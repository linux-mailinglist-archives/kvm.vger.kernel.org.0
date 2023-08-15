Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3CF77C616
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 04:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234356AbjHOCs1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 22:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbjHOCrx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 22:47:53 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6914C171B;
        Mon, 14 Aug 2023 19:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692067672; x=1723603672;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vbvLFaxLJpmydqkOrihTyN7wYRAw7/co0FtG3uw7Rdo=;
  b=U+0oBx9b49P6135t9SG/CC5+g6jn5WQULI7gstrZGARqg0xtT+sir2GX
   anueRueJ4P34BxeVQRmOPFwc5/IF4hOMuE69pMZMUMRjWiFy/MymbEnAU
   +NhMhqKuTilgaH6Gpeu5D/9IGWo2sD4oZfnHLwBUmfd/evX01luZaF+h1
   8VczweQRmsHe4K1a25e+Zm6TkGZYf5dNgimA1MZgIqOpkCj5/W4nF3uo/
   FO0rtlJT0myOHawRkQF/t0EJuhJbC5CuvfH+Adc6dbnnhRaI31YGp3Mo/
   VdQd7MsP7ctzsQ/q2y7ltpL3nFIlcEzLSQJccfViJxxfCVSFRW7seUYX8
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10802"; a="351773797"
X-IronPort-AV: E=Sophos;i="6.01,173,1684825200"; 
   d="scan'208";a="351773797"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2023 19:47:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10802"; a="710568793"
