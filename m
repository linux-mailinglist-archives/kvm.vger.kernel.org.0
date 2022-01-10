Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836D5488F81
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 06:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238627AbiAJFPz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 00:15:55 -0500
Received: from mga05.intel.com ([192.55.52.43]:30407 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238608AbiAJFPx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 00:15:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641791753; x=1673327753;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9DGsroFEDApKRkXloowZigcGqaCtT60D7QsMoKnb/cQ=;
  b=Jozs/FRjIA8WeNhBjVlhiXHMBfvF397NMD5zg2+kJZX7ZwDJ/QZ1RZEd
   B2Rw/1kWNI0f6pqCvMJARtgzuWvnd5oO0oCUs/eeR5p39Yn7rxJPdjgUw
   BCdEhmI4YWr7rggTkSUbZYdGYrAgAg/P1PDcz82H3IyN9qs7y0VBxA9EN
   0ZaJVoqwxzeGDCzhmkzLsIYt0Gh+rNkZbVr+sShZz9lNB6s5pj4Uy+6II
   kP0bjgGmRo3XHqiVzrI1yF/70JNHmlqGYgJf7aUfwLJBR3HED532DJQ9b
   7KxJ4FYfidLf0duqe6E2+1psixV6ZmTkZQRhO5TvKLB6LpPh8NoHFylbD
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10222"; a="329495849"
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="329495849"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 21:15:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="527850984"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 09 Jan 2022 21:15:53 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sun, 9 Jan 2022 21:15:53 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sun, 9 Jan 2022 21:15:52 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Sun, 9 Jan 2022 21:15:52 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Sun, 9 Jan 2022 21:15:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kB42A3BNySmpV9Wkr3tV/AxXiEbRam9zlrX9eCtM6iaILiSdVWg9TKhXUILruIvB+A4B3EUaFLVgunpKP/9MaT5uK1j8/praHnNKJIGGgnIkWK12OkW1goScWOsF56PEaHrZoQOtkyIESn+1jBMqw5ySxg+8qiMiyLLD7WwjFS8qc9LMm1bJ25cjtHQSNUZuEa8ZxGCj9Je4O9wORGAkIsSWgcirIGTDaJIiQh/qGmXL1t/8FlFcTjutSHQSEvPa76Bmfs6hKjswiGhW6aR7hoc15MXqr1dPsU0Ex/+I3UMEWc5t5zfoGMXpxOfwQ1UvEJk5ERsxGmCjthYS75+72w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9DGsroFEDApKRkXloowZigcGqaCtT60D7QsMoKnb/cQ=;
 b=Em0bvuS6TGHIjo5TzdU1T2RhJYA4D4m4MpNfYJycB3qiEFo64lfR2Ivx/ElFPxepo1Alx0YYyByC6kQTIxHWjwaUBiG5tUqmlRnGhktUyULGAeUcm4xcknWAOy4IUBq2LlTQrsbHSuJEBsz1q4jLu42xKMmWe5UIJjXPMSPE+MMtzuzn+npP4ybXwG9lJOCbNqYq3kS7UFiBjFIrXnbqdVjUYDyaL7Bi2MN6iCtg3xmaSJ1CjgOB1qbmXYgcqlfPMjgHCERaR6R9Ad2T7w2vJ5RgAZqjteg5uOP8HBrlGHvyNhlMQ+sril22or6E5jMWNxNiSy84ry1Lx73iQWnFag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (13.101.156.242) by
 BN7PR11MB2708.namprd11.prod.outlook.com (52.135.252.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.7; Mon, 10 Jan 2022 05:15:44 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%2]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 05:15:44 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Borislav Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Zeng, Guang" <guang.zeng@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>
Subject: RE: [PATCH v6 05/21] x86/fpu: Make XFD initialization in
 __fpstate_reset() a function argument
Thread-Topic: [PATCH v6 05/21] x86/fpu: Make XFD initialization in
 __fpstate_reset() a function argument
Thread-Index: AQHYA/gpzyW8+ydO5UO/RNIfEDi71KxX9ceAgAO5JdA=
Date:   Mon, 10 Jan 2022 05:15:44 +0000
Message-ID: <BN9PR11MB527688406C0BDCF093C718858C509@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220107185512.25321-1-pbonzini@redhat.com>
 <20220107185512.25321-6-pbonzini@redhat.com> <YdiX5y4KxQ7GY7xn@zn.tnic>
In-Reply-To: <YdiX5y4KxQ7GY7xn@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: efd64367-9051-4a96-d2d3-08d9d3f840c5
x-ms-traffictypediagnostic: BN7PR11MB2708:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN7PR11MB27089AF3F994634F9C9FDA838C509@BN7PR11MB2708.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cxCdxhZJYdfmACS9D1XImlq5f393rCruwz9LpMT9YNJmvVSBUzvXcTmG7lUOkSIPhEhB2Gl+7OVQQdmrVaBpYR3NIZfUnSpymJoYG03oxKun/BdcVU8cV0AWmsLomC2rJt7H5nGkmSs/xqc4pdkNCHnW7k9rlLf4rkby2AHUvWXQuKQY0l4UL7JBDW9KF0pLcUxgchq+CuNBZ68c07U2w8DZjt8Snw/YPsVBWGrmUjq1AhGkIFL6bE6gtjcMjF7T0c0811mnKXKDfd4VyKgx4s+imwNvD5dy8SFxaRMQMlVTHv1cu7XqSRFKWkdBwJOleGboiBG/soVHYMjtt4mWnLFwHnFG79kQh7wERq4ScDlerXbrR4UVEq1f4Yl+Q3OHZaI0CrKpky5rUxcBWBhHsVpw0jFPMokxY5YtP8tTOkVhPUDCfiGaycRDiGUeBnHYPmkP1lIME4w3+tiVMtoagAnZvV+NDmUroetrV/tYp5nQlRbWqI4KIOlSLlWhROmUdxjyk18jsyQ2jRqi+CFZ+lTF5lX3bcADWTLFs1lm8hAJawREbBSUfC016+95VP5Cw3Zij76qB1BT0FAfSByvBB0+0XPUF9bxGvx4Nrq4N7rE+Hn+L39YV1DY1etZl96OprW+SFOigGXCJbsOcT4xtIFr/we6AyHqJ8NQlInej1X4Hteda+iGUb6g1nwTfZrTDrwt3qFydb3tT+BTmCoBfkNLCT5Yex1PyAzkBuzKom5KgDs6PIHAp3c/YEXqg5SJP7Ko1jw3Kk2/GPW5uKs6q/U3Zy0jrKodgdPXvB2lu9w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(107886003)(55016003)(8676002)(186003)(7696005)(86362001)(52536014)(71200400001)(110136005)(6506007)(66556008)(76116006)(66946007)(64756008)(66446008)(2906002)(66476007)(54906003)(9686003)(508600001)(26005)(8936002)(83380400001)(38070700005)(316002)(38100700002)(122000001)(82960400001)(33656002)(4326008)(966005)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VzdDQ1BDK2RaV0VDVDZDRnB5UEMwQ1FPRDB4eFNVcGNHOGRQQ2hLWDl5VTR3?=
 =?utf-8?B?Kzc1RUtQcW5Ld0kyL3NUeW0yb2M4UnpveGR4Ny9McWdXS255eWlvZnJCV3h5?=
 =?utf-8?B?SFZ1eGxCTU1mT3hOZjBTUG8wSjQ2UFFQSkNJdWhWcUlKT3BpaTRjckxTbk03?=
 =?utf-8?B?MEU5THhCZS9PRHd6anloZWk4c2pUODIvNlVVQlY3WkdMOGEzTXFGVVRXeHhR?=
 =?utf-8?B?dGt1N3hIT1c4eGUvR2dxUVQyQ0VLdGt0d3hSeVpWOHh3cnF6UkdPWUM4RWsw?=
 =?utf-8?B?d0F6eG9RYUVBUXhEMFpjOGk3aDJXeXNNQjdONDREbzRFai9zTEczakdsdk9y?=
 =?utf-8?B?U1ZjbUxtMUIzSkVzaURveGoycWtYQm9JaW1udG9TRnpadjcvdWkyemdaSVQ3?=
 =?utf-8?B?dy94dm53SVJ1WVJSeVVOcmZ0cnBFQ0tnT1lUcmNVcTNBZlZkclNuZzV0eDVp?=
 =?utf-8?B?MHRvQUVmUDJMQVVpR1prU3IrYlFRV2YvZVg4bE0weUZWSlVqTENjeStBdEJB?=
 =?utf-8?B?U0FtSVFoZmx5ZWtXM3Nqc0I0UVhmT3BmZmJ0Z0FMNmdQckZhTmdwMXh2b0Mw?=
 =?utf-8?B?UDkyd0JtcVQvRkY5dWdWZ2tmSkxNT0R2eTlEbkZhOWY5Mm9vRjlZUkdQbFZR?=
 =?utf-8?B?VkMyWlpiZ0FNbEkxVUxnZTFiWmxJaTMrdkp0c3czRElWb1djak5mRzV2Wldt?=
 =?utf-8?B?M0gxUEZrTkJBbVJTd3hSYXRNL0hKVVAyYUJkam1SZWt0Z21rWmMyT3FZeXNY?=
 =?utf-8?B?MHpkWEd1MHBNN0R0RW13eTlOaDlTemNBVWRjMkVBbHhtcUc1NDhrdnB4VDBq?=
 =?utf-8?B?SmlrcWZ5b1NYaU9wSlYzRmc4VnBCUUJydnZ6M3kzMXkxQ3VhaTZPS05Bazlv?=
 =?utf-8?B?eHF2SUEzbjU2eVJZWVQraHJRUFV3VUNabG1KdUNmb1BadzFUMk5hbFRoRnFy?=
 =?utf-8?B?K2F2WHFJWUNRTVdTYklmWWNkSEVUK3lpVWFxcCtoeDhJYTBSKzVPNmFBY3h2?=
 =?utf-8?B?VUdCRThhWUNJZjZvakJlZFp2cHJXMjdiVjd2dzlGUmlBbFdEZDJDb291Q3RC?=
 =?utf-8?B?QXR0UUgxL0ZTRi92T0oxVkJ6M3NQQUdEQTYrOXd2YVpsbTYyc3lES21tdkNC?=
 =?utf-8?B?OW1ZVWtFSUUvcGZiZXp3YXdSZWRPTjFoTDZpY0huc0hJZkRjQkRWa2MyaU15?=
 =?utf-8?B?WDRZVWFWdDJRY2dkeGlJNFpJWlVGdUFCQ0JqZFBlMVRRN3hiakdnYmNGKytK?=
 =?utf-8?B?V2JnOWRkdGQ2UWdCT2FGdVl0WE1HOERZZ3cvZG5pcmFuTm8rZU5VU1ZPcHdz?=
 =?utf-8?B?ZStuV3lKUEhLY1RDOGNRMmZFRnJDUjRqdGhPUmJ2R3ZtOC9nZTJUQWNyMnph?=
 =?utf-8?B?LzVLcXdMY0VobFJxY3o2QUpqSlhuNSsya0JzZjhTZytUaktCSnNiT3FIaFI4?=
 =?utf-8?B?a0VlMzRQZDE0d0YzRWNIT3RSeURIMWI0T2xYdDh4V1kwd00xWDNvSmVqK0d1?=
 =?utf-8?B?L3hkbTVtMUpRWjZyVGI0UXp1MTJGUmZEZUMvb1FaUGtweDhIYUdkVUpWWXRl?=
 =?utf-8?B?ajRGRGxmR0JHdnNpbEdLNUNMcGU3OUlpZlptZDdyT3UwQldZaFhLS1NQMzhM?=
 =?utf-8?B?S2RySmowZDV3TkNLa2IraXJ4SEF3SmhrYkxublYremRLQ1ROWXRvUkFXUkZl?=
 =?utf-8?B?WFlIMlRET0hUMjZlaEZFclFNTTN2Mmc5TnZEVzQxeWw2amN5RWRVdFZIaFN5?=
 =?utf-8?B?VUdlcy9kd1M3TkNod2dveHU0T0I2Tk5ncElSN3NpT2xGVlhQd1ZvTHNaWUJM?=
 =?utf-8?B?WGVlR3JhL1lueGhUdVJ4Tnk0VzNVMzk3U1VQeHB5YmtONW5Cd3ZSWVBPVm9P?=
 =?utf-8?B?SVp0QTd2L1hwdE50MnIvQ1dsOUY4amJTdHpybmRWL2NVeUhwZ3Z6UkV2cE4y?=
 =?utf-8?B?cGR1bURzaUMyRmxaQXlHWVhTUmNYVDFCNnlmU3UrUjF5LzQvYzJidHFDTXZF?=
 =?utf-8?B?dXM4Q2pRdlljc2JNcHFvaGM5SjJIOGJ4R1Y1UDBLdWVlMnFOZ2JQYVJXSjBJ?=
 =?utf-8?B?aU9kdUFKbm45dVZ0WWlHMlZCMklKRS9LcS95OWg3OUE0d0E2cjRIWG50Y3B6?=
 =?utf-8?B?bE1vdURBRVozSjhoNE5iWDJZRlFhM1pjWGFaSURjNW9rSEdKT29pTGJiN1Bo?=
 =?utf-8?Q?D1TRMDjjzpZnKuWL83gqJOM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efd64367-9051-4a96-d2d3-08d9d3f840c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2022 05:15:44.0169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YgA0NQl8wo8QuLqO7VzBzdITRGsJwTV5ZxcbWJblTMxvsJckoAeZlFRbJ5GzoCSVzztU85KR57SfTvQ3eKq9BA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2708
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBCb3Jpc2xhdiBQZXRrb3YgPGJwQGFsaWVuOC5kZT4NCj4gU2VudDogU2F0dXJkYXks
IEphbnVhcnkgOCwgMjAyMiAzOjQ0IEFNDQo+IA0KPiBPbiBGcmksIEphbiAwNywgMjAyMiBhdCAw
MTo1NDo1NlBNIC0wNTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0KPiA+IEZyb206IEppbmcgTGl1
IDxqaW5nMi5saXVAaW50ZWwuY29tPg0KPiA+DQo+ID4gdkNQVSB0aHJlYWRzIGFyZSBkaWZmZXJl
bnQgZnJvbSBuYXRpdmUgdGFza3MgcmVnYXJkaW5nIHRvIHRoZSBpbml0aWFsIFhGRA0KPiA+IHZh
bHVlLiBXaGlsZSBhbGwgbmF0aXZlIHRhc2tzIGZvbGxvdyBhIGZpeGVkIHZhbHVlIChpbml0X2Zw
c3RhdGU6OnhmZCkNCj4gPiBlc3RhYmxpc2hlZCBieSB0aGUgRlBVIGNvcmUgYXQgYm9vdCwgdkNQ
VSB0aHJlYWRzIG5lZWQgdG8gb2JleSB0aGUgcmVzZXQNCj4gPiB2YWx1ZSAoaS5lLiBaRVJPKSBk
ZWZpbmVkIGJ5IHRoZSBzcGVjaWZpY2F0aW9uLCB0byBtZWV0IHRoZSBleHBlY3RhdGlvbiBvZg0K
PiA+IHRoZSBndWVzdC4NCj4gPg0KPiA+IExldCB0aGUgY2FsbGVyIHN1cHBseSBhbiBhcmd1bWVu
dCBhbmQgYWRqdXN0IHRoZSBob3N0IGFuZCBndWVzdCByZWxhdGVkDQo+ID4gaW52b2NhdGlvbnMg
YWNjb3JkaW5nbHkuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBUaG9tYXMgR2xlaXhuZXIgPHRn
bHhAbGludXRyb25peC5kZT4NCj4gDQo+IElmIEppbmcgaXMgYXV0aG9yLCB0aGVuIHRnbHgncyBT
T0Igc2hvdWxkIGNvbWUgYWZ0ZXIgSmluZydzIHRvIG1lYW4sDQo+IHRnbHggaGFuZGxlZCBpdCBm
dXJ0aGVyLg0KPiANCj4gQXMgaXQgaXMgbm93LCBpdCBsb29rcyB3cm9uZy4NCg0KVGhhbmtzIGZv
ciBwb2ludGluZyBpdCBvdXQhIEFjdHVhbGx5IHRoaXMgaXMgb25lIGFyZWEgd2hpY2ggd2UgZGlk
bid0IGdldA0KYSBjbGVhciBhbnN3ZXIgZnJvbSAnc3VibWl0dGluZy1wYXRjaGVzLnJzdCcgYW5k
IG5vdyBwb3NzaWJseSBhIGdvb2QNCmNoYW5jZSB0byBnZXQgaXQgY2xhcmlmaWVkLg0KDQpUaGlz
IHBhdGNoIHdhcyBoYW5kbGVkIGluIGFuIGludGVyZXN0aW5nIHdheSBkdWUgdG8gSmluZydzIHR3
byBhYnNlbmNlczoNCg0KSW50ZXJuYWwgdmVyc2lvbjogSmluZyB3YXMgdGhlIG9yaWdpbmFsIGF1
dGhvcg0KDQoJU2lnbmVkLW9mZi1ieTogSmluZyBMaXUgPGppbmcyLmxpdUBpbnRlbC5jb20+DQoN
Ci0tLSBKaW5nJ3MgZmlyc3QgYWJzZW5jZSAtLS0NCg0KdjE6IFlhbmcgd2FzIHRoZSBzdWJtaXR0
ZXI6DQoNCglTaWduZWQtb2ZmLWJ5OiBKaW5nIExpdSA8amluZzIubGl1QGludGVsLmNvbT4NCglT
aWduZWQtb2ZmLWJ5OiBZYW5nIFpob25nIDx5YW5nLnpob25nQGludGVsLmNvbT4NCg0KVGhvbWFz
IHVwZGF0ZWQgaXQgaW4gaGlzIHBlcnNvbmFsIGJyYW5jaCB3aGVuIHJldmlld2luZyB2MToNCg0K
CUZyb206IEppbmcgTGl1IDxqaW5nMi5saXVAaW50ZWwuY29tPg0KDQoJU2lnbmVkLW9mZi1ieTog
SmluZyBMaXUgPGppbmcyLmxpdUBpbnRlbC5jb20+DQoJU2lnbmVkLW9mZi1ieTogWWFuZyBaaG9u
ZyA8eWFuZy56aG9uZ0BpbnRlbC5jb20+DQoJU2lnbmVkLW9mZi1ieTogVGhvbWFzIEdsZWl4bmVy
IDx0Z2x4QGxpbnV0cm9uaXguZGU+DQoNCi0tLSBKaW5nIHdhcyBiYWNrIC0tLQ0KDQp2Mi12Mzog
SmluZyB3YXMgdGhlIHN1Ym1pdHRlcjoNCg0KVGhlIG9wZW4gaGVyZSBpcyB3aGV0aGVyIEppbmcg
c2hvdWxkIGNoYW5nZSB0aGUgU29CIG9yZGVyOg0KDQoJU2lnbmVkLW9mZi1ieTogWWFuZyBaaG9u
ZyA8eWFuZy56aG9uZ0BpbnRlbC5jb20+DQoJU2lnbmVkLW9mZi1ieTogVGhvbWFzIEdsZWl4bmVy
IDx0Z2x4QGxpbnV0cm9uaXguZGU+DQoJU2lnbmVkLW9mZi1ieTogSmluZyBMaXUgPGppbmcyLmxp
dUBpbnRlbC5jb20+DQoNCm9yIGp1c3QgYXBwZW5kIGhlciBuYW1lIGFnYWluOg0KDQoJU2lnbmVk
LW9mZi1ieTogSmluZyBMaXUgPGppbmcyLmxpdUBpbnRlbC5jb20+DQoJU2lnbmVkLW9mZi1ieTog
WWFuZyBaaG9uZyA8eWFuZy56aG9uZ0BpbnRlbC5jb20+DQoJU2lnbmVkLW9mZi1ieTogVGhvbWFz
IEdsZWl4bmVyIDx0Z2x4QGxpbnV0cm9uaXguZGU+DQoJU2lnbmVkLW9mZi1ieTogSmluZyBMaXUg
PGppbmcyLmxpdUBpbnRlbC5jb20+DQoNClRoZSBmb3JtZXIgd2FzIHNlbGVjdGVkIGZvciB0aGlz
IHBhdGNoLg0KDQotLS0gSmluZydzIDJuZCBhYnNlbmNlIC0tLQ0KDQp2NC12NTogWWFuZyB3YXMg
dGhlIHN1Ym1pdHRlci4NCg0KU29CIG9yZGVyIHdhcyBwYXJ0aWFsbHkgY2hhbmdlZCAoZm9yIFlh
bmcncyBTb0IpIGJ1dCBmb3Jnb3QgdG8gbWFrZSBKaW5nJ3MNClNvQiBhcyB0aGUgZmlyc3QuIEl0
IHNob3VsZCBiZToNCg0KCUZyb206IEppbmcgTGl1IDxqaW5nMi5saXVAaW50ZWwuY29tPg0KDQoJ
U2lnbmVkLW9mZi1ieTogSmluZyBMaXUgPGppbmcyLmxpdUBpbnRlbC5jb20+DQoJU2lnbmVkLW9m
Zi1ieTogVGhvbWFzIEdsZWl4bmVyIDx0Z2x4QGxpbnV0cm9uaXguZGU+DQoJU2lnbmVkLW9mZi1i
eTogWWFuZyBaaG9uZyA8eWFuZy56aG9uZ0BpbnRlbC5jb20+DQoNCklmIHRoZSBydWxlIGlzIHRo
YXQgU29CIG9yZGVyIHNob3VsZCBub3QgYmUgY2hhbmdlZCwgdGhlbiBpdCB3aWxsIGJlOg0KDQoJ
RnJvbTogSmluZyBMaXUgPGppbmcyLmxpdUBpbnRlbC5jb20+DQoNCglTaWduZWQtb2ZmLWJ5OiBK
aW5nIExpdSA8amluZzIubGl1QGludGVsLmNvbT4NCglTaWduZWQtb2ZmLWJ5OiBZYW5nIFpob25n
IDx5YW5nLnpob25nQGludGVsLmNvbT4NCglTaWduZWQtb2ZmLWJ5OiBUaG9tYXMgR2xlaXhuZXIg
PHRnbHhAbGludXRyb25peC5kZT4NCglTaWduZWQtb2ZmLWJ5OiBKaW5nIExpdSA8amluZzIubGl1
QGludGVsLmNvbT4NCglTaWduZWQtb2ZmLWJ5OiBZYW5nIFpob25nIDx5YW5nLnpob25nQGludGVs
LmNvbT4NCg0KPiANCj4gRGl0dG8gZm9yIHBhdGNoZXMgMTAsIDExLCAxMiwgMTMuDQo+IA0KPiBB
bHNvLCBJIHdvbmRlciBpZiBhbGwgdGhvc2UgU2lnbmVkLW9mZi1ieSdzIGRvIG1lYW4gImhhbmRs
ZWQiIG9yDQo+IENvLWRldmVsb3BlZC1ieSBidXQgSSBoYXZlbid0IHRyYWNrZWQgdGhhdCBwYXJ0
aWN1bGFyIHBpbGUgc28uLi4NCj4gDQo+ID4gU2lnbmVkLW9mZi1ieTogSmluZyBMaXUgPGppbmcy
LmxpdUBpbnRlbC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogWWFuZyBaaG9uZyA8eWFuZy56aG9u
Z0BpbnRlbC5jb20+DQo+ID4gTWVzc2FnZS1JZDogPDIwMjIwMTA1MTIzNTMyLjEyNTg2LTYteWFu
Zy56aG9uZ0BpbnRlbC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogUGFvbG8gQm9uemluaSA8cGJv
bnppbmlAcmVkaGF0LmNvbT4NCj4gDQo+IC0tDQo+IFJlZ2FyZHMvR3J1c3MsDQo+ICAgICBCb3Jp
cy4NCj4gDQo+IGh0dHBzOi8vcGVvcGxlLmtlcm5lbC5vcmcvdGdseC9ub3Rlcy1hYm91dC1uZXRp
cXVldHRlDQo=
