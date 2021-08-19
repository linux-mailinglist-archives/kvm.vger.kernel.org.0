Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3489E3F1847
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 13:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238866AbhHSLfz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 07:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238749AbhHSLfy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 07:35:54 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F35C061575
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 04:35:18 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id v4so8549608wro.12
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 04:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=getEzT2IMj3U2MYsPIPzBO2g/DoPkjIiRV/IoBHF0hU=;
        b=cZVgnBOTz79nvzvPsSH5jMjXNZ1usDMp1a3XXXSTA201zMGv+/tJ0RYo++RFJTCmYd
         VauCN55uVNX15CpwsdHUCK/9NHXZtunUxH5nz4uAlesCCthgNerTL4NhUecsW4RxucxC
         VT/NqOTFXUOhw+Pf2rO5vns3QyPhYY5Fl7lsZcLKvBwG/Dk2cGTPo2keJmdGIHGOpkJF
         Mxuqa4G566y1omo25FvyRy/UPfLpuh9/bVXysZhhCDk8F8AevLiVzkDW0ifjx8zDjDrQ
         oNXoBgsDxt36WdfiWd8rE9Zdw0G3HdfvxnWCNLPWOz+kqTlBROxMpzovrHtjmoIe5O0e
         MS/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=getEzT2IMj3U2MYsPIPzBO2g/DoPkjIiRV/IoBHF0hU=;
        b=QG34bLAmYw3GvdnrhaMPZFlHR7QtfNuZS3fLxRU6Y6IBg9ix2Csh86vUzKPmSBm6EN
         tVvP31Fuc+XlWzvClCIWbCVkcZooKQcob7DeKCEwwanzk5TvDvCZLiRYVyl2fZ2DoEhJ
         H15T4Vmv2QV7VeLGUsrs0bpiTiVmBICOzNchVpgXBeTQN3+Ijnvp4G6kkaDhp07iQTCZ
         ggdNnwFZ+BOXJ2H5d+U6mNel5wTuGLrWmDzzfjkurRGzuM9jDIJJiaFP21RrVCZ4/Zoe
         sGj6hpQtkPnoyVw1KeO/JlxDI+jHef+t0f3bQ9Kz/8+XkXkRwriYHeTbzCiAFOjc4QaE
         QeJA==
X-Gm-Message-State: AOAM531WKIomkab2mSBxYJSPQnhDDQ2otuRgiwuYlE/LaJ1Ok9S6QLEX
        GCwn7oLKQ1sU2yHbOH7CRu9bwtBndbRcCGZh
X-Google-Smtp-Source: ABdhPJxwxFEimQDL1ngUNfNmRySMOdSFUyp6fERueNLUVKTUBmg5OD3k3Yxq4SmhCt+QrA7SHiN/qA==
X-Received: by 2002:adf:f406:: with SMTP id g6mr3320498wro.131.1629372916775;
        Thu, 19 Aug 2021 04:35:16 -0700 (PDT)
Received: from xps13.suse.de (ip5f5a5c19.dynamic.kabel-deutschland.de. [95.90.92.25])
        by smtp.gmail.com with ESMTPSA id w11sm2682859wrr.48.2021.08.19.04.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 04:35:16 -0700 (PDT)
From:   Varad Gautam <varadgautam@gmail.com>
X-Google-Original-From: Varad Gautam <varad.gautam@suse.com>
To:     Zixuan Wang <zixuanwang@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Marc Orr <marcorr@google.com>, Joerg Roedel <jroedel@suse.de>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>, bp@suse.de,
        Thomas.Lendacky@amd.com, brijesh.singh@amd.com,
        Hyunwook Baek <baekhw@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Tom Roeder <tmroeder@google.com>
Subject: [kvm-unit-tests PATCH v2 6/6] x86 UEFI: Convert x86 test cases to PIC
Date:   Thu, 19 Aug 2021 13:34:00 +0200
Message-Id: <20210819113400.26516-7-varad.gautam@suse.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210819113400.26516-1-varad.gautam@suse.com>
References: <20210819113400.26516-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zixuan Wang <zixuanwang@google.com>

UEFI loads EFI applications to dynamic runtime addresses, so it requires
all applications to be compiled as PIC (position independent code). PIC
does not allow the usage of compile time absolute address.

