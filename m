Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07BC474535D
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 02:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjGCAvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Jul 2023 20:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjGCAvI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Jul 2023 20:51:08 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A4CE46;
        Sun,  2 Jul 2023 17:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1688345458;
        bh=W8UTleaI39zhvyKft+IyBAJyhvE7V+oU3D+72yrg5F0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qRrmb5NTY1ow3Ilu1mvFxM+Ue+zCMPXR+MI08Yse4OnproP0NQCyVhSqWpivJWqTL
         NkXNm/328oNJflh/OaEd1vd13yU7zxeDQweqIn2t4mAiYfAzH1Kwe3H/fp2uY7A4cr
         2EdQSUAf110QvU+Q/HokXb70uA2b/Zm06uj1ZprLn9RywR1umW/UUGWpzLHAVjXOWS
         s6rDDdc8tTg5TJGtMKmpWvvWTtBhX2V4MCTL08DgWGU6F+QUAwhjWfW+gmi3oqkefq
         FNSgUCWAR6yWAyOWY7KjavnozXYb+Rv756bYxbtwWtwEJFhV5AIK43GCV8MrRVGQu/
         Zfxcl7CmtY4lw==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4QvS5s7593z4wZs;
        Mon,  3 Jul 2023 10:50:57 +1000 (AEST)
Date:   Mon, 3 Jul 2023 10:50:55 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        KVM <kvm@vger.kernel.org>
Subject: Re: linux-next: manual merge of the kvm-arm tree with the arm64
 tree
Message-ID: <20230703105055.6f44441a@canb.auug.org.au>
In-Reply-To: <20230615122201.75e36abd@canb.auug.org.au>
References: <20230615122201.75e36abd@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/VrmBmzMnHW6Zb=BRqFTbtVd";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/VrmBmzMnHW6Zb=BRqFTbtVd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 15 Jun 2023 12:22:01 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>=20
> Today's linux-next merge of the kvm-arm tree got a conflict in:
>=20
>   arch/arm64/kernel/cpufeature.c
>=20
> between commits:
>=20
>   b7564127ffcb ("arm64: mops: detect and enable FEAT_MOPS")
>   2b760046a2d3 ("arm64: cpufeature: add TCR2 cpucap")
>   e43454c44232 ("arm64: cpufeature: add Permission Indirection Extension =
cpucap")
>=20
> from the arm64 tree and commits:
>=20
>   c876c3f182a5 ("KVM: arm64: Relax trapping of CTR_EL0 when FEAT_EVT is a=
vailable")
>   e2d6c906f0ac ("arm64: Add KVM_HVHE capability and has_hvhe() predicate")
>=20
> from the kvm-arm tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>=20
>=20
> diff --cc arch/arm64/kernel/cpufeature.c
> index 6ea7f23b1287,f6e3598760f1..000000000000
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@@ -2662,27 -2656,23 +2677,44 @@@ static const struct arm64_cpu_capabilit
>   		.cpu_enable =3D cpu_enable_dit,
>   		ARM64_CPUID_FIELDS(ID_AA64PFR0_EL1, DIT, IMP)
>   	},
>  +	{
>  +		.desc =3D "Memory Copy and Memory Set instructions",
>  +		.capability =3D ARM64_HAS_MOPS,
>  +		.type =3D ARM64_CPUCAP_SYSTEM_FEATURE,
>  +		.matches =3D has_cpuid_feature,
>  +		.cpu_enable =3D cpu_enable_mops,
>  +		ARM64_CPUID_FIELDS(ID_AA64ISAR2_EL1, MOPS, IMP)
>  +	},
>  +	{
>  +		.capability =3D ARM64_HAS_TCR2,
>  +		.type =3D ARM64_CPUCAP_SYSTEM_FEATURE,
>  +		.matches =3D has_cpuid_feature,
>  +		ARM64_CPUID_FIELDS(ID_AA64MMFR3_EL1, TCRX, IMP)
>  +	},
>  +	{
>  +		.desc =3D "Stage-1 Permission Indirection Extension (S1PIE)",
>  +		.capability =3D ARM64_HAS_S1PIE,
>  +		.type =3D ARM64_CPUCAP_BOOT_CPU_FEATURE,
>  +		.matches =3D has_cpuid_feature,
>  +		ARM64_CPUID_FIELDS(ID_AA64MMFR3_EL1, S1PIE, IMP)
>  +	},
> + 	{
> + 		.desc =3D "Enhanced Virtualization Traps",
> + 		.capability =3D ARM64_HAS_EVT,
> + 		.type =3D ARM64_CPUCAP_SYSTEM_FEATURE,
> + 		.sys_reg =3D SYS_ID_AA64MMFR2_EL1,
> + 		.sign =3D FTR_UNSIGNED,
> + 		.field_pos =3D ID_AA64MMFR2_EL1_EVT_SHIFT,
> + 		.field_width =3D 4,
> + 		.min_field_value =3D ID_AA64MMFR2_EL1_EVT_IMP,
> + 		.matches =3D has_cpuid_feature,
> + 	},
> + 	{
> + 		.desc =3D "VHE for hypervisor only",
> + 		.capability =3D ARM64_KVM_HVHE,
> + 		.type =3D ARM64_CPUCAP_SYSTEM_FEATURE,
> + 		.matches =3D hvhe_possible,
> + 	},
>   	{},
>   };
>  =20

This is now a conflict between the kvm tree and Linus' tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/VrmBmzMnHW6Zb=BRqFTbtVd
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmSiG3AACgkQAVBC80lX
0GwutwgAnkiwE+j+ht7leaNtMyHvErYDOgyp1MB9I+TwOyB5RpqljcDbrWhNOTXa
XHuVPX2BKJB20Mxkuz48uDqG104FAPJ8Govy1p5n+cqna3esTPAGpzE/nPFueT+g
EDfi/zlL215GzC5/ke+/KCGzBauHsw8F0ejDnry7bE4dm3Y0mXCjyDUztX90E4sn
/B+xQpxkZ+rkxoqAy8stb1Z3SiFfkJSz9Y8eUbAgNAgfATV29jsIVeRQZFOkgGah
8B8QtaFL/6+wNbLnKk1lvby5Qzc2B3pMl442EFWBpTtLMckbdn6RcpYoRY2NcDWt
ZBCIUVgBiKvO5M5oBBomTs+VhOZzfQ==
=/6o9
-----END PGP SIGNATURE-----

--Sig_/VrmBmzMnHW6Zb=BRqFTbtVd--
