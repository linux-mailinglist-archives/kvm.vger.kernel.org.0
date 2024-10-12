Return-Path: <kvm+bounces-28673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0C8099B1DA
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 09:56:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 560C4B239DF
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 07:56:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29E6F143723;
	Sat, 12 Oct 2024 07:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kQd4ReRH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57AFBA49;
	Sat, 12 Oct 2024 07:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728719772; cv=none; b=hbZocSrLE9tasejoDkoU3NvyFPODOACR0F23cUXhGPTgmR4YrDVO19IlKUdDMGbbgcap5frD9Wb13FM84+DfLGKGyKdNl+uK96zamHIGG5Hj/OFGu5d+v9EDYscx+TYkPuAaiZmhji6PsYpQj7GnQTmd6uAuvUwCWoHRsYne8ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728719772; c=relaxed/simple;
	bh=gV18vE+WympxuPSQ5mO9wGJcJQHcws7Y2Wv52F6le94=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HMFQpcfi5uPPK30pTXq5qCVudr806DifoOEMa/BbAdlxDNB6350TVQY1y/FLfh1c9pWdi6ySgfXMj744qPJisTxCNe8eCRdhQnmnedLSsR02nVBeLFMKoZKvET4SkycZvXfYpUehB+8mzbqgPoCu2bLBCbW4UO64p5Fk6ePSKuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kQd4ReRH; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728719770; x=1760255770;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gV18vE+WympxuPSQ5mO9wGJcJQHcws7Y2Wv52F6le94=;
  b=kQd4ReRHHzQRBrWZadUj0Av6YKMVx/faLOrTQEtyK2sp6Yd6uqBnPI9G
   a3sLdF5Ag+vDNNnC+QfRPdOcVUtOKFcl8IBbmoE9u1MAP2dZ1rrCsX6Fd
   gXPcmV8pIBDhhSAYVbdQ3iRcCyOq4QCVa9vR4pKp3yBqjTr7ZTOeRxUQe
   CEK/MaLNXhyEbPDAesYcwR+Apb1+tC70qEIR9Lch27W9cvKaNn0iBrz2R
   a3CS1utpFMfGvUHCs8oVM8QXiuWxY+iRopvDF+L28pTGoOEGy/OB8UC5u
   Q0/ifrJOg3PBRBWXpTxVk3Ck8jMfv002RRhyp9HBDJknZ/6jU56XCNs9c
   A==;
X-CSE-ConnectionGUID: V3LDjKJUQfSWu6KYGqEOEA==
X-CSE-MsgGUID: SeBnoHlKTjuThy/vQ5v7qg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="39510284"
X-IronPort-AV: E=Sophos;i="6.11,198,1725346800"; 
   d="scan'208";a="39510284"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2024 00:56:09 -0700
X-CSE-ConnectionGUID: e1ylxZniRm2Kd32uxXX+PA==
X-CSE-MsgGUID: a53GQsa3RQy/BxS85afHCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,198,1725346800"; 
   d="scan'208";a="82116736"
Received: from ls.amr.corp.intel.com (HELO localhost) ([172.25.112.54])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2024 00:56:09 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: kvm@vger.kernel.org,
	pbonzini@redhat.com
Cc: Sean Christopherson <seanjc@google.com>,
	chao.gao@intel.com,
	isaku.yamahata@intel.com,
	rick.p.edgecombe@intel.com,
	yan.y.zhao@intel.com,
	linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com,
	Nikunj A Dadhania <nikunj@amd.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 0/2] KVM: kvm-coco-queue: Support protected TSC
Date: Sat, 12 Oct 2024 00:55:54 -0700
Message-ID: <cover.1728719037.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series is for the kvm-coco-queue branch.  The change for TDX KVM is
included at the last.  The test is done by create TDX vCPU and run, get TSC
offset via vCPU device attributes and compare it with the TDX TSC OFFSET
metadata.  Because the test requires the TDX KVM and TDX KVM kselftests, don't
include it in this patch series.


Background
----------
X86 confidential computing technology defines protected guest TSC so that the
VMM can't change the TSC offset/multiplier once vCPU is initialized and the
guest can trust TSC.  The SEV-SNP defines Secure TSC as optional.  TDX mandates
it.  The TDX module determines the TSC offset/multiplier.  The VMM has to
retrieve them.

On the other hand, the x86 KVM common logic tries to guess or adjust the TSC
offset/multiplier for better guest TSC and TSC interrupt latency at KVM vCPU
creation (kvm_arch_vcpu_postcreate()), vCPU migration over pCPU
(kvm_arch_vcpu_load()), vCPU TSC device attributes (kvm_arch_tsc_set_attr()) and
guest/host writing to TSC or TSC adjust MSR (kvm_set_msr_common()).


