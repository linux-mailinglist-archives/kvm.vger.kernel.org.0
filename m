Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2E2DA71E7
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 19:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730087AbfICRoC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 13:44:02 -0400
Received: from mail-eopbgr720051.outbound.protection.outlook.com ([40.107.72.51]:45951
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729877AbfICRoC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 13:44:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hp6hbLxahvRz/g5QlqX/dtVuTVKYgaMhn10vkvMWoCiTa0myCNCX0We0UouhQ6TmVF4ndxPX2lVy1KPQ0mmxRayELsjCSoZnW3G6k2DUwI2UXL6VKl3ADAkC2YIhugD5hnjP14H1XONEBJp1Pd5SpSbRfQ1dD9bFUpQNnIS9fA767RpJlEPdeePJgIPkDvTasbIauzVPMgJ3GSfCtri123XP4lXdp0lRBJ23J2MEN7sAKL01yQBysVtkxHZL4vrDmhaOGk/8owFcs9DRELdDBHgCuVJN99ZZ84lb1MFQ/j8jmAgoX5/SDSiLQstBRIxLs0XflpZKXEUdeERCwR0k6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQri4cJJULQc9GihiE9Pu2GRvk4hKgUtgAZQso+Hn8I=;
 b=oJKofScrbwcfcU5jpb2zt6QbSn+LjRM/xe7Oh2fMShJuNjBuGh+OjbnVGfP0Ko/clNXtTZJTm+Remamr7ixkAAgb0mW6cKD0TgimD1uTEpgjROZqDX0AUWo3FQkZja1yJPG+K7ySOK4rhzWfl7XVTK1J8JW9utUzkeoQwddt4dxqLCkdTau6y5waMkcHx54tFBNzC47tWve/SPNeanvTGfmY0cyWS9gH33u56cRpCcLZGuHWPmQLkQNCd46jlzj9hPM2l6wVegmGecq2F/b0p+KjdpNeJjpVUrlB7vvMmwRVUy7M6M2uLrYq8JarHBRbQSxdYRcmyJTjbE0kxKDWhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQri4cJJULQc9GihiE9Pu2GRvk4hKgUtgAZQso+Hn8I=;
 b=WiGcHCjbH+omyYn86RFJbWjmlZEPkY+hmRWeGRWgZ0V6le6IS97naIGivUBQVZ1wSz0R2CD7sNgNmOFTBloeOxmx1lmtHJU7SDbNg76wbrWHvhKin7XoJOPI/CCfECe+ii6idpq9hCeMfxTGRvUkBZaXshrnzKRfpOYgjJJe/bg=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (52.135.233.146) by
 BYAPR05MB6022.namprd05.prod.outlook.com (20.178.53.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.12; Tue, 3 Sep 2019 17:44:00 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::b5c9:9c17:bcf1:1310]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::b5c9:9c17:bcf1:1310%5]) with mapi id 15.20.2241.011; Tue, 3 Sep 2019
 17:44:00 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [kvm-unit-tests PATCH 1/2] x86: nVMX: Do not use test_skip() when
 multiple tests are run
Thread-Topic: [kvm-unit-tests PATCH 1/2] x86: nVMX: Do not use test_skip()
 when multiple tests are run
Thread-Index: AQHVX7C+p2lf87FZvEm9fMlumjMjOKcaOqsAgAAESIA=
Date:   Tue, 3 Sep 2019 17:44:00 +0000
Message-ID: <62FE01A3-810C-4254-92F2-D7047865752B@vmware.com>
References: <20190830204031.3100-1-namit@vmware.com>
 <20190830204031.3100-2-namit@vmware.com>
 <20190903172840.GJ10768@linux.intel.com>
