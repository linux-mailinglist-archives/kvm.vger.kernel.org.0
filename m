Return-Path: <kvm+bounces-46715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DA90DAB8E83
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 20:08:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 628BE1BC60DA
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 18:08:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE6A925C6E3;
	Thu, 15 May 2025 18:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="it4p5Hh5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDCD25A338;
	Thu, 15 May 2025 18:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747332503; cv=none; b=cR/rNk0D2izHM2hdhlwG63RnOEDjq+QNheEylGHP6egLAYWTgJ+ep++s0u+kyT7rvBRHe2T9akbLWO6qNYSKKGKBpRogh/kqmdKbSNWwMKN2cjiqJL0rSHJzGWVmLRT5r+Ya3FXvjYrsu8KdioJ6fK+AWRE+6dIcvVg0lvLvsgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747332503; c=relaxed/simple;
	bh=AgsXEgybKJC5NgUaI+KPLkWpvyHX1LAfCpawBKt7gHA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s+Mr9x4F/8oht/jC8aZSShtfbwyr9Xru1BrQ4NrNn/dOUqyq+3CxCPiwyI71gGhQyY0TQRu/blERTreJsRI8IWIzaFty6veNmFMm3ARFH+T73Al0F6pvA/PBn/IGXKht7AVoJqgiretV3pHn5oZBMiq25qpngv/s1MhLjcEAWWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=it4p5Hh5; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747332502; x=1778868502;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AgsXEgybKJC5NgUaI+KPLkWpvyHX1LAfCpawBKt7gHA=;
  b=it4p5Hh5YJ+rjjs3gWvB4akbNIbamtbXwUeMdii/Q9fhYMwzqS0MBYE9
   9avIM5VCN33yoT3pZ8otDW53lCqtzpExRbci7NuUV6RFPxWCMmsfgkmp2
   HMme5ohEFtaNA7xHUNe9gYxpRlcN39iMtBwB3xU0pHZ1MZ37hUar27QCM
   EIuZ4OAbHIXV2w2/w4qMaSCFKdo/XuF3r65ha1kfC/LTjXBw55yNuFbUT
   kgoAqA5CUfaJelW24VCiXPHPuVJDjDaoIzFA0i8c3rr0xEajSJ6H086D2
   TzxZon9Q5OEw9MDdy0unz0HOk4HsOYZR97oCK28yp53HTr2OYz0ABt4ZH
   Q==;
X-CSE-ConnectionGUID: 3ak+ML4iTEClwd93i3bcjw==
X-CSE-MsgGUID: x5M5CW/FRw6AFimu8iNi1g==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="60304166"
X-IronPort-AV: E=Sophos;i="6.15,291,1739865600"; 
   d="scan'208";a="60304166"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 11:08:21 -0700
X-CSE-ConnectionGUID: 0qlDoZHvQuWXHzOv/4v1hg==
X-CSE-MsgGUID: wC3Reo/iRc6O5IOzpxZAKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,291,1739865600"; 
   d="scan'208";a="138841415"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa008.fm.intel.com with ESMTP; 15 May 2025 11:08:09 -0700
Date: Fri, 16 May 2025 02:02:29 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Zhi Wang <zhiw@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Alexey Kardashevskiy <aik@amd.com>,
	kvm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	sumit.semwal@linaro.org, christian.koenig@amd.com,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	vivek.kasireddy@intel.com, dan.j.williams@intel.com,
	yilun.xu@intel.com, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch, leon@kernel.org, baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com, tao1.su@intel.com
Subject: Re: [RFC PATCH 00/12] Private MMIO support for private assigned dev
Message-ID: <aCYsNSFQJZzHVOFI@yilunxu-OptiPlex-7050>
References: <c10bf9c2-e073-479d-ad1c-6796c592d333@amd.com>
 <aB3jLmlUKKziwdeG@yilunxu-OptiPlex-7050>
 <aB4tQHmHzHooDeTE@yilunxu-OptiPlex-7050>
 <20250509184318.GD5657@nvidia.com>
 <aB7Ma84WXATiu5O1@yilunxu-OptiPlex-7050>
 <2c4713b0-3d6c-4705-841b-1cb58cd9a0f5@amd.com>
 <20250512140617.GA285583@nvidia.com>
 <20250513130315.0158a626.zhiw@nvidia.com>
 <aCRmoDupzK9zTqFL@yilunxu-OptiPlex-7050>
 <20250514230502.6b64da7f.zhiw@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250514230502.6b64da7f.zhiw@nvidia.com>

> IMHO, I think it might be helpful that you can picture out what are the
> minimum requirements (function/life cycle) to the current IOMMUFD TSM
> bind architecture:
> 
> 1.host tsm_bind (preparation) is in IOMMUFD, triggered by QEMU handling
> the TVM-HOST call.
> 2. TDI acceptance is handled in guest_request() to accept the TDI after
> the validation in the TVM)

I'll try my best to brainstorm and make a flow in ASCII. 

(*) means new feature


      Guest          Guest TSM       QEMU           VFIO            IOMMUFD       host TSM          KVM 
      -----          ---------       ----           ----            -------       --------          ---
1.                                                                               *Connect(IDE)
2.                                 Init vdev            
3.                                *create dmabuf   
4.                                               *export dmabuf                              
5.                                create memslot
6.                                                                                              *import dmabuf
7.                                setup shared DMA
8.                                                                 create hwpt
9.                                               attach hwpt
10.                                  kvm run
11.enum shared dev
12.*Connect(Bind)
13.                  *GHCI Bind
14.                                  *Bind
15                                                                 CC viommu alloc
16.                                                                vdevice allloc
16.                                              *attach vdev
17.                                                               *setup CC viommu
18                                                                 *tsm_bind
19.                                                                                  *bind
20.*Attest
21.               *GHCI get CC info
22.                                 *get CC info
23.                                                                *vdev guest req
24.                                                                                 *guest req
25.*Accept
26.             *GHCI accept MMIO/DMA
27.                                *accept MMIO/DMA
28.                                                               *vdev guest req
29.                                                                                 *guest req
30.                                                                                              *map private MMIO
31.             *GHCI start tdi
32.                                *start tdi
33.                                                               *vdev guest req
34.                                                                                 *guest req
35.Workload...
36.*disconnect(Unbind)
37.              *GHCI unbind
38.                                *Unbind
39.                                            *detach vdev
40.                                                               *tsm_unbind
41.                                                                                 *TDX stop tdi
42.                                                                                 *TDX disable mmio cb
43.                                            *cb dmabuf revoke
44.                                                                                               *unmap private MMIO
45.                                                                                 *TDX disable dma cb
46.                                                              *cb disable CC viommu
47.                                                                                 *TDX tdi free
48.                                                                                 *enable mmio
49.                                            *cb dmabuf recover
50.workable shared dev

TSM unbind is a little verbos & specific to TDX Connect, but SEV TSM could
ignore these callback. Just implement an "unbind" tsm ops.

Thanks,
Yilun

> 
> and which part/where need to be modified in the current architecture to
> reach there. Try to fold vendor-specific knowledge as much as possible,
> but still keep them modular in the TSM driver and let's see how it looks
> like. Maybe some example TSM driver code to demonstrate together with
> VFIO dma-buf patch.
> 
> If some where is extremely hacky in the TSM driver, let's see how they
> can be lift to the upper level or the upper call passes more parameters
> to them.
> 

