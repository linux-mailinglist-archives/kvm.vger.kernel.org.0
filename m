Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2563A92F4
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 08:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbhFPGpe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 02:45:34 -0400
Received: from mga12.intel.com ([192.55.52.136]:28036 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229559AbhFPGpd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Jun 2021 02:45:33 -0400
IronPort-SDR: opkk9u9ir9/xCW6nJYaiBr7P+iRnUoyNFuX4bk0v33H9h66z/ExF5bw4yIllH1CQCVC1JjoszK
 lLCSh6aSN3zg==
X-IronPort-AV: E=McAfee;i="6200,9189,10016"; a="185816934"
X-IronPort-AV: E=Sophos;i="5.83,277,1616482800"; 
   d="scan'208";a="185816934"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2021 23:43:27 -0700
IronPort-SDR: lfH7QjVh/dChZ3CHuoSys3WPv4BokLf+EzazIsqrtfwPPmCR3EU0mv5XHoF5VRWCa9+Cg9xVmQ
 whyTKaANFrvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,277,1616482800"; 
   d="scan'208";a="639906116"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga005.fm.intel.com with ESMTP; 15 Jun 2021 23:43:27 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 15 Jun 2021 23:43:26 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 15 Jun 2021 23:43:26 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Tue, 15 Jun 2021 23:43:26 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Tue, 15 Jun 2021 23:43:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XqpK+SIZcpGnjmDxSNXI0HsawzfoNLDq05lsqwMJvEFdsAvphrOyYmNcZIX5sC+wZxdKg/1khHYxU3t/iWG7K3oI3I/3kT1tM13Zjxq0xOTUIWTLay9Cx6PHzacLmzF70chlIw91hXRBwzMVLwD6RczcsCCfefTuAVB/TjDDm34eF5HmldZuwuq7lubgdPe9HjMG6Ogj/pl54atntd1iEl9tUR/QxHAeWmx/gaozNoR6Ezd1+Edk69WXhHIYCZAz0mfJ0jdABEXNbDclT/URWToWh6UxpiXFsryUFQyhaVoeYdeE+ioQl3VSY5Yp6bIgyMcLYKXaSjSWDVpZMBdMFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vh+SUIHwg9bD8tFdI7ru7jLF845ehG0jgW8pkkfcG3U=;
 b=Mk70N01usImwJsDzWZgldcRjUrbnBK1IVxAf70w4A63XV+bVZx4+KNLL6CXrswtcwQdJgiYORWNTr1Jb2sCwhctxfhrf+1Q8j28yOgX7Y8J+YnRMKgBffjp17zvlOt5Cikm4idN3BOW/0xC0OEx3tVN09DKe3LMuTTnnyPR1TAPJdBNuzAnkizSlnq2q2E16e5MK2CESeLWpaNrSsBLbZMWpJO/eqAh7oj0G44TztAfCcFRBTq0jHWDjzhGZ5tG8CwGdrjIUWUyryGGIpThEPtBc+Dai8K0h3lZzdqayCO3HcvbI0VpCGbBAR9RjNxULCi1yaueMx4Y0sld4FL6JGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vh+SUIHwg9bD8tFdI7ru7jLF845ehG0jgW8pkkfcG3U=;
 b=zp0oMYZQXStMGqwIbVhUYJCyQYUkimgCkd6Z3T/1o8mjswR5mA0lEEyD7hvDQYGATNjK2aVldBXCiq1MeRjD4NyEV0kUZWjsOHvdiCBtaSFnc4oeb8LE5ytgPB0jc4k2WerxXl+U3xn7qAQUX5r6euV158b0aQCc5mFuqOzyZ3o=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB2062.namprd11.prod.outlook.com (2603:10b6:300:2a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Wed, 16 Jun
 2021 06:43:24 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4219.026; Wed, 16 Jun
 2021 06:43:24 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "Kirti Wankhede" <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>
Subject: RE: Plan for /dev/ioasid RFC v2
Thread-Topic: Plan for /dev/ioasid RFC v2
Thread-Index: AddbO/WEUAFl3MPnRsG8exiH8bwEagB7l+uAAACIfoAAAdwYAAADDw6AAAHKgwAAANd4AAAAacwAAAT4QwAAK587AAA0n7GAAAYKlwAADDvuAAAgbLGAAF6lSYAABO0WAAATSRtQAB5ymYAAEyKHQA==
Date:   Wed, 16 Jun 2021 06:43:23 +0000
Message-ID: <MWHPR11MB188692A6182B1292FADB3BDB8C0F9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210609150009.GE1002214@nvidia.com>
        <YMDjfmJKUDSrbZbo@8bytes.org>
        <20210609101532.452851eb.alex.williamson@redhat.com>
        <20210609102722.5abf62e1.alex.williamson@redhat.com>
        <20210609184940.GH1002214@nvidia.com>
        <20210610093842.6b9a4e5b.alex.williamson@redhat.com>
        <20210611164529.GR1002214@nvidia.com>
        <20210611133828.6c6e8b29.alex.williamson@redhat.com>
        <20210612012846.GC1002214@nvidia.com>
        <20210612105711.7ac68c83.alex.williamson@redhat.com>
        <20210614140711.GI1002214@nvidia.com>
        <20210614102814.43ada8df.alex.williamson@redhat.com>
        <MWHPR11MB1886239C82D6B66A732830B88C309@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210615101215.4ba67c86.alex.williamson@redhat.com>
In-Reply-To: <20210615101215.4ba67c86.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [101.80.71.101]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1e42e734-7e20-44fd-0414-08d930920a06
x-ms-traffictypediagnostic: MWHPR11MB2062:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB2062CFA5E8348533818643238C0F9@MWHPR11MB2062.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OU7s71Sg/zECfBIGPDAz9Nto3dugvijQPhiZonZyHtk42fqizig5gM25iw0tb5Hc2YF3TC8tn++s9/BLN6yB/0bH5mDQKsRyf64zEo55zhstRK5QPeDklzBNIIue6VcO3krXhzS+ILdsGeLzbJ1a0BxWcBEuocKY3hzzVdmIc8U1DrVVtdqqSnuGfx18nQ7JYe5B+btyHKiURNecyfETNXsU7aRInSUtVZYW2txOcayfDEWQhbveH7wtbRtygVjry6aevkbSZsyvmeY9g/YpF96WIYdOJsDvHStVxBApVmHKcpkosSXfffUEBbqmOI+IEMLP1McG/xGh3uTZyKOFsfycLy+dgKdfnYA8ESq6Fyg74WRM2If1zuZ2xJactzWbD3iGNz8aJTDVU6wg6ZW4FlsvhmfotVgblpG59m55HhMeU7bNyiFMsOKasXmIAPS8pRzmZu+Amzit2h7xBX3QuOPa9rJuC/7NIxDULw5J4whqC50SmLjHOGG7UPIbXXdHO1pS8RF6vuo0JbphLZlUIroOgjZJcLT3rrU2AsCdDPBBI/O7ZOY2o3H3ZLhKCgo4HV9CogByMjouLOXCjYmyi3gg3IPTxHqd7gpupG85Src=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(396003)(136003)(39860400002)(26005)(186003)(52536014)(4326008)(7416002)(8936002)(6506007)(83380400001)(76116006)(64756008)(38100700002)(122000001)(66476007)(8676002)(66556008)(66446008)(66946007)(86362001)(71200400001)(316002)(2906002)(6916009)(478600001)(55016002)(9686003)(54906003)(33656002)(7696005)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CT1O6Uac3sXww3cnGu721brnVv1/efqu1v0I1iwvHmhnoo98fCv2Ua4HBqyB?=
 =?us-ascii?Q?bzjkthmUnScBJ1+Th/7b50iQeOPtSCGEG6DIpwlSlII2PwPXXEFKPhE5UGG5?=
 =?us-ascii?Q?JTUY4hSA65p1Q0uWlxIo+4phHcYVfPpmfKgUty6rnpqbuUyGrH/IJSLcU1n7?=
 =?us-ascii?Q?9cErgtQzpF6B0O68netAGa7JN77m2pFFyFWTqvcXqpfOam7LVd9lw8S6njuF?=
 =?us-ascii?Q?wK2LuC0xs6aqtnFLzoEFmcAinzVYStnzw0f1zdxAQFx9kfifThElVWg4Zhxa?=
 =?us-ascii?Q?ep7kArLMCsbUHTZoxe8mdI1EEw7UcQph1lILlaMQNj5eWBPdFQlpDhw+z8P0?=
 =?us-ascii?Q?zWUB9MqpwtV8r6LMUkbeNAOINzhKe8aao6PQ03ZeJnOo9ZvnTIUJkTqaIMSo?=
 =?us-ascii?Q?OBYZROCcGCpzK4wcf+qkAdTPSaTRbFJPUIiAqs6F82u9hW+i58ebMiiiGNrA?=
 =?us-ascii?Q?ypgoKeUCWEHvgGbDPLsmIUlI8EpEskX8/y8qGyeHSH6NgRnDhgBEcSclZrJR?=
 =?us-ascii?Q?m1nnxwhcV0EboCCMJVtJ3ZlgaAQjgE2FjCgHbPLcPptkPc51kKYjYCg3I4CU?=
 =?us-ascii?Q?zL1QaWtAmVpFJvw0VoFUtOyaWbKV6eUpQIuFcrCRusij7M2QYb/iBfypvj5L?=
 =?us-ascii?Q?+k1HCT6O7+dCgVdwrvazu+yyxKMN9/KoZnTKNSm/Qqzj9+FRKXRs7qpsbRxb?=
 =?us-ascii?Q?/QuEDTGAwMQsyvVNbWunCYPqdPUaW/an+3qP40Er84NMwXpsQFn1uPrkyZvR?=
 =?us-ascii?Q?NRMHHiHg6uTYq0Ow8Y5iQKgcqA/sMIvZBxz6RgSMbhHv5grXOOfDhnD91whb?=
 =?us-ascii?Q?2yQSOjbJWOcFc68excsXwV2ykuBoM1oQAptBJdIBL4dvKDWXv3mOzU0LSEgE?=
 =?us-ascii?Q?YAZkOsA/4oeTgSvLyt9uzTq9XGRyCslzlPz1ylwZdUttT97KjIRGInBL7K6a?=
 =?us-ascii?Q?tbS9fYvWjuYB2ox2alowHta24oAhqNW9yR0kZNitS4dTeCwxx6Km8nkZpwiQ?=
 =?us-ascii?Q?pUsiHbSXJ8S/sYSPmJe60IjNO4lkx9vFhr4+tqcLWeU5BzzVWd1Dt2mvlDmz?=
 =?us-ascii?Q?q+vfNUQ8nC5X6EtbqRfeIj2wg+A7i4d6/mf+LFWukO9P7WwA8H6M/1+1Heal?=
 =?us-ascii?Q?QkEcqa8SFUyP79Z8V5ulGbtxP8SuD12kuZFLfYjlseoOMrRS4lTj/Lw0wZmz?=
 =?us-ascii?Q?tPtaHdyt3MwPKxZsB28DowjDhajN3pyjcvGbKtEntxItImddejqY2+SK3SoW?=
 =?us-ascii?Q?CjAJ8qi3A6nj+/1jLFmJfEtJsh3keAP/HPUIk4T3qnb91tEca9LHs/dNMkzU?=
 =?us-ascii?Q?Tq3exTirTJXCfppsa6QQXh3G?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e42e734-7e20-44fd-0414-08d930920a06
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2021 06:43:23.9061
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +mIlimQngoAedp8E6wESE9RaQ/KWKSfzam7t4lVV4G7flm2J52kUGzqUTUsWH6q8JWlKIKBAqnOFCRStajYHmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB2062
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, June 16, 2021 12:12 AM
>=20
> On Tue, 15 Jun 2021 02:31:39 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>=20
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Tuesday, June 15, 2021 12:28 AM
> > >
> > [...]
> > > > IOASID. Today the group fd requires an IOASID before it hands out a
> > > > device_fd. With iommu_fd the device_fd will not allow IOCTLs until =
it
> > > > has a blocked DMA IOASID and is successefully joined to an iommu_fd=
.
> > >
> > > Which is the root of my concern.  Who owns ioctls to the device fd?
> > > It's my understanding this is a vfio provided file descriptor and it'=
s
> > > therefore vfio's responsibility.  A device-level IOASID interface
> > > therefore requires that vfio manage the group aspect of device access=
.
> > > AFAICT, that means that device access can therefore only begin when a=
ll
> > > devices for a given group are attached to the IOASID and must halt fo=
r
> > > all devices in the group if any device is ever detached from an IOASI=
D,
> > > even temporarily.  That suggests a lot more oversight of the IOASIDs =
by
> > > vfio than I'd prefer.
> > >
> >
> > This is possibly the point that is worthy of more clarification and
> > alignment, as it sounds like the root of controversy here.
> >
> > I feel the goal of vfio group management is more about ownership, i.e.
> > all devices within a group must be assigned to a single user. Following
> > the three rules defined by Jason, what we really care is whether a grou=
p
> > of devices can be isolated from the rest of the world, i.e. no access t=
o
> > memory/device outside of its security context and no access to its
> > security context from devices outside of this group. This can be achiev=
ed
> > as long as every device in the group is either in block-DMA state when
> > it's not attached to any security context or attached to an IOASID cont=
ext
> > in IOMMU fd.
> >
> > As long as group-level isolation is satisfied, how devices within a gro=
up
> > are further managed is decided by the user (unattached, all attached to
> > same IOASID, attached to different IOASIDs) as long as the user
> > understands the implication of lacking of isolation within the group. T=
his
> > is what a device-centric model comes to play. Misconfiguration just hur=
ts
> > the user itself.
> >
> > If this rationale can be agreed, then I didn't see the point of having =
VFIO
> > to mandate all devices in the group must be attached/detached in
> > lockstep.
>=20
> In theory this sounds great, but there are still too many assumptions
> and too much hand waving about where isolation occurs for me to feel
> like I really have the complete picture.  So let's walk through some
> examples.  Please fill in and correct where I'm wrong.

Thanks for putting these examples. They are helpful for clearing the=20
whole picture.

Before filling in let's first align on what is the key difference between
current VFIO model and this new proposal. With this comparison we'll
know which of following questions are answered with existing VFIO
mechanism and which are handled differently.

With Yi's help we figured out the current mechanism:

1) vfio_group_viable. The code comment explains the intention clearly:

--
* A vfio group is viable for use by userspace if all devices are in
 * one of the following states:
 *  - driver-less
 *  - bound to a vfio driver
 *  - bound to an otherwise allowed driver
 *  - a PCI interconnect device
--

Note this check is not related to an IOMMU security context.

2) vfio_iommu_group_notifier. When an IOMMU_GROUP_NOTIFY_
BOUND_DRIVER event is notified, vfio_group_viable is re-evaluated.
If the affected group was previously viable but now becomes not=20
viable, BUG_ON() as it implies that this device is bound to a non-vfio=20
driver which breaks the group isolation.

