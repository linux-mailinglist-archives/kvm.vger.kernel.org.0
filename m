Return-Path: <kvm+bounces-60029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BEFC9BDB248
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 22:00:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E7B718A6B17
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 20:01:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E11F93054EB;
	Tue, 14 Oct 2025 20:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="mObzBgaj";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Y5OeRJOU"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF2F270576;
	Tue, 14 Oct 2025 20:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760472043; cv=none; b=ZRZnECFZxgsgm3quQ4kRCAUvMq6vGU5CARst21klmOVhoqIrEfSuUC0ALKz09iVsNGmUvGvlcuMHe8f1GkmcYJI4MkAYBXtTuUdX5hLBGR5WbcbogzksVKiTWZ7b+X3MMLBHjw1PGPIpu+01t9NcLJ51Pszk+P9RkRp9W2iKlr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760472043; c=relaxed/simple;
	bh=RPTDAXRUH48H3AuOqxa0FeN3HigldSnpntB2oGFh6IE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lXUUHzuP97zBxGvO1SUCGmPhOWTt3d4JO1BKWhp0VZ+NrjgpV+ImLZ0I6ZxhRxwd2sXHVCzHScU+EiLNqp37hb8hodi48Qjge5bYFm2HZpwUqZdLzy5U0GVouvbdMo166P9x2vrCQHS5lFa0LPuT6GALjU4tyZo60ik8//bnYD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=mObzBgaj; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Y5OeRJOU; arc=none smtp.client-ip=103.168.172.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 4D121EC0979;
	Tue, 14 Oct 2025 16:00:40 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Tue, 14 Oct 2025 16:00:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1760472040;
	 x=1760558440; bh=nAxl708qa6gSnRG8kCG0KKh+WEJSc1Rsjsj0CGW+qi4=; b=
	mObzBgajVP+Z4+HkmAJ54WcoMzfqCD9UcX65GSCNYUHmLmANNouhyS8twNIy83Ry
	xh4s3IVeNox2LSbZSk+Slw/r655vZaB82na+F/kY9ihval8GEw270ILbkxLzq475
	/9ysnopWzO8fKtT3HwAZsjo1mRNY2pAWhrRDTHhQRsLR6kpBKpoRJYqzk+WGWbFu
	LlfLLlQTEh4gFqX6FI1+lHGNwsJhDgSGkWa4w8Yl6VUlxWl2xFW5MTENShTASvGt
	T2KDgAit8AJ5kwifVl/1NziqZ/1hd+TPCws5iARQf09yKdoQtUgOhesc61kSvYga
	dvQXtyiwKJWjQ/g1wMJ5yA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1760472040; x=
	1760558440; bh=nAxl708qa6gSnRG8kCG0KKh+WEJSc1Rsjsj0CGW+qi4=; b=Y
	5OeRJOU4fqHMnQdlVW/TadlCpvcAwkXzT8UhAa8d7gp5A/zo5VMwjFG2baNBC4FA
	TSU7CHCxQwKDVdNtNgxjzO2xxNRbKJCRWdKys49n8x/Qjg/qWRyhfbPawlSikNVc
	8IzgHQ+IoLdo/Ux4SDWij3/fa5ZAfngSGeNxsJArtrvsUPUADIfqAa/A/4vcKGDU
	SCcEiMfNWX9aVhwq7C7/KFhQBL4rMDz46+U6I26nHf5D6VPOrjVHjoYLtMzx12Py
	qhoSc/52017ftfd5oT0iN9agcHsFw+jU+pzEFW8wfnDlJJ9Xd2iHQYpBg0rw7Z7Z
	u54KcAYf7vgwx6pjYZXLQ==
X-ME-Sender: <xms:5qvuaAdDrpWEwv-u-aasXbY69cKBjfSBzqzJ_WxRn9ZxklWtthOv2Q>
    <xme:5qvuaDJSF2Qgr8uRZodgNq3LsERt-1rY16PQMI_MP2zwUOjdDxnmPtjPhYZTzsP9o
    LxEYc_eKyfsudzGmIEk2UHjNAW2fCUUR2On27RiIEiXEUldqG-wZg>
