Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F142342BCBC
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 12:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239318AbhJMK12 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 06:27:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:53087 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239285AbhJMK11 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 06:27:27 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10135"; a="224836558"
X-IronPort-AV: E=Sophos;i="5.85,370,1624345200"; 
   d="scan'208";a="224836558"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2021 03:25:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,370,1624345200"; 
   d="scan'208";a="626298553"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 13 Oct 2021 03:25:23 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 13 Oct 2021 03:25:22 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 13 Oct 2021 03:25:22 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 13 Oct 2021 03:25:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jvjl3xDpIddNSHnaEOpOHYZrn/UnM9tft31lHZMV9/uFrcLX9m/9JBla8gi91An2KYG80LG/x7mP5lOFO16syAMvPD7jUI/a+h8RFyiONoFkFBF+oNFzlPZmlyBW0migV/ET2E9czW8keFnmxS8ojsdZa8j/lUztsRqHiPiZuC7HAF773S6GbRWlrRTvAv/HwY45VHRo750OKCBXRqFkQEJpJ9nEwRa2yNJW5OcTXBTwEF0za5dgEBbUaAJuz9AorNips8A+LNt1hvsmCj8h9PgkmuvcCxvKdh/jfbDoAiE8FuGAbzQ0GAO50U0e5Dr9DYYMDWadmgQwgfIsC9Sd0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ME3a+MgEftg4jE4OK0rpyyagCVA3WYVGtjH7s3Vjy1I=;
 b=ImeH4jpzDgXoCQqBf1/kQhHRp89Ug6CsoI92yNy7Q0Em16h8ffXngcSVdMQz8EFn6EovZT9WW7HubI5ZojST6YRGajtmDgqqLWBOw9T4Hw8ct2+Tn0Br68nVqoMPcinRDObA2X33XROBDC9YYrD6bm5CNACdRY03OHLyu0sBo+dyfZvBWyQT3ytbHJSyYddkSboe/AC0tnSC/ond17hzxH+AXA0UZ8HMEpibIOg1ycIZo3jYywkw4V6SbLBJ6dvLJtZCSnYFM5aXXF1w9T3/jB0e1pQYOjHei7UVPAGcFcvqSdNCOO/1siRGkyuuULSuun1KIJDquIa/9RKEbZgXjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ME3a+MgEftg4jE4OK0rpyyagCVA3WYVGtjH7s3Vjy1I=;
 b=cE3g3tnI9DheBKU2GrL2kba/BxAwoEspT4NhUUqhB4eInW4LbV6Z9qlG0VwKZ1YjMdR+0mc2ZBTPIV9LrUffmS6381JKFqOqZEbYcya0DcL02hd/TIJ1PMDDmO0TWFRpRSHk3NbE+z7PIRCN93Swi3cWKFqyRhX4ogV8Bd7XRvM=
