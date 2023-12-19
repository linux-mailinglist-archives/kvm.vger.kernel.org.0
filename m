Return-Path: <kvm+bounces-4870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C211819248
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 22:30:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4C8F287B55
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 21:30:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F9433B78A;
	Tue, 19 Dec 2023 21:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BiBRGd3E"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1683B182;
	Tue, 19 Dec 2023 21:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cpLp1wSEtLBy7tRRBZ8V2OUZ+WH/QjqrcQ38H2g5JjMrkBnAQ2BQxRq8eC8abzZg/qHFba2zJjKSgSS/L5ScgTgn03ssReCBKNtn3Ce8vSiyo4xIKlGj7PmZ4Qq/M/PCzV6w9IvTArgjaQBZrtFEsN/nRoFjgFeqRjLkbAp3MdCt9+Z+Mv6tB16VytvESfS4jZVbh0PgGn1JhhYVoi6X8S5TcR7ZWNrQ3pVCjZGj9bI2Gg2iKVT0CsfnnOIMLgxmSZhhePdzixSZ9f9j8bma2jOqX3F05usjNYo2q9p9YUyThmewM6iCAu2etPp5bty0q3AQ0hUZIz7WxUqeI+6YzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=larFxOrXAtkjbUQlyWzN5yyIEXBmwUnR3RKBgeKYw8w=;
 b=YQQLUqGWhAYllErJQRmK6X3OfGNg4e77HNpVlW4kRiSAPyV4eXQE199Z1zqDFmzMv3TSXfD4h1jIlwd3eLnVwH5ohab9lmOZlQqs1er3CHgLkTgwv7g1HOTF+gLwwfyiJTiy+RrwkOCpwVZfM2/qMLN15KvaD3HELvtvhUxdVpp9a5jGipCf5teziwwnoQi10DMOFITdq/AFk/tgBGg2wJgI5Bpr6o6u8yOjMSJdU88qsG7epG+ge7bVOc9bJcAHqrpB03EZj14Nh3ujBIrRXPjlH8XRS7I6ZezSBjjROcEc8bQwbcqPLvCztozC3HnLxaH/s2xtP/cMXxVnRXNFUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=larFxOrXAtkjbUQlyWzN5yyIEXBmwUnR3RKBgeKYw8w=;
 b=BiBRGd3EgO86yQ+3pz9vRrWHfyBQxP5FQbMutb7jsMWr9czaesHFSuxjTDUbR2S6WhS4e5bNXFDpGm1tkQiNy+u4Ip49cZ2SIYLLE9tdmXUkfF0BzF7PUt6Y8C+sBramXLLHCnbahpKPlaxXyTHTWtxIzyu9qrDzwnbl7mmpNtY=
