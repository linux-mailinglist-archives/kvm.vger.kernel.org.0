Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD8C52A2466
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 06:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbgKBFmL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 00:42:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:65179 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgKBFmL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 00:42:11 -0500
IronPort-SDR: gqvTVjX8cr+AZJpwy23hbycifSvMVLYEby4HNYeMckKYcptGKzHfc/aq84jyCGKtCT/B+A4t4F
 1Mp1oC77s2FA==
X-IronPort-AV: E=McAfee;i="6000,8403,9792"; a="155824286"
X-IronPort-AV: E=Sophos;i="5.77,444,1596524400"; 
   d="scan'208";a="155824286"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2020 21:42:10 -0800
IronPort-SDR: ARWE2mrB1vuZkyvyY07U+w0VTf2LCM6CrMqYVTb9IUKDjyk3oZQqWlEDuZFqL6VauDJTiUW68B
 I67pShSw6SIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,444,1596524400"; 
   d="scan'208";a="363129075"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga007.jf.intel.com with ESMTP; 01 Nov 2020 21:42:10 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 1 Nov 2020 21:42:10 -0800
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 1 Nov 2020 21:42:09 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sun, 1 Nov 2020 21:42:09 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Sun, 1 Nov 2020 21:42:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z+HLjsa8zJ7YoDSRYfFC0n0ukFAa69yT3GoRRfeVz1BrHG3BQDA6DKzw605iXo74WjdlUtLVDkdG0znKNyOlpU4E4KCLNoBUv5wmDH58vAEUiFnQroEPKFIkovwfjSSxsXafE2cY9z9nt3VXDu0qXFvB5LbZ8t9SyuX413tEryy+pFK9Ry+kosRV1fUc4oDdqpDXLCGPBy2Xq1fMxnDtEyyaRU8ok2cHZNyQAktEjjWjH7Zvv8EsG/qn+U8cJbnDOIEfYqn2/gjS5mjDXOOkIYbQ/RObOvasCKKCbauwl3RmdF/1Wk3Iu29pKWDwMnGyfWcefDDnify27Yd49iu3GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0j+cVeMdj1t8i7KrJIFpcCO2uFI8dOkHstipiGrpjk=;
 b=TXrnVm2L3hTdg16SLtqQdHKFT21/kXU2g4uWasNhQ5xHa6EgAdGdksrTC/A6yHzy8JcGkeYRris2RwJreacMHBFXc6Ti9cKIYaOy693/q0NRrmF+q9R4efQe6mcsEGDxsYz4h7ZCQqfP0yRxFs7JiMPUjKyYIF8LNckF2ZOfhi4UplTs++edJFfH53eBzOx1fcSRwCvD3Uyti3A3eWk7jOKocApl/b10xiM/bgRMGDdfbo6yCsjgGuREjLoGybIb207YwJEy1xw9HVw83uwkjkEg1D7E4yIiEqhWso+Ms+g59NOiwgZI4Fuh5HHNDHWpM2NgvlcoR8qmgUrNoJqz+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0j+cVeMdj1t8i7KrJIFpcCO2uFI8dOkHstipiGrpjk=;
 b=ZQzjc9JV81PwTD3ZNOrU6DyuDOtdwuYxQzcOQ/HFV9Jvx6SC3Y4osYbt4H0QywhzEW07fUrwji/3tz7ND5ZrGRhT810o1zQc2ZIE8ymdnjjIkO0asL4Y6DXYZU6NpQNUKGCpRoUdYF/5P28t7ndVo1BI4h8oKsmm8lOCfKkYW6s=
Received: from MWHPR11MB1968.namprd11.prod.outlook.com (2603:10b6:300:113::16)
 by MWHPR11MB1455.namprd11.prod.outlook.com (2603:10b6:301:9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Mon, 2 Nov
 2020 05:42:07 +0000
Received: from MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::cc39:78f5:4e8e:593e]) by MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::cc39:78f5:4e8e:593e%10]) with mapi id 15.20.3477.036; Mon, 2 Nov 2020
 05:42:07 +0000
From:   "Qi, Yadong" <yadong.qi@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
CC:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "liran.alon@oracle.com" <liran.alon@oracle.com>,
        "nikita.leshchenko@oracle.com" <nikita.leshchenko@oracle.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Chen, Luhai" <luhai.chen@intel.com>,
        "Zhu, Bing" <bing.zhu@intel.com>,
        "Wang, Kai Z" <kai.z.wang@intel.com>
