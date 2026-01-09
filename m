Return-Path: <kvm+bounces-67636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C7AFD0C07A
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 20:17:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A42513098459
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 19:14:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 083D63093C8;
	Fri,  9 Jan 2026 19:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WnR0qIlR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7050B2E5B09;
	Fri,  9 Jan 2026 19:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767986089; cv=none; b=n7JYWex8D6Xph3DglnCw4N4eBOWuwJ5/HzDimKK3BSicpmaOkQh97yU/iuEnpVOq9sWTmBUlobqpF94+FPD5XQttiwzLdus5kvX4CSP1DQvwE3O3SZGijVo5iDofPtrr+9ybjevmtg8pao4McOEidH3t0EW0o0ieIaBjXoTOr3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767986089; c=relaxed/simple;
	bh=mlUB6CpgC+NdTjv2wzLOOW7NeBH5rNDUGy/JFjUofP4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jiBRobn5Y+hihQj4dZf6DC3IoEGi3yAvWENwK428oKwXFwcGunCBJMGKxCphNgr/OjnOYgInHvtug01NeCfHnNaFHebfrjYHIVRs3D3u0/RKexKP42dVfzgJUMd3WVb8BBZ/24uoWxUbJvahvXL57e6Y2LZ19JMOepUCghFpZUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WnR0qIlR; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767986087; x=1799522087;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=mlUB6CpgC+NdTjv2wzLOOW7NeBH5rNDUGy/JFjUofP4=;
  b=WnR0qIlROE2bZlTxs5GLR7Ktym7y7NHRoct4KjVwG1+qeAlqUOumI60c
   iG4F0nskf5gw+7MuENTLx0Qf9TlL4kRIRdDuVvtvKLgE+OSBBgF3jjlIl
   aWzwjG3T5FMhpwyDBpKNJxam+kcGhsNTqv99anfBET6sm3Th8aEf/MK8P
   ZKn/5z2iYzDZhBVjEPpBL/u4UMCiJbmns8VvplBjoye9YLqn9vv49m3SY
   2p/RO5VzDulGKzl4iGK94It0Ka6R8n3RwyraEzYYYko7EPI2lpwIyhduz
   xPCOlq/fEa/cFd7TVpiVCFPTi/oasDNG/Pjd+GoVGG29dc8gexvMRg6P1
   A==;
X-CSE-ConnectionGUID: YKC96xc2Rkm0xNhEaSoYXg==
X-CSE-MsgGUID: T1v81hvcTrOj6wPUTZBQBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11666"; a="80824255"
X-IronPort-AV: E=Sophos;i="6.21,214,1763452800"; 
   d="scan'208";a="80824255"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 11:14:46 -0800
X-CSE-ConnectionGUID: UD05R2SnQNOzXDCchW89sQ==
X-CSE-MsgGUID: k43n+N7IRKSsaegwYiPLMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,214,1763452800"; 
   d="scan'208";a="203456690"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.124.223.127])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 11:14:45 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Fri, 09 Jan 2026 12:14:30 -0700
Subject: [PATCH v2 1/2] x86/virt/tdx: Retrieve TDX module version
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260109-tdx_print_module_version-v2-1-e10e4ca5b450@intel.com>
References: <20260109-tdx_print_module_version-v2-0-e10e4ca5b450@intel.com>
In-Reply-To: <20260109-tdx_print_module_version-v2-0-e10e4ca5b450@intel.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3840;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=Z+0V8kpF3yoteyWrw6vR62/QKpGxleXBJP3WnKnHjxs=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDJmJwUscWayM339klGS5Y3zeWuuEzeHc8mSZSYyL3xmms
 W79HqnWUcrCIMbFICumyPJ3z0fGY3Lb83kCExxh5rAygQxh4OIUgInYfWT4p353raP0w5mRor5y
 px7GM853/KMcxVNmtL7tgtYdJ92bsxn+KQdUH+LVitkemRWWkbjiiYHT3RdvbQ78uF67woktXeg
 EMwA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

From: Chao Gao <chao.gao@intel.com>

Each TDX module has several bits of metadata about which specific TDX
module it is. The primary bit of info is the version, which has an x.y.z
format. These represent the major version, minor version, and update
version respectively. Knowing the running TDX Module version is valuable
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
Link: https://lore.kernel.org/kvm/CABgObfYXUxqQV_FoxKjC8U3t5DnyM45nz5DpTxYZv2x_uFK_Kw@mail.gmail.com/ # [1]
Link: https://lore.kernel.org/all/1e7bcbad-eb26-44b7-97ca-88ab53467212@intel.com/ # [2]
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
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


