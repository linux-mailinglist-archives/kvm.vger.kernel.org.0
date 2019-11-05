Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1BFFF083F
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 22:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729813AbfKEVZX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 16:25:23 -0500
Received: from mail-eopbgr720070.outbound.protection.outlook.com ([40.107.72.70]:53109
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728515AbfKEVZX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 16:25:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A8M8S9X8YHJZ9sfnUSwrTkEc21ilCSPZbUOMFGzfewyIZyK4fy90c7On2WKJUTRROg1q/awEER6h5VXijD5YtE0/TQloTC4SuxytmA5R/Fy5ms/9WlDweqjvdfC6iVTlPbbmk0e5Vbn/6TtBOIC2BDNWblN/5xaECKtZUGzJ2ONigvpNHmT+0hZZwoC32RlWM4UWqF5yqTh+Gb6UPUWzOwEoga76xmvLimvaSCtnw5wFuv20ZA2QGxhJYH3SumUu4N3mDFebh1ljtY2f8XEIWEzJ2hBLqp7+64RfrnL0kbrKHAqQOCo5akNq2YykZJgx3ggKwTUQYlXaCQZBsUxKPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ag9cHqeXy5MJ57oTJjOmPRlWj0dDM16w01rExDwIc8Q=;
 b=A5cvmjE0FUyR3TyaP644a7YoFrAv9DbEeQK3E2lNYm/KIuN830m3kuetSU0ZaiaUouccfqK04CwQIZlG70KRWJvgcI6kHIR88tzGT1Aqdy4pbMFGshInXizGSYk7tN3r3Ezt2v2tdQCeMJWHV7IitcFuHmq9tld2f5TObEke9TU26ZNyRRlzDR6gjJq36/gI10mGDkyd6m7/8enhCwKVRUA+cRarC1ZSy28i2SKI2QLdzZUzy5cJxvkERT+wIvmkb5uyN1vIcvpXOIFAiMOwNLrlrzoqUy5fUIRiZu09ONDZiKbP67KirJ0hJnjNNwMS07xKx83WTMxhcZTFRhGu7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ag9cHqeXy5MJ57oTJjOmPRlWj0dDM16w01rExDwIc8Q=;
 b=0PfJBUVaSbzcVRmzq1dcbuVaCrxMa4Yi/iLqfAe5CTQkaZNIo4tY3DuQdoAr5ZqndKd0L9jHnRVl1eRLdoltQw0EAsww9yEyMjgbeg6h5qBZtvotyM7d2H6+gRCuAa55MTu/oQe6UQ/91dnh7+dY4fqOKcGL7v9KGQckhJBHEPo=
Received: from DM5PR12MB2471.namprd12.prod.outlook.com (52.132.141.138) by
 DM5PR12MB1195.namprd12.prod.outlook.com (10.168.240.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 21:25:20 +0000
Received: from DM5PR12MB2471.namprd12.prod.outlook.com
 ([fe80::c5a3:6a2e:8699:1999]) by DM5PR12MB2471.namprd12.prod.outlook.com
 ([fe80::c5a3:6a2e:8699:1999%6]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 21:25:20 +0000
From:   "Moger, Babu" <Babu.Moger@amd.com>
To:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Moger, Babu" <Babu.Moger@amd.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "nayna@linux.ibm.com" <nayna@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "ricardo.neri-calderon@linux.intel.com" 
        <ricardo.neri-calderon@linux.intel.com>,
        "bshanks@codeweavers.com" <bshanks@codeweavers.com>
Subject: [PATCH v3 0/2] Update UMIP config parameter and docs
Thread-Topic: [PATCH v3 0/2] Update UMIP config parameter and docs
Thread-Index: AQHVlB+GGc0dpKFRika7sFVswTRcfQ==
Date:   Tue, 5 Nov 2019 21:25:20 +0000
Message-ID: <157298900783.17462.2778215498449243912.stgit@naples-babu.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR2101CA0019.namprd21.prod.outlook.com
 (2603:10b6:805:106::29) To DM5PR12MB2471.namprd12.prod.outlook.com
 (2603:10b6:4:b5::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Babu.Moger@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 62149737-f9b4-42d7-fd7b-08d76236a90c
x-ms-traffictypediagnostic: DM5PR12MB1195:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR12MB119525CD471EF5BA27BB31FB957E0@DM5PR12MB1195.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(376002)(366004)(136003)(346002)(199004)(189003)(2201001)(54906003)(110136005)(8676002)(7416002)(103116003)(305945005)(81156014)(81166006)(66946007)(478600001)(25786009)(66556008)(64756008)(99286004)(66476007)(7736002)(316002)(26005)(2501003)(3846002)(102836004)(52116002)(6116002)(6436002)(6506007)(386003)(86362001)(66446008)(8936002)(15650500001)(2906002)(14454004)(71200400001)(71190400001)(4744005)(256004)(6512007)(476003)(486006)(186003)(4326008)(14444005)(5660300002)(6486002)(66066001)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1195;H:DM5PR12MB2471.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oOnlPsQawJIRZnk/q9q7xfj0bJjvSRJxT6NhLffT9uCU4b8CDAqnbe9g1CoKBIVzUvursflKxBZkluGGKLgjy0c71m1AqcN7paAG7IIcTfq+2k7TdCGDJ/IwxvDoKLgML6ALFLrIx749eYtPlh1ESMAEGMopy29/aOxyglMOduQ52+a08dMlzl9z+owQpb/AAIAdvAGo2e8IWQQG8OppV1LkKr57U+ZFhFt/31g5h/piYC6BtTUq5MwkQFu3wTx8K7lwQObCzxaIOuACQ+XrpqyfjQeA/ffzprSDe/V1L2vgi+luQSTdJ5ghwIHPgBVekcVA6hQ3zpfGIe4d/Ee6QEUGICpMeBOFxNzjiOP1hJLkS7rHg0FfNfbRzWlsneJRN08bnykeMPG5feE6woHmyKICgKtBvR5m6Xb2xLMKtusho0LIzjsM9dN5uI5crU+U
Content-Type: text/plain; charset="utf-8"
Content-ID: <A91190F407264842AD2DC0C30F7225D5@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62149737-f9b4-42d7-fd7b-08d76236a90c
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 21:25:20.2520
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MgqHg9E1/9AiWOVru2ze++9ac88snNMmQlmF67IC5RLAILm45/Ge4+cqJuxxrao5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1195
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QU1EIDJuZCBnZW5lcmF0aW9uIEVQWUMgcHJvY2Vzc29ycyBzdXBwb3J0IHRoZSBVTUlQIGZlYXR1
cmUuIA0KU28sIHVwZGF0ZSB0aGUgS2NvbmZpZyBhbmQgdW1pcCByZWxhdGVkIGRvY3VtZW50YXRp
b24uDQoNCi0tLQ0KdjM6DQogIFJlbW92ZWQgWDg2IGRlcGVuZCBjaGVjay4gSnVzdCBrZXB0IENQ
VV9TVVBfKiBjaGVjay4NCiAgVXBkYXRlZCB0aGUgY29tbWVudHMgaW4gdW1pcC5jIHRvIG1ha2Ug
aXQgYml0IGdlbmVyaWMuDQoNCnYyOg0KICBMZWFybmVkIHRoYXQgZm9yIHRoZSBoYXJkd2FyZSB0
aGF0IHN1cHBvcnQgVU1JUCwgd2UgZG9udCBuZWVkIHRvDQogIGVtdWxhdGUuIFJlbW92ZWQgdGhl
IGVtdWxhdGlvbiByZWxhdGVkIGNvZGUgYW5kIGp1c3Qgc3VibWl0dGluZw0KICB0aGUgY29uZmln
IGNoYW5nZXMuDQoNCg0KQmFidSBNb2dlciAoMik6DQogICAgICB4ODYvS2NvbmZpZzogUmVuYW1l
IFVNSVAgY29uZmlnIHBhcmFtZXRlcg0KICAgICAgeDg2L3VtaXA6IFVwZGF0ZSB0aGUgY29tbWVu
dHMgdG8gY292ZXIgZ2VuZXJpYyB4ODYgcHJvY2Vzc29ycw0KDQoNCiBhcmNoL3g4Ni9LY29uZmln
ICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAxMCArKysrKy0tLS0tDQogYXJjaC94ODYvaW5j
bHVkZS9hc20vZGlzYWJsZWQtZmVhdHVyZXMuaCB8ICAgIDIgKy0NCiBhcmNoL3g4Ni9pbmNsdWRl
L2FzbS91bWlwLmggICAgICAgICAgICAgIHwgICAgNCArKy0tDQogYXJjaC94ODYva2VybmVsL01h
a2VmaWxlICAgICAgICAgICAgICAgICB8ICAgIDIgKy0NCiBhcmNoL3g4Ni9rZXJuZWwvdW1pcC5j
ICAgICAgICAgICAgICAgICAgIHwgICAxMiArKysrKystLS0tLS0NCiA1IGZpbGVzIGNoYW5nZWQs
IDE1IGluc2VydGlvbnMoKyksIDE1IGRlbGV0aW9ucygtKQ0KDQotLQ0K
