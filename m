Return-Path: <kvm+bounces-36215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 46C40A18B07
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 05:33:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F966188C786
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 04:33:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F83D170A0B;
	Wed, 22 Jan 2025 04:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OobqpQfg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD91B2F22;
	Wed, 22 Jan 2025 04:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737520392; cv=none; b=ZBsEhNOUwLMNxlll7IhOF+MY0ueVjgAEewJqZks0HdAX/2B/7UJctQLehWMJ89witak/7U6/dkph+nndTUXVaeHMi+XqNLZqVEhp9kaau/dajxCBM4ozUlgSGLufkOOsGnszoUWdG3fBQARXdQN1G6Gf6+RD19aV1eGN20a1zf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737520392; c=relaxed/simple;
	bh=LxHnnR6mSHv1FRrCXMjIa+c5dsH7Ux6YqKwi2h9qwRk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AqKTXx8/gUHyBKYUKIhqQS9fz/bhe/BuNmgWZQQTiQlDu2uharQqtj8J5w/uqmsCbTeYSbgJvd4SvMHyi/1ABUMXye93dbEJonRlXjH88j1rsjqlYlKFiOCAkEM6CvxpCGbXco4YUjX5qtwqlhltCC9l+my+lgblvpO9ovhD9YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OobqpQfg; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737520390; x=1769056390;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LxHnnR6mSHv1FRrCXMjIa+c5dsH7Ux6YqKwi2h9qwRk=;
  b=OobqpQfgxoUyjJB5pxMXpXHKMCkHe/8Lqg5gPG3JzuN35J+PmSH2Xnub
   lTKYk3IzMLUZ4dFDQSVwqoUQGSMZGSySDWsY0cFlrVNC+8SxH2C1KFXQP
   /r7cvlXKC9QyjSy0IwtfSX+QLKPpK9wXK6kKV3NzAy/x0dhrAs1d+ZQAa
   b5qRWFT/UJRllSh8/VHsB5Eh1r7yqYzSlTz7RF2P7YPWi9EzRdU3Ggqfn
   wfJC1zpEvrcjbYE/HWNNWm0V9LeNRRbK3gVhbNpX+3EaR9eyBcPTTF/XQ
   CSUw1ghidsULg6yVHJV7IuLePi3qPJqKI7EVqdrsm6/gWjMPlMmlzHUd8
   Q==;
X-CSE-ConnectionGUID: k0AfoBBGRaWLtRut9FmwPg==
X-CSE-MsgGUID: 69t5RnRYS9WmqvkRBhS3uA==
X-IronPort-AV: E=McAfee;i="6700,10204,11322"; a="63317721"
X-IronPort-AV: E=Sophos;i="6.13,224,1732608000"; 
   d="scan'208";a="63317721"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2025 20:33:09 -0800
X-CSE-ConnectionGUID: GiiRJr4GRHis2kjxkPmIjg==
X-CSE-MsgGUID: YdGhyQHZTjSzt2/SOh01zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,224,1732608000"; 
   d="scan'208";a="106928561"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa007.fm.intel.com with ESMTP; 21 Jan 2025 20:33:05 -0800
Date: Wed, 22 Jan 2025 12:32:56 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Baolu Lu <baolu.lu@linux.intel.com>, Alexey Kardashevskiy <aik@amd.com>,
	kvm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	sumit.semwal@linaro.org, christian.koenig@amd.com,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	vivek.kasireddy@intel.com, dan.j.williams@intel.com,
	yilun.xu@intel.com, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch, leon@kernel.org, zhenzhong.duan@intel.com,
	tao1.su@intel.com
Subject: Re: [RFC PATCH 08/12] vfio/pci: Create host unaccessible dma-buf for
 private device
Message-ID: <Z5B0+OcLWsiHLRIA@yilunxu-OptiPlex-7050>
References: <ZnDGqww5SLbVD6ET@yilunxu-OptiPlex-7050>
 <20250114133553.GB5556@nvidia.com>
 <17cd9b77-4620-4883-9a6a-8d1cab822c88@amd.com>
 <20250115130102.GM5556@nvidia.com>
 <f1ac048f-64b1-4343-ab86-ad98c24a44f5@linux.intel.com>
 <20250117132523.GA5556@nvidia.com>
 <Znh+uTMe/wX2RIJm@yilunxu-OptiPlex-7050>
 <20250120132525.GH5556@nvidia.com>
 <ZnnhKtA2n4s1CLyf@yilunxu-OptiPlex-7050>
 <20250121174303.GV5556@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250121174303.GV5556@nvidia.com>

On Tue, Jan 21, 2025 at 01:43:03PM -0400, Jason Gunthorpe wrote:
> On Tue, Jun 25, 2024 at 05:12:10AM +0800, Xu Yilun wrote:
> 
> > When VFIO works as a TEE user in VM, it means an attester (e.g. PCI
> > subsystem) has already moved the device to RUN state. So VFIO & DPDK
> > are all TEE users, no need to manipulate TDISP state between them.
> > AFAICS, this is the most preferred TIO usage in CoCo-VM.
> 
> No, unfortunately. Part of the motivation to have the devices be
> unlocked when the VM starts is because there is an expectation that a
> driver in the VM will need to do untrusted operations to boot up the

I assume these operations are device specific.

> device before it can be switched to the run state.
> 
> So any vfio use case needs to imagine that VFIO starts with an
> untrusted device, does stuff to it, then pushes everything through to

I have concern that VFIO has to do device specific stuff. Our current
expectation is a specific device driver deals with the untrusted
operations, then user writes a 'bind' device sysfs node which detaches
the driver for untrusted, do the attestation and accept, and try match
the driver for trusted (e.g. VFIO).

Thanks,
Yilun

> run. The exact mirror as what a kernel driver should be able to do.
> 
> How exactly all this very complex stuff works, I have no idea, but
> this is what I've understood is the target. :\
> 
> Jason

