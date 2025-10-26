Return-Path: <kvm+bounces-61115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id EBD2EC0B27E
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 21:24:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 707E94EEA9D
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 20:23:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A49D130216D;
	Sun, 26 Oct 2025 20:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="TevQn1oE"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571422FE055;
	Sun, 26 Oct 2025 20:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761510033; cv=none; b=CmFg+c5IPOexOkMD+90NmxjY6arqhB97vTwfv2y88p20/dXjFfm7uezXgMeb70K0uSXtqTZpPknF2lbQdQ1vfApe0Y/+lGwqgeSPveMVJ4GfxIrbbOjmxL8uFnLLhLABOjEWxOhozzHVyXlNz8IS2oU2SND6c6mGhZ5pV36N2zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761510033; c=relaxed/simple;
	bh=KU4xhmJMGLuFxzun6WZQgkC7ke2VpVpvpky4CxD8dZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n+LT4OhQ1R0OTdkPwnITZ2lpgbtc7YD5tf5OJ8hZRvW4gnzndvA4o18CsMuicBr9mJpPKV7fnU8AFnmwzrbsUq5pFcJXgRnBvgZ3DuMJCr7El6tS34tJzM2JIqeP7kLkxFDk8So3SuWbTExW1JxjvUZgqeoV5GsbYvN8tuNjUC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=TevQn1oE; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59QKJBkM505258
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Sun, 26 Oct 2025 13:19:24 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59QKJBkM505258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1761509964;
	bh=sKhnLJFMHD1yDHnCepaJ0VneRFLfM/13ft4UiHuO+aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TevQn1oEcf2Ct1t3hioUN5ySSXMR764D7HQUAkuTKNk1c/ZQ5z44n06fBIAL1HBvW
	 wjlsGHVter7oRLyXbK9BCHkh7zLrEF0fKNzJGENC4t7RPms+BoZVVXxVNvD5QN5B+Y
	 Jkgi4V3oYCso5HJJ72kkSNE/Is+idaZDIYhP9pPmc0FpjOeq3JAO+W3qMQnKXvfsBU
	 07XFJikEGQOMVHpekDC4ax1QjviCKcKpg9JZaxLl5r9f7wO8jZ9f4YUJtpZSBKpEiy
	 YSHYozAO2v9furXzJeKyBDRX+M24Stf1pDL4igj3e5k+Qsi5A9JUd82Fl87pp5k6Pe
	 rHtRrUhzyvgkQ==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org, sohil.mehta@intel.com
Subject: [PATCH v9 05/22] x86/cea: Use array indexing to simplify exception stack access
Date: Sun, 26 Oct 2025 13:18:53 -0700
Message-ID: <20251026201911.505204-6-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026201911.505204-1-xin@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor struct cea_exception_stacks to leverage array indexing for
exception stack access, improving code clarity and eliminating the
need for the ESTACKS_MEMBERS() macro.

Convert __this_cpu_ist_{bottom,top}_va() from macros to functions,
allowing removal of the now-obsolete CEA_ESTACK_BOT and CEA_ESTACK_TOP
macros.

Also drop CEA_ESTACK_SIZE, which just duplicated EXCEPTION_STKSZ.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---

Change in v9:
* Refactor first and then export in a separate patch (Dave Hansen).

Change in v7:
* Access cea_exception_stacks using array indexing (Dave Hansen).
* Use BUILD_BUG_ON(ESTACK_DF != 0) to ensure the starting index is 0
  (Dave Hansen).
* Remove Suggested-bys (Dave Hansen).
* Move rename code in a separate patch (Dave Hansen).

Change in v5:
* Export accessor instead of data (Christoph Hellwig).
* Add TB from Xuelian Guo.

Change in v4:
* Rewrite the change log and add comments to the export (Dave Hansen).
---
 arch/x86/include/asm/cpu_entry_area.h | 52 ++++++++++++---------------
 arch/x86/kernel/dumpstack_64.c        |  4 +--
 arch/x86/mm/cpu_entry_area.c          | 21 ++++++++++-
 3 files changed, 44 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/cpu_entry_area.h b/arch/x86/include/asm/cpu_entry_area.h
index d0f884c28178..509e52fc3a0f 100644
--- a/arch/x86/include/asm/cpu_entry_area.h
+++ b/arch/x86/include/asm/cpu_entry_area.h
@@ -16,6 +16,19 @@
 #define VC_EXCEPTION_STKSZ	0
 #endif
 
+/*
+ * The exception stack ordering in [cea_]exception_stacks
+ */
+enum exception_stack_ordering {
+	ESTACK_DF,
+	ESTACK_NMI,
+	ESTACK_DB,
+	ESTACK_MCE,
+	ESTACK_VC,
+	ESTACK_VC2,
+	N_EXCEPTION_STACKS
+};
+
 /* Macro to enforce the same ordering and stack sizes */
 #define ESTACKS_MEMBERS(guardsize, optional_stack_size)		\
 	char	ESTACK_DF_stack_guard[guardsize];		\
