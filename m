Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B41AB9E8A1
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 15:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbfH0NHJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 09:07:09 -0400
Received: from mail-eopbgr30119.outbound.protection.outlook.com ([40.107.3.119]:35904
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726170AbfH0NHG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 09:07:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E9gtfSZk9QPeRHJrMrgZ4WFRMOUEvOSqGikHLrOQ4zR+atZB6TCIFN5nvFMMGj0+s+1zULE48HLM4nsM6SzWojHq6cR3sDe6jC9fZFUHVTKaMalfsiUWiXjaGLlUu6jEWkxCVwBNqrp6RjHOr+wN3EAwMlB+VawW/UIP909f7gf2QprsJFb7DIrn18835JvN7ypqUZWJC57pYrBLfKGZY9F2Yd1FqUsPBF1AbXGcG2iHoyiZ4PgooUUmBlYJsUWnz8pqvlSa0KRGAi8xmf/SlVXGVr3Cz2TvD+KSITWB4zW10nTSQ5kUxI7Rr47o7bSageNvE8ghzg0QkizpDBkc2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=svMO617yxV9WjSTdFYoLpdoZVKjKefsZQpgPhyC5Fp4=;
 b=MpudOCttzB2+S2WFE9mHf+5/c+xn85Z5vgNzRlvNaq+lSfqHJX4ZhfiWftdUOnUoiMeQ+2xtOMVjQnR6m+b1Ao4ACvqae/FbuBSXSmoP3JZBHj8n3mZjaWaFwd45lXv5mCwILkvucDuNV+x7SB0ZS2Gbpvjyau6rQ9D98aEZFbCCFCn4mMXSVjBGboYpzVQReBu6DCL0klhqYBpypS5+wfz2s7tz6bdSoTGXir3mO3MUjwv906Xm2F48tKjFI3bmqBIrudjfb/XqgLgmNcqix3lCSKljcnPF2BT3bG4f2Q4aC7UGE0EpDGzne9GsZLR7VaAYSGXRivWA51H3mAefMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=svMO617yxV9WjSTdFYoLpdoZVKjKefsZQpgPhyC5Fp4=;
 b=Ubt7/bPO+Xm038/qVDR8KdiZpA3fzuP4i3EbBtXLCO8qfVcV1sEdWkkF7IGi8qO/RTqpIx3nX3lVLVisr0yEFgxy/ZHyTq3Qp2HJtHnCjm51TJRY2MVMo5huLLJugnAADV0qNIOYXeBcd5+HdEwjyGW9K3tCp/4/8nOtespXBo4=
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com (10.170.236.143) by
 VI1PR08MB3471.eurprd08.prod.outlook.com (20.177.59.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Tue, 27 Aug 2019 13:07:04 +0000
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a]) by VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a%3]) with mapi id 15.20.2178.023; Tue, 27 Aug 2019
 13:07:04 +0000
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
Subject: [PATCH 1/3] KVM: x86: fix wrong return code
Thread-Topic: [PATCH 1/3] KVM: x86: fix wrong return code
Thread-Index: AQHVXNhSm57U5w68n0a9k1WFYt6uIw==
Date:   Tue, 27 Aug 2019 13:07:04 +0000
Message-ID: <1566911210-30059-2-git-send-email-jan.dakinevich@virtuozzo.com>
References: <1566911210-30059-1-git-send-email-jan.dakinevich@virtuozzo.com>
In-Reply-To: <1566911210-30059-1-git-send-email-jan.dakinevich@virtuozzo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0802CA0004.eurprd08.prod.outlook.com
 (2603:10a6:3:bd::14) To VI1PR08MB2782.eurprd08.prod.outlook.com
 (2603:10a6:802:19::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jan.dakinevich@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.1.4
x-originating-ip: [185.231.240.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb45f6f4-cc33-4b60-90ff-08d72aef74f6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR08MB3471;
x-ms-traffictypediagnostic: VI1PR08MB3471:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR08MB3471FF0F88E640E8371AD4C08AA00@VI1PR08MB3471.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39840400004)(396003)(376002)(366004)(346002)(136003)(199004)(189003)(25786009)(54906003)(6436002)(6512007)(5660300002)(64756008)(7736002)(26005)(4744005)(66946007)(36756003)(66446008)(186003)(66556008)(102836004)(7416002)(305945005)(50226002)(2906002)(52116002)(11346002)(486006)(476003)(2616005)(14444005)(6506007)(386003)(44832011)(76176011)(446003)(256004)(66066001)(99286004)(316002)(66476007)(53936002)(14454004)(5640700003)(2501003)(81156014)(6116002)(6486002)(71200400001)(2351001)(81166006)(6916009)(4326008)(86362001)(3846002)(8676002)(71190400001)(478600001)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR08MB3471;H:VI1PR08MB2782.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PMJObK75TD/Un6nmv5QMkeoE11yAPQQOaRm2D3fBt+UtVTclu5GkeoklEerNgqdDmGuv5cQsK+UNirnN1G5Kx8j6nmPd6T3CUtk3AvqItB/wX4xfdWSJf8RdTdxU/Cv347PxRjRCyxervG5xk5KWjQh/pGFXgK95l7JEWxmO+f0BjocQeg1PphaBo6UIKTwQl+/nkDId5qdWsgRrkDFKNHJM23jQmdl74JbUo34nWmMJ1wUrcIW1f6OXW1yJ446ZkfSuZQRomTdN3kxRFQfze26sCD/oYz7xNRdavKHsr1M9RdsKZ5iVeiYFkPtKC9CCPAc/rkvJ/MccWBppJUMqhckdmFhA5aXoC0KwV2f7/Hncs7fp0nTnhkZ1zp/YT8+fd2cwP+Bq849uzoj3zgCiux02XtPWYTQTUjaAZv2riEE=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb45f6f4-cc33-4b60-90ff-08d72aef74f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2019 13:07:04.7828
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1YneTsPm869tBdRtWEp5o2kfweg3PnVCiAupsk0onmZtt9VD0+9lf0gG5Y/pxR7AjSKWYtxHGlzevps5ft+/0dIrHlqlCxRYTvuQUuWVeNU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3471
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

x86_emulate_instruction(), the caller of x86_decode_insn(), expects
that x86_decode_insn()'s returning value belongs to EMULATION_* name
space. However, this function may return value from X86EMUL_* name
space.

Although, the code behaves properly (because both X86EMUL_CONTINUE and
EMULATION_OK are equal to 0) this change makes code more consistent and
it is required for further fixes.

Cc: Denis Lunev <den@virtuozzo.com>
Cc: Roman Kagan <rkagan@virtuozzo.com>
Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
---
 arch/x86/kvm/emulate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 718f7d9..6170ddf 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -5144,7 +5144,7 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, vo=
id *insn, int insn_len)
 	else {
 		rc =3D __do_insn_fetch_bytes(ctxt, 1);
 		if (rc !=3D X86EMUL_CONTINUE)
-			return rc;
+			goto done;
 	}
=20
 	switch (mode) {
--=20
2.1.4

