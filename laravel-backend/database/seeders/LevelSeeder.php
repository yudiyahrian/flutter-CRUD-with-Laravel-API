<?php

namespace Database\Seeders;

use Carbon\Carbon;
use App\Models\Level;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;

class LevelSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Schema::disableForeignKeyConstraints();
        Level::truncate();
        Schema::enableForeignKeyConstraints();

        $data = [
            ['name' => 'admin'],
            ['name' => 'student'],
            ['name' => 'teacher'],
        ];

        foreach ($data as $item) {
                Level::insert([
                    'name' => $item['name'],
                    'created_at' => Carbon::now(),
                    'updated_at' => Carbon::now(),
                ]);
        }
    }
}
