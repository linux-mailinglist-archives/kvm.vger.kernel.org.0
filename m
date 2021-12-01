Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C9B464551
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 04:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241527AbhLADRc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 22:17:32 -0500
Received: from mail-dm6nam12on2050.outbound.protection.outlook.com ([40.107.243.50]:21056
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229881AbhLADRa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 22:17:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=drRe+Z1LvWy5IwA55jwjhMlFupQZeZ+DUCKrVq3teQ0uVCCSADMZZFsjEC7My9jJvkrYwDrgEuJqmxqFvax5sSUJUS8x0l5jvyvvmj3z73JOBpOCQQOrgHopFPq+vIXgFl5UhBs21EA4oNpnt6YOr3jhyIWR8ogprBhG4yHw2C4vMTC9jMd9S4UatgNfmWFqtVurIlZtL2sWOL0OlERxAM/wkP+MLD4OEsnjKXZRCk7Tyz1CXYNS60vsf++MUSOKHhMHC3KJvvuRHS7GltQxAKONpwce4W3s/jRCOfu88Fvam7b2lBSpeUsTxZAJfuWFauYplp686ql0OAI6uRvNvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SLA3qIkN+vYWGjTU8jSq8d49kBpJaU82PgRkkeK3o98=;
 b=PU+FtTbK9bAZjU93hBIZpdA3UkrP8uKxntv9oo4jJ3UhywZrEINJzqwCjkSWtECW+fjvNRZfpL+vVSB4kdQ3FojtavtD5dh8u2Pd7NKgnA65WeR3rJV1xuU9XEzyPeUXCF4oz4Si927fPO5IegIoOi0AA8zBuV5EBEAGXBOsW+qqWQ5GT23x4JhrbJM4B63z0CvrUwuQpJ94iLHCLMo/7thrTl4CwYrn9Q3t2DSiWxRLv+VGvF54CUUhUfRR0WaJZtcLZ6E4oe9b0AjNukqHwqHwZWhbKM3ThdSz7cDwiw7M/jgwdIV8tt/3Dc+8Dkww2X49/WuHsDdenNOnLM+nTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SLA3qIkN+vYWGjTU8jSq8d49kBpJaU82PgRkkeK3o98=;
 b=B+KzAXb+sHr29g0gUNI6Qny4rWtzbMO3RrdFMoBwc+lEiyCf5W/v2xz/7SdEPHk9ROhh2b+2C7+OR5MIi38xMaIQTLg0v9eh/OQibpzsOS7sgW9AyS9gkjdqGS8Kh8cdGBOAQOfrbVH64Ybisw+5P1TrvV9a/qaL6DasyBhhHjpPmHHiw8EWul5iMeE6ojf85kaBywDsY3qfyKWCoDQuoThGDAcbsvr2fGbQEXYxuUINImgkkCZoI8b5rQdbkWkcnGSnDVRBn6lgWEbYDrby2E/1j1Dm06KMMj98AiHLKJ/opE9WDWF8Vf5bYMTZagQDP8YSvWl3fc0mXnWfy/zDMA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5378.namprd12.prod.outlook.com (2603:10b6:208:31d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Wed, 1 Dec
 2021 03:14:08 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%8]) with mapi id 15.20.4734.024; Wed, 1 Dec 2021
 03:14:08 +0000
