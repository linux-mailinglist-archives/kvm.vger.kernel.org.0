Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF0A414038
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 05:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbhIVD6U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 23:58:20 -0400
Received: from mga04.intel.com ([192.55.52.120]:52561 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230054AbhIVD6T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 23:58:19 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="221623767"
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="221623767"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2021 20:56:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="585243134"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga004.jf.intel.com with ESMTP; 21 Sep 2021 20:56:23 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 20:56:20 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 20:56:20 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 21 Sep 2021 20:56:20 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 21 Sep 2021 20:56:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c8nYNn7GGcFsM9ydVYWS1Ae0IQTNFisbdfHwImod4Js5SjbNNqPd+DZSuPihZuuZKSrYKA4tHGXI3T1YlfqanI+/I9pSHj6TpJtFWMxJZq6CZIe4Xu4aLffZoKBokx8BHG/E9aQV4gU/EG5G4UQjzCTP+rWae+GRN7NJJy7aP2XNOPL9Uuz1oZrb+t6lwGU0fO7zjfKNTxggqEGV1Bv7MMQIxWAlygfSlgbZfnZR+wEmOLS1omOYwbJxqzfs4x4IhFtm13gV076/W89KJi2yqgXR2jwc//EWOURRBfvrHzLx4uwau6yICDPMFX49Xkqeg8riTrwQ1FZ31TVZIJTDbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=o+OTp9qlSEHqEAUFeaK98ILf46B2CNeUlikTKMv5WTk=;
 b=aJuYUJqcFUSXYqAn9SUQWrTJ77rE687yHy3EgM2TC17zwASyVSKhGlY1MvM+5kfRaX4BQvgZCUQpi+MmMhi6P6PqRlngfoKy+HiPaGLecz+ZsaSP5ewvFhfGgLOg1jy93tgCzTvC94/WKBB6y39YL+WgfMCTFYJ0qKwWwRhksH/0t6qrCuIEf65C5+0t8JbrOiZrh49EP5O+BRmWzanVxdmjXdkRiXMDgGbmPnQinwxgiDf5csfSwyEK4f0VeMmFmXkdoEtU0JcnHoMd3Cx0cihcX4tuP2izeU+NUmou+4Q/q5EsAu6Gx3Vm4e3X2RhKo2To9QdUgKv5cpGPH5uEDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o+OTp9qlSEHqEAUFeaK98ILf46B2CNeUlikTKMv5WTk=;
 b=Tv21JHs7E0dJKCdcjbCUyhbSa6vkup9rMRTltZOj69Jy7En60FLNMbiyqX+eYlC3Uv4T/2FK5112jikJJlQ9/NLobUCZLp5T1nfWTBqapapcubZ94BjihI36NIT4CkaxJ+0iFSWhZ/NPH/ejZpNA1vH1j3hW8tVa64AdIgI/fyU=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR1101MB2082.namprd11.prod.outlook.com (2603:10b6:405:51::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.17; Wed, 22 Sep
 2021 03:56:18 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 03:56:18 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, "Liu, Yi L" <yi.l.liu@intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: RE: [RFC 15/20] vfio/pci: Add VFIO_DEVICE_[DE]ATTACH_IOASID
Thread-Topic: [RFC 15/20] vfio/pci: Add VFIO_DEVICE_[DE]ATTACH_IOASID
Thread-Index: AQHXrSGrvqwDmY670Eehf+r4QAc6S6uuy+yAgACk0sA=
Date:   Wed, 22 Sep 2021 03:56:18 +0000
Message-ID: <BN9PR11MB543319F29F0260EBE2A9F3478CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-16-yi.l.liu@intel.com>
 <20210921180417.GZ327412@nvidia.com>
In-Reply-To: <20210921180417.GZ327412@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 04a17f96-f4c9-4bfb-32f5-08d97d7ceef2
x-ms-traffictypediagnostic: BN6PR1101MB2082:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR1101MB2082FC6C5F69B6AFCBA63E688CA29@BN6PR1101MB2082.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vWSIXwWCk0LYyRJEv11T/ymArCtqCb65iof2RDTWqiS0Wj2mqfwZrSUHNJp33s+LZ3gUELJ0cJ2zCZU+pnMgASKY0yaiOW7idgFhBzzMvC8jJnWfNH2Oret2u7oXlPVHLVy4dlSwlU6DOWOmHFdCkIpgKWG6TiHwUlWO1kk98MSQWEt5WYAEzvhvN2MaUkmaIltGQ37IXe8jIZWOrjZYIuWOcITZgq3DKzov/+LoSo6BlFDTr2k9NCKgs+7R1Apvf5wQszjsXE0zfjWlzokaVlySYSatBbcmnJ5rbetFUZ8Tt6mka5kCn8UO9XoUgiKJBKDK8PQEd9PTFhDso/6g12rUbd8Fd2fkPh0dhZ53jEL8xiuISKmiEldxchkeO1AojbmrsIFFadK7XYw2Hca9y58jop0am4BY1gSyAIFXIj47S5pgIS1qfsbsLQnLVLhCqDppsKoEV8HWIwhVM5O4CvViUhBe131DPTlWhMqGD7TCw2ff5YP4Rtj8AYz4aMymlVuLUZRaTwxN1uT0rM+IO8xkv5pM7fOgVX6IrAOwz6aFxutU/hPvXP4duhZZv7NjP8sn9B04jYC3FcoW5+wzbVUVlzVqrmG4oy/Q3GPQVX+WBFxfTMy+lHlShi7mTx3kCz2FQiEK/tPr1YtKQpLajx3fDk+9W+5TZWJyivNxgPi5bmBTEUu9RkP7mUqRQCZxeKtu0O+7WVd9puW1Ul5GJg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(66446008)(66556008)(66946007)(64756008)(8936002)(55016002)(8676002)(7416002)(9686003)(316002)(2906002)(7696005)(6506007)(186003)(54906003)(5660300002)(508600001)(4326008)(6636002)(76116006)(26005)(86362001)(52536014)(110136005)(71200400001)(33656002)(38070700005)(38100700002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9Qmpm67UXFhxjX6ZlPVMHUSGnjw/YouXcV6f86gDiAetknUmL5RA3fjs3Xzm?=
 =?us-ascii?Q?XjENzR1fARld8xm7yC9EfaxRDqX/6IYBKy4GSIQSUz3Cv3ZTtgxwxb8A23Jk?=
 =?us-ascii?Q?Dt8xJrcA0fj93AgdnsgrE5wayOV0L7J/kQlnGNxOYuTUCpHHVcCEzg1jAEnr?=
 =?us-ascii?Q?q9Wd6vvu4D5xU71hn/XvWDoQ4yGIAj77rxTYXpoPIZDzJDios455TD47IRvZ?=
 =?us-ascii?Q?RgySwPhW2xr302rAv751nzj7rGCN2r5y0xYYleGtmgQRQCwPXqK+jIrLTaOV?=
 =?us-ascii?Q?+Yb2IdatxiRpbOvBZ30VnEn0qc/VP+WXnMlhxl5a7jLWV0+BEP5BMZIxDKbU?=
 =?us-ascii?Q?WrNdNNok7xgvVpR5Yjg2BBdeCPbmM49VgQrQCi6G36K4zbwj45fp/AELV7VH?=
 =?us-ascii?Q?KZIHZBrgGzpI8qacEacxXKF8dM4pHaGIySXU5ouEnViZhLvVAA80TVu1Pi3K?=
 =?us-ascii?Q?qCgfKlwEEHuWVX70BxmWBaxwdNmAe+iUMMrmDRMzjsSX2Kv/l+JRreII4h2H?=
 =?us-ascii?Q?Clw1ZluiNk4u9qKcWPlkaHbz/DnzrWLxAxahYv8nIvIc+jAOLfoWHtaAfqAK?=
 =?us-ascii?Q?Jp2NJDWWgxLJolFw662TInqMtgT5mR5+sE5iBBWQtCwyb5N1jy2C33ZFB3qc?=
 =?us-ascii?Q?GGy2/sDn3JkogtsUGhc1nfdFlubfb8HZayuxl7zGmCyqvJI6l0lRT70TWDiv?=
 =?us-ascii?Q?jcUFGRQij1U4L4otebb4paDWUtLtL9eTR3bkAaHnoEB5EEXbA0rhKm7jiC/a?=
 =?us-ascii?Q?WO0f/aAeNRjx1F5SJVWQIQZ3h/K7SWCe+nsMiE4MF4IXs4MAcVrhKi0sZZJN?=
 =?us-ascii?Q?LZ3fq/ceOjFs2MDLdliGu+OogtAjQpwqMUY5Gw1BSDE7eKB+IfK6PlOoRlau?=
 =?us-ascii?Q?bwp0HrZ5rjRwT1u9/PcZttBSS0wOTFWuKanGMV2Ae5+tptKLpbrKnxRIYbo6?=
 =?us-ascii?Q?6F8cXw8qRpP++1nEAurnG6Am/a/Lu/cJ1/JB+8MMhi82wDhP1LtIqatjYclE?=
 =?us-ascii?Q?VNu9JhYhWojdqF/9/Hy9OmVqZTAe/lPBMwzZoBBWCKdfWfi08DGyu0GhOas5?=
 =?us-ascii?Q?zCdh6k5NcOytGOguy4UGUDaozbK0CvwGzFkuDAugMqcx5ig3IepTj/BxF0MZ?=
 =?us-ascii?Q?TjearQ51XkfRKuiwm+0pmDSCFFzZyJI4GTlEnePLHXfnmDI6+6yBgMDt99GW?=
 =?us-ascii?Q?L2eaFqGDRJKCDWkFwYTFm3mK8Ak2fesqYEsGA9phHQJGYcsPQ7WcEjP6bDKX?=
 =?us-ascii?Q?3LUfyxVfqV78HPwFr1Lwu8L1K0xPfr1wjgN9RL1XJkCnxAaYrQu7L2Ae/kmc?=
 =?us-ascii?Q?xeDztYL1eNk1uhyPb3rmi0Yt?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04a17f96-f4c9-4bfb-32f5-08d97d7ceef2
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 03:56:18.6364
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jahu8Ai9Rh/cp7x1PCKdWbsjMrDjgmgtLi+pers1q6b5mWv3W0gruwhnelB8YgLszipj42BQ4UMBbm9dnqT7Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2082
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, September 22, 2021 2:04 AM
>=20
> On Sun, Sep 19, 2021 at 02:38:43PM +0800, Liu Yi L wrote:
> > This patch adds interface for userspace to attach device to specified
> > IOASID.
> >
> > Note:
> > One device can only be attached to one IOASID in this version. This is
> > on par with what vfio provides today. In the future this restriction ca=
n
> > be relaxed when multiple I/O address spaces are supported per device
>=20
> ?? In VFIO the container is the IOS and the container can be shared
> with multiple devices. This needs to start at about the same
> functionality.

a device can be only attached to one container. One container can be
shared by multiple devices.

a device can be only attached to one IOASID. One IOASID can be shared
by multiple devices.

it does start at the same functionality.

>=20
> > +	} else if (cmd =3D=3D VFIO_DEVICE_ATTACH_IOASID) {
>=20
> This should be in the core code, right? There is nothing PCI specific
> here.
>=20

but if you insist on a pci-wrapper attach function, we still need something
here (e.g. with .attach_ioasid() callback)?
