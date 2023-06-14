Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1867072F307
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 05:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241575AbjFNDYL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 23:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbjFNDYI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 23:24:08 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63976196;
        Tue, 13 Jun 2023 20:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686713045; x=1718249045;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wJkpuLnNW+c12fWLkdxbm3XEBlnH+xksoaEEPmH8ob8=;
  b=g6TrlEzQ6QwfOz5Ue1ymCaAJ0uWd5qKktpQDCCwY5boBQmcJFQbcW2ME
   imi+DbhP+xmmioZDcL1U5L0V89P6iAI94lbIz2hzHYsdD729aWCxzzUQH
   ByjpYkYtoqkFqswxON38fO9o4SqiHa/w6/wE5oWyWuB4yz/vzPRpIM+tc
   LVIf9qAC9MIewZaFDeWsT6wmqKKfGuPOKzO7nR/yysmaXo9oVviAxlPev
   FFxKQN58dSvHwUpv1NeCQvfoO42Hye5uj17BO23irFPpHq/QWrnk98H/u
   KnoaNquYgYOPKT8Km3EHfJfqjv7dryJZofeNIpWIRF93Tj2Pw9aLVG813
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="338141741"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="338141741"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 20:24:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="741672478"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="741672478"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 13 Jun 2023 20:24:04 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 20:24:04 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 20:24:04 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 20:24:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mks3Tm/zI85JmPlo/rcjVKob+617Zp9dZeBsP19xHG94P0s8uY4xzx7HQtzGCaS3yq6nyEz+UWbc4QWPQAjnvQmf0rMjSsMNMgatxEqvE8lpz0tQvCfQWje/Ltc0Z60QhLvxapmufaejlD+bIlMDB9eL+XvYbM6G/wjNRVLMZbLJx5ttOgs160f3wKJwnfBO7nyvqH97wYPO7etUQ0NQ8X06Z82wHFxqi8GQCWI2URah4PaRv27f3ubOlwAmraQDcTpZs8cjappKUswM/aGWMfLj4R+tBO2o/NSgzZ5vTim4ikcPKA38RNBW6hCB3x/6nTTZl4bZ2T2PquweO2chQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+cZllLtDr5v2+whVKyzIPgN6DFlfVsYq8371dP1XtX4=;
 b=A3NcolH1iOh0XiQsxnIY03VAhcuRnJsKSDn9aGqHmLZAKohO2FIqk32A9FkmO3kUuMmpcCHh60JiVntTe/aQr4InOA80R3tk2ZgBd/Pv+dbj2v8LTN8FCu8GYJilw18CjNNeJeKaEsgybKMehZG2HaEanoHHSi2K7nm6q6Lced26i3rzRE0NKJyjlcWXUi0rHeOA88HjBVP95uC1PZzWRrYjXPAOrD9T14fRa+iwMTrqP6S9usNa+ahTQejEk4O2ZX8uzkP8CG5Gcwn+5KnvgQzCAQDnojH4a0fPJj06CgMKR7UOHcyaONya1UEF+sn2lXEjsKTNo69/1KjOSb3ZDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA1PR11MB6370.namprd11.prod.outlook.com (2603:10b6:208:3ae::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Wed, 14 Jun
 2023 03:24:01 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 03:24:01 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v12 21/24] vfio: Determine noiommu device in
 __vfio_register_dev()
Thread-Topic: [PATCH v12 21/24] vfio: Determine noiommu device in
 __vfio_register_dev()
Thread-Index: AQHZlUw5Bdx6t/Ptjk+i/O1PZ4IdNK+H07wAgAB3NRCAAI6EgIAAArTAgAAFeACAAABSUIAABoqAgAAiIoCAAAWUgIAAK4AAgABxqjA=
Date:   Wed, 14 Jun 2023 03:24:00 +0000
Message-ID: <DS0PR11MB7529F2D5EF95E9E1D63C9264C35AA@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
        <20230602121653.80017-22-yi.l.liu@intel.com>
        <20230612164228.65b500e0.alex.williamson@redhat.com>
        <DS0PR11MB7529AE3701E154BF4C092E57C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230613081913.279dea9e.alex.williamson@redhat.com>
        <DS0PR11MB7529EB2903151B3399F636F5C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230613084828.7af51055.alex.williamson@redhat.com>
        <DS0PR11MB7529E84BCB100DE620FD2468C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230613091301.56986440.alex.williamson@redhat.com>
        <20230613111511.425bdeae.alex.williamson@redhat.com>
        <ZIiozfqet185iLIs@nvidia.com>
 <20230613141050.29e7a22b.alex.williamson@redhat.com>
