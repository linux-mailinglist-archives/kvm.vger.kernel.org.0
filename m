Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929E3367695
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 02:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242027AbhDVA5O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 20:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240786AbhDVA5O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 20:57:14 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6808AC06138A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 17:56:40 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id 59-20020a1709020241b02900e8de254a18so19151585plc.14
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 17:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XxDAh3fhzg5A8awaqIQozL0a7udxHE7UvhfJ/Wi4USQ=;
        b=OKzNJGs7evpkAgOjHMv/92KXILF1CXt1OoiqCa3/sFn+5Tiwyhbke+MVLj00a+QOQK
         W7Yrpe3/8/7w+6jmkjAWhZ6rim6es/ZqzjZjI5KtW92IgYhG/S4rtkcwxTm1jSctmdyw
         GzbCakasmyLuCDfYUgH5UCLR7gs8yvtx046Nv0VaRZ8TGXDSzFTNdbEDrqXAd9kUCK5u
         3JpGsusiKCfOpONHLg+mTBNwbCBZDCKX8gTLxqATf9O+QOjjYM4jCAFt16kCO7GTKdT8
         iEc7S5RdVChyd+fSHctUtWFA338V7T4HuaQ0p5zpR51sn6JCNbtXOzOMxUbOeWEXJwLQ
         z82g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XxDAh3fhzg5A8awaqIQozL0a7udxHE7UvhfJ/Wi4USQ=;
        b=eqC4pA8OWAH2y7PrZgpnhDIKwmgOcjoMy0pU0F/N8Nj+vI+os7dOqVlwXM2z9v2NxP
         I+xQG67E9nZvkpnVuTYpA0cLM83c+otuqHJrZMxs5LnwzTu6619MzG7gtNEcNpiO2N1i
         mHbDae2cBLfa+SZGMY2m5srcyg4J9OHuRlwkRuD5g8KGJ3E1XANgvTSn4Rn/kFWkmHG3
         HnTtNpFByjtTvQq6ipf/gdtdW3dB9wm5Y3rAe3xakm7xpxoCIH/LHkmWICJlv3lTz7Yw
         pGsJFjIOhsZgbuMulDRwRJGzAIAKLRyIUbM1Fj9viVk3BnyPqXr3LDCAWHqu3/fZ0Rrf
         31UA==
X-Gm-Message-State: AOAM533pviM0SJ6HhUfOuZ3oucLXamLRT0ziru4C1MQtZtWuIWO+NmIl
        Y2Pi0knVWKh0/zhdXBLiqPCr/tSG44Zlxw==
X-Google-Smtp-Source: ABdhPJytWStGBaql7sF4DNf3GoW+tjXcAJaAsgYk0ZcCMM/ByrNRJa463UMEIpmgYtWq8wO9TgWiGOhfc+BiQA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:aa7:87d5:0:b029:25a:b5f8:15ab with SMTP
 id i21-20020aa787d50000b029025ab5f815abmr861328pfo.22.1619052999831; Wed, 21
 Apr 2021 17:56:39 -0700 (PDT)
Date:   Wed, 21 Apr 2021 17:56:22 -0700
In-Reply-To: <20210422005626.564163-1-ricarkol@google.com>
Message-Id: <20210422005626.564163-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20210422005626.564163-1-ricarkol@google.com>
X-Mailer: git-send-email 2.31.1.368.gbe11c130af-goog
Subject: [PATCH 1/5] KVM: x86: Move reverse CPUID helpers to separate header file
From:   Ricardo Koller <ricarkol@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Split out the reverse CPUID machinery to a dedicated header file
so that KVM selftests can reuse the reverse CPUID definitions without
introducing any '#ifdef __KERNEL__' pollution.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/x86/kvm/cpuid.h         | 177 +--------------------------------
 arch/x86/kvm/reverse_cpuid.h | 185 +++++++++++++++++++++++++++++++++++
 2 files changed, 186 insertions(+), 176 deletions(-)
 create mode 100644 arch/x86/kvm/reverse_cpuid.h

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 888e88b42e8d..6132ed3c6ebf 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -3,28 +3,11 @@
 #define ARCH_X86_KVM_CPUID_H
 
 #include "x86.h"
