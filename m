Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D65CB1199E
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 14:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfEBM7y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 08:59:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64001 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfEBM7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 May 2019 08:59:54 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 529C9300B912;
        Thu,  2 May 2019 12:59:53 +0000 (UTC)
Received: from [10.36.117.88] (ovpn-117-88.ams2.redhat.com [10.36.117.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1EB0679C72;
        Thu,  2 May 2019 12:59:51 +0000 (UTC)
Subject: Re: [PATCH v4 2/2] s390/kvm: diagnose 318 handling
To:     Collin Walling <walling@linux.ibm.com>, cohuck@redhat.com,
        pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <1556751063-21835-1-git-send-email-walling@linux.ibm.com>
 <1556751063-21835-3-git-send-email-walling@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <783ecdb4-3bc2-4bf3-55cb-9a902467aadd@redhat.com>
Date:   Thu, 2 May 2019 14:59:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1556751063-21835-3-git-send-email-walling@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Thu, 02 May 2019 12:59:53 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02.05.19 00:51, Collin Walling wrote:
> DIAGNOSE 0x318 (diag318) is a privileged s390x instruction that must
> be intercepted by SIE and handled via KVM. Let's introduce some
> functions to communicate between userspace and KVM via ioctls. These
> will be used to get/set the diag318 related information (also known
> as the "Control Program Code" or "CPC"), as well as check the system
> if KVM supports handling this instruction.
> 
> This information can help with diagnosing the OS the VM is running
> in (Linux, z/VM, etc) if the OS calls this instruction.
> 
> The get/set functions are introduced primarily for VM migration and
> reset, though no harm could be done to the system if a userspace
> program decides to alter this data (this is highly discouraged).
> 
> The Control Program Name Code (CPNC) is stored in the SIE block and
> a copy is retained in each VCPU. The Control Program Version Code
> (CPVC) retains a copy in each VCPU as well.
> 
> At this time, the CPVC is not reported as its format is yet to be
> defined.
> 
> Note that the CPNC is set in the SIE block iff the host hardware
> supports it.

For vSIE and SIE you only configure the CPNC. Is that sufficient?
Shouldn't diag318 allow the guest to set both? (especially regarding vSIE)

[...]
> 
> diff --git a/Documentation/virtual/kvm/devices/vm.txt b/Documentation/virtual/kvm/devices/vm.txt
> index 95ca68d..9a8d934 100644
> --- a/Documentation/virtual/kvm/devices/vm.txt
> +++ b/Documentation/virtual/kvm/devices/vm.txt
> @@ -267,3 +267,17 @@ Parameters: address of a buffer in user space to store the data (u64) to;
>  	    if it is enabled
>  Returns:    -EFAULT if the given address is not accessible from kernel space
>  	    0 in case of success.
> +
> +6. GROUP: KVM_S390_VM_MISC
> +Architectures: s390
> +
> +6.1. KVM_S390_VM_MISC_CPC (r/w)
> +
> +Allows userspace to access the "Control Program Code" which consists of a
> +1-byte "Control Program Name Code" and a 7-byte "Control Program Version Code".
> +This information is initialized during IPL and must be preserved during
> +migration.

Your implementation does not match this description. User space can only
get/set the cpnc effectively for the HW to see it, not the CPVC, no?

Shouldn't you transparently forward that data to the SCB for vSIE/SIE,
because we really don't care what the target format will be?

> +
> +Parameters: address of a buffer in user space to store the data (u64) to
> +Returns:    -EFAULT if the given address is not accessible from kernel space
> +	     0 in case of success.

[...]
>  
>  #define KVM_HVA_ERR_BAD		(-1UL)
> diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
> index 16511d9..3d3d2a5 100644
> --- a/arch/s390/include/uapi/asm/kvm.h
> +++ b/arch/s390/include/uapi/asm/kvm.h
> @@ -74,6 +74,7 @@ struct kvm_s390_io_adapter_req {
>  #define KVM_S390_VM_CRYPTO		2
>  #define KVM_S390_VM_CPU_MODEL		3
>  #define KVM_S390_VM_MIGRATION		4
> +#define KVM_S390_VM_MISC		5
>  
>  /* kvm attributes for mem_ctrl */
>  #define KVM_S390_VM_MEM_ENABLE_CMMA	0
> @@ -168,6 +169,9 @@ struct kvm_s390_vm_cpu_subfunc {
>  #define KVM_S390_VM_MIGRATION_START	1
>  #define KVM_S390_VM_MIGRATION_STATUS	2
>  
> +/* kvm attributes for KVM_S390_VM_MISC */
> +#define KVM_S390_VM_MISC_CPC		0
> +
>  /* for KVM_GET_REGS and KVM_SET_REGS */
>  struct kvm_regs {
>  	/* general purpose regs for s390 */
> diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
> index 45634b3d..9762e6a 100644
> --- a/arch/s390/kvm/diag.c
> +++ b/arch/s390/kvm/diag.c
> @@ -235,6 +235,21 @@ static int __diag_virtio_hypercall(struct kvm_vcpu *vcpu)
>  	return ret < 0 ? ret : 0;
>  }
>  
> +static int __diag_set_control_prog_name(struct kvm_vcpu *vcpu)

Can we name that "__diag_set_cpc" ?

"control_prog_name" is certainly not 100% correct.

> +{
> +	unsigned int reg = (vcpu->arch.sie_block->ipa & 0xf0) >> 4;
> +	u64 cpc = vcpu->run->s.regs.gprs[reg];
> +
> +	vcpu->stat.diagnose_318++;
> +	kvm_s390_set_cpc(vcpu->kvm, cpc);
> +
> +	VCPU_EVENT(vcpu, 3, "diag 0x318 cpnc: 0x%x cpvc: 0x%llx",
> +		   vcpu->kvm->arch.diag318_info.cpnc,
> +		   (u64)vcpu->kvm->arch.diag318_info.cpvc);
> +
> +	return 0;
> +}


[...]
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 4638303..910af18 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -156,6 +156,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
>  	{ "instruction_diag_9c", VCPU_STAT(diagnose_9c) },
>  	{ "instruction_diag_258", VCPU_STAT(diagnose_258) },
>  	{ "instruction_diag_308", VCPU_STAT(diagnose_308) },
> +	{ "instruction_diag_318", VCPU_STAT(diagnose_318) },
>  	{ "instruction_diag_500", VCPU_STAT(diagnose_500) },
>  	{ "instruction_diag_other", VCPU_STAT(diagnose_other) },
>  	{ NULL }
> @@ -1190,6 +1191,70 @@ static int kvm_s390_get_tod(struct kvm *kvm, struct kvm_device_attr *attr)
>  	return ret;
>  }
>  
> +void kvm_s390_set_cpc(struct kvm *kvm, u64 cpc)
> +{
> +	struct kvm_vcpu *vcpu;
> +	int i;
> +
> +	mutex_lock(&kvm->lock);
> +	kvm->arch.diag318_info.val = cpc;
> +
> +	VM_EVENT(kvm, 3, "SET: CPNC: 0x%x CPVC: 0x%llx",
> +		 kvm->arch.diag318_info.cpnc, (u64)kvm->arch.diag318_info.cpvc);
> +
> +	if (sclp.has_diag318) {
> +		kvm_for_each_vcpu(i, vcpu, kvm) {
> +			vcpu->arch.sie_block->cpnc = kvm->arch.diag318_info.cpnc;
> +		}
> +	}

Do we care about races here between guest VCPUs reading it via the SCB
(HW) and us changing the value? My gut feeling is that it can be tolerated.

> +	mutex_unlock(&kvm->lock);
> +}
> +
> +static int kvm_s390_set_misc(struct kvm *kvm, struct kvm_device_attr *attr)
> +{
> +	int ret;
> +	u64 cpc;
> +
> +	switch (attr->attr) {
> +	case KVM_S390_VM_MISC_CPC:
> +		ret = -EFAULT;
> +		if (get_user(cpc, (u64 __user *)attr->addr))
> +			break;
> +		kvm_s390_set_cpc(kvm, cpc);
> +		ret = 0;
> +		break;
> +	default:
> +		ret = -ENXIO;
> +		break;
> +	}
> +	return ret;
> +}
> +
> +static int kvm_s390_get_cpc(struct kvm *kvm, struct kvm_device_attr *attr)
> +{
> +	if (put_user(kvm->arch.diag318_info.val, (u64 __user *)attr->addr))
> +		return -EFAULT;

Another possible race with setting code. Should be at least take the
kvm->lock here? Otherwise, also looks like this can be tolerated.

-- 

Thanks,

David / dhildenb
