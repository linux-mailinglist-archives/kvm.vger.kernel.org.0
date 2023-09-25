Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3F87AD1D9
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 09:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbjIYHhM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 03:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232259AbjIYHhJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 03:37:09 -0400
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513B6199;
        Mon, 25 Sep 2023 00:36:57 -0700 (PDT)
Received: by mail-oo1-xc2c.google.com with SMTP id 006d021491bc7-57b5f0d658dso3138880eaf.0;
        Mon, 25 Sep 2023 00:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695627416; x=1696232216; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iePwOqagKRRfZdlsnQfdqoKmzgfqbUdyaUQmBIvgPEg=;
        b=Cd+8f5itboFRteQ0EGzTmfsid03SgyBQK0fLxSG7JsW23y6Bj+5pEc7Jo+Tb9Y5Bkj
         nL07mTm3cfbMfwL5HLrhoDksQdUgwDetihcqa3srhZKvEn7qQVdJoALb0UVh7FLtEH6J
         TPNVNPR0yBIa2N/RLW05CDqw64HTim0s4szB7FQtx3ao46jvkSy5ZKJBFL47MhD3TMUH
         VHKOx3PsKxFTDbUFmSdr+scq9/Wk9dI3Zg3+HNdj1KR6RZtbCIT9l+yonYoh9L4KofWu
         VhxrZBXcGELYbCbV9DGcuPWaY81wiJ0V47nhJ3T2CqJ7Nc5s0sFVT1Y72XvnEWBYIXtO
         6V6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695627416; x=1696232216;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iePwOqagKRRfZdlsnQfdqoKmzgfqbUdyaUQmBIvgPEg=;
        b=JXJC4diIjKPROIcZLhurfAX5hR0ukUVfNZx2f01n56SxinVq3s8SSYWAlNqIQ7+p5l
         qYP7vEOeoKzV7TW2EXEJ1BmcGPB/TkYUs38B3U9QbaifRIZKvYA8dGLQdQD9bIopf1jN
         8PkTv1XmzTK325EukJGOzxldfWdMye1vVdkbvh+HX4T+7Z78Mgnh5w/TgndLSFRlHMiP
         m7QCIBPTu6Q4kquMqrNmf0cnl96ugHWAktf6cqbt6ly2ypThBrscjv4TCgtbs80tMjzE
         /46C7x++T74Fztsq2zxqPXitzByBNJjNALol6y79KPogkL4ZFhEeh/8ZP2PP7d//GJgL
         csDQ==
X-Gm-Message-State: AOJu0YwTgPgchJpYJfR/rL1OuI46R5hpfDmqkACHG++sXTavDf9Zh3Ur
        uLVY6omEvY14SM73pc9/qkWtfaNCtae3OQ==
X-Google-Smtp-Source: AGHT+IHro24S98PtKKLtHkyJh1crK1R5tzjpeSJSuZDQFUUKxrA0QMOoRWOelpJFapaE5ITYb9O08A==
X-Received: by 2002:a05:6358:4402:b0:134:ec9d:ef18 with SMTP id z2-20020a056358440200b00134ec9def18mr6971161rwc.28.1695627416361;
        Mon, 25 Sep 2023 00:36:56 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id s22-20020a62e716000000b0069023d80e63sm7326524pfh.25.2023.09.25.00.36.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Sep 2023 00:36:55 -0700 (PDT)
Message-ID: <b6661934-53d1-f7ca-d3d6-31b32a2ebb05@gmail.com>
Date:   Mon, 25 Sep 2023 15:36:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH v6] KVM: x86/tsc: Don't sync user-written TSC against
 startup values
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
To:     David Woodhouse <dwmw2@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20230913103729.51194-1-likexu@tencent.com>
 <5367c45df8e4730564ed7a55ed441a6a2d6ab0f9.camel@infradead.org>
 <2eaf612b-1ce3-0dfe-5d2e-2cf29bba7641@gmail.com>
 <ZQHLcs3VGyLUb6wW@google.com>
 <3912b026-7cd2-9981-27eb-e8e37be9bbad@gmail.com>
 <7c2e14e8d5759a59c2d69b057f21d3dca60394cc.camel@infradead.org>
 <fbcbbf94-2050-5243-664a-b65b9529070c@gmail.com>
In-Reply-To: <fbcbbf94-2050-5243-664a-b65b9529070c@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping for further comments and confirmation from Sean.
Could we trigger a new version for this issue ? Thanks.

