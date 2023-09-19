Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3FD7A6133
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 13:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbjISLaB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 07:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjISLaA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 07:30:00 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C266299;
        Tue, 19 Sep 2023 04:29:53 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 41be03b00d2f7-578af21ff50so657612a12.1;
        Tue, 19 Sep 2023 04:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695122993; x=1695727793; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UD3/IohtpyaFGOAUh2yOZ2pS+SJfWw5GYUQIjPP5bDk=;
        b=XmN1gfwT2QWQglBGwF/+n0cXYXATZM7JSbcGpqI/TrXdv3xGdn3eKWzMvScElQo35w
         XkQDzjuXMsaNba6zFC3cUyqRAQ86+FgP91+f0HugFY1PmG5N8kCkRpbiN5o05FZRWk58
         au6G+PheGP69Z+la4/dOylRoPT/L3TOg5aJSuHac69cWXK7Okesk8/nuA63lxCTBhYuo
         WpUTggQIuRPm+gvR61lnE04wOt89CC2d6GQMU0aCLAgM89aFiDTrHQKOS7KHUXUDfNCR
         /DBqtr3JchBwHX8iR+mlmZL+19kq/lL5+NG1EFsvLWglDp7kDuWElVblvJsQibkQqBRP
         PJtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695122993; x=1695727793;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UD3/IohtpyaFGOAUh2yOZ2pS+SJfWw5GYUQIjPP5bDk=;
        b=lxS/dNdV1CNwXGP1/clKYJk90fLQoLRGXHtuyOUFBknWAda5FSAMhPWdAyw8MFnH8p
         42KpRol4CwZdm4tMlBmbWhQNB/97HAUDqvelWGOUc0CgnDvOyeM+MWXVGXesqGlI4f3k
         LSieeKnCWHCzTgYtjs+ZtZNH7kRPO6aLUbMKWrbY7Tsvqlm6ch9Hxcm/Hfmp2oJyQ7Ri
         nMW+VZ5cPstjoyu//Zg5vVyyrRXZKtxMMAeW2uw4ikUvjJfWESz/aJ9TcR8EnzoQ61yB
         JEk51R+3EwdoIWWOsRNBxMKcjVmrXVMllZTTI+CR2gYUb9tfPHBApfUNnjKSrTSEWRUn
         Afvg==
X-Gm-Message-State: AOJu0YyNZkpWkpIlq+cVnXC/1wv+azbrFt6zYIFL+fkPaItaybLRx3aW
        d5Dfg80k8EF/A9VxzewkMPc=
X-Google-Smtp-Source: AGHT+IEdOMMhhDiBlYMfkH9+DQi2zcrPuyyGyRnpIjXttzWGyvDic8H4miNPtEk6If8EwrloqpD0RA==
X-Received: by 2002:a05:6a20:2594:b0:154:c959:f157 with SMTP id k20-20020a056a20259400b00154c959f157mr9907003pzd.30.1695122993068;
        Tue, 19 Sep 2023 04:29:53 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id w11-20020a056a0014cb00b0068bc461b68fsm1453424pfu.204.2023.09.19.04.29.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Sep 2023 04:29:52 -0700 (PDT)
Message-ID: <fbcbbf94-2050-5243-664a-b65b9529070c@gmail.com>
Date:   Tue, 19 Sep 2023 19:29:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH v6] KVM: x86/tsc: Don't sync user-written TSC against
 startup values
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
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <7c2e14e8d5759a59c2d69b057f21d3dca60394cc.camel@infradead.org>
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

