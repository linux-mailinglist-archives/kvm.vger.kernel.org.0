Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDBB020C588
	for <lists+kvm@lfdr.de>; Sun, 28 Jun 2020 05:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgF1DMX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Jun 2020 23:12:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:17934 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725880AbgF1DMW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Jun 2020 23:12:22 -0400
IronPort-SDR: Oj3bglE3meOtr8Gb7HhgFOch5Jw4VNDrr9/sCgaT5M813It9TWNVxHpe6E8x1isILz2YcYDE5H
 M++EwlYzrYRg==
X-IronPort-AV: E=McAfee;i="6000,8403,9665"; a="147315018"
X-IronPort-AV: E=Sophos;i="5.75,290,1589266800"; 
   d="scan'208";a="147315018"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2020 20:12:22 -0700
IronPort-SDR: Mlg2aCrdWAHmRQxvb5x68ZzYzUmn4SRsMDkAL9mviYuHy5oO4nKqJbKf3Jgvc9uJ2ESJzrO2aD
 +ebDYk5g4F2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,290,1589266800"; 
   d="scan'208";a="280526531"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga006.jf.intel.com with ESMTP; 27 Jun 2020 20:12:22 -0700
Received: from fmsmsx121.amr.corp.intel.com (10.18.125.36) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 27 Jun 2020 20:12:16 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx121.amr.corp.intel.com (10.18.125.36) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 27 Jun 2020 20:12:16 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Sat, 27 Jun 2020 20:12:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ejEk8gh4kdyS/t8L/+og8pHiUiglwQZpmBKdo2I9dTJP8Ao6hrlNRXCbsGrCLkJIVOGZm/Be4PgG1h/W0lr01xvus/kC8tOTNPxlrtXnrJAvZ6oN9GpwTICXAeH2bJTZabUz1tljtl6gycZ6HR82nq5dyf+QSUmnR1ArdKsvqrwYhRQr3Q/8+qxG/go/3G409M5N6EcCkpXn4mA8cvlyR9vcVXzd+2bsVcLE68qYYBdmAIwH477PrLxBhsLv1AvUNhSsmjg3bSmwkO9QXgzYser8iajePgwPCHUgbFQbcMGXLaoesttpYJCOfRhwiztGjPIFJ4iRLbWS6q3Ag/92oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kKxTN2gq9Jy2iGjyRCG55zJX/Rsa+NSjAjqNbMnzYXk=;
 b=XhKjhTgHmwebGp3Nc/C5xpVk8LODB8kxEC0Msakm3QmhTpzwEfzbtL14aqaCdXp3kc5Ak9yq6MMpdARuaVLbmahoQGXWlHam5D3pShza25VGaYeujBlkEkai9Le1yi3ibvIBIOKa4ztsljQwzOMy6l4xQutcKz67VpqZHa9ab2sv10J2v2rTkywedza8lHyEnGDcXFNy4YSkNuvxMvx+nvS5mPSMqUOO5QGebTjlFOA3B1pj3VSUq0SUKJxlukyzQvDMDLDnHHnumstl6GF25vXJ5+JXvwMo9JVPZ5Z/Bzd3wAT6dEzyMImL10lio5IoUGh8C9wh3oXjGXN8bX6K9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kKxTN2gq9Jy2iGjyRCG55zJX/Rsa+NSjAjqNbMnzYXk=;
 b=NBIDa/HhTIKeq3pj6ciolKPRQSSLirIqBEzhObdMP/+zrIvmNQdvshlt2YEhOHwqel8KiovGF+a6G1HVjOeyB3iPle5HoY5QtlDrqUEkHtS2DZN2a5m/dFkFJnLb563M/UcfehUS4mMEUwbjoXQtRt1jl/z+A8Uez/nVdwkc12E=
