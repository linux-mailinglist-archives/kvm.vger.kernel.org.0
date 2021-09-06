Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD87401FCA
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 20:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244553AbhIFSiq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 14:38:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59189 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236746AbhIFSio (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Sep 2021 14:38:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630953459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wnh0WKCRe49Jpy2AZ0FfJzHfp3O52I++fgnbbsEPWvk=;
        b=DGDc2/9nmfoUwgORKjX6iErRKBVc/yMPFRtQEBuxpfpGoFjoyMaSC7cZutejNnYWDTyU8S
        EYdPhLVol6kqtvRINHTbU73qF5BIb/Y0C+QlDfsYwr3yrTBZ3GYG2AIbQ6EINMVO4pe4zQ
        oKqO/SUM51QHOeL/7fv9aOb1LXV6eVs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-X_aEC181O5W4ShVCZiF84g-1; Mon, 06 Sep 2021 14:37:38 -0400
X-MC-Unique: X_aEC181O5W4ShVCZiF84g-1
Received: by mail-wr1-f71.google.com with SMTP id u2-20020adfdd42000000b001579f5d6779so1370912wrm.8
        for <kvm@vger.kernel.org>; Mon, 06 Sep 2021 11:37:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Wnh0WKCRe49Jpy2AZ0FfJzHfp3O52I++fgnbbsEPWvk=;
        b=D8xeUxsS3I66EfSfyPZRBzCf+1YmBToKOOD8IN8tboETekEhrNYvbeYUjBJ13oaZnx
         Nr4rf3L6YJEH8pq989XSYenNHT72RDmZKz9zB7pOYC7TLykyFxoUvaTdu8Yti2w1ivIc
         77U9g72itC+kyPGcV4Ss8fBNVL+sfX6D+OG3PaFl9me17g72K6dlHVBw3GSw+i6twiGp
         WhOHfq8NuFbpwgiyW9WUNEKtQFzSpWRYFviSpCZJ+RDL0SOw1mJBYdAHAt7wlaStLHNY
         TkcCccYL9QM3SfFplxh7pHqGHcEdxPpy69xq2N65ZKCcjDTUjDn4AumJ8L7XN9pbuauy
         jTrA==
X-Gm-Message-State: AOAM533Nn3VuOhlu7nD43vQZpJzuD9T0ShCyQNHIOel28duwOTERjtep
        d8OsSThmqs6CyOMWH8a6BCC+1ehUWiaO44uxXg0tEnggqfnHYcaqcVCJQZrYrbyOozJWU6j0LJ+
        +08aQyCacZyhT
X-Received: by 2002:a1c:2289:: with SMTP id i131mr412365wmi.113.1630953456911;
        Mon, 06 Sep 2021 11:37:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZGwfAJjZTLGnBV4KbGuYowR9PrWwNbsztoLb9n5KDjqcp7r1O7B+GCYU05DrZdWJQy51Xeg==
X-Received: by 2002:a1c:2289:: with SMTP id i131mr412347wmi.113.1630953456697;
        Mon, 06 Sep 2021 11:37:36 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6323.dip0.t-ipconnect.de. [91.12.99.35])
        by smtp.gmail.com with ESMTPSA id t14sm257161wmi.12.2021.09.06.11.37.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 11:37:36 -0700 (PDT)
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com
References: <1627979206-32663-1-git-send-email-pmorel@linux.ibm.com>
 <1627979206-32663-3-git-send-email-pmorel@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v3 2/3] s390x: KVM: Implementation of Multiprocessor
 Topology-Change-Report
Message-ID: <d85a6998-0f86-44d9-4eae-3051b65c2b4e@redhat.com>
Date:   Mon, 6 Sep 2021 20:37:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1627979206-32663-3-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03.08.21 10:26, Pierre Morel wrote:
> We let the userland hypervisor know if the machine support the CPU
> topology facility using a new KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
> 
> The PTF instruction will report a topology change if there is any change
> with a previous STSI_15_2 SYSIB.
> Changes inside a STSI_15_2 SYSIB occur if CPU bits are set or clear
> inside the CPU Topology List Entry CPU mask field, which happens with
> changes in CPU polarization, dedication, CPU types and adding or
> removing CPUs in a socket.
> 
> The reporting to the guest is done using the Multiprocessor
> Topology-Change-Report (MTCR) bit of the utility entry of the guest's
> SCA which will be cleared during the interpretation of PTF.
> 
> To check if the topology has been modified we use a new field of the
> arch vCPU to save the previous real CPU ID at the end of a schedule
> and verify on next schedule that the CPU used is in the same socket.
> 
> We deliberatly ignore:
> - polarization: only horizontal polarization is currently used in linux.
> - CPU Type: only IFL Type are supported in Linux
> - Dedication: we consider that only a complete dedicated CPU stack can
>    take benefit of the CPU Topology.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>


