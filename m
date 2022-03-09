Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E7C4D328E
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 17:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234171AbiCIQDS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 11:03:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234246AbiCIQCy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 11:02:54 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E62017F6A5
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 08:01:51 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id b24so3437613edu.10
        for <kvm@vger.kernel.org>; Wed, 09 Mar 2022 08:01:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bNm7G6IiV8nF+QMIC6woAzjAzzxvSSE04jWxtPLvt9c=;
        b=K/ovNL0cdiBocoz4nbhEs4jAoxl1ebwRuTQKxzhVRVQ3CNi1O9jZg/0CPMdQTjEn6K
         exQW4cp/Q+eePJzNSrsLju4EB5BV6Lzwt5Zbq4BDo900U4GtgyH5WtU0gNwMGhksdp8Z
         AX8BwmTKb8CbTANL1gBB2+keTomz1cx3f596miCPxYkyzn5oepUsChdmrBduVZ/j8z0o
         06SJHk0jVmSwqx1sQtlJb4l5Zn8zeJZiLPHkZoA9A4aKjV4+dnzA33GWUQ2igF488BmJ
         FSkTxZXqqJ3N57UjOWnSxstG0fDJFJXIiIJNeexePk/tT/q/lL3pjpmxDkU+NBBr7rvB
         BX+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bNm7G6IiV8nF+QMIC6woAzjAzzxvSSE04jWxtPLvt9c=;
        b=ra6YyITMWA42iq5g7SROxYobuA5y2OTJkbq8iiljNvhHslfVZ8vKSncCO7yG1/KlCp
         oXLRe12eIy4BuvVxbDPbcZRAlglfnWJ8RY76wxbEkgqFjK9nobZ+lkEbhN2ikn8mHTOo
         wfUDC7dHIqNlf7CMrrtqKpLoo0e55Y67kTePIKLgRrdBL4I2vqonpO53VZWvRz7HvJvT
         Uh1VUocFaz/DvE55RcI4nKNiA+fUZsIJhMZLBcCxBrqzxGoUkx87hD2XZjBP+y70lUdk
         oaW2NgmDm1KhGzySixVievpnHYLoTP0BhoHSSlWrqOiIl8E/vvUJzWpSSmrZYrTxs366
         ICkQ==
X-Gm-Message-State: AOAM530YAvcB4s2aQ7jzmAkAPFdG5KHszq/VRXdl97+vFgvezyE/ghL7
        pJCzw/dmCqy9tgAC+YJV970=
X-Google-Smtp-Source: ABdhPJzNitTVRa4m/MptKZdEK2YY3rUB+3mwmr9KL11EXqRWdt7CD9IGFNo2mSLyQR+TrRq/l7nS6Q==
X-Received: by 2002:a50:cccf:0:b0:410:ba4e:65fd with SMTP id b15-20020a50cccf000000b00410ba4e65fdmr106631edj.31.1646841709443;
        Wed, 09 Mar 2022 08:01:49 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id n3-20020a1709061d0300b006da94efcc7esm869105ejh.204.2022.03.09.08.01.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 08:01:48 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <be4a48a8-9d42-9a22-2367-fe4c009042e3@redhat.com>
Date:   Wed, 9 Mar 2022 17:01:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 4/8] KVM: x86: Introduce KVM_CAP_DISABLE_QUIRKS2
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>
References: <20220301060351.442881-1-oupton@google.com>
 <20220301060351.442881-5-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220301060351.442881-5-oupton@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/1/22 07:03, Oliver Upton wrote:
> KVM_CAP_DISABLE_QUIRKS is irrevocably broken. The capability does not
> advertise the set of quirks which may be disabled to userspace, so it is
> impossible to predict the behavior of KVM. Worse yet,
> KVM_CAP_DISABLE_QUIRKS will tolerate any value for cap->args[0], meaning
> it fails to reject attempts to set invalid quirk bits.
> 
> The only valid workaround for the quirky quirks API is to add a new CAP.
> Actually advertise the set of quirks that can be disabled to userspace
> so it can predict KVM's behavior. Reject values for cap->args[0] that
> contain invalid bits.
> 
> Finally, add documentation for the new capability and describe the
> existing quirks.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>

Queued, thanks.

Paolo

