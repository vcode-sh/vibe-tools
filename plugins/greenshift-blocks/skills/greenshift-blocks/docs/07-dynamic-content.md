# Dynamic Content

Dynamic blocks allow you to display content that changes based on post data, user information, site data, and more. Dynamic content is wrapped in `<dynamictext></dynamictext>` tags and configured through the `dynamictext` parameter.

---

## Basic Dynamic Block Structure

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-example","textContent":"<dynamictext>Hello world!</dynamictext>","dynamictext":{"dynamicEnable":true,"dynamicType":"postdata","dynamicSource":"latest_item","dynamicPostData":"post_title"},"localId":"gsbp-example"} -->
<div class="gsbp-example"><dynamictext>Hello world!</dynamictext></div>
<!-- /wp:greenshift-blocks/element -->
```

---

## Complete Dynamic Query Grid Example

```html
<!-- wp:greenshift-blocks/querygrid {"id":"gsbp-5ca4fa6", "data_source":"query","query_filters":{"post_type":"post"}, "displayStyle":"custom", "styleAttributesWrapper":{"display":["flex"],"columnGap":["var(--wp--preset--spacing--50, 1.5rem)"],"rowGap":["var(--wp--preset--spacing--50, 1.5rem)"],"flexWrap":["wrap"],"flexColumns_Extra":4,"flexWidths_Extra":{"desktop":{"name":"25/25/25/25","widths":[25,25,25,25]},"tablet":{"name":"50/50/50/50","widths":[50,50,50,50]},"mobile":{"name":"100/100/100/100","widths":[100,100,100,100]}}},"styleAttributesItem":{"borderBottomLeftRadius":["var(--wp--custom--border-radius--small, 10px)"],"borderBottomRightRadius":["var(--wp--custom--border-radius--small, 10px)"],"borderTopLeftRadius":["var(--wp--custom--border-radius--small, 10px)"],"borderTopRightRadius":["var(--wp--custom--border-radius--small, 10px)"],"borderRadiusCustom_Extra":false,"borderRadiusLink_Extra":true}} -->
<!-- wp:greenshift-blocks/element {"id":"gsbp-a6342f9","tag":"a","type":"inner","dynamiclink":{"dynamicEnable":true,"dynamicType":"postdata","dynamicSource":"latest_item","dynamicPostData":"permalink"},"localId":"gsbp-a6342f9"} -->
<a><!-- wp:greenshift-blocks/element {"id":"gsbp-7a5ed66","tag":"img","type":"inner","dynamiclink":{"dynamicEnable":true,"dynamicType":"postdata","dynamicSource":"latest_item","dynamicPostData":"post_image"},"localId":"gsbp-7a5ed66","styleAttributes":{"width":["100%"],"height":["180px"],"objectFit":["cover"],"borderBottomLeftRadius":["var(--wp--custom--border-radius--small, 10px)"],"borderBottomRightRadius":["var(--wp--custom--border-radius--small, 10px)"],"borderTopLeftRadius":["var(--wp--custom--border-radius--small, 10px)"],"borderTopRightRadius":["var(--wp--custom--border-radius--small, 10px)"],"borderRadiusCustom_Extra":false,"borderRadiusLink_Extra":true}} -->
<img class="gsbp-7a5ed66" loading="lazy"/>
<!-- /wp:greenshift-blocks/element --></a>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-10a3f57","textContent":"<dynamictext></dynamictext>","dynamictext":{"dynamicEnable":true,"dynamicType":"taxonomyvalue","dynamicSource":"latest_item","dynamicPostType":"post","dynamicPostId":0,"dynamicPostData":"post_title","dynamicTaxonomyValue":"category","dynamicTaxonomyLink":true,"dynamicTaxonomyDivider":", "},"localId":"gsbp-10a3f57","styleAttributes":{"fontSize":["var(--wp--preset--font-size--xs, 0.85rem)"],"lineHeight":["var(--wp--custom--line-height--xs, 1.15rem)"],"marginTop":["10px"],"opacity":["0.7"]},"isVariation":"divtext","metadata":{"name":"Taxonomy"}} -->
<div class="gsbp-10a3f57"><dynamictext></dynamictext></div>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-6410c04","tag":"a","type":"inner","dynamiclink":{"dynamicEnable":true,"dynamicType":"postdata","dynamicSource":"latest_item","dynamicPostData":"permalink"},"localId":"gsbp-6410c04","href":"<dynamictext></dynamictext>","styleAttributes":{"textDecoration":["none"]}} -->
<a class="gsbp-6410c04" href="<dynamictext></dynamictext>"><!-- wp:greenshift-blocks/element {"id":"gsbp-2acd12c","textContent":"<dynamictext>Hello world!</dynamictext>","dynamictext":{"dynamicEnable":true,"dynamicType":"postdata","dynamicSource":"latest_item","dynamicPostData":"post_title"},"localId":"gsbp-2acd12c","styleAttributes":{"fontSize":["var(--wp--preset--font-size--r, 1.2rem)"],"fontWeight":["600"],"lineHeight":["1.4em"],"marginTop":["8px"],"marginBottom":["0px"]},"isVariation":"divtext","metadata":{"name":"Post Title"}} -->
<div class="gsbp-2acd12c"><dynamictext>Hello world!</dynamictext></div>
<!-- /wp:greenshift-blocks/element --></a>
<!-- /wp:greenshift-blocks/element -->

