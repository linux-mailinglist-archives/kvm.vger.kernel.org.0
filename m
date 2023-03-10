Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24A4F6B392F
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 09:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjCJIuZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 03:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbjCJItd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 03:49:33 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4913DB32AE;
        Fri, 10 Mar 2023 00:48:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678438128; x=1709974128;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Qqi9NPuH05ETVe9/P+fO0QR6hy0CSd+I3Ms+3WYiQ9g=;
  b=FXIbhT6MGVwIWNIDBseSDjLDuF4CaJtPY5odxLFKklTMz8Oun/PYmHa5
   CSnX70DdaTWzlzADbZNCT0ek93ONb+rP9cHOiTqw8Ow3gBiWCmGEpogtQ
   klv194wqNlUzQHmXvXxiae6fpKikf2QKX+qG8DzTvTWRhw6/6W2SzaSio
   /2HO7ZwEy9KVsuDoPOr0NF7Ewo4wSvLmob4toOqi98l7hcoa9Ve40pqJm
   iAIrvt6SsV+ykQM1PqT4i+8o+I/anfX7ziJ59NvFPqXz2ebO+i1gWB6yq
   t2K3Dv5tRFOiDWqBJEluHnSg2tPN48p18qrZkV9uegKv3vi2I88aLRTIX
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="422948932"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="422948932"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 00:48:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="851836068"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="851836068"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 10 Mar 2023 00:48:47 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 10 Mar 2023 00:48:47 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 10 Mar 2023 00:48:47 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 10 Mar 2023 00:48:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EzlJhiSGLJ6F5CoUgUo1FqY8q9h1+Z1x0OM8/mtecMMBP3QJFYRvYCmRaLxdW8nAuyYcl3Q7h3CnPuS7eDGvCdz/Wtb/wQpfleRYNLN3z6CtWuNKSdWPW5e7gExZqwny9XnEGuxl6b/AhHylan5++zx3RYh77+1j7Qrt135QNZ/LjFP7mkofbvYXnl0jGL9M1WaAObIfj3zZG759VhD4RaF5ziNW08zxiVfVVDwrERkRsMbAufjQ2rOjqC0YOm0/wBHv5IIz7NYq6Cawfy5igmRvLxjzDdAnBm0pKsWbFhaZMefy55+sdjs8XwXjYRm2+mmi9S6vDZT/phHMxNvH3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JFSbFopE4eoKKwplKDV+IcC5vHq3JRA9AwcSnXxMZDE=;
 b=HtCwf1xpVhNNkV5R6RUKHvmOru2R4iD9f26wC4C5xuzAlXMCgUdJEq3WUHEKHWSsrCqIUYmbPpOjZE6RmpHMBgennUGMYg13RTs0ppRBkPhkDaQrmKn9sFTiIQRgZlFCXLgDbUTVrDod9WOpqxRrTKo8AfCqLEeEXnyjk5k8pCqxbYUspDJL+5Fdsj7iofjQUblH0ZLGDkzqbpmRWjOj2oVFh3X1LdtH0pVZrL5nPFjWvUZy/JjvTnIaYqSptLex6t0uBWZ1mip5e0GUtOZycaIl20SiXRy++IzMNDdJat1TAHT7COVUBDksK8b5GJyYrpdERUJZeikdUKJTn4gklw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY8PR11MB6866.namprd11.prod.outlook.com (2603:10b6:930:5e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Fri, 10 Mar
 2023 08:48:40 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.020; Fri, 10 Mar 2023
 08:48:40 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v6 20/24] vfio: Add cdev for vfio_device
