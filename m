Return-Path: <kvm+bounces-66450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 77790CD3BC7
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 05:36:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1DB84301F246
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 04:32:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 712282236F7;
	Sun, 21 Dec 2025 04:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JovDy1yA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEDC2236E0;
	Sun, 21 Dec 2025 04:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766291504; cv=none; b=NNUR5VoSZYUO05fpSjl/PKDA1I6Fz7e6XJbLWOu3te3kaX4Y61G+6nP9e9h77pESbNlABom5zfXCsIRj/mM5Rxs0FgHM00La9PMPEdfSUktIIUiJG4O063Z2ciP14N+fBlHzUEpbbebHZMd0VLjv73j2X6rySNquf2hc/bNTHIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766291504; c=relaxed/simple;
	bh=FJMJLaZeEkRpouMa6Z8DLyquPu+lMP+v7uZ/KQreFsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdJWOPGzbm5XbQkwRqKy/Fsh1Y9pV/PhgalP3lRGTCa2F4wo16bmymPLiSxGNQgNPxwAVh4ZNFi0r2rOxzBHZbqbRh9AxR+fmlHaXXq+k0Dfg2bayzzjCpgEy4jQ82M3uKmyVgScTDjxG50Rr20Ty1HVh1c+lHKeh3pj6y3T2T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JovDy1yA; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766291502; x=1797827502;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FJMJLaZeEkRpouMa6Z8DLyquPu+lMP+v7uZ/KQreFsg=;
  b=JovDy1yA4WPPZFq8QpaioFsM5T2LsOYnJy9wb4U3q0GETa4GOI5kPhA4
   4oAvPylTYCpiKjP3ZeghGD1Q7G7Us3V3Zfh4p7E045cvo/cps3/F6iT6P
   9qXwfdkXxYwzHomf0NtBmqUQGAqwcA8dUaHpxr6lqk0BCUPfqtlobak9g
   XFfEwl/T3/BmjX2Z9NyW5BxeKLISYvlXXh/nAsebwCsjKycKeUhgDft1h
   m5HggrFrWphxaXoV4n2BvzrhI12J2Xhwr/sBJ3/eH8qkm6rQjE1Bd0Jkc
   5Cis7jjYDS30JTepHd3+KYxVTAa2NqQIrxg+cQG9k3jRoEeWkSGHsuAHD
   g==;
X-CSE-ConnectionGUID: ivY8c4yxTeGe+jb/On1N7Q==
X-CSE-MsgGUID: 8XrYOUKyQUeOsxfA+8CSJg==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="68132407"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="68132407"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 20:31:41 -0800
X-CSE-ConnectionGUID: 3iUQIzwKTGi/vDgxfrEZUg==
X-CSE-MsgGUID: cZbfERRlSbujDbm4mUUC4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="229885001"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 20 Dec 2025 20:31:41 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chao.gao@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH 08/16] KVM: VMX: Support extended register index in exit handling
Date: Sun, 21 Dec 2025 04:07:34 +0000
Message-ID: <20251221040742.29749-9-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251221040742.29749-1-chang.seok.bae@intel.com>
References: <20251221040742.29749-1-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Support 5-bit register indices in VMCS fields when APX feature is
enumerated.

The presence of the extended instruction information field is indicated
by APX enumeration, regardless of the XCR0.APX bit setting.

With APX enumerated, the previously reserved bit in the exit qualification
can be referenced safely now. However, there is no guarantee that older
implementations always zeroed this bit.

Link: https://lore.kernel.org/7bb14722-c036-4835-8ed9-046b4e67909e@redhat.com
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
Changes since last version:
* Switch the condition for using the extended instruction information
  from checking XCR0 to relying on APX enumeration (Paolo).
* Rewrite the changelog to clarify this behavior.
---
 arch/x86/kvm/vmx/vmx.h | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index f8dbad161717..937f862f060d 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -372,12 +372,26 @@ struct vmx_insn_info {
 	union insn_info info;
 };
 
-static inline struct vmx_insn_info vmx_get_insn_info(struct kvm_vcpu *vcpu __maybe_unused)
+/*
+ * The APX enumeration guarantees the presence of the extended fields.
+ * The host CPUID bit alone is sufficient to rely on it.
+ */
+static inline bool vmx_insn_info_extended(void)
+{
+	return static_cpu_has(X86_FEATURE_APX);
+}
+
+static inline struct vmx_insn_info vmx_get_insn_info(struct kvm_vcpu *vcpu)
 {
 	struct vmx_insn_info insn;
 
-	insn.extended  = false;
-	insn.info.word = vmcs_read32(VMX_INSTRUCTION_INFO);
+	if (vmx_insn_info_extended()) {
+		insn.extended   = true;
+		insn.info.dword = vmcs_read64(EXTENDED_INSTRUCTION_INFO);
+	} else {
+		insn.extended  = false;
+		insn.info.word = vmcs_read32(VMX_INSTRUCTION_INFO);
+	}
 
 	return insn;
 }
@@ -413,7 +427,10 @@ static __always_inline unsigned long vmx_get_exit_qual(struct kvm_vcpu *vcpu)
 
 static inline int vmx_get_exit_qual_gpr(struct kvm_vcpu *vcpu)
 {
-	return (vmx_get_exit_qual(vcpu) >> 8) & 0xf;
+	if (vmx_insn_info_extended())
+		return (vmx_get_exit_qual(vcpu) >> 8) & 0x1f;
+	else
+		return (vmx_get_exit_qual(vcpu) >> 8) & 0xf;
 }
 
 static __always_inline u32 vmx_get_intr_info(struct kvm_vcpu *vcpu)
-- 
2.51.0


