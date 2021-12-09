Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13BE046E110
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 03:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbhLIDCG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 22:02:06 -0500
Received: from mga07.intel.com ([134.134.136.100]:10706 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229446AbhLIDCF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 22:02:05 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10192"; a="301386823"
X-IronPort-AV: E=Sophos;i="5.88,191,1635231600"; 
   d="scan'208";a="301386823"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2021 18:58:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,191,1635231600"; 
   d="scan'208";a="503318320"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga007.jf.intel.com with ESMTP; 08 Dec 2021 18:58:32 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 8 Dec 2021 18:58:31 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 8 Dec 2021 18:58:31 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.48) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 8 Dec 2021 18:58:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RjCupYxn6esqW7aMy01GulgtokMIaLtjAlVkdlElYSbQKvfeyDkGcuH/Qm+WQ5wk+lyzT8q3vLT0XAmNe2B/UfIbTYPtIKinkeitq/UO1qv2Dn0VmVkUy792OjJ81mgzLakEcsWTsBJsM1eMn75qx5QxI5oL9pdHw5OchBUIbjaGBPlnHVFGEnrC3ji1rRXPGawDkeHmhWHiZ5HUcWfeVwCK03gaWj/G7sofiSQeFexo4O4B6RFMb7PCURzSLSO/+W7x2cpIDfrugKUTdvOJJL4tVTy70XGEvsPm3mpi32QMULp4poLg0Nba7lVO8ubBj3nONLbT5bl9GQyC8qTAbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NUmmPFcskrMo/vZRxbqD6GjeKO15BUfKeYJWSO5lJvY=;
 b=hLvKSXk8RQC08Wl22WAuMGC7uf6tBQBjJJ14q8rQVlk8tsT+DbWILyOIgooJM4UNXyaUU4B825aQzr4Z6PZsvwIIG7DXHWefGw5pH0bgd/KNOxy6skL+iyBbVLbFZLz/hCjGZwBnfph9Wj4ZVjFXYsrBy0jqfIjXzO0KGzbDLi6UFk5bVav6TGdRdwsuCTrTc9UUw0gAHNOTovCvo27D6PDkSKjyGgk3UXp/ZzyD51c821nemJU0oy04OsaEJWP4ETTn26ctqUf4uG+MdgQ+c6tnr1IiRsd5X6sG4lpIvGOUb2ryfLXRcXpAzrRFWwbW/LsdpKkbSRCFn1J0zkjGlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NUmmPFcskrMo/vZRxbqD6GjeKO15BUfKeYJWSO5lJvY=;
 b=rTGJ8kmF0rCgNH2kT6CX9an+OlbhbqP/vGz8iCxhUOLAxek6/XbG2yeXv87c+phn9YGHZH66qxWCZHcryZw3UKSE5Ct5SV4VLQOKQwy6rpnMrx97483wfxySN1BVHUWzeHiil3p1Aor3odyBkASfVLo+wV3U0fKHgQiMFGXqWwk=
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB1316.namprd11.prod.outlook.com (2603:10b6:404:3c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Thu, 9 Dec
 2021 02:58:28 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%2]) with mapi id 15.20.4755.016; Thu, 9 Dec 2021
 02:58:28 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
CC:     Eric Auger <eric.auger@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "vsethi@nvidia.com" <vsethi@nvidia.com>,
        "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
        "will@kernel.org" <will@kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "wangxingang5@huawei.com" <wangxingang5@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
Thread-Topic: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
Thread-Index: AQHXyx+9zoVf6ec36EaoAw6mFm2RjKwlh1WAgAGLFwCAARJNAIAAUNaAgABaKgCAAEnegIAAE6oAgACHsjA=
Date:   Thu, 9 Dec 2021 02:58:28 +0000
Message-ID: <BN9PR11MB52764B70054A41BC169AFB318C709@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20211027104428.1059740-1-eric.auger@redhat.com>
 <20211027104428.1059740-2-eric.auger@redhat.com>
 <Ya3qd6mT/DpceSm8@8bytes.org>
 <c7e26722-f78c-a93f-c425-63413aa33dde@redhat.com>
 <e6733c59-ffcb-74d4-af26-273c1ae8ce68@linux.intel.com>
 <fbeabcff-a6d4-dcc5-6687-7b32d6358fe3@redhat.com>
 <20211208125616.GN6385@nvidia.com> <YbDpZ0pf7XeZcc7z@myrica>
 <20211208183102.GD6385@nvidia.com>
