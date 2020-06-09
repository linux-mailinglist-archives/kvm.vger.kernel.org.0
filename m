Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEDC21F3210
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 03:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgFIBmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 21:42:03 -0400
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:28860 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726013AbgFIBmC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Jun 2020 21:42:02 -0400
X-Greylist: delayed 2206 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Jun 2020 21:42:01 EDT
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05913cHg031324;
        Mon, 8 Jun 2020 18:04:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=3e0HuZCtF/ZexLHAyM2lxcqjazfi0aFZWeQUGbs/ybw=;
 b=qzQC9A8TPgdhV9/5xD8mtcNffk3kJrQ1r5Yb7zV5V5wB8GPnFaB0345ylHa3g/qVRSpq
 DsYUl2E0/1zbv15NZlyH3ehwH9WioZr3W0GdcGVh8HEHxZ8SdlS6R4eMSGbEZZZ1y6Qr
 Yw2YCCYPvVvvcgg+cIpO/l6nYYMLcvRpjRKwiosLqCX5AAqFeZhHH2ma5VLLpvMCdtCx
 CZuso6RsUczHBBOEY5OMtBbV23zXuwu965B31dXCkO4mLTNukwBwp5f+aKWb2qX00WdO
 xeOqs5urA4KbxEE8P50YeTUahm1rnekieJC23OTffeQbPd85KcYtIKGle/hQLV0TwtAd Gg== 
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2058.outbound.protection.outlook.com [104.47.38.58])
        by mx0b-002c1b01.pphosted.com with ESMTP id 31gaffd17d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 18:04:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BSGXfkRf+Onn00+OUGuo73CO56NicdsVNl4iY20pYhijkQGr5XI0t5OiCFrJuLI6dw95XuwN8hlw70EoyOjtWH3R7czyNr0bkpp603fqo1RA74FP8UJ8uhYNQfVhjB2HL3GjWL2/E8YXMkHN+csAzIZ6zhFihZiT/aysyfiOdqctQgxuJ1T3I7ji2WqCoaIV/rETMKsXHuFwk6nP610pzfXyZ3L+NwTQI4aiKpDgVV167G3nBC8oeXFr5OTj3GKnKlqNzj5Gq9v2gS31YjjGyHB+oQARYofoY7o421cYV1haTIE4pj2RgmvaCYd8NR4+wAV8qmF3dKQ+kXFrav/tEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3e0HuZCtF/ZexLHAyM2lxcqjazfi0aFZWeQUGbs/ybw=;
 b=Z7xRCnPJTelGpaicvxdUNJlPWVVVIFpgexa/Kb2oE50ifDzlkm+jJZhDBIryQyL5rlZ1TwiMrvRqjZxgOMAz2k02rt/oSBDuldE/3yctYBk1oDhbiVkpSGat57OxJUVij+EJfunF04PNvzx3ZwzmqoazNk7UKfiR5HBZePezh1gaTsplMDxDwhnSbOQzASEoOE04reReHqZXjhpY6i7isT73v/kqU1ZIMH3LrKTkeMvel5/pMZC4NgmV5RiER8zJ/RqjAVTP16iuBVXoJTuC72BuNXYjs+LBi7ySb83SesH8+PiEfbjscO2uzHHu7gWOUcx+NgOknDncVIBenGCR6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BY5PR02MB6690.namprd02.prod.outlook.com (2603:10b6:a03:213::10)
 by BY5PR02MB6916.namprd02.prod.outlook.com (2603:10b6:a03:234::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.20; Tue, 9 Jun
 2020 01:04:04 +0000
Received: from BY5PR02MB6690.namprd02.prod.outlook.com
 ([fe80::6ceb:66bd:bb5f:179e]) by BY5PR02MB6690.namprd02.prod.outlook.com
 ([fe80::6ceb:66bd:bb5f:179e%9]) with mapi id 15.20.3066.023; Tue, 9 Jun 2020
 01:04:03 +0000
From:   Eiichi Tsukata <eiichi.tsukata@nutanix.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Franciosi <felipe@nutanix.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC PATCH] KVM: x86: Fix APIC page invalidation race
Thread-Topic: [RFC PATCH] KVM: x86: Fix APIC page invalidation race
Thread-Index: AQHWO7rKzyOSDfpNlUO9aScE6IXasajOtaaAgADGnYA=
Date:   Tue, 9 Jun 2020 01:04:03 +0000
Message-ID: <7B9024C7-98D0-4940-91AE-40BCDE555C8F@nutanix.com>
References: <20200606042627.61070-1-eiichi.tsukata@nutanix.com>
 <0d9b3313-5d4c-9ef3-63e4-ba08ddbbe7a1@redhat.com>
