Return-Path: <kvm+bounces-60102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 787CBBE05AB
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 21:25:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 200E0357A92
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 19:25:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43EFB305E04;
	Wed, 15 Oct 2025 19:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="ex5rRZCZ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="yAu84kNy"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60091D90DF;
	Wed, 15 Oct 2025 19:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760556299; cv=none; b=IeqU/RSmS4z0pgf5jXy6xIDx+asfMu0yZUwDIo0zG5QHq/gRJaEplXT8HmTSObsLp6MshqshvnSyoXI2XHVYVNGYFb43N1tyY2Ke8+ANy0eWymajC8G4m6tMauEfvmVYR7XGnVPBDVURnhQKLs7LFNKvAaii2XSCU2proef6Btc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760556299; c=relaxed/simple;
	bh=Kp4pFhy8LP/ccyl0CNzovO3vHn7aphLruSOnZEUv+f0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dPeBKKZfJWYZ17p9KNEN7ZpH0UorpAFu5QiTExhOWL+eyyayOveHh5PXrRkAo/z2kZUbBLcAn6yEoglU3NUnBIp3tQykf0czIQyvFrIMKsAw3Y/6yimNVVRuO2hZO3+yO+yWNkF+dze0G60T+gTcSpKXwklFPbrBVUZMYr8eRnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=ex5rRZCZ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=yAu84kNy; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 84BE7EC022C;
	Wed, 15 Oct 2025 15:24:55 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Wed, 15 Oct 2025 15:24:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1760556295;
	 x=1760642695; bh=iGgB56Om/VOunCl4kKKV9RFWUYYlnHmOzS6O4BpdIx0=; b=
	ex5rRZCZZU+AIIR+jMqLtWjJy29Naz5UydliFn8EUOaE86tZYmavGk3l7SLxWapm
	rTKs9qCxhp2RmESqx1AYx4e5N3fQMjKjeYqCrpW0SKlexs4t9CDaCDhoIb8Cr00c
	iBcKZwIDdkwCUeD0eQ35VIwwt8C4unbK0+LWaJCBX3bobG5nAlsZDgOf9kyUcAIr
	SNmVjm7OixdIVD1qXrUoK3BJF6F3LBQTPKe+OCITLpcVrMV5OiSX+rXHe/nffEVv
	yDay+Ukf8BuaB1n3ENjzq5DQ1fzwa0Yi8TOi5cmDnmZ8oNC0w3w8HY4c8gxnuFiZ
	q5ltap0MYD93OAbSYM0D1g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1760556295; x=
	1760642695; bh=iGgB56Om/VOunCl4kKKV9RFWUYYlnHmOzS6O4BpdIx0=; b=y
	Au84kNyRhiUlS+vPlV2gt7zAVedR1RPWu0SHZl2IYOgdS/n0l+PqZ1VDAj9dppO2
	VKOR4mf1xAEDdxYCFDizcnhBzyZQBSHsbF8zV1q09xpeQaEjb7S6GVW+3cI6I9NG
	pP1xEOBCMwHg5hig6EbyoPOWKf7Wt/rIcNaK4Nk/aVz3Ad/1srugud3sgPd0qh0t
	DBsEDW8tj/APKMJ++OPljr6aYDm2OAEGTVrv3CyLjU9XNE+jNU3w6ceItqBRzGic
	E5gZ0IHjWQRig4HbKkxWShRNWAL3u04QCZFiQqu03HtGNUwx1QYdhVsS7PrnKXw9
	GL5IelO+BnCgnr0d7sg0Q==
X-ME-Sender: <xms:B_XvaHfd8oUXSb2ljKd-TqwVSfnqL_jEDydMM29VojSDKz83MgGLKg>
    <xme:B_XvaOtfthyXfbnO1d4IWWu7KWkVoIU-zQQtt5jk2TWAFHrkfE9ynsa-jnIVQuBzq
    bZLbgDILrq8k4M-xUcCs9UALpuARKKN0wvc-miqTcRQ8wHp38AvTw>
X-ME-Received: <xmr:B_XvaAm2jX8UVXAbN0Ng-hrTnW8oK4lEn4uD9B1Ux-aqfGMdf0bLqgO7XIw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduvdegvdegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthejredttddtvdenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhepteetudelgeekieegudegleeuvdffgeehleeivddtfeektdekkeehffehudet
    hffhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hlvgigsehshhgriigsohhtrdhorhhgpdhnsggprhgtphhtthhopeehpdhmohguvgepshhm
    thhpohhuthdprhgtphhtthhopegrmhgrshhtrhhosehfsgdrtghomhdprhgtphhtthhope
    hjghhgseiiihgvphgvrdgtrgdprhgtphhtthhopegrlhgvjhgrnhgurhhordhjrdhjihhm
    vghnvgiisehorhgrtghlvgdrtghomhdprhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrh
    hnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgv
    rhhnvghlrdhorhhg
X-ME-Proxy: <xmx:B_XvaIzxKkNDoGe7GQRqo8wovKbfgELwDVv240ZD4oifWnGcvScpaQ>
    <xmx:B_XvaKPolZl5XYvOIrKgnPlOS9X5-W9r2Nlp2ZT1GDH7f28k1CKVmw>
    <xmx:B_XvaMrAi9sUYLK6KH0eKKsoZUD6dKUgkwPkPAUW9m5b19tY5TsDww>
    <xmx:B_XvaLHssThqa7_XSMOfAqkPMEnLERt9ImsUr6NvyZ3AiCD0MQfWUA>
    <xmx:B_XvaHDbdfEPltY9P4f-mLDq_rFOK8AP8y8pzCzlfSvt3Fm_55aafMMg>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Oct 2025 15:24:54 -0400 (EDT)
Date: Wed, 15 Oct 2025 13:24:52 -0600
From: Alex Williamson <alex@shazbot.org>
To: Alex Mastro <amastro@fb.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Alejandro Jimenez
 <alejandro.j.jimenez@oracle.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/3] vfio: handle DMA map/unmap up to the addressable
 limit
Message-ID: <20251015132452.321477fa@shazbot.org>
In-Reply-To: <20251012-fix-unmap-v4-0-9eefc90ed14c@fb.com>
References: <20251012-fix-unmap-v4-0-9eefc90ed14c@fb.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 12 Oct 2025 22:32:23 -0700
Alex Mastro <amastro@fb.com> wrote:

> This patch series aims to fix vfio_iommu_type.c to support 
> VFIO_IOMMU_MAP_DMA and VFIO_IOMMU_UNMAP_DMA operations targeting IOVA
> ranges which lie against the addressable limit. i.e. ranges where
> iova_start + iova_size would overflow to exactly zero.

The series looks good to me and passes my testing.  Any further reviews
from anyone?  I think we should make this v6.18-rc material.  Thanks,

Alex