This commit converts multiple x86 test cases to PIC so they can compile
and run in UEFI:

- x86/cet.efi

- x86/emulator.c: x86/emulator.c depends on lib/x86/usermode.c. But
usermode.c contains non-PIC inline assembly code and thus blocks the
compilation with GNU-EFI. This commit converts lib/x86/usermode.c and
x86/emulator.c to PIC, so x86/emulator.c can compile and run in UEFI.

- x86/vmware_backdoors.c: it depends on lib/x86/usermode.c and now works
without modifications

- x86/eventinj.c

- x86/smap.c

- x86/access.c

- x86/umip.c

Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 lib/x86/usermode.c  |  3 ++-
 x86/Makefile.common |  7 ++++---
 x86/Makefile.x86_64 |  5 +++--
 x86/access.c        |  6 +++---
 x86/cet.c           |  8 +++++---
 x86/emulator.c      |  5 +++--
 x86/eventinj.c      |  6 ++++--
 x86/smap.c          |  8 ++++----
 x86/umip.c          | 10 +++++++---
 9 files changed, 35 insertions(+), 23 deletions(-)

diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
index f032523..c550545 100644
--- a/lib/x86/usermode.c
+++ b/lib/x86/usermode.c
@@ -58,7 +58,8 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
 			"pushq %[user_stack_top]\n\t"
 			"pushfq\n\t"
 			"pushq %[user_cs]\n\t"
-			"pushq $user_mode\n\t"
+			"lea user_mode(%%rip), %%rdx\n\t"
+			"pushq %%rdx\n\t"
 			"iretq\n"
 
 			"user_mode:\n\t"
diff --git a/x86/Makefile.common b/x86/Makefile.common
index ca33e8e..a91fd4c 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -61,8 +61,8 @@ FLATLIBS = lib/libcflat.a
 		    -j .reloc -j .init --target efi-app-x86_64 $*.so $@
 	@chmod a-x $@
 
-tests-flatonly = $(TEST_DIR)/realmode.$(out) $(TEST_DIR)/eventinj.$(out)		\
-		$(TEST_DIR)/smap.$(out) $(TEST_DIR)/umip.$(out)
+tests-flatonly = $(TEST_DIR)/realmode.$(out)						\
+		$(TEST_DIR)/smap.$(out)
 
 tests-common = $(TEST_DIR)/vmexit.$(out) $(TEST_DIR)/tsc.$(out)				\
 		$(TEST_DIR)/smptest.$(out) $(TEST_DIR)/msr.$(out)			\
@@ -72,7 +72,8 @@ tests-common = $(TEST_DIR)/vmexit.$(out) $(TEST_DIR)/tsc.$(out)				\
 		$(TEST_DIR)/tsc_adjust.$(out) $(TEST_DIR)/asyncpf.$(out)		\
 		$(TEST_DIR)/init.$(out) $(TEST_DIR)/hyperv_synic.$(out)			\
 		$(TEST_DIR)/hyperv_stimer.$(out) $(TEST_DIR)/hyperv_connections.$(out)	\
-		$(TEST_DIR)/tsx-ctrl.$(out)
+		$(TEST_DIR)/tsx-ctrl.$(out)						\
+		$(TEST_DIR)/eventinj.$(out) $(TEST_DIR)/umip.$(out)
 
 ifneq ($(CONFIG_EFI),y)
 tests-common += $(tests-flatonly)
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index f6c7bd7..e8843aa 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -18,9 +18,8 @@ cflatobjs += lib/x86/intel-iommu.o
 cflatobjs += lib/x86/usermode.o
 
 # Tests that have relocation / PIC problems and need more attention for EFI.
-tests_flatonly = $(TEST_DIR)/access.$(out) $(TEST_DIR)/emulator.$(out) \
+tests_flatonly = $(TEST_DIR)/access.$(out) \
 	$(TEST_DIR)/svm.$(out) $(TEST_DIR)/vmx.$(out) \
-	$(TEST_DIR)/vmware_backdoors.$(out)
 
 tests = $(TEST_DIR)/apic.$(out) $(TEST_DIR)/idt_test.$(out) \
 	  $(TEST_DIR)/xsave.$(out) $(TEST_DIR)/rmap_chain.$(out) \
