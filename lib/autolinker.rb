# frozen_string_literal: true

class Autolinker
  def self.auto_link(html, mode = :urls, link_attr = nil, &)
    link_attr ||= {
      :rel => "nofollow noopener noreferrer",
      :dir => "auto"
    }

    t0 = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    auto_link_with_rinku(html, mode, link_attr, &).tap do
    # auto_link_with_auto_link(html, mode, link_attr, &).tap do
      t1 = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      $t_total += (t1 - t0)
    end
  end

  def self.auto_link_with_auto_link(html, mode, link_attr, &)
    options = {
      :html => link_attr,
      :link => mode,
      :sanitize => false
    }
    ActionController::Base.helpers.auto_link(html, options, &)
  end

  def self.auto_link_with_rinku(html, mode = :urls, link_attr, &)
    Rinku.auto_link(html, mode, hash_to_attrs(link_attr), &)
  end

  def self.hash_to_attrs(hsh)
    hsh.map { |(k, v)| %(#{k}="#{v}") }.join(" ")
  end
end
