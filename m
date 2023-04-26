Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 770156EF77F
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 17:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241092AbjDZPIT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 11:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241177AbjDZPIQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 11:08:16 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722EFFC;
        Wed, 26 Apr 2023 08:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682521674; x=1714057674;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BpT0tpx+7sOdjGoxOJM1TwehfWnqfUg0S39wVcH2JeI=;
  b=TluEyNnLBkKx6pTRltndsc+/f3l/ovDfFFJFYU9nvZY58O2PmjD9XXMc
   tffVhqipyahVGLkuA7pgfB/i+dzdxMaqarvq1CT/2qaDt1Pt7fc1a/0kr
   AlF1Wma2SsnjbfwoWHQWqgH89V2kvrX2u/w0azaDYNs6FzylKWuCOX3eJ
   V0IdxyeMrcaV7c/iqU4/1EcnWIhQQZtgvnkFCMefT7PiSUIrTkIsyYmbI
   mrOtLFilQuqPuyokvYiLiEOg37lGkR6kcNwhqu9gc3C9sIQTjLV7azE1T
   JqvuDT0ugjUCRjyhn0cK/dfgfOEYiQW0iFtIjKnqDKtT5pe6ibMrm3otc
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="410136356"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="410136356"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 08:07:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="693981418"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="693981418"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 26 Apr 2023 08:07:03 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 26 Apr 2023 08:07:03 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 26 Apr 2023 08:07:03 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 26 Apr 2023 08:07:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xj5vkUafXenitdIN6poL1lJKTT6K5087hmvkIy8OSnacfneQB4FWdkkymBkqGyrFHdkrF8dsFX7SPepyy47EClnlmMmZUfyB0gB8meC9LzlcDt8GayNQjk/o6GCfu0WrKUJ3kR75kjKQTPtdVtq8P7cy0AZEcDPx5bTECQ1UZjQGunXaYoW3r+qjr7glizo+ChkpnHgt4+xGSfBAoV6NAFJV2heVG8qe1n8XFPZVdn4zF1tSSo2m9cH9wfsT8yqVc9N+QuEGHXohrnXhZE47DtceQLjCJcdZGQUIqHnah94FzbZ5adCHMexCbTd685QrCTi7fxnvVL1jCsJH7SbT6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BpT0tpx+7sOdjGoxOJM1TwehfWnqfUg0S39wVcH2JeI=;
 b=QwqQBCl8MdRpYawxPaWdVFPR0hY2fEf51nnvUoZufekpa5YH4DX4W+dKTMdJMWEZCzAAjKhiJasYw2jOG2N1glIZzC1UE7vnzIC316yuXrHgZMu90kzvmmrTnu6fGzwHc+ioOk+kOl4B79oxpqvXuBHHTay1mvsf8OoLH5/dsYnOnbn85vvRACsVHYt4GSvsMKsU7Zeyp7ZJiIZ5ALIYXQo+PKYZ0jKZKg06d0kCsLdAHaXW0wykJdX0DhdPlNu9LvK3jNpOkNnO1+MQRIIumy82sa8UNhBQkJHg98y6Zj7st7Iyyrugm0cdcL1Xw7YGkAyPgScv5ccOGxaOc+ZmAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7)
 by SN7PR11MB6972.namprd11.prod.outlook.com (2603:10b6:806:2ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Wed, 26 Apr
 2023 15:07:01 +0000
Received: from SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::c421:2c78:b19b:f054]) by SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::c421:2c78:b19b:f054%7]) with mapi id 15.20.6319.034; Wed, 26 Apr 2023
 15:07:00 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: RE: [PATCH v4 0/9] Enhance vfio PCI hot reset for vfio cdev device