<!-- wp:greenshift-blocks/element {"id":"gsbp-d0e8cf8","textContent":"<dynamictext>September 28, 2025</dynamictext>","tag":"span","dynamictext":{"dynamicEnable":true,"dynamicType":"postdata","dynamicSource":"latest_item","dynamicPostData":"post_modified"},"localId":"gsbp-d0e8cf8","styleAttributes":{"fontSize":["var(--wp--preset--font-size--xs, 0.85rem)"],"lineHeight":["var(--wp--custom--line-height--xs, 1.15rem)"],"opacity":[0.5]}} -->
<span class="gsbp-d0e8cf8"><dynamictext>September 28, 2025</dynamictext></span>
<!-- /wp:greenshift-blocks/element -->
<!-- /wp:greenshift-blocks/querygrid -->
```

---

## Query Loop Configuration

For arguments, use the same as available in WP Query as json in query_filters. For wrapper styles, use styleAttributesWrapper and for item style use styleAttributesItem. These attributes accept the same parameters as styleAttributes in greenshift-blocks/element block.

### Query Parameters (`query_filters`)

Uses WP_Query arguments as JSON:

```json
{
  "query_filters": {
    "post_type": "post",
    "posts_per_page": 6,
    "orderby": "date",
    "order": "DESC",
    "category_name": "news"
  }
}
```

### Wrapper & Item Styles

- `styleAttributesWrapper` - Container styles (flexbox grid)
- `styleAttributesItem` - Individual item styles

---

## Dynamic Text Configuration (`dynamictext`)

The `dynamictext` parameter contains all dynamic content configuration:

### Core Parameters

-   **`dynamicEnable: true`**: Enables dynamic content functionality
-   **`dynamicType`**: Type of dynamic content (see options below)
-   **`dynamicSource`**: Source selection - `"latest_item"` or `"definite_item"`
-   **`dynamicPostType`**: Post type to query (optional, uses current if empty)
-   **`dynamicPostId`**: Specific post ID (for definite_item source)

---

## Available Dynamic Types

### 1. Post Data (`dynamicType: "postdata"`)

```json
{
  "dynamictext": {
    "dynamicEnable": true,
    "dynamicType": "postdata",
    "dynamicSource": "latest_item",
    "dynamicPostData": "post_title"
  }
}
```

**Available `dynamicPostData` options:**

| Value | Description |
|-------|-------------|
| `post_title` | Post title |
| `post_image` | Featured image |
| `ID` | Post ID |
| `post_date` | Publish date |
| `post_modified` | Last modified date |
| `post_excerpt` | Post excerpt |
| `comment_count` | Number of comments |
| `permalink` | Post URL |
| `fullcontent` | Full content without formatting |
| `fullcontentfilters` | Formatted content |
| `post_author` | Author name |
| `post_name` | Post slug |
| `post_parent_title` | Parent post title |
| `post_parent_link` | Parent post link |

---

### 2. Author Data (`dynamicType: "authordata"`)

```json
{
  "dynamictext": {
    "dynamicEnable": true,
    "dynamicType": "authordata",
    "dynamicAuthorData": "display_name"
  }
}
```

**Available `dynamicAuthorData` options:**

| Value | Description |
|-------|-------------|
| `display_name` | Author display name |
| `description` | Author bio |
| `user_level` | User level |
| `user_registered` | Registration date |
| `user_email` | Author email |
| `user_login` | Username |
| `user_url` | Author website |
| `user_avatar_url` | Avatar image URL |
| `user_status` | User status |
| `ID` | Author ID |
| `meta` | Custom author meta (requires `dynamicAuthorField`) |

---

### 3. Current User Data (`dynamicType: "user_data"`)

Same options as Author Data but for currently logged-in user.

---

### 4. Taxonomy Value (`dynamicType: "taxonomyvalue"`)

```json
{
  "dynamictext": {
    "dynamicEnable": true,
    "dynamicType": "taxonomyvalue",
    "dynamicTaxonomyValue": "category",
    "dynamicTaxonomyLink": true,
    "dynamicTaxonomyDivider": ", "
  }
}
```

**Parameters:**

-   **`dynamicTaxonomyValue`**: Taxonomy name (e.g., `"category"`, `"post_tag"`)
-   **`dynamicTaxonomyLink: true`**: Show taxonomy terms as links
-   **`dynamicTaxonomyDivider`**: Separator between terms (e.g., `", "`)

---

### 5. Custom Meta Field (`dynamicType: "custom"`)

```json
{
  "dynamictext": {
    "dynamicEnable": true,
    "dynamicType": "custom",
    "dynamicField": "my_custom_field"
  }
}
```

**Parameters:**

-   **`dynamicField`**: Custom field name or meta key

---

### 6. Taxonomy Meta (`dynamicType: "taxonomy"`)

```json
{
  "dynamictext": {
    "dynamicEnable": true,
    "dynamicType": "taxonomy",
    "dynamicTaxonomy": "category",
    "dynamicTaxonomyField": "field_name",
    "dynamicTaxonomyType": "name"
  }
}
```

**Parameters:**

-   **`dynamicTaxonomy`**: Taxonomy name
-   **`dynamicTaxonomyField`**: Field to retrieve from taxonomy
-   **`dynamicTaxonomyType`**: Data type (`"name"`, `"description"`, or meta)

---

### 7. Site Data (`dynamicType: "sitedata"`)

```json
{
  "dynamictext": {
    "dynamicEnable": true,
    "dynamicType": "sitedata",
    "dynamicSiteData": "name"
  }
}
```

**Available `dynamicSiteData` options:**

| Value | Description |
|-------|-------------|
| `siteoption` | WordPress option |
| `acfsiteoption` | ACF site option |
| `name` | Site name |
| `description` | Site description |
| `year` | Current year |
| `month` | Current month |
| `today` | Today's date |
| `todayplus1` | Tomorrow |
| `todayplus2` | Day after tomorrow |
| `todayplus3` | 3 days from now |
| `todayplus7` | 1 week from now |
| `querystring` | URL query parameter |
| `transient` | WordPress transient |

---

### 8. Repeater (`dynamicType: "repeater"`)

```json
{
  "dynamictext": {
    "dynamicEnable": true,
    "dynamicType": "repeater",
    "repeaterField": "my_repeater_field"
  }
}
```

**Parameters:**

-   **`repeaterField`**: Repeater field name
-   Works within repeater contexts

---

## Dynamic Link Configuration (`dynamiclink`)

dynamiclink attribute supports the same options as dynamictext. Use dynamiclink for link element and images, video elements.

### Dynamic Link for Anchor Tags

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-link01","tag":"a","type":"inner","dynamiclink":{"dynamicEnable":true,"dynamicType":"postdata","dynamicSource":"latest_item","dynamicPostData":"permalink"},"localId":"gsbp-link01"} -->
<a>Link content</a>
<!-- /wp:greenshift-blocks/element -->
```

