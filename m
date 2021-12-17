Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03063479008
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 16:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234703AbhLQPdy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 10:33:54 -0500
Received: from mga17.intel.com ([192.55.52.151]:47040 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234889AbhLQPdm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 10:33:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639755222; x=1671291222;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/plCXUqGpWR+mgljvGE2AEcHsB1OVKB5C3/nxDWKBaM=;
  b=KsiZ/EOGbLVIht1h0eQT5+jharBbKMyLdNQIWRxMs8R3ldz31m0Ux5GQ
   KXHITuSMOmrBawCnOgiv/Xc+Wdg9VigyWUGRQR87Pa6FxHC5zVp00c+BQ
   +2ghGmugsI3yNMxJWiSlXaHF2/0HCEPGNY67db0QU07h2G/BuoateIJWs
   FvLxnfdW0OLhsZZTgQ+4NtyYT/J4K40xNspRF0rlcy5jv8jYTawA3ci3M
   5inZ+nssZupFO6ORDcfUOLQ+tWKa1FTo56oZT7WYJnJDMz26uHzrG1otl
   VddCz17Oy+pXYudyJm8WMsZvzoqC+FVpMhd8Kokd9XuDnFU5BBGYOK4e6
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="220453661"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="220453661"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 07:33:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="605923605"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Dec 2021 07:33:40 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 17 Dec 2021 07:33:40 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 17 Dec 2021 07:33:40 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 17 Dec 2021 07:33:40 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 17 Dec 2021 07:33:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JKc/gy58Rtvs50sneqTjfzzP12xkjZ5IXZh22lMhVKQR6LZUHMQuj19dZ9FiPOxwR+B6QTrZ+4+l+cGZ8jahoDasU7/915Fg6M4girRprcith7xvw4tbi2/xaFLikswGp2uOmDpxnoZWxLlpsrn/+Up1SgvYR+nrRaGyEYwB56uJoG9H2QJIi+bZSJiGhcOICzanbsDUnL5ACYsniug+HSUzYybx4jVAVZ/9H3ckWmvqlIrarmZx9SL2lpdSLi+McZg1rEVrCqRiucJ3y1EqAdeeO4xl1iLIpP36scgpS4L11dIlm4ZWPti0XplELy2FMwDPW3Z6nn+mLH7pd4akMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/plCXUqGpWR+mgljvGE2AEcHsB1OVKB5C3/nxDWKBaM=;
 b=gufRjepmUA73pzN5IYrTcOcPFQEAXKpiLIa0eiMEnPOpoH8hyVaau/v1JsHb6KKlOhWiUfKQm5Ajnkdi21aFuvUiEhJFkPlSMuVPJbuE0UFE9PD1mSjZoo7Gn2D8NT5iRX3lyGErllMEcweCaMrCynn6FDDzT2B9paie3k6UiLcxdnZqdPCuCf9LqjvDRsKAR237WrsC7OaGG03gU0GwFgZbxwkCnK0t2/YzHccyxAgOhF2QqVbzWV2IKeVCVzeFZUQmIbBolLCHBMI+6e+asuTff8Ag8qVdkqgc8k9u9MFwfMt3dOW7UCZood7gfTgctyiylSdfx6JlfcbsiCTXEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB1857.namprd11.prod.outlook.com (2603:10b6:404:103::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Fri, 17 Dec
 2021 15:33:34 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%3]) with mapi id 15.20.4778.018; Fri, 17 Dec 2021
 15:33:34 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "quintela@redhat.com" <quintela@redhat.com>
