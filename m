Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7975B42E8A7
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 08:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbhJOGGI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 02:06:08 -0400
Received: from mga05.intel.com ([192.55.52.43]:6695 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229610AbhJOGGH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 02:06:07 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10137"; a="314053265"
X-IronPort-AV: E=Sophos;i="5.85,374,1624345200"; 
   d="scan'208";a="314053265"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2021 23:03:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,374,1624345200"; 
   d="scan'208";a="525334540"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 14 Oct 2021 23:03:20 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 14 Oct 2021 23:03:20 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 14 Oct 2021 23:03:19 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 14 Oct 2021 23:03:19 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 14 Oct 2021 23:03:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eu7I9x3NSDjl5xuhnVTmWrC1EKhlacNaSk8tsdmrgqfB2iLuewDfdrowpgsjrtQNai5LiVgtW4AsAFb5TfI7S9T4jhnEK9UAw4tw+QEEgXNk5iEpXDopaWxAO+p7vnOhwAJ0zpyXugcFd3rJw7VsycWqRxVFkRW0ckDsWLwJL3u0gBJocChc7buJozHqRlu+24JOTgd1sn+NlSH8w79mCU+iRjwLMC273Ke/y1ND89P8Xe5HhCQ9u9HMoQHaqL+dUFo9fpmUd/8eE5CzVyE9mH43nBnpst/+vAJz3Gbz7sqNeJjKK2AMBgEh2qJ0kOLefHvpiy1CGkw3EZ50sFXTQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5dbrahQrXbES299XipkZGgNAly/FJJ6apOLD8IgAs0o=;
 b=EPq4voGZN8AkVMtT9r6TYJv8BXp754wirG1dsoUg1LwZQGaO/GVh/VYDCrkwnDSymrB2l8zCNKvzWyb26U+H3kgBE84Mq9WkEsPYuLxElfUA3KVVk6pcj3PdokhLnEt3WA2cG0iGIv9euT7uMuOFocNryYmMjiWrCZV5fCcMJTwFaKLUzOHkfwmGKQcswfJt/ZSCGIyfQzihegBN9D9l0Oa/Bn4cDm1DWgNTGLpHaeunj29ghB7MlbF2VlsZMSiYbPXUczPhMDPA7rfT9bDMggyB9cGZkeFH8jS4s7LX/CwhAS0wWDHzQFQ3EWbZ9j59gfvLg5HcJ87DlQbPk42BVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5dbrahQrXbES299XipkZGgNAly/FJJ6apOLD8IgAs0o=;
 b=cokdVx5VsakjT9J6iwdH3BxjP5hUGwi631+T3kGA4lBRdNAULSZZ5ZF2hCOZ+wzbxIUKo2rDnTAQQyI1f48lP1Sho3NI3C2nFnBVa2EZTUAuVrH411Wd6q9bDlB2Hr/MaUk+mNN3vtIj2eki3BjOPFdNNlkK7h5pSQFYiFKrI9k=
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by PH0PR11MB5660.namprd11.prod.outlook.com (2603:10b6:510:d5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Fri, 15 Oct
 2021 06:03:18 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::5009:9c8c:4cb4:e119]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::5009:9c8c:4cb4:e119%6]) with mapi id 15.20.4587.026; Fri, 15 Oct 2021
 06:03:18 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [PATCH v2 0/5] Update vfio_group to use the modern cdev lifecycle
Thread-Topic: [PATCH v2 0/5] Update vfio_group to use the modern cdev
 lifecycle
