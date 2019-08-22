Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23097994E3
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 15:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387611AbfHVNXR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 09:23:17 -0400
Received: from mail-eopbgr750071.outbound.protection.outlook.com ([40.107.75.71]:44270
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731211AbfHVNXQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 09:23:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Er7bBApvfPSbEIEn6ExbjgqDB3UsFuHkkOLIJsO6j6IMvLyB99dgEJmhD0+r2Sl/IMoXIojHVNukSHM0kjnkxfD6kI3sTFaUES3b1yaFFEDrFW3/xVTWvkh3djuDyL+9Pg2DpCrfk7MDdCWVeKey6atfkdUpmY9sz7qOHsUov6zyienR5xJ69mEOq7LVPcpUWVGoCpi5ZpHeddhmmjuazgqitbzVdooIX9cr0eaHOXqaNQzdzstlmv7RJl7Jw4RaksNN9ac1EKz6NVby4ce/7tf2fK8VRo0b+jo6OxqM8ruuRg/XganZrN3CqPz3sZ9Tx5rXjQ2Pih0k8xy9fYPouA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ef7DkQO/JXCm0VhQFyOEUF3BgOAe5aYAwf5A6gDDsd4=;
 b=gij9cDy9+mYs+gBq+u6ySK7tS2E08cEY8IoSNWIHfSo3mRK3s40Rv2wzgcQT7X3UpqFbmocnX2VYuVW2VkEyChK8USEa2Q1XvMA603UDDFV0uMdIkgMCx/YUPvpQcDtenzWqsdpwaFyDG0OL4YaPRcxj56YGz/4SqTJYYJw8xZ/bMiMszW8CuhaIjuhAoNY2MIiXXCLzYDwZ7uk2CcQrAuJrQ6akd8ld5GAKD+rrINDdXy/Jw8FdzfPJ6PGj6eCKonUYcT9jWjHHJdI9p6NVxPowBmESiYd0AofVd1fP4sYTd2rrhCGQ4YKzuXxThyDleUkysO0oB8oV+YXWtUoYOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ef7DkQO/JXCm0VhQFyOEUF3BgOAe5aYAwf5A6gDDsd4=;
 b=aGskMCbbSnXwtYn82+lPjW5fVZZI8IHmULieOojZ0h4CN8SZsPI4/2kDpAAFUjZ9uLq8zydNkRidEjd3HFfLGy55L9EHIHrmyzvZ++DhW2m8sVqbp149I9ZBjHnnpxEo+vWr4AflCJTyJ0DzogUbhxsXA4jucBnq+PpJhjUClf0=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.118.13) by
 DM6PR12MB2762.namprd12.prod.outlook.com (20.176.117.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Thu, 22 Aug 2019 13:23:12 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::a410:b3e6:1557:7450]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::a410:b3e6:1557:7450%6]) with mapi id 15.20.2178.020; Thu, 22 Aug 2019
 13:23:12 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     Borislav Petkov <bp@suse.de>
CC:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 01/11] KVM: SVM: Add KVM_SEV SEND_START command
Thread-Topic: [PATCH v3 01/11] KVM: SVM: Add KVM_SEV SEND_START command
Thread-Index: AQHVN1vfwI3dyIr5KUOzgRYnzjsexKcHNFIAgAA2cYA=
Date:   Thu, 22 Aug 2019 13:23:11 +0000
Message-ID: <e3f5a925-908d-a1f7-f279-98cdd1506013@amd.com>
References: <20190710201244.25195-1-brijesh.singh@amd.com>
 <20190710201244.25195-2-brijesh.singh@amd.com>
 <20190822100818.GB11845@zn.tnic>
