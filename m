Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64299746B62
	for <lists+kvm@lfdr.de>; Tue,  4 Jul 2023 10:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbjGDICJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 04:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbjGDICD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 04:02:03 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E357E72;
        Tue,  4 Jul 2023 01:01:59 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id ca18e2360f4ac-7835971026fso212251739f.3;
        Tue, 04 Jul 2023 01:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688457718; x=1691049718;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9obIGbe7Ltql5gFIiLDCERHCQB9lI1Zs9zejDT+BupE=;
        b=dTpBNyNAP6SDI0lcP82DoFS00ikvWz+HUdPKGnsP+a5CaKLpX7erU7uzNMFb7Y0CYT
         nZ+Dx22+2B5c1WoTERkC2wZE+Vb3JMxw2hu+T2EINe7TOVvM3bV9kdImuoxixDWNpg3l
         CX7Fhi7M9MCuR+FsGTCB8L6uB/PD/3WofXkSuIBXKo/+vynyoFwVckf7JqOvr9MkSF30
         vF6rxb2qnhDz+e2CBoLXmmHwcWtKtZ/NdB4btWHTXfOb5+dMZSTdLtK2uEZqok5DdvLv
         sgGZqbTHNmMOCp3dekTTDlws2tucY5pUr/QXuNVf5ZSQcdu0fcuPSOS49omeMUQH856H
         ZCKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688457718; x=1691049718;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9obIGbe7Ltql5gFIiLDCERHCQB9lI1Zs9zejDT+BupE=;
        b=bq7dZ90QYrVdTvOcAaqkMW9KOWNJBpVo80GGmRO5CECPI6hURg6QsSrTG2vwzjAZRz
         bNbi2QbN2ROkPCi/BOczHnnwz4H07dBrFVLHi0IGtqbtv3nASPbclwagJQNy/eNgehWU
         Nbhc3J8mv4osVsVGMMMrXzUJdHrODcvxTpLUzflxkYKSmH9VHl20DO7K9ln/Eql3Uc5L
         jAEAYA28U8pMwxJxTzzm+bkdDGNSGIheX0qOXKhPsoV07n+4HSCiJuOYyVcXdleXuHdT
         PMWFBH+pbLkku2rzWTzIaTSzXWFx8bIlcTQ7LUS4VV+L2s904x0mWy360OlIaSsVoJB4
         4/mA==
X-Gm-Message-State: AC+VfDzyafzQbmH14jZ2dNpfBV3wA2WNFXcRv+EeTm2l2Rtisi29ZSP/
        ALL4ncj8Mg9Sdg8DThaAVsc=
X-Google-Smtp-Source: ACHHUZ7eIbyAJYukAn7A9hDlg51URN/4evK8On7PTBXfKbEP6vgrX/DQVHvt4XpijnLmO4rr3cj+rg==
X-Received: by 2002:a5e:a911:0:b0:77e:3d2f:d1f4 with SMTP id c17-20020a5ea911000000b0077e3d2fd1f4mr12439925iod.15.1688457718361;
        Tue, 04 Jul 2023 01:01:58 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id y17-20020a63e251000000b005501b24b1c9sm15649485pgj.62.2023.07.04.01.01.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jul 2023 01:01:56 -0700 (PDT)
Message-ID: <3fe014ed-b845-bada-8598-351a6ec61523@gmail.com>
Date:   Tue, 4 Jul 2023 16:01:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH] KVM: x86/tsc: Update guest tsc_offset again before vcpu
 first runs
Content-Language: en-US
To:     Oliver Upton <oliver.upton@linux.dev>,
        Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230629164838.66847-1-likexu@tencent.com>
 <ZJ29KhiVLyAq/7Sh@google.com> <ZJ8PIbHfhc0oYB8/@linux.dev>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <ZJ8PIbHfhc0oYB8/@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/7/2023 1:21 am, Oliver Upton wrote:
> On Thu, Jun 29, 2023 at 10:19:38AM -0700, Sean Christopherson wrote:
>> +Oliver
> 
> It has been a while since I've looked at any x86 code, so forgive any
> ignorance :)

The x86 world still needs you, :D

