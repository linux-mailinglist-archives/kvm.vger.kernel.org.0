Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFED9D7BC
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 22:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbfHZUqX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 16:46:23 -0400
Received: from mail-eopbgr780050.outbound.protection.outlook.com ([40.107.78.50]:49664
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726220AbfHZUqX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 16:46:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n+qlZkuYkk3PMvdNMNvzPNGXd/6wxaLG8Zc4jvud+gg3eI9VIVZHA7bBUmrUIaPzegLuNWSnAw6IGfKRqdKsj9UWCp/0B2FRRocKQGKvj2peepIYYX+RCrwZd8JjYay4p09BpQM+0iDc7kX/azmyCnoXoWgOPO3kLQmjppAdwX1KpoEcyECYr5zkk8i/NpaeCDn3ze9t75GbX44A7DmN2uamf4k5tcP2sCeRXrIdG6STYEW8ichB9bng4le/mca+Wm0oklS6h0Z2iQuyDt3r52IrLcWRDTKk9dZf/fxAa44uc+bOL6bUuqjAxtMMWgwmn+NbssGmutbPzWWhH1XxKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d57o0BTpG44I5HhPKKU2fEZQUt9etBkRrbVi3O2mOC8=;
 b=DMVZ+hTcIBcpvkDtpIcnn6tZpDXCv48QSQXwEWfpGOqqcTJjtoG79I8x/KUP6Tu7XuQ/F9rJGzRM8L+XHnOgeKmi3Ip3GCWtULdIJm/m7hMMkctDHsfNdDcGK0HqJBaUzo0W5wwCcz0T/dRySp400VqDG4v1Nf9tfMpcEfRc9yW4EemOUMxPiJ2t9DnYe5etad9RtK2XbxKGy0VH4AXGffw7ssEOOST7Eo2TTPJ0HMiBouLyf1S0RliK44IW4ULswyk3J/SvSlKF7i86Tdx9qvJczUN1qqRiPT3W4vNmpnWaLAzsMybHhuWcbvEfYqRcLPGna3+Ck6gtwyEG9/hpog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d57o0BTpG44I5HhPKKU2fEZQUt9etBkRrbVi3O2mOC8=;
 b=pyvlb0J86PSKtm5ell9nty9X4s2JvKbJklaF09qAI7QoQRuFUIbAdGgKLD18zS+BSXYIVf0yM5DYT8+GFTmm6MOvZQuYZuV6K3Ei39erRQNkXSPTTrXwDdJE2fu0bvQAOFiHaYZev66mm+3hAdGT1J6tORRzwH1aJE3HmTsq1q4=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3260.namprd12.prod.outlook.com (20.179.105.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.19; Mon, 26 Aug 2019 20:46:20 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825%7]) with mapi id 15.20.2178.023; Mon, 26 Aug 2019
 20:46:20 +0000
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
Subject: Re: [PATCH v2 12/15] kvm: i8254: Check LAPIC EOI pending when
 injecting irq on SVM AVIC
Thread-Topic: [PATCH v2 12/15] kvm: i8254: Check LAPIC EOI pending when
 injecting irq on SVM AVIC
Thread-Index: AQHVU4YGnOwcrgTvnU6R6KE2IzCt16cCTo6AgAupA4A=
Date:   Mon, 26 Aug 2019 20:46:20 +0000
Message-ID: <8320fecb-de61-1a01-b90d-a45f224de287@amd.com>
References: <1565886293-115836-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1565886293-115836-13-git-send-email-suravee.suthikulpanit@amd.com>
 <ac9fa8d4-2c25-52a5-3938-3ce373b3c3e0@amazon.com>
