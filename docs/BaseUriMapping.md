# BaseUriMapping.xml settings

When you execute smoke test, you need to set Base URIs of test target each environment.
Tatami separates Base URIs settings from test case CSV. You need to create BaseUriMapping.xml and assign key name into test case CSV.    

Sample file : spec\sample_implementation\settings\BaseUriMapping_Wikipedia.xml
```
<BaseUriMapping>
  <Item Key="en-US">http://en.wikipedia.org</Item>
  <Item Key="ja-JP">http://ja.wikipedia.org</Item>
</BaseUriMapping>
```

