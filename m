Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA468656E03
	for <lists+kvm@lfdr.de>; Tue, 27 Dec 2022 19:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbiL0Si6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Dec 2022 13:38:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiL0Siy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Dec 2022 13:38:54 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F5B82639
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 10:38:53 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id f132-20020a636a8a000000b00473d0b600ebso6996078pgc.14
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 10:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lkceNBu3Cbfn5w2vNeWIIipWKDlu9o2a8WGB/CgbDnw=;
        b=k4lZfAxw0FDVLpd8uv3FYjCbKBP+DAdbJxul15ekbQRNy3Gcp3lbw8Aig7LPkFbJde
         WSiuvBFLqTKNHkseQc7nuIGap2OxSHDeql+U/tfyXutQZknXGTzW/B8RLYMCxD5FgBh3
         +ShtmjRqm7y1ZVb6VPJcr40rg8kOnUeYcUlIne6iSFrEAY7oidHwVb2vOTErPi7KSUEH
         NROdFjRjrWXlU+qOYH+WojKPFpA7Em9bHqFnOciFW0C5wCNCEMnSvfWGz7ZQtHQlOHwc
         rGqcq/6Bl+iGo1YU40vCMhW+I/Hdx0yVBfxI0Ey5zg8KDzYCi0nMlFv4M3SCBBC1wTvI
         VMTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lkceNBu3Cbfn5w2vNeWIIipWKDlu9o2a8WGB/CgbDnw=;
        b=UHEwvc1SMo7RNBbL/x8Tz03U3z++aGhctBxcuZC/kNaITiaYckNahEoBUw/KueoNuZ
         NsH2RE7/xKjXKSN/OxO3IuJyINjnRBH3f5Xg6+XA24fbsTChjv70v6TmCsgf0g/aP1Rs
         8ql8bwR2U0bK3qaRCd8N8aGqY3RKPz+n38plDy5UU5TsoWXHj8ghxCGaSKk09uWsAjhA
         T4ZE5JY60Xr9upgoSRIkCXO5SBvSxVQKvuVyPXIuj1edo4MeXnQ/qnOFLYZcvRhF3RTP
         mj6jK+/GrLnqkpItEFxvBz4JMTQmQc+lXpwQFTcF5bakmk43ffN/4beFCfgMefgQEqQy
         hN5A==
X-Gm-Message-State: AFqh2kqjc/LT4cvIJygQIEdX3r6Hn7U+CGogT5jJkDcUW7OZ0k2wnPk0
        HXdfnVbFuGtMjaED85Otg9nB6LT/z3F2KSuSNZxlqFfmhQxn4znP57aMMcep6Z3Q/zYtA1WvKvx
        AJ3NF7tEhmV7v1Q1htsPVue9+tJZ5yFaVI6KrG2Gopiia2RT8edPA6vhC2mPxO/lnPQqp
X-Google-Smtp-Source: AMrXdXt57ldBKeLCduhxiDS2UpSHsClNgc81Nghr4hblaBiDbgMlTtbqG/y25+dzHJl3OcpiVB5vAl8D6KSP0GEx
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90b:f0f:b0:225:eaa2:3f5d with SMTP
 id br15-20020a17090b0f0f00b00225eaa23f5dmr184386pjb.2.1672166332543; Tue, 27
 Dec 2022 10:38:52 -0800 (PST)
Date:   Tue, 27 Dec 2022 18:37:15 +0000
In-Reply-To: <20221227183713.29140-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20221227183713.29140-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221227183713.29140-4-aaronlewis@google.com>
Subject: [PATCH 3/3] KVM: selftests: Add XCR0 Test
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, Aaron Lewis <aaronlewis@google.com>
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

Test that the user xfeature bits, EDX:EAX of CPUID.(EAX=0DH,ECX=0),
don't set up userspace for failure.

Though it isn't architectural, test that the user xfeature bits aren't
set in a half baked state that will cause a #GP if used when setting
XCR0.

Check that the rules for XCR0 described in the SDM vol 1, section
13.3 ENABLING THE XSAVE FEATURE SET AND XSAVE-ENABLED FEATURES, are
followed for the xfeature bits too.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/xcr0_cpuid_test.c    | 134 ++++++++++++++++++
 2 files changed, 135 insertions(+)
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
index 0000000000000..644791ff5c48b
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
@@ -0,0 +1,134 @@
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
+#define XFEATURE_MASK_SSE		(1ul << 1)
+#define XFEATURE_MASK_YMM		(1ul << 2)
+#define XFEATURE_MASK_BNDREGS		(1ul << 3)
+#define XFEATURE_MASK_BNDCSR		(1ul << 4)
+#define XFEATURE_MASK_OPMASK		(1ul << 5)
+#define XFEATURE_MASK_ZMM_Hi256		(1ul << 6)
+#define XFEATURE_MASK_Hi16_ZMM		(1ul << 7)
+#define XFEATURE_MASK_XTILECFG		(1ul << 17)
+#define XFEATURE_MASK_XTILEDATA		(1ul << 18)
+#define XFEATURE_MASK_XTILE		(XFEATURE_MASK_XTILECFG | \
+					 XFEATURE_MASK_XTILEDATA)
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
+	xfeature_mask = XFEATURE_MASK_OPMASK |
+			XFEATURE_MASK_ZMM_Hi256 |
+			XFEATURE_MASK_Hi16_ZMM;
+	supported_state = supported_xcr0 & xfeature_mask;
+	GUEST_ASSERT((supported_state == xfeature_mask) ||
+		     (supported_state == 0ul));
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

