Return-Path: <kvm+bounces-57076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E2F51B4A871
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 11:43:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E997167DD9
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 09:43:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17DCA30ACE3;
	Tue,  9 Sep 2025 09:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FOgYSXmT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7D0307AD2;
	Tue,  9 Sep 2025 09:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757410805; cv=none; b=EoXaRRsGpyLxLwBMymnqMgWGM63ubgoU3iQYXqHvEvXZuk9nfMceFiJXrXIDIfQHqxLKLVayRNrpajlRr8jRoXUYKAmkKrq11ZsG8h8mad74nkp4J+Lxi8E50oA+RbNknzIVjKjqOH4Aps8sWW8Z1J4Kocz/JacpN+SIQynebwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757410805; c=relaxed/simple;
	bh=Iee4CLaQXxLG8uUP5bqwP61MDqXRMZclM7eNQhokwNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9tcD4zEwn8ruc0KQe2njWaIG2Ys6jcezx8xHvYC9OcM35JyjG9/EhxE3fmCnK8UUh/0s0NL5I51Lsir3NzX8159HLZvkEp/cuB1Mu9JAi1rUu77KMrDfri5uQZxPXc3g/wEqcMQSfOGwDGN0BW5gzrj/gJuu3kmZLnsidXuTDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FOgYSXmT; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757410804; x=1788946804;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Iee4CLaQXxLG8uUP5bqwP61MDqXRMZclM7eNQhokwNI=;
  b=FOgYSXmT6kMc7znkiqO7w1zc4Ft7T08d7U+ldfdXAuSOC+JZSq92E6OL
   afGcQiPvdmdA4eWOrE4PNf+TmHj0WiL7G5gl4umUhmKs/VU0PPochn4qU
   9weCEG8Ofjccwuz3PSzAnVweqDI7ycxAW1+RMy8fkNvJ7FrBT3S2cq0md
   JFFR9szp0T1/REYF3ROIRyepJtFdvGXKP6w0J+MD7x0PF1zi9atCNYVfB
   rOZN64PMA3xHCKLvcqor4ko+dd3lY4cnoFnwI7q56cSXYDNGlJ3Wk9Rdu
   JgE8It8ypFmDA2+g2sVjzPszjgN2deVV3i004TV2UjA/pSHVvsGpnkDnF
   w==;
X-CSE-ConnectionGUID: LfrkPiUGTB2PZ2jU9j9hxQ==
X-CSE-MsgGUID: v7C/Dx82Tmmh587mXVjc2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="70307275"
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="70307275"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:39:56 -0700
X-CSE-ConnectionGUID: McqjqCf1QbalR2wp4p6AiQ==
X-CSE-MsgGUID: Dy76je6IQMuLwtO6kKjzhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="172207421"
Received: from unknown (HELO CannotLeaveINTEL.jf.intel.com) ([10.165.54.94])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:39:56 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: acme@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	john.allen@amd.com,
	mingo@kernel.org,
	mingo@redhat.com,
	minipli@grsecurity.net,
	mlevitsk@redhat.com,
	namhyung@kernel.org,
	pbonzini@redhat.com,
	prsampat@amd.com,
	rick.p.edgecombe@intel.com,
	seanjc@google.com,
	shuah@kernel.org,
	tglx@linutronix.de,
	weijiang.yang@intel.com,
	x86@kernel.org,
	xin@zytor.com,
	xiaoyao.li@intel.com
Subject: [PATCH v14 12/22] KVM: x86: Save and reload SSP to/from SMRAM
Date: Tue,  9 Sep 2025 02:39:43 -0700
Message-ID: <20250909093953.202028-13-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250909093953.202028-1-chao.gao@intel.com>
References: <20250909093953.202028-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

Save CET SSP to SMRAM on SMI and reload it on RSM. KVM emulates HW arch
behavior when guest enters/leaves SMM mode,i.e., save registers to SMRAM
at the entry of SMM and reload them at the exit to SMM. Per SDM, SSP is
one of such registers on 64-bit Arch, and add the support for SSP.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/smm.c | 8 ++++++++
 arch/x86/kvm/smm.h | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
index 5dd8a1646800..b0b14ba37f9a 100644
--- a/arch/x86/kvm/smm.c
+++ b/arch/x86/kvm/smm.c
@@ -269,6 +269,10 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu,
 	enter_smm_save_seg_64(vcpu, &smram->gs, VCPU_SREG_GS);
 
 	smram->int_shadow = kvm_x86_call(get_interrupt_shadow)(vcpu);
+
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) &&
+	    kvm_msr_read(vcpu, MSR_KVM_INTERNAL_GUEST_SSP, &smram->ssp))
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 }
 #endif
 
@@ -558,6 +562,10 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
 	kvm_x86_call(set_interrupt_shadow)(vcpu, 0);
 	ctxt->interruptibility = (u8)smstate->int_shadow;
 
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) &&
+	    kvm_msr_write(vcpu, MSR_KVM_INTERNAL_GUEST_SSP, smstate->ssp))
+		return X86EMUL_UNHANDLEABLE;
+
 	return X86EMUL_CONTINUE;
 }
 #endif
diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
index 551703fbe200..db3c88f16138 100644
--- a/arch/x86/kvm/smm.h
+++ b/arch/x86/kvm/smm.h
@@ -116,8 +116,8 @@ struct kvm_smram_state_64 {
 	u32 smbase;
 	u32 reserved4[5];
 
-	/* ssp and svm_* fields below are not implemented by KVM */
 	u64 ssp;
+	/* svm_* fields below are not implemented by KVM */
 	u64 svm_guest_pat;
 	u64 svm_host_efer;
 	u64 svm_host_cr4;
-- 
2.47.3


