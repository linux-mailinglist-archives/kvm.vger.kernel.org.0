Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91CE2A0601
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 17:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfH1PSI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 11:18:08 -0400
Received: from mail-eopbgr780074.outbound.protection.outlook.com ([40.107.78.74]:47712
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726315AbfH1PSI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 11:18:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F1eEBsy+PeoRa3vCNtrQvp4G8Lv/Pp1eEmgZKA0b5n7E1Mq+9//l0xVuiAPqzb9LCrOMWXlyd8CrKGCu84gvuYHLxjyDGg+tslRdI/wAOaiTwP4tDOHHguDNJ1rO3UN6zgTYx5kXOpq7W1fEBJ1JGNFxtBtIdV8qtHxjKUMnLMHIbLmSk03kKUUDHy5RVkQrI2w3uoYYWhEYMtBNTRXmHmqpzfePYbFdCEdM8zXOkuqYdNHdzpBLW6H7MBA7jmNfB7hC1AkZtzn6kz4eHdbdmZiPG7c8Kcyxw9wo9DxxR3VySgKd1DThMlRHPwH6ZQg31SfQEDcG32LQI+BhWhD7Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=//rxmpTsWWYshMxybokud8vpQtPj+197kxX8uSI15g4=;
 b=VU7X2cA0DsTtgjCpIjZdf8MgWLsCJC+/SD4CibTaONM7NZteNuSmSKgVY179eEoijqi83A6KndYA+kF4T5xPw3juD0qOiOtvEmc2FuUeCEWAUBOGoWSnc2ZhL9zQHxaJymIEuN8mJhpHpH7DMw4b08C/2C0KRf2sy+DBb7hLFSsxI3uV2xMppYGNmnskTgS9m/vP5pqcylXj9lVisQfPP20/5BYeidOHYnZa1IfCBl4pWH/n6ksS1aYkBhJY1SHPxFE9kD5DOpW30gpBGxGUFLg4i5Z9vRGO82DIkJjXaq3y2yWOCPMOalr9RJzizJyZX+b8p2FzDL2kp04ISDo48w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=//rxmpTsWWYshMxybokud8vpQtPj+197kxX8uSI15g4=;
 b=XcWo/+4gltwKS5RWLwNEV5Vh/4jWblNjOOWzOtOQLLTf59gJxyzTwNxYcjKmpEdamS3ryr5ITktJfLlTnAlF6F1+yp7woWhT06tr5c85EHCJdYeTXvc3j7IDpOry4qq8a43U78DD+fvXBcbZvD0Sj+dtWZIKKdnnV1xhaO3xdNk=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3051.namprd12.prod.outlook.com (20.178.30.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 28 Aug 2019 15:18:00 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825%7]) with mapi id 15.20.2178.023; Wed, 28 Aug 2019
 15:18:00 +0000
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
Subject: Re: [PATCH v2 11/15] svm: Temporary deactivate AVIC during ExtINT
 handling
Thread-Topic: [PATCH v2 11/15] svm: Temporary deactivate AVIC during ExtINT
 handling
Thread-Index: AQHVU4YFgD8+7+7+rEC5OVevDFYqvqcCTLuAgA5zwgA=
Date:   Wed, 28 Aug 2019 15:17:59 +0000
Message-ID: <5aaef6f4-4bee-4cc4-8eb0-d9b4c412988b@amd.com>
References: <1565886293-115836-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1565886293-115836-12-git-send-email-suravee.suthikulpanit@amd.com>
 <1ed5bf9c-177e-b41c-b5ac-4c76155ead2a@amazon.com>
