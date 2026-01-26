Return-Path: <kvm+bounces-69082-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oIuiJwAsd2nacwEAu9opvQ
	(envelope-from <kvm+bounces-69082-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 09:55:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F2BC485A8C
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 09:55:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A4043301052D
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 08:54:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25A2D31355E;
	Mon, 26 Jan 2026 08:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b="ORqjPLk+"
X-Original-To: kvm@vger.kernel.org
Received: from relay5.mymailcheap.com (relay5.mymailcheap.com [159.100.248.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F0A3090C5;
	Mon, 26 Jan 2026 08:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.100.248.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769417688; cv=none; b=myx1Q+ohGF3d66CgbzUuy0lBgy68dvxFEGkV+tGlm0VkMxV2C5+X5LLCAePAuSX6CKQU3sg4GVMI4UK4oXBcLqRx7ElDBOR7eVpgwVrhlV2LcqzX+mLGQoPHVzJcTgzjh/pgEJ2KdXxsGNWcGPumJU2ktgIuTjDU8RoyYxkSl3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769417688; c=relaxed/simple;
	bh=TwIToU064K5dMWaz+SRpXB7pa10vjszZ1Jy8t7dLIrc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iyN+KDq26QxJCBhAZ/j1HVd5f4d20Wh5tFYrBdG6beC0Ut+ZmzYnh7V2ZrQsCDEhFffXcsJ4z/X8cjxm5ErclxmPyDW+jPZxEA0IGWbwVrOHDzg6FugNhYMF2YVZt6dcSgrjLUDsHTWv23s+rckpp8arQiLVRFr0gPmL2gAbdfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io; spf=pass smtp.mailfrom=aosc.io; dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b=ORqjPLk+; arc=none smtp.client-ip=159.100.248.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aosc.io
Received: from relay2.mymailcheap.com (relay2.mymailcheap.com [217.182.113.132])
	by relay5.mymailcheap.com (Postfix) with ESMTPS id 3B31F26345;
	Mon, 26 Jan 2026 08:54:44 +0000 (UTC)
Received: from nf1.mymailcheap.com (nf1.mymailcheap.com [51.75.14.91])
	by relay2.mymailcheap.com (Postfix) with ESMTPS id 0C8663E8B0;
	Mon, 26 Jan 2026 08:54:36 +0000 (UTC)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
	by nf1.mymailcheap.com (Postfix) with ESMTPSA id A2F0D400D5;
	Mon, 26 Jan 2026 08:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
	t=1769417671; bh=TwIToU064K5dMWaz+SRpXB7pa10vjszZ1Jy8t7dLIrc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ORqjPLk++EGfsnq5gappSmmd+co4PSfSsPlDjskR5vg14gPN7pChfp5XREpSKs0jx
	 Cbke3yY4poVFGqSSE4Yf72g9OJzkXuhAWPFDGWb495qP0jSi2ecAMoheaHzVbUQEO7
	 +kckd9qRE/pa8VR/InKeQPrA5GsVWV1ezawKn5pw=
Received: from [127.0.0.1] (unknown [117.151.13.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail20.mymailcheap.com (Postfix) with ESMTPSA id DF98543622;
	Mon, 26 Jan 2026 08:54:20 +0000 (UTC)
Message-ID: <f3256219-bb97-45d4-9364-cf28d3c9dc8a@aosc.io>
Date: Mon, 26 Jan 2026 16:54:15 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] KVM: Add KVM_GET_REG_LIST ioctl for LoongArch
Content-Language: en-US-large, en-US
To: Bibo Mao <maobibo@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 Huacai Chen <chenhuacai@kernel.org>
Cc: Kexy Biscuit <kexybiscuit@aosc.io>, Mingcong Bai <jeffbai@aosc.io>,
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
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
From: liushuyu <liushuyu@aosc.io>
In-Reply-To: <13746394-1a33-894a-d325-8125743f7906@loongson.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[aosc.io:s=default];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69082-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[aosc.io];
	FORGED_SENDER_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[27];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[aosc.io,redhat.com,lwn.net,loongson.cn,kernel.org,dabbelt.com,eecs.berkeley.edu,ghiti.fr,gmail.com,garyguo.net,protonmail.com,google.com,umich.edu,vger.kernel.org,lists.linux.dev,lists.infradead.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[liushuyu@aosc.io,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[aosc.io:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: F2BC485A8C
X-Rspamd-Action: no action

Hi Bibo,

>
>
> On 2026/1/26 下午12:22, liushuyu wrote:
>> Hi Bibo,
>>
>>>
>>>
>>> On 2026/1/26 上午11:38, liushuyu wrote:
>>>> Hi Bibo,
>>>>>
>>>>>
>>>>> On 2026/1/25 下午1:43, Zixing Liu wrote:
>>>>>> This ioctl can be used by userspace applications to determine which
>>>>>> (special) registers are get/set-able.
>>>>>>
>>>>>> This can be very useful for cross-platform VMMs so that they do not
>>>>>> have
>>>>>> to hardcode register indices for each supported architectures.
>>>>>>
>>>>>> Signed-off-by: Zixing Liu <liushuyu@aosc.io>
>>>>>> ---
>>>>>>
>>>>>> For example, this ioctl could be used by rust-vmm/rust-kvm or maybe
>>>>>> VirtualBox-kvm in the future.
>>>>>>
>>>>>>     Documentation/virt/kvm/api.rst |  2 +-
>>>>>>     arch/loongarch/kvm/vcpu.c      | 69
>>>>>> ++++++++++++++++++++++++++++++++++
>>>>>>     2 files changed, 70 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/Documentation/virt/kvm/api.rst
>>>>>> b/Documentation/virt/kvm/api.rst
>>>>>> index 01a3abef8abb..f46dd8be282f 100644
>>>>>> --- a/Documentation/virt/kvm/api.rst
>>>>>> +++ b/Documentation/virt/kvm/api.rst
>>>>>> @@ -3603,7 +3603,7 @@ VCPU matching underlying host.
>>>>>>     ---------------------
>>>>>>       :Capability: basic
>>>>>> -:Architectures: arm64, mips, riscv, x86 (if KVM_CAP_ONE_REG)
>>>>>> +:Architectures: arm64, loongarch, mips, riscv, x86 (if
>>>>>> KVM_CAP_ONE_REG)
>>>>>>     :Type: vcpu ioctl
>>>>>>     :Parameters: struct kvm_reg_list (in/out)
>>>>>>     :Returns: 0 on success; -1 on error
>>>>>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>>>>>> index 656b954c1134..b884eb9c76aa 100644
>>>>>> --- a/arch/loongarch/kvm/vcpu.c
>>>>>> +++ b/arch/loongarch/kvm/vcpu.c
>>>>>> @@ -1186,6 +1186,57 @@ static int kvm_loongarch_vcpu_set_attr(struct
>>>>>> kvm_vcpu *vcpu,
>>>>>>         return ret;
>>>>>>     }
>>>>>>     +static unsigned long kvm_loongarch_num_lbt_regs(void)
>>>>>> +{
>>>>>> +    /* +1 for the LBT_FTOP flag (inside arch.fpu) */
>>>>>> +    return sizeof(struct loongarch_lbt) / sizeof(unsigned long)
>>>>>> + 1;
>>>>>> +}
>>>>>> +
>>>>>> +static unsigned long kvm_loongarch_num_regs(struct kvm_vcpu *vcpu)
>>>>>> +{
>>>>>> +    /* +1 for the KVM_REG_LOONGARCH_COUNTER register */
>>>>>> +    unsigned long res = CSR_MAX_NUMS + KVM_MAX_CPUCFG_REGS + 1;
>>>>>> +
>>>>>> +    if (kvm_guest_has_lbt(&vcpu->arch))
>>>>>> +        res += kvm_loongarch_num_lbt_regs();
>>>>>> +
>>>>>> +    return res;
>>>>>> +}
>>>>>> +
>>>>>> +static int kvm_loongarch_copy_reg_indices(struct kvm_vcpu *vcpu,
>>>>>> +                      u64 __user *uindices)
>>>>>> +{
>>>>>> +    u64 reg;
>>>>>> +    unsigned int i;
>>>>>> +
>>>>>> +    for (i = 0; i < CSR_MAX_NUMS; i++) {
>>>>>> +        reg = KVM_IOC_CSRID(i);
>>>>>> +        if (put_user(reg, uindices++))
>>>>>> +            return -EFAULT;
>>>>>> +    }
>>>>> CSR_MAX_NUMS is max number of accessible CSR registers, instead only
>>>>> part of them is used by vCPU model. By my understanding, there
>>>>> will be
>>>>> no much meaning if CSR_MAX_NUMS is returned. And I think it will be
>>>>> better if real CSR register id and number is returned.
>>>>>
>>>> Did you mean we should only return the CSR registers initialized in
>>>> this
>>>> function
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/loongarch/kvm/main.c?id=63804fed149a6750ffd28610c5c1c98cce6bd377#n48
>>>>
>>>>
>>>> ?
>>>>
>>>> That looks like a very large list and the values of the register
>>>> IDs are
>>>> not fully continuous. If that is the case, how do we maintain the
>>>> get/set-able CSR register list?
>>> It will be better if CSR register list can be categorized, for example
>>> with LoongArch CPU manual CSR register is split into 8 types from
>>> chapter 7.4 -- 7.11
>>>
>>> At the beginning, there is big array with size CSR_MAX_NUMS without
>>> any category, it can be fine-gained in late.
>>
>> Does that mean in the new `kvm_loongarch_copy_reg_indices` function, it
>> is also okay to embed this big list in there?
> Firstly I do not know how to use ioctl command KVM_GET_REG_LIST in VMM
> actually.
>
> At the second from the word "determine which (special) registers are
> get/set-able", I think that it is better to set accessible CSR
> register number and ID rather than the total number CSR_MAX_NUMS. 
>
Understood. I will post a v2 patch, and we can continue the discussion
from there to see if I understood your points correctly.

> +static int kvm_loongarch_num_csr_regs(struct kvm_vcpu *vcpu)
> +{
> +    unsigned int i, count;
> +
> +    count = 0
> +    for (i = 0; i < CSR_MAX_NUMS; i++) {
> +        if (!(get_gcsr_flag(i) & (SW_GCSR | HW_GCSR)))
> +            continue;
> +        count++;
> +    }
> +    return count;
> +}
>
> static unsigned long kvm_loongarch_num_regs(struct kvm_vcpu *vcpu)
> {
>     /* +1 for the KVM_REG_LOONGARCH_COUNTER register */
> +    unsigned long res = kvm_loongarch_num_csr_regs +
> KVM_MAX_CPUCFG_REGS + 1;
>
>     if (kvm_guest_has_lbt(&vcpu->arch))
>         res += kvm_loongarch_num_lbt_regs();
>
>     return res;
> }
>
> static int kvm_loongarch_copy_reg_indices(struct kvm_vcpu *vcpu,
>                       u64 __user *uindices)
> {
>     u64 reg;
>     unsigned int i;
>
>     for (i = 0; i < CSR_MAX_NUMS; i++) {
> +                if (!(get_gcsr_flag(i) & (SW_GCSR | HW_GCSR)))
> +                    continue;
>         reg = KVM_IOC_CSRID(i);
>         if (put_user(reg, uindices++))
>             return -EFAULT;
>     }
>
> Regards
> Bibo Mao
>>
>> Or do you want to extract the list from the `kvm_init_gcsr_flag`
>> function and refactor both functions to share one single big list
>> (probably in the kvm_host.h header)?
>>
>> Because from what I could understand, your previous messages point to
>> that we need to use this list to make out what CSR registers to return
>> to the user space VMMs.
>
>>
>>>
>>> Regards
>>> Bibo Mao
>>>>
>>>>> Regards
>>>>> Bibo Mao
>>>>>> +
>>>>>> +    for (i = 0; i < KVM_MAX_CPUCFG_REGS; i++) {
>>>>>> +        reg = KVM_IOC_CPUCFG(i);
>>>>>> +        if (put_user(reg, uindices++))
>>>>>> +            return -EFAULT;
>>>>>> +    }
>>>>>> +
>>>>>> +    reg = KVM_REG_LOONGARCH_COUNTER;
>>>>>> +    if (put_user(reg, uindices++))
>>>>>> +        return -EFAULT;
>>>>>> +
>>>>>> +    if (!kvm_guest_has_lbt(&vcpu->arch))
>>>>>> +        return 0;
>>>>>> +
>>>>>> +    for (i = 1; i <= kvm_loongarch_num_lbt_regs(); i++) {
>>>>>> +        reg = (KVM_REG_LOONGARCH_LBT | KVM_REG_SIZE_U64 | i);
>>>>>> +        if (put_user(reg, uindices++))
>>>>>> +            return -EFAULT;
>>>>>> +    }
>>>>>> +
>>>>>> +    return 0;
>>>>>> +}
>>>>>> +
>>>>>>     long kvm_arch_vcpu_ioctl(struct file *filp,
>>>>>>                  unsigned int ioctl, unsigned long arg)
>>>>>>     {
>>>>>> @@ -1251,6 +1302,24 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>>>>>             r = kvm_loongarch_vcpu_set_attr(vcpu, &attr);
>>>>>>             break;
>>>>>>         }
>>>>>> +    case KVM_GET_REG_LIST: {
>>>>>> +        struct kvm_reg_list __user *user_list = argp;
>>>>>> +        struct kvm_reg_list reg_list;
>>>>>> +        unsigned n;
>>>>>> +
>>>>>> +        r = -EFAULT;
>>>>>> +        if (copy_from_user(&reg_list, user_list, sizeof(reg_list)))
>>>>>> +            break;
>>>>>> +        n = reg_list.n;
>>>>>> +        reg_list.n = kvm_loongarch_num_regs(vcpu);
>>>>>> +        if (copy_to_user(user_list, &reg_list, sizeof(reg_list)))
>>>>>> +            break;
>>>>>> +        r = -E2BIG;
>>>>>> +        if (n < reg_list.n)
>>>>>> +            break;
>>>>>> +        r = kvm_loongarch_copy_reg_indices(vcpu, user_list->reg);
>>>>>> +        break;
>>>>>> +    }
>>>>>>         default:
>>>>>>             r = -ENOIOCTLCMD;
>>>>>>             break;
>>>>>>
>>>>>
>>>> Thanks,
>>>> Zixing
>>>>
>>>
>> Thanks,
>> Zixing
>>
>
Thanks,

Zixing