Thread-Topic: [PATCH v6 20/24] vfio: Add cdev for vfio_device
Thread-Index: AQHZUcIMUr6jXEvwiEO/fnCvOrWOMq7ztcHg
Date:   Fri, 10 Mar 2023 08:48:40 +0000
Message-ID: <BN9PR11MB5276168FC09BFEF06E8683CE8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-21-yi.l.liu@intel.com>
In-Reply-To: <20230308132903.465159-21-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY8PR11MB6866:EE_
x-ms-office365-filtering-correlation-id: 9e6eb70b-de3b-4705-878f-08db21443f12
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +C+Mxb4bPV9zINfAtgognv/ziYLSSv1+Cy1Z2LZK+nWuoNWzMTdVXuGVB17x47S9ikfIXyvqvypRoNinynVCnbSHi1o7cR3WYBrDQVKr4XUvyqQS7BWh3NTXTti5326Inl4GUglzFSzt2Wu/rFRDdmAoajxPkwmK3diFtA4GzS2S27k5YPwaxEZVJQyaX6V0bpAFiP2Fev+T7OP2gSEUDJhqg708P5Ikngp5AGNb2C/RVP3MC8Jv6tFyW5766Sd8Q+etLCEnmGuxI+U0fTBHlcAJeUglzZ2KK0E02167DHL1m4D2Em2ep+noMKvkzlbcfhRt7Mzx4V+K8clAljuTOomo11N9PKB6A0kgMC5Bzn1Aaq4Wr+BWVVvp+27JJI+n/lRVKUaTdAJ+CNGrAvF5mcqcuX5wjYB9WSfEXIi3tW5x/0d8/k8pGklaFWAteEUTLaBhbXFRFfzu8Ek68MbpibCKTdquciQ6+XUKB3zAv5IFo/Qmt0HExlRzVMaDodcMW+pJ7OcM7nWK2nbv4M9P8zTfnqx/OIqGUvsLWWkWcBdSpRAc1ttEwV3Y9rfCk0RnT0AoXKqOuJ21JzLa5acL/TB90PACYE92xIevEOhZNVUe/NFp1s4qu+mE19iU0oBMQ5D5f5frlregSkNW5HeE6SODZrN6Jo8JffJLUoQOHRkiwTrS956USFE6c6L9VT/zLTHo5XDk0yxQ5M2y1X8ABw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(346002)(376002)(39860400002)(136003)(451199018)(26005)(6506007)(54906003)(110136005)(55016003)(478600001)(5660300002)(38100700002)(52536014)(86362001)(4744005)(7416002)(122000001)(8936002)(2906002)(7696005)(66556008)(76116006)(66946007)(8676002)(64756008)(33656002)(4326008)(66476007)(82960400001)(71200400001)(66446008)(186003)(316002)(41300700001)(9686003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?e+4Y0YQpLHfu/VrBcmjNw9i//qWq1WzNBh1BexLEOnlfxPj4ip26+zSLFWpb?=
 =?us-ascii?Q?pjqIbIJi1/Ea7UokTNNws6QeCB/QzBPs3B/G60chF/NLXH8/Pb4cvOi83jUf?=
 =?us-ascii?Q?+tqh/Xgdzf2MhZjycHZQruAsblW1opSHCmVFSGh+z8r92ixQmVukFAwzuL28?=
 =?us-ascii?Q?XDTzxHJdgXO0Haqy42ZR+ebzIEXJGVFpglNYQdU1cNmDhH6FiZ6BMFvpb2R6?=
 =?us-ascii?Q?MXgsoUHRUzcRwq2GlNmpdViRVGqyxk2ig5FE1VEMB8eZJXh1nQMz9TrsVW3Q?=
 =?us-ascii?Q?k4LDEQyqL3VL742NThY+vHatY5LRLi3fXRntxcs9n+nW+KAI57J52j1hmoXB?=
 =?us-ascii?Q?vaLSDOzVwzKo/le6zfZaj/IhuW10D5UmNS7TWi6Th5QQABhB7DUR95/8P8bb?=
 =?us-ascii?Q?3EZm6Cj9oRoESfX4bAqliQ7gznngnhwIcooAiAGnqyMoYOWg7nViSbCJ+XD2?=
 =?us-ascii?Q?pURvYD6x3Z3jw799/MHSy6h4sJfM4xIreFNDhAqKOFbKAQNTnwh1t/DBBhjp?=
 =?us-ascii?Q?kUSFI4BqhmWNkSmLNL6EjlAarZs92yYMuDOkhFeZC8qG2ucxv+NPNiZF2p2a?=
 =?us-ascii?Q?FvKCvPSZyMvbaCCQh36WQaBAba34giremRSA51DBlNuX93lKG+SPZ6juh+qe?=
 =?us-ascii?Q?wnQAXxIrmkaCSBlvCuKTtkOq5Fawan7BoB7b1K6r2vNAP8hzBl2utTfdtAPN?=
 =?us-ascii?Q?tiGaIXgIhxuOa5Wpn3RDuVdStBucRM1HbKeEDySlh2ox7Txg2g6xEkTvhhCB?=
 =?us-ascii?Q?4G+sqtf+jVSx1456l0pPFEbvSGB1rP8Qt9x3xIdksE9p4JfMHityatXhXlX0?=
 =?us-ascii?Q?ZXX7LypiQjlE9R1u5SxdPdfyTbD60s85NeU+MnZb8X8OionW0KvJq6p41GDf?=
 =?us-ascii?Q?tQyDFnJJf/8ckY4HSM8AUErLj3S5qjdSg5LbyEYVy6a3lwqMM41jc7YhSIl+?=
 =?us-ascii?Q?ekdEtUPt/sWsElT1Q3lKNgjVYuyuQ6V6EnHtv2g5xTrZ3FoLxh5CSAJtP7Ut?=
 =?us-ascii?Q?ianch6yPkC4gMcC3wtBv2gO5d9QboKFfDuthgOtr3jeKemuFE0zfzGZYLOvD?=
 =?us-ascii?Q?xIHduL5nK6UjrJcd9czF/wJDG6pfu2vaLxmuqTzqvWWmDONKYFGprHzD2TwG?=
 =?us-ascii?Q?AsR2NVLranBeq5SYPwKm/5iPbBT4LMp7V940o1PUuRLeIjB4EF8rvPSozm2I?=
 =?us-ascii?Q?Mw5nnr+eq4vaAolrG1lEQnopgZDqEVIYCwQxjLBoPjef9ihjrBetOBRk+Xx4?=
 =?us-ascii?Q?aZha8xSxfS8038dm7lQEtHUVMaOoal0UBuJDBwaFiszJSg4NauAhQyB+2uGT?=
 =?us-ascii?Q?MbHn6Mp6Gs5uV+2ttghra0vL+Hv4CwRc18T2JNMfRrE6lZ3jO6iAvOEhjzeS?=
 =?us-ascii?Q?YQNKRFnbEf4PbNMPRchZ0jOCaAgO+GJJM/89YWbS72GpyxV2Vwktb6IbNqiO?=
 =?us-ascii?Q?RNqqDxHuIJSnQZ9oeyaGopEyuHQApq8SAbrap9kK3LjfD+J1A4mY8O9V9If5?=
 =?us-ascii?Q?9VdlotroIwIeaJrBxn1h/wY/GNe1Fsbf2+eIU24NWHwGm7eZ9ks6HxTy1uPj?=
 =?us-ascii?Q?Z4beh56II2M4IzHNKx7kU+Z3fNtaq0CM4URbp3xw?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e6eb70b-de3b-4705-878f-08db21443f12
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2023 08:48:40.2416
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ijGTDuVbpZJdDaAWVdCOHzxlz2uqdJhW7yhB9IjxYhSooS4nexKv5eGF93f4mXyG1H1xdnFO62lKd+mt7QyyJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6866
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Wednesday, March 8, 2023 9:29 PM
>=20
> +	/*
> +	 * Placing it before vfio_device_put_registration() to prevent
> +	 * new registration refcount increment by
> VFIO_GROUP_GET_DEVICE_FD
> +	 * during the unregister time.
> +	 */
> +	vfio_device_group_unregister(device);
> +
> +	/*
> +	 * Balances vfio_device_add() in the register path. Placing it before
> +	 * vfio_device_put_registration() to prevent new registration refcount
> +	 * increment by the device cdev open during the unregister time.
> +	 */
> +	vfio_device_del(device);
> +

What about below?

	/*
	 * Cleanup to pair with the register path. Must be done
	 * before vfio_device_put_registration () to avoid racing with
	 * a new registration.
	 */
	vfio_device_group_unregister(device);
	vfio_device_del(device);
