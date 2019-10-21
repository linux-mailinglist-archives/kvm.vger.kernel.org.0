Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83950DF4EC
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 20:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729425AbfJUSQw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 14:16:52 -0400
Received: from mail-eopbgr810079.outbound.protection.outlook.com ([40.107.81.79]:34272
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727767AbfJUSQw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 14:16:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RhSanYzXvwg/DZmuVGwHoR79RJPM/B0JiDOhOAcZaodW/6PQd4NdxSqptvxiBE1QAxvq6QQNAywFx5ib7YuVF9KPEufmAK78aqZXTU6JFsmL+V0BM73VRpBU6va/ZsAGIPpg64djKaVXCu91TNZ+3sNARIp2R5izMQpXrYmL6i9dMVJay98J7A7mtL54/tS1QvdXKswir3mhm/Bo0Mar1X5BHsUqoj3VQ0HZXI0CLYEF6Fb6SA+rGE7o23UhWy3v8wHdMIpP182mDnmg/HDT5x5CWMlqm3A73ZgPmDWy/DBzVnL9zvgJt2H7AHsc2vXiTbgPpAwKrG6rb0g5j/hj0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RRc1WrujN5kJ3TYU4P01saYk01F9Bw75zeFqiI4CDSU=;
 b=NSHBkS14DSj/R+Z84MpoqzmOWNo+gEz7kA1L7jT1BHoxJJACsEeWO3WphKTLn+CuOA/R7rRMiOrcQP10W5MMvA0bkxJiEb0xLVtWYIBiV7CezQpvoXS+8SnA+IkRDgJir5a77bRk5eu3Ms1QPGRXCL4BZvitj7gtTHi5WkUMxLAjr5hXnzPfWxqchmb3dNERFZ3dzN4yw2+0drH4phJSMaRxE66C0g3OU7vYAi2MXd+Joo4cCOTgYVmh5ZiPnDAG3weLgj29wlAryaEJ2SAblF0On4LwvletIQy+8svMd+9C7/3/efvcBIUwPMcE+0t1xUcYg50tD/0XALGfNOzu8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RRc1WrujN5kJ3TYU4P01saYk01F9Bw75zeFqiI4CDSU=;
 b=ffLm16wM58W6VJzAXlNSP4N15uLUGcEL+LHUkpS5PD9rieREGWA4rHztSObS3wJJVgxM8eLqARCJkafD4jygGAZb/3G2c0ZQ+hdI8e31NhwvxSPfacYPwBfPdBU3dNjErNkJuKP9hR+YanPsUL/0nmIRzD/6Yoso9bRVwJNuBSg=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.118.13) by
 DM6PR12MB3804.namprd12.prod.outlook.com (10.255.173.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.19; Mon, 21 Oct 2019 18:16:48 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::80:cb81:4a0e:a36]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::80:cb81:4a0e:a36%3]) with mapi id 15.20.2367.022; Mon, 21 Oct 2019
 18:16:48 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     David Rientjes <rientjes@google.com>,
        "Kalra, Ashish" <Ashish.Kalra@amd.com>
