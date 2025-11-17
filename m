Return-Path: <kvm+bounces-63313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id C7AA2C621D9
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 03:40:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 143D736081D
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 02:40:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D450026F471;
	Mon, 17 Nov 2025 02:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O2tUZ9XP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEA826F29C;
	Mon, 17 Nov 2025 02:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763347124; cv=none; b=F0zpSdji/oxAvTEUkQ4H9Ysaz5KDrXLPTOcCoEWydJiXbIgwR9QDmNzrtdmBEd/R3Cmyxtex47YFNIxtaZJXjj1MLu5N3PAEtihHeI21ApLcF0wMrFv8gEMK8tFOxESK5msaA8d9+Jgbad8NwtPHHKrQsCyot3qlLeHZ68Omwlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763347124; c=relaxed/simple;
	bh=D6+r74jIPGap2uXcP9zcW1TNnT8dgkFvQ4v5fobURo4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a710mokBY4ydqGXZxlvWuLyoxjAWz7jU91LurxDTU9wAZapic0VMZstBE8sO0wKcvuyer6DeAELTWLsbpym/+YlOxLzXG4sWttdES+9xFHucDW1PvONaXT5RJe5cfAFYJAlgYP1wD0jH80l5SwKU+Byr0ltnC7Oj8brJXGj45Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O2tUZ9XP; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763347123; x=1794883123;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=D6+r74jIPGap2uXcP9zcW1TNnT8dgkFvQ4v5fobURo4=;
  b=O2tUZ9XPj3UMgt5QkAaQ+gx2hff8RB/yxpu4FccsyteEDEbEvT3SZ5s3
   vM9AWRIb4AeFF1h/bUXCFYIeRfo2GGzef91JSNkIOcmkRMdChAbuli3sz
   s2xctP05g+j531VtOzKm0XnOVFck5zan2YXEx2Sz7PHMcu8Tfwfgd+WvR
   TwEgZREtF04nhWiw9j7WBfrkU1SLv2S2dPTyB2rtB0YZdE2hy1DbJVFZz
   8/cCiLGIlf2tpzhoAJwWWhPcVNb+Kxn+yItRTmeHBBu8z6o1OG1T3kJlk
   XH9xpU2Fm5DMr1jPD9QSeIFFsA4iBiATu41HjebhjFMly0tUuTyzLeAGj
   A==;
X-CSE-ConnectionGUID: /4hRrAoVQ7SqaJqMt1RHbQ==
X-CSE-MsgGUID: r2LmHFHgRrWVPmVvCGksoA==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="82729551"
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="82729551"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 18:38:43 -0800
X-CSE-ConnectionGUID: RuE5gwsFSaKm95PZzhciQQ==
X-CSE-MsgGUID: LT9fXAOkQ8yaAhMOUTWWEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="227658302"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by orviesa001.jf.intel.com with ESMTP; 16 Nov 2025 18:38:39 -0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: linux-coco@lists.linux.dev,
	linux-pci@vger.kernel.org
Cc: chao.gao@intel.com,
	dave.jiang@intel.com,
	baolu.lu@linux.intel.com,
	yilun.xu@linux.intel.com,
	yilun.xu@intel.com,
	zhenzhong.duan@intel.com,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@linux.intel.com,
	dan.j.williams@intel.com,
	kas@kernel.org,
	x86@kernel.org
Subject: [PATCH v1 13/26] x86/virt/tdx: Read TDX Connect global metadata for TDX Connect
Date: Mon, 17 Nov 2025 10:22:57 +0800
Message-Id: <20251117022311.2443900-14-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add several global metadata fields for TDX Connect. These metadata field
specify the number of metadata pages needed for IOMMU/IDE/SPDM setup.

Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/tdx_global_metadata.h  |  8 ++++++++
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c | 18 ++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/arch/x86/include/asm/tdx_global_metadata.h b/arch/x86/include/asm/tdx_global_metadata.h
index 2aa741190b93..e7948bca671a 100644
--- a/arch/x86/include/asm/tdx_global_metadata.h
+++ b/arch/x86/include/asm/tdx_global_metadata.h
@@ -39,12 +39,20 @@ struct tdx_sys_info_ext {
 	u8 ext_required;
 };
 
+struct tdx_sys_info_connect {
+	u16 ide_mt_page_count;
+	u16 spdm_mt_page_count;
+	u16 iommu_mt_page_count;
+	u16 spdm_max_dev_info_pages;
+};
+
 struct tdx_sys_info {
 	struct tdx_sys_info_features features;
 	struct tdx_sys_info_tdmr tdmr;
 	struct tdx_sys_info_td_ctrl td_ctrl;
 	struct tdx_sys_info_td_conf td_conf;
 	struct tdx_sys_info_ext ext;
+	struct tdx_sys_info_connect connect;
 };
 
 #endif
diff --git a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
index c3b2e2748b3e..b9029c3f9b32 100644
--- a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
+++ b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
@@ -98,6 +98,23 @@ static __init int get_tdx_sys_info_ext(struct tdx_sys_info_ext *sysinfo_ext)
 	return ret;
 }
 
+static __init int get_tdx_sys_info_connect(struct tdx_sys_info_connect *sysinfo_connect)
+{
+	int ret = 0;
+	u64 val;
+
+	if (!ret && !(ret = read_sys_metadata_field(0x3000000100000001, &val)))
+		sysinfo_connect->ide_mt_page_count = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x3000000100000002, &val)))
+		sysinfo_connect->spdm_mt_page_count = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x3000000100000003, &val)))
+		sysinfo_connect->iommu_mt_page_count = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x3000000100000007, &val)))
+		sysinfo_connect->spdm_max_dev_info_pages = val;
+
+	return ret;
+}
+
 static __init int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
 {
 	int ret = 0;
@@ -107,6 +124,7 @@ static __init int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
 	ret = ret ?: get_tdx_sys_info_td_ctrl(&sysinfo->td_ctrl);
 	ret = ret ?: get_tdx_sys_info_td_conf(&sysinfo->td_conf);
 	ret = ret ?: get_tdx_sys_info_ext(&sysinfo->ext);
+	ret = ret ?: get_tdx_sys_info_connect(&sysinfo->connect);
 
 	return ret;
 }
-- 
2.25.1


