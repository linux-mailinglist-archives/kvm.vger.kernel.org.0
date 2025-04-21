Return-Path: <kvm+bounces-43707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B4948A94A13
	for <lists+kvm@lfdr.de>; Mon, 21 Apr 2025 02:52:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E107616F2CA
	for <lists+kvm@lfdr.de>; Mon, 21 Apr 2025 00:52:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C3191E531;
	Mon, 21 Apr 2025 00:52:18 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB7FFB652;
	Mon, 21 Apr 2025 00:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745196737; cv=none; b=R7uH2uk5lcmaYPPPETawImriCRXbpkDrk8B49AepUDeKR1Gy3wz+7XLZztbcUZEdTO88mT/G/4eNfjuYxV9rasr1AkWlq7C+2rUc6UAtNM8McnG6FO2mNONBNk2jhXP98n0CYZso5AyYDXt8NoEujlgXEqe/QADCJmQkHHZkF6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745196737; c=relaxed/simple;
	bh=Lv624GVjzZQJWZb5+uyT/JpL2YlsxWpae3WOCk6M7Bs=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=sVw5mwTp2WPiEZVfert75BTGOBfgkB5udFrPJgL3vNs+gi+caSDerRnoQ3OrFJmz7kjWQfCOgA2FsvewN3XbO+LRQmASS8+1rJciOrucFNglsOpk87wrLCu8ifNW+jRvdoMPewlnlxYvL/vRsCPfjB6PaSZIaqEPGQvABrJGu9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8BxlmmzlgVoKSHDAA--.60571S3;
	Mon, 21 Apr 2025 08:52:03 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMAxzxuulgVoepGNAA--.37780S3;
	Mon, 21 Apr 2025 08:52:01 +0800 (CST)
Subject: Re: [PATCH] LoongArch: Fixed multiple typos of KVM code
To: WangYuli <wangyuli@uniontech.com>, Yulong Han <wheatfox17@icloud.com>,
 zhaotianrui@loongson.cn, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>
Cc: loongarch@lists.linux.dev, Xianglai Li <lixianglai@loongson.cn>,
 Min Zhou <zhoumin@loongson.cn>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250420142208.2252280-1-wheatfox17@icloud.com>
 <B9FBAB180AE77BDB+52e0b4e7-58fa-4047-a35d-c2d00bc1f5bf@uniontech.com>
From: bibo mao <maobibo@loongson.cn>
Message-ID: <59895b61-9d63-9d60-63da-5524b4dcfe2b@loongson.cn>
Date: Mon, 21 Apr 2025 08:50:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <B9FBAB180AE77BDB+52e0b4e7-58fa-4047-a35d-c2d00bc1f5bf@uniontech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMAxzxuulgVoepGNAA--.37780S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxCF1rAr45KryfAw1UJr4rtFc_yoW5ZFy5pr
	1kAa4DArWrGr1kGr9rJw1UZFyUJry8tw18Xr1DJFyUCr42vr1vqrW0qryqgFn8Jw48Jr48
	Xw1UJrnxZF1UJwcCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	XVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jepB-UUUUU=

Yulong,

Sorry for the late response, I do not notice this until reply from Yuli.
Thanks for patch.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>


On 2025/4/20 下午11:40, WangYuli wrote:
> [ Expanded the recipient list.  ]
> 
> Hi Yulong,
> 
> On 2025/4/20 22:22, Yulong Han wrote:
>> Fixed multiple typos inside arch/loongarch/kvm.
>>
>> Signed-off-by: Yulong Han <wheatfox17@icloud.com>
>> ---
>>   arch/loongarch/kvm/intc/ipi.c | 4 ++--
>>   arch/loongarch/kvm/main.c     | 4 ++--
>>   2 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/loongarch/kvm/intc/ipi.c 
>> b/arch/loongarch/kvm/intc/ipi.c
>> index 93f4acd44..fe734dc06 100644
>> --- a/arch/loongarch/kvm/intc/ipi.c
>> +++ b/arch/loongarch/kvm/intc/ipi.c
>> @@ -111,7 +111,7 @@ static int send_ipi_data(struct kvm_vcpu *vcpu, 
>> gpa_t addr, uint64_t data)
>>           ret = kvm_io_bus_read(vcpu, KVM_IOCSR_BUS, addr, 
>> sizeof(val), &val);
>>           srcu_read_unlock(&vcpu->kvm->srcu, idx);
>>           if (unlikely(ret)) {
>> -            kvm_err("%s: : read date from addr %llx failed\n", 
>> __func__, addr);
>> +            kvm_err("%s: : read data from addr %llx failed\n", 
>> __func__, addr);
>>               return ret;
>>           }
>>           /* Construct the mask by scanning the bit 27-30 */
>> @@ -127,7 +127,7 @@ static int send_ipi_data(struct kvm_vcpu *vcpu, 
>> gpa_t addr, uint64_t data)
>>       ret = kvm_io_bus_write(vcpu, KVM_IOCSR_BUS, addr, sizeof(val), 
>> &val);
>>       srcu_read_unlock(&vcpu->kvm->srcu, idx);
>>       if (unlikely(ret))
>> -        kvm_err("%s: : write date to addr %llx failed\n", __func__, 
>> addr);
>> +        kvm_err("%s: : write data to addr %llx failed\n", __func__, 
>> addr);
>>       return ret;
>>   }
>> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
>> index d165cd38c..80ea63d46 100644
>> --- a/arch/loongarch/kvm/main.c
>> +++ b/arch/loongarch/kvm/main.c
>> @@ -296,10 +296,10 @@ int kvm_arch_enable_virtualization_cpu(void)
>>       /*
>>        * Enable virtualization features granting guest direct control of
>>        * certain features:
>> -     * GCI=2:       Trap on init or unimplement cache instruction.
>> +     * GCI=2:       Trap on init or unimplemented cache instruction.
>>        * TORU=0:      Trap on Root Unimplement.
>>        * CACTRL=1:    Root control cache.
>> -     * TOP=0:       Trap on Previlege.
>> +     * TOP=0:       Trap on Privilege.
>>        * TOE=0:       Trap on Exception.
>>        * TIT=0:       Trap on Timer.
>>        */
> Reviewed-by: Yuli Wang <wangyuli@uniontech.com>
> 
> Please note that if you wish for a timely response to your patch, you 
> should ensure that all maintainers output by ./scripts/get_maintainer.pl 
> and the relevant open mailing lists are fully present in your recipient 
> list.
> 
> Thanks,


