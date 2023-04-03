Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4816F6D3BA7
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 04:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbjDCCEK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Apr 2023 22:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjDCCEJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Apr 2023 22:04:09 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42F89005;
        Sun,  2 Apr 2023 19:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680487447; x=1712023447;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0O5qum0Tt7GK+tn7H3s5RfqQ/Ob5lYZ5UHJ1No4uYeA=;
  b=IDiize5D58zTe3bWV0Vg03BrQRELhjcZDl/Ag9FCWbGFS+OsLKvO8d9L
   K7DlrFx3u4auYnavHhxbD95cWtlQflPRD8IuRtc+fPAL6ceanpgyiTa3g
   +GLfqaFb8OZcjrWMMz54IWnmzL62Gj3XKnqKvWLTtdjiVkuWW1+9RzEFK
   TJguK0USgV+Nb36SAOS/P8vFSn/NvjjbQDkg2yMBBsThq/qc60/GYDDge
   ngrFJbuBUfnB9q1XW17WYR+2GLiUc2SB5W0StDcyovQa8os6ONbCINk85
   xx/KMoq4+8SHh7GAakveq/j89zKZUsAduq3YYb5C7fSZ1cbagY59Raa+T
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10668"; a="321449236"
X-IronPort-AV: E=Sophos;i="5.98,313,1673942400"; 
   d="scan'208";a="321449236"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2023 19:04:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10668"; a="1015526900"
X-IronPort-AV: E=Sophos;i="5.98,313,1673942400"; 
   d="scan'208";a="1015526900"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 02 Apr 2023 19:04:06 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 2 Apr 2023 19:04:06 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Sun, 2 Apr 2023 19:04:06 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.44) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Sun, 2 Apr 2023 19:04:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g+HXev5i+9ZQsnpOVjibAIaaTAOVjup9771MfWix/0YRAcsKE6nwihAhccIb6lPbIF5Oxo/3yVKJIFkvOxWjIlRNzsJAXWptC0jMP4UvQ4kJmzbd5o1szNv73IUr/t9EQHWaVqxTA+V53kRVOhxr1IqG3NDS8CeO4EtZ6uru6daryKp12T2W/lOlooxsPnc1IjheIaSh1egH5ZUnSg4VLsBa/xip8nEDjrBmc1jDkOZ91b1e7o3hjaYOWgjj1HLs/Dq3uGu7zTQq9X/iloIxRD6dtqFsPBvfvvyJ24VGfRGIZbF62QiV5oMTQNhlSpu2g2w+JWoNzbOfRB2n6sRL0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y5WfTxaxTPK0E9v6IGmG/SHvfbkLnjetTuP9u4h0vOQ=;
 b=Ko9poxpQhP9mv/BCZzPgJ71V5bCJVwf5qDsFV4KkGZISmgjo9mwz9IISKN9JKs96vfLKDwTyt9iUZPRDpyy2MgCDsFgH2/mINepPEvCtdTpZOa8aORwrBbxVM/7GnkbnJYXJFqAft1BxieNTlZgo6j6of3lzOXQ7e5ww/lAKfcFaXvYtyMAlXao6f/G1uxQ+efWvLOO4z7rfpGtOwRbs/NjzeD4qyJsQTa8YQRwysqmZ3tTgnrG3DLIQYzMvf2olCdg677Mb4+cdrfA6JEteomELnb35h2MGPjJa+btxF5w15b6aTS3VOfC/FmmeVmKMQt5Q6ssKPm9o7cZg/zJKIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6763.namprd11.prod.outlook.com (2603:10b6:303:20b::7)
 by CH0PR11MB5364.namprd11.prod.outlook.com (2603:10b6:610:bb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Mon, 3 Apr
 2023 02:04:04 +0000
Received: from MW4PR11MB6763.namprd11.prod.outlook.com
 ([fe80::c4e:6c7:e9f7:7222]) by MW4PR11MB6763.namprd11.prod.outlook.com
 ([fe80::c4e:6c7:e9f7:7222%6]) with mapi id 15.20.6254.030; Mon, 3 Apr 2023
 02:04:01 +0000
From:   "Jiang, Yanting" <yanting.jiang@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v2 00/10] Introduce new methods for verifying ownership in
 vfio PCI hot reset