@@ -33,6 +32,8 @@ tests += $(TEST_DIR)/intel-iommu.$(out)
 tests += $(TEST_DIR)/rdpru.$(out)
 tests += $(TEST_DIR)/pks.$(out)
 tests += $(TEST_DIR)/pmu_lbr.$(out)
+tests += $(TEST_DIR)/emulator.$(out)
+tests += $(TEST_DIR)/vmware_backdoors.$(out)
 
 ifneq ($(fcf_protection_full),)
 tests_flatonly += $(TEST_DIR)/cet.$(out)
diff --git a/x86/access.c b/x86/access.c
index 4725bbd..d0c84ca 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -700,7 +700,7 @@ static int ac_test_do_access(ac_test_t *at)
 
     if (F(AC_ACCESS_TWICE)) {
 	asm volatile (
-	    "mov $fixed2, %%rsi \n\t"
+	    "lea fixed2(%%rip), %%rsi \n\t"
 	    "mov (%[addr]), %[reg] \n\t"
 	    "fixed2:"
 	    : [reg]"=r"(r), [fault]"=a"(fault), "=b"(e)
@@ -710,7 +710,7 @@ static int ac_test_do_access(ac_test_t *at)
 	fault = 0;
     }
 
-    asm volatile ("mov $fixed1, %%rsi \n\t"
+    asm volatile ("lea fixed1(%%rip), %%rsi \n\t"
 		  "mov %%rsp, %%rdx \n\t"
 		  "cmp $0, %[user] \n\t"
 		  "jz do_access \n\t"
@@ -719,7 +719,7 @@ static int ac_test_do_access(ac_test_t *at)
 		  "pushq %[user_stack_top] \n\t"
 		  "pushfq \n\t"
 		  "pushq %[user_cs] \n\t"
-		  "pushq $do_access \n\t"
+		  "lea do_access(%%rip), %%rsi; pushq %%rsi; lea fixed1(%%rip), %%rsi\n\t"
 		  "iretq \n"
 		  "do_access: \n\t"
 		  "cmp $0, %[fetch] \n\t"
diff --git a/x86/cet.c b/x86/cet.c
index a21577a..a4b79cb 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -52,7 +52,7 @@ static u64 cet_ibt_func(void)
 	printf("No endbr64 instruction at jmp target, this triggers #CP...\n");
 	asm volatile ("movq $2, %rcx\n"
 		      "dec %rcx\n"
-		      "leaq 2f, %rax\n"
+		      "leaq 2f(%rip), %rax\n"
 		      "jmp *%rax \n"
 		      "2:\n"
 		      "dec %rcx\n");
@@ -67,7 +67,8 @@ void test_func(void) {
 			"pushq %[user_stack_top]\n\t"
 			"pushfq\n\t"
 			"pushq %[user_cs]\n\t"
-			"pushq $user_mode\n\t"
+			"lea user_mode(%%rip), %%rax\n\t"
+			"pushq %%rax\n\t"
 			"iretq\n"
 
 			"user_mode:\n\t"
@@ -77,7 +78,8 @@ void test_func(void) {
 			[user_ds]"i"(USER_DS),
 			[user_cs]"i"(USER_CS),
 			[user_stack_top]"r"(user_stack +
-					sizeof(user_stack)));
+					sizeof(user_stack))
+			: "rax");
 }
 
 #define SAVE_REGS() \
diff --git a/x86/emulator.c b/x86/emulator.c
index 9fda1a0..4d2de24 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -262,12 +262,13 @@ static void test_pop(void *mem)
 
 	asm volatile("mov %%rsp, %[tmp] \n\t"
 		     "mov %[stack_top], %%rsp \n\t"
-		     "push $1f \n\t"
+		     "lea 1f(%%rip), %%rax \n\t"
+		     "push %%rax \n\t"
 		     "ret \n\t"
 		     "2: jmp 2b \n\t"
 		     "1: mov %[tmp], %%rsp"
 		     : [tmp]"=&r"(tmp) : [stack_top]"r"(stack_top)
-		     : "memory");
+		     : "memory", "rax");
 	report(1, "ret");
 
 	stack_top[-1] = 0x778899;
