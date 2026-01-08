Return-Path: <kvm+bounces-67310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3104FD00785
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 01:33:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3E6B13044B9B
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 00:31:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C8041D514E;
	Thu,  8 Jan 2026 00:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="If9oxnzQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2B31A23B1;
	Thu,  8 Jan 2026 00:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767832310; cv=none; b=Iuf1mBR1WwkE1bbDoZutTJaNQzQB1bJpIBIQYI9vvzAn3JJnGgzDXaCLvhMbaV3vFtgHogoWkl45xduJ0HHE3TVZzu9CfkPQ7K8fOcPTZIAdOY46ZveXiMKYVeehS5FTY+G0kk2WvWVYfFWn6izjxBoURSthfLkoJxSkDlIJQa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767832310; c=relaxed/simple;
	bh=VeocBz7ZUL8kmL7Qm8PxmjzRiBIsK9PBvcRzKqbnhdM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WkJ2UNWE6HDb4rNbRh5Wn3Y6Wdl7RjDuaBPD6RpBGHc2XV2UyQR73lbs2IWGeNzHdZxxS/aqG7ORp+MAk78LgVXnK4tGMS39bDqQE+eyWy0Sl64eUDMaZdtT8BBsnxKd2nxR9vFn012zxzI44QEBa5n1vIr3SaB1RNJI24kO/SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=If9oxnzQ; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767832308; x=1799368308;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=VeocBz7ZUL8kmL7Qm8PxmjzRiBIsK9PBvcRzKqbnhdM=;
  b=If9oxnzQu1I9GRH004UK9VyiVg3OOhicUln/1SRp766J48nWBMBsmjFt
   Ci+i+y9gv9sKC1NkGea0chTL1ePpc91cgR8zSSMHAmLzpMPkIpDzdvfRb
   whVYIkRw92RrkGlIye7/4LdF1lDFOHA1qE4mOdo7vUpBEAywSmpnlVXNo
   1Q+NsehFkRv6pp0pdyZO5t66ApPw2NA3mZF/10+VoEIXx6wo4b/QdpYEu
   8FcE6VDbBrUbRAdtGGlW7hfJ8oplC2Qmb8mHS4pP3Ci5loUn0GkiSo6Z8
   A7WhrYjb3G+syR7QlZ2W6mVwzeNDCvFtsPQN+R2Lb3zkA/E4dRd0i6mQH
   w==;
X-CSE-ConnectionGUID: BB6iYG2sSX2QEB/Wvqbieg==
X-CSE-MsgGUID: e8Hu/uBhRXmTKykS3jTTxw==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="86625973"
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="86625973"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 16:31:47 -0800
X-CSE-ConnectionGUID: yyRUOx33SYuoIYXNOPyrMg==
X-CSE-MsgGUID: KgWjrT2vTnqeI/7WxBkn4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="207908360"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.124.222.195])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 16:31:46 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Wed, 07 Jan 2026 17:31:28 -0700
Subject: [PATCH 1/2] x86/virt/tdx: Retrieve TDX module version
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260107-tdx_print_module_version-v1-1-822baa56762d@intel.com>
References: <20260107-tdx_print_module_version-v1-0-822baa56762d@intel.com>
In-Reply-To: <20260107-tdx_print_module_version-v1-0-822baa56762d@intel.com>
To: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
 kvm@vger.kernel.org
Cc: x86@kernel.org, Chao Gao <chao.gao@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, Kai Huang <kai.huang@intel.com>, 
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 "H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.15-dev-e44bb
X-Developer-Signature: v=1; a=openpgp-sha256; l=3737;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=Z8auUD+eVQzZXFrwlXC8cyshYChK6jPdiigFSm5VbK0=;
 b=kA0DAAoWD86uVEnbi3YByyZiAGle+vHIjbi3dduDTdOXz79cv6ILaUCazpS703tVFQ8PNNtnl
 Ih1BAAWCgAdFiEE/bzxAcYet28MUWBBD86uVEnbi3YFAmle+vEACgkQD86uVEnbi3a5twEA1lo0
 Bpow1Z205C7qvzfWE4dN6gWPoiRe2oQ829kadW4A/RW0iKRx/2y2gM+O4DHiJ9jAZ3FQZKWr7RN
 eGGHRVeQO
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

