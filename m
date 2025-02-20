Return-Path: <kvm+bounces-38661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BEF48A3D6B6
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 11:31:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C2579189F7C3
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 10:30:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 993BA1F1501;
	Thu, 20 Feb 2025 10:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fcbsiCAy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438DB1F12E9;
	Thu, 20 Feb 2025 10:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740047321; cv=none; b=NC5BNUnjV1moue2Kev5S7xXXsEVy1zUZN2mmdwQs6eEhDLAgQAQdH0ZwtTPKfXVja3Er938PMHVeb5ZKOZTzy/PfVPhjjStbrV4EdTPv4CdQN8YkxcnK8oIOixOeTJFVnrnbzUku67hAoljAhN+Jhf6Z0SfhozmQ3oQBhskGyZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740047321; c=relaxed/simple;
	bh=OEt8Aq7BoSOrCA2PCB6GJkHkAIJo0azxBVTNUyBIXSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXcjFawSB/d7a+PEUMYQoicWcQK5wiBNqPcP5ZEc9YvIS4rc5xUoP+ZNty1VAPh7hf3Ta/Md0qIf8xqqFTf5l6lWHLyhH625LCjM3Ikhufz5P44QVclRnVFzVUj0R4cy1J0121h5xTBzrW78CCT1MnF8H8sr2owlid4N/YIsXtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fcbsiCAy; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740047320; x=1771583320;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OEt8Aq7BoSOrCA2PCB6GJkHkAIJo0azxBVTNUyBIXSI=;
  b=fcbsiCAyn/AKdLcwvEkxJy5QlzKKNFVsGATxUVS8Ue4co8fX2635c1UQ
   4T1rYksBUsYh0W0+bSrwo3jg0g9UE3a8iyoMvj1JV1217IE2K0t4v0wSX
   6lUBbLGW2pbc/qpLdob+j8FBGAjbdefEPlx+PwXHYE+4q0Vwprxr+wuBm
   F4OnbMUi2UZmPxnRxuq2A9H5hWfLFyzjeWzU/QaQqpO4jUwg8mU1sKeKT
   z1j+HhZZ84Lc0k4IPSwDlQlO5juqD7IhZm62nkEe2FFYlif+UAA2MPMfh
   nofIiMcCpQMy8T4ZvZgz0JAOYYSshVcfhSoS+GZxld7clUCKe85KMx+NV
   g==;
X-CSE-ConnectionGUID: iL6zt8dFQ5yKgC3BSx+aJg==
X-CSE-MsgGUID: e1P/q9fVSJWIjTGkmwdkrg==
X-IronPort-AV: E=McAfee;i="6700,10204,11350"; a="58362474"
X-IronPort-AV: E=Sophos;i="6.13,301,1732608000"; 
   d="scan'208";a="58362474"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 02:28:39 -0800
X-CSE-ConnectionGUID: ekKmtHWgSg63Jla+4MuHNg==
X-CSE-MsgGUID: zwq9/3W7Rqu/7bQTOGx7zQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,301,1732608000"; 
   d="scan'208";a="119624013"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 02:28:38 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2 2/2] KVM: x86/mmu: Bail out kvm_tdp_map_page() when VM dead
Date: Thu, 20 Feb 2025 18:27:27 +0800
Message-ID: <20250220102728.24546-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250220102436.24373-1-yan.y.zhao@intel.com>
References: <20250220102436.24373-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Bail out of the loop in kvm_tdp_map_page() when a VM is dead. Otherwise,
kvm_tdp_map_page() may get stuck in the kernel loop when there's only one
vCPU in the VM (or if the other vCPUs are not executing ioctls), even if
fatal errors have occurred.

kvm_tdp_map_page() is called by the ioctl KVM_PRE_FAULT_MEMORY or the TDX
ioctl KVM_TDX_INIT_MEM_REGION. It loops in the kernel whenever RET_PF_RETRY
is returned. In the TDP MMU, kvm_tdp_mmu_map() always returns RET_PF_RETRY,
regardless of the specific error code from tdp_mmu_set_spte_atomic(),
tdp_mmu_link_sp(), or tdp_mmu_split_huge_page(). While this is acceptable
in general cases where the only possible error code from these functions is
-EBUSY, TDX introduces an additional error code, -EIO, due to SEAMCALL
errors.

Since this -EIO error is also a fatal error, check for VM dead in the
kvm_tdp_map_page() to avoid unnecessary retries until a signal is pending.

The error -EIO is uncommon and has not been observed in real workloads.
Currently, it is only hypothetically triggered by bypassing the real
SEAMCALL and faking an error in the SEAMCALL wrapper.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
v2:
Use kvm_check_request(KVM_REQ_VM_DEAD) over kvm->vm_dead. (Sean)
---
 arch/x86/kvm/mmu/mmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 378428f4ae63..dd320d4a3b52 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4704,6 +4704,10 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
 	do {
 		if (signal_pending(current))
 			return -EINTR;
+
+		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu))
+			return -EIO;
+
 		cond_resched();
 		r = kvm_mmu_do_page_fault(vcpu, gpa, error_code, true, NULL, level);
 	} while (r == RET_PF_RETRY);
-- 
2.43.2


