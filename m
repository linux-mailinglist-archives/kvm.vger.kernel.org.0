Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA0F6D111
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 17:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbfGRPZu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 11:25:50 -0400
Received: from mail-eopbgr690083.outbound.protection.outlook.com ([40.107.69.83]:33412
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726040AbfGRPZt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 11:25:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EVZDkr4qQfrnhRQ/7shaShEhZmZdHNfTZVoputxRBSAbn1Ttdqktbytz+p9CfNEu/PQJCbGCIG9HIgevX/8PSXcqP479dKcqmZBcn5jqHV9HKG6w8MwGtHvj285JrgHdgXbPtkp5suaAljTWTqROffP/xtUYxiaalPO7F3+YtOyo+Eunhz8OgoHJAFtyj0HcsnO6Zczp1+FwDCJFtjdZy1ynWTOWpIH2/UmFGC8YWv45+Mtw5OLLMAvhDECdBr/0iMxbaRCYLEJJDwOLBOdSPjYn1EPfSMFwBvtxLtzlzNT9xWnD4HTh7L56+VZAYGMyav6UY2v/2nQp4yqQiVMMRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2U5YnsqlSdY3U3TAaucFxDBxLke7V9s44OYd7WffwjE=;
 b=Chta7llk2HvJ/rkS2dwiwq7l+JJObpbB/d+H6r3tBGpzCiqfha9RReDO11M4r18459l89JugG+D/ZX+o/X3y5a20dfPPiCRa/oEABUlXvau8OPZ1DhIaMNVyE5twpPlUWlmkw/bkIc3+kOwjZeV1mt6LbCoKvc06PFCODuqGoY7+gIjiQwc2P7YhV3MkuLS88HFbvcr5aazP7mMX/ya/6jS8jul02GrbmlvjbOvEC2nMLx0GNooOHTiwXL8Doy8AO9NN7DmqZYZhnu4Wo+VbUvj2/fO/Q/XjV1ojo+acmYDZxaweqjGEXKK1qCXHTcTGZKmvor07ruj0B7mf+7k6QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2U5YnsqlSdY3U3TAaucFxDBxLke7V9s44OYd7WffwjE=;
 b=r98OlWqxNoOPoltJEkFxhrkB10mVDvRfOUMN3xXG+rJDRTjqRSQ9FlP2TCjgHxifLhitkmYnYtswGvNei2keE3Fsl4vELwo+AJjggRQ1zXGKlBXkH1ucomQyBXj7Wp8zpJ6eDuhZqAdG8zUacFgygHo6Z/H3YkFui4AoMY8edXI=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.118.13) by
 DM6PR12MB4060.namprd12.prod.outlook.com (10.141.185.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.11; Thu, 18 Jul 2019 15:25:45 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::7439:ea87:cc5d:71]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::7439:ea87:cc5d:71%7]) with mapi id 15.20.2073.012; Thu, 18 Jul 2019
 15:25:45 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH v2] KVM: SVM: Fix detection of AMD Errata 1096
Thread-Topic: [PATCH v2] KVM: SVM: Fix detection of AMD Errata 1096
Thread-Index: AQHVPDI1g6HCMGM2X0WzQ9tuOo86XqbPSIEAgADsGgCAAE0egA==
Date:   Thu, 18 Jul 2019 15:25:45 +0000
Message-ID: <69838316-2ef8-bbb9-6f52-3f92f5922285@amd.com>
References: <20190716235658.18185-1-liran.alon@oracle.com>
 <462d7b68-94c9-2e9b-23f8-bc2567fa62af@amd.com>
 <d0445fde-afe1-f3fe-6c26-3d8eef8dc4d8@redhat.com>
