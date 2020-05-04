Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A51671C4928
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 23:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbgEDVhz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 17:37:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54860 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726816AbgEDVhy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 17:37:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044LX60u129315;
        Mon, 4 May 2020 21:37:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=nWn8CM6j4depyT+fw7GSCS2G+hPhtJf3Hn378vZfqYw=;
 b=sA0vmTKTGdp/JlpFC0zTR2BZlYXqrZQA2lgvxt82VHPB1f467Gvtup3KieLL+iD6uYH7
 VCwo3WXwPORrVD64NNhk1weX9QdYwh1nz9V4GEcAOH72+f/GjuAJjr5OZdw39VLHWEqT
 XIpuzWNIviJ9uUQ5IRZLXJSy7ZqFgcRbzEbJS2bh5HoEBS+InxGhdf993q9lCLHJQrA9
 DUsyc8UWDgs9sfyfoZTtFtm8LueW6SooN0Eb1iguWXak/zwB2ckLo23sqqJDmiWg7yDW
 3Vp+vjFbBoFfyGnYb9qXhCpFGm+XxD8nXBtTd+vFovhKjehoyZUUTIsCd6nIAeipukIv Sg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30s0tm9fpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 21:37:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044LbMCl021790;
        Mon, 4 May 2020 21:37:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30sjnc1kep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 21:37:32 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 044LbPkt006374;
        Mon, 4 May 2020 21:37:26 GMT
Received: from vbusired-dt (/10.39.235.150)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 14:37:25 -0700
Date:   Mon, 4 May 2020 16:37:24 -0500
From:   Venu Busireddy <venu.busireddy@oracle.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        rientjes@google.com, brijesh.singh@amd.com
Subject: Re: [PATCH v7 04/18] KVM: SVM: Add support for KVM_SEV_RECEIVE_START
 command
Message-ID: <20200504213724.GA1700255@vbusired-dt>
References: <cover.1588234824.git.ashish.kalra@amd.com>
 <c446e7802559c3b274b174769814369ed1d5e912.1588234824.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c446e7802559c3b274b174769814369ed1d5e912.1588234824.git.ashish.kalra@amd.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040169
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-04-30 08:42:02 +0000, Ashish Kalra wrote:
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
>  .../virt/kvm/amd-memory-encryption.rst        | 29 +++++++
>  arch/x86/kvm/svm/sev.c                        | 81 +++++++++++++++++++
>  include/uapi/linux/kvm.h                      |  9 +++
>  3 files changed, 119 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> index a45dcb5f8687..ef1f1f3a5b40 100644
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
> +                __u64 pdh_uaddr;         /* userspace address pointing to the PDH key */
> +                __u32 dh_len;
> +
> +                __u64 session_addr;     /* userspace address which points to the guest session information */
> +                __u32 session_len;

Can you address my comments in v6?
(https://lore.kernel.org/kvm/20200402213520.GA658288@vbusired-dt/)

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
> index 81d661706d31..74a847c9106d 100644
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
