Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15F906A245D
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 23:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjBXWhT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 17:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbjBXWhR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 17:37:17 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600D16F424
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 14:37:14 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id w130-20020a628288000000b005d1f4325e2aso212660pfd.18
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 14:37:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xLpEAeFTPW1MFSWD7xv6rlX3YaUbF9PKs2AOEdTxWsw=;
        b=SFw6iz617GhWiNMkRf84ki28hexiMmRsDaKqbzVPlBQP4zjCcEb06c88ty3riEhjn0
         f/6FB7XUkDmzqB6P2IhCExdwVEvCp3y3qaKLg3PEMPg3O8uA6Lzap5TuK8auUhyGZLP7
         yMOXp+ZtgEOnhbC3k6QP74HMZv3V4OuAJw7u/f2whGjGOp45qEzwfNp8D4waFfoqDLZt
         puRHy8jP+n1WdQexGdMol21S/9VyzfvQeIMUOg3VhR5gSNUL4PoTBFTvz1Ius1epZ+r7
         Xq7X4Uo1l3XMmLLf+RhAKe/2OZLI033l/uBpzjg/fv7+T9k3XAkukaH7KwQOFPGOrHHc
         8DQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xLpEAeFTPW1MFSWD7xv6rlX3YaUbF9PKs2AOEdTxWsw=;
        b=72Q8Vqc/nWM9B0fU9Ywhsh3LyqiRx6QTYkY1ZfmvGg9lT0Cz/ya9Kx8EpEIZsDdkV1
         dIhEdUN7RsWht2Wgi/z9b5dVqJV9cZ4FVRGqz2Jr/LTJguzoFODh16ZI9sfTnD5Y0fj9
         sr7VIKn2/vrdhANzqt+DuHcLXNtWAsW50Zr2jk+PIAdpqrGR6XwwM6vIiHTDBjSyZqQ8
         byvBz59LqOgK17sboqb1+pX+HC/7tE2cQYjMRzYx33Td4cY4rsAROSH+z7p3FCRSGkTK
         cvtI6pjMXly4KGaVD+Ke72AaLAKacyCfndWI+vfO9alzoyQTsZC8c2Z+HlaYjRBY5aDB
         augA==
X-Gm-Message-State: AO0yUKWXmr1V5Rjnl0XivUI0KpoUJ3rymt9f2e/cnKjr8r9wwO92XHj2
        DQvUg08RUaZuJtC+txTsB67Kimngeq3XKGrpYUoewuNw2On7q9meZ9DNY2X/INydVCcRkPWAza+
        32nPh4d40wELAIn8NvWGt0bsFMkSBkIge8JEw0AmYmFjuXJifK9kbt9T/4OWio/skwxQ3
X-Google-Smtp-Source: AK7set8TzTBS/L2mHE+tmM5wZ0n7eRhVyXCFhkSLCK5B98Dyz9YuxYQjgD2cF0UBnPXjFNtt6poqx+nP2rngGKqe
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a17:90a:17ec:b0:237:30ef:e252 with SMTP
 id q99-20020a17090a17ec00b0023730efe252mr2220850pja.9.1677278233766; Fri, 24
 Feb 2023 14:37:13 -0800 (PST)
Date:   Fri, 24 Feb 2023 22:36:07 +0000
In-Reply-To: <20230224223607.1580880-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230224223607.1580880-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230224223607.1580880-9-aaronlewis@google.com>
Subject: [PATCH v3 8/8] KVM: selftests: Add XCR0 Test
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        mizhang@google.com, Aaron Lewis <aaronlewis@google.com>
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

Check both architectural rules and KVM's own software-defined rules to
ensure the supported xfeatures[1] don't violate any of them.

The architectural rules[2] and KVM's rules ensure for a given
feature, e.g. sse, avx, amx, etc... their associated xfeatures are
either all sets or none of them are set, and any dependencies
are enabled if needed.

[1] EDX:EAX of CPUID.(EAX=0DH,ECX=0)
[2] SDM vol 1, 13.3 ENABLING THE XSAVE FEATURE SET AND XSAVE-ENABLED
    FEATURES

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/processor.h  |  17 +++
 .../selftests/kvm/x86_64/xcr0_cpuid_test.c    | 128 ++++++++++++++++++
 3 files changed, 146 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 84a627c43795..18cadc669798 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -105,6 +105,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_nested_tsc_scaling_test
 TEST_GEN_PROGS_x86_64 += x86_64/xapic_ipi_test
 TEST_GEN_PROGS_x86_64 += x86_64/xapic_state_test
