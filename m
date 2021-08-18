Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F53D3EF68D
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 02:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237042AbhHRAKG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 20:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237022AbhHRAKE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 20:10:04 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02796C0613C1
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:31 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b127-20020a25e485000000b005943f1efa05so947764ybh.15
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=K8jwsKzs7IEe9iRNrLfVJdwIHJGIIxqcPB0yjD0e3tQ=;
        b=KlTTUR+o3+BFUUCaZ9TQXlPXog9BsPKwgcz7XjAK1Pkm+PLiDrwckDGPTWgHq3PaMA
         XXC/Iibv+EHgtuCpqEuOvVUW/JGyhUkNPRSedtDd4YtmWuGOtt+RiBl0u79hA3PTXiCT
         qhn+WcnrjXYeUjhDp5/rtG3GlLS3LjDrtjCo48oDj9wIetA4o4t8gsnvx87bWlH2EWv0
         8gX6W7zs08rxAQgKQ+oTy3FPEusGQP9h5Uhs7a6AU1pIp2+zrXmcKd40U7mhbLqpmHSA
         ltx++VbHnaxukwin6N01eR+KO1zrJxDaif360y4LXSScIE6kUAswNtXsoG5I1qQeJVVy
         gStg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=K8jwsKzs7IEe9iRNrLfVJdwIHJGIIxqcPB0yjD0e3tQ=;
        b=VBALWmmwo6r3tHJO9kURWkiQwEbOmE4bwEWAYOimN5EMlM29pBSsVtKFPxeEoXd4bp
         bre2ub6jTeISDvFXjXB0Llk2iB1ZUM7+FUS7okxaivsKPqskU/udz9lyP2Ao4Cn0n89F
         eqWOMC4L+zi9olRoI8eCpYugO68pZGvnIkXjS/QkvaIqMsDIZcVvZqeXVMTSemvd+5hZ
         Ub4uJmEwbkfTIkRV3YfGZleXkN6tfeqNpUtyk1nHlG36wQgZ4hqnJU8ngnGKtP+u//YL
         5Gm4u9M0yNPNah/YFeiCWemgTbGzv2om/9WN6u4QWc+CX0Fa2+Jp21SN6bc0KR17UsTp
         ojgQ==
X-Gm-Message-State: AOAM531q1GqyzCERSe2ItQbOyvjKnQWUB8x3FU7YqFsa1bO/8Ir+3/Fc
        H0jq6e8lcy0YqDLnOdFX3boxMwVQY/hXlFjIEcpYiAS94ylji/8KPeedEXEcaTbkV4IRBcBs7Nv
        6yznHUTRmkhndBD4/L0qYBUqsrwuiK2ebzMiEck0hxDmv405aYttD/rwhJqVKE6nxjXwZ
X-Google-Smtp-Source: ABdhPJy+0Un8M2L4iyvOHpxOeLvC6CSdYs2xEe/z8PrrfpcVouYxQPqT0d2BTN9JWKZcgIo1j/Snk1mHEnXuJ2Fa
X-Received: from zxwang42.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2936])
 (user=zixuanwang job=sendgmr) by 2002:a25:80d4:: with SMTP id
 c20mr7831758ybm.345.1629245370090; Tue, 17 Aug 2021 17:09:30 -0700 (PDT)
Date:   Wed, 18 Aug 2021 00:08:58 +0000
In-Reply-To: <20210818000905.1111226-1-zixuanwang@google.com>
Message-Id: <20210818000905.1111226-10-zixuanwang@google.com>
Mime-Version: 1.0
References: <20210818000905.1111226-1-zixuanwang@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [kvm-unit-tests RFC 09/16] x86 UEFI: Convert x86 test cases to PIC
From:   Zixuan Wang <zixuanwang@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de,
        Zixuan Wang <zixuanwang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
 x86/Makefile.common | 10 +++++-----
 x86/Makefile.x86_64 |  7 ++++---
 x86/access.c        |  6 +++---
 x86/cet.c           |  8 +++++---
 x86/emulator.c      |  5 +++--
 x86/eventinj.c      |  6 ++++--
 x86/smap.c          |  8 ++++----
 x86/umip.c          | 10 +++++++---
 9 files changed, 37 insertions(+), 26 deletions(-)

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
index 314bf47..e77de6b 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -81,16 +81,16 @@ tests-common = $(TEST_DIR)/vmexit.$(exe) $(TEST_DIR)/tsc.$(exe) \
                $(TEST_DIR)/init.$(exe) \
                $(TEST_DIR)/hyperv_synic.$(exe) $(TEST_DIR)/hyperv_stimer.$(exe) \
                $(TEST_DIR)/hyperv_connections.$(exe) \
-               $(TEST_DIR)/tsx-ctrl.$(exe)
+               $(TEST_DIR)/tsx-ctrl.$(exe) \
+	       $(TEST_DIR)/eventinj.$(exe) \
+               $(TEST_DIR)/umip.$(exe)
 
 # The following test cases are disabled when building EFI tests because they
 # use absolute addresses in their inline assembly code, which cannot compile
 # with the '-fPIC' flag
 ifneq ($(TARGET_EFI),y)
-tests-common += $(TEST_DIR)/eventinj.$(exe) \
-                $(TEST_DIR)/smap.$(exe) \
-                $(TEST_DIR)/realmode.$(exe) \
-                $(TEST_DIR)/umip.$(exe)
+tests-common += $(TEST_DIR)/smap.$(exe) \
+                $(TEST_DIR)/realmode.$(exe)
 endif
 
 test_cases: $(tests-common) $(tests)
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index aa23b22..7e8a57a 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -30,20 +30,21 @@ tests += $(TEST_DIR)/intel-iommu.$(exe)
 tests += $(TEST_DIR)/rdpru.$(exe)
 tests += $(TEST_DIR)/pks.$(exe)
 tests += $(TEST_DIR)/pmu_lbr.$(exe)
+tests += $(TEST_DIR)/emulator.$(exe)
+tests += $(TEST_DIR)/vmware_backdoors.$(exe)
 
 # The following test cases are disabled when building EFI tests because they
 # use absolute addresses in their inline assembly code, which cannot compile
 # with the '-fPIC' flag
 ifneq ($(TARGET_EFI),y)
 tests += $(TEST_DIR)/access.$(exe)
-tests += $(TEST_DIR)/emulator.$(exe)
 tests += $(TEST_DIR)/svm.$(exe)
 tests += $(TEST_DIR)/vmx.$(exe)
-tests += $(TEST_DIR)/vmware_backdoors.$(exe)
+endif
+
 ifneq ($(fcf_protection_full),)
 tests += $(TEST_DIR)/cet.$(exe)
 endif
-endif
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
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
2.33.0.rc1.237.g0d66db33f3-goog

