Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704FD1EB292
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 02:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbgFBALp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 20:11:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51862 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgFBALp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 20:11:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052082x7137476;
        Tue, 2 Jun 2020 00:11:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=4x09eYxCbZNzgkKuwkQd+dLeabJhgDXKW7os9aI6aF8=;
 b=lWRY12HVGdTSxbG8YGQf7EsIYoExNwufik+Wj9uoMuClcjwE3gRAgPWLsj/Bb3JbvYPz
 v9dPqUPo1m82h6y3RFJkY85DBhcaUCWORuCUTy0ebVPzV/Fn5qfm/vLydnrmgfd8xWwe
 8+7KHbi6PyTrCfyL3qx2606GFra0Z9BdF1WQYE6Kv/C3N/Gu1CJ8tM8ySYC0kii6GMBJ
 NjkzCXLQsbDsyfu18CY/ntBn9AGthPVMLBPmMi95Nkdwds4bQzs2vQFKUt7ECwC5O2wA
 jB49Ah4gc+wdjFz0jAz84XrWttOdVaHrxHq+tEjLlE3whapwWOUIRtaQfT4IkcDXLUh6 vg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31d5qr1gbx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 00:11:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05209IDu068731;
        Tue, 2 Jun 2020 00:11:40 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 31c1dw9478-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 00:11:40 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0520Bd1S016706;
        Tue, 2 Jun 2020 00:11:39 GMT
Received: from localhost.localdomain (/10.159.152.58)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 17:11:39 -0700
Subject: Re: [PATCH 30/30] KVM: nSVM: implement KVM_GET_NESTED_STATE and
 KVM_SET_NESTED_STATE
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200529153934.11694-1-pbonzini@redhat.com>
 <20200529153934.11694-31-pbonzini@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <eabf694a-68e4-3877-2ad7-3d37f54fd3d4@oracle.com>
