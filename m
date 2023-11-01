Return-Path: <kvm+bounces-325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B3887DE4F8
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 18:02:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6FE941C20DE1
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 17:02:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AEBC15E83;
	Wed,  1 Nov 2023 17:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MIFUX4b+"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E84910A09;
	Wed,  1 Nov 2023 17:02:29 +0000 (UTC)
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8D9FD;
	Wed,  1 Nov 2023 10:02:27 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-4084b0223ccso57975e9.2;
        Wed, 01 Nov 2023 10:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698858146; x=1699462946; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+CMbhE83gVdE7/6b871iYz3oVRssgurvombxQrmFMGA=;
        b=MIFUX4b+NiW5ZuVc4kXsUXi0R6CJD9RJcHaYDScjm6JI4L+UwEzEKyU+TMEeoXJFd7
         rXCJFc7LN6BWa39ILHKtzSIRPCtUF6mCkf2AmxgP657sXfAr/lNhW3ZdSabPPHldNGXa
         +s2/JRA/lcvN91aLvDD44VZmKEUraoS+LHL7vmcEJ5xDm8NcmMZdQ2PLinTWHqK0S8cf
         vp468gzJG1DtI3ij6+9w8WngpdRYn5+j+C7OhuJ5/xNsj3bkocOZ354avilG3BMstnoq
         yccD+LXMo73+Xua7gbcsqa5lX89fkq8RWhvw4AxUy9JmUNLdvXtfNl/f58jFnCzOOsO/
         iqEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698858146; x=1699462946;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+CMbhE83gVdE7/6b871iYz3oVRssgurvombxQrmFMGA=;
        b=mD16JIKf7KejNf6SvTVMIcqDoSeQbgQS2IcsRP9Trf8cHRequcta+KH4qHWJ3xnc3S
         bc/R4RjjL5Q8Bb2NoK7dqeIVXLpwj/7beYPszQulOK5nPtfvdmYIrIKBAXvNujI5XnqH
         y1iPISY15UjzKRBbx+S3Fn7Ie4TpgoKvHKKX/M2Utaco4XERVzWseJOaiCikl/E5FqnR
         ad9Lkdzpg3J/DojNX3dOjbIv8WVTlYjPgZRYDUN3AqE2bJVQ4EXiCxqubu0gInr8A8Y5
         70UPaq030kbB3iq92lWZlif2dW9K4iNLa7PDg1+lMu2qsVm9HyaWuYHFu6fF7I5S+5J3
         LO8w==
X-Gm-Message-State: AOJu0Yy4nXTXfd08SGaU4g9eyqzHv7bopZaqVAomnby7QhMuRmdXIEBh
	QyOkI2Np2WSsu4RH8YqsKskH+6AFVXmKgA==
X-Google-Smtp-Source: AGHT+IFNtntu2ilsPgE2E7iq6WgEC3dCLXHRFsQQjqZbKEv86n02g1bpGZ0WxaTmFez/LPasusDJfA==
X-Received: by 2002:a05:600c:3d0e:b0:408:3bbd:4a82 with SMTP id bh14-20020a05600c3d0e00b004083bbd4a82mr13715339wmb.15.1698858145536;
        Wed, 01 Nov 2023 10:02:25 -0700 (PDT)
Received: from [192.168.14.111] (54-240-197-236.amazon.com. [54.240.197.236])
        by smtp.gmail.com with ESMTPSA id h12-20020a05600c314c00b0040641a9d49bsm239900wmo.17.2023.11.01.10.02.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Nov 2023 10:02:24 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <8b4fda17-07c3-4633-bf61-8b3829384c29@xen.org>
Date: Wed, 1 Nov 2023 17:02:23 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v3] KVM x86/xen: add an override for
 PVCLOCK_TSC_STABLE_BIT
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20231101112934.631344-1-paul@xen.org>
 <ZUKAzGzEts262FqC@google.com>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <ZUKAzGzEts262FqC@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/11/2023 16:46, Sean Christopherson wrote:
