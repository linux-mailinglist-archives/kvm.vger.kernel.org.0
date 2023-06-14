Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A82F72FB17
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 12:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234602AbjFNKfW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 06:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235426AbjFNKfR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 06:35:17 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F671BF8;
        Wed, 14 Jun 2023 03:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686738915; x=1718274915;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dIDOc7nHgqJx6oq+TZgHrWUTV8HPTb8u2Ywi8iQglUQ=;
  b=O9zc28AuU6upkdLLTG/EK8Go/JdmIdbmtjzcKiFC4Hywna4wRm8cjhRG
   TK/VS4vsDH4H49bhYDsoX2vO7Np43jQwE0UDHErFudXg6dGvRQxzHY90T
   KXvJYfyMys6Q8BtC/d5XL+FnU3WRUFJ2Pqyo0G3SQbcy+0SVKyaZay1zf
   egW8eZQ6g85VqQ7vkbc/M01F4J2OvZJqqW9lpcS8+LOomwuHFt+W972K9
   YAKWhWKTLnBDtUx3hyqmgGpd9d4Skzxme23tj0rHc/d7dRLWncRuDDsLB
   dLXDOllBeohO3U1R3wdx/N0W9AypwQS/nTTjb6npmy5fLBzt9v5iT2uWN
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="386986559"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="386986559"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 03:35:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="706175235"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="706175235"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 14 Jun 2023 03:35:14 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 03:35:13 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 14 Jun 2023 03:35:13 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 14 Jun 2023 03:35:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NyoLWhy63dtTTADpnC+xkTxOzOHhFcbljesCWztrCtQBByWCenXn2dIZyMTMyyvrcFqr6FH3spiMudmVuwEyM0jKYTtckbrImeEGc5zAEWC7hAPxMLU8l838oBjmqXQf6M+5sU0boKlXrvnQm5W35WzxPcZ2sDa9RrmW7S5nGVHGVLplp5GUDbDkpgKHOPhhaWApbq8RtoYkVM1MHeefpLeRGPydkCArmnT8eCCiNU+LF0gneye0gwtOQRCiramsTZQ02znSaFekFcni7lh7bnrM6cHDbMyXKNHFnHlSpbLBK0dilh3s9fNhYgQUpf0cWQ1FrLee14Q4MW7wVQIVcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d+W9whdnT/mRDJsgUmP2Zaya+Kp1CyJ7POqNfoWtGzs=;
 b=hxEefD517P49qYCgXDkAZW0CP8Lc5i2ZNJvshEMiCjEPVuM/RcJ594SI30wHt/jvOsNUw+hQLNkRi3ypb0BGHVLiuedpquoL9bJQiDX17mDa1zy6zQPZE7wE3KyH5I1yWDyFdy94/EwIFYaoIxnFuG6631rtIo93d4G3iBGd0AGz2E2bdagEI36xgrbDT6qHKoxzo7Ra1RAiyod9CCI/qmGv6kuCVzZlRK1AtemLhTyGL2SaGs3c8GcNrFWk1l6KRQ3BhFGr5+8+wXdY47/inkPC+wYBLY/CHLaLE9MB8CHnc23CTcv1eGzoJGjOBqQ2NIvAs3gxfcpnvHto/lnQZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB4805.namprd11.prod.outlook.com (2603:10b6:510:32::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 10:35:11 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 10:35:10 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v7 8/9] vfio/pci: Extend
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Thread-Topic: [PATCH v7 8/9] vfio/pci: Extend
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Thread-Index: AQHZlUvxjWjQHBtl702niB2RsWbvNK+JHZUAgAEMNoA=
Date:   Wed, 14 Jun 2023 10:35:10 +0000
Message-ID: <DS0PR11MB752932BD50E4F73FD7982DB0C35AA@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121515.79374-1-yi.l.liu@intel.com>
 <20230602121515.79374-9-yi.l.liu@intel.com> <ZIi0Bizk9qr1SgJ/@nvidia.com>
