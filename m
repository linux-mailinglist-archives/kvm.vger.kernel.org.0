Return-Path: <kvm+bounces-65498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AAEE3CACD35
	for <lists+kvm@lfdr.de>; Mon, 08 Dec 2025 11:13:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 032123065008
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 10:11:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BA713016F8;
	Mon,  8 Dec 2025 10:11:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B6D2E54D1;
	Mon,  8 Dec 2025 10:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765188664; cv=none; b=a82TOqYYZSmz1Bqun1pC7Mm0LKDOLTfAPwmDLvBex6mzPN+OgwvZtNDNfAG7U8NKQup0G+Zb7aoqPFxqVKqF9WRLEPaBwqCMRI+kN5cf8xlC5/6EUVhoxRrlvtO75F5RyqhYH7cdZNJgdTYLX0m5Ijkkx0cDK8qH22/AsnLnZkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765188664; c=relaxed/simple;
	bh=+DSmmXgm3P9RZfu6T8FOh34iy1aWMawnmSzjmjjVyXo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LOk2NGBD4RGhFLT/LafCqGAGdd81zUzUVVhGqeOX5b4LC7DmDeEEOpOdSpmN3VvlfPKpPLDwyCdsFIIH5ZbRryjm2un3te6JBqOPwZD141ed7RyX7iegX5egxhVRUECLzBefIpo3HT8rRKMyPe8qb8ajSqAWd5k2LbFZ3yixDG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from [192.168.12.121] (unknown [180.111.29.24])
	by APP-05 (Coremail) with SMTP id zQCowADXbBAmpDZpZxcBAA--.733S2;
	Mon, 08 Dec 2025 18:10:47 +0800 (CST)
Message-ID: <44d62b37-1496-48f1-ab5a-b12e91b32dbb@iscas.ac.cn>
Date: Mon, 8 Dec 2025 17:53:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] RISC-V: KVM: Allow zicfiss/zicfilp exts for Guest/VM
To: Deepak Gupta <debug@rivosinc.com>
Cc: anup@brainfault.org, ajones@ventanamicro.com, atishp@atishpatra.org,
 paul.walmsley@sifive.com, palmer@dabbelt.com, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org
References: <cover.1764509485.git.zhouquan@iscas.ac.cn>
 <103e156ea1f2201db52034e370a907f46edafb83.1764509485.git.zhouquan@iscas.ac.cn>
 <aTBxIBZ0Jwn67OcV@debug.ba.rivosinc.com>
Content-Language: en-US
From: Quan Zhou <zhouquan@iscas.ac.cn>
In-Reply-To: <aTBxIBZ0Jwn67OcV@debug.ba.rivosinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowADXbBAmpDZpZxcBAA--.733S2
X-Coremail-Antispam: 1UD129KBjvJXoWxuF1rZry5JFyDtr1fZFW7twb_yoWrWF13pr
	4kAFyfKrZxCwn3Ca4xtr1DWrW8uw4YgwnxGw18WFy8XFy7Cryvvr1qga4ag3WkJa10gr4v
	9r1rXFykZwnxJa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvqb7Iv0xC_Cr1lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4
	A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
	w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26F4j6r4UJw
	Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l
	c7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr
	1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE
	14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7
	IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E
	87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0x
	ZFpf9x07UXF4_UUUUU=
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiCQ4KBmk2dfC9AgAAsu



