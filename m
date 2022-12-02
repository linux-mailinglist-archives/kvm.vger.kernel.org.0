Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C946402C5
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 09:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbiLBI7s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 03:59:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232696AbiLBI72 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 03:59:28 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D8AC8D01
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 00:57:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669971451; x=1701507451;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W4IGyum3MJCMoq1QnxhaibySWrhWHY96lW6ogGdakDk=;
  b=k/gWR3cgmOyupMR3uEN1kFX0fNOcATZl6JnIQ0Q7lw/DM517pdCkt9ko
   A9qQBPLz0f/zOHyUp85qvIK16M/vAHv5Q5bhOep6Y3dE2+MV6YTP7U2IX
   bebqebkvNdNGXOi7GzuMfurOXgQ9hazoK2F/i/8RxJBb3eO8t5c6J6W5a
   1+8xJDBiNiKpzEuSXEBkGqegbscnGGAo9nZfpYB289JmBMgyMm6ymuigz
   w6NOa/lieVwJj/Voa9ruVhN+owrakZV+tO3kMfxaBh+POVtEpP6/66VL5
   N7BIoXNwslaI9dctV9zuERpUPQnKHEpZtOMfjHDNf5X0iGuN5rALT27P6
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="317058073"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="317058073"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 00:57:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="733745895"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="733745895"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 02 Dec 2022 00:57:19 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 00:57:19 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 2 Dec 2022 00:57:19 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 2 Dec 2022 00:57:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DxeAO6YVJiuLemgqHDg/PHaUlxjC7DynGjeq0MZLJT0C4HRwMXr/XZZmhWfGhKIylRPfzam6EdGmi//noX49rTpsArOeEHPLnwMcAPAvK+ZPB2yJx4E0CN9Xzewyq16sF67qbl3LS+8BG07mBCBtzXIuA0g6HkJ9q2ZkJq8a0n3AaZZsx/USDqll+8k64bURWKSvVisCNgHDJwcTE3lCyQDW//AlVdWBDwqXficBVHylJ9fgNgD+nVgzYDL1eZxRMfdnqiTNPnDMxYx5DPahFybrgmJD3l00COKuRSoXiiNJZfZSB7FKq6AMRYx3YDRAw0xH4ey5e/Bzj9vzLL6/Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W4IGyum3MJCMoq1QnxhaibySWrhWHY96lW6ogGdakDk=;
 b=JU6i2Xp/jrZOS7DGNExdtfj1YAF5t0v0cVO4Hz++vX+Zzia7qdlOkM8vg3ToF7B3b7SD+n0neRAIh2k3zTsYPcc7H7AxKZHnXWGuOXs2+f4ozQ7whPY70F0GSPTrBrC3fFgr3cPvPr5ZWqgGz5jbuTynWwK3j2xCL6JMo++DmtUBginRXeoE+zXqkJonr7t1BLjLdMmhZoCkywEoM2SVeFNlyf1PMDY4qv/VPLLPXGQi9nM6V3IA9iO2wSfO9WjbmHeHCucGh2Hk60E/gbwA4hMkvjNIXubTMfleiI/C/0NIDyOSNpuqkL2g/u8NC4l4i4/ibmqEwCjRJKqyVtiOgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW3PR11MB4619.namprd11.prod.outlook.com (2603:10b6:303:5b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 2 Dec
 2022 08:57:17 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb%5]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 08:57:16 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Yishai Hadas <yishaih@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "shayd@nvidia.com" <shayd@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "avihaih@nvidia.com" <avihaih@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: RE: [PATCH V2 vfio 00/14] Add migration PRE_COPY support for mlx5
 driver
Thread-Topic: [PATCH V2 vfio 00/14] Add migration PRE_COPY support for mlx5
 driver
