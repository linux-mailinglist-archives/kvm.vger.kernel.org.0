Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 501C26BE430
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 09:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbjCQIqL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 04:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231958AbjCQIpR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 04:45:17 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F1730298;
        Fri, 17 Mar 2023 01:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679042680; x=1710578680;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KzoeV5aM5Jbn6LeuC1NwmlgWrElPpz2dNz+pSpmE/AA=;
  b=T2Ix+0T0HhTB5RwkJzqJgX7YLEemjQ1W2M1HRUbtqh89tkENJwUT0RAa
   mJRKVNUEhrJ+gU4jCNOiwOr01sI3UPb/ECQk9/ct2c/cozV9WWW6DzOVH
   k7pnAbW9opkJBlw+yn7tt7RWcWJQq7V1V2jZ3CULaO2NFj2yTU6GTnoTK
   VIwiz89A0keyp3lHkms2KZSaRjxREvJkveojqNbeVrtT+MwLsFw3/VnO7
   56I9V4VGLrU9FWJVEsb5jcm0q7LL5yPECWv1Ko2dz4boqCUrlK/D46JXR
   DzcR/APXxftLiCFWyHwQDYhZ7x3mcdua/rDJQ3gZJx0tYKjmpdzXWUt/p
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="339752796"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="339752796"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 01:44:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="1009552821"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="1009552821"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 17 Mar 2023 01:44:02 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 01:44:02 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 01:44:02 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 01:43:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Os8RFQtif6rYOz880SEp8sOok1R+iwzrX85tiHtCf3d4fNq94lSyco28HYmi3ifTK9XkINevWfp6o3Ldekz3SwlNYY7CpGSgECh3xCjkpkAAdj+meNTx2V/da9BlM7f2fsZWx7aOELzNGjjeO6Ivh0vUYLTf7R7MLStzZnA/l7vBQ9tJcbiALtWUWFue4UEdesAxpo0tsYDnjoyBjnvpiMVUhBtRK3t/03ibbbC8V43Sz2WvJ+7f/5J1Ur2gMIRaQKV3oy6Mc4Kvq4kwfSYxNelpSI5NbqGpz8gN/xRDTZjQvXM2tACfU8ItzO6dpaFDWPwxWuptfYWZL/f3ikgF7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RogOGKBjWHTN6vb+cuCqK+95B6WsqMMophYRoSoS87Y=;
 b=HjaQCPpZEuKJCMKvDrqJaKKKU0NcTW2CUN35izalx26ZTH0PJb+w3y0cS8cu4TCgOFRqUMpzoRt9ywXD+08XbxG3LgE4y0gUmO52BASv00jv5fmYPI2l3PSCwIbzSXg0a8Sn4TMkln+w1zrNWwUV29+t9uOArqSJAtCPzZoatDlhZxEoWloW418+tsSG7Q15GfxzGzeXF1UjlhxAa1dMLWGNvAo4PlwSlqDuAK38UZLg5PtK8VVAJOb0tn4jIbrGPvqWVaE/iaJJp+lnJy6h2uJcxZ723DkmnY2921Vurz/u8frZ57XBBi1qINbaHFBP3Q9y4q0HMORyaCm3nW4pYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB5873.namprd11.prod.outlook.com (2603:10b6:806:228::11)
 by PH0PR11MB5904.namprd11.prod.outlook.com (2603:10b6:510:14e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Fri, 17 Mar
 2023 08:43:55 +0000
Received: from SA1PR11MB5873.namprd11.prod.outlook.com
 ([fe80::8610:e88d:1718:d8fc]) by SA1PR11MB5873.namprd11.prod.outlook.com
 ([fe80::8610:e88d:1718:d8fc%8]) with mapi id 15.20.6178.031; Fri, 17 Mar 2023
 08:43:55 +0000
From:   "Xu, Terrence" <terrence.xu@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
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
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: RE: [PATCH v2 0/5] vfio: Make emulated devices prepared for vfio
 device cdev
Thread-Topic: [PATCH v2 0/5] vfio: Make emulated devices prepared for vfio
 device cdev
Thread-Index: AQHZWAEQpkuvD2Jy6EG+yXUvMowlBq7+ptDg
Date:   Fri, 17 Mar 2023 08:43:55 +0000
Message-ID: <SA1PR11MB58732DFE64A364C4F3E2C82DF0BD9@SA1PR11MB5873.namprd11.prod.outlook.com>
References: <20230316121526.5644-1-yi.l.liu@intel.com>
In-Reply-To: <20230316121526.5644-1-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB5873:EE_|PH0PR11MB5904:EE_
x-ms-office365-filtering-correlation-id: 427093c8-356b-4e6b-b29c-08db26c3be16
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1GYtz6vT6XWUkugfc+ZKBV5OEsbH0DG5CnXYfTHNnKJmx/+OCYmycJh7Xe6tIdFBN90u3+hokwLOYwY6CJQ8HUnfJBldH5eI21cmYB0qrUnC1tcLWuyDxy79vUM/gdYawybs3djiqZgfyg3eVQw6d2kWbSC5MnsR1AqosX9SmyKVGk0KnAkPDO8Vp8IUTlMZJfKPunga8397btljFtKt1pqm6DOtNfbr+367WAvxw72j6/wE+nqc1oJDtJywbxG14Qd2nuGtEG5rFc7hpsuiAVZ4MohVhruSt55jCi+xxKMWWAk0PGz9FwYdLaW0poZkWq8/VqBFO3ckNtd2B7JAN6EmWCOLjgnGAQp2PXjSPOX6sQjWAAf8MXsKouHU+9u5TpinTfYwTAVXkw7lhAhUGo0zj050Lo3uiVbXzpGC4i2LPszqrCKRIO334K+4iC5Yt7AbKi3pc0bNMI1bERiLiYFliDerIV2ANoSXbJPRjbUTWjj2tJKgMGSDY3gR0MvfyWqTWCnkUpPeiUvj86343UPsyuWVqENmjDbMiZUiecX2/Caoh8KvbGVTsu7T8ZFtJrVBvJyNEKVY3JmMSordyW66PvffJuWO+spZlmRDcEHEJemOLnYcSX/xzi+OnAS3rwtDz8g61ZWAXfvDYrRQJH9k6gwiE1KbrhnkeE8EkOrEs/3GchRCi8UHeloNLJ2S
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB5873.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(376002)(346002)(366004)(136003)(451199018)(4326008)(966005)(9686003)(66556008)(66946007)(7696005)(66476007)(64756008)(478600001)(122000001)(82960400001)(76116006)(66446008)(33656002)(71200400001)(26005)(6506007)(7416002)(83380400001)(38070700005)(41300700001)(8936002)(55016003)(38100700002)(316002)(8676002)(52536014)(110136005)(5660300002)(186003)(6636002)(54906003)(86362001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?172qg31O2dtkiMcq2vG8TUjtNFUVy/+JILre5hosG7/XH9vWpukJAK3o+tIp?=
 =?us-ascii?Q?sN476FkqaHAXqkNbgPQa/34tUOCSgIPJzVSz9g7B274IpoIdFre/8sw+x0QZ?=
 =?us-ascii?Q?4/ii6QgXXu/NhO9RJ4KXb1mKr6qmKaG+K+X7fPr9a9pUGGgbvW7ZpVYwmz+O?=
 =?us-ascii?Q?8tTEROvqgfe9n6I8OcURT1VudzPcFfBah4edWMTQ/7DWHusKaVHeJXlpMKxk?=
 =?us-ascii?Q?vi3hkNjICnoGISXytLjfGjOxaqOi9djnrgr+iMhfEnOnDPVhopt+t6iTRy8S?=
 =?us-ascii?Q?AYQ/7wm87megMR1zcS1wZ3TTFMYxgkL1yl7G09oRYk0J6pPav74FLxxyIffA?=
 =?us-ascii?Q?lA/PXE7qWyuibLih5qqkEfcFupFZquZjFT49d0XIYI7UzXa93cc8RSnqLpYt?=
 =?us-ascii?Q?/p7l8wEmGCu98Eg9oOxOjJTXXFKF19XkNqUuS7lT5pajqFYqmIlzYtl9cZgR?=
 =?us-ascii?Q?vVkTIBviVRjz0I9Gmeim82Tuiu9HRvvv1om72skhmyaKl9CAX+BbkWSfF7B+?=
 =?us-ascii?Q?KjfXBjnsEemRgbJCDxo5puH1ZXDmn+bLuhsvegDbL46fu0bweJJP4Pc/bQ5G?=
 =?us-ascii?Q?rmuCc+weR05UV088sqsZJysIXrM8AXnkHREawAgE0uEq3RjMJN3KkauyCI+Y?=
 =?us-ascii?Q?czianqs3bOLdR19iLdqOOgMDtGXFjko3Ocg7I0sO3A7Q7gtSsLkQUXvRCYwL?=
 =?us-ascii?Q?Kh7obukz3oyvJY13SB3BeL0RJLpqW/8XDhVAD3T7sbwi7gFX1NTMNcvFZFcI?=
 =?us-ascii?Q?0ZvD4LT8upeNgJJGEke5f2COY1aqLA6sppZEvQZsskz6hBWw4ardeqr4FRgG?=
 =?us-ascii?Q?M/ZzhchX51Al5+NHgrzFXRCr2c9OktQrnPlLPblqNGvtMo1kRGBiEg7xX/3f?=
 =?us-ascii?Q?FMpExxl7swY/62wgZs837gHQCqaZ4VjnbwzEcmqE1wBrwqLuOFssXInT5w+C?=
 =?us-ascii?Q?1UvoaPZ23SY9Dbr1U+xVag+FmnKG+ZbYWdqUVMyVZCo+h/hIa1PsSk8hSXi+?=
 =?us-ascii?Q?0iE33QUsNioUyy2aM7yv4bwpnrmwPdjUAtDrtAPuqXTRh104+bhru68Nge9o?=
 =?us-ascii?Q?huTBVileIXuL+TYp+gRpgYELOmzFKN4CCs+YLd99Dxylv682Tos+NHeCWLyo?=
 =?us-ascii?Q?78EOfh9FhueTPtwuUHKL8SCXESAU9x3PkTguAHAX6WC9LULa5NLoFfRh8plF?=
 =?us-ascii?Q?8n9LoUYKH4Cp+VHCzU9pX7e1kE1oO+fYyOkdWotkuALoac5UulalkGCPXg2X?=
 =?us-ascii?Q?akN5R1wRkhOhTUWF9SBJp+9dkUSZRUwFCr/qGhV987JIfQ6VHlxk9uWGirXN?=
 =?us-ascii?Q?KwK2i+6Px9mzOXE11XSXX+rfeUmtT2JTGyuXRwGMKY3W4UjZINvtYPstFuKy?=
 =?us-ascii?Q?/hKp0YOif45vloXOI/MQhuJ9rV286V3tCoM+avHwY2517zoxcLHIiImMtC8r?=
 =?us-ascii?Q?tQCO6liBb9fQk1NHFKmIUUtYcrtvtNCiMV3cWfnyt/O5+Z9qpORgJVejB0qr?=
 =?us-ascii?Q?hcglyOhuQ8D1ANu3W4M7nEwMGwsq7c7yIpBktxiy27wtMVaKvpKcC+5aeE5v?=
 =?us-ascii?Q?bJErtbHgVvh7/RB7PCh4gt0oWEnPpS0Cfezu1Rub?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB5873.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 427093c8-356b-4e6b-b29c-08db26c3be16
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 08:43:55.2225
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZjsHQpAeUiu+Bke1u26k22HeySewoqRec/8FVDH0Zq6gnJFIZoAdRV1bOBAJw/rUW8dtDCkfBdbOach+Oqi3vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5904
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> -----Original Message-----
> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, March 16, 2023 8:15 PM
>=20
> The .bind_iommufd op of vfio emulated devices are either empty or does
> nothing. This is different with the vfio physical devices, to add vfio de=
vice
> cdev, need to make them act the same.
>=20
> This series first makes the .bind_iommufd op of vfio emulated devices to
> create iommufd_access, this introduces a new iommufd API. Then let the
> driver that does not provide .bind_iommufd op to use the vfio emulated
> iommufd op set. This makes all vfio device drivers have consistent iommuf=
d
> operations, which is good for adding new device uAPIs in the device cdev
> series.
>=20
> Change log:
>=20
> v2:
>  - Add r-b from Kevin and Jason
>  - Refine patch 01 per comments from Jason and Kevin
>=20
> v1: https://lore.kernel.org/kvm/20230308131340.459224-1-yi.l.liu@intel.co=
m/
>=20
> Thanks,
> 	Yi Liu
>=20
> Nicolin Chen (1):
>   iommufd: Create access in vfio_iommufd_emulated_bind()
>=20
> Yi Liu (4):
>   vfio-iommufd: No need to record iommufd_ctx in vfio_device
>   vfio-iommufd: Make vfio_iommufd_emulated_bind() return
> iommufd_access
>     ID
>   vfio/mdev: Uses the vfio emulated iommufd ops set in the mdev sample
>     drivers
>   vfio: Check the presence for iommufd callbacks in
>     __vfio_register_dev()
>=20
>  drivers/iommu/iommufd/device.c   | 57 ++++++++++++++++++++------------
>  drivers/iommu/iommufd/selftest.c |  8 +++--
>  drivers/vfio/iommufd.c           | 39 +++++++++++-----------
>  drivers/vfio/vfio_main.c         |  5 +--
>  include/linux/iommufd.h          |  5 +--
>  include/linux/vfio.h             |  1 -
>  samples/vfio-mdev/mbochs.c       |  3 ++
>  samples/vfio-mdev/mdpy.c         |  3 ++
>  samples/vfio-mdev/mtty.c         |  3 ++
>  9 files changed, 76 insertions(+), 48 deletions(-)
>=20
> --
> 2.34.1
Verified this series by test the vfio-mdev with mtty emulated device, it pa=
ssed VFIO legacy mode / compat mode / cdev mode, including negative tests.

Tested-by: Terrence Xu <terrence.xu@intel.com>

