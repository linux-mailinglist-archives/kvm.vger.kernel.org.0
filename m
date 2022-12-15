Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C46C64E4A8
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 00:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiLOX1O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 18:27:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiLOX1L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 18:27:11 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B86850D45;
        Thu, 15 Dec 2022 15:26:58 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4NY7fl2S2zz4xFy;
        Fri, 16 Dec 2022 10:26:55 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1671146816;
        bh=v2AHfR+82RtV0sKpDBXTbf/zmcDHdVuGQk+jo2tHN8I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ONMnnApuYu8CbdvBvMu0beq5Av1emjFc7jB/GWxCG4WCDduseKB1LppRmZOf2VpbM
         5QAGufkPCXOcSchFhOaloO1zSvZ6ZIsWyo/ffVjHSjr5mvgkFAjEckVk00vKtEDOF4
         rk0vroRkYLXcoz8TEQ+utiw87QWOOYcb4bt7QFyR/FkD2yxFI2XHvdFF8KsRhn164Y
         RUbj8N/CaOuruEpDDSn7gFHucJjMfyRL+deI3keujVVDRJ7ax/oWJy1wdgZtpB/Naw
         7gStjYsYNd32KSK+hqOUMG3k0XTcpyzeBFKGwFDg6na9iQSvqXlYx0w77ScX6f/sIO
         1a2UR9DG3Kizg==
Date:   Fri, 16 Dec 2022 10:26:54 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: manual merge of the kvm tree with the tip tree
Message-ID: <20221216102654.084efc38@canb.auug.org.au>
In-Reply-To: <20221201111408.05e4edaa@canb.auug.org.au>
References: <20221201111408.05e4edaa@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/+bYwiv08zE/aI24lqa8b.W8";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/+bYwiv08zE/aI24lqa8b.W8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 1 Dec 2022 11:14:08 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>=20
> Today's linux-next merge of the kvm tree got a conflict in:
>=20
>   arch/x86/include/asm/cpufeatures.h
>=20
> between commit:
>=20
>   aa387b1b1e66 ("x86: CPUID and CR3/CR4 flags for Linear Address Masking")
>=20
> from the tip tree and commits:
>=20
>   6a19d7aa5821 ("x86: KVM: Advertise CMPccXADD CPUID to user space")
>   af2872f62254 ("x86: KVM: Advertise AMX-FP16 CPUID to user space")
>   5e85c4ebf206 ("x86: KVM: Advertise AVX-IFMA CPUID to user space")
>=20
> from the kvm tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>=20
> --=20
> Cheers,
> Stephen Rothwell
>=20
> diff --cc arch/x86/include/asm/cpufeatures.h
> index 11a0e06362e4,1419c4e04d45..000000000000
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@@ -311,7 -308,9 +311,10 @@@
>   /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 =
*/
>   #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
>   #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instruct=
ions */
> + #define X86_FEATURE_CMPCCXADD           (12*32+ 7) /* "" CMPccXADD inst=
ructions */
> + #define X86_FEATURE_AMX_FP16		(12*32+21) /* "" AMX fp16 Support */
> + #define X86_FEATURE_AVX_IFMA            (12*32+23) /* "" Support for VP=
MADD52[H,L]UQ */
>  +#define X86_FEATURE_LAM			(12*32+26) /* Linear Address Masking */
>  =20
>   /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
>   #define X86_FEATURE_CLZERO		(13*32+ 0) /* CLZERO instruction */

This is now a conflict between the tip tree and Libnus' tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/+bYwiv08zE/aI24lqa8b.W8
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmObrT4ACgkQAVBC80lX
0GwbWQf/ZKziOdNiiQTU68Kwfh0tsDqsXzeBvEJpfN+1xGK8zpbuVIRFbdOsY4xf
ApcKNhAaqU4Z9c/RhE/7jn1Sio5uJQZc+rqR5ax2XTYR1CvrxxHoawsnxALf/rS5
usxjgJ4NP8hey0orrz8aygEgfUV8Ee8DUdBTX8oaxx9m/2wOLU9r1vblUEFjzhHD
WadHl6GWDfVC557genMZ8ez0dMAGBZiIlO7RA5Qw1eBWElqmUFzIc3EuOtDb3dmL
H7cR6IwZvoBE/W7iB6iJxA1rKNCsElR3MbcsrXX9b5fPBdutsE4sDHuq5AJ3aZlr
a0shzXbzNm+QHCieEwETuUUa0hfGcQ==
=gK+q
-----END PGP SIGNATURE-----

--Sig_/+bYwiv08zE/aI24lqa8b.W8--
