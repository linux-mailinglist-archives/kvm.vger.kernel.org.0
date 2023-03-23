Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64EC56C6B89
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 15:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbjCWOu1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 10:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbjCWOuX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 10:50:23 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3C310420;
        Thu, 23 Mar 2023 07:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679582999; x=1711118999;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=h4CS8S4czEwPAj/kAQo+lfzDYMoZ/HCv2kQL4ZKmB4I=;
  b=2s5poOskN+TC41MEI7TcfzWTEmu9ZRAVbdsKfCWarv6dhRFc/IfmiSqU
   utNHjcehkfyK5GHf8AG5T/+k4Kh1P4ix2UweMPN5HAq8CGNuMpA0ea91u
   1pQc6ABOGUVpz8bE/koGQ2p1OSYkatQgtj5OWkBOURrAU9Br1EkNxKJlM
   fntq9j8cBGBQWnE74D9i7eMKGIAPk6v0B5KiET7ZbULWP72lLYDpGcVSH
   y37C4V3mOe1NH2SOMKk2s8nry60hHYZlaZMhLLuZhcyv2PjC/07HFZZR7
   qqyk0Gc24Hi3B6seIcnHg43QPr61+7XpQfcqDABTGtElcTnGD3kVnB9jd
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,285,1673938800"; 
   d="asc'?scan'208";a="143542635"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Mar 2023 07:49:58 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 07:49:56 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Thu, 23 Mar 2023 07:49:53 -0700
Date:   Thu, 23 Mar 2023 14:49:34 +0000
From:   Conor Dooley <conor.dooley@microchip.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Jisheng Zhang <jszhang@kernel.org>
CC:     Conor Dooley <conor@kernel.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
        <regressions@leemhuis.info>, <regressions@lists.linux.dev>
Subject: Re: [PATCH] riscv: require alternatives framework when selecting FPU
 support
Message-ID: <af690061-f962-498e-b2df-d2e6119292cf@spud>
References: <ZBruFRwt3rUVngPu@zx2c4.com>
 <20230322120907.2968494-1-Jason@zx2c4.com>
 <20230322124631.7p67thzeblrawsqj@orel>
 <1884bd96-2783-4556-bc57-8b733758baff@spud>
 <20230322192610.sad42xau33ye5ayn@orel>
 <2a3b08ce-5ab1-41b6-ad58-edbeff7b1acb@spud>
 <ad445951-3d13-4644-94d9-e0989cda39c3@spud>
 <CAHmME9qEbUP7cq-iofN=ruSWhsHUva+qqavfEpNzDK_BjQVqxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WAnLRcLV3Ph+ynOR"
Content-Disposition: inline
In-Reply-To: <CAHmME9qEbUP7cq-iofN=ruSWhsHUva+qqavfEpNzDK_BjQVqxw@mail.gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--WAnLRcLV3Ph+ynOR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 22, 2023 at 09:19:50PM +0100, Jason A. Donenfeld wrote:
> On Wed, Mar 22, 2023 at 9:05=E2=80=AFPM Conor Dooley <conor@kernel.org> w=
rote:
> >
> > On Wed, Mar 22, 2023 at 07:44:13PM +0000, Conor Dooley wrote:
> > > On Wed, Mar 22, 2023 at 08:26:10PM +0100, Andrew Jones wrote:
> > > > On Wed, Mar 22, 2023 at 03:17:13PM +0000, Conor Dooley wrote:
> > > > > On Wed, Mar 22, 2023 at 01:46:31PM +0100, Andrew Jones wrote:
> > >
> > > > > > (It's tempting to just select RISCV_ALTERNATIVE from RISCV, but=
 maybe we
> > > > > >  can defer that wedding a bit longer.)
> > > > >
> > > > > At that point, the config option should just go away entirely, no?
> > > >
> > > > Ah, yes, and that makes the idea even more attractive, as we could =
remove
> > > > several ifdefs.
> > >
> > > I went and did the cursory check, it's not compatible with XIP_KERNEL=
 so
