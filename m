Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB69A2EC685
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 00:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbhAFXHA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 18:07:00 -0500
Received: from mail-dm6nam10on2060.outbound.protection.outlook.com ([40.107.93.60]:13281
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725788AbhAFXG7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 18:06:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EKHX3LOkLpajg6HpZ6L4yL+efrm03wHDnYbb4MZocmasAkaMKJmm7YiR3Wj0bwZ6QzczqThqugK7PqdOGQDJ3UJVqH/InZ/sGueRyitU/Z4UPuK71dofqdwCX7Kve3E/5KbtpyAdz1KJRguWXduld9hedtAf8OiLHktNRfZzgMYNdSRGtKGX2624xtXw8x6CJqiQkrw/R1Yixe9o+FvwqJmfV6BZE2cl7deAT5ncOWyrNFAo0NhKmE6yWSxm4mjjCIcCaW+49NdINOfDnPxoKY/smFIAFMNkhcoK3Kea7ipgztrKOqgaXG1eobAKd56QDAo+wsv6A1AwCNua+gkLMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qLQ5F5F26rlsYGZV+vI9WjutvLEUadW0gBGLvdvZ5BU=;
 b=l8PtAWljKkPs52SVbqeBtymKcSPOl8XBVJeiQmY1uxRNNjzm0waeZLWgYble7sKVETa1eGAdTppwowGm0ngMh9izmIp9wlzu0n9qouYHqqZJ0HZeHmUfu4ayam5XqwMDVsgx3PnhkIZxWePHFyy0/PZtkeAIN3jZeGNN7R7fjnUNCLwdhP584PslFhu8+dehfBmXLS8oeXmal9DLZF9mcFzbWlq2C23cnnLtpVTf9J8mEN2cSBnyX1mUKevtBbVmvz1tmgVY4LO2MR0vtQGeZGOD7woqBLOJOS90MpBx73i1ZoihG9zVs60daXBQxY7sW6tGHA3GZTP27uSwevWEFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qLQ5F5F26rlsYGZV+vI9WjutvLEUadW0gBGLvdvZ5BU=;
 b=ZGKzvfMxqawG63JtLqC/8svdUXdAw7LpEm5jMlpQ5DI0v1cHI/xJs8Flyr7jw3Gl/8PnMK7aAaH8m4sW383qMzOOguBp8DbPEMotiwQLz4UuGvB80K3bnhuiAKrT8b2Mffl5flfGqsqD3IDrIpQTEytuqn3uKb00iRTB35puvwk=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2541.namprd12.prod.outlook.com (2603:10b6:802:24::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.23; Wed, 6 Jan
 2021 23:06:03 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::209d:4e20:fc9e:a726]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::209d:4e20:fc9e:a726%6]) with mapi id 15.20.3742.006; Wed, 6 Jan 2021
 23:06:02 +0000
