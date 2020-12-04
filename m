Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92F22CF65E
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 22:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387514AbgLDVnb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 16:43:31 -0500
Received: from mail-bn8nam11on2084.outbound.protection.outlook.com ([40.107.236.84]:17345
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726318AbgLDVnb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 16:43:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aa9+Yq5vNbLeq//H83/Vbd9sps8K3ElenlEEDgnxQQM5vVbm1dm9T5nDVKRxBfs9VL3TvIdfRl3J0TD3sO3rjYMAUI8p4r011LEcdwzfBr2ezCXp24hCpX9GoYZlMmFgrMDFPWyeAOKGxOO+N7CUALiV9t0yx8/9eYqDxi4T2zkPAGZmfNpEexRoeZLdR5mTq+3ODYGlDrHrKXXmT+XgqTHIS25fIZq2fFHAFxbqdri1V/iEy2foRueFXfFvYCb9U4uxvn9y9I9NT695G/2CVDiDqWiCMSDVlDrpLax4LyVt4Zef13EDoX/xoH3N0toQ8s2Hg1etDu80ke5uTjafEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kkYlQGjyieHO60cQ1DGTvJZ9DHumHdwhG1yFQcO9mhs=;
 b=AQAZ3CLSGyfpva6Y/zCGvqw3SW8m4Qhe6Bhiu9rYrQpyELuMkTnmwoijDed3S1VvZ5qAhyGA5UyjelpqHWc09crLn4PPYwP4DCMCTKJ2QEjaEAr/Joz4dhX4LSgR3mZrDeOLbTnqrCqVCWt1RkgNHY5OaVQRfuiLV+p5H5CsEnrjZ90R3v7ZNOYyKXvllRxiACprSm8YccXzftqbpNr67uFxvWiOXryZ7TaYqqkHmEpnIDyXM6Zlk5ULxrxHLFvwyE0kzuxpbdcE24gCiy9joENEfqttfz0uRftglZTzow5w86BmOjYMnv043YvErYmG5BepR1//u/EsXF2SJ51Fuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kkYlQGjyieHO60cQ1DGTvJZ9DHumHdwhG1yFQcO9mhs=;
 b=pkfG+knNwYa4GkYz2PRAKbF8hTly36X0lXTSokt98ndOaCyC92b6q+2gteJQHByGdFY7ixT4W7p5lQOLNDvXwEZm2i8liOGjl9YgMGOdWm/nyKhATiic4dKIUYfnTCAjcJfU6YCsrn438vjhZr8N0Xqxsf2IfceLTQSqx3H0W3Y=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2446.namprd12.prod.outlook.com (2603:10b6:802:26::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.20; Fri, 4 Dec
 2020 21:42:36 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3611.025; Fri, 4 Dec 2020
 21:42:36 +0000
Date:   Fri, 4 Dec 2020 21:42:30 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, Thomas.Lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: Re: [PATCH v8 13/18] KVM: x86: Introduce new
 KVM_FEATURE_SEV_LIVE_MIGRATION feature & Custom MSR.
Message-ID: <20201204214230.GB1424@ashkalra_ubuntu_server>
References: <cover.1588711355.git.ashish.kalra@amd.com>
 <4ff020b446baa06037136ceeb1e66d4eba8ad492.1588711355.git.ashish.kalra@amd.com>
 <07c975ec-9319-dbd8-cbfe-61c70588d597@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07c975ec-9319-dbd8-cbfe-61c70588d597@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH0PR04CA0116.namprd04.prod.outlook.com
 (2603:10b6:610:75::31) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by CH0PR04CA0116.namprd04.prod.outlook.com (2603:10b6:610:75::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21 via Frontend Transport; Fri, 4 Dec 2020 21:42:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d67820cc-3924-40fc-4e94-08d8989d832d
X-MS-TrafficTypeDiagnostic: SN1PR12MB2446:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB244602E7E54E9797E01AF18A8EF10@SN1PR12MB2446.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IovFE824Qnzq0QnIuzcuXGbh0HCuZp4hc6QcARYDk7iHiyUAkbnQiZMhUGhxVt+XkdQ90LFipUihXVt4Sj+bsoREI9GP/950MCgxRW/H7VEPIyrjRRPOJN78kFdaKMMhCr6NfyBOZEeYaP0ZSWmUBghbGRAPpkfw91GHq6dnNDw7pDJ3AkhQyW7jVreOjEzrmQrX+ei0TJrunOfiKR/z7qKgHKiVIv0MMVBeo4vR7PXdvjUhLluuFAng7JNcErvZDQC2Rqit6hvAq2yKxou9ePLAlmKI7RR5WQeb/yuy4jSPQV8zB0C2EIQYj4a9rLgwUx35wF/QuwOs+cUhD5IE/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(396003)(366004)(39860400002)(9686003)(956004)(8676002)(8936002)(55016002)(4326008)(316002)(53546011)(6496006)(33716001)(66946007)(16526019)(7416002)(44832011)(186003)(478600001)(2906002)(86362001)(52116002)(5660300002)(6916009)(1076003)(33656002)(66476007)(66556008)(83380400001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Uxk2kk5q75LWeKIuu4/r3i2xO1qs9zsGcYvTTyfUUjG3fmo5wjqN5i278eGb?=
 =?us-ascii?Q?tzEgS7L9WbHeCFrNaCPq19+E2GVMSFGrJYzB7oT60bOlibTIGtDl+pHR5JuV?=
 =?us-ascii?Q?plvceMmZ08bzj7kceKfPFt45FOZKC21VS2WPcNI60EocoU0QFeCZgv6q4/4N?=
 =?us-ascii?Q?k1+AsXCPSbvLbzLq+UyuDVYnq3tz1RvfAe1dgrXC28sx0NdMqb7l/1Vlquyi?=
 =?us-ascii?Q?BbIF9zEVX4MllMHEhfzc14uvk+/eh9adNZkCPv/II5li+5WW4g1R1xg2jxxh?=
 =?us-ascii?Q?UcLiAABNgAM8jMP3NRpktJjPmgfHumK8y8cYF9c1IYNaHn4CoIe74Kw3cT87?=
 =?us-ascii?Q?DgG9at3Sxl6kJ6vOckQ084DyWwX43bpAfTbSt8zBmF0HLk7JjQEOuPAnu6Hg?=
 =?us-ascii?Q?JD2cHFr332b9t5H70cuNBhrgwArFKOUR1ts0YfO4XBvIkSt5Ysef9v0tvvMu?=
 =?us-ascii?Q?+D5X1WSl000Fqrgyxt2XRI25ssZISlYIZrmex4221rgIPlOl+7Q8RvZH89hW?=
 =?us-ascii?Q?lJgIs0gzPGvdTGylV1WtROQ6AtsXbDGQbbc+rLzCmgBMEKaEeW31B+BMH7ro?=
 =?us-ascii?Q?6uLxCKD4FiH7C/zX8e/6EZROlAqkkmna2+4/UJHsxAt8w5+NK4Ksl2+ELOYE?=
 =?us-ascii?Q?RP04HFohh8/cuT5W+vqVKJRGdtjnPi/qV1kJXt2Io6C2XAeADF/fI6y1f5MJ?=
 =?us-ascii?Q?+oV4JHO0yjXcTPCfig5yKbLRHEJDL3tZwyLXo6UOkaqXKhoEQI1L4Q+mADks?=
 =?us-ascii?Q?eIYhhRASqRljAvs7wmG/i6eihi08tPjgOA/krDRN2mBpMWC75xFURhkOoKN1?=
 =?us-ascii?Q?3jMCoqs1+hvUmhYdp8oh1jCwN5OufvOAC58ZAmr6xW7HMSVYqc2sKXVPZuBi?=
 =?us-ascii?Q?KAmwyn51xjfqF7pU1/roUjuP8g/GRr0v/JIpBAXgDKI1PwGpMcM0kDTaBoRz?=
 =?us-ascii?Q?GeHle08Y4cahlPLN/NsmyYeY4TqlTv/uSdelmKiK3uEjp2P0Fhk/0Wzz05bx?=
 =?us-ascii?Q?+YTS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d67820cc-3924-40fc-4e94-08d8989d832d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 21:42:36.0022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pXJfgORIWwauXyEO9vPKIFJcxBlkAxtPnciTVr7Fvrlx8zbhzL47DA2jxmrlvf4pVNaPb71DA+Te7EdyjEbaQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2446
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Paolo,

On Fri, Dec 04, 2020 at 12:20:46PM +0100, Paolo Bonzini wrote:
> On 05/05/20 23:19, Ashish Kalra wrote:
> > From: Ashish Kalra <ashish.kalra@amd.com>
> > 
> > Add new KVM_FEATURE_SEV_LIVE_MIGRATION feature for guest to check
> > for host-side support for SEV live migration. Also add a new custom
> > MSR_KVM_SEV_LIVE_MIG_EN for guest to enable the SEV live migration
> > feature.
> > 
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > ---
> >   Documentation/virt/kvm/cpuid.rst     |  5 +++++
> >   Documentation/virt/kvm/msr.rst       | 10 ++++++++++
> >   arch/x86/include/uapi/asm/kvm_para.h |  5 +++++
> >   arch/x86/kvm/svm/sev.c               | 14 ++++++++++++++
> >   arch/x86/kvm/svm/svm.c               | 16 ++++++++++++++++
> >   arch/x86/kvm/svm/svm.h               |  2 ++
> >   6 files changed, 52 insertions(+)
> > 
> > diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
> > index 01b081f6e7ea..0514523e00cd 100644
> > --- a/Documentation/virt/kvm/cpuid.rst
> > +++ b/Documentation/virt/kvm/cpuid.rst
> > @@ -86,6 +86,11 @@ KVM_FEATURE_PV_SCHED_YIELD        13          guest checks this feature bit
> >                                                 before using paravirtualized
> >                                                 sched yield.
> > +KVM_FEATURE_SEV_LIVE_MIGRATION    14          guest checks this feature bit before
> > +                                              using the page encryption state
> > +                                              hypercall to notify the page state
> > +                                              change
> > +
> >   KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          host will warn if no guest-side
> >                                                 per-cpu warps are expeced in
> >                                                 kvmclock
> > diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
> > index 33892036672d..7cd7786bbb03 100644
> > --- a/Documentation/virt/kvm/msr.rst
> > +++ b/Documentation/virt/kvm/msr.rst
> > @@ -319,3 +319,13 @@ data:
> >   	KVM guests can request the host not to poll on HLT, for example if
> >   	they are performing polling themselves.
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
> 
> This doesn't say what the feature is or does, and what the extensions are.
> As far as I understand bit 0 is a guest->host communication that it's
> properly handling the encryption bitmap.
> 
Yes, your understanding for bit 0 is correct, the extensions are for any
future extensions related to this live migration support, such as
extensions/support for accelerated migration, etc. 

> I applied patches -13, this one a bit changed as follows.

Yes, i will post a fresh series of this patch-set.

Thanks,
Ashish

> 
> diff --git a/Documentation/virt/kvm/cpuid.rst
> b/Documentation/virt/kvm/cpuid.rst
> index cf62162d4be2..7d82d7da3835 100644
> --- a/Documentation/virt/kvm/cpuid.rst
> +++ b/Documentation/virt/kvm/cpuid.rst
> @@ -96,6 +96,11 @@ KVM_FEATURE_MSI_EXT_DEST_ID        15          guest
> checks this feature bit
>                                                 before using extended
> destination
>                                                 ID bits in MSI address bits
> 11-5.
> 
> +KVM_FEATURE_ENCRYPTED_VM_BIT       16          guest checks this feature
> bit before
> +                                               using the page encryption
> state
> +                                               hypercall and encrypted VM
> +                                               features MSR
> +
>  KVM_FEATURE_CLOCKSOURCE_STABLE_BIT 24          host will warn if no
> guest-side
>                                                 per-cpu warps are expected
> in
>                                                 kvmclock
> diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
> index e37a14c323d2..02528bc760b8 100644
> --- a/Documentation/virt/kvm/msr.rst
> +++ b/Documentation/virt/kvm/msr.rst
> @@ -376,3 +376,13 @@ data:
>  	write '1' to bit 0 of the MSR, this causes the host to re-scan its queue
>  	and check if there are more notifications pending. The MSR is available
>  	if KVM_FEATURE_ASYNC_PF_INT is present in CPUID.
> +
> +MSR_KVM_ENC_VM_FEATURE:
> +        0x4b564d08
> +
> +	Control encrypted VM features.
> +
> +data:
> +        Bit 0 tells the host that the guest is (1) or is not (0) issuing
> the
> +        ``KVM_HC_PAGE_ENC_STATUS`` hypercall to keep the encrypted bitmap
> +       up to date.
> diff --git a/arch/x86/include/uapi/asm/kvm_para.h
> b/arch/x86/include/uapi/asm/kvm_para.h
> index 950afebfba88..3dda6e416a70 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -33,6 +33,7 @@
>  #define KVM_FEATURE_PV_SCHED_YIELD	13
>  #define KVM_FEATURE_ASYNC_PF_INT	14
>  #define KVM_FEATURE_MSI_EXT_DEST_ID	15
> +#define KVM_FEATURE_ENCRYPTED_VM	16
> 
>  #define KVM_HINTS_REALTIME      0
> 
> @@ -54,6 +55,7 @@
>  #define MSR_KVM_POLL_CONTROL	0x4b564d05
>  #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
>  #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
> +#define MSR_KVM_ENC_VM_FEATURE	0x4b564d08
> 
>  struct kvm_steal_time {
>  	__u64 steal;
> @@ -136,4 +138,6 @@ struct kvm_vcpu_pv_apf_data {
>  #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
>  #define KVM_PV_EOI_DISABLED 0x0
> 
> +#define KVM_ENC_VM_BITMAP_VALID			(1 << 0)
> +
>  #endif /* _UAPI_ASM_X86_KVM_PARA_H */
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index fa67f498e838..0673531233da 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1478,6 +1478,17 @@ int svm_page_enc_status_hc(struct kvm *kvm, unsigned
> long gpa,
>  	return 0;
>  }
> 
> +void sev_update_enc_vm_flags(struct kvm *kvm, u64 data)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +
> +	if (!sev_guest(kvm))
> +		return;
> +
> +	if (data & KVM_ENC_VM_BITMAP_VALID)
> +		sev->live_migration_enabled = true;
> +}
> +
>  int svm_get_page_enc_bitmap(struct kvm *kvm,
>  				   struct kvm_page_enc_bitmap *bmap)
>  {
> @@ -1490,6 +1501,9 @@ int svm_get_page_enc_bitmap(struct kvm *kvm,
>  	if (!sev_guest(kvm))
>  		return -ENOTTY;
> 
> +	if (!sev->live_migration_enabled)
> +		return -EINVAL;
> +
>  	gfn_start = bmap->start_gfn;
>  	gfn_end = gfn_start + bmap->num_pages;
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 66f7014eaae2..8ac2c5b9c675 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2766,6 +2766,9 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct
> msr_data *msr)
>  		svm->msr_decfg = data;
>  		break;
>  	}
> +	case MSR_KVM_ENC_VM_FEATURE:
> +		sev_update_enc_vm_flags(vcpu->kvm, data);
> +		break;
>  	case MSR_IA32_APICBASE:
>  		if (kvm_vcpu_apicv_active(vcpu))
>  			avic_update_vapic_bar(to_svm(vcpu), data);
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 287559b8c5b2..363c3f8d00b7 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -66,6 +66,7 @@ struct kvm_sev_info {
>  	int fd;			/* SEV device fd */
>  	unsigned long pages_locked; /* Number of pages locked */
>  	struct list_head regions_list;  /* List of registered regions */
> +	bool live_migration_enabled;
>  	unsigned long *page_enc_bmap;
>  	unsigned long page_enc_bmap_size;
>  };
> @@ -504,5 +505,6 @@ int svm_page_enc_status_hc(struct kvm *kvm, unsigned
> long gpa,
>  				  unsigned long npages, unsigned long enc);
>  int svm_get_page_enc_bitmap(struct kvm *kvm, struct kvm_page_enc_bitmap
> *bmap);
>  int svm_set_page_enc_bitmap(struct kvm *kvm, struct kvm_page_enc_bitmap
> *bmap);
> +void sev_update_enc_vm_flags(struct kvm *kvm, u64 data);
> 
>  #endif
> 
> Paolo
> 
