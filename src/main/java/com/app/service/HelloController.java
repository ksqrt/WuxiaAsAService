package com.app.service;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.OffsetDateTime;

@RestController
public class HelloController {

  @GetMapping("/api/hello")
  public String hello() {
    return "hello from  : " + OffsetDateTime.now();
  }
}
