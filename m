Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6499FF93
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 12:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbfH1KTj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 06:19:39 -0400
Received: from mail-eopbgr130093.outbound.protection.outlook.com ([40.107.13.93]:23438
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726270AbfH1KTi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 06:19:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JwDBm/gOJJw8O0qFGsNZErUa+LO0OP0U+PzqnFuZq2x+NUa6VWudIjKZGGxIYgWYhO8bdtBjb5ljXUwMWiG9WN8r9vgPtSLLCRUgBOo1bsw4eJzCCUXQex9rN6pdx1/Lg9Meg0Ps3m+fEJyng3NjEseDgqnh28LNgfLpXItT50RSvZ2nMEkAzMurlL/gCb0uyNl4yW+toEltZBZzrRIAFC5jVE2RFT4jI+ZOgZ4POrPDXaFtP2l417Pdy9zTNkLSFhV7CYoSFHQtuFWymbhlqQEDCQ+wRiX43hWvqv9v8m1cOPOkSuoCcTC8hX27xrJz3WYWsUeZyza5CP4qTYfM7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tZ6upkmTz0VJ446icbXjeZ8o3D0sFU6LGy+VGq+FlOQ=;
 b=IYfDdSwqTJgtVlKm8xRYKzT8gIo5b1XLrXapIbAVgTXlAkWipN8pXMFwulRsnen4g5fnCmxFhiupdHL1t1Zw5CczQvg/alki5P+p3lhWT6Mv7Bw/peIIEayqyshcOH9ta7Jv/aZ89z4B9tFCXsb2fO4x8oqBJmHGOVyy3nQh33XhCtCt1oXTRmMAbZ/GoKtF//qFM4lVAJgTNNXb7s+JX9/Ok3Z1gCgPtMSOKTGKgXE7aGh38kas7IHaI6NDlaeOB0QMlkPHEfTWtOnxImJYzWSjR5+N6/JDRTwDfYEKTZji3XCjKPydDluGawjazyieh7VBCA5qgWF96ufLagmGfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tZ6upkmTz0VJ446icbXjeZ8o3D0sFU6LGy+VGq+FlOQ=;
 b=ddR5wcDuuGdsqob4qAJLjO87iBU82QAdfvsv851VwXmhY1xMmX+2beWX68+9xTBoBBHPu017UHtpKg4mEFOziR83nCCGYN8KbXyVPOVY4lycb4/kEQfXnnE+4tSUIhQ9SYgk3NI47au4CSbw6351aZAGQ03RDS5TvzWpyuWWhWw=
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com (10.170.236.143) by
 VI1PR08MB3373.eurprd08.prod.outlook.com (20.177.58.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.19; Wed, 28 Aug 2019 10:19:30 +0000
Received: from VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a]) by VI1PR08MB2782.eurprd08.prod.outlook.com
 ([fe80::2969:e370:fb70:71a%3]) with mapi id 15.20.2178.023; Wed, 28 Aug 2019
 10:19:30 +0000
From:   Jan Dakinevich <jan.dakinevich@virtuozzo.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Denis Lunev <den@virtuozzo.com>,
        Roman Kagan <rkagan@virtuozzo.com>,
        Denis Plotnikov <dplotnikov@virtuozzo.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?iso-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/3] KVM: x86: set ctxt->have_exception in
 x86_decode_insn()
Thread-Topic: [PATCH 2/3] KVM: x86: set ctxt->have_exception in
 x86_decode_insn()
Thread-Index: AQHVXNhUGXqiO0HWykadKGZM7EVsb6cPFNEAgAFFooA=
Date:   Wed, 28 Aug 2019 10:19:30 +0000
Message-ID: <20190828131927.8be518098e0690f6e8d39f0c@virtuozzo.com>
References: <1566911210-30059-1-git-send-email-jan.dakinevich@virtuozzo.com>
        <1566911210-30059-3-git-send-email-jan.dakinevich@virtuozzo.com>
        <20190827145358.GD27459@linux.intel.com>