Thread-Index: AQHZBZnVochDC8r+3kW9w7KHTf4wK65aStvQ
Date:   Fri, 2 Dec 2022 08:57:16 +0000
Message-ID: <BN9PR11MB5276C44FA0D38980746EC27A8C179@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221201152931.47913-1-yishaih@nvidia.com>
In-Reply-To: <20221201152931.47913-1-yishaih@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW3PR11MB4619:EE_
x-ms-office365-filtering-correlation-id: 1a3db27c-bb89-4b8c-b226-08dad4433684
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JnJRXvo22PiKVN5nS9GimkS28AeMjwZQesCvc7IFKGGkGF3Tyu4ZWacXzLc1AQf59J7KnxYBrp5WlrlSgkRja/S5TLbcJ4gCwiUydcYAww6DdY1MJocLce6ThIEKaVeUTv+AJjHXocl1SDuNphemSRZBPsivlz1J+JC0ZmPqZhrt0KiA5VoI2bkhWzjAjkROhZ8BUzqQySwKU+tM650c4mjrQEnYlAUkOi4G9KM6qQjp6gIScnxDOFfDGQVWxYpbDCG0icXA8j7AegDK0wsjB+dMh6lFvUSr4wKpVl8moIabrlCXa3SPkvZkIUtgvfMCqylSyl5NAuUAYn9GbD6nqiR1R0OTCyEUpl5vH2hon5OkaCIVZakfNmaWrGFH0a39qVof7krz2ex4+198CI5g62W8q9clQLS4tpkBjFvutIbEENg9IvhOkQ8tjClZiTaqTG7p3BrvQKnhdVBotzYaHZB4ik+RMgfrL4ae1yEejro+gJuh8iDrpsqh5fsqC5TyT03HZGznYB0Bj699ULc3FtC1VbMneH9FeOegvGZ3/9scC+4+vvEOrXCfe3DsvDsg3UzKPwh/hAgkWopo+fCJJOhBa6i6FTIRcOiWcE32ndJElAPH8lesdCkxNl3yCm3VtIMj1MiPKv2y98oMflFKJx5QHN7ke58YIrRH0dKyuzXo+9nKCY7KVj43x6vbbvmbeWdk2o8HotwLkOlTR7vAxQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(136003)(396003)(39860400002)(376002)(451199015)(82960400001)(38100700002)(122000001)(33656002)(55016003)(38070700005)(86362001)(316002)(9686003)(110136005)(54906003)(76116006)(64756008)(8676002)(66476007)(66556008)(66946007)(478600001)(66446008)(26005)(186003)(7696005)(6506007)(71200400001)(2906002)(41300700001)(4326008)(4744005)(7416002)(5660300002)(52536014)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NCTMqyQ14vUloyY1A4qmDADsWWOD7WUMR37Toyf1mA256GbNtulPtvLUKBey?=
 =?us-ascii?Q?kG+7PqiEn+rApav8Et9O9pdiIFzoiAyFNZNT4SkqGohRKJrwTUzCBWGoYiNh?=
 =?us-ascii?Q?yYG+/evNfSYFtu76AdLA+vSB5+l3/cZWJ1c7ZSGGR7W85Gxj8vrjKWbpUO35?=
 =?us-ascii?Q?npu7A11s0y1eTPsQQgmcC23TuPYVpqgBVUAXPD/VA35pHf4Zxqmjlea5f0QH?=
 =?us-ascii?Q?kCwUSQpk+NCtmWhk6yN/W1jetUZB08ql9K2XerhadtB9sdRaYTFI9Aft0xNk?=
 =?us-ascii?Q?xW6tjEjiGRqgCW1Q0VcLA0CxWmRlC5KRz7riinAANhfyPasvJMayR+jRkpJd?=
 =?us-ascii?Q?9l/Rrv7+f5B9MVX4NmTcpT/WPQmMu+YhDO0W+aQmpRHFA+BuDDXj2/cnHKK+?=
 =?us-ascii?Q?5b4lpTyOkjhyTOz6OvKJgRb/zc45v5LwTA7PauXvKxaOkJ16sNJNOd+7QbIm?=
 =?us-ascii?Q?fNhipv7ewkK10Y5Et2anSRreayS04tAUfGyWDItuE/2vtzIdhtjyKJDSvC/i?=
 =?us-ascii?Q?DwiTbwBOwfssnGblItLfgeeVs9wFCGiaHq6+riq6hAYK+vMJSnzS6E+qeOpl?=
 =?us-ascii?Q?Bz6hImASyFeiytDW62nXRx5lI8BjP3SUMoKG/Ms/0TP3muG746aQtbbYdsoa?=
 =?us-ascii?Q?tFi/BOvu7rrjrQKvCygkoCHJkOwdSKLcO2vP2t6jWgMa3EXY1Fj/ikHe+QSI?=
 =?us-ascii?Q?poO71SU6vWC1HxgIp/kXWy52AwH2arqCEn4GKQ+l6cXqMG+Wzv+Dx1oohc3h?=
 =?us-ascii?Q?9+gWFIgF7O5A9RFJWR1dpHIo6uX0n7hI3Kp9se3nayFwon5Dpz6fBrJyNAL4?=
 =?us-ascii?Q?e5xf4SxtTq92c78PQGoHEJ7iLvMByfGtg+DcxxNEYMyp3fjj+dGth5V4+Gx2?=
 =?us-ascii?Q?kG2ELWxPCUA1Qo0NfAw2CrlfCh6W4kfoNn9w+UGqp2nf3Y0PX/9SOwThfw+o?=
 =?us-ascii?Q?Dt/m4ww2V/XhO4C4kE0ja2xmmGQGXwo7YSDC4UWvhcThc6omtp29rQaEHYAq?=
 =?us-ascii?Q?XnEj/lxwtlIFc/r2zzxpBqHNLkj4JSG0Jn3IVbKX7XWyz3ej2ALG41ourf+A?=
 =?us-ascii?Q?QUHzmi5D6GadDzBy0FCOsJEoyIP4XToq0LIB/QBjvxitqCf6/pEIMGrbwpeS?=
 =?us-ascii?Q?x0dhs5poZL8xPs/cNNaMAQfEMUW8h7sQnciNL7oC94ohmH8cwTbVscqVuP1+?=
 =?us-ascii?Q?UEE6OQhSndYD3CaclJUXGX7nd+LWLoCpkdCoH4TVhKb5LBn1VhDr5tbOnPEN?=
 =?us-ascii?Q?+RgsNVpLmYpbrt1WOevK6jILKSUQtxQMysVdTqnor2vu4cS3el42V1GhZFDr?=
 =?us-ascii?Q?fQdLEh9pLA3yrXnR8YoPTrECO+GeE/Vj0Hre5fdt2Czknp9WNZuRqMyJg53O?=
 =?us-ascii?Q?p36VWlTLq0QWXzBvtznEHbwThqgXR6LPsdov8hLc9XWKfL8KGxIoCaUPeaPR?=
 =?us-ascii?Q?FGwGXDHUu3Nm62A2T8yWP/qLUhhJELB2ZAZSUZ6B/XgBhHN/kiysnXWH/tTi?=
 =?us-ascii?Q?/RyIidoIW0OT6JYhZrqe7e+n5qeHUFHhT4+L0dkKM6rQBPpcDEEMayKIFc3K?=
 =?us-ascii?Q?qAPTcxhYZg0EscuK7cy6b7+gNt9vm9WmaJwOocaT?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a3db27c-bb89-4b8c-b226-08dad4433684
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 08:57:16.8597
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MB16r3R/A5wzkZENm0PO5GqWEUGOofO3f/zfkdnQdm4pvdhgQr701Qjn/5JavBpSp1VtRe7Fp6tvFmPRXdw/FA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4619
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Yishai Hadas <yishaih@nvidia.com>
> Sent: Thursday, December 1, 2022 11:29 PM
>=20
> In mlx5 driver we could gain with this series about 20-30 percent
> improvement
> in the downtime compared to the previous code when PRE_COPY wasn't
> supported.
>=20

Curious to see more data here.

what is the workload/configuration?

What is the size of the full state and downtime w/o PRECOPY?

with PRECOPY what is the size of initial/middle/final states?
