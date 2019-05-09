Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0169A193F9
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 23:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfEIVDs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 17:03:48 -0400
Received: from mail-eopbgr770055.outbound.protection.outlook.com ([40.107.77.55]:24030
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725992AbfEIVDr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 17:03:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amd-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NyaKgjSLIxq87DuT4W1BRtr+IwJjojMeS3MC8Fk8naY=;
 b=IQk1IHtBtNfPwSU3qmkoF3zKJ71YrGhk67Lc8Inla1HFwQC61kzAJUBotLZuY5oyRXQb/NfdlQ5nWeTvFx8xhdf/tNnXYZFu1GoF5bg4hEbHFvHdUu1QgSqShhqwMAgUscr957wjrVJfbMxeGRbNMVqC9sadq2bdbObVIOKyvUs=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3066.namprd12.prod.outlook.com (20.178.30.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.11; Thu, 9 May 2019 21:03:05 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::d119:23e5:be33:4ac6]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::d119:23e5:be33:4ac6%2]) with mapi id 15.20.1856.012; Thu, 9 May 2019
 21:03:05 +0000
From:   "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To:     "Graf, Alexander" <graf@amazon.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>
Subject: Re: [PATCH] svm/avic: Allow avic_vcpu_load logic to support host APIC
 ID 255
Thread-Topic: [PATCH] svm/avic: Allow avic_vcpu_load logic to support host
 APIC ID 255
Thread-Index: AQHVAbVYshI13bVJeUaA1Du2DOEuS6Zfu3aAgANdToCAADj+AA==
Date:   Thu, 9 May 2019 21:03:05 +0000
Message-ID: <c8950de7-bed3-06e0-9d4f-3d1ab1cad9a2@amd.com>
References: <1556890631-9561-1-git-send-email-suravee.suthikulpanit@amd.com>
 <49a27e83-a83e-5d2d-9b11-bb09c15776d2@amazon.com>
 <da74be11-1278-3b0f-db19-459f2f50e2ad@amd.com>
