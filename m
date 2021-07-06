Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F5D3BD85B
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbhGFOiW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 10:38:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25389 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232319AbhGFOiW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 10:38:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625582143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L/tN+7auaRQ4j3gGQQVbtbHULR6FDj/ZnvpQ9ApaAA0=;
        b=W0FIR+7Q9orp5yr/LGxeMQeGHX/uxqGPpx4Fish2uloE2oErnJ7Rpy0kaD/L2gaB36IS8l
        xA+ex1esqg/7lWRrgzVYqB0lsWOqhF0MqnEkbxO/O8hExvhMOq7k68oKXJBR4gb4anRZ1T
        WE3pC5f2DtyagdIIk+/seTarQzQIZWo=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-uoXdZwt7OKyp59XqVVf3aQ-1; Tue, 06 Jul 2021 09:45:13 -0400
X-MC-Unique: uoXdZwt7OKyp59XqVVf3aQ-1
Received: by mail-ed1-f69.google.com with SMTP id y17-20020a0564023591b02903951740fab5so10901825edc.23
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 06:45:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L/tN+7auaRQ4j3gGQQVbtbHULR6FDj/ZnvpQ9ApaAA0=;
        b=H01S7Pu4ycEItyD0yEbOe7gJ9qbPQnN+Hvr0G/Pzy1k4uLkgK0e7M6Ue+90Kmdedc5
         uO6NM41ffxNvQv3ZgsKvRaArIpk01ajcCRbHpWT/c1v/l7Q2392eK/FkKT0Sl8uNizdg
         O5b5K34xV3okAo1b7OIhr+ypATYAOcC/QQVV/7oeE64Tr0juE/oJIoOi02+9hxMaO8WI
         VKZ4eeLQU9XARg4mVHclJxbknhmBvX0eV/Ar+zkro7gyylwz0OwZm0bb9x8Vpn5Gtwy5
         WwpLCJeDJYgwxDtLDG0zl3jhOO6TKVCjMzf6AFIOUeXIKAJwMLp/y2SKNS7TAjiGCTfj
         al+Q==
X-Gm-Message-State: AOAM53371CYNf2QECOo2GDduSvZvxknlESJ6GVzFX4LLbQiaCMQLWgxs
        qN66TFqa2MWhw858wIm5c/+28I7nev6qViA1ZM9/NB9UROWUd7ZO2KQ032Vhk71q3p6bo9+F0+U
        9r0hLt66WAX8m
X-Received: by 2002:a17:906:2844:: with SMTP id s4mr18562481ejc.263.1625579112477;
        Tue, 06 Jul 2021 06:45:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzvP5PJngSaVi8a1gurvl/kRFC/ktOYyC+zcQJS653+dvBM8kyMH/tfEXevqDTM2dmCu5Bpnw==
X-Received: by 2002:a17:906:2844:: with SMTP id s4mr18562439ejc.263.1625579112243;
        Tue, 06 Jul 2021 06:45:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id cz9sm3252955edb.76.2021.07.06.06.45.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 06:45:11 -0700 (PDT)
Subject: Re: [RFC PATCH v2 17/69] KVM: Add infrastructure and macro to mark VM
 as bugged
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
 <3a0998645c328bf0895f1290e61821b70f048549.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1b69fd9b-fbe9-5fbc-83ed-4805e022e17d@redhat.com>
