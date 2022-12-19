Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B101650E32
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 16:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbiLSPBs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 10:01:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232107AbiLSPBm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 10:01:42 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7312E2718;
        Mon, 19 Dec 2022 07:01:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q6YVd4xMvUoIq2Wx9WV2h35FJy8uA4ZCtWgyaqaZYq2r7ihZ4DYTu7dseZ6rADG7wD484h+Jje14lhCyb44pUGrLfOdfRBWHP8CZrKw5ICx81UDiwKgGD7j1YyA3Arc+nNCSqAJLKWCVflk8rcbs/Zg1cJgAowLpMLdtYCBP03JgyuWCw4wGuXy+OUzGGc/t3xAOs/Jpp64UISLJXbT5jZ7scUZOL2eBIPo9kDTPTgfqFhUU36hfNEqf7iJ6cEc4auqhULjWr6hrvuOMx/3va4QLy87ll6AdtttDUYy+M7YzAKpyaGvEVUgp5bjHc64olvxLn6hRLzYtU8Jy2Ys2aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ig2iSgdvV3uLbGe83tM3u1cZ6pMnlDn3IGSbdiQ7yY=;
 b=Rbr1D5rEwP4+Hb9h/yjW2cIIz6mde+4y37GGaJ/w+or4wgtsi3bdYHIcko1BgyLf2flnkrIUxtxA4XjeDC/c3Ob9CkBnl7alPx/chD2W9BZp4spGgtLOe/KZtPPkd5/PNKK1tEVyZxCsBZR3aJSlnIf6Xs3AROaUuWyFYTSpqj1zflXdqQvHO9dY2qtCJTxdzziX20hsUq1GpOmXLi5NHDIkOzQbJJAeCENqSngpexnvbPTWWg2sbt9xx/RmO8e+i1BuqbqjsAfQbdnHiqBIOtd2y9jIUOWLsg7xH7i8MBrzz/XLIonCYcmGbfhLXTF6aOUXMzoz47cBb8KAoUlVbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ig2iSgdvV3uLbGe83tM3u1cZ6pMnlDn3IGSbdiQ7yY=;
 b=OhMjh3VXPYNz8RYoa7DRJzOj5aZjpvuhEdDDKeCr/PdBgUtg0J9ww+UTOCWemYi7BtCwfTYZxC1hJJYGBnykO53PE1lVwJJsDaUxuNohBxoZuV5pK1bBViv4EGY6Hcug1WV6Y2TIVoOSxNqCaMSOl+hcomjEmRRTu7aRddimFKc=
