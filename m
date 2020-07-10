Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D085C21BF24
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 23:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgGJVVZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 17:21:25 -0400
Received: from mail-bn8nam11on2057.outbound.protection.outlook.com ([40.107.236.57]:6133
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726262AbgGJVVZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 17:21:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NlDtrKwPbcEywERFIhauAOMX9gnbcQmWZhI5IL9igkCs3xA7+OMBnv19FaWcdooT4+AHZ3VbAzRQymYhLt26eQSrDVTq6PIfCPjPmwUQFw5Y5QKG8FmSHsOHSovgSkkq2YJmWhrToZPqqSafllKSI8jQ8hbumcDWo11Tsq03LhYycI+lgNSt1MsYs04xhLK6+50/Y/HyotTW3Yul++icY/NIWPUcA9RB7YWodpPr5rCY8ADgXiERHoXfrSmzlSZv36x3caVA1g8Rfo0zsWZ4aCdaksbIh+iZF83zTj/FPNfNxJbK3MZafMaKkOt8B7UhCwb9LKND/V1qcg5EX3Mcxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2U92W/fLqSbDT3SiSMxbD+RFHlD89WTRxmy4uYiXueM=;
 b=SVaYZPG+X9M+S718oHMw2B74b5mabllKgT9eUohNXsEuVb70o8behWJ9nGG1BmZ5jhagQ25z2R2JRFjjO3Fva827uH5VjkbW1cV7fx4rY02G2XCeI+sPx/Xb5DAi/FB1W+NMjhc38kFgjZDFZtriS1bNxfnu0R+JHKRWVJapckHiadhpmC0PABDveBmXQVmUVG8fmuUBOWHckF/HdfRXbLjmnzJmKnlSgOYpzy0EbzaC93M1gLATANhzlvy7GYs1beaQUwXy/G6E5N/kSwnKpZjKtyJ/OnQsT/NPSJ4Xgrlr60+ej0fOtM3tMx7O5U2IK0XOvLYjmRPetqa7la0a8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2U92W/fLqSbDT3SiSMxbD+RFHlD89WTRxmy4uYiXueM=;
 b=EpI2m5J+3AnM7V7N3Cw6XI4KciY1Z4d63uuI3vANYDUBi0TBJb061WOhPS8sU+JQU6MsqPO7wpZsXNWynHeJXVGK9gNQ7DfW2PvAXtxaK7FvHEPq6ne04OfCW0VrkOl/SOJ0JESjS4irW/Fj2tdFS/IBwbD4wv2RD1trypCu4WY=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (2603:10b6:a03:4a::18)
 by BYAPR05MB6518.namprd05.prod.outlook.com (2603:10b6:a03:e9::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.9; Fri, 10 Jul
 2020 21:21:22 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::d563:57:2c78:7f]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::d563:57:2c78:7f%4]) with mapi id 15.20.3195.009; Fri, 10 Jul 2020
 21:21:22 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 1/4] x86: svm: clear CR4.DE on DR intercept
 test
Thread-Topic: [kvm-unit-tests PATCH 1/4] x86: svm: clear CR4.DE on DR
 intercept test
Thread-Index: AQHWVujs7oOSa16iLkK0+asCgTs4eKkBSCMAgAAKJYA=
Date:   Fri, 10 Jul 2020 21:21:21 +0000
Message-ID: <E9674128-8401-49BA-B721-EE93C597BA8B@vmware.com>
References: <20200710183320.27266-1-namit@vmware.com>
 <20200710183320.27266-2-namit@vmware.com>
 <8b7970c9-0b9e-6108-dfeb-4d871ab425b0@redhat.com>
In-Reply-To: <8b7970c9-0b9e-6108-dfeb-4d871ab425b0@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [2601:647:4700:9b2:48f0:f214:d1f2:ad5b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8425139b-f9bc-4c48-699c-08d8251731a4
x-ms-traffictypediagnostic: BYAPR05MB6518:
x-microsoft-antispam-prvs: <BYAPR05MB651851D3142C44B306D4FA19D0650@BYAPR05MB6518.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ia1HXIq9RlMw06+G0qlvfQFtR2pxREIkVI423kqi9M8wwxQcVYmeiTlzFdaoQW99GURZKwhrdiwU7Cn3bDxdkdo3fMmG7cjRqOHkKO7RtPoVYrGDjydrGpzLXW7mz9ieRavkKvxPxFER3zasEH2cr3gjj3qFtHcRZmg5uvjwXY7Nd0peHHJuZ3vM0lLHGpaKjVwXynt0S6TIs9k2C162RhjdcRVLFzNu92fQFP/jXaWxkGoS67aFuEvT6S81qlsKRzqIzjY8+FEzLlse9ae18MbAJdZRo0m5ZcNiqoSz2l1Ow3twk4XpQlpmtIZ8LsZClQIwUq28W6f5M+GdVcDksA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4776.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(376002)(366004)(136003)(39860400002)(83380400001)(8936002)(2616005)(6916009)(316002)(4326008)(2906002)(6512007)(4744005)(6486002)(71200400001)(33656002)(66556008)(86362001)(66946007)(66446008)(5660300002)(8676002)(64756008)(66476007)(36756003)(53546011)(478600001)(186003)(6506007)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: DNZS+sqn1WJkskWj4RbYM3EKxqGGgs+VdNKkGnQZInMNfHFJHbCg7yo6pu/iN5SfCeqNl00tvxLLtx872UGb84FEtXuO/Z3JqB53V5eq0aulRAr68+1LnwhnpCmyQPpFwXopnzXtrygoQ6mp70YBQz9R0sITHVmT64MJq7epuzDuVotkXRKsIdz4dFkIBTNyIAM5SK95Ci5Ivwhe6hR6bj0/7shNV8ok+u96dUMRjYpBTMcvEIPYSkGI2xTRD40Ky1WriGvWt8PUnZ0aU4BZevmZJzCLifJUwXla/9oYaVV4C3l72YF6RElanpuEFAkUrNDsDYWWWcPh7vY0zUJTPsC1ZZIyu9/UYopNBlG0m/txgIio/uSie+pKS6mpuJ3HpFZQ4/t+yGxpROJvDCu93f8ihaInvHfhAyzJMnnveobOdIhaXazpfIp0fCy3WcGr7NW/IiCuo1GOP5/Z8ALiVAGOi57Yzui4fyyRO+4EcNyD1BF0mnjlOgPCPiWzGR7gRsEy6QyCgU/SsBrt4bsH1gtYp6JrePeCLfqcBAnR3E8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FC209B15DC438C44952F56EAF197D988@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4776.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8425139b-f9bc-4c48-699c-08d8251731a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2020 21:21:21.9129
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OE8FUhz2SyNGC+yeOrwGb+oEOgPg6oCf9AdWtpCFoBHfddPeoZKqR/ezmxGKVu3999i7tyVG7QPXqXSer4HZjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB6518
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jul 10, 2020, at 1:45 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> On 10/07/20 20:33, Nadav Amit wrote:
>> DR4/DR5 can only be written when CR4.DE is clear, and otherwise trigger
>> a #GP exception. The BIOS might not clear CR4.DE so update the tests not
>> to make this assumption.
>>=20
>>=20
>=20
> I think we should just start with a clean slate and clear CR4 in cstart*.=
S:

Your change seems fine. If you can push it (with the rest of the recent svm
changes), I would prefer to run it, before I need to return my AMD machine.

