Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B24FC755DF0
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 10:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbjGQIJw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 04:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjGQIJo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 04:09:44 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768C61989;
        Mon, 17 Jul 2023 01:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689581361; x=1721117361;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LD1LSBJ0DveCVuTZJgCcoadxnVwyP7pk3PLVhWAHrZQ=;
  b=TumHs1CJxMoiSlVd+d9ZM3lBgBSahzwmRFca/0vL0SA7J0NBv7tgFsVv
   yrvDaiosk9veP4Civa49mRguM+h9aVfhSzWMogdWLysbcbWNB9zUWFKel
   FPtKLIzP3sfs8+c7wXEEZjrtwuj1LXyQ/p5O0yHEy/ld/MFB7gBIj4g6U
   bRPgSedTZM0jNNObeXB7epEETPDYXnNIdr9i71n9OJAqmwdZ92J5CNXaP
   TVWODtsGRAhEg9mR6SfXoIbmvodlLPR8EsJWN8FLhbN5dDfrMURbIc8DM
   K0su4RD37o+hOdCKh+ecPbbWJqyD3vgRoKDF82t2pLqhUCigIglDzYrW7
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10773"; a="345464432"
X-IronPort-AV: E=Sophos;i="6.01,211,1684825200"; 
   d="scan'208";a="345464432"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2023 01:09:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10773"; a="1053810035"
X-IronPort-AV: E=Sophos;i="6.01,211,1684825200"; 
   d="scan'208";a="1053810035"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 17 Jul 2023 01:09:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 17 Jul 2023 01:09:02 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 17 Jul 2023 01:09:02 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 17 Jul 2023 01:09:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dcjW7GBVjWmFrtrd4+7WBHYE/6GQ0kYCkxmlb+VrbTHMGn9QwqzWWKMAychUV+Hkcq6LgHPJj2jkU/orU8VLVfNkaP5Pe0+EYQWxnHLq6ILRdrKqxmPTeXJr09vE9ulmEyIq7L4i/fxHDZcUfoQkJ+fiF6kES1mQPyaiZfmzHt92eK9AlSSnq/DKjNeObNqeA0DY0JK+UDeYZWzg8mdHgt0G4q3xDdezgVRmE2GVjXECJbRQzhaKLuCv6ueQTezgzJ32AoI0kLKE5pA3Q7+Pn6BYObm6HHpbcjV59iIGOurAsAElVUwLvmydv/jF3hJ+r8/WAvfAxoAJl5ki1tFFug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CigVVbxhBzUz7+qUYZE0HNzcrQO7Oqf7xiDnaI8qNSo=;
 b=HbDjln4uOWpvqcKhRU6ibm+P9fHOPy1WtUDjGCVjjFhW4v2aVXoIDUcVRLsstY8I5oTdwKbbzPvW5HDoCaH70pt+yqunDo8DCI3XIRid3J7xQh8KfxHDYbZResb/Jrh9oLCMfSzMAesmZZYmVokiAvYBQQOM/m8VrMfa4OZ3P9XplMlCKlqweG5Ekr1RZnor0Z8+LUqf+ktOZzPnvOlRZQjabwrn8WoY0ZNz0VskTfjHvNYtT51abELOecak1fzVx+sZgVbetsgLcacKOBMak9SsuohnDlvcm2s2/p+o67UDXU3WV++YrkxdilltjAsDqAiiFSMDYmK0GuWBDPviiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MW3PR11MB4587.namprd11.prod.outlook.com (2603:10b6:303:58::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.25; Mon, 17 Jul
 2023 08:09:00 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::806a:6364:af2:1aea]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::806a:6364:af2:1aea%7]) with mapi id 15.20.6588.031; Mon, 17 Jul 2023
 08:08:59 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v13 21/22] vfio: Compile vfio_group infrastructure
 optionally
Thread-Topic: [PATCH v13 21/22] vfio: Compile vfio_group infrastructure
 optionally
Thread-Index: AQHZoDagsdh+fCMUvkyHLuzt/JVGpq+9qlBwgAAgfRA=
Date:   Mon, 17 Jul 2023 08:08:59 +0000
Message-ID: <DS0PR11MB7529F01B82FB659B96D15E38C33BA@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230616093946.68711-1-yi.l.liu@intel.com>
 <20230616093946.68711-22-yi.l.liu@intel.com>
 <DS0PR11MB7529C571419F1DB629AB7E92C33BA@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB7529C571419F1DB629AB7E92C33BA@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|MW3PR11MB4587:EE_
