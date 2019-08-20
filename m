Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 863B795A13
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 10:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729327AbfHTIo1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Aug 2019 04:44:27 -0400
Received: from mail-eopbgr40128.outbound.protection.outlook.com ([40.107.4.128]:45255
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728545AbfHTIo1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Aug 2019 04:44:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=bitdefender.onmicrosoft.com; s=selector1-bitdefender-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nhgN+rjcQa5MO/IoHd4eCTIThqXq60SxS3NabMHoj2o=;
 b=BdOmKrN6ffq5XMtc6eP8IEhxmYm5tzXHtWnTBVlV+kVgulHsfp94N4ggtwrkrtu5vJMYVObaAdgUViz2an7zAkD3RNTNJQclkCaTW02x4W2INP829efIyKieK8uB9Q5PbVOfidd1a2wwFd7d4nkBgw/WGmAZF+SshWOqB8xFks0=
Received: from HE1PR0201MB2060.eurprd02.prod.outlook.com (10.168.30.152) by
 HE1PR0201MB2043.eurprd02.prod.outlook.com (10.167.187.149) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.11; Tue, 20 Aug 2019 08:44:22 +0000
Received: from HE1PR0201MB2060.eurprd02.prod.outlook.com
 ([fe80::11ea:ba34:6441:c332]) by HE1PR0201MB2060.eurprd02.prod.outlook.com
 ([fe80::11ea:ba34:6441:c332%8]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 08:44:22 +0000
From:   Nicusor CITU <ncitu@bitdefender.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
CC:     =?utf-8?B?QWRhbGJlcnQgTGF6xINy?= <alazar@bitdefender.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?utf-8?B?U2FtdWVsIExhdXLDqW4=?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        "Zhang@vger.kernel.org" <Zhang@vger.kernel.org>,
        Yu C <yu.c.zhang@intel.com>,
        =?utf-8?B?TWloYWkgRG9uyJt1?= <mdontu@bitdefender.com>
Subject: Re: [RFC PATCH v6 55/92] kvm: introspection: add KVMI_CONTROL_MSR and
 KVMI_EVENT_MSR
Thread-Topic: [RFC PATCH v6 55/92] kvm: introspection: add KVMI_CONTROL_MSR
 and KVMI_EVENT_MSR
Thread-Index: AQHVTs3TkKC1NudCY0uglRHlOs1VpKb4BZqAgAPEYICABxKDAIAA7M6A
Date:   Tue, 20 Aug 2019 08:44:21 +0000
Message-ID: <6854bfcc2bff3ffdaadad8708bd186a071ad682c.camel@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
         <20190809160047.8319-56-alazar@bitdefender.com>
         <20190812210501.GD1437@linux.intel.com>
         <f9e94e9649f072911cc20129c2b633747d5c1df5.camel@bitdefender.com>
         <20190819183643.GB1916@linux.intel.com>
In-Reply-To: <20190819183643.GB1916@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0089.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8::29) To HE1PR0201MB2060.eurprd02.prod.outlook.com
 (2603:10a6:3:20::24)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ncitu@bitdefender.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
x-originating-ip: [91.199.104.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4d8428be-f367-4406-6265-08d7254a98aa
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:HE1PR0201MB2043;
x-ms-traffictypediagnostic: HE1PR0201MB2043:|HE1PR0201MB2043:
x-microsoft-antispam-prvs: <HE1PR0201MB20435DE714A989DBDF83E33DB0AB0@HE1PR0201MB2043.eurprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(376002)(396003)(346002)(39860400002)(189003)(199004)(6512007)(14454004)(6486002)(446003)(66446008)(36756003)(229853002)(186003)(4326008)(76176011)(66476007)(316002)(86362001)(11346002)(50226002)(305945005)(64756008)(2616005)(3846002)(6116002)(6246003)(52116002)(81166006)(6436002)(66556008)(256004)(2906002)(66946007)(102836004)(66066001)(7416002)(26005)(71200400001)(508600001)(7736002)(6916009)(4744005)(81156014)(71190400001)(8676002)(486006)(107886003)(54906003)(5660300002)(25786009)(99286004)(476003)(386003)(8936002)(53936002)(118296001)(6506007)(99106002);DIR:OUT;SFP:1102;SCL:1;SRVR:HE1PR0201MB2043;H:HE1PR0201MB2060.eurprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: bitdefender.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: j4CP5WwcNtaYfY68GULVLPDYwy1mv/cD8SqrPvRAfUy7uEXZg/QQfYLlfGfUeUbdWzBh8u++J++SEUO1dwC629JxQ4E3pnEbpxgEAqxsY9xWXSlz/QM4QliF/zjm47lRywD8Kakq4pz/QaODRaHmPhtqH43VTN9zpiNI5BoQT6oTr1hOG+ARZOObjTyw0ugzrR0ik5xO21DhYcJxVHRgZ4gF9Vmcy4slvAWlm042HaaffPX+IpR/BSsghv7h4OMRFgN0ef/Yfg9CRLq9C6zkeEhjMwykA8wpbwL9d8i35XbX3woYTh8J5nZZnEpr2fZdUShbNOkVaYtIU7vSYa1Kv8xg97/BtJIGzEyW2lpu0Q7zCx+Y/nlffYzsPSK691kxHi0DgbIKmyzzI7UTx9/2QMhJfXxNrZmm3Y+0vW0DKgg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <216151A4C95C78438386E0E552F17071@eurprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bitdefender.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d8428be-f367-4406-6265-08d7254a98aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 08:44:22.0153
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 487baf29-f1da-469a-9221-243f830c36f3
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0201MB2043
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+ID4gPiArc3RhdGljIHZvaWQgdm14X21zcl9pbnRlcmNlcHQoc3RydWN0IGt2bV92Y3B1ICp2
Y3B1LCB1bnNpZ25lZA0KPiA+ID4gPiBpbnQNCj4gPiA+ID4gbXNyLA0KPiA+ID4gPiArCQkJICAg
ICAgYm9vbCBlbmFibGUpDQo+ID4gPiA+ICt7DQo+ID4gPiA+ICsJc3RydWN0IHZjcHVfdm14ICp2
bXggPSB0b192bXgodmNwdSk7DQo+ID4gPiA+ICsJdW5zaWduZWQgbG9uZyAqbXNyX2JpdG1hcCA9
IHZteC0+dm1jczAxLm1zcl9iaXRtYXA7DQo+IA0KPiBJcyBLVk1JIGludGVuZGVkIHRvIHBsYXkg
bmljZSB3aXRoIG5lc3RlZA0KPiB2aXJ0dWFsaXphdGlvbj8gIFVuY29uZGl0aW9uYWxseQ0KPiB1
cGRhdGluZyB2bWNzMDEubXNyX2JpdG1hcCBpcyBjb3JyZWN0IHJlZ2FyZGxlc3Mgb2Ygd2hldGhl
ciB0aGUgdkNQVQ0KPiBpcyBpbg0KPiBMMSBvciBMMiwgYnV0IGlmIHRoZSB2Q1BVIGlzIGN1cnJl
bnRseSBpbiBMMiB0aGVuIHRoZSBlZmZlY3RpdmUNCj4gYml0bWFwLA0KPiBpLmUuIHZtY3MwMi5t
c3JfYml0bWFwLCB3b24ndCBiZSB1cGRhdGVkIHVudGlsIHRoZSBuZXh0IG5lc3RlZCBWTS0NCj4g
RW50ZXIuDQoNCk91ciBpbml0aWFsIHByb29mIG9mIGNvbmNlcHQgd2FzIHJ1bm5pbmcgd2l0aCBz
dWNjZXNzIGluIG5lc3RlZA0KdmlydHVhbGl6YXRpb24uIEJ1dCBtb3N0IG9mIG91ciB0ZXN0cyB3
ZXJlIGRvbmUgb24gYmFyZS1tZXRhbC4NCldlIGRvIGhvd2V2ZXIgaW50ZW5kIHRvIG1ha2UgaXQg
ZnVsbHkgZnVuY3Rpb25pbmcgb24gbmVzdGVkIHN5c3RlbXMNCnRvby4NCg0KRXZlbiB0aG91Z2h0
LCBmcm9tIEtWTUkgcG9pbnQgb2YgdmlldywgdGhlIE1TUiBpbnRlcmNlcHRpb24NCmNvbmZpZ3Vy
YXRpb24gd291bGQgYmUganVzdCBmaW5lIGlmIGl0IGdldHMgdXBkYXRlZCBiZWZvcmUgdGhlIHZj
cHUgaXMNCmFjdHVhbGx5IGVudGVyaW5nIHRvIG5lc3RlZCBWTS4NCg0K