diff --git a/x86/eventinj.c b/x86/eventinj.c
index 46593c9..0cd68e8 100644
--- a/x86/eventinj.c
+++ b/x86/eventinj.c
@@ -155,9 +155,11 @@ asm("do_iret:"
 	"pushf"W" \n\t"
 	"mov %cs, %ecx \n\t"
 	"push"W" %"R "cx \n\t"
-	"push"W" $2f \n\t"
+	"lea"W" 2f(%"R "ip), %"R "bx \n\t"
+	"push"W" %"R "bx \n\t"
 
-	"cmpb $0, no_test_device\n\t"	// see if need to flush
+	"mov no_test_device(%"R "ip), %bl \n\t"
+	"cmpb $0, %bl\n\t"		// see if need to flush
 	"jnz 1f\n\t"
 	"outl %eax, $0xe4 \n\t"		// flush page
 	"1: \n\t"
diff --git a/x86/smap.c b/x86/smap.c
index ac2c8d5..b3ee16f 100644
--- a/x86/smap.c
+++ b/x86/smap.c
@@ -161,10 +161,10 @@ int main(int ac, char **av)
 		test = -1;
 		asm("or $(" xstr(USER_BASE) "), %"R "sp \n"
 		    "push $44 \n "
-		    "decl test\n"
+		    "decl test(%"R "ip)\n"
 		    "and $~(" xstr(USER_BASE) "), %"R "sp \n"
 		    "pop %"R "ax\n"
-		    "movl %eax, test");
+		    "movl %eax, test(%"R "ip)");
 		report(pf_count == 0 && test == 44,
 		       "write to user stack with AC=1");
 
@@ -173,10 +173,10 @@ int main(int ac, char **av)
 		test = -1;
 		asm("or $(" xstr(USER_BASE) "), %"R "sp \n"
 		    "push $45 \n "
-		    "decl test\n"
+		    "decl test(%"R "ip)\n"
 		    "and $~(" xstr(USER_BASE) "), %"R "sp \n"
 		    "pop %"R "ax\n"
-		    "movl %eax, test");
+		    "movl %eax, test(%"R "ip)");
 		report(pf_count == 1 && test == 45 && save == -1,
 		       "write to user stack with AC=0");
 
diff --git a/x86/umip.c b/x86/umip.c
index c5700b3..8b4e798 100644
--- a/x86/umip.c
+++ b/x86/umip.c
@@ -23,7 +23,10 @@ static void gp_handler(struct ex_regs *regs)
 
 #define GP_ASM(stmt, in, clobber)                  \
     asm volatile (                                 \
-          "mov" W " $1f, %[expected_rip]\n\t"      \
+          "push" W " %%" R "ax\n\t"                \
+	  "lea 1f(%%" R "ip), %%" R "ax\n\t"       \
+          "mov %%" R "ax, %[expected_rip]\n\t"     \
+          "pop" W " %%" R "ax\n\t"                 \
           "movl $2f-1f, %[skip_count]\n\t"         \
           "1: " stmt "\n\t"                        \
           "2: "                                    \
@@ -130,7 +133,8 @@ static int do_ring3(void (*fn)(const char *), const char *arg)
 		  "push" W " %%" R "dx \n\t"
 		  "pushf" W "\n\t"
 		  "push" W " %[user_cs] \n\t"
-		  "push" W " $1f \n\t"
+		  "lea 1f(%%" R "ip), %%" R "dx \n\t"
+		  "push" W " %%" R "dx \n\t"
 		  "iret" W "\n"
 		  "1: \n\t"
 		  "push %%" R "cx\n\t"   /* save kernel SP */
@@ -144,7 +148,7 @@ static int do_ring3(void (*fn)(const char *), const char *arg)
 #endif
 
 		  "pop %%" R "cx\n\t"
-		  "mov $1f, %%" R "dx\n\t"
+		  "lea 1f(%%" R "ip), %%" R "dx\n\t"
 		  "int %[kernel_entry_vector]\n\t"
 		  ".section .text.entry \n\t"
 		  "kernel_entry: \n\t"
-- 
2.30.2

