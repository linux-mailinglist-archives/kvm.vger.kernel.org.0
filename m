Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C663400E7B
	for <lists+kvm@lfdr.de>; Sun,  5 Sep 2021 08:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbhIEG73 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Sep 2021 02:59:29 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23294 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230076AbhIEG72 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 5 Sep 2021 02:59:28 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1856Xomw124685;
        Sun, 5 Sep 2021 02:57:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=GlhxVH8FDmNBYcDsNTMeDx5O2fgQyE110SKifBhF/Yg=;
 b=gw4IVCl9B+lgweDkhSFgmJge7MptLV5arjZXU/l8ZhLrdcZAdHNSB4pK2/vaL4Hc8NFz
 wJgURnb6mNJRXiZ6OkAGVkBsg7ITAbjF0v78n8TmDDvgFhLPjvC4gfNqBWJVnlVRTblz
 9VGEpNTdr4mSVxxSAiPEVO7qlrqh3UcBm7/6TKgpgjsGeyMkUL9yd2ZNNlz4N1qsJKbf
 ugyVZxoYErwNLZ2XjRcj4//J83W5L0XcD7iQlrSVRFTSsi0x+h5HMi5kaOUc/gsdruEg
 fXKj93NCCcb1+EI10Cv7YrrXkPCR/jdFCiRehGiL0dJeILd/cHASHcMlw/Zb4EGwAz4U Mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3avpau29w2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 05 Sep 2021 02:57:07 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1856v6WS189406;
        Sun, 5 Sep 2021 02:57:06 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3avpau29vs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 05 Sep 2021 02:57:06 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1856r8Xk020039;
        Sun, 5 Sep 2021 06:57:05 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma04dal.us.ibm.com with ESMTP id 3avbhwrx1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 05 Sep 2021 06:57:05 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1856v4uf35258830
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 5 Sep 2021 06:57:04 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6DD7C6057;
        Sun,  5 Sep 2021 06:57:03 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65AC4C6055;
        Sun,  5 Sep 2021 06:56:55 +0000 (GMT)
Received: from [9.65.84.185] (unknown [9.65.84.185])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sun,  5 Sep 2021 06:56:55 +0000 (GMT)
Subject: Re: [PATCH Part2 v5 23/45] KVM: SVM: Add KVM_SNP_INIT command
To:     Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        Pavan Kumar Paluri <papaluri@amd.com>,
        Dov Murik <dovmurik@linux.ibm.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-24-brijesh.singh@amd.com>
From:   Dov Murik <dovmurik@linux.ibm.com>
Message-ID: <66c9694a-bd1a-0a12-8c1d-326d34daaac2@linux.ibm.com>
Date:   Sun, 5 Sep 2021 09:56:53 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210820155918.7518-24-brijesh.singh@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Dgm_YsXvcRNfZRPdSnasUtiXEjwJZHpX
X-Proofpoint-ORIG-GUID: 8gJPvro4FJnD_kIYvGsZKe0ZsP5vDfIw
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-04_09:2021-09-03,2021-09-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxscore=0
 malwarescore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 suspectscore=0 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109050043
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Brijesh,

On 20/08/2021 18:58, Brijesh Singh wrote:
> The KVM_SNP_INIT command is used by the hypervisor to initialize the
> SEV-SNP platform context. In a typical workflow, this command should be the
> first command issued. When creating SEV-SNP guest, the VMM must use this
> command instead of the KVM_SEV_INIT or KVM_SEV_ES_INIT.
> 
> The flags value must be zero, it will be extended in future SNP support to
> communicate the optional features (such as restricted INT injection etc).
> 
> Co-developed-by: Pavan Kumar Paluri <papaluri@amd.com>
> Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  .../virt/kvm/amd-memory-encryption.rst        | 27 ++++++++++++
>  arch/x86/include/asm/svm.h                    |  2 +
>  arch/x86/kvm/svm/sev.c                        | 44 ++++++++++++++++++-
>  arch/x86/kvm/svm/svm.h                        |  4 ++
>  include/uapi/linux/kvm.h                      | 13 ++++++
>  5 files changed, 88 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> index 5c081c8c7164..7b1d32fb99a8 100644
> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> @@ -427,6 +427,33 @@ issued by the hypervisor to make the guest ready for execution.
>  
>  Returns: 0 on success, -negative on error
>  
> +18. KVM_SNP_INIT
> +----------------
> +
> +The KVM_SNP_INIT command can be used by the hypervisor to initialize SEV-SNP
> +context. In a typical workflow, this command should be the first command issued.
> +
> +Parameters (in/out): struct kvm_snp_init
> +
> +Returns: 0 on success, -negative on error
> +
> +::
> +
> +        struct kvm_snp_init {
> +                __u64 flags;
> +        };
> +
> +The flags bitmap is defined as::
> +
> +   /* enable the restricted injection */
> +   #define KVM_SEV_SNP_RESTRICTED_INJET   (1<<0)
> +
> +   /* enable the restricted injection timer */
> +   #define KVM_SEV_SNP_RESTRICTED_TIMER_INJET   (1<<1)

