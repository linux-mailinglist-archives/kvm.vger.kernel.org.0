Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2DEB8F067
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 18:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730974AbfHOQZE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 12:25:04 -0400
Received: from mail-eopbgr710058.outbound.protection.outlook.com ([40.107.71.58]:6245
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729274AbfHOQZE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 12:25:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JgEyovWHEL7UY6B8MO6YZCAZ/tgFw8U62LaS/srQEVLuHTvaAmv6lr7uIZqE7RnL+SxLrT/qG/g8scHGI/u/eWXF3X9vXnaqv+GASElPcmAdX6YjhZmksr0gK93uusVADsTTwKwPV1ryZ+CdMnTlCicbrUCTNFcPXKGeV7LpWQgNOr5cxvSyBa9EWwgzwZprk4cQVwSSj1QjPTlqTM5KsasuVRw6iVrXngRd+rQObj8/lp71gpBVBI90Txm1hfQkEsBYTDJoRIZuhpzQPoVI2Ksc7YHRjOalE8EWxksHUCXZGgy2pmtaeJQarqWpb/itMD1pGUq9TiMajF18w/UqTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6T46YcPc7dhvHL8tL24LI+MybNG4SL9zPJ/0eN4Q8X4=;
 b=UFh+u+0Nk/+jla6j3NBWlXKRIJOoen+fgmGg0EzkVgNc+pjv5aD1yGlf+AfrCvZL/yQEykjLudW51BE52OMXydFG8uhyuQhgmeXBcZz6p1v2XIBFnpPnmkSuvpPCIN99P/JPRGbTJz3kuHgi8RCDAYNAHmk6JGwPWh/rFXZ1AuK4LHKuTnk6ltfUGxgeySINubOfYPI5PBm+5OSe4sx+kV49VsbBexb+ASxSbWtMNVa2f3h4nhHFhJqNoLdyVqmdV6GVxhUAJKnl91tm4Kbdq9bympckO5g6GfKwG2TFiT8+ASTHX3Oku7CVHVMTL/UMTQfdoh1ld4Lzm/KTPAe2lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6T46YcPc7dhvHL8tL24LI+MybNG4SL9zPJ/0eN4Q8X4=;
 b=39XyGycQMKDZHp2rjSAS0B6qJVHXR0hw8kDGvhhdjSoyeIpTfZDHv2izxk63aypvuoKqCJa19Vr3B7QHZPW97XYDxbmrp8i476mRdjettHcfIsf/Qa5xt0TOoI5UFthOw5GS/kj2p/UCDsvXeojyVatNW8wGUJKCllR6yrjggaU=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3897.namprd12.prod.outlook.com (10.255.174.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Thu, 15 Aug 2019 16:25:00 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::e95a:d3ee:e6a0:2825%7]) with mapi id 15.20.2157.022; Thu, 15 Aug 2019
 16:25:00 +0000
From:   "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "graf@amazon.com" <graf@amazon.com>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH v2 00/15] kvm: x86: Support AMD SVM AVIC w/ in-kernel irqchip
 mode
Thread-Topic: [PATCH v2 00/15] kvm: x86: Support AMD SVM AVIC w/ in-kernel
 irqchip mode