Received: from BN8PR11MB3795.namprd11.prod.outlook.com (2603:10b6:408:82::31)
 by BN6PR11MB1667.namprd11.prod.outlook.com (2603:10b6:405:e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.24; Sun, 28 Jun
 2020 03:12:12 +0000
Received: from BN8PR11MB3795.namprd11.prod.outlook.com
 ([fe80::c96e:e522:e0dc:490c]) by BN8PR11MB3795.namprd11.prod.outlook.com
 ([fe80::c96e:e522:e0dc:490c%7]) with mapi id 15.20.3131.026; Sun, 28 Jun 2020
 03:12:12 +0000
From:   "Wang, Haiyue" <haiyue.wang@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        David Marchand <david.marchand@redhat.com>,
        Kevin Traynor <ktraynor@redhat.com>
Subject: RE: [PATCH] vfio/pci: Fix SR-IOV VF handling with MMIO blocking
Thread-Topic: [PATCH] vfio/pci: Fix SR-IOV VF handling with MMIO blocking
Thread-Index: AQHWSxHG3MhsyYc5LU2HHyb99u21najtWeJw
Date:   Sun, 28 Jun 2020 03:12:12 +0000
Message-ID: <BN8PR11MB3795C3338B3C7F67A6EDB43AF7910@BN8PR11MB3795.namprd11.prod.outlook.com>
References: <159310421505.27590.16617666489295503039.stgit@gimli.home>
In-Reply-To: <159310421505.27590.16617666489295503039.stgit@gimli.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.196]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9d39ed25-0afc-429b-fa73-08d81b110d8f
x-ms-traffictypediagnostic: BN6PR11MB1667:
x-microsoft-antispam-prvs: <BN6PR11MB16677EEC1217D9E8C3038623F7910@BN6PR11MB1667.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0448A97BF2
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Fal8FlIKaYD7cBWH6PYhBiKHC3e7tCpmI73V92WcslMKXKqAkAfpNaWuCza/h6GVyYp6OcX/b5CWZ3/5ywULXrC/Khh6bGxijBgF9SG6Zq9fGALtCk+qkhRUEWYJXlNT/R7cwH44L1+yP9H3SccDGXuA9FdbapMWZeZNNqpjVujxMHcOqyHkUINlMjfre8S6ZKSLNrCiGKAa6RY+9OJ/Glcd0TKMaaVxJBPvnhpHA2dMtijugJ/S96RRIq5exR4eyhBhZdVnvNPfhqoTPvTBREBubbwh6CsB58MLVDyV821r/8mJNae58eLE1B7+72js
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR11MB3795.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(33656002)(186003)(4326008)(8676002)(52536014)(9686003)(71200400001)(26005)(8936002)(6506007)(5660300002)(83380400001)(86362001)(53546011)(76116006)(6916009)(66946007)(66446008)(7696005)(478600001)(64756008)(66556008)(66476007)(54906003)(2906002)(55016002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 01f2EbkoX1Q97BFZ07cRyj4zAjCX0JMAKqJFVfYNyK3kTVufJA3riR49TLVVH3lhFXpjB8lIf8pPBfn8MqNuZzEl5zyGOED/nkjltZiSYC0LUVTQIyn4oP+ZrHxejS/Z0pCHU9xLIBjvGfQ5Vcp4kCAcZrqRvU9adfvk+wOLPzDbWZiMloa+iwKNJBIi4gIHNK4AVmaE5zTXFZIjmZea5/at6fzI3+VB/fT1i0z8ivYgZWUZtSTE9z2VqXpz2ZZquNpCL0PUf5hvEiZda7iubJGPAUfPFs/JW7Fb6v/kdcqZFWw+ifI1sLGaFjYNQCyuzav+8qIHsw5Lqispc7kxIzk3Zf04+6ms97aduciS1uZAFl2/OsGdqFlf67uJDy6hYipnA6KMVVi14afLlcmRAd/JkPFMMS/OA9oqSe8M/1fAOmS+CsdtdAj0uEFoGr/s8pVyTlvAx//0vPQqSJ9BCJCBZBmUCeknh4iEDvghGiQ8weXwmqzKm7K6ZcrxrlwZ
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR11MB3795.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d39ed25-0afc-429b-fa73-08d81b110d8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2020 03:12:12.8518
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /mJaYyO0481ID3VoCN9inWFdu4JJJMroU7PBlgMoj4CpMTIqkSxlpSFRJKzEGlD0NZ9z9nWQexYO1Lsbzh1SaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1667
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBrdm0tb3duZXJAdmdlci5rZXJu
ZWwub3JnIDxrdm0tb3duZXJAdmdlci5rZXJuZWwub3JnPiBPbiBCZWhhbGYgT2YgQWxleCBXaWxs
aWFtc29uDQo+IFNlbnQ6IEZyaWRheSwgSnVuZSAyNiwgMjAyMCAwMDo1Nw0KPiBUbzogYWxleC53
aWxsaWFtc29uQHJlZGhhdC5jb20NCj4gQ2M6IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtl
cm5lbEB2Z2VyLmtlcm5lbC5vcmc7IG1heGltZS5jb3F1ZWxpbkByZWRoYXQuY29tDQo+IFN1Ympl
Y3Q6IFtQQVRDSF0gdmZpby9wY2k6IEZpeCBTUi1JT1YgVkYgaGFuZGxpbmcgd2l0aCBNTUlPIGJs
b2NraW5nDQo+IA0KPiBTUi1JT1YgVkZzIGRvIG5vdCBpbXBsZW1lbnQgdGhlIG1lbW9yeSBlbmFi
bGUgYml0IG9mIHRoZSBjb21tYW5kDQo+IHJlZ2lzdGVyLCB0aGVyZWZvcmUgdGhpcyBiaXQgaXMg
bm90IHNldCBpbiBjb25maWcgc3BhY2UgYWZ0ZXINCj4gcGNpX2VuYWJsZV9kZXZpY2UoKS4gIFRo
aXMgbGVhZHMgdG8gYW4gdW5pbnRlbmRlZCBkaWZmZXJlbmNlDQo+IGJldHdlZW4gUEYgYW5kIFZG
IGluIGhhbmQtb2ZmIHN0YXRlIHRvIHRoZSB1c2VyLiAgV2UgY2FuIGNvcnJlY3QNCj4gdGhpcyBi
eSBzZXR0aW5nIHRoZSBpbml0aWFsIHZhbHVlIG9mIHRoZSBtZW1vcnkgZW5hYmxlIGJpdCBpbiBv
dXINCj4gdmlydHVhbGl6ZWQgY29uZmlnIHNwYWNlLiAgVGhlcmUncyByZWFsbHkgbm8gbmVlZCBo
b3dldmVyIHRvDQo+IGV2ZXIgZmF1bHQgYSB1c2VyIG9uIGEgVkYgdGhvdWdoIGFzIHRoaXMgd291
bGQgb25seSBpbmRpY2F0ZSBhbg0KPiBlcnJvciBpbiB0aGUgdXNlcidzIG1hbmFnZW1lbnQgb2Yg
dGhlIGVuYWJsZSBiaXQsIHZlcnN1cyBhIFBGDQo+IHdoZXJlIHRoZSBzYW1lIGFjY2VzcyBjb3Vs
ZCB0cmlnZ2VyIGhhcmR3YXJlIGZhdWx0cy4NCj4gDQo+IEZpeGVzOiBhYmFmYmM1NTFmZGQgKCJ2
ZmlvLXBjaTogSW52YWxpZGF0ZSBtbWFwcyBhbmQgYmxvY2sgTU1JTyBhY2Nlc3Mgb24gZGlzYWJs
ZWQgbWVtb3J5IikNCj4gU2lnbmVkLW9mZi1ieTogQWxleCBXaWxsaWFtc29uIDxhbGV4LndpbGxp
YW1zb25AcmVkaGF0LmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNpX2Nv
bmZpZy5jIHwgICAxNyArKysrKysrKysrKysrKysrLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDE2IGlu
c2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Zm
aW8vcGNpL3ZmaW9fcGNpX2NvbmZpZy5jIGIvZHJpdmVycy92ZmlvL3BjaS92ZmlvX3BjaV9jb25m
aWcuYw0KPiBpbmRleCA4NzQ2Yzk0MzI0N2EuLmQ5ODg0M2ZlZGRjZSAxMDA2NDQNCj4gLS0tIGEv
ZHJpdmVycy92ZmlvL3BjaS92ZmlvX3BjaV9jb25maWcuYw0KPiArKysgYi9kcml2ZXJzL3ZmaW8v
cGNpL3ZmaW9fcGNpX2NvbmZpZy5jDQo+IEBAIC0zOTgsOSArMzk4LDE1IEBAIHN0YXRpYyBpbmxp
bmUgdm9pZCBwX3NldGQoc3RydWN0IHBlcm1fYml0cyAqcCwgaW50IG9mZiwgdTMyIHZpcnQsIHUz
MiB3cml0ZSkNCj4gIC8qIENhbGxlciBzaG91bGQgaG9sZCBtZW1vcnlfbG9jayBzZW1hcGhvcmUg
Ki8NCj4gIGJvb2wgX192ZmlvX3BjaV9tZW1vcnlfZW5hYmxlZChzdHJ1Y3QgdmZpb19wY2lfZGV2
aWNlICp2ZGV2KQ0KPiAgew0KPiArCXN0cnVjdCBwY2lfZGV2ICpwZGV2ID0gdmRldi0+cGRldjsN
Cj4gIAl1MTYgY21kID0gbGUxNl90b19jcHUoKihfX2xlMTYgKikmdmRldi0+dmNvbmZpZ1tQQ0lf
Q09NTUFORF0pOw0KPiANCj4gLQlyZXR1cm4gY21kICYgUENJX0NPTU1BTkRfTUVNT1JZOw0KPiAr
CS8qDQo+ICsJICogU1ItSU9WIFZGIG1lbW9yeSBlbmFibGUgaXMgaGFuZGxlZCBieSB0aGUgTVNF
IGJpdCBpbiB0aGUNCj4gKwkgKiBQRiBTUi1JT1YgY2FwYWJpbGl0eSwgdGhlcmUncyB0aGVyZWZv
cmUgbm8gbmVlZCB0byB0cmlnZ2VyDQo+ICsJICogZmF1bHRzIGJhc2VkIG9uIHRoZSB2aXJ0dWFs
IHZhbHVlLg0KPiArCSAqLw0KPiArCXJldHVybiBwZGV2LT5pc192aXJ0Zm4gfHwgKGNtZCAmIFBD
SV9DT01NQU5EX01FTU9SWSk7DQoNCkhpIEFsZXgsDQoNCkFmdGVyIHNldCB1cCB0aGUgaW5pdGlh
bCBjb3B5IG9mIGNvbmZpZyBzcGFjZSBmb3IgbWVtb3J5IGVuYWJsZSBiaXQgZm9yIFZGLCBpcyBp
dCB3b3J0aA0KdG8gdHJpZ2dlciBTSUdCVVMgaW50byB0aGUgYmFkIHVzZXIgc3BhY2UgcHJvY2Vz
cyB3aGljaCBpbnRlbnRpb25hbGx5IHRyeSB0byBkaXNhYmxlIHRoZQ0KbWVtb3J5IGFjY2VzcyBj
b21tYW5kIChldmVuIGl0IGlzIFZGKSB0aGVuIGFjY2VzcyB0aGUgbWVtb3J5IHRvIHRyaWdnZXIg
Q1ZFLTIwMjAtMTI4ODggPw0KDQpCUiwNCkhhaXl1ZQ0KDQo+ICB9DQo+IA0KPiAgLyoNCj4gQEAg
LTE3MjgsNiArMTczNCwxNSBAQCBpbnQgdmZpb19jb25maWdfaW5pdChzdHJ1Y3QgdmZpb19wY2lf
ZGV2aWNlICp2ZGV2KQ0KPiAgCQkJCSB2Y29uZmlnW1BDSV9JTlRFUlJVUFRfUElOXSk7DQo+IA0K
PiAgCQl2Y29uZmlnW1BDSV9JTlRFUlJVUFRfUElOXSA9IDA7IC8qIEdyYXR1aXRvdXMgZm9yIGdv
b2QgVkZzICovDQo+ICsNCj4gKwkJLyoNCj4gKwkJICogVkZzIGRvIG5vIGltcGxlbWVudCB0aGUg
bWVtb3J5IGVuYWJsZSBiaXQgb2YgdGhlIENPTU1BTkQNCj4gKwkJICogcmVnaXN0ZXIgdGhlcmVm
b3JlIHdlJ2xsIG5vdCBoYXZlIGl0IHNldCBpbiBvdXIgaW5pdGlhbA0KPiArCQkgKiBjb3B5IG9m
IGNvbmZpZyBzcGFjZSBhZnRlciBwY2lfZW5hYmxlX2RldmljZSgpLiAgRm9yDQo+ICsJCSAqIGNv
bnNpc3RlbmN5IHdpdGggUEZzLCBzZXQgdGhlIHZpcnR1YWwgZW5hYmxlIGJpdCBoZXJlLg0KPiAr
CQkgKi8NCj4gKwkJKihfX2xlMTYgKikmdmNvbmZpZ1tQQ0lfQ09NTUFORF0gfD0NCj4gKwkJCQkJ
Y3B1X3RvX2xlMTYoUENJX0NPTU1BTkRfTUVNT1JZKTsNCj4gIAl9DQo+IA0KPiAgCWlmICghSVNf
RU5BQkxFRChDT05GSUdfVkZJT19QQ0lfSU5UWCkgfHwgdmRldi0+bm9pbnR4KQ0KDQo=
