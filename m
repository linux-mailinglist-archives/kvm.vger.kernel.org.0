Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B11673ABFED
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 02:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbhFRAEI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 20:04:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:26448 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229848AbhFRAEH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 20:04:07 -0400
IronPort-SDR: rUVrEDxq97jRvatji7FL/56jn0GCb+a1fPeh/3mrdc/P8Wm1sLdhYY+mhRb506oGJX8bKWrhnf
 FVtm3M/c01cg==
X-IronPort-AV: E=McAfee;i="6200,9189,10018"; a="206423244"
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="206423244"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 17:01:59 -0700
IronPort-SDR: vCPi98GpYZ0SBS90SlinVqfg1NRu+Qslc2M+/fe1g3W7EG8axT/knrdFBOo8TdaxaYJ1ADmsGc
 0ZLvD+JSOiXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="405112722"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga003.jf.intel.com with ESMTP; 17 Jun 2021 17:01:58 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 17 Jun 2021 17:01:57 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 17 Jun 2021 17:01:57 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Thu, 17 Jun 2021 17:01:57 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Thu, 17 Jun 2021 17:01:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iJYOv/FM7Z0N3d9HLnVUFUYBj89BD9m6IVqK/Dd35hMR0Ey+h6XiDvvZfyT/nlOfemZfdKGcnbeMznf6RIED5Ei3h3Z4mRMZU2kUrwH0bx2SOsSpeBY6DkoJDGTjWVhOCdWPWVmXj6Pt2/DKXl+4ac5z7lYmilPF+LQcXbuFL5tosZCcmODipn/rMwUMCk52uBM/nCICIi+MNA/Xrzckzr8TfMe0S+lYA9wQ7oLFPVFxOoIfp8lzgQf+DqGGAEZ6vxnK2H98LjKemS5NMJgjoUuwPmsZTq3PkgiTufXMjHkIyd5j4dWWhLbggbXuaqyZja/jyPKEYtMyokm2+NGViQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+4XC47IBwViKL73RqHgLL4nul99rdsBYXPn8XRYGjQM=;
 b=l4GhEbKnZhxX4GmLaUUGzfwUt2nAUUjgPeoQUdFvA6hqAgxXmYdz6FT114n4CgjYXUe506PglS3sRrSfXmar1QIfGND9/JEEvLngG2oxkylQxypFRuUYKhVppBtw/jVzo2KAmVFZSI05L3il5BHVw+msHerB19zDqFUa0i0b/pHqQnG9zg34iA6MGHBeVWZBwXiDDBA1vy/YL71VCVVjUkYKmIJqH9gG6xqEpN091n5pKMsEbc2cBPbYttUdV19lrNKfpUIOzxK8CfSiiFQ5sYDx+JvQ5UTr2FfSxuCcGrsR2GWr6sFVE40/qR4VKF9o3luu1CZfI4Kx9FwWhjDkSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+4XC47IBwViKL73RqHgLL4nul99rdsBYXPn8XRYGjQM=;
 b=MIhFN+fkj5dyWOehlFqEqBiK4Fr05JVDA/bmiUsX+ngmyDYoero8TrKhYOj5nebmJIcg9duGWE08ts1S23mOskfAB8XnGWRY2ijoNT7t70FpZ6SKB6Z90mxRZNSuHUchq7Ac/05upO8lSl+p7vtAXXysik2VRax+VlwuKlf/aAQ=
