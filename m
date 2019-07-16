Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4A566AE25
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 20:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388184AbfGPSG4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 14:06:56 -0400
Received: from mail-eopbgr700073.outbound.protection.outlook.com ([40.107.70.73]:41468
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387949AbfGPSGz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 14:06:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mo6XEpacYINSsotmmxvPefgsxB4B5CXpvgCsIVYoyC3SDZbJ3lFIJGcyYEUd86Y1+TeKiFtOaHPNJHxPskMiLiuch/5/6QwBrvPdCoEmt9asjIv14pHRY19aQstT6rhbll2gFewDViqww99CxcdpZPpp1HH09XP8NgJSM7Nc91sdj2UbObxUpe6ehzMDkPOCvz+nINmu4EwxCkgws4w7wwJby6O6OXPJrWwjBKqpkresIOCTYZjswkCRNyclTbwrEAzJjAPgqWHkiyWS4YokFDAf/T1D34IGfhTe0cjj/76H7y7KvgI7tleZuBsKxKGHeFdNnE0RUrvdUKMSGyH66A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t+mdZjMhzdoqjPagCz+mhDbCr90uI8D3UxtzVEhKSAQ=;
 b=Y0GMY4XxKf2zqeITZY+C2PJqK/GwFc2Qg+R3MXaZYlYQ2FR8pdirTjtqtc42NEYes8Y34CiDjeZIu12viuhk7gSMy3QVQB8bHZHwsrFeO/19Dx9msmOB0JBEXA6OfNFWdDzLt1CxWq9BE2i18OKtbQ45AnQSOJMp4EjpN1sAMckzdNWMz7SlD9XwTsIiXbgybg8BLcztAYuXyurOeseiLdCNd84/kqGWHgbtTwBazW8z+s5Uu41lRDvB4pYZtHw6CUu4lWo/fTQ6X1YVKXn7w5RpR9mQoXVMybwtFOvIA/ggqgD0B7xgunnkM6mt4yH3gI+WOGR05MMFiv0ZK1GFhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t+mdZjMhzdoqjPagCz+mhDbCr90uI8D3UxtzVEhKSAQ=;
 b=ediuyzVm2M/WuF40A2IAg8jlodLT0wfwFaxwQLKm+v4prOQVWKXMUSTQulss347/TJexVoDdfDVYcRmZ6WUkB93aH1OPj9ZFCTtp18Spy+7fVoofFgyMr1WS8Q2OkDJPXlyBThG5jMHmcsDQ7b4ThpmtHKWLu+A9H6zBRmyCESA=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.118.13) by
 DM6PR12MB3274.namprd12.prod.outlook.com (20.179.106.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Tue, 16 Jul 2019 18:06:52 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::7439:ea87:cc5d:71]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::7439:ea87:cc5d:71%7]) with mapi id 15.20.2073.012; Tue, 16 Jul 2019
 18:06:52 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     Liran Alon <liran.alon@oracle.com>
CC:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 1/2] KVM: SVM: Fix workaround for AMD Errata 1096
Thread-Topic: [PATCH 1/2] KVM: SVM: Fix workaround for AMD Errata 1096
Thread-Index: AQHVO0w5JJR7Enn+ZEGfnHG07AdKnabMIb8AgAFDlACAAAIYgIAAA+gAgAAC6ACAAB1DAIAAAGEA
Date:   Tue, 16 Jul 2019 18:06:51 +0000
Message-ID: <70251139-76ac-780c-08c1-91c9e5c94432@amd.com>
References: <20190715203043.100483-1-liran.alon@oracle.com>
 <20190715203043.100483-2-liran.alon@oracle.com>
 <1ef0f594-2039-1aeb-4fe0-edbc21fa1f60@amd.com>
 <CF48BCA4-4BC8-4AC8-8B48-85FA29E16719@oracle.com>
 <f6c78d65-70fc-4a79-44db-6abb0434db73@amd.com>
 <F2442A5C-702A-433D-9156-056E1844F378@oracle.com>
 <91eade26-e5cc-4841-e891-7aaa309471bc@amd.com>
