Return-Path: <kvm+bounces-61262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC7EAC12A6E
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 03:19:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1B3A3AB588
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 02:17:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5414223D291;
	Tue, 28 Oct 2025 02:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="ECGS85me";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="XM2xZzIx"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3FA23185D;
	Tue, 28 Oct 2025 02:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761617837; cv=none; b=hCTfxmTADNiod7XTy0zJ9on7ct14W+cGcQeOJaVUQ3k25isuru3XIaN1mGv7dDIPVaqZC5L9hSknpgyoBcOJuseYDqEyzdaVzEtWvXZ37zGD5sywL/3j8txCkOx7MwYX/xKYat4pxhS8OqAlUXig/9+0XAFoO2cbRpgvkgm7gBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761617837; c=relaxed/simple;
	bh=1YjmE2ecglQFqCri2IKUwNIAwJKetSmtlnaYwJm4OhE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YYIg88R/SoDf5YVj559Y3+vNHTwOn1Me6gA9Gby/mHud+pR/njlKVQ29jrm2W9DTZrydainkCE5c40KSAHyuiDRAEhqlVfjqyUhWRNSDQyGynI17JIvrJWNZregtsLPi024qaNGL9GagkVwCTt/Iyw5qoJNUldqbz5taRGKMd34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=ECGS85me; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=XM2xZzIx; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id DD2D5EC0452;
	Mon, 27 Oct 2025 22:17:13 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 27 Oct 2025 22:17:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1761617833;
	 x=1761704233; bh=7YbNRixEWi4PKn88O3ejOZxwF3GldVBmeOtlnBdESxU=; b=
	ECGS85metNzCUo6KeQtW0zjnm2b0zGjOlSS1eC7bapEDAFqC9YV6rU1BGKCWbVt0
	vVP5h1MeaDThT6dqYVwHN+0YPzOHmgIE8cWlsDW8RRWnXT2KnUF1mV5e/Fgq+Umz
	T9qbvLFEGHHsMFNhlwwAj+i4MY1vM8fgZNmVWlexOzsj7i4B/CEL0aZgAHeX6G9J
	D2l0jLgamEBJNf4q6wlMMbqwnNOHyaLsd+iB073FfhofKNlSjjOsTyJlUu15BaLn
	NR9xrSu+wjOFcAQhJ34mXpXFJZaSE8LFYJqx281QbjVoT+fyVEi3m6iPxF7JYZUd
	N59xK9RLeCCllFv/ghi2bw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1761617833; x=
	1761704233; bh=7YbNRixEWi4PKn88O3ejOZxwF3GldVBmeOtlnBdESxU=; b=X
	M2xZzIxU4vGppvkfB2NvH3gqaW76yU4EiKw27v6T3ZbalU74KWol0HO0q86kJ3/l
	8kGlF3HMlxVfaL27yj1oBGNvJEMtww1/8vzVEzu0YPwb0nTbcs8ZBAizsgVpp/bm
	qgyZYYwctjDPhJHYdN3vLpJDnT4rK5TGT+uERZ3RKBUKj6bFp/6/ZfKzZQaWSFxY
	5Utz9P3q1crvtTWy4AnKeGyBFxWAxZHOazwKnt3KFjPRHg0q0sezWEgldCWUFA3q
	GGq+StvzWPrHtXbE6thqCOuWaHh5ptDKWnNwiArBHDBs0K+qh1tu7hs4+WcvvA7q
	NxlmVQJbUgujKGfwuSfxg==
X-ME-Sender: <xms:qScAaUhmNLAV1gYHeW5u53oidOebwhYFGE0FirCqBm1AdYYv6pUW_Q>
    <xme:qScAacE3_WLK1GSqqafxAmaXAr47ctl74NL20VxvSlLGDAOZhHXKsPriNiOz0yN_0
    ROBYypzn9XlpoIkYxWibiOVNhMVuKu2hX0eWweCZNdZndD2BzTElg>
