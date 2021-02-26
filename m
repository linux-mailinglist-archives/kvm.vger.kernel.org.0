Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67CC93263BD
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 15:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhBZOFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 09:05:41 -0500
Received: from mail-bn7nam10on2078.outbound.protection.outlook.com ([40.107.92.78]:44544
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230128AbhBZOFa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 09:05:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HD3UAQLiGbpW89zpg0+oMf7tHru+sqRjaJJghizSSHNUJRUsQhGTlXzmtbVUD7PLvOzFR6SC1be7hWtQY8sxhHkAU7BZ2sJ+vBE2iC2iiool0KQ2cp8ivCYB9HPsGnFy+XUS5I3PhvKiTYdHM8Wi7Pbpk7v0YidiYrO9M5HZD1Vwtqyrln9tzpeVt1ovovNNzU2IZsNiRqZ40qDS0JB9qdMbnl7SV1Z9e8laJgnxol9mgIW4ntykbQWzDfRexKXOemOn9cnfkb6p6HWFZK+x50xl6v7lz6XZ9uXwrmueJrZlCqwDYmgczSLQiZE+UpCJ98WNsfRTrvREOpWIbZSiCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hjgln23smrmkPBbAED41Otoi5rR6eSKoQEUa2IC28v0=;
 b=TFh4SxoObqd0od+rY/FKCPML+gwGfvM8K57ZkeYYWKtWLB63ltKzoO+6QgaHN7G4HDt2rNC7WajipnVxaxp1XKN56sfD9O/BvSIGzkMC0JvQHYO93oe7Vw8EAdQsy9J8WnQJv5U6680dMS0Ul24FY4JTSJvGgp/Iukfau2RMRpPa3xiwxqPpf3yjYRpU4CePa+p2KLfhojPENzJEa2jsf4FQSrWC0OQIURTXLoN9Zq1OZYy2Bjh/09Jtu4l70QQE7h1FgxGhYlB5GxXUAsepnKgRXWc4tI59No1AgzhkAx/daCFTVclrlZQ7u+H2bLntFGNNn9KB95g4drJ5UMNKvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hjgln23smrmkPBbAED41Otoi5rR6eSKoQEUa2IC28v0=;
 b=uIRfD1tuwQCBcXzsFiQnWc7Hvp84An543BRvjjk+Gk5YrITCJAuuoVrVJBNZi+c1HJA6NlVa0Gqbogv2mPxxuf4QkVPcyTKc+Mzq8CNnyIEZ2ToXLVBQPeGZfh8mhP7FYQ0iCxO5GEoEkFYMF4/ZiU4h8Pcr9PdsfjMxV6NgjIs=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4512.namprd12.prod.outlook.com (2603:10b6:806:71::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Fri, 26 Feb
 2021 14:04:35 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3890.020; Fri, 26 Feb 2021
 14:04:34 +0000
Date:   Fri, 26 Feb 2021 14:04:32 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Steve Rutherford <srutherford@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>, "bp@suse.de" <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "venu.busireddy@oracle.com" <venu.busireddy@oracle.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>
Subject: Re: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST
 ioctl
Message-ID: <20210226140432.GB5950@ashkalra_ubuntu_server>
References: <cover.1612398155.git.ashish.kalra@amd.com>
 <7266edd714add8ec9d7f63eddfc9bbd4d789c213.1612398155.git.ashish.kalra@amd.com>
 <YCxrV4u98ZQtInOE@google.com>
 <SN6PR12MB27672FF8358D122EDD8CC0188E859@SN6PR12MB2767.namprd12.prod.outlook.com>
 <20210224175122.GA19661@ashkalra_ubuntu_server>
 <YDaZacLqNQ4nK/Ex@google.com>
 <20210225202008.GA5208@ashkalra_ubuntu_server>
 <CABayD+cn5e3PR6NtSWLeM_qxs6hKWtjEx=aeKpy=WC2dzPdRLw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABayD+cn5e3PR6NtSWLeM_qxs6hKWtjEx=aeKpy=WC2dzPdRLw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0401CA0028.namprd04.prod.outlook.com
 (2603:10b6:803:2a::14) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN4PR0401CA0028.namprd04.prod.outlook.com (2603:10b6:803:2a::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Fri, 26 Feb 2021 14:04:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 60fcebd4-4a88-47e3-862c-08d8da5f7241
X-MS-TrafficTypeDiagnostic: SA0PR12MB4512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4512982E90D742C492E59B8F8E9D9@SA0PR12MB4512.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y7ijaZHGBJTTm7kBe1QXZ0N2ndDSc1MRjelmF+hHGqKjDzqPhaqtUDU/eCS8zesDwCKtUUqELjUFbfHg33g6A1+NQUM/k0Bf9iYM30Bikg9EY0FqnvEc8jo0dfjFT/ke0C/p3gMyDh5QlE5WyWCBW1Nzo9W4zxhPvpFzNKO7RUYjuc9IVIB1Odw1gzwf6v3eJ22+jKkG+GwGR2rk6ESAEFsKwT0O0mVcjM7lJNHC2t/ryZPapvrmjtLo7qv3JhlZTJBedH/gjjrNj2c8vgJKxAemWrB6Ykz4e102xwil59x6Rv0Hzd7vdDTKF2e3U01mBkb+OH6E++Pd4Eatoz54CLA5ThdVAz9am9OuzZg2rWXcgd44YEPSRJtKrWfvyAXTseF1Gmg80loFreDQWvvzEhtPVCuU7ZOnblcD1o45cSm5UXLFduzGQoK9/kwDQYVsUQawRoxnJXICPpncsZVy8HC3OhR7hVXz2JZsh05iE6C4Rp8455ICmcbnNewLNY+GiNn69KZXttFU4h+747uzvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(66946007)(66556008)(66476007)(83380400001)(26005)(16526019)(4326008)(6916009)(316002)(52116002)(7416002)(186003)(53546011)(9686003)(6496006)(478600001)(55016002)(33716001)(86362001)(5660300002)(1076003)(44832011)(8936002)(956004)(8676002)(2906002)(54906003)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ab9DagM9dl1nyCHjQp0EO2dusGMgyGt1AtBljta+xcFxWcWeDAG04L5PlDcO?=
 =?us-ascii?Q?ENC9/7Sca9p8t/EKfH4mZEcv/duzG4I9d/Vt68HUTXL7Jatplu0qlcOzoGoP?=
 =?us-ascii?Q?btG1XFIB0cSCdtTcRCDVXNdhPcKPzQlawK0s+XNSfThDPv7GU4NEHNYA7NW2?=
 =?us-ascii?Q?KfWeC+SUGUNTMmmpScKMT1CvXH15ak9+tKPD5Kc1evrjTqHJKupSUbb12tRa?=
 =?us-ascii?Q?r58GrLN0vW/h4oRxbCZI+IAndmuhVXPaepF6OiQLnglA+48jVamzecTARDUv?=
 =?us-ascii?Q?9BVnVEKeyPGiBZLvdeosIFIAFclGaZutTfSlgoLZDIs3drzylkDpofpx+xgl?=
 =?us-ascii?Q?aSB5AFKQrHTOUgYiSQqpke8dz15zme/9akEdjGzA7T17uwLA4M8oTyWgpiA6?=
 =?us-ascii?Q?sl0H5uxHg7UJttPUGoZFYQsRTgfKjofM9zPuOEKdC5ulitXjXaa4NTAfuKqu?=
 =?us-ascii?Q?zBAcmmZFH3QNP7Si9c9nfbmgmPD25LzTZtsn9TGM6KVZsQzvgucZWy+NrVTa?=
 =?us-ascii?Q?udP8u7kJHWcpm00Td8jHbEWsKlHV8aOownS1xw/G+kCj6VdMMqcHagJJuxPu?=
 =?us-ascii?Q?DSbvZFmtBerjtbq0yTdS32q19juN4ZErUYrP8HqEAYc0bJe40mNSXcr50//o?=
 =?us-ascii?Q?PPlIOQu/GKbuVT22NRq6OEj39MCojvSbziYYgOnWFVrRoP9jEXRsKkuRMAdi?=
 =?us-ascii?Q?oUhV2v0+StxS4iYJ+2LjENwJEoVqAfFeUR9yNfooIhrdrtsOiVJBf41tBoh8?=
 =?us-ascii?Q?uHppu7DirjApezVM+FqyUoQmV/MI6PveKxLgpoMj+QuHstKs4rRWD68BHYYF?=
 =?us-ascii?Q?c5EuYKizqcXGFDfnSRjHQSanSWLarhnhfwnvEUEIgONry9SDsLtpWz2VMQrT?=
 =?us-ascii?Q?voTMAADn5gfSWxLvx02J0LJk5aViYKqYZX1eFgz/mQM7YzbuQmXRqB5pwqDm?=
 =?us-ascii?Q?KUVm8Eg4aiZ7HX7OJVY0jlHEszS6HtEjLTd4+FBBHl16Oqtp0MqlZsIhj+Rl?=
 =?us-ascii?Q?s7Nukhtn4Gv7bep4v2Q4D3o6qP1vgX7m73mAgJyyeteo1ShflkY6kLhGcSxB?=
 =?us-ascii?Q?r1mU7sEDgTKfCwrd+X/vq4qeF/pKumf6aPkqvJIsKRwYtA/nqXjAaNgTP5EK?=
 =?us-ascii?Q?4mB7wOOMXa1f7fMmNawA6yLttERSiStpuxXC0egVcqHuxZqVbkR7TDdIK+qo?=
 =?us-ascii?Q?FEheEzKsmwIz4EqdJwtlsbGhfTuOWLZL9VmbwaJE7Ks5/OheyuP8G9f6pAyr?=
 =?us-ascii?Q?Gzp93r7p4iPrNXg3UV0OFSL7ne105yVXsFMuZCYK3TFMsVqnrgQK3LTWFULv?=
 =?us-ascii?Q?asq5lAMsQOd76sARE3YBqjJF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60fcebd4-4a88-47e3-862c-08d8da5f7241
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2021 14:04:34.9088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: scXOahJXqLf2SvQH9cwpI//zvERPbwODCaCuZrHJa43jU0mprGl52U1fiDCFTeNORdS8d7ICr79czKINFZ9/0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4512
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Steve,

On Thu, Feb 25, 2021 at 02:59:27PM -0800, Steve Rutherford wrote:
> On Thu, Feb 25, 2021 at 12:20 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> >
> > On Wed, Feb 24, 2021 at 10:22:33AM -0800, Sean Christopherson wrote:
> > > On Wed, Feb 24, 2021, Ashish Kalra wrote:
> > > > # Samples: 19K of event 'kvm:kvm_hypercall'
> > > > # Event count (approx.): 19573
> > > > #
> > > > # Overhead  Command          Shared Object     Symbol
> > > > # ........  ...............  ................  .........................
> > > > #
> > > >    100.00%  qemu-system-x86  [kernel.vmlinux]  [k] kvm_emulate_hypercall
> > > >
> > > > Out of these 19573 hypercalls, # of page encryption status hcalls are 19479,
> > > > so almost all hypercalls here are page encryption status hypercalls.
> > >
> > > Oof.
> > >
> > > > The above data indicates that there will be ~2% more Heavyweight VMEXITs
> > > > during SEV guest boot if we do page encryption status hypercalls
> > > > pass-through to host userspace.
> > > >
> > > > But, then Brijesh pointed out to me and highlighted that currently
> > > > OVMF is doing lot of VMEXITs because they don't use the DMA pool to minimize the C-bit toggles,
> > > > in other words, OVMF bounce buffer does page state change on every DMA allocate and free.
> > > >
> > > > So here is the performance analysis after kernel and initrd have been
> > > > loaded into memory using grub and then starting perf just before booting the kernel.
> > > >
> > > > These are the performance #'s after kernel and initrd have been loaded into memory,
> > > > then perf is attached and kernel is booted :
> > > >
> > > > # Samples: 1M of event 'kvm:kvm_userspace_exit'
> > > > # Event count (approx.): 1081235
> > > > #
> > > > # Overhead  Trace output
> > > > # ........  ........................
> > > > #
> > > >     99.77%  reason KVM_EXIT_IO (2)
> > > >      0.23%  reason KVM_EXIT_MMIO (6)
> > > >
> > > > # Samples: 1K of event 'kvm:kvm_hypercall'
> > > > # Event count (approx.): 1279
> > > > #
> > > >
> > > > So as the above data indicates, Linux is only making ~1K hypercalls,
> > > > compared to ~18K hypercalls made by OVMF in the above use case.
> > > >
> > > > Does the above adds a prerequisite that OVMF needs to be optimized if
> > > > and before hypercall pass-through can be done ?
> > >
> > > Disclaimer: my math could be totally wrong.
> > >
> > > I doubt it's a hard requirement.  Assuming a conversative roundtrip time of 50k
> > > cycles, those 18K hypercalls will add well under a 1/2 a second of boot time.
> > > If userspace can push the roundtrip time down to 10k cycles, the overhead is
> > > more like 50 milliseconds.
> > >
> > > That being said, this does seem like a good OVMF cleanup, irrespective of this
> > > new hypercall.  I assume it's not cheap to convert a page between encrypted and
> > > decrypted.
> > >
> > > Thanks much for getting the numbers!
> >
> > Considering the above data and guest boot time latencies
> > (and potential issues with OVMF and optimizations required there),
> > do we have any consensus on whether we want to do page encryption
> > status hypercall passthrough or not ?
> >
> > Thanks,
> > Ashish
> 
> Thanks for grabbing the data!
> 
> I am fine with both paths. Sean has stated an explicit desire for
> hypercall exiting, so I think that would be the current consensus.
> 
> If we want to do hypercall exiting, this should be in a follow-up
> series where we implement something more generic, e.g. a hypercall
> exiting bitmap or hypercall exit list. If we are taking the hypercall
> exit route, we can drop the kvm side of the hypercall. Userspace could
> also handle the MSR using MSR filters (would need to confirm that).
> Then userspace could also be in control of the cpuid bit.
> 
> Essentially, I think you could drop most of the host kernel work if
> there were generic support for hypercall exiting. Then userspace would
> be responsible for all of that. Thoughts on this?
> 
So if i understand it correctly, i will submitting v11 of this patch-set
with in-kernel support for page encryption status hypercalls and shared
pages list and the userspace control of SEV live migration feature
support and fixes for MSR handling.

In subsequent follow-up patches we will add generic support for hypercall 
exiting and then drop kvm side of hypercall and also add userspace
support for MSR handling.

Thanks,
Ashish