On 14/9/2023 3:31 pm, David Woodhouse wrote:
> On Thu, 2023-09-14 at 11:50 +0800, Like Xu wrote:
>> On 13/9/2023 10:47 pm, Sean Christopherson wrote:
>>> On Wed, Sep 13, 2023, Like Xu wrote:
>>>> I'll wait for a cooling off period to see if the maintainers need me to post v7.
>>>
>>> You should have waiting to post v5, let alone v6.  Resurrecting a thread after a
>>> month and not waiting even 7 hours for others to respond is extremely frustrating.
>>
>> You are right. I don't seem to be keeping up with many of other issues. Sorry
>> for that.
>> Wish there were 48 hours in a day.
>>
>> Back to this issue: for commit message, I'd be more inclined to David's
>> understanding,
> 
> The discussion that Sean and I had should probably be reflected in the
> commit message too. To the end of the commit log you used for v6, after
> the final 'To that end:…' paragraph, let's add:
> 
>   Note that userspace can explicitly request a *synchronization* of the
>   TSC by writing zero. For the purpose of this patch, this counts as
>   "setting" the TSC. If userspace then subsequently writes an explicit
>   non-zero value which happens to be within 1 second of the previous
>   value, it will be 'corrected'. For that case, this preserves the prior
>   behaviour of KVM (which always applied the 1-second 'correction'
>   regardless of user vs. kernel).
> 
>> @@ -2728,27 +2729,45 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu,
>> u64 data)
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
>> +                */
> 
> You cannot *misconstrue* an attempt from userspace to synchronize. If
> userspace writes a zero, it's a sync attempt. If it's non-zero it's a
> TSC value to be set. It's not very subtle :)
> 
> I think the 1-second slop thing is sufficiently documented in the 'else
> if' clause below, so I started writing an alternative 'overall' comment
> to go here and found it a bit redundant. So maybe let's just drop this
> comment and add one back in the if (data == 0) case...
> 
>>                  if (data == 0) {
>> -                       /*
>> -                        * detection of vcpu initialization -- need to sync
>> -                        * with other vCPUs. This particularly helps to keep
>> -                        * kvm_clock stable after CPU hotplug
>> -                        */
> 
> 
> 			 /*
> 			  * Force synchronization when creating a vCPU, or when
> 			  * userspace explicitly writes a zero value.
> 			  */
> 
>>                          synchronizing = true;
>> -               } else {
>> +               } else if (kvm->arch.user_set_tsc) {
>>                          u64 tsc_exp = kvm->arch.last_tsc_write +
>>                                                  nsec_to_cycles(vcpu, elapsed);
>>                          u64 tsc_hz = vcpu->arch.virtual_tsc_khz * 1000LL;
>>                          /*
>> -                        * Special case: TSC write with a small delta (1 second)
>> -                        * of virtual cycle time against real time is
>> -                        * interpreted as an attempt to synchronize the CPU.
>> +                        * Here lies UAPI baggage: when a user-initiated TSC write has
>> +                        * a small delta (1 second) of virtual cycle time against the
>> +                        * previously set vCPU, we assume that they were intended to be
>> +                        * in sync and the delta was only due to the racy nature of the
>> +                        * legacy API.
>> +                        *
>> +                        * This trick falls down when restoring a guest which genuinely
>> +                        * has been running for less time than the 1 second of imprecision
>> +                        * which we allow for in the legacy API. In this case, the first
>> +                        * value written by userspace (on any vCPU) should not be subject
>> +                        * to this 'correction' to make it sync up with values that only
> 
> Missing the word 'come' here too, in '…that only *come* from…',
> 
>> +                        * from the kernel's default vCPU creation. Make the 1-second slop
>> +                        * hack only trigger if the user_set_tsc flag is already set.
>> +                        *
>> +                        * The correct answer is for the VMM not to use the legacy API.
> 
> Maybe we should drop this line, as we don't actually have a sane API
> yet that VMMs can use instead.
> 

Thanks for your comments, but not sure if Sean has any more concerns to move 
forward:

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1a4def36d5bb..9a7dfef9d32d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1324,6 +1324,7 @@ struct kvm_arch {
  	int nr_vcpus_matched_tsc;

  	u32 default_tsc_khz;
+	bool user_set_tsc;

  	seqcount_raw_spinlock_t pvclock_sc;
  	bool use_master_clock;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6c9c81e82e65..11fbd2a4a370 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2714,8 +2714,9 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, 
u64 offset, u64 tsc,
  	kvm_track_tsc_matching(vcpu);
  }

-static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
+static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 *user_value)
  {
+	u64 data = user_value ? *user_value : 0;
  	struct kvm *kvm = vcpu->kvm;
  	u64 offset, ns, elapsed;
  	unsigned long flags;
@@ -2730,25 +2731,37 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, 
u64 data)
  	if (vcpu->arch.virtual_tsc_khz) {
  		if (data == 0) {
  			/*
-			 * detection of vcpu initialization -- need to sync
-			 * with other vCPUs. This particularly helps to keep
-			 * kvm_clock stable after CPU hotplug
+			 * Force synchronization when creating a vCPU, or when
+			 * userspace explicitly writes a zero value.
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
+			 * Here lies UAPI baggage: when a user-initiated TSC write has
+			 * a small delta (1 second) of virtual cycle time against the
+			 * previously set vCPU, we assume that they were intended to be
+			 * in sync and the delta was only due to the racy nature of the
+			 * legacy API.
+			 *
+			 * This trick falls down when restoring a guest which genuinely
+			 * has been running for less time than the 1 second of imprecision
+			 * which we allow for in the legacy API. In this case, the first
+			 * value written by userspace (on any vCPU) should not be subject
+			 * to this 'correction' to make it sync up with values that only
+			 * come from the kernel's default vCPU creation. Make the 1-second
+			 * slop hack only trigger if the user_set_tsc flag is already set.
  			 */
  			synchronizing = data < tsc_exp + tsc_hz &&
  					data + tsc_hz > tsc_exp;
  		}
  	}

+	if (user_value)
+		kvm->arch.user_set_tsc = true;
+
  	/*
  	 * For a reliable TSC, we can match TSC offsets, and for an unstable
  	 * TSC, we add elapsed time in this computation.  We could let the
@@ -3777,7 +3790,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct 
msr_data *msr_info)
  		break;
  	case MSR_IA32_TSC:
  		if (msr_info->host_initiated) {
-			kvm_synchronize_tsc(vcpu, data);
+			kvm_synchronize_tsc(vcpu, &data);
  		} else {
  			u64 adj = kvm_compute_l1_tsc_offset(vcpu, data) - vcpu->arch.l1_tsc_offset;
  			adjust_tsc_offset_guest(vcpu, adj);
@@ -5536,6 +5549,7 @@ static int kvm_arch_tsc_set_attr(struct kvm_vcpu *vcpu,
  		tsc = kvm_scale_tsc(rdtsc(), vcpu->arch.l1_tsc_scaling_ratio) + offset;
  		ns = get_kvmclock_base_ns();

+		kvm->arch.user_set_tsc = true;
  		__kvm_synchronize_tsc(vcpu, offset, tsc, ns, matched);
  		raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);

@@ -11959,7 +11973,7 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
  	if (mutex_lock_killable(&vcpu->mutex))
  		return;
  	vcpu_load(vcpu);
-	kvm_synchronize_tsc(vcpu, 0);
+	kvm_synchronize_tsc(vcpu, NULL);
  	vcpu_put(vcpu);

  	/* poll control enabled by default */
