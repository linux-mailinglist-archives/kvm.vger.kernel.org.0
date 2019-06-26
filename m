Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2AD56550
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 11:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbfFZJI7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 05:08:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53086 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbfFZJI7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 05:08:59 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 34A23A705;
        Wed, 26 Jun 2019 09:08:58 +0000 (UTC)
Received: from [10.36.116.174] (ovpn-116-174.ams2.redhat.com [10.36.116.174])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C90CB1001B05;
        Wed, 26 Jun 2019 09:08:56 +0000 (UTC)
Subject: Re: [PATCH v5 2/2] s390/kvm: diagnose 318 handling
To:     Collin Walling <walling@linux.ibm.com>, cohuck@redhat.com,
        pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <1561475022-18348-1-git-send-email-walling@linux.ibm.com>
 <1561475022-18348-3-git-send-email-walling@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <cb01cb7b-51c5-b1e7-0a07-b2db4b1f2cf8@redhat.com>
Date:   Wed, 26 Jun 2019 11:08:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1561475022-18348-3-git-send-email-walling@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Wed, 26 Jun 2019 09:08:58 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25.06.19 17:03, Collin Walling wrote:
> DIAGNOSE 0x318 (diag318) is a privileged s390x instruction that must
> be intercepted by SIE and handled via KVM. Let's introduce some
> functions to communicate between userspace and KVM via ioctls. These
> will be used to get/set the diag318 related information, as well as
> check the system if KVM supports handling this instruction.
> 
> This information can help with diagnosing the environment the VM is
> running in (Linux, z/VM, etc) if the OS calls this instruction.
> 
> The get/set functions are introduced primarily for VM migration and
> reset, though no harm could be done to the system if a userspace
> program decides to alter this data (this is highly discouraged).
> 
> The Control Program Name Code (CPNC) is stored in the SIE block (if
> host hardware supports it) and a copy is retained in each VCPU. The
> Control Program Version Code (CPVC) is not designed to be stored in
> the SIE block, so we retain a copy in each VCPU next to the CPNC.
> 
> At this time, the CPVC is not reported during a VM_EVENT as its
> format is yet to be properly defined.
> > Signed-off-by: Collin Walling <walling@linux.ibm.com>

Only some minor comments.


