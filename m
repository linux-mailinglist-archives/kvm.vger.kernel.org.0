Return-Path: <kvm+bounces-64949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E8B57C930EC
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 20:53:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id BD96D349AE4
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 19:53:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C578C2D248D;
	Fri, 28 Nov 2025 19:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="tTlVitIK";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="p8UTVkvq"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5D429BD8C;
	Fri, 28 Nov 2025 19:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764359610; cv=none; b=cS8w229MzSoABR/ltrrylSsv36ZByVPHzMlZ7rQe1UZmsf2Tb7S4yc+DDhhFGkB7zIroyLdtST01pRUsWoXZHxGMSuqs5CFHnLz8fA3/o51CsiV3uuzhLqxYmZaIsQFmGSjFPZt4ubpK+WLCWlp+dvEbUsU7fNlM8QD+excZU1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764359610; c=relaxed/simple;
	bh=Ok0lIH1SR+J4sZFtNBBFMTphxWrTCZeUm+TGqp/ibfU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sARV5+3Q5W1IkRPvVfAdZFpAPvAjWuy/TRm7Ne/4UIgsisTWcphSITPxtqjcKsV3DRrMdoUFYOBybLRLyRVcmh+AiYtzOIRx87hiyeg8mvdGhW4SQoXPSq+GEXLWtqZCVdkdRgFW7rp079E4qXmeYM+RacBUxJa9/XfstuLwucA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=tTlVitIK; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=p8UTVkvq; arc=none smtp.client-ip=202.12.124.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 9B2937A0848;
	Fri, 28 Nov 2025 14:53:26 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 28 Nov 2025 14:53:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1764359606;
	 x=1764446006; bh=E/M1A9g+tzfu51whtk6ETtuXS4dKP2Z9OkNprWYeCNY=; b=
	tTlVitIKSELuFlIuIldmN/jM765oWmW/3YvZZKVeyvQMGDBt9V1fHU9TKPaA4Ad7
	qsP8i1xlM73b88dpavbLZpjB3jfXeWYMPE2iykLm0pdytbmi4fIm5YKKJ2Zj0wF1
	gmXvue8pczRsxySanqWNYs7/yVMMB+Qpg4o13P+i0+XYe3UprfG3eJNBonNxsjB0
	q+MAmMQ+7DkTjDnv3ByZ11RoEyz++QzleKxdPAe0B+4gtZQV9ncNcwfe2RHiqdz1
	O749eIZjml6RDJFEP2YJHjIzsmX1VLDvf+tY4VMhuMt07Q/rGj3xOCl6klkXkus+
	MDV2gz08o+xq15T7hxEsuw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1764359606; x=
	1764446006; bh=E/M1A9g+tzfu51whtk6ETtuXS4dKP2Z9OkNprWYeCNY=; b=p
	8UTVkvqc3s8yQa/I/qApMU/3+QEV07IFWmEogPBP8kUdHB45zW825ufQBnotw6WR
	HumlJ5qtUM+In+bGOM+AEH7YK7+Drw/legqKiMtVOkWlHYj2RejBM6we32sz2Q7w
	4fK2DrluT/ICsARZudwAKkL/YcJYR0x0LHgeYPWW92vz1kh7d+9adCFmf07gQsEW
	zCtkS7m3aycIAdRHC3X0nLf7kEos6mrqF7wLQ8U98UsVtS8wkwJHMKC0VWn89NZh
	oszi0kMFeKinwNI++V7mb0flPlQ0L8n0/2SZTl91Kp5UlxWyUksO1WNo4eCu1erg
	pIr5NalyzWckYqbJqe+Zg==
X-ME-Sender: <xms:tP0paYqp8QJDiRMtBbEN7ItLhBsGKMz3Bad_YFeSvoMAb_UhF2k7eA>
    <xme:tP0paU9vLSteN9eZB5YQg9Wemn7aEONJ2qjDkUZCgpjI5eFVw0DtZRI2Rcx9zYEhw
    4x00taHYFzJFwQ3RwB5xigZVQRl1qU9Ikaeip5hFI3CuKngZTXO8Xw>
