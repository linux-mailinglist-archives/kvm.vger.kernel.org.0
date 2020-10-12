Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41D428AE77
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 08:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgJLGy2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 02:54:28 -0400
Received: from mga18.intel.com ([134.134.136.126]:18703 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726677AbgJLGxh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Oct 2020 02:53:37 -0400
IronPort-SDR: +AD//XxoqTnAAS5Sxh9x5nYsa1eiBN9JMGFRlDzIf+qOQp8n0GKTGq6isqF/gxR4Gbo7v2xO5D
 +k/Zm/n+ZwGA==
X-IronPort-AV: E=McAfee;i="6000,8403,9771"; a="153528553"
X-IronPort-AV: E=Sophos;i="5.77,366,1596524400"; 
   d="scan'208";a="153528553"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2020 23:53:33 -0700
IronPort-SDR: oQ//e+gsqPMe11JPyZ3t3H6ZB64kP8dQiB4ygwg2dVavxxMkBWEws5Kgh6yJmdW1DVkPQcJQbE
 Xow1sg7MK5KA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,366,1596524400"; 
   d="scan'208";a="462995505"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga004.jf.intel.com with ESMTP; 11 Oct 2020 23:53:20 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 11 Oct 2020 23:53:19 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 11 Oct 2020 23:53:18 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sun, 11 Oct 2020 23:53:18 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Sun, 11 Oct 2020 23:53:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WVV3o0ocEtzbGH1FEZUD72uMNVV3nNUWrRSJ/PpLvDV7abpiGYsugpk7tJgNI1WXoYWGyFz65OvcB5T5vF8P/+gBxBdtGMVUjQDo6LAYu/HZmXsecq1lvVofvHU0MQSTF9E+K8ovG4W4XizNrB418g9ucZ9Se5QODCOh6kcUSoGNOqO1oHZDOtikSl9WVBu33X8nxtldWWqXKqY4gGUAvN4pLXXBrwMyKHLCPqYm/oVj4Uei4cGuukUbZLdoh+RxRahqIR7GyXMimnf69Msd5zSVmMZpLUeT58aInIHAfOvJPRQdfaZqHGHnIqsKk837dFqu/cASBMb8lxE6VSdu3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n5W4j1W16wHEGSy3GcP5++vRfKoOsXsAzFkRe3r24lo=;
 b=CtbQQqSvtTtSQ9ZP203zLRfPMbDb0DfRrryw4XZC+E6xNwfx6PtH5dMe2SC4i3OKA354pmqg66qnvNc3/QQS/UqyzucpLNybKvR8mdPkNThHpPPrVJRaO7Opvz3DjtJoi/NO0DmUJU9h7zY82QyM/vEOJiU2aE85ND6dYkZbKGvigpbzJLHko1x9yeL9fr0Qp10ybW6Q20JWMf7QzYHmmh9gxT30wIBx2Y5kzZUNiFpYKTxjHZoUD++MYyBJ1QfAus+FyIAYI9qzClO8R2WjN25DvZc9LG7zsORnktyIxEG5obQXqXckBHpBGwOU0vjy4R6u0eF/+SP+Crobv/IJ+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n5W4j1W16wHEGSy3GcP5++vRfKoOsXsAzFkRe3r24lo=;
 b=OPpzz8kZTpp2Qw2hmHBqgMWDOhA4MzujdbvJXbbvLZeqLrnHYjUey2l+JNyLjKj2QrG83N6Gw5xaWFD8jShjCzNFbfQ/HvJhPHtP/Ajv3+OeNymlBiN+rvithXIbbmOqCiPRqMHMua0AxowSuwp377GTUlIEPkfPLJ8LjU6xIls=
Received: from MWHPR11MB1968.namprd11.prod.outlook.com (2603:10b6:300:113::16)
 by MWHPR1101MB2208.namprd11.prod.outlook.com (2603:10b6:301:4d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.25; Mon, 12 Oct
 2020 06:53:17 +0000
Received: from MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::9976:e74f:b8e:dc15]) by MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::9976:e74f:b8e:dc15%7]) with mapi id 15.20.3455.030; Mon, 12 Oct 2020
 06:53:17 +0000
