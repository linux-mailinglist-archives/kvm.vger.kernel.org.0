Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06CB21E39C
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 01:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgGMXa0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 19:30:26 -0400
Received: from mail-eopbgr680080.outbound.protection.outlook.com ([40.107.68.80]:57943
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726352AbgGMXaZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 19:30:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gAdHk013hzHs9pLjwKMQpBloz4czDCLK733HRCIr0ZyZrMeyoa7W2Cw4sMFS7L8XtElH8LjlvdjwYbX3RzGp3nQaHKrNn/BqAfzFqVxylI6mvH6sVIpH35WJgAepo6kV4ZOGuTWWKsxs7LsYrXdvojtiiJuhGULfhF5LBrFw5aHZVEKAOOF2OWDLdjuwEWz+Yfeq4cN07sR0MZCaFY+HrjoX+1LCKE6MuVRra80oBlS2d91Eif3/uurkIO85oHnyUy09YQ3f040b/UOorvWPcsgphrpOMlWBMNTyPObYq4TGe9QpgvlAAPUVRuANpMoFDZ9mC/zobGeOEO86MdUPCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gfpuvL26DTvRifAwdI3TQ/eXNPBEer/EmoZ1Z3/B07Q=;
 b=Nc2mNEaKlE56RAwAbn8uqDxMf98U4lkFc6zJurSjq8Y0fDkl02Wt7B1tEnf1O1Mp8XuGBflPGJMiGNkrH9Xz7BAkjh4wcfhdDgnyU8P0wyMq2IOx/cdzswF44jskXxrJFZFqc0gxLNRp+x9q2l17+xopRBIL0tCAuNLeZqgnCD+e7KSxa4AeRd4FDqx9i5RoiXI3xAJpWaFU4mab44ACCzHdX8Qmv5zSaStpaidmKht1yBq7SBohlLQ63UcHck+Tae/++LZVOeL83dOVlg0wHbyLquQ1fRhhC8caYhBs28PRT+0WEeDza7QKRGuMoQx0hBOWyE4gKNvGGWw037F4pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gfpuvL26DTvRifAwdI3TQ/eXNPBEer/EmoZ1Z3/B07Q=;
 b=Q6rS1bcj3Up9Ce3bny43RPr2lyNG3ymcxsK393PgxKHqDaShnE0cC0+wOgMbFtcATb1GS0LZn+pYRKAAuItJgK0HkU4UNP8/yQR54YGMjFJvc+sJGs4nX5+rJa2ULIBATRISWdvXqloEHrL5U/XGgDXUTFRQPZTwVpWQI6yBLl4=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (2603:10b6:a03:4a::18)
 by BYAPR05MB5720.namprd05.prod.outlook.com (2603:10b6:a03:76::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.13; Mon, 13 Jul
 2020 23:30:19 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::d563:57:2c78:7f]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::d563:57:2c78:7f%4]) with mapi id 15.20.3195.009; Mon, 13 Jul 2020
 23:30:19 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH] x86: svm: low CR3 bits are not MBZ
Thread-Topic: [kvm-unit-tests PATCH] x86: svm: low CR3 bits are not MBZ
Thread-Index: AQHWWM/s9eQwCvJDT0a4UjvbTfvUQ6kGIrqAgAABgoCAAAGtgIAAA5kA
Date:   Mon, 13 Jul 2020 23:30:19 +0000
Message-ID: <6CD095D7-EF7F-49C2-98EF-F72D019817B2@vmware.com>
References: <20200713043908.39605-1-namit@vmware.com>
 <ce87fd51-8e27-e5ff-3a90-06cddbf47636@oracle.com>
 <CCEF21D4-57C3-4843-9443-BE46501FFE8C@vmware.com>
 <abe9138a-6c61-22e1-f0a6-fcd5d06ef3f1@oracle.com>
