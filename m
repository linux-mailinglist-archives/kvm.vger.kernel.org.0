Return-Path: <kvm+bounces-65499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A4F67CACD76
	for <lists+kvm@lfdr.de>; Mon, 08 Dec 2025 11:18:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C2A01303D9D1
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 10:18:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4E5172618;
	Mon,  8 Dec 2025 10:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vslo0nXg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBC3231A55;
	Mon,  8 Dec 2025 10:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765189123; cv=none; b=iaLr7AlyV9zsFdfboa7dv0/L4NWDXCho+U4RvmbgVHY7rqwm1yEjnf2nIjkwoI0u+M8wGb90telgCQafVoGkNVP/Yhi6ebb8Ipa2dXT5x8G1vNwb/SZ4CHFGByn8EFa7oCzLiHsLJiuonsuwTu8lI6leAinMIwzOh9AEU7p9stY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765189123; c=relaxed/simple;
	bh=p/uK0bPG4yk2qCRM4cLvNdKCcpfdEnaQ0rGXZZeRTnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nmcu0qZ2icgVGkBC7aFl2aOqVrXLc727BkZdGt4KnB3sYtx3gvX5H36q8s/YiW6QABCmpqS1wsMpIuZRu3Qu7OoMcu0MgMbGutn/5bmHhBo3ziRZr/MKseEyrCc4Ia5hFJAgQ0Sj32iV/UCUGtm/kfK3exF8Bui4qg4LS4Qm/4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vslo0nXg; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765189121; x=1796725121;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=p/uK0bPG4yk2qCRM4cLvNdKCcpfdEnaQ0rGXZZeRTnc=;
  b=Vslo0nXg4ZRKGfULNfwcSww7bjbh+4Pwd2yrnCF0E9F2Vyko7lZ0LJNO
   sfdQeeOitieAAvHtrqbsw3R3h01ZQCjGgphX2Ldu7duQHVYB/QKDk6pPP
   zgrXMnD2uCuQYCFeGNeLMqC7ir05VNm4d6V9k0nwzkK+d5aKKIUh/arFM
   q7pNIcIkQ8yvwTvt2zFd8WjIim+SoEwRujp1ZD+AvEJm4Os0JW65GWNny
   0nCaWAUEQ5dUx+a5UBPKNtKcPlkZp869knbMLZtJ5Jv9Jss3y8U/vp1zX
   Hc6WsPPiVr6ifVpYWVZUBlOdPKMieq/tB86DpkcSi7E7fzwv7eeos+dPl
   Q==;
X-CSE-ConnectionGUID: ryM/HSsnTYStYoj27WAYFg==
X-CSE-MsgGUID: JW+s46HqSomZ/xBD1WaB2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="70970768"
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="70970768"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 02:18:39 -0800
X-CSE-ConnectionGUID: 6gvQ/84JTKGlUXOV2I9U3A==
X-CSE-MsgGUID: +pXVwHBKSeeJTQE4HZVi7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="201024668"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa005.jf.intel.com with ESMTP; 08 Dec 2025 02:18:36 -0800
Date: Mon, 8 Dec 2025 18:02:52 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-coco@lists.linux.dev, linux-pci@vger.kernel.org,
	chao.gao@intel.com, dave.jiang@intel.com, baolu.lu@linux.intel.com,
	yilun.xu@intel.com, zhenzhong.duan@intel.com, kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com, dave.hansen@linux.intel.com,
	dan.j.williams@intel.com, kas@kernel.org, x86@kernel.org
Subject: Re: [PATCH v1 08/26] x86/virt/tdx: Add tdx_enable_ext() to enable of
 TDX Module Extensions
Message-ID: <aTaiTGsmPBgnan9J@yilunxu-OptiPlex-7050>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
 <20251117022311.2443900-9-yilun.xu@linux.intel.com>
 <cfcfb160-fcd2-4a75-9639-5f7f0894d14b@intel.com>
 <aRyphEW2jpB/3Ht2@yilunxu-OptiPlex-7050>
 <62bec236-4716-4326-8342-1863ad8a3f24@intel.com>
 <aR6ws2yzwQumApb9@yilunxu-OptiPlex-7050>
 <13e894a8-474f-465a-a13a-5d892efbfadb@intel.com>
 <aSBg+5rS1Y498gHx@yilunxu-OptiPlex-7050>
 <ca331aa3-6304-4e07-9ed9-94dc69726382@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca331aa3-6304-4e07-9ed9-94dc69726382@intel.com>