> ---
>   Documentation/virt/kvm/api.rst  | 50 +++++++++++++++++++++++++++++++++
>   arch/x86/include/asm/kvm_host.h |  7 +++++
>   arch/x86/kvm/x86.c              |  8 ++++++
>   include/uapi/linux/kvm.h        |  1 +
>   4 files changed, 66 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index f5d011351016..8f7240e79cc0 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7079,6 +7079,56 @@ resource that is controlled with the H_SET_MODE hypercall.
>   This capability allows a guest kernel to use a better-performance mode for
>   handling interrupts and system calls.
>   
> +7.31 KVM_CAP_DISABLE_QUIRKS2
> +----------------------------
> +
> +:Capability: KVM_CAP_DISABLE_QUIRKS2
> +:Parameters: args[0] - set of KVM quirks to disable
> +:Architectures: x86
> +:Type: vm
> +
> +This capability, if enabled, will cause KVM to disable some behavior
> +quirks.
> +
> +Calling KVM_CHECK_EXTENSION for this capability returns a bitmask of
> +quirks that can be disabled in KVM.
> +
> +The argument to KVM_ENABLE_CAP for this capability is a bitmask of
> +quirks to disable, and must be a subset of the bitmask returned by
> +KVM_CHECK_EXTENSION.
> +
> +The valid bits in cap.args[0] are:
> +
> +=================================== ============================================
> + KVM_X86_QUIRK_LINT0_REENABLED      By default, the reset value for the LVT
> +                                    LINT0 register is 0x700 (APIC_MODE_EXTINT).
> +                                    When this quirk is disabled, the reset value
> +                                    is 0x10000 (APIC_LVT_MASKED).
> +
> + KVM_X86_QUIRK_CD_NW_CLEARED        By default, KVM clears CR0.CD and CR0.NW.
> +                                    When this quirk is disabled, KVM does not
> +                                    change the value of CR0.CD and CR0.NW.
> +
> + KVM_X86_QUIRK_LAPIC_MMIO_HOLE      By default, the MMIO LAPIC interface is
> +                                    available even when configured for x2APIC
> +                                    mode. When this quirk is disabled, KVM
> +                                    disables the MMIO LAPIC interface if the
> +                                    LAPIC is in x2APIC mode.
> +
> + KVM_X86_QUIRK_OUT_7E_INC_RIP       By default, KVM pre-increments %rip before
> +                                    exiting to userspace for an OUT instruction
> +                                    to port 0x7e. When this quirk is disabled,
> +                                    KVM does not pre-increment %rip before
> +                                    exiting to userspace.
> +
> + KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT When this quirk is disabled, KVM sets
> +                                    CPUID.01H:ECX[bit 3] (MONITOR/MWAIT) if
> +                                    IA32_MISC_ENABLE[bit 18] (MWAIT) is set.
> +                                    Additionally, when this quirk is disabled,
> +                                    KVM clears CPUID.01H:ECX[bit 3] if
> +                                    IA32_MISC_ENABLE[bit 18] is cleared.
> +=================================== ============================================
> +
>   8. Other capabilities.
>   ======================
>   
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index ccec837e520d..bc3405565967 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1963,4 +1963,11 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
>   #define KVM_CLOCK_VALID_FLAGS						\
>   	(KVM_CLOCK_TSC_STABLE | KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC)
>   
> +#define KVM_X86_VALID_QUIRKS			\
> +	(KVM_X86_QUIRK_LINT0_REENABLED |	\
> +	 KVM_X86_QUIRK_CD_NW_CLEARED |		\
> +	 KVM_X86_QUIRK_LAPIC_MMIO_HOLE |	\
> +	 KVM_X86_QUIRK_OUT_7E_INC_RIP |		\
> +	 KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)
> +
>   #endif /* _ASM_X86_KVM_HOST_H */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c712c33c1521..ec9b602be8da 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4350,6 +4350,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   		r = enable_pmu ? KVM_CAP_PMU_VALID_MASK : 0;
>   		break;
>   	}
> +	case KVM_CAP_DISABLE_QUIRKS2:
> +		r = KVM_X86_VALID_QUIRKS;
> +		break;
>   	default:
>   		break;
>   	}
> @@ -5896,6 +5899,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   		return -EINVAL;
>   
>   	switch (cap->cap) {
> +	case KVM_CAP_DISABLE_QUIRKS2:
> +		r = -EINVAL;
> +		if (cap->args[0] & ~KVM_X86_VALID_QUIRKS)
> +			break;
> +		fallthrough;
>   	case KVM_CAP_DISABLE_QUIRKS:
>   		kvm->arch.disabled_quirks = cap->args[0];
>   		r = 0;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index d2f1efc3aa35..91a6fe4e02c0 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1143,6 +1143,7 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_CAP_PPC_AIL_MODE_3 210
>   #define KVM_CAP_S390_MEM_OP_EXTENSION 211
>   #define KVM_CAP_PMU_CAPABILITY 212
> +#define KVM_CAP_DISABLE_QUIRKS2 213
>   
>   #ifdef KVM_CAP_IRQ_ROUTING
>   

