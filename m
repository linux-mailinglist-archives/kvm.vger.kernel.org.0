Return-Path: <kvm+bounces-62119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E0040C37C88
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 21:48:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4806D18C6BA5
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 20:49:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 825082D6E53;
	Wed,  5 Nov 2025 20:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="ggyPflQg";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="F9WfphXM"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9298A264630;
	Wed,  5 Nov 2025 20:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762375718; cv=none; b=UI49ocoda1SNY60zmpVGO0HEr2QJb4cjiI4lTyWou/CCgJgpDJJuVCfpqXhSeOUH8Lm3gQ+H7Y78RZpt53vf2FMu2wLYinXtbJRmaI9kGOYzddF7th7emQh4UeDwh+qMBSpF3NMdnD6JwC/utXR3UT/Xhmuf2H24DjBzfuuawHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762375718; c=relaxed/simple;
	bh=XjX2Gu+czV/t+mrHM5omQPaJbXT57OwcqoDhbRZ9AEo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jH/VPG7ZKNmvsedMchGWib9T6lx/21euE9/xYM2pOGADjYHsUZNsJ9Pqvkr/k30EVBC4lZ+PrCWoGLy58Szjt694OoDeW4KXgnaTuDOMfN+4SWePuvmrAJz/wJaouKe3X+txJWHXCM+aRh7j/HABS+2sAe7U9Dc+htZlNit8aIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=ggyPflQg; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=F9WfphXM; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 7DDCA140012B;
	Wed,  5 Nov 2025 15:48:34 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Wed, 05 Nov 2025 15:48:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1762375714;
	 x=1762462114; bh=ohNL1+6zNNmYIdt9oX7AGViWYMx2eZbUzhURanHRVqc=; b=
	ggyPflQgHh6TLSYrPr5qAFAFzbvv/EUJGhXQZWZjIngcQ43LuqyXJoVstaFGVwyO
	8v/2eh8QVzB66hrc9OF4ls1c0jlRa/OaC6c4hFXmdTK65pXhjKYNXNrwvDxhCzLb
	cIhCYO+t1C3CPtuc1rIK/4NdHtSxycUflS+P/I6qOi2HtevQThAbAj23aH+VG8dV
	btV2Od3y1OwYcnbfTx9hIi0982VRVrYeQ5bHkAg/oMeUTOZwHW1U1Gx+NkLZUFBl
	MGaH/NWpVbGreZvA3OJ/qzkofm/LfVW066+8Im87qf8OjWvKeHPlTcBgCNuNHQ6Z
	7Rw4zk2jH0/ZNoAK1C7bLQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762375714; x=
	1762462114; bh=ohNL1+6zNNmYIdt9oX7AGViWYMx2eZbUzhURanHRVqc=; b=F
	9WfphXMWcIW8a8omrOiJRS4vq2bjM0yAjPJ9s0+pgvj+pgr5niiwhnu6oSFnp6ts
	dztx1dQOJYjnrNZST1cEDOqwE/FieKKvMJ+0x42WQztd9rkvYEiChxYrVQbQca4i
	WjpOogdTI2VTz+mg5eFPiss4p1F+WykfHxUILSPHtMIVLfrVt8mRUD3Fk1HyAwH1
	YMg8acFFDVdv6UE23skQpxrCas3yT0p4hXodsq8ObTOHf1OC/EyoK/ua0yRdwMy6
	hde1ERzOPT09iH7tb/PJpbex49Xt/dmkLaZ+lXhfGpTuF++Q4xFVT950A8qRn6RE
	/oXXTTvYOByWlWk7YRAbA==
X-ME-Sender: <xms:IbgLaZP21oYZAefMJOmF5Mm3c7Lv5X9PhAZF1wVTxXzMhOVaG4gDwQ>
    <xme:IbgLaVLkT4Zs-ARkdCFuq-0_ZRGqfRQScGVtd9GnT1mWtasvp7PrwPsmCp8AOteH9
    OeCu0nEjvzTGdVZYmV7iZrUBuzsBMedOWfoU1MxHbAE42ZG39pr>
X-ME-Received: <xmr:IbgLacgVqytAa8Jgc3CefYGptOjO4IlFqkd6YKB13ltqMVAS6QHVTnXs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddukeegledtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthejredttddtvdenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhepteetudelgeekieegudegleeuvdffgeehleeivddtfeektdekkeehffehudet
    hffhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hlvgigsehshhgriigsohhtrdhorhhgpdhnsggprhgtphhtthhopeegtddpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtohepphhrrggrnhesghhoohhglhgvrdgtohhmpdhrtghpth
    htohepjhhgghesnhhvihguihgrrdgtohhmpdhrtghpthhtoheprghgohhruggvvghvsehl
    ihhnuhigrdhisghmrdgtohhmpdhrtghpthhtoheprghirhhlihgvugesghhmrghilhdrtg
    homhdprhgtphhtthhopegrlhgvgidrfihilhhlihgrmhhsohhnsehrvgguhhgrthdrtgho
    mhdprhgtphhtthhopegrnhhkihhtrgesnhhvihguihgrrdgtohhmpdhrtghpthhtohepsg
    horhhnthhrrggvghgvrheslhhinhhugidrihgsmhdrtghomhdprhgtphhtthhopegsrhgv
    thhtrdgtrhgvvghlvgihsegrmhgurdgtohhmpdhrtghpthhtohepughrihdquggvvhgvlh
    eslhhishhtshdrfhhrvggvuggvshhkthhophdrohhrgh