> 
>> On Fri, Jun 30, 2023, Like Xu wrote:
>>> From: Like Xu <likexu@tencent.com>
>>>
>>> When a new vcpu is created and subsequently restored by vcpu snapshot,
>>> apply kvm_vcpu_write_tsc_offset() before vcpu runs for the first time.
>>>
>>> Before a vcpu runs for the first time, the user space (VMM) sets the guest
>>> tsc as it wants, which may triggers the time synchronization mechanism with
>>> other vcpus (if any). In a scenario where a vcpu snapshot is used to
>>> restore, like the bugzilla report [*], the newly target guest tsc (e.g.
>>> at the time of vcpu restoration) is synchronized with its the most
>>> primitive guest timestamp initialized at the time of vcpu creation.
>>>
>>> Furthermore, the VMM can actually update the target guest tsc multiple
>>> times before the vcpu actually gets running, which requires the tsc_offset
>>> to be updated every time it is set. In this scenario, it can be considered
>>> as unstable tsc (even this vcpu has not yet even started ticking to follow
>>> the intended logic of KVM timer emulation).
>>>
>>> It is only necessary to delay this step until kvm_arch_vcpu_load() to
>>> catch up with guest expectation with the help of kvm_vcpu_has_run(),
>>> and the change is expected to not break any of the cumbersome existing
>>> virt timer features.

Emm for Sean's comment, we may have something like:

"This change is not expected to break any of the cumbersome existing virt
timer features."

> 
> The bug description is a bit difficult to grok, IMO. My understanding is
> something like the following:
> 
>   1) Create VM_0 and save state within 1 second of creation
> 
>   2) Create VM_1 and restore state from VM_0
> 
>   3) Guest TSCs synchronize with the TSC value resulting from the vCPU
>   creation in VM_1 instead of the expected value in the snapshot.
> 
> Generalizing -- restoring a vCPU that was saved within a second of its
> creation leads to KVM ignoring the user-written TSC value.
> 
> Or am I entirely lost?

A user space saves the tsc of one vcpu and uses the same tsc value to
restore another vcpu, at which point the synchronizing brought by KVM
is not expected here. Part of log looks like this:

[save] kvm: kvm_get_msr_common, data = 0x175ef88a # MSR_IA32_TSC
[restore] kvm: kvm_synchronize_tsc, data = 0x175ef88a

[save] kvm: kvm_get_msr_common, data = 0x171a7688 # MSR_IA32_TSC
[restore] kvm: kvm_synchronize_tsc, data = 0x171a7688