> ---
>  Documentation/virtual/kvm/devices/vm.txt | 14 ++++++
>  arch/s390/include/asm/kvm_host.h         |  5 +-
>  arch/s390/include/uapi/asm/kvm.h         |  4 ++
>  arch/s390/kvm/diag.c                     | 17 +++++++
>  arch/s390/kvm/kvm-s390.c                 | 81 ++++++++++++++++++++++++++++++++
>  arch/s390/kvm/kvm-s390.h                 |  1 +
>  arch/s390/kvm/vsie.c                     |  2 +
>  7 files changed, 123 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virtual/kvm/devices/vm.txt b/Documentation/virtual/kvm/devices/vm.txt
> index 4ffb82b..56f7d9c 100644
> --- a/Documentation/virtual/kvm/devices/vm.txt
> +++ b/Documentation/virtual/kvm/devices/vm.txt
> @@ -268,3 +268,17 @@ Parameters: address of a buffer in user space to store the data (u64) to;
>  	    if it is enabled
>  Returns:    -EFAULT if the given address is not accessible from kernel space
>  	    0 in case of success.
> +
> +6. GROUP: KVM_S390_VM_MISC
> +Architectures: s390
> +
> +6.1. KVM_S390_VM_MISC_DIAG318 (r/w)
> +
> +Allows userspace to access the DIAGNOSE 0x318 information which consists of a
> +1-byte "Control Program Name Code" and a 7-byte "Control Program Version Code".
> +This information is initialized during IPL and must be preserved during
> +migration.
> +
> +Parameters: address of a buffer in user space to store the data (u64) to
> +Returns:    -EFAULT if the given address is not accessible from kernel space
> +	     0 in case of success.
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 2b00a3e..b70e8a4 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -229,7 +229,8 @@ struct kvm_s390_sie_block {
>  	__u32	scaol;			/* 0x0064 */
>  	__u8	reserved68;		/* 0x0068 */
>  	__u8    epdx;			/* 0x0069 */
> -	__u8    reserved6a[2];		/* 0x006a */
> +	__u8	cpnc;			/* 0x006a */
> +	__u8	reserved6b;		/* 0x006b */
>  	__u32	todpr;			/* 0x006c */
>  #define GISA_FORMAT1 0x00000001
>  	__u32	gd;			/* 0x0070 */
> @@ -393,6 +394,7 @@ struct kvm_vcpu_stat {
>  	u64 diagnose_9c;
>  	u64 diagnose_258;
>  	u64 diagnose_308;
> +	u64 diagnose_318;
>  	u64 diagnose_500;
>  	u64 diagnose_other;
>  };
> @@ -868,6 +870,7 @@ struct kvm_arch{
>  	DECLARE_BITMAP(cpu_feat, KVM_S390_VM_CPU_FEAT_NR_BITS);
>  	DECLARE_BITMAP(idle_mask, KVM_MAX_VCPUS);
>  	struct kvm_s390_gisa_interrupt gisa_int;
> +	union diag318_info diag318_info;
>  };
>  
>  #define KVM_HVA_ERR_BAD		(-1UL)
> diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
> index 47104e5..e0684da 100644
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
> @@ -171,6 +172,9 @@ struct kvm_s390_vm_cpu_subfunc {
>  #define KVM_S390_VM_MIGRATION_START	1
>  #define KVM_S390_VM_MIGRATION_STATUS	2
>  
> +/* kvm attributes for KVM_S390_VM_MISC */
> +#define KVM_S390_VM_MISC_DIAG318	0
> +
>  /* for KVM_GET_REGS and KVM_SET_REGS */
>  struct kvm_regs {
>  	/* general purpose regs for s390 */
> diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
> index 45634b3d..42a8db3 100644
> --- a/arch/s390/kvm/diag.c
> +++ b/arch/s390/kvm/diag.c
> @@ -235,6 +235,21 @@ static int __diag_virtio_hypercall(struct kvm_vcpu *vcpu)
>  	return ret < 0 ? ret : 0;
>  }
>  
> +static int __diag_set_diag318_info(struct kvm_vcpu *vcpu)
> +{
> +	unsigned int reg = (vcpu->arch.sie_block->ipa & 0xf0) >> 4;
> +	u64 info = vcpu->run->s.regs.gprs[reg];
> +
> +	vcpu->stat.diagnose_318++;
> +	kvm_s390_set_diag318_info(vcpu->kvm, info);
> +
> +	VCPU_EVENT(vcpu, 3, "diag 0x318 cpnc: 0x%x cpvc: 0x%llx",
> +		   vcpu->kvm->arch.diag318_info.cpnc,
> +		   (u64)vcpu->kvm->arch.diag318_info.cpvc);

We have the event in kvm_s390_set_diag318_info(), do we really need this
one, too?

> +
> +	return 0;
> +}
> +
>  int kvm_s390_handle_diag(struct kvm_vcpu *vcpu)
>  {
>  	int code = kvm_s390_get_base_disp_rs(vcpu, NULL) & 0xffff;
> @@ -254,6 +269,8 @@ int kvm_s390_handle_diag(struct kvm_vcpu *vcpu)
>  		return __diag_page_ref_service(vcpu);
>  	case 0x308:
>  		return __diag_ipl_functions(vcpu);
> +	case 0x318:
> +		return __diag_set_diag318_info(vcpu);
>  	case 0x500:
>  		return __diag_virtio_hypercall(vcpu);
>  	default:
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 28ebd64..8be9867 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -157,6 +157,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
>  	{ "instruction_diag_9c", VCPU_STAT(diagnose_9c) },
>  	{ "instruction_diag_258", VCPU_STAT(diagnose_258) },
>  	{ "instruction_diag_308", VCPU_STAT(diagnose_308) },
> +	{ "instruction_diag_318", VCPU_STAT(diagnose_318) },
>  	{ "instruction_diag_500", VCPU_STAT(diagnose_500) },
>  	{ "instruction_diag_other", VCPU_STAT(diagnose_other) },
>  	{ NULL }
> @@ -1228,6 +1229,68 @@ static int kvm_s390_get_tod(struct kvm *kvm, struct kvm_device_attr *attr)
>  	return ret;
>  }
>  
> +void kvm_s390_set_diag318_info(struct kvm *kvm, u64 info)
> +{
> +	struct kvm_vcpu *vcpu;
> +	int i;
> +
> +	kvm->arch.diag318_info.val = info;
> +
> +	VM_EVENT(kvm, 3, "SET: CPNC: 0x%x CPVC: 0x%llx",
> +		 kvm->arch.diag318_info.cpnc, (u64)kvm->arch.diag318_info.cpvc);
> +
> +	if (sclp.has_diag318) {
> +		kvm_for_each_vcpu(i, vcpu, kvm) {
> +			vcpu->arch.sie_block->cpnc = kvm->arch.diag318_info.cpnc;
> +		}

If two CPUs would be executing this in parallel, we could create an
inconsistent cpnc value in the HW. Not sure if we care.

Also, there is a possible race with CPU hotplug, depending on the
compiler optimizations if I'm not wrong.

Sure we don't want to protect this by a mutex just to avoid having to
worry about such stuff?

I guess, for ordinary guest operations, these races shouldn't matter.

> +	}
> +}
> +
> +static int kvm_s390_set_misc(struct kvm *kvm, struct kvm_device_attr *attr)
> +{
> +	int ret;
> +	u64 diag318_info;

nit: reorder both

> +
> +	switch (attr->attr) {
> +	case KVM_S390_VM_MISC_DIAG318:
> +		ret = -EFAULT;
> +		if (get_user(diag318_info, (u64 __user *)attr->addr))
> +			break;
> +		kvm_s390_set_diag318_info(kvm, diag318_info);
> +		ret = 0;
> +		break;
> +	default:
> +		ret = -ENXIO;
> +		break;
> +	}
> +	return ret;
> +}
> +
> +static int kvm_s390_get_diag318_info(struct kvm *kvm, struct kvm_device_attr *attr)
> +{
> +	if (put_user(kvm->arch.diag318_info.val, (u64 __user *)attr->addr))
> +		return -EFAULT;
> +
> +	VM_EVENT(kvm, 3, "QUERY: CPNC: 0x%x, CPVC: 0x%llx",
> +		 kvm->arch.diag318_info.cpnc, (u64)kvm->arch.diag318_info.cpvc);

Sure we need that cast / can't avoid it?

> +	return 0;
> +}
> +
> +static int kvm_s390_get_misc(struct kvm *kvm, struct kvm_device_attr *attr)
> +{
> +	int ret;
> +
> +	switch (attr->attr) {
> +	case KVM_S390_VM_MISC_DIAG318:
> +		ret = kvm_s390_get_diag318_info(kvm, attr);
> +		break;
> +	default:
> +		ret = -ENXIO;
> +		break;
> +	}
> +	return ret;
> +}
> +
>  static int kvm_s390_set_processor(struct kvm *kvm, struct kvm_device_attr *attr)
>  {
>  	struct kvm_s390_vm_cpu_processor *proc;
> @@ -1674,6 +1737,9 @@ static int kvm_s390_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>  	case KVM_S390_VM_MIGRATION:
>  		ret = kvm_s390_vm_set_migration(kvm, attr);
>  		break;
> +	case KVM_S390_VM_MISC:
> +		ret = kvm_s390_set_misc(kvm, attr);
> +		break;
>  	default:
>  		ret = -ENXIO;
>  		break;
> @@ -1699,6 +1765,9 @@ static int kvm_s390_vm_get_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>  	case KVM_S390_VM_MIGRATION:
>  		ret = kvm_s390_vm_get_migration(kvm, attr);
>  		break;
> +	case KVM_S390_VM_MISC:
> +		ret = kvm_s390_get_misc(kvm, attr);
> +		break;
>  	default:
>  		ret = -ENXIO;
>  		break;
> @@ -1772,6 +1841,16 @@ static int kvm_s390_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>  	case KVM_S390_VM_MIGRATION:
>  		ret = 0;
>  		break;
> +	case KVM_S390_VM_MISC:
> +		switch (attr->attr) {
> +		case KVM_S390_VM_MISC_DIAG318:
> +			ret = 0;
> +			break;
> +		default:
> +			ret = -ENXIO;
> +			break;
> +		}
> +		break;
>  	default:
>  		ret = -ENXIO;
>  		break;
> @@ -2892,6 +2971,8 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
>  		vcpu->arch.sie_block->ictl |= ICTL_OPEREXC;
>  	/* make vcpu_load load the right gmap on the first trigger */
>  	vcpu->arch.enabled_gmap = vcpu->arch.gmap;
> +	if (sclp.has_diag318)
> +		vcpu->arch.sie_block->cpnc = vcpu->kvm->arch.diag318_info.cpnc;
>  }
>  
>  static bool kvm_has_pckmo_subfunc(struct kvm *kvm, unsigned long nr)
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index 6d9448d..70a21b4 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -281,6 +281,7 @@ int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu);
>  int kvm_s390_handle_sigp_pei(struct kvm_vcpu *vcpu);
>  
>  /* implemented in kvm-s390.c */
> +void kvm_s390_set_diag318_info(struct kvm *kvm, u64 info);
>  void kvm_s390_set_tod_clock(struct kvm *kvm,
>  			    const struct kvm_s390_vm_tod_clock *gtod);
>  long kvm_arch_fault_in_page(struct kvm_vcpu *vcpu, gpa_t gpa, int writable);
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index 076090f..50e522e0 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -548,6 +548,8 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>  		scb_s->ecd |= scb_o->ecd & ECD_ETOKENF;
>  
>  	scb_s->hpid = HPID_VSIE;
> +	if (sclp.has_diag318)
> +		scb_s->cpnc = scb_o->cpnc;
>  
>  	prepare_ibc(vcpu, vsie_page);
>  	rc = shadow_crycb(vcpu, vsie_page);
> 


-- 

Thanks,

David / dhildenb
