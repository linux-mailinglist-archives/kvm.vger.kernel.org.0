Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA672B4F74
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388478AbgKPS3f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:29:35 -0500
Received: from mga02.intel.com ([134.134.136.20]:48448 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388296AbgKPS2S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:18 -0500
IronPort-SDR: PcUpB1VtxuHYlEa4fLYRvbx/qwmu5nm7RKQIKF6cLe4Gee1uvDqqR7Rwn0AIF0Y55NiIDYZWU2
 W7fkfXhLWE2Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="157819189"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="157819189"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:18 -0800
IronPort-SDR: GGz46BLE+1CSeSwbw1SfIA+tXn/PkoV4eAywjZirIFZmcH9evOtMGgfHKwT4MmL1kxx5hYjvNl
 CoHzMwlKh06A==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400528308"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:17 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@linux.intel.com>
Subject: [RFC PATCH 55/67] KVM: TDX: Add SEAMRR related MSRs macro definition
Date:   Mon, 16 Nov 2020 10:26:40 -0800
Message-Id: <7e03253675d49ee0d4af5ade35752e59147a3c69.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Kai Huang <kai.huang@linux.intel.com>

Two new MSRs IA32_SEAMRR_PHYS_BASE and IA32_SEAMRR_PHYS_MASK are added
in SPR for TDX. Add macro definition for both of them.

Signed-off-by: Kai Huang <kai.huang@linux.intel.com>
---
 arch/x86/include/asm/msr-index.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index aad12236b33c..f42da6b11b42 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -924,4 +924,12 @@
 #define MSR_VM_IGNNE                    0xc0010115
 #define MSR_VM_HSAVE_PA                 0xc0010117
 
+/* Intel SEAMRR */
+#define MSR_IA32_SEAMRR_PHYS_BASE	0x00001400
+#define MSR_IA32_SEAMRR_PHYS_MASK	0x00001401
+
+#define MSR_IA32_SEAMRR_PHYS_BASE_CONFIGURED	(1ULL << 3)
+#define MSR_IA32_SEAMRR_PHYS_MASK_ENABLED	(1ULL << 11)
+#define MSR_IA32_SEAMRR_PHYS_MASK_LOCKED	(1ULL << 10)
+
 #endif /* _ASM_X86_MSR_INDEX_H */
-- 
2.17.1

