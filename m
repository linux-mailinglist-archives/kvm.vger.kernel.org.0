Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABCCA09CB
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 20:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbfH1Skm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 14:40:42 -0400
Received: from mail-eopbgr770078.outbound.protection.outlook.com ([40.107.77.78]:52229
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726400AbfH1Skm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 14:40:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F5R6vkA2QEGDMw3uHlS2So25R7Oa/gA16HCEGH0QMyVYBfE0C4CdtXpwd0H/kVltXlmsPAQ+pIFiUfuixjSxoHfkdAah+I635B4FP9X72J+rNCmNJqvAbnQYSuO30d8TAHn+6fn+X6AVI8CqwupzdZO2fw2WU14lBFRatcZh6kYUjtdMx5Nfj4PgydErX510ShLYnEP4zxoz9pDUfzVQo3oFgRFUM0oeVEgrbZOkPudHUaqJXNh/gyLUb9xcApLYWYtNEhJ8eS90RXCLtCNHecj2sAjdvgbJOy8TwL0QIYIfkuZxNTFvHfvCVjLkXYTmuk4PWK9EVoJVPvngFhDXAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dx6sczcub6NUJaFA3elR0WCGZaa5gn5vpmXNR4Rsx70=;
 b=BH7KVaQtjC0fXVZfIBC5n/XSk0oHzf953wP7lFLm6flsQu40GCFYlW2T9WmHW6ku4/GTd6saMET5xIzYRREXsLYavjYoFEen374Z0IrjOzz4WER1DEVGvJkYVkBiK9l8hMRnUgQV8oexiKZeJyXsIOow3NRPz+TQQl7E1YPmC3LXI8hAuwEPaY7vNxE5HvDKcLYXNyyymkywhYL/27MDxbkSioNuo7A2hHC11jZrlf0hNZWFO2KddGgJGhEfO4AZCtiD1lGLe9IndTXqxTsnXbYDd08kv3y+lI4HnTbfzD/r3ULhXeYurVaJaDlGLCD2A6MfefaE53/Vuteny3MhVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dx6sczcub6NUJaFA3elR0WCGZaa5gn5vpmXNR4Rsx70=;
 b=yjYDk801RL8PQK4qTKY7AhRRTkbBcY3peznZR19cakVU59HqMmQmuUJiPfrOeTjrcqzlP3bJr4KnyQSMTFwI/1MYMwgQH1Ljj05hzSuyQ/8JaGJ6qqDEnykyFUWlwc1jyS7XO8AQpXDmSAtVwHCXCL0Cw8lpkHnIOkwtWnftQRw=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3385.namprd12.prod.outlook.com (20.178.198.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.20; Wed, 28 Aug 2019 18:39:56 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825%7]) with mapi id 15.20.2178.023; Wed, 28 Aug 2019
 18:39:56 +0000
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
Subject: Re: [PATCH v2 04/15] kvm: x86: Add per-VM APICv state debugfs
Thread-Topic: [PATCH v2 04/15] kvm: x86: Add per-VM APICv state debugfs
Thread-Index: AQHVU4YAxicok8C98kOOsiSZW3JVFacCQeaAgAtPyICAASf5gIACP0QA
Date:   Wed, 28 Aug 2019 18:39:56 +0000
Message-ID: <1bfccb79-5ace-0dba-a201-e069f77f740a@amd.com>
References: <1565886293-115836-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1565886293-115836-5-git-send-email-suravee.suthikulpanit@amd.com>
 <a48080a5-7ece-280d-2c1f-9d3f4c273a8d@amazon.com>
 <049c0f98-bd89-ee3c-7869-92972f2d7c31@amd.com>
 <f9c62280-efb4-197d-1444-fce8f3d15132@amazon.com>
