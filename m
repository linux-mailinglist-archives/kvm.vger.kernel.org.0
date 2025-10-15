Return-Path: <kvm+bounces-60049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A158BDBF3D
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 03:05:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A12B7192637A
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 01:06:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5CA02F7AB8;
	Wed, 15 Oct 2025 01:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="KbOEu2aL";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="YXwQfgR6"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C221A9F90;
	Wed, 15 Oct 2025 01:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760490339; cv=none; b=QRt75/KWcuxq9NBtGCPVwhg2T7t0+zMENbeB/+aV+XtZA4fmCwzUUhDL4d0l42b9V9wGW/gWfEEQRJYdiIHqvYZZxm0AXYGRkLK3bMBW1QKHnHmG1yON9F7gDEZyfkrDAksADyBapny7XQfznvv2+jUTrSNTpirNmX2q3ELGEdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760490339; c=relaxed/simple;
	bh=Vpdwz1lvoMPnezfHpwJ1w3Peea0Y3Rl3f/UeHuTQoj8=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=EbwsTLU0pTTDf02XIKbaiie+VzmB3OVqU4WLrkgDcWUN+z+JVdnLMFmtKBXv6L12Th8WaJ+k0TQMXL+Z6DcR2FKaXxcWuih3GgvkHCZCh+CfoRBHS+2iMEneg+1gw2w8xOAD8EeyvP8JzPsqiprW2rgb/zuyZYNY7GUfbIG96Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=KbOEu2aL; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=YXwQfgR6; arc=none smtp.client-ip=103.168.172.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfhigh.phl.internal (Postfix) with ESMTP id A14BF14000DE;
	Tue, 14 Oct 2025 21:05:35 -0400 (EDT)
Received: from phl-imap-18 ([10.202.2.89])
  by phl-compute-11.internal (MEProxy); Tue, 14 Oct 2025 21:05:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1760490335;
	 x=1760576735; bh=6WfOttKuFa3XxhnHEnOBF2NhU4+rEVKwvQn8bW9SNbE=; b=
	KbOEu2aLT/UfzvDu0SSJUOtZjPVshuyykVkae2aOdYK7SV2xvwOLVLCTysHFNJrn
	B1iHoAwrDYRqM2wIMxv7jrrKfuBCouHfVVlffouZ+OWIqNoUW4nSt4uqYZ2knuyD
	Ofyv9CkxvZORWkT4GffrSMR7i/yTqnnGWOJEBmOgUMLXnXPwurVQXsLl1ZZedRsW
	eq03ZIN7Red3958ho+UMH4rcGexVB5EnPwmk8xEOjwRrlpOJFXv1RV15hxw6oqUv
	+QlGqV5XfxwPr/f9cAkpsrPYBuT/gd+fhYXPtejI0FohtEM/jzIrpxF+opuWaEek
	HvzhjJjCOXOGuFLQPs9VZw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1760490335; x=
	1760576735; bh=6WfOttKuFa3XxhnHEnOBF2NhU4+rEVKwvQn8bW9SNbE=; b=Y
	XwQfgR6MVRkFKJPnBPd6gYi6NAyK5nkAVXXlUbfCUdQlo2WN9uZC/2WwMWz0D9UR
	2vBmMCjuTK0cPHTQGGKTNUxHZr6vZbsOXxUg2iZ2kq3u5oaVWheU2kSqGiOTub4B
	Vly7BcFUR6v8cLK9DYEISIRmpPBP+UOxz4TqTaZmnamui77K5r1feGMjsODapogY
	NDv4ARn7n1AFhQDfgAUNPd0b8y4407Iu7viuT8OtJhiwtw+SD7V7u0YuFeh8DWJj
	LhiUbK/ima0/toKxNtk4AiF1gspMQD+71uzeEyAgMjT3IwZW+OwMBXDbn1RAz779
	NL9VCru5mngUGZsN337aw==
