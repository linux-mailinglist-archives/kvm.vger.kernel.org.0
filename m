Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C94242D82F
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 13:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbhJNLcz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 07:32:55 -0400
Received: from mga07.intel.com ([134.134.136.100]:53798 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230361AbhJNLcy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 07:32:54 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10136"; a="291146027"
X-IronPort-AV: E=Sophos;i="5.85,372,1624345200"; 
   d="scan'208";a="291146027"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2021 04:30:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,372,1624345200"; 
   d="scan'208";a="716113190"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga006.fm.intel.com with ESMTP; 14 Oct 2021 04:30:48 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 14 Oct 2021 04:30:48 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 14 Oct 2021 04:30:48 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 14 Oct 2021 04:30:48 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 14 Oct 2021 04:30:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ALMyGusll2zL+7MqY3zwiTn8uoXu5D9zM4RPsoxbPNMcCwfJB6oBEExtTadmESSzmugRtHRRMxNpxt/C/x+qvkKx1/GpZ1mBjOYEXxq+T4RFI+revBpzGBDk8yJoTjiujvzKIDaWBIgFTs4BhwgV6Jquj2sUcazpT40o0+lSGh4fvri/YC+VlXB6tzHmZRyWEjW5NqU8yMO14juYd0RyV8gkFTgEAzvpm+az52uhHzO2xY+UTRX6nHWBPoxzqHRTMrwEPgLTrPE1kJlwuQW1ktgb921Qmv0UH0PJZpPqQU1TimJsCYPtA8yiwueaiq66KmIVSxE3K7MED0MKhGXcLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5G7tuRzjepGr5tiQ2LJgR4CIWPQwhcqMEcNplmXNqoM=;
 b=YKIf3o1nAWul6wjmxtME0GYjSmQexpVUkPOMI/XyXBb+jennOrIqNslmUYHiB20ERhasDzXYRsJfj2On+a0j9kHOHIdu+DKA154u7xcCI5sL+YW6i/ySpluvfej6NXYH8Rt3JApU9UDBAJTER91C6IT1ACYAC5pV64D5uYcsxJt8EShTPRF2rbpCBbjUdrvEb+eauhq7IktLJnhp5pUDBGaTFh2AK7VyKoHbHXGtIK3FNgmWbl51n7wJp4WRhZ45uHUkonoPAySzS/m4eAK2Zi8rdWIPfvA4iaMt00Rjfqc6JUyTDL9EePiB831Sy8qJV8QP2x5IFKiAy0jwnynb5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5G7tuRzjepGr5tiQ2LJgR4CIWPQwhcqMEcNplmXNqoM=;
 b=q7STfsWw9W6zWx2kZKzXHrZmoF2hHWrQyWmo34yJHAn+v6/6CPxWid4tTdDuBYXCZwJQAufq/lmYFY8Chy+gClFWwynglE+HMoOFt0PUsGpQddvAvboM0Jn64qyHFrIBTczmFLndDnb/EwAf6qUemB5QEnrlTgSX3O0hEKpjfig=
Received: from BYAPR11MB3256.namprd11.prod.outlook.com (2603:10b6:a03:76::19)
 by BYAPR11MB2807.namprd11.prod.outlook.com (2603:10b6:a02:c3::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Thu, 14 Oct
 2021 11:30:46 +0000
Received: from BYAPR11MB3256.namprd11.prod.outlook.com
 ([fe80::61d4:ab77:cc62:fabf]) by BYAPR11MB3256.namprd11.prod.outlook.com
 ([fe80::61d4:ab77:cc62:fabf%6]) with mapi id 15.20.4608.016; Thu, 14 Oct 2021
 11:30:46 +0000
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
Thread-Index: AQHXv42x8Iw8v1bdT0WqN+QXiZLaIqvQcYTggAAF7ACAAAOKwIAAIoqAgABafQCAARh7AIAACH/AgAAb+oCAACdDgA==
Date:   Thu, 14 Oct 2021 11:30:46 +0000
Message-ID: <BYAPR11MB32565A69998A2D3C26054D3EA9B89@BYAPR11MB3256.namprd11.prod.outlook.com>
References: <871r4p9fyh.ffs@tglx>
 <ec9c761d-4b5c-71e2-c1fc-d256b6b78c04@redhat.com>
 <BL0PR11MB3252511FC48E43484DE79A3CA9B89@BL0PR11MB3252.namprd11.prod.outlook.com>
 <6bbc5184-a675-1937-eb98-639906a9cf15@redhat.com>
In-Reply-To: <6bbc5184-a675-1937-eb98-639906a9cf15@redhat.com>
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
x-ms-office365-filtering-correlation-id: faeca33b-d9bf-47e1-3f44-08d98f0610f5
x-ms-traffictypediagnostic: BYAPR11MB2807:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB2807CBE3C276EA5D0E773292A9B89@BYAPR11MB2807.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DQ+Gxqc0BjkL0LtoJmiSlf1C+L8FN23Ti3Xn/r1IAp7oBM/pT/mDEJe6RXzOBdKB6TVwfM7nILlf17ybYJ5+r8fgGnWWzLwVW1qo7ZKMC9dvAbTMo3DPeCGq93etsPEruvWjejdViiCeNbJjcXmgL3Q3Aa/1laZ9B1dxKMSnNCp66H7e1v2ZQl3Hl2PMAPxNpBOARIyFxpnEtgDfR34TEKVqfFamEK8etrdARE2NMgevMBDmqYOiARtjLWMudWxywhoTDrwzlXgmCkYYRmW8GTUjLDWfoLBnfmfmjW20vGifMc1mYfUksj/9Ia7+1hJcUpDNVFuaTqW5n02qFa1gxB7cwfzPEmqMU3j7KRn+ef1yw8vsgh07LPqaa8UiYXjzwjO1NrJTAJw1kWppct0iAcHryrItZGcVyJ0BbmWuZNSF6wh+HL/X2ea/vwUi6Wt2QmNNajz/pBnRxTHymmjhkPg9MVWKu/kSus2osbmxwrQs5Po614gq0dDCfPk4oTLVZEIz50E1hAffCLieIZLJeV9zZV1jrUZCZMybjqjPgU/hjOG4M4lXLoqK8MUQ9GJdPvJxDlMD3YXJLl60IQLfsEW5R+uUxDKEgMsu3OqDGWSXNDAaiRyl9oGoW+JNLm+NtUEDuvvnnkpCvnHY3Y46ZfSmj60LJG86y8GgoR0JGw3tHgiLqncs3y2ndh4uYrdgh1rRRv3jpqLmMle9z28VRg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3256.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52536014)(9686003)(83380400001)(33656002)(53546011)(8936002)(6506007)(7696005)(86362001)(38100700002)(316002)(122000001)(7416002)(5660300002)(55016002)(82960400001)(186003)(54906003)(26005)(110136005)(66946007)(76116006)(2906002)(71200400001)(38070700005)(8676002)(66476007)(66556008)(4326008)(66446008)(64756008)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bFdzUjhwUUJsUC9pUThPSDJCLzJOK013OXFpRkh5SnlRd04vOUNGUFA3L2FO?=
 =?utf-8?B?T1V3S1k3RlJRbmlyNGMvdm16UzNVYUVaTWdtT0dML2tkcnVEcFFuNlB6RWM5?=
 =?utf-8?B?eGd3M2pQT3JaN2QrMUpOZDVvcnhaSHlmU29IS0R6VjVsVlFtR1FXbWgrckl2?=
 =?utf-8?B?RCs2YTE0aE9vcisyVEJPM2pqZEVtUEdnU01hNVZ3QnhHT0dvSEtjMzJIUlla?=
 =?utf-8?B?aURuSjF4Z0p4N2RBbU9MaVRrd2sydWdRQk1IYUxpaW9xL2F5Z2lIaXdNblVi?=
 =?utf-8?B?dzhwSjdSZjYwUFRYc3Q5bkJ1TVJyeS80a3cwTHZtOWNsTzZFNnlWMjF0R1VQ?=
 =?utf-8?B?NXpvMjNmTkFwVTE3UklXY3RmREdNay9TYmp4SG8xUGhIVkN0YlRkZTBtTGd5?=
 =?utf-8?B?QWNDWFNBdWJOQlczc3QyWVQ3TWhBUTYyMDdpVm1QYUNaWVZ3V2xTNCtSeGFH?=
 =?utf-8?B?UlpURDJuWnFVbEdMQUhxajRxZ3dpRTVzTXpYaFVLUUprMFF6ODJ0eVFOOGRz?=
 =?utf-8?B?V2JEY2dxRXVrdXZ2RkkwMWFLNTBTMXRBdzJBSEJmWkF2RkRkUHpGeFViMFh6?=
 =?utf-8?B?VGxRSFhPUzNoVVp4ZlJrZE5jdEl4NTFWRnBVK2ZkUlQ5bjl0bTRqaU9RVmRn?=
 =?utf-8?B?TG1xMWxzclpUY0FlbTdHWDJZVmlQNTFrWkM1UGE5ZHZvM1V1Vlp2VUM1aThn?=
 =?utf-8?B?aStHQU15SEFqZVRKSlpMZEFEbTBndXpWQzRqR1FXLzhpbDJqclEzcEM1U3Ar?=
 =?utf-8?B?MUJ0NDVLb0MwaW9hTFlkRStGa2NtOU1lbHM3RGpwTjRIQTl5NGp3RkdlYmZr?=
 =?utf-8?B?S3pyV292Ykdwc2xRYktFT1M2OS82a2pqVGdDNjlNQlZ0UkdQU0NLc1pWUWkw?=
 =?utf-8?B?aGFKdk9sQnF4MElxaUtyM3JQZWtGOEpFMG5rbXd6Vi9EOEZWc2JnN0FmOFho?=
 =?utf-8?B?RERTZVRkRm1NTkxXaTdpMHdLajhORWowUEVudzlCbWZick1OemNLSVltMVpK?=
 =?utf-8?B?OEw2ZkV5bmZBd3RFWjZxdG56SkdzL3lvVHNWWW0rdlluSWVvNkhUZnphaTNQ?=
 =?utf-8?B?QUhFRmJSZHRMU1VPMEZ4WkF3Q20wdlVLQTJxQjFBSDFDT1ZoOFlzZnVMdWRU?=
 =?utf-8?B?cVZKZ2RyaGFrbVBsbXRPNW1sOGh6QUtrSGVkcTZocUZKVjRJdEY4dk1MNit4?=
 =?utf-8?B?WFlWVU1xb2dHdFpqdWxzV3ZuMVZtSVJEb3dzaFA0YXUzazlCV2NWNWlxOU1O?=
 =?utf-8?B?VVN2N084VGliV0ZxRDFNcm9zazFOM2g0WHZ3OXpHUUJDcWwrQ040eXVyK3Fj?=
 =?utf-8?B?OTdkUk45YkJTVlFpRHdQOTVLUTAyVnpNRDhYNm54MDFNY0NrYnAxSTRyVU5T?=
 =?utf-8?B?c1ZhYysybXFMN044NURqb053dkgwVUZiSjlMbmZ5ZW5JNURINVBmTlB6M2Vy?=
 =?utf-8?B?WXZDU05SMXM5ZkxCZWM2Qm1UWkx5by9pa1RTaWFDalUzZllUZmhXbm5OVnhC?=
 =?utf-8?B?VWMzZms1bXlLQVVWSWFObzZQSEVOcE5EaVB6Tk5sWCtMRlJaUzk2Tm9xQVpr?=
 =?utf-8?B?MXdDV1daNFd2bFBCMjcvNjdmZGVhU0k2eGpHUnhMUzVvaHlZZEVzcW5aZ3lF?=
 =?utf-8?B?TmlLZXZBdkhWbzRyMWtZK1JCTVR0YUxjZzlsb3RrdGtWdTFmZ2tSV01JYU9o?=
 =?utf-8?B?YU9oK0tsMzhzbU5Ia0Y1V2ErMXBzS09jVmg3bkxKT2Jib3ZJNllkeHcwSXJR?=
 =?utf-8?Q?uTC2KxWR/ElloLu0dFBKOeQvaOJ5V63T3aGP0Nh?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3256.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faeca33b-d9bf-47e1-3f44-08d98f0610f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 11:30:46.5340
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: np4bIlCzZUu7CfOxK/13+dLiPOYtrxkTxpVIxthJrl2WOAEYQBDhKBqM4kBxhonXFQWcVCBJlRCiEVXZCTk10g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2807
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQpPbiAxMC8xNC8yMDIxIDU6MDEgUE0sIFBhb2xvIEJvbnppbmkgd3JvdGU6DQo+IE9uIDE0LzEw
LzIxIDEwOjAyLCBMaXUsIEppbmcyIHdyb3RlOg0KPiA+PiBJbiBwcmluY2lwbGUgSSBkb24ndCBs
aWtlIGl0IHZlcnkgbXVjaDsgaXQgd291bGQgYmUgbmljZXIgdG8gc2F5ICJ5b3UNCj4gPj4gZW5h
YmxlIGl0IGZvciBRRU1VIGl0c2VsZiB2aWEgYXJjaF9wcmN0bChBUkNIX1NFVF9TVEFURV9FTkFC
TEUpLCBhbmQNCj4gPj4gZm9yIHRoZSBndWVzdHMgdmlhIGlvY3RsKEtWTV9TRVRfQ1BVSUQyKSIu
ICBCdXQgSSBjYW4gc2VlIHdoeSB5b3UNCj4gPj4gd2FudCB0byBrZWVwIHRoaW5ncyBzaW1wbGUs
IHNvIGl0J3Mgbm90IGEgc3Ryb25nIG9iamVjdGlvbiBhdCBhbGwuDQo+ID4NCj4gPiBEb2VzIHRo
aXMgbWVhbiB0aGF0IEtWTSBhbGxvY2F0ZSAzIGJ1ZmZlcnMgdmlhDQo+ID4gMSkgUWVtdSdzIHJl
cXVlc3QsIGluc3RlYWQgb2YgdmlhIDIpIGd1ZXN0IFhDUjAgdHJhcD8NCj4gDQo+IEJhc2VkIG9u
IHRoZSBpbnB1dCBmcm9tIEFuZHkgYW5kIFRob21hcywgdGhlIG5ldyB3YXkgd291bGQgYmUgbGlr
ZSB0aGlzOg0KPiANCj4gMSkgaG9zdF9mcHUgbXVzdCBhbHdheXMgYmUgY2hlY2tlZCBmb3IgcmVh
bGxvY2F0aW9uIGluIGt2bV9sb2FkX2d1ZXN0X2ZwdQ0KPiAob3IgaW4gdGhlIEZQVSBmdW5jdGlv
bnMgdGhhdCBpdCBjYWxscywgdGhhdCBkZXBlbmRzIG9uIHRoZSByZXN0IG9mIFRob21hcydzDQo+
IHBhdGNoZXMpLiAgVGhhdCdzIGJlY2F1c2UgYXJjaF9wcmN0bCBjYW4gZW5hYmxlIEFNWCBmb3Ig
UUVNVSBhdCBhbnkgcG9pbnQNCj4gYWZ0ZXIgS1ZNX0NSRUFURV9WQ1BVLg0KPiANCj4gMikgZXZl
cnkgdXNlIG9mIHZjcHUtPmFyY2guZ3Vlc3Rfc3VwcG9ydGVkX3hjcjAgaXMgY2hhbmdlZCB0byBv
bmx5IGluY2x1ZGUNCj4gdGhvc2UgZHluYW1pYy1mZWF0dXJlIGJpdHMgdGhhdCB3ZXJlIGVuYWJs
ZWQgdmlhIGFyY2hfcHJjdGwuDQo+IFRoYXQgaXMsIHNvbWV0aGluZyBsaWtlOg0KPiANCj4gc3Rh
dGljIHU2NCBrdm1fZ3Vlc3Rfc3VwcG9ydGVkX2NyMChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpIHsN
Cj4gCXJldHVybiB2Y3B1LT5hcmNoLmd1ZXN0X3N1cHBvcnRlZF94Y3IwICYNCj4gCQkofnhmZWF0
dXJlc19tYXNrX3VzZXJfZHluYW1pYyB8IFwNCj4gCQkgY3VycmVudC0+dGhyZWFkLmZwdS5keW5h
bWljX3N0YXRlX3Blcm0pOw0KPiB9DQo+IA0KPiAzKSBFdmVuIHdpdGggcGFzc3Rocm91Z2ggZGlz
YWJsZWQsIHRoZSBndWVzdCBjYW4gcnVuIHdpdGggWEZEIHNldCB0bw0KPiB2Y3B1LT5hcmNoLmd1
ZXN0X3hmZCAoYW5kIGxpa2V3aXNlIGZvciBYRkRfRVJSKSB3aGljaCBpcyBtdWNoIHNpbXBsZXIN
Cj4gdGhhbiB0cmFwcGluZyAjTk0uICBUaGUgdHJhcHMgZm9yIHdyaXRpbmcgWENSMCBhbmQgWEZE
IGFyZSB1c2VkIHRvIGFsbG9jYXRlDQo+IGR5bmFtaWMgc3RhdGUgZm9yIGd1ZXN0X2ZwdSwgYW5k
IHN0YXJ0IHRoZSBwYXNzdGhyb3VnaCBvZiBYRkQgYW5kIFhGRF9FUlIuDQoNCkZvciBYRkRfRVJS
LCBzaW5jZSBpdCBjYW4gYmUgYXV0byBjaGFuZ2VkIGJ5IEhXLCB3cml0ZS1wcm90ZWN0IGlzIG5v
dA0KbmVlZCBJIHRoaW5rLiBLVk0gYWxzbyBub3QgbmVlZCB0cmFwIHJkbXNyIG9mIGl0IGJlY2F1
c2Ugbm8gdXNlLg0KDQpJIGd1ZXNzIHdlJ3JlIHdvcnJ5aW5nIGFib3V0IGlzIHdoZW4gS1ZNIGlz
IHNjaGVkX291dCwgYSBub256ZXJvIFhGRF9FUlINCmNhbiBiZSBsb3N0IGJ5IG90aGVyIGhvc3Qg
dGhyZWFkLiBXZSBjYW4gc2F2ZSBndWVzdCBYRkRfRVJSIGluIHNjaGVkX291dA0KYW5kIHJlc3Rv
cmUgYmVmb3JlIG5leHQgdm1lbnRlci4gS2VybmVsIGlzIGFzc3VtZWQgbm90IHVzaW5nIEFNWCB0
aHVzDQpzb2Z0aXJxIHdvbid0IG1ha2UgaXQgbG9zdC4NCkkgdGhpbmsgdGhpcyBzb2x2ZXMgdGhl
IHByb2JsZW0uIFNvIHdlIGNhbiBkaXJlY3RseSBwYXNzdGhyb3VnaCBSVyBvZiBpdCwNCmFuZCBu
byBuZWVkIHRvIHJkbXNyKFhGRF9FUlIpIGluIHZtZXhpdC4NCg0KVGhhbmtzLA0KSmluZw0KIA0K
