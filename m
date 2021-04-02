Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22ED352B5D
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 16:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235668AbhDBOUL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 10:20:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40380 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235366AbhDBOUK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Apr 2021 10:20:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617373208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DhzU5KDK0aI/Xg5UxNbhTqEeaUJh7MFKXwoOxCpGjPk=;
        b=Wxfyn60KAjEj83HpI0Ze1GrZ3cU16SAjYPC/9jyKa/QGb1f2jHwUKDltzWkiMAuDasVAvD
        JA3u+mBUd0sfEOq1JiYGXOokRsR5e1UGjsdsLiN3omMb/MeaQ1nl1v6YzLdviY79r7vcOk
        FJGIv/dDqw20xBpPYtzJSWPuxFFSFGk=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-NY3_6fqCORms9YnqZMddBg-1; Fri, 02 Apr 2021 10:20:07 -0400
X-MC-Unique: NY3_6fqCORms9YnqZMddBg-1
Received: by mail-ej1-f71.google.com with SMTP id k16so3199412ejg.9
        for <kvm@vger.kernel.org>; Fri, 02 Apr 2021 07:20:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DhzU5KDK0aI/Xg5UxNbhTqEeaUJh7MFKXwoOxCpGjPk=;
        b=DxbrDpVhzNoRAU0omUYPS1TZPIe9ahgb7Xk405W+hlZ27dyhIIEdnawMw/fkH73s4r
         4FYusnXy/7bGcWXfzEXAvFb7R/61/vxP1XtR7hrnGc9pl1lDNXsjxev1vs18AG6lNjpl
         2QDy8uMm0D//AsK+TqWNnC3fuba2Y/XJ+7a8QfkE6bZ9vuelCTtmxWtDqVcHSx12jP8P
         yt/+urIw9Ip0GRE4RtdP1Y99Z2gCbVw/UupYB/KeeqORWMhdTwHlcHwiJ/gXishm++3n
         uOr4wxAvSt0yRUZ4pSM4aj5Hk1Hx43rA3QKIJ3BrZkLUMLrITNhiSuvHqY08KJOT+Lpe
         Fitg==
X-Gm-Message-State: AOAM5339Dwks0ru9eRqn648G48t0jS4gHXaXopAeOMCy8d7VJC8uKnbt
        7Y+R8zyDEk39e07bFZBfijOqEaH9dezlHbXd+QonIsAXmK+Sv8vIzl5fJDWsYdrhPWGkD7fk8rI
        ABVlPX2kd8JRC
X-Received: by 2002:a17:906:5646:: with SMTP id v6mr14781729ejr.126.1617373205650;
        Fri, 02 Apr 2021 07:20:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwEEjmxjf3oyu5ioibvdHAx8CPMlowj2MYq2EepKI6gPtebDo+StvHt73vBopYWsBpG5EVpuA==
X-Received: by 2002:a17:906:5646:: with SMTP id v6mr14781703ejr.126.1617373205363;
        Fri, 02 Apr 2021 07:20:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a17sm4252990ejf.20.2021.04.02.07.20.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Apr 2021 07:20:03 -0700 (PDT)
Subject: Re: [RFC v2] KVM: x86: Support KVM VMs sharing SEV context
To:     Ashish Kalra <ashish.kalra@amd.com>,
        Nathan Tempelman <natet@google.com>
Cc:     thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        seanjc@google.com, rientjes@google.com, brijesh.singh@amd.com,
        dovmurik@linux.vnet.ibm.com, lersek@redhat.com, jejb@linux.ibm.com,
        frankeh@us.ibm.com
References: <20210316014027.3116119-1-natet@google.com>
 <20210402115813.GB17630@ashkalra_ubuntu_server>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <87bdd3a6-f5eb-91e4-9442-97dfef231640@redhat.com>
Date:   Fri, 2 Apr 2021 16:20:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210402115813.GB17630@ashkalra_ubuntu_server>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/04/21 13:58, Ashish Kalra wrote:
> Hi Nathan,
> 
> Will you be posting a corresponding Qemu patch for this ?

Hi Ashish,

as far as I know IBM is working on QEMU patches for guest-based 
migration helpers.

However, it would be nice to collaborate on the low-level (SEC/PEI) 
firmware patches to detect whether a CPU is part of the primary VM or 
the mirror.  If Google has any OVMF patches already done for that, it 
would be great to combine it with IBM's SEV migration code and merge it 
into upstream OVMF.