In-Reply-To: <f9c62280-efb4-197d-1444-fce8f3d15132@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
x-originating-ip: [165.204.78.1]
x-clientproxiedby: SN6PR1501CA0029.namprd15.prod.outlook.com
 (2603:10b6:805::42) To DM6PR12MB2844.namprd12.prod.outlook.com
 (2603:10b6:5:45::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9bf9c641-2251-40c4-ffd3-08d72be71f79
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3385;
x-ms-traffictypediagnostic: DM6PR12MB3385:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB33850ADBF3C1AFA9E304A30DF3A30@DM6PR12MB3385.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 014304E855
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(396003)(366004)(136003)(346002)(199004)(189003)(478600001)(2201001)(86362001)(305945005)(14454004)(58126008)(7736002)(71200400001)(102836004)(186003)(6246003)(26005)(53936002)(31696002)(110136005)(54906003)(8936002)(81166006)(64756008)(66556008)(66476007)(66946007)(66446008)(36756003)(2501003)(6436002)(6116002)(6512007)(6486002)(2906002)(229853002)(99286004)(8676002)(52116002)(71190400001)(6506007)(3846002)(76176011)(386003)(53546011)(316002)(25786009)(446003)(81156014)(4326008)(486006)(11346002)(476003)(2616005)(31686004)(5660300002)(65806001)(256004)(66066001)(65956001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3385;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2yjGaROEkUrtZLsmOt6G9vB2LpdlDHmQ5H0zn4pmBzg4K++vOAbA8E2FiaJDrdyM1X9JvSEMenrivkXT1oXORP/XFjBEBYoPlRajaBnBeVWV0H7h9ETe5Bj7lzafjjcELZGKKznmj5o/4eURrFzGdZa5CQ1r+r1oN//aPY86F71yvpZWJS9KOzx6J0JT0jq2VXRcRKRPf6u7cPBpm8o0Q/hr1Jgt5YMFwmtSyskS60IAsZVXgeaxrBxVlcc8VMFfnWbXkvlUD2IPgVozXr2ltG2t2ZxdQIltaXBCz/nnx6HZ0O5E+2qjSpSH9LSoVIyzpsUc8EVsWH0/vVdCTfqf5nGrutHn7kyIAhIlFuz9RTkBYYfaX+E3Xs3l5toJzQShaucea6wyakitcz53ywhQhyaQ6mZIEUg8pEe1kjB+cBA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E281AE6AA5F41A4B83631194F32A1CD7@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bf9c641-2251-40c4-ffd3-08d72be71f79
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2019 18:39:56.3922
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +HPr3CrlVp32PyZcCDGh5V4tw/V29V8aXUKyq6nkcqVxYiPhbfZOOirsHyXmOtx99t69Sjrw4SBo3H9EzBMwcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3385
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QWxleCwNCg0KT24gOC8yNy8xOSAzOjIwIEFNLCBBbGV4YW5kZXIgR3JhZiB3cm90ZToNCj4gDQo+
IA0KPiBPbiAyNi4wOC4xOSAyMTo0MSwgU3V0aGlrdWxwYW5pdCwgU3VyYXZlZSB3cm90ZToNCj4+
IEFsZXgsDQo+Pg0KPj4gT24gOC8xOS8yMDE5IDQ6NTcgQU0sIEFsZXhhbmRlciBHcmFmIHdyb3Rl
Og0KPj4+DQo+Pj4NCj4+PiBPbiAxNS4wOC4xOSAxODoyNSwgU3V0aGlrdWxwYW5pdCwgU3VyYXZl
ZSB3cm90ZToNCj4+Pj4gQ3VycmVudGx5LCB0aGVyZSBpcyBubyB3YXkgdG8gdGVsbCB3aGV0aGVy
IEFQSUN2IGlzIGFjdGl2ZQ0KPj4+PiBvbiBhIHBhcnRpY3VsYXIgVk0uIFRoaXMgb2Z0ZW4gY2F1
c2UgY29uZnVzaW9uIHNpbmNlIEFQSUN2DQo+Pj4+IGNhbiBiZSBkZWFjdGl2YXRlZCBhdCBydW50
aW1lLg0KPj4+Pg0KPj4+PiBJbnRyb2R1Y2UgYSBkZWJ1Z2ZzIGVudHJ5IHRvIHJlcG9ydCBBUElD
diBzdGF0ZSBvZiBhIFZNLg0KPj4+PiBUaGlzIGNyZWF0ZXMgYSByZWFkLW9ubHkgZmlsZToNCj4+
Pj4NCj4+Pj4gwqDCoMKgwqAgL3N5cy9rZXJuZWwvZGVidWcva3ZtLzcwODYwLTE0L2FwaWN2LXN0
YXRlDQo+Pj4+DQo+Pj4+IFNpZ25lZC1vZmYtYnk6IFN1cmF2ZWUgU3V0aGlrdWxwYW5pdCA8c3Vy
YXZlZS5zdXRoaWt1bHBhbml0QGFtZC5jb20+DQo+Pj4NCj4+PiBTaG91bGRuJ3QgdGhpcyBmaXJz
dCBhbmQgZm9yZW1vc3QgYmUgYSBWTSBpb2N0bCBzbyB0aGF0IHVzZXIgc3BhY2UgDQo+Pj4gY2Fu
IGlucXVpcmUgaXRzIG93biBzdGF0ZT8NCj4+Pg0KPj4+DQo+Pj4gQWxleA0KPj4NCj4+IEkgaW50
cm9kdWNlIHRoaXMgbWFpbmx5IGZvciBkZWJ1Z2dpbmcgc2ltaWxhciB0byBob3cgS1ZNIGlzIGN1
cnJlbnRseSANCj4+IHByb3ZpZGVzDQo+PiBzb21lIHBlci1WQ1BVIGluZm9ybWF0aW9uOg0KPj4N
Cj4+IMKgwqDCoMKgwqAgL3N5cy9rZXJuZWwvZGVidWcva3ZtLzE1OTU3LTE0L3ZjcHUwLw0KPj4g
wqDCoMKgwqDCoMKgwqDCoMKgIGxhcGljX3RpbWVyX2FkdmFuY2VfbnMNCj4+IMKgwqDCoMKgwqDC
oMKgwqDCoCB0c2Mtb2Zmc2V0DQo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgdHNjLXNjYWxpbmctcmF0
aW8NCj4+IMKgwqDCoMKgwqDCoMKgwqDCoCB0c2Mtc2NhbGluZy1yYXRpby1mcmFjLWJpdHMNCj4+
DQo+PiBJJ20gbm90IHN1cmUgaWYgdGhpcyBuZWVkcyB0byBiZSBWTSBpb2N0bCBhdCB0aGlzIHBv
aW50LiBJZiB0aGlzIA0KPj4gaW5mb3JtYXRpb24gaXMNCj4+IHVzZWZ1bCBmb3IgdXNlci1zcGFj
ZSB0b29sIHRvIGlucXVpcmUgdmlhIGlvY3RsLCB3ZSBjYW4gYWxzbyBwcm92aWRlIGl0Lg0KPiAN
Cj4gSSdtIG1vc3RseSB0aGlua2luZyBvZiBzb21ldGhpbmcgbGlrZSAiaW5mbyBhcGljIiBpbiBR
RU1VIHdoaWNoIHRvIG1lIA0KPiBzZWVtcyBsaWtlIHRoZSBuYXR1cmFsIHBsYWNlIGZvciBBUElD
IGluZm9ybWF0aW9uIGV4cG9zdXJlIHRvIGEgdXNlci4NCg0KSSBjb3VsZCBub3QgZmluZCBRRU1V
ICJpbmZvIGFwaWMiLiBJIGFzc3VtZSB5b3UgbWVhbnQgImluZm8gbGFwaWMiLCANCndoaWNoIHBy
b3ZpZGVzIGluZm9ybWF0aW9uIHNwZWNpZmljIHRvIGVhY2ggbG9jYWwgQVBJQyAoaS5lLiBwZXIt
dmNwdSkuDQoNCj4gVGhlIHByb2JsZW0gd2l0aCBkZWJ1Z2ZzIGlzIHRoYXQgaXQncyBub3QgYWNj
ZXNzaWJsZSB0byB0aGUgdXNlciB0aGF0IA0KPiBjcmVhdGVkIHRoZSBWTSwgYnV0IG9ubHkgcm9v
dCwgcmlnaHQ/DQoNCkhtLCB5b3UgYXJlIHJpZ2h0LiBJJ2xsIGFsc28gbG9vayBpbnRvIGFsc28g
YWRkaW5nIGlvY3RsIGludGVyZmFjZSB0aGVuLg0KDQpUaGFua3MsDQpTdXJhdmVlDQo=
