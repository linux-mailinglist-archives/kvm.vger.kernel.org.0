Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89142366F05
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 17:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243371AbhDUPW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 11:22:59 -0400
Received: from mail-dm6nam12on2049.outbound.protection.outlook.com ([40.107.243.49]:2561
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238829AbhDUPW6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 11:22:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PSfKxLStxrhAOUxVcxNr4chaqYbZx36k3f3gDPmkNMDlRAsz/zJc6iumehlQf3oXFlqXzY3fMpr+YPcmbq/GQPpww0tv2eSzwJNMkTUHljqWCYNBdnCm2LLRAfg1SXYYYjKRhffwblNUDYcwfLkOHlPH5ggSlhL1WnImloiTrXet4A1jKNBuq1R7GeXamW2w4uhFJ8TGmET9wDxr9epDCD7vi7pZ5nrFWCvLlEe8fKWbTZPcmn1IJUDllwsCsxq+gA8N7htXxUdcCodP3Jn3L1OUNL5rztq7pKh2dU+hNS5AAtNT1BKjeP4l9RAix8ha/tS2U1h12HyYwxT/6L5CxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dl5516Sxl0mDKCocVcvN/lCo2MRl6KtZOqjbyljpcWk=;
 b=Bz2cID+BnoESgGnQmyTFcm0LzDiiDjsSvTbN4wVGRO8zlcI51t6DoaKeJNfSOcCyNeuLof2NYTBNDgP3jTjPAMO+yfm0v6z9HiMHQP2y6K7pC5TGLfkwrLtTy04txE2Rb586kfjt8uejHfngHf9uHTHhM3gul23rgWfIOt6CCZubLh2pnZRhs+ypiU6+i4v5E2E0EI1KFULXOr6UB5FV3PB32mrPAb6pnY5yI1RFXv3L5KphYzeI8xRFAUp5kK+2XsmVJPRFEZ6gSKVd13hLtXq64t565halCPUo1voCvrpapVtMn25Eko2k1UCQ5WNbM9duj6JrUgDvJNKL5i/xZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dl5516Sxl0mDKCocVcvN/lCo2MRl6KtZOqjbyljpcWk=;
 b=PHfetjrGd2Uq+gBV1j6qZF5IcSuP6KRc3y7jz5MZ3q/YiCji2SOYAScuPqnppgjiNlg58J1hR4KX7KaGkVSI1cEWek//m/GkDGydL4pwsv+gawZVkYaC9Ltb7gOAAqFPDfYOUtcGX9fS+O6oSZbEiahseu/zwwXyIL/FCu0k0i0=
Authentication-Results: alien8.de; dkim=none (message not signed)
 header.d=none;alien8.de; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Wed, 21 Apr
 2021 15:22:23 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%7]) with mapi id 15.20.4065.021; Wed, 21 Apr 2021
 15:22:23 +0000
Date:   Wed, 21 Apr 2021 15:22:20 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        seanjc@google.com, venu.busireddy@oracle.com,
        brijesh.singh@amd.com, kexec@lists.infradead.org
Subject: Re: [PATCH v13 12/12] x86/kvm: Add guest support for detecting and
 enabling SEV Live Migration feature.