Typo in these flags: s/INJET/INJECT/

Also in the actual .h file below.


-Dov


> +
> +If the specified flags is not supported then return -EOPNOTSUPP, and the supported
> +flags are returned.
> +
>  References
>  ==========
>  
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 44a3f920f886..a39e31845a33 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -218,6 +218,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>  #define SVM_NESTED_CTL_SEV_ENABLE	BIT(1)
>  #define SVM_NESTED_CTL_SEV_ES_ENABLE	BIT(2)
>  
> +#define SVM_SEV_FEAT_SNP_ACTIVE		BIT(0)
> +
>  struct vmcb_seg {
>  	u16 selector;
>  	u16 attrib;
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 50fddbe56981..93da463545ef 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -235,10 +235,30 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
>  	sev_decommission(handle);
>  }
>  
> +static int verify_snp_init_flags(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_snp_init params;
> +	int ret = 0;
> +
> +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
> +		return -EFAULT;
> +
> +	if (params.flags & ~SEV_SNP_SUPPORTED_FLAGS)
> +		ret = -EOPNOTSUPP;
> +
> +	params.flags = SEV_SNP_SUPPORTED_FLAGS;
> +
> +	if (copy_to_user((void __user *)(uintptr_t)argp->data, &params, sizeof(params)))
> +		ret = -EFAULT;
> +
> +	return ret;
> +}
> +
>  static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
> +	bool es_active = (argp->id == KVM_SEV_ES_INIT || argp->id == KVM_SEV_SNP_INIT);
>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> -	bool es_active = argp->id == KVM_SEV_ES_INIT;
> +	bool snp_active = argp->id == KVM_SEV_SNP_INIT;
>  	int asid, ret;
>  
>  	if (kvm->created_vcpus)
> @@ -249,12 +269,22 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  		return ret;
>  
>  	sev->es_active = es_active;
> +	sev->snp_active = snp_active;
>  	asid = sev_asid_new(sev);
>  	if (asid < 0)
>  		goto e_no_asid;
>  	sev->asid = asid;
>  
> -	ret = sev_platform_init(&argp->error);
> +	if (snp_active) {
> +		ret = verify_snp_init_flags(kvm, argp);
> +		if (ret)
> +			goto e_free;
> +
> +		ret = sev_snp_init(&argp->error);
> +	} else {
> +		ret = sev_platform_init(&argp->error);
> +	}
> +
>  	if (ret)
>  		goto e_free;
>  
> @@ -600,6 +630,10 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>  	save->pkru = svm->vcpu.arch.pkru;
>  	save->xss  = svm->vcpu.arch.ia32_xss;
>  
> +	/* Enable the SEV-SNP feature */
> +	if (sev_snp_guest(svm->vcpu.kvm))
> +		save->sev_features |= SVM_SEV_FEAT_SNP_ACTIVE;
> +
>  	return 0;
>  }
>  
> @@ -1532,6 +1566,12 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  	}
>  
>  	switch (sev_cmd.id) {
> +	case KVM_SEV_SNP_INIT:
> +		if (!sev_snp_enabled) {
> +			r = -ENOTTY;
> +			goto out;
> +		}
> +		fallthrough;
>  	case KVM_SEV_ES_INIT:
>  		if (!sev_es_enabled) {
>  			r = -ENOTTY;
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 01953522097d..57c3c404b0b3 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -69,6 +69,9 @@ enum {
>  /* TPR and CR2 are always written before VMRUN */
>  #define VMCB_ALWAYS_DIRTY_MASK	((1U << VMCB_INTR) | (1U << VMCB_CR2))
>  
> +/* Supported init feature flags */
> +#define SEV_SNP_SUPPORTED_FLAGS		0x0
> +
>  struct kvm_sev_info {
>  	bool active;		/* SEV enabled guest */
>  	bool es_active;		/* SEV-ES enabled guest */
> @@ -81,6 +84,7 @@ struct kvm_sev_info {
>  	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
>  	struct kvm *enc_context_owner; /* Owner of copied encryption context */
>  	struct misc_cg *misc_cg; /* For misc cgroup accounting */
> +	u64 snp_init_flags;
>  };
>  
>  struct kvm_svm {
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index d9e4aabcb31a..944e2bf601fe 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1712,6 +1712,9 @@ enum sev_cmd_id {
>  	/* Guest Migration Extension */
>  	KVM_SEV_SEND_CANCEL,
>  
> +	/* SNP specific commands */
> +	KVM_SEV_SNP_INIT,
> +
>  	KVM_SEV_NR_MAX,
>  };
>  
> @@ -1808,6 +1811,16 @@ struct kvm_sev_receive_update_data {
>  	__u32 trans_len;
>  };
>  
> +/* enable the restricted injection */
> +#define KVM_SEV_SNP_RESTRICTED_INJET   (1 << 0)
> +
> +/* enable the restricted injection timer */
> +#define KVM_SEV_SNP_RESTRICTED_TIMER_INJET   (1 << 1)
> +
> +struct kvm_snp_init {
> +	__u64 flags;
> +};
> +
>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
>  #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
>  #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
> 
