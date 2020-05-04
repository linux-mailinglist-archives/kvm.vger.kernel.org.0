Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA8EE1C4A0B
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 01:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbgEDXLV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 19:11:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41242 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728145AbgEDXLV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 19:11:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044N36Ow073783;
        Mon, 4 May 2020 23:10:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=kGA6po6n5ZEh7PxSKCrJNDtgugXJS/KmCPVRSYPaUVc=;
 b=ipEGCwpyzO04k7VVcQszQiAwKVnBjPohTihdMRuF4T+Xyhu2QDM/t4MbJE+PUm3YwFRw
 009zfWTsofA3ywGTdzz0fSaaSL7UcPbGxWoNqvLBnZuhGWeMw3jYskhXIHWAuKMt+2o+
 Aw6Cot7geZoaxgKrQSZf7e/b7JDNQ5OwjYnyAwdHaI5bSUW8joaLTjyEt4zwwR243kSH
 Ou2idL2h2pG2vR7kZ15uBDMhI97q/rLR7+TrKsr2RJtOUKDTNGtCqITt1tw7fYijTDWo
 /ah+7U5LbhX9zeJ0j/KJjHziV5AmG60yQuThkFo9nXaCjfCK6J+48ZT29RiFwvxKHxLc zQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30s0tm9rwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 23:10:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044N5Xlb186092;
        Mon, 4 May 2020 23:10:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30sjncahqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 23:10:54 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 044NAqKp030329;
        Mon, 4 May 2020 23:10:52 GMT
