Return-Path: <kvm+bounces-66902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E09ECCEBBBB
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 11:04:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 29D013031958
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 10:04:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 134243195E3;
	Wed, 31 Dec 2025 10:04:03 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA43D299A82;
	Wed, 31 Dec 2025 10:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767175442; cv=none; b=H0QTOzQpIhixK0A5t7iWfBaUEO37aHvBEXxk3ubwvmPcmmAZopmy9wIEspNIDXkzMEOMZm6ZnxWxSPjEQEd3y18OrCEzG72Vz4BxZ4bXP4QA3rxVK8cw6+qUKarbuQSeO1jtFV7+BimlhF2U6Crt0MjHu/HX8pCZkB+8Z58jqV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767175442; c=relaxed/simple;
	bh=BL5UMvpBM99dQxCTWMRBK9IgaJ0KfoM+mWbJCQ02AQc=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=IQlUOpgHLoSM6eC3cRnU483fL20nN2bPj8WeEoDg/xb8uJGgDw/m/Ij+CK0CI8rARm5eIUd/xaZZHA5Hx7nOjqIXhzzmksnUU0bw5Hu7KcxQ/Zyx+ZeYnXOl+sN1HiIZWbGOyjeXKsYM18Mz78reKpNDmvT/sPEtzJ3AXZH6UW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Bx28IL9VRppqIEAA--.14241S3;
	Wed, 31 Dec 2025 18:03:55 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJCxOMEF9VRp988HAA--.5668S3;
	Wed, 31 Dec 2025 18:03:53 +0800 (CST)
Subject: Re: [PATCH] LoongArch: KVM: Add more CPUCFG mask bit
To: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20251231020227.1526779-1-maobibo@loongson.cn>
 <CAAhV-H4CU1Ct8ZcxpZcMEZy7uL-wPmkxVhJwEWQdy0rpBAo8fg@mail.gmail.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <1599cfd8-370b-4dec-5434-4845249c3533@loongson.cn>
Date: Wed, 31 Dec 2025 18:01:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H4CU1Ct8ZcxpZcMEZy7uL-wPmkxVhJwEWQdy0rpBAo8fg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxOMEF9VRp988HAA--.5668S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxGr1Dtw1fWw45CFykGry7twc_yoW5ur4fpr
	yUAF4DWF4UKr4ftw1vqas0gF17XrZ7Gr12vF1Fv34kCFsrt3Wxur18KFZxAFy5X34kCF10
	9as5W3WYva4Dt3gCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9Sb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv
	67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C2
	67AKxVWUXVWUAwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI
	8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWU
	CwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBI
	daVFxhVjvjDU0xZFpf9x07jnUUUUUUUU=



On 2025/12/31 下午5:57, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Wed, Dec 31, 2025 at 10:02 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> With LA664 CPU there are more features supported which are indicated
>> in CPUCFG2 bit24:30 and CPUCFG3 bit17 and bit 23. These features do
>> not depend on KVM and there is no KVM exception when it is used in
>> VM mode.
>>
>> Here add more CPUCFG mask support with LA664 if VM is configured with
>> host CPU model.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/include/asm/loongarch.h |  7 +++++++
>>   arch/loongarch/kvm/vcpu.c              | 11 +++++++++++
>>   2 files changed, 18 insertions(+)
>>
>> diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
>> index e6b8ff61c8cc..553c4dc7a156 100644
>> --- a/arch/loongarch/include/asm/loongarch.h
>> +++ b/arch/loongarch/include/asm/loongarch.h
>> @@ -94,6 +94,12 @@
>>   #define  CPUCFG2_LSPW                  BIT(21)
>>   #define  CPUCFG2_LAM                   BIT(22)
>>   #define  CPUCFG2_PTW                   BIT(24)
>> +#define  CPUCFG2_FRECIPE               BIT(25)
>> +#define  CPUCFG2_DIV32                 BIT(26)
>> +#define  CPUCFG2_LAM_BH                        BIT(27)
>> +#define  CPUCFG2_LAMCAS                        BIT(28)
>> +#define  CPUCFG2_LLACQ_SCREL           BIT(29)
>> +#define  CPUCFG2_SCQ                   BIT(30)
>>
>>   #define LOONGARCH_CPUCFG3              0x3
>>   #define  CPUCFG3_CCDMA                 BIT(0)
>> @@ -108,6 +114,7 @@
>>   #define  CPUCFG3_SPW_HG_HF             BIT(11)
>>   #define  CPUCFG3_RVA                   BIT(12)
>>   #define  CPUCFG3_RVAMAX                        GENMASK(16, 13)
>> +#define  CPUCFG3_DBAR_HINTS            BIT(17)
>>   #define  CPUCFG3_ALDORDER_CAP          BIT(18) /* All address load ordered, capability */
>>   #define  CPUCFG3_ASTORDER_CAP          BIT(19) /* All address store ordered, capability */
>>   #define  CPUCFG3_ALDORDER_STA          BIT(20) /* All address load ordered, status */
> I applied the first part because it both needed by KVM and George's patch:
> https://lore.kernel.org/loongarch/20251231034523.47014-1-dongtai.guo@linux.dev/T/#u
ok, thanks.

I will rebase patch based on new version once the first part is merged.

Regards
Bibo Mao
> 
> Huacai
> 
>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>> index 656b954c1134..9d186004670c 100644
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
>> @@ -684,9 +686,18 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
>>                  if (cpu_has_ptw)
>>                          *v |= CPUCFG2_PTW;
>>
>> +               /*
>> +                * Some features depends on host and they are irrelative with
>> +                * KVM hypervisor
>> +                */
>> +               config = read_cpucfg(LOONGARCH_CPUCFG2);
>> +               *v |= config & (CPUCFG2_FRECIPE | CPUCFG2_DIV32 | CPUCFG2_LAM_BH);
>> +               *v |= config & (CPUCFG2_LAMCAS | CPUCFG2_LLACQ_SCREL | CPUCFG2_SCQ);
>>                  return 0;
>>          case LOONGARCH_CPUCFG3:
>>                  *v = GENMASK(16, 0);
>> +               config = read_cpucfg(LOONGARCH_CPUCFG3);
>> +               *v |= config & (CPUCFG3_DBAR_HINTS | CPUCFG3_SLDORDER_STA);
>>                  return 0;
>>          case LOONGARCH_CPUCFG4:
>>          case LOONGARCH_CPUCFG5:
>>
>> base-commit: dbf8fe85a16a33d6b6bd01f2bc606fc017771465
>> --
>> 2.39.3
>>
>>