Message-ID: <20210421152220.GB14004@ashkalra_ubuntu_server>
References: <cover.1618498113.git.ashish.kalra@amd.com>
 <ffd67dbc1ae6d3505d844e65928a7248ebaebdcc.1618498113.git.ashish.kalra@amd.com>
 <20210421144402.GB5004@zn.tnic>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421144402.GB5004@zn.tnic>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN2PR01CA0062.prod.exchangelabs.com (2603:10b6:800::30) To
 SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN2PR01CA0062.prod.exchangelabs.com (2603:10b6:800::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend Transport; Wed, 21 Apr 2021 15:22:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f39cda9d-93c1-4dae-8919-08d904d94353
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4557C2541B6A4E50335B01AB8E479@SA0PR12MB4557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 00JDSFF8aExunpClxeQAhueQAuN9z+ALVn8CkU7e2bjwRVex4tOHS0EZWupzRbWOj9Zfn8BnwWy214U8nNXteMAZljzdD1iBbrHb/cDvbCxJRpOin9UdGObv2tTYrtt6LR/nsSPr6y8HmiamS1LrRCki46h8/MWO0Z8hlETpu58QRQGjUjpRQ+yNM/n+RL8/TSrwR1sjBRLxzKxlLElQNU9Mf/cPY4Cc74cJg/DOQw4ybO2rYrriYNxFUi6hVBi4VExIZbjN6rx2wyXB3N1g2uWm2ld38Nhh4+Xc1Zk0d0Eypx/w2WEJHcaIvZrd4y9kOyAsVw5qGrMnMI3bFg+dVJWpGX9KzxYC3cTY8U+2NAlEoqxHEHB3OwWiEhBAmKfMsCDvrDVTNXheBHYzfHLrnZb34XR0Jy2OucvMtR41bgoTHE7stYWuDZr0ZBtzgFIh5X0jj0nQ3hXSs69e4taZ0GpM8oCSeQ03khLk8pXLwG3phUDKWk9nBqS2Bopsnzig8OG9ljuxkcj3VRo6+Cq3wDrwNJl1wXbyQoq9SWcOaSy4mRQn7DLryU4g0IMjAFJTpe9lPyXamnm9BUk1u+4xlaM0/ly4X2DL+IvoGF2gqvkrQDNMnpwzpAXWISSpAUWdsjDuUUL2gefB9dDQrJLoV3P5Q4Fvee1Yx67LGzvPwL4GSRpBjFt7I7aC92h1m6K455eIdNd6LiqMzSZOL20gZqHlF/l5QovCGidt3v3gQEc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(346002)(376002)(39850400004)(6496006)(8936002)(52116002)(44832011)(966005)(5660300002)(45080400002)(38100700002)(33656002)(1076003)(9686003)(8676002)(83380400001)(186003)(66476007)(4326008)(6916009)(38350700002)(478600001)(956004)(66556008)(7416002)(2906002)(316002)(26005)(66946007)(55016002)(86362001)(16526019)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?kJWWFqG/BKGIZ5Lql/kC0mSX3O4KQ9dLHszSM5IhKzZ4z016t2ia1hxM0SA2?=
 =?us-ascii?Q?nnmkl1CY0AIlhWshGtVF828yBEle2zZuUb/cwhY/F9Pj0sYG4fg/iQkWt/xT?=
 =?us-ascii?Q?FVfwNpx9+wk+Y7LI7ztQzBM+zxivcY1Ii4ZgOC4LK49KZ9AZlDDwfaWUBfBb?=
 =?us-ascii?Q?nmsfelGe0eVJl034SV7vqC2fbn4YzABtTpEWd9s7BYZEVPx/MXLo1SPvNMuc?=
 =?us-ascii?Q?WQa434nupd997pB/uURqQ7H16xclNcGchB3AZf+RUqiJ66EedDPGCd5ULW0q?=
 =?us-ascii?Q?VfYjOgnLpCbb8iB6Rrx3+XPto4sLHnUyDRQk7GL6B4w6/sBwQUNgG207l01c?=
 =?us-ascii?Q?hZGQDysFvZVyt8CrB+xWzlWgrmGoD+q+fV0kZBJooFdXlKYHHFzMaOlVpEW8?=
 =?us-ascii?Q?M2dOir3HwWEj3YlF8lzV4JPESfeIou41m6BbdkYRWmAEbWmxnSNpT3/vfG18?=
 =?us-ascii?Q?hulQkw9PGdimyTLd/pJJI6pcDFoke0UFSXvodb2g4Ym8YqWkavfHRT+rVER2?=
 =?us-ascii?Q?B8EX8egd0/2ldhx/SFsD0R/GB7CZs0RE7U4E3FaxxCwRKbIw6LurFm8Gy4nP?=
 =?us-ascii?Q?UUC9wZNaj2R8YsVL+Oc8NB7nR/xLJc57YTKPAoWrNj2L+jv7ybsYLYFAhO6t?=
 =?us-ascii?Q?xO2C7WsCjS35x/RuTx3XDQHD04+8u8+130wPoyQdPx/uVuT5K8rKJL1rUdpi?=
 =?us-ascii?Q?PLfHJykhinP4ewn6GS4PqwJ9v1HzAUqpJ5XRrX0FgRiT3ExP3jPe0lSD7zF7?=
 =?us-ascii?Q?T+OSJ9BAmVe8h2Heu2aQ+7aLgAuJ4724u32P6belGwqWWpl/U5yiYChQrj3r?=
 =?us-ascii?Q?IBA+pgipwEhCNejOPM0kOiVvnr76LTQOvkVlRrP0fjnCRadM5ABgs4dbcyjI?=
 =?us-ascii?Q?IvEmsv44NRANAqrAObcy9zIhXrcSIaVKgV0eM36TFGlQTgS0lFbFp7lJtOcf?=
 =?us-ascii?Q?q+wVCvBdPuxbvvhKZoGdZGmn2F8t9MO+8ZKt0aidpCyQH5yvkAYkN3DHNYDn?=
 =?us-ascii?Q?iZDz+jO3dKfgi3ZIr1wWh1gqtA6/K7V2h4Mdh8YUvMvefboI034/ZCd1zoUf?=
 =?us-ascii?Q?Lki99weDLpkUtwNm6TUnH3qBn5H5UYpYUuWOtNn9FoqX+Cde7+0VZK6zhdRm?=
 =?us-ascii?Q?3w6g9uL7mC1GyKWIxP3JaVFqPsGagB+If6KuDK4bplCD1rcXM21aB6n88WDm?=
 =?us-ascii?Q?1uv9+QHyogYkEmImAzwnBbS+Tu1ecpExk2Ih3LzokDJdMglOJV723z0MbqwE?=
 =?us-ascii?Q?NNYhcWM0EuucWd4MWQLCrqqj5QOd7iWFDTBF26IH5eJzzaxl5naHM7nKgdff?=
 =?us-ascii?Q?2uzUr0lbPDBm2aAZ7jUFnTpe?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f39cda9d-93c1-4dae-8919-08d904d94353
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 15:22:23.5916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3QlVHthwd5rapE3nTDdjra76LocLRmdZqxDYNdbbqct3Ipi0K/v/X4gEtXmaeqtC+Cv4j7MWAi7IXqk+DLRZpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 21, 2021 at 04:44:02PM +0200, Borislav Petkov wrote:
> On Thu, Apr 15, 2021 at 04:01:16PM +0000, Ashish Kalra wrote:
> > From: Ashish Kalra <ashish.kalra@amd.com>
> > 
> > The guest support for detecting and enabling SEV Live migration
> > feature uses the following logic :
> > 
> >  - kvm_init_plaform() invokes check_kvm_sev_migration() which
> >    checks if its booted under the EFI
> > 
> >    - If not EFI,
> > 
> >      i) check for the KVM_FEATURE_CPUID
> 
> Where do you do that?
> 
> $ git grep KVM_FEATURE_CPUID
> $
> 
> Do you mean
> 
> 	kvm_para_has_feature(KVM_FEATURE_SEV_LIVE_MIGRATION)
> 
> per chance?
> 