x-ms-office365-filtering-correlation-id: 2706a599-1a8f-4355-9b32-08db869d132b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5o/4gJTcs0wWFZxY4arFzXGSokHUJirVxuedv+YbYCKWQFEoNVJnFBGJtnjbXfQ17O9nmq/zpZ8jATS9MDQjM5qkBapI2ecLR2mG+LtsriDrk/io2Rpf+6xyJ1dH4TE2WcD//jgGnD7RJkPheFDx7rlaUGX783ZfFyuObcD0hncgBYo1LcHfShSGVB0K56AcDJk+EUwfhS4jZwL/l1yHIhxtcrCDKVkaW0GcKcjBnhacudTFCa+hXLzT1kbhHDWNZr3nyESUl17caTkH8uTeRW7J4MDIEAC+oF0WjorcBQIRfo9KQ7Qn/y6RHwKVYmSTdyBrC1Pd0/cxxklpD+iY4s5/8JKHfhzWunNAswiuRWWb1pDJk6T/6/6lcK6No1/uikJj6drtV7B1b0RQ4uvG6GZ31rXBr4iE1usFAtLmzOFEUyTuYdQk2aXzmj3fcUCwiVNsMJJoWyRte+0gTX2zJyKSHWpq1fajpaaXhGagQOgDt5f8bhwL3xNDAtrQker5+RKJI0aK9oeWcPOr2X9Nf3YjG3YrIh338Hxf4WINKJ4Tu8y2WYj/sUDHGHZMxMRcBnV9/Je6V2OMFi4l/Xp1FeQEK1FHoN9O/dfUL0V53OVk4a2ZjZVUzeYA14hWXOWX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(366004)(376002)(396003)(136003)(451199021)(66556008)(110136005)(54906003)(76116006)(7696005)(71200400001)(478600001)(4326008)(2940100002)(66946007)(7416002)(30864003)(26005)(6636002)(5660300002)(64756008)(41300700001)(52536014)(8676002)(186003)(316002)(66446008)(82960400001)(9686003)(122000001)(6506007)(66476007)(8936002)(38100700002)(86362001)(33656002)(38070700005)(2906002)(55016003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?s/Dt5ojLxHfVm3qm/ps3SB4eZppa9CLshrbn7TFZaDPaI7h5fcf9S1Hl2nNk?=
 =?us-ascii?Q?6xR1gocqBKn9eEP5LFXeHx2u/Ircyvv5uqrqEr1q7ysUz8zpRzO8Oi+YkTdf?=
 =?us-ascii?Q?62eDMrm101f0dYfzuENfje/k3hmg9eb1jcQwOqzlG1y4QmCV26z5c39ezAl/?=
 =?us-ascii?Q?C1iYepNThxPKThIKEZF/6PrWy96c3f7vtFyXc5toMaUBXyiUkztH5nBh4OqH?=
 =?us-ascii?Q?f4rDS/NAL5ULP25xR8Id+LxvpAqZ6o4wggAiXC/8cVQS69o/bCLvQ+t1BbvX?=
 =?us-ascii?Q?6M3jdS7UGUKahGUKnsa40kGeaDaVCX8apFXtgkIoMHGPbJ67ZjSAIW1F88V1?=
 =?us-ascii?Q?QPydUalhNmxGk2yYe/3IzDG+p0Gr/VZ8Oh2YM+YfchVYOs2KLJ34W/xmRAdV?=
 =?us-ascii?Q?gnVysqlod0SGM/R1UzIEul2okVv9+47KazQo1oSfdOImn0dR80vbRURoeXAX?=
 =?us-ascii?Q?t4HPADR/75KjZAabldNB44pgix/7ZW4A36CCxQnnjWv5brgqnE8bUQp7A8h5?=
 =?us-ascii?Q?NLPbieFU0zgogTp3ty72m7nLQ5o7eo5dvzHStl4ijsP3KFC2uCmsoKsEhHnk?=
 =?us-ascii?Q?kT0C96fhKvd6aFpNujtfk3GxSst1e/w3/c/2+IQYwLusO16ztBTfXLBumTs+?=
 =?us-ascii?Q?td6pG8//WADeHGklFz2FXryS21qz6KbncNTEav7HPkn/1cca3WPIuKZJDrLo?=
 =?us-ascii?Q?o2NxTQzp8oChmXDYFE9xTrXY6acewPAfEbTOArIKateP5hys5dKeT2DT2Ypn?=
 =?us-ascii?Q?rZ4wmWj4+wmRfsKNfQCHndzFnFq+tPAmntHxBQlJdmz1/B9vqSW7oqRIEejS?=
 =?us-ascii?Q?XvPIsMRP1Y18lVfX2wlVwyXmRrhbavjM77RI32x1uppl+uFhm10q2mMk47lD?=
 =?us-ascii?Q?LI26iRv6RmfukDL/UIM96g/g1qqArS4kx2iumgd/HBeU9OBm5DLuxqFOpc3e?=
 =?us-ascii?Q?A3dzd41FR4ZW9+4qfnyISOarYakU0cH30Gwf3XO/OeSJvUSPIZMNTmvBnYZ5?=
 =?us-ascii?Q?dgoOmD2BpUIc60kAt1jR27p27k5Tx6BiBJZtk4sBvmauzIQPQH5XcNXZUix2?=
 =?us-ascii?Q?go3sA0jXZ2DL8IkBnbx7nG2Y8DSXdK2iPJg7Ufv2mC6/EW/J717arSeZrPbb?=
 =?us-ascii?Q?4DF5WWeuQxEDkTkFdgkUtzmRNFoYUIm6FfM69lu0K28xLUQMzksKDovGyDl3?=
 =?us-ascii?Q?FDA/PpLRzZeqVkePlAMmpUTWVp9HA6RThGGsA6ds60TqgFgOMBv9f/73sHBh?=
 =?us-ascii?Q?n8ZjhjpIawIQ/37BqbpqUD0F0p71AKxE6MFBNQbvF0Q51GIRr2XmsynNjUMf?=
 =?us-ascii?Q?SEuU2Pgu7z8MFIKItTw7NXS0s/fpnQ8OLY8ZN5A/cqr7PKXG/rrzCDkqEB0C?=
 =?us-ascii?Q?n126Flk+iN9GMHZ0TbtPnpRgShm5LSrPvS7WgUEj/0oaTu0zRNJ5H1NfiGv3?=
 =?us-ascii?Q?Vw4LkhxWmWoU2GAdsc89ayE6jCoio6acTYPBwfMCSnhrsyJdviB4cPxQEf9H?=
 =?us-ascii?Q?xmMai8/P09Uilv2e3OW373fpDv0Ed3FTD+qMRXmSZofe/5VxuhwvkDuessGO?=
 =?us-ascii?Q?YZslGRg8DV3Qcm5ITnFqJjyySwCIub4ac+33faTt?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2706a599-1a8f-4355-9b32-08db869d132b
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2023 08:08:59.2364
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ISQC85o4MrNOLiA4hCZqAO9RpYNmoBDwnXv1Gwsjr12tGUpAMcAByTFoNrAOW66cifAWTqWDwV6fxzZVaB/Q8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4587
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, July 17, 2023 2:36 PM
>=20
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Friday, June 16, 2023 5:40 PM
> >
> > vfio_group is not needed for vfio device cdev, so with vfio device cdev
> > introduced, the vfio_group infrastructures can be compiled out if only
> > cdev is needed.
> >
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> > Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > Tested-by: Terrence Xu <terrence.xu@intel.com>
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/iommu/iommufd/Kconfig |  4 +-
> >  drivers/vfio/Kconfig          | 15 ++++++
> >  drivers/vfio/Makefile         |  2 +-
> >  drivers/vfio/vfio.h           | 89 ++++++++++++++++++++++++++++++++---
> >  include/linux/vfio.h          | 25 ++++++++--
> >  5 files changed, 123 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kcon=
fig
> > index ada693ea51a7..99d4b075df49 100644
> > --- a/drivers/iommu/iommufd/Kconfig
> > +++ b/drivers/iommu/iommufd/Kconfig
> > @@ -14,8 +14,8 @@ config IOMMUFD
> >  if IOMMUFD
> >  config IOMMUFD_VFIO_CONTAINER
> >  	bool "IOMMUFD provides the VFIO container /dev/vfio/vfio"
> > -	depends on VFIO && !VFIO_CONTAINER
> > -	default VFIO && !VFIO_CONTAINER
> > +	depends on VFIO_GROUP && !VFIO_CONTAINER
> > +	default VFIO_GROUP && !VFIO_CONTAINER
>=20
> Hi Alex, Jason,
>=20
> I found a minor nit on the kconfig. The below configuration is valid.
> But user cannot use vfio directly as there is no /dev/vfio/vfio. Although
> user can open /dev/iommu instead. This is not good.
>=20
> CONFIG_IOMMUFD=3Dy
> CONFIG_VFIO_DEVICE_CDEv=3Dn
> CONFIG_VFIO_GROUP=3Dy
> CONFIG_VFIO_CONTAINER=3Dn
> CONFIG_IOMMUFD_VFIO_CONTAINER=3Dn
>=20
> So need to have the below change. I'll incorporate this change in
> this series after your ack.
>=20
> diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfi=
g
> index 99d4b075df49..d675c96c2bbb 100644
> --- a/drivers/iommu/iommufd/Kconfig
> +++ b/drivers/iommu/iommufd/Kconfig
> @@ -14,8 +14,8 @@ config IOMMUFD
>  if IOMMUFD
>  config IOMMUFD_VFIO_CONTAINER
>  	bool "IOMMUFD provides the VFIO container /dev/vfio/vfio"
> -	depends on VFIO_GROUP && !VFIO_CONTAINER
> -	default VFIO_GROUP && !VFIO_CONTAINER
> +	depends on VFIO_GROUP
> +	default n
>  	help
>  	  IOMMUFD will provide /dev/vfio/vfio instead of VFIO. This relies on
>  	  IOMMUFD providing compatibility emulation to give the same ioctls.
> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index 6bda6dbb4878..ee3bbad6beb8 100644
> --- a/drivers/vfio/Kconfig
> +++ b/drivers/vfio/Kconfig
> @@ -6,7 +6,7 @@ menuconfig VFIO
>  	select INTERVAL_TREE
>  	select VFIO_GROUP if SPAPR_TCE_IOMMU || IOMMUFD=3Dn
>  	select VFIO_DEVICE_CDEV if !VFIO_GROUP
> -	select VFIO_CONTAINER if IOMMUFD=3Dn
> +	select VFIO_CONTAINER if IOMMUFD_VFIO_CONTAINER=3Dn
>  	help
>  	  VFIO provides a framework for secure userspace device drivers.
>  	  See Documentation/driver-api/vfio.rst for more details.
>=20

