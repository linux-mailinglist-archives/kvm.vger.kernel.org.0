Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9069BA784C
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 04:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfIDCGU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 22:06:20 -0400
Received: from mail-eopbgr820070.outbound.protection.outlook.com ([40.107.82.70]:43952
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726925AbfIDCGT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 22:06:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hLTmUn618CMfoptDyhB5kzwE+wYbkpRe+oZJ8qF2T9Fcq/XXCSFgOjI53MDA8sIdPh1LqxYAJJJiMujbACB15naPEbdImN5axKbkhhvmuRYcgLlxyzQXnHvAjnQ9rEQnhiyF357OwMSUYcoSf4vZaHuo7JD6fsdkr11HsktSSgYXQLwXvhjOp8YLhozlHOsrrYdDJ+JuqQXZyINGaarJdWjbqzF5dj0Ig3bbIq/yDHMnC8MSsomb+yn1FbLuJSvq6hkCOadgKI6k8ALQ0arn4hSIOz5pDunZp6GTbPL9dGuk2dcA+5SKlInPMxr/DOWVYeH8+A0QIdXtnmMSw9NLpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=61O1q4DLnLZU4OcR0VH+fJvmStx6o1X5p+v6xWQ6xH4=;
 b=MqAk6Medfd/Nw5Ki0/CNOpXbqZlW1L54mJsEkYQhN6nV1KDS1aNlroA4HVMND4I+ETXQCl6K8FQ1kBOjwf9IwdP3R1+X4DEaRbXHHN3Al48+D3Agx8/a2mNYPsgCeUsFkMSo+ELQROWJ/z2+uRUSHKNc4Kflh0d6fAozUuaQkVMG+333DIZ8PKrxgan29FSC8i4HbTlm8+VaaJojjKIXiO/0MxdR9c8jPfGTjDu/TBbEZDrH7z5jYE08yaZxJRRzANviTQLD07gPh8ZXf9qp8H0D4R22r3rm3gcGDx1lyKa9k9xc+R062UYn6cHILAse/20IwGrjF/g0x8f5wRdeHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=61O1q4DLnLZU4OcR0VH+fJvmStx6o1X5p+v6xWQ6xH4=;
 b=om21v9c3YufYK7aGh4lKr5C1rwvRdQFqGxjyGg24ai/x9GBfcBHMNV0yvk2DKQGMFYCYD3s9EvcAr0Iqakd30uxyYQ0rrWqXDUSj0RYvcZC+GYIcB0w9hTgtpz22voc13nPA2IJo9bbwrCRiz+Bi9bn+FUoVkq7TsFPhqjrPRdE=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB2604.namprd12.prod.outlook.com (20.176.116.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Wed, 4 Sep 2019 02:06:16 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997%3]) with mapi id 15.20.2241.014; Wed, 4 Sep 2019
 02:06:16 +0000
From:   "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To:     Alexander Graf <graf@amazon.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
Subject: Re: [PATCH v2 14/15] kvm: ioapic: Delay update IOAPIC EOI for RTC
Thread-Topic: [PATCH v2 14/15] kvm: ioapic: Delay update IOAPIC EOI for RTC
Thread-Index: AQHVU4YIh6tJvHdq80Sa2/XMOGUQVKcCU3mAgBiQIoA=
Date:   Wed, 4 Sep 2019 02:06:15 +0000
Message-ID: <d818501c-cd4c-a0f7-0e40-39ba6aa78c05@amd.com>
References: <1565886293-115836-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1565886293-115836-15-git-send-email-suravee.suthikulpanit@amd.com>
 <e5556778-105a-bdb3-f118-84fe729d042b@amazon.com>
