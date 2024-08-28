Return-Path: <kvm+bounces-25222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FEC1961C1E
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 04:29:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D7ED81F245A3
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 02:29:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9A7C7316E;
	Wed, 28 Aug 2024 02:28:55 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D010211CBD;
	Wed, 28 Aug 2024 02:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724812135; cv=none; b=i8mbzguPRTvQ45P/RCPUpoCW3CuxcOfiXwN+cgVvmKQPE0NevVfOkbi7za+XcfqkBE1LwlXb0bQ5VqbPrLsO0sjDYdWWxuriNZ06MzBSC2kgetmrgg8Zfr28fSppTPo41VMAKJRhz52X4iHjgOZA4QqQT9gT4XPX48R2Fgnns8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724812135; c=relaxed/simple;
	bh=GJGug1cbipJCGXYCINJRJWPR2jdTKUmsQFbGCnb6MhQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=axm03KWviuX+JV0NsCVeBBnjdxD00Fk1K8fXGILDdt3ZwczuBnC1OrYO+CkOh7PAfi9SK29OAz9zvYdUz6rA6XuTivDyW+Z/peqOG79cq9BZIrdKkS4I92ikpDe6Ojn1RF2c/aVvvHXyD5QC5b8oV11x9Ec1kUQYdiMEXzIJXK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8BxqOlhi85mw1EiAA--.2349S3;
	Wed, 28 Aug 2024 10:28:49 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMDxkeFei85m9RwlAA--.26737S3;
	Wed, 28 Aug 2024 10:28:48 +0800 (CST)
Subject: Re: [PATCH v6 0/3] LoongArch: KVM: Add Binary Translation extension
 support
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>
References: <20240730075744.1215856-1-maobibo@loongson.cn>
 <CAAhV-H6dFBJ+dQE7qzK8aiTjx8NFJtzPWzEGpJ8dm7v4ExD8Ow@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <e898b732-71d5-c16f-93a5-de630820f06d@loongson.cn>
Date: Wed, 28 Aug 2024 10:28:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H6dFBJ+dQE7qzK8aiTjx8NFJtzPWzEGpJ8dm7v4ExD8Ow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMDxkeFei85m9RwlAA--.26737S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxXF4Uur45Kry7KFW8KryUArc_yoW5CF4kp3
	y5C3Z3CFWkGr1fAw4agw4jgF1YqrWxKF4xWF9xG345trZrWryUKr48KFZ5uFyDZw4rAry0
	vayvy395u3WDAFXCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE
	14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1c
	AE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr
	0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8vA
	pUUUUUU==



On 2024/8/28 上午10:08, Huacai Chen wrote:
> Hi, Bibo,
> 
> I have consulted with Jiaxun offline, and he has tried his best to
> propose a "scratch vcpu" solution. But unfortunately that solution is
> too difficult to implement and he has nearly given up.
> 
> So the solution in this series seems the best one, and I will queue it
> for loongarch-kvm now.
Thanks. There may be requirement such as there is different capability 
for different vCPUs, only that it is a little far from now. We can 
discuss and add that if there is such requirement. Because of limitation 
of human resource and ability, the implementation is not perfect however 
it can be used.

Regards
Bibo Mao
> 
> Huacai
> 
> On Tue, Jul 30, 2024 at 3:57 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> Loongson Binary Translation (LBT) is used to accelerate binary
>> translation, which contains 4 scratch registers (scr0 to scr3), x86/ARM
>> eflags (eflags) and x87 fpu stack pointer (ftop).
>>
>> Like FPU extension, here lately enabling method is used for LBT. LBT
>> context is saved/restored during vcpu context switch path.
>>
>> Also this patch set LBT capability detection, and LBT register get and set
>> interface for userspace vmm, so that vm supports migration with BT
>> extension.
>>
>> ---
>> v5 ... v6:
>>    1. Solve compiling issue with function kvm_get_one_reg() and
>>       kvm_set_one_reg().
>>
>> v4 ... v5:
>>    1. Add feature detection for LSX/LASX from vm side, previously
>>       LSX/LASX feature is detected from vcpu ioctl command, now both
>>       methods are supported.
>>
>> v3 ... v4:
>>    1. Merge LBT feature detection for VM and VCPU into one patch.
>>    2. Move function declaration such as kvm_lose_lbt()/kvm_check_fcsr()/
>>       kvm_enable_lbt_fpu() from header file to c file, since it is only
>>       used in one c file.
>>
>> v2 ... v3:
>>    1. Split KVM_LOONGARCH_VM_FEAT_LBT capability checking into three
>>       sub-features, KVM_LOONGARCH_VM_FEAT_X86BT/KVM_LOONGARCH_VM_FEAT_ARMBT
>>       and KVM_LOONGARCH_VM_FEAT_MIPSBT. Return success only if host
>>       supports the sub-feature.
>>
>> v1 ... v2:
>>    1. With LBT register read or write interface to userpace, replace
>>       device attr method with KVM_GET_ONE_REG method, since lbt register is
>>       vcpu register and can be added in kvm_reg_list in future.
>>    2. Add vm device attr ctrl marcro KVM_LOONGARCH_VM_FEAT_CTRL, it is
>>       used to get supported LBT feature before vm or vcpu is created.
>> ---
>> Bibo Mao (3):
>>    LoongArch: KVM: Add HW Binary Translation extension support
>>    LoongArch: KVM: Add LBT feature detection function
>>    LoongArch: KVM: Add vm migration support for LBT registers
>>
>>   arch/loongarch/include/asm/kvm_host.h |   8 ++
>>   arch/loongarch/include/asm/kvm_vcpu.h |   6 ++
>>   arch/loongarch/include/uapi/asm/kvm.h |  17 ++++
>>   arch/loongarch/kvm/exit.c             |   9 ++
>>   arch/loongarch/kvm/vcpu.c             | 128 +++++++++++++++++++++++++-
>>   arch/loongarch/kvm/vm.c               |  52 ++++++++++-
>>   6 files changed, 218 insertions(+), 2 deletions(-)
>>
>>
>> base-commit: 8400291e289ee6b2bf9779ff1c83a291501f017b
>> --
>> 2.39.3
>>
>>


