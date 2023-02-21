Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2E469E08F
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 13:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234634AbjBUMlw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 07:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234798AbjBUMln (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 07:41:43 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1687D26853;
        Tue, 21 Feb 2023 04:41:21 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31LBUrG6007035;
        Tue, 21 Feb 2023 12:40:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=DtcPa1deaHe9WjwD+eJN66LKxf6T5OcN86NGAmtJUgc=;
 b=WK+uTj4nX2mwFnL2NrMD7tcoLlhhlJDVHSgWJrgGl6emBMH26xqSQcNr72fNok7XU3xB
 sNWj2f3kYGHKNd8gLak8tmBN0RMelckKaMQnKJr11yEi5HVh38cT+vLCZXafTp6/N+Fn
 TemTVkMWEvLHWNbVXw0r357MzdqMysXutULQzAG3E3D/qidvzRVya/bpcS56oXjQoZWp
 l/r3mf5ulCsKJWsRACxznBi8h7pHLP9Z5OlAFItbsENMUzaSVI/5bt1uRaOhloigSzxk
 3mXbazkDXFjCD0RHbX92Xq2NVxXr5llXHXtk9TsiNxfECt1u57Y3CAlyZmpHAVLbSQ8I ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nvh4fsqdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 12:40:32 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31LCBIjF011033;
        Tue, 21 Feb 2023 12:40:32 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nvh4fsqcr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 12:40:32 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31L9u7SE011387;
        Tue, 21 Feb 2023 12:40:30 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([9.208.129.118])
        by ppma01dal.us.ibm.com (PPS) with ESMTPS id 3ntpa7f98w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 12:40:30 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
        by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31LCeSwt1573484
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Feb 2023 12:40:28 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BE8458043;
        Tue, 21 Feb 2023 12:40:28 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD17858055;
        Tue, 21 Feb 2023 12:40:18 +0000 (GMT)
Received: from [9.160.173.144] (unknown [9.160.173.144])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 21 Feb 2023 12:40:18 +0000 (GMT)
Message-ID: <ea3cbb15-99e1-827c-9602-f53f74f7e543@linux.ibm.com>
Date:   Tue, 21 Feb 2023 14:40:17 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH RFC v8 54/56] x86/sev: Add KVM commands for instance certs
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, tobin@ibm.com, bp@alien8.de, vbabka@suse.cz,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, dgilbert@redhat.com, jarkko@kernel.org,
        ashish.kalra@amd.com, nikunj.dadhania@amd.com,
        Dionna Glaze <dionnaglaze@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-55-michael.roth@amd.com>
From:   Dov Murik <dovmurik@linux.ibm.com>
In-Reply-To: <20230220183847.59159-55-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9knr3ZYypeuFlhnNPJpBvrWYo4mzWRWd
X-Proofpoint-GUID: b2MI_pUmnvqYKbcoJs3VcNLV8-inLHC1
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-21_07,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 clxscore=1011 mlxscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302210106
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Mike,

On 20/02/2023 20:38, Michael Roth wrote:
> From: Dionna Glaze <dionnaglaze@google.com>
> 
> The /dev/sev device has the ability to store host-wide certificates for
> the key used by the AMD-SP for SEV-SNP attestation report signing,
> but for hosts that want to specify additional certificates that are
> specific to the image launched in a VM, a different way is needed to
> communicate those certificates.
> 
> Add two new KVM ioctl to handle this: KVM_SEV_SNP_{GET,SET}_CERTS
> 
> The certificates that are set with this command are expected to follow
> the same format as the host certificates, but that format is opaque
> to the kernel.
> 
> The new behavior for custom certificates is that the extended guest
> request command will now return the overridden certificates if they
> were installed for the instance. The error condition for a too small
> data buffer is changed to return the overridden certificate data size
> if there is an overridden certificate set installed.
> 
> Setting a 0 length certificate returns the system state to only return
> the host certificates on an extended guest request.
> 
> Also increase the SEV_FW_BLOB_MAX_SIZE another 4K page to allow space
> for an extra certificate.
> 
> Cc: Tom Lendacky <Thomas.Lendacky@amd.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> 
> Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> [mdr: remove used of "we" and "this patch" in commit log]
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c   | 111 ++++++++++++++++++++++++++++++++++++++-
>  arch/x86/kvm/svm/svm.h   |   1 +
>  include/linux/psp-sev.h  |   2 +-
>  include/uapi/linux/kvm.h |  12 +++++
>  4 files changed, 123 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 70d5650d8d95..18b64b7005e7 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2089,6 +2089,7 @@ static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  		goto e_free;
>  
>  	sev->snp_certs_data = certs_data;
> +	sev->snp_certs_len = 0;
>  
>  	return context;
>  
> @@ -2404,6 +2405,86 @@ static int snp_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	return ret;
>  }
>  
> +static int snp_get_instance_certs(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_snp_get_certs params;
> +
> +	if (!sev_snp_guest(kvm))
> +		return -ENOTTY;
> +
> +	if (!sev->snp_context)
> +		return -EINVAL;
> +
> +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
> +			   sizeof(params)))
> +		return -EFAULT;
> +
> +	/* No instance certs set. */
> +	if (!sev->snp_certs_len)
> +		return -ENOENT;
> +
> +	if (params.certs_len < sev->snp_certs_len) {
> +		/* Output buffer too small. Return the required size. */
> +		params.certs_len = sev->snp_certs_len;
> +
> +		if (copy_to_user((void __user *)(uintptr_t)argp->data, &params,
> +				 sizeof(params)))
> +			return -EFAULT;
> +
> +		return -EINVAL;
> +	}
> +
> +	if (copy_to_user((void __user *)(uintptr_t)params.certs_uaddr,
> +			 sev->snp_certs_data, sev->snp_certs_len))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +static int snp_set_instance_certs(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	unsigned long length = SEV_FW_BLOB_MAX_SIZE;
> +	void *to_certs = sev->snp_certs_data;
> +	struct kvm_sev_snp_set_certs params;
> +
> +	if (!sev_snp_guest(kvm))
> +		return -ENOTTY;
> +
> +	if (!sev->snp_context)
> +		return -EINVAL;
> +
> +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
> +			   sizeof(params)))
> +		return -EFAULT;
> +
> +	if (params.certs_len > SEV_FW_BLOB_MAX_SIZE)
> +		return -EINVAL;
> +
> +	/*
> +	 * Setting a length of 0 is the same as "uninstalling" instance-
> +	 * specific certificates.
> +	 */
> +	if (params.certs_len == 0) {
> +		sev->snp_certs_len = 0;
> +		return 0;
> +	}
> +
> +	/* Page-align the length */
> +	length = (params.certs_len + PAGE_SIZE - 1) & PAGE_MASK;
> +