> @@ -228,7 +232,7 @@ struct kvm_s390_sie_block {
>   	__u8	icptcode;		/* 0x0050 */
>   	__u8	icptstatus;		/* 0x0051 */
>   	__u16	ihcpu;			/* 0x0052 */
> -	__u8	reserved54;		/* 0x0054 */
> +	__u8	mtcr;			/* 0x0054 */
>   #define IICTL_CODE_NONE		 0x00
>   #define IICTL_CODE_MCHK		 0x01
>   #define IICTL_CODE_EXT		 0x02
> @@ -246,6 +250,7 @@ struct kvm_s390_sie_block {
>   #define ECB_TE		0x10
>   #define ECB_SRSI	0x04
>   #define ECB_HOSTPROTINT	0x02
> +#define ECB_PTF		0x01

 From below I understand, that ECB_PTF can be used with stfl(11) in the 
hypervisor.

What is to happen if the hypervisor doesn't support stfl(11) and we 
consequently cannot use ECB_PTF? Will QEMU be able to emulate PTF fully?


>   	__u8	ecb;			/* 0x0061 */
>   #define ECB2_CMMA	0x80
>   #define ECB2_IEP	0x20
> @@ -747,6 +752,7 @@ struct kvm_vcpu_arch {
>   	bool skey_enabled;
>   	struct kvm_s390_pv_vcpu pv;
>   	union diag318_info diag318_info;
> +	int prev_cpu;
>   };
>   
>   struct kvm_vm_stat {
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index b655a7d82bf0..ff6d8a2b511c 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -568,6 +568,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_S390_VCPU_RESETS:
>   	case KVM_CAP_SET_GUEST_DEBUG:
>   	case KVM_CAP_S390_DIAG318:
> +	case KVM_CAP_S390_CPU_TOPOLOGY:

I would have expected instead

r = test_facility(11);
break

...

>   		r = 1;
>   		break;
>   	case KVM_CAP_SET_GUEST_DEBUG2:
> @@ -819,6 +820,23 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>   		icpt_operexc_on_all_vcpus(kvm);
>   		r = 0;
>   		break;
> +	case KVM_CAP_S390_CPU_TOPOLOGY:
> +		mutex_lock(&kvm->lock);
> +		if (kvm->created_vcpus) {
> +			r = -EBUSY;
> +		} else {

...
} else if (test_facility(11)) {
	set_kvm_facility(kvm->arch.model.fac_mask, 11);
	set_kvm_facility(kvm->arch.model.fac_list, 11);
	r = 0;
} else {
	r = -EINVAL;
}

similar to how we handle KVM_CAP_S390_VECTOR_REGISTERS.

But I assume you want to be able to support hosts without ECB_PTF, correct?


> +			set_kvm_facility(kvm->arch.model.fac_mask, 11);
> +			set_kvm_facility(kvm->arch.model.fac_list, 11);
> +			r = 0;
> +		}
> +		mutex_unlock(&kvm->lock);
> +		VM_EVENT(kvm, 3, "ENABLE: CPU TOPOLOGY %s",
> +			 r ? "(not available)" : "(success)");
> +		break;
> +
> +		r = -EINVAL;
> +		break;

^ dead code

[...]

>   }
>   
>   void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>   {
> +	vcpu->arch.prev_cpu = vcpu->cpu;
>   	vcpu->cpu = -1;
>   	if (vcpu->arch.cputm_enabled && !is_vcpu_idle(vcpu))
>   		__stop_cpu_timer_accounting(vcpu);
> @@ -3198,6 +3239,11 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
>   		vcpu->arch.sie_block->ecb |= ECB_HOSTPROTINT;
>   	if (test_kvm_facility(vcpu->kvm, 9))
>   		vcpu->arch.sie_block->ecb |= ECB_SRSI;
> +
> +	/* PTF needs both host and guest facilities to enable interpretation */
> +	if (test_kvm_facility(vcpu->kvm, 11) && test_facility(11))
> +		vcpu->arch.sie_block->ecb |= ECB_PTF;

Here you say we need both ...

> +
>   	if (test_kvm_facility(vcpu->kvm, 73))
>   		vcpu->arch.sie_block->ecb |= ECB_TE;
>   
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index 4002a24bc43a..50d67190bf65 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -503,6 +503,9 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>   	/* Host-protection-interruption introduced with ESOP */
>   	if (test_kvm_cpu_feat(vcpu->kvm, KVM_S390_VM_CPU_FEAT_ESOP))
>   		scb_s->ecb |= scb_o->ecb & ECB_HOSTPROTINT;
> +	/* CPU Topology */
> +	if (test_kvm_facility(vcpu->kvm, 11))
> +		scb_s->ecb |= scb_o->ecb & ECB_PTF;

but here you don't check?

>   	/* transactional execution */
>   	if (test_kvm_facility(vcpu->kvm, 73) && wants_tx) {
>   		/* remap the prefix is tx is toggled on */
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index d9e4aabcb31a..081ce0cd44b9 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1112,6 +1112,7 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_CAP_BINARY_STATS_FD 203
>   #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
>   #define KVM_CAP_ARM_MTE 205
> +#define KVM_CAP_S390_CPU_TOPOLOGY 206
>   

We'll need a Documentation/virt/kvm/api.rst description.

I'm not completely confident that the way we're handling the 
capability+facility is the right approach. It all feels a bit suboptimal.

Except stfl(74) -- STHYI --, we never enable a facility via 
set_kvm_facility() that's not available in the host. And STHYI is 
special such that it is never implemented in hardware.

I'll think about what might be cleaner once I get some more details 
about the interaction with stfl(11) in the hypervisor.

-- 
Thanks,

David / dhildenb

