Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D61C19C943
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 20:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389855AbgDBS5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 14:57:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45602 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388658AbgDBS5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 14:57:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032ItUc4123107;
        Thu, 2 Apr 2020 18:57:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=4kgp0JvYvdGT3yctWFFsMGKhKvX/jRxBqfIrbCuJ8NQ=;
 b=V2CDZwloo148EGljwlIwlmWx1M0TtQ84dm6nDYgGM7cph5gQ9KCgvf8pvTmIAiSd1OFX
 dXzo4EmlOqqqDq1vftTSu0hG8siFH+MFQGbWU7dHmGlgLRx1Guqbk/aug+p2a+G8FC3w
 elgWVBHMcMu8sVgN7ZHXJ0BwSZu8xFFw435aHHF3PGmMtW+3JIL/p/wXty9H5PqOaqNB
 STOvCuDGR+6EUIS/8qObZf45H1LbKGkfKSa3A5YZZ/emukJviHCoemkPgt1mrsmiRQOE
 sW5gXiRBbN2n9KmhtaHI6S3buI0e/un4IT2bEtmxGApVn2rdkTyjHpR3IqkIfWUa90dr hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 303yunfwb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 18:57:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032IcI4c069907;
        Thu, 2 Apr 2020 18:57:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 302ga2xm50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 18:57:13 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 032IvBC4004851;
        Thu, 2 Apr 2020 18:57:11 GMT
