Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C05DD3FF724
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 00:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235822AbhIBW2L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 18:28:11 -0400
Received: from mga03.intel.com ([134.134.136.65]:20855 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231642AbhIBW2K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 18:28:10 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10095"; a="219321882"
X-IronPort-AV: E=Sophos;i="5.85,263,1624345200"; 
   d="scan'208";a="219321882"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 15:27:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,263,1624345200"; 
   d="scan'208";a="447326912"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga002.jf.intel.com with ESMTP; 02 Sep 2021 15:27:11 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 2 Sep 2021 15:27:11 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 2 Sep 2021 15:27:11 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 2 Sep 2021 15:27:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D/pd4o6xu6opOKT6UM+TwBxnZeAjeB02puxV9ccXLTBN0bWchnQ+nWWktj3SsL/mi0wOTlePXzTr4/UE/f3BTirpC0cgrUfaOjvsE10xR5voh0zxqWoIvuInRCEvud7FoCWqhxX3/YW4xRHOxOQqZ4i2AlEpStZLhsY7jTHMkXLtYH4V20PhU6UmAF3Xz198wlS3Njp1coztZFHXM9cphTjr06904vMbFekvCvUJevC4XEwb7n30BHMB+tbgHr8as1isEjhneAeXuyyhwbYY7fwWv4O0hGKiJQxMFoieOvynUMAGYJf2uqNhTg9Yp0RCxqCeodnWL0jLYPQBkp6y2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2EtftwsCktq/nQTfmB0WEx1EirUnWiAly/IXZV/V+VY=;
 b=atoPkJSqeaINWsqfvmmjcXx4imc/hNTi9kjlYtS/U/gKbv9fTUcsGXNVxlQUYxsbZtPGmnsVn0EL6yKfExAR2BOKzn5W+VzE5XLHg1jvRxitrNRAghveeZhDM2eC1GSIDp0V8/DeH1ta3vQSazdk/ZmMQB5bE7DJINgspVhIWlD54y4f2N3LlevuFRuNaV7fmUWvd9VwaikjC9lyfsbgJU/+ii9f2FBeBJTxtX3BFCrnQJUBTJFbpxiAfcJ/xxTdn41p0Oztx+vIGbFHbLIRaotA4p59JMUdAmrn4fql8G1WWjALbUTT7SPYhkNJScU4iXbtXKGPKf3NYEisn2y4zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2EtftwsCktq/nQTfmB0WEx1EirUnWiAly/IXZV/V+VY=;
 b=Kmz5lp+Ohll5iR+FE24yQ9U7gOJ/8wHUWEjNXlNTsII1pX49KdVGt8LDnZLspaRQ6VeIuVJzURvacfBrvGhdlHdkFU5XULV5jmxeJAftQfDmhG//JNE8JY6c/PhQckktCLQoT1XCuuD5Gticz+0iDY7K/bvZZuWJE/jrbvnR6zc=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR1101MB2289.namprd11.prod.outlook.com (2603:10b6:405:54::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Thu, 2 Sep
 2021 22:27:06 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%9]) with mapi id 15.20.4478.022; Thu, 2 Sep 2021
 22:27:06 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "will@kernel.org" <will@kernel.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [RFC][PATCH v2 00/13] iommu/arm-smmu-v3: Add NVIDIA
 implementation
Thread-Topic: [RFC][PATCH v2 00/13] iommu/arm-smmu-v3: Add NVIDIA
 implementation
Thread-Index: AQHXnhVovHekE4RvPUm07KSkZdD8O6uNysGAgADuWNCAAh0OAIAAfHFQ
Date:   Thu, 2 Sep 2021 22:27:06 +0000
Message-ID: <BN9PR11MB54337332A83176241C984EC58CCE9@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210831025923.15812-1-nicolinc@nvidia.com>
 <20210831101549.237151fa.alex.williamson@redhat.com>
 <BN9PR11MB5433E064405A1AFEC50C1C9F8CCD9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210902144524.GU1721383@nvidia.com>