Problem
-------
The current x86 KVM implementation conflicts with protected TSC because the
VMM can't change the TSC offset/multiplier.  Disable or ignore the KVM
logic to change/adjust the TSC offset/multiplier somehow.

Because KVM emulates the TSC timer or the TSC deadline timer with the TSC
offset/multiplier, the TSC timer interrupts are injected to the guest at the
wrong time if the KVM TSC offset is different from what the TDX module
determined.

Originally the issue was found by cyclic test of rt-test [1] as the latency in
TDX case is worse than VMX value + TDX SEAMCALL overhead.  It turned out that
the KVM TSC offset is different from what the TDX module determines.


Solution
--------
The solution is to keep the KVM TSC offset/multiplier the same as the value of
the TDX module somehow.  Possible solutions are as follows.
- Skip the logic
  Ignore (or don't call related functions) the request to change the TSC
  offset/multiplier.
  Pros
  - Logically clean.  This is similar to the guest_protected case.
  Cons
  - Needs to identify the call sites.

- Revert the change at the hooks after TSC adjustment
  x86 KVM defines the vendor hooks when the TSC offset/multiplier are
  changed.  The callback can revert the change.
  Pros
  - We don't need to care about the logic to change the TSC offset/multiplier.
  Cons:
  - Hacky to revert the KVM x86 common code logic.

Choose the first one.  With this patch series, SEV-SNP secure TSC can be
supported.


Patches:
1: Preparation for the next patch
2: Skip the logic to adjust the TSC offset/multiplier in the common x86 KVM logic

[1] https://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git

Changes for TDX KVM

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 8785309ccb46..969da729d89f 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -694,8 +712,6 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.cr0_guest_owned_bits = -1ul;
 	vcpu->arch.cr4_guest_owned_bits = -1ul;
 
-	vcpu->arch.tsc_offset = kvm_tdx->tsc_offset;
-	vcpu->arch.l1_tsc_offset = vcpu->arch.tsc_offset;
 	/*
 	 * TODO: support off-TD debug.  If TD DEBUG is enabled, guest state
 	 * can be accessed. guest_state_protected = false. and kvm ioctl to
@@ -706,6 +722,13 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 	 */
 	vcpu->arch.guest_state_protected = true;
 
+	/* VMM can't change TSC offset/multiplier as TDX module manages them. */
+	vcpu->arch.guest_tsc_protected = true;
+	vcpu->arch.tsc_offset = kvm_tdx->tsc_offset;
+	vcpu->arch.l1_tsc_offset = vcpu->arch.tsc_offset;
+	vcpu->arch.tsc_scaling_ratio = kvm_tdx->tsc_multiplier;
+	vcpu->arch.l1_tsc_scaling_ratio = kvm_tdx->tsc_multiplier;
+
 	if ((kvm_tdx->xfam & XFEATURE_MASK_XTILE) == XFEATURE_MASK_XTILE)
 		vcpu->arch.xfd_no_write_intercept = true;
 
@@ -2674,6 +2697,7 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 		goto out;
 
 	kvm_tdx->tsc_offset = td_tdcs_exec_read64(kvm_tdx, TD_TDCS_EXEC_TSC_OFFSET);
+	kvm_tdx->tsc_multiplier = td_tdcs_exec_read64(kvm_tdx, TD_TDCS_EXEC_TSC_MULTIPLIER);
 	kvm_tdx->attributes = td_params->attributes;
 	kvm_tdx->xfam = td_params->xfam;
 
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 614b1c3b8483..c0e4fa61cab1 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -42,6 +42,7 @@ struct kvm_tdx {
 	bool tsx_supported;
 
 	u64 tsc_offset;
+	u64 tsc_multiplier;
 
 	enum kvm_tdx_state state;
 
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index 861c0f649b69..be4cf65c90a8 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -69,6 +69,7 @@
 
 enum tdx_tdcs_execution_control {
 	TD_TDCS_EXEC_TSC_OFFSET = 10,
+	TD_TDCS_EXEC_TSC_MULTIPLIER = 11,
 };
 
 enum tdx_vcpu_guest_other_state {

---
Isaku Yamahata (2):
  KVM: x86: Push down setting vcpu.arch.user_set_tsc
  KVM: x86: Don't allow tsc_offset, tsc_scaling_ratio to change

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 21 ++++++++++++++-------
 2 files changed, 15 insertions(+), 7 deletions(-)


base-commit: 909f9d422f59f863d7b6e4e2c6e57abb97a27d4d
-- 
2.45.2


