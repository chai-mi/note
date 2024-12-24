import os


def replace_punctuation_in_md_files(folder_path):
    # 遍历文件夹中的所有文件
    for root, dirs, files in os.walk(folder_path):
        for file_name in files:
            # 只处理md文件
            if file_name.endswith(".md"):
                file_path = os.path.join(root, file_name)
                with open(file_path, "r", encoding="utf-8") as file:
                    content = file.read()

                # 替换中文全角冒号和逗号
                content = content.replace("：", " : ")
                content = content.replace("，", " , ")

                # 将替换后的内容写回文件
                with open(file_path, "w", encoding="utf-8") as file:
                    file.write(content)


# 获取当前脚本所在的文件夹路径
current_folder_path = os.path.dirname(os.path.realpath(__file__))
replace_punctuation_in_md_files(current_folder_path)
