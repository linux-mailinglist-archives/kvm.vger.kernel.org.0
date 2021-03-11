Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24584337C43
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 19:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbhCKSPU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 13:15:20 -0500
Received: from mail-dm6nam10on2062.outbound.protection.outlook.com ([40.107.93.62]:30305
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230156AbhCKSPH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 13:15:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d8eRuWIELmdIuOBQFAQ6kWHIDi/OLL9z3y912O3fcailwXBFBzzUhVe2ASWf/1cFHFpyE6fVmvXuXZBORdq193yeV69WBECUr6DKt+dqQP/gSIZCibG2/1n6/CsbQZ9MBJpWoF2hUE+TegPYB7KWHMAXkltrI76WJAlhPl4lCOX3SoWi1HPtX+EBRtMSGrTJC0WF131lDguPE+4qKMxGQATJ4LqUW721d/3Caaso0Mzro5CR/TP4ZnL8UZn48MPF0GQXFzZkDRF5vJd8wGKXWt7vz6mbRXXgcGdPWjKdlHmf57BqOmqIr+Mhy6oGR8F0tZbSpwZiE7gVVM4qe9lkvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8iPHaLFe7yM5Dw2KQrrYNHBUoy3/gjyXnfSBpTmx/IU=;
 b=Zpp6sHBWfP6L1qzl0uVRhtwjqEGnM1KNPO8/bvgzS48wRgMDCBTc6AeJ2H2qgk2q0hhIYGos7f2fgavl4++oSUoT615jQXDoOkHsra5f3Fn43EtHnFT7op7Lf0gZ6si21gM/nW0tRK6GOcluSWnn1NER8vjk3GfSLe9o+dCXwfInG2iweqeJzi0B8vuYH7urjKZkwQTetCw+xVQmbCziEUM0psgP94V+vdW3FFrZ4CpxD9s24gvIX0hA4NspU4r/kdkAVcejDqfHHBjdQhq4+zS/ZEOakLtshtdGBrqqPz6caIO3B37ZVW6OOjmmvfrc1U8pqrx5O7Da/M+PrPT/TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8iPHaLFe7yM5Dw2KQrrYNHBUoy3/gjyXnfSBpTmx/IU=;
 b=fQvHaVUE6+PxyNVM/r9FfI76rFCbkser8tzZgXvn+0PRXAjWkMN0lidvjXALXMMpeDTq0j+Rmh7Idm5UaJVpxpDDJywsMsaI2igGA/8j+SeMGu+4TUOp2CmGS7X6sVeYTD7NbEsQidvCtaNaaHsszjMePTdVh5PzR12asDhvDSQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2768.namprd12.prod.outlook.com (2603:10b6:805:72::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.27; Thu, 11 Mar
 2021 18:15:05 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3933.031; Thu, 11 Mar 2021
 18:15:05 +0000
Date:   Thu, 11 Mar 2021 18:14:58 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Will Deacon <will@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Steve Rutherford <srutherford@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "venu.busireddy@oracle.com" <venu.busireddy@oracle.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Quentin Perret <qperret@google.com>, maz@kernel.org
Subject: Re: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST
 ioctl
Message-ID: <20210311181458.GA6650@ashkalra_ubuntu_server>
References: <YCxrV4u98ZQtInOE@google.com>
 <SN6PR12MB27672FF8358D122EDD8CC0188E859@SN6PR12MB2767.namprd12.prod.outlook.com>
 <20210224175122.GA19661@ashkalra_ubuntu_server>
 <YDaZacLqNQ4nK/Ex@google.com>
 <20210225202008.GA5208@ashkalra_ubuntu_server>
 <CABayD+cn5e3PR6NtSWLeM_qxs6hKWtjEx=aeKpy=WC2dzPdRLw@mail.gmail.com>
 <20210226140432.GB5950@ashkalra_ubuntu_server>
 <YDkzibkC7tAYbfFQ@google.com>
 <20210302145543.GA29994@ashkalra_ubuntu_server>
 <20210303185441.GA19944@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210303185441.GA19944@willie-the-truck>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN2PR01CA0019.prod.exchangelabs.com (2603:10b6:804:2::29)
 To SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN2PR01CA0019.prod.exchangelabs.com (2603:10b6:804:2::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Thu, 11 Mar 2021 18:15:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 98a53644-4149-404e-e881-08d8e4b99825
X-MS-TrafficTypeDiagnostic: SN6PR12MB2768:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2768C57364DAB07BA00A49E58E909@SN6PR12MB2768.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FkB6YMps+aRL+i64aoTgIQAN+u/tKEBsfd0BgbVI9wfSiF7I4BvfPuzGiyshh5YJbc88SILyN0hkkVbDD9kueIOc4XPm9SDSRRDg3efauOYwOzLW6/7UcKy1LxhpMSC5cHKZIjHTY7FvPe89Xpmv41J/h+vn3rbktQI/ORUHreSU5B9Xo6jpM7Kdl9uQZ64w9fdNgXUOm45n/RPNPldHUi0dDIqTOI2cu7h6PCeHlWHXD7ZKeHMCnyR24GniQic0tYJLrqeW5IvEAjFidIWxqdDy8nribR1s9Xj1oQXi7SpBOXK1kAI3wBAHcQM/R3gMlk06BiTTv7m247vUaZ0lQI/+Qr3aEfEcjvyWLnbfWZxDcmcuC3VaJR8/9I2j1i/yPB+0zB8FGNp9KXbd+JLgunoele9M2F8tausl9U1S1FAraZB5VOUp6NXhhIjMOecLVkxxdYlOS0cTKA3RfUSja7+x9t6Uj6Qq+6WwCrW0S5KwXIU2NN7Se7MtNeCHGgYQT0O+L1Jtuw1tL60aJX3dfwa38NFqzxay0nfVSDMvCSV2eYqJQuOMeFcIdr/OD9Kt6bEf8HCWgvlV4/pR+8GDUCO21HE50DBRDm9v9vBy0DM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(366004)(376002)(136003)(33656002)(966005)(54906003)(316002)(5660300002)(53546011)(86362001)(6916009)(8936002)(44832011)(9686003)(956004)(8676002)(6496006)(55016002)(45080400002)(7416002)(4326008)(52116002)(1076003)(66946007)(478600001)(6666004)(26005)(66476007)(66556008)(186003)(16526019)(33716001)(83380400001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/LWaHv88TdkU37nN4p+3i+UGaIHXSWRqbS6i5xD0IKfz3PZJNBBkr1VK6Qy8?=
 =?us-ascii?Q?DyKgR5AQvmhQMaUhuX3hXoxb6vAYGRu85V9a2vvTZI2jegtgL08z9nNb5pF9?=
 =?us-ascii?Q?ELa8OlfO4I5Om8f7MzkNy5Hq7Di4lve1JPUPZSzoMUxyPo8GnFxXQaxy5jYw?=
 =?us-ascii?Q?kH/yTzCxJ9S7ApOXQxq9Sb8m9ht+9J9MAt66WOY6YyVd0FsTK4Xwn2cXRxX3?=
 =?us-ascii?Q?jotTYxoFQGmN65VH15aIqyUr+KyMoMUYjK/SKmLAtI1wpQEkgQ3f2RrL7YD6?=
 =?us-ascii?Q?6p+aYvbp2XywQJEV6PzGexZmrH+avwMxKo7i+xS253l5Hzy7tv9t3oYGqpB4?=
 =?us-ascii?Q?vWrnCjMH6mqfDNdOpDEnCAqIzYwAtjcE2k0sIKpAmzfgqrwwFh3tpvf3uhYl?=
 =?us-ascii?Q?KIdiOzBk4DOufodmakrWmkYaqTmsfmhinZDOhGsg7vfQhmeGETsoQLbMSVEU?=
 =?us-ascii?Q?8cNSFNgjUL56ZnT+faoxj91u/pvzd2XUpQJW4oYqKerXQSFL1p3sG0VFfUZA?=
 =?us-ascii?Q?NsXKMvA0uAel0hk6N8Uj8B7gVCmPDiKAXpHjEj6yM2OS3ysMTJP7GqEYz5Iq?=
 =?us-ascii?Q?iRkAPWd0qKnc6awwaRBgoX8ELcLGvmSzk9MnVV2/R1EVu1DbC6Kf0zefJJJc?=
 =?us-ascii?Q?kLNvKQYsgYH7MR0B/24FjHzpf9VKf1ysE0CZ7dzYnUGlVw+JeNhswVr7K3Jw?=
 =?us-ascii?Q?25s0QWuvmkh9JLjHUz1RozzwAKsFyMWZQmhJSuZ7rNhzT6yFNKYux4emaPW6?=
 =?us-ascii?Q?IaaI2flAVYK25n84uba376rssSZ0GF9kMlEKp2GoyefpdJXJt3N79GQ2J9Gs?=
 =?us-ascii?Q?8EFXa2Dpq599EoXbM050EWR/OLbH4XBd7Lx9zjWm9WqpFBTNDxTYlPCl3ic3?=
 =?us-ascii?Q?xgk9cS4J8ajaTmDtFUkhTLn4IaZnCCv9Fn01KUtqLSgub9KgzUOY/QJfDfVX?=
 =?us-ascii?Q?biq02J67cIzu0LRHPX13VFk8I12PpfqdPPKGq8UQnUwkIh+zGsYEQLAkYi8O?=
 =?us-ascii?Q?n2+d79kMvyTMeHmfc8GL/TMHtg5D3XsVTZQn9HSWlsez9iKGl52+lpjoPGR2?=
 =?us-ascii?Q?7dVOkJy1WcQWVI9xKPtWfXj7U515nX49VcAOqu82cSqNW17h5/zju3w3X7OX?=
 =?us-ascii?Q?PoHq0P1KtGe4MnUjS7+6wNQT3V0Ngh1S3tkWQMdi30EzwBvpLDQTXQViYuCU?=
 =?us-ascii?Q?poQG8vlJ1A1a9l2hQqfUQBQtNOufkwpu2M+hjBoog4q3j8NMg7spq9jvG1Dm?=
 =?us-ascii?Q?t/Ai8xhMhQITWuOhvyv6AnBNkkH2elR+XifgeY1cbmYmlX1o/ehPkLn5VGeO?=
 =?us-ascii?Q?MLU3i1FZ1sMGXh2OeXySPs/4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98a53644-4149-404e-e881-08d8e4b99825
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 18:15:05.3874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 51C1AfW8JZ2TuEau3appwX1ab11zuZc2m9+YmYoN/zkb+tng7/HrhTvOhgRhjtPFsHKyUyOUgbhaMNqFTGTZjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2768
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 03, 2021 at 06:54:41PM +0000, Will Deacon wrote:
> [+Marc]
> 
> On Tue, Mar 02, 2021 at 02:55:43PM +0000, Ashish Kalra wrote:
> > On Fri, Feb 26, 2021 at 09:44:41AM -0800, Sean Christopherson wrote:
> > > On Fri, Feb 26, 2021, Ashish Kalra wrote:
> > > > On Thu, Feb 25, 2021 at 02:59:27PM -0800, Steve Rutherford wrote:
> > > > > On Thu, Feb 25, 2021 at 12:20 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> > > > > Thanks for grabbing the data!
> > > > > 
> > > > > I am fine with both paths. Sean has stated an explicit desire for
> > > > > hypercall exiting, so I think that would be the current consensus.
> > > 
> > > Yep, though it'd be good to get Paolo's input, too.
> > > 
> > > > > If we want to do hypercall exiting, this should be in a follow-up
> > > > > series where we implement something more generic, e.g. a hypercall
> > > > > exiting bitmap or hypercall exit list. If we are taking the hypercall
> > > > > exit route, we can drop the kvm side of the hypercall.
> > > 
> > > I don't think this is a good candidate for arbitrary hypercall interception.  Or
> > > rather, I think hypercall interception should be an orthogonal implementation.
> > > 
> > > The guest, including guest firmware, needs to be aware that the hypercall is
> > > supported, and the ABI needs to be well-defined.  Relying on userspace VMMs to
> > > implement a common ABI is an unnecessary risk.
> > > 
> > > We could make KVM's default behavior be a nop, i.e. have KVM enforce the ABI but
> > > require further VMM intervention.  But, I just don't see the point, it would
> > > save only a few lines of code.  It would also limit what KVM could do in the
> > > future, e.g. if KVM wanted to do its own bookkeeping _and_ exit to userspace,
> > > then mandatory interception would essentially make it impossible for KVM to do
> > > bookkeeping while still honoring the interception request.
> > > 
> > > However, I do think it would make sense to have the userspace exit be a generic
> > > exit type.  But hey, we already have the necessary ABI defined for that!  It's
> > > just not used anywhere.
> > > 
> > > 	/* KVM_EXIT_HYPERCALL */
> > > 	struct {
> > > 		__u64 nr;
> > > 		__u64 args[6];
> > > 		__u64 ret;
> > > 		__u32 longmode;
> > > 		__u32 pad;
> > > 	} hypercall;
> > > 
> > > 
> > > > > Userspace could also handle the MSR using MSR filters (would need to
> > > > > confirm that).  Then userspace could also be in control of the cpuid bit.
> > > 
> > > An MSR is not a great fit; it's x86 specific and limited to 64 bits of data.
> > > The data limitation could be fudged by shoving data into non-standard GPRs, but
> > > that will result in truly heinous guest code, and extensibility issues.
> > > 
> > > The data limitation is a moot point, because the x86-only thing is a deal
> > > breaker.  arm64's pKVM work has a near-identical use case for a guest to share
> > > memory with a host.  I can't think of a clever way to avoid having to support
> > > TDX's and SNP's hypervisor-agnostic variants, but we can at least not have
> > > multiple KVM variants.
> > 
> > Looking at arm64's pKVM work, i see that it is a recently introduced RFC
> > patch-set and probably relevant to arm64 nVHE hypervisor
> > mode/implementation, and potentially makes sense as it adds guest
> > memory protection as both host and guest kernels are running on the same
> > privilege level ?
> > 
> > Though i do see that the pKVM stuff adds two hypercalls, specifically :
> > 
> > pkvm_create_mappings() ( I assume this is for setting shared memory
> > regions between host and guest) &
> > pkvm_create_private_mappings().
> > 
> > And the use-cases are quite similar to memory protection architectues
> > use cases, for example, use with virtio devices, guest DMA I/O, etc.
> 
> These hypercalls are both private to the host kernel communicating with
> its hypervisor counterpart, so I don't think they're particularly
> relevant here. As far as I can see, the more useful thing is to allow
> the guest to communicate back to the host (and the VMM) that it has opened
> up a memory window, perhaps for virtio rings or some other shared memory.
> 
> We hacked this up as a prototype in the past:
> 
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fandroid-kvm.googlesource.com%2Flinux%2F%2B%2Fd12a9e2c12a52cf7140d40cd9fa092dc8a85fac9%255E%2521%2F&amp;data=04%7C01%7Cashish.kalra%40amd.com%7C7ae6bbd9fa6442f9edcc08d8de75d14b%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637503944913839841%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=Juon5nJ7BB6moTWYssRXOWrDOrYfZLmA%2BLrz3s12Ook%3D&amp;reserved=0
> 
> but that's all arm64-specific and if we're solving the same problem as
> you, then let's avoid arch-specific stuff if possible. The way in which
> the guest discovers the interface will be arch-specific (we already have
> a mechanism for that and some hypercalls are already allocated by specs
> from Arm), but the interface back to the VMM and some (most?) of the host
> handling could be shared.
> 

I have started implementing a similar "hypercall to userspace"
functionality for these DMA_SHARE/DMA_UNSHARE type of interfaces
corresponding to SEV guest's add/remove shared regions on the x86 platform.

This does not implement a generic hypercall exiting infrastructure, 
mainly extends the KVM hypercall support to return back to userspace
specifically for add/remove shared region hypercalls and then re-uses
the complete userspace I/O callback functionality to resume the guest
after returning back from userspace handling of the hypercall.

Looking fwd. to any comments/feedback/thoughts on the above.

Thanks,
Ashish

> > But, isn't this patch set still RFC, and though i agree that it adds
> > an infrastructure for standardised communication between the host and
> > it's guests for mutually controlled shared memory regions and
> > surely adds some kind of portability between hypervisor
> > implementations, but nothing is standardised still, right ?
> 
> No, and it seems that you're further ahead than us in terms of
> implementation in this area. We're happy to review patches though, to
> make sure we end up with something that works for us both.
> 
> Will
