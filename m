Return-Path: <kvm+bounces-69527-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kMTwOa4ve2n2CAIAu9opvQ
	(envelope-from <kvm+bounces-69527-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 11:00:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 54C1DAE4F3
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 11:00:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D6DAD30254CE
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 10:00:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 142033803DB;
	Thu, 29 Jan 2026 10:00:09 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A4B937FF74;
	Thu, 29 Jan 2026 10:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769680808; cv=none; b=SKtR2K3wkw4s2kbZBSPohmzak1XbXUAM93BoEvV3VwBCeB0CooJoCBMj0QzwtN0we0MpDQWq9+AJCmR2yKBSK10jQjMB64RkOaQWJ7fFUJbYfq+nO8tvmIV8PEdDzVqDIqzgEydt9s7RRaHbb9r/1h2bUDW62kWbDBuDn6lhVpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769680808; c=relaxed/simple;
	bh=QhjPT8u9EMDvaJX1Xa39xagGJLKCosmoYbIBrDlUvvU=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=fiQ45E+vLRtd0GivfsBhNixyRZQJ3WOfd+sL8wIVR6HWaGAonB1TyAXw8letP9pNkHFESNH205lkPOMD8nXzsHXAGryMPeiF0ykSaGHgjQRNJUDTEDhKCZS6MWs8rKK+W8UgCnOsd0x9E4edioqjSGw42jF+9GA67uYU5EaHSrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8CxMvGiL3tpvNwNAA--.45715S3;
	Thu, 29 Jan 2026 18:00:02 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJDxTMKeL3tp5Sc5AA--.41408S3;
	Thu, 29 Jan 2026 18:00:01 +0800 (CST)
Subject: Re: [PATCH v2] LoongArch: KVM: Add more CPUCFG mask bit
To: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20260126024840.2308379-1-maobibo@loongson.cn>
 <CAAhV-H66uH1TpaKTsqNtSqKYUDatJWj+zAuw-MYE88BqOF0XTA@mail.gmail.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <60b5e543-226c-3c15-09ed-c3c5ccfeb699@loongson.cn>
Date: Thu, 29 Jan 2026 17:57:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H66uH1TpaKTsqNtSqKYUDatJWj+zAuw-MYE88BqOF0XTA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxTMKeL3tp5Sc5AA--.41408S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxJFWrtFyfurW5Xw47GF15Awc_yoW5Gr1kpr
	Z29F4q9r4rKr4I9an2qrWDCr4ayrs7KFW7ZF92ya4DAFn8u3WxJr48KFWavFy5A348WF18
	uan5Ja4q9Fn8XacCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9ab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv
	67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C2
	67AKxVWUXVWUAwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI
	8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWU
	CwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsG
	vfC2KfnxnUUI43ZEXa7IU8j-e5UUUUU==
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	R_DKIM_NA(0.00)[];
	DMARC_NA(0.00)[loongson.cn];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maobibo@loongson.cn,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69527-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[loongson.cn:mid,loongson.cn:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 54C1DAE4F3
X-Rspamd-Action: no action



On 2026/1/29 下午5:26, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Mon, Jan 26, 2026 at 10:48 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> With LA664 CPU there are more features supported which are indicated
>> in CPUCFG2 bit24:30 and CPUCFG3 bit17 and bit 23. KVM hypervisor can
>> not enable or disable these features and there is no KVM exception
>> when instructions of these features are used in guest mode.
>>
>> Here add more CPUCFG mask support with LA664 CPU type.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>    1. Rebase on the latest version since some common CPUCFG bit macro
>>       definitions are merged.
>>    2. Modifiy the comments explaining why it comes from feature detect
>>       of host CPU.
>> ---
>>   arch/loongarch/kvm/vcpu.c | 15 +++++++++++++++
>>   1 file changed, 15 insertions(+)
>>
>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>> index 656b954c1134..a9608469fa7a 100644
>> --- a/arch/loongarch/kvm/vcpu.c
>> +++ b/arch/loongarch/kvm/vcpu.c
>> @@ -652,6 +652,8 @@ static int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 val)
>>
>>   static int _kvm_get_cpucfg_mask(int id, u64 *v)
>>   {
>> +       unsigned int config;
>> +
>>          if (id < 0 || id >= KVM_MAX_CPUCFG_REGS)
>>                  return -EINVAL;
>>
>> @@ -684,9 +686,22 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
>>                  if (cpu_has_ptw)
>>                          *v |= CPUCFG2_PTW;
>>
>> +               /*
>> +                * The capability indication of some features are the same
>> +                * between host CPU and guest vCPU, and there is no special
>> +                * feature detect method with vCPU. Also KVM hypervisor can
>> +                * not enable or disable these features.
>> +                *
>> +                * Here use host CPU detected features for vCPU
>> +                */
>> +               config = read_cpucfg(LOONGARCH_CPUCFG2);
>> +               *v |= config & (CPUCFG2_FRECIPE | CPUCFG2_DIV32 | CPUCFG2_LAM_BH);
>> +               *v |= config & (CPUCFG2_LAMCAS | CPUCFG2_LLACQ_SCREL | CPUCFG2_SCQ);
>>                  return 0;
>>          case LOONGARCH_CPUCFG3:
>>                  *v = GENMASK(16, 0);
>> +               config = read_cpucfg(LOONGARCH_CPUCFG3);
>> +               *v |= config & (CPUCFG3_DBAR_HINTS | CPUCFG3_SLDORDER_STA);
> What about adding CPUCFG3_ALDORDER_STA and CPUCFG3_ASTORDER_STA here, too?
I am ok to add these bits.

It is strange that there is both capability bit and status bit. AFAIK 
cpucfg is read-only, status bit means that it will change at runtime. I 
will negotiate with HW guys about these bits.

Regards
Bibo Mao
> 
> Huacai
> 
>>                  return 0;
>>          case LOONGARCH_CPUCFG4:
>>          case LOONGARCH_CPUCFG5:
>>
>> base-commit: 63804fed149a6750ffd28610c5c1c98cce6bd377
>> --
>> 2.39.3
>>
>>