From:   "Qi, Yadong" <yadong.qi@intel.com>
To:     Nadav Amit <nadav.amit@gmail.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: RE: [kvm-unit-tests PATCH] x86: vmx: Add test for SIPI signal
 processing
Thread-Topic: [kvm-unit-tests PATCH] x86: vmx: Add test for SIPI signal
 processing
Thread-Index: AQHWkw6i3URq225llEmaCd1JoJ27OqmHFl8AgAmNrACAApzMIIAAXUAAgAABNZA=
Date:   Mon, 12 Oct 2020 06:53:16 +0000
Message-ID: <MWHPR11MB1968819D6D051286C5A3D07DE3070@MWHPR11MB1968.namprd11.prod.outlook.com>
References: <20200925073624.245578-1-yadong.qi@intel.com>
 <MWHPR11MB1968C521D356F1D1FA17EE6EE30F0@MWHPR11MB1968.namprd11.prod.outlook.com>
 <3705293E-84DE-41ED-9DD1-D837855C079B@gmail.com>
 <MWHPR11MB196876354169E0DB6046BA5BE3070@MWHPR11MB1968.namprd11.prod.outlook.com>
 <7D2E7AB8-A063-4B91-9FB9-558B9D2BAA4F@gmail.com>
In-Reply-To: <7D2E7AB8-A063-4B91-9FB9-558B9D2BAA4F@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.221]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6d83347d-25ba-4a9e-db70-08d86e7b7f78
x-ms-traffictypediagnostic: MWHPR1101MB2208:
x-microsoft-antispam-prvs: <MWHPR1101MB220866DF0B37F22EA1DCFE31E3070@MWHPR1101MB2208.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yfd1r0tnZbvq1tAsd1C6I1BUSswHHSktYVts8yOIG9YIZhHJeNPKg5AuTxHdaA4czrCTCa22VncQfgwWhpVvPDcvWkS5RJgO2AgYwHIuca/kaGqqrpeXS36MQjJgtFJJFUJMEysN1b1EPIVur3QFMk8O6cE6eN00wq9K3RVBiGPyLtvCfN0W0Mq1EmaN4MlnEghZ9LftIVcbBFMMs8BHQeomSCR4bDjTSCdQKX9dKsgWKE6FR3EqMkwKXJkrj6vMYbqP1H7gZIL+rWXHELuL27XfmbicfIMHEIGw1UmFQ1rw9i9GAVeUCFYTcsMa/BRpzU6w5R5vb/1zZkitywyd5TsJwyJnmd7QDRh76Sg1jHizhEztYAveIf4lNcvnbHz4TP5ZOzJpL/gplaOXciHJUA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1968.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(136003)(396003)(346002)(478600001)(83080400001)(7696005)(6916009)(54906003)(316002)(966005)(83380400001)(33656002)(66476007)(9686003)(66556008)(64756008)(66446008)(86362001)(4326008)(71200400001)(6506007)(53546011)(5660300002)(186003)(8936002)(52536014)(55016002)(2906002)(76116006)(66946007)(26005)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: tTVJRWf+B4lob8FbaAl2nG/yyZhABLlsIMRWMeWj7KVGrIxD7qoZhtSYwYzXHrgc7UWWMSkVQPf9eA+H5aQjFpQCXD6951wTnDG01z9bQjFeXkgpst9zmQAKGdkjJqzwwurgX83jJAWAq1f+mQehpNFl1Arwp8J25+p+YNhlbP0+7BlFGQbZMYzr5Y6zYBG/MUNiPcutPm9TtyIXNo9ucMpsxAfyibfHLWntp1dhpDDdnAce+Uk5l51ruBXL2YuHXXw6SN6FhhLg6cWyiUESGzf4rUuah+/qUQ1qEmD3LSQpRhkdvzvo3/DaOjenQuDBvCkV9sLru2x2kHFZdHFxQv8IL0Q7urHbUcrt3vcqy24P4jTr44Z2/ePY7bgiy1ZY3bUGrJOCDjt8gzlPQsPnn5uR4SGg/qMK0QenA0dLOHu1As73waAvL0VNnnoeAVp0i9EVaQb098sbIkm6cp2jNV/8vYFNPOdeSfstRC79h7K2o7t/itMCoedjsEooIk2QBFcpaA/TptcTY5LS7x+1sdgyyO4+dcXeZKSqHj3QdiguOUQrlvEXIKlkctDd3qpBO/IfFcbVTR3/uzCgNlViwEFdAZqbzds2iXW6MfomrRHsOLbMivSQ31O5A+DMNEaloLCY8QSSxUWQx0Z73wKsZg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1968.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d83347d-25ba-4a9e-db70-08d86e7b7f78
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2020 06:53:17.0005
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g8+w80sJGQ/loj8U/TUPcjq6g/UrXCseZkeqkKgDpsYmM37odX34op7Uz4OlUQtkasxYytrJ3TXyBpFXdjVgUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2208
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBOYWRhdiBBbWl0IDxuYWRhdi5h
bWl0QGdtYWlsLmNvbT4NCj4gU2VudDogTW9uZGF5LCBPY3RvYmVyIDEyLCAyMDIwIDI6MzcgUE0N
Cj4gVG86IFFpLCBZYWRvbmcgPHlhZG9uZy5xaUBpbnRlbC5jb20+DQo+IENjOiBrdm1Admdlci5r
ZXJuZWwub3JnOyBwYm9uemluaUByZWRoYXQuY29tDQo+IFN1YmplY3Q6IFJlOiBba3ZtLXVuaXQt
dGVzdHMgUEFUQ0hdIHg4Njogdm14OiBBZGQgdGVzdCBmb3IgU0lQSSBzaWduYWwgcHJvY2Vzc2lu
Zw0KPiANCj4gPiBPbiBPY3QgMTEsIDIwMjAsIGF0IDY6MTkgUE0sIFFpLCBZYWRvbmcgPHlhZG9u
Zy5xaUBpbnRlbC5jb20+IHdyb3RlOg0KPiA+DQo+ID4+IE9uIG15IGJhcmUtbWV0YWwgbWFjaGlu
ZSwgSSBnZXQgYSAjR1Agb24gdGhlIFdSTVNSIHRoYXQgd3JpdGVzIHRoZQ0KPiA+PiBFT0kgaW5z
aWRlDQo+ID4+IGlwaSgpIDoNCj4gPj4NCj4gPj4gVGVzdCBzdWl0ZTogdm14X3NpcGlfc2lnbmFs
X3Rlc3QNCj4gPj4gVW5oYW5kbGVkIGV4Y2VwdGlvbiAxMyAjR1AgYXQgaXAgMDAwMDAwMDAwMDQx
N2ViYQ0KPiA+PiBlcnJvcl9jb2RlPTAwMDAgICAgICByZmxhZ3M9MDAwMTAwMDIgICAgICBjcz0w
MDAwMDAwOA0KPiA+PiByYXg9MDAwMDAwMDAwMDAwMDAwMCByY3g9MDAwMDAwMDAwMDAwMDgwYiBy
ZHg9MDAwMDAwMDAwMDAwMDAwMA0KPiA+PiByYng9MDAwMDAwMDAwMDAwMDAwMA0KPiA+PiByYnA9
MDAwMDAwMDAwMDUzYTIzOCByc2k9MDAwMDAwMDAwMDAwMDAwMCByZGk9MDAwMDAwMDAwMDAwMDAw
Yg0KPiA+PiByOD0wMDAwMDAwMDAwMDAwMDBhICByOT0wMDAwMDAwMDAwMDAwM2Y4IHIxMD0wMDAw
MDAwMDAwMDAwMDBkDQo+ID4+IHIxMT0wMDAwMDAwMDAwMDAwMDAwDQo+ID4+IHIxMj0wMDAwMDAw
MDAwNDBjN2E1IHIxMz0wMDAwMDAwMDAwMDAwMDAwIHIxND0wMDAwMDAwMDAwMDAwMDAwDQo+ID4+
IHIxNT0wMDAwMDAwMDAwMDAwMDAwDQo+ID4+IGNyMD0wMDAwMDAwMDgwMDAwMDExIGNyMj0wMDAw
MDAwMDAwMDAwMDAwIGNyMz0wMDAwMDAwMDAwNDFmMDAwDQo+ID4+IGNyND0wMDAwMDAwMDAwMDAw
MDIwDQo+ID4+IGNyOD0wMDAwMDAwMDAwMDAwMDAwDQo+ID4+IAlTVEFDSzogQDQxN2ViYSA0MTdm
MzYgNDE3NDgxIDQxNzM4Mw0KPiA+Pg0KPiA+PiBJIGRpZCBub3QgZGlnIG11Y2ggZGVlcGVyLiBD
b3VsZCBpdCBiZSB0aGF0IHRoZXJlIGlzIHNvbWUgY29uZnVzaW9uDQo+ID4+IGJldHdlZW4geGFw
aWMveDJhcGljID8NCj4gPg0KPiA+IFRoYW5rcywgTmFkYXYuDQo+ID4gSSBjYW5ub3QgcmVwcm9k
dWNlIHRoZSAjR1AgaXNzdWUgb24gbXkgYmFyZSBtZXRhbCBtYWNoaW5lLg0KPiA+IEFuZCBJIGFt
IGEgbGl0dGxlIGJpdCBjb25mdXNlZCwgdGhlcmUgaXMgbm8gRU9JIE1TUiB3cml0ZSBpbiB0aGlz
IHRlc3QNCj4gPiBzdWl0ZSwgaG93IHRoZSAjR1AgY29tZXMgb3V0Li4uDQo+ID4gQ291bGQgeW91
IHByb3ZpZGUgbW9yZSBpbmZvIGZvciBtZSB0byByZXByb2R1Y2UgdGhlIGlzc3VlPw0KPiANCj4g
V2UgbWlnaHQgaGF2ZSBkaWZmZXJlbnQgZGVmaW5pdGlvbnMgZm9yIOKAnGJhcmUtbWV0YWzigJ0g
OikNCj4gDQo+IEkgbWVhbnQgdGhhdCBJIHJhbiBpdCBkaXJlY3RseSBvbiB0aGUgbWFjaGluZSB3
aXRob3V0IEtWTS4gU2VlIFsxXS4gWW91IGRvIG5lZWQNCj4gc29tZSBhY2Nlc3Mgc2VyaWFsIGNv
bnNvbGUgdGhyb3VnaCB0aGUgaURSQUMvaWxvL2V0Yy4uDQoNCk9oLCBJIHNlZS4gVGhhbmsgeW91
IGZvciBjbGFyaWZ5aW5nIGl0Lg0KDQo+IA0KPiBBbnlob3csIEkgZmlndXJlZCBvdXQgdGhhdCB5
b3UgZm9yZ290IHRvIHNldHVwIENSMyBvbiB0aGUgQVAuDQo+IA0KPiBEb2luZyBzb21ldGhpbmcg
bGlrZToNCj4gDQo+ICsgICAgICAgb25fY3B1KDEsIHVwZGF0ZV9jcjMsICh2b2lkICopcmVhZF9j
cjMoKSk7DQo+IA0KPiAgICAgICAgIC8qIHN0YXJ0IEFQICovDQo+ICAgICAgICAgb25fY3B1X2Fz
eW5jKDEsIHNpcGlfdGVzdF9hcF90aHJlYWQsIE5VTEwpOw0KPiANCj4gDQo+IFNvbHZlcyB0aGUg
cHJvYmxlbS4gWW91IG1heSB3YW50IHRvIGRvIGl0IGluIGEgc2xpZ2h0bHkgY2xlYW5lciB3YXks
IG9yIGV4dHJhY3QNCj4gdXBkYXRlX2NyMygpIHRvIG9uZSBvZiB0aGUgbGlicyB0byBhdm9pZCBm
dXJ0aGVyIGNvZGUgZHVwbGljYXRpb24uDQoNClRoYW5rcyB2ZXJ5IG11Y2ggZm9yIGZpZ3VyaW5n
IG91dCB0aGUgaXNzdWUuDQpXaWxsIHVwZGF0ZSB0aGUgcGF0Y2ggaW4gbmV4dCB2ZXJzaW9uLg0K
DQpCZXN0IFJlZ2FyZA0KWWFkb25nDQoNCj4gDQo+IFJlZ2FyZHMsDQo+IE5hZGF2DQo+IA0KPiAN
Cj4gWzFdIGh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcvcGF0Y2gvMTEwNTM5MDMvDQoNCg==
