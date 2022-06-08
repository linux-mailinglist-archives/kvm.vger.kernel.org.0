Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12F0A544023
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 01:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbiFHXvB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 19:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235144AbiFHXu5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 19:50:57 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A76916A51D
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 16:52:47 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id e189-20020a6369c6000000b003fd31d5990fso7497180pgc.20
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 16:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=5POHikrtbL73csmdMiWjA/5IMzV8ce4yDJ9riky0UL4=;
        b=KAPIf+YqVzHSeC2jUtdouVCXG3AWis+x937xGHKAzgubpL7LsGUtL6o5eBZTdS4I5x
         ME5LelyHl5IJYE0TuOk6exATJI9eHAykxqTdjuFV1hoHEIOrblQWcooucQOuVW1IeHRf
         +wRG9K/pSdWOyUtjSRzMInOmBNJsgAO3lUQ39OzygReeIo174N9l12gkqhpDM0MBT3cN
         /IlwXVqoKUsIPs/W3mQjCtfTtdNu2XNr5iO09b7q81Q2/Ky6EUqfPZRVmmDyXKmhr9kE
         pM8GBNiQp8YnIj92s2jb8Pd5c3/STi3bScjzkSFZdUww1viEj7ZnAkXfY5uFZ3a4+7ra
         G5zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=5POHikrtbL73csmdMiWjA/5IMzV8ce4yDJ9riky0UL4=;
        b=eUmG85QYDXZS7mp75OrGhNHiNnCoe9UNz/SwvbclLmOLXeTz8kBL38e3TUB53FHg7n
         8oW/CWW1MRKwSjpskTMsEpZ9Rgsjg6WsaWeGboYeRYlPczjCR/NB+pE2QAswqLQ2IsCb
         Y1JQNlHaLodiFeqLjsReDWhM4BReJO3r6l+8MLqMTAJyGKAZONdRM2+Z1/m6SzYjoI6A
         jKD7eqsdL9CpN6elnANyiVHxIHisV7HVXKAGmVccXknQDhzAWMC7Y3jrFDa4Y3x1J2uP
         KaHqi+WYRXLCTed8mnpojV09/Jo3+t+Vh5puh5iqG2zxpVpU/05hbhrktm4jc5tClri1
         c3AQ==
X-Gm-Message-State: AOAM533agHmz1PrCZIAYbnzVE1hKRj62ptPuAkqU0mPTpfV8eIfxmNY7
        t6cUjlQxCzs6clBPF/RZOQI8EeIXLnA=
X-Google-Smtp-Source: ABdhPJz1cfFikNJetSjqwnubeDtUh6sb9UBHCFmGH8EzhAiBP2uDVKDb7qVHPfdjHaTf2Zn/nUlIotDBQ/M=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:c5c3:0:b0:51b:a11c:201f with SMTP id
 j186-20020a62c5c3000000b0051ba11c201fmr36974881pfg.71.1654732366599; Wed, 08
 Jun 2022 16:52:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Jun 2022 23:52:31 +0000
In-Reply-To: <20220608235238.3881916-1-seanjc@google.com>
Message-Id: <20220608235238.3881916-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220608235238.3881916-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [kvm-unit-tests PATCH 03/10] x86: Use "safe" terminology instead of "checking"
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
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

Rename all helpers that eat (and return) exceptions to use "safe" instead
of "checking".  This aligns KUT with the kernel and KVM selftests.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/desc.c      |  2 +-
 lib/x86/desc.h      |  2 +-
 lib/x86/processor.h |  4 ++--
 x86/access.c        |  8 ++++----
 x86/la57.c          |  2 +-
 x86/msr.c           |  4 ++--
 x86/pcid.c          | 22 +++++++++++-----------
 x86/rdpru.c         |  4 ++--
 x86/vmx.c           |  4 ++--
 x86/vmx.h           |  2 +-
 x86/vmx_tests.c     |  6 +++---
 x86/xsave.c         | 30 +++++++++++++++---------------
 12 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 0677fcd9..ff9bd6b7 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -299,7 +299,7 @@ unsigned exception_vector(void)
 	return this_cpu_read_exception_vector();
 }
 