Date:   Tue, 30 Nov 2021 23:14:07 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC v2] vfio: Documentation for the migration region
Message-ID: <20211201031407.GG4670@nvidia.com>
References: <0-v2-45a95932a4c6+37-vfio_mig_doc_jgg@nvidia.com>
 <20211130102611.71394253.alex.williamson@redhat.com>
 <20211130185910.GD4670@nvidia.com>
 <20211130153541.131c9729.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211130153541.131c9729.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR08CA0006.namprd08.prod.outlook.com
 (2603:10b6:208:239::11) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR08CA0006.namprd08.prod.outlook.com (2603:10b6:208:239::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Wed, 1 Dec 2021 03:14:08 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1msG4N-0064Df-Bq; Tue, 30 Nov 2021 23:14:07 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06540dcc-4633-4d03-6d5f-08d9b478a39d
X-MS-TrafficTypeDiagnostic: BL1PR12MB5378:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5378277B1F177EA8F972CCBAC2689@BL1PR12MB5378.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +q1oxyIlMBVFaaLMHr/uscLJz+Dme/foDs/+3G1a+T2obA/UqWQBzaPG9P5qcqe8x0l55gOTy32sGN8pSv3kTNA2GIDtf/jEt0eSRy4GVeCQiET3XCwLbcnKn9YMbPhx2dy2XJ1z2ZhUEWlse6oHs9lNozP71yND0X0kXqkSY0QleN8UOrR1p30bWNK7ff94k3h7vh/y04gHjB2M2fUG9FSMZxdgOHkob88SCStbNfNPk7vKmNaRjycrn+qQLNl4LKVj7FnIFWPUEYbPKgcSEs9byhTOWAS+HgR5h843IwyHV3LM0FVjOSN1g8c4tC/bZMXCstN0Dfcraj6oBBSr+AOL87t1c7cT7FZFSxp9Kr5h7DdjuB6Mhy5k7T3Iiuo18wsChVdWevAdQZt92PpdffUoFBIhyQspFoMN6IAZv54vwjJq4EvyrA7gNzhUweum41V1C1VGvsffLFScThFW53ZzFBqlFisp7bn/8rj2FPHtfKzGZ1ZRc/0UKcRa1zO+nm1ENQbeZBLAQpJwgKrjMi0DwCNM6GOdc0WIPZBjZba6Ke+IgFaJQakOkGZaLccMOMT6rnrtmD0n6T1sVhnljZctdUeOq2op/tTbG1qctTGb45MZ+gNPlOCWL9Vxa6zj5nOHaCTAcm0uXWj6hdgPWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(66476007)(66556008)(1076003)(33656002)(4326008)(36756003)(54906003)(107886003)(8676002)(6916009)(2616005)(9786002)(426003)(316002)(508600001)(38100700002)(9746002)(8936002)(30864003)(2906002)(83380400001)(186003)(86362001)(5660300002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UhNlb7W+Y4NjOBrTop0++Y+4En9twsyWI8/akAlqQ69saa1mWDaMaIZ7fUTm?=
 =?us-ascii?Q?YUhD2rukWzv/cH2V/8MWGZAWdq5W5V0H9Sxspb9ugOay8oE/1uMq9R88Qhgb?=
 =?us-ascii?Q?1d0pM5bOh4/xLwC1vZa18F+IyySwa4giOIRm9N56vEg73s4xbAGpEX3wmqoD?=
 =?us-ascii?Q?wVdx3efiyjvUJbpFcNV0yQNh1Gz8tm8YL6KclD18fQbQtz4nw35rr0E+QoXT?=
 =?us-ascii?Q?enf/4X2dya6GMluiBKK3DsvHWDykwTryJqtwMb/Z718ZWRSwe+yGwFkEWKUF?=
 =?us-ascii?Q?SkyIqLCX/G1dghIfqOM+DVHSo8yEvH4pabEuZCUbFthr0F98dXI+zL9TZHKI?=
 =?us-ascii?Q?dxrghlG7uz4ik8/+ypUAKmxgDcjeHSHLuzF4CxvHWC8Bb1OheH83t+4KQeZi?=
 =?us-ascii?Q?r7VFKvqj8de/R4uj15tvNJZDVRTEjqvgQoZoXfRAGHCys5AFKF43o2XgUEIH?=
 =?us-ascii?Q?RjI7nyGRwB0kMOUcmzYn2evoAtFy/B1QQwWSs1nHlRZpo48xv7crQoSStCQj?=
 =?us-ascii?Q?SAonyO4JcWeM6zLRowu/54JmdcrWc/fgmviE6YvDig/b1w/2b1zf4IsPYZIS?=
 =?us-ascii?Q?5u8TTtIhogfEpR+kSJgAAsXdgzMisTyonoffVT0cbPyMx/UAky46bcD9Ihel?=
 =?us-ascii?Q?46xmBQ+AIMJ4k+75DqEehBsmYWuPOuN1+IIv6jSTXrRJfx5Ksoe7lhuh4JE8?=
 =?us-ascii?Q?xuCOYlw8Pd9AWlEseYHPfrci0Tr0bJBqK+Es147CuPdpMHwLQKwhiY8uQNn9?=
 =?us-ascii?Q?s4JbHnGmwaoXnnpuiTRFk96wRg47nV3oatk0Ad2i2NDUXePPVPQrV+5k4kp6?=
 =?us-ascii?Q?g/dGTcX+/rjcCkqvfpEaybVCs+WjTYRy83v43Ci5zwEITTM4xpYJM//FEH/P?=
 =?us-ascii?Q?+1HF66DvR7y6jRKl6ekWeVYdipmOwGxS0tuHrcrHj6jm0wnOuCv8BZ7a42Rc?=
 =?us-ascii?Q?P4//L1bMv6/87Sk3pqS+FAe9Ito6CDx+5v5Cr0V1kuxdzDqGhxC9BXQG5qsB?=
 =?us-ascii?Q?phltO3A9DTdiTnlm8770UrXu1c7CAGNRXm5f9wHFZJAksWznrr116p9IZTTo?=
 =?us-ascii?Q?e8RWHXEUD3KmUAHAn3LmavomHAzlHomnKXZ/x+bj+P9mhJbeWqlKFTQKU9cj?=
 =?us-ascii?Q?hDmUwVJy+S5IMrVOX5AaMLCt7Xaq/TORrV9ko6Hq7H32Id6TOqcvSNRZ5AIG?=
 =?us-ascii?Q?6ek1c9GhRuBMffjmKlMuebJH9dchUPEv55OERujicMQ+OmSdO8wO7jKeEk76?=
 =?us-ascii?Q?opbESnlUdQybe+dr0w6FUHQMGwZlaRUM9jdZQqzCP4AJEZh/zmhqyB1bWME7?=
 =?us-ascii?Q?57gj6gsX9DMgfwK02sNR1AsgQxccr/NQQiCkwntO4cZRUdJJcA+UmXGD9GnL?=
 =?us-ascii?Q?baToPQD6d0QBW+SYCOnoy94g76Pzrk3uzirJPNvP8i90xTRv3pEjFhFZpEzI?=
 =?us-ascii?Q?3oAEI3XasjS8KEJiqZmTibv/YwyH3a9KWJ2/iPiQwhirHWpmY6ntdS3zCG3V?=
 =?us-ascii?Q?lofYDrLGVOvyWs84s8aN3P3/xKjpCDNdoGRPWC48pbWBJpH7bwyRsAEH0Cl1?=
 =?us-ascii?Q?k7/hB5rApv572uLbg2U=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06540dcc-4633-4d03-6d5f-08d9b478a39d
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2021 03:14:08.6223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SIVdbAsNkZxB/OCvDerGVPOdioWYZx4cmLkNcM9biqMbShweSG7yA/aFagaCwcuf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5378
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 30, 2021 at 03:35:41PM -0700, Alex Williamson wrote:

> > From what HNS said the device driver would have to trap every MMIO to
> > implement NDMA as it must prevent touches to the physical HW MMIO to
> > maintain the NDMA state.
> > 
> > The issue is that the HW migration registers can stop processing the
> > queue and thus enter NDMA but a MMIO touch can resume queue
> > processing, so NDMA cannot be sustained.
> > 
> > Trapping every MMIO would have a huge negative performance impact.  So
> > it doesn't make sense to do so for a device that is not intended to be
> > used in any situation where NDMA is required.
> 
> But migration is a cooperative activity with userspace.  If necessary
> we can impose a requirement that mmap access to regions (other than the
> migration region itself) are dropped when we're in the NDMA or !RUNNING
> device_state.  

It is always NDMA|RUNNING, so we can't fully drop access to
MMIO. Userspace would have to transfer from direct MMIO to
trapping. With enough new kernel infrastructure and qemu support it
could be done.

Even so, we can't trap accesses through the IOMMU so such a scheme
would still require removing IOMMU acess to the device. Given that the
basic qemu mitigation for no NDMA support is to eliminate P2P cases by
removing the IOMMU mappings this doesn't seem to advance anything and
only creates complexity.

At least I'm not going to insist that hns do all kinds of work like
this for a edge case they don't care about as a precondition to get a
migration driver.

> There's no reason that mediation while in the NDMA state needs to
> impose any performance penalty against the default RUNNING state. 

Eh? Mitigation of no NDMA support would have to mediate the MMIO on a
a performance doorbell path, there is no escaping a performance
hit. I'm not sure what you mean

> > > Some discussion of this requirement would be useful in the doc,
> > > otherwise it seems easier to deprecate the v1 migration region
> > > sub-type, and increment to a v2 where NDMA is a required feature.  
> > 
> > I can add some words a the bottom, but since NDMA is a completely
> > transparent optional feature I don't see any reason to have v2.
> 
> It's hardly transparent, aiui userspace is going to need to impose a
> variety of loosely defined restrictions for devices without NDMA
> support.  It would be far easier if we could declare NDMA support to be
> a requirement.

It would make userspace a bit simpler at the cost of excluding or
complicating devices like hns for a use case they don't care about.

On the other hand, the simple solution in qemu is when there is no
universal NDMA it simply doesn't include any MMIO ranges in the
IOMMU.

> As I think Connie also had trouble with, combining device_state with
> IOMMU migration features and VMM state, without any preceding context
> and visual cues makes the section confusing.  I did gain context as I
> read further though the doc, but I also had the advantage of being
> rather familiar with the topic.  Maybe a table format would help to
> segment the responsibilities?

I moved the context to the bottom exactly because Connie said it was
confusing at the start. :)

This is a RST document so I not keen to make huge formatting
adventures for minimal readability gain.

I view this as something that probably needs to be read a few times,
along with the code and header files for someone brand new to
understand. I'm Ok with that, it is about consistent with kernel docs
of this level.

What I would like is if userspace focused readers can get their
important bits of information with less work.

> > It is exsisting behavior of qemu - which is why we documented it.
> 
> QEMU resets devices as part of initializing the VM, but I don't see
> that QEMU specifically resets a device in order to transition it to
> the RESUMING device_state. 

We instrumented the kernel and monitored qemu, it showed up on the
resume traces.

> > Either qemu shouldn't do it as devices must fully self-reset, or we
> > should have it part of the canonical flow and devices may as well
> > expect it. It is useful because post VFIO_DEVICE_RESET all DMA is
> > quiet, no outstanding PRIs exist, etc etc.
> 
> It's valid for QEMU to reset the device any time it wants, saying that
> it cannot perform a reset before transitioning to the RESUMING state is
> absurd.  Userspace can do redundant things for their own convenience.

I didn't say cannot, I said it shouldn't.

Since qemu is the only implementation it would be easy for drivers to
rely on the implicit reset it seems to do, it seems an important point
that should be written either way.

I don't have a particular requirement to have the reset, but it does
seem like a good idea. If you feel strongly, then let's say the
opposite that the driver must enter RESUME with no preconditions,
doing an internal reset if required.

> We don't currently specify any precondition for a device to enter the
> RESUMING state.  The driver can of course nak the state change with an
> errno, or hard nak it with an errno and ERROR device_state, which would
> require userspace to make use of VFIO_DEVICE_RESET.

I don't think we should be relying on every driver doing something
totally differnt on the standard path. That is only going to hurt
interoperability.

> > > As with the previous flows, it seems like there's a ton of implicit
> > > knowledge here.  Why are we documenting these here rather than in the
> > > uAPI header?  
> > 
> > Because this is 300 lines already and is too complicated/long to
> > properly live in a uapi header.
> 
> Minimally we need to resolve that this document must be consistent with
> the uAPI.  I'm not sure that's entirely the case in this draft.

Can you point to something please? I can't work with "I'm not sure"

IMO the header file doesn't really say much and can be read in a way
that is consistent with this more specific document.

> >  - qemu doesn't support P2P cases due to the NDMA topic
> 
> Or rather QEMU does support p2p cases regardless of the NDMA topic.

I mean support in a way that is actually usable as without NDMA it
corrupts the VM when it migrates it.

> >  - simple devices like HNS will work, but not robustly in the face of
> >    a hostile VM and multiple VFIO devices.
> 
> So what's the goal here, are we trying to make the one currently
> implemented and unsupported userspace be the gold standard to which
> drivers should base their implementation?  

I have no idea anymore. You asked for docs and complete picture as a
percondition for merging a driver. Here it is.

What do you want?

> We've tried to define a specification that's more flexible than a
> single implementation and by these standards we seem to be flipping
> that implementation back into the specification.

What specification!?! All we have is a couple lines in a header file
that is no where near detailed enough for multi-driver
interoperability with userspace. You have no idea how much effort has
been expended to get this far based on the few breadcrumbs that were
left, and we have access to the team that made the only other
implementation!

*flexible* is not a specification.

> Userspace can attempt RESUMING -> RUNNING regardless of what we specify,
> so a driver needs to be prepared for such an attempted state change
> either way.  So what's the advantage to telling a driver author that
> they can expect a given behavior?

The above didn't tell a driver author to expect a certain behavior, it
tells userspace what to do.

> It doesn't make much sense to me to glue two separate userspace
> operations together to say these must be done in this sequence, back to
> back.  If we want the device to be reset in order to enter RESUMING, the
> driver should simply reset the device as necessary during the state
> transition.  The outward effect to the user is to specify that device
> internal state may not be retained on transition from RUNNING ->
> RESUMING.

Maybe, and I'm happy if you want to specify this instead. It just
doesn't match what we observe qemu to be doing.

> > Do you have an alternative language? This is quite complicated, I
> > advise people to refer to mlx5's implementation.
> 
> I agree with Connie on this, if the reader of the documentation needs
> to look at a specific driver implementation to understand the
> reasoning, the documentation has failed.  

Lets agree on some objective here, this is not trying to be fully
comprehensive, or fully standalone. It is intended to drive agreement,
be informative to userspace, and be supplemental to the actual code.

> If it can be worked out by looking at the device_state write
> function of the mlx5 driver, then surely a sentence or two for each
> priority item can be added here.

Please give me a suggestion then, because I don't know what will help
here?

> Part of the problem is that the nomenclature is unclear, we're listing
> bit combinations, but not the changed bit(s) and we need to infer the
> state.

Each line lists the new state, the changed bits are thus any bits that
make up the new state.

If you look at how mlx5 is constructed each if has a 'did it change'
test followed by 'what state is it in now'

So the document is read as listing the order the driver enters the new
states. I clarified it as ""must process the new device_state bits in
a priority order""

> flips in the presence of an existing state.  I'm not able to obviously
> map the listing above to the latest posted version of the mlx5 driver.

One of the things we've done is align mlx5 more clearly to this. For
instance it no longer has a mixture of state and old state in the if
statements, it always tests the new state so the tests logically
follow what is written here

Stripping away the excess the expressions now look like this:

 !(state & VFIO_DEVICE_STATE_RUNNING)
 ((state & (VFIO_DEVICE_STATE_RUNNING | VFIO_DEVICE_STATE_SAVING)) == VFIO_DEVICE_STATE_SAVING))
 (state & VFIO_DEVICE_STATE_RESUMING)

