#!/usr/bin/env bash
DATA_IN=../boxscore-data/scripts/new_dataset/new_ws2017
IDENTIFIER=new-roto-v1
#IDENTIFIER=new-roto-v2

DATA_OUT=data/$IDENTIFIER/$IDENTIFIER
PTR=data/$IDENTIFIER/$IDENTIFIER-ptrs.txt
SAVE_OUT=models/$IDENTIFIER/$IDENTIFIER
SUMM_OUT=outputs/$IDENTIFIER/$IDENTIFIER

mkdir -p data/$IDENTIFIER
mkdir -p models/$IDENTIFIER
mkdir -p outputs/$IDENTIFIER


if [ $1 = "train" ]; then

	echo -e "\n *** making pointers from $DATA_IN saving to $PTR"
	ls -l $DATA_IN
	ls -l $PTR
#	python data_utils.py -mode ptrs -input_path $DATA_IN/train.json -output_fi $PTR

	echo -e "\n *** preprocess from $DATA_IN and $PTR"
	ls -l $DATA_IN
	ls -l $PTR
#	th box_preprocess.lua -json_data_dir $DATA_IN -save_data $DATA_OUT -ptr_fi $PTR

	echo -e "\n *** train from $DATA_OUT-train.t7 and saving model to $SAVE_OUT"
	ls -l $DATA_OUT-train.t7
	ls -l $SAVE_OUT
#	th box_train.lua -data $DATA_OUT-train.t7 -save_model $SAVE_OUT -rnn_size 600 -word_vec_size 600 -enc_emb_size 600 -max_batch_size 16 -dropout 0.5 -feat_merge concat -pool mean -enc_layers 1 -enc_relu -report_every 50 -gpuid 1 -epochs 100 -learning_rate 1 -enc_dropout 0 -decay_update2 -layers 2 -copy_generate -tanh_query -max_bptt 100 -switch -multilabel -seed 0

elif [ $1 = "test" ]; then
	for EPOCH in $(seq 1 35)
	do

	   for MODEL in $(ls $SAVE_OUT\_epoch$EPOCH\_*)
	   do
#	       echo  -e "\n *** Testing using $MODEL"
#	       ls -l $MODEL
#	       echo  -e "\n *** Reading data from $DATA_OUT-train.t7"
#	       ls -l $DATA_OUT-train.t7
#	       echo  -e "\n *** Saving --valid-- output to $SUMM_OUT-beam5_gens.valid.$EPOCH.txt"
#	       th box_train.lua -data $DATA_OUT-train.t7 -save_model $SAVE_OUT -rnn_size 600 -word_vec_size 600 -enc_emb_size 600 -max_batch_size 16 -dropout 0.5 -feat_merge concat -pool mean -enc_layers 1 -enc_relu -report_every 50 -gpuid 1 -epochs 100 -learning_rate 1 -enc_dropout 0 -decay_update2 -layers 2 -copy_generate -tanh_query -max_bptt 100 -switch -multilabel -train_from $MODEL -just_gen -beam_size 5 -gen_file $SUMM_OUT-beam5_gens.valid.$EPOCH.txt

	       wc $SUMM_OUT-beam5_gens.valid.$EPOCH.txt

           echo  -e "\n *** Evaluating BLEU for $SUMM_OUT-beam5_gens.valid.$EPOCH.txt"
           perl ~/onmt-tf-whm/third_party/multi-bleu.perl ../boxscore-data/scripts/new_dataset/new_extend/valid/tgt_valid.norm.filter.tk.trim.txt < $SUMM_OUT-beam5_gens.valid.$EPOCH.txt

#	       echo  -e "\n *** Saving --test-- output to $SUMM_OUT-beam5_gens.test.$EPOCH.txt"
#	       th box_train.lua -data $DATA_OUT-train.t7 -save_model $SAVE_OUT -rnn_size 600 -word_vec_size 600 -enc_emb_size 600 -max_batch_size 16 -dropout 0.5 -feat_merge concat -pool mean -enc_layers 1 -enc_relu -report_every 50 -gpuid 1 -epochs 100 -learning_rate 1 -enc_dropout 0 -decay_update2 -layers 2 -copy_generate -tanh_query -max_bptt 100 -switch -multilabel -train_from $MODEL -just_gen -beam_size 5 -gen_file $SUMM_OUT-beam5_gens.test.$EPOCH.txt -test

	       wc $SUMM_OUT-beam5_gens.test.$EPOCH.txt
           echo  -e "\n *** Evaluating BLEU for $SUMM_OUT-beam5_gens.test.$EPOCH.txt"
	       perl ~/onmt-tf-whm/third_party/multi-bleu.perl ../boxscore-data/scripts/new_dataset/new_extend/test/tgt_test.norm.filter.tk.trim.txt < $SUMM_OUT-beam5_gens.test.$EPOCH.txt

	   done

	done
else
    echo "please give train / test"
fi