In-Reply-To: <20190822100818.GB11845@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0401CA0026.namprd04.prod.outlook.com
 (2603:10b6:803:2a::12) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:42::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ef404635-2572-4880-e3e0-08d72703e154
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR12MB2762;
x-ms-traffictypediagnostic: DM6PR12MB2762:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB2762D6B3FCF3ACCE40E88320E5A50@DM6PR12MB2762.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(396003)(376002)(136003)(346002)(189003)(199004)(25786009)(7416002)(446003)(8936002)(478600001)(7736002)(316002)(6916009)(256004)(54906003)(66066001)(66946007)(66476007)(8676002)(6512007)(305945005)(31686004)(5660300002)(99286004)(66446008)(66556008)(6486002)(76176011)(66574012)(71200400001)(71190400001)(6506007)(53546011)(386003)(102836004)(4326008)(6436002)(64756008)(11346002)(486006)(14454004)(2906002)(2616005)(476003)(26005)(6116002)(31696002)(3846002)(186003)(53936002)(6246003)(36756003)(52116002)(81156014)(229853002)(86362001)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2762;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wcsWsZHJBEOcHd4Rqa47PLiBnNlzkIwS5QSuW3obRBzoi6NfuZ0RU8Dfc9dia+jaJbPXlSBdXvCML91S+m4qtlSXDfTelnBMsjccT3bmqa/G/PIBUuHRfJnLTo9cOlMwngBTafVbgGGH+v8P1Y13mAcNGzOmQrM0uQF/d01hMhRuiriHgtT/x7DW0qyZ3ixhXrGgny33/C7iZ6Sco64ron9HRO0wig6Q/qpdrSqhDy7/JsGnDqlWmaRTY1labNdMHitmfkWWZyIaqm3wNGHVgN4K69pa9e4bK5wrMHc80EYVl6Ixo+GsHyvGSfJhBNXbLTLdd7S4nJ78/u7TnRLEyP/0k7nzm91KlgOdTzbeo6jZ6vWgxsNmmHk4TcNAAqbb9H7nAf1NRs8ZNw5O5BsSLOK+qkWf1roP2u+R4nJVDHs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FC1AC2C2482741408F4937D8F749F46C@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef404635-2572-4880-e3e0-08d72703e154
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 13:23:12.3611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GSBS3TA5UFJ8x6pI5K14O5IpBb78KbtSJczZqOgBoNa80yLjGhO7vWSuD36zTTw4pkTeZdFZEIIpcUPelzA+ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2762
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCk9uIDgvMjIvMTkgNTowOCBBTSwgQm9yaXNsYXYgUGV0a292IHdyb3RlOg0KPiBPbiBXZWQs
IEp1bCAxMCwgMjAxOSBhdCAwODoxMzowMFBNICswMDAwLCBTaW5naCwgQnJpamVzaCB3cm90ZToN
Cj4+IFRoZSBjb21tYW5kIGlzIHVzZWQgdG8gY3JlYXRlIGFuIG91dGdvaW5nIFNFViBndWVzdCBl
bmNyeXB0aW9uIGNvbnRleHQuDQo+Pg0KPj4gQ2M6IFRob21hcyBHbGVpeG5lciA8dGdseEBsaW51
dHJvbml4LmRlPg0KPj4gQ2M6IEluZ28gTW9sbmFyIDxtaW5nb0ByZWRoYXQuY29tPg0KPj4gQ2M6
ICJILiBQZXRlciBBbnZpbiIgPGhwYUB6eXRvci5jb20+DQo+PiBDYzogUGFvbG8gQm9uemluaSA8
cGJvbnppbmlAcmVkaGF0LmNvbT4NCj4+IENjOiAiUmFkaW0gS3LEjW3DocWZIiA8cmtyY21hckBy
ZWRoYXQuY29tPg0KPj4gQ2M6IEpvZXJnIFJvZWRlbCA8am9yb0A4Ynl0ZXMub3JnPg0KPj4gQ2M6
IEJvcmlzbGF2IFBldGtvdiA8YnBAc3VzZS5kZT4NCj4+IENjOiBUb20gTGVuZGFja3kgPHRob21h
cy5sZW5kYWNreUBhbWQuY29tPg0KPj4gQ2M6IHg4NkBrZXJuZWwub3JnDQo+PiBDYzoga3ZtQHZn
ZXIua2VybmVsLm9yZw0KPj4gQ2M6IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4+IFNp
Z25lZC1vZmYtYnk6IEJyaWplc2ggU2luZ2ggPGJyaWplc2guc2luZ2hAYW1kLmNvbT4NCj4+IC0t
LQ0KPj4gICAuLi4vdmlydHVhbC9rdm0vYW1kLW1lbW9yeS1lbmNyeXB0aW9uLnJzdCAgICAgfCAg
MjcgKysrKysNCj4+ICAgYXJjaC94ODYva3ZtL3N2bS5jICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHwgMTA1ICsrKysrKysrKysrKysrKysrKw0KPj4gICBpbmNsdWRlL3VhcGkvbGludXgva3Zt
LmggICAgICAgICAgICAgICAgICAgICAgfCAgMTIgKysNCj4+ICAgMyBmaWxlcyBjaGFuZ2VkLCAx
NDQgaW5zZXJ0aW9ucygrKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL3ZpcnR1
YWwva3ZtL2FtZC1tZW1vcnktZW5jcnlwdGlvbi5yc3QgYi9Eb2N1bWVudGF0aW9uL3ZpcnR1YWwv
a3ZtL2FtZC1tZW1vcnktZW5jcnlwdGlvbi5yc3QNCj4+IGluZGV4IGQxOGM5N2I0ZTE0MC4uMGU5
ZTFlOWY5Njg3IDEwMDY0NA0KPj4gLS0tIGEvRG9jdW1lbnRhdGlvbi92aXJ0dWFsL2t2bS9hbWQt
bWVtb3J5LWVuY3J5cHRpb24ucnN0DQo+PiArKysgYi9Eb2N1bWVudGF0aW9uL3ZpcnR1YWwva3Zt
L2FtZC1tZW1vcnktZW5jcnlwdGlvbi5yc3QNCj4gDQo+IERvIGENCj4gDQo+IHMvdmlydHVhbC92
aXJ0L2cNCj4gDQo+IGZvciB0aGUgbmV4dCByZXZpc2lvbiBiZWNhdXNlIHRoaXMgcGF0aCBnb3Qg
Y2hhbmdlZCByZWNlbnRseToNCj4gDQo+IDJmNTk0N2RmY2FlYyAoIkRvY3VtZW50YXRpb246IG1v
dmUgRG9jdW1lbnRhdGlvbi92aXJ0dWFsIHRvIERvY3VtZW50YXRpb24vdmlydCIpDQo+IA0KPj4g
QEAgLTIzOCw2ICsyMzgsMzMgQEAgUmV0dXJuczogMCBvbiBzdWNjZXNzLCAtbmVnYXRpdmUgb24g
ZXJyb3INCj4+ICAgICAgICAgICAgICAgICAgIF9fdTMyIHRyYW5zX2xlbjsNCj4+ICAgICAgICAg
ICB9Ow0KPj4gICANCj4+ICsxMC4gS1ZNX1NFVl9TRU5EX1NUQVJUDQo+PiArLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLQ0KPj4gKw0KPj4gK1RoZSBLVk1fU0VWX1NFTkRfU1RBUlQgY29tbWFuZCBjYW4g
YmUgdXNlZCBieSB0aGUgaHlwZXJ2aXNvciB0byBjcmVhdGUgYW4NCj4+ICtvdXRnb2luZyBndWVz
dCBlbmNyeXB0aW9uIGNvbnRleHQuDQo+PiArDQo+PiArUGFyYW1ldGVycyAoaW4pOiBzdHJ1Y3Qg
a3ZtX3Nldl9zZW5kX3N0YXJ0DQo+PiArDQo+PiArUmV0dXJuczogMCBvbiBzdWNjZXNzLCAtbmVn
YXRpdmUgb24gZXJyb3INCj4+ICsNCj4+ICs6Og0KPj4gKyAgICAgICAgc3RydWN0IGt2bV9zZXZf
c2VuZF9zdGFydCB7DQo+PiArICAgICAgICAgICAgICAgIF9fdTMyIHBvbGljeTsgICAgICAgICAg
ICAgICAgIC8qIGd1ZXN0IHBvbGljeSAqLw0KPj4gKw0KPj4gKyAgICAgICAgICAgICAgICBfX3U2
NCBwZGhfY2VydF91YWRkcjsgICAgICAgICAvKiBwbGF0Zm9ybSBEaWZmaWUtSGVsbG1hbiBjZXJ0
aWZpY2F0ZSAqLw0KPj4gKyAgICAgICAgICAgICAgICBfX3UzMiBwZGhfY2VydF9sZW47DQo+PiAr
DQo+PiArICAgICAgICAgICAgICAgIF9fdTY0IHBsYXRfY2VydF91YWRkcjsgICAgICAgIC8qIHBs
YXRmb3JtIGNlcnRpZmljYXRlIGNoYWluICovDQo+PiArICAgICAgICAgICAgICAgIF9fdTMyIHBs
YXRfY2VydF9sZW47DQo+PiArDQo+PiArICAgICAgICAgICAgICAgIF9fdTY0IGFtZF9jZXJ0X3Vh
ZGRyOyAgICAgICAgIC8qIEFNRCBjZXJ0aWZpY2F0ZSAqLw0KPj4gKyAgICAgICAgICAgICAgICBf
X3UzMiBhbWRfY2VydF9sZW47DQo+PiArDQo+PiArICAgICAgICAgICAgICAgIF9fdTY0IHNlc3Np
b25fdWFkZHI7ICAgICAgICAgLyogR3Vlc3Qgc2Vzc2lvbiBpbmZvcm1hdGlvbiAqLw0KPj4gKyAg
ICAgICAgICAgICAgICBfX3UzMiBzZXNzaW9uX2xlbjsNCj4+ICsgICAgICAgIH07DQo+IA0KPiBT
RVYgQVBJIGRvYyBoYXMgIkNFUlQiIGZvciBQREggbWVtYmVycyBidXQgIkNFUlRTIiBmb3IgdGhl
IG90aGVycy4NCj4gSnVkZ2luZyBieSB0aGUgZGVzY3JpcHRpb24sIHlvdSBzaG91bGQgZG8gdGhl
IHNhbWUgaGVyZSB0b28uIEp1c3Qgc28gdGhhdA0KPiB0aGVyZSdzIG5vIGRpc2NyZXBhbmN5IGZy
b20gdGhlIGRvY3MuDQo+IA0KDQpOb3RlZC4NCg0KPj4gKw0KPj4gICBSZWZlcmVuY2VzDQo+PiAg
ID09PT09PT09PT0NCj4+ICAgDQo+PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3N2bS5jIGIv
YXJjaC94ODYva3ZtL3N2bS5jDQo+PiBpbmRleCA0OGM4NjVhNGU1ZGQuLjBiMDkzN2Y1MzUyMCAx
MDA2NDQNCj4+IC0tLSBhL2FyY2gveDg2L2t2bS9zdm0uYw0KPj4gKysrIGIvYXJjaC94ODYva3Zt
L3N2bS5jDQo+PiBAQCAtNjk1Nyw2ICs2OTU3LDEwOCBAQCBzdGF0aWMgaW50IHNldl9sYXVuY2hf
c2VjcmV0KHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0IGt2bV9zZXZfY21kICphcmdwKQ0KPj4gICAJ
cmV0dXJuIHJldDsNCj4+ICAgfQ0KPj4gICANCj4+ICtzdGF0aWMgaW50IHNldl9zZW5kX3N0YXJ0
KHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0IGt2bV9zZXZfY21kICphcmdwKQ0KPj4gK3sNCj4+ICsJ
c3RydWN0IGt2bV9zZXZfaW5mbyAqc2V2ID0gJnRvX2t2bV9zdm0oa3ZtKS0+c2V2X2luZm87DQo+
PiArCXZvaWQgKmFtZF9jZXJ0ID0gTlVMTCwgKnNlc3Npb25fZGF0YSA9IE5VTEw7DQo+PiArCXZv
aWQgKnBkaF9jZXJ0ID0gTlVMTCwgKnBsYXRfY2VydCA9IE5VTEw7DQo+PiArCXN0cnVjdCBzZXZf
ZGF0YV9zZW5kX3N0YXJ0ICpkYXRhID0gTlVMTDsNCj4gDQo+IFdoeSBhcmUgeW91IGluaXRpYWxp
emluZyB0aG9zZSB0byBOVUxMPw0KPiANCg0KSXQgc2ltcGxpZmllcyB0aGUgZXJyb3IgaGFuZGxp
bmcgcGF0aCB3aGVyZSB3ZSBjYW4gZG8ga2ZyZWUoKSB3aXRob3V0DQprbm93aW5nIHdoZXRoZXIg
dGhlIGJ1ZmZlcnMgd2VyZSBhbGxvY2F0ZWQgb3Igbm90Lg0KDQoNCj4gQWxzbywgU0VWIEFQSSB0
ZXh0IG9uIFNFTkRfU1RBUlQgdGFsa3MgYWJvdXQgYSBidW5jaCBvZiByZXF1aXJlbWVudHMgaW4N
Cj4gc2VjdGlvbg0KPiANCj4gIjYuOC4xIEFjdGlvbnMiDQo+IA0KPiBsaWtlDQo+IA0KPiAiVGhl
IHBsYXRmb3JtIG11c3QgYmUgaW4gdGhlIFBTVEFURS5XT1JLSU5HIHN0YXRlLg0KPiBUaGUgZ3Vl
c3QgbXVzdCBiZSBpbiB0aGUgR1NUQVRFLlJVTk5JTkcgc3RhdGUuDQo+IEdDVFguUE9MSUNZLk5P
U0VORCBtdXN0IGJlIHplcm8uIE90aGVyd2lzZSwgYW4gZXJyb3IgaXMgcmV0dXJuZWQuDQo+IC4u
LiINCj4gDQo+IFdoZXJlIGFyZSB3ZSBjaGVja2luZy92ZXJpZnlpbmcgdGhvc2U/DQo+IA0KDQoN
ClRoZSBrZXJuZWwgZHJpdmVyIGRvZXMgbm90IGtlZXAgdHJhY2sgb2YgYWxsIHRob3NlIFNFViBW
TSBzdGF0ZXMuIFRoZQ0KdXNlcnNwYWNlIGFwcGxpY2F0aW9uIChlLmcgcWVtdSkgd2lsbCBlbnN1
cmUgdGhhdCBWTSBpcyBpbiBwcm9wZXINCnN0YXRlIGJlZm9yZSBjYWxsaW5nIHRob3NlIGNvbW1h
bmRzLiBJZiB1c2Vyc3BhY2UgZG9lcyBub3QgY2hlY2sgc3RhdGVzDQphbmQgbWFrZXMgYSBibGlu
ZCBjYWxscyB0aGVuIHdlIGxldCB0aGUgRlcgZXJyb3Igb3V0IGFuZCBwcm9wYWdhdGUNCnRoZSBj
b3JyZWN0IGVycm9yIG1lc3NhZ2UgdG8gdGhlIGNhbGxlciBzbyB0aGF0IGl0IGNhbiB0YWtlIHRo
ZSByZXF1aXJlZA0KYWN0aW9uLg0KDQoNCj4+ICsJc3RydWN0IGt2bV9zZXZfc2VuZF9zdGFydCBw
YXJhbXM7DQo+PiArCWludCByZXQ7DQo+PiArDQo+PiArCWlmICghc2V2X2d1ZXN0KGt2bSkpDQo+
PiArCQlyZXR1cm4gLUVOT1RUWTsNCj4+ICsNCj4+ICsJaWYgKGNvcHlfZnJvbV91c2VyKCZwYXJh
bXMsICh2b2lkIF9fdXNlciAqKSh1aW50cHRyX3QpYXJncC0+ZGF0YSwNCj4+ICsJCQkJc2l6ZW9m
KHN0cnVjdCBrdm1fc2V2X3NlbmRfc3RhcnQpKSkNCj4+ICsJCXJldHVybiAtRUZBVUxUOw0KPj4g
Kw0KPj4gKwlkYXRhID0ga3phbGxvYyhzaXplb2YoKmRhdGEpLCBHRlBfS0VSTkVMKTsNCj4+ICsJ
aWYgKCFkYXRhKQ0KPj4gKwkJcmV0dXJuIC1FTk9NRU07DQo+IA0KPiBNb3ZlIHRoYXQgYWxsb2Nh
dGlvbi4uLg0KPiANCj4+ICsNCj4+ICsJLyogdXNlcnNwYWNlIHdhbnRzIHRvIHF1ZXJ5IHRoZSBz
ZXNzaW9uIGxlbmd0aCAqLw0KPj4gKwlpZiAoIXBhcmFtcy5zZXNzaW9uX2xlbikNCj4+ICsJCWdv
dG8gY21kOw0KPj4gKw0KPj4gKwlpZiAoIXBhcmFtcy5wZGhfY2VydF91YWRkciB8fCAhcGFyYW1z
LnBkaF9jZXJ0X2xlbiB8fA0KPj4gKwkgICAgIXBhcmFtcy5zZXNzaW9uX3VhZGRyKQ0KPj4gKwkJ
cmV0dXJuIC1FSU5WQUw7DQo+PiArDQo+PiArCS8qIGNvcHkgdGhlIGNlcnRpZmljYXRlIGJsb2Jz
IGZyb20gdXNlcnNwYWNlICovDQo+PiArCXBkaF9jZXJ0ID0gcHNwX2NvcHlfdXNlcl9ibG9iKHBh
cmFtcy5wZGhfY2VydF91YWRkciwgcGFyYW1zLnBkaF9jZXJ0X2xlbik7DQo+PiArCWlmIChJU19F
UlIocGRoX2NlcnQpKSB7DQo+PiArCQlyZXQgPSBQVFJfRVJSKHBkaF9jZXJ0KTsNCj4+ICsJCWdv
dG8gZV9mcmVlOw0KPj4gKwl9DQo+IA0KPiAuLi4gaGVyZSBzbyB0aGF0IGl0IGRvZXNuJ3QgaGFw
cGVuIHVubmVjZXNzYXJpbHkgaWYgdGhlIGFib3ZlIGZhaWwuDQo+IA0KDQpOb3RlZC4NCg0KPj4g
Kw0KPj4gKwlkYXRhLT5wZGhfY2VydF9hZGRyZXNzID0gX19wc3BfcGEocGRoX2NlcnQpOw0KPj4g
KwlkYXRhLT5wZGhfY2VydF9sZW4gPSBwYXJhbXMucGRoX2NlcnRfbGVuOw0KPj4gKw0KPj4gKwlw
bGF0X2NlcnQgPSBwc3BfY29weV91c2VyX2Jsb2IocGFyYW1zLnBsYXRfY2VydF91YWRkciwgcGFy
YW1zLnBsYXRfY2VydF9sZW4pOw0KPj4gKwlpZiAoSVNfRVJSKHBsYXRfY2VydCkpIHsNCj4+ICsJ
CXJldCA9IFBUUl9FUlIocGxhdF9jZXJ0KTsNCj4+ICsJCWdvdG8gZV9mcmVlX3BkaDsNCj4+ICsJ
fQ0KPj4gKw0KPj4gKwlkYXRhLT5wbGF0X2NlcnRfYWRkcmVzcyA9IF9fcHNwX3BhKHBsYXRfY2Vy
dCk7DQo+PiArCWRhdGEtPnBsYXRfY2VydF9sZW4gPSBwYXJhbXMucGxhdF9jZXJ0X2xlbjsNCj4+
ICsNCj4+ICsJYW1kX2NlcnQgPSBwc3BfY29weV91c2VyX2Jsb2IocGFyYW1zLmFtZF9jZXJ0X3Vh
ZGRyLCBwYXJhbXMuYW1kX2NlcnRfbGVuKTsNCj4+ICsJaWYgKElTX0VSUihhbWRfY2VydCkpIHsN
Cj4+ICsJCXJldCA9IFBUUl9FUlIoYW1kX2NlcnQpOw0KPj4gKwkJZ290byBlX2ZyZWVfcGxhdF9j
ZXJ0Ow0KPj4gKwl9DQo+PiArDQo+PiArCWRhdGEtPmFtZF9jZXJ0X2FkZHJlc3MgPSBfX3BzcF9w
YShhbWRfY2VydCk7DQo+PiArCWRhdGEtPmFtZF9jZXJ0X2xlbiA9IHBhcmFtcy5hbWRfY2VydF9s
ZW47DQo+PiArDQo+PiArCXJldCA9IC1FSU5WQUw7DQo+PiArCWlmIChwYXJhbXMuc2Vzc2lvbl9s
ZW4gPiBTRVZfRldfQkxPQl9NQVhfU0laRSkNCj4+ICsJCWdvdG8gZV9mcmVlX2FtZF9jZXJ0Ow0K
PiANCj4gVGhhdCBjaGVjayBjb3VsZCBnbyB1cCB3aGVyZSB0aGUgb3RoZXIgcGFyYW1zLnNlc3Np
b25fbGVuIGNoZWNrIGlzDQo+IGhhcHBlbmluZyBhbmQgeW91IGNhbiBzYXZlIHlvdXJzZWxmIHRo
ZSBjZXJ0IGFsbG9jK2ZyZWVpbmcuDQo+IA0KDQpJIHdpbGwgdGFrZSBhIGxvb2suDQoNCj4+ICsN
Cj4+ICsJcmV0ID0gLUVOT01FTTsNCj4+ICsJc2Vzc2lvbl9kYXRhID0ga21hbGxvYyhwYXJhbXMu
c2Vzc2lvbl9sZW4sIEdGUF9LRVJORUwpOw0KPj4gKwlpZiAoIXNlc3Npb25fZGF0YSkNCj4+ICsJ
CWdvdG8gZV9mcmVlX2FtZF9jZXJ0Ow0KPiANCj4gRGl0dG8uDQo+IA0KPiAuLi4NCj4gDQo=