Which mirror what is written here.

> > > > +  As Peer to Peer DMA is a MMIO touch like any other, it is important that
> > > > +  userspace suspend these accesses before entering any device_state where MMIO
> > > > +  is not permitted, such as !RUNNING. This can be accomplished with the NDMA
> > > > +  state. Userspace may also choose to remove MMIO mappings from the IOMMU if the
> > > > +  device does not support NDMA and rely on that to guarantee quiet MMIO.  
> > > 
> > > Seems that would have its own set of consequences.  
> > 
> > Sure, userspace has to make choices here.
> 
> It seems a bit loaded to suggest an alternative choice if it's not
> practical or equivalent.  Maybe it's largely the phrasing, I read
> "remove MMIO mappings" as to drop them dynamically, when I think we've
> discussed that userspace might actually preclude these mappings for
> non-NDMA devices such that p2p DMA cannot exist, ever.

I mean the latter. How about "never install MMIO mappings" ?

> > Overall it must work in this basic way, and devices have freedom about
> > what internal state they can/will log. There is just a clear division
> > that every internal state in the first step is either immutable or
> > logged, and that the second step is a delta over the first.
> 
> I agree that it's a reasonable approach, though as I read the proposed
> text, there's no mention of immutable state and no reason a driver
> would implement a dirty log for immutable state, therefore we seem to
> be suggesting such data for the stop-and-copy phase when it would
> actually be preferable to include it in pre-copy.

I'd say that is a detail we don't need to discuss/define, it has no
user space visible consequence.

> I think the fact that a user is not required to run the pre-copy
> phase until completion is also noteworthy.

This text doesn't try to detail how the migration window works, that
is a different large task. The intention is that the migration window
must be fully drained to be successful.

I added this for some clarity ""The entire migration data, up to each
end of stream must be transported from the saving to resuming side.""

> > Yishai has a patch already to add NDMA to mlx5, it will come in the
> > next iteration once we can agree on this document. qemu will follow
> > sometime later.
> 
> So it's not really a TBD, it's resolved in a uAPI update that will be
> included with the next revision?  Thanks,

There is a patch yes, the TBD here is to include a few words about how
to detect NDMA

Jason
