Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19A40A138A
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 10:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfH2IXV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 04:23:21 -0400
Received: from mail-eopbgr10099.outbound.protection.outlook.com ([40.107.1.99]:44097
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725782AbfH2IXU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 04:23:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M3ZYvM47F2+QioH738DfKf2/2FVmj0r+upFRboI03M8xCG/Q4ZIJM7PTnvg0f4IG6e0gnD315VB1ksMnYK/7ckDOMkaEUrwFpRuR4Q8x29qw1Ld/20QjqLz4h94ZIXQZ3a0wmYFFHKt+1HiODot/YLe13zg33mhTBIb88ODUqTeIzR0eiCn+F9M45eQROlcPZWtfX1wbxmU8w0WJUZV7qDgsPY0agMToWYY5K+FVmpNzaAz2UxwuHJJpMeOof0zDkHUa9npBoJcm7V0M2LtU/wiCy+hPYqK1ySuHw37y8Qvbi1TVwPeubo6fpgGoi5nAvNyy8BoocOne2tdXKjYjVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oOjr3QaL9caWv5QYfhTa9inH921VgNgBHYPoRqxQsqA=;
 b=YRf0y/U7fQo7cMJlcczVOYzPv5la5y9bgmPSF5A7Y2CGKEtM8dwIoqH6DYeK/EdSkkZX5eRqWo5WDpJIUmHhaGQnfJYxCK0AxtcwUwG1yK7o3+7LZRijNxh7SSHd/CwN0aqQ4mGrIdbOMdWAh3HFX+qvJQsGr3y88Hq3mD9UQyfdP9PazCoONvjWXlY6WIlRCcfEaYC/nYzbg3KHp1KPowlYnJRwX2ons9l2m4Z4Vtlq2H335FKo0VdkVeY1vZthbh2NCh0FV+BwIl6jBHxdIfNDQX3/wBze9qcKLjPsUGiArLN8+W0KNWlk0Un4Eci0frMHzUKqmAIBPwn+JX3/RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oOjr3QaL9caWv5QYfhTa9inH921VgNgBHYPoRqxQsqA=;
 b=brQvV7XaeCZZqlQfRUhCIX47h7yw+S0YnuH6dhaSPvNLUoIcmpDpmtL+DjCTwzsDhvrxbjiPJh+EXU7JlJWpliL4XnVPakA3JQtuZfh9TD79Kf146gRr7E6HwoTyxtbalLq6rjTbw0BGDT0Xy/Z371nGvEvtF/Es/UplU2lFvTw=
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com (10.170.236.143) by
 VI1PR08MB3342.eurprd08.prod.outlook.com (52.134.31.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.18; Thu, 29 Aug 2019 08:23:17 +0000
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a]) by VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a%3]) with mapi id 15.20.2178.023; Thu, 29 Aug 2019
 08:23:16 +0000
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
Subject: [PATCH v3 0/2] fix emulation error on Windows bootup
Thread-Topic: [PATCH v3 0/2] fix emulation error on Windows bootup
Thread-Index: AQHVXkMCmLX7ptsowU6uxciM+lstmw==
Date:   Thu, 29 Aug 2019 08:23:16 +0000
Message-ID: <1567066988-23376-1-git-send-email-jan.dakinevich@virtuozzo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0274.eurprd05.prod.outlook.com
 (2603:10a6:3:fc::26) To VI1PR08MB2782.eurprd08.prod.outlook.com
 (2603:10a6:802:19::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jan.dakinevich@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.1.4
x-originating-ip: [185.231.240.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 76af0b90-7fa4-4b8a-6405-08d72c5a2461
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR08MB3342;
x-ms-traffictypediagnostic: VI1PR08MB3342:
x-ms-exchange-purlcount: 2
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR08MB3342B6F9234F50F95F0987568AA20@VI1PR08MB3342.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(39850400004)(396003)(366004)(376002)(199004)(189003)(66476007)(66946007)(66556008)(966005)(50226002)(64756008)(66446008)(4744005)(2351001)(2501003)(36756003)(14454004)(8936002)(86362001)(66066001)(81156014)(81166006)(6436002)(5640700003)(6512007)(6306002)(71200400001)(71190400001)(44832011)(486006)(476003)(6916009)(5660300002)(52116002)(54906003)(14444005)(53936002)(102836004)(99286004)(2906002)(6486002)(478600001)(8676002)(6506007)(386003)(2616005)(26005)(186003)(7416002)(305945005)(4326008)(3846002)(25786009)(7736002)(256004)(6116002)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR08MB3342;H:VI1PR08MB2782.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NExFHAo7/g7fLIRFeE6GMtYfmWh94Odxs8IJlWd2zjSDh3Jq5L/f+6+ys98rfJ/ZYzrkSTpX/+5Q1bvKcSHopCv7xMIVjOrFfv5otXJxbomnJRg7d257y64mcSKYhouuMvMS1OhEcOQY2WIRz4ch2/iJJjepUqK8RElXpKiru5OLDncH8G4fCXBOoJtbnNMyVM4Z8bFqIEJ3LPsFAxZNs0QoJFhDuou7dtvBnXjtHXohXpA5/viiyXp7YYbsFvG1sR/QviGNrptykyexS0k/7u10q8j20pR5zioBQjq2Uc7vM76Vo2waz30g9+NW2BrwgWU0KrO5bPWHKBHGg0snDpXtzIaRdx7t/lENlskauZAhZAV/4EjCyg6pTh4QnaxYxREMiV1nSpYa3JCQ6lno7Gdd6FOV864V5/E/bvJI88U=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76af0b90-7fa4-4b8a-6405-08d72c5a2461
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 08:23:16.8203
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tsNzXykSfnMB4/apFFWLx1tbrU1YdmJ5+J2pVLZ3iP3LQecUR5NraprvjkPwxueT+ssl0X8JHWWvOHgW5uLgdOtFpFP8QNEP+xUwCTmIj4E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3342
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

v2:
  https://lkml.org/lkml/2019/8/28/879

v3:
  - do sanity check in caller code
  - drop patch, that moved emulation_type() function

Jan Dakinevich (2):
  KVM: x86: always stop emulation on page fault
  KVM: x86: set ctxt->have_exception in x86_decode_insn()

 arch/x86/kvm/emulate.c | 2 ++
 arch/x86/kvm/x86.c     | 7 ++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

--=20
2.1.4