Received: from MN2PR11CA0027.namprd11.prod.outlook.com (2603:10b6:208:23b::32)
 by MN0PR12MB6344.namprd12.prod.outlook.com (2603:10b6:208:3d3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.21; Mon, 19 Dec
 2022 15:01:38 +0000
Received: from BL02EPF00010209.namprd05.prod.outlook.com
 (2603:10b6:208:23b:cafe::58) by MN2PR11CA0027.outlook.office365.com
 (2603:10b6:208:23b::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.20 via Frontend
 Transport; Mon, 19 Dec 2022 15:01:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00010209.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5944.8 via Frontend Transport; Mon, 19 Dec 2022 15:00:44 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 19 Dec
 2022 09:00:43 -0600
Date:   Mon, 19 Dec 2022 09:00:26 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     Ashish Kalra <Ashish.Kalra@amd.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <vbabka@suse.cz>,
        <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>
Subject: Re: [PATCH Part2 v6 07/49] x86/sev: Invalid pages from direct map
 when adding it to RMP table
Message-ID: <20221219150026.bltiyk72pmdc2ic3@amd.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <243778c282cd55a554af9c11d2ecd3ff9ea6820f.1655761627.git.ashish.kalra@amd.com>
 <YuFvbm/Zck9Tr5pq@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YuFvbm/Zck9Tr5pq@zn.tnic>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00010209:EE_|MN0PR12MB6344:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a3d93a4-984a-447d-486b-08dae1d1ebad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sn+iN0EOHrZbPtlTuU6uoHqSN7Wf81Q4S9116CuzH/V2P7pWEab1sSrnTqFnQGFP79aOHV+FVEbDOfaFglpFP6cJzNT3+OutSPPuNVD51zrNt0+qr5Ahr19cIImZTDRglJe82ydiUtqne61wUB6YjbD9v9ZNwWNgxlZq810GbO3magv7dV0YFzz+5oFhI9DhXgnoa17FoCEMSZNBQ9obTyZrYorhq8oD3y7gZ25A/5NSHH/cEgUZmeTLbwrnUfS0HH9BwBf6tuWbeaT2LsPV/zLr2Ss40tK1RR3e94KM9hk9d5yqBvFKPSOet5Nlfp3lcGwOO7B1LbN9yrt9ntjxwFBTY7CUR+pCyOFUyJeE/l7bAk0XztUV2xeUxo3cB2umNaeMMCQyqWditN8Nst9rjlmwX26j/rdOKNwp/c+Iq1sgcgv91uw18HqqNItg2kK7/c/Pa603WBjQwRD1acsLZrGtoBZoYLBpGlYcx7RDt0ar4bQlpSQWWz3m8CEJOSETAi7mz0yCWsHUFfaaVR/7irjh5XM9G50YLYWCtzvlWRZf/EdRXAG6NeCvyLw8M5QjETbpKs3j+D1xBdxYHNIwrGcLMS3Vg3WsZpBCvnF6qzXc8QUbz9s9lAF8YMvaWFp7LpBG9UnAK43AhaoGpUZcr0gnHkckQsFACNjnfhd7hXtK97aQm78BcICnUNWbnNTIEIiSiIL4DtmsnQ4tbDKKanpBXAYsU1kFHfWcSHXWzvsOHtJePILKrTqr7K16wcV8nMz17g+Hd66IkXlQYgFyvw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(396003)(376002)(451199015)(46966006)(40470700004)(36840700001)(2906002)(2616005)(16526019)(186003)(6916009)(36756003)(6666004)(40480700001)(26005)(4326008)(1076003)(8676002)(36860700001)(356005)(7406005)(70586007)(70206006)(7416002)(5660300002)(86362001)(41300700001)(47076005)(81166007)(82740400003)(336012)(426003)(54906003)(83380400001)(316002)(8936002)(40460700003)(82310400005)(478600001)(44832011)(966005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2022 15:00:44.8038
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a3d93a4-984a-447d-486b-08dae1d1ebad
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF00010209.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6344
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 27, 2022 at 07:01:34PM +0200, Borislav Petkov wrote:
> On Mon, Jun 20, 2022 at 11:03:07PM +0000, Ashish Kalra wrote:
> 
> > Subject: x86/sev: Invalid pages from direct map when adding it to RMP table
> 
> "...: Invalidate pages from the direct map when adding them to the RMP table"
> 
> > +static int restore_direct_map(u64 pfn, int npages)
> > +{
> > +	int i, ret = 0;
> > +
> > +	for (i = 0; i < npages; i++) {
> > +		ret = set_direct_map_default_noflush(pfn_to_page(pfn + i));
> 
> set_memory_p() ?

We implemented this approach for v7, but it causes a fairly significant
performance regression, particularly for the case for npages > 1 which
this change was meant to optimize.

I still need to dig in a big but I'm guessing it's related to flushing
behavior.

It would however be nice to have a set_direct_map_default_noflush()
variant that accepted a 'npages' argument, since it would be more
performant here and also would potentially allow for restoring the 2M
direct mapping in some cases. Will look into this more for v8.

-Mike

> 
> > +		if (ret)
> > +			goto cleanup;
> > +	}
> > +
> > +cleanup:
> > +	WARN(ret > 0, "Failed to restore direct map for pfn 0x%llx\n", pfn + i);
> 
> Warn for each pfn?!
> 
> That'll flood dmesg mightily.
> 
> > +	return ret;
> > +}
> > +
> > +static int invalid_direct_map(unsigned long pfn, int npages)
> > +{
> > +	int i, ret = 0;
> > +
> > +	for (i = 0; i < npages; i++) {
> > +		ret = set_direct_map_invalid_noflush(pfn_to_page(pfn + i));
> 
> As above, set_memory_np() doesn't work here instead of looping over each
> page?
> 
> > @@ -2462,11 +2494,38 @@ static int rmpupdate(u64 pfn, struct rmpupdate *val)
> >  	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> >  		return -ENXIO;
> >  
> > +	level = RMP_TO_X86_PG_LEVEL(val->pagesize);
> > +	npages = page_level_size(level) / PAGE_SIZE;
> > +
> > +	/*
> > +	 * If page is getting assigned in the RMP table then unmap it from the
> > +	 * direct map.
> > +	 */
> > +	if (val->assigned) {
> > +		if (invalid_direct_map(pfn, npages)) {
> > +			pr_err("Failed to unmap pfn 0x%llx pages %d from direct_map\n",
> 
> "Failed to unmap %d pages at pfn 0x... from the direct map\n"
> 
> > +			       pfn, npages);
> > +			return -EFAULT;
> > +		}
> > +	}
> > +
> >  	/* Binutils version 2.36 supports the RMPUPDATE mnemonic. */
> >  	asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"
> >  		     : "=a"(ret)
> >  		     : "a"(paddr), "c"((unsigned long)val)
> >  		     : "memory", "cc");
> > +
> > +	/*
> > +	 * Restore the direct map after the page is removed from the RMP table.
> > +	 */
> > +	if (!ret && !val->assigned) {
> > +		if (restore_direct_map(pfn, npages)) {
> > +			pr_err("Failed to map pfn 0x%llx pages %d in direct_map\n",
> 
> "Failed to map %d pages at pfn 0x... into the direct map\n"
> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