> On Wed, Nov 01, 2023, Paul Durrant wrote:
>> @@ -3231,12 +3245,15 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>>   	vcpu->hv_clock.flags = pvclock_flags;
>>   
>>   	if (vcpu->pv_time.active)
>> -		kvm_setup_guest_pvclock(v, &vcpu->pv_time, 0);
>> +		kvm_setup_guest_pvclock(v, &vcpu->pv_time, 0, false);
>> +
>>   	if (vcpu->xen.vcpu_info_cache.active)
>>   		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_info_cache,
>> -					offsetof(struct compat_vcpu_info, time));
>> +					offsetof(struct compat_vcpu_info, time),
>> +					xen_pvclock_tsc_unstable);
>>   	if (vcpu->xen.vcpu_time_info_cache.active)
>> -		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_time_info_cache, 0);
>> +		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_time_info_cache, 0,
>> +					xen_pvclock_tsc_unstable);
>>   	kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
>>   	return 0;
> 
> Please rebase, this conflicts with commit ee11ab6bb04e ("KVM: X86: Reduce size of
> kvm_vcpu_arch structure when CONFIG_KVM_XEN=n").  I can solve the conflict, but
> I really shouldn't have to.
> 
> Also, your version of git should support --base, which makes life much easier for
> others when non-trivial conflicts are encountered.  From maintainer-kvm-x86.rst:
> 
>   : Git Base
>   : ~~~~~~~~
>   : If you are using git version 2.9.0 or later (Googlers, this is all of you!),
>   : use ``git format-patch`` with the ``--base`` flag to automatically include the
>   : base tree information in the generated patches.
>   :
>   : Note, ``--base=auto`` works as expected if and only if a branch's upstream is
>   : set to the base topic branch, e.g. it will do the wrong thing if your upstream
>   : is set to your personal repository for backup purposes.  An alternative "auto"
>   : solution is to derive the names of your development branches based on their
>   : KVM x86 topic, and feed that into ``--base``.  E.g. ``x86/pmu/my_branch_name``,
>   : and then write a small wrapper to extract ``pmu`` from the current branch name
>   : to yield ``--base=x/pmu``, where ``x`` is whatever name your repository uses to
>   : track the KVM x86 remote.
> 

Ok, I'll sort that out. Thanks for the tip.

>> @@ -4531,7 +4548,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>   		    KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL |
>>   		    KVM_XEN_HVM_CONFIG_SHARED_INFO |
>>   		    KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL |
>> -		    KVM_XEN_HVM_CONFIG_EVTCHN_SEND;
>> +		    KVM_XEN_HVM_CONFIG_EVTCHN_SEND |
>> +		    KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE;
>>   		if (sched_info_on())
>>   			r |= KVM_XEN_HVM_CONFIG_RUNSTATE |
>>   			     KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG;
>> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
>> index 40edf4d1974c..7699d94f190b 100644
>> --- a/arch/x86/kvm/xen.c
>> +++ b/arch/x86/kvm/xen.c
>> @@ -1111,9 +1111,12 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
>>   
>>   int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc)
>>   {
>> +	bool update_pvclock = false;
>> +
>>   	/* Only some feature flags need to be *enabled* by userspace */
>>   	u32 permitted_flags = KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL |
>> -		KVM_XEN_HVM_CONFIG_EVTCHN_SEND;
>> +		KVM_XEN_HVM_CONFIG_EVTCHN_SEND |
>> +		KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE;
>>   
>>   	if (xhc->flags & ~permitted_flags)
>>   		return -EINVAL;
>> @@ -1134,9 +1137,19 @@ int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc)
>>   	else if (!xhc->msr && kvm->arch.xen_hvm_config.msr)
>>   		static_branch_slow_dec_deferred(&kvm_xen_enabled);
>>   
>> +	if ((kvm->arch.xen_hvm_config.flags &
>> +	     KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE) !=
>> +	    (xhc->flags &
>> +	     KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE))
>> +		update_pvclock = true;
> 
> Rather than a boolean and the above, which is a bit hard to parse, what about
> taking a snapshot of the old flags and then doing an XOR?
> 
> 	/* Only some feature flags need to be *enabled* by userspace */
> 	u32 permitted_flags = KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL |
> 		KVM_XEN_HVM_CONFIG_EVTCHN_SEND |
> 		KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE;
> 	u32 old_flags;
> 
> 	if (xhc->flags & ~permitted_flags)
> 		return -EINVAL;
> 
> 	/*
> 	 * With hypercall interception the kernel generates its own
> 	 * hypercall page so it must not be provided.
> 	 */
> 	if ((xhc->flags & KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL) &&
> 	    (xhc->blob_addr_32 || xhc->blob_addr_64 ||
> 	     xhc->blob_size_32 || xhc->blob_size_64))
> 		return -EINVAL;
> 
> 	mutex_lock(&kvm->arch.xen.xen_lock);
> 
> 	if (xhc->msr && !kvm->arch.xen_hvm_config.msr)
> 		static_branch_inc(&kvm_xen_enabled.key);
> 	else if (!xhc->msr && kvm->arch.xen_hvm_config.msr)
> 		static_branch_slow_dec_deferred(&kvm_xen_enabled);
> 
> 	old_flags = kvm->arch.xen_hvm_config.flags;
> 	memcpy(&kvm->arch.xen_hvm_config, xhc, sizeof(*xhc));
> 
> 	mutex_unlock(&kvm->arch.xen.xen_lock);
> 
> 	if ((old_flags ^ xhc->flags) & KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE)
> 		kvm_make_all_cpus_request(kvm, KVM_REQ_CLOCK_UPDATE);
> 
> 	return 0;

Sure, I can do it that way if you prefer.

   Paul



