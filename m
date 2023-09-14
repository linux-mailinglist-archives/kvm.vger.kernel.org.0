Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFBC47A00AE
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 11:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237531AbjINJs1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 05:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbjINJs0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 05:48:26 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CEF9EB;
        Thu, 14 Sep 2023 02:48:22 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1c337aeefbdso6622695ad.0;
        Thu, 14 Sep 2023 02:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694684902; x=1695289702; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6a6zOmRc9M17KBB4YTJsUWil+fUKVUovM7Jzzxz9wQA=;
        b=Pf8D2dbTYflsskyaGzZKKhLfvVPYej0ZtgSe61g0rbaG/C5RPrFUdy9pknbHttzdFV
         XttC0/5e9psvk3DWwaE8N744jgNKp6ZhIR0UGb3FJXwbEqPQuiqHNgCdLxtyaP2E0/FA
         TysaFiRRJWBWF8+1c69UkzlXQb1ruDi/AAeXEc1w6t4v4mq5OLofRumGfeEgi8T+33a1
         jpPIgHWa4ipVKjrQsVlEsVwK/YjuSB7rrjpzi0K/0G/mKYRmUChGLzCIHXWwY66gtzZ2
         fNLF+uk2gauMG4hg544tdoMVZCxBbH1kesPi90nGYN3wQ/FyoPUeygj60a7lGJg4Zi6N
         qDxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694684902; x=1695289702;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6a6zOmRc9M17KBB4YTJsUWil+fUKVUovM7Jzzxz9wQA=;
        b=ZQhcp6wCwPPhytWPKZcSJLWUxadSVyqDO1ZdQlx+6ZX453kP+f/Kzw3KPBsEJsbZ1x
         ZZlhc2KTfpsL6IKjgI7djj5D5e+OMHb3OnjLphpZKJ0SXBRY6HOwoSBRLBoFAesJjBys
         A3Z0s2ALQ4eJSZ9vOalPs8f8uG5lWbavzZTFnrr8FHjekbxALv0WWvC5RqqSIpxH8xrD
         sELcAUuNcepuM4otsCdWq8CVeGJNAdGEPaP4qLw0YG8m42oZemFjeLswcGw1lL5zlOSk
         +8BYIxD7AYCtIlC4+XZIvt6OnauGMRhdYt8VSzRwrA7q+C/0TmHJLt31XMWkneVPDEs1
         bgQw==
X-Gm-Message-State: AOJu0YyjAl5oUg+3VVj7bPg/MLmJr6m6vk2BeQZuBvoiSOJDj0PmN01h
        itQHrYnR3BLgG9xi3AdNK9LLfIwr94toUJlb
X-Google-Smtp-Source: AGHT+IEkROg8UtWXf8V6V1l+hYAFMFEcRdNd3m8GStklMRXJydb7AcIAPBJPyt2Prh9QhQhOKRy9UQ==
X-Received: by 2002:a17:902:c081:b0:1c3:4444:3c9e with SMTP id j1-20020a170902c08100b001c344443c9emr5372684pld.58.1694684901797;
        Thu, 14 Sep 2023 02:48:21 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id z14-20020a170902d54e00b001bd28b9c3ddsm1143914plf.299.2023.09.14.02.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 02:48:21 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: selftests: Remove obsolete and incorrect test case metadata
Date:   Thu, 14 Sep 2023 17:48:03 +0800
Message-ID: <20230914094803.94661-1-likexu@tencent.com>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Delete inaccurate descriptions and obsolete metadata for test cases.
It adds zero value, and has a non-zero chance of becoming stale and
misleading in the future. No functional changes intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
V1:
https://lore.kernel.org/kvm/20230629142633.86034-1-likexu@tencent.com/
V1 -> V2 Changelog:
- Delete the incorrect metadata instead of fix; (Sean)
- More selftests related files are covered;

 tools/testing/selftests/kvm/include/ucall_common.h       | 2 --
 tools/testing/selftests/kvm/lib/x86_64/apic.c            | 2 --
 tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c     | 2 --
 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c  | 2 --
 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh | 1 -
 tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c    | 4 ----
 tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c     | 4 ----
 7 files changed, 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index 112bc1da732a..ce33d306c2cb 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * tools/testing/selftests/kvm/include/kvm_util.h
- *
  * Copyright (C) 2018, Google LLC.
  */
 #ifndef SELFTEST_KVM_UCALL_COMMON_H
diff --git a/tools/testing/selftests/kvm/lib/x86_64/apic.c b/tools/testing/selftests/kvm/lib/x86_64/apic.c
index 7168e25c194e..89153a333e83 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/apic.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/apic.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * tools/testing/selftests/kvm/lib/x86_64/processor.c
- *
  * Copyright (C) 2021, Google LLC.
  */
 
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
index e446d76d1c0c..6c1278562090 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * KVM_GET/SET_* tests
- *
  * Copyright (C) 2022, Red Hat, Inc.
  *
  * Tests for Hyper-V extensions to SVM.
diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
index 7f36c32fa760..18ac5c1952a3 100644
--- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
+++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * tools/testing/selftests/kvm/nx_huge_page_test.c
- *
  * Usage: to be run via nx_huge_page_test.sh, which does the necessary
  * environment setup and teardown
  *
diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
index 0560149e66ed..7cbb409801ee 100755
--- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
+++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
@@ -4,7 +4,6 @@
 # Wrapper script which performs setup and cleanup for nx_huge_pages_test.
 # Makes use of root privileges to set up huge pages and KVM module parameters.
 #
-# tools/testing/selftests/kvm/nx_huge_page_test.sh
 # Copyright (C) 2022, Google LLC.
 
 set -e
diff --git a/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c b/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
index 5b669818e39a..59c7304f805e 100644
--- a/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
+++ b/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
@@ -1,10 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * svm_vmcall_test
- *
  * Copyright © 2021 Amazon.com, Inc. or its affiliates.
- *
- * Xen shared_info / pvclock testing
  */
 
 #include "test_util.h"
diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 05898ad9f4d9..9ec9ab60b63e 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -1,10 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * svm_vmcall_test
- *
  * Copyright © 2021 Amazon.com, Inc. or its affiliates.
- *
- * Xen shared_info / pvclock testing
  */
 
 #include "test_util.h"

base-commit: 0bb80ecc33a8fb5a682236443c1e740d5c917d1d
-- 
2.42.0

