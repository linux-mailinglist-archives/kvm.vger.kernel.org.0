Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890411DBD62
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 20:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbgETSx1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 14:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbgETSx1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 14:53:27 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E13C061A0E
        for <kvm@vger.kernel.org>; Wed, 20 May 2020 11:53:27 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id 23so2673787oiq.8
        for <kvm@vger.kernel.org>; Wed, 20 May 2020 11:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=K/ZoqL/0WiEKVI2fDVKw7mhP6kYMLRfrwx5FbmWUorA=;
        b=l7DRj1/fpoavyMYc3QvnOsJ3ozT2gB+Iih/9KJGvcOWjPy/p8OINl0jJx9RlNW1w6p
         nHLYSN4L+9gW7ftJj/MhldDLtolerYmCqtway7OBMMWZvwZHLeu+aGrVQorHrpQuf8y5
         pdygJd0jIh/c6IrHfXVyWkZwmi5bDEXx19Qn1sf3xnXpUwaNFMTauy5vMYOTKPfaRrnN
         Osr0g7t7cdYT+h8sqSAqOKCQ0hlv2xOPD8qTCOzoY3jP6C9cgTPZXe5Z0mbcgmhzVbjD
         uaV2VAzQWqvNOloSswWtkHUkmOz8hQLzntH1gYpPGSauBfTAHcdCgLrFf6bVIFTQnEHK
         bDZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=K/ZoqL/0WiEKVI2fDVKw7mhP6kYMLRfrwx5FbmWUorA=;
        b=GyiIoVjQrtCvAcYiaTEWFxBezQIrEnX3yEZVwKTri2gHUIo0nKslJi4XhO03gmJduZ
         7/MCNw56o4RX8577hvWDdtS0+577MKWYby/SANo2WNCJmq++BYmMR1ncAZzqt/KMc/l3
         iDbOm5BlX6IMmwmKbLf3f0gYad661kD+OxquITODzs/UNqlb7PD+ctwuhlLpckEpO/cQ
         gifNfMoNPv3z8osAytAz5nGR23m6Jzu5ejPajjNKtFNixHbvFSIaCltgAkRiJwHeWJrf
         DbVe7tMekO1xyuhFZwyc2V/pZMjqErvWPoSLWobUQ076mRCBxi53XqUnPxa44ECNqTHK
         +U1g==
X-Gm-Message-State: AOAM532WXEx6gqtT8u5WxDaGlpcZN+Jwmg1v+1A7mrLx2ssALLsOW+EQ
        cnWttRLRQp9/88BydsaxtV4ZuZ5KaBEnZRjBv5CHng35
X-Google-Smtp-Source: ABdhPJzv0AkuKPnkbZaOI6ekSc6WttNibOx+lUPhmdYHLbOS58bUTaFmevXCioh0yJ7eROJlOGDFeRBQpc3DY6kOjqE=
X-Received: by 2002:a54:4184:: with SMTP id 4mr2724530oiy.69.1590000806322;
 Wed, 20 May 2020 11:53:26 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:5f8b:0:0:0:0:0 with HTTP; Wed, 20 May 2020 11:53:25
 -0700 (PDT)
In-Reply-To: <87v9kqsfdh.fsf@vitty.brq.redhat.com>
References: <20200519222238.213574-1-makarandsonare@google.com>
 <20200519222238.213574-2-makarandsonare@google.com> <87v9kqsfdh.fsf@vitty.brq.redhat.com>