CC:     "Singh, Brijesh" <brijesh.singh@amd.com>,
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
Thread-Index: AQHVhTsiVAXVZvJHqE+F84WTgpVS9KdhrHEAgAPAfIA=
Date:   Mon, 21 Oct 2019 18:16:48 +0000
Message-ID: <29887804-ecab-ae83-8d3f-52ea83e44b4e@amd.com>
References: <20191017223459.64281-1-Ashish.Kalra@amd.com>
 <alpine.DEB.2.21.1910190156210.140416@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.21.1910190156210.140416@chino.kir.corp.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR06CA0005.namprd06.prod.outlook.com
 (2603:10b6:805:8e::18) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:42::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 037887d9-b2f1-47aa-3a51-08d75652d682
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DM6PR12MB3804:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB38048E06148278D31C040F50E5690@DM6PR12MB3804.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0197AFBD92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(396003)(136003)(39860400002)(199004)(189003)(8936002)(54906003)(478600001)(31696002)(71190400001)(71200400001)(8676002)(66556008)(66476007)(66446008)(64756008)(31686004)(316002)(86362001)(66066001)(66946007)(81156014)(81166006)(6636002)(14454004)(110136005)(25786009)(6512007)(7416002)(446003)(3846002)(2906002)(486006)(99286004)(36756003)(14444005)(256004)(5660300002)(11346002)(2616005)(6436002)(6486002)(229853002)(4326008)(476003)(26005)(76176011)(186003)(6246003)(7736002)(102836004)(53546011)(6506007)(386003)(52116002)(305945005)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3804;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vFeydfWMRRzbKTgZNGeNyNPfoh0zNstXqZwksGVNkozBtRgzeawR1hPAIIs5c85b19y7uIusONHhLHkrfSeheUxTxtT/YOMXe/mMFwzrtSAWj959SL84XVV9kb43HzDLz8r/oyA8fDYeffUj0AZKj7ZSE46TwpWVwVLrIyavqCLfIysTc48UcuGDhdyZG0SKhdFJoog85cd9HQF6hBx+P7FSiD7NP3ChpJuOcnFRUIOcUe1z5nJcKh6aZxG7WwQRH12T5ecHft0ksyv97sPmHtQNjtV5E0+rxIcaXOKaLsCuzqIHD8oS6Gdq/BRRMhb9BGTgsMVOGrZKSSdjzCpcoYvsdQxUcMP4wmE+hfXOAuBrmF1pAQ9LgNlLDLosY5X9dp4kH2Wl+mLS9Up6MFHk5Z+7mBtDoIv/fBy8mdX+T7c=
Content-Type: text/plain; charset="utf-8"
Content-ID: <777077A0761C7646BDBB320395BA0C30@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 037887d9-b2f1-47aa-3a51-08d75652d682
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2019 18:16:48.5628
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XMk0pQOeAgLeyKYB2Awl3LX5Wb8CQwuzEZ7x9nHilUpdjwXk2/yTRyyVULrl5+KYo6KZaMqF/QTxFaOdxOOgnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3804
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCk9uIDEwLzE5LzE5IDM6NTkgQU0sIERhdmlkIFJpZW50amVzIHdyb3RlOg0KPiBPbiBUaHUs
IDE3IE9jdCAyMDE5LCBLYWxyYSwgQXNoaXNoIHdyb3RlOg0KPiANCj4+IEZyb206IEFzaGlzaCBL
YWxyYSA8YXNoaXNoLmthbHJhQGFtZC5jb20+DQo+Pg0KPj4gU0VWIElOSVQgY29tbWFuZCBsb2Fk
cyB0aGUgU0VWIHJlbGF0ZWQgcGVyc2lzdGVudCBkYXRhIGZyb20gTlZTDQo+PiBhbmQgaW5pdGlh
bGl6ZXMgdGhlIHBsYXRmb3JtIGNvbnRleHQuIFRoZSBmaXJtd2FyZSB2YWxpZGF0ZXMgdGhlDQo+
PiBwZXJzaXN0ZW50IHN0YXRlLiBJZiB2YWxpZGF0aW9uIGZhaWxzLCB0aGUgZmlybXdhcmUgd2ls
bCByZXNldA0KPj4gdGhlIHBlcnNpc2VudCBzdGF0ZSBhbmQgcmV0dXJuIGFuIGludGVncml0eSBj
aGVjayBmYWlsdXJlIHN0YXR1cy4NCj4+DQo+PiBBdCB0aGlzIHBvaW50LCBhIHN1YnNlcXVlbnQg
SU5JVCBjb21tYW5kIHNob3VsZCBzdWNjZWVkLCBzbyByZXRyeQ0KPj4gdGhlIGNvbW1hbmQuIFRo
ZSBJTklUIGNvbW1hbmQgcmV0cnkgaXMgb25seSBkb25lIGR1cmluZyBkcml2ZXINCj4+IGluaXRp
YWxpemF0aW9uLg0KPj4NCj4+IEFkZGl0aW9uYWwgZW51bXMgYWxvbmcgd2l0aCBTRVZfUkVUX1NF
Q1VSRV9EQVRBX0lOVkFMSUQgYXJlIGFkZGVkDQo+PiB0byBzZXZfcmV0X2NvZGUgdG8gbWFpbnRh
aW4gY29udGludWl0eSBhbmQgcmVsZXZhbmNlIG9mIGVudW0gdmFsdWVzLg0KPj4NCj4+IFNpZ25l
ZC1vZmYtYnk6IEFzaGlzaCBLYWxyYSA8YXNoaXNoLmthbHJhQGFtZC5jb20+DQo+PiAtLS0NCj4+
ICAgZHJpdmVycy9jcnlwdG8vY2NwL3BzcC1kZXYuYyB8IDEyICsrKysrKysrKysrKw0KPj4gICBp
bmNsdWRlL3VhcGkvbGludXgvcHNwLXNldi5oIHwgIDMgKysrDQo+PiAgIDIgZmlsZXMgY2hhbmdl
ZCwgMTUgaW5zZXJ0aW9ucygrKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9j
Y3AvcHNwLWRldi5jIGIvZHJpdmVycy9jcnlwdG8vY2NwL3BzcC1kZXYuYw0KPj4gaW5kZXggNmIx
N2QxNzllZjhhLi5mOTMxOGQ0NDgyZjIgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL2NyeXB0by9j
Y3AvcHNwLWRldi5jDQo+PiArKysgYi9kcml2ZXJzL2NyeXB0by9jY3AvcHNwLWRldi5jDQo+PiBA
QCAtMTA2NCw2ICsxMDY0LDE4IEBAIHZvaWQgcHNwX3BjaV9pbml0KHZvaWQpDQo+PiAgIA0KPj4g
ICAJLyogSW5pdGlhbGl6ZSB0aGUgcGxhdGZvcm0gKi8NCj4+ICAgCXJjID0gc2V2X3BsYXRmb3Jt
X2luaXQoJmVycm9yKTsNCj4+ICsJaWYgKHJjICYmIChlcnJvciA9PSBTRVZfUkVUX1NFQ1VSRV9E
QVRBX0lOVkFMSUQpKSB7DQo+PiArCQkvKg0KPj4gKwkJICogSU5JVCBjb21tYW5kIHJldHVybmVk
IGFuIGludGVncml0eSBjaGVjayBmYWlsdXJlDQo+PiArCQkgKiBzdGF0dXMgY29kZSwgbWVhbmlu
ZyB0aGF0IGZpcm13YXJlIGxvYWQgYW5kDQo+PiArCQkgKiB2YWxpZGF0aW9uIG9mIFNFViByZWxh
dGVkIHBlcnNpc3RlbnQgZGF0YSBoYXMNCj4+ICsJCSAqIGZhaWxlZCBhbmQgcGVyc2lzdGVudCBz
dGF0ZSBoYXMgYmVlbiBlcmFzZWQuDQo+PiArCQkgKiBSZXRyeWluZyBJTklUIGNvbW1hbmQgaGVy
ZSBzaG91bGQgc3VjY2VlZC4NCj4+ICsJCSAqLw0KPj4gKwkJZGV2X2RiZyhzcC0+ZGV2LCAiU0VW
OiByZXRyeWluZyBJTklUIGNvbW1hbmQiKTsNCj4+ICsJCXJjID0gc2V2X3BsYXRmb3JtX2luaXQo
JmVycm9yKTsNCj4+ICsJfQ0KPj4gKw0KPj4gICAJaWYgKHJjKSB7DQo+PiAgIAkJZGV2X2Vycihz
cC0+ZGV2LCAiU0VWOiBmYWlsZWQgdG8gSU5JVCBlcnJvciAlI3hcbiIsIGVycm9yKTsNCj4+ICAg
CQlyZXR1cm47DQo+IA0KPiBDdXJpb3VzIHdoeSB0aGlzIGlzbid0IGRvbmUgaW4gX19zZXZfcGxh
dGZvcm1faW5pdF9sb2NrZWQoKSBzaW5jZQ0KPiBzZXZfcGxhdGZvcm1faW5pdCgpIGNhbiBiZSBj
YWxsZWQgd2hlbiBsb2FkaW5nIHRoZSBrdm0gbW9kdWxlIGFuZCB0aGUgc2FtZQ0KPiBpbml0IGZh
aWx1cmUgY2FuIGhhcHBlbiB0aGF0IHdheS4NCj4gDQoNClRoZSBGVyBpbml0aWFsaXphdGlvbiAo
YWthIFBMQVRGT1JNX0lOSVQpIGlzIGNhbGxlZCBpbiB0aGUgZm9sbG93aW5nDQpjb2RlIHBhdGhz
Og0KDQoxLiBEdXJpbmcgc3lzdGVtIGJvb3QgdXANCg0KYW5kDQoNCjIuIEFmdGVyIHRoZSBwbGF0
Zm9ybSByZXNldCBjb21tYW5kIGlzIGlzc3VlZA0KDQpUaGUgcGF0Y2ggdGFrZXMgY2FyZSBvZiAj
MS4gQmFzZWQgb24gdGhlIHNwZWMsIHBsYXRmb3JtIHJlc2V0IGNvbW1hbmQNCnNob3VsZCBlcmFz
ZSB0aGUgcGVyc2lzdGVudCBkYXRhIGFuZCB0aGUgUExBVEZPUk1fSU5JVCBzaG91bGQgKm5vdCog
ZmFpbA0Kd2l0aCBTRVZfUkVUX1NFQ1VSRV9EQVRBX0lOVkFMSUQgZXJyb3IgY29kZS4gU28sIEkg
YW0gbm90IGFibGUgdG8gc2VlDQphbnkgIHN0cm9uZyByZWFzb24gdG8gbW92ZSB0aGUgcmV0cnkg
Y29kZSBpbg0KX19zZXZfcGxhdGZvcm1faW5pdF9sb2NrZWQoKS4NCg0KdGhhbmtzDQo=