Just realized that it is possible to config both VFIO_CONTAINER and
IOMMUFD_VFIO_CONTAINER to "y". Then there will be a conflict when
registering /dev/vfio/vfio. Any suggestion?

Regards,
Yi Liu

> >  	help
> >  	  IOMMUFD will provide /dev/vfio/vfio instead of VFIO. This relies on
> >  	  IOMMUFD providing compatibility emulation to give the same ioctls.
> > diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> > index 1cab8e4729de..35ab8ab87688 100644
> > --- a/drivers/vfio/Kconfig
> > +++ b/drivers/vfio/Kconfig
> > @@ -4,6 +4,8 @@ menuconfig VFIO
> >  	select IOMMU_API
> >  	depends on IOMMUFD || !IOMMUFD
> >  	select INTERVAL_TREE
> > +	select VFIO_GROUP if SPAPR_TCE_IOMMU || IOMMUFD=3Dn
> > +	select VFIO_DEVICE_CDEV if !VFIO_GROUP
> >  	select VFIO_CONTAINER if IOMMUFD=3Dn
>=20
> This should be " select VFIO_CONTAINER if IOMMUFD_VFIO_CONTAINER=3Dn"
>=20
> Regards,
> Yi Liu
>=20
> >  	help
> >  	  VFIO provides a framework for secure userspace device drivers.
> > @@ -15,6 +17,7 @@ if VFIO
> >  config VFIO_DEVICE_CDEV
> >  	bool "Support for the VFIO cdev /dev/vfio/devices/vfioX"
> >  	depends on IOMMUFD
> > +	default !VFIO_GROUP
> >  	help
> >  	  The VFIO device cdev is another way for userspace to get device
> >  	  access. Userspace gets device fd by opening device cdev under
> > @@ -24,9 +27,20 @@ config VFIO_DEVICE_CDEV
> >
> >  	  If you don't know what to do here, say N.
> >
> > +config VFIO_GROUP
> > +	bool "Support for the VFIO group /dev/vfio/$group_id"
> > +	default y
> > +	help
> > +	   VFIO group support provides the traditional model for accessing
> > +	   devices through VFIO and is used by the majority of userspace
> > +	   applications and drivers making use of VFIO.
> > +
> > +	   If you don't know what to do here, say Y.
> > +
> >  config VFIO_CONTAINER
> >  	bool "Support for the VFIO container /dev/vfio/vfio"
> >  	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
> > +	depends on VFIO_GROUP
> >  	default y
> >  	help
> >  	  The VFIO container is the classic interface to VFIO for establishin=
g
> > @@ -48,6 +62,7 @@ endif
> >
> >  config VFIO_NOIOMMU
> >  	bool "VFIO No-IOMMU support"
> > +	depends on VFIO_GROUP
> >  	help
> >  	  VFIO is built on the ability to isolate devices using the IOMMU.
> >  	  Only with an IOMMU can userspace access to DMA capable devices be
> > diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> > index 245394aeb94b..57c3515af606 100644
> > --- a/drivers/vfio/Makefile
> > +++ b/drivers/vfio/Makefile
> > @@ -2,9 +2,9 @@
> >  obj-$(CONFIG_VFIO) +=3D vfio.o
> >
> >  vfio-y +=3D vfio_main.o \
> > -	  group.o \
> >  	  iova_bitmap.o
> >  vfio-$(CONFIG_VFIO_DEVICE_CDEV) +=3D device_cdev.o
> > +vfio-$(CONFIG_VFIO_GROUP) +=3D group.o
> >  vfio-$(CONFIG_IOMMUFD) +=3D iommufd.o
> >  vfio-$(CONFIG_VFIO_CONTAINER) +=3D container.o
> >  vfio-$(CONFIG_VFIO_VIRQFD) +=3D virqfd.o
> > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > index e7a3fe093362..b27a3915e6c9 100644
> > --- a/drivers/vfio/vfio.h
> > +++ b/drivers/vfio/vfio.h
> > @@ -36,6 +36,12 @@ vfio_allocate_device_file(struct vfio_device *device=
);
> >
> >  extern const struct file_operations vfio_device_fops;
> >
> > +#ifdef CONFIG_VFIO_NOIOMMU
> > +extern bool vfio_noiommu __read_mostly;
> > +#else
> > +enum { vfio_noiommu =3D false };
> > +#endif
> > +
> >  enum vfio_group_type {
> >  	/*
> >  	 * Physical device with IOMMU backing.
> > @@ -60,6 +66,7 @@ enum vfio_group_type {
> >  	VFIO_NO_IOMMU,
> >  };
> >
> > +#if IS_ENABLED(CONFIG_VFIO_GROUP)
> >  struct vfio_group {
> >  	struct device 			dev;
> >  	struct cdev			cdev;
> > @@ -111,6 +118,82 @@ static inline bool vfio_device_is_noiommu(struct v=
fio_device
> > *vdev)
> >  	return IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
> >  	       vdev->group->type =3D=3D VFIO_NO_IOMMU;
> >  }
> > +#else
> > +struct vfio_group;
> > +
> > +static inline int vfio_device_block_group(struct vfio_device *device)
> > +{
> > +	return 0;
> > +}
> > +
> > +static inline void vfio_device_unblock_group(struct vfio_device *devic=
e)
> > +{
> > +}
> > +
> > +static inline int vfio_device_set_group(struct vfio_device *device,
> > +					enum vfio_group_type type)
> > +{
> > +	return 0;
> > +}
> > +
> > +static inline void vfio_device_remove_group(struct vfio_device *device=
)
> > +{
> > +}
> > +
> > +static inline void vfio_device_group_register(struct vfio_device *devi=
ce)
> > +{
> > +}
> > +
> > +static inline void vfio_device_group_unregister(struct vfio_device *de=
vice)
> > +{
> > +}
> > +
> > +static inline int vfio_device_group_use_iommu(struct vfio_device *devi=
ce)
> > +{
> > +	return -EOPNOTSUPP;
> > +}
> > +
> > +static inline void vfio_device_group_unuse_iommu(struct vfio_device *d=
evice)
> > +{
> > +}
> > +
> > +static inline void vfio_df_group_close(struct vfio_device_file *df)
> > +{
> > +}
> > +
> > +static inline struct vfio_group *vfio_group_from_file(struct file *fil=
e)
> > +{
> > +	return NULL;
> > +}
> > +
> > +static inline bool vfio_group_enforced_coherent(struct vfio_group *gro=
up)
> > +{
> > +	return true;
> > +}
> > +
> > +static inline void vfio_group_set_kvm(struct vfio_group *group, struct=
 kvm *kvm)
> > +{
> > +}
> > +
> > +static inline bool vfio_device_has_container(struct vfio_device *devic=
e)
> > +{
> > +	return false;
> > +}
> > +
> > +static inline int __init vfio_group_init(void)
> > +{
> > +	return 0;
> > +}
> > +
> > +static inline void vfio_group_cleanup(void)
> > +{
> > +}
> > +
> > +static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
> > +{
> > +	return false;
> > +}
> > +#endif /* CONFIG_VFIO_GROUP */
> >
> >  #if IS_ENABLED(CONFIG_VFIO_CONTAINER)
> >  /**
> > @@ -362,12 +445,6 @@ static inline void vfio_virqfd_exit(void)
> >  }
> >  #endif
> >
> > -#ifdef CONFIG_VFIO_NOIOMMU
> > -extern bool vfio_noiommu __read_mostly;
> > -#else
> > -enum { vfio_noiommu =3D false };
> > -#endif
> > -
> >  #ifdef CONFIG_HAVE_KVM
> >  void _vfio_device_get_kvm_safe(struct vfio_device *device, struct kvm =
*kvm);
> >  void vfio_device_put_kvm(struct vfio_device *device);
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index d6228c839c44..5a1dee983f17 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -43,7 +43,11 @@ struct vfio_device {
> >  	 */
> >  	const struct vfio_migration_ops *mig_ops;
> >  	const struct vfio_log_ops *log_ops;
> > +#if IS_ENABLED(CONFIG_VFIO_GROUP)
> >  	struct vfio_group *group;
> > +	struct list_head group_next;
> > +	struct list_head iommu_entry;
> > +#endif
> >  	struct vfio_device_set *dev_set;
> >  	struct list_head dev_set_list;
> >  	unsigned int migration_flags;
> > @@ -58,8 +62,6 @@ struct vfio_device {
> >  	refcount_t refcount;	/* user count on registered device*/
> >  	unsigned int open_count;
> >  	struct completion comp;
> > -	struct list_head group_next;
> > -	struct list_head iommu_entry;
> >  	struct iommufd_access *iommufd_access;
> >  	void (*put_kvm)(struct kvm *kvm);
> >  #if IS_ENABLED(CONFIG_IOMMUFD)
> > @@ -284,12 +286,29 @@ int vfio_mig_get_next_state(struct vfio_device *d=
evice,
> >  /*
> >   * External user API
> >   */
> > +#if IS_ENABLED(CONFIG_VFIO_GROUP)
> >  struct iommu_group *vfio_file_iommu_group(struct file *file);
> >  bool vfio_file_is_group(struct file *file);
> > +bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
> > +#else
> > +static inline struct iommu_group *vfio_file_iommu_group(struct file *f=
ile)
> > +{
> > +	return NULL;
> > +}
> > +
> > +static inline bool vfio_file_is_group(struct file *file)
> > +{
> > +	return false;
> > +}
> > +
> > +static inline bool vfio_file_has_dev(struct file *file, struct vfio_de=
vice *device)
> > +{
> > +	return false;
> > +}
> > +#endif
> >  bool vfio_file_is_valid(struct file *file);
> >  bool vfio_file_enforced_coherent(struct file *file);
> >  void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
> > -bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
> >
> >  #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned long))
> >
> > --
> > 2.34.1

