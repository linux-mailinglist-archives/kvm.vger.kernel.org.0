Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF71522181E
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 00:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgGOWv0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 18:51:26 -0400
Received: from mail-co1nam11on2049.outbound.protection.outlook.com ([40.107.220.49]:55479
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726660AbgGOWvZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 18:51:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YUA1xWkpPZ7GwuihM6VQVHtbND24C4o1nH72sC1fOrE4xo2gOJMTJ3xElCInFpkdKORSMUqnhP0QUJeD1vgm2IONPFuk/w27tBDYKdcuiGX3imMzZP7lHOOwcBm4kkBj0KFwl3iK9kuptw1BejjPN5MstonI1ECg0TbqPuV5Su+uVE8FAvH34qXy5wdVDjnPjBNnA0BPKnVSJANqg+IkSrE/Bldleigmk2tZOq7Y5IwkrD2L6vhVtV3EwC3aHLlIxLSBcaOfwx2ge0jD6fyEFQQyKVrAAVzKjXELi/yDjKz0WO7wNX2sjK3zQyAV0Pf3v/5MDhqtcg3vO/FQTEbZIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ioum+0uDxyvvdsZEK1dzecl18xXg8wlf0mnbobPsyHw=;
 b=QlCjGLDu83so0UTY+pUCTBNf1/3URBv1t5yWID88Hqk9cMacYC8W4YzTnmPI8XKZC6UVciHm0n7URFoQXhaaoPxAZlriaOgg1IPaGn/WI/vHTZ1Cx+ZGaCM8SqotVjuFCQDdI5DDiSMBr1MSA1ZYfbBJ03BPvfaqBVlG+DXaHa4fgpWDnY0yyAAgxYpvpuJbD6arm08x3xmReC9GpPc3wfjmRVY4BnH8rpyIJhx738KUwHQwPTJCmIFWliOCkuM8zxpjb9QPhqZmK2Bn6k9nLs4Zhri9LcoBtX1310bOlKW0ebBJZj4ixYpbK/8ghQWgOcDYjuwJxeK8jhkWOUTRsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ioum+0uDxyvvdsZEK1dzecl18xXg8wlf0mnbobPsyHw=;
 b=y/T+/AvcyiyIH+yn75S3ecMcsLePmFuzcafwvhVdgVIo4S8GhMltyQgp9Zvb79ZHpruPGLASNSALgDy+kjwWMrzVt1lQSxzyYxoC18E2dZ2CgrypsAVdgd52VtA60FpmEsXdzJBqedYnyNkm6DjI7jQLMInq3dlxZC+zKuvlV8w=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (2603:10b6:a03:4a::18)
 by SJ0PR05MB7422.namprd05.prod.outlook.com (2603:10b6:a03:280::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.9; Wed, 15 Jul
 2020 22:51:22 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::d563:57:2c78:7f]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::d563:57:2c78:7f%4]) with mapi id 15.20.3195.017; Wed, 15 Jul 2020
 22:51:22 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH] x86: svm: low CR3 bits are not MBZ
Thread-Topic: [kvm-unit-tests PATCH] x86: svm: low CR3 bits are not MBZ
Thread-Index: AQHWWM/s9eQwCvJDT0a4UjvbTfvUQ6kGIrqAgAABgoCAAAGtgIAAA5kAgAMRZoCAAAG4AIAAA10AgAADTYA=
Date:   Wed, 15 Jul 2020 22:51:22 +0000
Message-ID: <9DCDCFFD-1A5F-42B0-8DEB-441C9908A5AA@vmware.com>
References: <20200713043908.39605-1-namit@vmware.com>
 <ce87fd51-8e27-e5ff-3a90-06cddbf47636@oracle.com>
 <CCEF21D4-57C3-4843-9443-BE46501FFE8C@vmware.com>
 <abe9138a-6c61-22e1-f0a6-fcd5d06ef3f1@oracle.com>
 <6CD095D7-EF7F-49C2-98EF-F72D019817B2@vmware.com>
 <fe76d847-5106-bc09-e4cf-498fb51e5255@oracle.com>
 <9DC37B0B-597A-4B31-8397-B6E4764EEA37@vmware.com>
 <ab9f1669-a295-1022-a62a-8b64c90f6dcb@oracle.com>
