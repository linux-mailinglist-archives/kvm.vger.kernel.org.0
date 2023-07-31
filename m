Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281DC768CBB
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 09:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbjGaHCY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 03:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbjGaHCK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 03:02:10 -0400
Received: from mgamail.intel.com (unknown [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DCB185;
        Mon, 31 Jul 2023 00:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690786929; x=1722322929;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f1KjXTBSCMC/3m47AKFmo72XHXtCtx2wNvJSmQVR8WU=;
  b=kqBHMwGjigCkQXGhyJ0SsSXb5L9lppOMXrViqJkaj3h7QUqCppXx0/E8
   vsXLwYzVeZKZuopG2nYUFHL8ETOGY4xgO4Gz80PoAVYDekBrt/I8plwnZ
   T7xtFi6tKPINsNWFni4h2Lz1SBLumAQx+lVTa9TPT6CFa7a802cDFX6FG
   mO27iAqqZVQNiMEXCGdh+tDiLkjj21TAqZSSYi4UEF9o8ST1/v0ZOHCtW
   UfuhmTUurOSK2p56gJui0wm/GyCcdf+IfvAfxI9b7a65LIwp30FKLjora
   ZMLH56vHrX6cB6KPUkRXtpYYHVo7cS7LN+sM5QufmF4ChsG21J9BcO+0g
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10787"; a="371648891"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="371648891"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 00:01:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="871543380"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga001.fm.intel.com with ESMTP; 31 Jul 2023 00:01:59 -0700
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
Subject: [PATCH v9 09/36] x86/fred: Make unions for the cs and ss fields in struct pt_regs
Date:   Sun, 30 Jul 2023 23:32:50 -0700
Message-Id: <20230731063317.3720-10-xin3.li@intel.com>
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

Make the cs and ss fields in struct pt_regs unions between the actual
selector and the unsigned long stack slot. FRED uses this space to
store additional flags.

The printk changes are simply due to the cs and ss fields changed to
unsigned short from unsigned long.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---

Changes since v8:
* Reflect stack frame definition changes from FRED spec 3.0 to 5.0.
* Use __packed instead of __attribute__((__packed__)) (Borislav Petkov).
* Put all comments above the members, like the rest of the file does
  (Borislav Petkov).

Changes since v3:
* Rename csl/ssl of the pt_regs structure to csx/ssx (x for extended)
  (Andrew Cooper).
---
 arch/x86/entry/vsyscall/vsyscall_64.c |  2 +-
 arch/x86/include/asm/ptrace.h         | 57 +++++++++++++++++++++++++--
 arch/x86/kernel/process_64.c          |  2 +-
 3 files changed, 56 insertions(+), 5 deletions(-)

diff --git a/arch/x86/entry/vsyscall/vsyscall_64.c b/arch/x86/entry/vsyscall/vsyscall_64.c
index e0ca8120aea8..a3c0df11d0e6 100644
--- a/arch/x86/entry/vsyscall/vsyscall_64.c
+++ b/arch/x86/entry/vsyscall/vsyscall_64.c
@@ -76,7 +76,7 @@ static void warn_bad_vsyscall(const char *level, struct pt_regs *regs,
 	if (!show_unhandled_signals)
 		return;
 
-	printk_ratelimited("%s%s[%d] %s ip:%lx cs:%lx sp:%lx ax:%lx si:%lx di:%lx\n",
+	printk_ratelimited("%s%s[%d] %s ip:%lx cs:%x sp:%lx ax:%lx si:%lx di:%lx\n",
 			   level, current->comm, task_pid_nr(current),
 			   message, regs->ip, regs->cs,
 			   regs->sp, regs->ax, regs->si, regs->di);
diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index f4db78b09c8f..f1690beffd15 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -80,15 +80,66 @@ struct pt_regs {
 /*
  * On syscall entry, this is syscall#. On CPU exception, this is error code.
  * On hw interrupt, it's IRQ number:
+ *
+ * A FRED stack frame starts here:
+ *   1) It _always_ includes an error code;
+ *   2) The return frame for eretu/erets starts here.
  */
 	unsigned long orig_ax;
 /* Return frame for iretq */
 	unsigned long ip;
-	unsigned long cs;
+	union {
+/* CS extended: CS + any fields above it */
+		unsigned long csx;
+		struct {
+/* CS selector proper */
+			unsigned short cs;
+/* The stack level (SL) at the time the event occurred */
+			unsigned int sl		: 2;
+/* Set to indicate that indirect branch tracker in WAIT_FOR_ENDBRANCH state */
+			unsigned int wfe	: 1;
+			unsigned int __csx_resv1: 13;
+			unsigned int __csx_resv2: 32;
+		} __packed;
+	};
 	unsigned long flags;
 	unsigned long sp;
-	unsigned long ss;
-/* top of stack page */
+	union {
+/* SS extended: SS + any fields above it */
+		unsigned long ssx;
+		struct {
+/* SS selector proper */
+			unsigned short ss;
+/* Set to indicate that interrupt blocking by STI was in effect */
+			unsigned int sti	: 1;
+/* For SYSCALL, SYSENTER, or INT n (for any value of n) */
+			unsigned int sys	: 1;
+			unsigned int nmi	: 1;
+			unsigned int __ssx_resv1: 13;
+/* Event information fields, ignored by the FRED return instructions */
+			unsigned int vector	: 8;
+			unsigned int __ssx_resv2: 8;
+			unsigned int type	: 4;
+			unsigned int __ssx_resv3: 4;
+/* Set to indicate that the event was incident to enclave execution */
+			unsigned int enc	: 1;
+/* Set to indicate that the logical processor had been in 64-bit mode */
+			unsigned int l		: 1;
+/*
+ * Set to indicate the event is a nested exception encountered during FRED
+ * event delivery of another event. This bit is not set if the event is
+ * double fault (#DF).
+ */
+			unsigned int nst	: 1;
+			unsigned int __ssx_resv4: 1;
+/* The length of the instruction causing the event */
+			unsigned int instr_len	: 4;
+		} __packed;
+	};
+/*
+ * Top of stack page on IDT systems, while FRED systems have extra fields
+ * defined above, see <asm/fred.h>.
+ */
 };
 
 #endif /* !__i386__ */
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 3d181c16a2f6..265ab8fcb146 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -117,7 +117,7 @@ void __show_regs(struct pt_regs *regs, enum show_regs_mode mode,
 
 	printk("%sFS:  %016lx(%04x) GS:%016lx(%04x) knlGS:%016lx\n",
 	       log_lvl, fs, fsindex, gs, gsindex, shadowgs);
-	printk("%sCS:  %04lx DS: %04x ES: %04x CR0: %016lx\n",
+	printk("%sCS:  %04x DS: %04x ES: %04x CR0: %016lx\n",
 		log_lvl, regs->cs, ds, es, cr0);
 	printk("%sCR2: %016lx CR3: %016lx CR4: %016lx\n",
 		log_lvl, cr2, cr3, cr4);
-- 
2.34.1