Received: from vbusired-dt (/10.154.166.66)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Apr 2020 11:57:10 -0700
Date:   Thu, 2 Apr 2020 13:57:06 -0500
From:   Venu Busireddy <venu.busireddy@oracle.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org
Subject: Re: [PATCH v6 01/14] KVM: SVM: Add KVM_SEV SEND_START command
Message-ID: <20200402185706.GA655878@vbusired-dt>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <3f90333959fd49bed184d45a761cc338424bf614.1585548051.git.ashish.kalra@amd.com>
 <20200402062726.GA647295@vbusired-dt>
 <89a586e4-8074-0d32-f384-a4597975d129@amd.com>
 <20200402163717.GA653926@vbusired-dt>
 <8b1b4874-11a8-1422-5ea1-ed665f41ab5c@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8b1b4874-11a8-1422-5ea1-ed665f41ab5c@amd.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004020141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 suspectscore=5 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020141
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-04-02 13:04:13 -0500, Brijesh Singh wrote:
> 
> On 4/2/20 11:37 AM, Venu Busireddy wrote:
> > On 2020-04-02 07:59:54 -0500, Brijesh Singh wrote:
> >> Hi Venu,
> >>
> >> Thanks for the feedback.
> >>
> >> On 4/2/20 1:27 AM, Venu Busireddy wrote:
> >>> On 2020-03-30 06:19:59 +0000, Ashish Kalra wrote:
> >>>> From: Brijesh Singh <Brijesh.Singh@amd.com>
> >>>>
> >>>> The command is used to create an outgoing SEV guest encryption context.
> >>>>
> >>>> Cc: Thomas Gleixner <tglx@linutronix.de>
> >>>> Cc: Ingo Molnar <mingo@redhat.com>
> >>>> Cc: "H. Peter Anvin" <hpa@zytor.com>
> >>>> Cc: Paolo Bonzini <pbonzini@redhat.com>
> >>>> Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> >>>> Cc: Joerg Roedel <joro@8bytes.org>
> >>>> Cc: Borislav Petkov <bp@suse.de>
> >>>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> >>>> Cc: x86@kernel.org
> >>>> Cc: kvm@vger.kernel.org
> >>>> Cc: linux-kernel@vger.kernel.org
> >>>> Reviewed-by: Steve Rutherford <srutherford@google.com>
> >>>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> >>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> >>>> ---
> >>>>  .../virt/kvm/amd-memory-encryption.rst        |  27 ++++
> >>>>  arch/x86/kvm/svm.c                            | 128 ++++++++++++++++++
> >>>>  include/linux/psp-sev.h                       |   8 +-
> >>>>  include/uapi/linux/kvm.h                      |  12 ++
> >>>>  4 files changed, 171 insertions(+), 4 deletions(-)
> >>>>
> >>>> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> >>>> index c3129b9ba5cb..4fd34fc5c7a7 100644
> >>>> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> >>>> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> >>>> @@ -263,6 +263,33 @@ Returns: 0 on success, -negative on error
> >>>>                  __u32 trans_len;
> >>>>          };
> >>>>  
> >>>> +10. KVM_SEV_SEND_START
> >>>> +----------------------
> >>>> +
> >>>> +The KVM_SEV_SEND_START command can be used by the hypervisor to create an
> >>>> +outgoing guest encryption context.
> >>>> +
> >>>> +Parameters (in): struct kvm_sev_send_start
> >>>> +
> >>>> +Returns: 0 on success, -negative on error
> >>>> +
> >>>> +::
> >>>> +        struct kvm_sev_send_start {
> >>>> +                __u32 policy;                 /* guest policy */
> >>>> +
> >>>> +                __u64 pdh_cert_uaddr;         /* platform Diffie-Hellman certificate */
> >>>> +                __u32 pdh_cert_len;
> >>>> +
> >>>> +                __u64 plat_certs_uadr;        /* platform certificate chain */
> >>> Could this please be changed to plat_certs_uaddr, as it is referred to
> >>> in the rest of the code?
> >>>
> >>>> +                __u32 plat_certs_len;
> >>>> +
> >>>> +                __u64 amd_certs_uaddr;        /* AMD certificate */
> >>>> +                __u32 amd_cert_len;
> >>> Could this please be changed to amd_certs_len, as it is referred to in
> >>> the rest of the code?
> >>>
> >>>> +
> >>>> +                __u64 session_uaddr;          /* Guest session information */
> >>>> +                __u32 session_len;
> >>>> +        };
> >>>> +
> >>>>  References
> >>>>  ==========
> >>>>  
> >>>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> >>>> index 50d1ebafe0b3..63d172e974ad 100644
> >>>> --- a/arch/x86/kvm/svm.c
> >>>> +++ b/arch/x86/kvm/svm.c
> >>>> @@ -7149,6 +7149,131 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >>>>  	return ret;
> >>>>  }
> >>>>  
> >>>> +/* Userspace wants to query session length. */
> >>>> +static int
> >>>> +__sev_send_start_query_session_length(struct kvm *kvm, struct kvm_sev_cmd *argp,
> >>>> +				      struct kvm_sev_send_start *params)
> >>>> +{
> >>>> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> >>>> +	struct sev_data_send_start *data;
> >>>> +	int ret;
> >>>> +
> >>>> +	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
> >>>> +	if (data == NULL)
> >>>> +		return -ENOMEM;
> >>>> +
> >>>> +	data->handle = sev->handle;
> >>>> +	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_START, data, &argp->error);
> >>>> +
> >>>> +	params->session_len = data->session_len;
> >>>> +	if (copy_to_user((void __user *)(uintptr_t)argp->data, params,
> >>>> +				sizeof(struct kvm_sev_send_start)))
> >>>> +		ret = -EFAULT;
> >>>> +
> >>>> +	kfree(data);
> >>>> +	return ret;
> >>>> +}
> >>>> +
> >>>> +static int sev_send_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >>>> +{
> >>>> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> >>>> +	struct sev_data_send_start *data;
> >>>> +	struct kvm_sev_send_start params;
> >>>> +	void *amd_certs, *session_data;
> >>>> +	void *pdh_cert, *plat_certs;
> >>>> +	int ret;
> >>>> +
> >>>> +	if (!sev_guest(kvm))
> >>>> +		return -ENOTTY;
> >>>> +
> >>>> +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
> >>>> +				sizeof(struct kvm_sev_send_start)))
> >>>> +		return -EFAULT;
> >>>> +
> >>>> +	/* if session_len is zero, userspace wants to query the session length */
> >>>> +	if (!params.session_len)
> >>>> +		return __sev_send_start_query_session_length(kvm, argp,
> >>>> +				&params);
> >>>> +
> >>>> +	/* some sanity checks */
> >>>> +	if (!params.pdh_cert_uaddr || !params.pdh_cert_len ||
> >>>> +	    !params.session_uaddr || params.session_len > SEV_FW_BLOB_MAX_SIZE)
> >>>> +		return -EINVAL;
> >>>> +
> >>>> +	/* allocate the memory to hold the session data blob */
> >>>> +	session_data = kmalloc(params.session_len, GFP_KERNEL_ACCOUNT);
> >>>> +	if (!session_data)
> >>>> +		return -ENOMEM;
> >>>> +
> >>>> +	/* copy the certificate blobs from userspace */
> >>>> +	pdh_cert = psp_copy_user_blob(params.pdh_cert_uaddr,
> >>>> +				params.pdh_cert_len);
> >>>> +	if (IS_ERR(pdh_cert)) {
> >>>> +		ret = PTR_ERR(pdh_cert);
> >>>> +		goto e_free_session;
> >>>> +	}
> >>>> +
> >>>> +	plat_certs = psp_copy_user_blob(params.plat_certs_uaddr,
> >>>> +				params.plat_certs_len);
> >>>> +	if (IS_ERR(plat_certs)) {
> >>>> +		ret = PTR_ERR(plat_certs);
> >>>> +		goto e_free_pdh;
> >>>> +	}
> >>>> +
> >>>> +	amd_certs = psp_copy_user_blob(params.amd_certs_uaddr,
> >>>> +				params.amd_certs_len);
> >>>> +	if (IS_ERR(amd_certs)) {
> >>>> +		ret = PTR_ERR(amd_certs);
> >>>> +		goto e_free_plat_cert;
> >>>> +	}
> >>>> +
> >>>> +	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
> >>>> +	if (data == NULL) {
> >>>> +		ret = -ENOMEM;
> >>>> +		goto e_free_amd_cert;
> >>>> +	}
> >>>> +
> >>>> +	/* populate the FW SEND_START field with system physical address */
> >>>> +	data->pdh_cert_address = __psp_pa(pdh_cert);
> >>>> +	data->pdh_cert_len = params.pdh_cert_len;
> >>>> +	data->plat_certs_address = __psp_pa(plat_certs);
> >>>> +	data->plat_certs_len = params.plat_certs_len;
> >>>> +	data->amd_certs_address = __psp_pa(amd_certs);
> >>>> +	data->amd_certs_len = params.amd_certs_len;
> >>>> +	data->session_address = __psp_pa(session_data);
> >>>> +	data->session_len = params.session_len;
> >>>> +	data->handle = sev->handle;
> >>>> +
> >>>> +	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_START, data, &argp->error);
> >>>> +
> >>>> +	if (ret)
> >>>> +		goto e_free;
> >>>> +
> >>>> +	if (copy_to_user((void __user *)(uintptr_t) params.session_uaddr,
> >>>> +			session_data, params.session_len)) {
> >>>> +		ret = -EFAULT;
> >>>> +		goto e_free;
> >>>> +	}
> >>> To optimize the amount of data being copied to user space, could the
> >>> above section of code changed as follows?
> >>>
> >>> 	params.session_len = data->session_len;
> >>> 	if (copy_to_user((void __user *)(uintptr_t) params.session_uaddr,
> >>> 			session_data, params.session_len)) {
> >>> 		ret = -EFAULT;
> >>> 		goto e_free;
> >>> 	}
> >>
> >> We should not be using the data->session_len, it will cause -EFAULT when
> >> user has not allocated enough space in the session_uaddr. Lets consider
> >> the case where user passes session_len=10 but firmware thinks the
> >> session length should be 64. In that case the data->session_len will
> >> contains a value of 64 but userspace has allocated space for 10 bytes
> >> and copy_to_user() will fail. If we are really concern about the amount
> >> of data getting copied to userspace then use min_t(size_t,
> >> params.session_len, data->session_len).
> > We are allocating a buffer of params.session_len size and passing that
> > buffer, and that length via data->session_len, to the firmware. Why would
> > the firmware set data->session_len to a larger value, in spite of telling
> > it that the buffer is only params.session_len long? I thought that only
> > the reverse is possible, that is, the user sets the params.session_len
> > to the MAX, but the session data is actually smaller than that size.
> 
> 
> The question is, how does a userspace know the session length ? One
> method is you can precalculate a value based on your firmware version
> and have userspace pass that, or another approach is set
> params.session_len = 0 and query it from the FW. The FW spec allow to
> query the length, please see the spec. In the qemu patches I choose
> second approach. This is because session blob can change from one FW
> version to another and I tried to avoid calculating or hardcoding the
> length for a one version of the FW. You can certainly choose the first
> method. We want to ensure that kernel interface works on the both cases.

