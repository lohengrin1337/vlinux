<?php

require_once 'vendor/autoload.php';

use Twig\Environment;
use Twig\Loader\FilesystemLoader;
use Parsedown;

/**
 * Handle rendering of twig templates and markdown content
 */
class RenderService
{
    /**
     * Render a page
     */
    public static function render(string $template, ?string $markdownFile, array $data = []) {
        // Initialize Twig
        $loader = new FilesystemLoader('templates');
        $twig = new Environment($loader, [
            'cache' => false, // or 'cache' => 'cache'
        ]);

        if ($markdownFile) {
            // Initialize Parsedown
            $parsedown = new Parsedown();

            // Load and parse the Markdown content
            $markdownContent = file_get_contents("../content/$markdownFile.md");
            $htmlContent = $parsedown->text($markdownContent);
            $data["content"] = $htmlContent;
        }

        // Render the Twig template with the parsed Markdown content
        echo $twig->render("$template.html.twig", $data);
    }
}
