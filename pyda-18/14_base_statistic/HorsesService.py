import pandas
import numpy

class HorsesService:

    def fetch_hourse_data_frame(self) -> pandas.DataFrame:
        return pandas.read_csv(
            'horse_data.csv',
            names=[
                'is_surgery',
                'age',
                'hospital_number',
                'rectal_temperature',
                'pulse',
                'respiratory_rate',
                'temperature_of_extremities',
                'peripheral_pulse',
                'mucous_membranes',
                'capillary_refill_time',
                'pain',  # a subjective judgement of the horse's pain level
                'peristalsis',
                'abdominal_distension',
                'nasogastric_tube',
                'nasogastric_reflux',
                'nasogastric_reflux_ph',
                'rectal_examination_-_feces',
                'abdomen',
                'packed_cell_volume',
                'total_protein',
                'abdominocentesis_appearance',
                'abdomcentesis_total_protein',
                'outcome',
                'is_surgical_lesion',
                'type_of_lesion_1',
                'type_of_lesion_2',
                'type_of_lesion_3',
                'cp_data',
            ]
        )

    def clean_trash(self, hourse_data_frame: pandas.DataFrame) -> pandas.DataFrame:
        clean_table: pandas.DataFrame = hourse_data_frame.apply(lambda column: column.replace('?', numpy.nan))
        names_float_columns = [
            'total_protein',
            'packed_cell_volume',
            'rectal_temperature',
            'pulse',
            'temperature_of_extremities',
            'peripheral_pulse',
            'capillary_refill_time',
            'packed_cell_volume',
            'is_surgery',
            'respiratory_rate',
            'abdomcentesis_total_protein'
        ]
        clean_table[names_float_columns] = clean_table[names_float_columns].astype(float)

        names_str_columns = [
            'mucous_membranes',
            'pain',
            'peristalsis',
            'rectal_examination_-_feces',
            'abdomen',
            'abdominal_distension',
            'nasogastric_tube',
            'nasogastric_reflux',
            'nasogastric_reflux_ph',
            'type_of_lesion_1',
            'type_of_lesion_2',
            'type_of_lesion_3',
            'abdominocentesis_appearance',
            'outcome'
        ]
        clean_table[names_str_columns] = clean_table[names_str_columns].astype(str)

        return clean_table

    def convert_type_bool(self, hourse_data_frame: pandas.DataFrame) -> pandas.DataFrame:
        hourse_data_frame['is_surgery'] = hourse_data_frame['is_surgery'] == 1
        hourse_data_frame['is_surgical_lesion'] = hourse_data_frame['is_surgical_lesion'] == 1
        hourse_data_frame['cp_data'] = hourse_data_frame['cp_data'] == 1
        return hourse_data_frame

    def fetch_processed_hourse_data_frame(self) -> pandas.DataFrame:
        return self.convert_type_bool(
            hourse_data_frame=self.clean_trash(
                hourse_data_frame=self.fetch_hourse_data_frame()
            )
        )