3) vfio_group_get_device_fd. User can acquire a device fd only after
	a) the group is viable;
	b) the group is attached to a container;
	c) iommu is set on the container (implying a security context
	    established);

The new device-centric proposal suggests:

1) vfio_group_viable;
2) vfio_iommu_group_notifier;
3) block-DMA if a device is detached from previous domain (instead of
switching back to default domain as today);
4) vfio_group_get_device_fd. User can acquire a device fd once the group
is viable;
5) device-centric when binding to IOMMU fd or attaching to IOASID

In this model the group viability mechanism is kept but there is no need
for VFIO to track the actual attaching status.

Now let's look at how the new model works.

>=20
> 1) A dual-function PCIe e1000e NIC where the functions are grouped
>    together due to ACS isolation issues.
>=20
>    a) Initial state: functions 0 & 1 are both bound to e1000e driver.
>=20
>    b) Admin uses driverctl to bind function 1 to vfio-pci, creating
>       vfio device file, which is chmod'd to grant to a user.

This implies that function 1 is in block-DMA mode when it's unbound
from e1000e.

>=20
>    c) User opens vfio function 1 device file and an iommu_fd, binds
>    device_fd to iommu_fd.

User should check group viability before step c).

>=20
>    Does this succeed?
>      - if no, specifically where does it fail?
>      - if yes, vfio can now allow access to the device?
>=20

