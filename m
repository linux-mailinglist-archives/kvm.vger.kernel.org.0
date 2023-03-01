Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9626A6DA8
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 14:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjCAN7n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 08:59:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjCAN7m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 08:59:42 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B185517CC1;
        Wed,  1 Mar 2023 05:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677679181; x=1709215181;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DRC/v1KCusR01vdUXTnQfU9FQF9z7yweETYCL7pxmEQ=;
  b=KzCJ53t9Py64XPiOku/tfFmchQWPuPOtlGlGxQwMklqlKa2h0Vus4eQY
   qlDv59SFtkPN3WXb2uq5i4O/L+y8n3S4E7NAbK6MbhnbkX503zUl5CNvK
   34I+HcJBXK1piihmFfZahpTktsIzvJNYwxlWqEd8+DSxoNjxfUyfSIPgi
   B70D9VlNjMS+R6EkvlQXllFL0hDAHb5WeUHzcBkvJe2cit9PLxdjvqc/W
   +3wMEH81Tz1f9L+qiW2fJI/NaY5WYchWW5bA18w0Uj0TQbA8VjjuuBdqA
   Pu1sD8MffRnz1A4sn12ui2ljpwYAIVpzTCxBuN++jLyOBpBQc5D5fraBL
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="334446885"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="334446885"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 05:59:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="624501970"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="624501970"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 01 Mar 2023 05:59:39 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 1 Mar 2023 05:59:39 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 1 Mar 2023 05:59:39 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 1 Mar 2023 05:59:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hC6/nBSmzXlZ76jzBy/pkv08jbMi0TmxNTjcS2j7nCmJBtz67iL/t5RRIMwwLs4KwGg9OkjcoaoIpGIXheqHjX+IO/sYaJogkvxxNS+9VSEuCz9B9t+eONKthZbzMo1XgmXxiEifeIrSSJnIKyYPJmpkM2+XPcK6Fjm9fdIobd8F4vaskh1Dk9otc+/p/z/1NdXjanRXL84hpPTOTJ3dUWrkClQ7IwGOrwXxnHH7WYF7VeGKCZDWmfAolcXRxKl4nbouO1kne9pbPWYD7sE6G5+EJ4gF5xFEr4f1fLw05PEfJxADf/TzGX7ZP/qJnxMwVDMACKk0VnrkI7s6XMVVbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ucgvxS2J5LW4U42xZo1aXDlbtcm1IxF9W7E+enw0MVM=;
 b=hAjIjwReJ7V0uJ6muhef7ed2lnLTEqnpVnLBgo8bdnhnUnlJh7qA+P4e4aZV0Ysa5i/BR91bc+S1gw9nT2BaofjzVx5wUJw08GKz5rX/EPapGE3GmX0HsoOE98BjBapHDG91EpmR7x17ogz9D/qWwIdmXuUWqNp1w7nf1Pr1Ny25NQO6Qz6H/uttEDZ7wV4gxGTdJ4DQPiaFE5dE7kep2RoE6f4qcbwxXkhMCEPIaX5h0SCZnzh6bfRjwtyT1rCAGOZkI+jqTWFQm6IqJAwdr0HxLozpLeEh0i0EthzVyy0G3U72vgrJqoBGD1R9wc7w5YBNCfHjwL/2wOM2tRlJLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BN0PR11MB5696.namprd11.prod.outlook.com (2603:10b6:408:14b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Wed, 1 Mar
 2023 13:59:37 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6134.030; Wed, 1 Mar 2023
 13:59:37 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
Subject: RE: [PATCH v5 18/19] vfio: Compile group optionally
Thread-Topic: [PATCH v5 18/19] vfio: Compile group optionally
Thread-Index: AQHZSpxOoJwf0hV6f0O8CRj2qSU0yK7j3QZwgABwRICAAal80A==
Date:   Wed, 1 Mar 2023 13:59:36 +0000
Message-ID: <DS0PR11MB75298BF2ACF857A36F3C9CEFC3AD9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-19-yi.l.liu@intel.com>
 <DS0PR11MB75296779110F91EA7648F9E1C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/31Q0KAAQITGW4d@nvidia.com>
In-Reply-To: <Y/31Q0KAAQITGW4d@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|BN0PR11MB5696:EE_
x-ms-office365-filtering-correlation-id: 09511f7d-18bb-4ee6-cefa-08db1a5d3191
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FRofCEqEdlFwvLrZRdBg2SkNveVBK5ZFlRuZEC3Cj8iqimjMUTgOc7vJ8WqA5Jkrk2ACc6f8eaSZKuYJVTWWha7Wb59u4wTndREmhyiNwd5vN9Hwmk6V47fIafpKnMyqp09bGTiItD5xsBlo11MG4G+GyahXDScPq77/kWE1xSEzQlEMWk/jJ6JlCxoJsPhNjQCBGWT4oFzHiZhHX5IoSx212/HnggnNgkYFD51Lb/9RYLs9VrvtWEpiLtK7Swml1xNFwwCITFDX2QAsS3rpwDD2B/uxbDCcq4ig2llTlmsJxwqFJSx61lZt/lqwR+L73LOir7+2QH6cqFTSuX3qMs838KeQ1BqofHk/Tx/Y8L9rlv/O1JV35uDdgFxEyLvN1bj6kSp6CNc4rkNoVTD1wdgcABHxouo45is4DRFi8bl97B9xc5p2Kg5Pis/akMbLOM+TSUs0JNhU9pmu68xTj2qMyoJeIxkcPyzyLi83rMkZLsmz+iRfoq/ZMjjBBnpN171vzP0X74OsP9k3Yb9n06uCSbNS/ziid9Y3CyIwyZqXTtVkSIQ0oSb58Z9MAjBteW8XZIx9cXdjSj5jIjTa/jTbfh1eXHAV3l4NAnK8Vax87ssYiXSpje3QOoZS5jt70Uy9UGgF8UfYYD5vtuXwKYJXalvhiXbg4nqTWyUxzuEmWY+dz3/Nrh4HBCApFevHCzEsozAQkhUnOLqgGbqTmw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(346002)(396003)(136003)(376002)(39860400002)(451199018)(7416002)(5660300002)(33656002)(478600001)(83380400001)(6506007)(7696005)(26005)(186003)(71200400001)(9686003)(4326008)(66946007)(76116006)(66446008)(66556008)(8676002)(64756008)(41300700001)(86362001)(52536014)(66476007)(55016003)(6916009)(122000001)(38100700002)(54906003)(8936002)(38070700005)(2906002)(316002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?I/3hLXnDrKEG2injmZC4mUFdlNlR63BqadBAXpaV1gck5Lvw9uuOV0q8i7rJ?=
 =?us-ascii?Q?2AIrWuN7HqOMOVJo9l/6ce/Wzaie0Da0fxWSjiaUqktGXayJsA8TDcqPjNl7?=
 =?us-ascii?Q?kaxzDN0sWm8p8VZcK49fAuPgWY0Vf9Uu31KiWxt2wrDIez50JB/7QaVGInK8?=
 =?us-ascii?Q?ivq2KHX13oiIq2HcgbSqZi+A66cEtXGGjbMcCnNZrbdA3T0rIragb9SkhSFo?=
 =?us-ascii?Q?hJauHJsc01sPmyivBkThinlxWxN6pvN4b8uOwaaTfg6L+jPREyqF75MksWni?=
 =?us-ascii?Q?EiIFYXfOQbDWemteA4jZDs5j4MmDbNk4N8+7KuAa1LE+5rEbbm0irCLO9az6?=
 =?us-ascii?Q?TcQ6w+FoRzP+Ba1Gq6ZNrFDoPMmTVFaFngFs+YepIqciFtO7ox+1hziO3Vww?=
 =?us-ascii?Q?dQDKvYyC9IGb/fyQQisHx5cOrLURKunmcg/SrSagJAcKVELfz+9FByp1deqG?=
 =?us-ascii?Q?7fnSHEdP9TkUDMCt+YCDp/yfgPqVUDPWwF87FoFjTVGwp9oLpMz4TbGn4UEU?=
 =?us-ascii?Q?tZ+AovqK7fTqEwTM+7OqH0QeWFGDapRN4O1srx+kw2181N/pMUK/fFzC6Xed?=
 =?us-ascii?Q?Z/Y1REP8U80U8HBr2K5u8frEeY6AkxppGxyAuxENZ9ZTHCj3N/TtxNNyogKM?=
 =?us-ascii?Q?2oR6s228j3+1XkFL27Byq1RJEUAcb2mTt4/jS+qkaeUwb5KGegE7gY5KEasH?=
 =?us-ascii?Q?56emeVP+2HKID2q3E8DznnWgkC/u+UXTXYGYXQ/OMwbVDy0NwDMcQ3930tZB?=
 =?us-ascii?Q?JS2GAJSxbfI7h+EykuZS7TIz0eRmJCK/sMZvLBLM4seyziAyLd4HPc5rfJVe?=
 =?us-ascii?Q?iATwh5O5WGfAlektM499aVsWSQOWMReopF7pvKpG6ygRUHGKQbw+Muk5i7lc?=
 =?us-ascii?Q?hopCQbP6oV107sGZM4JFAhG1OJ6WdrtCpHv9dK48PgbFPEUNtK3sP1NMwRiw?=
 =?us-ascii?Q?6lzqY34RJnIcS8C6/jebaFBzf4WyrPP1xV8YrIxC+lqSYaU44WLwGEJSW7mm?=
 =?us-ascii?Q?YPiJ/GKVxvERtiUpbCmXIbWH/gvOTSR45sHwhZwADTRB1MIdQGnM+qWc1Z0d?=
 =?us-ascii?Q?2Jue8+RrAxchr+vYpIR4YEJQdS3tgLH16b2RkOv5++BTHOzm9FBoZwdNQeRA?=
 =?us-ascii?Q?DptqOH0NTNKfAA0JfJZYpeqMp683dbTFFlk0ewQUzioNG9adttKvu1+ymwJ4?=
 =?us-ascii?Q?rMc47zbu10ZT7yvE67TZSfw5OnDVR7fXZefwRX6M4E2hnokohIYXL2BU0fn2?=
 =?us-ascii?Q?hw9iWwusKzfSCAjQ2SmHVNjlcFYJbgSGlMzYuvgghN+9Nnk+11vqVyus70iH?=
 =?us-ascii?Q?UGVX3rk02kArPWKyTOUUYfJ2COtJ0BgFw1Uz3ZZKnSnPevo7aFjM8sgog1mP?=
 =?us-ascii?Q?B57rsm4CAFXVb1nFR7HGZZqTzfVWwzoXBC6sUjiZwUkgPXIx50RMNYszR2oV?=
 =?us-ascii?Q?eYQKv6PU6wKym+NK75c9bGLbKu7+ZbnTnVVjkIWtFTzGy7XvlJE7cVGi7pSs?=
 =?us-ascii?Q?mY04QCgRiJIP4iCrFGSHYpXb/A2wpgFoqXo/8Zfd4u31iDExl0VhN3WZqq56?=
 =?us-ascii?Q?WtFAQPRmWG4pRMUkS1IPi9CGiWDtNVScnrkcioFx?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09511f7d-18bb-4ee6-cefa-08db1a5d3191
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2023 13:59:36.8820
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gvgibGwS0TdWqH9o3pZL5bxoebfoWW2r16B3Cux5YBVUcUSMazgXU+efl3/H3DdTBx/OENFnLMx4U46zIJLkSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR11MB5696
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, February 28, 2023 8:36 PM
>=20
> On Tue, Feb 28, 2023 at 06:00:09AM +0000, Liu, Yi L wrote:
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Monday, February 27, 2023 7:12 PM
> > >
> > > group code is not needed for vfio device cdev, so with vfio device cd=
ev
> > > introduced, the group infrastructures can be compiled out if only cde=
v
> > > is needed.
> > >
> > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > ---
> > >  drivers/vfio/Kconfig  | 14 +++++++++
> > >  drivers/vfio/Makefile |  2 +-
> > >  drivers/vfio/vfio.h   | 72
> > > +++++++++++++++++++++++++++++++++++++++++++
> > >  include/linux/vfio.h  | 24 ++++++++++++++-
> > >  4 files changed, 110 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> > > index 169762316513..c3ab06c314ea 100644
> > > --- a/drivers/vfio/Kconfig
> > > +++ b/drivers/vfio/Kconfig
> > > @@ -4,6 +4,8 @@ menuconfig VFIO
> > >  	select IOMMU_API
> > >  	depends on IOMMUFD || !IOMMUFD
> > >  	select INTERVAL_TREE
> > > +	select VFIO_GROUP if SPAPR_TCE_IOMMU
> > > +	select VFIO_DEVICE_CDEV if !VFIO_GROUP && (X86 || S390 || ARM
> || ARM64)
> >
> > Got below warning when IOMMUFD=3Dn, VFIO_GROUP=3Dn. so may remove
> > this select or needs to let VFIO_DEVICE_CDEV select IOMMUFD instead of
> > depends on IOMMUFD.
>=20
> Add
>=20
> select VFIO_GROUP if !IOMMUFD

Done.

Regards,
Yi Liu