In-Reply-To: <20210902144524.GU1721383@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 62fab0e4-2cff-473e-e136-08d96e60cbf2
x-ms-traffictypediagnostic: BN6PR1101MB2289:
x-microsoft-antispam-prvs: <BN6PR1101MB2289107683D11C82467FF4868CCE9@BN6PR1101MB2289.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gZEymyMl/uIo48J3+Eij9MbOx/jIlA+MTMKfGQqSAxayu7aHg2JFAGx8sOKjZVhlyhQS/a546DKUBY/kUek0b9ZlAKatDbNG8k34p3Sp1eLJ5Y92OfTunlsiy6MzbhEtM29dxOuDwPT2zNnFAOIElXu+uJUfOTPf0P/G7vH5UZzmyYohmB28Xb+5K/dA1To/rUwp6hm/MN/xQ71BnFFKEBKlzzilB35LPgndDVDt4ISFM267A+vT7E8iPOwuasM4uSps6+lYf8FQO+Ykd1qzm1lt7e41q8gxXtyhAJqVWzpzOJaSywIEkbIxRV3d6tRRkQDRepKAnhde5qIwL7/ZHKc7kt4uFwCd0vOtlz9SIf5LfDREKSh8sIxqm1/WhefSt1IGEzmtDoJdZtD3Z4HYjNT637k8/8yvxPUEf+Ws/sGi10HD+0uuLuQJ3zStXrQWTl0d5Eh8PB4/cJWOIhoNqBg+/Q1DEcp9SC8g94vB4CywKuprOF8tKMgKqI2DrBPPvWnTFnUSqO6Cbl3yQ8sJHPAo6H0xJ1KCIkSSX7ZGs8nFZ5apqXZgTP4ESReMsBdWUqxplvicn82PB3T/chwSLVtZoykJUAuT7MoE+gNjDZiCsxng7D5LRadyM60VrkFtO81HuMONzJKEhTXmUOv4950yMTfDIpN9LKd1svqHbyRyBIYrLBPVK2XlE6XwYvelpcjm72XJMcd2fHTwGTV5Uw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(66446008)(7696005)(2906002)(316002)(64756008)(186003)(66946007)(76116006)(7416002)(66556008)(122000001)(38100700002)(66476007)(8936002)(6916009)(508600001)(6506007)(5660300002)(9686003)(52536014)(8676002)(4326008)(86362001)(54906003)(26005)(71200400001)(55016002)(33656002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZTQGOze+Jwip6R0Lsz5/0cuV/ixU6GSODW/OBrHzB3Sk/yaCVZEbu1k6aFLB?=
 =?us-ascii?Q?s182np7akc6NH6dDbq0vegnzx2CDSHdU8maSLkrzQ4v/JFBz2A7n3jUWamxo?=
 =?us-ascii?Q?t9fb5vbeYW0qoDQDcbWCym3kQlLxPm9ieiAlrFIRiM9UP8d/yDG91NRqs5nd?=
 =?us-ascii?Q?yNhuGA6iew2JDYW0f/qoXfSvsY3CqpUi13YE688GiyrVwaoWj7cu8DNZaFry?=
 =?us-ascii?Q?kusI72/5jBQsQ9SxcKVRG9z5XtAfGF9eaEImaMXmJpCx1niIJRVMb/G4QJma?=
 =?us-ascii?Q?FcfSCsts4IAmxHthoeh0feYiko5ZovqDieBDuhqqw+zroaISmJF4IcosyPOF?=
 =?us-ascii?Q?03vc+N/UEKA1D/JTmGleZIyH841xd8PZNFB/Guj9h4EFv2agIFwg1n8gDkVC?=
 =?us-ascii?Q?gdVypSw0OnQOKmnQvbJsRhumWbg1Oke1e6ugFRhXZO+bKoGYmkUK+RMx8G54?=
 =?us-ascii?Q?HJQt6oChF5QJ043+lPDnwX+nVz9386aftKkXIa37pUqtPCZvbpUGHSPnom8M?=
 =?us-ascii?Q?RGzEMAWqH1QaWlFqqcODVSc+RPQlc4KlBK62GjsrjxDwI804dH2FXKWSwP/O?=
 =?us-ascii?Q?mRlJtLfYs+kKLN1pBYsCCAU6gMvn4CO/LQwQJ89F7+HQnIByh98j9HvI9oqc?=
 =?us-ascii?Q?2g+hmBBpWW8QgtZ3oU/a2qxiD/WEoWNXOrH/JOoIls36UQGufgOE5rxJpRya?=
 =?us-ascii?Q?gpRdGgbc7APZSQrY75C+L0xLYWlmSnjzRx69UXP6XD99+RHvkpZNHxsHGRPJ?=
 =?us-ascii?Q?EsKXqGXy9XcD+wT4fJuI7xJI16GWos1/Vf/+A8jCGnDkwyXwtPysCmsW8R6a?=
 =?us-ascii?Q?JBV5AnDefo/6jpJIwuBAQV556pZO1sCXEumUc2hG0tyGvpxwBQweUgUl+lcZ?=
 =?us-ascii?Q?Y+QmkLBcSY+ixPgIA7Y3S07cBTX/6cZklJuntVT+K1YsIeT1mwh6Af8a7lsY?=
 =?us-ascii?Q?f73cWbbDnc5GyuJJLhjBVifXdwUpi8Q2xImuBDwLCDiYJu0EOR2LH5FNq6qo?=
 =?us-ascii?Q?+sqDHzLmnxcNgzQettsmFM9T1fiImRhmkjbY4pSOvYqllkyZr6mziL0dF0LK?=
 =?us-ascii?Q?tHCr0F2eMruNHccymX2FCxC+/9vB+pe+byEim2PIncyYVbN00y19Ra5cO+Ze?=
 =?us-ascii?Q?21Z2E5XRZzApQLb7/EGUkxZo8MrPvQdx6BY3P4glZW7ceKwgZkiWZqfk0oCo?=
 =?us-ascii?Q?yo8PkTRoktoCQRs+XmITgSVXxaudtw4MbSPFJHALvQ4f3NpRs+JHr+vyKndp?=
 =?us-ascii?Q?7wEElDI48HJb07RzasSJ0TVRK2Q630F/juInydgb+hnTLC8cIvL3G/fE9twm?=
 =?us-ascii?Q?+nRm8gV9QvocVBFm6CPKnEmb?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62fab0e4-2cff-473e-e136-08d96e60cbf2
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2021 22:27:06.5889
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6+YrMiaF+WhjNpU8CPXJEKRyWz9WVpvP90PU2ZkuiSEFIGiWdYqftJ/ONbIyKHq9hIaqTYM48JFT5GMPYc1FdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2289
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, September 2, 2021 10:45 PM
>=20
> On Wed, Sep 01, 2021 at 06:55:55AM +0000, Tian, Kevin wrote:
> > > From: Alex Williamson
> > > Sent: Wednesday, September 1, 2021 12:16 AM
> > >
> > > On Mon, 30 Aug 2021 19:59:10 -0700
> > > Nicolin Chen <nicolinc@nvidia.com> wrote:
> > >
> > > > The SMMUv3 devices implemented in the Grace SoC support NVIDIA's
> > > custom
> > > > CMDQ-Virtualization (CMDQV) hardware. Like the new ECMDQ feature
> first
> > > > introduced in the ARM SMMUv3.3 specification, CMDQV adds multiple
> > > VCMDQ
> > > > interfaces to supplement the single architected SMMU_CMDQ in an
> effort
> > > > to reduce contention.
> > > >
> > > > This series of patches add CMDQV support with its preparational
> changes:
> > > >
> > > > * PATCH-1 to PATCH-8 are related to shared VMID feature: they are
> used
> > > >   first to improve TLB utilization, second to bind a shared VMID wi=
th a
> > > >   VCMDQ interface for hardware configuring requirement.
> > >
> > > The vfio changes would need to be implemented in alignment with the
> > > /dev/iommu proposals[1].  AIUI, the VMID is essentially binding
> > > multiple containers together for TLB invalidation, which I expect in
> > > the proposal below is largely already taken care of in that a single
> > > iommu-fd can support multiple I/O address spaces and it's largely
> > > expected that a hypervisor would use a single iommu-fd so this explic=
it
> > > connection by userspace across containers wouldn't be necessary.
> >
> > Agree. VMID is equivalent to DID (domain id) in other vendor iommus.
> > with /dev/iommu multiple I/O address spaces can share the same VMID
> > via nesting. No need of exposing VMID to userspace to build the
> > connection.
>=20
> Indeed, this looks like a flavour of the accelerated invalidation
> stuff we've talked about already.
>=20
> I would see it probably exposed as some HW specific IOCTL on the iommu
> fd to get access to the accelerated invalidation for IOASID's in the
> FD.
>=20
> Indeed, this seems like a further example of why /dev/iommu is looking
> like a good idea as this RFC is very complicated to do something
> fairly simple.
>=20
> Where are thing on the /dev/iommu work these days?
>=20

We are actively working on the basic skeleton. Our original plan is to send
out the 1st draft before LPC, with support of vfio type1 semantics and
and pci dev only (single-device group). But later we realized that adding
multi-devices group support is also necessary even in the 1st draft to avoi=
d
some dirty hacks and build the complete picture. This will add some time
though. If things go well, we'll still try hit the original plan. If not, i=
t will be
soon after LPC.

Thanks
Kevin