Yes, the above mentions to get KVM_FEATURE_CPUID and then check if live
migration feature is supported, i.e.,
kvm_para_has_feature(KVM_FEATURE_SEV_LIVE_MIGRATION). The above comments
are written more generically.

> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > index 78bb0fae3982..94ef16d263a7 100644
> > --- a/arch/x86/kernel/kvm.c
> > +++ b/arch/x86/kernel/kvm.c
> > @@ -26,6 +26,7 @@
> >  #include <linux/kprobes.h>
> >  #include <linux/nmi.h>
> >  #include <linux/swait.h>
> > +#include <linux/efi.h>
> >  #include <asm/timer.h>
> >  #include <asm/cpu.h>
> >  #include <asm/traps.h>
> > @@ -429,6 +430,59 @@ static inline void __set_percpu_decrypted(void *ptr, unsigned long size)
> >  	early_set_memory_decrypted((unsigned long) ptr, size);
> >  }
> >  
> > +static int __init setup_kvm_sev_migration(void)
> 
> kvm_init_sev_migration() or so.
> 
> ...
> 
> > @@ -48,6 +50,8 @@ EXPORT_SYMBOL_GPL(sev_enable_key);
> >  
> >  bool sev_enabled __section(".data");
> >  
> > +bool sev_live_migration_enabled __section(".data");
> 
> Pls add a function called something like:
> 
> bool sev_feature_enabled(enum sev_feature)
> 
> and gets SEV_FEATURE_LIVE_MIGRATION and then use it instead of adding
> yet another boolean which contains whether some aspect of SEV has been
> enabled or not.
> 
> Then add a
> 
> static enum sev_feature sev_features;
> 
> in mem_encrypt.c and that function above will query that sev_features
> enum for set flags.
> 
> Then, if you feel bored, you could convert sme_active, sev_active,
> sev_es_active, mem_encrypt_active and whetever else code needs to query
> any aspect of SEV being enabled or not, to that function.
> 

Ok.

> > +void __init check_kvm_sev_migration(void)
> > +{
> > +	if (sev_active() &&
> > +	    kvm_para_has_feature(KVM_FEATURE_SEV_LIVE_MIGRATION)) {
> 
> Save an indentation level:
> 
> 	if (!sev_active() ||
> 	    !kvm_para_has_feature(KVM_FEATURE_SEV_LIVE_MIGRATION))
> 		return;
> 
> > +		unsigned long nr_pages;
> > +		int i;
> > +
> > +		pr_info("KVM enable live migration\n");
> 
> That should be at the end of the function and say:
> 
> 		pr_info("KVM live migration enabled.\n");
> 
> > +		WRITE_ONCE(sev_live_migration_enabled, true);
> 
> Why WRITE_ONCE?
> 

Just to ensure that the sev_live_migration_enabled is set to TRUE before
it is used immediately next in the function.

Thanks,
Ashish

> And that needs to go to the end of the function too.
> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fpeople.kernel.org%2Ftglx%2Fnotes-about-netiquette&amp;data=04%7C01%7CAshish.Kalra%40amd.com%7Cfe47697d718c4326b62108d904d3e9ad%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637546130496140162%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=d%2F%2Bx8t8R7zJclA7ENc%2Fxwt5%2FU13m%2FWObem2Hq8yH190%3D&amp;reserved=0
