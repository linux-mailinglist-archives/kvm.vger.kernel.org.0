Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6497271F1
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 00:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbjFGWpg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 18:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233006AbjFGWpf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 18:45:35 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E13719AC
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 15:45:33 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5618857518dso99428057b3.2
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 15:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686177932; x=1688769932;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PbLYX85Jw4PTnvI11+u9XMaO08Dmwhv2XueYByO8/58=;
        b=el9pUpgeYZJobuUfgNS1qiQJbL5h/Clv9lYkF0ovsbnHQ6Ue1ZrkTDSfOUubMXp3an
         TxJ3dNT9Y7fq2Vl8QTRuHk2oatgELR30nqbGRBFhhOsZkF+ty+lQcSl/nc4pe+n4gZeB
         Vgx/KewUAzUzD5Fr61ulYaXa5fv+zU8zWHN7DlkO1E8CdJdy59yQzBJvPcmp0c57WzH6
         mNV+dgFZlg/q8+Ef9gRqp0UvNejdELbMF+a82XGXdE1oHjoM6WTB6XqdEVIWAsgQvFmS
         JDt5P2brqPWmQl39fHSdtTZzC1Z/vf0gokIRAfCTItT7fD3aiM+HJG2Cy62JSnLKJtpA
         0q8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686177932; x=1688769932;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PbLYX85Jw4PTnvI11+u9XMaO08Dmwhv2XueYByO8/58=;
        b=P3J+WmhYjFR4Ktn1np87qpAGfKPGobTQXkabBnl08NXXkLOc+EtY59D/RdjVEthUvn
         6OiWMrz1NUnLjforgMGcx6PPgt3bUVLl4BdY25olvAeYk8zf/QGZYqhHZmmV3NqKpyYk
         LgpH1Vi/FsVMu60kAGmzGiS2wZjj7h1wTFqL6PDVj8qXXwU/7xVJeGdDIEfWv9kKzyuA
         kVXg4iEPUhYPnd3F7eygaVsSP/rdiJIE5sTSBBMh5vH2BtM3t4zXd8Ax3Uky2bg37KQK
         t0q7uGESlWaA+6pHxpzf3JTgHqtzKj0gSAgbk1jlvfR85d4BcRr4+SIDVni57VN+l6re
         AGlw==
X-Gm-Message-State: AC+VfDxQria+ko1zKvdt4XD3NzO6s+8nJ9M1XGWVm6XcxCmeqKTCcUcc
        GhrdyPAk+CJ67gVv9PotpywNmZxx2YOe4KJ/EtbcthPQf7x1nBK3Ow3mKz4ghZRR3qNUZ2omaVm
        rLRZFwvNI8AcUCz1h9Bso0yiqLY1VNVOgE/LkMyfuGb3z9VgujRckugtZTj7er3mdQIY4
X-Google-Smtp-Source: ACHHUZ7AIIiAaYVMmlx33UJz7xyCMgqoe4mlFT+fTi1IhhlRSMEMUjKkLSC4MXaS5PnsTY6Lnr1MIH34v8iVwFd4
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a05:6902:1003:b0:ba8:2e69:9e06 with
 SMTP id w3-20020a056902100300b00ba82e699e06mr4018591ybt.1.1686177932688; Wed,
 07 Jun 2023 15:45:32 -0700 (PDT)
Date:   Wed,  7 Jun 2023 22:45:20 +0000
In-Reply-To: <20230607224520.4164598-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230607224520.4164598-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230607224520.4164598-6-aaronlewis@google.com>
Subject: [PATCH v3 5/5] KVM: selftests: Add a selftest for guest prints and
 formatted asserts
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The purpose of this test is to exercise the various features in KVM's
local snprintf() and compare them to LIBC's snprintf() to ensure they
behave the same.

This is not an exhaustive test.  KVM's local snprintf() does not
implement all the features LIBC does, e.g. KVM's local snprintf() does
not support floats or doubles, so testing for those features were
excluded.

Testing was added for the features that are expected to work to
support a minimal version of printf() in the guest.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/guest_print_test.c  | 222 ++++++++++++++++++
 2 files changed, 223 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/guest_print_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index efbe7e6d8f9b..85c35ea10ffd 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -122,6 +122,7 @@ TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
 TEST_GEN_PROGS_x86_64 += dirty_log_perf_test
