Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598C3245CF5
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 09:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgHQHGS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 03:06:18 -0400
Received: from mga12.intel.com ([192.55.52.136]:6567 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726721AbgHQHGQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 03:06:16 -0400
IronPort-SDR: 0wKG2gdd3cntSeZmcuqzZ17n3QEe3R2kKufpt8Y+FPDhtcRoDcBliW9fdI6XXbnNtFC6QyqaXd
 v3Oqq5E0vRxw==
X-IronPort-AV: E=McAfee;i="6000,8403,9715"; a="134163624"
X-IronPort-AV: E=Sophos;i="5.76,322,1592895600"; 
   d="scan'208";a="134163624"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2020 00:05:38 -0700
IronPort-SDR: TN43f2icxfR863ncZGIkQjplb1UDaVnRk/WTXsGxcyEFJvLlVVbo1MKCbfaQscaYN3n6tKxiAF
 fPRk3V3RSAVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,322,1592895600"; 
   d="scan'208";a="471326703"
Received: from unknown (HELO fmsmsx604.amr.corp.intel.com) ([10.18.84.214])
  by orsmga005.jf.intel.com with ESMTP; 17 Aug 2020 00:05:37 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 17 Aug 2020 00:05:36 -0700
Received: from fmsmsx152.amr.corp.intel.com (10.18.125.5) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 17 Aug 2020 00:05:36 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 FMSMSX152.amr.corp.intel.com (10.18.125.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 17 Aug 2020 00:05:36 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 17 Aug 2020 00:05:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oWkcBjv+B+OIFcgn7b/Z4FS4luOmcIB51+I8xlRfjj8eq91WZbcd98dW0UQXpW9G85sJT0bSUK9yk0OQCzGijsxa9XpM+7kTP5sfRZlQVjSNgCRFp17U25x2YlScfXH0ywcSREoqSyl9qoxc+uGNjmNz8MfVe0MhR9tOR/bz0EAjVgnwA0DVdHXiQmUq/JvjKSSZaEZ/B6I17x1NawaWPDqzBN/pufB/0fQPvdUQkBAp2m5gzdmRbWaSgGTnS50vpN7b+Vbbw9xzZ9c+fm5ECBV27tX6eQA5cHmIvP/1xbI4qcDomvYBDIjZWWIjU3pQxG9f9AU5zQUNp8Rjpd+lmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/E2y0gamZxI1MvTMz7+cy3n6NWL1n6HzQDm3lXIew+g=;
 b=aSFKZpITrW96lm57sVs/ywXTwYzE5+CZ/gGFRQiSjZBwcXQ8cQBeyLpsd/dU3jPV79Jc7Xb6r8mFRZxPHPPamdXlei0ElFKaCvGWrnF7sAiZy/cPHi0Gf3m0HuabuLNGb12a50itNWOZa+sA+Pl2JU1S9TxNk/W7m5EF59x+VBl3wxyc6Wny3fQFmy5sl8vilxP0xCIqEgfTxxvwo/fIS/z+ADTX2neQhbBTkQbRQlob/1nmJ8n74EkVVd62+KWtrRkNGU+vHR40vltrgZ+t5RtcWIa+H3VFxtNjlstHrbeYKoowjvAkYnXIpZ5EyT0qIwM1A+9mBaztwdtEqDVUhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/E2y0gamZxI1MvTMz7+cy3n6NWL1n6HzQDm3lXIew+g=;
 b=Xj7dLB2LHVBEgoiGmFzjRBk1CfyVyOwg2/uYsXA9qxLiJd69fHalTciFIy3PUkV1BPNQp+pudvJ5MLPXHKoY/i9jl6Pq7HnmPGX0p+bPkDUkmEMN73PSh8/fcq2cHFS2TS0omHW8AlymCj4sA5Uqh+c2nUYGCtYWMkp7oSpnqDw=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM5PR11MB1692.namprd11.prod.outlook.com (2603:10b6:3:d::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3283.22; Mon, 17 Aug 2020 07:05:34 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3283.027; Mon, 17 Aug
 2020 07:05:34 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Auger Eric <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Lu, Baolu" <baolu.lu@intel.com>
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
Subject: RE: [PATCH v6 15/15] iommu/vt-d: Support reporting nesting capability
 info
Thread-Topic: [PATCH v6 15/15] iommu/vt-d: Support reporting nesting
 capability info
Thread-Index: AQHWZKdN2jQ/iA01+E66P0YDXHPJ1qk6wIWAgAE+lvA=
Date:   Mon, 17 Aug 2020 07:05:34 +0000
Message-ID: <DM5PR11MB14351B5746A8A09E2EBCBEBDC35F0@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1595917664-33276-1-git-send-email-yi.l.liu@intel.com>
 <1595917664-33276-16-git-send-email-yi.l.liu@intel.com>
 <7fe337fa-abbc-82be-c8e8-b9e2a6179b90@redhat.com>
In-Reply-To: <7fe337fa-abbc-82be-c8e8-b9e2a6179b90@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-Mentions: baolu.lu@intel.com
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [117.169.230.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f5b7f940-534f-4d2a-eaf6-08d8427befac
x-ms-traffictypediagnostic: DM5PR11MB1692:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB1692A26FBC6DFA45B63704CBC35F0@DM5PR11MB1692.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qtYmnWKIVe/Jg1Li1eiHl+lYXusB650QJtbERigfmWqDROmLr/qxG1udZTZk15NiQHHFQZzGlaJ9Sqr7YLjTGC0jZOA5FY2iiH48s6/2XZUjtY4/lrrmEXo+yZVrESZaylFoCoFx2t/TZCZqNf9QM4IS+suIYhrcuY1TzYuzM593gtgUDKWfZ/Roz9qpGu7L81kn9fPU41141fG8FH/G5sS/qV2IiHSrb+B6MwCsXtJyeMREVgUdBqrSIqAOTMMQJ+D3wWZD/ePhwUozKPB0ICopb8HtyWREj5aTBuKVUmLcmKURSGWliy3kclr3FIRaaOQi2FiRsWjrt0MQ9C9T8A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(366004)(346002)(39860400002)(83380400001)(7696005)(8936002)(52536014)(86362001)(4326008)(7416002)(26005)(54906003)(186003)(76116006)(2906002)(66556008)(66476007)(66446008)(110136005)(53546011)(64756008)(66946007)(6506007)(8676002)(55016002)(5660300002)(33656002)(6636002)(478600001)(316002)(71200400001)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: AmzYtsnEdNLMXxPlMsS/UhV0DjALEuFNkky+WGCN0YutNd06Qn/GWBeqrLWdqpahdlFK+1SdYGbV8PR2BXxU9QC5uYkz1n/UAjLZiepVrKWdUsSmBjrKiXAsiAq0a+bAPifGQGe2IaTVrqt+zbYMhsadct2L5GcXKfQYXvKkOQRtIS4TRDkXJqL4Ou7gN2AeAacuSvWndKnME7g/uK6nFWaWjXScUmZVa6vwS4aaCgt+l8F4BNdmspsviBsjBxLhbWgg0GvmA8Nq9ntwWpc6NCYoz3+puzOMOd8TlMKh6yoRpFDv0H/CZWkBppzXvn8IYYH2TdEKZ1Z6L7Bc4mjLCBP4JuFjSfGPZkzkK0ftm/SNmeNQN/t4LedsCRS31LI8tttpM3dnV+aKYfSg3xwoXdBXALfXHSsrjNjPNMK4unuwKlEYw/QyLOtxhe4Ar+lQsEMzi/KLBFJnydxY3z7ICGZtkFWVNRThODs9tY9K1hEJv/MKvkxwwFZV4eEKItgHPSiFbYX5N9SWeLsoWefU06w+3RfdZmNPdeg9COLNQLCKSkBRK++qzNmVnIDMqVOQb2uzEPYL50dtkA/Y09bQshYBYK4YG84fhll9z2nrAggr+dIOfv5Yami129JTCJQzVsfHAtY7tv3N8MwXe6xDtg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5b7f940-534f-4d2a-eaf6-08d8427befac
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2020 07:05:34.0403
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mZl48Ev4WVzCIWGv2zZK4k8ThwERWnYY+ZnL7RXC9U7AJ8H8nNZFxSLhu5JxyDP6Skkrfdc6gPEja2WJdk7sXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1692
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBBdWdlciBFcmljIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+IFNlbnQ6
IFN1bmRheSwgQXVndXN0IDE2LCAyMDIwIDg6MDEgUE0NCj4gDQo+IEhpIFlpLA0KPiANCj4gT24g
Ny8yOC8yMCA4OjI3IEFNLCBMaXUgWWkgTCB3cm90ZToNCj4gPiBUaGlzIHBhdGNoIHJlcG9ydHMg
bmVzdGluZyBpbmZvLCBhbmQgb25seSBzdXBwb3J0cyB0aGUgY2FzZSB3aGVyZSBhbGwNCj4gPiB0
aGUgcGh5c2ljYWwgaW9tbXMgaGF2ZSB0aGUgc2FtZSBDQVAvRUNBUCBNQVNLUy4NCj4gcy9pb21t
cy9pb21tdXMNCg0KeWVwLg0KDQo+ID4NCj4gPiBDYzogS2V2aW4gVGlhbiA8a2V2aW4udGlhbkBp
bnRlbC5jb20+DQo+ID4gQ0M6IEphY29iIFBhbiA8amFjb2IuanVuLnBhbkBsaW51eC5pbnRlbC5j
b20+DQo+ID4gQ2M6IEFsZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+
DQo+ID4gQ2M6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4NCj4gPiBDYzogSmVh
bi1QaGlsaXBwZSBCcnVja2VyIDxqZWFuLXBoaWxpcHBlQGxpbmFyby5vcmc+DQo+ID4gQ2M6IEpv
ZXJnIFJvZWRlbCA8am9yb0A4Ynl0ZXMub3JnPg0KPiA+IENjOiBMdSBCYW9sdSA8YmFvbHUubHVA
bGludXguaW50ZWwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IExpdSBZaSBMIDx5aS5sLmxpdUBp
bnRlbC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogSmFjb2IgUGFuIDxqYWNvYi5qdW4ucGFuQGxp
bnV4LmludGVsLmNvbT4NCj4gPiAtLS0NCj4gPiB2MiAtPiB2MzoNCj4gPiAqKSByZW1vdmUgY2Fw
L2VjYXBfbWFzayBpbiBpb21tdV9uZXN0aW5nX2luZm8uDQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMv
aW9tbXUvaW50ZWwvaW9tbXUuYyB8IDgxDQo+ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKystLQ0KPiA+ICBpbmNsdWRlL2xpbnV4L2ludGVsLWlvbW11LmggfCAxNiAr
KysrKysrKysNCj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCA5NSBpbnNlcnRpb25zKCspLCAyIGRlbGV0
aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW9tbXUvaW50ZWwvaW9tbXUu
YyBiL2RyaXZlcnMvaW9tbXUvaW50ZWwvaW9tbXUuYw0KPiA+IGluZGV4IDg4ZjQ2NDcuLjA4MzU4
MDQgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9pb21tdS9pbnRlbC9pb21tdS5jDQo+ID4gKysr
IGIvZHJpdmVycy9pb21tdS9pbnRlbC9pb21tdS5jDQo+ID4gQEAgLTU2NjAsMTIgKzU2NjAsMTYg
QEAgc3RhdGljIGlubGluZSBib29sIGlvbW11X3Bhc2lkX3N1cHBvcnQodm9pZCkNCj4gPiAgc3Rh
dGljIGlubGluZSBib29sIG5lc3RlZF9tb2RlX3N1cHBvcnQodm9pZCkNCj4gPiAgew0KPiA+ICAJ
c3RydWN0IGRtYXJfZHJoZF91bml0ICpkcmhkOw0KPiA+IC0Jc3RydWN0IGludGVsX2lvbW11ICpp
b21tdTsNCj4gPiArCXN0cnVjdCBpbnRlbF9pb21tdSAqaW9tbXUsICpwcmV2ID0gTlVMTDsNCj4g
PiAgCWJvb2wgcmV0ID0gdHJ1ZTsNCj4gPg0KPiA+ICAJcmN1X3JlYWRfbG9jaygpOw0KPiA+ICAJ
Zm9yX2VhY2hfYWN0aXZlX2lvbW11KGlvbW11LCBkcmhkKSB7DQo+ID4gLQkJaWYgKCFzbV9zdXBw
b3J0ZWQoaW9tbXUpIHx8ICFlY2FwX25lc3QoaW9tbXUtPmVjYXApKSB7DQo+ID4gKwkJaWYgKCFw
cmV2KQ0KPiA+ICsJCQlwcmV2ID0gaW9tbXU7DQo+ID4gKwkJaWYgKCFzbV9zdXBwb3J0ZWQoaW9t
bXUpIHx8ICFlY2FwX25lc3QoaW9tbXUtPmVjYXApIHx8DQo+ID4gKwkJICAgIChWVERfQ0FQX01B
U0sgJiAoaW9tbXUtPmNhcCBeIHByZXYtPmNhcCkpIHx8DQo+ID4gKwkJICAgIChWVERfRUNBUF9N
QVNLICYgKGlvbW11LT5lY2FwIF4gcHJldi0+ZWNhcCkpKSB7DQo+ID4gIAkJCXJldCA9IGZhbHNl
Ow0KPiA+ICAJCQlicmVhazsNCj4gU28gdGhpcyBjaGFuZ2VzIHRoZSBiZWhhdmlvciBvZiBET01B
SU5fQVRUUl9ORVNUSU5HLiBTaG91bGRuJ3QgaXQgaGF2ZSBhDQo+IEZpeGVzIHRhZyBhcyB3ZWxs
PyBBbmQgbWF5YmUgYWRkIHRoZSBjYXBhYmlsaXR5IGdldHRlciBpbiBhIHNlcGFyYXRlIHBhdGNo
Pw0KDQp5ZXMsIHRoaXMgY2hhbmdlZCB0aGUgYmVoYXZpb3IuIHNvIGl0IHdvdWxkIGJlIGJldHRl
ciB0byBiZSBhIHNlcGFyYXRlIHBhdGNoDQphbmQgdXBzdHJlYW0gYWxvbmc/IGhvdyBhYm91dCB5
b3VyIGlkZWE/IEBMdSwgQmFvbHUgOi0pDQoNCj4gPiAgCQl9DQo+ID4gQEAgLTYwODEsNiArNjA4
NSw3OCBAQCBpbnRlbF9pb21tdV9kb21haW5fc2V0X2F0dHIoc3RydWN0IGlvbW11X2RvbWFpbg0K
PiAqZG9tYWluLA0KPiA+ICAJcmV0dXJuIHJldDsNCj4gPiAgfQ0KPiA+DQo+ID4gK3N0YXRpYyBp
bnQgaW50ZWxfaW9tbXVfZ2V0X25lc3RpbmdfaW5mbyhzdHJ1Y3QgaW9tbXVfZG9tYWluICpkb21h
aW4sDQo+ID4gKwkJCQkJc3RydWN0IGlvbW11X25lc3RpbmdfaW5mbyAqaW5mbykNCj4gPiArew0K
PiA+ICsJc3RydWN0IGRtYXJfZG9tYWluICpkbWFyX2RvbWFpbiA9IHRvX2RtYXJfZG9tYWluKGRv
bWFpbik7DQo+ID4gKwl1NjQgY2FwID0gVlREX0NBUF9NQVNLLCBlY2FwID0gVlREX0VDQVBfTUFT
SzsNCj4gPiArCXN0cnVjdCBkZXZpY2VfZG9tYWluX2luZm8gKmRvbWFpbl9pbmZvOw0KPiA+ICsJ
c3RydWN0IGlvbW11X25lc3RpbmdfaW5mb192dGQgdnRkOw0KPiA+ICsJdW5zaWduZWQgbG9uZyBm
bGFnczsNCj4gPiArCXVuc2lnbmVkIGludCBzaXplOw0KPiA+ICsNCg0KcGVyaGFwcyBiZXR0ZXIg
dG8gYWNxdWlyZSB0aGUgbG9jayBoZXJlLiBbMV0NCg0KPiA+ICsJaWYgKGRvbWFpbi0+dHlwZSAh
PSBJT01NVV9ET01BSU5fVU5NQU5BR0VEIHx8DQo+ID4gKwkgICAgIShkbWFyX2RvbWFpbi0+Zmxh
Z3MgJiBET01BSU5fRkxBR19ORVNUSU5HX01PREUpKQ0KPiA+ICsJCXJldHVybiAtRU5PREVWOw0K
PiA+ICsNCj4gPiArCWlmICghaW5mbykNCj4gPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiArDQo+
ID4gKwlzaXplID0gc2l6ZW9mKHN0cnVjdCBpb21tdV9uZXN0aW5nX2luZm8pICsNCj4gPiArCQlz
aXplb2Yoc3RydWN0IGlvbW11X25lc3RpbmdfaW5mb192dGQpOw0KPiA+ICsJLyoNCj4gPiArCSAq
IGlmIHByb3ZpZGVkIGJ1ZmZlciBzaXplIGlzIHNtYWxsZXIgdGhhbiBleHBlY3RlZCwgc2hvdWxk
DQo+ID4gKwkgKiByZXR1cm4gMCBhbmQgYWxzbyB0aGUgZXhwZWN0ZWQgYnVmZmVyIHNpemUgdG8g
Y2FsbGVyLg0KPiA+ICsJICovDQo+ID4gKwlpZiAoaW5mby0+YXJnc3ogPCBzaXplKSB7DQo+ID4g
KwkJaW5mby0+YXJnc3ogPSBzaXplOw0KPiA+ICsJCXJldHVybiAwOw0KPiA+ICsJfQ0KPiA+ICsN
Cj4gPiArCXNwaW5fbG9ja19pcnFzYXZlKCZkZXZpY2VfZG9tYWluX2xvY2ssIGZsYWdzKTsNCj4g
PiArCS8qDQo+ID4gKwkgKiBhcmJpdHJhcnkgc2VsZWN0IHRoZSBmaXJzdCBkb21haW5faW5mbyBh
cyBhbGwgbmVzdGluZw0KPiA+ICsJICogcmVsYXRlZCBjYXBhYmlsaXRpZXMgc2hvdWxkIGJlIGNv
bnNpc3RlbnQgYWNyb3NzIGlvbW11DQo+ID4gKwkgKiB1bml0cy4NCj4gPiArCSAqLw0KPiA+ICsJ
ZG9tYWluX2luZm8gPSBsaXN0X2ZpcnN0X2VudHJ5KCZkbWFyX2RvbWFpbi0+ZGV2aWNlcywNCj4g
PiArCQkJCSAgICAgICBzdHJ1Y3QgZGV2aWNlX2RvbWFpbl9pbmZvLCBsaW5rKTsNCj4gPiArCWNh
cCAmPSBkb21haW5faW5mby0+aW9tbXUtPmNhcDsNCj4gPiArCWVjYXAgJj0gZG9tYWluX2luZm8t
PmlvbW11LT5lY2FwOw0KPiA+ICsJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmZGV2aWNlX2RvbWFp
bl9sb2NrLCBmbGFncyk7DQo+ID4gKw0KPiA+ICsJaW5mby0+Zm9ybWF0ID0gSU9NTVVfUEFTSURf
Rk9STUFUX0lOVEVMX1ZURDsNCj4gPiArCWluZm8tPmZlYXR1cmVzID0gSU9NTVVfTkVTVElOR19G
RUFUX1NZU1dJREVfUEFTSUQgfA0KPiA+ICsJCQkgSU9NTVVfTkVTVElOR19GRUFUX0JJTkRfUEdU
QkwgfA0KPiA+ICsJCQkgSU9NTVVfTkVTVElOR19GRUFUX0NBQ0hFX0lOVkxEOw0KPiA+ICsJaW5m
by0+YWRkcl93aWR0aCA9IGRtYXJfZG9tYWluLT5nYXc7DQo+ID4gKwlpbmZvLT5wYXNpZF9iaXRz
ID0gaWxvZzIoaW50ZWxfcGFzaWRfbWF4X2lkKTsNCj4gPiArCWluZm8tPnBhZGRpbmcgPSAwOw0K
PiA+ICsJdnRkLmZsYWdzID0gMDsNCj4gPiArCXZ0ZC5wYWRkaW5nID0gMDsNCj4gPiArCXZ0ZC5j
YXBfcmVnID0gY2FwOw0KPiA+ICsJdnRkLmVjYXBfcmVnID0gZWNhcDsNCj4gPiArDQo+ID4gKwlt
ZW1jcHkoaW5mby0+ZGF0YSwgJnZ0ZCwgc2l6ZW9mKHZ0ZCkpOw0KPiA+ICsJcmV0dXJuIDA7DQo+
ID4gK30NCj4gPiArDQo+ID4gK3N0YXRpYyBpbnQgaW50ZWxfaW9tbXVfZG9tYWluX2dldF9hdHRy
KHN0cnVjdCBpb21tdV9kb21haW4gKmRvbWFpbiwNCj4gPiArCQkJCSAgICAgICBlbnVtIGlvbW11
X2F0dHIgYXR0ciwgdm9pZCAqZGF0YSkNCj4gPiArew0KPiA+ICsJc3dpdGNoIChhdHRyKSB7DQo+
ID4gKwljYXNlIERPTUFJTl9BVFRSX05FU1RJTkc6DQo+ID4gKwl7DQo+ID4gKwkJc3RydWN0IGlv
bW11X25lc3RpbmdfaW5mbyAqaW5mbyA9DQo+ID4gKwkJCQkoc3RydWN0IGlvbW11X25lc3Rpbmdf
aW5mbyAqKWRhdGE7DQo+IA0KPiBkb24ndCB5b3UgbmVlZCB0byBob2xkIGEgZGV2aWNlX2RvbWFp
bl9sb2NrIGVhcmxpZXIgdG8gbWFrZSBzdXJlIGRvbWFpbg0KPiBhdHRyaWJ1dGVzIGNhbid0IGNo
YW5nZSBiZWhpbmQgeW91ciBiYWNrICh1bm1hbmFnZWQgdHlwZSBhbmQgbmVzdGVkIG1vZGUpPw0K
DQpkbyB5b3UgbWVhbiBhY3F1aXJlIGxvY2sgYXQgWzFdPw0KDQpSZWdhcmRzLA0KWWkgTGl1DQoN
Cj4gPiArDQo+ID4gKwkJcmV0dXJuIGludGVsX2lvbW11X2dldF9uZXN0aW5nX2luZm8oZG9tYWlu
LCBpbmZvKTsNCj4gPiArCX0NCj4gPiArCWRlZmF1bHQ6DQo+ID4gKwkJcmV0dXJuIC1FTk9FTlQ7
DQo+ID4gKwl9DQo+ID4gK30NCj4gPiArDQo+ID4gIC8qDQo+ID4gICAqIENoZWNrIHRoYXQgdGhl
IGRldmljZSBkb2VzIG5vdCBsaXZlIG9uIGFuIGV4dGVybmFsIGZhY2luZyBQQ0kgcG9ydCB0aGF0
IGlzDQo+ID4gICAqIG1hcmtlZCBhcyB1bnRydXN0ZWQuIFN1Y2ggZGV2aWNlcyBzaG91bGQgbm90
IGJlIGFibGUgdG8gYXBwbHkgcXVpcmtzIGFuZA0KPiA+IEBAIC02MTAzLDYgKzYxNzksNyBAQCBj
b25zdCBzdHJ1Y3QgaW9tbXVfb3BzIGludGVsX2lvbW11X29wcyA9IHsNCj4gPiAgCS5kb21haW5f
YWxsb2MJCT0gaW50ZWxfaW9tbXVfZG9tYWluX2FsbG9jLA0KPiA+ICAJLmRvbWFpbl9mcmVlCQk9
IGludGVsX2lvbW11X2RvbWFpbl9mcmVlLA0KPiA+ICAJLmRvbWFpbl9zZXRfYXR0cgk9IGludGVs
X2lvbW11X2RvbWFpbl9zZXRfYXR0ciwNCj4gPiArCS5kb21haW5fZ2V0X2F0dHIJPSBpbnRlbF9p
b21tdV9kb21haW5fZ2V0X2F0dHIsDQo+ID4gIAkuYXR0YWNoX2RldgkJPSBpbnRlbF9pb21tdV9h
dHRhY2hfZGV2aWNlLA0KPiA+ICAJLmRldGFjaF9kZXYJCT0gaW50ZWxfaW9tbXVfZGV0YWNoX2Rl
dmljZSwNCj4gPiAgCS5hdXhfYXR0YWNoX2RldgkJPSBpbnRlbF9pb21tdV9hdXhfYXR0YWNoX2Rl
dmljZSwNCj4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9pbnRlbC1pb21tdS5oIGIvaW5j
bHVkZS9saW51eC9pbnRlbC1pb21tdS5oDQo+ID4gaW5kZXggZjk4MTQ2Yi4uNWFjZjc5NSAxMDA2
NDQNCj4gPiAtLS0gYS9pbmNsdWRlL2xpbnV4L2ludGVsLWlvbW11LmgNCj4gPiArKysgYi9pbmNs
dWRlL2xpbnV4L2ludGVsLWlvbW11LmgNCj4gPiBAQCAtMTk3LDYgKzE5NywyMiBAQA0KPiA+ICAj
ZGVmaW5lIGVjYXBfbWF4X2hhbmRsZV9tYXNrKGUpICgoZSA+PiAyMCkgJiAweGYpDQo+ID4gICNk
ZWZpbmUgZWNhcF9zY19zdXBwb3J0KGUpCSgoZSA+PiA3KSAmIDB4MSkgLyogU25vb3BpbmcgQ29u
dHJvbCAqLw0KPiA+DQo+ID4gKy8qIE5lc3RpbmcgU3VwcG9ydCBDYXBhYmlsaXR5IEFsaWdubWVu
dCAqLw0KPiA+ICsjZGVmaW5lIFZURF9DQVBfRkwxR1AJCUJJVF9VTEwoNTYpDQo+ID4gKyNkZWZp
bmUgVlREX0NBUF9GTDVMUAkJQklUX1VMTCg2MCkNCj4gPiArI2RlZmluZSBWVERfRUNBUF9QUlMJ
CUJJVF9VTEwoMjkpDQo+ID4gKyNkZWZpbmUgVlREX0VDQVBfRVJTCQlCSVRfVUxMKDMwKQ0KPiA+
ICsjZGVmaW5lIFZURF9FQ0FQX1NSUwkJQklUX1VMTCgzMSkNCj4gPiArI2RlZmluZSBWVERfRUNB
UF9FQUZTCQlCSVRfVUxMKDM0KQ0KPiA+ICsjZGVmaW5lIFZURF9FQ0FQX1BBU0lECQlCSVRfVUxM
KDQwKQ0KPiA+ICsNCj4gPiArLyogT25seSBjYXBhYmlsaXRpZXMgbWFya2VkIGluIGJlbG93IE1B
U0tzIGFyZSByZXBvcnRlZCAqLw0KPiA+ICsjZGVmaW5lIFZURF9DQVBfTUFTSwkJKFZURF9DQVBf
RkwxR1AgfCBWVERfQ0FQX0ZMNUxQKQ0KPiA+ICsNCj4gPiArI2RlZmluZSBWVERfRUNBUF9NQVNL
CQkoVlREX0VDQVBfUFJTIHwgVlREX0VDQVBfRVJTIHwgXA0KPiA+ICsJCQkJIFZURF9FQ0FQX1NS
UyB8IFZURF9FQ0FQX0VBRlMgfCBcDQo+ID4gKwkJCQkgVlREX0VDQVBfUEFTSUQpDQo+ID4gKw0K
PiA+ICAvKiBWaXJ0dWFsIGNvbW1hbmQgaW50ZXJmYWNlIGNhcGFiaWxpdHkgKi8NCj4gPiAgI2Rl
ZmluZSB2Y2NhcF9wYXNpZCh2KQkJKCgodikgJiBETUFfVkNTX1BBUykpIC8qIFBBU0lEIGFsbG9j
YXRpb24NCj4gKi8NCj4gPg0KPiA+DQo+IFRoYW5rcw0KPiANCj4gRXJpYw0KDQo=
