Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBD11107BFF
	for <lists+kvm@lfdr.de>; Sat, 23 Nov 2019 01:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfKWAYm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 19:24:42 -0500
Received: from mail-dm6nam10on2076.outbound.protection.outlook.com ([40.107.93.76]:61216
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726089AbfKWAYm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 19:24:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m+D3uto2+WXc58bNmJlv9du4/fpyHjFrn25BqAB1QTJ3K54+JTsG1Mg3DQbHIIvhzhaGeZMA1xn0ByFgM5+leAG29FzOV0SLhIovGulwwLCkVULclJFMG1jK4K5up0Ojo5o8qr8aVPA3YL4Qb/1+z28xDddvH0TSWdw4qxFWRsbQpSNJ6UTZXDUqUbSbZJ30Dx3o5fE2X0NpUNslyHo/nMFO002qGH85fmou00ocdGKJJgLthBRDxf6D4Ln/oPAbT8Ox4tEf8NIeS37GGiDmJZ3KBssIKAjBp+A3fC/kWUdT7Iw/450R4uPfjgHiEdLx3HHKNLIcE26zNxkRGiC8eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=35s7wuwgyAl55iv3xnoCAasQoYL0Dkt19gEQU1k6rOU=;
 b=WefnkR2C4i1xfYLKxPxRicAh5G5L5upRcTegeldfPwvbT1gl/3qaTFl6ILyMrs8DF323rEB4B+KjjMRmcKjrWBWae31HoY8TVfN1O+/Ygjh/Zb20L74bSyv1NMaaIstNa6SazkWYRsGM3/hgOg3MCAGZWkg6fEo4B8m8yY59Gdi/ufATwexvrClbEbKXvdb/HelFnHVVohcVi06nqnNOD8nerIq1uk3ODwmR6qlt91rQYI7OpiK+jUdvvO1cV5XitQ3bq1NWFBYDWgP2rt6M5kRcZ0hl1flpnAtY3Etoy5xYBMMc6wyLgK+KIsclnmdEEaBpysklX64DFgj948v8gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=35s7wuwgyAl55iv3xnoCAasQoYL0Dkt19gEQU1k6rOU=;
 b=pPmBBtif5EPVXKimBHldsfO8kWbj2Rpnk44RJ3jYPqhZilOipFWtEUNMAgy1KduZ+pnbSbFIulynNei48B6m9Ch8XjR+eSuJnxYbIcooqppwzp1eoRxdWe9lQN9IPkYnxo1zxvd0xajOelZsPcx1uVsiTik7Qt3janT+LxZv6O8=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (52.135.233.146) by
 BYAPR05MB6150.namprd05.prod.outlook.com (20.178.55.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.10; Sat, 23 Nov 2019 00:24:39 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::c078:b785:f79d:482e]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::c078:b785:f79d:482e%5]) with mapi id 15.20.2474.018; Sat, 23 Nov 2019
 00:24:39 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [kvm-unit-tests PATCH] x86: vmx: Fix the check whether CMCI is
 supported
Thread-Topic: [kvm-unit-tests PATCH] x86: vmx: Fix the check whether CMCI is
 supported
Thread-Index: AQHVftJDRH9WeMDLQEaQujdh1XzILaeYKyMA
Date:   Sat, 23 Nov 2019 00:24:39 +0000
Message-ID: <766B4333-44BF-41B0-B3B5-5C2F7190B7EF@vmware.com>
References: <20191009112754.36805-1-namit@vmware.com>
In-Reply-To: <20191009112754.36805-1-namit@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=namit@vmware.com; 
x-originating-ip: [66.170.99.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 498c9650-5b56-42ab-bb75-08d76fab8730
x-ms-traffictypediagnostic: BYAPR05MB6150:
x-microsoft-antispam-prvs: <BYAPR05MB61504F4F02A64694BA5A2484D0480@BYAPR05MB6150.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 0230B09AC4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(189003)(199004)(6916009)(14454004)(66476007)(7736002)(8936002)(446003)(11346002)(2616005)(71200400001)(71190400001)(25786009)(478600001)(102836004)(6506007)(26005)(76176011)(81166006)(81156014)(186003)(8676002)(6512007)(256004)(229853002)(5660300002)(86362001)(6436002)(4326008)(6246003)(316002)(66066001)(6486002)(54906003)(53546011)(6116002)(99286004)(2906002)(3846002)(36756003)(33656002)(66946007)(66446008)(305945005)(76116006)(66556008)(64756008)(4744005);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB6150;H:BYAPR05MB4776.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: URmg9/rMLOaxXmOt+vP3UINWPlAVXm5x/JFjyWdXz2IP2CHbINiP/Q9EcxPAYLWDkvIsJOCxr8zsOxpegAaznbVUausLhSyC21NHUuF8N19V0tasr+ounsGg3asSULqTXGogd/2P5GIm0hdKLC726bEs3oLniSMmDQt2rMdnP0KoD2dIiSehy6wAxi4lvV9yqWkWL3X0dtFU+ioPB53dlxqcT6FL4cV5sZOeEcJNDRBHwiYQWWfDIWMwKrz/q4SYvQc5ePCR8Gva11aJtSkfl+6IjE2d5dh1BbNbS1rJU8LiuQoO9hZIQJwY+unHqWGSJQ3LokdC0V7I1jYugvy1AqKc3XklJ5EzLzZLQ5BvPhUT+gW8Hlx/nItpGC/+IwS24pPuA+Z4GAtJikICcZaT7wryMnltr5mi71quOJvUx9yFQXmET913r4P2pHazb0ON
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <028850A512014A4484251E9DA567C164@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 498c9650-5b56-42ab-bb75-08d76fab8730
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2019 00:24:39.3423
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pzdDjmbVOKSII4I+dsSC1hKRol6NKacmalIxQbKSlH2akKEweKk+Bx2H18q9DB/YOCqOIhWi/BWjyc6LAKJ7Ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB6150
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> On Oct 9, 2019, at 4:27 AM, Nadav Amit <namit@vmware.com> wrote:
>=20
> The logic of figuring out whether CMCI is supported is broken, causing
> the CMCI accessing tests to fail on Skylake bare-metal.
>=20
> Determine whether CMCI is supported according to the maximum entries in
> the LVT as encoded in the APIC version register.
>=20
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Nadav Amit <namit@vmware.com>

Ping?

