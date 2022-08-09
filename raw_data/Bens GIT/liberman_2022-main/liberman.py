from sputils.spbars import SPBars

# spb = SPBars(
#             seq_count_table_path="/home/humebc/projects/liberman/203_20220411_03_DBV_20220412T020330.seqs.absolute.abund_and_meta.txt", profile_count_table_path="/home/humebc/projects/liberman/203_20220411_03_DBV_20220412T020330.profiles.absolute.abund_and_meta.txt",
#             plot_type="seq_and_profile", orientation='h', legend=True, relative_abundance=True, limit_genera=["A"], save_fig=True, add_sample_labels=True
#         )
# spb.plot()

# spb = SPBars(
#             seq_count_table_path="/home/humebc/projects/liberman/203_20220411_03_DBV_20220412T020330.seqs.absolute.abund_and_meta.txt", profile_count_table_path="/home/humebc/projects/liberman/203_20220411_03_DBV_20220412T020330.profiles.absolute.abund_and_meta.txt",
#             plot_type="seq_and_profile", orientation='h', legend=True, relative_abundance=True, limit_genera=["C"], save_fig=True, add_sample_labels=True
#         )
# spb.plot()

# spb = SPBars(
#             seq_count_table_path="/home/humebc/projects/liberman/203_20220411_03_DBV_20220412T020330.seqs.absolute.abund_and_meta.txt", profile_count_table_path="/home/humebc/projects/liberman/203_20220411_03_DBV_20220412T020330.profiles.absolute.abund_and_meta.txt",
#             plot_type="seq_and_profile", orientation='h', legend=True, relative_abundance=True, limit_genera=["D"], save_fig=True, add_sample_labels=True
#         )
# spb.plot()

spb = SPBars(
            seq_count_table_path="/home/humebc/projects/liberman/203_20220411_03_DBV_20220412T020330.seqs.absolute.abund_and_meta.txt", profile_count_table_path="/home/humebc/projects/liberman/203_20220411_03_DBV_20220412T020330.profiles.absolute.abund_and_meta.txt",
            plot_type="seq_only", orientation='h', legend=True, relative_abundance=True, limit_genera=["A", "C", "D"], save_fig=True, add_sample_labels=True, color_by_genus=True
        )
spb.plot()

foo = "bar"