Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08F422F6B6
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 19:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731331AbgG0RdI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 13:33:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34248 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgG0RdI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jul 2020 13:33:08 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06RHLwnO146995;
        Mon, 27 Jul 2020 17:33:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=AviRZ3CWmUEXHBgEkFCCRZ0bkOjgoJh4cxmuMjbPp1Q=;
 b=D2qtB2nVikdrUXXha+Rl630EKK9tfBbCKqVQQAIXavVlAkUKK3WCfQ3YhtytxMlSUo4j
 2TfNsRWQiQeJcTFpOxbq8Oq8uH1/Rm/lnXgfWUurk7Up3CC6P+qk36/PVTPNxErxTk1b
 h+FIYOj8dTE2FuxEQFaESHpB0C02JGtEJzEx5L9LqdPFZCWNeLtZxCGFslsWW/D9By/7
 9219k8DO6nzmCfJB3KNSE+br+KHEKR15OmjStdyeC0leMyewmUMpuHfzK/+7h58lD4Qx
 V5RsKU1RNn/NAfypdHUq1Mxi8MgLxrBfF6X3S9dPrq21xoJnrCwVDiOn9iMFGzU5Q2eV EA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 32hu1j2wcr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 27 Jul 2020 17:33:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06RHMfZ4030866;
        Mon, 27 Jul 2020 17:30:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 32hu5sxtqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jul 2020 17:30:59 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06RHUwYi031722;
        Mon, 27 Jul 2020 17:30:58 GMT
Received: from localhost.localdomain (/10.159.159.78)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Jul 2020 10:30:58 -0700
Subject: Re: [PATCH 1/5 v2] KVM: x86: Change names of some of the kvm_x86_ops
 functions to make them more semantical and readable
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com
References: <1595647598-53208-1-git-send-email-krish.sadhukhan@oracle.com>
 <1595647598-53208-2-git-send-email-krish.sadhukhan@oracle.com>
 <87wo2pmh4l.fsf@vitty.brq.redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <b4d44e3f-33af-c1e8-38b5-49c189cd0a32@oracle.com>
