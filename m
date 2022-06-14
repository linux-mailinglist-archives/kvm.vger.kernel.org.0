Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E740E54AE5F
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 12:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235246AbiFNKcR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 06:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbiFNKcP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 06:32:15 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE234738F;
        Tue, 14 Jun 2022 03:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655202734; x=1686738734;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QPKTMnB8uVps7X54urmGLJnx57cnpdme41Eu0QbkSIE=;
  b=cmBTpN0vQOBGgPptXWs8iWPRZbDBGeaU/0blZYr34Wek3EE2ep0i78Ft
   V1LVdhuK3zi7khdGl+ebn9cytc8X/ZtXz+c8YbOST5HkhVekF+0ePVYPV
   JKZp4OFh/wmJS3Cp8TN9C4hzzHHUJghvOq1ZnUcoLTr8pyZl9HZEo9bMX
   /+TXXGaIkLU+OH9aZyOD0x1sVJv5ZXBNRrhL5kqtwgeniOJ92yd9MDsr3
   XGAPYpKMsxFZd/QxxcxkV8zOKRyLx49YB6q11+B0Mwp4W7od9ImVTYQNv
   iV0IqBALkYna5UrY6oht3Vz2HZ2MKnp/HJAgqlBy6ZEANfiKoXCmVZO+D
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10377"; a="261607906"
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="261607906"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 03:32:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="640291351"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 14 Jun 2022 03:32:13 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 14 Jun 2022 03:32:13 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 14 Jun 2022 03:32:13 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 14 Jun 2022 03:32:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JyCu1WBXHXSRjovRCH983UxvQmxfSlvSdQtD754SuPStnyPL/BpgUMduD8jN7GE3+EQw5UWbrPsAEPL1eBGmb6IxGYvKXC8q2lUO0y5hfkyaIHG/PoxDGzIlE1MZxZPbd3pdTK4apxh+0UfnBcWBDRzKQ1QIkBYI/xWnatTlD4c+Q6t5OGZHKU0rgU0VAYza4kDkjOXO/YaMkgnsDPHi2HGNzzNE/DVEHkug4X96XQSxKuCQhdbUVBSE0oj5paRnng71qZwLJU3lGeZf0pvbVpckge+UdA5DobB0l2osVRPq/W0xv1cSm/TPGfOw8RfshLUlHXwBokZpfqbsa8xZYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=axRfZt8Gj58duZdGvYw63maRadYk/GPHouJ8eIU/5pE=;
 b=k1v183tWUa7SBR1wmSswJAWvrZzn63svpzzbQXil8gIqaQW69yCJ01Q4wfyoQA7i0dsTOIHepvuWMrsqhQRmhum5/cxUgpTKyLZWGpDbwgRlcEh9/BA2cmXsQzOTITvjrG/0JnKVJFW3PoFcA20Y7ahhtsbGHd/FwdSeK6vhYaDOGs6aKTYU4Ioiz0W/9PabW1UT4OT18o9zwVqG3CHrR+Jfp129bnlNAgU150ljrRndiYu1Hq6nIzH8kn5TfpcNNWAvuKJ9x4DrwAyLhIbFHaEiumn13P0yPdGUfLi3TSjKP4tNLxDOLqjiFEI6afAiW65gQ1BEp2N4AyPhhppU7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL1PR11MB5416.namprd11.prod.outlook.com (2603:10b6:208:319::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Tue, 14 Jun
 2022 10:32:11 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8%4]) with mapi id 15.20.5332.022; Tue, 14 Jun 2022
 10:32:11 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Alex Williamson" <alex.williamson@redhat.com>
CC:     "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 13/13] vfio/mdev: add mdev available instance checking to
 the core
Thread-Topic: [PATCH 13/13] vfio/mdev: add mdev available instance checking to
 the core
Thread-Index: AQHYf6sGj5um/s7K/EC5sPLf12L81a1Osm3g
Date:   Tue, 14 Jun 2022 10:32:11 +0000
Message-ID: <BN9PR11MB5276BB7AA39243BA5A21CFEC8CAA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220614045428.278494-1-hch@lst.de>
 <20220614045428.278494-14-hch@lst.de>
