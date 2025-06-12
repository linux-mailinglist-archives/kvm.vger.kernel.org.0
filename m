Return-Path: <kvm+bounces-49323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BC584AD7DCC
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 23:51:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E68B3B3D42
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 21:50:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21A512E0B59;
	Thu, 12 Jun 2025 21:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QS9zHrir"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C452D5419;
	Thu, 12 Jun 2025 21:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749765030; cv=none; b=KuSSevxOEOblXzJUnljtUxWC9uZholPSJZD4EaaMB6veVu3nFaPPKT1eJNtOVLJzGeAtSgoAfvdcZwi0wTD+AsnN+uPwHUIB5tG4GA5i8ke05D/Yf80IulSPE7NefQ+d0enPZbgbKRkjohmUq+tAmCKmumbLVFWObaIpzvsAGg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749765030; c=relaxed/simple;
	bh=TPNvueekJgJ+6J+ut2o8hb/2cBDnuiMm8XuCz7DRZyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7dWdktilO+jznMQ5BDAux3Gb0w9rPh/HK0DzDyEZr9tj/phLddtjoSs0fONfpfJxYWniUjZ7h/a4EbeLyFidk4R+7/AQydut4Czmskd5lrKs9WsYvILiuxFE0F8Jk83hpyqdtEkvcK87iWFGBpJQaW3RCMcFH5AZzjGyJ6wUMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QS9zHrir; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749765028; x=1781301028;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TPNvueekJgJ+6J+ut2o8hb/2cBDnuiMm8XuCz7DRZyE=;
  b=QS9zHrirgs6MjAutDVQcoFrl+URdnAkZEKOSswk0hzWVA2vOu+crgbKc
   QQAdjLYbt3zhzYMFkFLjy8nYrvegb2XWBinjoS8ojogUwVsF51VLx29+1
   E+ZxbZ+rX+3vJOiW42oGql+TD8Yoj5u6MB9TOMy4hycD8AP5VNiP3wdM/
   EqHvnIFTPrKIHPtS0xWZZAFi0tTncEfEbAtbaAueYBws2A6nvB8/7Hu2X
   AiUhnLCW3Y0lZHs35cvf/6Ua2XAHHJRgU8uulX/YrUSFqgQkkw58J1LLV
   KB/kfL6BDobKfSkzfZe54fJUv/hI3RepXm8HHaQ8Lulqnugrn7wDyaZ5F
   A==;
X-CSE-ConnectionGUID: Al2D1JlJR8OgLvT9+fFImw==
X-CSE-MsgGUID: ZvsP5f4rQFGRJhAH/MBtng==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="52065295"
X-IronPort-AV: E=Sophos;i="6.16,231,1744095600"; 
   d="scan'208";a="52065295"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 14:50:26 -0700
X-CSE-ConnectionGUID: +4JjIdO4R+qu1KI0pUsD3w==
X-CSE-MsgGUID: BkRwew3wSPWPBHilWxT/HQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,231,1744095600"; 
   d="scan'208";a="184881935"
Received: from sohilmeh.sc.intel.com ([172.25.103.65])
  by orviesa001.jf.intel.com with ESMTP; 12 Jun 2025 14:50:25 -0700
From: Sohil Mehta <sohil.mehta@intel.com>
To: x86@kernel.org,
	linux-kernel@vger.kernel.org
Cc: Xin Li <xin@zytor.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Sandipan Das <sandipan.das@amd.com>,
	linux-perf-users@vger.kernel.org,
	linux-edac@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH v7 01/10] x86/fred: Provide separate IRQ vs. NMI wrappers for entry from KVM
Date: Thu, 12 Jun 2025 14:48:40 -0700
Message-ID: <20250612214849.3950094-2-sohil.mehta@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250612214849.3950094-1-sohil.mehta@intel.com>
References: <20250612214849.3950094-1-sohil.mehta@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

Provide separate wrappers for forwarding IRQs vs NMIs from KVM in
anticipation of adding support for NMI source reporting, which will add
an NMI-only parameter, i.e. will further pollute the current API with a
param that is a hardcoded for one of the two call sites.

