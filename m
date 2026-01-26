Return-Path: <kvm+bounces-69074-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4OAhO/ThdmlVYQEAu9opvQ
	(envelope-from <kvm+bounces-69074-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 04:39:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D8D383B68
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 04:39:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2D627300B462
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 03:39:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA6842C0F63;
	Mon, 26 Jan 2026 03:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b="pqHPWPwi"
X-Original-To: kvm@vger.kernel.org
Received: from relay-us1.mymailcheap.com (relay-us1.mymailcheap.com [51.81.35.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FA8128816;
	Mon, 26 Jan 2026 03:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.81.35.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769398751; cv=none; b=J/UQAb79S7Jd8bh8mweqPf50KNK4imMRvcP5269bd6+oCNzMhhBMmOrip9IwJFoNUgn000M7/PwuY/496dYO66WN3pYwyiaBFT94PRw8dMOQO6Zrvx7HOH59xtbQecZyN9GDSIq2QsEx8O595s4GZWzTBy2ycEgS7vCiTDrksF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769398751; c=relaxed/simple;
	bh=QDen/lbFr0OrqZPB+Q+4DSK6r/05MWks/Pa21Xlsmko=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bTgTIYPDKJ1ivQ4rIHCREXjIVIqJtZndy5HvirfxmcqrbFAm0JAofTR8bNZStFsBj8h7t1mlI4i0HbRTQCNqvcZVrOvYo1/Nki3fl7X8Bxm97z80xCeTcgSFjTO65VsZIw3mtQWEGK8VWmjvJKTIfny6x7AHyz8nfcfiTBn/CFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io; spf=pass smtp.mailfrom=aosc.io; dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b=pqHPWPwi; arc=none smtp.client-ip=51.81.35.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aosc.io
Received: from relay5.mymailcheap.com (relay5.mymailcheap.com [159.100.248.207])
	by relay-us1.mymailcheap.com (Postfix) with ESMTPS id EEB0C20224;
	Mon, 26 Jan 2026 03:39:08 +0000 (UTC)
Received: from relay3.mymailcheap.com (relay3.mymailcheap.com [217.182.119.155])
	by relay5.mymailcheap.com (Postfix) with ESMTPS id ECE3626344;
	Mon, 26 Jan 2026 03:38:59 +0000 (UTC)
Received: from nf1.mymailcheap.com (nf1.mymailcheap.com [51.75.14.91])
	by relay3.mymailcheap.com (Postfix) with ESMTPS id 3D6EC3EC2C;
	Mon, 26 Jan 2026 03:38:52 +0000 (UTC)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
	by nf1.mymailcheap.com (Postfix) with ESMTPSA id 5BDD1400D5;
	Mon, 26 Jan 2026 03:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
	t=1769398731; bh=QDen/lbFr0OrqZPB+Q+4DSK6r/05MWks/Pa21Xlsmko=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pqHPWPwiV6w8D+jP5a1SfHUfFaPayXRCL+6lqyAMLthoyY83zoVlQpSbXwoatvvOZ
	 MR38O49DqVOvkLu5ueU65Ys/AzfihVeNlKr0rd2S5PlY8kaXEVEsh+xC2tvxSJ4W/V
	 HuHPJGbCHFp7l60rCJGduqiA4dxhTXHFZ7IqWK70=
Received: from [127.0.0.1] (unknown [117.151.13.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail20.mymailcheap.com (Postfix) with ESMTPSA id 60F7C4097F;
	Mon, 26 Jan 2026 03:38:44 +0000 (UTC)
Message-ID: <972430be-d2f3-49b6-851b-a057ddfcafec@aosc.io>
Date: Mon, 26 Jan 2026 11:38:41 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] KVM: Add KVM_GET_REG_LIST ioctl for LoongArch
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
From: liushuyu <liushuyu@aosc.io>
Content-Language: en-US-large, en-US
In-Reply-To: <4b504274-4241-0e3e-3ed3-7804b72b7ee8@loongson.cn>
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
	TAGGED_FROM(0.00)[bounces-69074-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	DMARC_NA(0.00)[aosc.io];
	FORGED_SENDER_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[27];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[aosc.io,redhat.com,lwn.net,loongson.cn,kernel.org,dabbelt.com,eecs.berkeley.edu,ghiti.fr,gmail.com,garyguo.net,protonmail.com,google.com,umich.edu,vger.kernel.org,lists.linux.dev,lists.infradead.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[liushuyu@aosc.io,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[aosc.io:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 4D8D383B68
X-Rspamd-Action: no action

Hi Bibo,
>
>
> On 2026/1/25 下午1:43, Zixing Liu wrote:
>> This ioctl can be used by userspace applications to determine which
>> (special) registers are get/set-able.
>>
>> This can be very useful for cross-platform VMMs so that they do not have
>> to hardcode register indices for each supported architectures.
>>
>> Signed-off-by: Zixing Liu <liushuyu@aosc.io>
>> ---
>>
>> For example, this ioctl could be used by rust-vmm/rust-kvm or maybe
>> VirtualBox-kvm in the future.
>>
>>   Documentation/virt/kvm/api.rst |  2 +-
>>   arch/loongarch/kvm/vcpu.c      | 69 ++++++++++++++++++++++++++++++++++
>>   2 files changed, 70 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst
>> b/Documentation/virt/kvm/api.rst
>> index 01a3abef8abb..f46dd8be282f 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -3603,7 +3603,7 @@ VCPU matching underlying host.
>>   ---------------------
>>     :Capability: basic
>> -:Architectures: arm64, mips, riscv, x86 (if KVM_CAP_ONE_REG)
>> +:Architectures: arm64, loongarch, mips, riscv, x86 (if KVM_CAP_ONE_REG)
>>   :Type: vcpu ioctl
>>   :Parameters: struct kvm_reg_list (in/out)
>>   :Returns: 0 on success; -1 on error
>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>> index 656b954c1134..b884eb9c76aa 100644
>> --- a/arch/loongarch/kvm/vcpu.c
>> +++ b/arch/loongarch/kvm/vcpu.c
>> @@ -1186,6 +1186,57 @@ static int kvm_loongarch_vcpu_set_attr(struct
>> kvm_vcpu *vcpu,
>>       return ret;
>>   }
>>   +static unsigned long kvm_loongarch_num_lbt_regs(void)
>> +{
>> +    /* +1 for the LBT_FTOP flag (inside arch.fpu) */
>> +    return sizeof(struct loongarch_lbt) / sizeof(unsigned long) + 1;
>> +}
>> +
>> +static unsigned long kvm_loongarch_num_regs(struct kvm_vcpu *vcpu)
>> +{
>> +    /* +1 for the KVM_REG_LOONGARCH_COUNTER register */
>> +    unsigned long res = CSR_MAX_NUMS + KVM_MAX_CPUCFG_REGS + 1;
>> +
>> +    if (kvm_guest_has_lbt(&vcpu->arch))
>> +        res += kvm_loongarch_num_lbt_regs();
>> +
>> +    return res;
>> +}
>> +
>> +static int kvm_loongarch_copy_reg_indices(struct kvm_vcpu *vcpu,
>> +                      u64 __user *uindices)
>> +{
>> +    u64 reg;
>> +    unsigned int i;
>> +
>> +    for (i = 0; i < CSR_MAX_NUMS; i++) {
>> +        reg = KVM_IOC_CSRID(i);
>> +        if (put_user(reg, uindices++))
>> +            return -EFAULT;
>> +    }
> CSR_MAX_NUMS is max number of accessible CSR registers, instead only
> part of them is used by vCPU model. By my understanding, there will be
> no much meaning if CSR_MAX_NUMS is returned. And I think it will be
> better if real CSR register id and number is returned. 
>
Did you mean we should only return the CSR registers initialized in this
function
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/loongarch/kvm/main.c?id=63804fed149a6750ffd28610c5c1c98cce6bd377#n48
?

That looks like a very large list and the values of the register IDs are
not fully continuous. If that is the case, how do we maintain the
get/set-able CSR register list?

> Regards
> Bibo Mao
>> +
>> +    for (i = 0; i < KVM_MAX_CPUCFG_REGS; i++) {
>> +        reg = KVM_IOC_CPUCFG(i);
>> +        if (put_user(reg, uindices++))
>> +            return -EFAULT;
>> +    }
>> +
>> +    reg = KVM_REG_LOONGARCH_COUNTER;
>> +    if (put_user(reg, uindices++))
>> +        return -EFAULT;
>> +
>> +    if (!kvm_guest_has_lbt(&vcpu->arch))
>> +        return 0;
>> +
>> +    for (i = 1; i <= kvm_loongarch_num_lbt_regs(); i++) {
>> +        reg = (KVM_REG_LOONGARCH_LBT | KVM_REG_SIZE_U64 | i);
>> +        if (put_user(reg, uindices++))
>> +            return -EFAULT;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>>   long kvm_arch_vcpu_ioctl(struct file *filp,
>>                unsigned int ioctl, unsigned long arg)
>>   {
>> @@ -1251,6 +1302,24 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>           r = kvm_loongarch_vcpu_set_attr(vcpu, &attr);
>>           break;
>>       }
>> +    case KVM_GET_REG_LIST: {
>> +        struct kvm_reg_list __user *user_list = argp;
>> +        struct kvm_reg_list reg_list;
>> +        unsigned n;
>> +
>> +        r = -EFAULT;
>> +        if (copy_from_user(&reg_list, user_list, sizeof(reg_list)))
>> +            break;
>> +        n = reg_list.n;
>> +        reg_list.n = kvm_loongarch_num_regs(vcpu);
>> +        if (copy_to_user(user_list, &reg_list, sizeof(reg_list)))
>> +            break;
>> +        r = -E2BIG;
>> +        if (n < reg_list.n)
>> +            break;
>> +        r = kvm_loongarch_copy_reg_indices(vcpu, user_list->reg);
>> +        break;
>> +    }
>>       default:
>>           r = -ENOIOCTLCMD;
>>           break;
>>
>
Thanks,
Zixing

