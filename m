Return-Path: <kvm+bounces-20986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DC79927FB5
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 03:21:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BAFA61F22897
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 01:21:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADE0D101CE;
	Fri,  5 Jul 2024 01:21:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9119D3FEC;
	Fri,  5 Jul 2024 01:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720142486; cv=none; b=W3tXOOXUzT7gCDT56XMSg6LgBubJ/z8tn12hruoalpJKm2aU8y7n5siLUDiOQ6ke3FBEnU/om/BFtw7hLHWeS67twHi91VLFkJ/D2JHKZAZ30+B50tXj6kPUellQPnVh1FQaAa50n5IAT05j2SbnlJ/63azZCDgnH1s0JG/togA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720142486; c=relaxed/simple;
	bh=5X/6jbJu4QtfpBJLnuys4Wu3vTFIuA7T4od907taK24=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=F3ESlz9Ga2gu0D80nIRBrn605ozIPCKTgUzoC/Bxhw4hDtvscWsyA6zY5MiJuAe9uXaxyIW0MMdxdtxXEVX1RJlSK56uAfamV4HvrFgEk05wltKPTZGE7LdivUQ9DiK3xqR/PwBZOADxGtvrdPXUzOIt7wm1KyQ/FjFk66YQmdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Cx7+uRSodm2x8BAA--.3399S3;
	Fri, 05 Jul 2024 09:21:21 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8CxJMWOSodmQbw7AA--.62450S3;
	Fri, 05 Jul 2024 09:21:20 +0800 (CST)
Subject: Re: [PATCH v4 2/3] LoongArch: KVM: Add LBT feature detection function
To: Jiaxun Yang <jiaxun.yang@flygoat.com>, Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
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
From: maobibo <maobibo@loongson.cn>
Message-ID: <554b10e8-a7ab-424a-f987-ea679859a220@loongson.cn>
Date: Fri, 5 Jul 2024 09:21:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ecb6df72-543c-4458-ba27-0ef8340c1eb3@flygoat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8CxJMWOSodmQbw7AA--.62450S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7Kry8ZF4rWFy8Ww1UZw1xtFc_yoW8KFy3pa
	yFka1S9F4DAr48AwnrAw4xWw4Skw4rta13Jrn8GryDJ398Xry2vr92kayruF9rCr1Sg34j
	vF42y3sakFZ8ZagCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AK
	xVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzV
	AYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r
	4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8zwZ7UU
	UUU==



On 2024/7/5 上午3:44, Jiaxun Yang wrote:
> 
> 
> On 2024/7/4 09:35, maobibo wrote:
>> In another thread I found that Jiaxun said he has a solution to make
>>> LBT be a vcpu feature and still works well. However, that may take
>>> some time and is too late for 6.11.
>>>
>>> But we have another choice now: just remove the UAPI and vm.c parts in
>>> this series, let the LBT main parts be upstream in 6.11, and then
>>> solve other problems after 6.11. Even if Jiaxun's solution isn't
>>> usable, we can still use this old vm feature solution then.
> 
> IMO this is the best approach to make some progress.
> 
>>
>> I am sure it is best if it is VM feature for LBT feature detection, 
>> LSX/LASX feature detection uses CPU feature, we can improve it later.
> 
> Please justify the reason, we should always be serious on UAPI design 
> choices.
> I don't really understand why the approach worked so well on Arm & 
> RISC-V is not working
> for you.
On the other hand, can you list benefits or disadvantage of approaches 
on different architecture?

Or you post patch about host cpu support, I list its disadvantage. Or I 
post patch about host cpu support with scheduled time, then we talk 
about it. Is that fair for you?

It is unfair that you list some approaches and let others spend time to 
do, else you are my top boss :)
> 
> I understand you may have some plans in your mind, please elaborate so 
> we can smash
> them together. That's how community work.
> 
>>
>> For host cpu type or migration feature detection, I have no idea now, 
>> also I do not think it will be big issue for me, I will do it with 
>> scheduled time. Of source, welcome Jiaxun and you to implement host 
>> cpu type or migration feature detection.
> 
> My concern is if you allow CPU features to have "auto" property you are 
> risking create
> inconsistency among migration. Once you've done that it's pretty hard to 
> get rid of it.
> 
> Please check how RISC-V dealing with CPU features at QMP side.
> 
> I'm not meant to hinder your development work, but we should always 
> think ahead.
Yes, it is potential issue and we will solve it. Another potential issue 
is that PV features may different on host, you cannot disable PV 
features directly.  The best way is that you post patch about it, then 
we can talk about together, else it may be kindly reminder, also may be 
waste of time, everyone is busy working for boss :)

Regards
Bibo Mao
> 
> Thanks
> - Jiaxun
>>


