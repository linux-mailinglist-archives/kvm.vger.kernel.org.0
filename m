Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC28A4721F7
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 08:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbhLMHvf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 02:51:35 -0500
Received: from mga02.intel.com ([134.134.136.20]:35917 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231407AbhLMHve (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 02:51:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639381894; x=1670917894;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=06bL+LdkfNW7a7Gv5btDW3xq5bEDILrWgnjUSJeHkuo=;
  b=jOUNluQWufWoRHs6lWmeCJ0tXI+FI2adhW/9RNC+q8h01OcB3b7Gmh3T
   o2nNrMIHsJ/C4pWRrCLK/NwNCla1nNBmNUK5K7TxXzggTGkg0wJuNdUd7
   taZgyjLTUKsftUEEoMjuDosKaIaht6m7MFWG8U8GZw+1yynAsTqKsyAlo
   XsMS+yzhT9wNQUZjt4CmB4C6CvqVa/mvGRPOVgFzNSSjnl+jN3doxYRJ0
   2w+TD8M2cRxT6nwBnNLrTnYwOPmwKDC2JH5458Do7kLH2T2MK4jDYpUiS
   cSAQCCKtPvX6NcB9WSrKR2NXaq8TcfZkHKzMvM8vg8KJ8qNRWrnCyanHG
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10196"; a="225957329"
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="225957329"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2021 23:51:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="504800011"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga007.jf.intel.com with ESMTP; 12 Dec 2021 23:51:34 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sun, 12 Dec 2021 23:51:33 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Sun, 12 Dec 2021 23:51:33 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Sun, 12 Dec 2021 23:51:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EhoOZFsCBxQEU3LFQiKA8oQz4/ZuXQKD/9iz7/4kXBJVyUYUaJVRkzAoszI/LWrzIFP9TZNd28aMRiGIDEYH3hd5/HDv+9feGBj8bvWERvXrC2dKCIUz9N3smo1vB+sct7qQHmwOZ32UpQ3WMfpe8EXWB7WiQAUyh+GWklzYZy0uJZ52diJFdhzDKHG3Ee+KPdtjesNBfylV3KwqhVhTWESTiqYpBSLlW3kKLDAUZLtdH6ZQKoLYOZVj/DzUUbpdi3BNHH4FTF1rjROYphPZJHU9hwqEBk2J9fli49iBkjYC7n5Nsx+i/5HvFqFo8yd4CKIxtfeOwJ4xtjzr1ozZ8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=06bL+LdkfNW7a7Gv5btDW3xq5bEDILrWgnjUSJeHkuo=;
 b=oEY1jqQ1QngPxi2GKWkkEp5xkL3pO0SIaxgX3jF4bRtoZ/y6+x3Aey4iO6nhD4FlL0VxUG9c9TzqcGFtayqe/JXpm+Drg15++jDdfaeVNtG3w33KDT204bkSu50hNfpVxUaK16JN7aAbJQKIP0RnUh/KHXHlq1Fe3xfrBOEJQ5BuziHKLkUhyeqjH6aaq6saaD4sV7wVkqHuKWvi/AdJvPGSffI3R23D/ZPQBXMmlWQrZFYcMKqn4b/27jA4KKvqej337K9rLFsAF3NURdWeVX4JULdghPiXdGPVojDqNanw28BAHSlL0vyj0zyGt8m360bWsimr6nLx1lSwKroXpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=06bL+LdkfNW7a7Gv5btDW3xq5bEDILrWgnjUSJeHkuo=;
 b=JdKCF7LM7HQuUYBIJnojH6EtIK8scR17Hi60b3urlRfkDbwcFgD3NwPKSaPLWbGxhO2NFI+s/+iu5S731L5AMXvXIPARpKnuriiVGj8tvapNt0IqmHyGKkwnSNoNIlyhRPekVrr0A4pIAFDWDHalNNPk6Qy5+JxU3kd9hp6+8VY=
Received: from MWHPR11MB1245.namprd11.prod.outlook.com (2603:10b6:300:28::11)
 by MWHPR11MB1919.namprd11.prod.outlook.com (2603:10b6:300:106::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.14; Mon, 13 Dec
 2021 07:51:27 +0000
Received: from MWHPR11MB1245.namprd11.prod.outlook.com
 ([fe80::9dd3:f8f0:48a8:1506]) by MWHPR11MB1245.namprd11.prod.outlook.com
 ([fe80::9dd3:f8f0:48a8:1506%12]) with mapi id 15.20.4755.025; Mon, 13 Dec
 2021 07:51:27 +0000
From:   "Liu, Jing2" <jing2.liu@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jing2.liu@linux.intel.com" <jing2.liu@linux.intel.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>
Subject: RE: [PATCH 10/19] kvm: x86: Emulate WRMSR of guest IA32_XFD
Thread-Topic: [PATCH 10/19] kvm: x86: Emulate WRMSR of guest IA32_XFD
Thread-Index: AQHX63yAx94sYKc+J0y0K5VRaG6gMawr58iAgAQoODA=
Date:   Mon, 13 Dec 2021 07:51:27 +0000
Message-ID: <MWHPR11MB1245F7730D9BF0DA251D302DA9749@MWHPR11MB1245.namprd11.prod.outlook.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-11-yang.zhong@intel.com>
 <fd16797c-b80f-c414-a731-0b9b73a3732e@redhat.com>
In-Reply-To: <fd16797c-b80f-c414-a731-0b9b73a3732e@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e381ab58-b5f0-450c-c5d9-08d9be0d5e73
x-ms-traffictypediagnostic: MWHPR11MB1919:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <MWHPR11MB19197372D7B5A9D800B7B1B5A9749@MWHPR11MB1919.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yyt5l4mYDY0YUUQd3QFeT64btZleITz5oXJ2RMrhbiuZS/PYTvegR7z823Zjhs4bv0N5qWVNmnsOxOHxzWsYeTanPVxk+fcPNIXsve5URt+r5ndhEvXYgzg93Hn3JdeMWEXgWF6DkB73t91/hqbTvZMcjg2eLwybt24dN4bNHaJm8poEYESMU7qc0PTMMJ3DUo9vF/jP0N4jMADSRnnoPJN8DT8kVW2lWeagmzzK+p5fCyYztDRN5b5c4RFL00pJZUxb3q6rmiVMztC3CVgDkNxwWOT3DsMiEBNBblCIPevaOxZQDDE97SSbmrhCl7+eUbeVP2XQReMqhS2KYQPqMdUZwK2yoZrHG0aXWbbW0FuHAUDt6oOyasv4NcWZHWgddRurr2ei56UbEGUe1omV5Ax6saUPR0geExlyhqGsDS2zvqTon6QnpOV7GxEOogmpsRa+elHPpA1SPiyuuF51SkohfiHLdfeBhdjrp7aXM9iWeaQ/She2FJt+HBnl6+5xhvLwi9L46JqoDF7KI6xylmtxcSi1kseTc1I+tvfboWl7gdV618+SUgQGCuJfAN0Ln1nkmTCy5GqaUKSwI+AZVPsbkP9PbsqGUo56BSZlKzwmn6CLEzjvuQQl09mVYU9bQAPehpSw0/L5C8iEGDxOGm83sqUjZPvDgVBwQoRf8uXPnC2XHHqFL0nOTfiWvXy2P4s+WhHxq9ILFv+02OzJQPTDAC8AwPPlr09IEv1znug=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1245.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4744005)(110136005)(316002)(82960400001)(54906003)(122000001)(38100700002)(52536014)(53546011)(6506007)(7416002)(66446008)(66556008)(66476007)(66946007)(86362001)(4326008)(921005)(76116006)(64756008)(2906002)(8676002)(9686003)(33656002)(508600001)(8936002)(55016003)(38070700005)(186003)(26005)(7696005)(5660300002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MFJncU1MZVhHUFNveUkzS3JMbXBlM2wrMkEyN0FlWUh4MmpETzdnYThQQVNU?=
 =?utf-8?B?RGwzcmxielJxeHZrMFJyWEhXOUxuZFExVW13N2FPNlM1d0NJSkdhTFVVTW0v?=
 =?utf-8?B?NmdJN2oybU9iN3hpbW1lR0dVMnI2MTl3K3dHQisvU0ZrNnRXRWZNd29ObU9p?=
 =?utf-8?B?ZzU3SG1hOHplTm1SQklpbmZGZHRiMW52L25DUXFleE9rNzFuRjY3L3dnRjRD?=
 =?utf-8?B?dGNLOFlBRVBqbmFsK25qd3hpME56MTFEMURhVzN0UjAwcDF2U0JvbHltUHlK?=
 =?utf-8?B?d3gxRXZpd2pUVnpSZzdiQU42cnQ0YmZKaXJudys2RjVONlJtTi9GYnhpb0Nk?=
 =?utf-8?B?VGk1Znp0VVN0RzJEQkduYzlPaHo4TFF0czd6bzhkTmRPb0x5Y3hyZElvbXEx?=
 =?utf-8?B?V2JDREd0a3NVcCtlbys4bkxJc3hBZXRXMGh5NDdqcG0wN3djcW9GSys5UCtH?=
 =?utf-8?B?cWYzNVh0dU5id0RBbGt2ZWNHTUltQWtqcVNRK0lHS3NMYnBHTHBWMFF5NVpB?=
 =?utf-8?B?MjZqczFxQ2gzRUdoME5WOTlGenEzQ2MydzNub0lqcnZ3TzNjLy85TzJ2NE5J?=
 =?utf-8?B?Mm1xb0R0M09sK2lzWXpjRXNKckFUcEEybjZieXNHVXNsRXRFaVFTeXNWMkdI?=
 =?utf-8?B?VVF4Y2JNYnBaek5RWncrVW1YajYvSkZ4b2dUYmw1dXRDM1BJTFpJbHBVMEdo?=
 =?utf-8?B?cDl1K295ZnZEamdVbktrNjFjV3FlUlV2RGZSUEV5Qkpsb05xZWJNcWhPWWFW?=
 =?utf-8?B?TnYyUVNjVFdNdkhCczF1OG8vc2tNaU1BV2VieEpBbFNHYlhqd1pIZDJjWHIv?=
 =?utf-8?B?dm1MVndmTFFZY1JZcTV6Ynd5dGdGWHROWnlROWE1OWJkUXJoTTlVSkpzaWxa?=
 =?utf-8?B?dWlUUUNEMU9yWXh6SnZVVkpBdm9TenlyeEVydzRXRStJaFFDb1R6UVY4WFRS?=
 =?utf-8?B?TmlUR25RZGxIWnFEeitPRUpULytnMVkyM2NqdWZobnh4cVV1cGpVZHVFRE01?=
 =?utf-8?B?eURnVU9Sa1NhTnZZd2tYV0FqK2pocndNYzJrZm1HL2tRUlcveU4xQmNrTWRk?=
 =?utf-8?B?Z2NlMHNlRFZ1UHZEM3ZYbTR6LzBRYW9Vc2NzZ2dlcGRBUXlydGg3TTVXSVI1?=
 =?utf-8?B?YlFUcis2LzN4dGRTVFdvc0hVTXU0c0g4RTVKNlY5aW1sUUc5SCtYRnQ1Kyt1?=
 =?utf-8?B?Z2lyMmFoZ1Fkb3RRakJsUURITE5HbTVKMEZkc09VQUtGRTBLMnlMeFNEVDlW?=
 =?utf-8?B?ZWc3Q2hmdEVaNFhqUk1OTU9vWk5VMUs5cmkvdTZhZWJ6cENUSEZPbUFaQlg1?=
 =?utf-8?B?ZFU0ZUkxdXIwd040RWgrSnNIK2tLSFZGU09BNVJadDBwVWNicjd6NnBZeFpy?=
 =?utf-8?B?dTdmUExvRnZGaE1YSElYcUZzdXZyaWRYSndoNE9VRlJmbThiVDdMTC9TYjN2?=
 =?utf-8?B?MzEzVWZzSWhSZ05TL29LODJSTDZZcU9zMkJiVWdEejUvSi9HdXcvZitLcGYy?=
 =?utf-8?B?RlNMYzFuZG9peFVsMnlkdVJyenJlc1dFOGhxYUE1UUZsU2F3QUxSRmg5REx3?=
 =?utf-8?B?UjBLczVWa0J4SDJqdjl3YkY1THlVaUhNeEZFbUhCZmU1eVZhazVQaUFEOFdD?=
 =?utf-8?B?dENYc0pVVVVYM0hRaWNZSVkySklCZ05Ja0w3ZkdRZStrSGpTcCtja0x0aVFr?=
 =?utf-8?B?V1dsanE4SGNDUStTY0kxcHY3bElocWRZbnkrL2Y4VWtLbW1XVDArRnFrSzZF?=
 =?utf-8?B?MFprRStkc2Q4OUtBUlozVEtuSFBpa2NiWTJydXpUR3pib3I1a0VpMER5VXNj?=
 =?utf-8?B?VkhFNWRiMUx6TENDMENmaGh2K241YXV3bXdEeFFGWnJLRFRJNzg0eUhpQ1Ez?=
 =?utf-8?B?ZDlvNW14ekhZVGVEaVh3cmx3azVudVA0SUtwSlZQZ20vdVI1U1dnS0kxNGRr?=
 =?utf-8?B?OG55bmh2RGpTSkIyU3B1TzJtcE0xWFREWHFPMXJZcjRpQ09XaHZsVmxaSXdG?=
 =?utf-8?B?MUdvVHNIQStnUjZ6d09oSXRJblNwb2ZyR1VrbTVYUEV4bkFhT0xJN2drcWc1?=
 =?utf-8?B?ZDVDMU9XeWV5bFBDTlRrN0pYNHRJV09xUHY4Q2ZvZTZyZ3JzNXVUS2JRaThz?=
 =?utf-8?B?UmgwZWloWVBwVy9CMWI1bitURngrY0dGbkppU3h0U2JtT3VGYUNjSWg2ZnRy?=
 =?utf-8?Q?O/SLBKH0ersrrMp1WOdYKN8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1245.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e381ab58-b5f0-450c-c5d9-08d9be0d5e73
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2021 07:51:27.5464
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0uRnuwQ8oFtoKhqL8DYqVA91zfdr2mJ9ro5CpNJy8GWmVERwRHOWMsNHVbxURhiEFfwHdnxHJgtvl75EcPC2WQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1919
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMTIvMTEvMjAyMSAxMjowMiBBTSwgUGFvbG8gQm9uemluaSB3cm90ZToNCj4gDQo+IEFsc286
DQo+IA0KPiBPbiAxMi84LzIxIDAxOjAzLCBZYW5nIFpob25nIHdyb3RlOg0KPiA+DQo+ID4gKwkJ
aWYgKCFndWVzdF9jcHVpZF9oYXModmNwdSwgWDg2X0ZFQVRVUkVfWEZEKSkNCj4gPiArCQkJcmV0
dXJuIDE7DQo+IA0KPiBUaGlzIHNob3VsZCBhbGxvdyBtc3ItPmhvc3RfaW5pdGlhdGVkIGFsd2F5
cyAoZXZlbiBpZiBYRkQgaXMgbm90IHBhcnQgb2YNCj4gQ1BVSUQpLiANClRoYW5rcyBQYW9sby4N
Cg0KbXNyLT5ob3N0X2luaXRpYXRlZCBoYW5kbGluZyB3b3VsZCBiZSBhZGRlZCBpbiBuZXh0IHZl
cnNpb24uDQoNCkknZCBsaWtlIHRvIGFzayB3aHkgYWx3YXlzIGFsbG93IG1zci0+aG9zdF9pbml0
aWF0ZWQgZXZlbiBpZiBYRkQgaXMgbm90IHBhcnQgb2YNCkNQVUlELCBhbHRob3VnaCBndWVzdCBk
b2Vzbid0IGNhcmUgdGhhdCBNU1I/ICBXZSBmb3VuZCBzb21lIE1TUnMNCiAoZS5nLiBNU1JfQU1E
NjRfT1NWV19TVEFUVVMgYW5kIE1TUl9BTUQ2NF9PU1ZXX0lEX0xFTkdUSCApIA0KYXJlIHNwZWNp
YWxseSBoYW5kbGVkIHNvIHdvdWxkIGxpa2UgdG8ga25vdyB0aGUgY29uc2lkZXJhdGlvbiBvZiBh
bGxvd2luZw0KbXNyLT5ob3N0X2luaXRpYXRlZC4NCg0KaWYgKCFtc3JfaW5mby0+aG9zdF9pbml0
aWF0ZWQgJiYgIWd1ZXN0X2NwdWlkX2hhcyh2Y3B1LCBYODZfRkVBVFVSRV9YRkQpKQ0KICAgICAg
ICByZXR1cm4gMTsNCg0KDQogSG93ZXZlciwgaWYgWEZEIGlzIG5vbnplcm8gYW5kIGt2bV9jaGVj
a19ndWVzdF9yZWFsbG9jX2Zwc3RhdGUNCj4gcmV0dXJucyB0cnVlLCB0aGVuIGl0IHNob3VsZCBy
ZXR1cm4gMS4NCj4gDQpJZiBYRkQgaXMgbm9uemVybywga3ZtX2NoZWNrX2d1ZXN0X3JlYWxsb2Nf
ZnBzdGF0ZSgpIHdvbid0IHJldHVybiB0cnVlLiBTbw0KbWF5IG5vdCBuZWVkIHRoaXMgY2hlY2sg
aGVyZT8NCg0KVGhhbmtzLA0KSmluZw0KDQo+IA0KPiBQYW9sbw0K
