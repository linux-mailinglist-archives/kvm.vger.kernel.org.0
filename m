Return-Path: <kvm+bounces-64677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E5B7C8AB41
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 16:40:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 859C134ECB0
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 15:40:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DCAB33A016;
	Wed, 26 Nov 2025 15:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="IGzLePBW";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="WX5AmDMi"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA0830F53B;
	Wed, 26 Nov 2025 15:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764171631; cv=none; b=YJawQgkH13jHr/rtQcITEPtVHpzkvA8qty4d3FZT8d4kYNgu+QrSj5jOjFBZuNDcDeq0/UaFdMXyS25HVBhchxiu+bQdCGevG+m/W/hqy1NZvkjhczlFnGoPJ7GEW6j2AvRT3HroX1zj3NmupQ+f5glZxgMDpExX+su1aTjQF+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764171631; c=relaxed/simple;
	bh=uA2yLzOCUKtSE6cp7GuVgmRgv0ZqGNBxvscHXc9Uxs4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JszU8KTemKVQ1kLNJ7WE+h1YzBvbTYCJrmhQoIZYgm03wQixazx++EOL39kFTcdzagyhRPCSdl57tr2T42hV1bWnqTdZGzEM7CyxBXt9GTVA4+GGjkzdz7ZsnFbh8WhngCT3UEclJpfQlbYWegfdqYa8aQrheN0vcqwdXoXMzH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=IGzLePBW; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=WX5AmDMi; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 2928414001FA;
	Wed, 26 Nov 2025 10:40:27 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Wed, 26 Nov 2025 10:40:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1764171627;
	 x=1764258027; bh=j8H6BE/mt4Q5DzO9R2uk9Mx3M08YNaiarQ6u7tGcrnA=; b=
	IGzLePBW0zd07K3IIjaxXdywNrcCAlly/DixIiFkLk3K7BfApgpmRBzJC8koF/vB
	3AJ+9Pyu2sqnxqFo2GZAW1Rtr/L7YjMUab3DgIhpo2kXXxm9OweCGQCCVCh7c/KT
	XVJGZmwtNIXDx6W6/niOD7Z2f7b1GWVlk6BdEGOysBmvJsCwNFfXl4GkXQcHJRqj
	BaWc7828+xBEeZfb+GbbEs5hrc8XMmE5sNVuXZNwR1BoWTIqRRa9VRVYvFkwNm1N
	4ykHV77oYtTaV3Xp3aw4YktTh1a8XQMkcGRJkxXBH5ys2VTVmx63WI/cklw5lPAT
	uN09bIS56LahdELZplfe+g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1764171627; x=
	1764258027; bh=j8H6BE/mt4Q5DzO9R2uk9Mx3M08YNaiarQ6u7tGcrnA=; b=W
	X5AmDMifsEM8W/QezAN5uzj6cWYqGbfaq9ihRQ5CN5Ej61g9eymlq6khjSM8/SWg
	tZJeAp/rNagQN8Ir7VHIJ4N7kkjAgVF6vbCUOPIrg6clLzvVBE1L6o1yakZvgQV0
	jOPYaNoCE1SCHu+FRJ3/AunVmI5R65Zgv0EQ+TuAOEQdc/nx0QMf+dWEGuoz/Rlm
	rZ6Q+/rpnyuqImBZUYX4RlKE7a5Nw780gIgLLZN7U2b7AU+of8rBcSZyZdunMr2i
	PbRVm3MYKgI/RoCVP54TAzTCeD2hv2n9fURrTe6CKV4EO1HIX0uee0ef6DbeoOIs
	2Ecb+3YgxHesCcLHLvDHg==
X-ME-Sender: <xms:aR8nafdCe95_hmcsyv9G9lnpiBo1UrB1EC-Fqusq3x4orG4_pXs9Tg>
    <xme:aR8naVo0xoFU0a_QNQBvnB84tPHssyj5uozunslECEr8l_a1yqWKK9EHP37apuxf3
    fw7ZswYMJBDUkhZiwavZHncNvooxiSprT69eRKpKjH6qCwtucu->
X-ME-Received: <xmr:aR8nad9pI3gQSUythgXzTGZneOfZCoqitRlp2H5qBSy_ZEgRCbce5Skt>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvgeegjedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthhqredttddtjeenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhepgffggfegffffhffhhefftdeikedtueefkefghfehledtkedvvddtieehveej
    fffgnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrlhgvgiesshhhrgiisghothdrohhrghdp
    nhgspghrtghpthhtohepvddupdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehmih
    gthhgrlhdrfihinhhirghrshhkihesihhnthgvlhdrtghomhdprhgtphhtthhopehthhho
    mhgrshdrhhgvlhhlshhtrhhomheslhhinhhugidrihhnthgvlhdrtghomhdprhgtphhtth
    hopehmrghtthhhvgifrdgsrhhoshhtsehinhhtvghlrdgtohhmpdhrtghpthhtoheplhhu
    tggrshdruggvmhgrrhgthhhisehinhhtvghlrdgtohhmpdhrtghpthhtoheprhhoughrih
    hgohdrvhhivhhisehinhhtvghlrdgtohhmpdhrtghpthhtohepjhhgghesiihivghpvgdr
    tggrpdhrtghpthhtohephihishhhrghihhesnhhvihguihgrrdgtohhmpdhrtghpthhtoh
    epkhgvvhhinhdrthhirghnsehinhhtvghlrdgtohhmpdhrtghpthhtohepshhkohhlohht
    hhhumhhthhhosehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:aR8nae7E_gnYeEsp9TOtFtmNZ3cmKciY5M9qSALORYPDu4QdZrfUYA>
    <xmx:aR8nafglhw287NcdCItRsudbE6ORgNGk7yvuhsyL1r2mfLp9ACexfg>
    <xmx:aR8nadoBEVUCUnSx7xp5pxxKb8eUlaBE-JKTewbT9LkMHUE8eD4bVg>
    <xmx:aR8naTKLoacGbQLoO78fiJktYq5T-yVAzowUmX9b8JCgwYlwanV9GQ>
    <xmx:ax8naUSQMLkt1zzlNthcDvhVX-1gRfAdg1FJ4OVuonPp3UkB7D9IN-4b>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Nov 2025 10:40:24 -0500 (EST)