CC:     LKML <linux-kernel@vger.kernel.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>
Subject: RE: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
Thread-Topic: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
Thread-Index: AQHX8JViV3rUbi5iYUCgo3JeBUJUo6wyGCEAgAAIi4CAAAi/gIAAH5YAgAAT0FyAABRSAIAAEuhSgABOroCAAIPaAIAABQ6AgADz3ECAAI+dAIAAA/xggABJxoCAAZ1E4A==
Date:   Fri, 17 Dec 2021 15:33:34 +0000
Message-ID: <BN9PR11MB5276D6D0CA227775941254B18C789@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20211214022825.563892248@linutronix.de>
 <20211214024948.048572883@linutronix.de>
 <854480525e7f4f3baeba09ec6a864b80@intel.com> <87zgp3ry8i.ffs@tglx>
 <b3ac7ba45c984cf39783e33e0c25274d@intel.com> <87r1afrrjx.ffs@tglx>
 <87k0g7qa3t.fsf@secure.mitica> <87k0g7rkwj.ffs@tglx>
 <878rwm7tu8.fsf@secure.mitica> <afeba57f71f742b88aac3f01800086f9@intel.com>
 <878rwmrxgb.ffs@tglx> <a4fbf9f8-8876-f58c-d2b6-15add35bedd0@redhat.com>
 <BN9PR11MB5276E2165EB86520520D54FD8C779@BN9PR11MB5276.namprd11.prod.outlook.com>
 <87fsqslwph.ffs@tglx>
 <BN9PR11MB52761B401F752514B22A23768C779@BN9PR11MB5276.namprd11.prod.outlook.com>
 <8735msljtm.ffs@tglx>
