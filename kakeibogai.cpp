#include<iostream>
#include<fstream>
#include<stdlib.h>

using namespace std;

//家計簿クラス
class Kakeibo
{
protected:
	int zankin;		//残金変数 
public:
	Kakeibo();		//コンストラクタ
	void Input(int);//金額入力
	void Output(int);//出金 
	void Disp(void);//金額 
	int GetZankin(void);//残金を読み込む 
	void SetZankin(void); 
};
Kakeibo::Kakeibo(void)//コンストラクタで残金導入 
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
	cout << "残金は" << zankin << "円です。"<<endl;
	return;
}

int Kakeibo::GetZankin(void)//ファイルを読み込んで初期値を用意する 
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
void Kakeibo::SetZankin(void)//ファイルに金額を入力 
{
	ofstream KakeiFile("kakei.dat",ios::trunc);
	KakeiFile<<zankin;
	return;
}


int main(void)
{
	char sw;
	int okane;
	cout <<"家計簿" <<endl;
	cout << "I:収入 U:支出 D:残金 E:終了" <<endl;
	Kakeibo Mykakei;
	while(1){
		cout<<"何をするか=";
		cin>>sw;
		switch(sw) {
            case 'I':cout << "収入金額＝";
                cin >> okane;
                Mykakei.Input(okane);
                break;
            case 'U':cout << "支出金額＝";
                cin >> okane;
                Mykakei.Output(okane);
                break;
            case 'D':Mykakei.Disp();
                break;
            case 'E':cout << "終了します" << endl;
                Mykakei.SetZankin();
                goto End;
                break;
            default:cout << "もう一度入力して下さい" << endl;
                break;
        }
	}
	End:
		return 0;
}









