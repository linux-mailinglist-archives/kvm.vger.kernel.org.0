Return-Path: <kvm+bounces-65069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 35D9FC9A14C
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 06:26:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5318A4E3B69
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 05:25:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46C552FB09C;
	Tue,  2 Dec 2025 05:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dQS45lml"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6E32FB094;
	Tue,  2 Dec 2025 05:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764653070; cv=none; b=VpgSB0tYC02OXupyULFzGCI189WpyQRfc1af0s46FvknVitJqCUrbP+vVQ21BK0lWXfQW+R7jTYDncWwfKDe+1fVqCSUHnL/1nwg/UrJnxnpBVl4VAbcS9M5Nxy0BGY9UOj43c+f0CKw+lscJ9Y5oIgvoq9g3NOcMAgZ2U8kVCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764653070; c=relaxed/simple;
	bh=uT7f6bQ68J4MYfOUU6yggYBwHANh+P7eRG5P+4Oj4ZI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Kr9oLNrmBnt30b05VVcnkDmP3K9Rlww39p/LCMhXBst9kKAtp/u0gl1J1vhe7x9KEO6BBr7sDAr9QGl1bBbbs4hVvlWOThRNd0WKoSlAsCglDkPvEruaKM268+ksUUhamQRJyR86ftBCrtkDchnDZW0Qvw3HbAicTCtIfY9SvV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dQS45lml; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764653069; x=1796189069;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uT7f6bQ68J4MYfOUU6yggYBwHANh+P7eRG5P+4Oj4ZI=;
  b=dQS45lmlBfiXO2cgFl8TAjy4wQTBcw8Pp0szsGIQKeFmXNQtWP42nxwc
   3B7IbQkfPzvftea2IyWuCH7u5Q617JL5952sZBzDWYAk3g9R2vdEmaXMf
   JBrWe/1I3RJl4WpKFmtoKh/xdtgFPToeTfbS4vgF1yGy0WluK3hj5j8y+
   5psdA4u3j6Rjob1l8qor4R30/JIqqu5TXcDHsEGgnHJLBDXbxKv0YqxOd
   u1IKG0m7VGflZkNErAz0RwXPcX7reLe5te/ElaZCrKfOBCDRM2rwU8xqj
   dHKKQzw1RSWYD6V4vve/Viujud3ollK7Kee+watxDIMw0h2hmI85aYQsa
   A==;
X-CSE-ConnectionGUID: ZTRaWWEFSImu/GeHMEGzKw==
X-CSE-MsgGUID: MVkD5dsRTFyi3SdiycwV+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="76929826"
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="76929826"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 21:24:29 -0800
X-CSE-ConnectionGUID: MG4+JMCeT7aVlHSmORsirQ==
X-CSE-MsgGUID: oFmNkvwdQ7WpDxmcRbI58g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="199399268"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by orviesa005.jf.intel.com with ESMTP; 01 Dec 2025 21:24:26 -0800
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
Subject: [PATCH 5/6] x86/virt/tdx: Add generic support for reading array-typed metadata
Date: Tue,  2 Dec 2025 13:08:43 +0800
Message-Id: <20251202050844.2520762-6-yilun.xu@linux.intel.com>
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

Rework metadata field reading helper to read array-typed metadata fields
in a unified way. Eliminate the need to read cpuid_config_leaves/values
in special manner.

By adding the array index to the base field_id, the array elements can
be read out. But the actual valid array index boundary should be
retrieved from other metadata fields. Otherwise TDX Module returns error
on an invalid field_id and the whole metadata reading process fails.
That leads to the special handling of these fields.

TDG.SYS.RD provides an output parameter (RDX) for next readable
field_id. Use this return value to validate the next array index and
detect actual array boundary. This makes the array-typed metadata fields
reading self-contained. Remove all special handling for them.

Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
---
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c | 99 +++++++++------------
 1 file changed, 44 insertions(+), 55 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
