Return-Path: <kvm+bounces-67118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DD564CF7F82
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 12:07:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1F38C31408D3
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 11:02:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE869326D45;
	Tue,  6 Jan 2026 10:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bKayXe+X"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9119432571F;
	Tue,  6 Jan 2026 10:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767695008; cv=none; b=DQpZ7nsAznTEe/ds8vwgGbRkGc3rxZwNXlPVURhw4iwn40FD8Qp+IsEw469iyADgb/Gj+dBEJ5l3FpGfnwt0AoIE90awITuGK3nZ0Dj7tzwoIbQErcOg5st8FRVTAFhRyUCGesSnbdKh3rFuBzAnZo9gPJiHBTdX3uxAaRKEj2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767695008; c=relaxed/simple;
	bh=AsoC2HYHqOgGjBb063lZ0sV1MtNnqE9jiBqgR85GKho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPzVFc9GppFwVTJ87Qkb6mYtH3ZmEUI9l3toTxUoAtxfVExcXd13HMCVOsRAhFja2SKyzHa1ap7fjGoS++Scabznw7cih6YeT/OnDcBb+tIkV7MdokHvdQnwGzsIOY3lGFs+zInafB0MkUEAGvmdc0oybtcCcxie63ToxOMXiTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bKayXe+X; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767695006; x=1799231006;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AsoC2HYHqOgGjBb063lZ0sV1MtNnqE9jiBqgR85GKho=;
  b=bKayXe+XM4o+Hakl5jbDXTYAESPqO5EmjQzgIPCG0xfNFf0I1TUOuzP4
   0i7yO4qE1NTYfglkKhPtZS4XZh5+krsA+qmGsFa6aDNz9lLqKsdFcy1iS
   Oo+S9Nvm/86kbQSUsDPY00vd35tx0/CF2v4lvrlBfxemR2F7n/hXp/+pM
   YWbSXZxcEXkpsaI6V54mMPuL2f2f4254tMN+lYDOEs3YAkCVArjhpeAvV
   Gwjh4JB+YXYZmIabpidKdKYkwNG1KtLgGvjO0F3u7wMzrEa6vaHoAv6k8
   bnnCQHvic86zZ9VKWeSN6BtpyqE4w+HglTjYAb8oH84Wq5Q5x45q8AnWX
   g==;
X-CSE-ConnectionGUID: ggixy/U3Qq2gPL0FzIS5Bg==
X-CSE-MsgGUID: V1SMhHdJTkCxc3o/lZjEbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="72689584"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="72689584"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:23:26 -0800
X-CSE-ConnectionGUID: MHiVDWaFQASAzOZ61sRtjw==
X-CSE-MsgGUID: K0q06bQJTji3abxnd2Q8wg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="201847492"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:23:20 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@intel.com,
	kas@kernel.org,
	tabba@google.com,
	ackerleytng@google.com,
	michael.roth@amd.com,
	david@kernel.org,
	vannapurve@google.com,
	sagis@google.com,
	vbabka@suse.cz,
	thomas.lendacky@amd.com,
	nik.borisov@suse.com,
	pgonda@google.com,
	fan.du@intel.com,
	jun.miao@intel.com,
	francescolavra.fl@gmail.com,
	jgross@suse.com,
	ira.weiny@intel.com,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	kai.huang@intel.com,
	binbin.wu@linux.intel.com,
	chao.p.peng@intel.com,
	chao.gao@intel.com,
	yan.y.zhao@intel.com
Subject: [PATCH v3 10/24] KVM: x86/tdp_mmu: Alloc external_spt page for mirror page table splitting
Date: Tue,  6 Jan 2026 18:21:22 +0800
Message-ID: <20260106102122.25091-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20260106101646.24809-1-yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Enhance tdp_mmu_alloc_sp_for_split() to allocate a page table page for the
external page table for splitting the mirror page table.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
v3:
- Removed unnecessary declaration of tdp_mmu_alloc_sp_for_split(). (Kai)
- Fixed a typo in the patch log. (Kai)

RFC v2:
- NO change.

RFC v1:
- Rebased and simplified the code.
---
 arch/x86/kvm/mmu/tdp_mmu.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 9b45ffb8585f..074209d91ec3 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1535,7 +1535,7 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
 	return spte_set;
 }
 
-static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(void)
+static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(bool mirror)
 {
 	struct kvm_mmu_page *sp;
 
@@ -1549,6 +1549,15 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(void)
 		return NULL;
 	}
 
+	if (mirror) {
+		sp->external_spt = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+		if (!sp->external_spt) {
+			free_page((unsigned long)sp->spt);
+			kmem_cache_free(mmu_page_header_cache, sp);
+			return NULL;
+		}
+	}
+
 	return sp;
 }
 
@@ -1628,7 +1637,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 			else
 				write_unlock(&kvm->mmu_lock);
 
-			sp = tdp_mmu_alloc_sp_for_split();
+			sp = tdp_mmu_alloc_sp_for_split(is_mirror_sp(root));
 
 			if (shared)
 				read_lock(&kvm->mmu_lock);
-- 
2.43.2


