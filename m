Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 190B136548E
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 10:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbhDTIut (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 04:50:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21310 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230436AbhDTIuq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 04:50:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618908614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eNIbX5EAXb6hcc5613svpGxssGl3UvQl0x7wbRQve7Q=;
        b=bh1NONa4qa6wtX4tSPBh61HRUDsO05ab8ayjLqZckLN5/VaskEwd7J2ivIVwwS2H3m3a4S
        xV0uHbtsvGHCdak6EBf0tIlcF87pX6YbMd17VewVNMoGpzVNHR7qP9K5TzIKubAE//qicy
        13EIGHjW5toaencOUukF/5UVaqWNCeA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-_7bniWHqNNu2RYlimjU8Rg-1; Tue, 20 Apr 2021 04:50:13 -0400
X-MC-Unique: _7bniWHqNNu2RYlimjU8Rg-1
Received: by mail-ed1-f69.google.com with SMTP id w14-20020aa7da4e0000b02903834aeed684so10979706eds.13
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 01:50:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eNIbX5EAXb6hcc5613svpGxssGl3UvQl0x7wbRQve7Q=;
        b=VN+NMpehkshmKWCPkbgl8Ba/buQKj0p0aALs3JfyBqQm0RIyAlbwpAEiU4IMYK+ca2
         suPKe1plbwr7cB7rjErmm0lj8+fp5i0EU9iStoBlOizTlhgb+zaJLydLJkv3AP3dr6lt
         HfwD68XRR4dQTh5NDKTlfiUJ1IACSVrSe6fBcA33SAEAH+L6sEAn6Y6wIrpSlY4/szwD
         PmZrsHNNFxTg8vDu3MatXg5PFgU0iov7fJMlypM6ilLO6Nz5/ZjlyLWYr6gDwqc52FVC
         gtFFoi0vXMqbmbo+xVPUqPyObbO52SVSiu7sdjc6kHZD/ILOKjCZwMCAoY44V4wHrD/4
         iJIw==
X-Gm-Message-State: AOAM533tE0St58fJgo3oqLt/0kREpPeDA/9Xx+fdqzGlrK10w95MgMDq
        FfVhcJeIBceFYnczaA7QkQzBjZajty/6zSJxGf7wL0LStJlHduvmMdGhSayNoDDO01OKIQKzpJN
        4YwDFcQVNaYG8
X-Received: by 2002:a17:906:154f:: with SMTP id c15mr26621317ejd.142.1618908611053;
        Tue, 20 Apr 2021 01:50:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxtPni1TTl2iNx0aHJJVCtC2EXpya5BNfC5SY/JaZ5J1kNGm/qdNwEzEly0iJ9tvVAStRFKRw==
X-Received: by 2002:a17:906:154f:: with SMTP id c15mr26621305ejd.142.1618908610865;
        Tue, 20 Apr 2021 01:50:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h9sm10494985ejf.10.2021.04.20.01.50.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 01:50:10 -0700 (PDT)
Subject: Re: [PATCH v13 01/12] KVM: SVM: Add KVM_SEV SEND_START command
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
References: <cover.1618498113.git.ashish.kalra@amd.com>
 <2f1686d0164e0f1b3d6a41d620408393e0a48376.1618498113.git.ashish.kalra@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4b368b32-0c6b-a7bf-be24-e641a0955c80@redhat.com>
Date:   Tue, 20 Apr 2021 10:50:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <2f1686d0164e0f1b3d6a41d620408393e0a48376.1618498113.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/04/21 17:53, Ashish Kalra wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The command is used to create an outgoing SEV guest encryption context.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
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
>   .../virt/kvm/amd-memory-encryption.rst        |  27 ++++
>   arch/x86/kvm/svm/sev.c                        | 125 ++++++++++++++++++
>   include/linux/psp-sev.h                       |   8 +-
>   include/uapi/linux/kvm.h                      |  12 ++
>   4 files changed, 168 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> index 469a6308765b..ac799dd7a618 100644
> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> @@ -284,6 +284,33 @@ Returns: 0 on success, -negative on error
>                   __u32 len;
>           };
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
> +                __u64 plat_certs_uaddr;        /* platform certificate chain */
> +                __u32 plat_certs_len;
> +
> +                __u64 amd_certs_uaddr;        /* AMD certificate */
> +                __u32 amd_certs_len;
> +
> +                __u64 session_uaddr;          /* Guest session information */
> +                __u32 session_len;
> +        };
> +
>   References
>   ==========
>   
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 874ea309279f..2b65900c05d6 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1110,6 +1110,128 @@ static int sev_get_attestation_report(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   	return ret;
>   }
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

This is missing an "if (ret < 0)" (and this time I'm pretty sure it's 
indeed the case :)), otherwise you miss for example the EBADF return 
code if the SEV file descriptor is closed or reused.  Same for 
KVM_SEND_UPDATE_DATA.  Also, the length==0 case is not documented.

Paolo

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
>   int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>   {
>   	struct kvm_sev_cmd sev_cmd;
> @@ -1163,6 +1285,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>   	case KVM_SEV_GET_ATTESTATION_REPORT:
>   		r = sev_get_attestation_report(kvm, &sev_cmd);
>   		break;
> +	case KVM_SEV_SEND_START:
> +		r = sev_send_start(kvm, &sev_cmd);
> +		break;
>   	default:
>   		r = -EINVAL;
>   		goto out;
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index b801ead1e2bb..73da511b9423 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -326,11 +326,11 @@ struct sev_data_send_start {
>   	u64 pdh_cert_address;			/* In */
>   	u32 pdh_cert_len;			/* In */
>   	u32 reserved1;
> -	u64 plat_cert_address;			/* In */
> -	u32 plat_cert_len;			/* In */
> +	u64 plat_certs_address;			/* In */
> +	u32 plat_certs_len;			/* In */
>   	u32 reserved2;
> -	u64 amd_cert_address;			/* In */
> -	u32 amd_cert_len;			/* In */
> +	u64 amd_certs_address;			/* In */
> +	u32 amd_certs_len;			/* In */
>   	u32 reserved3;
>   	u64 session_address;			/* In */
>   	u32 session_len;			/* In/Out */
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index f6afee209620..ac53ad2e7271 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1729,6 +1729,18 @@ struct kvm_sev_attestation_report {
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
> 

