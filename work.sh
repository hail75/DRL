apt install libgl1

GAMMAS=(0.5 1 2 3 4)
ALPHAS=(1)
CONFIG_TEMPLATE="cf.py"

for alpha in "${ALPHAS[@]}"; do
    for gamma in "${GAMMAS[@]}"; do
        name="g${gamma}a${alpha}"
        temp_config="${name}_config.py"
        cp "$CONFIG_TEMPLATE" "$temp_config"
        

        sed -i "s|gamma=9999,|gamma=${gamma},|g" "$temp_config"
        sed -i "s|alpha=8888,|alpha=${alpha},|g" "$temp_config"
        
        echo "--- Starting run for config: $temp_config (Name: $name) ---"

        gpu_ids=0
        python train.py --config "$temp_config" --name "$name" --gpu_ids "$gpu_ids"
        
        cd "checkpoints/$name"
        test_config="${name}_test_config.py"
        cp "../../$temp_config" "$test_config"
        
        echo "Running test on $test_config"
        python test_meter.py --config "$test_config"

        cd ../..
        rm "$temp_config"
        rm "checkpoints/$name/$test_config"

        echo "--- Finished run for config: $name ---"
        echo ""

    done
done
