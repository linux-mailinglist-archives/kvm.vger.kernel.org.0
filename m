Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E897D650C
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 10:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234083AbjJYI3B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 04:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234231AbjJYI24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 04:28:56 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA78C12A;
        Wed, 25 Oct 2023 01:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698222534; x=1729758534;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gDGkSrd4jcXqe4qCaZAZbNqQCwu2mj5AsNRQTI62tBk=;
  b=lxiRC6XUGSM9f3OrdHzrurqOg5+h3+TrYCamKDk5srUjNxKOTY5pfdcD
   thz68V4tN2rPwZ6zpPpqcX0/V2Kh6TBRvH/eitYkEtv+d+eT/UCOeg1Fd
   2W2rGiksk0pDcOwt/q2nmpy8Q3rs0D7/13E4EQ5JYg5dwe2EcWYHdJLSU
   xECDoZPKrPoA2iBCRqAGmcgEGeoXa0ci5bs1M11V+gi5w69BBH8uYdTiE
   FArrzjPbJtfYLJAQv6q56rqFiRTGdU/nkRnqLxPmSNWA5UIpoPO1k7jYb
   yhwS2s2b60V/cjJMyVgJYgSBNk3nGWekAJx2CeG/nK4zocpzCPr4cuTWf
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="453737050"
X-IronPort-AV: E=Sophos;i="6.03,250,1694761200"; 
   d="scan'208";a="453737050"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 01:28:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="762380304"
