Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7854A19E09F
	for <lists+kvm@lfdr.de>; Sat,  4 Apr 2020 00:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbgDCWEW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 18:04:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33238 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727924AbgDCWEW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 18:04:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033Lrax6096174;
        Fri, 3 Apr 2020 22:04:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=5jW1Wzm7zEMLhx2xwM/U535iraCz0A9wo/tTcX6MZuk=;
 b=rNWfSoeND3DS/kxREHuSjzO903eYJRM0Npz9b4+RpjEwahcsY7MT0s7b3ZShAAWW3H6B
 g86MkHTNlTlj4UGr4jv3oTYURwgYxIkahaHzjQZtY6+IXnBX4Law4X0QR0LP9Bdu3jOq
 F+Sgu1GpP/QnZjugZV9UJfS5fTmtjNx0JEqBCM2AN7GowP9MQe9XkGpX8z3BVDDBz97F
 HYV6AoaMHnApi8Hppa8kE3KyAPELxF2eHJH+YUN+uwCm+KaaOVAnEA9eVmFGf7ZrxRKO
 9lyeAJSTL3Al3QBzezSWIStW/UziFtXxWeRb7Fe0VM3cNOQ3pwg0IRtGRKNMOam9GG+O 0Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 303aqj3vn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 22:04:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033LqRIP017160;
        Fri, 3 Apr 2020 22:01:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 302g4y92fh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 22:01:59 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 033M1uVu006426;
        Fri, 3 Apr 2020 22:01:57 GMT
Received: from vbusired-dt (/10.154.116.130)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 15:01:56 -0700
Date:   Fri, 3 Apr 2020 17:01:51 -0500
From:   Venu Busireddy <venu.busireddy@oracle.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        srutherford@google.com, luto@kernel.org, brijesh.singh@amd.com
Subject: Re: [PATCH v6 12/14] KVM: x86: Introduce KVM_PAGE_ENC_BITMAP_RESET
 ioctl
Message-ID: <20200403220151.GA730828@vbusired-dt>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <9e959ee134ad77f62c9881b8c54cd27e35055072.1585548051.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e959ee134ad77f62c9881b8c54cd27e35055072.1585548051.git.ashish.kalra@amd.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=1
 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030169
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-03-30 06:23:10 +0000, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> This ioctl can be used by the application to reset the page
> encryption bitmap managed by the KVM driver. A typical usage
> for this ioctl is on VM reboot, on reboot, we must reinitialize
> the bitmap.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>

> ---
>  Documentation/virt/kvm/api.rst  | 13 +++++++++++++
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/svm.c              | 16 ++++++++++++++++
>  arch/x86/kvm/x86.c              |  6 ++++++
>  include/uapi/linux/kvm.h        |  1 +
>  5 files changed, 37 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 4d1004a154f6..a11326ccc51d 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -4698,6 +4698,19 @@ During the guest live migration the outgoing guest exports its page encryption
>  bitmap, the KVM_SET_PAGE_ENC_BITMAP can be used to build the page encryption
>  bitmap for an incoming guest.
>  
> +4.127 KVM_PAGE_ENC_BITMAP_RESET (vm ioctl)
> +-----------------------------------------
> +
> +:Capability: basic
> +:Architectures: x86
> +:Type: vm ioctl
> +:Parameters: none
> +:Returns: 0 on success, -1 on error
> +
> +The KVM_PAGE_ENC_BITMAP_RESET is used to reset the guest's page encryption
> +bitmap during guest reboot and this is only done on the guest's boot vCPU.
> +
> +
>  5. The kvm_run structure
>  ========================
>  
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d30f770aaaea..a96ef6338cd2 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1273,6 +1273,7 @@ struct kvm_x86_ops {
>  				struct kvm_page_enc_bitmap *bmap);
>  	int (*set_page_enc_bitmap)(struct kvm *kvm,
>  				struct kvm_page_enc_bitmap *bmap);
> +	int (*reset_page_enc_bitmap)(struct kvm *kvm);
>  };
>  
>  struct kvm_arch_async_pf {
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 313343a43045..c99b0207a443 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -7797,6 +7797,21 @@ static int svm_set_page_enc_bitmap(struct kvm *kvm,
>  	return ret;
>  }
>  
> +static int svm_reset_page_enc_bitmap(struct kvm *kvm)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +
> +	if (!sev_guest(kvm))
> +		return -ENOTTY;
> +
> +	mutex_lock(&kvm->lock);
> +	/* by default all pages should be marked encrypted */
> +	if (sev->page_enc_bmap_size)
> +		bitmap_fill(sev->page_enc_bmap, sev->page_enc_bmap_size);
> +	mutex_unlock(&kvm->lock);
> +	return 0;
> +}
> +
>  static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_sev_cmd sev_cmd;
> @@ -8203,6 +8218,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
>  	.page_enc_status_hc = svm_page_enc_status_hc,
>  	.get_page_enc_bitmap = svm_get_page_enc_bitmap,
>  	.set_page_enc_bitmap = svm_set_page_enc_bitmap,
> +	.reset_page_enc_bitmap = svm_reset_page_enc_bitmap,
>  };
>  
>  static int __init svm_init(void)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 05e953b2ec61..2127ed937f53 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5250,6 +5250,12 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  			r = kvm_x86_ops->set_page_enc_bitmap(kvm, &bitmap);
>  		break;
>  	}
> +	case KVM_PAGE_ENC_BITMAP_RESET: {
> +		r = -ENOTTY;
> +		if (kvm_x86_ops->reset_page_enc_bitmap)
> +			r = kvm_x86_ops->reset_page_enc_bitmap(kvm);
> +		break;
> +	}
>  	default:
>  		r = -ENOTTY;
>  	}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index b4b01d47e568..0884a581fc37 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1490,6 +1490,7 @@ struct kvm_enc_region {
>  
>  #define KVM_GET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc5, struct kvm_page_enc_bitmap)
>  #define KVM_SET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc6, struct kvm_page_enc_bitmap)
> +#define KVM_PAGE_ENC_BITMAP_RESET	_IO(KVMIO, 0xc7)
>  
>  /* Secure Encrypted Virtualization command */
>  enum sev_cmd_id {
> -- 
> 2.17.1
> 
