Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE5166AFD5
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 21:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728966AbfGPT3g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 15:29:36 -0400
Received: from mail-eopbgr710075.outbound.protection.outlook.com ([40.107.71.75]:63328
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726213AbfGPT3f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 15:29:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bmY/lNq3MIXWpypbDIkb9cGYOQD5J8pp5KR8TmEnxsVjDF56/eOz0o7M1tUwxcgdX7GMmlFHgx9GN+QNbIGOm1DLkMyi85ldd7HLEXjEN8f3IYBXTGVMq+JFEDiYLoc6rru3MrhHREElT+38pCEv644Lg4q+GG/V8PVQE7NZFZVJwOHe30I4WF8nQnvkgSgl2L9TELw+6vKKJO/tAMuhIkgAn56dMaNaqsPttOIWO7ylS471G7XOqZDVlI0PA8Hbzza7QP+N7AOkZgwDiV1qY9e0Du5tXenBp9tnArL1Z6FwRz0a4eqwi0AXRiv/TfKzkBaR6ZWcPAHlPziWp2BcRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oMxD2eq/k2szv51FNrlpFi4CyTH6RicN4CsXMLWXXZg=;
 b=ZK9iIlYo1QYoaJpIYMAxvpc5NFB2V+c6SRsUwynLV2SLP2TGAZF2LTXbv2wgzYfYakgfKCZFpzdM3G0vNU1MK5fXN1Gmuas5iTqTeXlRqs7n8170w8vP4DTC3SAJgUhnHbPcjSmNo/x+4BGdgMqZd+sUZr5Rjtr5IEZt9b8bNKJqMXj6V9pLf4v93Egb7pLBrhbzTO1iT8feM3/GEilUJn34qmRIZLVJgL4knroGNvDQllnNQtJadYoH0VF8Dq+Dg5zSGbJM0eIjE8/35qWGZvdhDrbHcSsR1OAf8LPGimzcClzYmM0tLbrqVA3BIpDQPZTp0+4Ub4EI0b/cr/R09Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oMxD2eq/k2szv51FNrlpFi4CyTH6RicN4CsXMLWXXZg=;
 b=R5BB+3uXNK5CsRhLSawwrWGWaFBFp6uLn9AIkEbtQUeIoc6Zw23mkGD/sKNvuojn0RYKxTLvzNl4MJcz0i7dyLNt0T9AVQP4/D+Nwrw1QiEsX26kKwtBxe5t7z5VKwcVeBzLndPTYJqPutKh/GGFKi/1IbBsnVIHCG+5mwmfx5M=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.118.13) by
 DM6PR12MB3963.namprd12.prod.outlook.com (10.255.174.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Tue, 16 Jul 2019 19:28:54 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::7439:ea87:cc5d:71]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::7439:ea87:cc5d:71%7]) with mapi id 15.20.2073.012; Tue, 16 Jul 2019
 19:28:54 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 1/2] KVM: SVM: Fix workaround for AMD Errata 1096
Thread-Topic: [PATCH 1/2] KVM: SVM: Fix workaround for AMD Errata 1096
Thread-Index: AQHVO0w5JJR7Enn+ZEGfnHG07AdKnabMIb8AgAFDlACAAAIYgIAAA+gAgAAC6ACAAAXogIAABBmAgAAInwCAAAJiAIAAH44A
Date:   Tue, 16 Jul 2019 19:28:53 +0000
Message-ID: <015b03bc-8518-2066-c916-f5e12dd2d506@amd.com>
References: <20190715203043.100483-1-liran.alon@oracle.com>
 <20190715203043.100483-2-liran.alon@oracle.com>
 <1ef0f594-2039-1aeb-4fe0-edbc21fa1f60@amd.com>
 <CF48BCA4-4BC8-4AC8-8B48-85FA29E16719@oracle.com>
 <f6c78d65-70fc-4a79-44db-6abb0434db73@amd.com>
 <F2442A5C-702A-433D-9156-056E1844F378@oracle.com>
 <20190716164151.GC1987@linux.intel.com>
 <60D01C4B-EC2E-453E-B5F6-BBE8FA94E31D@oracle.com>
 <ce1284de-6088-afd7-ead4-6ef70b89f365@redhat.com>
 <DD44D29C-36C4-42E7-905E-7300F92F3BE6@oracle.com>
