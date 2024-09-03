<?php

/**
 * Handle rendering of twig templates and markdown content
 */
function renderPage(string $template, ?string $markdownFile, array $data = []) {
    require_once 'vendor/autoload.php';

    // Initialize Twig
    $loader = new \Twig\Loader\FilesystemLoader('templates');
    $twig = new \Twig\Environment($loader, [
        'cache' => false, // or 'cache' => 'cache'
    ]);

    if ($markdownFile) {
        // Initialize Parsedown
        $parsedown = new Parsedown();

        // Load and parse the Markdown content
        $markdownContent = file_get_contents("content/$markdownFile.md");
        $htmlContent = $parsedown->text($markdownContent);
        $data["content"] = $htmlContent;
    }

    // Render the Twig template with the parsed Markdown content and opt data
    echo $twig->render("$template.html.twig", $data);
}
