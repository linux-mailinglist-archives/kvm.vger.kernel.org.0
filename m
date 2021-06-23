Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 973043B13C4
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 08:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbhFWGO1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 02:14:27 -0400
Received: from mga03.intel.com ([134.134.136.65]:14188 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229660AbhFWGO0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 02:14:26 -0400
IronPort-SDR: IDzPU07UmygxqFqs5Q/j9UFMgLZlULWdk8dK+aLl7axCk+f/eNADMERNHwXfnpzUThQueLUwvM
 Y0jWsZbtqp9A==
X-IronPort-AV: E=McAfee;i="6200,9189,10023"; a="207242180"
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="207242180"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 23:12:08 -0700
IronPort-SDR: wlf6aR5CTAjPcz5UJ/I213MlaWlQL5HFpLbL5Yx9XscKfFcmNpKezngHsjQhg9JE6xWorEfIZ1
 Rm8N3dR9avRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="474029939"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga004.fm.intel.com with ESMTP; 22 Jun 2021 23:12:08 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 22 Jun 2021 23:12:07 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Tue, 22 Jun 2021 23:12:07 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Tue, 22 Jun 2021 23:12:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=id1RRg7zxEodeuny6jisJYV0W5SVpbuvNWTK6Wb1s0sEk8blwKAtFnJZMLqSXa+aIFNBNv67ScVx+3KPD4cfKplq46aOcM3UrqntaDS9I4avraec2hVe5Xz1xWZc8iglSQTa3UWzCIoroTJv5BIXND4sxn35VEuaKI+wkFDlhBBh1zc8+IIEVx3X4R+762m1/+uZkrWPf/3GKMjKv4DCjwUyfazD1+3jxU/5DRZq0wdIB4F0m6oYCe8tXEMGSXjIfdrd4MbU4j/uNXUEv3Jac4XwZPRC76gUALbU1/TMSwqkqZHMDkw/za/hcDfl27XZx6fByucXtHViTuvNFEzXnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bBF78xKmjEK1sBc0JBajRBIHHNZ7kM/d7g5MKC+R0Sc=;
 b=V3MCYyAzSiDPrlQPVojuhdDHlailCirh1gjMp0wSx9UoLjp4pIb15HVC/QelBnDSE/0WfAiWgeBh68KVWqOCMzTFM2OzEueATbKNnCVfdBgXzlUcGq2/gUBdQ55OgnRVNvUKBPTHSfpscQkNhJMh3cUGu3A3C4dHebN5BKt2pyeQ5rdDqJ1EvyDMO8RF7ODOKXzTfuDMR9qONwMyjl34uRHh9RVUTRNFQqccAC/CospFjPLRuq5XhN8wwdP6jbzOULUta2eZQTQv8Oj9HLoiA4jKxczxdu8uzdHwfMUWCWdH3/mx8GU1Cmq3IuW9KTkl7DeXv5NwHvjj07EccIPhRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bBF78xKmjEK1sBc0JBajRBIHHNZ7kM/d7g5MKC+R0Sc=;
 b=kRT2JKgYROU1R1S/NTDvqXKphLUWT9NZxV4+GtMF0MZX1YLiVMEqtNx2N1LP2DvvL3lkGZJrljtBFgWB4OV9ri9DJjc/n5GD6CDF7+hj7AmWa/6CBurPYbHnpPkicOIOTUoikW48j7wv96TEWKxNojYhJoAy/0qw7XdIwRJYxFc=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1838.namprd11.prod.outlook.com (2603:10b6:300:10c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Wed, 23 Jun
 2021 06:12:06 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4242.024; Wed, 23 Jun
 2021 06:12:06 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "Dey, Megha" <megha.dey@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        "Bjorn Helgaas" <helgaas@kernel.org>
Subject: RE: Virtualizing MSI-X on IMS via VFIO
Thread-Topic: Virtualizing MSI-X on IMS via VFIO
Thread-Index: AddnMs7+4GfLhTceT8q8tdV8716lmQAZ7UiAAAoHBgAACsXtAA==
Date:   Wed, 23 Jun 2021 06:12:05 +0000
Message-ID: <MWHPR11MB1886811339F7873A8E34549A8C089@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210622131217.76b28f6f.alex.williamson@redhat.com>
 <87o8bxcuxv.ffs@nanos.tec.linutronix.de>
In-Reply-To: <87o8bxcuxv.ffs@nanos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.143.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b5517e82-c994-4b75-0702-08d9360dd3ba
x-ms-traffictypediagnostic: MWHPR11MB1838:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1838115E67113097A8B6E0DD8C089@MWHPR11MB1838.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nHT4dwRHQb6ynXOPefr4G5wvyvr0Z9b9M5Lp5HEGfz6Gakv5qGUJUSKfpv/idJSm27rnS6kiHdRomRLCKzdWwggWD3c7rhREgTZQHwWnGGnArQJNdObtC1NzOGz1DNqWCPMjF18uCudmFweCF3QbVmealcY4tEYx2viLz4tc7qyvB3FHhaGRpVFDIKfJ7C2p7npywldHWB2OxjeGQ+bgMswyIVJr1U7/U5G8KCwG8ONwZ1w8gcnZkqyQcR8Vde1TarpqmDILyt36asSZouqd9TsdEf2AUVcD2yGjMJoTZeDAz0UxBk3Qx8O5xqfkhBwDiLoMrsDPibqqE/ysZCss02qbdL0U4n6pzD0Vx4uG0E6hZ9mrIW9R9YfiZLdYnzyysZWaxHwQSsFQ7XUX+TjEWD/I78oYeNNhfRPZ4h8VqJlqktTPq7JnxOVvZtOQuzZnrumag7C2JTG5NkodUSTHkakJcqbOT42XaCHZvTI79ErML1ysRvvsR6BLOtDYCCuy3cWedKbgJvJvbsoR0IIMIiyQ9anUQTNE6t5pS9ZZBj03BQIhZm0opBqak0dQ+zZYPeIOF9zcoOvZiBoFL9HKDxQIygkOpAPiCPuM0skJTIMgvUOptIIfy5VPzuyL8q0jtMGNZu/tlWxL3/IIJc5D+g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(346002)(376002)(39860400002)(66946007)(66446008)(64756008)(66556008)(8936002)(66476007)(86362001)(33656002)(8676002)(6506007)(2906002)(26005)(83380400001)(76116006)(71200400001)(186003)(5660300002)(4326008)(9686003)(55016002)(478600001)(7416002)(122000001)(38100700002)(316002)(7696005)(110136005)(52536014)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eRmaYAUJhyAThFD7u/QITo/tH6qigT0dSeIGrDequrrOkKJ+cFG6iQcNCh1z?=
 =?us-ascii?Q?FcpheZbz179z1w5EVIy/hjwpYkKy1+DX2RJymT6KElx+7VERLXDzVSFDaNNf?=
 =?us-ascii?Q?mpBH67uQ8K2eCJr9rQ+MxklR7eCBcvyesl9fMGTsHNcjSLQgdTTL3JVD42Jj?=
 =?us-ascii?Q?uqqvbiSTqJl8USGYk85UC5mV8ezy3MN8RaqzUtVyNK0/qBsZ/nTX39zutxNr?=
 =?us-ascii?Q?f8guOZpaVFCi0tRg9gclZwQ/rjHgaB9cbWzDXc2N64A3q1pAklUYc1IcDugT?=
 =?us-ascii?Q?zCcgpIA5qPCisVOatU/zikJe55Y3cAPo1qPk9wdYMmN+7Nbbt31xLbtvHi9k?=
 =?us-ascii?Q?QdKirkCS4Iutt/0/zhXk14QZUCrlsGqY5ejrJeSQtxJX6re9G/G09UxWZS82?=
 =?us-ascii?Q?QKdfM06S9L16UI6gRs4q6T/P+CRJKATeUbo8T/ERCXkIqEAu2f9+aRsX9zgr?=
 =?us-ascii?Q?RHCB0sMdi64Sd1wqZw7hZdu3adNkWMDeq+mtn92WsKjkwZhaVjLdI8brTVJA?=
 =?us-ascii?Q?RY2RXduHWy9NQleyYl1CA+2VgPISPBiqa4TCxCnqRJBCTpSwoSHPyT7BavK4?=
 =?us-ascii?Q?bIE1x4/jjBR4xgV3SDzuHgrB/Bn84zXjU0x/IzoQyTFCP3WLknfrBGUDsKHP?=
 =?us-ascii?Q?4ufQ+fUPmbhGlP+ez0QQv0ypd3/80kO8Kj/w86IiS1eYJNpfiMCG1NK4H3VS?=
 =?us-ascii?Q?/g1r5FjtOiO7bK7d33EpmyetDfm3oGK4XJN4zSJigJ9QJMOK7lQ9KW+7u1xB?=
 =?us-ascii?Q?K3LENmCOAOuU0ylVJi8q4L/Wqely5ryKOvFgvelhwJztGmtukagZXHJt4XHF?=
 =?us-ascii?Q?CcMhqmBuMpnIwnfpEGOpXwRs+VoCRkEqThkIK4VRTr++VKyeepod9eiH9J2H?=
 =?us-ascii?Q?N8D4QQcrPreb7JINJd+aOdcI/6qOUJU+Ar+sRIT+pofm1Wi9h64qQoPXM2NE?=
 =?us-ascii?Q?3cTVQ8xSn5+7O6HCrMjnqJ4hDaumzunnonlHVH9ZxyptqtiBeS+pAKy99KgX?=
 =?us-ascii?Q?UIYjE1BKKbqrbvq4QjpFZE4c0OnuWp5oSbCtn3/0TU69Mni5pNR4t0AABrYc?=
 =?us-ascii?Q?2gA1Pcuc/p+oNRfPSnz3Ftyd2KagoNwU+yHgn2EvScEf22o8S1GCp6yQqfBh?=
 =?us-ascii?Q?9r0opkLACpPPXX/Q3F/JdotC1BkGMofk0tQYDwLmTZe3xKqDOlSLj1JcpywI?=
 =?us-ascii?Q?4YtLyGaAHtsSdhRVC/vnifaZOuK5fTQckifXeoSFUQ6kGzxsA0T8eFmsBeNg?=
 =?us-ascii?Q?VB1AVKMECJDb0bU2ENuY2CrQ3N4xo9ZbLc9v2RfLdn6Rj/kS42amvoiDE5R6?=
 =?us-ascii?Q?Djr1QxoNopoaa1D5Fab0pj7H?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5517e82-c994-4b75-0702-08d9360dd3ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2021 06:12:05.9326
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ILoPIjJ9CUspIjUvnzLLMeGFuYCk1IHe2QT9rGh8bNxflKMGgDVAsl+ADuBhFf8nUbWU1SOgGWUbQYS2a0Aeag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1838
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Thomas Gleixner <tglx@linutronix.de>
> Sent: Wednesday, June 23, 2021 7:59 AM
>=20
[...]
> I only can assume that back then the main problem was vector exhaustion
> on the host and to avoid allocating memory for interrupt descriptors
> etc, right?
>=20
> The host vector exhaustion problem was that each MSIX vector consumed a
> real CPU vector which is a limited resource on X86. This is not longer
> the case today:
>=20
>     1) pci_msix_enable[range]() consumes exactly zero CPU vectors from
>        the allocatable range independent of the number of MSIX vectors
>        it allocates, unless it is in multi-queue managed mode where it
>        will actually reserve a vector (maybe two) per CPU.
>=20
>        But for devices which are not using that mode, they just
>        opportunistically "reserve" vectors.
>=20
>        All entries are initialized with a special system vector which
>        when raised will emit a nastigram in dmesg.
>=20
>     2) request_irq() actually allocates a CPU vector from the
>        allocatable vector space which can obviously still fail, which is
>        perfectly fine.
>=20
> So the only downside today of allocating more MSI-X vectors than
> necessary is memory consumption for the irq descriptors.

