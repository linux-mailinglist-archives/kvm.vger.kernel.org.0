Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0743FC953
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 16:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbhHaOEq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 10:04:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48719 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232699AbhHaOEp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Aug 2021 10:04:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630418629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KUyHspkViTFXqWZ8iiKYwCb9orAa774mgXoDDK5r4uw=;
        b=WqsQDup4oIkAwSVcrxyFkyhstktgWS3P4i3EQFKkevMUU03f+E5qOuRz4ZGCgTEAsGAP2Z
        jm29Dn1dliulugZvKqpYlRvF9/wVrvn4r72THwudH7fzT1UtdKPZIuDi/VUFP88bn05zNi
        kPQZUg8jef3sI3Ilcwh7tchl+BwE5+Q=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-ABE0rkh8NrmlFpyYFj9qIg-1; Tue, 31 Aug 2021 10:03:48 -0400
X-MC-Unique: ABE0rkh8NrmlFpyYFj9qIg-1
Received: by mail-wm1-f72.google.com with SMTP id r4-20020a1c4404000000b002e728beb9fbso1286740wma.9
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 07:03:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=KUyHspkViTFXqWZ8iiKYwCb9orAa774mgXoDDK5r4uw=;
        b=oExmRfqUrTMsUJv6Ncj8UBEmn+k/CUbXU339pHwAHpnBJqE1ePJ2HitI5AiStfLc4F
         gVZ9XOSZmfN038XOMOWr2Olip/crk4CIyEVlold5cweLDZmwMzb9sq6jxYRFpaS2OZP+
         WuUAA3l+Wp5HPuYQsFdi8nq5kOex6XAIvmuygZiEPS+DDpamKwaB7bmW1c9pxe88v0KI
         yR9nbEhLjRJqzjtpHnS7yt66GdDKvILtJJPTm7r8m6hstfO4ggb50iIQo+9l6xJkGQJC
         5MhSU8wWtaLWE+VUxAKC+1NZZ+haNun9Zmaht7We9OLFxpo2gGdWl0Homg878LniqZDu
         1qVw==
X-Gm-Message-State: AOAM530/L9yNieBBxbaAGrSKS1sjxbBt+WUKr9SfZEZlyNmPzdvSnvzW
        XFCWeIrgSmiCU92OScxepdoWXtHO/VhwTimD6K55FpTSS77814KLH4bt67oCwdp1b5DiE1fhCE7
        TaZVQJLUhBx3P
X-Received: by 2002:a7b:cb44:: with SMTP id v4mr4482988wmj.169.1630418626900;
        Tue, 31 Aug 2021 07:03:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQxgsAwqewPXBe3d+wAvlhesHNv1NlxeMEIDzWug8SQcboJNjWJ6G41AqWjlU9NYpwI5Aafw==
X-Received: by 2002:a7b:cb44:: with SMTP id v4mr4482961wmj.169.1630418626624;
        Tue, 31 Aug 2021 07:03:46 -0700 (PDT)
Received: from [192.168.3.132] (p4ff23bf5.dip0.t-ipconnect.de. [79.242.59.245])
        by smtp.gmail.com with ESMTPSA id a10sm2518234wmj.44.2021.08.31.07.03.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 07:03:46 -0700 (PDT)
Subject: Re: [PATCH v3 2/3] s390x: KVM: Implementation of Multiprocessor
 Topology-Change-Report
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com
References: <1627979206-32663-1-git-send-email-pmorel@linux.ibm.com>
 <1627979206-32663-3-git-send-email-pmorel@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <4d462f11-2990-6799-75e5-add0c39f9563@redhat.com>
Date:   Tue, 31 Aug 2021 16:03:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1627979206-32663-3-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
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
> ---
>   arch/s390/include/asm/kvm_host.h | 14 +++++++---
>   arch/s390/kvm/kvm-s390.c         | 48 +++++++++++++++++++++++++++++++-
>   arch/s390/kvm/vsie.c             |  3 ++
>   include/uapi/linux/kvm.h         |  1 +
>   4 files changed, 61 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 9b4473f76e56..b7effdc96a7a 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -95,15 +95,19 @@ struct bsca_block {
>   	union ipte_control ipte_control;
>   	__u64	reserved[5];
>   	__u64	mcn;
> -	__u64	reserved2;
> +#define ESCA_UTILITY_MTCR	0x8000
> +	__u16	utility;
> +	__u8	reserved2[6];
>   	struct bsca_entry cpu[KVM_S390_BSCA_CPU_SLOTS];
>   };
>   
>   struct esca_block {
>   	union ipte_control ipte_control;
> -	__u64   reserved1[7];
> +	__u64   reserved1[6];
> +	__u16	utility;
> +	__u8	reserved2[6];
>   	__u64   mcn[4];
> -	__u64   reserved2[20];
> +	__u64   reserved3[20];
>   	struct esca_entry cpu[KVM_S390_ESCA_CPU_SLOTS];
>   };
>   
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
> +
>   	default:
>   		r = -EINVAL;
>   		break;
> @@ -3067,18 +3085,41 @@ __u64 kvm_s390_get_cpu_timer(struct kvm_vcpu *vcpu)
>   	return value;
>   }
>   
> -void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> +static void kvm_s390_set_mtcr(struct kvm_vcpu *vcpu)
>   {
> +	struct esca_block *esca = vcpu->kvm->arch.sca;
> +
> +	if (vcpu->arch.sie_block->ecb & ECB_PTF) {
> +		ipte_lock(vcpu);
> +		WRITE_ONCE(esca->utility, ESCA_UTILITY_MTCR);
> +		ipte_unlock(vcpu);
> +	}
> +}
>   
> +void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> +{
>   	gmap_enable(vcpu->arch.enabled_gmap);
>   	kvm_s390_set_cpuflags(vcpu, CPUSTAT_RUNNING);
>   	if (vcpu->arch.cputm_enabled && !is_vcpu_idle(vcpu))
>   		__start_cpu_timer_accounting(vcpu);
>   	vcpu->cpu = cpu;
> +
> +	/*
> +	 * With PTF interpretation the guest will be aware of topology
> +	 * change by the Multiprocessor Topology-Change-Report is pending.
> +	 * Check for reasons to make the MTCR pending and make it pending.
> +	 */
> +	if ((vcpu->arch.sie_block->ecb & ECB_PTF) &&
> +	    cpu != vcpu->arch.prev_cpu) {
> +		if (cpu_topology[cpu].socket_id !=
> +		    cpu_topology[vcpu->arch.prev_cpu].socket_id)
> +			kvm_s390_set_mtcr(vcpu);
> +	}
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


Again, doesn't test_kvm_facility(vcpu->kvm, 11) imply that we have host 
support by checking fac_mask?

-- 
Thanks,

David / dhildenb

