Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6E839988C
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 05:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbhFCDai (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 23:30:38 -0400
Received: from mga07.intel.com ([134.134.136.100]:61417 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229744AbhFCD0Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 23:26:24 -0400
IronPort-SDR: Lhh95kBgihuL6f2raskgvQMBxI8HWcLUyeuhAhjOFnaiaMxAioQj/FDRQ/1hfB4RAfu+kMTUCw
 3GcvjilqfUKQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10003"; a="267822168"
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="267822168"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 20:22:32 -0700
IronPort-SDR: cQP4sYRLvkF/zHOBchRoulg3qa0HJQBogVgvkCjQ22xPO+xxNdCKSa5LQu4iHrJQJvJBPqOgGU
 7QFs2h7WIU9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="617532119"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 02 Jun 2021 20:22:32 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 2 Jun 2021 20:22:31 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 2 Jun 2021 20:22:31 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 2 Jun 2021 20:22:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nm7nGn9jzqz1FnwY1ama4VoEWfbVLJ6x0agie7M3rFlUofb8pvwsgTfIJIWls6WFl0d8xycbvaTvDdWDXvudyb6fRaAxcTetzCOGj+jiueHbg1t8Lf64H7pWp5Bd/vYdl8nwPgiU2sScvVjwqdGwy9sUVRpWm0QX7qcRxCWf5o9/ULPBJT3YrHH9gRfM4+P+bb+AD9EZRL37lyRit7+CyEGb+eTW2ZB8LyLqXlhKVIkICUjNSLwINeadC5fJ7sYMJJWGo8BRQcq2HwlbfI2zeYDXgyUWYVWOV7ecb6aw7i6AtO9WA5obj2B7hqAbeKMMcpu9maEnf+3PerRaCBmycA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jVhIy9ruIgg2oHhogpeFTXpGE0LiX2iV4cwfOSQV/XI=;
 b=nBy9I0jxj5+PASWBafBIaQn4qTk60Q7ffU9+pKdFsRJiUkDEKvjhzro/z5d44LmA+5kBOPtYJqUKkhZn06acBf8XcVdS+KuU9CE/e+iSLe0IfplKPQvMmaGzwhWqNXTxBPG0+dObBto5nILLPxVdhT0PUuLs4UABcSV3djTWQMxDe5B/4a+qUKVzz+OZXMpZEL+c3uVs8aAi41LGT7Lvbo8x+tgLnLXjhFFhw/887uDSXpCCMxoKfj12mqD+EIjb3K1sWvQcpvV3A2E80lKneu5qkhkWzg/1edcPBCld7dqKSCR2g8uk4IIOT9SdVFR+uHBu1E9R/jayDPgUB3LtkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jVhIy9ruIgg2oHhogpeFTXpGE0LiX2iV4cwfOSQV/XI=;
 b=WA3OpBWCwtLy0k2dhwh1fh85hbaawgIyyL7YT8WQ8l9Ejb3gQZ/TL81v7qkwwRLTdm1mDH/9TqMlIdV9bqSd52HKnzf5G9jBFCWZU84NFKV+74SxDE2BjBGFFQ2KELCyiC9Qh2bfCrqKtwhE9bQnfvP04pVttVbC28e354FddCM=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB0030.namprd11.prod.outlook.com (2603:10b6:301:65::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Thu, 3 Jun
 2021 03:22:28 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4173.030; Thu, 3 Jun 2021
 03:22:28 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: RE: [RFC] /dev/ioasid uAPI proposal
Thread-Topic: [RFC] /dev/ioasid uAPI proposal
Thread-Index: AddSzQ970oLnVHLeQca/ysPD8zMJZwBL2ymAAKTbxpAAKSt7gAAHpf9wAB1YcAAAAm5sgAAA1YgAAADonIAAAEmcgAABzCaAAAHbfwAAAYTsAAAEeLUAAAiRJwAAAHcmwA==
Date:   Thu, 3 Jun 2021 03:22:27 +0000
Message-ID: <MWHPR11MB1886DC8ECF5D56FE485D13D58C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210601162225.259923bc.alex.williamson@redhat.com>
        <MWHPR11MB1886E8454A58661DC2CDBA678C3D9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210602160140.GV1002214@nvidia.com>
        <20210602111117.026d4a26.alex.williamson@redhat.com>
        <20210602173510.GE1002214@nvidia.com>
        <20210602120111.5e5bcf93.alex.williamson@redhat.com>
        <20210602180925.GH1002214@nvidia.com>
        <20210602130053.615db578.alex.williamson@redhat.com>
        <20210602195404.GI1002214@nvidia.com>
        <20210602143734.72fb4fa4.alex.williamson@redhat.com>
        <20210602224536.GJ1002214@nvidia.com>
 <20210602205054.3505c9c3.alex.williamson@redhat.com>
In-Reply-To: <20210602205054.3505c9c3.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.142.24]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 746f4b84-b5ae-44b4-6453-08d9263ed0ca
x-ms-traffictypediagnostic: MWHPR11MB0030:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB003040D8451CB26B341DD8078C3C9@MWHPR11MB0030.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IAlxz96MqYEUEWyexWGJCluAXA9aejXoMy0APElM24tANJmqFxUAQgqRkBNW3B53VxMT7wo5gW59sfrDyBVdYsEZsAdPx9cIODXCKb+pWzvz2Kzx76HdrwHWilQMWKROqfuRrTy8QirDiLJMANAwinHnGPSlBQv73iycTa41MiwiQdI+Atdib7T5yCPZ6LtEW007XLkZodnx4uPKFm00Jv2AarX05+umorf4G7LJU9EOAzpNhdGnqhLGVDmU4mMTkPIuf9PGs+idfnQ6voIv20RyicAJRZ0N8vARV6pkwP/Ep5cRGfsZE7L8V3OL5l68Vh3dKbHQY3uJl9KytSYzNplfw/PhdlrAgqCvlhVNp7ac/S+11skFhkHIa7wAhIMS44JWrMakBSZHFcLg+9JBhooKl5eT82n5cQ96XTXXGNJMnj2ImYSNwEzbFXm+td65rVHVNTrzQeYorf16z+fHNyv9EDnkhmPjl0C58Oft+0ImkyF8x+fJMV8h5C+run/FAaTkwpP/zDc+E2lGyFuwahuTFUrwHM4VhSKazn8SqLpjyKyWKAScAfdnusZkJVC24PRGoHHm60oR4/GoQEtN3azfS3VyKcKRR/Q8FyiM0ag=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(376002)(366004)(39860400002)(86362001)(8936002)(6506007)(52536014)(478600001)(316002)(9686003)(186003)(83380400001)(64756008)(66556008)(71200400001)(66476007)(38100700002)(55016002)(122000001)(66946007)(66446008)(110136005)(76116006)(8676002)(7696005)(4326008)(26005)(7416002)(2906002)(54906003)(33656002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?lU5VMyxjEkHh7uhSYh0xn/hQ2xXZBo+z5QAFfvoacBlWar88xI5pevjRPXDD?=
 =?us-ascii?Q?lBJYpj0UAR5M5qZC36tZTSpRVvFqIgvXlIUKe3JsLUlPHcczCVXSzTWT3AsH?=
 =?us-ascii?Q?OD608aVA74u28q9DZCv19BQ2IEc8CzMk9Wp3QX7WWeQUp3UZtzmTJqLOSs2Y?=
 =?us-ascii?Q?eJOCXvH3H1+EpRQBx1yQrDY7EMbGxUPIt5vrF6PzJuld88h7X1qN+ZYJKOj9?=
 =?us-ascii?Q?h+/qTBEZyvO5k+MCBXuLMqPtk3zqKVtk+PyAVmoEWMY6W1qMvNZRC4ONprst?=
 =?us-ascii?Q?1Uvcu2iCORzpGCPaOPeXa5znO69iyFrWi1CzvV6D/y+nrSHiZUf1nbs50TE5?=
 =?us-ascii?Q?OnJ6zZd/6kPP1Wxn/FZe2/ey3p+iQIcV5gqFnwyFwR8JZjc4JpUi6SG9r7/3?=
 =?us-ascii?Q?+X/rIIQ8fbAS/thYGfP7StgFcJxZ8W1WJgBdQmzVLzgvhMC0UUIfnCevPbmJ?=
 =?us-ascii?Q?lk/b7eJ0BdGowjY8JEB9pNm5IJ5w9ZZvRUwm91z7b4Nz+qYZTBsOfODuWAeq?=
 =?us-ascii?Q?BGk7lg+ZGErJ/hagN7DLlL0uAuYI+YhOdui+OmeNbIgxFNS0T6mrx4JC+JcZ?=
 =?us-ascii?Q?O/g7yTdc3j0elMjhVX6t6D1LihSsLZgi/V7t4MA+7xlqkuZMvWb3GEmn2jIr?=
 =?us-ascii?Q?EM91fa1v4yeOrprBMwETaHnx+ZHaCu+nTJTiM0qkmMDRjFKu6n7feYkiB4Bj?=
 =?us-ascii?Q?F8nL5HIXab+nc9eMNeA8O9xbwX2hyWFewDxcYgurNEgdr63IxzO5j1a+OZ/D?=
 =?us-ascii?Q?nElnDCLbWaACOlQKTe4r7NRFD6WeDmNWgNBNjmGPP3GRO6zJSLXQDXFOLlWG?=
 =?us-ascii?Q?LHK1yg7TZzt6eaX6/w0ulvIN5o9u0phT/+TIjOYBmJmabqkp+/nSOwffphGH?=
 =?us-ascii?Q?Om8Duf0scBGYMt6rXcyzDtXScx88MxayEuctaICING4x1dczeL1TUwxDUdYc?=
 =?us-ascii?Q?DuXU8uKsjKnAFwdx417a9fDLldLkt+XEQcIMNB0+iaLGvIKwTCYmXx7mWlhP?=
 =?us-ascii?Q?JriaWXzDxry2OK2jQg7ZXjfkwJwqEcLm2AVZcgjYILV1P1CWlWDCWxsgNiYg?=
 =?us-ascii?Q?Ky4eq2RbgA4udkShffX6Nr9LV3NevJiOcYYg2MZRrnvwQwUpeH8bJTLtS4YS?=
 =?us-ascii?Q?zUyVluQfrvb9DmVTOHcE8nrCoLjvCXzjWbGsnoHl4GnhC3gTx+IlMVrtSova?=
 =?us-ascii?Q?CD4Bd7lTDTsekgrPs3SPpI7QCVEzMH4Sen9b/1fgj0PelhAly79Y78RMvK6a?=
 =?us-ascii?Q?SU+i3D5N5LvhCtcvtr3zFq3x5s1FWV8PnPPU+IAT8LHTN1MW2boLrg1JLgPc?=
 =?us-ascii?Q?zOQR/o/yr5q+YTVqEerN5ocI?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 746f4b84-b5ae-44b4-6453-08d9263ed0ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 03:22:28.0559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rwdqsGeOicFqvCnqQ4qPdmqbL2nf3L64N6Hd4C4XC4PPwIXSHkeJosVgGEas+pVXf12Gkxk+fHV5UTdoySmkJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB0030
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, June 3, 2021 10:51 AM
>=20
> On Wed, 2 Jun 2021 19:45:36 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>=20
> > On Wed, Jun 02, 2021 at 02:37:34PM -0600, Alex Williamson wrote:
> >
> > > Right.  I don't follow where you're jumping to relaying DMA_PTE_SNP
> > > from the guest page table... what page table?
> >
> > I see my confusion now, the phrasing in your earlier remark led me
> > think this was about allowing the no-snoop performance enhancement in
> > some restricted way.
> >
> > It is really about blocking no-snoop 100% of the time and then
> > disabling the dangerous wbinvd when the block is successful.
> >
> > Didn't closely read the kvm code :\
> >
> > If it was about allowing the optimization then I'd expect the guest to
> > enable no-snoopable regions via it's vIOMMU and realize them to the
> > hypervisor and plumb the whole thing through. Hence my remark about
> > the guest page tables..
> >
> > So really the test is just 'were we able to block it' ?
>=20
> Yup.  Do we really still consider that there's some performance benefit
> to be had by enabling a device to use no-snoop?  This seems largely a
> legacy thing.

Yes, there is indeed performance benefit for device to use no-snoop,
e.g. 8K display and some imaging processing path, etc. The problem is
that the IOMMU for such devices is typically a different one from the
default IOMMU for most devices. This special IOMMU may not have
the ability of enforcing snoop on no-snoop PCI traffic then this fact
must be understood by KVM to do proper mtrr/pat/wbinvd virtualization=20
for such devices to work correctly.

>=20
> > > This support existed before mdev, IIRC we needed it for direct
> > > assignment of NVIDIA GPUs.
> >
> > Probably because they ignored the disable no-snoop bits in the control
> > block, or reset them in some insane way to "fix" broken bioses and
> > kept using it even though by all rights qemu would have tried hard to
> > turn it off via the config space. Processing no-snoop without a
> > working wbinvd would be fatal. Yeesh
> >
> > But Ok, back the /dev/ioasid. This answers a few lingering questions I
> > had..
> >
> > 1) Mixing IOMMU_CAP_CACHE_COHERENCY
> and !IOMMU_CAP_CACHE_COHERENCY
> >    domains.
> >
> >    This doesn't actually matter. If you mix them together then kvm
> >    will turn on wbinvd anyhow, so we don't need to use the DMA_PTE_SNP
> >    anywhere in this VM.
> >
> >    This if two IOMMU's are joined together into a single /dev/ioasid
> >    then we can just make them both pretend to be
> >    !IOMMU_CAP_CACHE_COHERENCY and both not set IOMMU_CACHE.
>=20
> Yes and no.  Yes, if any domain is !IOMMU_CAP_CACHE_COHERENCY then
> we
> need to emulate wbinvd, but no we'll use IOMMU_CACHE any time it's
> available based on the per domain support available.  That gives us the
> most consistent behavior, ie. we don't have VMs emulating wbinvd
> because they used to have a device attached where the domain required
> it and we can't atomically remap with new flags to perform the same as
> a VM that never had that device attached in the first place.
>=20
> > 2) How to fit this part of kvm in some new /dev/ioasid world
> >
> >    What we want to do here is iterate over every ioasid associated
> >    with the group fd that is passed into kvm.
>=20
> Yeah, we need some better names, binding a device to an ioasid (fd) but
> then attaching a device to an allocated ioasid (non-fd)... I assume
> you're talking about the latter ioasid.
>=20
> >    Today the group fd has a single container which specifies the
> >    single ioasid so this is being done trivially.
> >
> >    To reorg we want to get the ioasid from the device not the
> >    group (see my note to David about the groups vs device rational)
> >
> >    This is just iterating over each vfio_device in the group and
> >    querying the ioasid it is using.
>=20
> The IOMMU API group interfaces is largely iommu_group_for_each_dev()
> anyway, we still need to account for all the RIDs and aliases of a
> group.
>=20
> >    Or perhaps more directly: an op attaching the vfio_device to the
> >    kvm and having some simple helper
> >          '(un)register ioasid with kvm (kvm, ioasid)'
> >    that the vfio_device driver can call that just sorts this out.
>=20
> We could almost eliminate the device notion altogether here, use an
> ioasidfd_for_each_ioasid() but we really want a way to trigger on each
> change to the composition of the device set for the ioasid, which is
> why we currently do it on addition or removal of a group, where the
> group has a consistent set of IOMMU properties.  Register a notifier
> callback via the ioasidfd?  Thanks,
>=20

When discussing I/O page fault support in another thread, the consensus
is that an device handle will be registered (by user) or allocated (return
to user) in /dev/ioasid when binding the device to ioasid fd. From this=20
angle we can register {ioasid_fd, device_handle} to KVM and then call=20
something like ioasidfd_device_is_coherent() to get the property.=20
Anyway the coherency is a per-device property which is not changed=20
by how many I/O page tables are attached to it.

Thanks
Kevin
