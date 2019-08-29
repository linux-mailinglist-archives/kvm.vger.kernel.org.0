Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78DE4A2126
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 18:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbfH2Qlw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 12:41:52 -0400
Received: from mail-eopbgr760071.outbound.protection.outlook.com ([40.107.76.71]:4737
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727115AbfH2Qlw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 12:41:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kIBDqxXREYlC87iZ6t4DqXlLO7Zsi0R9CtVQ4+hCuuOgt6ZJogIH2/Jzjrfd7AzXr1X4ez72DCCiRLsRf2TVqspDZJfNPMbgWkeHkujknCJ1YfkXJwPwCiZWVIjr4xyc4XsmcWV1zF9aTHe4iK0am8vMaL8KVNVz2Vjbn5AWdA8Y3V08omCktK4OeAdoPFHmNZEZCtI1ykHyFz0DD5BydH4iOZvMn37U0/G3lCUz0zuuTNMIqLANh5ya/WIaFxxqGMEoqbtdsxAv4rbLM/V8uHi4ed1f+6HtfDxaJKW5xEo1IEAZlW7L8a9DJJnnfKVmKVdXOAoUUNf27nEzkuIhow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yYaac3Wu8j0cQ5wf1a2j968qmXvov6EmpSm3YMgu0dY=;
 b=Aez8mRlQ5cYlxaB5lRGPYCsdeRc0PJyDCuCNx2QpVIkc0XvwLHwqVUsk3UMXTk2Ax/eRtu4j63wGAvZVFATk0rMi9GJT+yCWgnhDb1GDdzh3k/WKiMtwbgd4/mRCACu7FYU34qDtdLcX6Lw1mjPOc4HYJtytrA4nCZaJHJw0AxnmTEK3ZTfOpXhY0eslW6YYGIeerMV51/0JyoA0qB+GcXMxEsMOlzEhVWyvGwAIU7Ce9bClHzfLbQ5X7NOUA86W0hJ/Bl/19cSRLVLukj9VEtnxuwSqbAPODAjDo5C47PG0qJwtHkvMKdaw+ItAvtXiv5kg+naNnj4+A7ZjHlEv5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yYaac3Wu8j0cQ5wf1a2j968qmXvov6EmpSm3YMgu0dY=;
 b=Qu0zmSOZIh5GG2iSkfHFjd4r7dpf9EhqrDtFPAHXBHUE+skumKejMXnLBpbTPqxExhFu6pneoyWssCzyXGPwycBeP1RlEpjtlgW9iXAQ1SCYwPxs1TmZCIr3k5PvjyWWH2YoK8c8own3EpKdVWVJ9tyxvNcel02Giz3bnr2LLYk=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.118.13) by
 DM6PR12MB2970.namprd12.prod.outlook.com (20.178.29.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Thu, 29 Aug 2019 16:41:50 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::a410:b3e6:1557:7450]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::a410:b3e6:1557:7450%6]) with mapi id 15.20.2199.021; Thu, 29 Aug 2019
 16:41:50 +0000
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
Subject: Re: [PATCH v3 09/11] KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP
 ioctl
Thread-Topic: [PATCH v3 09/11] KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP
 ioctl
Thread-Index: AQHVN1vlxpPTIlj8306352DSevx+a6cSnlyAgAAEOQA=
Date:   Thu, 29 Aug 2019 16:41:50 +0000
Message-ID: <f347e7f3-133f-2199-eeec-583a10c43e3c@amd.com>
References: <20190710201244.25195-1-brijesh.singh@amd.com>
 <20190710201244.25195-10-brijesh.singh@amd.com>
 <20190829162641.GB2132@zn.tnic>
