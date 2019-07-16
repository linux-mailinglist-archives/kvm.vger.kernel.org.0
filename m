Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 228C36AC85
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 18:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728771AbfGPQLC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 12:11:02 -0400
Received: from mail-eopbgr790073.outbound.protection.outlook.com ([40.107.79.73]:18976
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728004AbfGPQLC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 12:11:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U7GSzmeO/gDTgdtOFXLdc9ei8HqKnHg8XCUECcCwjyTZ/q+hNU39meFYX8sl8OB+MKpPrOPsK/7arOMv/etcE8CbZaI3IlaZzA9eXcaXDIKPP5intOVDXuX0Qg/vqUqBczu0OUHU0eu3KvHuMeQpOt7HpBaoOIT8BWvLQRuU73FEQSd4Y4hz8g/mdySP5RZ9iMP/s0xD9cdsrVDDvig3qYCJV4B2vRQcw7eXZ1hlUl718NEsTeJrRF2qKpY5YyJ+Or+AyABR7JeuqpdPT8o/pZ7jwb5nje6a6SYWjuNAlNn2+zmqbsC/UhHTphphYFJjwBqqhXG5LtgHkeG91SwzbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QfQOSYwg0gHApBMmpl9G9MT4uTr07ia28+75vnH53wU=;
 b=JEaQAHwDCfZrDZ/dH7Jo95lk7R7sdYCyvODzqoGIXjj2YJ12sh6jm1ipGkp+uzSwkARVy/9Lfkmcqk+++uG8vpLZ1MYPEKrSSVmb5giz/dYXWRf1+On+mQ7NAVR4Fi2NckKa17fjKEFFPfKOf/EKm8VJ2Mmy+LPyFkUd8Eok7XNNR3VArmJXQxS9icykbMNXIBI1SG1f8NxaLMdSb9EXUuZ1GabJO9DwJZPIiBdLU/mcbu6nH5BZMR3MDADvgdF4C20sHhCvWVgmtpyK8Ie5028UTMlApAF5ru/qHLVXFsnyklcnjWn3UZGz04VygpI6N22UqiWPVG2GpVefnkH1EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QfQOSYwg0gHApBMmpl9G9MT4uTr07ia28+75vnH53wU=;
 b=O0dB2Dxx6m/etAEuEK7ymEXif6m0VjxENbJZlPqGpGU/ZxufSUGVUKHGHq6z06/88Nol+4o2c7vnncCHRh40ZmHPVoa0y/ucnL6eXYZ24K7AqWvJtELIpCMZsgRPDMTfno5gB11qfKcaVan0Kd+bmd3pVsoeAOxbxSFv4IwKmkg=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.118.13) by
 DM6PR12MB3628.namprd12.prod.outlook.com (20.178.199.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Tue, 16 Jul 2019 16:10:20 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::7439:ea87:cc5d:71]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::7439:ea87:cc5d:71%7]) with mapi id 15.20.2073.012; Tue, 16 Jul 2019
 16:10:20 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     Liran Alon <liran.alon@oracle.com>
CC:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 1/2] KVM: SVM: Fix workaround for AMD Errata 1096
Thread-Topic: [PATCH 1/2] KVM: SVM: Fix workaround for AMD Errata 1096
Thread-Index: AQHVO0w5JJR7Enn+ZEGfnHG07AdKnabMIb8AgAFDlACAAAIYgIAAA+gA
Date:   Tue, 16 Jul 2019 16:10:20 +0000
Message-ID: <f6c78d65-70fc-4a79-44db-6abb0434db73@amd.com>
References: <20190715203043.100483-1-liran.alon@oracle.com>
 <20190715203043.100483-2-liran.alon@oracle.com>
 <1ef0f594-2039-1aeb-4fe0-edbc21fa1f60@amd.com>
 <CF48BCA4-4BC8-4AC8-8B48-85FA29E16719@oracle.com>
