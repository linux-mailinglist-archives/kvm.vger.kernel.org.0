Return-Path: <kvm+bounces-65067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A6350C9A137
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 06:25:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 699BE4E2D8C
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 05:25:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B152C2F90CD;
	Tue,  2 Dec 2025 05:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n/wibYBg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71C12F691C;
	Tue,  2 Dec 2025 05:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764653065; cv=none; b=aN3rwbb0oMqWBT81OIaJQipv689aT/XRoTLEn8ioMPMuSjgIuTXYVgaDTpTHDTLnusgA8ihBcNbVK5LWdZcsnxLI4rDeKPOv0xvk890+JV3LIxr1JrcD5UUGLHLa6MR7g56m2lnMy9PfZGtiW4Ez8DCKGRXpWfFABEfhTsvjXxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764653065; c=relaxed/simple;
	bh=DJRuK7HlQ8X+StaFssrTXGF0hy+6VlJGkzm7EvKoKZY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BhNmbyU3VPDJIzxLfKRSj4PdCPOtThl4rZ1AihTnyKM723ff3RNt0blnvmt7Ydtb4s3uMLlUC8c9qv3MzAg98Qfon3vFAnKuGIYYT90IjKi0JfrHOxr1RQqARxde17MvMLXGzwVsCve104DR4BAneS+dvrE8ikmbtxpgu4oFEto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n/wibYBg; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764653064; x=1796189064;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DJRuK7HlQ8X+StaFssrTXGF0hy+6VlJGkzm7EvKoKZY=;
  b=n/wibYBgl+wUxe/OsuwXEa8SAZ1i4MOClOryIIDdl1reY50Htkd5gcOm
   O1UIa8B1bKSCcn/1Qr9EDPhMjG7jL34T8umlh9PFBGVnTY1TZaLXogz6A
   KbuhwZEHfuUNrYlmNE1+nUAARHlPzuehHlQDsU+maUKiXqpvBbxy08mRM
   c3G/AE8oKLd1fNQTe586T38H4h7M8xerlyDZVhTqkZoSwEwtLu1VeC2rE
   xgDIoOqWmkqnp1oeznyivOmZtZ9HDQC/h3cJ6/qCBSK14ZpSuTl/BK6cV
   Jsb8qNlWHmcPgJAr0v3Ue4uBo3118dLFtDgIDXzHGoIalINswltWHOQNu
   A==;
X-CSE-ConnectionGUID: 6rZkvdtYQUG5nwyrzd2JVQ==
X-CSE-MsgGUID: c8W4C9l5T6y+FHVU9lSIBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="76929822"
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="76929822"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 21:24:22 -0800
X-CSE-ConnectionGUID: fH4pcSXmR2uk8pKVB7mfjg==
X-CSE-MsgGUID: DEaRk0ITTd6YebeOhpGroQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="199399254"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by orviesa005.jf.intel.com with ESMTP; 01 Dec 2025 21:24:19 -0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: x86@kernel.org,
	dave.hansen@linux.intel.com,
	kas@kernel.org,
	linux-kernel@vger.kernel.org
Cc: chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	dan.j.williams@intel.com,
	baolu.lu@linux.intel.com,
	yilun.xu@linux.intel.com,
	yilun.xu@intel.com,
	zhenzhong.duan@intel.com,
	kvm@vger.kernel.org,
	adrian.hunter@intel.com
Subject: [PATCH 3/6] x86/virt/tdx: Refactor metadata reading with a clearer for loop
Date: Tue,  2 Dec 2025 13:08:41 +0800
Message-Id: <20251202050844.2520762-4-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251202050844.2520762-1-yilun.xu@linux.intel.com>
References: <20251202050844.2520762-1-yilun.xu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace confusing "ret = ret ?: " code pattern with a normal for loop.

The existing code pattern is compact and friendly to auto-generation.
However, hiding the stop-on-failure logic within the sequential
execution pattern reduces readability. Revive the field mapping table
which lists the field_ids to read and where to store each readout value.
Iterate the table with a normal for loop.

For now this metadata reading process doesn't work well with array typed
fields. Use dedicated method to read these 2 array typed fields. Will
improve in later patches.

Cc: Kai Huang <kai.huang@intel.com>
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
---
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c | 172 ++++++++++----------
 1 file changed, 86 insertions(+), 86 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
index 0dfb3a9995fe..3db87c4accd6 100644
--- a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
+++ b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
@@ -7,8 +7,50 @@
  * Include this file to other C file instead.
  */
 
