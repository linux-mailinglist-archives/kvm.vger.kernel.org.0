Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06F8479E35D
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 11:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239183AbjIMJSD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 05:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbjIMJSC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 05:18:02 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B261173E;
        Wed, 13 Sep 2023 02:17:58 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-68fb85afef4so2963314b3a.1;
        Wed, 13 Sep 2023 02:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694596678; x=1695201478; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D5ntlfyfrnWhRaPe5gyjAcDshm+TQkTrWZZbi0hLuRo=;
        b=VaO9L8rA0hfDvX63LHdsATtDLL71M1fQSWsYk03prPOB7l/eZtC4grf1eRyXoh7G+L
         d2q1hFFAcGPF54u7GGxWlYj6U4HrFLWUSUy3RLGn/rqD7MzX3gVcOmwfJxgkuQnuZefv
         CpsQa0y8G5T0xUo02JM6QJJuetxsJMfDL7ziiMZAgmLEyTeMw/8JzECRVwOr4MkP+IfD
         04ohce6t0FoYHMGmoaYHsA67lfJ+nQ3KUB2WYqBFsBKEQFNCan3D9dfDFC1UJ6ISkeRe
         Di7dxPP9zXV1tRRl9o4++s9u9w8VsRXianirBDNfWCkXNEvjqhV7kV4iR0q5OhBii5U7
         RnUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694596678; x=1695201478;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D5ntlfyfrnWhRaPe5gyjAcDshm+TQkTrWZZbi0hLuRo=;
        b=Kky6X5GW937PEiGgq3Ff+AzIA3/ezjQjHvNVENM7OKGariqVi3ZJSYVBsq5SMVtHjC
         Brok6dGEI2VuFVYEH1XZyUj4WlnrKNqE6AodkFicylsZBPDwsQjHV7iE8wmRj8GEfQ7o
         x94Q/Dhl6zhWBTKt9ERFRkxXzt1nZk4hTxDQm/i+qNBsn7QSbqpyL4GBfb/9IlcEaDsO
         UtGNfSArxfYgyZi3rdiT0LDF3uSbmjZbZqvUqPFMejKih+pzNejmWMM1X1PHeL0DvyrK
         RXSNqUbbped/g92am+NIcFqSh1Q3IOiCLcBWzt1sjavZxhhuWpursS8k9G1Q6IP7ajRq
         Hm8g==
X-Gm-Message-State: AOJu0Ywtj9qbidnFdgN9+K5ZbxnRzBXzPpuAnA+j6UndGZiooX6FEF60
        v6XIeuF4QANh6gy+r46sr3A=
X-Google-Smtp-Source: AGHT+IFL55pYAq1VsdG9gnxZsr0fiX9yLoanH66YdDqBEyjDFEgQ+3z2guA4i9QK0kndgxG+nEjrXQ==
X-Received: by 2002:a05:6a20:5613:b0:14c:84e6:1ab4 with SMTP id ir19-20020a056a20561300b0014c84e61ab4mr1490436pzc.33.1694596677614;
        Wed, 13 Sep 2023 02:17:57 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id iw21-20020a170903045500b001b39ffff838sm10039861plb.25.2023.09.13.02.17.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Sep 2023 02:17:56 -0700 (PDT)
Message-ID: <90194cd0-61d8-18b9-980a-b46f903409b4@gmail.com>
Date:   Wed, 13 Sep 2023 17:17:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v5] KVM: x86/tsc: Don't sync TSC on the first write in
 state restoration
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230913072113.78885-1-likexu@tencent.com>
 <e506ceb2d837344999c4899525a3490d8c46c95b.camel@infradead.org>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <e506ceb2d837344999c4899525a3490d8c46c95b.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/9/2023 4:37 pm, David Woodhouse wrote:
> On Wed, 2023-09-13 at 15:21 +0800, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> Add kvm->arch.user_set_tsc to avoid synchronization on the first write
>> from userspace so as not to misconstrue state restoration after live
>> migration as an attempt from userspace to synchronize. More precisely,
>> the problem is that the sync code doesn't differentiate between userspace
>> initializing the TSC and userspace attempting to synchronize the TSC.
> 
> 
> That commit message definitely needs work. Oliver gave you some
> verbiage which made a lot more sense to me. Let me try again...

