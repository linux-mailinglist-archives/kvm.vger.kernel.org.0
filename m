Return-Path: <kvm+bounces-5410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 29A13820C09
	for <lists+kvm@lfdr.de>; Sun, 31 Dec 2023 17:45:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A152A1F21841
	for <lists+kvm@lfdr.de>; Sun, 31 Dec 2023 16:45:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDB478F7A;
	Sun, 31 Dec 2023 16:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wm6tNN7l"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CC18F48;
	Sun, 31 Dec 2023 16:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XIr42lHTIvFEHDULdKSmTHvRTYab5cuvlG9AItrcTgwXVyc9rW03yaPeQyADpF9RniaqhfFMTftY9XEtPQksVOezCw2Vh5/PZDNGw+ec8xhKbbZANBK/M4Nx/oJM5fCWA+mnxPDH8HXb60dUmLerEnng+uKvdVgTKJSEc8BaCUSc5cWIqyBqBYpBfmzyenFhcZQyO+fe7jiWz1ERRNfl58OemvjmVkWlQjOcGNIYz0sYO/WvA29jPvz19emywpOKsvkqLzkLvTfZPyi9E/YPpKp7PyxsgJ0yHDkPjbbU4ckMFc1TZ/p6Q2whfBP2REbzvxUJ7ASVpG0+e1McjipDjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nTzLcDtllNFqZ6s9ehy9kf7kXTafi3HDtuvCwvyUd9c=;
 b=OUtUKWEkmMgEdDZb9cF+CGI9KVRhf7QrH0o6kC0Cq6qrFmM/PZAxxKBppBG5c016k30jK+zG7H/lJCbrccA9Bstz53sEFsFqZiCCJKY0orrWarr9k3LMZuH9P6G0UHLXJuZfFSf3HCAIARB5fq06HwUt7SFYdVQhjWRWGauiRxxMNKhTOpjjZ2LRvWgCxG7sYjl6fajc06qM+pAZNeldquQ5SFkk5HnZTUjxcHUz/e+jBztg+UqfoEPrGYXYkPqoH5o4G7l3bSeNooIepn1HukIBQEmb/ApCa7vYVsqV0dTWsNMuUGCvJbN+7s4Aa5yU5infwCrHH4YQZzJoS+Jwbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nTzLcDtllNFqZ6s9ehy9kf7kXTafi3HDtuvCwvyUd9c=;
 b=wm6tNN7lwQiihqqZMhDfn2BBOzyRcWO/6gigHskCQqwSWrd04Rm+oJmVDzlqb3F1GPAN4KnesY7kFj59PG7RFd7ATrjMk6lJq0NmkRdwM3aODufoGMMCIBLxXatRjDNu401UJwS68zVJIOEYDfHY9iXNOyf3EXR5RbbgEHT6uvw=
