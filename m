Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45D52E0542
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 15:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732092AbfJVNii (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 09:38:38 -0400
Received: from mail-eopbgr800050.outbound.protection.outlook.com ([40.107.80.50]:35012
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732064AbfJVNii (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 09:38:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jGdEoXEWiRcTtKNKwtmZnRhoe9sJk+Zk/822w5Y2HZYsdOQX/3d67xECVz3BWEl0SyxDutkILH2Fh7BXpEJvKgqN0EdERx/3IwK+50+aT9cJB2MWaWoENFF7qqgusgn24DH5R3VfVD43ok5Drs+k1Ef4tKvi1IT8/bStMVHtLgdElXNq5Wl/JEu2wQD5rTHY5+ftfnVhw7dc+LtWpfJeeVZPIWpYECx72jmIXSqg9hiUmjPIueIWu9Lj1Yip4woShs9s8AeiERg3bZ+65p9Q+hGCJaaGwXX0uOQRaFMi5EmIzxMkC1E/jrm+RMhnN3ZOvK6lX5Yq/Y1DUI1e3KFwAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WUVx25eyEVhaMDYtSn6AQODsbMxEvTyjMFvV19ED3+k=;
 b=AAyNLa13W3iHF++EHjoIGu/E22woLZv9ooH3IhYXsmf+y47b4ZRZTfwb04f1Pj/nrd/uhbipjA2VwLP7VH91/CTdKi9k5kOUq+q7BvUsceRtCuPr8CbCx7pkOusC3EhPOz5KtzrNio/6s60UGkbknVHYNufhk184JHjYKi0bKy+i1wtXk7AzQ7e41u6KixptApAr5Vn1cUGnTC/Do1iHvSt0g4tgp+PICn+l+JUkX0sjm80FsBVyKLnP+uookQo2H03Zxbo0O0/5ARLqi4fc0oD4T2OveEu7XkZ8rZ+2NDgpdGAMlpnK4/7+OJL9K+i37j0lzrbdRm4nBFPCfgpGjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WUVx25eyEVhaMDYtSn6AQODsbMxEvTyjMFvV19ED3+k=;
 b=TXTMKnPZg3AaLaijH1xbkHzkYoeY+sstO1GKCS3UEYFukqNGDOXypGk7yeqxQxlrAYpbOoIEaih/BtXGcNVmnZ/P1OHvfb25hfWrI5wzzQ1lMKTC41YnD7YUe53X9hS8FEC9SRRzu4n+WlYPF+Rvn4Igr14t7qSdVCDOV4Nxx9M=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.118.13) by
 DM6PR12MB4218.namprd12.prod.outlook.com (10.141.186.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Tue, 22 Oct 2019 13:38:33 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::80:cb81:4a0e:a36]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::80:cb81:4a0e:a36%3]) with mapi id 15.20.2367.022; Tue, 22 Oct 2019
 13:38:33 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     David Rientjes <rientjes@google.com>
CC:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Kalra, Ashish" <Ashish.Kalra@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "info@metux.net" <info@metux.net>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] crypto: ccp - Retry SEV INIT command in case of integrity
 check failure.
Thread-Topic: [PATCH] crypto: ccp - Retry SEV INIT command in case of
 integrity check failure.
