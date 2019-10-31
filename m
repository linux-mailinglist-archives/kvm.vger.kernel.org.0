Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B276EEB3BD
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2019 16:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbfJaPRT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Oct 2019 11:17:19 -0400
Received: from mail-eopbgr800049.outbound.protection.outlook.com ([40.107.80.49]:46592
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726664AbfJaPRT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Oct 2019 11:17:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dwk1FSJaOeW9ExY9HDa8AZ19NtLYQvv/61RzeT/m2ooyHjLX1UPrgppDc+DXvLDPjVBBdbNrhVb39VN/hy01selEEyOGdlJPB2ipd9a6Z82uWh4ZDowwkqgtvjs82dwDy4KL7FoyBp0+qOjMPjlLmfzWhZgc8CN4nl62RooAf3CiYK2IHjEidp4VkY51d0iX0zRR1Ye2qDTg5AefFydfIPp5uW2meKe/Uzw+CKOhEPDNdclZdUPR28B8p6DMoxSQf4fe6M0onv4G6wwWZACaZ2cUo4mesd5jsFsvDO+bdBbEJkVuqi1xeyKMdcVuTiDanDGi3W5pDZ+sLm2uGJ3oXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F/sBh0KHS+dt/1oY8jcUb4IvzGzczjam9iMVTL2wkls=;
 b=YeJIaC56YzMVoJzxl+yalTIO5Pwc00fYwZLrcU4O1wKCkGyokEfhjcN5bHkb4dvX/3Lc5Xiw8YTZ4e3lrFRQM7cJ5oS/k/WiwoRM5EdOQM84MsL6HWAql4Kg7oWz1ih85pDZU7jPFsBIN4O5bhx30kTZe3curlYb9FhmHdDJctFTRv/LgXjhesEFs70/paEgCL+TjenNi65Q437OmC12s714knBlYf3eFm40IPEpcR8zMo/oBYnVQPrT+bED/8ORaBvAC2RAISXkQ68hEqb56vo6IqSqHdQ9Z70gaqt2s6aOdGJeVS3EloAIVxe1nFTluqNK2UvIkf1/OfBBJMWSBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F/sBh0KHS+dt/1oY8jcUb4IvzGzczjam9iMVTL2wkls=;
 b=ZR2lP/Bhl9p2MQ2ruvAoHvzwZjOGQZ+1ROTIHx4O8UxAil2TJ9p7v1v1/sHiQeE3uygn4gfmWx7+ESYxLCJ8DHmCy5ORxsH2kusC6iFIb/rxJAb+8INhjtcLGD1jsJ6i77tCCYuUH8ssL8RBXMR9IPiPRpWa/14Uk2P5mimhj/g=
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3020.namprd12.prod.outlook.com (20.178.30.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Thu, 31 Oct 2019 15:17:02 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2387.028; Thu, 31 Oct 2019
 15:17:02 +0000
From:   "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "graf@amazon.com" <graf@amazon.com>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
Subject: Re: [PATCH v3 15/16] kvm: x86: ioapic: Lazy update IOAPIC EOI
Thread-Topic: [PATCH v3 15/16] kvm: x86: ioapic: Lazy update IOAPIC EOI
Thread-Index: AQHVamWbRD5vJtxZB0KDkUxSQlG/TKdSMSCAgCL2jgA=
Date:   Thu, 31 Oct 2019 15:17:01 +0000
Message-ID: <5581f203-b9de-7f33-8afc-0d7026387a46@amd.com>
References: <1568401242-260374-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1568401242-260374-16-git-send-email-suravee.suthikulpanit@amd.com>
 <3771e33d-365b-c214-3d40-bca67c2fa841@redhat.com>
In-Reply-To: <3771e33d-365b-c214-3d40-bca67c2fa841@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.0
x-originating-ip: [165.204.77.11]
x-clientproxiedby: SN4PR0201CA0027.namprd02.prod.outlook.com
 (2603:10b6:803:2e::13) To DM6PR12MB3865.namprd12.prod.outlook.com
 (2603:10b6:5:1c8::18)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d965a36c-914e-4188-e4ee-08d75e156152
x-ms-traffictypediagnostic: DM6PR12MB3020:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3020189D18E4484A5E597857F3630@DM6PR12MB3020.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02070414A1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(136003)(366004)(376002)(396003)(346002)(39860400002)(189003)(199004)(2616005)(446003)(15650500001)(478600001)(76176011)(54906003)(66946007)(2906002)(66556008)(66476007)(64756008)(256004)(14444005)(110136005)(58126008)(4326008)(25786009)(316002)(31686004)(6512007)(52116002)(11346002)(66446008)(86362001)(6246003)(65806001)(65956001)(7416002)(66066001)(81166006)(81156014)(305945005)(7736002)(102836004)(386003)(2501003)(26005)(229853002)(5660300002)(31696002)(2201001)(14454004)(99286004)(486006)(71200400001)(71190400001)(6506007)(3846002)(8676002)(53546011)(6486002)(6116002)(476003)(8936002)(6436002)(186003)(36756003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3020;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PdCuh7Uv3pEP6a89FHuXV0uJJ3nAh7lnqhrm5Kh8/uZnQEI54XJPzFavsk5uciMFZP29k8eHk/0DxFEB11HmP4bhQYRtgMBc4ufqzUr/XfDaMZAwegK9mTK5W8VwcfpTu1JbaIzjXR3Nkm80/yY1P62lfVIwsxneit/GkTCFHJu1ozsy6AOr4mpMg0BKZ930jc6zM0OzYeY+vhTUOow3nacxQ3h1yFBwrI3jdM1sbuUjfh4iu89MIitNUebKRbu6cYQli8VSntacmHPOxKTJIZ5CnkOslP0wyL2Gk1J8NFkD5aUE8pqG3GHP3K0C+gE6xTP6xrp0rjlJfuIb9oIuJgswzPgOmYN8cH4UDTrjU3elqeVCeRaIOFv+VM33tjTMRtekFS0i7aRjVVQpo4L331t4qvREe0jG3rPcXG7oa7+ADXur00dlbgcwy8ImaXhX
Content-Type: text/plain; charset="utf-8"
Content-ID: <A3D4816A50B78C4C975FCF4C59300953@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d965a36c-914e-4188-e4ee-08d75e156152
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2019 15:17:01.9349
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ejmAJTK4y9NPTZ/O87h2d2OsnurDkb5xkiXYi47Z6TA3JNqtWRextGCF1tpvJTuBmRUEKPz4f4XBiGlslZHPCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3020
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UGFvbG8sDQoNCk9uIDEwLzkvMTkgNDoyMSBBTSwgUGFvbG8gQm9uemluaSB3cm90ZToNCj4gT24g
MTMvMDkvMTkgMjE6MDEsIFN1dGhpa3VscGFuaXQsIFN1cmF2ZWUgd3JvdGU6DQo+PiAgIAkvKg0K
Pj4gKwkgKiBJbiBjYXNlIEFQSUN2IGFjY2VsZXJhdGUgRU9JIHdyaXRlIGFuZCBkbyBub3QgdHJh
cCwNCj4+ICsJICogaW4ta2VybmVsIElPQVBJQyB3aWxsIG5vdCBiZSBhYmxlIHRvIHJlY2VpdmUg
dGhlIEVPSS4NCj4+ICsJICogSW4gdGhpcyBjYXNlLCB3ZSBkbyBsYXp5IHVwZGF0ZSBvZiB0aGUg
cGVuZGluZyBFT0kgd2hlbg0KPj4gKwkgKiB0cnlpbmcgdG8gc2V0IElPQVBJQyBpcnEuDQo+PiAr
CSAqLw0KPj4gKwlpZiAoa3ZtX2FwaWN2X2VvaV9hY2NlbGVyYXRlKGlvYXBpYy0+a3ZtLCBlZGdl
KSkNCj4+ICsJCWlvYXBpY19sYXp5X3VwZGF0ZV9lb2koaW9hcGljLCBpcnEpOw0KPj4gKw0KPiAN
Cj4gVGhpcyBpcyBva2F5IGZvciB0aGUgUlRDLCBhbmQgaW4gZmFjdCBJIHN1Z2dlc3QgdGhhdCB5
b3UgbWFrZSBpdCB3b3JrDQo+IGxpa2UgdGhpcyBldmVuIGZvciBJbnRlbC4gIFRoaXMgd2lsbCBn
ZXQgcmlkIG9mIGt2bV9hcGljdl9lb2lfYWNjZWxlcmF0ZQ0KPiBhbmQgYmUgbmljZXIgb3ZlcmFs
bC4NCj4gDQo+IEhvd2V2ZXIsIGl0IGNhbm5vdCB3b3JrIGZvciB0aGUgaW4ta2VybmVsIFBJVCwg
YmVjYXVzZSBpdCBpcyBjdXJyZW50bHkNCj4gY2hlY2tpbmcgcHMtPmlycV9hY2sgYmVmb3JlIGt2
bV9zZXRfaXJxLiAgVW5mb3J0dW5hdGVseSwgdGhlIGluLWtlcm5lbA0KPiBQSVQgaXMgcmVseWlu
ZyBvbiB0aGUgYWNrIG5vdGlmaWVyIHRvIHRpbWVseSBxdWV1ZSB0aGUgcHQtPndvcmtlciB3b3Jr
DQo+IGl0ZW0gYW5kIHJlaW5qZWN0IHRoZSBtaXNzZWQgdGljay4NCj4gDQo+IFRodXMsIHlvdSBj
YW5ub3QgZW5hYmxlIEFQSUN2IGlmIHBzLT5yZWluamVjdCBpcyB0cnVlLg0KPiANCj4gUGVyaGFw
cyB5b3UgY2FuIG1ha2Uga3ZtLT5hcmNoLmFwaWN2X3N0YXRlIGEgZGlzYWJsZWQgY291bnRlcj8g
IFRoZW4NCj4gSHlwZXItViBjYW4gaW5jcmVtZW50IGl0IHdoZW4gZW5hYmxlZCwgUElUIGNhbiBp
bmNyZW1lbnQgaXQgd2hlbg0KPiBwcy0+cmVpbmplY3QgYmVjb21lcyB0cnVlIGFuZCBkZWNyZW1l
bnQgaXQgd2hlbiBpdCBiZWNvbWVzIGZhbHNlOw0KPiBmaW5hbGx5LCBzdm0uYyBjYW4gaW5jcmVt
ZW50IGl0IHdoZW4gYW4gU1ZNIGd1ZXN0IGlzIGxhdW5jaGVkIGFuZA0KPiBpbmNyZW1lbnQvZGVj
cmVtZW50IGl0IGFyb3VuZCBFeHRJTlQgaGFuZGxpbmc/DQoNCkkgaGF2ZSBiZWVuIGxvb2tpbmcg
aW50byB0aGUgZGlzYWJsZWQgY291bnRlciBpZGVhIGFuZCBmb3VuZCBhIGNvdXBsZSANCmlzc3Vl
czoNCg0KKiBJIGFtIHNlZWluZyBtb3JlIGNhbGxzIHRvIGVuYWJsZV9pcnFfd2luZG93KCkgdGhh
biB0aGUgbnVtYmVyIG9mIA0KaW50ZXJydXB0X3dpbmRvd19pbnRlcmNlcHRpb24oKS4gVGhpcyBy
ZXN1bHRzIGluIGltYmFsYW5jZWQgDQppbmNyZW1lbnQvZGVjcmVtZW50IG9mIHRoZSBjb3VudGVy
Lg0KDQoqIEFQSUN2IGNhbiBiZSBkZWFjdGl2YXRlZCBkdWUgdG8gc2V2ZXJhbCByZWFzb25zLiBD
dXJyZW50bHksIGl0IGlzIA0KZGlmZmljdWx0IHRvIGZpZ3VyZSBvdXQgd2h5LCBhbmQgdGhpcyBt
YWtlcyBkZWJ1Z2dpbmcgQVBJQ3YgZGlmZmljdWx0Lg0KDQpXaGF0IGlmIHdlIGNoYW5nZSBrdm0t
PmFyY2guYXBpY3Zfc3RhdGUgdG8ga3ZtLT5hcmNoLmFwaWN2X2Rpc2FibGVfbWFzayANCmFuZCBo
YXZlIGVhY2ggYml0IHJlcHJlc2VudGluZyB0aGUgcmVhc29uIGZvciBkZWFjdGl2YXRpbmcgQVBJ
Q3YuDQoNCkZvciBleGFtcGxlOg0KICAgICAjZGVmaW5lIEFQSUNWX0RJU0FCTEVfTUFTS19JUlFX
SU4gICAgICAgIDANCiAgICAgI2RlZmluZSBBUElDVl9ESVNBQkxFX01BU0tfSFlQRVJWICAgICAg
ICAxDQogICAgICNkZWZpbmUgQVBJQ1ZfRElTQUJMRV9NQVNLX1BJVF9SRUlOSiAgICAgMg0KICAg
ICAjZGVmaW5lIEFQSUNWX0RJU0FCTEVfTUFTS19ORVNURUQgICAgICAgIDMNCg0KSW4gdGhpcyBj
YXNlLCB3ZSBhY3RpdmF0ZSBBUElDdiBvbmx5IGlmIGt2bS0+YXJjaC5hcGljdl9kaXNhYmxlX21h
c2sgPT0gDQowLiBUaGlzIHdheSwgd2UgY2FuIGZpbmQgb3V0IHdoeSBBUElDdiBpcyBkZWFjdGl2
YXRlZCBvbiBhIHBhcnRpY3VsYXIgVk0gDQphdCBhIHBhcnRpY3VsYXIgcG9pbnQgaW4gdGltZS4N
Cg0KVGhhbmtzLA0KU3VyYXZlZQ0K