-static int read_sys_metadata_field(u64 field_id, u64 *data)
+struct field_mapping {
+	u64 field_id;
+	int offset;
+	int size;
+};
+
+#define TD_SYSINFO_MAP(_field_id, _member)				\
+	{ .field_id = _field_id,					\
+	  .offset = offsetof(struct tdx_sys_info, _member),		\
+	  .size = sizeof_field(struct tdx_sys_info, _member) }
+
+/* Map TD_SYSINFO fields into 'struct tdx_sys_info': */
+static const struct field_mapping mappings[] = {
+	TD_SYSINFO_MAP(0x0A00000300000008, features.tdx_features0),
+
+	TD_SYSINFO_MAP(0x9100000100000008, tdmr.max_tdmrs),
+	TD_SYSINFO_MAP(0x9100000100000009, tdmr.max_reserved_per_tdmr),
+	TD_SYSINFO_MAP(0x9100000100000010, tdmr.pamt_4k_entry_size),
+	TD_SYSINFO_MAP(0x9100000100000011, tdmr.pamt_2m_entry_size),
+	TD_SYSINFO_MAP(0x9100000100000012, tdmr.pamt_1g_entry_size),
+
+	TD_SYSINFO_MAP(0x9800000100000000, td_ctrl.tdr_base_size),
+	TD_SYSINFO_MAP(0x9800000100000100, td_ctrl.tdcs_base_size),
+	TD_SYSINFO_MAP(0x9800000100000200, td_ctrl.tdvps_base_size),
+
+	TD_SYSINFO_MAP(0x1900000300000000, td_conf.attributes_fixed0),
+	TD_SYSINFO_MAP(0x1900000300000001, td_conf.attributes_fixed1),
+	TD_SYSINFO_MAP(0x1900000300000002, td_conf.xfam_fixed0),
+	TD_SYSINFO_MAP(0x1900000300000003, td_conf.xfam_fixed1),
+	TD_SYSINFO_MAP(0x9900000100000004, td_conf.num_cpuid_config),
+	TD_SYSINFO_MAP(0x9900000100000008, td_conf.max_vcpus_per_td),
+};
+
+/* Populate the following fields in special manner, separate them out. */
+static const struct field_mapping cpuid_config_leaves =
+	TD_SYSINFO_MAP(0x9900000300000400, td_conf.cpuid_config_leaves[0]);
+
+static const struct field_mapping cpuid_config_values =
+	TD_SYSINFO_MAP(0x9900000300000500, td_conf.cpuid_config_values[0][0]);
+
+static int read_sys_metadata_field(u64 field_id, int offset, int size,
+				   struct tdx_sys_info *ts)
 {
+	void *field = ((void *)ts) + offset;
 	struct tdx_module_args args = {};
 	int ret;
 
@@ -22,97 +64,55 @@ static int read_sys_metadata_field(u64 field_id, u64 *data)
 	if (ret)
 		return ret;
 
-	*data = args.r8;
+	memcpy(field, &args.r8, size);
 
 	return 0;
 }
 
