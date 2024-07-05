Return-Path: <kvm+bounces-21034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E566592812E
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 06:10:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3F954B239F1
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 04:10:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E94B66E5FD;
	Fri,  5 Jul 2024 04:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b="r0RC1yST";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="VjC7ZCKX"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh4-smtp.messagingengine.com (fhigh4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7268649654;
	Fri,  5 Jul 2024 04:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720152612; cv=none; b=cF04iKT9XqUPg+Hn0XPl2XdWgyS0oAYd7FjarDS42HAdPY19w8m6l0qC6Z9MI4BbL4/fVOQky6WEnD8NIO3JixwIIF/w2CnSihGGmWcfzSFjofjMqO8X7N8BHiaRuGHJnAeMm3Gs3Ecy5vXerZD4OlqUP/0TuSshdliZIvKl/eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720152612; c=relaxed/simple;
	bh=Zjg9lyUX2x0vprFRKyAabsUjt1z+kMCC1wKEBOt66ZM=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=lEIMIxJzb9HbpHtzbY1D8OIl34qHBUzCJjQnl4r5wfGRmZ4XbzReAX9MuMlEojpWBGS79GlzTEPbx3WQ22H7QxA8wi8u0W9zDDwRF1XarpmCTqWCZ4BgKMe+dgAY1zqGCPuMUBA46o2kourp327vdw0gPzXXk62vS0lS1L6Lync=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com; spf=pass smtp.mailfrom=flygoat.com; dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b=r0RC1yST; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=VjC7ZCKX; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flygoat.com
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id 9B16E1140237;
	Fri,  5 Jul 2024 00:10:10 -0400 (EDT)
Received: from imap44 ([10.202.2.94])
  by compute3.internal (MEProxy); Fri, 05 Jul 2024 00:10:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1720152610;
	 x=1720239010; bh=WT8jpXAd58+z774U5N+k5xZn+Ya/pi+ya2IVvs4MEJg=; b=
	r0RC1ySTij1VxOQnDEUEsf9tfFvaIOV4cK/k4fMEF4k0UwKR2nLsXHHaf0B5Ai2O
	KZv3gy7NZBPTXdNanbNLCzZn1rKUoVmZkIKd1bzM5SdV3A4h/PT272zkYtLCYfhG
	37g/LVBgDIrw0INhoV4Z6yGV6Y/otlXTsUHZVDQ1MH9ngdLtpMwS/AGXCLoPcMSI
	FmiShBy4fGJb3545QpOYydof7T0rEFAsJGJiR16oOsmMMpsO1s7/qiLZiQX4K96b
	/f8kEb40oA07LfH2I2JNDvCZR5HNc8Clfs7VJPG6NmjcrZwF3K7Jk8tHO6XK4oA5
	E9FL26AuIDTuX08kvlLEMg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1720152610; x=
	1720239010; bh=WT8jpXAd58+z774U5N+k5xZn+Ya/pi+ya2IVvs4MEJg=; b=V
	jC7ZCKXp41hZFKcJ2iYckJ/Zk0RyHwGQgBAsJp/GvNKHb57XCn6VrpiStF384X+0
	QcP0BSttCQ/NVGEa4TaYhJphMtzmDVDzPDHiRJDE8FEW/Pf2KpuH+hddNoWi9A7t
	7gDrDiVNpZ52WSKBwgei6royt1OJEZpMvY/sJmmJhrxd1fSZn+ywi8+DkAx3TfJv
	BnK2rmbwBSBZPJT7CycUzQjDoBCb/HJFYUu03+tc2aqSu7Rl2QhwkC3D6DF+/emU
	JOcqz3edQbAc4DBzxSrw/oHf47gLzO8zpN0yw5J1QI+u5F1iB317Zk1QqwfyZk7A
	Xe4kkR7Xc88P7HZH04MwQ==
X-ME-Sender: <xms:IXKHZj_Hq74hy7UfYccLUy6xTXCw8UfqeldFa8sntlhlQf93ycvz2Q>
    <xme:IXKHZvuLMByh3TLU9WL_HP2b-cb8_um6_WTnmGw5QpFvh_tqlQmxgWSTw_733Z_3Y
    1agMEqK2lwEoT9Rktc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvddtgdejlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgfgsehtqhertderreejnecuhfhrohhmpedflfhi
    rgiguhhnucgjrghnghdfuceojhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomh
    eqnecuggftrfgrthhtvghrnhepudefgeeftedugeehffdtheefgfevffelfefghefhjeeu
    geevtefhudduvdeihefgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomh
X-ME-Proxy: <xmx:IXKHZhB0M0ulNtvKIEA_JgzTqiwAROOzkdoTcss6qfrLDPUT6yO9dw>
    <xmx:IXKHZvc20mK7SAGoh8Bgahm4PrRTD7wZyyeFSi-M_hYW4bYA-kzznQ>
    <xmx:IXKHZoMV2wpKdnXbXFH0Zteg39wmqa8EXruxndcw-i49bvgBWO7xmw>
    <xmx:IXKHZhl3RmRUuoJFY5uvi6TpNDUvAu0NlHYGI2kViBc8116RSl0n4Q>
    <xmx:InKHZkB6JVX0D7b8W2xEVCqzd-0BnoxJ98AzuZvtgKdZKA6mR0yjcA1N>
Feedback-ID: ifd894703:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id C461A36A0074; Fri,  5 Jul 2024 00:10:09 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-566-g3812ddbbc-fm-20240627.001-g3812ddbb
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <4cfc5292-6f1a-4409-b229-2433e18f012f@app.fastmail.com>
In-Reply-To: <9316cde1-26d0-54d5-43c3-1284288c685f@loongson.cn>
References: <20240626063239.3722175-1-maobibo@loongson.cn>
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
 <01eb9efd-ca7a-4d4c-a29d-cfc2f6cfbb86@app.fastmail.com>
 <9316cde1-26d0-54d5-43c3-1284288c685f@loongson.cn>
Date: Fri, 05 Jul 2024 12:09:49 +0800
From: "Jiaxun Yang" <jiaxun.yang@flygoat.com>
To: "Bibo Mao" <maobibo@loongson.cn>, "Huacai Chen" <chenhuacai@kernel.org>
Cc: "Tianrui Zhao" <zhaotianrui@loongson.cn>,
 "Xuerui Wang" <kernel@xen0n.name>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/3] LoongArch: KVM: Add LBT feature detection function
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable



