Return-Path: <kvm+bounces-48935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AE5DAD4764
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 02:17:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF19C3A81CE
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 00:16:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61C1A1401B;
	Wed, 11 Jun 2025 00:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dByUjmHo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0177DEBE;
	Wed, 11 Jun 2025 00:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749601010; cv=none; b=aQ5CoipfZWbhHFoxtWDqvs+RaS1H5jbvgHQu6GUExEveMFrptYTfgu9MtRwpNWnIaAzQ/9rtKPuJR7vgaNBAeolwnMk4KrL5m9HRw5UHLVy1DiAP4abQThWB0ss3EbvZ56ZRWF6C8LgdwotVU/HJjzwidOGBczvsdAUh/GhONfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749601010; c=relaxed/simple;
	bh=S40pI5W06xk884q2HvExFYi8n68iIjm/9A9TA1JDBk0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JHTeFkpt/a2yY2IgAuimPYXghvWqkkQw9uAHjaP+CDdyDHCy655gHtmw+01DOSuqNS8zuAooR1Q8dxRGr+2rhiGdifqhwgE2W+v99gWc7lJH1vADZFv1IqM14oOLIP2I2H4Wqn1/ue8J6Xl+JAND7O4jdX05BBTn8lZ1/fnp2HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dByUjmHo; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749601009; x=1781137009;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=S40pI5W06xk884q2HvExFYi8n68iIjm/9A9TA1JDBk0=;
  b=dByUjmHogDiQp0Q/3gFOh2kCGuuX5hP1PInYiRP2HhvwR8pZqw5TxHMg
   76gwTVr3Hiqt31L63UKU+KyHAEOHcA0NqIovr6KsXjtcB8Gy72Wde5/hw
   vljD7USx6S/jzahq/Pfm7ILnFxD1az/xmyLTBwKzkDDHhhKupmBoLMFoQ
   6ebPKgTVo1s9/zPolZVfJRboqECuWMe+oiEbDyYdwNk1tnWyVwl32/Ht1
   UBFDg3WIrkpRzvYOWkkOGHNBmipIQv+YnpvIVGUHFXNq+lTThzQ3j3MER
   rreqqsU49U4821zBdRDeDCE+saQT1z/IFSdnu2hPvsUT/7vG6RSFEETms
   Q==;
X-CSE-ConnectionGUID: OLX097SLSnORjO9sYMJvcQ==
X-CSE-MsgGUID: PZjoSyywT/qWH0a8Y5CHJQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="51644542"
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="51644542"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 17:16:48 -0700
X-CSE-ConnectionGUID: 0s0PpqsrRIeorsymB8zcIw==
X-CSE-MsgGUID: P+ZmXgcDRYm0AIQrnw8Jng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="151808058"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa003.jf.intel.com with ESMTP; 10 Jun 2025 17:16:45 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	rick.p.edgecombe@intel.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yan.y.zhao@intel.com,
	reinette.chatre@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	isaku.yamahata@intel.com,
	Binbin Wu <binbin.wu@linux.intel.com>,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com
Subject: [PATCH] KVM: x86/mmu: Embed direct bits into gpa for KVM_PRE_FAULT_MEMORY
Date: Tue, 10 Jun 2025 20:10:18 -0400
Message-ID: <20250611001018.2179964-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Paolo Bonzini <pbonzini@redhat.com>

Bug[*] reported for TDX case when enabling KVM_PRE_FAULT_MEMORY in QEMU.

It turns out that @gpa passed to kvm_mmu_do_page_fault() doesn't have
shared bit set when the memory attribute of it is shared, and it leads
to wrong root in tdp_mmu_get_root_for_fault().

Fix it by embedding the direct bits in the gpa that is passed to
kvm_tdp_map_page(), when the memory of the gpa is not private.

[*] https://lore.kernel.org/qemu-devel/4a757796-11c2-47f1-ae0d-335626e818fd@intel.com/

Reported-by: Xiaoyao Li <xiaoyao.li@intel.com>
Closes: https://lore.kernel.org/qemu-devel/4a757796-11c2-47f1-ae0d-335626e818fd@intel.com/
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
we have selftests enhancement for TDX case of KVM_PRE_FAULT_MEMORY, but
the plan is to post them on top of the TDX selftests [1] when they get
upstream.

[1] https://lore.kernel.org/all/20250414214801.2693294-1-sagis@google.com/
---
 arch/x86/kvm/mmu/mmu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index cbc84c6abc2e..a4040578b537 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4896,6 +4896,7 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 {
 	u64 error_code = PFERR_GUEST_FINAL_MASK;
 	u8 level = PG_LEVEL_4K;
+	u64 direct_bits;
 	u64 end;
 	int r;
 
@@ -4910,15 +4911,18 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 	if (r)
 		return r;
 
+	direct_bits = 0;
 	if (kvm_arch_has_private_mem(vcpu->kvm) &&
 	    kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(range->gpa)))
 		error_code |= PFERR_PRIVATE_ACCESS;
+	else
+		direct_bits = gfn_to_gpa(kvm_gfn_direct_bits(vcpu->kvm));
 
 	/*
 	 * Shadow paging uses GVA for kvm page fault, so restrict to
 	 * two-dimensional paging.
 	 */
-	r = kvm_tdp_map_page(vcpu, range->gpa, error_code, &level);
+	r = kvm_tdp_map_page(vcpu, range->gpa | direct_bits, error_code, &level);
 	if (r < 0)
 		return r;
 

base-commit: 19272b37aa4f83ca52bdf9c16d5d81bdd1354494
-- 
2.43.0