+#include "reverse_cpuid.h"
 #include <asm/cpu.h>
 #include <asm/processor.h>
 #include <uapi/asm/kvm_para.h>
 
-/*
- * Hardware-defined CPUID leafs that are scattered in the kernel, but need to
- * be directly used by KVM.  Note, these word values conflict with the kernel's
- * "bug" caps, but KVM doesn't use those.
- */
-enum kvm_only_cpuid_leafs {
-	CPUID_12_EAX	 = NCAPINTS,
-	NR_KVM_CPU_CAPS,
-
-	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
-};
-
-#define KVM_X86_FEATURE(w, f)		((w)*32 + (f))
-
-/* Intel-defined SGX sub-features, CPUID level 0x12 (EAX). */
-#define KVM_X86_FEATURE_SGX1		KVM_X86_FEATURE(CPUID_12_EAX, 0)
-#define KVM_X86_FEATURE_SGX2		KVM_X86_FEATURE(CPUID_12_EAX, 1)
-
 extern u32 kvm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
 void kvm_set_cpu_caps(void);
 
@@ -76,164 +59,6 @@ static inline bool page_address_valid(struct kvm_vcpu *vcpu, gpa_t gpa)
 	return kvm_vcpu_is_legal_aligned_gpa(vcpu, gpa, PAGE_SIZE);
 }
 