In-Reply-To: <20230613141050.29e7a22b.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|IA1PR11MB6370:EE_
x-ms-office365-filtering-correlation-id: 1e343e11-586b-40a7-358b-08db6c86cc10
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GFaUsdaIM1pTr9PpKK/ncpzFpVWssas8K3tKrfv4fOQ0bTKE8K5LLam8l0dRBXHg+rrAV176QHAnZ9cIOMPFJlZWUNanG6bbOPLsmrO+zzIjUf9jxjyWugUYG4cfwyY0JqOAU+jV9DVNKz6S1Kp17N8My1ZEF6TKGYLjsiT0ryG2kiAlQGQF9fq3ltbwsF5KhiiAgpbTNZEByeFPn8y4dFNrTTekTKcl1JE0tlX8o1AoHg6swIegJBSnwXrU1MBkw87pz8aow15PTHGts6g/IF/f57IJWrK0pbmxbGkqKssXx73VI35LeQ3pg0HDqPDBbRCaxSLePrStqh2oeIFiJNYIzkOecR7eBYHM0wWap6fUVUEI3GXbmW61UnzLMTNtkYZ/NTXS0JF1KkxoGAn979u93c3S7u1aDCkmdUF7zhWQO2HJ3mH8MgD4F+WmuH1jJYHTQjtd0j15P7sjcDdHSkt6cqEzSUDeHfIZjvQUTfT/MX8T0D+xmOyspAq9dPQ1v9pLfdzp+fdSjS/KOEhqNGeQsSbAv6ICUEd0pXppLXSPPENU7nnlsmU2eNhP0mFToD8c5BVJ/rwe7Nc8VjPXvLuXTXY+dhNheOn44JSJvV5Py9Mcu6uSXDZPZddWcSAU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(396003)(376002)(346002)(366004)(451199021)(33656002)(110136005)(54906003)(66446008)(71200400001)(478600001)(66476007)(8936002)(7416002)(86362001)(38070700005)(5660300002)(2906002)(64756008)(76116006)(66556008)(122000001)(55016003)(52536014)(8676002)(316002)(66946007)(4326008)(82960400001)(6506007)(38100700002)(41300700001)(9686003)(26005)(83380400001)(186003)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?a4Lyz7GdtCHNWexSKH90fQPE3IbXd/XbOMiG+mbu3TJE8RbwVMtDKvGYiK3x?=
 =?us-ascii?Q?SePtCzvkV9U0Xwbee6yviz7vEArgQ95oRzM5lQMnevm2SVQs00VhN53+tNGl?=
 =?us-ascii?Q?6SX3DTwArLF9XCaf8iVqeCcYFYTFSybBSDp1ybK6dps+zQhcgiMOh/d/rKEo?=
 =?us-ascii?Q?MpeFNpxDIAEd3XcymLQdiXH8nK3AcwIFR4QJyTBAV0D7ITi3driV70U8deCj?=
 =?us-ascii?Q?WtAda3oKkrKpxeU6pTXqwxF7UEWJApOQ7U65DVlbNqzL6yH/VaYpt/C/0A0y?=
 =?us-ascii?Q?pCXhk3elPWV+7fGR+jsDdDzYBRUmKQ5b9FY2/cNcjpDrCaJwtUb7LxN7SYwk?=
 =?us-ascii?Q?m2dmouowa07uZAFQA3HGOGWaXFOzgpXbMiom81gMqcT5ji1kckFoJSUnRo4v?=
 =?us-ascii?Q?Au+zMWBYNlKWsWBL3RQ7gwaQAwspLaZ+o4XUtWS0RwkZv7jBerpeXx6RS1oe?=
 =?us-ascii?Q?3FuFx42VZTlCbshzNqT6cZdQ9n1tdOc98KxZHcNdpYbNQ9w1Nkzy1FsrDwHQ?=
 =?us-ascii?Q?Ch/jBA/YsLLE/pvmS84MfVvVQ3JMaovA/KzyTBeT/dbuzx6FT3E4DN7N6hDA?=
 =?us-ascii?Q?/4TFDTrretfcllXT4soywWtYeB/zEOixn7+SnS2po4cyHTnSJq8Yb4fUcg0j?=
 =?us-ascii?Q?ujx/QD9A/Vob5zfHaqXl9CWKGSoA5CeY01+I9pAF7khL+7A114bL0Iig6SPZ?=
 =?us-ascii?Q?vrxnR6xVx0/bNh7MMkg4VGtExJT4unvPhVA75qULaRkpGDZSlBKLZn82APKs?=
 =?us-ascii?Q?T1yXi0danwxHV6FnfQjGmrTT4lkk5O4fN/PtEMrSw+9+r/1vDArS7qGs9cce?=
 =?us-ascii?Q?uLpv+BbPp8cd3IM53EJzhawpm+CiEsy2NT+zBoOw+jDiaQN6R6OF6vy+BTXa?=
 =?us-ascii?Q?UQK/Hg7lIXApfMDVQgbdlAUkzKVMDi22KCeN52HUIHdi4iYgdOTltiF3oRHJ?=
 =?us-ascii?Q?J1/4aN+16kn0dS3qxLVb6VjhgLE0GD5gqFLRgUUPVmRBcs/mFB0XXmu7tKVo?=
 =?us-ascii?Q?Hg1WDfUoas3xBvWZEIRL9AXm1tKOPgusGsFn13jPiXSguuwCrPoIeQ5d25jL?=
 =?us-ascii?Q?ByAOK49G6NZELYj76liindZtIx6VLwq5zDvzetq9Hv+GdEQhypKmdqqDLNG/?=
 =?us-ascii?Q?2Cv65/lUMYRB7feVtQTmPnjUDewTMgQ4QDW/Xmy2ESPjorYpdZ0hUZUTn7gk?=
 =?us-ascii?Q?raPvIc1j8yCy+P9DZT4/dPbujabWzvbFlAEVrZwHM3hj8hq0ygSO11YQ1rbN?=
 =?us-ascii?Q?QS0FEj6YmD1C9e33oBcgQpa7KMEycRyddKTzMfcpX5QR90Tq95/B2GqYJpr+?=
 =?us-ascii?Q?pG5rghKEH1PS8WMpNwnzas+FjJ6KzA6Cm2AklzBhdA/mZNKxmLWt0hruSVaS?=
 =?us-ascii?Q?nOXbBLDmlyBuQaeQZVc+Rm/SxQsOlM9TyEV3uspM1kCi2zK3dUGvEi7S/qpC?=
 =?us-ascii?Q?VvueG8ABXMCxEGCU85PylFwI6mpQhUqYvu2Bdh/lBvLJbqqShNuB7fnHeY/W?=
 =?us-ascii?Q?jcRO0pB+oAjJK9qS2rM8yH75sqL2ucG3o+kzobvOMs2aebEXW/0g9WaFKRzv?=
 =?us-ascii?Q?HwGQaRMJBpikFUisMLe52TCCyHsBC8nAeef3OPFN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e343e11-586b-40a7-358b-08db6c86cc10
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 03:24:00.7365
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1qz2/Njs3JrdXcyol7mEjrsuUSAqI3YkHwD11phfZCOwTJPyDyy3ObdnkmCFudQg8E+XAGjt6bNyuic/VlSr4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6370
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, June 14, 2023 4:11 AM
>=20
> On Tue, 13 Jun 2023 14:35:09 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>=20
> > On Tue, Jun 13, 2023 at 11:15:11AM -0600, Alex Williamson wrote:
> > > [Sorry for breaking threading, replying to my own message id with rep=
ly
> > >  content from Yi since the Cc list got broken]
> >
> > Yikes it is really busted, I think I fixed it?
> >
> > > If we renamed your function above to vfio_device_has_iommu_group(),
> > > couldn't we just wrap device_add like below instead to not have cdev
> > > setup for a noiommu device, generate an error for a physical device w=
/o
> > > IOMMU backing, and otherwise setup the cdev device?
> > >
> > > static inline int vfio_device_add(struct vfio_device *device, enum vf=
io_group_type
> type)
> > > {
> > > #if IS_ENABLED(CONFIG_VFIO_GROUP)
> > > 	if (device->group->type =3D=3D VFIO_NO_IOMMU)
> > > 		return device_add(&device->device);
> >
> > vfio_device_is_noiommu() embeds the IS_ENABLED
>=20
> But patch 23/ makes the definition of struct vfio_group conditional on
> CONFIG_VFIO_GROUP, so while CONFIG_VFIO_NOIOMMU depends on
> CONFIG_VFIO_GROUP and the result could be determined, I think the
> compiler is still unhappy about the undefined reference.  We'd need a
> !CONFIG_VFIO_GROUP stub for the function.
>=20
> > > #else
> > > 	if (type =3D=3D VFIO_IOMMU && !vfio_device_has_iommu_group(device))
> > > 		return -EINVAL;
> > > #endif
> >
> > The require test is this from the group code:
> >
> >  	if (!device_iommu_capable(dev, IOMMU_CAP_CACHE_COHERENCY)) {
> >
> > We could lift it out of the group code and call it from vfio_main.c lik=
e:
> >
> > if (type =3D=3D VFIO_IOMMU && !vfio_device_is_noiommu(vdev)
> && !device_iommu_capable(dev,
> >      IOMMU_CAP_CACHE_COHERENCY))
> >    FAIL
>=20
> Ack.  Thanks,

So, what I got is:

1) Add bellow check in __vfio_register_dev() to fail the physical devices t=
hat
    don't have IOMMU protection.

	/*
	  * noiommu device is a special type supported by the group interface.
	  * Such type represents the physical devices  that are not iommu backed.
	  */
	if (type =3D=3D VFIO_IOMMU && !vfio_device_is_noiommu(device)) &&
	    !vfio_device_has_iommu_group(device))
		return -EINVAL; //or maybe -EOPNOTSUPP?

Nit: require a vfio_device_is_noiommu() stub which returns false for
the VFIO_GROUP unset case.

2) Have below functions to add device

#if IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV)
static inline int vfio_device_add(struct vfio_device *device)
{
	if (vfio_device_is_noiommu(device))
		return device_add(&device->device);
	vfio_init_device_cdev(device);
	return cdev_device_add(&device->cdev, &device->device);
}

static inline void vfio_device_del(struct vfio_device *device)
{
	if (vfio_device_is_noiommu(device))
		return device_del(&device->device);
	cdev_device_del(&device->cdev, &device->device);
}
#else
blabla
#endif

Regards,
Yi Liu
