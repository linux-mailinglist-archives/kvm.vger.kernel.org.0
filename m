Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC9422584E
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 09:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgGTHUp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 03:20:45 -0400
Received: from mga03.intel.com ([134.134.136.65]:35662 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbgGTHUo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jul 2020 03:20:44 -0400
IronPort-SDR: OMWZV1IkZ4fwX1kdQ9a6kKp/RPksvVDmHQsmjs/C13zJG75yhUeXvxPydGXfZrEH5UnEsg1Ibu
 8mqE8v5ZOA1w==
X-IronPort-AV: E=McAfee;i="6000,8403,9687"; a="149850839"
X-IronPort-AV: E=Sophos;i="5.75,374,1589266800"; 
   d="scan'208";a="149850839"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2020 00:20:42 -0700
IronPort-SDR: OhayfH2uMfthA5db7dh0ksWVGis0yVJeFLZ9Y6mKctrqpaPhcR/tvnhz5OHEMLsOGy44Uri4O4
 78BL4e7Z/hOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,374,1589266800"; 
   d="scan'208";a="361940056"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by orsmga001.jf.intel.com with ESMTP; 20 Jul 2020 00:20:41 -0700
Received: from orsmsx151.amr.corp.intel.com (10.22.226.38) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 20 Jul 2020 00:20:40 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX151.amr.corp.intel.com (10.22.226.38) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 20 Jul 2020 00:20:40 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.59) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 20 Jul 2020 00:20:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YOB0X4/3eNok1obl0W91CJ5nATFUjKoPXsJUJCRn2voppLFu//TKijZaXx1oKuGfiODl6cLBHVMFSU3JP9hmWy7mtKYogwQSsC7ZgCqcuuCyF83dqnXKHqNlHL9DAtnVcKZocnIGSELt59VV5vlbPOnfdJzA/8CgQYv3auR7GzAnEeoTTBMrVtzHowyGFfmfVprDtX8GvHapv8Bvz7FzW32ivvxKbS6d+5nWRw8hm12i5C4WRDTdQ/limDvub0V5ojWk1+J7mYeC8uAoxOmIvPLn1fRD0aDhONQYu4RYq6/D9yBIrqyB/k5zbXMU2xCKBxoGjHCXpWCyVGIZBnnb7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1W0daj2ef5suQ7niJxvtakKtD1Z6zjFx5uiVU6kvud4=;
 b=BwBiXnjgkofhyfNJ0LIGKhG8P75tmt0KlIDcNbwBAxkoM/3FNbjTW/XzlYnCyBrogJNsv4Yz9W0KaMSXGOkT6q8KFiuFkyDgkzQoAfFp+zXohnBusgmXQOcaKCe3Uvj7a+wQKp2vv89Hx9WbCOaBCZ4CEg+jDXtgu+NTo27GdOfNDWhwZRA3k1oUw5jf2to4RqmIGaqG0J9Bk2Epskx5chnlJ+6woEJfDDyU4q9Moh0lm0i3dApM3jwjiUpYudEyLAfkNNttBM/FWkS6P2QBWqH0/0augL4oTGU4ZsrZ03OeiMsEwWcDEgbvOBzpiZDzIyfOrCDhZ1jqDlEKgVLsGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1W0daj2ef5suQ7niJxvtakKtD1Z6zjFx5uiVU6kvud4=;
 b=RV1FOv8XP8HJFZHUdTv8FrkeCD2nzL1wa/wbeJnZrYdH+rhn2iwKCnev6QJX60s5ZXUPkx6gIq9bAufxvbpSACozM+uoxj7LoTMbliqfu61GqRjTQIyOwpoOfh1HItIE2rbye062haieK6YOK4vpXA/kD036VXFXvhXF/97dseg=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB4722.namprd11.prod.outlook.com (2603:10b6:5:2a7::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3195.23; Mon, 20 Jul 2020 07:20:27 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3195.025; Mon, 20 Jul
 2020 07:20:27 +0000
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
Subject: RE: [PATCH v5 02/15] iommu: Report domain nesting info
Thread-Topic: [PATCH v5 02/15] iommu: Report domain nesting info
Thread-Index: AQHWWD2l24VL7ljS90uDgo6kI5uKT6kL/mYAgAQRbLA=
Date:   Mon, 20 Jul 2020 07:20:27 +0000
Message-ID: <DM5PR11MB1435E32D70ED3BB1BF56F94AC37B0@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
 <1594552870-55687-3-git-send-email-yi.l.liu@intel.com>
 <99c20ada-b7e8-44f6-e036-ab905d119119@redhat.com>
In-Reply-To: <99c20ada-b7e8-44f6-e036-ab905d119119@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2baf3bec-cf34-40f4-8deb-08d82c7d60b3
x-ms-traffictypediagnostic: DM6PR11MB4722:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB4722EB05FC9643C3299100F0C37B0@DM6PR11MB4722.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TthiII4+Pps/bGOR5xs12nJGp0COCjn5NNsM4yKD+riJeFMDcIr8b/n9NVeVVnvfcMJE6QpXqNP4rW+PGZLclsO9uUsQ1/vSpjC34v6MmjbiHrXyB3de6cn4+ujoXLzK7jHdP8RKSBuNPX2ARwPPSeHHXmdQj1wy31hFomhqjYKHEpNnuzqfV9nbsgqT0h7j+yCc9PPL7KUrEYtem4EWbmmSpYsaQ6beG4yOETx9UG/Oa0N090KLbZ/XUbnS8DqqFQzCZfdhgDVf+y+ROldk5Quey0WkfdJ+PrVnX4W3ltDOmXahqOXk3ETL/8qFXuAkyHshz38nyGhAtW5NFxgb6OGsNNhINTrw8wj0y/cQ0HhXlqdC43fTQTnwO3jlLTrPznU7R9+EA3g7gxAuLgEC4A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(66946007)(66556008)(76116006)(966005)(64756008)(66476007)(7696005)(55016002)(86362001)(2906002)(9686003)(66446008)(7416002)(8676002)(83380400001)(8936002)(26005)(186003)(33656002)(53546011)(6506007)(52536014)(54906003)(110136005)(71200400001)(5660300002)(4326008)(316002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: A6s5e0nZcxnmcrR2TUsu3EEtdUiwz36dsX+/XFVgXRFNMlJg2HAmgTUttm1E88F+fPziMrbphyefNpnVGE7A5fhph69hCwgBgK2zAZj0yVpB+nfiV+Wc7gZU9oOzywGa4f/ebMhYuVQYVca4GKxgXgBxPvl3Z6vg0zN4OWq1NYwIGV3IvKrC2ltDS/M0KKIDYo5ZAWVlA6eGZiC7eM85rM+RDiWYmkH2txFVcw1/9YCIkQ+4YAfLa3A8tew0B/HbEb1R8eG83O9npFoO0nv7vV704hV52rtBugYDgH51xhhowCihbjJb9cCVJCti0ITXzdDdVTNHNfUV1zI+CQ2KqoXCv4wJ0RKV0tkUdvaWgveE3+cPO0GzFoFPddA3rdIqfu3TBnc/FjtQlPmhQ6oes/KllXzfrrLnWjUYhZpSfLcsqHuzFoiJH0iDiiITs18JKH3A8zJZ6kfpDB4SI3cFnN+I0DFj0Uox1jxz49VcNrfOr0tmyv7T4/TN6lNnPmfm
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2baf3bec-cf34-40f4-8deb-08d82c7d60b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2020 07:20:27.6280
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QYw02umRKVyAIDCzHuK7pfZ38svyF3lc3nRlYqbeBY+2Q6ZwTGPO+fpMEQlvq1CrSDz+Nyfn4yxfSgrX3k1tog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4722
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBBdWdlciBFcmljIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+
IFNlbnQ6IFNhdHVyZGF5LCBKdWx5IDE4LCAyMDIwIDEyOjI5IEFNDQo+IA0KPiBIaSBZaSwNCj4g
DQo+IE9uIDcvMTIvMjAgMToyMCBQTSwgTGl1IFlpIEwgd3JvdGU6DQo+ID4gSU9NTVVzIHRoYXQg
c3VwcG9ydCBuZXN0aW5nIHRyYW5zbGF0aW9uIG5lZWRzIHJlcG9ydCB0aGUgY2FwYWJpbGl0eSBp
bmZvDQo+IHMvbmVlZHMvbmVlZCB0byByZXBvcnQNCg0KeWVwLg0KDQo+ID4gdG8gdXNlcnNwYWNl
LCBlLmcuIHRoZSBmb3JtYXQgb2YgZmlyc3QgbGV2ZWwvc3RhZ2UgcGFnaW5nIHN0cnVjdHVyZXMu
DQo+IEl0IGdpdmVzIGluZm9ybWF0aW9uIGFib3V0IHJlcXVpcmVtZW50cyB0aGUgdXNlcnNwYWNl
IG5lZWRzIHRvIGltcGxlbWVudA0KPiBwbHVzIG90aGVyIGZlYXR1cmVzIGNoYXJhY3Rlcml6aW5n
IHRoZSBwaHlzaWNhbCBpbXBsZW1lbnRhdGlvbi4NCg0KZ290IGl0LiB3aWxsIGFkZCBpdCBpbiBu
ZXh0IHZlcnNpb24uDQoNCj4gPg0KPiA+IFRoaXMgcGF0Y2ggcmVwb3J0cyBuZXN0aW5nIGluZm8g
YnkgRE9NQUlOX0FUVFJfTkVTVElORy4gQ2FsbGVyIGNhbiBnZXQNCj4gPiBuZXN0aW5nIGluZm8g
YWZ0ZXIgc2V0dGluZyBET01BSU5fQVRUUl9ORVNUSU5HLg0KPiBJIGd1ZXNzIHlvdSBtZWFudCBh
ZnRlciBzZWxlY3RpbmcgVkZJT19UWVBFMV9ORVNUSU5HX0lPTU1VPw0KDQp5ZXMsIGl0IGlzLiBv
aywgcGVyaGFwcywgaXQncyBiZXR0ZXIgdG8gc2F5IGdldCBuZXN0aW5nIGluZm8gYWZ0ZXIgc2Vs
ZWN0aW5nDQpWRklPX1RZUEUxX05FU1RJTkdfSU9NTVUuDQoNCj4gPg0KPiA+IENjOiBLZXZpbiBU
aWFuIDxrZXZpbi50aWFuQGludGVsLmNvbT4NCj4gPiBDQzogSmFjb2IgUGFuIDxqYWNvYi5qdW4u
cGFuQGxpbnV4LmludGVsLmNvbT4NCj4gPiBDYzogQWxleCBXaWxsaWFtc29uIDxhbGV4LndpbGxp
YW1zb25AcmVkaGF0LmNvbT4NCj4gPiBDYzogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQu
Y29tPg0KPiA+IENjOiBKZWFuLVBoaWxpcHBlIEJydWNrZXIgPGplYW4tcGhpbGlwcGVAbGluYXJv
Lm9yZz4NCj4gPiBDYzogSm9lcmcgUm9lZGVsIDxqb3JvQDhieXRlcy5vcmc+DQo+ID4gQ2M6IEx1
IEJhb2x1IDxiYW9sdS5sdUBsaW51eC5pbnRlbC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogTGl1
IFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBKYWNvYiBQYW4g
PGphY29iLmp1bi5wYW5AbGludXguaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+IHY0IC0+IHY1Og0K
PiA+ICopIGFkZHJlc3MgY29tbWVudHMgZnJvbSBFcmljIEF1Z2VyLg0KPiA+DQo+ID4gdjMgLT4g
djQ6DQo+ID4gKikgc3BsaXQgdGhlIFNNTVUgZHJpdmVyIGNoYW5nZXMgdG8gYmUgYSBzZXBhcmF0
ZSBwYXRjaA0KPiA+ICopIG1vdmUgdGhlIEBhZGRyX3dpZHRoIGFuZCBAcGFzaWRfYml0cyBmcm9t
IHZlbmRvciBzcGVjaWZpYw0KPiA+ICAgIHBhcnQgdG8gZ2VuZXJpYyBwYXJ0Lg0KPiA+ICopIHR3
ZWFrIHRoZSBkZXNjcmlwdGlvbiBmb3IgdGhlIEBmZWF0dXJlcyBmaWVsZCBvZiBzdHJ1Y3QNCj4g
PiAgICBpb21tdV9uZXN0aW5nX2luZm8uDQo+ID4gKikgYWRkIGRlc2NyaXB0aW9uIG9uIHRoZSBA
ZGF0YVtdIGZpZWxkIG9mIHN0cnVjdCBpb21tdV9uZXN0aW5nX2luZm8NCj4gPg0KPiA+IHYyIC0+
IHYzOg0KPiA+ICopIHJlbXZvZSBjYXAvZWNhcF9tYXNrIGluIGlvbW11X25lc3RpbmdfaW5mby4N
Cj4gPiAqKSByZXVzZSBET01BSU5fQVRUUl9ORVNUSU5HIHRvIGdldCBuZXN0aW5nIGluZm8uDQo+
ID4gKikgcmV0dXJuIGFuIGVtcHR5IGlvbW11X25lc3RpbmdfaW5mbyBmb3IgU01NVSBkcml2ZXJz
IHBlciBKZWFuJw0KPiA+ICAgIHN1Z2dlc3Rpb24uDQo+ID4gLS0tDQo+ID4gIGluY2x1ZGUvdWFw
aS9saW51eC9pb21tdS5oIHwgNzcNCj4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKw0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgNzcgaW5zZXJ0aW9ucygrKQ0KPiA+
DQo+ID4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9saW51eC9pb21tdS5oIGIvaW5jbHVkZS91
YXBpL2xpbnV4L2lvbW11LmgNCj4gPiBpbmRleCAxYWZjNjYxLi5kMmE0N2M0IDEwMDY0NA0KPiA+
IC0tLSBhL2luY2x1ZGUvdWFwaS9saW51eC9pb21tdS5oDQo+ID4gKysrIGIvaW5jbHVkZS91YXBp
L2xpbnV4L2lvbW11LmgNCj4gPiBAQCAtMzMyLDQgKzMzMiw4MSBAQCBzdHJ1Y3QgaW9tbXVfZ3Bh
c2lkX2JpbmRfZGF0YSB7DQo+ID4gIAl9IHZlbmRvcjsNCj4gPiAgfTsNCj4gPg0KPiA+ICsvKg0K
PiA+ICsgKiBzdHJ1Y3QgaW9tbXVfbmVzdGluZ19pbmZvIC0gSW5mb3JtYXRpb24gZm9yIG5lc3Rp
bmctY2FwYWJsZSBJT01NVS4NCj4gPiArICoJCQkgICAgICAgdXNlciBzcGFjZSBzaG91bGQgY2hl
Y2sgaXQgYmVmb3JlIHVzaW5nDQo+ID4gKyAqCQkJICAgICAgIG5lc3RpbmcgY2FwYWJpbGl0eS4N
Cj4gPiArICoNCj4gPiArICogQHNpemU6CXNpemUgb2YgdGhlIHdob2xlIHN0cnVjdHVyZQ0KPiA+
ICsgKiBAZm9ybWF0OglQQVNJRCB0YWJsZSBlbnRyeSBmb3JtYXQsIHRoZSBzYW1lIGRlZmluaXRp
b24gYXMgc3RydWN0DQo+ID4gKyAqCQlpb21tdV9ncGFzaWRfYmluZF9kYXRhIEBmb3JtYXQuDQo+
ID4gKyAqIEBmZWF0dXJlczoJc3VwcG9ydGVkIG5lc3RpbmcgZmVhdHVyZXMuDQo+ID4gKyAqIEBm
bGFnczoJY3VycmVudGx5IHJlc2VydmVkIGZvciBmdXR1cmUgZXh0ZW5zaW9uLg0KPiA+ICsgKiBA
YWRkcl93aWR0aDoJVGhlIG91dHB1dCBhZGRyIHdpZHRoIG9mIGZpcnN0IGxldmVsL3N0YWdlIHRy
YW5zbGF0aW9uDQo+ID4gKyAqIEBwYXNpZF9iaXRzOglNYXhpbXVtIHN1cHBvcnRlZCBQQVNJRCBi
aXRzLCAwIHJlcHJlc2VudHMgbm8gUEFTSUQNCj4gPiArICoJCXN1cHBvcnQuDQo+ID4gKyAqIEBk
YXRhOgl2ZW5kb3Igc3BlY2lmaWMgY2FwIGluZm8uIGRhdGFbXSBzdHJ1Y3R1cmUgdHlwZSBjYW4g
YmUgZGVkdWNlZA0KPiA+ICsgKgkJZnJvbSBAZm9ybWF0IGZpZWxkLg0KPiA+ICsgKg0KPiA+ICsg
Kg0KPiArPT09PT09PT09PT09PT09Kz09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PQ0KPiA9PT0rDQo+ID4gKyAqIHwgZmVhdHVyZSAgICAgICB8ICBOb3Rl
cyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfA0KPiA+ICsg
Kg0KPiArPT09PT09PT09PT09PT09Kz09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PQ0KPiA9PT0rDQo+ID4gKyAqIHwgU1lTV0lERV9QQVNJRCB8ICBQQVNJ
RHMgYXJlIG1hbmFnZWQgaW4gc3lzdGVtLXdpZGUsIGluc3RlYWQgb2YgcGVyICAgfA0KPiBzL2lu
IHN5c3RlbS13aWRlL3N5c3RlbS13aWRlID8NCg0KZ290IGl0Lg0KDQo+ID4gKyAqIHwgICAgICAg
ICAgICAgICB8ICBkZXZpY2UuIFdoZW4gYSBkZXZpY2UgaXMgYXNzaWduZWQgdG8gdXNlcnNwYWNl
IG9yICAgfA0KPiA+ICsgKiB8ICAgICAgICAgICAgICAgfCAgVk0sIHByb3BlciB1QVBJICh1c2Vy
c3BhY2UgZHJpdmVyIGZyYW1ld29yayB1QVBJLCAgIHwNCj4gPiArICogfCAgICAgICAgICAgICAg
IHwgIGUuZy4gVkZJTykgbXVzdCBiZSB1c2VkIHRvIGFsbG9jYXRlL2ZyZWUgUEFTSURzIGZvciB8
DQo+ID4gKyAqIHwgICAgICAgICAgICAgICB8ICB0aGUgYXNzaWduZWQgZGV2aWNlLg0KPiBJc24n
dCBpdCBwb3NzaWJsZSB0byBiZSBtb3JlIGV4cGxpY2l0LCBzb21ldGhpbmcgbGlrZToNCj4gICAg
ICAgICAgICAgICAgICAgICAgIHwNCj4gU3lzdGVtLXdpZGUgUEFTSUQgbWFuYWdlbWVudCBpcyBt
YW5kYXRlZCBieSB0aGUgcGh5c2ljYWwgSU9NTVUuIEFsbA0KPiBQQVNJRHMgYWxsb2NhdGlvbiBt
dXN0IGJlIG1lZGlhdGVkIHRocm91Z2ggdGhlIFRCRCBBUEkuDQoNCnllcCwgSSBjYW4gYWRkIGl0
Lg0KDQo+ID4gKyAqICstLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tKw0KPiA+ICsgKiB8IEJJTkRfUEdUQkwgICAgfCAg
VGhlIG93bmVyIG9mIHRoZSBmaXJzdCBsZXZlbC9zdGFnZSBwYWdlIHRhYmxlIG11c3QgIHwNCj4g
PiArICogfCAgICAgICAgICAgICAgIHwgIGV4cGxpY2l0bHkgYmluZCB0aGUgcGFnZSB0YWJsZSB0
byBhc3NvY2lhdGVkIFBBU0lEICB8DQo+ID4gKyAqIHwgICAgICAgICAgICAgICB8ICAoZWl0aGVy
IHRoZSBvbmUgc3BlY2lmaWVkIGluIGJpbmQgcmVxdWVzdCBvciB0aGUgICAgfA0KPiA+ICsgKiB8
ICAgICAgICAgICAgICAgfCAgZGVmYXVsdCBQQVNJRCBvZiBpb21tdSBkb21haW4pLCB0aHJvdWdo
IHVzZXJzcGFjZSAgIHwNCj4gPiArICogfCAgICAgICAgICAgICAgIHwgIGRyaXZlciBmcmFtZXdv
cmsgdUFQSSAoZS5nLiBWRklPX0lPTU1VX05FU1RJTkdfT1ApLiB8DQo+IEFzIHBlciB5b3VyIGFu
c3dlciBpbiBodHRwczovL2xrbWwub3JnL2xrbWwvMjAyMC83LzYvMzgzLCBJIG5vdw0KPiB1bmRl
cnN0YW5kIEFSTSB3b3VsZCBub3QgZXhwb3NlIHRoYXQgQklORF9QR1RCTCBuZXN0aW5nIGZlYXR1
cmUsDQoNCnllcywgdGhhdCdzIG15IHBvaW50Lg0KDQo+IEkgc3RpbGwNCj4gdGhpbmsgdGhlIGFi
b3ZlIHdvcmRpbmcgaXMgYSBiaXQgY29uZnVzaW5nLiBNYXliZSB5b3UgbWF5IGV4cGxpY2l0bHkN
Cj4gdGFsayBhYm91dCB0aGUgUEFTSUQgKmVudHJ5KiB0aGF0IG5lZWRzIHRvIGJlIHBhc3NlZCBm
cm9tIGd1ZXN0IHRvIGhvc3QuDQo+IE9uIEFSTSB3ZSBkaXJlY3RseSBwYXNzIHRoZSBQQVNJRCB0
YWJsZSBidXQgd2hlbiByZWFkaW5nIHRoZSBhYm92ZQ0KPiBkZXNjcmlwdGlvbiBJIGZhaWwgdG8g
ZGV0ZXJtaW5lIGlmIHRoaXMgZG9lcyBub3QgZml0IHRoYXQgZGVzY3JpcHRpb24uDQoNCnllcywg
SSBjYW4gZG8gaXQuDQoNCj4gPiArICogKy0tLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0rDQo+ID4gKyAqIHwgQ0FDSEVf
SU5WTEQgICB8ICBUaGUgb3duZXIgb2YgdGhlIGZpcnN0IGxldmVsL3N0YWdlIHBhZ2UgdGFibGUg
bXVzdCAgfA0KPiA+ICsgKiB8ICAgICAgICAgICAgICAgfCAgZXhwbGljaXRseSBpbnZhbGlkYXRl
IHRoZSBJT01NVSBjYWNoZSB0aHJvdWdoIHVBUEkgIHwNCj4gPiArICogfCAgICAgICAgICAgICAg
IHwgIHByb3ZpZGVkIGJ5IHVzZXJzcGFjZSBkcml2ZXIgZnJhbWV3b3JrIChlLmcuIFZGSU8pICB8
DQo+ID4gKyAqIHwgICAgICAgICAgICAgICB8ICBhY2NvcmRpbmcgdG8gdmVuZG9yLXNwZWNpZmlj
IHJlcXVpcmVtZW50IHdoZW4gICAgICAgfA0KPiA+ICsgKiB8ICAgICAgICAgICAgICAgfCAgY2hh
bmdpbmcgdGhlIHBhZ2UgdGFibGUuICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwNCj4gPiAr
ICogKy0tLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0rDQo+IA0KPiBpbnN0ZWFkIG9mIHVzaW5nIHRoZSAidUFQSSBwcm92
aWRlZCBieSB1c2Vyc3BhY2UgZHJpdmVyIGZyYW1ld29yayAoZS5nLg0KPiBWRklPKSIsIGNhbid0
IHdlIHVzZSB0aGUgc28tY2FsbGVkIElPTU1VIFVBUEkgdGVybWlub2xvZ3kgd2hpY2ggbm93IGhh
cw0KPiBhIHVzZXJzcGFjZSBkb2N1bWVudGF0aW9uPw0KDQp0aGUgcHJvYmxlbSBpcyBjdXJyZW50
IElPTU1VIFVBUEkgZGVmaW5pdGlvbnMgaXMgYWN0dWFsbHkgZW1iZWRkZWQgaW4NCm90aGVyIFZG
SU8gVUFQSS4gaWYgaXQgY2FuIG1ha2UgdGhlIGRlc2NyaXB0aW9uIG1vcmUgY2xlYXIsIEkgY2Fu
IGZvbGxvdw0KeW91ciBzdWdnZXN0aW9uLiA6LSkNCg0KPiANCj4gPiArICoNCj4gPiArICogQGRh
dGFbXSB0eXBlcyBkZWZpbmVkIGZvciBAZm9ybWF0Og0KPiA+ICsgKg0KPiArPT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT0rPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0K
PiA9PT0rDQo+ID4gKyAqIHwgQGZvcm1hdCAgICAgICAgICAgICAgICAgICAgICAgIHwgQGRhdGFb
XSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfA0KPiA+ICsgKg0KPiArPT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT0rPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0K
PiA9PT0rDQo+ID4gKyAqIHwgSU9NTVVfUEFTSURfRk9STUFUX0lOVEVMX1ZURCAgIHwgc3RydWN0
IGlvbW11X25lc3RpbmdfaW5mb192dGQgICAgICAgfA0KPiA+ICsgKiArLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSsN
Cj4gPiArICoNCj4gPiArICovDQo+ID4gK3N0cnVjdCBpb21tdV9uZXN0aW5nX2luZm8gew0KPiA+
ICsJX191MzIJc2l6ZTsNCj4gc2hvdWxkbid0IGl0IGJlIEBhcmdzeiB0byBmaXQgdGhlIGlvbW11
IHVhcGkgY29udmVudGlvbiBhbmQgdGFrZSBiZW5lZml0DQo+IHRvIHB1dCB0aGUgZmxhZ3MgZmll
bGQganVzdCBiZWxvdz8NCg0KbWFrZSBzZW5zZS4NCg0KPiA+ICsJX191MzIJZm9ybWF0Ow0KPiA+
ICsjZGVmaW5lIElPTU1VX05FU1RJTkdfRkVBVF9TWVNXSURFX1BBU0lECSgxIDw8IDApDQo+ID4g
KyNkZWZpbmUgSU9NTVVfTkVTVElOR19GRUFUX0JJTkRfUEdUQkwJCSgxIDw8IDEpDQo+ID4gKyNk
ZWZpbmUgSU9NTVVfTkVTVElOR19GRUFUX0NBQ0hFX0lOVkxECQkoMSA8PCAyKQ0KPiA+ICsJX191
MzIJZmVhdHVyZXM7DQo+ID4gKwlfX3UzMglmbGFnczsNCj4gPiArCV9fdTE2CWFkZHJfd2lkdGg7
DQo+ID4gKwlfX3UxNglwYXNpZF9iaXRzOw0KPiA+ICsJX191MzIJcGFkZGluZzsNCj4gPiArCV9f
dTgJZGF0YVtdOw0KPiA+ICt9Ow0KPiA+ICsNCj4gPiArLyoNCj4gPiArICogc3RydWN0IGlvbW11
X25lc3RpbmdfaW5mb192dGQgLSBJbnRlbCBWVC1kIHNwZWNpZmljIG5lc3RpbmcgaW5mbw0KPiA+
ICsgKg0KPiA+ICsgKiBAZmxhZ3M6CVZULWQgc3BlY2lmaWMgZmxhZ3MuIEN1cnJlbnRseSByZXNl
cnZlZCBmb3IgZnV0dXJlDQo+ID4gKyAqCQlleHRlbnNpb24uDQo+IG11c3QgYmUgc2V0IHRvIDA/
DQoNCnllcy4gd2lsbCBhZGQgaXQuDQoNClRoYW5rcywNCllpIExpdQ0KDQo+ID4gKyAqIEBjYXBf
cmVnOglEZXNjcmliZSBiYXNpYyBjYXBhYmlsaXRpZXMgYXMgZGVmaW5lZCBpbiBWVC1kIGNhcGFi
aWxpdHkNCj4gPiArICoJCXJlZ2lzdGVyLg0KPiA+ICsgKiBAZWNhcF9yZWc6CURlc2NyaWJlIHRo
ZSBleHRlbmRlZCBjYXBhYmlsaXRpZXMgYXMgZGVmaW5lZCBpbiBWVC1kDQo+ID4gKyAqCQlleHRl
bmRlZCBjYXBhYmlsaXR5IHJlZ2lzdGVyLg0KPiA+ICsgKi8NCj4gPiArc3RydWN0IGlvbW11X25l
c3RpbmdfaW5mb192dGQgew0KPiA+ICsJX191MzIJZmxhZ3M7DQo+ID4gKwlfX3UzMglwYWRkaW5n
Ow0KPiA+ICsJX191NjQJY2FwX3JlZzsNCj4gPiArCV9fdTY0CWVjYXBfcmVnOw0KPiA+ICt9Ow0K
PiA+ICsNCj4gPiAgI2VuZGlmIC8qIF9VQVBJX0lPTU1VX0ggKi8NCj4gVGhhbmtzDQo+IA0KPiBF
cmljDQo+ID4NCg0K
