Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC657079E7
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 07:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjERFwQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 01:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjERFwO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 01:52:14 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5D9E49;
        Wed, 17 May 2023 22:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684389132; x=1715925132;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bXOEPXR1ECEtYzeDAOL/6tbVF2QjgW9PpiKJTsoeKks=;
  b=VGHWxX645nb3sE2U8REuvjuBpMXlbbbsFjC0MJyVYkgZ+1O4X4SeqNYT
   y8PaqsiZAjSJ9mVWcaEFZVEuaeUwlku/vR2APiUaJdeRtnHusvl/umfqg
   zBNd1kaU3E9diOH0yRrhgS/loEXmPc+txvpAfZo+17E/Ql812L7j+iOBV
   K3FwJQinBmGQvq7wjuce7QI9m+vNBCsP+K6I6ojEB877aP0MGWQggsWGs
   xYz1byLGmvpO8Zd45IS4e3+TZYlSEOXlGe2mdVopfvotDCX3KGsVLs+Ub
   Zkk7VWgHYZWad+eXUI0KLMH+qRtQrRK6vVgrrNhu+VI1vlvxM4pV4PTaE
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="415393966"
X-IronPort-AV: E=Sophos;i="5.99,284,1677571200"; 
   d="scan'208";a="415393966"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2023 22:52:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="705082391"