X-ME-Sender: <xms:XvPuaHvn4AyIwceeC9gm4GXEYVo189WkwzAqOGnFZXXSHUpAG1IPxQ>
    <xme:XvPuaDTlrXbVap0JafZMpHrVFJwiNx8hwITaFooaLaX38QF84_85N4_-6j3ZHuoga
    OknLq3G4_OZlwo9IM8ujpTPthmuPszDNVLWjYEntwsZ7L2_JhPn>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduvddvtdehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefoggffhffvvefkjghfufgtgfesthhqre
    dtredtjeenucfhrhhomhepfdetlhgvgicuhghilhhlihgrmhhsohhnfdcuoegrlhgvgies
    shhhrgiisghothdrohhrgheqnecuggftrfgrthhtvghrnhepuefgtdefheeiheethfeggf
    fhteduiefhfffhieeljeeijeegieffleevjeeiuefgnecuvehluhhsthgvrhfuihiivgep
    tdenucfrrghrrghmpehmrghilhhfrhhomheprghlvgigsehshhgriigsohhtrdhorhhgpd
    hnsggprhgtphhtthhopedujedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepshgu
    fhesfhhomhhitghhvghvrdhmvgdprhgtphhtthhopegvugguhiiikeejsehgmhgrihhlrd
    gtohhmpdhrtghpthhtohepjhhohhhnrdhfrghsthgrsggvnhgusehgmhgrihhlrdgtohhm
    pdhrtghpthhtohephhgrohhluhhosehgohhoghhlvgdrtghomhdprhgtphhtthhopegthh
    hughhurghnghhqihhnghesihhnshhpuhhrrdgtohhmpdhrtghpthhtohepuggrnhhivghl
    sehiohhgvggrrhgsohigrdhnvghtpdhrtghpthhtoheprghnughrihhisehkvghrnhgvlh
    drohhrghdprhgtphhtthhopegrshhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehj
    ohhlshgrsehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:XvPuaPPK_nfwU05sQbeRi6eCvQvvO0fgsxrldnNp4mkh5TF8h5tfPg>
    <xmx:XvPuaGSFWIFmFL3ErefrsSfPFZhT1EFvyjjMQzjA3TE7-XxSwlHRYQ>
    <xmx:XvPuaP5FrgSic4bZdhG7ww9dDaX32Ia5671iW_3F37PL4mIvckzc3w>
    <xmx:XvPuaA3AgqRfY0Hl18GCKZid99UDv5zQrtHd605OrFI6HPXfKhSsKQ>
    <xmx:X_PuaLHQcBg_5ojt7hqTtKRSNaJb5oBCmWf2f94XXoClZ_EtrVL2iZ4c>
Feedback-ID: i03f14258:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 9EBB515C0053; Tue, 14 Oct 2025 21:05:34 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AauiaLfHrCWk
Date: Tue, 14 Oct 2025 19:05:14 -0600
From: "Alex Williamson" <alex@shazbot.org>
To: 
 =?UTF-8?Q?Gary_Chu=28=E6=A5=9A=E5=85=89=E5=BA=86=29?= <chuguangqing@inspur.com>
Cc: ast <ast@kernel.org>, daniel <daniel@iogearbox.net>,
 andrii <andrii@kernel.org>, "martin.lau" <martin.lau@linux.dev>,
 eddyz87 <eddyz87@gmail.com>, song <song@kernel.org>,
 "yonghong.song" <yonghong.song@linux.dev>,
 "john.fastabend" <john.fastabend@gmail.com>, kpsingh <kpsingh@kernel.org>,
 sdf <sdf@fomichev.me>, haoluo <haoluo@google.com>, jolsa <jolsa@kernel.org>,
 kwankhede <kwankhede@nvidia.com>, bpf <bpf@vger.kernel.org>,
 linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Message-Id: <7514bbaa-3ae1-4041-b5aa-9d5b790c7778@app.fastmail.com>
In-Reply-To: <68eef1b8.1.4heY4R8JIaj5heY4@inspur.com>
References: 
 <3e4b2ac992da27b6aeafed9553a7fa9d15-10-25shazbot.org@g.corp-email.com>
 <20251014140035.31bd9154@shazbot.org>
 <68eef1b8.1.4heY4R8JIaj5heY4@inspur.com>
Subject: Re: [PATCH v2 1/1] samples/bpf: Fix spelling typo in samples/bpf
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 14, 2025, at 6:59 PM, Gary Chu(=E6=A5=9A=E5=85=89=E5=BA=86) =
wrote:
>>I'd suggest this go through bpf since it touches more there.  For mtty,
>>
>>Acked-by: Alex Williamson <alex@shazbot.org>
> Can I understand this as splitting into two separate threads: one for=20
> BPF and one for mtty?

It might have been a bit of an over correction to roll 5 patches into 1,
one for vfio/mtty and one for bpf would have been easier to split between
maintainers, but I'm providing my ack so it can go through the bpf folks
since this is fairly inconsequential.  Thanks,

Alex