In-Reply-To: <abe9138a-6c61-22e1-f0a6-fcd5d06ef3f1@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [2601:647:4700:9b2:c93b:d519:464b:6d2e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 11b3817b-60ea-4fe1-52d1-08d82784b4ca
x-ms-traffictypediagnostic: BYAPR05MB5720:
x-microsoft-antispam-prvs: <BYAPR05MB5720573851C6DD5EC144AD6FD0600@BYAPR05MB5720.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BBNnf2xbI2VfPDjRUSqyf3cPzzFPE2CDZv4e7nxVkgAnmIKb4SLb9BRwSwsD3mqMwoUe3RsVHj9QFO0+KM18pBz6m0mur/ssplfv/5bsOGuWQArhBd8/qSWqOPcIArz4Qj0ZrdcbetWgT//bYMXjEGykOq4Mt+rgFhH5tFjhF/ZhfvhiyTSrlqeoTzHm8ph0tEI0476b75C46wV36mFxiAqBoX4ZhaidaoNqF3VH+sXkbbdDk0KR0kQK5tgRAcWnYZtaZMC7wG4UtIH0ur0VMRwVc+vJhmXes29uu8gGqKe90kisq/DpS6UA8197yqYHRZ4PWji4wwHF83tqY507lg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4776.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(346002)(376002)(396003)(86362001)(71200400001)(6512007)(36756003)(4326008)(83380400001)(2906002)(8676002)(6486002)(2616005)(6506007)(53546011)(8936002)(478600001)(33656002)(19627235002)(316002)(66946007)(186003)(64756008)(66476007)(66446008)(54906003)(66556008)(76116006)(6916009)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 1q2fxTnR+Y0XmnQ8zTAjV/JdLU687LITwfT2/9qFdgjd9SFeBviz2kYlRjt8zaR3/K+k2oMnGqBVePG7v0Tu4GoYpQIB49/xC+HHgPmdM7rFIfWQM6YGhCizYXjIoiYe9P0eKzmdH9uNR9iFg6ris7Rh7QSsXujLJD/Tsk48FdIlgOPin75BYebVDd8H7M4NNXrGz3jrRmd3CWMOgmN7yxOmPjVlpr8fYK5W6WY2D1uplCZEGntG79q7WklGe8BnCa4bbS3BcWKsg0v4dxSf31wNZaw6FLY4LgAxMhyZytoI3bNKU/4Kn8iB7tjsvd/Rk3+3gZ5prrpX3/62oAV8btLejNbH33s2lteoRKh5/WTr/fm7x5Yrd5X5I9hgA0XvlDYEjuB6qvAyVb9MoQG/QCouIT+xakEE1F9Hqgt8dY4CNNSO0u6mti5oMCUvT4czppkfdTn1OjKC2+L7fRSQAhg+9dcVvT5Aib/aBTYvD5S3/FYAteogkLNW0vWYI6DH8YZ2Z1NfS1FLcLoX/wC/e4iOaxuIDsX5se9OaxnmFSc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <10A584E4659EB34D91FAE57033BB5C02@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4776.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11b3817b-60ea-4fe1-52d1-08d82784b4ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2020 23:30:19.4120
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: laTw2x3+EfUulDPXC7nEe3GAuGBdtLnDhoqwz8MPwTsLdHn8EQgRMf6ye1QCjn7SOl0pbXXHXlOFXC0GSzelig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5720
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiBKdWwgMTMsIDIwMjAsIGF0IDQ6MTcgUE0sIEtyaXNoIFNhZGh1a2hhbiA8a3Jpc2guc2Fk
aHVraGFuQG9yYWNsZS5jb20+IHdyb3RlOg0KPiANCj4gDQo+IE9uIDcvMTMvMjAgNDoxMSBQTSwg
TmFkYXYgQW1pdCB3cm90ZToNCj4+PiBPbiBKdWwgMTMsIDIwMjAsIGF0IDQ6MDYgUE0sIEtyaXNo
IFNhZGh1a2hhbiA8a3Jpc2guc2FkaHVraGFuQG9yYWNsZS5jb20+IHdyb3RlOg0KPj4+IA0KPj4+
IA0KPj4+IE9uIDcvMTIvMjAgOTozOSBQTSwgTmFkYXYgQW1pdCB3cm90ZToNCj4+Pj4gVGhlIGxv
dyBDUjMgYml0cyBhcmUgcmVzZXJ2ZWQgYnV0IG5vdCBNQlogYWNjb3JkaW5nIHRvIHRoYSBBUE0u
IFRoZQ0KPj4+PiB0ZXN0cyBzaG91bGQgdGhlcmVmb3JlIG5vdCBjaGVjayB0aGF0IHRoZXkgY2F1
c2UgZmFpbGVkIFZNLWVudHJ5LiBUZXN0cw0KPj4+PiBvbiBiYXJlLW1ldGFsIHNob3cgdGhleSBk
byBub3QuDQo+Pj4+IA0KPj4+PiBTaWduZWQtb2ZmLWJ5OiBOYWRhdiBBbWl0IDxuYW1pdEB2bXdh
cmUuY29tPg0KPj4+PiAtLS0NCj4+Pj4gIHg4Ni9zdm0uaCAgICAgICB8ICA0ICstLS0NCj4+Pj4g
IHg4Ni9zdm1fdGVzdHMuYyB8IDI2ICstLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+Pj4+ICAy
IGZpbGVzIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMjggZGVsZXRpb25zKC0pDQo+Pj4+IA0K
Pj4+PiBkaWZmIC0tZ2l0IGEveDg2L3N2bS5oIGIveDg2L3N2bS5oDQo+Pj4+IGluZGV4IGY4ZTc0
MjkuLjE1ZTBmMTggMTAwNjQ0DQo+Pj4+IC0tLSBhL3g4Ni9zdm0uaA0KPj4+PiArKysgYi94ODYv
c3ZtLmgNCj4+Pj4gQEAgLTMyNSw5ICszMjUsNyBAQCBzdHJ1Y3QgX19hdHRyaWJ1dGVfXyAoKF9f
cGFja2VkX18pKSB2bWNiIHsNCj4+Pj4gICNkZWZpbmUgU1ZNX0NSMF9TRUxFQ1RJVkVfTUFTSyAo
WDg2X0NSMF9UUyB8IFg4Nl9DUjBfTVApDQo+Pj4+ICAgICNkZWZpbmUJU1ZNX0NSMF9SRVNFUlZF
RF9NQVNLCQkJMHhmZmZmZmZmZjAwMDAwMDAwVQ0KPj4+PiAtI2RlZmluZQlTVk1fQ1IzX0xFR0FD
WV9SRVNFUlZFRF9NQVNLCQkweGZlN1UNCj4+Pj4gLSNkZWZpbmUJU1ZNX0NSM19MRUdBQ1lfUEFF
X1JFU0VSVkVEX01BU0sJMHg3VQ0KPj4+PiAtI2RlZmluZQlTVk1fQ1IzX0xPTkdfUkVTRVJWRURf
TUFTSwkJMHhmZmYwMDAwMDAwMDAwZmU3VQ0KPj4+PiArI2RlZmluZQlTVk1fQ1IzX0xPTkdfUkVT
RVJWRURfTUFTSwkJMHhmZmYwMDAwMDAwMDAwMDAwVQ0KPj4+PiAgI2RlZmluZQlTVk1fQ1I0X0xF
R0FDWV9SRVNFUlZFRF9NQVNLCQkweGZmODhmMDAwVQ0KPj4+PiAgI2RlZmluZQlTVk1fQ1I0X1JF
U0VSVkVEX01BU0sJCQkweGZmZmZmZmZmZmY4OGYwMDBVDQo+Pj4+ICAjZGVmaW5lCVNWTV9EUjZf
UkVTRVJWRURfTUFTSwkJCTB4ZmZmZmZmZmZmZmZmMWZmMFUNCj4+Pj4gZGlmZiAtLWdpdCBhL3g4
Ni9zdm1fdGVzdHMuYyBiL3g4Ni9zdm1fdGVzdHMuYw0KPj4+PiBpbmRleCAzYjBkMDE5Li4xOTA4
YzdjIDEwMDY0NA0KPj4+PiAtLS0gYS94ODYvc3ZtX3Rlc3RzLmMNCj4+Pj4gKysrIGIveDg2L3N2
bV90ZXN0cy5jDQo+Pj4+IEBAIC0yMDA3LDM4ICsyMDA3LDE0IEBAIHN0YXRpYyB2b2lkIHRlc3Rf
Y3IzKHZvaWQpDQo+Pj4+ICB7DQo+Pj4+ICAJLyoNCj4+Pj4gIAkgKiBDUjMgTUJaIGJpdHMgYmFz
ZWQgb24gZGlmZmVyZW50IG1vZGVzOg0KPj4+PiAtCSAqICAgWzI6MF0JCSAgICAtIGxlZ2FjeSBQ
QUUNCj4+Pj4gLQkgKiAgIFsyOjBdLCBbMTE6NV0JICAgIC0gbGVnYWN5IG5vbi1QQUUNCj4+Pj4g
LQkgKiAgIFsyOjBdLCBbMTE6NV0sIFs2Mzo1Ml0gLSBsb25nIG1vZGUNCj4+Pj4gKwkgKiAgIFs2
Mzo1Ml0gLSBsb25nIG1vZGUNCj4+Pj4gIAkgKi8NCj4+Pj4gIAl1NjQgY3IzX3NhdmVkID0gdm1j
Yi0+c2F2ZS5jcjM7DQo+Pj4+IC0JdTY0IGNyNF9zYXZlZCA9IHZtY2ItPnNhdmUuY3I0Ow0KPj4+
PiAtCXU2NCBjcjQgPSBjcjRfc2F2ZWQ7DQo+Pj4+IC0JdTY0IGVmZXJfc2F2ZWQgPSB2bWNiLT5z
YXZlLmVmZXI7DQo+Pj4+IC0JdTY0IGVmZXIgPSBlZmVyX3NhdmVkOw0KPj4+PiAgLQllZmVyICY9
IH5FRkVSX0xNRTsNCj4+Pj4gLQl2bWNiLT5zYXZlLmVmZXIgPSBlZmVyOw0KPj4+PiAtCWNyNCB8
PSBYODZfQ1I0X1BBRTsNCj4+Pj4gLQl2bWNiLT5zYXZlLmNyNCA9IGNyNDsNCj4+Pj4gLQlTVk1f
VEVTVF9DUl9SRVNFUlZFRF9CSVRTKDAsIDIsIDEsIDMsIGNyM19zYXZlZCwNCj4+Pj4gLQkgICAg
U1ZNX0NSM19MRUdBQ1lfUEFFX1JFU0VSVkVEX01BU0spOw0KPj4+PiAtDQo+Pj4+IC0JY3I0ID0g
Y3I0X3NhdmVkICYgflg4Nl9DUjRfUEFFOw0KPj4+PiAtCXZtY2ItPnNhdmUuY3I0ID0gY3I0Ow0K
Pj4+PiAtCVNWTV9URVNUX0NSX1JFU0VSVkVEX0JJVFMoMCwgMTEsIDEsIDMsIGNyM19zYXZlZCwN
Cj4+Pj4gLQkgICAgU1ZNX0NSM19MRUdBQ1lfUkVTRVJWRURfTUFTSyk7DQo+Pj4+IC0NCj4+Pj4g
LQljcjQgfD0gWDg2X0NSNF9QQUU7DQo+Pj4+IC0Jdm1jYi0+c2F2ZS5jcjQgPSBjcjQ7DQo+Pj4+
IC0JZWZlciB8PSBFRkVSX0xNRTsNCj4+Pj4gLQl2bWNiLT5zYXZlLmVmZXIgPSBlZmVyOw0KPj4+
PiAgCVNWTV9URVNUX0NSX1JFU0VSVkVEX0JJVFMoMCwgNjMsIDEsIDMsIGNyM19zYXZlZCwNCj4+
Pj4gIAkgICAgU1ZNX0NSM19MT05HX1JFU0VSVkVEX01BU0spOw0KPj4+PiAgLQl2bWNiLT5zYXZl
LmNyNCA9IGNyNF9zYXZlZDsNCj4+Pj4gIAl2bWNiLT5zYXZlLmNyMyA9IGNyM19zYXZlZDsNCj4+
Pj4gLQl2bWNiLT5zYXZlLmVmZXIgPSBlZmVyX3NhdmVkOw0KPj4+PiAgfQ0KPj4+PiAgICBzdGF0
aWMgdm9pZCB0ZXN0X2NyNCh2b2lkKQ0KPj4+IEFQTSBzYXlzLA0KPj4+IA0KPj4+ICAgICAiUmVz
ZXJ2ZWQgQml0cy4gUmVzZXJ2ZWQgZmllbGRzIHNob3VsZCBiZSBjbGVhcmVkIHRvIDAgYnkgc29m
dHdhcmUgd2hlbiB3cml0aW5nIENSMy4iDQo+Pj4gDQo+Pj4gSWYgcHJvY2Vzc29yIGFsbG93cyB0
aGVzZSBiaXRzIHRvIGJlIGxlZnQgbm9uLXplcm8sICJzaG91bGQgYmUgY2xlYXJlZCB0byAwIiBt
ZWFucyBpdCdzIG5vdCBtYW5kYXRvcnkgdGhlbi4gSSBhbSB3b25kZXJpbmcgd2hhdCB0aGlzICJz
aG91bGQgYmUiIGFjdHVhbGx5IG1lYW5zIDotKSAhDQo+PiBJIHJlYWxseSB0ZXN0ZWQgaXQsIHNv
IEkgZ3Vlc3Mgd2Ug4oCcc2hvdWxk4oCdIG5vdCBhcmd1ZSBhYm91dCBpdC4gOy0pDQo+IE5vLCBJ
IGFtIG5vdCBhcmd1aW5nIG92ZXIgeW91ciB0ZXN0IHJlc3VsdHMuIDotKQ0KPj4gQW55aG93LCBh
Y2NvcmRpbmcgdG8gQVBNIEZpZ3VyZSA1LTE2ICjigJxDb250cm9sIFJlZ2lzdGVyIDMgKENSMykt
TG9uZyBNb2Rl4oCdKSwNCj4+IGJpdHMgNTI6NjMgYXJlIOKAnHJlc2VydmVkLCBNQlrigJ0gYW5k
IG90aGVycyBhcmUganVzdCBtYXJrZWQgYXMg4oCcUmVzZXJ2ZWTigJ0uIFNvDQo+PiBpdCBzZWVt
cyB0aGV5IGFyZSBub3QgdGhlIHNhbWUuDQo+IEkgYW0ganVzdCBzYXlpbmcgdGhhdCB0aGUgQVBN
IGxhbmd1YWdlICJzaG91bGQgYmUgY2xlYXJlZCB0byAwIiBpcyBtaXNsZWFkaW5nIGlmIHRoZSBw
cm9jZXNzb3IgZG9lc24ndCBlbmZvcmNlIGl0Lg0KDQpKdXN0IHRvIGVuc3VyZSBJIGFtIGNsZWFy
IC0gSSBhbSBub3QgYmxhbWluZyB5b3UgaW4gYW55IHdheS4gSSBhbHNvIGZvdW5kDQp0aGUgcGhy
YXNpbmcgY29uZnVzaW5nLg0KDQpIYXZpbmcgc2FpZCB0aGF0LCBpZiB5b3UgKG9yIGFueW9uZSBl
bHNlKSByZWludHJvZHVjZXMg4oCccG9zaXRpdmXigJ0gdGVzdHMsIGluDQp3aGljaCB0aGUgVk0g
Q1IzIGlzIG1vZGlmaWVkIHRvIGVuc3VyZSBWTS1lbnRyeSBzdWNjZWVkcyB3aGVuIHRoZSByZXNl
cnZlZA0Kbm9uLU1CWiBiaXRzIGFyZSBzZXQsIHBsZWFzZSBlbnN1cmUgdGhlIHRlc3RzIGZhaWxz
IGdyYWNlZnVsbHkuIFRoZQ0Kbm9uLWxvbmctbW9kZSBDUjMgdGVzdHMgY3Jhc2hlZCBzaW5jZSB0
aGUgVk0gcGFnZS10YWJsZXMgd2VyZSBpbmNvbXBhdGlibGUNCndpdGggdGhlIHBhZ2luZyBtb2Rl
Lg0KDQpJbiBvdGhlciB3b3JkcywgaW5zdGVhZCBvZiBzZXR0aW5nIGEgVk1NQ0FMTCBpbnN0cnVj
dGlvbiBpbiB0aGUgVk0gdG8gdHJhcA0KaW1tZWRpYXRlbHkgYWZ0ZXIgZW50cnksIGNvbnNpZGVy
IGNsZWFyaW5nIHRoZSBwcmVzZW50LWJpdHMgaW4gdGhlIGhpZ2gNCmxldmVscyBvZiB0aGUgTlBU
OyBvciBpbmplY3Rpbmcgc29tZSBleGNlcHRpb24gdGhhdCB3b3VsZCB0cmlnZ2VyIGV4aXQNCmR1
cmluZyB2ZWN0b3Jpbmcgb3Igc29tZXRoaW5nIGxpa2UgdGhhdC4NCg0KUC5TLjogSWYgaXQgd2Fz
buKAmXQgY2xlYXIsIEkgYW0gbm90IGdvaW5nIHRvIGZpeCBLVk0gaXRzZWxmIGZvciBzb21lIG9i
dmlvdXMNCnJlYXNvbnMuDQoNCg==