X-IronPort-AV: E=Sophos;i="5.99,284,1677571200"; 
   d="scan'208";a="705082391"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 17 May 2023 22:52:11 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 17 May 2023 22:52:11 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 17 May 2023 22:52:11 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 17 May 2023 22:51:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R9E50VD6CB7sDZXsnhdm+3y9DOOpEH7ogi+HmXe95YRw9ikEtfkrZCoRmKc3TIzH0pVlchA6qldfEOksR4DLJn6wb3G8bwQMV/QUXdO5ZkOBI2H2UmFtqU73smhAlX283DKMJ3p92EEhcm7dZzgVI+f0DKxpruVXOl5dPxhnOYB+V93NuDPvjgkb/JggfVCvXd2DCvK7FrsicLe4B65WhLZ3SdTSXYhu1JZSnMWZuf7crHs2a3GBrBmhBlt8JiTOJGI4iLf3cBwzIab7YUkxyOhjD0Ac4SsPGTN/NL8Xk2Mphzj5Q6Yr2PlWfWXChyPnO37nwnrNLX8oWwgkG/Y2DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xN+q9W6XoxnSSN0yb328IfwG6vJ0eaqAd7CYMelpgDI=;
 b=eUqe0cM52pogVmEIybstMoKwvq3i91mHTrAI4AWAMgifz/C706/AKDQMEjHdeH9pWn3UqCOpDBL+chHr6rn+RphjoXl07I0eCNeOFjP0flaMc6yGz/5u5kPgogDQbraZt7oE2vUFQWlGXOes1oIe6uDGInZmPyvFF/v6ZDJE8QMmeboXePm/2qzaaw/1Ur17AlzYE4LhFsqWBesn8jRK/3HDWqIckttQO99Ky3sRLt/vzNktXEfQR+RG1wVrFZxdoY19XysDdwvZJANqszCRueO/R7WQj7GGlEJgOvftK8LVeOAx2WBs+cN6FrdxaX8RXl5bGTU15ihrC9hfBpMRrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL3PR11MB6483.namprd11.prod.outlook.com (2603:10b6:208:3be::13)
 by BN9PR11MB5260.namprd11.prod.outlook.com (2603:10b6:408:135::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Thu, 18 May
 2023 05:51:32 +0000
Received: from BL3PR11MB6483.namprd11.prod.outlook.com
 ([fe80::f386:4283:71d7:c99e]) by BL3PR11MB6483.namprd11.prod.outlook.com
 ([fe80::f386:4283:71d7:c99e%3]) with mapi id 15.20.6411.019; Thu, 18 May 2023
 05:51:32 +0000
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
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v5 00/10] Enhance vfio PCI hot reset for vfio cdev device
Thread-Topic: [PATCH v5 00/10] Enhance vfio PCI hot reset for vfio cdev device
Thread-Index: AQHZhZ3encFKvHyoNEuPo1lAsmusgK9fi9Tw
Date:   Thu, 18 May 2023 05:51:32 +0000
Message-ID: <BL3PR11MB64837CF31D43B772CD548277F07F9@BL3PR11MB6483.namprd11.prod.outlook.com>
References: <20230513132136.15021-1-yi.l.liu@intel.com>
In-Reply-To: <20230513132136.15021-1-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL3PR11MB6483:EE_|BN9PR11MB5260:EE_
x-ms-office365-filtering-correlation-id: 0e70b79d-1106-40af-fc7d-08db5763eecd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fhx0ShvmZ40vaH/u7Lx1OLRRRZjLEBlf1YlmPzu0lZEK66Up3ioslwG7iv58MPsnd/6d2GMvcpynPnImXlH+n+8L9FtMecXVYFDTic+ByOyGHNO1aSf4Aua9SADVFgjfSU8gk9bqvGzBLYvzOqQlyicYGPfoMNagSSp4iJQw+roUip+ZJIN4dE9NaIV9GAJwKwgJgcHbMbIt8kYIBQrr8jBUKw9qBVkq7Vd6HAe3DiGrBYOEIaD8Y5B0NtbT4IrGrAv5xM3juvlTrvKZ3xDX+ZTP6aziIZacYZ8IPXJFoHyp5UkuktzGiPHdfZQ7XfceltANREfQO8+t8gXUE+VnbfWepe9tlAgTomklGIrv5soZPKgbikpCWJRkx7r87uCD/Yxw8XW9NIKMxlpIAzd4DbOg4uktbu9mWpZyHr71YVhsiL9cHhTesmfWMNZLkGKkuNwDgLLs5qaQkq4eC5Hd5ckqzGdV1rZRfcZuuORjawd5TIQpd1foeMexOODpqgO21+7w5lF1qXH1IZCChzHJyR6UkSYHpCQzXIgh07oMOnAf1mI2DF8o5xdZza9HVgTAFu5LpUVSHHeDkDZwrdGN41E/8bJF6QUYY9mVlMNlIp1z1sm5wBydpYdSbZsOaS+hSJCnycskoyMc4QVvi2AlqQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR11MB6483.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(346002)(39860400002)(366004)(376002)(451199021)(2906002)(316002)(478600001)(52536014)(41300700001)(4326008)(8936002)(8676002)(6636002)(54906003)(110136005)(7416002)(71200400001)(64756008)(66476007)(66446008)(76116006)(66946007)(66556008)(5660300002)(7696005)(966005)(9686003)(6506007)(26005)(82960400001)(122000001)(38100700002)(186003)(55016003)(83380400001)(38070700005)(86362001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yJAmcY2/z3n6zUpRxuO5xBM386WH0n1UUt1cQUdsFeaOZaj8/LgZSESiqulZ?=
 =?us-ascii?Q?I5HGNCBYloq++y/mngUTMs9b4Rs7xlBRcZBzbjUXnXsNAQ3EboJuqJQjwUHi?=
 =?us-ascii?Q?1RcbJbD5jabuf/zrBBHgXAD2V3Q26VGa9b30qmlYxth9Q3r5+ZN16nLdfFNX?=
 =?us-ascii?Q?pYh0/7PC45tDdqAlRzOUBX6wWsU2+CXVHqiaV4JgCL178wLBEnZoEsA+BGw7?=
 =?us-ascii?Q?sXz1RFhr6okcIgCvIsSMo3HQO1mEaID3tmXO285nM8PEtDtUFGYZXpuL+lSC?=
 =?us-ascii?Q?0IWqr856z7LBuuzaxvYbzkbmSuISBp12dWddNJGcGL4qcdo3Qerb2tBN+HrE?=
 =?us-ascii?Q?vsLb0Z+jBjDVtQFeyXb7k8815BTKceNjtXf3MR+PjqlZDBZUZZdVUfF5SjdB?=
 =?us-ascii?Q?bv+OxGw9B9NFdiulU7WDZfhv+MkDSc/PIfz2ShiDDE3NkXZy18DsY6eGITKj?=
 =?us-ascii?Q?WEY71Gcgpp9tcynrw3BoBdkgT/9AkSfGQVYzcVFCTSAzJTzJyTtZEH0xdmSe?=
 =?us-ascii?Q?yc0BXciep/6cLIsNKLDwbLSw1MWn3ZNFCir3wbGLO2/yvHFBCTn8lElgS6Ff?=
 =?us-ascii?Q?yVrcNiIERGAhftHqm1Km17kPqcSI6Kn5MmVyy0lU+vN1wnot1b4cQJhshCSb?=
 =?us-ascii?Q?xrF2wwqCZj8+XZhrdJNaZnv2gNSxlnHx73XhtQXOtCdOP5M4rVWUxzmfKnJu?=
 =?us-ascii?Q?QgrZ8cIM3y2CUveQ+Xw+4Dv7UmnQ394tQ1ZFC0NAsbRJuE/hj0nbHGiWQuEm?=
 =?us-ascii?Q?lo/8TSUnM7TGIqbQTCSB/oT1Z2r3bHN4qDQcY6KV3dzPxgYPboQHDeKpJTg3?=
 =?us-ascii?Q?pU9NCFgJgW/8ThDlWbwfFFnyAL2gjSWeStc6VFL3O/RZyBH0QSVgpWknO58Y?=
 =?us-ascii?Q?eSd/tORb7UVXLC8WKxW4ZvNvLSVQJ3r2n6EdXMqYZxyyHlknond1DEKieNQI?=
 =?us-ascii?Q?whlP1OQ7vRsbl+ir11EBgAIJisUbUoUudWzyam1E/ZauU9KQYav4GNqEb7ZO?=
 =?us-ascii?Q?sa3MdXKMFWKCkWPkfuVA98OMKdT+J47YNF5DB5kgNlUY9eygf1/EqztMywYs?=
 =?us-ascii?Q?aAIrEqc9HSLR5poIIfCOhjq7GY4BkH2JJnRnsEHpowbMqEEWnLmEANc1ch0R?=
 =?us-ascii?Q?qTMOrdK7f/HvtCKe/pbthf8wYtXVe73Ddf3Iuibtt6Z8X6XKjkyB4q2VJP6z?=
 =?us-ascii?Q?OnHXrfHT063db74qbo9msoM3r77Btx7zLTGABlYAalvlxbtrdqsGJdNxPGJl?=
 =?us-ascii?Q?SvGRWwUMyvb3Wumefd50wxUvqDJ+iL9B0sbNJAHXuyPPjnC+O9E9lbO5poUt?=
 =?us-ascii?Q?Ks+39QQAuk2M5/rM8GMY1loiU8gqrvI5wkcrzrR1hQJONuGEpP6r6lfuuVe4?=
 =?us-ascii?Q?Knpo5goRmPootY8YFVN1qryDDXFz47vL5P4DMTDK4IXGn7Ut0bCBxfrp6aLX?=
 =?us-ascii?Q?qusNDhas2TmltzTGjsFFMVDJC9F5drZRpUH/3doOKqrl031+CB3Ssf8urpOR?=
 =?us-ascii?Q?uiuMpRK4FJCIPdl59GloPx72Prp//0Ouk/368lJUWz9Q/DsRHiEketrb0XVW?=
 =?us-ascii?Q?NFE2cKCpjbmmfgu7PlzQXlRr0PSmBDl4FQYvKqA6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL3PR11MB6483.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e70b79d-1106-40af-fc7d-08db5763eecd
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2023 05:51:32.2744
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D2g2vKoLhOCWZ1PXonQen9tVRKVfpYSkTB402fjZUKeZRFOZkRw9MSLB5iQ7iho4JdxPzdo8ALbEiptq4xNUkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5260
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> -----Original Message-----
> From: Liu, Yi L <yi.l.liu@intel.com>
> Subject: [PATCH v5 00/10] Enhance vfio PCI hot reset for vfio cdev device
>=20
> VFIO_DEVICE_PCI_HOT_RESET requires user to pass an array of group fds to
> prove that it owns all devices affected by resetting the calling device. =
While
> for cdev devices, user can use an iommufd-based ownership checking model
> and invoke VFIO_DEVICE_PCI_HOT_RESET with a zero-length fd array.
>=20
> This series first creates iommufd_access for noiommu devices to fill the =
gap
> for adding iommufd-based ownership checking model, then extends
> VFIO_DEVICE_GET_PCI_HOT_RESET_INFO to check ownership and return
> the check result and the devid of affected devices to user. In the end,
> extends the VFIO_DEVICE_PCI_HOT_RESET to accept zero-length fd array for
> hot-reset with cdev devices.
>=20
> The new hot reset method and updated _INFO ioctl are tested with the
> below qemu:
>=20
> https://github.com/yiliu1765/qemu/tree/iommufd_rfcv4.mig.reset.v4_var3
> (requires to test with the cdev kernel)
>=20
> Change log:
>=20
> v5:
>  - Drop patch 01 of v4 (Alex)
>  - Create noiommu_access for noiommu devices (Jason)
>  - Reserve all negative iommufd IDs, hence VFIO can encode negative
>    values (Jason)
>  - Make vfio_iommufd_physical_devid() return -EINVAL if it's not called
>    with a physical device or a noiommu device.
>  - Add vfio_find_device_in_devset() in vfio_main.c (Alex)
>  - Add iommufd_ctx_has_group() to replace
> vfio_devset_iommufd_has_group().
>    Reason: vfio_devset_iommufd_has_group() only loops the devices within
>    the given devset to check the iommufd an iommu_group, but an
> iommu_group
>    can span into multiple devsets. So if failed to find the group in a
>    devset doesn't mean the group is not owned by the iommufd. So here
> either
>    needs to search all the devsets or add an iommufd API to check it. It
>    appears an iommufd API makes more sense.
>  - Adopt suggestions from Alex on patch 08 and 09 of v4, refine the hot-r=
eset
>    uapi description and minor tweaks
>  - Use bitfields for bool members (Alex)
>=20
> v4: https://lore.kernel.org/kvm/20230426145419.450922-1-yi.l.liu@intel.co=
m/
>  - Rename the patch series subject
>  - Patch 01 is moved from the cdev series
>  - Patch 02, 06 are new per review comments in v3
>  - Patch 03/04/05/07/08/09 are from v3 with updates
>=20
> v3: https://lore.kernel.org/kvm/20230401144429.88673-1-yi.l.liu@intel.com=
/
>  - Remove the new _INFO ioctl of v2, extend the existing _INFO ioctl to
>    report devid (Alex)
>  - Add r-b from Jason
>  - Add t-b from Terrence Xu and Yanting Jiang (mainly regression test)
>=20
> v2: https://lore.kernel.org/kvm/20230327093458.44939-1-yi.l.liu@intel.com=
/
>  - Split the patch 03 of v1 to be 03, 04 and 05 of v2 (Jaon)
>  - Add r-b from Kevin and Jason
>  - Add patch 10 to introduce a new _INFO ioctl for the usage of device
>    fd passing usage in cdev path (Jason, Alex)
>=20
> v1: https://lore.kernel.org/kvm/20230316124156.12064-1-yi.l.liu@intel.com=
/
>=20
> Regards,
> 	Yi Liu
>=20
> Yi Liu (10):
>   vfio-iommufd: Create iommufd_access for noiommu devices
>   vfio/pci: Update comment around group_fd get in
>     vfio_pci_ioctl_pci_hot_reset()
>   vfio/pci: Move the existing hot reset logic to be a helper
>   vfio: Mark cdev usage in vfio_device
>   iommufd: Reserve all negative IDs in the iommufd xarray
>   vfio-iommufd: Add helper to retrieve iommufd_ctx and devid for
>     vfio_device
>   vfio: Add helper to search vfio_device in a dev_set
>   iommufd: Add iommufd_ctx_has_group()
>   vfio/pci: Extend VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device
>     cdev
>   vfio/pci: Allow passing zero-length fd array in
>     VFIO_DEVICE_PCI_HOT_RESET
>=20
>  drivers/iommu/iommufd/device.c   |  53 +++++++++
>  drivers/iommu/iommufd/main.c     |   2 +-
>  drivers/vfio/iommufd.c           |  63 ++++++++++-
>  drivers/vfio/pci/vfio_pci_core.c | 184 ++++++++++++++++++++++++-------
>  drivers/vfio/vfio_main.c         |  15 +++
>  include/linux/iommufd.h          |  14 +++
>  include/linux/vfio.h             |  23 ++++
>  include/uapi/linux/vfio.h        |  60 +++++++++-
>  8 files changed, 368 insertions(+), 46 deletions(-)
>=20
> --
> 2.34.1

The new uapi works fine.
Tested GVT-g / GVT-d VFIO legacy mode / compat mode / cdev mode, including =
negative tests. No regression be introduced. =20

Tested-by: Terrence Xu <terrence.xu@intel.com>