I like the fact that you have already implemented the functionality to
facilitate the user space to obtain the session length from the firmware
(by setting params.session_len to 0). However, I am trying to address
the case where the user space sets the params.session_len to a size
smaller than the size needed.

Let me put it differently. Let us say that the session blob needs 128
bytes, but the user space sets params.session_len to 16. That results
in us allocating a buffer of 16 bytes, and set data->session_len to 16.

What does the firmware do now?

Does it copy 128 bytes into data->session_address, or, does it copy
16 bytes?

If it copies 128 bytes, we most certainly will end up with a kernel crash.

If it copies 16 bytes, then what does it set in data->session_len? 16,
or 128? If 16, everything is good. If 128, we end up causing memory
access violation for the user space.

Perhaps, this can be dealt a little differently? Why not always call
sev_issue_cmd(kvm, SEV_CMD_SEND_START, ...) with zeroed out data? Then,
if the user space has set params.session_len to 0, we return with the
needed params.session_len. Otherwise, we check if params.session_len is
large enough, and if not, we return -EINVAL?

> 
> 
> > Also, if for whatever reason the firmware sets data->session_len to
> > a larger value than what is passed, what is the user space expected
> > to do when the call returns? If the user space tries to access
> > params.session_len amount of data, it will possibly get a memory access
> > violation, because it did not originally allocate that large a buffer.
> >
> > If we do go with using min_t(size_t, params.session_len,
> > data->session_len), then params.session_len should also be set to the
> > smaller of the two, right?
> >
> >>>> +
> >>>> +	params.policy = data->policy;
> >>>> +	params.session_len = data->session_len;
> >>>> +	if (copy_to_user((void __user *)(uintptr_t)argp->data, &params,
> >>>> +				sizeof(struct kvm_sev_send_start)))
> >>>> +		ret = -EFAULT;
> >>> Since the only fields that are changed in the kvm_sev_send_start structure
> >>> are session_len and policy, why do we need to copy the entire structure
> >>> back to the user? Why not just those two values? Please see the changes
> >>> proposed to kvm_sev_send_start structure further below to accomplish this.
> >> I think we also need to consider the code readability while saving the
> >> CPU cycles. This is very small structure. By duplicating into two calls
> >> #1 copy params.policy and #2 copy params.session_len we will add more
> >> CPU cycle. And, If we get creative and rearrange the structure then code
> >> readability is lost because now the copy will depend on how the
> >> structure is layout in the memory.
> > I was not recommending splitting that call into two. That would certainly
> > be more expensive, than copying the entire structure. That is the reason
> > why I suggested reordering the members of kvm_sev_send_start. Isn't
> > there plenty of code where structures are defined in a way to keep the
> > data movement efficient? :-)
> >
> > Please see my other comment below.
> >
> >>> 	params.policy = data->policy;
> >>> 	if (copy_to_user((void __user *)(uintptr_t)argp->data, &params,
> >>> 			sizeof(params.policy) + sizeof(params.session_len))
> >>> 		ret = -EFAULT;
> >>>> +
> >>>> +e_free:
> >>>> +	kfree(data);
> >>>> +e_free_amd_cert:
> >>>> +	kfree(amd_certs);
> >>>> +e_free_plat_cert:
> >>>> +	kfree(plat_certs);
> >>>> +e_free_pdh:
> >>>> +	kfree(pdh_cert);
> >>>> +e_free_session:
> >>>> +	kfree(session_data);
> >>>> +	return ret;
> >>>> +}
> >>>> +
> >>>>  static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> >>>>  {
> >>>>  	struct kvm_sev_cmd sev_cmd;
> >>>> @@ -7193,6 +7318,9 @@ static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> >>>>  	case KVM_SEV_LAUNCH_SECRET:
> >>>>  		r = sev_launch_secret(kvm, &sev_cmd);
> >>>>  		break;
> >>>> +	case KVM_SEV_SEND_START:
> >>>> +		r = sev_send_start(kvm, &sev_cmd);
> >>>> +		break;
> >>>>  	default:
> >>>>  		r = -EINVAL;
> >>>>  		goto out;
> >>>> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> >>>> index 5167bf2bfc75..9f63b9d48b63 100644
> >>>> --- a/include/linux/psp-sev.h
> >>>> +++ b/include/linux/psp-sev.h
> >>>> @@ -323,11 +323,11 @@ struct sev_data_send_start {
> >>>>  	u64 pdh_cert_address;			/* In */
> >>>>  	u32 pdh_cert_len;			/* In */
> >>>>  	u32 reserved1;
> >>>> -	u64 plat_cert_address;			/* In */
> >>>> -	u32 plat_cert_len;			/* In */
> >>>> +	u64 plat_certs_address;			/* In */
> >>>> +	u32 plat_certs_len;			/* In */
> >>>>  	u32 reserved2;
> >>>> -	u64 amd_cert_address;			/* In */
> >>>> -	u32 amd_cert_len;			/* In */
> >>>> +	u64 amd_certs_address;			/* In */
> >>>> +	u32 amd_certs_len;			/* In */
> >>>>  	u32 reserved3;
> >>>>  	u64 session_address;			/* In */
> >>>>  	u32 session_len;			/* In/Out */
> >>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> >>>> index 4b95f9a31a2f..17bef4c245e1 100644
> >>>> --- a/include/uapi/linux/kvm.h
> >>>> +++ b/include/uapi/linux/kvm.h
> >>>> @@ -1558,6 +1558,18 @@ struct kvm_sev_dbg {
> >>>>  	__u32 len;
> >>>>  };
> >>>>  
> >>>> +struct kvm_sev_send_start {
> >>>> +	__u32 policy;
> >>>> +	__u64 pdh_cert_uaddr;
> >>>> +	__u32 pdh_cert_len;
> >>>> +	__u64 plat_certs_uaddr;
> >>>> +	__u32 plat_certs_len;
> >>>> +	__u64 amd_certs_uaddr;
> >>>> +	__u32 amd_certs_len;
> >>>> +	__u64 session_uaddr;
> >>>> +	__u32 session_len;
> >>>> +};
> >>> Redo this structure as below:
> >>>
> >>> struct kvm_sev_send_start {
> >>> 	__u32 policy;
> >>> 	__u32 session_len;
> >>> 	__u64 session_uaddr;
> >>> 	__u64 pdh_cert_uaddr;
> >>> 	__u32 pdh_cert_len;
> >>> 	__u64 plat_certs_uaddr;
> >>> 	__u32 plat_certs_len;
> >>> 	__u64 amd_certs_uaddr;
> >>> 	__u32 amd_certs_len;
> >>> };
> >>>
> >>> Or as below, just to make it look better.
> >>>
> >>> struct kvm_sev_send_start {
> >>> 	__u32 policy;
> >>> 	__u32 session_len;
> >>> 	__u64 session_uaddr;
> >>> 	__u32 pdh_cert_len;
> >>> 	__u64 pdh_cert_uaddr;
> >>> 	__u32 plat_certs_len;
> >>> 	__u64 plat_certs_uaddr;
> >>> 	__u32 amd_certs_len;
> >>> 	__u64 amd_certs_uaddr;
> >>> };
> >>>
> >> Wherever applicable, I tried  best to not divert from the SEV spec
> >> structure layout. Anyone who is reading the SEV FW spec  will see a
> >> similar structure layout in the KVM/PSP header files. I would prefer to
> >> stick to that approach.
> > This structure is in uapi, and is anyway different from the
> > sev_data_send_start, right? Does it really need to stay close to the
> > firmware structure layout? Just because the firmware folks thought of
> > a structure layout, that should not prevent our code to be efficient.
> >
> >>
> >>>> +
> >>>>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
> >>>>  #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
> >>>>  #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
> >>>> -- 
> >>>> 2.17.1
> >>>>