In-Reply-To: <e5556778-105a-bdb3-f118-84fe729d042b@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
x-originating-ip: [165.204.77.11]
x-clientproxiedby: SN6PR06CA0009.namprd06.prod.outlook.com
 (2603:10b6:805:8e::22) To DM6PR12MB2844.namprd12.prod.outlook.com
 (2603:10b6:5:45::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dd88a6c0-82dc-4158-8232-08d730dc77d3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB2604;
x-ms-traffictypediagnostic: DM6PR12MB2604:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB2604E642060EAB64E9DF209DF3B80@DM6PR12MB2604.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(199004)(189003)(31696002)(7736002)(71200400001)(71190400001)(2201001)(2501003)(6486002)(305945005)(8676002)(2616005)(86362001)(52116002)(316002)(5660300002)(66946007)(99286004)(81166006)(81156014)(54906003)(6436002)(476003)(6506007)(76176011)(6116002)(478600001)(3846002)(25786009)(446003)(26005)(110136005)(66556008)(102836004)(64756008)(66476007)(486006)(53546011)(15650500001)(31686004)(65806001)(66446008)(6246003)(58126008)(2906002)(14444005)(256004)(8936002)(4326008)(186003)(229853002)(11346002)(14454004)(66066001)(36756003)(6512007)(53936002)(386003)(65956001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2604;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OFDjK7l5gEwIOtTdR0nI99V7W3x2vhr2o8P30+hO3FY6dAPMaVx8c5XFhY2x2Ox3S+f25SkUBhwWW+4DOR+dBdP+SQT+u65FD8wCp1bZKaRJQbUIckc5vaVND2US9P9k/DFNF7n8gy/xIyFCFFBWkUUv8cyXw/poJsBNeUhX5RubeIxpY1JVm3tO9M2Jamc3TDwEL/lAr5f2IOGE7V5dbNa29fq1a5qStCuzoTgM2hm2TvFx0LCglH0tGddyDHVJysbUHBVtSHeNPviXCqdig3s7uG4+VbD0Om5QtDD4SJcSLyXaTGzEru2+bfCbRpE9nZ1ySiPv9dNzQJhoIaaxUYLAc2RPTckfvgwkJq4FkKZ2slZ5idI0w2aYHDIFkaY4lawCHx0E90Hy+gJpVuirksg9wXeMVg7LAHkeHKqmVfA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <57FCF1DD486BA84E95D74F1D2E5229DB@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd88a6c0-82dc-4158-8232-08d730dc77d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 02:06:16.0351
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: izjFkn/jWmg3qaA484TR2Aqys1DH4pOe2n6A9TVa6NfDnvCFlbeDYoHVUL3qDJqPxzXK9R4y+PDoPvpJ5b/fYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2604
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QWxleCwNCg0KT24gOC8xOS8xOSA2OjAwIEFNLCBBbGV4YW5kZXIgR3JhZiB3cm90ZToNCj4gDQo+
IA0KPiBPbiAxNS4wOC4xOSAxODoyNSwgU3V0aGlrdWxwYW5pdCwgU3VyYXZlZSB3cm90ZToNCj4+
IEluLWtlcm5lbCBJT0FQSUMgZG9lcyBub3QgdXBkYXRlIFJUQyBwZW5kaW5nIEVPSSBpbmZvIHdp
dGggQU1EIFNWTSAvdyANCj4+IEFWSUMNCj4+IHdoZW4gaW50ZXJydXB0IGlzIGRlbGl2ZXJlZCBh
cyBlZGdlLXRyaWdnZXJlZCBzaW5jZSBBTUQgcHJvY2Vzc29ycw0KPj4gY2Fubm90IGV4aXQgb24g
RU9JIGZvciB0aGVzZSBpbnRlcnJ1cHRzLg0KPj4NCj4+IEFkZCBjb2RlIHRvIGFsc28gY2hlY2sg
TEFQSUMgcGVuZGluZyBFT0kgYmVmb3JlIGluamVjdGluZyBhbnkgbmV3IFJUQw0KPj4gaW50ZXJy
dXB0cyBvbiBBTUQgU1ZNIHdoZW4gQVZJQyBpcyBhY3RpdmF0ZWQuDQo+Pg0KPj4gU2lnbmVkLW9m
Zi1ieTogU3VyYXZlZSBTdXRoaWt1bHBhbml0IDxzdXJhdmVlLnN1dGhpa3VscGFuaXRAYW1kLmNv
bT4NCj4+IC0tLQ0KPj4gwqAgYXJjaC94ODYva3ZtL2lvYXBpYy5jIHwgMzYgKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKystLS0tDQo+PiDCoCAxIGZpbGUgY2hhbmdlZCwgMzIgaW5zZXJ0
aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3Zt
L2lvYXBpYy5jIGIvYXJjaC94ODYva3ZtL2lvYXBpYy5jDQo+PiBpbmRleCAxYWRkMWJjLi40NWU3
YmIwIDEwMDY0NA0KPj4gLS0tIGEvYXJjaC94ODYva3ZtL2lvYXBpYy5jDQo+PiArKysgYi9hcmNo
L3g4Ni9rdm0vaW9hcGljLmMNCj4+IEBAIC0zOSw2ICszOSw3IEBADQo+PiDCoCAjaW5jbHVkZSA8
YXNtL3Byb2Nlc3Nvci5oPg0KPj4gwqAgI2luY2x1ZGUgPGFzbS9wYWdlLmg+DQo+PiDCoCAjaW5j
bHVkZSA8YXNtL2N1cnJlbnQuaD4NCj4+ICsjaW5jbHVkZSA8YXNtL3ZpcnRleHQuaD4NCj4+IMKg
ICNpbmNsdWRlIDx0cmFjZS9ldmVudHMva3ZtLmg+DQo+PiDCoCAjaW5jbHVkZSAiaW9hcGljLmgi
DQo+PiBAQCAtMTczLDYgKzE3NCw3IEBAIHN0YXRpYyBib29sIHJ0Y19pcnFfY2hlY2tfY29hbGVz
Y2VkKHN0cnVjdCANCj4+IGt2bV9pb2FwaWMgKmlvYXBpYykNCj4+IMKgwqDCoMKgwqAgcmV0dXJu
IGZhbHNlOw0KPj4gwqAgfQ0KPj4gKyNkZWZpbmUgQVBJQ19ERVNUX05PU0hPUlTCoMKgwqDCoMKg
wqDCoCAweDANCj4+IMKgIHN0YXRpYyBpbnQgaW9hcGljX3NldF9pcnEoc3RydWN0IGt2bV9pb2Fw
aWMgKmlvYXBpYywgdW5zaWduZWQgaW50IGlycSwNCj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBpbnQg
aXJxX2xldmVsLCBib29sIGxpbmVfc3RhdHVzKQ0KPj4gwqAgew0KPj4gQEAgLTIwMSwxMCArMjAz
LDM2IEBAIHN0YXRpYyBpbnQgaW9hcGljX3NldF9pcnEoc3RydWN0IGt2bV9pb2FwaWMgDQo+PiAq
aW9hcGljLCB1bnNpZ25lZCBpbnQgaXJxLA0KPj4gwqDCoMKgwqDCoMKgICogaW50ZXJydXB0cyBs
ZWFkIHRvIHRpbWUgZHJpZnQgaW4gV2luZG93cyBndWVzdHMuwqAgU28gd2UgdHJhY2sNCj4+IMKg
wqDCoMKgwqDCoCAqIEVPSSBtYW51YWxseSBmb3IgdGhlIFJUQyBpbnRlcnJ1cHQuDQo+PiDCoMKg
wqDCoMKgwqAgKi8NCj4+IC3CoMKgwqAgaWYgKGlycSA9PSBSVENfR1NJICYmIGxpbmVfc3RhdHVz
ICYmDQo+PiAtwqDCoMKgwqDCoMKgwqAgcnRjX2lycV9jaGVja19jb2FsZXNjZWQoaW9hcGljKSkg
ew0KPj4gLcKgwqDCoMKgwqDCoMKgIHJldCA9IDA7DQo+PiAtwqDCoMKgwqDCoMKgwqAgZ290byBv
dXQ7DQo+PiArwqDCoMKgIGlmIChpcnEgPT0gUlRDX0dTSSAmJiBsaW5lX3N0YXR1cykgew0KPj4g
K8KgwqDCoMKgwqDCoMKgIHN0cnVjdCBrdm0gKmt2bSA9IGlvYXBpYy0+a3ZtOw0KPj4gK8KgwqDC
oMKgwqDCoMKgIHVuaW9uIGt2bV9pb2FwaWNfcmVkaXJlY3RfZW50cnkgKmVudHJ5ID0gJmlvYXBp
Yy0+cmVkaXJ0YmxbaXJxXTsNCj4+ICsNCj4+ICvCoMKgwqDCoMKgwqDCoCAvKg0KPj4gK8KgwqDC
oMKgwqDCoMKgwqAgKiBTaW5jZSwgQU1EIFNWTSBBVklDIGFjY2VsZXJhdGVzIHdyaXRlIGFjY2Vz
cyB0byBBUElDIEVPSQ0KPj4gK8KgwqDCoMKgwqDCoMKgwqAgKiByZWdpc3RlciBmb3IgZWRnZS10
cmlnZ2VyIGludGVycnVwdHMsIElPQVBJQyB3aWxsIG5vdCBiZQ0KPj4gK8KgwqDCoMKgwqDCoMKg
wqAgKiBhYmxlIHRvIHJlY2VpdmUgdGhlIEVPSS4gSW4gdGhpcyBjYXNlLCB3ZSBkbyBsYXp5IHVw
ZGF0ZQ0KPj4gK8KgwqDCoMKgwqDCoMKgwqAgKiBvZiB0aGUgcGVuZGluZyBFT0kgd2hlbiB0cnlp
bmcgdG8gc2V0IElPQVBJQyBpcnEgZm9yIFJUQy4NCj4+ICvCoMKgwqDCoMKgwqDCoMKgICovDQo+
PiArwqDCoMKgwqDCoMKgwqAgaWYgKGNwdV9oYXNfc3ZtKE5VTEwpICYmDQo+PiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCAoa3ZtLT5hcmNoLmFwaWN2X3N0YXRlID09IEFQSUNWX0FDVElWQVRFRCkg
JiYNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIChlbnRyeS0+ZmllbGRzLnRyaWdfbW9kZSA9
PSBJT0FQSUNfRURHRV9UUklHKSkgew0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaW50IGk7
DQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHU7DQo+PiAr
DQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBrdm1fZm9yX2VhY2hfdmNwdShpLCB2Y3B1LCBr
dm0pDQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChrdm1fYXBpY19tYXRj
aF9kZXN0KHZjcHUsIE5VTEwsDQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIEtWTV9BUElDX0RFU1RfTk9TSE9SVCwNCj4+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZW50cnktPmZp
ZWxkcy5kZXN0X2lkLA0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBlbnRyeS0+ZmllbGRzLmRlc3RfbW9kZSkpIHsNCj4+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBfX3J0Y19pcnFfZW9pX3RyYWNraW5nX3Jl
c3RvcmVfb25lKHZjcHUpOw0KPiANCj4gSSBkb24ndCB1bmRlcnN0YW5kIHdoeSB0aGlzIHdvcmtz
LiBUaGlzIGNvZGUganVzdCBtZWFucyB3ZSdyZSBpbmplY3RpbmcgDQo+IGFuIEVPSSBvbiB0aGUg
Zmlyc3QgQ1BVIHRoYXQgaGFzIHRoZSB2ZWN0b3IgbWFwcGVkLCByaWdodCB3aGVuIHdlJ3JlIA0K
PiBzZXR0aW5nIGl0IHRvIHRyaWdnZXIsIG5vPw0KDQpBY3R1YWxseSwgdGhpcyBpcyBzaW1pbGFy
IHRvIHRoZSBhcHByb2FjaCBpbiBwYXRjaCAxMi8xNSwgd2hlcmUgd2UgY2hlY2sgDQppZiB0aGVy
ZSBpcyBhbnkgcGVuZGluZyBFT0kgZm9yIHRoZSBSVENfR1NJIG9uIHRoZSBkZXN0aW5hdGlvbiB2
Y3B1LiANCk90aGVyd2lzZSwgdGhlIF9fcnRjX2lycV9lb2lfdHJhY2tpbmdfcmVzdG9yZV9vbmUo
KSBzaG91bGQgY2xlYXIgSU9BUElDIA0KcGVuZGluZyBFT0kgZm9yIFJUQy4NCg0KU3VyYXZlZQ0K
