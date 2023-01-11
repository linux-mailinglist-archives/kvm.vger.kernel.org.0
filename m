Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE6FE665E2C
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 15:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbjAKOlt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 09:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239272AbjAKOlN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 09:41:13 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED65ACF9;
        Wed, 11 Jan 2023 06:40:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1673447931; bh=KGDHyrq93FiiZx1EhWmtnBQOkzL5jkL4/UViqKUSfL4=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=T1i/unbasWn85o+aPTED4yXFVg7aLTucnQyk8ryAaSmEqmPCfyf+rETycugwO24rQ
         fF7XuH5tCyDA/r2I+smEDWAhExcHBWpcZo/bQzLzrLCJxB4Ity0JowhbE41cCDZr5z
         v0oaGYPBY5pBnLO0otKZQRVpojZvkUqmEy7xCoqCuex4IL+xRZ23QY9UdK9HeSVVOq
         phoPQrIJj5wX3fJBvaPOslFYXdFXFVlCeWDI7sgfOwjWq9YlXJXvUd5mBjszRoyVSi
         aibeKXgnonXYZ0Knv71UPYJBj3HWkamsneodQ2Oaw5uKdGPtiuB8p1EDavrOJ70UtA
         jai1ONqaNRt3A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from localhost ([134.147.254.72]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MCsPy-1p6qoF0gMa-008niX; Wed, 11
 Jan 2023 15:38:51 +0100
Date:   Wed, 11 Jan 2023 15:38:36 +0100
From:   Tom Dohrmann <erbse.13@gmx.de>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        harald@profian.com, Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH RFC v7 47/64] KVM: SVM: Add support to handle MSR based
 Page State Change VMGEXIT
Message-ID: <Y77J7C2E9Xd1QcmZ@notebook>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-48-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214194056.161492-48-michael.roth@amd.com>
X-Provags-ID: V03:K1:fyBxy7/U5oJ/3CUIg8Fre+QtVDGfqDpzpl+I0WKzziUfm4MtvXH
 AN3QAiMSkM5UBh+zOT1MtudGYJsm/9WAwTwuQVrW9T1IKHRY/XUiKRphImWDNWTF9ABn9xS
 j/kH6EL/jxWkwofoHGGaOkbeNgGASfqpYy+Y8tEvaCU+RPPS/pXtABfeyrJlD6mKnOtM+Ku
 xbRNGzskdvgqgPvCL3wtA==