X-IronPort-AV: E=Sophos;i="6.01,173,1684825200"; 
   d="scan'208";a="710568793"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 14 Aug 2023 19:47:45 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 14 Aug 2023 19:47:40 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 14 Aug 2023 19:47:40 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 14 Aug 2023 19:47:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lharqIiDT/bkgDJJBb8IrwEfRmjir21SnPSaDso0VwiD6v/b/Nyd7BwpDXuyxW/0WRKBzlT1bVZXCegwHb0h4xfNrR24CgYsgdxZY71nxn4tlT3bIqdLMySu9i1FMMQDmFm79aay+WNj0Ejb8FQLhw2v54fUlZTQsesS/ENLfln6UHEzxK1icZFAb5SsF1T7pHwW+qC9XkqaLwssH8OhrE00etZl/oh96YWqPuwn/e2gfR86OQpcgFKNstJ4sZU9aDlViIlgkCfs1tuzLtBsl0LZvyPNBW5kLMm2S+XopswVKQ7lvZSZyfhAcyhIEwZXTQ24S7LFmpYdGtaxGcljPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XE7lLF4rjdhGmjZNV8I/vj7jSuWPmcVpSXzGTBbqcFQ=;
 b=SoBWYTB0GEnVTAoJMQYfHI/Y4uDGezFetL9y3o1Q37IB/jxBqCGNgR12gUoNg9g3SfV6qMGPKPS+/l5paGV75TAQKvGwuNBmgGYhb7c4ZW37EUIifexw3RflIp8Jfx3cdwWT3qSQSt2XYahJs/sASu5Un6afeAU+RJsaCpXZAN2ZghDNPPOCypchFYMQJVIG/lKL/TSjOv3/jyloKfNqT3Hy1Pv17wQHBVtSaAWc7prCNQXeWZp+4YO/vGltqH5P3IreKl0Zrb/1YmLi9qivmzpq/sapybd3nnM0XhoWKPvUIFOWz2zERBOIDOj2XELsuQgDiAYT8E7BJf/VNZS9Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY8PR11MB7846.namprd11.prod.outlook.com (2603:10b6:930:79::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.26; Tue, 15 Aug
 2023 02:47:37 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6678.025; Tue, 15 Aug 2023
 02:47:36 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>
CC:     "horms@kernel.org" <horms@kernel.org>,
        "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [PATCH v14 vfio 0/8] pds-vfio-pci driver
Thread-Topic: [PATCH v14 vfio 0/8] pds-vfio-pci driver
Thread-Index: AQHZyXHr0cElGlfcb0Or15gC/HZ7DK/qsm0A
Date:   Tue, 15 Aug 2023 02:47:36 +0000
Message-ID: <BN9PR11MB527688FFB5206CC3150EA7958C14A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230807205755.29579-1-brett.creeley@amd.com>
In-Reply-To: <20230807205755.29579-1-brett.creeley@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY8PR11MB7846:EE_
x-ms-office365-filtering-correlation-id: a12cab30-520f-43f8-7cc2-08db9d39fbfa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n6a9LHGhmypEvvBqZPy+5jAUZmyMnmx85HRJ79L8OzZCi4IY9inpY29fdnb99TawF7zPaBY1NSDrSeGcYuQWIr1xH+2LdSdS4YTYzbEeDNQAZEyEz43CchO5iK+jCwlyt+9CiF2hn83/fCj1DQTaMJFkoz1gbhQ35YWm2AIoJfiwS8e3fc7nmE+758nT5YZ8UExkLga7hoA6zvgSfK87tmfxaN7NA9+2XhfTiAp+3f6ZgaQx6uv5KcbDsmt5bkkBceN+bdnsDzpiYssEFBw2Ud4x3BKx9PL4TROZ/euAPrKxmIKVVsgssvlzI6bT+J9Pk3nqnja4dBeDi6FgaPX2BW1CweyeO/s9UteHJJK9D8NRaG5oqnDbfsayaM8M6sOaP/jy96JAp65liF62zkgXYDxG0HMfjSEjNVDaVWX1W25T05djRAF0gI/1ugVak7gv/40Lf/aOhzE0OAaGi4UZhv6WKsZXa4ccUkjOFqgJJdLN1DPx9CuEtflSv9YcAmvkEwqp45fuGEzz4zJN7IWjftUpG2hSvZOReQzUIS3PhIPK8pe5DPjAXjulIvyna4HQN++x07/1KCsKFRWukgEkK5mXltCEz3fZ5f5MA25kPWCc/W8iXUZqK4cfSoB8wJC0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(346002)(136003)(396003)(376002)(451199021)(1800799006)(186006)(38100700002)(55016003)(54906003)(110136005)(7696005)(71200400001)(478600001)(122000001)(82960400001)(52536014)(2906002)(38070700005)(5660300002)(86362001)(33656002)(4326008)(64756008)(66446008)(66476007)(66556008)(76116006)(66946007)(41300700001)(8936002)(8676002)(316002)(6506007)(26005)(83380400001)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XB0MjfR5HJkCE8F614buSOyYQlTc0IbPjCEzPAhi4WE8vp2NOR2p2ss+zyu4?=
 =?us-ascii?Q?pYz0g68m21iSdVNKENhj6GRUhuNZe0mnE0YZGeCoHozGyWQt4omiVEw/Idmd?=
 =?us-ascii?Q?QOR2nMhueJ4UMJP+abKsTSLB8PtIE9KAX6cRN5tieSCeWtnhmxR8GCzUhYfL?=
 =?us-ascii?Q?4xRvwtcnAragMbmmzqBsax9P+RnJrBMC85qMHUKUw7aU9NT0QYRNycogcKIE?=
 =?us-ascii?Q?9lEvE4nTnMKwHrvxb+8hiZCMSv+rlUcjx0HS05irSxIVWqVD3//hyKYTSy6B?=
 =?us-ascii?Q?/kJnONILmu1b37jdkfVf6GmUKZE3tSWqBceLZ+RI+6+Um5T5CW91HKQyNHmC?=
 =?us-ascii?Q?lUo4ctJjAPxINnWROKheHtFRpQzHzWMWsemBsmft2b3EU6d69suHs2GQ+YIJ?=
 =?us-ascii?Q?QXFwAHoEnFGYZCJ5gbp20BNeh5Lzu4BhzGwR2he4g7LJdOAom+7v6/gVAQIk?=
 =?us-ascii?Q?e6M4f/tXA205oDvuo8xhJ3DewqYzwPMcsavpUlKGyhuOVvGGoOHso9tIGE6c?=
 =?us-ascii?Q?9jQn2sw4/MDPoOukaozPMf+xFWnoxReQ1i6DbXuIycwQQcBqKVcLYtOSS1BI?=
 =?us-ascii?Q?2ypsRgJ2pbRB2SqWMwvv+e17rROdAV23zl7EzsxBgvCVdL0D6A0NdFBOLl0o?=
 =?us-ascii?Q?kk180JVtg+OSofWNtzxJ+pb3tlP84SZ/ZiUgyxZon+KwG1nSzYyDRBX+4mov?=
 =?us-ascii?Q?WsfhEoB8G40ckq73VFN8C7mP7TzcziEfZMbuidGSz8VNGz30WZucI+ZXfOOc?=
 =?us-ascii?Q?jkMayVtILsFoRGek7TEcAl4mNMAUscKNR1LYGGCXfdnDZe9NnvIOXbqHzaaO?=
 =?us-ascii?Q?uvxu04rhV9WQFq/aBX6WCzSfp3r8nlMH049JhwV5zpvoAg2QcEV1vuXgKOJU?=
 =?us-ascii?Q?yiNwExn+1hGT5gMQLl9OIJvhIK3d/lwfnYsi3lfXSl+J50L8gLGnpxyQzkPa?=
 =?us-ascii?Q?js3fktNtLyfXd7WojUWwoKjnKzILmaAhEcTamghDTMXUfDUAM68BHReJqcdr?=
 =?us-ascii?Q?7JbOjHZlk94has2XyVBPwgS0ghXsX8soamkSlUTgh3Z881imfy8B4f6Qwr0B?=
 =?us-ascii?Q?VMJ1Sd2eJ/JqNhXHiybLtF+T2jgfbGFKLU54x+PtBYbU34YjOGQ4I0Ts+IQD?=
 =?us-ascii?Q?Wvezen6q8P8wwHU13vRPTDRfOZb/30h16vahX9Jso/qR6oZMtusZotGOL4Dm?=
 =?us-ascii?Q?K26be4GMgPSG3UsOZmOeqazKQCgG7Ktp7G8j57VVeZhj4O/OZIu4Wfi4LNCx?=
 =?us-ascii?Q?bHY3weVnxdTOR5+fntqTyP+wt40bObwAbNC7eOge/ST7h//mXUNLy0+0AHos?=
 =?us-ascii?Q?4nBVraY8e03abTS5PHbHbtB1lAUWJyVc4NbRxeqqqkwDk/WsINRwz6rl727P?=
 =?us-ascii?Q?H2fPSKCZSqhWtKEkFxQKkWkAUuQW6Y6qY2YnxnijDawZDofSmYAbgSu/i+i5?=
 =?us-ascii?Q?BLaD1hwdAiNqTAnZqzOiX7ntg97en/0jxaPVxaDX8/wugR1WSEpSsizMlmUi?=
 =?us-ascii?Q?tmNjc9cuHDfEpUk73oUNYCX8EENN2qoE8G1ud6B8HLqIn10TvApUqQv7v75T?=
 =?us-ascii?Q?RKiRnVaZo3L3rremOy3btBnR5Cp5TG4KWjd0/gNU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a12cab30-520f-43f8-7cc2-08db9d39fbfa
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2023 02:47:36.9231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mJMGXbjqniJXOUt7m1YFdYuZc/NFAwwxPh2uatQ6P7ZwDOc+nU9lU3/hswZ7nEHpDYYGvtr8uD7MgV7/FxrwQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7846
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Brett Creeley <brett.creeley@amd.com>
> Sent: Tuesday, August 8, 2023 4:58 AM
>=20
> This is a patchset for a new vendor specific VFIO driver
> (pds-vfio-pci) for use with the AMD/Pensando Distributed Services
> Card (DSC). This driver makes use of the pds_core driver.
>=20
> This driver will use the pds_core device's adminq as the VFIO
> control path to the DSC. In order to make adminq calls, the VFIO
> instance makes use of functions exported by the pds_core driver.
>=20
> In order to receive events from pds_core, the pds-vfio-pci driver
> registers to a private notifier. This is needed for various events
> that come from the device.
>=20
> An ASCII diagram of a VFIO instance looks something like this and can
> be used with the VFIO subsystem to provide the VF device VFIO and live
> migration support.
>=20
>                                .------.  .-----------------------.
>                                | QEMU |--|  VM  .-------------.  |
>                                '......'  |      |   Eth VF    |  |
>                                   |      |      .-------------.  |
>                                   |      |      |  SR-IOV VF  |  |
>                                   |      |      '-------------'  |
>                                   |      '------------||---------'
>                                .--------------.       ||
>                                |/dev/<vfio_fd>|       ||
>                                '--------------'       ||
> Host Userspace                         |              ||
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D   ||
> Host Kernel                            |              ||
>                                   .--------.          ||
>                                   |vfio-pci|          ||
>                                   '--------'          ||
>        .------------------.           ||              ||
>        |   | exported API |<----+     ||              ||
>        |   '--------------|     |     ||              ||
>        |                  |    .--------------.       ||
>        |     pds_core     |--->| pds-vfio-pci |       ||
>        '------------------' |  '--------------'       ||
>                ||           |         ||              ||
>              09:00.0     notifier    09:00.1          ||
> =3D=3D PCI =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D||=3D=3D=3D=3D=3D
>                ||                     ||              ||
>           .----------.          .----------.          ||
>     ,-----|    PF    |----------|    VF    |-------------------,
>     |     '----------'         |'----------'         VF        |
>     |                     DSC  |                 data/control  |
>     |                          |                     path      |
>     -----------------------------------------------------------
>=20
> The pds-vfio-pci driver is targeted to reside in drivers/vfio/pci/pds.
> It makes use of and introduces new files in the common include/linux/pds
> include directory.
>=20

the series looks good now.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
