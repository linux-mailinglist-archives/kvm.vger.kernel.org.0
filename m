Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8B32686B4
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 10:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgINIBS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 04:01:18 -0400
Received: from mga06.intel.com ([134.134.136.31]:38484 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbgINIBL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 04:01:11 -0400
IronPort-SDR: RtAj0EsR29MtEJiZ1WN0nQ+9oOhafxAo8Qcdd5AXsbzy578ki1rysO8iR55sammyuwIuVh8pAZ
 +4TEGx7PRSOg==
X-IronPort-AV: E=McAfee;i="6000,8403,9743"; a="220594118"
X-IronPort-AV: E=Sophos;i="5.76,425,1592895600"; 
   d="scan'208";a="220594118"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 01:01:10 -0700
IronPort-SDR: KL6k0XJ3Ke0AyfJ8HNnxZK9BZxpoX5elE7LtHRyafL35VEYI/36UugoBAf2C2+N9TDoI4UFn9O
 ej3ZM3MFagsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,425,1592895600"; 
   d="scan'208";a="408788314"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga001.fm.intel.com with ESMTP; 14 Sep 2020 01:01:10 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 14 Sep 2020 01:01:09 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 14 Sep 2020 01:01:09 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 14 Sep 2020 01:01:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oRAqrBnCIE+QUkb4hBXeLxX2srjV5uyjrigRuPH1BxQqx55+G9zJlJuzgjWxsZcpcH52oqDtW0WnK/hg7gUpgMQ4hcyiwJaM/dXL59rmEbEnE6Zcp1baOeNpV6G5i2fUFV5CpAtXKD5HMn4YoquLx7IqymrV2ZOaZMVH+FubB9tdMIrWooNE91Z0fOU71lF4qUxkL83SDQfIokhyXrxLV4dH1Ra6XhAcrKVCP4LlIQf/Z5ezNaGsXB50eFtupLtUhy4sjf6SPujEVSct6Rbcd1eeSM7kDqI3+M7L07Xq2mZG1/EOo3+DzA1qtzUBD0LiBBppIWbDrnUvRKe6MULexw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gvEGCZ20NHBNljvOq+5hnC3vPGAqQp/hglGVnB8PgC4=;
 b=C5YwDG2vq7B2/GEP84Bfh8ogKw/T0u4/y+28fR8oxCqYZjiFT/eJNtpVUvJD2mdwf4GqTP1+/9odcWl9YvVQ7zCTaY2BQUJkQ+fgO1hCicp8levnnIj6Lk64tX85CoE4vCXd9vkXLSTf9x/GYxjgiaSo0uf1bSz1nu0Zi9seHIAxmHdw1DtoL63O9gcfO6w4Ddg6R4PToYZyMVADs0O4B1uEnI0jnTPCO79rumCY0qVH41NR/Ihj3Q1bMDVjQEEgirUYkn+0qKpXHD+mtu2+Ga55qeVFl7v3Pt8LpPNdP9xcs5Y7UusbsHcuWwmWdsbG5lHsOy2do/RpBbQQYWV//Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gvEGCZ20NHBNljvOq+5hnC3vPGAqQp/hglGVnB8PgC4=;
 b=cCpKnCbqWcTfSoBqi0JTmJVLAC8riVLIesMk6hShZ+XRFvJe88PsDvvT2TGn5zxLtR1mpuCFZHQAem/RUeTvwnzzjAuwqs3BTUAag9hv9xm9T0UATjQr7A8Lu0xzXwNTd55V7sYsvrWbKENW4pUeH+krSZaAory6G7Jxx0zoulE=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR1101MB2288.namprd11.prod.outlook.com (2603:10b6:301:53::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Mon, 14 Sep
 2020 08:01:02 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::6dfe:feb8:25f1:ac9c]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::6dfe:feb8:25f1:ac9c%7]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 08:01:02 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Wang <jasowang@redhat.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>
CC:     "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: RE: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
Thread-Topic: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
Thread-Index: AQHWh19AhgenwZ1qREOwvjqrd6cs+KlnjewAgAA1gYA=
Date:   Mon, 14 Sep 2020 08:01:02 +0000
Message-ID: <MWHPR11MB164517F15EF2C4831C191CF28C230@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
 <411c81c0-f13c-37cc-6c26-cafb42b46b15@redhat.com>
