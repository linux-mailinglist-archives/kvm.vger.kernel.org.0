Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A23D91C4942
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 23:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgEDVwc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 17:52:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33578 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbgEDVwc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 17:52:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044Lneg9048000;
        Mon, 4 May 2020 21:52:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=PaqyVTFz1u3aOKtE931CrMvc7VQMfvnsQeVzYfvTaJo=;
 b=VrTErSqjiqH0MppK3BoA9lOyu1+j0ZXHKGS5apLwR52IFwvV91xBqW4885nTz7RJUxCT
 eKneJzS53s5n5g1sA5QiIwkImSzAoIysStQMTn5x0EOCbV5CgZWhMvpUBNVYP8HTgVGf
 3ldotHiNE/OZtS7KQM5eoh14vHumCJsgheRGZNqsMBjs5SiTxf4biBcBOm2mLg61piJI
 B2FJFkneVgSvta4EfUKVfE2pJC+i00lQLl8IBL47oa3iaPm6/6+Hcbc9qUI7SXXEOL4P
 75Txj3qCakpjohMQvjadbCwhOiodCPyi7IOw7+rk9fVYknm6czeMMqILfmecYrGMoxpp Qg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30s09r1k3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 21:52:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044LlcJg176376;
        Mon, 4 May 2020 21:52:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 30t1r3cn1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 21:52:11 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 044Lq8R4004149;
        Mon, 4 May 2020 21:52:09 GMT
Received: from vbusired-dt (/10.39.235.150)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 14:52:08 -0700
Date:   Mon, 4 May 2020 16:52:07 -0500
From:   Venu Busireddy <venu.busireddy@oracle.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        rientjes@google.com, brijesh.singh@amd.com
Subject: Re: [PATCH v7 09/18] KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP
 ioctl
Message-ID: <20200504215207.GC1700255@vbusired-dt>
References: <cover.1588234824.git.ashish.kalra@amd.com>
 <4f4246c58ab1ee7e61b72b0ef0a3b023d7976803.1588234824.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4f4246c58ab1ee7e61b72b0ef0a3b023d7976803.1588234824.git.ashish.kalra@amd.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040171
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-04-30 08:43:40 +0000, Ashish Kalra wrote:
> From: Brijesh Singh <Brijesh.Singh@amd.com>
> 
> The ioctl can be used to retrieve page encryption bitmap for a given
> gfn range.
> 
> Return the correct bitmap as per the number of pages being requested
> by the user. Ensure that we only copy bmap->num_pages bytes in the
> userspace buffer, if bmap->num_pages is not byte aligned we read
> the trailing bits from the userspace and copy those bits as is.
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
> Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  Documentation/virt/kvm/api.rst  | 27 +++++++++++++
>  arch/x86/include/asm/kvm_host.h |  2 +
>  arch/x86/kvm/svm/sev.c          | 70 +++++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c          |  1 +
>  arch/x86/kvm/svm/svm.h          |  1 +
>  arch/x86/kvm/x86.c              | 12 ++++++
>  include/uapi/linux/kvm.h        | 12 ++++++
>  7 files changed, 125 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index efbbe570aa9b..e2f0dd105b5c 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -4636,6 +4636,33 @@ This ioctl resets VCPU registers and control structures according to
>  the clear cpu reset definition in the POP. However, the cpu is not put
>  into ESA mode. This reset is a superset of the initial reset.
>  
> +4.125 KVM_GET_PAGE_ENC_BITMAP (vm ioctl)
> +---------------------------------------
> +
> +:Capability: basic
> +:Architectures: x86
> +:Type: vm ioctl
> +:Parameters: struct kvm_page_enc_bitmap (in/out)
> +:Returns: 0 on success, -1 on error
> +
> +/* for KVM_GET_PAGE_ENC_BITMAP */
> +struct kvm_page_enc_bitmap {
> +	__u64 start_gfn;
> +	__u64 num_pages;
> +	union {
> +		void __user *enc_bitmap; /* one bit per page */
> +		__u64 padding2;
> +	};
> +};
> +
> +The encrypted VMs have concept of private and shared pages. The private
> +page is encrypted with the guest-specific key, while shared page may
> +be encrypted with the hypervisor key. The KVM_GET_PAGE_ENC_BITMAP can
> +be used to get the bitmap indicating whether the guest page is private
> +or shared. The bitmap can be used during the guest migration, if the page
> +is private then userspace need to use SEV migration commands to transmit
> +the page.