In comments on v7 [1] Dionna agreed adding cleanup here:

  /* The size could shrink and leave garbage at the end. */
  memset(sev->snp_certs_data, 0, SEV_FW_BLOB_MAX_SIZE);

(we can use 'to_certs' in the first argument)

but it wasn't added in v8.

-Dov

[1] https://lore.kernel.org/linux-coco/CAAH4kHYOtzgqSTZQFcRiZwPLCkLAThjsCMdjUCdsBTiP=W0Vxw@mail.gmail.com/


> +	if (copy_from_user(to_certs,
> +			   (void __user *)(uintptr_t)params.certs_uaddr,
> +			   params.certs_len)) {
> +		return -EFAULT;
> +	}
> +
> +	sev->snp_certs_len = length;
> +
> +	return 0;
> +}
> +
>  int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_sev_cmd sev_cmd;
> @@ -2503,6 +2584,12 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  	case KVM_SEV_SNP_LAUNCH_FINISH:
>  		r = snp_launch_finish(kvm, &sev_cmd);
>  		break;
> +	case KVM_SEV_SNP_GET_CERTS:
> +		r = snp_get_instance_certs(kvm, &sev_cmd);
> +		break;
> +	case KVM_SEV_SNP_SET_CERTS:
> +		r = snp_set_instance_certs(kvm, &sev_cmd);
> +		break;
>  	default:
>  		r = -EINVAL;
>  		goto out;
> @@ -3550,8 +3637,28 @@ static void snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gp
>  	if (rc)
>  		goto unlock;
>  
> -	rc = snp_guest_ext_guest_request(&req, (unsigned long)sev->snp_certs_data,
> -					 &data_npages, &err);
> +	/*
> +	 * If the VMM has overridden the certs, then change the error message
> +	 * if the size is inappropriate for the override. Otherwise, use a
> +	 * regular guest request and copy back the instance certs.
> +	 */
> +	if (sev->snp_certs_len) {
> +		if ((data_npages << PAGE_SHIFT) < sev->snp_certs_len) {
> +			rc = -EINVAL;
> +			err = SNP_GUEST_REQ_INVALID_LEN;
> +			goto datalen;
> +		}
> +		rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &req,
> +				   (int *)&err);
> +	} else {
> +		rc = snp_guest_ext_guest_request(&req,
> +						 (unsigned long)sev->snp_certs_data,
> +						 &data_npages, &err);
> +	}
> +datalen:
> +	if (sev->snp_certs_len)
> +		data_npages = sev->snp_certs_len >> PAGE_SHIFT;
> +
>  	if (rc) {
>  		/*
>  		 * If buffer length is small then return the expected
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 221b38d3c845..dced46559508 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -94,6 +94,7 @@ struct kvm_sev_info {
>  	u64 snp_init_flags;
>  	void *snp_context;      /* SNP guest context page */
>  	void *snp_certs_data;
> +	unsigned int snp_certs_len; /* Size of instance override for certs */
>  	struct mutex guest_req_lock; /* Lock for guest request handling */
>  
>  	u64 sev_features;	/* Features set at VMSA creation */
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 92116e2b74fd..3b28b78938f6 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -22,7 +22,7 @@
>  #define __psp_pa(x)	__pa(x)
>  #endif
>  
> -#define SEV_FW_BLOB_MAX_SIZE	0x4000	/* 16KB */
> +#define SEV_FW_BLOB_MAX_SIZE	0x5000	/* 20KB */
>  
>  /**
>   * SEV platform state
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 6e684bf5f723..ad7e24e43547 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1928,6 +1928,8 @@ enum sev_cmd_id {
>  	KVM_SEV_SNP_LAUNCH_START,
>  	KVM_SEV_SNP_LAUNCH_UPDATE,
>  	KVM_SEV_SNP_LAUNCH_FINISH,
> +	KVM_SEV_SNP_GET_CERTS,
> +	KVM_SEV_SNP_SET_CERTS,
>  
>  	KVM_SEV_NR_MAX,
>  };
> @@ -2075,6 +2077,16 @@ struct kvm_sev_snp_launch_finish {
>  	__u8 pad[6];
>  };
>  
> +struct kvm_sev_snp_get_certs {
> +	__u64 certs_uaddr;
> +	__u64 certs_len;
> +};
> +
> +struct kvm_sev_snp_set_certs {
> +	__u64 certs_uaddr;
> +	__u64 certs_len;
> +};
> +
>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
>  #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
>  #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
