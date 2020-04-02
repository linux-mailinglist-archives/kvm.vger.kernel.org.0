Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B90519CCAB
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 00:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389520AbgDBWMF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 18:12:05 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41286 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbgDBWMF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 18:12:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032M8sJA164409;
        Thu, 2 Apr 2020 22:11:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=WnocW8mWItP6QF6XoA61ycAu6zStMx9i0N4yYd3pAtY=;
 b=Nc65dlGGPV6InMcuql7/xXyQMMKqGuL5apD7TikEyP6eAx3nsQsvNwXq3T7uPZMfK5C1
 V0PSKPgtO3O9oYkxrAE75/Ye6XdqVRu1+vG3XUDEhovY8FWNZiNL9urHCPJg+zjlidn6
 CD6NVPATGBUzWdZWYzg6ziiwKCLBd/SmnQgweTKnssyWv/VrWRZyhNFYiyF8+uB3jAEg
 MgfV4NUoNJ400O/bod7NQNYtuJMs7wMG+wxbCWB9grdzwGQ6ycQmlkz0WJpUVW6kisvv
 jlG2lddcTxBUX9x4NGuxRF7Pklssk4svSr66XGeyeIBoVyMGholP0j2O9L+E7u/CHVVw Sw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 303aqhxk2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 22:11:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032M8Hfa048419;
        Thu, 2 Apr 2020 22:09:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 302ga37nk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 22:09:37 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 032M9Zum028546;
        Thu, 2 Apr 2020 22:09:35 GMT