On 2025/12/4 01:19, Deepak Gupta wrote:
> On Mon, Dec 01, 2025 at 09:28:25AM +0800, zhouquan@iscas.ac.cn wrote:
>> From: Quan Zhou <zhouquan@iscas.ac.cn>
>>
>> Extend the KVM ISA extension ONE_REG interface to allow KVM user
>> space to detect and enable zicfiss/zicfilp exts for Guest/VM,
>> the rules defined in the spec [1] are as follows:
>> ---
>> 1) Zicfiss extension introduces the SSE field (bit 3) in henvcfg.
>> If the SSE field is set to 1, the Zicfiss extension is activated
>> in VS-mode. When the SSE field is 0, the Zicfiss extension remains
>> inactive in VS-mode.
>>
>> 2) Zicfilp extension introduces the LPE field (bit 2) in henvcfg.
>> When the LPE field is set to 1, the Zicfilp extension is enabled
>> in VS-mode. When the LPE field is 0, the Zicfilp extension is not
>> enabled in VS-mode.
>>
>> [1] - https://github.com/riscv/riscv-cfi
>>
>> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
>> ---
>> arch/riscv/include/uapi/asm/kvm.h | 2 ++
>> arch/riscv/kvm/vcpu.c             | 6 ++++++
>> arch/riscv/kvm/vcpu_onereg.c      | 2 ++
>> 3 files changed, 10 insertions(+)
>>
>> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/ 
>> uapi/asm/kvm.h
>> index 759a4852c09a..7ca087848a43 100644
>> --- a/arch/riscv/include/uapi/asm/kvm.h
>> +++ b/arch/riscv/include/uapi/asm/kvm.h
>> @@ -190,6 +190,8 @@ enum KVM_RISCV_ISA_EXT_ID {
>>     KVM_RISCV_ISA_EXT_ZFBFMIN,
>>     KVM_RISCV_ISA_EXT_ZVFBFMIN,
>>     KVM_RISCV_ISA_EXT_ZVFBFWMA,
>> +    KVM_RISCV_ISA_EXT_ZICFILP,
>> +    KVM_RISCV_ISA_EXT_ZICFISS,
>>     KVM_RISCV_ISA_EXT_MAX,
>> };
>>
>> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
>> index 5ce35aba6069..098d77f9a886 100644
>> --- a/arch/riscv/kvm/vcpu.c
>> +++ b/arch/riscv/kvm/vcpu.c
>> @@ -557,6 +557,12 @@ static void kvm_riscv_vcpu_setup_config(struct 
>> kvm_vcpu *vcpu)
>>     if (riscv_isa_extension_available(isa, ZICBOZ))
>>         cfg->henvcfg |= ENVCFG_CBZE;
>>
>> +    if (riscv_isa_extension_available(isa, ZICFILP))
>> +        cfg->henvcfg |= ENVCFG_LPE;
> 
> Blindly enabling landing pad enforcement on guest kernel will lead to 
> issues
> (a guest kernel might not be ready and compiled with landing pad 
> enforcement).
> It must be done via a SSE interface where enable is requested by guest 
> kernel.
> 
>> +
>> +    if (riscv_isa_extension_available(isa, ZICFISS))
>> +        cfg->henvcfg |= ENVCFG_SSE;
> 
> Same comment on shadow stack enable. While usually shadow stack usage is 
> optin
> where explicityl sspush/sspopchk/ssamoswap has to be part of codegen to 
> use the
> extension and not modifying existing instruction behavior (like zicfilp 
> does on
> `jalr`)
> There is a situaion during early boot of kernel where shadow stack 
> permissions
> for init shadow stack might not have been configured (or satp == BARE at 
> that
> time), in those cases `sspush/sspopchk` in guest kernel will start 
> faulting.
> 
> So enabling shadow stack should also be done via SSE interface.
> 
> That's how user cfi patchsets also do.
> 

Okay, I will fix it.

Thanks,
Quan

>> +
>>     if (riscv_isa_extension_available(isa, SVADU) &&
>>         !riscv_isa_extension_available(isa, SVADE))
>>         cfg->henvcfg |= ENVCFG_ADUE;
>> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
>> index 865dae903aa0..3d05a4bafd9b 100644
>> --- a/arch/riscv/kvm/vcpu_onereg.c
>> +++ b/arch/riscv/kvm/vcpu_onereg.c
>> @@ -72,6 +72,8 @@ static const unsigned long kvm_isa_ext_arr[] = {
>>     KVM_ISA_EXT_ARR(ZICBOP),
>>     KVM_ISA_EXT_ARR(ZICBOZ),
>>     KVM_ISA_EXT_ARR(ZICCRSE),
>> +    KVM_ISA_EXT_ARR(ZICFILP),
>> +    KVM_ISA_EXT_ARR(ZICFISS),
>>     KVM_ISA_EXT_ARR(ZICNTR),
>>     KVM_ISA_EXT_ARR(ZICOND),
>>     KVM_ISA_EXT_ARR(ZICSR),
>> -- 
>> 2.34.1
>>
>>


