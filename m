Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B36027ABFC1
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 12:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbjIWKL5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Sep 2023 06:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbjIWKLr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 Sep 2023 06:11:47 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BB61A8;
        Sat, 23 Sep 2023 03:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695463901; x=1726999901;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bNeoh4I4zABONAQfik1sKjrzvYgDVMEQH0uLYFn+NlU=;
  b=b+PTUHAqEW3mlhCqgSdINZV9ulURcmqLC6nJ1W/SzATjFjtYG9IkL0oB
   cY4Rb7msf449jdB2O37nwjOHI+MeqYaaqzx5w4hS1WcuIV2Qv1lLntHTN
   b7A+B5QkJnAsxrwNrFeCxVYfh/JXYJnSWh6at1CVoIk4r1oBs20Zecbv5
   cpVSJ6QjF6V1kN8zDtD71HkQvftEU7oOpi/13m2fovRZf0rXJGTiesQxl
   SQFirxaMpIK2X2uzBogeBq5RdXpvt6Lxe69gjIF3d9U/DLSAXhQooSxn+
   iIJUASph2rfUIQ56p4TD5y+ie9nUOBtl/yhGI+uQ2WOXeoiNB3E1y84Fl
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="447492143"
X-IronPort-AV: E=Sophos;i="6.03,171,1694761200"; 
   d="scan'208";a="447492143"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2023 03:11:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="813388120"
X-IronPort-AV: E=Sophos;i="6.03,171,1694761200"; 
   d="scan'208";a="813388120"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 23 Sep 2023 03:11:38 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        peterz@infradead.org, jgross@suse.com, ravi.v.shankar@intel.com,
        mhiramat@kernel.org, andrew.cooper3@citrix.com,
        jiangshanlai@gmail.com, nik.borisov@suse.com
Subject: [PATCH v11 06/37] Documentation/x86/64: Add a documentation for FRED
Date:   Sat, 23 Sep 2023 02:41:41 -0700
Message-Id: <20230923094212.26520-7-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230923094212.26520-1-xin3.li@intel.com>
References: <20230923094212.26520-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Briefly introduce FRED, and its advantages compared to IDT.

Signed-off-by: Xin Li <xin3.li@intel.com>
---

Changes since v10:
* Reword a sentence to improve readability (Nikolay Borisov).
---
 Documentation/arch/x86/x86_64/fred.rst  | 96 +++++++++++++++++++++++++
 Documentation/arch/x86/x86_64/index.rst |  1 +
 2 files changed, 97 insertions(+)
 create mode 100644 Documentation/arch/x86/x86_64/fred.rst

diff --git a/Documentation/arch/x86/x86_64/fred.rst b/Documentation/arch/x86/x86_64/fred.rst
new file mode 100644
index 000000000000..9f57e7b91f7e
--- /dev/null
+++ b/Documentation/arch/x86/x86_64/fred.rst
@@ -0,0 +1,96 @@
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
+Furthermore, the FRED architecture is easy to extend for future CPU
+architectures.
+
+Software based event dispatching
+================================
+
+FRED operates differently from IDT in terms of event handling. Instead
+of directly dispatching an event to its handler based on the event
+vector, FRED requires the software to dispatch an event to its handler
+based on both the event's type and vector. Therefore, an event dispatch
+framework must be implemented to facilitate the event-to-handler
+dispatch process. The FRED event dispatch framework takes control
+once an event is delivered, and employs a two-level dispatch.
+
+The first level dispatching is event type based, and the second level
+dispatching is event vector based.
+
+Full supervisor/user context
+============================
+
+FRED event delivery atomically save and restore full supervisor/user
+context upon event delivery and return. Thus it avoids the problem of
+transient states due to %cr2 and/or %dr6, and it is no longer needed
+to handle all the ugly corner cases caused by half baked entry states.
+
+FRED allows explicit unblock of NMI with new event return instructions
+ERETS/ERETU, avoiding the mess caused by IRET which unconditionally
+unblocks NMI, e.g., when an exception happens during NMI handling.
+
+FRED always restores the full value of %rsp, thus ESPFIX is no longer
+needed when FRED is enabled.
+
+LKGS
+====
+
+LKGS behaves like the MOV to GS instruction except that it loads the
+base address into the IA32_KERNEL_GS_BASE MSR instead of the GS
+segment’s descriptor cache. With LKGS, it ends up with avoiding
+mucking with kernel GS, i.e., an operating system can always operate
+with its own GS base address.
+
+Because FRED event delivery from ring 3 and ERETU both swap the value
+of the GS base address and that of the IA32_KERNEL_GS_BASE MSR, plus
+the introduction of LKGS instruction, the SWAPGS instruction is no
+longer needed when FRED is enabled, thus is disallowed (#UD).
+
+Stack levels
+============
+
+4 stack levels 0~3 are introduced to replace the nonreentrant IST for
+event handling, and each stack level should be configured to use a
+dedicated stack.
+
+The current stack level could be unchanged or go higher upon FRED
+event delivery. If unchanged, the CPU keeps using the current event
+stack. If higher, the CPU switches to a new event stack specified by
+the MSR of the new stack level, i.e., MSR_IA32_FRED_RSP[123].
+
+Only execution of a FRED return instruction ERET[US], could lower the
+current stack level, causing the CPU to switch back to the stack it was
+on before a previous event delivery that promoted the stack level.
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

