Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36FB9245E4A
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 09:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgHQHqV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 03:46:21 -0400
Received: from mga17.intel.com ([192.55.52.151]:2632 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbgHQHqM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 03:46:12 -0400
IronPort-SDR: ups9GaQktolPpu9H6afkayVzMhC8FVjYyU1a4o4cg2HinoX6OP3AjFE9XtZ2+aa4QO2OSub2Y8
 bGnxWtrwTdqA==
X-IronPort-AV: E=McAfee;i="6000,8403,9715"; a="134712178"
X-IronPort-AV: E=Sophos;i="5.76,322,1592895600"; 
   d="scan'208";a="134712178"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2020 00:45:09 -0700
IronPort-SDR: 03tOiTjvFJ/T/TvwT0OpsQzkUpYplUlasHq9gOFnnzSArDT7WkKhb4LGfIn2wsKapjpwN3np4v
 UEaMIORluHkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,322,1592895600"; 
   d="scan'208";a="319626635"
Received: from orsmsx601-2.jf.intel.com (HELO ORSMSX601.amr.corp.intel.com) ([10.22.229.81])
  by fmsmga004.fm.intel.com with ESMTP; 17 Aug 2020 00:45:08 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 17 Aug 2020 00:45:07 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 17 Aug 2020 00:45:07 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 17 Aug 2020 00:45:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lAckd4QlQrVgU1Iq0/SvMPF/ABh2GoWigpl5QuoizfCuadPidI9zwz1SfyBg0ZqFaz5UTzq4ZAjNyATxYifZmEA7oeO0pFMm5p25CNjifpV3SS4/1+p3dYA/6nd+Mk8NLd7FLkNO2bbrxNl+SrOWJASUhffyYSHYc2zMybzngwN24SMZGuG+DEr4I6LDi0dRy2IiYw4biFglin64U6CfimUvNvcvKP1OQXN1oUqNVMmJAjBobLzZvfcTfKbqZ7f8jtJLrEyILZBSGaN6NTwBKMRtInqn0s1lHFky/kkuq5INedZJJFLS+ZzDUVCb6LRWTGt38GzbQ0sBB59BiJDAnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kdxA4Y2I/aXpPWkY+QYfLqSO+k9CkQz3Pxg54Ct9Cz4=;
 b=WeW+4389gIFGCJ34lxLHB7jb58zhvwhOGeLBqUFOynyXGSft6hvsPUu5SYatFX7nxm6bbDgSoIlYyYmmwlQJv182+9VGn6ZrRN9w7TR3rgWplt8a8mW3n0vb0V8DKdAL55DbQLvVpAwzd18cIkyxE+R3zXgZGTRE3ka+GgKWEEq/x0QCnj1RJGBQrq85tBUhvW09QTB2SX/ZU5C9mnmk7cJsBxRWFUq9wlRYOsa4vU6d3pimL9XLEcqusCGgaTBHSvBhYQSygdLjdaZ8GjkOL+MgmlskIdHclRBaCU+ta7Jp786NWlW3V1fadPJT5b4ZNLZ5VzcOOUxLIEOIJR3ncA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kdxA4Y2I/aXpPWkY+QYfLqSO+k9CkQz3Pxg54Ct9Cz4=;
 b=pu7VuQtmufPTxH0BFf6SEvMwRnfVT5tvIVlsNLsVq1s+tLA0risFgT2t+z1/SgSeCwrvp0ksShUkmR+Rxuvoc8Oreuj2QEa2yT+iweQPh/bxqPQvuxajQRlPw8dBKYGM1nm0Iu0PImOCrpAkXuS9AXLFmd4V9VhO4amNKt4TM4A=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM5PR11MB1434.namprd11.prod.outlook.com (2603:10b6:4:9::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3283.23; Mon, 17 Aug 2020 07:45:04 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3283.027; Mon, 17 Aug
 2020 07:45:04 +0000
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
Thread-Index: AQHWZKdN2jQ/iA01+E66P0YDXHPJ1qk6wIWAgAE+lvCAAAuigIAAAGfQ
Date:   Mon, 17 Aug 2020 07:45:04 +0000
Message-ID: <DM5PR11MB14352387C6990D0DF03B068DC35F0@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1595917664-33276-1-git-send-email-yi.l.liu@intel.com>
 <1595917664-33276-16-git-send-email-yi.l.liu@intel.com>
 <7fe337fa-abbc-82be-c8e8-b9e2a6179b90@redhat.com>
 <DM5PR11MB14351B5746A8A09E2EBCBEBDC35F0@DM5PR11MB1435.namprd11.prod.outlook.com>
 <83376141-8357-8100-54f5-2ccbf2e09090@redhat.com>
In-Reply-To: <83376141-8357-8100-54f5-2ccbf2e09090@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.46.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f3df9c4f-ce91-463d-96d7-08d842817492
x-ms-traffictypediagnostic: DM5PR11MB1434:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB1434B75C5281542ABEF6FD19C35F0@DM5PR11MB1434.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qngRo31bFxWcTl2vuXNCWLqg2saoWuSPSfYg92dyti977Tpc9l1kCbdf7AbpuG9JH/9LgV8BuzClLXfRzz1Cgt4/SOqsV7l14HfurTrzeZA6G8QG+WvzoviMfhOxK4Ez3H5dLxwLnytf9CtuicTS14PR5QYRFhH5dXUB7RswUpz6lSIMgngyrTAsHxcybvA/xArirPyMNq3riEhqx/wwlJ6Rr2oa8VyN7+grtd3+61yWMzWFvW75qc8oixQiq1N/gKkuU6LiGJ84YS1o5aViKY8bbwQ6mK2YW035QFW/z3nRhElaJGxZQ7170nPChtqWiT6YjCA9wTCEm3Ge72+4+w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(346002)(376002)(136003)(396003)(66476007)(64756008)(66446008)(8676002)(83380400001)(86362001)(316002)(110136005)(6636002)(54906003)(66556008)(52536014)(76116006)(66946007)(53546011)(9686003)(55016002)(7416002)(5660300002)(71200400001)(26005)(186003)(2906002)(8936002)(4326008)(33656002)(7696005)(478600001)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: UxMxfxq+tWvTbIvYiM5zyMcpLRH95nluZF0acefWElyMEk2oTSmE3qVCKivd1zntQJk8nrqP+AOGXx7J5TItTaNtLH6mwngtsf9IC2HBFN2zE19gll4/lZnTsHIZGKa3yObdnSe0eya2co6+PrxgfQOLdKLozqK9ls2bSwUOIjp6Eto+6/16azT73EexhLugEV9UeCeH5KW0v+/2y6aXYAa17suxbS5f84YOEf5uP5ziqdWzfs8IrwupghK/sRxo4REC+QrJmGRZJKleEYeICvspH6T1jmNBbQWw9c8uidz66dMTrGyu4qjedtyY1OOfnbNlHleGIkt2P8ghjD+JUANOY7x8mOUzbYTeJ9v4A/wBF7B7iqivbsofb/9JDF+6ricZdLIGdaYUrMNphc6AQ8a+Yeq17diksTJ5iVhpyCZkpy8zM5r5koHcstWfXbkhFjThjnvUSVsLTMe4DF7+tkC+Fs+Vj7gyi22XnV697KFc/qdn4mvwiKthoLaJk3VW3SDMPqsCVKQljMT3PCexCj5yWUC/EG48yAlM8scglpwkd48LGWlJxudb0BUe5fTlrS7epgsQXNoqmMzlhVNQBw08PsR2at9YGlJRNXTqAMy1n2qb1C8RPRB0zdLCjssQF0ZYvb6drpiOUcFWbTr2/w==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3df9c4f-ce91-463d-96d7-08d842817492
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2020 07:45:04.5014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yYecwWa3j9m05fYVfcKSpzFBtfqeB8OudU2tz309y9u1iawMsQ18C+9a95e2b4Ar3r8HNsSOtAa5RBJcfKpodQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1434
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RXJpYywNCg0KPiBGcm9tOiBBdWdlciBFcmljIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+IFNl
bnQ6IE1vbmRheSwgQXVndXN0IDE3LCAyMDIwIDM6NDMgUE0NCj4gDQo+IE9uIDgvMTcvMjAgOTow
NSBBTSwgTGl1LCBZaSBMIHdyb3RlOg0KPiA+IEhpIEVyaWMsDQo+ID4NCj4gPj4gQXVnZXIgRXJp
YyA8ZXJpYy5hdWdlckByZWRoYXQuY29tPg0KPiA+PiBTZW50OiBTdW5kYXksIEF1Z3VzdCAxNiwg
MjAyMCA4OjAxIFBNDQo+ID4+DQo+ID4+IEhpIFlpLA0KPiA+Pg0KPiA+PiBPbiA3LzI4LzIwIDg6
MjcgQU0sIExpdSBZaSBMIHdyb3RlOg0KPiA+Pj4gVGhpcyBwYXRjaCByZXBvcnRzIG5lc3Rpbmcg
aW5mbywgYW5kIG9ubHkgc3VwcG9ydHMgdGhlIGNhc2Ugd2hlcmUgYWxsDQo+ID4+PiB0aGUgcGh5
c2ljYWwgaW9tbXMgaGF2ZSB0aGUgc2FtZSBDQVAvRUNBUCBNQVNLUy4NCj4gPj4gcy9pb21tcy9p
b21tdXMNCj4gPg0KPiA+IHllcC4NCj4gPg0KPiA+Pj4NCj4gPj4+IENjOiBLZXZpbiBUaWFuIDxr
ZXZpbi50aWFuQGludGVsLmNvbT4NCj4gPj4+IENDOiBKYWNvYiBQYW4gPGphY29iLmp1bi5wYW5A
bGludXguaW50ZWwuY29tPg0KPiA+Pj4gQ2M6IEFsZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFt
c29uQHJlZGhhdC5jb20+DQo+ID4+PiBDYzogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQu
Y29tPg0KPiA+Pj4gQ2M6IEplYW4tUGhpbGlwcGUgQnJ1Y2tlciA8amVhbi1waGlsaXBwZUBsaW5h
cm8ub3JnPg0KPiA+Pj4gQ2M6IEpvZXJnIFJvZWRlbCA8am9yb0A4Ynl0ZXMub3JnPg0KPiA+Pj4g
Q2M6IEx1IEJhb2x1IDxiYW9sdS5sdUBsaW51eC5pbnRlbC5jb20+DQo+ID4+PiBTaWduZWQtb2Zm
LWJ5OiBMaXUgWWkgTCA8eWkubC5saXVAaW50ZWwuY29tPg0KPiA+Pj4gU2lnbmVkLW9mZi1ieTog
SmFjb2IgUGFuIDxqYWNvYi5qdW4ucGFuQGxpbnV4LmludGVsLmNvbT4NCj4gPj4+IC0tLQ0KPiA+
Pj4gdjIgLT4gdjM6DQo+ID4+PiAqKSByZW1vdmUgY2FwL2VjYXBfbWFzayBpbiBpb21tdV9uZXN0
aW5nX2luZm8uDQo+ID4+PiAtLS0NCj4gPj4+ICBkcml2ZXJzL2lvbW11L2ludGVsL2lvbW11LmMg
fCA4MQ0KPiA+PiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0N
Cj4gPj4+ICBpbmNsdWRlL2xpbnV4L2ludGVsLWlvbW11LmggfCAxNiArKysrKysrKysNCj4gPj4+
ICAyIGZpbGVzIGNoYW5nZWQsIDk1IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+ID4+
Pg0KPiA+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW9tbXUvaW50ZWwvaW9tbXUuYyBiL2RyaXZl
cnMvaW9tbXUvaW50ZWwvaW9tbXUuYw0KPiA+Pj4gaW5kZXggODhmNDY0Ny4uMDgzNTgwNCAxMDA2
NDQNCj4gPj4+IC0tLSBhL2RyaXZlcnMvaW9tbXUvaW50ZWwvaW9tbXUuYw0KPiA+Pj4gKysrIGIv
ZHJpdmVycy9pb21tdS9pbnRlbC9pb21tdS5jDQo+ID4+PiBAQCAtNTY2MCwxMiArNTY2MCwxNiBA
QCBzdGF0aWMgaW5saW5lIGJvb2wgaW9tbXVfcGFzaWRfc3VwcG9ydCh2b2lkKQ0KPiA+Pj4gIHN0
YXRpYyBpbmxpbmUgYm9vbCBuZXN0ZWRfbW9kZV9zdXBwb3J0KHZvaWQpDQo+ID4+PiAgew0KPiA+
Pj4gIAlzdHJ1Y3QgZG1hcl9kcmhkX3VuaXQgKmRyaGQ7DQo+ID4+PiAtCXN0cnVjdCBpbnRlbF9p
b21tdSAqaW9tbXU7DQo+ID4+PiArCXN0cnVjdCBpbnRlbF9pb21tdSAqaW9tbXUsICpwcmV2ID0g
TlVMTDsNCj4gPj4+ICAJYm9vbCByZXQgPSB0cnVlOw0KPiA+Pj4NCj4gPj4+ICAJcmN1X3JlYWRf
bG9jaygpOw0KPiA+Pj4gIAlmb3JfZWFjaF9hY3RpdmVfaW9tbXUoaW9tbXUsIGRyaGQpIHsNCj4g
Pj4+IC0JCWlmICghc21fc3VwcG9ydGVkKGlvbW11KSB8fCAhZWNhcF9uZXN0KGlvbW11LT5lY2Fw
KSkgew0KPiA+Pj4gKwkJaWYgKCFwcmV2KQ0KPiA+Pj4gKwkJCXByZXYgPSBpb21tdTsNCj4gPj4+
ICsJCWlmICghc21fc3VwcG9ydGVkKGlvbW11KSB8fCAhZWNhcF9uZXN0KGlvbW11LT5lY2FwKSB8
fA0KPiA+Pj4gKwkJICAgIChWVERfQ0FQX01BU0sgJiAoaW9tbXUtPmNhcCBeIHByZXYtPmNhcCkp
IHx8DQo+ID4+PiArCQkgICAgKFZURF9FQ0FQX01BU0sgJiAoaW9tbXUtPmVjYXAgXiBwcmV2LT5l
Y2FwKSkpIHsNCj4gPj4+ICAJCQlyZXQgPSBmYWxzZTsNCj4gPj4+ICAJCQlicmVhazsNCj4gPj4g
U28gdGhpcyBjaGFuZ2VzIHRoZSBiZWhhdmlvciBvZiBET01BSU5fQVRUUl9ORVNUSU5HLiBTaG91
bGRuJ3QgaXQgaGF2ZSBhDQo+ID4+IEZpeGVzIHRhZyBhcyB3ZWxsPyBBbmQgbWF5YmUgYWRkIHRo
ZSBjYXBhYmlsaXR5IGdldHRlciBpbiBhIHNlcGFyYXRlIHBhdGNoPw0KPiA+DQo+ID4geWVzLCB0
aGlzIGNoYW5nZWQgdGhlIGJlaGF2aW9yLiBzbyBpdCB3b3VsZCBiZSBiZXR0ZXIgdG8gYmUgYSBz
ZXBhcmF0ZSBwYXRjaA0KPiA+IGFuZCB1cHN0cmVhbSBhbG9uZz8gaG93IGFib3V0IHlvdXIgaWRl
YT8gQEx1LCBCYW9sdSA6LSkNCj4gPg0KPiA+Pj4gIAkJfQ0KPiA+Pj4gQEAgLTYwODEsNiArNjA4
NSw3OCBAQCBpbnRlbF9pb21tdV9kb21haW5fc2V0X2F0dHIoc3RydWN0DQo+IGlvbW11X2RvbWFp
bg0KPiA+PiAqZG9tYWluLA0KPiA+Pj4gIAlyZXR1cm4gcmV0Ow0KPiA+Pj4gIH0NCj4gPj4+DQo+
ID4+PiArc3RhdGljIGludCBpbnRlbF9pb21tdV9nZXRfbmVzdGluZ19pbmZvKHN0cnVjdCBpb21t
dV9kb21haW4gKmRvbWFpbiwNCj4gPj4+ICsJCQkJCXN0cnVjdCBpb21tdV9uZXN0aW5nX2luZm8g
KmluZm8pDQo+ID4+PiArew0KPiA+Pj4gKwlzdHJ1Y3QgZG1hcl9kb21haW4gKmRtYXJfZG9tYWlu
ID0gdG9fZG1hcl9kb21haW4oZG9tYWluKTsNCj4gPj4+ICsJdTY0IGNhcCA9IFZURF9DQVBfTUFT
SywgZWNhcCA9IFZURF9FQ0FQX01BU0s7DQo+ID4+PiArCXN0cnVjdCBkZXZpY2VfZG9tYWluX2lu
Zm8gKmRvbWFpbl9pbmZvOw0KPiA+Pj4gKwlzdHJ1Y3QgaW9tbXVfbmVzdGluZ19pbmZvX3Z0ZCB2
dGQ7DQo+ID4+PiArCXVuc2lnbmVkIGxvbmcgZmxhZ3M7DQo+ID4+PiArCXVuc2lnbmVkIGludCBz
aXplOw0KPiA+Pj4gKw0KPiA+DQo+ID4gcGVyaGFwcyBiZXR0ZXIgdG8gYWNxdWlyZSB0aGUgbG9j
ayBoZXJlLiBbMV0NCj4gPg0KPiA+Pj4gKwlpZiAoZG9tYWluLT50eXBlICE9IElPTU1VX0RPTUFJ
Tl9VTk1BTkFHRUQgfHwNCj4gPj4+ICsJICAgICEoZG1hcl9kb21haW4tPmZsYWdzICYgRE9NQUlO
X0ZMQUdfTkVTVElOR19NT0RFKSkNCj4gPj4+ICsJCXJldHVybiAtRU5PREVWOw0KPiA+Pj4gKw0K
PiA+Pj4gKwlpZiAoIWluZm8pDQo+ID4+PiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gPj4+ICsNCj4g
Pj4+ICsJc2l6ZSA9IHNpemVvZihzdHJ1Y3QgaW9tbXVfbmVzdGluZ19pbmZvKSArDQo+ID4+PiAr
CQlzaXplb2Yoc3RydWN0IGlvbW11X25lc3RpbmdfaW5mb192dGQpOw0KPiA+Pj4gKwkvKg0KPiA+
Pj4gKwkgKiBpZiBwcm92aWRlZCBidWZmZXIgc2l6ZSBpcyBzbWFsbGVyIHRoYW4gZXhwZWN0ZWQs
IHNob3VsZA0KPiA+Pj4gKwkgKiByZXR1cm4gMCBhbmQgYWxzbyB0aGUgZXhwZWN0ZWQgYnVmZmVy
IHNpemUgdG8gY2FsbGVyLg0KPiA+Pj4gKwkgKi8NCj4gPj4+ICsJaWYgKGluZm8tPmFyZ3N6IDwg
c2l6ZSkgew0KPiA+Pj4gKwkJaW5mby0+YXJnc3ogPSBzaXplOw0KPiA+Pj4gKwkJcmV0dXJuIDA7
DQo+ID4+PiArCX0NCj4gPj4+ICsNCj4gPj4+ICsJc3Bpbl9sb2NrX2lycXNhdmUoJmRldmljZV9k
b21haW5fbG9jaywgZmxhZ3MpOw0KPiA+Pj4gKwkvKg0KPiA+Pj4gKwkgKiBhcmJpdHJhcnkgc2Vs
ZWN0IHRoZSBmaXJzdCBkb21haW5faW5mbyBhcyBhbGwgbmVzdGluZw0KPiA+Pj4gKwkgKiByZWxh
dGVkIGNhcGFiaWxpdGllcyBzaG91bGQgYmUgY29uc2lzdGVudCBhY3Jvc3MgaW9tbXUNCj4gPj4+
ICsJICogdW5pdHMuDQo+ID4+PiArCSAqLw0KPiA+Pj4gKwlkb21haW5faW5mbyA9IGxpc3RfZmly
c3RfZW50cnkoJmRtYXJfZG9tYWluLT5kZXZpY2VzLA0KPiA+Pj4gKwkJCQkgICAgICAgc3RydWN0
IGRldmljZV9kb21haW5faW5mbywgbGluayk7DQo+ID4+PiArCWNhcCAmPSBkb21haW5faW5mby0+
aW9tbXUtPmNhcDsNCj4gPj4+ICsJZWNhcCAmPSBkb21haW5faW5mby0+aW9tbXUtPmVjYXA7DQo+
ID4+PiArCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmRldmljZV9kb21haW5fbG9jaywgZmxhZ3Mp
Ow0KPiA+Pj4gKw0KPiA+Pj4gKwlpbmZvLT5mb3JtYXQgPSBJT01NVV9QQVNJRF9GT1JNQVRfSU5U
RUxfVlREOw0KPiA+Pj4gKwlpbmZvLT5mZWF0dXJlcyA9IElPTU1VX05FU1RJTkdfRkVBVF9TWVNX
SURFX1BBU0lEIHwNCj4gPj4+ICsJCQkgSU9NTVVfTkVTVElOR19GRUFUX0JJTkRfUEdUQkwgfA0K
PiA+Pj4gKwkJCSBJT01NVV9ORVNUSU5HX0ZFQVRfQ0FDSEVfSU5WTEQ7DQo+ID4+PiArCWluZm8t
PmFkZHJfd2lkdGggPSBkbWFyX2RvbWFpbi0+Z2F3Ow0KPiA+Pj4gKwlpbmZvLT5wYXNpZF9iaXRz
ID0gaWxvZzIoaW50ZWxfcGFzaWRfbWF4X2lkKTsNCj4gPj4+ICsJaW5mby0+cGFkZGluZyA9IDA7
DQo+ID4+PiArCXZ0ZC5mbGFncyA9IDA7DQo+ID4+PiArCXZ0ZC5wYWRkaW5nID0gMDsNCj4gPj4+
ICsJdnRkLmNhcF9yZWcgPSBjYXA7DQo+ID4+PiArCXZ0ZC5lY2FwX3JlZyA9IGVjYXA7DQo+ID4+
PiArDQo+ID4+PiArCW1lbWNweShpbmZvLT5kYXRhLCAmdnRkLCBzaXplb2YodnRkKSk7DQo+ID4+
PiArCXJldHVybiAwOw0KPiA+Pj4gK30NCj4gPj4+ICsNCj4gPj4+ICtzdGF0aWMgaW50IGludGVs
X2lvbW11X2RvbWFpbl9nZXRfYXR0cihzdHJ1Y3QgaW9tbXVfZG9tYWluICpkb21haW4sDQo+ID4+
PiArCQkJCSAgICAgICBlbnVtIGlvbW11X2F0dHIgYXR0ciwgdm9pZCAqZGF0YSkNCj4gPj4+ICt7
DQo+ID4+PiArCXN3aXRjaCAoYXR0cikgew0KPiA+Pj4gKwljYXNlIERPTUFJTl9BVFRSX05FU1RJ
Tkc6DQo+ID4+PiArCXsNCj4gPj4+ICsJCXN0cnVjdCBpb21tdV9uZXN0aW5nX2luZm8gKmluZm8g
PQ0KPiA+Pj4gKwkJCQkoc3RydWN0IGlvbW11X25lc3RpbmdfaW5mbyAqKWRhdGE7DQo+ID4+DQo+
ID4+IGRvbid0IHlvdSBuZWVkIHRvIGhvbGQgYSBkZXZpY2VfZG9tYWluX2xvY2sgZWFybGllciB0
byBtYWtlIHN1cmUgZG9tYWluDQo+ID4+IGF0dHJpYnV0ZXMgY2FuJ3QgY2hhbmdlIGJlaGluZCB5
b3VyIGJhY2sgKHVubWFuYWdlZCB0eXBlIGFuZCBuZXN0ZWQgbW9kZSk/DQo+ID4NCj4gPiBkbyB5
b3UgbWVhbiBhY3F1aXJlIGxvY2sgYXQgWzFdPw0KPiB5ZXAgZWl0aGVyIGF0IFsxXSBvciBiZWZv
cmUgY2FsbGluZyBpbnRlbF9pb21tdV9nZXRfbmVzdGluZ19pbmZvIGFuZA0KPiBhZGRpbmcgYSBj
b21tZW50IHNheWluZyBpbnRlbF9pb21tdV9nZXRfbmVzdGluZ19pbmZvKCkgc2hhbGwgYmUgY2Fs
bGVkDQo+IHdpdGggdGhlIGxvY2sgaGVsZA0KDQp3aWxsIGRvLiA6LSkNCg0KUmVnYXJkcywNCllp
IExpdQ0KDQo+IFRoYW5rcw0KPiANCj4gRXJpYw0KPiA+DQo+ID4gUmVnYXJkcywNCj4gPiBZaSBM
aXUNCj4gPg0KPiA+Pj4gKw0KPiA+Pj4gKwkJcmV0dXJuIGludGVsX2lvbW11X2dldF9uZXN0aW5n
X2luZm8oZG9tYWluLCBpbmZvKTsNCj4gPj4+ICsJfQ0KPiA+Pj4gKwlkZWZhdWx0Og0KPiA+Pj4g
KwkJcmV0dXJuIC1FTk9FTlQ7DQo+ID4+PiArCX0NCj4gPj4+ICt9DQo+ID4+PiArDQo+ID4+PiAg
LyoNCj4gPj4+ICAgKiBDaGVjayB0aGF0IHRoZSBkZXZpY2UgZG9lcyBub3QgbGl2ZSBvbiBhbiBl
eHRlcm5hbCBmYWNpbmcgUENJIHBvcnQgdGhhdCBpcw0KPiA+Pj4gICAqIG1hcmtlZCBhcyB1bnRy
dXN0ZWQuIFN1Y2ggZGV2aWNlcyBzaG91bGQgbm90IGJlIGFibGUgdG8gYXBwbHkgcXVpcmtzIGFu
ZA0KPiA+Pj4gQEAgLTYxMDMsNiArNjE3OSw3IEBAIGNvbnN0IHN0cnVjdCBpb21tdV9vcHMgaW50
ZWxfaW9tbXVfb3BzID0gew0KPiA+Pj4gIAkuZG9tYWluX2FsbG9jCQk9IGludGVsX2lvbW11X2Rv
bWFpbl9hbGxvYywNCj4gPj4+ICAJLmRvbWFpbl9mcmVlCQk9IGludGVsX2lvbW11X2RvbWFpbl9m
cmVlLA0KPiA+Pj4gIAkuZG9tYWluX3NldF9hdHRyCT0gaW50ZWxfaW9tbXVfZG9tYWluX3NldF9h
dHRyLA0KPiA+Pj4gKwkuZG9tYWluX2dldF9hdHRyCT0gaW50ZWxfaW9tbXVfZG9tYWluX2dldF9h
dHRyLA0KPiA+Pj4gIAkuYXR0YWNoX2RldgkJPSBpbnRlbF9pb21tdV9hdHRhY2hfZGV2aWNlLA0K
PiA+Pj4gIAkuZGV0YWNoX2RldgkJPSBpbnRlbF9pb21tdV9kZXRhY2hfZGV2aWNlLA0KPiA+Pj4g
IAkuYXV4X2F0dGFjaF9kZXYJCT0gaW50ZWxfaW9tbXVfYXV4X2F0dGFjaF9kZXZpY2UsDQo+ID4+
PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9pbnRlbC1pb21tdS5oIGIvaW5jbHVkZS9saW51
eC9pbnRlbC1pb21tdS5oDQo+ID4+PiBpbmRleCBmOTgxNDZiLi41YWNmNzk1IDEwMDY0NA0KPiA+
Pj4gLS0tIGEvaW5jbHVkZS9saW51eC9pbnRlbC1pb21tdS5oDQo+ID4+PiArKysgYi9pbmNsdWRl
L2xpbnV4L2ludGVsLWlvbW11LmgNCj4gPj4+IEBAIC0xOTcsNiArMTk3LDIyIEBADQo+ID4+PiAg
I2RlZmluZSBlY2FwX21heF9oYW5kbGVfbWFzayhlKSAoKGUgPj4gMjApICYgMHhmKQ0KPiA+Pj4g
ICNkZWZpbmUgZWNhcF9zY19zdXBwb3J0KGUpCSgoZSA+PiA3KSAmIDB4MSkgLyogU25vb3Bpbmcg
Q29udHJvbCAqLw0KPiA+Pj4NCj4gPj4+ICsvKiBOZXN0aW5nIFN1cHBvcnQgQ2FwYWJpbGl0eSBB
bGlnbm1lbnQgKi8NCj4gPj4+ICsjZGVmaW5lIFZURF9DQVBfRkwxR1AJCUJJVF9VTEwoNTYpDQo+
ID4+PiArI2RlZmluZSBWVERfQ0FQX0ZMNUxQCQlCSVRfVUxMKDYwKQ0KPiA+Pj4gKyNkZWZpbmUg
VlREX0VDQVBfUFJTCQlCSVRfVUxMKDI5KQ0KPiA+Pj4gKyNkZWZpbmUgVlREX0VDQVBfRVJTCQlC
SVRfVUxMKDMwKQ0KPiA+Pj4gKyNkZWZpbmUgVlREX0VDQVBfU1JTCQlCSVRfVUxMKDMxKQ0KPiA+
Pj4gKyNkZWZpbmUgVlREX0VDQVBfRUFGUwkJQklUX1VMTCgzNCkNCj4gPj4+ICsjZGVmaW5lIFZU
RF9FQ0FQX1BBU0lECQlCSVRfVUxMKDQwKQ0KPiA+Pj4gKw0KPiA+Pj4gKy8qIE9ubHkgY2FwYWJp
bGl0aWVzIG1hcmtlZCBpbiBiZWxvdyBNQVNLcyBhcmUgcmVwb3J0ZWQgKi8NCj4gPj4+ICsjZGVm
aW5lIFZURF9DQVBfTUFTSwkJKFZURF9DQVBfRkwxR1AgfCBWVERfQ0FQX0ZMNUxQKQ0KPiA+Pj4g
Kw0KPiA+Pj4gKyNkZWZpbmUgVlREX0VDQVBfTUFTSwkJKFZURF9FQ0FQX1BSUyB8IFZURF9FQ0FQ
X0VSUyB8IFwNCj4gPj4+ICsJCQkJIFZURF9FQ0FQX1NSUyB8IFZURF9FQ0FQX0VBRlMgfCBcDQo+
ID4+PiArCQkJCSBWVERfRUNBUF9QQVNJRCkNCj4gPj4+ICsNCj4gPj4+ICAvKiBWaXJ0dWFsIGNv
bW1hbmQgaW50ZXJmYWNlIGNhcGFiaWxpdHkgKi8NCj4gPj4+ICAjZGVmaW5lIHZjY2FwX3Bhc2lk
KHYpCQkoKCh2KSAmIERNQV9WQ1NfUEFTKSkgLyogUEFTSUQgYWxsb2NhdGlvbg0KPiA+PiAqLw0K
PiA+Pj4NCj4gPj4+DQo+ID4+IFRoYW5rcw0KPiA+Pg0KPiA+PiBFcmljDQo+ID4NCg0K