From:   Makarand Sonare <makarandsonare@google.com>
Date:   Wed, 20 May 2020 11:53:25 -0700
Message-ID: <CA+qz5sppOJe5meVqdgW-H=_2ptmmP+s3H9iVicA0SRBpy4g5tQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: nVMX: Fix VMX preemption timer migration
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, pshier@google.com, jmattson@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>> From: Peter Shier <pshier@google.com>
>>
>> Add new field to hold preemption timer expiration deadline
>> appended to struct kvm_vmx_nested_state_data. This is to prevent
>> the first VM-Enter after migration from incorrectly restarting the timer
>> with the full timer value instead of partially decayed timer value.
>> KVM_SET_NESTED_STATE restarts timer using migrated state regardless
>> of whether L1 sets VM_EXIT_SAVE_VMX_PREEMPTION_TIMER.
>>
>> Fixes: cf8b84f48a593 ("kvm: nVMX: Prepare for checkpointing L2 state")
>>
>> Signed-off-by: Peter Shier <pshier@google.com>
>> Signed-off-by: Makarand Sonare <makarandsonare@google.com>
>> Change-Id: I6446aba5a547afa667f0ef4620b1b76115bf3753
>> ---
>>  Documentation/virt/kvm/api.rst  |  4 +++
>>  arch/x86/include/uapi/asm/kvm.h |  3 ++
>>  arch/x86/kvm/vmx/nested.c       | 56 +++++++++++++++++++++++++++++----
>>  arch/x86/kvm/vmx/vmx.h          |  1 +
>>  arch/x86/kvm/x86.c              |  3 +-
>>  include/uapi/linux/kvm.h        |  1 +
>>  6 files changed, 61 insertions(+), 7 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst
>> b/Documentation/virt/kvm/api.rst
>> index d871dacb984e9..b410815772970 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -4326,6 +4326,9 @@ Errors:
>>    #define KVM_STATE_NESTED_RUN_PENDING		0x00000002
>>    #define KVM_STATE_NESTED_EVMCS		0x00000004
>>
>> +  /* Available with KVM_CAP_NESTED_STATE_PREEMPTION_TIMER */
>> +  #define KVM_STATE_NESTED_PREEMPTION_TIMER	0x00000010
>> +
>>    #define KVM_STATE_NESTED_FORMAT_VMX		0
>>    #define KVM_STATE_NESTED_FORMAT_SVM		1
>>
>> @@ -4346,6 +4349,7 @@ Errors:
>>    struct kvm_vmx_nested_state_data {
>>  	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
>>  	__u8 shadow_vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
>> +	__u64 preemption_timer_deadline;
>>    };
>>
>>  This ioctl copies the vcpu's nested virtualization state from the kernel
>> to
>> diff --git a/arch/x86/include/uapi/asm/kvm.h
>> b/arch/x86/include/uapi/asm/kvm.h
>> index 3f3f780c8c650..13dca545554dc 100644
>> --- a/arch/x86/include/uapi/asm/kvm.h
>> +++ b/arch/x86/include/uapi/asm/kvm.h
>> @@ -391,6 +391,8 @@ struct kvm_sync_regs {
>>  #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
>>  #define KVM_STATE_NESTED_EVMCS		0x00000004
>>  #define KVM_STATE_NESTED_MTF_PENDING	0x00000008
>> +/* Available with KVM_CAP_NESTED_STATE_PREEMPTION_TIMER */
>> +#define KVM_STATE_NESTED_PREEMPTION_TIMER	0x00000010
>>
>>  #define KVM_STATE_NESTED_SMM_GUEST_MODE	0x00000001
>>  #define KVM_STATE_NESTED_SMM_VMXON	0x00000002
>> @@ -400,6 +402,7 @@ struct kvm_sync_regs {
>>  struct kvm_vmx_nested_state_data {
>>  	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
>>  	__u8 shadow_vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
>> +	__u64 preemption_timer_deadline;
>>  };
>>
>>  struct kvm_vmx_nested_state_hdr {
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 51ebb60e1533a..318b753743902 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -2092,9 +2092,9 @@ static enum hrtimer_restart
>> vmx_preemption_timer_fn(struct hrtimer *timer)
>>  	return HRTIMER_NORESTART;
>>  }
>>
>> -static void vmx_start_preemption_timer(struct kvm_vcpu *vcpu)
>> +static void vmx_start_preemption_timer(struct kvm_vcpu *vcpu,
>> +					u64 preemption_timeout)
>>  {
>> -	u64 preemption_timeout = get_vmcs12(vcpu)->vmx_preemption_timer_value;
>>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>>
>>  	/*
>> @@ -3353,8 +3353,20 @@ enum nvmx_vmentry_status
>> nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>>  	 * the timer.
>>  	 */
>>  	vmx->nested.preemption_timer_expired = false;
>> -	if (nested_cpu_has_preemption_timer(vmcs12))
>> -		vmx_start_preemption_timer(vcpu);
>> +	if (nested_cpu_has_preemption_timer(vmcs12)) {
>> +		u64 timer_value = 0;
>> +		u64 l1_scaled_tsc_value = (kvm_read_l1_tsc(vcpu, rdtsc())
>> +					   >> VMX_MISC_EMULATED_PREEMPTION_TIMER_RATE);
>> +
>> +		if (from_vmentry) {
>> +			timer_value = vmcs12->vmx_preemption_timer_value;
>> +			vmx->nested.preemption_timer_deadline = timer_value +
>> +								l1_scaled_tsc_value;
>> +		} else if (l1_scaled_tsc_value <=
>> vmx->nested.preemption_timer_deadline)
>> +			timer_value = vmx->nested.preemption_timer_deadline -
>> +				      l1_scaled_tsc_value;
>> +		vmx_start_preemption_timer(vcpu, timer_value);
>> +	}
>>
>>  	/*
>>  	 * Note no nested_vmx_succeed or nested_vmx_fail here. At this point
>> @@ -3962,9 +3974,11 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu
>> *vcpu, struct vmcs12 *vmcs12)
>>  		vmcs12->guest_activity_state = GUEST_ACTIVITY_ACTIVE;
>>
>>  	if (nested_cpu_has_preemption_timer(vmcs12) &&
>> -	    vmcs12->vm_exit_controls & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
>> +	    !vmx->nested.nested_run_pending) {
>> +		if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
>>  			vmcs12->vmx_preemption_timer_value =
>>  				vmx_get_preemption_timer_value(vcpu);
>> +	}
>>
>>  	/*
>>  	 * In some cases (usually, nested EPT), L2 is allowed to change its
>> @@ -5939,6 +5953,12 @@ static int vmx_get_nested_state(struct kvm_vcpu
>> *vcpu,
>>
>>  			if (vmx->nested.mtf_pending)
>>  				kvm_state.flags |= KVM_STATE_NESTED_MTF_PENDING;
>> +
>> +			if (nested_cpu_has_preemption_timer(vmcs12)) {
>> +				kvm_state.flags |=
>> +					KVM_STATE_NESTED_PREEMPTION_TIMER;
>> +				kvm_state.size +=
>> sizeof(user_vmx_nested_state->preemption_timer_deadline);
>> +			}
>>  		}
>>  	}
>>
>> @@ -5970,6 +5990,9 @@ static int vmx_get_nested_state(struct kvm_vcpu
>> *vcpu,
>>
>>  	BUILD_BUG_ON(sizeof(user_vmx_nested_state->vmcs12) < VMCS12_SIZE);
>>  	BUILD_BUG_ON(sizeof(user_vmx_nested_state->shadow_vmcs12) <
>> VMCS12_SIZE);
>> +	BUILD_BUG_ON(sizeof(user_vmx_nested_state->preemption_timer_deadline)
>> +		    != sizeof(vmx->nested.preemption_timer_deadline));
>> +
>>
>>  	/*
>>  	 * Copy over the full allocated size of vmcs12 rather than just the
>> size
>> @@ -5985,6 +6008,12 @@ static int vmx_get_nested_state(struct kvm_vcpu
>> *vcpu,
>>  			return -EFAULT;
>>  	}
>>
>> +	if (kvm_state.flags & KVM_STATE_NESTED_PREEMPTION_TIMER) {
>> +		if (put_user(vmx->nested.preemption_timer_deadline,
>> +			     &user_vmx_nested_state->preemption_timer_deadline))
>> +			return -EFAULT;
>> +	}
>> +
>>  out:
>>  	return kvm_state.size;
>>  }
>> @@ -6056,7 +6085,8 @@ static int vmx_set_nested_state(struct kvm_vcpu
>> *vcpu,
>>  	 */
>>  	if (is_smm(vcpu) ?
>>  		(kvm_state->flags &
>> -		 (KVM_STATE_NESTED_GUEST_MODE | KVM_STATE_NESTED_RUN_PENDING))
>> +		 (KVM_STATE_NESTED_GUEST_MODE | KVM_STATE_NESTED_RUN_PENDING |
>> +		  KVM_STATE_NESTED_PREEMPTION_TIMER))
>>  		: kvm_state->hdr.vmx.smm.flags)
>>  		return -EINVAL;
>>
>> @@ -6146,6 +6176,20 @@ static int vmx_set_nested_state(struct kvm_vcpu
>> *vcpu,
>>  			goto error_guest_mode;
>>  	}
>>
>> +	if (kvm_state->flags & KVM_STATE_NESTED_PREEMPTION_TIMER) {
>> +
>> +		if (kvm_state->size <
>> +		    sizeof(*kvm_state) +
>> +		    sizeof(user_vmx_nested_state->vmcs12) +
>> sizeof(vmx->nested.preemption_timer_deadline))
>> +			goto error_guest_mode;
>
> I'm not sure this check is entirely correct.
>
> kvm_state->size can now be:
>
> - (1) sizeof(*kvm_state) + sizeof(user_vmx_nested_state->vmcs12) when no
>   shadow vmcs/preemtion timer flags
> - (1) + sizeof(*shadow_vmcs12)) when shadow vmcs and no preemtion
>   timer.
> - (1) + sizeof(vmx->nested.preemption_timer_deadline) when preemtion
>   timer and no shadow vmcs
> - (1) + sizeof(*shadow_vmcs12)) +
>   sizeof(vmx->nested.preemption_timer_deadline) when both shadow vmcs
>   and preemption timer.
>
> (I don't even want to think what happens when we add something else here
> :-))
>
> I.e. your check will pass when e.g. the total size is '(1) +
> sizeof(*shadow_vmcs12))' but it is wrong, you need more!
>
> I suggest we add a logic to calculate the required size:
>
>   required_size = sizeof(*kvm_state) +
> sizeof(user_vmx_nested_state->vmcs12)
>   if (shadow_vmcs_present)
>       required_size += sizeof(*shadow_vmcs12);
>   if (preemption_timer_present)
>       required_size += sizeof(vmx->nested.preemption_timer_deadline);
>   ...
>
> But ...
>
>> +
>> +		if (get_user(vmx->nested.preemption_timer_deadline,
>> +			     &user_vmx_nested_state->preemption_timer_deadline)) {
>
> ... tt also seems that we expect user_vmx_nested_state to always have
> all fields, e.g. here the offset of 'preemption_timer_deadline' is
> static, we always expect it to be after shadow vmcs. I think we need a
> way to calculate the offset dynamically and not require everything to be
> present.
>
Would it suffice if I move preemption_timer_deadline field to
kvm_vmx_nested_state_hdr?

>> +			ret = -EFAULT;
>> +			goto error_guest_mode;
>> +		}
>> +	}
>> +
>>  	if (nested_vmx_check_controls(vcpu, vmcs12) ||
>>  	    nested_vmx_check_host_state(vcpu, vmcs12) ||
>>  	    nested_vmx_check_guest_state(vcpu, vmcs12, &ignored))
>> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>> index 298ddef79d009..db697400755fb 100644
>> --- a/arch/x86/kvm/vmx/vmx.h
>> +++ b/arch/x86/kvm/vmx/vmx.h
>> @@ -169,6 +169,7 @@ struct nested_vmx {
>>  	u16 posted_intr_nv;
>>
>>  	struct hrtimer preemption_timer;
>> +	u64 preemption_timer_deadline;
>>  	bool preemption_timer_expired;
>>
>>  	/* to migrate it to L2 if VM_ENTRY_LOAD_DEBUG_CONTROLS is off */
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 471fccf7f8501..ba9e62ffbb4cd 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -3418,6 +3418,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,
>> long ext)
>>  	case KVM_CAP_MSR_PLATFORM_INFO:
>>  	case KVM_CAP_EXCEPTION_PAYLOAD:
>>  	case KVM_CAP_SET_GUEST_DEBUG:
>> +	case KVM_CAP_NESTED_STATE_PREEMPTION_TIMER:
>>  		r = 1;
>>  		break;
>>  	case KVM_CAP_SYNC_REGS:
>> @@ -4626,7 +4627,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>
>>  		if (kvm_state.flags &
>>  		    ~(KVM_STATE_NESTED_RUN_PENDING | KVM_STATE_NESTED_GUEST_MODE
>> -		      | KVM_STATE_NESTED_EVMCS))
>> +		      | KVM_STATE_NESTED_EVMCS | KVM_STATE_NESTED_PREEMPTION_TIMER))
>>  			break;
>>
>>  		/* nested_run_pending implies guest_mode.  */
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index ac9eba0289d1b..0868dce12a715 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1018,6 +1018,7 @@ struct kvm_ppc_resize_hpt {
>>  #define KVM_CAP_S390_PROTECTED 180
>>  #define KVM_CAP_PPC_SECURE_GUEST 181
>>  #define KVM_CAP_HALT_POLL 182
>> +#define KVM_CAP_NESTED_STATE_PREEMPTION_TIMER 183
>>
>>  #ifdef KVM_CAP_IRQ_ROUTING
>>
>> --
>> 2.26.2.761.g0e0b3e54be-goog
>>
>
> --
> Vitaly
>
>


-- 
Thanks,
Makarand Sonare
