// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// import '../../../../constants.dart';

// String? emailValidator(String? value) {
//   if (value == null || value.isEmpty) return 'Email is required';
//   if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//     return 'Enter a valid email';
//   }
//   return null;
// }

// String? passwordValidator(String? value) {
//   if (value == null || value.isEmpty) return 'Password is required';
//   if (value.length < 6) return 'Password must be at least 6 characters';
//   return null;
// }

// class LogInForm extends StatelessWidget {
//   const LogInForm({
//     super.key,
//     required this.formKey,
//     required this.emailController,
//     required this.passwordController,
//   });

//   final GlobalKey<FormState> formKey;
//   final TextEditingController emailController;
//   final TextEditingController passwordController;

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: formKey,
//       child: Column(
//         children: [
//           TextFormField(
//             controller: emailController,
//             validator: emailValidator.call,
//             keyboardType: TextInputType.emailAddress,
//             decoration: InputDecoration(
//               hintText: "Email address",
//               prefixIcon: Padding(
//                 padding: const EdgeInsets.all(defaultPadding * 0.75),
//                 child: SvgPicture.asset(
//                   "assets/icons/Message.svg",
//                   colorFilter: ColorFilter.mode(
//                     Theme.of(context)
//                         .textTheme
//                         .bodyLarge!
//                         .color!
//                         .withOpacity(0.3),
//                     BlendMode.srcIn,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: defaultPadding),
//           TextFormField(
//             controller: passwordController,
//             validator: passwordValidator,
//             obscureText: true,
//             decoration: InputDecoration(
//               hintText: "Password",
//               prefixIcon: Padding(
//                 padding: const EdgeInsets.all(defaultPadding * 0.75),
//                 child: SvgPicture.asset(
//                   "assets/icons/Lock.svg",
//                   colorFilter: ColorFilter.mode(
//                     Theme.of(context)
//                         .textTheme
//                         .bodyLarge!
//                         .color!
//                         .withOpacity(0.3),
//                     BlendMode.srcIn,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants.dart';

String? emailValidator(String? value) {
  if (value == null || value.isEmpty) return 'Email is required';
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return 'Enter a valid email';
  }
  return null;
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) return 'Password is required';
  if (value.length < 6) return 'Password must be at least 6 characters';
  return null;
}

class LogInForm extends StatelessWidget {
  const LogInForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            validator: emailValidator,
            decoration: InputDecoration(
              hintText: "Email address",
              prefixIcon: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                child: SvgPicture.asset(
                  "assets/icons/Message.svg",
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withAlpha(77),
                      BlendMode.srcIn),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            controller: passwordController,
            validator: passwordValidator,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Password",
              prefixIcon: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                child: SvgPicture.asset(
                  "assets/icons/Lock.svg",
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withAlpha(77),
                      BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