Thread-Index: AQHVU4X8OLUbTY6KtUOjhfBM714iZw==
Date:   Thu, 15 Aug 2019 16:25:00 +0000
Message-ID: <1565886293-115836-1-git-send-email-suravee.suthikulpanit@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [165.204.78.1]
x-clientproxiedby: SN6PR04CA0084.namprd04.prod.outlook.com
 (2603:10b6:805:f2::25) To DM6PR12MB2844.namprd12.prod.outlook.com
 (2603:10b6:5:45::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 1.8.3.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 811129f8-b982-4e6d-8995-08d7219d1e8a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3897;
x-ms-traffictypediagnostic: DM6PR12MB3897:
x-ms-exchange-purlcount: 2
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3897B937AC0BF55F43AD1743F3AC0@DM6PR12MB3897.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1751;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(199004)(189003)(478600001)(8936002)(66476007)(3846002)(6436002)(53936002)(50226002)(316002)(66556008)(36756003)(66946007)(6116002)(64756008)(6306002)(102836004)(66446008)(386003)(6506007)(6512007)(2616005)(186003)(66066001)(81166006)(486006)(25786009)(81156014)(26005)(99286004)(14444005)(2501003)(8676002)(476003)(7736002)(256004)(14454004)(5660300002)(52116002)(4720700003)(71200400001)(71190400001)(2906002)(110136005)(54906003)(4326008)(305945005)(86362001)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3897;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PBuFzZ+Pn6kH8VxaULBsWp35vkZ24vN+7btKrVCg06TV2sF4mHb0+WitfB5mMPq+O4E7pRYt4X9F3XYjffoQtX03H4rQgCytxgNUZHiTOMzWdeGP3Tx5/kHT1J5MR75T9Yr17Erdp0IKb8esqmztMjF+KvnH/j5Hzm5jz4VbvbcUgBPhKAU3fdyEEjqVUAWj+shz0F6CsEBw0IF7z/nQIIc9ALOSzd7w+2l7BOdnoBiaKG3OtUUFDXQvnGYNUjkUY7+HxeRxlOgoAUGZGdnUIK7ufoc7gDmRGs+P85ele0hQKsTV4aTGwjhQNrXz6Z2qpZte3To/oMmlj6SH78pwFJXQ26bAg3uMPBN+2Ac6lQPVeQ/lKXiLeLG8p3MrOHfF85Q90f/6W4GW4Pu2bXl1odTEmJrtVlBz92XIQFAez9k=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6AC743E7C44C6745BE1861931A903A69@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 811129f8-b982-4e6d-8995-08d7219d1e8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 16:25:00.4620
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YNtY6yOra+T7+PK1zFbR55RCibTRcrdsK48GcZjWY/gnnIwSO6WoZ+2vptL0P0TgSiEEkdg85EAe/O09wGNMgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3897
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VGhlICdjb21taXQgNjcwMzRiYjlkZDVlICgiS1ZNOiBTVk06IEFkZCBpcnFjaGlwX3NwbGl0KCkg
Y2hlY2tzIGJlZm9yZQ0KZW5hYmxpbmcgQVZJQyIpJyB3YXMgaW50cm9kdWNlZCB0byBmaXggbWlz
Y2VsbGFuZW91cyBib290LWhhbmcgaXNzdWVzDQp3aGVuIGVuYWJsZSBBVklDLiBUaGlzIGlzIG1h
aW5seSBkdWUgdG8gQVZJQyBoYXJkd2FyZSBkb2VzdCBub3QgI3ZtZXhpdA0Kb24gd3JpdGUgdG8g
TEFQSUMgRU9JIHJlZ2lzdGVyIHJlc3VsdGluZyBpbi1rZXJuZWwgUElDIGFuZCBJT0FQSUMgdG8N
CndhaXQgYW5kIGRvIG5vdCBpbmplY3QgbmV3IGludGVycnVwdHMgKGUuZy4gUElUKS4NCg0KVGhp
cyBsaW1pdHMgQVZJQyB0byBvbmx5IHdvcmsgd2l0aCBrZXJuZWxfaXJxY2hpcD1zcGxpdCBtb2Rl
LCB3aGljaCBpcw0Kbm90IGN1cnJlbnRseSBlbmFibGVkIGJ5IGRlZmF1bHQsIGFuZCBhbHNvIHJl
cXVpcmVkIHVzZXItc3BhY2UgdG8NCnN1cHBvcnQgc3BsaXQgaXJxY2hpcCBtb2RlbCwgd2hpY2gg
bWlnaHQgbm90IGJlIHRoZSBjYXNlLg0KDQpUaGUgZ29hbCBvZiB0aGlzIHNlcmllcyBpcyB0byBl
bmFibGUgQVZJQyB0byB3b3JrIGluIGJvdGggaXJxY2hpcCBtb2Rlcy4NCmJ5IGFsbG93aW5nIEFW
SUMgdG8gYmUgZGVhY3RpdmF0ZWQgdGVtcG9yYXJ5IGR1cmluZyBydW50aW1lIGFuZCBmYWxsYmFj
aw0KdG8gbGVnYWN5IGludGVycnVwdCBpbmplY3Rpb24gbW9kZSAody8gdklOVFIgYW5kIGludGVy
cnVwdCB3aW5kb3dzKQ0Kd2hlbiBuZWVkZWQsIGFuZCB0aGVuIHJlLWVuYWJsZWQgc3Vic2VxZW50
bHkuDQoNClNpbWlsYXIgYXBwcm9hY2ggaXMgYWxzbyB1c2VkIHRvIGhhbmRsZSBIeXBlci1WIFN5
bklDIGluIHRoZQ0KJ2NvbW1pdCA1YzkxOTQxMmZlNjEgKCJrdm0veDg2OiBIeXBlci1WIHN5bnRo
ZXRpYyBpbnRlcnJ1cHQgY29udHJvbGxlciIpJywNCndoZXJlIEFQSUN2IGlzIHBlcm1hbmVudGx5
IGRpc2FibGVkIGF0IHJ1bnRpbWUgKGN1cnJlbnRseSBicm9rZW4gZm9yDQpBVklDLCBhbmQgZml4
ZWQgYnkgdGhpcyBzZXJpZXMpLiANCg0KSW4gYWRkaXRpb24sIGN1cnJlbnRseSB3aGVuIEtWTSBk
aXNhYmxlcyBBUElDdiAoZS5nLiBydW5uaW5nIHdpdGgNCmtlcm5lbF9pcnFjaGlwPW9uIG1vZGUg
b24gQU1ELCBvciBkdWUgdG8gSHlwZXItViBTeW5jSUMgbW9kZSksIHRoaXMgaGFwcGVucw0KdW5k
ZXIgdGhlIGhvb2QgYW5kIG9mdGVuIGNhdXNlIGNvbmZ1c2lvbiB0byB1c2Vycy4gVGhpcyB3aWxs
IGJlIGFkZHJlc3NlZA0KaW4gcGFydCAxIG9mIHRoaXMgc2VyaWVzLg0KDQpUaGlzIHNlcmllcyBj
b250YWlucyB0aHJlZSBwYXJ0czoNCiAgKiBQYXJ0IDE6IHBhdGNoIDEtNA0KICAgICBJbnRyb2R1
Y2UgQVBJQ3Ygc3RhdGUgZW51bSBhbmQgbG9naWMgZm9yIGtlZXBpbmcgdHJhY2sgb2YgdGhlIHN0
YXRlDQogICAgIGZvciBlYWNoIHZtLCBhbG9uZyB3aXRoIGRlYnVnZnMgZm9yIGNoZWNraW5nIHRv
IHNlZSBpZiBBUElDdiBpcw0KICAgICBlbmFibGVkIGZvciBhIHBhcnRpY3VsYXIgdm0uDQoNCiAg
KiBQYXJ0IDI6IHBhdGNoIDUtMTENCiAgICAgQWRkIHN1cHBvcnQgZm9yIGFjdGl2YXRlL2RlYWN0
aXZhdGUgQVBJQ3YgYXQgcnVudGltZQ0KDQogICogUGFydCAzOiBwYXRjaCAxMi0xNToNCiAgICAg
UHJvdmlkZSB3b3JrYXJvdW5kIGZvciBBVklDIEVPSSBhbmQgYWxsb3cgZW5hYmxlIEFWSUMgdy8N
CiAgICAga2VybmVsX2lycWNoaXA9b24NCg0KUHJlLXJlcXVpc2l0ZSBQYXRjaDoNCiAgKiBjb21t
aXQgYjljNmZmOTRlNDNhICgiaW9tbXUvYW1kOiBSZS1mYWN0b3IgZ3Vlc3QgdmlydHVhbCBBUElD
DQogICAgKGRlLSlhY3RpdmF0aW9uIGNvZGUiKQ0KICAgIChodHRwczovL2dpdC5rZXJuZWwub3Jn
L3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9qb3JvL2lvbW11LmdpdC9jb21taXQvDQogICAgID9o
PW5leHQmaWQ9YjljNmZmOTRlNDNhMGVlMDUzZTBjMWQ5ODNmYmExYWM0OTUzYjc2MikNCg0KVGhp
cyBzZXJpZXMgaGFzIGJlZW4gdGVzdGVkIGFnYWluc3QgdjUuMiBhcyBmb2xsb3dpbmc6DQogICog
Qm9vdGluZyBMaW51eCwgRnJlZUJTRCwgYW5kIFdpbmRvd3MgU2VydmVyIDIwMTkgVk1zIHVwdG8g
MjU1IHZDUFVzDQogICAgdy8gcWVtdSBvcHRpb24gImtlcm5lbC1pcnFjaGlwPW9uIiBhbmQgIi1u
by1ocGV0Ii4NCiAgKiBQYXNzLXRocm91Z2ggSW50ZWwgMTBHYkUgTklDIGFuZCBydW4gbmV0cGVy
ZiBpbiB0aGUgVk0uDQoNCkNoYW5nZXMgZnJvbSBWMTogKGh0dHBzOi8vbGttbC5vcmcvbGttbC8y
MDE5LzMvMjIvMTA0MikNCiAgKiBJbnRyb2R1Y2UgQVBJQ3Ygc3RhdGUgZW51bWVyYXRpb24NCiAg
KiBJbnRyb2R1Y2UgS1ZNIGRlYnVnZnMgZm9yIEFQSUN2IHN0YXRlDQogICogQWRkIHN5bmNocm9u
aXphdGlvbiBsb2dpYyBmb3IgQVBJQ3Ygc3RhdGUgdG8gcHJldmVudCBwb3RlbnRpYWwNCiAgICBy
YWNlIGNvbmRpdGlvbiAocGVyIEphbidzIHN1Z2dlc3Rpb24pDQogICogQWRkIHN1cHBvcnQgZm9y
IGFjdGl2YXRlL2RlYWN0aXZhdGUgcG9zdGVkIGludGVycnVwdA0KICAgIChwZXIgSmFuJ3Mgc3Vn
Z2VzdGlvbikNCiAgKiBSZW1vdmUgY2FsbGJhY2sgZnVuY3Rpb25zIGZvciBoYW5kbGluZyBBUElD
IElELCBERlIgYW5kIExEUiB1cGRhdGUNCiAgICAocGVyIFBhb2xvJ3Mgc3VnZ2VzdGlvbikNCiAg
KiBBZGQgd29ya2Fyb3VuZCBmb3IgaGFuZGxpbmcgRU9JIGZvciBpbi1rZXJuZWwgUElUIGFuZCBJ
T0FQSUMuDQoNClN1cmF2ZWUgU3V0aGlrdWxwYW5pdCAoMTUpOg0KICBrdm06IHg4NjogTW9kaWZ5
IGt2bV94ODZfb3BzLmdldF9lbmFibGVfYXBpY3YoKSB0byB1c2Ugc3RydWN0IGt2bQ0KICAgIHBh
cmFtZXRlcg0KICBrdm06IHg4NjogSW50cm9kdWNlIEtWTSBBUElDdiBzdGF0ZQ0KICBrdm06IEFk
ZCBhcmNoLXNwZWNpZmljIHBlci1WTSBkZWJ1Z2ZzIHN1cHBvcnQNCiAga3ZtOiB4ODY6IEFkZCBw
ZXItVk0gQVBJQ3Ygc3RhdGUgZGVidWdmcw0KICBrdm06IGxhcGljOiBJbnRyb2R1Y2UgQVBJQ3Yg
dXBkYXRlIGhlbHBlciBmdW5jdGlvbg0KICBrdm06IHg4NjogQWRkIHN1cHBvcnQgZm9yIGFjdGl2
YXRlL2RlLWFjdGl2YXRlIEFQSUN2IGF0IHJ1bnRpbWUNCiAga3ZtOiB4ODY6IHN2bTogQWRkIHN1
cHBvcnQgdG8gYWN0aXZhdGUvZGVhY3RpdmF0ZSBwb3N0ZWQgaW50ZXJydXB0cw0KICBzdm06IEFk
ZCBzdXBwb3J0IGZvciBzZXR1cC9kZXN0cm95IHZpcnV0YWwgQVBJQyBiYWNraW5nIHBhZ2UgZm9y
IEFWSUMNCiAgc3ZtOiBBZGQgc3VwcG9ydCBmb3IgYWN0aXZhdGUvZGVhY3RpdmF0ZSBBVklDIGF0
IHJ1bnRpbWUNCiAga3ZtOiB4ODY6IGh5cGVydjogVXNlIEFQSUN2IGRlYWN0aXZhdGUgcmVxdWVz
dCBpbnRlcmZhY2UNCiAgc3ZtOiBUZW1wb3JhcnkgZGVhY3RpdmF0ZSBBVklDIGR1cmluZyBFeHRJ
TlQgaGFuZGxpbmcNCiAga3ZtOiBpODI1NDogQ2hlY2sgTEFQSUMgRU9JIHBlbmRpbmcgd2hlbiBp
bmplY3RpbmcgaXJxIG9uIFNWTSBBVklDDQogIGt2bTogbGFwaWM6IENsZWFuIHVwIEFQSUMgcHJl
ZGVmaW5lZCBtYWNyb3MNCiAga3ZtOiBpb2FwaWM6IERlbGF5IHVwZGF0ZSBJT0FQSUMgRU9JIGZv
ciBSVEMNCiAgc3ZtOiBBbGxvdyBBVklDIHdpdGggaW4ta2VybmVsIGlycWNoaXAgbW9kZQ0KDQog
YXJjaC9taXBzL2t2bS9taXBzLmMgICAgICAgICAgICB8ICAgNSArKw0KIGFyY2gvcG93ZXJwYy9r
dm0vcG93ZXJwYy5jICAgICAgfCAgIDUgKysNCiBhcmNoL3MzOTAva3ZtL2t2bS1zMzkwLmMgICAg
ICAgIHwgICA1ICsrDQogYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaCB8ICAyNiArKysr
Ky0NCiBhcmNoL3g4Ni9rdm0vZGVidWdmcy5jICAgICAgICAgIHwgIDI3ICsrKysrKysNCiBhcmNo
L3g4Ni9rdm0vaHlwZXJ2LmMgICAgICAgICAgIHwgIDEyICsrLQ0KIGFyY2gveDg2L2t2bS9pODI1
NC5jICAgICAgICAgICAgfCAgMzEgKysrKystLQ0KIGFyY2gveDg2L2t2bS9pb2FwaWMuYyAgICAg
ICAgICAgfCAgMzYgKysrKysrKystDQogYXJjaC94ODYva3ZtL2xhcGljLmMgICAgICAgICAgICB8
ICAzNSArKysrKy0tLQ0KIGFyY2gveDg2L2t2bS9sYXBpYy5oICAgICAgICAgICAgfCAgIDIgKw0K
IGFyY2gveDg2L2t2bS9zdm0uYyAgICAgICAgICAgICAgfCAxNzMgKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKy0tLQ0KIGFyY2gveDg2L2t2bS92bXgvdm14LmMgICAgICAgICAg
fCAgIDIgKy0NCiBhcmNoL3g4Ni9rdm0veDg2LmMgICAgICAgICAgICAgIHwgIDk2ICsrKysrKysr
KysrKysrKysrKysrKy0NCiBpbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmggICAgICAgIHwgICAxICsN
CiB2aXJ0L2t2bS9hcm0vYXJtLmMgICAgICAgICAgICAgIHwgICA1ICsrDQogdmlydC9rdm0va3Zt
X21haW4uYyAgICAgICAgICAgICB8ICAgMiArLQ0KIDE2IGZpbGVzIGNoYW5nZWQsIDQyMSBpbnNl
cnRpb25zKCspLCA0MiBkZWxldGlvbnMoLSkNCg0KLS0gDQoxLjguMy4xDQoNCg==
