# Category Pages Generator Plugin
# 
# This plugin automatically generates category pages for articles during the Jekyll build.
# For each unique category found in articles, it creates a page at /articles/category/[category-slug]/
#
# Example: If articles have categories ["General", "Press Release"], it generates:
# - /articles/category/general/
# - /articles/category/press-release/

module Jekyll
  class CategoryPageGenerator < Generator
    safe true
    priority :low

    def generate(site)
      # Only proceed if we have articles
      unless site.collections.key?('articles')
        puts "CategoryPageGenerator: No 'articles' collection found"
        return
      end
      
      articles = site.collections['articles'].docs
      puts "CategoryPageGenerator: Found #{articles.size} articles"
      
      # Collect all unique categories from all articles
      categories = Set.new
      articles.each do |article|
        if article.data['categories']
          # Handle both array and string categories
          cats = article.data['categories']
          cats = [cats] unless cats.is_a?(Array)
          cats.each { |cat| categories.add(cat.to_s.strip) if cat }
        end
      end
      
      puts "CategoryPageGenerator: Found #{categories.size} unique categories: #{categories.to_a.join(', ')}"
      
      # Generate a page for each category
      categories.each do |category|
        puts "CategoryPageGenerator: Creating page for category '#{category}'"
        site.pages << CategoryPage.new(site, site.source, category)
      end
      
      puts "CategoryPageGenerator: Generated #{categories.size} category pages"
      
      # Generate archive pages by month/year
      archives = Hash.new(0)
      articles.each do |article|
        if article.data['date']
          date = article.data['date']
          year_month = date.strftime('%Y-%m')
          archives[year_month] += 1
        end
      end
      
      puts "CategoryPageGenerator: Found #{archives.size} archive periods"
      
      archives.each do |year_month, count|
        year, month = year_month.split('-')
        site.pages << ArchivePage.new(site, site.source, year, month)
        puts "CategoryPageGenerator: Creating archive page for #{year_month}"
      end
      
      puts "CategoryPageGenerator: Generated #{archives.size} archive pages"
    end
  end

  class ArchivePage < Page
    def initialize(site, base, year, month)
      @site = site
      @base = base
      
      # Set the directory and filename for this archive page
      @dir = File.join('articles', 'archive', year, month)
      @name = 'index.html'
      
      # Initialize the page
      self.process(@name)
      
      # Create readable month name
      month_names = ['', 'January', 'February', 'March', 'April', 'May', 'June',
                     'July', 'August', 'September', 'October', 'November', 'December']
      month_name = month_names[month.to_i]
      
      # Set page data
      self.data = {
        'layout' => 'archive',
        'title' => "#{month_name} #{year}",
        'year' => year,
        'month' => month,
        'month_name' => month_name,
        'is_archive_page' => true
      }
      
      # Set empty content (layout will handle it)
      self.content = ''
    end
  end

  class CategoryPage < Page
    def initialize(site, base, category)
      @site = site
      @base = base
      
      # Create URL-friendly slug from category name
      category_slug = category.downcase.gsub(/[^\w\s-]/, '').gsub(/[\s_]+/, '-')
      
      # Set the directory and filename for this category page
      @dir = File.join('articles', 'category', category_slug)
      @name = 'index.html'
      
      # Initialize the page
      self.process(@name)
      
      # Set page data first
      self.data = {
        'layout' => 'category',
        'title' => category,
        'category' => category,
        'category_slug' => category_slug,
        'is_category_page' => true
      }
      
      # Set empty content (layout will handle it)
      self.content = ''
    end
  end
end