In-Reply-To: <ac9fa8d4-2c25-52a5-3938-3ce373b3c3e0@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-originating-ip: [165.204.77.1]
x-clientproxiedby: SN4PR0501CA0079.namprd05.prod.outlook.com
 (2603:10b6:803:22::17) To DM6PR12MB2844.namprd12.prod.outlook.com
 (2603:10b6:5:45::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fd955b80-c579-42b6-1283-08d72a6672e4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3260;
x-ms-traffictypediagnostic: DM6PR12MB3260:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3260C1B961D792A43379B47BF3A10@DM6PR12MB3260.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-forefront-prvs: 01415BB535
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(346002)(366004)(376002)(189003)(199004)(3846002)(229853002)(99286004)(102836004)(25786009)(478600001)(76176011)(256004)(14444005)(66946007)(66476007)(66556008)(64756008)(66446008)(6506007)(65806001)(65956001)(66066001)(86362001)(31696002)(486006)(316002)(2616005)(8676002)(11346002)(71190400001)(71200400001)(2906002)(446003)(53546011)(386003)(476003)(2201001)(4326008)(26005)(81166006)(8936002)(81156014)(186003)(6116002)(2501003)(31686004)(58126008)(110136005)(6436002)(53936002)(54906003)(14454004)(6246003)(6512007)(36756003)(5660300002)(305945005)(7736002)(52116002)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3260;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dyOfLKAlpSI+b8Cx0JKJ0h0wtdVQKyYH/90oabYGAb4C6g11AlScmF+W48hYTKbavGssvyXElkO+2lXDCEmMDRXBZloqy1bz8gG9s9kdZpCaQPZImC2GhVi4YLUJsNEjuE+YPkqGSr6DAkUiuo06VrV05wJp9C3ov7yqSPyGz5Hya9CGItSDziCsxPk1rGQF0f5e5jKXVsIzWF2p8DEGkHbocPQtXJcQLvL8e95beUTI+wgN0cLMGDsy7R9KZZBTpKVtO6pX+CaXeOvBuW79OLv0MLSnbBH2sy0U51zEZ0fA7XUW5r6fXbr4l92Cxf4kWx5mCF/xoCulTGYRjTyXkU6ZCqmBMOTaMHMypM6xrWzm59F48ARFEMkKnomLST2jO38/mY6GoeSkeZ31B+pb4K6j6HstwsraVTU8U01yhJ8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0E60A608E87D5A469BF5BAE2252B5985@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd955b80-c579-42b6-1283-08d72a6672e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2019 20:46:20.0723
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5IPpeFE+b3j88B17/cNU5kwc95LiZAGMa1prMTqjhpQueEOb09kiXsVOBKEEkIMDG0gHeoINEMESX7YgJHKTXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3260
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QWxleCwNCg0KT24gOC8xOS8yMDE5IDU6NDIgQU0sIEFsZXhhbmRlciBHcmFmIHdyb3RlOg0KPiAN
Cj4gDQo+IE9uwqAxNS4wOC4xOcKgMTg6MjUswqBTdXRoaWt1bHBhbml0LMKgU3VyYXZlZcKgd3Jv
dGU6DQo+PiBBQ0vCoG5vdGlmaWVyc8KgZG9uJ3TCoHdvcmvCoHdpdGjCoEFNRMKgU1ZNwqB3L8Kg
QVZJQ8Kgd2hlbsKgdGhlwqBQSVTCoGludGVycnVwdA0KPj4gaXPCoGRlbGl2ZXJlZMKgYXPCoGVk
Z2UtdHJpZ2dlcmVkwqBmaXhlZMKgaW50ZXJydXB0wqBzaW5jZcKgQU1EwqBwcm9jZXNzb3JzDQo+
PiBjYW5ub3TCoGV4aXTCoG9uwqBFT0nCoGZvcsKgdGhlc2XCoGludGVycnVwdHMuDQo+Pg0KPj4g
QWRkwqBjb2RlwqB0b8KgY2hlY2vCoExBUElDwqBwZW5kaW5nwqBFT0nCoGJlZm9yZcKgaW5qZWN0
aW5nwqBhbnnCoHBlbmRpbmfCoFBJVA0KPj4gaW50ZXJydXB0wqBvbsKgQU1EwqBTVk3CoHdoZW7C
oEFWSUPCoGlzwqBhY3RpdmF0ZWQuDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTrCoFN1cmF2ZWXCoFN1
dGhpa3VscGFuaXQgPHN1cmF2ZWUuc3V0aGlrdWxwYW5pdEBhbWQuY29tPg0KPj4gLS0tDQo+PiDC
oMKgYXJjaC94ODYva3ZtL2k4MjU0LmPCoHzCoDMxwqArKysrKysrKysrKysrKysrKysrKysrKysr
LS0tLS0tDQo+PiDCoMKgMcKgZmlsZcKgY2hhbmdlZCzCoDI1wqBpbnNlcnRpb25zKCspLMKgNsKg
ZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZsKgLS1naXTCoGEvYXJjaC94ODYva3ZtL2k4MjU0LmPC
oGIvYXJjaC94ODYva3ZtL2k4MjU0LmMNCj4+IGluZGV4wqA0YTZkYzU0Li4zMWM0YTliwqAxMDA2
NDQNCj4+IC0tLcKgYS9hcmNoL3g4Ni9rdm0vaTgyNTQuYw0KPj4gKysrwqBiL2FyY2gveDg2L2t2
bS9pODI1NC5jDQo+PiBAQMKgLTM0LDEwwqArMzQsMTLCoEBADQo+PiDCoMKgI2luY2x1ZGXCoDxs
aW51eC9rdm1faG9zdC5oPg0KPj4gwqDCoCNpbmNsdWRlwqA8bGludXgvc2xhYi5oPg0KPj4gKyNp
bmNsdWRlwqA8YXNtL3ZpcnRleHQuaD4NCj4+IMKgwqAjaW5jbHVkZcKgImlvYXBpYy5oIg0KPj4g
wqDCoCNpbmNsdWRlwqAiaXJxLmgiDQo+PiDCoMKgI2luY2x1ZGXCoCJpODI1NC5oIg0KPj4gKyNp
bmNsdWRlwqAibGFwaWMuaCINCj4+IMKgwqAjaW5jbHVkZcKgIng4Ni5oIg0KPj4gwqDCoCNpZm5k
ZWbCoENPTkZJR19YODZfNjQNCj4+IEBAwqAtMjM2LDbCoCsyMzgsMTLCoEBAwqBzdGF0aWPCoHZv
aWTCoGRlc3Ryb3lfcGl0X3RpbWVyKHN0cnVjdMKga3ZtX3BpdMKgKnBpdCkNCj4+IMKgwqDCoMKg
wqDCoGt0aHJlYWRfZmx1c2hfd29yaygmcGl0LT5leHBpcmVkKTsNCj4+IMKgwqB9DQo+PiArc3Rh
dGljwqBpbmxpbmXCoHZvaWTCoGt2bV9waXRfcmVzZXRfcmVpbmplY3Qoc3RydWN0wqBrdm1fcGl0
wqAqcGl0KQ0KPj4gK3sNCj4+ICvCoMKgwqDCoGF0b21pY19zZXQoJnBpdC0+cGl0X3N0YXRlLnBl
bmRpbmcswqAwKTsNCj4+ICvCoMKgwqDCoGF0b21pY19zZXQoJnBpdC0+cGl0X3N0YXRlLmlycV9h
Y2sswqAxKTsNCj4+ICt9DQo+PiArDQo+PiDCoMKgc3RhdGljwqB2b2lkwqBwaXRfZG9fd29yayhz
dHJ1Y3TCoGt0aHJlYWRfd29ya8KgKndvcmspDQo+PiDCoMKgew0KPj4gwqDCoMKgwqDCoMKgc3Ry
dWN0wqBrdm1fcGl0wqAqcGl0wqA9wqBjb250YWluZXJfb2Yod29yayzCoHN0cnVjdMKga3ZtX3Bp
dCzCoGV4cGlyZWQpOw0KPj4gQEDCoC0yNDQsNsKgKzI1MiwyM8KgQEDCoHN0YXRpY8Kgdm9pZMKg
cGl0X2RvX3dvcmsoc3RydWN0wqBrdGhyZWFkX3dvcmvCoCp3b3JrKQ0KPj4gwqDCoMKgwqDCoMKg
aW50wqBpOw0KPj4gwqDCoMKgwqDCoMKgc3RydWN0wqBrdm1fa3BpdF9zdGF0ZcKgKnBzwqA9wqAm
cGl0LT5waXRfc3RhdGU7DQo+PiArwqDCoMKgwqAvKg0KPj4gK8KgwqDCoMKgwqAqwqBTaW5jZSzC
oEFNRMKgU1ZNwqBBVklDwqBhY2NlbGVyYXRlc8Kgd3JpdGXCoGFjY2Vzc8KgdG/CoEFQSUPCoEVP
SQ0KPj4gK8KgwqDCoMKgwqAqwqByZWdpc3RlcsKgZm9ywqBlZGdlLXRyaWdnZXLCoGludGVycnVw
dHMuwqBQSVTCoHdpbGzCoG5vdMKgYmXCoGFibGUNCj4+ICvCoMKgwqDCoMKgKsKgdG/CoHJlY2Vp
dmXCoHRoZcKgSVJRwqBBQ0vCoG5vdGlmaWVywqBhbmTCoHdpbGzCoGFsd2F5c8KgYmXCoHplcm8u
DQo+PiArwqDCoMKgwqDCoCrCoFRoZXJlZm9yZSzCoHdlwqBjaGVja8KgaWbCoGFuecKgTEFQSUPC
oEVPScKgcGVuZGluZ8KgZm9ywqB2ZWN0b3LCoDANCj4+ICvCoMKgwqDCoMKgKsKgYW5kwqByZXNl
dMKgaXJxX2Fja8KgaWbCoG5vwqBwZW5kaW5nLg0KPj4gK8KgwqDCoMKgwqAqLw0KPj4gK8KgwqDC
oMKgaWbCoChjcHVfaGFzX3N2bShOVUxMKcKgJibCoGt2bS0+YXJjaC5hcGljdl9zdGF0ZcKgPT3C
oEFQSUNWX0FDVElWQVRFRCnCoHsNCj4+ICvCoMKgwqDCoMKgwqDCoMKgaW50wqBlb2nCoD3CoDA7
DQo+PiArDQo+PiArwqDCoMKgwqDCoMKgwqDCoGt2bV9mb3JfZWFjaF92Y3B1KGkswqB2Y3B1LMKg
a3ZtKQ0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmwqAoa3ZtX2FwaWNfcGVuZGluZ19l
b2kodmNwdSzCoDApKQ0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZW9pKys7
DQo+PiArwqDCoMKgwqDCoMKgwqDCoGlmwqAoIWVvaSkNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBrdm1fcGl0X3Jlc2V0X3JlaW5qZWN0KHBpdCk7DQo+IA0KPiBJbsKgd2hpY2jCoGNhc2XC
oHdvdWxkwqBlb2nCoGJlwqAhPcKgMMKgd2hlbsKgQVBJQy1WwqBpc8KgYWN0aXZlPw0KDQpUaGF0
IHdvdWxkIGJlIHRoZSBjYXNlIHdoZW4gZ3Vlc3QgaGFzIG5vdCBwcm9jZXNzZWQgYW5kL29yIHN0
aWxsIHByb2Nlc3NpbmcgdGhlIGludGVycnVwdC4NCk9uY2UgdGhlIGd1ZXN0IHdyaXRlcyB0byBB
UElDIEVPSSByZWdpc3RlciBmb3IgZWRnZS10cmlnZ2VyZWQgaW50ZXJydXB0IGZvciB2ZWN0b3Ig
MCwNCmFuZCB0aGUgQVZJQyBoYXJkd2FyZSBhY2NlbGVyYXRlZCB0aGUgYWNjZXNzIGJ5IGNsZWFy
aW5nIHRoZSBoaWdoZXN0IHByaW9yaXR5IElTUiBiaXQsDQp0aGVuIHRoZSBlb2kgc2hvdWxkIGJl
IHplcm8uDQoNClN1cmF2ZWUNCg==
