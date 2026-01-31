Return-Path: <kvm+bounces-69780-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kAsyDxUNfmlbVAIAu9opvQ
	(envelope-from <kvm+bounces-69780-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 15:09:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EF5D4C22C1
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 15:09:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8C18D3009990
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 14:09:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8FCB354AD9;
	Sat, 31 Jan 2026 14:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b="QvjPHoHw"
X-Original-To: kvm@vger.kernel.org
Received: from relay4.mymailcheap.com (relay4.mymailcheap.com [137.74.80.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783821C5D5E;
	Sat, 31 Jan 2026 14:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=137.74.80.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769868553; cv=none; b=hpgxlYPIsYeSxkwBpHO7p5f0sD+H25vJfo9IdRUP04I60InLzCklaorIDfc0lcQMCl2p52gEyU1GWj/qG1AV4vzRP5hl1FTPaiIrTf6hwFX4rntoov61hrfzyjtstD0jMw4aGAsA6hhVVDGGrbeQvea3EZGLzJsLyGWlNwnSmXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769868553; c=relaxed/simple;
	bh=wKjWwAJDesOvn1+Zai9dJuWomkGTs+IRFJbxkSgLNQk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bgiol1ce17fb0Mh98E9A22cU2lnSTuG9kYhlr06DJAZWxsx7rrYFQrzHjl8k8FNGgZ0Wxii7jIVPKoiZ2Rzaf5Bxu2b3EvuARbC0U5NoE6urp/7Me4hVrxg+C3rWki+yJ+1xpxbCA4ArypP18wimfUyC/QcdXTyGQigBSoKEol8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io; spf=pass smtp.mailfrom=aosc.io; dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b=QvjPHoHw; arc=none smtp.client-ip=137.74.80.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aosc.io
Received: from nf1.mymailcheap.com (nf1.mymailcheap.com [51.75.14.91])
	by relay4.mymailcheap.com (Postfix) with ESMTPS id 78742202EF;
	Sat, 31 Jan 2026 14:09:09 +0000 (UTC)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
	by nf1.mymailcheap.com (Postfix) with ESMTPSA id 25FD8400D5;
	Sat, 31 Jan 2026 14:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
	t=1769868544; bh=wKjWwAJDesOvn1+Zai9dJuWomkGTs+IRFJbxkSgLNQk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QvjPHoHwEgO8gx+Zhcn2hOoHbSeVsG7b6cx6tkxsFow0OTUhuRBe2Qqk0uxNof75i
	 k9FX9PaXUMxSwqOQn53lizfLeNcjGoIl3/iRdmdAa3XNFWO8KwWD+nSXk4RcyMwOZg
	 XxAy1jldNZixA8pMXBLcyoMBnsHghh+J3B32ottQ=
Received: from [127.0.0.1] (unknown [117.151.13.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail20.mymailcheap.com (Postfix) with ESMTPSA id 24E3740F79;
	Sat, 31 Jan 2026 14:08:51 +0000 (UTC)
Message-ID: <b89a22a3-be55-4c86-99e3-84759e362309@aosc.io>
Date: Sat, 31 Jan 2026 22:08:47 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 RESEND] KVM: Add KVM_GET_REG_LIST ioctl for LoongArch
Content-Language: en-US-large, en-US
To: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>, Bibo Mao <maobibo@loongson.cn>,
 Kexy Biscuit <kexybiscuit@aosc.io>, Mingcong Bai <jeffbai@aosc.io>,
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260131060600.169748-1-liushuyu@aosc.io>
 <CAAhV-H7g4StjP5fnHVVEyR_xFx9=fg6S9UuHWnPpMV_k=ZVGGw@mail.gmail.com>
From: liushuyu <liushuyu@aosc.io>
In-Reply-To: <CAAhV-H7g4StjP5fnHVVEyR_xFx9=fg6S9UuHWnPpMV_k=ZVGGw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[aosc.io:s=default];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-69780-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DMARC_NA(0.00)[aosc.io];
	DKIM_TRACE(0.00)[aosc.io:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[liushuyu@aosc.io,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: EF5D4C22C1
X-Rspamd-Action: no action

Hi Huacai,

> Hi, Zixing,
>
> On Sat, Jan 31, 2026 at 2:07 PM Zixing Liu <liushuyu@aosc.io> wrote:
>> This ioctl can be used by the userspace applications to determine which
>> (special) registers are get/set-able in a meaningful way.
>>
>> This can be very useful for cross-platform VMMs so that they do not have
>> to hardcode register indices for each supported architectures.
>>
>> Signed-off-by: Zixing Liu <liushuyu@aosc.io>
>> ---
>>  Documentation/virt/kvm/api.rst |  2 +-
>>  arch/loongarch/kvm/vcpu.c      | 85 ++++++++++++++++++++++++++++++++++
>>  2 files changed, 86 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index 01a3abef8abb..f46dd8be282f 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -3603,7 +3603,7 @@ VCPU matching underlying host.
>>  ---------------------
>>
>>  :Capability: basic
>> -:Architectures: arm64, mips, riscv, x86 (if KVM_CAP_ONE_REG)
>> +:Architectures: arm64, loongarch, mips, riscv, x86 (if KVM_CAP_ONE_REG)
>>  :Type: vcpu ioctl
>>  :Parameters: struct kvm_reg_list (in/out)
>>  :Returns: 0 on success; -1 on error
>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>> index 656b954c1134..ed11438f4544 100644
>> --- a/arch/loongarch/kvm/vcpu.c
>> +++ b/arch/loongarch/kvm/vcpu.c
>> @@ -1186,6 +1186,73 @@ static int kvm_loongarch_vcpu_set_attr(struct kvm_vcpu *vcpu,
>>         return ret;
>>  }
>>
>> +static int kvm_loongarch_walk_csrs(struct kvm_vcpu *vcpu, u64 __user *uindices)
>> +{
>> +       unsigned int i, count;
>> +
>> +       for (i = 0, count = 0; i < CSR_MAX_NUMS; i++) {
>> +               if (!(get_gcsr_flag(i) & (SW_GCSR | HW_GCSR)))
>> +                       continue;
>> +               const u64 reg = KVM_IOC_CSRID(i);
>> +               if (uindices && put_user(reg, uindices++))
>> +                       return -EFAULT;
>> +               count++;
>> +       }
>> +
>> +       return count;
>> +}
>> +
>> +static unsigned long kvm_loongarch_num_lbt_regs(void)
>> +{
>> +       /* +1 for the LBT_FTOP flag (inside arch.fpu) */
>> +       return sizeof(struct loongarch_lbt) / sizeof(unsigned long) + 1;
>> +}
> This function has only one line, I think it is better to embed it into
> the caller.

This function was used twice in this patch. If the hardware gained more
LBT registers that are not recorded in `struct loongarch_lbt` in the
future, I am afraid changing manually inlined logic will be a bit
error-prone.

Maybe one compromise would be making this a `const` variable somewhere
in this file instead of a function? What do you think?

> Huacai

Thanks,

Zixing

>> +
>> +static unsigned long kvm_loongarch_num_regs(struct kvm_vcpu *vcpu)
>> +{
>> +       /* +1 for the KVM_REG_LOONGARCH_COUNTER register */
>> +       unsigned long res =
>> +               kvm_loongarch_walk_csrs(vcpu, NULL) + KVM_MAX_CPUCFG_REGS + 1;
>> +
>> +       if (kvm_guest_has_lbt(&vcpu->arch))
>> +               res += kvm_loongarch_num_lbt_regs();
>> +
>> +       return res;
>> +}
>> +
>> +static int kvm_loongarch_copy_reg_indices(struct kvm_vcpu *vcpu,
>> +                                         u64 __user *uindices)
>> +{
>> +       u64 reg;
>> +       unsigned int i;
>> +
>> +       i = kvm_loongarch_walk_csrs(vcpu, uindices);
>> +       if (i < 0)
>> +               return i;
>> +       uindices += i;
>> +
>> +       for (i = 0; i < KVM_MAX_CPUCFG_REGS; i++) {
>> +               reg = KVM_IOC_CPUCFG(i);
>> +               if (put_user(reg, uindices++))
>> +                       return -EFAULT;
>> +       }
>> +
>> +       reg = KVM_REG_LOONGARCH_COUNTER;
>> +       if (put_user(reg, uindices++))
>> +               return -EFAULT;
>> +
>> +       if (!kvm_guest_has_lbt(&vcpu->arch))
>> +               return 0;
>> +
>> +       for (i = 1; i <= kvm_loongarch_num_lbt_regs(); i++) {
>> +               reg = (KVM_REG_LOONGARCH_LBT | KVM_REG_SIZE_U64 | i);
>> +               if (put_user(reg, uindices++))
>> +                       return -EFAULT;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>>  long kvm_arch_vcpu_ioctl(struct file *filp,
>>                          unsigned int ioctl, unsigned long arg)
>>  {
>> @@ -1251,6 +1318,24 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>                 r = kvm_loongarch_vcpu_set_attr(vcpu, &attr);
>>                 break;
>>         }
>> +       case KVM_GET_REG_LIST: {
>> +               struct kvm_reg_list __user *user_list = argp;
>> +               struct kvm_reg_list reg_list;
>> +               unsigned n;
>> +
>> +               r = -EFAULT;
>> +               if (copy_from_user(&reg_list, user_list, sizeof(reg_list)))
>> +                       break;
>> +               n = reg_list.n;
>> +               reg_list.n = kvm_loongarch_num_regs(vcpu);
>> +               if (copy_to_user(user_list, &reg_list, sizeof(reg_list)))
>> +                       break;
>> +               r = -E2BIG;
>> +               if (n < reg_list.n)
>> +                       break;
>> +               r = kvm_loongarch_copy_reg_indices(vcpu, user_list->reg);
>> +               break;
>> +       }
>>         default:
>>                 r = -ENOIOCTLCMD;
>>                 break;
>> --
>> 2.52.0
>>

