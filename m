Return-Path: <kvm+bounces-21754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 436289335BE
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 05:43:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB8D0281B9D
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 03:43:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17FF5111A8;
	Wed, 17 Jul 2024 03:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="File3HTL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83CEFBEA;
	Wed, 17 Jul 2024 03:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721187674; cv=none; b=CfU6DIvWqj6ToRjSFSgEr/bu5orQNZ8C/9ZM7/t6ao6+9Cp+hPO6C+ikM/S78QH8hfs+v9oIsHxja+prE0Eg6opGwZkQfDzNFeFDBELbq6ZV6xV+C6vtRjgGPYRVQn3fSsdwFSqVkbQCZWlmpTvDefkOWB4OimCGf4Jflg0nc88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721187674; c=relaxed/simple;
	bh=6ijwVBE78YFDivz/d8+zBvfY9v8iI1faK1uvaOKYN2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJqrsLSC+Hjhx50URx5zc08B3CcBkI+tMdjw297HOxb5xRAmKha4kVrL4JK7ZheePdOeSmGGw5Q6v5uy933zWakbs31QZjWJQ9Lsi14VRFWFX4wq0UzBMxf2hHi0hSh0iqyLWSKVacAXU5bl/UCqGM9D1T/H1/Gc+6O+cRugfb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=File3HTL; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721187673; x=1752723673;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6ijwVBE78YFDivz/d8+zBvfY9v8iI1faK1uvaOKYN2E=;
  b=File3HTLmVAxePV2Pmi1vpDI+Qc+mMDrwFanviQ2mRV7YYJIT1osTKQ7
   X4IuRCMID2tna9eHaXGMMTq1rS1i27zJzbaXbOoUzs82bBl3AyQJ9br3c
   3hxJY5YfBvdCeYPkMlvWynDWEtgHBqJAFPsmX+p6Jzjtjj8OqTt048HB/
   OxxIQOik8RrhquNPwiGf5w6Zp10arjj6iT1T+GHxb1S3WANIvqZMSVWzQ
   1ZQjuzeaJTXuv2dMw/spXAYWWh5he+ILD8+Gog0EmE+0T+eRukQQMHXiF
   yILgewIFPiTYhwBUk71n45lkXHdxZBl2SqJ/NJcoFdIIHEzGRgVefkFXo
   Q==;
X-CSE-ConnectionGUID: +Pd1sMtnRJyfTN3HOfRZsQ==
X-CSE-MsgGUID: MSc5eIzdTMygivhwA+SYRw==
X-IronPort-AV: E=McAfee;i="6700,10204,11135"; a="18512471"
X-IronPort-AV: E=Sophos;i="6.09,213,1716274800"; 
   d="scan'208";a="18512471"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 20:41:12 -0700
X-CSE-ConnectionGUID: Z/cDHmnAQ+GJwtomkO9Hsg==
X-CSE-MsgGUID: hNOLH89WS+mJ5djd5euveg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,213,1716274800"; 
   d="scan'208";a="54566761"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.184])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 20:41:00 -0700
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	dan.j.williams@intel.com
Cc: x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	chao.gao@intel.com,
	binbin.wu@linux.intel.com,
	kai.huang@intel.com
Subject: [PATCH v2 08/10] x86/virt/tdx: Print TDX module basic information
Date: Wed, 17 Jul 2024 15:40:15 +1200
Message-ID: <1e71406eec47ae7f6a47f8be3beab18c766ff5a7.1721186590.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1721186590.git.kai.huang@intel.com>
References: <cover.1721186590.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently the kernel doesn't print any information regarding the TDX
module itself, e.g. module version.  In practice such information is
useful, especially to the developers.

For instance, there are a couple of use cases for dumping module basic
information:

1) When something goes wrong around using TDX, the information like TDX
   module version, supported features etc could be helpful [1][2].

