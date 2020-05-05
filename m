Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA8D1C6432
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 00:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729293AbgEEWzS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 18:55:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41684 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbgEEWzS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 18:55:18 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045MlwlA142083;
        Tue, 5 May 2020 22:54:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=3DnnHFYUXigKZxsq+0pIPNnX7HcTxYgu9fs6oxrXSGY=;
 b=HDE5035Ykm3hj2ylBXNnyIGEdNm5kSVEVPjWhaeO/sJGqHaQoaGVU3UuA7ZZzPsZOzX1
 u9QBbiY6YqxfQOuE2u/RLvzcrwu2t85K9QNqDi0Z5TwDoAi4P8cPcyWVW0fOfxKsujRh
 /NpDEUPxMizbJj8f0xLml5d8LLs5stwx282Ze9nM49VK5vxlxAJuWCpkbiTHWQapyV4t
 Ga+NLhNUCMoppdrDX3op/86HYHWKnIJW2MvVXKAZdoOVEan3gfXsp3oztmr6HY1nd0XV
 W8XV/DXFpn7qmGTKo6T7D464Qq9SGvZfEnILHIri1j6UbIObujkSmx5uujUnWDINTk4V CA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30s09r7fbx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 22:54:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045Mlik5098289;
        Tue, 5 May 2020 22:52:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30t1r65yu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 22:52:56 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 045MqsEI010496;
        Tue, 5 May 2020 22:52:54 GMT
Received: from vbusired-dt (/10.154.183.230)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 May 2020 15:52:54 -0700
Date:   Tue, 5 May 2020 17:52:55 -0500
From:   Venu Busireddy <venu.busireddy@oracle.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        Thomas.Lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        rientjes@google.com, brijesh.singh@amd.com
Subject: Re: [PATCH v8 04/18] KVM: SVM: Add support for KVM_SEV_RECEIVE_START
 command
Message-ID: <20200505225255.GC1721674@vbusired-dt>
References: <cover.1588711355.git.ashish.kalra@amd.com>
 <cdf08144fe1cea7775c8bb288ae761c4572f8c6c.1588711355.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cdf08144fe1cea7775c8bb288ae761c4572f8c6c.1588711355.git.ashish.kalra@amd.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=5
 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=5
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050171
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-05-05 21:15:40 +0000, Ashish Kalra wrote:
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

Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>

> ---
>  .../virt/kvm/amd-memory-encryption.rst        | 29 +++++++
>  arch/x86/kvm/svm/sev.c                        | 81 +++++++++++++++++++
>  include/uapi/linux/kvm.h                      |  9 +++
>  3 files changed, 119 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> index 93884ec8918e..337bf6a8a3ee 100644
> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> @@ -322,6 +322,35 @@ issued by the hypervisor to delete the encryption context.
>  
>  Returns: 0 on success, -negative on error
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
> +                __u64 pdh_uaddr;        /* userspace address pointing to the PDH key */
> +                __u32 pdh_len;
> +
> +                __u64 session_uaddr;    /* userspace address which points to the guest session information */
> +                __u32 session_len;
> +        };
> +
> +On success, the 'handle' field contains a new handle and on error, a negative value.
> +
> +For more details, see SEV spec Section 6.12.
> +
>  References
>  ==========
>  
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 4d3031c9fdcf..b575aa8e27af 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1173,6 +1173,84 @@ static int sev_send_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	return ret;
>  }
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
>  int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_sev_cmd sev_cmd;
> @@ -1226,6 +1304,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  	case KVM_SEV_SEND_FINISH:
>  		r = sev_send_finish(kvm, &sev_cmd);
>  		break;
> +	case KVM_SEV_RECEIVE_START:
> +		r = sev_receive_start(kvm, &sev_cmd);
> +		break;
>  	default:
>  		r = -EINVAL;
>  		goto out;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 7aaed8ee33cf..24ac57151d53 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1619,6 +1619,15 @@ struct kvm_sev_send_update_data {
>  	__u32 trans_len;
>  };
>  
> +struct kvm_sev_receive_start {
> +	__u32 handle;
> +	__u32 policy;
> +	__u64 pdh_uaddr;
> +	__u32 pdh_len;
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
