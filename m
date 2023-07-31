Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1CAE768D17
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 09:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbjGaHFa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 03:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbjGaHFL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 03:05:11 -0400
Received: from mgamail.intel.com (unknown [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6804E30C2;
        Mon, 31 Jul 2023 00:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690787007; x=1722323007;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X4MZTo9+yUn1bPdeMYVQLWvNe1DyIq6KwUj9R7l5YRg=;
  b=QocNXTlIXc34bawMb/E6KEk5BOVfTXd5aiGhQ8x+s6OXgz3JN+pMLZDe
   f0zoordHLjPtlYLmo2qSnu5I8JuVFADeMcZADUIEObyOPDlIgXJ2bj+0X
   y/kXP2Dz7kBDK1G7S4DGi1lGfJYJq5nOnQqWZoQzaw7k7OAxApxk6wbfQ
   gXCZEU5IqEki7e+b2zytPuA+AtINAMMpbE91HcN+Xag4SKVD4tQ8aKjIG
   4lZ02HJUxwCytys+rVfeko6TqwCUwusgUPTPNGp5Njp5iYnHBz5RQaHEV
   V2M1D6x7Tn4GDJuIdOqLA+mcjg5fKxlc22Dg18NT+XZYHX6FnfElLqDMu
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10787"; a="371649458"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="371649458"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 00:02:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="871543489"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga001.fm.intel.com with ESMTP; 31 Jul 2023 00:02:16 -0700
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
Subject: [PATCH v9 25/36] x86/traps: Add a system interrupt handler table for system interrupt dispatch
Date:   Sun, 30 Jul 2023 23:33:06 -0700
Message-Id: <20230731063317.3720-26-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230731063317.3720-1-xin3.li@intel.com>
References: <20230731063317.3720-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

On x86, external interrupts can be categorized into two groups:
  1) System interrupts
  2) External device interrupts

All external device interrupts are directed to the common_interrupt(),
which, in turn, dispatches these external device interrupts using a
per-CPU external device interrupt dispatch table vector_irq.

To handle system interrupts, a system interrupt handler table needs to
be introduced. This table enables the direct dispatching of a system
interrupt to its corresponding handler. As a result, a software-based
dispatch function will be implemented as:

  void external_interrupt(struct pt_regs *regs)
  {
    u8 vector = regs->vector;
    if (is_system_interrupt(vector))
      system_interrupt_handlers[vector_to_sysvec(vector)](regs);
    else /* external device interrupt */
      common_interrupt(regs);
  }

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Co-developed-by: Xin Li <xin3.li@intel.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---

Changes since v8:
* Remove junk code that assumes no local APIC on x86_64 (Thomas Gleixner).

Changes since v5:
* Initialize system_interrupt_handlers with dispatch_table_spurious_interrupt()
  instead of NULL to get rid of any NULL check (Peter Zijlstra).
---
 arch/x86/kernel/traps.c | 50 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 49dd92458eb0..e430a8c47931 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -1488,6 +1488,56 @@ DEFINE_IDTENTRY_SW(iret_error)
 }
 #endif
 
+#ifdef CONFIG_X86_64
+
+static void dispatch_table_spurious_interrupt(struct pt_regs *regs)
+{
+	dispatch_spurious_interrupt(regs, regs->vector);
+}
+
+#define SYSV(x,y) [(x) - FIRST_SYSTEM_VECTOR] = y
+
+static system_interrupt_handler system_interrupt_handlers[NR_SYSTEM_VECTORS] = {
+	[0 ... NR_SYSTEM_VECTORS-1]		= dispatch_table_spurious_interrupt,
+#ifdef CONFIG_SMP
+	SYSV(RESCHEDULE_VECTOR,			dispatch_table_sysvec_reschedule_ipi),
+	SYSV(CALL_FUNCTION_VECTOR,		dispatch_table_sysvec_call_function),
+	SYSV(CALL_FUNCTION_SINGLE_VECTOR,	dispatch_table_sysvec_call_function_single),
+	SYSV(REBOOT_VECTOR,			dispatch_table_sysvec_reboot),
+#endif
+
+#ifdef CONFIG_X86_THERMAL_VECTOR
+	SYSV(THERMAL_APIC_VECTOR,		dispatch_table_sysvec_thermal),
+#endif
+
+#ifdef CONFIG_X86_MCE_THRESHOLD
+	SYSV(THRESHOLD_APIC_VECTOR,		dispatch_table_sysvec_threshold),
+#endif
+
+#ifdef CONFIG_X86_MCE_AMD
+	SYSV(DEFERRED_ERROR_VECTOR,		dispatch_table_sysvec_deferred_error),
+#endif
+
+#ifdef CONFIG_X86_LOCAL_APIC
+	SYSV(LOCAL_TIMER_VECTOR,		dispatch_table_sysvec_apic_timer_interrupt),
+	SYSV(X86_PLATFORM_IPI_VECTOR,		dispatch_table_sysvec_x86_platform_ipi),
+# ifdef CONFIG_HAVE_KVM
+	SYSV(POSTED_INTR_VECTOR,		dispatch_table_sysvec_kvm_posted_intr_ipi),
+	SYSV(POSTED_INTR_WAKEUP_VECTOR,		dispatch_table_sysvec_kvm_posted_intr_wakeup_ipi),
+	SYSV(POSTED_INTR_NESTED_VECTOR,		dispatch_table_sysvec_kvm_posted_intr_nested_ipi),
+# endif
+# ifdef CONFIG_IRQ_WORK
+	SYSV(IRQ_WORK_VECTOR,			dispatch_table_sysvec_irq_work),
+# endif
+	SYSV(SPURIOUS_APIC_VECTOR,		dispatch_table_sysvec_spurious_apic_interrupt),
+	SYSV(ERROR_APIC_VECTOR,			dispatch_table_sysvec_error_interrupt),
+#endif
+};
+
+#undef SYSV
+
+#endif /* CONFIG_X86_64 */
+
 void __init trap_init(void)
 {
 	/* Init cpu_entry_area before IST entries are set up */
-- 
2.34.1

