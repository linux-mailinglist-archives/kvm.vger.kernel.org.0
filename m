Return-Path: <kvm+bounces-60231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CB7F0BE5A1D
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 00:01:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 81A954F9FEA
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 22:01:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FF7D2E6106;
	Thu, 16 Oct 2025 22:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="HdWq+6GC";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="OePscQGj"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671972DFA48;
	Thu, 16 Oct 2025 22:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760652107; cv=none; b=OmMYFBuur1+dPH6BWoy+40QHJ9UQwC4EqPAYn/CqmQffcxuNwwY+CfoqnJ05+0edJ9ajh09c8rQuAwV8847rlhhcKitsCkr7fdAl+O5MPD7weIPMaQq63ps9Lovr6FfVtrRDRReaNci1kTQdYIqzwde2umu2UXSRcfaDniC1s30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760652107; c=relaxed/simple;
	bh=TVWwG6C+CUNW26rEtsWK44upOeWoXwozc5BcwDmIdi8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gsJ0Pv2gBV+HtequsI3wWrtfocCQtvWnM6BIjCmxlcFy98hfNbUn1TH+3oLNLTSNGjQRxJkaDbv3n4YkCNQmf35DCUZJgCgvbuI3W2RzTxhk2nTU8RJTgqRKNQBgMeHhhSJrOUghs9SY4ZtGYZaTHnZ6uhkOmqF1+58Wza8ZED8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=HdWq+6GC; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=OePscQGj; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id 475D01D0005C;
	Thu, 16 Oct 2025 18:01:43 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Thu, 16 Oct 2025 18:01:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1760652103;
	 x=1760738503; bh=4uiZ9WYAYVcK3QbHeOV3S54ojJ1TPQb+P5ityLpARDg=; b=
	HdWq+6GCq9H67XQMbIbLF5/1scrM5vp/Hiw1hV+BA48b58c/XMicdB1iyEDaEGzH
	i9j8gFN7CXYBuKjIssvexGD8BEykh9AwlpCCB3sgcN3b9P3RmAp9D7Pgbs4wmOxV
	/7x8KUD6v4p13DxE0khZECHIbbEuXmSlwaiceGWCeNDOEz5ztU0NrT2o/XaZCt5N
	ZeNu5KatsNxnVoMrn/kfdP/lQCJe+Yf9wL6hcPzvVgQL6Yeyp6j9GtlUGDkx+OEV
	foyqb4u9UU/99N2NmeAuS3juQovtsCegRLMIH071ovKIp4iba7B4WEGVj6zSEAJg
	Ty3MJtmZgudeJhSymEARTg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1760652103; x=
	1760738503; bh=4uiZ9WYAYVcK3QbHeOV3S54ojJ1TPQb+P5ityLpARDg=; b=O
	ePscQGjKn4KSW0Xwfq7TiJvTWhKsSRPCq9+ljfbXgRDFaVxmZ8vCEUyX1vljm7m5
	Xz3PAEPul9uLO5akq1QRK4gLrf4To3UjBbFHGNfM1GbKh08xULJsHfJdhuwR1aOA
	eK5wWYwmfSbtXb7ZisqWTEAjOEDSLaHE5E5e2QiVPY44hcHUvtBYXHg0gVpuP9pP
	AUgvudpIA5DrKwbQas6yy+biFT9KBZN6ykg86Wd1oYZfZJ3j9SZgOCbDZdjwfiLz
	IlLl1GQngGNz8t6EwA5aXk57pG5JJ5O0efxJIXq/WLioma6jXS8zA5PaxIMJoHlQ
	Fs9iXW1kUZtZHcMzllbbQ==
X-ME-Sender: <xms:RmvxaJoRPgEYtxAUfuPa38vNIY-liYkpPtFjT_bZ62DX7C-i92yzig>
    <xme:RmvxaNIE15aacbJff0A4yCm1Ntf-74ccEW-r4ni9hqkVmrD8pN0kdzQcaDOb0leV-
    VGBp-ugKOVe0CKpwqnWFlLoYNMOCkFNOUHch0KPwegFHR-oV_Xx6Q>
X-ME-Received: <xmr:RmvxaGR2jyr1wD0Tn11MMgWIOx8Vn8qsRL7oMskPR737a_8m-yB27D8l5TI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduvdejgeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthejredttddtvdenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhepteehueetledtveduueffvefgieegieeuueekvdehtdekvdejgfeihfekuedt
    kedvnecuffhomhgrihhnpehgihhthhhusgdrtghomhenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrlhgvgiesshhhrgiisghothdrohhrghdp
    nhgspghrtghpthhtohephedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghmrg
    hsthhrohesfhgsrdgtohhmpdhrtghpthhtoheprghlvghjrghnughrohdrjhdrjhhimhgv
    nhgviiesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepjhhgghesiihivghpvgdrtggrpd
    hrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehl
    ihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:RmvxaEuan-PAOT7V8cd9HGCb5rEVLIf_oPFVrCD6fAqg-uSmDQIGog>
    <xmx:RmvxaPZb8exl43z7Wr3Wae5nJhwvctlr8MKOOpa6vJcqTrW1g-ts-g>
    <xmx:RmvxaCFtnM1jYQfIDRyQKMHMH3ZUIyStOX3EMVIQTLFES9FCxWNhsw>
    <xmx:RmvxaLx31ZYtZOAXf0y-QDHFR_6pI8_pKlJN6Hj_Xd0xpVsfs7tDYw>
    <xmx:R2vxaJ-7XQrNDyXOr0peLgeW8gEALGNtEZPTMRvO85eEIy-B25zRJWZp>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 16 Oct 2025 18:01:41 -0400 (EDT)