In-Reply-To: <1ed5bf9c-177e-b41c-b5ac-4c76155ead2a@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
x-originating-ip: [165.204.78.1]
x-clientproxiedby: SN4PR0401CA0041.namprd04.prod.outlook.com
 (2603:10b6:803:2a::27) To DM6PR12MB2844.namprd12.prod.outlook.com
 (2603:10b6:5:45::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4966523b-b6a5-485b-9680-08d72bcae90c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3051;
x-ms-traffictypediagnostic: DM6PR12MB3051:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB30512E599201CE2A91D15BB9F3A30@DM6PR12MB3051.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 014304E855
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(396003)(366004)(39860400002)(189003)(199004)(2201001)(229853002)(6486002)(2616005)(65806001)(446003)(11346002)(8936002)(58126008)(76176011)(54906003)(110136005)(6246003)(6436002)(14454004)(31686004)(316002)(31696002)(102836004)(81166006)(99286004)(186003)(71190400001)(25786009)(53546011)(6506007)(386003)(52116002)(81156014)(8676002)(66066001)(2906002)(65956001)(2501003)(476003)(66446008)(64756008)(66556008)(5660300002)(486006)(53936002)(36756003)(66476007)(478600001)(66946007)(26005)(305945005)(256004)(71200400001)(86362001)(6116002)(3846002)(6512007)(14444005)(7736002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3051;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dK61yeNVqSITg6bXzMUj8RMR+CA0KvCxvHuXWq/Igifx6Cvb7VAI7w0MG74R7Be9Y/fpX9ylGKazX1v+LQRvNxnH9/P5b7MTE0UhQ0bSa7PKaIs4+yxRiebvqxuiXD9C28e1P2KYCHeSJjdDqs7V6Goo+DJ7zCAqgAlGfPEbTb5RQ5F9MutsoV8UEi+opskqWxi74+x4gncx8zXaQA9haWokJWQSx9cMmNcEptyeypk5Say/grmjzlpnSnTsIG/eAwZvsdoKkymsljQLd4un4svtLjvv6IG+Qp/tC3Bp08P6wgnRrN6MdR3ga6+pgtAVnWLS7r2y7gqUdg/Xrg1Xws+UHBd1od09B+9BMx9jkM1d6+4HveSIuS/Pu9Aowcs6BFivhTKiHGa3PGQCTU9MDSQZbeQHQ0+NdmI0lxQ2auw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B74C86FC3694CF4FAC41CD3FF05C0593@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4966523b-b6a5-485b-9680-08d72bcae90c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2019 15:18:00.1452
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8bC11CVU3DokIngXt3b7LdTl9cs/hpvSb9D0q1ZGYrTgWnpQYayJ5BqU28Aa87J+Ez0Og1pEtGSsmgJG+012+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3051
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QWxleCwNCg0KT24gOC8xOS8xOSA1OjM1IEFNLCBBbGV4YW5kZXIgR3JhZiB3cm90ZToNCj4gDQo+
IA0KPiBPbiAxNS4wOC4xOSAxODoyNSwgU3V0aGlrdWxwYW5pdCwgU3VyYXZlZSB3cm90ZToNCj4+
IEFNRCBBVklDIGRvZXMgbm90IHN1cHBvcnQgRXh0SU5ULiBUaGVyZWZvcmUsIEFWSUMgbXVzdCBi
ZSB0ZW1wb3JhcnkNCj4+IGRlYWN0aXZhdGVkIGFuZCBmYWxsIGJhY2sgdG8gdXNpbmcgbGVnYWN5
IGludGVycnVwdCBpbmplY3Rpb24gdmlhIHZJTlRSDQo+PiBhbmQgaW50ZXJydXB0IHdpbmRvdy4N
Cj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBTdXJhdmVlIFN1dGhpa3VscGFuaXQgPHN1cmF2ZWUuc3V0
aGlrdWxwYW5pdEBhbWQuY29tPg0KPj4gLS0tDQo+PiDCoCBhcmNoL3g4Ni9rdm0vc3ZtLmMgfCA0
OSANCj4+ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0N
Cj4+IMKgIDEgZmlsZSBjaGFuZ2VkLCA0NSBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0K
Pj4NCj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vc3ZtLmMgYi9hcmNoL3g4Ni9rdm0vc3Zt
LmMNCj4+IGluZGV4IGNmYTRiMTMuLjQ2OTAzNTEgMTAwNjQ0DQo+PiAtLS0gYS9hcmNoL3g4Ni9r
dm0vc3ZtLmMNCj4+ICsrKyBiL2FyY2gveDg2L2t2bS9zdm0uYw0KPj4gQEAgLTM4NCw2ICszODQs
NyBAQCBzdHJ1Y3QgYW1kX3N2bV9pb21tdV9pciB7DQo+PiDCoCBzdGF0aWMgdm9pZCBzdm1fc2V0
X2NyMChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHVuc2lnbmVkIGxvbmcgY3IwKTsNCj4+IMKgIHN0
YXRpYyB2b2lkIHN2bV9mbHVzaF90bGIoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBib29sIGludmFs
aWRhdGVfZ3BhKTsNCj4+IMKgIHN0YXRpYyB2b2lkIHN2bV9jb21wbGV0ZV9pbnRlcnJ1cHRzKHN0
cnVjdCB2Y3B1X3N2bSAqc3ZtKTsNCj4+ICtzdGF0aWMgdm9pZCBzdm1fcmVxdWVzdF9hY3RpdmF0
ZV9hdmljKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7DQo+PiDCoCBzdGF0aWMgYm9vbCBzdm1fZ2V0
X2VuYWJsZV9hcGljdihzdHJ1Y3Qga3ZtICprdm0pOw0KPj4gwqAgc3RhdGljIGlubGluZSB2b2lk
IGF2aWNfcG9zdF9zdGF0ZV9yZXN0b3JlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7DQo+PiBAQCAt
NDQ5NCw2ICs0NDk1LDE1IEBAIHN0YXRpYyBpbnQgaW50ZXJydXB0X3dpbmRvd19pbnRlcmNlcHRp
b24oc3RydWN0IA0KPj4gdmNwdV9zdm0gKnN2bSkNCj4+IMKgIHsNCj4+IMKgwqDCoMKgwqAga3Zt
X21ha2VfcmVxdWVzdChLVk1fUkVRX0VWRU5ULCAmc3ZtLT52Y3B1KTsNCj4+IMKgwqDCoMKgwqAg
c3ZtX2NsZWFyX3ZpbnRyKHN2bSk7DQo+PiArDQo+PiArwqDCoMKgIC8qDQo+PiArwqDCoMKgwqAg
KiBGb3IgQVZJQywgdGhlIG9ubHkgcmVhc29uIHRvIGVuZCB1cCBoZXJlIGlzIEV4dElOVHMuDQo+
PiArwqDCoMKgwqAgKiBJbiB0aGlzIGNhc2UgQVZJQyB3YXMgdGVtcG9yYXJpbHkgZGlzYWJsZWQg
Zm9yDQo+PiArwqDCoMKgwqAgKiByZXF1ZXN0aW5nIHRoZSBJUlEgd2luZG93IGFuZCB3ZSBoYXZl
IHRvIHJlLWVuYWJsZSBpdC4NCj4+ICvCoMKgwqDCoCAqLw0KPj4gK8KgwqDCoCBpZiAoc3ZtX2dl
dF9lbmFibGVfYXBpY3Yoc3ZtLT52Y3B1Lmt2bSkpDQo+PiArwqDCoMKgwqDCoMKgwqAgc3ZtX3Jl
cXVlc3RfYWN0aXZhdGVfYXZpYygmc3ZtLT52Y3B1KTsNCj4gDQo+IFdvdWxkIGl0IG1ha2Ugc2Vu
c2UgdG8gYWRkIGEgdHJhY2UgcG9pbnQgaGVyZSBhbmQgdG8gdGhlIG90aGVyIGNhbGwgDQo+IHNp
dGVzLCBzbyB0aGF0IGl0IGJlY29tZXMgb2J2aW91cyBpbiBhIHRyYWNlIHdoZW4gYW5kIHdoeSBl
eGFjdGx5IGF2aWMgDQo+IHdhcyBhY3RpdmUvaW5hY3RpdmU/DQo+IA0KPiBUaGUgdHJhY2UgcG9p
bnQgY291bGQgYWRkIGFkZGl0aW9uYWwgaW5mb3JtYXRpb24gb24gdGhlIHdoeS4NCg0KU3VyZSwg
c291bmRzIGdvb2QuDQoNCj4+IC4uLi4NCj4+IEBAIC01NTIyLDkgKzU1NTgsNiBAQCBzdGF0aWMg
dm9pZCBlbmFibGVfaXJxX3dpbmRvdyhzdHJ1Y3Qga3ZtX3ZjcHUgDQo+PiAqdmNwdSkNCj4+IMKg
IHsNCj4+IMKgwqDCoMKgwqAgc3RydWN0IHZjcHVfc3ZtICpzdm0gPSB0b19zdm0odmNwdSk7DQo+
PiAtwqDCoMKgIGlmIChrdm1fdmNwdV9hcGljdl9hY3RpdmUodmNwdSkpDQo+PiAtwqDCoMKgwqDC
oMKgwqAgcmV0dXJuOw0KPj4gLQ0KPj4gwqDCoMKgwqDCoCAvKg0KPj4gwqDCoMKgwqDCoMKgICog
SW4gY2FzZSBHSUY9MCB3ZSBjYW4ndCByZWx5IG9uIHRoZSBDUFUgdG8gdGVsbCB1cyB3aGVuIEdJ
RiANCj4+IGJlY29tZXMNCj4+IMKgwqDCoMKgwqDCoCAqIDEsIGJlY2F1c2UgdGhhdCdzIGEgc2Vw
YXJhdGUgU1RHSS9WTVJVTiBpbnRlcmNlcHQuwqAgVGhlIG5leHQgDQo+PiB0aW1lIHdlDQo+PiBA
QCAtNTUzNCw2ICs1NTY3LDE0IEBAIHN0YXRpYyB2b2lkIGVuYWJsZV9pcnFfd2luZG93KHN0cnVj
dCBrdm1fdmNwdSANCj4+ICp2Y3B1KQ0KPj4gwqDCoMKgwqDCoMKgICogd2luZG93IHVuZGVyIHRo
ZSBhc3N1bXB0aW9uIHRoYXQgdGhlIGhhcmR3YXJlIHdpbGwgc2V0IHRoZSBHSUYuDQo+PiDCoMKg
wqDCoMKgwqAgKi8NCj4+IMKgwqDCoMKgwqAgaWYgKCh2Z2lmX2VuYWJsZWQoc3ZtKSB8fCBnaWZf
c2V0KHN2bSkpICYmIG5lc3RlZF9zdm1faW50cihzdm0pKSB7DQo+PiArwqDCoMKgwqDCoMKgwqAg
LyoNCj4+ICvCoMKgwqDCoMKgwqDCoMKgICogSVJRIHdpbmRvdyBpcyBub3QgbmVlZGVkIHdoZW4g
QVZJQyBpcyBlbmFibGVkLA0KPj4gK8KgwqDCoMKgwqDCoMKgwqAgKiB1bmxlc3Mgd2UgaGF2ZSBw
ZW5kaW5nIEV4dElOVCBzaW5jZSBpdCBjYW5ub3QgYmUgaW5qZWN0ZWQNCj4+ICvCoMKgwqDCoMKg
wqDCoMKgICogdmlhIEFWSUMuIEluIHN1Y2ggY2FzZSwgd2UgbmVlZCB0byB0ZW1wb3JhcmlseSBk
aXNhYmxlIEFWSUMsDQo+PiArwqDCoMKgwqDCoMKgwqDCoCAqIGFuZCBmYWxsYmFjayB0byBpbmpl
Y3RpbmcgSVJRIHZpYSBWX0lSUS4NCj4+ICvCoMKgwqDCoMKgwqDCoMKgICovDQo+PiArwqDCoMKg
wqDCoMKgwqAgaWYgKGt2bV92Y3B1X2FwaWN2X2FjdGl2ZSh2Y3B1KSkNCj4+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHN2bV9yZXF1ZXN0X2RlYWN0aXZhdGVfYXZpYygmc3ZtLT52Y3B1KTsNCj4g
DQo+IERpZCB5b3UgdGVzdCBBVklDIHdpdGggbmVzdGluZz8gRGlkIHlvdSBhY3R1YWxseSBydW4g
YWNyb3NzIHRoaXMgaXNzdWUgDQo+IHRoZXJlPw0KDQpDdXJyZW50bHksIHdlIGhhdmUgbm90IGNs
YWltZWQgdGhhdCBBVklDIGlzIHN1cHBvcnRlZCB3LyBuZXN0ZWQgVk0uIA0KVGhhdCdzIHdoeSB3
ZSBoYXZlIG5vdCBlbmFibGVkIEFWSUMgYnkgZGVmYXVsdCB5ZXQuIFdlIHdpbGwgYmUgbG9va2lu
ZyANCm1vcmUgaW50byB0aGF0IG5leHQuDQoNClN1cmF2ZWUNCg==
