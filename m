Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD372B2584
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 21:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388321AbfIMTAz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 15:00:55 -0400
Received: from mail-eopbgr820057.outbound.protection.outlook.com ([40.107.82.57]:58712
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730118AbfIMTAy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 15:00:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j+bqGlrTS7eVs6ewi/IOHz/O1sBoeY9ehwqwXySMSqGR3NH+tahhC9ClyEdFQAF1tEQuLdbB8PAhDW8eJht4FfH46LF9p8UKija1NBtFcmbiVzNWEjwDNJ8usGklUcdi2jiamjpDD67fNAlO208tOWGLVCdNaQ4a1toFQvSaLUXAc9T0CKAwYehZwkH9hJVqiRq8iLQ/WAFbTon7+n1biVYM99frkgqMCvSyNuJtprIqdJVs/B87lco2lamrQ8Xbt47BRyJr7ukFM5QFV+kp/2x9SiATcbLG4d9V/9fTllYYllgAslDcgcWXPbGHGztWmMGnawGK87nbfEtSzk+CAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LJjg+xGFnIZYniI7cQgYICURDGNtboMJYL34yLv3hK8=;
 b=dijOuncCILBuIJdBMCaBf0HIVaUU4pdKtpuLP4SRibu48NQYeUSsil9cNJKjEd5RcmA1XTIT8F0cXJoa2hv0x++k3SX2K9ZBdIZd8EYZoAFGoI39YjiLFeC9+ffAOQk15s62XQq0JPU6InfuofNG+zFXcagjgdx8FvorvcHQ+WgnKRgU+zZP/JZARPHV6RTF3D1k+m+MqM8v9lEWZ3tTgdpvF6Nrz/yFlA+N4DjI8hgTr3pwrLlB9lYJkcrMMb8DQfWgoSpy3m+1TQ5XHrAeKA4MCxABUcDoTarZueuEk+PB+GM+vHok7m00MpPWGKA+8ac3OFHWCx+2nJxwPa7x8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LJjg+xGFnIZYniI7cQgYICURDGNtboMJYL34yLv3hK8=;
 b=dImAT+oySwlrcmfQSr9ZOK4Bmg5SKukutShRUtdXHsWPNkCEWajDY3Jc7KYwnQ1rVpB2GqnMflyfv4wcEkMfRlkvENxT3MoCX0EJpuERrQtlr35HYvTloTC/WxSKq6VRi4GvtWdNco3opn/QMFyW0H7J+uasM+gjV7RkRvL/umI=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3804.namprd12.prod.outlook.com (10.255.173.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.20; Fri, 13 Sep 2019 19:00:48 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997%3]) with mapi id 15.20.2241.022; Fri, 13 Sep 2019
 19:00:48 +0000
From:   "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "graf@amazon.com" <graf@amazon.com>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH v3 00/16] kvm: x86: Support AMD SVM AVIC w/ in-kernel irqchip
 mode
Thread-Topic: [PATCH v3 00/16] kvm: x86: Support AMD SVM AVIC w/ in-kernel
 irqchip mode
