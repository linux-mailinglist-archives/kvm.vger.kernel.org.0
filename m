Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9177367353
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 21:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243461AbhDUTUP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 15:20:15 -0400
Received: from mail-dm6nam11on2078.outbound.protection.outlook.com ([40.107.223.78]:5216
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243066AbhDUTUO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 15:20:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZypAaGWczIltfmQ4Qg9wnG6uhWRx2uPcnOcuO0w9dQ/MHE7n4ScHaNMv67sliWpA1IBIe3XL2u45g3zVlA4nbqPzLy+m+0wIVq+NiJi8gLD39NAsVXLzKvxzINUtq+rwYwwGpEIYNahQ9p3pq+dHPiNnrc6gXjwHvrUydyTkVfowZOOOPscWxTcv89x/hG5GGH4l/pV4qkm8jfez/2a1FdQ/sIeVgNaghMF+MIB5t34XFGOC9Qj6ghbRdnPP3HQxvknvjTa2VD631jNkwuJIhCMftkv4R+1NSW3Rv+sFI336Bxp/sLTLWxlihFFTEUXOXSXrEiH9HBpf8UMjoISLug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=caZhG3/pmpBukfUZnzY91qxusJ9B5F6aSswDGypdi/E=;
 b=IwniwzwgKfgJAlILOch5WvkrAedTNtaoxWSUBHbRlNKXIpfjlRjWQpQ4cN9JHvu8Ipl1Rv2GnP8QPk5UGa8HKjxB88+CSvID5uHOUvqje2/2f6ioWnMqmWQfoo67FQPE/M+RNjsNrsi3WXMLmD40Sor4Ibub2TN8/ZU5uuPVW8pdbwcRk7JT50mrRPMDDSaZ5tf8UOlg2nCTxFoMDb11HOmsldmZcYMnxiQ7E9qyBgIdDDhmwsxYig9smDOwawB67tffiEA5TqIjcLOdB3WdWAxMZKHfOB90v8RRyEmSAT4QgkuZJPrYBlH5G+ri5Fr5uMfGRWYwhnQKK17BJASWpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=caZhG3/pmpBukfUZnzY91qxusJ9B5F6aSswDGypdi/E=;
 b=c2G26AYPzeZPKx4gsmisooRgX6hqDhV/W5PbHGvCynfT1Vm9/p96q3sRlC92uvBNYgneAcHRRLi0kYZDpXkcmBiXT7EJhQHo3/zOxD6id4kA2TZ86dmPciP/09Ridw0iZYBlfJKfmtSPVP0/gJq4YVdqJFCNrh7EC2M/mVjO+eU=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from BYAPR12MB2759.namprd12.prod.outlook.com (2603:10b6:a03:61::32)
 by BY5PR12MB4904.namprd12.prod.outlook.com (2603:10b6:a03:1d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Wed, 21 Apr
 2021 19:19:36 +0000
Received: from BYAPR12MB2759.namprd12.prod.outlook.com
 ([fe80::b0a3:bc2c:80ec:e791]) by BYAPR12MB2759.namprd12.prod.outlook.com
 ([fe80::b0a3:bc2c:80ec:e791%3]) with mapi id 15.20.4042.024; Wed, 21 Apr 2021
 19:19:36 +0000
Date:   Wed, 21 Apr 2021 19:19:32 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Borislav Petkov <bp@alien8.de>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        seanjc@google.com, venu.busireddy@oracle.com,
        brijesh.singh@amd.com, kexec@lists.infradead.org
Subject: Re: [PATCH v13 12/12] x86/kvm: Add guest support for detecting and
 enabling SEV Live Migration feature.
Message-ID: <20210421191932.GB14208@ashkalra_ubuntu_server>
References: <cover.1618498113.git.ashish.kalra@amd.com>
 <ffd67dbc1ae6d3505d844e65928a7248ebaebdcc.1618498113.git.ashish.kalra@amd.com>
 <20210421144402.GB5004@zn.tnic>
 <2d3170ae-470a-089d-bdec-a43f8190cce7@redhat.com>
 <20210421184832.GA14208@ashkalra_ubuntu_server>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421184832.GA14208@ashkalra_ubuntu_server>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN2PR01CA0035.prod.exchangelabs.com (2603:10b6:804:2::45)
 To BYAPR12MB2759.namprd12.prod.outlook.com (2603:10b6:a03:61::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN2PR01CA0035.prod.exchangelabs.com (2603:10b6:804:2::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Wed, 21 Apr 2021 19:19:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57632730-ec21-4892-7ed4-08d904fa66ca
X-MS-TrafficTypeDiagnostic: BY5PR12MB4904:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR12MB49041897C00B02688121A4718E479@BY5PR12MB4904.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XzDJDTYjLBLNELxArsfAFjtB9lQGuLcDGHy4bKbAlb1Joxgtovqn0Dg5WIKclKYIKMJ0/UYy4nrIgDyhifLYSkwZPlaU47X/NqIaTTVLXy5ADxrfGBDhSN/JgW0YTCwWVEsJK1qTTGMe48hvhN7OZoEbG3xo8SuRZ4UTlNq6gzWDx2nkB4V7dQbE0d1cBTPzfw0TuYwP6gxIbwhgolkS8rIhIx9a7kJARx60ultsVOvNElxEzWsKjs2bgHLY/ALm0tFclFUOdN5MoGwDEo3/3uFYoZ+Sd3TNoeU6rNsWKyBTnH9VK8FqRzYZ5ST27mYTaGf3SiFO4RtPKiQZxPJdhmBrnbsVk3z4cdOEcgzfkWhEzDd0Bm6ppB4wRzivFQqi5a6wJy30FtjSJS8d8PeOPCpSEuADE8GUxwi1YarqfdHkS6CWOsOCAFQvQ4v01Ztc4i0yUgwr1eMcdQvEdPyg5qI1Vura2p6jT8PJzQYDgda+4ijIMVtZEHhcxrbCgMDYBlNa+tkGcmq1JQ3wlcgUeIlhvSuhSsHMH2jUr0nhQpkHx5Tavn25dtvD2ADep3ZdN5kYJEPGwzX3uK4VIReUeOZRHnh1e8dIZnn6dgUaMQkYf5Qw+LM6r72UxdqabFKm3t35wtEmbPJu1djhHqSkHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2759.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(39850400004)(346002)(376002)(2906002)(53546011)(6666004)(38350700002)(66556008)(5660300002)(6496006)(4326008)(9686003)(55016002)(52116002)(26005)(83380400001)(956004)(86362001)(478600001)(33716001)(66476007)(8936002)(66946007)(8676002)(33656002)(6916009)(7416002)(44832011)(186003)(316002)(1076003)(16526019)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Jp7VQ5q9jvRGfRwyILpRJHF3StHTg5l2Md6tBE33MR/4yEWIR8w2J+cnWCLT?=
 =?us-ascii?Q?+M5+3YL4KbH8zlW2D+on0pW68BUR1s6OqAU3rwMP7vHADtgR00wvd/k3FkeF?=
 =?us-ascii?Q?5szQj9BlDxhXcIicsGNXw7yOeSWNgaymgyurQ7YjYqLRXAofq7hG25mTJH42?=
 =?us-ascii?Q?t4yGXicQo0JBSAr67i67NQ+2JAfnfURP3DmjTC4PnxewKiQq/QJFNrK+M/Rd?=
 =?us-ascii?Q?ETLt0N6tPUCHJQ82fXFhRziQmWRvv8O6jZBKP+JkEm62hQr4la5pY1/57B+w?=
 =?us-ascii?Q?hvsNHwxdunMPRwyNirkrK00SOF/8k1WTU4v7u56Z9AwvLTQE/hUe0QT4EEgS?=
 =?us-ascii?Q?r+4kOItMLrPw9M3k/90TPabYaHEtwZzRXqf/mYgrE3cNRsRzcSsDI8Zn9zrG?=
 =?us-ascii?Q?gbMyn+RZJfcVkzG/+Sl4B58qYJBxNAlwLb2L7GBCssqpuYAYgxaFllLixedJ?=
 =?us-ascii?Q?D98EQiB2thBaRMJiFrlrOp4ebG9cUV7G+0F1j1QuHySSaEzOrZ/9u9GT4UJO?=
 =?us-ascii?Q?sARTlNI/ReJv39qj4DOLE5WWGdsDi8TsbQeuDcx2yT779vWgZGRY3jOSlAoC?=
 =?us-ascii?Q?ZustgroU/KY5fPMlwXIC3SD2uuVPIq32PLNXh1IbYv2B04mQNXlQjbVhL9oN?=
 =?us-ascii?Q?T6F30xUYT9K4Pt21q8axjibE3XMJ02pj49svpbAykSr4PjJnfr7QFx85/4LV?=
 =?us-ascii?Q?Qshg28P1cdGaEoPI6HO17vN/FHKzdOPkSKtaLH0KV2pUfMAVnDIQNRpqGimW?=
 =?us-ascii?Q?3ESmoEveHMqSDcAETMiLdhgoXHsyArFkLT9s5Cp4VTBpcTtHCtjI6JaZ5rbT?=
 =?us-ascii?Q?ajDaQFIbY1t4uba5Xyaa+Tn+7/kulzTUXSTSxlOLhP7U72ROTHPkOzrMxJE1?=
 =?us-ascii?Q?F9d8/+P4F3AX+BS7abwXa4Nlih8m22NCqTDfOa6zmU3QQh4+JrRlFseXpBmD?=
 =?us-ascii?Q?kau+sTV5+LL1O2HrnDfdOtkySNRXiTl1PYN9xfdVx8w5WW/KZGaPWJMPUotZ?=
 =?us-ascii?Q?Acc5rbrtOIrrBYT1+vVCa6QsyEdq+O+oXqgfA/mEq3+MWFvYciDjI0v0Lt1v?=
 =?us-ascii?Q?fB85Co4DwLW8w1mZo8x2vVDUPVjYVL1/FJRyrSduwcn+jTh/GJdTkVM4GaIg?=
 =?us-ascii?Q?Hfi+9enp+vjsiO281+HPKlBRqgHAA/f+Wqq/Y1VudsDXMaVTligo2wElng3g?=
 =?us-ascii?Q?pST8NxI2pZmeftbi3AuaK9u81D2cWoLgjTIFCEzLPKxxNORYl/ZT4MK307SG?=
 =?us-ascii?Q?6tLy5wsk75s6apS7VP9joBkET1HcvLlZaztjPwVk9u51IC3rPQU/xupe5kyi?=
 =?us-ascii?Q?SlcGYQ4tl5a7e2tI/AUfgOs5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57632730-ec21-4892-7ed4-08d904fa66ca
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2759.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 19:19:36.4276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XaqeyZ8CDTVebmCM8Sp2M8oEGZ2me1VLChDqtAfZZYfLco/htWcK6HuZ3/NjYl9G1KhegnfLzzWKssJvVJ6/Qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4904
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To reiterate, in addition to KVM_FEATURE_HC_PAGE_ENC_STATUS, we also need 
to add the new KVM_FEATURE_SEV_LIVE_MIGRATION feature for guest to check
for host-side support for SEV live migration. 

Or will the guest now check KVM_FEATURE_HC_PAGE_ENC_STATUS in CPUID and
then accordingly set bit0 in MSR_KVM_MIGRATION_CONTROL to enable SEV
live migration ?

Thanks,
Ashish

On Wed, Apr 21, 2021 at 06:48:32PM +0000, Ashish Kalra wrote:
> Hello Paolo,
> 
> The earlier patch#10 of SEV live migration patches which is now part of
> the guest interface patches used to define
> KVM_FEATURE_SEV_LIVE_MIGRATION. 
> 
> So now, will the guest patches need to define this feature ?
> 
> Thanks,
> Ashish
> 
> On Wed, Apr 21, 2021 at 05:38:45PM +0200, Paolo Bonzini wrote:
> > On 21/04/21 16:44, Borislav Petkov wrote:
> > > On Thu, Apr 15, 2021 at 04:01:16PM +0000, Ashish Kalra wrote:
> > > > From: Ashish Kalra <ashish.kalra@amd.com>
> > > > 
> > > > The guest support for detecting and enabling SEV Live migration
> > > > feature uses the following logic :
> > > > 
> > > >   - kvm_init_plaform() invokes check_kvm_sev_migration() which
> > > >     checks if its booted under the EFI
> > > > 
> > > >     - If not EFI,
> > > > 
> > > >       i) check for the KVM_FEATURE_CPUID
> > > 
> > > Where do you do that?
> > > 
> > > $ git grep KVM_FEATURE_CPUID
> > > $
> > > 
> > > Do you mean
> > > 
> > > 	kvm_para_has_feature(KVM_FEATURE_SEV_LIVE_MIGRATION)
> > > 
> > > per chance?
> > 
> > Yep.  Or KVM_CPUID_FEATURES perhaps.
> > 
> > > 
> > > > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > > > index 78bb0fae3982..94ef16d263a7 100644
> > > > --- a/arch/x86/kernel/kvm.c
> > > > +++ b/arch/x86/kernel/kvm.c
> > > > @@ -26,6 +26,7 @@
> > > >   #include <linux/kprobes.h>
> > > >   #include <linux/nmi.h>
> > > >   #include <linux/swait.h>
> > > > +#include <linux/efi.h>
> > > >   #include <asm/timer.h>
> > > >   #include <asm/cpu.h>
> > > >   #include <asm/traps.h>
> > > > @@ -429,6 +430,59 @@ static inline void __set_percpu_decrypted(void *ptr, unsigned long size)
> > > >   	early_set_memory_decrypted((unsigned long) ptr, size);
> > > >   }
> > > > +static int __init setup_kvm_sev_migration(void)
> > > 
> > > kvm_init_sev_migration() or so.
> > > 
> > > ...
> > > 
> > > > @@ -48,6 +50,8 @@ EXPORT_SYMBOL_GPL(sev_enable_key);
> > > >   bool sev_enabled __section(".data");
> > > > +bool sev_live_migration_enabled __section(".data");
> > > 
> > > Pls add a function called something like:
> > > 
> > > bool sev_feature_enabled(enum sev_feature)
> > > 
> > > and gets SEV_FEATURE_LIVE_MIGRATION and then use it instead of adding
> > > yet another boolean which contains whether some aspect of SEV has been
> > > enabled or not.
> > > 
> > > Then add a
> > > 
> > > static enum sev_feature sev_features;
> > > 
> > > in mem_encrypt.c and that function above will query that sev_features
> > > enum for set flags.
> > 
> > Even better: let's stop callings things SEV/SEV_ES.  Long term we want
> > anyway to use things like mem_encrypt_enabled (SEV),
> > guest_instruction_trap_enabled (SEV/ES), etc.
> > 
> > For this one we don't need a bool at all, we can simply check whether the
> > pvop points to paravirt_nop.  Also keep everything but the BSS handling in
> > arch/x86/kernel/kvm.c.  Only the BSS handling should be in
> > arch/x86/mm/mem_encrypt.c.  This way all KVM paravirt hypercalls and MSRs
> > are in kvm.c.
> > 
> > That is:
> > 
> > void kvm_init_platform(void)
> > {
> > 	if (sev_active() &&
> > 	    kvm_para_has_feature(KVM_FEATURE_SEV_LIVE_MIGRATION)) {
> > 		pv_ops.mmu.notify_page_enc_status_changed =
> > 			kvm_sev_hc_page_enc_status;
> > 		/* this takes care of bss_decrypted */
> > 		early_set_page_enc_status();
> > 		if (!efi_enabled(EFI_BOOT))
> > 			wrmsrl(MSR_KVM_SEV_LIVE_MIGRATION,
> > 			       KVM_SEV_LIVE_MIGRATION_ENABLED);
> > 	}
> > 	/* existing kvm_init_platform code goes here */
> > }
> > 
> > // the pvop is changed to take the pfn, so that the vaddr loop
> > // is not KVM specific
> > static inline void notify_page_enc_status_changed(unsigned long pfn,
> > 				int npages, bool enc)
> > {
> > 	PVOP_VCALL3(mmu.page_encryption_changed, pfn, npages, enc);
> > }
> > 
> > static void notify_addr_enc_status_changed(unsigned long addr,
> > 					   int numpages, bool enc)
> > {
> > #ifdef CONFIG_PARAVIRT
> > 	if (pv_ops.mmu.notify_page_enc_status_changed == paravirt_nop)
> > 		return;
> > 
> > 	/* the body of set_memory_enc_dec_hypercall goes here */
> > 	for (; vaddr < vaddr_end; vaddr = vaddr_next) {
> > 		...
> > 		notify_page_enc_status_changed(pfn, psize >> PAGE_SHIFT,
> > 					       enc);
> > 		vaddr_next = (vaddr & pmask) + psize;
> > 	}
> > #endif
> > }
> > 
> > static int __set_memory_enc_dec(unsigned long addr,
> > 				int numpages, bool enc)
> > {
> > 	...
> >  	cpa_flush(&cpa, 0);
> > 	notify_addr_enc_status_changed(addr, numpages, enc);
> >  	return ret;
> > }
> > 
> > 
> > > +static int __init setup_kvm_sev_migration(void)
> > 
> > Please rename this to include efi in the function name.
> > 
> > > 
> > > +		 */
> > > +		if (!efi_enabled(EFI_BOOT))
> > > +			wrmsrl(MSR_KVM_SEV_LIVE_MIGRATION,
> > > +			       KVM_SEV_LIVE_MIGRATION_ENABLED);
> > > +		} else {
> > > +			pr_info("KVM enable live migration feature unsupported\n");
> > > +		}
> > > +}
> > 
> > I think this pr_info is incorrect, because it can still be enabled in the
> > late_initcall.  Just remove it as in the sketch above.
> > 
> > Paolo
> > 
