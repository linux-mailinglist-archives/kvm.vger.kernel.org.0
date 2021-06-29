Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5513B6BB0
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 02:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbhF2A25 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 20:28:57 -0400
Received: from mga12.intel.com ([192.55.52.136]:1703 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231946AbhF2A2y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Jun 2021 20:28:54 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10029"; a="187746476"
X-IronPort-AV: E=Sophos;i="5.83,307,1616482800"; 
   d="scan'208";a="187746476"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2021 17:26:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,307,1616482800"; 
   d="scan'208";a="408264017"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga003.jf.intel.com with ESMTP; 28 Jun 2021 17:26:26 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 28 Jun 2021 17:26:25 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 28 Jun 2021 17:26:25 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Mon, 28 Jun 2021 17:26:25 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Mon, 28 Jun 2021 17:26:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SRRf1c5OstxfEe4OM7jqSa/68Q7NHl0iqT4Rce4iuX/CBJ/IEzBWN/GV6XWbXhnfo/myDkneRpHcDqBIDezmyXpWp3hYgdXiR6TTEfP7nJUs9kvKWK9fW6ZzceDTxBwAGlLbSi/Cto1HezfNryisYQgWqPcwGi84XvIF8/9X+aZDGHvCuppMr4Dvxe5BoIrb4sK1vLKRa5gnj9JRlEhu65yAc0KS0PYZ8feWmu3OlYO2O7yThA+5wV+OGKDwAoAVpYdRHbzqqqH98cCOieAt+AW7mD+HXG+EVd/UUGt9oRQ95wimd9oDCKSyhgYdAGZWlV718RaaujitqpXZcjIykg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YDq8RjLhCslvFqsC5BuXfYJ1E2JAzxZcTcIn/bIktoY=;
 b=ksU1nQDkPp/vO235DwzCOV90EJzseRmtORkk/K4z0Mj8rOt63NM1gOKTm78/S7r4NcxJqSMQ+jqwl+JxA5AuR9UnOZ/Bh3XTDBW10EkA0iDjBTOsr/ABwwqBjxAftcq8CXxdFQgOphro9Kzg9I5JlpHo0GJwo3JZ8Q5hUjf8NH3QKnQ82dBAk8n6xjJCBcwNHsccmkjRC3irr+BY4PvJzx5L1pPedVWC7wHKBvJyiHUpjRA70286c4UTNmIC3uhAA/a6AwILb6AVcYU13PWfo+wjpMH4CaLasIKaYHpVcrz97z90zMgFqQailNR4zuBKzugGrGc+eshV6FM8H/Kd8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YDq8RjLhCslvFqsC5BuXfYJ1E2JAzxZcTcIn/bIktoY=;
 b=JemGBDymfW+EdXG0hw6f6XHazrDgCjA4tJD90tPE6G2WRG1Y6UD9ayIqmXLVOCHfAtTSKg11HMG2r7BVcQPKZddUAC67oAz10o3icTHVmT+BmV/nrWbx7L1MPuuLWM6nV6SoTZBa5luiZEYZdk0ZKF4ktoR/DuanYpCMKVaCizE=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1329.namprd11.prod.outlook.com (2603:10b6:404:47::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19; Tue, 29 Jun
 2021 00:26:23 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::2539:bbbd:5109:e36a]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::2539:bbbd:5109:e36a%5]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 00:26:23 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        David Gibson <david@gibson.dropbear.id.au>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Shenming Lu <lushenming@huawei.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: RE: Plan for /dev/ioasid RFC v2
Thread-Topic: Plan for /dev/ioasid RFC v2
Thread-Index: AddbO/WEUAFl3MPnRsG8exiH8bwEagB7l+uAAACIfoAAAdwYAAADDw6AAAHKgwAAANd4AAAAacwAAAT4QwAAK587AAA0n7GAAAYKlwAADDvuAAAgbLGAAF6lSYAABO0WAAATSRtQAB5ymYAAEyKHQAAmZhSAAAo/ocAAK16TAAAGdqAAACJdiVAAA3a7AAEa314AAD0+zwAAeWnuUAAuEQiAAACT+AAAALlfAAAAJ6MAAAHPk6A=
Date:   Tue, 29 Jun 2021 00:26:23 +0000
Message-ID: <BN9PR11MB54339FA9A465EA5CD7F96BCA8C029@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210617151452.08beadae.alex.williamson@redhat.com>
 <20210618001956.GA1987166@nvidia.com>
 <MWHPR11MB1886A17124605251DF394E888C0D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210618182306.GI1002214@nvidia.com>
 <BN9PR11MB5433B9C0577CF0BD8EFCC9BC8C069@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210625143616.GT2371267@nvidia.com>
 <BN9PR11MB5433D40116BC1939B6B297EA8C039@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210628163145.1a21cca9.alex.williamson@redhat.com>
 <20210628224818.GJ4459@nvidia.com>
 <20210628170902.61c0aa1d.alex.williamson@redhat.com>
 <20210628231328.GK4459@nvidia.com>