In-Reply-To: <ZIi0Bizk9qr1SgJ/@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH0PR11MB4805:EE_
x-ms-office365-filtering-correlation-id: 3d1627b1-e082-407f-208a-08db6cc30794
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ktaF0ZV0lWUKqJ4F639WU8mivKw8H4Z6dWYi2R7SBjdVSDDERHYZ123uTJdakYwQZN8se2TXEdpD/GLEcOQx7IwPbhc2rwFlaQ/HhbKocqZka0Q/Xu4/gpsyzequyD+BPWZXjut5eJVXNiHRxMaiySzcH75Cl2FPaFpN8KIf7FUY3V1fi+HaboI60CPHDxoWbfnQXH/CvrzbFoo4jboQQU4KWVcJpUmOi9QIO47CehMn4gJJQY4zEdiJIzYO6SZHXKqWf6LgMrZSTpd3n4UG3CkLu0K0GGbxtBcO06ysFdvyJq4iFE8hISMRdatfkyurmvccJKddQvlT6/SVGF/x2kohZqqnkaJ1muJGCmayX5wGdQ0DJEYhcl1qhiHzF0RzwWb9IMVaxShmIWpC1MIjqTZAtcOsUURnWQeghflcRkkKPj2bxRiCENFDWqhD1S+L3pZNhEP8fQuE0k8gMAUP8Cu+t96PmIyxE8/cwqHT6au5ijt05QWgQ+eFpj7CrtEd6xEQdpzDyppastZ+uuN6CM/mR5iEnchTeZMMegjbsVaOPoKnlqjP7Taim8IsTbhT7BCp/0KG1Lk7Yeb9WuEvjpwaz6Z+pAjTUm9WVT6myYbp8nyWGEH8RuLM9hvh0yrx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(136003)(366004)(396003)(376002)(451199021)(8676002)(8936002)(2906002)(5660300002)(316002)(64756008)(66446008)(66476007)(66556008)(66946007)(33656002)(52536014)(82960400001)(76116006)(4326008)(6916009)(122000001)(38100700002)(83380400001)(54906003)(41300700001)(478600001)(186003)(9686003)(6506007)(26005)(71200400001)(7416002)(55016003)(7696005)(38070700005)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KvPD/YHIvDweO5WEq5HRMNwSdxdTxEo2fvx7vCdWUE7+/eDnpUL7Y3fze6N9?=
 =?us-ascii?Q?vHrK4fIsyZxSN79JidccyF2HhbMY1va9EXUHP6lgbNs2sJI7a/a0R001U3QO?=
 =?us-ascii?Q?PsEmRafZ13pWqc8REtWHD5yXiCc05YF0VQk9/YHnxj8zEzSYPVFVSC2UGDO1?=
 =?us-ascii?Q?MYLCRirtfsIut9LTHOu6FnNAa5aHf9qh9UAbZMXL0wRFuthtzmjEJ5ErzBZ3?=
 =?us-ascii?Q?CHO4TLGVdRvaV0yd8BhnBMH0/rLoXf68JO0dptiMq2HRO12II917QdxBlWVm?=
 =?us-ascii?Q?hmFopQY3udS7cXe/TTDYVfSqKIEWWJzkjxH0UmYgHmh949DQagEo0rfmW5Mw?=
 =?us-ascii?Q?clSpNOyR+oEZtwpl1shMs1IclRaqf5iLH+uVoZhjJ/Zp+SXSCys6XsTAwE39?=
 =?us-ascii?Q?6Ykhd9Xw7Lac3lgzgdff/q3ZBvD7WzBi7iIYieb/jHSZDDBt2P/wn3yqL8Jd?=
 =?us-ascii?Q?mRbVfM1yA8+1UzlGjz0tylP3Cd53F89K/UN8X4EKApn8xvtx8ckn4GvGAvSh?=
 =?us-ascii?Q?1RMzKXklWeR4HbNTXNRLhiTdfhNza6LzgNG8FdMpCVXoTMe6J0iTSvbaUiTe?=
 =?us-ascii?Q?stjnMDgmkvLla71dLPwh93LDqRUuuHoHnvDG2DCZpt519bNAiVu/DEnC/yU7?=
 =?us-ascii?Q?JD8vUjgTbU1bJvyPoJ2vj41KmVVjl8TrZfy2KewmBsMzHpj6s75K9AJcTk/e?=
 =?us-ascii?Q?+JBma71TubDdE9tZVuC2VbajWft0p/khPuKoX9DrTwkuffB1UhbYWtmafH85?=
 =?us-ascii?Q?6cWZcvpR5IgFGuz0yAYP3mYABJs8U4ffP9hZ3K6Tjwi1mgCvw6o0BQAob2sz?=
 =?us-ascii?Q?zUoWLU0h4D2r/6Ggyw16hmis1ttl5stiYTG/+noFhFmaDq1hfT1D+vvdEQHu?=
 =?us-ascii?Q?jZOahwdHM2CRsIQprL695tvjm9zmUgDFjIHA7MCu5hNGvQ3XPuaTZyB77CQV?=
 =?us-ascii?Q?tq6rMdcr5c9QxMV7Y5OmpP9or/6HnnrXktRBA9+J1bJw7t0Gj7HJ4VGzdKOD?=
 =?us-ascii?Q?64VsANH4h+ySYYp2oUNMupu/BEaN2rp2yDfPvoimbuu0etHd4SnQtZOMP3Nh?=
 =?us-ascii?Q?/8O8n2U8+Dw4bCrQ/XJDROnsKv1sZswcVi0OZi1dSlviZfvOSjBWHkNT3+Zk?=
 =?us-ascii?Q?jexcvVgattNZSv3QywC6FmpSoKAeiZlXKxFdh8aiECMUhqnNBG3ua6+2vG6Z?=
 =?us-ascii?Q?jOBdRqIR2YPmDDXVqC1ldOWJrWSE9P5r7TbofX/Xc1UpBa53DTj8yhVl9Qmf?=
 =?us-ascii?Q?kmnYpEHO+0txHq7q/ceAKae29SbvTNDMQQLBEDuxwLKRc//cjVrnyElzlxYc?=
 =?us-ascii?Q?ziDXUdWfoYAIIGcXJ15TQi5VWx8TBe1o3MlCWFxsr5XRq+JGI4EJTZsPGGdw?=
 =?us-ascii?Q?npb/Mj67ebnwZEI5ilVkRtw0hEN+RKQBsDaTC38vXjzKckggOod6P/6nRlTs?=
 =?us-ascii?Q?/Hh+MkkoJqD/2R3KOwAzKQ//j+L/hfgPycKPjGkYj5TX8GuaFXLomOGgCo9h?=
 =?us-ascii?Q?vOb6zCS2ndln/qFyUww5NKIXGSVOTGtiNwq66PCWz+n6uChopvRpFepEOHT3?=
 =?us-ascii?Q?5I/E8tsegpqMwx5/ex1qCrqqSgtJzbl2IJd2b88K?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d1627b1-e082-407f-208a-08db6cc30794
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 10:35:10.4332
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RLmOhn34x7UruF56ld41TBLzpstmwH3f8ocU5pSs7lmkITBOC6oQdIV6+Rx78nkOPRDnDioZW69bLcJFs6hWbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4805
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, June 14, 2023 2:23 AM
>=20
> On Fri, Jun 02, 2023 at 05:15:14AM -0700, Yi Liu wrote:
> > This allows VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl use the iommufd_ct=
x
> > of the cdev device to check the ownership of the other affected devices=
.
> >
> > When VFIO_DEVICE_GET_PCI_HOT_RESET_INFO is called on an IOMMUFD managed
> > device, the new flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID is reported to indi=
cate
> > the values returned are IOMMUFD devids rather than group IDs as used wh=
en
> > accessing vfio devices through the conventional vfio group interface.
> > Additionally the flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED will be repo=
rted
> > in this mode if all of the devices affected by the hot-reset are owned =
by
> > either virtue of being directly bound to the same iommufd context as th=
e
> > calling device, or implicitly owned via a shared IOMMU group.
> >
> > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/iommufd.c           | 49 +++++++++++++++++++++++++++++++
> >  drivers/vfio/pci/vfio_pci_core.c | 47 +++++++++++++++++++++++++-----
> >  include/linux/vfio.h             | 16 ++++++++++
> >  include/uapi/linux/vfio.h        | 50 +++++++++++++++++++++++++++++++-
> >  4 files changed, 154 insertions(+), 8 deletions(-)
>=20
> This could use some more fiddling, like we could copy each
> vfio_pci_dependent_device to user memory inside the loop instead of
> allocating an array.

