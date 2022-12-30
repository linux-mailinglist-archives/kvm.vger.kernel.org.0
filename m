Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105B0659A83
	for <lists+kvm@lfdr.de>; Fri, 30 Dec 2022 17:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235268AbiL3QZN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Dec 2022 11:25:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235245AbiL3QZK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Dec 2022 11:25:10 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C2A63FC
        for <kvm@vger.kernel.org>; Fri, 30 Dec 2022 08:25:09 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id s76-20020a632c4f000000b0049ceb0f185eso3231677pgs.7
        for <kvm@vger.kernel.org>; Fri, 30 Dec 2022 08:25:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yhfrk/52wm4AFDi/mc+1vvT+9S7e8FJyWcR7c7u9018=;
        b=X72w3/yvTPj9htBmgCtAdC4I8SVLEkBIAovj/08uPXmTTnP+vroEYAayaE8osUP3JS
         Y/qOwmEs7upvtMQk0yUNqdeCfaZOG+715CZ4M63ccIPp8OTMXLHsHvAfmqfANUWuSqe7
         g+N9/utfCb91iWcBsdzc9K9FtIRsUBS6Ta8Ttriq3h/8Tsr3AVhaKInKWUsgldAzU6eN
         HKUIH5C6jHYXWLcaHWYZb1RuxtY+3ed5pDT3PkcxRj771YCxOaovmZGrltd+YABwCYAV
         J2UsEUDd1yGC8rrEHBQIuiRXyIJkooof9zhc3UtQ3BWNKiEsBcY6Top3IOkxqP9p5j4L
         G5wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yhfrk/52wm4AFDi/mc+1vvT+9S7e8FJyWcR7c7u9018=;
        b=W+zrwT8lCxOdHzGS0qsv4thsVPqyAQF/o9iVRFCHJfQpzI6fFLTtODkLqtAwgQC9qc
         AnXiNERNXZk9nJgjfruCJICr0N5OPjS9tTocbwikxI8axTuSg9TFZXv7aJ17W/kOUo/O
         rbKDnz4hZX0EVX2J0a6BF27bwvee5k+vh1UlNLtduNyCy+G5D22UH4sFnQoQd/MTd+Zm
         meXBN6jEWWN+gpRRcslYlGFU1rj403KJNM+/9YW0QcHvOIoX/GSUpujgN/NBEwVyb5kM
         6cE6eHmoU8fol5qhVPHtarkzinOAuMHKRv5U0o2jvGW5ldEkESWJ9sQwGPJGImrhXCrL
         qE1A==
X-Gm-Message-State: AFqh2kqZgUqeKdffkROVTXkecawhKzyxAsTN4XW3EQ2qQhOk7M7IV4iB
        u+/yk7CuqM9oyyWLZdACn8grA22SoMqOUL9SFQ70qMJYhBOHP0Bh6O+Rf2/8PO2/hFOV593jlTq
        vvMPB0d5JD6EJCHj9QTeNLqLNRwp57mlETx22e7H/x4eYImDq+MVZ4DrB2h3mtRFtcDrA
X-Google-Smtp-Source: AMrXdXschlB8w7UUhl4ummy0bl+PrFAr096VJnWBusk4xBMciGhgGJVGb98Bs8EY62TD6ipx8RV3LUZPaS3ktQYh
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a63:d14a:0:b0:479:5a45:6d32 with SMTP
 id c10-20020a63d14a000000b004795a456d32mr1452676pgj.138.1672417508987; Fri,
 30 Dec 2022 08:25:08 -0800 (PST)
Date:   Fri, 30 Dec 2022 16:24:42 +0000
In-Reply-To: <20221230162442.3781098-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20221230162442.3781098-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221230162442.3781098-7-aaronlewis@google.com>
Subject: [PATCH v2 6/6] KVM: selftests: Add XCR0 Test
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test that the supported xfeatures, i.e. EDX:EAX of CPUID.(EAX=0DH,ECX=0),
don't set userspace up for failure.

