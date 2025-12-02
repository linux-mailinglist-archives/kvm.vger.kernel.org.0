Return-Path: <kvm+bounces-65070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EEDDC9A15B
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 06:27:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C0CC34E368D
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 05:25:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94A772FC00F;
	Tue,  2 Dec 2025 05:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DDQ62Vmb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9D52FBDE4;
	Tue,  2 Dec 2025 05:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764653073; cv=none; b=VnSQ3GbCaPYoYZLBhMVwoAJ2a9C8ehjDBVeXcPzrQKz62rfAslndKbSjgLb50Ra6Ki2nIp0sSIi4I8O5OaEU5DZKyX5Un8JdK0RHmizrcRCIReDHLsBUzdTxxh8a2PTDkkuvcSUez2GMYtKrG+XLgl4OvKgQumIBuB8Dz4BhXPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764653073; c=relaxed/simple;
	bh=TijaFDTOis9Jp85ZCxKbRaB2Ebx2EjzBgE3r6OPiuKI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=K7CGoseZb+U2PSg4ebE4TcRRuuvRSTZiiQZWkpEfQkaavUXQFkjm2mU1t6LOhE/10Qt/UvAe192jhcR9bDGxG0uQQ3uYitLKGq0IynQu2P/MZ4FbowyLa99t+ZUZfvBkycYksloCFjEf5zM8+j6sIMU+PVIaBsrLJoOdJp1PRNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DDQ62Vmb; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764653072; x=1796189072;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TijaFDTOis9Jp85ZCxKbRaB2Ebx2EjzBgE3r6OPiuKI=;
  b=DDQ62VmbUhsJbvbFr7yk+nFG76Q+UDlVWJr0A6+zvB5nv+CGGlypjzP4
   dviRf/htLJ1SgTM0nIW6/mAgQUK25fNp+9W4t2de/iaoLx8vtk+CTus6w
   wNLJI5Y2j2MdN4J3Uv/S8ScLhS4byJN0zco8YABzB3JFJNJogEmyde7C5
   0TKE9XJ9PRyfmcyLZqBhu+gMyLls3mu7MBbs5qcm7SHMNC4ccp7aOajn0
   66uEscl1Z3iwMP1GTV4PU0FGgaDnqnLhcnxGtSO3nT7ePdSX7UiDnjThn
   1vPA5xH1BVDmyfqz6rsaS/AC/qszbwR7ZSE1Eny9LOGtmOLPQyyz5z2Fr
   g==;
X-CSE-ConnectionGUID: idDtSLO7QqqHRSO6D0zqiQ==
X-CSE-MsgGUID: 0QY0KTTgTum2/6xUemx4jw==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="76929828"
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="76929828"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 21:24:32 -0800
X-CSE-ConnectionGUID: a8OJgQOSSKed138DWq6q6g==
X-CSE-MsgGUID: tXViw6INR6+meokhl42wnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="199399272"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by orviesa005.jf.intel.com with ESMTP; 01 Dec 2025 21:24:29 -0800
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
Subject: [PATCH 6/6] x86/virt/tdx: Skip unsupported metadata by querying tdx_feature0
Date: Tue,  2 Dec 2025 13:08:44 +0800
Message-Id: <20251202050844.2520762-7-yilun.xu@linux.intel.com>
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

TDX Module will add new metadata fields for new features over time.
These new metadata fields are optional and only valid when the
corresponding bits in tdx_feature0 are set. Add new helpers to specify
the required feature bits for each field_id, to avoid reading
unsupported metadata fields and in turn failing the entire metadata
reading process.

Add definitions for the new metadata fields "TDX Module Extensions" as
the example.

Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
---
 arch/x86/include/asm/tdx.h                  |  1 +
 arch/x86/include/asm/tdx_global_metadata.h  |  6 +++++
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c | 25 ++++++++++++++++-----
 3 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 96565f6b69b9..886d65ed58c8 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -151,6 +151,7 @@ const char *tdx_dump_mce_info(struct mce *m);
 
 /* Bit definitions of TDX_FEATURES0 metadata field */
 #define TDX_FEATURES0_NO_RBP_MOD	BIT_ULL(18)
+#define TDX_FEATURES0_EXT		BIT_ULL(39)
 
 const struct tdx_sys_info *tdx_get_sysinfo(void);
 