Date: Wed, 26 Nov 2025 08:40:23 -0700
From: Alex Williamson <alex@shazbot.org>
To: =?UTF-8?B?TWljaGHFgg==?= Winiarski <michal.winiarski@intel.com>
Cc: Thomas =?UTF-8?B?SGVsbHN0csO2bQ==?= <thomas.hellstrom@linux.intel.com>,
 Matthew Brost <matthew.brost@intel.com>, Lucas De Marchi
 <lucas.demarchi@intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Jason
 Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Kevin Tian
 <kevin.tian@intel.com>, Shameer Kolothum <skolothumtho@nvidia.com>,
 <intel-xe@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
 <kvm@vger.kernel.org>, Michal Wajdeczko <michal.wajdeczko@intel.com>,
 <dri-devel@lists.freedesktop.org>, Jani Nikula
 <jani.nikula@linux.intel.com>, Joonas Lahtinen
 <joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, "Lukasz
 Laguna" <lukasz.laguna@intel.com>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 0/4] vfio/xe: Add driver variant for Xe VF migration
Message-ID: <20251126084023.705ebca1.alex@shazbot.org>
In-Reply-To: <nsiqp2nv73cegxwmnqkxw66zfy4efl4k3zxidt23ljyry3u7b5@buufaqzja7sb>
References: <20251124230841.613894-1-michal.winiarski@intel.com>
	<20251125131315.60aa0614.alex@shazbot.org>
	<aSZVybx3cgPw6HQh@lstrano-desk.jf.intel.com>
	<c5f1344daeec43e5b5d9e6536c8c8b8a13323f7a.camel@linux.intel.com>
	<nsiqp2nv73cegxwmnqkxw66zfy4efl4k3zxidt23ljyry3u7b5@buufaqzja7sb>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Nov 2025 15:46:43 +0100
Micha=C5=82 Winiarski <michal.winiarski@intel.com> wrote:

> On Wed, Nov 26, 2025 at 12:38:34PM +0100, Thomas Hellstr=C3=B6m wrote:
> > On Tue, 2025-11-25 at 17:20 -0800, Matthew Brost wrote: =20
> > > On Tue, Nov 25, 2025 at 01:13:15PM -0700, Alex Williamson wrote: =20
> > > > On Tue, 25 Nov 2025 00:08:37 +0100
> > > > Micha=C5=82 Winiarski <michal.winiarski@intel.com> wrote:
> > > >  =20
> > > > > Hi,
> > > > >=20
> > > > > We're now at v6, thanks for all the review feedback.
> > > > >=20
> > > > > First 24 patches are now already merged through drm-tip tree, and
> > > > > I hope
> > > > > we can get the remaining ones through the VFIO tree. =20
> > > >=20
> > > > Are all those dependencies in a topic branch somewhere?=C2=A0 Other=
wise
> > > > to
> > > > go in through vfio would mean we need to rebase our next branch
> > > > after
> > > > drm is merged.=C2=A0 LPC is happening during this merge window, so =
we
> > > > may
> > > > not be able to achieve that leniency in ordering.=C2=A0 Is the bett=
er
> > > > approach to get acks on the variant driver and funnel the whole
> > > > thing
> > > > through the drm tree?=C2=A0 Thanks, =20
> > >=20
> > > +1 on merging through drm if VFIO maintainers are ok with this. I've
> > > done this for various drm external changes in the past with
> > > maintainers
> > > acks.
> > >=20
> > > Matt =20
> >=20
> > @Michal Winiarski
> >=20
> > Are these patches depending on any other VFIO changes that are queued
> > for 6.19?  =20
>=20
> No, there's a series that I'm working on in parallel:
> https://lore.kernel.org/lkml/20251120123647.3522082-1-michal.winiarski@in=
tel.com/
>=20
> Which will potentially change the VFIO driver that's part of this
> series.
> But I believe that this could go through fixes, after we have all the
> pieces in place as part of 6.19-rc release.

6.19-rc or 6.19+1, depends on to what extent we decide the other
variant drivers have this same problem.  This driver has worked around
it in the traditional way though and I don't think it needs to be
delayed for a universal helper.

> > If not and with proper VFIO acks, I could ask Dave / Sima to allow this
> > for drm-xe-next-fixes pull. Then I also would need a strong
> > justification for it being in 6.19 rather in 7.0.
> >=20
> > Otherwise we'd need to have the VFIO changes it depends on in a topic
> > branch, or target this for 7.0 and hold off the merge until we can
> > backmerge 6.9-rc1. =20
>=20
> Unless Alex has a different opinion, I think the justification would be
> that this is just a matter of logistics - merging through DRM would just
> be a simpler process than merging through VFIO. End result would be the
> same.

Yes, the result is the same, logistics of waiting for the drm-next
merge, rebasing, and sending a 2nd vfio pull request is the overhead.
The easier route through drm still depends on getting full acks on this
and whether drm will take it.  Thanks,

Alex

