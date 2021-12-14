Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE2F473CEF
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 07:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbhLNGFu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 01:05:50 -0500
Received: from mga03.intel.com ([134.134.136.65]:7899 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229766AbhLNGFt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 01:05:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639461949; x=1670997949;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2PssJzvs9oNXFX7mDGeL2KK4NHej8lfTPYCf3Xyxw18=;
  b=GoYFxDoJ0rE/a7K+HDCAbp9B7PzEAPVISwtVLbq/M4AoND4nz+I04O6j
   h226RhKMXFGBlw/Teb5L+HteNA+yJDBS9/cmY/ot29La5CNC25essXWgl
   weDCSxXUyHB8nuwavkX4a36CbsOMWQF45fB7oq4k9nqlxiQM54pknHcMz
   izTKXJm+duXyhb76v4EEIq91P5NxtKfi4z5y5qhJK3lKV4BUPfHtlTa7e
   YUtr9ymgTU1gqY1tK8rb5GzmVmG+0N1MQSIk7xUdZDw+LlGOPtnqUzIbp
   d/vXPdKnZY9fV/enh1uTDf7zD5UhDWfmJEziGT/EWBnj/H7vxN806MFTi
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="238852051"
X-IronPort-AV: E=Sophos;i="5.88,204,1635231600"; 
   d="scan'208";a="238852051"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 22:05:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,204,1635231600"; 
   d="scan'208";a="681926590"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga005.jf.intel.com with ESMTP; 13 Dec 2021 22:05:49 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 22:05:48 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 22:05:48 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 13 Dec 2021 22:05:48 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.44) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 13 Dec 2021 22:05:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ezl9fX24vxEOEwVcKUtSDP1tsiZ5PH2rx/8pkakGJWBr6Csr/rxuPBgI2bkFrkDMs4OCtItPPfgVpleDGQzwegoyN//3DBrvUNEQKJkY/FX1RJE7CSRK9vge/ep+ZSYBGH9JTbxjiIn0E1Bs6Zj5hErH+I8rNQ+0Mkt7qunhSB2Jeb14i5ZK6CvvF/p+gwPdwi97WzSPJiZxOae1aXA6pnYwVcsAMwnaLsP1PlbJ4sDV0Z6zIIxUjVb3c3D1CvdDbV57gfR/IFy4EnNmketozSCLoF9o/bfPsf1OTivNXED2O8EPGuP+7utX4v5A0P3YDfijd9M6cQ4HxFKaGmX22w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2PssJzvs9oNXFX7mDGeL2KK4NHej8lfTPYCf3Xyxw18=;
 b=oRFW4RAVnWNgtR+OIScSCj9nlmVQ9xlHvDFubBARJOu7TSV9uxOtu/sJaR1tP61mSrOY4ROrm+k84w/F3IuybzW2EcWM1keoCyJWdFDStKgp7SeIoROVNp+M5AMZqnwk/PFskoeA0FRj7XP3OEVDJqsPNWCdFCfOAZuuJJ1OHFLzk/HV7bjLoN/0lpR6d8LYgQPSnMS9qCoRN37Rouf44eWCaI/elzFgmjCV17y8g5imcCtVYfPRIUkOXIlBJmTXHvNRIt+2CgDYYni6VUvlrFtdooLa4zxrzIPBbri5e7mGOmjNOGaIo4VtAJXJ6JefQYmxKo0Jq3Ddfxwsm7aMkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2PssJzvs9oNXFX7mDGeL2KK4NHej8lfTPYCf3Xyxw18=;
 b=kAesQ/OMY7AGmxL5gizRy3+fMVhKyACcqFSfR7w25ZFgCAMuxZnd9ehY3TKMTXSa7cOGyibpSlwQxelrVFuxiEeYxGNZS6MTvQdhro/4sawXK9LW2XQq7JsAHmT3ILZGnMzwtHXopg4DILdvjjZlLlPvq+IJnL284iSx6YWKlNc=
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN9PR11MB5370.namprd11.prod.outlook.com (2603:10b6:408:11b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 06:05:42 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%3]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 06:05:42 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
CC:     Jing Liu <jing2.liu@linux.intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: RE: [patch 4/6] x86/fpu: Add guest support to xfd_enable_feature()
Thread-Topic: [patch 4/6] x86/fpu: Add guest support to xfd_enable_feature()
Thread-Index: AQHX8JVfa24MaOKR6ES6APNYc0mH4qwxeZaw
Date:   Tue, 14 Dec 2021 06:05:42 +0000
Message-ID: <BN9PR11MB5276D76F3F0729865FCE02938C759@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20211214022825.563892248@linutronix.de>
 <20211214024947.991506193@linutronix.de>
