Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF283B7FAB
	for <lists+kvm@lfdr.de>; Wed, 30 Jun 2021 11:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbhF3JK6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Jun 2021 05:10:58 -0400
Received: from mga03.intel.com ([134.134.136.65]:40594 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233561AbhF3JK5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Jun 2021 05:10:57 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10030"; a="208356440"
X-IronPort-AV: E=Sophos;i="5.83,311,1616482800"; 
   d="scan'208";a="208356440"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2021 02:08:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,311,1616482800"; 
   d="scan'208";a="447394644"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 30 Jun 2021 02:08:28 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 30 Jun 2021 02:08:28 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 30 Jun 2021 02:08:27 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 30 Jun 2021 02:08:27 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 30 Jun 2021 02:08:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l4DieObbXY0lkUx8VSfOjXuvLOjnPnHTFjtjU71tEc07zrdV5OORBlrOoMyK5cJQx6bkEtt1foyl+JxeGNBiD8I0jLHrgP6zKL1JMGSstlS9O2HagHu9sEcGDgnS5tQ4CEV6joO53uIoC3ET3bDdipIbgIkxaKCBBsXKLlUh5LPjcOWZw620yyGK+up29+SYd1QM2DFBRPDUGeB7Qejzqh9r/us6VKKQ7PeFUWluiFcgqAhEyc3tAqeP+Im99jM+nKg4c+FDZUmJBnK+1zQCp1/yZ95OdcRJq0h9J4nQcoOe1AxlxMBE+FPWx4Op4ffQ3DEx3CB3lL2yf4Rt72URvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZ9CwcyEKePmAd/UxKsZHvxVzzPzLYA2VUToah83SZ4=;
 b=S8+E+E6g/LJnMLFxF3GyZTDIpWiRXW+8U0qjnFtleJmBFjTlOMQVp4XmaXTJ+vW/b0+4OZvrSG6JH9ebvzgLve9CAhDbsmJUUt1nX3lQ3I9aTnHs5bHM8HVPtSNpsllTXmOf/OQARbu4Y0LtYSvt6Tk4bdZv7uw0Wh7dkZQPOPJWTpo9jtjKfwNkK7Co2p2a4eeYTAQJGgHJ9/s8FpTfWUg7f5avJumBv2AdVxKtB7kloJA5byx/ZOOsI12DOv5AUQetf0/QDMmOzH1eFXfH1A2XxiBZxzuNBalAzr+qQFdggDF3ZT1+JHla7BA0KrPUpXgUmV5Rjf4pUP7H4+3acQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZ9CwcyEKePmAd/UxKsZHvxVzzPzLYA2VUToah83SZ4=;
 b=BB5sz6u2s6P7sSwncxf29OUWQ7MaJnxuVXOhLzA0tcSoa49xVHH8DlmbKsi01wzLK4mb7OZC2kKDqzlNz+Lqt+zpZeKNwQIGrzfyWrGQjZFAeaUGokdltgi/XiHRd5c3Nl+LM42kTPRQuaYu7V4in2GEQjJNjJvQU6zEZSgOBcI=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN8PR11MB3844.namprd11.prod.outlook.com (2603:10b6:408:91::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.23; Wed, 30 Jun
 2021 09:08:19 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::2539:bbbd:5109:e36a]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::2539:bbbd:5109:e36a%5]) with mapi id 15.20.4264.026; Wed, 30 Jun 2021
 09:08:19 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Joerg Roedel <joro@8bytes.org>, Jason Gunthorpe <jgg@ziepe.ca>
