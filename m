Return-Path: <kvm+bounces-3595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96606805A2A
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 17:43:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B9982820CF
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 16:43:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DF4146AF;
	Tue,  5 Dec 2023 16:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JmAtBPbp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2082.outbound.protection.outlook.com [40.107.237.82])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12CD7135;
	Tue,  5 Dec 2023 08:43:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b90PWXvvjjy8972AC8GRECffrwcPtEei04JESS7EhSXuFZ+TNdVOhaVsPszrTc/jCHQBHUT7HvSrs7swStO6DyFCDfmLqGSopv43etyP2V9sGDUnIvyu/mAymx1auq1kzAH4DA//b3MTgFn2ayHlYBy6CCBR0lmhkmhnlO+DVmxZEYOt/l2Spd0G6CeJE0a21EfXy5NHv94PGybVgfTabYkMd+VVNhZCCvrQrzGVHDDrwQABLjWO8B2xpW+XzUowCI2+MZzDvzzT2z4vzIxReci8tM60jX6sRbsuaqNDOUux4dRkxUuJR/WQSMoEJCuWmImaSe1m42iXtsdCBcxGfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sQmwIwVYkauMGtvx1jGrLwI/4G4nT7X0iDtOCpiEUN8=;
 b=fSBMgCrnzd9O6H71ySZtHBh3WXjzd4Xla/X+9CBcoEu+UqLA1qAT4obI/0cOkSAgK+BJQrpzxZib6nsMetkq+2Y8jbqJzk1zSZbnKv6RlDP1W7Dpe/gb/hXXyocfJLvoce0tF50vW+JNh0PIvNiZrY5oc60rG/Qx9oa7JQp5eqo9D4Kg2LR1zciYYasSXk01/QxbmDVBIiDSiRtgmf1qiqQNDnnquRxsSXVS5pMMn0ELjAgDgVn8oXhaKf9TWV38pOpHnUSGlmHDbsfx4R9ZWktPcl6lUYCrxwzX9aPX8uqM7LWwix7ykGZ7dHr8eXVKjzYRM/is0436gjbr1vNr/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sQmwIwVYkauMGtvx1jGrLwI/4G4nT7X0iDtOCpiEUN8=;
 b=JmAtBPbpCBRDizDdY8uxV1z17TgyXogGUvuv37VmA0TI6/Om4huTborvfanHo5sLRr3DixUznDIHJr56oyKRI5iENN5MH/I0bjqW50bIAht57i3DWTx3KDSGSopIS7MH3vEUMeQcP6MJa44UP08cQd6Qr1/sebBtXLvgN84BcbCvqQ4s/YUTxs5MqL9pi5Lz82T8H3G3N8y/SMVG5zlYFnIps3ZxlJI/aAP29rv72u3J1qWvsFnsOzFglCLCGdHFpLHAyGKSeO7mKY+8RBCh6ZK53VBWpjscKWGmH/0kV1YV11WhvuQQmL1uEe8yMX0m201ULyys67MtywLpjRwf4w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH3PR12MB7764.namprd12.prod.outlook.com (2603:10b6:610:14e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 16:43:19 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 16:43:19 +0000
Date: Tue, 5 Dec 2023 12:43:18 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, ankita@nvidia.com,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	oliver.upton@linux.dev, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, will@kernel.org, ardb@kernel.org,
	akpm@linux-foundation.org, gshan@redhat.com, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, mochs@nvidia.com,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, lpieralisi@kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/1] KVM: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Message-ID: <20231205164318.GG2692119@nvidia.com>
References: <20231205033015.10044-1-ankita@nvidia.com>
 <86fs0hatt3.wl-maz@kernel.org>
 <ZW8MP2tDt4_9ROBz@arm.com>
 <20231205130517.GD2692119@nvidia.com>
 <ZW9OSe8Z9gAmM7My@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZW9OSe8Z9gAmM7My@arm.com>