In-Reply-To: <CF48BCA4-4BC8-4AC8-8B48-85FA29E16719@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0501CA0046.namprd05.prod.outlook.com
 (2603:10b6:803:41::23) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:42::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb9debf9-4bde-4338-50bc-08d70a081985
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR12MB3628;
x-ms-traffictypediagnostic: DM6PR12MB3628:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DM6PR12MB36289CB512633DEDF3043EC0E5CE0@DM6PR12MB3628.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0100732B76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(199004)(189003)(8676002)(14454004)(54906003)(71200400001)(71190400001)(6306002)(14444005)(256004)(25786009)(6916009)(31696002)(966005)(6486002)(305945005)(81156014)(86362001)(81166006)(316002)(229853002)(6512007)(4326008)(8936002)(53936002)(6436002)(478600001)(6246003)(68736007)(476003)(31686004)(66476007)(66556008)(66446008)(66946007)(52116002)(446003)(66066001)(26005)(386003)(76176011)(2616005)(186003)(102836004)(5660300002)(7736002)(6116002)(486006)(36756003)(11346002)(64756008)(99286004)(6506007)(2906002)(53546011)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3628;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: joHv8srk19zNgDfo3huO+lCYeIGyI/ZAusYK1/2BOID0IM/JKiY7TeW3BYcCrWMyuBq09maGvwl6iZcGQOpuLGdUnrJYHnFrcoE1faX1hYJJNL1K9eehESnrQTYX7SYWt+VTyuFMyBn4U9VUmDvoZyIFSFDtpIJ+2kHd0liyqvuDhZ1/27O+gImddpPt9ybkMd4EoA8tApXLatMN42DH+nN0CyRKXP5h34bVK5aoBNB9WwzXNtpc+Kb4QCwvtksTloO/mCG3tcxl66N5j2pMVeOB5hE27dya5S991GdUpmH5Fya50V/y8z2ajwTQiRJkbHidrMsv8bYUW2Vws9h+Hiq+tMfz76FGd5IM+PfX7MZ5P423uNMRGxJv7LjyIU68r7fFiU6vPPh2Uuq26DMVgHtGceZyF8+opWxbuDvWmzM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <72DBD935C3E6A949AC64A71F4AF7B5A7@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb9debf9-4bde-4338-50bc-08d70a081985
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2019 16:10:20.1497
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sbrijesh@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3628
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCk9uIDcvMTYvMTkgMTA6NTYgQU0sIExpcmFuIEFsb24gd3JvdGU6DQo+IA0KPiANCj4+IE9u
IDE2IEp1bCAyMDE5LCBhdCAxODo0OCwgU2luZ2gsIEJyaWplc2ggPGJyaWplc2guc2luZ2hAYW1k
LmNvbT4gd3JvdGU6DQo+Pg0KPj4gT24gNy8xNS8xOSAzOjMwIFBNLCBMaXJhbiBBbG9uIHdyb3Rl
Og0KPj4+IEFjY29yZGluZyB0byBBTUQgRXJyYXRhIDEwOTY6DQo+Pj4gIk9uIGEgbmVzdGVkIGRh
dGEgcGFnZSBmYXVsdCB3aGVuIENSNC5TTUFQID0gMSBhbmQgdGhlIGd1ZXN0IGRhdGEgcmVhZCBn
ZW5lcmF0ZXMgYSBTTUFQIHZpb2xhdGlvbiwgdGhlDQo+Pj4gR3Vlc3RJbnN0ckJ5dGVzIGZpZWxk
IG9mIHRoZSBWTUNCIG9uIGEgVk1FWElUIHdpbGwgaW5jb3JyZWN0bHkgcmV0dXJuIDBoIGluc3Rl
YWQgdGhlIGNvcnJlY3QgZ3Vlc3QgaW5zdHJ1Y3Rpb24NCj4+PiBieXRlcy4iDQo+Pj4NCj4+PiBB
cyBzdGF0ZWQgYWJvdmUsIGVycmF0YSBpcyBlbmNvdW50ZXJlZCB3aGVuIGd1ZXN0IHJlYWQgZ2Vu
ZXJhdGVzIGEgU01BUCB2aW9sYXRpb24uIGkuZS4gdkNQVSBydW5zDQo+Pj4gd2l0aCBDUEw8MyBh
bmQgQ1I0LlNNQVA9MS4gSG93ZXZlciwgY29kZSBoYXZlIG1pc3Rha2VubHkgY2hlY2tlZCBpZiBD
UEw9PTMgYW5kIENSNC5TTUFQPT0wLg0KPj4+DQo+Pg0KPj4gVGhlIFNNQVAgdmlvbGF0aW9uIHdp
bGwgb2NjdXIgZnJvbSBDUEwzIHNvIENQTD09MyBpcyBhIHZhbGlkIGNoZWNrLg0KPj4NCj4+IFNl
ZSBbMV0gZm9yIGNvbXBsZXRlIGRpc2N1c3Npb24NCj4+DQo+PiBodHRwczovL3VybGRlZmVuc2Uu
cHJvb2Zwb2ludC5jb20vdjIvdXJsP3U9aHR0cHMtM0FfX3BhdGNod29yay5rZXJuZWwub3JnX3Bh
dGNoXzEwODA4MDc1Xy0yMzIyNDc5MjcxJmQ9RHdJR2FRJmM9Um9QMVl1bUNYQ2dhV0h2bFpZUjhQ
Wmg4QnY3cUlyTVVCNjVlYXBJX0puRSZyPUprNlE4bk56a1E2TEo2ZzQycUFSa2c2cnlJREdRci15
S1hQTkdaYnBUeDAmbT1SQXQ4dDhuQmFDeFVQeTVPVERrTzBuOEJNUTVsOW9TZkxNaUwwVExUdTZj
JnM9Tmt3ZThyVEpoeWdCQ0lQejI3TFhyeWxwdGpuV3lNd0ItbkphaW93V3BXYyZlPQ0KPiANCj4g
SSBzdGlsbCBkb27igJl0IHVuZGVyc3RhbmQuIFNNQVAgaXMgYSBtZWNoYW5pc20gd2hpY2ggaXMg
bWVhbnQgdG8gcHJvdGVjdCBhIENQVSBydW5uaW5nIGluIENQTDwzIGZyb20gbWlzdGFrZW5seSBy
ZWZlcmVuY2luZyBkYXRhIGNvbnRyb2xsYWJsZSBieSBDUEw9PTMuDQo+IFRoZXJlZm9yZSwgU01B
UCB2aW9sYXRpb24gc2hvdWxkIGJlIHJhaXNlZCB3aGVuIENQTDwzIGFuZCBkYXRhIHJlZmVyZW5j
ZWQgaXMgbWFwcGVkIGluIHBhZ2UtdGFibGVzIHdpdGggUFRFIHdpdGggVS9TIGJpdCBzZXQgdG8g
MS4gKGkuZS4gVXNlciBhY2Nlc3NpYmxlKS4NCj4gDQo+IFRodXMsIHdlIHNob3VsZCBjaGVjayBp
ZiBDUEw8MyBhbmQgQ1I0LlNNQVA9PTEuDQo+IA0KDQoNCkluIHRoaXMgcGFydGljdWxhciBjYXNl
IHdlIGFyZSBkZWFsaW5nIHdpdGggTlBGIGFuZCBub3QgU01BUCBmYXVsdCBwZXINCnNheS4NCg0K
V2hhdCB0eXBpY2FsbHkgaGFzIGhhcHBlbmVkIGhlcmUgaXM6DQoNCi0gdXNlciBzcGFjZSBkb2Vz
IHRoZSBNTUlPIGFjY2VzcyB3aGljaCBjYXVzZXMgYSBmYXVsdA0KLSBoYXJkd2FyZSBwcm9jZXNz
ZXMgdGhpcyBhcyBhIFZNRVhJVA0KLSBkdXJpbmcgcHJvY2Vzc2luZywgaGFyZHdhcmUgYXR0ZW1w
dHMgdG8gcmVhZCB0aGUgaW5zdHJ1Y3Rpb24gYnl0ZXMgdG8NCnByb3ZpZGUgZGVjb2RlIGFzc2lz
dC4gVGhpcyBpcyB0eXBpY2FsbHkgZG9uZSBieSBkYXRhIHJlYWQgcmVxdWVzdCBmcm9tDQp0aGUg
UklQIHRoYXQgdGhlIGd1ZXN0IHdhcyBhdC4gV2hpbGUgZG9pbmcgc28sIHdlIG1heSBoaXQgU01B
UCBmYXVsdA0KYmVjYXVzZSBpbnRlcm5hbGx5IENQVSBpcyBkb2luZyBhIGRhdGEgcmVhZCBmcm9t
IHRoZSBSSVAgdG8gZ2V0IHRob3NlDQppbnN0cnVjdGlvbiBieXRlcy4gU2luY2UgaXQgaGl0IHRo
ZSBTTUFQIGZhdWx0IGhlbmNlIGl0IHdhcyBub3QgYWJsZQ0KdG8gZGVjb2RlIHRoZSBpbnN0cnVj
dGlvbiB0byBwcm92aWRlIHRoZSBpbnNuX2xlbi4gU28gd2UgYXJlIGZpcnN0DQpjaGVja2luZyBp
ZiBpdCB3YXMgYSBmYXVsdCBjYXVzZWQgZnJvbSBDUEw9PTMgYW5kIFNNQVAgaXMgZW5hYmxlZC4N
CklmIHNvLCB3ZSBhcmUgaGl0dGluZyB0aGlzIGVycmF0YSBhbmQgaXQgY2FuIGJlIHdvcmthcm91
bmQuDQoNCi1CcmlqZXNoDQoNCg0KDQo=
