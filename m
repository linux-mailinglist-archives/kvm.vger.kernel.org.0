Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB13223A380
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 13:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgHCLrp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 07:47:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46843 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726676AbgHCLki (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Aug 2020 07:40:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596454819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Qqsn1OhNVWLL2lwKAjqiVTImuyugyE853WFWtZfmS5w=;
        b=jAKFhBet17SolFpvJ08qTXGneQcGm9vdrlqFyB8iVtHreqIfUwXyoWkKR/D6sB+Rxx0sOu
        Ye8gt8EBctT8/7MPeFH7y38acTkLj99mSPuQ6S+wrKT1XeXJFtKsviU5PlgDB1V+2YWhIo
        7dVcJEKyxamcGPr/1u4j2yGUpEmgozo=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-lAvjHvaSODC7KTW4h3C5sw-1; Mon, 03 Aug 2020 07:38:02 -0400
X-MC-Unique: lAvjHvaSODC7KTW4h3C5sw-1
Received: by mail-ej1-f70.google.com with SMTP id sd23so6246501ejb.14
        for <kvm@vger.kernel.org>; Mon, 03 Aug 2020 04:38:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Qqsn1OhNVWLL2lwKAjqiVTImuyugyE853WFWtZfmS5w=;
        b=UYCKaTw6scIYqhxFwC7o5OGoe2LT/g4tKTdF8jPYV9p1IgvmgTYsKfb/e0vx9yJQYT
         wWWueIgUGdll+7m3e1jEozQur2rhcSV5q6QIF+319tmoauT+mSh32gRgZjhK6qIcF0Kv
         zbSGvqQ2OVsymGc4eLzqzypBP/tygqeVpDIKVEP/dN3lvXUEl0M5A/tCjuEI2lOJxKL8
         XvS79Kun4hREyzRiO/sNAkrEzUUe9Jc65PK4j2Gy2i4ID8JJcGekgRnsLwICXVf22ePN
         qvV3te0b87kQxkqgbKD02iAlnqGRa0/ZsE36oWxbQ3siXXSVD/UpWvokxAePKwmvJx9y
         VI4g==
X-Gm-Message-State: AOAM530pccA+OtHYqgB1miqY1LQzwVtde/9zH4AcFZ7lcVL+9FZQHGyX
        wv/HZyld2P5WazkKHCf8PyJdPfBJlylS0GDVacQY2fEt8Z0J1LypQzRwMav/JZEQjlXpKYSnaVc
        sQ/RFuEmTph+j
X-Received: by 2002:a17:906:dd5:: with SMTP id p21mr17197359eji.416.1596454680808;
        Mon, 03 Aug 2020 04:38:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxc9QE5JAqE7wMoDynSJB83QTt7cbJPuJ+rzioebbbacZGy7G8PM1RIUsH+AjUFe8rkh+RV/Q==
X-Received: by 2002:a17:906:dd5:: with SMTP id p21mr17197327eji.416.1596454680386;
        Mon, 03 Aug 2020 04:38:00 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u4sm8728328edy.18.2020.08.03.04.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 04:37:59 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Alexander Graf <graf@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] KVM: x86: Introduce allow list for MSR emulation
In-Reply-To: <20200731214947.16885-3-graf@amazon.com>
References: <20200731214947.16885-1-graf@amazon.com> <20200731214947.16885-3-graf@amazon.com>
Date:   Mon, 03 Aug 2020 13:37:58 +0200
Message-ID: <87zh7cot7t.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alexander Graf <graf@amazon.com> writes:

