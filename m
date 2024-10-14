Return-Path: <kvm+bounces-28756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BC6699C955
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 13:50:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E31F41F21C18
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 11:50:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7E9E19DF7A;
	Mon, 14 Oct 2024 11:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="jBd5HThY";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ONse7UCi"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F61F19E7E3
	for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 11:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728906601; cv=none; b=FRhte6SIIMdUwdCp1cANRzR14oBtjGDex3XWSGUfHarI/iDUNuCE+gNig9uk2YDhNlARPtx4Ao+RAfjItNfoJ5H0EwJ7xI652u0P4AXmggjGX4sXIGJSMKg2LnP/JdoEdo1ofVjDNmQlYNBbq4EnUSD1BVFOkzc3LL3UFIend8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728906601; c=relaxed/simple;
	bh=5TB0pSPYP8QnedVlMT+s1vYwVihEgjHtCs0VO6LmVyI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W7+45eMGZ2H1yAp5E8tmCctxanHbfn9nTmUE+pt3B84zOUtvey4xIMJZ3Q2YgcbFBbsxx522bD23MXT+mJrDPFdduby/YjfKH7eAkv8k+HvqVpBsWvXysOQZFuHpa50tQHPPWZtUtPXrn3JyMs4STLuHuyfISb0t1ttfyNGyTSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=jBd5HThY; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ONse7UCi; arc=none smtp.client-ip=202.12.124.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Received: from phl-compute-09.internal (phl-compute-09.phl.internal [10.202.2.49])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 447042540070;
	Mon, 14 Oct 2024 07:49:57 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Mon, 14 Oct 2024 07:49:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1728906597; x=1728992997; bh=VH6J9qqL+8
	tokCzUFrEcflFU8u0Nez+8Z710tOWUCPg=; b=jBd5HThYUnXGTWo6D6XPU6VvhT
	ezPnauWJKGqBhG14U3nZ7u78Xk3e+Bm1elEQQUCepr2Vum4PgXi3r4id16gVW+9J
	LSXbSuvvlNaCiXHfhJ/v4BGbLuolHC7Q4pithpSgdESOhfXYKunZDKluua6OcGLT
	uRJJple0U/PjgUDTb7nxMzB5nPGmWcWQUepv7IP2vKUSGSvocUchwAGktLA6BRiR
	nyc26DjIp9EMqKnY2TxTaQ6+mbcRYrSCoVmGHVzlXbMnEcDKnLi2y8TUl+yD7o8v
	5kh8dIwnv3+UJ5K/8yKOUzivS+orerWg312M9R16xOekT/25B1j8XYvtCaag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1728906597; x=1728992997; bh=VH6J9qqL+8tokCzUFrEcflFU8u0N
	ez+8Z710tOWUCPg=; b=ONse7UCiSbFovJuyUqKgK5ovUHTqsFltajvno2ky1hFu
	X4nU4fORh9O97d7s4Zsl8kjWfAfN6R+WVFNEP+c1xbGDJYPr3LL/wcbx6iJWcQaK
	lfex9iwnu2ITWJeoJZDCFoOAgTF9hNd2a64AVVXEqrnns76HrFHSE0bVIDLS7b/G
	4nK/649Z7DQA40ZkyQEWSfbfSdnL3FcQyGcYiuKKB+o28b0NOWnjeX0VHm7607kM
	Zoug3y3tN9zzBbJdGIU4m0R47P0KL0sXHKKPBXIIZfKb4b3vs8ojL0hAM2QZbf1W
	5mmncG6rLN8nBvB1N9vxl3RoSQBgx5PYF8on3RbbMw==
X-ME-Sender: <xms:ZAUNZ804cUVR9dUczop5yHjCVgZvVJ--yfqeRVWNjHaECJCWbmbGDQ>
    <xme:ZAUNZ3F5L7WBZ4YmW2N7cKIn1PLdpH288SLm3pFuZVktz5FGHhJw7jjpQWI_OFYUK
    fapPPbzgG-aIw>
