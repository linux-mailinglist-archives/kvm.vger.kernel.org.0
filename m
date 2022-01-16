Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E9648FF5B
	for <lists+kvm@lfdr.de>; Sun, 16 Jan 2022 22:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236312AbiAPVyl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Jan 2022 16:54:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233774AbiAPVyl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Jan 2022 16:54:41 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12367C061574;
        Sun, 16 Jan 2022 13:54:41 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JcTMr05B0z4y4r;
        Mon, 17 Jan 2022 08:54:31 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1642370076;
        bh=4Oy66ShTun4ti7zT93SlHvM1ki9/1BUHlvd5thJEPsU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bEc7BpYtzC9Mx9Wq6rpmDsjPVg9amw+gIx42NWxrhfV/m/qASAA1AVf3KsOZ3d2r+
         qdSPlsJUg9+71V5BLF+RwFZ/L5K9RZDHri0Lhnhg/EMNP3ewaO4v0bK3yI6f5KonR5
         pP2KizvVbsbUz25pveCvgXS4zxMbfR2N2kOg5xA8DmM5fmU4PpXPxpQVyNWO46+cqq
         pE/l3rk2jR9qXyb/M8+U2R1BVGAYnlHraLm4KWJH3KI3XoDnAgy3O0p1h/c5wk2fxY
         YaAYZ1XyKxYedMmUv+K5JiKnKATwmIWVhK5VO80HKgxj1Z7WaxCv9sHB9Gyv+PasnO
         Ji6myd+GYnACQ==
Date:   Mon, 17 Jan 2022 08:54:31 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul@pwsan.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Anup Patel <anup.patel@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atish.patra@wdc.com>,
        Atish Patra <atishp@atishpatra.org>,
        Atish Patra <atishp@rivosinc.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: Re: linux-next: manual merge of the kvm tree with the risc-v tree
Message-ID: <20220117085431.7bef9ebc@canb.auug.org.au>
In-Reply-To: <20220112114024.7be8aac6@canb.auug.org.au>
References: <20220112114024.7be8aac6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ls2tCAonIwnKX_AJBeqqKur";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/ls2tCAonIwnKX_AJBeqqKur
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 12 Jan 2022 11:40:24 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the kvm tree got a conflict in:
>=20
>   arch/riscv/include/asm/sbi.h
>=20
> between commit:
>=20
>   b579dfe71a6a ("RISC-V: Use SBI SRST extension when available")
>=20
> from the risc-v tree and commit:
>=20
>   c62a76859723 ("RISC-V: KVM: Add SBI v0.2 base extension")
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
>=20
> diff --cc arch/riscv/include/asm/sbi.h
> index 289621da4a2a,9c46dd3ff4a2..000000000000
> --- a/arch/riscv/include/asm/sbi.h
> +++ b/arch/riscv/include/asm/sbi.h
> @@@ -27,7 -27,14 +27,15 @@@ enum sbi_ext_id=20
>   	SBI_EXT_IPI =3D 0x735049,
>   	SBI_EXT_RFENCE =3D 0x52464E43,
>   	SBI_EXT_HSM =3D 0x48534D,
>  +	SBI_EXT_SRST =3D 0x53525354,
> +=20
> + 	/* Experimentals extensions must lie within this range */
> + 	SBI_EXT_EXPERIMENTAL_START =3D 0x08000000,
> + 	SBI_EXT_EXPERIMENTAL_END =3D 0x08FFFFFF,
> +=20
> + 	/* Vendor extensions must lie within this range */
> + 	SBI_EXT_VENDOR_START =3D 0x09000000,
> + 	SBI_EXT_VENDOR_END =3D 0x09FFFFFF,
>   };
>  =20
>   enum sbi_ext_base_fid {

This is now a conflict between the risc-v tree and Linus' tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/ls2tCAonIwnKX_AJBeqqKur
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmHklBcACgkQAVBC80lX
0Gx0Kgf8DwWsTWCg2uDT5qR3wwkFtCKSuP0wF5QIgkhrkYZpRAudXaqXQyjsiXO5
+sELtoAlDRix1bMM+A470UU5PFX0nol4w3iP+YqQM0blt2K8B8ghCeq4bww4U+RP
f2tE7YVt88/vqoz689CO5XkBSx3FHThW9iyGpZbSdc6ZLALypOB/NSIqQqaMKEfu
qRCNILhu8gVRVsBMXvZeKDEb+w4YdKggW8vifasj+Wldrk+C0r61jc+wycpUvbSS
WBPm5NjAj4Dz1VxUxc/x/TkRJZVzxFI3Z2bj7Zz/1XftvUBrS0MaW7BRoU0gTeUY
iJX/XQCADUMTvHa94AVweB0pauBgqA==
=N0Ig
-----END PGP SIGNATURE-----

--Sig_/ls2tCAonIwnKX_AJBeqqKur--
