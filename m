Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB6CE19817C
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 18:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgC3Qmu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 12:42:50 -0400
Received: from mail-dm6nam11on2081.outbound.protection.outlook.com ([40.107.223.81]:7449
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726497AbgC3Qmu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 12:42:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sr3jWT3xZyCz0+R3QgiK9Q1C38fVSvD01Ayo51AmT2ioou074hklrexPQZONbJfo8GGAfQ2+WOeODy9TQScGar5lEtAZxxIBo7EvUMWmoexOEpyz1ZT4CHa/82pIdS4x8QWMfe/+FBNAvO2pd8M7n+Y+ZPXbc5dl4iXbNYpMKoURWHY4Ktq8u2ZiRkX3lg9cgbNuOaVmiMOn/Ees7mz0xiEu1QUf0e5/yat1rD3bbn5WsM6yumxtRVdRxUZDrRNWlPGSZQTB/V1paa5QlNfRwwP/w/gg/wcTuh9VDCl7Bu8h504trUa6bkhdmsI8VS5JjeFpBm9LiMCzD+p1CbkonA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z6zA2DNl130FDEzyfLH7NulmjjwfKpgbnQXWIn8+EmM=;
 b=MZyhq1DtS+EHxnb0mCxX6hRp4YN/EdNlc2FDAOYvN9uRdJmRz3XY0ZQ4qw5G0aI42jEfPSdWIKSyKlZCx3RO748woKGYHwOJNUsyA1kpRWs8UEHG0Slnf2Cnqal2cpMhhWWKTSf/bynX2E0siasvkM3ckr5pYx0vap+K20v2Kuxu8N5HwxBMcuOhKyoFLkiUezRNKQ6EziS1TYYoTo7k1hi/ZQBkVrW/9mS6WfvjJqzkpaOasQMdYkSHxCb0cvipNxyBWjFLXjWy1sISQKBMm0NpTI2sBMtJeic/3CW5CcD6AO5q/y1PMXxnNIEvuGy5MIRNl6mBO5wXchEPq5OKQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z6zA2DNl130FDEzyfLH7NulmjjwfKpgbnQXWIn8+EmM=;
 b=tlKt81nIHW3TTCJc1BPQgMByeYe+UaChIqmauMG5g6xrKHAhhzrWLhBuh7Jodf7ODug0GudbA9vtpimHynxb6pt25NV27UFuPGeWsYKC4WZmbACV8F6eR9Bo8rryukPFTV+F1YJeza8My48c7BYqkNRYY4Uzxu58pMy+Kg2ib+8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB2501.namprd12.prod.outlook.com (2603:10b6:4:b4::34) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Mon, 30 Mar 2020 16:42:45 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 16:42:45 +0000
Date:   Mon, 30 Mar 2020 16:42:37 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        srutherford@google.com, luto@kernel.org
Subject: Re: [PATCH v6 13/14] KVM: x86: Introduce new
 KVM_FEATURE_SEV_LIVE_MIGRATION feature & Custom MSR.
Message-ID: <20200330164237.GA21601@ashkalra_ubuntu_server>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <21b2119906f4cce10b4133107ece3dab0957c07c.1585548051.git.ashish.kalra@amd.com>
 <9ab53cb5-5cfd-ee63-74ae-0a3188adffcc@amd.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9ab53cb5-5cfd-ee63-74ae-0a3188adffcc@amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: DM6PR02CA0109.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::11) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by DM6PR02CA0109.namprd02.prod.outlook.com (2603:10b6:5:1b4::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Mon, 30 Mar 2020 16:42:43 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fab840f9-822d-4062-ac7e-08d7d4c95f26
X-MS-TrafficTypeDiagnostic: DM5PR12MB2501:|DM5PR12MB2501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB25013E4BFA42F25320D124028ECB0@DM5PR12MB2501.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(136003)(376002)(366004)(346002)(39860400002)(6636002)(7416002)(33716001)(478600001)(6666004)(81166006)(81156014)(26005)(8676002)(86362001)(16526019)(8936002)(186003)(1076003)(44832011)(956004)(6496006)(53546011)(2906002)(316002)(66946007)(55016002)(66476007)(9686003)(66556008)(4326008)(5660300002)(52116002)(6862004)(33656002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vKr8w0zQ5obPGL79pD9PbrQ6SR5V5XxoPCXksdNepYcC87yx4rU6hkSux8HakFDtkS6RyJMin/j89hIc8IYNJfuFKIgpvnS2BwuxaVNZLgUEb6x3j01Rnz+fDNM3Ifnv+AY0LpvWw0CgODIa3SdxXpP/qNpXZ252aeFOojNvi5jQ00zxJAvmr8+pjfON8G8HnyPpoCLFRH4yFq5/w0Hly88weLjwQojatjSaiKdRrz1QyEV9HsjTePj6NPbnV3g28rfuzlhXaIwnG3i/c2JvSn04vqM1Esp/AyUTufpir4nd1LwOO7/lcrQy0ErdjutQX3eMOQ5LwYQXhejOD56UQu+Kp9VhEQWnOtbLS6FdDHbW6Qu/HZJJyCSSI17CLR9yo84ysenies1GH9oqcizKR4qPX7hQjgrBO1j+5vjXy46fkdK8Pa99RrTqO/aqvlWz
X-MS-Exchange-AntiSpam-MessageData: 7RBrhruRP5qQNetY8tcPopYgWBm4AJVbJIAIiPuGk68ScupcZoAPVtXB1FBrpLm0fKMkv09Q7FqZygHZVCLH/Jz3lxxNrbBkhcN7nM6QNw9wIJWvXhzTV1OwHCW3XsmPKDGSFt/Vohj9CECqpq1VDA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fab840f9-822d-4062-ac7e-08d7d4c95f26
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 16:42:44.9248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sW9JBN+cSyFwHnBq2d8tEfvMLEs6UzXYgw/WwtPqwPH400b4I46Wo85Nh5d4CSA9TpwZozQr6GYchktJXBpS4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2501
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Brijesh,

On Mon, Mar 30, 2020 at 10:52:16AM -0500, Brijesh Singh wrote:
> 
> On 3/30/20 1:23 AM, Ashish Kalra wrote:
> > From: Ashish Kalra <ashish.kalra@amd.com>
> >
> > Add new KVM_FEATURE_SEV_LIVE_MIGRATION feature for guest to check
> > for host-side support for SEV live migration. Also add a new custom
> > MSR_KVM_SEV_LIVE_MIG_EN for guest to enable the SEV live migration
> > feature.
> >
> > Also, ensure that _bss_decrypted section is marked as decrypted in the
> > page encryption bitmap.
> >
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > ---
> >  Documentation/virt/kvm/cpuid.rst     |  4 ++++
> >  Documentation/virt/kvm/msr.rst       | 10 ++++++++++
> >  arch/x86/include/asm/kvm_host.h      |  3 +++
> >  arch/x86/include/uapi/asm/kvm_para.h |  5 +++++
> >  arch/x86/kernel/kvm.c                |  4 ++++
> >  arch/x86/kvm/cpuid.c                 |  3 ++-
> >  arch/x86/kvm/svm.c                   |  5 +++++
> >  arch/x86/kvm/x86.c                   |  7 +++++++
> >  arch/x86/mm/mem_encrypt.c            | 14 +++++++++++++-
> >  9 files changed, 53 insertions(+), 2 deletions(-)
> 
> 
> IMHO, this patch should be broken into multiple patches as it touches
> guest, and hypervisor at the same time. The first patch can introduce
> the feature flag in the kvm, second patch can make the changes specific
> to svm,  and third patch can focus on how to make use of that feature
> inside the guest. Additionally invoking the HC to clear the
> __bss_decrypted section should be either squash in Patch 10/14 or be a
> separate patch itself.
> 
> 

Ok.

I will also move the __bss_decrypted section HC to a separate patch.

> > diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
> > index 01b081f6e7ea..fcb191bb3016 100644
> > --- a/Documentation/virt/kvm/cpuid.rst
> > +++ b/Documentation/virt/kvm/cpuid.rst
> > @@ -86,6 +86,10 @@ KVM_FEATURE_PV_SCHED_YIELD        13          guest checks this feature bit
> >                                                before using paravirtualized
> >                                                sched yield.
> >  
> > +KVM_FEATURE_SEV_LIVE_MIGRATION    14          guest checks this feature bit
> > +                                              before enabling SEV live
> > +                                              migration feature.
> > +
> >  KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          host will warn if no guest-side
> >                                                per-cpu warps are expeced in
> >                                                kvmclock
> > diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
> > index 33892036672d..7cd7786bbb03 100644
> > --- a/Documentation/virt/kvm/msr.rst
> > +++ b/Documentation/virt/kvm/msr.rst
> > @@ -319,3 +319,13 @@ data:
> >  
> >  	KVM guests can request the host not to poll on HLT, for example if
> >  	they are performing polling themselves.
> > +
> > +MSR_KVM_SEV_LIVE_MIG_EN:
> > +        0x4b564d06
> > +
> > +	Control SEV Live Migration features.
> > +
> > +data:
> > +        Bit 0 enables (1) or disables (0) host-side SEV Live Migration feature.
> > +        Bit 1 enables (1) or disables (0) support for SEV Live Migration extensions.
> > +        All other bits are reserved.
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index a96ef6338cd2..ad5faaed43c0 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -780,6 +780,9 @@ struct kvm_vcpu_arch {
> >  
> >  	u64 msr_kvm_poll_control;
> >  
> > +	/* SEV Live Migration MSR (AMD only) */
> > +	u64 msr_kvm_sev_live_migration_flag;
> > +
> >  	/*
> >  	 * Indicates the guest is trying to write a gfn that contains one or
> >  	 * more of the PTEs used to translate the write itself, i.e. the access
> > diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> > index 2a8e0b6b9805..d9d4953b42ad 100644
> > --- a/arch/x86/include/uapi/asm/kvm_para.h
> > +++ b/arch/x86/include/uapi/asm/kvm_para.h
> > @@ -31,6 +31,7 @@
> >  #define KVM_FEATURE_PV_SEND_IPI	11
> >  #define KVM_FEATURE_POLL_CONTROL	12
> >  #define KVM_FEATURE_PV_SCHED_YIELD	13
> > +#define KVM_FEATURE_SEV_LIVE_MIGRATION	14
> >  
> >  #define KVM_HINTS_REALTIME      0
> >  
> > @@ -50,6 +51,7 @@
> >  #define MSR_KVM_STEAL_TIME  0x4b564d03
> >  #define MSR_KVM_PV_EOI_EN      0x4b564d04
> >  #define MSR_KVM_POLL_CONTROL	0x4b564d05
> > +#define MSR_KVM_SEV_LIVE_MIG_EN	0x4b564d06
> >  
> >  struct kvm_steal_time {
> >  	__u64 steal;
> > @@ -122,4 +124,7 @@ struct kvm_vcpu_pv_apf_data {
> >  #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
> >  #define KVM_PV_EOI_DISABLED 0x0
> >  
> > +#define KVM_SEV_LIVE_MIGRATION_ENABLED			(1 << 0)
> > +#define KVM_SEV_LIVE_MIGRATION_EXTENSIONS_SUPPORTED	(1 << 1)
> > +
> >  #endif /* _UAPI_ASM_X86_KVM_PARA_H */
> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > index 6efe0410fb72..8fcee0b45231 100644
> > --- a/arch/x86/kernel/kvm.c
> > +++ b/arch/x86/kernel/kvm.c
> > @@ -418,6 +418,10 @@ static void __init sev_map_percpu_data(void)
> >  	if (!sev_active())
> >  		return;
> >  
> > +	if (kvm_para_has_feature(KVM_FEATURE_SEV_LIVE_MIGRATION)) {
> > +		wrmsrl(MSR_KVM_SEV_LIVE_MIG_EN, KVM_SEV_LIVE_MIGRATION_ENABLED);
> > +	}
> > +
> >  	for_each_possible_cpu(cpu) {
> >  		__set_percpu_decrypted(&per_cpu(apf_reason, cpu), sizeof(apf_reason));
> >  		__set_percpu_decrypted(&per_cpu(steal_time, cpu), sizeof(steal_time));
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index b1c469446b07..74c8b2a7270c 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -716,7 +716,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
> >  			     (1 << KVM_FEATURE_ASYNC_PF_VMEXIT) |
> >  			     (1 << KVM_FEATURE_PV_SEND_IPI) |
> >  			     (1 << KVM_FEATURE_POLL_CONTROL) |
> > -			     (1 << KVM_FEATURE_PV_SCHED_YIELD);
> > +			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
> > +			     (1 << KVM_FEATURE_SEV_LIVE_MIGRATION);
> 
> 
> Do we want to enable this feature unconditionally ? Who will clear the
> feature flags for the non-SEV guest ?
>

The guest only enables/activates this feature if sev is active.

> >  
> >  		if (sched_info_on())
> >  			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
> > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > index c99b0207a443..60ddc242a133 100644
> > --- a/arch/x86/kvm/svm.c
> > +++ b/arch/x86/kvm/svm.c
> > @@ -7632,6 +7632,7 @@ static int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
> >  				  unsigned long npages, unsigned long enc)
> >  {
> >  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > +	struct kvm_vcpu *vcpu = kvm->vcpus[0];
> >  	kvm_pfn_t pfn_start, pfn_end;
> >  	gfn_t gfn_start, gfn_end;
> >  	int ret;
> > @@ -7639,6 +7640,10 @@ static int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
> >  	if (!sev_guest(kvm))
> >  		return -EINVAL;
> >  
> > +	if (!(vcpu->arch.msr_kvm_sev_live_migration_flag &
> > +		KVM_SEV_LIVE_MIGRATION_ENABLED))
> > +		return -ENOTTY;
> > +
> >  	if (!npages)
> >  		return 0;
> >  
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 2127ed937f53..82867b8798f8 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -2880,6 +2880,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  		vcpu->arch.msr_kvm_poll_control = data;
> >  		break;
> >  
> > +	case MSR_KVM_SEV_LIVE_MIG_EN:
> > +		vcpu->arch.msr_kvm_sev_live_migration_flag = data;
> > +		break;
> > +
> >  	case MSR_IA32_MCG_CTL:
> >  	case MSR_IA32_MCG_STATUS:
> >  	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
> > @@ -3126,6 +3130,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  	case MSR_KVM_POLL_CONTROL:
> >  		msr_info->data = vcpu->arch.msr_kvm_poll_control;
> >  		break;
> > +	case MSR_KVM_SEV_LIVE_MIG_EN:
> > +		msr_info->data = vcpu->arch.msr_kvm_sev_live_migration_flag;
> > +		break;
> >  	case MSR_IA32_P5_MC_ADDR:
> >  	case MSR_IA32_P5_MC_TYPE:
> >  	case MSR_IA32_MCG_CAP:
> > diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> > index c9800fa811f6..f6a841494845 100644
> > --- a/arch/x86/mm/mem_encrypt.c
> > +++ b/arch/x86/mm/mem_encrypt.c
> > @@ -502,8 +502,20 @@ void __init mem_encrypt_init(void)
> >  	 * With SEV, we need to make a hypercall when page encryption state is
> >  	 * changed.
> >  	 */
> > -	if (sev_active())
> > +	if (sev_active()) {
> > +		unsigned long nr_pages;
> > +
> >  		pv_ops.mmu.page_encryption_changed = set_memory_enc_dec_hypercall;
> > +
> > +		/*
> > +		 * Ensure that _bss_decrypted section is marked as decrypted in the
> > +		 * page encryption bitmap.
> > +		 */
> > +		nr_pages = DIV_ROUND_UP(__end_bss_decrypted - __start_bss_decrypted,
> > +			PAGE_SIZE);
> > +		set_memory_enc_dec_hypercall((unsigned long)__start_bss_decrypted,
> > +			nr_pages, 0);
> > +	}
> 
> 
> Isn't this too late, should we be making hypercall at the same time we
> clear the encryption bit ?
> 
>

Actually this is being done somewhat lazily, after the guest enables/activates the live migration feature, it should be fine to do it
here or it can be moved into sev_map_percpu_data() where the first hypercalls are done, in both cases the __bss_decrypted section will
be marked before the live migration process is initiated.

> >  #endif
> >  
> >  	pr_info("AMD %s active\n",

Thanks,
Ashish
