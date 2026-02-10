Return-Path: <kvm+bounces-70691-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4JFJOsekimmhMgAAu9opvQ
	(envelope-from <kvm+bounces-70691-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 04:23:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 69321116BA3
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 04:23:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E01773024961
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 03:23:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D83B3302753;
	Tue, 10 Feb 2026 03:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b="A7e7sz+J"
X-Original-To: kvm@vger.kernel.org
Received: from relay3.mymailcheap.com (relay3.mymailcheap.com [217.182.119.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775D8277017;
	Tue, 10 Feb 2026 03:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.182.119.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770693803; cv=none; b=TUhXmMXEtEnIgQvBG84rN8pOBovOKxuM6Jx5rLRYw6UUCPUZMxunhrinB/QGHgAbA4p20+I/MPuNTiGTxpYSu0gx9w3Ot4d5GsRMEZLos4G7npSKAm/6Py4mbwQJWyrUhZ7aSLxpkpAqGM1BQ6lRDytiowFblA3J5u70nW5Uego=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770693803; c=relaxed/simple;
	bh=Gq2n1OnOZVVPjYYFQIf3cFth+vTAwQXURO5ndm8jd7U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QS+L4x/kpZsVuZL/OKhfhzhZq9Odpra9ZxGH7DkgEWECJhoF8VuUbaKuFM6T3qhPfvrj0CCoaOSuWpt0d950Yu/iU0Di1L043K7DO2cXDpPdLbovim4GTxeXuc51lAlSlpWgrk/a7Hz4ynD792pVJ9IJb0wZ3u4/iCnASyplLww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io; spf=pass smtp.mailfrom=aosc.io; dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b=A7e7sz+J; arc=none smtp.client-ip=217.182.119.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aosc.io
Received: from nf1.mymailcheap.com (nf1.mymailcheap.com [51.75.14.91])
	by relay3.mymailcheap.com (Postfix) with ESMTPS id 3E6383E91A;
	Tue, 10 Feb 2026 03:23:14 +0000 (UTC)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
	by nf1.mymailcheap.com (Postfix) with ESMTPSA id CE84E400D5;
	Tue, 10 Feb 2026 03:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
	t=1770693793; bh=Gq2n1OnOZVVPjYYFQIf3cFth+vTAwQXURO5ndm8jd7U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=A7e7sz+J1r2OGzBip8WTdvcxwWpKrN4GhYIKaRIlKDnHdiAW63Bz7kM6oBmXs0jiU
	 NN84Mxmg42CXpsVUsHRInEgZl+miHNt0WEhx2G+QN1ia+t3PPdIWKXUr1vEuaWRPhM
	 EGYm31cXz9gQkhYy/XsFUNLZnIVxWVFVgoCTxqu0=
Received: from [127.0.0.1] (unknown [117.151.82.151])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail20.mymailcheap.com (Postfix) with ESMTPSA id 910F640B39;
	Tue, 10 Feb 2026 03:23:05 +0000 (UTC)
Message-ID: <c4be7e68-6e51-4f2b-8a51-bef658a8ac4a@aosc.io>
Date: Tue, 10 Feb 2026 11:23:02 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] KVM: Add KVM_GET_REG_LIST ioctl for LoongArch
Content-Language: en-US-large, en-US
To: Bibo Mao <maobibo@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 Huacai Chen <chenhuacai@kernel.org>
Cc: Kexy Biscuit <kexybiscuit@aosc.io>, Mingcong Bai <jeffbai@aosc.io>,
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260205051822.1318253-1-liushuyu@aosc.io>
 <aa35c7a6-6361-9f83-a726-89d7deff8560@loongson.cn>
From: liushuyu <liushuyu@aosc.io>
In-Reply-To: <aa35c7a6-6361-9f83-a726-89d7deff8560@loongson.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[aosc.io:s=default];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70691-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DMARC_NA(0.00)[aosc.io];
	DKIM_TRACE(0.00)[aosc.io:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[liushuyu@aosc.io,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 69321116BA3
X-Rspamd-Action: no action

Hi Bibo,

>
>
> On 2026/2/5 下午1:18, Zixing Liu wrote:
>> This ioctl can be used by the userspace applications to determine which
>> (special) registers are get/set-able in a meaningful way.
>>
>> This can be very useful for cross-platform VMMs so that they do not have
>> to hardcode register indices for each supported architectures.
>>
>> Signed-off-by: Zixing Liu <liushuyu@aosc.io>
>> ---
>>   Documentation/virt/kvm/api.rst |   2 +-
>>   arch/loongarch/kvm/vcpu.c      | 120 +++++++++++++++++++++++++++++++++
>>   2 files changed, 121 insertions(+), 1 deletion(-)
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
>> index 656b954c1134..de02e409ae39 100644
>> --- a/arch/loongarch/kvm/vcpu.c
>> +++ b/arch/loongarch/kvm/vcpu.c
>> @@ -5,6 +5,7 @@
>>     #include <linux/kvm_host.h>
>>   #include <asm/fpu.h>
>> +#include <asm/kvm_host.h>
>>   #include <asm/lbt.h>
>>   #include <asm/loongarch.h>
>>   #include <asm/setup.h>
>> @@ -14,6 +15,8 @@
>>   #define CREATE_TRACE_POINTS
>>   #include "trace.h"
>>   +#define NUM_LBT_REGS 6
>> +
>>   const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>>       KVM_GENERIC_VCPU_STATS(),
>>       STATS_DESC_COUNTER(VCPU, int_exits),
>> @@ -1186,6 +1189,105 @@ static int kvm_loongarch_vcpu_set_attr(struct
>> kvm_vcpu *vcpu,
>>       return ret;
>>   }
>>   +static int kvm_loongarch_walk_csrs(struct kvm_vcpu *vcpu, u64
>> __user *uindices)
>> +{
>> +    unsigned int i, count;
>> +    const unsigned int csrs_to_save[] = {
>> +        LOONGARCH_CSR_CRMD,      LOONGARCH_CSR_PRMD,
>> +        LOONGARCH_CSR_EUEN,      LOONGARCH_CSR_MISC,
>> +        LOONGARCH_CSR_ECFG,      LOONGARCH_CSR_ESTAT,
>> +        LOONGARCH_CSR_ERA,      LOONGARCH_CSR_BADV,
>> +        LOONGARCH_CSR_BADI,      LOONGARCH_CSR_EENTRY,
>> +        LOONGARCH_CSR_TLBIDX,      LOONGARCH_CSR_TLBEHI,
>> +        LOONGARCH_CSR_TLBELO0,      LOONGARCH_CSR_TLBELO1,
>> +        LOONGARCH_CSR_ASID,      LOONGARCH_CSR_PGDL,
>> +        LOONGARCH_CSR_PGDH,      LOONGARCH_CSR_PGD,
>> +        LOONGARCH_CSR_PWCTL0,      LOONGARCH_CSR_PWCTL1,
>> +        LOONGARCH_CSR_STLBPGSIZE, LOONGARCH_CSR_RVACFG,
>> +        LOONGARCH_CSR_CPUID,      LOONGARCH_CSR_PRCFG1,
>> +        LOONGARCH_CSR_PRCFG2,      LOONGARCH_CSR_PRCFG3,
>> +        LOONGARCH_CSR_KS0,      LOONGARCH_CSR_KS1,
>> +        LOONGARCH_CSR_KS2,      LOONGARCH_CSR_KS3,
>> +        LOONGARCH_CSR_KS4,      LOONGARCH_CSR_KS5,
>> +        LOONGARCH_CSR_KS6,      LOONGARCH_CSR_KS7,
>> +        LOONGARCH_CSR_TMID,      LOONGARCH_CSR_CNTC,
>> +        LOONGARCH_CSR_TINTCLR,      LOONGARCH_CSR_LLBCTL,
>> +        LOONGARCH_CSR_IMPCTL1,      LOONGARCH_CSR_IMPCTL2,
>> +        LOONGARCH_CSR_TLBRENTRY,  LOONGARCH_CSR_TLBRBADV,
>> +        LOONGARCH_CSR_TLBRERA,      LOONGARCH_CSR_TLBRSAVE,
>> +        LOONGARCH_CSR_TLBRELO0,      LOONGARCH_CSR_TLBRELO1,
>> +        LOONGARCH_CSR_TLBREHI,      LOONGARCH_CSR_TLBRPRMD,
>> +        LOONGARCH_CSR_DMWIN0,      LOONGARCH_CSR_DMWIN1,
>> +        LOONGARCH_CSR_DMWIN2,      LOONGARCH_CSR_DMWIN3,
>> +        LOONGARCH_CSR_TVAL,      LOONGARCH_CSR_TCFG,
>> +    };
> this increases much kernel stack size usage :)
>
> Please wait a moment, I am considering how to cleanup code about CSR
> registers.
Okay.
> And KVM_GET_REG_LIST is not so urgent, else there is
> KVM_read_from_REG_LIST/KVM_write_from_REG_LIST ioctl commands to
> access registers in batch mode. 
>
Adding KVM_GET_REG_LIST is not urgent. However, unlike
KVM_read_from_REG_LIST and KVM_write_from_REG_LIST, KVM_GET_REG_LIST
serves a different purpose.

The KVM_GET_REG_LIST ioctl lets user-space VMMs determine the number of
get/set-able registers (via KVM_GET_ONE_REG/KVM_SET_ONE_REG) and their
register IDs. User-space VMMs use this ioctl so they don't have to
hardcode a register ID table for each architecture.

I also had trouble finding information on the KVM_read_from_REG_LIST and
KVM_write_from_REG_LIST ioctl commands. As of commit
3d29a326eba82d987a82fd59379d6d668b769965, I could not find any logic or
identifiers for these two ioctls.

In some cases, KVM_GET_REG_LIST is a prerequisite for using
KVM_read_from_REG_LIST or KVM_write_from_REG_LIST (assuming they exist),
as you still need to know the register IDs to use these ioctls.

> Regards
> Bibo Mao
>
>> +
>> +    for (i = 0, count = 0;
>> +         i < sizeof(csrs_to_save) / sizeof(csrs_to_save[0]); i++) {
>> +        const u64 reg = KVM_IOC_CSRID(i);
>> +        if (uindices && put_user(reg, uindices++))
>> +            return -EFAULT;
>> +        count++;
>> +    }
>> +
>> +    /* Skip PMU CSRs if not supported by the guest */
>> +    if (!kvm_guest_has_pmu(&vcpu->arch))
>> +        return count;
>> +    for (i = LOONGARCH_CSR_PERFCTRL0; i <= LOONGARCH_CSR_PERFCNTR3;
>> i++) {
>> +        const u64 reg = KVM_IOC_CSRID(i);
>> +        if (uindices && put_user(reg, uindices++))
>> +            return -EFAULT;
>> +        count++;
>> +    }
>> +
>> +    return count;
>> +}
>> +
>> +static unsigned long kvm_loongarch_num_regs(struct kvm_vcpu *vcpu)
>> +{
>> +    /* +1 for the KVM_REG_LOONGARCH_COUNTER register */
>> +    unsigned long res =
>> +        kvm_loongarch_walk_csrs(vcpu, NULL) + KVM_MAX_CPUCFG_REGS + 1;
>> +
>> +    if (kvm_guest_has_lbt(&vcpu->arch))
>> +        res += NUM_LBT_REGS;
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
>> +    i = kvm_loongarch_walk_csrs(vcpu, uindices);
>> +    if (i < 0)
>> +        return i;
>> +    uindices += i;
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
>> +    for (i = 1; i <= NUM_LBT_REGS; i++) {
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
>> @@ -1251,6 +1353,24 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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