> > > dropping the option entirely probably isn't a possibility :/
> >
> > What I said is only now sinking in. We're now going to be disabling FPU
> > support on XIP kernels with this patch.
> > Well, technically not this patch since it wouldn't have built without
> > Jason's changes, but that doesn't seem like the right thing to do...
>=20
> I suppose you could have riscv_has_extension_*() fall back to
> something that doesn't use alternatives on XIP kernels.

Yah, something like the below I guess? Probably overlooking something
silly & it's lost the benefit of the static branch that it used to have,
but with the infra that we have at the moment this seemed like the
sanest thing to do?

This would requiring picking up your patch Jason, but with an
"if !XIP_KERNEL" added to the select.

It's only had the lightest of build tests, but I can go make it a real
patch if there's not something obviously amiss.

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index e3021b2590de..6263a0de1c6a 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -57,18 +57,31 @@ struct riscv_isa_ext_data {
 	unsigned int isa_ext_id;
 };
=20
+unsigned long riscv_isa_extension_base(const unsigned long *isa_bitmap);
+
+#define riscv_isa_extension_mask(ext) BIT_MASK(RISCV_ISA_EXT_##ext)
+
+bool __riscv_isa_extension_available(const unsigned long *isa_bitmap, int =
bit);
+#define riscv_isa_extension_available(isa_bitmap, ext)	\
+	__riscv_isa_extension_available(isa_bitmap, RISCV_ISA_EXT_##ext)
+
 static __always_inline bool
 riscv_has_extension_likely(const unsigned long ext)
 {
 	compiletime_assert(ext < RISCV_ISA_EXT_MAX,
 			   "ext must be < RISCV_ISA_EXT_MAX");
=20
-	asm_volatile_goto(
-	ALTERNATIVE("j	%l[l_no]", "nop", 0, %[ext], 1)
-	:
-	: [ext] "i" (ext)
-	:
-	: l_no);
+	if (IS_ENABLED(CONFIG_RISCV_ALTERNATIVE)) {
+		asm_volatile_goto(
+		ALTERNATIVE("j	%l[l_no]", "nop", 0, %[ext], 1)
+		:
+		: [ext] "i" (ext)
+		:
+		: l_no);
+	} else {
+		if (!__riscv_isa_extension_available(NULL, ext))
+			goto l_no;
+	}
=20
 	return true;
 l_no:
@@ -81,26 +94,23 @@ riscv_has_extension_unlikely(const unsigned long ext)
 	compiletime_assert(ext < RISCV_ISA_EXT_MAX,
 			   "ext must be < RISCV_ISA_EXT_MAX");
=20
-	asm_volatile_goto(
-	ALTERNATIVE("nop", "j	%l[l_yes]", 0, %[ext], 1)
-	:
-	: [ext] "i" (ext)
-	:
-	: l_yes);
+	if (IS_ENABLED(CONFIG_RISCV_ALTERNATIVE)) {
+		asm_volatile_goto(
+		ALTERNATIVE("nop", "j	%l[l_yes]", 0, %[ext], 1)
+		:
+		: [ext] "i" (ext)
+		:
+		: l_yes);
+	} else {
+		if (__riscv_isa_extension_available(NULL, ext))
+			goto l_yes;
+	}
=20
 	return false;
 l_yes:
 	return true;
 }
=20
-unsigned long riscv_isa_extension_base(const unsigned long *isa_bitmap);
-
-#define riscv_isa_extension_mask(ext) BIT_MASK(RISCV_ISA_EXT_##ext)
-
-bool __riscv_isa_extension_available(const unsigned long *isa_bitmap, int =
bit);
-#define riscv_isa_extension_available(isa_bitmap, ext)	\
-	__riscv_isa_extension_available(isa_bitmap, RISCV_ISA_EXT_##ext)
-
 #endif
=20
 #endif /* _ASM_RISCV_HWCAP_H */

--WAnLRcLV3Ph+ynOR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZBxm/gAKCRB4tDGHoIJi
0iuPAQCj0oB2PJm3sAnzQn4lJ3P3IQyfftDTZrZVctDQipZ9xwD8DCL8PQqFHGGb
iqK+RMu43c4MOpwgWxlM+qkjCjCdTQg=
=RGLC
-----END PGP SIGNATURE-----

--WAnLRcLV3Ph+ynOR--
