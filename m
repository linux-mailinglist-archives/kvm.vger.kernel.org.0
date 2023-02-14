Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D333769628D
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 12:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbjBNLjW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 06:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjBNLjV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 06:39:21 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0D0233C8;
        Tue, 14 Feb 2023 03:39:15 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id w20-20020a17090a8a1400b00233d7314c1cso7413174pjn.5;
        Tue, 14 Feb 2023 03:39:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/Y57F08pUra92blWcIk+PqGFgFXQ01NHbnCF22kLkSc=;
        b=R9RRplBng8KHI9xyWdPmB2r7QLviyH7cRO3oyxS8roXx7HrOwCo8jS0wCmIXhWCDKj
         mQaD6JoyrdqPF+ROb3FQ+EdRABjucoD7VucMW+XLWz0B6106BD1mV3PFH+MA0FhASEkC
         ojrfiDZUT55ms9YSAMy701AvkOQCm2nD9YOZ+L9wKgA33ulamD8DATFV6mwR7XMd+VpK
         ppZDa+IKYMCECKuHR8pA1pocJKrvnuhNH/ver/NryWXmqHDloUR0bHR+pNkkoO9HlEi4
         ib0JmMUlDpfC7sQfG3LLsHSPFgAfl/vCEu5q++dMrKG4f2LxDsO/7ObU/5XVkQVSK6kr
         6MUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/Y57F08pUra92blWcIk+PqGFgFXQ01NHbnCF22kLkSc=;
        b=YPjO9q2K8XQHzEdX8iJLJ3cZgWGRwuXtw3v4TLZNQnQV+6pBQOVkkE9oRs0ftF193b
         61/Bd/eJht1/TvOB98qU8nLy9HCplwKy2rUIqa8KGasylRaaztETiE1jbOhBEHuUDytG
         7dP6MuuoTSjDxmO9fAVUr0uOFpTsm7wB9eHQYlMCZ/1g5jMnJ7ZF4Av4VuQZ9XkfenC1
         uOX7nW6HuvFnRAyluxiJ36EdfsKpV5Sh9TQhLDFq/kV4oizksoVXRs3DUrT4b5dZOQby
         F32BjCzT/uEDF+y3gPheIeA/ddREL2NGItrTydUA5aQRa63fjipcQZDzrE628AawtG1X
         8mXA==
X-Gm-Message-State: AO0yUKVAtHXZIA8D6U1qoKrJO5EgnIDTT+UEnmCtS9kyUdoeBfn6BOv/
        3uQMUQnRtULgM6ErH0aBi/ROOEebVigXU7F9z7Q=
X-Google-Smtp-Source: AK7set/QyO0+U3as6lA7xWgRlSxgkKZjw7IDHpaF3AS0Sn1LZun9am32Kc6+S4OZQNg3zWyOOCdtWg==
X-Received: by 2002:a05:6a20:b91b:b0:bf:58d1:ce99 with SMTP id fe27-20020a056a20b91b00b000bf58d1ce99mr14877930pzb.24.1676374755150;
        Tue, 14 Feb 2023 03:39:15 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t1-20020a63b701000000b004fb5704f19bsm7381770pgf.31.2023.02.14.03.39.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 03:39:14 -0800 (PST)
Message-ID: <4f0d03de-4372-2472-ef59-e80bb3aa7703@gmail.com>
Date:   Tue, 14 Feb 2023 19:39:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH v2 05/21] KVM: x86: Disallow writes to immutable feature
 MSRs after KVM_RUN
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230210003148.2646712-1-seanjc@google.com>
 <20230210003148.2646712-6-seanjc@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230210003148.2646712-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/2/2023 8:31 am, Sean Christopherson wrote:
> Disallow writes to feature MSRs after KVM_RUN to prevent userspace from
> changing the vCPU model after running the vCPU.  Similar to guest CPUID,
> KVM uses feature MSRs to configure intercepts, determine what operations
> are/aren't allowed, etc.  Changing the capabilities while the vCPU is
> active will at best yield unpredictable guest behavior, and at worst
> could be dangerous to KVM.
> 
> Allow writing the current value, e.g. so that userspace can blindly set
> all MSRs when emulating RESET, and unconditionally allow writes to
> MSR_IA32_UCODE_REV so that userspace can emulate patch loads.
> 
> Special case the VMX MSRs to keep the generic list small, i.e. so that
> KVM can do a linear walk of the generic list without incurring meaningful
> overhead.
> 
> Cc: Like Xu <like.xu.linux@gmail.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/x86.c | 36 ++++++++++++++++++++++++++++++++++++
>   1 file changed, 36 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7b73a0b45041..186cb6a81643 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1554,6 +1554,25 @@ static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all_except_vmx) +
>   			      (KVM_LAST_EMULATED_VMX_MSR - KVM_FIRST_EMULATED_VMX_MSR + 1)];
>   static unsigned int num_msr_based_features;
>   
> +/*
> + * All feature MSRs except uCode revID, which tracks the currently loaded uCode
> + * patch, are immutable once the vCPU model is defined.
> + */
> +static bool kvm_is_immutable_feature_msr(u32 msr)
> +{
> +	int i;
> +
> +	if (msr >= KVM_FIRST_EMULATED_VMX_MSR && msr <= KVM_LAST_EMULATED_VMX_MSR)
> +		return true;
> +
> +	for (i = 0; i < ARRAY_SIZE(msr_based_features_all_except_vmx); i++) {
> +		if (msr == msr_based_features_all_except_vmx[i])
> +			return msr != MSR_IA32_UCODE_REV;
> +	}
> +
> +	return false;
> +}
> +
>   /*
>    * Some IA32_ARCH_CAPABILITIES bits have dependencies on MSRs that KVM
>    * does not yet virtualize. These include:
> @@ -2168,6 +2187,23 @@ static int do_get_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
>   
>   static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
>   {
> +	u64 val;
> +
> +	/*
> +	 * Disallow writes to immutable feature MSRs after KVM_RUN.  KVM does
> +	 * not support modifying the guest vCPU model on the fly, e.g. changing
> +	 * the nVMX capabilities while L2 is running is nonsensical.  Ignore
> +	 * writes of the same value, e.g. to allow userspace to blindly stuff
> +	 * all MSRs when emulating RESET.
> +	 */
> +	if (vcpu->arch.last_vmentry_cpu != -1 &&

Three concerns on my mind (to help you think more if any):
- why not using kvm->created_vcpus;

- how about different vcpu models of the same guest have different feature_msr 
values;
(although they are not altered after the first run, cases (selftests) may be 
needed to
show that it is dangerous for KVM);

- the relative time to set "vcpu->arch.last_vmentry_cpu = vcpu->cpu" is still 
too late,
since part of the guest code (an attack window) has already been executed on first
run of kvm_x86_vcpu_run() which may run for a long time;

> +	    kvm_is_immutable_feature_msr(index)) {
> +		if (do_get_msr(vcpu, index, &val) || *data != val)
> +			return -EINVAL;
> +
> +		return 0;
> +	}
> +
>   	return kvm_set_msr_ignored_check(vcpu, index, *data, true);
>   }
>   