Received: from BY5PR11MB4435.namprd11.prod.outlook.com (2603:10b6:a03:1ce::30)
 by BYAPR11MB3622.namprd11.prod.outlook.com (2603:10b6:a03:fe::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Fri, 18 Jun
 2021 00:01:53 +0000
Received: from BY5PR11MB4435.namprd11.prod.outlook.com
 ([fe80::cf5:f29c:49a0:ca6f]) by BY5PR11MB4435.namprd11.prod.outlook.com
 ([fe80::cf5:f29c:49a0:ca6f%3]) with mapi id 15.20.4219.026; Fri, 18 Jun 2021
 00:01:53 +0000
From:   "Nakajima, Jun" <jun.nakajima@intel.com>
To:     Kallol Biswas <kallolkernel@gmail.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: vmcs_config.size is 1024 but field offsets are larger
Thread-Topic: vmcs_config.size is 1024 but field offsets are larger
Thread-Index: AQHXY86pYxkyeCW8g0Khj3si2Tkxw6sY4qyA
Date:   Fri, 18 Jun 2021 00:01:53 +0000
Message-ID: <C6A9D59F-B03C-4E0F-B6EA-B48852B80DDD@intel.com>
References: <CANcxk1g0K6TFLwiOzTCAuxzeMYTZ4e90+FLtLL_sS9D1QEnH8g@mail.gmail.com>
In-Reply-To: <CANcxk1g0K6TFLwiOzTCAuxzeMYTZ4e90+FLtLL_sS9D1QEnH8g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [73.223.163.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 231e62f3-720e-4a93-2396-08d931ec47d1
x-ms-traffictypediagnostic: BYAPR11MB3622:
x-microsoft-antispam-prvs: <BYAPR11MB3622AEAAA59BADA371326B1C9A0D9@BYAPR11MB3622.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ya9UPzIz3zfq+h0u5lIKK3lq6VLCl/NmkpwzzwXXSI+TrcCgmnRkQ9Gh+NKEIPPqibhA5EdxS7dhdQGjJqDHArJTJro/adtnr3u1uiGLHefsCa0HvDknaMuy1PJZ2cTwl0SpZCkhk2X+3b9YPe2NlyRwsDHg94ksGjW5V5e+0cLr9Ofhpz2VDL97sP1TTxJ824PyI/w28gadbbgY6z0/11w3XXsrop5JNSpitqKodM2Qztz1t01+h6ZRNMODQZF3OIRm5oy5KexMnrWbCKdyRn6BWXWfQchIX0fV+YsQkBIdYhdDCgL8TqSIZhiepr2/6j+T3q53h6s3j45tBfX2Ty/c+5mkGjAmWURnKDjifHSjQJUv6keDX7pBjuq1wfoN7j9/H1hOgAmlENxTXJyaBp03EbWbIJLVDw34xNrnoJxCdUSkeWmiei8NOc6FQUqGMACzzBymxcQP2h1+QXHCwFE6iSh9+h09IuYW5ix8DbMdgrjkTi4eCrnSXPFHXKWjaqhVpJcHjG+ko1lDQIBH5MaOgcmNLWwlOseFWXCQOIYe2jrzP9JaMJUm7tYqIQ7msT7U7ZTjFtweA6rKQmToqiGIXLmJ2i+K91rIwghazBy4/Jjqeb92XoloQXZvIf8NZrG2nliVmqE7q1TL6IBSo/vDZHloLiZMcXfi7SVP8ao=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(346002)(396003)(136003)(53546011)(8676002)(86362001)(2616005)(6916009)(91956017)(8936002)(6506007)(66476007)(64756008)(66946007)(38100700002)(122000001)(66556008)(76116006)(4744005)(316002)(26005)(66446008)(2906002)(4326008)(33656002)(6512007)(6486002)(5660300002)(83380400001)(478600001)(36756003)(186003)(71200400001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ek5zRGt4T2ZncFRDTzNodnFQUjJEK0poZXJzY1ZWc3lmVy9SR3lDWlhmaWQ1?=
 =?utf-8?B?MDdJZ25oWVA3MXNJRmxQb3JUSVlDSFhZcVZQYXFtaFNlUm1zL09oMmJvcldR?=
 =?utf-8?B?bUtvaHpxeGgvUHNTRFJsa2dtSFBGMTczNU10ay9FZDJDZlJBaDJzeFJadjBr?=
 =?utf-8?B?eWlPenZBdHVFYkhTWFMyZi90UmJGQ1RwZzVWdy9JNlI4V3NVVCt5d0lVS3Q1?=
 =?utf-8?B?azd3WmF3NVdPQkY2dUNFdzkvR0IrdExubk9ReXpaTnpPYkhRYmdXNHdlZEk4?=
 =?utf-8?B?SjUzK0tOTnNkaHRpYzVjTG54dGVwMGdkakVCSmphc28vcCtvK29ZWVYwRWVp?=
 =?utf-8?B?TnlTcTljbng5TnlyODZLWkwrQjZHMHo1aW12N1Bia1hwdFovMzkzeUZPbXk3?=
 =?utf-8?B?Q1dYcDlCRUhlYUhDWk5pMXBRbXZ3T0hhT3c1eFF2WGtHMlpoekJNcDNUbWo1?=
 =?utf-8?B?VUc1ODJ5U2FBaEo3TEY5UXBoV1Q1V0dLdnhEcEJ2Q1g4R0pFZUh0STVTdXFv?=
 =?utf-8?B?cjlucHppd3F4ZEUvK01Hei9BZHc3UHFKeEpzNW1CY0NLRVZ3U0tOYWlNWFBK?=
 =?utf-8?B?Q3M2enVBUWRrNGoxbzJkZ0tXSlQ1Y092dlJXM0hjNVZkYlhwZ2NJUVo1UVNS?=
 =?utf-8?B?M0VUeVJyb09QeGh2YytBbFUyaUU4THAyd2NWZXpzNGYrU2RZQVh0N0FnVlE0?=
 =?utf-8?B?dmJXb2pFWHlicVg3MFNmOEJpQWJLS2cyZnNPSitQalNCaEpIUmE2cC9TUlkv?=
 =?utf-8?B?VVoxT3E3aXBRNFpVL1BsUXV2UThOYktuZFVvbHlwZnFEeDR0ZVNhNG5NcmV4?=
 =?utf-8?B?MDJGRU1PWlo1cWU3cVMra2VPeUc5R0FIbm0vbVNTNXhzcGh1R1VQdXJ3eGdO?=
 =?utf-8?B?WUV0TG9ZZWp1ZU1rUXRxM2g5RFlid1B6MzY1dGtQMUVEdWhvN21FSjhwNnR2?=
 =?utf-8?B?UGZqVmhaT0Rnam9oUkVsYTlHUWI1WEVsUE1BS1l6cWhUZ2hhd1UyUG5OUGc1?=
 =?utf-8?B?RHRvbFdSV1c4aEFsWnRIY3Urb3htV203Wll2eGxYS3RXb0ZtdTJMWjRxZnlN?=
 =?utf-8?B?SmFBK1dMMUpUZFJKTFl1RnluS25uMk9wcXUxNmg2cUU3bDg5SXp3RWlQay9T?=
 =?utf-8?B?eHgwSEtaUHB1UUF6aC9jUGUyVG56bzliMW5MTlVjTWg1alphYTZCdTFQQmht?=
 =?utf-8?B?b09DVmhibHVFbXZZcE9kak5OaDRneHNyRmNaZU1EM2lqK1hhVUgvM2xpSzhG?=
 =?utf-8?B?dkxhbG5aQlRyb2FGa2dDM0VlWUlVZXdPVDFRVWlmZkdGelR5b1RDdkIrRkpv?=
 =?utf-8?B?OXdHbFdzTE1mNHVHYjJSeEdGRDRvUmdVWDVmRmpBUTFIbHQ4dmg4b3FVdzdn?=
 =?utf-8?B?Z3hkNE1hakU3bW1xZmpLdFd5M0ZBNllzcW5SN24ycTNZcnl4dlFMTVNLWWpV?=
 =?utf-8?B?eDVOYU01b0xLa2hYaDlDUENRbEtDTWxpREdPLzVQd3R5RnlhdWZaRmVyUjZr?=
 =?utf-8?B?V2xhakZ3MzcrS0NFZkZFNHJKSm5zZ0tGYmFjQTA5dmRUc201S2tHQTJneTFS?=
 =?utf-8?B?NUFUNkh0WFMwTXdmcXVwQ0dFVXBEV2tJS1VqdXpWT092Y3ZuYnQ3b0Q3d2Nz?=
 =?utf-8?B?TjI4akpKTzFsU1RzbXhML2R0akRMeU1IdXUrKzd5VHlCWHpqTkFzdVViRHU0?=
 =?utf-8?B?SFBPNXRLZ3pyai9HV0xBRnZxQW13Mnh2TE5VbDNTbHorK2VuK1dRQXE1dVdm?=
 =?utf-8?B?aldveEQ2MWtLVFo2WG95bEFOeXIzemlqL2dyL0ZCaU1OWXpPZ1B5YlEvY1dM?=
 =?utf-8?B?TDN6T1dTSUdTeFByWERCZz09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A3E3902CBB8DAE45836346FE64236E06@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 231e62f3-720e-4a93-2396-08d931ec47d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2021 00:01:53.5307
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fVjEcXIhG+q2UqLKznxEiz/wdWNaFhoTNmyzE7EV0kwqGBRi51y0LtlhmLphTTyLUC1omx7/t2AhrBpkTzyfQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3622
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gSnVuIDE3LCAyMDIxLCBhdCA0OjE0IFBNLCBLYWxsb2wgQmlzd2FzIDxrYWxsb2xrZXJuZWxA
Z21haWwuY29tPiB3cm90ZToNCg0KPiBIaSwNCj4gICAgSSBhbSB0cnlpbmcgdG8gdW5kZXJzdGFu
ZCB0aGUgdm1jcyBtYW5pcHVsYXRpb24gY29kZS4NCj4gDQo+IEl0IHNlZW1zIHRoYXQgd2UgYWxs
b2NhdGUgNDA5NiBieXRlcyBmb3Igdm1jcywgYnV0IHRoZSBmaWVsZCBvZmZzZXRzDQo+IGFyZSBt
dWNoIGxhcmdlci4NCj4gDQo+IGNyYXNoPiBwIHZtY3NfY29uZmlnLnNpemUNCj4gJDE1ID0gMTAy
NA0KPiANCj4gdm14Lmg6DQo+IEhPU1RfUklQICAgICAgICAgICAgICAgICAgICAgICAgPSAweDAw
MDA2YzE2DQo+IEdVRVNUX1JGTEFHUyAgICAgICAgICAgICAgICAgICAgPSAweDAwMDA2ODIwDQoN
ClRob3NlIGFyZSDigJxFbmNvZGluZ+KAnSwgbm90IGluZGV4LiAgDQoNCj4gDQo+IHZteC5jOg0K
PiBmbGFncyA9IHZtY3NfcmVhZGwoR1VFU1RfUkZMQUdTKTsNCj4gDQo+IEkgbXVzdCBoYXZlIGEg
Z2FwIGluIHVuZGVyc3RhbmRpbmcuIE1heWJlIEkgc2hvdWxkIHJlYWQgdGhlIGludGVsDQo+IG1h
bnVhbCBjYXJlZnVsbHkuDQo+IA0KDQpJdOKAmXMgcmVxdWlyZWQgdG8gdXNlIHRoZSBWTVJFQUQv
Vk1XUklURSBpbnN0cnVjdGlvbiB0byBhY2Nlc3MgdGhlIFZNQ1MgZmllbGRzLg0KWW91IHNob3Vs
ZCBsb29rIGF0IEFwcGVuZGl4IEIgb2YgdGhlIFNETSBmb3IgZGV0YWlscy4NCg0KLS0tIA0KSnVu
DQpJbnRlbCBPcGVuIFNvdXJjZSBUZWNobm9sb2d5IENlbnRlcg0KDQo=
