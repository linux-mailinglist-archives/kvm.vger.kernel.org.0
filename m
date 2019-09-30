Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30320C2414
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 17:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731938AbfI3PQG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 11:16:06 -0400
Received: from mail-eopbgr00085.outbound.protection.outlook.com ([40.107.0.85]:48760
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730780AbfI3PQG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 11:16:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4l6b0DWo8g+GFqaYF/9RVXpBY/aMzX+Q0+L24G8HuwU=;
 b=2g+wvgujA+dxudEHU6L1zWuVN+w2w4oH/8sqjBei89yVlJlCGnZVH1F2z7UMaYHTeAgUL1xVuCfizAjDUadl72CzbGJS6VHX/6ZKMhQP7llEc9EeAk/8rYByxB4E/iIN+ixEND0EbAcDXcTOOV875oMjjyEAkzkWfKddXDGlIj8=
Received: from VI1PR08CA0113.eurprd08.prod.outlook.com (2603:10a6:800:d4::15)
 by DB6PR0802MB2150.eurprd08.prod.outlook.com (2603:10a6:4:85::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2284.23; Mon, 30 Sep
 2019 15:16:01 +0000
Received: from VE1EUR03FT015.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e09::204) by VI1PR08CA0113.outlook.office365.com
 (2603:10a6:800:d4::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2305.17 via Frontend
 Transport; Mon, 30 Sep 2019 15:16:01 +0000
Authentication-Results: spf=fail (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received-SPF: Fail (protection.outlook.com: domain of arm.com does not
 designate 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT015.mail.protection.outlook.com (10.152.18.176) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2305.15 via Frontend Transport; Mon, 30 Sep 2019 15:16:00 +0000
Received: ("Tessian outbound e4042aced47b:v33"); Mon, 30 Sep 2019 15:15:58 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 2a299e50669ee4c2
X-CR-MTA-TID: 64aa7808
Received: from 9e0d70fd4ff7.2 (ip-172-16-0-2.eu-west-1.compute.internal [104.47.12.53])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id E085D8AF-A32B-4176-B94E-771331C03BAE.1;
        Mon, 30 Sep 2019 15:15:53 +0000
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04lp2053.outbound.protection.outlook.com [104.47.12.53])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 9e0d70fd4ff7.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384);
    Mon, 30 Sep 2019 15:15:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hm9hKGs+5njsQTWmd9UMCdoEStrnmMBnbgn8ELs19tOW2HeUYaY3d6jdiEW6b+7vZPtO/sviP2zRxODFnoMDHzFGezPPsFNlAEodqRy/hmE2wqN0F10VR//NNHhcPdVqYJn8mPeaBb0Xl4RQpzj2/bVTeVbwsRQno9vU2LmA3NCF9+rz9tXF2QSmbbM4n9878cqBb7/mEPafvEldqqqdw3LyTcTBkJAPMjIW8zjh2ZLSXew7G/fKK6ZuQsk4zQKCOwEVY3CdR5VGNi4xKY5G8q2T03E7k2b6hn5CiGmi3Qde4p7tmSHq4FzT5RkqVUPD5avxU0ng3O6wQSyKMJwFow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=289Nt+lUfQpT+KpTbd8iRw4J3QI1jg/VdfTBK5osgzA=;
 b=KpMR6837dQ/rvF0/tdLSsm4WbytqQrUbbDs/cfoNQVhsi3S5uVoxQXNXcTgl+d+wqwPetn7T557fT1EqZJPbzb+pW+RrkrWTFV9o3NK63Og+YS7MfVCqt4NcxKcJ4gnm3kPyaT7eSHr//7HflvkgUm+An5yQ6oBiih92yXBj8PxoEFxgbLG/zfbTpSNZNWtEKeQPuYZnQrOdQu4xvL4Dtz12byfTQ0KEQAnKS1msd7zUb407jsFgtIBa4WmTCup0zZLcSiW3I1PWlhZJ+n5sfYxKuOwM9Ln2w31eH1zLZ250PnqW+j2QvKTh0jMhMZD9uNsQNU2yz9iqMhuZRAzkrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=289Nt+lUfQpT+KpTbd8iRw4J3QI1jg/VdfTBK5osgzA=;
 b=CF4qXhGUHRDQabwR2l/Mro5TPV+0lq+PP/bGt8V7WpBbTxerB8QgDbGP9iFQeBvKOQlLFz79Tx4/X0cipFZJHDngAahGgfXkE6key7HXoEuYkXYLdfJGLJYiE9+iiYOU4mTacUoe/vQ4XOQFEZBO82kZluao+r/S8Di8zdO6Fjc=
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com (10.255.99.17) by
 AM6PR08MB3816.eurprd08.prod.outlook.com (20.178.90.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Mon, 30 Sep 2019 15:15:52 +0000
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::6848:2a38:498c:81a2]) by AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::6848:2a38:498c:81a2%3]) with mapi id 15.20.2305.017; Mon, 30 Sep 2019
 15:15:52 +0000