X-ME-Received: <xmr:qScAaSThYP21U9dVoIc1mCr7rrIKu1ymR7LjWR2VDbVtuDBZOWB5iV_7ACk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduheeliedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfgjfhggtgfgsehtjeertd
    dttddvnecuhfhrohhmpeetlhgvgicuhghilhhlihgrmhhsohhnuceorghlvgigsehshhgr
    iigsohhtrdhorhhgqeenucggtffrrghtthgvrhhnpeetteduleegkeeigedugeeluedvff
    egheeliedvtdefkedtkeekheffhedutefhhfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpegrlhgvgiesshhhrgiisghothdrohhrghdpnhgspg
    hrtghpthhtohepjedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepmhhrrghthhho
    rheslhhinhhugidrmhhitghrohhsohhfthdrtghomhdprhgtphhtthhopegrlhgvgidrfi
    hilhhlihgrmhhsohhnsehrvgguhhgrthdrtghomhdprhgtphhtthhopehjohgvsehpvghr
    tghhvghsrdgtohhmpdhrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
    dprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopehlihhnuhigqdhhhihpvghrvhesvhhgvghrrdhkvghrnhgvlhdroh
    hrghdprhgtphhtthhopeifvghirdhlihhusehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:qScAaRxSnyantMaOmFGY0_eq9JoHkY8KXbhgluq3eF1Vj-QmGJqoDw>
    <xmx:qScAaWesqbfldIhK4o3cL94fpHVo8COFDCKQt_6elfEfCg5_kIrDUw>
    <xmx:qScAacPvzsVskerSNgmmi1JsrhRUqqXF4xJhrjWPQKxqUNQ9Bef82g>
    <xmx:qScAaZuYDMl8kyDGIW_iRW7ed3fwxJ0SJ7AUjvB3km43MTrBSpSUVA>
    <xmx:qScAaaIfblwsUiJadpkQ0WdU24thQkz5Ux15FeXUFCPlfhrDy-bqD6Ju>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 27 Oct 2025 22:17:12 -0400 (EDT)
Date: Mon, 27 Oct 2025 20:17:11 -0600
From: Alex Williamson <alex@shazbot.org>
To: Mukesh R <mrathor@linux.microsoft.com>
Cc: alex.williamson@redhat.com, joe@perches.com, kvm@vger.kernel.org,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
 "wei.liu@kernel.org" <wei.liu@kernel.org>
Subject: Re: [RFC] Making vma_to_pfn() public (due to vm_pgoff change)
Message-ID: <20251027201711.65e82a4f@shazbot.org>
In-Reply-To: <a9b8a3ee-b35b-5c45-5042-2466607abcd0@linux.microsoft.com>
References: <a9b8a3ee-b35b-5c45-5042-2466607abcd0@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 27 Oct 2025 14:21:56 -0700
Mukesh R <mrathor@linux.microsoft.com> wrote:

> Hi Alex,
> 
> This regards vfio passthru support on hyperv running linux as dom0 aka
> root. At a high level, cloud hypervisor uses vfio for set up as usual,
> then maps the mmio ranges via the hyperv linux driver ioctls.
> 
> Over a year ago, when working on this I had used vm_pgoff to get the pfn
> for the mmio, that was 5.15 and early 6.x kernels. Now that I am porting
> to 6.18 for upstreaming, I noticed:
> 
> commit aac6db75a9fc
> Author: Alex Williamson <alex.williamson@redhat.com>
>     vfio/pci: Use unmap_mapping_range()
> 
> changed the behavior and vm_pgoff is no longer holding the pfn. In light
> of that, I wondered if the following minor change, making vma_to_pfn() 
> public (after renaming it), would be acceptable to you.

How do you know the device is using vfio_pci_core_mmap() with these
semantics for vm_pgoff versus something like nvgrace_gpu_mmap() that
uses vm_pgoff more like you're expecting?  vma_to_pfn() is specific to
the vfio-pci-core semantics, it's not portable to expose for other use
cases.  Thanks,

Alex

