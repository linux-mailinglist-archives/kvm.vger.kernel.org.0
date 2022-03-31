Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA0D94EDF68
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 19:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240513AbiCaRNE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 13:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240546AbiCaRNA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 13:13:00 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC055DA07
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 10:11:12 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id b15so186313pfm.5
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 10:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Drmbq79QeIm1cSvXRWC9Bjjy3UbRJvjEEz56yjhAFHk=;
        b=maCraEyhJbns9Y5iNDTD3D4TKY3vk4PGYgbE5V0t/IUKocIP3bPXW593LvA5ors1mu
         3AAMabfiPWFpSwWNlLOAymBkQ83YLTi7v6I2PVfEVPVm42eiqEd5mSIiCjWnEidAy0KE
         itLxmVzCpbWIEMBEoU5dARPQ9uHVizKDZ855waOH+sz8UbfqeFVr9Ol2UQ6jFChs0jg7
         SQNA/rUXSklfCdBcEAg9xwq0OfHROoVsw6Csvbvr0HVd6ntX8B+qFxFS25LWlZ9YkgBo
         bjBw8iuxG76K7Kt94aN9EEi+ETt0ZZHFBkl3wH0rs0/XzzeBYVVCVoen4asGJVKCg2qX
         PhMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Drmbq79QeIm1cSvXRWC9Bjjy3UbRJvjEEz56yjhAFHk=;
        b=FaYhc43mLGw0Lst6B8TYGZrkpmMAqYwEAeRwHzB0Pxz+YEsCHBib+5+th0DLSdDANv
         TJW6YuhuP9PEJyNSh1aM6RvqUbCMjTntOXi9aJ89gNrGU11z6XZR6ljgPjgFZQ3+UMEJ
         jBkG2bpsM0CHO2DcYefDdPCb+xnw9gZV8s6p3RWSJy1U/duDkVRzP8si7Nr4UXS2OyoM
         GMWrg3QhqYApVO9EtLMQ8QT4odw4xgykh+8N2D+nW7x6t74/8Tlqp/o0hGwRKfbIFGLk
         Sp+xTH+Mqdt5y3hkXzUIDRhQlH1a/lAzto9Q20juHYAxLQVQwO9zkUV789dot/tBoiKj
         YJnw==
X-Gm-Message-State: AOAM533U9pGjfFF6WpPnVizgpHuYnHX04IdjxXqxEcDLYesdaKDIq7XK
        oEE2MIeJu19HtBO6Ib7SzzF7AA==
X-Google-Smtp-Source: ABdhPJwtQ7QkU/dHqoQHuhPlTitS79pIvTcntQtAgPPtxVRspHRbWRlhYvyj8hf0lb245RMgKFCWhg==
X-Received: by 2002:a63:d149:0:b0:384:b288:8704 with SMTP id c9-20020a63d149000000b00384b2888704mr11374089pgj.112.1648746671936;
        Thu, 31 Mar 2022 10:11:11 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a11-20020a056a000c8b00b004fade889fb3sm58117pfv.18.2022.03.31.10.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 10:11:11 -0700 (PDT)
Date:   Thu, 31 Mar 2022 17:11:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3] KVM, SEV: Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
Message-ID: <YkXgq7hez9gGcmKt@google.com>
References: <20220330182821.2633150-1-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330182821.2633150-1-pgonda@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Paolo and Vitaly

In the future, I highly recommend using scripts/get_maintainers.pl.

On Wed, Mar 30, 2022, Peter Gonda wrote:
> SEV-ES guests can request termination using the GHCB's MSR protocol. See
> AMD's GHCB spec section '4.1.13 Termination Request'. Currently when a
> guest does this the userspace VMM sees an KVM_EXIT_UNKNOWN (-EVINAL)
> return code from KVM_RUN. By adding a KVM_EXIT_SHUTDOWN_ENTRY to kvm_run
> struct the userspace VMM can clearly see the guest has requested a SEV-ES
> termination including the termination reason code set and reason code.
> 
> Signed-off-by: Peter Gonda <pgonda@google.com>
> 
> ---
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 75fa6dd268f0..5f9d37dd3f6f 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2735,8 +2735,13 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>  		pr_info("SEV-ES guest requested termination: %#llx:%#llx\n",
>  			reason_set, reason_code);

This pr_info() should be removed.  A malicious usersepace could spam the kernel
by constantly running a vCPU that requests termination.

> -		ret = -EINVAL;
> -		break;
> +		vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
> +		vcpu->run->shutdown.reason = KVM_SHUTDOWN_SEV_TERM;
> +		vcpu->run->shutdown.ndata = 2;
> +		vcpu->run->shutdown.data[0] = reason_set;
> +		vcpu->run->shutdown.data[1] = reason_code;

Does KVM really need to split the reason_set and reason_code?  Without reading
the spec, it's not even clear what "set" means.  Assuming it's something like
"the reason code is valid", then I don't see any reason (lol) to split the two.
If we do split them, then arguably the reason_code should be filled if and only
if reason_set is true, and that's just extra work.

Dumping the entire raw "MSR" would simplify this code and the helper to fill the
termination request.

