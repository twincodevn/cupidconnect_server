package com.cupidconnect.cupidconnect.services.impl;


import com.cupidconnect.cupidconnect.models.Role;
import com.cupidconnect.cupidconnect.repositories.RoleRepository;
import com.cupidconnect.cupidconnect.services.IRoleService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class RoleService implements IRoleService {
    private final RoleRepository roleRepository;

    @Override
    public Role createRole(Role role) {
        return roleRepository.save(role);
    }

    @Override
    public Role getRoleById(Integer id) {
        return roleRepository.findById(id).orElseThrow(()-> new RuntimeException("Role not found"));
    }

    @Override
    public List<Role> getAllRoles() {
        return roleRepository.findAll();
    }

    @Override
    public Role updateRole(Integer id, Role newRole) {
        return null;
    }

    @Override
    public void deleteRole(Integer id) {

    }
}
