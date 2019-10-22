Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B192DF95C
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 02:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387573AbfJVAJD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 20:09:03 -0400
Received: from mga07.intel.com ([134.134.136.100]:64050 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387558AbfJVAJB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 20:09:01 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 17:09:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; 
   d="scan'208";a="187710437"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 21 Oct 2019 17:09:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v2 14/16] x86/cpufeatures: Clean up synthetic virtualization flags
Date:   Mon, 21 Oct 2019 17:09:00 -0700
Message-Id: <20191022000900.2426-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191021234632.32363-1-sean.j.christopherson@intel.com>
References: <20191021234632.32363-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Shift the remaining synthetic virtualization flags so that the flags
are contiguous starting from bit 0.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/cpufeatures.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 306e3e70d2d3..0543590d2442 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -222,10 +222,10 @@
 #define X86_FEATURE_IBRS_ENHANCED	( 7*32+30) /* Enhanced IBRS */
 
 /* Virtualization flags: Linux defined, word 8 */
-#define X86_FEATURE_VMMCALL		( 8*32+15) /* Prefer VMMCALL to VMCALL */
-#define X86_FEATURE_XENPV		( 8*32+16) /* "" Xen paravirtual guest */
-#define X86_FEATURE_VMCALL		( 8*32+18) /* "" Hypervisor supports the VMCALL instruction */
-#define X86_FEATURE_VMW_VMMCALL		( 8*32+19) /* "" VMware prefers VMMCALL hypercall instruction */
+#define X86_FEATURE_VMMCALL		( 8*32+ 0) /* Prefer VMMCALL to VMCALL */
+#define X86_FEATURE_XENPV		( 8*32+ 1) /* "" Xen paravirtual guest */
+#define X86_FEATURE_VMCALL		( 8*32+ 2) /* "" Hypervisor supports the VMCALL instruction */
+#define X86_FEATURE_VMW_VMMCALL		( 8*32+ 3) /* "" VMware prefers VMMCALL hypercall instruction */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EBX), word 9 */
 #define X86_FEATURE_FSGSBASE		( 9*32+ 0) /* RDFSBASE, WRFSBASE, RDGSBASE, WRGSBASE instructions*/
-- 
2.22.0