Can you address the comments in the review of v6 patch?
(https://lore.kernel.org/kvm/20200403183046.GA727000@vbusired-dt/)

> +
>  
>  4.125 KVM_S390_PV_COMMAND
>  -------------------------
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 4a8ee22f4f5b..9e428befb6a4 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1256,6 +1256,8 @@ struct kvm_x86_ops {
>  	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
>  	int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
>  				  unsigned long sz, unsigned long mode);
> +	int (*get_page_enc_bitmap)(struct kvm *kvm,
> +				struct kvm_page_enc_bitmap *bmap);
>  };
>  
>  struct kvm_x86_init_ops {
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 7dc68db70405..73bbbffb3487 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1434,6 +1434,76 @@ int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
>  	return 0;
>  }
>  
> +int svm_get_page_enc_bitmap(struct kvm *kvm,
> +				   struct kvm_page_enc_bitmap *bmap)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	unsigned long gfn_start, gfn_end;
> +	unsigned long sz, i, sz_bytes;
> +	unsigned long *bitmap;
> +	int ret, n;
> +
> +	if (!sev_guest(kvm))
> +		return -ENOTTY;
> +
> +	gfn_start = bmap->start_gfn;
> +	gfn_end = gfn_start + bmap->num_pages;
> +
> +	sz = ALIGN(bmap->num_pages, BITS_PER_LONG) / BITS_PER_BYTE;
> +	bitmap = kmalloc(sz, GFP_KERNEL);
> +	if (!bitmap)
> +		return -ENOMEM;
> +
> +	/* by default all pages are marked encrypted */
> +	memset(bitmap, 0xff, sz);
> +
> +	mutex_lock(&kvm->lock);
> +	if (sev->page_enc_bmap) {
> +		i = gfn_start;
> +		for_each_clear_bit_from(i, sev->page_enc_bmap,
> +				      min(sev->page_enc_bmap_size, gfn_end))
> +			clear_bit(i - gfn_start, bitmap);
> +	}
> +	mutex_unlock(&kvm->lock);
> +
> +	ret = -EFAULT;
> +
> +	n = bmap->num_pages % BITS_PER_BYTE;
> +	sz_bytes = ALIGN(bmap->num_pages, BITS_PER_BYTE) / BITS_PER_BYTE;
> +
> +	/*
> +	 * Return the correct bitmap as per the number of pages being
> +	 * requested by the user. Ensure that we only copy bmap->num_pages
> +	 * bytes in the userspace buffer, if bmap->num_pages is not byte
> +	 * aligned we read the trailing bits from the userspace and copy
> +	 * those bits as is.
> +	 */
> +
> +	if (n) {
> +		unsigned char *bitmap_kernel = (unsigned char *)bitmap;
> +		unsigned char bitmap_user;
> +		unsigned long offset, mask;
> +
> +		offset = bmap->num_pages / BITS_PER_BYTE;
> +		if (copy_from_user(&bitmap_user, bmap->enc_bitmap + offset,
> +				sizeof(unsigned char)))
> +			goto out;
> +
> +		mask = GENMASK(n - 1, 0);
> +		bitmap_user &= ~mask;
> +		bitmap_kernel[offset] &= mask;
> +		bitmap_kernel[offset] |= bitmap_user;
> +	}
> +
> +	if (copy_to_user(bmap->enc_bitmap, bitmap, sz_bytes))
> +		goto out;
> +
> +	ret = 0;
> +out:
> +	kfree(bitmap);
> +	return ret;
> +}
> +
>  int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_sev_cmd sev_cmd;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 1013ef0f4ce2..588709a9f68e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4016,6 +4016,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.check_nested_events = svm_check_nested_events,
>  
>  	.page_enc_status_hc = svm_page_enc_status_hc,
> +	.get_page_enc_bitmap = svm_get_page_enc_bitmap,
>  };
>  
>  static struct kvm_x86_init_ops svm_init_ops __initdata = {
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 6a562f5928a2..f087fa7b380c 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -404,6 +404,7 @@ int svm_check_nested_events(struct kvm_vcpu *vcpu);
>  int nested_svm_exit_special(struct vcpu_svm *svm);
>  int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
>  				  unsigned long npages, unsigned long enc);
> +int svm_get_page_enc_bitmap(struct kvm *kvm, struct kvm_page_enc_bitmap *bmap);
>  
>  /* avic.c */
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5f5ddb5765e2..937797cfaf9a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5208,6 +5208,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  	case KVM_SET_PMU_EVENT_FILTER:
>  		r = kvm_vm_ioctl_set_pmu_event_filter(kvm, argp);
>  		break;
> +	case KVM_GET_PAGE_ENC_BITMAP: {
> +		struct kvm_page_enc_bitmap bitmap;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&bitmap, argp, sizeof(bitmap)))
> +			goto out;
> +
> +		r = -ENOTTY;
> +		if (kvm_x86_ops.get_page_enc_bitmap)
> +			r = kvm_x86_ops.get_page_enc_bitmap(kvm, &bitmap);
> +		break;
> +	}
>  	default:
>  		r = -ENOTTY;
>  	}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 0fe1d206d750..af62f2afaa5d 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -505,6 +505,16 @@ struct kvm_dirty_log {
>  	};
>  };
>  
> +/* for KVM_GET_PAGE_ENC_BITMAP */
> +struct kvm_page_enc_bitmap {
> +	__u64 start_gfn;
> +	__u64 num_pages;
> +	union {
> +		void __user *enc_bitmap; /* one bit per page */
> +		__u64 padding2;
> +	};
> +};
> +
>  /* for KVM_CLEAR_DIRTY_LOG */
>  struct kvm_clear_dirty_log {
>  	__u32 slot;
> @@ -1518,6 +1528,8 @@ struct kvm_pv_cmd {
>  /* Available with KVM_CAP_S390_PROTECTED */
>  #define KVM_S390_PV_COMMAND		_IOWR(KVMIO, 0xc5, struct kvm_pv_cmd)
>  
> +#define KVM_GET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc6, struct kvm_page_enc_bitmap)
> +
>  /* Secure Encrypted Virtualization command */
>  enum sev_cmd_id {
>  	/* Guest initialization commands */
> -- 
> 2.17.1
> 
