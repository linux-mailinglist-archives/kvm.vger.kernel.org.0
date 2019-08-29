Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA8D9A138C
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 10:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfH2IXY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 04:23:24 -0400
Received: from mail-eopbgr10099.outbound.protection.outlook.com ([40.107.1.99]:44097
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726009AbfH2IXX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 04:23:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Od3qtFFEvH8suqN+s0IzbC14P+J67AIvxkvnQbRakBBvH0rWbYfSQPfFjQey+ua0Blbjo/8FkuUcSBLZPm7ZdnsKs0BSapwdwuL/NAG+Ip/SmHBermth9NUdIwd44ME5X17R1axBhw2q+hKJ5JgTcw2x6D4rPP2lP8oz5nTojlFrK04wB6/BtkOclxCTL2kERe5lLC6Ro55bARwGCh4H2VRIAQye1fqRnyVu/TnUehxYNpNA0oq7iPyaKAM9rPXnTpLjfTq3ypPZNAMp1IAa9BO8bptRqQv6IcsOoRgELP8xhLt6a8HqqrL/P9fyckNY1YP/DDz3Lid5jXSrJbQ/KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eHXtOLU+RACRHQmWlmEgJKIwDrd/jAecnZx3zuIg0xo=;
 b=ngzMRjaN/AXzAcbTM8VYbQOpRByemwam8p8Utwm4ITH1kNiZF8Dq0TaVczbUO9NglDRL7OcpQ7tABgkq2poyC8g0j59w86b5QaPRfmE3x9YzI0kZYfzbqrx0sMCIJmwHb0Lf2uSQGtT42KOKPMYb7QXUZjjp3asBGt6v8qN7Yd4MoiMjhdlFxm5nOPx6QYQ8PJIayYtPaOMZnq4iHkeK7Qvcl9lCRPUF7wiDJQyh9PweZxf6hvbB7rCiZ9uAYKc1w8FFHD+fa03PtqX4qU3GG8wyCSUaHUNjdvCH0owq1zbsfdM2j8z8sX3Nu2Tm8brZkCQvY2GbmZyYKKMCbJFrxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eHXtOLU+RACRHQmWlmEgJKIwDrd/jAecnZx3zuIg0xo=;
 b=vrJPFubXtL/fDLGwFFpJ3hFeasbwbGaTKdwK2vbvl6gn+Kwa9D3cYc7Eg8Z9PynGk9dS0BXs8ROqczCP5wM/37vTkJWOKlTgjwCkPdNah7j3YabLlzsz9WnuFYa46bHczBkHpTKz9pjo8jaD0ScoWzlt8HNe7SnmvdwIw5kByk0=
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com (10.170.236.143) by
 VI1PR08MB3342.eurprd08.prod.outlook.com (52.134.31.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.18; Thu, 29 Aug 2019 08:23:19 +0000
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a]) by VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a%3]) with mapi id 15.20.2178.023; Thu, 29 Aug 2019
 08:23:19 +0000
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
Subject: [PATCH v3 1/2] KVM: x86: always stop emulation on page fault
Thread-Topic: [PATCH v3 1/2] KVM: x86: always stop emulation on page fault
Thread-Index: AQHVXkMDq0PAUucu1Uu9lgvhCNDIuA==
Date:   Thu, 29 Aug 2019 08:23:18 +0000
Message-ID: <1567066988-23376-2-git-send-email-jan.dakinevich@virtuozzo.com>
References: <1567066988-23376-1-git-send-email-jan.dakinevich@virtuozzo.com>
In-Reply-To: <1567066988-23376-1-git-send-email-jan.dakinevich@virtuozzo.com>
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
x-ms-office365-filtering-correlation-id: 6fb81dd3-e3ba-4c87-9d38-08d72c5a258a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR08MB3342;
x-ms-traffictypediagnostic: VI1PR08MB3342:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR08MB3342253857F0A0472F9462438AA20@VI1PR08MB3342.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1284;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(39850400004)(396003)(366004)(376002)(199004)(189003)(66476007)(66946007)(66556008)(50226002)(64756008)(66446008)(2351001)(2501003)(36756003)(14454004)(8936002)(86362001)(66066001)(81156014)(81166006)(6436002)(5640700003)(6512007)(71200400001)(71190400001)(44832011)(486006)(476003)(6916009)(5660300002)(52116002)(54906003)(14444005)(53936002)(102836004)(99286004)(2906002)(6486002)(478600001)(8676002)(6506007)(386003)(446003)(11346002)(2616005)(26005)(76176011)(186003)(7416002)(305945005)(4326008)(3846002)(25786009)(7736002)(256004)(6116002)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR08MB3342;H:VI1PR08MB2782.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NeKDJeqHRiHmvuCnX3OTwR7mKNfIyvzDCXwB5comj5tJgkH9v60ZCWzBLPnQhjrA8fBMGOOeGQYB1ez8PoqlbWrQO6wKaWqDhf1KGw9D9QrOGpykkU6m1ILj07s3OjnP8lI+eHGP+QaRlTjmB/9B2ZcDKWGrYhd6HNXb6GFoUuFxBaL32r7MqzAfdYoHZ9SJOMQD/NXplgo9WdvlpIaVe5+rEuSiobiTnaeSwL8E+cGp6DHy61fDjJP5vqOk8mtOMgDU2PH2NQw0Oa7w3lstyM4kTzUvi+rP97W8N0zO11Ay98nVFK9IOIuBAcRPQ/50iCNhC+3HntLfQjV8MzztsdHgOkKOVeuQ3/u5XoWNbIEIzUHQK6j7pdvX5yh56WyVzbY456BRkfUvU5mTQc0owzMfjU8nQXhdlpk5STQW7Ck=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fb81dd3-e3ba-4c87-9d38-08d72c5a258a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 08:23:18.8812
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sJTEFkoGsF6iMO4LXMCJZjPrn2Km0lpqcYabnpuJNN7PSsPwsBMFr3pCh+7AhsCsYa0tkpSwOyPod6kznWes9D8RwmUUdpAFytI3v2HMGFM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3342
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

inject_emulated_exception() returns true if and only if nested page
fault happens. However, page fault can come from guest page tables
walk, either nested or not nested. In both cases we should stop an
attempt to read under RIP and give guest to step over its own page
fault handler.

Fixes: 6ea6e84 ("KVM: x86: inject exceptions produced by x86_decode_insn")
Cc: Denis Lunev <den@virtuozzo.com>
Cc: Roman Kagan <rkagan@virtuozzo.com>
Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
---
 arch/x86/kvm/x86.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b4cfd78..6bf7b55 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6537,8 +6537,13 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 			if (reexecute_instruction(vcpu, cr2, write_fault_to_spt,
 						emulation_type))
 				return EMULATE_DONE;
-			if (ctxt->have_exception && inject_emulated_exception(vcpu))
+			if (ctxt->have_exception) {
+				WARN_ON_ONCE(ctxt->exception.vector =3D=3D UD_VECTOR);
+				WARN_ON_ONCE(exception_type(ctxt->exception.vector)
+					=3D=3D EXCPT_TRAP);
+				inject_emulated_exception(vcpu);
 				return EMULATE_DONE;
+			}
 			if (emulation_type & EMULTYPE_SKIP)
 				return EMULATE_FAIL;
 			return handle_emulation_failure(vcpu, emulation_type);
--=20
2.1.4