In-Reply-To: <20190903172840.GJ10768@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=namit@vmware.com; 
x-originating-ip: [66.170.99.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4a91edb8-d60c-4b0b-f23f-08d730964dc1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR05MB6022;
x-ms-traffictypediagnostic: BYAPR05MB6022:
x-microsoft-antispam-prvs: <BYAPR05MB6022575F42A566B493E26232D0B90@BYAPR05MB6022.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-forefront-prvs: 01494FA7F7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(199004)(189003)(86362001)(8676002)(81156014)(81166006)(6436002)(476003)(6506007)(5660300002)(3846002)(6116002)(229853002)(11346002)(53936002)(53546011)(446003)(76116006)(486006)(99286004)(66066001)(66446008)(66946007)(6486002)(64756008)(66556008)(66476007)(2616005)(71200400001)(71190400001)(305945005)(26005)(186003)(316002)(6512007)(14454004)(4326008)(6916009)(8936002)(478600001)(54906003)(76176011)(2906002)(6246003)(33656002)(36756003)(7736002)(102836004)(25786009)(14444005)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB6022;H:BYAPR05MB4776.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: veL/2M12t0JX30oubbqDPHQ3+14yg74TMzMnHMnkJn2WYyJPehTRqlqKVXC5s+B2biuhSLlXxllUAYT+g75oLwiFfWY9lbSFnJrVtaOsDqSECCmj/uBznzntHW1R0dQs7KdP+AApYN0IDYbkRU6vvC+VsxjHuyE+phlu2Ab4hTvnpN3MZrYnADvRV9lyyr1KqxpesJZZqmKVYpq3YUhEQJreFAeRBlgHS/0vIB82nhHcDV1WMg07b6fXanAOdVomCa+HQo9KhTPtKLT+oVQ2ZzH9WOYHtrWYshLk+sXNuCr+r2x5SRvYRV3wPIzg/OR65nJAnPrX5lVYbHDkhYj/dpdtr69HWSOc18WU1NuYJANcfW0nmzkzjTGYWaRd7REiIcRDmHdEArJy+niXcOhm13hI8vFR9NKhAO3sN6DdiIk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <01AF5E1CA97912408AC266C4D2A02C69@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a91edb8-d60c-4b0b-f23f-08d730964dc1
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2019 17:44:00.2479
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yAjgPZ8EBwzdEsDwr16yz8k5HNx/EaRF3QKBnm3xmO5xhcs5tP1WUYlFAND/E+YjlrxqOC3sS0H5UV+FYnPm8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB6022
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiBTZXAgMywgMjAxOSwgYXQgMTA6MjggQU0sIFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW4u
ai5jaHJpc3RvcGhlcnNvbkBpbnRlbC5jb20+IHdyb3RlOg0KPiANCj4gT24gRnJpLCBBdWcgMzAs
IDIwMTkgYXQgMDE6NDA6MzBQTSAtMDcwMCwgTmFkYXYgQW1pdCB3cm90ZToNCj4+IFVzaW5nIHRl
c3Rfc2tpcCgpIHdoZW4gbXVsdGlwbGUgdGVzdHMgYXJlIHJ1biBjYXVzZXMgYWxsIHRoZSBmb2xs
b3dpbmcNCj4+IHRlc3RzIHRvIGJlIHNraXBwZWQuIEluc3RlYWQsIGp1c3QgcHJpbnQgYSBtZXNz
YWdlIGFuZCByZXR1cm4uDQo+PiANCj4+IEZpeGVzOiA0N2NjM2Q4NWMyZmUgKCJuVk1YIHg4Njog
Q2hlY2sgUE1MIGFuZCBFUFQgb24gdm1lbnRyeSBvZiBMMiBndWVzdHMiKQ0KPj4gRml4ZXM6IDdm
ZDQ0OWYyZWQyZSAoIm5WTVggeDg2OiBDaGVjayBWUElEIHZhbHVlIG9uIHZtZW50cnkgb2YgTDIg
Z3Vlc3RzIikNCj4+IEZpeGVzOiAxODEyMTliZmQ3NmIgKCJ4ODY6IEFkZCB0ZXN0IGZvciBjaGVj
a2luZyBOTUkgY29udHJvbHMgb24gdm1lbnRyeSBvZiBMMiBndWVzdHMiKQ0KPj4gRml4ZXM6IDFk
NzBlYjgyM2UxMiAoIm5WTVggeDg2OiBDaGVjayBFUFRQIG9uIHZtZW50cnkgb2YgTDIgZ3Vlc3Rz
IikNCj4+IENjOiBLcmlzaCBTYWRodWtoYW4gPGtyaXNoLnNhZGh1a2hhbkBvcmFjbGUuY29tPg0K
Pj4gU2lnbmVkLW9mZi1ieTogTmFkYXYgQW1pdCA8bmFtaXRAdm13YXJlLmNvbT4NCj4gDQo+IGlu
dnZwaWRfdGVzdF92MigpIGFsc28gaGFzIGEgYnVuY2ggb2YgYmFkIGNhbGxzIHRvIHRlc3Rfc2tp
cCgpLg0KDQpJbiB0aGUgY2FzZSBvZiBpbnZ2cGlkX3Rlc3RfdjIoKSB0aGUgdXNlIHNlZW1zIGNv
cnJlY3QsIGFzIHRoZSBjYWxsIGlzIG5vdA0KZW5jYXBzdWxhdGVkIHdpdGhpbiBhIGdyb3VwIG9m
IHRlc3RzLiBZb3Ugd2FudCB0byBza2lwIGFsbCB0aGUgdGVzdHMgaWYNCmludnZwaWQgaXMgbm90
IHN1cHBvcnRlZCBmb3Igc29tZSByZWFzb24uDQoNCj4gV2hhdCBhYm91dCByZW1vdmluZyB0ZXN0
X3NraXAoKSBlbnRpcmVseT8gIFRoZSBjb2RlIGZvciBpbl9ndWVzdCBsb29rcw0KPiBzdXNwZWN0
LCBlLmcuIGF0IGEgZ2xhbmNlIGl0IHNob3VsZCB1c2UgSFlQRVJDQUxMX1ZNU0tJUCBpbnN0ZWFk
IG9mDQo+IEhZUEVSQ0FMTF9WTUFCT1JULiAgVGhlIG9ubHkgc29tZXdoYXQgbGVnaXQgdXNhZ2Ug
aXMgdGhlIGVwdCB0ZXN0cywgYW5kDQo+IG9ubHkgdGhlbiBiZWNhdXNlIHRoZSBlcHQgdGVzdHMg
YXJlIGFsbCBhdCB0aGUgZW5kIG9mIHRoZSBhcnJheS4NCj4gUmV0dXJuaW5nIHN1Y2Nlc3MvZmFp
bHVyZSBmcm9tIGVwdF9hY2Nlc3NfdGVzdF9zZXR1cCgpIHNlZW1zIGxpa2UgYQ0KPiBiZXR0ZXIg
c29sdXRpb24gdGhhbiB0ZXN0X3NraXAuDQoNCkkgZG9u4oCZdCBrbm93LiB0ZXN0X3NraXAoKSBk
b2VzIHNlZW0g4oCcbmljZeKAnSBpbiB0aGVvcnkgKGFzIGxvbmcgYXMgaXQgaXMgbm90DQp1c2Vk
IGltcHJvcGVybHkpLiBIYXZpbmcgc2FpZCB0aGF0LCB0aGUgZmFjdCB0aGF0IGl0IHVzZXMgSFlQ
RVJDQUxMX1ZNQUJPUlQNCmRvZXMgc2VlbSB3cm9uZy4gSSB0aGluayBpdCBzaG91bGQgYmUgYSBz
ZXBhcmF0ZSBjaGFuZ2UgdGhvdWdoLg==