From: Chao Gao <chao.gao@intel.com>

Each TDX module has several bits of metadata about which specific TDX
module it is. The primary bit of info is the version, which has an x.y.z
format, where x represents the major version, y the minor version, and z
the update version. Knowing the running TDX Module version is valuable
for bug reporting and debugging. Note that the module does expose other
pieces of version-related metadata, such as build number and date. Those
aren't retrieved for now, that can be added if needed in the future.

Retrieve the TDX Module version using the existing metadata reading
interface. Later changes will expose this information. The metadata
reading interfaces have existed for quite some time, so this will work
with older versions of the TDX module as well - i.e. this isn't a new
interface.

As a side note, the global metadata reading code was originally set up
to be auto-generated from a JSON definition [1]. However, later [2] this
was found to be unsustainable, and the autogeneration approach was
dropped in favor of just manually adding fields as needed (e.g. as in
this patch).

Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Link: https://lore.kernel.org/kvm/CABgObfYXUxqQV_FoxKjC8U3t5DnyM45nz5DpTxYZv2x_uFK_Kw@mail.gmail.com/ # [1]
Link: https://lore.kernel.org/all/1e7bcbad-eb26-44b7-97ca-88ab53467212@intel.com/ # [2]
---
 arch/x86/include/asm/tdx_global_metadata.h  |  7 +++++++
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c | 16 ++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/arch/x86/include/asm/tdx_global_metadata.h b/arch/x86/include/asm/tdx_global_metadata.h
index 060a2ad744bff..40689c8dc67eb 100644
--- a/arch/x86/include/asm/tdx_global_metadata.h
+++ b/arch/x86/include/asm/tdx_global_metadata.h
@@ -5,6 +5,12 @@
 
 #include <linux/types.h>
 
+struct tdx_sys_info_version {
+	u16 minor_version;
+	u16 major_version;
+	u16 update_version;
+};
+
 struct tdx_sys_info_features {
 	u64 tdx_features0;
 };
@@ -35,6 +41,7 @@ struct tdx_sys_info_td_conf {
 };
 
 struct tdx_sys_info {
+	struct tdx_sys_info_version version;
 	struct tdx_sys_info_features features;
 	struct tdx_sys_info_tdmr tdmr;
 	struct tdx_sys_info_td_ctrl td_ctrl;
diff --git a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
index 13ad2663488b1..0454124803f36 100644
--- a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
+++ b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
@@ -7,6 +7,21 @@
  * Include this file to other C file instead.
  */
 
+static int get_tdx_sys_info_version(struct tdx_sys_info_version *sysinfo_version)
+{
+	int ret = 0;
+	u64 val;
+
+	if (!ret && !(ret = read_sys_metadata_field(0x0800000100000003, &val)))
+		sysinfo_version->minor_version = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x0800000100000004, &val)))
+		sysinfo_version->major_version = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x0800000100000005, &val)))
+		sysinfo_version->update_version = val;
+
+	return ret;
+}
+
 static int get_tdx_sys_info_features(struct tdx_sys_info_features *sysinfo_features)
 {
 	int ret = 0;
@@ -89,6 +104,7 @@ static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
 {
 	int ret = 0;
 
+	ret = ret ?: get_tdx_sys_info_version(&sysinfo->version);
 	ret = ret ?: get_tdx_sys_info_features(&sysinfo->features);
 	ret = ret ?: get_tdx_sys_info_tdmr(&sysinfo->tdmr);
 	ret = ret ?: get_tdx_sys_info_td_ctrl(&sysinfo->td_ctrl);

-- 
2.52.0


