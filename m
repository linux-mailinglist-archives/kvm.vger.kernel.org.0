Return-Path: <kvm+bounces-34267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B42409F9D9E
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2024 02:08:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2CE407A3FC2
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2024 01:07:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 516561BF37;
	Sat, 21 Dec 2024 01:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SwRBBwSe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0B525949D;
	Sat, 21 Dec 2024 01:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734743262; cv=none; b=doYfLR0qeXSyqYUpx0U2TJsrPaqxPOrnFR/YeWUpwMOrD5VhGQzvtXbMKqVl3WfRoQ0EOKiWwb7RgQqoaI6+LDIzlV9QWQ42fs603g/VbAQ718Wd7nRKRswAz6UgiuBl5QADKVs1sE+NuUU7YHO75ESMiJjnK3yvVqIHMObhf/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734743262; c=relaxed/simple;
	bh=OoAFMs8/w0JtEYYsXPcdE1fQ86+tcPR53L7qovIijFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGjoKKOESr9naSKvUfBnJkP8UyYtOih6f5TGelOvDeqj7UbfD9UtbUGFKfFt3L3lZTRaDycl6lyhoQeGadKMRNy79/Pvb4PCzDayLcX1bu05WL46EbIv1fI6UPP+inuXwVpKUKIWH4dE6zwGQdxT/won1V8Fw7WV1CThKTxHH9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SwRBBwSe; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734743260; x=1766279260;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OoAFMs8/w0JtEYYsXPcdE1fQ86+tcPR53L7qovIijFk=;
  b=SwRBBwSe3SURg/rNVmqC8kGwIF95PkDf+DJKgReASDV4j5LxT7kGRVDf
   Yc4zFSm5ysHgWJFalARhpU11sv6+nphpEVAjkwLyguCdpFWx3zj96br5w
   +M6VUy9pPU5tRx+ggpbjDDHwijbqeDAkrmESk+io+YgINyy4cp7+KhCWk
   j6okVBJJNFPnbF+JMzwKQ0NjjqGPeXb3pr/6PKztCqfVhMAQ47ruTSihv
   s6i589A9xBjGB0MVxdahGpCdBrfDjseS55RLQeqxgCllow549mCHV5jEa
   JVVR3xFfegY1K2cE61klamAWyr5mfKaiOQd/9xAT6XE00WDUGhWAhBKvY
   Q==;
X-CSE-ConnectionGUID: tNNkUyklQlu7ZympQPxSQw==
X-CSE-MsgGUID: aUqR4jLoSZiylxz3gtvkjA==
X-IronPort-AV: E=McAfee;i="6700,10204,11292"; a="45793812"
X-IronPort-AV: E=Sophos;i="6.12,252,1728975600"; 
   d="scan'208";a="45793812"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2024 17:07:39 -0800
X-CSE-ConnectionGUID: +AsPGPpyRPSX9Xs7YMJZrA==
X-CSE-MsgGUID: s/TjREc5SFmaxihH6MuLdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,252,1728975600"; 
   d="scan'208";a="98863972"
Received: from server.sh.intel.com ([10.239.53.23])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2024 17:07:35 -0800
From: Kai Huang <kai.huang@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	dave.hansen@intel.com,
	yan.y.zhao@intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tony.lindgren@intel.com,
	xiaoyao.li@intel.com,
	reinette.chatre@intel.com
Subject: [PATCH v2.1 03/25] x86/virt/tdx: Read essential global metadata for KVM
Date: Sat, 21 Dec 2024 01:07:04 +0000
Message-ID: <20241221010704.14155-1-kai.huang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241030190039.77971-4-rick.p.edgecombe@intel.com>
References: <20241030190039.77971-4-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM needs two classes of global metadata to create and run TDX guests:

 - "TD Control Structures"
 - "TD Configurability"

The first class contains the sizes of TDX guest per-VM and per-vCPU
control structures.  KVM will need to use them to allocate enough space
for those control structures.

The second class contains info which reports things like which features
are configurable to TDX guests.  KVM will need to use them to properly
configure TDX guests.

Read them for KVM TDX to use.

Basically, the code change is auto-generated by adding below to the
script in [1]:

    "td_ctrl": [
        "TDR_BASE_SIZE",
        "TDCS_BASE_SIZE",
        "TDVPS_BASE_SIZE",
    ],
    "td_conf": [
        "ATTRIBUTES_FIXED0",
        "ATTRIBUTES_FIXED1",
        "XFAM_FIXED0",
        "XFAM_FIXED1",
        "NUM_CPUID_CONFIG",
        "MAX_VCPUS_PER_TD",
        "CPUID_CONFIG_LEAVES",
        "CPUID_CONFIG_VALUES",
    ],

.. and re-running the script:

  #python tdx_global_metadata.py global_metadata.json \
  	tdx_global_metadata.h tdx_global_metadata.c

.. but unfortunately with some tweaks:

The "Intel TDX Module v1.5.09 ABI Definitions" JSON files[2], which
describe the TDX module ABI to the kernel, were expected to maintain
backward compatibility.  However, it turns out there are plans to change
the JSON per module release.  Specifically, the maximum number of
CPUID_CONFIGs, i.e., CPUID_CONFIG_{LEAVES|VALUES} is one of the fields
expected to change.

This is obviously problematic for the kernel, and needs to be addressed
by the TDX Module team.  Negotiations on clarifying ABI boundary in the
spec for future models are ongoing.  In the meantime, the TDX module
team has agreed to not increase this specific field beyond 128 entries
without an opt in.

So for now just tweak the JSON to change "Num Fields" from 32 to 128 and
generate a fixed-size (128) array for CPUID_CONFIG_{LEAVES|VALUES}.