Received: from vbusired-dt (/10.39.235.150)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 16:10:51 -0700
Date:   Mon, 4 May 2020 18:10:50 -0500
From:   Venu Busireddy <venu.busireddy@oracle.com>
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        rientjes@google.com, brijesh.singh@amd.com
Subject: Re: [PATCH v7 01/18] KVM: SVM: Add KVM_SEV SEND_START command
Message-ID: <20200504231050.GA1701627@vbusired-dt>
References: <cover.1588234824.git.ashish.kalra@amd.com>
 <6473e5803d8c47d9b207810e8015c3066c39f17d.1588234824.git.ashish.kalra@amd.com>
 <20200504210717.GA1699387@vbusired-dt>
 <20200504223637.GA3615@ashkalra_ubuntu_server>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200504223637.GA3615@ashkalra_ubuntu_server>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040179
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040179
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-05-04 22:36:37 +0000, Ashish Kalra wrote:
> On Mon, May 04, 2020 at 04:07:17PM -0500, Venu Busireddy wrote:
> > On 2020-04-30 08:40:34 +0000, Ashish Kalra wrote:
> > > From: Brijesh Singh <Brijesh.Singh@amd.com>
> > > 
> > > The command is used to create an outgoing SEV guest encryption context.
> > > 
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: Ingo Molnar <mingo@redhat.com>
> > > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> > > Cc: Joerg Roedel <joro@8bytes.org>
> > > Cc: Borislav Petkov <bp@suse.de>
> > > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > > Cc: x86@kernel.org
> > > Cc: kvm@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > > Reviewed-by: Steve Rutherford <srutherford@google.com>
> > > Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>
> > > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > > ---
> > >  .../virt/kvm/amd-memory-encryption.rst        |  27 ++++
> > >  arch/x86/kvm/svm/sev.c                        | 125 ++++++++++++++++++
> > >  include/linux/psp-sev.h                       |   8 +-
> > >  include/uapi/linux/kvm.h                      |  12 ++
> > >  4 files changed, 168 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> > > index c3129b9ba5cb..4fd34fc5c7a7 100644
> > > --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> > > +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> > > @@ -263,6 +263,33 @@ Returns: 0 on success, -negative on error
> > >                  __u32 trans_len;
> > >          };
> > >  
> > > +10. KVM_SEV_SEND_START
> > > +----------------------
> > > +
> > > +The KVM_SEV_SEND_START command can be used by the hypervisor to create an
> > > +outgoing guest encryption context.
> > > +
> > > +Parameters (in): struct kvm_sev_send_start
> > > +
> > > +Returns: 0 on success, -negative on error
> > > +
> > > +::
> > > +        struct kvm_sev_send_start {
> > > +                __u32 policy;                 /* guest policy */
> > > +
> > > +                __u64 pdh_cert_uaddr;         /* platform Diffie-Hellman certificate */
> > > +                __u32 pdh_cert_len;
> > > +
> > > +                __u64 plat_certs_uadr;        /* platform certificate chain */
> > 
> > Can this be changed as mentioned in the previous review
> > (https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fkvm%2F20200402062726.GA647295%40vbusired-dt%2F&amp;data=02%7C01%7CAshish.Kalra%40amd.com%7C5ea8d5ae78814a01618908d7f06f7667%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637242233846313842&amp;sdata=qfxRdCY3A1Tox%2FMI%2FQLmUcvIxbfL%2BwoR2fzfQa1FVkA%3D&amp;reserved=0)?
> > 
> > > +                __u32 plat_certs_len;
> > > +
> > > +                __u64 amd_certs_uaddr;        /* AMD certificate */
> > > +                __u32 amd_cert_len;
> > 
> > Can this be changed as mentioned in the previous review
> > (https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fkvm%2F20200402062726.GA647295%40vbusired-dt%2F&amp;data=02%7C01%7CAshish.Kalra%40amd.com%7C5ea8d5ae78814a01618908d7f06f7667%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637242233846323835&amp;sdata=SMYG1m%2BT2KwNQ4Jed%2BJhsK6TQ7EYTKT16moEoZMTf7c%3D&amp;reserved=0)?
> > 
> > > +
> > > +                __u64 session_uaddr;          /* Guest session information */
> > > +                __u32 session_len;
> > > +        };
> > > +
> > >  References
> > >  ==========
> > >  
> > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > index cf912b4aaba8..5a15b43b4349 100644
> > > --- a/arch/x86/kvm/svm/sev.c
> > > +++ b/arch/x86/kvm/svm/sev.c
> > > @@ -913,6 +913,128 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
> > >  	return ret;
> > >  }
> > >  
> > > +/* Userspace wants to query session length. */
> > > +static int
> > > +__sev_send_start_query_session_length(struct kvm *kvm, struct kvm_sev_cmd *argp,
> > > +				      struct kvm_sev_send_start *params)
> > > +{
> > > +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > > +	struct sev_data_send_start *data;
> > > +	int ret;
> > > +
> > > +	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
> > > +	if (data == NULL)
> > > +		return -ENOMEM;
> > > +
> > > +	data->handle = sev->handle;
> > > +	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_START, data, &argp->error);
> > > +
> > > +	params->session_len = data->session_len;
> > > +	if (copy_to_user((void __user *)(uintptr_t)argp->data, params,
> > > +				sizeof(struct kvm_sev_send_start)))
> > > +		ret = -EFAULT;
> > > +
> > > +	kfree(data);
> > > +	return ret;
> > > +}
> > > +
> > > +static int sev_send_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
> > > +{
> > > +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > > +	struct sev_data_send_start *data;
> > > +	struct kvm_sev_send_start params;
> > > +	void *amd_certs, *session_data;
> > > +	void *pdh_cert, *plat_certs;
> > > +	int ret;
> > > +
> > > +	if (!sev_guest(kvm))
> > > +		return -ENOTTY;
> > > +
> > > +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
> > > +				sizeof(struct kvm_sev_send_start)))
> > > +		return -EFAULT;
> > > +
> > > +	/* if session_len is zero, userspace wants to query the session length */
> > > +	if (!params.session_len)
> > > +		return __sev_send_start_query_session_length(kvm, argp,
> > > +				&params);
> > > +
> > > +	/* some sanity checks */
> > > +	if (!params.pdh_cert_uaddr || !params.pdh_cert_len ||
> > > +	    !params.session_uaddr || params.session_len > SEV_FW_BLOB_MAX_SIZE)
> > > +		return -EINVAL;
> > > +
> > > +	/* allocate the memory to hold the session data blob */
> > > +	session_data = kmalloc(params.session_len, GFP_KERNEL_ACCOUNT);
> > > +	if (!session_data)
> > > +		return -ENOMEM;
> > > +
> > > +	/* copy the certificate blobs from userspace */
> > > +	pdh_cert = psp_copy_user_blob(params.pdh_cert_uaddr,
> > > +				params.pdh_cert_len);
> > > +	if (IS_ERR(pdh_cert)) {
> > > +		ret = PTR_ERR(pdh_cert);
> > > +		goto e_free_session;
> > > +	}
> > > +
> > > +	plat_certs = psp_copy_user_blob(params.plat_certs_uaddr,
> > > +				params.plat_certs_len);
> > > +	if (IS_ERR(plat_certs)) {
> > > +		ret = PTR_ERR(plat_certs);
> > > +		goto e_free_pdh;
> > > +	}
> > > +
> > > +	amd_certs = psp_copy_user_blob(params.amd_certs_uaddr,
> > > +				params.amd_certs_len);
> > > +	if (IS_ERR(amd_certs)) {
> > > +		ret = PTR_ERR(amd_certs);
> > > +		goto e_free_plat_cert;
> > > +	}
> > > +
> > > +	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
> > > +	if (data == NULL) {
> > > +		ret = -ENOMEM;
> > > +		goto e_free_amd_cert;
> > > +	}
> > > +
> > > +	/* populate the FW SEND_START field with system physical address */
> > > +	data->pdh_cert_address = __psp_pa(pdh_cert);
> > > +	data->pdh_cert_len = params.pdh_cert_len;
> > > +	data->plat_certs_address = __psp_pa(plat_certs);
> > > +	data->plat_certs_len = params.plat_certs_len;
> > > +	data->amd_certs_address = __psp_pa(amd_certs);
> > > +	data->amd_certs_len = params.amd_certs_len;
> > > +	data->session_address = __psp_pa(session_data);
> > > +	data->session_len = params.session_len;
> > > +	data->handle = sev->handle;
> > > +
> > 
> > Can the following code be changed as acknowledged in
> > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fkvm%2Ff715bf99-0158-4d5f-77f3-b27743db3c59%40amd.com%2F&amp;data=02%7C01%7CAshish.Kalra%40amd.com%7C5ea8d5ae78814a01618908d7f06f7667%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637242233846323835&amp;sdata=5hbjsP%2Btxt2rdv2PtIc%2BV8cAwKUNsRdtiRglDupYXzs%3D&amp;reserved=0?
> > 
> 
> I believe that this has been already addressed as discussed :
> 
> Ah, so the main issue is we should not be going to e_free on error. If
> session_len is less than the expected len then FW will return an error.
> In the case of an error we can skip copying the session_data into
> userspace buffer but we still need to pass the session_len and policy
> back to the userspace.
> 
> So this patch is still returning session_len and policy back to user
> in case of error : ( as the code below shows )
> 
> if (!ret && copy_to_user((void
> __user*)(uintptr_t)params.session_uaddr,...

This fix addresses only one part of the problem. I am referring to the
other suggestion about avoiding copying the entire kvm_sev_send_start
structure back to the user. As I was mentioning in the discussion,
the only fields that changed are the policy and session_len fields. So,
why copy back the entire structure? Why not just those two fields?

> 
> Thanks,
> Ashish
> 
> > > +	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_START, data, &argp->error);
> > > +
> > > +	if (!ret && copy_to_user((void __user *)(uintptr_t)params.session_uaddr,
> > > +			session_data, params.session_len)) {
> > > +		ret = -EFAULT;
> > > +		goto e_free;
> > > +	}
> > > +
> > > +	params.policy = data->policy;
> > > +	params.session_len = data->session_len;
> > > +	if (copy_to_user((void __user *)(uintptr_t)argp->data, &params,
> > > +				sizeof(struct kvm_sev_send_start)))
> > > +		ret = -EFAULT;
> > > +
> > > +e_free:
> > > +	kfree(data);
> > > +e_free_amd_cert:
> > > +	kfree(amd_certs);
> > > +e_free_plat_cert:
> > > +	kfree(plat_certs);
> > > +e_free_pdh:
> > > +	kfree(pdh_cert);
> > > +e_free_session:
> > > +	kfree(session_data);
> > > +	return ret;
> > > +}
> > > +
> > >  int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> > >  {
> > >  	struct kvm_sev_cmd sev_cmd;
> > > @@ -957,6 +1079,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> > >  	case KVM_SEV_LAUNCH_SECRET:
> > >  		r = sev_launch_secret(kvm, &sev_cmd);
> > >  		break;
> > > +	case KVM_SEV_SEND_START:
> > > +		r = sev_send_start(kvm, &sev_cmd);
> > > +		break;
> > >  	default:
> > >  		r = -EINVAL;
> > >  		goto out;
> > > diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> > > index 5167bf2bfc75..9f63b9d48b63 100644
> > > --- a/include/linux/psp-sev.h
> > > +++ b/include/linux/psp-sev.h
> > > @@ -323,11 +323,11 @@ struct sev_data_send_start {
> > >  	u64 pdh_cert_address;			/* In */
> > >  	u32 pdh_cert_len;			/* In */
> > >  	u32 reserved1;
> > > -	u64 plat_cert_address;			/* In */
> > > -	u32 plat_cert_len;			/* In */
> > > +	u64 plat_certs_address;			/* In */
> > > +	u32 plat_certs_len;			/* In */
> > >  	u32 reserved2;
> > > -	u64 amd_cert_address;			/* In */
> > > -	u32 amd_cert_len;			/* In */
> > > +	u64 amd_certs_address;			/* In */
> > > +	u32 amd_certs_len;			/* In */
> > >  	u32 reserved3;
> > >  	u64 session_address;			/* In */
> > >  	u32 session_len;			/* In/Out */
> > > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > > index 428c7dde6b4b..8827d43e2684 100644
> > > --- a/include/uapi/linux/kvm.h
> > > +++ b/include/uapi/linux/kvm.h
> > > @@ -1598,6 +1598,18 @@ struct kvm_sev_dbg {
> > >  	__u32 len;
> > >  };
> > >  
> > > +struct kvm_sev_send_start {
> > > +	__u32 policy;
> > > +	__u64 pdh_cert_uaddr;
> > > +	__u32 pdh_cert_len;
> > > +	__u64 plat_certs_uaddr;
> > > +	__u32 plat_certs_len;
> > > +	__u64 amd_certs_uaddr;
> > > +	__u32 amd_certs_len;
> > > +	__u64 session_uaddr;
> > > +	__u32 session_len;
> > > +};
> > > +
> > >  #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
> > >  #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
> > >  #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
> > > -- 
> > > 2.17.1
> > > 
