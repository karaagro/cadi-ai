import 'package:flutter/material.dart';

class SearchInputField extends StatefulWidget {
  const SearchInputField({super.key, this.onChanged, this.onTap});

  final void Function(String)? onChanged;
  final void Function()? onTap;

  @override
  State<SearchInputField> createState() => _SearchInputFieldState();
}

class _SearchInputFieldState extends State<SearchInputField> {
  final _controller = TextEditingController();

  bool _isSearchActive = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final text = _controller.text;
      widget.onChanged?.call(text);

      setState(() {
        _isSearchActive = text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      cursorColor: Colors.amber,
      decoration: InputDecoration(
          filled: true,
          isDense: true,
          hintText: 'Search',
          // focusColor: Colors.amber,
          prefixIcon: const Icon(
            Icons.search,
          ),
          suffixIcon: _isSearchActive
              ? IconButton(
                  splashRadius: 16,
                  onPressed: () {
                    _controller.clear();
                  },
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.red,
                  ))
              : null,
          border: const OutlineInputBorder(
              gapPadding: 0,
              borderSide: BorderSide(style: BorderStyle.none, width: 0))),
      onTap: widget.onTap,
    );
  }
}