Thread-Index: AQHVhTsiVAXVZvJHqE+F84WTgpVS9KdhrHEAgAPAfICAAG/6gIAA1J0A
Date:   Tue, 22 Oct 2019 13:38:33 +0000
Message-ID: <cfc975bb-d520-82a4-6fbe-40d78ce2e822@amd.com>
References: <20191017223459.64281-1-Ashish.Kalra@amd.com>
 <alpine.DEB.2.21.1910190156210.140416@chino.kir.corp.google.com>
 <29887804-ecab-ae83-8d3f-52ea83e44b4e@amd.com>
 <alpine.DEB.2.21.1910211754550.152056@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.21.1910211754550.152056@chino.kir.corp.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR01CA0018.prod.exchangelabs.com (2603:10b6:805:b6::31)
 To DM6PR12MB2682.namprd12.prod.outlook.com (2603:10b6:5:42::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9a0756d9-fc36-429f-d175-08d756f521b0
x-ms-traffictypediagnostic: DM6PR12MB4218:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB4218E0A8C2D999E5E199E2A8E5680@DM6PR12MB4218.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(366004)(376002)(346002)(199004)(189003)(76176011)(8676002)(81166006)(81156014)(25786009)(66946007)(14454004)(64756008)(66446008)(66556008)(486006)(6916009)(8936002)(31686004)(71190400001)(71200400001)(99286004)(478600001)(53546011)(66066001)(6506007)(386003)(102836004)(186003)(26005)(52116002)(66476007)(256004)(14444005)(5660300002)(4326008)(6246003)(3846002)(6116002)(305945005)(7736002)(6486002)(6436002)(6512007)(7416002)(54906003)(316002)(11346002)(446003)(2906002)(229853002)(2616005)(476003)(36756003)(86362001)(31696002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB4218;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jIygXWtAzOL+QTZm7367nSSrS1XuE+Vh7y6XhoFC5bO4YSGsFVLIuRCKiBjkIrylFZtB6EYAs/HQIojChBu5F51puUJ47OSiVO6arObG3nsJk7qMOEZZ0gxw0ydsekpcBcf1wTPvVLiW0fsnuawK6Dagmq+t6HK81VuS4BKb4VKpddzbeLP1/+8msuH0YccbW24zcYOAMPUWI7gzOdOmSUDYUT6wb/2DBen9FlEel9+6Sfjx9/H43x3HlKLqx3cecMERaeoF4wAqJGFMkbvuA8ryyNXxPzJIuN5C5T6DGcpFWoyUNFlVsCREsCAe/hXQ+e14qWxh2/w6m5ObSJ/4ag0wwVJphdZcB6nH2SBDxL9d+Nwjjr8L1mA0/4zsB5WEo/4E13xGQZscbk2m1TuVNFFEG809pQI/qaSWkfsvsw4xz+RQCbNl01Mku28xpDEI
Content-Type: text/plain; charset="utf-8"
Content-ID: <468FC00634ABA3428AFE78F5CFD1C3F0@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a0756d9-fc36-429f-d175-08d756f521b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 13:38:33.7451
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LjcnZOYSDvKXyKYQvJeOKxZIIw8J8/h5JHGNbzjDzOQS0uBFRUgA2vQTfPYoYQFdogz+b5XRiFvDVK9utyxoKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4218
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCk9uIDEwLzIxLzE5IDc6NTcgUE0sIERhdmlkIFJpZW50amVzIHdyb3RlOg0KPiBPbiBNb24s
IDIxIE9jdCAyMDE5LCBTaW5naCwgQnJpamVzaCB3cm90ZToNCj4gDQo+Pj4+IEZyb206IEFzaGlz
aCBLYWxyYSA8YXNoaXNoLmthbHJhQGFtZC5jb20+DQo+Pj4+DQo+Pj4+IFNFViBJTklUIGNvbW1h
bmQgbG9hZHMgdGhlIFNFViByZWxhdGVkIHBlcnNpc3RlbnQgZGF0YSBmcm9tIE5WUw0KPj4+PiBh
bmQgaW5pdGlhbGl6ZXMgdGhlIHBsYXRmb3JtIGNvbnRleHQuIFRoZSBmaXJtd2FyZSB2YWxpZGF0
ZXMgdGhlDQo+Pj4+IHBlcnNpc3RlbnQgc3RhdGUuIElmIHZhbGlkYXRpb24gZmFpbHMsIHRoZSBm
aXJtd2FyZSB3aWxsIHJlc2V0DQo+Pj4+IHRoZSBwZXJzaXNlbnQgc3RhdGUgYW5kIHJldHVybiBh
biBpbnRlZ3JpdHkgY2hlY2sgZmFpbHVyZSBzdGF0dXMuDQo+Pj4+DQo+Pj4+IEF0IHRoaXMgcG9p
bnQsIGEgc3Vic2VxdWVudCBJTklUIGNvbW1hbmQgc2hvdWxkIHN1Y2NlZWQsIHNvIHJldHJ5DQo+
Pj4+IHRoZSBjb21tYW5kLiBUaGUgSU5JVCBjb21tYW5kIHJldHJ5IGlzIG9ubHkgZG9uZSBkdXJp
bmcgZHJpdmVyDQo+Pj4+IGluaXRpYWxpemF0aW9uLg0KPj4+Pg0KPj4+PiBBZGRpdGlvbmFsIGVu
dW1zIGFsb25nIHdpdGggU0VWX1JFVF9TRUNVUkVfREFUQV9JTlZBTElEIGFyZSBhZGRlZA0KPj4+
PiB0byBzZXZfcmV0X2NvZGUgdG8gbWFpbnRhaW4gY29udGludWl0eSBhbmQgcmVsZXZhbmNlIG9m
IGVudW0gdmFsdWVzLg0KPj4+Pg0KPj4+PiBTaWduZWQtb2ZmLWJ5OiBBc2hpc2ggS2FscmEgPGFz
aGlzaC5rYWxyYUBhbWQuY29tPg0KPj4+PiAtLS0NCj4+Pj4gICAgZHJpdmVycy9jcnlwdG8vY2Nw
L3BzcC1kZXYuYyB8IDEyICsrKysrKysrKysrKw0KPj4+PiAgICBpbmNsdWRlL3VhcGkvbGludXgv
cHNwLXNldi5oIHwgIDMgKysrDQo+Pj4+ICAgIDIgZmlsZXMgY2hhbmdlZCwgMTUgaW5zZXJ0aW9u
cygrKQ0KPj4+Pg0KPj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vY2NwL3BzcC1kZXYu
YyBiL2RyaXZlcnMvY3J5cHRvL2NjcC9wc3AtZGV2LmMNCj4+Pj4gaW5kZXggNmIxN2QxNzllZjhh
Li5mOTMxOGQ0NDgyZjIgMTAwNjQ0DQo+Pj4+IC0tLSBhL2RyaXZlcnMvY3J5cHRvL2NjcC9wc3At
ZGV2LmMNCj4+Pj4gKysrIGIvZHJpdmVycy9jcnlwdG8vY2NwL3BzcC1kZXYuYw0KPj4+PiBAQCAt
MTA2NCw2ICsxMDY0LDE4IEBAIHZvaWQgcHNwX3BjaV9pbml0KHZvaWQpDQo+Pj4+ICAgIA0KPj4+
PiAgICAJLyogSW5pdGlhbGl6ZSB0aGUgcGxhdGZvcm0gKi8NCj4+Pj4gICAgCXJjID0gc2V2X3Bs
YXRmb3JtX2luaXQoJmVycm9yKTsNCj4+Pj4gKwlpZiAocmMgJiYgKGVycm9yID09IFNFVl9SRVRf
U0VDVVJFX0RBVEFfSU5WQUxJRCkpIHsNCj4+Pj4gKwkJLyoNCj4+Pj4gKwkJICogSU5JVCBjb21t
YW5kIHJldHVybmVkIGFuIGludGVncml0eSBjaGVjayBmYWlsdXJlDQo+Pj4+ICsJCSAqIHN0YXR1
cyBjb2RlLCBtZWFuaW5nIHRoYXQgZmlybXdhcmUgbG9hZCBhbmQNCj4+Pj4gKwkJICogdmFsaWRh
dGlvbiBvZiBTRVYgcmVsYXRlZCBwZXJzaXN0ZW50IGRhdGEgaGFzDQo+Pj4+ICsJCSAqIGZhaWxl
ZCBhbmQgcGVyc2lzdGVudCBzdGF0ZSBoYXMgYmVlbiBlcmFzZWQuDQo+Pj4+ICsJCSAqIFJldHJ5
aW5nIElOSVQgY29tbWFuZCBoZXJlIHNob3VsZCBzdWNjZWVkLg0KPj4+PiArCQkgKi8NCj4+Pj4g
KwkJZGV2X2RiZyhzcC0+ZGV2LCAiU0VWOiByZXRyeWluZyBJTklUIGNvbW1hbmQiKTsNCj4+Pj4g
KwkJcmMgPSBzZXZfcGxhdGZvcm1faW5pdCgmZXJyb3IpOw0KPj4+PiArCX0NCj4+Pj4gKw0KPj4+
PiAgICAJaWYgKHJjKSB7DQo+Pj4+ICAgIAkJZGV2X2VycihzcC0+ZGV2LCAiU0VWOiBmYWlsZWQg
dG8gSU5JVCBlcnJvciAlI3hcbiIsIGVycm9yKTsNCj4+Pj4gICAgCQlyZXR1cm47DQo+Pj4NCj4+
PiBDdXJpb3VzIHdoeSB0aGlzIGlzbid0IGRvbmUgaW4gX19zZXZfcGxhdGZvcm1faW5pdF9sb2Nr
ZWQoKSBzaW5jZQ0KPj4+IHNldl9wbGF0Zm9ybV9pbml0KCkgY2FuIGJlIGNhbGxlZCB3aGVuIGxv
YWRpbmcgdGhlIGt2bSBtb2R1bGUgYW5kIHRoZSBzYW1lDQo+Pj4gaW5pdCBmYWlsdXJlIGNhbiBo
YXBwZW4gdGhhdCB3YXkuDQo+Pj4NCj4+DQo+PiBUaGUgRlcgaW5pdGlhbGl6YXRpb24gKGFrYSBQ
TEFURk9STV9JTklUKSBpcyBjYWxsZWQgaW4gdGhlIGZvbGxvd2luZw0KPj4gY29kZSBwYXRoczoN
Cj4+DQo+PiAxLiBEdXJpbmcgc3lzdGVtIGJvb3QgdXANCj4+DQo+PiBhbmQNCj4+DQo+PiAyLiBB
ZnRlciB0aGUgcGxhdGZvcm0gcmVzZXQgY29tbWFuZCBpcyBpc3N1ZWQNCj4+DQo+PiBUaGUgcGF0
Y2ggdGFrZXMgY2FyZSBvZiAjMS4gQmFzZWQgb24gdGhlIHNwZWMsIHBsYXRmb3JtIHJlc2V0IGNv
bW1hbmQNCj4+IHNob3VsZCBlcmFzZSB0aGUgcGVyc2lzdGVudCBkYXRhIGFuZCB0aGUgUExBVEZP
Uk1fSU5JVCBzaG91bGQgKm5vdCogZmFpbA0KPj4gd2l0aCBTRVZfUkVUX1NFQ1VSRV9EQVRBX0lO
VkFMSUQgZXJyb3IgY29kZS4gU28sIEkgYW0gbm90IGFibGUgdG8gc2VlDQo+PiBhbnkgIHN0cm9u
ZyByZWFzb24gdG8gbW92ZSB0aGUgcmV0cnkgY29kZSBpbg0KPj4gX19zZXZfcGxhdGZvcm1faW5p
dF9sb2NrZWQoKS4NCj4+DQo+IA0KPiBIbW0sIGlzIHRoZSBzZXZfcGxhdGZvcm1faW5pdCgpIGNh
bGwgaW4gc2V2X2d1ZXN0X2luaXQoKSBpbnRlbmRlZCB0byBkbw0KPiBTRVZfQ01EX0lOSVQgb25s
eSBhZnRlciBwbGF0Zm9ybSByZXNldD8gIEkgd2FzIHVuZGVyIHRoZSBpbXByZXNzaW9uIGl0IHdh
cw0KPiBkb25lIGluIGNhc2UgYW55IHByZXZpb3VzIGluaXQgZmFpbGVkLg0KPiANCg0KDQpUaGUg
UExBVEZPUk1fSU5JVCBjb21tYW5kIGlzIGFsbG93ZWQgb25seSB3aGVuIEZXIGlzIGluIFVJTklU
IHN0YXRlLiBPbg0KYm9vdCwgdGhlIEZXIHdpbGwgYmUgaW4gVU5JTklUIHN0YXRlIGFuZCBzaW1p
bGFybHkgYWZ0ZXIgdGhlIHBsYXRmb3JtIA0KcmVzZXQgY29tbWFuZCB0aGUgRlcgZ29lcyBiYWNr
IHRvIFVOSU5JVCBzdGF0ZS4NCg0KVGhlIF9fc2V2X3BsYXRmb3JtX2luaXRfbG9ja2VkKCkgY2hl
Y2tzIHRoZSBGVyBzdGF0ZSBiZWZvcmUgaXNzdWluZyB0aGUNCmNvbW1hbmQsIGlmIEZXIGlzIGFs
cmVhZHkgaW4gSU5JVCBzdGF0ZSB0aGVuIGl0IHJldHVybnMgaW1tZWRpYXRlbHkuDQoNCnRoYW5r
cw0K
