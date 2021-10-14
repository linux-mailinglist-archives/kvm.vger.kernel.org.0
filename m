Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7EE42D482
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 10:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhJNIIQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 04:08:16 -0400
Received: from mga04.intel.com ([192.55.52.120]:31691 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229970AbhJNIIP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 04:08:15 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10136"; a="226397199"
X-IronPort-AV: E=Sophos;i="5.85,372,1624345200"; 
   d="scan'208";a="226397199"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2021 01:06:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,372,1624345200"; 
   d="scan'208";a="548429700"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga004.fm.intel.com with ESMTP; 14 Oct 2021 01:06:11 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 14 Oct 2021 01:06:10 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 14 Oct 2021 01:06:10 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 14 Oct 2021 01:06:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hgqFJrmSKHAMqa+NYqsbbLFSS1oaES387Qnf5TXUb7ol8XEHTRmZuAAeKaN2WfVLk10rCHCLUv/xd4jCkfaDfR6z3RGwv/vf8lUDajNVIWlWA6suQF44g0zc61pW4b0JVO7GLM4PpPtud7eKvOI5hXG5/sLq35o6VvASmmZo6Vbc7JNhXaSy6MJPqeohgYq6FCN8MEP71FGSu9jtCOnw/k3yyuTQcB9Js9KWBhKeFt23Q22IEGdg8ubk9pxLWS2hY8BO082xCypJMRgpkrImovhPfM/x6Q8J8+1/VsZZWCO0lBOOxmVuSG5LcFBkZBlJJIMfwZ7sKVel1kdg8Fc7Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RO8PjDcMULedjn3dbjnDKYwTkT5ktHpZtD4bom0+3A4=;
 b=WfoQBn+rdSnyLxuVqi077ZRh024YjXmY1/DGa7SHHFZg3CMZ0K0QruZ1NkV+wx7r8icarr/gjrZ5/F8h7GS9wRdcRFd95MFZsT25qG/wAj+WXS0n4HWMLzqUgHLTdkJCUuddFvhRaNh4sJakgZV1pEy5/q77D0+Bl9YMog7oPN4wGBl/65WqFdLIlaSpwKCMFDRQjpzUur3bflslpCx7B1RR6ncivIoaR3IGMisRTEKo7j8Pne5rLUh/8lsDcV4h9z3XNDfdkJauKE4ap+l38/0nKcxaLDZAE47gQkSkUrME9R7YJVUyzA9KRxtGhrUr1ubQk/+QFCAMyvXdCcqL3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RO8PjDcMULedjn3dbjnDKYwTkT5ktHpZtD4bom0+3A4=;
 b=CSwxnKJv3kA4gvd/uYUCxfDmAXPsvDKQ2RGvWTiAh20ojp3Ik2QqvUW1Ufa0yQ3oJk2nizpJ8orKmo3Iqq1/ss5fbak9Mh6DOIQA83EN3J2wra7GXqffT6f+ccuCcZnw783/YNuG2Lvivizuch+HRYLVnY2pLDRJO9ctq+9dIXc=
Received: from BL0PR11MB3252.namprd11.prod.outlook.com (2603:10b6:208:6e::18)
 by MN2PR11MB4383.namprd11.prod.outlook.com (2603:10b6:208:17b::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Thu, 14 Oct
 2021 08:06:07 +0000
Received: from BL0PR11MB3252.namprd11.prod.outlook.com
 ([fe80::7d33:5c44:70ad:f165]) by BL0PR11MB3252.namprd11.prod.outlook.com
 ([fe80::7d33:5c44:70ad:f165%7]) with mapi id 15.20.4608.016; Thu, 14 Oct 2021
 08:02:23 +0000
From:   "Liu, Jing2" <jing2.liu@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Arjan van de Ven" <arjan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>
Subject: RE: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
Thread-Topic: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
Thread-Index: AQHXv42x8Iw8v1bdT0WqN+QXiZLaIqvQcYTggAAF7ACAAAOKwIAAIoqAgABafQCAARh7AIAACH/A
Date:   Thu, 14 Oct 2021 08:02:23 +0000
Message-ID: <BL0PR11MB3252511FC48E43484DE79A3CA9B89@BL0PR11MB3252.namprd11.prod.outlook.com>
References: <871r4p9fyh.ffs@tglx>
 <ec9c761d-4b5c-71e2-c1fc-d256b6b78c04@redhat.com>
In-Reply-To: <ec9c761d-4b5c-71e2-c1fc-d256b6b78c04@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 397905d0-ebd1-4ef4-fa95-08d98ee8f4b4
x-ms-traffictypediagnostic: MN2PR11MB4383:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB43834691F5FACBBBDC222AD3A9B89@MN2PR11MB4383.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: txFgroDeyZ6Y/MCmPwHirOm+dplnCV2ZfSdHZPVYssVTn6GYWR5rf9zAlq9C9YnAM29mvSeyX4N9UPfIkJH/yU1RXHxdl3b8Y9PFSUj/WbjpMF37hi98GgEEPJUKQACnYsaTM681WP1M85HoOW/+WKb0knDNWUzLXrO5mP+rfAPoqnucb+PRvzIgujlLt1+vpYowsd0qtHu5R56Y43Obnr8960hy5HLxshRvJ9Xl3sJ69DNlKYa3vev6nd8w9k63UqOMvrhSYLVDRSqrw+U6PrrUV5pTytdvsgKJPNkRecrX8PshUEx5e9Gb827Qpd0wLJ9OTEPIRFRmnlTWo3JsKzg173HOCp5lYEgRpxRVGmqmpbL1ZeGFnAmIgdKSIo8paPEQmv8/MzgENlSLNV2AM+MiQ95nAUMqX/syugbr6WTXYLf6jy5k+vOFccDf5VwezeY+frylA6veFF8OCZlUi42rZ5L+rGtzz8x7ZKNNw27Dnu48rEvMm5O5g+zULmKRwngqThioxYDbG5tjBXuY6Jw6/x3IzIoUjBRWrrmHp/+ob+MicrvnN7/cbBXA5m9AcFQ5e34gR7ZHne6Ua/YchwUMPDXMEFysv9JRI+7tPjMm36/nBLlZXElvOe4CvHVxIBMparQrfrEQ1EuGqe2/afNzramw7jrTdD1epNS3ExF1OkXhIxziA6cMukV9i2qntWTBugdyfuGTMNCX1qR7Zw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3252.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(110136005)(122000001)(86362001)(66556008)(6506007)(52536014)(5660300002)(9686003)(7696005)(66446008)(26005)(38100700002)(54906003)(53546011)(2906002)(66946007)(76116006)(508600001)(71200400001)(55016002)(64756008)(8676002)(33656002)(83380400001)(82960400001)(38070700005)(8936002)(66476007)(316002)(186003)(7416002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M01MU3dob1RwY0RFeUsxem9icGhEY0orSUZQdklBZ05yV0JQMFdoa0p5cXVn?=
 =?utf-8?B?SHRMZVFLbXVmTEg4eWlLdEZBdDk2Z1NCSy96Qm9nRndCQlUwcUtSdGwyRmli?=
 =?utf-8?B?Q21ueXZpcEFTUWQwdlc2aFNJSUpaby9USHZRY0ttOTFjVkxCV0VRUUR5ekJt?=
 =?utf-8?B?M0FXTVYwNlNjaTdxQjRYL1ZHNjloUUdrRVhqVjJGcGJtR0RqY09abzJ1T3Ay?=
 =?utf-8?B?YUhheURiM3VMWVViYkNJVUlVVjk4Q052V1FkSFdqdGxTR3FlclNJYWtYR0xw?=
 =?utf-8?B?TS9KR1F0UUJwRWtYYlppOFBqYTRBM01ObjlNeVJSUVpESFcxSUpBZ09EV3g3?=
 =?utf-8?B?WU1Id1FuSHJoYUFwdTB1bjFhbFgzN0dXOFZVSWJ4SlUzMStLc3FoNyt4OHM4?=
 =?utf-8?B?ZHBWZFh3OXFSVFVnMkZLaElEUEoyREZ2V0pYY1Mvd21WUW5rMU9ua2hob2RB?=
 =?utf-8?B?UmdHQnR2THVINERqUlNOczdMdkFCMUQwQmNEYkY0OHhYbEpsaFVKMFJUWXd5?=
 =?utf-8?B?a291cU5aaG9sd3RubUZXWGZ0eVRnTDhEdFAvbWNyOEdFOGh3d2N2L05jOFBS?=
 =?utf-8?B?c0ZqSFhTOVBBWFVDZXBqdkQrRjZXNTBqSVhVSG41QlB5emRCWWxZZzd3cmU0?=
 =?utf-8?B?L0N4RlBUSVdsdkRDRUZwa2krUXNuQzEvVjFvYzg1Kyt5T0pBNXd2Slk4MkpR?=
 =?utf-8?B?eCtVSzkyUEI4MzIvRHBGKzl6N3VCMW9Sd1VGU3pqMXB0Q1VaZm4rK216TGJ1?=
 =?utf-8?B?R1pRZityWG5PVlNWV3BacS9Qd0hhUlpQcW1jOFFMVnhCOUVXQTZkRXZnWTly?=
 =?utf-8?B?dzU2eUhvMUgwR3BhVEJLVHB6QjNwVUFyRkpyTFB2aDdld2l2Zzg5RmZVNktC?=
 =?utf-8?B?QXlJQzA0ODZwQ2lDcHNJZlY0cVN5NTFBQ3prQlU1WXlETmFLZldjVDVXRGVq?=
 =?utf-8?B?NGM1dWRvQnJQOGtvSXZ0dFdZendHQkpiUnVnZzRDUTBnTzJYUVkxUDNkUU0y?=
 =?utf-8?B?b0lQWEUwQ1BST2huTHlOOGZxVmpMNXFYVnZFeDNCZHA3UzlySU9mUkhKNFRk?=
 =?utf-8?B?cWNhdFVwbzl0enlHSmNUVDVZY0FrdnNXSUhMaFYvNEJ1OGplaW9lei9OWmJN?=
 =?utf-8?B?aG9Hc1U0YVBnRVJwUlo5RG9VTmFaRXlaak1uSnRNRGFVNXNuUVFkb3RpbXJ5?=
 =?utf-8?B?d3FYeEdvVW5EbjlYalhjNHlwOGx2djZKRHRSWVFVRmttUUhJc3l1U3RZYmdx?=
 =?utf-8?B?VHJPNktzNFU1Y0ZYMEM4N1pHQjNyNm13bzBsMzhSa05jbitPa05mOXpPT25Z?=
 =?utf-8?B?VWorRzQrUU1FejRCdlo4cWRsOG96K2cvbWh3QlRGUTZVa2lYa2lpUnc5YUVz?=
 =?utf-8?B?S1hiZjJRaDd0Y3dBM0xMdlVHRXhvU2tBUUUvQno4MW5DM3pMay9TOUlXcUg4?=
 =?utf-8?B?UFdLUGVtdnZHYklGOVU4d1JoY3FxbXNjMGpKdTd1TTlYUHRzdDd0cFVKUVRu?=
 =?utf-8?B?MHpic0VyS1d2N282MzZqQVBBU2pPdTd3Mk9ncmlvK0xkSUV5THRNSldiN244?=
 =?utf-8?B?dWE0OXpzc2pYaTYyd2hTY3dDY0RmdGw5VXZiZ3R2bjA1TlBMUzYrWm9YU2xS?=
 =?utf-8?B?WWpZSEpJdWdHZTl5dGczdVJxTmhvdHhxVVVVMjZZc2puVDhWWWUySzBMNXVS?=
 =?utf-8?B?bVA0VCt4aUFKSHN1cFFkSFNhcVRycm5IUGFsT1lpODY4aFRDaDA3Sjg1R3Ax?=
 =?utf-8?Q?NoOO3haPcKN6Rui8B2IxoUpWcZw2DyUJeeMahuf?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3252.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 397905d0-ebd1-4ef4-fa95-08d98ee8f4b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 08:02:23.7214
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QxIRf6GJZC/0YM7ufjyMxDcx4ffTGL1ByEH2SQULu471UUjE/0hRESt8P7rxUeXZYD546zDvUNlQgzIhMur0cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4383
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMTAvMTQvMjAyMSAyOjUwIFBNLCBQYW9sbyBCb256aW5pIHdyb3RlOg0KPiBPbiAxMy8xMC8y
MSAxNjowNiwgVGhvbWFzIEdsZWl4bmVyIHdyb3RlOg0KPiA+PiAtIHRoZSBndWVzdCB2YWx1ZSBz
dG9yZWQgaW4gdmNwdS0+YXJjaC4NCj4gPj4NCj4gPj4gLSB0aGUgIlFFTVUiIHZhbHVlIGF0dGFj
aGVkIHRvIGhvc3RfZnB1LiAgVGhpcyBvbmUgb25seSBiZWNvbWVzIHplcm8NCj4gPj4gaWYgUUVN
VSByZXF1aXJlcyBBTVggKHdoaWNoIHNob3VsZG4ndCBoYXBwZW4pLg0KPiA+DQo+ID4gSSBkb24n
dCB0aGluayB0aGF0IG1ha2VzIHNlbnNlLg0KPiA+DQo+ID4gRmlyc3Qgb2YgYWxsLCBpZiBRRU1V
IHdhbnRzIHRvIGV4cG9zZSBBTVggdG8gZ3Vlc3RzLCB0aGVuIGl0IGhhcyB0bw0KPiA+IGFzayBm
b3IgcGVybWlzc2lvbiB0byBkbyBzbyBhcyBhbnkgb3RoZXIgdXNlciBzcGFjZSBwcm9jZXNzLiBX
ZSdyZSBub3QNCj4gPiBnb2luZyB0byBtYWtlIHRoYXQgc3BlY2lhbCBqdXN0IGJlY2F1c2UuDQo+
IA0KPiBIbW0sIEkgd291bGQgaGF2ZSBwcmVmZXJyZWQgaWYgdGhlcmUgd2FzIG5vIG5lZWQgdG8g
ZW5hYmxlIEFNWCBmb3IgdGhlDQo+IFFFTVUgRlBVLiAgQnV0IHlvdSdyZSBzYXlpbmcgdGhhdCBn
dWVzdF9mcHUgbmVlZHMgdG8gc3dhcCBvdXQgdG8NCj4gY3VycmVudC0+dGhyZWFkLmZwdSBpZiB0
aGUgZ3Vlc3QgaXMgcHJlZW1wdGVkLCB3aGljaCB3b3VsZCByZXF1aXJlDQo+IFhGRD0wOyBhbmQg
YWZmZWN0IFFFTVUgb3BlcmF0aW9uIGFzIHdlbGwuDQoNCkZvciBwcmVlbXB0aW9uLCBpZiBndWVz
dF9mcHUgWEZEIGlzIHVzZWQgYXMgS1ZNIGludGVybmFsIHZhbHVlLCB0aGVuDQp3ZSBjYW4gc2lt
cGx5IHNldCBjdXJyZW50LT50aHJlYWQuZnB1IFhGRCB0aGUgc2FtZSBhcyBLVk0gaW50ZXJuYWwN
CnZhbHVlIGluIHZtZXhpdCBzbyBrZXJuZWwgcHJlZW1wdGlvbiBjYW4gcmVmZXIgdG8gaXQuDQoN
ClRodXMsIEkgdGhpbmsgdGhpcyBpc3N1ZSBkb2Vzbid0IG11Y2ggZWZmZWN0IGlmIGVuYWJsaW5n
IEFNWCBmb3IgUWVtdQ0KRlBVIG9yIG5vdC4NCg0KPiANCj4gSW4gcHJpbmNpcGxlIEkgZG9uJ3Qg
bGlrZSBpdCB2ZXJ5IG11Y2g7IGl0IHdvdWxkIGJlIG5pY2VyIHRvIHNheSAieW91DQo+IGVuYWJs
ZSBpdCBmb3IgUUVNVSBpdHNlbGYgdmlhIGFyY2hfcHJjdGwoQVJDSF9TRVRfU1RBVEVfRU5BQkxF
KSwgYW5kIGZvcg0KPiB0aGUgZ3Vlc3RzIHZpYSBpb2N0bChLVk1fU0VUX0NQVUlEMikiLiAgQnV0
IEkgY2FuIHNlZSB3aHkgeW91IHdhbnQgdG8NCj4ga2VlcCB0aGluZ3Mgc2ltcGxlLCBzbyBpdCdz
IG5vdCBhIHN0cm9uZyBvYmplY3Rpb24gYXQgYWxsLg0KPiANCg0KRG9lcyB0aGlzIG1lYW4gdGhh
dCBLVk0gYWxsb2NhdGUgMyBidWZmZXJzIHZpYSANCjEpIFFlbXUncyByZXF1ZXN0LCBpbnN0ZWFk
IG9mIHZpYSAyKSBndWVzdCBYQ1IwIHRyYXA/IA0KDQpGb3IgdGhlIHR3byB3YXlzLCBJIHRoaW5r
IHdoYXQgd2UgbmVlZCBjYXJlIGlzIHRoZSBzYW1lOiBhKSBhbGxvY2F0aW9uIHRpbWU7DQpiKSBs
YXp5IHBhc3N0aHJvdWdoIHRpbWUgd2hpY2ggcmVsYXRlZCB0byBYRkQgaGFuZGxpbmcgYW5kIHZh
bHVlcy4gQmVjYXVzZQ0Kd2UgZG9uJ3Qgd2FudCBhbHdheXMgcmRtc3IgYW5kIGNsZWFyIFhGRCBp
biB2bWV4aXQsIGFuZCBkb24ndCB3YW50IHRvDQp0cmFwIGRpZmZlcmVudCBYRkQgc3dpdGNoaW5n
IGluIGd1ZXN0Lg0KDQpGb3IgMSksIFFlbXUgbmVlZCBwcmN0bCgpIGFuZCBpb2N0bChFTkFCTEVf
RFlOX0ZFQVRVUkUpLg0KQnV0ICp3aGVuKiBkb2VzIFFlbXUgZG8gaW9jdGwoRU5BQkxFX0RZTl9G
RUFUVVJFKT8gSSBtZWFuIGlmDQpndWVzdCBYQ1IwIGRvZXNuJ3Qgc2V0IGJpdDE4LCB0aGVuIEtW
TSBkb2Vzbid0IG5lZWQgYWxsb2MgMyBidWZmZXJzDQphdCBhbGwuDQoNClRodXMsIFhDUjAgdHJh
cCBpcyBhIHNpbXBsZSB3YXk/DQoNCk1lYW53aGlsZSwgZm9yIGxhenkgcGFzc3Rocm91Z2gsIGRv
IHdlIHdhbnQgdG8gbWFrZSBpdCB3aGVuIGd1ZXN0DQp3cm1zciB0cmFwIChpLmUuIGd1ZXN0IGNo
YW5nZXMgWEZELCBub3QgaW5pdHMgWEZEKSBpZiB1c2luZyAxKSBxZW11J3MNCnJlcXVlc3Q/ICBP
ciB1c2luZyAyKSB2aWEgWENSMCB0cmFwLCBkaXJlY3RseSBwYXNzdGhyb3VnaCB3aGVuIFhDUjAN
CnRyYXA/DQoNCj4gPiBBbnl0aGluZyBlbHNlIHdpbGwganVzdCBjcmVhdGUgbW9yZSBwcm9ibGVt
cyB0aGFuIGl0IHNvbHZlcy4gRXNwZWNpYWxseQ0KPiA+ICNOTSBoYW5kbGluZyAodGhpbmsgbmVz
dGVkIGd1ZXN0KSBhbmQgdGhlIFhGRF9FUlIgYWRkaXRpdmUgYmVoYXZpb3VyDQo+ID4gd2lsbCBi
ZSBhIG5hc3R5IHBsYXlncm91bmQgYW5kIGVhc3kgdG8gZ2V0IHdyb25nLg0KPiA+DQo+ID4gTm90
IGhhdmluZyB0aGF0IGF0IGFsbCBtYWtlcyBsaWZlIHdheSBzaW1wbGVyLCByaWdodD8NCj4gDQo+
IEl0IGlzIHNpbXBsZXIgaW5kZWVkLCBhbmQgaXQgbWFrZXMgc2Vuc2UgdG8gc3RhcnQgc2ltcGxl
LiAgDQpJJ2QgbGlrZSB0byBjb25maXJtIHdoaWNoIGlzIHRoZSBzaW1wbGVyIHdheSB3ZSdkIGxp
a2UgdG8gOikNCg0KVGhhbmtzLA0KSmluZw0KDQpJIGFtIG5vdCBzdXJlDQo+IGlmIGl0IHdpbGwg
aG9sZCwgYnV0IEkgYWdyZWUgaXQncyBiZXR0ZXIgZm9yIHRoZSBmaXJzdCBpbXBsZW1lbnRhdGlv
bi4NCj4gDQo+IFBhb2xvDQoNCg==