with group viability step c) fails.

>    d) Repeat b) for function 0.

function 0 is in block DMA mode now.

>=20
>    e) Repeat c), still using function 1, is it different?  Where?  Why?

it's different because group becomes viable now. Then step c) succeeds.
At this point, both function 0/1 are in block-DMA mode thus isolated
from the rest of the system. VFIO allows the user to access function 1
without the need of knowing when function 1 is attached to a new
context (IOASID) via IOMMU fd and whether function 0 is left detached.

>=20
> 2) The same NIC as 1)
>=20
>    a) Initial state: functions 0 & 1 bound to vfio-pci, vfio device
>       files granted to user, user has bound both device_fds to the same
>       iommu_fd.
>=20
>    AIUI, even though not bound to an IOASID, vfio can now enable access
>    through the device_fds, right?  What specific entity has placed these

yes

>    devices into a block DMA state, when, and how?

As explained in 2.b), both devices are put into block-DMA when they
are detached from the default domain which is used when they are
bound to e1000e driver.

>=20
>    b) Both devices are attached to the same IOASID.
>=20
>    Are we assuming that each device was atomically moved to the new
>    IOMMU context by the IOASID code?  What if the IOMMU cannot change
>    the domain atomically?

No. Moving function 0 then function 1, or moving function 0 alone can
all works. The one which hasn't been attached to an IOASID is kept in
block-DMA state.

