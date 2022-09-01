Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E91335A8B55
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 04:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbiIACSq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 22:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232754AbiIACSo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 22:18:44 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED0181616A8
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 19:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661998720; x=1693534720;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=103CEDzl3FCpsN49/KUv18i8Ty1fHe+abqEOAYuJZYU=;
  b=Rjg6BrIi9sDDHqTTF51U2qJyZD7DqVZES4MCLlhPp135pB925WMPu6bT
   E68dIwxjgzt8SEHR/RVaR7z4yUvWws232UZlO5vmaYRshdcr4hK0iUpp7
   6ICBSWh9vSu6bH1f6LNOsyeUmkDdHHfRf0j5SuePUbVaoKmV7TWI6zhCF
   HE3cJ8cSyPmnPURuEM2PaDKOCQXlZP3b8JzJh6oiXjSUu5Ubo4VZJC7ZR
   wp2fmMME3H4zogd75j1GN70P/cM+YHwFanc316cYnr4d97s09L4qfNb7w
   isgQE/ItIwnpBId1BcqYyrXWkUr+mB2IWndHqQcDZooiG1kqS5nMZu2uH
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="293175204"
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="293175204"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 19:18:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="673630082"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 31 Aug 2022 19:18:40 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 19:18:40 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 31 Aug 2022 19:18:40 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 31 Aug 2022 19:18:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UcJ2/0V3vcLblPAtOP+ld40csinbOh8s0mNAcpva9TxtuQWQPI6LpZlMSS7/TLgBv1ANUzIDeFMlIHO+LwMJ7GlY/330tjTw3gQ6/8IR2778DDUClCUHlcbIEYIK/bzwpiDuQMP0zRirh5vA8O6uIue3y28HAyP63y/cD//Ek02Eu9lDssV+GUG67Z944bM2mWIWZoq4PQkr/wJo95t1U4nlzOcxYtNhyEmLfr6EMjg2A/+iFnq1lWZYN6tTKLdAb0Ykd3d4RRCCuowE9Ao//S46rPJwc5AJ3bcSbqq30S/rtNwDFzZHJoGv5bRGGkYUQwWMOlw5WKuyz9SyLwmvsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nsqzcItzcWkHf0Zy8AZtvs2RPRR3/36AKK0rHyTNGNk=;
 b=MY9sUYqsn+Iab9kTvXnpDqlbx7vj5OY/xkhv1aBrQQ/JPvk3BnUVR3Nl/GGRMKiEcOI8/SZPs0iOkpL14LSQqUPky3+xg0PZdwkx+VWyOzZOjXxd9IRBzoUymfz01UImCCUM0Ft6fWQGxbr7fF9+mZl4P4gflQ9XDhaX0Lu+Fvz0g0qJyHyJLUI3FAsH+gesTOTvh4d6ufbnhJYKNEsZfiy8V/dW/w/lHXWqhol+lWHvl4Z/VpyNbd+CYVuj2bkFGo/EqKqYXAxvOPrcZBNEiLRl/IeMjMBJq5qJqJs+SDJd9P5XkojAq/lGLsf0uSPElw7h6OHIhILEgxWg3SBnZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB6558.namprd11.prod.outlook.com (2603:10b6:806:26e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Thu, 1 Sep
 2022 02:18:38 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7%5]) with mapi id 15.20.5588.010; Thu, 1 Sep 2022
 02:18:38 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 4/8] vfio: Remove #ifdefs around CONFIG_VFIO_NOIOMMU
Thread-Topic: [PATCH 4/8] vfio: Remove #ifdefs around CONFIG_VFIO_NOIOMMU
Thread-Index: AQHYvNVUPq69b/lv8EmXj62LjeXVRq3IsxKAgABwAYCAALVpcA==
Date:   Thu, 1 Sep 2022 02:18:38 +0000
Message-ID: <BN9PR11MB5276953DA9E1D36D055858DB8C7B9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
 <4-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
 <BN9PR11MB5276255A50937E1D2C3590B88C789@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Yw9+M7qWo8aLMpb6@nvidia.com>
