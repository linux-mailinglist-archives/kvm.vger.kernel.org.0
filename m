Return-Path: <kvm+bounces-47654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 519BEAC2D3F
	for <lists+kvm@lfdr.de>; Sat, 24 May 2025 05:39:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE77EA24F75
	for <lists+kvm@lfdr.de>; Sat, 24 May 2025 03:39:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 795FD1A725A;
	Sat, 24 May 2025 03:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XrqQljMu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95AD4101FF;
	Sat, 24 May 2025 03:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748057976; cv=none; b=sA/Nz95HDKe6ylt/T6/DBSgfVqxMpBKcx318xx5omDg7MUIRU4Jy//m8rgkhCwEVb39ra/mpjVCMrzPG1uIYJONYwAnaiQEWxOAoIW+HfGIqfmUj5lCzJF7RCA7soIAXZGB/7R682oliLEJpcrZHxkzcvtdHVWlmb18TMgOixMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748057976; c=relaxed/simple;
	bh=7IzTik7Z1oQYNbi1ZtvITH1vtj4QWC1+x7Q28RIHobI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R6w0DmHEqdXbKlatfy802Y8vNbzvyKZrAvAABTSCZvruHp5JqHJBO87vuNReAlR4ou5dnwsuucLkozeBUSs1KT099TutJ1McDPttcQI5wCRs0hZx1LRx1hJ/H15fCVSvEMfEzrGgfHwznxEi8Y/LRtlhGYbK/7i0GQ7lK0TVVSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XrqQljMu; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748057973; x=1779593973;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7IzTik7Z1oQYNbi1ZtvITH1vtj4QWC1+x7Q28RIHobI=;
  b=XrqQljMuPCnydCrBKUKNKl/sgSQfxikD0pa/vGCzEh+3uD626/s9zZDc
   EO3AC0d2NgeD0yYnCfyevH1Y4E2XMzvb1Np7NTndSyUdz5XYT+TikLzE6
   m7xgw7H9oRGhjCa1/OxVMBhyszM1JdSOoQsP/DKlzL9f1KH8llAp5qZmY
   lqCT2qtLb32zsdz3Tp8+bEYsZRZkZ5Av3G+K1HvosWbuz0WE88UsKMSBv
   0ejLYZni7BmK6MQGgV+CjTz9DMKG3TgZCwmectd4OHkeKIuLrB38Fmal3
   TCVFX9ywp4P/r/lCXS3MqoJPVYH3LdexcxL0+zaANRalL5y3oU1wJnUPV
   A==;
X-CSE-ConnectionGUID: hCdmmq9kSAmjcMsWfSWjKg==
X-CSE-MsgGUID: jiAD3MUdS92tITHvGVGJPQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="50227673"
X-IronPort-AV: E=Sophos;i="6.15,310,1739865600"; 
   d="scan'208";a="50227673"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 20:39:32 -0700
X-CSE-ConnectionGUID: zcZxj8dbTb+bAaFrzD0SGA==
X-CSE-MsgGUID: DCJiGGXWQl+UORP1bJyepw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,310,1739865600"; 
   d="scan'208";a="141966994"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa007.jf.intel.com with ESMTP; 23 May 2025 20:39:28 -0700
Date: Sat, 24 May 2025 11:33:25 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: Zhi Wang <zhiw@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
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
Message-ID: <aDE+BaMo+X75QaEW@yilunxu-OptiPlex-7050>
References: <aB4tQHmHzHooDeTE@yilunxu-OptiPlex-7050>
 <20250509184318.GD5657@nvidia.com>
 <aB7Ma84WXATiu5O1@yilunxu-OptiPlex-7050>
 <2c4713b0-3d6c-4705-841b-1cb58cd9a0f5@amd.com>
 <20250512140617.GA285583@nvidia.com>
 <20250513130315.0158a626.zhiw@nvidia.com>
 <aCRmoDupzK9zTqFL@yilunxu-OptiPlex-7050>
 <20250514230502.6b64da7f.zhiw@nvidia.com>
 <aCYsNSFQJZzHVOFI@yilunxu-OptiPlex-7050>
 <3909686a-be14-4b0b-8336-0674667d5159@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3909686a-be14-4b0b-8336-0674667d5159@amd.com>

