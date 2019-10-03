Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32143CAB2D
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 19:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732416AbfJCRSv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 13:18:51 -0400
Received: from mail-eopbgr720057.outbound.protection.outlook.com ([40.107.72.57]:7944
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389905AbfJCQUe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 12:20:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mmg+HVfaOpHnslf9lvCsk33r1mHxUde+6WVZQYGYCAzRWwlgQdageS9sqrwPj391sYDM9Nq9hRUaKwkxGhffIeoOurGHs0/nEM0dnZEXzgBlixxjeMAguMnWULptDfWhjmZcGe1KKd8qXuZGWSk5wenbiWosonNhMJ17xrnOQ9qJKD9OtI+l2EcdeoJ2Z34ZDzhdOfdwppazTSnmw+zKME/iZIQXrlgJr/PcbA6X8Fzm4xnknB47dF0qI/Tqt0TqUILykc+vK+0xzjiaAdinAz6KYa1oI2SPcbvv8gzk7/tMkhx1o51J3pc5zOz6uteUOf+vjxTzq93bSYbyMIOCWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lv25nK+ojMzECCWa9fBjp6glzi/C37/KWaRcIyIRVeQ=;
 b=R0gKNZmFOu/GnYKRHSHs4hx1gG80McwalS/3c2TiQJphi/QlWxGPkY/8bRa8VGI7x+YhEJl1GGGAoeI7wFyW15q3rDmUBgXwnM5ex05sZr3OMhQbvwPkKPwRYM8/ZxYVJUirahO0rSyZTQGPOKuBC8ztc6mL7ReD3RFWYksO9+ePrt2WfaMP1KTTYcH+P3vOjh7qC/ZN0ng5JpNnrVEIKTUQCCec8Wp1bK2lSIy9cxV9GyMiThpePfry1PrWZsiVFrIIWIiGhN6WgHPcGL6l/a8GZPKoHnySNxOL9MtBi2dxmJFmhrlkONt9cGTDQmZo4xkEU2SoYrowTFpHSwGZuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lv25nK+ojMzECCWa9fBjp6glzi/C37/KWaRcIyIRVeQ=;
 b=HKw5sVCYoYGTUpYGmFGee40CMG/5c6x5UA/PozsrkTZoj+XhOWfMJSi+jQscABfzqSzfQN6lva/ypiVvjEEiWiP/mvF/5dlcJwHXBvfP1JBSOb//9Zl2VMOF+6Xhw06Qhj5tyCTZDOkZXtNzkcw69wUYCzYsAGBJUpwHmsA46ZM=
Received: from DM5PR12MB2471.namprd12.prod.outlook.com (52.132.141.138) by
 DM5PR12MB1164.namprd12.prod.outlook.com (10.168.238.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.18; Thu, 3 Oct 2019 16:20:32 +0000
Received: from DM5PR12MB2471.namprd12.prod.outlook.com
 ([fe80::9089:8467:a76c:6f9d]) by DM5PR12MB2471.namprd12.prod.outlook.com
 ([fe80::9089:8467:a76c:6f9d%6]) with mapi id 15.20.2305.023; Thu, 3 Oct 2019
 16:20:32 +0000
From:   "Moger, Babu" <Babu.Moger@amd.com>
To:     Jim Mattson <jmattson@google.com>
CC:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>,
        kvm list <kvm@vger.kernel.org>,
        "Natarajan, Janakarajan" <Janakarajan.Natarajan@amd.com>
Subject: RE: [Patch] KVM: SVM: Fix svm_xsaves_supported
Thread-Topic: [Patch] KVM: SVM: Fix svm_xsaves_supported
Thread-Index: AQHVYrXJP10t9r+KHEKUgXki1Eom9acbvH4AgAM2fQCABB/vAIAl29qAgABXPYCAAAEr8A==
Date:   Thu, 3 Oct 2019 16:20:32 +0000
Message-ID: <DM5PR12MB2471BF88CE676019071B55EF959F0@DM5PR12MB2471.namprd12.prod.outlook.com>
References: <20190904001422.11809-1-aaronlewis@google.com>
 <87o900j98f.fsf@vitty.brq.redhat.com>
 <CALMp9eRbDAB0NF=WVjHJWJNPgsTfE_s+4CeGMkpJpXSGP9zOyg@mail.gmail.com>
 <87sgp5g88z.fsf@vitty.brq.redhat.com>
 <17bf8eb1-a63d-8081-776f-930133ea26e1@amd.com>
 <CALMp9eQVFnFB8p=10H4oDzw6TwAEFRNkyAQOpKNi8L0x_r+ivw@mail.gmail.com>
In-Reply-To: <CALMp9eQVFnFB8p=10H4oDzw6TwAEFRNkyAQOpKNi8L0x_r+ivw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Babu.Moger@amd.com; 
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d7c45ae8-43bd-4d4e-4464-08d7481d9d0e
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DM5PR12MB1164:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR12MB116450FBFCB9362D3DAE6D1D959F0@DM5PR12MB1164.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01792087B6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(366004)(396003)(136003)(13464003)(189003)(199004)(54906003)(186003)(6436002)(6506007)(76176011)(478600001)(316002)(25786009)(52536014)(26005)(66446008)(76116006)(5660300002)(55016002)(74316002)(66556008)(86362001)(64756008)(14454004)(256004)(446003)(66066001)(14444005)(11346002)(71190400001)(53546011)(7696005)(71200400001)(99286004)(102836004)(486006)(476003)(8936002)(81156014)(8676002)(229853002)(9686003)(2906002)(6916009)(33656002)(4326008)(7736002)(66946007)(305945005)(3846002)(81166006)(6116002)(6246003)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1164;H:DM5PR12MB2471.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a4FtWLN6S414l72tlxfpryucAkowLtXp2MTCPTCTrd4FEXW3e8/kvvYkg8GlSXdd/YQOoHZaKe2zL6sgXRwl4ZEun66z9JyQg46CyzeGZxuC9PzYYiASch1cSSZVIGzkund+G8dUyxjaJvwvwiJR1m8Z8qPHYze7swUuRN7XUc2DXn1568ejaP05T7LcwnZfI+XG5NHYZyo17XnrNkI4XDCdvrbEPUSfzmf38KQYpMv48vTKfRTv0zMclJ2xJ3/suJOC8NyjRBwi3fC32OvWOiY8y2ZyPhWT+s9TSGMtITqj+3U+Siq3b36xiCWtFttIHKbuQFL84nfD1Fjg9p4gY37yzCDCb7ysDo7w9rvsv5EXPCUU9HVmfjth8IbRMFtiwcavXlDA7W6Wo0vqzVBTA7IttTeKKYwUuu/NLofv0VQ=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7c45ae8-43bd-4d4e-4464-08d7481d9d0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2019 16:20:32.1174
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1jmV64VKl1BMVdEBxjFT3obAhNNe3GQw5Nt0YY5g/5SVIDps7B7Di4l4d9rDr2mw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1164
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmltIE1hdHRzb24gPGpt
YXR0c29uQGdvb2dsZS5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBPY3RvYmVyIDMsIDIwMTkgMTE6
MTUgQU0NCj4gVG86IE1vZ2VyLCBCYWJ1IDxCYWJ1Lk1vZ2VyQGFtZC5jb20+DQo+IENjOiBWaXRh
bHkgS3V6bmV0c292IDx2a3V6bmV0c0ByZWRoYXQuY29tPjsgQWFyb24gTGV3aXMNCj4gPGFhcm9u
bGV3aXNAZ29vZ2xlLmNvbT47IGt2bSBsaXN0IDxrdm1Admdlci5rZXJuZWwub3JnPjsgTmF0YXJh
amFuLA0KPiBKYW5ha2FyYWphbiA8SmFuYWthcmFqYW4uTmF0YXJhamFuQGFtZC5jb20+DQo+IFN1
YmplY3Q6IFJlOiBbUGF0Y2hdIEtWTTogU1ZNOiBGaXggc3ZtX3hzYXZlc19zdXBwb3J0ZWQNCj4g
DQo+IE9uIFRodSwgT2N0IDMsIDIwMTkgYXQgOTowMiBBTSBNb2dlciwgQmFidSA8QmFidS5Nb2dl
ckBhbWQuY29tPg0KPiB3cm90ZToNCj4gPg0KPiA+DQo+ID4NCj4gPiBPbiA5LzkvMTkgMzo1NCBB
TSwgVml0YWx5IEt1em5ldHNvdiB3cm90ZToNCj4gPiA+IEppbSBNYXR0c29uIDxqbWF0dHNvbkBn
b29nbGUuY29tPiB3cml0ZXM6DQo+ID4gPg0KPiA+ID4+IE9uIFdlZCwgU2VwIDQsIDIwMTkgYXQg
OTo1MSBBTSBWaXRhbHkgS3V6bmV0c292DQo+IDx2a3V6bmV0c0ByZWRoYXQuY29tPiB3cm90ZToN
Cj4gPiA+Pg0KPiA+ID4+PiBDdXJyZW50bHksIFZNWCBjb2RlIG9ubHkgc3VwcG9ydHMgd3JpdGlu
ZyAnMCcgdG8gTVNSX0lBMzJfWFNTOg0KPiA+ID4+Pg0KPiA+ID4+PiAgICAgICAgIGNhc2UgTVNS
X0lBMzJfWFNTOg0KPiA+ID4+PiAgICAgICAgICAgICAgICAgaWYgKCF2bXhfeHNhdmVzX3N1cHBv
cnRlZCgpIHx8DQo+ID4gPj4+ICAgICAgICAgICAgICAgICAgICAgKCFtc3JfaW5mby0+aG9zdF9p
bml0aWF0ZWQgJiYNCj4gPiA+Pj4gICAgICAgICAgICAgICAgICAgICAgIShndWVzdF9jcHVpZF9o
YXModmNwdSwgWDg2X0ZFQVRVUkVfWFNBVkUpICYmDQo+ID4gPj4+ICAgICAgICAgICAgICAgICAg
ICAgICAgZ3Vlc3RfY3B1aWRfaGFzKHZjcHUsIFg4Nl9GRUFUVVJFX1hTQVZFUykpKSkNCj4gPiA+
Pj4gICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIDE7DQo+ID4gPj4+ICAgICAgICAgICAg
ICAgICAvKg0KPiA+ID4+PiAgICAgICAgICAgICAgICAgICogVGhlIG9ubHkgc3VwcG9ydGVkIGJp
dCBhcyBvZiBTa3lsYWtlIGlzIGJpdCA4LCBidXQNCj4gPiA+Pj4gICAgICAgICAgICAgICAgICAq
IGl0IGlzIG5vdCBzdXBwb3J0ZWQgb24gS1ZNLg0KPiA+ID4+PiAgICAgICAgICAgICAgICAgICov
DQo+ID4gPj4+ICAgICAgICAgICAgICAgICBpZiAoZGF0YSAhPSAwKQ0KPiA+ID4+PiAgICAgICAg
ICAgICAgICAgICAgICAgICByZXR1cm4gMTsNCj4gPiA+Pj4NCj4gPiA+Pj4NCj4gPiA+Pj4gd2Ug
d2lsbCBwcm9iYWJseSBuZWVkIHRoZSBzYW1lIGxpbWl0YXRpb24gZm9yIFNWTSwgaG93ZXZlciwg
SSdkIHZvdGUNCj4gZm9yDQo+ID4gPj4+IGNyZWF0aW5nIHNlcGFyYXRlIGt2bV94ODZfb3BzLT5z
ZXRfeHNzKCkgaW1wbGVtZW50YXRpb25zLg0KPiA+ID4+DQo+ID4gPj4gSSBob3BlIHNlcGFyYXRl
IGltcGxlbWVudGF0aW9ucyBhcmUgdW5uZWNlc3NhcnkuIFRoZSBhbGxvd2VkDQo+IElBMzJfWFNT
DQo+ID4gPj4gYml0cyBzaG91bGQgYmUgZGVyaXZhYmxlIGZyb20gZ3Vlc3RfY3B1aWRfaGFzKCkg
aW4gYQ0KPiA+ID4+IHZlbmRvci1pbmRlcGVuZGVudCB3YXkuIE90aGVyd2lzZSwgdGhlIENQVSB2
ZW5kb3JzIGhhdmUgbWVzc2VkDQo+IHVwLiA6LSkNCj4gPiA+Pg0KPiA+ID4+IEF0IHByZXNlbnQs
IHdlIHVzZSB0aGUgTVNSLWxvYWQgYXJlYSB0byBzd2FwIGd1ZXN0L2hvc3QgdmFsdWVzIG9mDQo+
ID4gPj4gSUEzMl9YU1Mgb24gSW50ZWwgKHdoZW4gdGhlIGhvc3QgYW5kIGd1ZXN0IHZhbHVlcyBk
aWZmZXIpLCBidXQgaXQNCj4gPiA+PiBzZWVtcyB0byBtZSB0aGF0IElBMzJfWFNTIGFuZCAleGNy
MCBzaG91bGQgYmUgc3dhcHBlZCBhdCB0aGUgc2FtZQ0KPiA+ID4+IHRpbWUsIGluIGt2bV9sb2Fk
X2d1ZXN0X3hjcjAva3ZtX3B1dF9ndWVzdF94Y3IwLiBUaGlzIHBvdGVudGlhbGx5DQo+IGFkZHMN
Cj4gPiA+PiBhbiBhZGRpdGlvbmFsIEwxIFdSTVNSIFZNLWV4aXQgdG8gZXZlcnkgZW11bGF0ZWQg
Vk0tZW50cnkgb3IgVk0tDQo+IGV4aXQNCj4gPiA+PiBmb3IgblZNWCwgYnV0IHNpbmNlIHRoZSBo
b3N0IGN1cnJlbnRseSBzZXRzIElBMzJfWFNTIHRvIDAgYW5kIHdlIG9ubHkNCj4gPiA+PiBhbGxv
dyB0aGUgZ3Vlc3QgdG8gc2V0IElBMzJfWFNTIHRvIDAsIHdlIGNhbiBwcm9iYWJseSB3b3JyeSBh
Ym91dCB0aGlzDQo+ID4gPj4gbGF0ZXIuDQo+ID4gPg0KPiA+ID4gWWVhLCBJIHdhcyBzdWdnZXN0
aW5nIHRvIHNwbGl0IGltcGxlbWVudGF0aW9ucyBhcyBhIGZ1dHVyZSBwcm9vZiBidXQgYQ0KPiA+
ID4gY29tbWVudCBsaWtlICJUaGlzIG91Z2h0IHRvIGJlIDAgZm9yIG5vdyIgd291bGQgYWxzbyBk
bykNCj4gPg0KPiA+IEhpLCBBbnlvbmUgYWN0aXZlbHkgd29ya2luZyBvbiB0aGlzPw0KPiA+DQo+
ID4gSSB3YXMgdHJ5aW5nIHRvIGV4cG9zZSB4c2F2ZXMgb24gQU1EIHFlbXUgZ3Vlc3QuIEZvdW5k
IG91dCB0aGF0IHdlDQo+IG5lZWQgdG8NCj4gPiBnZXQgdGhpcyBhYm92ZSBjb2RlIHdvcmtpbmcg
YmVmb3JlIEkgY2FuIGV4cG9zZSB4c2F2ZXMgb24gZ3Vlc3QuIEkgY2FuDQo+ID4gcmUtcG9zdCB0
aGVzZSBwYXRjaGVzIGlmIGl0IGlzIG9rLg0KPiA+DQo+ID4gU29ycnksIEkgZG9udCBoYXZlIHRo
ZSBjb21wbGV0ZSBiYWNrZ3JvdW5kLiBGcm9tIHdoYXQgSSB1bmRlcnN0b29kLCB3ZQ0KPiA+IG5l
ZWQgdG8gYWRkIHRoZSBzYW1lIGNoZWNrIGFzIEludGVsIGZvciBNU1JfSUEzMl9YU1MgaW4gZ2V0
X21zciBhbmQNCj4gc2V0X21zci4NCj4gPg0KPiA+IHN0YXRpYyBpbnQgdm14X2dldF9tc3Ioc3Ry
dWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3QgbXNyX2RhdGEgKm1zcl9pbmZvKQ0KPiA+IHsNCj4g
PiAuLg0KPiA+DQo+ID4gIGNhc2UgTVNSX0lBMzJfWFNTOg0KPiA+ICAgICAgICAgICAgICAgICBp
ZiAoIXZteF94c2F2ZXNfc3VwcG9ydGVkKCkgfHwNCj4gPiAgICAgICAgICAgICAgICAgICAgICgh
bXNyX2luZm8tPmhvc3RfaW5pdGlhdGVkICYmDQo+ID4gICAgICAgICAgICAgICAgICAgICAgIShn
dWVzdF9jcHVpZF9oYXModmNwdSwgWDg2X0ZFQVRVUkVfWFNBVkUpICYmDQo+ID4gICAgICAgICAg
ICAgICAgICAgICAgICBndWVzdF9jcHVpZF9oYXModmNwdSwgWDg2X0ZFQVRVUkVfWFNBVkVTKSkp
KQ0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiAxOw0KPiA+ICAgICAgICAgICAg
ICAgICBtc3JfaW5mby0+ZGF0YSA9IHZjcHUtPmFyY2guaWEzMl94c3M7DQo+ID4gICAgICAgICAg
ICAgICAgIGJyZWFrOw0KPiA+IC4uDQo+ID4gLi4NCj4gPiB9DQo+ID4NCj4gPiBzdGF0aWMgaW50
IHZteF9zZXRfbXNyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0IG1zcl9kYXRhICptc3Jf
aW5mbykNCj4gPiB7DQo+ID4gLi4NCj4gPiAuLg0KPiA+ICAgY2FzZSBNU1JfSUEzMl9YU1M6DQo+
ID4gICAgICAgICAgICAgICAgIGlmICghdm14X3hzYXZlc19zdXBwb3J0ZWQoKSB8fA0KPiA+ICAg
ICAgICAgICAgICAgICAgICAgKCFtc3JfaW5mby0+aG9zdF9pbml0aWF0ZWQgJiYNCj4gPiAgICAg
ICAgICAgICAgICAgICAgICAhKGd1ZXN0X2NwdWlkX2hhcyh2Y3B1LCBYODZfRkVBVFVSRV9YU0FW
RSkgJiYNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgIGd1ZXN0X2NwdWlkX2hhcyh2Y3B1LCBY
ODZfRkVBVFVSRV9YU0FWRVMpKSkpDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJu
IDE7DQo+ID4gICAgICAgICAgICAgICAgIC8qDQo+ID4gICAgICAgICAgICAgICAgICAqIFRoZSBv
bmx5IHN1cHBvcnRlZCBiaXQgYXMgb2YgU2t5bGFrZSBpcyBiaXQgOCwgYnV0DQo+ID4gICAgICAg
ICAgICAgICAgICAqIGl0IGlzIG5vdCBzdXBwb3J0ZWQgb24gS1ZNLg0KPiA+ICAgICAgICAgICAg
ICAgICAgKi8NCj4gPiAgICAgICAgICAgICAgICAgaWYgKGRhdGEgIT0gMCkNCj4gPiAgICAgICAg
ICAgICAgICAgICAgICAgICByZXR1cm4gMTsNCj4gPiAgICAgICAgICAgICAgICAgdmNwdS0+YXJj
aC5pYTMyX3hzcyA9IGRhdGE7DQo+ID4gICAgICAgICAgICAgICAgIGlmICh2Y3B1LT5hcmNoLmlh
MzJfeHNzICE9IGhvc3RfeHNzKQ0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgIGFkZF9hdG9t
aWNfc3dpdGNoX21zcih2bXgsIE1TUl9JQTMyX1hTUywNCj4gPiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIHZjcHUtPmFyY2guaWEzMl94c3MsIGhvc3RfeHNzLCBmYWxzZSk7DQo+ID4g
ICAgICAgICAgICAgICAgIGVsc2UNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICBjbGVhcl9h
dG9taWNfc3dpdGNoX21zcih2bXgsIE1TUl9JQTMyX1hTUyk7DQo+ID4gICAgICAgICAgICAgICAg
IGJyZWFrOw0KPiA+IC4uLg0KPiA+IH0NCj4gPg0KPiA+IFdlIHByb2JhYmx5IGRvbid0IG5lZWQg
bGFzdCAiaWYgJiBlbHNlIiBjaGVjayBhcyB3ZSBhcmUgc2V0dGluZyBpdCAwIG5vdy4NCj4gPiBE
b2VzIHRoaXMgbG9vayBhY2N1cmF0ZT8NCj4gDQo+IEFhcm9uIGlzIHdvcmtpbmcgb24gaXQsIGFu
ZCBJIHRoaW5rIGhlJ3MgY2xvc2UgdG8gYmVpbmcgcmVhZHkgdG8gc2VuZA0KPiBvdXQgdGhlIG5l
eHQgcmV2aXNpb24uDQoNCk9rLiBUaGFua3MuDQo=
