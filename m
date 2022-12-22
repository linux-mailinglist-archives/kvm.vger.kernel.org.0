Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E408654373
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 15:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235515AbiLVO64 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 09:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiLVO6y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 09:58:54 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37E71EC55;
        Thu, 22 Dec 2022 06:58:53 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BMEcgOV037417;
        Thu, 22 Dec 2022 14:57:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=XL1hZNgrmOg9cH6ry3OwTUd/lTK9egdtoBeKA3RpoBs=;
 b=awHM/ztat81t3bGwLLSRdGBY4j0lBgPoyXma0KO2R9KCMbpRORinlKfw56d/CwzLYCMX
 n7KULpjGKvEAj11fNk8ME34kN0eHq4l8+VGDcCmP/lrGAPm04vEEH6Jj2n0XyWlUNGGz
 o9mh1yIBrozckj10DpUNl8ITblAKKAe8szXdbKNNRICZZ8pS/asM3nqf6sEWgdydaKF3
 6ElwIIxh0g6Or5JgFZNpj56V8hTfknpI6LH4+u5HL3EbXFvU9h2PFBD67XuT1anLi3PF
 9Eo2UWMcQzWBhhbrjYOdX6HwPNBj8PhnaUFCmPw5FRTmUMAGXAh6Me0FiqnmenTY8rga Ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mmrsnh2fm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Dec 2022 14:57:43 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BMEv18W002601;
        Thu, 22 Dec 2022 14:57:42 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mmrsnh2ew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Dec 2022 14:57:42 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BMCaeJ6022055;
        Thu, 22 Dec 2022 14:57:40 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([9.208.130.100])
        by ppma03wdc.us.ibm.com (PPS) with ESMTPS id 3mh6yy25wg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Dec 2022 14:57:40 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
        by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BMEvdvs57278816
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Dec 2022 14:57:39 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB02C58056;
        Thu, 22 Dec 2022 14:57:39 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A10735803F;
        Thu, 22 Dec 2022 14:57:31 +0000 (GMT)
Received: from [9.160.79.63] (unknown [9.160.79.63])
        by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 22 Dec 2022 14:57:31 +0000 (GMT)
Message-ID: <1c02cc0d-9f0c-cf4a-b012-9932f551dd83@linux.ibm.com>
Date:   Thu, 22 Dec 2022 16:57:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH RFC v7 62/64] x86/sev: Add KVM commands for instance certs
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        tobin@ibm.com, bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        harald@profian.com, Dionna Glaze <dionnaglaze@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-63-michael.roth@amd.com>
From:   Dov Murik <dovmurik@linux.ibm.com>
In-Reply-To: <20221214194056.161492-63-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Vmc8E9jK40yCYYa9Yu3ItgHPAwELMYH9
X-Proofpoint-GUID: abweW81WQRFpje3SmNwzKQF3FrWvXWzr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-22_08,2022-12-22_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxlogscore=999 clxscore=1011 spamscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212220127
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Dionna, Mike,

On 14/12/2022 21:40, Michael Roth wrote:
> From: Dionna Glaze <dionnaglaze@google.com>
> 
> The /dev/sev device has the ability to store host-wide certificates for
> the key used by the AMD-SP for SEV-SNP attestation report signing,
> but for hosts that want to specify additional certificates that are
> specific to the image launched in a VM, a different way is needed to
> communicate those certificates.
> 
> This patch adds two new KVM ioctl commands: KVM_SEV_SNP_{GET,SET}_CERTS
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
> We also increase the SEV_FW_BLOB_MAX_SIZE another 4K page to allow
> space for an extra certificate.
> 
> Cc: Tom Lendacky <Thomas.Lendacky@amd.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> 
> Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c   | 111 ++++++++++++++++++++++++++++++++++++++-
>  arch/x86/kvm/svm/svm.h   |   1 +
>  include/linux/psp-sev.h  |   2 +-
>  include/uapi/linux/kvm.h |  12 +++++
>  4 files changed, 123 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 4de952d1d446..d0e58cffd1ed 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2081,6 +2081,7 @@ static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  		goto e_free;
>  
>  	sev->snp_certs_data = certs_data;
> +	sev->snp_certs_len = 0;
>  
>  	return context;
>  
> @@ -2364,6 +2365,86 @@ static int snp_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
> +	if (copy_from_user(to_certs,
> +			   (void __user *)(uintptr_t)params.certs_uaddr,
> +			   params.certs_len)) {
> +		return -EFAULT;
> +	}
> +
> +	sev->snp_certs_len = length;

Here we set the length to the page-aligned value, but we copy only
params.cert_len bytes.  If there are two subsequent
snp_set_instance_certs() calls where the second one has a shorter
length, we might "keep" some leftover bytes from the first call.

Consider:
1. snp_set_instance_certs(certs_addr point to "AAA...", certs_len=8192)
2. snp_set_instance_certs(certs_addr point to "BBB...", certs_len=4097)

If I understand correctly, on the second call we'll copy 4097 "BBB..."
bytes into the to_certs buffer, but length will be (4096 + PAGE_SIZE -
1) & PAGE_MASK which will be 8192.

Later when fetching the certs (for the extended report or in
snp_get_instance_certs()) the user will get a buffer of 8192 bytes
filled with 4097 BBBs and 4095 leftover AAAs.

Maybe zero sev->snp_certs_data entirely before writing to it?

Related question (not only for this patch) regarding snp_certs_data
(host or per-instance): why is its size page-aligned at all? why is it
limited by 16KB or 20KB? If I understand correctly, for SNP, this buffer
is never sent to the PSP.

> +
> +	return 0;
> +}
> +
>  int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_sev_cmd sev_cmd;

[...]

> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index a1e6624540f3..970a9de0ed20 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -22,7 +22,7 @@
>  #define __psp_pa(x)	__pa(x)
>  #endif
>  
> -#define SEV_FW_BLOB_MAX_SIZE	0x4000	/* 16KB */
> +#define SEV_FW_BLOB_MAX_SIZE	0x5000	/* 20KB */
>  

This has effects in drivers/crypto/ccp/sev-dev.c
                                                               (for
example in alloc_snp_host_map).  Is that OK?


-Dov

>  /**
>   * SEV platform state
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 61b1e26ced01..48bcc59cf86b 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1949,6 +1949,8 @@ enum sev_cmd_id {
>  	KVM_SEV_SNP_LAUNCH_START,
>  	KVM_SEV_SNP_LAUNCH_UPDATE,
>  	KVM_SEV_SNP_LAUNCH_FINISH,
> +	KVM_SEV_SNP_GET_CERTS,
> +	KVM_SEV_SNP_SET_CERTS,
>  
>  	KVM_SEV_NR_MAX,
>  };
> @@ -2096,6 +2098,16 @@ struct kvm_sev_snp_launch_finish {
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