index 836d97166a7a..c366bace454e 100644
--- a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
+++ b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
@@ -11,6 +11,7 @@ struct field_mapping {
 	u64 field_id;
 	int offset;
 	int size;
+	int count;
 };
 
 /*
@@ -34,11 +35,24 @@ struct field_mapping {
 #define TD_SYSINFO_CHECK_SIZE(_field_id, _size)		\
 	__builtin_choose_expr(MD_FIELD_SIZE(_field_id) == (_size), _size, (void)0)
 
-#define TD_SYSINFO_MAP(_field_id, _member)				\
+#define _TD_SYSINFO_MAP(_field_id, _member, _count)			\
 	{ .field_id = _field_id,					\
 	  .offset = offsetof(struct tdx_sys_info, _member),		\
 	  .size = TD_SYSINFO_CHECK_SIZE(_field_id,			\
-					sizeof_field(struct tdx_sys_info, _member)) }
+					sizeof_field(struct tdx_sys_info, _member)), \
+	  .count = _count }
+
+#define TD_SYSINFO_MAP(_field_id, _member)				\
+	_TD_SYSINFO_MAP(_field_id, _member, 1)
+
+#define TD_SYSINFO_MAP_ARR(_field_id, _arr)				\
+	_TD_SYSINFO_MAP(_field_id, _arr[0],				\
+			ARRAY_SIZE(((struct tdx_sys_info *)0)->_arr))
+
+#define TD_SYSINFO_MAP_2DARR(_field_id, _arr)				\
+	_TD_SYSINFO_MAP(_field_id, _arr[0][0],				\
+			ARRAY_SIZE(((struct tdx_sys_info *)0)->_arr) *	\
+			ARRAY_SIZE(((struct tdx_sys_info *)0)->_arr[0]))
 
 /* Map TD_SYSINFO fields into 'struct tdx_sys_info': */
 static const struct field_mapping mappings[] = {
@@ -60,33 +74,37 @@ static const struct field_mapping mappings[] = {
 	TD_SYSINFO_MAP(0x1900000300000003, td_conf.xfam_fixed1),
 	TD_SYSINFO_MAP(0x9900000100000004, td_conf.num_cpuid_config),
 	TD_SYSINFO_MAP(0x9900000100000008, td_conf.max_vcpus_per_td),
+	TD_SYSINFO_MAP_ARR(0x9900000300000400, td_conf.cpuid_config_leaves),
+	TD_SYSINFO_MAP_2DARR(0x9900000300000500, td_conf.cpuid_config_values),
 };
 
-/* Populate the following fields in special manner, separate them out. */
-static const struct field_mapping cpuid_config_leaves =
-	TD_SYSINFO_MAP(0x9900000300000400, td_conf.cpuid_config_leaves[0]);
-
-static const struct field_mapping cpuid_config_values =
-	TD_SYSINFO_MAP(0x9900000300000500, td_conf.cpuid_config_values[0][0]);
-
-static int read_sys_metadata_field(u64 field_id, int offset, int size,
+static int read_sys_metadata_field(const struct field_mapping *base,
 				   struct tdx_sys_info *ts)
 {
-	void *field = ((void *)ts) + offset;
-	struct tdx_module_args args = {};
-	int ret;
-
-	/*
-	 * TDH.SYS.RD -- reads one global metadata field
-	 *  - RDX (in): the field to read
-	 *  - R8 (out): the field data
-	 */
-	args.rdx = field_id;
-	ret = seamcall_prerr_ret(TDH_SYS_RD, &args);
-	if (ret)
-		return ret;
-
-	memcpy(field, &args.r8, size);
+	int i, ret;
+
+	for (i = 0; i < base->count; i++) {
+		void *field = ((void *)ts) + base->offset + base->size * i;
+		u64 field_id = base->field_id + i;
+		struct tdx_module_args args = {};
+
+		/*
+		 * TDH.SYS.RD -- reads one global metadata field
+		 *  - RDX (in): the field to read
+		 *  - RDX (out) : the next valid field ID
+		 *  - R8 (out): the field data
+		 */
+		args.rdx = field_id;
+		ret = seamcall_prerr_ret(TDH_SYS_RD, &args);
+		if (ret)
+			return ret;
+
+		memcpy(field, &args.r8, base->size);
+
+		/* field_id + 1 is invalid, the metadata array ends */
+		if (args.rdx != field_id + 1)
+			break;
+	}
 
 	return 0;
 }
@@ -98,10 +116,7 @@ static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
 
 	/* Populate 'tdx_sys_info' fields using the mapping structure above: */
 	for (i = 0; i < ARRAY_SIZE(mappings); i++) {
-		ret = read_sys_metadata_field(mappings[i].field_id,
-					      mappings[i].offset,
-					      mappings[i].size,
-					      sysinfo);
+		ret = read_sys_metadata_field(&mappings[i], sysinfo);
 		if (ret)
 			return ret;
 	}
@@ -110,31 +125,5 @@ static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
 	    td_conf->num_cpuid_config > ARRAY_SIZE(td_conf->cpuid_config_values))
 		return -EINVAL;
 
-	/*
-	 * Populate 2 special fields, td_conf.cpuid_config_leaves[] and
-	 * td_conf.cpuid_config_values[][]
-	 */
-	for (i = 0; i < td_conf->num_cpuid_config; i++) {
-		ret = read_sys_metadata_field(cpuid_config_leaves.field_id + i,
-					      cpuid_config_leaves.offset +
-						cpuid_config_leaves.size * i,
-					      cpuid_config_leaves.size,
-					      sysinfo);
-		if (ret)
-			return ret;
-	}
-
-	for (i = 0;
-	     i < td_conf->num_cpuid_config * ARRAY_SIZE(td_conf->cpuid_config_values[0]);
-	     i++) {
-		ret = read_sys_metadata_field(cpuid_config_values.field_id + i,
-					      cpuid_config_values.offset +
-						cpuid_config_values.size * i,
-					      cpuid_config_values.size,
-					      sysinfo);
-		if (ret)
-			return ret;
-	}
-
 	return 0;
 }
-- 
2.25.1


