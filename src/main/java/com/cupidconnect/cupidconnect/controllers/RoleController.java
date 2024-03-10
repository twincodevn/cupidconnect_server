package com.cupidconnect.cupidconnect.controllers;


import com.cupidconnect.cupidconnect.services.impl.RoleService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping ("${api.prefix}/role")
@RequiredArgsConstructor
public class RoleController {
    private final RoleService roleService;
    @GetMapping
    public ResponseEntity<?> getAllRoles(
            @RequestParam("page") int page,
            @RequestParam("limit") int limit
    ){
        return ResponseEntity.ok(roleService.getAllRoles());
    }
}