Thank you for reviewing it.

> 
> ================
> 
> [PATCH] KVM: x86/tsc: Don't sync user-written TSC against startup values
> 
> The legacy API for setting the TSC is fundamentally broken, and only
> allows userspace to set a TSC "now", without any way to account for
> time lost to preemption between the calculation of the value, and the
> kernel eventually handling the ioctl.
> 
> To work around this we have had a hack which, if a TSC is set with a
> value which is within a second's worth of a previous vCPU, assumes that
> userspace actually intended them to be in sync and adjusts the newly-
> written TSC value accordingly.
> 
> Thus, when a VMM restores a guest after suspend or migration using the
> legacy API, the TSCs aren't necessarily *right*, but at least they're
> in sync.
> 
> This trick falls down when restoring a guest which genuinely has been
> running for less time than the 1 second of imprecision which we allow
> for in the legacy API. On *creation* the first vCPU starts its TSC
> counting from zero, and the subsequent vCPUs synchronize to that. But
> then when the VMM tries to set the intended TSC value, because that's
> within a second of what the last TSC synced to, it just adjusts it to
> match that.
> 
> The correct answer is for the VMM not to use the legacy API of course.
> 
> But we can pile further hacks onto our existing hackish ABI, and
> declare that the *first* value written by userspace (on any vCPU)
> should not be subject to this 'correction' to make it sync up with
> values that only from from the kernel's default vCPU creation.
> 
> To that end: Add a flag in kvm->arch.user_set_tsc, protected by
> kvm->arch.tsc_write_lock, to record that a TSC for at least one vCPU in
> this KVM *has* been set by userspace. Make the 1-second slop hack only
> trigger if that flag is already set.
> 
> ===================
> 
> I think you also need to set kvm->arch.user_set_tsc() in
> kvm_arch_tsc_set_attr(), don't you?

How about:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c55cc60769db..374965f66137 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5545,6 +5545,7 @@ static int kvm_arch_tsc_set_attr(struct kvm_vcpu *vcpu,
  		tsc = kvm_scale_tsc(rdtsc(), vcpu->arch.l1_tsc_scaling_ratio) + offset;
  		ns = get_kvmclock_base_ns();

+		kvm->arch.user_set_tsc = true;
  		__kvm_synchronize_tsc(vcpu, offset, tsc, ns, matched);
  		raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);

