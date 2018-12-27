#include<iostream>
#include<fstream>
#include<stdlib.h>

using namespace std;

//�ƌv��N���X
class Kakeibo
{
protected:
	int zankin;		//�c���ϐ� 
public:
	Kakeibo();		//�R���X�g���N�^
	void Input(int);//���z����
	void Output(int);//�o�� 
	void Disp(void);//���z 
	int GetZankin(void);//�c����ǂݍ��� 
	void SetZankin(void); 
};
Kakeibo::Kakeibo(void)//�R���X�g���N�^�Ŏc������ 
{
	zankin = GetZankin();
}
void Kakeibo::Input(int mon)
{
	zankin += mon;
	return;
}
void Kakeibo::Output(int mon)
{
	zankin -= mon;
	return;
}
void Kakeibo::Disp(void)
{
	cout << "�c����" << zankin << "�~�ł��B"<<endl;
	return;
}

int Kakeibo::GetZankin(void)//�t�@�C����ǂݍ���ŏ����l��p�ӂ��� 
{
	char c,zan[6];
	int i= 0;
	ifstream KakeiFile("kakei.dat");
	while(KakeiFile.get(c))
	{
		zan[i++] = c;
	}
	zan[i] = '\0';
	if(zan[0] == '\0')
		return 0;
	return(atoi(zan));
}
void Kakeibo::SetZankin(void)//�t�@�C���ɋ��z����� 
{
	ofstream KakeiFile("kakei.dat",ios::trunc);
	KakeiFile<<zankin;
	return;
}


int main(void)
{
	char sw;
	int okane;
	cout <<"�ƌv��" <<endl;
	cout << "I:���� U:�x�o D:�c�� E:�I��" <<endl;
	Kakeibo Mykakei;
	while(1){
		cout<<"�������邩=";
		cin>>sw;
		switch(sw) {
            case 'I':cout << "�������z��";
                cin >> okane;
                Mykakei.Input(okane);
                break;
            case 'U':cout << "�x�o���z��";
                cin >> okane;
                Mykakei.Output(okane);
                break;
            case 'D':Mykakei.Disp();
                break;
            case 'E':cout << "�I�����܂�" << endl;
                Mykakei.SetZankin();
                goto End;
                break;
            default:cout << "������x���͂��ĉ�����" << endl;
                break;
        }
	}
	End:
		return 0;
}