X-ME-Received: <xmr:5qvuaB3xi5KjXdLTdGvsgyXlEbXgSYDvkDAVztKJlkdU0Y08HwxT5Imdud0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduvddugeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthejredttddtvdenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhepteetudelgeekieegudegleeuvdffgeehleeivddtfeektdekkeehffehudet
    hffhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hlvgigsehshhgriigsohhtrdhorhhgpdhnsggprhgtphhtthhopedujedpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtoheptghhuhhguhgrnhhgqhhinhhgsehinhhsphhurhdrtg
    homhdprhgtphhtthhopegrshhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopegurghn
    ihgvlhesihhoghgvrghrsghogidrnhgvthdprhgtphhtthhopegrnhgurhhiiheskhgvrh
    hnvghlrdhorhhgpdhrtghpthhtohepmhgrrhhtihhnrdhlrghusehlihhnuhigrdguvghv
    pdhrtghpthhtohepvgguugihiiekjeesghhmrghilhdrtghomhdprhgtphhtthhopehsoh
    hngheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohephihonhhghhhonhhgrdhsohhnghes
    lhhinhhugidruggvvhdprhgtphhtthhopehjohhhnhdrfhgrshhtrggsvghnugesghhmrg
    hilhdrtghomh
X-ME-Proxy: <xmx:56vuaEaBczoypXRgxQ2vwcOpEatc8EpKuldURGbBn3iF7RZMksgdLA>
    <xmx:56vuaDiR0EORGA6YSEoXACvx5T7iLGBZZ2SuWLJiexmr8x9XTRB7LA>
    <xmx:56vuaL_jKvtp3aIGw3Dn9g_3HofzU__XjJuAmJZxhpSOOPIFv8CLoQ>
    <xmx:56vuaJMu1tKSW7wt6ouQtZh0Tf_6X3JRL0BSCBLFkdvP3X_KTD-xzQ>
    <xmx:6KvuaIOjQkDPfSTH2nx6Cw-5jE5I72Hkc0pO-Cbe1al3NqYjPBbEc2wc>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Oct 2025 16:00:37 -0400 (EDT)
Date: Tue, 14 Oct 2025 14:00:35 -0600
From: Alex Williamson <alex@shazbot.org>
To: Chu Guangqing <chuguangqing@inspur.com>
Cc: <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
 <martin.lau@linux.dev>, <eddyz87@gmail.com>, <song@kernel.org>,
 <yonghong.song@linux.dev>, <john.fastabend@gmail.com>,
 <kpsingh@kernel.org>, <sdf@fomichev.me>, <haoluo@google.com>,
 <jolsa@kernel.org>, <kwankhede@nvidia.com>, <bpf@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] samples/bpf: Fix spelling typo in samples/bpf
Message-ID: <20251014140035.31bd9154@shazbot.org>
In-Reply-To: <20251014060849.3074-2-chuguangqing@inspur.com>
References: <20251014060849.3074-1-chuguangqing@inspur.com>
	<20251014060849.3074-2-chuguangqing@inspur.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 14 Oct 2025 14:08:49 +0800
Chu Guangqing <chuguangqing@inspur.com> wrote:

> do_hbm_test.sh:
> The comment incorrectly used "upcomming" instead of "upcoming".
> 
> hbm.c
> The comment incorrectly used "Managment" instead of "Management".
> The comment incorrectly used "Currrently" instead of "Currently".
> 
> tcp_cong_kern.c
> The comment incorrectly used "deteremined" instead of "determined".
> 
> tracex1.bpf.c
> The comment incorrectly used "loobpack" instead of "loopback".
> 
> mtty.c
> The comment incorrectly used "atleast" instead of "at least".
> 
> Signed-off-by: Chu Guangqing <chuguangqing@inspur.com>
> ---
>  samples/bpf/do_hbm_test.sh  | 2 +-
>  samples/bpf/hbm.c           | 4 ++--
>  samples/bpf/tcp_cong_kern.c | 2 +-
>  samples/bpf/tracex1.bpf.c   | 2 +-
>  samples/vfio-mdev/mtty.c    | 2 +-
>  5 files changed, 6 insertions(+), 6 deletions(-)
> 
...
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> index 59eefe2fed10..6cb3e5974990 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -624,7 +624,7 @@ static void handle_bar_read(unsigned int index, struct mdev_state *mdev_state,
>  		u8 lsr = 0;
>  
>  		mutex_lock(&mdev_state->rxtx_lock);
> -		/* atleast one char in FIFO */
> +		/* at least one char in FIFO */
>  		if (mdev_state->s[index].rxtx.head !=
>  				 mdev_state->s[index].rxtx.tail)
>  			lsr |= UART_LSR_DR;

I'd suggest this go through bpf since it touches more there.  For mtty,

Acked-by: Alex Williamson <alex@shazbot.org>

