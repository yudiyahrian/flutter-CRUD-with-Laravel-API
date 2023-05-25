<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use App\Http\Resources\UserResource;
use Illuminate\Support\Facades\Validator;

class UserController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $users = User::with('level')->get();
        return UserResource::collection($users);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = Validator::make($request->all(), [
            'name' => 'required',
            'email' => 'required|email',
            'password' => 'required',
            'level_id' => 'required',
        ]);

        if($validated->fails()) {
            return response()->json($validated->errors(), 400);
        }

        $add_data = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => $request->password,
            'level_id' => $request->level_id,
        ]);

        if($request->hasFile('image')) {
            $add_data->addMedia($request->image)
            ->usingName(pathinfo($request->image->getClientOriginalName(), PATHINFO_FILENAME))
            ->toMediaCollection('profile-images');
        }

        if($add_data){
            return new UserResource($add_data);
        }

        return response()->json([
            'message' => 'failed to add',
        ], 409);

    }

    /**
     * Display the specified resource.
     */
    public function show(User $user)
    {
        return new UserResource($user);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, User $user)
    {
        $validated = Validator::make($request->all(), [
            'name' => 'required',
            'email' => 'required|email',
            'password' => 'required',
            'level_id' => 'required',
        ]);

        if($validated->fails()) {
            return response()->json($validated->errors(), 400);
        }

        $update = $user->update([
            'name' => $request->name,
            'email' => $request->email,
            'password' => $request->password,
            'level_id' => $request->level_id,
        ]);

        if($request->hasFile('image')) {
            $user->clearMediaCollection('profile-images');
            $user->addMedia($request->image)
            ->usingName(pathinfo($request->image->getClientOriginalName(), PATHINFO_FILENAME))
            ->toMediaCollection('profile-images');
        }

        if($update){
            return new UserResource($user->fresh());
        }

        return response()->json([
            'message' => 'failed to update',
        ], 409);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(User $user)
    {
        $user->delete();

        return response()->json([
            'name' => $user->name,
            'message' => 'User deleted successfully'
        ]);
    }
}