> >>> --- a/arch/x86/virt/vmx/tdx/tdx.h
> >>> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> >>> @@ -46,6 +46,7 @@
> >>>  #define TDH_PHYMEM_PAGE_WBINVD         41
> >>>  #define TDH_VP_WR                      43
> >>>  #define TDH_SYS_CONFIG                 45
> >>> +#define TDH_SYS_CONFIG_V1              (TDH_SYS_CONFIG | (1ULL << TDX_VERSION_SHIFT))
> >>>
> >>> And if a SEAMCALL needs export, add new tdh_foobar() helper. Anyway
> >>> the parameter list should be different.
> >>
> >> I'd need quite a bit of convincing that this is the right way.
> >>
> >> What is the scenario where there's a:
> >>
> >> 	TDH_SYS_CONFIG_V1
> >> and
> >> 	TDH_SYS_CONFIG_V2
> >>
> >> in the tree at the same time?
> > 
> > I assume you mean TDH_SYS_CONFIG & TDH_SYS_CONFIG_V1.
> 
> Sure. But I wasn't being that literal about it. My point was whether we
> need two macros for two simultaneous uses of the same seamcall.
> 
> > If you want to enable optional features via this seamcall, you must use
> > v1, otherwise v0 & v1 are all good. Mm... I suddenly don't see usecase
> > they must co-exist. Unconditionally use v1 is fine. So does TDH_VP_INIT.
> > 
> > Does that mean we don't have to keep versions, always use the latest is
> > good? (Proper Macro to be used...)
> > 
> >  -#define TDH_SYS_CONFIG                 45
> >  +#define TDH_SYS_CONFIG                 (45 | (1ULL << TDX_VERSION_SHIFT))
> 
> That's my theory: we don't need to keep versions.

Sorry, I found we have to keep versions for backward compatibility. The
old TDX Modules reject v1.

Here is my change, including TDH_SYS_CONFIG & TDH_VP_INIT. Will break
them down in formal patches.

-----8<-------

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 3b4d7cb25164..1e0a174dfb57 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1330,6 +1330,7 @@ static __init int config_tdx_module(struct tdmr_info_list *tdmr_list,
                                    u64 global_keyid)
 {
        struct tdx_module_args args = {};
+       u64 seamcall_fn = TDH_SYS_CONFIG;
        u64 *tdmr_pa_array;
        size_t array_sz;
        int i, ret;
@@ -1354,7 +1355,14 @@ static __init int config_tdx_module(struct tdmr_info_list *tdmr_list,
        args.rcx = __pa(tdmr_pa_array);
        args.rdx = tdmr_list->nr_consumed_tdmrs;
        args.r8 = global_keyid;
-       ret = seamcall_prerr(TDH_SYS_CONFIG, &args);
+
+       if (tdx_sysinfo.features.tdx_features0 & TDX_FEATURES0_TDXCONNECT) {
+               args.r9 |= TDX_FEATURES0_TDXCONNECT;
+               args.r11 = ktime_get_real_seconds();
+               seamcall_fn = TDH_SYS_CONFIG_V1;
+       }
+
+       ret = seamcall_prerr(seamcall_fn, &args);

        /* Free the array as it is not required anymore. */
        kfree(tdmr_pa_array);
@@ -2153,7 +2166,7 @@ u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid)
        };

        /* apicid requires version == 1. */
-       return seamcall(TDH_VP_INIT | (1ULL << TDX_VERSION_SHIFT), &args);
+       return seamcall(TDH_VP_INIT_V1, &args);
 }
 EXPORT_SYMBOL_GPL(tdh_vp_init);

diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 4370d3d177f6..835ea2f08fe2 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -2,6 +2,7 @@
 #ifndef _X86_VIRT_TDX_H
 #define _X86_VIRT_TDX_H

+#include <linux/bitfield.h>
 #include <linux/bits.h>

 /*
@@ -11,6 +12,18 @@
  * architectural definitions come first.
  */

+/*
+ * SEAMCALL leaf:
+ *
+ * Bit 15:0    Leaf number
+ * Bit 23:16   Version number
+ */
+#define SEAMCALL_LEAF                  GENMASK(15, 0)
+#define SEAMCALL_VER                   GENMASK(23, 16)
+
+#define SEAMCALL_LEAF_VER(l, v)                (FIELD_PREP(SEAMCALL_LEAF, l) | \
+                                        FIELD_PREP(SEAMCALL_VER, v))
+
 /*
  * TDX module SEAMCALL leaf functions
  */
@@ -31,7 +44,7 @@
 #define TDH_VP_CREATE                  10
 #define TDH_MNG_KEY_FREEID             20
 #define TDH_MNG_INIT                   21
-#define TDH_VP_INIT                    22
+#define TDH_VP_INIT_V1                 SEAMCALL_LEAF_VER(22, 1)
 #define TDH_PHYMEM_PAGE_RDMD           24
 #define TDH_VP_RD                      26
 #define TDH_PHYMEM_PAGE_RECLAIM                28
@@ -46,14 +59,7 @@
 #define TDH_PHYMEM_PAGE_WBINVD         41
 #define TDH_VP_WR                      43
 #define TDH_SYS_CONFIG                 45
-
-/*
- * SEAMCALL leaf:
- *
- * Bit 15:0    Leaf number
- * Bit 23:16   Version number
- */
-#define TDX_VERSION_SHIFT              16
+#define TDH_SYS_CONFIG_V1              SEAMCALL_LEAF_VER(TDH_SYS_CONFIG, 1)

 /* TDX page types */
 #define        PT_NDA          0x0