CC:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Robin Murphy <robin.murphy@arm.com>
Subject: RE: [PATCH 3/6] vfio: remove the unused mdev iommu hook
Thread-Topic: [PATCH 3/6] vfio: remove the unused mdev iommu hook
Thread-Index: AQHXRWldX98a1U6w60C1HwYkmNlXK6rc3tAAgAPcBcCAAJmdAIABJmdggAASuMCAAF5dgIAAAFGAgAAT44CABKOLAIAAAkEAgAAGdACAAAupAIAAIZMAgESRwUA=
Date:   Wed, 30 Jun 2021 09:08:19 +0000
Message-ID: <BN9PR11MB54331FC6BB31E8CBF11914A48C019@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <MWHPR11MB1886E02BF7DE371E9665AA328C519@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210513120058.GG1096940@ziepe.ca>
 <MWHPR11MB1886B92507ED9015831A0CEA8C509@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210514121925.GI1096940@ziepe.ca>
 <MWHPR11MB18866205125E566FE05867A78C509@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210514133143.GK1096940@ziepe.ca> <YKJf7mphTHZoi7Qr@8bytes.org>
 <20210517123010.GO1096940@ziepe.ca> <YKJnPGonR+d8rbu/@8bytes.org>
 <20210517133500.GP1096940@ziepe.ca> <YKKNLrdQ4QjhLrKX@8bytes.org>
In-Reply-To: <YKKNLrdQ4QjhLrKX@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: 8bytes.org; dkim=none (message not signed)
 header.d=none;8bytes.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.142.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f67c68c-d3b4-49e7-0560-08d93ba69a9a