Curious about irte entry when IRQ remapping is enabled. Is it also
allocated at request_irq()?

>=20
> Though for virtualization there is still another problem:
>=20
>   Even if all possible MSI-X vectors for a passthrough PCI device would
>   be allocated upfront independent of the actual usage in the guest,
>   then there is still the issue of request_irq() failing on the host
>   once the guest decides to use any of those interrupts.
>=20
> It's a halfways reasonable argumentation by some definition of
> reasonable, that this case would be a host system configuration problem
> and the admin who overcommitted is responsible for the consequence.
>=20
> Where the only reasonable consequence is to kill the guest right there
> because there is no mechanism to actually tell it that the host ran out
> of resources.
>=20
> Not at all a pretty solution, but it is contrary to the status quo well
> defined. The most important aspect is that it is well defined for the
> case of success:
>=20
>   If it succeeds then there is no way that already requested interrupts
>   can be lost or end up being redirected to the legacy PCI irq due to
>   clearing the MSIX enable bit, which is a gazillion times better than
>   the "let's hope it works" based tinkerware we have now.

fair enough.

>=20
> So, aside of the existing VFIO/PCI/MSIX thing being just half thought
> out, even thinking about proliferating this with IMS is bonkers.
>=20
> IMS is meant to avoid the problem of MSI-X which needs to disable MSI-X
> in order to expand the number of vectors. The use cases are going to be
> even more dynamic than the usual device drivers, so the lost interrupt
> issue will be much more likely to trigger.
>=20
> So no, we are not going to proliferate this complete ignorance of how
> MSI-X actually works and just cram another "feature" into code which is
> known to be incorrect.
>=20