On 19/9/2023 7:29 pm, Like Xu wrote:
> On 14/9/2023 3:31 pm, David Woodhouse wrote:
>> On Thu, 2023-09-14 at 11:50 +0800, Like Xu wrote:
>>> On 13/9/2023 10:47 pm, Sean Christopherson wrote:
>>>> On Wed, Sep 13, 2023, Like Xu wrote:
>>>>> I'll wait for a cooling off period to see if the maintainers need me to 
>>>>> post v7.
>>>>
>>>> You should have waiting to post v5, let alone v6.  Resurrecting a thread 
>>>> after a
>>>> month and not waiting even 7 hours for others to respond is extremely 
>>>> frustrating.
>>>
>>> You are right. I don't seem to be keeping up with many of other issues. Sorry
>>> for that.
>>> Wish there were 48 hours in a day.
>>>
>>> Back to this issue: for commit message, I'd be more inclined to David's
>>> understanding,
>>
>> The discussion that Sean and I had should probably be reflected in the
>> commit message too. To the end of the commit log you used for v6, after
>> the final 'To that end:…' paragraph, let's add:
>>
>>   Note that userspace can explicitly request a *synchronization* of the
>>   TSC by writing zero. For the purpose of this patch, this counts as
>>   "setting" the TSC. If userspace then subsequently writes an explicit
>>   non-zero value which happens to be within 1 second of the previous
>>   value, it will be 'corrected'. For that case, this preserves the prior
>>   behaviour of KVM (which always applied the 1-second 'correction'
>>   regardless of user vs. kernel).
>>
>>> @@ -2728,27 +2729,45 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu,
>>> u64 data)
>>>          elapsed = ns - kvm->arch.last_tsc_nsec;
>>>
>>>          if (vcpu->arch.virtual_tsc_khz) {
>>> +               /*
>>> +                * Force synchronization when creating or hotplugging a vCPU,
>>> +                * i.e. when the TSC value is '0', to help keep clocks stable.
>>> +                * If this is NOT a hotplug/creation case, skip synchronization
>>> +                * on the first write from userspace so as not to misconstrue
>>> +                * state restoration after live migration as an attempt from
>>> +                * userspace to synchronize.
>>> +                */
>>
>> You cannot *misconstrue* an attempt from userspace to synchronize. If
>> userspace writes a zero, it's a sync attempt. If it's non-zero it's a
>> TSC value to be set. It's not very subtle :)
>>
>> I think the 1-second slop thing is sufficiently documented in the 'else
>> if' clause below, so I started writing an alternative 'overall' comment
>> to go here and found it a bit redundant. So maybe let's just drop this
>> comment and add one back in the if (data == 0) case...
>>
>>>                  if (data == 0) {
>>> -                       /*
>>> -                        * detection of vcpu initialization -- need to sync
>>> -                        * with other vCPUs. This particularly helps to keep
>>> -                        * kvm_clock stable after CPU hotplug
>>> -                        */
>>
>>
>>              /*
>>               * Force synchronization when creating a vCPU, or when
>>               * userspace explicitly writes a zero value.
>>               */
>>
>>>                          synchronizing = true;
>>> -               } else {
>>> +               } else if (kvm->arch.user_set_tsc) {
>>>                          u64 tsc_exp = kvm->arch.last_tsc_write +
>>>                                                  nsec_to_cycles(vcpu, elapsed);
>>>                          u64 tsc_hz = vcpu->arch.virtual_tsc_khz * 1000LL;
>>>                          /*
>>> -                        * Special case: TSC write with a small delta (1 second)
>>> -                        * of virtual cycle time against real time is
>>> -                        * interpreted as an attempt to synchronize the CPU.
>>> +                        * Here lies UAPI baggage: when a user-initiated TSC 
>>> write has
>>> +                        * a small delta (1 second) of virtual cycle time 
>>> against the
>>> +                        * previously set vCPU, we assume that they were 
>>> intended to be
>>> +                        * in sync and the delta was only due to the racy 
>>> nature of the
>>> +                        * legacy API.
>>> +                        *
>>> +                        * This trick falls down when restoring a guest which 
>>> genuinely
>>> +                        * has been running for less time than the 1 second 
>>> of imprecision
>>> +                        * which we allow for in the legacy API. In this 
>>> case, the first
>>> +                        * value written by userspace (on any vCPU) should 
>>> not be subject
>>> +                        * to this 'correction' to make it sync up with 
>>> values that only
>>
>> Missing the word 'come' here too, in '…that only *come* from…',
>>
>>> +                        * from the kernel's default vCPU creation. Make the 
>>> 1-second slop
>>> +                        * hack only trigger if the user_set_tsc flag is 
>>> already set.
>>> +                        *
>>> +                        * The correct answer is for the VMM not to use the 
>>> legacy API.
>>
>> Maybe we should drop this line, as we don't actually have a sane API
>> yet that VMMs can use instead.
>>
> 
> Thanks for your comments, but not sure if Sean has any more concerns to move 
> forward:
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 1a4def36d5bb..9a7dfef9d32d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1324,6 +1324,7 @@ struct kvm_arch {
>       int nr_vcpus_matched_tsc;
> 
>       u32 default_tsc_khz;
> +    bool user_set_tsc;
> 
>       seqcount_raw_spinlock_t pvclock_sc;
>       bool use_master_clock;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6c9c81e82e65..11fbd2a4a370 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2714,8 +2714,9 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, 
> u64 offset, u64 tsc,
>       kvm_track_tsc_matching(vcpu);
>   }
> 
> -static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
> +static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 *user_value)
>   {
> +    u64 data = user_value ? *user_value : 0;
>       struct kvm *kvm = vcpu->kvm;
>       u64 offset, ns, elapsed;
>       unsigned long flags;
> @@ -2730,25 +2731,37 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, 
> u64 data)
>       if (vcpu->arch.virtual_tsc_khz) {
>           if (data == 0) {
>               /*
> -             * detection of vcpu initialization -- need to sync
> -             * with other vCPUs. This particularly helps to keep
> -             * kvm_clock stable after CPU hotplug
> +             * Force synchronization when creating a vCPU, or when
> +             * userspace explicitly writes a zero value.
>                */
>               synchronizing = true;
> -        } else {
> +        } else if (kvm->arch.user_set_tsc) {
>               u64 tsc_exp = kvm->arch.last_tsc_write +
>                           nsec_to_cycles(vcpu, elapsed);
>               u64 tsc_hz = vcpu->arch.virtual_tsc_khz * 1000LL;
>               /*
> -             * Special case: TSC write with a small delta (1 second)
> -             * of virtual cycle time against real time is
> -             * interpreted as an attempt to synchronize the CPU.
> +             * Here lies UAPI baggage: when a user-initiated TSC write has
> +             * a small delta (1 second) of virtual cycle time against the
> +             * previously set vCPU, we assume that they were intended to be
> +             * in sync and the delta was only due to the racy nature of the
> +             * legacy API.
> +             *
> +             * This trick falls down when restoring a guest which genuinely
> +             * has been running for less time than the 1 second of imprecision
> +             * which we allow for in the legacy API. In this case, the first
> +             * value written by userspace (on any vCPU) should not be subject
> +             * to this 'correction' to make it sync up with values that only
> +             * come from the kernel's default vCPU creation. Make the 1-second
> +             * slop hack only trigger if the user_set_tsc flag is already set.
>                */
>               synchronizing = data < tsc_exp + tsc_hz &&
>                       data + tsc_hz > tsc_exp;
>           }
>       }
> 
> +    if (user_value)
> +        kvm->arch.user_set_tsc = true;
> +
>       /*
>        * For a reliable TSC, we can match TSC offsets, and for an unstable
>        * TSC, we add elapsed time in this computation.  We could let the
> @@ -3777,7 +3790,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct 
> msr_data *msr_info)
>           break;
>       case MSR_IA32_TSC:
>           if (msr_info->host_initiated) {
> -            kvm_synchronize_tsc(vcpu, data);
> +            kvm_synchronize_tsc(vcpu, &data);
>           } else {
>               u64 adj = kvm_compute_l1_tsc_offset(vcpu, data) - 
> vcpu->arch.l1_tsc_offset;
>               adjust_tsc_offset_guest(vcpu, adj);
> @@ -5536,6 +5549,7 @@ static int kvm_arch_tsc_set_attr(struct kvm_vcpu *vcpu,
>           tsc = kvm_scale_tsc(rdtsc(), vcpu->arch.l1_tsc_scaling_ratio) + offset;
>           ns = get_kvmclock_base_ns();
> 
> +        kvm->arch.user_set_tsc = true;
>           __kvm_synchronize_tsc(vcpu, offset, tsc, ns, matched);
>           raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
> 
> @@ -11959,7 +11973,7 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
>       if (mutex_lock_killable(&vcpu->mutex))
>           return;
>       vcpu_load(vcpu);
> -    kvm_synchronize_tsc(vcpu, 0);
> +    kvm_synchronize_tsc(vcpu, NULL);
>       vcpu_put(vcpu);
> 
>       /* poll control enabled by default */
