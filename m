Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12A4119E028
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 23:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgDCVLJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 17:11:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42122 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbgDCVLJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 17:11:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033L92HC132796;
        Fri, 3 Apr 2020 21:10:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=9NtL6bJW3Vibj3T2e+wi14Zc2JO1BYTNJgCkJSHA8U0=;
 b=sUr7HY1KQlCqkIYO0JIzEbvDqNDsX0IQdCE7IIrtd1Ui1u8Y5P4henunpIpVFnBnhOE+
 XVjtCHDSa83W5g3x1alQviV981Y8pN6S+1iDT8CWdY84J//Objh4qsrMHK0BJKliNovT
 o8U2/NHxw9Ey5Zw8RtfrPq8RS2BP/UMKKko89U342DRBWup/JY2e6C0UpLTfjmMbJ/OY
 5asofsZ4DAi6p7Uj2Gyp5KKp9wLoL0w1qbyyBAtg2ds0R3jhg0SdMTRZsifqcK6l+UWJ
 Ih2FRSivIx+/JTYCdwuOLYnVEQ+6ymvsrWRmYGXO8Uei0WE6e56zmAXLpzc1TJSdt96X kQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 303aqj3qdk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 21:10:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033L8WIQ150198;
        Fri, 3 Apr 2020 21:10:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 302g4y6yym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 21:10:47 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 033LAiZi016759;
        Fri, 3 Apr 2020 21:10:44 GMT
Received: from localhost.localdomain (/10.159.159.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 14:10:44 -0700
Subject: Re: [PATCH v6 11/14] KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP
 ioctl
To:     Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <4d4fbe2b9acda82c04834682900acf782182ec23.1585548051.git.ashish.kalra@amd.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <56d25d86-f66c-d68c-a6ea-17a99927f3cd@oracle.com>
Date:   Fri, 3 Apr 2020 14:10:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <4d4fbe2b9acda82c04834682900acf782182ec23.1585548051.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030166
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030166
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/29/20 11:22 PM, Ashish Kalra wrote:
> From: Brijesh Singh <Brijesh.Singh@amd.com>
>
> The ioctl can be used to set page encryption bitmap for an
> incoming guest.
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
>   Documentation/virt/kvm/api.rst  | 22 +++++++++++++++++
>   arch/x86/include/asm/kvm_host.h |  2 ++
>   arch/x86/kvm/svm.c              | 42 +++++++++++++++++++++++++++++++++
>   arch/x86/kvm/x86.c              | 12 ++++++++++
>   include/uapi/linux/kvm.h        |  1 +
>   5 files changed, 79 insertions(+)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 8ad800ebb54f..4d1004a154f6 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -4675,6 +4675,28 @@ or shared. The bitmap can be used during the guest migration, if the page
>   is private then userspace need to use SEV migration commands to transmit
>   the page.
>   
> +4.126 KVM_SET_PAGE_ENC_BITMAP (vm ioctl)
> +---------------------------------------
> +
> +:Capability: basic
> +:Architectures: x86
> +:Type: vm ioctl
> +:Parameters: struct kvm_page_enc_bitmap (in/out)
> +:Returns: 0 on success, -1 on error
> +
> +/* for KVM_SET_PAGE_ENC_BITMAP */
> +struct kvm_page_enc_bitmap {
> +	__u64 start_gfn;
> +	__u64 num_pages;
> +	union {
> +		void __user *enc_bitmap; /* one bit per page */
> +		__u64 padding2;
> +	};
> +};
> +
> +During the guest live migration the outgoing guest exports its page encryption
> +bitmap, the KVM_SET_PAGE_ENC_BITMAP can be used to build the page encryption
> +bitmap for an incoming guest.
>   
>   5. The kvm_run structure
>   ========================
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 27e43e3ec9d8..d30f770aaaea 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1271,6 +1271,8 @@ struct kvm_x86_ops {
>   				  unsigned long sz, unsigned long mode);
>   	int (*get_page_enc_bitmap)(struct kvm *kvm,
>   				struct kvm_page_enc_bitmap *bmap);
> +	int (*set_page_enc_bitmap)(struct kvm *kvm,
> +				struct kvm_page_enc_bitmap *bmap);
>   };
>   
>   struct kvm_arch_async_pf {
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index bae783cd396a..313343a43045 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -7756,6 +7756,47 @@ static int svm_get_page_enc_bitmap(struct kvm *kvm,
>   	return ret;
>   }
>   
> +static int svm_set_page_enc_bitmap(struct kvm *kvm,
> +				   struct kvm_page_enc_bitmap *bmap)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	unsigned long gfn_start, gfn_end;
> +	unsigned long *bitmap;
> +	unsigned long sz, i;
> +	int ret;
> +
> +	if (!sev_guest(kvm))
> +		return -ENOTTY;
> +
> +	gfn_start = bmap->start_gfn;
> +	gfn_end = gfn_start + bmap->num_pages;


Same comment as the previous one. Do we continue if num_pages is zero ?

> +
> +	sz = ALIGN(bmap->num_pages, BITS_PER_LONG) / 8;
> +	bitmap = kmalloc(sz, GFP_KERNEL);
> +	if (!bitmap)
> +		return -ENOMEM;
> +
> +	ret = -EFAULT;
> +	if (copy_from_user(bitmap, bmap->enc_bitmap, sz))
> +		goto out;
> +
> +	mutex_lock(&kvm->lock);
> +	ret = sev_resize_page_enc_bitmap(kvm, gfn_end);
> +	if (ret)
> +		goto unlock;
> +
> +	i = gfn_start;
> +	for_each_clear_bit_from(i, bitmap, (gfn_end - gfn_start))
> +		clear_bit(i + gfn_start, sev->page_enc_bmap);
> +
> +	ret = 0;
> +unlock:
> +	mutex_unlock(&kvm->lock);
> +out:
> +	kfree(bitmap);
> +	return ret;
> +}
> +
>   static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>   {
>   	struct kvm_sev_cmd sev_cmd;
> @@ -8161,6 +8202,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
>   
>   	.page_enc_status_hc = svm_page_enc_status_hc,
>   	.get_page_enc_bitmap = svm_get_page_enc_bitmap,
> +	.set_page_enc_bitmap = svm_set_page_enc_bitmap,
>   };
>   
>   static int __init svm_init(void)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3c3fea4e20b5..05e953b2ec61 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5238,6 +5238,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
>   			r = kvm_x86_ops->get_page_enc_bitmap(kvm, &bitmap);
>   		break;
>   	}
> +	case KVM_SET_PAGE_ENC_BITMAP: {
> +		struct kvm_page_enc_bitmap bitmap;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&bitmap, argp, sizeof(bitmap)))
> +			goto out;
> +
> +		r = -ENOTTY;
> +		if (kvm_x86_ops->set_page_enc_bitmap)
> +			r = kvm_x86_ops->set_page_enc_bitmap(kvm, &bitmap);
> +		break;
> +	}
>   	default:
>   		r = -ENOTTY;
>   	}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index db1ebf85e177..b4b01d47e568 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1489,6 +1489,7 @@ struct kvm_enc_region {
>   #define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
>   
>   #define KVM_GET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc5, struct kvm_page_enc_bitmap)
> +#define KVM_SET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc6, struct kvm_page_enc_bitmap)
>   
>   /* Secure Encrypted Virtualization command */
>   enum sev_cmd_id {
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
