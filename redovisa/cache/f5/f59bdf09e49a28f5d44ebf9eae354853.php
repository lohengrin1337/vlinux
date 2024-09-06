<?php

use Twig\Environment;
use Twig\Error\LoaderError;
use Twig\Error\RuntimeError;
use Twig\Extension\CoreExtension;
use Twig\Extension\SandboxExtension;
use Twig\Markup;
use Twig\Sandbox\SecurityError;
use Twig\Sandbox\SecurityNotAllowedTagError;
use Twig\Sandbox\SecurityNotAllowedFilterError;
use Twig\Sandbox\SecurityNotAllowedFunctionError;
use Twig\Source;
use Twig\Template;
use Twig\TemplateWrapper;

/* base.html.twig */
class __TwigTemplate_29c64a957f2d06b6d0ced3ae27db9aff extends Template
{
    private Source $source;
    /**
     * @var array<string, Template>
     */
    private array $macros = [];

    public function __construct(Environment $env)
    {
        parent::__construct($env);

        $this->source = $this->getSourceContext();

        $this->parent = false;

        $this->blocks = [
            'main' => [$this, 'block_main'],
        ];
    }

    protected function doDisplay(array $context, array $blocks = [])
    {
        $macros = $this->macros;
        // line 1
        yield "<!DOCTYPE html>
<html lang=\"sv\">
<head>
    <meta charset=\"UTF-8\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
    <title>";
        // line 6
        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["pageTitle"] ?? null), "html", null, true);
        yield " | ";
        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["siteTitle"] ?? null), "html", null, true);
        yield "</title>

    <link rel=\"preconnect\" href=\"https://fonts.googleapis.com\">
    <link rel=\"preconnect\" href=\"https://fonts.gstatic.com\" crossorigin>
    <link href=\"https://fonts.googleapis.com/css2?family=Josefin+Slab:ital,wght@0,100..700;1,100..700&display=swap\" rel=\"stylesheet\">

    <link rel=\"stylesheet\" href=\"style/style.css\">
</head>
<body>
    <header>
        <a href=\"index.php\"><span class=\"site-title\">";
        // line 16
        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["siteTitle"] ?? null), "html", null, true);
        yield "</span></a>
        <nav>
            <ul>
                <li><a href=\"index.php\">Om</a></li>
                <li><a href=\"report.php\">Redovisning</a></li>
            </ul>
        </nav>
    </header>
    
    <main>
        ";
        // line 26
        yield from $this->unwrap()->yieldBlock('main', $context, $blocks);
        // line 27
        yield "    </main>

    <footer>
        <p>&copy; 2024 Olof Jönsson - oljn22</p>
    </footer>
</body>
</html>
";
        return; yield '';
    }

    // line 26
    public function block_main($context, array $blocks = [])
    {
        $macros = $this->macros;
        return; yield '';
    }

    /**
     * @codeCoverageIgnore
     */
    public function getTemplateName(): string
    {
        return "base.html.twig";
    }

    /**
     * @codeCoverageIgnore
     */
    public function isTraitable(): bool
    {
        return false;
    }

    /**
     * @codeCoverageIgnore
     */
    public function getDebugInfo(): array
    {
        return array (  92 => 26,  80 => 27,  78 => 26,  65 => 16,  50 => 6,  43 => 1,);
    }

    public function getSourceContext(): Source
    {
        return new Source("", "base.html.twig", "/home/lohengrin/dbwebb-kurser/vlinux/me/redovisa/templates/base.html.twig");
    }
}