X-ME-Proxy: <xmx:IbgLabf4MeGhfi3gNmowE7mD37sHgNH2WDwF5uz_DRckxmZNEl2TVw>
    <xmx:IbgLac6GnpBjn1Obw1EEsjUzeywMCKsH8b3lTrDAOXZowAalTuV3Ow>
    <xmx:IbgLachtNFumMNL4vC2n74-G33nTJUMKGlJq_2E4NSbPxZ3-5jNX4g>
    <xmx:IbgLabH9DtlfEpWnYK7pUkApvb-syRCS2ZP9nP-8RLj2oglsb2bBzQ>
    <xmx:IrgLaceGyGmekenMqPNiLCD9fPFtA4ot0EGM5UOvgQtmC9TptrzEqdzp>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 5 Nov 2025 15:48:30 -0500 (EST)
Date: Wed, 5 Nov 2025 13:48:29 -0700
From: Alex Williamson <alex@shazbot.org>
To: Pranjal Shrivastava <praan@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 David Airlie <airlied@gmail.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Ankit Agrawal <ankita@nvidia.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Brett Creeley <brett.creeley@amd.com>, dri-devel@lists.freedesktop.org,
 Eric Auger <eric.auger@redhat.com>, Eric Farman <farman@linux.ibm.com>,
 Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 intel-gfx@lists.freedesktop.org,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
 Kirti Wankhede <kwankhede@nvidia.com>, linux-s390@vger.kernel.org,
 Longfang Liu <liulongfang@huawei.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>,
 Nikhil Agarwal <nikhil.agarwal@amd.com>,
 Nipun Gupta <nipun.gupta@amd.com>,
 Peter Oberparleiter <oberpar@linux.ibm.com>,
 Halil Pasic <pasic@linux.ibm.com>, qat-linux@intel.com,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Simona Vetter <simona@ffwll.ch>,
 Shameer Kolothum <skolothumtho@nvidia.com>,
 Mostafa Saleh <smostafa@google.com>, Sven Schnelle <svens@linux.ibm.com>,
 Tvrtko Ursulin <tursulin@ursulin.net>, virtualization@lists.linux.dev,
 Vineeth Vijayan <vneethv@linux.ibm.com>,
 Yishai Hadas <yishaih@nvidia.com>, Zhenyu Wang <zhenyuw.linux@gmail.com>,
 Zhi Wang <zhi.wang.linux@gmail.com>, patches@lists.linux.dev
Subject: Re: [PATCH 14/22] vfio: Require drivers to implement
 get_region_info
Message-ID: <20251105134829.333243dd.alex@shazbot.org>
In-Reply-To: <aQhcOYVbY-LqOjW5@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
	<14-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
	<aQhcOYVbY-LqOjW5@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 3 Nov 2025 07:39:37 +0000
Pranjal Shrivastava <praan@google.com> wrote:

> On Thu, Oct 23, 2025 at 08:09:28PM -0300, Jason Gunthorpe wrote:
> > Remove the fallback through the ioctl callback, no drivers use this now.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/vfio/vfio_main.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > index a390163ce706c4..f056e82ba35075 100644
> > --- a/drivers/vfio/vfio_main.c
> > +++ b/drivers/vfio/vfio_main.c
> > @@ -1297,13 +1297,13 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
> >  		break;
> >  
> >  	case VFIO_DEVICE_GET_REGION_INFO:
> > -		if (!device->ops->get_region_info)
> > -			goto ioctl_fallback;
> > -		ret = device->ops->get_region_info(device, uptr);
> > +		if (unlikely(!device->ops->get_region_info))
> > +			ret = -EINVAL;  

Nit, typically I would have expected a success oriented flow, ie.

		if (likely(device->ops->get_region_info))
			ret = device->ops->get_region_info(device, uptr);
		else
			ret = -EINVAL;

But it goes away in the next patch, so *shrug*.

> 
> Nit: Let's also add a warn/err log here highliting that the device
> doesn't populate the get_region_info op?

Are devices required to implement regions?  If so, it'd be more
appropriate to fail the device registration in __vfio_register_dev()
for the missing op than wait for an ioctl.  However, here in the device
agnostic layer of vfio, I think the answer leans more towards no, we
could theoretically have a device with no regions.  We also want to be
careful not to introduce a WARN_ON that's user trigger'able.  Thanks,

Alex

