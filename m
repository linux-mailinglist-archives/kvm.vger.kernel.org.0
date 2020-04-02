Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F18819C85D
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 19:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388648AbgDBRwa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 13:52:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33888 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgDBRwa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 13:52:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032Hh4ja096652;
        Thu, 2 Apr 2020 17:52:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=TX5zMc9PwD7oT3/VNkiEq/TnRI/NA7BQ48BXlX+gTIc=;
 b=c/QD4IQy+1oGgkUWctV0sjlsivaWnzUZN1q38rwEymAg6k/EqrNOJwTpVPFy2I8swVPH
 bf6T+kqWTHQ7iNX1r8E/i262Q1feg0eC+Ta18r0XXz2hzamQr6VvtOlrxK8/cpcJvYI5
 eCml9lQhWB+fbk1sLG2iLlqpIlYygoAR1weunTaUBmDMx2ENCDxvFN32VBDgEPqEd1oy
 aLiHqBpUGBJc7LFAUmvmf2JsKaybSWRfBBEqZCW5rL0H7T1phIdEvwFrZwTx3FFcoi0q
 ecEe7O+nAJ7rk9KkXiJ1t/jtXH25KARgvZTPkuJZFdyNXjOTaUqcv1qNrV7S8OMp7wha bg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 303aqhwdqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 17:52:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032Hh7fS018244;
        Thu, 2 Apr 2020 17:52:04 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 304sjq4jba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 17:52:04 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 032HpuhB009656;
        Thu, 2 Apr 2020 17:51:57 GMT
Received: from localhost.localdomain (/10.159.142.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Apr 2020 10:51:56 -0700
Subject: Re: [PATCH v6 01/14] KVM: SVM: Add KVM_SEV SEND_START command
To:     Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <3f90333959fd49bed184d45a761cc338424bf614.1585548051.git.ashish.kalra@amd.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <4a614d5f-2a01-7b1e-fc76-413b9618e135@oracle.com>
Date:   Thu, 2 Apr 2020 10:51:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <3f90333959fd49bed184d45a761cc338424bf614.1585548051.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=2 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 clxscore=1011
 malwarescore=0 impostorscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020137
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/29/20 11:19 PM, Ashish Kalra wrote:
> From: Brijesh Singh <Brijesh.Singh@amd.com>
>
> The command is used to create an outgoing SEV guest encryption context.
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
> Reviewed-by: Steve Rutherford <srutherford@google.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>   .../virt/kvm/amd-memory-encryption.rst        |  27 ++++
>   arch/x86/kvm/svm.c                            | 128 ++++++++++++++++++
>   include/linux/psp-sev.h                       |   8 +-
>   include/uapi/linux/kvm.h                      |  12 ++
>   4 files changed, 171 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> index c3129b9ba5cb..4fd34fc5c7a7 100644
> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> @@ -263,6 +263,33 @@ Returns: 0 on success, -negative on error
>                   __u32 trans_len;
>           };
>   
> +10. KVM_SEV_SEND_START
> +----------------------
> +
> +The KVM_SEV_SEND_START command can be used by the hypervisor to create an
> +outgoing guest encryption context.
Shouldn't we mention that this command is also used to save the guest to 
the disk ?
> +
> +Parameters (in): struct kvm_sev_send_start
> +
> +Returns: 0 on success, -negative on error
> +
> +::
> +        struct kvm_sev_send_start {
> +                __u32 policy;                 /* guest policy */
> +
> +                __u64 pdh_cert_uaddr;         /* platform Diffie-Hellman certificate */
> +                __u32 pdh_cert_len;
> +
> +                __u64 plat_certs_uadr;        /* platform certificate chain */
> +                __u32 plat_certs_len;
> +
> +                __u64 amd_certs_uaddr;        /* AMD certificate */
> +                __u32 amd_cert_len;
> +
> +                __u64 session_uaddr;          /* Guest session information */
> +                __u32 session_len;
> +        };
> +
>   References
>   ==========
>   
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 50d1ebafe0b3..63d172e974ad 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -7149,6 +7149,131 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   	return ret;
>   }
>   
> +/* Userspace wants to query session length. */
> +static int
> +__sev_send_start_query_session_length(struct kvm *kvm, struct kvm_sev_cmd *argp,


__sev_query_send_start_session_length a better name perhaps ?

> +				      struct kvm_sev_send_start *params)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct sev_data_send_start *data;
> +	int ret;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
> +	if (data == NULL)
> +		return -ENOMEM;
> +
> +	data->handle = sev->handle;
> +	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_START, data, &argp->error);


We are not checking ret here as we are assuming that the command will 
always be successful. Is there any chance that sev->handle can be junk 
and should we have an ASSERT for it ?

> +
> +	params->session_len = data->session_len;
> +	if (copy_to_user((void __user *)(uintptr_t)argp->data, params,
> +				sizeof(struct kvm_sev_send_start)))
> +		ret = -EFAULT;
> +
> +	kfree(data);
> +	return ret;
> +}
> +
> +static int sev_send_start(struct kvm *kvm, struct kvm_sev_cmd *argp)


For readability and ease of cscope searches, isn't it better to append 
"svm" to all these functions ?

It seems svm_sev_enabled() is an example of an appropriate naming style.

> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct sev_data_send_start *data;
> +	struct kvm_sev_send_start params;
> +	void *amd_certs, *session_data;
> +	void *pdh_cert, *plat_certs;
> +	int ret;
> +
> +	if (!sev_guest(kvm))
> +		return -ENOTTY;
> +
> +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
> +				sizeof(struct kvm_sev_send_start)))
> +		return -EFAULT;
> +
> +	/* if session_len is zero, userspace wants to query the session length */
> +	if (!params.session_len)
> +		return __sev_send_start_query_session_length(kvm, argp,
> +				&params);
> +
> +	/* some sanity checks */
> +	if (!params.pdh_cert_uaddr || !params.pdh_cert_len ||
> +	    !params.session_uaddr || params.session_len > SEV_FW_BLOB_MAX_SIZE)
> +		return -EINVAL;


What if params.plat_certs_uaddr or params.amd_certs_uaddr is NULL ?

> +
> +	/* allocate the memory to hold the session data blob */
> +	session_data = kmalloc(params.session_len, GFP_KERNEL_ACCOUNT);
> +	if (!session_data)
> +		return -ENOMEM;
> +
> +	/* copy the certificate blobs from userspace */


You haven't added comments for plat_cert and amd_cert. Also, it's much 
more readable if you add block comments like,

         /*

          *  PDH cert

          */

> +	pdh_cert = psp_copy_user_blob(params.pdh_cert_uaddr,
> +				params.pdh_cert_len);
> +	if (IS_ERR(pdh_cert)) {
> +		ret = PTR_ERR(pdh_cert);
> +		goto e_free_session;
> +	}
> +
> +	plat_certs = psp_copy_user_blob(params.plat_certs_uaddr,
> +				params.plat_certs_len);
> +	if (IS_ERR(plat_certs)) {
> +		ret = PTR_ERR(plat_certs);
> +		goto e_free_pdh;
> +	}
> +
> +	amd_certs = psp_copy_user_blob(params.amd_certs_uaddr,
> +				params.amd_certs_len);
> +	if (IS_ERR(amd_certs)) {
> +		ret = PTR_ERR(amd_certs);
> +		goto e_free_plat_cert;
> +	}
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
> +	if (data == NULL) {
> +		ret = -ENOMEM;
> +		goto e_free_amd_cert;
> +	}
> +
> +	/* populate the FW SEND_START field with system physical address */
> +	data->pdh_cert_address = __psp_pa(pdh_cert);
> +	data->pdh_cert_len = params.pdh_cert_len;
> +	data->plat_certs_address = __psp_pa(plat_certs);
> +	data->plat_certs_len = params.plat_certs_len;
> +	data->amd_certs_address = __psp_pa(amd_certs);
> +	data->amd_certs_len = params.amd_certs_len;
> +	data->session_address = __psp_pa(session_data);
> +	data->session_len = params.session_len;
> +	data->handle = sev->handle;
> +
> +	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_START, data, &argp->error);
> +
> +	if (ret)
> +		goto e_free;
> +
> +	if (copy_to_user((void __user *)(uintptr_t) params.session_uaddr,
> +			session_data, params.session_len)) {
> +		ret = -EFAULT;
> +		goto e_free;
> +	}
> +
> +	params.policy = data->policy;
> +	params.session_len = data->session_len;
> +	if (copy_to_user((void __user *)(uintptr_t)argp->data, &params,
> +				sizeof(struct kvm_sev_send_start)))
> +		ret = -EFAULT;
> +
> +e_free:
> +	kfree(data);
> +e_free_amd_cert:
> +	kfree(amd_certs);
> +e_free_plat_cert:
> +	kfree(plat_certs);
> +e_free_pdh:
> +	kfree(pdh_cert);
> +e_free_session:
> +	kfree(session_data);
> +	return ret;
> +}
> +
>   static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>   {
>   	struct kvm_sev_cmd sev_cmd;
> @@ -7193,6 +7318,9 @@ static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>   	case KVM_SEV_LAUNCH_SECRET:
>   		r = sev_launch_secret(kvm, &sev_cmd);
>   		break;
> +	case KVM_SEV_SEND_START:
> +		r = sev_send_start(kvm, &sev_cmd);
> +		break;
>   	default:
>   		r = -EINVAL;
>   		goto out;
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 5167bf2bfc75..9f63b9d48b63 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -323,11 +323,11 @@ struct sev_data_send_start {
>   	u64 pdh_cert_address;			/* In */
>   	u32 pdh_cert_len;			/* In */
>   	u32 reserved1;
> -	u64 plat_cert_address;			/* In */
> -	u32 plat_cert_len;			/* In */
> +	u64 plat_certs_address;			/* In */
> +	u32 plat_certs_len;			/* In */


It seems that the 'platform certificate' and the 'amd_certificate' are 
single entities, meaning only copy is there for the particular platform 
and particular the AMD product. Why are these plural then ?


>   	u32 reserved2;
> -	u64 amd_cert_address;			/* In */
> -	u32 amd_cert_len;			/* In */
> +	u64 amd_certs_address;			/* In */
> +	u32 amd_certs_len;			/* In */
>   	u32 reserved3;
>   	u64 session_address;			/* In */
>   	u32 session_len;			/* In/Out */
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 4b95f9a31a2f..17bef4c245e1 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1558,6 +1558,18 @@ struct kvm_sev_dbg {
>   	__u32 len;
>   };
>   
> +struct kvm_sev_send_start {
> +	__u32 policy;
> +	__u64 pdh_cert_uaddr;
> +	__u32 pdh_cert_len;
> +	__u64 plat_certs_uaddr;
> +	__u32 plat_certs_len;
> +	__u64 amd_certs_uaddr;
> +	__u32 amd_certs_len;
> +	__u64 session_uaddr;
> +	__u32 session_len;
> +};
> +
>   #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
>   #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
>   #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
