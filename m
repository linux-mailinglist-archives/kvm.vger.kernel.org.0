Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 326ED6734C
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 18:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfGLQbQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 12:31:16 -0400
Received: from mail-eopbgr700060.outbound.protection.outlook.com ([40.107.70.60]:46273
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726449AbfGLQbQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 12:31:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PKq9oE1PS8CwMN5Kux7T+dqvyB3ejiWK9hOV67bEzeKMVUBi5s5/F8UCZ9DUwq5utN9ePFoi4QmPqZ5ycIrbgv10Tpt1xDDECnM/isdyJyOFPAm9v36lPYSSKqIkGdsidDdO3xxg9ae4630h7E0mTcG7t0ZmKiKC2tAtRJ7iJVTQ034AH4SJygVQxI0l8RsOr85r6zZwwYXCPBc4Rs5rRiBAdKYfD0wuC2PlNLY08BsDFeMhn6L/7gKl4gHNmSQxT2dDKU09k8c11MMQrLIVkhfhy/h5jtzyoanFbDdpbKuOQy+2aUqUerg8Zkx1xfidDVvKThdDMCvQHDFe0KVG/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c563vQfCKbW0M4EvO8q51umhylKIZU4RT14JjIsUxaA=;
 b=HS2lIHgIEybzC3sCMekz/IXdCd/wy/9P/B+guwa6ApsaEySFxrl1aomDGX+02OnK7aIWyFyQFS2PUMML6iM16pM3MCTQ+ciuS/K1x/2Vhj6lOT3JApGatXmd1cg/t7pupAjL8EcDQhImRwpFS1QmSLfMIjWpiE9o0Eg4BTmsjQZ2qobEB2YwKlGHWhwxDOzTc/uEiCHmtHGAh0/D3QBDEOkPa/QKS7F7D0Zq2j8sM0izw67JSiK0JfkVWg9lAPz/8AhgNpFbsOZVov6gtZJVhShbFFApas2oRVOPAfLbAKQfKclKIs1+padC3vBFCbGn7PP6Wv3eeoXR7WmNXBhHvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c563vQfCKbW0M4EvO8q51umhylKIZU4RT14JjIsUxaA=;
 b=pbvn9qPbHHNk4McqYYv+Fbe9eggG/cUP6y5EVwgYM+gefICvnKu0xiPnTCCaGRratzNFomni1z9EnENNNhQZPBoYglOWQQkyiceSxbmeN6HNORw4HRM2AQVOrOUpMZBZuqYE/itmvdIX2hm2mRnWbNQgF1TNRPv7u3Pgv7fAI3g=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.116.31) by
 DM6PR12MB3179.namprd12.prod.outlook.com (20.179.104.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.11; Fri, 12 Jul 2019 16:31:14 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::bc1a:a30d:9da2:1cdd]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::bc1a:a30d:9da2:1cdd%6]) with mapi id 15.20.2073.008; Fri, 12 Jul 2019
 16:31:14 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 00/11] Add AMD SEV guest live migration support
Thread-Topic: [PATCH v3 00/11] Add AMD SEV guest live migration support
Thread-Index: AQHVN1ve9r51ARqErUyGGRuzHzYveabHJNWAgAAK4gA=
Date:   Fri, 12 Jul 2019 16:31:14 +0000
Message-ID: <04ef6d22-84de-f5d3-9fc4-ffc555860c51@amd.com>
References: <20190710201244.25195-1-brijesh.singh@amd.com>
 <20190712155215.GA12840@char.us.oracle.com>