>=20
>    c) The device_fd for function 1 is detached from the IOASID.
>=20
>    Are we assuming the reverse of b) performed by the IOASID code?

function 1 turns back to block-DMA

>=20
>    d) The device_fd for function 1 is unbound from the iommu_fd.
>=20
>    Does this succeed?
>      - if yes, what is the resulting IOMMU context of the device and
>        who owns it?
>      - if no, well, that results in numerous tear-down issues.

Yes. function 1 is block-DMA while function 0 still attached to IOASID.
Actually unbind from IOMMU fd doesn't change the security context.
the change is conducted when attaching/detaching device to/from an
IOASID.

>=20
>    e) Function 1 is unbound from vfio-pci.
>=20
>    Does this work or is it blocked?  If blocked, by what entity
>    specifically?

works.=20

>=20
>    f) Function 1 is bound to e1000e driver.
>=20
>    We clearly have a violation here, specifically where and by who in
>    this path should have prevented us from getting here or who pushes
>    the BUG_ON to abort this?

via vfio_iommu_group_notifier, same as today.

>=20
> 3) A dual-function conventional PCI e1000 NIC where the functions are
>    grouped together due to shared RID.
>=20
>    a) Repeat 2.a) and 2.b) such that we have a valid, user accessible
>       devices in the same IOMMU context.
>=20
>    b) Function 1 is detached from the IOASID.
>=20
>    I think function 1 cannot be placed into a different IOMMU context
>    here, does the detach work?  What's the IOMMU context now?

