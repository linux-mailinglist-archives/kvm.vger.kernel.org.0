Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2E619CE29
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 03:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390258AbgDCBe0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 21:34:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38034 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390223AbgDCBe0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 21:34:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0331Xrwt165875;
        Fri, 3 Apr 2020 01:34:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=j+08PfmRnWNdrM0YxjwL4DzMLLgv6NLexUvaxQJ1IDE=;
 b=uFLKwJH0czwOocdxZYgbLu2sb4piBmOoguLGc9QC4x+37IowXDIxNlm34Dm0/J06SnXu
 xwPv+iwOCt6obU4HWzCDL8Kqb6u9xvJGo53AA1gbXkrrXnQezrPDULk4OkzriqG9dwgY
 J4yhaHJKP7MDerA1X59oV3uoZOBqFynsZRcxeiN5QLNswkuf7G6yI55gOgazt/mspEwf
 X10ge8Pv8ziVdlDtM/tfp1cGxRqi5uO/8m1DuaHi2TxeXz5YAugG+yZbKCnS71I5IcLE
 Tlr+zfGTdrelFvFrS7PTOVtukQsQgkUkeEv6NOW1Q+mtVOVMmstINi7MtMCy+NY/Gwc1 kQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 303aqhy1cg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 01:34:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0331SMA6083896;
        Fri, 3 Apr 2020 01:32:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 302g4wgpq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 01:31:59 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0331Vuus008600;
        Fri, 3 Apr 2020 01:31:57 GMT
Received: from localhost.localdomain (/10.159.142.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Apr 2020 18:31:56 -0700
Subject: Re: [PATCH v6 08/14] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
To:     Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <265ef8a0ab75f01bc673cce6ddcf7988c7623943.1585548051.git.ashish.kalra@amd.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <8d1baef8-c5ea-e8ac-0a9c-097aa20ea7aa@oracle.com>
Date:   Thu, 2 Apr 2020 18:31:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <265ef8a0ab75f01bc673cce6ddcf7988c7623943.1585548051.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=2
 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030009
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/29/20 11:22 PM, Ashish Kalra wrote:
> From: Brijesh Singh <Brijesh.Singh@amd.com>
>
> This hypercall is used by the SEV guest to notify a change in the page
> encryption status to the hypervisor. The hypercall should be invoked
> only when the encryption attribute is changed from encrypted -> decrypted
> and vice versa. By default all guest pages are considered encrypted.
>
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
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>   Documentation/virt/kvm/hypercalls.rst | 15 +++++
>   arch/x86/include/asm/kvm_host.h       |  2 +
>   arch/x86/kvm/svm.c                    | 95 +++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/vmx.c                |  1 +
>   arch/x86/kvm/x86.c                    |  6 ++
>   include/uapi/linux/kvm_para.h         |  1 +
>   6 files changed, 120 insertions(+)
>
> diff --git a/Documentation/virt/kvm/hypercalls.rst b/Documentation/virt/kvm/hypercalls.rst
> index dbaf207e560d..ff5287e68e81 100644
> --- a/Documentation/virt/kvm/hypercalls.rst
> +++ b/Documentation/virt/kvm/hypercalls.rst
> @@ -169,3 +169,18 @@ a0: destination APIC ID
>   
>   :Usage example: When sending a call-function IPI-many to vCPUs, yield if
>   	        any of the IPI target vCPUs was preempted.
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
> index 98959e8cd448..90718fa3db47 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1267,6 +1267,8 @@ struct kvm_x86_ops {
>   
>   	bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
>   	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
> +	int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
> +				  unsigned long sz, unsigned long mode);
>   };
>   
>   struct kvm_arch_async_pf {
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 7c2721e18b06..1d8beaf1bceb 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -136,6 +136,8 @@ struct kvm_sev_info {
>   	int fd;			/* SEV device fd */
>   	unsigned long pages_locked; /* Number of pages locked */
>   	struct list_head regions_list;  /* List of registered regions */
> +	unsigned long *page_enc_bmap;
> +	unsigned long page_enc_bmap_size;
>   };
>   
>   struct kvm_svm {
> @@ -1991,6 +1993,9 @@ static void sev_vm_destroy(struct kvm *kvm)
>   
>   	sev_unbind_asid(kvm, sev->handle);
>   	sev_asid_free(sev->asid);
> +
> +	kvfree(sev->page_enc_bmap);
> +	sev->page_enc_bmap = NULL;
>   }
>   
>   static void avic_vm_destroy(struct kvm *kvm)
> @@ -7593,6 +7598,94 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   	return ret;
>   }
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


Just wondering why we can't directly modify sev->page_enc_bmap.

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
> +static int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
> +				  unsigned long npages, unsigned long enc)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	kvm_pfn_t pfn_start, pfn_end;
> +	gfn_t gfn_start, gfn_end;
> +	int ret;
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


It seems is_error_noslot_pfn() covers both cases - i) gfn slot is 
absent, ii) failure to translate to pfn. So do we still need 
is_noslot_pfn() ?

> +
> +	mutex_lock(&kvm->lock);
> +	ret = sev_resize_page_enc_bitmap(kvm, gfn_end);
> +	if (ret)
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
> +	return ret;
> +}
> +
>   static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>   {
>   	struct kvm_sev_cmd sev_cmd;
> @@ -7995,6 +8088,8 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
>   	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
>   
>   	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
> +
> +	.page_enc_status_hc = svm_page_enc_status_hc,


Why not place it where other encryption ops are located ?

         ...

         .mem_enc_unreg_region

+      .page_enc_status_hc = svm_page_enc_status_hc

>   };
>   
>   static int __init svm_init(void)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 079d9fbf278e..f68e76ee7f9c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8001,6 +8001,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
>   	.nested_get_evmcs_version = NULL,
>   	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
>   	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
> +	.page_enc_status_hc = NULL,
>   };
>   
>   static void vmx_cleanup_l1d_flush(void)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index cf95c36cb4f4..68428eef2dde 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7564,6 +7564,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>   		kvm_sched_yield(vcpu->kvm, a0);
>   		ret = 0;
>   		break;
> +	case KVM_HC_PAGE_ENC_STATUS:
> +		ret = -KVM_ENOSYS;
> +		if (kvm_x86_ops->page_enc_status_hc)
> +			ret = kvm_x86_ops->page_enc_status_hc(vcpu->kvm,
> +					a0, a1, a2);
> +		break;
>   	default:
>   		ret = -KVM_ENOSYS;
>   		break;
> diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
> index 8b86609849b9..847b83b75dc8 100644
> --- a/include/uapi/linux/kvm_para.h
> +++ b/include/uapi/linux/kvm_para.h
> @@ -29,6 +29,7 @@
>   #define KVM_HC_CLOCK_PAIRING		9
>   #define KVM_HC_SEND_IPI		10
>   #define KVM_HC_SCHED_YIELD		11
> +#define KVM_HC_PAGE_ENC_STATUS		12
>   
>   /*
>    * hypercalls use architecture specific