+TEST_GEN_PROGS_x86_64 += x86_64/xcr0_cpuid_test
 TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
 TEST_GEN_PROGS_x86_64 += x86_64/debug_regs
 TEST_GEN_PROGS_x86_64 += x86_64/tsc_msrs_test
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index ebe83cfe521c..380daa82b023 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -667,6 +667,15 @@ static inline bool this_pmu_has(struct kvm_x86_pmu_feature feature)
 	       !this_cpu_has(feature.anti_feature);
 }
 
+static __always_inline uint64_t this_cpu_supported_xcr0(void)
+{
+	uint32_t a, b, c, d;
+
+	cpuid(0xd, &a, &b, &c, &d);
+
+	return a | ((uint64_t)d << 32);
+}
+
 typedef u32		__attribute__((vector_size(16))) sse128_t;
 #define __sse128_u	union { sse128_t vec; u64 as_u64[2]; u32 as_u32[4]; }
 #define sse128_lo(x)	({ __sse128_u t; t.vec = x; t.as_u64[0]; })
@@ -1090,6 +1099,14 @@ static inline uint8_t wrmsr_safe(uint32_t msr, uint64_t val)
 	return kvm_asm_safe("wrmsr", "a"(val & -1u), "d"(val >> 32), "c"(msr));
 }
 
+static inline uint8_t xsetbv_safe(uint32_t index, uint64_t value)
+{
+	u32 eax = value;
+	u32 edx = value >> 32;
+
+	return kvm_asm_safe("xsetbv", "a" (eax), "d" (edx), "c" (index));
+}
+
 bool kvm_is_tdp_enabled(void);
 
 uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
diff --git a/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
new file mode 100644
index 000000000000..7ca0dea3d144
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
@@ -0,0 +1,128 @@
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
+/* Architectural check. */
+#define ASSERT_XFEATURE_DEPENDENCIES(supported_xcr0, xfeatures, dependencies)	  \
+do {										  \
+	uint64_t __supported = (supported_xcr0) & ((xfeatures) | (dependencies)); \
+										  \
+	GUEST_ASSERT_3((__supported & (xfeatures)) != (xfeatures) ||		  \
+		       __supported == ((xfeatures) | (dependencies)),		  \
+		       __supported, (xfeatures), (dependencies));		  \
+} while (0)
+
+/*
+ * KVM's own software-defined rules.  While not architectural it really
+ * ought to be true.
+ */
+#define ASSERT_ALL_OR_NONE_XFEATURE(supported_xcr0, xfeatures)		\
+do {									\
+	uint64_t __supported = (supported_xcr0) & (xfeatures);		\
+									\
+	GUEST_ASSERT_2(!__supported || __supported == (xfeatures),	\
+		       __supported, (xfeatures));			\
+} while (0)
+
+static void guest_code(void)
+{
+	uint64_t xcr0_reset;
+	uint64_t supported_xcr0;
+	int i, vector;
+
+	set_cr4(get_cr4() | X86_CR4_OSXSAVE);
+
+	xcr0_reset = xgetbv(0);
+	supported_xcr0 = this_cpu_supported_xcr0();
+
+	GUEST_ASSERT(xcr0_reset == XFEATURE_MASK_FP);
+
+	/* Check AVX */
+	ASSERT_XFEATURE_DEPENDENCIES(supported_xcr0,
+				     XFEATURE_MASK_YMM,
+				     XFEATURE_MASK_SSE);
+
+	/* Check MPX */
+	ASSERT_ALL_OR_NONE_XFEATURE(supported_xcr0,
+				    XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
+
+	/* Check AVX-512 */
+	ASSERT_XFEATURE_DEPENDENCIES(supported_xcr0,
+				     XFEATURE_MASK_AVX512,
+				     XFEATURE_MASK_SSE | XFEATURE_MASK_YMM);
+	ASSERT_ALL_OR_NONE_XFEATURE(supported_xcr0,
+				    XFEATURE_MASK_AVX512);
+
+	/* Check AMX */
+	ASSERT_ALL_OR_NONE_XFEATURE(supported_xcr0,
+				    XFEATURE_MASK_XTILE);
+
+	vector = xsetbv_safe(0, supported_xcr0);
+	GUEST_ASSERT_2(!vector, supported_xcr0, vector);
+
+	for (i = 0; i < 64; i++) {
+		if (supported_xcr0 & BIT_ULL(i))
+			continue;
+
+		vector = xsetbv_safe(0, supported_xcr0 | BIT_ULL(i));
+		GUEST_ASSERT_3(vector == GP_VECTOR, supported_xcr0, vector, BIT_ULL(i));
+	}
+
+	GUEST_DONE();
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
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT_3(uc, "0x%lx 0x%lx 0x%lx");
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
2.39.2.637.g21b0678d19-goog