Yes. Function 1 is back to block-DMA. Since both functions share RID,
essentially it implies function 0 is in block-DMA state too (though its
tracking state may not change yet) since the shared IOMMU context=20
entry blocks DMA now. In IOMMU fd function 0 is still attached to the
IOASID thus the user still needs do an explicit detach to clear the=20
tracking state for function 0.

>=20
>    c) A new IOASID is alloc'd within the existing iommu_fd and function
>       1 is attached to the new IOASID.
>=20
>    Where, how, by whom does this fail?

No need to fail. It can succeed since doing so just hurts user's own foot.

The only question is how user knows the fact that a group of devices
share RID thus avoid such thing. I'm curious how it is communicated
with today's VFIO mechanism. Yes the group-centric VFIO uAPI prevents
a group of devices from attaching to multiple IOMMU contexts, but=20
suppose we still need a way to tell the user to not do so. Especially=20
such knowledge would be also reflected in the virtual PCI topology
when the entire group is assigned to the guest which needs to know
this fact when vIOMMU is exposed. I haven't found time to investigate
it but suppose if such channel exists it could be reused, or in the worst=20
case we may have the new device capability interface to convey...

>=20
> If vfio gets to offload all of it's group management to IOASID code,
> that's great, but I'm afraid that IOASID is so focused on a
> device-level API that we're instead just ignoring the group dynamics
> and vfio will be forced to provide oversight to maintain secure
> userspace access.  Thanks,
>=20

In summary, the security of the group dynamics are handled through=20
block-DMA plus existing vfio_group_viable mechanism in this device-
centric design. VFIO still keeps its group management, but no need
to track the attaching status for allowing user access.

Thanks
Kevin
