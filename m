Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE45244616
	for <lists+kvm@lfdr.de>; Fri, 14 Aug 2020 10:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgHNIEd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Aug 2020 04:04:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:26035 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726772AbgHNIEc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Aug 2020 04:04:32 -0400
IronPort-SDR: y8SDV6hwrtAgNXjCe6V61Pg+qG2zcIoc19le9RLHcP1fJUxLFLGIEZ+HOCtOAtCf+fvxNhzocY
 aoPcwpJzdK7A==
X-IronPort-AV: E=McAfee;i="6000,8403,9712"; a="155482780"
X-IronPort-AV: E=Sophos;i="5.76,311,1592895600"; 
   d="scan'208";a="155482780"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2020 01:04:31 -0700
IronPort-SDR: ujHSCwuwX5rvQe0NiFOTmIa9AF01udBLN2BkdhMLlNsz4p7OJf0lu6147jr7RGL7cfJKCP1XY3
 7QbjtATjSTFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,311,1592895600"; 
   d="scan'208";a="369839071"
Received: from fmsmsx602-2.cps.intel.com (HELO fmsmsx602.amr.corp.intel.com) ([10.18.84.212])
  by orsmga001.jf.intel.com with ESMTP; 14 Aug 2020 01:04:31 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 14 Aug 2020 01:04:30 -0700