In-Reply-To: <411c81c0-f13c-37cc-6c26-cafb42b46b15@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.209]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb11a16c-6fb9-4170-75e8-08d85884531c
x-ms-traffictypediagnostic: MWHPR1101MB2288:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB2288115FB156DB7F2506C6678C230@MWHPR1101MB2288.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DHL6521Aa8jvHAFPb5/PIqpLmZGjJyqc/h5M4I3Lw9B+fB7lU1rFVnjX1SGcNxl/2wlXoAbAlAzb3/5PezpXT0Zm2B1VhosjVZxrPp9vCfgby3LkjJL5cKzUMnqYxv5PyCa/wW+tfalv05Uzh3gjK+rj2IaTna72LwViqPVayjN57n5gxpaI76uaW9/BIVo12ds9Yb1AcCnY7k0RuF7rjuo8cSZep95x+JWdA1mZSu0dgdbgGEk+iFaXGX8gA+W5nFRavR6xT0LbSOR7mDFuII3HhI0G4MOQOwOhAWa/itPKxfkB3aKIbdUDJDVirgBdVF1B4RCMPBP0Yyg+pxJHiw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(346002)(366004)(376002)(7416002)(4326008)(186003)(9686003)(7696005)(52536014)(5660300002)(478600001)(316002)(55016002)(76116006)(66446008)(33656002)(66946007)(71200400001)(66476007)(66556008)(64756008)(110136005)(86362001)(54906003)(2906002)(8676002)(8936002)(83380400001)(26005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: YW8lRkAJ99SSLXDxWTI0qJGF7gy1guD5ickyopPok43zvW4zz6XINBUGHwtW/2xzDELPb5SjnfcdOgn7ptXdIu57CjPyG9Q4lREhqOgq7/K/j9O9Y4Jm2e/P/1J8S+0kGNpl1YGyH6OgVBkWNcJJYhoyUcag+WCfrlx6tm8lRb6oPSOWqvBQu6CX9OsUdsH7fI6iYzpeGqV7akjgF2k1AvzMozhlqJoomkfv5+tS1R7XpGq89akZt+CHuwl0B1zUBoYDb1MFt/Hx+AgAnWpY7fkTQifXeawfJ8/h8KlKIZxwlEg9o9SnE9buCbvfuVx212SCTOKbKsuI9TVLwdESnxZoi/QXO0whDdY1gcCiwPGtIf8U72IW1uTHM0Xg2uxKq+dpHrIC4Hy3v8Rc+vcV4ilyW8a4WLO6aE1ZDbo4AlBtDZsppurZIo7fBSeGjB/wJehIbBl6raeYaivlYiejFaTOJbxsV85LMWKyxMuScnaVtG10EyRgVTVnc9cLV0RCWbpn3NqMXflr0RKr0pAafrDQ4rV4YYyJiTGUEFgOt7iHLg+qWLAF/VWSHg4IxgMapHUp7PCVz915J0320fQ9CIWXtVrfu0ygeTRs12H4NlnUz7eENNfVUKo5SYkhAsZENurP1OPXAYquYSsvZgB5Eg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb11a16c-6fb9-4170-75e8-08d85884531c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2020 08:01:02.3347
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yx8QHkmpK9KzZ/7VAMYRV9wHn7WuFcIJhHhnqrR44yeeDkRTxCYPI5hBSQNGNxHO080ANmGTa0TrTnkDrCj1Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2288
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29tPg0KPiBTZW50OiBNb25kYXks
IFNlcHRlbWJlciAxNCwgMjAyMCAxMjoyMCBQTQ0KPiANCj4gT24gMjAyMC85LzEwIOS4i+WNiDY6
NDUsIExpdSBZaSBMIHdyb3RlOg0KPiA+IFNoYXJlZCBWaXJ0dWFsIEFkZHJlc3NpbmcgKFNWQSks
IGEuay5hLCBTaGFyZWQgVmlydHVhbCBNZW1vcnkgKFNWTSkgb24NCj4gPiBJbnRlbCBwbGF0Zm9y
bXMgYWxsb3dzIGFkZHJlc3Mgc3BhY2Ugc2hhcmluZyBiZXR3ZWVuIGRldmljZSBETUEgYW5kDQo+
ID4gYXBwbGljYXRpb25zLiBTVkEgY2FuIHJlZHVjZSBwcm9ncmFtbWluZyBjb21wbGV4aXR5IGFu
ZCBlbmhhbmNlDQo+IHNlY3VyaXR5Lg0KPiA+DQo+ID4gVGhpcyBWRklPIHNlcmllcyBpcyBpbnRl
bmRlZCB0byBleHBvc2UgU1ZBIHVzYWdlIHRvIFZNcy4gaS5lLiBTaGFyaW5nDQo+ID4gZ3Vlc3Qg
YXBwbGljYXRpb24gYWRkcmVzcyBzcGFjZSB3aXRoIHBhc3N0aHJ1IGRldmljZXMuIFRoaXMgaXMg
Y2FsbGVkDQo+ID4gdlNWQSBpbiB0aGlzIHNlcmllcy4gVGhlIHdob2xlIHZTVkEgZW5hYmxpbmcg
cmVxdWlyZXMgUUVNVS9WRklPL0lPTU1VDQo+ID4gY2hhbmdlcy4gRm9yIElPTU1VIGFuZCBRRU1V
IGNoYW5nZXMsIHRoZXkgYXJlIGluIHNlcGFyYXRlIHNlcmllcyAobGlzdGVkDQo+ID4gaW4gdGhl
ICJSZWxhdGVkIHNlcmllcyIpLg0KPiA+DQo+ID4gVGhlIGhpZ2gtbGV2ZWwgYXJjaGl0ZWN0dXJl
IGZvciBTVkEgdmlydHVhbGl6YXRpb24gaXMgYXMgYmVsb3csIHRoZSBrZXkNCj4gPiBkZXNpZ24g
b2YgdlNWQSBzdXBwb3J0IGlzIHRvIHV0aWxpemUgdGhlIGR1YWwtc3RhZ2UgSU9NTVUgdHJhbnNs
YXRpb24gKA0KPiA+IGFsc28ga25vd24gYXMgSU9NTVUgbmVzdGluZyB0cmFuc2xhdGlvbikgY2Fw
YWJpbGl0eSBpbiBob3N0IElPTU1VLg0KPiA+DQo+ID4NCj4gPiAgICAgIC4tLS0tLS0tLS0tLS0t
LiAgLi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS4NCj4gPiAgICAgIHwgICB2SU9NTVUgICAg
fCAgfCBHdWVzdCBwcm9jZXNzIENSMywgRkwgb25seXwNCj4gPiAgICAgIHwgICAgICAgICAgICAg
fCAgJy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLScNCj4gPiAgICAgIC4tLS0tLS0tLS0tLS0t
LS0tLw0KPiA+ICAgICAgfCBQQVNJRCBFbnRyeSB8LS0tIFBBU0lEIGNhY2hlIGZsdXNoIC0NCj4g
PiAgICAgICctLS0tLS0tLS0tLS0tJyAgICAgICAgICAgICAgICAgICAgICAgfA0KPiA+ICAgICAg
fCAgICAgICAgICAgICB8ICAgICAgICAgICAgICAgICAgICAgICBWDQo+ID4gICAgICB8ICAgICAg
ICAgICAgIHwgICAgICAgICAgICAgICAgQ1IzIGluIEdQQQ0KPiA+ICAgICAgJy0tLS0tLS0tLS0t
LS0nDQo+ID4gR3Vlc3QNCj4gPiAtLS0tLS18IFNoYWRvdyB8LS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS18LS0tLS0tLS0NCj4gPiAgICAgICAgdiAgICAgICAgdiAgICAgICAgICAgICAgICAgICAg
ICAgICAgdg0KPiA+IEhvc3QNCj4gPiAgICAgIC4tLS0tLS0tLS0tLS0tLiAgLi0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0uDQo+ID4gICAgICB8ICAgcElPTU1VICAgIHwgIHwgQmluZCBGTCBmb3IgR1ZB
LUdQQSAgfA0KPiA+ICAgICAgfCAgICAgICAgICAgICB8ICAnLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LScNCj4gPiAgICAgIC4tLS0tLS0tLS0tLS0tLS0tLyAgfA0KPiA+ICAgICAgfCBQQVNJRCBFbnRy
eSB8ICAgICBWIChOZXN0ZWQgeGxhdGUpDQo+ID4gICAgICAnLS0tLS0tLS0tLS0tLS0tLVwuLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLg0KPiA+ICAgICAgfCAgICAgICAgICAgICB8fFNM
IGZvciBHUEEtSFBBLCBkZWZhdWx0IGRvbWFpbnwNCj4gPiAgICAgIHwgICAgICAgICAgICAgfCAg
ICctLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0nDQo+ID4gICAgICAnLS0tLS0tLS0tLS0t
LScNCj4gPiBXaGVyZToNCj4gPiAgIC0gRkwgPSBGaXJzdCBsZXZlbC9zdGFnZSBvbmUgcGFnZSB0
YWJsZXMNCj4gPiAgIC0gU0wgPSBTZWNvbmQgbGV2ZWwvc3RhZ2UgdHdvIHBhZ2UgdGFibGVzDQo+
ID4NCj4gPiBQYXRjaCBPdmVydmlldzoNCj4gPiAgIDEuIHJlcG9ydHMgSU9NTVUgbmVzdGluZyBp
bmZvIHRvIHVzZXJzcGFjZSAoIHBhdGNoIDAwMDEsIDAwMDIsIDAwMDMsDQo+IDAwMTUgLCAwMDE2
KQ0KPiA+ICAgMi4gdmZpbyBzdXBwb3J0IGZvciBQQVNJRCBhbGxvY2F0aW9uIGFuZCBmcmVlIGZv
ciBWTXMgKHBhdGNoIDAwMDQsIDAwMDUsDQo+IDAwMDcpDQo+ID4gICAzLiBhIGZpeCB0byBhIHJl
dmlzaXQgaW4gaW50ZWwgaW9tbXUgZHJpdmVyIChwYXRjaCAwMDA2KQ0KPiA+ICAgNC4gdmZpbyBz
dXBwb3J0IGZvciBiaW5kaW5nIGd1ZXN0IHBhZ2UgdGFibGUgdG8gaG9zdCAocGF0Y2ggMDAwOCwg
MDAwOSwNCj4gMDAxMCkNCj4gPiAgIDUuIHZmaW8gc3VwcG9ydCBmb3IgSU9NTVUgY2FjaGUgaW52
YWxpZGF0aW9uIGZyb20gVk1zIChwYXRjaCAwMDExKQ0KPiA+ICAgNi4gdmZpbyBzdXBwb3J0IGZv
ciB2U1ZBIHVzYWdlIG9uIElPTU1VLWJhY2tlZCBtZGV2cyAocGF0Y2ggMDAxMikNCj4gPiAgIDcu
IGV4cG9zZSBQQVNJRCBjYXBhYmlsaXR5IHRvIFZNIChwYXRjaCAwMDEzKQ0KPiA+ICAgOC4gYWRk
IGRvYyBmb3IgVkZJTyBkdWFsIHN0YWdlIGNvbnRyb2wgKHBhdGNoIDAwMTQpDQo+IA0KPiANCj4g
SWYgaXQncyBwb3NzaWJsZSwgSSB3b3VsZCBzdWdnZXN0IGEgZ2VuZXJpYyB1QVBJIGluc3RlYWQg
b2YgYSBWRklPDQo+IHNwZWNpZmljIG9uZS4NCj4gDQo+IEphc29uIHN1Z2dlc3Qgc29tZXRoaW5n
IGxpa2UgL2Rldi9zdmEuIFRoZXJlIHdpbGwgYmUgYSBsb3Qgb2Ygb3RoZXINCj4gc3Vic3lzdGVt
cyB0aGF0IGNvdWxkIGJlbmVmaXQgZnJvbSB0aGlzIChlLmcgdkRQQSkuDQo+IA0KDQpKdXN0IGJl
IGN1cmlvdXMuIFdoZW4gZG9lcyB2RFBBIHN1YnN5c3RlbSBwbGFuIHRvIHN1cHBvcnQgdlNWQSBh
bmQgDQp3aGVuIGNvdWxkIG9uZSBleHBlY3QgYSBTVkEtY2FwYWJsZSB2RFBBIGRldmljZSBpbiBt
YXJrZXQ/DQoNClRoYW5rcw0KS2V2aW4NCg==
