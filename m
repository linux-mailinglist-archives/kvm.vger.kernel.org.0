Return-Path: <kvm+bounces-48509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B628ACED18
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 11:48:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A0103A6B3E
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 09:47:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B3B4213E7B;
	Thu,  5 Jun 2025 09:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jzl9LojX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9E62C3242;
	Thu,  5 Jun 2025 09:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749116884; cv=none; b=OnxkdfRSwmgJi4ZFATXECljRKwiDf2FV5Y8Q0vrsGr2/DYEXjXMg5cRKARnULpCQv210yubip2JLUDqyLeL7OHq2bCHacoRWHJXYbxl+mWnRt0BMxELtgNtHQC2XYN7frmjIK68d/OIE9G/PQ6Ekd+y19GlmH9fjelCW7Ayz2bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749116884; c=relaxed/simple;
	bh=/VL9o7ChNpJtoUsc5ibEOwDBnVANVkT3Ha++wcl3fYE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sxqv/yqPZ91Z6yu+St9Kr9ScP9xdF1Mf+glVdpT/eogz9ZxZy9K1TAv3HEVl4dd0VMmyQGngyVEMGGtQAN0fNA0OQa6qxI9eOCmPRqW5OwEFj3zVLWCzOjVArKc29LAqFCLy/aFgSMhoFB44C5BFizyMWdtP+q+c2AZwVGbRDdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jzl9LojX; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749116883; x=1780652883;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/VL9o7ChNpJtoUsc5ibEOwDBnVANVkT3Ha++wcl3fYE=;
  b=Jzl9LojXTcxA9v2vPNSYC+YgABD1rahkREzXZ/iQkE2Uw6jeezJHimKm
   I+A/CrUWSydOvc9AhaRAU85GnZ1lTymdzmVpaQYBqyE+FMO4HFU5RJgQ0
   MAvZV3qarpEo8Wy5mYIQw3tMUXRfBcO5L1sclTC56eF4YLLRY6F8OAZtq
   bAE877swmE+/w/yYLPsoih2mQxtBkHrZPTxtzOOieLUyRn2n++0BFctsW
   4MYYKMLtrlDQW+oRFqCCGAymQBlNOumWkTAZi8fKCeTU1muZZtWrFWTny
   KALOsUAj2SeJcrbND+z6PqnjyhJj9hIa3hPx2uI8SKj8co0fVOFz718+v
   Q==;
X-CSE-ConnectionGUID: b8Tnf0HQTN6ckJytSyY1MA==
X-CSE-MsgGUID: /qLFletzQaSMOJjHMzPmCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11454"; a="61894012"
X-IronPort-AV: E=Sophos;i="6.16,211,1744095600"; 
   d="scan'208";a="61894012"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2025 02:48:02 -0700
X-CSE-ConnectionGUID: bZl8PvLtTTmumH8CpnrPsQ==
X-CSE-MsgGUID: NroY4ThARXa4bErMmRN2Vg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,211,1744095600"; 
   d="scan'208";a="145358422"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa006.jf.intel.com with ESMTP; 05 Jun 2025 02:47:55 -0700
Date: Thu, 5 Jun 2025 17:41:17 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: kvm@vger.kernel.org, sumit.semwal@linaro.org, christian.koenig@amd.com,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	jgg@nvidia.com, dan.j.williams@intel.com, aik@amd.com,
	linux-coco@lists.linux.dev, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	vivek.kasireddy@intel.com, yilun.xu@intel.com,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch, leon@kernel.org, baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com, tao1.su@intel.com,
	linux-pci@vger.kernel.org, zhiw@nvidia.com, simona.vetter@ffwll.ch,
	shameerali.kolothum.thodi@huawei.com, iommu@lists.linux.dev,
	kevin.tian@intel.com
Subject: Re: [RFC PATCH 19/30] vfio/pci: Add TSM TDI bind/unbind IOCTLs for
 TEE-IO support
Message-ID: <aEFmPaYorqaYCKBY@yilunxu-OptiPlex-7050>
References: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
 <20250529053513.1592088-20-yilun.xu@linux.intel.com>
 <yq5aplfn210z.fsf@kernel.org>
 <aD24r44v0g1NgeZs@yilunxu-OptiPlex-7050>
 <yq5ajz5r8w6p.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5ajz5r8w6p.fsf@kernel.org>