In-Reply-To: <20190712155215.GA12840@char.us.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR04CA0045.namprd04.prod.outlook.com
 (2603:10b6:805:2a::22) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:4a::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 39e75b72-8a2b-4ce8-4f79-08d706e65b46
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3179;
x-ms-traffictypediagnostic: DM6PR12MB3179:
x-microsoft-antispam-prvs: <DM6PR12MB3179DFC1A668A3D0BD6035B0E5F20@DM6PR12MB3179.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00963989E5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(366004)(346002)(376002)(396003)(199004)(189003)(3846002)(6116002)(53546011)(11346002)(446003)(102836004)(5660300002)(2906002)(86362001)(256004)(64756008)(186003)(81166006)(81156014)(66946007)(52116002)(476003)(99286004)(2616005)(8676002)(66476007)(66446008)(8936002)(6506007)(386003)(66556008)(54906003)(6246003)(76176011)(26005)(53936002)(36756003)(478600001)(66066001)(316002)(6486002)(229853002)(6436002)(6512007)(486006)(6916009)(31686004)(14454004)(71200400001)(7736002)(25786009)(68736007)(31696002)(305945005)(71190400001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3179;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mjYMkF87fkkx0FZaBo/IYJIw2IjR3Ux79YnSV1bcQxbpv6zGpUiQsJJcrjnqQQp3zaeI/Yu10UWxjtYZJuDVMcFbWdEQ1vy9IeYF90/KoDzjDa6LsnhG55o6J0iDfCvXEcDJb8+Q9lQ0nGHbf32OQFcwod2Ujrk6zMvkQ2HZM8gtp4DAeYKh2cL+nTLSrD1BPby+OsIZEm3iSb2X8AARD4Gchg+hL6TPm9TSLVFZTHAY6pM7JPrQ4NDyzEt8XdCGJ1KxXdQXIBLSMfXxx8rm26JQAfM4RK9vNiubDOf7CSmTRlDJut/D3xT1tiNR1DFV3IEIZggNCQTgaZYuohpbIfibm309yMp9mQISR9pFaz+D8NSGnA2oNhc0O1SZubtgIKWJSZSvCa4DFWnqDJKfWfVsxJGaCubgCnbhyU9G0JU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D899BCF4DF64264E905725E7DA1597F1@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39e75b72-8a2b-4ce8-4f79-08d706e65b46
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2019 16:31:14.1652
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sbrijesh@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3179
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCk9uIDcvMTIvMTkgMTA6NTIgQU0sIEtvbnJhZCBSemVzenV0ZWsgV2lsayB3cm90ZToNCj4g
T24gV2VkLCBKdWwgMTAsIDIwMTkgYXQgMDg6MTI6NTlQTSArMDAwMCwgU2luZ2gsIEJyaWplc2gg
d3JvdGU6DQo+PiBUaGUgc2VyaWVzIGFkZCBzdXBwb3J0IGZvciBBTUQgU0VWIGd1ZXN0IGxpdmUg
bWlncmF0aW9uIGNvbW1hbmRzLiBUbyBwcm90ZWN0IHRoZQ0KPj4gY29uZmlkZW50aWFsaXR5IG9m
IGFuIFNFViBwcm90ZWN0ZWQgZ3Vlc3QgbWVtb3J5IHdoaWxlIGluIHRyYW5zaXQgd2UgbmVlZCB0
bw0KPj4gdXNlIHRoZSBTRVYgY29tbWFuZHMgZGVmaW5lZCBpbiBTRVYgQVBJIHNwZWMgWzFdLg0K
Pj4NCj4+IFNFViBndWVzdCBWTXMgaGF2ZSB0aGUgY29uY2VwdCBvZiBwcml2YXRlIGFuZCBzaGFy
ZWQgbWVtb3J5LiBQcml2YXRlIG1lbW9yeQ0KPj4gaXMgZW5jcnlwdGVkIHdpdGggdGhlIGd1ZXN0
LXNwZWNpZmljIGtleSwgd2hpbGUgc2hhcmVkIG1lbW9yeSBtYXkgYmUgZW5jcnlwdGVkDQo+PiB3
aXRoIGh5cGVydmlzb3Iga2V5LiBUaGUgY29tbWFuZHMgcHJvdmlkZWQgYnkgdGhlIFNFViBGVyBh
cmUgbWVhbnQgdG8gYmUgdXNlZA0KPj4gZm9yIHRoZSBwcml2YXRlIG1lbW9yeSBvbmx5LiBUaGUg
cGF0Y2ggc2VyaWVzIGludHJvZHVjZXMgYSBuZXcgaHlwZXJjYWxsLg0KPj4gVGhlIGd1ZXN0IE9T
IGNhbiB1c2UgdGhpcyBoeXBlcmNhbGwgdG8gbm90aWZ5IHRoZSBwYWdlIGVuY3J5cHRpb24gc3Rh
dHVzLg0KPj4gSWYgdGhlIHBhZ2UgaXMgZW5jcnlwdGVkIHdpdGggZ3Vlc3Qgc3BlY2lmaWMta2V5
IHRoZW4gd2UgdXNlIFNFViBjb21tYW5kIGR1cmluZw0KPj4gdGhlIG1pZ3JhdGlvbi4gSWYgcGFn
ZSBpcyBub3QgZW5jcnlwdGVkIHRoZW4gZmFsbGJhY2sgdG8gZGVmYXVsdC4NCj4+DQo+IA0KPiBJ
IGFtIGJpdCBsb3N0LiBXaHkgY2FuJ3QgdGhlIGh5cGVydmlzb3Iga2VlcCB0cmFjayBvZiBoeXBl
cnZpc29yIGtleSBwYWdlcw0KPiBhbmQgdHJlYXQgYWxsIG90aGVyIHBhZ2VzIGFzIG93bmVkIGJ5
IHRoZSBndWVzdCBhbmQgaGVuY2UgdXNpbmcgdGhlIGd1ZXN0LXNwZWNpZmljDQo+IGtleT8NCj4g
DQoNClRoZSBndWVzdCBPUyBtYXJrcyB0aGUgcGFnZXMgJ3ByaXZhdGUnIG9yICdzaGFyZWQnLiBJ
dCBpcyBkb25lIGJ5DQpzZXR0aW5nIHBhZ2UgZW5jcnlwdGlvbiBmbGFnIChha2EgQy1iaXQpIGlu
IGd1ZXN0IHBhZ2UgdGFibGUuIFRoZSBzaGFyZWQNCnBhZ2VzIG1heSBub3QgbmVjZXNzYXJ5IGJl
IGp1c3QgaHlwZXJ2aXNvciBrZXkgcGFnZXMuIEluIGNhc2Ugb2YgU0VWLA0KRE1BIG5lZWRzIHRv
IGJlIGRvbmUgb24gdGhlIHNoYXJlZCBwYWdlcywgc28gZ3Vlc3QgT1MgbWFya3MgdGhlIERNQQ0K
YnVmZmVycyBhcyBzaGFyZWQuDQoNCi1CcmlqZXNoDQo=