In-Reply-To: <da74be11-1278-3b0f-db19-459f2f50e2ad@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
x-originating-ip: [165.204.77.11]
x-clientproxiedby: SN4PR0201CA0024.namprd02.prod.outlook.com
 (2603:10b6:803:2b::34) To DM6PR12MB2844.namprd12.prod.outlook.com
 (2603:10b6:5:45::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24ff02cf-4afc-4362-9f1b-08d6d4c1bae9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3066;
x-ms-traffictypediagnostic: DM6PR12MB3066:
x-microsoft-antispam-prvs: <DM6PR12MB3066955B5C3C1CBFD39BBA3BF3330@DM6PR12MB3066.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 003245E729
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(39860400002)(346002)(376002)(396003)(189003)(199004)(386003)(102836004)(53546011)(8936002)(6506007)(65806001)(11346002)(99286004)(5660300002)(52116002)(25786009)(476003)(486006)(65956001)(66066001)(478600001)(2616005)(446003)(66946007)(305945005)(31696002)(66476007)(71190400001)(66556008)(71200400001)(2906002)(26005)(36756003)(7736002)(86362001)(73956011)(2201001)(64756008)(186003)(66446008)(53936002)(72206003)(64126003)(31686004)(229853002)(81156014)(4326008)(76176011)(8676002)(81166006)(58126008)(110136005)(54906003)(14444005)(256004)(6436002)(68736007)(316002)(14454004)(6486002)(6512007)(65826007)(6116002)(3846002)(2501003)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3066;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: FGlppJOxw90diaz1eqmVLFaqlSevweaMYfFwrBvwhz1ZhMkGSxvNk6aAHrvNaFK5AE1I5dar9wctwEpeAPfdMAkD1NQVcN4sCIjhsX5/DJXkcxuEq8jMD3Yq18LxO/Uoao96DO5NGn5TZYPttmy4axltCR/9kvQC3n55FXoZseR2VS+PJMw859oKTz6k3rWA9FVU2ggAYhBm9wx7sIftpQ6f2Z2SwaxVUdxd5VJRPlbBNGc/Oo8qxVEZzSwrJYTYnZLmhLQIPAXliNXlL0/iu6fjFONPcxDKwxBMhmVAvJPGxspf6mDpDublshMM3vG+/W0k+u3VDX3IXoJB2o2aXz21i5IaHPMoJUER0mPiloXI7FsMlZy3Uu9B4ikjrtltWcficXGN71HCYFJ6bskEtdbZevwDGnrmBUvspXrZmIM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <49CD341922D76F49BD257EA771F9E849@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24ff02cf-4afc-4362-9f1b-08d6d4c1bae9
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2019 21:03:05.1004
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3066
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QWxleCwNCg0KQWN0dWFsbHksIGEgc2Vjb25kIHRob3VnaHQgb24gdGhpcyBwYXRjaCwgSSBzaG91
bGQgaGF2ZSBiZWVuIHVzaW5nDQpBVklDX1BIWVNJQ0FMX0lEX0VOVFJZX0hPU1RfUEhZU0lDQUxf
SURfTUFTSyAtLS0+DQoNCk9uIDUvOS8xOSAxMjozOSBQTSwgU3V0aGlrdWxwYW5pdCwgU3VyYXZl
ZSB3cm90ZToNCj4gW0NBVVRJT046IEV4dGVybmFsIEVtYWlsXQ0KPiANCj4gQWxleCwNCj4gDQo+
IE9uIDUvNy8xOSA5OjE2IEFNLCBHcmFmLCBBbGV4YW5kZXIgd3JvdGU6DQo+PiBbQ0FVVElPTjog
RXh0ZXJuYWwgRW1haWxdDQo+Pg0KPj4gT24gMDMuMDUuMTkgMTU6MzcsIFN1dGhpa3VscGFuaXQs
IFN1cmF2ZWUgd3JvdGU6DQo+Pj4gQ3VycmVudCBsb2dpYyBkb2VzIG5vdCBhbGxvdyBWQ1BVIHRv
IGJlIGxvYWRlZCBvbnRvIENQVSB3aXRoDQo+Pj4gQVBJQyBJRCAyNTUuIFRoaXMgc2hvdWxkIGJl
IGFsbG93ZWQgc2luY2UgdGhlIGhvc3QgcGh5c2ljYWwgQVBJQyBJRA0KPj4+IGZpZWxkIGluIHRo
ZSBBVklDIFBoeXNpY2FsIEFQSUMgdGFibGUgZW50cnkgaXMgYW4gOC1iaXQgdmFsdWUsDQo+Pj4g
YW5kIEFQSUMgSUQgMjU1IGlzIHZhbGlkIGluIHN5c3RlbSB3aXRoIHgyQVBJQyBlbmFibGVkLg0K
Pj4+DQo+Pj4gSW5zdGVhZCwgZG8gbm90IGFsbG93IFZDUFUgbG9hZCBpZiB0aGUgaG9zdCBBUElD
IElEIGNhbm5vdCBiZQ0KPj4+IHJlcHJlc2VudGVkIGJ5IGFuIDgtYml0IHZhbHVlLg0KPj4+DQo+
Pj4gU2lnbmVkLW9mZi1ieTogU3VyYXZlZSBTdXRoaWt1bHBhbml0IDxzdXJhdmVlLnN1dGhpa3Vs
cGFuaXRAYW1kLmNvbT4NCj4+DQo+PiBZb3VyIGNvbW1lbnQgZm9yIEFWSUNfTUFYX1BIWVNJQ0FM
X0lEX0NPVU5UIHNheXMgdGhhdCAweGZmICgyNTUpIGlzDQo+PiBicm9hZGNhc3QgaGVuY2UgeW91
IGRpc2FsbG93IHRoYXQgdmFsdWUuIEluIGZhY3QsIGV2ZW4gdGhlIGNvbW1lbnQgYSBmZXcNCj4+
IGxpbmVzIGFib3ZlIHRoZSBwYXRjaCBodW5rIGRvZXMgc2F5IHRoYXQuIFdoeSB0aGUgY2hhbmdl
IG9mIG1pbmQ/DQo+IA0KPiBBY3R1YWxseSwgSSB3b3VsZCBuZWVkIHRvIG1ha2UgY2hhbmdlIHRv
IHRoYXQgY29tbWVudCB0byByZW1vdmUgdGhlIG1lbnRpb25pbmcNCj4gb2YgMjU1IGFzIGJyb2Fk
Y2FzdC4gSSB3aWxsIHNlbmQgb3V0IFYyIHdpdGggcHJvcGVyIGNvbW1lbnQgZml4Lg0KPiANCj4g
VGhlIHJlYXNvbiBpcyBiZWNhdXNlIG9uIHN5c3RlbSB3LyB4MkFQSUMsIHRoZSBBUElDIElEIDI1
NSBpcyBhY3R1YWxseQ0KPiBub24tYnJvYWRjYXN0LCBhbmQgdGhpcyBzaG91bGQgYmUgYWxsb3dl
ZC4gVGhlIGNvZGUgaGVyZSBzaG91bGQgbm90IG5lZWQNCj4gdG8gY2hlY2sgZm9yIGJyb2FkY2Fz
dC4NCj4gDQo+IFRoYW5rcywNCj4gU3VyYXZlZQ0KPiANCj4+IEFsZXgNCj4+DQo+Pj4gLS0tDQo+
Pj4gICAgYXJjaC94ODYva3ZtL3N2bS5jIHwgNiArKysrKy0NCj4+PiAgICAxIGZpbGUgY2hhbmdl
ZCwgNSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+Pj4NCj4+PiBkaWZmIC0tZ2l0IGEv
YXJjaC94ODYva3ZtL3N2bS5jIGIvYXJjaC94ODYva3ZtL3N2bS5jDQo+Pj4gaW5kZXggMjk0NDQ4
ZS4uMTIyNzg4ZiAxMDA2NDQNCj4+PiAtLS0gYS9hcmNoL3g4Ni9rdm0vc3ZtLmMNCj4+PiArKysg
Yi9hcmNoL3g4Ni9rdm0vc3ZtLmMNCj4+PiBAQCAtMjA3MSw3ICsyMDcxLDExIEBAIHN0YXRpYyB2
b2lkIGF2aWNfdmNwdV9sb2FkKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgaW50IGNwdSkNCj4+PiAg
ICAgICAgaWYgKCFrdm1fdmNwdV9hcGljdl9hY3RpdmUodmNwdSkpDQo+Pj4gICAgICAgICAgICAg
ICAgcmV0dXJuOw0KPj4+DQo+Pj4gLSAgICAgaWYgKFdBUk5fT04oaF9waHlzaWNhbF9pZCA+PSBB
VklDX01BWF9QSFlTSUNBTF9JRF9DT1VOVCkpDQo+Pj4gKyAgICAgLyoNCj4+PiArICAgICAgKiBT
aW5jZSB0aGUgaG9zdCBwaHlzaWNhbCBBUElDIGlkIGlzIDggYml0cywNCj4+PiArICAgICAgKiB3
ZSBjYW4gc3VwcG9ydCBob3N0IEFQSUMgSUQgdXB0byAyNTUuDQo+Pj4gKyAgICAgICovDQo+Pj4g
KyAgICAgaWYgKFdBUk5fT04oaF9waHlzaWNhbF9pZCA+IEFWSUNfTUFYX1BIWVNJQ0FMX0lEX0NP
VU5UKSkNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXiBIRVJF
DQoNCkl0IGRvZXMgdGhlIHNhbWUgdGhpbmcsIGJ1dCB3b3VsZCBiZSBlYXNpZXIgdG8gdW5kZXJz
dGFuZC4NCg0KVGhlIEFWSUNfTUFYX1BIWVNJQ0FMX0lEX0NPVU5UIGlzIG1lYW50IGZvciByZXBy
ZXNlbnRpbmcgdGhlIG1heCBudW1iZXINCm9mIGVudHJ5IGFsbG93ZWQgZm9yIEFWSUMgcGh5c2lj
YWwgQVBJQyBJRCB0YWJsZSwgd2hpY2ggaXMgYSBkaWZmZXJlbnQgdGhpbmcuDQoNCkknbGwgc2Vu
ZCBvdXQgVjIuDQoNClN1cmF2ZWUNCj4+PiAgICAgICAgICAgICAgICByZXR1cm47DQo+Pj4NCj4+
PiAgICAgICAgZW50cnkgPSBSRUFEX09OQ0UoKihzdm0tPmF2aWNfcGh5c2ljYWxfaWRfY2FjaGUp
KTsNCj4+Pg0KPj4NCg==
