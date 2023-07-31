Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B93B768D5A
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 09:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbjGaHLv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 03:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjGaHLa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 03:11:30 -0400
Received: from mgamail.intel.com (unknown [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02573210C;
        Mon, 31 Jul 2023 00:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690787363; x=1722323363;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0Vsn6bDzpRkXYLGAG2NP2KMCccOE1uQI/p8GcVukrL0=;
  b=UwiW2QVw9Ogi5/7ebMqH0f/lzptRFLkpNDCtuT7EMADADnKu9GP67vWk
   Q6+4QrXcvCfNQV9ycTebE9j0j/OIT4v5tXcKxD5FDWgKlxGgzdjhgbQ7N
   /ZWb81pvC9JJ71yMdK2o9bnhcBdI3cSgFKBZxcuh15BacXOxe4n3nW7Gp
   f7t/u5LNR35R7BMr8SmfTm7NK6T8btghj3bX71HHchG0NQ8UniK58HCNu
   rlTtex5VhQJlfXhixhK/xwnz0hpnwUMiOKUAp6PlyZIHQPZOsJWBCNmts
   GaY9BjKbnawx+HrJTDYKKubtABuv6FkmQK1tfv0YA2lFpoM09rrEmCAf2
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10787"; a="348538894"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="348538894"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 00:08:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10787"; a="851922998"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="851922998"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga004.jf.intel.com with ESMTP; 31 Jul 2023 00:08:56 -0700
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
Subject: [PATCH v9 26/36] x86/traps: Add sysvec_install() to install a system interrupt handler
Date:   Sun, 30 Jul 2023 23:40:25 -0700
Message-Id: <20230731064025.3819-1-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add sysvec_install() to install a system interrupt handler into both
the IDT and system_interrupt_handlers. The latter is used to dispatch
system interrupts to their respective handlers when FRED is enabled.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---

Changes since v8:
* Introduce a macro sysvec_install() to derive the asm handler name from
  a C handler, which simplifies the code and avoids an ugly typecast
  (Thomas Gleixner).
---
 arch/x86/include/asm/traps.h     | 19 +++++++++++++++++++
 arch/x86/kernel/cpu/acrn.c       |  5 +++--
 arch/x86/kernel/cpu/mshyperv.c   | 16 ++++++++--------
 arch/x86/kernel/kvm.c            |  2 +-
 arch/x86/kernel/traps.c          |  6 ++++++
 drivers/xen/events/events_base.c |  3 ++-
 6 files changed, 39 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 47ecfff2c83d..cba3e4dfc329 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -47,4 +47,23 @@ void __noreturn handle_stack_overflow(struct pt_regs *regs,
 				      struct stack_info *info);
 #endif
 
+#ifdef CONFIG_X86_64
+inline void set_sysvec_handler(unsigned int i, system_interrupt_handler func);
+
+static inline void sysvec_setup_fred(unsigned int vector, system_interrupt_handler func)
+{
+	BUG_ON(vector < FIRST_SYSTEM_VECTOR);
+	set_sysvec_handler(vector - FIRST_SYSTEM_VECTOR, func);
+}
+#else
+static inline void sysvec_setup_fred(unsigned int vector, system_interrupt_handler func)
+{
+}
+#endif
+
+#define sysvec_install(vector, func) {					\
+	sysvec_setup_fred(vector, func);				\
+	alloc_intr_gate(vector, asm_##func);				\
+}
+
 #endif /* _ASM_X86_TRAPS_H */
diff --git a/arch/x86/kernel/cpu/acrn.c b/arch/x86/kernel/cpu/acrn.c
index 485441b7f030..a879b4b87740 100644
--- a/arch/x86/kernel/cpu/acrn.c
+++ b/arch/x86/kernel/cpu/acrn.c
@@ -18,6 +18,7 @@
 #include <asm/hypervisor.h>
 #include <asm/idtentry.h>
 #include <asm/irq_regs.h>
+#include <asm/traps.h>
 
 static u32 __init acrn_detect(void)
 {
@@ -26,8 +27,8 @@ static u32 __init acrn_detect(void)
 
 static void __init acrn_init_platform(void)
 {
-	/* Setup the IDT for ACRN hypervisor callback */
-	alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, asm_sysvec_acrn_hv_callback);
+	/* Install system interrupt handler for ACRN hypervisor callback */
+	sysvec_install(HYPERVISOR_CALLBACK_VECTOR, sysvec_acrn_hv_callback);
 
 	x86_platform.calibrate_tsc = acrn_get_tsc_khz;
 	x86_platform.calibrate_cpu = acrn_get_tsc_khz;
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index c7969e806c64..134830a7f575 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -28,6 +28,7 @@
 #include <asm/i8259.h>
 #include <asm/apic.h>
 #include <asm/timer.h>
+#include <asm/traps.h>
 #include <asm/reboot.h>
 #include <asm/nmi.h>
 #include <clocksource/hyperv_timer.h>
@@ -480,19 +481,18 @@ static void __init ms_hyperv_init_platform(void)
 	 */
 	x86_platform.apic_post_init = hyperv_init;
 	hyperv_setup_mmu_ops();
-	/* Setup the IDT for hypervisor callback */
-	alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, asm_sysvec_hyperv_callback);
 
-	/* Setup the IDT for reenlightenment notifications */
+	/* Install system interrupt handler for hypervisor callback */
+	sysvec_install(HYPERVISOR_CALLBACK_VECTOR, sysvec_hyperv_callback);
+
+	/* Install system interrupt handler for reenlightenment notifications */
 	if (ms_hyperv.features & HV_ACCESS_REENLIGHTENMENT) {
-		alloc_intr_gate(HYPERV_REENLIGHTENMENT_VECTOR,
-				asm_sysvec_hyperv_reenlightenment);
+		sysvec_install(HYPERV_REENLIGHTENMENT_VECTOR, sysvec_hyperv_reenlightenment);
 	}
 
-	/* Setup the IDT for stimer0 */
+	/* Install system interrupt handler for stimer0 */
 	if (ms_hyperv.misc_features & HV_STIMER_DIRECT_MODE_AVAILABLE) {
-		alloc_intr_gate(HYPERV_STIMER0_VECTOR,
-				asm_sysvec_hyperv_stimer0);
+		sysvec_install(HYPERV_STIMER0_VECTOR, sysvec_hyperv_stimer0);
 	}
 
 # ifdef CONFIG_SMP
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 1cceac5984da..12c799412c5d 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -829,7 +829,7 @@ static void __init kvm_guest_init(void)
 
 	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_INT) && kvmapf) {
 		static_branch_enable(&kvm_async_pf_enabled);
-		alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, asm_sysvec_kvm_asyncpf_interrupt);
+		sysvec_install(HYPERVISOR_CALLBACK_VECTOR, sysvec_kvm_asyncpf_interrupt);
 	}
 
 #ifdef CONFIG_SMP
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index e430a8c47931..9040c7f01c93 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -1536,6 +1536,12 @@ static system_interrupt_handler system_interrupt_handlers[NR_SYSTEM_VECTORS] = {
 
 #undef SYSV
 
+void set_sysvec_handler(unsigned int i, system_interrupt_handler func)
+{
+	BUG_ON(i >= NR_SYSTEM_VECTORS);
+	system_interrupt_handlers[i] = func;
+}
+
 #endif /* CONFIG_X86_64 */
 
 void __init trap_init(void)
diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index c7715f8bd452..16d51338e1f8 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -45,6 +45,7 @@
 #include <asm/irq.h>
 #include <asm/io_apic.h>
 #include <asm/i8259.h>
+#include <asm/traps.h>
 #include <asm/xen/cpuid.h>
 #include <asm/xen/pci.h>
 #endif
@@ -2249,7 +2250,7 @@ static __init void xen_alloc_callback_vector(void)
 		return;
 
 	pr_info("Xen HVM callback vector for event delivery is enabled\n");
-	alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, asm_sysvec_xen_hvm_callback);
+	sysvec_install(HYPERVISOR_CALLBACK_VECTOR, sysvec_xen_hvm_callback);
 }
 #else
 void xen_setup_callback_vector(void) {}
-- 
2.34.1

