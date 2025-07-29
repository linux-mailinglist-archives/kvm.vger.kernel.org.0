Return-Path: <kvm+bounces-53599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E7B9B1476B
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 07:05:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58774542EB3
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 05:05:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AFCE234984;
	Tue, 29 Jul 2025 05:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jEC8rh+u"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E025224AF2;
	Tue, 29 Jul 2025 05:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753765513; cv=none; b=bxa/CaISuHRQTSteqd6JLuzqdmTrE2+NyiZjxuMLKh7NmOBkkxRiWxful2PjnSPhFULV9K5sutrPFxMDU2/rtlXlMBNjtk0XCReek+pc1dq1baUsgPj31Y66k4faN1A99IZUv+1KFoaOi1njTP4x5nEYF4X6lXOOcdYCsRoEZr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753765513; c=relaxed/simple;
	bh=5egcKgD4FYDc9odofRDQJ94rLDaE5PJqwRcIkar3lGo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=apIn3ZKNIka7XFZYLatVPgk3nHlve8EKd0odVgwi9DVsqLzupqpkqrsfEk22pnuJrOHtaH/+qIPBxxAP51sMO64AA3AVbTzoOYnGtMF79f4toonrfyarz7lPYQRv3gL6DpQCLuuUCEfPqs3rnbu0IpJ+jovtlHnSKoxH0rkufis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jEC8rh+u; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753765512; x=1785301512;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5egcKgD4FYDc9odofRDQJ94rLDaE5PJqwRcIkar3lGo=;
  b=jEC8rh+uj5kSZgFbvwlnzjVx+n7L50vIpMUAlFIJCizlHoakH52GR1cN
   VJ/WVVJ+lDKUhuseKemjFlxp5evxVvRU0eADliJwcYcWDB48aWhnRwbhz
   WnTDSnRnwrVa7oq/XAOP04/G7/eWP5nCWpBH1+dbcTWERk5xIml9JnJ1G
   lzb3OmtZbxM7HNLX5hIUmo52jl3DLjqefAzS8KwCaeIS1XDZkiKLCu5+2
   Q1Qi3UwhMyYPPvMJma3MF09GkXwWgRmL36u8QCZeraFDrSvhmT+pYM1aJ
   qqM2bW4LfQw9oxUIUXAuKhpRvwS6DO2R+AHiGFL7dOEAARo57OpcHMtcO
   w==;
X-CSE-ConnectionGUID: YHc11TtWRTKLEUlT46UY9g==
X-CSE-MsgGUID: PYjPUCX4R2uo8LzxQa1ASg==
X-IronPort-AV: E=McAfee;i="6800,10657,11505"; a="59671659"
X-IronPort-AV: E=Sophos;i="6.16,348,1744095600"; 
   d="scan'208";a="59671659"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2025 22:05:11 -0700
X-CSE-ConnectionGUID: NtU2Nli6Ro2azAlZ/UeGhA==
X-CSE-MsgGUID: WWnmbXg2QjKOC6qN3TIygg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,348,1744095600"; 
   d="scan'208";a="162172796"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa007.fm.intel.com with ESMTP; 28 Jul 2025 22:05:06 -0700
Date: Tue, 29 Jul 2025 12:55:51 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, x86@kernel.org, kvm@vger.kernel.org,
	seanjc@google.com, pbonzini@redhat.com, eddie.dong@intel.com,
	kirill.shutemov@intel.com, dave.hansen@intel.com,
	dan.j.williams@intel.com, kai.huang@intel.com,
	isaku.yamahata@intel.com, elena.reshetova@intel.com,
	rick.p.edgecombe@intel.com, Farrah Chen <farrah.chen@intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 07/20] x86/virt/tdx: Expose SEAMLDR information via
 sysfs
Message-ID: <aIhUVyJVQ+rhRB4r@yilunxu-OptiPlex-7050>
References: <20250523095322.88774-1-chao.gao@intel.com>
 <20250523095322.88774-8-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250523095322.88774-8-chao.gao@intel.com>

> +static const struct attribute_group *tdx_subsys_groups[] = {
> +	SEAMLDR_GROUP,
> +	NULL,
> +};
> +
>  static void tdx_subsys_init(void)
>  {
>  	struct tdx_tsm *tdx_tsm;
>  	int err;
>  
> +	err = get_seamldr_info();
> +	if (err) {
> +		pr_err("failed to get seamldr info %d\n", err);
> +		return;
> +	}
> +
>  	/* Establish subsystem for global TDX module attributes */
> -	err = subsys_virtual_register(&tdx_subsys, NULL);
> +	err = subsys_virtual_register(&tdx_subsys, tdx_subsys_groups);
>  	if (err) {
>  		pr_err("failed to register tdx_subsys %d\n", err);
>  		return;

As mentioned, TDX Connect also uses this virtual TSM device. And I tend
to extend it to TDX guest, also make the guest TSM management run on
the virtual device which represents the TDG calls and TDG_VP_VM calls.

So I'm considering extract the common part of tdx_subsys_init() out of
TDX host and into a separate file, e.g.

---

+source "drivers/virt/coco/tdx-tsm/Kconfig"
+
 config TSM
        bool
diff --git a/drivers/virt/coco/Makefile b/drivers/virt/coco/Makefile
index c0c3733be165..a54d3cb5b4e9 100644
--- a/drivers/virt/coco/Makefile
+++ b/drivers/virt/coco/Makefile
@@ -10,3 +10,4 @@ obj-$(CONFIG_INTEL_TDX_GUEST) += tdx-guest/
 obj-$(CONFIG_ARM_CCA_GUEST)    += arm-cca-guest/
 obj-$(CONFIG_TSM)              += tsm-core.o
 obj-$(CONFIG_TSM_GUEST)                += guest/
+obj-y                          += tdx-tsm/
diff --git a/drivers/virt/coco/tdx-tsm/Kconfig b/drivers/virt/coco/tdx-tsm/Kconfig
new file mode 100644
index 000000000000..768175f8bb2c
--- /dev/null
+++ b/drivers/virt/coco/tdx-tsm/Kconfig
@@ -0,0 +1,2 @@
+config TDX_TSM_BUS
+       bool
diff --git a/drivers/virt/coco/tdx-tsm/Makefile b/drivers/virt/coco/tdx-tsm/Makefile
new file mode 100644
index 000000000000..09f0ac08988a
--- /dev/null
+++ b/drivers/virt/coco/tdx-tsm/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_TDX_TSM_BUS) += tdx-tsm-bus.o

---

And put the tdx_subsys_init() in tdx-tsm-bus.c. We need to move host
specific initializations out of tdx_subsys_init(), e.g. seamldr_group &
seamldr fw upload.

Thanks,
Yilun

