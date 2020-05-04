Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5791C48D6
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 23:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgEDVQZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 17:16:25 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34842 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbgEDVQZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 17:16:25 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044LBwr1190374;
        Mon, 4 May 2020 21:16:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=Oplnk4Rt829rHZ5Ud2jmRrMcwwQYYPsjI4HEiMMUZK8=;
 b=j3nPqVHcVXCpfkkVM4IoKe52OwIyj6wFSh5Aee+lewHjtzli8zxHYtMSxbYQuQI03vXK
 AMnJRTsbI2OZsOyrtoyt1J6jcjhKupHlme0nLIoqWDy36B1BaQy1eG4EU94Z3Jo0hCQF
 0jzMx7w1SlB3rBiukNT5FxzWo66qQGV3fGQDrV1x18PI8iLLVA+URSzqfo+fvszqIyGp
 ML3GLcfWxS4LZDerAXZ1x36GTOlK/UK+lL4fNX8ZM+SOxfV/gosLZG5KmnAE/u/Er0RH
 HU4r/VbWtcg5KJSAQsmLEOwHqx1ILb6sR+J+a4YupQD9591r7lDBQbN9PpwrE7+arBMo 5g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30s09r1f42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 21:16:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044L7eWS140831;
        Mon, 4 May 2020 21:14:00 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30t1r39k5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 21:13:59 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 044LDwdt019330;
        Mon, 4 May 2020 21:13:58 GMT
