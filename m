Return-Path: <kvm+bounces-68542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F859D3B8A7
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 21:40:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 373E0302F91F
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 20:39:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BC1B2F6574;
	Mon, 19 Jan 2026 20:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="Cd1jzcLw";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Kb0Ld9oV"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859212F0C78;
	Mon, 19 Jan 2026 20:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768855186; cv=none; b=NIUi5MwTdX7W66F8IfJdys8TImmjbtEera/R3HSUsHVtV0Hx7CoesgfEderiGh0EKg0dk2Sk2b5H3riLgCGY+iUqSsDu7UnN3HA83yKfx81H/9teTe1RNFaBb99ShiLxCzWWhaMaIkRMfy7qBHCdt8xxvXv7WK4uzCtX0OQYXvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768855186; c=relaxed/simple;
	bh=rp4s91TcQNT/Im3eCCEY3IqbumZ7+YnVNOzqepi46rs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mHQTVvKrBdKwd8Un73Eo4DNZ++lPKTr/hPa1tF04QmTEc6dCWo6UhDFoiqoJs/rcD3uy4Bhdaq1gBc2V4bYmr5cUQXzajDnq2VUKFx8l34Awt3BYQtCWMD3nk0lXxMT8XAhirc2pPrsWZkN7UX91DGb+sykFU9wlcxr1Jozyo5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=Cd1jzcLw; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Kb0Ld9oV; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id BBC81EC00D2;
	Mon, 19 Jan 2026 15:39:43 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Mon, 19 Jan 2026 15:39:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1768855183;
	 x=1768941583; bh=UBFgguEuXiAHVZI06QHGYrq2GluVufoWEpXqZX/5BGw=; b=
	Cd1jzcLwauvaWODb3MNLsIt3bGPpRu8WF0tEav7iVgnDSxJerMHdrhZi1N6LTDhA
	MsmBGNi9cpjP6EafG6D5/gnKadl3tjiRaPmw6gZVTv7ar4erOOVbGr2EEcT7clNS
	rvY5/TLOp7cdbac1S9eW52Djsw7MD5cdx1YgTRLQ+2FB6KvKCZKMORC02PP8ygf5
	T+Gm1NZxKBoW1i+cJCvYk+GBeHZRpj6SYK+sX3fZlociK9SVNXrOZCXnLdHACjIG
	WeST+8hDEWRVd1b9KJ5kqriJVmVPaAY6lab/hrFp5+AV5R13FIZzeFamfcG3CLz1
	5vpV6689riyT+51FHhv18Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1768855183; x=
	1768941583; bh=UBFgguEuXiAHVZI06QHGYrq2GluVufoWEpXqZX/5BGw=; b=K
	b0Ld9oV9fmzNNJMwWM4Q1L8cTWI1esUrKqF8PAMOgSjIfHGOHhweIlZiR2FPI1Q9
	MCN/FvYo9Ry+u8N9qg3sQgHQgMvrqH4JVPKrcE+YuRWF7Vr3M7j0TM+3EE21DgEE
	/QuAa2jdLLERIEA0uj3Ug9RfnOI5x9CJ5QeemBEwvbB2jrC+VXXdyQTxO9YwI/TF
	JenGVZjiBNXsh35hNOAD7fyoltPoJsTKhj47QwRceFV7cZwo4yvPRlfT6G/HWnCJ
	0nnXq4TE0m5wqUr3hjfxuA7viH983cVAEOo2nJ16dE1IWYAgyD4ud1z7NLgRSaZR
	kHjeE3/tzzNxzTAdamDEg==
X-ME-Sender: <xms:j5ZuaXYJUNrcG1rQtT-PfoFgRKp-j_yvHK1mNRL9vvAdsskJVI-D_Q>
    <xme:j5Zuad_a7T9c7zWxhvAxMjvjp5HUotOzXFKJKBIaSQ7ih4tIb1NwxVSbt8yLQqow-
    4EdwvDD0FdeDnwfgNwcSoB4PwvXd_lN8NOk-35KR5llVEsBGhx7WA>
