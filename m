Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD76F3BD83F
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbhGFOft (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 10:35:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57375 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232326AbhGFOfq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 10:35:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625581702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kAXRQIQOyrP0g5o0EvkttGD6vMDJoyXaK3EIFo8Ix/U=;
        b=fCbswAoMfb4Kq3dS4ADqYmwXF+YVxFa940/d+Q6EBttufzAW2xPgi5F+2EqVyljiT6O2/8
        u2MPZMSi9Lkvu+S7tuECvXBpFBN1ZyoJQsbp7c921qGMEL1rIYQqOs9+tdVEIwbVqJ20zt
        pHJ5PVBHNPfBT7XfFu6XTjXGpLIDmi8=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-546-zuIS-AKJND2HDvuVzYhcnQ-1; Tue, 06 Jul 2021 10:12:13 -0400
X-MC-Unique: zuIS-AKJND2HDvuVzYhcnQ-1
Received: by mail-ej1-f69.google.com with SMTP id my13-20020a1709065a4db02904dca50901ebso1579363ejc.12
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 07:12:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kAXRQIQOyrP0g5o0EvkttGD6vMDJoyXaK3EIFo8Ix/U=;
        b=mK9ZFXsFWR9vjmfdE1iWRk/xo/C/09sNkCZCsAOXaOsh8/RtuvGtilVjDV81pnxbfZ
         8IsIQlZbsWfrPXUiXcEU7+i+91vAyUPOLTUtMX7APhqdKZ7oliHca4kGWeyAj3P6yNie
         ZfLAm7ZgTTDvQ7dqI5UHyRGw/K3UVUkUZP5Lb+Ae+SwfyeyT9XO0M0MZqAJsuNrgOb64
         O4CYGyOyC37qdpY4sgilQZMjHzORQ3QdNsW3+cmpREyYDpLsYHajlX3wplYzN0PP8LI7
         R3ZreQ/YRpJeh8LmVctbC5D/okjz6uKzU2tJh6ioovoUgSpSLRsSUAHfKlpZYsyKNI/f
         5Kpg==
X-Gm-Message-State: AOAM530fYYh7SwJH/MCE7p41gQCBeuaR4ka30w6L6D86MxjIKg7JTjol
        aeUAT7eCAnBLkrRoOlmYPs6ezXSdtV6aYKIRIQ6sLZa8Zj9T6MUzPZmU8RaeR/twyG0bAtGenHC
        HPMQZUI5kEMk2
X-Received: by 2002:a17:907:1691:: with SMTP id hc17mr18418953ejc.382.1625580732546;
        Tue, 06 Jul 2021 07:12:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzKz34q4gDTn4Kf2fUnrBHph+ddCTrKRbmybA5FfMS/MCT+c1HunciX4cxDDuiyEsLN89xzEQ==
X-Received: by 2002:a17:907:1691:: with SMTP id hc17mr18418922ejc.382.1625580732303;
        Tue, 06 Jul 2021 07:12:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f9sm5585747edw.88.2021.07.06.07.12.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 07:12:10 -0700 (PDT)
Subject: Re: [RFC PATCH v2 34/69] KVM: x86: Add support for vCPU and
 device-scoped KVM_MEMORY_ENCRYPT_OP
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <68b1d5fb6afc30e41e46be63ef67412ec3b08fab.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c1d15f15-ee6f-14fe-c21d-27f426fdc17f@redhat.com>
Date:   Tue, 6 Jul 2021 16:12:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <68b1d5fb6afc30e41e46be63ef67412ec3b08fab.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  2 ++
>   arch/x86/kvm/x86.c              | 12 ++++++++++++
>   2 files changed, 14 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 9791c4bb5198..e3abf077f328 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1377,7 +1377,9 @@ struct kvm_x86_ops {
>   	int (*pre_leave_smm)(struct kvm_vcpu *vcpu, const char *smstate);
>   	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
>   
> +	int (*mem_enc_op_dev)(void __user *argp);
>   	int (*mem_enc_op)(struct kvm *kvm, void __user *argp);
> +	int (*mem_enc_op_vcpu)(struct kvm_vcpu *vcpu, void __user *argp);
>   	int (*mem_enc_reg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
>   	int (*mem_enc_unreg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
>   	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f7ae0a47e555..da9f1081cb03 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4109,6 +4109,12 @@ long kvm_arch_dev_ioctl(struct file *filp,
>   	case KVM_GET_SUPPORTED_HV_CPUID:
>   		r = kvm_ioctl_get_supported_hv_cpuid(NULL, argp);
>   		break;
> +	case KVM_MEMORY_ENCRYPT_OP:
> +		r = -EINVAL;
> +		if (!kvm_x86_ops.mem_enc_op_dev)
> +			goto out;
> +		r = kvm_x86_ops.mem_enc_op_dev(argp);
> +		break;
>   	default:
>   		r = -EINVAL;
>   		break;
> @@ -5263,6 +5269,12 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>   		break;
>   	}
>   #endif
> +	case KVM_MEMORY_ENCRYPT_OP:
> +		r = -EINVAL;
> +		if (!kvm_x86_ops.mem_enc_op_vcpu)
> +			goto out;
> +		r = kvm_x86_ops.mem_enc_op_vcpu(vcpu, argp);
> +		break;
>   	default:
>   		r = -EINVAL;
>   	}
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