> 
>>> Reported-by: Yong He <alexyonghe@tencent.com>
>>> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217423 [*]
>>> Tested-by: Jinrong Liang <cloudliang@tencent.com>
>>> Signed-off-by: Like Xu <likexu@tencent.com>
>>> ---
>>>   arch/x86/kvm/x86.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 439312e04384..616940fc3791 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -4818,7 +4818,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>>   		if (tsc_delta < 0)
>>>   			mark_tsc_unstable("KVM discovered backwards TSC");
>>>   
>>> -		if (kvm_check_tsc_unstable()) {
>>> +		if (kvm_check_tsc_unstable() || !kvm_vcpu_has_run(vcpu)) {
>>>   			u64 offset = kvm_compute_l1_tsc_offset(vcpu,
>>>   						vcpu->arch.last_guest_tsc);
>>>   			kvm_vcpu_write_tsc_offset(vcpu, offset);
>>
>> Doing this on every vCPU load feels all kinds of wrong, e.g. it will override the
>> value set by userspace via KVM_VCPU_TSC_OFFSET.  One could argue the KVM is "helping"
>> userspace by providing a more up-to-date offset for the guest, but "helping"
>> userspace by silently overriding userspace rarely ends well.
>>
>> Can't we instead just fix the heuristic that tries to detect synchronization?
>>
>> ---
>>   arch/x86/kvm/x86.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index c30364152fe6..43d40f058a41 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -2721,14 +2721,14 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
>>   			 * kvm_clock stable after CPU hotplug
>>   			 */
>>   			synchronizing = true;
>> -		} else {
>> +		} else if (kvm_vcpu_has_run(vcpu)) {
>>   			u64 tsc_exp = kvm->arch.last_tsc_write +
>>   						nsec_to_cycles(vcpu, elapsed);
>>   			u64 tsc_hz = vcpu->arch.virtual_tsc_khz * 1000LL;
>>   			/*
>>   			 * Special case: TSC write with a small delta (1 second)
>> -			 * of virtual cycle time against real time is
>> -			 * interpreted as an attempt to synchronize the CPU.
>> +			 * of virtual cycle time against real time on a running
>> +			 * vCPU is interpreted as an attempt to synchronize.
>>   			 */
>>   			synchronizing = data < tsc_exp + tsc_hz &&
>>   					data + tsc_hz > tsc_exp;

The above proposal also breaks the KUT:hyperv_clock test.

> 
> This would break existing save/restore patterns for the TSC. QEMU relies
> on KVM synchronizing the TSCs when restoring a VM, since it cannot
> snapshot the TSC values of all the vCPUs in a single instant. It instead
> tries to save the TSCs at roughly the same time [*], which KVM detects
> on the target and gets everything back in sync. Can't wait to see when
> this heuristic actually breaks :)
> 
> It's gonna be a hack no matter how we go about fixing this, but the root
> of the problem is that KVM-initiated TSC changes are synchronizing with
> userpsace-initiated TSC changes. Why not force a new TSC sync generation
> (i.e. set @synchronizing to false) for the first user-initiated write to
> the TSC MSR?
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 808c292ad3f4..8bb27ad0af53 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1321,6 +1321,7 @@ struct kvm_arch {
>   	u64 cur_tsc_offset;
>   	u64 cur_tsc_generation;
>   	int nr_vcpus_matched_tsc;
> +	bool user_changed_tsc;
>   
>   	u32 default_tsc_khz;
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7713420abab0..1fe24bbc28f4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2668,7 +2668,7 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
>   	kvm_track_tsc_matching(vcpu);
>   }
>   
> -static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
> +static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data, bool user_initiated)
>   {
>   	struct kvm *kvm = vcpu->kvm;
>   	u64 offset, ns, elapsed;
> @@ -2689,20 +2689,29 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
>   			 * kvm_clock stable after CPU hotplug
>   			 */
>   			synchronizing = true;
> -		} else {
> +		} else if (kvm->arch.user_changed_tsc) {
>   			u64 tsc_exp = kvm->arch.last_tsc_write +
>   						nsec_to_cycles(vcpu, elapsed);
>   			u64 tsc_hz = vcpu->arch.virtual_tsc_khz * 1000LL;
>   			/*
> -			 * Special case: TSC write with a small delta (1 second)
> -			 * of virtual cycle time against real time is
> -			 * interpreted as an attempt to synchronize the CPU.
> +			 * Here lies UAPI baggage: user-initiated TSC write with
> +			 * a small delta (1 second) of virtual cycle time
> +			 * against real time is interpreted as an attempt to
> +			 * synchronize the CPU.
> +			 *
> +			 * Don't synchronize user changes to the TSC with the
> +			 * KVM-initiated change in kvm_arch_vcpu_postcreate()
> +			 * by conditioning this mess on userspace having
> +			 * written the TSC at least once already.
>   			 */
>   			synchronizing = data < tsc_exp + tsc_hz &&
>   					data + tsc_hz > tsc_exp;
>   		}
>   	}
>   
> +	if (user_initiated)
> +		kvm->arch.user_changed_tsc = true;
> +
>   	/*
>   	 * For a reliable TSC, we can match TSC offsets, and for an unstable
>   	 * TSC, we add elapsed time in this computation.  We could let the
> @@ -3695,7 +3704,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		break;
>   	case MSR_IA32_TSC:
>   		if (msr_info->host_initiated) {
> -			kvm_synchronize_tsc(vcpu, data);
> +			kvm_synchronize_tsc(vcpu, data, true);
>   		} else {
>   			u64 adj = kvm_compute_l1_tsc_offset(vcpu, data) - vcpu->arch.l1_tsc_offset;
>   			adjust_tsc_offset_guest(vcpu, adj);
> @@ -11832,7 +11841,7 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
>   	if (mutex_lock_killable(&vcpu->mutex))
>   		return;
>   	vcpu_load(vcpu);
> -	kvm_synchronize_tsc(vcpu, 0);
> +	kvm_synchronize_tsc(vcpu, 0, false);
>   	vcpu_put(vcpu);
>   
>   	/* poll control enabled by default */

This looks a lot like my first fix attempt, then came a new version:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 439312e04384..715f0b078a4e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2721,7 +2721,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 
data)
  			 * kvm_clock stable after CPU hotplug
  			 */
  			synchronizing = true;
-		} else {
+		} else if (kvm->arch.nr_vcpus_matched_tsc) {
  			u64 tsc_exp = kvm->arch.last_tsc_write +
  						nsec_to_cycles(vcpu, elapsed);
  			u64 tsc_hz = vcpu->arch.virtual_tsc_khz * 1000LL;

Oliver and Sean, any better move ?
