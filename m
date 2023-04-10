Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1943B6DC84E
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 17:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjDJPSe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 11:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjDJPSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 11:18:32 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE28726B7;
        Mon, 10 Apr 2023 08:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681139912; x=1712675912;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RCDlYGiroBUzMnav9YxMFRIl1BL4hqzrOQ3tF7FsmVM=;
  b=dZ9njwJtZyAMYBNumie3oNAtedqsTZ3yjlaxGM1u8+18J8V1qyIIcNlO
   kKnE5Hh8lXitV5j72gRi/imvIUNGxDzxjra4IwqIbi9sJxhAAAIOCbk2n
   vBV42I9vL68k4E87+F16ykV8IgcBtw90nMbHEOXV+ZWb3zMv6IuAnTmhw
   H6juIdXEpPl6DQPKtVhPC74kRYSzVcj7JF4jB9nhViViEKc3+bmAdw9qN
   ExmJyaFF0Z8yhd4xw4T22qkLzTvz6HnBy3GwkNzUZGAc0tS2Nv+IZsu17
   8kvHv8QFLLZVaZveliwTFyaUWMxSvZAY0IG2YNTxzh9/gNciimhDa4H3h
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="346037143"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="346037143"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 08:18:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="777594946"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="777594946"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Apr 2023 08:18:30 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 10 Apr 2023 08:18:29 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 10 Apr 2023 08:18:29 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 10 Apr 2023 08:18:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hDcxKCTAcWWuY02tADhW1hhqb5LGiqwILV1vwozF/VlyhzMqKVctO9I2ExBfAOuSlhaxg76zGxwsqpBS/G8I2lqmoca8SrPgxLfDya03E1Xq6q/E5fRDp0ST9/gswb5y960DjlrhcuYdHq1z8SO4JH3B+x9oIbFR6jE4WA0NJR4u4NM3KJzFya15iUjBRY0RkDhg5mIFvVO6dees2mLyajEGBOdImRmEJ34VMFYZ7vzLAgKGRLCF+vMpMcXf/RdGDrNDQNp06I78tE8hvKU2HGg2hLTd0nikOsPgsnIQXzYA4O3SWIfj7EyFCmmLRs7sFaZZOBoaTmQHY/jYuRhikQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=menLCdvEzHkE0IkGM9AuDFYzdymiOQm01PKXiCDnfCc=;
 b=Xi9bG4DJGEN1uwep+VeT42Q+RBXgVQOqtlgTT3tWn4dCjeO9VYJakAyaX9mMi0RnaOVRKuMINfXW3FAaA7Y3KD4v+6AVTyzVIWUCpy6vo4p4zM8f34738JlmcaVP1Smz2NboWDkbdQlAPW0Qt8aeTTg91UD5TB1Lbv0COUgyiwmHdHHbTwGJyj3NzJbuRwUZe3gynkRCtZANgEruqw6Ymk3vVz2ZQBaje8wddvpTQ7yvpUs201GCnymTVILzwkdgKIuAjqfzJ7xm+LDrqzZYiSf19nnHE5YA1N40rMiQ86ZEk2RHk6XuxrZ/fj3PS8Q1fEmUVr4Ua9oM+JuSOPng2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM4PR11MB6285.namprd11.prod.outlook.com (2603:10b6:8:a8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Mon, 10 Apr
 2023 15:18:28 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%5]) with mapi id 15.20.6277.036; Mon, 10 Apr 2023
 15:18:28 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Topic: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Index: AQHZZKiCMJJkpNrujkKpjX0h05Zqwa8ZTcVQgABjWoCABfZ/IIAAIQaAgAAVGHCAAAktgIAAAk+wgAAUoYCAAAeeMIAAWxqAgAB8OECAAKRjAIABasqAgAAZcoCAABTt4IABkVuAgAAAdLA=
Date:   Mon, 10 Apr 2023 15:18:27 +0000
Message-ID: <DS0PR11MB752938649DE21B96577C2B1CC3959@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
        <20230403090151.4cb2158c.alex.williamson@redhat.com>
        <DS0PR11MB75291E6ED702ADD03AAE023BC3969@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230407060335.7babfeb8.alex.williamson@redhat.com>
        <DS0PR11MB7529B0A91FF97C078BEA3783C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230407075155.3ad4c804.alex.williamson@redhat.com>
        <DS0PR11MB7529C1CA38D7D1035869F358C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230407091401.1c847419.alex.williamson@redhat.com>
        <DS0PR11MB7529A9D103F88381F84CF390C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230407150721.395eabc4.alex.williamson@redhat.com>
        <SN7PR11MB75407463181A0D7A4F21D546C3979@SN7PR11MB7540.namprd11.prod.outlook.com>
        <20230408082018.04dcd1e3.alex.williamson@redhat.com>
        <81a3e148-89de-e399-fefa-0785dac75f85@intel.com>
        <20230409072951.629af3a7.alex.williamson@redhat.com>
        <DS0PR11MB7529BE00767D7ABC1136BF7CC3959@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230410084115.3c6604f1.alex.williamson@redhat.com>
