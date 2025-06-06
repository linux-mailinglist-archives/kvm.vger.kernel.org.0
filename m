Return-Path: <kvm+bounces-48629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E17EACFBFE
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 06:33:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC8C7173384
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 04:33:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C2261E2602;
	Fri,  6 Jun 2025 04:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YQZP8hn+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71D67FD;
	Fri,  6 Jun 2025 04:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749184376; cv=none; b=DQAGNm13t+mlUJEIWdvLLh0mzQzxByXTCGbGlV1PS5oeQ+qX2DTNMZO17mPtYSI2Q32bOvTJ8V8EFp1WdG+ykb9gxFhLHwbECYJhR6KJ1FzVmKefzONVzyqOJVXP6geSQEh3lCo5PIkWS2oKGSH85Fv3L5/yacnJTX2iS7gG4Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749184376; c=relaxed/simple;
	bh=yLDNyNn/xDL5lmtA4zeU4VCRJdc6yerfu8f1Dqe1TBs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vFpyq/rMXw3mV3EWuZdcJHKJUmhwZPecr0drCWeA50PKE0w6Nbmz3qxcEH0ue81ueNgwDYMkFdoFzqikvWvmG9ANUYJY1z683+u/LXK2b2CwWaGSUQ54iRAFqXuCgZb4/287u7zXFdXS+Cl7XMbcwZ99DfFBTRJojhPPdZRduzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YQZP8hn+; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749184375; x=1780720375;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=yLDNyNn/xDL5lmtA4zeU4VCRJdc6yerfu8f1Dqe1TBs=;
  b=YQZP8hn+SOUfzKbwhx47ZKLENBZNgsFZubTErvJES9pTsRuolVvCshsW
   UNELI6UU2wV1yrWw0LAk2gLe5/48qDFbZ7koz7y2SVxrbZY+4xG0Y+xKz
   eaReq9JKvBGgynwp55+hjEb2rpxYHi50aYU9yeiyFMxeuvigosyUY+Dc+
   Myejwa/wFPBS3Zw35w3GVRWCKE6aXpLHLKKQE5+wMITyl9D4+k27pLynb
   4eg8aM/etT2Igig8URPNs470V+3v+4/IqxJKkoK4beJumRoatH5lF+96j
   vVwpmvxHy9szYcIwoghKIu99UxsNwiDUrbEw/r5UM7kxhExZoXtJhqH5O
   A==;
X-CSE-ConnectionGUID: gaYWy8jGSbeNnIz5MTldLQ==
X-CSE-MsgGUID: 7rnkmtpFS7C1QBh9/XMEfg==
X-IronPort-AV: E=McAfee;i="6800,10657,11455"; a="51468937"
X-IronPort-AV: E=Sophos;i="6.16,214,1744095600"; 
   d="scan'208";a="51468937"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2025 21:32:54 -0700
X-CSE-ConnectionGUID: a2NVxN3HTFG+xIUIK89PUA==
X-CSE-MsgGUID: 8D/PmArNSKGGUGligSxiFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,214,1744095600"; 
   d="scan'208";a="182904220"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa001.jf.intel.com with ESMTP; 05 Jun 2025 21:32:47 -0700
Date: Fri, 6 Jun 2025 12:26:07 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, kvm@vger.kernel.org,
	sumit.semwal@linaro.org, christian.koenig@amd.com,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	dan.j.williams@intel.com, aik@amd.com, linux-coco@lists.linux.dev,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, vivek.kasireddy@intel.com,
	yilun.xu@intel.com, linux-kernel@vger.kernel.org, lukas@wunner.de,
	yan.y.zhao@intel.com, daniel.vetter@ffwll.ch, leon@kernel.org,
	baolu.lu@linux.intel.com, zhenzhong.duan@intel.com,
	tao1.su@intel.com, linux-pci@vger.kernel.org, zhiw@nvidia.com,
	simona.vetter@ffwll.ch, shameerali.kolothum.thodi@huawei.com,
	iommu@lists.linux.dev, kevin.tian@intel.com
Subject: Re: [RFC PATCH 19/30] vfio/pci: Add TSM TDI bind/unbind IOCTLs for
 TEE-IO support
Message-ID: <aEJt39oExEUDg/Dh@yilunxu-OptiPlex-7050>
References: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
 <20250529053513.1592088-20-yilun.xu@linux.intel.com>
 <yq5ah60u8kev.fsf@kernel.org>
 <20250605151029.GC19710@nvidia.com>
 <yq5a7c1q88oy.fsf@kernel.org>
 <20250605163339.GE19710@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250605163339.GE19710@nvidia.com>

On Thu, Jun 05, 2025 at 01:33:39PM -0300, Jason Gunthorpe wrote:
> On Thu, Jun 05, 2025 at 09:47:01PM +0530, Aneesh Kumar K.V wrote:
> > Jason Gunthorpe <jgg@nvidia.com> writes:
> > 
> > > On Thu, Jun 05, 2025 at 05:33:52PM +0530, Aneesh Kumar K.V wrote:
> > >
> > >> > +
> > >> > +	/* To ensure no host side MMIO access is possible */
> > >> > +	ret = pci_request_regions_exclusive(pdev, "vfio-pci-tsm");
> > >> > +	if (ret)
> > >> > +		goto out_unlock;
> > >> > +
> > >> >
> > >> 
> > >> I am hitting failures here with similar changes. Can you share the Qemu
> > >> changes needed to make this pci_request_regions_exclusive successful.

Jason has described the suggested static lockdown flow and we could
try on that.  I just wanna help position your immediate failure.

Maybe you still have QEMU mmapped the MMIO region.

int vfio_pci_core_mmap()
{
...

	if (!vdev->barmap[index]) {
		ret = pci_request_selected_regions(pdev,
						   1 << index, "vfio-pci");
...
}

Even for static lockdown, userspace should not mmap the MMIOs anymore.

Thanks,
Yilun

> > >> Also after the TDI is unbound, we want the region ownership backto
> > >> "vfio-pci" so that things continue to work as non-secure device. I don't
> > >> see we doing that. I could add a pci_bar_deactivate/pci_bar_activate in
> > >> userspace which will result in vfio_unmap()/vfio_map(). But that doesn't
> > >> release the region ownership.
> > >
> > > Again, IMHO, we should not be doing this dynamically. VFIO should do
> > > pci_request_regions_exclusive() once at the very start and it should
> > > stay that way.
> > >
> > > There is no reason to change it dynamically.
> > >
> > > The only decision to make is if all vfio should switch to exclusive
> > > mode or if we need to make it optional for userspace.
> > 
> > We only need the exclusive mode when the device is operating in secure
> > mode, correct? That suggests we’ll need to dynamically toggle this
> > setting based on the device’s security state.
> 
> No, if the decision is that VFIO should allow this to be controlled by
> userspace then userspace will tell iommufd to run in regions_exclusive
> mode prior to opening the vfio cdev and VFIO will still do it once at
> open time and never change it.
> 
> The only thing request_regions does is block other drivers outside
> vfio from using this memory space. There is no reason at all to change
> this dynamically. A CC VMM using VFIO will never use a driver outside
> VFIO to touch the VFIO controlled memory.
> 
> Jason

