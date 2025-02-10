Return-Path: <kvm+bounces-37669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 91DF4A2E212
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 02:42:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AEB441887BCB
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 01:42:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DEEC225D7;
	Mon, 10 Feb 2025 01:42:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA6489461;
	Mon, 10 Feb 2025 01:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739151742; cv=none; b=DX0o5aKgvDivOj0DOfbIcseHy6xuIf3hsleljaUBP2xraUpODL6ecjJMU8eZwKwteNYipMKBn39VQGZw749p5jO1ZNR6BDkTY4zXI089JSC/oZEpmffHn7cHodeY2rZ+ROA3N2yMmM1hIGDBjA27Kcmqt0+X83BLNjK9opwvzSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739151742; c=relaxed/simple;
	bh=asVXNS3/8IWV+3hHCrQkdDFRVC5LyZdIRIpXzO80+Is=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=dA484dIfQZU2+nq22TVWXYESRFAjMzmJhcyuHTR+Qhe3JJx/VwpdKDTgxqiO4HlonvA3AQMN36BF3r8ncNtyu68gdQxy2/x2+I4FWV1LNiJU9cWO2ZiFCvK2DOr/w/VksiHoQEUXVRzQ8mLq5b5NmM3Ig/AyhMpO/apXTZ5PPg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8DxGeF3Walng9pwAA--.21859S3;
	Mon, 10 Feb 2025 09:42:15 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMCxLcVzWaln6nEJAA--.33606S3;
	Mon, 10 Feb 2025 09:42:13 +0800 (CST)
Subject: Re: [PATCH 1/3] LoongArch: KVM: Fix typo issue about GCFG feature
 detection
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250207032634.2333300-1-maobibo@loongson.cn>
 <20250207032634.2333300-2-maobibo@loongson.cn>
 <CAAhV-H7p9G8At3Pz_o31u_Zpho2gfbe6WOxF6_WpebVfcfgaKQ@mail.gmail.com>
From: bibo mao <maobibo@loongson.cn>
Message-ID: <30caead6-5b12-638c-677d-dc1111aea43c@loongson.cn>
Date: Mon, 10 Feb 2025 09:41:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H7p9G8At3Pz_o31u_Zpho2gfbe6WOxF6_WpebVfcfgaKQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMCxLcVzWaln6nEJAA--.33606S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3Gr1rGF15KF1rtw15tF4xAFc_yoWxGFW7pr
	98Ka43Gr40qr4fW3sxKrn8X3W5Xr1xJ3sI93WUGrWrtF1UWa1IkFn0qan5AFySqan3tFyU
	trs29w17XF4DZ3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv
	67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw
	1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8j-
	e5UUUUU==



