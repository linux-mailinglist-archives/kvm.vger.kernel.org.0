Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 277B46E7B63
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 15:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231971AbjDSN5m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 09:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbjDSN5U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 09:57:20 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E3959D5
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:57:17 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-63b78b344d5so2319506b3a.1
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681912636; x=1684504636;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u7oEQgq/N7m5uMfXKoD8pt9QoV4B/N16ESs+v3DEmZM=;
        b=W+cnHA13BWowN0PpxsgVhIwq+MMW1zvcCcBUoMAeS+sZ1H77rpJ/TM2DCd5bhOTNwp
         ynhaMGA0aRyv8Y0Li1+MF87fPvNKsEwkMY/Lzqb2t6CaaTYVdYYK7ArYZmzBK3Blxvzd
         dQBoyInLWtIgQRHaqnXAcFItxBWH4H/XwLrSgwtou95phMVunOu4pHEHCcVqDVtrmAhS
         INcCA1HhY7SqFIweW8sBWYlLLuA+1eMS49k/g78QYEhoZONY64bi1VJRlQlt8EbKTZK+
         mcrqoKxZxYX5CJeCwaamGb7h0FJzAsTgeCTO8VhIfSdJEceG73s5RCFw+0xicPMHOzbf
         HQQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681912636; x=1684504636;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u7oEQgq/N7m5uMfXKoD8pt9QoV4B/N16ESs+v3DEmZM=;
        b=PTUmGDF/kKr9co0+tufW/t6vmFdnD8LYviqj0+5V0Yd0ejbbl5826rG13+xP7CmFVl
         xGsLJvuLLytKotW6j6Asbn6Gl5J1VuppLr0Q09Eme+NaIL9+T/IvR6JurwBp03K+/mnk
         FD+UY0iwK1BT9wrmRUINt5ZyeniuQGw0dk3T82kpjKLJKl2pfYCEYlILYGo4Pprbba5N
         8WfjHu5GHrBLhqxP9LIGhTUo918CLhSHhGvr3SGfE6zjQxCFPC8DroOSUvXd3yeSxI1k
         TMgI4j2SfUS029IfnYCXkznB0KzMBoGprFvXBlee8sq/q911k/915pN3rd1wRdVBWTYJ
         Tkxw==
X-Gm-Message-State: AAQBX9dVWHdTAIj+rFGIwwZTCPghedh4feguW6eh66+Hr5oztGBUhBy5
        ym/igm3FvlrRgYhUzzL0XGc=
X-Google-Smtp-Source: AKy350aPNtDY+P1RjfZPKNSooNYyjTs9DHxBOkVD4MYIWvKGPM8tkOablbaPzsUYz6GH2aCKQRqegg==
X-Received: by 2002:a05:6a00:2d1e:b0:63b:23b0:a72e with SMTP id fa30-20020a056a002d1e00b0063b23b0a72emr4357016pfb.15.1681912636339;
        Wed, 19 Apr 2023 06:57:16 -0700 (PDT)
Received: from [172.27.232.10] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id n17-20020aa78a51000000b0062dcf5c01f9sm11134940pfa.36.2023.04.19.06.57.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 06:57:15 -0700 (PDT)
Message-ID: <a518e669-c758-57c8-3ba9-b4844e2cb79d@gmail.com>
Date:   Wed, 19 Apr 2023 21:57:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3 05/22] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
Content-Language: en-US
To:     Anish Moorthy <amoorthy@google.com>, pbonzini@redhat.com,
        maz@kernel.org
Cc:     oliver.upton@linux.dev, seanjc@google.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
References: <20230412213510.1220557-1-amoorthy@google.com>
 <20230412213510.1220557-6-amoorthy@google.com>
From:   Hoo Robert <robert.hoo.linux@gmail.com>
In-Reply-To: <20230412213510.1220557-6-amoorthy@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/13/2023 5:34 AM, Anish Moorthy wrote:
> KVM_CAP_MEMORY_FAULT_INFO allows kvm_run to return useful information
> besides a return value of -1 and errno of EFAULT when a vCPU fails an
> access to guest memory.
> 
> Add documentation, updates to the KVM headers, and a helper function
> (kvm_populate_efault_info) for implementing the capability.

