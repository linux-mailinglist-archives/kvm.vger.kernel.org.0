Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD7256AC2F
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 17:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbfGPPs6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 11:48:58 -0400
Received: from mail-eopbgr800085.outbound.protection.outlook.com ([40.107.80.85]:26240
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728121AbfGPPs5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 11:48:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PEEp37/YHZ0UuuxXp9/dpUTDli6BkoOqe6gcqek83mxA5FH80Y7sBpA8CtvLgWyLcA9RQfXagcmedF6yskKAl/G7hEKwbTbMhRuJHkaQOYCaJvFGnlmGjbggDMCl6Wm2l5xxaYcFEtuqzQzkUzQ0AAN8BQPBau19hG41CqA/zCqiFI/rDPzjiopA0o665Rrd+3UXB0FKspWbREGnqI7PndrurOZLPVVpqcImpmjVByMrnOEPwpbUZFsPZ/rx4Qw0gqGCrwiuPD7KrajjnhYc5x16wifkZhlku4b8E1DeosohT/VB7BdFNXcYyi7qpEY9b9tV+Seen8bLEt1O+7qxDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e438eRP0tYMYTe0TuxK8mA+UquoONxvXDgUGggehjc0=;
 b=JyAXKfJO77Z4eXIRUAluLnI1m02BqXH1VodqnTcLu5QKNkieQRCpiaouZCbZ6L/P2o3DxKhefDisXGIjVyacrxur/pr+Y7h5wRrSK1C/AX6pJ7bLinncDRfjlpqSRxf/oJiYhdizYo9pfZJD+hy3lMNj7ivgDQ0UZRnMEepVxaoypbJnkRLZWWxHstQA0z4nO1I8+lDZ2SZx/yXFelSK6l0+YQ9N3N/Th/cAkEe25RI4GWDeOUF05wGDedF9ppUpPR478M96F6PncUvQHWg1yOxGcZCJ99BonPsuGilvMKXDPl7uhwpP3EAuTHMPgh9zB0ijvshnKsaS2uwRwKnpbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e438eRP0tYMYTe0TuxK8mA+UquoONxvXDgUGggehjc0=;
 b=rrKjfV9gnYftwVEf3/D/JlTY+/GYE4R9XdFmo214K0JIcFThWM/bBVsYUW+aQ8VmvC1A7OnjRVvpVF0BdIrtHuH48KwPrhyL0yIaNQajlehR7JzxS+GRIIFU3bTrkG/hKL/sc994Euvu+gZ7l0v3IazTDQqLvkwNxUMmB2pCu7E=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.118.13) by
 DM6PR12MB3657.namprd12.prod.outlook.com (10.255.76.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Tue, 16 Jul 2019 15:48:52 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::7439:ea87:cc5d:71]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::7439:ea87:cc5d:71%7]) with mapi id 15.20.2073.012; Tue, 16 Jul 2019
 15:48:52 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     Liran Alon <liran.alon@oracle.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 1/2] KVM: SVM: Fix workaround for AMD Errata 1096
Thread-Topic: [PATCH 1/2] KVM: SVM: Fix workaround for AMD Errata 1096
Thread-Index: AQHVO0w5JJR7Enn+ZEGfnHG07AdKnabMIb8AgAFDlAA=
Date:   Tue, 16 Jul 2019 15:48:52 +0000
Message-ID: <1ef0f594-2039-1aeb-4fe0-edbc21fa1f60@amd.com>
References: <20190715203043.100483-1-liran.alon@oracle.com>
 <20190715203043.100483-2-liran.alon@oracle.com>
In-Reply-To: <20190715203043.100483-2-liran.alon@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR06CA0010.namprd06.prod.outlook.com
 (2603:10b6:805:8e::23) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:42::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 548a6680-b48d-43f7-f1dc-08d70a0519e8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3657;