In-Reply-To: <20211208183102.GD6385@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b1642ed-1ab2-4f5e-ab45-08d9babfc6e1
x-ms-traffictypediagnostic: BN6PR11MB1316:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN6PR11MB1316346DC3D225986E1215F78C709@BN6PR11MB1316.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DJuRGo3fIYm0y9xr3oz9ZLvJuYu6eTBReN83uMhbIROntYxbJOR1QRplshP+KEOUYmOHAEd61KJ0cfV9KEelnkezfNXQ0e09MNVOpW9a9fagxSHHvxzrUKx46+9oaqTDkgn6Re5QBSAkihl0dJ1+SQBpNtqDqG+zIA5/JeebP71oyZ9VovqhPAV/055EiIqLGnPRa2zf9YhnmCEyQ5gJsb7N9kNHZ5/nl94ceBanANNXxcnJBLAznbSl6jtZVwwCyTxgoF7aBt2PK0zKBY+YinVqRY6aqb6WLTVda2Pv0NTz3f2WvedaUvxgVP6IYoJZ5lFeK6YdkjeUkUa24b+bz83ndvnkEaxNsdpq6J5zjejP5wakfDaWfYlDef7gcsgjGXqtQk4cy8QxAKF4MB0mEIIyliMJQNYR3t2Tg9MH1K1A9l3dQuyM8JAf2+wMpVaGkC1ORSg2sz2rUiQ1y6DKY7Hm+zqdkLnrUOxFfe/icX+r8hC7W3gxNzlUqy4tdEXuWqlxgiPs3PezLd+uVN/NfEcWLfw4xvlh6R+T1MzLoqdgvDP+5944uIGt4OZIqMdsuuPhLmtGs2TxJ7JT8cmfkB0sYnJz3O433zOHYWk+/L5/oC+UCImwGXDadBnuDEUPmvQlZqBY8mByVqVCAV48yPWD2l0h5KitipA04aqzQ6Hgq093iWddi5AzlDz0YbmK5pzk1Wg1CQVeq7JzfReoYg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52536014)(64756008)(316002)(6506007)(186003)(508600001)(8936002)(2906002)(4326008)(54906003)(110136005)(83380400001)(26005)(8676002)(66476007)(66556008)(38070700005)(5660300002)(7696005)(71200400001)(86362001)(38100700002)(33656002)(9686003)(55016003)(82960400001)(76116006)(66446008)(122000001)(66946007)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wz8aw+E/ijfz+6zclGEX8UrHXziX9B48BWIYIhnWj0PFoKJ4vFWPnsZnFck1?=
 =?us-ascii?Q?ng4esJ96L4y7RFFya+TXHzryJgWniNtdgIielKT9RdNeMFbhZAWURC7we/iw?=
 =?us-ascii?Q?OsQG/bdSTr0QjACkAo+ZzW+RWM+jD+4sUX7tF2froOl/o7SWwQ3Om5FmRlPM?=
 =?us-ascii?Q?CRVZ3oQZ6zVglCKCzqwH9DVMVCJHezpFpS42ISHXl87oVjTmCqigBnYFlvyZ?=
 =?us-ascii?Q?nn5P89yjWQnBVJ0LoskhIsl3jXn41MJSVmTYSYoebi7oq08+K2Pgj6lCBFwt?=
 =?us-ascii?Q?3fCh79ZFkJsxpdtw8bqlFlI7aM16QiZC7y3V5P6SnrJsM/dRN0qmf7CORvCk?=
 =?us-ascii?Q?OTJRqf2uxnscvm24FUtopanuQUATllyQz3+5GpqBTce7AMpOG7XQsbmHGlNe?=
 =?us-ascii?Q?G39K0SmKmIxNaw3izN2o7x9RjuVwJrkOile8vmLXyUkLe5cLe2crU96JLABA?=
 =?us-ascii?Q?giDAM7CFdYLVetJJ9lPsFK6Ic7QBOkTg5mzpQstfHwgtKOOqO8QjQ5U2xw1U?=
 =?us-ascii?Q?ML8Kz5KXfX+h0ZUNuzPVlvH57MbM7JMWp/ohEbrJaWwnm6ETSpxfeB+wEGe5?=
 =?us-ascii?Q?H6A+OHEog4pqelr6sm07YYwElVP7MEPxzmNgK+5CNGHfmFKgXb2HwEaA0dge?=
 =?us-ascii?Q?Umg/SpokfQoU02ao6chiGtYSAIO7G/sonyXo2JMv9vkaxsAqOAJFyd61CURQ?=
 =?us-ascii?Q?rZREi1tQ8R0DNfpgvALBXCV9KF9+g0ABUiGiaYgwqBdNwY4d7C0lMv7JxlQI?=
 =?us-ascii?Q?4cVPDmo0tLjRDSG6gjYo1g/j5LsydmlgpS16SUUFnBBCmyQ43PiemWKtQj5A?=
 =?us-ascii?Q?68UHq1ZIvBOV3oq2Dm26wm2pXHzraNaEA0bxv9BTAPfwShA4EcIsh4bP8PO5?=
 =?us-ascii?Q?PHzBIfBmZhutiaP3JRdQ7KRH2HZ5HpuG9bs1ELvajPRXwumLwsTdEKBRaY6y?=
 =?us-ascii?Q?lNBKfV0AJj+Hnm8W7hReV5lNgjWWObnAIeTYnmajlo7/oz4T9jnByxJ9SvrG?=
 =?us-ascii?Q?w/qI/04rSE4iRyLdrRtUYHbaUep7SWoify6m38jD856bpgzbTc6jGM1O4Xi9?=
 =?us-ascii?Q?+iiaUFyqwyhPtIaf/79r7bDLX1SpJ6fyXFA843pP2hNUlZUoTGohYZ5srLsv?=
 =?us-ascii?Q?FdJG4IkM/caLLDMzmY3mt9W3CFwQmuTaxALvxaLJvsr3XXRogPBP4xpFpETf?=
 =?us-ascii?Q?bu53PappHr3AQoz07jsfzhxdILTihXxDld86I6DKecwkclPvVcziS1OoyYDr?=
 =?us-ascii?Q?dGqGgEPG2TQmt/dApQ/Z8Q4yX7xYiPCCwM7e4ke28jRWmCtsEVJGRNhNTUeG?=
 =?us-ascii?Q?qEmk2SeebxpSsqw/UdRlHw4QHYPKedvk4bqnkmOBaPaR5LcjfBGswAJ/FEmw?=
 =?us-ascii?Q?ljz+p0+lROf2vNWGRnrMUF/MSDs67K8duJ2Q0e3max9g8COr9OcYNLCpPMj+?=
 =?us-ascii?Q?TT761qyKgN18pPizob6M2OeIKFfCcAKjipmzjA8yw8xmgGjDrzFsYutF6Ut8?=
 =?us-ascii?Q?yTobJEe2TMBf4AaWhwqXVZ3J/rzY45CLqgOy45DyPO/SWqehMAl4qPr0beKQ?=
 =?us-ascii?Q?tD7990sYuHYt6kdXDW17VLUyOCaGTBFvb3NYQDQo8cYlxibyxn8wHVm1SN3K?=
 =?us-ascii?Q?41jr4AJ7oukdsctbeaFvuQU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b1642ed-1ab2-4f5e-ab45-08d9babfc6e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2021 02:58:28.7097
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3rgXeRws/kMY19EXtemG4nljhCufAzDsAw+gVpEiMxv0QP5iCd751KxRZZHpBA9km3v8Vp0rtdUAih/egO1cXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1316
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, December 9, 2021 2:31 AM
>=20
> On Wed, Dec 08, 2021 at 05:20:39PM +0000, Jean-Philippe Brucker wrote:
> > On Wed, Dec 08, 2021 at 08:56:16AM -0400, Jason Gunthorpe wrote:
> > > From a progress perspective I would like to start with simple 'page
> > > tables in userspace', ie no PASID in this step.
> > >
> > > 'page tables in userspace' means an iommufd ioctl to create an
> > > iommu_domain where the IOMMU HW is directly travesering a
> > > device-specific page table structure in user space memory. All the HW
> > > today implements this by using another iommu_domain to allow the
> IOMMU
> > > HW DMA access to user memory - ie nesting or multi-stage or whatever.
> > >
> > > This would come along with some ioctls to invalidate the IOTLB.
> > >
> > > I'm imagining this step as a iommu_group->op->create_user_domain()
> > > driver callback which will create a new kind of domain with
> > > domain-unique ops. Ie map/unmap related should all be NULL as those
> > > are impossible operations.
> > >
> > > From there the usual struct device (ie RID) attach/detatch stuff need=
s
> > > to take care of routing DMAs to this iommu_domain.
> > >
> > > Step two would be to add the ability for an iommufd using driver to
> > > request that a RID&PASID is connected to an iommu_domain. This
> > > connection can be requested for any kind of iommu_domain, kernel
> owned
> > > or user owned.
> > >
> > > I don't quite have an answer how exactly the SMMUv3 vs Intel
> > > difference in PASID routing should be resolved.
> >
> > In SMMUv3 the user pgd is always stored in the PASID table (actually
> > called "context descriptor table" but I want to avoid confusion with
> > the VT-d "context table"). And to access the PASID table, the SMMUv3 fi=
rst
> > translate its GPA into a PA using the stage-2 page table. For userspace=
 to