X-ME-Received: <xmr:tP0paZ61ZWm-vR4A2FBDLEZyT5IY2GeV_cAo5S9LeLwfDS3HUyOnBdfp>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvhedtjeeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthhqredttddtjeenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhepgfffvdefjeejueevfeetudfhgeetfeeuheetfeekjedvuddvueehffdtgeej
    keetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hlvgigsehshhgriigsohhtrdhorhhgpdhnsggprhgtphhtthhopedvuddpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtohepmhhitghhrghlrdifihhnihgrrhhskhhisehinhhtvg
    hlrdgtohhmpdhrtghpthhtoheplhhutggrshdruggvmhgrrhgthhhisehinhhtvghlrdgt
    ohhmpdhrtghpthhtohepthhhohhmrghsrdhhvghllhhsthhrohhmsehlihhnuhigrdhinh
    htvghlrdgtohhmpdhrtghpthhtoheprhhoughrihhgohdrvhhivhhisehinhhtvghlrdgt
    ohhmpdhrtghpthhtohepjhhgghesiihivghpvgdrtggrpdhrtghpthhtohephihishhhrg
    hihhesnhhvihguihgrrdgtohhmpdhrtghpthhtohepkhgvvhhinhdrthhirghnsehinhht
    vghlrdgtohhmpdhrtghpthhtohepshhkohhlohhthhhumhhthhhosehnvhhiughirgdrtg
    homhdprhgtphhtthhopehinhhtvghlqdigvgeslhhishhtshdrfhhrvggvuggvshhkthho
    phdrohhrgh
X-ME-Proxy: <xmx:tP0paejA2arawQL2tW7aJBMgRhoJ3cxaKnM_sMn6sVthAU3MrEh6VA>
    <xmx:tP0paQqasH0lWNj-7AJAwoNtct6Nfyn81YdROwycgrBJIhFnUeTMpg>
    <xmx:tP0paaJ3kEJJRAsl6kuyfx1dclLaa1Hvek7jfXLBFzrQrG9Za8Z-xA>
    <xmx:tP0padsiaK5H7roIkIloK5l1KoqqQdAvSkDRazoByVqIf8fUp7jZuw>
    <xmx:tv0paQmaOVeIca7ACmTx7-urEuW6tun3Ol_1ctTi4f5rnRAdXMHzNYdG>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 28 Nov 2025 14:53:23 -0500 (EST)
Date: Fri, 28 Nov 2025 12:53:22 -0700
From: Alex Williamson <alex@shazbot.org>
To: =?UTF-8?B?TWljaGHFgg==?= Winiarski <michal.winiarski@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>, Thomas =?UTF-8?B?SGVsbHN0?=
 =?UTF-8?B?csO2bQ==?= <thomas.hellstrom@linux.intel.com>, Rodrigo Vivi
 <rodrigo.vivi@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas
 <yishaih@nvidia.com>, Kevin Tian <kevin.tian@intel.com>, Shameer Kolothum
 <skolothumtho@nvidia.com>, <intel-xe@lists.freedesktop.org>,
 <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Matthew Brost
 <matthew.brost@intel.com>, "Michal Wajdeczko" <michal.wajdeczko@intel.com>,
 <dri-devel@lists.freedesktop.org>, Jani Nikula
 <jani.nikula@linux.intel.com>, Joonas Lahtinen
 <joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, "Lukasz
 Laguna" <lukasz.laguna@intel.com>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v7 4/4] vfio/xe: Add device specific vfio_pci driver
 variant for Intel graphics
Message-ID: <20251128125322.34edbeaf.alex@shazbot.org>
In-Reply-To: <20251127093934.1462188-5-michal.winiarski@intel.com>
References: <20251127093934.1462188-1-michal.winiarski@intel.com>
	<20251127093934.1462188-5-michal.winiarski@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 27 Nov 2025 10:39:34 +0100
Micha=C5=82 Winiarski <michal.winiarski@intel.com> wrote:

> In addition to generic VFIO PCI functionality, the driver implements
> VFIO migration uAPI, allowing userspace to enable migration for Intel
> Graphics SR-IOV Virtual Functions.
> The driver binds to VF device and uses API exposed by Xe driver to
> transfer the VF migration data under the control of PF device.
>=20
> Signed-off-by: Micha=C5=82 Winiarski <michal.winiarski@intel.com>
> Acked-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>  MAINTAINERS                  |   7 +
>  drivers/vfio/pci/Kconfig     |   2 +
>  drivers/vfio/pci/Makefile    |   2 +
>  drivers/vfio/pci/xe/Kconfig  |  12 +
>  drivers/vfio/pci/xe/Makefile |   3 +
>  drivers/vfio/pci/xe/main.c   | 573 +++++++++++++++++++++++++++++++++++
>  6 files changed, 599 insertions(+)
>  create mode 100644 drivers/vfio/pci/xe/Kconfig
>  create mode 100644 drivers/vfio/pci/xe/Makefile
>  create mode 100644 drivers/vfio/pci/xe/main.c

Reviewed-by: Alex Williamson <alex@shazbot.org>

Hopefully this can still go in via the drm window this cycle.  Thanks,

Alex

