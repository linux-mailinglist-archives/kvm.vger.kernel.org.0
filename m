Return-Path: <kvm+bounces-69084-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yBwNNmU2d2nhdAEAu9opvQ
	(envelope-from <kvm+bounces-69084-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 10:39:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D823861C7
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 10:39:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4F7F13026AAB
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 09:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADB5232A3E5;
	Mon, 26 Jan 2026 09:38:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29E722F999F;
	Mon, 26 Jan 2026 09:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769420291; cv=none; b=T5G2gex3knHfOihlH3wP+cMwj8xwtjw7cp0fvCmKTAd9dJAcZErfeWQ/oJdsqtcr2qJafpbTMglk+qHoC0Eg9qVpAJxW6kHH1yRY3LrSRlBPQ49WaakjAe+XHJAYiW0OqcpHRFpvV0+uriV3wyaRCjb7Mla3nJjlOdOE5G3f1fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769420291; c=relaxed/simple;
	bh=eqCA/a/wxtEARzfbMDsIhUSnq3wES5Qi6jw+JIWfs9k=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=PFdLo4tvhY3Z11lkpCLfiZ7Se4nIM/QZ8Duu5YfT1XIxkna0ona2vB4LnNb6LjrYRQPOr+urzLOKBGqRoShjoImtBJsREUH+RM8RGE3t4NU1iYqxdr2HofR+S4HzerK16NcoWH6TixatEPcvIATk1U7+N+KQyQP3iFdiydSC23U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8AxEvH8NXdp_6sMAA--.41904S3;
	Mon, 26 Jan 2026 17:38:04 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJCx98DoNXdpY9UxAA--.19314S3;
	Mon, 26 Jan 2026 17:37:47 +0800 (CST)
Subject: Re: [PATCH 1/1] KVM: Add KVM_GET_REG_LIST ioctl for LoongArch
To: liushuyu <liushuyu@aosc.io>, WANG Xuerui <kernel@xen0n.name>,
 Huacai Chen <chenhuacai@kernel.org>
Cc: Kexy Biscuit <kexybiscuit@aosc.io>, Mingcong Bai <jeffbai@aosc.io>,
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
 rust-for-linux@vger.kernel.org
References: <20260125054322.1237687-1-liushuyu@aosc.io>
 <4b504274-4241-0e3e-3ed3-7804b72b7ee8@loongson.cn>
 <972430be-d2f3-49b6-851b-a057ddfcafec@aosc.io>
 <29565e27-f153-c2c5-cbc3-e0457d45f094@loongson.cn>
 <2fa2dc72-b24e-4504-8c8e-e4ecacda02c4@aosc.io>
 <13746394-1a33-894a-d325-8125743f7906@loongson.cn>
 <f3256219-bb97-45d4-9364-cf28d3c9dc8a@aosc.io>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <913e8e96-9124-2fbe-bd00-f6122962562a@loongson.cn>
Date: Mon, 26 Jan 2026 17:35:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <f3256219-bb97-45d4-9364-cf28d3c9dc8a@aosc.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCx98DoNXdpY9UxAA--.19314S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3Xr1UCw4xWFyxWr1DXw1rKrX_yoWfKry7pr
	ykAFWUJry5Jrn5Jr1jqw15WF9Fyr1UJ3WDXr1xXF1UJr4Dtr1jqr18Xr1qgF18Jr48JF1j
	qr1UXr17ur15JrgCm3ZEXasCq-sJn29KB7ZKAUJUUUUA529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPvb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUtVW8ZwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	tVWrXwAv7VC2z280aVAFwI0_Cr0_Gr1UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwI
	xGrwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r4a6rW5MxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26rWY6Fy7MI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r4j6ryUMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Cr0_
	Gr1UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjxU-J
	KIDUUUU
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[27];
	TAGGED_FROM(0.00)[bounces-69084-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[loongson.cn];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[aosc.io,redhat.com,lwn.net,loongson.cn,kernel.org,dabbelt.com,eecs.berkeley.edu,ghiti.fr,gmail.com,garyguo.net,protonmail.com,google.com,umich.edu,vger.kernel.org,lists.linux.dev,lists.infradead.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maobibo@loongson.cn,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.995];
	MID_RHS_MATCH_FROM(0.00)[];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,loongson.cn:mid,aosc.io:email]
X-Rspamd-Queue-Id: 3D823861C7
X-Rspamd-Action: no action



On 2026/1/26 下午4:54, liushuyu wrote:
> Hi Bibo,
> 
>>
>>
>> On 2026/1/26 下午12:22, liushuyu wrote:
>>> Hi Bibo,
>>>
>>>>
>>>>
>>>> On 2026/1/26 上午11:38, liushuyu wrote:
>>>>> Hi Bibo,
>>>>>>
>>>>>>
>>>>>> On 2026/1/25 下午1:43, Zixing Liu wrote:
>>>>>>> This ioctl can be used by userspace applications to determine which
>>>>>>> (special) registers are get/set-able.
>>>>>>>
>>>>>>> This can be very useful for cross-platform VMMs so that they do not
>>>>>>> have
>>>>>>> to hardcode register indices for each supported architectures.
>>>>>>>
>>>>>>> Signed-off-by: Zixing Liu <liushuyu@aosc.io>
>>>>>>> ---
>>>>>>>
>>>>>>> For example, this ioctl could be used by rust-vmm/rust-kvm or maybe
>>>>>>> VirtualBox-kvm in the future.
>>>>>>>
>>>>>>>      Documentation/virt/kvm/api.rst |  2 +-
>>>>>>>      arch/loongarch/kvm/vcpu.c      | 69
>>>>>>> ++++++++++++++++++++++++++++++++++
>>>>>>>      2 files changed, 70 insertions(+), 1 deletion(-)
>>>>>>>
>>>>>>> diff --git a/Documentation/virt/kvm/api.rst
>>>>>>> b/Documentation/virt/kvm/api.rst
>>>>>>> index 01a3abef8abb..f46dd8be282f 100644
>>>>>>> --- a/Documentation/virt/kvm/api.rst
>>>>>>> +++ b/Documentation/virt/kvm/api.rst
>>>>>>> @@ -3603,7 +3603,7 @@ VCPU matching underlying host.
>>>>>>>      ---------------------
>>>>>>>        :Capability: basic
>>>>>>> -:Architectures: arm64, mips, riscv, x86 (if KVM_CAP_ONE_REG)
>>>>>>> +:Architectures: arm64, loongarch, mips, riscv, x86 (if
>>>>>>> KVM_CAP_ONE_REG)
>>>>>>>      :Type: vcpu ioctl
>>>>>>>      :Parameters: struct kvm_reg_list (in/out)
>>>>>>>      :Returns: 0 on success; -1 on error
>>>>>>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>>>>>>> index 656b954c1134..b884eb9c76aa 100644
>>>>>>> --- a/arch/loongarch/kvm/vcpu.c
>>>>>>> +++ b/arch/loongarch/kvm/vcpu.c
>>>>>>> @@ -1186,6 +1186,57 @@ static int kvm_loongarch_vcpu_set_attr(struct
>>>>>>> kvm_vcpu *vcpu,
>>>>>>>          return ret;
>>>>>>>      }
>>>>>>>      +static unsigned long kvm_loongarch_num_lbt_regs(void)
>>>>>>> +{
>>>>>>> +    /* +1 for the LBT_FTOP flag (inside arch.fpu) */
>>>>>>> +    return sizeof(struct loongarch_lbt) / sizeof(unsigned long)
>>>>>>> + 1;
>>>>>>> +}
>>>>>>> +
>>>>>>> +static unsigned long kvm_loongarch_num_regs(struct kvm_vcpu *vcpu)
>>>>>>> +{
>>>>>>> +    /* +1 for the KVM_REG_LOONGARCH_COUNTER register */
>>>>>>> +    unsigned long res = CSR_MAX_NUMS + KVM_MAX_CPUCFG_REGS + 1;
>>>>>>> +
>>>>>>> +    if (kvm_guest_has_lbt(&vcpu->arch))
>>>>>>> +        res += kvm_loongarch_num_lbt_regs();
>>>>>>> +
>>>>>>> +    return res;
>>>>>>> +}
>>>>>>> +
>>>>>>> +static int kvm_loongarch_copy_reg_indices(struct kvm_vcpu *vcpu,
>>>>>>> +                      u64 __user *uindices)
>>>>>>> +{
>>>>>>> +    u64 reg;
>>>>>>> +    unsigned int i;
>>>>>>> +
>>>>>>> +    for (i = 0; i < CSR_MAX_NUMS; i++) {
>>>>>>> +        reg = KVM_IOC_CSRID(i);
>>>>>>> +        if (put_user(reg, uindices++))
>>>>>>> +            return -EFAULT;
>>>>>>> +    }
>>>>>> CSR_MAX_NUMS is max number of accessible CSR registers, instead only
>>>>>> part of them is used by vCPU model. By my understanding, there
>>>>>> will be
>>>>>> no much meaning if CSR_MAX_NUMS is returned. And I think it will be
>>>>>> better if real CSR register id and number is returned.
>>>>>>
>>>>> Did you mean we should only return the CSR registers initialized in
>>>>> this
>>>>> function
>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/loongarch/kvm/main.c?id=63804fed149a6750ffd28610c5c1c98cce6bd377#n48
>>>>>
>>>>>
>>>>> ?
>>>>>
>>>>> That looks like a very large list and the values of the register
>>>>> IDs are
>>>>> not fully continuous. If that is the case, how do we maintain the
>>>>> get/set-able CSR register list?
>>>> It will be better if CSR register list can be categorized, for example
>>>> with LoongArch CPU manual CSR register is split into 8 types from
>>>> chapter 7.4 -- 7.11
>>>>
>>>> At the beginning, there is big array with size CSR_MAX_NUMS without
>>>> any category, it can be fine-gained in late.
>>>
>>> Does that mean in the new `kvm_loongarch_copy_reg_indices` function, it
>>> is also okay to embed this big list in there?
>> Firstly I do not know how to use ioctl command KVM_GET_REG_LIST in VMM
>> actually.
>>
>> At the second from the word "determine which (special) registers are
>> get/set-able", I think that it is better to set accessible CSR
>> register number and ID rather than the total number CSR_MAX_NUMS.
>>
> Understood. I will post a v2 patch, and we can continue the discussion
> from there to see if I understood your points correctly.
Remember to add such lines in function kvm_init_gcsr_flag() in the next 
round, since MSGINT CSR registers are missing here.

void kvm_init_gcsr_flag(void) {
+        if (cpu_has_msgint) {
+                set_gcsr_hw_flag(LOONGARCH_CSR_ISR0);
+                set_gcsr_hw_flag(LOONGARCH_CSR_ISR1);
+                set_gcsr_hw_flag(LOONGARCH_CSR_ISR2);
+                set_gcsr_hw_flag(LOONGARCH_CSR_ISR3);
+        }
}

Regards
Bibo Mao
> 
>> +static int kvm_loongarch_num_csr_regs(struct kvm_vcpu *vcpu)
>> +{
>> +    unsigned int i, count;
>> +
>> +    count = 0
>> +    for (i = 0; i < CSR_MAX_NUMS; i++) {
>> +        if (!(get_gcsr_flag(i) & (SW_GCSR | HW_GCSR)))
>> +            continue;
>> +        count++;
>> +    }
>> +    return count;
>> +}
>>
>> static unsigned long kvm_loongarch_num_regs(struct kvm_vcpu *vcpu)
>> {
>>      /* +1 for the KVM_REG_LOONGARCH_COUNTER register */
>> +    unsigned long res = kvm_loongarch_num_csr_regs +
>> KVM_MAX_CPUCFG_REGS + 1;
>>
>>      if (kvm_guest_has_lbt(&vcpu->arch))
>>          res += kvm_loongarch_num_lbt_regs();
>>
>>      return res;
>> }
>>
>> static int kvm_loongarch_copy_reg_indices(struct kvm_vcpu *vcpu,
>>                        u64 __user *uindices)
>> {
>>      u64 reg;
>>      unsigned int i;
>>
>>      for (i = 0; i < CSR_MAX_NUMS; i++) {
>> +                if (!(get_gcsr_flag(i) & (SW_GCSR | HW_GCSR)))
>> +                    continue;
>>          reg = KVM_IOC_CSRID(i);
>>          if (put_user(reg, uindices++))
>>              return -EFAULT;
>>      }
>>
>> Regards
>> Bibo Mao
>>>
>>> Or do you want to extract the list from the `kvm_init_gcsr_flag`
>>> function and refactor both functions to share one single big list
>>> (probably in the kvm_host.h header)?
>>>
>>> Because from what I could understand, your previous messages point to
>>> that we need to use this list to make out what CSR registers to return
>>> to the user space VMMs.
>>
>>>
>>>>
>>>> Regards
>>>> Bibo Mao
>>>>>
>>>>>> Regards
>>>>>> Bibo Mao
>>>>>>> +
>>>>>>> +    for (i = 0; i < KVM_MAX_CPUCFG_REGS; i++) {
>>>>>>> +        reg = KVM_IOC_CPUCFG(i);
>>>>>>> +        if (put_user(reg, uindices++))
>>>>>>> +            return -EFAULT;
>>>>>>> +    }
>>>>>>> +
>>>>>>> +    reg = KVM_REG_LOONGARCH_COUNTER;
>>>>>>> +    if (put_user(reg, uindices++))
>>>>>>> +        return -EFAULT;
>>>>>>> +
>>>>>>> +    if (!kvm_guest_has_lbt(&vcpu->arch))
>>>>>>> +        return 0;
>>>>>>> +
>>>>>>> +    for (i = 1; i <= kvm_loongarch_num_lbt_regs(); i++) {
>>>>>>> +        reg = (KVM_REG_LOONGARCH_LBT | KVM_REG_SIZE_U64 | i);
>>>>>>> +        if (put_user(reg, uindices++))
>>>>>>> +            return -EFAULT;
>>>>>>> +    }
>>>>>>> +
>>>>>>> +    return 0;
>>>>>>> +}
>>>>>>> +
>>>>>>>      long kvm_arch_vcpu_ioctl(struct file *filp,
>>>>>>>                   unsigned int ioctl, unsigned long arg)
>>>>>>>      {
>>>>>>> @@ -1251,6 +1302,24 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>>>>>>              r = kvm_loongarch_vcpu_set_attr(vcpu, &attr);
>>>>>>>              break;
>>>>>>>          }
>>>>>>> +    case KVM_GET_REG_LIST: {
>>>>>>> +        struct kvm_reg_list __user *user_list = argp;
>>>>>>> +        struct kvm_reg_list reg_list;
>>>>>>> +        unsigned n;
>>>>>>> +
>>>>>>> +        r = -EFAULT;
>>>>>>> +        if (copy_from_user(&reg_list, user_list, sizeof(reg_list)))
>>>>>>> +            break;
>>>>>>> +        n = reg_list.n;
>>>>>>> +        reg_list.n = kvm_loongarch_num_regs(vcpu);
>>>>>>> +        if (copy_to_user(user_list, &reg_list, sizeof(reg_list)))
>>>>>>> +            break;
>>>>>>> +        r = -E2BIG;
>>>>>>> +        if (n < reg_list.n)
>>>>>>> +            break;
>>>>>>> +        r = kvm_loongarch_copy_reg_indices(vcpu, user_list->reg);
>>>>>>> +        break;
>>>>>>> +    }
>>>>>>>          default:
>>>>>>>              r = -ENOIOCTLCMD;
>>>>>>>              break;
>>>>>>>
>>>>>>
>>>>> Thanks,
>>>>> Zixing
>>>>>
>>>>
>>> Thanks,
>>> Zixing
>>>
>>
> Thanks,
> 
> Zixing
> 


