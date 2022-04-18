Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA5B504E00
	for <lists+kvm@lfdr.de>; Mon, 18 Apr 2022 10:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237331AbiDRIwe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 04:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237332AbiDRIw2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 04:52:28 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01A95FDA
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 01:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650271789; x=1681807789;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=85/a2DWuy9JB48tS0g+xgmPL0C5MXFpsE99eykdFRgQ=;
  b=J6sx/n2wk+Db1do8vTc77+VWjow6Mt8/YPwp9zt0HpoxQmhnlqebtQ9w
   MygwLWVb4BSj/6e3eSaqGcOVVmSq6XOJkf14GjIhofibHG+xgt0wbjZHo
   0K6rV2s/VOUIXUDaHUlXjslpTbi/SIb0zzK+j0+kWCNrIVizAXEq5K/fm
   33tve69ademxcg4hbRY+YAfjEwXDcECmBJfwsCzr1WEU9zBuUVN28wVaV
   y+lvx/UdC2RT9LKFoJbIt9NCLUOh6M6G1Me0giLL7qD4I7kwWMFI7wR1s
   jcvBxeWIAlPpnyPOrwcWensZg/8uioV/yFGp4U5ig65mxowiAN0RRZOsH
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10320"; a="261082763"
X-IronPort-AV: E=Sophos;i="5.90,269,1643702400"; 
   d="scan'208";a="261082763"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 01:49:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,269,1643702400"; 
   d="scan'208";a="804230018"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 18 Apr 2022 01:49:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 18 Apr 2022 01:49:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 18 Apr 2022 01:49:48 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 18 Apr 2022 01:49:48 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 18 Apr 2022 01:49:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hiOcTYaHDN3ezV2JtDUfZaYd/3IfwiqFqsxRQ4YB0GUeqit5TfMHabLvFIVMnkZhjxyf04lJQaHdGnznE8Xquw/QDsIcjwCq9XdNRpaODz+pwPm2Yf72IrIG+wOkrjU8Yi7PPrIW1tmppc/Vneu9cZzubIzrplaeJYno9anG36pfjYSa8VMvDx/tZIgere3jOazS40z2Vec/V1xIPIhDBIH1ukoK6vO+GUfj191qIMA3KnxdwC5EhEcaSgQrKIXzUQRgm4JTUrAildOkGKFYW8LG68jv0yN4Vi8pWMNW0AIjnyTCpIVTCpqZlX1PQARWyHpxC0ZYjRxAYpV8f2r6BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IqYWZktFZFwoW3Wn8hyxK7Up1I4j2b2wXGGri2gHu7o=;
 b=ip55wsKcsAaM7IYGlsg/icCK3LXk+P3GHHGmtPkqjrY834cGBgJy/BmTLYva6ne24PSmKi++f4KXHOsPa8qXD8MVbd/UScpucIc4IVbv9oLNt4qf3WXuC7bOj0mybD5yCSKttOzFwoJBY6zRPpwIYo6BIEwoZFyXJ0ZaCvxoesWWJepJq8mNjlxAMyfGMCjWIMJdcNQrdA+V/8plzw4xRlf022USMwYu6mC7HSAjisNyOlBB9d94rXwVbBxmmrMXPesNn5WK17drGKvzK5mjJoY8fWR8i3E7BpbCzBffntmFdFTLcKfEbjDxpn5ZqR9k7HIvkwbjo6L79kRRdBTWQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN8PR11MB3793.namprd11.prod.outlook.com (2603:10b6:408:86::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 08:49:46 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e%8]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 08:49:46 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC:     "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "Peng, Chao P" <chao.p.peng@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>