Subject: RE: [PATCH] KVM: x86: emulate wait-for-SIPI and SIPI-VMExit
Thread-Topic: [PATCH] KVM: x86: emulate wait-for-SIPI and SIPI-VMExit
Thread-Index: AQHWkKDXpbo0akWSWkKXeJbWVxPoT6l0XvaAgEAysMA=
Date:   Mon, 2 Nov 2020 05:42:07 +0000
Message-ID: <MWHPR11MB1968E398CFFACE3B2D95A760E3100@MWHPR11MB1968.namprd11.prod.outlook.com>
References: <20200922052343.84388-1-yadong.qi@intel.com>
 <c0157014-d1bb-ef81-b92f-ebecb72396c9@redhat.com>
In-Reply-To: <c0157014-d1bb-ef81-b92f-ebecb72396c9@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.102.204.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 32f7173e-d256-4ec7-d733-08d87ef2094b
x-ms-traffictypediagnostic: MWHPR11MB1455:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1455B28AB61B4F27FB13C02CE3100@MWHPR11MB1455.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RRfKSBW/YQYEreSWwpe7NYZ33y2jbeCGiImtLTyBBB9fUlEwC/iMQ+UTCSZ1gUdvMRoD7zgoYp+LJTAph2/aX9DIVXgH6aqIwc3mOKKyu2X6o9UCp0cmvEAsq2PN/AytjQrVG3LbCqNZZCh99V0uxYJ6NPloAOiAHK8faGjZqhHTwnaQ3O8A2YQdZWN/G5GX0gO0hTB73qenyUdf53Al9qr6ETDYt1fezmkUdnKlMl502uJuMPnLue1w2d8RSObegMTmexQXGt+efevokCS4EEWqknepWqwz4WX0G54FV2aTTswhVnEJIEBt0w9KGl/9oamlkSOKk6aKvTchnPOJAJA4AO1Uv2wvgxhY3IfmdppEwCoiYY7D1t+FyrCHkOvQ/nG0fpIq0minbf4fw165zQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1968.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(376002)(346002)(136003)(83380400001)(66946007)(8936002)(64756008)(66476007)(66446008)(66556008)(9686003)(86362001)(2906002)(76116006)(8676002)(5660300002)(52536014)(33656002)(107886003)(7416002)(53546011)(4326008)(478600001)(7696005)(6506007)(71200400001)(55016002)(186003)(966005)(316002)(26005)(54906003)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 9sZDN+fgi/9/chmK3rocqbwfPf9pUNJSd1RYz92OvG+qSxjeE+cwPwTPPZNOSibtXvXFA6mEyUxk4p6yMqjobtGBxk+20vpK6AD/eSIBVEydM9yCFvbKpZ0jU9V921wknzeOosTfqZ4lIDXbJdnsxN6gI4lTNQ02y3gTZ2JZBCBzFSPEk02/68bACMSYAO901HgUxogkNzreyIl7seGfIgp4d67DPQtkQN2qg903EYnzL5pGO1f7F48ONi7vs7oIXLESmcfQnJEyaLiJuQ+/43thCuageXfkZG1zPGCHkyl6r1p5rXlo2L4Lqdf/iWp1nO+rasoqShCh1bInc3uu6tyeNmCXJKam3CmIiwaQ4FiQdIEwsC23GDtnefyu9wtN/BYKNkI5jVAZhzPLxYZ0Ttu7KILnCZ4KcAD+sJeeZ0bewcj0qeewwGcls1ztwhYsRd57PYLMl+X926V5acB+8im+dsoYVgZbzwuYRELzUXzkRX8H89zxB++TbZ4EUmEjCY4A50wvsJBn6oErb5/1P9dE4LQbNqHa4oAMUdJq8BSiT+/8JI8OSqWYR31s3zLmS5F5ltqJogkqrLQ6MkYGQgI2nlXiHbfCEzGoUPmCWD4oV/sIv5u/ttv3vdFlYFAGjuVaLLkRIe4HNt8GXGIDvg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1968.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32f7173e-d256-4ec7-d733-08d87ef2094b
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2020 05:42:07.4186
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oqe/husubmzp3AiyyquxBldJsOTn/hg52R0VSTDGAexjV/x3+KaUQRjhCQEuIj58JGU2zYA8ApK7S/DciTdSpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1455
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFBhb2xvIEJvbnppbmkgPHBi
b256aW5pQHJlZGhhdC5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIFNlcHRlbWJlciAyMiwgMjAyMCA1
OjEwIFBNDQo+IFRvOiBRaSwgWWFkb25nIDx5YWRvbmcucWlAaW50ZWwuY29tPjsga3ZtQHZnZXIu
a2VybmVsLm9yZzsgbGludXgtDQo+IGtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IHg4NkBrZXJuZWwu
b3JnDQo+IENjOiBDaHJpc3RvcGhlcnNvbiwgU2VhbiBKIDxzZWFuLmouY2hyaXN0b3BoZXJzb25A
aW50ZWwuY29tPjsNCj4gdmt1em5ldHNAcmVkaGF0LmNvbTsgd2FucGVuZ2xpQHRlbmNlbnQuY29t
OyBqbWF0dHNvbkBnb29nbGUuY29tOw0KPiBqb3JvQDhieXRlcy5vcmc7IHRnbHhAbGludXRyb25p
eC5kZTsgbWluZ29AcmVkaGF0LmNvbTsgYnBAYWxpZW44LmRlOw0KPiBocGFAenl0b3IuY29tOyBs
aXJhbi5hbG9uQG9yYWNsZS5jb207IG5pa2l0YS5sZXNoY2hlbmtvQG9yYWNsZS5jb207IEdhbywN
Cj4gQ2hhbyA8Y2hhby5nYW9AaW50ZWwuY29tPjsgVGlhbiwgS2V2aW4gPGtldmluLnRpYW5AaW50
ZWwuY29tPjsgQ2hlbiwgTHVoYWkNCj4gPGx1aGFpLmNoZW5AaW50ZWwuY29tPjsgWmh1LCBCaW5n
IDxiaW5nLnpodUBpbnRlbC5jb20+OyBXYW5nLCBLYWkgWg0KPiA8a2FpLnoud2FuZ0BpbnRlbC5j
b20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIEtWTTogeDg2OiBlbXVsYXRlIHdhaXQtZm9yLVNJ
UEkgYW5kIFNJUEktVk1FeGl0DQo+IA0KPiBPbiAyMi8wOS8yMCAwNzoyMywgeWFkb25nLnFpQGlu
dGVsLmNvbSB3cm90ZToNCj4gPiBGcm9tOiBZYWRvbmcgUWkgPHlhZG9uZy5xaUBpbnRlbC5jb20+
DQo+ID4NCj4gPiBCYWNrZ3JvdW5kOiBXZSBoYXZlIGEgbGlnaHR3ZWlnaHQgSFYsIGl0IG5lZWRz
IElOSVQtVk1FeGl0IGFuZA0KPiA+IFNJUEktVk1FeGl0IHRvIHdha2UtdXAgQVBzIGZvciBndWVz
dHMgc2luY2UgaXQgZG8gbm90IG1vbml0b3IgdGhlDQo+ID4gTG9jYWwgQVBJQy4gQnV0IGN1cnJl
bnRseSB2aXJ0dWFsIHdhaXQtZm9yLVNJUEkoV0ZTKSBzdGF0ZSBpcyBub3QNCj4gPiBzdXBwb3J0
ZWQgaW4gblZNWCwgc28gd2hlbiBydW5uaW5nIG9uIHRvcCBvZiBLVk0sIHRoZSBMMSBIViBjYW5u
b3QNCj4gPiByZWNlaXZlIHRoZSBJTklULVZNRXhpdCBhbmQgU0lQSS1WTUV4aXQgd2hpY2ggY2F1
c2UgdGhlIEwyIGd1ZXN0DQo+ID4gY2Fubm90IHdha2UgdXAgdGhlIEFQcy4NCj4gPg0KPiA+IEFj
Y29yZGluZyB0byBJbnRlbCBTRE0gQ2hhcHRlciAyNS4yIE90aGVyIENhdXNlcyBvZiBWTSBFeGl0
cywgU0lQSXMNCj4gPiBjYXVzZSBWTSBleGl0cyB3aGVuIGEgbG9naWNhbCBwcm9jZXNzb3IgaXMg
aW4gd2FpdC1mb3ItU0lQSSBzdGF0ZS4NCj4gPg0KPiA+IEluIHRoaXMgcGF0Y2g6DQo+ID4gICAg
IDEuIGludHJvZHVjZSBTSVBJIGV4aXQgcmVhc29uLA0KPiA+ICAgICAyLiBpbnRyb2R1Y2Ugd2Fp
dC1mb3ItU0lQSSBzdGF0ZSBmb3IgblZNWCwNCj4gPiAgICAgMy4gYWR2ZXJ0aXNlIHdhaXQtZm9y
LVNJUEkgc3VwcG9ydCB0byBndWVzdC4NCj4gPg0KPiA+IFdoZW4gTDEgaHlwZXJ2aXNvciBpcyBu
b3QgbW9uaXRvcmluZyBMb2NhbCBBUElDLCBMMCBuZWVkIHRvIGVtdWxhdGUNCj4gPiBJTklULVZN
RXhpdCBhbmQgU0lQSS1WTUV4aXQgdG8gTDEgdG8gZW11bGF0ZSBJTklULVNJUEktU0lQSSBmb3Ig
TDIuIEwyDQo+ID4gTEFQSUMgd3JpdGUgd291bGQgYmUgdHJhcGVkIGJ5IEwwIEh5cGVydmlzb3Io
S1ZNKSwgTDAgc2hvdWxkIGVtdWxhdGUNCj4gPiB0aGUgSU5JVC9TSVBJIHZtZXhpdCB0byBMMSBo
eXBlcnZpc29yIHRvIHNldCBwcm9wZXIgc3RhdGUgZm9yIEwyJ3MNCj4gPiB2Y3B1IHN0YXRlLg0K
PiA+DQo+ID4gSGFuZGxlIHByb2NkdXJlOg0KPiA+IFNvdXJjZSB2Q1BVOg0KPiA+ICAgICBMMiB3
cml0ZSBMQVBJQy5JQ1IoSU5JVCkuDQo+ID4gICAgIEwwIHRyYXAgTEFQSUMuSUNSIHdyaXRlKElO
SVQpOiBpbmplY3QgYSBsYXRjaGVkIElOSVQgZXZlbnQgdG8gdGFyZ2V0DQo+ID4gICAgICAgIHZD
UFUuDQo+ID4gVGFyZ2V0IHZDUFU6DQo+ID4gICAgIEwwIGVtdWxhdGUgYW4gSU5JVCBWTUV4aXQg
dG8gTDEgaWYgaXMgZ3Vlc3QgbW9kZS4NCj4gPiAgICAgTDEgc2V0IGd1ZXN0IFZNQ1MsIGd1ZXN0
X2FjdGl2aXR5X3N0YXRlPVdBSVRfU0lQSSwgdm1yZXN1bWUuDQo+ID4gICAgIEwwIHNldCB2Y3B1
Lm1wX3N0YXRlIHRvIElOSVRfUkVDRUlWRUQgaWYgKHZtY3MxMi5ndWVzdF9hY3Rpdml0eV9zdGF0
ZQ0KPiA+ICAgICAgICA9PSBXQUlUX1NJUEkpLg0KPiA+DQo+ID4gU291cmNlIHZDUFU6DQo+ID4g
ICAgIEwyIHdyaXRlIExBUElDLklDUihTSVBJKS4NCj4gPiAgICAgTDAgdHJhcCBMQVBJQy5JQ1Ig
d3JpdGUoSU5JVCk6IGluamVjdCBhIGxhdGNoZWQgU0lQSSBldmVudCB0byB0cmFnZXQNCj4gPiAg
ICAgICAgdkNQVS4NCj4gPiBUYXJnZXQgdkNQVToNCj4gPiAgICAgTDAgZW11bGF0ZSBhbiBTSVBJ
IFZNRXhpdCB0byBMMSBpZiAodmNwdS5tcF9zdGF0ZSA9PSBJTklUX1JFQ0VJVkVEKS4NCj4gPiAg
ICAgTDEgc2V0IENTOklQLCBndWVzdF9hY3Rpdml0eV9zdGF0ZT1BQ1RJVkUsIHZtcmVzdW1lLg0K
PiA+ICAgICBMMCByZXN1bWUgdG8gTDIuDQo+ID4gICAgIEwyIHN0YXJ0LXVwLg0KPiANCj4gQWdh
aW4sIHRoaXMgbG9va3MgZ29vZCBidXQgaXQgbmVlZHMgdGVzdGNhc2VzLg0KPiANCg0KSGksIFBh
b2xvDQoNCkkgc2F3IHlvdSBxdWV1ZWQgdGhlIHRlc3RjYXNlIHBhdGNoOiBodHRwczovL3BhdGNo
d29yay5rZXJuZWwub3JnL3Byb2plY3Qva3ZtL3BhdGNoLzIwMjAxMDEzMDUyODQ1LjI0OTExMy0x
LXlhZG9uZy5xaUBpbnRlbC5jb20vDQpXaWxsIHlvdSBhbHNvIHF1ZXVlIHRoaXMgcGF0Y2g/IE9y
IHRoZXJlIGFyZSBzb21lIGFkZGl0aW9uYWwgY29tbWVudHMgb2YgdGhpcyBwYXRjaD8gDQoNCkJl
c3QgUmVnYXJkDQpZYWRvbmcNCg0KDQo=
