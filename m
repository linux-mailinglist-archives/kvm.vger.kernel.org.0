Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4E4225ADB
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 11:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgGTJGy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 05:06:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:48191 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727862AbgGTJGv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jul 2020 05:06:51 -0400
IronPort-SDR: lp3OTVbpcctY0ViuNKVFGO7p2FCmKJwcn2YQZCGakpqJXTY8V0tauJEq5JAE5QwP89aSAZUXj8
 zTjPI2oIqKXA==
X-IronPort-AV: E=McAfee;i="6000,8403,9687"; a="168007382"
X-IronPort-AV: E=Sophos;i="5.75,374,1589266800"; 
   d="scan'208";a="168007382"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2020 02:06:48 -0700
IronPort-SDR: e4E+b+2+mpO1Vuzu5qo0xyBI/wNpx3cDTkN5hB4n7AoNS8MIkLujmog84UrbS5N8+grr9JDuYV
 EoFyhwKob4rg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,374,1589266800"; 
   d="scan'208";a="301213268"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga002.jf.intel.com with ESMTP; 20 Jul 2020 02:06:47 -0700
Received: from fmsmsx156.amr.corp.intel.com (10.18.116.74) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 20 Jul 2020 02:06:47 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx156.amr.corp.intel.com (10.18.116.74) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 20 Jul 2020 02:06:46 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 20 Jul 2020 02:06:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f3fWtnLKzx7aqkFP6l2qk7Elv5tJ9cx+nVQxye4y88HTUnNyLHk78hPBkrn+RUkF4NyOQy1mc1pu8EJNaaBp0BcRa3HbFC/tEIUUxyV0zuG4QF+u3xsHglGbnN1NsLoAc8jtJXBqdCjWwHIeuLdPVO2BrObGTT5sOjcij0V8NgWcNUJi22+mcAvY+N3CIFr6aP3uBObx4N7lhkq+p46vgRzXyxSFzhu+OIuvd4i3/HF4EZQHUFmnXCA9O7/uys/zaTFU+Y6q86D3D1dYjj7AR0uGGLghtW7uprZw5Sur52RTlcVFS+PcsKi8uPtSICcqheYLdbonQ0I0pjhLSRF62Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VG5BSyW10Gpyzyqk/OpSNZMZ834H833RpY7ODfXUB1Y=;
 b=InkRoPexDv2q2v5zuc5cDJ0lsBrRxJyV0+sppVR5X7zKP9nXo77K4SSEbfNXq+OgCDjJtx3gNsm88FmLBMcWotSEvptO0lGFek6kyRMrnBc2fQn+DrkmM9tSlD5gGSTvOsy8wMc1j2PeQDqRyYLQZBmoLeVGvxONh0l5aeCjs6aZxo/F2s+fXiUZhQSrbCQ6JBFfDXkOjUrk/ok3azABUjtICK8VyxFdJtdyx17jgp7tyuDoBZWvbIGC/YXRWuev//yubCftYMHyUi/erM/LQw2/oLLdys/DQERQ1TRTFNbWUNFQjZWVGAWl7BTqJnJ2R0VkDEdEX3VvHoQN8f2JLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VG5BSyW10Gpyzyqk/OpSNZMZ834H833RpY7ODfXUB1Y=;
 b=C2SYJyUNMLGCZ/bXx5gxQJSUNXgFHmNhP5jdyNdsMVXFgTTFYfgAtK3trIm/YEI1dAnzYL8+EHzkoN2d1v3/9C0Qkm4/rOf9QoG1gpDQhSFW/ysLyNp8zWbmtjY5XNXqFR9cEVMl+pCxcgSV2TNJ1SW5lecn8uX86El0KbkVkqI=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM5PR11MB1673.namprd11.prod.outlook.com (2603:10b6:4:c::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3195.25; Mon, 20 Jul 2020 09:06:43 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3195.025; Mon, 20 Jul
 2020 09:06:43 +0000
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
Subject: RE: [PATCH v5 08/15] iommu: Pass domain to sva_unbind_gpasid()
Thread-Topic: [PATCH v5 08/15] iommu: Pass domain to sva_unbind_gpasid()
Thread-Index: AQHWWD2wpTv8jD9LM0Op13LFQ21toKkPFKAAgAEiVAA=
Date:   Mon, 20 Jul 2020 09:06:43 +0000
Message-ID: <DM5PR11MB14351DE64D6D3184AF9282ECC37B0@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
 <1594552870-55687-9-git-send-email-yi.l.liu@intel.com>
 <27ac7880-bdd3-2891-139e-b4a7cd18420b@redhat.com>
In-Reply-To: <27ac7880-bdd3-2891-139e-b4a7cd18420b@redhat.com>
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
x-ms-office365-filtering-correlation-id: 811a8136-ae6c-4248-9737-08d82c8c3912
x-ms-traffictypediagnostic: DM5PR11MB1673:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB16735363CEF09107B4FDF51AC37B0@DM5PR11MB1673.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nrvWsD+3ippcGZenjpGWQnpKM6xST5kFTw+JUPYuTVoJI0dUEkz8xoFdvubaNmZ7Vz4/I5siL7E7QvMGuqKIIODdm3X2wnbK4OVr4cCWo+l1MatOpIthb2RbuhtNH8DuXJVzS9KF8aLlqbfYKocBjWxzdHJYhz8RuFRYDgqg41aUGr2BfESNffhaxs/2l/gx1vPgsecco0Zxvn+26mqtWPFoL5C26FDcvrj5oIMqLjJjEG1f8JgxjlUtYOwiAi/jVXeVJLyvquHsn3tf7N5JOI2gkfewMY8X5gfdH768hQkq+fhy1hFBpB6ZHQOZKNPSqtlRlmyU2wS7F0Ji+e9QLqIDejmN6mM85reh0GZVLwKlzm2MvnIlOWwgZsTpP2qufTn+cXpzysWyXa9PEOeeKA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(86362001)(52536014)(8936002)(186003)(966005)(2906002)(6506007)(5660300002)(53546011)(7696005)(478600001)(8676002)(26005)(66946007)(7416002)(83380400001)(66476007)(316002)(110136005)(76116006)(71200400001)(9686003)(55016002)(54906003)(33656002)(66446008)(64756008)(4326008)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: KKeQPYpZIkHINnGdZ2XIVpIUhAjwQhoIJwmZ+mftD1Yoqvjx15pI5u1ZBhcPc8IK3TuOMIOywr9HhPmurD7Ed+9V9UjOrP/OCtnlSVxdtoiG7ZmlN4ZcB0hGJIwRBI6DE/taovNkx4BRgRifd9bSVFJPduxKUQ9UW4h0zQTozVWgiLkF1GUKhD1o9MIaUToFFWoilWIZwSiDPr3mkWDtW5D/b2E0t+N4K732IhLJBaUreGbFWBNnDiDULXXjJQpa4WrsZgJ4k4uI7RNF0mBvtH6yXh1SWOeZiZHOAo5tohKwavI9LFABZ4+doTznIfhtWFrxy69NKPw6jXEgTfzRqCmC7jzU+6asjB340j5gLe75Jv3vQs3nx8rJatwRqNLTpLcjziAEMMYpgD7Xkrn33lFNtBDkDPjNpq9LJuIZu8hDpzmgw2bqwm92KB1xVC7AffL9U7X7PR8yyv4Wipgbly/c3n/0JPlbtteBjLKVkeViYomRA7F/rtHU+r+zKE1V
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 811a8136-ae6c-4248-9737-08d82c8c3912
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2020 09:06:43.5569
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fanzy1K7MFl7+sC6e5irp8kmuAGclqF6UnxfQyb4eAkgN+KRT+qZ/G33+TcWx8nVk4C7gby/cRL2InwN6tFXlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1673
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBBdWdlciBFcmljIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+
IFNlbnQ6IFN1bmRheSwgSnVseSAxOSwgMjAyMCAxMTozOCBQTQ0KPiANCj4gWWksDQo+IA0KPiBP
biA3LzEyLzIwIDE6MjEgUE0sIExpdSBZaSBMIHdyb3RlOg0KPiA+IEZyb206IFlpIFN1biA8eWku
eS5zdW5AaW50ZWwuY29tPg0KPiA+DQo+ID4gQ3VycmVudCBpbnRlcmZhY2UgaXMgZ29vZCBlbm91
Z2ggZm9yIFNWQSB2aXJ0dWFsaXphdGlvbiBvbiBhbiBhc3NpZ25lZA0KPiA+IHBoeXNpY2FsIFBD
SSBkZXZpY2UsIGJ1dCB3aGVuIGl0IGNvbWVzIHRvIG1lZGlhdGVkIGRldmljZXMsIGEgcGh5c2lj
YWwNCj4gPiBkZXZpY2UgbWF5IGF0dGFjaGVkIHdpdGggbXVsdGlwbGUgYXV4LWRvbWFpbnMuIEFs
c28sIGZvciBndWVzdCB1bmJpbmQsDQo+ID4gdGhlIFBBU0lEIHRvIGJlIHVuYmluZCBzaG91bGQg
YmUgYWxsb2NhdGVkIHRvIHRoZSBWTS4gVGhpcyBjaGVjaw0KPiA+IHJlcXVpcmVzIHRvIGtub3cg
dGhlIGlvYXNpZF9zZXQgd2hpY2ggaXMgYXNzb2NpYXRlZCB3aXRoIHRoZSBkb21haW4uDQo+ID4N
Cj4gPiBTbyB0aGlzIGludGVyZmFjZSBuZWVkcyB0byBwYXNzIGluIGRvbWFpbiBpbmZvLiBUaGVu
IHRoZSBpb21tdSBkcml2ZXINCj4gPiBpcyBhYmxlIHRvIGtub3cgd2hpY2ggZG9tYWluIHdpbGwg
YmUgdXNlZCBmb3IgdGhlIDJuZCBzdGFnZQ0KPiA+IHRyYW5zbGF0aW9uIG9mIHRoZSBuZXN0aW5n
IG1vZGUgYW5kIGFsc28gYmUgYWJsZSB0byBkbyBQQVNJRCBvd25lcnNoaXANCj4gPiBjaGVjay4g
VGhpcyBwYXRjaCBwYXNzZXMgQGRvbWFpbiBwZXIgdGhlIGFib3ZlIHJlYXNvbi4NCj4gPg0KPiA+
IENjOiBLZXZpbiBUaWFuIDxrZXZpbi50aWFuQGludGVsLmNvbT4NCj4gPiBDQzogSmFjb2IgUGFu
IDxqYWNvYi5qdW4ucGFuQGxpbnV4LmludGVsLmNvbT4NCj4gPiBDYzogQWxleCBXaWxsaWFtc29u
IDxhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbT4NCj4gPiBDYzogRXJpYyBBdWdlciA8ZXJpYy5h
dWdlckByZWRoYXQuY29tPg0KPiA+IENjOiBKZWFuLVBoaWxpcHBlIEJydWNrZXIgPGplYW4tcGhp
bGlwcGVAbGluYXJvLm9yZz4NCj4gPiBDYzogSm9lcmcgUm9lZGVsIDxqb3JvQDhieXRlcy5vcmc+
DQo+ID4gQ2M6IEx1IEJhb2x1IDxiYW9sdS5sdUBsaW51eC5pbnRlbC5jb20+DQo+ID4gU2lnbmVk
LW9mZi1ieTogWWkgU3VuIDx5aS55LnN1bkBpbnRlbC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTog
TGl1IFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gPiAtLS0NCj4gPiB2MiAtPiB2MzoNCj4g
PiAqKSBwYXNzIGluIGRvbWFpbiBpbmZvIG9ubHkNCj4gPiAqKSB1c2UgaW9hc2lkX3QgZm9yIHBh
c2lkIGluc3RlYWQgb2YgaW50IHR5cGUNCj4gPg0KPiA+IHYxIC0+IHYyOg0KPiA+ICopIGFkZGVk
IGluIHYyLg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL2lvbW11L2ludGVsL3N2bS5jICAgfCAzICsr
LQ0KPiA+ICBkcml2ZXJzL2lvbW11L2lvbW11LmMgICAgICAgfCAyICstDQo+ID4gIGluY2x1ZGUv
bGludXgvaW50ZWwtaW9tbXUuaCB8IDMgKystDQo+ID4gIGluY2x1ZGUvbGludXgvaW9tbXUuaCAg
ICAgICB8IDMgKystDQo+ID4gIDQgZmlsZXMgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCA0IGRl
bGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW9tbXUvaW50ZWwvc3Zt
LmMgYi9kcml2ZXJzL2lvbW11L2ludGVsL3N2bS5jDQo+ID4gaW5kZXggYjlhOWM1NS4uZDJjMGUx
YSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL2lvbW11L2ludGVsL3N2bS5jDQo+ID4gKysrIGIv
ZHJpdmVycy9pb21tdS9pbnRlbC9zdm0uYw0KPiA+IEBAIC00MzIsNyArNDMyLDggQEAgaW50IGlu
dGVsX3N2bV9iaW5kX2dwYXNpZChzdHJ1Y3QgaW9tbXVfZG9tYWluICpkb21haW4sDQo+IHN0cnVj
dCBkZXZpY2UgKmRldiwNCj4gPiAgCXJldHVybiByZXQ7DQo+ID4gIH0NCj4gPg0KPiA+IC1pbnQg
aW50ZWxfc3ZtX3VuYmluZF9ncGFzaWQoc3RydWN0IGRldmljZSAqZGV2LCBpbnQgcGFzaWQpDQo+
ID4gK2ludCBpbnRlbF9zdm1fdW5iaW5kX2dwYXNpZChzdHJ1Y3QgaW9tbXVfZG9tYWluICpkb21h
aW4sDQo+ID4gKwkJCSAgICBzdHJ1Y3QgZGV2aWNlICpkZXYsIGlvYXNpZF90IHBhc2lkKQ0KPiBp
bnQgLT4gaW9hc2lkX3QgcHJvdG8gY2hhbmdlIGlzIG5vdCBkZXNjcmliZWQgaW4gdGhlIGNvbW1p
dCBtZXNzYWdlLA0KDQpvb3BzLCB5ZXMuIGJ0dy4gSSBub3RpY2VkIHRoZXJlIGlzIGFub3RoZXIg
dGhyZWFkIHdoaWNoIGlzIGdvaW5nIHRvIHVzZQ0KdTMyIGZvciBwYXNpZC4gcGVyaGFwcyBJIG5l
ZWQgdG8gZHJvcCBzdWNoIGNoYW5nZS4NCg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgt
aW9tbXUvMTU5NDY4NDA4Ny02MTE4NC0yLWdpdC1zZW5kLWVtYWlsLWZlbmdodWEueXVAaW50ZWwu
Y29tLyNaMzBkcml2ZXJzOmlvbW11OmlvbW11LmMNCg0KPiA+ICB7DQo+ID4gIAlzdHJ1Y3QgaW50
ZWxfaW9tbXUgKmlvbW11ID0gaW50ZWxfc3ZtX2RldmljZV90b19pb21tdShkZXYpOw0KPiA+ICAJ
c3RydWN0IGludGVsX3N2bV9kZXYgKnNkZXY7DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW9t
bXUvaW9tbXUuYyBiL2RyaXZlcnMvaW9tbXUvaW9tbXUuYyBpbmRleA0KPiA+IDc5MTAyNDkuLmQz
ZTU1NGMgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9pb21tdS9pb21tdS5jDQo+ID4gKysrIGIv
ZHJpdmVycy9pb21tdS9pb21tdS5jDQo+ID4gQEAgLTIxNTEsNyArMjE1MSw3IEBAIGludCBfX2lv
bW11X3N2YV91bmJpbmRfZ3Bhc2lkKHN0cnVjdCBpb21tdV9kb21haW4NCj4gKmRvbWFpbiwgc3Ry
dWN0IGRldmljZSAqZGV2LA0KPiA+ICAJaWYgKHVubGlrZWx5KCFkb21haW4tPm9wcy0+c3ZhX3Vu
YmluZF9ncGFzaWQpKQ0KPiA+ICAJCXJldHVybiAtRU5PREVWOw0KPiA+DQo+ID4gLQlyZXR1cm4g
ZG9tYWluLT5vcHMtPnN2YV91bmJpbmRfZ3Bhc2lkKGRldiwgZGF0YS0+aHBhc2lkKTsNCj4gPiAr
CXJldHVybiBkb21haW4tPm9wcy0+c3ZhX3VuYmluZF9ncGFzaWQoZG9tYWluLCBkZXYsIGRhdGEt
PmhwYXNpZCk7DQo+ID4gIH0NCj4gPiAgRVhQT1JUX1NZTUJPTF9HUEwoX19pb21tdV9zdmFfdW5i
aW5kX2dwYXNpZCk7DQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9pbnRlbC1p
b21tdS5oIGIvaW5jbHVkZS9saW51eC9pbnRlbC1pb21tdS5oDQo+ID4gaW5kZXggMGQwYWIzMi4u
MThmMjkyZSAxMDA2NDQNCj4gPiAtLS0gYS9pbmNsdWRlL2xpbnV4L2ludGVsLWlvbW11LmgNCj4g
PiArKysgYi9pbmNsdWRlL2xpbnV4L2ludGVsLWlvbW11LmgNCj4gPiBAQCAtNzM4LDcgKzczOCw4
IEBAIGV4dGVybiBpbnQgaW50ZWxfc3ZtX2VuYWJsZV9wcnEoc3RydWN0IGludGVsX2lvbW11DQo+
ID4gKmlvbW11KTsgIGV4dGVybiBpbnQgaW50ZWxfc3ZtX2ZpbmlzaF9wcnEoc3RydWN0IGludGVs
X2lvbW11ICppb21tdSk7DQo+ID4gaW50IGludGVsX3N2bV9iaW5kX2dwYXNpZChzdHJ1Y3QgaW9t
bXVfZG9tYWluICpkb21haW4sIHN0cnVjdCBkZXZpY2UgKmRldiwNCj4gPiAgCQkJICBzdHJ1Y3Qg
aW9tbXVfZ3Bhc2lkX2JpbmRfZGF0YSAqZGF0YSk7IC1pbnQNCj4gPiBpbnRlbF9zdm1fdW5iaW5k
X2dwYXNpZChzdHJ1Y3QgZGV2aWNlICpkZXYsIGludCBwYXNpZCk7DQo+ID4gK2ludCBpbnRlbF9z
dm1fdW5iaW5kX2dwYXNpZChzdHJ1Y3QgaW9tbXVfZG9tYWluICpkb21haW4sDQo+ID4gKwkJCSAg
ICBzdHJ1Y3QgZGV2aWNlICpkZXYsIGlvYXNpZF90IHBhc2lkKTsNCj4gPiAgc3RydWN0IGlvbW11
X3N2YSAqaW50ZWxfc3ZtX2JpbmQoc3RydWN0IGRldmljZSAqZGV2LCBzdHJ1Y3QgbW1fc3RydWN0
ICptbSwNCj4gPiAgCQkJCSB2b2lkICpkcnZkYXRhKTsNCj4gPiAgdm9pZCBpbnRlbF9zdm1fdW5i
aW5kKHN0cnVjdCBpb21tdV9zdmEgKmhhbmRsZSk7IGRpZmYgLS1naXQNCj4gPiBhL2luY2x1ZGUv
bGludXgvaW9tbXUuaCBiL2luY2x1ZGUvbGludXgvaW9tbXUuaCBpbmRleCBlODRhMWQ1Li5jYTVl
ZGQ4DQo+ID4gMTAwNjQ0DQo+ID4gLS0tIGEvaW5jbHVkZS9saW51eC9pb21tdS5oDQo+ID4gKysr
IGIvaW5jbHVkZS9saW51eC9pb21tdS5oDQo+ID4gQEAgLTMwMyw3ICszMDMsOCBAQCBzdHJ1Y3Qg
aW9tbXVfb3BzIHsNCj4gPiAgCWludCAoKnN2YV9iaW5kX2dwYXNpZCkoc3RydWN0IGlvbW11X2Rv
bWFpbiAqZG9tYWluLA0KPiA+ICAJCQlzdHJ1Y3QgZGV2aWNlICpkZXYsIHN0cnVjdCBpb21tdV9n
cGFzaWRfYmluZF9kYXRhICpkYXRhKTsNCj4gPg0KPiA+IC0JaW50ICgqc3ZhX3VuYmluZF9ncGFz
aWQpKHN0cnVjdCBkZXZpY2UgKmRldiwgaW50IHBhc2lkKTsNCj4gPiArCWludCAoKnN2YV91bmJp
bmRfZ3Bhc2lkKShzdHJ1Y3QgaW9tbXVfZG9tYWluICpkb21haW4sDQo+ID4gKwkJCQkgc3RydWN0
IGRldmljZSAqZGV2LCBpb2FzaWRfdCBwYXNpZCk7DQo+ID4NCj4gPiAgCWludCAoKmRlZl9kb21h
aW5fdHlwZSkoc3RydWN0IGRldmljZSAqZGV2KTsNCj4gPg0KPiA+DQo+IEJlc2lkZXMNCj4gUmV2
aWV3ZWQtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4NCj4NCg0KdGhhbmtz
Lg0KDQpSZWdhcmRzLA0KWWkgTGl1DQoNCj4gRXJpYw0KDQo=
