//
//  ContectUsDetailViewController.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/25.
//

#import "ContectUsDetailViewController.h"
#import "appendAskView.h"
@interface ContectUsDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *dataArr;
@property(nonatomic, strong)UIImageView *bgTableViewImge;
@property(nonatomic, strong)UIButton *appendBtn;
@property(nonatomic, strong)appendAskView *appendView;
@end

@implementation ContectUsDetailViewController

-(void)returnClick{
    [self popViewControllerAnimate];
}
- (void)initData{
     UIView *leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIButton *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
       [leftButtonView addSubview:returnBtn];
       [returnBtn setImage:[UIImage imageNamed:@"white_back"] forState:UIControlStateNormal];
       [returnBtn addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
      self.navigationItem.leftBarButtonItem = leftCunstomButtonView;

}
-(void)CreateView{
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    self.navigationItem.title = TransOutput(@"联系我们");
    [self.view addSubview:self.bgTableViewImge];
    [self.bgTableViewImge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(16);
        make.top.mas_equalTo(self.bgHeaderView.mas_bottom).offset(16);
        make.trailing.bottom.mas_offset(-16);
    }];
    self.bgTableViewImge.userInteractionEnabled = YES;
    [self.bgTableViewImge addSubview:self.tableView];
    
    [self.view addSubview:self.appendBtn];
    [_appendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(15);
        make.bottom.mas_offset(-24);
        make.height.mas_offset(44);
        make.trailing.mas_offset(-15);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(5);
        make.top.mas_offset(22);
        
        make.trailing.mas_offset(-5);
        make.bottom.mas_equalTo(self.appendBtn.mas_top).offset(-10);
    }];
    
    @weakify(self);
    [self.appendBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self.view addSubview: self.appendView];
        [self.appendView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.bottom.mas_offset(0);
        }];
        [self.appendView setSureClickBlock:^(NSString * _Nonnull content) {
            @strongify(self);
           //追加咨询内容确认
            [self.appendView removeFromSuperview];
            
        }];
    }];
  
}
-(void)GetData{
    [NetwortTool getContactUsDetaiWithParm:self.idStr Success:^(id  _Nonnull responseObject) {
        ContectUsModel *model = [ContectUsModel mj_objectWithKeyValues:responseObject];
        NSString *stas;
        if ([model.status isEqual:@"0"]) {
            stas = TransOutput(@"审核中");
        }
        else{
            stas = TransOutput(@"审核完成");
        }
        
        
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH-42, 78)];
        headerView.backgroundColor = [UIColor clearColor];
        self.tableView.tableHeaderView = headerView;
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, WIDTH - 82, 24)];
        NSString *str = [NSString stringWithFormat:@"%@：%@",TransOutput(@"要件"),[NSString isNullStr:model.topic]];
        
        NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:str];
        textLabel.font = [UIFont systemFontOfSize:16];
        [attrString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor darkGrayColor]} range:NSMakeRange(0, [TransOutput(@"要件") length]+1)];
        
         
        textLabel.textColor = [UIColor grayColor];
        textLabel.attributedText = attrString;
        [headerView addSubview:textLabel];
        
        
        UILabel *textLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 44, WIDTH - 82, 24)];
        NSString *str2 = [NSString stringWithFormat:@"%@：%@",TransOutput(@"状态"),[NSString isNullStr:stas]];
        
        NSMutableAttributedString * attrString2 = [[NSMutableAttributedString alloc] initWithString:str2];
        textLabel2.font = [UIFont systemFontOfSize:16];
        [attrString2 addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor darkGrayColor]} range:NSMakeRange(0, [TransOutput(@"状态") length]+1)];
        
         
        textLabel2.textColor = [UIColor grayColor];
        textLabel2.attributedText = attrString2;
        [headerView addSubview:textLabel2];
        self.dataArr = @[@{@"list":@[@{@"title":TransOutput(@"创建时间"),@"content":[NSString isNullStr:model.createTime]},
                                      @{@"title":TransOutput(@"问题包括"),@"content":[NSString isNullStr:model.content]},
                                  @{@"title":TransOutput(@"回答时间"),@"content":[NSString isNullStr:model.replyTime]},
                                  @{@"title":TransOutput(@"回答内容"),@"content":[NSString isNullStr:model.reply]}]}
                        
            
        ];
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}
-(UIImageView *)bgHeaderView{
    if (!_bgHeaderView) {
        _bgHeaderView = [[UIImageView alloc] init];
        _bgHeaderView.userInteractionEnabled = YES;
        _bgHeaderView.image = [UIImage imageNamed:@"homeBackground"];
        
    }
    return _bgHeaderView;
}
- (UIButton *)appendBtn{
    if (!_appendBtn) {
        _appendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_appendBtn setTitle:TransOutput(@"追加提问") forState:UIControlStateNormal];
        _appendBtn.backgroundColor = [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 30];
        _appendBtn.layer.cornerRadius = 22;
        _appendBtn.clipsToBounds = YES;
       
       
    }
    return _appendBtn;
}
-(UIImageView *)bgTableViewImge{
    if (!_bgTableViewImge) {
        _bgTableViewImge = [[UIImageView alloc] init];
        _bgTableViewImge.image = [UIImage imageNamed:@"矩形 1450"];
        
    }
    return _bgTableViewImge;
}
-(appendAskView *)appendView{
    if (!_appendView) {
        _appendView = [appendAskView initViewNIB];
        _appendView.backgroundColor = [UIColor clearColor];
    }
    return _appendView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 1)];
    vi.backgroundColor = [UIColor clearColor];
    UILabel *line =[[UILabel alloc] initWithFrame:CGRectMake(20, 0, WIDTH - 82, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [vi addSubview:line];
    return vi;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.dataArr[section][@"list"];
    return arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *arr = self.dataArr[indexPath.section][@"list"];
    NSDictionary *dic = arr[indexPath.row];
    NSString *str = [NSString stringWithFormat:@"%@：%@",[NSString isNullStr:dic[@"title"]],[NSString isNullStr:dic[@"content"]]];
    
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:str];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    [attrString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor darkGrayColor]} range:NSMakeRange(0, [dic[@"title"] length]+1)];
    
     
    cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.attributedText = attrString;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
   
    
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = self.dataArr[indexPath.section][@"list"];
    NSDictionary *dic = arr[indexPath.row];
//    NSDictionary *dic = self.dataArr[indexPath.row];
    NSString *str = [NSString stringWithFormat:@"%@：%@",[NSString isNullStr:dic[@"title"]],[NSString isNullStr:dic[@"content"]]];
    CGFloat h = [Tool getLabelHeightWithText:str width:WIDTH - 32-10 font:17];
   
       return h + 16;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
