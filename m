Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4C02CC2D1
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 17:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728586AbgLBQ4q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 11:56:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38622 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727826AbgLBQ4o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Dec 2020 11:56:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606928116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7d+ODyxw2BpfIDkA7n8FBbX/gBxpW+0DWJBwsQ2CH/0=;
        b=JBflWaO3oiTiZFEVK9BaPJuSFnFnk33jNTdBuj6WHedLZ8nm+hd6lwog60tcBoVRzKhHVR
        SDJlRppN5qy+5aERDGN5pM3QVEt5QHZ8CyYz9NKwNfc9HxBZ5fv79/woKtv7SUNDKBPdfX
        GPlpI5JGtNoIdNQCpINcMBrMx8dRq10=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-EBsUfN_SN2G-6-XWAMdKJw-1; Wed, 02 Dec 2020 11:55:12 -0500
X-MC-Unique: EBsUfN_SN2G-6-XWAMdKJw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 225D3814413;
        Wed,  2 Dec 2020 16:54:27 +0000 (UTC)
Received: from work-vm (unknown [10.33.36.90])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E2D060BFA;
        Wed,  2 Dec 2020 16:54:23 +0000 (UTC)
Date:   Wed, 2 Dec 2020 16:54:20 +0000
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        brijesh.singh@amd.com, dovmurik@linux.vnet.ibm.com, tobin@ibm.com,
        jejb@linux.ibm.com, frankeh@us.ibm.com
Subject: Re: [PATCH v2 2/9] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
Message-ID: <20201202165420.GI3226@work-vm>
References: <cover.1606782580.git.ashish.kalra@amd.com>
 <40acca4b49cd904ea73038309908151508fb555c.1606782580.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <40acca4b49cd904ea73038309908151508fb555c.1606782580.git.ashish.kalra@amd.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Ashish Kalra (Ashish.Kalra@amd.com) wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> This hypercall is used by the SEV guest to notify a change in the page
> encryption status to the hypervisor. The hypercall should be invoked
> only when the encryption attribute is changed from encrypted -> decrypted
> and vice versa. By default all guest pages are considered encrypted.

Is it defined whether these are supposed to be called before or after
the the page type has been changed; is it change the type and then
notify or the other way around?

Dave

> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  Documentation/virt/kvm/hypercalls.rst | 15 +++++
>  arch/x86/include/asm/kvm_host.h       |  2 +
>  arch/x86/kvm/svm/sev.c                | 90 +++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c                |  2 +
>  arch/x86/kvm/svm/svm.h                |  4 ++
>  arch/x86/kvm/vmx/vmx.c                |  1 +
>  arch/x86/kvm/x86.c                    |  6 ++
>  include/uapi/linux/kvm_para.h         |  1 +
>  8 files changed, 121 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/hypercalls.rst b/Documentation/virt/kvm/hypercalls.rst
> index ed4fddd364ea..7aff0cebab7c 100644
> --- a/Documentation/virt/kvm/hypercalls.rst
> +++ b/Documentation/virt/kvm/hypercalls.rst
> @@ -169,3 +169,18 @@ a0: destination APIC ID
>  
>  :Usage example: When sending a call-function IPI-many to vCPUs, yield if
>  	        any of the IPI target vCPUs was preempted.
> +
> +
> +8. KVM_HC_PAGE_ENC_STATUS
> +-------------------------
> +:Architecture: x86
> +:Status: active
> +:Purpose: Notify the encryption status changes in guest page table (SEV guest)
> +
> +a0: the guest physical address of the start page
> +a1: the number of pages
> +a2: encryption attribute
> +
> +   Where:
> +	* 1: Encryption attribute is set
> +	* 0: Encryption attribute is cleared
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f002cdb13a0b..d035dc983a7a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1282,6 +1282,8 @@ struct kvm_x86_ops {
>  
>  	void (*migrate_timers)(struct kvm_vcpu *vcpu);
>  	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
> +	int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
> +				  unsigned long sz, unsigned long mode);
>  };
>  
>  struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c0b14106258a..6b8bc1297f9c 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -927,6 +927,93 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	return ret;
>  }
>  
> +static int sev_resize_page_enc_bitmap(struct kvm *kvm, unsigned long new_size)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	unsigned long *map;
> +	unsigned long sz;
> +
> +	if (sev->page_enc_bmap_size >= new_size)
> +		return 0;
> +
> +	sz = ALIGN(new_size, BITS_PER_LONG) / 8;
> +
> +	map = vmalloc(sz);
> +	if (!map) {
> +		pr_err_once("Failed to allocate encrypted bitmap size %lx\n",
> +				sz);
> +		return -ENOMEM;
> +	}
> +
> +	/* mark the page encrypted (by default) */
> +	memset(map, 0xff, sz);
> +
> +	bitmap_copy(map, sev->page_enc_bmap, sev->page_enc_bmap_size);
> +	kvfree(sev->page_enc_bmap);
> +
> +	sev->page_enc_bmap = map;
> +	sev->page_enc_bmap_size = new_size;
> +
> +	return 0;
> +}
> +
> +int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
> +				  unsigned long npages, unsigned long enc)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	kvm_pfn_t pfn_start, pfn_end;
> +	gfn_t gfn_start, gfn_end;
> +
> +	if (!sev_guest(kvm))
> +		return -EINVAL;
> +
> +	if (!npages)
> +		return 0;
> +
> +	gfn_start = gpa_to_gfn(gpa);
> +	gfn_end = gfn_start + npages;
> +
> +	/* out of bound access error check */
> +	if (gfn_end <= gfn_start)
> +		return -EINVAL;
> +
> +	/* lets make sure that gpa exist in our memslot */
> +	pfn_start = gfn_to_pfn(kvm, gfn_start);
> +	pfn_end = gfn_to_pfn(kvm, gfn_end);
> +
> +	if (is_error_noslot_pfn(pfn_start) && !is_noslot_pfn(pfn_start)) {
> +		/*
> +		 * Allow guest MMIO range(s) to be added
> +		 * to the page encryption bitmap.
> +		 */
> +		return -EINVAL;
> +	}
> +
> +	if (is_error_noslot_pfn(pfn_end) && !is_noslot_pfn(pfn_end)) {
> +		/*
> +		 * Allow guest MMIO range(s) to be added
> +		 * to the page encryption bitmap.
> +		 */
> +		return -EINVAL;
> +	}
> +
> +	mutex_lock(&kvm->lock);
> +
> +	if (sev->page_enc_bmap_size < gfn_end)
> +		goto unlock;
> +
> +	if (enc)
> +		__bitmap_set(sev->page_enc_bmap, gfn_start,
> +				gfn_end - gfn_start);
> +	else
> +		__bitmap_clear(sev->page_enc_bmap, gfn_start,
> +				gfn_end - gfn_start);
> +
> +unlock:
> +	mutex_unlock(&kvm->lock);
> +	return 0;
> +}
> +
>  int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_sev_cmd sev_cmd;
> @@ -1123,6 +1210,9 @@ void sev_vm_destroy(struct kvm *kvm)
>  
>  	sev_unbind_asid(kvm, sev->handle);
>  	sev_asid_free(sev->asid);
> +
> +	kvfree(sev->page_enc_bmap);
> +	sev->page_enc_bmap = NULL;
>  }
>  
>  int __init sev_hardware_setup(void)
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 6dc337b9c231..7122ea5f7c47 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4312,6 +4312,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
>  
>  	.msr_filter_changed = svm_msr_filter_changed,
> +
> +	.page_enc_status_hc = svm_page_enc_status_hc,
>  };
>  
>  static struct kvm_x86_init_ops svm_init_ops __initdata = {
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index fdff76eb6ceb..0103a23ca174 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -66,6 +66,8 @@ struct kvm_sev_info {
>  	int fd;			/* SEV device fd */
>  	unsigned long pages_locked; /* Number of pages locked */
>  	struct list_head regions_list;  /* List of registered regions */
> +	unsigned long *page_enc_bmap;
> +	unsigned long page_enc_bmap_size;
>  };
>  
>  struct kvm_svm {
> @@ -409,6 +411,8 @@ int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
>  			       bool has_error_code, u32 error_code);
>  int nested_svm_exit_special(struct vcpu_svm *svm);
>  void sync_nested_vmcb_control(struct vcpu_svm *svm);
> +int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
> +                           unsigned long npages, unsigned long enc);
>  
>  extern struct kvm_x86_nested_ops svm_nested_ops;
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c3441e7e5a87..5bc37a38e6be 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7722,6 +7722,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>  
>  	.msr_filter_changed = vmx_msr_filter_changed,
>  	.cpu_dirty_log_size = vmx_cpu_dirty_log_size,
> +	.page_enc_status_hc = NULL,
>  };
>  
>  static __init int hardware_setup(void)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a3fdc16cfd6f..3afc78f18f69 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8125,6 +8125,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  		kvm_sched_yield(vcpu->kvm, a0);
>  		ret = 0;
>  		break;
> +	case KVM_HC_PAGE_ENC_STATUS:
> +		ret = -KVM_ENOSYS;
> +		if (kvm_x86_ops.page_enc_status_hc)
> +			ret = kvm_x86_ops.page_enc_status_hc(vcpu->kvm,
> +					a0, a1, a2);
> +		break;
>  	default:
>  		ret = -KVM_ENOSYS;
>  		break;
> diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
> index 8b86609849b9..847b83b75dc8 100644
> --- a/include/uapi/linux/kvm_para.h
> +++ b/include/uapi/linux/kvm_para.h
> @@ -29,6 +29,7 @@
>  #define KVM_HC_CLOCK_PAIRING		9
>  #define KVM_HC_SEND_IPI		10
>  #define KVM_HC_SCHED_YIELD		11
> +#define KVM_HC_PAGE_ENC_STATUS		12
>  
>  /*
>   * hypercalls use architecture specific
> -- 
> 2.17.1
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

