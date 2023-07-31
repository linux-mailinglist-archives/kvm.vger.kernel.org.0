Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5667768CD4
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 09:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbjGaHDr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 03:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbjGaHDY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 03:03:24 -0400
Received: from mgamail.intel.com (unknown [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1C91712;
        Mon, 31 Jul 2023 00:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690786938; x=1722322938;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R/F68dINSJ894CWgsWAeNvE3sYeHzSDBLZY+Pavzuys=;
  b=lKSYGrEu8T1GGKWNCOhRk0Xue8TyAjY+4Iev4p1UGDxMGV2/jmlBWAcS
   MmCPCT+dzXqJh3kDhnzMoELkhvcbpkbNgo/BlgKf65ja3dDt+tlDZ2daw
   T5OuyrfJR6tesxvz29mSMEqoEtDPCBNxmFqrvlHQ/SwTKKgYLmTsDtryc
   +sVWotjcqC/axyEkzJEysDA62kHSTrKseXTlbzpTIrlDFcN0AFyYJFyYb
   OrMzr30KnKALnEpnLRWc9Cy/MtGV0erQNxiE3Htyfe6RoEiOczlfrhkTa
   gckTFOy1ORX5/nMcEkhjrZW3D0tEh86VSuGdFnBZsqo2siHNxFcPDsq+h
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10787"; a="371649144"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="371649144"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 00:02:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="871543437"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga001.fm.intel.com with ESMTP; 31 Jul 2023 00:02:06 -0700
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
Subject: [PATCH v9 16/36] x86/fred: Allow single-step trap and NMI when starting a new task
Date:   Sun, 30 Jul 2023 23:32:57 -0700
Message-Id: <20230731063317.3720-17-xin3.li@intel.com>
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

Entering a new task is logically speaking a return from a system call
(exec, fork, clone, etc.). As such, if ptrace enables single stepping
a single step exception should be allowed to trigger immediately upon
entering user space. This is not optional.

NMI should *never* be disabled in user space. As such, this is an
optional, opportunistic way to catch errors.

Allow single-step trap and NMI when starting a new task, thus once
the new task enters user space, single-step trap and NMI are both
enabled immediately.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---

Changes since v8:
* Use high-order 48 bits above the lowest 16 bit SS only when FRED
  is enabled (Thomas Gleixner).
---
 arch/x86/kernel/process_64.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 6d5fed29f552..0b47871a6141 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -56,6 +56,7 @@
 #include <asm/resctrl.h>
 #include <asm/unistd.h>
 #include <asm/fsgsbase.h>
+#include <asm/fred.h>
 #ifdef CONFIG_IA32_EMULATION
 /* Not included via unistd.h */
 #include <asm/unistd_32_ia32.h>
@@ -507,8 +508,18 @@ void x86_gsbase_write_task(struct task_struct *task, unsigned long gsbase)
 static void
 start_thread_common(struct pt_regs *regs, unsigned long new_ip,
 		    unsigned long new_sp,
-		    unsigned int _cs, unsigned int _ss, unsigned int _ds)
+		    u16 _cs, u16 _ss, u16 _ds)
 {
+	/*
+	 * Paranoia: High-order 48 bits above the lowest 16 bit SS are
+	 * discarded by the legacy IRET instruction on all Intel, AMD,
+	 * and Cyrix/Centaur/VIA CPUs, thus can be set unconditionally,
+	 * even when FRED is not enabled. But we choose the safer side
+	 * to use these bits only when FRED is enabled.
+	 */
+	const unsigned long ssx_flags = cpu_feature_enabled(X86_FEATURE_FRED) ?
+		(FRED_SSX_SOFTWARE_INITIATED | FRED_SSX_NMI) : 0;
+
 	WARN_ON_ONCE(regs != current_pt_regs());
 
 	if (static_cpu_has(X86_BUG_NULL_SEG)) {
@@ -522,11 +533,11 @@ start_thread_common(struct pt_regs *regs, unsigned long new_ip,
 	loadsegment(ds, _ds);
 	load_gs_index(0);
 
-	regs->ip		= new_ip;
-	regs->sp		= new_sp;
-	regs->cs		= _cs;
-	regs->ss		= _ss;
-	regs->flags		= X86_EFLAGS_IF;
+	regs->ip	= new_ip;
+	regs->sp	= new_sp;
+	regs->csx	= _cs;
+	regs->ssx	= _ss | ssx_flags;
+	regs->flags	= X86_EFLAGS_IF | X86_EFLAGS_FIXED;
 }
 
 void
-- 
2.34.1

