Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D98496D461E
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 15:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbjDCNt3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 09:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232113AbjDCNtZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 09:49:25 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48EB26EAF
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 06:49:23 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id r19-20020a05600c459300b003eb3e2a5e7bso18173010wmo.0
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 06:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680529762;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VBQGpqWmgJmN3spJtbY9ofJJqcdbpRTH4FCdiaUq178=;
        b=H4QstZX/rS1x1LifCE9PcChSlhTKrXM1xvEbZTlLirjUI/RKnVpIUf5i0ZDtBZYRX+
         BXEEzSG+k9s3MkHeQnsexzyaMFuT5wqn3PUAKKS9MMVd85bE5Ghku89tTedIx1ORbbDM
         7fwKLJsWRHoy7kj5r53uVIdQMKNChX4p9mxE0hlNr27F2Xq/Kxz1SheWm1TF89jS0sKs
         Yqyy3YdqRE12hYcOnLu65RT52HTSpbHmN9laA5R8bbWO1YP9xrbfcJJHnYZsC/AKUSpU
         eUGnAGbALhvUf6T5fvwIYkh1Wxw0u3qoU6hFrEA8L1jCb1mFb2u7gOxGANgT5+MLZPRL
         vV1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680529762;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VBQGpqWmgJmN3spJtbY9ofJJqcdbpRTH4FCdiaUq178=;
        b=cS071HkZlKxTchCc0vU8p2uBnge6jj+WcmFef/BbTnrrgjsK0JdOshAxennrzkS9Iv
         tUNhTQBsBoZab0SSAURZXbs1XlaCyc8tESL58SwEYr4yXhoBMll8+9JvXeS7HJV4EEq1
         7OvWa8L0vhmoaf1WlZoo0D89kYZy0tgA9ZD71UDDhruP2k7df7iYBlyJ59Z5RjIdJJmm
         LJ0rIHbbChSyN3sPvwtq2wdFW5rzkgsSiKkbQi+3qXZN7bI6+eS3cswKdCfZs6a4BiXR
         QEHtceUJXHnsLlD4jN8xfuNET/j/W8P+83z3BmbVLxgblOfu95yklN7Y1b8IXIeAzNUa
         HsAQ==
X-Gm-Message-State: AAQBX9fY39H7aqe/50Y414bYaaVG9nfMRjVl9OYoaA0JyvwWAehaL5mw
        2al/v6QoLK8rw9ZHuxeqPnOn3g==
X-Google-Smtp-Source: AKy350adEMNdoAny6K7tt+gEXhIno5WjB+5zl1E0OzgZy/kdk0TZ8Gz6NZBlFwEo4yk3JyvTab8maA==
X-Received: by 2002:a05:600c:220c:b0:3ef:61f7:7d34 with SMTP id z12-20020a05600c220c00b003ef61f77d34mr22447919wml.1.1680529761634;
        Mon, 03 Apr 2023 06:49:21 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id t14-20020a05600c198e00b003ee1e07a14asm19528903wmq.45.2023.04.03.06.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 06:49:21 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id CCCCE1FFB8;
        Mon,  3 Apr 2023 14:49:20 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Ryo ONODERA <ryoon@netbsd.org>, qemu-block@nongnu.org,
        Hanna Reitz <hreitz@redhat.com>, Warner Losh <imp@bsdimp.com>,
        Beraldo Leal <bleal@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Kyle Evans <kevans@freebsd.org>, kvm@vger.kernel.org,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Cleber Rosa <crosa@redhat.com>, Thomas Huth <thuth@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Kautuk Consul <kconsul@linux.vnet.ibm.com>
Subject: [PATCH v2 01/11] scripts/coverage: initial coverage comparison script
Date:   Mon,  3 Apr 2023 14:49:10 +0100
Message-Id: <20230403134920.2132362-2-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230403134920.2132362-1-alex.bennee@linaro.org>
References: <20230403134920.2132362-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a very rough and ready first pass at comparing gcovr's json
output between two different runs. At the moment it will give you a
file level diff between two runs but hopefully it wont be too hard to
extend to give better insight.

After generating the coverage results you run with something like:

  ./scripts/coverage/compare_gcov_json.py \
    -a ./builds/gcov.config1/coverage.json \
    -b ./builds/gcov.config2/coverage.json