In-Reply-To: <d0445fde-afe1-f3fe-6c26-3d8eef8dc4d8@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0501CA0135.namprd05.prod.outlook.com
 (2603:10b6:803:2c::13) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:42::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f8bd441c-b6b4-49e0-99ad-08d70b943344
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB4060;
x-ms-traffictypediagnostic: DM6PR12MB4060:
x-microsoft-antispam-prvs: <DM6PR12MB4060433A02E129695DBC78CFE5C80@DM6PR12MB4060.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01026E1310
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(366004)(346002)(136003)(396003)(199004)(189003)(476003)(2201001)(66476007)(64756008)(36756003)(86362001)(2616005)(66446008)(66946007)(446003)(11346002)(186003)(5660300002)(6246003)(66066001)(66556008)(71190400001)(26005)(71200400001)(6436002)(6512007)(478600001)(305945005)(7736002)(53936002)(6486002)(99286004)(81156014)(31686004)(8936002)(14444005)(81166006)(3846002)(256004)(6116002)(31696002)(76176011)(54906003)(486006)(110136005)(102836004)(229853002)(4326008)(52116002)(53546011)(6506007)(2501003)(386003)(68736007)(8676002)(2906002)(25786009)(316002)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB4060;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: suTZrjkdIwwMWQRL5RYBAQfb9esyoN6Sb6aZO/8127dgI76MpWUKHjKSTkOy4FEakES9/V+IEQMwPVJO2wVvxELJqz3lDolAyOzXe7imnXn5LTk8DBW9ESdc3h3gThdSXA+ldUQVjirrcgdefFYYKg7ZDZYCmN+JkY5k6lVp32srzsglJLEWbkEcKELA6DF4Qe0vzEBMYp6fMIVdXzQGXbwdMiozTOtgvz/1NHpUOVHuGfVNnApyHFbAOtQTcZo4nXtAwY2GyA6yqapO26zl08D0RDVUV+eCNsVtl+q8QC+nX/ITfpIA9RzjXKG9mO4rGM2CSwNqAsQ+OsYEwyv8LxfOT05wf58+bYiBdA72tWqqxdw7tdWsqzUfjaT44/yNOGLetZTvDoe7uj4zRudjns4qlRBkuEi9fttdFbHjHrE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1DEC1FFA8547404ABEE51D39AF328F41@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8bd441c-b6b4-49e0-99ad-08d70b943344
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2019 15:25:45.8322
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sbrijesh@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4060
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgUGFvbG8sDQoNCk9uIDcvMTgvMTkgNTo0OSBBTSwgUGFvbG8gQm9uemluaSB3cm90ZToNCj4g
QnJpamVzaCwNCj4gDQo+IGp1c3Qgb25lIHRoaW5nIEknZCBsaWtlIHRvIGRvdWJsZSBjaGVjazog
ZG9lcyB0aGUgZXJyYXR1bSByZWFsbHkgZGVwZW5kDQo+IG9uIGd1ZXN0IENSNC5TTUFQLCBvciBy
YXRoZXIgb24gaG9zdCBDUjQuU01BUD8gIChPZiBjb3Vyc2UgdGhlIFNNRVANCj4gY2hlY2sgaW5z
dGVhZCBuZWVkcyB0byB1c2UgZ3Vlc3QgQ1I0LlNNRVApLg0KPiANCg0KSSBkb3VibGUgY2hlY2tl
ZCB3aXRoIGRlc2lnbiB0ZWFtIHRvIGJlIHN1cmUsIHRoZSBlcnJhdHVtIGRlcGVuZHMgb24NCmd1
ZXN0IENSNC5TTUFQIGFuZCBub3QgdGhlIGhvc3QgQ1I0LlNNQVAuDQoNCnRoYW5rcw0KDQo+IEFu
ZCBoZXJlIGlzIGEgY29tbWl0IG1lc3NhZ2Ugd2l0aCBzdHlsZSBmaXhlczoNCj4gDQo+IC0tLQ0K
PiBXaGVuIENQVSByYWlzZSAjTlBGIG9uIGd1ZXN0IGRhdGEgYWNjZXNzIGFuZCBndWVzdCBDUjQu
U01BUD0xLCBpdCBpcw0KPiBwb3NzaWJsZSB0aGF0IENQVSBtaWNyb2NvZGUgaW1wbGVtZW50aW5n
IERlY29kZUFzc2lzdCB3aWxsIGZhaWwNCj4gdG8gcmVhZCBieXRlcyBvZiBpbnN0cnVjdGlvbiB3
aGljaCBjYXVzZWQgI05QRi4gVGhpcyBpcyBBTUQgZXJyYXRhDQo+IDEwOTYgYW5kIGl0IGhhcHBl
bnMgYmVjYXVzZSBDUFUgbWljcm9jb2RlIHJlYWRpbmcgaW5zdHJ1Y3Rpb24gYnl0ZXMNCj4gaW5j
b3JyZWN0bHkgYXR0ZW1wdHMgdG8gcmVhZCBjb2RlIGFzIGltcGxpY2l0IHN1cGVydmlzb3ItbW9k
ZSBkYXRhDQo+IGFjY2Vzc2VzICh0aGF0IGlzLCBqdXN0IGxpa2UgaXQgd291bGQgcmVhZCBlLmcu
IGEgVFNTKSwgd2hpY2ggYXJlDQo+IHN1c2NlcHRpYmxlIHRvIFNNQVAgZmF1bHRzLiBUaGUgbWlj
cm9jb2RlIHJlYWRzIENTOlJJUCBhbmQgaWYgaXQgaXMNCj4gYSB1c2VyLW1vZGUgYWRkcmVzcyBh
Y2NvcmRpbmcgdG8gdGhlIHBhZ2UgdGFibGVzLCB0aGUgcHJvY2Vzc29yDQo+IGdpdmVzIHVwIGFu
ZCByZXR1cm5zIG5vIGluc3RydWN0aW9uIGJ5dGVzLiAgSW4gdGhpcyBjYXNlLA0KPiBHdWVzdElu
dHJCeXRlcyBmaWVsZCBvZiB0aGUgVk1DQiBvbiBhIFZNRVhJVCB3aWxsIGluY29ycmVjdGx5DQo+
IHJldHVybiAwIGluc3RlYWQgb2YgdGhlIGNvcnJlY3QgZ3Vlc3QgaW5zdHJ1Y3Rpb24gYnl0ZXMu
DQo+IA0KPiBDdXJyZW50IEtWTSBjb2RlIGF0dGVtcHMgdG8gZGV0ZWN0IGFuZCB3b3JrYXJvdW5k
IHRoaXMgZXJyYXRhLCBidXQgaXQNCj4gaGFzIG11bHRpcGxlIGlzc3VlczoNCj4gDQo+IDEpIEl0
IG1pc3Rha2VubHkgY2hlY2tzIGlmIGd1ZXN0IENSNC5TTUFQPTAgaW5zdGVhZCBvZiBndWVzdCBD
UjQuU01BUD0xLA0KPiB3aGljaCBpcyByZXF1aXJlZCBmb3IgZW5jb3VudGVyaW5nIGEgU01BUCBm
YXVsdC4NCj4gDQo+IDIpIEl0IGFzc3VtZXMgU01BUCBmYXVsdHMgY2FuIG9ubHkgb2NjdXIgd2hl
biB2Q1BVIENQTD09My4NCj4gSG93ZXZlciwgaW4gY2FzZSB2Q1BVIENSNC5TTUVQPTAsIHRoZSBn
dWVzdCBjYW4gZXhlY3V0ZSBhbiBpbnN0cnVjdGlvbg0KPiB3aGljaCByZXNpZGUgaW4gYSB1c2Vy
LWFjY2Vzc2libGUgcGFnZSB3aXRoIENQTDwzIHByaXZpbGVkZ2UuIElmIHRoaXMNCj4gaW5zdHJ1
Y3Rpb24gcmFpc2UgYSAjTlBGIG9uIGl0J3MgZGF0YSBhY2Nlc3MsIHRoZW4gQ1BVIERlY29kZUFz
c2lzdA0KPiBtaWNyb2NvZGUgd2lsbCBzdGlsbCBlbmNvdW50ZXIgYSBTTUFQIHZpb2xhdGlvbi4g
IEV2ZW4gdGhvdWdoIG5vIHNhbmUNCj4gT1Mgd2lsbCBkbyBzbyAoYXMgaXQncyBhbiBvYnZpb3Vz
IHByaXZpbGVkZ2UgZXNjYWxhdGlvbiB2dWxuZXJhYmlsaXR5KSwNCj4gd2Ugc3RpbGwgbmVlZCB0
byBoYW5kbGUgdGhpcyBzZW1hbnRpY2x5IGNvcnJlY3QgaW4gS1ZNIHNpZGUuDQo+IA0KPiBOb3Rl
IHRoYXQgKDIpICppcyogYSB1c2VmdWwgb3B0aW1pemF0aW9uLCBiZWNhdXNlIENSNC5TTUFQPTEg
aXMgYW4gZWFzeQ0KPiB0cmlnZ2VyYWJsZSBjb25kaXRpb24gYW5kIGd1ZXN0cyB1c3VhbGx5IGVu
YWJsZSBTTUFQIHRvZ2V0aGVyIHdpdGggU01FUCwNCj4gSWYgdGhlIHZDUFUgaGFzIENSNC5TTUVQ
PTEsIHRoZSBlcnJhdGEgY291bGQgaW5kZWVkIGJlIGVuY291bnRlcmVkIG9ubHkNCj4gYXQgZ3Vl
c3QgQ1BMMzsgb3RoZXJ3aXNlLCB0aGUgQ1BVIHdvdWxkIHJhaXNlIGEgU01FUCBmYXVsdCB0byBn
dWVzdA0KPiBpbnN0ZWFkIG9mICNOUEYuICBXZSBrZWVwIHRoaXMgY29uZGl0aW9uIHRvIGF2b2lk
IGZhbHNlIHBvc2l0aXZlcyBpbg0KPiB0aGUgZGV0ZWN0aW9uIG9mIHRoZSBlcnJhdGEuDQo+IA0K
PiBJbiBhZGRpdGlvbiwgdG8gYXZvaWQgZnV0dXJlIGNvbmZ1c2lvbiBhbmQgaW1wcm92ZSBjb2Rl
IHJlYWRiaWxpdHksDQo+IGluY2x1ZGUgZGV0YWlscyBvZiB0aGUgZXJyYXRhIGluIGNvZGUgYW5k
IG5vdCBqdXN0IGluIGNvbW1pdCBtZXNzYWdlLg0KPiAtLS0NCj4gDQo+IFBhb2xvDQo+IA0K