Received: from CH2PR05CA0021.namprd05.prod.outlook.com (2603:10b6:610::34) by
 DM4PR12MB5841.namprd12.prod.outlook.com (2603:10b6:8:64::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.38; Tue, 19 Dec 2023 21:29:48 +0000
Received: from SA2PEPF00001507.namprd04.prod.outlook.com
 (2603:10b6:610:0:cafe::9b) by CH2PR05CA0021.outlook.office365.com
 (2603:10b6:610::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18 via Frontend
 Transport; Tue, 19 Dec 2023 21:29:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00001507.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7113.14 via Frontend Transport; Tue, 19 Dec 2023 21:29:47 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Tue, 19 Dec
 2023 15:29:46 -0600
Date: Mon, 18 Dec 2023 21:31:50 -0600
From: Michael Roth <michael.roth@amd.com>
To: Borislav Petkov <bp@alien8.de>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
	<tony.luck@intel.com>, <sathyanarayanan.kuppuswamy@linux.intel.com>,
	<alpergun@google.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
	<nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>, <liam.merwick@oracle.com>,
	<zhi.a.wang@intel.com>, Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v10 07/50] x86/sev: Add RMP entry lookup helpers
Message-ID: <20231219033150.m4x6yh6udupkdqaa@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-8-michael.roth@amd.com>
 <20231114142442.GCZVODKh03BoMFdlmj@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231114142442.GCZVODKh03BoMFdlmj@fat_crate.local>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001507:EE_|DM4PR12MB5841:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bc95432-33d2-4ad1-31e0-08dc00d9a068
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	9KD0603tTAiALk7I6Jz12bQio8+vI4sno7zUFyDelGPzqACFMThcn3dAoBEgAUF68TmjEno8fwCgGaM83MStOqm94FR+FgCUlmB0w6mtH/vKGfVUwAs7vDl+r073Pc2ZlDec+6IA3/m+xMcbRKrTmp4q0yZtMOo3UCrjDFbdeebapQ+5asHlCOAAZ60VJU0LsqUFlnR0hxVGHuU4F0v2R7B0sQUmI7fjrcMVhtttbiJHT74i1W2cVoVS6tVPzVeYrPwXicKHD0jrHMkTaUhAlX5sRwE4KT4XwmcAhkRa5KIk+wAcfE+aYdvgD0Mr82VVAaFO/FAagUkmjNwqiQYcvibBncoibGKPVy6LhKg9VLRLa3rTXgpNWApFie8TbSuoSNbB5/cYrVoYEIivdxbXxJAj+yU7nPg6zctn+oBnSLVrO/OvLgsUOQxFqBCOL9PpFVM6RRAqOsFo603KpxFuqjj36D0erWwjERDhAjl0gxEKBDtWBu/+RLjlQUahSP5oCmoj50h+7Xw+0YMpT3uFfuneLoUaC2A/XVc+TcX5MPNk75FYlO/VyprXI8ZoQglzrZb+7fULWpA9gV8gRyUR5NAUZS2J6UAPh2lxydQfEz8HXzCrZlK45cp6xBlYOXMokhied3xskSAN0lcTbrc9igboiXW/bZxQB/RCsMsrzKgt9AtGlCBx2X4cpdNrPPpPUGCJXHOfkpZWcj0/7XNVFH3S7s0tQOruBCAbeMuciggk6xH8IKd+rTTi1JrPAF8I62NF7y1tCpcNV5KJ2zzWbdg0oiRUxTepiUp8cviyAyk=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(39860400002)(376002)(346002)(396003)(230273577357003)(230173577357003)(230922051799003)(1800799012)(451199024)(82310400011)(186009)(64100799003)(40470700004)(46966006)(36840700001)(36756003)(83380400001)(7416002)(6916009)(316002)(426003)(336012)(70206006)(40480700001)(7406005)(54906003)(70586007)(47076005)(4326008)(44832011)(8936002)(5660300002)(36860700001)(82740400003)(8676002)(2906002)(6666004)(86362001)(16526019)(478600001)(1076003)(966005)(2616005)(26005)(41300700001)(40460700003)(81166007)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2023 21:29:47.8229
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bc95432-33d2-4ad1-31e0-08dc00d9a068
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001507.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5841

On Tue, Nov 14, 2023 at 03:24:42PM +0100, Borislav Petkov wrote:
> On Mon, Oct 16, 2023 at 08:27:36AM -0500, Michael Roth wrote:
> > From: Brijesh Singh <brijesh.singh@amd.com>
> > 
> > The snp_lookup_page_in_rmptable() can be used by the host to read the RMP
> 
> $ git grep snp_lookup_page_in_rmptable
> $
> 
> Stale commit message. And not very telling. Please rewrite.
> 
> > entry for a given page. The RMP entry format is documented in AMD PPR, see
> > https://bugzilla.kernel.org/attachment.cgi?id=296015.
> 
> <--- Brijesh's SOB comes first here if he's the primary author.
> 
> > Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > [mdr: separate 'assigned' indicator from return code]
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  arch/x86/include/asm/sev-common.h |  4 +++
> >  arch/x86/include/asm/sev-host.h   | 22 +++++++++++++
> >  arch/x86/virt/svm/sev.c           | 53 +++++++++++++++++++++++++++++++
> >  3 files changed, 79 insertions(+)
> >  create mode 100644 arch/x86/include/asm/sev-host.h
> > 
> > diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> > index b463fcbd4b90..1e6fb93d8ab0 100644
> > --- a/arch/x86/include/asm/sev-common.h
> > +++ b/arch/x86/include/asm/sev-common.h
> > @@ -173,4 +173,8 @@ struct snp_psc_desc {
> >  #define GHCB_ERR_INVALID_INPUT		5
> >  #define GHCB_ERR_INVALID_EVENT		6
> >  
> > +/* RMP page size */
> > +#define RMP_PG_SIZE_4K			0
> 
> RMP_PG_LEVEL_4K just like the generic ones.

I've moved this to sev.h, but it RMP_PG_SIZE_4K is already defined there
and used by a bunch of guest code so it's a bit out-of-place to update
those as part of this patchset. I can send a follow-up series to clean up
some of the naming and get rid of sev-common.h

> 
> > +#define RMP_TO_X86_PG_LEVEL(level)	(((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)
> 
> What else is there besides X86 PG level?
> 
> IOW, RMP_TO_PG_LEVEL simply.

Make sense.

> 
> > +
> >  #endif
> > diff --git a/arch/x86/include/asm/sev-host.h b/arch/x86/include/asm/sev-host.h
> 
> Nah, we don't need a third sev header:
> 
> arch/x86/include/asm/sev-common.h
> arch/x86/include/asm/sev.h
> arch/x86/include/asm/sev-host.h
> 
> Put it in sev.h pls.

Done.

> 
> sev-common.h should be merged into sev.h too unless there's a compelling
> reason not to which I don't see atm.

Doesn't seem like it would be an issue, maybe some fallout from any
files that previously only included sev-common.h and now need to pull in
guest struct definitions as well, but those definitions don't have a lot
of external dependencies so don't anticipate any header include
hellishness. I'll send that as a separate follow-up, along with some of
the renames you suggested above since they'll touch guest code and
create unecessary churn for SNP host support.

Thanks,

Mike

> > -- 
> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