Subject: RE: [RFC 00/18] vfio: Adopt iommufd
Thread-Topic: [RFC 00/18] vfio: Adopt iommufd
Thread-Index: AQHYT+0D1ejJho1As0eoIzmf/Uaf8qz1XItw
Date:   Mon, 18 Apr 2022 08:49:46 +0000
Message-ID: <BN9PR11MB5276085CDF750807005A775B8CF39@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
In-Reply-To: <20220414104710.28534-1-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e680ca19-9e70-4904-25cd-08da211863fd
x-ms-traffictypediagnostic: BN8PR11MB3793:EE_
x-microsoft-antispam-prvs: <BN8PR11MB379322D999BBD88E0B3991CE8CF39@BN8PR11MB3793.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j8JVx5lsqx75yFhFa94oopP15+3W7hPo2WnizHZpbh5k6aNk2qbK+iSMm+ZrIgy1XM2bk6RSzw6QsjMJofiwhhe6d4MnOyTaOJfejYRjYvpG6hH+lJ+M8uLaSCaoMTZZJh6i5+sAhmQTMRKpb2XIULd6P7gIldNC41Hy+umYv781VnLWdY29kZmy1UUKhGrgLK4JVo4mjWmVHdI76WMgcCzT1p2O1sQ1GyUE3t6POvqlvPFf7EcEz/pGLQIvrkUBXVkIukQJA50xKdKWp8vOn4cLAYhyxv8bolceReqGFk8TRG1G9gDL5U3w2wtY0zbUnVHDu4T6nu1JYluFdbohSs6Ip0B3YmlebjED84+djGFouey/ExVinsNW55ts9ULNIIzWQXmGgY88wjNaqClPIW8uAS9tXFK2DppVvOsEVMfLVt0GDwAg3AhJ4B02hK7omv+8gCBaSDSNA8lZ6iPkoqyr8piNffYCFCfVrNnyH0E/9WX4FvA5wjOG6phqgw1TJfjydxlVL/nriW9auKiKtFvLBFuMyYO1C6Tw71KS3Q1HmaLjJdgrnk/s4gUvIxur/zvBSXCPmP+5kSHFoC3R9lUhd9lFyHmLRYhl1oigQl81s7bqCqXjgzSIjSX9Rmah7qDGCwGE7T86OEai+Wq9DiRhd9Shfx1h6vktjUtCZVnZw8Iun3QSHfnwd1BYUCJmpWkva960wgNoEXUvBzn9Jj1ZEfpBNoh1OehcasfTSxjml3BiOMjwDvCn6oFsS8GS7h1YD5kkCKpAhbQyeK0hZW6fV0UzE46PhSCRvcJCCPFNuLaX/92BtppIKY5MWyLTbZDqaA+DWm0dQ0KFCaPy7g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(33656002)(2906002)(508600001)(110136005)(83380400001)(316002)(19627235002)(71200400001)(7696005)(122000001)(38070700005)(6506007)(38100700002)(82960400001)(26005)(186003)(966005)(54906003)(9686003)(86362001)(55016003)(4326008)(8676002)(8936002)(52536014)(66556008)(66476007)(7416002)(5660300002)(66446008)(66946007)(64756008)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HtsdydHuS8Zt4PNYwUi7ruBXpWitkPTtL3kSnA6p+Kr/1qZYeBIi1EAYU+Nj?=
 =?us-ascii?Q?ThVlXSzgh5ab8qNvBAwfhLTxKgwTSa4dI7BdiQI2XsesnZBdUwirfjohmwCu?=
 =?us-ascii?Q?VJbR0KLQJax6/oT3DVOZA4qQCCpnuALTX5OawANvXD0flvIhtaLM7/zAYjS2?=
 =?us-ascii?Q?Mgf7zfxB/Pk0HR65dwRqkwgPPAC+gKrqx1IGQCFSkzt1wUCPaXb7qlDxnOZB?=
 =?us-ascii?Q?d6LaaGVRk0B7ALG5Hwo9cj0/ewoFnYfxopb1fHpHVnBrRd7zkRLfnBZlO6jh?=
 =?us-ascii?Q?nrLw0uINiXQ78znWoWZhk/aa1WwBYpTD1zWpgLIf1AkuJ2VUs5+c1PlkEjhu?=
 =?us-ascii?Q?HwFDna9b4TaNWHAVOSn/qEgwJLQAeslXzxdwpKCguKrQ0uBtEhAOOwjECFMj?=
 =?us-ascii?Q?OZCy+Dy2KP7HS7hPh7Grlz0nYWl5zQwgl8UTgFiZiuEVMiXWjOa+xb/PL3CH?=
 =?us-ascii?Q?H5IoJBhldJK1PrUdv63v5oD6cUd/p9fHqwnpyqhEwb/NlBKJ80NZMsybdA8g?=
 =?us-ascii?Q?ijuVfq8DBmP/uTo5H8GJWPrGM5oB9sgcAYDjDc9oeBbs82m5dgwSMJd+f2NM?=
 =?us-ascii?Q?H6+QaIOaOtSlF3FMl8DQXWlCu1fr+R7U+qgGNk1/3AYgkVGXnU4XfK6hrANh?=
 =?us-ascii?Q?16ugcSaWCj0nJJhxYV788ydQpORI0P6/Cb/4X0dQBS9ofwtYvjcHjlgqO9XC?=
 =?us-ascii?Q?i1uq65GmHTOtS7Vgi1kwtvlcdK2J3DqZWspC5LKHd2Upx4SKMNd0ymH/+Ubf?=
 =?us-ascii?Q?2EtqMXLiT7X8NyPdkZJiZ2IggXI3tNwULBrgEOIrCqfpXBoz0qHl2ycQUZSf?=
 =?us-ascii?Q?QFCc0rvK7SdP6w1hguofmltepW4CbU6xiaOLARLxPEkYc4Bue/WFzztAEmhj?=
 =?us-ascii?Q?TXfFTKK0KlRJGFrsmUYNrw8rpzlaWTyAIMrpGreztPvCGtI54AcqcJjOqYls?=
 =?us-ascii?Q?V0SxSb1TM+1ycSFOA7hqsqcvGtxv+WN5JXBNq3VoxSQTcDsi2S6zoCGtHube?=
 =?us-ascii?Q?MQMWdA5yyaXAD1RfTMwwst3yOwzxdTf+w7qDEYGU0U0gEXu914JqRC2BaycH?=
 =?us-ascii?Q?qUMFCay8cyv1F+m/UR93uc6B3AwhHN1n5nGpY4Q+AcHr2ERXUbRGNrwMqyPb?=
 =?us-ascii?Q?oO6qI4OOb1H82fa1mkUWmhJddBPVEFU7lJXUuafUP9I97XM10VxDCU1XD4Gq?=
 =?us-ascii?Q?JdmvWl6Y9/daHAV69X8DBOlCD4ywuLjG8hIo7e97enqzHA7tRtkHzR72soEo?=
 =?us-ascii?Q?6Gcy6NhvHtRNUzYFgumXPNfKxwOIs6ha40i1YVgMH4rpetSd7Bj9Mx+R8xs/?=
 =?us-ascii?Q?oXKzFYd8D5Sgoy1B9+pIEv0p3TDghlZ6bbbfUSlgmfaSXqO4ojsIG/S/sHR3?=
 =?us-ascii?Q?rGw0Yc1koAY3Vhfui9Qr673xBeQJgyhyFV0BouQS7RVzmyvWRSe688dkE8U0?=
 =?us-ascii?Q?VcyJwp4Ra4MKlKZ35mZ3UzD7+LHN5BjxWsnWNBYdpPYLEcLwtdAD14Stg4vY?=
 =?us-ascii?Q?6D7sviblQwZ2hTxNz2YOV3YcNFG+qfj+BkkxYbg5DGfhaPdEKzQS2uVKTRuu?=
 =?us-ascii?Q?NNryK1feRid0lNuUzmNra790jlXVLgw6ZRBDEABJscj3iBTYwpw2l+6UBRjr?=
 =?us-ascii?Q?AgI6L3js+2zEWUzT+9d7vbNTIidMa7GIiWeefhyGgWhKpSsYhir1qz7epgLt?=
 =?us-ascii?Q?2Gq9pEQkvP7Y4Nsl/1RL+vQMR1ORMii4bN/uwpIa8ZTdjvglZeurl74PlAEP?=
 =?us-ascii?Q?e2Z7HPaJTw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e680ca19-9e70-4904-25cd-08da211863fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2022 08:49:46.6031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ey72bEnadolCCyGUHG/SNyo2dOxeGdYxQ7zcfls5NRRN9cQoNhr5cSumf1iyJxAQCjmoHTNF6jsoG+rAB6v3ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3793
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, April 14, 2022 6:47 PM
>=20
> With the introduction of iommufd[1], the linux kernel provides a generic
> interface for userspace drivers to propagate their DMA mappings to kernel
> for assigned devices. This series does the porting of the VFIO devices
> onto the /dev/iommu uapi and let it coexist with the legacy implementatio=
n.
> Other devices like vpda, vfio mdev and etc. are not considered yet.

