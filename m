Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9AB32C754
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377269AbhCDAbf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:31:35 -0500
Received: from mail-bn8nam12on2075.outbound.protection.outlook.com ([40.107.237.75]:58080
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1387776AbhCCTec (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 14:34:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d/RiXao5tGaORtMiEPSuSYQKpNtw61FOr/x6n1aoXZGCMhCXI5el+qMaYl90NH6pjHsUlD2j1rnv420hWaSN2DP4ZKbY0IMaLYk5BuBM/lKeENTz0OQqk+PxQ0t7JZp6SuZIt9nrk1RUh481y0VCJHaG0xRgEj0XBYzrEvPJ8G8x0e8PB1e5yQRdPQm0SfJavHTpCTjSt7m43+2lGpzkXZJOQN4Z8vH3BHioz93ZCVoHo7lh+nSAbo6W2hFeQ1AVBO8+amb9O1O7mK7FPmc1yNzA2A8G95UmsU+4FgkVa8ue9TR1IULnTj0Xuz1qTLPQpKQKWKUloINrXC59VM79dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vtkyo+V3+SHUJ+ltdcocAo8ILTVFWFJbVRt/eTP4ca0=;
 b=Jma749x1FO8/u++WXkI32/uQcc3k0VtuMIMlIrQsvGQlUtJFfAyvfyS6lWjHTVdY/JoVPfMAPeNum4yHRSzjnTmyBHtJMcHfUnIzdncrVJU9Fpk+dLP8Uk3WIzQeRN7OReKgj6zPnCcv/Ary2IYsB13QT+dnxbo7huA3Yxxx1ufPX8fWMEgQfGtOv6GCFZcE0DkhyUaXkXmvIn/FHkz35MwU12kH9ucs+mBgIG/jIUXcMqoNZGzF5RNYh2c1hZfc3MwNgSxp/m9e7gmR0CZ7ld5tsJ91Noc96KxYgYUp8qUFoWXxtNP6YRaOGlhQ5x1G0KNHEcDZyY7RfI3LuHvy1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vtkyo+V3+SHUJ+ltdcocAo8ILTVFWFJbVRt/eTP4ca0=;
 b=MQM6MQosMlju+1bl2yvcYQHGNfJ6bITAe11Bg4oVz3AhfjvwhOpuWAq0UI4gxT1qlO4FRSsQCYIKjDhDUyVxJVcSF8kXDiSPa2tY5IuJoEkkPDSbyR8slaRDJ0Qi0C7+UKCcEmPH06qGgP2JU53f7ka8IU1rRb3VM9COpTlRZQ8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2415.namprd12.prod.outlook.com (2603:10b6:802:26::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 3 Mar
 2021 19:32:53 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3912.018; Wed, 3 Mar 2021
 19:32:53 +0000
Date:   Wed, 3 Mar 2021 19:32:47 +0000
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
Message-ID: <20210303193247.GA32216@ashkalra_ubuntu_server>
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
X-ClientProxiedBy: SN4PR0801CA0004.namprd08.prod.outlook.com
 (2603:10b6:803:29::14) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN4PR0801CA0004.namprd08.prod.outlook.com (2603:10b6:803:29::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20 via Frontend Transport; Wed, 3 Mar 2021 19:32:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ad455b37-cc70-4c7a-169a-08d8de7b238f
X-MS-TrafficTypeDiagnostic: SN1PR12MB2415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB241541EA86CE081044AC22148E989@SN1PR12MB2415.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7QK9YT341ZNns0U/upNaKCrJ4epm7t7Z6EwNYsCavhDKKv4bMl/askgxi3fWTa+PLzjwwFJVPowA/uOEkSbhbxqfJjNOGWiyzyIZnIxmQCC4zOUXDzz4jfc2lRfs1SqraaFH625ZbQOCCzgdC1Qoh9u7+wsFBVcyOIxOaS+taRHqRJZf83nGodn/xfDbcQZs1JZMjYwC5sT6j3E2oaRoPqrka+NUjKmsV1iRctP9JO6HIttZ2gdabJkJpt94lth3HgNuRjolZpDoYbrZdfL+WM4YnS/2FPNvBFcjTkktok3AA9HizEdSqs8BYPt02e2zA9YSidsFCDo+WNVZcB6KwXMwfaLV9wJW/n5HPF3BGwlqs197JIJ8N4G0rUV1N+IjcsF3SyRlvkMF7h2f0BuMZGEvVNAUYIaPKF2U8gkJPzBptOwB9+1ZNVy158J6iOhchUHx7tps9UpXmd4WRR4ru1bMfD+BlTcFbf31Vwy2xGjBF312UeDPuGd33YPo2FqtlxFzf3Ry589NKyuf4S6wk4btbzupfpnGs58PwnFLHsbRKpOwoVzhsQN1vAvGudByn10f96spe2QBmXNygDL//g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(376002)(346002)(136003)(9686003)(8676002)(86362001)(1076003)(316002)(6916009)(52116002)(6666004)(26005)(8936002)(53546011)(54906003)(33716001)(55016002)(33656002)(7416002)(6496006)(66946007)(66476007)(45080400002)(5660300002)(66556008)(44832011)(2906002)(186003)(16526019)(956004)(4326008)(966005)(83380400001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?yF0jBggMi/HkxwKVHWW7FKX9MOlrhZBLF+4Fw6Qi8fZopodcBU0LevBfMHdq?=
 =?us-ascii?Q?Gb9n9RXxl233m76GfSBKGqUSowfdUiwlmfuaAGD0F25SQcV+V28H5C34jMK1?=
 =?us-ascii?Q?XxPd2SSLZTVEUuOfesVjanzoGURrPU0Revfmhu3oeX0Ww6KKWN2OswKCsl4M?=
 =?us-ascii?Q?Ud1rvp3N/EQ3QGa4+NFG5hP8ISJERyQy6wBEhFEeHcpiPZK6mcU4OGUIjQsD?=
 =?us-ascii?Q?LFelPfNVjUdCZRfqQtzO6ohPVDgu63ubKfS+HV/idP8RnblI97bPRkgR4oLf?=
 =?us-ascii?Q?aD+5AvDx6dGuDJlvW6xTymmc4+l+82DctDg90aaKLtOsZAmj3WIiY3FIUOx1?=
 =?us-ascii?Q?kX/gjbEZjGZ/ubQ1K54WRUvVPWIuKWsTuZctih4TQN3sw+NUZQ8Gs+9zIF3r?=
 =?us-ascii?Q?tr0sylmFIBw2PRLXBs5P2DXUmqlsXIo3hc5IvzULWv+bFgZX8fsEwY8S+/OM?=
 =?us-ascii?Q?+YnW9zw8BXmZF6pPZAcS5j4+pP7Ad2vHRpIDWzpOChIERJn4m4B2NA4N52NN?=
 =?us-ascii?Q?hE2pwpHwKgT9nQxCrfmtagv5olQkYSjFTvj87llZNoQeZlq6N5N0TsjqM0NJ?=
 =?us-ascii?Q?Dtp20X058JoPnC57k+C8TzGx66zWF6Lc7ilGhQ+AodsMX60Mds5iqbX7nYjI?=
 =?us-ascii?Q?E4QX+iwiMIAtsdCVTkCX/ikVEElzqBH+TgxIxUSlFGXiuEkdm20ONOLRXvl8?=
 =?us-ascii?Q?y6h20gLJrkGzYwZRLmqfq25VI6twLVsVHPVtS6GrUgyiRSZlz1YZ1cFcEiMT?=
 =?us-ascii?Q?ULdz8KjwduQTlAx4OVpdC9OsnVITCpI2sqeycOp7XNK6W8aL05htEv62/u0B?=
 =?us-ascii?Q?dsLIICE80eroSrBVPbjO1yL2sV4ocfI+LxckwZkMjWIfQAaqTDdOFaKWmkRu?=
 =?us-ascii?Q?IChd7O0Cg1rbrdVHT3xp2JNE8rgi33JtFDslrvnA5eF7FETy7hjsLnKJC1EJ?=
 =?us-ascii?Q?RcQ4E7V93asZ0Y7yw6WBAFSARkMw/vIX3aGmoUTZKeCmCD9ojwPdARxJznsk?=
 =?us-ascii?Q?EEhsazTibQhiA53n+xXIMSdkJc4fLiTpclyRkjb72Gwmqfqx8Krjq0q7MBRK?=
 =?us-ascii?Q?QelkmOgk1MbEiXC3/sxEjhz1gGRjnZNokXXileqH7UUkmmNqxiIyn+V4x7qr?=
 =?us-ascii?Q?deuvZhnJJWNlfThqGLkqzaaKITemKKhmIyTRKVtfvh1paS+s2C7QCrbXZAej?=
 =?us-ascii?Q?IGDceEQprb0ZgInPknNybwAiUiQV+1rY2uVafS7d6f3v2VOuHZl68RCPfIei?=
 =?us-ascii?Q?JxJElVKvGZH/xW+7L8yv+Eg1ksbSaBXKHjUAVUji442dsn3L/MWN4P1vjgsj?=
 =?us-ascii?Q?BhFiozBJMBJxPp72+EvklOlv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad455b37-cc70-4c7a-169a-08d8de7b238f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2021 19:32:53.5027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oZ4tFi8tkaUqVuOltPfZGveKFgQV7C6Row929KFkkXzSoAE5Q2o3wOnGqE+RgiIetAt2hky0MLxtgEZw1MyZlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2415
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
> relevant here. 

Yes, i have the same thoughts here as this looked like a private hypercall
interface between host kernel and hypervisor, rather than between guest
and host/hypervisor.

> As far as I can see, the more useful thing is to allow
> the guest to communicate back to the host (and the VMM) that it has opened
> up a memory window, perhaps for virtio rings or some other shared memory.
> 

Yes, this is our main use case.

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

Ok, yes and that makes sense.

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

Here is the link to the current patch series :
https://lore.kernel.org/lkml/cover.1612398155.git.ashish.kalra@amd.com/

And the following patches will be relevant here: 
  KVM: x86: Add AMD SEV specific Hypercall3
  KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
  mm: x86: Invoke hypercall when page encryption status is changed
  KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST ioctl
  KVM: x86: Introduce KVM_SET_SHARED_PAGES_LIST ioctl

Thanks,
Ashish