Date: Thu, 16 Oct 2025 16:01:38 -0600
From: Alex Williamson <alex@shazbot.org>
To: Alex Mastro <amastro@fb.com>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/3] vfio: handle DMA map/unmap up to the addressable
 limit
Message-ID: <20251016160138.374c8cfb@shazbot.org>
In-Reply-To: <aPFheZru+U+C4jT7@devgpu015.cco6.facebook.com>
References: <20251012-fix-unmap-v4-0-9eefc90ed14c@fb.com>
	<20251015132452.321477fa@shazbot.org>
	<3308406e-2e64-4d53-8bcc-bac84575c1d9@oracle.com>
	<aPFheZru+U+C4jT7@devgpu015.cco6.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 16 Oct 2025 14:19:53 -0700
Alex Mastro <amastro@fb.com> wrote:

> On Wed, Oct 15, 2025 at 05:25:14PM -0400, Alejandro Jimenez wrote:
> > 
> > 
> > On 10/15/25 3:24 PM, Alex Williamson wrote:  
> > > On Sun, 12 Oct 2025 22:32:23 -0700
> > > Alex Mastro <amastro@fb.com> wrote:
> > >   
> > > > This patch series aims to fix vfio_iommu_type.c to support
> > > > VFIO_IOMMU_MAP_DMA and VFIO_IOMMU_UNMAP_DMA operations targeting IOVA
> > > > ranges which lie against the addressable limit. i.e. ranges where
> > > > iova_start + iova_size would overflow to exactly zero.  
> > > 
> > > The series looks good to me and passes my testing.  Any further reviews
> > > from anyone?  I think we should make this v6.18-rc material.  Thanks,
> > >   
> > 
> > I haven't had a chance yet to closely review the latest patchset versions,
> > but I did test this v4 and confirmed that it solves the issue of not being
> > able to unmap an IOVA range extending up to the address space boundary. I
> > verified both with the simplified test case at:
> > https://gist.github.com/aljimenezb/f3338c9c2eda9b0a7bf5f76b40354db8
> > 
> > plus using QEMU's amd-iommu and a guest with iommu.passthrough=0
> > iommu.forcedac=1 (which is how I first found the problem).
> > 
> > So Alex Mastro, please feel free to add:
> > 
> > Tested-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
> > 
> > for the series. I'll try to find time to review the patches in detail.
> > 
> > Thank you,
> > Alejandro
> >   
> > > Alex  
> >   
> 
> Thanks all. I would like additional scrutiny around vfio_iommu_replay. It was
> the one block of affected code I have not been able to test, since I don't have
> / am not sure how to simulate a setup which can cause mappings to be replayed
> on a newly added IOMMU domain. My confidence in that code is from close review
> only.
> 
> I explicitly tested various combinations of the following with mappings up to
> the addressable limit:
> - VFIO_IOMMU_MAP_DMA
> - VFIO_IOMMU_UNMAP_DMA range-based, and VFIO_DMA_UNMAP_FLAG_ALL
> - VFIO_IOMMU_DIRTY_PAGES with VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP
> 
> My understanding is that my changes to vfio_iommu_replay would be traversed
> when binding a group to a container with existing mappings where the group's
> IOMMU domain is not already one of the domains in the container.

I really appreciate you making note of it if you're uneasy about the
change.  I'll take a closer look there and hopefully others can as
well.

The legacy vfio container represents a single IOMMU context, which is
typically managed by a single domain.  The replay comes into play when
groups are under IOMMUs with different properties that prevent us from
re-using the domain.  The case that most comes to mind for this is
Intel platforms with integrated graphics where there's a separate IOMMU
for the GPU, which iirc has different coherency settings.

That mechanism for triggering replay requires a specific hardware
configuration, but we can easily trigger it through code
instrumentation, ex:

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 5167bec14e36..2cb19ddbb524 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2368,7 +2368,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
                    d->enforce_cache_coherency ==
                            domain->enforce_cache_coherency) {
                        iommu_detach_group(domain->domain, group->iommu_group);
-                       if (!iommu_attach_group(d->domain,
+                       if (0 && !iommu_attach_group(d->domain,
                                                group->iommu_group)) {
                                list_add(&group->next, &d->group_list);
                                iommu_domain_free(domain->domain);

We might consider whether it's useful for testing purposes to expose a
mechanism to toggle this.  For a unit test, if we create a container,
add a group, and build up some suspect mappings, if we then add another
group to the container with the above bypass we should trigger the
replay.

In general though the replay shouldn't have a mechanism to trigger
overflows, we're simply iterating the current set of mappings that have
already been validated and applying them to a new domain.

In any case, we can all take a second look at the changes there.
Thanks,

Alex

