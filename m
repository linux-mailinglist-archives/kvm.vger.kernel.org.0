Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC6971BA0
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2019 17:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728833AbfGWPb1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jul 2019 11:31:27 -0400
Received: from mail-eopbgr780080.outbound.protection.outlook.com ([40.107.78.80]:36813
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726276AbfGWPb0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jul 2019 11:31:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JmAox/pz+NoveCnF1/T7mKotaKmwRRjDdhvDqXGuiwrsrT1UXvnfGT0GuzBXkYnxxcOdwohYmRDn5trPFLpRQ4W0zKz/b2PuZfmUNLqDsdD01ik/d31Bda0HDhAxE3MHCGvuuJ5rACuFisWyi0tdrHbxix7Z5xT+jZ2+c+4ZGPXjOknbO+LXkXsElt/mnRonX3hW3+kiyZ4Van4vHHZO8ASyl2Q13njpK062vDz9y5/R3HSuM3FjajMm4P/GS4xhX16OIX45hxB0At3ug8JIMo7Xe77uLgXR5TNd6T0Fiv+5S16iYZGW8YVt25d3I2XL/zV0l+4ZMvPK8dzyTCud8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hSrqbzMXJD2r6Qrpy7hI285S+0TlyTgqSRtU1axnqUg=;
 b=D119CHsny6qdnXp5kM2Seu05LXeT2sj+d67vNuIVM0+0CbackNL54RcjuLttXJBfYlYhanGCior9sf/ytrLMbiqyE7fArJhHTIidL/1mto4lcZFYRTfWK1ddVzmgoQNKE1PjDPFL7V92UdB15o5q+r4/iJpiEyIYsXEKAJyhVJlbHhzYjzDpjDeFktKLsStQPUt/01q156v4wFHFtrXSFyScBYYV11kTobyGFF0oGbF8w645sKQhkOOD7zHRNnQ9R9BEqxdocrmrgVHF7iImgLgMsYsBsLiX6xysEOyZj3z0rZ8pt+tE8KNsrcL9aM/OYr5bThrvFiaZONuPH8qPrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hSrqbzMXJD2r6Qrpy7hI285S+0TlyTgqSRtU1axnqUg=;
 b=vdLIBCwBnO5jxSUeC/nhKIlJ8Hj5xjyUHs0xFth9iEJYMa9e4Zhofg0pVsBGWTE65T7TK9ouGFQsMCp09oL0+dNHgw+SW/qPA8q5tesft8RPsfyg0/8MkHNfRRH6t4K0rbVWOnroLTt3Pvai9Om8DgzZK5c0eIdJidt7wVWdR8g=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.118.13) by
 DM6PR12MB2699.namprd12.prod.outlook.com (20.176.116.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Tue, 23 Jul 2019 15:31:20 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::7439:ea87:cc5d:71]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::7439:ea87:cc5d:71%7]) with mapi id 15.20.2094.017; Tue, 23 Jul 2019
 15:31:20 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     Cfir Cohen <cfir@google.com>, David Rientjes <rientjes@google.com>
CC:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 08/11] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
Thread-Topic: [PATCH v3 08/11] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
Thread-Index: AQHVN1vkr0vUgqY4y0eLnE4RKbM1dKbVnyeAgAFTcICAAXYJAA==
Date:   Tue, 23 Jul 2019 15:31:20 +0000
Message-ID: <4a1b0181-1843-1f10-a45d-8087b35d5885@amd.com>
References: <20190710201244.25195-1-brijesh.singh@amd.com>
 <20190710201244.25195-9-brijesh.singh@amd.com>
 <alpine.DEB.2.21.1907211354220.58367@chino.kir.corp.google.com>
 <CAEU=KTGRCWQH-XxmH+cwMHiXmq7px+qcNMr_6ByO=WvsOewQpA@mail.gmail.com>