X-ClientProxiedBy: BL0PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:208:2d::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH3PR12MB7764:EE_
X-MS-Office365-Filtering-Correlation-Id: b858a273-057a-4eb0-9869-08dbf5b1493c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	AFSbd5BvOwEA5LJLP7M0qa6FsN4m+jFsXh66gDbpnRsNY6c27/kM16Ix61Iwp+ShCcagycsz3eT63jRQ8ZDJ2XpgqTGyDPVAiH5FfVBukmCWR3yxbR0HCR1bXK7ojrOcTvb2L1jLJ7x9Gewf/Y04cn1OmjpYb1JRP6l74IKIS9WAvbtYVg79ljSs7PT84V9FFW3b0IfFpGv1xaWUflHJfaAW3G7NcgPyQcKIB8ewt/++txClIM465+IiLX6Fe3BtUVI2JUHYmU2lIjWC2yAaOaLavOGSvN1+HQMUotawj+XDvfcPTYPrhT6A05irpHUmFB5aieQ1BP77GMFPc/cSrgADxpyj9V32Pso/jGprDrt4KKYXjvlYA+WM04akpodxR3J7+N84jneDBI8PJpXND4diGS2+u9cBLS2WYcJecEecI20QLtt7hwtXyOyu2A1tqHUrcKwljEELUVkKWs8datvg+Uom6RhFGTexiVsDwDFw2s701RdUmjpFsbmhUkTU8Hiu9PblZs+8hqBxUmUf+scIMUvMNwG86zfOq7iVGFXRK69uQ/Jc8QPm5uRc8eF1
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(376002)(39860400002)(396003)(346002)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(54906003)(6916009)(66946007)(66556008)(316002)(66476007)(6486002)(478600001)(7416002)(5660300002)(41300700001)(36756003)(33656002)(2906002)(4326008)(8676002)(8936002)(83380400001)(86362001)(2616005)(26005)(1076003)(6506007)(38100700002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3VtKCITSQ1dFSVI/uuxAWlKZsmibVzIWRM4D8ml7r9UL1BIxGUotHUNV7eFh?=
 =?us-ascii?Q?LuhkUoFBSU1s+lrbsIt6PHsbl8nmhQEMZefl4rFQx4RH1jnyjW9Rp2JbWfrN?=
 =?us-ascii?Q?HFoo4/L8wxnmU/etfKahwcwbKvdCVZwvzyvROwPLSsLjYdrsTZSu1ppL5bxt?=
 =?us-ascii?Q?XJll5E0WmJAgm0yRLp1BqrsllztnPgzYxhm9cg6lKOP1+kEaAXE9Zp77I79m?=
 =?us-ascii?Q?VOTjs1pb5Tn/1iGR6Xb23wdS1PVOa0oxSZGy9AeMgPA0bG1vyBVBLHQpnnkU?=
 =?us-ascii?Q?IwyMtVWRNhMm2qb5DAPtubRKuV6KFcvvEJlWpDikeSWInxOVA8eN77vk5wi0?=
 =?us-ascii?Q?aPP55/fCd7mFkrMT/T3FrXlxMyCs/nR456CACEdyJ5aBPuf0V6CrQfpJgBlQ?=
 =?us-ascii?Q?zhYgLAVWVfI8P7z3aevVefmmDbNu1Wgltcq1fVztDlPV8kBXRTgtdWsKy+6l?=
 =?us-ascii?Q?ZIt7+evopfFh7rPWjRYEdyOy1Y1xewNEaV3cfoIGhdV5US8TMAhDC51sLDlK?=
 =?us-ascii?Q?TAiOKzEXvFZrJuAn9YIkHJ4UWHngEHq60sJOXXGH3iIybOyJxCxgRVKMPo+v?=
 =?us-ascii?Q?kJU0Ja/5lx7ouc82ozEetls9djsfrdD8aZJinHaCijithYEqKcst0OvosiO8?=
 =?us-ascii?Q?BO7T/YjpwrEQ32BLRnIAssjyPdWQZ/41oyaWsoa78WXVmNVyP5QxJKo5dwsV?=
 =?us-ascii?Q?8yddmyiri7QcETtySxH4jSW6hEio9pBPG5MkKSZgkXc/INpLkSqqwJkcyGIl?=
 =?us-ascii?Q?2hN47gbSjaxvktxiOK3cRhDckGZY6Uc5sxypk3U+A5luH6uNZEL/9Fxx2X/b?=
 =?us-ascii?Q?HdnWDXhxqWyHlyTIHsJOk2z5bOeQsGn523qQGJeoqF52X05EIE4oZVmEgeu8?=
 =?us-ascii?Q?8fbDkZ/Kdq2zWKxPpXc4nfpP4RbcNuuLHExH0ISkcfSIglc+tFEezfiRRSxn?=
 =?us-ascii?Q?HHpzLaGPdZmGUjyDp22I+anV9eS3eE6hl/Xlr2juVqhXb1gDNCiULN7z0wzE?=
 =?us-ascii?Q?3tob7IiBinAlcdVGuBpYVXFIhdJFHNZkD9m+Pp2WVZ6i+AoDCoGi3u18Edqr?=
 =?us-ascii?Q?q1q7e63NHrI8wg+Cg/obmp0ykmNKSAl0+qQP1ADJFvKyfwSqoJKIyYhWKGes?=
 =?us-ascii?Q?nqYJs+Zb1r5Mw9M8vgXfcpHPIXBSjYtxTsM+kNVX4Qzh8aFvXymr/+ZXE9p/?=
 =?us-ascii?Q?4ulGZ5RltW+RA3m2trgM9dS6PHM9pm7N+QPap5pzmxbO5jtBi54930BM88dV?=
 =?us-ascii?Q?Q8XeboSAMLl0JiRvT4/pyPJ3sA6paIQMub6QmljEnf7sT/iymbe0UIIYGlFt?=
 =?us-ascii?Q?NwHU3pkoLtKFyFi1U/9ln02/2+h7Fyic0dsVSdVGHVTtgsebrnsnXDBQkWhK?=
 =?us-ascii?Q?Z8EOFmNGFD+k9kMTlIBh5cvHvBG0gxWpxf6a/oKg+/KzHsD8QcRg1Vbaq355?=
 =?us-ascii?Q?NI1ZEMoUno1sBz7RTvWV1gccm3NWmEx0Z83MtR0BfXXZj+Q0CWGoLPvTrLmI?=
 =?us-ascii?Q?An6mQGQdbgeqXA7EI/+kBQoZnS4EqzdtemxobxbOKnvT1PYwttNK3AJNcoCV?=
 =?us-ascii?Q?gLFOakAp3pupuLZy2EPVYhTozdT5V3mLNoCYVKd/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b858a273-057a-4eb0-9869-08dbf5b1493c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 16:43:19.2296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DBkwKONxfo+tkoiwvyosd2V48YfjvPEGw933wLah4ia70uyuZJ9hLQWF2KapwYr4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7764

On Tue, Dec 05, 2023 at 04:22:33PM +0000, Catalin Marinas wrote:
> Yeah, I made this argument in the past. But it's a fair question to ask
> since the Arm world is different from x86. Just reusing an existing
> driver in a different context may break its expectations. Does Normal NC
> access complete by the time a TLBI (for Stage 2) and DSB (DVMsync) is
> completed? It does reach some point of serialisation with subsequent
> accesses to the same address but not sure how it is ordered with an
> access to a different location like the config space used for reset.
> Maybe it's not a problem at all or it is safe only for PCIe but it would
> be good to get to the bottom of this.

IMHO, the answer is you can't know architecturally. The specific
vfio-platform driver must do an analysis of it's specific SOC and
determine what exactly is required to order the reset. The primary
purpose of the vfio-platform drivers is to provide this reset!

In most cases I would expect some reads from the device to be required
before the reset.

> > Remember, the feedback we got from the CPU architects was that even
> > DEVICE_* will experience an uncontained failure if the device tiggers
> > an error response in shipping ARM IP.
> > 
> > The reason PCIe is safe is because the PCI bridge does not generate
> > errors in the first place!
> 
> That's an argument to restrict this feature to PCIe. It's really about
> fewer arguments on the behaviour of other devices. Marc did raise
> another issue with the GIC VCPU interface (does this even have a vma in
> the host VMM?). That's a class of devices where the mapping is
> context-switched, so the TLBI+DSB rules don't help.

I don't know anything about the GIC VCPU interface, to give any
comment unfortunately. Since it seems there is something to fix here I
would appreciate some background..
 
When you say it is context switched do you mean kvm does a register
write on every vm entry to set the proper HW context for the vCPU?

We are worrying that register write will possibly not order after
NORMAL_NC?

> > Thus, the way a platform device can actually be safe is if it too
> > never generates errors in the first place! Obviously this approach
> > works just as well with NORMAL_NC.
> > 
> > If a platform device does generate errors then we shouldn't expect
> > containment at all, and the memory type has no bearing on the
> > safety. The correct answer is to block these platform devices from
> > VFIO/KVM/etc because they can trigger uncontained failures.
> 
> Assuming the error containment is sorted, there are two other issues
> with other types of devices:
> 
> 1. Ordering guarantees on reclaim or context switch

Solved in VFIO
 
> 2. Unaligned accesses
> 
> On (2), I think PCIe is fairly clear on how the TLPs are generated, so I
> wouldn't expect additional errors here. But I have no idea what AMBA/AXI
> does here in general. Perhaps it's fine, I don't think we looked into it
> as the focus was mostly on PCIe.

I would expect AXI devices to throw errors in all sorts of odd
cases. eg I would not be surprised at all to see carelessly built AXI
devices error if ST64B is pointed at them. At least when I was
building AXI logic years ago I was so lazy :P

This is mostly my point - if the devices under vfio-platform were not
designed to have contained errors then, IMHO, it is hard to believe
that DEVICE_X/NORMAL_NC is the only issue in that HW.

> So, I think it would be easier to get this patch upstream if we limit
> the change to PCIe devices for now. We may relax this further in the
> future. Do you actually have a need for non-PCIe devices to support WC
> in the guest or it's more about the complexity of the logic to detect
> whether it's actually a PCIe BAR we are mapping into the guest? (I can
> see some Arm GPU folk asking for this but those devices are not easily
> virtualisable).

The complexity is my concern, and the disruption to the ecosystem with
some of the ideas given.

If there was a trivial way to convey in the VMA that it is safe then
sure, no objection from me.

My worry is this has turned from fixing a real problem we have today
into a debate about theoretical issues that nobody may care about that
are very disruptive to solve.

I would turn it around and ask we find a way to restrict platform
devices when someone comes with a platform device that wants to use
secure kvm and has a single well defined HW problem that is solved by
this work.

What if we change vfio-pci to use pgprot_device() like it already
really should and say the pgprot_noncached() is enforced as
DEVICE_nGnRnE and pgprot_device() may be DEVICE_nGnRE or NORMAL_NC?
Would that be acceptable?

Jason

