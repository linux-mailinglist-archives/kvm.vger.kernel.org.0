Return-Path: <kvm+bounces-62133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 07939C381DB
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 22:54:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 049FB4E9EE0
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 21:54:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1444B2E0406;
	Wed,  5 Nov 2025 21:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="XKidI/CF";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="QnflL+mD"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD0E2749C9
	for <kvm@vger.kernel.org>; Wed,  5 Nov 2025 21:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762379667; cv=none; b=NgmAUF6jO8NumdJfA9BX+7e8B440+E14PfVGyX5RLV6AygkHWc2aK6EUTh1NuE8nZXPMbri2E1pp170BJ1bbAg9JDijHGivunUAsyC4J/Kj3ccKNZQJO+f6JYQ4gYctNSkeutOyi7YgUTdMNmzcjDU5ruxOJHfnO7czrPhO6LD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762379667; c=relaxed/simple;
	bh=nZAfXaxS4TbxTxhV2EwyP8b6xf2akeBu8OX20MmVURA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a26nER2uI7tyyzaWF4g/CUP/EN+6/+cddjw9En1eW9tunsAKXTFkQGpOw74WH3GP+n5/bRnkH7jYAHNFQ6PfN/wl+9qiLAw1qThVLaN1YFKOH1trvYlND/R7WfutY2jqw4ackL5eSNd4dOYjtvk0slXhjxsKJh2DC+IwDufB9sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=XKidI/CF; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=QnflL+mD; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id ACE71EC0177;
	Wed,  5 Nov 2025 16:54:23 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 05 Nov 2025 16:54:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1762379663;
	 x=1762466063; bh=LdWr9dQGcsKLWFPrabrYdojVTQ/5NNNUNnJM/kPysAQ=; b=
	XKidI/CF8vGR0aszq/yEcCtL2TtpIde6ChPngNoRYEQaYYjyQQy2dPBw2tJrhtkr
	75ZoY45WuAYgiil/w4lEwxFDpg3vfMUKMRJRwGalg3eYAWhtNSdsExNOdouqbbGV
	KFYBF/FCmcJX3ILn1ab88P7QHcGATsln4rTX6+Y96mRvf5/g1yuWpio2txv37RLf
	ztYQqSeH7tN0T6uiwXc4Z/oUrh49HCA9WC+fggO2ilxIeANA14TNiwwz/ZdXhf7p
	uTZUPUpy6jlY/hHHz13On6q2NAyVA4HU1ecdFukh9o/sGz9DAngorHio+YCoxdnh
	c+u2Danphn8wg4QErIyidw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762379663; x=
	1762466063; bh=LdWr9dQGcsKLWFPrabrYdojVTQ/5NNNUNnJM/kPysAQ=; b=Q
	nflL+mDZG5q5MvxAXc4EFvskDiSpyuS3+s6cHyH04yOt9g8hi6d7jSi2/YpD9wBI
	bsWKkV9kzJFAmvn1UH0CAsj1Dc4PwVL5h7EtYH/Gtx6xQqCM6fG+90FiK49uJlJE
	63229rLMO5NZO0n2Z3+9ow1lZ9Oe2Pc+V+GYGGyv2KE5RyJth1IlHHrBmbAEhdsR
	owRb+b4dTW4pry+peLuDfAoZ7CBXFmmr6dbbYlAvmtElxoPy1/BI5Bh4HbCtt68l
	20B4hJqvKeIdyxkH/ydti3l21ozbuVGlqoqdNZI9GB0f5XmhuRAbfNxd56Kc5j9i
	1MFJTjS/GY4ejWonAP/OQ==
X-ME-Sender: <xms:j8cLaWVY88SCaUTievezswgl7sts0G0yhjSILdgLYDRtZ-qj3X2Q6g>
    <xme:j8cLaWSilIdH_ETW__a2Or0NcBPe3jB236uibUmPTONNngMpDKCi_WuX_R2t-iMRI
    X_UQ2c2GW5z4tg-zj_V25K77316yR8dKuJ3VLrN0_lGLRv9Sgc36A>