From:   Alexandru Elisei <Alexandru.Elisei@arm.com>
To:     Andrew Jones <drjones@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "maz@kernel.org" <maz@kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Andre Przywara <Andre.Przywara@arm.com>
Subject: Re: [kvm-unit-tests PATCH 2/3] lib: arm/arm64: Add function to clear
 the PTE_USER bit
Thread-Topic: [kvm-unit-tests PATCH 2/3] lib: arm/arm64: Add function to clear
 the PTE_USER bit
Thread-Index: AQHVd5rkkorMtiVcoEGqwu99vMHDlqdETo+AgAAEb4CAAAFRAIAAAF+A
Date:   Mon, 30 Sep 2019 15:15:52 +0000
Message-ID: <1703f24c-5682-0b37-d804-31b4a46483f8@arm.com>
References: <20190930142508.25102-1-alexandru.elisei@arm.com>
 <20190930142508.25102-3-alexandru.elisei@arm.com>
 <20190930145357.o7pq5ysttui2pjjm@kamzik.brq.redhat.com>
 <a33705e8-fd12-86db-be64-dca9900a5555@arm.com>
 <20190930151432.zgcaxtn7glrffkkn@kamzik.brq.redhat.com>
In-Reply-To: <20190930151432.zgcaxtn7glrffkkn@kamzik.brq.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0012.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::24) To AM6PR08MB4756.eurprd08.prod.outlook.com
 (2603:10a6:20b:cd::17)
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Alexandru.Elisei@arm.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [217.140.106.54]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: c702b31d-70d5-4ed3-60e7-08d745b91a63
X-MS-Office365-Filtering-HT: Tenant
X-MS-TrafficTypeDiagnostic: AM6PR08MB3816:|AM6PR08MB3816:|DB6PR0802MB2150:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0802MB21508BEE2EC30A7F5D39908386820@DB6PR0802MB2150.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;OLM:10000;
x-forefront-prvs: 01762B0D64
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(52314003)(189003)(199004)(2616005)(478600001)(6116002)(53546011)(64756008)(31686004)(54906003)(316002)(2906002)(3846002)(8676002)(81156014)(81166006)(66066001)(66946007)(8936002)(66476007)(66556008)(11346002)(66446008)(25786009)(102836004)(26005)(14454004)(6506007)(386003)(186003)(76176011)(99286004)(476003)(52116002)(44832011)(486006)(446003)(6486002)(6436002)(31696002)(4326008)(86362001)(6246003)(36756003)(6512007)(5660300002)(229853002)(71190400001)(7736002)(256004)(71200400001)(14444005)(305945005)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR08MB3816;H:AM6PR08MB4756.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: cquy0nlM3TO1Gk9J+7ZDH6/xu7BU6oGoW51QIfc4tLFmItIbJYRaekXsvyTeukZ3datefsBjpSVi26mcluAIPTOB0PIbJYoUEx8kppsZ1gjnbnzmnwW7lYQveoiMJOxgnfKkxO6Fg011yFgRWiGlPJWZo4MJ4JbFFHX/tJxjrRLg2rHn16F4sibMvIm3AYfFOLV8lajQAQoXYJan1ABFWhX33O+WuIz3Ac7YlWpbu0dfYn9j1t/zuJ9HCzbYxx2mtfcrXothDNO7OCcRPugPpFSRk1mart6eY4pfJlwK++a5ivDcqFlJdOyww6BS/vWf/ejT3Zf4NSgvH0+f5vKO3V8idabCy2hp3YJ88qgAGYoY1MJ2xn7cRQkjlTVf4EdPZm/y0+VCDE74nK9RmsdadnfYZ/RHaPjJMmSoZru+wY4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F07C9B73D7EE594FB01E263CAF203505@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3816
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Alexandru.Elisei@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT015.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(396003)(39860400002)(1110001)(339900001)(52314003)(40434004)(199004)(189003)(5660300002)(86362001)(81166006)(81156014)(8676002)(2906002)(31696002)(3846002)(6116002)(14444005)(25786009)(8936002)(22756006)(7736002)(54906003)(99286004)(47776003)(11346002)(66066001)(478600001)(386003)(6506007)(336012)(305945005)(23676004)(2486003)(26005)(2616005)(26826003)(6246003)(476003)(4326008)(316002)(126002)(5024004)(53546011)(14454004)(486006)(6512007)(102836004)(446003)(70206006)(356004)(6486002)(36756003)(50466002)(436003)(70586007)(76130400001)(76176011)(36906005)(6862004)(31686004)(229853002)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0802MB2150;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:Fail;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;A:1;MX:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 38b46d9e-b2cb-4e1c-e702-08d745b91522
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(710020)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB6PR0802MB2150;
X-Forefront-PRVS: 01762B0D64
X-Microsoft-Antispam-Message-Info: SCfsYMG5rxcDrkTLPN5CliGAXdgoJojhJGJkhmiksooqYcvkx/Exa5rUi0beruVUcvQT4zPL52ERbxHVvLlp9X0hwhjJnz6+jwd7JIo8XdRuR2UWK1XKID/SGSPE8jhrf6qkqHRHee2hg5eC+ZaA3GfRnQP7hXxJKMOv8O9vL43yP0+kzNsaON3RZdS2afZgN1QWyMJCD3aSZhwTwg/gLLFP3WVKWdj4PnxUTYe21gXxkNxLahdpi63ZqFQnYv1qj+9f0LJZyzRO0kkEPO65mR8kA2ITAt5up/WB+LfbkB6VoeoLfSqfbU7//9kTki4fwFSeXHFd/7cTjJ0iteAiGRV8Lr2vAAuSb91XGOeETEdEDmD4Y4lD41tdm0aLgICJ6NNskeKdAfS9/gT8daFctLbIwdURWhfC8r0PgfdFqAU=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2019 15:16:00.9120
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c702b31d-70d5-4ed3-60e7-08d745b91a63
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2150
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gOS8zMC8xOSA0OjE0IFBNLCBBbmRyZXcgSm9uZXMgd3JvdGU6DQo+IE9uIE1vbiwgU2VwIDMw
LCAyMDE5IGF0IDA0OjA5OjQ5UE0gKzAxMDAsIEFsZXhhbmRydSBFbGlzZWkgd3JvdGU6DQo+PiBI
aSwNCj4+DQo+PiBPbiA5LzMwLzE5IDM6NTMgUE0sIEFuZHJldyBKb25lcyB3cm90ZToNCj4+DQo+
Pj4gT24gTW9uLCBTZXAgMzAsIDIwMTkgYXQgMDM6MjU6MDdQTSArMDEwMCwgQWxleGFuZHJ1IEVs
aXNlaSB3cm90ZToNCj4+Pj4gVGhlIFBURV9VU0VSIGJpdCAoQVBbMV0pIGluIGEgcGFnZSBlbnRy
eSBtZWFucyB0aGF0IGxvd2VyIHByaXZpbGVnZSBsZXZlbHMNCj4+Pj4gKEVMMCwgb24gYXJtNjQs
IG9yIFBMMCwgb24gYXJtKSBjYW4gcmVhZCBhbmQgd3JpdGUgZnJvbSB0aGF0IG1lbW9yeQ0KPj4+
PiBsb2NhdGlvbiBbMV1bMl0uIE9uIGFybTY0LCBpdCBhbHNvIGltcGxpZXMgUFhOIChQcml2aWxl
Z2VkIGV4ZWN1dGUtbmV2ZXIpDQo+Pj4+IHdoZW4gaXMgc2V0IFszXS4gQWRkIGEgZnVuY3Rpb24g
dG8gY2xlYXIgdGhlIGJpdCB3aGljaCB3ZSBjYW4gdXNlIHdoZW4gd2UNCj4+Pj4gd2FudCB0byBl
eGVjdXRlIGNvZGUgZnJvbSB0aGF0IHBhZ2Ugb3IgdGhlIHByZXZlbnQgYWNjZXNzIGZyb20gbG93
ZXINCj4+Pj4gZXhjZXB0aW9uIGxldmVscy4NCj4+Pj4NCj4+Pj4gTWFrZSBpdCBhdmFpbGFibGUg
dG8gYXJtIHRvbywgaW4gY2FzZSBzb21lb25lIG5lZWRzIGl0IGF0IHNvbWUgcG9pbnQuDQo+Pj4+
DQo+Pj4+IFsxXSBBUk0gRERJIDA0MDZDLmQsIFRhYmxlIEIzLTYNCj4+Pj4gWzJdIEFSTSBEREkg
MDQ4N0UuYSwgdGFibGUgRDUtMjgNCj4+Pj4gWzNdIEFSTSBEREkgMDQ4N0UuYSwgdGFibGUgRDUt
MzMNCj4+Pj4NCj4+Pj4gU2lnbmVkLW9mZi1ieTogQWxleGFuZHJ1IEVsaXNlaSA8YWxleGFuZHJ1
LmVsaXNlaUBhcm0uY29tPg0KPj4+PiAtLS0NCj4+Pj4gICAgbGliL2FybS9hc20vbW11LWFwaS5o
IHwgIDEgKw0KPj4+PiAgICBsaWIvYXJtL21tdS5jICAgICAgICAgfCAxNSArKysrKysrKysrKysr
KysNCj4+Pj4gICAgMiBmaWxlcyBjaGFuZ2VkLCAxNiBpbnNlcnRpb25zKCspDQo+Pj4+DQo+Pj4+
IGRpZmYgLS1naXQgYS9saWIvYXJtL2FzbS9tbXUtYXBpLmggYi9saWIvYXJtL2FzbS9tbXUtYXBp
LmgNCj4+Pj4gaW5kZXggZGYzY2NmN2JjN2UwLi44ZmU4NWJhMzFlYzkgMTAwNjQ0DQo+Pj4+IC0t
LSBhL2xpYi9hcm0vYXNtL21tdS1hcGkuaA0KPj4+PiArKysgYi9saWIvYXJtL2FzbS9tbXUtYXBp
LmgNCj4+Pj4gQEAgLTIyLDQgKzIyLDUgQEAgZXh0ZXJuIHZvaWQgbW11X3NldF9yYW5nZV9zZWN0
KHBnZF90ICpwZ3RhYmxlLCB1aW50cHRyX3QgdmlydF9vZmZzZXQsDQo+Pj4+ICAgIGV4dGVybiB2
b2lkIG1tdV9zZXRfcmFuZ2VfcHRlcyhwZ2RfdCAqcGd0YWJsZSwgdWludHB0cl90IHZpcnRfb2Zm
c2V0LA0KPj4+PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcGh5c19hZGRyX3Qg
cGh5c19zdGFydCwgcGh5c19hZGRyX3QgcGh5c19lbmQsDQo+Pj4+ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBwZ3Byb3RfdCBwcm90KTsNCj4+Pj4gK2V4dGVybiB2b2lkIG1tdV9j
bGVhcl91c2VyKHVuc2lnbmVkIGxvbmcgdmFkZHIpOw0KPj4+PiAgICAjZW5kaWYNCj4+Pj4gZGlm
ZiAtLWdpdCBhL2xpYi9hcm0vbW11LmMgYi9saWIvYXJtL21tdS5jDQo+Pj4+IGluZGV4IDNkMzhj
ODM5N2Y1YS4uNzhkYjIyZTZhZjE0IDEwMDY0NA0KPj4+PiAtLS0gYS9saWIvYXJtL21tdS5jDQo+
Pj4+ICsrKyBiL2xpYi9hcm0vbW11LmMNCj4+Pj4gQEAgLTIxNywzICsyMTcsMTggQEAgdW5zaWdu
ZWQgbG9uZyBfX3BoeXNfdG9fdmlydChwaHlzX2FkZHJfdCBhZGRyKQ0KPj4+PiAgICAgICAgICAg
IGFzc2VydCghbW11X2VuYWJsZWQoKSB8fCBfX3ZpcnRfdG9fcGh5cyhhZGRyKSA9PSBhZGRyKTsN
Cj4+Pj4gICAgICAgICAgICByZXR1cm4gYWRkcjsNCj4+Pj4gICAgfQ0KPj4+PiArDQo+Pj4+ICt2
b2lkIG1tdV9jbGVhcl91c2VyKHVuc2lnbmVkIGxvbmcgdmFkZHIpDQo+Pj4+ICt7DQo+Pj4+ICsg
IHBnZF90ICpwZ3RhYmxlOw0KPj4+PiArICBwdGV2YWxfdCAqcHRlOw0KPj4+PiArDQo+Pj4+ICsg
IGlmICghbW11X2VuYWJsZWQoKSkNCj4+Pj4gKyAgICAgICAgICByZXR1cm47DQo+Pj4+ICsNCj4+
Pj4gKyAgcGd0YWJsZSA9IGN1cnJlbnRfdGhyZWFkX2luZm8oKS0+cGd0YWJsZTsNCj4+Pj4gKyAg
cHRlID0gZ2V0X3B0ZShwZ3RhYmxlLCB2YWRkcik7DQo+Pj4+ICsNCj4+Pj4gKyAgKnB0ZSAmPSB+
UFRFX1VTRVI7DQo+Pj4+ICsgIGZsdXNoX3RsYl9wYWdlKHZhZGRyKTsNCj4+Pj4gK30NCj4+Pj4g
LS0NCj4+Pj4gMi4yMC4xDQo+Pj4+DQo+Pj4gVGhpcyBpcyBmaW5lLCBidXQgSSB0aGluayB5b3Ug
Y291bGQganVzdCBleHBvcnQgZ2V0X3B0ZSgpIGFuZCB0aGVuDQo+Pj4gaW1wbGVtZW50IHRoZSBQ
VEVfVVNFUiBjbGVhcmluZyBpbiB0aGUgY2FjaGUgdW5pdCB0ZXN0IGluc3RlYWQuIEFueXdheSwN
Cj4+IEkgdGhvdWdodCBhYm91dCB0aGF0LCBidXQgSSBvcHRlZCB0byBtYWtlIHRoaXMgYSBsaWJy
YXJ5IGZ1bmN0aW9uIGJlY2F1c2UgSQ0KPj4gd291bGQgbGlrZSB0byBtb2RpZnkgaXQgdG8gYWxz
byBhY3Qgb24gYmxvY2sgbWFwcGluZ3MgYW5kIHVzZSBpdCBpbiBwYXRjaCAjNA0KPj4gZnJvbSB0
aGUgRUwyIHNlcmllcyAodGhlIHBhdGNoIHRoYXQgYWRkcyB0aGUgcHJlZmV0Y2ggYWJvcnQgdGVz
dCksIGFuZCBzZW5kDQo+PiB0aGF0IGNoYW5nZSBhcyBwYXJ0IG9mIHRoZSBFTDIgc2VyaWVzLiBJ
IGFtIGFzc3VtaW5nIHRoYXQgdGhpcyBwYXRjaCBzZXQNCj4+IHdpbGwgZ2V0IG1lcmdlZCBiZWZv
cmUgdGhlIEVMMiBzZXJpZXMuDQo+IFllYWgsIEkgbmVlZCB0byBnZXQgYmFjayB0byB0aGF0IEVM
MiBzZXJpZXMuIEkganVzdCBuZWVkIHRvIHdyYXAgdXAgYQ0KPiBjb3VwbGUgbW9yZSB0aGluZ3Mg
YW5kIHRoZW4gSSdsbCBiZSBhYmxlIHRvIGZvY3VzIG9uIGl0LiBJZiB5b3UgaGF2ZQ0KPiBzb21l
IHBsYW5zIHRvIHJlZnJlc2ggaXQsIHRoZW4gZmVlbCBmcmVlIHRvIGRvIHRoYXQgbm93LiBXaGVu
IEkgZ2V0DQo+IGJhY2sgdG8gaXQsIEknbGwganVzdCBqdW1wIGludG8gdGhlIHJlZnJlc2hlZCB2
ZXJzaW9uLg0KDQpUaGF0J3MgZ3JlYXQsIEkgaGF2ZSB2MiBhbG1vc3QgcmVhZHksIEknbGwgc2Vu
ZCBpdCB0b21vcnJvdy4NCg0KPiBUaGFua3MsDQo+IGRyZXcNCklNUE9SVEFOVCBOT1RJQ0U6IFRo
ZSBjb250ZW50cyBvZiB0aGlzIGVtYWlsIGFuZCBhbnkgYXR0YWNobWVudHMgYXJlIGNvbmZpZGVu
dGlhbCBhbmQgbWF5IGFsc28gYmUgcHJpdmlsZWdlZC4gSWYgeW91IGFyZSBub3QgdGhlIGludGVu
ZGVkIHJlY2lwaWVudCwgcGxlYXNlIG5vdGlmeSB0aGUgc2VuZGVyIGltbWVkaWF0ZWx5IGFuZCBk
byBub3QgZGlzY2xvc2UgdGhlIGNvbnRlbnRzIHRvIGFueSBvdGhlciBwZXJzb24sIHVzZSBpdCBm
b3IgYW55IHB1cnBvc2UsIG9yIHN0b3JlIG9yIGNvcHkgdGhlIGluZm9ybWF0aW9uIGluIGFueSBt
ZWRpdW0uIFRoYW5rIHlvdS4NCg==