Thread-Index: AQHVamWNwMSOXdHv0kO89gBM6mvXdw==
Date:   Fri, 13 Sep 2019 19:00:48 +0000
Message-ID: <1568401242-260374-1-git-send-email-suravee.suthikulpanit@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [165.204.78.1]
x-clientproxiedby: SN6PR08CA0021.namprd08.prod.outlook.com
 (2603:10b6:805:66::34) To DM6PR12MB2844.namprd12.prod.outlook.com
 (2603:10b6:5:45::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 1.8.3.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d8199909-0bdf-4683-f638-08d7387cb050
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR12MB3804;
x-ms-traffictypediagnostic: DM6PR12MB3804:
x-ms-exchange-purlcount: 3
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB38048A0D64F0DD15139E4836F3B30@DM6PR12MB3804.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1247;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(189003)(199004)(6436002)(6512007)(478600001)(6486002)(7416002)(53936002)(2906002)(4326008)(6116002)(3846002)(25786009)(86362001)(6306002)(99286004)(66946007)(64756008)(66446008)(36756003)(486006)(71190400001)(71200400001)(52116002)(66556008)(256004)(4720700003)(2616005)(476003)(14444005)(102836004)(305945005)(14454004)(7736002)(316002)(50226002)(386003)(6506007)(26005)(2501003)(8936002)(66066001)(8676002)(186003)(81156014)(81166006)(110136005)(5660300002)(54906003)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3804;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wMhkL0YQIemWGVFst6FvkDOkaPcl4ou3B4/iR3qdXRukgheEZBxUp3x4IPgg9OtjgbXNRZK73NxQvN+kRp2BUCWqA/3QRijV70yGgviK1WnoLW1e5aB4RdqDh98cixzniXy/fX0FIW09kH+wsiU4hw4wVO4caZ727qNyymFBbxnT6/G/+YztiNRITIfxiAUxaJ9hPzo8Uy6QPAqAFFaJ+8cvIjnLbI4KpqL4OW+mYcGcMqNgfAXXDrSDV4uwnJIak5U7X7qNHC7OdgbabxaITqQKFHoub4pzSZGoK1RK9mmGPpsns3s8XITBojNY1FVJWsexjt0ezUuJ8PL3NdQrXQVFi04CGXuva2SchEoI85gTJnVp7jT+6CK0OtxA+p6pk31WH2D2i5y1vYQU/3vDbsGLr4tJJ2si3m56p4BF+XQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <42AC8A303734644DB7BD6EE5EC84398D@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8199909-0bdf-4683-f638-08d7387cb050
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 19:00:48.5218
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gRKjhRsym7LB/fJsqSv01WSIRenwql7VPTm4pPbxE5FYWyo1MlplZX+bfaw++jJaq2XHXN8+O0Ym8DQfUshNPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3804
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
LCBhbmQgZml4ZWQgYnkgdGhpcyBzZXJpZXMpLiANCg0KVGhpcyBzZXJpZXMgY29udGFpbnMgdGhy
ZWUgcGFydHM6DQogICogUGFydCAxOiBwYXRjaCAxLTINCiAgICBJbnRyb2R1Y2UgQVBJQ3Ygc3Rh
dGUgZW51bSBhbmQgbG9naWMgZm9yIGtlZXBpbmcgdHJhY2sgb2YgdGhlIHN0YXRlDQogICAgZm9y
IGVhY2ggdm0uDQogDQogICogUGFydCAyOiBwYXRjaCAzLTExDQogICAgQWRkIHN1cHBvcnQgZm9y
IGFjdGl2YXRlL2RlYWN0aXZhdGUgQVBJQ3YgYXQgcnVudGltZQ0KDQogICogUGFydCAzOiBwYXRj
aCAxMi0xNjoNCiAgICBQcm92aWRlIHdvcmthcm91bmQgZm9yIEFWSUMgRU9JIGFuZCBhbGxvdyBl
bmFibGUgQVZJQyB3Lw0KICAgIGtlcm5lbF9pcnFjaGlwPW9uDQoNClByZS1yZXF1aXNpdGUgUGF0
Y2g6DQogICogY29tbWl0IGI5YzZmZjk0ZTQzYSAoImlvbW11L2FtZDogUmUtZmFjdG9yIGd1ZXN0
IHZpcnR1YWwgQVBJQw0KICAgIChkZS0pYWN0aXZhdGlvbiBjb2RlIikNCiAgICAoaHR0cHM6Ly9n
aXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvam9yby9pb21tdS5naXQvY29t
bWl0Lw0KICAgICA/aD1uZXh0JmlkPWI5YzZmZjk0ZTQzYTBlZTA1M2UwYzFkOTgzZmJhMWFjNDk1
M2I3NjIpDQoNClRoaXMgc2VyaWVzIGhhcyBiZWVuIHRlc3RlZCBhZ2FpbnN0IHY1LjMtcmM1IGFz
IGZvbGxvd2luZzoNCiAgKiBCb290aW5nIExpbnV4IGFuZCBXaW5kb3dzIFNlcnZlciAyMDE5IFZN
cyB1cHRvIDI0MCB2Y3B1cw0KICAgIGFuZCBGcmVlQlNEIHVwdG8gMTI4IHZjcHVzIHcvIHFlbXUg
b3B0aW9uICJrZXJuZWwtaXJxY2hpcD1vbiINCiAgICBhbmQgIi1uby1ocGV0Ii4NCiAgKiBQYXNz
LXRocm91Z2ggSW50ZWwgMTBHYkUgTklDIGFuZCBydW4gbmV0cGVyZiBpbiB0aGUgVk0uDQoNCkNo
YW5nZXMgZnJvbSBWMjogKGh0dHBzOi8vbGttbC5vcmcvbGttbC8yMDE5LzgvMTUvNjcyKQ0KICAq
IFJlYmFzZSB0byB2NS4zLXJjNQ0KICAqIE1pc2MgY2hhbmdlcyByZWNvbW1lbmRlZCBieSBBbGV4
IGFuZCBWaXRhbHkuDQogICogUmVuYW1lIEFQSUNWX0RFQUNUSVZBVEVEIHRvIEFQSUNWX1NVU1BF
TkRFRA0KICAqIERpc2FibGUgQVZJQyB3aGVuIGd1ZXN0IGJvb3Rpbmcgdy8gU1ZNIHN1cHBvcnQg
c2luY2UgQVZJQw0KICAgIGRvZXMgbm90IGN1cnJlbnRseSBzdXBwb3J0IGd1ZXN0IHcvIG5lc3Rl
ZCB2aXJ0Lg0KICAqIEFkZCB0cmFjZXBvaW50IGZvciBBUElDViBhY3RpdmF0ZS9kZWFjdGl2YXRl
IHJlcXVlc3QuIChwZXIgQWxleCkNCiAgKiBDb25zb2xpZGF0ZSBjaGFuZ2VzIGZvciBoYW5kbGlu
ZyBFT0kgZm9yIGt2bSBQSVQgZW11bGF0aW9uIGFuZA0KICAgIElPQVBJQyBSVEMgaGFuZGxpbmcg
aW4gVjIgaW50byBpb2FwaWNfbGF6eV91cGRhdGVfZW9pKCkgaW4NCiAgICBwYXRjaCAxNy8xOCBv
ZiB2MyBzZXJpZS4NCiAgKiBSZW1vdmUgcGF0Y2hlcyBmb3IgcHJvdmlkaW5nIHBlci12bSBhcGlj
dl9zdGF0ZSBkZWJ1ZyBpbmZvcm1hdGlvbi4NCg0KQ2hhbmdlcyBmcm9tIFYxOiAoaHR0cHM6Ly9s
a21sLm9yZy9sa21sLzIwMTkvMy8yMi8xMDQyKQ0KICAqIEludHJvZHVjZSBBUElDdiBzdGF0ZSBl
bnVtZXJhdGlvbg0KICAqIEludHJvZHVjZSBLVk0gZGVidWdmcyBmb3IgQVBJQ3Ygc3RhdGUNCiAg
KiBBZGQgc3luY2hyb25pemF0aW9uIGxvZ2ljIGZvciBBUElDdiBzdGF0ZSB0byBwcmV2ZW50IHBv
dGVudGlhbA0KICAgIHJhY2UgY29uZGl0aW9uIChwZXIgSmFuJ3Mgc3VnZ2VzdGlvbikNCiAgKiBB
ZGQgc3VwcG9ydCBmb3IgYWN0aXZhdGUvZGVhY3RpdmF0ZSBwb3N0ZWQgaW50ZXJydXB0DQogICAg
KHBlciBKYW4ncyBzdWdnZXN0aW9uKQ0KICAqIFJlbW92ZSBjYWxsYmFjayBmdW5jdGlvbnMgZm9y
IGhhbmRsaW5nIEFQSUMgSUQsIERGUiBhbmQgTERSIHVwZGF0ZQ0KICAgIChwZXIgUGFvbG8ncyBz
dWdnZXN0aW9uKQ0KICAqIEFkZCB3b3JrYXJvdW5kIGZvciBoYW5kbGluZyBFT0kgZm9yIGluLWtl
cm5lbCBQSVQgYW5kIElPQVBJQy4NCg0KU3VyYXZlZSBTdXRoaWt1bHBhbml0ICgxNik6DQogIGt2
bTogeDg2OiBNb2RpZnkga3ZtX3g4Nl9vcHMuZ2V0X2VuYWJsZV9hcGljdigpIHRvIHVzZSBzdHJ1
Y3Qga3ZtDQogICAgcGFyYW1ldGVyDQogIGt2bTogeDg2OiBJbnRyb2R1Y2UgS1ZNIEFQSUN2IHN0
YXRlDQogIGt2bTogbGFwaWM6IEludHJvZHVjZSBBUElDdiB1cGRhdGUgaGVscGVyIGZ1bmN0aW9u
DQogIGt2bTogeDg2OiBBZGQgc3VwcG9ydCBmb3IgYWN0aXZhdGUvZGUtYWN0aXZhdGUgQVBJQ3Yg
YXQgcnVudGltZQ0KICBrdm06IHg4NjogQWRkIEFQSUN2IGFjdGl2YXRlL2RlYWN0aXZhdGUgcmVx
dWVzdCB0cmFjZSBwb2ludHMNCiAga3ZtOiB4ODY6IHN2bTogQWRkIHN1cHBvcnQgdG8gYWN0aXZh
dGUvZGVhY3RpdmF0ZSBwb3N0ZWQgaW50ZXJydXB0cw0KICBzdm06IEFkZCBzdXBwb3J0IGZvciBz
ZXR1cC9kZXN0cm95IHZpcnV0YWwgQVBJQyBiYWNraW5nIHBhZ2UgZm9yIEFWSUMNCiAgc3ZtOiBB
ZGQgc3VwcG9ydCBmb3IgYWN0aXZhdGUvZGVhY3RpdmF0ZSBBVklDIGF0IHJ1bnRpbWUNCiAga3Zt
OiB4ODY6IGh5cGVydjogVXNlIEFQSUN2IGRlYWN0aXZhdGUgcmVxdWVzdCBpbnRlcmZhY2UNCiAg
c3ZtOiBEaXNhYmxlIEFWSUMgd2hlbiBsYXVuY2hpbmcgZ3Vlc3Qgd2l0aCBTVk0gc3VwcG9ydA0K
ICBzdm06IFRlbXBvcmFyeSBkZWFjdGl2YXRlIEFWSUMgZHVyaW5nIEV4dElOVCBoYW5kbGluZw0K
ICBrdm06IHg4NjogSW50cm9kdWNlIHN0cnVjdCBrdm1feDg2X29wcy5hcGljdl9lb2lfYWNjZWxl
cmF0ZQ0KICBrdm06IGxhcGljOiBDbGVhbiB1cCBBUElDIHByZWRlZmluZWQgbWFjcm9zDQogIGt2
bTogaW9hcGljOiBSZWZhY3RvciBrdm1faW9hcGljX3VwZGF0ZV9lb2koKQ0KICBrdm06IHg4Njog
aW9hcGljOiBMYXp5IHVwZGF0ZSBJT0FQSUMgRU9JDQogIHN2bTogQWxsb3cgQVZJQyB3aXRoIGlu
LWtlcm5lbCBpcnFjaGlwIG1vZGUNCg0KIGFyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0Lmgg
fCAgMjggKysrKystDQogYXJjaC94ODYva3ZtL2h5cGVydi5jICAgICAgICAgICB8ICAxMiArKy0N
CiBhcmNoL3g4Ni9rdm0vaW9hcGljLmMgICAgICAgICAgIHwgMTQ5ICsrKysrKysrKysrKysrKysr
KystLS0tLS0tLS0tLQ0KIGFyY2gveDg2L2t2bS9sYXBpYy5jICAgICAgICAgICAgfCAgMzUgKysr
Ky0tLQ0KIGFyY2gveDg2L2t2bS9sYXBpYy5oICAgICAgICAgICAgfCAgIDIgKw0KIGFyY2gveDg2
L2t2bS9zdm0uYyAgICAgICAgICAgICAgfCAxOTggKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKy0tLQ0KIGFyY2gveDg2L2t2bS90cmFjZS5oICAgICAgICAgICAgfCAgMzAgKysr
KysrDQogYXJjaC94ODYva3ZtL3ZteC92bXguYyAgICAgICAgICB8ICAgMiArLQ0KIGFyY2gveDg2
L2t2bS94ODYuYyAgICAgICAgICAgICAgfCAxMzYgKysrKysrKysrKysrKysrKysrKysrKysrKyst
DQogOSBmaWxlcyBjaGFuZ2VkLCA1MDYgaW5zZXJ0aW9ucygrKSwgODYgZGVsZXRpb25zKC0pDQoN
Ci0tIA0KMS44LjMuMQ0KDQo=