On Tue, May 20, 2025 at 08:57:42PM +1000, Alexey Kardashevskiy wrote:
> 
> 
> On 16/5/25 04:02, Xu Yilun wrote:
> > > IMHO, I think it might be helpful that you can picture out what are the
> > > minimum requirements (function/life cycle) to the current IOMMUFD TSM
> > > bind architecture:
> > > 
> > > 1.host tsm_bind (preparation) is in IOMMUFD, triggered by QEMU handling
> > > the TVM-HOST call.
> > > 2. TDI acceptance is handled in guest_request() to accept the TDI after
> > > the validation in the TVM)
> > 
> > I'll try my best to brainstorm and make a flow in ASCII.
> > 
> > (*) means new feature
> > 
> > 
> >        Guest          Guest TSM       QEMU           VFIO            IOMMUFD       host TSM          KVM
> >        -----          ---------       ----           ----            -------       --------          ---
> > 1.                                                                               *Connect(IDE)
> > 2.                                 Init vdev
> > 3.                                *create dmabuf
> > 4.                                               *export dmabuf
> > 5.                                create memslot
> > 6.                                                                                              *import dmabuf
> > 7.                                setup shared DMA
> > 8.                                                                 create hwpt
> > 9.                                               attach hwpt
> > 10.                                  kvm run
> > 11.enum shared dev
> > 12.*Connect(Bind)
> > 13.                  *GHCI Bind
> > 14.                                  *Bind
> > 15                                                                 CC viommu alloc
> > 16.                                                                vdevice allloc
> > 16.                                              *attach vdev
> 
> 
> This "attach vdev" - we are still deciding if it goes to IOMMUFD or VFIO, right?

This should be "tsm bind". Seems Jason's suggestion is place the IOCTL
against VFIO, then VFIO reach into IOMMUFD to do the real
pci_tsm_bind().

https://lore.kernel.org/all/20250515175658.GR382960@nvidia.com/

> 
> 
> > 17.                                                               *setup CC viommu
> > 18                                                                 *tsm_bind
> > 19.                                                                                  *bind
> > 20.*Attest
> > 21.               *GHCI get CC info
> > 22.                                 *get CC info
> > 23.                                                                *vdev guest req
> > 24.                                                                                 *guest req
> > 25.*Accept
> > 26.             *GHCI accept MMIO/DMA
> > 27.                                *accept MMIO/DMA
> > 28.                                                               *vdev guest req
> > 29.                                                                                 *guest req
> > 30.                                                                                              *map private MMIO
> > 31.             *GHCI start tdi
> > 32.                                *start tdi
> > 33.                                                               *vdev guest req
> > 34.                                                                                 *guest req
> 
> 
> I am not sure I follow the layout here. "start tdi" and "accept MMIO/DMA" are under "QEMU" but QEMU cannot do anything by itself and has to call VFIO or some other driver...
> 

Yes. Call IOCTL(iommufd, IOMMUFD_VDEVICE_GUEST_REQUEST, vdevice_id)

> > 35.Workload...
> > 36.*disconnect(Unbind)
> 
> Is this a case of PCI hotunplug? Or just killing QEMU/shutting down the VM? Or stopping trusting the device and switching it to untrusted mode, to work with SWIOTLB or DiscardManager?
> 

switching to untrusted mode. But I think hotunplug would finally trigger
the same host side behavior, only no need the guest to "echo 0 > connect"

> > 37.              *GHCI unbind
> > 38.                                *Unbind
> > 39.                                            *detach vdev
> > 40.                                                               *tsm_unbind
> > 41.                                                                                 *TDX stop tdi
> > 42.                                                                                 *TDX disable mmio cb
> > 43.                                            *cb dmabuf revoke
> 
> 
> ... like VFIO and hostTSM - "TDX stop tdi" and "cb dmabuf revoke" are not under QEMU.

Correct. These are TDX Module specific requirements, we don't want them
to make the general APIs unnecessary verbose.

> 
> 
> > 44.                                                                                               *unmap private MMIO
> > 45.                                                                                 *TDX disable dma cb
> > 46.                                                              *cb disable CC viommu
> > 47.                                                                                 *TDX tdi free
> > 48.                                                                                 *enable mmio
> > 49.                                            *cb dmabuf recover
> 
> 
> What is the difference between "cb dmabuf revoke" and "cb dmabuf recover"?

revoke revokes private S-EPT mapping, recover means KVM could then do
shared MMIO mapping on EPT.

Thanks,
Yilun

> 
> 
> > 50.workable shared dev
> > 
> > TSM unbind is a little verbos & specific to TDX Connect, but SEV TSM could
> > ignore these callback. Just implement an "unbind" tsm ops.
> 
> 
> Well, something need to clear RMP entries, can be done in the TDI unbind or whenever you will do it.
> 
> And the chart applies for AMD too, more or less. Thanks,
> 
> 
> > Thanks,
> > Yilun
> > 
> > > 
> > > and which part/where need to be modified in the current architecture to
> > > reach there. Try to fold vendor-specific knowledge as much as possible,
> > > but still keep them modular in the TSM driver and let's see how it looks
> > > like. Maybe some example TSM driver code to demonstrate together with
> > > VFIO dma-buf patch.
> > > 
> > > If some where is extremely hacky in the TSM driver, let's see how they
> > > can be lift to the upper level or the upper call passes more parameters
> > > to them.
> 
> 
> 
> -- 
> Alexey
> 