Received: from localhost.localdomain (/10.159.142.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Apr 2020 15:09:35 -0700
Subject: Re: [PATCH v6 04/14] KVM: SVM: Add support for KVM_SEV_RECEIVE_START
 command
To:     Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <7753c183e9e571220fffe3663b1139c1f9030fbf.1585548051.git.ashish.kalra@amd.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <b6644f3c-defe-3ac3-12e5-502faf22d5e2@oracle.com>
Date:   Thu, 2 Apr 2020 15:09:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <7753c183e9e571220fffe3663b1139c1f9030fbf.1585548051.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004020164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020164
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/29/20 11:21 PM, Ashish Kalra wrote:
> From: Brijesh Singh <Brijesh.Singh@amd.com>
>
> The command is used to create the encryption context for an incoming
> SEV guest. The encryption context can be later used by the hypervisor
> to import the incoming data into the SEV guest memory space.
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
>   .../virt/kvm/amd-memory-encryption.rst        | 29 +++++++
>   arch/x86/kvm/svm.c                            | 81 +++++++++++++++++++
>   include/uapi/linux/kvm.h                      |  9 +++
>   3 files changed, 119 insertions(+)
>
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> index a45dcb5f8687..ef1f1f3a5b40 100644
> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> @@ -322,6 +322,35 @@ issued by the hypervisor to delete the encryption context.
>   
>   Returns: 0 on success, -negative on error
>   
> +13. KVM_SEV_RECEIVE_START
> +------------------------
> +
> +The KVM_SEV_RECEIVE_START command is used for creating the memory encryption
> +context for an incoming SEV guest. To create the encryption context, the user must
> +provide a guest policy, the platform public Diffie-Hellman (PDH) key and session
> +information.
> +
> +Parameters: struct  kvm_sev_receive_start (in/out)
> +
> +Returns: 0 on success, -negative on error
> +
> +::
> +
> +        struct kvm_sev_receive_start {
> +                __u32 handle;           /* if zero then firmware creates a new handle */
> +                __u32 policy;           /* guest's policy */
> +
> +                __u64 pdh_uaddr;         /* userspace address pointing to the PDH key */
> +                __u32 dh_len;
> +
> +                __u64 session_addr;     /* userspace address which points to the guest session information */
> +                __u32 session_len;
> +        };
> +
> +On success, the 'handle' field contains a new handle and on error, a negative value.
> +
> +For more details, see SEV spec Section 6.12.
> +
>   References
>   ==========
>   
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 71a4cb3b817d..038b47685733 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -7419,6 +7419,84 @@ static int sev_send_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   	return ret;
>   }
>   
> +static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct sev_data_receive_start *start;
> +	struct kvm_sev_receive_start params;
> +	int *error = &argp->error;
> +	void *session_data;
> +	void *pdh_data;
> +	int ret;
> +
> +	if (!sev_guest(kvm))
> +		return -ENOTTY;
> +
> +	/* Get parameter from the userspace */
> +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
> +			sizeof(struct kvm_sev_receive_start)))
> +		return -EFAULT;
> +
> +	/* some sanity checks */
> +	if (!params.pdh_uaddr || !params.pdh_len ||
> +	    !params.session_uaddr || !params.session_len)
> +		return -EINVAL;
> +
> +	pdh_data = psp_copy_user_blob(params.pdh_uaddr, params.pdh_len);
> +	if (IS_ERR(pdh_data))
> +		return PTR_ERR(pdh_data);
> +
> +	session_data = psp_copy_user_blob(params.session_uaddr,
> +			params.session_len);
> +	if (IS_ERR(session_data)) {
> +		ret = PTR_ERR(session_data);
> +		goto e_free_pdh;
> +	}
> +
> +	ret = -ENOMEM;
> +	start = kzalloc(sizeof(*start), GFP_KERNEL);
> +	if (!start)
> +		goto e_free_session;
> +
> +	start->handle = params.handle;
> +	start->policy = params.policy;
> +	start->pdh_cert_address = __psp_pa(pdh_data);
> +	start->pdh_cert_len = params.pdh_len;
> +	start->session_address = __psp_pa(session_data);
> +	start->session_len = params.session_len;
> +
> +	/* create memory encryption context */
> +	ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_RECEIVE_START, start,
> +				error);
> +	if (ret)
> +		goto e_free;
> +
> +	/* Bind ASID to this guest */
> +	ret = sev_bind_asid(kvm, start->handle, error);
> +	if (ret)
> +		goto e_free;
> +
> +	params.handle = start->handle;
> +	if (copy_to_user((void __user *)(uintptr_t)argp->data,
> +			 &params, sizeof(struct kvm_sev_receive_start))) {
> +		ret = -EFAULT;
> +		sev_unbind_asid(kvm, start->handle);
> +		goto e_free;
> +	}
> +
> +	sev->handle = start->handle;
> +	sev->fd = argp->sev_fd;
> +
> +e_free:
> +	kfree(start);
> +e_free_session:
> +	kfree(session_data);
> +e_free_pdh:
> +	kfree(pdh_data);
> +
> +	return ret;
> +}
> +
>   static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>   {
>   	struct kvm_sev_cmd sev_cmd;
> @@ -7472,6 +7550,9 @@ static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>   	case KVM_SEV_SEND_FINISH:
>   		r = sev_send_finish(kvm, &sev_cmd);
>   		break;
> +	case KVM_SEV_RECEIVE_START:
> +		r = sev_receive_start(kvm, &sev_cmd);
> +		break;
>   	default:
>   		r = -EINVAL;
>   		goto out;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index d9dc81bb9c55..74764b9db5fa 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1579,6 +1579,15 @@ struct kvm_sev_send_update_data {
>   	__u32 trans_len;
>   };
>   
> +struct kvm_sev_receive_start {
> +	__u32 handle;
> +	__u32 policy;
> +	__u64 pdh_uaddr;
> +	__u32 pdh_len;

Why not 'pdh_cert_uaddr' and 'pdh_cert_len' ? That's the naming 
convention you have followed in previous patches.
> +	__u64 session_uaddr;
> +	__u32 session_len;
> +};
> +
>   #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
>   #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
>   #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)


Reviewed-by: Krish Sadhukhan <krish.sadhukan@oracle.com>

