Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D643E6ED840
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 00:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbjDXW7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 18:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbjDXW7K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 18:59:10 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0A093C1
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 15:59:08 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-24763adb145so4951959a91.2
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 15:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682377148; x=1684969148;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZuwyeqJU2ec2RnXFc6oVuANOVQcHu6d+sHkMhDN9j9E=;
        b=Wb2urpN/5j7jJtUVBrNfy+U2bPKKCkuLnZrQBBb88jPHXgUC2NQlh+33DbJiMzT5i7
         xAGZDsydldLCELgwg54aD7uDUa5oKAD6eUWc1Vcr1Gr0hSyeOETBwzIYxhTHNbDuiMnO
         jOAqJP/bpDeeFomcz/Ifo+IBnuX46iS8/fOm7s5GrX8mopaUVP+2fZ3tfOM1NSJTJWmM
         yjvOfhtQPhNHb10Fxzm8dRYCm2g8FF3Cy+VXgqi4enfUT0MsSnz0etiGU+1uRizqozeD
         HanOGzf54gTYsxC8Xt7UZzQolBjm3zDfnORbezyb/wG2PXcpcxaIxIJ5RX1KcF3baPdI
         uYtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682377148; x=1684969148;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZuwyeqJU2ec2RnXFc6oVuANOVQcHu6d+sHkMhDN9j9E=;
        b=GvHlgxSH694qPI6wrFwqE4NwMOVTQo91JWWO3Se334gC0FMnDax7hLLPqh+b/55MzS
         3vVvkJw1n+EWHrobvw3/RVSWk3T2ueqgPmSnd2H2X/fLCcdV/nzElFymlX7/WG9grBpv
         dRDEitWn4qIi4Zg1qT65Mo4EmMn22TrtAPu3INr3WZlR7FLGu/iB/Pai4w+s0T55FHrd
         GRv8qwHQyRDo0tTgVs2QjbdSbDdX06hvZN7A6h/mzxmvGq43knDNyVREVvZmEC12Et8d
         fvwl0zKNZRxki3+CCtLmR486qoXFNja7eBH7S0TkLvRo+daN7oZ8yEyIIs9vGcypzqHA
         z2OQ==
X-Gm-Message-State: AAQBX9dQW6pjz0EbJIxXVp19RnzRc9fUzdw0OoE4eEuvLKYkg7ogUrlA
        7JmR3HDvxMShpcqrD1WHwovLRrCs/cyQVXTrEp+u5fDaGkXoywsWHOOpFz6S1bO/2UYaLI6Zcsg
        jGa+Qa1Z7SpLURdt4NzaMn0irZQQ8anouOCBO6OvbRHMnjRRYaX/w6GqnmlunS39eD6r2
X-Google-Smtp-Source: AKy350Yy/Ppyj3DYTKUlNH28a4PB95v78vuIxkSV3S96Nb40A3gbVAjw7w66sASo3wtSCFhFQrEQHue7zmw/Cpu/
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a17:90a:4ecc:b0:246:66d6:f24e with SMTP
 id v12-20020a17090a4ecc00b0024666d6f24emr3787625pjl.2.1682377148361; Mon, 24
 Apr 2023 15:59:08 -0700 (PDT)
Date:   Mon, 24 Apr 2023 22:58:54 +0000
In-Reply-To: <20230424225854.4023978-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230424225854.4023978-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230424225854.4023978-7-aaronlewis@google.com>
Subject: [PATCH v2 6/6] KVM: selftests: Add a selftest for guest prints and
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
 .../testing/selftests/kvm/guest_print_test.c  | 207 ++++++++++++++++++
 2 files changed, 208 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/guest_print_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 84b126398729..31587a0e2efb 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -121,6 +121,7 @@ TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
 TEST_GEN_PROGS_x86_64 += dirty_log_perf_test
+TEST_GEN_PROGS_x86_64 += guest_print_test
 TEST_GEN_PROGS_x86_64 += hardware_disable_test
 TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
 TEST_GEN_PROGS_x86_64 += kvm_page_table_test
diff --git a/tools/testing/selftests/kvm/guest_print_test.c b/tools/testing/selftests/kvm/guest_print_test.c
new file mode 100644
index 000000000000..57489055e5cb
--- /dev/null
+++ b/tools/testing/selftests/kvm/guest_print_test.c
@@ -0,0 +1,207 @@
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
+	vcpu_args_set(vcpu, 3, a, b, TYPE_##ext);			     \
+	run_test(vcpu, expected_printf, expected_assert);		     \
+}
+
+#define TYPE(fn, ext, fmt_t, T) \
+		BUILD_TYPE_STRINGS_AND_HELPER(fn, ext, fmt_t, T)
+	TYPE_LIST
+#undef TYPE
+
+static void guest_code(uint64_t a, uint64_t b, uint64_t type)
+{
+	switch (type) {
+#define TYPE(fn, ext, fmt_t, T) case TYPE_##ext:			\
+		GUEST_PRINTF(PRINTF_FMT_##ext, a, b);			\
+		GUEST_ASSERT_FMT(a == b, ASSERT_FMT_##ext, a, b);	\
+		break;
+	TYPE_LIST
+#undef TYPE
+	default:
+		GUEST_SYNC(type);
+	}
+
+	GUEST_DONE();
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
+	struct kvm_regs regs;
+	struct ucall uc;
+
+	/*
+	 * The guest takes 3 parameters (T val1, T val2, TYPE) which are set
+	 * in the parent call to allow run_tests() to be type-agnostic.
+	 */
+
+	vcpu_regs_get(vcpu, &regs);
+	regs.rip = (uintptr_t)guest_code;
+	vcpu_regs_set(vcpu, &regs);
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
+static void test_limits(void)
+{
+	const int buffer_len = UCALL_BUFFER_LEN + 10;
+	char test_str[buffer_len];
+	char test_res[buffer_len];
+	int r;
+
+	memset(test_str, 'a', buffer_len);
+	test_str[buffer_len - 1] = 0;
+
+	r = kvm_snprintf(test_res, UCALL_BUFFER_LEN, "%s", test_str);
+	TEST_ASSERT(r == (buffer_len - 1),
+		    "Unexpected kvm_snprintf() length.  Expected: %d, got: %d",
+		    buffer_len - 1, r);
+
+	r = strlen(test_res);
+	TEST_ASSERT(r == (UCALL_BUFFER_LEN - 1),
+		    "Unexpected strlen() length.  Expected: %d, got: %d",
+		    UCALL_BUFFER_LEN - 1, r);
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = vm_create_with_one_vcpu(&vcpu, NULL);
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
2.40.0.634.g4ca3ef3211-goog