Though it isn't architectural, test that the supported xfeatures
aren't set in a half baked state that will cause a #GP if used to
execute XSETBV.

Check that the rules for XCR0 described in the SDM vol 1, section
13.3 ENABLING THE XSAVE FEATURE SET AND XSAVE-ENABLED FEATURES, are
followed for the supported xfeatures too.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/xcr0_cpuid_test.c    | 121 ++++++++++++++++++
 2 files changed, 122 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 1750f91dd9362..e2e56c82b8a90 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -104,6 +104,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_nested_tsc_scaling_test
 TEST_GEN_PROGS_x86_64 += x86_64/xapic_ipi_test
 TEST_GEN_PROGS_x86_64 += x86_64/xapic_state_test
+TEST_GEN_PROGS_x86_64 += x86_64/xcr0_cpuid_test
 TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
 TEST_GEN_PROGS_x86_64 += x86_64/debug_regs
 TEST_GEN_PROGS_x86_64 += x86_64/tsc_msrs_test
diff --git a/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
new file mode 100644
index 0000000000000..6bef362872154
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
@@ -0,0 +1,121 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * XCR0 cpuid test
+ *
+ * Copyright (C) 2022, Google LLC.
+ */
+
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+
+#include "test_util.h"
+
+#include "kvm_util.h"
+#include "processor.h"
+
+static uint64_t get_supported_user_xfeatures(void)
+{
+	uint32_t a, b, c, d;
+
+	cpuid(0xd, &a, &b, &c, &d);
+
+	return a | ((uint64_t)d << 32);
+}
+
+static void guest_code(void)
+{
+	uint64_t xcr0_rest;
+	uint64_t supported_xcr0;
+	uint64_t xfeature_mask;
+	uint64_t supported_state;
+
+	set_cr4(get_cr4() | X86_CR4_OSXSAVE);
+
+	xcr0_rest = xgetbv(0);
+	supported_xcr0 = get_supported_user_xfeatures();
+
+	GUEST_ASSERT(xcr0_rest == 1ul);
+
+	/* Check AVX */
+	xfeature_mask = XFEATURE_MASK_SSE | XFEATURE_MASK_YMM;
+	supported_state = supported_xcr0 & xfeature_mask;
+	GUEST_ASSERT(supported_state != XFEATURE_MASK_YMM);
+
+	/* Check MPX */
+	xfeature_mask = XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR;
+	supported_state = supported_xcr0 & xfeature_mask;
+	GUEST_ASSERT((supported_state == xfeature_mask) ||
+		     (supported_state == 0ul));
+
+	/* Check AVX-512 */
+	xfeature_mask = XFEATURE_MASK_SSE | XFEATURE_MASK_YMM |
+			XFEATURE_MASK_AVX512;
+	supported_state = supported_xcr0 & xfeature_mask;
+	GUEST_ASSERT((supported_state == xfeature_mask) ||
+		     ((supported_state & XFEATURE_MASK_AVX512) == 0ul));
+
+	/* Check AMX */
+	xfeature_mask = XFEATURE_MASK_XTILE;
+	supported_state = supported_xcr0 & xfeature_mask;
+	GUEST_ASSERT((supported_state == xfeature_mask) ||
+		     (supported_state == 0ul));
+
+	GUEST_SYNC(0);
+
+	xsetbv(0, supported_xcr0);
+
+	GUEST_DONE();
+}
+
+static void guest_gp_handler(struct ex_regs *regs)
+{
+	GUEST_ASSERT(!"Failed to set the supported xfeature bits in XCR0.");
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_run *run;
+	struct kvm_vm *vm;
+	struct ucall uc;
+
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XSAVE));
+
+	/* Tell stdout not to buffer its content */
+	setbuf(stdout, NULL);
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	run = vcpu->run;
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vcpu);
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
+			vm_install_exception_handler(vm, GP_VECTOR,
+						     guest_gp_handler);
+			break;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	}
+
+done:
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.39.0.314.g84b9a713c41-goog