-static int get_tdx_sys_info_features(struct tdx_sys_info_features *sysinfo_features)
-{
-	int ret = 0;
-	u64 val;
-
-	if (!ret && !(ret = read_sys_metadata_field(0x0A00000300000008, &val)))
-		sysinfo_features->tdx_features0 = val;
-
-	return ret;
-}
-
-static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
-{
-	int ret = 0;
-	u64 val;
-
-	if (!ret && !(ret = read_sys_metadata_field(0x9100000100000008, &val)))
-		sysinfo_tdmr->max_tdmrs = val;
-	if (!ret && !(ret = read_sys_metadata_field(0x9100000100000009, &val)))
-		sysinfo_tdmr->max_reserved_per_tdmr = val;
-	if (!ret && !(ret = read_sys_metadata_field(0x9100000100000010, &val)))
-		sysinfo_tdmr->pamt_4k_entry_size = val;
-	if (!ret && !(ret = read_sys_metadata_field(0x9100000100000011, &val)))
-		sysinfo_tdmr->pamt_2m_entry_size = val;
-	if (!ret && !(ret = read_sys_metadata_field(0x9100000100000012, &val)))
-		sysinfo_tdmr->pamt_1g_entry_size = val;
-
-	return ret;
-}
-
-static int get_tdx_sys_info_td_ctrl(struct tdx_sys_info_td_ctrl *sysinfo_td_ctrl)
-{
-	int ret = 0;
-	u64 val;
-
-	if (!ret && !(ret = read_sys_metadata_field(0x9800000100000000, &val)))
-		sysinfo_td_ctrl->tdr_base_size = val;
-	if (!ret && !(ret = read_sys_metadata_field(0x9800000100000100, &val)))
-		sysinfo_td_ctrl->tdcs_base_size = val;
-	if (!ret && !(ret = read_sys_metadata_field(0x9800000100000200, &val)))
-		sysinfo_td_ctrl->tdvps_base_size = val;
-
-	return ret;
-}
-
-static int get_tdx_sys_info_td_conf(struct tdx_sys_info_td_conf *sysinfo_td_conf)
-{
-	int ret = 0;
-	u64 val;
-	int i, j;
-
-	if (!ret && !(ret = read_sys_metadata_field(0x1900000300000000, &val)))
-		sysinfo_td_conf->attributes_fixed0 = val;
-	if (!ret && !(ret = read_sys_metadata_field(0x1900000300000001, &val)))
-		sysinfo_td_conf->attributes_fixed1 = val;
-	if (!ret && !(ret = read_sys_metadata_field(0x1900000300000002, &val)))
-		sysinfo_td_conf->xfam_fixed0 = val;
-	if (!ret && !(ret = read_sys_metadata_field(0x1900000300000003, &val)))
-		sysinfo_td_conf->xfam_fixed1 = val;
-	if (!ret && !(ret = read_sys_metadata_field(0x9900000100000004, &val)))
-		sysinfo_td_conf->num_cpuid_config = val;
-	if (!ret && !(ret = read_sys_metadata_field(0x9900000100000008, &val)))
-		sysinfo_td_conf->max_vcpus_per_td = val;
-	if (sysinfo_td_conf->num_cpuid_config > ARRAY_SIZE(sysinfo_td_conf->cpuid_config_leaves))
-		return -EINVAL;
-	for (i = 0; i < sysinfo_td_conf->num_cpuid_config; i++)
-		if (!ret && !(ret = read_sys_metadata_field(0x9900000300000400 + i, &val)))
-			sysinfo_td_conf->cpuid_config_leaves[i] = val;
-	if (sysinfo_td_conf->num_cpuid_config > ARRAY_SIZE(sysinfo_td_conf->cpuid_config_values))
-		return -EINVAL;
-	for (i = 0; i < sysinfo_td_conf->num_cpuid_config; i++)
-		for (j = 0; j < 2; j++)
-			if (!ret && !(ret = read_sys_metadata_field(0x9900000300000500 + i * 2 + j, &val)))
-				sysinfo_td_conf->cpuid_config_values[i][j] = val;
-
-	return ret;
-}
-
 static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
 {
-	int ret = 0;
+	struct tdx_sys_info_td_conf *td_conf = &sysinfo->td_conf;
+	int ret, i;
+
+	/* Populate 'tdx_sys_info' fields using the mapping structure above: */
+	for (i = 0; i < ARRAY_SIZE(mappings); i++) {
+		ret = read_sys_metadata_field(mappings[i].field_id,
+					      mappings[i].offset,
+					      mappings[i].size,
+					      sysinfo);
+		if (ret)
+			return ret;
+	}
+
+	if (td_conf->num_cpuid_config > ARRAY_SIZE(td_conf->cpuid_config_leaves) ||
+	    td_conf->num_cpuid_config > ARRAY_SIZE(td_conf->cpuid_config_values))
+		return -EINVAL;
 
-	ret = ret ?: get_tdx_sys_info_features(&sysinfo->features);
-	ret = ret ?: get_tdx_sys_info_tdmr(&sysinfo->tdmr);
-	ret = ret ?: get_tdx_sys_info_td_ctrl(&sysinfo->td_ctrl);
-	ret = ret ?: get_tdx_sys_info_td_conf(&sysinfo->td_conf);
+	/*
+	 * Populate 2 special fields, td_conf.cpuid_config_leaves[] and
+	 * td_conf.cpuid_config_values[][]
+	 */
+	for (i = 0; i < td_conf->num_cpuid_config; i++) {
+		ret = read_sys_metadata_field(cpuid_config_leaves.field_id + i,
+					      cpuid_config_leaves.offset +
+						cpuid_config_leaves.size * i,
+					      cpuid_config_leaves.size,
+					      sysinfo);
+		if (ret)
+			return ret;
+	}
+
+	for (i = 0;
+	     i < td_conf->num_cpuid_config * ARRAY_SIZE(td_conf->cpuid_config_values[0]);
+	     i++) {
+		ret = read_sys_metadata_field(cpuid_config_values.field_id + i,
+					      cpuid_config_values.offset +
+						cpuid_config_values.size * i,
+					      cpuid_config_values.size,
+					      sysinfo);
+		if (ret)
+			return ret;
+	}
 
-	return ret;
+	return 0;
 }
-- 
2.25.1