=E5=9C=A82024=E5=B9=B47=E6=9C=885=E6=97=A5=E4=B8=83=E6=9C=88 =E4=B8=8A=E5=
=8D=8811:46=EF=BC=8Cmaobibo=E5=86=99=E9=81=93=EF=BC=9A
> On 2024/7/5 =E4=B8=8A=E5=8D=8811:19, Jiaxun Yang wrote:
>>=20
>>=20
>> =E5=9C=A82024=E5=B9=B47=E6=9C=885=E6=97=A5=E4=B8=83=E6=9C=88 =E4=B8=8A=
=E5=8D=889:21=EF=BC=8Cmaobibo=E5=86=99=E9=81=93=EF=BC=9A
>> [...]
>>>> for you.
>>> On the other hand, can you list benefits or disadvantage of approach=
es
>>> on different architecture?
>>=20
>> So the obvious benefit of scratch vCPU would be maintaining consisten=
cy and simpleness
>> for UAPI.
> I do not find the simpleness, for the same feature function, both VM=20
> feature and CPU feature is define as follows.  Do you think it is for=20
> simple :)

So they made a mistake here :-(

We don't even need vCPU flag, just probing CPUCFG bits is sufficient.

Note that in Arm's case, some CPU features have system dependencies, tha=
t's why
they need to be entitled twice.

For us, we don't have such burden.

If Arm doesn't set a good example here, please check RISC-V's CONFIG reg=
 on dealing
ISA extensions. We don't even need such register because our CPUCFG can =
perfectly
describe ISA status.

>
> VM CAPBILITY:
>      KVM_CAP_ARM_PTRAUTH_ADDRESS
>      KVM_CAP_ARM_PTRAUTH_GENERIC
>      KVM_CAP_ARM_EL1_32BIT
>      KVM_CAP_ARM_PMU_V3
>      KVM_CAP_ARM_SVE
>      KVM_CAP_ARM_PSCI
>      KVM_CAP_ARM_PSCI_0_2
>
> CPU:
>      KVM_ARM_VCPU_POWER_OFF
>      KVM_ARM_VCPU_EL1_32BIT
>      KVM_ARM_VCPU_PSCI_0_2
>      KVM_ARM_VCPU_PMU_V3
>      KVM_ARM_VCPU_SVE
>      KVM_ARM_VCPU_PTRAUTH_ADDRESS
>      KVM_ARM_VCPU_PTRAUTH_GENERIC
>      KVM_ARM_VCPU_HAS_EL2
>
> Also why scratch vcpu is created and tested on host cpu type rather th=
an=20
> other cpu type?  It wastes much time for host cpu type to detect capab=
ility.

To maximize supported features, on Arm there is KVM_ARM_VCPU_INIT ioctl.
For us that's unnecessary, our kernel does not need to be aware of CPU t=
ype,
only CPUCFG bits are necessary. RISC-V is following the same convention.

>>=20
>> It can also maximum code reuse probabilities in other user space hype=
rvisor projects.
>>=20
>> Also, it can benefit a potential asymmetrical system. I understand th=
at it won't appear
>> in near future, but we should always be prepared, especially in UAPI =
design.
> If for potential asymmetrical system, however there is only one scratc=
h=20
> vcpu. is that right? how does only one scratch vcpu detect ASMP=20
> capability, and it is not bind to physical cpu to detect ASMP capabili=
ty.
>
> In generic big.little is HMP rather than ASMP, are you agree.

So I was talking about emulating asymmetrical guest. Each guest CPU shou=
ld have
it's own copy of properties. That's the lesson learnt.

[...]

Anyway I'm just trying to help out here, feel free to go ahead without t=
aking my advice.

I've seen so many pitfalls on all other arches and I don't want them to =
repeat on LoongArch.
But sometimes people only learn from mistakes.

--=20
- Jiaxun