X-IronPort-AV: E=Sophos;i="6.03,250,1694761200"; 
   d="scan'208";a="762380304"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Oct 2023 01:28:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 25 Oct 2023 01:28:53 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Wed, 25 Oct 2023 01:28:53 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Wed, 25 Oct 2023 01:28:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OfluVuplc4F9Y4947y5IheMgPzBwuru3eRlounETfY2QfRn31v/5r36TVjLsKfftXkned038YqCgjGT790suRZYymoN8o6AqFYnSxx9VjCXxq3nNn9ohOlNgGd1Pse86zIozgD6xwInqKLgAwr6wHCDT4iVkrk6jWzGDEu6QYqZJTS3QR4HVH1NQpUjGCnFuauyyvbPVGmW0BCbfBnc6A0Gi0zxxmp+ZL8/XpbSz6EypeCsCwExcZyIcEzwBVDKeF6tqxy0FwWrLJEEKp/royg/gOsXy8NwCcSYJ9jpwGuNxPOq+nuIt+IJMD+920wGc5Mcf65AHMuuqp+W/p0JkTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gDGkSrd4jcXqe4qCaZAZbNqQCwu2mj5AsNRQTI62tBk=;
 b=YiMPBQqlRHhUQdS1+hVLKT4IVg7jCH7uUGziqfo0Iu5dP77HpolZkNC0SUzbwhPMKkKk21UNhVcUptEq8T0Ic9YzOoG8nWlrlNKPy4+2HrMvY+ZEC7Kosza83xWI4jcEYCQ8JxqGaKgZ/WdrsdJjhHLXQJzSZG6a7Sgzoz7HuYYifOgBOYM3Wd2t+N8nwGaisnhFJbPdb9plnuJ4sgC92UiF9MROp+Hd4NnhSWfQ52+1r4n/9S1q7QeuOvqpyY7AavaUoCWvhDMj7L4a/ax7LCdgGR7ulYr3NDF9jhivsdeDouVvVvvyHrkth98TS8TIYF2G7E48teRSBqH/ZHfsMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB6446.namprd11.prod.outlook.com (2603:10b6:8:c5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.31; Wed, 25 Oct
 2023 08:28:45 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.6907.032; Wed, 25 Oct 2023
 08:28:44 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Ankit Agrawal <ankita@nvidia.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
        Vikram Sethi <vsethi@nvidia.com>,
        "Currid, Andy" <acurrid@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Dan Williams <danw@nvidia.com>,
        "Anuj Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v12 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Thread-Topic: [PATCH v12 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Thread-Index: AQHZ/4UAiVeDSSetRE6jD5b3WusvvbBOmsSAgAjEmwCAACAVAIABhzeAgAAHHwCAAStocA==
Date:   Wed, 25 Oct 2023 08:28:44 +0000
Message-ID: <BN9PR11MB5276A59033E514C051E9E4618CDEA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231015163047.20391-1-ankita@nvidia.com>
        <20231017165437.69a84f0c.alex.williamson@redhat.com>
        <BY5PR12MB3763356FC8CD2A7B307BD9AAB0D8A@BY5PR12MB3763.namprd12.prod.outlook.com>
        <20231023084312.15b8e37e.alex.williamson@redhat.com>
        <BY5PR12MB37636C06DED20856CF604A86B0DFA@BY5PR12MB3763.namprd12.prod.outlook.com>
 <20231024082854.0b767d74.alex.williamson@redhat.com>
In-Reply-To: <20231024082854.0b767d74.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB6446:EE_
x-ms-office365-filtering-correlation-id: a0d4af6d-d7d1-4bc9-2e13-08dbd53466d2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nP8VIFVD/oSCEkiZqqaKf2IGl8hiZqsMxRGyZWZUT9blrBnb0QK7kztQUKL29Ar8fkEdTqB5zZrJcefE5vHaU4+lbRmaZUtCzLHFhAinkfyhO2y3g8Oqh6y2PitM+Mej36ZWk2P42QLhK7Pnx4K9ZHxemBeUT3MEHQ1EtcBjUQAkk42b5rENjq0NQeC4IZR74lLjje4p2o2wPCbZq6Q+4Lfew2Ptf0jC15E2e4fAxiDZDMeSj9JgBwH/T6fDM+Q/34pBWgGikybjYHp2708SxylR/Iu9WIpxg4JeJkTGKiesO0ooq40gPQzgqbt/EzeQilVECtSNM2qx18WOuH73TLPfgpQqa5iUwTS34ouUZ3v1U5YfX6+xF5/7ye0NKfZD4P3DREQ4GGL3v1zpjsiLyBo/lGsLo61bE2l44ZeDQLBjBK0BgvsViJXBerGoYS+mWPWD0MZ8EBhTUx4ukXQu8kvp6t8gijuE6ETfgknI+G0gBOvqdpmUX7eoJUPwGFNJIf2eZbgOqLYOOhwwQ7vYRZ3TUzq3gnlpLvgiGMAorrb8IXu8nfmOaE9XyCWSw/mwikx0UhiDQQbX3l2n7BucgRVsfUOTzL+yli+Uo+F+b/E46oqKx3hdtZvPTcf14i6h
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(136003)(376002)(346002)(396003)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(55016003)(66476007)(316002)(86362001)(2906002)(38100700002)(122000001)(110136005)(66446008)(76116006)(66946007)(66556008)(7696005)(71200400001)(478600001)(6506007)(82960400001)(9686003)(54906003)(83380400001)(4326008)(52536014)(7416002)(5660300002)(33656002)(41300700001)(64756008)(8676002)(8936002)(26005)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cGtVN281SUM2UUZPZW4vVnN5SXZJNENzTUd2cEx1RU5JWmpscVVkREVmRjIr?=
 =?utf-8?B?YXhTN0g5ZFAwbGpYWnZpM1l2RCtTSEI2NmdWNlI0ZGM1aXpFY2RKQkdVNUp1?=
 =?utf-8?B?ZmFNZWtqdUxDQmdmL0g2RDBXdlMxU3Z2L0ZGMytDT0hSaUp6cEtReW9hZG9q?=
 =?utf-8?B?ei9xcVFvSHBjOGV4Wk9PL0h1bWs3Z2o3OXpNWlBML1l6V3JnWEhmMUdKZ1lL?=
 =?utf-8?B?aEZCVmo4YTF1dTk4MG5RWXA0ekJCSllHQ21qWnFKS2xXT3J0MDZ1T3VYY2Yx?=
 =?utf-8?B?TTJvODM4ZjJvUU43aDFwTkVSZjBhaU9wV3lnanNEZkZWVWFMdTdEbjdCT3BU?=
 =?utf-8?B?SkRweTFDTGpnelhLQVVPNE9aRmZHb0xRQWVKcjc3ZGVIYUFIeGZ1MzNBeVF1?=
 =?utf-8?B?UDBJWW9RclhvaEdHRDByMGRtR0VKT0ZBcFk3TnJ6cDd5eGxjUGZnc2NFRk5L?=
 =?utf-8?B?YnRJT2VlTG5vbjdSWExkTGdkdlBZQmdiZ1ZlcXR2VGd5eGtzdXBVK3JqUVVn?=
 =?utf-8?B?dHlpLzMwaCtBU1VURE9kRVNoaHB3Rll1VnFwSU5xZDVFU3VHRnFtTXpaVlls?=
 =?utf-8?B?WUNyQ212NUsyUEtaN0FIRXVSaDFQSlpodnVFMVNhakMxaTdBeS9jbUt2RXZo?=
 =?utf-8?B?QjRTZEJydURyRkZWaG5HRyt0YXpvNXcxTHZ0RzkvdWVGeXZ1dC9pN0poQlly?=
 =?utf-8?B?dU4zcGhrZ3lQbUxnTDUwWmthVEhjcDlEbDh6ZlFLK0dlUG55MjZqbHZkYXg1?=
 =?utf-8?B?T2RZdWJydWtRZUR1RnhYOGJmV1I1NytVVzNlS2N2MFBTL2o4THI3QkJLL3FX?=
 =?utf-8?B?SWtydmttQUdhVCtCd3A4WFZ5QWhOTGp4Umc1TmtmZCtWandxbjdSeHdkMzFs?=
 =?utf-8?B?QmxZNCtBYVdOelJZMm56TnFzR2tPZVlBS1pPbGR4Nk1XM3hrYSsrWithNlpX?=
 =?utf-8?B?cWdCZHZKMnorNm15dkNjaFFqbkg1b0FVaVBBM3ZtNXNGRWpwTndLYW93cGpG?=
 =?utf-8?B?UzZRV3RSWmdnTGJCVzhVd0FISk55eFB1UEZNdmNWWE1jNVhkN0tZOWRkMmRT?=
 =?utf-8?B?c0hqaFRaOW9qWWZ4dVNTbllobmVBdFNQaVczWXc5aExvekFYbWtISFAwcjhD?=
 =?utf-8?B?VU1iSHFPTTloMDdmbDNHbEgzR1Ivc3QzeHZFZUY1ZUJXS1FXZ1lCaVd4Y1JM?=
 =?utf-8?B?ZWozZU0wYzhiMmpKQWw4NHA0TWFXSTMwZmphQmRUV1Q4Si9JVENJQS9pd002?=
 =?utf-8?B?R2ZVMFU4ZnhRYnQ1YTVLQ3B0cUlUMUJaTXRHL1I0ZzEvWkcyWW40eUVnVlF4?=
 =?utf-8?B?blFKZjVaQkErNldqSU9LWlV3WXhtWTZiN1loVWVPMFNZdG03ekVYR3pqZXNw?=
 =?utf-8?B?dEIvaEhrQllUWW1tNlpTWDhyYXVNaVhkUERKU3N2K2lpTjByTExtWnR2QVRK?=
 =?utf-8?B?YUR1d1JQTUdjc1l0cTFVZWFueGRFUHRSQlJaSG1zcS9iUDZjbmIvSEVYU1pG?=
 =?utf-8?B?a1ZtM2w5a3ZTMk5VWFRVQ0lEWDg2RTNkcEFDTm1OM2x6OGJ6YzU0U1NuT2Vs?=
 =?utf-8?B?NWxhTlBsTEg1ejNwMC9KZTJ3aVJVM1FLVkxnMlhFUXlkRVZDTDFlY01vUWtO?=
 =?utf-8?B?Zlp3N2tXZEg2cmxjRmd2cXBNNFQvWFNiMytPZ1dXWUUyTlcvaXEwOFY5OVE3?=
 =?utf-8?B?d3FqRUx6K2Q4L0ROOEZrMUh2bUsrci9ncEd1WSt5SmhuMTFkR09xOFNGQmM0?=
 =?utf-8?B?VENvYzM1OVVKS0x0KzE5ZVhzTGdJYmIyZDZtQTFwZ0RVZitpbGpZVTkzYUFM?=
 =?utf-8?B?WVo5L29TaDZwK3BqTHM0Y0tKU1pSRmowMTVwRXdVeGh0c1BPRy9KU0l2aVFx?=
 =?utf-8?B?Qjh4TFk1MGRvWm1XbmJ6dnNFT3AvV0RIanJtOWxTcStwZjdlZXFIbDVjNTQ4?=
 =?utf-8?B?SVdZMmlza3pLdlliL1UvSUlDaVdHVHVHS2U0cXZLdTFiQURsTHU3ZFRzOWFX?=
 =?utf-8?B?ekMxKy9JUExOdGdxSHYvTTN0Y0pSenRmRjFOZE5GTFlYS0xWTVlaUWc3bGUz?=
 =?utf-8?B?ODI0STk4dVo4VitFcE12V1ZNQzJnUkNHRXNCaG1rVFZYQjUxdEJQb0pMdlZu?=
 =?utf-8?Q?wSojMb3xzL2BxJKEgP4tWIBNx?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0d4af6d-d7d1-4bc9-2e13-08dbd53466d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2023 08:28:44.2958
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CJ/FYUovfZWqmZRSme7Ya6NX4R3PCTbJoq1eOnMenWygfyqJqXVMb33uF0u0FYGYj0YG3A/zYmO9q037hUo3Pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6446
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBUdWVzZGF5LCBPY3RvYmVyIDI0LCAyMDIzIDEwOjI5IFBNDQo+IA0KPiBPbiBUdWUsIDI0
IE9jdCAyMDIzIDE0OjAzOjI1ICswMDAwDQo+IEFua2l0IEFncmF3YWwgPGFua2l0YUBudmlkaWEu
Y29tPiB3cm90ZToNCj4gDQo+ID4gPj4gPiBBZnRlciBsb29raW5nIGF0IFlpc2hhaSdzIHZpcnRp
by12ZmlvLXBjaSBkcml2ZXIgd2hlcmUgQkFSMCBpcyBlbXVsYXRlZA0KPiA+ID4+ID4gYXMgYW4g
SU8gUG9ydCBCQVIsIGl0IG9jY3VycyB0byBtZSB0aGF0IHRoZXJlJ3Mgbm8gY29uZmlnIHNwYWNl
DQo+ID4gPj4gPiBlbXVsYXRpb24gb2YgQkFSMiAob3IgQkFSMykgaGVyZS7CoCBEb2Vzbid0IHRo
aXMgbWVhbiB0aGF0IFFFTVUNCj4gcmVnaXN0ZXJzDQo+ID4gPj4gPiB0aGUgQkFSIGFzIDMyLWJp
dCwgbm9uLXByZWZldGNoYWJsZT/CoCBpZS4gVkZJT0JBUi50eXBlICYgLm1lbTY0IGFyZQ0KPiA+
ID4+ID4gd3Jvbmc/DQo+ID4gPj4NCj4gPiA+PiBNYXliZSBJIGRpZG4ndCB1bmRlcnN0YW5kIHRo
ZSBxdWVzdGlvbiwgYnV0IHRoZSBQQ0kgY29uZmlnIHNwYWNlDQo+IHJlYWQvd3JpdGUNCj4gPiA+
PiB3b3VsZCBzdGlsbCBiZSBoYW5kbGVkIGJ5IHZmaW9fcGNpX2NvcmVfcmVhZC93cml0ZSgpIHdo
aWNoIHJldHVybnMgdGhlDQo+ID4gPj4gYXBwcm9wcmlhdGUgZmxhZ3MuIEkgaGF2ZSBjaGVja2Vk
IHRoYXQgdGhlIGRldmljZSBCQVJzIGFyZSA2NGIgYW5kDQo+ID4gPj4gcHJlZmV0Y2hhYmxlIGlu
IHRoZSBWTS4NCj4gPiA+DQo+ID4gPiB2ZmlvX3BjaV9jb3JlX3JlYWQvd3JpdGUoKSBhY2Nlc3Nl
cyB0aGUgcGh5c2ljYWwgZGV2aWNlLCB3aGljaCBkb2Vzbid0DQo+ID4gPiBpbXBsZW1lbnQgQkFS
Mi7CoCBXaHkgd291bGQgYW4gdW5pbXBsZW1lbnRlZCBCQVIyIG9uIHRoZSBwaHlzaWNhbA0KPiBk
ZXZpY2UNCj4gPiA+IHJlcG9ydCA2NC1iaXQsIHByZWZldGNoYWJsZT8NCj4gPiA+DQo+ID4gPiBR
RU1VIHJlY29yZHMgVkZJT0JBUi50eXBlIGFuZCAubWVtNjQgZnJvbSByZWFkaW5nIHRoZSBCQVIg
cmVnaXN0ZXINCj4gaW4NCj4gPiA+IHZmaW9fYmFyX3ByZXBhcmUoKSBhbmQgcGFzc2VzIHRoaXMg
dHlwZSB0byBwY2lfcmVnaXN0ZXJfYmFyKCkgaW4NCj4gPiA+IHZmaW9fYmFyX3JlZ2lzdGVyKCku
wqAgV2l0aG91dCBhbiBpbXBsZW1lbnRhdGlvbiBvZiBhIGNvbmZpZyBzcGFjZSByZWFkDQo+ID4g
PiBvcCBpbiB0aGUgdmFyaWFudCBkcml2ZXIgYW5kIHdpdGggbm8gcGh5c2ljYWwgaW1wbGVtZW50
YXRpb24gb2YgQkFSMiBvbg0KPiA+ID4gdGhlIGRldmljZSwgSSBkb24ndCBzZWUgaG93IHdlIGdl
dCBjb3JyZWN0IHZhbHVlcyBpbiB0aGVzZSBmaWVsZHMuDQo+ID4NCj4gPiBJIHRoaW5rIEkgc2Vl
IHRoZSBjYXVzZSBvZiBjb25mdXNpb24uIFRoZXJlIGFyZSByZWFsIFBDSWUgY29tcGxpYW50IEJB
UnMNCj4gPiBwcmVzZW50IG9uIHRoZSBkZXZpY2UsIGp1c3QgdGhhdCBpdCBpc24ndCBiZWluZyB1
c2VkIG9uY2UgdGhlIEMyQw0KPiA+IGludGVyY29ubmVjdCBpcyBhY3RpdmUuIFRoZSBCQVJzIGFy
ZSA2NGIgcHJlZmV0Y2hhYmxlLiBIZXJlIGl0IHRoZSBsc3BjaQ0KPiA+IHNuaXBwZXQgb2YgdGhl
IGRldmljZSBvbiB0aGUgaG9zdC4NCj4gPiAjIGxzcGNpIC12IC1zIDk6MTowLjANCj4gPiAwMDA5
OjAxOjAwLjAgM0QgY29udHJvbGxlcjogTlZJRElBIENvcnBvcmF0aW9uIERldmljZSAyMzQyIChy
ZXYgYTEpDQo+ID4gICAgICAgICBTdWJzeXN0ZW06IE5WSURJQSBDb3Jwb3JhdGlvbiBEZXZpY2Ug
MTZlYg0KPiA+ICAgICAgICAgUGh5c2ljYWwgU2xvdDogMC01DQo+ID4gICAgICAgICBGbGFnczog
YnVzIG1hc3RlciwgZmFzdCBkZXZzZWwsIGxhdGVuY3kgMCwgSVJRIDI2MywgTlVNQSBub2RlIDAs
DQo+IElPTU1VIGdyb3VwIDE5DQo+ID4gICAgICAgICBNZW1vcnkgYXQgNjYxMDAyMDAwMDAwICg2
NC1iaXQsIHByZWZldGNoYWJsZSkgW3NpemU9MTZNXQ0KPiA+ICAgICAgICAgTWVtb3J5IGF0IDY2
MjAwMDAwMDAwMCAoNjQtYml0LCBwcmVmZXRjaGFibGUpIFtzaXplPTEyOEddDQo+ID4gICAgICAg
ICBNZW1vcnkgYXQgNjYxMDAwMDAwMDAwICg2NC1iaXQsIHByZWZldGNoYWJsZSkgW3NpemU9MzJN
XQ0KPiA+DQo+ID4gSSBzdXBwb3NlIHRoaXMgYW5zd2VycyB0aGUgQkFSIHNpemluZyBxdWVzdGlv
biBhcyB3ZWxsPw0KPiANCj4gRG9lcyB0aGlzIEJBUjIgc2l6ZSBtYXRjaCB0aGUgc2l6ZSB3ZSdy
ZSByZXBvcnRpbmcgZm9yIHRoZSByZWdpb24/ICBOb3cNCj4gSSdtIGNvbmZ1c2VkIHdoeSB3ZSBu
ZWVkIHRvIGludGVyY2VwdCB0aGUgQkFSMiByZWdpb24gaW5mbyBpZiB0aGVyZSdzDQo+IHBoeXNp
Y2FsbHkgYSByZWFsIEJBUiBiZWhpbmQgaXQuICBUaGFua3MsDQo+IA0KDQpzYW1lIGNvbmZ1c2lv
bi4NCg0KcHJvYmFibHkgdmZpby1wY2ktY29yZSBjYW4gaW5jbHVkZSBhIGhlbHBlciBmb3IgY2Zn
IHNwYWNlIGVtdWxhdGlvbg0Kb24gZW11bGF0ZWQgQkFScyB0byBiZSB1c2VkIGJ5IGFsbCB2YXJp
YW50IGRyaXZlcnMgaW4gdGhhdCBjYXRlZ29yeT8NCg0KYnR3IGludGVsIHZncHUgYWxzbyBpbmNs
dWRlcyBhbiBlbXVsYXRpb24gb2YgQkFSIHNpemluZy4gc2FtZSBmb3INCmZ1dHVyZSBTSU9WIGRl
dmljZXMuIHNvIHRoZXJlIHNvdW5kcyBsaWtlIGEgZ2VuZXJhbCByZXF1aXJlbWVudCBidXQNCm9m
IGNvdXJzZSBzaGFyaW5nIGl0IGJldHdlZW4gdmZpby1wY2kgYW5kIG1kZXYvc2lvdiB3b3VsZCBi
ZSBtb3JlDQpkaWZmaWN1bHQuDQoNCg==