vfio mdev has no special support in Qemu. Just that it's not supported
by iommufd yet thus can only be operated in legacy container interface at
this point. Later once it's supported by the kernel suppose no additional
enabling work is required for mdev in Qemu.

>=20
> For vfio devices, the new interface is tied with device fd and iommufd
> as the iommufd solution is device-centric. This is different from legacy
> vfio which is group-centric. To support both interfaces in QEMU, this
> series introduces the iommu backend concept in the form of different
> container classes. The existing vfio container is named legacy container
> (equivalent with legacy iommu backend in this series), while the new
> iommufd based container is named as iommufd container (may also be
> mentioned
> as iommufd backend in this series). The two backend types have their own
> way to setup secure context and dma management interface. Below diagram
> shows how it looks like with both BEs.
>=20
>                     VFIO                           AddressSpace/Memory
>     +-------+  +----------+  +-----+  +-----+
>     |  pci  |  | platform |  |  ap |  | ccw |
>     +---+---+  +----+-----+  +--+--+  +--+--+     +----------------------=
+
>         |           |           |        |        |   AddressSpace       =
|
>         |           |           |        |        +------------+---------=
+
>     +---V-----------V-----------V--------V----+               /
>     |           VFIOAddressSpace              | <------------+
>     |                  |                      |  MemoryListener
>     |          VFIOContainer list             |
>     +-------+----------------------------+----+
>             |                            |
>             |                            |
>     +-------V------+            +--------V----------+
>     |   iommufd    |            |    vfio legacy    |
>     |  container   |            |     container     |
>     +-------+------+            +--------+----------+
>             |                            |
>             | /dev/iommu                 | /dev/vfio/vfio
>             | /dev/vfio/devices/vfioX    | /dev/vfio/$group_id
>  Userspace  |                            |
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D=3D=3D=3D=3D=3D=3D=3D=3D
>  Kernel     |  device fd                 |
>             +---------------+            | group/container fd
>             | (BIND_IOMMUFD |            | (SET_CONTAINER/SET_IOMMU)
>             |  ATTACH_IOAS) |            | device fd
>             |               |            |
>             |       +-------V------------V-----------------+
>     iommufd |       |                vfio                  |
> (map/unmap  |       +---------+--------------------+-------+
>  ioas_copy) |                 |                    | map/unmap
>             |                 |                    |
>      +------V------+    +-----V------+      +------V--------+
>      | iommfd core |    |  device    |      |  vfio iommu   |
>      +-------------+    +------------+      +---------------+

