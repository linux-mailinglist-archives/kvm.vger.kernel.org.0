Return-Path: <kvm+bounces-21030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 113299280E1
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 05:19:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2604D1C21B77
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 03:19:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76B3538DD4;
	Fri,  5 Jul 2024 03:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b="hsALHIgm";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="sQBACcDF"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh4-smtp.messagingengine.com (fhigh4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EDF1B950;
	Fri,  5 Jul 2024 03:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720149574; cv=none; b=Zgz5FehLWrgmh0mjhu5rLdoiILIluwxuu8AfbSfmCD4kitdOFm498rWkPsWa6l6E6ej+xL2mAX9U6YZM0nYCMyZLSs9dPlIeZikL1ZYs5Tvu3oqmtmnghDCzunF9BEzryct7Gd9LQsHB6+UNWVk5n5Qc8DifwQabghCWrm2/OTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720149574; c=relaxed/simple;
	bh=+wTwNpg8TcTjbHythgWMvLOXcf15T1T2vdbdDsv15Eo=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=WwVe0hy2fIef7yv9Hyw6+PgjYiHk463KCH8jrUp/DLC1krjrjoD14ygmHP3Bh1y/Mc0SeEJeGNliflxU1DP82FlYp31rdZrdrFB2dPlcAmipRsOuQwVq4wi04guRoBWFHeQhEc7d02qI4pzYkx70bQR0Gy3LBd9iuIcmzMFORVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com; spf=pass smtp.mailfrom=flygoat.com; dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b=hsALHIgm; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=sQBACcDF; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flygoat.com
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id E3F7A1140212;
	Thu,  4 Jul 2024 23:19:31 -0400 (EDT)
Received: from imap44 ([10.202.2.94])
  by compute3.internal (MEProxy); Thu, 04 Jul 2024 23:19:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1720149571;
	 x=1720235971; bh=YpqySUb+a4hGbNyz/m8SXRAbP72Db2DhOeFYdzoNiIk=; b=
	hsALHIgmuWtvnCQ1d3Sgnrf2znx2l0XG2RRxjuRWL8QeNDh7KQBR7q5DL/ly/nyv
	no+XmfmyhCUS7Qz7m+wwisWK4LFhXj0OXwmBV6Sg+W77dZuk3qaMSVUSOc/d/wWc
	cSyF77EdDWYlxmVfVI4/iYn3M6sszZgP5lNUrOTgmdvBPr+qJlYMNb0uCOSkgrR9
	A+1X7rCquuiHFoet6SqIfeAgzagS61z+0+D0/GDDfUfS2fscPlliz5tX8LLDAUhr
	YdlrPfZPVaJBoK7Bh9LWbyVmgydii2jSsIYXvoKLaIyF9xnwNnnwtFU3e7+Zf2AJ
	TyoKH0heJedK9Iwr/D833A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1720149571; x=
	1720235971; bh=YpqySUb+a4hGbNyz/m8SXRAbP72Db2DhOeFYdzoNiIk=; b=s
	QBACcDFZUAU+vOChb6LlDVPhM6xr9y4QOEZo4IuOpp1FAV+IP+2kPQuzfO1d4x8Z
	3ps7rB4RkmjFfRnpLROvteBxZieBH+PK0mKVooJc8aquQsWU9OT25RPQe64Dk5qM
	22sNoi+f8zJQoDjvXhkysHxR1t/efsV+OmPskaCoYHGtBesEteVp7ewtIwEyBHE4
	rpPJSlPmpUHBS69nSEpCvDqdBEERxKxXPl5siQcEZzpVKkAQgSxeLxtPK4Idm/0A
	6p+siXLb77CnZ9bnl2Ub1OgzdSTiQQSRIoT+Oy3aD9S09j3kXxDlukMHW4xVdVJ+
	LHXDsrzoKoJMWm3VC7SkQ==
X-ME-Sender: <xms:QmaHZoIfeq3ppTADQcJm2SzZeqv63xLcz2mZQMkeZeZfpUAPrcbKzw>
    <xme:QmaHZoJSHKWPICYHoR5u3n1ySZ_7diOdqSDuqjNG4kfD1nD9IlnSZNVLHxAiw0mj2
    yL4yFjC02M_apknTaA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvddtgdeilecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgfgsehtqhertderreejnecuhfhrohhmpedflfhi
    rgiguhhnucgjrghnghdfuceojhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomh
    eqnecuggftrfgrthhtvghrnhepudefgeeftedugeehffdtheefgfevffelfefghefhjeeu
    geevtefhudduvdeihefgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomh
X-ME-Proxy: <xmx:QmaHZotFaIIlbINwjLculLxVZUEQHn0SlHY3XOpqW7JU8mbtJxGnuw>
    <xmx:QmaHZlbq5x-UoajqeF0gLUDLvYmXfBv6KEXsDqQO_wDCM3R_p4Yk6A>
    <xmx:QmaHZvbO08lN3d_6jobNEvFTNx7IydaOiq2oAn-Tk1gvT3JI7mHhfw>
    <xmx:QmaHZhC_ztpfqxkMJ2NUqtqO0ouaNJDLtY6DKgi2wBzuCPg7UX38SQ>
    <xmx:Q2aHZkNplrJKCKsO_YYDBjgsjBLr99yY1fsmTFM6xpknu8VxjaQajd3R>
Feedback-ID: ifd894703:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 8993336A0074; Thu,  4 Jul 2024 23:19:30 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-566-g3812ddbbc-fm-20240627.001-g3812ddbb
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <01eb9efd-ca7a-4d4c-a29d-cfc2f6cfbb86@app.fastmail.com>
In-Reply-To: <554b10e8-a7ab-424a-f987-ea679859a220@loongson.cn>
References: <20240626063239.3722175-1-maobibo@loongson.cn>
 <20240626063239.3722175-3-maobibo@loongson.cn>
 <CAAhV-H4O8QNb61xkErd9y_1tK_70=Y=LNqzy=9Ny5EQK1XZJaQ@mail.gmail.com>
 <79dcf093-614f-2737-bb03-698b0b3abc57@loongson.cn>
 <CAAhV-H5bQutcLcVaHn-amjF6_NDnCf2BFqqnGSRT_QQ_6q6REg@mail.gmail.com>
 <9c7d242e-660b-8d39-b69e-201fd0a4bfbf@loongson.cn>
 <CAAhV-H4wwrYyMYpL1u5Z3sFp6EeW4eWhGbBv0Jn9XYJGXgwLfg@mail.gmail.com>
 <059d66e4-dd5d-0091-01d9-11aaba9297bd@loongson.cn>
 <CAAhV-H41B3_dLgTQGwT-DRDbb=qt44A_M08-RcKfJuxOTfm3nw@mail.gmail.com>
 <7e6a1dbc-779a-4669-4541-c5952c9bdf24@loongson.cn>
 <CAAhV-H7jY8p8eY4rVLcMvVky9ZQTyZkA+0UsW2JkbKYtWvjmZg@mail.gmail.com>
 <81dded06-ad03-9aed-3f07-cf19c5538723@loongson.cn>
 <CAAhV-H520i-2N0DUPO=RJxtU8Sn+eofQAy7_e+rRsnNdgv8DTQ@mail.gmail.com>
 <0e28596c-3fe9-b716-b193-200b9b1d5516@loongson.cn>
 <CAAhV-H6vgb1D53zHoe=BJD1crB9jcdZy7RM-G0YY0UD+ubDi4g@mail.gmail.com>
 <bdcc9ec4-31a8-1438-25c0-be8ba7f49ed0@loongson.cn>
 <ecb6df72-543c-4458-ba27-0ef8340c1eb3@flygoat.com>
 <554b10e8-a7ab-424a-f987-ea679859a220@loongson.cn>
Date: Fri, 05 Jul 2024 11:19:09 +0800
From: "Jiaxun Yang" <jiaxun.yang@flygoat.com>
To: "Bibo Mao" <maobibo@loongson.cn>, "Huacai Chen" <chenhuacai@kernel.org>
Cc: "Tianrui Zhao" <zhaotianrui@loongson.cn>,
 "Xuerui Wang" <kernel@xen0n.name>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/3] LoongArch: KVM: Add LBT feature detection function
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable



