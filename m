Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43D4266BFC
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 14:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbfGLMDI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 08:03:08 -0400
Received: from mail-mr2fra01hn0201.outbound.protection.outlook.com ([52.101.140.201]:24702
        "EHLO FRA01-MR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726250AbfGLMDI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 08:03:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PYOP42WAQOCgeWncfJNjk+S8eHm4Eqk3wr5bM8vM9GHQHTiKj3r6/0a/XmEf/8fRVEJMbYM6FNQW314agkbIg/DQ2yczTZVLYdbJ/NQEL4Nzo/Vi+gPsI0LAmIliDhfRSbkahlc8lCqDdddIqPmf/tY0NmaY9NhMxJExVqQyfSMIaC05q317DuwmGhImyfMluWODcYrHOitzziR3eepHahU/LXbpGA1BFD/kf8Q7XFP5kk5c2v2oqTkKl2zMJc9zG5gVOdQ4zXaMVGMEw/zBNPvMPm9Fuc5mN6aSWYzsRCMzwNDS2gEPaAW7P3CrJdkUc5zlgb3hQOdnbKMoqRmtfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xmY1mv+dHio+3MItvVkGF63PN/fcqxkb5pNdFzFKjac=;
 b=czxS7fCTdDOlpy9l0YOEt9h8lu3fGGlAeR+bLiGbAiDlBOjE4s7P/UnSaFvE8e3t170sQYQNg+6WdaS62kx8xZ88THO65JOaWt9+idChWAdYlcSj26Ugkz8f516DJ5pJzLlb93CPo/f2uiTPlGCk3b/is8IvKjbsQXMg7IMeBQRFYNgbZ4o2hwD3/P6XBCDuqZQZREyHem1xFOLAptpiP1wUukmdcYGGbTgTc57HM0eEuc5hrclhQyN9x98QAjj5LppwirEFYU4KefAmadKWCWgy4jeqLSvZFgm8bcBjblyJ1ajPrIFUSemah6c6avfV0UGV7ZEFGoyVWWv9Ua2MGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=virtuozzo.com;dmarc=pass action=none
 header.from=virtuozzo.com;dkim=pass header.d=virtuozzo.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xmY1mv+dHio+3MItvVkGF63PN/fcqxkb5pNdFzFKjac=;
 b=KyuZc7NBMvmQS5vZOcfALTf/7XSwD8Fq/cYwLb0LjBEJlcv/K+igDUEiher2oy+BZGYh3emhIHF83rLUcE8xUTPZVaweBEF/BUJGzomsEFx3RYakPLWezJLdNF9Aft4uch/o7nrhsfNHtTTas8/0AFJYV+WsG2bNM6VrwiePsz0=
Received: from PR2PR08MB4649.eurprd08.prod.outlook.com (52.133.107.81) by
 PR2PR08MB4876.eurprd08.prod.outlook.com (52.133.109.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Fri, 12 Jul 2019 12:02:53 +0000
Received: from PR2PR08MB4649.eurprd08.prod.outlook.com
 ([fe80::bd59:a723:4d09:9e88]) by PR2PR08MB4649.eurprd08.prod.outlook.com
 ([fe80::bd59:a723:4d09:9e88%7]) with mapi id 15.20.2052.020; Fri, 12 Jul 2019
 12:02:53 +0000
From:   Roman Kagan <rkagan@virtuozzo.com>
To:     Arnd Bergmann <arnd@arndb.de>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        =?iso-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH 1/2] x86: kvm: avoid -Wsometimes-uninitized warning
Thread-Topic: [PATCH 1/2] x86: kvm: avoid -Wsometimes-uninitized warning
Thread-Index: AQHVOJH6diSyEW2P2EODPrXdUKWMMKbG4k+A
Date:   Fri, 12 Jul 2019 12:02:53 +0000
Message-ID: <20190712120249.GA27820@rkaganb.sw.ru>
References: <20190712091239.716978-1-arnd@arndb.de>
In-Reply-To: <20190712091239.716978-1-arnd@arndb.de>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.12.0 (2019-05-25)
mail-followup-to: =?iso-8859-2?Q?Roman_Kagan_<rkagan@virtuozzo.com>,=09Arnd_Bergmann_<arnd@?=
 =?iso-8859-2?Q?arndb.de>,_Paolo_Bonzini_<pbonzini@redhat.com>,=09Radim_Kr?=
 =?iso-8859-2?Q?=E8m=E1=F8_<rkrcmar@redhat.com>,=09Thomas_Gleixner_<tglx@l?=
 =?iso-8859-2?Q?inutronix.de>,=09Ingo_Molnar_<mingo@redhat.com>,_Borislav_?=
 =?iso-8859-2?Q?Petkov_<bp@alien8.de>,=09x86@kernel.org,_"H._Peter_Anvin"_?=
 =?iso-8859-2?Q?<hpa@zytor.com>,=09Vitaly_Kuznetsov_<vkuznets@redhat.com>,?=
 =?iso-8859-2?Q?=09Liran_Alon_<liran.alon@oracle.com>,_kvm@vger.kernel.org?=
 =?iso-8859-2?Q?,=09linux-kernel@vger.kernel.org,_clang-built-linux@google?=
 =?iso-8859-2?Q?groups.com?=
x-originating-ip: [185.231.240.5]
x-clientproxiedby: HE1P18901CA0008.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:3:8b::18) To PR2PR08MB4649.eurprd08.prod.outlook.com
 (2603:10a6:101:18::17)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=rkagan@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e546975-b305-4ea4-d086-08d706c0de75
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:PR2PR08MB4876;
x-ms-traffictypediagnostic: PR2PR08MB4876:|PR2PR08MB4876:
x-microsoft-antispam-prvs: <PR2PR08MB4876A9811F5F39F7C0D5020AC9F20@PR2PR08MB4876.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 00963989E5
x-forefront-antispam-report: SFV:SPM;SFS:(10019020)(396003)(39850400004)(366004)(376002)(346002)(136003)(52314003)(189003)(199004)(11346002)(1076003)(8936002)(86362001)(446003)(26005)(66476007)(66446008)(64756008)(66556008)(305945005)(66946007)(7416002)(6506007)(386003)(6486002)(229853002)(53936002)(68736007)(7736002)(5660300002)(486006)(8676002)(81156014)(81166006)(476003)(33656002)(6116002)(36756003)(6436002)(54906003)(99286004)(52116002)(71200400001)(6916009)(71190400001)(14454004)(256004)(14444005)(76176011)(316002)(3846002)(478600001)(9686003)(6246003)(102836004)(58126008)(186003)(66066001)(2906002)(4326008)(6512007)(25786009)(30126002);DIR:OUT;SFP:1501;SCL:5;SRVR:PR2PR08MB4876;H:PR2PR08MB4649.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: aZEEVmJq9Ai+pTBpi0Z64R1J46fPFywjKn+Rny4npfJf93oQbVKE3MXqS0YWWmugIRSK0oTQd0QCF1yim3Fil1s6u2E97gWk/91eEPugOVaprimjDFJUqGSLGT+Yo/4R0iqFBOlMzBr8hL65OX4dsLC7vJ0l1LmnHU7moJzGyAXCUyk0eBLlPp7B3c2VrhVs7VJhWFQbpRaIxUAxRC1/VhpZbqO/E9xQNEZbKAuAdCsEHiBjj0kMb+3wFL4aifiITFpwg7Aq9KHjoOQ6ksmcoRVTZj85MBQp1vAQYKHPTMbD5VfEOirEEGH/7tpmD3yAGNLVUcGV0mSgA2LaPsc6/dyf4zzCRbFrUhP7SMSSupCenEwr1eWxrhOawMDUzqb7Tk56mEkxxJz6kbKeN04rOJSiGUVShWntTdVVkNjLQlxfRlFfjvZYdXxilzYjGZUymdIjEr3QuZnkooKQgdT1gkcZNIYbOIbBrkwMxEfWKj3pYqvdPfeWO/08qk1QVcHT
Content-Type: text/plain; charset="iso-8859-2"
Content-ID: <87266A893EA54040A4AA25B17E388B6A@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e546975-b305-4ea4-d086-08d706c0de75
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2019 12:02:53.4013
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rkagan@virtuozzo.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR2PR08MB4876
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 12, 2019 at 11:12:29AM +0200, Arnd Bergmann wrote:
> clang points out that running a 64-bit guest on a 32-bit host
> would lead to uninitialized variables:
>=20
> arch/x86/kvm/hyperv.c:1610:6: error: variable 'ingpa' is used uninitializ=
ed whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>         if (!longmode) {
>             ^~~~~~~~~
> arch/x86/kvm/hyperv.c:1632:55: note: uninitialized use occurs here
>         trace_kvm_hv_hypercall(code, fast, rep_cnt, rep_idx, ingpa, outgp=
a);
>                                                              ^~~~~
> arch/x86/kvm/hyperv.c:1610:2: note: remove the 'if' if its condition is a=
lways true
>         if (!longmode) {
>         ^~~~~~~~~~~~~~~
> arch/x86/kvm/hyperv.c:1595:18: note: initialize the variable 'ingpa' to s=
ilence this warning
>         u64 param, ingpa, outgpa, ret =3D HV_STATUS_SUCCESS;
>                         ^
>                          =3D 0
> arch/x86/kvm/hyperv.c:1610:6: error: variable 'outgpa' is used uninitiali=
zed whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
> arch/x86/kvm/hyperv.c:1610:6: error: variable 'param' is used uninitializ=
ed whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>=20
> Since that combination is not supported anyway, change the condition
> to tell the compiler how the code is actually executed.

Hmm, the compiler *is* told all it needs:


arch/x86/kvm/x86.h:
...
static inline int is_long_mode(struct kvm_vcpu *vcpu)
{
#ifdef CONFIG_X86_64
	return vcpu->arch.efer & EFER_LMA;
#else
	return 0;
#endif
}

static inline bool is_64_bit_mode(struct kvm_vcpu *vcpu)
{
	int cs_db, cs_l;

	if (!is_long_mode(vcpu))
		return false;
	kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
	return cs_l;
}
...

so in !CONFIG_X86_64 case is_64_bit_mode() unconditionally returns
false, and the branch setting the values of the variables is always
taken.

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/x86/kvm/hyperv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index a39e38f13029..950436c502ba 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1607,7 +1607,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
> =20
>  	longmode =3D is_64_bit_mode(vcpu);
> =20
> -	if (!longmode) {
> +	if (!IS_ENABLED(CONFIG_X86_64) || !longmode) {
>  		param =3D ((u64)kvm_rdx_read(vcpu) << 32) |
>  			(kvm_rax_read(vcpu) & 0xffffffff);
>  		ingpa =3D ((u64)kvm_rbx_read(vcpu) << 32) |

So this is rather a workaround for the compiler giving false positive.
I suggest to at least rephrase the log message to inidcate this.

Roman.
