import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_tracking/src/ui/pages/main_page/widgets/postal_id_input.dart';

import '../../global/widgets/my_scaffold.dart';
import 'bloc/tracking_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Center(
        child: BlocBuilder<TrackingBloc, TrackingState>(
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PostalIdInput(),
              ],
            );
          },
        ),
      ),
    );
  }
}