> It's not desireable to have all MSRs always handled by KVM kernel space. Some
> MSRs would be useful to handle in user space to either emulate behavior (like
> uCode updates) or differentiate whether they are valid based on the CPU model.
>
> To allow user space to specify which MSRs it wants to see handled by KVM,
> this patch introduces a new ioctl to push allow lists of bitmaps into
> KVM. Based on these bitmaps, KVM can then decide whether to reject MSR access.
> With the addition of KVM_CAP_X86_USER_SPACE_MSR it can also deflect the
> denied MSR events to user space to operate on.
>
> If no allowlist is populated, MSR handling stays identical to before.
>
> Signed-off-by: KarimAllah Ahmed <karahmed@amazon.de>
> Signed-off-by: Alexander Graf <graf@amazon.com>
>
> ---
>
> v2 -> v3:
>
>   - document flags for KVM_X86_ADD_MSR_ALLOWLIST
>   - generalize exit path, always unlock when returning
>   - s/KVM_CAP_ADD_MSR_ALLOWLIST/KVM_CAP_X86_MSR_ALLOWLIST/g
>   - Add KVM_X86_CLEAR_MSR_ALLOWLIST
> ---
>  Documentation/virt/kvm/api.rst  |  91 +++++++++++++++++++++
>  arch/x86/include/asm/kvm_host.h |  10 +++
>  arch/x86/include/uapi/asm/kvm.h |  15 ++++
>  arch/x86/kvm/x86.c              | 135 ++++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h        |   5 ++
>  5 files changed, 256 insertions(+)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 79c3e2fdfae4..d611ddd326fc 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -4697,6 +4697,82 @@ KVM_PV_VM_VERIFY
>    Verify the integrity of the unpacked image. Only if this succeeds,
>    KVM is allowed to start protected VCPUs.
>  
> +4.126 KVM_X86_ADD_MSR_ALLOWLIST
> +-------------------------------
> +
> +:Capability: KVM_CAP_X86_MSR_ALLOWLIST
> +:Architectures: x86
> +:Type: vm ioctl
> +:Parameters: struct kvm_msr_allowlist
> +:Returns: 0 on success, < 0 on error
> +
> +::
> +
> +  struct kvm_msr_allowlist {
> +         __u32 flags;
> +         __u32 nmsrs; /* number of msrs in bitmap */
> +         __u32 base;  /* base address for the MSRs bitmap */
> +         __u32 pad;
> +
> +         __u8 bitmap[0]; /* a set bit allows that the operation set in flags */
> +  };
> +
> +flags values:
> +
> +KVM_MSR_ALLOW_READ
> +
> +  Filter read accesses to MSRs using the given bitmap. A 0 in the bitmap
> +  indicates that a read should immediately fail, while a 1 indicates that
> +  a read should be handled by the normal KVM MSR emulation logic.
> +
> +KVM_MSR_ALLOW_WRITE
> +
> +  Filter write accesses to MSRs using the given bitmap. A 0 in the bitmap
> +  indicates that a write should immediately fail, while a 1 indicates that
> +  a write should be handled by the normal KVM MSR emulation logic.
> +
> +KVM_MSR_ALLOW_READ | KVM_MSR_ALLOW_WRITE
> +

Should we probably say what KVM_MSR_ALLOW_READ/KVM_MSR_ALLOW_WRITE are
equal to? (1 << 0, 1 << 1)? 