diff --git a/arch/x86/include/asm/tdx_global_metadata.h b/arch/x86/include/asm/tdx_global_metadata.h
index b44f1df013b2..feb9097c9881 100644
--- a/arch/x86/include/asm/tdx_global_metadata.h
+++ b/arch/x86/include/asm/tdx_global_metadata.h
@@ -34,11 +34,17 @@ struct tdx_sys_info_td_conf {
 	u64 cpuid_config_values[128][2];
 };
 
+struct tdx_sys_info_ext {
+	u16 memory_pool_required_pages;
+	u8 ext_required;
+};
+
 struct tdx_sys_info {
 	struct tdx_sys_info_features features;
 	struct tdx_sys_info_tdmr tdmr;
 	struct tdx_sys_info_td_ctrl td_ctrl;
 	struct tdx_sys_info_td_conf td_conf;
+	struct tdx_sys_info_ext ext;
 };
 
 #endif
diff --git a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
index c366bace454e..6835af65a5f8 100644
--- a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
+++ b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
@@ -12,6 +12,7 @@ struct field_mapping {
 	int offset;
 	int size;
 	int count;
+	u64 feature0_mask;
 };
 
 /*
@@ -35,24 +36,28 @@ struct field_mapping {
 #define TD_SYSINFO_CHECK_SIZE(_field_id, _size)		\
 	__builtin_choose_expr(MD_FIELD_SIZE(_field_id) == (_size), _size, (void)0)
 
-#define _TD_SYSINFO_MAP(_field_id, _member, _count)			\
+#define _TD_SYSINFO_MAP(_field_id, _member, _count, _feature0_mask)	\
 	{ .field_id = _field_id,					\
 	  .offset = offsetof(struct tdx_sys_info, _member),		\
 	  .size = TD_SYSINFO_CHECK_SIZE(_field_id,			\
 					sizeof_field(struct tdx_sys_info, _member)), \
-	  .count = _count }
+	  .count = _count,						\
+	  .feature0_mask = _feature0_mask }
 
 #define TD_SYSINFO_MAP(_field_id, _member)				\
-	_TD_SYSINFO_MAP(_field_id, _member, 1)
+	_TD_SYSINFO_MAP(_field_id, _member, 1, 0)
 
 #define TD_SYSINFO_MAP_ARR(_field_id, _arr)				\
 	_TD_SYSINFO_MAP(_field_id, _arr[0],				\
-			ARRAY_SIZE(((struct tdx_sys_info *)0)->_arr))
+			ARRAY_SIZE(((struct tdx_sys_info *)0)->_arr), 0)
 
 #define TD_SYSINFO_MAP_2DARR(_field_id, _arr)				\
 	_TD_SYSINFO_MAP(_field_id, _arr[0][0],				\
 			ARRAY_SIZE(((struct tdx_sys_info *)0)->_arr) *	\
-			ARRAY_SIZE(((struct tdx_sys_info *)0)->_arr[0]))
+			ARRAY_SIZE(((struct tdx_sys_info *)0)->_arr[0]), 0)
+
+#define TD_SYSINFO_MAP_FEATURE0(_field_id, _member, _feature0_mask)	\
+	_TD_SYSINFO_MAP(_field_id, _member, 1, _feature0_mask)
 
 /* Map TD_SYSINFO fields into 'struct tdx_sys_info': */
 static const struct field_mapping mappings[] = {
@@ -76,6 +81,12 @@ static const struct field_mapping mappings[] = {
 	TD_SYSINFO_MAP(0x9900000100000008, td_conf.max_vcpus_per_td),
 	TD_SYSINFO_MAP_ARR(0x9900000300000400, td_conf.cpuid_config_leaves),
 	TD_SYSINFO_MAP_2DARR(0x9900000300000500, td_conf.cpuid_config_values),
+
+	TD_SYSINFO_MAP_FEATURE0(0x3100000100000000,
+				ext.memory_pool_required_pages,
+				TDX_FEATURES0_EXT),
+	TD_SYSINFO_MAP_FEATURE0(0x3100000000000001, ext.ext_required,
+				TDX_FEATURES0_EXT),
 };
 
 static int read_sys_metadata_field(const struct field_mapping *base,
@@ -83,6 +94,10 @@ static int read_sys_metadata_field(const struct field_mapping *base,
 {
 	int i, ret;
 
+	if (base->feature0_mask &&
+	    !(ts->features.tdx_features0 & base->feature0_mask))
+		return 0;
+
 	for (i = 0; i < base->count; i++) {
 		void *field = ((void *)ts) + base->offset + base->size * i;
 		u64 field_id = base->field_id + i;
-- 
2.25.1