In-Reply-To: <Yw9+M7qWo8aLMpb6@nvidia.com>
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
x-ms-office365-filtering-correlation-id: 5bc31965-83fd-4f43-d87a-08da8bc0481d
x-ms-traffictypediagnostic: SN7PR11MB6558:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tb7LYTL1s63AesH/0HjflhaD/I9XmTGQhXVP2BXiGuM0FrmIM3D3JIUVJzxyEVc0OK6tz/3SA9P0ExN+f419TIVLL4nqudsWFg9eSJ2sQjHzNwZs3IdcVTjRkbmBiAbMm/FOWYdFnyQynvMuDs6dvP1gQuQnfNAkzLvpR6JaO5jLGGRuBMcxWM3m4QZXdqkELnmJDc7kpgxGJvTjBwLJUgNOfi0J6Gv6ZQi7EJwBOQjGd5CYh7Wmfn+5hzApHXjzogbCdvUgPuGp9PkoHg44tsCRYjbnfa3nmW96s9pd6JxPy20DnnqxQVF3knTumObrGvSixO3Go9LTJOk5kS3BtaJ/QU0LM3Q8Fllfwb/4BtBENTkEKSkJ3ZImeG4bKp5Frvs7xHltIgdgVBFWamOY1fKApKARxFLvk0TCGjYzIEhpHKoGFMp+I1sv2bSpuPkKAma37BL6SIV8C8OCYAfxVNql7QPMJb3fV+0yK14E3CS7SbYYYHmRyIpdlSfdOFd8dqwLfKUzZ9H1uuZXIxcIxWuku+100rBpPhiSOi6t0cxdibaE6awul04mf9CKq4RL9amdCWczsHmlMvioC0Vz+D9m/3uc/Y3t7K1Qc+kIvZs4tiFa00LAJ/Df6vXl8Xl7nCmO4eRpPWniX4mAYlj1hrSnoVghcfB9x2Ng5JygTIn+c29k+KZvFJLudsFC6AJKZgc5NuZLvu3NMdT+1IOe3vTLsTDdnU3IY7Fe3AoNzouAZWGTc31CJ686QYFf0vqEixqWrzGGGLFtMZPugGbPYw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(366004)(376002)(39860400002)(136003)(41300700001)(478600001)(7696005)(26005)(6506007)(71200400001)(2906002)(66476007)(66556008)(55016003)(66446008)(82960400001)(66946007)(33656002)(86362001)(316002)(54906003)(6916009)(38070700005)(9686003)(122000001)(64756008)(186003)(5660300002)(8936002)(52536014)(76116006)(8676002)(4326008)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tW5x1BgSATqOgI+BuG9lI3pzHpqXUgmJW1ySjBuVLx/YTeJ8muY/GvdermBg?=
 =?us-ascii?Q?3n26sNsh0a/IHiw2PeCp+tfxYFbxOGBq3GHVtcSp41e7jr/2rAjnM1hTokUR?=
 =?us-ascii?Q?A75NS2gXKrsvDuDrbSJAksugCqrhma4stQoN0psqR1Sqro+v4YF1T+Qa9drl?=
 =?us-ascii?Q?rV3Y06Av6flpsK5hVfcxxyPDyeC+EdXqK2xWySpSUVDgvG3tUF0wknRotZt+?=
 =?us-ascii?Q?k8NnBLgJahv1ANKXuA8xLyTupy8kCrnMEpqnKWhewJuzCOuzdbiMy3uzH4ga?=
 =?us-ascii?Q?L6UG0DDXpu/Lqq+wL3TAgECkU3p1ubY0MrM4POzRS+yHEMZx/BEW9RrBphsB?=
 =?us-ascii?Q?efy+733RZaX670YGrDx7MXQ4iGGu0TmOQQjnvpD8GAGNsxdLSX9PTiHXC21U?=
 =?us-ascii?Q?52G7QM9PYNaPiwOQs0LtfhV4Ctixc8PdLJWKO9+KxrrRx5S4AnS+tFsVg/lv?=
 =?us-ascii?Q?2gnQPsj3dZv/lC71MKmLKF/hYDgK8lu7VzXAhurzIe+qMdTT0NtcAJrX1JAI?=
 =?us-ascii?Q?3ynmm52+zjMWkzxaOKeQUX+JuslawZFfjRKSiqfWPePU0ppYRxRRzFzHWsjQ?=
 =?us-ascii?Q?zfIF8H2Edwft+JJCc5oQYaD+Ftsvlat7dpaI6GYSwN2Rluxb44vgqXr+dQ1X?=
 =?us-ascii?Q?O6kMRAzixHV40vxo2L6S9OfRVYhXOwDHgfwJglsrtIXsY5j7HWcKTOWyjURP?=
 =?us-ascii?Q?fI+8z84WuqpGcNyaoGQBy00Bg9P1C6uMqURwRvgpJHX+YFMA9djltp/vd601?=
 =?us-ascii?Q?ApHBKI8bmBKi+/1eOt7MmMX2+3oqy6V13maN89hScrpKlSKrx5lKaYdS9FNS?=
 =?us-ascii?Q?myRqkfXK7ff0SOppkSvDTT6EcYme0des+Lt4HFz9ddvBYcpzRlS/6gzWWpbN?=
 =?us-ascii?Q?mObGv+pmddJdBHSeSUcrk5jeo9fYvhsuz3HC9P4y3L8/Yl9FCJAoisgOVcac?=
 =?us-ascii?Q?o+Wt5b93xqL4tVpO8EmzwMZxo53tW0P4YbMIF/zHdsDnkCx6yHwd1QziHAcZ?=
 =?us-ascii?Q?OcCZnEf8J1MGIesu9Zp/5BILqdXAYUkHURpwmW+8iRk0FDCh32Yp6oOQ9Jyu?=
 =?us-ascii?Q?v27cICm/1bTZKw5MH1z0x7PZFvT6q3g6ZQSCj13d+T4mn2Avbopv3JG454NT?=
 =?us-ascii?Q?hq1lEJKi9K7Wyom1XmGm52zoMSXwHgxMe9GcThvA3uIjRnA+y7uwCiJS/uUy?=
 =?us-ascii?Q?QEbGwH1F0PotSGhLNVKprjssgI0kDCCP1KkYi4eX/oNOTK5/C/N8JUPBZths?=
 =?us-ascii?Q?58azsskDWWvxLHD54EqeGWnlGt2NfYfaJQXIOJSGrWzLYYZFOfYRyWM0ttPX?=
 =?us-ascii?Q?5o4E1evwR+rbesPqJqqHqvecs/cph9i+IO9Asf737wpzrhw1hkCysmOv6pzh?=
 =?us-ascii?Q?/JpWbJW5uBRThGCyV1yAmMmDf4JIDBqQyUAmE6SSXsf9TvRG3d/K1/FIIsc0?=
 =?us-ascii?Q?nejrJSj/Tm5ZGFB0tGdJIJ7pfCU39zgbjHArAYf9us509d1Ljhhjucnyeoca?=
 =?us-ascii?Q?uxxio5L31o80/Q0+nGZUjSvcA5Ayvef6TrQhdIQAqDw2TeQhSrL+bAJQAHdb?=
 =?us-ascii?Q?IMpuPNkAbTOly+xklXuTiCU88pfbtWXQphUSG46i?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bc31965-83fd-4f43-d87a-08da8bc0481d
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2022 02:18:38.5618
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m7OuSADv8S+A90491h/0Tfh6scSfIokmwgRfdI5CyQ1I7HPHmcX67ygxwlLz+MMkEKoGO8H7f6VSTgsw8ZlYvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6558
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, August 31, 2022 11:29 PM
>=20
> On Wed, Aug 31, 2022 at 08:48:55AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Wednesday, August 31, 2022 9:02 AM
> > >  #ifdef CONFIG_VFIO_NOIOMMU
> > > -static bool noiommu __read_mostly;
> > > +static bool vfio_noiommu __read_mostly;
> > >  module_param_named(enable_unsafe_noiommu_mode,
> > > -		   noiommu, bool, S_IRUGO | S_IWUSR);
> > > +		   vfio_noiommu, bool, S_IRUGO | S_IWUSR);
> > >  MODULE_PARM_DESC(enable_unsafe_noiommu_mode, "Enable
> UNSAFE,
> > > no-IOMMU mode.  This mode provides no device isolation, no DMA
> > > translation, no host kernel protection, cannot be used for device
> assignment
> > > to virtual machines, requires RAWIO permissions, and will taint the k=
ernel.
> If
> > > you do not know what this is for, step away. (default: false)");
> > > +#else
> > > +enum { vfio_noiommu =3D false };
> > >  #endif
> >
> > what is the benefit of enum here?
>=20
> It means we don't have to use #ifdef to protect references to
> vfio_noiommu. Do mean enum vs #define? I prefer generally prefer enums
> as they behave more like a variable.
>=20

Okay.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