> +  Filter booth read and write accesses to MSRs using the given bitmap. A 0
> +  in the bitmap indicates that both reads and writes should immediately fail,
> +  while a 1 indicates that reads and writes should be handled by the normal
> +  KVM MSR emulation logic.
> +
> +This ioctl allows user space to define a set of bitmaps of MSR ranges to
> +specify whether a certain MSR access is allowed or not.
> +
> +If this ioctl has never been invoked, MSR accesses are not guarded and the
> +old KVM in-kernel emulation behavior is fully preserved.
> +
> +As soon as the first allow list was specified, only allowed MSR accesses
> +are permitted inside of KVM's MSR code.
> +
> +Each allowlist specifies a range of MSRs to potentially allow access on.
> +The range goes from MSR index [base .. base+nmsrs]. The flags field
> +indicates whether reads, writes or both reads and writes are permitted
> +by setting a 1 bit in the bitmap for the corresponding MSR index.
> +
> +If an MSR access is not permitted through the allow list, it generates a
> +#GP inside the guest. When combined with KVM_CAP_X86_USER_SPACE_MSR, that
> +allows user space to deflect and potentially handle various MSR accesses
> +into user space.
> +
> +4.124 KVM_X86_CLEAR_MSR_ALLOWLIST
> +---------------------------------
> +
> +:Capability: KVM_CAP_X86_MSR_ALLOWLIST
> +:Architectures: x86
> +:Type: vcpu ioctl
> +:Parameters: none
> +:Returns: 0
> +
> +This ioctl resets all internal MSR allow lists. After this call, no allow
> +list is present and the guest would execute as if no allow lists were set,
> +so all MSRs are considered allowed and thus handled by the in-kernel MSR
> +emulation logic.
> +
> +No vCPU may be in running state when calling this ioctl.
> +
>  
>  5. The kvm_run structure
>  ========================
> @@ -6213,3 +6289,18 @@ writes to user space. It can be enabled on a VM level. If enabled, MSR
>  accesses that would usually trigger a #GP by KVM into the guest will
>  instead get bounced to user space through the KVM_EXIT_X86_RDMSR and
>  KVM_EXIT_X86_WRMSR exit notifications.
> +
> +8.25 KVM_CAP_X86_MSR_ALLOWLIST
> +------------------------------
> +
> +:Architectures: x86
> +
> +This capability indicates that KVM supports emulation of only select MSR
> +registers. With this capability exposed, KVM exports two new VM ioctls:
> +KVM_X86_ADD_MSR_ALLOWLIST which user space can call to specify bitmaps of MSR
> +ranges that KVM should emulate in kernel space and KVM_X86_CLEAR_MSR_ALLOWLIST
> +which user space can call to remove all MSR allow lists from the VM context.
> +
> +In combination with KVM_CAP_X86_USER_SPACE_MSR, this allows user space to
> +trap and emulate MSRs that are outside of the scope of KVM as well as
> +limit the attack surface on KVM's MSR emulation code.
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 809eed0dbdea..21358ed4e590 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -904,6 +904,13 @@ struct kvm_hv {
>  	struct kvm_hv_syndbg hv_syndbg;
>  };
>  
> +struct msr_bitmap_range {
> +	u32 flags;
> +	u32 nmsrs;
> +	u32 base;
> +	unsigned long *bitmap;
> +};
> +
>  enum kvm_irqchip_mode {
>  	KVM_IRQCHIP_NONE,
>  	KVM_IRQCHIP_KERNEL,       /* created with KVM_CREATE_IRQCHIP */
> @@ -1008,6 +1015,9 @@ struct kvm_arch {
>  	/* Deflect RDMSR and WRMSR to user space when they trigger a #GP */
>  	bool user_space_msr_enabled;
>  
> +	struct msr_bitmap_range msr_allowlist_ranges[10];
> +	int msr_allowlist_ranges_count;
> +
>  	struct kvm_pmu_event_filter *pmu_event_filter;
>  	struct task_struct *nx_lpage_recovery_thread;
>  };
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 0780f97c1850..c33fb1d72d52 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -192,6 +192,21 @@ struct kvm_msr_list {
>  	__u32 indices[0];
>  };
>  
> +#define KVM_MSR_ALLOW_READ  (1 << 0)
> +#define KVM_MSR_ALLOW_WRITE (1 << 1)
> +
> +/* Maximum size of the of the bitmap in bytes */
> +#define KVM_MSR_ALLOWLIST_MAX_LEN 0x600
> +
> +/* for KVM_X86_ADD_MSR_ALLOWLIST */
> +struct kvm_msr_allowlist {
> +	__u32 flags;
> +	__u32 nmsrs; /* number of msrs in bitmap */
> +	__u32 base;  /* base address for the MSRs bitmap */
> +	__u32 pad;
> +
> +	__u8 bitmap[0]; /* a set bit allows that the operation set in flags */
> +};
>  
>  struct kvm_cpuid_entry {
>  	__u32 function;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 24c72250f6df..7a2be00a3512 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1472,6 +1472,29 @@ void kvm_enable_efer_bits(u64 mask)
>  }
>  EXPORT_SYMBOL_GPL(kvm_enable_efer_bits);
>  
> +static bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
> +{
> +	struct msr_bitmap_range *ranges = vcpu->kvm->arch.msr_allowlist_ranges;
> +	u32 count = vcpu->kvm->arch.msr_allowlist_ranges_count;
> +	u32 i;
> +
> +	/* MSR allowlist not set up, allow everything */
> +	if (!count)
> +		return true;
> +
> +	for (i = 0; i < count; i++) {
> +		u32 start = ranges[i].base;
> +		u32 end = start + ranges[i].nmsrs;
> +		int flags = ranges[i].flags;

u32 flags?

> +		unsigned long *bitmap = ranges[i].bitmap;
> +
> +		if ((index >= start) && (index < end) && (flags & type))
> +			return !!test_bit(index - start, bitmap);
> +	}
> +
> +	return false;
> +}
> +
>  /*
>   * Write @data into the MSR specified by @index.  Select MSR specific fault
>   * checks are bypassed if @host_initiated is %true.
> @@ -1483,6 +1506,9 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
>  {
>  	struct msr_data msr;
>  
> +	if (!host_initiated && !kvm_msr_allowed(vcpu, index, KVM_MSR_ALLOW_WRITE))
> +		return -ENOENT;
> +
>  	switch (index) {
>  	case MSR_FS_BASE:
>  	case MSR_GS_BASE:
> @@ -1528,6 +1554,9 @@ int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
>  	struct msr_data msr;
>  	int ret;
>  
> +	if (!host_initiated && !kvm_msr_allowed(vcpu, index, KVM_MSR_ALLOW_READ))
> +		return -ENOENT;
> +
>  	msr.index = index;
>  	msr.host_initiated = host_initiated;
>  
> @@ -3550,6 +3579,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_EXCEPTION_PAYLOAD:
>  	case KVM_CAP_SET_GUEST_DEBUG:
>  	case KVM_CAP_X86_USER_SPACE_MSR:
> +	case KVM_CAP_X86_MSR_ALLOWLIST:
>  		r = 1;
>  		break;
>  	case KVM_CAP_SYNC_REGS:
> @@ -5075,6 +5105,101 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  	return r;
>  }
>  
> +static bool msr_range_overlaps(struct kvm *kvm, struct msr_bitmap_range *range)
> +{
> +	struct msr_bitmap_range *ranges = kvm->arch.msr_allowlist_ranges;
> +	u32 i, count = kvm->arch.msr_allowlist_ranges_count;
> +
> +	for (i = 0; i < count; i++) {
> +		u32 start = max(range->base, ranges[i].base);
> +		u32 end = min(range->base + range->nmsrs,
> +			      ranges[i].base + ranges[i].nmsrs);
> +
> +		if ((start < end) && (range->flags & ranges[i].flags))
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
> +static int kvm_vm_ioctl_add_msr_allowlist(struct kvm *kvm, void __user *argp)
> +{
> +	struct msr_bitmap_range *ranges = kvm->arch.msr_allowlist_ranges;
> +	struct kvm_msr_allowlist __user *user_msr_allowlist = argp;
> +	struct msr_bitmap_range range;
> +	struct kvm_msr_allowlist kernel_msr_allowlist;
> +	unsigned long *bitmap = NULL;
> +	size_t bitmap_size;
> +	int r = 0;
> +
> +	if (copy_from_user(&kernel_msr_allowlist, user_msr_allowlist,
> +			   sizeof(kernel_msr_allowlist))) {
> +		r = -EFAULT;
> +		goto out;
> +	}
> +
> +	bitmap_size = BITS_TO_LONGS(kernel_msr_allowlist.nmsrs) * sizeof(long);
> +	if (bitmap_size > KVM_MSR_ALLOWLIST_MAX_LEN) {
> +		r = -EINVAL;
> +		goto out;
> +	}
> +
> +	bitmap = memdup_user(user_msr_allowlist->bitmap, bitmap_size);
> +	if (IS_ERR(bitmap)) {
> +		r = PTR_ERR(bitmap);
> +		goto out;
> +	}
> +
> +	range = (struct msr_bitmap_range) {
> +		.flags = kernel_msr_allowlist.flags,
> +		.base = kernel_msr_allowlist.base,
> +		.nmsrs = kernel_msr_allowlist.nmsrs,
> +		.bitmap = bitmap,
> +	};
> +
> +	if (range.flags & ~(KVM_MSR_ALLOW_READ | KVM_MSR_ALLOW_WRITE)) {
> +		r = -EINVAL;
> +		goto out;
> +	}
> +
> +	/*
> +	 * Protect from concurrent calls to this function that could trigger
> +	 * a TOCTOU violation on kvm->arch.msr_allowlist_ranges_count.
> +	 */
> +	mutex_lock(&kvm->lock);
> +
> +	if (kvm->arch.msr_allowlist_ranges_count >=
> +	    ARRAY_SIZE(kvm->arch.msr_allowlist_ranges)) {
> +		r = -E2BIG;
> +		goto out_locked;
> +	}
> +
> +	if (msr_range_overlaps(kvm, &range)) {
> +		r = -EINVAL;
> +		goto out_locked;
> +	}
> +
> +	/* Everything ok, add this range identifier to our global pool */
> +	ranges[kvm->arch.msr_allowlist_ranges_count++] = range;
> +
> +out_locked:
> +	mutex_unlock(&kvm->lock);
> +out:
> +	if (r)
> +		kfree(bitmap);
> +
> +	return r;
> +}
> +
> +static int kvm_vm_ioctl_clear_msr_allowlist(struct kvm *kvm)
> +{
> +	mutex_lock(&kvm->lock);
> +	kvm->arch.msr_allowlist_ranges_count = 0;
> +	mutex_unlock(&kvm->lock);

Are we also supposed to kfree() bitmaps here?

> +
> +	return 0;
> +}
> +
>  long kvm_arch_vm_ioctl(struct file *filp,
>  		       unsigned int ioctl, unsigned long arg)
>  {
> @@ -5381,6 +5506,12 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  	case KVM_SET_PMU_EVENT_FILTER:
>  		r = kvm_vm_ioctl_set_pmu_event_filter(kvm, argp);
>  		break;
> +	case KVM_X86_ADD_MSR_ALLOWLIST:
> +		r = kvm_vm_ioctl_add_msr_allowlist(kvm, argp);
> +		break;
> +	case KVM_X86_CLEAR_MSR_ALLOWLIST:
> +		r = kvm_vm_ioctl_clear_msr_allowlist(kvm);
> +		break;
>  	default:
>  		r = -ENOTTY;
>  	}
> @@ -10086,6 +10217,8 @@ void kvm_arch_pre_destroy_vm(struct kvm *kvm)
>  
>  void kvm_arch_destroy_vm(struct kvm *kvm)
>  {
> +	int i;
> +
>  	if (current->mm == kvm->mm) {
>  		/*
>  		 * Free memory regions allocated on behalf of userspace,
> @@ -10102,6 +10235,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  	}
>  	if (kvm_x86_ops.vm_destroy)
>  		kvm_x86_ops.vm_destroy(kvm);
> +	for (i = 0; i < kvm->arch.msr_allowlist_ranges_count; i++)
> +		kfree(kvm->arch.msr_allowlist_ranges[i].bitmap);
>  	kvm_pic_destroy(kvm);
>  	kvm_ioapic_destroy(kvm);
>  	kvm_free_vcpus(kvm);
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 13fc7de1eb50..4d6bb06e0fb1 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1041,6 +1041,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_HALT_POLL 182
>  #define KVM_CAP_ASYNC_PF_INT 183
>  #define KVM_CAP_X86_USER_SPACE_MSR 184
> +#define KVM_CAP_X86_MSR_ALLOWLIST 185
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> @@ -1542,6 +1543,10 @@ struct kvm_pv_cmd {
>  /* Available with KVM_CAP_S390_PROTECTED */
>  #define KVM_S390_PV_COMMAND		_IOWR(KVMIO, 0xc5, struct kvm_pv_cmd)
>  
> +/* Available with KVM_CAP_X86_MSR_ALLOWLIST */
> +#define KVM_X86_ADD_MSR_ALLOWLIST	_IOW(KVMIO,  0xc6, struct kvm_msr_allowlist)
> +#define KVM_X86_CLEAR_MSR_ALLOWLIST	_IO(KVMIO,  0xc7)
> +
>  /* Secure Encrypted Virtualization command */
>  enum sev_cmd_id {
>  	/* Guest initialization commands */

-- 
Vitaly

