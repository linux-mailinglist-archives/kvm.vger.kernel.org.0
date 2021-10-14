Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E3142D46B
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 10:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhJNIEF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 04:04:05 -0400
Received: from mga12.intel.com ([192.55.52.136]:22585 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230020AbhJNIED (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 04:04:03 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10136"; a="207740443"
X-IronPort-AV: E=Sophos;i="5.85,372,1624345200"; 
   d="scan'208";a="207740443"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2021 01:01:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,372,1624345200"; 
   d="scan'208";a="571156405"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga002.fm.intel.com with ESMTP; 14 Oct 2021 01:01:55 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 14 Oct 2021 01:01:54 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 14 Oct 2021 01:01:54 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 14 Oct 2021 01:01:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eGcFLntTkZBqDHB5xL2YHmLnQcSadvKKjwf0Pk5UeO+qv38IidcsG/2xOIDkO5fLbXZvI2CBZQG0VKGe9d1FzHFLVC30dnIXauGQahnXa6xPJX1MvoUeuq7EpqVHRNDVWEB5wgHfyjYXcPMZlT6vZMZVUQvc6rdrDYXQIXlP6v51DCbTJVI3e9q3gmIgzR3vs2w4zgqMIlszHlEKbQ7QMVoSHHnxmh8UYAuCWONeQ06lKkfSmr4CNRt6iktY/1uwBBC2qrouUsZP8G9ZAvzF5W8WR+wlrG5yhIFCBClUz+k72QQyuojm6MmF3vEd4UsVXbjNXu+a9pwewrXvK997Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cmNjSN1f+shia+GAffoh46m4uUHo3zHayWX+yh+d59w=;
 b=LH+KU/Vi13Sl90qAl6Mu4OHaaM8iO2cSfcqRWGFvrqGQPGVDwPgeOa4z961YwKYrivx4Bwg9FquwanNzcekit1DEYMVtabAZm1CjJoCNstUXoaCf2bO/CoKaEcP5fri2bbPfp7CYKD7j+IyuVz0CPLdqL9je9NahrAtxqDAdgiLLEF+GGrXZLBjX0dxKn2XoXWygkwb+m95+qMiMv2cRsVdigha9NX/pnftpuzWyJ9GdYIaBeFox8EZVi0tY8R4ZIkbeVT7F2otRfAt1pBBbNk0A5j2IXlAya5xTBx93TAm1H/b3p/QMTtqF+r17pxG34+KyeoZ9Ry6Sbyg92BoNew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cmNjSN1f+shia+GAffoh46m4uUHo3zHayWX+yh+d59w=;
 b=xm1W4PtOKru7LgIzZjewysKzqjCeN1pjJ85qDbNoTYLSJxC9c5jN2yOong8IV5n+EZfdaRu1R6d9l1GTu7Cw+HkXwP9PpIZB9YAcoNZyJqWuk6YyQ4pngmeY9ge88dDLipJRxHT7THSbj+O7blguotaKGjEhfnnKQbIYZXViv14=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN9PR11MB5531.namprd11.prod.outlook.com (2603:10b6:408:104::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.20; Thu, 14 Oct
 2021 08:01:49 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4608.016; Thu, 14 Oct 2021
 08:01:49 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "hch@lst.de" <hch@lst.de>, "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "parav@mellanox.com" <parav@mellanox.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Thread-Topic: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Thread-Index: AQHXrSGNbNtRgavabUSKJjvt8l12BauwlhaAgAAouwCAACufAIAAgyUAgAAUFACAAAdkgIAAB/8AgAkqbYCAAEeFAIABQYSQgAAuX4CAFdW7UA==
Date:   Thu, 14 Oct 2021 08:01:49 +0000
Message-ID: <BN9PR11MB543330751AD68F70E89BC0FA8CB89@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210922152407.1bfa6ff7.alex.williamson@redhat.com>
 <20210922234954.GB964074@nvidia.com>
 <BN9PR11MB543333AD3C81312115686AAA8CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YUxTvCt1mYDntO8z@myrica> <20210923112716.GE964074@nvidia.com>
 <BN9PR11MB5433BCFCF3B0CB657E9BFE898CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210923122220.GL964074@nvidia.com>
 <BN9PR11MB5433D75C09C6FDA01C2B7CF48CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210929123630.GS964074@nvidia.com>
 <BN9PR11MB5433C9B5A0CD0B58163859EC8CAA9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YVWSaU4CHFHnwEA5@myrica>
In-Reply-To: <YVWSaU4CHFHnwEA5@myrica>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 72c25e27-aa90-44f9-9ab1-08d98ee8e071
x-ms-traffictypediagnostic: BN9PR11MB5531:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN9PR11MB55312473980C7043A85894E98CB89@BN9PR11MB5531.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QrGpV4FMCfOndkHEHQMVwqHbz3QT7J7WZPQLu7HkZ08skxiM6Dag4CmbLw2dqRPZz37XAwqK0IAPx76h57BVbSOsXDU2/wBYNq11vLuOBgZeFMSCRzlNIlW8+r0aXCIolrl6Q79Bimq3atQk5ZiC8i2RK/xkZD010voxlf4ex/4CPzj7jc89E+VautxvGsnQC11sN2j9JqNFwdw96VqI+o2hvn+M+ZHiF7pr6B+/3ngPxzGK2iyBatY9jfYS/P7llBf1sWF95prYSYWQq+CIoqJ6UYL4HIYscx/A+dmh8amLYnbtDqtWsKqkO50ZrFbHcNVX2QQZ7pe7bzkBBuQgi6W3mjgobH3LcvhfjFBzoQN+3LgoXzCScb1WNAQktJJYZGHU4UvVuyV8FwRfj7CYz/lv6QQKwfgl5qau4mtblZ8tfXu+tlGAGAbEg5fIwjlvm+QyygqqNBYlFGoHD4Dtdgyw7mdvdFJ8+RInrsae8qHeOdLzMsAF2byutHju+Wy1hhctZAY3UgKSR8BQr3fdqv0vH+b0mq7AtzDOjH+P0JXgxKjEOPcF/JwsT5HvwFGo2ZdgLgDHsfcf+qvAw5D0+eDfqPN6yvAnnC7HqH8Zh4x4KKfe/NkVzOcwVpD5HZeImMNeXWsC4KcCbv9wo2049sBOGTeGIPoEOB5RhcoJHQc1VpnKFluaKDz98Ky0aY83+P7dqjXVQdNXnTcD09wIAA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(7416002)(54906003)(76116006)(508600001)(5660300002)(82960400001)(38100700002)(55016002)(66946007)(6916009)(64756008)(38070700005)(66556008)(2906002)(66476007)(122000001)(9686003)(52536014)(7696005)(6506007)(4326008)(4744005)(86362001)(83380400001)(186003)(8936002)(8676002)(66446008)(26005)(33656002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Q18vn73Dv28pkkbFpe/32kvuN/qQYCTpoJPcH+Z1ErsC8RebVY1dR3jkJ4Aa?=
 =?us-ascii?Q?lTxPRfHzvyuNA2hstKAm85NigS5eGERRFwXA+4uk268hZGPcSHmO2m60M+/E?=
 =?us-ascii?Q?KNXhQgVstS1122YXPukRE+grfPPJcgz63SeEbKbhQsbrGoT/i1u1/ZDAP9av?=
 =?us-ascii?Q?MZ5HWaHHfLY9+cg6/fvVhc43kqwmty++vWUbCrbilS2arRNcGCoVWeLk22Az?=
 =?us-ascii?Q?o75mEPIS9/hFSWbRmj0ArcZ7N2Xc68zr7CNEDSH/AHi8ADyBmd+qtB2PX+6o?=
 =?us-ascii?Q?wjGXkQ7/H3EBi5pl2/U2AnE8HdTtDKku5IvEqvsAa8oXmUgFREyxle9BL3NK?=
 =?us-ascii?Q?JR7BxbGc5O4Z9zgQm+i1Jo30+N3+s235eIaMNVGs9GnNMRxCyW4Mn5VsbFw8?=
 =?us-ascii?Q?usn0A2B/ti/skwqY2EGQbUNavIXCePU13i8dwix/c46jNNJJW+/qgNemx+++?=
 =?us-ascii?Q?1zl7YSf7gAmemPgK2MNmHPvq9KytsSUNa4vu4tCC3Xt4ApLsk2LgNCvqdDY2?=
 =?us-ascii?Q?i+eMLBFFgbXK+Ldttm5iF50WgEL+9hvU370lSwaLw1fbD3FjGPqtczoKKYCz?=
 =?us-ascii?Q?oreJhOsV5rmNeGMhYACqwYcE4qNT1Dtic3+tPBrD6A90hf+jmfzYH7VgIzHg?=
 =?us-ascii?Q?s/SoA96aTZQxB1dQr6jQgUZSv4DNd/OLZR3bprPTjFWmIUahNeNxB3kTX6TR?=
 =?us-ascii?Q?fI5iqxNGp6240tA+1WT7A/gEwvFV6U/Ngg+muYqVCmBnAAOpx/19H+tM04ux?=
 =?us-ascii?Q?8/44qe8vd6EyXEqM8p5DNMvM+V36K0miP/dWTkCfBsxfS1CBJuQIUV+1593S?=
 =?us-ascii?Q?EsVXfdMseiyxq66Kx/2Tze0GlKGeYI1n0omSVwNAjgLAvOhFXsvaeq6XL9Ig?=
 =?us-ascii?Q?ETlhQemSAiMufFYaEQf0PnpSOROE+W7znCDI+gFHGIRzUkw9003Qp8rGNgmi?=
 =?us-ascii?Q?iF5XBH9eukL9LJdsPrdQtHg2z2eujDCSOxHABhJLEni7ZL0lI0e9kWiq7UP/?=
 =?us-ascii?Q?bqan0iipCkXt+YCXS0kx5xO/s+k0Py8reh4YUozPs8XA/EBxinIBaEN0m2fd?=
 =?us-ascii?Q?ucv7SY6OOzVFBcAlfwUCtGcGIlNRWQl/BAb/txJfk630cAN3PK0x7MH4dPOE?=
 =?us-ascii?Q?pia3D5kn4YnXE4vUNzFJbkc8NotLjNFDkvdXFK198TYJSUkDTCtqtyPmdIa/?=
 =?us-ascii?Q?SGVWxfJmv9jEJxsdyv1Me720Jm14pdYYvcgIE+COzMESFveeZ9OlK63C6yu6?=
 =?us-ascii?Q?rVKUTkjxhd0hjAiUVme3QsQXqE9G38ihXmKD/bukAH9GOGN2FVogyCDDvb56?=
 =?us-ascii?Q?mapjTuWAzdxTHDo0tFJEFh/M?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72c25e27-aa90-44f9-9ab1-08d98ee8e071
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 08:01:49.7639
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: orqs/S7eGxLFx0gNtzI9uymlLUVFOLY7iDJnr7xij0OGUxqqYttqgkHxEFcD+QQQOtE0cNstLSmHJNPtGH4qyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5531
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Sent: Thursday, September 30, 2021 6:33 PM
>=20
> The PTE flags define whether the memory access is cache-coherent or not.
> * WB is cacheable (short for write-back cacheable. Doesn't matter here
>   what OI or RWA mean.)
> * NC is non-cacheable.
>=20
>          | Normal PCI access | No_snoop PCI access
>   -------+-------------------+-------------------
>   PTE WB | Cacheable         | Non-cacheable
>   PTE NC | Non-cacheable     | Non-cacheable

This implies that PCI no-snoop supersedes PTE flags when it's supported
by the system?