Though I'm not actually sure KVM_EXIT_SHUTDOWN is the best exit reason.  The
exit reason used for Hyper-V's paravirt stuff is arguably more appropriate,
because in this case the guest hasn't actually encountered shutdown, rather it
has requested termination.

		/* KVM_EXIT_SYSTEM_EVENT */
		struct {
#define KVM_SYSTEM_EVENT_SHUTDOWN       1
#define KVM_SYSTEM_EVENT_RESET          2
#define KVM_SYSTEM_EVENT_CRASH          3
			__u32 type;
			__u64 flags;
		} system_event;

Though looking at system_event, isn't that missing padding after type?  Ah, KVM
doesn't actually populate flags, wonderful.  Maybe we can get away with tweaking
it to:

		struct {
			__u32 type;
			__u32 ndata;
			__u64 data[16];
		} system_event;

> +
> +		return 0;
>  	}
>  	default:
>  		/* Error, keep GHCB MSR value as-is */
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 6535adee3e9c..c2cc10776517 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1953,6 +1953,8 @@ static int shutdown_interception(struct kvm_vcpu *vcpu)
>  	kvm_vcpu_reset(vcpu, true);
>  
>  	kvm_run->exit_reason = KVM_EXIT_SHUTDOWN;
> +	vcpu->run->shutdown.reason = KVM_SHUTDOWN_REQ;
> +	vcpu->run->shutdown.ndata = 0;
>  	return 0;
>  }
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 84a7500cd80c..85b21fc490e4 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4988,6 +4988,8 @@ static __always_inline int handle_external_interrupt(struct kvm_vcpu *vcpu)
>  static int handle_triple_fault(struct kvm_vcpu *vcpu)
>  {
>  	vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
> +	vcpu->run->shutdown.reason = KVM_SHUTDOWN_REQ;
> +	vcpu->run->shutdown.ndata = 0;

If we do piggyback KVM_EXIT_SHUTDOWN, a helper to fill the shutdown reason is
warranted, similar to prepare_emulation_failure_exit().  If the raw GHCB MSR is
dumped, the helper can be:

  void kvm_prepare_shutdown_exit(struct kvm_vcpu *vcpu, u64 *data);

where a NULL @data means ndata=0, and a non-NULL @data means ndata=1.

>  	vcpu->mmio_needed = 0;
>  	return 0;
>  }
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d3a9ce07a565..f7cd224a4c32 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9999,6 +9999,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  				kvm_x86_ops.nested_ops->triple_fault(vcpu);
>  			} else {
>  				vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
> +				vcpu->run->shutdown.reason = KVM_SHUTDOWN_REQ;
> +				vcpu->run->shutdown.ndata = 0;
>  				vcpu->mmio_needed = 0;
>  				r = 0;
>  				goto out;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 8616af85dc5d..017c03421c48 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -271,6 +271,12 @@ struct kvm_xen_exit {
>  #define KVM_EXIT_XEN              34
>  #define KVM_EXIT_RISCV_SBI        35
>  
> +/* For KVM_EXIT_SHUTDOWN */
> +/* Standard VM shutdown request. No additional metadata provided. */
> +#define KVM_SHUTDOWN_REQ	0

I dislike the "REQ" part.  In a triple fault scenario, the guest isn't requesting
anything.  KVM does "request" shutdown, but that's not a request from the guest's
perspective and is purely a KVM implementation detail.  I'm having trouble coming
up with a decent alternative, but that's probably another indicator that piggybacking
KVM_EXIT_SHUTDOWN may not be appropriate.

> +/* SEV-ES termination request */
> +#define KVM_SHUTDOWN_SEV_TERM	1
> +
>  /* For KVM_EXIT_INTERNAL_ERROR */
>  /* Emulate instruction failed. */
>  #define KVM_INTERNAL_ERROR_EMULATION	1
> @@ -311,6 +317,12 @@ struct kvm_run {
>  		struct {
>  			__u64 hardware_exit_reason;
>  		} hw;
> +		/* KVM_EXIT_SHUTDOWN */
> +		struct {
> +			__u64 reason;
> +			__u32 ndata;

This needs 

			__u32 pad;

to ensure data[16] is aligned regardless of compiler.  Though it's simpler to
just do:

		struct {
			__u32 reason;
			__u32 ndata;
			__u64 data[16];
		}

because 4 billion reasons is probably enough :-)

> +			__u64 data[16];
> +		} shutdown;
>  		/* KVM_EXIT_FAIL_ENTRY */
>  		struct {
>  			__u64 hardware_entry_failure_reason;
> @@ -1145,6 +1157,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_PMU_CAPABILITY 212
>  #define KVM_CAP_DISABLE_QUIRKS2 213
>  #define KVM_CAP_VM_TSC_CONTROL 214
> +#define KVM_CAP_EXIT_SHUTDOWN_REASON 215
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 70e05af5ebea..03b6e472f32c 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4299,6 +4299,7 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>  	case KVM_CAP_CHECK_EXTENSION_VM:
>  	case KVM_CAP_ENABLE_CAP_VM:
>  	case KVM_CAP_HALT_POLL:
> +	case KVM_CAP_EXIT_SHUTDOWN_REASON:
>  		return 1;
>  #ifdef CONFIG_KVM_MMIO
>  	case KVM_CAP_COALESCED_MMIO:
> -- 
> 2.35.1.1094.g7c7d902a7c-goog
> 
