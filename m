Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F43542D33A
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 09:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhJNHIY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 03:08:24 -0400
Received: from mga17.intel.com ([192.55.52.151]:13884 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229551AbhJNHIV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 03:08:21 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10136"; a="208414083"
X-IronPort-AV: E=Sophos;i="5.85,371,1624345200"; 
   d="scan'208";a="208414083"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2021 00:06:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,371,1624345200"; 
   d="scan'208";a="548411367"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga004.fm.intel.com with ESMTP; 14 Oct 2021 00:06:15 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 14 Oct 2021 00:06:14 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 14 Oct 2021 00:06:14 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 14 Oct 2021 00:06:14 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 14 Oct 2021 00:06:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z3Q6+zTuwfKskAht/sWP2qjP/H4avMASQZiUHfYxcKNXIF8tcIU+jj6lOjl92ts/ZzKNdHgdX2wJ4mr7oymudp5hmVFMQEqwEXRRR2VajHQHcRbZ+jn3+902WG++tnbQ6va33FZ1rt1hBmvHW0Gx3pPB+3igPWBBQ2No5PhSvpO2lBVa2ud+f27nJvRZ+jcSrU+RfKxM5n208FvoUn5JdrPUU/43TUJ+kEn3jsLk1to1zNpOSzwXGvSce65WR9tYBEogcFrwQ2bigjGNxgp+i3+UiL8i+zUvhdZW56VZrjw6qMwMSmoK4j+DWNk9C4Wd0MRMaGNgVcq7FcAk77rFJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ijY1pY4YbxmOLx3jZrC66yl45Mvd+5NDDbfZdWCsAU=;
 b=C9R/Tp/KBc5iFiuoaa+j7/4sxw0Dftu3Z0QqBQ1kHxG0Jks36uPXxOAdsAFsjbzxyleie0/zx0P1iXHNAgpct3hOV1QUysgf9AP6hnbgWzXBrGzmVxhA8G+gEEu9NUqm31k1z2MdumS47bt177yGajTnaMd0eOkxyHxQBTTNrtGoAv5bTUfY+fLu3d4CgVOBP1wuKtXiGH14uF3RTysMkQCbKcseggreQW3Q/BEbuwd/BJSfLBmC7otk08WaFHSuP0aFME7WjZKTlwzmlk2N7DnVRw1ZrCpYAhTBnruF/OkojUqBXKcFsdkZ/zFo4Xn029Z4PxV5JtXw0mtSjeHltg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ijY1pY4YbxmOLx3jZrC66yl45Mvd+5NDDbfZdWCsAU=;
 b=R9TVK7otwJdJ8pYvmC7jH0p4G51KuZcTicaUwFDGpFMXgGJGsly3LdGMu/vvMyOe2R4uza/wzsScXBQsis9gK8WMuVpEQHYLAo7QpYGphtSOOsGrc97RNhGP10iXelGCOyMJYMuz7MWqwBFrvu98VPMTXkWt3JuCGkH1EFYjPIw=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB2020.namprd11.prod.outlook.com (2603:10b6:404:3c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Thu, 14 Oct
 2021 07:06:07 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4608.016; Thu, 14 Oct 2021
 07:06:07 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     David Gibson <david@gibson.dropbear.id.au>,
        "Liu, Yi L" <yi.l.liu@intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>, "hch@lst.de" <hch@lst.de>,
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
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: RE: [RFC 13/20] iommu: Extend iommu_at[de]tach_device() for multiple
 devices group
Thread-Topic: [RFC 13/20] iommu: Extend iommu_at[de]tach_device() for multiple
 devices group
Thread-Index: AQHXrSGaa5Rm1P0kqEyK39kAddiKjavSHSOAgAAai+A=
Date:   Thu, 14 Oct 2021 07:06:07 +0000
Message-ID: <BN9PR11MB54337A8E65C789D038D875C68CB89@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-14-yi.l.liu@intel.com> <YWe+88sfCbxgMYPN@yekko>
In-Reply-To: <YWe+88sfCbxgMYPN@yekko>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ec1adbf5-0ad1-47a8-5d12-08d98ee1183b
x-ms-traffictypediagnostic: BN6PR11MB2020:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB202042C3BB3141F78C62ADCB8CB89@BN6PR11MB2020.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NKDYkpsUzhy5giVsqjApO8g+R8hUVCmVvDLuin/tDFHNNGxtRg/bxYqZsyPGUJlkQOnWvfR52AUG9eZhIv5AhXFIGzdIcCjme2cESNZN4oRxuI7PfHmPxEVdDWrxCGL67XS7Ai9bkQj6iKNUD1UFFT3FXGuTxPEI2YvVXY5ViNsmTpWDRylSlzgELJmaGVb1hcZGaRAV1aI9VAK5udzrN5Xkswed5cTfS1D3g+eLwrSqbzm8zY5BeDtNvXpz32X/U+LuzFDLV8Y+L4v1R35Qbb88rMEi3kjBj9W0PyZQA7xcsLId296t3h2ifhROpqDPrZq2/v7qMvnDnEi2hXTuZP2UmLraP85fH6WsG/ixCwqpSU2S/NtzsDWCz7Ixk/+kkVnh2Ns6+EFbb9Fyh7uD6wz7r3WwaW44vF/442r49j8p7v4mF6imu9hxyZpRUn/rXzm/Ye1u4l+fvzPDf9SXhYBrFtO0H6Jt0Q01YvPaqvWl5dG3q90GXfppw1sERYzc3obrdez1hOhTSh5j5UzZSGuOC6drGhKSVxHzq3ru286E1SyMcaw8JPROPtCmdqL8CimzWqDR5gn3epZ3y4xFw8a373LCilt2ZgOBaHA3VfdiQMeNqhtmyXex89z1nvh/1yR/9I8+sOjMPyL4nFbTgsYqM17CNxeJ1GCCnrt3fa2P9N0ibD9QUQlNONVpJtp2+6/vhhBFiURUgb2nDx4fHw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(71200400001)(122000001)(55016002)(7416002)(6636002)(83380400001)(33656002)(2906002)(38070700005)(86362001)(26005)(186003)(76116006)(5660300002)(66946007)(82960400001)(8936002)(52536014)(64756008)(110136005)(54906003)(66446008)(9686003)(4326008)(508600001)(6506007)(66476007)(66556008)(316002)(8676002)(7696005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zSzrR2UJ8li2dtWfW+RYnpHwyUnKtxci7FSh5noXWlxdGi4eCK0eOxULicmg?=
 =?us-ascii?Q?P5gjSc9diuWAYUZ5whCdGzerZS1+6Y8D7jI+C1nqI/jXsKCgkJGaZz7YfE4X?=
 =?us-ascii?Q?TCyzcn4Afxm64iCzUn1LBoZa69kQZznkaFxO2Nis5PqX+vzIyKtBszrh5jjG?=
 =?us-ascii?Q?SNhRZhh8fRvpOU6FJDv8eBlzd6o/6hOfsNhxs1ue2MJ20r2BKTiNM1g9B+Jv?=
 =?us-ascii?Q?u7u2FE1+eP+Nh/ovzXiIS0CnyHXPjCPJbaWr/CLu44VbGb99p7qBs+U53yZu?=
 =?us-ascii?Q?peFtOZbJF8qXIYeE+watFfPNOYEWxymWPFpV9Za2iu56oZioSPQ4mRHNfTQ0?=
 =?us-ascii?Q?LwvWQyJQWE5+NzQxi/m7llrkFybFcaohBw9ofXS4rArpy+HSfz/pxNoCcg9h?=
 =?us-ascii?Q?wxUZ003FGdzS90CgmaAd6zo4CTe9WAJwmiQXMy0HUKw1TA9U1GyUMfdb8Fyy?=
 =?us-ascii?Q?i0+OWwq+5/QlcnLgfFoRkf4w+OkA2d+sgyH8Mw0NE5Zoqcd8gUD+68pMjYDn?=
 =?us-ascii?Q?1WIcKiy65145vk53H6NMiF0rRrZKIpg791LrYaR1XExJFC88fZ1WbIokXrpN?=
 =?us-ascii?Q?JQxWoQr7IwO7/8F0/NlfRiM5o/Tuh6NrS8LZtSDF4lrX205w9D/k8kZX1DaO?=
 =?us-ascii?Q?SnLlhby0afoJWFe2FMI2yumfmHpske912NByUYJUUb492TH+qbLjC9XcVovH?=
 =?us-ascii?Q?oh2/lsfOS606QV6WoJ+16gxV/87vy2z/lOtRb2b3S+9veEYPg/g8P7lZ/7Tf?=
 =?us-ascii?Q?ZG40Xm17pYzE21QEYqEhidxZkibPM5ngs8yrNPIAuTR0kMbvHGXMdJtXOkcU?=
 =?us-ascii?Q?AT43uqmY7fcKAZDBzXXo4/RwW7zXYtaMdMqDj9ojk0TB/Sk3xuf5brd01ODG?=
 =?us-ascii?Q?UPI0Fr23k/ul/Kgr5LB7LNpbeseBaDE7GPQqM+QaOXxwwJucRJjD96tzMNrz?=
 =?us-ascii?Q?enj5vulAJEWzLPOysSXyR5sG1NOIxm2dTyezON8PuHsV2w6dpTRU6L9Slrcn?=
 =?us-ascii?Q?YBlU8eRk7+xRadArQ/BG2f+4g32upnUc2uTozP9CeBlqjsvDGCkbeSg1FuqT?=
 =?us-ascii?Q?THKXMTCepgx6kydMbRY5/btpJO29Fln8kciB/en+0DDq/EN6SXS2mXS/GVbr?=
 =?us-ascii?Q?U6XvF8uIMy0brVnXEOqprUWisR2OL+UvVnzi2QlSbKHMuLDKYziI8h15mvg5?=
 =?us-ascii?Q?YjoBsHBtax6LK4Vd3JlM5j1PO2maBveF9gZj8vp06Sz48Ly8QpcacrV5sBRC?=
 =?us-ascii?Q?0Y2A+H2hVmh1zEwzepSo3V9krXJaIIt+JIrgtxaxqW2koFzpyDnMYSfVjd0D?=
 =?us-ascii?Q?d64BzPTDFAZ7A/ppt4rj3Ayq?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec1adbf5-0ad1-47a8-5d12-08d98ee1183b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 07:06:07.3113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PFyBb1Xp9jxJmPuDWY28xxAIsOj9dWDP8D1pZ4urgdr8Rb0Y/FBAASwMFq8sj4lsgSMnTvjKlM2AhlMQO5yexg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB2020
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: David Gibson <david@gibson.dropbear.id.au>
> Sent: Thursday, October 14, 2021 1:24 PM
>=20
> On Sun, Sep 19, 2021 at 02:38:41PM +0800, Liu Yi L wrote:
> > From: Lu Baolu <baolu.lu@linux.intel.com>
> >
> > These two helpers could be used when 1) the iommu group is singleton,
> > or 2) the upper layer has put the iommu group into the secure state by
> > calling iommu_device_init_user_dma().
> >
> > As we want the iommufd design to be a device-centric model, we want to
> > remove any group knowledge in iommufd. Given that we already have
> > iommu_at[de]tach_device() interface, we could extend it for iommufd
> > simply by doing below:
> >
> >  - first device in a group does group attach;
> >  - last device in a group does group detach.
> >
> > as long as the group has been put into the secure context.
> >
> > The commit <426a273834eae> ("iommu: Limit
> iommu_attach/detach_device to
> > device with their own group") deliberately restricts the two interfaces
> > to single-device group. To avoid the conflict with existing usages, we
> > keep this policy and put the new extension only when the group has been
> > marked for user_dma.
>=20
> I still kind of hate this interface because it means an operation that
> appears to be explicitly on a single device has an implicit effect on
> other devices.
>=20

I still didn't get your concern why it's such a big deal. With this proposa=
l
the group restriction will be 'explicitly' documented in the attach uAPI
comment and sample flow in iommufd.rst. A sane user should read all
those information to understand how this new sub-system works and
follow whatever constraints claimed there. In the end the user should
maintain the same group knowledge regardless of whether to use an
explicit group uAPI or a device uAPI which has group constraint...

Thanks,
Kevin
