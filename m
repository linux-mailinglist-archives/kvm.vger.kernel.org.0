Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7F7470595
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 17:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239937AbhLJQ2m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 11:28:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235394AbhLJQ2k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 11:28:40 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C44C061746;
        Fri, 10 Dec 2021 08:25:05 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id l25so32006030eda.11;
        Fri, 10 Dec 2021 08:25:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aq3bL3BbRmtZwxR4wWJFLPVeXPXiDvdj4OqXnxpLGk4=;
        b=US3cKBlDl5OFWCmuSnjWOJ+1xYty9xnVF9s9OotlkTgZAG13eTtMJiEFlQuKTxtyAX
         nd6Z87IhWvRHJjEyO7zy7lw5ZMHxp8A51RlwPlRizsWdchc+Qb8Al3EaXvlYEjjzCgCP
         dQP2BHS5rBbtk+47kOpTCONffz/xN4NjGUY1PfNCnQpYVSjkNyyEvLtDnlNsliG8PRSc
         unbTtNztz0b+nzWP/GTXfZqqdJciI7yTRT/IsHv7OUqwVs+g/YYdmi57FL6fEZ9F7roZ
         h9B+RLJKfCHe3tSTY5R5LN5gQgRGYxRbV1oRG051ZOSgmTeKgEB7T53TOn2g7hBPXm9g
         9uXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aq3bL3BbRmtZwxR4wWJFLPVeXPXiDvdj4OqXnxpLGk4=;
        b=FWba2RNHlUEVVuvP0KWgoA81VGIi9AjMTqkDVgmS1xOveRD6drujB9rhn629bt2j2h
         QfZ7DS5Vz8aHbVfJupT87PCUtl3auFwP6IHy1zBa2pIiW+2rQmv0CsPEMBPYzfvGsGRX
         hJT/r7Igdg0iE7eFw59adTHVlZpbnEpMDrMKgUfZ3n9tGbNprseFXytkbWh0A96KwzPi
         qkJu1K4zQTZG3S8UhAu/8+aZWMl4C6sGtQms/hr13GnEu5z1URRFIKLzDKk7Mc7wlTb+
         qJ0PgKm+su+LWPJwevP20twZU4PHrcRnOl8WZfBgwk4lQu8EcfWio0ThZOmvODiOqHj/
         ds9A==
X-Gm-Message-State: AOAM531fJ2BlGM286dev0SOlli1gnv60/t+lJecLU60Xn9hk54R27bXA
        7SbZW4OFpvdsTFOd2udD+aL+pPPYeSY=
X-Google-Smtp-Source: ABdhPJwVoFTV0ORzB/pl3r7l3Iaoe7pxBsmHbgSNb7z8el3iydU2LzBjZ5gFOwOo/xGw/fL1Af+Zqw==
X-Received: by 2002:a50:ef11:: with SMTP id m17mr40145717eds.98.1639153503694;
        Fri, 10 Dec 2021 08:25:03 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:48f9:bea:a04c:3dfe? ([2001:b07:6468:f312:48f9:bea:a04c:3dfe])
        by smtp.googlemail.com with ESMTPSA id hx14sm1677676ejc.92.2021.12.10.08.25.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 08:25:03 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <64f83af7-f769-7e5b-aaa4-588f27178cba@redhat.com>
