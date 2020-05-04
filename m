Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37921C48D0
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 23:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgEDVKC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 17:10:02 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57968 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbgEDVKC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 17:10:02 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044L9Xdc187750;
        Mon, 4 May 2020 21:09:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=PLcYr1wD2Icnc/sFUstGtwMmvpnHA9CE9i6umK8mDL4=;
 b=TsHx+LUb/3EzhOVYyytb7FIQ5LVJLt5c0SRWPEGpKRRgE8WYPJg8syfJKx05KdTPmowf
 1mcaWdIbfvj2KsOIzi1dFsJfZZNjvs4fzL5VQRcxwUuVqvhK6YMlofcb3/o7i/Yei6rr
 UaSQJsLck7VMFRd07Wg7mFdCw0F21mLi26hctMwWjE3jSpFPs8fu/oROctPzhsoTc4lG
 vZAadGtg3ubcjFFd25uzHA45HWbppWUPpl7HdgxfnzSzI5CJeD6T5Wnd5Z+bEgwth6aQ
 NdDBN9cUM7lXXYO8iW6+0luruMMPbl4Q07E9xmtekPDlB/OhgKZTmpoX21XKdn6S8G0V gg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30s09r1e7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 21:09:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044L7NRm050315;
        Mon, 4 May 2020 21:07:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30sjnbxqh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 21:07:29 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 044L7JrY013551;
        Mon, 4 May 2020 21:07:20 GMT
Received: from vbusired-dt (/10.39.235.150)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 14:07:18 -0700
Date:   Mon, 4 May 2020 16:07:17 -0500
From:   Venu Busireddy <venu.busireddy@oracle.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        rientjes@google.com, brijesh.singh@amd.com
Subject: Re: [PATCH v7 01/18] KVM: SVM: Add KVM_SEV SEND_START command
Message-ID: <20200504210717.GA1699387@vbusired-dt>
References: <cover.1588234824.git.ashish.kalra@amd.com>
 <6473e5803d8c47d9b207810e8015c3066c39f17d.1588234824.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6473e5803d8c47d9b207810e8015c3066c39f17d.1588234824.git.ashish.kalra@amd.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1011 suspectscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040165
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-04-30 08:40:34 +0000, Ashish Kalra wrote:
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
> Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  .../virt/kvm/amd-memory-encryption.rst        |  27 ++++
>  arch/x86/kvm/svm/sev.c                        | 125 ++++++++++++++++++
>  include/linux/psp-sev.h                       |   8 +-
>  include/uapi/linux/kvm.h                      |  12 ++
>  4 files changed, 168 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> index c3129b9ba5cb..4fd34fc5c7a7 100644
> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> @@ -263,6 +263,33 @@ Returns: 0 on success, -negative on error
>                  __u32 trans_len;
>          };
>  
> +10. KVM_SEV_SEND_START
> +----------------------
> +
> +The KVM_SEV_SEND_START command can be used by the hypervisor to create an
> +outgoing guest encryption context.
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

Can this be changed as mentioned in the previous review
(https://lore.kernel.org/kvm/20200402062726.GA647295@vbusired-dt/)?

> +                __u32 plat_certs_len;
> +
> +                __u64 amd_certs_uaddr;        /* AMD certificate */
> +                __u32 amd_cert_len;

Can this be changed as mentioned in the previous review
(https://lore.kernel.org/kvm/20200402062726.GA647295@vbusired-dt/)?

> +
> +                __u64 session_uaddr;          /* Guest session information */
> +                __u32 session_len;
> +        };
> +
>  References
>  ==========
>  
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index cf912b4aaba8..5a15b43b4349 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -913,6 +913,128 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	return ret;
>  }
>  
> +/* Userspace wants to query session length. */
> +static int
> +__sev_send_start_query_session_length(struct kvm *kvm, struct kvm_sev_cmd *argp,
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
> +
> +	/* allocate the memory to hold the session data blob */
> +	session_data = kmalloc(params.session_len, GFP_KERNEL_ACCOUNT);
> +	if (!session_data)
> +		return -ENOMEM;
> +
> +	/* copy the certificate blobs from userspace */
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

Can the following code be changed as acknowledged in
https://lore.kernel.org/kvm/f715bf99-0158-4d5f-77f3-b27743db3c59@amd.com/?

> +	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_START, data, &argp->error);
> +
> +	if (!ret && copy_to_user((void __user *)(uintptr_t)params.session_uaddr,
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
>  int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_sev_cmd sev_cmd;
> @@ -957,6 +1079,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  	case KVM_SEV_LAUNCH_SECRET:
>  		r = sev_launch_secret(kvm, &sev_cmd);
>  		break;
> +	case KVM_SEV_SEND_START:
> +		r = sev_send_start(kvm, &sev_cmd);
> +		break;
>  	default:
>  		r = -EINVAL;
>  		goto out;
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 5167bf2bfc75..9f63b9d48b63 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -323,11 +323,11 @@ struct sev_data_send_start {
>  	u64 pdh_cert_address;			/* In */
>  	u32 pdh_cert_len;			/* In */
>  	u32 reserved1;
> -	u64 plat_cert_address;			/* In */
> -	u32 plat_cert_len;			/* In */
> +	u64 plat_certs_address;			/* In */
> +	u32 plat_certs_len;			/* In */
>  	u32 reserved2;
> -	u64 amd_cert_address;			/* In */
> -	u32 amd_cert_len;			/* In */
> +	u64 amd_certs_address;			/* In */
> +	u32 amd_certs_len;			/* In */
>  	u32 reserved3;
>  	u64 session_address;			/* In */
>  	u32 session_len;			/* In/Out */
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 428c7dde6b4b..8827d43e2684 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1598,6 +1598,18 @@ struct kvm_sev_dbg {
>  	__u32 len;
>  };
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
>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
>  #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
>  #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
> -- 
> 2.17.1
> 
