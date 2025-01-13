Return-Path: <kvm+bounces-35258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38CCDA0AD4B
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 03:11:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FD2B165F61
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 02:11:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A46FD54648;
	Mon, 13 Jan 2025 02:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gfVjuWLP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0A5126BF7;
	Mon, 13 Jan 2025 02:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736734303; cv=none; b=bO1beLSfwEvYqPICyXA0wL7gRUC432LhUo59BSwxJLC9THcoKxxdrp4aKbbtrNe9A0P+YiinoiYGJszZNrrdn61gvIwcOYaOiIdaH2+PCz41loBcprNEKhefpB7uu0SVOxn1T6+RyQcsLbuCTEvve/lcNyM1D3LYb4xpop+JmWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736734303; c=relaxed/simple;
	bh=q8aqLqDc+mTchE3+0c19Ruw75q0tQpImjWf/MDNELjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CAjTodbi95HxS2zjKGRb+FiQuMfyOE3BKmcUPygz04SUEEdZ6tfKV0VmC6ErjG8SBDnnXQkbDvfFaKUsJTArvOqWuFymWnjhgC/4A4JztU/7IpvWXn300c/607OnocLD73N2T+wi5+kn14p1qqLReLbgoaxc5V52E96/ol3L8KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gfVjuWLP; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736734302; x=1768270302;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q8aqLqDc+mTchE3+0c19Ruw75q0tQpImjWf/MDNELjo=;
  b=gfVjuWLPIKtEJi5VjRRaONqb8X0qcWqUyf26mFUw0F17shwGz61sivl8
   MCnb+jEk4xYJ45rZEvaEZHcpI6EH5zY9JX9mnfsXftmGSrIUYRaquqvB9
   FCzGEzyE9SjoyeOsH7711O8vYbWO2k+OfFR+mzOMKQfIPeNnH2HTkf0nP
   xz1BEE09FoIgx6dw2uX5Bv3djxDnX8rSaG3uqFNAetSAIY0idacZflFhB
   yrVe6gpkLX5mIAdNYoR65NopOxtiEAD7EDXNeLJz+g/ftXQe3YamrV797
   po9b/wYdST6ciUBcrgJma+NZI78uV/HIYpXDr7RQV3iW/CfJa7ZeXUfpL
   w==;
X-CSE-ConnectionGUID: h2DsxRggQduXNSvfJy9yGg==
X-CSE-MsgGUID: xDKyn1R0Q5SKn4ikBRUf/g==
X-IronPort-AV: E=McAfee;i="6700,10204,11313"; a="40742672"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="40742672"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2025 18:11:41 -0800
X-CSE-ConnectionGUID: k+Frghk0QHOqnXjYb8pCsw==
X-CSE-MsgGUID: GMLxz/TDSymxtFpU6mKKUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="104843307"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2025 18:11:38 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com
Subject: [PATCH 1/7] KVM: TDX: Return -EBUSY when tdh_mem_page_add() encounters TDX_OPERAND_BUSY
Date: Mon, 13 Jan 2025 10:10:50 +0800
Message-ID: <20250113021050.18828-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250113020925.18789-1-yan.y.zhao@intel.com>
References: <20250113020925.18789-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

tdh_mem_page_add() is called during TD build time. Within the TDX module,
it acquires the exclusive lock on the TDR resource (eliminating the need to
hold locks for TDCS/SEPT tree) and the exclusive lock on the PAMT entry for
the page to be added. The TDX module returns TDX_OPERAND_BUSY if
tdh_mem_page_add() contends with other SEAMCALLs.

SEAMCALL                Lock Type        Resource
-----------------------------------------------------------------------
tdh_mem_page_add        EXCLUSIVE        TDR
                        NO_LOCK          TDCS
                        NO_LOCK          SEPT tree
                        EXCLUSIVE        PAMT entry for the page to add

Given (1)-(4) and the expected behavior from userspace (5), KVM doesn't
expect tdh_mem_page_add() to encounter TDX_OPERAND_BUSY:
(1) tdx_vcpu_create() only allows vCPU creation when the TD state is
    TD_STATE_INITIALIZED, so tdh_mem_page_add(), as invoked in vCPU ioctl,
    does not contend with
    tdh_mng_create()/tdh_mng_addcx()/tdh_mng_key_config()/tdh_mng_init().

(2) tdx_vcpu_ioctl() bails out on TD_STATE_RUNNABLE, so tdh_mem_page_add()
    does not contend with tdh_vp_enter()/tdh_mem_page_aug()/tdh_mem_track()
    and TDCALLs.

(3) By holding slots_lock and the filemap invalidate lock,
    tdh_mem_page_add() does not contend with tdh_mr_finalize(),
    tdh_mem_page_remove()/tdh_mem_range_block()/
    tdh_phymem_page_wbinvd_hkid() or another tdh_mem_page_add(),
    tdh_mem_sept_add()/tdh_mr_extend().

(4) By holding reference to kvm, tdh_mem_page_add() does not contend with
    tdh_mng_vpflushdone()/tdh_phymem_cache_wb()/tdh_mng_key_freeid()/
    tdh_phymem_page_wbinvd_tdr()/tdh_phymem_page_reclaim().

(5) A well-behaved userspace invokes ioctl KVM_TDX_INIT_MEM_REGION on one
    vCPU after initializing all vCPUs and does not invoke ioctls on the
    other vCPUs before the KVM_TDX_INIT_MEM_REGION completes. Thus,
    tdh_mem_page_add() does not contend with
    tdh_vp_create()/tdh_vp_addcx()/tdh_vp_init*()/tdh_vp_rd()/tdh_vp_wr()/
    tdh_mng_rd()/tdh_vp_flush() on the other vCPUs.

However, if the userspace breaks (5), tdh_mem_page_add() could encounter
TDX_OPERAND_BUSY when trying to acquire the exclusive lock on the TDR
resource in the TDX module. In this case, simply return -EBUSY.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
tdx_vcpu_pre_run() will check TD_STATE_RUNNABLE for (2).
https://lore.kernel.org/kvm/3576c721-3ef2-40bd-8764-b50912df93a2@intel.com/
---
 arch/x86/kvm/vmx/tdx.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index d0dc3200fa37..1cf3ef0faff7 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3024,13 +3024,11 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	}
 
 	ret = 0;
-	do {
-		err = tdh_mem_page_add(kvm_tdx->tdr_pa, gpa, pfn_to_hpa(pfn),
-				       pfn_to_hpa(page_to_pfn(page)),
-				       &entry, &level_state);
-	} while (err == TDX_ERROR_SEPT_BUSY);
+	err = tdh_mem_page_add(kvm_tdx->tdr_pa, gpa, pfn_to_hpa(pfn),
+			       pfn_to_hpa(page_to_pfn(page)),
+			       &entry, &level_state);
 	if (err) {
-		ret = -EIO;
+		ret = unlikely(err & TDX_OPERAND_BUSY) ? -EBUSY : -EIO;
 		goto out;
 	}
 
-- 
2.43.2


