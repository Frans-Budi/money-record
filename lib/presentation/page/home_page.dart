import 'package:d_chart/d_chart.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_record/config/app_asset.dart';
import 'package:money_record/config/app_color.dart';
import 'package:money_record/config/app_format.dart';
import 'package:money_record/config/session.dart';
import 'package:money_record/presentation/controller/c_home.dart';
import 'package:money_record/presentation/controller/c_user.dart';
import 'package:money_record/presentation/page/auth/login_page.dart';
import 'package:money_record/presentation/page/history/add_history_page.dart';
import 'package:money_record/presentation/page/history/detail_history_page.dart';
import 'package:money_record/presentation/page/history/history_page.dart';
import 'package:money_record/presentation/page/history/income_outcome_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cUser = Get.put(CUser());
  final cHome = Get.put(CHome());

  @override
  void initState() {
    cHome.getAnalysis(cUser.data.idUser!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: drawer(context),
      body: Column(
        children: [
          //header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
            child: Row(
              children: [
                Image.asset(AppAsset.profile),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi,",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      Obx(
                        () => Text(
                          cUser.data.name ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                Builder(builder: (ctx) {
                  return Material(
                    borderRadius: BorderRadius.circular(6),
                    color: AppColor.tint,
                    child: InkWell(
                      onTap: () {
                        Scaffold.of(ctx).openEndDrawer();
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.menu,
                          color: AppColor.primary,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          //content
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                cHome.getAnalysis(cUser.data.idUser!);
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                children: [
                  //pengeluaran harian
                  Text(
                    "Pengeluaran Hari ini",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  DView.height(),
                  cardToday(context),
                  DView.height(30),
                  Center(
                    child: Container(
                      width: 80,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColor.background,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  DView.height(30),
                  //pengeluaran mingguan
                  Text(
                    "Pengeluaran Mingguan Ini",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  DView.height(),
                  weekly(),
                  DView.height(30),
                  //pengeluaran bulanan
                  Text(
                    "Perbandingan Bulan Ini",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  DView.height(),
                  monthly(context)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Drawer drawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 20),
            showDivider: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(AppAsset.profile),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => Text(
                              cUser.data.name ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Obx(
                            () => Text(
                              cUser.data.email ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Material(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    onTap: () {
                      Session.clearUser();
                      Get.off(() => const LoginPage());
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      child: Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.black26),
          ListTile(
            onTap: () {
              Get.to(() => const AddHistoryPage())?.then((value) => {
                    if (value ?? false)
                      {
                        cHome.getAnalysis(cUser.data.idUser!),
                      }
                  });
            },
            leading: const Icon(Icons.add, color: Colors.black54),
            horizontalTitleGap: 16,
            title: const Text("Tambah Baru"),
            trailing: const Icon(Icons.navigate_next),
          ),
          const Divider(height: 1, color: Colors.black26),
          ListTile(
            onTap: () {
              Get.to(() => const IncomeOutcomePage(type: "Pemasukan"));
            },
            leading: const Icon(Icons.south_west, color: Colors.black54),
            horizontalTitleGap: 16,
            title: const Text("Pemasukan"),
            trailing: const Icon(Icons.navigate_next),
          ),
          const Divider(height: 1, color: Colors.black26),
          ListTile(
            onTap: () {
              Get.to(() => const IncomeOutcomePage(type: "Pengeluaran"));
            },
            leading: const Icon(Icons.north_east, color: Colors.black54),
            horizontalTitleGap: 16,
            title: const Text("Pengeluaran"),
            trailing: const Icon(Icons.navigate_next),
          ),
          const Divider(height: 1, color: Colors.black26),
          ListTile(
            onTap: () {
              Get.to(() => const HistoryPage());
            },
            leading: const Icon(Icons.history, color: Colors.black54),
            horizontalTitleGap: 16,
            title: const Text("Riwayat"),
            trailing: const Icon(Icons.navigate_next),
          ),
          const Divider(height: 1, color: Colors.black26),
        ],
      ),
    );
  }

  Material cardToday(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      elevation: 4,
      color: AppColor.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
            child: Obx(
              () {
                return Text(
                  AppFormat.currency(cHome.today.toString()),
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColor.secondary,
                      ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
            child: Obx(
              () {
                return Text(
                  cHome.todayPercent,
                  style: const TextStyle(
                    color: AppColor.background,
                    fontSize: 16,
                  ),
                );
              },
            ),
          ),
          GestureDetector(
            onTap: () => Get.to(() => DetailHistoryPage(
                  idUser: cUser.data.idUser!,
                  date: DateFormat("yyyy-MM-dd").format(DateTime.now()),
                  type: "Pengeluaran",
                )),
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 0, 16),
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Selengkapnya",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColor.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    Icons.navigate_next,
                    color: AppColor.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AspectRatio weekly() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Obx(
        () {
          return DChartBarO(
            domainAxis: const DomainAxis(
              gapAxisToLabel: 12,
              labelAnchor: LabelAnchor.centered,
              tickLength: 5,
              labelStyle: LabelStyle(
                color: Colors.black,
                fontSize: 14,
              ),
              lineStyle: LineStyle(
                color: AppColor.primary,
                thickness: 2,
              ),
              showLine: true,
            ),
            measureAxis: const MeasureAxis(
              showLine: true,
              gapAxisToLabel: 12,
              tickLength: 0,
              labelAnchor: LabelAnchor.centered,
              labelStyle: LabelStyle(
                color: Colors.transparent,
                fontSize: 14,
              ),
              lineStyle: LineStyle(
                color: AppColor.primary,
                thickness: 2,
              ),
            ),
            fillColor: (group, ordinalData, index) {
              return AppColor.primary;
            },
            groupList: [
              OrdinalGroup(
                id: '1',
                data: List.generate(7, (index) {
                  return OrdinalData(
                    domain: cHome.weekText()[index],
                    measure: cHome.week[index],
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }

  Row monthly(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.width * 0.5,
          child: Stack(
            children: [
              Obx(() {
                return DChartPieO(
                  data: [
                    OrdinalData(
                      domain: 'Income',
                      measure: cHome.monthIncome,
                      color: AppColor.primary,
                    ),
                    OrdinalData(
                      domain: 'Outcome',
                      measure: cHome.monthOutcome,
                      color: AppColor.tint,
                    ),
                    if (cHome.monthIncome == 0 && cHome.monthOutcome == 0)
                      OrdinalData(
                        domain: "Nol",
                        measure: 1,
                        color: AppColor.background,
                      )
                  ],
                  configRenderPie: const ConfigRenderPie(arcWidth: 20),
                );
              }),
              Center(
                child: Obx(() {
                  return Text(
                    "${cHome.percentIncome}%",
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: AppColor.primary, fontWeight: FontWeight.w500),
                  );
                }),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  color: AppColor.primary,
                ),
                DView.width(8),
                const Text("Pemasukan"),
              ],
            ),
            DView.height(8),
            Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  color: AppColor.tint,
                ),
                DView.width(8),
                const Text("Pengeluaran"),
              ],
            ),
            DView.height(20),
            Obx(() {
              return Text(cHome.monthPercent);
            }),
            DView.height(10),
            const Text("Atau setara:"),
            Obx(() {
              return Text(
                AppFormat.currency(cHome.differentMonth.toString()),
                style: const TextStyle(
                  color: AppColor.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              );
            })
          ],
        ),
      ],
    );
  }
}