last row: s/iommfd/iommufd/

overall this sounds a reasonable abstraction. Later when vdpa starts
supporting iommufd probably the iommufd BE will become even
smaller with more logic shareable between vfio and vdpa.

>=20
> [Secure Context setup]
> - iommufd BE: uses device fd and iommufd to setup secure context
>               (bind_iommufd, attach_ioas)
> - vfio legacy BE: uses group fd and container fd to setup secure context
>                   (set_container, set_iommu)
> [Device access]
> - iommufd BE: device fd is opened through /dev/vfio/devices/vfioX
> - vfio legacy BE: device fd is retrieved from group fd ioctl
> [DMA Mapping flow]
> - VFIOAddressSpace receives MemoryRegion add/del via MemoryListener
> - VFIO populates DMA map/unmap via the container BEs
>   *) iommufd BE: uses iommufd
>   *) vfio legacy BE: uses container fd
>=20
> This series qomifies the VFIOContainer object which acts as a base class

what does 'qomify' mean? I didn't find this word from dictionary...

> for a container. This base class is derived into the legacy VFIO containe=
r
> and the new iommufd based container. The base class implements generic
> code
> such as code related to memory_listener and address space management
> whereas
> the derived class implements callbacks that depend on the kernel user spa=
ce

'the kernel user space'?

