Return-Path: <kvm+bounces-33268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED6A39E88DE
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 02:08:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD45E282F99
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 01:08:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF2A0154456;
	Mon,  9 Dec 2024 01:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cgGuhxbl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCEA14D2B9;
	Mon,  9 Dec 2024 01:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733706369; cv=none; b=uJPpb0CsmM9sxEg7AAZS/3ws20+uoLZ0fUVSrlTMfO0KCcpZd1eMCUsc9PZaU3DSNLlRhzNTWVugEc4Yc86lsMcW29exIoCNhiqhlsZO6m8omk5RZpKDPpO9Oa2H+4XqECTF5S6r1lEhhWi2rBPLi42xM3N7L9h35x/Jyjzot4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733706369; c=relaxed/simple;
	bh=5ml+PiaQIYfUdS9tDc806DhUEass7N5ztAX9ZhkrO+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ov5CBEYJDxwLwnNsGbd5qsXjmvZ6sU6gxixX7pM997qLqzd35F1JKDYWJ/CkcwdMvNMSbhCVZ7KsUcW33W81R4JG5Kr34Dee0vVaNII97Hc33+50VN2257j+EEgCGb7t0y4LFHFPXhEaCQnnSZldqrxZWvSE2b6oOCbFGk7RoS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cgGuhxbl; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733706367; x=1765242367;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5ml+PiaQIYfUdS9tDc806DhUEass7N5ztAX9ZhkrO+E=;
  b=cgGuhxbl55wNpLukUjQUrewCpUrigzs3DofZngZvR1jaK+sp+Dnw1AAb
   rJtcL+89R8XR+pJle75+s8w2DzaKwr8N7W5w7veKwW5SO6L25k53f4vrG
   j+yshjaoPuCMHdhYCd5aUEKNmI1WXrJ+c01dys2aj/pGaJ3E/J8p7vzGc
   QMvvL2kIcNW9j6IbNsn10jXmfXGD/Uqa3weo8y5+oujW3T2bepNqhdV29
   UsMf2xs9xveSoe3vn3dzIF/7DS1sq022aLCbbKCT7/V1mzFwZZ3keZ5vm
   aHZ6wbyxNU9OO+AqAD0VYlF2e7ojqSpbLyc+65scIzC8S4SXPapmL6S5Z
   Q==;
X-CSE-ConnectionGUID: cYn9vi9ZS+WYWQbR0WbFvA==
X-CSE-MsgGUID: NNVKE/j1SEWFrG7ko62g7g==
X-IronPort-AV: E=McAfee;i="6700,10204,11280"; a="36833715"
X-IronPort-AV: E=Sophos;i="6.12,218,1728975600"; 
   d="scan'208";a="36833715"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2024 17:06:07 -0800
X-CSE-ConnectionGUID: BFoTNLthQASMbUMSQAKndQ==
X-CSE-MsgGUID: ZXK/CwvBSY2OYBcqTfRGdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,218,1728975600"; 
   d="scan'208";a="95402501"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2024 17:06:03 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH 09/16] KVM: TDX: Complete interrupts after TD exit
Date: Mon,  9 Dec 2024 09:07:23 +0800
Message-ID: <20241209010734.3543481-10-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Complete NMI injection by updating the status of NMI injection for TDX.

Because TDX virtualizes vAPIC, and non-NMI interrupts are delivered
using posted-interrupt mechanism, KVM only needs to care about NMI
injection.

For VMX, KVM injects an NMI by setting VM_ENTRY_INTR_INFO_FIELD via
vector-event injection mechanism.  For TDX, KVM needs to request TDX
module to inject an NMI into a guest TD vCPU when the vCPU is not
active by setting PEND_NMI field within the TDX vCPU scope metadata
(Trust Domain Virtual Processor State (TDVPS)).  TDX module will attempt
to inject an NMI as soon as possible on TD entry.  KVM can read PEND_NMI
to get the status of NMI injection.  A value of 0 indicates the NMI has
been injected into the guest TD vCPU.

Update KVM's NMI status on TD exit by checking whether a requested NMI
has been injected into the TD.  Reading the PEND_NMI field via SEAMCALL
is expensive so only perform the check if an NMI was requested to inject.
If the read back value is 0, the NMI has been injected, update the NMI
status.  If the read back value is 1, no action needed since the PEND_NMI
is still set.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
TDX interrupts breakout:
- Shortlog "tdexit" -> "TD exit" (Reinette)
- Update change log as following suggested by Reinette with a little
  supplement.
  https://lore.kernel.org/lkml/fe9cec78-36ee-4a20-81df-ec837a45f69f@linux.intel.com/
- Fix comment, "nmi" -> "NMI" and add a missing period. (Reinette)
- Add a comment to explain why no need to request KVM_REQ_EVENT.

v19:
- move tdvps_management_check() to this patch
- typo: complete -> Complete in short log
---
 arch/x86/kvm/vmx/tdx.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 65fe7ba8a6c6..b0f525069ebd 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -853,6 +853,21 @@ int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static void tdx_complete_interrupts(struct kvm_vcpu *vcpu)
+{
+	/* Avoid costly SEAMCALL if no NMI was injected. */
+	if (vcpu->arch.nmi_injected) {
+		/*
+		 * No need to request KVM_REQ_EVENT because PEND_NMI is still
+		 * set if NMI re-injection needed.  No other event types need
+		 * to be handled because TDX doesn't support injection of
+		 * exception, SMI or interrupt (via event injection).
+		 */
+		vcpu->arch.nmi_injected = td_management_read8(to_tdx(vcpu),
+							      TD_VCPU_PEND_NMI);
+	}
+}
+
 struct tdx_uret_msr {
 	u32 msr;
 	unsigned int slot;
@@ -1004,6 +1019,8 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 	if (unlikely(tdx_has_exit_reason(vcpu) && tdexit_exit_reason(vcpu).failed_vmentry))
 		return EXIT_FASTPATH_NONE;
 
+	tdx_complete_interrupts(vcpu);
+
 	return tdx_exit_handlers_fastpath(vcpu);
 }
 
-- 
2.46.0