2) For Linux, when the user wants to update the TDX module, one needs to
   replace the old module in a specific location in the EFI partition
   with the new one so that after reboot the BIOS can load it.  However,
   after kernel boots, currently the user has no way to verify it is
   indeed the new module that gets loaded and initialized (e.g., error
   could happen when replacing the old module).  With the module version
   dumped the user can verify this easily.

So dump the basic TDX module information:

 - TDX module version, and the build date.
 - TDX module type: Debug or Production.
 - TDX_FEATURES0: Supported TDX features.

And dump the information right after reading global metadata, so that
this information is printed no matter whether module initialization
fails or not.

The actual dmesg will look like:

  virt/tdx: Initializing TDX module: 1.5.00.00.0481 (build_date 20230323, Production module), TDX_FEATURES0 0xfbf

Link: https://lore.kernel.org/lkml/e2d844ad-182a-4fc0-a06a-d609c9cbef74@suse.com/T/#m352829aedf6680d4628c7e40dc40b332eda93355 [1]
Link: https://lore.kernel.org/lkml/e2d844ad-182a-4fc0-a06a-d609c9cbef74@suse.com/T/#m351ebcbc006d2e5bc3e7650206a087cb2708d451 [2]
Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v1 -> v2 (Nikolay):
 - Change the format to dump TDX basic info.
 - Slightly improve changelog.

---
 arch/x86/virt/vmx/tdx/tdx.c | 64 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h | 33 ++++++++++++++++++-
 2 files changed, 96 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 3253cdfa5207..5ac0c411f4f7 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -319,6 +319,58 @@ static int stbuf_read_sysmd_multi(const struct field_mapping *fields,
 	return 0;
 }
 
+#define TD_SYSINFO_MAP_MOD_INFO(_field_id, _member)	\
+	TD_SYSINFO_MAP(_field_id, struct tdx_sysinfo_module_info, _member)
+
+static int get_tdx_module_info(struct tdx_sysinfo_module_info *modinfo)
+{
+	static const struct field_mapping fields[] = {
+		TD_SYSINFO_MAP_MOD_INFO(SYS_ATTRIBUTES, sys_attributes),
+		TD_SYSINFO_MAP_MOD_INFO(TDX_FEATURES0,  tdx_features0),
+	};
+
+	return stbuf_read_sysmd_multi(fields, ARRAY_SIZE(fields), modinfo);
+}
+
+#define TD_SYSINFO_MAP_MOD_VERSION(_field_id, _member)	\
+	TD_SYSINFO_MAP(_field_id, struct tdx_sysinfo_module_version, _member)
+
+static int get_tdx_module_version(struct tdx_sysinfo_module_version *modver)
+{
+	static const struct field_mapping fields[] = {
+		TD_SYSINFO_MAP_MOD_VERSION(MAJOR_VERSION,    major),
+		TD_SYSINFO_MAP_MOD_VERSION(MINOR_VERSION,    minor),
+		TD_SYSINFO_MAP_MOD_VERSION(UPDATE_VERSION,   update),
+		TD_SYSINFO_MAP_MOD_VERSION(INTERNAL_VERSION, internal),
+		TD_SYSINFO_MAP_MOD_VERSION(BUILD_NUM,	     build_num),
+		TD_SYSINFO_MAP_MOD_VERSION(BUILD_DATE,	     build_date),
+	};
+
+	return stbuf_read_sysmd_multi(fields, ARRAY_SIZE(fields), modver);
+}
+
+static void print_basic_sysinfo(struct tdx_sysinfo *sysinfo)
+{
+	struct tdx_sysinfo_module_version *modver = &sysinfo->module_version;
+	struct tdx_sysinfo_module_info *modinfo = &sysinfo->module_info;
+	bool debug = modinfo->sys_attributes & TDX_SYS_ATTR_DEBUG_MODULE;
+
+	/*
+	 * TDX module version encoding:
+	 *
+	 *   <major>.<minor>.<update>.<internal>.<build_num>
+	 *
+	 * When printed as text, <major> and <minor> are 1-digit,
+	 * <update> and <internal> are 2-digits and <build_num>
+	 * is 4-digits.
+	 */
+	pr_info("Initializing TDX module: %u.%u.%02u.%02u.%04u (build_date %u, %s module), TDX_FEATURES0 0x%llx\n",
+			modver->major, modver->minor, modver->update,
+			modver->internal, modver->build_num,
+			modver->build_date, debug ? "Debug" : "Production",
+			modinfo->tdx_features0);
+}
+
 #define TD_SYSINFO_MAP_TDMR_INFO(_field_id, _member)	\
 	TD_SYSINFO_MAP(_field_id, struct tdx_sysinfo_tdmr_info, _member)
 
