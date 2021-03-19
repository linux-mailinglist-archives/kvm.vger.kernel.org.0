Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228C13423E5
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 19:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbhCSSAT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 14:00:19 -0400
Received: from mail-bn7nam10on2058.outbound.protection.outlook.com ([40.107.92.58]:16224
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230226AbhCSSAB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 14:00:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HGnBLFFbFce2m0kQWXOGG+gwnw2Mv6nTOjNdFZHuiAQSL6Ymc3x5BSQgDx9NAyEQ3oFJXrISiwO6V2cAAcTpGkg1w/Mg6LT7AoA2k82vfJDJcaI5XkrZdbU9L2nm/0RFLSISLEN3m6FnP8ltz2GCEToZ2iocJEJu/rOsL1Sizr5BqiLf4pzOQvvbF7pnPX48cr3tiC3EtOba2y2xy5scIz/dBgmcgeM6g6vDwqz4Xdph9dbpzXY94XHgdW3G72FEyBAIRAWcGPC8IqKShBDUS2BFeGUZunPp1YVH0zQR0OMvvRkOAipmkJNxJ/0GHc4f0B4q9M4b1VRa+8P8QyXEaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TnDWpuc8QynxOghGTr+hlPmdL7skn7/UHmlmcFCY7YE=;
 b=cAbm5mn5cpUf8+q2RIyRKbMPhElodmltReRUr6fu1nP8X2zB+A4XE8z1bz3wiExQT9U8X78/ZlukQfTM0Tsfa27w+u9Tgd+f7z6GcrTjushXF8qaGkDyLiPKYgDkeFiv1gLqiu9TRjGoE9UgMvWURLYmZ8sM/mwM/VSY6XxerqTQsEdGIwQ/WV4Vjvb992QdEYu7dZowpvIrkq+MEEnP7EKO7lIwEX1yMdCySSYY4U36ftvn5L3bf3sb9gdVDz/rBJ9fCoXodIjA9c7DRLdBChBQM+Udz96Q0yMLkXWuo8kAhu2VCVy/Tk09l8YWrJe/Zju7TAKosr7Am7GvuE+Yaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TnDWpuc8QynxOghGTr+hlPmdL7skn7/UHmlmcFCY7YE=;
 b=vAVB2iS/MAj4/UG+/cdZKXOFlLyoiLI3FX9MYsMf3cXXHrFQeoyoqOgXK9dKfTlkAjY7EklPUsxvTwxPu79Yf2lDg1cBhTq0dwOSCE/iJi8zCe1kNzxPpSZJwaS84I6KPAndCNMTvdq+1aVX11OaVSTGBdJP0HHz5H9QZMqFUaU=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4509.namprd12.prod.outlook.com (2603:10b6:806:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 17:59:59 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3933.033; Fri, 19 Mar 2021
 17:59:59 +0000
Date:   Fri, 19 Mar 2021 17:59:53 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Steve Rutherford <srutherford@google.com>
Cc:     Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
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
Message-ID: <20210319175953.GA585@ashkalra_ubuntu_server>
References: <20210224175122.GA19661@ashkalra_ubuntu_server>
 <YDaZacLqNQ4nK/Ex@google.com>
 <20210225202008.GA5208@ashkalra_ubuntu_server>
 <CABayD+cn5e3PR6NtSWLeM_qxs6hKWtjEx=aeKpy=WC2dzPdRLw@mail.gmail.com>
 <20210226140432.GB5950@ashkalra_ubuntu_server>
 <YDkzibkC7tAYbfFQ@google.com>
 <20210302145543.GA29994@ashkalra_ubuntu_server>
 <20210303185441.GA19944@willie-the-truck>
 <20210311181458.GA6650@ashkalra_ubuntu_server>
 <CABayD+cXH0oeV4-Ah3y6ThhNt3dhd0qDh6JmimjSz=EFjC+SYw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABayD+cXH0oeV4-Ah3y6ThhNt3dhd0qDh6JmimjSz=EFjC+SYw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0120.namprd04.prod.outlook.com
 (2603:10b6:806:122::35) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN7PR04CA0120.namprd04.prod.outlook.com (2603:10b6:806:122::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Fri, 19 Mar 2021 17:59:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8d3794d8-e7cc-42e3-a35a-08d8eb00cf6e
X-MS-TrafficTypeDiagnostic: SA0PR12MB4509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4509A022C9B97E857B2CF6518E689@SA0PR12MB4509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D31aFGDanVH9z2ixtelUt05xBHvIMhSPZunrHAnHLWIYj/KKVGA54RlKPSiIu3EU+whi2FoWdYLIhwlQ50xZSEtmq/TwQsXznCBq2WrhkvU+nOYxeuI8XZ2GGwySlAs2NnOTmQOnExllCfuKeNrsjfLqA4mjzhs0YKDRP76Jqi4B2k4VNMZ+EWfBuEPBi127PMsm9B1272SoCrDf7QWf5ngRGs7qxvAx3OZCoodDHLWdqGDY0TI1FtWhNh3gaPgDrGFmji4oINALZJNvJv2YXQAm6iXXSwlJb0rUSBpIY8EmMsUBV0xyr1ddlswqw8OykuShod1DZyuN9WRdGvSTTlAbpG05bIn7Z8bsLPy9rGQld/WP8TN2sCLpb/gYYL01npADK4Bynjai/4P4kz4t7PFPJVAz2k3qn+VJZH4HfqzlYGI9g+BLe+EOkkevX4gRxPpePK4vjpQTEXtIIzuf/s9RyUcZC9Fkfq19ZKot+033BvG39iUlfmBxZzeBVCpNy8kv2o7pM5EBdlJHGMckiBHOb18dmWSs+acOm9n9gCz4ZL6BJ59n9Xyu0i0EC0g4wo3j4NH3JpVlNi+xHH4Av9We4NlaGhWqq1uuiFI97SU8ovB7H/myLoIN8oJXOwvmq77rPGGcSRXmi4WL6nQH9tt27nNah2IVyj2t3KdnZwdwPR9t+5d0jLsVm6svCFNy8189iGVUk14DxJ3Sf/4ZtvAzJvk3PXF8IxXr01Pwv60=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(376002)(396003)(366004)(316002)(66476007)(4326008)(2906002)(8936002)(66556008)(54906003)(1076003)(53546011)(66946007)(186003)(9686003)(6496006)(6916009)(16526019)(6666004)(8676002)(55016002)(52116002)(86362001)(33716001)(45080400002)(83380400001)(956004)(966005)(26005)(5660300002)(38100700001)(478600001)(7416002)(44832011)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Tcv5dN/FwJnE7oQ0pwqVNLURP3nuXmjdks0FFIVPxMswNKs39UnvlIoD1TTO?=
 =?us-ascii?Q?6FvuPbtqIfxyZ6qvSRKAtrQLDx/klgGLgFWkUs78Z4WhwARMbYxvdjeV9DH6?=
 =?us-ascii?Q?ZURARKiKFR4GdVOIulf2BQaEpkSt/R9zga4EOCF4cnPs9PEaZaBeMg59uQnY?=
 =?us-ascii?Q?m7wnJWEdEp4/JzU+wIbje22CkfIl62B4Hvxq4DZszVp9BNsburOu0Rv8zCUl?=
 =?us-ascii?Q?xqjHNETdOYHCuJtAcP33iLzng3Nex93a6FVo/1PKNcLKQrsDTSccp3PTLof8?=
 =?us-ascii?Q?ofZ+cYt+yFL0lEObZtUq4lgOEHIbkmfSZVsc623lqX2H85wALhhyxc+4AuSN?=
 =?us-ascii?Q?hiNTfMskgMwQcv5Q9vlzq94gz+2wITGS7420uQDRaT0woV3nZdcLr9E/TGmg?=
 =?us-ascii?Q?d0jzuWuzef8bfOvSU9aO8Uvyn5gKo0FTtIl/zI8Dmg2o61eRDpy8YN5kCLrF?=
 =?us-ascii?Q?YbZZGHh6r0YG/RP4FfFA35DYJvdQ/IPIliZreRYMPPNoeT2sCCTxNkLA+xHn?=
 =?us-ascii?Q?R355ab4AI9NOcThshgS6efJ30dt6CCVN5KxI2W3c50e7wUwNMFxz8hHLmru6?=
 =?us-ascii?Q?Y5S4GGqS0C0Sk91rTpayxFfz7/7bnjOG86Flhe1FrUsdEcB8TCOrD5XD5Wf2?=
 =?us-ascii?Q?zWsYdcP/W3piKZJgw6Cyo8SI+o1Uee037KTfgZiAaxmsL0nUsgmBUkuwxiXC?=
 =?us-ascii?Q?2C9AzpnNoQ6X3ITtx/pa/mx3exKQ0Zq4J29y3ChO7OscLeJcY17//DAb7XnQ?=
 =?us-ascii?Q?nTpePm0FjycYdfqGO+DoOpXOdA9lVy3pD5s7VDiNC3up7WU/g+JAriKU5jj/?=
 =?us-ascii?Q?EuUq7iurmpPaCMdrl30xG6vdOdnvh84u0vrsp8bqFWlQoKbKGi9OBC6QqX1t?=
 =?us-ascii?Q?NU/ERGxMMSPWwroVNrN3e7Mb6jF8Hh49ZM0O9K8J84z1xvb4vZkZJBd5yBNN?=
 =?us-ascii?Q?P7JB4K0blHTi5YX3yJNGnklwK+uU3Fj2aPRpys1dP7hG5uTaopfgDD2AUO2H?=
 =?us-ascii?Q?RZwjoVKZ3VI5A0hBwHc0vSmTdfSEic/us2iUUXCygQeMj1dqicQYqcXSMw/N?=
 =?us-ascii?Q?k7BMK2IGObpp+iMcOT2RoKuIAQZQDgP50wUkGdAsnhx5tc8MpFmadA4iH3Cm?=
 =?us-ascii?Q?e5iHznfZBVf+wrGnh2KqKGO58iLyBuIiaEvy8u16bLqXqEN/4fy+JoIRnCJY?=
 =?us-ascii?Q?ELG+9jzpgizCD579i9Sb4/kzrndf51fT543UtgVZQTlXn1faHkAnIeUBF53I?=
 =?us-ascii?Q?j1oxY9eb6sRcQg8fUDZAI5lO3Wpp3Ku2YwwO34fVb0vh+NC8FCDZnu1MaCqC?=
 =?us-ascii?Q?yGP9HXP4uwuqk5LB5w6leg0g?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d3794d8-e7cc-42e3-a35a-08d8eb00cf6e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 17:59:58.9874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i3XDTtc8v6OICRIFTFRoRygkK54P6YHWN1a/GyVdFLs7u1iwtdeJBQX6eY4Sr6gAh5Z0RdzGqwTCQWM+2q+WUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 11, 2021 at 12:48:07PM -0800, Steve Rutherford wrote:
> On Thu, Mar 11, 2021 at 10:15 AM Ashish Kalra <ashish.kalra@amd.com> wrote:
> >
> > On Wed, Mar 03, 2021 at 06:54:41PM +0000, Will Deacon wrote:
> > > [+Marc]
> > >
> > > On Tue, Mar 02, 2021 at 02:55:43PM +0000, Ashish Kalra wrote:
> > > > On Fri, Feb 26, 2021 at 09:44:41AM -0800, Sean Christopherson wrote:
> > > > > On Fri, Feb 26, 2021, Ashish Kalra wrote:
> > > > > > On Thu, Feb 25, 2021 at 02:59:27PM -0800, Steve Rutherford wrote:
> > > > > > > On Thu, Feb 25, 2021 at 12:20 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> > > > > > > Thanks for grabbing the data!
> > > > > > >
> > > > > > > I am fine with both paths. Sean has stated an explicit desire for
> > > > > > > hypercall exiting, so I think that would be the current consensus.
> > > > >
> > > > > Yep, though it'd be good to get Paolo's input, too.
> > > > >
> > > > > > > If we want to do hypercall exiting, this should be in a follow-up
> > > > > > > series where we implement something more generic, e.g. a hypercall
> > > > > > > exiting bitmap or hypercall exit list. If we are taking the hypercall
> > > > > > > exit route, we can drop the kvm side of the hypercall.
> > > > >
> > > > > I don't think this is a good candidate for arbitrary hypercall interception.  Or
> > > > > rather, I think hypercall interception should be an orthogonal implementation.
> > > > >
> > > > > The guest, including guest firmware, needs to be aware that the hypercall is
> > > > > supported, and the ABI needs to be well-defined.  Relying on userspace VMMs to
> > > > > implement a common ABI is an unnecessary risk.
> > > > >
> > > > > We could make KVM's default behavior be a nop, i.e. have KVM enforce the ABI but
> > > > > require further VMM intervention.  But, I just don't see the point, it would
> > > > > save only a few lines of code.  It would also limit what KVM could do in the
> > > > > future, e.g. if KVM wanted to do its own bookkeeping _and_ exit to userspace,
> > > > > then mandatory interception would essentially make it impossible for KVM to do
> > > > > bookkeeping while still honoring the interception request.
> > > > >
> > > > > However, I do think it would make sense to have the userspace exit be a generic
> > > > > exit type.  But hey, we already have the necessary ABI defined for that!  It's
> > > > > just not used anywhere.
> > > > >
> > > > >   /* KVM_EXIT_HYPERCALL */
> > > > >   struct {
> > > > >           __u64 nr;
> > > > >           __u64 args[6];
> > > > >           __u64 ret;
> > > > >           __u32 longmode;
> > > > >           __u32 pad;
> > > > >   } hypercall;
> > > > >
> > > > >
> > > > > > > Userspace could also handle the MSR using MSR filters (would need to
> > > > > > > confirm that).  Then userspace could also be in control of the cpuid bit.
> > > > >
> > > > > An MSR is not a great fit; it's x86 specific and limited to 64 bits of data.
> > > > > The data limitation could be fudged by shoving data into non-standard GPRs, but
> > > > > that will result in truly heinous guest code, and extensibility issues.
> > > > >

We may also need to pass-through the MSR to userspace, as it is a part of this
complete host (userspace/kernel), OVMF and guest kernel negotiation of
the SEV live migration feature. 

Host (userspace/kernel) advertises it's support for SEV live migration
feature via the CPUID bits, which is queried by OVMF and which in turn
adds a new UEFI runtime variable to indicate support for SEV live
migration, which is later queried during guest kernel boot and
accordingly the guest does a wrmrsl() to custom MSR to complete SEV
live migration negotiation and enable it. 

Now, the GET_SHARED_REGION_LIST ioctl returns error, until this MSR write
enables SEV live migration, hence, preventing userspace to start live
migration before the feature support has been negotiated and enabled on
all the three components - host, guest OVMF and kernel. 

But, now with this ioctl not existing anymore, we will need to
pass-through the MSR to userspace too, for it to only initiate live
migration once the feature negotiation has been completed.

Thanks,
Ashish

> > > > > The data limitation is a moot point, because the x86-only thing is a deal
> > > > > breaker.  arm64's pKVM work has a near-identical use case for a guest to share
> > > > > memory with a host.  I can't think of a clever way to avoid having to support
> > > > > TDX's and SNP's hypervisor-agnostic variants, but we can at least not have
> > > > > multiple KVM variants.
> > > >
> > > > Looking at arm64's pKVM work, i see that it is a recently introduced RFC
> > > > patch-set and probably relevant to arm64 nVHE hypervisor
> > > > mode/implementation, and potentially makes sense as it adds guest
> > > > memory protection as both host and guest kernels are running on the same
> > > > privilege level ?
> > > >
> > > > Though i do see that the pKVM stuff adds two hypercalls, specifically :
> > > >
> > > > pkvm_create_mappings() ( I assume this is for setting shared memory
> > > > regions between host and guest) &
> > > > pkvm_create_private_mappings().
> > > >
> > > > And the use-cases are quite similar to memory protection architectues
> > > > use cases, for example, use with virtio devices, guest DMA I/O, etc.
> > >
> > > These hypercalls are both private to the host kernel communicating with
> > > its hypervisor counterpart, so I don't think they're particularly
> > > relevant here. As far as I can see, the more useful thing is to allow
> > > the guest to communicate back to the host (and the VMM) that it has opened
> > > up a memory window, perhaps for virtio rings or some other shared memory.
> > >
> > > We hacked this up as a prototype in the past:
> > >
> > > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fandroid-kvm.googlesource.com%2Flinux%2F%2B%2Fd12a9e2c12a52cf7140d40cd9fa092dc8a85fac9%255E%2521%2F&amp;data=04%7C01%7Cashish.kalra%40amd.com%7C21099e2dd82c477005a008d8e4cf149e%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637510925361923243%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=JputIEFoae3HRO5jvvn%2FTpP8i%2FpMMfWSiZ8a2%2Bna5iQ%3D&amp;reserved=0
> > >
> > > but that's all arm64-specific and if we're solving the same problem as
> > > you, then let's avoid arch-specific stuff if possible. The way in which
> > > the guest discovers the interface will be arch-specific (we already have
> > > a mechanism for that and some hypercalls are already allocated by specs
> > > from Arm), but the interface back to the VMM and some (most?) of the host
> > > handling could be shared.
> > >
> >
> > I have started implementing a similar "hypercall to userspace"
> > functionality for these DMA_SHARE/DMA_UNSHARE type of interfaces
> > corresponding to SEV guest's add/remove shared regions on the x86 platform.
> >
> > This does not implement a generic hypercall exiting infrastructure,
> > mainly extends the KVM hypercall support to return back to userspace
> > specifically for add/remove shared region hypercalls and then re-uses
> > the complete userspace I/O callback functionality to resume the guest
> > after returning back from userspace handling of the hypercall.
> >
> > Looking fwd. to any comments/feedback/thoughts on the above.
> Others have mentioned a lack of appetite for generic hypercall
> intercepts, so this is the right approach.
> 
> Thanks,
> Steve