> 
> 
>> Reported-by: Yong He <alexyonghe@tencent.com>
>> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217423
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Suggested-by: Oliver Upton <oliver.upton@linux.dev>
>> Original-by: Sean Christopherson <seanjc@google.com>
>> Tested-by: Like Xu <likexu@tencent.com>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>> V4 -> V5 Changelog:
>> - Making kvm_synchronize_tsc(@data) a pointer and passing NULL; (Sean)
>> - Refine commit message in a more accurate way; (Sean)
>> V4: https://lore.kernel.org/kvm/20230801034524.64007-1-likexu@tencent.com/
>>
>>   arch/x86/include/asm/kvm_host.h |  1 +
>>   arch/x86/kvm/x86.c              | 25 ++++++++++++++++---------
>>   2 files changed, 17 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 1a4def36d5bb..9a7dfef9d32d 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1324,6 +1324,7 @@ struct kvm_arch {
>>          int nr_vcpus_matched_tsc;
>>   
>>          u32 default_tsc_khz;
>> +       bool user_set_tsc;
>>   
>>          seqcount_raw_spinlock_t pvclock_sc;
>>          bool use_master_clock;
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 6c9c81e82e65..0fef6ed69cbb 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -2714,8 +2714,9 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
>>          kvm_track_tsc_matching(vcpu);
>>   }
>>   
>> -static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
>> +static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 *user_value)
>>   {
>> +       u64 data = user_value ? *user_value : 0;
>>          struct kvm *kvm = vcpu->kvm;
>>          u64 offset, ns, elapsed;
>>          unsigned long flags;
>> @@ -2728,14 +2729,17 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
>>          elapsed = ns - kvm->arch.last_tsc_nsec;
>>   
>>          if (vcpu->arch.virtual_tsc_khz) {
>> +               /*
>> +                * Force synchronization when creating or hotplugging a vCPU,
>> +                * i.e. when the TSC value is '0', to help keep clocks stable.
>> +                * If this is NOT a hotplug/creation case, skip synchronization
>> +                * on the first write from userspace so as not to misconstrue
>> +                * state restoration after live migration as an attempt from
>> +                * userspace to synchronize.
> 
> This comment isn't quite right; it wants to use some excerpt of the
> commit message I've suggested above.

How about:

@@ -2735,20 +2735,34 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, 
u64 data)
  			 * kvm_clock stable after CPU hotplug
  			 */
  			synchronizing = true;
-		} else {
+		} else if (kvm->arch.user_set_tsc) {
  			u64 tsc_exp = kvm->arch.last_tsc_write +
  						nsec_to_cycles(vcpu, elapsed);
  			u64 tsc_hz = vcpu->arch.virtual_tsc_khz * 1000LL;
  			/*
-			 * Special case: TSC write with a small delta (1 second)
-			 * of virtual cycle time against real time is
-			 * interpreted as an attempt to synchronize the CPU.
+			 * Here lies UAPI baggage: user-initiated TSC write with
+			 * a small delta (1 second) of virtual cycle time
+			 * against real time is interpreted as an attempt to
+			 * synchronize the CPU.
+			 *
+			 * This trick falls down when restoring a guest which genuinely
+			 * has been running for less time than the 1 second of imprecision
+			 * which we allow for in the legacy API. In this case, the first
+			 * value written by userspace (on any vCPU) should not be subject
+			 * to this 'correction' to make it sync up with values that only
+			 * from from the kernel's default vCPU creation. Make the 1-second
+			 * slop hack only trigger if flag is already set.
+			 *
+			 * The correct answer is for the VMM not to use the legacy API.
  			 */
  			synchronizing = data < tsc_exp + tsc_hz &&
  					data + tsc_hz > tsc_exp;
  		}
  	}

> 
>> +                */
>>                  if (data == 0) {
>> -                       /*
>> -                        * detection of vcpu initialization -- need to sync
>> -                        * with other vCPUs. This particularly helps to keep
>> -                        * kvm_clock stable after CPU hotplug
>> -                        */
>>                          synchronizing = true;
>> -               } else {
>> +               } else if (kvm->arch.user_set_tsc) {
>>                          u64 tsc_exp = kvm->arch.last_tsc_write +
>>                                                  nsec_to_cycles(vcpu, elapsed);
>>                          u64 tsc_hz = vcpu->arch.virtual_tsc_khz * 1000LL;
>> @@ -2749,6 +2753,9 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
>>                  }
>>          }
>>   
>> +       if (user_value)
>> +               kvm->arch.user_set_tsc = true;
>> +
>>          /*
>>           * For a reliable TSC, we can match TSC offsets, and for an unstable
>>           * TSC, we add elapsed time in this computation.  We could let the
>> @@ -3777,7 +3784,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>                  break;
>>          case MSR_IA32_TSC:
>>                  if (msr_info->host_initiated) {
>> -                       kvm_synchronize_tsc(vcpu, data);
>> +                       kvm_synchronize_tsc(vcpu, &data);
> 
> Userspace used to be able to write zero to force a sync. You've removed
> that ability from the ABI, and haven't even mentioned it. Must we?

Will continue to use "bool user_initiated" for lack of a better move.

> 
>>                  } else {
>>                          u64 adj = kvm_compute_l1_tsc_offset(vcpu, data) - vcpu->arch.l1_tsc_offset;
>>                          adjust_tsc_offset_guest(vcpu, adj);
>> @@ -11959,7 +11966,7 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
>>          if (mutex_lock_killable(&vcpu->mutex))
>>                  return;
>>          vcpu_load(vcpu);
>> -       kvm_synchronize_tsc(vcpu, 0);
>> +       kvm_synchronize_tsc(vcpu, NULL);
>>          vcpu_put(vcpu);
>>   
>>          /* poll control enabled by default */
>>
>> base-commit: 0bb80ecc33a8fb5a682236443c1e740d5c917d1d
> 