Received: from DM6PR11CA0045.namprd11.prod.outlook.com (2603:10b6:5:14c::22)
 by LV8PR12MB9154.namprd12.prod.outlook.com (2603:10b6:408:190::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.20; Sun, 31 Dec
 2023 16:44:57 +0000
Received: from DS1PEPF00017092.namprd03.prod.outlook.com
 (2603:10b6:5:14c:cafe::1a) by DM6PR11CA0045.outlook.office365.com
 (2603:10b6:5:14c::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.20 via Frontend
 Transport; Sun, 31 Dec 2023 16:44:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017092.mail.protection.outlook.com (10.167.17.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sun, 31 Dec 2023 16:44:57 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sun, 31 Dec
 2023 10:44:56 -0600
Date: Sun, 31 Dec 2023 10:44:40 -0600
From: Michael Roth <michael.roth@amd.com>
To: Borislav Petkov <bp@alien8.de>
CC: <x86@kernel.org>, <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <tobin@ibm.com>, <vbabka@suse.cz>,
	<kirill@shutemov.name>, <ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>, Jarkko Sakkinen <jarkko@profian.com>
Subject: Re: [PATCH v1 01/26] x86/cpufeatures: Add SEV-SNP CPU feature
Message-ID: <20231231164440.lj5v7eeu5r3cqzlg@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-2-michael.roth@amd.com>
 <20231231115012.GAZZFVdHCWijp7yFls@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231231115012.GAZZFVdHCWijp7yFls@fat_crate.local>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017092:EE_|LV8PR12MB9154:EE_
X-MS-Office365-Filtering-Correlation-Id: c9f80bfd-07fa-4551-f92a-08dc0a1fd286
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	f8DUsodeokI3415GLTDC9FxQFM1dxIGTSemRrcAoJc3KCcGdffC0GAWUwGsBMacBTPaIKvvS4o59nQvuqqvDwr8lLAdiByFSiaiUx1ftApVHMCFiqdpk9IWUMd3Ngy3fzZzc/TMclbyoerDanS7diaGhGFwpxThPeDw16eghs4M/IYV2iYEoHW+qPgWsxFF7xU2AsIMMcGY9ZBNmr6vDVg7HRNTwEw+sj/Q7cKM7sJGF8ac9evsGDEY9yY+ZiFIFgf9qSfJ0gE2duUh4VzYUq56Oy6Y7xd/H9RQRtArqcNKmpvarVAgWe72NZgdu25xH0CzAiDOF4AM+loyJwTbIz8tAkBdAKs9Lz95uzMCFrVM6SHCt/VF3WCU0WFomfTuywCzKf5TGbPvSHLTNPYECeqs9Q8WtYVwYT+6uXLSies/QDRUrb1lsAYAkUo1C4754UAdPmqU0e15/eAzftZGmHiSI33B7m86rmJHiUvAdJGWmRfSFUez6Yk0OcTvYiSBToDkfRbXWaL1djHPy9gPFHNZ/X69jUUwTuHJe4d/bbg592RADtLk1jGCtehGevssyOCcE5QUtwrc2w4hqkpZ4yXl0QtpXSNo6WH1p2DUUs1iPDf96j23dXzf+dfhEzbA1Tf7o81WVOExLRKbO3b3SDYyIqmh9n6MkvI4kO1BVHNXLp6IXw5iprSIRji4QHVbRH+rpNP8wnUjRfZfKWv3ev2lcJthnikE3Na/kc0l1esx7L9iLsVVyKnzcb6sSeYZP5y9oupm5AwG8D58dPoIh7A==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(396003)(39860400002)(136003)(230922051799003)(451199024)(1800799012)(82310400011)(64100799003)(186009)(40470700004)(46966006)(36840700001)(8936002)(2616005)(26005)(83380400001)(426003)(47076005)(41300700001)(81166007)(356005)(82740400003)(336012)(36860700001)(316002)(16526019)(8676002)(54906003)(44832011)(7406005)(2906002)(7416002)(5660300002)(4326008)(966005)(478600001)(70586007)(70206006)(6916009)(86362001)(6666004)(1076003)(36756003)(40480700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2023 16:44:57.1467
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c9f80bfd-07fa-4551-f92a-08dc0a1fd286
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017092.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9154

On Sun, Dec 31, 2023 at 12:50:12PM +0100, Borislav Petkov wrote:
> On Sat, Dec 30, 2023 at 10:19:29AM -0600, Michael Roth wrote:
> > From: Brijesh Singh <brijesh.singh@amd.com>
> > 
> > Add CPU feature detection for Secure Encrypted Virtualization with
> > Secure Nested Paging. This feature adds a strong memory integrity
> > protection to help prevent malicious hypervisor-based attacks like
> > data replay, memory re-mapping, and more.
> > 
> > Since enabling the SNP CPU feature imposes a number of additional
> > requirements on host initialization and handling legacy firmware APIs
> > for SEV/SEV-ES guests, only introduce the CPU feature bit so that the
> > relevant handling can be added, but leave it disabled via a
> > disabled-features mask.
> > 
> > Once all the necessary changes needed to maintain legacy SEV/SEV-ES
> > support are introduced in subsequent patches, the SNP feature bit will
> > be unmasked/enabled.
> > 
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
> > Signed-off-by: Ashish Kalra <Ashish.Kalra@amd.com>
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  arch/x86/include/asm/cpufeatures.h       | 1 +
> >  arch/x86/include/asm/disabled-features.h | 4 +++-
> >  arch/x86/kernel/cpu/amd.c                | 5 +++--
> >  tools/arch/x86/include/asm/cpufeatures.h | 1 +
> >  4 files changed, 8 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> > index 29cb275a219d..9492dcad560d 100644
> > --- a/arch/x86/include/asm/cpufeatures.h
> > +++ b/arch/x86/include/asm/cpufeatures.h
> > @@ -442,6 +442,7 @@
> >  #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
> >  #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
> >  #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
> > +#define X86_FEATURE_SEV_SNP		(19*32+ 4) /* AMD Secure Encrypted Virtualization - Secure Nested Paging */
> >  #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */
> >  #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
> >  #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* AMD SEV-ES full debug state swap support */
> > diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
> > index 702d93fdd10e..a864a5b208fa 100644
> > --- a/arch/x86/include/asm/disabled-features.h
> > +++ b/arch/x86/include/asm/disabled-features.h
> > @@ -117,6 +117,8 @@
> >  #define DISABLE_IBT	(1 << (X86_FEATURE_IBT & 31))
> >  #endif
> >  
> > +#define DISABLE_SEV_SNP		0
> 
> I think you want this here if SEV_SNP should be initially disabled:
> 
> diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
> index a864a5b208fa..5b2fab8ad262 100644
> --- a/arch/x86/include/asm/disabled-features.h
> +++ b/arch/x86/include/asm/disabled-features.h
> @@ -117,7 +117,7 @@
>  #define DISABLE_IBT	(1 << (X86_FEATURE_IBT & 31))
>  #endif
>  
> -#define DISABLE_SEV_SNP		0
> +#define DISABLE_SEV_SNP	(1 << (X86_FEATURE_SEV_SNP & 31))
>  
>  /*
>   * Make sure to add features to the correct mask

Sorry, I must have inverted things when I was squashing in the changes =\

I've gone ahead and force-pushed your fixup to the snp-host-init-v1
branch.

Thanks,

Mike

> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