My hope is we can use this to remove some redundancy from testing as
well as evaluate if new tests are actually providing additional
coverage or just burning our precious CI time.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Cc: Kautuk Consul <kconsul@linux.vnet.ibm.com>
Acked-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20230330101141.30199-2-alex.bennee@linaro.org>
---
 MAINTAINERS                           |   5 ++
 scripts/coverage/compare_gcov_json.py | 119 ++++++++++++++++++++++++++
 2 files changed, 124 insertions(+)
 create mode 100755 scripts/coverage/compare_gcov_json.py

diff --git a/MAINTAINERS b/MAINTAINERS
index ef45b5e71e..9e1a60ea24 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3908,3 +3908,8 @@ Performance Tools and Tests
 M: Ahmed Karaman <ahmedkhaledkaraman@gmail.com>
 S: Maintained
 F: scripts/performance/
+
+Code Coverage Tools
+M: Alex Bennée <alex.bennee@linaro.org>
+S: Odd Fixes
+F: scripts/coverage/
diff --git a/scripts/coverage/compare_gcov_json.py b/scripts/coverage/compare_gcov_json.py
new file mode 100755
index 0000000000..1b92dc2c8c
--- /dev/null
+++ b/scripts/coverage/compare_gcov_json.py
@@ -0,0 +1,119 @@
+#!/usr/bin/env python3
+#
+# Compare output of two gcovr JSON reports and report differences. To
+# generate the required output first:
+#   - create two build dirs with --enable-gcov
+#   - run set of tests in each
+#   - run make coverage-html in each
+#   - run gcovr --json --exclude-unreachable-branches \
+#           --print-summary -o coverage.json --root ../../ . *.p
+#
+# Author: Alex Bennée <alex.bennee@linaro.org>
+#
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+
+import argparse
+import json
+import sys
+from pathlib import Path
+
+def create_parser():
+    parser = argparse.ArgumentParser(
+        prog='compare_gcov_json',
+        description='analyse the differences in coverage between two runs')
+
+    parser.add_argument('-a', type=Path, default=None,
+                        help=('First file to check'))
+
+    parser.add_argument('-b', type=Path, default=None,
+                        help=('Second file to check'))
+
+    parser.add_argument('--verbose', action='store_true', default=False,
+                        help=('A minimal verbosity level that prints the '
+                              'overall result of the check/wait'))
+    return parser
+
+
+# See https://gcovr.com/en/stable/output/json.html#json-format-reference
+def load_json(json_file_path: Path, verbose = False) -> dict[str, set[int]]:
+
+    with open(json_file_path) as f:
+        data = json.load(f)
+
+    root_dir = json_file_path.absolute().parent
+    covered_lines = dict()
+
+    for filecov in data["files"]:
+        file_path = Path(filecov["file"])
+
+        # account for generated files - map into src tree
+        resolved_path = Path(file_path).absolute()
+        if resolved_path.is_relative_to(root_dir):
+            file_path = resolved_path.relative_to(root_dir)
+            # print(f"remapped {resolved_path} to {file_path}")
+
+        lines = filecov["lines"]
+
+        executed_lines = set(
+            linecov["line_number"]
+            for linecov in filecov["lines"]
+            if linecov["count"] != 0 and not linecov["gcovr/noncode"]
+        )
+
+        # if this file has any coverage add it to the system
+        if len(executed_lines) > 0:
+            if verbose:
+                print(f"file {file_path} {len(executed_lines)}/{len(lines)}")
+            covered_lines[str(file_path)] = executed_lines
+
+    return covered_lines
+
+def find_missing_files(first, second):
+    """
+    Return a list of files not covered in the second set
+    """
+    missing_files = []
+    for f in sorted(first):
+        file_a = first[f]
+        try:
+            file_b = second[f]
+        except KeyError:
+            missing_files.append(f)
+
+    return missing_files
+
+def main():
+    """
+    Script entry point
+    """
+    parser = create_parser()
+    args = parser.parse_args()
+
+    if not args.a or not args.b:
+        print("We need two files to compare")
+        sys.exit(1)
+
+    first_coverage = load_json(args.a, args.verbose)
+    second_coverage = load_json(args.b, args.verbose)
+
+    first_missing = find_missing_files(first_coverage,
+                                       second_coverage)
+
+    second_missing = find_missing_files(second_coverage,
+                                        first_coverage)
+
+    a_name = args.a.parent.name
+    b_name = args.b.parent.name
+
+    print(f"{b_name} missing coverage in {len(first_missing)} files")
+    for f in first_missing:
+        print(f"  {f}")
+
+    print(f"{a_name} missing coverage in {len(second_missing)} files")
+    for f in second_missing:
+        print(f"  {f}")
+
+
+if __name__ == '__main__':
+    main()
-- 
2.39.2