> being used.
>=20
> The selection of the backend is made on a device basis using the new
> iommufd option (on/off/auto). By default the iommufd backend is selected
> if supported by the host and by QEMU (iommufd KConfig). This option is
> currently available only for the vfio-pci device. For other types of
> devices, it does not yet exist and the legacy BE is chosen by default.
>=20
> Test done:
> - PCI and Platform device were tested

In this case PCI uses iommufd while platform device uses legacy?

> - ccw and ap were only compile-tested
> - limited device hotplug test
> - vIOMMU test run for both legacy and iommufd backends (limited tests)
>=20
> This series was co-developed by Eric Auger and me based on the exploratio=
n
> iommufd kernel[2], complete code of this series is available in[3]. As
> iommufd kernel is in the early step (only iommufd generic interface is in
> mailing list), so this series hasn't made the iommufd backend fully on pa=
r
> with legacy backend w.r.t. features like p2p mappings, coherency tracking=
,

what does 'coherency tracking' mean here? if related to iommu enforce
snoop it is fully handled by the kernel so far. I didn't find any use of
VFIO_DMA_CC_IOMMU in current Qemu.

> live migration, etc. This series hasn't supported PCI devices without FLR
> neither as the kernel doesn't support VFIO_DEVICE_PCI_HOT_RESET when
> userspace
> is using iommufd. The kernel needs to be updated to accept device fd list=
 for
> reset when userspace is using iommufd. Related work is in progress by
> Jason[4].
>=20
> TODOs:
> - Add DMA alias check for iommufd BE (group level)
> - Make pci.c to be BE agnostic. Needs kernel change as well to fix the
>   VFIO_DEVICE_PCI_HOT_RESET gap
> - Cleanup the VFIODevice fields as it's used in both BEs
> - Add locks
> - Replace list with g_tree
> - More tests
>=20
> Patch Overview:
>=20
> - Preparation:
>   0001-scripts-update-linux-headers-Add-iommufd.h.patch
>   0002-linux-headers-Import-latest-vfio.h-and-iommufd.h.patch
>   0003-hw-vfio-pci-fix-vfio_pci_hot_reset_result-trace-poin.patch
>   0004-vfio-pci-Use-vbasedev-local-variable-in-vfio_realize.patch
>   0005-vfio-common-Rename-VFIOGuestIOMMU-iommu-into-
> iommu_m.patch

3-5 are pure cleanups which could be sent out separately=20

>   0006-vfio-common-Split-common.c-into-common.c-container.c.patch
>=20
> - Introduce container object and covert existing vfio to use it:
>   0007-vfio-Add-base-object-for-VFIOContainer.patch
>   0008-vfio-container-Introduce-vfio_attach-detach_device.patch
>   0009-vfio-platform-Use-vfio_-attach-detach-_device.patch
>   0010-vfio-ap-Use-vfio_-attach-detach-_device.patch
>   0011-vfio-ccw-Use-vfio_-attach-detach-_device.patch
>   0012-vfio-container-obj-Introduce-attach-detach-_device-c.patch
>   0013-vfio-container-obj-Introduce-VFIOContainer-reset-cal.patch
>=20
> - Introduce iommufd based container:
>   0014-hw-iommufd-Creation.patch
>   0015-vfio-iommufd-Implement-iommufd-backend.patch
>   0016-vfio-iommufd-Add-IOAS_COPY_DMA-support.patch
>=20
> - Add backend selection for vfio-pci:
>   0017-vfio-as-Allow-the-selection-of-a-given-iommu-backend.patch
>   0018-vfio-pci-Add-an-iommufd-option.patch
>=20
> [1] https://lore.kernel.org/kvm/0-v1-e79cd8d168e8+6-
> iommufd_jgg@nvidia.com/
> [2] https://github.com/luxis1999/iommufd/tree/iommufd-v5.17-rc6
> [3] https://github.com/luxis1999/qemu/tree/qemu-for-5.17-rc6-vm-rfcv1
> [4] https://lore.kernel.org/kvm/0-v1-a8faf768d202+125dd-
> vfio_mdev_no_group_jgg@nvidia.com/

Following is probably more relevant to [4]:

https://lore.kernel.org/all/10-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@n=
vidia.com/

Thanks
Kevin