In-Reply-To: <8735msljtm.ffs@tglx>
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
x-ms-office365-filtering-correlation-id: 31464e80-1361-4947-f592-08d9c17296a6
x-ms-traffictypediagnostic: BN6PR11MB1857:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN6PR11MB18572FB3DD98C3C4A2BBF8C98C789@BN6PR11MB1857.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TAaYSJL8xAdTFAAGisJEsexRF44gjyA66RWHxTfCUNdppQZgF+CnCQT79kzoV/ZRn+CRM/iNgzF3lE4Am94UaBUudFIRn8N5RFquiY5o3u6r5riH0yQy7khlRLx9ZofNVc+2Imbr8YvuvdXBx2OaaFKTBhskwYzUoD6AclWSo5tj/h+cNhbqu7H0VtHO7eqR+mO6fHSapZBT2QWSb5RTCRYfBrnypU6w2UTXt4D1B6lLEdQzVFyfHQNRWNyPmJCxxUpkMfEZAqMcZaeqKh4oYLm/s0g0eMH5hvVgT6OsSiVQ6qbl5cYNvY3welroNHAKftQ0CMaVn/PANhJl0zig3CYHOS4Z0ftm8Qf1IiK3hf5gOZXO9pSZq3sSGO1uIidGuiS+ZkcGi7D81/f0l/jVafK3qDpghQD1Ma9MsxCz5TJ7nNMHakAvV3qd0tfCx8CZT35WzUA/0pl032+bjrF8ey0rdGobSzKXRb1ut5OHPMq2VmD9pdzuWhgTbZh5lq355kufOMzwhuWZhhIirWZfTNhkDOh9p8qneif4Xpfzo2lSSV0J+C4/7ks9iRW18v3gickkNcxP1/4TYDNas1jXW1TdiyCBtm8KRSGJ7WQ9ui7Bq6Q/GlHlbcWJqM2QUQKLOGt53qWD1Atm004AlKo3mJuKuolE/UwC1eqM2MPkOgqShf0MmqJdz6lkc8vu86kHy9QV0l97ABxktATiaQyE8w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(71200400001)(508600001)(4326008)(64756008)(6506007)(82960400001)(83380400001)(33656002)(122000001)(66476007)(66946007)(66556008)(66446008)(4744005)(76116006)(5660300002)(86362001)(38100700002)(186003)(9686003)(54906003)(26005)(55016003)(316002)(110136005)(8936002)(7696005)(2906002)(8676002)(52536014)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RU9ZOFNOVWc5aVpMZFh6TkNYYkJQRFF2Sjd6d1VaeVRuNU9vUUhPc3grUHhM?=
 =?utf-8?B?TWtaMVBqSWdwVTRqTGpaR3lyQ08yU0MwUlFyd3FIaG0xNDFHQ2Z6MXpLWTF1?=
 =?utf-8?B?ODZYYXJ0dTBHSmFDTEZiMmZmZFFYWHVtOUpUc3FWelhJS2hKVlNlTHpSWVdS?=
 =?utf-8?B?c014UW1qOVdXS1lFZ2pWQUdqemZtdEs0QlhvWFQzRk1ycnFYRG5TU1Z4d2c0?=
 =?utf-8?B?cG5UQngvak9LdHZXMGdMMXBQOXhhdTZnR0JHbkRveXp1RWhMWkZhck9GTzdH?=
 =?utf-8?B?aTRUY04wcUxFcTZxSzVZelpVWWdwaTRweXRGK1QxelJ6Vi90cUxGWGlDeGpE?=
 =?utf-8?B?RnYrUWlZQi9qNTQxdjhJZm5LelVEN0paa29uNXhCUVFuRVViTm90SjhrYXRy?=
 =?utf-8?B?MkxwclE3RUlPTWwxb1NvaW04dzFVTTRFR2pEYWVBbXFSaUEvaGVmbWVDTnNK?=
 =?utf-8?B?M0xUT0pjaXJyd2hEc1BZazZRU0tEeHptN1BubG9DMnFiWG5icUk5ZHJPVmJl?=
 =?utf-8?B?VGx6NEFJaEhZQ1V4Y0xoZ1NLQUhrZW5mdEFYbjl1anJacG1JVTdZUkJLWFRj?=
 =?utf-8?B?ZFhZVFFnSlh2a1JpVlJuMjRQeW95T2F3Ylp3eXVoR0dFbzIvYWUzcmVrYTJX?=
 =?utf-8?B?YnQ2NGg4TVdRUzAvSUFYV1ZnbXRGQmcxTjErTXNOZnhkd1l4VURLWXpUQVFT?=
 =?utf-8?B?R21NYy9Kb2VNYXo4WW1XeFUwRm1LdlFTNE82TG5wMFBYbWl1LytqWVowaVdM?=
 =?utf-8?B?U3VQZTJPMlVCTWhSczB6eDBTclNuR0Z3RFNzOVJ0WE1DYjdtamJMeGdORXgx?=
 =?utf-8?B?bmpGYkNVV1BZTTJjK2dJZWZIOENNbS9xUitPeXBhWjNkaDZqYUU0TTlWRHBF?=
 =?utf-8?B?VG0yVWdUdEdaR0dBdC84YlQyZms1M0sxR2szSmRVZHpmS3NZSWdON0diNGk2?=
 =?utf-8?B?aDc3TVVxQklld1NvUmx5OVhMQWphQm9HUjRyQmtmcExCZUZNTjg3TFdmTG4z?=
 =?utf-8?B?bk9mSzNJZ1BlMURTMjI3dmk0TXBWV2lEaTN6YkkxMXR6d3RpQkNLaW13SlJq?=
 =?utf-8?B?K3ByRzU3NFRjV3dVblpybm9oa2JmazNKaGt5L2RtclN1V2pwd0tkWjQzL0Fm?=
 =?utf-8?B?TE5oVFRaWG9KOFBvT3BKOEdWMFNwY2hDdEMvQXJubk9VcFVsZG1VcHBtWXFE?=
 =?utf-8?B?dzM4YWZnZ21tM0hrbjE0NzJVWkZ1a0syU2c0ajZqSzZicVFST3NZejUwdG9C?=
 =?utf-8?B?clZ3VW9ScG9QRU1ySFQvS25MUEVoSXJKYU0wLzB4ckJSNnRMM1NSc3VldVBJ?=
 =?utf-8?B?Qk1HT0NrN2VOUVRTRGRGdHkzQ0hIWHIvY1FIMWl2T0wvK3p3VEkyUndUbisz?=
 =?utf-8?B?cjA0TnJId1ZzMjZlZEdBa2dFK2tMZXYxUkdJMk9DRzRHcVUvMCswSXBjUTY4?=
 =?utf-8?B?M2NwbXhManRNby9iWWs1ZGdOcGVYUkNwOER3UWU4UTRodVpWNngyMUJDWFh1?=
 =?utf-8?B?R0VuZFkxY0dQUGNxU09qcGI3aEpZZkZRY3FUT2JOQmNZaXE5RG9WWm00S3pN?=
 =?utf-8?B?aFR6aHNWVUV5QW9lY20raW9mWGJvZWlCOXBxZjNjdWhiWEpIUllFclIvRUNw?=
 =?utf-8?B?ZStDRXlwSGNua2NQLytaVWl5UjYxZzFlUk13R1pTREh1L013OTNZbHNxQlBw?=
 =?utf-8?B?RjRZcFpzQTNqNjZqWFhwTzZmWk1aR3dsdmR1eUwrSnpPZWFkU3hMak1GbW0v?=
 =?utf-8?B?QVpiU3RMcmNFYVR3SFV6TjJDY3dQeCtvdDBCQS8zMmNOelkwS1B6eHBaZkZy?=
 =?utf-8?B?aWt0cEp1NGhpMmg0dFRPTnNtUER4MWpKV2xFSk94Wm9nV2xML3pVcVZVcW82?=
 =?utf-8?B?NEVRRzV0WWVMMnVSbDJkVTJMYWtwUXl3SXRRbTNtc0xqSFNLaWNyWUZ6OWZm?=
 =?utf-8?B?elFLWFBaT25sQ2RudkdJcHNzaXVzcWZtQm4xOG44T1pJWVhhdHV1clVybHFK?=
 =?utf-8?B?NlBsRVdRY1hidXZsRlMrQ3J0VnREcVhoWW1TcGxwd0Rra1p4ZnlwZlZUWnRs?=
 =?utf-8?B?WVRSM2ZQcS9KN2ppZTIxelVpb2FaRjJFakQ1LzN0VGJmUW9pWUNXTjBoTytw?=
 =?utf-8?B?enlLOU83V0Z5S3VHajZsYTZudmk4dTc5dXp6eGs2OWtiUDhXTEJMdFRBTzU5?=
 =?utf-8?Q?GSBqpF86W9FQEiY7b3VoY2U=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31464e80-1361-4947-f592-08d9c17296a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2021 15:33:34.5561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AnIsyxhrXDclxE7o3zzq4t2/YuRXgU67/YgqfGpR5vaDsEAPxl+FQjrAGNXR229FMsaRxbi4hWaH3QepRxF6MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1857
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBUaG9tYXMgR2xlaXhuZXIgPHRnbHhAbGludXRyb25peC5kZT4NCj4gU2VudDogVGh1
cnNkYXksIERlY2VtYmVyIDE2LCAyMDIxIDEwOjEzIFBNDQo+ID4NCj4gPiBZZXMsIHRoaXMgaXMg
dGhlIDNyZCBvcGVuIHRoYXQgSSBhc2tlZCBpbiBhbm90aGVyIHJlcGx5LiBUaGUgb25seSByZXN0
cmljdGlvbg0KPiA+IHdpdGggdGhpcyBhcHByb2FjaCBpcyB0aGF0IHRoZSBzeW5jIGNvc3QgaXMg
YWRkZWQgYWxzbyBmb3IgbGVnYWN5IE9TIHdoaWNoDQo+ID4gZG9lc24ndCB0b3VjaCB4ZmQgYXQg
YWxsLg0KPiANCj4gWW91IHN0aWxsIGNhbiBtYWtlIHRoYXQgY29uZGl0aW9uYWwgb24gdGhlIGd1
ZXN0IFhDUjAuIElmIGd1ZXN0IG5ldmVyDQo+IGVuYWJsZXMgdGhlIGV4dGVuZGVkIGJpdCB0aGVu
IG5laXRoZXIgdGhlICNOTSB0cmFwIG5vciB0aGUgWEZEIHN5bmMNCj4gYXJlIHJlcXVpcmVkLg0K
PiANCj4gQnV0IHllcywgdGhlcmUgYXJlIHRvbyBtYW55IG1vdmluZyBwYXJ0cyBoZXJlIDopDQo+
IA0KDQpZZXMuIE1hbnkgbW92aW5nIHBhcnRzIGJ1dCBpbiBnZW5lcmFsIGl0J3MgZ2V0dGluZyBj
bGVhbmVyIGFuZCBzaW1wbGlmaWVkLiDwn5iKDQoNCldlIGp1c3Qgc2VudCBvdXQgdjIgdG8gaG9w
ZWZ1bGx5IGxvY2sgZG93biBhbHJlYWR5LWNsb3NlZCBvcGVucy4gQmFzZWQgb24NCnRoYXQgd2Ug
Y2FuIHNlZSB3aGF0IHJlbWFpbnMgdG8gYmUgZnVydGhlciBzb2x2ZWQuDQoNCkFuZCByZWFsbHkg
YXBwcmVjaWF0ZSBhbGwgdGhlIHN1Z2dlc3Rpb25zIGZyb20geW91IGFuZCBQYW9sbyENCg0KVGhh
bmtzDQpLZXZpbg0K