X-ME-Received: <xmr:ZAUNZ06T3rXY5-OyP15nRN49qVn3tX2dx4dNuTtXcb6HJgUDlyLQsuYLAQUQ6DfPehUamYZnzCpwpxs5vdu8BfePldhuwILDvV3M9A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdeghedggeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvden
    ucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrf
    grthhtvghrnhepheegvdevvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefh
    gfehkeetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmpdhnsggprhgtphhtthhopeefvddpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtohepiihhihifsehnvhhiughirgdrtghomhdprhgtphhtth
    hopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepnhhouhhvvggr
    uheslhhishhtshdrfhhrvggvuggvshhkthhophdrohhrghdprhgtphhtthhopegrlhgvgi
    drfihilhhlihgrmhhsohhnsehrvgguhhgrthdrtghomhdprhgtphhtthhopehkvghvihhn
    rdhtihgrnhesihhnthgvlhdrtghomhdprhgtphhtthhopehjghhgsehnvhhiughirgdrtg
    homhdprhgtphhtthhopegrihhrlhhivggusehgmhgrihhlrdgtohhmpdhrtghpthhtohep
    uggrnhhivghlsehffhiflhhlrdgthhdprhgtphhtthhopegrtghurhhrihgusehnvhhiug
    hirgdrtghomh
X-ME-Proxy: <xmx:ZAUNZ1046ByOb_1RW4CoxcGSCqlIQyoXwGuEK_rKAvsCjEDYqyYl4A>
    <xmx:ZAUNZ_FRg8kdoA418zNlj5cuXPT4vpOMm2A33pSvbl1QEi0eStDJ4Q>
    <xmx:ZAUNZ-8Fm9FAR1ao9Bi97u1SK-2q3t0VejTc7feNkPBS9-v8gErGKQ>
    <xmx:ZAUNZ0nSR7OvxVOwn7gwrBFAgYEJyn8wwaaZEoMfWtJMMm2taIdvVw>
    <xmx:ZQUNZ28_H89rsywTQKR1C3sbepiNfqsNSC88ksGPqYabv2ckg7GuC1T_>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Oct 2024 07:49:56 -0400 (EDT)
Date: Mon, 14 Oct 2024 13:36:18 +0200
From: Greg KH <greg@kroah.com>
To: Zhi Wang <zhiw@nvidia.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	"airlied@gmail.com" <airlied@gmail.com>,
	"daniel@ffwll.ch" <daniel@ffwll.ch>,
	Andy Currid <ACurrid@nvidia.com>, Neo Jia <cjia@nvidia.com>,
	Surath Mitra <smitra@nvidia.com>, Ankit Agrawal <ankita@nvidia.com>,
	Aniket Agashe <aniketa@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	"zhiwang@kernel.org" <zhiwang@kernel.org>
Subject: Re: [RFC 01/29] nvkm/vgpu: introduce NVIDIA vGPU support prelude
Message-ID: <2024101408-splashed-criteria-6b1a@gregkh>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <20240922124951.1946072-2-zhiw@nvidia.com>
 <2024092604-factor-pushpin-99ee@gregkh>
 <bab2ee27-059e-4f9b-a5f8-87cee04630d1@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bab2ee27-059e-4f9b-a5f8-87cee04630d1@nvidia.com>