Opportunistically tag the non-FRED NMI wrapper __always_inline, as the
compiler could theoretically generate a function call and trigger and a
(completely benign) "leaving noinstr" warning.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
---
v7: New patch
---
 arch/x86/include/asm/fred.h | 30 ++++++++++++++++++++++--------
 arch/x86/kvm/vmx/vmx.c      |  4 ++--
 2 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/fred.h b/arch/x86/include/asm/fred.h
index 12b34d5b2953..552332ca060c 100644
--- a/arch/x86/include/asm/fred.h
+++ b/arch/x86/include/asm/fred.h
@@ -9,6 +9,7 @@
 #include <linux/const.h>
 
 #include <asm/asm.h>
+#include <asm/irq_vectors.h>
 #include <asm/msr.h>
 #include <asm/trapnr.h>
 
@@ -71,15 +72,27 @@ __visible void fred_entry_from_user(struct pt_regs *regs);
 __visible void fred_entry_from_kernel(struct pt_regs *regs);
 __visible void __fred_entry_from_kvm(struct pt_regs *regs);
 
-/* Can be called from noinstr code, thus __always_inline */
-static __always_inline void fred_entry_from_kvm(unsigned int type, unsigned int vector)
+/* Must be called from noinstr code, thus __always_inline */
+static __always_inline void fred_nmi_from_kvm(void)
 {
 	struct fred_ss ss = {
-		.ss     =__KERNEL_DS,
-		.type   = type,
-		.vector = vector,
-		.nmi    = type == EVENT_TYPE_NMI,
-		.lm     = 1,
+		.ss	= __KERNEL_DS,
+		.type	= EVENT_TYPE_NMI,
+		.vector	= NMI_VECTOR,
+		.nmi	= true,
+		.lm	= 1,
+	};
+
+	asm_fred_entry_from_kvm(ss);
+}
+
+static inline void fred_irq_from_kvm(unsigned int vector)
+{
+	struct fred_ss ss = {
+		.ss	= __KERNEL_DS,
+		.type	= EVENT_TYPE_EXTINT,
+		.vector	= vector,
+		.lm	= 1,
 	};
 
 	asm_fred_entry_from_kvm(ss);
@@ -110,7 +123,8 @@ static __always_inline unsigned long fred_event_data(struct pt_regs *regs) { ret
 static inline void cpu_init_fred_exceptions(void) { }
 static inline void cpu_init_fred_rsps(void) { }
 static inline void fred_complete_exception_setup(void) { }
-static inline void fred_entry_from_kvm(unsigned int type, unsigned int vector) { }
+static __always_inline void fred_nmi_from_kvm(void) { }
+static inline void fred_irq_from_kvm(unsigned int vector) { }
 static inline void fred_sync_rsp0(unsigned long rsp0) { }
 static inline void fred_update_rsp0(void) { }
 #endif /* CONFIG_X86_FRED */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4953846cb30d..8183886eda3d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6991,7 +6991,7 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu,
 
 	kvm_before_interrupt(vcpu, KVM_HANDLING_IRQ);
 	if (cpu_feature_enabled(X86_FEATURE_FRED))
-		fred_entry_from_kvm(EVENT_TYPE_EXTINT, vector);
+		fred_irq_from_kvm(vector);
 	else
 		vmx_do_interrupt_irqoff(gate_offset((gate_desc *)host_idt_base + vector));
 	kvm_after_interrupt(vcpu);
@@ -7264,7 +7264,7 @@ noinstr void vmx_handle_nmi(struct kvm_vcpu *vcpu)
 
 	kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
 	if (cpu_feature_enabled(X86_FEATURE_FRED))
-		fred_entry_from_kvm(EVENT_TYPE_NMI, NMI_VECTOR);
+		fred_nmi_from_kvm();
 	else
 		vmx_do_nmi_irqoff();
 	kvm_after_interrupt(vcpu);
-- 
2.43.0