=E5=9C=A82024=E5=B9=B47=E6=9C=885=E6=97=A5=E4=B8=83=E6=9C=88 =E4=B8=8A=E5=
=8D=889:21=EF=BC=8Cmaobibo=E5=86=99=E9=81=93=EF=BC=9A
[...]
>> for you.
> On the other hand, can you list benefits or disadvantage of approaches=20
> on different architecture?

So the obvious benefit of scratch vCPU would be maintaining consistency =
and simpleness
for UAPI.

It can also maximum code reuse probabilities in other user space hypervi=
sor projects.

Also, it can benefit a potential asymmetrical system. I understand that =
it won't appear
in near future, but we should always be prepared, especially in UAPI des=
ign.

>
> Or you post patch about host cpu support, I list its disadvantage. Or =
I=20
> post patch about host cpu support with scheduled time, then we talk=20
> about it. Is that fair for you?

I'm not committed to development work, I can try, but I can't promise.

Regarding the fairness, IMO that's not how community works. If you obser=
ve reviewing
process happening all the place, it's always about addressing other's co=
ncern.

Still, it's up to maintainers to decide what's reasonable, I'm just tryi=
ng to help.

>
> It is unfair that you list some approaches and let others spend time t=
o=20
> do, else you are my top boss :)

I mean, I'm just trying to make some progress here. I saw you have some =
disagreement
with Huacai.

I know QEMU side implementation better than Huacai, so I'm trying to pro=
pose a solution
that would address Huacai's concern and may work for you.

>>=20
>> I understand you may have some plans in your mind, please elaborate s=
o=20
>> we can smash
>> them together. That's how community work.
>>=20
>>>
>>> For host cpu type or migration feature detection, I have no idea now=
,=20
>>> also I do not think it will be big issue for me, I will do it with=20
>>> scheduled time. Of source, welcome Jiaxun and you to implement host=20
>>> cpu type or migration feature detection.
>>=20
>> My concern is if you allow CPU features to have "auto" property you a=
re=20
>> risking create
>> inconsistency among migration.=C2=A0Once you've done that it's pretty=
 hard to=20
>> get rid of it.
>>=20
>> Please check how RISC-V dealing with CPU features at QMP side.We are =
working on
>>=20
>> I'm not meant to hinder your development work, but we should always=20
>> think ahead.
> Yes, it is potential issue and we will solve it. Another potential iss=
ue=20
> is that PV features may different on host, you cannot disable PV=20
> features directly.  The best way is that you post patch about it, then=20
> we can talk about together, else it may be kindly reminder, also may b=
e=20
> waste of time, everyone is busy working for boss :)

Sigh, so you meant you submitted something known to be problematic?

--=20
- Jiaxun