In-Reply-To: <20210628231328.GK4459@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [101.80.71.101]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d2f43bf7-69c9-4ebf-50fc-08d93a9486bb
x-ms-traffictypediagnostic: BN6PR11MB1329:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB1329C70D4974F5E27F0862B68C029@BN6PR11MB1329.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5tHqODsGHfC5fmhd6WMZFKqu8CA1josj1zDxQc89LjlKIETrMkvBbdQ1OfTegWVPFFPv9dvM+wmFyFi3BOpxHKCJB9sfS6puUUGZEWlu9c7qhwr369c/Po1zdoU8phOV16TRl814qWMpTJK7CislepGVGZGBf3vEfgfZmfOx9kChxddIvjeF84SZI4f4DcBZFmxh0k8scBxECAh+dRUKsNLEemuOE2aTAjua5bR3BUskTApy3oArNLzyj/ojlrDa+kkk5JKcbIKfFhZTEky7xsM0dn2ldQqc9UaIO//VlanMTkeerwtCDkYDC/O8pB2N4ECIv/7StmHKpTHALyWgi9XIvO6cb3HOvG1dL8vmHuAhd9bbRDcSGVcoZwopMSiTcp88P7C5wPDSCihIe5MWvM5BtvJakUeht3UtilkiESWybqQVRsFBaJl3Cfcj9gbc/yAzqwS7TSTuSdB8pDpSfxoIBpiG+bwt7Hh4fDQ/4XFvTgZJTYZgzSjf7SKqFWmPlB2AbupuEhOQwX2Hy/lNsoFT3U3T0f/NghEXgFCadgB10EVFESUdWLXMzpmtr/kcskx4YVdngQbwLt6qMh7SV1qOx67DtabnxAUg4t9EIMsvKe/mYuesuByKCnVG/Mm+W9ivgdO6JUdEppOd5lefPA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(39860400002)(396003)(376002)(478600001)(8936002)(86362001)(8676002)(2906002)(9686003)(7696005)(6506007)(122000001)(186003)(7416002)(33656002)(55016002)(26005)(38100700002)(76116006)(66946007)(4326008)(5660300002)(66476007)(66556008)(64756008)(66446008)(316002)(71200400001)(54906003)(52536014)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?S87lTmMFevuF05fPgJI3IMDRvc+PYXCwdqdjceU1lu9+3+83ERpLt22eU+/k?=
 =?us-ascii?Q?GR6+e/x+jtKzEhjN8t/hZIcAn4WMubhAQDT6Z5gvXL0ZGpq2GZjSSCOgiOq2?=
 =?us-ascii?Q?0tADmOZzkdexr9VoZrX+0Jz6O8mp/QOVj7Yu/gwKZ7P8wzY7tPBwxfG8iTGu?=
 =?us-ascii?Q?yzXcKZ2alwJsqzg4uqepdb8ypqYbwv29G6dY7xAylVmmJsidva7MFKeB39HJ?=
 =?us-ascii?Q?KBfol1MiH6Rbfbu6BbB/d831QyWM7Lu0U9LlHTz3hW+MqqaArNn5wZeIjN+p?=
 =?us-ascii?Q?Y43+grHWJAtuMIujdoN4RpA5cttTN45BdvT/gq3aWUjmtoY26mXufS5Z//Wr?=
 =?us-ascii?Q?LBZiX5gS+eb2ZWdU4/6AsbvaMFmhxnAD7zNvtgkIoFjDZJuQcxjH0KVu6ut8?=
 =?us-ascii?Q?buJ/YfA0LS9DieR0gAAmwE1qV1UuYUuEAuF77zizutZCB5DL79l3y4bgXLll?=
 =?us-ascii?Q?CFRsjuUUrLdOHN2Kyrxef2jwl5e/ipNI+SeskZE8aOJ7vgv48kgNKm7tDrnr?=
 =?us-ascii?Q?UY72Pb11Eb1nXLifCykFPBr6wPFy5Mv34wDZLiKqx9qsWpP1mgGsQjTAiqbQ?=
 =?us-ascii?Q?B6+rg8o8twAAverNcGqeoDc6OrDgE14xvmcr5OEwjc2J7H8sSe8RuYmHJqoN?=
 =?us-ascii?Q?KmyVODOij9CYH7yrPPeA75BUFR5o+0KZ9GMiQvFHk7MIJe/wVy8GFUj+X1HL?=
 =?us-ascii?Q?5zt49/vTbYVhUoF7m+HXaQuUVvIwEoLqTG1L7TsCEbuiNd+hTf+rZ16mEyZZ?=
 =?us-ascii?Q?mEABgDwmhqY6RgS1NAqg47xz90lxA0NV2KdUTRfQUMYWFssxruXdlyJ84TcW?=
 =?us-ascii?Q?mCAGNKgyNolfBOHxUNmioxrrdKzi75+RWw0kNAfkV2GxlyBesRFdeTrm/SlE?=
 =?us-ascii?Q?WV+xlJbMDHqE6YZ6llbarYnLFms15THcbrEQZItzVckb9Wm/RkCzXMIS6Kan?=
 =?us-ascii?Q?88ouOpyQXOn5Z+/O1bcituBHouxj8H6J2Z9PRAUWOe+kEyrQ32l/bLEX61HQ?=
 =?us-ascii?Q?1UIz2h6EtdSVVytR96vNEKv7ZS/lPez51PHxLAPQJ4j1JybQAw6GhcNlnR3j?=
 =?us-ascii?Q?Z0uPxaCBBKyiDZpkqi5FAgwbROO2TtQ8vkoum7IzohfKG1hw550cDMQz+G2x?=
 =?us-ascii?Q?9vN4Hs7h+y2tUAf4hYbXXiY1Uy5HZlTwf36ANrPw2rCedNn8NyOpf0e1r5X/?=
 =?us-ascii?Q?sONuC2w0qyF7+zPivz83DDrfQhxIziKgXLFwc01xsLSlkl74U20T9PcGe239?=
 =?us-ascii?Q?mO7ZC8Ubvo3ErVV5ZmbjHz96rMn7nDUV1KKsegyYwGtuAth8sloycxqEmiFW?=
 =?us-ascii?Q?6znvzZvssXYDj5ZDzCSwxVuU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2f43bf7-69c9-4ebf-50fc-08d93a9486bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2021 00:26:23.8613
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gFBhRu7MZTcebG3BdV48Rxshwr1/5G352cCV9Ta6beohEt67Ot10Utaa9XI5EmQioyotXIKXNj0Bde9QN0Zypg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1329
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe
> Sent: Tuesday, June 29, 2021 7:13 AM
>=20
> On Mon, Jun 28, 2021 at 05:09:02PM -0600, Alex Williamson wrote:
> > On Mon, 28 Jun 2021 19:48:18 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > > On Mon, Jun 28, 2021 at 04:31:45PM -0600, Alex Williamson wrote:
> > >
> > > > I'd expect that /dev/iommu will be used by multiple subsystems.  Al=
l
> > > > will want to bind devices to address spaces, so shouldn't binding a
> > > > device to an iommufd be an ioctl on the iommufd, ie.
> > > > IOMMU_BIND_VFIO_DEVICE_FD.  Maybe we don't even need "VFIO" in
> there and
> > > > the iommufd code can figure it out internally.
> > >
> > > It wants to be the other way around because iommu_fd is the lower
> > > level subsystem. We don't/can't teach iommu_fd how to convert a fd
> > > number to a vfio/vdpa/etc/etc, we teach all the things building on
> > > iommu_fd how to change a fd number to an iommu - they already
> > > necessarily have an inter-module linkage.
> >
> > These seem like peer subsystems, like vfio and kvm.  vfio shouldn't
> > have any hard dependencies on the iommufd module, especially so long as
> > we have the legacy type1 code.
>=20
> It does, the vfio_device implementation has to tell the iommu subsystem
> what kind of device behavior it has and possibly interact with the
> iommu subsystem with it in cases like PASID. This was outlined in part
> of the RFC.

Right. PASID is managed by specific device driver in this RFC and provided
as routing information to iommu_fd when the device is attached to an=20
IOASID. Another point is about PASID virtualization (vPASID->pPASID),
which is established by having the user to register its vPASID when doing
the attach call. vfio device driver needs to use this information in the
mediation path. In concept vPASID is not relevant to iommu_fd which only=20
cares about pPASID. Having vPASID registered via iommu_fd uAPI and=20
then indirectly communicated to vfio device driver looks not a clean
way in the first place.

Thanks
Kevin
