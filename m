Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2589418FDE1
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 20:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgCWTm4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 15:42:56 -0400
Received: from mail-dm6nam10on2065.outbound.protection.outlook.com ([40.107.93.65]:21187
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726982AbgCWTm4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 15:42:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OcWE6kA5Da8gLTm3kDx6RgDLzRgbEh5FiB5WCTiLHZEJFAYgjLqyY8d/t09jdSIoAxu5zJfoRLg1Ljxh4jKfmhemrLMZjyun3Jwd33qkafeBYJ0n1LxpxlurzUBsXUJNuGnOw8LrSb0XOGaC7iJOQ0jt/sNiZjDDfLvbwyVnhWCNe2uUeR7evX3evwQ7OP5GUrBIj86ohFYYU4+jEmGWwyiQ5uHbURKLF6h6FnA4E7hz4MKY0uoF5wnHdY7jkcdgocjquzks1MjqSQKmIcvqTsL9j+xvBQOyJj5nji1XREyal2gGIkgiZoaADx+87g2O80b/FDaSq5zqFEH4wb2BjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8VqHGj6tv+X13n6j5vsgoBf2teVx/EcYXWkyKyE+oYc=;
 b=ZaKmjgRZUBZmncAQC1hUTBmNj9hD7ce+o1Wy8jRKdT/q6qkIYUex430SC3PEkHJhyv+8U71iaO4VnU/g0IEOxzzSTMymqAvo8+8n/QLNd/pZk1lTyDBXlZJVrMkTwRfho6ADJKEn/1Ked6QeV2RmSIMmucffVzu72b6trAS2qFjalEC57ax6YcSSSZunNjviCUJLeEdw6DZDkCxUlXQHCcPSX8+dH7SJyTsM/49vjKILCy25QInvyDM/Mpvds8yLbF/L2dFfZ9osUZdJe4D8etC/GGtkTnd+/PLe49oRb1rzKmH9xJ62+JUp/Kz1EkqtajXLQuQMYdWBPtCGcF1IfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8VqHGj6tv+X13n6j5vsgoBf2teVx/EcYXWkyKyE+oYc=;
 b=1tLqsF1CLoJdphx8A3QlTDbKHJ+RaPaj3eF+QBlKg9rSdog85WUb7GfVQq8P1mvACwysWOBpoGDL5t2VBORT3oJnTZ+gJyz1ItCJciOlgL//TS8DDBW0PTzGlXB5IP5euzv/juajMM0Qt3GMWiHiUS8tL5XpibwzT4tRZV9lmjY=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (2603:10b6:a03:4a::18)
 by BYAPR05MB5366.namprd05.prod.outlook.com (2603:10b6:a03:1e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.9; Mon, 23 Mar
 2020 19:42:52 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::7c65:25af:faf7:5331]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::7c65:25af:faf7:5331%2]) with mapi id 15.20.2835.017; Mon, 23 Mar 2020
 19:42:52 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Nadav Amit <namit@vmware.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Marc Orr <marcorr@google.com>
Subject: Re: [PATCH] x86: vmx: skip atomic_switch_overflow_msrs_test on bare
 metal
Thread-Topic: [PATCH] x86: vmx: skip atomic_switch_overflow_msrs_test on bare
 metal
