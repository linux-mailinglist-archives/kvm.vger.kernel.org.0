Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0B419E037
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 23:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgDCVPB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 17:15:01 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57088 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727809AbgDCVPB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 17:15:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033LDhRM179303;
        Fri, 3 Apr 2020 21:14:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=lAFN7mAESPzYll9xPCsRkmxIqI6EVsbBX20TXlp5u6c=;
 b=qMy9Ve5Vkgg082L1gSU2Z99BR3L1iqKKWVzQsSMD27hapkBqSFWtqMApwv4ab5CDjs4r
 xW7NZ5DZl1MVFOWn8NlVdcdRwz9/yqAi6GL7+TNc7hHSYNghnNL3d73BlEYVcvFd9L/U
 7ChUqiK9WKKkETRaQ8IksmcYO5kW83CLC2uLHCP3h9AUtgNzFqCrPqNxaBJNft3Wz7SI
 4vSmsbZkuBAHxsLOcBNSbTaGnLVRlkS6oDLUyuVefaYtB+idJIAQV3rgvSrXFlkqNMS9
 VZ/kPFi75LMOWKw8JU37BTD/Rl9JYp+3zHRfDdIVTRvoVq9Jn8gICFPzWMYXyvxgrcNR 3w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 303yunnu71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 21:14:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033LCRB2024934;
        Fri, 3 Apr 2020 21:14:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 302g4y75j2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 21:14:28 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 033LEQHN004069;
        Fri, 3 Apr 2020 21:14:26 GMT
Received: from localhost.localdomain (/10.159.159.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 14:14:25 -0700
Subject: Re: [PATCH v6 12/14] KVM: x86: Introduce KVM_PAGE_ENC_BITMAP_RESET
 ioctl
To:     Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <9e959ee134ad77f62c9881b8c54cd27e35055072.1585548051.git.ashish.kalra@amd.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <b77a4a1e-b8ca-57a2-d849-adda91bfeac7@oracle.com>
Date:   Fri, 3 Apr 2020 14:14:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <9e959ee134ad77f62c9881b8c54cd27e35055072.1585548051.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 suspectscore=0 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030167
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/29/20 11:23 PM, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> This ioctl can be used by the application to reset the page
> encryption bitmap managed by the KVM driver. A typical usage
> for this ioctl is on VM reboot, on reboot, we must reinitialize
> the bitmap.
>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>   Documentation/virt/kvm/api.rst  | 13 +++++++++++++
>   arch/x86/include/asm/kvm_host.h |  1 +
>   arch/x86/kvm/svm.c              | 16 ++++++++++++++++
>   arch/x86/kvm/x86.c              |  6 ++++++
>   include/uapi/linux/kvm.h        |  1 +
>   5 files changed, 37 insertions(+)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 4d1004a154f6..a11326ccc51d 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -4698,6 +4698,19 @@ During the guest live migration the outgoing guest exports its page encryption
>   bitmap, the KVM_SET_PAGE_ENC_BITMAP can be used to build the page encryption
>   bitmap for an incoming guest.
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
>   5. The kvm_run structure
>   ========================
>   
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d30f770aaaea..a96ef6338cd2 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1273,6 +1273,7 @@ struct kvm_x86_ops {
>   				struct kvm_page_enc_bitmap *bmap);
>   	int (*set_page_enc_bitmap)(struct kvm *kvm,
>   				struct kvm_page_enc_bitmap *bmap);
> +	int (*reset_page_enc_bitmap)(struct kvm *kvm);
>   };
>   
>   struct kvm_arch_async_pf {
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 313343a43045..c99b0207a443 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -7797,6 +7797,21 @@ static int svm_set_page_enc_bitmap(struct kvm *kvm,
>   	return ret;
>   }
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
>   static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>   {
>   	struct kvm_sev_cmd sev_cmd;
> @@ -8203,6 +8218,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
>   	.page_enc_status_hc = svm_page_enc_status_hc,
>   	.get_page_enc_bitmap = svm_get_page_enc_bitmap,
>   	.set_page_enc_bitmap = svm_set_page_enc_bitmap,
> +	.reset_page_enc_bitmap = svm_reset_page_enc_bitmap,


We don't need to initialize the intel ops to NULL ? It's not initialized 
in the previous patch either.

>   };
>   
>   static int __init svm_init(void)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 05e953b2ec61..2127ed937f53 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5250,6 +5250,12 @@ long kvm_arch_vm_ioctl(struct file *filp,
>   			r = kvm_x86_ops->set_page_enc_bitmap(kvm, &bitmap);
>   		break;
>   	}
> +	case KVM_PAGE_ENC_BITMAP_RESET: {
> +		r = -ENOTTY;
> +		if (kvm_x86_ops->reset_page_enc_bitmap)
> +			r = kvm_x86_ops->reset_page_enc_bitmap(kvm);
> +		break;
> +	}
>   	default:
>   		r = -ENOTTY;
>   	}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index b4b01d47e568..0884a581fc37 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1490,6 +1490,7 @@ struct kvm_enc_region {
>   
>   #define KVM_GET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc5, struct kvm_page_enc_bitmap)
>   #define KVM_SET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc6, struct kvm_page_enc_bitmap)
> +#define KVM_PAGE_ENC_BITMAP_RESET	_IO(KVMIO, 0xc7)
>   
>   /* Secure Encrypted Virtualization command */
>   enum sev_cmd_id {
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