In-Reply-To: <20190829162641.GB2132@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0601CA0004.namprd06.prod.outlook.com
 (2603:10b6:803:2f::14) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:42::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fd8db703-fd94-4e6b-4c34-08d72c9fca46
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR12MB2970;
x-ms-traffictypediagnostic: DM6PR12MB2970:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB29701ECEE0D7BAB2CA9F7DB9E5A20@DM6PR12MB2970.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:510;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(199004)(189003)(66946007)(6246003)(3846002)(6116002)(6512007)(6436002)(102836004)(478600001)(186003)(76176011)(86362001)(8936002)(14454004)(229853002)(99286004)(26005)(256004)(53936002)(52116002)(36756003)(31686004)(66446008)(66556008)(64756008)(66476007)(6486002)(6916009)(305945005)(446003)(71200400001)(5660300002)(31696002)(81156014)(81166006)(476003)(2906002)(11346002)(7736002)(316002)(2616005)(4326008)(54906003)(66066001)(7416002)(486006)(8676002)(25786009)(71190400001)(6506007)(386003)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2970;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: yC/IOaVFmrSJW1RndFQqMrlq/0GuhsVzIIej2HtuUJGnwtmHBpUitVKPMtn4TxCkRvC0CwUviUMTuq0yEJgyWoUgtE4gle2j3eTlmSRNxD7emhI8kVpJVUoXl29e8i+yAA/hpMLGf2xsWWnEJS5bL3ssRxyjFLThTgEUfGu2EvHSAjNCLxdz6DxFR0gNCYF3DtTpeSZe4kUlSA5xhYsmov2iZe6E6PFzytg3ALu7nJfRoNZ4Lo0KqIOV+wtkdMcmmqSvKo9LoNKsyZgQjAT83OQKz0vavjkmWYMl6TQkl9HLzbbWntjhV0ifnRwnlgixxfUNUR7mqGwbPm/qfyrk1X+Bopx/4hpLc6czUu2gj9fgkw/hXbX1css0yDDJ4BO/GAiPx2O+0y3a1p+QxrR8Fi2wItRxqawG/k6+mLtAAf8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CB0D7ADC58F7CF458A03B47D609DC5F6@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd8db703-fd94-4e6b-4c34-08d72c9fca46
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 16:41:50.3656
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2ygINi2I76eQlunMVExiIL9qccIEGF1iii6JYsU0ZCaZAxsvBwYLWuSB46Ii21ZGklRS+iIrj+K6mtH7mysrbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2970
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCk9uIDgvMjkvMTkgMTE6MjYgQU0sIEJvcmlzbGF2IFBldGtvdiB3cm90ZToNCj4gT24gV2Vk
LCBKdWwgMTAsIDIwMTkgYXQgMDg6MTM6MTBQTSArMDAwMCwgU2luZ2gsIEJyaWplc2ggd3JvdGU6
DQo+PiBAQCAtNzc2Nyw3ICs3ODA4LDggQEAgc3RhdGljIHN0cnVjdCBrdm1feDg2X29wcyBzdm1f
eDg2X29wcyBfX3JvX2FmdGVyX2luaXQgPSB7DQo+PiAgIA0KPj4gICAJLm5lZWRfZW11bGF0aW9u
X29uX3BhZ2VfZmF1bHQgPSBzdm1fbmVlZF9lbXVsYXRpb25fb25fcGFnZV9mYXVsdCwNCj4+ICAg
DQo+PiAtCS5wYWdlX2VuY19zdGF0dXNfaGMgPSBzdm1fcGFnZV9lbmNfc3RhdHVzX2hjDQo+PiAr
CS5wYWdlX2VuY19zdGF0dXNfaGMgPSBzdm1fcGFnZV9lbmNfc3RhdHVzX2hjLA0KPj4gKwkuZ2V0
X3BhZ2VfZW5jX2JpdG1hcCA9IHN2bV9nZXRfcGFnZV9lbmNfYml0bWFwDQo+PiAgIH07DQo+PiAg
IA0KPj4gICBzdGF0aWMgaW50IF9faW5pdCBzdm1faW5pdCh2b2lkKQ0KPj4gZGlmZiAtLWdpdCBh
L2FyY2gveDg2L2t2bS94ODYuYyBiL2FyY2gveDg2L2t2bS94ODYuYw0KPj4gaW5kZXggNmJhZjQ4
ZWMwZWQ0Li41OWFlNDliMWI5MTQgMTAwNjQ0DQo+PiAtLS0gYS9hcmNoL3g4Ni9rdm0veDg2LmMN
Cj4+ICsrKyBiL2FyY2gveDg2L2t2bS94ODYuYw0KPj4gQEAgLTQ5MjcsNiArNDkyNywxOCBAQCBs
b25nIGt2bV9hcmNoX3ZtX2lvY3RsKHN0cnVjdCBmaWxlICpmaWxwLA0KPj4gICAJCXIgPSBrdm1f
dm1faW9jdGxfaHZfZXZlbnRmZChrdm0sICZodmV2ZmQpOw0KPj4gICAJCWJyZWFrOw0KPj4gICAJ
fQ0KPj4gKwljYXNlIEtWTV9HRVRfUEFHRV9FTkNfQklUTUFQOiB7DQo+PiArCQlzdHJ1Y3Qga3Zt
X3BhZ2VfZW5jX2JpdG1hcCBiaXRtYXA7DQo+PiArDQo+PiArCQlyID0gLUVGQVVMVDsNCj4+ICsJ
CWlmIChjb3B5X2Zyb21fdXNlcigmYml0bWFwLCBhcmdwLCBzaXplb2YoYml0bWFwKSkpDQo+PiAr
CQkJZ290byBvdXQ7DQo+PiArDQo+PiArCQlyID0gLUVOT1RUWTsNCj4+ICsJCWlmIChrdm1feDg2
X29wcy0+Z2V0X3BhZ2VfZW5jX2JpdG1hcCkNCj4+ICsJCQlyID0ga3ZtX3g4Nl9vcHMtPmdldF9w
YWdlX2VuY19iaXRtYXAoa3ZtLCAmYml0bWFwKTsNCj4gDQo+IEkgZG9uJ3Qga25vdyB3aGF0IHRy
ZWUgeW91J3ZlIGRvbmUgdGhvc2UgcGF0Y2hlcyBhZ2FpbnN0IGJ1dCBhZ2FpbnN0IC1yYzYrLCB0
aGUNCj4gZmlyc3QgYXJndW1lbnQgYWJvdmUgbmVlZHMgdG8gYmUgdmNwdS0+a3ZtOg0KPiANCj4g
YXJjaC94ODYva3ZtL3g4Ni5jOiBJbiBmdW5jdGlvbiDigJhrdm1fYXJjaF92Y3B1X2lvY3Rs4oCZ
Og0KPiBhcmNoL3g4Ni9rdm0veDg2LmM6NDM0Mzo0MTogZXJyb3I6IOKAmGt2beKAmSB1bmRlY2xh
cmVkIChmaXJzdCB1c2UgaW4gdGhpcyBmdW5jdGlvbikNCj4gICAgICByID0ga3ZtX3g4Nl9vcHMt
PmdldF9wYWdlX2VuY19iaXRtYXAoa3ZtLCAmYml0bWFwKTsNCj4gICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgXn5+DQo+IGFyY2gveDg2L2t2bS94ODYuYzo0MzQzOjQx
OiBub3RlOiBlYWNoIHVuZGVjbGFyZWQgaWRlbnRpZmllciBpcyByZXBvcnRlZCBvbmx5IG9uY2Ug
Zm9yIGVhY2ggZnVuY3Rpb24gaXQgYXBwZWFycyBpbg0KPiBtYWtlWzJdOiAqKiogW3NjcmlwdHMv
TWFrZWZpbGUuYnVpbGQ6MjgwOiBhcmNoL3g4Ni9rdm0veDg2Lm9dIEVycm9yIDENCj4gbWFrZVsy
XTogKioqIFdhaXRpbmcgZm9yIHVuZmluaXNoZWQgam9icy4uLi4NCj4gbWFrZVsxXTogKioqIFtz
Y3JpcHRzL01ha2VmaWxlLmJ1aWxkOjQ5NzogYXJjaC94ODYva3ZtXSBFcnJvciAyDQo+IG1ha2Vb
MV06ICoqKiBXYWl0aW5nIGZvciB1bmZpbmlzaGVkIGpvYnMuLi4uDQo+IG1ha2U6ICoqKiBbTWFr
ZWZpbGU6MTA4MzogYXJjaC94ODZdIEVycm9yIDINCj4gbWFrZTogKioqIFdhaXRpbmcgZm9yIHVu
ZmluaXNoZWQgam9icy4uLi4NCj4gDQoNClRoZSBwYXRjaGVzIHdlcmUgYmFzZWQgb24gS1ZNIHRy
ZWUgSnVseSA5dGgNCg0KY29tbWl0IGlkOiBlOWE4M2JkMjMyMjAzNWVkOWQ3ZGNmMzU3NTNkM2Y5
ODRkNzZjNmE1DQoNCkkgaGF2ZSBiZWVuIHdhaXRpbmcgZm9yIHNvbWUgZmVlZGJhY2sgYmVmb3Jl
IHJlZnJlc2hpbmcgaXQuIElmIHlvdSB3YW50DQp0aGVuIEkgY2FuIHJlZnJlc2ggdGhlIHBhdGNo
IHdpdGggbGF0ZXN0IGZyb20gTGludXMgYW5kIHNlbmQgdjQuDQoNCnRoYW5rcw0K