In-Reply-To: <20220614045428.278494-14-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f208e65-36df-45ca-8ddc-08da4df123e1
x-ms-traffictypediagnostic: BL1PR11MB5416:EE_
x-microsoft-antispam-prvs: <BL1PR11MB54165813162847285DF0D9C98CAA9@BL1PR11MB5416.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r19zAlAFMQoqgyP8uaHFERlEnZqTTnAUYyDxKbjfy0HfJ+BdRXubfA74wFNeL9SfA9mtad0chFHdefhR4tefecSKp7bs6UzQ3edhODEdA111fnvxuxMqqRIIXJNdJiOg0aubLLsJVy2WEc8SNaoRCPX0TCXn1WjixSwUMWbzh/heghQWytN6NieeztOECjO95WNDcxyMtlxeN0JT1GqwfmzlFV8MOPtEaoo2G5+suF0BMQXTGgim/FM1lQnRWADSpgAHq0R3334VOLZnKM29K/DGVhBq0w3Z9Pa1b6sgLHtM3SzggDc7nSmtKixtevqt3DVkjNTjQ6r37ilbc3YHqHgPSf7A7JwdFDAI7mslPjPfLwFEeVNEhiukHify60VJY0gahRvwspGVlMVnxfrkhZLJEva60kegQym+uptfJQYh33A7BrdQ46wyPdkVymHlslP1RjfELazjxPjcKv/imyhL+xg6XkeOKl149D9vowaN2/A3XD/xyOy7UWzE0ZEJXPcwpPvwCAQc1b+8Sw7x+B7pgGfCNKOfCyJyGLsjXm3ZLckzcukS3GKagIAESMnYGWflQFN3iqfXBFdWH3Msp9epb9oXfWNHwxdxugubGcJ4FS2U5U7DUucoQtvn3TsshKGiaj5JxWNz9q5zX7XaE7aqobRWatMwGU5Vm9ASee0CrMS5HC+fWi5pjxhHP0x/Tb6Oiq477+7W2JlTdB5R6crapvaKNLkTkRKEl0TkR5lOTq8xuwjuFvADTNXbEJw2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(38100700002)(6506007)(38070700005)(55016003)(33656002)(71200400001)(316002)(7696005)(86362001)(122000001)(921005)(2906002)(110136005)(54906003)(508600001)(9686003)(4326008)(82960400001)(83380400001)(52536014)(8676002)(64756008)(66946007)(76116006)(66556008)(66446008)(26005)(66476007)(7416002)(5660300002)(186003)(8936002)(131093003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qGjSFvhYRrkrGUo06jhl8ULSx4/ACqUINilDVLsFN8Lap3n9Ke24pZeETgTS?=
 =?us-ascii?Q?eByBVIoY3QVzOjq2RwElxsesReF0PAU8NmBOzvyQy30ZdE44JKgRSnN/JGKN?=
 =?us-ascii?Q?1tr9PfrOM97Y8syoeJpihAKPDBkEZCS4mnmhS3StIqzH1/Uoi/CusOPztQRT?=
 =?us-ascii?Q?X6jz6EGsVI1v0KVCic+L3cTH6mZ7UrHD17caSUb8LIyITlASUvIN1b/7DRdN?=
 =?us-ascii?Q?a74hWydeUN5+MbB9a1+C9OeYRgj8NKL5aveqRGEXshGG6BUEy/QdaVbdviXD?=
 =?us-ascii?Q?1dfWVSuTCZh6KSlo1FAgu/kfJ9bnGdJM20/nefOeK2bwRJmUBnXKperc4gmW?=
 =?us-ascii?Q?Es1vNr08tRQRD81H/RyVvF4PUrXNb8NvnFwU3B7tnffNsqEyZzS9iprJKi6n?=
 =?us-ascii?Q?w8HuuKd4koD+XqoGU/pR9O0TT7lloPmthQU69qI+1Olp3awpGGyOYhNhIvux?=
 =?us-ascii?Q?FO9Ze0ziVZqSSTO3HCv+rUF17aebP/StTkfBBTn8qlL/vNTBeVz8jKEjIADK?=
 =?us-ascii?Q?eiZ5SVha+LaFJ18nwweMLv855x29Ta1UBzslPDDEDJOHdSYDjTUrPM7gLUOl?=
 =?us-ascii?Q?q+dklbafXMOKdGCDzv+HRdudzuNshHC/ehPR2x8ougFsHtRV81iC1zkiwJNa?=
 =?us-ascii?Q?k7qFnPeaYwaoF2BNnrWpTPI3lIoojnujQQimKD26nRsk3FA9Zsj4XaOKzaHP?=
 =?us-ascii?Q?toUVf2cx6wEoFYvhRqAhpkag62yukr+UjlIadYkm55vtm+gsZS36HwHJWq37?=
 =?us-ascii?Q?FJDy4m5Sl20jINPlaPxvPUcYBb3VSq+BEylkZm91olV3pT1d2rNPzOtJizup?=
 =?us-ascii?Q?emaoibSAma7myATeNP2vewgXUoC4VAxoeub3L8VxjYZtzDtxns1ywGMIhkMF?=
 =?us-ascii?Q?WegllFxVbMJ9eRchZzXP2n2o4WeNrsMaHQ89CAafQUFnUYW2+2RFuj2Z3adB?=
 =?us-ascii?Q?PQtdQX51h4Ydu2lliN2s/xlsZ3gW5m7vWePNgbRq7Oq5HygfLrRn2Il70XRf?=
 =?us-ascii?Q?hJhfmrZ0PjrbFxZVCJqoKEBwfR7WNnw5Py55WQjIk12PTYqPy31nOL+jFwsx?=
 =?us-ascii?Q?3d5iH7HoW34jqFjo8Sh0ONHub1hiznu6THogqS23UP/NLrBlT/QVNKJQYmSN?=
 =?us-ascii?Q?X4Er2zW/WjV3mofC96KUz7Uq/W9ggH9iAGxKVEHyqtiBov7mDmKVqhD2A78p?=
 =?us-ascii?Q?uDlnQdt+88ItcfkviBATJ7OjDHlnb26oShXnyh+v0cJwCtVS+a4t29iE4Qad?=
 =?us-ascii?Q?084smYXhrKuaB9zGbqjnD/2K2/IJUymKEz5YEjY9zL0MPCADcDbYOezzPvGx?=
 =?us-ascii?Q?subkoej2zx/6KM7imO+x8GHlbuMUNI+LrajihJSUUpV+S0dAfBn06cnSrmOL?=
 =?us-ascii?Q?xr2tqTGq1xj8SSu37n/lMjzEMvC8VAr7SZOqdSJWILDacijIr/NmyUNREK5z?=
 =?us-ascii?Q?a5e2006DkJED7csRMacAQbKemffg64oXrSoxEVXSmuvu+pp3tyaHuIwISLBX?=
 =?us-ascii?Q?4bjumAxjA5WjL6tlZsWBy9qoFd66WzdP++tPERtyWu6az8vEDFI4bwdv+Eyp?=
 =?us-ascii?Q?43wJItPmKkPPPe8oKiYFvWTYElYSmjyKH6rgkcTfI+glk895fxrQksyvslU5?=
 =?us-ascii?Q?YBz26qBeK+zWu68bfs3VNWFwnNEYzp+zEvFBH6MXAy2lzapSQlzFtZ3SpDpG?=
 =?us-ascii?Q?5RNecPTwuuBtnXL4u/vPiBFwW2lzqs/u6Q/93yDLlx13f6sfNE6xXWZoaBQl?=
 =?us-ascii?Q?u0TuoBxVbA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f208e65-36df-45ca-8ddc-08da4df123e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2022 10:32:11.0631
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mAny8JbvKGexe1m3s2B+qzzQRWVYHLqUdRKeiQm4lCnLI/ahrdEbHonqFMqXuFUWAYxrBeddvZzqcXVAZM8iHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5416
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig
> Sent: Tuesday, June 14, 2022 12:54 PM
>=20
> From: Jason Gunthorpe <jgg@nvidia.com>
>=20
> Many of the mdev drivers use a simple counter for keeping track of the
> available instances. Move this code to the core code and store the counte=
r
> in the mdev_type. Implement it using correct locking, fixing mdpy.
>=20
> Drivers provide a the value in the mdev_driver at registration time and
> the core code provides a standard sysfs attribute to return the
> available_instances.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> [count instances per-parent instead of per-type]

per-parent counting works only if the parent doesn't have overlapping
instances between types. This is probably worth a clarification in doc.

> @@ -135,6 +136,7 @@ static void mdev_device_release(struct device *dev)
>=20
>  	mutex_lock(&mdev_list_lock);
>  	list_del(&mdev->next);
> +	mdev->type->parent->available_instances++;

	if (!drv->get_available)
		mdev->type->parent->available_instances++;

Otherwise this looks good to me:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