> > pass individual pgds to the kernel, as opposed to passing whole PASID
> > tables, the host kernel needs to reserve GPA space and map it in stage-=
2,
> > so it can store the PASID table in there. Userspace manages GPA space.
>=20
> It is what I thought.. So in the SMMUv3 spec the STE is completely in
> kernel memory, but it points to an S1ContextPtr that must be an IPA if
> the "stage 1 translation tables" are IPA. Only via S1ContextPtr can we
> decode the substream?
>=20
> So in SMMUv3 land we don't really ever talk about PASID, we have a
> 'user page table' that is bound to an entire RID and *all* PASIDs.
>=20
> While Intel would have a 'user page table' that is only bound to a RID
> & PASID
>=20
> Certianly it is not a difference we can hide from userspace.

Concept-wise it is still a 'user page table' with vendor specific format.

Taking your earlier analog it's just for a single 84-bit address space
(20PASID+64bitVA) per RID.

So what we requires is still one unified ioctl in your step-1 to support
per-RID 'user page table'.

For ARM it's SMMU's PASID table format. There is no step-2 since PASID
is already within the address space covered by the user PASID table.

For Intel it's VT-d's 1st level page table format. When moving to step-2
then allows multiple 'user page tables' connected to RID & PASID.

>=20
> > This would be easy for a single pgd. In this case the PASID table has a
> > single entry and userspace could just pass one GPA page during
> > registration. However it isn't easily generalized to full PASID support=
,
> > because managing a multi-level PASID table will require runtime GPA
> > allocation, and that API is awkward. That's why we opted for "attach PA=
SID
> > table" operation rather than "attach page table" (back then the choice =
was
> > easy since VT-d used the same concept).
>=20
> I think the entire context descriptor table should be in userspace,
> and filled in by userspace, as part of the userspace page table.
>=20
> The kernel API should accept the S1ContextPtr IPA and all the parts of
> the STE that relate to the defining the layout of what the S1Context
> points to an thats it.
>=20
> We should have another mode where the kernel owns everything, and the
> S1ContexPtr is a PA with Stage 2 bypassed.

I guess this is for the usage like DPDK. In that case yes we can have
unified ioctl since the kernel manages everything including the PASID
table.=20

>=20
> That part is fine, the more open question is what does the driver
> interface look like when userspace tell something like vfio-pci to
> connect to this thing. At some level the attaching device needs to
> authorize iommufd to take the entire PASID table and RID.

as long as smmu driver advocates only supporting step-1 ioctl,
then this authorization should be implied already.

>=20
> Specifically we cannot use this thing with a mdev, while the Intel
> version of a userspace page table can be.

yes. Supporting mdev is all the reason why Intel puts the PASID
table in host physical address space to be managed by the kernel.

>=20
> Maybe that is just some 'allow whole device' flag in an API
>=20

As said, I feel this special flag is not required as long as the=20
vendor iommu driver only supports your step-1 interface which
implies 'allow whole device' for ARM.

Thanks
Kevin