In-Reply-To: <0d9b3313-5d4c-9ef3-63e4-ba08ddbbe7a1@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nutanix.com;
x-originating-ip: [39.110.210.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dcf72b40-4812-46d4-d595-08d80c1100bf
x-ms-traffictypediagnostic: BY5PR02MB6916:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR02MB6916843386E1FC831E6189EA80820@BY5PR02MB6916.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 042957ACD7
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D2qEtMVYQRyw93fu5ADlNXHeZFGatE4qJL7nGVOHhcyaJDugw0oq0MU3nCXfVnBXT1MkuDHyo+iviEjcU3+q4FUrMrxNRVX1qMwKlQ8mY7103exeD23/OJbrT6bZPNESxIdWSlbQ4nKXRKcDUMKENMA/wPL5NTNtpcCkRamp+edECkiIbtYKZIvvifmHzr1JVsRBA7CjLkz+JRtgoshp/fA1k5RL8dKq+rD/nCPIVogKQOJRLdVacWDulr4eGaBr1QghS1oSaMBtEGrafO97kdV35Dn3E3cYE4KmH/HDWKxBlruDAqnCkddMwTglH5jF/qjGgtmJZRF7Kh0WQWBGCh5F7iB/rW9EiEgbQGBjtYL/dx42D/u8sYF45l12b73t/atR36n+0TCxihUarpA5+A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR02MB6690.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(396003)(39860400002)(376002)(136003)(366004)(186003)(4326008)(76116006)(6916009)(66946007)(36756003)(966005)(66476007)(53546011)(66556008)(66446008)(54906003)(26005)(6512007)(478600001)(6486002)(6506007)(83380400001)(64756008)(71200400001)(44832011)(316002)(7416002)(5660300002)(2906002)(8676002)(86362001)(33656002)(2616005)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 1Ov8UeC78fGsrXcrzUOjGgYbuyzBPdQfcAJCEzedhtiKkurccb4ox0ayapQt5tDFeNfdnZy8tq2+Ac3yHXZvtewktAHOYvkl7/TtbX2vbJoY/3nyTj2/VFM/SpMIyI+w0db0Tt6ZNYWYG/B1ghybwZitiVQfcmnfAIv1Gx0Yq929u6G0O3HDAKF7Q70LnjATQ92nlZ5G0ywuFNmBJPEpPhrex/L3p9rGE+G3aSB4MBj9lj8ero4BeQFOe02/OHw7boEt4Z25X6Lm0Ypp/h5UpQVL34H76IFbBPgXsaj1Us6pjEALmsyyhqgYLHks40CWvQ4Z5QN/3tMlFo1RJdoKiYLSDhqjRfaTpORtWOy0uK5Hu/+yyBUvkjGaFFh3Wd6LuVkfhCmBGKxdm8Erq2EyC2L4BXS4F/uXktXrrfHtLgOHhiDW8T+CvKWTaGt1WNfn/X4Gq2RK4ZLRxBBar5YTEoyvbL25g4brrs4IbPrwz9rB7oXcIZa9npKU+4vF5ol1
Content-Type: text/plain; charset="utf-8"
Content-ID: <87A50056817B1C48800156A5EFCAC557@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcf72b40-4812-46d4-d595-08d80c1100bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2020 01:04:03.7821
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n8Kl7jE9GOYsXTTat4qCg64dpXQUpXe+OiuD6l9tvz3ir+NIN9nY61n0hKKzUtEDE77crMmajLlbDOeYrhI4VOQGPg5fbd3l8ZT40AuCOOI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6916
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-08_18:2020-06-08,2020-06-08 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gSnVuIDgsIDIwMjAsIGF0IDIyOjEzLCBQYW9sbyBCb256aW5pIDxwYm9uemluaUBy
ZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+IE9uIDA2LzA2LzIwIDA2OjI2LCBFaWljaGkgVHN1a2F0
YSB3cm90ZToNCj4+IENvbW1pdCBiMTM5NGU3NDViOTQgKCJLVk06IHg4NjogZml4IEFQSUMgcGFn
ZSBpbnZhbGlkYXRpb24iKSB0cmllZCB0bw0KPj4gZml4IGluYXBwcm9wcmlhdGUgQVBJQyBwYWdl
IGludmFsaWRhdGlvbiBieSByZS1pbnRyb2R1Y2luZyBhcmNoIHNwZWNpZmljDQo+PiBrdm1fYXJj
aF9tbXVfbm90aWZpZXJfaW52YWxpZGF0ZV9yYW5nZSgpIGFuZCBjYWxsaW5nIGl0IGZyb20NCj4+
IGt2bV9tbXVfbm90aWZpZXJfaW52YWxpZGF0ZV9yYW5nZV9zdGFydC4gQnV0IHRocmVyZSBjb3Vs
ZCBiZSB0aGUNCj4+IGZvbGxvd2luZyByYWNlIGJlY2F1c2UgVk1DUyBBUElDIGFkZHJlc3MgY2Fj
aGUgY2FuIGJlIHVwZGF0ZWQNCj4+ICpiZWZvcmUqIGl0IGlzIHVubWFwcGVkLg0KPj4gDQo+PiBS
YWNlOg0KPj4gIChJbnZhbGlkYXRvcikga3ZtX21tdV9ub3RpZmllcl9pbnZhbGlkYXRlX3Jhbmdl
X3N0YXJ0KCkNCj4+ICAoSW52YWxpZGF0b3IpIGt2bV9tYWtlX2FsbF9jcHVzX3JlcXVlc3Qoa3Zt
LCBLVk1fUkVRX0FQSUNfUEFHRV9SRUxPQUQpDQo+PiAgKEtWTSBWQ1BVKSB2Y3B1X2VudGVyX2d1
ZXN0KCkNCj4+ICAoS1ZNIFZDUFUpIGt2bV92Y3B1X3JlbG9hZF9hcGljX2FjY2Vzc19wYWdlKCkN
Cj4+ICAoSW52YWxpZGF0b3IpIGFjdHVhbGx5IHVubWFwIHBhZ2UNCj4+IA0KPj4gU3ltcHRvbToN
Cj4+ICBUaGUgYWJvdmUgcmFjZSBjYW4gbWFrZSBHdWVzdCBPUyBzZWUgYWxyZWFkeSBmcmVlZCBw
YWdlIGFuZCBHdWVzdCBPUw0KPj4gd2lsbCBzZWUgYnJva2VuIEFQSUMgcmVnaXN0ZXIgdmFsdWVz
Lg0KPiANCj4gVGhpcyBpcyBub3QgZXhhY3RseSB0aGUgaXNzdWUuICBUaGUgdmFsdWVzIGluIHRo
ZSBBUElDLWFjY2VzcyBwYWdlIGRvDQo+IG5vdCByZWFsbHkgbWF0dGVyLCB0aGUgcHJvYmxlbSBp
cyB0aGF0IHRoZSBob3N0IHBoeXNpY2FsIGFkZHJlc3MgdmFsdWVzDQo+IHdvbid0IG1hdGNoIGJl
dHdlZW4gdGhlIHBhZ2UgdGFibGVzIGFuZCB0aGUgQVBJQy1hY2Nlc3MgcGFnZSBhZGRyZXNzLg0K
PiBUaGVuIHRoZSBwcm9jZXNzb3Igd2lsbCBub3QgdHJhcCBBUElDIGFjY2Vzc2VzLCBhbmQgd2ls
bCBpbnN0ZWFkIHNob3cNCj4gdGhlIHJhdyBjb250ZW50cyBvZiB0aGUgQVBJQy1hY2Nlc3MgcGFn
ZSAoemVyb2VzKSwgYW5kIGNhdXNlIHRoZSBjcmFzaA0KPiBhcyB5b3UgbWVudGlvbiBiZWxvdy4N
Cj4gDQo+IFN0aWxsLCB0aGUgcmFjZSBleHBsYWlucyB0aGUgc3ltcHRvbXMgYW5kIHRoZSBwYXRj
aCBtYXRjaGVzIHRoaXMgdGV4dCBpbg0KPiBpbmNsdWRlL2xpbnV4L21tdV9ub3RpZmllci5oOg0K
PiANCj4gCSAqIElmIHRoZSBzdWJzeXN0ZW0NCj4gICAgICAgICAqIGNhbid0IGd1YXJhbnRlZSB0
aGF0IG5vIGFkZGl0aW9uYWwgcmVmZXJlbmNlcyBhcmUgdGFrZW4gdG8NCj4gICAgICAgICAqIHRo
ZSBwYWdlcyBpbiB0aGUgcmFuZ2UsIGl0IGhhcyB0byBpbXBsZW1lbnQgdGhlDQo+ICAgICAgICAg
KiBpbnZhbGlkYXRlX3JhbmdlKCkgbm90aWZpZXIgdG8gcmVtb3ZlIGFueSByZWZlcmVuY2VzIHRh
a2VuDQo+ICAgICAgICAgKiBhZnRlciBpbnZhbGlkYXRlX3JhbmdlX3N0YXJ0KCkuDQo+IA0KPiB3
aGVyZSB0aGUgImFkZGl0aW9uYWwgcmVmZXJlbmNlIiBpcyBpbiB0aGUgVk1DUzogYmVjYXVzZSB3
ZSBoYXZlIHRvDQo+IGFjY291bnQgZm9yIGt2bV92Y3B1X3JlbG9hZF9hcGljX2FjY2Vzc19wYWdl
IHJ1bm5pbmcgYmV0d2Vlbg0KPiBpbnZhbGlkYXRlX3JhbmdlX3N0YXJ0KCkgYW5kIGludmFsaWRh
dGVfcmFuZ2VfZW5kKCksIHdlIG5lZWQgdG8NCj4gaW1wbGVtZW50IGludmFsaWRhdGVfcmFuZ2Uo
KS4NCj4gDQo+IFRoZSBwYXRjaCBzZWVtcyBnb29kLCBidXQgSSdkIGxpa2UgQW5kcmVhIEFyY2Fu
Z2VsaSB0byB0YWtlIGEgbG9vayBhcw0KPiB3ZWxsIHNvIEkndmUgQ0NlZCBoaW0uDQo+IA0KPiBU
aGFuayB5b3UgdmVyeSBtdWNoIQ0KPiANCj4gUGFvbG8NCj4gDQoNCkhlbGxvIFBhb2xvDQoNClRo
YW5rcyBmb3IgZGV0YWlsZWQgZXhwbGFuYXRpb24hDQpJ4oCZbGwgZml4IHRoZSBjb21taXQgbWVz
c2FnZSBsaWtlIHRoaXM6DQoNCmBgYA0KU3ltcHRvbToNCiAgVGhlIGFib3ZlIHJhY2UgY2FuIGNh
dXNlIG1pc21hdGNoIGJldHdlZW4gdGhlIHBhZ2UgdGFibGVzIGFuZCB0aGUNCkFQSUMtYWNjZXNz
IHBhZ2UgYWRkcmVzcyBpbiBWTUNTLlRoZW4gdGhlIHByb2Nlc3NvciB3aWxsIG5vdCB0cmFwIEFQ
SUMNCmFjY2Vzc2VzLCBhbmQgd2lsbCBpbnN0ZWFkIHNob3cgdGhlIHJhdyBjb250ZW50cyBvZiB0
aGUgQVBJQy1hY2Nlc3MgcGFnZQ0KKHplcm9lcykuIEVzcGVjaWFsbHksIFdpbmRvd3MgT1MgY2hl
Y2tzIExBUElDIG1vZGlmaWNhdGlvbiBzbyBpdCBjYW4gY2F1c2UNCkJTT0QgY3Jhc2ggd2l0aCBC
dWdDaGVjayBDUklUSUNBTF9TVFJVQ1RVUkVfQ09SUlVQVElPTiAoMTA5KS4gVGhlc2Ugc3ltcHRv
bXMNCmFyZSB0aGUgc2FtZSBhcyB3ZSBwcmV2aW91c2x5IHNhdyBpbg0KaHR0cHM6Ly9idWd6aWxs
YS5rZXJuZWwub3JnL3Nob3dfYnVnLmNnaT9pZD0xOTc5NTENCmFuZCB3ZSBhcmUgY3VycmVudGx5
IHNlZWluZyBpbg0KaHR0cHM6Ly9idWd6aWxsYS5yZWRoYXQuY29tL3Nob3dfYnVnLmNnaT9pZD0x
NzUxMDE3Lg0KDQpUbyBwcmV2ZW50IG1pc21hdGNoIGJldHdlZW4gcGFnZSB0YWJsZXMgYW5kIEFQ
SUMtYWNjZXNzIHBhZ2UgYWRkcmVzcywNCnRoaXMgcGF0Y2ggY2FsbHMga3ZtX2FyY2hfbW11X25v
dGlmaWVyX2ludmFsaWRhdGVfcmFuZ2UoKSBmcm9tDQprdm1fbW11X25vdGlmaWVyX2ludmFsaWRh
dGVfcmFuZ2UoKSBpbnN0ZWFkIG9mIC4uLl9yYW5nZV9zdGFydCgpLg0KV2UgbmVlZCB0byBpbXBs
ZW1lbnQgaW52YWxpZGF0ZV9yYW5nZSgpIGJlY2F1c2Ugd2UgaGF2ZSB0bw0KYWNjb3VudCBmb3Ig
a3ZtX3ZjcHVfcmVsb2FkX2FwaWNfYWNjZXNzX3BhZ2UoKSBydW5uaW5nIGJldHdlZW4NCmludmFs
aWRhdGVfcmFuZ2Vfc3RhcnQoKSBhbmQgaW52YWxpZGF0ZV9yYW5nZV9lbmQoKS4NCmBgYA0KDQoN
CkJlc3QNCg0KRWlpY2hpDQoNCg==
