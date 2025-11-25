Return-Path: <kvm+bounces-64557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 517D6C86F78
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 21:13:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70EC33A9BB4
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 20:13:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3B6333B6CF;
	Tue, 25 Nov 2025 20:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="xWis5iHp";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="1WgIpRu1"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B9F337BBA;
	Tue, 25 Nov 2025 20:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764101602; cv=none; b=kN/IBd6BmLYTLvexaL+OCS+FDKHPRk+sqOI9LjLo+SD5VXp+oKDEBCaWkL32lbPLmGuUu+ppeeiDvcdFog/Dkom7W90hQGeg+60DYmOC9OBRbG7/pArVLt+7nXW5d1iTywV+f/4p62u/+/oVbW6jQH86FFUXM0qdkjCD4bWPJmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764101602; c=relaxed/simple;
	bh=0/0UeQJCjp5D+uIegEC7K0ZffE+WC5C90+EK6JYsel0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZyWCNRp51SvU+pkNPe9h4ib66NhM3b6qSRCZTJ8/6rD0Dack5PIaXPT1qpELw629EdloFzoUXKd7mMtlxeRU8g0FqVmNHFkP6ExzAYlMl83I3+mD9Is4WE8y/ik3T35xAd4rDK7DSKWQXS2nig+kHtsESbkeDwWd7JMCwjkUX1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=xWis5iHp; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=1WgIpRu1; arc=none smtp.client-ip=202.12.124.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 2A1031D00189;
	Tue, 25 Nov 2025 15:13:19 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Tue, 25 Nov 2025 15:13:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1764101599;
	 x=1764187999; bh=SxBzS6wxsA9DU/wrcG08wVM8JozAfkjt6DeecCIzneM=; b=
	xWis5iHprTUKC6s7veQqbuYlIsiGvFjWVZ/ncVbfj/kEkDoww2qZjckaxKdbwpOS
	fJRcWTDv/zBudS40kGTvSd7x2/gZ/xexrNsAkXxFdo+nsGjq4gTOKB0QXnasYV97
	KQ3FiUxLCBHaVWzEsKDy5SX9O71Ripd+BRcZq+LSd/KyMRO1CVzlQMqh3ejJBI2j
	kdFl1MVvdcsVY5bcVdv6FUQVuhjs57ua/i0HBNFKzKYVjSWcff34g03pk9xgo/Th
	uxPY+4qrqoLputQtxu0IR86JR2wGtwVODJONsralwcG3OCC1gWZhKAt0PSXKKyJ+
	pbu/60K6xj5Xnyft5SiFZg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1764101599; x=
	1764187999; bh=SxBzS6wxsA9DU/wrcG08wVM8JozAfkjt6DeecCIzneM=; b=1
	WgIpRu17/CGPtlIdUy5fftZ7tplpJ7JytkmZ0175np73ki83mNji1nkOmaVQP+i/
	MtLu9DcVIQwD3WN0oH3l1OI4HEfpW2LkXXrIKw/SpdjTRAMgTksrLE4szPcl0SrQ
	GfqVBLipASmJSoUf6MZP2B0H5KwZLfofSyqlQSknfeydOHo0D1aqi9DaN/g2mfx3
	jlk9bSa9PVTYEn4QAtlZCcHWbbtcawYoe/VNnnTjFS5dbyEXaIe6VRw5akFBaLHZ
	iaEkZ/DHhDZR23lYDwo4ff9PDRQrTnbvlOyixGydJghiWVBkRlagzS38UarJ7fst
	zNlV9lelt5k8TfuJ6gzyw==
X-ME-Sender: <xms:3g0maU4fw47TisN_W1o-i0kLbHCfFWmgWwZl119Xd_VUeRCgimeoSA>
    <xme:3g0maWUvibJsF9iLcfpVi_kCe3pIqp6oBhVHaQPvHibCiwcmrI22GCDmMTJK43fT4
    t7wDh7aHnVp-njdglEsjLMCttZ1_86gh8Bv7Q_zExRbSNSn4EClMw>
X-ME-Received: <xmr:3g0maY4v2GCi9oMzl_tFJBzLqOX479SoH2_CMpqhpEpk7O_VckukHBsR>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvgedvgedtucetufdoteggodetrf
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
X-ME-Proxy: <xmx:3g0maXEq5ofT8QQr-mpV7rNXW5VqYmxVP4fkg7679KM-n_JTajGtfA>
    <xmx:3g0mab8QBb2EtiqGTSLfZwISvRnUQ02VfvHCwF-kAJ92_zKQPG8dNg>
    <xmx:3g0maZXCEDDKqaKX8nE4kgcUnJsB-NLGwyLZhx7gF4F-iC0jL2V6UQ>
    <xmx:3g0madGcEoSKfZhKbIyhL-h0o8oF61rz0tNxfGnca9R8VxPJt9BJEA>
    <xmx:3w0maVfPtYIDUbwzNoblR8K0XZ7sAGHjEdm_at5Nr0TOmVOgjRGwo6za>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 25 Nov 2025 15:13:16 -0500 (EST)
Date: Tue, 25 Nov 2025 13:13:15 -0700
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
Subject: Re: [PATCH v6 0/4] vfio/xe: Add driver variant for Xe VF migration
Message-ID: <20251125131315.60aa0614.alex@shazbot.org>
In-Reply-To: <20251124230841.613894-1-michal.winiarski@intel.com>
References: <20251124230841.613894-1-michal.winiarski@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 25 Nov 2025 00:08:37 +0100
Micha=C5=82 Winiarski <michal.winiarski@intel.com> wrote:

> Hi,
>=20
> We're now at v6, thanks for all the review feedback.
>=20
> First 24 patches are now already merged through drm-tip tree, and I hope
> we can get the remaining ones through the VFIO tree.

Are all those dependencies in a topic branch somewhere?  Otherwise to
go in through vfio would mean we need to rebase our next branch after
drm is merged.  LPC is happening during this merge window, so we may
not be able to achieve that leniency in ordering.  Is the better
approach to get acks on the variant driver and funnel the whole thing
through the drm tree?  Thanks,

Alex