Thread-Index: AQHXwD6SiGHsWaIRwEeUL+A5q+eCDqvTkyWw
Date:   Fri, 15 Oct 2021 06:03:18 +0000
Message-ID: <PH0PR11MB5658A21677BA355E1A44A6C9C3B99@PH0PR11MB5658.namprd11.prod.outlook.com>
References: <0-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
In-Reply-To: <0-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 87283d02-8d5d-4737-add5-08d98fa17bf9
x-ms-traffictypediagnostic: PH0PR11MB5660:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB56608B8DE0D8A3D588B7693BC3B99@PH0PR11MB5660.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ycWd4bcSAqEIekJHd3jz4JsyA+r3rqetClPoPcXzk6wAIJk0Cn+QSelMEGCyjGEMvHMOshWwhVVSFm0M6vazmb9c/yzUhH9zsiVZCdSRALFWJqHd/WbEDmiY1cCEhSMrNPYJN5PdY/uYncdZXLL3gkoa6YIb9yrztfCBAwZIrRseN+Cw+1CMOMjxQC898Sed86gkYOfuzkdjL08BQTzlts6YoVgOXMmMa4Caujg60xc/Ssc17iffxJ9BXlIrVtsfrRoCPU8H/lruYuXOfJPQAqaic76MwprVLIpJysrxW0De5SNdHJZcyjIglnHGcNxpIQD4vydSf4nijGsrtTTj95E88Lao3NCbkiX+NJqXceFssifDuCnbIb6QmkXeFcxbjM8kfEcpZP6xTdl/yo+PY7p/01eP+1ai/rrkOevT96Uge9FKotn8V8uAizFRkptD2hmh8qhabcwXzS5Wtgq4Elrzxx0648lqN/GfkOuyGV8uMt9AMirGMq2n7dU9uV6D9l858WshEpqbNxGPxRafv/E7BAVI0TVtHkWIHaFStB5Yr7j8ScRKnZvEosfCcfJ7f7F5GYcv2ecm+rxNuCIsGZ6nNU/IPFI1tKGsiiDygnvFTuNNqavvMXLE5tNDrr3pJlc+0ftGZ2zfUNXDCLvsu//jLc6HkRi6w58wIsuLAWK27ropwz6xl5QUzjfNeSSe0PYCR48x0flFEUBshJo+AdyLdmRYKeQ/c2FRE+03aLyOXv8feY5OFs6poXzWYcH+4ceHH7EptKTGK9wUTISOglDmJVdb1NOeycKwEcQdMEkGhLqm2CkNyr3hF2KwKyE2VhCdr/jxoxt7qTCnkku/xA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(54906003)(66476007)(76116006)(8936002)(66446008)(55016002)(316002)(966005)(508600001)(107886003)(4326008)(26005)(9686003)(66556008)(186003)(6506007)(110136005)(83380400001)(2906002)(82960400001)(5660300002)(7696005)(33656002)(38100700002)(8676002)(86362001)(64756008)(38070700005)(71200400001)(122000001)(52536014)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TDZ2czkweTZLcXZ1Mk9jSUtCbjQxUnZTc0Ztcms0cXhPRzhPYWRpR1IveHpF?=
 =?utf-8?B?bzl2Q0V0T3RQVVZCTHc0RUJLTFY3RStYcHJBdUxqY3ZpZ2l1Z3RXMnRTNjky?=
 =?utf-8?B?Kys1ckRiZmpXbUFKWFJFdVhpanZ2bVJ1MHptWEhiNnlmZEM3aUVtbnJaVHV2?=
 =?utf-8?B?eU9xMWN6WXdoSms0alRZWUFiWCtGTzBvTGlpTzc3b1AvWDRzMm5DNGlCYTdP?=
 =?utf-8?B?eXc1bVJxVlM2TWRuZk9SZnNQZ2MvUnlmcmYvZGIySC9vb3lYVFJ6aEpZK1RH?=
 =?utf-8?B?Yis0WnRROU5wSjMzWlFHUVI5NWhNclE4S21Xd1FpNUJWNXNZOVlFSmdMSkZT?=
 =?utf-8?B?TjlkMExLRGtTemE2OExBTUR2VjNkVTRPYVQzeU9RTjB1RjNmUnB5ZTJCbWRS?=
 =?utf-8?B?bTNmRFpCTTE0VTJtc3JtclY3NzhBTlBtd1l4dDhSUGhXVU1neU15MTAzK2lX?=
 =?utf-8?B?bXkrWWd1RDVFZE9DTHdpQkNRVklYclQ1Qk1TbS9EeW1WZHFGWWhVQ3RacSs0?=
 =?utf-8?B?djdzMDB4UGtsUW9pWkJrQ1haSi8yTzdqcjc4Njg5dGpIRlpiQVpsYzlzNlNO?=
 =?utf-8?B?OWw1S0hqSG16bUgyNmFMNC9URDRXMDgxTk9ZWmlyZys4bDZCZGZLTiswb0g3?=
 =?utf-8?B?bVpaeWhMamc2TkJGNmxQK1U3TlpiZzJMcEljMGJsOS90d1cwUGg1RXdsdWpK?=
 =?utf-8?B?RUQ2eFFMUzBhTEdqSzVLNVVIWWgyc3U5OXBWckRvZ1ZpSDkwK0F3ZVFRZGxJ?=
 =?utf-8?B?eWJqVk9mMFNuZG5DWWZnaXJJU2ZYbmZpQ3FLQ3ErNEd3anhRMU1LQ1FBbS9q?=
 =?utf-8?B?aDNjeXdqeEY5UEswbS9xNFBHdXFYN3A4anU3UkFJZExSTDFNSUIzVWhyajdF?=
 =?utf-8?B?dGJ1aWVzUjRSazEwMVNDeXRSeTR0d3lPOWJkTUZlaGkvWklDRi8ybmFxMWhE?=
 =?utf-8?B?TTdhQnlHSmI5OHB1aG5sYmV6ODFiaHV5a3JlZTkrT21Jc3RGeFAwUjZibkJK?=
 =?utf-8?B?RmpETEh2YW1nclN4NUs2cXVsVGxaLzhoTnBzMTBEaUZtcFpONkg1aXBHamxU?=
 =?utf-8?B?d2dVKzJxL2d4V0pXbXFrNFAwa2p2ZkFYdlR0Zk9IcDNidlRHdXlOdUYrc2Mw?=
 =?utf-8?B?bjNteVdTV0dteUM2TUtQZHFsVGxFbkd5ZkM0YWxzck1nRytidUpXRkhVN2JO?=
 =?utf-8?B?NG84bmdiTTU3bFJRTTIzZDZCR0s3cGZkeHYxdTZ6NWU3SUgzcGtIOWFoZXUy?=
 =?utf-8?B?UUEwS0VQbzNGcjlKN3o1elRqMEt6VFllZmNiNVdSUlVlSTVPQlhuSTdNU0w1?=
 =?utf-8?B?Z3cyNmdkaTdHWnZWRHplcHRvL00vUGtwR0E4QmNvSlRQVThHM0ZIVVJ0SGdi?=
 =?utf-8?B?WlFTZDFadHNYS2o4R1FjREsxbHJreDUyOVRGWXZzOVJ4MEtqUk81aTZWYnYy?=
 =?utf-8?B?QlJYMmFuc3ZTUldyMllMd2FiUWt1RWFVbUl1cS9qNjNGczVXbStxTG5GaUNz?=
 =?utf-8?B?QzVRelowVDZVNEdxVlpkam56cGNBY050NVcrWW40c01MY0NqeW1YVzdQNXhS?=
 =?utf-8?B?Y25xUUpXVHFVWnZBOFRJbS9ZRUZzUE9xcE9FSVJPaCt1OGdhOFhnRk9CWFdN?=
 =?utf-8?B?cVJnSXVzMzdhL3FMKzFsa0MyM1liSkpqVGpCMnA2bEJlUDFrcWVSbjM1eHlh?=
 =?utf-8?B?bHlGNE53eGYzTFE1azAzSjR6dlppVnQwWXpqbWZsTGh6OVNLRVJFT3loc2ZK?=
 =?utf-8?Q?T2lPArDfuUOFlGbv5RHG/z11YwZELSUHKLYYSZa?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87283d02-8d5d-4737-add5-08d98fa17bf9
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2021 06:03:18.1077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fN14NZ4z3rhKr62E3Nm43uVcyR9KeeBXLwyDULMCqx5JQ9+Te6AtX9nqeZVy9oYfJVOunjt83WxaYrSPzZsuiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5660
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBXZWRuZXNk
YXksIE9jdG9iZXIgMTMsIDIwMjEgMTA6MjggUE0NCj4gDQo+IFRoZXNlIGRheXMgZHJpdmVycyB3
aXRoIHN0YXRlIHNob3VsZCB1c2UgY2Rldl9kZXZpY2VfYWRkKCkgYW5kDQo+IGNkZXZfZGV2aWNl
X2RlbCgpIHRvIG1hbmFnZSB0aGUgY2RldiBhbmQgc3lzZnMgbGlmZXRpbWUuIFRoaXMgc2ltcGxl
DQo+IHBhdHRlcm4gdGllcyBhbGwgdGhlIHN0YXRlICh2ZmlvLCBkZXYsIGFuZCBjZGV2KSB0b2dl
dGhlciBpbiBvbmUgbWVtb3J5DQo+IHN0cnVjdHVyZSBhbmQgdXNlcyBjb250YWluZXJfb2YoKSB0
byBuYXZpZ2F0ZSBiZXR3ZWVuIHRoZSBsYXllcnMuDQo+IA0KPiBUaGlzIGlzIGEgZm9sbG93dXAg
dG8gdGhlIGRpc2N1c3Npb24gaGVyZToNCj4gDQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2
bS8yMDIxMDkyMTE1NTcwNS5HTjMyNzQxMkBudmlkaWEuY29tLw0KPiANCj4gVGhpcyBidWlsZHMg
b24gQ2hyaXN0b3BoJ3Mgd29yayB0byByZXZpc2UgaG93IHRoZSB2ZmlvX2dyb3VwIHdvcmtzIGFu
ZCBpcw0KPiBhZ2FpbnN0IHRoZSBsYXRlc3QgVkZJTyB0cmVlLg0KDQpKYXNvbiwgZG8geW91IGhh
dmUgYSBnaXRodWIgYnJhbmNoIGluY2x1ZGVzIHRoZXNlIGNoYW5nZXMgYW5kIGFsc28NCkNocmlz
dG9waCdzIHJldmlzZSB3b3JrLiBJIHdvdWxkIGxpa2UgdG8gcmViYXNlIHRoZSBpb21tdWZkIHRo
aW5ncyBvbg0KdG9wIG9mIGl0LiBBbHNvLCB3YW50IHRvIGhhdmUgYSB0cnkgdG8gc2VlIGlmIGFu
eSByZWdyZXNzaW9uLg0KDQpUaGFua3MsDQpZaSBMaXUNCg0KPiB2MjoNCj4gIC0gUmVtb3ZlIGNv
bW1lbnQgYmVmb3JlIGlvbW11X2dyb3VwX3VucmVnaXN0ZXJfbm90aWZpZXIoKQ0KPiAgLSBBZGQg
Y29tbWVudCBleHBsYWluaW5nIHdoYXQgdGhlIFdBUk5fT05zIHZmaW9fZ3JvdXBfcHV0KCkgZG8N
Cj4gIC0gRml4IGVycm9yIGxvZ2ljIGFyb3VuZCB2ZmlvX2NyZWF0ZV9ncm91cCgpIGluIHBhdGNo
IDMNCj4gIC0gQWRkIGhvcml6b250YWwgd2hpdGVzcGFjZQ0KPiAgLSBDbGFyaWZ5IGNvbW1lbnQg
aXMgcmVmZXJpbmcgdG8gZ3JvdXAtPnVzZXJzDQo+IHYxOiBodHRwczovL2xvcmUua2VybmVsLm9y
Zy9yLzAtdjEtZmJhOTg5MTU5MTU4KzJmOWItDQo+IHZmaW9fZ3JvdXBfY2Rldl9qZ2dAbnZpZGlh
LmNvbQ0KPiANCj4gQ2M6IExpdSBZaSBMIDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+IENjOiAiVGlh
biwgS2V2aW4iIDxrZXZpbi50aWFuQGludGVsLmNvbT4NCj4gQ2M6IENocmlzdG9waCBIZWxsd2ln
IDxoY2hAbHN0LmRlPg0KPiBTaWduZWQtb2ZmLWJ5OiBKYXNvbiBHdW50aG9ycGUgPGpnZ0Budmlk
aWEuY29tPg0KPiANCj4gSmFzb24gR3VudGhvcnBlICg1KToNCj4gICB2ZmlvOiBEZWxldGUgdmZp
b19nZXQvcHV0X2dyb3VwIGZyb20gdmZpb19pb21tdV9ncm91cF9ub3RpZmllcigpDQo+ICAgdmZp
bzogRG8gbm90IG9wZW4gY29kZSB0aGUgZ3JvdXAgbGlzdCBzZWFyY2ggaW4gdmZpb19jcmVhdGVf
Z3JvdXAoKQ0KPiAgIHZmaW86IERvbid0IGxlYWsgYSBncm91cCByZWZlcmVuY2UgaWYgdGhlIGdy
b3VwIGFscmVhZHkgZXhpc3RzDQo+ICAgdmZpbzogVXNlIGEgcmVmY291bnRfdCBpbnN0ZWFkIG9m
IGEga3JlZiBpbiB0aGUgdmZpb19ncm91cA0KPiAgIHZmaW86IFVzZSBjZGV2X2RldmljZV9hZGQo
KSBpbnN0ZWFkIG9mIGRldmljZV9jcmVhdGUoKQ0KPiANCj4gIGRyaXZlcnMvdmZpby92ZmlvLmMg
fCAzNzIgKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gIDEg
ZmlsZSBjaGFuZ2VkLCAxNDggaW5zZXJ0aW9ucygrKSwgMjI0IGRlbGV0aW9ucygtKQ0KPiANCj4g
DQo+IGJhc2UtY29tbWl0OiBkOWEwY2Q1MTBjMzM4M2I2MWRiNmY3MGE4NGUwYzM0ODdmODM2YTYz
DQo+IC0tDQo+IDIuMzMuMA0KDQo=