So the correct flow is like below:

    guest::enable_msix()
      trapped_by_host()
        pci_alloc_irq_vectors(); // for all possible vMSI-X entries
          pci_enable_msix();     =20

    guest::unmask()
      trapped_by_host()
        request_irqs();

the first trap calls a new VFIO ioctl e.g. VFIO_DEVICE_ALLOC_IRQS.

the 2nd trap can reuse existing VFIO_DEVICE_SET_IRQS which just
does request_irq() if specified irqs have been allocated.

Then map ims to this flow:

    guest::enable_msix()
      trapped_by_host()
        msi_domain_alloc_irqs(); // for all possible vMSI-X entries
        for_all_allocated_irqs(i)
          pci_update_msi_desc_id(i, default_pasid); // a new helper func

    guest::unmask(entry#0)=20
      trapped_by_host()
        request_irqs();
          ims_array_irq_startup(); // write msi_desc.id (default_pasid) to =
ims entry

    guest::set_msix_perm(entry#1, guest_sva_pasid)
      trapped_by_host()
        pci_update_msi_desc_id(1, host_sva_pasid);

    guest::unmask(entry#1)
      trapped_by_host()
        request_irqs();
          ims_array_irq_startup(); // write msi_desc.id (host_sva_pasid) to=
 ims entry

Does above match your thoughts?

Thanks
Kevin
