Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675492260F5
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 15:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgGTNd1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 09:33:27 -0400
Received: from mga03.intel.com ([134.134.136.65]:6684 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725900AbgGTNd1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jul 2020 09:33:27 -0400
IronPort-SDR: nLWdMpZCPf9HPMboZ7cNcfbY6+V0xJgQMWLSt9J66hIASw+Ya+WaDcKV7vW7BS1/krL1q0qGlk
 yvenPsZgG6ag==
X-IronPort-AV: E=McAfee;i="6000,8403,9687"; a="149892241"
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="scan'208";a="149892241"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2020 06:33:24 -0700
IronPort-SDR: hbKC49QTN1FSOl2K1vGA+c+wMUiKyFO6q+EMu1+UeR71FpKHl+5AsYTB2aP0SZWFNXc7TyiFez
 eAJuYnvyyT1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="scan'208";a="283516710"
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by orsmga003.jf.intel.com with ESMTP; 20 Jul 2020 06:33:24 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX110.amr.corp.intel.com (10.22.240.8) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 20 Jul 2020 06:33:24 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 20 Jul 2020 06:33:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iL+zMWLFX8v3oQWPQMk2VJA/V1pZ2YrJFUBDBjdxubMDQkjcYjOWyrElIc1YbqfZyENyd33/oWJEBgroKO9k8rs5dMQrhW/8UheH/CESWJUe8D7d/rjL/fNyBOWslXjH0FDIEWKsBomO7nSP/HH0RoBcnCckmxnrPUP9c2jCobonAhVqrbmqzxysqLV9TB3oaHfNHPhFmknl532R/Nx+FsgzPsMOr1xveFuAtQktC0a7Fk2xMLw9RRoWicPoV5nm8ET8maIB5DICCpLJJqWDcY/2e+J84EqP0gNKPo87bFB7Idlg3IqoMgOABnzZ+mOhBKBDnahh8KV3YhblbTTfKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Did4OclTlVLRsl7kyk1lieVKCNHUQM2WmEl2pF2OUQ=;
 b=Ix2PiG1JL8cSsb+gx10yzEipo9E+vAHo225m+9teEw4gKv8cPtd2SYmQVR3uCMvZAqn/4NtmaNUIH1QvT/qwbiWaJRCEZZN2N9au5BzUaZow5UejD4kOI8/CZslwCtzpU2bdUIE8wZxj4MsOHntfj697oaQoSYwqJGMo07tDoiMjZg+mSfac7uYlwj/Um+ZxZscXOGQZKEe1+/+JyWqpIwUuUOXFzJBnoIuArfqiRrprmEGeib9bVFLbvZ8m+u2Rppeg2gw4d5JyTcFAzoDx1EMRWIlI969x/frIW5b88UHYQYbE5TQK5SSP8N54OSRshzYK6IscolyinWd31tF0UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Did4OclTlVLRsl7kyk1lieVKCNHUQM2WmEl2pF2OUQ=;
 b=blnM3EuPKgsfaTkUQal6IHeVYpL+/zkilUtvewXJIYPq6/SUS9X0VReNgMPZai9auePKxXVhLw8UjCeNq/VgIdjQNMYjMaXvNCZxQIeaxQPZJCNYL3IxyytpjxYxdt2hnq5bgm7nGRGZNwbdtrdQtsaBxXJuGAziJNq3OhRP1Z8=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB3148.namprd11.prod.outlook.com (2603:10b6:5:6f::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3195.17; Mon, 20 Jul 2020 13:33:21 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3195.025; Mon, 20 Jul
 2020 13:33:21 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Auger Eric <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5 15/15] iommu/vt-d: Support reporting nesting capability
 info
Thread-Topic: [PATCH v5 15/15] iommu/vt-d: Support reporting nesting
 capability info
Thread-Index: AQHWWD2ozEKwFS8Y2kWlIFOVw8dCH6kMCuCAgAR3s/A=
Date:   Mon, 20 Jul 2020 13:33:21 +0000
Message-ID: <DM5PR11MB14355BD93D10F5CB5CE9F056C37B0@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
 <1594552870-55687-16-git-send-email-yi.l.liu@intel.com>
 <be27f7ee-3fac-d1c5-0cd9-9581f8827de6@redhat.com>
In-Reply-To: <be27f7ee-3fac-d1c5-0cd9-9581f8827de6@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.102.204.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b45749d-edf2-4280-963a-08d82cb17888
x-ms-traffictypediagnostic: DM6PR11MB3148:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB314819B977E01EFA2B80F102C37B0@DM6PR11MB3148.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:758;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kynp+ReLhq+xj8sORHe41qSjC24h5Opbn3RNwhwrvy0UH2KxDMKVP8WzXugfOkyf+OXrBj0txfD40Xa0NFfzQeVj/xO3ahqnhWs3Ry6ap16SNkCz4BSnElgEV72ajm3m34PJgN/lCArHhFXTfr8IsO8v6kLYSOkzkYCluTljlHQdcRX+vOncZZhcY/OLHYrrTH4QqfAqQHA2vwQoppTKshJE0MVIcnmTswmtpZqK6rZousTdWIz05A7lh8b1x0mbvVCEFpmsFIr2W1o4uQTL534TzRoUSvCy1eGx8so8RtinB835U47PnvbY6aqbtQHP+xAqEZyjGl/JV/lrX7gB6w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(136003)(376002)(39860400002)(366004)(86362001)(7416002)(9686003)(71200400001)(4326008)(52536014)(316002)(83380400001)(66446008)(2906002)(64756008)(66556008)(66476007)(66946007)(76116006)(26005)(33656002)(55016002)(8676002)(478600001)(7696005)(5660300002)(186003)(54906003)(110136005)(53546011)(6506007)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 6SFI/QCFWOMEbBYuyOv1PatTjjgHeFqAk5aFpTaS2kAUa41znxuCvkRzMHlqQFtSU/Fd688idY4M3VgwD4I76fsq5bxu6muZA+bBVppR6WErdN/WpwPN9gz6IkytDr0haBDxlwO12JrLOvXwoZOo7zVKeCxnone2Ux8vJkux7NXqlePTIxjO3PzwkPjBH4E7NjMSXF/E50TwFDJFcC0YazxAAHCKtjpUQOM2yiOrYFNPQIIfBZ1SaiZi+bnB8SbNe145TYw8K3WLj2T91VluO8T0mU5sKVsb+9ay0EJTCSBDkfSl/fB8kHFHGaWK6WKr84EC5J8Soji+AF1OzxT6kxZ4djKeysOvuMpL6Dqq4p6ornO0Vjub1qNCHODjkb8Q8244FQQ/prxTjrz3HylOMZVmEWnuiQacNL1U9blCi+jMbTPf0zQbO9kyfLp9D2olbLqu3b2g5RF844lFIBG2C2HJbb2OH3q+6f2Kgaj/0O5D065ZOmnhFkofeRrNtr2a
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b45749d-edf2-4280-963a-08d82cb17888
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2020 13:33:21.5036
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h+Na1snQEW6fhLBuQWRJ12WBRhhIxk3SYNx8Snr56MrdoQ70DfmylqnS4XNFnTJV8XUnZwXL8cVsOr6WY53ejg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3148
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBBdWdlciBFcmljIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+
IFNlbnQ6IFNhdHVyZGF5LCBKdWx5IDE4LCAyMDIwIDE6MTQgQU0NCj4gDQo+IEhpIFlpLA0KPiAN
Cj4gTWlzc2luZyBhIHByb3BlciBjb21taXQgbWVzc2FnZS4gWW91IGNhbiBjb21tZW50IG9uIHRo
ZSBmYWN0IHlvdSBvbmx5DQo+IHN1cHBvcnQgdGhlIGNhc2Ugd2hlcmUgYWxsIHRoZSBwaHlzaWNh
bCBpb21tcyBoYXZlIHRoZSBzYW1lIENBUC9FQ0FQIE1BU0tTDQoNCmdvdCBpdC4gd2lsbCBhZGQg
aXQuIGl0IGxvb2tzIGxpa2UgdGhlIHN1YmplY3QgaXMgc3RyYWlnaHRmb3J3YXJkLCBzbyBJIHJl
bW92ZWQgY29tbWl0DQptZXNzYWdlLg0KDQo+IA0KPiBPbiA3LzEyLzIwIDE6MjEgUE0sIExpdSBZ
aSBMIHdyb3RlOg0KPiA+IENjOiBLZXZpbiBUaWFuIDxrZXZpbi50aWFuQGludGVsLmNvbT4NCj4g
PiBDQzogSmFjb2IgUGFuIDxqYWNvYi5qdW4ucGFuQGxpbnV4LmludGVsLmNvbT4NCj4gPiBDYzog
QWxleCBXaWxsaWFtc29uIDxhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbT4NCj4gPiBDYzogRXJp
YyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPg0KPiA+IENjOiBKZWFuLVBoaWxpcHBlIEJy
dWNrZXIgPGplYW4tcGhpbGlwcGVAbGluYXJvLm9yZz4NCj4gPiBDYzogSm9lcmcgUm9lZGVsIDxq
b3JvQDhieXRlcy5vcmc+DQo+ID4gQ2M6IEx1IEJhb2x1IDxiYW9sdS5sdUBsaW51eC5pbnRlbC5j
b20+DQo+ID4gU2lnbmVkLW9mZi1ieTogTGl1IFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4g
PiBTaWduZWQtb2ZmLWJ5OiBKYWNvYiBQYW4gPGphY29iLmp1bi5wYW5AbGludXguaW50ZWwuY29t
Pg0KPiA+IC0tLQ0KPiA+IHYyIC0+IHYzOg0KPiA+ICopIHJlbW92ZSBjYXAvZWNhcF9tYXNrIGlu
IGlvbW11X25lc3RpbmdfaW5mby4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9pb21tdS9pbnRlbC9p
b21tdS5jIHwgODENCj4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
Ky0tDQo+ID4gIGluY2x1ZGUvbGludXgvaW50ZWwtaW9tbXUuaCB8IDE2ICsrKysrKysrKw0KPiA+
ICAyIGZpbGVzIGNoYW5nZWQsIDk1IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+ID4N
Cj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pb21tdS9pbnRlbC9pb21tdS5jIGIvZHJpdmVycy9p
b21tdS9pbnRlbC9pb21tdS5jDQo+ID4gaW5kZXggYTk1MDRjYi4uOWY3YWQxYSAxMDA2NDQNCj4g
PiAtLS0gYS9kcml2ZXJzL2lvbW11L2ludGVsL2lvbW11LmMNCj4gPiArKysgYi9kcml2ZXJzL2lv
bW11L2ludGVsL2lvbW11LmMNCj4gPiBAQCAtNTY1OSwxMiArNTY1OSwxNiBAQCBzdGF0aWMgaW5s
aW5lIGJvb2wgaW9tbXVfcGFzaWRfc3VwcG9ydCh2b2lkKQ0KPiA+ICBzdGF0aWMgaW5saW5lIGJv
b2wgbmVzdGVkX21vZGVfc3VwcG9ydCh2b2lkKQ0KPiA+ICB7DQo+ID4gIAlzdHJ1Y3QgZG1hcl9k
cmhkX3VuaXQgKmRyaGQ7DQo+ID4gLQlzdHJ1Y3QgaW50ZWxfaW9tbXUgKmlvbW11Ow0KPiA+ICsJ
c3RydWN0IGludGVsX2lvbW11ICppb21tdSwgKnByZXYgPSBOVUxMOw0KPiA+ICAJYm9vbCByZXQg
PSB0cnVlOw0KPiA+DQo+ID4gIAlyY3VfcmVhZF9sb2NrKCk7DQo+ID4gIAlmb3JfZWFjaF9hY3Rp
dmVfaW9tbXUoaW9tbXUsIGRyaGQpIHsNCj4gPiAtCQlpZiAoIXNtX3N1cHBvcnRlZChpb21tdSkg
fHwgIWVjYXBfbmVzdChpb21tdS0+ZWNhcCkpIHsNCj4gPiArCQlpZiAoIXByZXYpDQo+ID4gKwkJ
CXByZXYgPSBpb21tdTsNCj4gPiArCQlpZiAoIXNtX3N1cHBvcnRlZChpb21tdSkgfHwgIWVjYXBf
bmVzdChpb21tdS0+ZWNhcCkgfHwNCj4gPiArCQkgICAgKFZURF9DQVBfTUFTSyAmIChpb21tdS0+
Y2FwIF4gcHJldi0+Y2FwKSkgfHwNCj4gPiArCQkgICAgKFZURF9FQ0FQX01BU0sgJiAoaW9tbXUt
PmVjYXAgXiBwcmV2LT5lY2FwKSkpIHsNCj4gPiAgCQkJcmV0ID0gZmFsc2U7DQo+ID4gIAkJCWJy
ZWFrOz4gIAkJfQ0KPiA+IEBAIC02MDc5LDYgKzYwODMsNzggQEAgaW50ZWxfaW9tbXVfZG9tYWlu
X3NldF9hdHRyKHN0cnVjdCBpb21tdV9kb21haW4NCj4gKmRvbWFpbiwNCj4gPiAgCXJldHVybiBy
ZXQ7DQo+ID4gIH0NCj4gPg0KPiA+ICtzdGF0aWMgaW50IGludGVsX2lvbW11X2dldF9uZXN0aW5n
X2luZm8oc3RydWN0IGlvbW11X2RvbWFpbiAqZG9tYWluLA0KPiA+ICsJCQkJCXN0cnVjdCBpb21t
dV9uZXN0aW5nX2luZm8gKmluZm8pDQo+ID4gK3sNCj4gPiArCXN0cnVjdCBkbWFyX2RvbWFpbiAq
ZG1hcl9kb21haW4gPSB0b19kbWFyX2RvbWFpbihkb21haW4pOw0KPiA+ICsJdTY0IGNhcCA9IFZU
RF9DQVBfTUFTSywgZWNhcCA9IFZURF9FQ0FQX01BU0s7DQo+ID4gKwlzdHJ1Y3QgZGV2aWNlX2Rv
bWFpbl9pbmZvICpkb21haW5faW5mbzsNCj4gPiArCXN0cnVjdCBpb21tdV9uZXN0aW5nX2luZm9f
dnRkIHZ0ZDsNCj4gPiArCXVuc2lnbmVkIGxvbmcgZmxhZ3M7DQo+ID4gKwl1bnNpZ25lZCBpbnQg
c2l6ZTsNCj4gPiArDQo+ID4gKwlpZiAoZG9tYWluLT50eXBlICE9IElPTU1VX0RPTUFJTl9VTk1B
TkFHRUQgfHwNCj4gPiArCSAgICAhKGRtYXJfZG9tYWluLT5mbGFncyAmIERPTUFJTl9GTEFHX05F
U1RJTkdfTU9ERSkpDQo+ID4gKwkJcmV0dXJuIC1FTk9ERVY7DQo+ID4gKw0KPiA+ICsJaWYgKCFp
bmZvKQ0KPiA+ICsJCXJldHVybiAtRUlOVkFMOw0KPiA+ICsNCj4gPiArCXNpemUgPSBzaXplb2Yo
c3RydWN0IGlvbW11X25lc3RpbmdfaW5mbykgKw0KPiA+ICsJCXNpemVvZihzdHJ1Y3QgaW9tbXVf
bmVzdGluZ19pbmZvX3Z0ZCk7DQo+ID4gKwkvKg0KPiA+ICsJICogaWYgcHJvdmlkZWQgYnVmZmVy
IHNpemUgaXMgc21hbGxlciB0aGFuIGV4cGVjdGVkLCBzaG91bGQNCj4gPiArCSAqIHJldHVybiAw
IGFuZCBhbHNvIHRoZSBleHBlY3RlZCBidWZmZXIgc2l6ZSB0byBjYWxsZXIuDQo+ID4gKwkgKi8N
Cj4gPiArCWlmIChpbmZvLT5zaXplIDwgc2l6ZSkgew0KPiA+ICsJCWluZm8tPnNpemUgPSBzaXpl
Ow0KPiA+ICsJCXJldHVybiAwOw0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCXNwaW5fbG9ja19pcnFz
YXZlKCZkZXZpY2VfZG9tYWluX2xvY2ssIGZsYWdzKTsNCj4gPiArCS8qDQo+ID4gKwkgKiBhcmJp
dHJhcnkgc2VsZWN0IHRoZSBmaXJzdCBkb21haW5faW5mbyBhcyBhbGwgbmVzdGluZw0KPiA+ICsJ
ICogcmVsYXRlZCBjYXBhYmlsaXRpZXMgc2hvdWxkIGJlIGNvbnNpc3RlbnQgYWNyb3NzIGlvbW11
DQo+ID4gKwkgKiB1bml0cy4NCj4gPiArCSAqLw0KPiA+ICsJZG9tYWluX2luZm8gPSBsaXN0X2Zp
cnN0X2VudHJ5KCZkbWFyX2RvbWFpbi0+ZGV2aWNlcywNCj4gPiArCQkJCSAgICAgICBzdHJ1Y3Qg
ZGV2aWNlX2RvbWFpbl9pbmZvLCBsaW5rKTsNCj4gPiArCWNhcCAmPSBkb21haW5faW5mby0+aW9t
bXUtPmNhcDsNCj4gPiArCWVjYXAgJj0gZG9tYWluX2luZm8tPmlvbW11LT5lY2FwOw0KPiA+ICsJ
c3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmZGV2aWNlX2RvbWFpbl9sb2NrLCBmbGFncyk7DQo+ID4g
Kw0KPiA+ICsJaW5mby0+Zm9ybWF0ID0gSU9NTVVfUEFTSURfRk9STUFUX0lOVEVMX1ZURDsNCj4g
PiArCWluZm8tPmZlYXR1cmVzID0gSU9NTVVfTkVTVElOR19GRUFUX1NZU1dJREVfUEFTSUQgfA0K
PiA+ICsJCQkgSU9NTVVfTkVTVElOR19GRUFUX0JJTkRfUEdUQkwgfA0KPiA+ICsJCQkgSU9NTVVf
TkVTVElOR19GRUFUX0NBQ0hFX0lOVkxEOw0KPiA+ICsJaW5mby0+YWRkcl93aWR0aCA9IGRtYXJf
ZG9tYWluLT5nYXc7DQo+ID4gKwlpbmZvLT5wYXNpZF9iaXRzID0gaWxvZzIoaW50ZWxfcGFzaWRf
bWF4X2lkKTsNCj4gPiArCWluZm8tPnBhZGRpbmcgPSAwOw0KPiA+ICsJdnRkLmZsYWdzID0gMDsN
Cj4gPiArCXZ0ZC5wYWRkaW5nID0gMDsNCj4gPiArCXZ0ZC5jYXBfcmVnID0gY2FwOw0KPiA+ICsJ
dnRkLmVjYXBfcmVnID0gZWNhcDsNCj4gPiArDQo+ID4gKwltZW1jcHkoaW5mby0+ZGF0YSwgJnZ0
ZCwgc2l6ZW9mKHZ0ZCkpOw0KPiA+ICsJcmV0dXJuIDA7DQo+ID4gK30NCj4gPiArDQo+ID4gK3N0
YXRpYyBpbnQgaW50ZWxfaW9tbXVfZG9tYWluX2dldF9hdHRyKHN0cnVjdCBpb21tdV9kb21haW4g
KmRvbWFpbiwNCj4gPiArCQkJCSAgICAgICBlbnVtIGlvbW11X2F0dHIgYXR0ciwgdm9pZCAqZGF0
YSkNCj4gPiArew0KPiA+ICsJc3dpdGNoIChhdHRyKSB7DQo+ID4gKwljYXNlIERPTUFJTl9BVFRS
X05FU1RJTkc6DQo+ID4gKwl7DQo+ID4gKwkJc3RydWN0IGlvbW11X25lc3RpbmdfaW5mbyAqaW5m
byA9DQo+ID4gKwkJCQkoc3RydWN0IGlvbW11X25lc3RpbmdfaW5mbyAqKWRhdGE7DQo+ID4gKw0K
PiA+ICsJCXJldHVybiBpbnRlbF9pb21tdV9nZXRfbmVzdGluZ19pbmZvKGRvbWFpbiwgaW5mbyk7
DQo+ID4gKwl9DQo+ID4gKwlkZWZhdWx0Og0KPiA+ICsJCXJldHVybiAtRU5PREVWOw0KPiAtRU5P
RU5UPw0KDQphcm1fc21tdV9kb21haW5fZ2V0X2F0dHIoKSBpcyB1c2luZyAtRU5PREVWLCBzbyBJ
IHVzZWQgdGhlIHNhbWUuIEkgY2FuDQptb2RpZnkgaXQgaWYgLUVOT0VOVCBpcyBiZXR0ZXIuIDot
KQ0KDQpSZWdhcmRzLA0KWWkgTGl1DQoNCj4gPiArCX0NCj4gPiArfQ0KPiA+ICsNCj4gPiAgLyoN
Cj4gPiAgICogQ2hlY2sgdGhhdCB0aGUgZGV2aWNlIGRvZXMgbm90IGxpdmUgb24gYW4gZXh0ZXJu
YWwgZmFjaW5nIFBDSSBwb3J0IHRoYXQgaXMNCj4gPiAgICogbWFya2VkIGFzIHVudHJ1c3RlZC4g
U3VjaCBkZXZpY2VzIHNob3VsZCBub3QgYmUgYWJsZSB0byBhcHBseSBxdWlya3MgYW5kDQo+ID4g
QEAgLTYxMDEsNiArNjE3Nyw3IEBAIGNvbnN0IHN0cnVjdCBpb21tdV9vcHMgaW50ZWxfaW9tbXVf
b3BzID0gew0KPiA+ICAJLmRvbWFpbl9hbGxvYwkJPSBpbnRlbF9pb21tdV9kb21haW5fYWxsb2Ms
DQo+ID4gIAkuZG9tYWluX2ZyZWUJCT0gaW50ZWxfaW9tbXVfZG9tYWluX2ZyZWUsDQo+ID4gIAku
ZG9tYWluX3NldF9hdHRyCT0gaW50ZWxfaW9tbXVfZG9tYWluX3NldF9hdHRyLA0KPiA+ICsJLmRv
bWFpbl9nZXRfYXR0cgk9IGludGVsX2lvbW11X2RvbWFpbl9nZXRfYXR0ciwNCj4gPiAgCS5hdHRh
Y2hfZGV2CQk9IGludGVsX2lvbW11X2F0dGFjaF9kZXZpY2UsDQo+ID4gIAkuZGV0YWNoX2RldgkJ
PSBpbnRlbF9pb21tdV9kZXRhY2hfZGV2aWNlLA0KPiA+ICAJLmF1eF9hdHRhY2hfZGV2CQk9IGlu
dGVsX2lvbW11X2F1eF9hdHRhY2hfZGV2aWNlLA0KPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xp
bnV4L2ludGVsLWlvbW11LmggYi9pbmNsdWRlL2xpbnV4L2ludGVsLWlvbW11LmgNCj4gPiBpbmRl
eCAxOGYyOTJlLi5jNGVkMGQ0IDEwMDY0NA0KPiA+IC0tLSBhL2luY2x1ZGUvbGludXgvaW50ZWwt
aW9tbXUuaA0KPiA+ICsrKyBiL2luY2x1ZGUvbGludXgvaW50ZWwtaW9tbXUuaA0KPiA+IEBAIC0x
OTcsNiArMTk3LDIyIEBADQo+ID4gICNkZWZpbmUgZWNhcF9tYXhfaGFuZGxlX21hc2soZSkgKChl
ID4+IDIwKSAmIDB4ZikNCj4gPiAgI2RlZmluZSBlY2FwX3NjX3N1cHBvcnQoZSkJKChlID4+IDcp
ICYgMHgxKSAvKiBTbm9vcGluZyBDb250cm9sICovDQo+ID4NCj4gPiArLyogTmVzdGluZyBTdXBw
b3J0IENhcGFiaWxpdHkgQWxpZ25tZW50ICovDQo+ID4gKyNkZWZpbmUgVlREX0NBUF9GTDFHUAkJ
QklUX1VMTCg1NikNCj4gPiArI2RlZmluZSBWVERfQ0FQX0ZMNUxQCQlCSVRfVUxMKDYwKQ0KPiA+
ICsjZGVmaW5lIFZURF9FQ0FQX1BSUwkJQklUX1VMTCgyOSkNCj4gPiArI2RlZmluZSBWVERfRUNB
UF9FUlMJCUJJVF9VTEwoMzApDQo+ID4gKyNkZWZpbmUgVlREX0VDQVBfU1JTCQlCSVRfVUxMKDMx
KQ0KPiA+ICsjZGVmaW5lIFZURF9FQ0FQX0VBRlMJCUJJVF9VTEwoMzQpDQo+ID4gKyNkZWZpbmUg
VlREX0VDQVBfUEFTSUQJCUJJVF9VTEwoNDApDQo+IA0KPiA+ICsNCj4gPiArLyogT25seSBjYXBh
YmlsaXRpZXMgbWFya2VkIGluIGJlbG93IE1BU0tzIGFyZSByZXBvcnRlZCAqLw0KPiA+ICsjZGVm
aW5lIFZURF9DQVBfTUFTSwkJKFZURF9DQVBfRkwxR1AgfCBWVERfQ0FQX0ZMNUxQKQ0KPiA+ICsN
Cj4gPiArI2RlZmluZSBWVERfRUNBUF9NQVNLCQkoVlREX0VDQVBfUFJTIHwgVlREX0VDQVBfRVJT
IHwgXA0KPiA+ICsJCQkJIFZURF9FQ0FQX1NSUyB8IFZURF9FQ0FQX0VBRlMgfCBcDQo+ID4gKwkJ
CQkgVlREX0VDQVBfUEFTSUQpDQo+ID4gKw0KPiA+ICAvKiBWaXJ0dWFsIGNvbW1hbmQgaW50ZXJm
YWNlIGNhcGFiaWxpdHkgKi8NCj4gPiAgI2RlZmluZSB2Y2NhcF9wYXNpZCh2KQkJKCgodikgJiBE
TUFfVkNTX1BBUykpIC8qIFBBU0lEIGFsbG9jYXRpb24NCj4gKi8NCj4gPg0KPiA+DQo+IFRoYW5r
cw0KPiANCj4gRXJpYw0KPiANCg0K
