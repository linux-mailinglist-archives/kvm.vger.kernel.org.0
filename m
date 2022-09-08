Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 879655B294B
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 00:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiIHW3G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 18:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiIHW3E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 18:29:04 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2051.outbound.protection.outlook.com [40.107.237.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DACA9C534;
        Thu,  8 Sep 2022 15:29:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oIc77U9v3JGymKPalKEEooIlQBBmDGaA5kfbJc1PxnTZhPncpAUP+lG614Pdkd1Z3v3ZBiP8SWAphK+wMgJsN8BgKBUSN68sXLlvlD0S/hGf7I62go/N2DVy1VC5WuWpswDaytpVAS7GhuwfPIwjdwG49tQssEN0TQm7DFGaS/z2BEwi01TCPxvGaELl89KQkKbrcdmUCa9d9TIEpCnQ1PNVx0Dt+TXNaBltAc67NDwqUqDtKqeinhNcuiMpCmNkIwU3fhtSeseZbD+0ry5PuO8n4VgnPiPc1u9UhWb+Xn+UdhFoTIJYywKMiLmPOhuEdzwbDlSOWZLzMYaW0CslPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3b4KL6z5FWhyrR8E6jExBB8Ta3XF8MB+Evt/Hg6x8Ew=;
 b=NV+QIHFOE8VvMGkVVaTWaxz2zSaKTGlWFWpMeuZACiRo63T7q43vKF0kDMarLDWqSGI+RHr5Ph4QPm4CiE3qWU990eOa6IlYg8UgZLlpTgmUdu8B9q4khjzC58Q0TTtBwCwheulvZPOHOEeXXIGTMb7juapNHk+kK5WqW/XBNpaZ2ZZUyku8iSRjZWJ4whKCSbO+M9NEynZZd2nvMibGRua83EaifKWMY6/Cz4GAZZKzlSMgLjbHs+MKjQOe5Jz8ktmbKkXhz2l4Tc2vhV9k/CqtHIT302z2QzuCU2eoMlCE4CJ5IyJYk1CCt49qn/a5eCzFfKGXMwMWqzhjPqM09w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3b4KL6z5FWhyrR8E6jExBB8Ta3XF8MB+Evt/Hg6x8Ew=;
 b=g44DKDBndEDc6H0YCnACy2Wz2eHMfq4qmm7d6glpUHeBrmpGgANBCGmXdKGeKli8gKObt/Llnsj5valuNua3t4qNHDZCreA+PGH/kqz9V9m4qU8BSp1ZoeGnVcdmgn9YKaxvT4w2mCyuPapZEazbV9PVc9erklNju3ZTf8eWp5o=
Received: from BN0PR10CA0021.namprd10.prod.outlook.com (2603:10b6:408:143::24)
 by BL0PR12MB5009.namprd12.prod.outlook.com (2603:10b6:208:1c2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Thu, 8 Sep
 2022 22:29:00 +0000
Received: from BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:143:cafe::6b) by BN0PR10CA0021.outlook.office365.com
 (2603:10b6:408:143::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12 via Frontend
 Transport; Thu, 8 Sep 2022 22:29:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT068.mail.protection.outlook.com (10.13.177.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5612.13 via Frontend Transport; Thu, 8 Sep 2022 22:29:00 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 8 Sep
 2022 17:28:58 -0500
Date:   Thu, 8 Sep 2022 17:28:43 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Brijesh Singh <brijesh.singh@amd.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Srinivas Pandruvada" <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        "Tobin Feldman-Fitzthum" <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        "Vlastimil Babka" <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        "Andi Kleen" <ak@linux.intel.com>, <tony.luck@intel.com>,
        <marcorr@google.com>, <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <jarkko@profian.com>
Subject: Re: [PATCH Part2 v5 39/45] KVM: SVM: Introduce ops for the post gfn
 map and unmap
Message-ID: <20220908222843.x6jort7kaw4qnft3@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-40-brijesh.singh@amd.com>
 <YWYm/Gw8PbaAKBF0@google.com>
 <YWc+sRwHxEmcZZxB@google.com>
 <4e41dcff-7c7b-cf36-434a-c7732e7e8ff2@amd.com>
 <YWm3bOFcUSlyZjNb@google.com>
 <20220908212114.sqne7awimfwfztq7@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220908212114.sqne7awimfwfztq7@amd.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT068:EE_|BL0PR12MB5009:EE_
X-MS-Office365-Filtering-Correlation-Id: e149aba8-cd9c-4a46-7691-08da91e98703
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mbDWHgK2utvKJzReekh8PiY+8tEEZXHST6isJHFYZkW2qEomLZHsdzSojyGeQABiOT4lghUM1oD/+Q3r6Q74ccBQGFaQ5gmwOs2NuE48I/a7m8niM2KDzcO7T0WpV2ig4hKkzbq0cFz2xBX2AHufeM6r+LQNiLuIiV6sqU+OBD5RPLEVNPgvAnCjRSDFgSvZgycXnJ6zxa00uaJ0f7Ey8glmcprh5aJPZ/biWxIxPTjOHAgfkEbXM8WJAelUSVtW3xNlikSR9n9WQ9Trs4pu9KOlzS3CduqDuFJDRSAOoRiKUTSddKSnkKgLZb8/JtHqZnweeqkTOTvuFbI6uqMJJ37oUOz6/dxWulrhjMLzrdQywHe/NxS19u/eYCH9zo9EfX+zkPMeVNjn/v5ck9wNnSQ4josbSeYvliPJ7eIHl71db6NXpDcnuG+RAnoCpaKt3pxggMBKVUz6R+D8GT9wflyvqJdSp1C/KMPeELQKBAPjbqPi75LBaZ0MAK9/0w6bjtMBbya0gIa20j55h7TlVAi2G0OaqoiLypkBAsafLVLkSnkDlV8YqELkR/fzcI0kdfmm6xzoJbgBjBd95cV2m3vLWQy9lEBHNvp3Fpzj1kJl7SIxSHcJpuM6mkRMOPbDLTuEFEoVTywcguZX9bh8IlPTDQOrfknsg5eYkxqQ+NymqjbrQVC3mG3LS6lLyUCAJv3scX4btEYHkVJfhEXnHZRO3UJVp+g3/3JVm7Kya5mK5oEwdZb+CPzSxjkt8tZyBOdYMPREcGKPPqomM2+VdrT9DKXNCj3bNV35CrNJ+XdMDjCjOU44QxYyvy+A9fFp
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(376002)(346002)(396003)(36840700001)(40470700004)(46966006)(1076003)(41300700001)(426003)(47076005)(2616005)(6666004)(16526019)(478600001)(26005)(186003)(40480700001)(53546011)(336012)(82310400005)(86362001)(40460700003)(81166007)(356005)(82740400003)(83380400001)(36756003)(5660300002)(70206006)(316002)(36860700001)(7406005)(70586007)(4326008)(2906002)(8676002)(7416002)(8936002)(6916009)(44832011)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 22:29:00.4123
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e149aba8-cd9c-4a46-7691-08da91e98703
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5009
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 08, 2022 at 04:21:14PM -0500, Michael Roth wrote:
> On Fri, Oct 15, 2021 at 05:16:28PM +0000, Sean Christopherson wrote:
> > On Fri, Oct 15, 2021, Brijesh Singh wrote:
> > > 
> > > On 10/13/21 1:16 PM, Sean Christopherson wrote:
> > > > On Wed, Oct 13, 2021, Sean Christopherson wrote:
> > > >> On Fri, Aug 20, 2021, Brijesh Singh wrote:
> > > >>> When SEV-SNP is enabled in the guest VM, the guest memory pages can
> > > >>> either be a private or shared. A write from the hypervisor goes through
> > > >>> the RMP checks. If hardware sees that hypervisor is attempting to write
> > > >>> to a guest private page, then it triggers an RMP violation #PF.
> > > >>>
> > > >>> To avoid the RMP violation, add post_{map,unmap}_gfn() ops that can be
> > > >>> used to verify that its safe to map a given guest page. Use the SRCU to
> > > >>> protect against the page state change for existing mapped pages.
> > > >> SRCU isn't protecting anything.  The synchronize_srcu_expedited() in the PSC code
> > > >> forces it to wait for existing maps to go away, but it doesn't prevent new maps
> > > >> from being created while the actual RMP updates are in-flight.  Most telling is
> > > >> that the RMP updates happen _after_ the synchronize_srcu_expedited() call.
> > > > Argh, another goof on my part.  Rereading prior feedback, I see that I loosely
> > > > suggested SRCU as a possible solution.  That was a bad, bad suggestion.  I think
> > > > (hope) I made it offhand without really thinking it through.  SRCU can't work in
> > > > this case, because the whole premise of Read-Copy-Update is that there can be
> > > > multiple copies of the data.  That simply can't be true for the RMP as hardware
> > > > operates on a single table.
> > > >
> > > > In the future, please don't hesitate to push back on and/or question suggestions,
> > > > especially those that are made without concrete examples, i.e. are likely off the
> > > > cuff.  My goal isn't to set you up for failure :-/
> > > 
> > > What do you think about going back to my initial proposal of per-gfn
> > > tracking [1] ? We can limit the changes to just for the kvm_vcpu_map()
> > > and let the copy_to_user() take a fault and return an error (if it
> > > attempt to write to guest private). If PSC happen while lock is held
> > > then simplify return and let the guest retry PSC.
> > 
> > That approach is also broken as it doesn't hold a lock when updating host_write_track,
> > e.g. the count can be corrupted if writers collide, and nothing blocks writers on
> > in-progress readers.
> > 
> > I'm not opposed to a scheme that blocks PSC while KVM is reading, but I don't want
> > to spend time iterating on the KVM case until consensus has been reached on how
> > exactly RMP updates will be handled, and in general how the kernel will manage
> > guest private memory.
> 
> Hi Sean,
> 
> (Sorry in advance for the long read, but it touches on a couple
> inter-tangled topics that I think are important for this series.)
> 
> While we do still remain committed to working with community toward
> implementing a UPM solution, we would still like to have a 'complete'
> solution in the meantime, if at the very least to use as a basis for
> building out other parts of the stack, or for enabling early adopters
> downstream doing the same.
> 
> Toward that end, there are a couple areas that need to be addressed,
> (and remain unaddressed with v6, since we were planning to leverage UPM
> to handle them and so left them as open TODOs at the time):
> 
>  1) this issue of guarding against shared->private conversions for pages
>     that are in-use by kernel
>  2) how to deal with unmapping/splitting the direct map
> 
> (These 2 things end up being fairly tightly coupled, which is why I'm
> trying to cover them both in this email. Will explain more in a bit)
> 
> You mentioned elsewhere how 1) would be nicely addressed with UPM, since
> the conversion would only point the guest to an entirely new page, while
> leaving the shared page intact (at least until the normal notifiers do
> their thing in response to any subsequent discard operations from
> userspace). If the guest breaks because it doesn't see the write, that's
> okay, because it's not supposed to be switching in-use shared pages to
> private while they are being used. (though the pKVM folks did note in v7
> of private memslot patches that they actually use the same physical page
> for both shared/private, so I'm not sure if that approach will still
> stack up in that context, if it ends up being needed there)
> 
> So in the context of this interim solution, we're trying to look for a
> solution that's simple enough that it can be used reliably, without
> introducing too much additional complexity into KVM. There is one
> approach that seems to fit that bill, that Brijesh attempted in an
> earlier version of this series (I'm not sure what exactly was the
> catalyst to changing the approach, as I wasn't really in the loop at
> the time, but AIUI there weren't any showstoppers there, but please
> correct me if I'm missing anything):
> 
>  - if the host is writing to a page that it thinks is supposed to be
>    shared, and the guest switches it to private, we get an RMP fault
>    (actually, we will get a !PRESENT fault, since as of v5 we now
>    remove the mapping from the directmap as part of conversion)
>  - in the host #PF handler, if we see that the page is marked private
>    in the RMP table, simply switch it back to shared
>  - if this was a bug on the part of the host, then the guest will see
>    the validated bit was cleared, and get a #VC where it can
>    terminate accordingly
>  - if this was a bug (or maliciousness) on the part of the guest,
>    then the behavior is unexpected anyway, and it will be made
>    aware this by the same mechanism
> 
> We've done some testing with this approach and it seems to hold up,
> but since we also need the handler to deal with the !PRESENT case
> (because of the current approach of nuking directmap entry for
> private pages), there's a situation that can't be easily resolved
> with this approach:
> 
>   # CASE1: recoverable
>   
>     THREAD 1              THREAD 2
>     - #PF(!PRESENT)       - #PF(!PRESENT)
>     - restore directmap
>     - RMPUPDATE(shared)
>                           - not private? okay to retry since maybe it was
>                             fixed up already
>   
>   # CASE2: unrecoverable
>   
>     THREAD 1
>     - broken kernel breaks directmap/init-mm, not related to SEV
>     - #PF(!PRESENT)
>     - not private? we should oops, since retrying might cause a loop
>   
> The reason we can't distinguish between recoverable/unrecoverable is
> because the kernel #PF handling here needs to happen for both !PRESENT
> and for RMP violations. This is due to how we unmap from directmap as
> part of shared->private conversion.
> 
> So we have to take the pessimistic approach due to CASE2, which
> means that if CASE1 pops up, we'll still have a case where guest can
> cause a crash/loop.
> 
> That where 2) comes into play. If we go back to the original approach
> (as of v4) of simply splitting the directmap when we do shared->private
> conversions, then we can limit the #PF handling to only have to deal
> with cases where there's an RMP violation and X86_PF_RMP is set, which
> makes it safe to retry to handle spurious cases like case #1.
> 
> AIUI, this is still sort of an open question, but you noted how nuking
> the directmap without any formalized interface for letting the kernel
> know about it could be problematic down the road, which also sounds
> like the sort of thing more suited for having UPM address at a more
> general level, since there are similar requirements for TDX as well.
> 
> AIUI there are 2 main arguments against splitting the directmap:
>  a) we can't easily rebuild it atm
>  b) things like KSM might still tries to access private pages
> 
> But unmapping also suffers from a), since we still end up splitting the
> directmap unless we remove pages in blocks of 2M. But nothing prevents
> a guest from switching a single 4K page to private, in which case we
> are forced to split. That would be normal behavior on the part of the
> guest for setting up GHCB pages/etc, so we still end up splitting the
> directmap over time.

One more thing to note here, is with the splitting approach, we also
have the option of doing all the splitting when the region is registered
via KVM_MEMORY_ENCRYPT_REG_REGION. If unsplitting becomes possible in
the future, we could then handle that in KVM_MEMORY_ENCRYPT_UNREG_REGION
all at once which, where we'd have a bit more flexibility for going
about that.

-Mike

> 
> And for b), as you noted, this is already something that SEV/SEV-ES
> need to deal with, and at least in the case of SNP guest things are
> a bit better since:
> 
>   -  if some kernel thread tried to write to private memory, they
>      would notice if some errant kernel thread tried to write to guest
>      memory, since #PF handler with flip the page and unset the
>      validated bit on that memory.
> 
>   - for reads, they will get ciphertext, which isn't any worse than
>     reading unencrypted guest memory for anything outside of KVM that
>     specifically knows what it is expecting to read there (KSM being
>     one exception, since it'll waste cycles cmp'ing ciphertext, but
>     there's no way to make it work anyway, and we would be fine with
>     requiring it to be disabled if that is a concern)
> 
> So that's sort of the context for why we're considering these 2 changes.
> Any input on these is welcome, but at the very least wanted to provide
> our rationale for past reviewers.
> 
> Thanks!
> 
> -Mike
