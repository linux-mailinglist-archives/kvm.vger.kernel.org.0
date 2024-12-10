Return-Path: <kvm+bounces-33351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BCD29EA3C6
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 01:48:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61310166D85
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 00:48:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C710F7E111;
	Tue, 10 Dec 2024 00:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QNMqZB4+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503D170824;
	Tue, 10 Dec 2024 00:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733791678; cv=none; b=hXJkAbZciynuL57RsFOUgR7x94CbSp5K6KiXuky3sur0/VAbau2j2atJh50xB16zL4jhQQczRxP4OqaddipVimvJPDk1s2agEjHHrgPkWBu0CJapwmcZl58YjuOGJkQ0dihdvxT7kohW1j8T6YkQVs/EwU8Oks+EwM8vk5rpqWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733791678; c=relaxed/simple;
	bh=LtHixNDxmGs+Yn/0JWV3y5pxILC73hM/NhFnT+0NrSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tknyiIftHGJl0lCNVJXC4RLZW/Ru5Nbwcgnb5O7FH7NVqO7vT1EPcx73J9hjz2D6A1h0b8OHxUbyk0/dfuwsjZ5RNcyau0knxy6jW+aqCxAcb5Tv61xccvPx1fbBD56tbMMUUm30FbNA7ddqEHC5IEyK35YSBkezeMPJwlLF8qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QNMqZB4+; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733791677; x=1765327677;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LtHixNDxmGs+Yn/0JWV3y5pxILC73hM/NhFnT+0NrSQ=;
  b=QNMqZB4+NQ5CVvd4YdiTX74gO22YrMWlIxp5Pyo+LJmT0o8cC7sOc7Sz
   K19BKkTBc9rAc2RiYhMfNPflOFQBgdP/3XfA45Giy2sLXjFpDvgS8FJII
   H32J5KtXA0TB6tpF7L50Tpab/ENkLotcWHaDNFCvoiw0fUQyWY8Kue/lm
   OlOAcpuNFThPF4bgLjT4iW92p4PYQ6u81tqIn3I4KZ2gWoum9B2Q27j1O
   7tbQvfl+d0GTp3leh8/oNGI7D1MACKrQx4bapI9Z6O4A1xcm7/pxHvMDL
   N0ajmDBkZuruluq5OYIdXjuizbsIUy0kOWBFqvRhX9e88YmbAfUvvisnn
   g==;
X-CSE-ConnectionGUID: rzmp08vyQWSWxtyLjUyEJQ==
X-CSE-MsgGUID: TyNTIKgMR3uuJYNYr+ln2w==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="44793684"
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="44793684"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 16:47:56 -0800
X-CSE-ConnectionGUID: dtiCF5rUT064Wama6d62VA==
X-CSE-MsgGUID: PtePnla1Qi+CwaWSxPFEfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="96033012"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 16:47:52 -0800
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
Subject: [PATCH 02/18] KVM: TDX: Handle EPT violation/misconfig exit
Date: Tue, 10 Dec 2024 08:49:28 +0800
Message-ID: <20241210004946.3718496-3-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241210004946.3718496-1-binbin.wu@linux.intel.com>
References: <20241210004946.3718496-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

For TDX, on EPT violation, call common __vmx_handle_ept_violation() to
trigger x86 MMU code; on EPT misconfiguration, bug the VM since it
shouldn't happen.

EPT violation due to instruction fetch should never be triggered from
shared memory in TDX guest.  If such EPT violation occurs, treat it as
broken hardware.

EPT misconfiguration shouldn't happen on neither shared nor secure EPT for
TDX guests.
- TDX module guarantees no EPT misconfiguration on secure EPT.  Per TDX
  module v1.5 spec section 9.4 "Secure EPT Induced TD Exits":
  "By design, since secure EPT is fully controlled by the TDX module, an
  EPT misconfiguration on a private GPA indicates a TDX module bug and is
  handled as a fatal error."
- For shared EPT, the MMIO caching optimization, which is the only case
  where current KVM configures EPT entries to generate EPT misconfiguration,
  is implemented in a different way for TDX guests.  KVM configures EPT
  entries to non-present value without suppressing #VE bit.  It causes #VE
  in the TDX guest and the guest will call TDG.VP.VMCALL to request MMIO
  emulation.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
[binbin: rework changelog]
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX "the rest" breakout:
- Renamed from "KVM: TDX: Handle ept violation/misconfig exit" to
  "KVM: TDX: Handle EPT violation/misconfig exit" (Reinette)
- Removed WARN_ON_ONCE(1) in tdx_handle_ept_misconfig(). (Rick)
- Add comment above EPT_VIOLATION_ACC_INSTR check. (Chao)
  https://lore.kernel.org/lkml/Zgoz0sizgEZhnQ98@chao-email/
  https://lore.kernel.org/lkml/ZjiE+O9fct5zI4Sf@chao-email/
- Remove unnecessary define of TDX_SEPT_VIOLATION_EXIT_QUAL. (Sean)
- Replace pr_warn() and KVM_EXIT_EXCEPTION with KVM_BUG_ON(). (Sean)
- KVM_BUG_ON() for EPT misconfig. (Sean)
- Rework changelog.

v14 -> v15:
- use PFERR_GUEST_ENC_MASK to tell the fault is private
---
 arch/x86/kvm/vmx/tdx.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b87daa643e6e..aecf52dda00d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1770,6 +1770,36 @@ void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 	__vmx_deliver_posted_interrupt(vcpu, &tdx->pi_desc, vector);
 }
 
+static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
+{
+	unsigned long exit_qual;
+
+	if (vt_is_tdx_private_gpa(vcpu->kvm, tdexit_gpa(vcpu))) {
+		/*
+		 * Always treat SEPT violations as write faults.  Ignore the
+		 * EXIT_QUALIFICATION reported by TDX-SEAM for SEPT violations.
+		 * TD private pages are always RWX in the SEPT tables,
+		 * i.e. they're always mapped writable.  Just as importantly,
+		 * treating SEPT violations as write faults is necessary to
+		 * avoid COW allocations, which will cause TDAUGPAGE failures
+		 * due to aliasing a single HPA to multiple GPAs.
+		 */
+		exit_qual = EPT_VIOLATION_ACC_WRITE;
+	} else {
+		exit_qual = tdexit_exit_qual(vcpu);
+		/*
+		 * EPT violation due to instruction fetch should never be
+		 * triggered from shared memory in TDX guest.  If such EPT
+		 * violation occurs, treat it as broken hardware.
+		 */
+		if (KVM_BUG_ON(exit_qual & EPT_VIOLATION_ACC_INSTR, vcpu->kvm))
+			return -EIO;
+	}
+
+	trace_kvm_page_fault(vcpu, tdexit_gpa(vcpu), exit_qual);
+	return __vmx_handle_ept_violation(vcpu, tdexit_gpa(vcpu), exit_qual);
+}
+
 int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
@@ -1814,6 +1844,11 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 		return tdx_handle_external_interrupt(vcpu);
 	case EXIT_REASON_TDCALL:
 		return handle_tdvmcall(vcpu);
+	case EXIT_REASON_EPT_VIOLATION:
+		return tdx_handle_ept_violation(vcpu);
+	case EXIT_REASON_EPT_MISCONFIG:
+		KVM_BUG_ON(1, vcpu->kvm);
+		return -EIO;
 	case EXIT_REASON_OTHER_SMI:
 		/*
 		 * Unlike VMX, SMI in SEAM non-root mode (i.e. when
-- 
2.46.0


