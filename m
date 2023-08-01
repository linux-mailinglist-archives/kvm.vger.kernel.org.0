Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDBF76ABAD
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 11:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbjHAJCU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 05:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232212AbjHAJCB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 05:02:01 -0400
Received: from mgamail.intel.com (unknown [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A71F2112;
        Tue,  1 Aug 2023 02:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690880515; x=1722416515;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6FF6EgUyznIqvHXwn5+F1gytlgvayKLTt5Pzm0+v43k=;
  b=RiXxAVtkQZC09rZcPW5YfIWOfmdNjqo2bxCYCaukz19YcljsJ28z16as
   R0rG2r85xiibOFbg7tc8unPnpTD6QfVKayGXn/qfN0PPneCqbOI8sKr7Q
   O2vg3TmQTKb8ss87QM/GAEfeBLGvRxrHUn6seKl0d8OisQqqFuZDVYWdr
   hIdr/p8ef/bEP26jHgE6JD5bNDtp9tG0fBJWhBIRvRaEr8qTW+bRbZt8R
   wYH70IGNV8/SCQefsVB5B9TnpWww2YE0xeJ8eo0lUL9hlr3lYenlePe8N
   LK3vudXxbAUIQqwhT2Jd33kug2WyxpOiS+PUZyfAaW0f7/BVrbnyo2wfX
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="433082067"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="433082067"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 02:01:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="975216947"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="975216947"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga006.fm.intel.com with ESMTP; 01 Aug 2023 02:01:51 -0700
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
Subject: [PATCH RESEND v9 01/36] Documentation/x86/64: Add documentation for FRED
Date:   Tue,  1 Aug 2023 01:32:43 -0700
Message-Id: <20230801083318.8363-2-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230801083318.8363-1-xin3.li@intel.com>
References: <20230801083318.8363-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Briefly introduce FRED, its advantages compared to IDT, and its
Linux enabling.

Signed-off-by: Xin Li <xin3.li@intel.com>
---
 Documentation/arch/x86/x86_64/fred.rst  | 102 ++++++++++++++++++++++++
 Documentation/arch/x86/x86_64/index.rst |   1 +
 2 files changed, 103 insertions(+)
 create mode 100644 Documentation/arch/x86/x86_64/fred.rst

diff --git a/Documentation/arch/x86/x86_64/fred.rst b/Documentation/arch/x86/x86_64/fred.rst
new file mode 100644
index 000000000000..27c980e882ba
--- /dev/null
+++ b/Documentation/arch/x86/x86_64/fred.rst
@@ -0,0 +1,102 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================================
+Flexible Return and Event Delivery (FRED)
+=========================================
+
+Overview
+========
+
+The FRED architecture defines simple new transitions that change
+privilege level (ring transitions). The FRED architecture was
+designed with the following goals:
+
+1) Improve overall performance and response time by replacing event
+   delivery through the interrupt descriptor table (IDT event
+   delivery) and event return by the IRET instruction with lower
+   latency transitions.
+
+2) Improve software robustness by ensuring that event delivery
+   establishes the full supervisor context and that event return
+   establishes the full user context.
+
+The new transitions defined by the FRED architecture are FRED event
+delivery and, for returning from events, two FRED return instructions.
+FRED event delivery can effect a transition from ring 3 to ring 0, but
+it is used also to deliver events incident to ring 0. One FRED
+instruction (ERETU) effects a return from ring 0 to ring 3, while the
+other (ERETS) returns while remaining in ring 0. Collectively, FRED
+event delivery and the FRED return instructions are FRED transitions.
+
+In addition to these transitions, the FRED architecture defines a new
+instruction (LKGS) for managing the state of the GS segment register.
+The LKGS instruction can be used by 64-bit operating systems that do
+not use the new FRED transitions.
+
+Software based event dispatching
+================================
+
+FRED operates differently from IDT in terms of event handling. Instead
+of directly dispatching an event to its handler based on the event
+vector, FRED requires the software to dispatch an event to its handler
+based on both the event's type and vector. Therefore, an event
+dispatch framework must be implemented to facilitate the
+event-to-handler dispatch process. The FRED event dispatch framework
+assumes control once an event is delivered, starting from two FRED
+entry points, after which several event dispatch tables are introduced
+to facilitate the dispatching.
+
+The first level dispatching is event type based, and two tables need
+to be defined, one for ring 3 event dispatching, and the other
+for ring 0.
+
+The second level dispatching is event vector based, and
+several tables need to be defined, e.g., an exception handler table
+for exception dispatching.
+
+Full supervisor/user context
+============================
+
+FRED event delivery atomically save and restore full supervisor/user
+context upon event delivery and return. Thus it avoids the problem of
+transient states due to %cr2 and/or %dr6, thus it is no longer needed
+to handle all the ugly corner cases caused by half baked CPU states.
+
+FRED allows explicit unblock of NMI with new event return instructions
+ERETS/ERETU, avoiding the mess caused by IRET which unconditionally
+unblocks NMI, when an exception happens during NMI handling.
+
+FRED always restores the full value of %rsp, thus ESPFIX is no longer
+needed when FRED is enabled.
+
+LKGS
+====
+
+LKGS behaves like the MOV to GS instruction except that it loads the
+base address into the IA32_KERNEL_GS_BASE MSR instead of the GS
+segment’s descriptor cache, which is exactly what Linux kernel does
+to load user level GS base. With LKGS, it ends up with avoiding
+mucking with kernel GS.
+
+Because FRED event delivery from ring 3 swaps the value of the GS base
+address and that of the IA32_KERNEL_GS_BASE MSR, and ERETU swaps the
+value of the GS base address and that of the IA32_KERNEL_GS_BASE MSR,
+plus the introduction of LKGS instruction, the SWAPGS instruction is
+no longer needed when FRED is enabled, thus is disallowed (#UD).
+
+Stack levels
+============
+
+4 stack levels 0~3 are introduced to replace the un-reentrant IST for
+handling events. Each stack level could be configured to use a
+dedicated stack.
+
+The current stack level could be unchanged or go higher upon FRED
+event delivery. If unchanged, the CPU keeps using the current event
+stack. If higher, the CPU switches to a new stack specified by the
+stack MSR of the new stack level.
+
+Only execution of a FRED return instruction ERETU or ERETS could lower
+the current stack level, causing the CPU to switch back to the stack
+it was on before a previous event delivery.
+satck.
diff --git a/Documentation/arch/x86/x86_64/index.rst b/Documentation/arch/x86/x86_64/index.rst
index a56070fc8e77..ad15e9bd623f 100644
--- a/Documentation/arch/x86/x86_64/index.rst
+++ b/Documentation/arch/x86/x86_64/index.rst
@@ -15,3 +15,4 @@ x86_64 Support
    cpu-hotplug-spec
    machinecheck
    fsgs
+   fred
-- 
2.34.1

