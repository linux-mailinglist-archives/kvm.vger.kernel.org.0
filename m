Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07759768D6A
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 09:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbjGaHMX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 03:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbjGaHME (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 03:12:04 -0400
Received: from mgamail.intel.com (unknown [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580ED30E2;
        Mon, 31 Jul 2023 00:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690787398; x=1722323398;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mV4jSKbY2d+wZLYFM+7NRxftfBvXd0NC2fevZMSM55Q=;
  b=mu/aBl+LQaZ69kHgXasqfa9KbuguzEUTvbq9emU7DVr4EB8qENq696hu
   eQcsRdHD96wQ/fN/MjNtD/JsPXN+BfOXOdwbTRxbzAQkSPIdUo2f4lq/O
   cmw8NeJwRsy+QMs6CnXN2/XfopC2MqljpAp5bxWZHES+1vEREEFAqNQKz
   9N0c+t8g20RVvlaEJzyco8ZPja0n/vAf/mpeqDH5Q9HwWa20ZuJ4//61d
   gKXWPiZLbAdRI6Va95RP/rWobD6crh5wWAMta8+i+b6/wbafNA5adnIto
   6NYY49XbPxoJ6YsdGGZjh7jCRjj1TIkirqAk9OlHM9bvBR2p9VN9E314W
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10787"; a="432750007"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="432750007"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 00:09:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10787"; a="731491787"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="731491787"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga007.fm.intel.com with ESMTP; 31 Jul 2023 00:09:50 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Xin Li <xin3.li@intel.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "Liam R . Howlett" <Liam.Howlett@Oracle.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>,
        Jim Mattson <jmattson@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Breno Leitao <leitao@debian.org>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Brian Gerst <brgerst@gmail.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ze Gao <zegao2021@gmail.com>, Fei Li <fei1.li@intel.com>,
        Conghui <conghui.chen@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Jane Malalane <jane.malalane@citrix.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Yantengsi <siyanteng@loongson.cn>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Sathvika Vasireddy <sv@linux.ibm.com>
Subject: [PATCH v9 29/36] x86/fred: FRED entry/exit and dispatch code
Date:   Sun, 30 Jul 2023 23:41:19 -0700
Message-Id: <20230731064119.3870-1-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

The code to actually handle kernel and event entry/exit using
FRED. It is split up into two files thus:

- entry_64_fred.S contains the actual entrypoints and exit code, and
  saves and restores registers.
- entry_fred.c contains the two-level event dispatch code for FRED.
  The first-level dispatch is on the event type, and the second-level
  is on the event vector.

Originally-by: Megha Dey <megha.dey@intel.com>
Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Co-developed-by: Xin Li <xin3.li@intel.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---

Changes since v8:
* Don't do syscall early out in fred_entry_from_user() before there are
  proper performance numbers and justifications (Thomas Gleixner).
* Add the control exception handler to the FRED exception handler table
  (Thomas Gleixner).
* Add ENDBR to the FRED_ENTER asm macro.
* Reflect the FRED spec 5.0 change that ERETS and ERETU add 8 to %rsp
  before popping the return context from the stack.

Changes since v1:
* Initialize a FRED exception handler to fred_bad_event() instead of NULL
  if no FRED handler defined for an exception vector (Peter Zijlstra).
* Push calling irqentry_{enter,exit}() and instrumentation_{begin,end}()
  down into individual FRED exception handlers, instead of in the dispatch
  framework (Peter Zijlstra).
---
 arch/x86/entry/Makefile               |   5 +-
 arch/x86/entry/entry_64_fred.S        |  53 +++++++
 arch/x86/entry/entry_fred.c           | 220 ++++++++++++++++++++++++++
 arch/x86/include/asm/asm-prototypes.h |   1 +
 arch/x86/include/asm/fred.h           |   4 +
 arch/x86/include/asm/idtentry.h       |   4 +
 6 files changed, 286 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/entry/entry_64_fred.S
 create mode 100644 arch/x86/entry/entry_fred.c

diff --git a/arch/x86/entry/Makefile b/arch/x86/entry/Makefile
index ca2fe186994b..c93e7f5c2a06 100644
--- a/arch/x86/entry/Makefile
+++ b/arch/x86/entry/Makefile
@@ -18,6 +18,9 @@ obj-y				+= vdso/
 obj-y				+= vsyscall/
 
 obj-$(CONFIG_PREEMPTION)	+= thunk_$(BITS).o
+CFLAGS_entry_fred.o		+= -fno-stack-protector
+CFLAGS_REMOVE_entry_fred.o	+= -pg $(CC_FLAGS_FTRACE)
+obj-$(CONFIG_X86_FRED)		+= entry_64_fred.o entry_fred.o
+
 obj-$(CONFIG_IA32_EMULATION)	+= entry_64_compat.o syscall_32.o
 obj-$(CONFIG_X86_X32_ABI)	+= syscall_x32.o
-
diff --git a/arch/x86/entry/entry_64_fred.S b/arch/x86/entry/entry_64_fred.S
new file mode 100644
index 000000000000..4ae12d557db3
--- /dev/null
+++ b/arch/x86/entry/entry_64_fred.S
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * The actual FRED entry points.
+ */
+
+#include <asm/fred.h>
+
+#include "calling.h"
+
+	.code64
+	.section ".noinstr.text", "ax"
+
+.macro FRED_ENTER
+	UNWIND_HINT_END_OF_STACK
+	ENDBR
+	PUSH_AND_CLEAR_REGS
+	movq	%rsp, %rdi	/* %rdi -> pt_regs */
+.endm
+
+.macro FRED_EXIT
+	UNWIND_HINT_REGS
+	POP_REGS
+.endm
+
+/*
+ * The new RIP value that FRED event delivery establishes is
+ * IA32_FRED_CONFIG & ~FFFH for events that occur in ring 3.
+ * Thus the FRED ring 3 entry point must be 4K page aligned.
+ */
+	.align 4096
+
+SYM_CODE_START_NOALIGN(fred_entrypoint_user)
+	FRED_ENTER
+	call	fred_entry_from_user
+SYM_INNER_LABEL(fred_exit_user, SYM_L_GLOBAL)
+	FRED_EXIT
+	ERETU
+SYM_CODE_END(fred_entrypoint_user)
+
+.fill fred_entrypoint_kernel - ., 1, 0xcc
+
+/*
+ * The new RIP value that FRED event delivery establishes is
+ * (IA32_FRED_CONFIG & ~FFFH) + 256 for events that occur in
+ * ring 0, i.e., fred_entrypoint_user + 256.
+ */
+	.org fred_entrypoint_user+256
+SYM_CODE_START_NOALIGN(fred_entrypoint_kernel)
+	FRED_ENTER
+	call	fred_entry_from_kernel
+	FRED_EXIT
+	ERETS
+SYM_CODE_END(fred_entrypoint_kernel)
diff --git a/arch/x86/entry/entry_fred.c b/arch/x86/entry/entry_fred.c
new file mode 100644
index 000000000000..1688e7e09370
--- /dev/null
+++ b/arch/x86/entry/entry_fred.c
@@ -0,0 +1,220 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * This contains the dispatch functions called from the entry point
+ * assembly.
+ */
+
+#include <linux/kernel.h>
+#include <linux/kdebug.h>
+#include <linux/nospec.h>
+
+#include <asm/fred.h>
+#include <asm/idtentry.h>
+#include <asm/syscall.h>
+#include <asm/trapnr.h>
+#include <asm/traps.h>
+#include <asm/kdebug.h>
+
+static DEFINE_FRED_HANDLER(fred_bad_event)
+{
+	irqentry_state_t irq_state = irqentry_nmi_enter(regs);
+
+	instrumentation_begin();
+
+	/* Panic on events from a high stack level */
+	if (regs->sl > 0) {
+		pr_emerg("PANIC: invalid or fatal FRED event; event type %u "
+			 "vector %u error 0x%lx aux 0x%lx at %04x:%016lx\n",
+			 regs->type, regs->vector, regs->orig_ax,
+			 fred_event_data(regs), regs->cs, regs->ip);
+		die("invalid or fatal FRED event", regs, regs->orig_ax);
+		panic("invalid or fatal FRED event");
+	} else {
+		unsigned long flags = oops_begin();
+		int sig = SIGKILL;
+
+		pr_alert("BUG: invalid or fatal FRED event; event type %u "
+			 "vector %u error 0x%lx aux 0x%lx at %04x:%016lx\n",
+			 regs->type, regs->vector, regs->orig_ax,
+			 fred_event_data(regs), regs->cs, regs->ip);
+
+		if (__die("Invalid or fatal FRED event", regs, regs->orig_ax))
+			sig = 0;
+
+		oops_end(flags, regs, sig);
+	}
+
+	instrumentation_end();
+	irqentry_nmi_exit(regs, irq_state);
+}
+
+static DEFINE_FRED_HANDLER(fred_exception)
+{
+	/*
+	 * Exceptions that cannot happen on FRED h/w are set to fred_bad_event().
+	 */
+	static const fred_handler exception_handlers[NUM_EXCEPTION_VECTORS] = {
+		[0 ... NUM_EXCEPTION_VECTORS-1] = fred_bad_event,
+
+		[X86_TRAP_DE]		= exc_divide_error,
+		[X86_TRAP_DB]		= fred_exc_debug,
+		[X86_TRAP_BP]		= exc_int3,
+		[X86_TRAP_OF]		= exc_overflow,
+		[X86_TRAP_BR]		= exc_bounds,
+		[X86_TRAP_UD]		= exc_invalid_op,
+		[X86_TRAP_NM]		= exc_device_not_available,
+		[X86_TRAP_DF]		= fred_exc_double_fault,
+		[X86_TRAP_TS]		= fred_exc_invalid_tss,
+		[X86_TRAP_NP]		= fred_exc_segment_not_present,
+		[X86_TRAP_SS]		= fred_exc_stack_segment,
+		[X86_TRAP_GP]		= fred_exc_general_protection,
+		[X86_TRAP_PF]		= fred_exc_page_fault,
+		[X86_TRAP_MF]		= exc_coprocessor_error,
+		[X86_TRAP_AC]		= fred_exc_alignment_check,
+		[X86_TRAP_MC]		= fred_exc_machine_check,
+		[X86_TRAP_XF]		= exc_simd_coprocessor_error,
+		[X86_TRAP_CP]		= fred_exc_control_protection,
+	};
+
+	exception_handlers[regs->vector](regs);
+}
+
+static __always_inline void fred_emulate_trap(struct pt_regs *regs)
+{
+	regs->orig_ax = 0;
+	fred_exception(regs);
+}
+
+static __always_inline void fred_emulate_fault(struct pt_regs *regs)
+{
+	regs->ip -= regs->instr_len;
+	fred_emulate_trap(regs);
+}
+
+static DEFINE_FRED_HANDLER(fred_sw_interrupt_user)
+{
+	/*
+	 * In compat mode INT $0x80 (32bit system call) is
+	 * performance-critical. Handle it first.
+	 */
+	if (IS_ENABLED(CONFIG_IA32_EMULATION) &&
+	    likely(regs->vector == IA32_SYSCALL_VECTOR)) {
+		regs->orig_ax = regs->ax;
+		regs->ax = -ENOSYS;
+		return do_int80_syscall_32(regs);
+	}
+
+	/*
+	 * Some software exceptions can also be triggered as
+	 * int instructions, for historical reasons.
+	 */
+	switch (regs->vector) {
+	case X86_TRAP_BP:
+	case X86_TRAP_OF:
+		fred_emulate_trap(regs);
+		break;
+	default:
+		regs->vector = X86_TRAP_GP;
+		fred_emulate_fault(regs);
+		break;
+	}
+}
+
+static DEFINE_FRED_HANDLER(fred_other_default)
+{
+	regs->vector = X86_TRAP_UD;
+	fred_emulate_fault(regs);
+}
+
+static DEFINE_FRED_HANDLER(fred_syscall)
+{
+	regs->orig_ax = regs->ax;
+	regs->ax = -ENOSYS;
+	do_syscall_64(regs, regs->orig_ax);
+}
+
+#if IS_ENABLED(CONFIG_IA32_EMULATION)
+/*
+ * Emulate SYSENTER if applicable. This is not the preferred system
+ * call in 32-bit mode under FRED, rather int $0x80 is preferred and
+ * exported in the vdso.
+ */
+static DEFINE_FRED_HANDLER(fred_sysenter)
+{
+	regs->orig_ax = regs->ax;
+	regs->ax = -ENOSYS;
+	do_fast_syscall_32(regs);
+}
+#else
+#define fred_sysenter fred_other_default
+#endif
+
+static DEFINE_FRED_HANDLER(fred_other)
+{
+	static const fred_handler user_other_handlers[FRED_NUM_OTHER_VECTORS] =
+	{
+		/*
+		 * Vector 0 of the other event type is not used
+		 * per FRED spec 5.0.
+		 */
+		[0]		= fred_other_default,
+		[FRED_SYSCALL]	= fred_syscall,
+		[FRED_SYSENTER]	= fred_sysenter
+	};
+
+	user_other_handlers[regs->vector](regs);
+}
+
+static DEFINE_FRED_HANDLER(fred_hw_interrupt)
+{
+	irqentry_state_t state = irqentry_enter(regs);
+
+	instrumentation_begin();
+	external_interrupt(regs);
+	instrumentation_end();
+	irqentry_exit(regs, state);
+}
+
+__visible noinstr void fred_entry_from_user(struct pt_regs *regs)
+{
+	static const fred_handler user_handlers[FRED_EVENT_TYPE_COUNT] =
+	{
+		[EVENT_TYPE_HWINT]	= fred_hw_interrupt,
+		[EVENT_TYPE_RESERVED]	= fred_bad_event,
+		[EVENT_TYPE_NMI]	= fred_exc_nmi,
+		[EVENT_TYPE_SWINT]	= fred_sw_interrupt_user,
+		[EVENT_TYPE_HWFAULT]	= fred_exception,
+		[EVENT_TYPE_SWFAULT]	= fred_exception,
+		[EVENT_TYPE_PRIVSW]	= fred_exception,
+		[EVENT_TYPE_OTHER]	= fred_other
+	};
+
+	/*
+	 * FRED employs a two-level event dispatch mechanism, with the
+	 * first-level on the type of an event and the second-level on
+	 * its vector. Here is the first-level dispatch for ring 3 events.
+	 */
+	user_handlers[regs->type](regs);
+}
+
+__visible noinstr void fred_entry_from_kernel(struct pt_regs *regs)
+{
+	static const fred_handler kernel_handlers[FRED_EVENT_TYPE_COUNT] =
+	{
+		[EVENT_TYPE_HWINT]	= fred_hw_interrupt,
+		[EVENT_TYPE_RESERVED]	= fred_bad_event,
+		[EVENT_TYPE_NMI]	= fred_exc_nmi,
+		[EVENT_TYPE_SWINT]	= fred_bad_event,
+		[EVENT_TYPE_HWFAULT]	= fred_exception,
+		[EVENT_TYPE_SWFAULT]	= fred_exception,
+		[EVENT_TYPE_PRIVSW]	= fred_exception,
+		[EVENT_TYPE_OTHER]	= fred_bad_event
+	};
+
+	/*
+	 * FRED employs a two-level event dispatch mechanism, with the
+	 * first-level on the type of an event and the second-level on
+	 * its vector. Here is the first-level dispatch for ring 0 events.
+	 */
+	kernel_handlers[regs->type](regs);
+}
diff --git a/arch/x86/include/asm/asm-prototypes.h b/arch/x86/include/asm/asm-prototypes.h
index b1a98fa38828..36505b991f88 100644
--- a/arch/x86/include/asm/asm-prototypes.h
+++ b/arch/x86/include/asm/asm-prototypes.h
@@ -13,6 +13,7 @@
 #include <asm/preempt.h>
 #include <asm/asm.h>
 #include <asm/gsseg.h>
+#include <asm/fred.h>
 
 #ifndef CONFIG_X86_CMPXCHG64
 extern void cmpxchg8b_emu(void);
diff --git a/arch/x86/include/asm/fred.h b/arch/x86/include/asm/fred.h
index bd701ac87528..3c91f0eae62e 100644
--- a/arch/x86/include/asm/fred.h
+++ b/arch/x86/include/asm/fred.h
@@ -118,6 +118,10 @@ DECLARE_FRED_HANDLER(fred_exc_page_fault);
 DECLARE_FRED_HANDLER(fred_exc_machine_check);
 DECLARE_FRED_HANDLER(fred_exc_double_fault);
 
+/* The actual assembly entry point for ring 3 and 0 */
+extern asmlinkage __visible void fred_entrypoint_user(void);
+extern asmlinkage __visible void fred_entrypoint_kernel(void);
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* CONFIG_X86_FRED */
diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index 3b743c3fbe91..0df3a3cc7e0f 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -661,6 +661,8 @@ DECLARE_IDTENTRY_RAW(X86_TRAP_MC,	exc_machine_check);
 #ifdef CONFIG_XEN_PV
 DECLARE_IDTENTRY_RAW(X86_TRAP_MC,	xenpv_exc_machine_check);
 #endif
+#else
+#define fred_exc_machine_check		fred_bad_event
 #endif
 
 /* NMI */
@@ -699,6 +701,8 @@ DECLARE_IDTENTRY_RAW_ERRORCODE(X86_TRAP_DF,	xenpv_exc_double_fault);
 /* #CP */
 #ifdef CONFIG_X86_KERNEL_IBT
 DECLARE_IDTENTRY_ERRORCODE(X86_TRAP_CP,	exc_control_protection);
+#else
+#define fred_exc_control_protection	fred_bad_event
 #endif
 
 /* #VC */
-- 
2.34.1

