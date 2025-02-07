Return-Path: <kvm+bounces-37612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B3F7DA2C9BE
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 18:05:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B16907A7917
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 17:04:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE73A195381;
	Fri,  7 Feb 2025 17:05:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCE4118DB3A;
	Fri,  7 Feb 2025 17:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738947920; cv=none; b=rJlsZdv+FSmLtL8ZMCeO/c05mWh9rRA+YEL5hNxBPUXqIYCv33E1ttj4JiiOeHsBq54qQT85zRwe3fM0SZ6tid7q88G8Xu54n71SO5cIcpt6I91NYOOb2ifQXk/1q1YfsFThE0isMNjwdHQQwTaKCEsHwzHqoqj2G1S0YDcLsb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738947920; c=relaxed/simple;
	bh=OMT6o3zvGMA4/AcTLvMTo16S6Q4Z08p3D8wSVmR3b1s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JEN/5uuerJq0nvVbf9qYjeKPjEXzbr1dxd+YCtUfcfaE3YW3tIEuSyxp8VgT3Ga+AsMB29geU6ppbQV0FvUbOJPoFmyGOwU6zxrgs7kSKrkfjEQicvQlkC8lajpPhQ1ZM2ygLhQBJyROydYxfaW1senYc6Kc+XwScCAYutXTWlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 18D66113E;
	Fri,  7 Feb 2025 09:05:41 -0800 (PST)
Received: from [10.1.26.24] (e122027.cambridge.arm.com [10.1.26.24])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D53073F63F;
	Fri,  7 Feb 2025 09:05:13 -0800 (PST)
Message-ID: <9f4ff6dd-b2e1-411a-a231-4575be04540d@arm.com>
Date: Fri, 7 Feb 2025 17:05:13 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 27/43] arm64: rme: support RSI_HOST_CALL
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
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-28-steven.price@arm.com>
 <69a424e0-1350-484c-9ce7-b40c4fcacd8e@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <69a424e0-1350-484c-9ce7-b40c4fcacd8e@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 02/02/2025 06:41, Gavin Shan wrote:
> On 12/13/24 1:55 AM, Steven Price wrote:
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
>> index 8f0f9ab57f28..b2a367474d74 100644
>> --- a/arch/arm64/kvm/rme-exit.c
>> +++ b/arch/arm64/kvm/rme-exit.c
>> @@ -103,6 +103,26 @@ static int rec_exit_ripas_change(struct kvm_vcpu
>> *vcpu)
>>       return 0;
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
> It seems that the return value from kvm_smccc_call() won't be negative.

Well the comment above kvm_psci_call() explains that the return value
can be negative which would be passed through, so there's definitely a
convention that it could be negative. However...

> Besides,
> the host call requests are currently handled by kvm_psci_call(), which
> isn't
> what we want.

Indeed, we shouldn't be getting PSCI calls this way as the RMM needs to
be involved for proper handling of PSCI.

> So I think a new helper is needed and called in> kvm_smccc_call_handler().
> The new helper simply push the error (NOT_SUPPORTED) to x0. Otherwise, a
> unexpected
> return value will be seen by guest.
> 
> handle_rec_exit
>   rec_exit_host_call
>     kvm_smccc_call_handler


I'm not sure I follow here. Are you saying that we should have separate
handling of HOST_CALLs to SMCCC? That's certainly a possibility, but the
expectation is that HOST_CALL is effectively equivalent to a simple
SMC/HVC call in a normal guest. To be honest a "Realm Host Interface" is
something that we're currently lacking a spec for.

Thanks,
Steve

>>   static void update_arch_timer_irq_lines(struct kvm_vcpu *vcpu)
>>   {
>>       struct realm_rec *rec = &vcpu->arch.rec;
>> @@ -164,6 +184,8 @@ int handle_rec_exit(struct kvm_vcpu *vcpu, int
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