x-ms-traffictypediagnostic: DM6PR12MB3657:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DM6PR12MB3657C0AF081E51DE3F3738A7E5CE0@DM6PR12MB3657.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1775;
x-forefront-prvs: 0100732B76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(376002)(396003)(366004)(136003)(199004)(189003)(68736007)(446003)(386003)(6506007)(476003)(5660300002)(2616005)(31686004)(11346002)(81166006)(71200400001)(8936002)(71190400001)(316002)(486006)(6116002)(186003)(3846002)(6246003)(52116002)(110136005)(54906003)(26005)(81156014)(53546011)(2501003)(2201001)(7736002)(76176011)(102836004)(25786009)(6436002)(36756003)(66946007)(66476007)(64756008)(66446008)(66556008)(6486002)(53936002)(966005)(2906002)(6306002)(478600001)(6512007)(14454004)(229853002)(256004)(14444005)(86362001)(31696002)(66066001)(8676002)(305945005)(99286004)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3657;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9MwGpHZ/TrKc4raC9QJyq6kHGa0LIwiekhEzN0y8E+zoh6N8LLDhafH79ARsned7Hi2RowtwUdrBfe73mfc80yynXg+JpeMoJA5XKRTbwO813+TATdy5crWHdAlN/q2E6WWNxiD2bEJSPwghNRJ91Gegp1+rwrXJQw7FUGBJfpY03jVAZDEbXdl0JU+eIeZOZtciKaoGJp2bmbS7DDyvppMFAjyBDlaLD6jNu73223ZmGgQuHiC3LWTwFIAGov20CU2ZSpCvMHjP7X5qlW0GY+ow57js+a2Z/FsrHb0zxCiPFcDG/ConI4xI451kdaOQHP/urlDgEXP9ppyP83yKMbYifAZmNTCnqoVIQLEZQbEzH5leDYlQ3eJALJKS7OXJhqP2Wj3ng6qrpWOWe1zGeVg8Qs7RpPn6o3Q5ixxk/7g=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EC119D421B66A147B5CEE0C7DA299AFA@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 548a6680-b48d-43f7-f1dc-08d70a0519e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2019 15:48:52.3114
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sbrijesh@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3657
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCk9uIDcvMTUvMTkgMzozMCBQTSwgTGlyYW4gQWxvbiB3cm90ZToNCj4gQWNjb3JkaW5nIHRv
IEFNRCBFcnJhdGEgMTA5NjoNCj4gIk9uIGEgbmVzdGVkIGRhdGEgcGFnZSBmYXVsdCB3aGVuIENS
NC5TTUFQID0gMSBhbmQgdGhlIGd1ZXN0IGRhdGEgcmVhZCBnZW5lcmF0ZXMgYSBTTUFQIHZpb2xh
dGlvbiwgdGhlDQo+IEd1ZXN0SW5zdHJCeXRlcyBmaWVsZCBvZiB0aGUgVk1DQiBvbiBhIFZNRVhJ
VCB3aWxsIGluY29ycmVjdGx5IHJldHVybiAwaCBpbnN0ZWFkIHRoZSBjb3JyZWN0IGd1ZXN0IGlu
c3RydWN0aW9uDQo+IGJ5dGVzLiINCj4gDQo+IEFzIHN0YXRlZCBhYm92ZSwgZXJyYXRhIGlzIGVu
Y291bnRlcmVkIHdoZW4gZ3Vlc3QgcmVhZCBnZW5lcmF0ZXMgYSBTTUFQIHZpb2xhdGlvbi4gaS5l
LiB2Q1BVIHJ1bnMNCj4gd2l0aCBDUEw8MyBhbmQgQ1I0LlNNQVA9MS4gSG93ZXZlciwgY29kZSBo
YXZlIG1pc3Rha2VubHkgY2hlY2tlZCBpZiBDUEw9PTMgYW5kIENSNC5TTUFQPT0wLg0KPiANCg0K
VGhlIFNNQVAgdmlvbGF0aW9uIHdpbGwgb2NjdXIgZnJvbSBDUEwzIHNvIENQTD09MyBpcyBhIHZh
bGlkIGNoZWNrLg0KDQpTZWUgWzFdIGZvciBjb21wbGV0ZSBkaXNjdXNzaW9uDQoNCmh0dHBzOi8v
cGF0Y2h3b3JrLmtlcm5lbC5vcmcvcGF0Y2gvMTA4MDgwNzUvIzIyNDc5MjcxDQoNCkhvd2V2ZXIs
IGNvZGUgbWlzdGFrZW5seSBjaGVja2VkIENSNC5TTUFQPT0wLCBpdCBzaG91bGQgYmUgQ1I0LlNN
QVA9PTENCg0KPiBUbyBhdm9pZCBmdXR1cmUgY29uZnVzaW9uIGFuZCBpbXByb3ZlIGNvZGUgcmVh
ZGJpbGl0eSwgY29tbWVudCBlcnJhdGEgZGV0YWlscyBpbiBjb2RlIGFuZCBub3QNCj4ganVzdCBp
biBjb21taXQgbWVzc2FnZS4NCj4gDQo+IEZpeGVzOiAwNWQ1YTQ4NjM1MjUgKCJLVk06IFNWTTog
V29ya2Fyb3VuZCBlcnJhdGEjMTA5NiAoaW5zbl9sZW4gbWF5YmUgemVybyBvbiBTTUFQIHZpb2xh
dGlvbikiKQ0KPiBSZXZpZXdlZC1ieTogQm9yaXMgT3N0cm92c2t5IDxib3Jpcy5vc3Ryb3Zza3lA
b3JhY2xlLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogTGlyYW4gQWxvbiA8bGlyYW4uYWxvbkBvcmFj
bGUuY29tPg0KPiAtLS0NCj4gICBhcmNoL3g4Ni9rdm0vc3ZtLmMgfCAxNyArKysrKysrKysrKysr
LS0tLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAxMyBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygt
KQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9zdm0uYyBiL2FyY2gveDg2L2t2bS9z
dm0uYw0KPiBpbmRleCA3MzViOGMwMTg5NWUuLjc5MDIzYTQxZjdhNyAxMDA2NDQNCj4gLS0tIGEv
YXJjaC94ODYva3ZtL3N2bS5jDQo+ICsrKyBiL2FyY2gveDg2L2t2bS9zdm0uYw0KPiBAQCAtNzEy
MywxMCArNzEyMywxOSBAQCBzdGF0aWMgYm9vbCBzdm1fbmVlZF9lbXVsYXRpb25fb25fcGFnZV9m
YXVsdChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ICAgCWJvb2wgaXNfdXNlciwgc21hcDsNCj4g
ICANCj4gICAJaXNfdXNlciA9IHN2bV9nZXRfY3BsKHZjcHUpID09IDM7DQo+IC0Jc21hcCA9ICFr
dm1fcmVhZF9jcjRfYml0cyh2Y3B1LCBYODZfQ1I0X1NNQVApOw0KPiArCXNtYXAgPSBrdm1fcmVh
ZF9jcjRfYml0cyh2Y3B1LCBYODZfQ1I0X1NNQVApOw0KPiAgIA0KDQpBaCBnb29kIGNhdGNoLiB0
aGFuaw0KDQoNCj4gICAJLyoNCj4gLQkgKiBEZXRlY3QgYW5kIHdvcmthcm91bmQgRXJyYXRhIDEw
OTYgRmFtXzE3aF8wMF8wRmgNCj4gKwkgKiBEZXRlY3QgYW5kIHdvcmthcm91bmQgRXJyYXRhIDEw
OTYgRmFtXzE3aF8wMF8wRmguDQo+ICsJICoNCj4gKwkgKiBFcnJhdGE6DQo+ICsJICogT24gYSBu
ZXN0ZWQgcGFnZSBmYXVsdCB3aGVuIENSNC5TTUFQPTEgYW5kIHRoZSBndWVzdCBkYXRhIHJlYWQg
Z2VuZXJhdGVzDQo+ICsJICogYSBTTUFQIHZpb2xhdGlvbiwgR3Vlc3RJbnRyQnl0ZXMgZmllbGQg
b2YgdGhlIFZNQ0Igb24gYSBWTUVYSVQgd2lsbA0KPiArCSAqIGluY29ycmVjdGx5IHJldHVybiAw
IGluc3RlYWQgdGhlIGNvcnJlY3QgZ3Vlc3QgaW5zdHJ1Y3Rpb24gYnl0ZXMuDQo+ICsJICoNCj4g
KwkgKiBXb3JrYXJvdW5kOg0KPiArCSAqIFRvIGRldGVybWluZSB3aGF0IGluc3RydWN0aW9uIHRo
ZSBndWVzdCB3YXMgZXhlY3V0aW5nLCB0aGUgaHlwZXJ2aXNvcg0KPiArCSAqIHdpbGwgaGF2ZSB0
byBkZWNvZGUgdGhlIGluc3RydWN0aW9uIGF0IHRoZSBpbnN0cnVjdGlvbiBwb2ludGVyLg0KPiAg
IAkgKg0KPiAgIAkgKiBJbiBub24gU0VWIGd1ZXN0LCBoeXBlcnZpc29yIHdpbGwgYmUgYWJsZSB0
byByZWFkIHRoZSBndWVzdA0KPiAgIAkgKiBtZW1vcnkgdG8gZGVjb2RlIHRoZSBpbnN0cnVjdGlv
biBwb2ludGVyIHdoZW4gaW5zbl9sZW4gaXMgemVybw0KPiBAQCAtNzEzNywxMSArNzE0NiwxMSBA
QCBzdGF0aWMgYm9vbCBzdm1fbmVlZF9lbXVsYXRpb25fb25fcGFnZV9mYXVsdChzdHJ1Y3Qga3Zt
X3ZjcHUgKnZjcHUpDQo+ICAgCSAqIGluc3RydWN0aW9uIHBvaW50ZXIgc28gd2Ugd2lsbCBub3Qg
YWJsZSB0byB3b3JrYXJvdW5kIGl0LiBMZXRzDQo+ICAgCSAqIHByaW50IHRoZSBlcnJvciBhbmQg
cmVxdWVzdCB0byBraWxsIHRoZSBndWVzdC4NCj4gICAJICovDQo+IC0JaWYgKGlzX3VzZXIgJiYg
c21hcCkgew0KPiArCWlmICghaXNfdXNlciAmJiBzbWFwKSB7DQo+ICAgCQlpZiAoIXNldl9ndWVz
dCh2Y3B1LT5rdm0pKQ0KPiAgIAkJCXJldHVybiB0cnVlOw0KPiAgIA0KPiAtCQlwcl9lcnJfcmF0
ZWxpbWl0ZWQoIktWTTogR3Vlc3QgdHJpZ2dlcmVkIEFNRCBFcnJhdHVtIDEwOTZcbiIpOw0KPiAr
CQlwcl9lcnJfcmF0ZWxpbWl0ZWQoIktWTTogU0VWIEd1ZXN0IHRyaWdnZXJlZCBBTUQgRXJyYXR1
bSAxMDk2XG4iKTsNCj4gICAJCWt2bV9tYWtlX3JlcXVlc3QoS1ZNX1JFUV9UUklQTEVfRkFVTFQs
IHZjcHUpOw0KPiAgIAl9DQo+ICAgDQo+IA0K