X-ME-Received: <xmr:j8cLaUNXIvnL2-0EjD3xJSPSzt7nvuADN83cTde4qxbNc3dviWwGReeL>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddukeehtdefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthhqredttddtjeenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhepgffggfegffffhffhhefftdeikedtueefkefghfehledtkedvvddtieehveej
    fffgnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrlhgvgiesshhhrgiisghothdrohhrghdp
    nhgspghrtghpthhtohepiedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepughmrg
    htlhgrtghksehgohhoghhlvgdrtghomhdprhgtphhtthhopegrlhgvgidrfihilhhlihgr
    mhhsohhnsehrvgguhhgrthdrtghomhdprhgtphhtthhopehjghhgsehnvhhiughirgdrtg
    homhdprhgtphhtthhopehjrhhhihhlkhgvsehgohhoghhlvgdrtghomhdprhgtphhtthho
    pehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepvhhiphhinhhshh
    esghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:j8cLaUTJtl2FUwknhpxTZgoUBehZ8MyExuMPPftV79hvaSxsEUEWIg>
    <xmx:j8cLaSiZzAi13wnnxMfnyLNYTfE0naC5umzKbeNlJLNOYK6u66QUTw>
    <xmx:j8cLad9ExwA-9PR3vguY8YcvoMDD7xp_Oouj7RbpyA-u4gcPu0xQQQ>
    <xmx:j8cLaZEjVUrBVoRqis9DKgC5lKOsPG4mwSTFcCpUpoGbOujmtx-yNw>
    <xmx:j8cLab50MCbqGJ-QI10JhlrYkwHc0WF3-ZrKb3PIQ1UYqsmCSzcqNbHQ>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 5 Nov 2025 16:54:22 -0500 (EST)
Date: Wed, 5 Nov 2025 14:54:21 -0700
From: Alex Williamson <alex@shazbot.org>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe
 <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org,
 Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH 00/12] vfio: selftests: Support for multi-device tests
Message-ID: <20251105145421.216ae95c.alex@shazbot.org>
In-Reply-To: <CALzav=cMyD=SOUnpy3XnFn5cmn7xb8_YnTJHFyfCgqNpECCQsA@mail.gmail.com>
References: <20251008232531.1152035-1-dmatlack@google.com>
	<20251105120634.3aca5a6b.alex@shazbot.org>
	<CALzav=cMyD=SOUnpy3XnFn5cmn7xb8_YnTJHFyfCgqNpECCQsA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 5 Nov 2025 13:03:51 -0800
David Matlack <dmatlack@google.com> wrote:

> On Wed, Nov 5, 2025 at 11:06=E2=80=AFAM Alex Williamson <alex@shazbot.org=
> wrote:
> >
> > On Wed,  8 Oct 2025 23:25:19 +0000
> > David Matlack <dmatlack@google.com> wrote:
> > =20
> > > This series adds support for tests that use multiple devices, and adds
> > > one new test, vfio_pci_device_init_perf_test, which measures parallel
> > > device initialization time to demonstrate the improvement from commit
> > > e908f58b6beb ("vfio/pci: Separate SR-IOV VF dev_set").
> > >
> > > This series also breaks apart the monolithic vfio_util.h and
> > > vfio_pci_device.c into separate files, to account for all the new cod=
e.
> > > This required some code motion so the diffstat looks large. The final
> > > layout is more granular and provides a better separation of the IOMMU
> > > code from the device code. =20
> >
> > Hi David,
> >
> > This series doesn't apply to mainline currently and I see you have some
> > self-comments that suggests this is still a WIP, so I'll drop it and
> > look for a v2. =20
>=20
> Yes, I am going to send a v2 to address my self-comments. I'm also
> looking at getting reviews of this series from some fellow Googlers on
> the mailing list. Feel free to hold off for now.
>=20
> >  I believe
> > https://lore.kernel.org/kvm/20250912222525.2515416-2-dmatlack@google.co=
m/
> > is still in play though and does apply.  Thanks, =20
>=20
> This series will need another revision as well to address Sean's
> feedback, and I think can be merged via KVM maintainers.
>=20
> That being said,
> https://lore.kernel.org/kvm/20250922224857.2528737-1-dmatlack@google.com/
> should apply and be ready to merge. It is a small prep patch for the
> KVM selftests integration.

Oops, yes, that's the one I meant to reference.  It links to the prior
one and I grabbed the wrong link from my local branch.  Thanks for the
confirmation.

Alex