I understand the motivation. But have some concerns. Please check
inline.

> Add another patch with something like this in it:
>=20
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci=
_core.c
> index b0eadafcbcf502..516e0fda74bec9 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -775,19 +775,23 @@ static int vfio_pci_count_devs(struct pci_dev *pdev=
, void
> *data)
>  }
>=20
>  struct vfio_pci_fill_info {
> -	int max;
> -	int cur;
> -	struct vfio_pci_dependent_device *devices;
> +	struct vfio_pci_dependent_device __user *devices;
> +	struct vfio_pci_dependent_device __user *devices_end;
>  	struct vfio_device *vdev;
>  	u32 flags;
>  };
>=20
>  static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
>  {
> +	struct vfio_pci_dependent_device info =3D {
> +		.segment =3D pci_domain_nr(pdev->bus),
> +		.bus =3D pdev->bus->number,
> +		.devfn =3D pdev->devfn,
> +	};
>  	struct vfio_pci_fill_info *fill =3D data;
>=20
> -	if (fill->cur =3D=3D fill->max)
> -		return -EAGAIN; /* Something changed, try again */
> +	if (fill->devices_end >=3D fill->devices)
> +		return -ENOSPC;

This should be fill->devices_end <=3D fill->devices. Even it's corrected. T=
he
new code does not return -EAGAIN. And if return -ENOSPC, the expected
size should be returned. But I didn't see it. As the hunk below[1] is remov=
ed,
seems no way to know how many memory it requires.

>=20
>  	if (fill->flags & VFIO_PCI_HOT_RESET_FLAG_DEV_ID) {
>  		struct iommufd_ctx *iommufd =3D vfio_iommufd_device_ictx(fill->vdev);
> @@ -800,12 +804,12 @@ static int vfio_pci_fill_devs(struct pci_dev *pdev,=
 void *data)
>  		 */
>  		vdev =3D vfio_find_device_in_devset(dev_set, &pdev->dev);
>  		if (!vdev)
> -			fill->devices[fill->cur].devid =3D VFIO_PCI_DEVID_NOT_OWNED;
> +			info.devid =3D VFIO_PCI_DEVID_NOT_OWNED;
>  		else
> -			fill->devices[fill->cur].devid =3D
> -				vfio_iommufd_device_hot_reset_devid(vdev, iommufd);
> +			info.devid =3D vfio_iommufd_device_hot_reset_devid(
> +				vdev, iommufd);
>  		/* If devid is VFIO_PCI_DEVID_NOT_OWNED, clear owned flag. */
> -		if (fill->devices[fill->cur].devid =3D=3D VFIO_PCI_DEVID_NOT_OWNED)
> +		if (info.devid =3D=3D VFIO_PCI_DEVID_NOT_OWNED)
>  			fill->flags &=3D ~VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED;
>  	} else {
>  		struct iommu_group *iommu_group;
> @@ -814,13 +818,13 @@ static int vfio_pci_fill_devs(struct pci_dev *pdev,=
 void *data)
>  		if (!iommu_group)
>  			return -EPERM; /* Cannot reset non-isolated devices */
>=20
> -		fill->devices[fill->cur].group_id =3D iommu_group_id(iommu_group);
> +		info.group_id =3D iommu_group_id(iommu_group);
>  		iommu_group_put(iommu_group);
>  	}
> -	fill->devices[fill->cur].segment =3D pci_domain_nr(pdev->bus);
> -	fill->devices[fill->cur].bus =3D pdev->bus->number;
> -	fill->devices[fill->cur].devfn =3D pdev->devfn;
> -	fill->cur++;
> +
> +	if (copy_to_user(fill->devices, &info, sizeof(info)))
> +		return -EFAULT;
> +	fill->devices++;
>  	return 0;
>  }
>=20
> @@ -1212,8 +1216,7 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
>  	unsigned long minsz =3D
>  		offsetofend(struct vfio_pci_hot_reset_info, count);
>  	struct vfio_pci_hot_reset_info hdr;
> -	struct vfio_pci_fill_info fill =3D { 0 };
> -	struct vfio_pci_dependent_device *devices =3D NULL;
> +	struct vfio_pci_fill_info fill =3D {};
>  	bool slot =3D false;
>  	int ret =3D 0;
>=20
> @@ -1231,29 +1234,9 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
>  	else if (pci_probe_reset_bus(vdev->pdev->bus))
>  		return -ENODEV;
>=20
> -	/* How many devices are affected? */
> -	ret =3D vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_count_devs,
> -					    &fill.max, slot);
> -	if (ret)
> -		return ret;
> -
> -	WARN_ON(!fill.max); /* Should always be at least one */
> -
> -	/*
> -	 * If there's enough space, fill it now, otherwise return -ENOSPC and
> -	 * the number of devices affected.
> -	 */
> -	if (hdr.argsz < sizeof(hdr) + (fill.max * sizeof(*devices))) {
> -		ret =3D -ENOSPC;
> -		hdr.count =3D fill.max;
> -		goto reset_info_exit;
> -	}

