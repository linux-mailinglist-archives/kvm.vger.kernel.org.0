Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB43019E18B
	for <lists+kvm@lfdr.de>; Sat,  4 Apr 2020 01:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgDCXrG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 19:47:06 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60474 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbgDCXrF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 19:47:05 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033Ne64k172730;
        Fri, 3 Apr 2020 23:46:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=nLRWJC2thIHFBQoLnBnBk/8K8/szGgd/DwrmZQvszWQ=;
 b=RS1vQ7Tn29VflfbYQ33ImBct25vyzLenFq6bpGfLMj46ef/AdlKrZdt+3++xzQ5vQvKY
 5wHNBuBe9Qef2QiwoSWfkYk3kN/uB7LPP3+xOKkwVQOr4f4+v8uyznZ9pHKJA4dHn9Xr
 URjVRe89jTcDtxps7JJwEwg9+sopQaaEZd/PHnItS+6XEfd717nAiAAkUbBtBZQ5r8A7
 YUmM1K4aO/NvGYzJkNJT+9kNNXFEZbS+0h1tw+Ps5MVp6hxQ9MdbdiBjcPCnuKPQjNh6
 zabvPBdnsCqhCv6l9IiWRzJxROEdYOM3bGZ7QeoGTFio7mLrCj+4cB8NOJY2KLVIFvu0 xQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 303cevkm1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 23:46:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033NcKRx051611;
        Fri, 3 Apr 2020 23:46:35 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 302ga669d4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 23:46:35 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 033NkWC4014576;
        Fri, 3 Apr 2020 23:46:33 GMT