In-Reply-To: <20211214024947.991506193@linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 48d62e5c-b5e4-4482-8052-08d9bec7c294
x-ms-traffictypediagnostic: BN9PR11MB5370:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN9PR11MB5370BE29FB6C26E84D9BF0F68C759@BN9PR11MB5370.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1091;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ny3nv3OnX2HaY+3b9UvfBU0nHgF6xVKVOgJ3ZJcPd/JXWOWBOgGOX9iGcLKiUsbOha+or0E6IJMapjAw4B1juFntz/JZjvZrZeJR3/BroBn6DU/6ZstRlv9hIi1ihkz3P++CqRPP2VXTGChqh/RetJPGn4+1NxbsmWu905EuvbUrNWHSJPMZosS3vzMzVcQT35r5/jNh75OGtIdKnjNQXMnceXi3XQfoZ/AzIS/LJXJED49609VfvRXa9TynC7Hj7441UKCtZUVrluJbBOJYamG1Hp9SKbVrlsjwFFXP7oE5ndqgmhHC4g5ujTWDNoSW38i1Grozp9pWHrBcFVJilY6h7sCWI1csC+26j2qXGLF7fxNSwbxJAGnC02V6EXS7y3viBGNQyXFOifzX67if8y3BmmBy6qHoUAnSHaweRJrJO6DZ/u+MPo3xmkme5z+zLbnkHc486dbjz92vxoOebN2udfCpP7zeCu1JitPQwYhn+SV9pjEnKxedtNnlT7faOWRrWSpUssl5+IijRwADDyiYZE8kE3a90oubgUFD6/dYTUvvCYkO5CrSdjZFLyBawDMTh7eqq677ySs7om4PFPnWI+pdqlWF2lvunu383KlkyiQGMilBgTnK747OCtkp7smC4Rvfv377ZU/p8EUKo3NZNjdTG5CmJDhY7hLCrDISObnnOGTTu3KPVsyONLssYsQK1aSPZPQlBxD8ZseIPw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(66446008)(82960400001)(4326008)(64756008)(6506007)(2906002)(186003)(66476007)(38100700002)(76116006)(66946007)(71200400001)(122000001)(9686003)(66556008)(55016003)(83380400001)(508600001)(7696005)(38070700005)(33656002)(5660300002)(110136005)(54906003)(316002)(8676002)(86362001)(8936002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UGhDd3JiaTFZL0MwUGw5WXcrQ24wUkEwdXFRUFNYUVd3MWVDT3Z2UG9IVDN6?=
 =?utf-8?B?RUdWR3ZaYlJsUGFsblg3LzJ5V0pVU0JTbXdJNkNsSEhmbTlpRS91WDludk9T?=
 =?utf-8?B?bmlKeDAwYmYvbnpwa1gxV0FvckVJSHZVZjVFTkRiYnRsUW1BMWtCaHg3MEJV?=
 =?utf-8?B?R2xzeTRWMnRsMXZScDE3UWtNSUQvbWdINXkyTUpUNzUra0Nla3pOa2pPTXpM?=
 =?utf-8?B?Z1loSmVKR0RlK1BYQUU2ZU1mK0VDTmpvR3ViTDl3VlJPc2NXRDM1NkI5dEI3?=
 =?utf-8?B?SG5ZSzNLWnluNTcrY3V1c3pBQ2xCbFZpbk5nSDltQmpUbFNLdEM3NHJNaFJQ?=
 =?utf-8?B?WmZtU2IrSWI2TkErZWV3eVpkckVWajB0TDluK2Fzc0JPL056UnVaK2RUMjNt?=
 =?utf-8?B?bTZIeUQwT200RlRibmE2aWwxWVBLY0QxWGppaXJ0bmpYWWp0c3lmWXkyejhx?=
 =?utf-8?B?dG9XanlUK1BwbUo4clRSNUF4bHpaVGt0bUJ2eElKeTZ6RTJ0WVVXL2FiV2Ux?=
 =?utf-8?B?UHVaWHQ2UXBQZU1udis0UGY0bnZjUnNXR2YreldabmJ1ZHlzN2VBTjdDS1l1?=
 =?utf-8?B?bWlwaFpZK2p6VDZkN0ZCcXFCcTRJWmZJc2hrVXR5RU5wSk15SFgrV0JxQUlX?=
 =?utf-8?B?anZqS0I3N2FqclNTWXV4a1NPUXpabERXdjk4ZkRsUzEveHM5MUlMcWg0cmc3?=
 =?utf-8?B?Vk9MUlNXTVplUDlPYXJoTElrQTdVWjg3UVZSMjBxeHFXbDRkTDJXSUtIT2NI?=
 =?utf-8?B?cFFPSTl1dWhRMlp0T29yaWlHcDRkU1M3dnhzc2I5QVpRNHJIM0U0elZxeFJU?=
 =?utf-8?B?Mm5mNzhyd2tHZXFtbGl5Rks1dFF3TVNMMHAvN1VYSUZQMXRxZUpFeVp2T21P?=
 =?utf-8?B?cURWWVpOTWdYcXg1RHVMRlZGRC9jZ0xTeGRGc2E2M3F6NU9sVTh4bnY0K3Uv?=
 =?utf-8?B?eUJ4alh6TnljaVhkaDZ6SDYyRlVtS2VOdlg0TTk2VWhCRjZsazErNWJkZGFu?=
 =?utf-8?B?RnNWYitwSDMxajQ4THBtUzg0c2NTQ0p3NG5pLzhldE9ibUFrRHQxZzQyRUFq?=
 =?utf-8?B?aDJzMTNCVUFGZU5WVkZlaUVMc0Jqc2ZubFhyUTRDNjdtaHhOZjZtankvZWRa?=
 =?utf-8?B?WGkyUUxtTlRRQnVPMHNkeUl2ditPRzEyY25sVVplZ08vbDVvUEpRSnFmRXBX?=
 =?utf-8?B?MmpURTM0L0psZHp0UGcwc3E4TjV6cktzQ05YOHh1cG5ZU0dOTGRaUk5INTBR?=
 =?utf-8?B?bFZQbFhwcFhoRUd2dExBQ1lKaHJ2TDN4aC9oR2xoc2I5cHRkYWRXSC9lRzJo?=
 =?utf-8?B?RG0vQzNVVDhnY0dMQm44d1duMldRdmpoMVJtdExwWG0zcDc4YjVNVHU2QlJW?=
 =?utf-8?B?YzBVWDNOeUVmTFdFbGNxY0Fhd2hyS3J3TndKNDNnZlUxbi9JNlBpUTJkT1ZI?=
 =?utf-8?B?MVdxcEwwMWM1NEFFdTdMTkZUUnpTaTA3L0d6RWJ1eGwzbkF0U05JeGFabHl6?=
 =?utf-8?B?ZkFPcEpCY0ZTMEhtTmlVT0lVazVORDY2WXZFNlJwMjE4ZWhaSWEwdm8yMEli?=
 =?utf-8?B?aGduTFdOZzlmSUhMS3NwRDEreE9GQ29nL0JyUldoajlWamZaV3NMekJIZjJY?=
 =?utf-8?B?dmFCQWprWW91L25UZERjMFNrOTNIcTFIVUJFRSt3bG81VzU4YjZPVWtEemRs?=
 =?utf-8?B?YlpTdlorU1Fad2pjbTA3RGFrTWRNSnRmSkVrZzVIdlRaQXAwbWR5UThxZ0Za?=
 =?utf-8?B?N2RTY3VyQ3MxV0IzaWFpUDM1NDVWeWd4Z28zeGNNRzFzZVVGa2hINTYxeHFY?=
 =?utf-8?B?VEd0aEFHZU1BQ2RmOVdzdFdMZ2ZMWDNQV3U2b3FpTXo5V0VmaEd1aDZBb24y?=
 =?utf-8?B?Y2tuc1NmTEdYNWQvbC9kMVRjbUpLbmlTaGxzMVBHREIvLzJBRC9COTlxdWRQ?=
 =?utf-8?B?LzE4TmNGRFhvNFhaeHF1cXo4U0VXUFJOdis0V2RVTmhHOElZam5ONkw2amRu?=
 =?utf-8?B?V3V0amRLc0dWQk0ySHBackNjVjdRVjdaR0FORWEzQnYva2NESzN3TElsMFZT?=
 =?utf-8?B?b05UMm03WmkyeExQODF3WVh3cU9NUFZtL0FxT2JYZXN0Z2RpT0dCOGpQaUh1?=
 =?utf-8?B?ejBJeEZDcDZUQjJ0RnAzN296SmhQSHMzLzIwWkFTSDVDZkxEWVEwSDZodGNU?=
 =?utf-8?Q?PoH4lvpk8ZfHhVl7XUddITw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48d62e5c-b5e4-4482-8052-08d9bec7c294
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2021 06:05:42.0423
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QVyFXvZ9MIjOwC38USlNN6i4btZ62I/d2tOSY4I157NgLLziNBR4KQjhocU/N54a2UaIFTojtH+RqePS9yJfrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5370
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBUaG9tYXMgR2xlaXhuZXIgPHRnbHhAbGludXRyb25peC5kZT4NCj4gU2VudDogVHVl
c2RheSwgRGVjZW1iZXIgMTQsIDIwMjEgMTA6NTAgQU0NCj4gDQo+IEd1ZXN0IHN1cHBvcnQgZm9y
IGR5bmFtaWNhbGx5IGVuYWJsaW5nIEZQVSBmZWF0dXJlcyByZXF1aXJlcyBhIGZldw0KDQonZW5h
YmxpbmcnIC0+ICdlbmFibGVkJw0KDQo+IG1vZGlmaWNhdGlvbnMgdG8gdGhlIGVuYWJsZW1lbnQg
ZnVuY3Rpb24gd2hpY2ggaXMgY3VycmVudGx5IGludm9rZWQgZnJvbQ0KPiB0aGUgI05NIGhhbmRs
ZXI6DQo+IA0KPiAgIDEpIFVzZSBndWVzdCBwZXJtaXNzaW9ucyBhbmQgc2l6ZXMgZm9yIHRoZSB1
cGRhdGUNCj4gDQo+ICAgMikgVXBkYXRlIGZwdV9ndWVzdCBzdGF0ZSBhY2NvcmRpbmdseQ0KPiAN
Cj4gICAzKSBUYWtlIGludG8gYWNjb3VudCB0aGF0IHRoZSBlbmFibGluZyBjYW4gYmUgdHJpZ2dl
cmVkIGVpdGhlciBmcm9tIGENCj4gICAgICBydW5uaW5nIGd1ZXN0IHZpYSBYU0VUQlYgYW5kIE1T
Ul9JQTMyX1hGRCB3cml0ZSBlbXVsYXRpb24gYW5kIGZyb20NCg0KJ2FuZCBmcm9tJyAtPiAnb3Ig
ZnJvbScNCg0KPiAgICAgIGEgZ3Vlc3QgcmVzdG9yZS4gSW4gdGhlIGxhdHRlciBjYXNlIHRoZSBn
dWVzdHMgZnBzdGF0ZSBpcyBub3QgdGhlDQo+ICAgICAgY3VycmVudCB0YXNrcyBhY3RpdmUgZnBz
dGF0ZS4NCj4gDQo+IFNwbGl0IHRoZSBmdW5jdGlvbiBhbmQgaW1wbGVtZW50IHRoZSBndWVzdCBt
ZWNoYW5pY3MgdGhyb3VnaG91dCB0aGUNCj4gY2FsbGNoYWluLg0KPiANCj4gU2lnbmVkLW9mZi1i
eTogVGhvbWFzIEdsZWl4bmVyIDx0Z2x4QGxpbnV0cm9uaXguZGU+DQoNClsuLi5dDQo+IEBAIC0x
NTUzLDYgKzE1MzEsMTMgQEAgc3RhdGljIGludCBmcHN0YXRlX3JlYWxsb2ModTY0IHhmZWF0dXJl
cw0KPiAgCW5ld2Zwcy0+dXNlcl9zaXplID0gdXNpemU7DQo+ICAJbmV3ZnBzLT5pc192YWxsb2Mg
PSB0cnVlOw0KPiANCj4gKwlpZiAoZ3Vlc3RfZnB1KSB7DQo+ICsJCW5ld2Zwcy0+aXNfZ3Vlc3Qg
PSB0cnVlOw0KPiArCQluZXdmcHMtPmlzX2NvbmZpZGVudGlhbCA9IGN1cmZwcy0+aXNfY29uZmlk
ZW50aWFsOw0KPiArCQluZXdmcHMtPmluX3VzZSA9IGN1cmZwcy0+aW5fdXNlOw0KPiArCQlndWVz
dF9mcHUtPnhmZWF0dXJlcyB8PSB4ZmVhdHVyZXM7DQo+ICsJfQ0KPiArDQoNCkFzIHlvdSBleHBs
YWluZWQgZ3Vlc3QgZnBzdGF0ZSBpcyBub3QgY3VycmVudCBhY3RpdmUgaW4gdGhlIHJlc3Rvcmlu
ZyANCnBhdGgsIHRodXMgaXQncyBub3QgY29ycmVjdCB0byBhbHdheXMgaW5oZXJpdCBhdHRyaWJ1
dGVzIGZyb20gdGhlIA0KYWN0aXZlIG9uZS4NCg0KQWxzbyB3ZSB3YW50IHRvIGF2b2lkIHRvdWNo
aW5nIHJlYWwgaGFyZHdhcmUgc3RhdGUgaWYgZ3Vlc3RfZnBzdGF0ZQ0KIT0gY3VyZnBzLCBlLmcu
Og0KDQoJaWYgKHRlc3RfdGhyZWFkX2ZsYWcoVElGX05FRURfRlBVX0xPQUQpKQ0KCQlmcHJlZ3Nf
cmVzdG9yZV91c2VycmVncygpOw0KDQo+ICsJaWYgKGd1ZXN0X2ZwdSkgew0KPiArCQljdXJmcHMg
PSB4Y2hnKCZndWVzdF9mcHUtPmZwc3RhdGUsIG5ld2Zwcyk7DQo+ICsJCS8qIElmIGN1cmZwcyBp
cyBhY3RpdmUsIHVwZGF0ZSB0aGUgRlBVIGZwc3RhdGUgcG9pbnRlciAqLw0KPiArCQlpZiAoZnB1
LT5mcHN0YXRlID09IGN1cmZwcykNCj4gKwkJCWZwdS0+ZnBzdGF0ZSA9IG5ld2ZwczsNCj4gKwl9
IGVsc2Ugew0KPiArCQljdXJmcHMgPSB4Y2hnKCZmcHUtPmZwc3RhdGUsIG5ld2Zwcyk7DQo+ICsJ
fQ0KPiArDQo+ICsJeGZkX3VwZGF0ZV9zdGF0ZShmcHUtPmZwc3RhdGUpOw0KDQphbmQgYWxzbyBo
ZXJlLg0KDQo+IEBAIC0xNjk3LDE0ICsxNjk0LDE2IEBAIGludCB4ZmRfZW5hYmxlX2ZlYXR1cmUo
dTY0IHhmZF9lcnIpDQo+ICAJc3Bpbl9sb2NrX2lycSgmY3VycmVudC0+c2lnaGFuZC0+c2lnbG9j
ayk7DQo+IA0KPiAgCS8qIElmIG5vdCBwZXJtaXR0ZWQgbGV0IGl0IGRpZSAqLw0KPiAtCWlmICgo
eHN0YXRlX2dldF9ob3N0X2dyb3VwX3Blcm0oKSAmIHhmZF9ldmVudCkgIT0geGZkX2V2ZW50KSB7
DQo+ICsJaWYgKCh4c3RhdGVfZ2V0X2dyb3VwX3Blcm0oISFndWVzdF9mcHUpICYgeGZkX2V2ZW50
KSAhPSB4ZmRfZXZlbnQpIHsNCj4gIAkJc3Bpbl91bmxvY2tfaXJxKCZjdXJyZW50LT5zaWdoYW5k
LT5zaWdsb2NrKTsNCj4gIAkJcmV0dXJuIC1FUEVSTTsNCj4gIAl9DQo+IA0KPiAgCWZwdSA9ICZj
dXJyZW50LT5ncm91cF9sZWFkZXItPnRocmVhZC5mcHU7DQo+IC0Ja3NpemUgPSBmcHUtPnBlcm0u
X19zdGF0ZV9zaXplOw0KPiAtCXVzaXplID0gZnB1LT5wZXJtLl9fdXNlcl9zdGF0ZV9zaXplOw0K
PiArCXBlcm0gPSBndWVzdF9mcHUgPyAmZnB1LT5ndWVzdF9wZXJtIDogJmZwdS0+cGVybTsNCj4g
Kwlrc2l6ZSA9IHBlcm0tPl9fc3RhdGVfc2l6ZTsNCj4gKwl1c2l6ZSA9IHBlcm0tPl9fdXNlcl9z
dGF0ZV9zaXplOw0KPiArDQoNCkRvIHdlIHdhbnQgdG8gbWVudGlvbiBpbiB0aGUgY29tbWl0IG1z
ZyB0aGF0IGZwc3RhdGUgDQpyZWFsbG9jYXRpb24gc2l6ZSBpcyBiYXNlZCBvbiBwZXJtaXNzaW9u
cyBpbnN0ZWFkIG9mIHJlcXVlc3RlZCANCmZlYXR1cmVzPyBUaGUgaW50dWl0aXZlIHRob3VnaHQg
aXMgdGhhdCBlYWNoIHRpbWUgYSBuZXcgZmVhdHVyZSBpcyANCnJlcXVlc3RlZCB0aGlzIGV4cGFu
ZHMgdGhlIGJ1ZmZlciB0byBtYXRjaCB0aGUgcmVxdWVzdGVkIGZlYXR1cmUuLi4NCg0KVGhhbmtz
DQpLZXZpbg0K
