Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE0D768D08
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 09:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbjGaHE7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 03:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbjGaHEX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 03:04:23 -0400
Received: from mgamail.intel.com (unknown [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D27212B;
        Mon, 31 Jul 2023 00:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690786976; x=1722322976;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QeZUtDgMAPwFIrdo9TmaG72+ignP6GGIZpxe8B2aw6k=;
  b=jdf62DHeNx3GUGi4/Rmb3ifKkK2J/LQxQsM73UALjV9lAVzRty0g5hNa
   ly0iDGcLnrKt45yqiAx9Bn1TE9IfYJ0/aMUVfDFStOzWWjNLb+iDWHK2y
   cytjav7MSAkJiVmx8Gvi+68JqPdHe/j5p6ewBIeQvsKdPQS/CT0jSR30C
   VWkiwu+3TO/qLOp+4BGGR6Wut0ARGvGmKvdLog7vQDTiSsZFY28FdOIRO
   JUoEqwOkwW5YwKthwoLjTO6WtoxrdsZhQqJv8D1faNVAEfsWpBY0iiu+T
   a5uc7YaYGjid3YJ7bAZYW65tSCVbReeCvTMdbqkx4IRdYvxYJWmrC5I0Y
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10787"; a="371649351"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="371649351"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 00:02:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="871543474"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga001.fm.intel.com with ESMTP; 31 Jul 2023 00:02:13 -0700
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
Subject: [PATCH v9 22/36] x86/fred: Add a double fault entry stub for FRED
Date:   Sun, 30 Jul 2023 23:33:03 -0700
Message-Id: <20230731063317.3720-23-xin3.li@intel.com>
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

The IDT event delivery of a double fault pushes an error code into the
orig_ax member of the pt_regs structure, and the error code is passed
as the second argument of its C-handler exc_double_fault(), although
the pt_regs structure is already passed as the first argument.

The existing IDT double fault asm entry code does the following

  movq ORIG_RAX(%rsp), %rsi	/* get error code into 2nd argument*/
  movq $-1, ORIG_RAX(%rsp)	/* no syscall to restart */

to set the orig_ax member to -1 just before calling the C-handler.

X86_TRAP_TS, X86_TRAP_NP, X86_TRAP_SS, X86_TRAP_GP, X86_TRAP_AC and
X86_TRAP_CP are all handled in the same way because the IDT event
delivery pushes an error code into their stack frame for them.

The commit d99015b1abbad ("x86: move entry_64.S register saving out of
the macros") introduced the changes to set orig_ax to -1, but I can't
see why. Our tests with FRED seem fine if orig_ax is left unchanged
instead of set to -1. It's probably cleaner and simpler to remove the
second argument from exc_double_fault() while leave orig_ax unchanged
to pass the error code inside the first argument, at least on native
x86_64. That would be a separate, pre-FRED, patch.

For now just add a double fault entry stub for FRED, which simply
calls the existing exc_double_fault().

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/fred.h | 1 +
 arch/x86/kernel/traps.c     | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/include/asm/fred.h b/arch/x86/include/asm/fred.h
index f559dd9dc4f2..bd701ac87528 100644
--- a/arch/x86/include/asm/fred.h
+++ b/arch/x86/include/asm/fred.h
@@ -116,6 +116,7 @@ DECLARE_FRED_HANDLER(fred_exc_nmi);
 DECLARE_FRED_HANDLER(fred_exc_debug);
 DECLARE_FRED_HANDLER(fred_exc_page_fault);
 DECLARE_FRED_HANDLER(fred_exc_machine_check);
+DECLARE_FRED_HANDLER(fred_exc_double_fault);
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index b10464966a81..49dd92458eb0 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -555,6 +555,13 @@ DEFINE_IDTENTRY_DF(exc_double_fault)
 	instrumentation_end();
 }
 
+#ifdef CONFIG_X86_FRED
+DEFINE_FRED_HANDLER(fred_exc_double_fault)
+{
+	exc_double_fault(regs, regs->orig_ax);
+}
+#endif
+
 DEFINE_IDTENTRY(exc_bounds)
 {
 	if (notify_die(DIE_TRAP, "bounds", regs, 0,
-- 
2.34.1

