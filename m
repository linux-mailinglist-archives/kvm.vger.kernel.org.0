Return-Path: <kvm+bounces-37673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D2B5CA2E430
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 07:33:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6FF3616640A
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 06:33:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43B59199FBA;
	Mon, 10 Feb 2025 06:33:37 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 943D624339A;
	Mon, 10 Feb 2025 06:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739169216; cv=none; b=GQPWbRKbyDfTXSiJE24CAaUBqIv3Cp4IKABbuBwI2BTlQiviivSIy1Dcxzo6JJxf0hnpNXnshGwGOG22+1QqOXdWDMkU30eJxf93hmONNh85F490Ai3BxqNPTnXswgXdpIpVrz10JTI6c7SMUAqi8+1L33ELXtfgxTHpzYRUMaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739169216; c=relaxed/simple;
	bh=at0Q2hWKA0LY8IG5O59bOvOTzVv3ODdbsKuhDwctDa4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=SCR/SjxjVwtqdnbHYTM8qui+0zNm1CSh2/y5JUBydP/ikuWL2y+iqrESPCgSsqC4vk+Gwx/zHN4FI7vlqsYyLPS+oaPCNWuqWeLlAjxoxZhu3UJy8RFnQ3m1Co6rkrluTESGL251S4YbX1lttNuuO9ljJan5JKP3IGYMpWr70jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8BxuuC7nalnxP5wAA--.24467S3;
	Mon, 10 Feb 2025 14:33:31 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMAxj8W4naln98gJAA--.38442S3;
	Mon, 10 Feb 2025 14:33:30 +0800 (CST)
Subject: Re: [PATCH 1/3] LoongArch: KVM: Fix typo issue about GCFG feature
 detection
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250207032634.2333300-1-maobibo@loongson.cn>
 <20250207032634.2333300-2-maobibo@loongson.cn>
 <CAAhV-H7p9G8At3Pz_o31u_Zpho2gfbe6WOxF6_WpebVfcfgaKQ@mail.gmail.com>
 <30caead6-5b12-638c-677d-dc1111aea43c@loongson.cn>
 <CAAhV-H43Y4-oN9SVDWBhQ7nunYS08r5at+hVbtsdbWmKGDBMZw@mail.gmail.com>
From: bibo mao <maobibo@loongson.cn>
Message-ID: <ded29573-45a7-3d27-fe38-a27da9576180@loongson.cn>
Date: Mon, 10 Feb 2025 14:32:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H43Y4-oN9SVDWBhQ7nunYS08r5at+hVbtsdbWmKGDBMZw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMAxj8W4naln98gJAA--.38442S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3Jw4xXF4DKFWrXrW7CrWDJrc_yoWxuw15pr
	yYka43Jr40qr4fW3sFgwnYqw12qryxJ34q9F1UJryrtr1jga1IkFn0qa1FyrySq3Z3JF1U
	trn29w13ZFZ8A3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv
	67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw
	1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07j8
	yCJUUUUU=



