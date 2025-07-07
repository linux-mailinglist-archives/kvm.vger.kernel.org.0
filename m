Return-Path: <kvm+bounces-51642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 685D7AFAA6B
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 05:53:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D105189B44B
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 03:53:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A861D25A334;
	Mon,  7 Jul 2025 03:53:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6FC51373;
	Mon,  7 Jul 2025 03:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751860409; cv=none; b=aC4n29DIII4pNy5MWpPyxWAHnDTWdJfH4leTgo6VVZH9JLCrcFPKznmfZIgPtQdkjOdZT1xCfNASSBHMGSQWEI2LIJLRUCZwCTO4lNw/rPdKC/NVV/V0rE3nBEosKoTDc/dF5Fi7zMEsbhp9HE1dhSGYJq4in/BGUitpQgPWz+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751860409; c=relaxed/simple;
	bh=VjKOmdNW8ives2UOA8eIRLWsGujxivGZIYKGG8g6MFQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=h7bJZP4RB2F9RKQoZxeHdrwlkIJTgnjHoLk9NXf1BBlnkKyz4JkbVbJsHpSFumtLRew0ZKLIcSVNXgWIrx0h474JYStRQbvYkmGDWjJNPbj9Hp8BCje8K5FMTk/gYAy9aK6MOtwJdUsTNOMzhc6cbnI9+MUD+UABwqWpnPK9nVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Bxnmu1RGtoqUkjAQ--.35471S3;
	Mon, 07 Jul 2025 11:53:25 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJAxT+ayRGtomlsMAA--.6415S3;
	Mon, 07 Jul 2025 11:53:24 +0800 (CST)
Subject: Re: [PATCH v5 00/13] LoongArch: KVM: Enhancement with eiointc
 emulation
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
 Xianglai Li <lixianglai@loongson.cn>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250701030842.1136519-1-maobibo@loongson.cn>
 <CAAhV-H6pt74LDg0idJ=71RG9MDh2KkMxE-Fao-qCFexyd8fz4A@mail.gmail.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <f71ceea8-e690-19cc-95a5-3f4ad25b3223@loongson.cn>
Date: Mon, 7 Jul 2025 11:51:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H6pt74LDg0idJ=71RG9MDh2KkMxE-Fao-qCFexyd8fz4A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxT+ayRGtomlsMAA--.6415S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxAw1fGryrAryktry5uw4ftFc_yoW5WFW5pF
	Wfu3ZxCFs8Krs7JFy2ga47WFy8ZF12gry7tr45KF4SgFyDZr1Sv3yrXwn7CFyDC395Gr1I
	qF40qr1kZF1UAacCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv
	67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw
	1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1Ek
	sDUUUUU==



On 2025/7/1 下午6:48, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Tue, Jul 1, 2025 at 11:08 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> This series add generic eiointc 8 bytes access interface, so that 1/2/4/8
>> bytes access can use the generic 8 bytes access interface. It reduce
>> about 300 lines redundant code and make eiointc emulation driver simple
>> than ever.
>>
>> ---
>> v4 ... v5
>>    1. Rebase patch on latest kernel where bugfix of eiointc has been
>>       merged.
>>    2. Add generic eiointc 8 bytes access interface, 1/2/4/8 bytes access
>>       uses generic 8 bytes access interface.
>>
>> v3 ... v4:
>>    1. Remove patch about enhancement and only keep bugfix relative
>>       patches.
>>    2. Remove INTC indication in the patch title.
>>    3. With access size, keep default case unchanged besides 1/2/4/8 since
>>       here all patches are bugfix
>>    4. Firstly check return value of copy_from_user() with error path,
>>       keep the same order with old patch in patch 4.
>>
>> v2 ... v3:
>>    1. Add prefix INTC: in title of every patch.
>>    2. Fix array index overflow when emulate register EIOINTC_ENABLE
>>       writing operation.
>>    3. Add address alignment check with eiointc register access operation.
>>
>> v1 ... v2:
>>    1. Add extra fix in patch 3 and patch 4, add num_cpu validation check
>>    2. Name of stat information keeps unchanged, only move it from VM stat
>>       to vCPU stat.
>> ---
>> Bibo Mao (13):
>>    LoongArch: KVM: Use standard bitops API with eiointc
>>    LoongArch: KVM: Remove unused parameter len
>>    LoongArch: KVM: Add stat information with kernel irqchip
>>    LoongArch: KVM: Remove never called default case statement
>>    LoongArch: KVM: Rename loongarch_eiointc_readq with
>>      loongarch_eiointc_read
>>    LoongArch: KVM: Use generic read function loongarch_eiointc_read
>>    LoongArch: KVM: Remove some unnecessary local variables
>>    LoongArch: KVM: Use concise api __ffs()
>>    LoongArch: KVM: Replace eiointc_enable_irq() with eiointc_update_irq()
>>    LoongArch: KVM: Remove local variable offset
>>    LoongArch: KVM: Rename old_data with old
>>    LoongArch: KVM: Add generic function loongarch_eiointc_write()
>>    LoongArch: KVM: Use generic interface loongarch_eiointc_write()
> Patch5 and Patch6 can be squashed, Patch7 and Patch10 can be squashed,
> Patch8 and Patch9 can be squshed, Patch12 and Patch13 can be squashed,
> Patch11 is useless so can be removed.
Thanks for reviewing, will do in this way.

Regards
Bibo Mao
> 
> 
> Huacai
> 
>>
>>   arch/loongarch/include/asm/kvm_host.h |  12 +-
>>   arch/loongarch/kvm/intc/eiointc.c     | 557 ++++----------------------
>>   arch/loongarch/kvm/intc/ipi.c         |  28 +-
>>   arch/loongarch/kvm/intc/pch_pic.c     |   4 +-
>>   arch/loongarch/kvm/vcpu.c             |   8 +-
>>   5 files changed, 102 insertions(+), 507 deletions(-)
>>
>>
>> base-commit: d0b3b7b22dfa1f4b515fd3a295b3fd958f9e81af
>> --
>> 2.39.3
>>


