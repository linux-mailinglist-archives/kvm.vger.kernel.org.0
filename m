Return-Path: <kvm+bounces-52711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D2DAB08656
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 09:17:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1ED2E188DC77
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 07:17:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0BD521CA13;
	Thu, 17 Jul 2025 07:16:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D54A021B905;
	Thu, 17 Jul 2025 07:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752736613; cv=none; b=m32Vhc8Qad3Z5QNhu2trQFghV1hxvD2lRGhHIwNlJUo/dSZnc/5GTddLyQg/ZClDtA0l2fRKXSAHdx+Awi97VmaXB2LkMiq/+FVOsN8+bg+pgJ3QuyglwZlZ2UshKUH4i80CKbm4d7WqLPCo0aGq0SLvhGW+4dh4b9ZJJaTZixk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752736613; c=relaxed/simple;
	bh=WklU54y6lya8nGklziuxsA67cNF/uMKTCUH871Bjzvg=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=qsAZPhj4kIdY/zI8TxUNH9Fu9ozPl4kU6uepTnM8oLIO1T4ycMcbOo7LCQppVu2vKW/Dll8Q9e1dSGgcg1YIVzuS592tQ/+I0zgRt3fW7jxxiOKWIiXeVGKepF8ouuFUkfJz4zZ6hsPhTSnEy+dCz2hb0CfsJZ2xa9nNfWNkwAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8CxNHBWo3houOwrAQ--.24669S3;
	Thu, 17 Jul 2025 15:16:38 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJAxVORQo3hofLQaAA--.12371S3;
	Thu, 17 Jul 2025 15:16:35 +0800 (CST)
Subject: Re: [PATCH v6 0/8] LoongArch: KVM: Enhancement with eiointc emulation
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
 Xianglai Li <lixianglai@loongson.cn>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250709080233.3948503-1-maobibo@loongson.cn>
 <CAAhV-H5x_V8CjX=Keb0k5+5zFtqh01MBWEo_hTFwwge-01jT9Q@mail.gmail.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <4cdb6cf7-2293-04e3-57b3-9ad4fd07ac9e@loongson.cn>
Date: Thu, 17 Jul 2025 15:14:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H5x_V8CjX=Keb0k5+5zFtqh01MBWEo_hTFwwge-01jT9Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxVORQo3hofLQaAA--.12371S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxArWxXryUAry7KFyUZF13GFX_yoW5Ary7pF
	WfC3ZakF45Gr48Gas2ga47WFy8Z3ZrZryxtrn0grW09FyDZrnIv3yFvw10kFyUC395Gr1I
	qa18Xwn5ZFyUAacCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v2
	6F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI0UMc
	02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAF
	wI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4
	CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
	67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
	W8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jUsqXU
	UUUU=



On 2025/7/16 下午6:19, Huacai Chen wrote:
> Applied with some modifications. E.g., Patch6 removes offset, and
> Patch8 adds it back, so I combine these two.
> 
> Since the code is a little different, it is better to test it again [1].
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson.git/log/?h=loongarch-kvm
It works well with basic VM operations.
Also looks good from code review side.

Regards
Bibo Mao
> 
> 
> 
> Huacai
> 
> On Wed, Jul 9, 2025 at 4:02 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> This series add generic eiointc 8 bytes access interface, so that 1/2/4/8
>> bytes access can use the generic 8 bytes access interface. It reduce
>> about 500 lines redundant code and make eiointc emulation driver
>> simpler than ever.
>>
>> ---
>> v5 ... v6:
>>    1. Merge previous patch 5 & 6 into one, patch 7 & 10 into into one and
>>       patch 12 and patch 13 into one.
>>    2. Use sign extension with destination register for IOCSRRD.{B/H/W}
>>       kernel emulation.
>>
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
>> Bibo Mao (8):
>>    LoongArch: KVM: Use standard bitops API with eiointc
>>    LoongArch: KVM: Remove unused parameter len
>>    LoongArch: KVM: Add stat information with kernel irqchip
>>    LoongArch: KVM: Remove never called default case statement
>>    LoongArch: KVM: Use generic function loongarch_eiointc_read()
>>    LoongArch: KVM: Remove some unnecessary local variables
>>    LoongArch: KVM: Replace eiointc_enable_irq() with eiointc_update_irq()
>>    LoongArch: KVM: Add generic function loongarch_eiointc_write()
>>
>>   arch/loongarch/include/asm/kvm_host.h |  12 +-
>>   arch/loongarch/kvm/intc/eiointc.c     | 558 ++++----------------------
>>   arch/loongarch/kvm/intc/ipi.c         |  28 +-
>>   arch/loongarch/kvm/intc/pch_pic.c     |   4 +-
>>   arch/loongarch/kvm/vcpu.c             |   8 +-
>>   5 files changed, 102 insertions(+), 508 deletions(-)
>>
>>
>> base-commit: 733923397fd95405a48f165c9b1fbc8c4b0a4681
>> --
>> 2.39.3
>>


