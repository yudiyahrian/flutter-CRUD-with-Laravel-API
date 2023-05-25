<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UserResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $data = [
            'id' => $this->id,
            'name' => $this->name,
            'email' => $this->email,
            'password' => $this->when($request->user()->level_id == 1 , $this->password),
            'level_id' => $this->level_id,
            // 'level' => $this->when($request->user()->level_id == 1 , $this->level->name),
        ];

        if ($this->hasMedia('profile-images')) {
            $media = $this->getFirstMedia('profile-images');
            $data['image'] = $media->getFullUrl();
        }

        return $data;
    }
}
