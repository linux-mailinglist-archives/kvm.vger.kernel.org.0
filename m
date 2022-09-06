Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1D95AEF69
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 17:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237308AbiIFPvy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 11:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234529AbiIFPvc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 11:51:32 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2068.outbound.protection.outlook.com [40.107.92.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FD662AA1;
        Tue,  6 Sep 2022 08:06:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N+aAbQohOEGo28BO6tV6YH1VcPr0l0gibU6RJ5FsI8rT/LIZPS5a6DQIc66PJVNGMmS95CapKhGzn6M+iet+aYpJE+onzZugvqffXtqOuKnXFknL6A8tPGKP/CZmnW11YtLfcBi6X39cBCTQUjfcESNrmX/1HdlIJ3Ixw8yAQK1rTHc1SNsnY7Hz+6/hKsURQXcCzg38gNDdJIo8puHD5etYqbBOMzR4nJn8RLZ4zHR0KxTe8bSFrqdM+5nqZDoE0aJ6qNnvpriLVYDizYjCic8ssExSa9bT4r+26Aa4LYM2z+Lu4KJrHv4+uy9M3yC/BnYN3TVJLynI+nHOfY9Q+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t04+BqkgjX3bgXEy0Znny8fEtVdufxpjRhleigZHYVk=;
 b=WkGjm6mzgeMAJnheQLCRrZ4p7/A9Wfz/vOOVIneJIFPtNenehio6s9d4UZI/MKZdmrKwAXJojMt6SdbxI9pDWOJv4KIL/YNfiOuoYBIUrSxrghf/bqtMsah09ydmlj4bIsg5JXZynL/fvf9Spgs37G4MI87fveGfRd/Jr7GDBhSfGVUN6hEtZQwKVuRKc7G+p12nPWEg9Q4SegHE4UcDMrmZbJlnONShD06032t39VlWXKQbHtVFMdI6rQSK6euuOPZ5xsdMyAjJ1qheNKgpsQCjRDq/sR3o/5EP11HLZpi3l1FaikbEGK3H6wIxSrdBfpCQ9lzTyuuY+zL4rNohUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t04+BqkgjX3bgXEy0Znny8fEtVdufxpjRhleigZHYVk=;
 b=eoGI48JqqKSFYKYxZjeFZlpYPXz7Mt1l0YZ2+/v3U5ZQuqEaNGf56EZzKLauoAjnY1QtFiII4THjoyt4jMvXz3oMSg8tqegfBrP1Y643Rlw+DqKeYvaQLfGgeBo1eL/7L8fB/ZFEvbA5ifGyWISyGxfPgaGvTqj88HJ2HD+yy8g=
Received: from BN9PR03CA0514.namprd03.prod.outlook.com (2603:10b6:408:131::9)
 by CH2PR12MB4069.namprd12.prod.outlook.com (2603:10b6:610:ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12; Tue, 6 Sep
 2022 15:06:53 +0000
Received: from BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:131:cafe::ec) by BN9PR03CA0514.outlook.office365.com
 (2603:10b6:408:131::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12 via Frontend
 Transport; Tue, 6 Sep 2022 15:06:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT036.mail.protection.outlook.com (10.13.177.168) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5588.10 via Frontend Transport; Tue, 6 Sep 2022 15:06:53 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 6 Sep
 2022 10:06:53 -0500
Date:   Tue, 6 Sep 2022 10:06:35 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     "Kalra, Ashish" <Ashish.Kalra@amd.com>
CC:     Marc Orr <marcorr@google.com>, Jarkko Sakkinen <jarkko@kernel.org>,
        Borislav Petkov <bp@alien8.de>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "Linux Memory Management List" <linux-mm@kvack.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Srinivas Pandruvada" <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        "Tobin Feldman-Fitzthum" <tobin@ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        "Tony Luck" <tony.luck@intel.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH Part2 v6 09/49] x86/fault: Add support to handle the RMP
 fault for user address
Message-ID: <20220906150635.mhfvtl2xgdbzr7a5@amd.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <0ecb0a4781be933fcadeb56a85070818ef3566e7.1655761627.git.ashish.kalra@amd.com>
 <YvKRjxgipxLSNCLe@zn.tnic>
 <YxcgAk7AHWZVnSCJ@kernel.org>
 <CAA03e5FgiLoixmqpKtfNOXM_0P5Y7LQzr3_oQe+2Z=GJ6kw32g@mail.gmail.com>
 <SN6PR12MB2767ABA4CEFE4591F87968AD8E7E9@SN6PR12MB2767.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <SN6PR12MB2767ABA4CEFE4591F87968AD8E7E9@SN6PR12MB2767.namprd12.prod.outlook.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9cde9736-7ab9-492d-803a-08da90196efd
X-MS-TrafficTypeDiagnostic: CH2PR12MB4069:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +yYR8h0l8iBwUFDxR7TZmg0mZ1ELWIGN+eR2n4TfmcGKmqp9maKRQdGQgS7euFINJOZvA/DQlTnyN+Lhwi0AND2MpAZhJXFletBf4U2FYbgD29sSkqvanQbUdgnQ4M6ZtzU6uMTY8mGkh2jXxOUQKNtBXojoAtjSb0i+OkdKF2ebJp/qvhM+Q8LyiLJLzFK1kl9ktMox+6iBZuhtOlV+H6HaAmChOxIz5cdRsLg5WKQjiJWHpn9EsWTzmhah/DbEwNrhADgIT4euuMtkWRxPUtg/i3B7HTq49yjdebMZvJTgXG+RqxKgJwNmazJ6k8N6mvx1rNL9NuvcU89gok34rYOCBa+0Vmthh2Ikf3VA6zUhtL//umHw3KdLNb/5i4wcPTpSI0v1oFxk4wE4MGGkSmQVsu8rppHC3xgH6fTf/qjx+OXWEIXcxOlYTEJDJUp/jvWRN8Mkl257W3UOaFP8hgLEWkDnWxchiG1dOuMMOPf4rGmdFtqo75rQEuDdPrI81L1XLJNdbgHRFbAK28jkwFlKR1stBG1b8Vf7LFXP5XKUAIxr/UNvvOcEoRbNkW4nMntPyV/VApWE3DRRydPAWYX6Z+h5zHp3X1wyvvvfuAuaYPut6FrI0sQ1od5BcBg+QS6fU8+1aqltqL+6/s1X+Lkv1JxN4wI8Vyp/IZfSpTGId4J6LW61vqjngUUmDCF4V5RDyrlqcAGygQY5HDx/7b1ywwGBwFoiu70Gh89pPiO8jH31/7a5Khj0c+Hf35W+zLz7kzOQzVfAewpXoYef6r7MLWCYtCYAInBv9+pgRlYOfgbwIkFJnwMWZgB6lfPM
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(346002)(396003)(39860400002)(46966006)(36840700001)(40470700004)(86362001)(82310400005)(1076003)(47076005)(16526019)(186003)(336012)(2616005)(6666004)(40480700001)(478600001)(41300700001)(26005)(426003)(40460700003)(81166007)(82740400003)(356005)(83380400001)(36860700001)(5660300002)(316002)(37006003)(44832011)(54906003)(8676002)(2906002)(8936002)(4326008)(6862004)(6636002)(36756003)(7406005)(7416002)(70586007)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 15:06:53.6254
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cde9736-7ab9-492d-803a-08da90196efd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4069
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 06, 2022 at 09:17:15AM -0500, Kalra, Ashish wrote:
> [AMD Official Use Only - General]
> 
> >> On Tue, Aug 09, 2022 at 06:55:43PM +0200, Borislav Petkov wrote:
> >> > On Mon, Jun 20, 2022 at 11:03:43PM +0000, Ashish Kalra wrote:
> >> > > +   pfn = pte_pfn(*pte);
> >> > > +
> >> > > +   /* If its large page then calculte the fault pfn */
> >> > > +   if (level > PG_LEVEL_4K) {
> >> > > +           unsigned long mask;
> >> > > +
> >> > > +           mask = pages_per_hpage(level) - pages_per_hpage(level - 1);
> >> > > +           pfn |= (address >> PAGE_SHIFT) & mask;
> >> >
> >> > Oh boy, this is unnecessarily complicated. Isn't this
> >> >
> >> >       pfn |= pud_index(address);
> >> >
> >> > or
> >> >       pfn |= pmd_index(address);
> >>
> >> I played with this a bit and ended up with
> >>
> >>         pfn = pte_pfn(*pte) | PFN_DOWN(address & page_level_mask(level 
> >> - 1));
> >>
> >> Unless I got something terribly wrong, this should do the same (see 
> >> the attached patch) as the existing calculations.
> 
> >Actually, I don't think they're the same. I think Jarkko's version is correct. Specifically:
> >- For level = PG_LEVEL_2M they're the same.
> >- For level = PG_LEVEL_1G:
> >The current code calculates a garbage mask:
> >mask = pages_per_hpage(level) - pages_per_hpage(level - 1); translates to:
> >>> hex(262144 - 512)
> >'0x3fe00'
> 
> No actually this is not a garbage mask, as I explained in earlier responses we need to capture the address bits 
> to get to the correct 4K index into the RMP table.
> Therefore, for level = PG_LEVEL_1G:
> mask = pages_per_hpage(level) - pages_per_hpage(level - 1) => 0x3fe00 (which is the correct mask).

That's the correct mask to grab the 2M-aligned address bits, e.g:

  pfn_mask = 3fe00h = 11 1111 1110 0000 0000b
  
  So the last 9 bits are ignored, e.g. anything PFNs that are multiples
  of 512 (2^9), and the upper bits comes from the 1GB PTE entry.

But there is an open question of whether we actually want to index using
2M-aligned or specific 4K-aligned PFN indicated by the faulting address.

> 
> >But I believe Jarkko's version calculates the correct mask (below), incorporating all 18 offset bits into the 1G page.
> >>> hex(262144 -1)
> >'0x3ffff'
> 
> We can get this simply by doing (page_per_hpage(level)-1), but as I mentioned above this is not what we need.

If we actually want the 4K page, I think we would want to use the 0x3ffff
mask as Marc suggested to get to the specific 4K RMP entry, which I don't
think the current code is trying to do. But maybe that *should* be what we
should be doing.

Based on your earlier explanation, if we index into the RMP table using
2M-aligned address, we might find that the entry does not have the
page-size bit set (maybe it was PSMASH'd for some reason). If that's the
cause we'd then have to calculate the index for the specific RMP entry
for the specific 4K address that caused the fault, and then check that
instead.

If however we simply index directly in the 4K RMP entry from the start,
snp_lookup_rmpentry() should still tell us whether the page is private
or not, because RMPUPDATE/PSMASH are both documented to also update the
assigned bits for each 4K RMP entry even if you're using a 2M RMP entry
and setting the page-size bit to cover the whole 2M range.

Additionally, snp_lookup_rmpentry() already has logic to also go check
the 2M-aligned RMP entry to provide an indication of what level it is
mapped at in the RMP table, so we can still use that to determine if the
host mapping needs to be split or not.

One thing that could use some confirmation is what happens if you do an
RMPUPDATE for a 2MB RMP entry, and then go back and try to RMPUPDATE a
sub-page and change the assigned bit so it's not consistent with 2MB RMP
entry. I would assume that would fail the instruction, but we should
confirm that before relying on this logic.

-Mike

> 
> Thanks,
> Ashish
