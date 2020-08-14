Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41EC02445C0
	for <lists+kvm@lfdr.de>; Fri, 14 Aug 2020 09:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgHNHQ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Aug 2020 03:16:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:41132 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726727AbgHNHQZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Aug 2020 03:16:25 -0400
IronPort-SDR: 7wDX3+w0YwqjRK1w4xGDrFqdDBb6Mv+2xSnXuqqurgHG3mQbXO1fNuA0FOw9vycMEWja7I8nzW
 eyihAz0e9qeA==
X-IronPort-AV: E=McAfee;i="6000,8403,9712"; a="152014480"
X-IronPort-AV: E=Sophos;i="5.76,311,1592895600"; 
   d="scan'208";a="152014480"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2020 00:15:54 -0700
IronPort-SDR: +4Y2nrRTaZpr65Yo6Ac7T7f2L261i1GoYbs9JRk7Nd2byBC0EfgNLbMCdAoP+2tvnpJDu/2YHG
 HE30SxLQg9zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,311,1592895600"; 
   d="scan'208";a="333340802"
Received: from fmsmsx603-2.cps.intel.com (HELO fmsmsx603.amr.corp.intel.com) ([10.18.84.213])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Aug 2020 00:15:54 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 14 Aug 2020 00:15:53 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 14 Aug 2020 00:15:53 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Fri, 14 Aug 2020 00:15:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XS8NfjD6MNk/m9x1ZLOzmCMOY6tCaOi9ZK/Ygk4rQVjTQPs2T7lO0t/bAuKDr2O31ttqy8oJhNnjaotBLAsnq54fsMR6qhri22AWRZjySG/lrrQ4F8g1Q7gL4c+38/EjINx+OEaHecuKR3x+f/LJhpD24msMiC406TcYvBBiawEld7kTFGG+Z0jX8paG2l8EUTGt1lihVWbl2SrEe3Xp2EqEA9xOLgo1NgcDhC8V/g31OfJhDu7Sn000GvidZb0dvBgcOGu2nY4DhZtAJcta7VIlb8g/1PqLCaChtU4erVhQdnIxflJHkBhUvKLyX/phGwOd3/DwVlDQdUydql4WTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mcFX9i7AW0gEbnMaL94WWsDqvdZazrWpgIHaui36jgU=;
 b=TwIR0tjgmuXbfTTs1yjcixMEx0ei0dyVkLPJMXJEhDuBFmWnMEm+QWX5qecf97KkpqFxWJF+M4V0bx0BGmNQEmTI51nH8eC+RvPS700zD0i4UhzBkffWAWspgoScYHjKim6UTfwMEHi5/DPz9UKkjnCJ3Nv8uCnsTXYmuSUrQrLFBgfNwb+STAVhMA5a4WZw3FHgk/UBwqV31xycfkVqWG7mhlM9T0/+IYLC50QzyE0W8UFNI3bqtdQlGcuFNMBvb8dmdOXcZhUvLOBPbKNVcnCGq8dsUPk5qpIzcRyUD6VY/j5Pp9QrTnLn9nTIepAhJN/k7kkpCYi8un/hnq1VGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mcFX9i7AW0gEbnMaL94WWsDqvdZazrWpgIHaui36jgU=;
 b=WgEJ5Fzru3nBmewV6dKs65bGbAh50v5ZDfqBLwPW5c9GsA36r6Std2vLN1+mDlIXsgPGc0vfeRX4GoiCQSePvD7HLAbN+f7qnr9jswyCX5I/5mdYStybymzRRsz1BUatnDxai3fmQ+HJ3inqU8DpyqJOhg4D9q2UdXUYgl3CQ0M=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB3196.namprd11.prod.outlook.com (2603:10b6:5:5b::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3261.15; Fri, 14 Aug 2020 07:15:51 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3261.026; Fri, 14 Aug
 2020 07:15:51 +0000
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
Subject: RE: [PATCH v6 02/15] iommu: Report domain nesting info
Thread-Topic: [PATCH v6 02/15] iommu: Report domain nesting info
Thread-Index: AQHWZKdKwF+TL587NUuMMt8yXXLPy6k2F/OAgAExUEA=
Date:   Fri, 14 Aug 2020 07:15:51 +0000
Message-ID: <DM5PR11MB1435CC4503506228790CCB39C3400@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1595917664-33276-1-git-send-email-yi.l.liu@intel.com>
 <1595917664-33276-3-git-send-email-yi.l.liu@intel.com>
 <5c911565-c76a-c361-845e-56a91744d504@redhat.com>
In-Reply-To: <5c911565-c76a-c361-845e-56a91744d504@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [117.169.228.168]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1e29fa9f-f6b2-4ab2-d947-08d84021e083
x-ms-traffictypediagnostic: DM6PR11MB3196:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB31967D04381322AAC61E02E9C3400@DM6PR11MB3196.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QWLMTvJAh3py6UZ+EY7Ss+5m75dqbnO9LhD+gbNZ51ZWozPDGokG/MWIa/HBTRim49Y6rWSPabj0BOLyRYiuSaKximoNyw+T9JIIIS+5btlibPHB70MD5B9QqhTUt9GUla+gYUtQ/ePBE2dTYxbQg02Y2MBZ5tlfv77wpkE3TGxU6cGLuOSsMHE/0RoE5SQ321JDvVlmWknRrWI+hpLYJd9BFW1jksYLnLj63f8IH2SxHei48JNDLCRs0F+TX4g3m3Fpt3HyP3kJ+Y9QV70OStWJBTPxH7oQyWsNwQfjLE2DqWgg4ZPsj0RxAhsjA9QGl8jqO+DQt8I9mlN9/OAKyw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(39860400002)(346002)(396003)(110136005)(55016002)(66446008)(54906003)(9686003)(2906002)(71200400001)(7416002)(316002)(186003)(26005)(478600001)(52536014)(8676002)(6506007)(33656002)(76116006)(8936002)(86362001)(53546011)(7696005)(64756008)(66476007)(66556008)(66946007)(83380400001)(4326008)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: L6/LgBuJgPtNRMLsDa4UKcOKm6+AzpjFxHozLUMWVegz1Ie9BbwEcX3Yz1tTIE8bRYOzQi3fwShohauH5QKiZcgaCTTNAn0gAClvPKm+s2mpgJaRw8m1+4aWYJKWOMZIC4ofhqsD9kfyaqQ5omm3vOXrHd5/YcFWE2dHq8zROT+CQD+u2b+doDdgQ7edTeXcpmuwoPp44LHk+fAlh6/aQWO5IZlQhFuPdtIyn6OPmLX2IcnsCNnfWgWWsd5f4FdOP8PECdLXFq/2tRMGjPELA8/g002ZyK+9kI79A9bCScjda55nF/uiVHVawU4J7mTDEMQeRppk8PTbL6qFoqQrFxtaAgnl3r+VH6va8paFZjZm/LrHEdjQuuhKo/cfWjFD4IosplWP5WDH7x7AoZdtE0oLYyEBXKDHok5T+08rRH1oONp6pdDgIgI0O0phWArpxuCIfWSXB6RgR5Y8yO9AVecCqWFnDPT4ZAUlkG4eEmAoHLz0dd5UZJFYZi482rQ+1ynyMRWWqmwp8dWll4INj93CqdmEkQfdN1IeCHZ7mAtZsQ2vL49sp75jNCcJjpxMy1d9gZ3Sm4INo4jTo6Ru589pW6iw8j97N9c905laVkoqOkfTKp18xJju2miL7DTDEkxhh65B4EhqRjD9XJQVaw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e29fa9f-f6b2-4ab2-d947-08d84021e083
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2020 07:15:51.6611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oJkhkokH2RpqtSMmZfb93hj7F+e3iWWpWfPrM1mdVr/VCzo9SEZFlu1zYc740K5TwYYxopVhyqyjqd8AIbnXoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3196
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBBdWdlciBFcmljIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+
IFNlbnQ6IFRodXJzZGF5LCBBdWd1c3QgMTMsIDIwMjAgODo1MyBQTQ0KPiANCj4gWWksDQo+IE9u
IDcvMjgvMjAgODoyNyBBTSwgTGl1IFlpIEwgd3JvdGU6DQo+ID4gSU9NTVVzIHRoYXQgc3VwcG9y
dCBuZXN0aW5nIHRyYW5zbGF0aW9uIG5lZWRzIHJlcG9ydCB0aGUgY2FwYWJpbGl0eSBpbmZvDQo+
IHMvbmVlZHMvbmVlZCB0bw0KPiA+IHRvIHVzZXJzcGFjZS4gSXQgZ2l2ZXMgaW5mb3JtYXRpb24g
YWJvdXQgcmVxdWlyZW1lbnRzIHRoZSB1c2Vyc3BhY2UgbmVlZHMNCj4gPiB0byBpbXBsZW1lbnQg
cGx1cyBvdGhlciBmZWF0dXJlcyBjaGFyYWN0ZXJpemluZyB0aGUgcGh5c2ljYWwgaW1wbGVtZW50
YXRpb24uDQo+ID4NCj4gPiBUaGlzIHBhdGNoIHJlcG9ydHMgbmVzdGluZyBpbmZvIGJ5IERPTUFJ
Tl9BVFRSX05FU1RJTkcuIENhbGxlciBjYW4gZ2V0DQo+ID4gbmVzdGluZyBpbmZvIGFmdGVyIHNl
dHRpbmcgRE9NQUlOX0FUVFJfTkVTVElORy4gRm9yIFZGSU8sIGl0IGlzIGFmdGVyDQo+ID4gc2Vs
ZWN0aW5nIFZGSU9fVFlQRTFfTkVTVElOR19JT01NVS4NCj4gVGhpcyBpcyBub3Qgd2hhdCB0aGlz
IHBhdGNoIGRvZXMgOy0pIEl0IGludHJvZHVjZXMgYSBuZXcgSU9NTVUgVUFQSQ0KPiBzdHJ1Y3Qg
dGhhdCBnaXZlcyBpbmZvcm1hdGlvbiBhYm91dCB0aGUgbmVzdGluZyBjYXBhYmlsaXRpZXMgYW5k
DQo+IGZlYXR1cmVzLiBUaGlzIHN0cnVjdCBpcyBzdXBwb3NlZCB0byBiZSByZXR1cm5lZCBieQ0K
PiBpb21tdV9kb21haW5fZ2V0X2F0dHIoKSB3aXRoIERPTUFJTl9BVFRSX05FU1RJTkcgYXR0cmli
dXRlIHBhcmFtZXRlciwNCj4gb25lIGEgZG9tYWluIHdob3NlIHR5cGUgaGFzIGJlZW4gc2V0IHRv
IERPTUFJTl9BVFRSX05FU1RJTkcuDQoNCmdvdCBpdC4gbGV0IG1lIGFwcGx5IHlvdXIgc3VnZ2Vz
dGlvbi4gdGhhbmtzLiA6LSkNCg0KPiA+DQo+ID4gQ2M6IEtldmluIFRpYW4gPGtldmluLnRpYW5A
aW50ZWwuY29tPg0KPiA+IENDOiBKYWNvYiBQYW4gPGphY29iLmp1bi5wYW5AbGludXguaW50ZWwu
Y29tPg0KPiA+IENjOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29t
Pg0KPiA+IENjOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+ID4gQ2M6IEpl
YW4tUGhpbGlwcGUgQnJ1Y2tlciA8amVhbi1waGlsaXBwZUBsaW5hcm8ub3JnPg0KPiA+IENjOiBK
b2VyZyBSb2VkZWwgPGpvcm9AOGJ5dGVzLm9yZz4NCj4gPiBDYzogTHUgQmFvbHUgPGJhb2x1Lmx1
QGxpbnV4LmludGVsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBMaXUgWWkgTCA8eWkubC5saXVA
aW50ZWwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEphY29iIFBhbiA8amFjb2IuanVuLnBhbkBs
aW51eC5pbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gdjUgLT4gdjY6DQo+ID4gKikgcmVwaHJhc2Ug
dGhlIGZlYXR1cmUgbm90ZXMgcGVyIGNvbW1lbnRzIGZyb20gRXJpYyBBdWdlci4NCj4gPiAqKSBy
ZW5hbWUgQHNpemUgb2Ygc3RydWN0IGlvbW11X25lc3RpbmdfaW5mbyB0byBAYXJnc3ouDQo+ID4N
Cj4gPiB2NCAtPiB2NToNCj4gPiAqKSBhZGRyZXNzIGNvbW1lbnRzIGZyb20gRXJpYyBBdWdlci4N
Cj4gPg0KPiA+IHYzIC0+IHY0Og0KPiA+ICopIHNwbGl0IHRoZSBTTU1VIGRyaXZlciBjaGFuZ2Vz
IHRvIGJlIGEgc2VwYXJhdGUgcGF0Y2gNCj4gPiAqKSBtb3ZlIHRoZSBAYWRkcl93aWR0aCBhbmQg
QHBhc2lkX2JpdHMgZnJvbSB2ZW5kb3Igc3BlY2lmaWMNCj4gPiAgICBwYXJ0IHRvIGdlbmVyaWMg
cGFydC4NCj4gPiAqKSB0d2VhayB0aGUgZGVzY3JpcHRpb24gZm9yIHRoZSBAZmVhdHVyZXMgZmll
bGQgb2Ygc3RydWN0DQo+ID4gICAgaW9tbXVfbmVzdGluZ19pbmZvLg0KPiA+ICopIGFkZCBkZXNj
cmlwdGlvbiBvbiB0aGUgQGRhdGFbXSBmaWVsZCBvZiBzdHJ1Y3QgaW9tbXVfbmVzdGluZ19pbmZv
DQo+ID4NCj4gPiB2MiAtPiB2MzoNCj4gPiAqKSByZW12b2UgY2FwL2VjYXBfbWFzayBpbiBpb21t
dV9uZXN0aW5nX2luZm8uDQo+ID4gKikgcmV1c2UgRE9NQUlOX0FUVFJfTkVTVElORyB0byBnZXQg
bmVzdGluZyBpbmZvLg0KPiA+ICopIHJldHVybiBhbiBlbXB0eSBpb21tdV9uZXN0aW5nX2luZm8g
Zm9yIFNNTVUgZHJpdmVycyBwZXIgSmVhbicNCj4gPiAgICBzdWdnZXN0aW9uLg0KPiA+IC0tLQ0K
PiA+ICBpbmNsdWRlL3VhcGkvbGludXgvaW9tbXUuaCB8IDc0DQo+ICsrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDc0IGlu
c2VydGlvbnMoKykNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGludXgvaW9t
bXUuaCBiL2luY2x1ZGUvdWFwaS9saW51eC9pb21tdS5oDQo+ID4gaW5kZXggN2M4ZTA3NS4uNWU0
NzQ1YSAxMDA2NDQNCj4gPiAtLS0gYS9pbmNsdWRlL3VhcGkvbGludXgvaW9tbXUuaA0KPiA+ICsr
KyBiL2luY2x1ZGUvdWFwaS9saW51eC9pb21tdS5oDQo+ID4gQEAgLTMzMiw0ICszMzIsNzggQEAg
c3RydWN0IGlvbW11X2dwYXNpZF9iaW5kX2RhdGEgew0KPiA+ICAJfSB2ZW5kb3I7DQo+ID4gIH07
DQo+ID4NCj4gPiArLyoNCj4gPiArICogc3RydWN0IGlvbW11X25lc3RpbmdfaW5mbyAtIEluZm9y
bWF0aW9uIGZvciBuZXN0aW5nLWNhcGFibGUgSU9NTVUuDQo+ID4gKyAqCQkJICAgICAgIHVzZXJz
cGFjZSBzaG91bGQgY2hlY2sgaXQgYmVmb3JlIHVzaW5nDQo+ID4gKyAqCQkJICAgICAgIG5lc3Rp
bmcgY2FwYWJpbGl0eS4NCj4gPiArICoNCj4gPiArICogQGFyZ3N6OglzaXplIG9mIHRoZSB3aG9s
ZSBzdHJ1Y3R1cmUuDQo+ID4gKyAqIEBmbGFnczoJY3VycmVudGx5IHJlc2VydmVkIGZvciBmdXR1
cmUgZXh0ZW5zaW9uLiBtdXN0IHNldCB0byAwLg0KPiA+ICsgKiBAZm9ybWF0OglQQVNJRCB0YWJs
ZSBlbnRyeSBmb3JtYXQsIHRoZSBzYW1lIGRlZmluaXRpb24gYXMgc3RydWN0DQo+ID4gKyAqCQlp
b21tdV9ncGFzaWRfYmluZF9kYXRhIEBmb3JtYXQuDQo+ID4gKyAqIEBmZWF0dXJlczoJc3VwcG9y
dGVkIG5lc3RpbmcgZmVhdHVyZXMuDQo+ID4gKyAqIEBhZGRyX3dpZHRoOglUaGUgb3V0cHV0IGFk
ZHIgd2lkdGggb2YgZmlyc3QgbGV2ZWwvc3RhZ2UgdHJhbnNsYXRpb24NCj4gPiArICogQHBhc2lk
X2JpdHM6CU1heGltdW0gc3VwcG9ydGVkIFBBU0lEIGJpdHMsIDAgcmVwcmVzZW50cyBubyBQQVNJ
RA0KPiA+ICsgKgkJc3VwcG9ydC4NCj4gPiArICogQGRhdGE6CXZlbmRvciBzcGVjaWZpYyBjYXAg
aW5mby4gZGF0YVtdIHN0cnVjdHVyZSB0eXBlIGNhbiBiZSBkZWR1Y2VkDQo+ID4gKyAqCQlmcm9t
IEBmb3JtYXQgZmllbGQuDQo+ID4gKyAqDQo+ID4gKyAqDQo+ICs9PT09PT09PT09PT09PT0rPT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQo+ID09PSsN
Cj4gPiArICogfCBmZWF0dXJlICAgICAgIHwgIE5vdGVzICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICB8DQo+ID4gKyAqDQo+ICs9PT09PT09PT09PT09PT0rPT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQo+ID09PSsN
Cj4gPiArICogfCBTWVNXSURFX1BBU0lEIHwgIElPTU1VIHZlbmRvciBkcml2ZXIgc2V0cyBpdCB0
byBtYW5kYXRlIHVzZXJzcGFjZSAgICB8DQo+ID4gKyAqIHwgICAgICAgICAgICAgICB8ICB0byBh
bGxvY2F0ZSBQQVNJRCBmcm9tIGtlcm5lbC4gQWxsIFBBU0lEIGFsbG9jYXRpb24gfA0KPiA+ICsg
KiB8ICAgICAgICAgICAgICAgfCAgZnJlZSBtdXN0IGJlIG1lZGlhdGVkIHRocm91Z2ggdGhlIFRC
RCBBUEkuICAgICAgICAgIHwNCj4gcy9UQkQvSU9NTVUNCg0KZ290IGl0Lg0KDQo+ID4gKyAqICst
LS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tKw0KPiA+ICsgKiB8IEJJTkRfUEdUQkwgICAgfCAgSU9NTVUgdmVuZG9yIGRy
aXZlciBzZXRzIGl0IHRvIG1hbmRhdGUgdXNlcnNwYWNlICAgIHwNCj4gPiArICogfCAgICAgICAg
ICAgICAgIHwgIGJpbmQgdGhlIGZpcnN0IGxldmVsL3N0YWdlIHBhZ2UgdGFibGUgdG8gYXNzb2Np
YXRlZCB8DQo+IHMvYmluZC90byBiaW5kDQoNCmdvdCBpdC4NCg0KPiA+ICsgKiB8ICAgICAgICAg
ICAgICAgfCAgUEFTSUQgKGVpdGhlciB0aGUgb25lIHNwZWNpZmllZCBpbiBiaW5kIHJlcXVlc3Qg
b3IgIHwNCj4gPiArICogfCAgICAgICAgICAgICAgIHwgIHRoZSBkZWZhdWx0IFBBU0lEIG9mIGlv
bW11IGRvbWFpbiksIHRocm91Z2ggSU9NTVUgICB8DQo+ID4gKyAqIHwgICAgICAgICAgICAgICB8
ICBVQVBJLiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfA0K
PiA+ICsgKiArLS0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLSsNCj4gPiArICogfCBDQUNIRV9JTlZMRCAgIHwgIElPTU1V
IHZlbmRvciBkcml2ZXIgc2V0cyBpdCB0byBtYW5kYXRlIHVzZXJzcGFjZSAgICB8DQo+IA0KPiA+
ICsgKiB8ICAgICAgICAgICAgICAgfCAgZXhwbGljaXRseSBpbnZhbGlkYXRlIHRoZSBJT01NVSBj
YWNoZSB0aHJvdWdoIElPTU1VIHwNCj4gdG8gZXhwbGljaXRseQ0KDQpJIHNlZS4NCg0KPiA+ICsg
KiB8ICAgICAgICAgICAgICAgfCAgVQ0KPiA+IEFQSSBhY2NvcmRpbmcgdG8gdmVuZG9yLXNwZWNp
ZmljIHJlcXVpcmVtZW50IHdoZW4gIHwNCj4gPiArICogfCAgICAgICAgICAgICAgIHwgIGNoYW5n
aW5nIHRoZSAxc3QgbGV2ZWwvc3RhZ2UgcGFnZSB0YWJsZS4gICAgICAgICAgICB8DQo+ID4gKyAq
ICstLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tKw0KPiA+ICsgKg0KPiA+ICsgKiBAZGF0YVtdIHR5cGVzIGRlZmluZWQg
Zm9yIEBmb3JtYXQ6DQo+ID4gKyAqDQo+ICs9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PSs9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQo+ID09PSsNCj4gPiArICogfCBA
Zm9ybWF0ICAgICAgICAgICAgICAgICAgICAgICAgfCBAZGF0YVtdICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICB8DQo+ID4gKyAqDQo+ICs9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PSs9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQo+ID09PSsNCj4gPiArICogfCBJ
T01NVV9QQVNJRF9GT1JNQVRfSU5URUxfVlREICAgfCBzdHJ1Y3QgaW9tbXVfbmVzdGluZ19pbmZv
X3Z0ZCAgICAgICB8DQo+ID4gKyAqICstLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSst
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tKw0KPiA+ICsgKg0KPiA+ICsgKi8N
Cj4gPiArc3RydWN0IGlvbW11X25lc3RpbmdfaW5mbyB7DQo+ID4gKwlfX3UzMglhcmdzejsNCj4g
PiArCV9fdTMyCWZsYWdzOw0KPiA+ICsJX191MzIJZm9ybWF0Ow0KPiA+ICsjZGVmaW5lIElPTU1V
X05FU1RJTkdfRkVBVF9TWVNXSURFX1BBU0lECSgxIDw8IDApDQo+ID4gKyNkZWZpbmUgSU9NTVVf
TkVTVElOR19GRUFUX0JJTkRfUEdUQkwJCSgxIDw8IDEpDQo+ID4gKyNkZWZpbmUgSU9NTVVfTkVT
VElOR19GRUFUX0NBQ0hFX0lOVkxECQkoMSA8PCAyKQ0KPiA+ICsJX191MzIJZmVhdHVyZXM7DQo+
ID4gKwlfX3UxNglhZGRyX3dpZHRoOw0KPiA+ICsJX191MTYJcGFzaWRfYml0czsNCj4gPiArCV9f
dTMyCXBhZGRpbmc7DQo+ID4gKwlfX3U4CWRhdGFbXTsNCj4gPiArfTsNCj4gQXMgb3Bwb3NlZCB0
byBvdGhlciBJT01NVSBVQVBJIHN0cnVjdHMgdGhlcmUgaXMgbm8gdW5pb24gbWVtYmVyIGF0IHRo
ZQ0KPiBlbmQuDQoNCm5pY2UgY2F0Y2guIGRvIHlvdSB0aGluayBpdCB3b3VsZCBiZSBiZXR0ZXIg
dG8gYWRkaW5nIGEgdW5pb24gYW5kDQpwdXQgdGhlIHN0cnVjdCBpb21tdV9uZXN0aW5nX2luZm9f
dnRkIGluIGl0Pw0KDQo+IEFsc28gdGhpcyBzdHJ1Y3QgaXMgbm90IGRvY3VtZW50ZWQgaW4gW1BB
VENIIHY3IDEvN10gZG9jczogSU9NTVUNCj4gdXNlciBBUEkuIFNob3VsZG4ndCB3ZSBhbGlnbi4N
Cj4gWW91IG1heSBhbHNvIGNvbnNpZGVyIHRvIG1vdmUgdGhpcyBwYXRjaCBpbiBKYWNvYidzIHNl
cmllcyBmb3INCj4gY29uc2lzdGVuY3ksIHRob3VnaHRzPw0KDQp0aGlzIHdhcyB0YWxrZWQgb25l
IHRpbWUgYmV0d2VlbiBKYWNvYiBhbmQgbWUuIEl0IHdhcyBwdXQgaW4gdGhpcw0Kc2VyaWVzIGFz
IHRoZSBtYWpvciB1c2VyIG9mIG5lc3RpbmdfaW5mbyBpcyBpbiB0aGlzIHNlcmllcy4gZS5nLg0K
dmZpbyBjaGVja3MgdGhlIFNZU1dJREVfUEFTSUQuIGJ1dCBJJ20gb3BlbiB0byBtZXJnZSBpdCB3
aXRoIEphY29iJ3MNCnNlcmllcyBpZiBpdCB3b3VsZCBtYWtlIHRoZSBtZXJnZSBlYXNpZXIuDQoN
ClRoYW5rcywNCllpIExpdQ0KDQo+ID4gKw0KPiA+ICsvKg0KPiA+ICsgKiBzdHJ1Y3QgaW9tbXVf
bmVzdGluZ19pbmZvX3Z0ZCAtIEludGVsIFZULWQgc3BlY2lmaWMgbmVzdGluZyBpbmZvLg0KPiA+
ICsgKg0KPiA+ICsgKiBAZmxhZ3M6CVZULWQgc3BlY2lmaWMgZmxhZ3MuIEN1cnJlbnRseSByZXNl
cnZlZCBmb3IgZnV0dXJlDQo+ID4gKyAqCQlleHRlbnNpb24uIG11c3QgYmUgc2V0IHRvIDAuDQo+
ID4gKyAqIEBjYXBfcmVnOglEZXNjcmliZSBiYXNpYyBjYXBhYmlsaXRpZXMgYXMgZGVmaW5lZCBp
biBWVC1kIGNhcGFiaWxpdHkNCj4gPiArICoJCXJlZ2lzdGVyLg0KPiA+ICsgKiBAZWNhcF9yZWc6
CURlc2NyaWJlIHRoZSBleHRlbmRlZCBjYXBhYmlsaXRpZXMgYXMgZGVmaW5lZCBpbiBWVC1kDQo+
ID4gKyAqCQlleHRlbmRlZCBjYXBhYmlsaXR5IHJlZ2lzdGVyLg0KPiA+ICsgKi8NCj4gPiArc3Ry
dWN0IGlvbW11X25lc3RpbmdfaW5mb192dGQgew0KPiA+ICsJX191MzIJZmxhZ3M7DQo+ID4gKwlf
X3UzMglwYWRkaW5nOw0KPiA+ICsJX191NjQJY2FwX3JlZzsNCj4gPiArCV9fdTY0CWVjYXBfcmVn
Ow0KPiA+ICt9Ow0KPiA+ICsNCj4gPiAgI2VuZGlmIC8qIF9VQVBJX0lPTU1VX0ggKi8NCj4gPg0K
PiANCj4gVGhhbmtzDQo+IA0KPiBFcmljDQo+IA0KDQo=