Thread-Topic: [PATCH v2 00/10] Introduce new methods for verifying ownership
 in vfio PCI hot reset
Thread-Index: AQHZYI9oL669gEM9E0+QMvpJm73ZX68UPIhwgACqogCAA/ez0A==
Date:   Mon, 3 Apr 2023 02:04:00 +0000
Message-ID: <MW4PR11MB6763D53D27521AE33B2FD42FE8929@MW4PR11MB6763.namprd11.prod.outlook.com>
References: <20230327093458.44939-1-yi.l.liu@intel.com>
        <MW4PR11MB6763D4F64127A5205D3B6567E88F9@MW4PR11MB6763.namprd11.prod.outlook.com>
 <20230331072438.21c9243b.alex.williamson@redhat.com>
In-Reply-To: <20230331072438.21c9243b.alex.williamson@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6763:EE_|CH0PR11MB5364:EE_
x-ms-office365-filtering-correlation-id: e4c8ea8c-6ffa-468b-28d6-08db33e7b152
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: knGuizA3enTZgY0RhCeWT3ZYMOquPe7DMFibc0yhEZRwcIA1jdVgWbtx58XJe48h2RAG7gaRTqaPT6nOpqhZI99pEcqKJMn9ecKcOg77DBiRJ9ck2HJwsDBP9kndt4U2cO+kCHitk2nugNiXlHJRtpIKX3K9ZWGv32L7NMcrfon6MNzm7h2zXfynQu5jxluiMqY3CGJTcBSf5q9JKY5yq44qqNOLVjMpHRhY4JPHTAxv2WOscemcKp8iPo1qm8uLS/6kLcgQtNTGbTwrVmkZjGRAh02fpw8oH9+6Jrblc8PIT77mYwcBrcKvSn60wgzVAHS9nABaNYgnNhimsN9vyvkHxhMg+re1UJZgzhApvFXdVJbM24mV9n6mu2acL4kexu/kYMkj8Womt/ezcYIhlrosvPBEE2mRwPuJB3mx3zBqFTiRvhQJMjNfeGi+/AxPfAAL45xp6KgTvIHJqu5ss6q8tGlS52KR86uJAh2OYzwN5Z0QBrgN8CqUKEgx+XCT8iUDVnmem7lqfWm+wt5A5lDoTEB/GjuRNMMGTxM+53JRD6BFXYj4+HseSDcD+TrvGniB1Sb96qNYNzZmPQgfpop/VKAM1SqDdz9b1iQCxcyQTdvWEVuflLu9MBEWCbod
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6763.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(136003)(376002)(366004)(39860400002)(451199021)(53546011)(26005)(6506007)(6916009)(9686003)(186003)(83380400001)(52536014)(7416002)(8936002)(5660300002)(4326008)(8676002)(64756008)(41300700001)(66446008)(66476007)(66556008)(76116006)(66946007)(71200400001)(15650500001)(2906002)(7696005)(478600001)(54906003)(316002)(55016003)(82960400001)(122000001)(38070700005)(33656002)(86362001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?q2YQWlRZtfzCfr8N/EYZHk17Yo9YA5Q/ir2A+BGWZpIsinG4wgPsxca+K03m?=
 =?us-ascii?Q?3oZKzWF96AGVJNaXQCkOnPp9r5vDRJy0enZmMhM+LniA9xUSlDkIq3MTdKRG?=
 =?us-ascii?Q?z+GetQR5C6Bc8EXbohXUsGATMTJGMMC0XGwcneKW8kho19qtL3LeR2RXBGJG?=
 =?us-ascii?Q?ubH+VB7x4teOrrlulyv9M44tZSJ6srLjUGCqk5MN+fnLhVsOmTctPjYlQ5qo?=
 =?us-ascii?Q?94fb9MDF7pIoG/x6otFcHCI9hCYNhmglXWLOlbqZ6BzDDEFPUUy//QFSKnCD?=
 =?us-ascii?Q?/5h16H+VSi5d7X74LzA+IHcuNykc22UjSDQsdQeZIgcule/V7l61xr6CTexj?=
 =?us-ascii?Q?vXpG6W3ZQwQGmF1ZA1emNFJrAP0xMNPoivfNHFFlKe2grkgt8T8tDNfRnKVc?=
 =?us-ascii?Q?hBILGq26yacwFtrOATW4jBIEsSFv7VtTuUWsftvbZEKv7hZTbRUhQWWKrjd6?=
 =?us-ascii?Q?+3t6qyvUB8gRly+DDPtO2Aqqqympd9fyG1RX46YqjzDudJXyIsSYLKk4WoA1?=
 =?us-ascii?Q?awi+Ams5tVWCogRH/DSOJD1ajcDXme0v3nbXN3+lU1lDKUVgFNs7fGEcJyN8?=
 =?us-ascii?Q?18x8Go36E3Kur5EkpKc2VPVje2n1TJucrK9fkqSx/2cneniHATxS3rRFgKNE?=
 =?us-ascii?Q?0QiKkRuqPBbAShPjKDQm1TSwpswlzLtSBc7oLq1G8CvEVZAhf//CcaNR+hlW?=
 =?us-ascii?Q?Weva4LT2Ecu+E7aiGAE+oHFwfijN5Wayy09bK7HDVkELMQR5U5zYFRASmIj7?=
 =?us-ascii?Q?6gnsT+uP+kOhzz0zHY1u6dfIaTRQ2ePpnAo4O+7PKlM4YcYCav+8PoJmizvM?=
 =?us-ascii?Q?ycoS/NkJ+OiEQw1EkDmwUNaFQ1f+NHM1FkXuerpY0X1yQx13i3YJLTjjIsIW?=
 =?us-ascii?Q?inwB4+rxdfxawwh+DSLm03UT7gixYOQ5xEF6X87GmP5OaYvSqYGLmB8q6yJB?=
 =?us-ascii?Q?3XdPplK7kRRmQ0Iws9rtP+p2hChP/35EEsmm7MV8MLSbVIrghXHcgyqV8QmB?=
 =?us-ascii?Q?cho32nSu959/aMcOAbhiGzbI5my1dcJzHa+TFWW6g8urfkdFRVzTiIZCFWnU?=
 =?us-ascii?Q?ZSxz87L43DND9qC2PZsdn86tSzklYaIRgB0BinZOdIeQXWdOpOTYUeLq8KJG?=
 =?us-ascii?Q?7UAm1FLiIEBLLI6dvNcIbtq8/azn8wPxjbafF8PzPxV7xqZVCCC7SuvkuX85?=
 =?us-ascii?Q?8y2elECG+KHJQ19SsoXiBzP/nEqU9+pn/j6w9xszDs9ogatlO30bDAdk2QVp?=
 =?us-ascii?Q?nH6V6fercZYAXeoPZLZg79OXzwxOs0Y07bGXjNbY1+UxR+dthSTq5roYqG6s?=
 =?us-ascii?Q?escgIurYFKllpMLsw9UMw7Eg0NHeBVGK+YN7Gc1QeNj8tFnHmrmhITvPAwWX?=
 =?us-ascii?Q?0ucoiOsVkI1xxwZLMswhsQoSVwkz2f29dGgtTxdc39gbcjKViOsNGJd0VjsC?=
 =?us-ascii?Q?kvGxlUIwKg2YbMjOHkblTML+W/mWnPaVTvFMhVmCNsgykRoPsBNh4tcNqQpA?=
 =?us-ascii?Q?JVTIjsfLSXVhs6JUGujK7sG3YSz1C6lHuE0wT+CC9r5yJF2VKCohfEXRjiFo?=
 =?us-ascii?Q?PyCHUDx8GcFobGh++8RmUGjw9DNEAC/X9aGNpf4N?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6763.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4c8ea8c-6ffa-468b-28d6-08db33e7b152
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2023 02:04:00.8234
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NkK873Yct5kxK5dYNFg+M/TPbP3oEdeBrs6jMGIZXmJ+Lw4x1wfDRdOwMn6lD7uLcnCS+NxgVMTP06kNOto8pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5364
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, March 31, 2023 9:25 PM
> To: Jiang, Yanting <yanting.jiang@intel.com>
> Cc: Liu, Yi L <yi.l.liu@intel.com>; jgg@nvidia.com; Tian, Kevin
> <kevin.tian@intel.com>; joro@8bytes.org; robin.murphy@arm.com;
> cohuck@redhat.com; eric.auger@redhat.com; nicolinc@nvidia.com;
> kvm@vger.kernel.org; mjrosato@linux.ibm.com; chao.p.peng@linux.intel.com;
> yi.y.sun@linux.intel.com; peterx@redhat.com; jasowang@redhat.com;
> shameerali.kolothum.thodi@huawei.com; lulu@redhat.com;
> suravee.suthikulpanit@amd.com; intel-gvt-dev@lists.freedesktop.org; intel=
-
> gfx@lists.freedesktop.org; linux-s390@vger.kernel.org; Hao, Xudong
> <xudong.hao@intel.com>; Zhao, Yan Y <yan.y.zhao@intel.com>; Xu, Terrence
> <terrence.xu@intel.com>
> Subject: Re: [PATCH v2 00/10] Introduce new methods for verifying ownersh=
ip in
> vfio PCI hot reset
>=20
> On Fri, 31 Mar 2023 03:14:23 +0000
> "Jiang, Yanting" <yanting.jiang@intel.com> wrote:
>=20
> > >
> > > VFIO_DEVICE_PCI_HOT_RESET requires user to pass an array of group
> > > fds to prove that it owns all devices affected by resetting the
> > > calling device. This series introduces several extensions to allow
> > > the ownership check better aligned with iommufd and coming vfio devic=
e
> cdev support.
> > >
> > > First, resetting an unopened device is always safe given nobody is
> > > using it. So relax the check to allow such devices not covered by
> > > group fd array. [1]
> > >
> > > When iommufd is used we can simply verify that all affected devices
> > > are bound to a same iommufd then no need for the user to provide extr=
a fd
> information.
> > > This is enabled by the user passing a zero-length fd array and
> > > moving forward this should be the preferred way for hot reset. [2]
> > >
> > > However the iommufd method has difficulty working with noiommu
> > > devices since those devices don't have a valid iommufd, unless the
> > > noiommu device is in a singleton dev_set hence no ownership check is
> > > required. [3]
> > >
> > > For noiommu backward compatibility a 3rd method is introduced by
> > > allowing the user to pass an array of device fds to prove ownership.
> > > [4]
> > >
> > > As suggested by Jason [5], we have this series to introduce the
> > > above stuffs to the vfio PCI hot reset. Per the dicussion in [6],
> > > this series also adds a new _INFO ioctl to get hot reset scope for gi=
ven
> device.
> > >
> > Tested NIC passthrough on Intel platform.
> > Result looks good hence,
> > Tested by: Jiang, Yanting <yanting.jiang@intel.com>
>=20
> I'm not aware of any userspace that exercises this reset ioctl in cdev mo=
de.  Is
> this regression testing only?  Thanks,
>=20
> Alex

Hi Alex,=20

Yes, only regression testing and some negative testing for NIC passthrough =
with legacy vfio mode, vfio iommufd compat mode, and cdev mode.

Thanks,
Yanting


