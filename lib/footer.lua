
-- Footer Generator für Slides
-- Global YAML Defaults + Pro-Slide Overrides

local footer_date = "15.06.2026"
local footer_center_text = ""
local total_slides = 0

-- Extrahiere globale YAML Metadaten
function Meta(m)
    if m["footer-date"] then
        footer_date = pandoc.utils.stringify(m["footer-date"])
    end
    if m["footer-center-text"] then
        footer_center_text = pandoc.utils.stringify(m["footer-center-text"])
    end
end

-- Zähle Content-Slides
function count_slides(blocks)
    local count = 0
    for _, block in ipairs(blocks) do
        if block.t == "Div" and block.classes:includes("slide") and block.classes:includes("content") then
            count = count + 1
        end
    end
    return count
end

-- Generiere Footer Div
function create_footer_div(current_slide, total, date, center_text)
    local footer_html = pandoc.RawBlock(
        "html",
        '<div class="footer-content">\n' ..
        '  <div class="footer-cell left">' .. date .. '</div>\n' ..
        '  <div class="footer-cell center">' .. center_text .. '</div>\n' ..
        '  <div class="footer-cell right">' .. current_slide .. ' / ' .. total .. '</div>\n' ..
        '</div>'
    )
    return footer_html
end

-- Hauptlogik
function Pandoc(doc)
    -- Zähle Slides
    total_slides = count_slides(doc.blocks)
    
    local new_blocks = {}
    local content_counter = 0
    
    for _, block in ipairs(doc.blocks) do
        if block.t == "Div" and block.classes:includes("slide") and block.classes:includes("content") then
            content_counter = content_counter + 1
            
            -- Prüfe Div-Attribute für Overrides
            local slide_date = footer_date
            local slide_center_text = footer_center_text
            
            if block.attributes["footer-date"] then
                slide_date = block.attributes["footer-date"]
            end
            
            if block.attributes["footer-center-text"] then
                slide_center_text = block.attributes["footer-center-text"]
            end
            
            table.insert(new_blocks, block)
            table.insert(new_blocks, create_footer_div(content_counter, total_slides, slide_date, slide_center_text))
        else
            table.insert(new_blocks, block)
        end
    end
    
    return pandoc.Pandoc(new_blocks, doc.meta)
end
