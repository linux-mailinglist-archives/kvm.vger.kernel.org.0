Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F18F39BE3F
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 19:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhFDRPL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 13:15:11 -0400
Received: from mga06.intel.com ([134.134.136.31]:38540 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229878AbhFDRPK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 13:15:10 -0400
IronPort-SDR: volUmOhRy81lQwtCOZGrJBa+nA90Azf7QgwJ8cgW2V4NK1aEZFgmV7b4b1iwHPnmZ6pHtdIofd
 sRamOWHThIuw==
X-IronPort-AV: E=McAfee;i="6200,9189,10005"; a="265494668"
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="265494668"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 10:13:23 -0700
IronPort-SDR: PHnkbewFBrjDEKnN2uCBzIvSvVqi9BvKEpuoekpht5NFY+1auyPIxiX98T7pF5K2Hr6ElQe0Tg
 CMOoawqqrMvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="412427912"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga007.fm.intel.com with ESMTP; 04 Jun 2021 10:13:22 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 4 Jun 2021 10:13:22 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Fri, 4 Jun 2021 10:13:22 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Fri, 4 Jun 2021 10:13:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SFHCh/tVRYZczAQ2C6IRtTByYClpYEdZkzdoDzc/euCn+CaFH3zzmzEEHgtLaVVWfhn9Da6cu+BxTNSiLBrGP9avyS5zRWTINtW9/I5hq5VzoGxdemhPYCQpQM3qdhHPicrgrSzTA+jphD/ullb7W1VVSziMgAvpOpciEiAq44cR6AGT1wunoFd3Ty8xEgs1Fioz6nleL1FOqRv/K7FAgxMA5yKEJoiwLKrCbK7Uyi2odhwWPm5NwEpEmbsi+eZ6ptxzxx+By7mLW2unQuquh/+7JHUqpGWWDi4eyGhdo04Qh2b92bA/JiaCNC+PIK6o5G7qhLtIGpqPFI9gcuxsXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j54s/3tekphM5o7VZLfxjIP2sft80d6CH53CsbXBVAU=;
 b=iuhnydJ86TbzkV0JxIFFjt1tLGsLR+CWCTFl+Wj16gszYDZ3v5fjz2uXrDYHTEJqX3UWIdhA1f/tPpCFMGwOQZeVReQ+WY+wiVXW3tRhoojtE1bnlk6tvXFWE+R3V6a1BZZ+Mdd53Y8UStbckAcpotu/BxQYqrz8VyQncL8/m3/2rkGRmbp8bX50b/i+KDl/UCvRIwxUiD3b5OSqxBf9ywvH6Btjt5kIRLmc466WJOWL8FOAep2+3TO9Pk1hROgN7D5+QDSu/g/31+f2K2oJu/kiDbUwcvV2yJBwuTpcVZ75Np09u3w2hyF6o+eZUsTMdXSSwQWkCFRNTV1gByVUog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j54s/3tekphM5o7VZLfxjIP2sft80d6CH53CsbXBVAU=;
 b=rx6YP631f5aykDVcxhBYYkhHu5VwpBch3JMr16oI8usZOnTvbBnlCoRVOr90ROQMGMJ9guefDmHzQYYmfn6Eu90wGIplGsMTHNTJWR7DeIVbC/1xBmV8Vs471l8O+Vv2vZZCV0lKyg8ykuTt8tEhsC5WPvoUpn1HQLj6Ron0IDI=
Received: from DM6PR11MB3115.namprd11.prod.outlook.com (2603:10b6:5:66::33) by
 DM6PR11MB4658.namprd11.prod.outlook.com (2603:10b6:5:28f::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4195.24; Fri, 4 Jun 2021 17:13:20 +0000
Received: from DM6PR11MB3115.namprd11.prod.outlook.com
 ([fe80::6d2f:50ab:cdf0:3465]) by DM6PR11MB3115.namprd11.prod.outlook.com
 ([fe80::6d2f:50ab:cdf0:3465%7]) with mapi id 15.20.4173.030; Fri, 4 Jun 2021
 17:13:20 +0000
From:   "Sun, Yi" <yi.sun@intel.com>
To:     Nadav Amit <nadav.amit@gmail.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [kvm-unit-tests PATCH 2/2] x86: Create ISO images according to
 unittests.cfg
Thread-Topic: [kvm-unit-tests PATCH 2/2] x86: Create ISO images according to
 unittests.cfg
Thread-Index: AQHXWOo86XUHYgZSU0qrii8ea7woGasDK0uAgACXPHCAAFRBAIAAAEwg
Date:   Fri, 4 Jun 2021 17:13:20 +0000
Message-ID: <DM6PR11MB31155CEFF09D4EAF3990DBB1993B9@DM6PR11MB3115.namprd11.prod.outlook.com>
References: <20210604023453.905512-1-yi.sun@intel.com>
 <20210604023453.905512-2-yi.sun@intel.com>
 <30FA4AAE-DBC9-4DB7-8742-079F2B3067C3@gmail.com>
 <DM6PR11MB311557D8C203529903BEFB2F993B9@DM6PR11MB3115.namprd11.prod.outlook.com>
 <2516617A-CFDE-4EEF-89D9-896951A9C68D@gmail.com>
In-Reply-To: <2516617A-CFDE-4EEF-89D9-896951A9C68D@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.142.26]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 226bf24b-6d9a-4de1-b07f-08d9277c0da9
x-ms-traffictypediagnostic: DM6PR11MB4658:
x-microsoft-antispam-prvs: <DM6PR11MB465805A0BE00A2B291DDCACA993B9@DM6PR11MB4658.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7jevMoB9MlYvyCOOu5SusCv7FEUovv1ikwfK3rr5KmurLLEA/LYulMVdYIlMCF+/g1OSnmZRVH0xVd2BlHkpntiGGqtMwoaoEwkw+sU2g+2uiCjITv3rd5JYoBinHIf8TGrMut2GC4EqFDnLxRRC0dev2WaTyrI7sdWOZqvGjE4dWaVqRXAznBH6SLuF4O3O/HK3uGCH3+BvhAka4CzXVd606NlVN5wPX75kkDUvmIb3FdQW5lQXuH2s5tsTlUf3zB/M6N8ZNSJkVxGwky7nlgJnbjFFhcfc8RoE9JqNv7/DJQ1T1fJn7+4AUQxOvjdS8/Qur86+WsCjzUUR57VVRM7wcAvO70KFGM/ZfsRj8aZyh3/vSkA/uY8qXvqegy6LMIZnBAx3fls0ZiGyCifnWMlP9i5EWN8e1vTrps2JguTBkxy2f4X9/UiQ/LbGR9zQ6kGR0em7EJf3b6C0CkKCFSiuRSzAic9MhlMYLAoW/es+6yzSxXWbUZgdJnXNplkcIor6CQFV7rSGXY1hNamjeyObzh5Oiyf+AfG57Hauy7kbdAXe+gY0tqcsR6WW4M3wzaceFdLXPr+zYzhARhoUn3DOq9CSuocz3aPh1yP9+9U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3115.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(39860400002)(366004)(136003)(6916009)(26005)(5660300002)(186003)(2906002)(83380400001)(86362001)(66946007)(33656002)(71200400001)(76116006)(4326008)(66446008)(478600001)(52536014)(38100700002)(64756008)(9686003)(66476007)(66556008)(316002)(55016002)(7696005)(8676002)(122000001)(6506007)(53546011)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?OUcxSHNJN01XL1RwSnNJMVkyZWQzeWd0WEtCbDYzWThyM24zcDVUamJWaWFm?=
 =?utf-8?B?aVBWbnFwajNqMEIvTUhJb2hDRkRLZmNFL1ZZZFlOdDg1WjRLZ3diMm45bHp0?=
 =?utf-8?B?T05XLzQyRTF6ZlpOTFUzRFQwSk53U2hobTliMkNjYU4xWWI4elRCbERrazZk?=
 =?utf-8?B?QVRsZWZCaTcwTnRxT3BwTzVBc2ZzcTRibkUzSHJOVTRUUG5HTyt4NG9jV2Rx?=
 =?utf-8?B?dDZGcThnVXJHcGdTdk85SW9vNTRMOEFja2RtblNWOWtVNGUwNTVXUmlSMXFo?=
 =?utf-8?B?OWRYUGlFbHE1b0lFM1daNHErTTBoWXFWLzJyYmQzS3FtQ0paaDkvbjVwQ1hO?=
 =?utf-8?B?S3p4bkFLamtkejF3SGlEUjhHY051VFdRUzdyWUtNM2RFaTB3ZXpNdkdmbFNz?=
 =?utf-8?B?RkdtUzhHR2l2SHhLVDBLaFNUNS9IVzkzd0E3Yi9jak13L2JzVnJxcHpJam5k?=
 =?utf-8?B?MjQ3VlFaSjVzOXBJU1BmVFBrTUNnZDViWlN5K2ZqejdkVFRaVmFNN3NvdTda?=
 =?utf-8?B?RytyMWVWMEdyVlpQbU4vYTlBdktFNTI5bkhhTjBLcUcrek1TbzV2ZnZvUkk2?=
 =?utf-8?B?a2lIQ2lUNW1rTVh0VE9oZ1JMVFJKVlFkQzBGRi9yQVhRc1JwdmhOaFZLbW53?=
 =?utf-8?B?Umk3SDY4UlhsbDJQdFlvN0diMkRPUUkzQkp0MHdSb3UzWDRwZVEzRnh6K2VI?=
 =?utf-8?B?Y2lsSVFUVmJCMGx3bkNCSE12RlA3RlMwRElCeG15N0lCbDNGRDdhMlBPbGds?=
 =?utf-8?B?NDFMM05WR1ZyWmtyMzFVS0FUTlFIam1OTStJR0lGelp0MDZqR2ZVL2VPSnlH?=
 =?utf-8?B?eTQrM0phanBMb1V2bWIrL1B0RDlLa0RubndzYlF3c0pLUm8zTWpONkZDVm9S?=
 =?utf-8?B?SFRlLy9VQndzb1JKY0FVYUdmUDRXbllneHpGWnk0L0FkcUp1bTVKcmhyZmJ5?=
 =?utf-8?B?U0Q0dXRiNWg5dlVNUHhrMlhjbWtacUt6Q2JlN0oreWJPUVdaSGlYc2pBRjRx?=
 =?utf-8?B?R3EwSFBzYk9TcEVkTjFtQk9UdC8xNnFZNUxZR0ZoSS9mdWNjMmFLeC9sUDhV?=
 =?utf-8?B?UGp5SlNBNzZER3FiUllEQ2N1YUZWaEFEWDJEbzRqQXhockdWK01hVGg3MEhs?=
 =?utf-8?B?MnJjSHh2VG5TSmZ3NExrS1F2V1BzOU5zUEJMVVVSejFURTdTY1lxcTMwVkxF?=
 =?utf-8?B?djZQellIa2JnN05uZEZQbCtMVW5NcDhnZXdPU1ZkNGN2c04vYjRRZTljVkNQ?=
 =?utf-8?B?TU1laXpzOGk2NXVXck9GZ0hPN1hJeWUvdEFxNDk5WU5lWEVSKzJWMCtaZld3?=
 =?utf-8?B?by9lTHo2eU9BbmNCcllNeDRIR2h6bGRuMzJ4L0w2NUlwRlhVYTU2VHZ6M1Zz?=
 =?utf-8?B?dXhKbndidEs2aFRYZisxQWk5NysxUlhMNkg1Z0NmSHA5NzdBY2llSlVjMGpO?=
 =?utf-8?B?QWc5d0VsbFJZMFJ3cEpRRzUxaGcycDBVNUZsZTloNTN2NTNEeHV1TkYxOHN5?=
 =?utf-8?B?S1ZZNFRjWGZUbXlpYWVXQWRVMGR5ZVFDT0IzV0JUcEpiOFZvSUN6S0dXakNH?=
 =?utf-8?B?Z0FxN2Vxcko0SGY4SFJBYUg4aUJlRlA0NjljQTNqVnVrVU12YVNUNEdxT0Vh?=
 =?utf-8?B?NzZ5R2tBRHRIN2hOODRvQUJGS1pBMGtXM1gyeVNiUFZaR2txSkJvTVBSbmZk?=
 =?utf-8?B?cFRYL1R4U05nd1I5RCtqN29PWkxHV2Q3Zkl2N3BNLzZZV0FualF5bHFiSTJJ?=
 =?utf-8?Q?c5UAlICsc6mWkyfC7sqUKkyjaV0Is12StO4Bxaf?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3115.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 226bf24b-6d9a-4de1-b07f-08d9277c0da9
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 17:13:20.6929
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: av8R80OUKSpkDExwbQB4HakpEycDgH3/bfuSR9A5qMFpqQ/9Rme4Ps6r5mvYtnryD6N4WRDTp/hNVflHgwU6lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4658
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T2ssIGdldCBpdCBub3cuIFNlbmQgeW91IHRoZSBzZWNvbmQgdmVyc2lvbiBzb29uLg0KDQpUaGFu
a3MNCiAgICAtLVN1biwgWWkNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9t
OiBOYWRhdiBBbWl0IDxuYWRhdi5hbWl0QGdtYWlsLmNvbT4NCj4gU2VudDogU2F0dXJkYXksIEp1
bmUgNSwgMjAyMSAwMTowOQ0KPiBUbzogU3VuLCBZaSA8eWkuc3VuQGludGVsLmNvbT4NCj4gQ2M6
IGt2bUB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtrdm0tdW5pdC10ZXN0cyBQQVRD
SCAyLzJdIHg4NjogQ3JlYXRlIElTTyBpbWFnZXMgYWNjb3JkaW5nIHRvDQo+IHVuaXR0ZXN0cy5j
ZmcNCj4gDQo+IA0KPiANCj4gPiBPbiBKdW4gNCwgMjAyMSwgYXQgNTozMiBBTSwgU3VuLCBZaSA8
eWkuc3VuQGludGVsLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBIaSBOYWRhdiwNCj4gPg0KPiA+IExl
dCBtZSBjb25maXJtIGlmICBJIGdvdCB3aGF0IHlvdSBtZWFudC4gRG8geW91IHdhbnQgdGhlIGdy
dWIgZW50cnkgbG9vaw0KPiBsaWtlIGZvbGxvd2luZz8NCj4gPiBUYWtlIGNhc2UgbWVtb3J5IGFz
IGFuIGV4YW1wbGU6DQo+ID4gQWRkIG1vZHVsZSBjb21tYW5kIGxpbmUgdGFraW5nICcvYm9vdC9t
b2R1bGUnIGFzIGl0cyBwYXJhbWV0ZXIsDQo+IG1lYW53aGlsZSBwYWNrYWdlIHRoZSBmaWxlICdt
b2R1bGUnIGluIHRoZSBmb2xkZXI/DQo+ID4NCj4gPiBtZW51ZW50cnkgIm1lbW9yeS5lbGYiIHsN
Cj4gPiAgICBtdWx0aWJvb3QgL2Jvb3QvbWVtb3J5LmVsZiAgdHNjZGVhZGxpbmVfaW1tZWQNCj4g
PiAgICBtb2R1bGUgICAvYm9vdC9tb2R1bGUgICAgIyBBZGQgb25lIGxpbmUgbGlrZSB0aGlzID8N
Cj4gPiB9DQo+IA0KPiBZZXMuIFRoZSBlbnRyeSBzaG91bGQgbG9vayBleGFjdGx5IGxpa2UgdGhh
dC4NCj4gDQo+IEp1c3QgdG8gbWFrZSBzdXJlIHdlIGFyZSBvbiB0aGUgc2FtZSBwYWdlLCB0aGUg
4oCcbW9kdWxl4oCdIHNob3VsZCBiZQ0KPiBwcm92aWRlZCBhcyBhIHNlY29uZCBwYXJhbWV0ZXIg
Zm9yIHRoZSBzY3JpcHQuIFRoZSBhZGRpdGlvbmFsIOKAnG1vZHVsZeKAnSBlbnRyeQ0KPiBzaG91
bGQgb25seSBiZSBhZGRlZCBpZiBhIHNlY29uZCBwYXJhbWV0ZXIgaXMgcHJvdmlkZWQuDQo+IA0K
PiBUaGFua3MsDQo+IE5hZGF2DQo=
