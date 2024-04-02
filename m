Return-Path: <kvm+bounces-13313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 143A38948A2
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 03:16:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42EEB1C2196E
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 01:16:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B99E6CA73;
	Tue,  2 Apr 2024 01:16:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F1CB6FD9;
	Tue,  2 Apr 2024 01:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712020561; cv=none; b=GhblaXKWhzLeT5F4jceQ0T2K9xDLc3Ig5UMJC9rRr1N3EppVhUPwbQRFc6WhILB5xZ71z4AfvCq0+ogGVcD2IvWXw29AYmltRzuJV4dPrdEY4aHpUnRlS/JRaC+jNGG2mU2SegMYw9QaS8YkPcPqd4p/hXexP3mBSC7gaOAoJlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712020561; c=relaxed/simple;
	bh=8xe9EHnD1Z7Ql0v2jfMirkIGsHMGEqtuaUuaCXmxea4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=r3VF/Ky781p16lecqQSdwVAl0YBasq4Y06p5RuIdtk1Jd+0xFYjRThjUyYqMyRwLw7gAZAYZ9kEB8ooZDZndFZguijdKgNLkWnTdhqMU3Tpu7Y7KtJxxWiyQWRYCZjDylAOHIoKW8b92YIZOxG5H3clrGF/7C80BQ3koOGzIJC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8AxafBMXAtmRSgiAA--.13600S3;
	Tue, 02 Apr 2024 09:15:56 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxxxFHXAtmbT5xAA--.12076S3;
	Tue, 02 Apr 2024 09:15:53 +0800 (CST)
Subject: Re: [PATCH v7 7/7] Documentation: KVM: Add hypercall for LoongArch
To: WANG Xuerui <kernel@xen0n.name>, Huacai Chen <chenhuacai@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org
References: <20240315080710.2812974-1-maobibo@loongson.cn>
 <20240315081104.2813031-1-maobibo@loongson.cn>
 <68473508-dbf1-4875-a392-88ca09f7ea63@xen0n.name>
From: maobibo <maobibo@loongson.cn>
Message-ID: <0bdcaf41-c54d-9f39-0dd2-3b3d2a954649@loongson.cn>
Date: Tue, 2 Apr 2024 09:15:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <68473508-dbf1-4875-a392-88ca09f7ea63@xen0n.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxxxFHXAtmbT5xAA--.12076S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9xXoWrtr4xCw17tFy7CF18Zr4fZwc_yoWDKFgEv3
	y0qF4UGws0gr4293W8Cr43XrW2vFWDGryIqw4qqasrZryftayDGFWDur93CF4xJFW3Jr1Y
	93Z0gw4S9wnruosvyTuYvTs0mTUanT9S1TB71UUUUj7qnTZGkaVYY2UrUUUUj1kv1TuYvT
	s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
	cSsGvfJTRUUUbDkYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
	vaj40_Wr0E3s1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r4j6F4UM28EF7xvwVC2z280aVCY1x0267AKxVW8
	JVW8Jr1ln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2
	x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1D
	McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7
	I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCF
	x2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r
	1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij
	64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr
	0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF
	0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8Dl1DUUUUU==



On 2024/3/24 上午2:40, WANG Xuerui wrote:
> On 3/15/24 16:11, Bibo Mao wrote:
>> [snip]
>> +KVM hypercall ABI
>> +=================
>> +
>> +Hypercall ABI on KVM is simple, only one scratch register a0 and at most
>> +five generic registers used as input parameter. FP register and 
>> vector register
>> +is not used for input register and should not be modified during 
>> hypercall.
>> +Hypercall function can be inlined since there is only one scratch 
>> register.
> 
> Maybe it's better to describe the list of preserved registers with an 
> expression such as "all non-GPR registers shall remain unmodified after 
> returning from the hypercall", to guard ourselves against future ISA 
> state additions.
Sorry, I do not understand. What is the meaning of "all non-GPR 
registers"?  Can you give an example?

Regards
Bibo Mao
> 
> But I still maintain that it's better to promise less here, and only 
> hint on the extensive preservation of context as an implementation 
> detail. It is for not losing our ability to save/restore less in the 
> future, should we decide to do so.
> 