-int write_cr4_checking(unsigned long val)
+int write_cr4_safe(unsigned long val)
 {
 	asm volatile(ASM_TRY("1f")
 		"mov %0,%%cr4\n\t"
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 5224b58b..0bd44445 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -213,7 +213,7 @@ extern tss64_t tss[];
 extern gdt_entry_t gdt[];
 
 unsigned exception_vector(void);
-int write_cr4_checking(unsigned long val);
+int write_cr4_safe(unsigned long val);
 unsigned exception_error_code(void);
 bool exception_rflags_rf(void);
 void set_idt_entry(int vec, void *addr, int dpl);
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 13d9d9bb..e169aac8 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -354,7 +354,7 @@ static inline void wrmsr(u32 index, u64 val)
 	asm volatile ("wrmsr" : : "a"(a), "d"(d), "c"(index) : "memory");
 }
 
-static inline int rdmsr_checking(u32 index)
+static inline int rdmsr_safe(u32 index)
 {
 	asm volatile (ASM_TRY("1f")
 		      "rdmsr\n\t"
@@ -363,7 +363,7 @@ static inline int rdmsr_checking(u32 index)
 	return exception_vector();
 }
 
-static inline int wrmsr_checking(u32 index, u64 val)
+static inline int wrmsr_safe(u32 index, u64 val)
 {
 	u32 a = val, d = val >> 32;
 
diff --git a/x86/access.c b/x86/access.c
index 3832e2ef..4dfec230 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -280,7 +280,7 @@ static unsigned set_cr4_smep(ac_test_t *at, int smep)
 
 	if (smep)
 		walk_ptes(at, code_start, code_end, clear_user_mask);
-	r = write_cr4_checking(cr4);
+	r = write_cr4_safe(cr4);
 	if (r || !smep)
 		walk_ptes(at, code_start, code_end, set_user_mask);
 	if (!r)
@@ -1188,7 +1188,7 @@ int ac_test_run(int pt_levels)
 		/* Now PKRU = 0xFFFFFFFF.  */
 	} else {
 		tests++;
-		if (write_cr4_checking(shadow_cr4 | X86_CR4_PKE) == GP_VECTOR) {
+		if (write_cr4_safe(shadow_cr4 | X86_CR4_PKE) == GP_VECTOR) {
 			successes++;
 			invalid_mask |= AC_PKU_AD_MASK;
 			invalid_mask |= AC_PKU_WD_MASK;
@@ -1216,12 +1216,12 @@ int ac_test_run(int pt_levels)
 	/* Toggling LA57 in 64-bit mode (guaranteed for this test) is illegal. */
 	if (this_cpu_has(X86_FEATURE_LA57)) {
 		tests++;
-		if (write_cr4_checking(shadow_cr4 ^ X86_CR4_LA57) == GP_VECTOR)
+		if (write_cr4_safe(shadow_cr4 ^ X86_CR4_LA57) == GP_VECTOR)
 			successes++;
 
 		/* Force a VM-Exit on KVM, which doesn't intercept LA57 itself. */
 		tests++;
-		if (write_cr4_checking(shadow_cr4 ^ (X86_CR4_LA57 | X86_CR4_PSE)) == GP_VECTOR)
+		if (write_cr4_safe(shadow_cr4 ^ (X86_CR4_LA57 | X86_CR4_PSE)) == GP_VECTOR)
 			successes++;
 	}
 
diff --git a/x86/la57.c b/x86/la57.c
index b537bb22..1f11412c 100644
--- a/x86/la57.c
+++ b/x86/la57.c
@@ -4,7 +4,7 @@
 
 int main(int ac, char **av)
 {
-	int vector = write_cr4_checking(read_cr4() | X86_CR4_LA57);
+	int vector = write_cr4_safe(read_cr4() | X86_CR4_LA57);
 	int expected = this_cpu_has(X86_FEATURE_LA57) ? 0 : 13;
 
 	report(vector == expected, "%s when CR4.LA57 %ssupported",
diff --git a/x86/msr.c b/x86/msr.c
index 44fbb3b2..eaca19ed 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -72,7 +72,7 @@ static void test_msr_rw(struct msr_info *msr, unsigned long long val)
 
 static void test_wrmsr_fault(struct msr_info *msr, unsigned long long val)
 {
-	unsigned char vector = wrmsr_checking(msr->index, val);
+	unsigned char vector = wrmsr_safe(msr->index, val);
 
 	report(vector == GP_VECTOR,
 	       "Expected #GP on WRSMR(%s, 0x%llx), got vector %d",
@@ -81,7 +81,7 @@ static void test_wrmsr_fault(struct msr_info *msr, unsigned long long val)
 
 static void test_rdmsr_fault(struct msr_info *msr)
 {
-	unsigned char vector = rdmsr_checking(msr->index);
+	unsigned char vector = rdmsr_safe(msr->index);
 
 	report(vector == GP_VECTOR,
 	       "Expected #GP on RDSMR(%s), got vector %d", msr->name, vector);
diff --git a/x86/pcid.c b/x86/pcid.c
index 80a4611d..5e08f576 100644
--- a/x86/pcid.c
+++ b/x86/pcid.c
@@ -10,7 +10,7 @@ struct invpcid_desc {
     u64 addr : 64;
 };
 
-static int write_cr0_checking(unsigned long val)
+static int write_cr0_safe(unsigned long val)
 {
     asm volatile(ASM_TRY("1f")
                  "mov %0, %%cr0\n\t"
@@ -18,7 +18,7 @@ static int write_cr0_checking(unsigned long val)
     return exception_vector();
 }
 
-static int invpcid_checking(unsigned long type, void *desc)
+static int invpcid_safe(unsigned long type, void *desc)
 {
     asm volatile (ASM_TRY("1f")
                   ".byte 0x66,0x0f,0x38,0x82,0x18 \n\t" /* invpcid (%rax), %rbx */
@@ -32,18 +32,18 @@ static void test_pcid_enabled(void)
     ulong cr0 = read_cr0(), cr3 = read_cr3(), cr4 = read_cr4();
 
     /* try setting CR4.PCIDE, no exception expected */
-    if (write_cr4_checking(cr4 | X86_CR4_PCIDE) != 0)
+    if (write_cr4_safe(cr4 | X86_CR4_PCIDE) != 0)
         goto report;
 
     /* try clearing CR0.PG when CR4.PCIDE=1, #GP expected */
-    if (write_cr0_checking(cr0 & ~X86_CR0_PG) != GP_VECTOR)
+    if (write_cr0_safe(cr0 & ~X86_CR0_PG) != GP_VECTOR)
         goto report;
 
     write_cr4(cr4);
 
     /* try setting CR4.PCIDE when CR3[11:0] != 0 , #GP expected */
     write_cr3(cr3 | 0x001);
-    if (write_cr4_checking(cr4 | X86_CR4_PCIDE) != GP_VECTOR)
+    if (write_cr4_safe(cr4 | X86_CR4_PCIDE) != GP_VECTOR)
         goto report;
     write_cr3(cr3);
 
@@ -59,7 +59,7 @@ static void test_pcid_disabled(void)
     ulong cr4 = read_cr4();
 
     /* try setting CR4.PCIDE, #GP expected */
-    if (write_cr4_checking(cr4 | X86_CR4_PCIDE) != GP_VECTOR)
+    if (write_cr4_safe(cr4 | X86_CR4_PCIDE) != GP_VECTOR)
         goto report;
 
     passed = 1;
@@ -80,7 +80,7 @@ static void test_invpcid_enabled(int pcid_enabled)
      * no exception expected
      */
     for (i = 0; i < 4; i++) {
-        if (invpcid_checking(i, &desc) != 0)
+        if (invpcid_safe(i, &desc) != 0)
             goto report;
     }
 
@@ -89,7 +89,7 @@ static void test_invpcid_enabled(int pcid_enabled)
      */
     desc.pcid = 1;
     for (i = 0; i < 2; i++) {
-        if (invpcid_checking(i, &desc) != GP_VECTOR)
+        if (invpcid_safe(i, &desc) != GP_VECTOR)
             goto report;
     }
 
@@ -97,14 +97,14 @@ static void test_invpcid_enabled(int pcid_enabled)
     if (!pcid_enabled)
         goto success;
 
-    if (write_cr4_checking(cr4 | X86_CR4_PCIDE) != 0)
+    if (write_cr4_safe(cr4 | X86_CR4_PCIDE) != 0)
         goto report;
 
     /* try executing invpcid when CR4.PCIDE=1
      * no exception expected
      */
     desc.pcid = 10;
-    if (invpcid_checking(2, &desc) != 0)
+    if (invpcid_safe(2, &desc) != 0)
         goto report;
 
 success:
@@ -120,7 +120,7 @@ static void test_invpcid_disabled(void)
     struct invpcid_desc desc;
 
     /* try executing invpcid, #UD expected */
-    if (invpcid_checking(2, &desc) != UD_VECTOR)
+    if (invpcid_safe(2, &desc) != UD_VECTOR)
         goto report;
 
     passed = 1;
diff --git a/x86/rdpru.c b/x86/rdpru.c
index 5cb69cb6..85c5edd6 100644
--- a/x86/rdpru.c
+++ b/x86/rdpru.c
@@ -4,7 +4,7 @@
 #include "processor.h"
 #include "desc.h"
 
-static int rdpru_checking(void)
+static int rdpru_safe(void)
 {
 	asm volatile (ASM_TRY("1f")
 		      ".byte 0x0f,0x01,0xfd \n\t" /* rdpru */
@@ -17,7 +17,7 @@ int main(int ac, char **av)
 	if (this_cpu_has(X86_FEATURE_RDPRU))
 		report_skip("RDPRU raises #UD");
 	else
-		report(rdpru_checking() == UD_VECTOR, "RDPRU raises #UD");
+		report(rdpru_safe() == UD_VECTOR, "RDPRU raises #UD");
 
 	return report_summary();
 }
diff --git a/x86/vmx.c b/x86/vmx.c
index c0242986..65305238 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -292,7 +292,7 @@ static bool check_vmcs_field(struct vmcs_field *f, u8 cookie)
 		return true;
 	}
 
-	ret = vmcs_read_checking(f->encoding, &actual);
+	ret = vmcs_read_safe(f->encoding, &actual);
 	assert(!(ret & X86_EFLAGS_CF));
 	/* Skip VMCS fields that aren't recognized by the CPU */
 	if (ret & X86_EFLAGS_ZF)
@@ -352,7 +352,7 @@ static u32 find_vmcs_max_index(void)
 				      (type << VMCS_FIELD_TYPE_SHIFT) |
 				      (width << VMCS_FIELD_WIDTH_SHIFT);
 
-				ret = vmcs_read_checking(enc, &actual);
+				ret = vmcs_read_safe(enc, &actual);
 				assert(!(ret & X86_EFLAGS_CF));
 				if (!(ret & X86_EFLAGS_ZF))
 					return idx;
diff --git a/x86/vmx.h b/x86/vmx.h
index 11cb6651..7cd02410 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -933,7 +933,7 @@ static inline u64 vmcs_readm(enum Encoding enc)
 	return val;
 }
 
-static inline int vmcs_read_checking(enum Encoding enc, u64 *value)
+static inline int vmcs_read_safe(enum Encoding enc, u64 *value)
 {
 	u64 rflags = read_rflags() | X86_EFLAGS_CF | X86_EFLAGS_ZF;
 	u64 encoding = enc;
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 4d581e70..1b277cfb 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -8311,7 +8311,7 @@ static void vmx_cr_load_test(void)
 	/* Enable PCID for L1. */
 	cr4 = orig_cr4 | X86_CR4_PCIDE;
 	cr3 = orig_cr3 | 0x1;
-	TEST_ASSERT(!write_cr4_checking(cr4));
+	TEST_ASSERT(!write_cr4_safe(cr4));
 	write_cr3(cr3);
 
 	test_set_guest(vmx_single_vmcall_guest);
@@ -8328,11 +8328,11 @@ static void vmx_cr_load_test(void)
 	 *     have no side effect because normally no guest MCE (e.g., as the
 	 *     result of bad memory) would happen during this test.
 	 */
-	TEST_ASSERT(!write_cr4_checking(cr4 ^ X86_CR4_MCE));
+	TEST_ASSERT(!write_cr4_safe(cr4 ^ X86_CR4_MCE));
 
 	/* Cleanup L1 state. */
 	write_cr3(orig_cr3);
-	TEST_ASSERT(!write_cr4_checking(orig_cr4));
+	TEST_ASSERT(!write_cr4_safe(orig_cr4));
 
 	if (!this_cpu_has(X86_FEATURE_LA57))
 		goto done;
diff --git a/x86/xsave.c b/x86/xsave.c
index 84170033..39a55d66 100644
--- a/x86/xsave.c
+++ b/x86/xsave.c
@@ -21,7 +21,7 @@ static int xgetbv_checking(u32 index, u64 *result)
     return exception_vector();
 }
 
-static int xsetbv_checking(u32 index, u64 value)
+static int xsetbv_safe(u32 index, u64 value)
 {
     u32 eax = value;
     u32 edx = value >> 32;
@@ -66,60 +66,60 @@ static void test_xsave(void)
            "Check minimal XSAVE required bits");
 
     cr4 = read_cr4();
-    report(write_cr4_checking(cr4 | X86_CR4_OSXSAVE) == 0, "Set CR4 OSXSAVE");
+    report(write_cr4_safe(cr4 | X86_CR4_OSXSAVE) == 0, "Set CR4 OSXSAVE");
     report(this_cpu_has(X86_FEATURE_OSXSAVE),
            "Check CPUID.1.ECX.OSXSAVE - expect 1");
 
     printf("\tLegal tests\n");
     test_bits = XSTATE_FP;
-    report(xsetbv_checking(XCR_XFEATURE_ENABLED_MASK, test_bits) == 0,
+    report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == 0,
            "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP)");
 
     test_bits = XSTATE_FP | XSTATE_SSE;
-    report(xsetbv_checking(XCR_XFEATURE_ENABLED_MASK, test_bits) == 0,
+    report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == 0,
            "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP | XSTATE_SSE)");
     report(xgetbv_checking(XCR_XFEATURE_ENABLED_MASK, &xcr0) == 0,
            "        xgetbv(XCR_XFEATURE_ENABLED_MASK)");
 
     printf("\tIllegal tests\n");
     test_bits = 0;
-    report(xsetbv_checking(XCR_XFEATURE_ENABLED_MASK, test_bits) == GP_VECTOR,
+    report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == GP_VECTOR,
            "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, 0) - expect #GP");
 
     test_bits = XSTATE_SSE;
-    report(xsetbv_checking(XCR_XFEATURE_ENABLED_MASK, test_bits) == GP_VECTOR,
+    report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == GP_VECTOR,
            "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_SSE) - expect #GP");
 
     if (supported_xcr0 & XSTATE_YMM) {
         test_bits = XSTATE_YMM;
-        report(xsetbv_checking(XCR_XFEATURE_ENABLED_MASK, test_bits) == GP_VECTOR,
+        report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == GP_VECTOR,
                "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_YMM) - expect #GP");
 
         test_bits = XSTATE_FP | XSTATE_YMM;
-        report(xsetbv_checking(XCR_XFEATURE_ENABLED_MASK, test_bits) == GP_VECTOR,
+        report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == GP_VECTOR,
                "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP | XSTATE_YMM) - expect #GP");
     }
 
     test_bits = XSTATE_SSE;
-    report(xsetbv_checking(XCR_XFEATURE_ILLEGAL_MASK, test_bits) == GP_VECTOR,
+    report(xsetbv_safe(XCR_XFEATURE_ILLEGAL_MASK, test_bits) == GP_VECTOR,
            "\t\txsetbv(XCR_XFEATURE_ILLEGAL_MASK, XSTATE_FP) - expect #GP");
 
     test_bits = XSTATE_SSE;
-    report(xsetbv_checking(XCR_XFEATURE_ILLEGAL_MASK, test_bits) == GP_VECTOR,
+    report(xsetbv_safe(XCR_XFEATURE_ILLEGAL_MASK, test_bits) == GP_VECTOR,
            "\t\txgetbv(XCR_XFEATURE_ILLEGAL_MASK, XSTATE_FP) - expect #GP");
 
     cr4 &= ~X86_CR4_OSXSAVE;
-    report(write_cr4_checking(cr4) == 0, "Unset CR4 OSXSAVE");
+    report(write_cr4_safe(cr4) == 0, "Unset CR4 OSXSAVE");
     report(this_cpu_has(X86_FEATURE_OSXSAVE) == 0,
            "Check CPUID.1.ECX.OSXSAVE - expect 0");
 
     printf("\tIllegal tests:\n");
     test_bits = XSTATE_FP;
-    report(xsetbv_checking(XCR_XFEATURE_ENABLED_MASK, test_bits) == UD_VECTOR,
+    report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == UD_VECTOR,
            "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP) - expect #UD");
 
     test_bits = XSTATE_FP | XSTATE_SSE;
-    report(xsetbv_checking(XCR_XFEATURE_ENABLED_MASK, test_bits) == UD_VECTOR,
+    report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == UD_VECTOR,
            "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP | XSTATE_SSE) - expect #UD");
 
     printf("\tIllegal tests:\n");
@@ -138,13 +138,13 @@ static void test_no_xsave(void)
     printf("Illegal instruction testing:\n");
 
     cr4 = read_cr4();
-    report(write_cr4_checking(cr4 | X86_CR4_OSXSAVE) == GP_VECTOR,
+    report(write_cr4_safe(cr4 | X86_CR4_OSXSAVE) == GP_VECTOR,
            "Set OSXSAVE in CR4 - expect #GP");
 
     report(xgetbv_checking(XCR_XFEATURE_ENABLED_MASK, &xcr0) == UD_VECTOR,
            "Execute xgetbv - expect #UD");
 
-    report(xsetbv_checking(XCR_XFEATURE_ENABLED_MASK, 0x3) == UD_VECTOR,
+    report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, 0x3) == UD_VECTOR,
            "Execute xsetbv - expect #UD");
 }
 
-- 
2.36.1.255.ge46751e96f-goog