Received: from vbusired-dt (/10.39.235.150)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 14:13:57 -0700
Date:   Mon, 4 May 2020 16:13:56 -0500
From:   Venu Busireddy <venu.busireddy@oracle.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        rientjes@google.com, brijesh.singh@amd.com
Subject: Re: [PATCH v7 02/18] KVM: SVM: Add KVM_SEND_UPDATE_DATA command
Message-ID: <20200504211356.GB1699387@vbusired-dt>
References: <cover.1588234824.git.ashish.kalra@amd.com>
 <8d336fdd83e9b698354b5572d5f2bd1660879fc4.1588234824.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8d336fdd83e9b698354b5572d5f2bd1660879fc4.1588234824.git.ashish.kalra@amd.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040165
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-04-30 08:40:50 +0000, Ashish Kalra wrote:
> From: Brijesh Singh <Brijesh.Singh@amd.com>
> 
> The command is used for encrypting the guest memory region using the encryption
> context created with KVM_SEV_SEND_START.
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
> Reviewed-by : Steve Rutherford <srutherford@google.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  .../virt/kvm/amd-memory-encryption.rst        |  24 ++++
>  arch/x86/kvm/svm/sev.c                        | 135 +++++++++++++++++-
>  include/uapi/linux/kvm.h                      |   9 ++
>  3 files changed, 164 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> index 4fd34fc5c7a7..f46817ef7019 100644
> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> @@ -290,6 +290,30 @@ Returns: 0 on success, -negative on error
>                  __u32 session_len;
>          };
>  
> +11. KVM_SEV_SEND_UPDATE_DATA
> +----------------------------
> +
> +The KVM_SEV_SEND_UPDATE_DATA command can be used by the hypervisor to encrypt the
> +outgoing guest memory region with the encryption context creating using
> +KVM_SEV_SEND_START.
> +
> +Parameters (in): struct kvm_sev_send_update_data
> +
> +Returns: 0 on success, -negative on error
> +
> +::
> +
> +        struct kvm_sev_launch_send_update_data {
> +                __u64 hdr_uaddr;        /* userspace address containing the packet header */
> +                __u32 hdr_len;
> +
> +                __u64 guest_uaddr;      /* the source memory region to be encrypted */
> +                __u32 guest_len;
> +
> +                __u64 trans_uaddr;      /* the destition memory region  */
> +                __u32 trans_len;
> +        };
> +
>  References
>  ==========
>  
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 5a15b43b4349..0c92c16505ab 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -23,6 +23,7 @@ static DECLARE_RWSEM(sev_deactivate_lock);
>  static DEFINE_MUTEX(sev_bitmap_lock);
>  unsigned int max_sev_asid;
>  static unsigned int min_sev_asid;
> +static unsigned long sev_me_mask;
>  static unsigned long *sev_asid_bitmap;
>  static unsigned long *sev_reclaim_asid_bitmap;
>  #define __sme_page_pa(x) __sme_set(page_to_pfn(x) << PAGE_SHIFT)
> @@ -1035,6 +1036,123 @@ static int sev_send_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	return ret;
>  }
>  
> +/* Userspace wants to query either header or trans length. */
> +static int
> +__sev_send_update_data_query_lengths(struct kvm *kvm, struct kvm_sev_cmd *argp,
> +				     struct kvm_sev_send_update_data *params)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct sev_data_send_update_data *data;
> +	int ret;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	data->handle = sev->handle;
> +	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_UPDATE_DATA, data, &argp->error);
> +
> +	params->hdr_len = data->hdr_len;
> +	params->trans_len = data->trans_len;
> +
> +	if (copy_to_user((void __user *)(uintptr_t)argp->data, params,
> +			 sizeof(struct kvm_sev_send_update_data)))
> +		ret = -EFAULT;
> +
> +	kfree(data);
> +	return ret;
> +}
> +
> +static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct sev_data_send_update_data *data;
> +	struct kvm_sev_send_update_data params;
> +	void *hdr, *trans_data;
> +	struct page **guest_page;
> +	unsigned long n;
> +	int ret, offset;
> +
> +	if (!sev_guest(kvm))
> +		return -ENOTTY;
> +
> +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
> +			sizeof(struct kvm_sev_send_update_data)))
> +		return -EFAULT;
> +
> +	/* userspace wants to query either header or trans length */
> +	if (!params.trans_len || !params.hdr_len)
> +		return __sev_send_update_data_query_lengths(kvm, argp, &params);
> +
> +	if (!params.trans_uaddr || !params.guest_uaddr ||
> +	    !params.guest_len || !params.hdr_uaddr)
> +		return -EINVAL;
> +
> +	/* Check if we are crossing the page boundary */
> +	offset = params.guest_uaddr & (PAGE_SIZE - 1);
> +	if ((params.guest_len + offset > PAGE_SIZE))
> +		return -EINVAL;
> +
> +	/* Pin guest memory */
> +	guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK,
> +				    PAGE_SIZE, &n, 0);
> +	if (!guest_page)
> +		return -EFAULT;
> +
> +	/* allocate memory for header and transport buffer */
> +	ret = -ENOMEM;
> +	hdr = kmalloc(params.hdr_len, GFP_KERNEL_ACCOUNT);
> +	if (!hdr)
> +		goto e_unpin;
> +
> +	trans_data = kmalloc(params.trans_len, GFP_KERNEL_ACCOUNT);
> +	if (!trans_data)
> +		goto e_free_hdr;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		goto e_free_trans_data;
> +
> +	data->hdr_address = __psp_pa(hdr);
> +	data->hdr_len = params.hdr_len;
> +	data->trans_address = __psp_pa(trans_data);
> +	data->trans_len = params.trans_len;
> +
> +	/* The SEND_UPDATE_DATA command requires C-bit to be always set. */
> +	data->guest_address = (page_to_pfn(guest_page[0]) << PAGE_SHIFT) +
> +				offset;
> +	data->guest_address |= sev_me_mask;
> +	data->guest_len = params.guest_len;
> +	data->handle = sev->handle;
> +
> +	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_UPDATE_DATA, data, &argp->error);
> +
> +	if (ret)
> +		goto e_free;
> +
> +	/* copy transport buffer to user space */
> +	if (copy_to_user((void __user *)(uintptr_t)params.trans_uaddr,
> +			 trans_data, params.trans_len)) {
> +		ret = -EFAULT;
> +		goto e_unpin;

Can you address my comment in v6 about this goto statement?
https://lore.kernel.org/kvm/20200402175529.GA655472@vbusired-dt/

> +	}
> +
> +	/* Copy packet header to userspace. */
> +	ret = copy_to_user((void __user *)(uintptr_t)params.hdr_uaddr, hdr,
> +				params.hdr_len);
> +
> +e_free:
> +	kfree(data);
> +e_free_trans_data:
> +	kfree(trans_data);
> +e_free_hdr:
> +	kfree(hdr);
> +e_unpin:
> +	sev_unpin_memory(kvm, guest_page, n);
> +
> +	return ret;
> +}
> +
>  int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_sev_cmd sev_cmd;
> @@ -1082,6 +1200,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  	case KVM_SEV_SEND_START:
>  		r = sev_send_start(kvm, &sev_cmd);
>  		break;
> +	case KVM_SEV_SEND_UPDATE_DATA:
> +		r = sev_send_update_data(kvm, &sev_cmd);
> +		break;
>  	default:
>  		r = -EINVAL;
>  		goto out;
> @@ -1238,16 +1359,22 @@ void sev_vm_destroy(struct kvm *kvm)
>  int __init sev_hardware_setup(void)
>  {
>  	struct sev_user_data_status *status;
> +	u32 eax, ebx;
>  	int rc;
>  
> -	/* Maximum number of encrypted guests supported simultaneously */
> -	max_sev_asid = cpuid_ecx(0x8000001F);
> +	/*
> +	 * Query the memory encryption information.
> +	 *  EBX:  Bit 0:5 Pagetable bit position used to indicate encryption
> +	 *  (aka Cbit).
> +	 *  ECX:  Maximum number of encrypted guests supported simultaneously.
> +	 *  EDX:  Minimum ASID value that should be used for SEV guest.
> +	 */
> +	cpuid(0x8000001f, &eax, &ebx, &max_sev_asid, &min_sev_asid);
>  
>  	if (!svm_sev_enabled())
>  		return 1;
>  
> -	/* Minimum ASID value that should be used for SEV guest */
> -	min_sev_asid = cpuid_edx(0x8000001F);
> +	sev_me_mask = 1UL << (ebx & 0x3f);
>  
>  	/* Initialize SEV ASID bitmaps */
>  	sev_asid_bitmap = bitmap_zalloc(max_sev_asid, GFP_KERNEL);
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 8827d43e2684..7aaed8ee33cf 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1610,6 +1610,15 @@ struct kvm_sev_send_start {
>  	__u32 session_len;
>  };
>  
> +struct kvm_sev_send_update_data {
> +	__u64 hdr_uaddr;
> +	__u32 hdr_len;
> +	__u64 guest_uaddr;
> +	__u32 guest_len;
> +	__u64 trans_uaddr;
> +	__u32 trans_len;
> +};
> +
>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
>  #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
>  #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
> -- 
> 2.17.1
> 
