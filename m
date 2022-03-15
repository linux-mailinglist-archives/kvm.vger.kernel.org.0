Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC05B4D9481
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 07:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345145AbiCOGUP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 02:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240909AbiCOGUO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 02:20:14 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD8C29817
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 23:19:02 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id v4so16919854pjh.2
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 23:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=3wytI+o6bwtJ4Dpfg7rMXu2s2dNhaBrevNAlydfmJ9Y=;
        b=OjRLETlcyNryp6ynLIRerLTLcyAH/ACgm0fvpqm0MhnGxLC7h3VPAuEf5Dz8Ksxw7L
         dNgxQpy1/FFtwsX5penzTbRtcG00wrGSC8vmCMVyca9Y7VFSRNpZmV2keWdIpYPSvwlb
         1ou4wd27MLb9waDHJtDPzCdSBUILAPs2gxk+YCPL8cMuhlML0nK9+iaMsjojzTF8f7NZ
         mYs9MFkq21Nux/3ukhJetZC4VnB4bFSf5FK3MM5WpJS6ajHB4glX3poitDlI1cyQ05s2
         3BhlB7updjFgnQcjQki7qDTowfnGExnwYZKp+E1Ir9M8pnL+yk6IdEfK1t+ZFeshl3Di
         3Fmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3wytI+o6bwtJ4Dpfg7rMXu2s2dNhaBrevNAlydfmJ9Y=;
        b=Hi3SYjZnSTaOd79vAd6b5RITKxlEnxvfjlh7QwZLeXYVzZr9vjGGoP/R9UpuGNtmNA
         3VYnUHq+8kVnzILarQCfdLU8+gXfty8+3FRqObVjqmWfcZY3+yfekvu/RJP6JN/m5LZh
         ruuHOR7dR6H4Nmqy2VR61zI21kcDBtSH0G4yk/Ft1OWm1Hb9gAuvri0FWgTCQRJGRqCq
         AzO93iSpm3FCK58uANLB2/QCgk6mrZcUpcNKg1umVaxgyx1HpFboimm40r4YlDZ0Ng22
         2iJBVoL5+LUmhkuYl99jrYBbPEk9s+q4rVXQrEUaNeoLufMiNbHBy9yORngc8vdHmc8q
         LZQQ==
X-Gm-Message-State: AOAM531BzhoVPWJ56cAltzFWPWHLiZxlSiQirhKpgk1i1NUfcY8ei6ie
        eLTamqHXwXNizw52GfoSCceEQg==
X-Google-Smtp-Source: ABdhPJxij0wVnX33VjeJ6aT13GHWGNxA95HSixBLiLXvpL/1AJ0HETrmJfzBHOqwi/Rmeggu/BoT8Q==
X-Received: by 2002:a17:90b:1809:b0:1bf:7e9:bdf5 with SMTP id lw9-20020a17090b180900b001bf07e9bdf5mr2881531pjb.52.1647325141594;
        Mon, 14 Mar 2022 23:19:01 -0700 (PDT)
Received: from [192.168.86.237] (107-203-254-183.lightspeed.sntcca.sbcglobal.net. [107.203.254.183])
        by smtp.gmail.com with ESMTPSA id m19-20020a17090ab79300b001c5ddc6ff21sm1525563pjr.8.2022.03.14.23.18.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 23:19:01 -0700 (PDT)
Message-ID: <27834312-1877-f244-634d-6e645dea9f9e@google.com>
Date:   Mon, 14 Mar 2022 23:18:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v4 2/3] KVM: arm64: mixed-width check should be skipped
 for uninitialized vCPUs
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
References: <20220314061959.3349716-1-reijiw@google.com>
 <20220314061959.3349716-3-reijiw@google.com> <Yi+j7zGxA80ZR4t7@google.com>
