package com.cupidconnect.cupidconnect.services;

import com.cupidconnect.cupidconnect.models.Role;

import java.util.List;

public interface IRoleService {
     Role createRole(Role role);
     Role getRoleById(Integer id);

     List<Role> getAllRoles();

     Role updateRole(Integer id,Role newRole);

     void deleteRole(Integer id);
}