+TEST_GEN_PROGS_x86_64 += guest_print_test
 TEST_GEN_PROGS_x86_64 += hardware_disable_test
 TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
 TEST_GEN_PROGS_x86_64 += kvm_page_table_test
diff --git a/tools/testing/selftests/kvm/guest_print_test.c b/tools/testing/selftests/kvm/guest_print_test.c
new file mode 100644
index 000000000000..7dd0a36e23c2
--- /dev/null
+++ b/tools/testing/selftests/kvm/guest_print_test.c
@@ -0,0 +1,222 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * A test for GUEST_PRINTF
+ *
+ * Copyright 2022, Google, Inc. and/or its affiliates.
+ */
+
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+struct guest_vals {
+	uint64_t a;
+	uint64_t b;
+	uint64_t type;
+};
+
+struct guest_vals vals;
+
+/* GUEST_PRINTF()/GUEST_ASSERT_FMT() does not support float or double. */
+#define TYPE_LIST					\
+TYPE(test_type_i64,  I64,  "%ld",   int64_t)		\
+TYPE(test_type_u64,  U64u, "%lu",   uint64_t)		\
+TYPE(test_type_x64,  U64x, "0x%lx", uint64_t)		\
+TYPE(test_type_X64,  U64X, "0x%lX", uint64_t)		\
+TYPE(test_type_u32,  U32u, "%u",    uint32_t)		\
+TYPE(test_type_x32,  U32x, "0x%x",  uint32_t)		\
+TYPE(test_type_X32,  U32X, "0x%X",  uint32_t)		\
+TYPE(test_type_int,  INT,  "%d",    int)		\
+TYPE(test_type_char, CHAR, "%c",    char)		\
+TYPE(test_type_str,  STR,  "'%s'",  const char *)	\
+TYPE(test_type_ptr,  PTR,  "%p",    uintptr_t)
+
+enum args_type {
+#define TYPE(fn, ext, fmt_t, T) TYPE_##ext,
+	TYPE_LIST
+#undef TYPE
+};
+
+static void run_test(struct kvm_vcpu *vcpu, const char *expected_printf,
+		     const char *expected_assert);
+
+#define BUILD_TYPE_STRINGS_AND_HELPER(fn, ext, fmt_t, T)		     \
+const char *PRINTF_FMT_##ext = "Got params a = " fmt_t " and b = " fmt_t;    \
+const char *ASSERT_FMT_##ext = "Expected " fmt_t ", got " fmt_t " instead";  \
+static void fn(struct kvm_vcpu *vcpu, T a, T b)				     \
+{									     \
+	char expected_printf[UCALL_BUFFER_LEN];				     \
+	char expected_assert[UCALL_BUFFER_LEN];				     \
+									     \
+	snprintf(expected_printf, UCALL_BUFFER_LEN, PRINTF_FMT_##ext, a, b); \
+	snprintf(expected_assert, UCALL_BUFFER_LEN, ASSERT_FMT_##ext, a, b); \
+	vals = (struct guest_vals){ (uint64_t)a, (uint64_t)b, TYPE_##ext };  \
+	sync_global_to_guest(vcpu->vm, vals);				     \
+	run_test(vcpu, expected_printf, expected_assert);		     \
+}
+
+#define TYPE(fn, ext, fmt_t, T) \
+		BUILD_TYPE_STRINGS_AND_HELPER(fn, ext, fmt_t, T)
+	TYPE_LIST
+#undef TYPE
+
+static void guest_code(void)
+{
+	while (1) {
+		switch (vals.type) {
+#define TYPE(fn, ext, fmt_t, T)							\
+		case TYPE_##ext:						\
+			GUEST_PRINTF(PRINTF_FMT_##ext, vals.a, vals.b);		\
+			GUEST_ASSERT_FMT(vals.a == vals.b,			\
+					 ASSERT_FMT_##ext, vals.a, vals.b);	\
+			break;
+	TYPE_LIST
+#undef TYPE
+		default:
+			GUEST_SYNC(vals.type);
+		}
+
+		GUEST_DONE();
+	}
+}
+
+/*
+ * Unfortunately this gets a little messy because 'assert_msg' doesn't
+ * just contains the matching string, it also contains additional assert
+ * info.  Fortunately the part that matches should be at the very end of
+ * 'assert_msg'.
+ */
+static void ucall_abort(const char *assert_msg, const char *expected_assert_msg)
+{
+	int len_str = strlen(assert_msg);
+	int len_substr = strlen(expected_assert_msg);
+	int offset = len_str - len_substr;
+
+	TEST_ASSERT(len_substr <= len_str,
+		    "Expected to find a substring, len_str: %d, len_substr: %d",
+		    len_str, len_substr);
+
+	TEST_ASSERT(strcmp(&assert_msg[offset], expected_assert_msg) == 0,
+		    "Unexpected mismatch. Expected: '%s', got: '%s'",
+		    expected_assert_msg, &assert_msg[offset]);
+}
+
+static void run_test(struct kvm_vcpu *vcpu, const char *expected_printf,
+		     const char *expected_assert)
+{
+	struct kvm_run *run = vcpu->run;
+	struct ucall uc;
+
+	while (1) {
+		vcpu_run(vcpu);
+
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+			    "Unexpected exit reason: %u (%s),\n",
+			    run->exit_reason,
+			    exit_reason_str(run->exit_reason));
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_SYNC:
+			TEST_FAIL("Unknown 'args_type' = %lu", uc.args[1]);
+			break;
+		case UCALL_PRINTF:
+			TEST_ASSERT(strcmp(uc.buffer, expected_printf) == 0,
+				    "Unexpected mismatch. Expected: '%s', got: '%s'",
+				    expected_printf, uc.buffer);
+			break;
+		case UCALL_ABORT:
+			ucall_abort(uc.buffer, expected_assert);
+			break;
+		case UCALL_DONE:
+			return;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	}
+}
+
+static void guest_code_limits(void)
+{
+	char test_str[UCALL_BUFFER_LEN + 10];
+
+	memset(test_str, 'a', sizeof(test_str));
+	test_str[sizeof(test_str) - 1] = 0;
+
+	GUEST_PRINTF("%s", test_str);
+}
+
+static void test_limits(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_run *run;
+	struct kvm_vm *vm;
+	struct ucall uc;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code_limits);
+	run = vcpu->run;
+	vcpu_run(vcpu);
+
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+		    "Unexpected exit reason: %u (%s),\n",
+		    run->exit_reason,
+		    exit_reason_str(run->exit_reason));
+
+	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_ABORT,
+		    "Unexpected ucall command: %lu,  Expected: %u (UCALL_ABORT)\n",
+		    uc.cmd, UCALL_ABORT);
+
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+
+	test_type_i64(vcpu, -1, -1);
+	test_type_i64(vcpu, -1,  1);
+	test_type_i64(vcpu, 0x1234567890abcdef, 0x1234567890abcdef);
+	test_type_i64(vcpu, 0x1234567890abcdef, 0x1234567890abcdee);
+
+	test_type_u64(vcpu, 0x1234567890abcdef, 0x1234567890abcdef);
+	test_type_u64(vcpu, 0x1234567890abcdef, 0x1234567890abcdee);
+	test_type_x64(vcpu, 0x1234567890abcdef, 0x1234567890abcdef);
+	test_type_x64(vcpu, 0x1234567890abcdef, 0x1234567890abcdee);
+	test_type_X64(vcpu, 0x1234567890abcdef, 0x1234567890abcdef);
+	test_type_X64(vcpu, 0x1234567890abcdef, 0x1234567890abcdee);
+
+	test_type_u32(vcpu, 0x90abcdef, 0x90abcdef);
+	test_type_u32(vcpu, 0x90abcdef, 0x90abcdee);
+	test_type_x32(vcpu, 0x90abcdef, 0x90abcdef);
+	test_type_x32(vcpu, 0x90abcdef, 0x90abcdee);
+	test_type_X32(vcpu, 0x90abcdef, 0x90abcdef);
+	test_type_X32(vcpu, 0x90abcdef, 0x90abcdee);
+
+	test_type_int(vcpu, -1, -1);
+	test_type_int(vcpu, -1,  1);
+	test_type_int(vcpu,  1,  1);
+
+	test_type_char(vcpu, 'a', 'a');
+	test_type_char(vcpu, 'a', 'A');
+	test_type_char(vcpu, 'a', 'b');
+
+	test_type_str(vcpu, "foo", "foo");
+	test_type_str(vcpu, "foo", "bar");
+
+	test_type_ptr(vcpu, 0x1234567890abcdef, 0x1234567890abcdef);
+	test_type_ptr(vcpu, 0x1234567890abcdef, 0x1234567890abcdee);
+
+	kvm_vm_free(vm);
+
+	test_limits();
+
+	return 0;
+}
-- 
2.41.0.rc0.172.g3f132b7071-goog