UI-OutboundReport: notjunk:1;M01:P0:dH+xw7ymR9w=;cLUfesrjFWuy3u94c3rIF8n1+Nx
 Te1okBEsYhishwY+PSwiZ9P45qQcafKVEnwg3kwi7G7qUJE90dCwVjb61fzHJIflyBk7bp8S8
 lWAvq0IlNkcNvdGdX61wK824zpC/0hO/MFKDUQGAYyifvcDl+VBfjTpBv/PYwzL3rER+wz4xZ
 is1MgUjXQdM3U403EuPgq2Ian1vDg1IaXwLA5IFBxk8344enYegAvdZuBir+BVdQ3yTkcTULi
 F3LMNqn/aznyBRhKXh6k+YVoMV7rGaUlIVU0CkwOXrmJYnJZHZD81KhdCQ82AidNp2FwShiXr
 HKj8LP8ZM6os69A3u20QKAww3ocLBz1hvdabDtXGfK/rn5PO1JEmBfJi8SXEUy4rxKIEjaJ24
 feK7F6jUf4wmyKAL1iZbQQoYprtKQ2nnJblgjepW9Q98t4ejFpmHKRjaO7C2jh4/tTRJjMoto
 CNcjQ2u8My7e94rboXSXB6DD/4UjK4e5FbIe//pVhikhjqKtE8bpG1Ndt/kjdDR92aqZBlbmc
 zqMan439EU+mrtTqeeNIH/Gk3HNX/xhlm+eY5rrVjus9a3lFqtsYazgVbUPfPWfpcilNnAod4
 buXxXnm/JwKKOWc2Rpm/8azzTVFxqcUqZAA4ZbpBWIUO6jgJjt10WwyrbWQZzB5pA7HohRjx6
 LsCd8d38mENFHkKleNmaFZwOgltfEcW7/EIN5iAySLJB/xs++G7f4MCCj7WxMWxOZOn9VYxI1
 euOwd8rDf/dp1TBKgqbq3uB9ERjjI6yEssBhsBoMikcgZT7aN7hix/C/zbvgwzXkj2BuD5YBy
 IeWGwk6ftwt+oCAZiRTr/BynKmVaWZy4DdRIO3dHZMSkk0CklYUyCyKKDUijX0qiQaTluWlVB
 eMvyTAjNqfTFqMfTP+1LH3WPIHxALQ13f5Yo48Fhw1v5VuFn6+j8WYM5pHjGt//AqZq2rL2rV
 7WQk5LKZadDRgYgVCTSLA378BFk=
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_FILL_THIS_FORM_SHORT autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 14, 2022 at 01:40:39PM -0600, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> SEV-SNP VMs can ask the hypervisor to change the page state in the RMP
> table to be private or shared using the Page State Change MSR protocol
> as defined in the GHCB specification.
>
> Forward these requests to userspace via KVM_EXIT_VMGEXIT so the VMM can
> issue the KVM ioctls to update the page state accordingly.
>
> Co-developed-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/include/asm/sev-common.h |  9 ++++++++
>  arch/x86/kvm/svm/sev.c            | 25 +++++++++++++++++++++++
>  arch/x86/kvm/trace.h              | 34 +++++++++++++++++++++++++++++++
>  arch/x86/kvm/x86.c                |  1 +
>  4 files changed, 69 insertions(+)
>
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/se=
v-common.h
> index 0a9055cdfae2..ee38f7408470 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -93,6 +93,10 @@ enum psc_op {
>  };
>
>  #define GHCB_MSR_PSC_REQ		0x014
> +#define GHCB_MSR_PSC_GFN_POS		12
> +#define GHCB_MSR_PSC_GFN_MASK		GENMASK_ULL(39, 0)
> +#define GHCB_MSR_PSC_OP_POS		52
> +#define GHCB_MSR_PSC_OP_MASK		0xf
>  #define GHCB_MSR_PSC_REQ_GFN(gfn, op)			\
>  	/* GHCBData[55:52] */				\
>  	(((u64)((op) & 0xf) << 52) |			\
> @@ -102,6 +106,11 @@ enum psc_op {
>  	GHCB_MSR_PSC_REQ)
>
>  #define GHCB_MSR_PSC_RESP		0x015
> +#define GHCB_MSR_PSC_ERROR_POS		32
> +#define GHCB_MSR_PSC_ERROR_MASK		GENMASK_ULL(31, 0)
> +#define GHCB_MSR_PSC_ERROR		GENMASK_ULL(31, 0)
> +#define GHCB_MSR_PSC_RSVD_POS		12
> +#define GHCB_MSR_PSC_RSVD_MASK		GENMASK_ULL(19, 0)
>  #define GHCB_MSR_PSC_RESP_VAL(val)			\
>  	/* GHCBData[63:32] */				\
>  	(((u64)(val) & GENMASK_ULL(63, 32)) >> 32)
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index d7b467b620aa..d7988629073b 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -29,6 +29,7 @@
>  #include "svm_ops.h"
>  #include "cpuid.h"
>  #include "trace.h"
> +#include "mmu.h"
>
>  #ifndef CONFIG_KVM_AMD_SEV
>  /*
> @@ -3350,6 +3351,23 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u6=
4 value)
>  	svm->vmcb->control.ghcb_gpa =3D value;
>  }
>
> +/*
> + * TODO: need to get the value set by userspace in vcpu->run->vmgexit.g=
hcb_msr
> + * and process that here accordingly.
> + */
> +static int snp_complete_psc_msr_protocol(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm =3D to_svm(vcpu);
> +
> +	set_ghcb_msr_bits(svm, 0,
> +			  GHCB_MSR_PSC_ERROR_MASK, GHCB_MSR_PSC_ERROR_POS);
> +
> +	set_ghcb_msr_bits(svm, 0, GHCB_MSR_PSC_RSVD_MASK, GHCB_MSR_PSC_RSVD_PO=
S);
> +	set_ghcb_msr_bits(svm, GHCB_MSR_PSC_RESP, GHCB_MSR_INFO_MASK, GHCB_MSR=
_INFO_POS);
> +
> +	return 1; /* resume */
> +}
> +
>  static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>  {
>  	struct vmcb_control_area *control =3D &svm->vmcb->control;
> @@ -3450,6 +3468,13 @@ static int sev_handle_vmgexit_msr_protocol(struct=
 vcpu_svm *svm)
>  				  GHCB_MSR_INFO_POS);
>  		break;
>  	}
> +	case GHCB_MSR_PSC_REQ:
> +		vcpu->run->exit_reason =3D KVM_EXIT_VMGEXIT;
> +		vcpu->run->vmgexit.ghcb_msr =3D control->ghcb_gpa;
> +		vcpu->arch.complete_userspace_io =3D snp_complete_psc_msr_protocol;
> +
> +		ret =3D -1;
> +		break;

