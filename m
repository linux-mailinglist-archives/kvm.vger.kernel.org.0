Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 095142D1E0C
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 00:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgLGXEL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 18:04:11 -0500
Received: from mga11.intel.com ([192.55.52.93]:62327 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726158AbgLGXEL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 18:04:11 -0500
IronPort-SDR: yoQrxdM6duvhugA1iIuTCfblb53rPDwN8MS5SvANIvWic8o6fQaVB2FmQVrFzrTDUHdTOclA/X
 dBLEoYvXr3+g==
X-IronPort-AV: E=McAfee;i="6000,8403,9828"; a="170286231"
X-IronPort-AV: E=Sophos;i="5.78,401,1599548400"; 
   d="scan'208";a="170286231"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2020 15:03:30 -0800
IronPort-SDR: Mbp6E6rTUOvkanad+PZv7R72Sk7hnjSkkq3ucqvnE2MtpRhMrzOiwtbhqUYcb+i2YLXf3sExVQ
 Fq3k/Ms1rHpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,401,1599548400"; 
   d="scan'208";a="317435682"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga008.fm.intel.com with ESMTP; 07 Dec 2020 15:03:30 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 7 Dec 2020 15:03:30 -0800
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 7 Dec 2020 15:03:29 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 7 Dec 2020 15:03:29 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 7 Dec 2020 15:03:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZQ2g77H3HQzOMupuW5R72Gp7VMIdLRj/NIpfL014HaDMmtLB93sh6g2uUkJT247EG/CDATFjTZzM/HtSC4ato7KzyZJ6uzef+nKdnAQ7C1+IcRM6+7YcLsP2eSMXrRDKMCENnDE80Bzk4tB5Rsl5m3sf7UNfhOYW0O6HDzE9G4IejCBRhoPYfwE7oIuHiurlp9Ra3XiNt1ON76akYVyNzvnhI2BcKembOxNpeRTw8QLFoIlTh8HVK3zHuMr+OpE+VxwzMCtoZUXnayavaS3TSY4phWiIf4PXgQ70xB9RVHrVbpDHF0TpQAY6W+kuQhtP3WPCHTreoNpTAEFswV4Xtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AwaeRn+rALXR0WA0siLnHiGRDvCmU2DAhc6s8hh72p8=;
 b=Qd5URM0JsD8TSvX17x0iV0nBfvbgJ/deInd1nKRTSHC+NavBfLNVSe7kz8s/OL3yilVHoMo4qa80YFFD5jfrlUtFPvK1h17v522kb/p1QatAN4bOrSCarxDfITPkhZ0sVePn8AREk92FNwUiYlZIv271mv4e0BHqtfmjZX1b0NbicZFF7JVu3MclB169RteHYWrIJTx3BYmuFFafHT7zgWbIklmMktUv3aeHtEKrBBz/Dx2MmMvyO7M7F5kLkvBU5hK/6B9O7nnb1iIlCIIowpPDqrBgVSvHn7Fgn+YXm10aLPZmt0gkx+1teTs5C6P2+SqxPDDz7BShWjr9Q5+E3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AwaeRn+rALXR0WA0siLnHiGRDvCmU2DAhc6s8hh72p8=;
 b=sL1RwqOcT1pcBrUm1C2523Kskiy0IbE4qhK+6PNRuUm4bK2LMi6/Mgmv3aMS36f2RIFazONkfD/ADggJdhC89Bk7eqaU99F3YLWhoMDv4ltTd/w5QR3CwnAZ4SWbSHb+6oOTWblNY+3D4Dbx3NkcIQwXXHEvuO1TMRBj9ybTBW4=
Received: from BY5PR11MB4056.namprd11.prod.outlook.com (2603:10b6:a03:18c::17)
 by BYAPR11MB3461.namprd11.prod.outlook.com (2603:10b6:a03:7b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Mon, 7 Dec
 2020 23:03:27 +0000
Received: from BY5PR11MB4056.namprd11.prod.outlook.com
 ([fe80::a556:7843:c77:936a]) by BY5PR11MB4056.namprd11.prod.outlook.com
 ([fe80::a556:7843:c77:936a%5]) with mapi id 15.20.3632.023; Mon, 7 Dec 2020
 23:03:27 +0000
From:   "Bae, Chang Seok" <chang.seok.bae@intel.com>
To:     "bp@suse.de" <bp@suse.de>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Brown, Len" <len.brown@intel.com>
Subject: Re: [PATCH v2 01/22] x86/fpu/xstate: Modify area init helper
 prototypes to access all the possible areas
Thread-Topic: [PATCH v2 01/22] x86/fpu/xstate: Modify area init helper
 prototypes to access all the possible areas
Thread-Index: AQHWvszlf9f10cfw1UitI0Rshkg6Z6nr+smAgABgxwA=
Date:   Mon, 7 Dec 2020 23:03:27 +0000
Message-ID: <2c4c4340feaf8542fa41e9f4563ecb2b58eef996.camel@intel.com>
References: <20201119233257.2939-1-chang.seok.bae@intel.com>
         <20201119233257.2939-2-chang.seok.bae@intel.com>
         <20201207171251.GB16640@zn.tnic>
In-Reply-To: <20201207171251.GB16640@zn.tnic>
Reply-To: "Bae, Chang Seok" <chang.seok.bae@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.55.41]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d147a5f-ba84-4994-adca-08d89b044ee3
x-ms-traffictypediagnostic: BYAPR11MB3461:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB3461EAA2EE7154958F1FD265D8CE0@BYAPR11MB3461.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hpJALPzjB6qJwrGirZNjsJY/lzACrgXTn76yA63efYvP13zQ+kHKf+HtSqrMg+/PhT4fQYHbG1siPzJemCUQ0p2EOob5tjLBVCEG83+Mi+vj1hCpE8s/Z2EsFeE4/WVIA09dNQUUC8eyoN0jxtK5XARc0OVldBoC1TRaILzNah9cC5TEsDUdyxwNuLlg8rz99nhq1wMSW+fArvx+eYHYsKwzCZSyAc97cRXEebk3NHq6mT67YFkEPeR4a5rNhnmS0D7IQaoAbwdToip637BCTIbxwhltDd/P8Q4mjLa3/CW7mOjfyJBO7rP97nkdgsC4ji22iGmPapd9wWudSG4KF222GnZzjUGBo9I5EknehwiX1Otka+Y6ohfBXlL6jT0S
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4056.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(396003)(376002)(39860400002)(4326008)(6506007)(5660300002)(8676002)(83380400001)(53546011)(186003)(2906002)(6512007)(316002)(36756003)(54906003)(478600001)(2616005)(107886003)(64756008)(6916009)(26005)(66946007)(8936002)(86362001)(6486002)(3450700001)(66556008)(71200400001)(66446008)(66476007)(76116006)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?eU9BbEpNQkU1alR1V3BsNnZXdENLYWdVVVRlNGNyM1F2Rm1XVTdlQnRQYjZY?=
 =?utf-8?B?SG1Yck9uUHA0ZlJ5SWwzUFFRSXUxVHRVZCs5c3l0OEV1c20xTmxJU3JUaVZs?=
 =?utf-8?B?Z29PS25hWDhmbGsxSUxXNnZxZ1IvdVhKbVBrZnRxdUozRmxWR1Jwcm9xcU4y?=
 =?utf-8?B?YTlsS3pMdTB1WXE5MVoybkdJekdGMjdNdVFINzhVMWttdURXbFQwblBuNEJ4?=
 =?utf-8?B?dW5nSTVObWJjNDNRWjQ5SmN0YWo0Q0RyYkl0QXB6SXFMYUc1OHg1ZEV3czRp?=
 =?utf-8?B?b0ljd2lQZ0hxdENlOUFnZG9hdlJ3RFpyeDVBdXg4NVZjc3g5anhXdmtUN1ZX?=
 =?utf-8?B?RC95Ukk1aFFEQ2FOcjJjeG5zVk15OE5mQnJueEZXZ1VvbFVZTWhVTzE1RnI2?=
 =?utf-8?B?ZEV5K3poK0U4NUhjSk5LQldOQk5Ib2Q3NnFlUUkzNmEvamlQemk5Qlpnb3E4?=
 =?utf-8?B?RkFMZkVsNmx3N3FRNnNNSHJibXlaYjdaNW9zRzB3YmlBbzI1eFArTm9ZQWJr?=
 =?utf-8?B?aXhsSDVHTWM4YlJyT1hTWU1zME1RRjV5aC82WU9uVjNUWnMzWngvK2dQbnE3?=
 =?utf-8?B?dzVzSFNQdmZRVmthSkdjYUFwRmtxT0VJSWEvR0MvUnV6UzAvNEcvV1lyQUEz?=
 =?utf-8?B?T2xIdVAvZ2Z1VnJ4VUE2V3F3a2R2d2lWaTVlZlNYUXdYalRKMENHSjlFUzFo?=
 =?utf-8?B?WUNIREpEYXU4WTI3VGlISXRJUzVvTS9jMFRTN0lHWldnelExaDliR0JsNC8y?=
 =?utf-8?B?VUI2RjIwQ3JMVmhEcDB0bTU1dFdSZ1lTOGVjV2paN1VoVStlaENRa29EaTNQ?=
 =?utf-8?B?MzRvVXpmU1JYam43TkUxQTduREhVTE5ES05oeGZhY3lrUkNvR01hOWdRcldZ?=
 =?utf-8?B?MzJEbElROHZaOGtMVmJJcFFNSFFiSG54bVNsUkRBT2NFZ21HakFPdWtydWpU?=
 =?utf-8?B?QkZ1M3VMZytnVXR1TVdTYStPWHJNL1RxK3FUUm16RlB5clVYT3JydExsU3cx?=
 =?utf-8?B?VS9UdmJJVXRCSWthRlh4bmJUVFA3WFU4QzRZM0wvVFdOMHBZYjdmUTlQNGxG?=
 =?utf-8?B?ck9FMWxXekRndisvWWI2bUpqdjdHenRhR2dDN3hjUHlZTzdDanAzNG9CcXpM?=
 =?utf-8?B?dUptdW1YcmpIaHhPTS9IMGd4TEpjYkJwQ0xjbnFPWWlaRW5IOUJrbmRQdUtQ?=
 =?utf-8?B?N1EvamlkOVFCSzd6REJNdDRVeWpvVXJoS1UzZ3p2NXJ0Unp5Mk1GdDl2dzM2?=
 =?utf-8?B?bnF6UUswVko0OVRORVh6M3d6WFJyTWo5SWhWNHN1Q0xLVTkzeTlpd3Vob1V0?=
 =?utf-8?Q?0ED0DeR3KfzuUxhvU01dQs2V1AwO+eA81L?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AA0DC06F6959E24C91A512E9585BA373@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4056.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d147a5f-ba84-4994-adca-08d89b044ee3
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2020 23:03:27.6644
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZDwWJIomEt/ke4IW9ctPBvsbEm3ItMEPOWxsBvrXgLkarJGde++8GwbN1U/rAx8JhyWbtyw5R1DoZDDm7CzlaErAjHluZEQMizaYQ+cflaM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3461
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiBEZWMgOCwgMjAyMCwgYXQgMDI6MTIsIEJvcmlzbGF2IFBldGtvdiA8YnBAc3VzZS5kZT4g
d3JvdGU6DQo+IA0KPiBPbiBUaHUsIE5vdiAxOSwgMjAyMCBhdCAwMzozMjozNlBNIC0wODAwLCBD
aGFuZyBTLiBCYWUgd3JvdGU6DQo+ID4gVGhlIHhzdGF0ZSBpbmZyYXN0cnVjdHVyZSBpcyBub3Qg
ZmxleGlibGUgdG8gc3VwcG9ydCBkeW5hbWljIGFyZWFzIGluDQo+ID4gdGFzay0+ZnB1Lg0KPiAN
Cj4gdGFzay0+ZnB1Pw0KDQpJdCB3YXMgY29uc2lkZXJlZCB0byBiZSBjb25jaXNlIHRvIHJlcHJl
c2VudCwgYnV0IGl0IGxvb2tzIHRvIGJlIA0KdW5yZWFkYWJsZS4NCg0KPiBEbyB5b3UgbWVhbiB0
aGUgZnB1IG1lbWJlciBpbiBzdHJ1Y3QgdGhyZWFkX3N0cnVjdCA/DQoNClllcy4gV2lsbCBtYWtl
IHN1cmUgdG8gdXNlIHRoaXMgZm9yIGNsYXJpZmljYXRpb24gYXQgZmlzdC4NCg0KPiA+IENoYW5n
ZSB0aGUgZnBzdGF0ZV9pbml0KCkgcHJvdG90eXBlIHRvIGFjY2VzcyB0YXNrLT5mcHUgZGlyZWN0
bHkuIEl0DQo+ID4gdHJlYXRzIGEgbnVsbCBwb2ludGVyIGFzIGluZGljYXRpbmcgaW5pdF9mcHN0
YXRlLCBhcyB0aGlzIGluaXRpYWwgZGF0YQ0KPiA+IGRvZXMgbm90IGJlbG9uZyB0byBhbnkgdGFz
ay4NCj4gDQo+IFdoYXQgZm9yPyBDb21taXQgbWVzc2FnZXMgc2hvdWxkIHN0YXRlICp3aHkqIHlv
dSdyZSBkb2luZyBhIGNoYW5nZSAtIG5vdA0KPiAqd2hhdCogeW91J3JlIGRvaW5nLiAqV2hhdCog
SSBjYW4gbW9yZSBvciBsZXNzIHNlZSwgKndoeSogaXMgaGFyZGVyLg0KDQpBbiBlYXJsaWVyIHZl
cnNpb24gaGFkIHdvcmR5IGV4cGxhbmF0aW9ucywgYnV0IGl0IGxvb2tzIHRvbyBtdWNoIHRyaW1t
ZWQNCmRvd24uDQoNCihJIHN1c3BlY3QgdGhpcyBwb2ludCBhcHBsaWNhYmxlIHRvIFBBVENIMi00
IGFzIHdlbGwuKQ0KDQo+IC9tZSBnb2VzIGFuZCBsb29rcyBmb3J3YXJkIGludG8gdGhlIHBhdGNo
c2V0Li4uDQo+IA0KPiBBcmUgeW91IGdvaW5nIHRvIG5lZWQgaXQgZm9yIHN0dWZmIGxpa2UNCj4g
DQo+IAlmcHUgPyBmcHUtPnN0YXRlX21hc2sgOiBnZXRfaW5pdF9mcHN0YXRlX21hc2soKQ0KPiAN
Cj4gPw0KDQpZZXMsIEkgdGhpbmsgdGhhdOKAmXMgb25lIG9mIHRoZSBjYXNlcy4NCg0KPiBJZiBz
bywgd2h5IGRvbid0IHlvdSB3cml0ZSAqd2h5KiB5b3UncmUgZG9pbmcgdGhvc2UgY2hhbmdlcyBo
ZXJlPw0KDQpXaWxsIGRvIHRoYXQuDQoNClRoYW5rcywNCkNoYW5nDQo=
