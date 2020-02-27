Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE4991726E7
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 19:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730413AbgB0STc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 13:19:32 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38158 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729536AbgB0STc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 13:19:32 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RIHidk030820;
        Thu, 27 Feb 2020 18:19:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=UCOWi6xTqALc4+GIlAcZUMnpHO1zAlGEODpt199CDEI=;
 b=EIK/Yfk3NWvfeVVaLcaUlOQyRZ0wRdOlGNwuBvx0LKRkxf6xqdTYSR9sU9V6Bflh7hOv
 AIo3uU/eNlZIhpja9lC2kD8NtmxoDb4pVtDJuVCcElKfaBtnf+fBjUtgu627r3g40K74
 m7otV3OKXyjEZ2gclad25UJx/tY+ZHlIz/o6WKSttBIhLB2hXisashEdHrbcMqJYVUAt
 p6O9fD6w0sUs/pARBy/P0OIPjXUHDJCiRPSOJQKvJngVjvUo2X6+2mVFja/Yl3IYkObm
 1rigG1ttxY8QGyhZsquPLip2Nln+dakLu/NBvqENj2dgkQS9990+I78zYvMvJcfeNrxK rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2yehxrrcgq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 18:19:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RIIT8A068806;
        Thu, 27 Feb 2020 18:19:03 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2ydcsa3u0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 18:19:03 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01RIJ0Du009775;
        Thu, 27 Feb 2020 18:19:01 GMT
Received: from vbusired-dt (/10.154.159.233)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Feb 2020 10:19:00 -0800
Date:   Thu, 27 Feb 2020 12:18:58 -0600
From:   Venu Busireddy <venu.busireddy@oracle.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, rientjes@google.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/12] KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP ioctl
Message-ID: <20200227181858.GA268538@vbusired-dt>
References: <cover.1581555616.git.ashish.kalra@amd.com>
 <efe6a4d829af0b2ed9fe1b58fd2dfb343f5b8de0.1581555616.git.ashish.kalra@amd.com>
 <20200227175748.GA268253@vbusired-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200227175748.GA268253@vbusired-dt>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=2 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 bulkscore=0 phishscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 suspectscore=2 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270130
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-02-27 11:57:50 -0600, Venu Busireddy wrote:
> On 2020-02-13 01:17:45 +0000, Ashish Kalra wrote:
> > From: Brijesh Singh <brijesh.singh@amd.com>
> > 
> > The ioctl can be used to retrieve page encryption bitmap for a given
> > gfn range.
> > 
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Cc: Borislav Petkov <bp@suse.de>
> > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > Cc: x86@kernel.org
> > Cc: kvm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> 
> This patch does not apply to upstream Linux version 5.5.6.
> 
>   <snip>
>   Applying: KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP ioctl
>   error: patch failed: Documentation/virt/kvm/api.txt:4213
>   error: Documentation/virt/kvm/api.txt: patch does not apply
>   error: patch failed: include/uapi/linux/kvm.h:1478
>   error: include/uapi/linux/kvm.h: patch does not apply
>   Patch failed at 0009 KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP ioctl
>   <snip>
> 
> Which kernel version does this patch series apply to, cleanly?

Tried git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git.
With that, patch 08/12 fails with the top of that tree, as well as
tag v5.6-rc3.