Received: from localhost.localdomain (/10.159.159.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 16:46:32 -0700
Subject: Re: [PATCH v6 13/14] KVM: x86: Introduce new
 KVM_FEATURE_SEV_LIVE_MIGRATION feature & Custom MSR.
To:     Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <21b2119906f4cce10b4133107ece3dab0957c07c.1585548051.git.ashish.kalra@amd.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <f009abf6-0a19-6d82-393c-8a431ce541cb@oracle.com>
Date:   Fri, 3 Apr 2020 16:46:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <21b2119906f4cce10b4133107ece3dab0957c07c.1585548051.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004030178
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 adultscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030178
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/29/20 11:23 PM, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> Add new KVM_FEATURE_SEV_LIVE_MIGRATION feature for guest to check
> for host-side support for SEV live migration. Also add a new custom
> MSR_KVM_SEV_LIVE_MIG_EN for guest to enable the SEV live migration
> feature.
>
> Also, ensure that _bss_decrypted section is marked as decrypted in the
> page encryption bitmap.
>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>   Documentation/virt/kvm/cpuid.rst     |  4 ++++
>   Documentation/virt/kvm/msr.rst       | 10 ++++++++++
>   arch/x86/include/asm/kvm_host.h      |  3 +++
>   arch/x86/include/uapi/asm/kvm_para.h |  5 +++++
>   arch/x86/kernel/kvm.c                |  4 ++++
>   arch/x86/kvm/cpuid.c                 |  3 ++-
>   arch/x86/kvm/svm.c                   |  5 +++++
>   arch/x86/kvm/x86.c                   |  7 +++++++
>   arch/x86/mm/mem_encrypt.c            | 14 +++++++++++++-
>   9 files changed, 53 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
> index 01b081f6e7ea..fcb191bb3016 100644
> --- a/Documentation/virt/kvm/cpuid.rst
> +++ b/Documentation/virt/kvm/cpuid.rst
> @@ -86,6 +86,10 @@ KVM_FEATURE_PV_SCHED_YIELD        13          guest checks this feature bit
>                                                 before using paravirtualized
>                                                 sched yield.
>   
> +KVM_FEATURE_SEV_LIVE_MIGRATION    14          guest checks this feature bit
> +                                              before enabling SEV live
> +                                              migration feature.
> +
>   KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          host will warn if no guest-side
>                                                 per-cpu warps are expeced in
>                                                 kvmclock
> diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
> index 33892036672d..7cd7786bbb03 100644
> --- a/Documentation/virt/kvm/msr.rst
> +++ b/Documentation/virt/kvm/msr.rst
> @@ -319,3 +319,13 @@ data:
>   
>   	KVM guests can request the host not to poll on HLT, for example if
>   	they are performing polling themselves.
> +
> +MSR_KVM_SEV_LIVE_MIG_EN:
> +        0x4b564d06
> +
> +	Control SEV Live Migration features.
> +
> +data:
> +        Bit 0 enables (1) or disables (0) host-side SEV Live Migration feature.
> +        Bit 1 enables (1) or disables (0) support for SEV Live Migration extensions.
> +        All other bits are reserved.
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index a96ef6338cd2..ad5faaed43c0 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -780,6 +780,9 @@ struct kvm_vcpu_arch {
>   
>   	u64 msr_kvm_poll_control;
>   
> +	/* SEV Live Migration MSR (AMD only) */
> +	u64 msr_kvm_sev_live_migration_flag;
> +
>   	/*
>   	 * Indicates the guest is trying to write a gfn that contains one or
>   	 * more of the PTEs used to translate the write itself, i.e. the access
> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index 2a8e0b6b9805..d9d4953b42ad 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -31,6 +31,7 @@
>   #define KVM_FEATURE_PV_SEND_IPI	11
>   #define KVM_FEATURE_POLL_CONTROL	12
>   #define KVM_FEATURE_PV_SCHED_YIELD	13
> +#define KVM_FEATURE_SEV_LIVE_MIGRATION	14
>   
>   #define KVM_HINTS_REALTIME      0
>   
> @@ -50,6 +51,7 @@
>   #define MSR_KVM_STEAL_TIME  0x4b564d03
>   #define MSR_KVM_PV_EOI_EN      0x4b564d04
>   #define MSR_KVM_POLL_CONTROL	0x4b564d05
> +#define MSR_KVM_SEV_LIVE_MIG_EN	0x4b564d06
>   
>   struct kvm_steal_time {
>   	__u64 steal;
> @@ -122,4 +124,7 @@ struct kvm_vcpu_pv_apf_data {
>   #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
>   #define KVM_PV_EOI_DISABLED 0x0
>   
> +#define KVM_SEV_LIVE_MIGRATION_ENABLED			(1 << 0)
> +#define KVM_SEV_LIVE_MIGRATION_EXTENSIONS_SUPPORTED	(1 << 1)
> +
>   #endif /* _UAPI_ASM_X86_KVM_PARA_H */
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 6efe0410fb72..8fcee0b45231 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -418,6 +418,10 @@ static void __init sev_map_percpu_data(void)
>   	if (!sev_active())
>   		return;
>   
> +	if (kvm_para_has_feature(KVM_FEATURE_SEV_LIVE_MIGRATION)) {
> +		wrmsrl(MSR_KVM_SEV_LIVE_MIG_EN, KVM_SEV_LIVE_MIGRATION_ENABLED);
> +	}
> +
>   	for_each_possible_cpu(cpu) {
>   		__set_percpu_decrypted(&per_cpu(apf_reason, cpu), sizeof(apf_reason));
>   		__set_percpu_decrypted(&per_cpu(steal_time, cpu), sizeof(steal_time));
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index b1c469446b07..74c8b2a7270c 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -716,7 +716,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>   			     (1 << KVM_FEATURE_ASYNC_PF_VMEXIT) |
>   			     (1 << KVM_FEATURE_PV_SEND_IPI) |
>   			     (1 << KVM_FEATURE_POLL_CONTROL) |
> -			     (1 << KVM_FEATURE_PV_SCHED_YIELD);
> +			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
> +			     (1 << KVM_FEATURE_SEV_LIVE_MIGRATION);
>   
>   		if (sched_info_on())
>   			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index c99b0207a443..60ddc242a133 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -7632,6 +7632,7 @@ static int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
>   				  unsigned long npages, unsigned long enc)
>   {
>   	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_vcpu *vcpu = kvm->vcpus[0];
>   	kvm_pfn_t pfn_start, pfn_end;
>   	gfn_t gfn_start, gfn_end;
>   	int ret;
> @@ -7639,6 +7640,10 @@ static int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
>   	if (!sev_guest(kvm))
>   		return -EINVAL;
>   
> +	if (!(vcpu->arch.msr_kvm_sev_live_migration_flag &
> +		KVM_SEV_LIVE_MIGRATION_ENABLED))
> +		return -ENOTTY;
> +
>   	if (!npages)
>   		return 0;
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2127ed937f53..82867b8798f8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2880,6 +2880,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		vcpu->arch.msr_kvm_poll_control = data;
>   		break;
>   
> +	case MSR_KVM_SEV_LIVE_MIG_EN:
> +		vcpu->arch.msr_kvm_sev_live_migration_flag = data;
> +		break;
> +
>   	case MSR_IA32_MCG_CTL:
>   	case MSR_IA32_MCG_STATUS:
>   	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
> @@ -3126,6 +3130,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   	case MSR_KVM_POLL_CONTROL:
>   		msr_info->data = vcpu->arch.msr_kvm_poll_control;
>   		break;
> +	case MSR_KVM_SEV_LIVE_MIG_EN:
> +		msr_info->data = vcpu->arch.msr_kvm_sev_live_migration_flag;
> +		break;
>   	case MSR_IA32_P5_MC_ADDR:
>   	case MSR_IA32_P5_MC_TYPE:
>   	case MSR_IA32_MCG_CAP:
> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index c9800fa811f6..f6a841494845 100644
> --- a/arch/x86/mm/mem_encrypt.c
> +++ b/arch/x86/mm/mem_encrypt.c
> @@ -502,8 +502,20 @@ void __init mem_encrypt_init(void)
>   	 * With SEV, we need to make a hypercall when page encryption state is
>   	 * changed.
>   	 */
> -	if (sev_active())
> +	if (sev_active()) {
> +		unsigned long nr_pages;
> +
>   		pv_ops.mmu.page_encryption_changed = set_memory_enc_dec_hypercall;
> +
> +		/*
> +		 * Ensure that _bss_decrypted section is marked as decrypted in the
> +		 * page encryption bitmap.
> +		 */
> +		nr_pages = DIV_ROUND_UP(__end_bss_decrypted - __start_bss_decrypted,
> +			PAGE_SIZE);
> +		set_memory_enc_dec_hypercall((unsigned long)__start_bss_decrypted,
> +			nr_pages, 0);
> +	}
>   #endif
>   
>   	pr_info("AMD %s active\n",
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