@@ -339,6 +391,16 @@ static int get_tdx_tdmr_sysinfo(struct tdx_sysinfo_tdmr_info *tdmr_sysinfo)
 
 static int get_tdx_sysinfo(struct tdx_sysinfo *sysinfo)
 {
+	int ret;
+
+	ret = get_tdx_module_info(&sysinfo->module_info);
+	if (ret)
+		return ret;
+
+	ret = get_tdx_module_version(&sysinfo->module_version);
+	if (ret)
+		return ret;
+
 	return get_tdx_tdmr_sysinfo(&sysinfo->tdmr_info);
 }
 
@@ -1121,6 +1183,8 @@ static int init_tdx_module(void)
 	if (ret)
 		return ret;
 
+	print_basic_sysinfo(&sysinfo);
+
 	/*
 	 * To keep things simple, assume that all TDX-protected memory
 	 * will come from the page allocator.  Make sure all pages in the
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index b5eb7c35f1dc..861ddf2c2e88 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -31,6 +31,15 @@
  *
  * See the "global_metadata.json" in the "TDX 1.5 ABI definitions".
  */
+#define MD_FIELD_ID_SYS_ATTRIBUTES		0x0A00000200000000ULL
+#define MD_FIELD_ID_TDX_FEATURES0		0x0A00000300000008ULL
+#define MD_FIELD_ID_BUILD_DATE			0x8800000200000001ULL
+#define MD_FIELD_ID_BUILD_NUM			0x8800000100000002ULL
+#define MD_FIELD_ID_MINOR_VERSION		0x0800000100000003ULL
+#define MD_FIELD_ID_MAJOR_VERSION		0x0800000100000004ULL
+#define MD_FIELD_ID_UPDATE_VERSION		0x0800000100000005ULL
+#define MD_FIELD_ID_INTERNAL_VERSION		0x0800000100000006ULL
+
 #define MD_FIELD_ID_MAX_TDMRS			0x9100000100000008ULL
 #define MD_FIELD_ID_MAX_RESERVED_PER_TDMR	0x9100000100000009ULL
 #define MD_FIELD_ID_PAMT_4K_ENTRY_SIZE		0x9100000100000010ULL
@@ -124,8 +133,28 @@ struct tdmr_info_list {
  *
  * Note not all metadata fields in each class are defined, only those
  * used by the kernel are.
+ *
+ * Also note the "bit definitions" are architectural.
  */
 
+/* Class "TDX Module Info" */
+struct tdx_sysinfo_module_info {
+	u32 sys_attributes;
+	u64 tdx_features0;
+};
+
+#define TDX_SYS_ATTR_DEBUG_MODULE	0x1
+
+/* Class "TDX Module Version" */
+struct tdx_sysinfo_module_version {
+	u16 major;
+	u16 minor;
+	u16 update;
+	u16 internal;
+	u16 build_num;
+	u32 build_date;
+};
+
 /* Class "TDMR Info" */
 struct tdx_sysinfo_tdmr_info {
 	u16 max_tdmrs;
@@ -134,7 +163,9 @@ struct tdx_sysinfo_tdmr_info {
 };
 
 struct tdx_sysinfo {
-	struct tdx_sysinfo_tdmr_info tdmr_info;
+	struct tdx_sysinfo_module_info		module_info;
+	struct tdx_sysinfo_module_version	module_version;
+	struct tdx_sysinfo_tdmr_info		tdmr_info;
 };
 
 #endif
-- 
2.45.2