Date:   Mon, 1 Jun 2020 17:11:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200529153934.11694-31-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=855
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006010177
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=894 cotscore=-2147483648
 mlxscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0 adultscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006010177
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/29/20 8:39 AM, Paolo Bonzini wrote:
> Similar to VMX, the state that is captured through the currently available
> IOCTLs is a mix of L1 and L2 state, dependent on whether the L2 guest was
> running at the moment when the process was interrupted to save its state.
>
> In particular, the SVM-specific state for nested virtualization includes
> the L1 saved state (including the interrupt flag), the cached L2 controls,
> and the GIF.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/include/uapi/asm/kvm.h |  17 +++-
>   arch/x86/kvm/cpuid.h            |   5 ++
>   arch/x86/kvm/svm/nested.c       | 147 ++++++++++++++++++++++++++++++++
>   arch/x86/kvm/svm/svm.c          |   1 +
>   arch/x86/kvm/vmx/nested.c       |   5 --
>   arch/x86/kvm/x86.c              |   3 +-
>   6 files changed, 171 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 3f3f780c8c65..12075a9de1c1 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -385,18 +385,22 @@ struct kvm_sync_regs {
>   #define KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT (1 << 4)
>   
>   #define KVM_STATE_NESTED_FORMAT_VMX	0
> -#define KVM_STATE_NESTED_FORMAT_SVM	1	/* unused */
> +#define KVM_STATE_NESTED_FORMAT_SVM	1
>   
>   #define KVM_STATE_NESTED_GUEST_MODE	0x00000001
>   #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
>   #define KVM_STATE_NESTED_EVMCS		0x00000004
>   #define KVM_STATE_NESTED_MTF_PENDING	0x00000008
> +#define KVM_STATE_NESTED_GIF_SET	0x00000100
>   
>   #define KVM_STATE_NESTED_SMM_GUEST_MODE	0x00000001
>   #define KVM_STATE_NESTED_SMM_VMXON	0x00000002
>   
>   #define KVM_STATE_NESTED_VMX_VMCS_SIZE	0x1000
>   
> +#define KVM_STATE_NESTED_SVM_VMCB_SIZE	0x1000
> +
> +
>   struct kvm_vmx_nested_state_data {
>   	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
>   	__u8 shadow_vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
> @@ -411,6 +415,15 @@ struct kvm_vmx_nested_state_hdr {
>   	} smm;
>   };
>   
> +struct kvm_svm_nested_state_data {
> +	/* Save area only used if KVM_STATE_NESTED_RUN_PENDING.  */
> +	__u8 vmcb12[KVM_STATE_NESTED_SVM_VMCB_SIZE];
> +};
> +
> +struct kvm_svm_nested_state_hdr {
> +	__u64 vmcb_pa;
> +};
> +
>   /* for KVM_CAP_NESTED_STATE */
>   struct kvm_nested_state {
>   	__u16 flags;
> @@ -419,6 +432,7 @@ struct kvm_nested_state {
>   
>   	union {
>   		struct kvm_vmx_nested_state_hdr vmx;
> +		struct kvm_svm_nested_state_hdr svm;
>   
>   		/* Pad the header to 128 bytes.  */
>   		__u8 pad[120];
> @@ -431,6 +445,7 @@ struct kvm_nested_state {
>   	 */
>   	union {
>   		struct kvm_vmx_nested_state_data vmx[0];
> +		struct kvm_svm_nested_state_data svm[0];
>   	} data;
>   };
>   
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index 63a70f6a3df3..05434cd9342f 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -303,4 +303,9 @@ static __always_inline void kvm_cpu_cap_check_and_set(unsigned int x86_feature)
>   		kvm_cpu_cap_set(x86_feature);
>   }
>   
> +static inline bool page_address_valid(struct kvm_vcpu *vcpu, gpa_t gpa)
> +{
> +	return PAGE_ALIGNED(gpa) && !(gpa >> cpuid_maxphyaddr(vcpu));
> +}
> +
>   #endif
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index c712fe577029..6b1049148c1b 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -25,6 +25,7 @@
>   #include "trace.h"
>   #include "mmu.h"
>   #include "x86.h"
> +#include "cpuid.h"
>   #include "lapic.h"
>   #include "svm.h"
>   
> @@ -238,6 +239,8 @@ static void load_nested_vmcb_control(struct vcpu_svm *svm,
>   {
>   	copy_vmcb_control_area(&svm->nested.ctl, control);
>   
> +	/* Copy it here because nested_svm_check_controls will check it.  */
> +	svm->nested.ctl.asid           = control->asid;
>   	svm->nested.ctl.msrpm_base_pa &= ~0x0fffULL;
>   	svm->nested.ctl.iopm_base_pa  &= ~0x0fffULL;
>   }
> @@ -930,6 +933,150 @@ int nested_svm_exit_special(struct vcpu_svm *svm)
>   	return NESTED_EXIT_CONTINUE;
>   }
>   
> +static int svm_get_nested_state(struct kvm_vcpu *vcpu,
> +				struct kvm_nested_state __user *user_kvm_nested_state,
> +				u32 user_data_size)
> +{
> +	struct vcpu_svm *svm;
> +	struct kvm_nested_state kvm_state = {
> +		.flags = 0,
> +		.format = KVM_STATE_NESTED_FORMAT_SVM,
> +		.size = sizeof(kvm_state),
> +	};
> +	struct vmcb __user *user_vmcb = (struct vmcb __user *)
> +		&user_kvm_nested_state->data.svm[0];
> +
> +	if (!vcpu)
> +		return kvm_state.size + KVM_STATE_NESTED_SVM_VMCB_SIZE;
> +
> +	svm = to_svm(vcpu);
> +
> +	if (user_data_size < kvm_state.size)
> +		goto out;
> +
> +	/* First fill in the header and copy it out.  */
> +	if (is_guest_mode(vcpu)) {
> +		kvm_state.hdr.svm.vmcb_pa = svm->nested.vmcb;
> +		kvm_state.size += KVM_STATE_NESTED_SVM_VMCB_SIZE;
> +		kvm_state.flags |= KVM_STATE_NESTED_GUEST_MODE;
> +
> +		if (svm->nested.nested_run_pending)
> +			kvm_state.flags |= KVM_STATE_NESTED_RUN_PENDING;
> +	}
> +
> +	if (gif_set(svm))
> +		kvm_state.flags |= KVM_STATE_NESTED_GIF_SET;
> +
> +	if (copy_to_user(user_kvm_nested_state, &kvm_state, sizeof(kvm_state)))
> +		return -EFAULT;
> +
> +	if (!is_guest_mode(vcpu))
> +		goto out;
> +
> +	/*
> +	 * Copy over the full size of the VMCB rather than just the size
> +	 * of the structs.
> +	 */
> +	if (clear_user(user_vmcb, KVM_STATE_NESTED_SVM_VMCB_SIZE))
> +		return -EFAULT;
> +	if (copy_to_user(&user_vmcb->control, &svm->nested.ctl,
> +			 sizeof(user_vmcb->control)))
> +		return -EFAULT;
> +	if (copy_to_user(&user_vmcb->save, &svm->nested.hsave->save,
> +			 sizeof(user_vmcb->save)))
> +		return -EFAULT;
> +
> +out:
> +	return kvm_state.size;
> +}
> +
> +static int svm_set_nested_state(struct kvm_vcpu *vcpu,
> +				struct kvm_nested_state __user *user_kvm_nested_state,
> +				struct kvm_nested_state *kvm_state)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	struct vmcb *hsave = svm->nested.hsave;
> +	struct vmcb __user *user_vmcb = (struct vmcb __user *)
> +		&user_kvm_nested_state->data.svm[0];
> +	struct vmcb_control_area ctl;
> +	struct vmcb_save_area save;
> +	u32 cr0;
> +
> +	if (kvm_state->format != KVM_STATE_NESTED_FORMAT_SVM)
> +		return -EINVAL;
> +
> +	if (kvm_state->flags & ~(KVM_STATE_NESTED_GUEST_MODE |
> +				 KVM_STATE_NESTED_RUN_PENDING |
> +				 KVM_STATE_NESTED_GIF_SET))
> +		return -EINVAL;
> +
> +	/*
> +	 * If in guest mode, vcpu->arch.efer actually refers to the L2 guest's
> +	 * EFER.SVME, but EFER.SVME still has to be 1 for VMRUN to succeed.
> +	 */
> +	if (!(vcpu->arch.efer & EFER_SVME)) {
> +		/* GIF=1 and no guest mode are required if SVME=0.  */
> +		if (kvm_state->flags != KVM_STATE_NESTED_GIF_SET)
> +			return -EINVAL;
> +	}
> +
> +	/* SMM temporarily disables SVM, so we cannot be in guest mode.  */
> +	if (is_smm(vcpu) && (kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE))
> +		return -EINVAL;
> +
> +	if (!(kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE)) {


Should this be done up at the beginning of the function ? If this flag 
isn't set, we probably don't want to come this far.

> +		svm_leave_nested(svm);
> +		goto out_set_gif;
> +	}
> +
> +	if (!page_address_valid(vcpu, kvm_state->hdr.svm.vmcb_pa))
> +		return -EINVAL;
> +	if (kvm_state->size < sizeof(*kvm_state) + KVM_STATE_NESTED_SVM_VMCB_SIZE)
> +		return -EINVAL;
> +	if (copy_from_user(&ctl, &user_vmcb->control, sizeof(ctl)))
> +		return -EFAULT;
> +	if (copy_from_user(&save, &user_vmcb->save, sizeof(save)))
> +		return -EFAULT;
> +
> +	if (!nested_vmcb_check_controls(&ctl))
> +		return -EINVAL;
> +
> +	/*
> +	 * Processor state contains L2 state.  Check that it is
> +	 * valid for guest mode (see nested_vmcb_checks).
> +	 */
> +	cr0 = kvm_read_cr0(vcpu);
> +        if (((cr0 & X86_CR0_CD) == 0) && (cr0 & X86_CR0_NW))
> +                return -EINVAL;


Does it make sense to create a wrapper for the CR0 checks ? We have 
these checks in nested_vmcb_check_controls() also.

> +
> +	/*
> +	 * Validate host state saved from before VMRUN (see
> +	 * nested_svm_check_permissions).
> +	 * TODO: validate reserved bits for all saved state.
> +	 */
> +	if (!(save.cr0 & X86_CR0_PG))
> +		return -EINVAL;
> +
> +	/*
> +	 * All checks done, we can enter guest mode.  L1 control fields
> +	 * come from the nested save state.  Guest state is already
> +	 * in the registers, the save area of the nested state instead
> +	 * contains saved L1 state.
> +	 */
> +	copy_vmcb_control_area(&hsave->control, &svm->vmcb->control);
> +	hsave->save = save;
> +
> +	svm->nested.vmcb = kvm_state->hdr.svm.vmcb_pa;
> +	load_nested_vmcb_control(svm, &ctl);
> +	nested_prepare_vmcb_control(svm);
> +
> +out_set_gif:
> +	svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
> +	return 0;
> +}
> +
>   struct kvm_x86_nested_ops svm_nested_ops = {
>   	.check_events = svm_check_nested_events,
> +	.get_state = svm_get_nested_state,
> +	.set_state = svm_set_nested_state,
>   };
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b4db9a980469..3871bfb40594 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1193,6 +1193,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
>   		svm->avic_is_running = true;
>   
>   	svm->nested.hsave = page_address(hsave_page);
> +	clear_page(svm->nested.hsave);
>   
>   	svm->msrpm = page_address(msrpm_pages);
>   	svm_vcpu_init_msrpm(svm->msrpm);
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 51ebb60e1533..106fc6fceb97 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -437,11 +437,6 @@ static void vmx_inject_page_fault_nested(struct kvm_vcpu *vcpu,
>   	}
>   }
>   
> -static bool page_address_valid(struct kvm_vcpu *vcpu, gpa_t gpa)
> -{
> -	return PAGE_ALIGNED(gpa) && !(gpa >> cpuid_maxphyaddr(vcpu));
> -}
> -
>   static int nested_vmx_check_io_bitmap_controls(struct kvm_vcpu *vcpu,
>   					       struct vmcs12 *vmcs12)
>   {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f0fa610bed91..d4aa7dc662d5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4628,7 +4628,8 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>   
>   		if (kvm_state.flags &
>   		    ~(KVM_STATE_NESTED_RUN_PENDING | KVM_STATE_NESTED_GUEST_MODE
> -		      | KVM_STATE_NESTED_EVMCS | KVM_STATE_NESTED_MTF_PENDING))
> +		      | KVM_STATE_NESTED_EVMCS | KVM_STATE_NESTED_MTF_PENDING
> +		      | KVM_STATE_NESTED_GIF_SET))
>   			break;
>   
>   		/* nested_run_pending implies guest_mode.  */
