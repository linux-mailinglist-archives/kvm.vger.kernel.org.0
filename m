Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFD2AA0805
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 19:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbfH1RC6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 13:02:58 -0400
Received: from mail-eopbgr140095.outbound.protection.outlook.com ([40.107.14.95]:48192
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726415AbfH1RC5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 13:02:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Knncb2YGp6rFvcdaawkryp+agerdZcF18Dl5W/D4nBUC3YAe7HYI4wroIxD1FO8Rqgu/cH0J7Rt5vDDuE8uMfOpIg1FutT3RiMU81MrzKa8CVXOYAVCml7EuY5iC9memyy59p4QTrZTTNbmGOvBaa7o6eVqpWBcuwUPKDfbsBaK0wcFdZWvsi2lwpLIDw8u7zmOm8scmgYLDRmec2u1MWPQEYQOLKe6ePve9qQbszkS9xQ1+UjgpRtrLHTD/V+2oqCKmeICbf2+AS9WnVpRl3fbNer5/QqonMBQQfXwVg/1x/kuKNOnypFYqCkjV0CiG66qz43o1jdvyWHzqBRWr3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=myWY8g9AcvfNu6dTIgirU2weQVxzebMvrt7vFKAVqN8=;
 b=K9Kdb36XGBVnu7GCpYci+OEwCkKEreTZnqts7ptOZvPc07piIeIHpbBdagG9Dmfw71ic9GFFrcyg7F+9hYD84mWy251J5ih1vHmtneyoY+PYwf7dVNw2JU7GKije7OD+JSSSXSu0fMHk13Hr8VLpxsb33WB4i+NgDPDWKME34Lb2BYrPKvFUc1XHweFoCbv4Gm+DyXKDYadP+ISRtzvcZXV8wa3sVDwcfQ+nDjRu/KrTlZZKKaTYUYHmy7THmNigl8Eu53qaExr7BabpvmX+Qy2vzBNo07wC6e5JgnDdvV2fvhRSzSGawFvhwGwItlhI/XBrVIww3+WGP8pY/Ckdsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=myWY8g9AcvfNu6dTIgirU2weQVxzebMvrt7vFKAVqN8=;
 b=t4Tflww+IlKSAoWnRrSKLe+hHs/oDBwsaGcCjQodWO6mtkZn98SMAKrIlmg6hWNKUCzx2nKdVy6fnZYfrePbbIql68gEshwgEuH0SzG/MJLWcMrMbme2wNAFJDsoRNAjdrBV7x9AqMKGdYoilnBb65FSLbv/eleK8HkMImF8I4k=
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com (10.170.236.143) by
 VI1PR08MB3181.eurprd08.prod.outlook.com (52.133.15.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.19; Wed, 28 Aug 2019 17:02:53 +0000
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a]) by VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a%3]) with mapi id 15.20.2178.023; Wed, 28 Aug 2019
 17:02:53 +0000
From:   Jan Dakinevich <jan.dakinevich@virtuozzo.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Jan Dakinevich <jan.dakinevich@virtuozzo.com>,
        Denis Lunev <den@virtuozzo.com>,
        Roman Kagan <rkagan@virtuozzo.com>,
        Denis Plotnikov <dplotnikov@virtuozzo.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?iso-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [PATCH v2 0/3] fix emulation error on Windows bootup
Thread-Topic: [PATCH v2 0/3] fix emulation error on Windows bootup
Thread-Index: AQHVXcJt7Trak7Eg4E+dkRqxYyQrAg==
Date:   Wed, 28 Aug 2019 17:02:52 +0000
Message-ID: <1567011759-9969-1-git-send-email-jan.dakinevich@virtuozzo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0154.eurprd05.prod.outlook.com
 (2603:10a6:7:28::41) To VI1PR08MB2782.eurprd08.prod.outlook.com
 (2603:10a6:802:19::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jan.dakinevich@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.1.4
x-originating-ip: [185.231.240.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2962f05b-6e34-4746-f882-08d72bd99058
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR08MB3181;
x-ms-traffictypediagnostic: VI1PR08MB3181:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR08MB3181E67F2E4DBE1B129C3BB58AA30@VI1PR08MB3181.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 014304E855
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(346002)(39850400004)(136003)(396003)(189003)(199004)(478600001)(26005)(4326008)(8936002)(186003)(102836004)(3846002)(256004)(476003)(44832011)(6486002)(66066001)(6512007)(305945005)(2906002)(2501003)(86362001)(6436002)(6116002)(66446008)(8676002)(66946007)(966005)(64756008)(66556008)(66476007)(316002)(7736002)(81156014)(52116002)(25786009)(81166006)(71190400001)(71200400001)(6506007)(486006)(386003)(14454004)(53936002)(99286004)(2616005)(5660300002)(6916009)(2351001)(54906003)(5640700003)(36756003)(6306002)(50226002)(7416002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR08MB3181;H:VI1PR08MB2782.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 21WDfx4epCOmOonbGEuydhJUzYXUkuFmmNJwodILZGSk45HcS1WNwfPGgJvuOq/zzmg0WsS+ykBZMQnqY/fZLB6PZ0kUBe5NoUTNlv00An6zRlImMBRW2SYpgEOrz9K/hi4jTpwqwm3MkGyofhhVLzJ1nh05Y1jKNGdIlrFUFRE7vfVIgIFXSsIc/1QC98nOTZ4AY9zC+DE3V3SU2a3mTtiYrp3gC70i+2dMDUYq/U4xQaHcSwFc8rHKDgriL/Fwcb7FIdeonzJgBkNpAm99k8+Hle/GKp9deLJW96f6T9+hrrY7wZNfpEfAJvggMPpMXpvDqwAchJ3yAAVyBh1tC0qUxt0CECWrQjilha07KJ+2aIwJXBrVzwsmeqW/UZ05TiJK31nWkfEeTvvSD2QUJlEGpAZq28rar3ggiBsrykw=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2962f05b-6e34-4746-f882-08d72bd99058
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2019 17:02:53.1128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: POViCxvypt4B415UZXJeNOZ9/xUg8bkP0RA4CThLLT02RtWw9k69UP9uM50yzkiJM+5Oe7H68SWx1JwtaoIWbAmfb2tCQCYAtAjSm1e3EkA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3181
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series intended to fix (again) a bug that was a subject of the=20
following change:

  6ea6e84 ("KVM: x86: inject exceptions produced by x86_decode_insn")

Suddenly, that fix had a couple mistakes. First, ctxt->have_exception was=20
not set if fault happened during instruction decoding. Second, returning=20
value of inject_emulated_instruction was used to make the decision to=20
reenter guest, but this could happen iff on nested page fault, that is not=
=20
the scope where this bug could occur.

v1:
  https://lkml.org/lkml/2019/8/27/881

v2
  - reorder commits, rebase on top kvm/queue
  - add sanity check for exception value of exception vector

Jan Dakinevich (3):
  KVM: x86: always stop emulation on page fault
  KVM: x86: make exception_class() and exception_type() globally visible
  KVM: x86: set ctxt->have_exception in x86_decode_insn()

 arch/x86/kvm/emulate.c |  5 +++++
 arch/x86/kvm/x86.c     | 50 +++-------------------------------------------=
----
 arch/x86/kvm/x86.h     | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 54 insertions(+), 47 deletions(-)

--=20
2.1.4

