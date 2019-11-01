Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4E9EC92D
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 20:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfKATkA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 15:40:00 -0400
Received: from mail-eopbgr770042.outbound.protection.outlook.com ([40.107.77.42]:53413
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725536AbfKATj7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 15:39:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DbGpkSfke0Ym+sC9Uo3vYPptQw2zlS9PS60wjFAd8T9ZR37ywzrjH26BFae8WoqEz3Ga7EoL5GjoBAtCVkjaphUHfTI8KcPW0MZWQ3ps3+4f1XuS6nDkASlDaCZD6nGel0KLIxPFXIb3PKI+opR/BKrmkLhF3QBYzJhD5OivsL2MeNWHB62855pjfstjvgo3CgiEwIVQi3zM32irQIRD1UzS3B6dYzAsd6cbOMnPvUStdn5NgpBWfb1g8o8mvf9PcOnhFDM2uHQMOohglH7pF+EwoDyxOeyZPIBuklNUX8RSUgDUTPjLDgOlA634x4ZjTc8fwOSCz7igoR/GMqBR3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XYsHszAd/GHvxQ25SMPXdrqfm1rQ9O+UPQtOL42YxyY=;
 b=YIv9sF5zfwyXbm+206hkiCGkFIwKtwRAWLdbhnTGK0jx2CO2fWZG4r0BfJwqD6kGQ8PF1C7E/RPqRumNFtGZxDBK4NUurAEFFwEC+RoDQhNREGb+JsMiwfvOSQfO42MU8tiZf6oq3eBDiikqPHua0jTbRl65hNS0/6RAWhfKO3eXCBuUiqLkzaFgS3b9boodEJsoreUahIPLi3qK8IxefqT9Xhz0TjePiq/RxlY4pQEXX+423RbRyFoF8+gqsLUzfirwWlU+uToVbOKTIrheSaSXesCFEeNNP6vosvZLaLtEvFQp9OzYS0H6XB6xdtMh6aAghDWrM2W7FHqxdvJ/sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XYsHszAd/GHvxQ25SMPXdrqfm1rQ9O+UPQtOL42YxyY=;
 b=Q92zZHwJBBNjq9tCmKx9ckQer7jGh1FhpbaRAXtG3jWa14c4NG3mXQZ4819qJJln3K+95eW3aIDGO71vTR2O37E3E/cXJxNxNsNJOMpgr7/xfRrqwcBY5FPe9LwOy8txQ6/jF/xwGyddkSzLrbTy5bBXG2FCyrX512FVLrCT2qU=
Received: from BL0PR12MB2468.namprd12.prod.outlook.com (52.132.30.157) by
 BL0PR12MB2561.namprd12.prod.outlook.com (52.132.27.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Fri, 1 Nov 2019 19:39:55 +0000
Received: from BL0PR12MB2468.namprd12.prod.outlook.com
 ([fe80::748c:1f32:1a4d:acca]) by BL0PR12MB2468.namprd12.prod.outlook.com
 ([fe80::748c:1f32:1a4d:acca%7]) with mapi id 15.20.2387.028; Fri, 1 Nov 2019
 19:39:55 +0000
From:   "Moger, Babu" <Babu.Moger@amd.com>
To:     Jim Mattson <jmattson@google.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "nayna@linux.ibm.com" <nayna@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/4] kvm: x86: Dont set UMIP feature bit unconditionally
Thread-Topic: [PATCH 1/4] kvm: x86: Dont set UMIP feature bit unconditionally
Thread-Index: AQHVkNp+SVH8W6w/AkiSMfw9AT2Glad2pJ8AgAAR7gA=
Date:   Fri, 1 Nov 2019 19:39:55 +0000
Message-ID: <a5466e76-3a7b-2de7-ceb9-3d41bf5e4f4d@amd.com>
References: <157262960837.2838.17520432516398899751.stgit@naples-babu.amd.com>
 <157262961597.2838.16953618909905259198.stgit@naples-babu.amd.com>
 <CALMp9eTb8N-WxgQ_J5_siU=8=DGNUjM=UZCN5YkAQoofZHx1hA@mail.gmail.com>
In-Reply-To: <CALMp9eTb8N-WxgQ_J5_siU=8=DGNUjM=UZCN5YkAQoofZHx1hA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR05CA0035.namprd05.prod.outlook.com
 (2603:10b6:805:de::48) To BL0PR12MB2468.namprd12.prod.outlook.com
 (2603:10b6:207:44::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Babu.Moger@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4c6bd757-3665-46dc-8c9b-08d75f034582
x-ms-traffictypediagnostic: BL0PR12MB2561:
x-microsoft-antispam-prvs: <BL0PR12MB2561D78BDFE041B5203FEF7395620@BL0PR12MB2561.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(376002)(366004)(346002)(396003)(189003)(199004)(66066001)(6116002)(66446008)(26005)(102836004)(476003)(99286004)(7736002)(81156014)(7416002)(8936002)(305945005)(186003)(52116002)(64756008)(76176011)(31686004)(4326008)(66556008)(14444005)(256004)(81166006)(8676002)(229853002)(6436002)(6506007)(486006)(66476007)(6512007)(386003)(6486002)(53546011)(36756003)(6916009)(2616005)(14454004)(66946007)(71200400001)(86362001)(71190400001)(5660300002)(54906003)(316002)(25786009)(11346002)(446003)(478600001)(3846002)(6246003)(2906002)(31696002)(192303002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR12MB2561;H:BL0PR12MB2468.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v4EZW5zb78kadaIu/nZ8kGVtlThWF4dv8rVc6I/ykoVSKaDso1jxreW0yBk/NAb2hHT9bIsjjJNk+fZ1SEVTaEoIk2PeFf5KZEy+1A3SiiAtkm73Gk9HYwvdNw7hQJIBfGQYyjF1+s/1T+u2oJGC7S6TMrx+XcAAhTENj5RKT3BX7td4XHuWcEQ+GFGySl3vijf6l9UZxEcVmcgk9/RzAMj6aFDZ7Y8rpy7yAcT67UA2w2ZZaAYFVbh3Mk3DYyc2qshJN1IZG/W7tnIkjU0TlVNkbZBa1f7zPx++xhyMYUh1Sa9dmSMQvQBfPEHi9kExhL08tP8JKU8L38SWSYHuYbZTAZJZDB+T/uFB+lQ2IfgvPivTgNjaJWskDYYX2p+0czhsyvQC+r2jT9DaAIVwN6Ju30/3lXMi5XEbufoVr1XIw4FEdqk6zwdamZAO/mkP
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <7D25C0E604FEE44DB85A5A07B1900CB0@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c6bd757-3665-46dc-8c9b-08d75f034582
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 19:39:55.6596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AYmZxjDV//WoARLVXdhsmjicSOVBz+xP8w7u6hLZ3yNne5DhOf2tevmlsa7lK/BZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2561
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCk9uIDExLzEvMTkgMTozNSBQTSwgSmltIE1hdHRzb24gd3JvdGU6DQo+IE9uIEZyaSwgTm92
IDEsIDIwMTkgYXQgMTA6MzMgQU0gTW9nZXIsIEJhYnUgPEJhYnUuTW9nZXJAYW1kLmNvbT4gd3Jv
dGU6DQo+Pg0KPj4gVGhlIFVNSVAgKFVzZXItTW9kZSBJbnN0cnVjdGlvbiBQcmV2ZW50aW9uKSBm
ZWF0dXJlIGJpdCBzaG91bGQgYmUNCj4+IHNldCBpZiB0aGUgZW11bGF0aW9uIChrdm1feDg2X29w
cy0+dW1pcF9lbXVsYXRlZCkgaXMgc3VwcG9ydGVkDQo+PiB3aGljaCBpcyBkb25lIGFscmVhZHku
DQo+Pg0KPj4gUmVtb3ZlIHRoZSB1bmNvbmRpdGlvbmFsIHNldHRpbmcgb2YgdGhpcyBiaXQuDQo+
Pg0KPj4gRml4ZXM6IGFlM2U2MWUxYzI4MzM4ZDAgKCJLVk06IHg4NjogYWRkIHN1cHBvcnQgZm9y
IFVNSVAiKQ0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IEJhYnUgTW9nZXIgPGJhYnUubW9nZXJAYW1k
LmNvbT4NCj4+IC0tLQ0KPj4gIGFyY2gveDg2L2t2bS9jcHVpZC5jIHwgICAgMiArLQ0KPj4gIDEg
ZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPj4NCj4+IGRpZmYg
LS1naXQgYS9hcmNoL3g4Ni9rdm0vY3B1aWQuYyBiL2FyY2gveDg2L2t2bS9jcHVpZC5jDQo+PiBp
bmRleCBmNjhjMGM3NTNjMzguLjViODFiYTVhZDQyOCAxMDA2NDQNCj4+IC0tLSBhL2FyY2gveDg2
L2t2bS9jcHVpZC5jDQo+PiArKysgYi9hcmNoL3g4Ni9rdm0vY3B1aWQuYw0KPj4gQEAgLTM2NCw3
ICszNjQsNyBAQCBzdGF0aWMgaW5saW5lIHZvaWQgZG9fY3B1aWRfN19tYXNrKHN0cnVjdCBrdm1f
Y3B1aWRfZW50cnkyICplbnRyeSwgaW50IGluZGV4KQ0KPj4gICAgICAgICAvKiBjcHVpZCA3LjAu
ZWN4Ki8NCj4+ICAgICAgICAgY29uc3QgdTMyIGt2bV9jcHVpZF83XzBfZWN4X3g4Nl9mZWF0dXJl
cyA9DQo+PiAgICAgICAgICAgICAgICAgRihBVlg1MTJWQk1JKSB8IEYoTEE1NykgfCBGKFBLVSkg
fCAwIC8qT1NQS0UqLyB8IEYoUkRQSUQpIHwNCj4+IC0gICAgICAgICAgICAgICBGKEFWWDUxMl9W
UE9QQ05URFEpIHwgRihVTUlQKSB8IEYoQVZYNTEyX1ZCTUkyKSB8IEYoR0ZOSSkgfA0KPj4gKyAg
ICAgICAgICAgICAgIEYoQVZYNTEyX1ZQT1BDTlREUSkgfCBGKEFWWDUxMl9WQk1JMikgfCBGKEdG
TkkpIHwNCj4+ICAgICAgICAgICAgICAgICBGKFZBRVMpIHwgRihWUENMTVVMUURRKSB8IEYoQVZY
NTEyX1ZOTkkpIHwgRihBVlg1MTJfQklUQUxHKSB8DQo+PiAgICAgICAgICAgICAgICAgRihDTERF
TU9URSkgfCBGKE1PVkRJUkkpIHwgRihNT1ZESVI2NEIpIHwgMCAvKldBSVRQS0cqLzsNCj4+DQo+
IA0KPiBUaGlzIGlzbid0IHVuY29uZGl0aW9uYWwuIFRoaXMgaXMgbWFza2VkIGJ5IHRoZSBmZWF0
dXJlcyBvbiB0aGUgYm9vdA0KPiBDUFUuIFNpbmNlIFVNSVAgY2FuIGJlIHZpcnR1YWxpemVkICh3
aXRob3V0IGVtdWxhdGlvbikgb24gQ1BVcyB0aGF0DQo+IHN1cHBvcnQgVU1JUCwgeW91IHNob3Vs
ZCBsZWF2ZSB0aGlzIGFsb25lLg0KPiANCg0KVGhlcmUgaXMgc29tZSBpbmNvbnN0YW5jeSBoZXJl
Lg0KDQpzdGF0aWMgaW5saW5lIGludCBfX2RvX2NwdWlkX2VudChzdHJ1Y3Qga3ZtX2NwdWlkX2Vu
dHJ5MiAqZW50cnksIHUzMg0KDQp1bnNpZ25lZCBmX3VtaXAgPSBrdm1feDg2X29wcy0+dW1pcF9l
bXVsYXRlZCgpID8gRihVTUlQKSA6IDA7DQouLi4NCg0KY2FzZSA3OiB7DQogICAgICAgICAgICAg
Li4NCiAgICAgICAgICAgIGVudHJ5LT5lY3ggfD0gZl91bWlwOw0KICAgICAgICAgICAgLi4NCiAg
ICAgICAgfQ0KDQphbmQNCnN0YXRpYyBib29sIHN2bV91bWlwX2VtdWxhdGVkKHZvaWQpDQp7DQog
ICAgICAgIHJldHVybiBmYWxzZTsNCn0NCg0Kc3RhdGljIGlubGluZSBib29sIHZteF91bWlwX2Vt
dWxhdGVkKHZvaWQpDQp7DQogICAgICAgIHJldHVybiB2bWNzX2NvbmZpZy5jcHVfYmFzZWRfMm5k
X2V4ZWNfY3RybCAmDQogICAgICAgICAgICAgICAgU0VDT05EQVJZX0VYRUNfREVTQzsNCn0NCg0K
DQpJdCBhcHBlYXJzIHRoYXQgaW50ZW50aW9uIHdhcyB0byBlbmFibGUgdGhlIFVNSVAgaWYgU1ZN
IG9yIFZNWCBzdXBwb3J0DQp1bWlwIGVtdWxhdGlvbi4gQnV0IHRoYXQgaXMgbm90IGhvdyBpdCBp
cyB3b3JraW5nIG5vdy4gTm93IGl0IGlzIGVuYWJsZWQNCmlmIGJvb3QgQ1BVIHN1cHBvcnRzIFVN
SVAuDQoNCg==
