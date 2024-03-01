package com.cupidconnect.cupidconnect.services;


import com.cupidconnect.cupidconnect.models.Role;
import com.cupidconnect.cupidconnect.repositories.RoleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class RoleService implements IRoleService{
    private final RoleRepository roleRepository;

    @Override
    public Role createRole(Role role) {
        return roleRepository.save(role);
    }

    @Override
    public Role getRoleById(long id) {
        return roleRepository.findById(id).orElseThrow(()-> new RuntimeException("Role not found"));
    }

    @Override
    public List<Role> getAllRoles() {
        return roleRepository.findAll();
    }

    @Override
    public Role updateRole(long id, Role newRole) {
        return null;
    }

    @Override
    public void deleteRole(long id) {

    }
}