-struct cpuid_reg {
-	u32 function;
-	u32 index;
-	int reg;
-};
-
-static const struct cpuid_reg reverse_cpuid[] = {
-	[CPUID_1_EDX]         = {         1, 0, CPUID_EDX},
-	[CPUID_8000_0001_EDX] = {0x80000001, 0, CPUID_EDX},
-	[CPUID_8086_0001_EDX] = {0x80860001, 0, CPUID_EDX},
-	[CPUID_1_ECX]         = {         1, 0, CPUID_ECX},
-	[CPUID_C000_0001_EDX] = {0xc0000001, 0, CPUID_EDX},
-	[CPUID_8000_0001_ECX] = {0x80000001, 0, CPUID_ECX},
-	[CPUID_7_0_EBX]       = {         7, 0, CPUID_EBX},
-	[CPUID_D_1_EAX]       = {       0xd, 1, CPUID_EAX},
-	[CPUID_8000_0008_EBX] = {0x80000008, 0, CPUID_EBX},
-	[CPUID_6_EAX]         = {         6, 0, CPUID_EAX},
-	[CPUID_8000_000A_EDX] = {0x8000000a, 0, CPUID_EDX},
-	[CPUID_7_ECX]         = {         7, 0, CPUID_ECX},
-	[CPUID_8000_0007_EBX] = {0x80000007, 0, CPUID_EBX},
-	[CPUID_7_EDX]         = {         7, 0, CPUID_EDX},
-	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
-	[CPUID_12_EAX]        = {0x00000012, 0, CPUID_EAX},
-};
-
-/*
- * Reverse CPUID and its derivatives can only be used for hardware-defined
- * feature words, i.e. words whose bits directly correspond to a CPUID leaf.
- * Retrieving a feature bit or masking guest CPUID from a Linux-defined word
- * is nonsensical as the bit number/mask is an arbitrary software-defined value
- * and can't be used by KVM to query/control guest capabilities.  And obviously
- * the leaf being queried must have an entry in the lookup table.
- */
-static __always_inline void reverse_cpuid_check(unsigned int x86_leaf)
-{
-	BUILD_BUG_ON(x86_leaf == CPUID_LNX_1);
-	BUILD_BUG_ON(x86_leaf == CPUID_LNX_2);
-	BUILD_BUG_ON(x86_leaf == CPUID_LNX_3);
-	BUILD_BUG_ON(x86_leaf == CPUID_LNX_4);
-	BUILD_BUG_ON(x86_leaf >= ARRAY_SIZE(reverse_cpuid));
-	BUILD_BUG_ON(reverse_cpuid[x86_leaf].function == 0);
-}
-
-/*
- * Translate feature bits that are scattered in the kernel's cpufeatures word
- * into KVM feature words that align with hardware's definitions.
- */
-static __always_inline u32 __feature_translate(int x86_feature)
-{
-	if (x86_feature == X86_FEATURE_SGX1)
-		return KVM_X86_FEATURE_SGX1;
-	else if (x86_feature == X86_FEATURE_SGX2)
-		return KVM_X86_FEATURE_SGX2;
-
-	return x86_feature;
-}
-
-static __always_inline u32 __feature_leaf(int x86_feature)
-{
-	return __feature_translate(x86_feature) / 32;
-}
-
-/*
- * Retrieve the bit mask from an X86_FEATURE_* definition.  Features contain
- * the hardware defined bit number (stored in bits 4:0) and a software defined
- * "word" (stored in bits 31:5).  The word is used to index into arrays of
- * bit masks that hold the per-cpu feature capabilities, e.g. this_cpu_has().
- */
-static __always_inline u32 __feature_bit(int x86_feature)
-{
-	x86_feature = __feature_translate(x86_feature);
-
-	reverse_cpuid_check(x86_feature / 32);
-	return 1 << (x86_feature & 31);
-}
-
-#define feature_bit(name)  __feature_bit(X86_FEATURE_##name)
-
-static __always_inline struct cpuid_reg x86_feature_cpuid(unsigned int x86_feature)
-{
-	unsigned int x86_leaf = __feature_leaf(x86_feature);
-
-	reverse_cpuid_check(x86_leaf);
-	return reverse_cpuid[x86_leaf];
-}
-
-static __always_inline u32 *__cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry,
-						  u32 reg)
-{
-	switch (reg) {
-	case CPUID_EAX:
-		return &entry->eax;
-	case CPUID_EBX:
-		return &entry->ebx;
-	case CPUID_ECX:
-		return &entry->ecx;
-	case CPUID_EDX:
-		return &entry->edx;
-	default:
-		BUILD_BUG();
-		return NULL;
-	}
-}
-
-static __always_inline u32 *cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry,
-						unsigned int x86_feature)
-{
-	const struct cpuid_reg cpuid = x86_feature_cpuid(x86_feature);
-
-	return __cpuid_entry_get_reg(entry, cpuid.reg);
-}
-
-static __always_inline u32 cpuid_entry_get(struct kvm_cpuid_entry2 *entry,
-					   unsigned int x86_feature)
-{
-	u32 *reg = cpuid_entry_get_reg(entry, x86_feature);
-
-	return *reg & __feature_bit(x86_feature);
-}
-
-static __always_inline bool cpuid_entry_has(struct kvm_cpuid_entry2 *entry,
-					    unsigned int x86_feature)
-{
-	return cpuid_entry_get(entry, x86_feature);
-}
-
-static __always_inline void cpuid_entry_clear(struct kvm_cpuid_entry2 *entry,
-					      unsigned int x86_feature)
-{
-	u32 *reg = cpuid_entry_get_reg(entry, x86_feature);
-
-	*reg &= ~__feature_bit(x86_feature);
-}
-
-static __always_inline void cpuid_entry_set(struct kvm_cpuid_entry2 *entry,
-					    unsigned int x86_feature)
-{
-	u32 *reg = cpuid_entry_get_reg(entry, x86_feature);
-
-	*reg |= __feature_bit(x86_feature);
-}
-
-static __always_inline void cpuid_entry_change(struct kvm_cpuid_entry2 *entry,
-					       unsigned int x86_feature,
-					       bool set)
-{
-	u32 *reg = cpuid_entry_get_reg(entry, x86_feature);
-
-	/*
-	 * Open coded instead of using cpuid_entry_{clear,set}() to coerce the
-	 * compiler into using CMOV instead of Jcc when possible.
-	 */
-	if (set)
-		*reg |= __feature_bit(x86_feature);
-	else
-		*reg &= ~__feature_bit(x86_feature);
-}
-
 static __always_inline void cpuid_entry_override(struct kvm_cpuid_entry2 *entry,
 						 enum cpuid_leafs leaf)
 {
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
new file mode 100644
index 000000000000..8e0756ddab1a
--- /dev/null
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -0,0 +1,185 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef ARCH_X86_KVM_REVERSE_CPUID_H
+#define ARCH_X86_KVM_REVERSE_CPUID_H
+
+#include <uapi/asm/kvm.h>
+#include <asm/cpufeature.h>
+#include <asm/cpufeatures.h>
+
+/*
+ * Hardware-defined CPUID leafs that are scattered in the kernel, but need to
+ * be directly used by KVM.  Note, these word values conflict with the kernel's
+ * "bug" caps, but KVM doesn't use those.
+ */
+enum kvm_only_cpuid_leafs {
+	CPUID_12_EAX	 = NCAPINTS,
+	NR_KVM_CPU_CAPS,
+
+	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
+};
+
+#define KVM_X86_FEATURE(w, f)		((w)*32 + (f))
+
+/* Intel-defined SGX sub-features, CPUID level 0x12 (EAX). */
+#define KVM_X86_FEATURE_SGX1		KVM_X86_FEATURE(CPUID_12_EAX, 0)
+#define KVM_X86_FEATURE_SGX2		KVM_X86_FEATURE(CPUID_12_EAX, 1)
+
+struct cpuid_reg {
+	u32 function;
+	u32 index;
+	int reg;
+};
+
+static const struct cpuid_reg reverse_cpuid[] = {
+	[CPUID_1_EDX]         = {         1, 0, CPUID_EDX},
+	[CPUID_8000_0001_EDX] = {0x80000001, 0, CPUID_EDX},
+	[CPUID_8086_0001_EDX] = {0x80860001, 0, CPUID_EDX},
+	[CPUID_1_ECX]         = {         1, 0, CPUID_ECX},
+	[CPUID_C000_0001_EDX] = {0xc0000001, 0, CPUID_EDX},
+	[CPUID_8000_0001_ECX] = {0x80000001, 0, CPUID_ECX},
+	[CPUID_7_0_EBX]       = {         7, 0, CPUID_EBX},
+	[CPUID_D_1_EAX]       = {       0xd, 1, CPUID_EAX},
+	[CPUID_8000_0008_EBX] = {0x80000008, 0, CPUID_EBX},
+	[CPUID_6_EAX]         = {         6, 0, CPUID_EAX},
+	[CPUID_8000_000A_EDX] = {0x8000000a, 0, CPUID_EDX},
+	[CPUID_7_ECX]         = {         7, 0, CPUID_ECX},
+	[CPUID_8000_0007_EBX] = {0x80000007, 0, CPUID_EBX},
+	[CPUID_7_EDX]         = {         7, 0, CPUID_EDX},
+	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
+	[CPUID_12_EAX]        = {0x00000012, 0, CPUID_EAX},
+};
+
+/*
+ * Reverse CPUID and its derivatives can only be used for hardware-defined
+ * feature words, i.e. words whose bits directly correspond to a CPUID leaf.
+ * Retrieving a feature bit or masking guest CPUID from a Linux-defined word
+ * is nonsensical as the bit number/mask is an arbitrary software-defined value
+ * and can't be used by KVM to query/control guest capabilities.  And obviously
+ * the leaf being queried must have an entry in the lookup table.
+ */
+static __always_inline void reverse_cpuid_check(unsigned int x86_leaf)
+{
+	BUILD_BUG_ON(x86_leaf == CPUID_LNX_1);
+	BUILD_BUG_ON(x86_leaf == CPUID_LNX_2);
+	BUILD_BUG_ON(x86_leaf == CPUID_LNX_3);
+	BUILD_BUG_ON(x86_leaf == CPUID_LNX_4);
+	BUILD_BUG_ON(x86_leaf >= ARRAY_SIZE(reverse_cpuid));
+	BUILD_BUG_ON(reverse_cpuid[x86_leaf].function == 0);
+}
+
+/*
+ * Translate feature bits that are scattered in the kernel's cpufeatures word
+ * into KVM feature words that align with hardware's definitions.
+ */
+static __always_inline u32 __feature_translate(int x86_feature)
+{
+	if (x86_feature == X86_FEATURE_SGX1)
+		return KVM_X86_FEATURE_SGX1;
+	else if (x86_feature == X86_FEATURE_SGX2)
+		return KVM_X86_FEATURE_SGX2;
+
+	return x86_feature;
+}
+
+static __always_inline u32 __feature_leaf(int x86_feature)
+{
+	return __feature_translate(x86_feature) / 32;
+}
+
+/*
+ * Retrieve the bit mask from an X86_FEATURE_* definition.  Features contain
+ * the hardware defined bit number (stored in bits 4:0) and a software defined
+ * "word" (stored in bits 31:5).  The word is used to index into arrays of
+ * bit masks that hold the per-cpu feature capabilities, e.g. this_cpu_has().
+ */
+static __always_inline u32 __feature_bit(int x86_feature)
+{
+	x86_feature = __feature_translate(x86_feature);
+
+	reverse_cpuid_check(x86_feature / 32);
+	return 1 << (x86_feature & 31);
+}
+
+#define feature_bit(name)  __feature_bit(X86_FEATURE_##name)
+
+static __always_inline struct cpuid_reg x86_feature_cpuid(unsigned int x86_feature)
+{
+	unsigned int x86_leaf = __feature_leaf(x86_feature);
+
+	reverse_cpuid_check(x86_leaf);
+	return reverse_cpuid[x86_leaf];
+}
+
+static __always_inline u32 *__cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry,
+						  u32 reg)
+{
+	switch (reg) {
+	case CPUID_EAX:
+		return &entry->eax;
+	case CPUID_EBX:
+		return &entry->ebx;
+	case CPUID_ECX:
+		return &entry->ecx;
+	case CPUID_EDX:
+		return &entry->edx;
+	default:
+		BUILD_BUG();
+		return NULL;
+	}
+}
+
+static __always_inline u32 *cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry,
+						unsigned int x86_feature)
+{
+	const struct cpuid_reg cpuid = x86_feature_cpuid(x86_feature);
+
+	return __cpuid_entry_get_reg(entry, cpuid.reg);
+}
+
+static __always_inline u32 cpuid_entry_get(struct kvm_cpuid_entry2 *entry,
+					   unsigned int x86_feature)
+{
+	u32 *reg = cpuid_entry_get_reg(entry, x86_feature);
+
+	return *reg & __feature_bit(x86_feature);
+}
+
+static __always_inline bool cpuid_entry_has(struct kvm_cpuid_entry2 *entry,
+					    unsigned int x86_feature)
+{
+	return cpuid_entry_get(entry, x86_feature);
+}
+
+static __always_inline void cpuid_entry_clear(struct kvm_cpuid_entry2 *entry,
+					      unsigned int x86_feature)
+{
+	u32 *reg = cpuid_entry_get_reg(entry, x86_feature);
+
+	*reg &= ~__feature_bit(x86_feature);
+}
+
+static __always_inline void cpuid_entry_set(struct kvm_cpuid_entry2 *entry,
+					    unsigned int x86_feature)
+{
+	u32 *reg = cpuid_entry_get_reg(entry, x86_feature);
+
+	*reg |= __feature_bit(x86_feature);
+}
+
+static __always_inline void cpuid_entry_change(struct kvm_cpuid_entry2 *entry,
+					       unsigned int x86_feature,
+					       bool set)
+{
+	u32 *reg = cpuid_entry_get_reg(entry, x86_feature);
+
+	/*
+	 * Open coded instead of using cpuid_entry_{clear,set}() to coerce the
+	 * compiler into using CMOV instead of Jcc when possible.
+	 */
+	if (set)
+		*reg |= __feature_bit(x86_feature);
+	else
+		*reg &= ~__feature_bit(x86_feature);
+}
+
+#endif /* ARCH_X86_KVM_REVERSE_CPUID_H */
-- 
2.31.1.368.gbe11c130af-goog

