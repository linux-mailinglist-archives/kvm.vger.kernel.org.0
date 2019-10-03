Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAEECA235
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 18:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732090AbfJCQCz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 12:02:55 -0400
Received: from mail-eopbgr680045.outbound.protection.outlook.com ([40.107.68.45]:30382
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730839AbfJCQCy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 12:02:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bopfB2m0/I0kCvRMUmRLkWyhLgDthSwSp8dCiB6S7Og/Q6fq5bgGI/ZbCSiACATooQvppMyDqvk/PXluZO7b/kGXN/gQhg5FThekIalXWlIwA3WEd2r9UW7VlZluljtwP46hQSgJfHnODTFHdEqo3DQo4yDzpRehxNs1MEOJE/G3CDzl9uqXv4AVH+aElqzYdTqpz/bPmPxk7w/ebBobGewcK6vRgYR2Nx07XPPhALKz+oZQ4Ie/kWd/fRe2tysX2qQ8dnNlYDuctYHN2YuLp8hjA4TshxM0irtXdlH65Kh40atgnG7+bTJ0rPWGZPh5dHRWbFbs+dojwMHsX+6S5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SxCQK3pusOM5RTwg+3E2lOUnepypDlNnTWh1HjcY0Xc=;
 b=fcJQIXJK1YaVc0aN+vSmuUZEIFGRwUhoATS9rZrZhqSETrbBWkI+FltKjr6NgzgD5J9Bkr+mwmMh8+dMoWkEjeSlHWXPpCNHs3WeEGlWR76tRXG7RaPw5KpkFPRHuqoWbGgWhsfzWV75Jy0pLlZWQzf15SfCb3rMZ4H6XeTpZgtQwECxstPx71Q17heHhj091Jaun/OFnY4d5jKZENAqmkeG/KV9yIRjxIjlyLdJ43jxcy4TycLMIVSZkbFcPQywsqRZ/QjbzhUikXGPiAtt7rC70c4PiGAPzk3qAYc2qlWsSuxOEIHSxHUYtmXEXPmIsbMUg37tt1w0lLUKPZLOIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SxCQK3pusOM5RTwg+3E2lOUnepypDlNnTWh1HjcY0Xc=;
 b=1ZA9NGnFr0f1kQhgG3PmPA2BH9/U1LWhEj0Otcnk/Ji/wmmtYQYxqdUOX93bSALGmN936FJKohcApLJU+/flr+bTWKGajyqcmOlkDCj4R8V1OOBNH62T0nLRYquXZ8amfJK/w59cpWvxtFg/pdcmcS1IJCr6jzGj7kwZg11DHzY=
Received: from DM5PR12MB2471.namprd12.prod.outlook.com (52.132.141.138) by
 DM5PR12MB1547.namprd12.prod.outlook.com (10.172.38.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Thu, 3 Oct 2019 16:02:51 +0000
Received: from DM5PR12MB2471.namprd12.prod.outlook.com
 ([fe80::9089:8467:a76c:6f9d]) by DM5PR12MB2471.namprd12.prod.outlook.com
 ([fe80::9089:8467:a76c:6f9d%6]) with mapi id 15.20.2305.023; Thu, 3 Oct 2019
 16:02:51 +0000
From:   "Moger, Babu" <Babu.Moger@amd.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>
CC:     Aaron Lewis <aaronlewis@google.com>,
        kvm list <kvm@vger.kernel.org>,
        "Natarajan, Janakarajan" <Janakarajan.Natarajan@amd.com>
Subject: Re: [Patch] KVM: SVM: Fix svm_xsaves_supported
Thread-Topic: [Patch] KVM: SVM: Fix svm_xsaves_supported
Thread-Index: AQHVYrXJP10t9r+KHEKUgXki1Eom9acbvH4AgAM2fQCABB/vAIAmL6yA
Date:   Thu, 3 Oct 2019 16:02:51 +0000
Message-ID: <17bf8eb1-a63d-8081-776f-930133ea26e1@amd.com>
References: <20190904001422.11809-1-aaronlewis@google.com>
 <87o900j98f.fsf@vitty.brq.redhat.com>
 <CALMp9eRbDAB0NF=WVjHJWJNPgsTfE_s+4CeGMkpJpXSGP9zOyg@mail.gmail.com>
 <87sgp5g88z.fsf@vitty.brq.redhat.com>
In-Reply-To: <87sgp5g88z.fsf@vitty.brq.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR06CA0005.namprd06.prod.outlook.com
 (2603:10b6:805:8e::18) To DM5PR12MB2471.namprd12.prod.outlook.com
 (2603:10b6:4:b5::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Babu.Moger@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a796f6f8-0f8c-4833-f24a-08d7481b2475
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DM5PR12MB1547:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR12MB1547367B7503B167DFA7ECAE959F0@DM5PR12MB1547.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01792087B6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(346002)(39860400002)(396003)(136003)(189003)(199004)(99286004)(86362001)(476003)(31696002)(486006)(446003)(2616005)(71200400001)(6512007)(256004)(26005)(6246003)(186003)(71190400001)(6436002)(11346002)(52116002)(316002)(110136005)(6486002)(102836004)(4326008)(229853002)(54906003)(53546011)(6506007)(386003)(14454004)(81156014)(81166006)(8676002)(8936002)(25786009)(478600001)(76176011)(31686004)(2906002)(7736002)(36756003)(3846002)(6116002)(66066001)(66476007)(5660300002)(66946007)(64756008)(305945005)(66556008)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1547;H:DM5PR12MB2471.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8OtZnhAFox07Cdcud9ukkaYKAA7YMg8XCSZCcuB1wAlvXOdnntJWhRw3lESja2ud+nkOHWNTydQttrO8ipoG2mPxpy6XnlHU+bdFf7VLgBNaAyGZyr+jVD5qljCqprkOtqjit0Xs3XuKEyPYEX/R2o5K/Brf32Ty/ScsR6ZvwYBlZnmeRUadooGc+XBi2rLTt7X+jf67oi7SgOxjBWUNxxFL/VrmEAg1gVZ7ib7QR6ABKVP9i6VwcX6P0ZgXrvBgJgwiSD5N9O0ynzMGZ4sD6eOfTL2nIUSFrGyN5JBTJB3Td7UtJFVpqojtCxd+M5MCaATnyJ2PICEPbMzRh+ko9lh5qACEIElFS6K9mKL1MYuM5+FSd/Y7XPXPtRkOvkzRvkn8jDghgQAd0BmxzOMZt3GIeP5gtyECTQ83ijD6+00=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8140BA12E09D4147844C4DF22000F6B3@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a796f6f8-0f8c-4833-f24a-08d7481b2475
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2019 16:02:51.1549
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qdw81eKZQx8KXXfdfUXcyfv7D6d0gM9Y8GSPT1Pu7dgeQba0EoBgxu4qiXuQdpme
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1547
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCk9uIDkvOS8xOSAzOjU0IEFNLCBWaXRhbHkgS3V6bmV0c292IHdyb3RlOg0KPiBKaW0gTWF0
dHNvbiA8am1hdHRzb25AZ29vZ2xlLmNvbT4gd3JpdGVzOg0KPiANCj4+IE9uIFdlZCwgU2VwIDQs
IDIwMTkgYXQgOTo1MSBBTSBWaXRhbHkgS3V6bmV0c292IDx2a3V6bmV0c0ByZWRoYXQuY29tPiB3
cm90ZToNCj4+DQo+Pj4gQ3VycmVudGx5LCBWTVggY29kZSBvbmx5IHN1cHBvcnRzIHdyaXRpbmcg
JzAnIHRvIE1TUl9JQTMyX1hTUzoNCj4+Pg0KPj4+ICAgICAgICAgY2FzZSBNU1JfSUEzMl9YU1M6
DQo+Pj4gICAgICAgICAgICAgICAgIGlmICghdm14X3hzYXZlc19zdXBwb3J0ZWQoKSB8fA0KPj4+
ICAgICAgICAgICAgICAgICAgICAgKCFtc3JfaW5mby0+aG9zdF9pbml0aWF0ZWQgJiYNCj4+PiAg
ICAgICAgICAgICAgICAgICAgICAhKGd1ZXN0X2NwdWlkX2hhcyh2Y3B1LCBYODZfRkVBVFVSRV9Y
U0FWRSkgJiYNCj4+PiAgICAgICAgICAgICAgICAgICAgICAgIGd1ZXN0X2NwdWlkX2hhcyh2Y3B1
LCBYODZfRkVBVFVSRV9YU0FWRVMpKSkpDQo+Pj4gICAgICAgICAgICAgICAgICAgICAgICAgcmV0
dXJuIDE7DQo+Pj4gICAgICAgICAgICAgICAgIC8qDQo+Pj4gICAgICAgICAgICAgICAgICAqIFRo
ZSBvbmx5IHN1cHBvcnRlZCBiaXQgYXMgb2YgU2t5bGFrZSBpcyBiaXQgOCwgYnV0DQo+Pj4gICAg
ICAgICAgICAgICAgICAqIGl0IGlzIG5vdCBzdXBwb3J0ZWQgb24gS1ZNLg0KPj4+ICAgICAgICAg
ICAgICAgICAgKi8NCj4+PiAgICAgICAgICAgICAgICAgaWYgKGRhdGEgIT0gMCkNCj4+PiAgICAg
ICAgICAgICAgICAgICAgICAgICByZXR1cm4gMTsNCj4+Pg0KPj4+DQo+Pj4gd2Ugd2lsbCBwcm9i
YWJseSBuZWVkIHRoZSBzYW1lIGxpbWl0YXRpb24gZm9yIFNWTSwgaG93ZXZlciwgSSdkIHZvdGUg
Zm9yDQo+Pj4gY3JlYXRpbmcgc2VwYXJhdGUga3ZtX3g4Nl9vcHMtPnNldF94c3MoKSBpbXBsZW1l
bnRhdGlvbnMuDQo+Pg0KPj4gSSBob3BlIHNlcGFyYXRlIGltcGxlbWVudGF0aW9ucyBhcmUgdW5u
ZWNlc3NhcnkuIFRoZSBhbGxvd2VkIElBMzJfWFNTDQo+PiBiaXRzIHNob3VsZCBiZSBkZXJpdmFi
bGUgZnJvbSBndWVzdF9jcHVpZF9oYXMoKSBpbiBhDQo+PiB2ZW5kb3ItaW5kZXBlbmRlbnQgd2F5
LiBPdGhlcndpc2UsIHRoZSBDUFUgdmVuZG9ycyBoYXZlIG1lc3NlZCB1cC4gOi0pDQo+Pg0KPj4g
QXQgcHJlc2VudCwgd2UgdXNlIHRoZSBNU1ItbG9hZCBhcmVhIHRvIHN3YXAgZ3Vlc3QvaG9zdCB2
YWx1ZXMgb2YNCj4+IElBMzJfWFNTIG9uIEludGVsICh3aGVuIHRoZSBob3N0IGFuZCBndWVzdCB2
YWx1ZXMgZGlmZmVyKSwgYnV0IGl0DQo+PiBzZWVtcyB0byBtZSB0aGF0IElBMzJfWFNTIGFuZCAl
eGNyMCBzaG91bGQgYmUgc3dhcHBlZCBhdCB0aGUgc2FtZQ0KPj4gdGltZSwgaW4ga3ZtX2xvYWRf
Z3Vlc3RfeGNyMC9rdm1fcHV0X2d1ZXN0X3hjcjAuIFRoaXMgcG90ZW50aWFsbHkgYWRkcw0KPj4g
YW4gYWRkaXRpb25hbCBMMSBXUk1TUiBWTS1leGl0IHRvIGV2ZXJ5IGVtdWxhdGVkIFZNLWVudHJ5
IG9yIFZNLWV4aXQNCj4+IGZvciBuVk1YLCBidXQgc2luY2UgdGhlIGhvc3QgY3VycmVudGx5IHNl
dHMgSUEzMl9YU1MgdG8gMCBhbmQgd2Ugb25seQ0KPj4gYWxsb3cgdGhlIGd1ZXN0IHRvIHNldCBJ
QTMyX1hTUyB0byAwLCB3ZSBjYW4gcHJvYmFibHkgd29ycnkgYWJvdXQgdGhpcw0KPj4gbGF0ZXIu
DQo+IA0KPiBZZWEsIEkgd2FzIHN1Z2dlc3RpbmcgdG8gc3BsaXQgaW1wbGVtZW50YXRpb25zIGFz
IGEgZnV0dXJlIHByb29mIGJ1dCBhDQo+IGNvbW1lbnQgbGlrZSAiVGhpcyBvdWdodCB0byBiZSAw
IGZvciBub3ciIHdvdWxkIGFsc28gZG8pDQoNCkhpLCBBbnlvbmUgYWN0aXZlbHkgd29ya2luZyBv
biB0aGlzPw0KDQpJIHdhcyB0cnlpbmcgdG8gZXhwb3NlIHhzYXZlcyBvbiBBTUQgcWVtdSBndWVz
dC4gRm91bmQgb3V0IHRoYXQgd2UgbmVlZCB0bw0KZ2V0IHRoaXMgYWJvdmUgY29kZSB3b3JraW5n
IGJlZm9yZSBJIGNhbiBleHBvc2UgeHNhdmVzIG9uIGd1ZXN0LiBJIGNhbg0KcmUtcG9zdCB0aGVz
ZSBwYXRjaGVzIGlmIGl0IGlzIG9rLg0KDQpTb3JyeSwgSSBkb250IGhhdmUgdGhlIGNvbXBsZXRl
IGJhY2tncm91bmQuIEZyb20gd2hhdCBJIHVuZGVyc3Rvb2QsIHdlDQpuZWVkIHRvIGFkZCB0aGUg
c2FtZSBjaGVjayBhcyBJbnRlbCBmb3IgTVNSX0lBMzJfWFNTIGluIGdldF9tc3IgYW5kIHNldF9t
c3IuDQoNCnN0YXRpYyBpbnQgdm14X2dldF9tc3Ioc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1
Y3QgbXNyX2RhdGEgKm1zcl9pbmZvKQ0Kew0KLi4NCg0KIGNhc2UgTVNSX0lBMzJfWFNTOg0KICAg
ICAgICAgICAgICAgIGlmICghdm14X3hzYXZlc19zdXBwb3J0ZWQoKSB8fA0KICAgICAgICAgICAg
ICAgICAgICAoIW1zcl9pbmZvLT5ob3N0X2luaXRpYXRlZCAmJg0KICAgICAgICAgICAgICAgICAg
ICAgIShndWVzdF9jcHVpZF9oYXModmNwdSwgWDg2X0ZFQVRVUkVfWFNBVkUpICYmDQogICAgICAg
ICAgICAgICAgICAgICAgIGd1ZXN0X2NwdWlkX2hhcyh2Y3B1LCBYODZfRkVBVFVSRV9YU0FWRVMp
KSkpDQogICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gMTsNCiAgICAgICAgICAgICAgICBt
c3JfaW5mby0+ZGF0YSA9IHZjcHUtPmFyY2guaWEzMl94c3M7DQogICAgICAgICAgICAgICAgYnJl
YWs7DQouLg0KLi4NCn0NCg0Kc3RhdGljIGludCB2bXhfc2V0X21zcihzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHUsIHN0cnVjdCBtc3JfZGF0YSAqbXNyX2luZm8pDQp7DQouLg0KLi4NCiAgY2FzZSBNU1Jf
SUEzMl9YU1M6DQogICAgICAgICAgICAgICAgaWYgKCF2bXhfeHNhdmVzX3N1cHBvcnRlZCgpIHx8
DQogICAgICAgICAgICAgICAgICAgICghbXNyX2luZm8tPmhvc3RfaW5pdGlhdGVkICYmDQogICAg
ICAgICAgICAgICAgICAgICAhKGd1ZXN0X2NwdWlkX2hhcyh2Y3B1LCBYODZfRkVBVFVSRV9YU0FW
RSkgJiYNCiAgICAgICAgICAgICAgICAgICAgICAgZ3Vlc3RfY3B1aWRfaGFzKHZjcHUsIFg4Nl9G
RUFUVVJFX1hTQVZFUykpKSkNCiAgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiAxOw0KICAg
ICAgICAgICAgICAgIC8qDQogICAgICAgICAgICAgICAgICogVGhlIG9ubHkgc3VwcG9ydGVkIGJp
dCBhcyBvZiBTa3lsYWtlIGlzIGJpdCA4LCBidXQNCiAgICAgICAgICAgICAgICAgKiBpdCBpcyBu
b3Qgc3VwcG9ydGVkIG9uIEtWTS4NCiAgICAgICAgICAgICAgICAgKi8NCiAgICAgICAgICAgICAg
ICBpZiAoZGF0YSAhPSAwKQ0KICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIDE7DQogICAg
ICAgICAgICAgICAgdmNwdS0+YXJjaC5pYTMyX3hzcyA9IGRhdGE7DQogICAgICAgICAgICAgICAg
aWYgKHZjcHUtPmFyY2guaWEzMl94c3MgIT0gaG9zdF94c3MpDQogICAgICAgICAgICAgICAgICAg
ICAgICBhZGRfYXRvbWljX3N3aXRjaF9tc3Iodm14LCBNU1JfSUEzMl9YU1MsDQogICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHZjcHUtPmFyY2guaWEzMl94c3MsIGhvc3RfeHNzLCBmYWxz
ZSk7DQogICAgICAgICAgICAgICAgZWxzZQ0KICAgICAgICAgICAgICAgICAgICAgICAgY2xlYXJf
YXRvbWljX3N3aXRjaF9tc3Iodm14LCBNU1JfSUEzMl9YU1MpOw0KICAgICAgICAgICAgICAgIGJy
ZWFrOw0KLi4uDQp9DQoNCldlIHByb2JhYmx5IGRvbid0IG5lZWQgbGFzdCAiaWYgJiBlbHNlIiBj
aGVjayBhcyB3ZSBhcmUgc2V0dGluZyBpdCAwIG5vdy4NCkRvZXMgdGhpcyBsb29rIGFjY3VyYXRl
Pw0K