Also, due to all those ABI breakages (and module bugs), be paranoid by
generating additional checks to make sure NUM_CPUID_CONFIG will never
exceed the array size of CPUID_CONFIG_{LEAVES|VALUES} to protect the
kernel from the module breakages.  With those checks, detecting a
breakage will just result in module initialization failure.

Link: https://lore.kernel.org/762a50133300710771337398284567b299a86f67.camel@intel.com/ [1]
Link: https://cdrdv2.intel.com/v1/dl/getContent/795381 [2]
Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v2 -> v2.1
 - Bump array size for CPUID_CONFIGs to 128
 - Add paranoid checks to protect against incorrect NUM_CPUID_CONFIG.
 - Update changelog accordingly.

 Note: this is based on kvm-coco-queue which has v7 of TDX host metadata
 series which has patches to read TDX module version and CMRs.  It will
 have conflicts to resolve when rebasing to the v9 patches currently
 queued in tip/x86/tdx.

uAPI breakout v2:
 - New patch

---
 arch/x86/include/asm/tdx_global_metadata.h  | 19 ++++++++
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c | 50 +++++++++++++++++++++
 2 files changed, 69 insertions(+)

diff --git a/arch/x86/include/asm/tdx_global_metadata.h b/arch/x86/include/asm/tdx_global_metadata.h
index fde370b855f1..cfef9e5e4d93 100644
--- a/arch/x86/include/asm/tdx_global_metadata.h
+++ b/arch/x86/include/asm/tdx_global_metadata.h
@@ -32,11 +32,30 @@ struct tdx_sys_info_cmr {
 	u64 cmr_size[32];
 };
 
+struct tdx_sys_info_td_ctrl {
+	u16 tdr_base_size;
+	u16 tdcs_base_size;
+	u16 tdvps_base_size;
+};
+
+struct tdx_sys_info_td_conf {
+	u64 attributes_fixed0;
+	u64 attributes_fixed1;
+	u64 xfam_fixed0;
+	u64 xfam_fixed1;
+	u16 num_cpuid_config;
+	u16 max_vcpus_per_td;
+	u64 cpuid_config_leaves[128];
+	u64 cpuid_config_values[128][2];
+};
+
 struct tdx_sys_info {
 	struct tdx_sys_info_version version;
 	struct tdx_sys_info_features features;
 	struct tdx_sys_info_tdmr tdmr;
 	struct tdx_sys_info_cmr cmr;
+	struct tdx_sys_info_td_ctrl td_ctrl;
+	struct tdx_sys_info_td_conf td_conf;
 };
 
 #endif
diff --git a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
index 2fe57e084453..d96dbfb43574 100644
--- a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
+++ b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
@@ -76,6 +76,54 @@ static int get_tdx_sys_info_cmr(struct tdx_sys_info_cmr *sysinfo_cmr)
 	return ret;
 }
 
+static int get_tdx_sys_info_td_ctrl(struct tdx_sys_info_td_ctrl *sysinfo_td_ctrl)
+{
+	int ret = 0;
+	u64 val;
+
+	if (!ret && !(ret = read_sys_metadata_field(0x9800000100000000, &val)))
+		sysinfo_td_ctrl->tdr_base_size = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x9800000100000100, &val)))
+		sysinfo_td_ctrl->tdcs_base_size = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x9800000100000200, &val)))
+		sysinfo_td_ctrl->tdvps_base_size = val;
+
+	return ret;
+}
+
+static int get_tdx_sys_info_td_conf(struct tdx_sys_info_td_conf *sysinfo_td_conf)
+{
+	int ret = 0;
+	u64 val;
+	int i, j;
+
+	if (!ret && !(ret = read_sys_metadata_field(0x1900000300000000, &val)))
+		sysinfo_td_conf->attributes_fixed0 = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x1900000300000001, &val)))
+		sysinfo_td_conf->attributes_fixed1 = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x1900000300000002, &val)))
+		sysinfo_td_conf->xfam_fixed0 = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x1900000300000003, &val)))
+		sysinfo_td_conf->xfam_fixed1 = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x9900000100000004, &val)))
+		sysinfo_td_conf->num_cpuid_config = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x9900000100000008, &val)))
+		sysinfo_td_conf->max_vcpus_per_td = val;
+	if (sysinfo_td_conf->num_cpuid_config > ARRAY_SIZE(sysinfo_td_conf->cpuid_config_leaves))
+		return -EINVAL;
+	for (i = 0; i < sysinfo_td_conf->num_cpuid_config; i++)
+		if (!ret && !(ret = read_sys_metadata_field(0x9900000300000400 + i, &val)))
+			sysinfo_td_conf->cpuid_config_leaves[i] = val;
+	if (sysinfo_td_conf->num_cpuid_config > ARRAY_SIZE(sysinfo_td_conf->cpuid_config_values))
+		return -EINVAL;
+	for (i = 0; i < sysinfo_td_conf->num_cpuid_config; i++)
+		for (j = 0; j < 2; j++)
+			if (!ret && !(ret = read_sys_metadata_field(0x9900000300000500 + i * 2 + j, &val)))
+				sysinfo_td_conf->cpuid_config_values[i][j] = val;
+
+	return ret;
+}
+
 static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
 {
 	int ret = 0;
@@ -84,6 +132,8 @@ static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
 	ret = ret ?: get_tdx_sys_info_features(&sysinfo->features);
 	ret = ret ?: get_tdx_sys_info_tdmr(&sysinfo->tdmr);
 	ret = ret ?: get_tdx_sys_info_cmr(&sysinfo->cmr);
+	ret = ret ?: get_tdx_sys_info_td_ctrl(&sysinfo->td_ctrl);
+	ret = ret ?: get_tdx_sys_info_td_conf(&sysinfo->td_conf);
 
 	return ret;
 }
-- 
2.43.0