On 2025/2/10 上午11:58, Huacai Chen wrote:
> On Mon, Feb 10, 2025 at 9:42 AM bibo mao <maobibo@loongson.cn> wrote:
>>
>>
>>
>> On 2025/2/9 下午5:38, Huacai Chen wrote:
>>> Hi, Bibo,
>>>
>>> On Fri, Feb 7, 2025 at 11:26 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>>>
>>>> This is typo issue about GCFG feature macro, comments is added for
>>>> these macro and typo issue is fixed here.
>>>>
>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>>> ---
>>>>    arch/loongarch/include/asm/loongarch.h | 26 ++++++++++++++++++++++++++
>>>>    arch/loongarch/kvm/main.c              |  4 ++--
>>>>    2 files changed, 28 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
>>>> index 52651aa0e583..1a65b5a7d54a 100644
>>>> --- a/arch/loongarch/include/asm/loongarch.h
>>>> +++ b/arch/loongarch/include/asm/loongarch.h
>>>> @@ -502,49 +502,75 @@
>>>>    #define LOONGARCH_CSR_GCFG             0x51    /* Guest config */
>>>>    #define  CSR_GCFG_GPERF_SHIFT          24
>>>>    #define  CSR_GCFG_GPERF_WIDTH          3
>>>> +/* Number PMU register started from PM0 passthrough to VM */
>>>>    #define  CSR_GCFG_GPERF                        (_ULCAST_(0x7) << CSR_GCFG_GPERF_SHIFT)
>>>> +#define  CSR_GCFG_GPERFP_SHIFT         23
>>>> +/* Read-only bit: show PMU passthrough supported or not */
>>>> +#define  CSR_GCFG_GPERFP               (_ULCAST_(0x1) << CSR_GCFG_GPERFP_SHIFT)
>>>>    #define  CSR_GCFG_GCI_SHIFT            20
>>>>    #define  CSR_GCFG_GCI_WIDTH            2
>>>>    #define  CSR_GCFG_GCI                  (_ULCAST_(0x3) << CSR_GCFG_GCI_SHIFT)
>>>> +/* All cacheop instructions will trap to host */
>>>>    #define  CSR_GCFG_GCI_ALL              (_ULCAST_(0x0) << CSR_GCFG_GCI_SHIFT)
>>>> +/* Cacheop instruction except hit invalidate will trap to host */
>>>>    #define  CSR_GCFG_GCI_HIT              (_ULCAST_(0x1) << CSR_GCFG_GCI_SHIFT)
>>>> +/* Cacheop instruction except hit and index invalidate will trap to host */
>>>>    #define  CSR_GCFG_GCI_SECURE           (_ULCAST_(0x2) << CSR_GCFG_GCI_SHIFT)
>>>>    #define  CSR_GCFG_GCIP_SHIFT           16
>>>>    #define  CSR_GCFG_GCIP                 (_ULCAST_(0xf) << CSR_GCFG_GCIP_SHIFT)
>>>> +/* Read-only bit: show feature CSR_GCFG_GCI_ALL supported or not */
>>>>    #define  CSR_GCFG_GCIP_ALL             (_ULCAST_(0x1) << CSR_GCFG_GCIP_SHIFT)
>>>> +/* Read-only bit: show feature CSR_GCFG_GCI_HIT supported or not */
>>>>    #define  CSR_GCFG_GCIP_HIT             (_ULCAST_(0x1) << (CSR_GCFG_GCIP_SHIFT + 1))
>>>> +/* Read-only bit: show feature CSR_GCFG_GCI_SECURE supported or not */
>>>>    #define  CSR_GCFG_GCIP_SECURE          (_ULCAST_(0x1) << (CSR_GCFG_GCIP_SHIFT + 2))
>>>>    #define  CSR_GCFG_TORU_SHIFT           15
>>>> +/* Operation with CSR register unimplemented will trap to host */
>>>>    #define  CSR_GCFG_TORU                 (_ULCAST_(0x1) << CSR_GCFG_TORU_SHIFT)
>>>>    #define  CSR_GCFG_TORUP_SHIFT          14
>>>> +/* Read-only bit: show feature CSR_GCFG_TORU supported or not */
>>>>    #define  CSR_GCFG_TORUP                        (_ULCAST_(0x1) << CSR_GCFG_TORUP_SHIFT)
>>>>    #define  CSR_GCFG_TOP_SHIFT            13
>>>> +/* Modificattion with CRMD.PLV will trap to host */
>>>>    #define  CSR_GCFG_TOP                  (_ULCAST_(0x1) << CSR_GCFG_TOP_SHIFT)
>>>>    #define  CSR_GCFG_TOPP_SHIFT           12
>>>> +/* Read-only bit: show feature CSR_GCFG_TOP supported or not */
>>>>    #define  CSR_GCFG_TOPP                 (_ULCAST_(0x1) << CSR_GCFG_TOPP_SHIFT)
>>>>    #define  CSR_GCFG_TOE_SHIFT            11
>>>> +/* ertn instruction will trap to host */
>>>>    #define  CSR_GCFG_TOE                  (_ULCAST_(0x1) << CSR_GCFG_TOE_SHIFT)
>>>>    #define  CSR_GCFG_TOEP_SHIFT           10
>>>> +/* Read-only bit: show feature CSR_GCFG_TOE supported or not */
>>>>    #define  CSR_GCFG_TOEP                 (_ULCAST_(0x1) << CSR_GCFG_TOEP_SHIFT)
>>>>    #define  CSR_GCFG_TIT_SHIFT            9
>>>> +/* Timer instruction such as rdtime/TCFG/TVAL will trap to host */
>>>>    #define  CSR_GCFG_TIT                  (_ULCAST_(0x1) << CSR_GCFG_TIT_SHIFT)
>>>>    #define  CSR_GCFG_TITP_SHIFT           8
>>>> +/* Read-only bit: show feature CSR_GCFG_TIT supported or not */
>>>>    #define  CSR_GCFG_TITP                 (_ULCAST_(0x1) << CSR_GCFG_TITP_SHIFT)
>>>>    #define  CSR_GCFG_SIT_SHIFT            7
>>>> +/* All privilege instruction will trap to host */
>>>>    #define  CSR_GCFG_SIT                  (_ULCAST_(0x1) << CSR_GCFG_SIT_SHIFT)
>>>>    #define  CSR_GCFG_SITP_SHIFT           6
>>>> +/* Read-only bit: show feature CSR_GCFG_SIT supported or not */
>>>>    #define  CSR_GCFG_SITP                 (_ULCAST_(0x1) << CSR_GCFG_SITP_SHIFT)
>>>>    #define  CSR_GCFG_MATC_SHITF           4
>>>>    #define  CSR_GCFG_MATC_WIDTH           2
>>>>    #define  CSR_GCFG_MATC_MASK            (_ULCAST_(0x3) << CSR_GCFG_MATC_SHITF)
>>>> +/* Cache attribute comes from GVA->GPA mapping */
>>>>    #define  CSR_GCFG_MATC_GUEST           (_ULCAST_(0x0) << CSR_GCFG_MATC_SHITF)
>>>> +/* Cache attribute comes from GPA->HPA mapping */
>>>>    #define  CSR_GCFG_MATC_ROOT            (_ULCAST_(0x1) << CSR_GCFG_MATC_SHITF)
>>>> +/* Cache attribute comes from weaker one of GVA->GPA and GPA->HPA mapping */
>>>>    #define  CSR_GCFG_MATC_NEST            (_ULCAST_(0x2) << CSR_GCFG_MATC_SHITF)
>>>>    #define  CSR_GCFG_MATP_NEST_SHIFT      2
>>>> +/* Read-only bit: show feature CSR_GCFG_MATC_NEST supported or not */
>>>>    #define  CSR_GCFG_MATP_NEST            (_ULCAST_(0x1) << CSR_GCFG_MATP_NEST_SHIFT)
>>>>    #define  CSR_GCFG_MATP_ROOT_SHIFT      1
>>>> +/* Read-only bit: show feature CSR_GCFG_MATC_ROOT supported or not */
>>>>    #define  CSR_GCFG_MATP_ROOT            (_ULCAST_(0x1) << CSR_GCFG_MATP_ROOT_SHIFT)
>>>>    #define  CSR_GCFG_MATP_GUEST_SHIFT     0
>>>> +/* Read-only bit: show feature CSR_GCFG_MATC_GUEST suppoorted or not */
>>>>    #define  CSR_GCFG_MATP_GUEST           (_ULCAST_(0x1) << CSR_GCFG_MATP_GUEST_SHIFT)
>>> Bugfix is the majority here, so it is better to remove the comments,
>>> make this patch easier to be backported to stable branches.
>> How about split the patch into two for better backporting? With comments
>> it is convinient to people to understand and provide LoongArch KVM
>> patches in future, after all it cannot depends on the few guys inside.
> I don't suggest splitting, just removing it is better (developers
> still need to read the user manual even if there are such comments).
> But if you insist, then keep it as is (keep this version).
Ok, I will remove comments . Put it in header file seems a temporary 
method :(

Regards
Bibo Mao

> 
> 
> 
> Huacai
>>
>> Regards
>> Bibo Mao
>>>
>>> Huacai
>>>
>>>>
>>>>    #define LOONGARCH_CSR_GINTC            0x52    /* Guest interrupt control */
>>>> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
>>>> index bf9268bf26d5..f6d3242b9234 100644
>>>> --- a/arch/loongarch/kvm/main.c
>>>> +++ b/arch/loongarch/kvm/main.c
>>>> @@ -303,9 +303,9 @@ int kvm_arch_enable_virtualization_cpu(void)
>>>>            * TOE=0:       Trap on Exception.
>>>>            * TIT=0:       Trap on Timer.
>>>>            */
>>>> -       if (env & CSR_GCFG_GCIP_ALL)
>>>> +       if (env & CSR_GCFG_GCIP_SECURE)
>>>>                   gcfg |= CSR_GCFG_GCI_SECURE;
>>>> -       if (env & CSR_GCFG_MATC_ROOT)
>>>> +       if (env & CSR_GCFG_MATP_ROOT)
>>>>                   gcfg |= CSR_GCFG_MATC_ROOT;
>>>>
>>>>           write_csr_gcfg(gcfg);
>>>> --
>>>> 2.39.3
>>>>
>>
>>