x-ms-traffictypediagnostic: BN8PR11MB3844:
x-microsoft-antispam-prvs: <BN8PR11MB384470FE70C030CB85EF353D8C019@BN8PR11MB3844.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CYGcFIhXnf+exUpwiRnMUD2T8mC902FJulywMLHwS839eOHSr02FYrFvJ0vZ1u1ToBnwzCOyKQgWHJnexLMH8UIptk+na/73iREDG7rfe3VYPetmAw9CD/ETP1HI/T+YM2bH+zzyJwmstmtUmPetp9203a7GoNvirn+WAwt3GcpaJIbJIZZkXLTdcfxigxNU1MVjiavbTTmoOSrWuU9DKPoS1sx1/mTfUVnDdT5RopGw0uF1mkXk6NeqjjPZKT1E66hzfmxYOVRAzI1f/ZWQWvruy6IEn/VJfRoeBSB/zBZ7jf5EkMB7VClaFyCa1aHVWsSadN9NbHfce5CWPC20AQyNO1M6JAtyZKvFMdESjoPB1iLc7BN4ttmVn5gtqltR/tYu3cgDUOqF9MXtY4ldgvCAvaDqJ3vr76FWjScIbwvfl7wFqfOjlEx+K+Ek84i3vlMK1aN9pChFx2StlXJ0NyvQhXUuwT5t0mjMN9BNvjMdWFRdctOk9ZOfK3yxNNERlpd9hGiUxtvM0UZoP0mzYlZl5h1vCpHokj3SLsubXatMmshh0RweivaHykM1umduBxNFDo7O2UaIAgj01rXRkQAQt8KZbLxYDukiZZ8DgomBS9tQD1a7X70ZIOPQHcKw1UTSA7Mr3k5XQ8F3IK3qzQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(39860400002)(396003)(366004)(33656002)(6506007)(54906003)(110136005)(316002)(26005)(186003)(83380400001)(5660300002)(66446008)(38100700002)(66946007)(71200400001)(64756008)(66556008)(66476007)(55016002)(2906002)(86362001)(52536014)(8676002)(7696005)(9686003)(478600001)(4326008)(76116006)(7416002)(8936002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LkU5yya8RyXgFwBzJtxz0AOiEkpL+eh3PLbmqCGYvuhRff1B1oXB1cYE+MHr?=
 =?us-ascii?Q?0h997498JL1VFuoAV/Lz7ja0YmRk6ZfuVEfx9l1Xmwveelm8yAxfaKYTe1yx?=
 =?us-ascii?Q?wVq1Y8GP2jHbHBxHVI+X/nAG9vXh3pnXD/hF8GJRd5HgCSTSCRQJ4/tG6oKT?=
 =?us-ascii?Q?FeQzjHrOAjZlsvZOeS1sJh5CNY9UP30ohaeN+ZSv0JWspI5S21aRjL7Q+Oar?=
 =?us-ascii?Q?7q5oQgX4+JdncMCZBO1rH7zEcK4rmZeUKe1n72RfVMH5R5qWs7wFujfVZT8D?=
 =?us-ascii?Q?4WhR5RfVYUNk3Hgih1Smn8E/8UAip83SJgZ9E1hR1OTmxZwblou49mHJcrwN?=
 =?us-ascii?Q?Zwda/BFEEi6qcqTI3ZR7Fe6D372DRWtoKZ7S1pHBfJQbG17AyyQUnIkRDemv?=
 =?us-ascii?Q?lW1V6xTI9x+NkWY3yh3kIw56S9hZ2N5B1uF8OMUOAVu/VFDyWlUhA47rcmis?=
 =?us-ascii?Q?DhTOsrCTtP+KqUWLj9Jqop3WUJf6UbcLTCbycEjbEmy/NI6qHtWmeAJ7MFqP?=
 =?us-ascii?Q?QIyOuFmy8AY+RuV4YFaDS7SuhAXChWIF3Nh3Gjj7n5e1Qp3NwiXIZegIHW25?=
 =?us-ascii?Q?kCifb/ZWxY31u9HMREm7NmaIhWQ+2IxNDMRotnbCZDh9BZ/FeC+HRPQcsvEM?=
 =?us-ascii?Q?uL4VCbcu26YGzQahag5yJ6FRCmxvnU/WyF8m+wbmwgY5L5EshOCC0SaynpzG?=
 =?us-ascii?Q?diBX39/UKFVwgTKWXWI5QM3Az5XV0wiwOsSS6AUkegbNhbwPJ3C3nr6qGS0R?=
 =?us-ascii?Q?OjTMjtdK0+UNCI6defYaQ+cCHmz4DCm60heyEC+L5TqyH7CVJRagQcqzeE07?=
 =?us-ascii?Q?8fntZK0Zzfz/sM7N7EAHouOM6Q0Q/Du1+Cvuz6cLmfACpXcqnqZMO7z4n7fy?=
 =?us-ascii?Q?jX2O+o+ToWL1keSI4KXEI0EOJ/6gJ+J//23DbMYs68mRYKG8fz1VQ0QOJTd/?=
 =?us-ascii?Q?PcLJljhruNJhYhFPfXn9FmZTGfhJ5+Ptk2TmOhinZuJY8nKac8hOcYExPC8u?=
 =?us-ascii?Q?5JWtsw2uxaJ5CAlui6S7slPuehEE9DUr/d7LVHfaM/tAWML77JfSnGPMiIwP?=
 =?us-ascii?Q?BBBwXTzdUAkiuceWanAa1OC4X4na4o88NSdqNf7xJ7uopix0aOHpkYo/sBre?=
 =?us-ascii?Q?JAK4BqjGgeHJsl+p66o5BBckA7wFZzzhSN/2L1MXsviPYOOoGuD4rzWOsTUS?=
 =?us-ascii?Q?BwU2recO2kyDeLLvhPXVyugDBOFOd2qk9/QzYAdUVZOF9cr7iYkJL+E7oOXo?=
 =?us-ascii?Q?Km6XaV/1UE59tvqEFmdlx5iXfyrOiIfGdKiI2ArKXyRyll92A8PN3epMv5+U?=
 =?us-ascii?Q?+CsQF3itARrxO/ECHy8b26qH?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f67c68c-d3b4-49e7-0560-08d93ba69a9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2021 09:08:19.3204
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lWOn67oBF1YFd3huoqPhm9gkPtROho1WBXYlpKrXdkK+nCE2IUl3jNoAmVQnsgORjSHCSPJcP0HYO8H9E/PGqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3844
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Joerg Roedel <joro@8bytes.org>
> Sent: Monday, May 17, 2021 11:35 PM
>=20
> On Mon, May 17, 2021 at 10:35:00AM -0300, Jason Gunthorpe wrote:
> > Well, I'm sorry, but there is a huge other thread talking about the
> > IOASID design in great detail and why this is all needed. Jumping into
> > this thread without context and basically rejecting all the
> > conclusions that were reached over the last several weeks is really
> > not helpful - especially since your objection is not technical.
> >
> > I think you should wait for Intel to put together the /dev/ioasid uAPI
> > proposal and the example use cases it should address then you can give
> > feedback there, with proper context.
>=20
> Yes, I think the next step is that someone who read the whole thread
> writes up the conclusions and a rough /dev/ioasid API proposal, also
> mentioning the use-cases it addresses. Based on that we can discuss the
> implications this needs to have for IOMMU-API and code.
>=20
> From the use-cases I know the mdev concept is just fine. But if there is
> a more generic one we can talk about it.
>=20

Although /dev/iommu v2 proposal is still in progress, I think there are=20
enough background gathered in v1 to resume this discussion now.

In a nutshell /dev/iommu requires two sets of services from the iommu
layer:

-   for an kernel-managed I/O page table via map/unmap;
-   for an user-managed I/O page table via bind/invalidate and nested on=20
    a kernel-managed parent I/O page table;

Each I/O page table could be attached by multiple devices. /dev/iommu
maintains device specific routing information (RID, or RID+PASID) for
where to install the I/O page table in the IOMMU for each attached device.

Kernel-managed page table is represented by iommu domain. Existing=20
IOMMU-API allows /dev/iommu to attach a RID device to iommu domain.=20
A new interface is required, e.g. iommu_attach_device_pasid(domain, dev,=20
pasid), to cover (RID+PASID) attaching. Once attaching succeeds, no change
to following map/unmap which are domain-wide thus applied to both RID=20
and RID+PASID. In case of dev_iotlb invalidation is required, the iommu=20
driver is responsible for handling it for every attached RID or RID+PASID
if ats is enabled.

to take one example, the parent (RID1) has three work queues. WQ1 is=20
for parent's own DMA-API usage, with WQ2 (PASID-x) assigned to VM1=20
and WQ3 (PASID-y) assigned to VM2. VM2 is also assigned with another=20
device (RID2). In this case there are three kernel-managed I/O page=20
tables (IOVA in kernel, GPA for VM1 and GPA for VM2), thus RID1 is=20
attached to three domains:

RID1 --- domain1 (default, IOVA)
     |      |
     |      |-- [RID1]
     |
     |-- domain2 (vm1, GPA)
     |      |
     |      |-- [RID1, PASID-x]
     |
     |-- domain3 (vm2, GPA)
     |      |
     |      |-- [RID1, PASID-y]
     |      |
     |      |-- [RID2]

The iommu layer should maintain above attaching status per device and per
iommu domain. There is no mdev/subdev concept in the iommu layer. It's
just about RID or PASID.

User-manage I/O page table might be represented by a new object which=20
describes:

    - routing information (RID or RID+PASID)
    - pointer to iommu_domain of the parent I/O page table (inherit the
      domain ID in iotlb due to nesting)
    - address of the I/O page table

There might be chance to share the structure with native SVA which also
has page table managed outside of iommu subsystem. But we can leave=20
it and figure out until coding.

And a new set of IOMMU-API:

    - iommu_{un}bind_pgtable(domain, dev, addr);
    - iommu_{un}bind_pgtable_pasid(domain, dev, addr, pasid);
    - iommu_cache_invalidate(domain, dev, invalid_info);
    - and APIs for registering fault handler and completing faults;
(here 'domain' is the one representing the parent I/O page table)

Because nesting essentially creates a new reference to the parent I/O=20
page table, iommu_bind_pgtable_pasid() implicitly calls __iommu_attach_
device_pasid() to setup the connection between the parent domain and=20
the new [RID,PASID]. It's not necessary to do so for iommu_bind_pgtable()=20
since the RID is already attached when the parent I/O page table is created=
.

In consequence the example topology is updated as below, with guest
SVA enabled in both vm1 and vm2:

RID1 --- domain1 (default, IOVA)
     |      |
     |      |-- [RID1]
     |
     |-- domain2 (vm1, GPA)
     |      |
     |      |-- [RID1, PASID-x]
     |      |-- [RID1, PASID-a] // nested for vm1 process1
     |      |-- [RID1, PASID-b] // nested for vm1 process2
     |
     |-- domain3 (vm2, GPA)
     |      |
     |      |-- [RID1, PASID-y]
     |      |-- [RID1, PASID-c] // nested for vm2 process1
     |      |
     |      |-- [RID2]
     |      |-- [RID2, PASID-a] // nested for vm2 process2

Thoughts?

Thanks
Kevin
