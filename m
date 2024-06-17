Return-Path: <kvm+bounces-35357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9203CA101EC
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 09:22:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE0DE1888F44
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 08:22:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D94F25949A;
	Tue, 14 Jan 2025 08:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jE+YwIxA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1192230D15;
	Tue, 14 Jan 2025 08:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736842916; cv=none; b=RnBPZ8pQR35tR/U4HndnpNcnIrnxg4XKkArFOl26m0XtbCjAHYNTvvKu/ub1U4/Sb/+vGWp8YIu4A3tO8NOtZC35EqQhY62de5St93ycV0R8QTIiF3thAf/Qw3Bppv84d269FCOqPZzAZ44Ypr+rnE6Lo5TsrtDv8MHaNdrSfVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736842916; c=relaxed/simple;
	bh=YFJKCb0jqMAhlwNKuT95tl8Htv3gL4ALSvmG3zHbfqM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hXd3qDeOB25dVIW5NPHA6zNDiN5SCBMw8nvsPyvASf38Cp6SsSWK5kxr1NIH7dDTiq8ZmD1fP9GfD/ACaOa2z7aisS+CtvlH5VfXkG23tBQWhDUCJINwrhsmTaeR5EMahQaoKQ29RlOUa7FsT/sSkMgNB/2FeUFutj6cFar+GjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jE+YwIxA; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736842915; x=1768378915;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YFJKCb0jqMAhlwNKuT95tl8Htv3gL4ALSvmG3zHbfqM=;
  b=jE+YwIxA2nOhW+W9BCs4jSJhqopYxRk4B67+LzoVqAGAZH8a/J4J1vRu
   c0mN6CRT8yOcpGfLVty90jA9IW2pbBKaIrkh5ZZY5wKwvu6RnrXvtx0np
   o3lycRhHKOjg7JktovKkjtydHlHdURcNdpfHgwSQEh0aVp+6VThQiS6eS
   ITs2kDSfjXQjGKoB1gLJwMqK3bKmEk9YQ6qhfB0LYxZZzAyupuh+zy+gh
   e/wcO/R1h6tgTVN8Lvtwq2maymOfPuVsAfn8SuSRpN+6vqefDaFOspTp2
   QcjqEKms8bK6NlnWMUVsGUosNQCssMTczyho9FB6GbR+kqlyD165UYxCF
   w==;
X-CSE-ConnectionGUID: BnSZLHJnRRWbIPOHB9XLUw==
X-CSE-MsgGUID: pbJmPwsoSlWp/K5HjV79Mg==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="40893898"
X-IronPort-AV: E=Sophos;i="6.12,313,1728975600"; 
   d="scan'208";a="40893898"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 00:21:54 -0800
X-CSE-ConnectionGUID: 4bgDJI7lSkCxurHBiLu3JA==
X-CSE-MsgGUID: O/PUG0G3R9COCkCPxJ2Amg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="105610990"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa008.jf.intel.com with ESMTP; 14 Jan 2025 00:21:49 -0800
Date: Tue, 18 Jun 2024 07:28:43 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: kvm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	sumit.semwal@linaro.org, christian.koenig@amd.com,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	vivek.kasireddy@intel.com, dan.j.williams@intel.com, aik@amd.com,
	yilun.xu@intel.com, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch, leon@kernel.org, baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com, tao1.su@intel.com
Subject: Re: [RFC PATCH 08/12] vfio/pci: Create host unaccessible dma-buf for
 private device
Message-ID: <ZnDGqww5SLbVD6ET@yilunxu-OptiPlex-7050>
References: <20250107142719.179636-1-yilun.xu@linux.intel.com>
 <20250107142719.179636-9-yilun.xu@linux.intel.com>
 <20250108133026.GQ5556@nvidia.com>
 <Z36ulpCoJAllp4fP@yilunxu-OptiPlex-7050>
 <20250109144051.GX5556@nvidia.com>
 <Z3/7/PQCLi1GE5Ry@yilunxu-OptiPlex-7050>
 <20250110133116.GF5556@nvidia.com>
 <Z4Hp9jvJbhW0cqWY@yilunxu-OptiPlex-7050>
 <20250113164935.GP5556@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250113164935.GP5556@nvidia.com>

On Mon, Jan 13, 2025 at 12:49:35PM -0400, Jason Gunthorpe wrote:
> On Sat, Jan 11, 2025 at 11:48:06AM +0800, Xu Yilun wrote:
> 
> > > > > can be sure what is the correct UAPI. In other words, make the
> > > > > VFIO device into a CC device should also prevent mmaping it and so on.
> > > > 
> > > > My idea is prevent mmaping first, then allow VFIO device into CC dev (TDI).
> > > 
> > > I think you need to start the TDI process much earlier. Some arches
> > > are going to need work to prepare the TDI before the VM is started.
> > 
> > Could you elaborate more on that? AFAICS Intel & AMD are all good on
> > "late bind", but not sure for other architectures.
> 
> I'm not sure about this, the topic has been confused a bit, and people
> often seem to  misunderstand what the full scenario actually is. :\

Yes, it is in early stage and open to discuss.

> 
> What I'm talking abou there is that you will tell the secure world to
> create vPCI function that has the potential to be secure "TDI run"
> down the road. The VM will decide when it reaches the run state. This

Yes.

> is needed so the secure world can prepare anything it needs prior to
> starting the VM.

OK. From Dan's patchset there are some touch point for vendor tsm
drivers to do secure world preparation. e.g. pci_tsm_ops::probe().

Maybe we could move to Dan's thread for discussion.

https://lore.kernel.org/linux-coco/173343739517.1074769.13134786548545925484.stgit@dwillia2-xfh.jf.intel.com/

> Setting up secure vIOMMU emulation, for instance. I

I think this could be done at VM late bind time.

> expect ARM will need this, I'd be surprised if AMD actually doesn't in
> the full scenario with secure viommu.

AFAICS, AMD needs secure viommu.

> 
> It should not be a surprise to the secure world after the VM has
> started that suddenly it learns about a vPCI function that wants to be

With some pre-VM stage touch point, it wouldn't be all of a sudden.

> secure. This should all be pre-arranged as possible before starting

But our current implementation is not to prepare as much as possible,
but only necessary, so most of the secure work for vPCI function is done
at late bind time.

Thank,
Yilun

> the VM, even if alot of steps happen after the VM starts running (or
> maybe don't happen at all).
> 
> Jason