@@ -39,37 +52,22 @@ struct exception_stacks {
 
 /* The effective cpu entry area mapping with guard pages. */
 struct cea_exception_stacks {
-	ESTACKS_MEMBERS(PAGE_SIZE, EXCEPTION_STKSZ)
-};
-
-/*
- * The exception stack ordering in [cea_]exception_stacks
- */
-enum exception_stack_ordering {
-	ESTACK_DF,
-	ESTACK_NMI,
-	ESTACK_DB,
-	ESTACK_MCE,
-	ESTACK_VC,
-	ESTACK_VC2,
-	N_EXCEPTION_STACKS
+	struct {
+		char stack_guard[PAGE_SIZE];
+		char stack[EXCEPTION_STKSZ];
+	} event_stacks[N_EXCEPTION_STACKS];
+	char IST_top_guard[PAGE_SIZE];
 };
 
-#define CEA_ESTACK_SIZE(st)					\
-	sizeof(((struct cea_exception_stacks *)0)->st## _stack)
-
-#define CEA_ESTACK_BOT(ceastp, st)				\
-	((unsigned long)&(ceastp)->st## _stack)
-
-#define CEA_ESTACK_TOP(ceastp, st)				\
-	(CEA_ESTACK_BOT(ceastp, st) + CEA_ESTACK_SIZE(st))
-
 #define CEA_ESTACK_OFFS(st)					\
-	offsetof(struct cea_exception_stacks, st## _stack)
+	offsetof(struct cea_exception_stacks, event_stacks[st].stack)
 
 #define CEA_ESTACK_PAGES					\
 	(sizeof(struct cea_exception_stacks) / PAGE_SIZE)
 
+extern unsigned long __this_cpu_ist_top_va(enum exception_stack_ordering stack);
+extern unsigned long __this_cpu_ist_bottom_va(enum exception_stack_ordering stack);
+
 #endif
 
 #ifdef CONFIG_X86_32
@@ -144,10 +142,4 @@ static __always_inline struct entry_stack *cpu_entry_stack(int cpu)
 	return &get_cpu_entry_area(cpu)->entry_stack_page.stack;
 }
 
-#define __this_cpu_ist_top_va(name)					\
-	CEA_ESTACK_TOP(__this_cpu_read(cea_exception_stacks), name)
-
-#define __this_cpu_ist_bottom_va(name)					\
-	CEA_ESTACK_BOT(__this_cpu_read(cea_exception_stacks), name)
-
 #endif
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 40f51e278171..93b10b264e53 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -70,9 +70,9 @@ struct estack_pages {
 
 #define EPAGERANGE(st)							\
 	[PFN_DOWN(CEA_ESTACK_OFFS(st)) ...				\
-	 PFN_DOWN(CEA_ESTACK_OFFS(st) + CEA_ESTACK_SIZE(st) - 1)] = {	\
+	 PFN_DOWN(CEA_ESTACK_OFFS(st) + EXCEPTION_STKSZ - 1)] = {	\
 		.offs	= CEA_ESTACK_OFFS(st),				\
-		.size	= CEA_ESTACK_SIZE(st),				\
+		.size	= EXCEPTION_STKSZ,				\
 		.type	= STACK_TYPE_EXCEPTION + st, }
 
 /*
diff --git a/arch/x86/mm/cpu_entry_area.c b/arch/x86/mm/cpu_entry_area.c
index 9fa371af8abc..b3d90f9cfbb1 100644
--- a/arch/x86/mm/cpu_entry_area.c
+++ b/arch/x86/mm/cpu_entry_area.c
@@ -18,6 +18,25 @@ static DEFINE_PER_CPU_PAGE_ALIGNED(struct entry_stack_page, entry_stack_storage)
 static DEFINE_PER_CPU_PAGE_ALIGNED(struct exception_stacks, exception_stacks);
 DEFINE_PER_CPU(struct cea_exception_stacks*, cea_exception_stacks);
 
+/*
+ * Typically invoked by entry code, so must be noinstr.
+ */
+noinstr unsigned long __this_cpu_ist_bottom_va(enum exception_stack_ordering stack)
+{
+	struct cea_exception_stacks *s;
+
+	BUILD_BUG_ON(ESTACK_DF != 0);
+
+	s = __this_cpu_read(cea_exception_stacks);
+
+	return (unsigned long)&s->event_stacks[stack].stack;
+}
+
+noinstr unsigned long __this_cpu_ist_top_va(enum exception_stack_ordering stack)
+{
+	return __this_cpu_ist_bottom_va(stack) + EXCEPTION_STKSZ;
+}
+
 static DEFINE_PER_CPU_READ_MOSTLY(unsigned long, _cea_offset);
 
 static __always_inline unsigned int cea_offset(unsigned int cpu)
@@ -132,7 +151,7 @@ static void __init percpu_setup_debug_store(unsigned int cpu)
 
 #define cea_map_stack(name) do {					\
 	npages = sizeof(estacks->name## _stack) / PAGE_SIZE;		\
-	cea_map_percpu_pages(cea->estacks.name## _stack,		\
+	cea_map_percpu_pages(cea->estacks.event_stacks[name].stack,	\
 			estacks->name## _stack, npages, PAGE_KERNEL);	\
 	} while (0)
 
-- 
2.51.0


