Return-Path: <kvm+bounces-42859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8A56A7E6FB
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 18:42:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB9213B5D55
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 16:35:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F104B20DD7B;
	Mon,  7 Apr 2025 16:34:42 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEDA820C49B;
	Mon,  7 Apr 2025 16:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744043682; cv=none; b=X3HpTa31TERZ9OX30+UBinDi+OecDTnkKzUFd93r4r9as18TXMg1BHR9rIhWX/uCrADR6uV6xyPaRlSc8IxIOtVVZZUZtXOyB0xFaeLUwe8aquxEqfI4hxU8j7WJWlpoDu1aDv9yoRyuaaKJ9zuNsoRj0OKcmNm4JbxNcWy8VNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744043682; c=relaxed/simple;
	bh=ZVHsOKk6Tki2Ik7EGodG3eEWIVhvhilPXpP937Jf5VI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NpiPeILxHh0uINMPCwiBdxI8K5H12SsvhpFVTNdim7oB4P0GAzbw2+7Zu9TVBHkV25At5HDeIKZIzj+0vij0p0AZ0+SmHem/k0h/kbsSe7YziNnrpm6BBPCENBp8UtqbQcKbdwJOayyebDLVBHGDrnNnER0qFSr3GdjWkRiuvqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 84324106F;
	Mon,  7 Apr 2025 09:34:41 -0700 (PDT)
Received: from [10.57.17.31] (unknown [10.57.17.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DCBFB3F694;
	Mon,  7 Apr 2025 09:34:35 -0700 (PDT)
Message-ID: <54f1fbb1-4fa1-4b09-bbac-3afcbb7ec478@arm.com>
Date: Mon, 7 Apr 2025 17:34:35 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 28/45] arm64: rme: support RSI_HOST_CALL
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-29-steven.price@arm.com>
 <12b5ba41-4b1e-4876-9796-d1d6bb344015@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <12b5ba41-4b1e-4876-9796-d1d6bb344015@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 04/03/2025 06:01, Gavin Shan wrote:
> On 2/14/25 2:14 AM, Steven Price wrote:
>> From: Joey Gouly <joey.gouly@arm.com>
>>
>> Forward RSI_HOST_CALLS to KVM's HVC handler.
>>
>> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v4:
>>   * Setting GPRS is now done by kvm_rec_enter() rather than
>>     rec_exit_host_call() (see previous patch - arm64: RME: Handle realm
>>     enter/exit). This fixes a bug where the registers set by user space
>>     were being ignored.
>> ---
>>   arch/arm64/kvm/rme-exit.c | 22 ++++++++++++++++++++++
>>   1 file changed, 22 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/rme-exit.c b/arch/arm64/kvm/rme-exit.c
>> index c785005f821f..4f7602aa3c6c 100644
>> --- a/arch/arm64/kvm/rme-exit.c
>> +++ b/arch/arm64/kvm/rme-exit.c
>> @@ -107,6 +107,26 @@ static int rec_exit_ripas_change(struct kvm_vcpu
>> *vcpu)
>>       return -EFAULT;
>>   }
>>   +static int rec_exit_host_call(struct kvm_vcpu *vcpu)
>> +{
>> +    int ret, i;
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +
>> +    vcpu->stat.hvc_exit_stat++;
>> +
>> +    for (i = 0; i < REC_RUN_GPRS; i++)
>> +        vcpu_set_reg(vcpu, i, rec->run->exit.gprs[i]);
>> +
>> +    ret = kvm_smccc_call_handler(vcpu);
>> +
>> +    if (ret < 0) {
>> +        vcpu_set_reg(vcpu, 0, ~0UL);
>> +        ret = 1;
>> +    }
>> +
>> +    return ret;
>> +}
>> +
> 
> I don't understand how a negative error can be returned from
> kvm_smccc_call_handler().

I don't believe it really can. However kvm_smccc_call_handler() calls
kvm_psci_call() and that has a documentation block which states:

 * This function returns: > 0 (success), 0 (success but exit to user
 * space), and < 0 (errors)
 *
 * Errors:
 * -EINVAL: Unrecognized PSCI function

But I can't actually see code which returns the negative value...

> Besides, SMCCC_RET_NOT_SUPPORTED has been set to GPR[0 - 3] if the
> request can't be
> supported. Why we need to set GPR[0] to ~0UL, which corresponds to
> SMCCC_RET_NOT_SUPPORTED
> if I'm correct. I guess change log or a comment to explain the questions
> would be
> nice.

I'll add a comment explaining we don't expect negative codes. And I'll
expand ~0UL to SMCCC_RET_NOT_SUPPORTED which is what it should be.

Thanks,
Steve

>>   static void update_arch_timer_irq_lines(struct kvm_vcpu *vcpu)
>>   {
>>       struct realm_rec *rec = &vcpu->arch.rec;
>> @@ -168,6 +188,8 @@ int handle_rec_exit(struct kvm_vcpu *vcpu, int
>> rec_run_ret)
>>           return rec_exit_psci(vcpu);
>>       case RMI_EXIT_RIPAS_CHANGE:
>>           return rec_exit_ripas_change(vcpu);
>> +    case RMI_EXIT_HOST_CALL:
>> +        return rec_exit_host_call(vcpu);
>>       }
>>         kvm_pr_unimpl("Unsupported exit reason: %u\n",
> 
> Thanks,
> Gavin
> 


