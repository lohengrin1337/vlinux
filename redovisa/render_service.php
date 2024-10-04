<?php

/**
 * Handle rendering of twig templates and markdown content
 */
function renderPage(string $template, ?string $markdownFile, array $data = []) {
    require_once "vendor/autoload.php";

    // Initialize Twig
    $loader = new \Twig\Loader\FilesystemLoader(__DIR__ . "/templates");
    $twig = new \Twig\Environment($loader, [
        "cache" => "cache", // or "cache" => "false"
    ]);

    if ($markdownFile) {
        $markdownFilePath = __DIR__ . "/content/$markdownFile.md";

        if (file_exists($markdownFilePath)) {
            // Initialize Parsedown
            $parsedown = new Parsedown();

            // Load and parse the Markdown content, and add to $data
            $markdownContent = file_get_contents($markdownFilePath);
            $htmlContent = $parsedown->text($markdownContent);
            $data["content"] = $htmlContent;
        } else {
            echo "Markdown file not found: " . $markdownFilePath;
            return;
        }
    }

    // Render the Twig template with the parsed Markdown content and optional data
    echo $twig->render("$template.html.twig", $data);
}