Date:   Tue, 6 Jul 2021 15:45:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <3a0998645c328bf0895f1290e61821b70f048549.1625186503.git.isaku.yamahata@intel.com>
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
>   include/linux/kvm_host.h | 29 ++++++++++++++++++++++++++++-
>   virt/kvm/kvm_main.c      | 10 +++++-----
>   2 files changed, 33 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 8583ed3ff344..09618f8a1338 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -149,6 +149,7 @@ static inline bool is_error_page(struct page *page)
>   #define KVM_REQ_MMU_RELOAD        (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>   #define KVM_REQ_UNBLOCK           2
>   #define KVM_REQ_UNHALT            3
> +#define KVM_REQ_VM_BUGGED         (4 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>   #define KVM_REQUEST_ARCH_BASE     8
>   
>   #define KVM_ARCH_REQ_FLAGS(nr, flags) ({ \
> @@ -585,6 +586,8 @@ struct kvm {
>   	pid_t userspace_pid;
>   	unsigned int max_halt_poll_ns;
>   	u32 dirty_ring_size;
> +
> +	bool vm_bugged;
>   };
>   
>   #define kvm_err(fmt, ...) \
> @@ -613,6 +616,31 @@ struct kvm {
>   #define vcpu_err(vcpu, fmt, ...)					\
>   	kvm_err("vcpu%i " fmt, (vcpu)->vcpu_id, ## __VA_ARGS__)
>   
> +bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
> +static inline void kvm_vm_bugged(struct kvm *kvm)
> +{
> +	kvm->vm_bugged = true;
> +	kvm_make_all_cpus_request(kvm, KVM_REQ_VM_BUGGED);
> +}
> +
> +#define KVM_BUG(cond, kvm, fmt...)				\
> +({								\
> +	int __ret = (cond);					\
> +								\
> +	if (WARN_ONCE(__ret && !(kvm)->vm_bugged, fmt))		\
> +		kvm_vm_bugged(kvm);				\
> +	unlikely(__ret);					\
> +})
> +
> +#define KVM_BUG_ON(cond, kvm)					\
> +({								\
> +	int __ret = (cond);					\
> +								\
> +	if (WARN_ON_ONCE(__ret && !(kvm)->vm_bugged))		\
> +		kvm_vm_bugged(kvm);				\
> +	unlikely(__ret);					\
> +})
> +
>   static inline bool kvm_dirty_log_manual_protect_and_init_set(struct kvm *kvm)
>   {
>   	return !!(kvm->manual_dirty_log_protect & KVM_DIRTY_LOG_INITIALLY_SET);
> @@ -930,7 +958,6 @@ void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
>   bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
>   				 struct kvm_vcpu *except,
>   				 unsigned long *vcpu_bitmap, cpumask_var_t tmp);
> -bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
>   bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
>   				      struct kvm_vcpu *except);
>   bool kvm_make_cpus_request_mask(struct kvm *kvm, unsigned int req,
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 751d1f6890b0..dc752d0bd3ec 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3435,7 +3435,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
>   	struct kvm_fpu *fpu = NULL;
>   	struct kvm_sregs *kvm_sregs = NULL;
>   
> -	if (vcpu->kvm->mm != current->mm)
> +	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_bugged)
>   		return -EIO;
>   
>   	if (unlikely(_IOC_TYPE(ioctl) != KVMIO))
> @@ -3641,7 +3641,7 @@ static long kvm_vcpu_compat_ioctl(struct file *filp,
>   	void __user *argp = compat_ptr(arg);
>   	int r;
>   
> -	if (vcpu->kvm->mm != current->mm)
> +	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_bugged)
>   		return -EIO;
>   
>   	switch (ioctl) {
> @@ -3707,7 +3707,7 @@ static long kvm_device_ioctl(struct file *filp, unsigned int ioctl,
>   {
>   	struct kvm_device *dev = filp->private_data;
>   
> -	if (dev->kvm->mm != current->mm)
> +	if (dev->kvm->mm != current->mm || dev->kvm->vm_bugged)
>   		return -EIO;
>   
>   	switch (ioctl) {
> @@ -3991,7 +3991,7 @@ static long kvm_vm_ioctl(struct file *filp,
>   	void __user *argp = (void __user *)arg;
>   	int r;
>   
> -	if (kvm->mm != current->mm)
> +	if (kvm->mm != current->mm || kvm->vm_bugged)
>   		return -EIO;
>   	switch (ioctl) {
>   	case KVM_CREATE_VCPU:
> @@ -4189,7 +4189,7 @@ static long kvm_vm_compat_ioctl(struct file *filp,
>   	struct kvm *kvm = filp->private_data;
>   	int r;
>   
> -	if (kvm->mm != current->mm)
> +	if (kvm->mm != current->mm || kvm->vm_bugged)
>   		return -EIO;
>   	switch (ioctl) {
>   	case KVM_GET_DIRTY_LOG: {
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

