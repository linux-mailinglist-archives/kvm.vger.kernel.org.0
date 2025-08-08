Return-Path: <kvm+bounces-54326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 12E9BB1E8CF
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 15:00:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8B663B9AEF
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 13:00:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32D4F27AC59;
	Fri,  8 Aug 2025 13:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e2Mt3WMB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60ECF221729
	for <kvm@vger.kernel.org>; Fri,  8 Aug 2025 13:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754658040; cv=none; b=MzTNqiYTq+/R9LPERsA6P/qSbE3WRVqEh1snGCxfcl8YvSu9LW3YyPpZup/wuk+OyMK9lGLfVVmP82gLp9QFX1aIlLpvRrgjlyDwRgG3RLNzzBpnU2/VI5ehNTbkaaAL/Jy7F+ypjdxXHcW2kc7EulA8mNAvpIdnvTRrDuQ29ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754658040; c=relaxed/simple;
	bh=ur4VNeXzGQk9qmrEDQ7LtPu2J4y9zaMIA/9t0a37I4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SY6m/UDGnSUE3iI+c9lFG2hTryCdsD94nlpaFqMiIHGN9XhPmXO2pqg/mcGtqx9qpnHXeqZFSW5UzNhmoSxpzmT5UHGItFTs/pC3mw+F/DBLc5Xwa4Ejxu90lzX9PJBPJORIALeM8JqffDggfpgP8QNy6YZf3uprj/D/I+vkWr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e2Mt3WMB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A21C4CEED;
	Fri,  8 Aug 2025 13:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754658040;
	bh=ur4VNeXzGQk9qmrEDQ7LtPu2J4y9zaMIA/9t0a37I4Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e2Mt3WMB2LzmSeJBjcIdzu+cOQ4LT5n3QSAjdXeZmuOIf5An77XTNTUNfZf4LPPbo
	 KD+1jRaNObq6aOQrdr9FbT73oG3pGcuCyuutQ1fE+gugc5mLfca6a5sO2IFY2MWzLo
	 L2VtkxcvpCyGB7TiqsomQ+DEAXfiOZ1G105ROgRS1epDrCVKaAqDKVcpLkIaP44itK
	 z33djFfls93zLQiJdDNp2CgtFv1hJwVeI4K2lx2DeUqbeRen7XLWgycPDlYm8JetA2
	 CzujUY/lSlGQKE8KM6pPzHHsC21HKg+p/HrvuSr0q7DiNNjA7kuB4f0NL30QCd2Q9v
	 g+n74pJ0r9qgw==
Date: Fri, 8 Aug 2025 14:00:35 +0100
From: Will Deacon <will@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, kvm@vger.kernel.org,
	Steven Price <steven.price@arm.com>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [RFC PATCH kvmtool 09/10] vfio/iommufd: Add viommu and vdevice
 objects
Message-ID: <aJX089pd81f6vMCu@willie-the-truck>
References: <20250525074917.150332-1-aneesh.kumar@kernel.org>
 <20250525074917.150332-9-aneesh.kumar@kernel.org>
 <aH4yMUWTuVtgqD7T@willie-the-truck>
 <yq5att31brz2.fsf@kernel.org>
 <f3b39fdc-e063-4d47-95dd-d4158f139053@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3b39fdc-e063-4d47-95dd-d4158f139053@arm.com>

On Mon, Aug 04, 2025 at 11:33:27PM +0100, Suzuki K Poulose wrote:
> On 24/07/2025 15:09, Aneesh Kumar K.V wrote:
> > Will Deacon <will@kernel.org> writes:
> > > On Sun, May 25, 2025 at 01:19:15PM +0530, Aneesh Kumar K.V (Arm) wrote:
> > > > +	dev_num = vdev->dev_hdr.dev_num;
> > > > +	/* kvmtool only do 0 domain, 0 bus and 0 function devices. */
> > > > +	guest_bdf = (0ULL << 32) | (0 << 16) | dev_num << 11 | (0 << 8);
> > > 
> > > I don't understand this. Shouldn't the BDF correspond to the virtual
> > > configuration space? That's not allocated until later, but just going
> > > with 0 isn't going to work.
> > > 
> > > What am I missing?
> > > 
> > 
> > As I understand it, kvmtool supports only bus 0 and does not allow
> > multifunction devices. Based on that, I derived the guest BDF as follows
> > (correcting what was wrong in the original patch):
> > 
> > guest_bdf = (0ULL << 16) | (0 << 8) | dev_num << 3 | (0 << 0);
> > 
> > Are you suggesting that this approach is incorrect, and that we can use
> > a bus number other than 0?
> 
> To put this other way, the emulation of the configuration space is based
> on the "dev_num". i.e., CFG address is converted to the offset and
> mapped to the "dev_num". So I think what we have here is correct.

My point is that 'dev_num' isn't allocated until vfio_pci_setup_device(),
which is called from __iommufd_configure_device() _after_  we've called
iommufd_alloc_s1bypass_hwpt().

So I don't see how this works. You have to allocate the virtual config
space before you can allocate the virtual device with iommufd.

Will