> Thanks,
> 
> Venu
> 
> > ---
> >  Documentation/virt/kvm/api.txt  | 27 +++++++++++++++++++++
> >  arch/x86/include/asm/kvm_host.h |  2 ++
> >  arch/x86/kvm/svm.c              | 43 +++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/x86.c              | 12 +++++++++
> >  include/uapi/linux/kvm.h        | 12 +++++++++
> >  5 files changed, 96 insertions(+)
> > 
> > diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
> > index c6e1ce5d40de..053aecfabe74 100644
> > --- a/Documentation/virt/kvm/api.txt
> > +++ b/Documentation/virt/kvm/api.txt
> > @@ -4213,6 +4213,33 @@ the clear cpu reset definition in the POP. However, the cpu is not put
> >  into ESA mode. This reset is a superset of the initial reset.
> >  
> >  
> > +4.120 KVM_GET_PAGE_ENC_BITMAP (vm ioctl)
> > +
> > +Capability: basic
> > +Architectures: x86
> > +Type: vm ioctl
> > +Parameters: struct kvm_page_enc_bitmap (in/out)
> > +Returns: 0 on success, -1 on error
> > +
> > +/* for KVM_GET_PAGE_ENC_BITMAP */
> > +struct kvm_page_enc_bitmap {
> > +	__u64 start_gfn;
> > +	__u64 num_pages;
> > +	union {
> > +		void __user *enc_bitmap; /* one bit per page */
> > +		__u64 padding2;
> > +	};
> > +};
> > +
> > +The encrypted VMs have concept of private and shared pages. The private
> > +page is encrypted with the guest-specific key, while shared page may
> > +be encrypted with the hypervisor key. The KVM_GET_PAGE_ENC_BITMAP can
> > +be used to get the bitmap indicating whether the guest page is private
> > +or shared. The bitmap can be used during the guest migration, if the page
> > +is private then userspace need to use SEV migration commands to transmit
> > +the page.
> > +
> > +
> >  5. The kvm_run structure
> >  ------------------------
> >  
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 4ae7293033b2..a6882c5214b4 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1258,6 +1258,8 @@ struct kvm_x86_ops {
> >  	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
> >  	int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
> >  				  unsigned long sz, unsigned long mode);
> > +	int (*get_page_enc_bitmap)(struct kvm *kvm,
> > +				struct kvm_page_enc_bitmap *bmap);
> >  };
> >  
> >  struct kvm_arch_async_pf {
> > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > index f09791109075..f1c8806a97c6 100644
> > --- a/arch/x86/kvm/svm.c
> > +++ b/arch/x86/kvm/svm.c
> > @@ -7673,6 +7673,48 @@ static int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
> >  	return ret;
> >  }
> >  
> > +static int svm_get_page_enc_bitmap(struct kvm *kvm,
> > +				   struct kvm_page_enc_bitmap *bmap)
> > +{
> > +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > +	unsigned long gfn_start, gfn_end;
> > +	unsigned long *bitmap;
> > +	unsigned long sz, i;
> > +	int ret;
> > +
> > +	if (!sev_guest(kvm))
> > +		return -ENOTTY;
> > +
> > +	gfn_start = bmap->start_gfn;
> > +	gfn_end = gfn_start + bmap->num_pages;
> > +
> > +	sz = ALIGN(bmap->num_pages, BITS_PER_LONG) / 8;
> > +	bitmap = kmalloc(sz, GFP_KERNEL);
> > +	if (!bitmap)
> > +		return -ENOMEM;
> > +
> > +	/* by default all pages are marked encrypted */
> > +	memset(bitmap, 0xff, sz);
> > +
> > +	mutex_lock(&kvm->lock);
> > +	if (sev->page_enc_bmap) {
> > +		i = gfn_start;
> > +		for_each_clear_bit_from(i, sev->page_enc_bmap,
> > +				      min(sev->page_enc_bmap_size, gfn_end))
> > +			clear_bit(i - gfn_start, bitmap);
> > +	}
> > +	mutex_unlock(&kvm->lock);
> > +
> > +	ret = -EFAULT;
> > +	if (copy_to_user(bmap->enc_bitmap, bitmap, sz))
> > +		goto out;
> > +
> > +	ret = 0;
> > +out:
> > +	kfree(bitmap);
> > +	return ret;
> > +}
> > +
> >  static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> >  {
> >  	struct kvm_sev_cmd sev_cmd;
> > @@ -8066,6 +8108,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
> >  	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
> >  
> >  	.page_enc_status_hc = svm_page_enc_status_hc,
> > +	.get_page_enc_bitmap = svm_get_page_enc_bitmap,
> >  };
> >  
> >  static int __init svm_init(void)
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 298627fa3d39..e955f886ee17 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -5213,6 +5213,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
> >  	case KVM_SET_PMU_EVENT_FILTER:
> >  		r = kvm_vm_ioctl_set_pmu_event_filter(kvm, argp);
> >  		break;
> > +	case KVM_GET_PAGE_ENC_BITMAP: {
> > +		struct kvm_page_enc_bitmap bitmap;
> > +
> > +		r = -EFAULT;
> > +		if (copy_from_user(&bitmap, argp, sizeof(bitmap)))
> > +			goto out;
> > +
> > +		r = -ENOTTY;
> > +		if (kvm_x86_ops->get_page_enc_bitmap)
> > +			r = kvm_x86_ops->get_page_enc_bitmap(kvm, &bitmap);
> > +		break;
> > +	}
> >  	default:
> >  		r = -ENOTTY;
> >  	}
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 4e80c57a3182..9377b26c5f4e 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -500,6 +500,16 @@ struct kvm_dirty_log {
> >  	};
> >  };
> >  
> > +/* for KVM_GET_PAGE_ENC_BITMAP */
> > +struct kvm_page_enc_bitmap {
> > +	__u64 start_gfn;
> > +	__u64 num_pages;
> > +	union {
> > +		void __user *enc_bitmap; /* one bit per page */
> > +		__u64 padding2;
> > +	};
> > +};
> > +
> >  /* for KVM_CLEAR_DIRTY_LOG */
> >  struct kvm_clear_dirty_log {
> >  	__u32 slot;
> > @@ -1478,6 +1488,8 @@ struct kvm_enc_region {
> >  #define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
> >  #define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
> >  
> > +#define KVM_GET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc2, struct kvm_page_enc_bitmap)
> > +
> >  /* Secure Encrypted Virtualization command */
> >  enum sev_cmd_id {
> >  	/* Guest initialization commands */
> > -- 
> > 2.17.1
> > 