[1] The loop in this hunk figures out how many devices are affected
      and also figures out how many memory is needs.

> -
> -	devices =3D kcalloc(fill.max, sizeof(*devices), GFP_KERNEL);
> -	if (!devices)
> -		return -ENOMEM;
> -
> -	fill.devices =3D devices;
> +	fill.devices =3D arg->devices;
> +	fill.devices_end =3D arg->devices +
> +			   (hdr.argsz - sizeof(hdr)) / sizeof(arg->devices[0]);
>  	fill.vdev =3D &vdev->vdev;
>=20
>  	if (vfio_device_cdev_opened(&vdev->vdev))
> @@ -1264,29 +1247,14 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
>  	ret =3D vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_fill_devs,
>  					    &fill, slot);
>  	mutex_unlock(&vdev->vdev.dev_set->lock);
> +	if (ret)
> +		return ret;
>=20
> -	/*
> -	 * If a device was removed between counting and filling, we may come up
> -	 * short of fill.max.  If a device was added, we'll have a return of
> -	 * -EAGAIN above.
> -	 */
> -	if (!ret) {
> -		hdr.count =3D fill.cur;
> -		hdr.flags =3D fill.flags;
> -	}

This mechanism is also removed though it may be rare.

> -
> -reset_info_exit:
> +	hdr.count =3D fill.devices - arg->devices;
> +	hdr.flags =3D fill.flags;
>  	if (copy_to_user(arg, &hdr, minsz))
>  		ret =3D -EFAULT;
> -
> -	if (!ret) {
> -		if (copy_to_user(&arg->devices, devices,
> -				 hdr.count * sizeof(*devices)))
> -			ret =3D -EFAULT;
> -	}
> -
> -	kfree(devices);
> -	return ret;
> +	return 0;

should still return ret as "if (copy_to_user(arg, &hdr, minsz))" can
fail.

>  }
>=20
>  static int

It appears to me there are subtle changes in the uapi (-ENOSPC, -EAGAIN).
Though uapi header didn't document them. But per the comment in the
code, it's changed. Maybe we can do it in a follow-up patch instead of
part of this series.

Regards,
Yi Liu
