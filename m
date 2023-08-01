Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6F8B76AC17
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 11:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbjHAJF0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 05:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232032AbjHAJFB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 05:05:01 -0400
Received: from mgamail.intel.com (unknown [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD562D73;
        Tue,  1 Aug 2023 02:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690880610; x=1722416610;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1h9fTPNcW28O8bu/nclSFH4GxPR5CW0Rl9/PbASKNuY=;
  b=idvqPorgX8GY9j44SW+loRLPYmAOtLB5T4KiDnwZtq2W4fEPS4CqiQtO
   8hTn1p3GTcO+HcI6KkhOeUPnYsvuZyzm9rv3k7LCONcSL+VqwTaqeuser
   Kw0MkcXavpmTPATqHTzgCXxLlgHAbnRq8wgImS1aCNqrJOnS3ChcH+DLd
   6DRGDTE8vr0b/EpcBcSWNN4HzsSw6wvYwXwsX99Abyl2Su6WIOY0OlD+5
   9qhKOS5aGqPyGAiUwfEHI+Nimmh2bSqb5NfZ6fiZ4KbGUzRS/QRtGs40A
   J6QKQ53ELfNs19t9a5zsnJzHsvycg6Ykd2XDtvDJWqAq4267aDdgR6bFo
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="433082611"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="433082611"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 02:02:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="975217056"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="975217056"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga006.fm.intel.com with ESMTP; 01 Aug 2023 02:02:06 -0700
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
Subject: [PATCH RESEND v9 17/36] x86/fred: Define a common function type fred_handler
Date:   Tue,  1 Aug 2023 01:32:59 -0700
Message-Id: <20230801083318.8363-18-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230801083318.8363-1-xin3.li@intel.com>
References: <20230801083318.8363-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

FRED event delivery establishes a full supervisor context by saving
the essential information about an event to a FRED stack frame, e.g.,
the faulting linear address of a #PF is saved as event data of a FRED
stack frame. Thus a struct pt_regs has all the needed data to handle
an event and it's the only input argument of a FRED event handler.

Define fred_handler, a common function type used in the FRED event
dispatch framework, which makes it easier to find the entry points
(via grep), allows the prototype to change if necessary without
requiring changing changes everywhere, and makes sure that all the
entry points have the proper decorations (currently noinstr, but
could change in the future.)

Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/fred.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/include/asm/fred.h b/arch/x86/include/asm/fred.h
index d76e681a806f..b45c1bea5b7f 100644
--- a/arch/x86/include/asm/fred.h
+++ b/arch/x86/include/asm/fred.h
@@ -68,6 +68,19 @@
 #define FRED_SSX_64_BIT_MODE_BIT	57
 #define FRED_SSX_64_BIT_MODE		_BITUL(FRED_SSX_64_BIT_MODE_BIT)
 
+/*
+ * FRED event delivery establishes a full supervisor context by
+ * saving the essential information about an event to a FRED
+ * stack frame, e.g., the faulting linear address of a #PF is
+ * saved as event data of a FRED #PF stack frame. Thus a struct
+ * pt_regs has all the needed data to handle an event and it's
+ * the only input argument of a FRED event handler.
+ *
+ * FRED handlers need to be placed in the noinstr text section.
+ */
+#define DECLARE_FRED_HANDLER(f) void f (struct pt_regs *regs)
+#define DEFINE_FRED_HANDLER(f) noinstr DECLARE_FRED_HANDLER(f)
+
 #ifdef CONFIG_X86_FRED
 
 #ifndef __ASSEMBLY__
@@ -97,6 +110,8 @@ static __always_inline unsigned long fred_event_data(struct pt_regs *regs)
 	return fred_info(regs)->edata;
 }
 
+typedef DECLARE_FRED_HANDLER((*fred_handler));
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* CONFIG_X86_FRED */
-- 
2.34.1