On Wed, Jun 04, 2025 at 07:07:18PM +0530, Aneesh Kumar K.V wrote:
> Xu Yilun <yilun.xu@linux.intel.com> writes:
> 
> > On Sun, Jun 01, 2025 at 04:15:32PM +0530, Aneesh Kumar K.V wrote:
> >> Xu Yilun <yilun.xu@linux.intel.com> writes:
> >> 
> >> > Add new IOCTLs to do TSM based TDI bind/unbind. These IOCTLs are
> >> > expected to be called by userspace when CoCo VM issues TDI bind/unbind
> >> > command to VMM. Specifically for TDX Connect, these commands are some
> >> > secure Hypervisor call named GHCI (Guest-Hypervisor Communication
> >> > Interface).
> >> >
> >> > The TSM TDI bind/unbind operations are expected to be initiated by a
> >> > running CoCo VM, which already have the legacy assigned device in place.
> >> > The TSM bind operation is to request VMM make all secure configurations
> >> > to support device work as a TDI, and then issue TDISP messages to move
> >> > the TDI to CONFIG_LOCKED or RUN state, waiting for guest's attestation.
> >> >
> >> > Do TSM Unbind before vfio_pci_core_disable(), otherwise will lead
> >> > device to TDISP ERROR state.
> >> >
> >> 
> >> Any reason these need to be a vfio ioctl instead of iommufd ioctl?
> >> For ex: https://lore.kernel.org/all/20250529133757.462088-3-aneesh.kumar@kernel.org/
> >
> > A general reason is, the device driver - VFIO should be aware of the
> > bound state, and some operations break the bound state. VFIO should also
> > know some operations on bound may crash kernel because of platform TSM
> > firmware's enforcement. E.g. zapping MMIO, because private MMIO mapping
> > in secure page tables cannot be unmapped before TDI STOP [1].
> >
> > Specifically, for TDX Connect, the firmware enforces MMIO unmapping in
> > S-EPT would fail if TDI is bound. For AMD there seems also some
> > requirement about this but I need Alexey's confirmation.
> >
> > [1] https://lore.kernel.org/all/aDnXxk46kwrOcl0i@yilunxu-OptiPlex-7050/
> >
> 
> According to the TDISP specification (Section 11.2.6), clearing either
> the Bus Master Enable (BME) or Memory Space Enable (MSE) bits will cause
> the TDI to transition to an error state. To handle this gracefully, it
> seems necessary to unbind the TDI before modifying the BME or MSE bits.

Yes. But now the suggestion is never let VFIO do unbind, instead VFIO
should block these operations when device is bound.

> 
> If I understand correctly, we also need to unmap the Stage-2 mapping due
> to the issue described in commit
> abafbc551fddede3e0a08dee1dcde08fc0eb8476. Are there any additional
> reasons we would want to unmap the Stage-2 mapping for the BAR (as done
> in vfio_pci_zap_and_down_write_memory_lock)?

I think no more reason. 

> 
> Additionally, with TDX, it appears that before unmapping the Stage-2
> mapping for the BAR, we should first unbind the TDI (ie, move it to the
> "unlock" state?) Is this step related Section 11.2.6 of the TDISP spec,
> or is it driven by a different requirement?

No, this is not device side TDISP requirement. It is host side
requirement to fix DMA silent drop issue. TDX enforces CPU S2 PT share
with IOMMU S2 PT (does ARM do the same?), so unmap CPU S2 PT in KVM equals
unmap IOMMU S2 PT.

If we allow IOMMU S2 PT unmapped when TDI is running, host could fool
guest by just unmap some PT entry and suppress the fault event. Guest
thought a DMA writting is successful but it is not and may cause
data integrity issue.

This is not a TDX specific problem, but different vendors has different
mechanisms for this. For TDX, firmware fails the MMIO unmap for S2. For
AMD, will trigger some HW protection called "ASID fence" [1]. Not sure
how ARM handles this?

https://lore.kernel.org/all/aDnXxk46kwrOcl0i@yilunxu-OptiPlex-7050/

Thanks,
Yilun

> 
> -aneesh