In-Reply-To: <20230410084115.3c6604f1.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DM4PR11MB6285:EE_
x-ms-office365-filtering-correlation-id: 21a5bf53-9b28-43ef-c8ad-08db39d6d5ea
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jp2QMLaQ8zIcJM6sGtxJE7NucwwrRqbRp31pcllDN/te5IuNQV0BXfcTKZdFxP+7TIbM/9mPEruwSE68UTfnQfkJ75kKYRrDWhov6d18Trzun56/MJlfV5OhnfNKlBN85PsugyvKOarJxZmsIOnwU5zfz7WyrxgdbRqq/4Xy0BD0RW6De7OOjynCJD6SjucXARu9amAJWqBttbbL6FW0UV+4lo5Aqqm5ttXwgw7vaTVz1xXgfebsLToyJinhm2lUNsactvNnOdSnD3u8B9sn5W15/4n+bkjNXupAxsIQQ4sX2OpfnFG+Caue8y4cPSKrc5tH0d6OJPDJ78/LnprpOczffER67elzGbveD0XZ8CTrTp5oSSUNhFFP5Jz9pYMmJCvK+urK/UoigukOuB34fDrRO/lQ7AZiajX4cE+hve8MgUI0pvVuh8f8pvG1PaOIW0eGiSBSvLTXR1ZAyXaZGZUc6qHK8Ia6csUmW4qljrgP1QhZo4RxT4bYafrh113E9xV4F7Jz3dZERbuI/hFSJybY7mpl8XUZEkPgZ/Z4z358dCh4a93qqqH9ZvYORgsloZmixR935r9Mb0S5PBUATogsL+Vk9fyXNRJLbPNbBHu8k1iDdXXJmHbcYn6ebE+DWkJxJQOb79+bQpyLno+whHj+6aIa97E1VthmtSr42ME=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(39860400002)(136003)(366004)(376002)(451199021)(478600001)(71200400001)(38100700002)(8676002)(8936002)(316002)(41300700001)(82960400001)(76116006)(4326008)(55016003)(66556008)(66476007)(66446008)(6916009)(66946007)(64756008)(54906003)(122000001)(186003)(2906002)(33656002)(38070700005)(9686003)(6506007)(26005)(86362001)(83380400001)(52536014)(5660300002)(7416002)(966005)(7696005)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KDTPVv6uwMGaewt1+SQ/7gBLfBKmJU3ubA6MlNe2SwM0trgmCsqiJ5P5wVdt?=
 =?us-ascii?Q?+p9vjhz5VPEun/r1fkXP2xseumdB8uLyx5myMoRExNEJd01crajbqWAk0obB?=
 =?us-ascii?Q?/WujBfVGqlo7wM2ir4Gd0VHhvw8rPoYfSj/Taj5tFin+JoNn89n3D149OBtA?=
 =?us-ascii?Q?3Iy/E4virJAjZ7bWEAB/oJlRHUKGMU2NjAAmPU2bj0tpun/r9yp8NOf6r5Uq?=
 =?us-ascii?Q?pJvadFptgiLG1vPXEU7IBQwGb5964yMJ9k18VfOMMqPBmxaYDPvlRwSfodpY?=
 =?us-ascii?Q?rdNV0UEY45hOoqRGbtaFRi8EbdfP1xqO87vVu2wxlLzpQEZXZrGX86aHGJkl?=
 =?us-ascii?Q?xdmKB7cFeqhpQ4IwvZY1M/GWVrBwc8AWV63hNP8w8hzWqSRtXh1jio8hv2O3?=
 =?us-ascii?Q?+tc/30py5wZIt9eEkTKcTbRpkopBvZejVC2sPCguUPm/ZM5tWCeeHgftztqS?=
 =?us-ascii?Q?iC+89u7IPuoWZsx7Vujm6q8/ncF78LrTWyiaKkSSoeV/cUdW8JRClPbx8VWT?=
 =?us-ascii?Q?HkvHN5hu+lCyeNj0Ruk1hquVsDI3KsUf4LMrMMbxn0bP9GdXRyxTvl/sjgfB?=
 =?us-ascii?Q?VCfDnvypgxH6mXgsEBLTEDgmh6XBMtMWVecU6XT7bbHEbgxUtcA8wKnKRAy5?=
 =?us-ascii?Q?CB8l+IAXsniL0THFUn7faeUe9x7Lx6CTuugXzmMgoXWRWfng1XgC+0gqND5T?=
 =?us-ascii?Q?QN1fptFaX3a/DvQ6S8u4XgDGO1G4me6wd3ukZ/qJpAkts0/dabzpYcGu7lbS?=
 =?us-ascii?Q?/BiWXHR8AbOv1bPtbIFJ9lGfOo7RyxOCqs86uma5eqM0Xawhar2y24i1dMjs?=
 =?us-ascii?Q?VUmh7wiiuH3sRNYxBTvMDSzWvBexBhKppWb1TWF3/5ePfomYifHGnpZpfudQ?=
 =?us-ascii?Q?VlsIxnIFnfD4G23aAs8+nvaMJFjH6W26mbJlniYtIIloqnaLNa9RTOtAx9WW?=
 =?us-ascii?Q?60TYA+V59gWwE+00b2XCe/5aW0Ygigarbny6+aXetHWX/RDVj3dIUBsX60Uk?=
 =?us-ascii?Q?JCse9FBT4NHj9SrkILf6pnsZ5soTH9lOWqNs8NBFj7Ra9diiYeOYlDhgV6OR?=
 =?us-ascii?Q?oBHW6412K2uJ6h3N5eU8QDOTp2o7xvp0T0qcEnbCjK0c3OZfcpdUOc7a6wqU?=
 =?us-ascii?Q?o9ukqQz5BI+xGjUTQaYvWrnHGNSdPEb6sdtyjzpjuO4/g1PhaVkbEpa4IkWs?=
 =?us-ascii?Q?XOrKeXPip26RAjF8sRqiMd6UqiuXSTln9MtP+Lx/0DqL/SPeSSMOCLgbKJTD?=
 =?us-ascii?Q?oVgRUm4AXYz1q1HrW8BlEuuaDBX7nOSgSRFy7PK/tQRI/ictn5l53oUIB4Ib?=
 =?us-ascii?Q?u2aG+4uNS8fe8D+yy0sQqFnAf8W8vAen+AgllAlO8E1a8JWAX4Cr+aCQ7jaM?=
 =?us-ascii?Q?JiGwsZUYXPfIrva92WEkwRouFpmv+SHRD2J+oKOW3An8RZZfeVtuyN2+FhRI?=
 =?us-ascii?Q?LoGPc7EZPozh8wp7CPy/yH5RkDQtGGNK9zy3X5ZIxiBBYZIc/iZ4PHNiuIPM?=
 =?us-ascii?Q?2WsDHKqixWdAM4iF/GwLnVvy3L0RkUBzYWYm7/qym816+e3X/vmtYjCNNFo1?=
 =?us-ascii?Q?44cAH0I6r9KzP4YqY84=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21a5bf53-9b28-43ef-c8ad-08db39d6d5ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2023 15:18:27.7550
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BOxC61x3JeKmvawvfHAgSyYhxWCf8ofccWcH98nKj7vGX2L8hHWH2tLjhqM+U/XOqbS7908BvpQ9EvcFtki7bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6285
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Monday, April 10, 2023 10:41 PM
>=20
> On Mon, 10 Apr 2023 08:48:54 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
>=20
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Sunday, April 9, 2023 9:30 PM
> > [...]
> > > > yeah, needs to move the iommu group creation back to vfio_main.c. T=
his
> > > > would be a prerequisite for [1]
> > > >
> > > > [1] https://lore.kernel.org/kvm/20230401151833.124749-25-yi.l.liu@i=
ntel.com/
> > > >
> > > > I'll also try out your suggestion to add a capability like below an=
d link
> > > > it in the vfio_device_info cap chain.
> > > >
> > > > #define VFIO_DEVICE_INFO_CAP_PCI_BDF          5
> > > >
> > > > struct vfio_device_info_cap_pci_bdf {
> > > >          struct vfio_info_cap_header header;
> > > >          __u32   group_id;
> > > >          __u16   segment;
> > > >          __u8    bus;
> > > >          __u8    devfn; /* Use PCI_SLOT/PCI_FUNC */
> > > > };
> > > >
> > >
> > > Group-id and bdf should be separate capabilities, all device should
> > > report a group-id capability and only PCI devices a bdf capability.
> >
> > ok. Since this is to support the device fd passing usage, so we need to
> > let all the vfio device drivers report group-id capability. is it? So m=
ay
> > have a below helper in vfio_main.c. How about the sample drivers?
> > seems not necessary for them. right?
>=20
> The more common we can make it, the better, but if it ends up that the
> individual drivers need to initialize the capability then it would
> probably be limited to those driver with a need to expose the group.

looks to be such a case. vfio_device_info is assembled by the individual
drivers. If want to report group_id capability as a common behavior, needs
to change all of them. Had a quick draft for it as below commit:

https://github.com/yiliu1765/iommufd/commit/ff4b8bee90761961041126305183a9a=
7e0f0542d

https://github.com/yiliu1765/iommufd/commits/report_group_id

> Sample drivers for the purpose of illustrating the interface and of
> course anything based on vfio-pci-core which exposes hot-reset.  Thanks

do you see any sample drivers need to report group_id cap? IMHO, seems
no.

Regards,
Yi Liu

