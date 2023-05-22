import os

__version__ = "2.0.0"

REPO_LINK = "https://huggingface.co/crusher083/mDeepFRI/resolve/main"

MODEL_NAMES = [
    "DeepCNN-MERGED_bp.onnx",
    "DeepCNN-MERGED_cc.onnx",
    "DeepCNN-MERGED_mf.onnx",
    "DeepCNN-MERGED_ec.onnx",
    "DeepFRI-MERGED_GraphConv_gcd_512-512-512_fcd_1024_ca_10.0_bp.onnx",
    "DeepFRI-MERGED_GraphConv_gcd_512-512-512_fcd_1024_ca_10.0_cc.onnx",
    "DeepFRI-MERGED_GraphConv_gcd_512-512-512_fcd_1024_ca_10.0_ec.onnx",
    "DeepFRI-MERGED_GraphConv_gcd_512-512-512_fcd_1024_ca_10.0_mf.onnx",
]

MODEL_LINKS = [
    os.path.join(REPO_LINK, model_name) for model_name in MODEL_NAMES
]

CONFIG_NAMES = [
    "DeepCNN-MERGED_bp_model_params.json",
    "DeepCNN-MERGED_cc_model_params.json",
    "DeepCNN-MERGED_mf_model_params.json",
    "DeepCNN-MERGED_ec_model_params.json",
    "DeepFRI-MERGED_GraphConv_gcd_512-512-512_fcd_1024_ca_10.0_bp_model_params.json",
    "DeepFRI-MERGED_GraphConv_gcd_512-512-512_fcd_1024_ca_10.0_cc_model_params.json",
    "DeepFRI-MERGED_GraphConv_gcd_512-512-512_fcd_1024_ca_10.0_ec_model_params.json",
    "DeepFRI-MERGED_GraphConv_gcd_512-512-512_fcd_1024_ca_10.0_mf_model_params.json",
    "model_config.json"
]

CONFIG_LIST = [
    os.path.join(REPO_LINK, config_name) for config_name in CONFIG_NAMES
]

TARGET_MMSEQS_DB_NAME = "targetDB"
SEQUENCES = "seq"
ATOMS = "atom"
SEQ_ATOMS_DATASET_PATH = "seq_atom_db"

ALIGNMENTS = "alignments.json"
MERGED_SEQUENCES = 'merged_sequences.faa'
MMSEQS_SEARCH_RESULTS = 'mmseqs2_search_results.m8'
