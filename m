Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57DFDA138D
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 10:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfH2IX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 04:23:27 -0400
Received: from mail-eopbgr10099.outbound.protection.outlook.com ([40.107.1.99]:44097
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726936AbfH2IXZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 04:23:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Akrlbb6mXDETd8mkeP98MguamKuvljwAzuAaQkAJBXY7AfmOKdyDR7AyRMUoB1alpzFtXQ7FH84Uz60q1KObremhUVd1UHSZ7HmcJcOar68H2fGpytV28Yl8pEEVA+xxzT3W49dekLsCYK2dyZ5hLRTVIHYmkVdTiVQ4nrVe26Q8Z8AyMDaTQOkqSK5rW4ltaChkhA5XiaZMkXwoHA1ffQt4OfzLFq1RLX+LGfVyTUhCQ/MMPpFdyrQ1K/h7k/6vP0OiKSqG5X2J3kbW/u71XmZzFTD89nGj2tCYP37NLN36Yyde2P5fI5E0CoIaSrUhqwUhZ9kziL6HN+ROXYt0rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5LuyGNhNrlfcnZvv+W7xKG+CckyJ2SriczrGAChgeKw=;
 b=XOA9WqYG/R8MdVj5yz7/eDSAuikzxjK+/MLf8gx4pFxlG6TsJK9f45ORxlgvY5cImQ+Gpir88Y8fWZdyCnzOvuF6hU/MGQ8LamK+mtPIF8Z69CrRbR8h3coqv+mek5v/CrR9rAbc5KFEIzIoc6sg3x8WMP4Pf+9JcWDsdjr64I4u5kEeFgoHmO3xqs0neQggyaB2LuDh4//cZlWABwN2Jr/bXqZJHlgt7/NLHC/DYUX2qUyo2bp/m0PSVDZDV1/x5zjgJON2BBN8BOpLf3PYPIbQsgAE2ixRJpIH9eS4UxHtmjK7DAvSVNH2HeX3fxXUiSUuUdFplBF44RlMzvNjzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5LuyGNhNrlfcnZvv+W7xKG+CckyJ2SriczrGAChgeKw=;
 b=uWEfBo6Bhp9XzFzTljWeQO/BiaFxjloRp3OVrTwnUYLvLK2yM7XK/MeWb6U7Uo3OQy8ffg8jCd7Wb3iUAraTiHm1ObmViylLDdge+rr/L4O0NjqnUwcwmtjs5FspBSTSsAG5EvNoVL+I1ODFVWP9qZK1FgcwJKV83kCgH9zPxxw=
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com (10.170.236.143) by
 VI1PR08MB3342.eurprd08.prod.outlook.com (52.134.31.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.18; Thu, 29 Aug 2019 08:23:21 +0000
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a]) by VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a%3]) with mapi id 15.20.2178.023; Thu, 29 Aug 2019
 08:23:21 +0000
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
Subject: [PATCH v3 2/2] KVM: x86: set ctxt->have_exception in
 x86_decode_insn()
Thread-Topic: [PATCH v3 2/2] KVM: x86: set ctxt->have_exception in
 x86_decode_insn()
Thread-Index: AQHVXkMEmSTghXkdTUiK1kvyvFq3Lw==
Date:   Thu, 29 Aug 2019 08:23:20 +0000
Message-ID: <1567066988-23376-3-git-send-email-jan.dakinevich@virtuozzo.com>
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
x-ms-office365-filtering-correlation-id: 3c3e0883-dd29-4984-570e-08d72c5a26c9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR08MB3342;
x-ms-traffictypediagnostic: VI1PR08MB3342:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR08MB334239A46E052880A02B7BE98AA20@VI1PR08MB3342.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(39850400004)(396003)(366004)(376002)(199004)(189003)(66476007)(66946007)(66556008)(50226002)(64756008)(66446008)(4744005)(2351001)(2501003)(36756003)(14454004)(8936002)(86362001)(66066001)(81156014)(81166006)(6436002)(5640700003)(6512007)(71200400001)(71190400001)(44832011)(486006)(476003)(6916009)(5660300002)(52116002)(54906003)(14444005)(53936002)(102836004)(99286004)(2906002)(6486002)(478600001)(8676002)(6506007)(386003)(446003)(11346002)(2616005)(26005)(76176011)(186003)(7416002)(305945005)(4326008)(3846002)(25786009)(7736002)(256004)(6116002)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR08MB3342;H:VI1PR08MB2782.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: q3DiaVp4hWiULxowV1pDgjxeXSfK9WEW8wBzGVdas1Mo/ZO2HsqaqFpzsoH9kuwYLF95wjBrpftI/729FlWavKbFzGd1fqrJTy8QV7YiWMOBmop7AVMW/r9ii8GbmPFjPBmnhZQGYFxWwpVKX1mQkzoYmnzCYoglPa0hcHZ14nvQH61Ngv0/Wq7mSK8wUC5aaqGe+N9EPKVI5eSNwrDQrdfmyRkQ9XccEGLsvInQNhxveCYPaSiXimOsBCXvJzM3/WDuNZl6lq2uGUTVgZ19WNmGrX+Tc9H901oXUXZVpFr3VCZgHfxfoooJfb6/pMSV4KR0P8gIZrILyG6eJcrkkZ/ZMlDqiDCkHXadICEJOkquc19Un7yrYS8myoElY1qqSKvgpHt10nKZ9fTqQkyjd6uN23fBZyE6aHHr7egJWPY=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c3e0883-dd29-4984-570e-08d72c5a26c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 08:23:20.9720
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fIqdJ/wOOewmNj1Iix3FSzGuVpEbFiDhUfkdEy9G7wmONvqLnDzk+NcTNXFC4nW3fJd/zVUORy+yanKdhdNrdmFH/lnCJ6O9IhJGyiJvAAo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3342
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

x86_emulate_instruction() takes into account ctxt->have_exception flag
during instruction decoding, but in practice this flag is never set in
x86_decode_insn().

Fixes: 6ea6e84 ("KVM: x86: inject exceptions produced by x86_decode_insn")
Cc: Denis Lunev <den@virtuozzo.com>
Cc: Roman Kagan <rkagan@virtuozzo.com>
Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
---
 arch/x86/kvm/emulate.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index bef3c3c..698efb8 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -5416,6 +5416,8 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, vo=
id *insn, int insn_len)
 					ctxt->memopp->addr.mem.ea + ctxt->_eip);
=20
 done:
+	if (rc =3D=3D X86EMUL_PROPAGATE_FAULT)
+		ctxt->have_exception =3D true;
 	return (rc !=3D X86EMUL_CONTINUE) ? EMULATION_FAILED : EMULATION_OK;
 }
=20
--=20
2.1.4

