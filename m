Return-Path: <kvm+bounces-69629-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uKP4CmLYe2l3IwIAu9opvQ
	(envelope-from <kvm+bounces-69629-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 23:00:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ECACB5251
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 23:00:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D24423028EC9
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 21:58:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AC71366DCD;
	Thu, 29 Jan 2026 21:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="YD7fJW14";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="RsWc0rPL"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6AF3328B47;
	Thu, 29 Jan 2026 21:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769723925; cv=none; b=NY5meJOB5qcLVPoNFNqFBnKRKdHw0vcIbin1veKVJbavwSQnOiL01K5zcKVMYGL29o/oHg1m0l2uUgB6pf77a4skpUa9HXDdvt/lWYAuAh6emzrG5xeEx0eS5Ki3s+2I3U3iDkYA+u0OhIgvh4u6LcTE8iL0+h27z03shcBQR1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769723925; c=relaxed/simple;
	bh=NcR7Pla/9ZASYbgKSOWYLIHCTfmdXpnXp67lI52+vGY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FsVzwy753RdXZgMxMZBFvMrL3eFPIkYhejKzw4YUBQNRd1Ma4osA89tWsFg+Xr3CTdusJUWGpf1CoYVDJUME5xrA0IL4xcw7TpdBzoHGCPnUwWnC8HLKXEsCqsMFFw5SC6A2e6dWBuaJqNhOKOleDPlJxPYCi1iWkR+2mf1n5v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=YD7fJW14; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=RsWc0rPL; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 177291400078;
	Thu, 29 Jan 2026 16:58:42 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 29 Jan 2026 16:58:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1769723922;
	 x=1769810322; bh=lvScv9KpkvKASqV5mrTmVeOLkrLV2lQ2HyOegCZUelk=; b=
	YD7fJW14jTxUmEOmxbsw4HzdLX7uWIcuQk+zIkC0KJEbz8R1qW/GkCgYwH37s5WW
	pMUwxAqMydTQPVVIkBjStgqQkE4O8Cu+ccMfDoA9/JpMhuCQ1XqBmrYaCTYf8DUe
	NkRmJMsrBkbamJYeJsIHDlM3kMCkUgNW6wsWpdVV389EG0W57XzRwY0nryGoVV1z
	IWZhfCmyyyZv8+LAIoyZyexTfGJuDD7RT3/sTaGQMpVKDuSQBaDbPvZanUsllKzc
	J/7QmhLAkVcpgu5zMYza1zW+0DQ7DaiO4KOay/lcjc8xcwP3MpXp58fnhlm6wN8A
	0ns2UXa+0t9I5EImV2suZA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1769723922; x=
	1769810322; bh=lvScv9KpkvKASqV5mrTmVeOLkrLV2lQ2HyOegCZUelk=; b=R
	sWc0rPLG41wu4YsHvQ7CMQaGxNvg4Re9RKMz8CGdyyvq0es0uDRZDkXTItmx2+bu
	gTw/EVPwnhaR9waea/S4mnOTgWqVXvoQ4Yb+cSphYYr0EhTVM8Jf7cBe2IVJOs+7
	JJ5mfEGnyUb/KDlGOZYLEErdlKkrpSpvd+OmSB8cRakFVug/8AbWiQzVXN1QP1ma
	EBmJJwrmt9h2YUu3xiiCmEGvCD/nnKE8S2hQVkAHCoWShaLzZDB48WI08wHhY/xj
	S3kBxd9HREPsp8aZGgKHV76VPT52rRkmQBdjbRVQgIlVZbJ5rn7/9UysYoH7j6VY
	7arZ+D2jbtx3U7zoSD8RA==
X-ME-Sender: <xms:Edh7aY0GLxM0SpmZAWo2MdGzkIMAtYuSHwZFWvMR7O2u-fxayLuguw>
    <xme:Edh7aUmihUAPs2u2K6nIeTBjKJKIZMmQ58kJQ7ABkls7zLts7VrKiCeC-XFYZfzxJ
    wRyYPgHl_Ub8QU_fwDXvq0muDR6eR0wnKTvqv3z9u-IhBwdMdJHxQ>
X-ME-Received: <xmr:Edh7aQ9sFaf9YeLkvHYHH-xppbXZTxp6J1gSTrLY8pKbkCQWFOidfv0r_Gg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduieejfeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtjeertdertddvnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvkeefjeekvdduhfduhfetkedugfduieettedvueekvdehtedvkefgudeg
    veeuueenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohephedpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtoheplhhiuhhlohhnghhfrghngheshhhurgifvghirdgtoh
    hmpdhrtghpthhtohepjhhgghesnhhvihguihgrrdgtohhmpdhrtghpthhtohepjhhonhgr
    thhhrghnrdgtrghmvghrohhnsehhuhgrfigvihdrtghomhdprhgtphhtthhopehkvhhmse
    hvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghl
    sehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:Edh7aRrWBAeob6swGAY245T10XvwZAskpruF7SZnatBwIcuiGLL1Lw>
    <xmx:Edh7aRnNm5dM7AjmcW25e-f5_jEoqfGpkoFfGqT_Eesd7Sw_Wkq_ig>
    <xmx:Edh7aQgLGEA8lLZWAvGPYBs6Wp-tVzkC5Qbyw8Jlx9EdfjpH-Cr2PQ>
    <xmx:Edh7aRc9SUi5pGEQJu3yfosdwObQTC6XRooONYukB5bIXXa3hYrZPA>
    <xmx:Eth7aZuv5-O9AKK45lfBt3KDN2sMP3TISP53fJ13gJWYPQwgG9yYq0yA>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 29 Jan 2026 16:58:41 -0500 (EST)
Date: Thu, 29 Jan 2026 14:58:40 -0700
From: Alex Williamson <alex@shazbot.org>
To: Longfang Liu <liulongfang@huawei.com>
Cc: <jgg@nvidia.com>, <jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] bugfix some issues under abnormal scenarios.
Message-ID: <20260129145840.1d49a38e@shazbot.org>
In-Reply-To: <20260122020205.2884497-1-liulongfang@huawei.com>
References: <20260122020205.2884497-1-liulongfang@huawei.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[shazbot.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm2,messagingengine.com:s=fm3];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-69629-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,huawei.com:email,messagingengine.com:dkim,shazbot.org:mid,shazbot.org:dkim]
X-Rspamd-Queue-Id: 5ECACB5251
X-Rspamd-Action: no action

On Thu, 22 Jan 2026 10:02:01 +0800
Longfang Liu <liulongfang@huawei.com> wrote:

> In certain reset scenarios, repeated migration scenarios, and error injection
> scenarios, it is essential to ensure that the device driver functions properly.
> Issues arising in these scenarios need to be addressed and fixed
> 
> Change v1 -> v2
> 	Fix the reset state handling issue
> 
> Longfang Liu (3):
>   hisi_acc_vfio_pci: update status after RAS error
>   hisi_acc_vfio_pci: resolve duplicate migration states
>   hisi_acc_vfio_pci: fix the queue parameter anomaly issue
> 
> Weili Qian (1):
>   hisi_acc_vfio_pci: fix VF reset timeout issue
> 
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 30 +++++++++++++++++--
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  2 ++
>  2 files changed, 29 insertions(+), 3 deletions(-)
> 

Applied to vfio next branch for v6.20/v7.0.  Thanks,

Alex