In-Reply-To: <91eade26-e5cc-4841-e891-7aaa309471bc@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0201CA0069.namprd02.prod.outlook.com
 (2603:10b6:803:20::31) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:42::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2132ccfe-3d28-4816-d87b-08d70a1860e3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3274;
x-ms-traffictypediagnostic: DM6PR12MB3274:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <DM6PR12MB3274767542F8CD10841BC815E5CE0@DM6PR12MB3274.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0100732B76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(39860400002)(136003)(396003)(366004)(199004)(189003)(2616005)(31696002)(26005)(54906003)(53936002)(8676002)(25786009)(5660300002)(66066001)(229853002)(71190400001)(71200400001)(6506007)(81166006)(36756003)(386003)(86362001)(76176011)(11346002)(316002)(186003)(102836004)(6436002)(53546011)(6246003)(2906002)(68736007)(966005)(64756008)(8936002)(256004)(14444005)(6512007)(6916009)(66476007)(66556008)(66946007)(99286004)(476003)(14454004)(6306002)(66446008)(31686004)(446003)(52116002)(81156014)(6116002)(305945005)(7736002)(478600001)(4326008)(3846002)(486006)(6486002)(6606295002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3274;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5yJe3EU/4GymLFxRWXxkac2OFX7POGsGhMMOKoufftKl9hux+OSPHSRquVkIKrfu/eaw2vN3z89JZlWCB3jrNw5ajUC5EW586XBc9wrF8fi1vSYRtQnS5BoehfW2WRnqyeDw16CXiSNLbZGUoCq0AZDyV11SrK0kMvz8nKh8GRuD+oL3jEeIBlpTLE02Oy+TsSV1Od2J2pBl0vjJW0ypZm5aNiwE7j1KT7E31qSxWDmzpDh8TpxBjewCEyVXPA3NGp5h+WcIcJMbghfb832Uvw+BZL3WsVjFejBq31Co4yOAaTxsGjec557tW9SQ0iQeznrcjYKWku/Fd6XXmZRSPDWWuehGXHRcE1GbHyAH7M8DryFDWpdDShrQ5dC0Jh8s5+Sy8rYQmXYMMU7e61q2cGVOfoWZXpLg9FaDY/v6/hs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7C2F9C853D6C8946B6600BBD20C59482@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2132ccfe-3d28-4816-d87b-08d70a1860e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2019 18:06:51.9241
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

DQpPb29wcyBzb3JyeSwgSSB3YXMgZndkaW5nIHRocmVhZCBIVyBmb2xrcyB0byBjb3JyZWN0IG15
IHVuZGVyc3RhbmRpbmcuDQpJIHdpbGwgdXBkYXRlIHlvdSB3aXRoIHJlc3VsdC4gdGhhbmtzDQoN
Cg0KT24gNy8xNi8xOSAxOjA1IFBNLCBTaW5naCwgQnJpamVzaCB3cm90ZToNCj4gSGVyZSBpcyBh
IHRocmVhZC4uIGJ1dCBtb3JlIHJlY2VudCBpcyBhdmFpbGFibGUNCj4gDQo+IGh0dHBzOi8vbWFy
Yy5pbmZvLz90PTE1NjMyMjI4MzMwMDAwMSZyPTEmdz0yDQo+IA0KPiBQYW9sbywgU2VhbiBhbmQg
b3RoZXJzIGhhdmUgYWxzbyByZXBsaWVkIHRvIGl0IHdoaWNoIHlvdSBjYW4gc2VlIG9uDQo+IG1h
cmMuaW5mby4NCj4gDQo+IC1CcmlqZXNoDQo+IA0KPiBPbiA3LzE2LzE5IDExOjIwIEFNLCBMaXJh
biBBbG9uIHdyb3RlOg0KPj4NCj4+DQo+Pj4gT24gMTYgSnVsIDIwMTksIGF0IDE5OjEwLCBTaW5n
aCwgQnJpamVzaCA8YnJpamVzaC5zaW5naEBhbWQuY29tPiB3cm90ZToNCj4+Pg0KPj4+DQo+Pj4N
Cj4+PiBPbiA3LzE2LzE5IDEwOjU2IEFNLCBMaXJhbiBBbG9uIHdyb3RlOg0KPj4+Pg0KPj4+Pg0K
Pj4+Pj4gT24gMTYgSnVsIDIwMTksIGF0IDE4OjQ4LCBTaW5naCwgQnJpamVzaCA8YnJpamVzaC5z
aW5naEBhbWQuY29tPiB3cm90ZToNCj4+Pj4+DQo+Pj4+PiBPbiA3LzE1LzE5IDM6MzAgUE0sIExp
cmFuIEFsb24gd3JvdGU6DQo+Pj4+Pj4gQWNjb3JkaW5nIHRvIEFNRCBFcnJhdGEgMTA5NjoNCj4+
Pj4+PiAiT24gYSBuZXN0ZWQgZGF0YSBwYWdlIGZhdWx0IHdoZW4gQ1I0LlNNQVAgPSAxIGFuZCB0
aGUgZ3Vlc3QgZGF0YSByZWFkIGdlbmVyYXRlcyBhIFNNQVAgdmlvbGF0aW9uLCB0aGUNCj4+Pj4+
PiBHdWVzdEluc3RyQnl0ZXMgZmllbGQgb2YgdGhlIFZNQ0Igb24gYSBWTUVYSVQgd2lsbCBpbmNv
cnJlY3RseSByZXR1cm4gMGggaW5zdGVhZCB0aGUgY29ycmVjdCBndWVzdCBpbnN0cnVjdGlvbg0K
Pj4+Pj4+IGJ5dGVzLiINCj4+Pj4+Pg0KPj4+Pj4+IEFzIHN0YXRlZCBhYm92ZSwgZXJyYXRhIGlz
IGVuY291bnRlcmVkIHdoZW4gZ3Vlc3QgcmVhZCBnZW5lcmF0ZXMgYSBTTUFQIHZpb2xhdGlvbi4g
aS5lLiB2Q1BVIHJ1bnMNCj4+Pj4+PiB3aXRoIENQTDwzIGFuZCBDUjQuU01BUD0xLiBIb3dldmVy
LCBjb2RlIGhhdmUgbWlzdGFrZW5seSBjaGVja2VkIGlmIENQTD09MyBhbmQgQ1I0LlNNQVA9PTAu
DQo+Pj4+Pj4NCj4+Pj4+DQo+Pj4+PiBUaGUgU01BUCB2aW9sYXRpb24gd2lsbCBvY2N1ciBmcm9t
IENQTDMgc28gQ1BMPT0zIGlzIGEgdmFsaWQgY2hlY2suDQo+Pj4+Pg0KPj4+Pj4gU2VlIFsxXSBm
b3IgY29tcGxldGUgZGlzY3Vzc2lvbg0KPj4+Pj4NCj4+Pj4+IGh0dHBzOi8vdXJsZGVmZW5zZS5w
cm9vZnBvaW50LmNvbS92Mi91cmw/dT1odHRwcy0zQV9fcGF0Y2h3b3JrLmtlcm5lbC5vcmdfcGF0
Y2hfMTA4MDgwNzVfLTIzMjI0NzkyNzEmZD1Ed0lHYVEmYz1Sb1AxWXVtQ1hDZ2FXSHZsWllSOFBa
aDhCdjdxSXJNVUI2NWVhcElfSm5FJnI9Sms2UThuTnprUTZMSjZnNDJxQVJrZzZyeUlER1FyLXlL
WFBOR1picFR4MCZtPVJBdDh0OG5CYUN4VVB5NU9URGtPMG44Qk1RNWw5b1NmTE1pTDBUTFR1NmMm
cz1Oa3dlOHJUSmh5Z0JDSVB6MjdMWHJ5bHB0am5XeU13Qi1uSmFpb3dXcFdjJmU9DQo+Pj4+DQo+
Pj4+IEkgc3RpbGwgZG9u4oCZdCB1bmRlcnN0YW5kLiBTTUFQIGlzIGEgbWVjaGFuaXNtIHdoaWNo
IGlzIG1lYW50IHRvIHByb3RlY3QgYSBDUFUgcnVubmluZyBpbiBDUEw8MyBmcm9tIG1pc3Rha2Vu
bHkgcmVmZXJlbmNpbmcgZGF0YSBjb250cm9sbGFibGUgYnkgQ1BMPT0zLg0KPj4+PiBUaGVyZWZv
cmUsIFNNQVAgdmlvbGF0aW9uIHNob3VsZCBiZSByYWlzZWQgd2hlbiBDUEw8MyBhbmQgZGF0YSBy
ZWZlcmVuY2VkIGlzIG1hcHBlZCBpbiBwYWdlLXRhYmxlcyB3aXRoIFBURSB3aXRoIFUvUyBiaXQg
c2V0IHRvIDEuIChpLmUuIFVzZXIgYWNjZXNzaWJsZSkuDQo+Pj4+DQo+Pj4+IFRodXMsIHdlIHNo
b3VsZCBjaGVjayBpZiBDUEw8MyBhbmQgQ1I0LlNNQVA9PTEuDQo+Pj4+DQo+Pj4NCj4+PiBJbiB0
aGlzIHBhcnRpY3VsYXIgY2FzZSB3ZSBhcmUgZGVhbGluZyB3aXRoIE5QRiBhbmQgbm90IFNNQVAg
ZmF1bHQgcGVyDQo+Pj4gc2F5Lg0KPj4+DQo+Pj4gV2hhdCB0eXBpY2FsbHkgaGFzIGhhcHBlbmVk
IGhlcmUgaXM6DQo+Pj4NCj4+PiAtIHVzZXIgc3BhY2UgZG9lcyB0aGUgTU1JTyBhY2Nlc3Mgd2hp
Y2ggY2F1c2VzIGEgZmF1bHQNCj4+PiAtIGhhcmR3YXJlIHByb2Nlc3NlcyB0aGlzIGFzIGEgVk1F
WElUDQo+Pj4gLSBkdXJpbmcgcHJvY2Vzc2luZywgaGFyZHdhcmUgYXR0ZW1wdHMgdG8gcmVhZCB0
aGUgaW5zdHJ1Y3Rpb24gYnl0ZXMgdG8NCj4+PiBwcm92aWRlIGRlY29kZSBhc3Npc3QuIFRoaXMg
aXMgdHlwaWNhbGx5IGRvbmUgYnkgZGF0YSByZWFkIHJlcXVlc3QgZnJvbQ0KPj4+IHRoZSBSSVAg
dGhhdCB0aGUgZ3Vlc3Qgd2FzIGF0LiBXaGlsZSBkb2luZyBzbywgd2UgbWF5IGhpdCBTTUFQIGZh
dWx0DQo+Pg0KPj4gSG93IGNhbiBhIFNNQVAgZmF1bHQgb2NjdXIgd2hlbiBDUEw9PTM/IE9uZSBv
ZiB0aGUgY29uZGl0aW9ucyBmb3IgU01BUCBpcyB0aGF0IENQTDwzLg0KPj4NCj4+IEkgdGhpbmsg
dGhlIGNvbmZ1c2lvbiBpcyB0aGF0IEkgYmVsaWV2ZSBhIGNvZGUgbWFwcGVkIGFzIHVzZXItYWNj
ZXNzaWJsZSBpbiBwYWdlLXRhYmxlcyBidXQgcnVucyB3aXRoIENQTDwzDQo+PiBzaG91bGQgYmUg
dGhlIG9uZSB3aGljaCBkb2VzIHRoZSBNTUlPLiBSYXRoZXIgdGhlbiBjb2RlIHJ1bm5pbmcgaW4g
Q1BMPT0zLg0KPj4NCj4+IFRoZSBzZXF1ZW5jZSBvZiBldmVudHMgSSBpbWFnaW5lIHRvIHRyaWdn
ZXIgdGhlIEVycmF0YSBpcyBhcyBmb2xsb3dzOg0KPj4gMSkgR3Vlc3QgbWFwcyBjb2RlIGluIHBh
Z2UtdGFibGVzIGFzIHVzZXItYWNjZXNzaWJsZSAoaS5lLiBQVEUgd2l0aCBVL1MgYml0IHNldCB0
byAxKS4NCj4+IDIpIEd1ZXN0IGV4ZWN1dGVzIHRoaXMgY29kZSB3aXRoIENQTDwzIChldmVuIHRo
b3VnaCBtYXBwZWQgYXMgdXNlci1hY2Nlc3NpYmxlIHdoaWNoIGlzIGEgc2VjdXJpdHkgdnVsbmVy
YWJpbGl0eSBpbiBpdHNlbGbigKYpIHdoaWNoIGFjY2VzcyBkYXRhIHRoYXQgaXMgbm90IG1hcHBl
ZCBvciBtYXJrZWQgYXMgcmVzZXJ2ZWQgaW4gTlBUIGFuZCB0aGVyZWZvcmUgY2F1c2UgI05QRi4N
Cj4+IDMpIFBoeXNpY2FsIENQVSBEZWNvZGVBc3Npc3QgZmVhdHVyZSBhdHRlbXB0cyB0byBmaWxs
LWluIGd1ZXN0IGluc3RydWN0aW9uIGJ5dGVzLiBTbyBpdCByZWFkcyBhcyBkYXRhIHRoZSBndWVz
dCBpbnN0cnVjdGlvbnMgd2hpbGUgQ1BVIGlzIGN1cnJlbnRseSB3aXRoIENQTDwzLCBDUjQuU01B
UD0xIGFuZCBjb2RlIGlzIG1hcHBlZCBhcyB1c2VyLWFjY2Vzc2libGUuIFRoZXJlZm9yZSwgdGhp
cyBmaWxsLWluIHJhaXNlIGEgU01BUCB2aW9sYXRpb24gd2hpY2ggY2F1c2UgI05QRiB0byBiZSBy
YWlzZWQgdG8gS1ZNIHdpdGggMCBpbnN0cnVjdGlvbiBieXRlcy4NCj4+DQo+PiBCVFcsIHRoaXMg
YWxzbyBtZWFucyB0aGF0IGluIG9yZGVyIHRvIHRyaWdnZXIgdGhpcywgQ1I0LlNNRVAgc2hvdWxk
IGJlIHNldCB0byAwLiBBcyBvdGhlcndpc2UsIGluc3RydWN0aW9uIGNvdWxkbuKAmXQgaGF2ZSBi
ZWVuIGV4ZWN1dGVkIHRvIHJhaXNlICNOUEYgaW4gdGhlIGZpcnN0IHBsYWNlLiBNYXliZSB3ZSBj
YW4gYWRkIHRoaXMgYXMgYW5vdGhlciBjb25kaXRpb24gdG8gcmVjb2duaXNlIHRoZSBFcnJhdGE/
DQo+Pg0KPj4gLUxpcmFuDQo+Pg0KPj4+IGJlY2F1c2UgaW50ZXJuYWxseSBDUFUgaXMgZG9pbmcg
YSBkYXRhIHJlYWQgZnJvbSB0aGUgUklQIHRvIGdldCB0aG9zZQ0KPj4+IGluc3RydWN0aW9uIGJ5
dGVzLiBTaW5jZSBpdCBoaXQgdGhlIFNNQVAgZmF1bHQgaGVuY2UgaXQgd2FzIG5vdCBhYmxlDQo+
Pj4gdG8gZGVjb2RlIHRoZSBpbnN0cnVjdGlvbiB0byBwcm92aWRlIHRoZSBpbnNuX2xlbi4gU28g
d2UgYXJlIGZpcnN0DQo+Pj4gY2hlY2tpbmcgaWYgaXQgd2FzIGEgZmF1bHQgY2F1c2VkIGZyb20g
Q1BMPT0zIGFuZCBTTUFQIGlzIGVuYWJsZWQuDQo+Pj4gSWYgc28sIHdlIGFyZSBoaXR0aW5nIHRo
aXMgZXJyYXRhIGFuZCBpdCBjYW4gYmUgd29ya2Fyb3VuZC4NCj4+Pg0KPj4+IC1CcmlqZXNoDQo+
Pj4NCj4+Pg0KPj4+DQo+Pg0K
