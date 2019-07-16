Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8BF06AE20
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 20:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbfGPSFc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 14:05:32 -0400
Received: from mail-eopbgr700042.outbound.protection.outlook.com ([40.107.70.42]:10656
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728137AbfGPSFb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 14:05:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aLOCTFNzmkZqtrQehInYkcwLICkjVG6zLx6G5mr0Pi91mFyqLSrAUUgV38/TzWFLsoW8SQ204J9Y8VIelO06rqrrxXZUXLyYdgjFWXK6PdYByiTzWwVxQs4ZMd2JIzKlU22xCjYGwFicsF2GZJli9T25txcCQ9AbUj3+YiH2o9yimSDKioqmLfioOT/bt8wPDRK6xlh/t8HGTdk0hVyjaU/JL/3s1xe3fTcj1Wtjup/2s3Cp07XPwL41oxB0Z0u31rJF1SLZNngKVOFLlYyWuB/BOlZzITLbRWtpMGrICSqc3BDhmzG3pBWIMSHLzI+RsI5pTM2vVvadT6w+9L/MJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AIqNFGcK9KsskJoyJnV/BunluS9NOhVurW9S8yF+3Z8=;
 b=JF34Q9SRfglBcsqHhoJpHvBV2XNXzuFKm2kxegTQyK2ZL0GEbEX1HumjOp1rmcMdiRcUJkiwiiDZ7pFCFm13Dte9WONtsE7GcriQNfWERJnQgBVxdTMFxTSYtxVJKZPfW6iP3hEuzhDjzC/nAqJUB90e9HoPHn2HbQ33jHMeSUSKFTnF7DU+w2SKGn3pq1s18m1e5OVKMmLseU2KtyiMFOiIk2DPIkSGE1fG9Ihz37pzIsa1ADw6Oo4nA6DYtbv5eScxa2Zuw6KsfE2bTaTCRg3bkA0xUqIlbayRuN6h+IF3trOSxznnKPoANLES7bdV29m7UtB+ZOw1FfzErp5afA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AIqNFGcK9KsskJoyJnV/BunluS9NOhVurW9S8yF+3Z8=;
 b=aEjfHxgJKrnZJpuETO8B+8euXGxp/wXdwzVRO3G3AWoKUrrmT88+0H1hc0JkIqeFjF/z7M7GQ2Ng1afkbXDNGKB1peYMyEWjvPh04d9zqn7jh9f5EAzFQgRepmJMf4ytXCsxbuwqdc2/Cam3mPOophIp8UgvaLYPz0eikQrQFAk=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.118.13) by
 DM6PR12MB3274.namprd12.prod.outlook.com (20.179.106.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Tue, 16 Jul 2019 18:05:28 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::7439:ea87:cc5d:71]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::7439:ea87:cc5d:71%7]) with mapi id 15.20.2073.012; Tue, 16 Jul 2019
 18:05:28 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     Liran Alon <liran.alon@oracle.com>
CC:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 1/2] KVM: SVM: Fix workaround for AMD Errata 1096
Thread-Topic: [PATCH 1/2] KVM: SVM: Fix workaround for AMD Errata 1096
Thread-Index: AQHVO0w5JJR7Enn+ZEGfnHG07AdKnabMIb8AgAFDlACAAAIYgIAAA+gAgAAC6ACAAB1DAA==
Date:   Tue, 16 Jul 2019 18:05:27 +0000
Message-ID: <91eade26-e5cc-4841-e891-7aaa309471bc@amd.com>
References: <20190715203043.100483-1-liran.alon@oracle.com>
 <20190715203043.100483-2-liran.alon@oracle.com>
 <1ef0f594-2039-1aeb-4fe0-edbc21fa1f60@amd.com>
 <CF48BCA4-4BC8-4AC8-8B48-85FA29E16719@oracle.com>
 <f6c78d65-70fc-4a79-44db-6abb0434db73@amd.com>
 <F2442A5C-702A-433D-9156-056E1844F378@oracle.com>