In-Reply-To: <20190827145358.GD27459@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0402CA0045.eurprd04.prod.outlook.com
 (2603:10a6:7:7c::34) To VI1PR08MB2782.eurprd08.prod.outlook.com
 (2603:10a6:802:19::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jan.dakinevich@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: Sylpheed 3.6.0 (GTK+ 2.24.25; x86_64-unknown-linux-gnu)
x-originating-ip: [185.231.240.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6738309f-88f7-429b-37c2-08d72ba13654
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR08MB3373;
x-ms-traffictypediagnostic: VI1PR08MB3373:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR08MB33734F938429C148D539ACF68AA30@VI1PR08MB3373.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 014304E855
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(346002)(376002)(136003)(39850400004)(189003)(199004)(478600001)(4326008)(1076003)(8936002)(256004)(14444005)(186003)(476003)(102836004)(6246003)(6486002)(44832011)(66066001)(305945005)(6512007)(2906002)(446003)(86362001)(66556008)(76176011)(6116002)(8676002)(66446008)(26005)(6436002)(66946007)(64756008)(66476007)(54906003)(7736002)(81156014)(50226002)(386003)(52116002)(25786009)(14454004)(81166006)(71200400001)(71190400001)(316002)(36756003)(486006)(3846002)(5660300002)(99286004)(11346002)(2616005)(7416002)(6506007)(229853002)(6916009)(53936002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR08MB3373;H:VI1PR08MB2782.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7k7fuOfEbReztE8vciO6fIGNi91WttF6uHFpnJc1OPSALsGgxJvq9+2ZZDa44t3/9+ejyKy7aqIxUHwNfYvF12TU0ggTWHx5MIX+3c0lWhDkK1W1+pYma5OP4Uj5vTM44OfmL4t+myvKQoc/zGnAvjS9JjnyOFAFAXBPDBODh6aLoHXRHd+Dz7dIseWZrvjtaR/9mo48NNDuI06zUhWgl2Ums0Htb6WfIAWChKw4HwTpyKuZtCZ3q7jb9Haox42RLB31do1b7HI6+d4GKMe7SabB++oxxDgYFPdDOqcEOhyAQBmPRgJz3Vit955PWtnSCq+ZYo8mg0hFjrPrDa/tO69Cc2yTa3giYh0on2EmTix5bznQyNNAGOyCFjmbhegs4drLKFM0xXvf1D5BTm2E1f27klajiNSlv67MbyQmVQI=
Content-Type: text/plain; charset="iso-8859-2"
Content-ID: <7B34392635C87445B6ED0D0C17CB529C@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6738309f-88f7-429b-37c2-08d72ba13654
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2019 10:19:30.4428
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XumqkVhD2/YFB99q79v+XyKG13P8Zyv4lWJYB3gjo+vSQh1FstVeUJU+iQov1eSvAKO//2T+H6t3jXdtzswgnR+tgucsCmjuGvUh8Cr0OnE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3373
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 27 Aug 2019 07:53:58 -0700
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> On Tue, Aug 27, 2019 at 01:07:08PM +0000, Jan Dakinevich wrote:
> > x86_emulate_instruction() takes into account ctxt->have_exception flag
> > during instruction decoding, but in practice this flag is never set in
> > x86_decode_insn().
> >=20
> > Fixes: 6ea6e84 ("KVM: x86: inject exceptions produced by x86_decode_ins=
n")
> > Cc: Denis Lunev <den@virtuozzo.com>
> > Cc: Roman Kagan <rkagan@virtuozzo.com>
> > Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
> > Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
> > ---
> >  arch/x86/kvm/emulate.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >=20
> > diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> > index 6170ddf..f93880f 100644
> > --- a/arch/x86/kvm/emulate.c
> > +++ b/arch/x86/kvm/emulate.c
> > @@ -5395,6 +5395,8 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt=
, void *insn, int insn_len)
> >  					ctxt->memopp->addr.mem.ea + ctxt->_eip);
> > =20
> >  done:
> > +	if (rc =3D=3D X86EMUL_PROPAGATE_FAULT)
> > +		ctxt->have_exception =3D true;
>=20
> We should add a sanity check or two on the vector since the emulator code
> goes all over the place, e.g. #UD should not be injected/propagated, and
> trap-like exceptions should not be handled/encountered during decode.
> Note, exception_type() also warns on illegal vectors.
>=20
>   WARN_ON_ONCE(ctxt->exception.vector =3D=3D UD_VECTOR ||
> 	       exception_type(ctxt->exception.vector) =3D=3D EXCPT_TRAP);

Ok.

>=20
> >  	return (rc !=3D X86EMUL_CONTINUE) ? EMULATION_FAILED : EMULATION_OK;
> >  }
> > =20
> > --=20
> > 2.1.4
> >=20


--=20
Best regards
Jan Dakinevich
