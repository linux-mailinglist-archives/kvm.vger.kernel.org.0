Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F67332ECC
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 20:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbhCITKp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 14:10:45 -0500
Received: from mail-co1nam11on2070.outbound.protection.outlook.com ([40.107.220.70]:37216
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230266AbhCITKe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 14:10:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZY8vwhgvu00I5WbnhpdFspqP7ErHu1/mkWaMkQNyl2pMHxfAwd3C6nsXfIzzK/xx5LVUknoEAGixhpiB7LPMBkdJgDrEbRKRHemAj2TFknRneJRqdKs1kgtgr5Ora1UK0JAsKdur/dcBrX+GFNhjedNbyY0GsMNRIc+itFynnkAt0wy44o+txxsGlrLna4CcN0deeAsQsEZpBzAhRSUDQO44VKJqCdP1qP1n1L8vzSWjnrl5PFmq5D/qAdu4LXuZhw6tgifh94Sr48PA/YZodRL++qku7wSFYmX7+AhTSmpEDZ+NQ2kf4GFE7Nzft85rrKzNatYWIoNKHKOWP86QJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wQVEawMcyLDwpxf3QB4bA2SPGOAt2C0/TKVTsTrqNF0=;
 b=EyaSxAT8z66+VFFYS3O4AYf6yWlbTv0BgSgwcrwnIaDVVM4/FiniYFBy1STdvliLvlPl//O+fMprMa0KCPvA2vLssXc7s1+eofpYY+wvJOExVT+I59NFvqI1jO1Xv32HidE9Uz6ciwQ76NBRXjghlVWNgTiWrJwTiPXcZra1jXs9MM0tnbPNrDD5W8A+K15ziFUmpSIKcSEboKxIc7j6w1Tu5wWGQxMr3o0n9QKPAqPOPtaLtm8jq3h+6mlzlRZ/oc9evvbbl3eWttZF671qL6nmTjGdw+H6xvC2fp8avB3lK3EXcpUreS5o+FDcCYB3xtkLJvI+U7+2DFVZnd8slQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wQVEawMcyLDwpxf3QB4bA2SPGOAt2C0/TKVTsTrqNF0=;
 b=GN/J8czxBND8Xmcean2Xb6jAvQc+8QD987t6k/hcrHfwS3+zWZELZUrvagcIyoNhVr2HQFt83K6DBMbIJH0/uNKCRQyLRBw/AVsEuA0FYYApRbUxEs/hvmmik7PGpXu5DgDz0bmrZeY2McMWZUpspN+Pj8KSWNZjkHTosqBvgXE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2447.namprd12.prod.outlook.com (2603:10b6:802:27::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.29; Tue, 9 Mar
 2021 19:10:30 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 19:10:30 +0000
Date:   Tue, 9 Mar 2021 19:10:24 +0000
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
Message-ID: <20210309191024.GA7273@ashkalra_ubuntu_server>
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
X-ClientProxiedBy: SN7PR04CA0200.namprd04.prod.outlook.com
 (2603:10b6:806:126::25) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN7PR04CA0200.namprd04.prod.outlook.com (2603:10b6:806:126::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 19:10:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b901eedb-14ee-4902-f470-08d8e32f017a
X-MS-TrafficTypeDiagnostic: SN1PR12MB2447:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2447F2D2BD4FB9D5E4AA1E778E929@SN1PR12MB2447.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PXQmA+jjsa4l2Sq22SK/fQYF8oa7hizCH3k1o2cPDCqhyAFHeKADNOAt8OojPF8pecKiKB6/4lp7m7hOmK0GuFGRh9NjJo3JnLjkS3yf6NgSCxD80J/gMAbl7MTq4Xylhw/RSIoAGPPxNfOuRdvEuqfEwgfxnU1YOx6wr9+i307wKqd9fpi78ZxOAC7kVVQ3rK4sSflHxfvwsvF7tVLx5dAIU9y3/AYca+DujGhZAh1fGFuzeK8EaEptrJ6zSocdAwyWSmrVnJxWcZ5ZGwtRP6Cd1mywN3YTbwL6PQFP3WYxicXQqB7OBvUuduHMmsB0xjA3OhkIDy2ULyMOZskyecnXUQjMAy5uPYUPkKKyNMNtQngvn4KZLNkvRZHXo3CcszFgZ6Gjv6SuLPZM1q9K2xG4iwUMK5HA6cL19/psiK5cKSeHmPHOGAqbsgnfWS1Hk3gfuS+yutS0Lp/UhhVTbJziHoHBlDPn4+6XU4LfV2PB7M/ZH/oEnZjPmFcLq0ckGMZaz1PnQsTpogiAaO5gAyPk4T03FpM2Uh5bx0XAHQccO+YTr6Pg08G2s6C6/i5rVkSPfVO136Uq1949Cs+30Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(6666004)(26005)(44832011)(1076003)(52116002)(478600001)(7416002)(8936002)(6916009)(66476007)(66556008)(66946007)(83380400001)(8676002)(16526019)(186003)(6496006)(45080400002)(53546011)(2906002)(33716001)(4326008)(54906003)(33656002)(86362001)(316002)(966005)(9686003)(956004)(55016002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?wED7J4SPntpGweDibMggfOb1Pzu6iFKEKL1uAt2vNM+GJNFLD4gUihxBiz6A?=
 =?us-ascii?Q?eDIMGr56DQME0gFMN1ojhOsisGKDEit/IsZkSsggk1DaN+EHm20c48gvpUB3?=
 =?us-ascii?Q?oLVMXQHynvgdPduP37ej7H5++ITU+OgBHf1/5bfpNRoVx3F+kRCPswlMrSOc?=
 =?us-ascii?Q?I3hcEx3nmswGSA3F2AS2EvF/cY9vK7mIdqYtC4FH5OKpbCB6Vg6zqrpkDmFD?=
 =?us-ascii?Q?n1uZQTIgfTZMRKZ2Dz7Q1/t9mcNORO3HRH5gFs+3M8yxy8iydTZJvhj/P0Dz?=
 =?us-ascii?Q?p7MBidDU9MPWvdBDxuYXru1AfQgj5zmTVM8P6dU0NurTb2nYx04CNTwnzxaA?=
 =?us-ascii?Q?FoqjsBA9jSK8NwfcG80BuPn9k7s4oKQgHy6ecNCGD6rVzLBiu4JaaMbJcrgE?=
 =?us-ascii?Q?AX9wQ1fFiQEwIuRAVtd13WZqEGefT5nt4V+H+mFmzevoIzbh2t5Z+25nn27U?=
 =?us-ascii?Q?ehfAqUhaU9CA13QWYB6nhozM0tfKIQJFq6MA1NEF39t8XAuq29ge+kLwJSWV?=
 =?us-ascii?Q?7WClIPmv7nqONZSLZXHfuXPaBG+gjndTGgxAgtuDvhUMwo6yIXP1GOdDy3YN?=
 =?us-ascii?Q?eCVzBR7n95IIfElenOdSLAYsLX0AXyv+VyqLMXMi8dVm2yewRJT4Bk8cisDN?=
 =?us-ascii?Q?Uq+9AeEW3qfAxyI3G/CkFFnfWdKnSO0m7uUNpWYNJHGy9QwxWksMqAErzEr/?=
 =?us-ascii?Q?JvgVMe1Grs/1wifth/RTuPAA4b+2YcbySmGbfmC/4o8uNy2u6VMDwa0w9/T+?=
 =?us-ascii?Q?Jenz8sfoJMGRO0t8Nsbbw2nQ6bO9usTiD/Ki6JsnZG0odKNkVcfkfZpbeC4r?=
 =?us-ascii?Q?IiRKL0Fd+28INGAS87/YXfnSMvck8h8NWOT7gTEy3XEl+ArmqDY88LD6VJ2c?=
 =?us-ascii?Q?3nPZ0rw0PLd2gHw7uHY/JMUO4eNHu+jUV2g6lEWiXL5EnAuQUCsnIFYHk4W0?=
 =?us-ascii?Q?9PATe+hCSIrIl07HqFwEzBE8qTKDJQJc43zjKFQBkKVCMGciFSqS3GKG+APj?=
 =?us-ascii?Q?xHWUxmeZzMHiCNYvCj9iT+2d37rLS2DwE8lKuaRsC0yvpaJmm42K0qCwADTX?=
 =?us-ascii?Q?f8cbZc8lVUr7dDObnB1S358KJfHW8aXGAv223nZuWVLn1cvvFMqg43oq3qM7?=
 =?us-ascii?Q?5XLOoGax+9udsEtK3zf5a+y5birxgZybiAcxF3CGyJL1KQqblJFBB2/yBZZW?=
 =?us-ascii?Q?XFxzV4YiAlZcDdJI/WYZsEOVcHSMurrw+rdLH2dM/0mS6LGgNyMgbFZUPWiP?=
 =?us-ascii?Q?de1H4aOrv7kNeGrFtl3ZJUWhVQ5FjJYaIpmH1c7+07jHzrhVaD3qr3wwC7FK?=
 =?us-ascii?Q?T2ZT8mgCnE0xWwKy7StplWVo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b901eedb-14ee-4902-f470-08d8e32f017a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 19:10:30.3656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ikCdvLx7+HfLIzaUI3OEaLSg9KWN36idxNUzygbGSJcm+868pas9XfGoSagxIvXjN8Bk7AWgm4mRH9pREPFEEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2447
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

Doc mentions to use KVM_EXIT_IO for x86 to implement "hypercall to userspace"
functionality. 

Any reasons for not using KVM_EXIT_HYPERCALL interface any more, even
though it is still there and not removed ?

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

Again any reason for not using the KVM_EXIT_HYPERCALL interface for these ?

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
