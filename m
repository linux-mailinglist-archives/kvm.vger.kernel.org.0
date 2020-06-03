Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30DD51EC6CA
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 03:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgFCBe7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 21:34:59 -0400
Received: from mga06.intel.com ([134.134.136.31]:47179 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbgFCBe7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jun 2020 21:34:59 -0400
IronPort-SDR: BGzQix7VIVmZ/OPbkhzZ7AJ3ze03+LCJXqbl7ovE+R3rH67mf8oRpgseH/eDwfV+Yt13caU0NL
 6laKdiLYH+Ag==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2020 18:34:48 -0700
IronPort-SDR: 04v8Ip+xZeNI8on+VN6mrLjRB6JQ4IKmlk9SCeHwao/gQoZGrsi6Dg5uI2zQLfjctsPyrzhbw6
 c2UdXO9rP2zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,466,1583222400"; 
   d="scan'208";a="258481984"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga008.fm.intel.com with ESMTP; 02 Jun 2020 18:34:48 -0700
Received: from fmsmsx120.amr.corp.intel.com (10.18.124.208) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 2 Jun 2020 18:34:47 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx120.amr.corp.intel.com (10.18.124.208) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 2 Jun 2020 18:34:47 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Tue, 2 Jun 2020 18:34:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DupzB3+jKTrM3CDWr52kNfzyW79sG3KdX22YeAKaeZJBWQIJrV4hDEQ9hF+a0+vKM2jm70BOYnSWVsMJLBGPooFPb5wrodIyRmWdvke+dZaVt7qsi81Xjp99YAVrDMCz2Vw2BFMaGiBe0obRhQiebWHtvwQfIhB9ZJ6Y+yNQ1q05N5Tm5DSNxFCJk4oWc3AHpIxIgyCwsaV9OxUYC4VjG2AFMeRGTLcpCXvVHD8hW/2D+KXjbpSDmL9UjJcauF4ECxzRoEvs6ErG3wElzxuWPm5C8XYlhGUydLxgAewA1sYqe5Z8QRayKrHknDQkvsBcW894xCDJlpJLCGLtEDYimQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/b8dvyUoyQbEjyd+CJdnstlBXN1paZ1bm4dRoDxYPGg=;
 b=LdH3FJdZvlZF+awfx1YoaP0z+dspKJSDAdprHMrUiZmHSn1hQw+HY9Gajo2rwgATFMsQ8wHhGFAGPkIE22mtv5LHE8ag3U5ojamqbPtpXiC2YWFPH8fbEUb/8O9yFabBNxE7mv0E4vPsh47FKutfS1w4rqL+A3BDC8QiWVxJAYWKFRRxhVn95ueRoCJULEMukYKp5zsDWEs8YHVSl3dqdNW+p9Sp0SEhMdEb4vPD0yh1yU6Iy0M2MMaxhVNosSdo6y5ABpoakTJH//njtvwHkYdBzs9p2MidvQPA7e7xAjNJatmQu59PMa5Po44w4IaaVSeUmhXqsSBLMOZ+vY/6Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/b8dvyUoyQbEjyd+CJdnstlBXN1paZ1bm4dRoDxYPGg=;
 b=SZEcCbAVefp9kYdFQRP7jGkJ5hJD6xnJYr2izFJDtLK9ufaGZuxKu2FJ+hyUbewfUs6thoE0yI7K+KjlkUjJOIVOQBLLZaDaszsVcmHtK3bw8RPpuYvW+HJQ3HQSfm8YPtFMQUTbW3LCpJ2Ft1IVgeuEDAZIJZswr62nJsOcki0=
Received: from CY4PR1101MB2216.namprd11.prod.outlook.com
 (2603:10b6:910:25::17) by CY4PR1101MB2071.namprd11.prod.outlook.com
 (2603:10b6:910:1a::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Wed, 3 Jun
 2020 01:34:45 +0000
Received: from CY4PR1101MB2216.namprd11.prod.outlook.com
 ([fe80::9c64:9b0a:fde3:b715]) by CY4PR1101MB2216.namprd11.prod.outlook.com
 ([fe80::9c64:9b0a:fde3:b715%5]) with mapi id 15.20.3045.024; Wed, 3 Jun 2020
 01:34:45 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill@shutemov.name" <kirill@shutemov.name>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "wad@chromium.org" <wad@chromium.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC 09/16] KVM: Protected memory extension
Thread-Topic: [RFC 09/16] KVM: Protected memory extension
Thread-Index: AQHWMDf0LEKYD6iy3k27XZpPWNEGT6i48VKAgAACOoCADTpVAA==
Date:   Wed, 3 Jun 2020 01:34:45 +0000
Message-ID: <05a440207cf0e6149a5ca2a7f1ecccde834a208c.camel@intel.com>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
         <20200522125214.31348-10-kirill.shutemov@linux.intel.com>
         <87367o828i.fsf@vitty.brq.redhat.com> <20200525153435.c6mx3pjryyk4j4go@box>
In-Reply-To: <20200525153435.c6mx3pjryyk4j4go@box>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.2 (3.36.2-1.fc32) 
authentication-results: shutemov.name; dkim=none (message not signed)
 header.d=none;shutemov.name; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.52.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c06f932f-8928-42ac-c11a-08d8075e4c2e
x-ms-traffictypediagnostic: CY4PR1101MB2071:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR1101MB2071DFADF466D9DF8BC67706F7880@CY4PR1101MB2071.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 04238CD941
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WzEHTLSjhxTlgHTWc80lhZvD9bwgTgYqSyAxoSPdToz2gILMAp2OP0X/l8B+60CtpjmYKVn1hZlqIYphXxVKRmTjFd273uwk0aS7Cf9MFTwmjXB+dCCCw0pJbikAlFCEYaI584hHkcu4uTsU2eD4loE19VXJ5++2a19t2e9TynVwonsetAEMJQSQXrAjI7UzctUmV1f8FKxEyIPDIrwF+sg0bIOfiuXD1rlhI/Hi3Xdpjs0tBmpSGFK3orJ4Yewkm6BsB5PyVv4agXCOQ+3xnewlypbd00NwJtJhvBVfz4020t2YapueYDLISYhz0qdB+on/s1c/DXx4lZlgChxUu4gMUtbiY+QKOah4XDeRLPZUobVO0mVIIdwcIiMJZM48
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1101MB2216.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(346002)(366004)(396003)(136003)(376002)(6486002)(2906002)(83380400001)(4326008)(66946007)(478600001)(66476007)(91956017)(64756008)(76116006)(66446008)(66556008)(6512007)(36756003)(186003)(26005)(5660300002)(110136005)(2616005)(316002)(6506007)(8676002)(71200400001)(8936002)(7416002)(86362001)(54906003)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: CYSrp4/YuMTIVtt+ptpNbgEK5LXhTffD03Ey7LFE+M5OCA6V8s8CiV2PkWLbBGflIxNNBM28EMsYh5SOXND7QOSGN/HE8qaz/ENrokWOol8IXLhzlgM5OYQuxPFWL6GL/ajDFlWKE6eQ34dt4lgXdu02RmRX0tI6u1kzSRzqFpSoZcgA9p0RiCUqrZqtZVtCog0s2SkPUVCTVv8z/a4Cv16ONlQti0wUgi+XmsBnB0DU/iKKoX32P7aKTvZv/Dvz5upikzj8NZyUTNa/ySiIKfi7qyUf6PIuA39h4gepJ1tXnnJSOa+B3tW6VFmaoK6xggAH06U7mM6uUzk7oMg+D7pXRciM2yxAfT6ApX8UfQikxQcMxGdw262yFmZhYy/pXwt6vH8JpN1vd0ASr3RHoaO92XpRwI0C5lu7uETzZ7GB9PB5kjg2FGTctG34s3hzMlFfn/PJ/OIbnOiRxNgFwBAMYZ887OlbiMAVKxpOZ+I=
Content-Type: text/plain; charset="utf-8"
Content-ID: <494ED0D45964C847A07574F376AF9D6B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c06f932f-8928-42ac-c11a-08d8075e4c2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2020 01:34:45.8568
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s9X8q7J8Eki1lxSohwTV8J1FFChB+lU2SlDmwulJuVuJBr4YLCADzdMTdxfjQUtyIkyJBEhewpvYyGUccTvgLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2071
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIwLTA1LTI1IGF0IDE4OjM0ICswMzAwLCBLaXJpbGwgQS4gU2h1dGVtb3Ygd3Jv
dGU6DQo+IE9uIE1vbiwgTWF5IDI1LCAyMDIwIGF0IDA1OjI2OjM3UE0gKzAyMDAsIFZpdGFseSBL
dXpuZXRzb3Ygd3JvdGU6DQo+ID4gIktpcmlsbCBBLiBTaHV0ZW1vdiIgPGtpcmlsbEBzaHV0ZW1v
di5uYW1lPiB3cml0ZXM6DQo+ID4gDQo+ID4gPiBBZGQgaW5mcmFzdHJ1Y3R1cmUgdGhhdCBoYW5k
bGVzIHByb3RlY3RlZCBtZW1vcnkgZXh0ZW5zaW9uLg0KPiA+ID4gDQo+ID4gPiBBcmNoLXNwZWNp
ZmljIGNvZGUgaGFzIHRvIHByb3ZpZGUgaHlwZXJjYWxscyBhbmQgZGVmaW5lIG5vbi16ZXJvDQo+
ID4gPiBWTV9LVk1fUFJPVEVDVEVELg0KPiA+ID4gDQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBLaXJp
bGwgQS4gU2h1dGVtb3YgPGtpcmlsbC5zaHV0ZW1vdkBsaW51eC5pbnRlbC5jb20+DQo+ID4gPiAt
LS0NCj4gPiA+ICBpbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmggfCAgIDQgKysNCj4gPiA+ICBtbS9t
cHJvdGVjdC5jICAgICAgICAgICAgfCAgIDEgKw0KPiA+ID4gIHZpcnQva3ZtL2t2bV9tYWluLmMg
ICAgICB8IDEzMSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gPiA+
ICAzIGZpbGVzIGNoYW5nZWQsIDEzNiBpbnNlcnRpb25zKCspDQo+ID4gPiANCj4gPiA+IGRpZmYg
LS1naXQgYS9pbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmggYi9pbmNsdWRlL2xpbnV4L2t2bV9ob3N0
LmgNCj4gPiA+IGluZGV4IGJkMGJiNjAwZjYxMC4uZDcwNzJmNmQ2YWEwIDEwMDY0NA0KPiA+ID4g
LS0tIGEvaW5jbHVkZS9saW51eC9rdm1faG9zdC5oDQo+ID4gPiArKysgYi9pbmNsdWRlL2xpbnV4
L2t2bV9ob3N0LmgNCj4gPiA+IEBAIC03MDAsNiArNzAwLDEwIEBAIHZvaWQga3ZtX2FyY2hfZmx1
c2hfc2hhZG93X2FsbChzdHJ1Y3Qga3ZtICprdm0pOw0KPiA+ID4gIHZvaWQga3ZtX2FyY2hfZmx1
c2hfc2hhZG93X21lbXNsb3Qoc3RydWN0IGt2bSAqa3ZtLA0KPiA+ID4gIAkJCQkgICBzdHJ1Y3Qg
a3ZtX21lbW9yeV9zbG90ICpzbG90KTsNCj4gPiA+ICANCj4gPiA+ICtpbnQga3ZtX3Byb3RlY3Rf
YWxsX21lbW9yeShzdHJ1Y3Qga3ZtICprdm0pOw0KPiA+ID4gK2ludCBrdm1fcHJvdGVjdF9tZW1v
cnkoc3RydWN0IGt2bSAqa3ZtLA0KPiA+ID4gKwkJICAgICAgIHVuc2lnbmVkIGxvbmcgZ2ZuLCB1
bnNpZ25lZCBsb25nIG5wYWdlcywgYm9vbCBwcm90ZWN0KTsNCj4gPiA+ICsNCj4gPiA+ICBpbnQg
Z2ZuX3RvX3BhZ2VfbWFueV9hdG9taWMoc3RydWN0IGt2bV9tZW1vcnlfc2xvdCAqc2xvdCwgZ2Zu
X3QgZ2ZuLA0KPiA+ID4gIAkJCSAgICBzdHJ1Y3QgcGFnZSAqKnBhZ2VzLCBpbnQgbnJfcGFnZXMp
Ow0KPiA+ID4gIA0KPiA+ID4gZGlmZiAtLWdpdCBhL21tL21wcm90ZWN0LmMgYi9tbS9tcHJvdGVj
dC5jDQo+ID4gPiBpbmRleCA0OTQxOTJjYTk1NGIuLjU1MmJlM2I0YzgwYSAxMDA2NDQNCj4gPiA+
IC0tLSBhL21tL21wcm90ZWN0LmMNCj4gPiA+ICsrKyBiL21tL21wcm90ZWN0LmMNCj4gPiA+IEBA
IC01MDUsNiArNTA1LDcgQEAgbXByb3RlY3RfZml4dXAoc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2
bWEsIHN0cnVjdA0KPiA+ID4gdm1fYXJlYV9zdHJ1Y3QgKipwcHJldiwNCj4gPiA+ICAJdm1fdW5h
Y2N0X21lbW9yeShjaGFyZ2VkKTsNCj4gPiA+ICAJcmV0dXJuIGVycm9yOw0KPiA+ID4gIH0NCj4g
PiA+ICtFWFBPUlRfU1lNQk9MX0dQTChtcHJvdGVjdF9maXh1cCk7DQo+ID4gPiAgDQo+ID4gPiAg
LyoNCj4gPiA+ICAgKiBwa2V5PT0tMSB3aGVuIGRvaW5nIGEgbGVnYWN5IG1wcm90ZWN0KCkNCj4g
PiA+IGRpZmYgLS1naXQgYS92aXJ0L2t2bS9rdm1fbWFpbi5jIGIvdmlydC9rdm0va3ZtX21haW4u
Yw0KPiA+ID4gaW5kZXggNTMwYWY5NWVmZGYzLi4wN2Q0NWRhNWQyYWEgMTAwNjQ0DQo+ID4gPiAt
LS0gYS92aXJ0L2t2bS9rdm1fbWFpbi5jDQo+ID4gPiArKysgYi92aXJ0L2t2bS9rdm1fbWFpbi5j
DQo+ID4gPiBAQCAtMTU1LDYgKzE1NSw4IEBAIHN0YXRpYyB2b2lkIGt2bV91ZXZlbnRfbm90aWZ5
X2NoYW5nZSh1bnNpZ25lZCBpbnQNCj4gPiA+IHR5cGUsIHN0cnVjdCBrdm0gKmt2bSk7DQo+ID4g
PiAgc3RhdGljIHVuc2lnbmVkIGxvbmcgbG9uZyBrdm1fY3JlYXRldm1fY291bnQ7DQo+ID4gPiAg
c3RhdGljIHVuc2lnbmVkIGxvbmcgbG9uZyBrdm1fYWN0aXZlX3ZtczsNCj4gPiA+ICANCj4gPiA+
ICtzdGF0aWMgaW50IHByb3RlY3RfbWVtb3J5KHVuc2lnbmVkIGxvbmcgc3RhcnQsIHVuc2lnbmVk
IGxvbmcgZW5kLCBib29sDQo+ID4gPiBwcm90ZWN0KTsNCj4gPiA+ICsNCj4gPiA+ICBfX3dlYWsg
aW50IGt2bV9hcmNoX21tdV9ub3RpZmllcl9pbnZhbGlkYXRlX3JhbmdlKHN0cnVjdCBrdm0gKmt2
bSwNCj4gPiA+ICAJCXVuc2lnbmVkIGxvbmcgc3RhcnQsIHVuc2lnbmVkIGxvbmcgZW5kLCBib29s
IGJsb2NrYWJsZSkNCj4gPiA+ICB7DQo+ID4gPiBAQCAtMTMwOSw2ICsxMzExLDE0IEBAIGludCBf
X2t2bV9zZXRfbWVtb3J5X3JlZ2lvbihzdHJ1Y3Qga3ZtICprdm0sDQo+ID4gPiAgCWlmIChyKQ0K
PiA+ID4gIAkJZ290byBvdXRfYml0bWFwOw0KPiA+ID4gIA0KPiA+ID4gKwlpZiAobWVtLT5tZW1v
cnlfc2l6ZSAmJiBrdm0tPm1lbV9wcm90ZWN0ZWQpIHsNCj4gPiA+ICsJCXIgPSBwcm90ZWN0X21l
bW9yeShuZXcudXNlcnNwYWNlX2FkZHIsDQo+ID4gPiArCQkJCSAgIG5ldy51c2Vyc3BhY2VfYWRk
ciArIG5ldy5ucGFnZXMgKiBQQUdFX1NJWkUsDQo+ID4gPiArCQkJCSAgIHRydWUpOw0KPiA+ID4g
KwkJaWYgKHIpDQo+ID4gPiArCQkJZ290byBvdXRfYml0bWFwOw0KPiA+ID4gKwl9DQo+ID4gPiAr
DQo+ID4gPiAgCWlmIChvbGQuZGlydHlfYml0bWFwICYmICFuZXcuZGlydHlfYml0bWFwKQ0KPiA+
ID4gIAkJa3ZtX2Rlc3Ryb3lfZGlydHlfYml0bWFwKCZvbGQpOw0KPiA+ID4gIAlyZXR1cm4gMDsN
Cj4gPiA+IEBAIC0yNjUyLDYgKzI2NjIsMTI3IEBAIHZvaWQga3ZtX3ZjcHVfbWFya19wYWdlX2Rp
cnR5KHN0cnVjdCBrdm1fdmNwdQ0KPiA+ID4gKnZjcHUsIGdmbl90IGdmbikNCj4gPiA+ICB9DQo+
ID4gPiAgRVhQT1JUX1NZTUJPTF9HUEwoa3ZtX3ZjcHVfbWFya19wYWdlX2RpcnR5KTsNCj4gPiA+
ICANCj4gPiA+ICtzdGF0aWMgaW50IHByb3RlY3RfbWVtb3J5KHVuc2lnbmVkIGxvbmcgc3RhcnQs
IHVuc2lnbmVkIGxvbmcgZW5kLCBib29sDQo+ID4gPiBwcm90ZWN0KQ0KPiA+ID4gK3sNCj4gPiA+
ICsJc3RydWN0IG1tX3N0cnVjdCAqbW0gPSBjdXJyZW50LT5tbTsNCj4gPiA+ICsJc3RydWN0IHZt
X2FyZWFfc3RydWN0ICp2bWEsICpwcmV2Ow0KPiA+ID4gKwlpbnQgcmV0Ow0KPiA+ID4gKw0KPiA+
ID4gKwlpZiAoZG93bl93cml0ZV9raWxsYWJsZSgmbW0tPm1tYXBfc2VtKSkNCj4gPiA+ICsJCXJl
dHVybiAtRUlOVFI7DQo+ID4gPiArDQo+ID4gPiArCXJldCA9IC1FTk9NRU07DQo+ID4gPiArCXZt
YSA9IGZpbmRfdm1hKGN1cnJlbnQtPm1tLCBzdGFydCk7DQo+ID4gPiArCWlmICghdm1hKQ0KPiA+
ID4gKwkJZ290byBvdXQ7DQo+ID4gPiArDQo+ID4gPiArCXJldCA9IC1FSU5WQUw7DQo+ID4gPiAr
CWlmICh2bWEtPnZtX3N0YXJ0ID4gc3RhcnQpDQo+ID4gPiArCQlnb3RvIG91dDsNCj4gPiA+ICsN
Cj4gPiA+ICsJaWYgKHN0YXJ0ID4gdm1hLT52bV9zdGFydCkNCj4gPiA+ICsJCXByZXYgPSB2bWE7
DQo+ID4gPiArCWVsc2UNCj4gPiA+ICsJCXByZXYgPSB2bWEtPnZtX3ByZXY7DQo+ID4gPiArDQo+
ID4gPiArCXJldCA9IDA7DQo+ID4gPiArCXdoaWxlICh0cnVlKSB7DQo+ID4gPiArCQl1bnNpZ25l
ZCBsb25nIG5ld2ZsYWdzLCB0bXA7DQo+ID4gPiArDQo+ID4gPiArCQl0bXAgPSB2bWEtPnZtX2Vu
ZDsNCj4gPiA+ICsJCWlmICh0bXAgPiBlbmQpDQo+ID4gPiArCQkJdG1wID0gZW5kOw0KPiA+ID4g
Kw0KPiA+ID4gKwkJbmV3ZmxhZ3MgPSB2bWEtPnZtX2ZsYWdzOw0KPiA+ID4gKwkJaWYgKHByb3Rl
Y3QpDQo+ID4gPiArCQkJbmV3ZmxhZ3MgfD0gVk1fS1ZNX1BST1RFQ1RFRDsNCj4gPiA+ICsJCWVs
c2UNCj4gPiA+ICsJCQluZXdmbGFncyAmPSB+Vk1fS1ZNX1BST1RFQ1RFRDsNCj4gPiA+ICsNCj4g
PiA+ICsJCS8qIFRoZSBWTUEgaGFzIGJlZW4gaGFuZGxlZCBhcyBwYXJ0IG9mIG90aGVyIG1lbXNs
b3QgKi8NCj4gPiA+ICsJCWlmIChuZXdmbGFncyA9PSB2bWEtPnZtX2ZsYWdzKQ0KPiA+ID4gKwkJ
CWdvdG8gbmV4dDsNCj4gPiA+ICsNCj4gPiA+ICsJCXJldCA9IG1wcm90ZWN0X2ZpeHVwKHZtYSwg
JnByZXYsIHN0YXJ0LCB0bXAsIG5ld2ZsYWdzKTsNCj4gPiA+ICsJCWlmIChyZXQpDQo+ID4gPiAr
CQkJZ290byBvdXQ7DQo+ID4gPiArDQo+ID4gPiArbmV4dDoNCj4gPiA+ICsJCXN0YXJ0ID0gdG1w
Ow0KPiA+ID4gKwkJaWYgKHN0YXJ0IDwgcHJldi0+dm1fZW5kKQ0KPiA+ID4gKwkJCXN0YXJ0ID0g
cHJldi0+dm1fZW5kOw0KPiA+ID4gKw0KPiA+ID4gKwkJaWYgKHN0YXJ0ID49IGVuZCkNCj4gPiA+
ICsJCQlnb3RvIG91dDsNCj4gPiA+ICsNCj4gPiA+ICsJCXZtYSA9IHByZXYtPnZtX25leHQ7DQo+
ID4gPiArCQlpZiAoIXZtYSB8fCB2bWEtPnZtX3N0YXJ0ICE9IHN0YXJ0KSB7DQo+ID4gPiArCQkJ
cmV0ID0gLUVOT01FTTsNCj4gPiA+ICsJCQlnb3RvIG91dDsNCj4gPiA+ICsJCX0NCj4gPiA+ICsJ
fQ0KPiA+ID4gK291dDoNCj4gPiA+ICsJdXBfd3JpdGUoJm1tLT5tbWFwX3NlbSk7DQo+ID4gPiAr
CXJldHVybiByZXQ7DQo+ID4gPiArfQ0KPiA+ID4gKw0KPiA+ID4gK2ludCBrdm1fcHJvdGVjdF9t
ZW1vcnkoc3RydWN0IGt2bSAqa3ZtLA0KPiA+ID4gKwkJICAgICAgIHVuc2lnbmVkIGxvbmcgZ2Zu
LCB1bnNpZ25lZCBsb25nIG5wYWdlcywgYm9vbCBwcm90ZWN0KQ0KPiA+ID4gK3sNCj4gPiA+ICsJ
c3RydWN0IGt2bV9tZW1vcnlfc2xvdCAqbWVtc2xvdDsNCj4gPiA+ICsJdW5zaWduZWQgbG9uZyBz
dGFydCwgZW5kOw0KPiA+ID4gKwlnZm5fdCBudW1wYWdlczsNCj4gPiA+ICsNCj4gPiA+ICsJaWYg
KCFWTV9LVk1fUFJPVEVDVEVEKQ0KPiA+ID4gKwkJcmV0dXJuIC1LVk1fRU5PU1lTOw0KPiA+ID4g
Kw0KPiA+ID4gKwlpZiAoIW5wYWdlcykNCj4gPiA+ICsJCXJldHVybiAwOw0KPiA+ID4gKw0KPiA+
ID4gKwltZW1zbG90ID0gZ2ZuX3RvX21lbXNsb3Qoa3ZtLCBnZm4pOw0KPiA+ID4gKwkvKiBOb3Qg
YmFja2VkIGJ5IG1lbW9yeS4gSXQncyBva2F5LiAqLw0KPiA+ID4gKwlpZiAoIW1lbXNsb3QpDQo+
ID4gPiArCQlyZXR1cm4gMDsNCj4gPiA+ICsNCj4gPiA+ICsJc3RhcnQgPSBnZm5fdG9faHZhX21h
bnkobWVtc2xvdCwgZ2ZuLCAmbnVtcGFnZXMpOw0KPiA+ID4gKwllbmQgPSBzdGFydCArIG5wYWdl
cyAqIFBBR0VfU0laRTsNCj4gPiA+ICsNCj4gPiA+ICsJLyogWFhYOiBTaGFyZSByYW5nZSBhY3Jv
c3MgbWVtb3J5IHNsb3RzPyAqLw0KPiA+ID4gKwlpZiAoV0FSTl9PTihudW1wYWdlcyA8IG5wYWdl
cykpDQo+ID4gPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiA+ICsNCj4gPiA+ICsJcmV0dXJuIHBy
b3RlY3RfbWVtb3J5KHN0YXJ0LCBlbmQsIHByb3RlY3QpOw0KPiA+ID4gK30NCj4gPiA+ICtFWFBP
UlRfU1lNQk9MX0dQTChrdm1fcHJvdGVjdF9tZW1vcnkpOw0KPiA+ID4gKw0KPiA+ID4gK2ludCBr
dm1fcHJvdGVjdF9hbGxfbWVtb3J5KHN0cnVjdCBrdm0gKmt2bSkNCj4gPiA+ICt7DQo+ID4gPiAr
CXN0cnVjdCBrdm1fbWVtc2xvdHMgKnNsb3RzOw0KPiA+ID4gKwlzdHJ1Y3Qga3ZtX21lbW9yeV9z
bG90ICptZW1zbG90Ow0KPiA+ID4gKwl1bnNpZ25lZCBsb25nIHN0YXJ0LCBlbmQ7DQo+ID4gPiAr
CWludCBpLCByZXQgPSAwOzsNCj4gPiA+ICsNCj4gPiA+ICsJaWYgKCFWTV9LVk1fUFJPVEVDVEVE
KQ0KPiA+ID4gKwkJcmV0dXJuIC1LVk1fRU5PU1lTOw0KPiA+ID4gKw0KPiA+ID4gKwltdXRleF9s
b2NrKCZrdm0tPnNsb3RzX2xvY2spOw0KPiA+ID4gKwlrdm0tPm1lbV9wcm90ZWN0ZWQgPSB0cnVl
Ow0KPiA+IA0KPiA+IFdoYXQgd2lsbCBoYXBwZW4gdXBvbiBndWVzdCByZWJvb3Q/IERvIHdlIG5l
ZWQgdG8gdW5wcm90ZWN0IGV2ZXJ5dGhpbmcNCj4gPiB0byBtYWtlIHN1cmUgd2UnbGwgYmUgYWJs
ZSB0byBib290PyBBbHNvLCBhZnRlciB0aGUgcmVib290IGhvdyB3aWxsIHRoZQ0KPiA+IGd1ZXN0
IGtub3cgdGhhdCBpdCBpcyBwcm90ZWN0ZWQgYW5kIG5lZWRzIHRvIHVucHJvdGVjdCB0aGluZ3M/
IC0+IHNlZSBteQ0KPiA+IGlkZWEgYWJvdXQgY29udmVydGluZyBLVk1fSENfRU5BQkxFX01FTV9Q
Uk9URUNURUQgdG8gYSBzdGF0ZWZ1bCBNU1IgKGJ1dA0KPiA+IHdlJ2xsIGxpa2VseSBoYXZlIHRv
IHJlc2V0IGl0IHVwb24gcmVib290IGFueXdheSkuDQo+IA0KPiBUaGF0J3MgZXh0cmVtZWx5IGdv
b2QgcXVlc3Rpb24uIEkgaGF2ZSBub3QgY29uc2lkZXJlZCByZWJvb3QuIEkgdGVuZCB0byB1c2UN
Cj4gLW5vLXJlYm9vdCBpbiBteSBzZXR1cC4NCj4gDQo+IEknbGwgdGhpbmsgaG93IHRvIGRlYWwg
d2l0aCByZWJvb3QuIEkgZG9uJ3Qga25vdyBob3cgaXQgd29ya3Mgbm93IHRvIGdpdmUNCj4gYSBn
b29kIGFuc3dlci4NCj4gDQo+IFRoZSBtYXkgbm90IGJlIGEgZ29vZCBzb2x1dGlvbjogdW5wcm90
ZWN0aW5nIG1lbW9yeSBvbiByZWJvb3QgbWVhbnMgd2UNCj4gZXhwb3NlIHVzZXIgZGF0YS4gV2Ug
Y2FuIHdpcGUgdGhlIGRhdGEgYmVmb3JlIHVucHJvdGVjdGluZywgYnV0IHdlIHNob3VsZA0KPiBu
b3Qgd2lwZSBCSU9TIGFuZCBhbnl0aGluZyBlbHNlIHRoYXQgaXMgcmVxdWlyZWQgb24gcmVib290
LiBJIGRvbm5vLg0KDQpJZiB5b3UgbGV0IFFlbXUgdG8gcHJvdGVjdCBndWVzdCBtZW1vcnkgd2hl
biBjcmVhdGluZyB0aGUgdm0sIGJ1dCBub3QgYXNrIGd1ZXN0DQprZXJuZWwgdG8gZW5hYmxlIHdo
ZW4gaXQgYm9vdHMsIHlvdSB3b24ndCBoYXZlIHRoaXMgcHJvYmxlbS4gQW5kIGd1ZXN0IGtlcm5l
bA0KKnF1ZXJpZXMqIHdoZXRoZXIgaXRzIG1lbW9yeSBpcyBwcm90ZWN0ZWQgb3Igbm90IGR1cmlu
ZyBib290LiBUaGlzIGlzIGNvbnNpc3RlbnQNCnRvIFNFViBhcyB3ZWxsLg0K