Thanks,

Paolo

> Thanks,
> Ashish
> 
> On Tue, Mar 16, 2021 at 01:40:27AM +0000, Nathan Tempelman wrote:
>> Add a capability for userspace to mirror SEV encryption context from
>> one vm to another. On our side, this is intended to support a
>> Migration Helper vCPU, but it can also be used generically to support
>> other in-guest workloads scheduled by the host. The intention is for
>> the primary guest and the mirror to have nearly identical memslots.
>>
>> The primary benefits of this are that:
>> 1) The VMs do not share KVM contexts (think APIC/MSRs/etc), so they
>> can't accidentally clobber each other.
>> 2) The VMs can have different memory-views, which is necessary for post-copy
>> migration (the migration vCPUs on the target need to read and write to
>> pages, when the primary guest would VMEXIT).
>>
>> This does not change the threat model for AMD SEV. Any memory involved
>> is still owned by the primary guest and its initial state is still
>> attested to through the normal SEV_LAUNCH_* flows. If userspace wanted
>> to circumvent SEV, they could achieve the same effect by simply attaching
>> a vCPU to the primary VM.
>> This patch deliberately leaves userspace in charge of the memslots for the
>> mirror, as it already has the power to mess with them in the primary guest.
>>
>> This patch does not support SEV-ES (much less SNP), as it does not
>> handle handing off attested VMSAs to the mirror.
>>
>> For additional context, we need a Migration Helper because SEV PSP migration
>> is far too slow for our live migration on its own. Using an in-guest
>> migrator lets us speed this up significantly.
>>
>> Signed-off-by: Nathan Tempelman <natet@google.com>
>> ---
>>   Documentation/virt/kvm/api.rst  | 17 +++++++
>>   arch/x86/include/asm/kvm_host.h |  1 +
>>   arch/x86/kvm/svm/sev.c          | 88 +++++++++++++++++++++++++++++++++
>>   arch/x86/kvm/svm/svm.c          |  2 +
>>   arch/x86/kvm/svm/svm.h          |  2 +
>>   arch/x86/kvm/x86.c              |  7 ++-
>>   include/linux/kvm_host.h        |  1 +
>>   include/uapi/linux/kvm.h        |  1 +
>>   virt/kvm/kvm_main.c             |  6 +++
>>   9 files changed, 124 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index 482508ec7cc4..332ba8b5b6f4 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -6213,6 +6213,23 @@ the bus lock vm exit can be preempted by a higher priority VM exit, the exit
>>   notifications to userspace can be KVM_EXIT_BUS_LOCK or other reasons.
>>   KVM_RUN_BUS_LOCK flag is used to distinguish between them.
>>   
>> +7.23 KVM_CAP_VM_COPY_ENC_CONTEXT_FROM
>> +-------------------------------------
>> +
>> +Architectures: x86 SEV enabled
>> +Type: vm
>> +Parameters: args[0] is the fd of the source vm
>> +Returns: 0 on success; ENOTTY on error
>> +
>> +This capability enables userspace to copy encryption context from the vm
>> +indicated by the fd to the vm this is called on.
>> +
>> +This is intended to support in-guest workloads scheduled by the host. This
>> +allows the in-guest workload to maintain its own NPTs and keeps the two vms
>> +from accidentally clobbering each other with interrupts and the like (separate
>> +APIC/MSRs/etc).
>> +
>> +
>>   8. Other capabilities.
>>   ======================
>>   
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 84499aad01a4..46df415a8e91 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1334,6 +1334,7 @@ struct kvm_x86_ops {
>>   	int (*mem_enc_op)(struct kvm *kvm, void __user *argp);
>>   	int (*mem_enc_reg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
>>   	int (*mem_enc_unreg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
>> +	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
>>   
>>   	int (*get_msr_feature)(struct kvm_msr_entry *entry);
>>   
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 874ea309279f..b2c90c67a0d9 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -66,6 +66,11 @@ static int sev_flush_asids(void)
>>   	return ret;
>>   }
>>   
>> +static inline bool is_mirroring_enc_context(struct kvm *kvm)
>> +{
>> +	return to_kvm_svm(kvm)->sev_info.enc_context_owner;
>> +}
>> +
>>   /* Must be called with the sev_bitmap_lock held */
>>   static bool __sev_recycle_asids(int min_asid, int max_asid)
>>   {
>> @@ -1124,6 +1129,10 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>>   	if (copy_from_user(&sev_cmd, argp, sizeof(struct kvm_sev_cmd)))
>>   		return -EFAULT;
>>   
>> +	/* enc_context_owner handles all memory enc operations */
>> +	if (is_mirroring_enc_context(kvm))
>> +		return -ENOTTY;
>> +
>>   	mutex_lock(&kvm->lock);
>>   
>>   	switch (sev_cmd.id) {
>> @@ -1186,6 +1195,10 @@ int svm_register_enc_region(struct kvm *kvm,
>>   	if (!sev_guest(kvm))
>>   		return -ENOTTY;
>>   
>> +	/* If kvm is mirroring encryption context it isn't responsible for it */
>> +	if (is_mirroring_enc_context(kvm))
>> +		return -ENOTTY;
>> +
>>   	if (range->addr > ULONG_MAX || range->size > ULONG_MAX)
>>   		return -EINVAL;
>>   
>> @@ -1252,6 +1265,10 @@ int svm_unregister_enc_region(struct kvm *kvm,
>>   	struct enc_region *region;
>>   	int ret;
>>   
>> +	/* If kvm is mirroring encryption context it isn't responsible for it */
>> +	if (is_mirroring_enc_context(kvm))
>> +		return -ENOTTY;
>> +
>>   	mutex_lock(&kvm->lock);
>>   
>>   	if (!sev_guest(kvm)) {
>> @@ -1282,6 +1299,71 @@ int svm_unregister_enc_region(struct kvm *kvm,
>>   	return ret;
>>   }
>>   
>> +int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>> +{
>> +	struct file *source_kvm_file;
>> +	struct kvm *source_kvm;
>> +	struct kvm_sev_info *mirror_sev;
>> +	unsigned int asid;
>> +	int ret;
>> +
>> +	source_kvm_file = fget(source_fd);
>> +	if (!file_is_kvm(source_kvm_file)) {
>> +		ret = -EBADF;
>> +		goto e_source_put;
>> +	}
>> +
>> +	source_kvm = source_kvm_file->private_data;
>> +	mutex_lock(&source_kvm->lock);
>> +
>> +	if (!sev_guest(source_kvm)) {
>> +		ret = -ENOTTY;
>> +		goto e_source_unlock;
>> +	}
>> +
>> +	/* Mirrors of mirrors should work, but let's not get silly */
>> +	if (is_mirroring_enc_context(source_kvm) || source_kvm == kvm) {
>> +		ret = -ENOTTY;
>> +		goto e_source_unlock;
>> +	}
>> +
>> +	asid = to_kvm_svm(source_kvm)->sev_info.asid;
>> +
>> +	/*
>> +	 * The mirror kvm holds an enc_context_owner ref so its asid can't
>> +	 * disappear until we're done with it
>> +	 */
>> +	kvm_get_kvm(source_kvm);
>> +
>> +	fput(source_kvm_file);
>> +	mutex_unlock(&source_kvm->lock);
>> +	mutex_lock(&kvm->lock);
>> +
>> +	if (sev_guest(kvm)) {
>> +		ret = -ENOTTY;
>> +		goto e_mirror_unlock;
>> +	}
>> +
>> +	/* Set enc_context_owner and copy its encryption context over */
>> +	mirror_sev = &to_kvm_svm(kvm)->sev_info;
>> +	mirror_sev->enc_context_owner = source_kvm;
>> +	mirror_sev->asid = asid;
>> +	mirror_sev->active = true;
>> +
>> +	mutex_unlock(&kvm->lock);
>> +	return 0;
>> +
>> +e_mirror_unlock:
>> +	mutex_unlock(&kvm->lock);
>> +	kvm_put_kvm(source_kvm);
>> +	return ret;
>> +e_source_unlock:
>> +	mutex_unlock(&source_kvm->lock);
>> +e_source_put:
>> +	fput(source_kvm_file);
>> +	return ret;
>> +}
>> +
>>   void sev_vm_destroy(struct kvm *kvm)
>>   {
>>   	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> @@ -1293,6 +1375,12 @@ void sev_vm_destroy(struct kvm *kvm)
>>   
>>   	mutex_lock(&kvm->lock);
>>   
>> +	/* If this is a mirror_kvm release the enc_context_owner and skip sev cleanup */
>> +	if (is_mirroring_enc_context(kvm)) {
>> +		kvm_put_kvm(sev->enc_context_owner);
>> +		return;
>> +	}
>> +
>>   	/*
>>   	 * Ensure that all guest tagged cache entries are flushed before
>>   	 * releasing the pages back to the system for use. CLFLUSH will
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 42d4710074a6..9ffb2bcf5389 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -4608,6 +4608,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>>   	.mem_enc_reg_region = svm_register_enc_region,
>>   	.mem_enc_unreg_region = svm_unregister_enc_region,
>>   
>> +	.vm_copy_enc_context_from = svm_vm_copy_asid_from,
>> +
>>   	.can_emulate_instruction = svm_can_emulate_instruction,
>>   
>>   	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>> index 39e071fdab0c..779009839f6a 100644
>> --- a/arch/x86/kvm/svm/svm.h
>> +++ b/arch/x86/kvm/svm/svm.h
>> @@ -65,6 +65,7 @@ struct kvm_sev_info {
>>   	unsigned long pages_locked; /* Number of pages locked */
>>   	struct list_head regions_list;  /* List of registered regions */
>>   	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
>> +	struct kvm *enc_context_owner; /* Owner of copied encryption context */
>>   };
>>   
>>   struct kvm_svm {
>> @@ -561,6 +562,7 @@ int svm_register_enc_region(struct kvm *kvm,
>>   			    struct kvm_enc_region *range);
>>   int svm_unregister_enc_region(struct kvm *kvm,
>>   			      struct kvm_enc_region *range);
>> +int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd);
>>   void pre_sev_run(struct vcpu_svm *svm, int cpu);
>>   void __init sev_hardware_setup(void);
>>   void sev_hardware_teardown(void);
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 3fa140383f5d..343cb05c2a24 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -3753,6 +3753,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>   	case KVM_CAP_X86_USER_SPACE_MSR:
>>   	case KVM_CAP_X86_MSR_FILTER:
>>   	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
>> +	case KVM_CAP_VM_COPY_ENC_CONTEXT_FROM:
>>   		r = 1;
>>   		break;
>>   	case KVM_CAP_XEN_HVM:
>> @@ -4649,7 +4650,6 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
>>   			kvm_update_pv_runtime(vcpu);
>>   
>>   		return 0;
>> -
>>   	default:
>>   		return -EINVAL;
>>   	}
>> @@ -5321,6 +5321,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>>   			kvm->arch.bus_lock_detection_enabled = true;
>>   		r = 0;
>>   		break;
>> +	case KVM_CAP_VM_COPY_ENC_CONTEXT_FROM:
>> +		r = -ENOTTY;
>> +		if (kvm_x86_ops.vm_copy_enc_context_from)
>> +			r = kvm_x86_ops.vm_copy_enc_context_from(kvm, cap->args[0]);
>> +		return r;
>>   	default:
>>   		r = -EINVAL;
>>   		break;
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index e126ebda36d0..dc5a81115df7 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -637,6 +637,7 @@ void kvm_exit(void);
>>   
>>   void kvm_get_kvm(struct kvm *kvm);
>>   void kvm_put_kvm(struct kvm *kvm);
>> +bool file_is_kvm(struct file *file);
>>   void kvm_put_kvm_no_destroy(struct kvm *kvm);
>>   
>>   static inline struct kvm_memslots *__kvm_memslots(struct kvm *kvm, int as_id)
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 63f8f6e95648..9dc00f9baf54 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1077,6 +1077,7 @@ struct kvm_ppc_resize_hpt {
>>   #define KVM_CAP_SYS_HYPERV_CPUID 191
>>   #define KVM_CAP_DIRTY_LOG_RING 192
>>   #define KVM_CAP_X86_BUS_LOCK_EXIT 193
>> +#define KVM_CAP_VM_COPY_ENC_CONTEXT_FROM 194
>>   
>>   #ifdef KVM_CAP_IRQ_ROUTING
>>   
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 001b9de4e727..5baf82b01e0c 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -4041,6 +4041,12 @@ static struct file_operations kvm_vm_fops = {
>>   	KVM_COMPAT(kvm_vm_compat_ioctl),
>>   };
>>   
>> +bool file_is_kvm(struct file *file)
>> +{
>> +	return file && file->f_op == &kvm_vm_fops;
>> +}
>> +EXPORT_SYMBOL_GPL(file_is_kvm);
>> +
>>   static int kvm_dev_ioctl_create_vm(unsigned long type)
>>   {
>>   	int r;
>> -- 
>> 2.31.0.rc2.261.g7f71774620-goog
>>
> 

