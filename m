Return-Path: <kvm+bounces-6068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9936982AA84
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 10:07:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99CE21C261FC
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 09:07:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAD0D125DA;
	Thu, 11 Jan 2024 09:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zp9ecvpP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DB012E5B
	for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 09:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704963959; x=1736499959;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WJYX7eVmKz0kBzx3Qx8aLWx4x2vYw6sUwUHVR0Zf0yM=;
  b=Zp9ecvpP/u53Nd/Kw7s/8ZLGtJWvtML++GSBV2jCvC36T2e0GHvf365H
   sOL3Kl1pZA/yB5mCLUoNhSB62YH7KfP9n8yfNgn2cF7VgFeFNeJCJ2XmR
   n4TvxhDXb1VhAgIucELSBQTXrZYcIkoboYS4PWJotMP9fxkY+ceEyOnM7
   jB8f29L966DaG0FwQRy4wRojLlwH0Bt08lNcKtPEj/TPEO8Dvpl/lkw3p
   q/hrqjRzjtPTqOhTlyw+tm2ak/2RkJ5k+M6SNVoN/yFG+4w4Xc04Ojo/L
   534X9bUh6HWAG7QnjjQiRMWDiliFRJOCogLDFoHy6UL91qjJxtBjn2QC1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10949"; a="389225285"
X-IronPort-AV: E=Sophos;i="6.04,185,1695711600"; 
   d="scan'208";a="389225285"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2024 01:05:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10949"; a="1113769799"
X-IronPort-AV: E=Sophos;i="6.04,185,1695711600"; 
   d="scan'208";a="1113769799"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmsmga005.fm.intel.com with ESMTP; 11 Jan 2024 01:05:54 -0800
Date: Thu, 11 Jan 2024 17:18:50 +0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>, Babu Moger <babu.moger@amd.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [PATCH v7 07/16] i386: Support modules_per_die in X86CPUTopoInfo
Message-ID: <ZZ+yei0d1kRyJC7F@intel.com>
References: <20240108082727.420817-1-zhao1.liu@linux.intel.com>
 <20240108082727.420817-8-zhao1.liu@linux.intel.com>
 <866a3a37-cba8-425c-9d9b-57ad05b16bc4@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <866a3a37-cba8-425c-9d9b-57ad05b16bc4@intel.com>

Hi Xiaoyao,

On Thu, Jan 11, 2024 at 01:53:53PM +0800, Xiaoyao Li wrote:

> > -    cores_per_pkg = topo_info.cores_per_die * topo_info.dies_per_pkg;
> > +    cores_per_pkg = topo_info.cores_per_module * topo_info.modules_per_die *
> > +                    topo_info.dies_per_pkg;
> 
> Nit. maybe we can introduce some helper function like
> 
> static inline uint32_t topo_info_cores_per_pkg(X86CPUTopoInfo *topo_info) {
> 	return topo_info.cores_per_module * topo_info.modules_per_die *
>                topo_info.dies_per_pkg;
> }
> 
> so we don't need to care how it calculates.

Yeah, will add this helper, maybe in another patch.

> 
> Besides,
> 
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

Thanks!

-Zhao