In-Reply-To: <F2442A5C-702A-433D-9156-056E1844F378@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0501CA0092.namprd05.prod.outlook.com
 (2603:10b6:803:22::30) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:42::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 67a6705f-dbf1-49b9-eaa7-08d70a182ed1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3274;
x-ms-traffictypediagnostic: DM6PR12MB3274:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <DM6PR12MB32745165725173B2EA0B9A83E5CE0@DM6PR12MB3274.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0100732B76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(39860400002)(136003)(396003)(366004)(199004)(189003)(2616005)(31696002)(26005)(54906003)(53936002)(8676002)(25786009)(5660300002)(66066001)(229853002)(71190400001)(71200400001)(6506007)(81166006)(36756003)(386003)(86362001)(76176011)(11346002)(316002)(186003)(102836004)(6436002)(53546011)(6246003)(2906002)(68736007)(966005)(64756008)(8936002)(256004)(14444005)(6512007)(6916009)(66476007)(66556008)(66946007)(99286004)(476003)(14454004)(6306002)(66446008)(31686004)(446003)(52116002)(81156014)(6116002)(305945005)(7736002)(478600001)(4326008)(3846002)(486006)(6486002)(6606295002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3274;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MMnNgNgHDCbSsCo8z1290y2/RIfYb+ujVIrC0wvRqd6qEh0mOjFdtt2QDMHmh2Jmdsf6u4qky3M3kX2x+Uv3MTrKNHZkmUfwuHOHQhYVrT8uY5KgXO19HsUnrTsDqn1KX9PNQfSBVO3DjyGH1TiP9t0dPMwHBksk78n6/DtNJ+Ui0gK1IWMl4VLp3hW89y5CZlyC4OgLwwqILqhSkKO6ly2iSJmjsKM6bTH2wp3idb6F5ckiUTZ2u6x2CS4fTj2mRLmT5sNh/l1Gdr1CJ0efXcCzFD5vup5LB8n2suENn40kIW5ZI6quqMUgzpMcbHGyJkSRq9iZdrEeTVPBej92/61mkgRUsY9pRSJt3ioGf46AecfoKeJGcLnRyKSbhaMqsqbv3ydjgGrytFuEu4ENXO7VCuV2M89D0zy3NY86+RI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CE0EA0CD28312547B92F3A0029BEB5B6@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67a6705f-dbf1-49b9-eaa7-08d70a182ed1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2019 18:05:28.0624
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sbrijesh@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3274
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGVyZSBpcyBhIHRocmVhZC4uIGJ1dCBtb3JlIHJlY2VudCBpcyBhdmFpbGFibGUNCg0KaHR0cHM6
Ly9tYXJjLmluZm8vP3Q9MTU2MzIyMjgzMzAwMDAxJnI9MSZ3PTINCg0KUGFvbG8sIFNlYW4gYW5k
IG90aGVycyBoYXZlIGFsc28gcmVwbGllZCB0byBpdCB3aGljaCB5b3UgY2FuIHNlZSBvbiANCm1h
cmMuaW5mby4NCg0KLUJyaWplc2gNCg0KT24gNy8xNi8xOSAxMToyMCBBTSwgTGlyYW4gQWxvbiB3
cm90ZToNCj4gDQo+IA0KPj4gT24gMTYgSnVsIDIwMTksIGF0IDE5OjEwLCBTaW5naCwgQnJpamVz
aCA8YnJpamVzaC5zaW5naEBhbWQuY29tPiB3cm90ZToNCj4+DQo+Pg0KPj4NCj4+IE9uIDcvMTYv
MTkgMTA6NTYgQU0sIExpcmFuIEFsb24gd3JvdGU6DQo+Pj4NCj4+Pg0KPj4+PiBPbiAxNiBKdWwg
MjAxOSwgYXQgMTg6NDgsIFNpbmdoLCBCcmlqZXNoIDxicmlqZXNoLnNpbmdoQGFtZC5jb20+IHdy
b3RlOg0KPj4+Pg0KPj4+PiBPbiA3LzE1LzE5IDM6MzAgUE0sIExpcmFuIEFsb24gd3JvdGU6DQo+
Pj4+PiBBY2NvcmRpbmcgdG8gQU1EIEVycmF0YSAxMDk2Og0KPj4+Pj4gIk9uIGEgbmVzdGVkIGRh
dGEgcGFnZSBmYXVsdCB3aGVuIENSNC5TTUFQID0gMSBhbmQgdGhlIGd1ZXN0IGRhdGEgcmVhZCBn
ZW5lcmF0ZXMgYSBTTUFQIHZpb2xhdGlvbiwgdGhlDQo+Pj4+PiBHdWVzdEluc3RyQnl0ZXMgZmll
bGQgb2YgdGhlIFZNQ0Igb24gYSBWTUVYSVQgd2lsbCBpbmNvcnJlY3RseSByZXR1cm4gMGggaW5z
dGVhZCB0aGUgY29ycmVjdCBndWVzdCBpbnN0cnVjdGlvbg0KPj4+Pj4gYnl0ZXMuIg0KPj4+Pj4N
Cj4+Pj4+IEFzIHN0YXRlZCBhYm92ZSwgZXJyYXRhIGlzIGVuY291bnRlcmVkIHdoZW4gZ3Vlc3Qg
cmVhZCBnZW5lcmF0ZXMgYSBTTUFQIHZpb2xhdGlvbi4gaS5lLiB2Q1BVIHJ1bnMNCj4+Pj4+IHdp
dGggQ1BMPDMgYW5kIENSNC5TTUFQPTEuIEhvd2V2ZXIsIGNvZGUgaGF2ZSBtaXN0YWtlbmx5IGNo
ZWNrZWQgaWYgQ1BMPT0zIGFuZCBDUjQuU01BUD09MC4NCj4+Pj4+DQo+Pj4+DQo+Pj4+IFRoZSBT
TUFQIHZpb2xhdGlvbiB3aWxsIG9jY3VyIGZyb20gQ1BMMyBzbyBDUEw9PTMgaXMgYSB2YWxpZCBj
aGVjay4NCj4+Pj4NCj4+Pj4gU2VlIFsxXSBmb3IgY29tcGxldGUgZGlzY3Vzc2lvbg0KPj4+Pg0K
Pj4+PiBodHRwczovL3VybGRlZmVuc2UucHJvb2Zwb2ludC5jb20vdjIvdXJsP3U9aHR0cHMtM0Ff
X3BhdGNod29yay5rZXJuZWwub3JnX3BhdGNoXzEwODA4MDc1Xy0yMzIyNDc5MjcxJmQ9RHdJR2FR
JmM9Um9QMVl1bUNYQ2dhV0h2bFpZUjhQWmg4QnY3cUlyTVVCNjVlYXBJX0puRSZyPUprNlE4bk56
a1E2TEo2ZzQycUFSa2c2cnlJREdRci15S1hQTkdaYnBUeDAmbT1SQXQ4dDhuQmFDeFVQeTVPVERr
TzBuOEJNUTVsOW9TZkxNaUwwVExUdTZjJnM9Tmt3ZThyVEpoeWdCQ0lQejI3TFhyeWxwdGpuV3lN
d0ItbkphaW93V3BXYyZlPQ0KPj4+DQo+Pj4gSSBzdGlsbCBkb27igJl0IHVuZGVyc3RhbmQuIFNN
QVAgaXMgYSBtZWNoYW5pc20gd2hpY2ggaXMgbWVhbnQgdG8gcHJvdGVjdCBhIENQVSBydW5uaW5n
IGluIENQTDwzIGZyb20gbWlzdGFrZW5seSByZWZlcmVuY2luZyBkYXRhIGNvbnRyb2xsYWJsZSBi
eSBDUEw9PTMuDQo+Pj4gVGhlcmVmb3JlLCBTTUFQIHZpb2xhdGlvbiBzaG91bGQgYmUgcmFpc2Vk
IHdoZW4gQ1BMPDMgYW5kIGRhdGEgcmVmZXJlbmNlZCBpcyBtYXBwZWQgaW4gcGFnZS10YWJsZXMg
d2l0aCBQVEUgd2l0aCBVL1MgYml0IHNldCB0byAxLiAoaS5lLiBVc2VyIGFjY2Vzc2libGUpLg0K
Pj4+DQo+Pj4gVGh1cywgd2Ugc2hvdWxkIGNoZWNrIGlmIENQTDwzIGFuZCBDUjQuU01BUD09MS4N
Cj4+Pg0KPj4NCj4+IEluIHRoaXMgcGFydGljdWxhciBjYXNlIHdlIGFyZSBkZWFsaW5nIHdpdGgg
TlBGIGFuZCBub3QgU01BUCBmYXVsdCBwZXINCj4+IHNheS4NCj4+DQo+PiBXaGF0IHR5cGljYWxs
eSBoYXMgaGFwcGVuZWQgaGVyZSBpczoNCj4+DQo+PiAtIHVzZXIgc3BhY2UgZG9lcyB0aGUgTU1J
TyBhY2Nlc3Mgd2hpY2ggY2F1c2VzIGEgZmF1bHQNCj4+IC0gaGFyZHdhcmUgcHJvY2Vzc2VzIHRo
aXMgYXMgYSBWTUVYSVQNCj4+IC0gZHVyaW5nIHByb2Nlc3NpbmcsIGhhcmR3YXJlIGF0dGVtcHRz
IHRvIHJlYWQgdGhlIGluc3RydWN0aW9uIGJ5dGVzIHRvDQo+PiBwcm92aWRlIGRlY29kZSBhc3Np
c3QuIFRoaXMgaXMgdHlwaWNhbGx5IGRvbmUgYnkgZGF0YSByZWFkIHJlcXVlc3QgZnJvbQ0KPj4g
dGhlIFJJUCB0aGF0IHRoZSBndWVzdCB3YXMgYXQuIFdoaWxlIGRvaW5nIHNvLCB3ZSBtYXkgaGl0
IFNNQVAgZmF1bHQNCj4gDQo+IEhvdyBjYW4gYSBTTUFQIGZhdWx0IG9jY3VyIHdoZW4gQ1BMPT0z
PyBPbmUgb2YgdGhlIGNvbmRpdGlvbnMgZm9yIFNNQVAgaXMgdGhhdCBDUEw8My4NCj4gDQo+IEkg
dGhpbmsgdGhlIGNvbmZ1c2lvbiBpcyB0aGF0IEkgYmVsaWV2ZSBhIGNvZGUgbWFwcGVkIGFzIHVz
ZXItYWNjZXNzaWJsZSBpbiBwYWdlLXRhYmxlcyBidXQgcnVucyB3aXRoIENQTDwzDQo+IHNob3Vs
ZCBiZSB0aGUgb25lIHdoaWNoIGRvZXMgdGhlIE1NSU8uIFJhdGhlciB0aGVuIGNvZGUgcnVubmlu
ZyBpbiBDUEw9PTMuDQo+IA0KPiBUaGUgc2VxdWVuY2Ugb2YgZXZlbnRzIEkgaW1hZ2luZSB0byB0
cmlnZ2VyIHRoZSBFcnJhdGEgaXMgYXMgZm9sbG93czoNCj4gMSkgR3Vlc3QgbWFwcyBjb2RlIGlu
IHBhZ2UtdGFibGVzIGFzIHVzZXItYWNjZXNzaWJsZSAoaS5lLiBQVEUgd2l0aCBVL1MgYml0IHNl
dCB0byAxKS4NCj4gMikgR3Vlc3QgZXhlY3V0ZXMgdGhpcyBjb2RlIHdpdGggQ1BMPDMgKGV2ZW4g
dGhvdWdoIG1hcHBlZCBhcyB1c2VyLWFjY2Vzc2libGUgd2hpY2ggaXMgYSBzZWN1cml0eSB2dWxu
ZXJhYmlsaXR5IGluIGl0c2VsZuKApikgd2hpY2ggYWNjZXNzIGRhdGEgdGhhdCBpcyBub3QgbWFw
cGVkIG9yIG1hcmtlZCBhcyByZXNlcnZlZCBpbiBOUFQgYW5kIHRoZXJlZm9yZSBjYXVzZSAjTlBG
Lg0KPiAzKSBQaHlzaWNhbCBDUFUgRGVjb2RlQXNzaXN0IGZlYXR1cmUgYXR0ZW1wdHMgdG8gZmls
bC1pbiBndWVzdCBpbnN0cnVjdGlvbiBieXRlcy4gU28gaXQgcmVhZHMgYXMgZGF0YSB0aGUgZ3Vl
c3QgaW5zdHJ1Y3Rpb25zIHdoaWxlIENQVSBpcyBjdXJyZW50bHkgd2l0aCBDUEw8MywgQ1I0LlNN
QVA9MSBhbmQgY29kZSBpcyBtYXBwZWQgYXMgdXNlci1hY2Nlc3NpYmxlLiBUaGVyZWZvcmUsIHRo
aXMgZmlsbC1pbiByYWlzZSBhIFNNQVAgdmlvbGF0aW9uIHdoaWNoIGNhdXNlICNOUEYgdG8gYmUg
cmFpc2VkIHRvIEtWTSB3aXRoIDAgaW5zdHJ1Y3Rpb24gYnl0ZXMuDQo+IA0KPiBCVFcsIHRoaXMg
YWxzbyBtZWFucyB0aGF0IGluIG9yZGVyIHRvIHRyaWdnZXIgdGhpcywgQ1I0LlNNRVAgc2hvdWxk
IGJlIHNldCB0byAwLiBBcyBvdGhlcndpc2UsIGluc3RydWN0aW9uIGNvdWxkbuKAmXQgaGF2ZSBi
ZWVuIGV4ZWN1dGVkIHRvIHJhaXNlICNOUEYgaW4gdGhlIGZpcnN0IHBsYWNlLiBNYXliZSB3ZSBj
YW4gYWRkIHRoaXMgYXMgYW5vdGhlciBjb25kaXRpb24gdG8gcmVjb2duaXNlIHRoZSBFcnJhdGE/
DQo+IA0KPiAtTGlyYW4NCj4gDQo+PiBiZWNhdXNlIGludGVybmFsbHkgQ1BVIGlzIGRvaW5nIGEg
ZGF0YSByZWFkIGZyb20gdGhlIFJJUCB0byBnZXQgdGhvc2UNCj4+IGluc3RydWN0aW9uIGJ5dGVz
LiBTaW5jZSBpdCBoaXQgdGhlIFNNQVAgZmF1bHQgaGVuY2UgaXQgd2FzIG5vdCBhYmxlDQo+PiB0
byBkZWNvZGUgdGhlIGluc3RydWN0aW9uIHRvIHByb3ZpZGUgdGhlIGluc25fbGVuLiBTbyB3ZSBh
cmUgZmlyc3QNCj4+IGNoZWNraW5nIGlmIGl0IHdhcyBhIGZhdWx0IGNhdXNlZCBmcm9tIENQTD09
MyBhbmQgU01BUCBpcyBlbmFibGVkLg0KPj4gSWYgc28sIHdlIGFyZSBoaXR0aW5nIHRoaXMgZXJy
YXRhIGFuZCBpdCBjYW4gYmUgd29ya2Fyb3VuZC4NCj4+DQo+PiAtQnJpamVzaA0KPj4NCj4+DQo+
Pg0KPiANCg==