In-Reply-To: <CAEU=KTGRCWQH-XxmH+cwMHiXmq7px+qcNMr_6ByO=WvsOewQpA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM5PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:3:7b::12) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:42::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d636bfbb-9cc6-4926-46d5-08d70f82cfd3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB2699;
x-ms-traffictypediagnostic: DM6PR12MB2699:
x-microsoft-antispam-prvs: <DM6PR12MB26996CA315773ED748B1213CE5C70@DM6PR12MB2699.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(136003)(366004)(346002)(39860400002)(199004)(189003)(36756003)(31696002)(6512007)(6246003)(8676002)(86362001)(64756008)(3846002)(66946007)(81166006)(53936002)(66556008)(11346002)(14444005)(2616005)(66446008)(6506007)(66066001)(81156014)(6436002)(2906002)(446003)(476003)(66476007)(6486002)(256004)(229853002)(386003)(6116002)(14454004)(7416002)(186003)(316002)(31686004)(4326008)(26005)(68736007)(25786009)(52116002)(54906003)(110136005)(8936002)(7736002)(99286004)(486006)(102836004)(71200400001)(76176011)(53546011)(71190400001)(5660300002)(478600001)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2699;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lPGUkF/S3+3IexG0U4vp/ok5G+j+8fd+xFVuwQmLEnun4FMRyrz1ediXV+rPCPcmxqLIplA98J+gUQX17czAOqIuWSg/EnJpqyobFPc8ZUzDBBpFkmts7ff+2fuI978LlyS1iInCBdmTB+NLTeyGsGeKkpGLpco54ftI6QqQAB+g32eCshavOyzagVnIKNmGVrBOALpKg01nVL1Fao0FOYs1wSb9NYlsBxa1+8I0Bst4JMofTloWHv7Wx3bbfFSrZm86w+vmRW8k+7MWTYZFdMqjRwxB3ly8x6qShUmxREdlG4t1dmZSRX/XkW2wUorps/A1z/uRiPFmMjUPbNwS+zlA5yMTdDFJO9kQBnFnE4qLWfD5bvJh5RFg5+QVjYIFcwCujB+EIkVqwIkqFO6xaa2VjpmnQGKC9TJ8RhPg7j4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E8AEF74D3621746B77BA94D921E3198@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d636bfbb-9cc6-4926-46d5-08d70f82cfd3
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 15:31:20.4548
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sbrijesh@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2699
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCk9uIDcvMjIvMTkgMTI6MTIgUE0sIENmaXIgQ29oZW4gd3JvdGU6DQo+IEluIGFkZGl0aW9u
LCBpdCBzZWVtcyB0aGF0IHN2bV9wYWdlX2VuY19zdGF0dXNfaGMoKSBhY2NlcHRzICdncGEnLA0K
PiAnbnBhZ2VzJywgJ2VuYycgZGlyZWN0bHkgZnJvbSB0aGUgZ3Vlc3QsIGFuZCBzbyB0aGVzZSBj
YW4gdGFrZQ0KPiBhcmJpdHJhcnkgdmFsdWVzLiBBIHZlcnkgbGFyZ2UgJ25wYWdlcycgY291bGQg
bGVhZCB0byBhbiBpbnQgb3ZlcmZsb3cNCj4gaW4gJ2dmbl9lbmQgPSBnZm5fc3RhcnQgKyBucGFn
ZXMnLCBtYWtpbmcgZ2ZuX2VuZCA8IGdmbl9zdGFydC4gVGhpcw0KPiBjb3VsZCBhbiBPT0IgYWNj
ZXNzIGluIHRoZSBiaXRtYXAuIENvbmNyZXRlIGV4YW1wbGU6IGdmbl9zdGFydCA9IDIsDQo+IG5w
YWdlcyA9IC0xLCBnZm5fZW5kID0gMisoLTEpID0gMSwgc2V2X3Jlc2l6ZV9wYWdlX2VuY19iaXRt
YXANCj4gYWxsb2NhdGVzIGEgYml0bWFwIGZvciBhIHNpbmdsZSBwYWdlIChuZXdfc2l6ZT0xKSwg
X19iaXRtYXBfc2V0IGFjY2Vzcw0KPiBvZmZzZXQgZ2ZuX2VuZCAtIGdmbl9zdGFydCA9IC0xLg0K
PiANCg0KR29vZCBwb2ludC4gSSB3aWxsIGFkZCBhIGNoZWNrIGZvciBpdCwgc29tZXRoaW5nIGxp
a2UNCg0KaWYgKGdmbl9lbmQgPD0gZ2ZuX3N0YXJ0KQ0KCXJldHVybiAtRUlOVkFMOw0KDQoNCj4g
DQo+IE9uIFN1biwgSnVsIDIxLCAyMDE5IGF0IDE6NTcgUE0gRGF2aWQgUmllbnRqZXMgPHJpZW50
amVzQGdvb2dsZS5jb20+IHdyb3RlOg0KPj4NCj4+IE9uIFdlZCwgMTAgSnVsIDIwMTksIFNpbmdo
LCBCcmlqZXNoIHdyb3RlOg0KPj4NCj4+PiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi92aXJ0
dWFsL2t2bS9oeXBlcmNhbGxzLnR4dCBiL0RvY3VtZW50YXRpb24vdmlydHVhbC9rdm0vaHlwZXJj
YWxscy50eHQNCj4+PiBpbmRleCBkYTI0YzEzOGM4ZDEuLjk0ZjA2MTFmNGQ4OCAxMDA2NDQNCj4+
PiAtLS0gYS9Eb2N1bWVudGF0aW9uL3ZpcnR1YWwva3ZtL2h5cGVyY2FsbHMudHh0DQo+Pj4gKysr
IGIvRG9jdW1lbnRhdGlvbi92aXJ0dWFsL2t2bS9oeXBlcmNhbGxzLnR4dA0KPj4+IEBAIC0xNDEs
MyArMTQxLDE3IEBAIGEwIGNvcnJlc3BvbmRzIHRvIHRoZSBBUElDIElEIGluIHRoZSB0aGlyZCBh
cmd1bWVudCAoYTIpLCBiaXQgMQ0KPj4+ICAgY29ycmVzcG9uZHMgdG8gdGhlIEFQSUMgSUQgYTIr
MSwgYW5kIHNvIG9uLg0KPj4+DQo+Pj4gICBSZXR1cm5zIHRoZSBudW1iZXIgb2YgQ1BVcyB0byB3
aGljaCB0aGUgSVBJcyB3ZXJlIGRlbGl2ZXJlZCBzdWNjZXNzZnVsbHkuDQo+Pj4gKw0KPj4+ICs3
LiBLVk1fSENfUEFHRV9FTkNfU1RBVFVTDQo+Pj4gKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0N
Cj4+PiArQXJjaGl0ZWN0dXJlOiB4ODYNCj4+PiArU3RhdHVzOiBhY3RpdmUNCj4+PiArUHVycG9z
ZTogTm90aWZ5IHRoZSBlbmNyeXB0aW9uIHN0YXR1cyBjaGFuZ2VzIGluIGd1ZXN0IHBhZ2UgdGFi
bGUgKFNFViBndWVzdCkNCj4+PiArDQo+Pj4gK2EwOiB0aGUgZ3Vlc3QgcGh5c2ljYWwgYWRkcmVz
cyBvZiB0aGUgc3RhcnQgcGFnZQ0KPj4+ICthMTogdGhlIG51bWJlciBvZiBwYWdlcw0KPj4+ICth
MjogZW5jcnlwdGlvbiBhdHRyaWJ1dGUNCj4+PiArDQo+Pj4gKyAgIFdoZXJlOg0KPj4+ICsgICAg
ICogMTogRW5jcnlwdGlvbiBhdHRyaWJ1dGUgaXMgc2V0DQo+Pj4gKyAgICAgKiAwOiBFbmNyeXB0
aW9uIGF0dHJpYnV0ZSBpcyBjbGVhcmVkDQo+Pj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1
ZGUvYXNtL2t2bV9ob3N0LmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oDQo+Pj4g
aW5kZXggMjZkMWViODNmNzJhLi5iNDYzYTgxZGMxNzYgMTAwNjQ0DQo+Pj4gLS0tIGEvYXJjaC94
ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0KPj4+ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNt
L2t2bV9ob3N0LmgNCj4+PiBAQCAtMTE5OSw2ICsxMTk5LDggQEAgc3RydWN0IGt2bV94ODZfb3Bz
IHsNCj4+PiAgICAgICAgdWludDE2X3QgKCpuZXN0ZWRfZ2V0X2V2bWNzX3ZlcnNpb24pKHN0cnVj
dCBrdm1fdmNwdSAqdmNwdSk7DQo+Pj4NCj4+PiAgICAgICAgYm9vbCAoKm5lZWRfZW11bGF0aW9u
X29uX3BhZ2VfZmF1bHQpKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7DQo+Pj4gKyAgICAgaW50ICgq
cGFnZV9lbmNfc3RhdHVzX2hjKShzdHJ1Y3Qga3ZtICprdm0sIHVuc2lnbmVkIGxvbmcgZ3BhLA0K
Pj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdW5zaWduZWQgbG9uZyBzeiwgdW5z
aWduZWQgbG9uZyBtb2RlKTsNCj4+PiAgIH07DQo+Pj4NCj4+PiAgIHN0cnVjdCBrdm1fYXJjaF9h
c3luY19wZiB7DQo+Pj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9zdm0uYyBiL2FyY2gveDg2
L2t2bS9zdm0uYw0KPj4+IGluZGV4IDMwODk5NDJmNjYzMC4uNDMxNzE4MzA5MzU5IDEwMDY0NA0K
Pj4+IC0tLSBhL2FyY2gveDg2L2t2bS9zdm0uYw0KPj4+ICsrKyBiL2FyY2gveDg2L2t2bS9zdm0u
Yw0KPj4+IEBAIC0xMzUsNiArMTM1LDggQEAgc3RydWN0IGt2bV9zZXZfaW5mbyB7DQo+Pj4gICAg
ICAgIGludCBmZDsgICAgICAgICAgICAgICAgIC8qIFNFViBkZXZpY2UgZmQgKi8NCj4+PiAgICAg
ICAgdW5zaWduZWQgbG9uZyBwYWdlc19sb2NrZWQ7IC8qIE51bWJlciBvZiBwYWdlcyBsb2NrZWQg
Ki8NCj4+PiAgICAgICAgc3RydWN0IGxpc3RfaGVhZCByZWdpb25zX2xpc3Q7ICAvKiBMaXN0IG9m
IHJlZ2lzdGVyZWQgcmVnaW9ucyAqLw0KPj4+ICsgICAgIHVuc2lnbmVkIGxvbmcgKnBhZ2VfZW5j
X2JtYXA7DQo+Pj4gKyAgICAgdW5zaWduZWQgbG9uZyBwYWdlX2VuY19ibWFwX3NpemU7DQo+Pj4g
ICB9Ow0KPj4+DQo+Pj4gICBzdHJ1Y3Qga3ZtX3N2bSB7DQo+Pj4gQEAgLTE5MTAsNiArMTkxMiw4
IEBAIHN0YXRpYyB2b2lkIHNldl92bV9kZXN0cm95KHN0cnVjdCBrdm0gKmt2bSkNCj4+Pg0KPj4+
ICAgICAgICBzZXZfdW5iaW5kX2FzaWQoa3ZtLCBzZXYtPmhhbmRsZSk7DQo+Pj4gICAgICAgIHNl
dl9hc2lkX2ZyZWUoa3ZtKTsNCj4+PiArDQo+Pj4gKyAgICAga3ZmcmVlKHNldi0+cGFnZV9lbmNf
Ym1hcCk7DQo+Pj4gICB9DQo+Pj4NCj4+PiAgIHN0YXRpYyB2b2lkIGF2aWNfdm1fZGVzdHJveShz
dHJ1Y3Qga3ZtICprdm0pDQo+Pg0KPj4gQWRkaW5nIENmaXIgd2hvIGZsYWdnZWQgdGhpcyBrdmZy
ZWUoKS4NCj4+DQo+PiBPdGhlciBmcmVlaW5nIG9mIHNldi0+cGFnZV9lbmNfYm1hcCBpbiB0aGlz
IHBhdGNoIGFsc28gc2V0DQo+PiBzZXYtPnBhZ2VfZW5jX2JtYXBfc2l6ZSB0byAwIGFuZCBuZWl0
aGVyIHNldCBzZXYtPnBhZ2VfZW5jX2JtYXAgdG8gTlVMTA0KPj4gYWZ0ZXIgZnJlZWluZyBpdC4N
Cj4+DQo+PiBGb3IgZXh0cmEgc2FmZXR5LCBpcyBpdCBwb3NzaWJsZSB0byBzZXYtPnBhZ2VfZW5j
X2JtYXAgPSBOVUxMIGFueXRpbWUgdGhlDQo+PiBiaXRtYXAgaXMga3ZmcmVlZD8NCj4+DQo+Pj4g
QEAgLTIwODQsNiArMjA4OCw3IEBAIHN0YXRpYyB2b2lkIGF2aWNfc2V0X3J1bm5pbmcoc3RydWN0
IGt2bV92Y3B1ICp2Y3B1LCBib29sIGlzX3J1bikNCj4+Pg0KPj4+ICAgc3RhdGljIHZvaWQgc3Zt
X3ZjcHVfcmVzZXQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBib29sIGluaXRfZXZlbnQpDQo+Pj4g
ICB7DQo+Pj4gKyAgICAgc3RydWN0IGt2bV9zZXZfaW5mbyAqc2V2ID0gJnRvX2t2bV9zdm0odmNw
dS0+a3ZtKS0+c2V2X2luZm87DQo+Pj4gICAgICAgIHN0cnVjdCB2Y3B1X3N2bSAqc3ZtID0gdG9f
c3ZtKHZjcHUpOw0KPj4+ICAgICAgICB1MzIgZHVtbXk7DQo+Pj4gICAgICAgIHUzMiBlYXggPSAx
Ow0KPj4+IEBAIC0yMTA1LDYgKzIxMTAsMTIgQEAgc3RhdGljIHZvaWQgc3ZtX3ZjcHVfcmVzZXQo
c3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBib29sIGluaXRfZXZlbnQpDQo+Pj4NCj4+PiAgICAgICAg
aWYgKGt2bV92Y3B1X2FwaWN2X2FjdGl2ZSh2Y3B1KSAmJiAhaW5pdF9ldmVudCkNCj4+PiAgICAg
ICAgICAgICAgICBhdmljX3VwZGF0ZV92YXBpY19iYXIoc3ZtLCBBUElDX0RFRkFVTFRfUEhZU19C
QVNFKTsNCj4+PiArDQo+Pj4gKyAgICAgLyogcmVzZXQgdGhlIHBhZ2UgZW5jcnlwdGlvbiBiaXRt
YXAgKi8NCj4+PiArICAgICBpZiAoc2V2X2d1ZXN0KHZjcHUtPmt2bSkpIHsNCj4+PiArICAgICAg
ICAgICAgIGt2ZnJlZShzZXYtPnBhZ2VfZW5jX2JtYXApOw0KPj4+ICsgICAgICAgICAgICAgc2V2
LT5wYWdlX2VuY19ibWFwX3NpemUgPSAwOw0KPj4+ICsgICAgIH0NCj4+PiAgIH0NCj4+Pg0KPj4+
ICAgc3RhdGljIGludCBhdmljX2luaXRfdmNwdShzdHJ1Y3QgdmNwdV9zdm0gKnN2bSkNCj4+DQo+
PiBXaGF0IGlzIHByb3RlY3Rpbmcgc2V2LT5wYWdlX2VuY19ibWFwIGFuZCBzZXYtPnBhZ2VfZW5j
X2JtYXBfc2l6ZSBpbiBjYWxscw0KPj4gdG8gc3ZtX3ZjcHVfcmVzZXQoKT8NCg==
