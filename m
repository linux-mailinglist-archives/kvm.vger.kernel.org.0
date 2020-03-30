Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE1319802E
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 17:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729697AbgC3Pu6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 11:50:58 -0400
Received: from mail-bn8nam11on2058.outbound.protection.outlook.com ([40.107.236.58]:6229
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729319AbgC3Pu6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 11:50:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ENUUhXnGIUgUqX6x0zX/9O7g2dv5UzxMFaRAMHAS9AAB0hSpDyj/ouc7PPNv/Cul2Yny0Pq7lNsCp+IC3laW6JqM6cOmQhYqDJwHqG2FywRsyP4ciYhMQMFujn+/ua6uU6rDtE+uKkB4AKfccTk5fUwRYGqzpgJHI9wSDsEJQuR9jJU40J9Puj75SgPdzyiBJ3WqTk1pbd3ET9/2Jjs5Xf5AmGF2OntPvVrvvLob896CuXFyGLpd9K86PPZAAiaAxuLy7V+9R1iDwXKV5Aqeg5nmgv4iIAVNPyVpr0vx7XPk35KMKkJ3I5hfs6ftxB5HWwge7SOOwmQNNT9U8d2ArA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zSNgUXuGx4mNWgSoK+kJxiUaasNR5gANnfxFiIWBluo=;
 b=mSYv17bHgf62ftzeUYOenmTgxSKpMki9jf/tSel9k4bNnm4581UIse0CovTjgnOzQQOrOPL/05/wpaWgixZR6/HYMx5u1drbu3S5wP0BMPix3LUjmiHOA6DMJGmltJ+fqa4NjK1arvTFBqJ+ZRVczG96ybGwM+AFAmNgigmMMUjfUAsNrLZvWQbqHlHGKeHTybOH/17nZhdT8YQ+dmXExcM2N/t96iPy+ymBj7aiKuvHh1YXyoeGaFYYei6z1JOmaerdZZTwL/BkyEsOiKLmYkkxNtZz0nqeccS2WpR2IwJ8Lrs92MHOzwfWYkNcUgQSG+f+UO9wJ6y8T/FU2VG3Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zSNgUXuGx4mNWgSoK+kJxiUaasNR5gANnfxFiIWBluo=;
 b=1qztGcP6M6aUmLsoEfllnJ0zvtX04x2Hmb6NvZfso6zN1jsnWLr8DQsBXs4Fwli2DdyQP7n8lmEvzgPI4+kM+pKB0DlmvINVei+hlqXTskljdciqoC9T+f9oQ1r0SoqrpNoSnRRLxbUllTKtmTVGSR37uwmzR4psi3Kkapj8z2E=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
Received: from SA0PR12MB4400.namprd12.prod.outlook.com (2603:10b6:806:95::13)
 by SA0PR12MB4477.namprd12.prod.outlook.com (2603:10b6:806:92::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Mon, 30 Mar
 2020 15:50:55 +0000
Received: from SA0PR12MB4400.namprd12.prod.outlook.com
 ([fe80::60d9:da58:71b4:35f3]) by SA0PR12MB4400.namprd12.prod.outlook.com
 ([fe80::60d9:da58:71b4:35f3%7]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 15:50:55 +0000
Cc:     brijesh.singh@amd.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        srutherford@google.com, luto@kernel.org
Subject: Re: [PATCH v6 13/14] KVM: x86: Introduce new
 KVM_FEATURE_SEV_LIVE_MIGRATION feature & Custom MSR.
To:     Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <21b2119906f4cce10b4133107ece3dab0957c07c.1585548051.git.ashish.kalra@amd.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <9ab53cb5-5cfd-ee63-74ae-0a3188adffcc@amd.com>
Date:   Mon, 30 Mar 2020 10:52:16 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <21b2119906f4cce10b4133107ece3dab0957c07c.1585548051.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: SN6PR04CA0104.namprd04.prod.outlook.com
 (2603:10b6:805:f2::45) To SA0PR12MB4400.namprd12.prod.outlook.com
 (2603:10b6:806:95::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN6PR04CA0104.namprd04.prod.outlook.com (2603:10b6:805:f2::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Mon, 30 Mar 2020 15:50:54 +0000
X-Originating-IP: [70.112.153.56]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 269a30b8-2f37-4911-d388-08d7d4c221aa
X-MS-TrafficTypeDiagnostic: SA0PR12MB4477:|SA0PR12MB4477:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4477ADA6D7B5C5422E033A37E5CB0@SA0PR12MB4477.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(136003)(366004)(39860400002)(346002)(376002)(36756003)(31686004)(316002)(5660300002)(16526019)(6506007)(53546011)(6486002)(186003)(7416002)(26005)(6512007)(6666004)(8936002)(52116002)(66556008)(66476007)(86362001)(478600001)(66946007)(31696002)(4326008)(44832011)(81166006)(8676002)(956004)(2906002)(81156014)(2616005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YXexDIB2Vv1i1MZuXQKzfOHKFiAnR/lUXxUrVQz5qp0zRjJkDeTZjtKQdO1sWVit/7uaWpBDKHyyw46FGtnBYHfRm0dIlO1dpMbUck1QIXtdqrcitac8UXFva4079aXGHiies6w5XSYFm5S3NySs37Cm5/UQcJn+7QuC9fZzsg5bgfnEjaxWXLgkBWmADw90riuMgcQuxa91EtE3/qnOh9N2lhJPDkF3aH7gmXmiZgPQPF6+IAHdSW0EY8ikPQxmWPHRDAtMcwXR5J/NH6/NNJvollkvbhTeLRknsLHXyEFGTOa8jqOmxL65VPiIarajiUwOTSBCzDP98AFgYho0d+5g8Ej1eLWYWpje9UEhPCWMD8Yr/n79YTbcalVPgWFjR8kaMu/AKNjTl+OmKaVpR6DCCFBEj9reaB0mChLLU9X50j1aryzsSPi/XEjPyK7j
X-MS-Exchange-AntiSpam-MessageData: n3s0TDyeT9o6GuedPJ3U2Dlm2dScxif0m1vuCZCA5RiEicz2pkYIQvFXtFEmx60UluYEAi+VG2M3c1lGa+WFmy3m1aMKtAmEzVhUkQZ/eBcTe27vGl+cW1mrwj1ypwmYBRyobSCxiDbSaa7+zuXfZw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 269a30b8-2f37-4911-d388-08d7d4c221aa
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 15:50:55.1633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O0avJDD2ZmnuLtHhBo1rKixvNLyj+O7jRh2o5x8AbULWI4/bvoPZI3kheWBGJ4sIkhZMQuqyKJK2gsD0ViRctA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4477
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/30/20 1:23 AM, Ashish Kalra wrote:
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
>  Documentation/virt/kvm/cpuid.rst     |  4 ++++
>  Documentation/virt/kvm/msr.rst       | 10 ++++++++++
>  arch/x86/include/asm/kvm_host.h      |  3 +++
>  arch/x86/include/uapi/asm/kvm_para.h |  5 +++++
>  arch/x86/kernel/kvm.c                |  4 ++++
>  arch/x86/kvm/cpuid.c                 |  3 ++-
>  arch/x86/kvm/svm.c                   |  5 +++++
>  arch/x86/kvm/x86.c                   |  7 +++++++
>  arch/x86/mm/mem_encrypt.c            | 14 +++++++++++++-
>  9 files changed, 53 insertions(+), 2 deletions(-)


IMHO, this patch should be broken into multiple patches as it touches
guest, and hypervisor at the same time. The first patch can introduce
the feature flag in the kvm, second patch can make the changes specific
to svm,  and third patch can focus on how to make use of that feature
inside the guest. Additionally invoking the HC to clear the
__bss_decrypted section should be either squash in Patch 10/14 or be a
separate patch itself.


> diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
> index 01b081f6e7ea..fcb191bb3016 100644
> --- a/Documentation/virt/kvm/cpuid.rst
> +++ b/Documentation/virt/kvm/cpuid.rst
> @@ -86,6 +86,10 @@ KVM_FEATURE_PV_SCHED_YIELD        13          guest checks this feature bit
>                                                before using paravirtualized
>                                                sched yield.
>  
> +KVM_FEATURE_SEV_LIVE_MIGRATION    14          guest checks this feature bit
> +                                              before enabling SEV live
> +                                              migration feature.
> +
>  KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          host will warn if no guest-side
>                                                per-cpu warps are expeced in
>                                                kvmclock
> diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
> index 33892036672d..7cd7786bbb03 100644
> --- a/Documentation/virt/kvm/msr.rst
> +++ b/Documentation/virt/kvm/msr.rst
> @@ -319,3 +319,13 @@ data:
>  
>  	KVM guests can request the host not to poll on HLT, for example if
>  	they are performing polling themselves.
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
>  	u64 msr_kvm_poll_control;
>  
> +	/* SEV Live Migration MSR (AMD only) */
> +	u64 msr_kvm_sev_live_migration_flag;
> +
>  	/*
>  	 * Indicates the guest is trying to write a gfn that contains one or
>  	 * more of the PTEs used to translate the write itself, i.e. the access
> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index 2a8e0b6b9805..d9d4953b42ad 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -31,6 +31,7 @@
>  #define KVM_FEATURE_PV_SEND_IPI	11
>  #define KVM_FEATURE_POLL_CONTROL	12
>  #define KVM_FEATURE_PV_SCHED_YIELD	13
> +#define KVM_FEATURE_SEV_LIVE_MIGRATION	14
>  
>  #define KVM_HINTS_REALTIME      0
>  
> @@ -50,6 +51,7 @@
>  #define MSR_KVM_STEAL_TIME  0x4b564d03
>  #define MSR_KVM_PV_EOI_EN      0x4b564d04
>  #define MSR_KVM_POLL_CONTROL	0x4b564d05
> +#define MSR_KVM_SEV_LIVE_MIG_EN	0x4b564d06
>  
>  struct kvm_steal_time {
>  	__u64 steal;
> @@ -122,4 +124,7 @@ struct kvm_vcpu_pv_apf_data {
>  #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
>  #define KVM_PV_EOI_DISABLED 0x0
>  
> +#define KVM_SEV_LIVE_MIGRATION_ENABLED			(1 << 0)
> +#define KVM_SEV_LIVE_MIGRATION_EXTENSIONS_SUPPORTED	(1 << 1)
> +
>  #endif /* _UAPI_ASM_X86_KVM_PARA_H */
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 6efe0410fb72..8fcee0b45231 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -418,6 +418,10 @@ static void __init sev_map_percpu_data(void)
>  	if (!sev_active())
>  		return;
>  
> +	if (kvm_para_has_feature(KVM_FEATURE_SEV_LIVE_MIGRATION)) {
> +		wrmsrl(MSR_KVM_SEV_LIVE_MIG_EN, KVM_SEV_LIVE_MIGRATION_ENABLED);
> +	}
> +
>  	for_each_possible_cpu(cpu) {
>  		__set_percpu_decrypted(&per_cpu(apf_reason, cpu), sizeof(apf_reason));
>  		__set_percpu_decrypted(&per_cpu(steal_time, cpu), sizeof(steal_time));
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index b1c469446b07..74c8b2a7270c 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -716,7 +716,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>  			     (1 << KVM_FEATURE_ASYNC_PF_VMEXIT) |
>  			     (1 << KVM_FEATURE_PV_SEND_IPI) |
>  			     (1 << KVM_FEATURE_POLL_CONTROL) |
> -			     (1 << KVM_FEATURE_PV_SCHED_YIELD);
> +			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
> +			     (1 << KVM_FEATURE_SEV_LIVE_MIGRATION);


Do we want to enable this feature unconditionally ? Who will clear the
feature flags for the non-SEV guest ?

>  
>  		if (sched_info_on())
>  			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index c99b0207a443..60ddc242a133 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -7632,6 +7632,7 @@ static int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
>  				  unsigned long npages, unsigned long enc)
>  {
>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_vcpu *vcpu = kvm->vcpus[0];
>  	kvm_pfn_t pfn_start, pfn_end;
>  	gfn_t gfn_start, gfn_end;
>  	int ret;
> @@ -7639,6 +7640,10 @@ static int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
>  	if (!sev_guest(kvm))
>  		return -EINVAL;
>  
> +	if (!(vcpu->arch.msr_kvm_sev_live_migration_flag &
> +		KVM_SEV_LIVE_MIGRATION_ENABLED))
> +		return -ENOTTY;
> +
>  	if (!npages)
>  		return 0;
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2127ed937f53..82867b8798f8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2880,6 +2880,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		vcpu->arch.msr_kvm_poll_control = data;
>  		break;
>  
> +	case MSR_KVM_SEV_LIVE_MIG_EN:
> +		vcpu->arch.msr_kvm_sev_live_migration_flag = data;
> +		break;
> +
>  	case MSR_IA32_MCG_CTL:
>  	case MSR_IA32_MCG_STATUS:
>  	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
> @@ -3126,6 +3130,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case MSR_KVM_POLL_CONTROL:
>  		msr_info->data = vcpu->arch.msr_kvm_poll_control;
>  		break;
> +	case MSR_KVM_SEV_LIVE_MIG_EN:
> +		msr_info->data = vcpu->arch.msr_kvm_sev_live_migration_flag;
> +		break;
>  	case MSR_IA32_P5_MC_ADDR:
>  	case MSR_IA32_P5_MC_TYPE:
>  	case MSR_IA32_MCG_CAP:
> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index c9800fa811f6..f6a841494845 100644
> --- a/arch/x86/mm/mem_encrypt.c
> +++ b/arch/x86/mm/mem_encrypt.c
> @@ -502,8 +502,20 @@ void __init mem_encrypt_init(void)
>  	 * With SEV, we need to make a hypercall when page encryption state is
>  	 * changed.
>  	 */
> -	if (sev_active())
> +	if (sev_active()) {
> +		unsigned long nr_pages;
> +
>  		pv_ops.mmu.page_encryption_changed = set_memory_enc_dec_hypercall;
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


Isn't this too late, should we be making hypercall at the same time we
clear the encryption bit ?


>  #endif
>  
>  	pr_info("AMD %s active\n",