In-Reply-To: <DD44D29C-36C4-42E7-905E-7300F92F3BE6@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR0102CA0004.prod.exchangelabs.com (2603:10b6:805:1::17)
 To DM6PR12MB2682.namprd12.prod.outlook.com (2603:10b6:5:42::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f7b09da2-4f6f-40c1-e081-08d70a23d692
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR12MB3963;
x-ms-traffictypediagnostic: DM6PR12MB3963:
x-microsoft-antispam-prvs: <DM6PR12MB39632B8C3D375F60BACFCA8FE5CE0@DM6PR12MB3963.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0100732B76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(346002)(376002)(366004)(199004)(189003)(66066001)(99286004)(7736002)(102836004)(68736007)(54906003)(305945005)(8936002)(316002)(110136005)(8676002)(52116002)(386003)(11346002)(186003)(2616005)(446003)(26005)(81156014)(81166006)(14454004)(66446008)(486006)(64756008)(6512007)(66556008)(66476007)(53936002)(66946007)(2906002)(25786009)(3846002)(6116002)(36756003)(31696002)(14444005)(6486002)(478600001)(86362001)(6436002)(256004)(476003)(5660300002)(53546011)(76176011)(6506007)(71200400001)(71190400001)(229853002)(31686004)(6246003)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3963;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: eKWnMPxIWm8jrLO7VoqIJrWiubL114H5gpwCeIN61Rn2yKgxZ7X+x6Ps8eTvTI6CqR54vZWSBy+rFp1lSHPLKkLrAibD6/F8xFGnHzzR3/tbpZylB2TWyeCv+woyd55345y6jVYQuBD61cMYSZUca9+/sbfxFivAFnBGgSigH7p64tEDjAsC2mVEtTk7Mq8CRSPISt74ENhBok3wzjNjazkyE3omhziBprWUYWB5a0efMUGQv742nGqH9wSlWijMhNsNoU2LZk2a2Lz0iOcT+x9ArCRkyqSpx3a2bO+AX0vmkF7MliJU5MSQloq3S5HP5Gk1fNs2Hp5pq4xPpEhkFgg8DD7+49pjjNDmztIhCrxy5j0lGHrLJV4dzXLfxCf5n9S7VdYX2XMgzRxQ8gtzywbSKtmmy1/GnaQ+NkGpynI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <87EA40BE5B0B2345BACCDE80001AF54C@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7b09da2-4f6f-40c1-e081-08d70a23d692
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2019 19:28:53.9585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sbrijesh@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3963
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCk9uIDcvMTYvMTkgMTI6MzUgUE0sIExpcmFuIEFsb24gd3JvdGU6DQo+IA0KPiANCj4+IE9u
IDE2IEp1bCAyMDE5LCBhdCAyMDoyNywgUGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNv
bT4gd3JvdGU6DQo+Pg0KPj4gT24gMTYvMDcvMTkgMTg6NTYsIExpcmFuIEFsb24gd3JvdGU6DQo+
Pj4gSWYgdGhlIENQVSBwZXJmb3JtcyB0aGUgVk1FeGl0IHRyYW5zaXRpb24gb2Ygc3RhdGUgYmVm
b3JlIGRvaW5nIHRoZSBkYXRhIHJlYWQgZm9yIERlY29kZUFzc2lzdCwNCj4+PiB0aGVuIEkgYWdy
ZWUgdGhhdCBDUEwgd2lsbCBiZSAwIG9uIGRhdGEtYWNjZXNzIHJlZ2FyZGxlc3Mgb2YgdkNQVSBD
UEwuIEJ1dCB0aGlzIGFsc28gbWVhbnMgdGhhdCBTTUFQDQo+Pj4gdmlvbGF0aW9uIHNob3VsZCBi
ZSByYWlzZWQgYmFzZWQgb24gaG9zdCBDUjQuU01BUCB2YWx1ZSBhbmQgbm90IHZDUFUgQ1I0LlNN
QVAgdmFsdWUgYXMgS1ZNIGNvZGUgY2hlY2tzLg0KPj4+DQo+Pj4gRnVydGhlcm1vcmUsIHZDUFUg
Q1BMIG9mIGd1ZXN0IGRvZXNu4oCZdCBuZWVkIHRvIGJlIDMgaW4gb3JkZXIgdG8gdHJpZ2dlciB0
aGlzIEVycmF0YS4NCj4+DQo+PiBVbmRlciB0aGUgY29uZGl0aW9ucyBpbiB0aGUgY29kZSwgaWYg
Q1BMIHdlcmUgPDMgdGhlbiB0aGUgU01BUCBmYXVsdA0KPj4gd291bGQgaGF2ZSBiZWVuIHNlbnQg
dG8gdGhlIGd1ZXN0Lg0KPj4gQnV0IEkgYWdyZWUgdGhhdCBpZiB3ZSBuZWVkIHRvDQo+PiBjaGFu
Z2UgaXQgdG8gY2hlY2sgaG9zdCBDUjQsIHRoZW4gdGhlIENQTCBvZiB0aGUgZ3Vlc3Qgc2hvdWxk
IG5vdCBiZQ0KPj4gY2hlY2tlZC4NCj4gDQo+IFllcC4NCj4gV2VsbCBpdCBhbGwgZGVwZW5kcyBv
biBob3cgQU1EIENQVSBhY3R1YWxseSB3b3Jrcy4NCj4gV2UgbmVlZCBzb21lIGNsYXJpZmljYXRp
b24gZnJvbSBBTUQgYnV0IGZvciBzdXJlIHRoZSBjdXJyZW50IGNvZGUgaW4gS1ZNIGlzIG5vdCBv
bmx5IHdyb25nLCBidXQgcHJvYmFibHkgaGF2ZSBuZXZlciBiZWVuIHRlc3RlZC4gOlANCj4gDQo+
IExvb2tpbmcgZm9yIGZ1cnRoZXIgY2xhcmlmaWNhdGlvbnMgZnJvbSBBTUQgYmVmb3JlIHN1Ym1p
dHRpbmcgdjLigKYNCj4gDQoNCldoZW4gdGhpcyBlcnJhdGEgaXMgaGl0LCB0aGUgQ1BVIHdpbGwg
YmUgYXQgQ1BMMy4gRnJvbSBoYXJkd2FyZQ0KcG9pbnQtb2YtdmlldyB0aGUgYmVsb3cgc2VxdWVu
Y2UgaGFwcGVuczoNCg0KMS4gQ1BMMyBndWVzdCBoaXRzIHJlc2VydmVkIGJpdCBOUFQgZmF1bHQg
KE1NSU8gYWNjZXNzKQ0KDQoyLiBNaWNyb2NvZGUgdXNlcyBzcGVjaWFsIG9wY29kZSB3aGljaCBh
dHRlbXB0cyB0byByZWFkIGRhdGEgdXNpbmcgdGhlDQpDUEwwIHByaXZpbGVnZXMuIFRoZSBtaWNy
b2NvZGUgcmVhZCBDUzpSSVAsIHdoZW4gaXQgaGl0cyBTTUFQIGZhdWx0LA0KaXQgZ2l2ZXMgdXAg
YW5kIHJldHVybnMgbm8gaW5zdHJ1Y3Rpb24gYnl0ZXMuDQoNCihOb3RlOiB2Q1BVIGlzIHN0aWxs
IGF0IENQTDMpDQoNCjMuIENQVSBjYXVzZXMgI1ZNRVhJVCBmb3Igb3JpZ2luYWwgZmF1bHQgYWRk
cmVzcy4NCg0KVGhlIFNNQVAgZmF1bHQgb2NjdXJyZWQgd2hpbGUgd2UgYXJlIHN0aWxsIGluIGd1
ZXN0IGNvbnRleHQuIEl0IHdpbGwgYmUNCm5pY2UgdG8gaGF2ZSBjb2RlIHRlc3QgZXhhbXBsZSB0
byB0cmlnZ2VycyB0aGlzIGVycmF0YS4NCg0KPiAtTGlyYW4NCj4gDQo+Pg0KPj4gUGFvbG8NCj4+
DQo+Pj4gSXTigJlzIG9ubHkgaW1wb3J0YW50IHRoYXQgZ3Vlc3QgcGFnZS10YWJsZXMgbWFwcyB0
aGUgZ3Vlc3QgUklQIGFzIHVzZXItYWNjZXNzaWJsZS4gaS5lLiBVL1MgYml0IGluIFBURSBzZXQg
dG8gMS4NCj4+DQo+IA0K