Date:   Wed, 6 Jan 2021 23:05:55 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        Steve Rutherford <srutherford@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "dovmurik@linux.vnet.ibm.com" <dovmurik@linux.vnet.ibm.com>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "frankeh@us.ibm.com" <frankeh@us.ibm.com>
Subject: Re: [PATCH v2 1/9] KVM: x86: Add AMD SEV specific Hypercall3
Message-ID: <20210106230555.GA13999@ashkalra_ubuntu_server>
References: <X8gyhCsEMf8QU9H/@google.com>
 <d63529ce-d613-9f83-6cfc-012a8b333e38@redhat.com>
 <X86Tlin14Ct38zDt@google.com>
 <CABayD+esy0yeKi9W3wQw+ou4y4840LPCwd-PHhN1J6Uh_fvSjA@mail.gmail.com>
 <765f86ae-7c68-6722-c6e0-c6150ce69e59@amd.com>
 <20201211225542.GA30409@ashkalra_ubuntu_server>
 <20201212045603.GA27415@ashkalra_ubuntu_server>
 <20201218193956.GJ2956@work-vm>
 <E79E09A2-F314-4B59-B7AE-07B1D422DF2B@amd.com>
 <20201218195641.GL2956@work-vm>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201218195641.GL2956@work-vm>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR19CA0051.namprd19.prod.outlook.com
 (2603:10b6:3:116::13) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by DM5PR19CA0051.namprd19.prod.outlook.com (2603:10b6:3:116::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Wed, 6 Jan 2021 23:06:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 96b2bc74-a863-4b69-d653-08d8b297a3ab
X-MS-TrafficTypeDiagnostic: SN1PR12MB2541:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2541701678BD3A6A6379EEE18ED00@SN1PR12MB2541.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lritDJQMpBgNZKe30iAgnZhnWDLLyCQuDfvmfONJHEBQbrERtm9L4UAh3ll9+sMLDsxPSOqJcznnaOkTblnnnKuq5W2+70bczg4C9z1nWCnkjUJ5iwCtVk1mo/PerngmtYeVUQ1Z/2eH2XmHDj28qs79/aDhlwh1+sRuyy8nikhFMf2cFnzof8HNAW5eq8PMHwKEKAU9jq0Gprgzk7S+akX6nAaPKCgCIZLoi2x01ga7QwxHW/koXQ/Xp+Zq4rUgEReelrcH8y4cv+uahPv875nudWvo1pobwpL769U82Gxn4WC/ArT74t6FPR5JD6gN63urAg9GqlKnXP1X+6EvucJeQvXchd3tTyBpE+YihQWWzzmK306UHd6+Oldva/Hj0HCuczzsPxyOCDJeIMqoMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(44832011)(6496006)(8936002)(4326008)(478600001)(33656002)(956004)(54906003)(33716001)(1076003)(7416002)(2906002)(30864003)(316002)(8676002)(6916009)(66946007)(53546011)(186003)(16526019)(86362001)(5660300002)(66476007)(55016002)(83380400001)(66556008)(9686003)(6666004)(26005)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VE5oYUZZQnJrU2pYMlJzMFpIVnQzbjFRbFVGdWNYODFGWDRQMjJsNFJiaHcy?=
 =?utf-8?B?bjdCUzZFbTJVRUd5UHAxWko0emJZaFBrTGEraVZmbERqQkNGUGJ4TTVGd2ky?=
 =?utf-8?B?MHVKbklLRkpsSnJXRGwvQzY5ejd4RTBPdS8zQThMckhaMlR0Y0lVOWFYQWFm?=
 =?utf-8?B?Z0VBL0UwRlNxeHBkZ2NTVWZqdFlmTnZNemR1Z2VtUnExSUJNalM5QnFSWW1j?=
 =?utf-8?B?K1ZTVklXU1BVOTcvNlU4Z01vUHg0dy9wYk5WK1V2TGhmaDZoamlmR3owYzBw?=
 =?utf-8?B?UjMzYVZ5anlCV1hkOE5qcGsrMWI2bTNJWXdrYzhZMXFUUUlPYUxycmY1d3Rx?=
 =?utf-8?B?N1V4RjJLZjhlZlkxUUxVeEJpa25sa24rQ1VrTVZWU0NFOWczZ0RhNnR6OEs3?=
 =?utf-8?B?SXQxQU9QNXlRbVZZZmVIa2RmNU5iOVNoVmw5cXA4aVZ2cWl2amZhVE9vQTRO?=
 =?utf-8?B?TzlnaE1WaHFKd0NERkRFL1NGV1ZwYTRoMjFIRVUrYnNRR1VYeWR3OEZVazdp?=
 =?utf-8?B?ZDNNQjBGWTU2MkpqR09BVjh2bDZ3YjBPM3BYMzZuNWFxYUlGendmUGcxUHRz?=
 =?utf-8?B?NTRqZVNsdzRXT2Z0OTZIMlRYOU1Qa00yRjBkZSsxdXJta21aQ2JvRHRRM3o4?=
 =?utf-8?B?SWZ5UUdaZXlPMkZKeHA4WUtsOXIvMGpoRkkwdWJ5bmZFMDRzVVU3djloYmE0?=
 =?utf-8?B?M1hVOFBSeU8zMTZYSnZaaGtQSTgxUC9na0RMeWEvb0xFT3d2MS9xaWlsVW9K?=
 =?utf-8?B?c3UyNmxkWDU0WFB5S3lPRjN2UDFhQ0xmSFcveXZFZVBRcTI3eFRZN0FFNnhR?=
 =?utf-8?B?UFNFbHJFZS9kMmsyZU41eStNdEhEM0RJRko0VkpqQ0t0S1FzNlk4YlFUTUJ2?=
 =?utf-8?B?Qjl2eU9rWGlxNlZGbUlnOG9YUDJNb2g1a0pqcjNudTI3SzNvUitWTjlac2U0?=
 =?utf-8?B?Vll3cVduYXhSRE44RlZycW5DM3VFQWJQNmR5VmhMc0Voc25LNGoybWthdVVQ?=
 =?utf-8?B?cWJVWkcwVVJqbmhHWE9HWGJBMDB4S2E5WmlOQkVmdXlMTEtvb1U4OUdpUm5X?=
 =?utf-8?B?am1RT3NqaDZrTEUwMzhvVHNhME1XN0Z3eTd6TkJxNStQM0svUEIvWHFJZmYx?=
 =?utf-8?B?SFgvSURJN0pqYXExVHhONVgwYXc5OGk4NERpbjNoZ2VoUlluQjZPSkpZejVn?=
 =?utf-8?B?bUNaNlJYOWQyTGg1QTNCUGJyb295UnZaMyttL2xtNkkxUnRlVityTlYrb2pu?=
 =?utf-8?B?UjRHcHd0NmxFNHNFRXVGYXBiVFZmRVhqam0xN0tqWExwNFE0UjZNUGQyZ1JX?=
 =?utf-8?Q?Nh2HZipdtvMi1a+X5vYw+HIvHs46mQ0bNm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2021 23:06:02.6889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 96b2bc74-a863-4b69-d653-08d8b297a3ab
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y2P9z2EMoGCXelRmcdPuWoXufvKi0WmqsQs/9NUb6stH63S9m08d7Iq6d/lsaaeL+2tV5IS19PAHnTWaVC4VsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2541
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 18, 2020 at 07:56:41PM +0000, Dr. David Alan Gilbert wrote:
> * Kalra, Ashish (Ashish.Kalra@amd.com) wrote:
> > Hello Dave,
> > 
> > On Dec 18, 2020, at 1:40 PM, Dr. David Alan Gilbert <dgilbert@redhat.com> wrote:
> > 
> > ﻿* Ashish Kalra (ashish.kalra@amd.com) wrote:
> > On Fri, Dec 11, 2020 at 10:55:42PM +0000, Ashish Kalra wrote:
> > Hello All,
> > 
> > On Tue, Dec 08, 2020 at 10:29:05AM -0600, Brijesh Singh wrote:
> > 
> > On 12/7/20 9:09 PM, Steve Rutherford wrote:
> > On Mon, Dec 7, 2020 at 12:42 PM Sean Christopherson <seanjc@google.com> wrote:
> > On Sun, Dec 06, 2020, Paolo Bonzini wrote:
> > On 03/12/20 01:34, Sean Christopherson wrote:
> > On Tue, Dec 01, 2020, Ashish Kalra wrote:
> > From: Brijesh Singh <brijesh.singh@amd.com>
> > 
> > KVM hypercall framework relies on alternative framework to patch the
> > VMCALL -> VMMCALL on AMD platform. If a hypercall is made before
> > apply_alternative() is called then it defaults to VMCALL. The approach
> > works fine on non SEV guest. A VMCALL would causes #UD, and hypervisor
> > will be able to decode the instruction and do the right things. But
> > when SEV is active, guest memory is encrypted with guest key and
> > hypervisor will not be able to decode the instruction bytes.
> > 
> > Add SEV specific hypercall3, it unconditionally uses VMMCALL. The hypercall
> > will be used by the SEV guest to notify encrypted pages to the hypervisor.
> > What if we invert KVM_HYPERCALL and X86_FEATURE_VMMCALL to default to VMMCALL
> > and opt into VMCALL?  It's a synthetic feature flag either way, and I don't
> > think there are any existing KVM hypercalls that happen before alternatives are
> > patched, i.e. it'll be a nop for sane kernel builds.
> > 
> > I'm also skeptical that a KVM specific hypercall is the right approach for the
> > encryption behavior, but I'll take that up in the patches later in the series.
> > Do you think that it's the guest that should "donate" memory for the bitmap
> > instead?
> > No.  Two things I'd like to explore:
> > 
> >  1. Making the hypercall to announce/request private vs. shared common across
> >     hypervisors (KVM, Hyper-V, VMware, etc...) and technologies (SEV-* and TDX).
> >     I'm concerned that we'll end up with multiple hypercalls that do more or
> >     less the same thing, e.g. KVM+SEV, Hyper-V+SEV, TDX, etc...  Maybe it's a
> >     pipe dream, but I'd like to at least explore options before shoving in KVM-
> >     only hypercalls.
> > 
> > 
> >  2. Tracking shared memory via a list of ranges instead of a using bitmap to
> >     track all of guest memory.  For most use cases, the vast majority of guest
> >     memory will be private, most ranges will be 2mb+, and conversions between
> >     private and shared will be uncommon events, i.e. the overhead to walk and
> >     split/merge list entries is hopefully not a big concern.  I suspect a list
> >     would consume far less memory, hopefully without impacting performance.
> > For a fancier data structure, I'd suggest an interval tree. Linux
> > already has an rbtree-based interval tree implementation, which would
> > likely work, and would probably assuage any performance concerns.
> > 
> > Something like this would not be worth doing unless most of the shared
> > pages were physically contiguous. A sample Ubuntu 20.04 VM on GCP had
> > 60ish discontiguous shared regions. This is by no means a thorough
> > search, but it's suggestive. If this is typical, then the bitmap would
> > be far less efficient than most any interval-based data structure.
> > 
> > You'd have to allow userspace to upper bound the number of intervals
> > (similar to the maximum bitmap size), to prevent host OOMs due to
> > malicious guests. There's something nice about the guest donating
> > memory for this, since that would eliminate the OOM risk.
> > 
> > 
> > Tracking the list of ranges may not be bad idea, especially if we use
> > the some kind of rbtree-based data structure to update the ranges. It
> > will certainly be better than bitmap which grows based on the guest
> > memory size and as you guys see in the practice most of the pages will
> > be guest private. I am not sure if guest donating a memory will cover
> > all the cases, e.g what if we do a memory hotplug (increase the guest
> > ram from 2GB to 64GB), will donated memory range will be enough to store
> > the metadata.
> > 
> > .
> > 
> > With reference to internal discussions regarding the above, i am going
> > to look into specific items as listed below :
> > 
> > 1). "hypercall" related :
> > a). Explore the SEV-SNP page change request structure (included in GHCB),
> > see if there is something common there than can be re-used for SEV/SEV-ES
> > page encryption status hypercalls.
> > b). Explore if there is any common hypercall framework i can use in
> > Linux/KVM.
> > 
> > 2). related to the "backing" data structure - explore using a range-based
> > list or something like rbtree-based interval tree data structure
> > (as mentioned by Steve above) to replace the current bitmap based
> > implementation.
> > 
> > 
> > 
> > I do agree that a range-based list or an interval tree data structure is a
> > really good "logical" fit for the guest page encryption status tracking.
> > 
> > We can only keep track of the guest unencrypted shared pages in the
> > range(s) list (which will keep the data structure quite compact) and all
> > the guest private/encrypted memory does not really need any tracking in
> > the list, anything not in the list will be encrypted/private.
> > 
> > Also looking at a more "practical" use case, here is the current log of
> > page encryption status hypercalls when booting a linux guest :
> > 
> > ...
> > 
> > <snip>
> > 
> > [   56.146336] page_enc_status_hc invoked, gpa = 1f018000, npages  = 1, enc = 1
> > [   56.146351] page_enc_status_hc invoked, gpa = 1f00e000, npages  = 1, enc = 0
> > [   56.147261] page_enc_status_hc invoked, gpa = 1f00e000, npages  = 1, enc = 0
> > [   56.147271] page_enc_status_hc invoked, gpa = 1f018000, npages  = 1, enc = 0
> > ....
> > 
> > [   56.180730] page_enc_status_hc invoked, gpa = 1f008000, npages  = 1, enc = 0
> > [   56.180741] page_enc_status_hc invoked, gpa = 1f006000, npages  = 1, enc = 0
> > [   56.180768] page_enc_status_hc invoked, gpa = 1f008000, npages  = 1, enc = 1
> > [   56.180782] page_enc_status_hc invoked, gpa = 1f006000, npages  = 1, enc = 1
> > 
> > ....
> > [   56.197110] page_enc_status_hc invoked, gpa = 1f007000, npages  = 1, enc = 0
> > [   56.197120] page_enc_status_hc invoked, gpa = 1f005000, npages  = 1, enc = 0
> > [   56.197136] page_enc_status_hc invoked, gpa = 1f007000, npages  = 1, enc = 1
> > [   56.197148] page_enc_status_hc invoked, gpa = 1f005000, npages  = 1, enc = 1
> > ....
> > 
> > [   56.222679] page_enc_status_hc invoked, gpa = 1e83b000, npages  = 1, enc = 0
> > [   56.222691] page_enc_status_hc invoked, gpa = 1e839000, npages  = 1, enc = 0
> > [   56.222707] page_enc_status_hc invoked, gpa = 1e83b000, npages  = 1, enc = 1
> > [   56.222720] page_enc_status_hc invoked, gpa = 1e839000, npages  = 1, enc = 1
> > ....
> > 
> > [   56.313747] page_enc_status_hc invoked, gpa = 1e5eb000, npages  = 1, enc = 0
> > [   56.313771] page_enc_status_hc invoked, gpa = 1e5e9000, npages  = 1, enc = 0
> > [   56.313789] page_enc_status_hc invoked, gpa = 1e5eb000, npages  = 1, enc = 1
> > [   56.313803] page_enc_status_hc invoked, gpa = 1e5e9000, npages  = 1, enc = 1
> > ....
> > [   56.459276] page_enc_status_hc invoked, gpa = 1d767000, npages  = 100, enc = 0
> > [   56.459428] page_enc_status_hc invoked, gpa = 1e501000, npages  = 1, enc = 1
> > [   56.460037] page_enc_status_hc invoked, gpa = 1d767000, npages  = 100, enc = 1
> > [   56.460216] page_enc_status_hc invoked, gpa = 1e501000, npages  = 1, enc = 0
> > [   56.460299] page_enc_status_hc invoked, gpa = 1d767000, npages  = 100, enc = 0
> > [   56.460448] page_enc_status_hc invoked, gpa = 1e501000, npages  = 1, enc = 1
> > ....
> > 
> > As can be observed here, all guest MMIO ranges are initially setup as
> > shared, and those are all contigious guest page ranges.
> > 
> > After that the encryption status hypercalls are invoked when DMA gets
> > triggered during disk i/o while booting the guest ... here again the
> > guest page ranges are contigious, though mostly single page is touched
> > and a lot of page re-use is observed.
> > 
> > So a range-based list/structure will be a "good" fit for such usage
> > scenarios.
> > 
> > It seems surprisingly common to flick the same pages back and forth between
> > encrypted and clear for quite a while;  why is this?
> > 
> > 
> > dma_alloc_coherent()'s will allocate pages and then call
> > set_decrypted() on them and then at dma_free_coherent(), set_encrypted()
> > is called on the pages to be freed. So these observations in the logs
> > where a lot of single 4K pages are seeing C-bit transitions and
> > corresponding hypercalls are the ones associated with
> > dma_alloc_coherent().
> 
> It makes me wonder if it might be worth teaching it to hold onto those
> DMA pages somewhere until it needs them for something else and avoid the
> extra hypercalls; just something to think about.
> 
> Dave