Received: from fmsmsx156.amr.corp.intel.com (10.18.116.74) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 14 Aug 2020 01:04:30 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx156.amr.corp.intel.com (10.18.116.74) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 14 Aug 2020 01:04:30 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 14 Aug 2020 01:04:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GKKJvVJlJw6Xw4PsFWq717sij2/lSn04R2IGPapIiasvPTGLaBOZKO4/+NF+TKt4oSUOKNcWzPholQ+kHwLd7i/RE/q8tBlvC307zZUmDPgqZRwSp9Sv8xlBuVwRdFcMGBeXG0ghURwo9gB7BjEbXV0q+2H5jozHMq72wayHGTKUjUszQUnbSwTOhQCbq+6GptbLsdMk5+/G1UfvA9Y/DBPbEk7w0AQ1Yf9EQRv/f1rC7GSB8YWxi1oEmy7MwD0UEB/UhKSiRFUbjmvsmXzc9sgt+yLqK4oluHJBr7RWuq01xP9zIEQCb1EXRyiHguH57j16pH/4elDa0A+XkqBImQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=idtRZA57xfaRUh46gfc2kvUxgQab3KeAsOwC1O10AhE=;
 b=ccf/7DJHP9pa/gp5JrbatCUV9+VC5S7hstyWSn9+G/756OzwVHkKBIxYUnYTzcRy6mtIBqcjXsAQOUqpiwTxAY2UPjFXXmgjVgThZFjr7ZdIcLqiffQaLzalIV9PArRGCD+V6odAHhCLKI7KYMwC95zKfRYTjdhDaFQ87kOgD50ByIuUFPw2Et+FVEI95ZXsSgvJLXm9Tz0NG/k642f6COp0qdX5qG6q1D1E0akgANNXWNS68enqDKWUCJWPbDHLfy5iI8lpTFRqqdRXOZESR6tFliqo+SKNrzKiHe66S7eLZO9z5pHgHggexdAdUqGJ52sjCJiucDs6pT9drpVQmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=idtRZA57xfaRUh46gfc2kvUxgQab3KeAsOwC1O10AhE=;
 b=CAYVWUDjwaoqo3baF+oiVyfqcOAkhJdJAg5bkmJQy2lwjnJm4jMf5W2iNCTEAIBtKtpv7ngYNN9+15gOYLMu/qKz6J4ZuKA4OcVxtvcLF8jxcEtuZ2d1X9wHcG+neeni53uplI0piW+R0g4qtpnA98PZPrWd5Ima6FaEToe8czw=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM5PR11MB1674.namprd11.prod.outlook.com (2603:10b6:4:b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3283.15; Fri, 14 Aug 2020 08:04:28 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3261.026; Fri, 14 Aug
 2020 08:04:28 +0000
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
Subject: RE: [PATCH v6 06/15] iommu/vt-d: Support setting ioasid set to domain
Thread-Topic: [PATCH v6 06/15] iommu/vt-d: Support setting ioasid set to
 domain
Thread-Index: AQHWZKdLZpvd5TQUUESePx5zY7Axxak2PXYAgAEWcvA=
Date:   Fri, 14 Aug 2020 08:04:28 +0000
Message-ID: <DM5PR11MB1435CD15D0C713E7D1B7E8F8C3400@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1595917664-33276-1-git-send-email-yi.l.liu@intel.com>
 <1595917664-33276-7-git-send-email-yi.l.liu@intel.com>
 <ae43dda5-01aa-adb1-d21d-2525cf4f4d95@redhat.com>
In-Reply-To: <ae43dda5-01aa-adb1-d21d-2525cf4f4d95@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.202]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b1cb32d-998b-4f74-efa1-08d84028ab20
x-ms-traffictypediagnostic: DM5PR11MB1674:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB1674DFA5E58E59E0E295A134C3400@DM5PR11MB1674.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gE6zJ5u84WP4ouQUfxfmlcUcEvOb8ZhUHhFTS/Xn7ocfCErYN/I/lpxgbi4bQtn9RsKdAHgwmOF1+1i6FzaZ8S2joTkEWtN8eQB6Yep2hW17AXoPERNDsZXQejtL+e55ZPtLm4hX52RqZ5sT6H6KYpRMFY7t1zl7It9mIMvDF6ga7u9rqsIrOR5h8Znr5uZr9UX3f1/qlV6g1+gEa4eDO5xfLWndUNYwf8kNHcFkqkLdZNYKO1YXUMrMqQQX257UQMr1MCTYfMIgw6GK2MWwOga5uNZZyCt3tV78zGV8iLNuyq+MEv74pbHVllmtkMHuGRWDsydey09GqAQbKX0dvya0BBniv8+MvaOrs4YGey8f0HTXNTiLrud+5MGZdolanQkQP4ZL8Q3yg2Y8GbK1zQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(66446008)(7696005)(6506007)(53546011)(76116006)(4326008)(186003)(8936002)(33656002)(26005)(83380400001)(52536014)(66946007)(5660300002)(8676002)(966005)(71200400001)(66476007)(7416002)(66556008)(9686003)(2906002)(110136005)(478600001)(316002)(64756008)(86362001)(54906003)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: x0geWRlWubq65K0+d5pl30kacCHDuM1OK/BKgVsaOWJ1KbtQzDfeM9anfpEUnuvuV33CsgxVAndSiREuLG8gEAVSK5C5c7b9f2TyTeSDpW2zPXKqkUhnfG//UWEGRflAIO+BEZYGzVzQmdnryOq8szNwn+LrgdPvnS/7j41TIzKW5Alf6fzSb/iPR8f2ROEkh1WdWiDduArOJHP91h6z4H1dvLgGC60e7hJsXBq5yuXP5pFByKzXVdhkiMoKWGHNvHnC2dRH1BVKcgDqxFKfFzmTfjcD0Rlg/E+8VkXVyJ8+gLRGASKpXaLBqUM3fl9iC05GMUyaITIXy9JqQaXXqgPqAx7M24V/FUucOoeiK3qV0PiZ8Sdr5ljYjvo36BPRjIK8PIN/LelIN6iHnXwCZ/UongGbwunZexxQ97EKWvP4VgTOzi8mmsZnA9DucjyMzo7pqcqJ5ro6L7JKT3SN1CMeKiIpKgrH12Mq9EdgexgNVjuOUhEyhz14tEDV3gbjG8RtEyn5md3uSZqoGYEMNC3UbCOY+pfDy+HMj3dRZIeikSkDuzhq4rvUdEaXlF3Yry5ZATZKaNe0Mn77zQTC/cgJ5vOoBAMzk6wtNm8YN/NdFBO0wbLWPp/bLF8EsdJZtbMQlpKH8YHGuLzzUHQgtQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b1cb32d-998b-4f74-efa1-08d84028ab20
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2020 08:04:28.5127
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hMzGOQmhY0CI8Y8cpzZGu2mNhjgMLHaWX3i+Phxqeo6s2aIN/SGvM3LlKRrPAhaCOoe83D8N8UPr4bHOHuxAhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1674
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBBdWdlciBFcmljIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+
IFNlbnQ6IFRodXJzZGF5LCBBdWd1c3QgMTMsIDIwMjAgMTE6MDcgUE0NCj4gDQo+IEhpIFlpLA0K
PiANCj4gT24gNy8yOC8yMCA4OjI3IEFNLCBMaXUgWWkgTCB3cm90ZToNCj4gPiBGcm9tIElPTU1V
IHAuby52LiwgUEFTSURzIGFsbG9jYXRlZCBhbmQgbWFuYWdlZCBieSBleHRlcm5hbCBjb21wb25l
bnRzDQo+ID4gKGUuZy4gVkZJTykgd2lsbCBiZSBwYXNzZWQgaW4gZm9yIGdwYXNpZF9iaW5kL3Vu
YmluZCBvcGVyYXRpb24uIElPTU1VDQo+ID4gbmVlZHMgc29tZSBrbm93bGVkZ2UgdG8gY2hlY2sg
dGhlIFBBU0lEIG93bmVyc2hpcCwgaGVuY2UgYWRkIGFuDQo+ID4gaW50ZXJmYWNlIGZvciB0aG9z
ZSBjb21wb25lbnRzIHRvIHRlbGwgdGhlIFBBU0lEIG93bmVyLg0KPiA+DQo+ID4gSW4gbGF0ZXN0
IGtlcm5lbCBkZXNpZ24sIFBBU0lEIG93bmVyc2hpcCBpcyBtYW5hZ2VkIGJ5IElPQVNJRCBzZXQN
Cj4gPiB3aGVyZSB0aGUgUEFTSUQgaXMgYWxsb2NhdGVkIGZyb20uIFRoaXMgcGF0Y2ggYWRkcyBz
dXBwb3J0IGZvciBzZXR0aW5nDQo+ID4gaW9hc2lkIHNldCBJRCB0byB0aGUgZG9tYWlucyB1c2Vk
IGZvciBuZXN0aW5nL3ZTVkEuIFN1YnNlcXVlbnQgU1ZBDQo+ID4gb3BlcmF0aW9ucyB3aWxsIGNo
ZWNrIHRoZSBQQVNJRCBhZ2FpbnN0IGl0cyBJT0FTSUQgc2V0IGZvciBwcm9wZXIgb3duZXJzaGlw
Lg0KPiA+DQo+ID4gQ2M6IEtldmluIFRpYW4gPGtldmluLnRpYW5AaW50ZWwuY29tPg0KPiA+IEND
OiBKYWNvYiBQYW4gPGphY29iLmp1bi5wYW5AbGludXguaW50ZWwuY29tPg0KPiA+IENjOiBBbGV4
IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiA+IENjOiBFcmljIEF1
Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+ID4gQ2M6IEplYW4tUGhpbGlwcGUgQnJ1Y2tl
ciA8amVhbi1waGlsaXBwZUBsaW5hcm8ub3JnPg0KPiA+IENjOiBKb2VyZyBSb2VkZWwgPGpvcm9A
OGJ5dGVzLm9yZz4NCj4gPiBDYzogTHUgQmFvbHUgPGJhb2x1Lmx1QGxpbnV4LmludGVsLmNvbT4N
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBMaXUgWWkgTCA8eWkubC5saXVAaW50ZWwuY29tPg0KPiA+IFNp
Z25lZC1vZmYtYnk6IEphY29iIFBhbiA8amFjb2IuanVuLnBhbkBsaW51eC5pbnRlbC5jb20+DQo+
ID4gLS0tDQo+ID4gdjUgLT4gdjY6DQo+ID4gKikgYWRkcmVzcyBjb21tZW50cyBhZ2FpbnN0IHY1
IGZyb20gRXJpYyBBdWdlci4NCj4gPg0KPiA+IHY0IC0+IHY1Og0KPiA+ICopIGFkZHJlc3MgY29t
bWVudHMgZnJvbSBFcmljIEF1Z2VyLg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL2lvbW11L2ludGVs
L2lvbW11LmMgfCAyMyArKysrKysrKysrKysrKysrKysrKysrKw0KPiA+IGluY2x1ZGUvbGludXgv
aW50ZWwtaW9tbXUuaCB8ICA0ICsrKysNCj4gPiAgaW5jbHVkZS9saW51eC9pb21tdS5oICAgICAg
IHwgIDEgKw0KPiA+ICAzIGZpbGVzIGNoYW5nZWQsIDI4IGluc2VydGlvbnMoKykNCj4gPg0KPiA+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL2lvbW11L2ludGVsL2lvbW11LmMgYi9kcml2ZXJzL2lvbW11
L2ludGVsL2lvbW11LmMNCj4gPiBpbmRleCBlZDRiNzFjLi5iMmZlNTRlIDEwMDY0NA0KPiA+IC0t
LSBhL2RyaXZlcnMvaW9tbXUvaW50ZWwvaW9tbXUuYw0KPiA+ICsrKyBiL2RyaXZlcnMvaW9tbXUv
aW50ZWwvaW9tbXUuYw0KPiA+IEBAIC0xNzkzLDYgKzE3OTMsNyBAQCBzdGF0aWMgc3RydWN0IGRt
YXJfZG9tYWluICphbGxvY19kb21haW4oaW50IGZsYWdzKQ0KPiA+ICAJaWYgKGZpcnN0X2xldmVs
X2J5X2RlZmF1bHQoKSkNCj4gPiAgCQlkb21haW4tPmZsYWdzIHw9IERPTUFJTl9GTEFHX1VTRV9G
SVJTVF9MRVZFTDsNCj4gPiAgCWRvbWFpbi0+aGFzX2lvdGxiX2RldmljZSA9IGZhbHNlOw0KPiA+
ICsJZG9tYWluLT5pb2FzaWRfc2lkID0gSU5WQUxJRF9JT0FTSURfU0VUOw0KPiA+ICAJSU5JVF9M
SVNUX0hFQUQoJmRvbWFpbi0+ZGV2aWNlcyk7DQo+ID4NCj4gPiAgCXJldHVybiBkb21haW47DQo+
ID4gQEAgLTYwNDAsNiArNjA0MSwyOCBAQCBpbnRlbF9pb21tdV9kb21haW5fc2V0X2F0dHIoc3Ry
dWN0IGlvbW11X2RvbWFpbg0KPiAqZG9tYWluLA0KPiA+ICAJCX0NCj4gPiAgCQlzcGluX3VubG9j
a19pcnFyZXN0b3JlKCZkZXZpY2VfZG9tYWluX2xvY2ssIGZsYWdzKTsNCj4gPiAgCQlicmVhazsN
Cj4gPiArCWNhc2UgRE9NQUlOX0FUVFJfSU9BU0lEX1NJRDoNCj4gPiArCXsNCj4gPiArCQlpbnQg
c2lkID0gKihpbnQgKilkYXRhOw0KPiANCj4gPiArDQo+ID4gKwkJc3Bpbl9sb2NrX2lycXNhdmUo
JmRldmljZV9kb21haW5fbG9jaywgZmxhZ3MpOw0KPiA+ICsJCWlmICghKGRtYXJfZG9tYWluLT5m
bGFncyAmIERPTUFJTl9GTEFHX05FU1RJTkdfTU9ERSkpIHsNCj4gPiArCQkJcmV0ID0gLUVOT0RF
VjsNCj4gPiArCQkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmZGV2aWNlX2RvbWFpbl9sb2NrLCBm
bGFncyk7DQo+ID4gKwkJCWJyZWFrOw0KPiA+ICsJCX0NCj4gPiArCQlpZiAoZG1hcl9kb21haW4t
PmlvYXNpZF9zaWQgIT0gSU5WQUxJRF9JT0FTSURfU0VUICYmDQo+ID4gKwkJICAgIGRtYXJfZG9t
YWluLT5pb2FzaWRfc2lkICE9IHNpZCkgew0KPiA+ICsJCQlwcl93YXJuX3JhdGVsaW1pdGVkKCJt
dWx0aSBpb2FzaWRfc2V0ICglZDolZCkgc2V0dGluZyIsDQo+ID4gKwkJCQkJICAgIGRtYXJfZG9t
YWluLT5pb2FzaWRfc2lkLCBzaWQpOw0KPiA+ICsJCQlyZXQgPSAtRUJVU1k7DQo+ID4gKwkJCXNw
aW5fdW5sb2NrX2lycXJlc3RvcmUoJmRldmljZV9kb21haW5fbG9jaywgZmxhZ3MpOw0KPiA+ICsJ
CQlicmVhazsNCj4gPiArCQl9DQo+ID4gKwkJZG1hcl9kb21haW4tPmlvYXNpZF9zaWQgPSBzaWQ7
DQo+ID4gKwkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmZGV2aWNlX2RvbWFpbl9sb2NrLCBmbGFn
cyk7DQo+ID4gKwkJYnJlYWs7DQo+IG5pdDogQWRkaW5nIGEgc21hbGwgaGVscGVyDQo+IGludF9f
c2V0X2lvYXNpZF9zaWQoc3RydWN0IGRtYXJfZG9tYWluICpkbWFyX2RvbWFpbiwgaW50IHNpZF9p
ZCkNCj4gDQo+IG1heSBzaW1wbGlmeSB0aGUgbG9jayBoYW5kbGluZw0KDQpvay4gd2lsbCBkby4N
Cg0KPiANCj4gPiArCX0NCj4gPiAgCWRlZmF1bHQ6DQo+ID4gIAkJcmV0ID0gLUVJTlZBTDsNCj4g
PiAgCQlicmVhazsNCj4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9pbnRlbC1pb21tdS5o
IGIvaW5jbHVkZS9saW51eC9pbnRlbC1pb21tdS5oDQo+ID4gaW5kZXggM2YyM2MyNi4uMGQwYWIz
MiAxMDA2NDQNCj4gPiAtLS0gYS9pbmNsdWRlL2xpbnV4L2ludGVsLWlvbW11LmgNCj4gPiArKysg
Yi9pbmNsdWRlL2xpbnV4L2ludGVsLWlvbW11LmgNCj4gPiBAQCAtNTQ5LDYgKzU0OSwxMCBAQCBz
dHJ1Y3QgZG1hcl9kb21haW4gew0KPiA+ICAJCQkJCSAgIDIgPT0gMUdpQiwgMyA9PSA1MTJHaUIs
IDQgPT0gMVRpQiAqLw0KPiA+ICAJdTY0CQltYXhfYWRkcjsJLyogbWF4aW11bSBtYXBwZWQgYWRk
cmVzcyAqLw0KPiA+DQo+ID4gKwlpbnQJCWlvYXNpZF9zaWQ7CS8qDQo+ID4gKwkJCQkJICogdGhl
IGlvYXNpZCBzZXQgd2hpY2ggdHJhY2tzIGFsbA0KPiBpZCBvZiB0aGUgaW9hc2lkIHNldD8NCg0K
c2hvdWxkIGJlIGlvYXNpZF9zZXQuIGhvd2V2ZXIsIGlvYXNpZF9hbGxvY19zZXQoKSByZXR1cm5z
IHNpZCBpbiBKYWNvYidzDQpzZXJpZXMuIGJ1dCwgSSBoZWFyZCBmcm9tIEphY29iLCBoZSB3aWxs
IHJlbW92ZSBpb2FzaWRfc2lkLCBhbmQgcmV0dXJuDQppb2FzaWRfc2V0LiBzbyBJIHdpbGwgbW9k
aWZ5IGl0IG9uY2UgaGlzIHBhdGNoIGlzIHNlbnQgb3V0Lg0KDQpodHRwczovL2xvcmUua2VybmVs
Lm9yZy9saW51eC1pb21tdS8xNTg1MTU4OTMxLTE4MjUtNC1naXQtc2VuZC1lbWFpbC1qYWNvYi5q
dW4ucGFuQGxpbnV4LmludGVsLmNvbS8NCg0KPiA+ICsJCQkJCSAqIFBBU0lEcyB1c2VkIGJ5IHRo
ZSBkb21haW4uDQo+ID4gKwkJCQkJICovDQo+ID4gIAlpbnQJCWRlZmF1bHRfcGFzaWQ7CS8qDQo+
ID4gIAkJCQkJICogVGhlIGRlZmF1bHQgcGFzaWQgdXNlZCBmb3Igbm9uLVNWTQ0KPiA+ICAJCQkJ
CSAqIHRyYWZmaWMgb24gbWVkaWF0ZWQgZGV2aWNlcy4NCj4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVk
ZS9saW51eC9pb21tdS5oIGIvaW5jbHVkZS9saW51eC9pb21tdS5oIGluZGV4DQo+ID4gNGEwMmM5
ZS4uYjFmZjcwMiAxMDA2NDQNCj4gPiAtLS0gYS9pbmNsdWRlL2xpbnV4L2lvbW11LmgNCj4gPiAr
KysgYi9pbmNsdWRlL2xpbnV4L2lvbW11LmgNCj4gPiBAQCAtMTI0LDYgKzEyNCw3IEBAIGVudW0g
aW9tbXVfYXR0ciB7DQo+ID4gIAlET01BSU5fQVRUUl9GU0xfUEFNVVYxLA0KPiA+ICAJRE9NQUlO
X0FUVFJfTkVTVElORywJLyogdHdvIHN0YWdlcyBvZiB0cmFuc2xhdGlvbiAqLw0KPiA+ICAJRE9N
QUlOX0FUVFJfRE1BX1VTRV9GTFVTSF9RVUVVRSwNCj4gPiArCURPTUFJTl9BVFRSX0lPQVNJRF9T
SUQsDQo+ID4gIAlET01BSU5fQVRUUl9NQVgsDQo+ID4gIH07DQo+ID4NCj4gPg0KPiBCZXNpZGVz
DQo+IFJldmlld2VkLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQoNCnRo
YW5rcyA6LSkNCg0KUmVnYXJkcywNCllpIExpdQ0KDQo+IA0KPiBFcmljDQoNCg==
