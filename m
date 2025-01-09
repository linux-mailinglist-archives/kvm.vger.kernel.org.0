Return-Path: <kvm+bounces-34897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 403B3A07176
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 10:28:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C6DC3A69EC
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 09:28:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F76E2153E0;
	Thu,  9 Jan 2025 09:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XxSyn6Ok"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EBA21507F;
	Thu,  9 Jan 2025 09:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736414909; cv=none; b=RXHK+d5fXMTuLPEyT2B8k2JirmeamU81KoWPgMp1/a/1fsc0nXWHwtfGwgU8maVxy6ovlraqoe1uXvSdXtzcFNxtRIU2KIDVHNP41ZPPr18q4aj1auN5qSwQguXAVfiG5l8xk+9VCUM6KgFdmy5J1gXZGXnhnFD0qpewSXKVpD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736414909; c=relaxed/simple;
	bh=cm/GOqwwiMkALA/fEFsX5hEEy5V6SjOqxswcdV/STbM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QHPeDzZLgTrT2B51v5SkyfeOKejyWbvJqma+6O86jYv8srn6Q3L8U0IDYsLP9YC7wrHlKVy1J1rzE6P4uEhFBN3KNJudNfPkUwFGorYjTX8Ey+4Btj/5yTJQlIoivG9ioA3USAyC0JPbrrmJpvXYZlfgIuyypCh0J6VTmx/6M4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XxSyn6Ok; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807A9C4CED2;
	Thu,  9 Jan 2025 09:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736414908;
	bh=cm/GOqwwiMkALA/fEFsX5hEEy5V6SjOqxswcdV/STbM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XxSyn6OkLmGCUGT46Xejk0oVc9wYD6k8fTUvHOcwReKi7cu6apM1Vv1rk43TPDSbX
	 7sksEqWG8naX3qZ+x3+Ac6FeG0lmDUVJPikfxBnc5gug7Hx8qjQxIgvULeiBnFWXuj
	 SM8vT7SquKvEx0eHIPKAsmANxGan3rbJGW9vVoaVZqc3tkai/PWNcix/6rQRChz9Nb
	 2KoIvEiL7LeXPhq2jWy/Yhkp7s+tJ3Ly3EX1EZxh9Cs3SAjKPyzxFcQ05qLBYB3Y2W
	 yr50Zso/lxP8NEHsbimRm8FzQti0ZSbgPIyYUmWNhduiWnACP6D+kuhmH+FRBFL4ZS
	 onQxs8GNPbFsw==
Date: Thu, 9 Jan 2025 11:28:23 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Christoph Hellwig <hch@lst.de>,
	Xu Yilun <yilun.xu@linux.intel.com>, kvm@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	vivek.kasireddy@intel.com, dan.j.williams@intel.com, aik@amd.com,
	yilun.xu@intel.com, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch, baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com, tao1.su@intel.com
Subject: Re: [RFC PATCH 01/12] dma-buf: Introduce dma_buf_get_pfn_unlocked()
 kAPI
Message-ID: <20250109092823.GI87447@unreal>
References: <20250107142719.179636-1-yilun.xu@linux.intel.com>
 <20250107142719.179636-2-yilun.xu@linux.intel.com>
 <b1f3c179-31a9-4592-a35b-b96d2e8e8261@amd.com>
 <20250108132358.GP5556@nvidia.com>
 <f3748173-2bbc-43fa-b62e-72e778999764@amd.com>
 <20250108145843.GR5556@nvidia.com>
 <5a858e00-6fea-4a7a-93be-f23b66e00835@amd.com>
 <20250108162227.GT5556@nvidia.com>
 <0e7f92bd-7da3-4328-9081-0957b3d155ca@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0e7f92bd-7da3-4328-9081-0957b3d155ca@amd.com>

On Thu, Jan 09, 2025 at 10:10:01AM +0100, Christian König wrote:
> Am 08.01.25 um 17:22 schrieb Jason Gunthorpe:
> > [SNIP]
> > > > For P2P cases we are going toward (PFN + P2P source information) as
> > > > input to the DMA API. The additional "P2P source information" provides
> > > > a good way for co-operating drivers to represent private address
> > > > spaces as well. Both importer and exporter can have full understanding
> > > > what is being mapped and do the correct things, safely.
> > > I can say from experience that this is clearly not going to work for all use
> > > cases.
> > > 
> > > It would mean that we have to pull a massive amount of driver specific
> > > functionality into the DMA API.
> > That isn't what I mean. There are two distinct parts, the means to
> > describe the source (PFN + P2P source information) that is compatible
> > with the DMA API, and the DMA API itself that works with a few general
> > P2P source information types.
> > 
> > Private source information would be detected by co-operating drivers
> > and go down driver private paths. It would be rejected by other
> > drivers. This broadly follows how the new API is working.
> > 
> > So here I mean you can use the same PFN + Source API between importer
> > and exporter and the importer can simply detect the special source and
> > do the private stuff. It is not shifting things under the DMA API, it
> > is building along side it using compatible design approaches. You
> > would match the source information, cast it to a driver structure, do
> > whatever driver math is needed to compute the local DMA address and
> > then write it to the device. Nothing is hard or "not going to work"
> > here.
> 
> Well to be honest that sounds like an absolutely horrible design.
> 
> You are moving all responsibilities for inter driver handling into the
> drivers themselves without any supervision by the core OS.
> 
> Drivers are notoriously buggy and should absolutely not do things like that
> on their own.

IMHO, you and Jason give different meaning to word "driver" in this
discussion. It is upto to the subsystems to decide how to provide new
API to the end drivers. Worth to read this LWN article first.

Dancing the DMA two-step - https://lwn.net/Articles/997563/

> 
> Do you have pointers to this new API?

Latest version is here - https://lore.kernel.org/all/cover.1734436840.git.leon@kernel.org/
Unfortunately, I forgot to copy/paste cover letter but it can be seen in
previous version https://lore.kernel.org/all/cover.1733398913.git.leon@kernel.org/.

The most complex example is block layer implementation which hides DMA API from
block drivers. https://lore.kernel.org/all/cover.1730037261.git.leon@kernel.org/

Thanks