Following up on this discussion and looking at the hypercall logs and DMA usage scenarios on the SEV, I have the following additional observations and comments :

It is mostly the Guest MMIO regions setup as un-encrypted by uefi/edk2 initially, which will be the "static" nodes in the backing data structure for page encryption status. 
These will be like 15-20 nodes/entries.

Drivers doing DMA allocations using GFP_ATOMIC will be fetching DMA buffers from the pre-allocated unencrypted atomic pool, hence it will be a "static" node added at kernel startup.

As we see with the logs, almost all runtime C-bit transitions and corresponding hypercalls will be from DMA I/O and dma_alloc_coherent/dma_free_coherent calls, these will be 
using 4K/single pages and mostly fragmented ranges, so if we use a "rbtree" based interval tree then there will be a lot of tree insertions and deletions 
(dma_alloc_coherent followed with a dma_free_coherent), so this will lead to a lot of expensive tree rotations and re-balancing, compared to much less complex 
and faster linked list node insertions and deletions (if we use a list based structure to represent these interval ranges).

Also as the static nodes in the structure will be quite limited (all the above DMA I/O added ranges will simply be inserted and removed), so a linked list lookup 
won't be too expensive compared to a tree lookup. In other words, this be a fixed size list.

Looking at the above, I am now more inclined to use a list based structure to represent the page encryption status.

Looking fwd. to any comments/feedback/thoughts on the above.

Thanks,
Ashish