Thread-Topic: [PATCH v4 0/9] Enhance vfio PCI hot reset for vfio cdev device
Thread-Index: AQHZeE8AA4GAMSoKiU67+GzdOE4hQq89sHYQ
Date:   Wed, 26 Apr 2023 15:07:00 +0000
Message-ID: <SN7PR11MB7540873804F331E008F3B112C3659@SN7PR11MB7540.namprd11.prod.outlook.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
In-Reply-To: <20230426145419.450922-1-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR11MB7540:EE_|SN7PR11MB6972:EE_
x-ms-office365-filtering-correlation-id: fa6a405e-cee4-4b89-5680-08db4667e2d3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7/HrczcyCtvCq7WAd2MjWghxNauDY45WGF5FH5w8I9+jfjQDbyjrhbihERWUjGYFk3uwM9ZXc31l+v1Dex8t93CktJ0mwnxxf7+6if+vAOnqH5uStzP1x3tFssGkqvwBO/g0+U8UI2K7z7oEOZIhzmhvsDXY22sSrfESfeKczgBWLV/oY7m1ZC1m/j8PldiQ//n9BM576XS4oTZIym7xFlpylShLGR5jfbzvcDtkcOy5pZE4zgzind+WTDF4G7tlHpEOyF/mz0OxItiIWgrE+s1o2AIaUxvUU8r+3WLzdg8KInFrcbvwcqjCZu8FfyAkWQc6gqOhwEJcIQOCi1J8tVwjfQ3aLYOnMbDDY3Iehsv7Ds+6V9cZFfM8j8vgWjwzKsxd+sLbOmXKEPJSXza3mN/KVgsUG8VqSxXDHdt+iIAma4tXQVYBo1EHbcivV8gXXjlnRP3Pqc8oiqj5fAtOceM8NfwlcyaaS2N7+0xGnEI7CMX3ecRt5CsZFq6/fAKk5SbDMx47/O7RKLzc9QXNIeCX2Shyei6ht4E0dj5O9Cl65sqqoDugCxsA3O1awFBWL8qNMU9rplcIX/EF1qtSWhjDCgk3GpAfamy2sWY8sL6JU4u6z4TlXoJQbetFD4pghCXHPxnBjRb1shWc/iCYow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7540.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(39860400002)(376002)(346002)(136003)(451199021)(966005)(9686003)(6506007)(26005)(38070700005)(55016003)(83380400001)(186003)(82960400001)(122000001)(38100700002)(54906003)(66946007)(76116006)(86362001)(478600001)(66446008)(66476007)(8676002)(8936002)(7416002)(64756008)(6636002)(66556008)(52536014)(110136005)(71200400001)(7696005)(5660300002)(41300700001)(2906002)(4326008)(33656002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YSCGb0SR+XF6r8XYVJdNApbRm0onN/dpcp1NrFizeGE/IGf4NAO0KgSwDlgJ?=
 =?us-ascii?Q?uoKiGsBDdmYwBZzLpaXkhhIQww8BZaEItSlR3qjkvumbtcBQEWfQ1qZUN6uh?=
 =?us-ascii?Q?RULFDX2549bSy62NUMIDSIUoFvps18xGqzUbJGAU2nW88lykPTcp+TwdJdZZ?=
 =?us-ascii?Q?yqNXzZpOXamNcfU5liyLzUhf6xY6fWpp1jc+ojpbQKd9hGCN1VvEYcugpiDx?=
 =?us-ascii?Q?OUWFaKjKw+Ru9QXUhUWDaGbiJN+SUq0HUX7s8/M24dgVkTuwVrHsrEQQfCfe?=
 =?us-ascii?Q?KhfbwKxP19kVihd9ZNQCZvD6Sm5KDL7s7boQyHaGWNrDp2aL7nzPaPBYVQRo?=
 =?us-ascii?Q?plvk27e0shMIe6aqggo5btS92lrItwd1HBvgz7sbNvwsbdmz1nNLCbeGgD8n?=
 =?us-ascii?Q?2FrIvVQDixEs1R7853fIgH+pAzS22of3cvu6nw9axgNQRNvoMQ2eDM7/944l?=
 =?us-ascii?Q?uAfMJrA6fAqrVCcoEOxoCY9jdQLs0IwTV1IRJSCHgFijprDSEfh53f/mKTTB?=
 =?us-ascii?Q?5M36smf1CBnkF4qRtqz+7SvE9p2Zd4NtcErL+zkdFCgW53p6NnEKuxfdE4zP?=
 =?us-ascii?Q?ZdFN492vCFd7Q+ipqtUq5Gyce3Xlw+Ax4UpHH7i/AXDlmVFH7OZDiLPstnUH?=
 =?us-ascii?Q?wIaPibr/s16ytWO/VJOqN+iB4kbw2OtNklgXGPxBz6TmMt9UOre/HjCzGPuJ?=
 =?us-ascii?Q?1jB5nxaA5ZLlIIUJeFtIkVyk12b8uWFn9iHAnOq8ov+EcHMfmGTGBfnkwls0?=
 =?us-ascii?Q?xz9Fop/6VH96MpylstJduKN44ggExwuT062C4Q8i+2PcuFRtMybUpnM+9oEx?=
 =?us-ascii?Q?/CBCNLTFgaroj49eBeYLjm/74MbeTXeD1l55sHdlVK1FJdqg82Mc6CRWMacx?=
 =?us-ascii?Q?rWOyhKqBkMOyFQ3ObMbvUhhgoWPNQRd599z8hPvvdWTjXEl6iOyFFbo3w/On?=
 =?us-ascii?Q?bFXFxde6Yw+4gNtVdSxWa+p0NzreSpc/6Yc56wW+/DWLEFuRuqt/FHimc9rN?=
 =?us-ascii?Q?WNPjwa2Y4oO6biDw/Xm+/k+eZl23SbPlyl7dQMBXemrcwwEWbqYmRwKu12b4?=
 =?us-ascii?Q?/9LyeqFgFc4UViNIAF7DisF51LU8O57pc7KpfuiO+zH6cgcS2dpg2SUKJaZq?=
 =?us-ascii?Q?qYp8Uo+v0Amb32Zaz7DN9QABa1trBuuVLrQBFOugtY+BH7icN/OLvDfeExA7?=
 =?us-ascii?Q?9S5x71Uo7dlPA3Gn15g1eSuguemdu4KyTVy0Y87tw9qqwmBvoAPcFSVY0KkF?=
 =?us-ascii?Q?oKqRwbYr8HfLbq1rZi0u6N5OJITodAVqgT+rFHsw9dQAbn19i+5c/6vrb46+?=
 =?us-ascii?Q?A5lIUgEhhpevxO+26uB9lnSo1KK/lhSJbzN8Mc7eANeXQMyMJZJIOG3ZksZc?=
 =?us-ascii?Q?Puw/0VSjM5Qa0CcNqhCKHoVW3M1/64IjWlkU5v2mX6YsgPvwXN791MD1BFx1?=
 =?us-ascii?Q?loQJXB1EX7bB8QHSsacDKguU/ImoIrdOgz9t/ho+I2vnfALOxYpe4FdUqcfO?=
 =?us-ascii?Q?8XvORVX2Dm5vvbOjBBfez8Kp3uSeY30o5EITN1b+es6zwrvBDFuSHAwN3KTs?=
 =?us-ascii?Q?RUOmg31K5imt2PXSIDUWeudg5eWdtNdDB90M5TLO?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7540.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa6a405e-cee4-4b89-5680-08db4667e2d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2023 15:07:00.3877
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rr2QUhERpWC83lzyvJvczpFaiUC5Cc+8DL04loaJuLDdkL/qeO9RxhonEKJbNRa5vxQA9Zt6OeYzXhwf9K0yaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6972
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Wednesday, April 26, 2023 10:54 PM
>=20
> VFIO_DEVICE_PCI_HOT_RESET requires user to pass an array of group fds
> to prove that it owns all devices affected by resetting the calling
> device. While for cdev devices, user can use an iommufd-based ownership
> checking model and invoke VFIO_DEVICE_PCI_HOT_RESET with a zero-length
> fd array.
>=20
> This series first creates iommufd_access for noiommu devices to fill the
> gap for adding iommufd-based ownership checking model, then extends
> VFIO_DEVICE_GET_PCI_HOT_RESET_INFO to check ownership and return the
> check result and the devid of affected devices to user. In the end, exten=
ds
> the VFIO_DEVICE_PCI_HOT_RESET to accept zero-length fd array for hot-rese=
t
> with cdev devices.
>=20
> The new hot reset method and updated _INFO ioctl are tested with the
> below qemu:
>=20
> https://github.com/yiliu1765/qemu/tree/iommufd_rfcv4.mig.reset.v4_var3
> (requires to test with the cdev kernel)

The cdev kernel is below branch, this series is part of below branch.

https://github.com/yiliu1765/iommufd/tree/vfio_device_cdev_v10

Regards,
Yi Liu

