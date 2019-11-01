Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34753ECB99
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 23:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbfKAWl1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 18:41:27 -0400
Received: from mail-eopbgr720065.outbound.protection.outlook.com ([40.107.72.65]:49770
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727029AbfKAWl1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 18:41:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jOBb4F5gTdTHAeHvgDDJB4YJuF9u2NOsrPsC8X4tNqf3+QGrBAXkUTi9MOwl/1n2TuJmT+ugz8LN8Yoes95XW9bWZBk2tCfSrovcodSKnaiWy4CB2Xu1aGB9FPl0tizzJem5dOMfML+1XBUrovXntJM1G+TyzBgm0PTVmmx6VkDD8JISmguQ+N1Lo7k9iniP1XA0l3df0F0GUr+n/os4I9xpvcsfAlFQU1EP1maDOTBClnam9RHjZPb4W2frFgf7HLyE6wO6F3Y2l1E7CWVy+9U9i+Cbx502UZWHfbftN/pJviodwq+vqMWOB91QfujuDxNYBpFrD5Vho3Pd2yBZcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pIpksEIacLQcGqwrLOjQ3oi61X6LlqCS4MXDFkZ6/VY=;
 b=Rb2DKFicP4vhZP/3S8dHzwmZtcbWpPF0UExAXsYRR8AGdQAKm24pn45Ro96ZLRjrG+pLVwv7ru/M3oR5TdYu/OeYEM3tEmoGlru8xU0hE5EbmhpGp82DxvIayuVtybSY/IxMK/q5VOIe+3iol97QSSSurrEBmBKOe//wPrnFUtPTIVX/6UkrfJevPYUd7LZmeNhBn1rof/Q4CARSXj5tM/ZMIxrDLuH1y2s3QRajJQ7s3M/+bFPfIpefJzi95TZdOt67y7eDISp+M2RGHkmS3BesB2dLU+X0rqWyzqvyqR78oWU1wPOGtupEZFWmuBRE3WNgjpdUHfXbpCV5tZ+/9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pIpksEIacLQcGqwrLOjQ3oi61X6LlqCS4MXDFkZ6/VY=;
 b=oQ5hDg90jh0weV1wil8fusnbTs5IQD89lzlqqrVYXTCrOvBVdMXgpZz0gEJMVSRY9w5dKmG7qHIF1SqRLheDc2qATNX7eJC9QVru9oh1KwkHkyPT3dFx94qgkdWt8lfN/ui+7OhKaR0z5qSJ0XA62c2AQjC8z7QruXrVO/8J+Og=
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3243.namprd12.prod.outlook.com (20.179.105.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 1 Nov 2019 22:41:22 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 22:41:22 +0000
From:   "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "rkagan@virtuozzo.com" <rkagan@virtuozzo.com>,
        "graf@amazon.com" <graf@amazon.com>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH v4 00/17] kvm: x86: Support AMD SVM AVIC w/ in-kernel irqchip
 mode
Thread-Topic: [PATCH v4 00/17] kvm: x86: Support AMD SVM AVIC w/ in-kernel
 irqchip mode
Thread-Index: AQHVkQV87nIRXYvD70eAN6/11mAloQ==
Date:   Fri, 1 Nov 2019 22:41:22 +0000
Message-ID: <1572648072-84536-1-git-send-email-suravee.suthikulpanit@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [165.204.78.1]
x-clientproxiedby: SN1PR12CA0047.namprd12.prod.outlook.com
 (2603:10b6:802:20::18) To DM6PR12MB3865.namprd12.prod.outlook.com
 (2603:10b6:5:1c8::18)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 1.8.3.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c877bc34-4629-4515-59ad-08d75f1c9e9b
x-ms-traffictypediagnostic: DM6PR12MB3243:
x-ms-exchange-purlcount: 2
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB32439EBFBD7287903C409504F3620@DM6PR12MB3243.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1247;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(366004)(376002)(39860400002)(136003)(199004)(189003)(66476007)(66446008)(26005)(6506007)(386003)(86362001)(5660300002)(102836004)(4720700003)(305945005)(7736002)(7416002)(256004)(14444005)(8936002)(8676002)(186003)(52116002)(6486002)(478600001)(50226002)(71200400001)(71190400001)(81166006)(6436002)(476003)(6306002)(2906002)(3846002)(6116002)(6512007)(99286004)(4326008)(2616005)(316002)(486006)(81156014)(14454004)(66946007)(36756003)(110136005)(54906003)(66066001)(64756008)(66556008)(25786009)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3243;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bWiGoPPz+pIE1csKJ52L6oFgO8RAj+s5a6E5MrY7XPdXGmUEyPXacHXmIpuTJOTV9m4JD93YfYAr2Kl+nkbI48KuFvnlC0B2mccvRKO9OIXf5BzeIWfuyh54BB490xDf4EOz/ID5P5ojUmMlcVfOJlUM4Uk1l//PTDotVZa47UqzCYvWJcd4fsxieoU3zKY5BvNWZnIn8AeVCPOwyQ8hpbz92lU18hhBWUvUFx+KVCMKj5DHxOc8XaoSEq5eFFmZ6+Zw+3ysF2KJ1MeYb/7P/Tm4oChPx2PO5nDbVHAZMDIWpWxfBG8JfoFEM0ERc9phyKfFaykN3b90LeVvnyIsUxai8E/6DnO9/NOG4LtRu/uQtXv6AuNend0ou0o3EtrZBZphZUR+otlaAlNU+urfLRkvDSLc99XuTzCW+Fdnad+JBJ/r1/8vXinFENcQAHMPHsp6sPNA8nxaatqI5Yb4iMKmy69YMTlWstgvIerUSZU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EEEDE0C18170D54C80BC453F68451A6F@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c877bc34-4629-4515-59ad-08d75f1c9e9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 22:41:22.3257
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D1BfOTxe7SrNjfaA0ZLQ+H1rZYU8FGZK7CipjLLlsrB56lnrIF5qqUHp2GcQcJDw7sy+FyAj7mi31QiDnzkeow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3243
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VGhlICdjb21taXQgNjcwMzRiYjlkZDVlICgiS1ZNOiBTVk06IEFkZCBpcnFjaGlwX3NwbGl0KCkg
Y2hlY2tzIGJlZm9yZQ0KZW5hYmxpbmcgQVZJQyIpJyB3YXMgaW50cm9kdWNlZCB0byBmaXggbWlz
Y2VsbGFuZW91cyBib290LWhhbmcgaXNzdWVzDQp3aGVuIGVuYWJsZSBBVklDLiBUaGlzIGlzIG1h
aW5seSBkdWUgdG8gQVZJQyBoYXJkd2FyZSBkb2VzdCBub3QgI3ZtZXhpdA0Kb24gd3JpdGUgdG8g
TEFQSUMgRU9JIHJlZ2lzdGVyIHJlc3VsdGluZyBpbi1rZXJuZWwgUElDIGFuZCBJT0FQSUMgdG8N
CndhaXQgYW5kIGRvIG5vdCBpbmplY3QgbmV3IGludGVycnVwdHMgKGUuZy4gUElULCBSVEMpLg0K
DQpUaGlzIGxpbWl0cyBBVklDIHRvIG9ubHkgd29yayB3aXRoIGtlcm5lbF9pcnFjaGlwPXNwbGl0
IG1vZGUsIHdoaWNoIGlzDQpub3QgY3VycmVudGx5IGVuYWJsZWQgYnkgZGVmYXVsdCwgYW5kIGFs
c28gcmVxdWlyZWQgdXNlci1zcGFjZSB0bw0Kc3VwcG9ydCBzcGxpdCBpcnFjaGlwIG1vZGVsLCB3
aGljaCBtaWdodCBub3QgYmUgdGhlIGNhc2UuDQoNClRoZSBnb2FsIG9mIHRoaXMgc2VyaWVzIGlz
IHRvIGVuYWJsZSBBVklDIHRvIHdvcmsgaW4gYm90aCBpcnFjaGlwIG1vZGVzLA0KYnkgYWxsb3dp
bmcgQVZJQyB0byBiZSBkZWFjdGl2YXRlZCB0ZW1wb3JhcmlseSBkdXJpbmcgcnVudGltZSwgYW5k
IGZhbGxiYWNrDQp0byBsZWdhY3kgaW50ZXJydXB0IGluamVjdGlvbiBtb2RlICh3LyB2SU5UUiBh
bmQgaW50ZXJydXB0IHdpbmRvd3MpDQp3aGVuIG5lZWRlZCwgYW5kIHRoZW4gcmUtZW5hYmxlZCBz
dWJzZXF1ZW50bHkuDQoNClNpbWlsYXIgYXBwcm9hY2ggaXMgYWxzbyB1c2VkIHRvIGhhbmRsZSBI
eXBlci1WIFN5bklDIGluIHRoZQ0KJ2NvbW1pdCA1YzkxOTQxMmZlNjEgKCJrdm0veDg2OiBIeXBl
ci1WIHN5bnRoZXRpYyBpbnRlcnJ1cHQgY29udHJvbGxlciIpJywNCndoZXJlIEFQSUN2IGlzIHBl
cm1hbmVudGx5IGRpc2FibGVkIGF0IHJ1bnRpbWUgKGN1cnJlbnRseSBicm9rZW4gZm9yDQpBVklD
LCBhbmQgZml4ZWQgYnkgdGhpcyBzZXJpZXMpLiANCg0KVGhpcyBzZXJpZXMgY29udGFpbnMgc2Vy
dmVyYWwgcGFydHM6DQogICogUGFydCAxOiBwYXRjaCAxLDINCiAgICBDb2RlIGNsZWFuIHVwLCBy
ZWZhY3RvciwgYW5kIGludHJvZHVjZSBoZWxwZXIgZnVudGlvbnMNCg0KICAqIFBhcnQgMjogcGF0
Y2ggMyANCiAgICBJbnRyb2R1Y2UgQVBJQ3YgZGVhY3RpdmF0ZSBiaXRzIHRvIGtlZXAgdHJhY2sg
b2YgQVBJQ3Ygc3RhdGUgDQogICAgZm9yIGVhY2ggdm0uDQogDQogICogUGFydCAzOiBwYXRjaCA0
LTkNCiAgICBBZGQgc3VwcG9ydCBmb3IgYWN0aXZhdGUvZGVhY3RpdmF0ZSBBUElDdiBhdCBydW50
aW1lDQoNCiAgKiBQYXJ0IDQ6IHBhdGNoIDEwLTEzOg0KICAgIEFkZCBzdXBwb3J0IHZhcmlvdXMg
Y2FzZXMgd2hlcmUgQVBJQ3YgbmVlZHMgdG8gYmUgZGVhY3RpdmF0ZWQNCg0KICAqIFBhcnQgNTog
cGF0Y2ggMTQtMTY6DQogICAgSW50cm9kdWNlIGluLWtlcm5lbCBJT0FQSUMgd29ya2Fyb3VuZCBm
b3IgQVZJQyBFT0kNCg0KICAqIFBhcnQgNjogcGF0aCAxNw0KICAgIEFsbG93IGVuYWJsZSBBVklD
IHcvIGtlcm5lbF9pcnFjaGlwPW9uDQoNClByZS1yZXF1aXNpdGUgUGF0Y2g6DQogICogY29tbWl0
IGI5YzZmZjk0ZTQzYSAoImlvbW11L2FtZDogUmUtZmFjdG9yIGd1ZXN0IHZpcnR1YWwgQVBJQyAo
ZGUtKWFjdGl2YXRpb24gY29kZSIpDQogICAgKGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3Nj
bS9saW51eC9rZXJuZWwvZ2l0L2pvcm8vaW9tbXUuZ2l0L2NvbW1pdC8NCiAgICAgP2g9bmV4dCZp
ZD1iOWM2ZmY5NGU0M2EwZWUwNTNlMGMxZDk4M2ZiYTFhYzQ5NTNiNzYyKQ0KDQpUaGlzIHNlcmll
cyBoYXMgYmVlbiB0ZXN0ZWQgYWdhaW5zdCB2NS4zIGFzIGZvbGxvd2luZzoNCiAgKiBCb290aW5n
IExpbnV4IGFuZCBXaW5kb3dzIFNlcnZlciAyMDE5IFZNcyB1cHRvIDI0MCB2Y3B1cw0KICAgIGFu
ZCBGcmVlQlNEIHVwdG8gMTI4IHZjcHVzIHcvIHFlbXUgb3B0aW9uICJrZXJuZWwtaXJxY2hpcD1v
biINCiAgICBhbmQgIi1uby1ocGV0Ii4NCiAgKiBQYXNzLXRocm91Z2ggSW50ZWwgMTBHYkUgTklD
IGFuZCBydW4gbmV0cGVyZiBpbiB0aGUgVk0uDQoNCkNoYW5nZXMgZnJvbSBWMzogKGh0dHBzOi8v
bGttbC5vcmcvbGttbC8yMDE5LzkvMTMvODcxKQ0KKFBlciBQYW9sbyBjb21tZW50cykgDQogICog
UmVwbGFjZSBzdHJ1Y3Qga3ZtX3ZjcHUgd2l0aCBzdHJ1Y3Qga3ZtIGluIHZhcmlvdXMgaW50ZXJm
YWNlcw0KICAqIFJlcGxhY2UgS1ZNX1JFUV9BUElDVl9BQ1RJVkFURS9ERUFDVElWQVRFIHdpdGgg
S1ZNX1JFUV9BUElDVl9VUERBVEUgcmVxdWVzdA0KICAqIFJlcGxhY2UgQVBJQ3Ygc3RhdGUgZW51
bSAoaW50cm9kdWNlZCBpbiBWMykgdy8gZGVhY3RpdmF0ZSBiaXRzIHRvIHRyYWNrIEFQSUN2IHN0
YXRlDQogICogUmVtb3ZlIGt2bV9hcGljdl9lb2lfYWNjZWxlcmF0ZSgpIChpbnRyb2R1Y2VkIGlu
IFYzKQ0KICAqIERlYWN0aXZhdGUgQVBJQ3Ygd2hlbiB1c2luZyBQSVQgcmUtaW5qZWN0IG1vZGUN
CiAgKiBDb25zb2xpZGF0ZSBzcmN1X3JlYWRfdW5sb2NrL2xvY2sgaW50byBzdm1fcmVxdWVzdF91
cGRhdGVfYXZpYygpDQoNClN1cmF2ZWUgU3V0aGlrdWxwYW5pdCAoMTcpOg0KICBrdm06IHg4Njog
TW9kaWZ5IGt2bV94ODZfb3BzLmdldF9lbmFibGVfYXBpY3YoKSB0byB1c2Ugc3RydWN0IGt2bSBw
YXJhbWV0ZXINCiAga3ZtOiBsYXBpYzogSW50cm9kdWNlIEFQSUN2IHVwZGF0ZSBoZWxwZXIgZnVu
Y3Rpb24NCiAga3ZtOiB4ODY6IEludHJvZHVjZSBBUElDdiBkZWFjdGl2YXRlIGJpdHMNCiAga3Zt
OiB4ODY6IEFkZCBzdXBwb3J0IGZvciBhY3RpdmF0ZS9kZS1hY3RpdmF0ZSBBUElDdiBhdCBydW50
aW1lDQogIGt2bTogeDg2OiBBZGQgQVBJQ3YgYWN0aXZhdGUvZGVhY3RpdmF0ZSByZXF1ZXN0IHRy
YWNlIHBvaW50cw0KICBrdm06IHg4Njogc3ZtOiBBZGQgc3VwcG9ydCB0byBhY3RpdmF0ZS9kZWFj
dGl2YXRlIHBvc3RlZCBpbnRlcnJ1cHRzDQogIHN2bTogQWRkIHN1cHBvcnQgZm9yIHNldHVwL2Rl
c3Ryb3kgdmlydXRhbCBBUElDIGJhY2tpbmcgcGFnZSBmb3IgQVZJQw0KICBrdm06IHg4NjogSW50
cm9kdWNlIEFQSUN2IHByZS11cGRhdGUgaG9vaw0KICBzdm06IEFkZCBzdXBwb3J0IGZvciBhY3Rp
dmF0ZS9kZWFjdGl2YXRlIEFWSUMgYXQgcnVudGltZQ0KICBrdm06IHg4NjogaHlwZXJ2OiBVc2Ug
QVBJQ3YgdXBkYXRlIHJlcXVlc3QgaW50ZXJmYWNlDQogIHN2bTogRGVhY3RpdmF0ZSBBVklDIHdo
ZW4gbGF1bmNoaW5nIGd1ZXN0IHdpdGggbmVzdGVkIFNWTSBzdXBwb3J0DQogIHN2bTogVGVtcG9y
YXJ5IGRlYWN0aXZhdGUgQVZJQyBkdXJpbmcgRXh0SU5UIGhhbmRsaW5nDQogIGt2bTogaTgyNTQ6
IERlYWN0aXZhdGUgQVBJQ3Ygd2hlbiB1c2luZyBpbi1rZXJuZWwgUElUIHJlLWluamVjdGlvbiBt
b2RlLg0KICBrdm06IGxhcGljOiBDbGVhbiB1cCBBUElDIHByZWRlZmluZWQgbWFjcm9zDQogIGt2
bTogaW9hcGljOiBSZWZhY3RvciBrdm1faW9hcGljX3VwZGF0ZV9lb2koKQ0KICBrdm06IGlvYXBp
YzogTGF6eSB1cGRhdGUgSU9BUElDIEVPSQ0KICBzdm06IEFsbG93IEFWSUMgd2l0aCBpbi1rZXJu
ZWwgaXJxY2hpcCBtb2RlDQoNCiBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oIHwgIDE4
ICsrKystDQogYXJjaC94ODYva3ZtL2h5cGVydi5jICAgICAgICAgICB8ICAgNSArLQ0KIGFyY2gv
eDg2L2t2bS9pODI1NC5jICAgICAgICAgICAgfCAgMTAgKysrDQogYXJjaC94ODYva3ZtL2lvYXBp
Yy5jICAgICAgICAgICB8IDE0OSArKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0t
LS0tDQogYXJjaC94ODYva3ZtL2xhcGljLmMgICAgICAgICAgICB8ICAzNSArKysrKystLS0tDQog
YXJjaC94ODYva3ZtL2xhcGljLmggICAgICAgICAgICB8ICAgMiArDQogYXJjaC94ODYva3ZtL3N2
bS5jICAgICAgICAgICAgICB8IDEzNiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0t
LS0NCiBhcmNoL3g4Ni9rdm0vdHJhY2UuaCAgICAgICAgICAgIHwgIDE5ICsrKysrDQogYXJjaC94
ODYva3ZtL3ZteC92bXguYyAgICAgICAgICB8ICAgNiArLQ0KIGFyY2gveDg2L2t2bS94ODYuYyAg
ICAgICAgICAgICAgfCAgNjEgKysrKysrKysrKysrKy0tLQ0KIDEwIGZpbGVzIGNoYW5nZWQsIDM0
MyBpbnNlcnRpb25zKCspLCA5OCBkZWxldGlvbnMoLSkNCg0KLS0gDQoxLjguMy4xDQoNCg==
