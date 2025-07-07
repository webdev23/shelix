#!/usr/bin/php
<?php

/* TOML parser */

function parseSimpleToml(string $toml): array {
    $result = [];
    $currentSection = '';
    $lines = explode("\n", trim($toml));

    foreach ($lines as $line) {
        $line = trim($line);
        if ($line === '' || str_starts_with($line, '#')) continue; // Skip empty lines/comments

        // Detect section headers (e.g., [database])
        if (preg_match('/^\[(.*)\]$/', $line, $matches)) {
            $currentSection = $matches[1];
            $result[$currentSection] = [];
            continue;
        }

        // Split key-value pairs (e.g., "enabled = true")
        [$key, $valueStr] = array_map('trim', explode('=', $line, 2));

        // Convert TOML value to PHP type
        $value = match (true) {
            // Booleans
            $valueStr === 'true' => true,
            $valueStr === 'false' => false,
            // Inline tables (e.g., { cpu = 79.5 })
            str_starts_with($valueStr, '{') => parseInlineTable($valueStr),
            // Arrays (e.g., [8000, 8001] or [["delta", "phi"]])
            str_starts_with($valueStr, '[') => parseArray($valueStr),
            // Numbers (integers/floats)
            is_numeric($valueStr) => $valueStr + 0, // Convert to int/float
            // Strings (assume quoted, e.g., "delta")
            default => trim($valueStr, '"\'') // Remove quotes
        };

        $result[$currentSection][$key] = $value;
    }

    return $result;
}

// Helper: Parse inline tables (e.g., { cpu = 79.5, case = 72.0 })
function parseInlineTable(string $str): array {
    $str = trim($str, '{}');
    $pairs = explode(',', $str);
    $table = [];
    foreach ($pairs as $pair) {
        [$k, $v] = array_map('trim', explode('=', $pair, 2));
        $table[$k] = is_numeric($v) ? $v + 0 : trim($v, '"\'');
    }
    return $table;
}

// Helper: Parse arrays (supports nested arrays)
function parseArray(string $str): array {
    $str = trim($str, '[]');
    $elements = [];
    $depth = 0;
    $current = '';

    // Handle nested arrays by tracking bracket depth
    for ($i = 0; $i < strlen($str); $i++) {
        $char = $str[$i];
        if ($char === '[' || $char === '{') $depth++;
        if ($char === ']' || $char === '}') $depth--;
        if ($char === ',' && $depth === 0) {
            $elements[] = trim($current);
            $current = '';
            continue;
        }
        $current .= $char;
    }
    $elements[] = trim($current);

    // Convert elements to PHP types
    return array_map(function($el) {
        if ($el === '') return null;
        if (str_starts_with($el, '[')) return parseArray($el);
        if (str_starts_with($el, '{')) return parseInlineTable($el);
        if ($el === 'true') return true;
        if ($el === 'false') return false;
        if (is_numeric($el)) return $el + 0;
        return trim($el, '"\'');
    }, $elements);
}

// Example usage
$toml = <<<TOML
[database]
enabled = true
ports = [ 8000, 8001, 8002 ]
data = [ ["delta", "phi"], [3.14] ]
temp_targets = { cpu = 79.5, case = 72.0 }
TOML;

// $parsed = parseSimpleToml($toml);
$parsed = parseSimpleToml(file_get_contents($argv[1]));
echo json_encode($parsed, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);