In-Reply-To: <ab9f1669-a295-1022-a62a-8b64c90f6dcb@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [2601:647:4700:9b2:d804:e155:7b4c:bf3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8bb977f6-18dd-40b1-7d26-08d82911986e
x-ms-traffictypediagnostic: SJ0PR05MB7422:
x-microsoft-antispam-prvs: <SJ0PR05MB742277DAFBA97BCD241AB1C1D07E0@SJ0PR05MB7422.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YqRxgkwWgyA8llxYd5gGSYrEthJeM4nhsS6BHqv4MO+z3EcW/4WbH6lMHaBkU6cD5iyyq0ISxIMVD/tr4am8B9L9Q2VcnA3u6sIIV17UwRZ2Yfa4SNQlVBDORvH01yhfEcsB0atpNLL79BySy2rVCsTSdltDOG3eMcJiUn2zmEc+vMDBDkRrLyXfPZkSzJzlsJ28aUB+R3KgXCy87GH/DA3Bq9V7hS2Dhmbz6H5Or8V0RPlM4YvzzT1GDwQScnHCCXQvS9yA8UL8cYDxZ2KLGRY0pMCbjNRUYg5UJszJbd8CKSAHfjZVwhfp694sR4T6jZLXLLzyJRB/Fj6OFec+6A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4776.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39860400002)(366004)(376002)(136003)(396003)(316002)(76116006)(54906003)(5660300002)(6512007)(83380400001)(71200400001)(6486002)(86362001)(4326008)(6916009)(478600001)(6506007)(33656002)(36756003)(8936002)(2616005)(66476007)(66556008)(64756008)(186003)(2906002)(53546011)(66446008)(66946007)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: eH+kfMdmUMzrG07p+jhdjDwERpL7xQPzMiO6Dfvog6D0M9CBKpC2t/Fu38czG3iixTChQQOuneZRk7CQpLz0J+iuIiG056zJ+eYuIQYwV+UnZDIB2foMXGTyoYwxzxyD6YbqaMy9c41Ph7soN0+peRk9XIylTi3qSlWmZ+rjEp+Gm1Pdx+hhkVssSVzkv/rLOex6yHBwADZCpSrdPDehs8cUtowivHfZTT54gGdQi1dSGOezs4/4QjrOKMh6mHthyGM4jb2U4O8ZwPsZ6BGKJFrP8GvU5o5MUGeapHD1XDgXe272Ge2h20S9N+714c3cHS5QDnLNwuyqbqIF5v//ZHV6zd01jBYNFa4PBSPkm2sXxmt5G2hR3spRqeO6Kh+PqOr+QUD890cO9JSvbKyb1tckKm/BHaPOUKN9IXCoL2fbdOzdo/mX8o4NcJsv7HjThBkywtFYuAjwJ50MswZrWrTGTiKtDhLaiXTl3Mdac89YymQd1SaAg4TAB/BYgqqWNQWruPk0jZdHrplrKXsHfWobMuLoDgiSkGrM+J/FIVM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <693E2ED29A671D42BF39705F01F01256@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4776.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bb977f6-18dd-40b1-7d26-08d82911986e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2020 22:51:22.0456
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l6epTIi7EKQdeoRw3958D6FascwRT2EGDt79ixjfCfwDmrvIcQ8jb3xe/wYofINaNt994qeYJvDUmM0hrL1SFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR05MB7422
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiBKdWwgMTUsIDIwMjAsIGF0IDM6MzkgUE0sIEtyaXNoIFNhZGh1a2hhbiA8a3Jpc2guc2Fk
aHVraGFuQG9yYWNsZS5jb20+IHdyb3RlOg0KPiANCj4gDQo+IE9uIDcvMTUvMjAgMzoyNyBQTSwg
TmFkYXYgQW1pdCB3cm90ZToNCj4+PiBPbiBKdWwgMTUsIDIwMjAsIGF0IDM6MjEgUE0sIEtyaXNo
IFNhZGh1a2hhbiA8a3Jpc2guc2FkaHVraGFuQG9yYWNsZS5jb20+IHdyb3RlOg0KPj4+IA0KPj4+
IA0KPj4+IE9uIDcvMTMvMjAgNDozMCBQTSwgTmFkYXYgQW1pdCB3cm90ZToNCj4+Pj4+IE9uIEp1
bCAxMywgMjAyMCwgYXQgNDoxNyBQTSwgS3Jpc2ggU2FkaHVraGFuIDxrcmlzaC5zYWRodWtoYW5A
b3JhY2xlLmNvbT4gd3JvdGU6DQo+PiBbc25pcF0NCj4+IA0KPj4+Pj4gSSBhbSBqdXN0IHNheWlu
ZyB0aGF0IHRoZSBBUE0gbGFuZ3VhZ2UgInNob3VsZCBiZSBjbGVhcmVkIHRvIDAiIGlzIG1pc2xl
YWRpbmcgaWYgdGhlIHByb2Nlc3NvciBkb2Vzbid0IGVuZm9yY2UgaXQuDQo+Pj4+IEp1c3QgdG8g
ZW5zdXJlIEkgYW0gY2xlYXIgLSBJIGFtIG5vdCBibGFtaW5nIHlvdSBpbiBhbnkgd2F5LiBJIGFs
c28gZm91bmQNCj4+Pj4gdGhlIHBocmFzaW5nIGNvbmZ1c2luZy4NCj4+Pj4gDQo+Pj4+IEhhdmlu
ZyBzYWlkIHRoYXQsIGlmIHlvdSAob3IgYW55b25lIGVsc2UpIHJlaW50cm9kdWNlcyDigJxwb3Np
dGl2ZeKAnSB0ZXN0cywgaW4NCj4+Pj4gd2hpY2ggdGhlIFZNIENSMyBpcyBtb2RpZmllZCB0byBl
bnN1cmUgVk0tZW50cnkgc3VjY2VlZHMgd2hlbiB0aGUgcmVzZXJ2ZWQNCj4+Pj4gbm9uLU1CWiBi
aXRzIGFyZSBzZXQsIHBsZWFzZSBlbnN1cmUgdGhlIHRlc3RzIGZhaWxzIGdyYWNlZnVsbHkuIFRo
ZQ0KPj4+PiBub24tbG9uZy1tb2RlIENSMyB0ZXN0cyBjcmFzaGVkIHNpbmNlIHRoZSBWTSBwYWdl
LXRhYmxlcyB3ZXJlIGluY29tcGF0aWJsZQ0KPj4+PiB3aXRoIHRoZSBwYWdpbmcgbW9kZS4NCj4+
Pj4gDQo+Pj4+IEluIG90aGVyIHdvcmRzLCBpbnN0ZWFkIG9mIHNldHRpbmcgYSBWTU1DQUxMIGlu
c3RydWN0aW9uIGluIHRoZSBWTSB0byB0cmFwDQo+Pj4+IGltbWVkaWF0ZWx5IGFmdGVyIGVudHJ5
LCBjb25zaWRlciBjbGVhcmluZyB0aGUgcHJlc2VudC1iaXRzIGluIHRoZSBoaWdoDQo+Pj4+IGxl
dmVscyBvZiB0aGUgTlBUOyBvciBpbmplY3Rpbmcgc29tZSBleGNlcHRpb24gdGhhdCB3b3VsZCB0
cmlnZ2VyIGV4aXQNCj4+Pj4gZHVyaW5nIHZlY3RvcmluZyBvciBzb21ldGhpbmcgbGlrZSB0aGF0
Lg0KPj4+PiANCj4+Pj4gUC5TLjogSWYgaXQgd2FzbuKAmXQgY2xlYXIsIEkgYW0gbm90IGdvaW5n
IHRvIGZpeCBLVk0gaXRzZWxmIGZvciBzb21lIG9idmlvdXMNCj4+Pj4gcmVhc29ucy4NCj4+PiBJ
IHRoaW5rIHNpbmNlIHRoZSBBUE0gaXMgbm90IGNsZWFyLCByZS1hZGRpbmcgYW55IHRlc3QgdGhh
dCB0ZXN0cyB0aG9zZSBiaXRzLCBpcyBsaWtlIGFkZGluZyBhIHRlc3Qgd2l0aCAidW5kZWZpbmVk
IGJlaGF2aW9yIiB0byBtZS4NCj4+PiANCj4+PiANCj4+PiBQYW9sbywgU2hvdWxkIEkgc2VuZCBh
IEtWTSBwYXRjaCB0byByZW1vdmUgY2hlY2tzIGZvciB0aG9zZSBub24tTUJaIHJlc2VydmVkIGJp
dHMgPw0KPj4gV2hpY2ggbm9uLU1CWiByZXNlcnZlZCBiaXRzIChvdGhlciB0aGFuIHRob3NlIHRo
YXQgSSBhZGRyZXNzZWQpIGRvIHlvdSByZWZlcg0KPj4gdG8/DQo+IEkgYW0gcmVmZXJyaW5nIHRv
LA0KPiANCj4gICAgICJbUEFUQ0ggMi8zIHY0XSBLVk06IG5TVk06IENoZWNrIHRoYXQgTUJaIGJp
dHMgaW4gQ1IzIGFuZCBDUjQgYXJlIG5vdCBzZXQgb24gdm1ydW4gb2YgbmVzdGVkIGd1ZXN0cyIN
Cj4gDQo+IGluIHdoaWNoIEkgYWRkZWQgdGhlIGZvbGxvd2luZzoNCj4gDQo+IA0KPiArI2RlZmlu
ZSBNU1JfQ1IzX0xFR0FDWV9SRVNFUlZFRF9NQVNLICAgICAgICAweGZlN1UNCj4gKyNkZWZpbmUg
TVNSX0NSM19MRUdBQ1lfUEFFX1JFU0VSVkVEX01BU0sgICAgMHg3VQ0KPiArI2RlZmluZSBNU1Jf
Q1IzX0xPTkdfUkVTRVJWRURfTUFTSyAgICAgICAgMHhmZmYwMDAwMDAwMDAwZmU3VQ0KDQpPaCwg
eW91IHJlZmVyIHRvIEtWTSwgbm90IGt2bS11bml0LXRlc3RzLi4uDQoNClRoYXTigJlzIG91dCBv
ZiBteSBzY29wZSA7LSkNCg0K
