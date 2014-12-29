# UserAngetMapping.xml settings

Tatami separates User Agent settings from test case CSV. If you want to set User-Agent in test case, you need to create UserAngetMapping.xml and assign key name into test case CSV.    

Sample file : spec\sample_implementation\settings\UserAgentMapping.xml

```
<UserAgentMapping>
  <Item Key="IE11">Mozilla/5.0 (Windows NT 6.3; Win64, x64; Trident/7.0; Touch; rv:11.0)</Item>
  <Item Key="iPhone">Mozilla/5.0 (iPhone; CPU iPhone OS 7_0 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11A465 Safari/9537.53</Item>
</UserAgentMapping>
```
