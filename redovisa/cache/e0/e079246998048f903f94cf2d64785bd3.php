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

/* report.html.twig */
class __TwigTemplate_5724b3b0de334c496160c76a09d7f7ed extends Template
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

        $this->blocks = [
            'main' => [$this, 'block_main'],
        ];
    }

    protected function doGetParent(array $context): bool|string|Template|TemplateWrapper
    {
        // line 1
        return "base.html.twig";
    }

    protected function doDisplay(array $context, array $blocks = [])
    {
        $macros = $this->macros;
        $this->parent = $this->loadTemplate("base.html.twig", "report.html.twig", 1);
        yield from $this->parent->unwrap()->yield($context, array_merge($this->blocks, $blocks));
    }

    // line 3
    public function block_main($context, array $blocks = [])
    {
        $macros = $this->macros;
        // line 4
        yield "    <h1>";
        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["pageTitle"] ?? null), "html", null, true);
        yield "</h1>

    <nav class=\"small-nav\">
        <ul>
            <li><a href=\"#kmom01\">kmom01</a></li>
            <li><a href=\"#kmom02\">kmom02</a></li>
            <li><a href=\"#kmom03\">kmom03</a></li>
            <li><a href=\"#kmom04\">kmom04</a></li>
            <li><a href=\"#kmom05\">kmom05</a></li>
            <li><a href=\"#kmom06\">kmom06</a></li>
            <li><a href=\"#kmom10\">kmom10</a></li>
        </ul>
    </nav>
    
    <article>
        ";
        // line 19
        yield ($context["content"] ?? null);
        yield "
    </article>
";
        return; yield '';
    }

    /**
     * @codeCoverageIgnore
     */
    public function getTemplateName(): string
    {
        return "report.html.twig";
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
        return array (  74 => 19,  55 => 4,  51 => 3,  40 => 1,);
    }

    public function getSourceContext(): Source
    {
        return new Source("", "report.html.twig", "/home/lohengrin/dbwebb-kurser/vlinux/me/redovisa/templates/report.html.twig");
    }
}
