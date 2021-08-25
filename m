Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0003F7055
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 09:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239241AbhHYHZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 03:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236402AbhHYHZg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 03:25:36 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFAFC061757;
        Wed, 25 Aug 2021 00:24:51 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id j187so20482362pfg.4;
        Wed, 25 Aug 2021 00:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:organization:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q73Nnih7jpsSbpkSWK5EpPqifAUWwvTUzbwSd8zUZyU=;
        b=o0UyFPQi4xqO3PzR7TAOaCJwvDbpz3DniRpvtWeJdH3bFKibc0Yv2FCWreUqPUHbyZ
         Y1N2wuqBQWtbQaQH7wEj9h421tRii3HA2gQDlxgU0aH1dmKS5U6xlLi7vCYFKJKacBdr
         wOSLbe2P+r08qzSvRTwT1TDrPBOcfBnQzivOflu3J6Q+FfFF9gr5BHFTr7EwnfGZZMi+
         1LEVYTlC/JfyZtCQNfPaSRWb+2BYOKgYScjhmqBgTE8zd1OSTZFHOplLv4GaVi4eEHRc
         oRKws3ayh76IwdphWNE2OupsCFlWEn6n70gHYJ8bEHx0kMhZXvWZYsY/z7gjgmakFECF
         Dd+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=q73Nnih7jpsSbpkSWK5EpPqifAUWwvTUzbwSd8zUZyU=;
        b=F6cyJyWgs8rG8GKodMAGxGM5duumb/f7TXJGPoR3NaWAAeSHMBHXQhmWHFz3I0gxjg
         I5xzapv39Ws0X4qErOMMVAkTQ2vsL2rDhwta2dwwV4iK2odji1lQVK3MtnYgvQuefIfI
         Nmy02Rfuc74q/17N9uEyIvOADWER8dCbA/BCphhCrOF+dO/zG3GU2WHYq5DWSOKJ9ILw
         6DL1K0UrZ2VTxGzoBmv4zQuwAU9kcFtcrLvUUlYCxtbj5v/W+N2q8Yo7awjf+tlCUg7r
         b6hFPt/xh+RCQ3UQQdEz8A4mCHmUQkATT5x1QtcDUskRXN5an+KNdgz04Aq62NJKexzB
         7JkA==
X-Gm-Message-State: AOAM531UoVMb6gl4+lmot2dHGBNiLcRcwOQOZr/wu0H31qdHkVKstAhz
        mj0C4Lb62DV9hsJsNQaBcs8=
X-Google-Smtp-Source: ABdhPJzRSyE5neu6RJ+gjTEVDHfBcpu6bsE7zXSnqjaD48x+obpgYGzPEezUn8K5kdl+d36SDtMxRw==
X-Received: by 2002:a05:6a00:168a:b0:3e2:789e:5fd0 with SMTP id k10-20020a056a00168a00b003e2789e5fd0mr43048282pfc.68.1629876291052;
        Wed, 25 Aug 2021 00:24:51 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id z3sm4482928pjn.43.2021.08.25.00.24.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 00:24:50 -0700 (PDT)
To:     Sean Christopherson <seanjc@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc:     Mark Rutland <mark.rutland@arm.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Artem Kashkanov <artem.kashkanov@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <20210823193709.55886-1-seanjc@google.com>
 <20210823193709.55886-3-seanjc@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH 2/3] KVM: x86: Register Processor Trace interrupt hook iff
 PT enabled in guest
Message-ID: <3021c1cc-a4eb-e3ab-d6b7-558cbaefd03b@gmail.com>
Date:   Wed, 25 Aug 2021 15:24:41 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210823193709.55886-3-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/8/2021 3:37 am, Sean Christopherson wrote:
> Override the Processor Trace (PT) interrupt handler for guest mode if and
> only if PT is configured for host+guest mode, i.e. is being used
> independently by both host and guest.  If PT is configured for system
> mode, the host fully controls PT and must handle all events.
> 
> Fixes: 8479e04e7d6b ("KVM: x86: Inject PMI for KVM guest")
> Cc: stable@vger.kernel.org
> Reported-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Reported-by: Artem Kashkanov <artem.kashkanov@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 1 +
>   arch/x86/kvm/pmu.h              | 1 +
>   arch/x86/kvm/vmx/vmx.c          | 1 +
>   arch/x86/kvm/x86.c              | 4 +++-
>   4 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 09b256db394a..1ea4943a73d7 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1494,6 +1494,7 @@ struct kvm_x86_init_ops {
>   	int (*disabled_by_bios)(void);
>   	int (*check_processor_compatibility)(void);
>   	int (*hardware_setup)(void);
> +	bool (*intel_pt_intr_in_guest)(void);
>   
>   	struct kvm_x86_ops *runtime_ops;
>   };
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 0e4f2b1fa9fb..b06dbbd7eeeb 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -41,6 +41,7 @@ struct kvm_pmu_ops {
>   	void (*reset)(struct kvm_vcpu *vcpu);
>   	void (*deliver_pmi)(struct kvm_vcpu *vcpu);
>   	void (*cleanup)(struct kvm_vcpu *vcpu);
> +	void (*handle_intel_pt_intr)(void);
>   };
>   
>   static inline u64 pmc_bitmask(struct kvm_pmc *pmc)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index fada1055f325..f19d72136f77 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7896,6 +7896,7 @@ static struct kvm_x86_init_ops vmx_init_ops __initdata = {
>   	.disabled_by_bios = vmx_disabled_by_bios,
>   	.check_processor_compatibility = vmx_check_processor_compat,
>   	.hardware_setup = hardware_setup,
> +	.intel_pt_intr_in_guest = vmx_pt_mode_is_host_guest,
>   
>   	.runtime_ops = &vmx_x86_ops,
>   };
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fb6015f97f9e..b5ade47dad9c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8305,7 +8305,7 @@ static struct perf_guest_info_callbacks kvm_guest_cbs = {
>   	.is_in_guest		= kvm_is_in_guest,
>   	.is_user_mode		= kvm_is_user_mode,
>   	.get_guest_ip		= kvm_get_guest_ip,
> -	.handle_intel_pt_intr	= kvm_handle_intel_pt_intr,
> +	.handle_intel_pt_intr	= NULL,
>   };
>   
>   #ifdef CONFIG_X86_64
> @@ -11061,6 +11061,8 @@ int kvm_arch_hardware_setup(void *opaque)
>   	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
>   	kvm_ops_static_call_update();
>   
> +	if (ops->intel_pt_intr_in_guest && ops->intel_pt_intr_in_guest())
> +		kvm_guest_cbs.handle_intel_pt_intr = kvm_handle_intel_pt_intr;

Emm, it's still buggy.

The guest "unknown NMI" from the host Intel PT can still be reproduced
after the following operation:

	rmmod kvm_intel
	modprobe kvm-intel pt_mode=1 ept=1
	rmmod kvm_intel
	modprobe kvm-intel pt_mode=1 ept=0

Since the handle_intel_pt_intr is not reset to NULL in kvm_arch_hardware_unsetup(),
and the previous function pointer still exists in the generic KVM data structure.

But I have to say that this fix is much better than the one I proposed [1].

[1] https://lore.kernel.org/lkml/20210514084436.848396-1-like.xu@linux.intel.com/

>   	perf_register_guest_info_callbacks(&kvm_guest_cbs);
>   
>   	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
> 