### Dynamic Link for Images

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-img01","tag":"img","dynamiclink":{"dynamicEnable":true,"dynamicType":"postdata","dynamicSource":"latest_item","dynamicPostData":"post_image"},"localId":"gsbp-img01"} -->
<img class="gsbp-img01" loading="lazy"/>
<!-- /wp:greenshift-blocks/element -->
```

---

## Dynamic Placeholders

Dynamic placeholders can be used in query arguments and text content.

### Basic Placeholders

| Placeholder | Description |
|-------------|-------------|
| `{{POST_ID}}` | Current post ID |
| `{{POST_TITLE}}` | Current post title |
| `{{POST_URL}}` | Current post URL |
| `{{AUTHOR_ID}}` | Post author ID |
| `{{AUTHOR_NAME}}` | Post author name |
| `{{CURRENT_USER_ID}}` | Logged-in user ID |
| `{{CURRENT_USER_NAME}}` | Logged-in user name |
| `{{CURRENT_OBJECT_ID}}` | Current object ID |
| `{{CURRENT_OBJECT_NAME}}` | Current object name |
| `{{CURRENT_DATE_YMD}}` | Current date (YYYY-MM-DD) |
| `{{CURRENT_DATE_YMD_HMS}}` | Current date and time |
| `{{SITE_URL}}` | Site URL |

### Advanced Placeholders

| Placeholder | Description |
|-------------|-------------|
| `{{TIMESTRING:today+10days}}` | Date calculations |
| `{{GET:get_name}}` | URL GET parameters |
| `{{SETTING:option_name}}` | WordPress options |
| `{{META:meta_key}}` | Post meta |
| `{{TERM_META:meta_key}}` | Taxonomy term meta |
| `{{TERM_LINKS:taxonomy}}` | List of links for a post's terms |
| `{{USER_META:meta_key}}` | User meta |
| `{{COOKIE:cookie_name}}` | Cookie values |
| `{{RANDOM:0-100}}` | Random numbers |
| `{{RANDOM:red\|blue\|green}}` | Random selection |

---

## Data Formatting (`postprocessor`)

This is used for further processing returned data.

```json
{
  "dynamictext": {
    "dynamicEnable": true,
    "dynamicType": "postdata",
    "dynamicPostData": "post_date",
    "postprocessor": "datecustom",
    "dateformat": "F j, Y"
  }
}
```

### Available Formatting Options

| Value | Description |
|-------|-------------|
| `textformat` | Use if returned data has WYSIWYG formatting |
| `mailto` | Email links |
| `tel` | Convert to Phone links |
| `postlink` | Post links |
| `idtofile` | Convert ID of file to file link |
| `idtofileurl` | Convert ID of file to file URL |
| `idtoimageurl` | ID to image URL (full size) |
| `idtoimageurlthumb` | ID to image URL (thumbnail) |
| `ymd` | Date YYYYMMDD to WordPress date |
| `ytmd` | Date yyyy-mm-dd to WordPress date |
| `unixtowp` | Unix time to WordPress date |
| `ymdhis` | Date Y-m-d H:i:s to WordPress date |
| `ymdtodiff` | Date difference with current |
| `datecustom` | Custom date format (requires `dateformat`) |
| `numberformat` | Number formatting |
| `numberformatenglish` | English number formatting |
| `numeric` | Only numeric values |
| `json` | Array to JSON |

---

## Additional Parameters

| Parameter | Description |
|-----------|-------------|
| `fallbackValue` | Fallback text when no data is found |
| `avatarSize` | Avatar size for user avatars |
| `dynamicPostImageSize` | Image size for post images |
| `dateformat` | Custom date format string |

---

## Complete Example: Post Card

```html
<!-- wp:greenshift-blocks/element {"id":"gsbp-card01","tag":"a","type":"inner","dynamiclink":{"dynamicEnable":true,"dynamicType":"postdata","dynamicSource":"latest_item","dynamicPostData":"permalink"},"localId":"gsbp-card01","styleAttributes":{"display":["block"],"textDecoration":["none"]}} -->
<a class="gsbp-card01">
  <!-- Featured Image -->
  <!-- wp:greenshift-blocks/element {"id":"gsbp-card02","tag":"img","dynamiclink":{"dynamicEnable":true,"dynamicType":"postdata","dynamicSource":"latest_item","dynamicPostData":"post_image"},"localId":"gsbp-card02","styleAttributes":{"width":["100%"],"aspectRatio":["16/9"],"objectFit":["cover"]}} -->
  <img class="gsbp-card02" loading="lazy"/>
  <!-- /wp:greenshift-blocks/element -->

  <!-- Category -->
  <!-- wp:greenshift-blocks/element {"id":"gsbp-card03","textContent":"<dynamictext></dynamictext>","dynamictext":{"dynamicEnable":true,"dynamicType":"taxonomyvalue","dynamicTaxonomyValue":"category"},"localId":"gsbp-card03","styleAttributes":{"fontSize":["var(--wp--preset--font-size--xs)"],"marginTop":["1rem"]}} -->
  <div class="gsbp-card03"><dynamictext></dynamictext></div>
  <!-- /wp:greenshift-blocks/element -->

  <!-- Title -->
  <!-- wp:greenshift-blocks/element {"id":"gsbp-card04","textContent":"<dynamictext>Post Title</dynamictext>","tag":"h3","dynamictext":{"dynamicEnable":true,"dynamicType":"postdata","dynamicPostData":"post_title"},"localId":"gsbp-card04","styleAttributes":{"fontSize":["var(--wp--preset--font-size--l)"],"marginTop":["0.5rem"]}} -->
  <h3 class="gsbp-card04"><dynamictext>Post Title</dynamictext></h3>
  <!-- /wp:greenshift-blocks/element -->
</a>
<!-- /wp:greenshift-blocks/element -->
```
