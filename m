Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33C32EE7BF
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 19:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbfKDSzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 13:55:40 -0500
Received: from mail-eopbgr720062.outbound.protection.outlook.com ([40.107.72.62]:4141
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728268AbfKDSzk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 13:55:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cf4aze0GAJ3lRQm+QUV98wt5NKbO5elslYSsnUsMOmvx+rJkpWE0WbInbhCh5DMU/aTMSq1H6eHywswmqUAKQ/1E+IrYQojw/1JGckqAk+2GMptgv/lpbfZmvCbATW/3XzF/w/TMklP/VWxOYFfbH6YUMvYfYnCT/xIa4uPpP+t1eXAVt8s3GY/SV8buenIZ8nZXp7T5/c8dM6ard0++QB0kAdhF8818rdWA+VX8U+FehhfrXNVTLyv1/2+7kUa1WraIZOEYJQznm+vv85wKz/KVwt+SOlUbLaAvxg9Rxq2DujAnZalylzO7VZ5CJUAjoXU7d4FvWEr9i1oDaidTMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DkCrKEFENQ5NkLIhAmkV5Rrdz/wQ2JVQsCmVuU40x1Y=;
 b=FhfB+pwUA4tT59VX4QShuA2IIQTNDfc5mUkLDPPdDov6jiak2zD/nGyz8jIkDmjTQ9MjN2Coe3gmkpjqcT5PEBc+qCbs4AF/euKS0UhIwcVkBYlPFcZJBtYIizUVkxEanEdNMKNe62DZkrNdGnF0imGCHlzj24X7yeSKL7L+/AzmQxLDabMPSmVqU0Z3JaeSCV29yBk18CuNmw5lwa1e86Ds8fCHuip5KnNFqrU24CQ0TDzifCsBd0iiDDMyEvDcUH++8Zq/3ksoGstwyXuwx26hABVyhpb03AZoVpFj43549eHVGXyARqcCdHa5JgJr2f8gZxSHQ4+QW/ftq5cr0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DkCrKEFENQ5NkLIhAmkV5Rrdz/wQ2JVQsCmVuU40x1Y=;
 b=NflsDGMn48S9zhToNDlMWBce2djn6UGiqbdrJ/UxbhX70AsvJWWssQTJVIuRfa1dy7QMi8X7m0MyhuQlAYJlLrB7o5BgNjQ8rAv4lTeyMDW5GkPp1w823B3YxzaZCdpFDuFI8rD/nGhtwJdTENuVLajtLLUERvd5CqOWYHJvmgw=
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3916.namprd12.prod.outlook.com (10.255.174.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Mon, 4 Nov 2019 18:54:58 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2408.024; Mon, 4 Nov 2019
 18:54:57 +0000
From:   "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "rkagan@virtuozzo.com" <rkagan@virtuozzo.com>,
        "graf@amazon.com" <graf@amazon.com>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
Subject: Re: [PATCH v4 13/17] kvm: i8254: Deactivate APICv when using
 in-kernel PIT re-injection mode.
Thread-Topic: [PATCH v4 13/17] kvm: i8254: Deactivate APICv when using
 in-kernel PIT re-injection mode.
Thread-Index: AQHVkQWFwL1+c1CZPkWuTq14KdLXDad3peqAgAO6uQA=
Date:   Mon, 4 Nov 2019 18:54:57 +0000
Message-ID: <b4e61499-7247-d39e-cd46-c53388ba347a@amd.com>
References: <1572648072-84536-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1572648072-84536-14-git-send-email-suravee.suthikulpanit@amd.com>
 <70fb2b49-2198-bde4-a38b-f37bc8bc9847@redhat.com>
In-Reply-To: <70fb2b49-2198-bde4-a38b-f37bc8bc9847@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.0
x-originating-ip: [165.204.25.250]
x-clientproxiedby: BN6PR12CA0042.namprd12.prod.outlook.com
 (2603:10b6:405:70::28) To DM6PR12MB3865.namprd12.prod.outlook.com
 (2603:10b6:5:1c8::18)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6988c91a-be43-47e0-8d21-08d761587cc3
x-ms-traffictypediagnostic: DM6PR12MB3916:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB39162904F7B331C6E5467D5DF37F0@DM6PR12MB3916.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0211965D06
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(346002)(136003)(376002)(39860400002)(189003)(199004)(2201001)(99286004)(25786009)(71200400001)(65806001)(229853002)(66066001)(14444005)(256004)(31686004)(81166006)(2906002)(8936002)(8676002)(71190400001)(81156014)(6512007)(6436002)(305945005)(478600001)(7736002)(486006)(476003)(4326008)(6486002)(66446008)(2616005)(14454004)(6246003)(65956001)(5660300002)(11346002)(446003)(64756008)(36756003)(386003)(6506007)(53546011)(2501003)(3846002)(102836004)(52116002)(76176011)(6116002)(26005)(54906003)(186003)(7416002)(86362001)(31696002)(316002)(110136005)(58126008)(66946007)(66476007)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3916;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jixSI+jtlyLvpNb5yIECnOi4yU5LzRseEWYBsoPBIC/LzN7KCf0MWwsjeJpNHNtDOk7a44c+79DojVvV3fd/dSuAZOhIGvszA7T3TAryhFpZ+Xzpr7Lhvdge5nzOFeRcqd4WfXaLIHQEaMIpWrzE5PbYSSgEp6MIRkXTS8wFkUJJfnAxiRM44wqj3hDJfxKWclZcAcJv840IHGeh0GcCtJSFxScsGXcumW4foSpNMI47g6xcIOX0lRJLUzZYhL0nLR3YwlJ5jaeDehDjlo0+VzrjPGAbRC4Lrq5owsZuVetIqHV0clY3TFvWL57EjJn1fEhda27oo38qgcu2o8B37bT0ee34uuTZUAVJYLoXjBh9YPwK1kponK+D1ZxyrVi0W1+Zqxl5n7GLzP4U5vTMwWdV5B+nxGExQ7U+levP6tteII9IJ9ADeq2SxL+TdM7E
Content-Type: text/plain; charset="utf-8"
Content-ID: <BA05608FF90A9B448651DE7A951AF675@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6988c91a-be43-47e0-8d21-08d761587cc3
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2019 18:54:57.6290
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4YBmfc1gPGP1DmBotnbgdYhlApHmhOY27x2cu9xJ/0WaACOlhqOyOa1tX5TAg56QyJgd9WbL8VyFz37boORMWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3916
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UGFvbG8sDQoNClRoYW5rcyBmb3IgcXVpY2sgcmVzcG9uc2UuDQoNCk9uIDExLzIvMTkgNDo1NyBB
TSwgUGFvbG8gQm9uemluaSB3cm90ZToNCj4gT24gMDEvMTEvMTkgMjM6NDEsIFN1dGhpa3VscGFu
aXQsIFN1cmF2ZWUgd3JvdGU6DQo+PiArCS8qDQo+PiArCSAqIEFNRCBTVk0gQVZJQyBhY2NlbGVy
YXRlcyBFT0kgd3JpdGUgYW5kIGRvZXMgbm90IHRyYXAuDQo+PiArCSAqIFRoaXMgY2F1c2UgaW4t
a2VybmVsIFBJVCByZS1pbmplY3QgbW9kZSB0byBmYWlsDQo+PiArCSAqIHNpbmNlIGl0IGNoZWNr
cyBwcy0+aXJxX2FjayBiZWZvcmUga3ZtX3NldF9pcnEoKQ0KPj4gKwkgKiBhbmQgcmVsaWVzIG9u
IHRoZSBhY2sgbm90aWZpZXIgdG8gdGltZWx5IHF1ZXVlDQo+PiArCSAqIHRoZSBwdC0+d29ya2Vy
IHdvcmsgaXRlcm0gYW5kIHJlaW5qZWN0IHRoZSBtaXNzZWQgdGljay4NCj4+ICsJICogU28sIGRl
YWN0aXZhdGUgQVBJQ3Ygd2hlbiBQSVQgaXMgaW4gcmVpbmplY3QgbW9kZS4NCj4+ICsJICovDQo+
PiAgIAlpZiAocmVpbmplY3QpIHsNCj4+ICsJCWt2bV9yZXF1ZXN0X2FwaWN2X3VwZGF0ZShrdm0s
IGZhbHNlLCBBUElDVl9ERUFDVF9CSVRfUElUX1JFSU5KKTsNCj4+ICAgCQkvKiBUaGUgaW5pdGlh
bCBzdGF0ZSBpcyBwcmVzZXJ2ZWQgd2hpbGUgcHMtPnJlaW5qZWN0ID09IDAuICovDQo+PiAgIAkJ
a3ZtX3BpdF9yZXNldF9yZWluamVjdChwaXQpOw0KPj4gICAJCWt2bV9yZWdpc3Rlcl9pcnFfYWNr
X25vdGlmaWVyKGt2bSwgJnBzLT5pcnFfYWNrX25vdGlmaWVyKTsNCj4+ICAgCQlrdm1fcmVnaXN0
ZXJfaXJxX21hc2tfbm90aWZpZXIoa3ZtLCAwLCAmcGl0LT5tYXNrX25vdGlmaWVyKTsNCj4+ICAg
CX0gZWxzZSB7DQo+PiArCQlrdm1fcmVxdWVzdF9hcGljdl91cGRhdGUoa3ZtLCB0cnVlLCBBUElD
Vl9ERUFDVF9CSVRfUElUX1JFSU5KKTsNCj4+ICAgCQlrdm1fdW5yZWdpc3Rlcl9pcnFfYWNrX25v
dGlmaWVyKGt2bSwgJnBzLT5pcnFfYWNrX25vdGlmaWVyKTsNCj4+ICAgCQlrdm1fdW5yZWdpc3Rl
cl9pcnFfbWFza19ub3RpZmllcihrdm0sIDAsICZwaXQtPm1hc2tfbm90aWZpZXIpOw0KPiANCj4g
VGhpcyBpcyBub3QgdG9vIG5pY2UgZm9yIEludGVsIHdoaWNoIGRvZXMgc3VwcG9ydCAodGhyb3Vn
aCB0aGUgRU9JIGV4aXQNCj4gbWFzaykgQVBJQ3YgZXZlbiBpZiBQSVQgcmVpbmplY3Rpb24gYWN0
aXZlLg0KDQpJIHNlZSB5b3UgcG9pbnQuDQoNCj4gV2UgY2FuIHdvcmsgYXJvdW5kIGl0IGJ5IGFk
ZGluZyBhIGdsb2JhbCBtYXNrIG9mIGluaGliaXQgcmVhc29ucyB0aGF0DQo+IGFwcGx5IHRvIHRo
ZSB2ZW5kb3IsIGFuZCBpbml0aWFsaXppbmcgaXQgYXMgc29vbiBhcyBwb3NzaWJsZSBpbiB2bXgu
Yy9zdm0uYy4NCj4gDQo+IFRoZW4ga3ZtX3JlcXVlc3RfYXBpY3ZfdXBkYXRlIGNhbiBpZ25vcmUg
cmVhc29ucyB0aGF0IHRoZSB2ZW5kb3IgZG9lc24ndA0KPiBjYXJlIGFib3V0Lg0KPiANCj4gUGFv
bG8NCj4gDQoNCldoYXQgYWJvdXQgd2UgZW5oYW5jZSB0aGUgcHJlX3VwZGF0ZV9hcGl2Y19leGVj
X2N0cmwoKSB0byBhbHNvIHJldHVybiANCnN1Y2Nlc3MvZmFpbC4gSW4gaGVyZSwgdGhlIHZlbmRv
ciBzcGVjaWZpYyBjb2RlIGNhbiBkZWNpZGUgdG8gdXBkYXRlIA0KQVBJQ3Ygc3RhdGUgb3Igbm90
Lg0KDQpUaGFua3MsDQpTdXJhdmVlDQo=