On 2025/2/9 下午5:38, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Fri, Feb 7, 2025 at 11:26 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> This is typo issue about GCFG feature macro, comments is added for
>> these macro and typo issue is fixed here.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/include/asm/loongarch.h | 26 ++++++++++++++++++++++++++
>>   arch/loongarch/kvm/main.c              |  4 ++--
>>   2 files changed, 28 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
>> index 52651aa0e583..1a65b5a7d54a 100644
>> --- a/arch/loongarch/include/asm/loongarch.h
>> +++ b/arch/loongarch/include/asm/loongarch.h
>> @@ -502,49 +502,75 @@
>>   #define LOONGARCH_CSR_GCFG             0x51    /* Guest config */
>>   #define  CSR_GCFG_GPERF_SHIFT          24
>>   #define  CSR_GCFG_GPERF_WIDTH          3
>> +/* Number PMU register started from PM0 passthrough to VM */
>>   #define  CSR_GCFG_GPERF                        (_ULCAST_(0x7) << CSR_GCFG_GPERF_SHIFT)
>> +#define  CSR_GCFG_GPERFP_SHIFT         23
>> +/* Read-only bit: show PMU passthrough supported or not */
>> +#define  CSR_GCFG_GPERFP               (_ULCAST_(0x1) << CSR_GCFG_GPERFP_SHIFT)
>>   #define  CSR_GCFG_GCI_SHIFT            20
>>   #define  CSR_GCFG_GCI_WIDTH            2
>>   #define  CSR_GCFG_GCI                  (_ULCAST_(0x3) << CSR_GCFG_GCI_SHIFT)
>> +/* All cacheop instructions will trap to host */
>>   #define  CSR_GCFG_GCI_ALL              (_ULCAST_(0x0) << CSR_GCFG_GCI_SHIFT)
>> +/* Cacheop instruction except hit invalidate will trap to host */
>>   #define  CSR_GCFG_GCI_HIT              (_ULCAST_(0x1) << CSR_GCFG_GCI_SHIFT)
>> +/* Cacheop instruction except hit and index invalidate will trap to host */
>>   #define  CSR_GCFG_GCI_SECURE           (_ULCAST_(0x2) << CSR_GCFG_GCI_SHIFT)
>>   #define  CSR_GCFG_GCIP_SHIFT           16
>>   #define  CSR_GCFG_GCIP                 (_ULCAST_(0xf) << CSR_GCFG_GCIP_SHIFT)
>> +/* Read-only bit: show feature CSR_GCFG_GCI_ALL supported or not */
>>   #define  CSR_GCFG_GCIP_ALL             (_ULCAST_(0x1) << CSR_GCFG_GCIP_SHIFT)
>> +/* Read-only bit: show feature CSR_GCFG_GCI_HIT supported or not */
>>   #define  CSR_GCFG_GCIP_HIT             (_ULCAST_(0x1) << (CSR_GCFG_GCIP_SHIFT + 1))
>> +/* Read-only bit: show feature CSR_GCFG_GCI_SECURE supported or not */
>>   #define  CSR_GCFG_GCIP_SECURE          (_ULCAST_(0x1) << (CSR_GCFG_GCIP_SHIFT + 2))
>>   #define  CSR_GCFG_TORU_SHIFT           15
>> +/* Operation with CSR register unimplemented will trap to host */
>>   #define  CSR_GCFG_TORU                 (_ULCAST_(0x1) << CSR_GCFG_TORU_SHIFT)
>>   #define  CSR_GCFG_TORUP_SHIFT          14
>> +/* Read-only bit: show feature CSR_GCFG_TORU supported or not */
>>   #define  CSR_GCFG_TORUP                        (_ULCAST_(0x1) << CSR_GCFG_TORUP_SHIFT)
>>   #define  CSR_GCFG_TOP_SHIFT            13
>> +/* Modificattion with CRMD.PLV will trap to host */
>>   #define  CSR_GCFG_TOP                  (_ULCAST_(0x1) << CSR_GCFG_TOP_SHIFT)
>>   #define  CSR_GCFG_TOPP_SHIFT           12
>> +/* Read-only bit: show feature CSR_GCFG_TOP supported or not */
>>   #define  CSR_GCFG_TOPP                 (_ULCAST_(0x1) << CSR_GCFG_TOPP_SHIFT)
>>   #define  CSR_GCFG_TOE_SHIFT            11
>> +/* ertn instruction will trap to host */
>>   #define  CSR_GCFG_TOE                  (_ULCAST_(0x1) << CSR_GCFG_TOE_SHIFT)
>>   #define  CSR_GCFG_TOEP_SHIFT           10
>> +/* Read-only bit: show feature CSR_GCFG_TOE supported or not */
>>   #define  CSR_GCFG_TOEP                 (_ULCAST_(0x1) << CSR_GCFG_TOEP_SHIFT)
>>   #define  CSR_GCFG_TIT_SHIFT            9
>> +/* Timer instruction such as rdtime/TCFG/TVAL will trap to host */
>>   #define  CSR_GCFG_TIT                  (_ULCAST_(0x1) << CSR_GCFG_TIT_SHIFT)
>>   #define  CSR_GCFG_TITP_SHIFT           8
>> +/* Read-only bit: show feature CSR_GCFG_TIT supported or not */
>>   #define  CSR_GCFG_TITP                 (_ULCAST_(0x1) << CSR_GCFG_TITP_SHIFT)
>>   #define  CSR_GCFG_SIT_SHIFT            7
>> +/* All privilege instruction will trap to host */
>>   #define  CSR_GCFG_SIT                  (_ULCAST_(0x1) << CSR_GCFG_SIT_SHIFT)
>>   #define  CSR_GCFG_SITP_SHIFT           6
>> +/* Read-only bit: show feature CSR_GCFG_SIT supported or not */
>>   #define  CSR_GCFG_SITP                 (_ULCAST_(0x1) << CSR_GCFG_SITP_SHIFT)
>>   #define  CSR_GCFG_MATC_SHITF           4
>>   #define  CSR_GCFG_MATC_WIDTH           2
>>   #define  CSR_GCFG_MATC_MASK            (_ULCAST_(0x3) << CSR_GCFG_MATC_SHITF)
>> +/* Cache attribute comes from GVA->GPA mapping */
>>   #define  CSR_GCFG_MATC_GUEST           (_ULCAST_(0x0) << CSR_GCFG_MATC_SHITF)
>> +/* Cache attribute comes from GPA->HPA mapping */
>>   #define  CSR_GCFG_MATC_ROOT            (_ULCAST_(0x1) << CSR_GCFG_MATC_SHITF)
>> +/* Cache attribute comes from weaker one of GVA->GPA and GPA->HPA mapping */
>>   #define  CSR_GCFG_MATC_NEST            (_ULCAST_(0x2) << CSR_GCFG_MATC_SHITF)
>>   #define  CSR_GCFG_MATP_NEST_SHIFT      2
>> +/* Read-only bit: show feature CSR_GCFG_MATC_NEST supported or not */
>>   #define  CSR_GCFG_MATP_NEST            (_ULCAST_(0x1) << CSR_GCFG_MATP_NEST_SHIFT)
>>   #define  CSR_GCFG_MATP_ROOT_SHIFT      1
>> +/* Read-only bit: show feature CSR_GCFG_MATC_ROOT supported or not */
>>   #define  CSR_GCFG_MATP_ROOT            (_ULCAST_(0x1) << CSR_GCFG_MATP_ROOT_SHIFT)
>>   #define  CSR_GCFG_MATP_GUEST_SHIFT     0
>> +/* Read-only bit: show feature CSR_GCFG_MATC_GUEST suppoorted or not */
>>   #define  CSR_GCFG_MATP_GUEST           (_ULCAST_(0x1) << CSR_GCFG_MATP_GUEST_SHIFT)
> Bugfix is the majority here, so it is better to remove the comments,
> make this patch easier to be backported to stable branches.
How about split the patch into two for better backporting? With comments 
it is convinient to people to understand and provide LoongArch KVM 
patches in future, after all it cannot depends on the few guys inside.

Regards
Bibo Mao
> 
> Huacai
> 
>>
>>   #define LOONGARCH_CSR_GINTC            0x52    /* Guest interrupt control */
>> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
>> index bf9268bf26d5..f6d3242b9234 100644
>> --- a/arch/loongarch/kvm/main.c
>> +++ b/arch/loongarch/kvm/main.c
>> @@ -303,9 +303,9 @@ int kvm_arch_enable_virtualization_cpu(void)
>>           * TOE=0:       Trap on Exception.
>>           * TIT=0:       Trap on Timer.
>>           */
>> -       if (env & CSR_GCFG_GCIP_ALL)
>> +       if (env & CSR_GCFG_GCIP_SECURE)
>>                  gcfg |= CSR_GCFG_GCI_SECURE;
>> -       if (env & CSR_GCFG_MATC_ROOT)
>> +       if (env & CSR_GCFG_MATP_ROOT)
>>                  gcfg |= CSR_GCFG_MATC_ROOT;
>>
>>          write_csr_gcfg(gcfg);
>> --
>> 2.39.3
>>


