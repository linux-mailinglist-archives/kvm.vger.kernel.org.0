Return-Path: <kvm+bounces-22287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9214093CE4B
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 08:50:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C1D3C1C21107
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 06:50:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFCC7176237;
	Fri, 26 Jul 2024 06:50:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB97817623A;
	Fri, 26 Jul 2024 06:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721976620; cv=none; b=QGWoaBA/umowFV2GrF18UA4QOeuUpNe8q8yCrdur3ZBIzRaNvf7WqQJsWeJVFp082PWiOifgKIiHxDtlwE+9iQxej/idIDDUcF//tgC/AYJQjQV9xFAtKkGio1f6xJqp+Wcu9mtO6p9IXp0YcMLPuL/TWzEO334kjJYEK87F9Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721976620; c=relaxed/simple;
	bh=yuY8lQr4XJsFDjEBO/51xJBBFKCJZKqleGTBLoabv8k=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=O88+Pc+sdhGl+L2/lftxDzzxNirgKMMcq1/UIq2Fum9wPSpquEV9CmMPNfIDlriDIhef1c765gKuR4TMYSgcNs8QHmlFploJznupy53Xp2zCUOwnJTh0ZsKlfQXxOF1nIK19pZ+vp2lcIuT+X6iU8p1orqi7ylKXChcpFk/vUfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8AxmOkjR6NmnvcBAA--.5838S3;
	Fri, 26 Jul 2024 14:50:11 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMDxa+UgR6NmT1oCAA--.13636S3;
	Fri, 26 Jul 2024 14:50:11 +0800 (CST)
Subject: Re: [PATCH] KVM: Loongarch: Remove undefined a6 argument comment for
 kvm_hypercall
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Dandan Zhang <zhangdandan@uniontech.com>, zhaotianrui@loongson.cn,
 kernel@xen0n.name, kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, wangyuli@uniontech.com,
 Wentao Guan <guanwentao@uniontech.com>
References: <6D5128458C9E19E4+20240725134820.55817-1-zhangdandan@uniontech.com>
 <c40854ac-38ef-4781-6c6b-4f74e24f265c@loongson.cn>
 <CAAhV-H5R_kamf=YJ62hb+iFr7Y+cvCaBBrY1rdk_wEEq4+6D_w@mail.gmail.com>
 <a9245b66-be6e-7211-49dd-a9a2d23ec2cf@loongson.cn>
 <CAAhV-H7Op_W0B7d4uQQVU_BEkpyQmwf9TCxQA9bYx3=JrQZ8pg@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <9bad6e47-dac5-82d2-1828-57df3ec840f8@loongson.cn>
Date: Fri, 26 Jul 2024 14:50:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H7Op_W0B7d4uQQVU_BEkpyQmwf9TCxQA9bYx3=JrQZ8pg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMDxa+UgR6NmT1oCAA--.13636S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxXF1Uuw4rJF4ruFy8Jr15Jrc_yoW5GFyDpF
	ZxC3WDCF48Kr1xCw1xt3s8uryavrWkKw12gF15Wry5Arnxtr1fJr48tF4UCF1kZayrJF10
	qFyag3WfZFyUA3gCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9Sb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv
	67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C2
	67AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI
	8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWU
	CwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBI
	daVFxhVjvjDU0xZFpf9x07jYSoJUUUUU=



On 2024/7/26 下午2:32, Huacai Chen wrote:
> On Fri, Jul 26, 2024 at 11:35 AM maobibo <maobibo@loongson.cn> wrote:
>>
>>
>>
>> On 2024/7/26 上午10:55, Huacai Chen wrote:
>>> On Fri, Jul 26, 2024 at 9:49 AM maobibo <maobibo@loongson.cn> wrote:
>>>>
>>>>
>>>>
>>>> On 2024/7/25 下午9:48, Dandan Zhang wrote:
>>>>> The kvm_hypercall set for LoongArch is limited to a1-a5.
>>>>> The mention of a6 in the comment is undefined that needs to be rectified.
>>>>>
>>>>> Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
>>>>> Signed-off-by: Dandan Zhang <zhangdandan@uniontech.com>
>>>>> ---
>>>>>     arch/loongarch/include/asm/kvm_para.h | 4 ++--
>>>>>     1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/include/asm/kvm_para.h
>>>>> index 335fb86778e2..43ec61589e6c 100644
>>>>> --- a/arch/loongarch/include/asm/kvm_para.h
>>>>> +++ b/arch/loongarch/include/asm/kvm_para.h
>>>>> @@ -39,9 +39,9 @@ struct kvm_steal_time {
>>>>>      * Hypercall interface for KVM hypervisor
>>>>>      *
>>>>>      * a0: function identifier
>>>>> - * a1-a6: args
>>>>> + * a1-a5: args
>>>>>      * Return value will be placed in a0.
>>>>> - * Up to 6 arguments are passed in a1, a2, a3, a4, a5, a6.
>>>>> + * Up to 5 arguments are passed in a1, a2, a3, a4, a5.
>>>>>      */
>>>>>     static __always_inline long kvm_hypercall0(u64 fid)
>>>>>     {
>>>>>
>>>>
>>>> Dandan,
>>>>
>>>> Nice catch. In future hypercall abi may expand such as the number of
>>>> input register and output register, or async hypercall function if there
>>>> is really such requirement.
>>>>
>>>> Anyway the modification is deserved and it is enough to use now, thanks
>>>> for doing it.
>>>>
>>>> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
>>> Maybe it is better to implement kvm_hypercall6() than remove a6 now?
>> That is one option also. The main reason is that there is no such
>> requirement in near future :(, I prefer to removing the annotation and
>> keeping it clean.
> I don't like removing something and then adding it back again, so if
> kvm_hypercall6() is needed in future, it is better to add it now.
I do not see the requirement by now.

At the same time I just suggest you care about LoongArch kernel and 
catch up the gap, just go forward rather than go around. Is it 
responsibility of maintainer to catch future direction?

Thanks for merging LoongArch KVM code at beginning, and I think I can 
merge LoongArch kvm kernel to KVM tree directly just like KVM 
x86/ARM64/RISCV.

Regards
Bibo

> 
> Huacai
>>
>> Regards
>> Bibo Mao
>>>
>>> Huacai
>>>>
>>
>>


