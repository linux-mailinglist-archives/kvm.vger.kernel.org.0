Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9AEB371656
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 15:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234284AbhECOAk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 10:00:40 -0400
Received: from mail-dm6nam12on2088.outbound.protection.outlook.com ([40.107.243.88]:65281
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230431AbhECOAj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 10:00:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RK93RX0hnQr4aj92te+w0ep1KM66gl4lyCUA7MdOYWYVXGUIBw2+mA/UnTlhUdXX6REjmFoyLm74ZQNg/GVmsRP8VhqjSlottRsZSKaYsUHlibNr5K2TCG/HO0UkY5OKUFgc3Qknqu1y6iS+rv293koD9CEtEPVulLVryLH1OCZuOY3sbkoJ0hSksPNCvZFCzvWRjvITk29TD2OxnCLH4MMgF8i7iV6lzvMBM+pvbviI4qEVTaIRDj7YJ9yomU1oD70IE2ofJCG2XiI3o+cJuDJGuuBNfuekeYbBpeIgfIrIlb23OSyd3XnOvFUNxaYK0mAgcfaQGQDD2qB1YDkudA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IfXZNEZrFmlYV/mP2EmA0FrW/ZCornxPXkq8D0E+5k4=;
 b=R+C+m2G/uAABH+VLCWzWpMo6tzsmKWedkMj1P0ybhedJcZO9h3yD3EH5bNNrRyaHwlreE6igweneA8nkqT2/MxCjcUnxdtKrfBV0pIqqLMBMtnRRdqHMgZnoA0QqNXXumRJGEKsHJMD+CsysKZi15H54ywyVPqz7Q6/oFmYLA5V9Zicl3Nn30AXhHHPFnrb85dkZjNsBnZC0CgWyPcvjbd7rXz/FpioJD1IogJv5MIePx0ca96ALMFs2UK6D6yMO1eIoZEMifEWvJU+k9K5mvMzo9oDdki/AOhQn35kY+rKNgCXIM5yIN8mcTcRnFUJH8ptxwQWUqd4Un7Subz8K3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IfXZNEZrFmlYV/mP2EmA0FrW/ZCornxPXkq8D0E+5k4=;
 b=sk0jgYY6pvICYxscWo6yeO8wvDckujBInyvcyr0UBQTo49yMZ4uwxI/EZuzsmztblDfEa5SC8eHJB5NGajk4sTTEoc0pXaiOx3zMm/nm/vfMscb8QIW+sNKVgCocTM6daPWpz2nPGoUDAgyzm41uTEgja3NGr5tAKmHTrgICWVk7wae/Rgr9HYKK/Y5G62igBX5wWX0wsGuaXpKbrdO/RU4LtT1tZLKwcWDuoq0H7FpqrhXTJsFSwOmVZLP1Q2xK9HKCpujGOZvc/BXW3+z8KBWDgEw+QLlbedNhZ3e6XbdtXH/WxMAWckGsqhaSgJFsbmqdvg9a1ztSGzvoxrk6oA==
Received: from BL0PR12MB2532.namprd12.prod.outlook.com (2603:10b6:207:4a::20)
 by MN2PR12MB3856.namprd12.prod.outlook.com (2603:10b6:208:168::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.26; Mon, 3 May
 2021 13:59:43 +0000
Received: from BL0PR12MB2532.namprd12.prod.outlook.com
 ([fe80::5105:e8df:9631:bf0f]) by BL0PR12MB2532.namprd12.prod.outlook.com
 ([fe80::5105:e8df:9631:bf0f%5]) with mapi id 15.20.4087.044; Mon, 3 May 2021
 13:59:43 +0000
From:   Vikram Sethi <vsethi@nvidia.com>
To:     Mark Kettenis <mark.kettenis@xs4all.nl>,
        Marc Zyngier <maz@kernel.org>
CC:     Shanker Donthineni <sdonthineni@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "will@kernel.org" <will@kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "christoffer.dall@arm.com" <christoffer.dall@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Sequeira <jsequeira@nvidia.com>
Subject: RE: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
Thread-Topic: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
Thread-Index: AQHXPRTigOHff2apwEeawQns3nBPOqrL0MoAgAAM5gCAAAj7gIABBh4AgAAGT4CAADU7AIAACSoAgAABt+CAASvZAIACHFDwgAEVfYCAADdZj4AAAavQ
Date:   Mon, 3 May 2021 13:59:43 +0000
Message-ID: <BL0PR12MB253296086906C4A850EC68E6BD5B9@BL0PR12MB2532.namprd12.prod.outlook.com>
References: <20210429162906.32742-1-sdonthineni@nvidia.com>
 <20210429162906.32742-2-sdonthineni@nvidia.com>
 <20210429122840.4f98f78e@redhat.com>
 <470360a7-0242-9ae5-816f-13608f957bf6@nvidia.com>
 <20210429134659.321a5c3c@redhat.com>
 <e3d7fda8-5263-211c-3686-f699765ab715@nvidia.com>
 <87czucngdc.wl-maz@kernel.org>
 <1edb2c4e-23f0-5730-245b-fc6d289951e1@nvidia.com>
 <878s4zokll.wl-maz@kernel.org>
 <BL0PR12MB2532CC436EBF626966B15994BD5E9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <87eeeqvm1d.wl-maz@kernel.org>
 <BL0PR12MB25329EF5DFA7BBAA732064A7BD5C9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <87bl9sunnw.wl-maz@kernel.org> <c1bd514a531988c9@bloch.sibelius.xs4all.nl>
In-Reply-To: <c1bd514a531988c9@bloch.sibelius.xs4all.nl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: xs4all.nl; dkim=none (message not signed)
 header.d=none;xs4all.nl; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [12.97.180.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4c19da9f-8698-4e06-ebb8-08d90e3bb404
x-ms-traffictypediagnostic: MN2PR12MB3856:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR12MB3856A0A2A4FD9B2E7E1E3E15BD5B9@MN2PR12MB3856.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7bfVFllGAu0Rctoe2laR8ItnRhUUrhGOIwQ2NtpsRL9+3yJjFQ7qz65TynJt8mU2zy5hRV9HoCWoReDgNTwGmPqXHFi65PorRBLBC4pGMKbo6J1kLeNz9Jz9oEMdI1oYsmLvsb20z3rm9hsfCfTC16aiZrgUoPIMcdEj4KnUHHZV7oynxMT8RW9VXfDQKLm9NUGK1eMKxYNQQzYdKJrsVSsad0ERHqukHEIvDHZC6pTf+ytpND15lYFWvzqsAT0nmgn7A+fs7QfFgdpY3Cge0L/0x1Za1xxPXELFtIvAlx4u79Dq74ybpDGEFQwa+MuAZWXEiWoX326Lr2ykDYn5i7endG9awswWFwA9miYrnZjLMx35PHsbsiUMmd5CUiKIG2MQjG+iEeSub96aIbAWmGAM7gXS+8zx9P/ipAQ4BwisleQu5fXyVoNC2Puato6yo5d6DP7hTXWNJ3Iept08WtRuAmk4VW6dEbm7rY7LAhF+atHNXl/pEXNOwXn8x3GzTPgsiGZ50MD52zaA4ui2sz3mf45pE8W2wMMJMyaFuXNrVA3CMy+2SiHCqdnWVPpMbYq9jPstRIvPgwYwGCoIr31QG6LNQdd0Bx0HmtveNMe9XbFuGcrh5vxuBD7OaptOHIb/wEMagd/3AbET9P7/DUC9hP1WlFQSKcvWsrX6sZcxmwXiF2bntU4xMsB5F18fgG/F1hmnSJNiNcr9nbyEoXdO/mp19NatebR0i63yhb8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2532.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(39860400002)(136003)(376002)(7416002)(316002)(122000001)(8936002)(6506007)(76116006)(54906003)(38100700002)(83380400001)(66946007)(9686003)(66556008)(66446008)(7696005)(64756008)(66476007)(110136005)(2906002)(4326008)(478600001)(966005)(186003)(52536014)(26005)(33656002)(86362001)(8676002)(55016002)(71200400001)(107886003)(5660300002)(3714002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?C/lsuMpV6HBav/lo0+rYaKuicYAfF7Qfkf9nMVwpswsJWKjsF+b8StGGgsCG?=
 =?us-ascii?Q?UWpBvhQrobEuCG7TNFNh75yUiLPs+uS6bTzO+O3SDiUBCfoKQFTA9zMyo82z?=
 =?us-ascii?Q?Dk1Noev0hTqTgLpjMlP3bVc9+0noVf3gbAppwV8dKhLRuFJGus0xRUG9Dhvm?=
 =?us-ascii?Q?9JIslXuWFOMQHaS4nxms4me7M6U5xtiF/S4CMnWInEh8NL6U8ByYG3wrNLaD?=
 =?us-ascii?Q?ts0D533nsZrDErLO1k0vdPxLQiN6qVZcp7IyVwgDyuQu2An9VcOoGOA02AK6?=
 =?us-ascii?Q?SeXpFfsSApwrMg2IiV8gy2A8qdv1Mojv86QUdaPPS0n0l1l4xPW6NI1fEqI4?=
 =?us-ascii?Q?ze3ObdxzT73zEdBB91Vhga4HlBAsk5OYLbTuulHv70vZ6HLcKXXB3qJrpYUQ?=
 =?us-ascii?Q?9RSmfutNPbt1A0FHpDAbSWdJzNri2KDaRBDsJTHmGGGXq7U08Jg4ugfNjgSm?=
 =?us-ascii?Q?4uhCUbDo3uYal9njloPISRRPREm4Ce3Ra2DlDQxyjEMEJGnj42+pHQ/oPMXJ?=
 =?us-ascii?Q?NG6DbcYW2C9Tg5fccX5rgev/Y0xNkGCDZC0u+zafpHT1nrNSa6sZz9qfxQMH?=
 =?us-ascii?Q?fUla48EObuEQ5HaPPMy+PPAsGuqQoBKRVhPslStaTWxknv5JUacNG5npRQk+?=
 =?us-ascii?Q?c6YArORpbXD54Ybcx0sBE8NZiXQqhbmJoe2UbTfsBd/WXUvYzEK/CWr4n1TL?=
 =?us-ascii?Q?Hf46xPC2zEkNQDIfi3y9DwRJQNzg6tfBomWUWYTVkvmPfGfQ17ToHbgEN9Of?=
 =?us-ascii?Q?r9Ytp/+/jZJvDPgBinbAutfkFHedTrP1zSb80E/3UCfeenpBr3lTD1Qnes/Y?=
 =?us-ascii?Q?UIheAvKPZCtam6Sw6VSpGaqYwfsV65qGuroLqR/xK6Cue4FBUVv29yoUWLrx?=
 =?us-ascii?Q?aYU7HdljYSj0IuqKibvNu5DvFewDM0w4itEw0rdsfnVVTJw+z1nLLXYuPDhb?=
 =?us-ascii?Q?j7cD8Sd7kDIyzeSi9HMh2nHsy1QNtUYJKX3M0XXlC8+hZsntMLzzzLE6uc+A?=
 =?us-ascii?Q?Lw5p8FrZt4t9tfB2mFg3Z3sGwEeOL5miBKaAz7AG7/8fyjo/9Bm49Jv1dSM8?=
 =?us-ascii?Q?Qgv8bRoiwRX0kuIy+AB2ocucdf94iZiIgZhERhj7EPNI6iHIzStHr8Q3jMNm?=
 =?us-ascii?Q?2KWiuO+kMelIa9eYik1T8bJt4vWor0+4tZBkaGA9e+9p5GyDQycxmXZi52th?=
 =?us-ascii?Q?MeRo998/1EBk2XkJO/BmndGoOg1zZ5MuxrS9sLeUU/AaTYpkmkrl4GMBQs1V?=
 =?us-ascii?Q?CoNrXQHxNfefPUAIwfuJCxqTgvs58wdVs5q1ZdGVRi8bNY24ky4Xefs+Syef?=
 =?us-ascii?Q?AYk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2532.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c19da9f-8698-4e06-ebb8-08d90e3bb404
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2021 13:59:43.3667
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lCO7HUdTBV/WRyvNvWJRiVSjeWjygIkM4Nz0oIIiLptXif1SCsq0nXnv+D8DbINj00x+qLqyf9JnVgtGDdeiQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3856
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> From: Mark Kettenis <mark.kettenis@xs4all.nl>
> > From: Marc Zyngier <maz@kernel.org>

snip
> > If, by enumerating the properties of Prefetchable, you can show that
> > they are a strict superset of Normal_NC, I'm on board. I haven't seen
> > such an enumeration so far.
> >
snip
> > Right, so we have made a small step in the direction of mapping
> > "prefetchable" onto "Normal_NC", thanks for that. What about all the
> > other properties (unaligned accesses, ordering, gathering)?
>=20
Regarding gathering/write combining, that is also allowed to prefetchable p=
er PCI spec
From 1.3.2.2 of 5/0 base spec:
A PCI Express Endpoint requesting memory resources through a BAR must set t=
he BAR's Prefetchable bit unless
the range contains locations with read side-effects or locations in which t=
he Function does not tolerate write
merging.
Further 7.5.1.2.1 says " A Function is permitted
to mark a range as prefetchable if there are no side effects on reads, the =
Function returns all bytes on reads regardless of
the byte enables, and host bridges can merge processor writes into this ran=
ge139 without causing errors"

The "regardless of byte enables" suggests to me that unaligned is OK, as on=
ly=20
certain byte enables may be set, what do you think?

So to me prefetchable in PCIe spec allows for write combining, read without
sideeffect (prefetch/speculative as long as uncached), and unaligned. Regar=
ding
ordering I didn't find a statement one way or other in PCIe prefetchable de=
finition, but
I think that goes beyond what PCIe says or doesn't say anyway since reorder=
ing can=20
also happen in the CPU, and since driver must be aware of correctness issue=
s in its=20
producer/consumer models it will need the right barriers where they are req=
uired=20
for correctness anyway (required for the driver/userspace to work on host w=
/ ioremap_wc).

But perhaps the bigger question is since WC doesn't exist as a Memory type
on armv8, yet we are trying to fit something onto ioremap_wc which came fro=
m
x86 world, shouldn't the arm64 MT we use for WC match the semantics of=20
whatever drivers and userspace expected from ioremap_wc as defined on=20
x86, which as Mark notes below includes unaligned? If we agree to that,=20
we can codify it in the documentation of ioremap_wc and allow for
Normal NC on arm64 for ioremap_wc in host or guest.=20
Beyond that, if we don't want to do it automatically based on prefetchable
but from explicit call from userspace is fine too.=20

> On x86 WC:
>=20
> 1. Is not cached (but stores are buffered).
>=20
> 2. Allows unaligned access just like normal memory.
>=20
> 3. Allows speculative reads.
>=20
> 4. Has weaker ordering than normal memory; [lsm]fence instructions are
>    needed to guarantee a particular ordering of writes with respect to
>    other writes and reads.
>=20
> 5. Stores are buffered.  This buffer isn't snooped so it has to be
>    flushed before changes are globally visible.  The [sm]fence
>    instructions flush the store buffer.
>=20
> 6. The store buffer may combine multiple writes into a single write.
>=20
> Now whether the fact the unaligned access is allowed is really part of th=
e
> semantics of WC mappings is debatable as x86 always allows unaligned
> access, even for areas mapped with ioremap().
>=20
> However, this is where userland comes in.  The userland graphics stack do=
es
> assume that graphics memory mapped throug a prefetchable PCIe BAR
> allows unaligned access if the architecture allows unaligned access for
> cacheable memory.  On arm64 this means that such memory needs to be
> "Normal NC".  And since kernel drivers tend to map such memory using
> ioremap_wc() that pretty much implies ioremap_wc() shoul use "Normal NC"
> as well isn't it?
>=20
> > > > How do we translate this into something consistent? I'd like to
> > > > see an actual description of what we *really* expect from WC on
> > > > prefetchable PCI regions, turn that into a documented definition
> > > > agreed across architectures, and then we can look at implementing
> > > > it with one memory type or another on arm64.
> > > >
> > > > Because once we expose that memory type at S2 for KVM guests, it
> > > > becomes ABI and there is no turning back. So I want to get it
> > > > right once and for all.
> > > >
> > > I agree that we need a precise definition for the Linux ioremap_wc
> > > API wrt what drivers (kernel and userspace) can expect and whether
> > > memset/memcpy is expected to work or not and whether aligned
> > > accesses are a requirement.
> > > To the extent ABI is set, I would think that the ABI is also already
> > > set in the host kernel for arm64 WC =3D Normal NC, so why should that
> > > not also be the ABI for same driver in VMs.
> >
> > KVM is an implementation of the ARM architecture, and doesn't really
> > care about what WC is. If we come to the conclusion that Normal_NC is
> > the natural match for Prefetchable attributes, than we're good and we
> > can have Normal_NC being set by userspace, or even VFIO. But I don't
> > want to set it only because "it works when bare-metal Linux uses it".
> > Remember KVM doesn't only run Linux as guests.
> >
> >       M.
> >
> > --
> > Without deviation from the norm, progress is not possible.
> >
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> >