On Mon, Oct 14, 2024 at 09:59:18AM +0000, Zhi Wang wrote:
> On 26/09/2024 12.20, Greg KH wrote:
> > External email: Use caution opening links or attachments
> > 
> > 
> > On Sun, Sep 22, 2024 at 05:49:23AM -0700, Zhi Wang wrote:
> >> NVIDIA GPU virtualization is a technology that allows multiple virtual
> >> machines (VMs) to share the power of a single GPU, enabling greater
> >> flexibility, efficiency, and cost-effectiveness in data centers and cloud
> >> environments.
> >>
> >> The first step of supporting NVIDIA vGPU in nvkm is to introduce the
> >> necessary vGPU data structures and functions to hook into the
> >> (de)initialization path of nvkm.
> >>
> >> Introduce NVIDIA vGPU data structures and functions hooking into the
> >> the (de)initialization path of nvkm and support the following patches.
> >>
> >> Cc: Neo Jia <cjia@nvidia.com>
> >> Cc: Surath Mitra <smitra@nvidia.com>
> >> Signed-off-by: Zhi Wang <zhiw@nvidia.com>
> > 
> > Some minor comments that are a hint you all aren't running checkpatch on
> > your code...
> > 
> >> --- /dev/null
> >> +++ b/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h
> >> @@ -0,0 +1,17 @@
> >> +/* SPDX-License-Identifier: MIT */
> > 
> > Wait, what?  Why?  Ick.  You all also forgot the copyright line :(
> > 
> 
> Will fix it accordingly.
> 
> Back to the reason, I am trying to follow the majority in the nouveau 
> since this is the change of nouveau.
> 
> What's your guidelines about those already in the code?

My "guidelines" is that your lawyers agree what needs to be done and to
do that.

After that, my opinion is you do the proper thing and follow the kernel
licenses here, ESPECIALLY as you will be talking to gpl-only symbols
(hint, MIT licensed code doesn't make any sense there, and go get your
legal approval if you think it does...)

> >> +static bool support_vgpu_mgr = false;
> > 
> > A global variable for the whole system?  Are you sure that will work
> > well over time?  Why isn't this a per-device thing?
> > 
> >> +module_param_named(support_vgpu_mgr, support_vgpu_mgr, bool, 0400);
> > 
> > This is not the 1990's, please never add new module parameters, use
> > per-device variables.  And no documentation?  That's not ok either even
> > if you did want to have this.
> 
> Thanks for the comments. I am most collecting people opinion on the 
> means of enabling/disabling the vGPU, via kernel parameter or not is 
> just one of the options. If it is chosen, having a global kernel 
> parameter is not expected to be in the !RFC patch.

That wasn't explained anywhere I noticed, did I miss it?

Please do this properly, again, kernel module parameters is not the
proper way.

> >> +static inline struct pci_dev *nvkm_to_pdev(struct nvkm_device *device)
> >> +{
> >> +     struct nvkm_device_pci *pci = container_of(device, typeof(*pci),
> >> +                                                device);
> >> +
> >> +     return pci->pdev;
> >> +}
> >> +
> >> +/**
> >> + * nvkm_vgpu_mgr_is_supported - check if a platform support vGPU
> >> + * @device: the nvkm_device pointer
> >> + *
> >> + * Returns: true on supported platform which is newer than ADA Lovelace
> >> + * with SRIOV support.
> >> + */
> >> +bool nvkm_vgpu_mgr_is_supported(struct nvkm_device *device)
> >> +{
> >> +     struct pci_dev *pdev = nvkm_to_pdev(device);
> >> +
> >> +     if (!support_vgpu_mgr)
> >> +             return false;
> >> +
> >> +     return device->card_type == AD100 &&  pci_sriov_get_totalvfs(pdev);
> > 
> > checkpatch please.
> > 
> 
> I did before sending it, but it doesn't complain this line.
> 
> My command line
> $ scripts/checkpatch.pl [this patch]

Then something is odd as that '  ' should have been caught.

> > And "AD100" is an odd #define, as you know.
> 
> I agree and people commented about it in the internal review. But it is 
> from the nouveau driver and it has been used in many other places in 
> nouveau driver. What would be your guidelines in this situation?

Something properly namespaced?

> >> +/**
> >> + * nvkm_vgpu_mgr_init - Initialize the vGPU manager support
> >> + * @device: the nvkm_device pointer
> >> + *
> >> + * Returns: 0 on success, -ENODEV on platforms that are not supported.
> >> + */
> >> +int nvkm_vgpu_mgr_init(struct nvkm_device *device)
> >> +{
> >> +     struct nvkm_vgpu_mgr *vgpu_mgr = &device->vgpu_mgr;
> >> +
> >> +     if (!nvkm_vgpu_mgr_is_supported(device))
> >> +             return -ENODEV;
> >> +
> >> +     vgpu_mgr->nvkm_dev = device;
> >> +     vgpu_mgr->enabled = true;
> >> +
> >> +     pci_info(nvkm_to_pdev(device),
> >> +              "NVIDIA vGPU mananger support is enabled.\n");
> > 
> > When drivers work properly, they are quiet.
> >
> 
> I totally understand this rule that driver should be quiet. But this is 
> not the same as "driver is loaded". This is a feature reporting like 
> many others

And again, those "many others" need to be quiet too, we have many ways
to properly gather system information, and the kernel boot log is not
that.

> My concern is as nouveau is a kernel driver, when a user mets a kernel 
> panic and offers a dmesg to analyze, it would be at least nice to know 
> if the vGPU feature is turned on or not. Sysfs is doable, but it helps 
> in different scenarios.

A kernel panic is usually way way way after this initial boot time
message.  Again, keep the boot fast, and quiet please.

thanks,

greg k-h