Thread-Index: AQHV/z62NFNL/tcTD0STGE4gHSPzwKhWl/yA
Date:   Mon, 23 Mar 2020 19:42:52 +0000
Message-ID: <8F02E1F3-F553-4863-A19C-9B409DD50E6C@vmware.com>
References: <20200321050616.4272-1-namit@vmware.com>
In-Reply-To: <20200321050616.4272-1-namit@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=namit@vmware.com; 
x-originating-ip: [2601:647:4700:9b2:891d:581c:617:a1a1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d1afb0de-50f8-4171-6a4a-08d7cf626036
x-ms-traffictypediagnostic: BYAPR05MB5366:|BYAPR05MB5366:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR05MB5366C4902CEAA46D887D99E6D0F00@BYAPR05MB5366.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0351D213B3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(199004)(4744005)(76116006)(4326008)(71200400001)(186003)(2906002)(6506007)(8676002)(6512007)(478600001)(53546011)(81166006)(81156014)(8936002)(6486002)(5660300002)(316002)(2616005)(54906003)(66476007)(64756008)(66446008)(66556008)(66946007)(6862004)(37006003)(36756003)(6200100001)(86362001)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB5366;H:BYAPR05MB4776.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F5OeiaLDtL6O5q+Ezs/1Ir6DGdmeRzLs8B9aqgOoG51IqBzD11Dr75VqKKksFbaaey4dRmr7ZPvFgTs4TkqtpMnDTMqJjsaQRYDgomR1/rvHEcH49yjVQprqsnZCrlFUMBIOPFQAYbD8nq7vSFJogNX6joJBtGTLSU3wl6npFHwrZ4M9ndNKDUfT4gwimasslz4nFa0WuC07wEM2Xibu/boNiUd5IGHyie5quNfqBzU9AqIYEnEYpX9xqyKIDb9XgfANTBnfFZpD4MrxG2YAgTlc+BW9Vv5HCo8goe9PxnNLMctch3sQMdCXl1eXyM+x9L+0Sk45olt+MWAkWbHYwmNU2Hl5iTsDQCDQoFRTn9wtEL/NCv1qp4jXak1pqH89wy1ck+YxLp6G6UEdlc5lYxpq7P9IMIVw3elZr1oVkh5BLa7QrhIZgYy0RPEjfFVd
x-ms-exchange-antispam-messagedata: yueYdPzcP8uTyyCAYUixCw+g1CX+I9KctOAvIJLDGXs2sSRMJ6L8TnX5UV8ARHmz2Iot7DGDtUldx4PDwuzmUMSWyFdZGrv14KOjy7GK3ODIjEdulrvEaJ0ZUOe3AJIUMgcEcc5DtxlyYVxcDAna5n7xqOp4FcpJzvXEfeExtFQ5l3iKE3bafvSieBiYm8sU0KGluztmjH5er+zjL5eEhg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <8B2CA20BCA016145AF8B14484F9D7711@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1afb0de-50f8-4171-6a4a-08d7cf626036
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2020 19:42:52.3218
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 93+qm6i1kZw7qBJ3HXBxNJbT4I72X7hdblGfZ1PXMP2ftNone82MXJfBwrvPI1/Qw39VZYK4Uf+5vBngXpEvhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5366
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SSBtaXN0YWtlbmx5IGZvcmdvdCB0aGUga3ZtLXVuaXQtdGVzdHMgaW4gdGhlIHBhdGNoIHN1Ympl
Y3QuIFNvcnJ5IGZvciB0aGF0Lg0KDQo+IE9uIE1hciAyMCwgMjAyMCwgYXQgMTA6MDYgUE0sIE5h
ZGF2IEFtaXQgPG5hbWl0QHZtd2FyZS5jb20+IHdyb3RlOg0KPiANCj4gVGhlIHRlc3QgYXRvbWlj
X3N3aXRjaF9vdmVyZmxvd19tc3JzX3Rlc3QgaXMgb25seSBleHBlY3RlZCB0byBwYXNzIG9uDQo+
IEtWTS4gU2tpcCB0aGUgdGVzdCB3aGVuIHRoZSBkZWJ1ZyBkZXZpY2UgaXMgbm90IHN1cHBvcnRl
ZCB0byBhdm9pZA0KPiBmYWlsdXJlcyBvbiBiYXJlLW1ldGFsLg0KPiANCj4gQ2M6IE1hcmMgT3Jy
IDxtYXJjb3JyQGdvb2dsZS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IE5hZGF2IEFtaXQgPG5hbWl0
QHZtd2FyZS5jb20+DQo+IC0tLQ0KPiB4ODYvdm14X3Rlc3RzLmMgfCA1ICsrKystDQo+IDEgZmls
ZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1n
aXQgYS94ODYvdm14X3Rlc3RzLmMgYi94ODYvdm14X3Rlc3RzLmMNCj4gaW5kZXggMjAxNGU1NC4u
YmU1Yzk1MiAxMDA2NDQNCj4gLS0tIGEveDg2L3ZteF90ZXN0cy5jDQo+ICsrKyBiL3g4Ni92bXhf
dGVzdHMuYw0KPiBAQCAtOTU0Niw3ICs5NTQ2LDEwIEBAIHN0YXRpYyB2b2lkIGF0b21pY19zd2l0
Y2hfbWF4X21zcnNfdGVzdCh2b2lkKQ0KPiANCj4gc3RhdGljIHZvaWQgYXRvbWljX3N3aXRjaF9v
dmVyZmxvd19tc3JzX3Rlc3Qodm9pZCkNCj4gew0KPiAtCWF0b21pY19zd2l0Y2hfbXNyc190ZXN0
KG1heF9tc3JfbGlzdF9zaXplKCkgKyAxKTsNCj4gKwlpZiAodGVzdF9kZXZpY2VfZW5hYmxlZCgp
KQ0KPiArCQlhdG9taWNfc3dpdGNoX21zcnNfdGVzdChtYXhfbXNyX2xpc3Rfc2l6ZSgpICsgMSk7
DQo+ICsJZWxzZQ0KPiArCQl0ZXN0X3NraXAoIlRlc3QgaXMgb25seSBzdXBwb3J0ZWQgb24gS1ZN
Iik7DQo+IH0NCj4gDQo+ICNkZWZpbmUgVEVTVChuYW1lKSB7ICNuYW1lLCAudjIgPSBuYW1lIH0N
Cj4g4oCUIA0KPiAyLjE3LjENCg0KDQo=