Date:   Fri, 10 Dec 2021 17:25:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 16/19] kvm: x86: Introduce KVM_{G|S}ET_XSAVE2 ioctl
Content-Language: en-US
To:     Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-17-yang.zhong@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211208000359.2853257-17-yang.zhong@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/21 01:03, Yang Zhong wrote:
> From: Jing Liu <jing2.liu@intel.com>
> 
> When dynamic XSTATE features are supported, the xsave states are
> beyond 4KB. The current kvm_xsave structure and related
> KVM_{G, S}ET_XSAVE only allows 4KB which is not enough for full
> states.
> 
> Introduce a new kvm_xsave2 structure and the corresponding
> KVM_GET_XSAVE2 and KVM_SET_XSAVE2 ioctls so that userspace VMM
> can get and set the full xsave states.
> 
> Signed-off-by: Jing Liu <jing2.liu@intel.com>
> Signed-off-by: Yang Zhong <yang.zhong@intel.com>
> ---
>   arch/x86/include/uapi/asm/kvm.h |  6 ++++
>   arch/x86/kvm/x86.c              | 62 +++++++++++++++++++++++++++++++++
>   include/uapi/linux/kvm.h        |  7 +++-
>   3 files changed, 74 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 5a776a08f78c..de42a51e20c3 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -47,6 +47,7 @@
>   #define __KVM_HAVE_VCPU_EVENTS
>   #define __KVM_HAVE_DEBUGREGS
>   #define __KVM_HAVE_XSAVE
> +#define __KVM_HAVE_XSAVE2
>   #define __KVM_HAVE_XCRS
>   #define __KVM_HAVE_READONLY_MEM
>   
> @@ -378,6 +379,11 @@ struct kvm_xsave {
>   	__u32 region[1024];
>   };
>   
> +struct kvm_xsave2 {
> +	__u32 size;
> +	__u8 state[0];
> +};
> +
>   #define KVM_MAX_XCRS	16
>   
>   struct kvm_xcr {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8b033c9241d6..d212f6d2d39a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4216,6 +4216,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_DEBUGREGS:
>   	case KVM_CAP_X86_ROBUST_SINGLESTEP:
>   	case KVM_CAP_XSAVE:
> +	case KVM_CAP_XSAVE2:
>   	case KVM_CAP_ASYNC_PF:
>   	case KVM_CAP_ASYNC_PF_INT:
>   	case KVM_CAP_GET_TSC_KHZ:
> @@ -4940,6 +4941,17 @@ static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
>   				       vcpu->arch.pkru);
>   }
>   
> +static void kvm_vcpu_ioctl_x86_get_xsave2(struct kvm_vcpu *vcpu,
> +					  u8 *state, u32 size)
> +{
> +	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
> +		return;
> +
> +	fpu_copy_guest_fpstate_to_uabi(&vcpu->arch.guest_fpu,
> +				       state, size,
> +				       vcpu->arch.pkru);
> +}
> +
>   static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
>   					struct kvm_xsave *guest_xsave)
>   {
> @@ -4951,6 +4963,15 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
>   					      supported_xcr0, &vcpu->arch.pkru);
>   }
>   
> +static int kvm_vcpu_ioctl_x86_set_xsave2(struct kvm_vcpu *vcpu, u8 *state)
> +{
> +	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
> +		return 0;
> +
> +	return fpu_copy_uabi_to_guest_fpstate(&vcpu->arch.guest_fpu, state,
> +					      supported_xcr0, &vcpu->arch.pkru);
> +}
> +
>   static void kvm_vcpu_ioctl_x86_get_xcrs(struct kvm_vcpu *vcpu,
>   					struct kvm_xcrs *guest_xcrs)
>   {
> @@ -5416,6 +5437,47 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>   		r = kvm_vcpu_ioctl_x86_set_xsave(vcpu, u.xsave);
>   		break;
>   	}
> +	case KVM_GET_XSAVE2: {
> +		struct kvm_xsave2 __user *xsave2_arg = argp;
> +		struct kvm_xsave2 xsave2;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&xsave2, xsave2_arg, sizeof(struct kvm_xsave2)))
> +			break;
> +
> +		u.buffer = kzalloc(xsave2.size, GFP_KERNEL_ACCOUNT);
> +
> +		r = -ENOMEM;
> +		if (!u.buffer)
> +			break;
> +
> +		kvm_vcpu_ioctl_x86_get_xsave2(vcpu, u.buffer, xsave2.size);
> +
> +		r = -EFAULT;
> +		if (copy_to_user(xsave2_arg->state, u.buffer, xsave2.size))
> +			break;
> +
> +		r = 0;
> +		break;
> +	}
> +	case KVM_SET_XSAVE2: {
> +		struct kvm_xsave2 __user *xsave2_arg = argp;
> +		struct kvm_xsave2 xsave2;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&xsave2, xsave2_arg, sizeof(struct kvm_xsave2)))
> +			break;
> +
> +		u.buffer = memdup_user(xsave2_arg->state, xsave2.size);
> +
> +		if (IS_ERR(u.buffer)) {
> +			r = PTR_ERR(u.buffer);
> +			goto out_nofree;
> +		}
> +
> +		r = kvm_vcpu_ioctl_x86_set_xsave2(vcpu, u.buffer);
> +		break;
> +	}
>   	case KVM_GET_XCRS: {
>   		u.xcrs = kzalloc(sizeof(struct kvm_xcrs), GFP_KERNEL_ACCOUNT);
>   		r = -ENOMEM;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 0c7b301c7254..603e1ca9ba09 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1132,7 +1132,9 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
>   #define KVM_CAP_ARM_MTE 205
>   #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
> -
> +#ifdef __KVM_HAVE_XSAVE2
> +#define KVM_CAP_XSAVE2 207
> +#endif
>   #ifdef KVM_CAP_IRQ_ROUTING
>   
>   struct kvm_irq_routing_irqchip {
> @@ -1679,6 +1681,9 @@ struct kvm_xen_hvm_attr {
>   #define KVM_GET_SREGS2             _IOR(KVMIO,  0xcc, struct kvm_sregs2)
>   #define KVM_SET_SREGS2             _IOW(KVMIO,  0xcd, struct kvm_sregs2)
>   
> +#define KVM_GET_XSAVE2		   _IOR(KVMIO,  0xcf, struct kvm_xsave2)
> +#define KVM_SET_XSAVE2		   _IOW(KVMIO,  0xd0, struct kvm_xsave2)
> +
>   struct kvm_xen_vcpu_attr {
>   	__u16 type;
>   	__u16 pad[3];
> 

Please also modify KVM_GET/SET_XSAVE to fail with ENOSPC if the 
requested size is bigger than 4096.

Paolo
