Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5FAA19CCD6
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 00:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389894AbgDBWZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 18:25:54 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49540 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389574AbgDBWZy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 18:25:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032M9eJ8140317;
        Thu, 2 Apr 2020 22:25:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=xHqDgWlOpxttXJcz2uGd8+ijlNwiCje2fkWcKJRG85c=;
 b=I/CHdSoIjfvv8zqlEIKBYl3Itcu4/ald6DL35D0XCH/Ei5yzdMJQ7Lxqy5ihev+5dl11
 i1xABaG9dTHG6z6bv9EVqSMVm0h8L7JnXTxpnfRJNqmJG+NsWL/FGnEpLzytoqx16QZZ
 LYG+PleWEgkuNaznm2oqDKMXqNxYiprtLoGFkxlaTPLKt01kCindA5JKw/gfB4E+oK97
 lbqV/yCza81ZXr3OHb45j/lAVOQN6F6f5P5jwkMnanPSx/86o0XkFLcZ9EvvzGNb8cYc
 wkmjQM4ISGmSLXk+8Pni11zENIVuAAJRJiYREBH3J375vdZODZACwRyoYe1EW7U5+/oy OQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 303yungrk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 22:25:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032M8RlW055048;
        Thu, 2 Apr 2020 22:25:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 302g4w8wqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 22:25:31 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 032MPSDZ011277;
        Thu, 2 Apr 2020 22:25:29 GMT
Received: from localhost.localdomain (/10.159.142.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Apr 2020 15:25:28 -0700
Subject: Re: [PATCH v6 05/14] KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA
 command
To:     Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <871a1e89a4dff59f50d9c264c6d9a4cfd0eab50f.1585548051.git.ashish.kalra@amd.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <bd3da2a5-8570-5cb5-56c9-6d78bcc75b5e@oracle.com>
Date:   Thu, 2 Apr 2020 15:25:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <871a1e89a4dff59f50d9c264c6d9a4cfd0eab50f.1585548051.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=2
 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 suspectscore=2 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020164
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/29/20 11:21 PM, Ashish Kalra wrote:
> From: Brijesh Singh <Brijesh.Singh@amd.com>
>
> The command is used for copying the incoming buffer into the
> SEV guest memory space.
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
>   .../virt/kvm/amd-memory-encryption.rst        | 24 ++++++
>   arch/x86/kvm/svm.c                            | 79 +++++++++++++++++++
>   include/uapi/linux/kvm.h                      |  9 +++
>   3 files changed, 112 insertions(+)
>
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> index ef1f1f3a5b40..554aa33a99cc 100644
> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> @@ -351,6 +351,30 @@ On success, the 'handle' field contains a new handle and on error, a negative va
>   
>   For more details, see SEV spec Section 6.12.
>   
> +14. KVM_SEV_RECEIVE_UPDATE_DATA
> +----------------------------
> +
> +The KVM_SEV_RECEIVE_UPDATE_DATA command can be used by the hypervisor to copy
> +the incoming buffers into the guest memory region with encryption context
> +created during the KVM_SEV_RECEIVE_START.
> +
> +Parameters (in): struct kvm_sev_receive_update_data
> +
> +Returns: 0 on success, -negative on error
> +
> +::
> +
> +        struct kvm_sev_launch_receive_update_data {
> +                __u64 hdr_uaddr;        /* userspace address containing the packet header */
> +                __u32 hdr_len;
> +
> +                __u64 guest_uaddr;      /* the destination guest memory region */
> +                __u32 guest_len;
> +
> +                __u64 trans_uaddr;      /* the incoming buffer memory region  */
> +                __u32 trans_len;
> +        };
> +
>   References
>   ==========
>   
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 038b47685733..5fc5355536d7 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -7497,6 +7497,82 @@ static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   	return ret;
>   }
>   
> +static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_receive_update_data params;
> +	struct sev_data_receive_update_data *data;
> +	void *hdr = NULL, *trans = NULL;
> +	struct page **guest_page;
> +	unsigned long n;
> +	int ret, offset;
> +
> +	if (!sev_guest(kvm))
> +		return -EINVAL;
> +
> +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
> +			sizeof(struct kvm_sev_receive_update_data)))
> +		return -EFAULT;
> +
> +	if (!params.hdr_uaddr || !params.hdr_len ||
> +	    !params.guest_uaddr || !params.guest_len ||
> +	    !params.trans_uaddr || !params.trans_len)
> +		return -EINVAL;
> +
> +	/* Check if we are crossing the page boundary */
> +	offset = params.guest_uaddr & (PAGE_SIZE - 1);
> +	if ((params.guest_len + offset > PAGE_SIZE))
> +		return -EINVAL;
> +
> +	hdr = psp_copy_user_blob(params.hdr_uaddr, params.hdr_len);
> +	if (IS_ERR(hdr))
> +		return PTR_ERR(hdr);
> +
> +	trans = psp_copy_user_blob(params.trans_uaddr, params.trans_len);
> +	if (IS_ERR(trans)) {
> +		ret = PTR_ERR(trans);
> +		goto e_free_hdr;
> +	}
> +
> +	ret = -ENOMEM;
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		goto e_free_trans;
> +
> +	data->hdr_address = __psp_pa(hdr);
> +	data->hdr_len = params.hdr_len;
> +	data->trans_address = __psp_pa(trans);
> +	data->trans_len = params.trans_len;
> +
> +	/* Pin guest memory */
> +	ret = -EFAULT;
> +	guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK,
> +				    PAGE_SIZE, &n, 0);
> +	if (!guest_page)
> +		goto e_free;
> +
> +	/* The RECEIVE_UPDATE_DATA command requires C-bit to be always set. */
> +	data->guest_address = (page_to_pfn(guest_page[0]) << PAGE_SHIFT) +
> +				offset;
> +	data->guest_address |= sev_me_mask;
> +	data->guest_len = params.guest_len;
> +	data->handle = sev->handle;
> +
> +	ret = sev_issue_cmd(kvm, SEV_CMD_RECEIVE_UPDATE_DATA, data,
> +				&argp->error);
> +
> +	sev_unpin_memory(kvm, guest_page, n);
> +
> +e_free:
> +	kfree(data);
> +e_free_trans:
> +	kfree(trans);
> +e_free_hdr:
> +	kfree(hdr);
> +
> +	return ret;
> +}
> +
>   static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>   {
>   	struct kvm_sev_cmd sev_cmd;
> @@ -7553,6 +7629,9 @@ static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>   	case KVM_SEV_RECEIVE_START:
>   		r = sev_receive_start(kvm, &sev_cmd);
>   		break;
> +	case KVM_SEV_RECEIVE_UPDATE_DATA:
> +		r = sev_receive_update_data(kvm, &sev_cmd);
> +		break;
>   	default:
>   		r = -EINVAL;
>   		goto out;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 74764b9db5fa..4e80c57a3182 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1588,6 +1588,15 @@ struct kvm_sev_receive_start {
>   	__u32 session_len;
>   };
>   
> +struct kvm_sev_receive_update_data {
> +	__u64 hdr_uaddr;
> +	__u32 hdr_len;
> +	__u64 guest_uaddr;
> +	__u32 guest_len;
> +	__u64 trans_uaddr;
> +	__u32 trans_len;
> +};
> +
>   #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
>   #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
>   #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