What's the reasoning behind returning an error (-1) here? This error bubbl=
es all
the way up to the `KVM_RUN` ioctl. Would it be more appropriate to return =
0?
Returning 0 would cause a VM exit without indicating an error to userspace=
.

>  	case GHCB_MSR_TERM_REQ: {
>  		u64 reason_set, reason_code;
>
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index 83843379813e..65861d2d086c 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -7,6 +7,7 @@
>  #include <asm/svm.h>
>  #include <asm/clocksource.h>
>  #include <asm/pvclock-abi.h>
> +#include <asm/sev-common.h>
>
>  #undef TRACE_SYSTEM
>  #define TRACE_SYSTEM kvm
> @@ -1831,6 +1832,39 @@ TRACE_EVENT(kvm_vmgexit_msr_protocol_exit,
>  		  __entry->vcpu_id, __entry->ghcb_gpa, __entry->result)
>  );
>
> +/*
> + * Tracepoint for the SEV-SNP page state change processing
> + */
> +#define psc_operation					\
> +	{SNP_PAGE_STATE_PRIVATE, "private"},		\
> +	{SNP_PAGE_STATE_SHARED,  "shared"}		\
> +
> +TRACE_EVENT(kvm_snp_psc,
> +	TP_PROTO(unsigned int vcpu_id, u64 pfn, u64 gpa, u8 op, int level),
> +	TP_ARGS(vcpu_id, pfn, gpa, op, level),
> +
> +	TP_STRUCT__entry(
> +		__field(int, vcpu_id)
> +		__field(u64, pfn)
> +		__field(u64, gpa)
> +		__field(u8, op)
> +		__field(int, level)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->vcpu_id =3D vcpu_id;
> +		__entry->pfn =3D pfn;
> +		__entry->gpa =3D gpa;
> +		__entry->op =3D op;
> +		__entry->level =3D level;
> +	),
> +
> +	TP_printk("vcpu %u, pfn %llx, gpa %llx, op %s, level %d",
> +		  __entry->vcpu_id, __entry->pfn, __entry->gpa,
> +		  __print_symbolic(__entry->op, psc_operation),
> +		  __entry->level)
> +);
> +
>  #endif /* _TRACE_KVM_H */
>
>  #undef TRACE_INCLUDE_PATH
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 732f9cbbadb5..08dd1ef7e136 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13481,6 +13481,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_enter);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_exit);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_enter);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_exit);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_snp_psc);
>
>  static int __init kvm_x86_init(void)
>  {
> --
> 2.25.1
>

Regards, Tom