Date:   Mon, 27 Jul 2020 10:30:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <87wo2pmh4l.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007270118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxscore=0 impostorscore=0
 phishscore=0 adultscore=0 suspectscore=2 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270118
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/27/20 2:39 AM, Vitaly Kuznetsov wrote:
> Krish Sadhukhan <krish.sadhukhan@oracle.com> writes:
>
>> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h | 12 ++++++------
>>   arch/x86/kvm/svm/svm.c          | 12 ++++++------
>>   arch/x86/kvm/vmx/vmx.c          |  8 ++++----
>>   arch/x86/kvm/x86.c              | 22 +++++++++++-----------
>>   include/linux/kvm_host.h        |  2 +-
>>   virt/kvm/kvm_main.c             |  4 ++--
>>   6 files changed, 30 insertions(+), 30 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index be5363b..ccad66d 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1080,7 +1080,7 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
>>   struct kvm_x86_ops {
>>   	int (*hardware_enable)(void);
>>   	void (*hardware_disable)(void);
>> -	void (*hardware_unsetup)(void);
>> +	void (*hardware_teardown)(void);
> I definitely welcome the change but we may want to fix other arches as
> well:
>
>   git grep hardware_unsetup HEAD
>
> HEAD:arch/arm64/include/asm/kvm_host.h:static inline void kvm_arch_hardware_unsetup(void) {}
> HEAD:arch/mips/include/asm/kvm_host.h:static inline void kvm_arch_hardware_unsetup(void) {}
> HEAD:arch/powerpc/include/asm/kvm_host.h:static inline void kvm_arch_hardware_unsetup(void) {}
> HEAD:arch/s390/kvm/kvm-s390.c:void kvm_arch_hardware_unsetup(void)


Absolutely.  I should have thought about other arches when making that 
change !

>
>>   	bool (*cpu_has_accelerated_tpr)(void);
>>   	bool (*has_emulated_msr)(u32 index);
>>   	void (*cpuid_update)(struct kvm_vcpu *vcpu);
>> @@ -1141,7 +1141,7 @@ struct kvm_x86_ops {
>>   	 */
>>   	void (*tlb_flush_guest)(struct kvm_vcpu *vcpu);
>>   
>> -	enum exit_fastpath_completion (*run)(struct kvm_vcpu *vcpu);
>> +	enum exit_fastpath_completion (*vcpu_run)(struct kvm_vcpu *vcpu);
>>   	int (*handle_exit)(struct kvm_vcpu *vcpu,
>>   		enum exit_fastpath_completion exit_fastpath);
>>   	int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
>> @@ -1150,8 +1150,8 @@ struct kvm_x86_ops {
>>   	u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu);
>>   	void (*patch_hypercall)(struct kvm_vcpu *vcpu,
>>   				unsigned char *hypercall_addr);
>> -	void (*set_irq)(struct kvm_vcpu *vcpu);
>> -	void (*set_nmi)(struct kvm_vcpu *vcpu);
>> +	void (*inject_irq)(struct kvm_vcpu *vcpu);
>> +	void (*inject_nmi)(struct kvm_vcpu *vcpu);
>>   	void (*queue_exception)(struct kvm_vcpu *vcpu);
>>   	void (*cancel_injection)(struct kvm_vcpu *vcpu);
>>   	int (*interrupt_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
>> @@ -1258,8 +1258,8 @@ struct kvm_x86_ops {
>>   	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
>>   
>>   	int (*mem_enc_op)(struct kvm *kvm, void __user *argp);
>> -	int (*mem_enc_reg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
>> -	int (*mem_enc_unreg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
>> +	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
>> +	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
> These two should probably pair with
>
> KVM_MEMORY_ENCRYPT_REG_REGION
> KVM_MEMORY_ENCRYPT_UNREG_REGION
>
> shortening "memory" as "mem" and "encrypt" as "enc" is probably OK
> because I can't think of any other meaning but shortening "register" as
> "reg" may be percieved as CPU register.
>
> What if we change ioctls too:
> KVM_MEM_ENC_REGISTER_REGION
> KVM_MEM_ENC_UNREGISTER_REGION
>
> to make this all consistent?


Works for me. Will send v3.  Thanks !

>
>>   
>>   	int (*get_msr_feature)(struct kvm_msr_entry *entry);
>>   
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index c0da4dd..24755eb 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -3969,7 +3969,7 @@ static int svm_vm_init(struct kvm *kvm)
>>   }
>>   
>>   static struct kvm_x86_ops svm_x86_ops __initdata = {
>> -	.hardware_unsetup = svm_hardware_teardown,
>> +	.hardware_teardown = svm_hardware_teardown,
>>   	.hardware_enable = svm_hardware_enable,
>>   	.hardware_disable = svm_hardware_disable,
>>   	.cpu_has_accelerated_tpr = svm_cpu_has_accelerated_tpr,
>> @@ -4016,15 +4016,15 @@ static int svm_vm_init(struct kvm *kvm)
>>   	.tlb_flush_gva = svm_flush_tlb_gva,
>>   	.tlb_flush_guest = svm_flush_tlb,
>>   
>> -	.run = svm_vcpu_run,
>> +	.vcpu_run = svm_vcpu_run,
>>   	.handle_exit = handle_exit,
>>   	.skip_emulated_instruction = skip_emulated_instruction,
>>   	.update_emulated_instruction = NULL,
>>   	.set_interrupt_shadow = svm_set_interrupt_shadow,
>>   	.get_interrupt_shadow = svm_get_interrupt_shadow,
>>   	.patch_hypercall = svm_patch_hypercall,
>> -	.set_irq = svm_set_irq,
>> -	.set_nmi = svm_inject_nmi,
>> +	.inject_irq = svm_set_irq,
>> +	.inject_nmi = svm_inject_nmi,
>>   	.queue_exception = svm_queue_exception,
>>   	.cancel_injection = svm_cancel_injection,
>>   	.interrupt_allowed = svm_interrupt_allowed,
>> @@ -4080,8 +4080,8 @@ static int svm_vm_init(struct kvm *kvm)
>>   	.enable_smi_window = enable_smi_window,
>>   
>>   	.mem_enc_op = svm_mem_enc_op,
>> -	.mem_enc_reg_region = svm_register_enc_region,
>> -	.mem_enc_unreg_region = svm_unregister_enc_region,
>> +	.mem_enc_register_region = svm_register_enc_region,
>> +	.mem_enc_unregister_region = svm_unregister_enc_region,
>>   
>>   	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
>>   
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index cb22f33..90d91524 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -7844,7 +7844,7 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
>>   }
>>   
>>   static struct kvm_x86_ops vmx_x86_ops __initdata = {
>> -	.hardware_unsetup = hardware_unsetup,
>> +	.hardware_teardown = hardware_unsetup,
>>   
>>   	.hardware_enable = hardware_enable,
>>   	.hardware_disable = hardware_disable,
>> @@ -7889,15 +7889,15 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
>>   	.tlb_flush_gva = vmx_flush_tlb_gva,
>>   	.tlb_flush_guest = vmx_flush_tlb_guest,
>>   
>> -	.run = vmx_vcpu_run,
>> +	.vcpu_run = vmx_vcpu_run,
>>   	.handle_exit = vmx_handle_exit,
>>   	.skip_emulated_instruction = vmx_skip_emulated_instruction,
>>   	.update_emulated_instruction = vmx_update_emulated_instruction,
>>   	.set_interrupt_shadow = vmx_set_interrupt_shadow,
>>   	.get_interrupt_shadow = vmx_get_interrupt_shadow,
>>   	.patch_hypercall = vmx_patch_hypercall,
>> -	.set_irq = vmx_inject_irq,
>> -	.set_nmi = vmx_inject_nmi,
>> +	.inject_irq = vmx_inject_irq,
>> +	.inject_nmi = vmx_inject_nmi,
>>   	.queue_exception = vmx_queue_exception,
>>   	.cancel_injection = vmx_cancel_injection,
>>   	.interrupt_allowed = vmx_interrupt_allowed,
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 3b92db4..e850fb3 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -5270,8 +5270,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
>>   			goto out;
>>   
>>   		r = -ENOTTY;
>> -		if (kvm_x86_ops.mem_enc_reg_region)
>> -			r = kvm_x86_ops.mem_enc_reg_region(kvm, &region);
>> +		if (kvm_x86_ops.mem_enc_register_region)
>> +			r = kvm_x86_ops.mem_enc_register_region(kvm, &region);
>>   		break;
>>   	}
>>   	case KVM_MEMORY_ENCRYPT_UNREG_REGION: {
>> @@ -5282,8 +5282,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
>>   			goto out;
>>   
>>   		r = -ENOTTY;
>> -		if (kvm_x86_ops.mem_enc_unreg_region)
>> -			r = kvm_x86_ops.mem_enc_unreg_region(kvm, &region);
>> +		if (kvm_x86_ops.mem_enc_unregister_region)
>> +			r = kvm_x86_ops.mem_enc_unregister_region(kvm, &region);
>>   		break;
>>   	}
>>   	case KVM_HYPERV_EVENTFD: {
>> @@ -7788,10 +7788,10 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
>>   	 */
>>   	else if (!vcpu->arch.exception.pending) {
>>   		if (vcpu->arch.nmi_injected) {
>> -			kvm_x86_ops.set_nmi(vcpu);
>> +			kvm_x86_ops.inject_nmi(vcpu);
>>   			can_inject = false;
>>   		} else if (vcpu->arch.interrupt.injected) {
>> -			kvm_x86_ops.set_irq(vcpu);
>> +			kvm_x86_ops.inject_irq(vcpu);
>>   			can_inject = false;
>>   		}
>>   	}
>> @@ -7867,7 +7867,7 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
>>   		if (r) {
>>   			--vcpu->arch.nmi_pending;
>>   			vcpu->arch.nmi_injected = true;
>> -			kvm_x86_ops.set_nmi(vcpu);
>> +			kvm_x86_ops.inject_nmi(vcpu);
>>   			can_inject = false;
>>   			WARN_ON(kvm_x86_ops.nmi_allowed(vcpu, true) < 0);
>>   		}
>> @@ -7881,7 +7881,7 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
>>   			goto busy;
>>   		if (r) {
>>   			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu), false);
>> -			kvm_x86_ops.set_irq(vcpu);
>> +			kvm_x86_ops.inject_irq(vcpu);
>>   			WARN_ON(kvm_x86_ops.interrupt_allowed(vcpu, true) < 0);
>>   		}
>>   		if (kvm_cpu_has_injectable_intr(vcpu))
>> @@ -8517,7 +8517,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>>   		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_RELOAD;
>>   	}
>>   
>> -	exit_fastpath = kvm_x86_ops.run(vcpu);
>> +	exit_fastpath = kvm_x86_ops.vcpu_run(vcpu);
>>   
>>   	/*
>>   	 * Do this here before restoring debug registers on the host.  And
>> @@ -9793,9 +9793,9 @@ int kvm_arch_hardware_setup(void *opaque)
>>   	return 0;
>>   }
>>   
>> -void kvm_arch_hardware_unsetup(void)
>> +void kvm_arch_hardware_teardown(void)
>>   {
>> -	kvm_x86_ops.hardware_unsetup();
>> +	kvm_x86_ops.hardware_teardown();
>>   }
>>   
>>   int kvm_arch_check_processor_compat(void *opaque)
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index d564855..b49312c 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -894,7 +894,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>>   int kvm_arch_hardware_enable(void);
>>   void kvm_arch_hardware_disable(void);
>>   int kvm_arch_hardware_setup(void *opaque);
>> -void kvm_arch_hardware_unsetup(void);
>> +void kvm_arch_hardware_teardown(void);
>>   int kvm_arch_check_processor_compat(void *opaque);
>>   int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
>>   bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index a852af5..4625f3a 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -4786,7 +4786,7 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>>   	unregister_reboot_notifier(&kvm_reboot_notifier);
>>   	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
>>   out_free_2:
>> -	kvm_arch_hardware_unsetup();
>> +	kvm_arch_hardware_teardown();
>>   out_free_1:
>>   	free_cpumask_var(cpus_hardware_enabled);
>>   out_free_0:
>> @@ -4808,7 +4808,7 @@ void kvm_exit(void)
>>   	unregister_reboot_notifier(&kvm_reboot_notifier);
>>   	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
>>   	on_each_cpu(hardware_disable_nolock, NULL, 1);
>> -	kvm_arch_hardware_unsetup();
>> +	kvm_arch_hardware_teardown();
> And this probably means we'll have to take care of non-x86 arches after
> all.
>
>>   	kvm_arch_exit();
>>   	kvm_irqfd_exit();
>>   	free_cpumask_var(cpus_hardware_enabled);