From:   Reiji Watanabe <reijiw@google.com>
In-Reply-To: <Yi+j7zGxA80ZR4t7@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On 3/14/22 1:22 PM, Oliver Upton wrote:
> On Sun, Mar 13, 2022 at 11:19:58PM -0700, Reiji Watanabe wrote:
>> KVM allows userspace to configure either all EL1 32bit or 64bit vCPUs
>> for a guest.  At vCPU reset, vcpu_allowed_register_width() checks
>> if the vcpu's register width is consistent with all other vCPUs'.
>> Since the checking is done even against vCPUs that are not initialized
>> (KVM_ARM_VCPU_INIT has not been done) yet, the uninitialized vCPUs
>> are erroneously treated as 64bit vCPU, which causes the function to
>> incorrectly detect a mixed-width VM.
>>
>> Introduce KVM_ARCH_FLAG_EL1_32BIT and KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED
>> bits for kvm->arch.flags.  A value of the EL1_32BIT bit indicates that
>> the guest needs to be configured with all 32bit or 64bit vCPUs, and
>> a value of the REG_WIDTH_CONFIGURED bit indicates if a value of the
>> EL1_32BIT bit is valid (already set up). Values in those bits are set at
>> the first KVM_ARM_VCPU_INIT for the guest based on KVM_ARM_VCPU_EL1_32BIT
>> configuration for the vCPU.
>>
>> Check vcpu's register width against those new bits at the vcpu's
>> KVM_ARM_VCPU_INIT (instead of against other vCPUs' register width).
>>
>> Fixes: 66e94d5cafd4 ("KVM: arm64: Prevent mixed-width VM creation")
>> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> 
> Hrmph... I hate to be asking this question so late in the game, but...
> 
> Are there any bits that we really allow variation per-vCPU besides
> KVM_ARM_VCPU_POWER_OFF? We unintentionally allow for variance with the
> KVM_ARM_VCPU_PSCI_0_2 bit even though that's complete nonsense.
> 
> Stated plainly, should we just deny any attempts at asymmetry besides
> POWER_OFF?> 
> Besides the nits, I see nothing objectionable with the patch. I'd really
> like to see more generalized constraints on vCPU configuration, but if
> this is the route we take:

Prohibiting the mixed width configuration is not a new constraint that
this patch creates (this patch fixes a bug that erroneously detects
mixed-width configuration), and enforcing symmetry of other features
among vCPUs is a bit different matter.

Having said that, I like the idea, which will be more consistent with
my ID register series (it can simplify things).  But, I'm not sure
if creating the constraint for those features would be a problem for
existing userspace even if allowing variation per-vCPU for the features
was not our intention.
I would guess having the constraint for KVM_ARM_VCPU_PSCI_0_2 should
be fine.  Do you think that should be fine for PMU, SVE, and PTRAUTH*
as well ?


> 
> Reviewed-by: Oliver Upton <oupton@google.com>
> 
>> ---
>>   arch/arm64/include/asm/kvm_emulate.h | 27 ++++++++----
>>   arch/arm64/include/asm/kvm_host.h    |  9 ++++
>>   arch/arm64/kvm/reset.c               | 64 ++++++++++++++++++----------
>>   3 files changed, 70 insertions(+), 30 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>> index d62405ce3e6d..7496deab025a 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -43,10 +43,22 @@ void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
>>   
>>   void kvm_vcpu_wfi(struct kvm_vcpu *vcpu);
>>   
>> +#if defined(__KVM_VHE_HYPERVISOR__) || defined(__KVM_NVHE_HYPERVISOR__)
>>   static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
>>   {
>>   	return !(vcpu->arch.hcr_el2 & HCR_RW);
>>   }
>> +#else
>> +static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm *kvm = vcpu->kvm;
>> +
>> +	WARN_ON_ONCE(!test_bit(KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED,
>> +			       &kvm->arch.flags));
>> +
>> +	return test_bit(KVM_ARCH_FLAG_EL1_32BIT, &kvm->arch.flags);
>> +}
>> +#endif
>>   
>>   static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
>>   {
>> @@ -72,15 +84,14 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
>>   		vcpu->arch.hcr_el2 |= HCR_TVM;
>>   	}
>>   
>> -	if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
>> +	if (vcpu_el1_is_32bit(vcpu))
>>   		vcpu->arch.hcr_el2 &= ~HCR_RW;
>> -
>> -	/*
>> -	 * TID3: trap feature register accesses that we virtualise.
>> -	 * For now this is conditional, since no AArch32 feature regs
>> -	 * are currently virtualised.
>> -	 */
>> -	if (!vcpu_el1_is_32bit(vcpu))
>> +	else
>> +		/*
>> +		 * TID3: trap feature register accesses that we virtualise.
>> +		 * For now this is conditional, since no AArch32 feature regs
>> +		 * are currently virtualised.
>> +		 */
>>   		vcpu->arch.hcr_el2 |= HCR_TID3;
>>   
>>   	if (cpus_have_const_cap(ARM64_MISMATCHED_CACHE_TYPE) ||
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 11a7ae747ded..22ad977069f5 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -125,6 +125,15 @@ struct kvm_arch {
>>   #define KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER	0
>>   	/* Memory Tagging Extension enabled for the guest */
>>   #define KVM_ARCH_FLAG_MTE_ENABLED			1
>> +	/*
>> +	 * The following two bits are used to indicate the guest's EL1
>> +	 * register width configuration. A value of KVM_ARCH_FLAG_EL1_32BIT
>> +	 * bit is valid only when KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED is set.
>> +	 * Otherwise, the guest's EL1 register width has not yet been
>> +	 * determined yet.
>> +	 */
>> +#define KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED		2
>> +#define KVM_ARCH_FLAG_EL1_32BIT				3
>>   	unsigned long flags;
>>   
>>   	/*
>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>> index ecc40c8cd6f6..cbeb6216ee25 100644
>> --- a/arch/arm64/kvm/reset.c
>> +++ b/arch/arm64/kvm/reset.c
>> @@ -181,27 +181,45 @@ static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
>>   	return 0;
>>   }
>>   
>> -static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
>> +/*
>> + * A guest can have either all EL1 32bit or 64bit vcpus only. It is
>> + * indicated by a value of KVM_ARCH_FLAG_EL1_32BIT bit in kvm->arch.flags,
>> + * which is valid only when KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED in
>> + * kvm->arch.flags is set.
>> + * This function sets the EL1_32BIT bit based on the given @is32bit (and
>> + * sets REG_WIDTH_CONFIGURED bit). When those flags are already set,
>> + * @is32bit must be consistent with the flags.
>> + * Returns 0 on success, or non-zero otherwise.
>> + */
> 
> nit: use kerneldoc style:
> 
>    https://www.kernel.org/doc/html/latest/doc-guide/kernel-doc.html

Sure, I can fix the comment to use kerneldoc style.


> 
>> +static int kvm_set_vm_width(struct kvm *kvm, bool is32bit)
>>   {
>> -	struct kvm_vcpu *tmp;
>> -	bool is32bit;
>> -	unsigned long i;
>> +	bool allowed;
>> +
>> +	lockdep_assert_held(&kvm->lock);
>> +
>> +	if (test_bit(KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED, &kvm->arch.flags)) {
>> +		/*
>> +		 * The guest's register width is already configured.
>> +		 * Make sure that @is32bit is consistent with it.
>> +		 */
>> +		allowed = (is32bit ==
>> +			   test_bit(KVM_ARCH_FLAG_EL1_32BIT, &kvm->arch.flags));
>> +		return allowed ? 0 : -EINVAL;
> 
> nit: I'd avoid the ternary and just use a boring if/else (though I could
> be in the minority here).

I agree with you and will fix it.
(The ternary with 'allowed' was just copied from the previous patch,
  and I should have changed that in this patch...)

Thanks,
Reiji


> 
>> +	}
>>   
>> -	is32bit = vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT);
>>   	if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1) && is32bit)
>> -		return false;
>> +		return -EINVAL;
>>   
>>   	/* MTE is incompatible with AArch32 */
>> -	if (kvm_has_mte(vcpu->kvm) && is32bit)
>> -		return false;
>> +	if (kvm_has_mte(kvm) && is32bit)
>> +		return -EINVAL;
>>   
>> -	/* Check that the vcpus are either all 32bit or all 64bit */
>> -	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
>> -		if (vcpu_has_feature(tmp, KVM_ARM_VCPU_EL1_32BIT) != is32bit)
>> -			return false;
>> -	}
>> +	if (is32bit)
>> +		set_bit(KVM_ARCH_FLAG_EL1_32BIT, &kvm->arch.flags);
>>   
>> -	return true;
>> +	set_bit(KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED, &kvm->arch.flags);
>> +
>> +	return 0;
>>   }
>>   
>>   /**
>> @@ -230,10 +248,17 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>>   	u32 pstate;
>>   
>>   	mutex_lock(&vcpu->kvm->lock);
>> -	reset_state = vcpu->arch.reset_state;
>> -	WRITE_ONCE(vcpu->arch.reset_state.reset, false);
>> +	ret = kvm_set_vm_width(vcpu->kvm,
>> +			       vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT));
>> +	if (!ret) {
>> +		reset_state = vcpu->arch.reset_state;
>> +		WRITE_ONCE(vcpu->arch.reset_state.reset, false);
>> +	}
>>   	mutex_unlock(&vcpu->kvm->lock);
>>   
>> +	if (ret)
>> +		return ret;
>> +
>>   	/* Reset PMU outside of the non-preemptible section */
>>   	kvm_pmu_vcpu_reset(vcpu);
>>   
>> @@ -260,14 +285,9 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>>   		}
>>   	}
>>   
>> -	if (!vcpu_allowed_register_width(vcpu)) {
>> -		ret = -EINVAL;
>> -		goto out;
>> -	}
>> -
>>   	switch (vcpu->arch.target) {
>>   	default:
>> -		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
>> +		if (vcpu_el1_is_32bit(vcpu)) {
>>   			pstate = VCPU_RESET_PSTATE_SVC;
>>   		} else {
>>   			pstate = VCPU_RESET_PSTATE_EL1;
>> -- 
>> 2.35.1.723.g4982287a31-goog
>>
