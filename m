Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2E46A0809
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 19:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbfH1RDI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 13:03:08 -0400
Received: from mail-eopbgr140095.outbound.protection.outlook.com ([40.107.14.95]:48192
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726837AbfH1RDF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 13:03:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jUJLWoKMmzmjMJ3MYBHkfxkc6oh6SxW4mdmVl7/jWfepDBbb1mEGck+7W1F8nILZCBlio5a/5NjkLqOFyDN2ewASw23W4ybujOkuGwPg7FJumV0iWQYWZyHluMFNYlpr1c3m2QqveYGNt9TzpSpminnLZOd31RQgrPzQcYCJbdZcQ/FxH3u+8N27acrUW25TuXvq1HxKMaHOnFd40SHpv+PQ0XgdV0yBLwfCoQK46FcegviS4k4EW8iSNLa9a7yAjtrN1wQ6FSOhWxkQ722eX1XkSoba3z6tNn7gEVeiTQ1+xTPpA8wfEHN4meXlqdBIUt1fCVDRyRQZUTbSH4lcXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FVE+tKSCP26l93DhJV3K+1nKtyODUHjKA+FnaFcYU5U=;
 b=nVq8w/X5MKOPp65xiQZnNEdvtiTkZ89KGnoP37YAgEZbZHxHLbxfp5ytUK4G/GMtadl4eqoz7Ww2tzbfEKXKtL+Asg6z0EhFZUWAA7PpDy01PVAbwr6MmDuWg2bN2lJwOhUAx5XKhpv43surkZN0wFrM46PYNz/GMCQM/ydlabYDczulHByoEfPrJjpCwJ+cad9H/q+Buq6UB2w0cuCPB6aMgTwPtxp4KZ0tPxq2AxGcrnVJJkAJnTP8ggHHrkcfWCMXgCz9yaZt4fEAPcuo1GjDqYH/kJfSKjYposySjMKII/65gric3npgoK95/AYRo5Cy+6tfyikH4ykJ0Moytg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FVE+tKSCP26l93DhJV3K+1nKtyODUHjKA+FnaFcYU5U=;
 b=DFG79O+vtUwhq+SW1k1JU62KGVHrW7zcVXD46MsVFUTCTG6AN/vTkAj/rvupGzgHGv7BO/hJgOS3d/8QnhIwFt9922/RHtYKKbYEVvVJf3L/ifHB5mhzUw4ia67PC62R+n0IFr0JUm/WekJjkNp9CiY84hixmjdIcZ9uEtVbkYU=
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com (10.170.236.143) by
 VI1PR08MB3181.eurprd08.prod.outlook.com (52.133.15.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.19; Wed, 28 Aug 2019 17:02:59 +0000
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a]) by VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a%3]) with mapi id 15.20.2178.023; Wed, 28 Aug 2019
 17:02:59 +0000
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
Subject: [PATCH v2 3/3] KVM: x86: set ctxt->have_exception in
 x86_decode_insn()
Thread-Topic: [PATCH v2 3/3] KVM: x86: set ctxt->have_exception in
 x86_decode_insn()
Thread-Index: AQHVXcJxnnwQLIGeYUSYlBg22R5cuw==
Date:   Wed, 28 Aug 2019 17:02:59 +0000
Message-ID: <1567011759-9969-4-git-send-email-jan.dakinevich@virtuozzo.com>
References: <1567011759-9969-1-git-send-email-jan.dakinevich@virtuozzo.com>
In-Reply-To: <1567011759-9969-1-git-send-email-jan.dakinevich@virtuozzo.com>
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
x-ms-office365-filtering-correlation-id: 96a8620c-ffc4-4c78-e996-08d72bd99440
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR08MB3181;
x-ms-traffictypediagnostic: VI1PR08MB3181:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR08MB3181536D61CFF41CEC2DD7998AA30@VI1PR08MB3181.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-forefront-prvs: 014304E855
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(346002)(39850400004)(136003)(396003)(189003)(199004)(478600001)(26005)(4326008)(8936002)(14444005)(186003)(102836004)(3846002)(256004)(476003)(44832011)(6486002)(66066001)(6512007)(305945005)(4744005)(2906002)(2501003)(446003)(86362001)(6436002)(6116002)(66446008)(8676002)(66946007)(64756008)(66556008)(76176011)(66476007)(316002)(7736002)(81156014)(52116002)(25786009)(81166006)(71190400001)(71200400001)(6506007)(486006)(386003)(14454004)(53936002)(99286004)(2616005)(5660300002)(6916009)(2351001)(54906003)(5640700003)(36756003)(50226002)(11346002)(7416002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR08MB3181;H:VI1PR08MB2782.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2gaLlwxtNvt9Zytn3/lKCmB93uhWT5fkGLpL/GCZDsvhLcNBwrWL0Ym5i5iGfqTuFEOnQDcLUCnvsRlilg8tDECIdHaPlAYdn6xeoVTo7L4fyTeRRkrZRT8MuDM4M0oU/OT/q54ANg99tN+wtcH5shkHatjD2eu5Jo1KPiNzUhkjAOSXu4pMey5Ak7JA9R9UgWsqaecjiJMuX5VMNvi/pSA3FdEp70biURZIv1L9G3r24YdUoxMCKoBv/Lt+hzD1SlrLS9ZH5jHhvS6rFxfYmgPFykQW1F8S5d37eFkvdMYyw/FmYYTtfqBmQBXPkvRSXAIigd00+ZjW2KtFPb4YWuUoqdi9JxhfGCSxDcKL03UrLIqFz+V46SXye1wDpUcjk/n0W6xC/iz5UNuxj1ULrxWMsV2ODQ5mTySAv60U9lk=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96a8620c-ffc4-4c78-e996-08d72bd99440
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2019 17:02:59.5321
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DPGYn7KqLQz9MV02v8mNpCsTr5LqvI0JLjeycMfdFUq3XfLEMWgvzjFoNz+bLTinRkZBSVE94N3WNzpwBoCLpoLBO+jdycvGm7JZCTl3c7M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3181
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
 arch/x86/kvm/emulate.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index bef3c3c..74b4d79 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -5416,6 +5416,11 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, v=
oid *insn, int insn_len)
 					ctxt->memopp->addr.mem.ea + ctxt->_eip);
=20
 done:
+	if (rc =3D=3D X86EMUL_PROPAGATE_FAULT) {
+		WARN_ON_ONCE(ctxt->exception.vector =3D=3D UD_VECTOR ||
+			     exception_type(ctxt->exception.vector) =3D=3D EXCPT_TRAP);
+		ctxt->have_exception =3D true;
+	}
 	return (rc !=3D X86EMUL_CONTINUE) ? EMULATION_FAILED : EMULATION_OK;
 }
=20
--=20
2.1.4