X-ME-Received: <xmr:j5ZuaZmVKS2NeRw48sYVE4sFqNxgIp5nTcHE2zgqvxQQ2ig1f9v2-_Kfp_c>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddufeekheegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfgjfhfogggtgfesthejre
    dtredtvdenucfhrhhomheptehlvgigucghihhllhhirghmshhonhcuoegrlhgvgiesshhh
    rgiisghothdrohhrgheqnecuggftrfgrthhtvghrnhepkeehjeeitefffeeuieetjedtje
    ffvdelledvuedvffdvfeetgefhveekuedvfedvnecuffhomhgrihhnpehkvghrnhgvlhdr
    ohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepudeipdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopegrnhhkihhtrgesnhhvihguihgrrdgtohhmpdhrtg
    hpthhtohepvhhsvghthhhisehnvhhiughirgdrtghomhdprhgtphhtthhopehjghhgsehn
    vhhiughirgdrtghomhdprhgtphhtthhopehmohgthhhssehnvhhiughirgdrtghomhdprh
    gtphhtthhopehjghhgseiiihgvphgvrdgtrgdprhgtphhtthhopehskhholhhothhhuhhm
    thhhohesnhhvihguihgrrdgtohhmpdhrtghpthhtoheplhhinhhmihgrohhhvgeshhhurg
    ifvghirdgtohhmpdhrtghpthhtohepnhgrohdrhhhorhhighhutghhihesghhmrghilhdr
    tghomhdprhgtphhtthhopegtjhhirgesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:j5ZuaaaH2-EYtGccQOU5pCexBS3btzV5-lo1KS4RXPOXb4adVCUI4g>
    <xmx:j5ZuaZNtsXvaGJFPVMMee9RjL5jrvF_RRvNyAGjwc20ITC9RhYFsnQ>
    <xmx:j5Zuaaf3B3COk8iQhvdI7qxgIu3hjTNaS4yD7PcXnezl7rI44g0sxw>
    <xmx:j5ZuafGX1HESnLYPUSKpweccZugsneCmqoGGdpCEd9KwzbqK3dPYEA>
    <xmx:j5ZuaYFTv_0-XeoJCgj-mm3XuFt9-A1a2at6kUn8uaSyckgHFdt8EjPf>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Jan 2026 15:39:42 -0500 (EST)
Date: Mon, 19 Jan 2026 13:38:05 -0700
From: Alex Williamson <alex@shazbot.org>
To: <ankita@nvidia.com>
Cc: <vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
 <jgg@ziepe.ca>, <skolothumtho@nvidia.com>, <linmiaohe@huawei.com>,
 <nao.horiguchi@gmail.com>, <cjia@nvidia.com>, <zhiw@nvidia.com>,
 <kjaju@nvidia.com>, <yishaih@nvidia.com>, <kevin.tian@intel.com>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH v2 0/2] Register device memory for poison handling
Message-ID: <20260119133805.49fa7b8d@shazbot.org>
In-Reply-To: <20260115202849.2921-1-ankita@nvidia.com>
References: <20260115202849.2921-1-ankita@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 Jan 2026 20:28:47 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Linux MM provides interfaces to allow a driver to [un]register device
> memory not backed by struct page for poison handling through
> memory_failure.
> 
> The device memory on NVIDIA Grace based systems are not added to the
> kernel and are not backed by struct pages. So nvgrace-gpu module
> which manages the device memory can make use of these interfaces to
> get the benefit of poison handling. Make nvgrace-gpu register the device
> memory with the MM on open.
> 
> Moreover, the stubs are added to accommodate for CONFIG_MEMORY_FAILURE
> being disabled.
> 
> Patch 1/2 introduces stubs for CONFIG_MEMORY_FAILURE disabled.
> Patch 2/2 registers the device memory at the time of open instead of mmap.
> 
> Note that this is a reposting of an earlier series [1] which is partly
> (patch 1/3) merged to v6.19-rc4. This one addresses the leftover patching.
> Many thanks to Jason Gunthorpe (jgg@nvidia.com) and Alex Williamson
> (alex@shazbot.org) for valuable suggestions.
> 
> Link: https://lore.kernel.org/all/20251213044708.3610-1-ankita@nvidia.com/ [1]
> 
> Changelog:
> v2:
> - Fixed nit to cleanup nvgrace_gpu_vfio_pci_register_pfn_range
>   (Thanks Jiaqi Yan)
> Link: https://lore.kernel.org/all/20260108153548.7386-1-ankita@nvidia.com/ [v1]
> 
> Ankit Agrawal (2):
>   mm: add stubs for PFNMAP memory failure registration functions
>   vfio/nvgrace-gpu: register device memory for poison handling
> 
>  drivers/vfio/pci/nvgrace-gpu/main.c | 113 +++++++++++++++++++++++++++-
>  include/linux/memory-failure.h      |  13 +++-
>  2 files changed, 120 insertions(+), 6 deletions(-)
> 

Applied to vfio next branch for v6.20/7.0.  Thanks,

Alex