kvm_populate_efault_info(), function name.
> 
> Besides simply filling the run struct, kvm_populate_efault_info takes

Ditto

> two safety measures
> 
>    a. It tries to prevent concurrent fills on a single vCPU run struct
>       by checking that the run struct being modified corresponds to the
>       currently loaded vCPU.
>    b. It tries to avoid filling an already-populated run struct by
>       checking whether the exit reason has been modified since entry
>       into KVM_RUN.
> 
> Finally, mark KVM_CAP_MEMORY_FAULT_INFO as available on arm64 and x86,
> even though EFAULT annotation are currently totally absent. Picking a
> point to declare the implementation "done" is difficult because
> 
>    1. Annotations will be performed incrementally in subsequent commits
>       across both core and arch-specific KVM.
>    2. The initial series will very likely miss some cases which need
>       annotation. Although these omissions are to be fixed in the future,
>       userspace thus still needs to expect and be able to handle
>       unannotated EFAULTs.
> 
> Given these qualifications, just marking it available here seems the
> least arbitrary thing to do.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>   Documentation/virt/kvm/api.rst | 35 +++++++++++++++++++++++++++
>   arch/arm64/kvm/arm.c           |  1 +
>   arch/x86/kvm/x86.c             |  1 +
>   include/linux/kvm_host.h       | 12 ++++++++++
>   include/uapi/linux/kvm.h       | 16 +++++++++++++
>   tools/include/uapi/linux/kvm.h | 11 +++++++++
>   virt/kvm/kvm_main.c            | 44 ++++++++++++++++++++++++++++++++++
>   7 files changed, 120 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 48fad65568227..f174f43c38d45 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6637,6 +6637,18 @@ array field represents return values. The userspace should update the return
>   values of SBI call before resuming the VCPU. For more details on RISC-V SBI
>   spec refer, https://github.com/riscv/riscv-sbi-doc.
>   
> +::
> +
> +		/* KVM_EXIT_MEMORY_FAULT */
> +		struct {
> +			__u64 flags;
> +			__u64 gpa;
> +			__u64 len; /* in bytes */
> +		} memory_fault;
> +
> +Indicates a vCPU memory fault on the guest physical address range
> +[gpa, gpa + len). See KVM_CAP_MEMORY_FAULT_INFO for more details.
> +
>   ::
>   
>       /* KVM_EXIT_NOTIFY */
> @@ -7670,6 +7682,29 @@ This capability is aimed to mitigate the threat that malicious VMs can
>   cause CPU stuck (due to event windows don't open up) and make the CPU
>   unavailable to host or other VMs.
>   
> +7.34 KVM_CAP_MEMORY_FAULT_INFO
> +------------------------------
> +
> +:Architectures: x86, arm64
> +:Parameters: args[0] - KVM_MEMORY_FAULT_INFO_ENABLE|DISABLE to enable/disable
> +             the capability.
> +:Returns: 0 on success, or -EINVAL if unsupported or invalid args[0].
> +
> +When enabled, EFAULTs "returned" by KVM_RUN in response to failed vCPU guest
> +memory accesses may be annotated with additional information. When KVM_RUN
> +returns an error with errno=EFAULT, userspace may check the exit reason: if it
> +is KVM_EXIT_MEMORY_FAULT, userspace is then permitted to read the 'memory_fault'
> +member of the run struct.
> +
> +The 'gpa' and 'len' (in bytes) fields describe the range of guest
> +physical memory to which access failed, i.e. [gpa, gpa + len). 'flags' is
> +currently always zero.
> +
> +NOTE: The implementation of this capability is incomplete. Even with it enabled,
> +userspace may receive "bare" EFAULTs (i.e. exit reason !=
> +KVM_EXIT_MEMORY_FAULT) from KVM_RUN. These should be considered bugs and
> +reported to the maintainers.
> +
>   8. Other capabilities.
>   ======================
>   
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index a43e1cb3b7e97..a932346b59f61 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -220,6 +220,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_VCPU_ATTRIBUTES:
>   	case KVM_CAP_PTP_KVM:
>   	case KVM_CAP_ARM_SYSTEM_SUSPEND:
> +	case KVM_CAP_MEMORY_FAULT_INFO:
>   		r = 1;
>   		break;
>   	case KVM_CAP_SET_GUEST_DEBUG2:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ca73eb066af81..0925678e741de 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4432,6 +4432,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_VAPIC:
>   	case KVM_CAP_ENABLE_CAP:
>   	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
> +	case KVM_CAP_MEMORY_FAULT_INFO:
>   		r = 1;
>   		break;
>   	case KVM_CAP_EXIT_HYPERCALL:
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 90edc16d37e59..776f9713f3921 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -805,6 +805,8 @@ struct kvm {
>   	struct notifier_block pm_notifier;
>   #endif
>   	char stats_id[KVM_STATS_NAME_SIZE];
> +
> +	bool fill_efault_info;
>   };
>   
>   #define kvm_err(fmt, ...) \
> @@ -2277,4 +2279,14 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
>   /* Max number of entries allowed for each kvm dirty ring */
>   #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
>   
> +/*
> + * Attempts to set the run struct's exit reason to KVM_EXIT_MEMORY_FAULT and
> + * populate the memory_fault field with the given information.
> + *
> + * Does nothing if KVM_CAP_MEMORY_FAULT_INFO is not enabled. WARNs and does
> + * nothing if the exit reason is not KVM_EXIT_UNKNOWN, or if 'vcpu' is not
> + * the current running vcpu.
> + */
> +inline void kvm_populate_efault_info(struct kvm_vcpu *vcpu,
> +					uint64_t gpa, uint64_t len);
>   #endif
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 4003a166328cc..bc73e8381a2bb 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -264,6 +264,7 @@ struct kvm_xen_exit {
>   #define KVM_EXIT_RISCV_SBI        35
>   #define KVM_EXIT_RISCV_CSR        36
>   #define KVM_EXIT_NOTIFY           37
> +#define KVM_EXIT_MEMORY_FAULT     38

struct exit_reason[] string for KVM_EXIT_MEMORY_FAULT can be added as
well.
>   
>   /* For KVM_EXIT_INTERNAL_ERROR */
>   /* Emulate instruction failed. */
> @@ -505,6 +506,16 @@ struct kvm_run {
>   #define KVM_NOTIFY_CONTEXT_INVALID	(1 << 0)
>   			__u32 flags;
>   		} notify;
> +		/* KVM_EXIT_MEMORY_FAULT */
> +		struct {
> +			/*
> +			 * Indicates a memory fault on the guest physical address range
> +			 * [gpa, gpa + len). flags is always zero for now.
> +			 */
> +			__u64 flags;
> +			__u64 gpa;
> +			__u64 len; /* in bytes */
> +		} memory_fault;
>   		/* Fix the size of the union. */
>   		char padding[256];
>   	};
> @@ -1184,6 +1195,7 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
>   #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
>   #define KVM_CAP_PMU_EVENT_MASKED_EVENTS 226
> +#define KVM_CAP_MEMORY_FAULT_INFO 227
>   
>   #ifdef KVM_CAP_IRQ_ROUTING
>   
> @@ -2237,4 +2249,8 @@ struct kvm_s390_zpci_op {
>   /* flags for kvm_s390_zpci_op->u.reg_aen.flags */
>   #define KVM_S390_ZPCIOP_REGAEN_HOST    (1 << 0)
>   
> +/* flags for KVM_CAP_MEMORY_FAULT_INFO */
> +#define KVM_MEMORY_FAULT_INFO_DISABLE  0
> +#define KVM_MEMORY_FAULT_INFO_ENABLE   1
> +
>   #endif /* __LINUX_KVM_H */
> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
> index 4003a166328cc..5c57796364d65 100644
> --- a/tools/include/uapi/linux/kvm.h
> +++ b/tools/include/uapi/linux/kvm.h
> @@ -264,6 +264,7 @@ struct kvm_xen_exit {
>   #define KVM_EXIT_RISCV_SBI        35
>   #define KVM_EXIT_RISCV_CSR        36
>   #define KVM_EXIT_NOTIFY           37
> +#define KVM_EXIT_MEMORY_FAULT     38
>   
>   /* For KVM_EXIT_INTERNAL_ERROR */
>   /* Emulate instruction failed. */
> @@ -505,6 +506,16 @@ struct kvm_run {
>   #define KVM_NOTIFY_CONTEXT_INVALID	(1 << 0)
>   			__u32 flags;
>   		} notify;
> +		/* KVM_EXIT_MEMORY_FAULT */
> +		struct {
> +			/*
> +			 * Indicates a memory fault on the guest physical address range
> +			 * [gpa, gpa + len). flags is always zero for now.
> +			 */
> +			__u64 flags;
> +			__u64 gpa;
> +			__u64 len; /* in bytes */
> +		} memory_fault;
>   		/* Fix the size of the union. */
>   		char padding[256];
>   	};
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index cf7d3de6f3689..f3effc93cbef3 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1142,6 +1142,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
>   	spin_lock_init(&kvm->mn_invalidate_lock);
>   	rcuwait_init(&kvm->mn_memslots_update_rcuwait);
>   	xa_init(&kvm->vcpu_array);
> +	kvm->fill_efault_info = false;
>   
>   	INIT_LIST_HEAD(&kvm->gpc_list);
>   	spin_lock_init(&kvm->gpc_lock);
> @@ -4096,6 +4097,8 @@ static long kvm_vcpu_ioctl(struct file *filp,
>   			put_pid(oldpid);
>   		}
>   		r = kvm_arch_vcpu_ioctl_run(vcpu);
> +		WARN_ON_ONCE(r == -EFAULT &&
> +					 vcpu->run->exit_reason != KVM_EXIT_MEMORY_FAULT);
>   		trace_kvm_userspace_exit(vcpu->run->exit_reason, r);
>   		break;
>   	}
> @@ -4672,6 +4675,15 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
>   
>   		return r;
>   	}
> +	case KVM_CAP_MEMORY_FAULT_INFO: {
> +		if (!kvm_vm_ioctl_check_extension_generic(kvm, cap->cap)
> +			|| (cap->args[0] != KVM_MEMORY_FAULT_INFO_ENABLE
> +				&& cap->args[0] != KVM_MEMORY_FAULT_INFO_DISABLE)) {
> +			return -EINVAL;
> +		}
> +		kvm->fill_efault_info = cap->args[0] == KVM_MEMORY_FAULT_INFO_ENABLE;
> +		return 0;
> +	}
>   	default:
>   		return kvm_vm_ioctl_enable_cap(kvm, cap);
>   	}
> @@ -6173,3 +6185,35 @@ int kvm_vm_create_worker_thread(struct kvm *kvm, kvm_vm_thread_fn_t thread_fn,
>   
>   	return init_context.err;
>   }
> +
> +inline void kvm_populate_efault_info(struct kvm_vcpu *vcpu,
> +					uint64_t gpa, uint64_t len)
> +{
> +	if (!vcpu->kvm->fill_efault_info)
> +		return;
> +
> +	preempt_disable();
> +	/*
> +	 * Ensure the this vCPU isn't modifying another vCPU's run struct, which
> +	 * would open the door for races between concurrent calls to this
> +	 * function.
> +	 */
> +	if (WARN_ON_ONCE(vcpu != __this_cpu_read(kvm_running_vcpu)))
> +		goto out;
> +	/*
> +	 * Try not to overwrite an already-populated run struct.
> +	 * This isn't a perfect solution, as there's no guarantee that the exit
> +	 * reason is set before the run struct is populated, but it should prevent
> +	 * at least some bugs.
> +	 */
> +	else if (WARN_ON_ONCE(vcpu->run->exit_reason != KVM_EXIT_UNKNOWN))
> +		goto out;
> +
> +	vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
> +	vcpu->run->memory_fault.gpa = gpa;
> +	vcpu->run->memory_fault.len = len;
> +	vcpu->run->memory_fault.flags = 0;
> +
> +out:
> +	preempt_enable();
> +}