Received: from BYAPR11MB3256.namprd11.prod.outlook.com (2603:10b6:a03:76::19)
 by SJ0PR11MB4816.namprd11.prod.outlook.com (2603:10b6:a03:2ad::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Wed, 13 Oct
 2021 10:25:19 +0000
Received: from BYAPR11MB3256.namprd11.prod.outlook.com
 ([fe80::d9e1:ed97:d0d9:d571]) by BYAPR11MB3256.namprd11.prod.outlook.com
 ([fe80::d9e1:ed97:d0d9:d571%5]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 10:25:19 +0000
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
        "seanjc@google.com" <seanjc@google.com>
Subject: RE: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
Thread-Topic: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
Thread-Index: AQHXv42x8Iw8v1bdT0WqN+QXiZLaIqvQcYTggAAF7ACAAAOKwIAAIoqAgAAMLcA=
Date:   Wed, 13 Oct 2021 10:25:18 +0000
Message-ID: <BYAPR11MB325670EF536F5C4766C18D19A9B79@BYAPR11MB3256.namprd11.prod.outlook.com>
References: <20211011215813.558681373@linutronix.de>
 <20211011223611.069324121@linutronix.de>
 <8a5762ab-18d5-56f8-78a6-c722a2f387c5@redhat.com>
 <BYAPR11MB3256B39E2A34A09FF64ECC5BA9B79@BYAPR11MB3256.namprd11.prod.outlook.com>
 <0962c143-2ff9-f157-d258-d16659818e80@redhat.com>
 <BYAPR11MB325676AAA8A0785AF992A2B9A9B79@BYAPR11MB3256.namprd11.prod.outlook.com>
 <da47ba42-b61e-d236-2c1c-9c5504e48091@redhat.com>
In-Reply-To: <da47ba42-b61e-d236-2c1c-9c5504e48091@redhat.com>
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
x-ms-office365-filtering-correlation-id: 89aea544-3d10-4016-8793-08d98e33c18d
x-ms-traffictypediagnostic: SJ0PR11MB4816:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR11MB4816BCE723E08089A141C08AA9B79@SJ0PR11MB4816.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ovjwHOomCLltG9GA4tCF5uWiiOaUYp0pU/dIcZkGZaCtw5ammG5wPEHySH0UJbN//H+mdE0H8BAUrDzls/zHn1eVGYZZ+BYpXbnwUC6HMJXKnQOY3FPkJ4/0PhG3Wu4ddBvsv1iHOErRsSpQ1VjlIggwJwxxco4QtEwNW5YKuJAN7bQJGAK4O5t3znD/Zo2LjkXulzNkRxvkGky6j3B7kfJq2KDlLgp+Fhpq/GxWYQLKhuUaonQCtKNKz8dB4iwRE4GJOq4+BdO4DH7DIZLiOoy04ff+qXkKPRTGg+mgJsRE0Xaa8rZyiMA/bQOA/RCJGW+OU1IMfdS0G80O69DY25IBc7aX6r4oXuphzuU58YnQLF7jrO/r7k01PpRmSvpECnJpOAcV5MDDW6RbFLmIoevb/EWuirrFK7qN7B2PBtFqjfjW6KcV2dOKs9wvWfj1GoVU71IIPGSUR1vQpvO87lKS8blo1439CqVnx1iSd5HmoOnCjd2IssiMH1jRAw3VdR8MIZyJvTbdrui2LG/2/QERsG6W7Viaza+fSQgnTFBtZZzGDYS5z5J9XfXFaIn0scckF8QJ4db2oOVo6TNBrSPtnkjurFgkHmDpQnv/Iy7MkPf9NS/lMgyhMwACiWMXltzUADtuXfscsYGF94O57LAFBZFi4p/EwWOVa0mepzJBp7fVVB6Ee6bpvTU+qEpzV6G8++r4Q4a9R9Jm2/ygww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3256.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(8676002)(71200400001)(5660300002)(7696005)(8936002)(54906003)(9686003)(33656002)(86362001)(55016002)(26005)(52536014)(38070700005)(64756008)(53546011)(110136005)(38100700002)(2906002)(76116006)(186003)(316002)(66446008)(66556008)(508600001)(82960400001)(4326008)(122000001)(66946007)(6506007)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c0JOMW1TUHpOZ3VJdWZqcGJVbDZXM0FVcXVSdlE0U3FnM3dyWHFVZXRpZ05o?=
 =?utf-8?B?b0ovTlRYM2FDT2JQQ2pNOUVGd3ZFOGp3aWJoMitEaXJuQ3JIdFFCNmJLRWF1?=
 =?utf-8?B?YmhLVU4ybHVwTDhPVFM5VllsaVpKd210dWovQzVsNy9TNCtOeHhyR2dBc0da?=
 =?utf-8?B?bG5vaWh4c1VpYTUrWERCN2pMd290WURxMGorZENJUGx4eEp6YUdqT2JVRXl1?=
 =?utf-8?B?bUJSbjhXMm9IdUFpS3RCL2UvbXBKVGpFenNCNVNYSC90WDhLSmFxakxJMUk4?=
 =?utf-8?B?M3d6bTBGdjh2TVJBSGxHV0NZVTJNUXlvNEZYdE9tR0MwZUQxeU9xaWlzMFpZ?=
 =?utf-8?B?WlpORVNWQ2NDNklVWEF3QlpOLzNxalZqbEFNeFFqT3VMOEJCcURFTHBLY2Fp?=
 =?utf-8?B?OWlKY0x0RmNLdnU0cUpkUndXcTR3OUFEV05rYUFjUGtXVTJPWHVjNEI5RDg3?=
 =?utf-8?B?bTBtRURCL0ZULzlxK3BoUkMvV1FiTTVOQmtRc29DOE02QzJXbE1EZUdTcjhI?=
 =?utf-8?B?OFcwSXd5OUFTUzFObnlqMloxTHdtSHNFSXpwWXdxaE5uNE5GRkpoVUdrYzJr?=
 =?utf-8?B?YTAxZnlqNEQ2Z1h2NndxdW50Qy9FcjhYMmVtVWN3T2JUa1Z0M3VmblhsZXJS?=
 =?utf-8?B?TERESnZ5OFNTRHhlOFRjdEJOY08yRS9PRCswT2JUNzlnODJXdEJjZDVhSU5j?=
 =?utf-8?B?MzNoRU9mTEpmUjh2d3d3aTVxdXpybkxldGVOUjduSXBRc3V0eTRvdDZEUjNw?=
 =?utf-8?B?eTQvN0RPRlkrWERTU21vd1FLTmhTOWswdVd1UUpSSkJTYS92eFdLUWFmS3R3?=
 =?utf-8?B?d3hYUE1PWGQvTUlQcUU0TFArRU1OU0JETEVLNWoxMmd6Y21SZ2N2MksxcXJK?=
 =?utf-8?B?RHRPTXovL2huQ2FFa1hPZXRycFpqQkJoOTdOcTBWbTYzenBxNGZzb1RLdFE0?=
 =?utf-8?B?N3BFS1N5NTd5TThLTENJUU15dnFJeWZNT2hCeVBRMEhnSFVCL2ZzTmx1S1N5?=
 =?utf-8?B?QUlUOEMxTzNFNjgxbTJlTmYyOWFvVDRLVERRYnZQQ1JGQ0Jmc3F6Rnd3VFd3?=
 =?utf-8?B?c1ozMUNwNlRxd1QvOEVnNWZFakdtdjZsVGswSWsyYzJLUURCbVdPUFBESjEw?=
 =?utf-8?B?MlNKbTk4WVpaVUl4YXY3VzhHWmQ1aXo1Z2VNNWJycTVnNEhTRkF4UEVZak14?=
 =?utf-8?B?cXVMSmdpUGwwdkJaY3k1WFhwNlpFK0ZUK1UxV2hGQUxhWlVtSll5TUNxbEJu?=
 =?utf-8?B?UGV4c2d3eDFwd1BBU0xjbVlJQ2dMRml5KzFlZXBoQm1OU3lFaHFZeExYaUk1?=
 =?utf-8?B?Tm16aHVsU0hkVVJkay9SbnVXbFpkenRZRERIMG82L29iRldaa0dqODlQR3FT?=
 =?utf-8?B?eHNIR0tQM2V1WGpadVlIMzZyd0txb3ZRY3JYY20wNXZFM2taamFXeFh2a3B6?=
 =?utf-8?B?Q3dYUjltajJHT2dWLzlmbGIrMUpQclZmdWFDby9ZaUxiNno3S01NN3pTVEpB?=
 =?utf-8?B?WVdBdm54ZU5lalNERUpHNC9rYjVxQUlpWU45dmFtWDZKRWtOQjQxUlJvZTcz?=
 =?utf-8?B?TTRCWGRtRGdSNTlEcHlqeWdUMS9TSUloVUFSZU9lRm9lWFExZjY4aW9aZXRr?=
 =?utf-8?B?KzlHczNmVGg5ODNuQ3JBbEs2dnJrVC9jNGprYXVZQW9nRG44L1B5bUhjMnNr?=
 =?utf-8?B?K3cvMnBaN1RoZENLTWE5d2VkdHJ0UUlWM0JiWTZ3cXFjMCsxekU1N0tHaVYy?=
 =?utf-8?Q?N4uHXWCL/gHxkQY0/tgSiHhYqs5WDeZIrHDYgQB?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3256.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89aea544-3d10-4016-8793-08d98e33c18d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 10:25:18.9611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XlQmUBAbhAEUVv6nEX0PXt+X4ozJvQabcRCE+W2ISITZ6cTLorfdM7YR0faKFsotdsXsrGJz5r7yPr8rvzDN/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4816
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQpPbiAxMy8xMC8yMSAxMDo0MiwgUGFvbG8gQm9uemluaSB3cm90ZToNCj4gT24gMTMvMTAvMjEg
MDk6NDYsIExpdSwgSmluZzIgd3JvdGU6DQo+ID4NCj4gPj4gT24gMTMvMTAvMjEgMDg6MTUsIExp
dSwgSmluZzIgd3JvdGU6DQo+ID4+PiBBZnRlciBLVk0gcGFzc3Rocm91Z2ggWEZEIHRvIGd1ZXN0
LCB3aGVuIHZtZXhpdCBvcGVuaW5nIGlycSB3aW5kb3cNCj4gPj4+IGFuZCBLVk0gaXMgaW50ZXJy
dXB0ZWQsIGtlcm5lbCBzb2Z0aXJxIHBhdGggY2FuIGNhbGwNCj4gPj4+IGtlcm5lbF9mcHVfYmVn
aW4oKSB0byB0b3VjaCB4c2F2ZSBzdGF0ZS4gVGhpcyBmdW5jdGlvbiBkb2VzIFhTQVZFUy4NCj4g
Pj4+IElmIGd1ZXN0IFhGRFsxOF0gaXMgMSwgYW5kIHdpdGggZ3Vlc3QgQU1YIHN0YXRlIGluIHJl
Z2lzdGVyLCB0aGVuDQo+ID4+PiBndWVzdCBBTVggc3RhdGUgaXMgbG9zdCBieSBYU0FWRVMuDQo+
ID4+DQo+ID4+IFllcywgdGhlIGhvc3QgdmFsdWUgb2YgWEZEICh3aGljaCBpcyB6ZXJvKSBoYXMg
dG8gYmUgcmVzdG9yZWQgYWZ0ZXIgdm1leGl0Lg0KPiA+PiBTZWUgaG93IEtWTSBhbHJlYWR5IGhh
bmRsZXMgU1BFQ19DVFJMLg0KPiA+DQo+ID4gSSdtIHRyeWluZyB0byB1bmRlcnN0YW5kIHdoeSBx
ZW11J3MgWEZEIGlzIHplcm8gYWZ0ZXIga2VybmVsIHN1cHBvcnRzIEFNWC4NCj4gDQo+IFRoZXJl
IGFyZSB0aHJlZSBjb3BpZXMgb2YgWEZEOg0KPiANCj4gLSB0aGUgZ3Vlc3QgdmFsdWUgc3RvcmVk
IGluIHZjcHUtPmFyY2guDQoNCk9LLCBsZXQncyBjYWxsIGl0IGUuZy4gdmNwdS0+YXJjaC54ZmQN
Cg0KWy4uLl0NCj4gLSB0aGUgaW50ZXJuYWwgS1ZNIHZhbHVlIGF0dGFjaGVkIHRvIGd1ZXN0X2Zw
dS4gIFdoZW4gI05NIGhhcHBlbnMsIHRoaXMNCj4gb25lIGJlY29tZXMgemVyby4NCg0KPiBUaGUg
Q1BVIHZhbHVlIGlzOg0KPiANCj4gLSB0aGUgZ3Vlc3RfZnB1IHZhbHVlIGJldHdlZW4ga3ZtX2xv
YWRfZ3Vlc3RfZnB1IGFuZCBrdm1fcHV0X2d1ZXN0X2ZwdS4NCj4gICBUaGlzIGVuc3VyZXMgdGhh
dCBubyBzdGF0ZSBpcyBsb3N0IGluIHRoZSBjYXNlIHlvdSBhcmUgZGVzY3JpYmluZy4NCj4gDQoN
Ck9LLCB5b3UgbWVhbiB1c2luZyBndWVzdF9mcHUgYXMgYSBLVk0gdmFsdWUuIExldCBtZSBkZXNj
cmliZSB0aGUNCmZsb3cgdG8gc2VlIGlmIGFueXRoaW5nIG1pc3NpbmcuDQoNCldoZW4gI05NIHRy
YXAgd2hpY2ggbWFrZXMgcGFzc3Rocm91Z2gsIGd1ZXN0X2ZwdSBYRkQgc2V0IHRvIDAgYW5kIGtl
ZXBzDQpmb3JldmVyLiAoZG9uJ3QgY2hhbmdlIEhXIFhGRCB3aGljaCBpcyBzdGlsbCAxKQ0KSW4g
dGhlICNOTSB0cmFwLCBLVk0gYWxsb2MgYnVmZmVyIGFuZCByZWdlbmVyYXRlIGEgI05NIGV4Y2Vw
dGlvbiB0byBndWVzdA0KdG8gbWFrZSBndWVzdCBrZXJuZWwgYWxsb2MgaXRzIHRocmVhZCBidWZm
ZXIuIA0KVGhlbiBpbiBuZXh0IHZtZXhpdCwgS1ZNIHN5bmMgdmNwdS0+YXJjaC54ZmQsIGxvYWQg
Z3Vlc3RfZnB1IHZhbHVlICg9MCkgYW5kDQp1cGRhdGUgY3VycmVudC0+dGhyZWFkLmZwdSBYRkQg
dG8gMCBmb3Iga2VybmVsIHJlZmVyZW5jZS4gDQoNCg0KPiAtIHRoZSBPUiBvZiB0aGUgZ3Vlc3Qg
dmFsdWUgYW5kIHRoZSBndWVzdF9mcHUgdmFsdWUgd2hpbGUgdGhlIGd1ZXN0IHJ1bnMNCj4gKHVz
aW5nIGVpdGhlciBNU1IgbG9hZC9zYXZlIGxpc3RzLCBvciBtYW51YWwgd3Jtc3IgbGlrZQ0KPiBw
dF9ndWVzdF9lbnRlci9wdF9ndWVzdF9leGl0KS4gIFRoaXMgZW5zdXJlcyB0aGF0IHRoZSBob3N0
IGhhcyB0aGUNCj4gb3Bwb3J0dW5pdHkgdG8gZ2V0IGEgI05NIGV4Y2VwdGlvbiwgYW5kIGFsbG9j
YXRlIEFNWCBzdGF0ZSBpbiB0aGUNCj4gZ3Vlc3RfZnB1IGFuZCBpbiBjdXJyZW50LT50aHJlYWQu
ZnB1Lg0KPiANCj4gPiBZZXMsIHBhc3N0aHJvdWdoIGlzIGRvbmUgYnkgdHdvIGNhc2VzOiBvbmUg
aXMgZ3Vlc3QgI05NIHRyYXBwZWQ7DQo+ID4gYW5vdGhlciBpcyBndWVzdCBjbGVhcmluZyBYRkQg
YmVmb3JlIGl0IGdlbmVyYXRlcyAjTk0gKHRoaXMgaXMgcG9zc2libGUgZm9yDQo+ID4gZ3Vlc3Qp
LCB0aGVuIHBhc3N0aHJvdWdoLg0KPiA+IEZvciB0aGUgdHdvIGNhc2VzLCB3ZSBwYXNzdGhyb3Vn
aCBhbmQgYWxsb2NhdGUgYnVmZmVyIGZvciBndWVzdF9mcHUsIGFuZA0KPiA+IGN1cnJlbnQtPnRo
cmVhZC5mcHUuDQo+IA0KPiBJIHRoaW5rIGl0J3Mgc2ltcGxlciB0byBhbHdheXMgd2FpdCBmb3Ig
I05NLCBpdCB3aWxsIG9ubHkgaGFwcGVuIG9uY2UNCj4gcGVyIHZDUFUuICBJbiBvdGhlciB3b3Jk
cywgZXZlbiBpZiB0aGUgZ3Vlc3QgY2xlYXJzIFhGRCBiZWZvcmUgaXQNCj4gZ2VuZXJhdGVzICNO
TSwgdGhlIGd1ZXN0X2ZwdSdzIFhGRCByZW1haW5zIG5vbnplcm8gDQoNCllvdSBtZWFuIGEgd3Jt
c3IgdHJhcCBkb2Vzbid0IGRvIGFueXRoaW5nIGFuZCByZXR1cm4gYmFjaz8NCkluIHRoaXMgY2Fz
ZSwgd2hlbiBuZXh0IHZtZW50ZXIsIHRoZSBPUiBvZiB0aGUgZ3Vlc3QgdmFsdWUgDQoodmNwdS0+
YXJjaC54ZmQpIGFuZCB0aGUgZ3Vlc3RfZnB1IHZhbHVlIGlzIHN0aWxsIDEsIHNvIHRoaXMgDQpk
b2Vzbid0IG9iZXkgZ3Vlc3QncyBIVyBhc3N1bXB0aW9uPyAoZ3Vlc3QgZmluZHMgdGhlIHdybXNy
IA0KZGlkbid0IHdvcmspDQogDQpUaGFua3MsDQpKaW5nDQoNCmFuZCBhbiAjTk0gdm1leGl0IGlz
DQo+IHBvc3NpYmxlLiAgQWZ0ZXIgI05NIHRoZSBndWVzdF9mcHUncyBYRkQgaXMgemVybzsgdGhl
biBwYXNzdGhyb3VnaCBjYW4NCj4gaGFwcGVuIGFuZCB0aGUgI05NIHZtZXhpdCB0cmFwIGNhbiBi
ZSBkaXNhYmxlZC4NCg0KPiANCj4gUGFvbG8NCg0K
