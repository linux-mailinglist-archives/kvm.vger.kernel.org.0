Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31D1D745368
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 02:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbjGCAz6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Jul 2023 20:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjGCAz6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Jul 2023 20:55:58 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1AEAE44;
        Sun,  2 Jul 2023 17:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1688345754;
        bh=FeLntdASzvWztXJYx3FPLBi6IsJR0YozWqTAPkr742E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SmstCbxGCKA3MP9B+JhujVSmfeoOtxg08l3M/1VgglnKhQ8WZ4qTYsA8AnqUb27CS
         vlJysR4pyMSIJaFiSK1aRYoPh5dN7zTRnygHjU/V2Z/Evn8tv+C/cADZP4s4Y4Lo15
         eCfg+Qfa1EbJ4AHUm9bW6z8QbmP3p5jnslKKg3pxzjTryWVj4bD6v0w99oX3nWiKtM
         H3txxtsh6uFplhrNsuxVnV+++82MAzD0uEteiqB74YlmpZv2UsX0s6CcZyJqYOfZFf
         e3zlc65vCbSe5Z/NnzPy9ZdCx5pOkfvKDNTWZH7hI+veW3TDGADjxPSvgs11smxSXj
         IFjuDZ7EmYF0A==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4QvSCY4Lzyz4wb1;
        Mon,  3 Jul 2023 10:55:53 +1000 (AEST)
Date:   Mon, 3 Jul 2023 10:55:52 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Anup Patel <anup@brainfault.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul@pwsan.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Anup Patel <apatel@ventanamicro.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        KVM <kvm@vger.kernel.org>
Subject: Re: linux-next: manual merge of the kvm-riscv tree with the risc-v
 tree
Message-ID: <20230703105552.5acf5f9f@canb.auug.org.au>
In-Reply-To: <20230620124533.45c18fee@canb.auug.org.au>
References: <20230620124533.45c18fee@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/7cTy0wTS/3CWFgu5zjddGxq";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/7cTy0wTS/3CWFgu5zjddGxq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 20 Jun 2023 12:45:33 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>=20
> Today's linux-next merge of the kvm-riscv tree got a conflict in:
>=20
>   arch/riscv/include/uapi/asm/kvm.h
>=20
> between commit:
>=20
>   bf78f1ea6e51 ("riscv: kvm: Add V extension to KVM ISA")
>=20
> from the risc-v tree and commit:
>=20
>   3177011788ee ("RISC-V: KVM: Allow Svnapot extension for Guest/VM")
>=20
> from the kvm-riscv tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>=20
>=20
> diff --cc arch/riscv/include/uapi/asm/kvm.h
> index 855c047e86d4,a1ca18408bbd..000000000000
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@@ -121,7 -122,7 +122,8 @@@ enum KVM_RISCV_ISA_EXT_ID=20
>   	KVM_RISCV_ISA_EXT_ZICBOZ,
>   	KVM_RISCV_ISA_EXT_ZBB,
>   	KVM_RISCV_ISA_EXT_SSAIA,
>  +	KVM_RISCV_ISA_EXT_V,
> + 	KVM_RISCV_ISA_EXT_SVNAPOT,
>   	KVM_RISCV_ISA_EXT_MAX,
>   };
>  =20
> @@@ -204,13 -205,77 +206,84 @@@ enum KVM_RISCV_SBI_EXT_ID=20
>   #define KVM_REG_RISCV_SBI_MULTI_REG_LAST	\
>   		KVM_REG_RISCV_SBI_MULTI_REG(KVM_RISCV_SBI_EXT_MAX - 1)
>  =20
>  +/* V extension registers are mapped as type 9 */
>  +#define KVM_REG_RISCV_VECTOR		(0x09 << KVM_REG_RISCV_TYPE_SHIFT)
>  +#define KVM_REG_RISCV_VECTOR_CSR_REG(name)	\
>  +		(offsetof(struct __riscv_v_ext_state, name) / sizeof(unsigned long))
>  +#define KVM_REG_RISCV_VECTOR_REG(n)	\
>  +		((n) + sizeof(struct __riscv_v_ext_state) / sizeof(unsigned long))
>  +
> + /* Device Control API: RISC-V AIA */
> + #define KVM_DEV_RISCV_APLIC_ALIGN		0x1000
> + #define KVM_DEV_RISCV_APLIC_SIZE		0x4000
> + #define KVM_DEV_RISCV_APLIC_MAX_HARTS		0x4000
> + #define KVM_DEV_RISCV_IMSIC_ALIGN		0x1000
> + #define KVM_DEV_RISCV_IMSIC_SIZE		0x1000
> +=20
> + #define KVM_DEV_RISCV_AIA_GRP_CONFIG		0
> + #define KVM_DEV_RISCV_AIA_CONFIG_MODE		0
> + #define KVM_DEV_RISCV_AIA_CONFIG_IDS		1
> + #define KVM_DEV_RISCV_AIA_CONFIG_SRCS		2
> + #define KVM_DEV_RISCV_AIA_CONFIG_GROUP_BITS	3
> + #define KVM_DEV_RISCV_AIA_CONFIG_GROUP_SHIFT	4
> + #define KVM_DEV_RISCV_AIA_CONFIG_HART_BITS	5
> + #define KVM_DEV_RISCV_AIA_CONFIG_GUEST_BITS	6
> +=20
> + /*
> +  * Modes of RISC-V AIA device:
> +  * 1) EMUL (aka Emulation): Trap-n-emulate IMSIC
> +  * 2) HWACCEL (aka HW Acceleration): Virtualize IMSIC using IMSIC guest=
 files
> +  * 3) AUTO (aka Automatic): Virtualize IMSIC using IMSIC guest files wh=
enever
> +  *    available otherwise fallback to trap-n-emulation
> +  */
> + #define KVM_DEV_RISCV_AIA_MODE_EMUL		0
> + #define KVM_DEV_RISCV_AIA_MODE_HWACCEL		1
> + #define KVM_DEV_RISCV_AIA_MODE_AUTO		2
> +=20
> + #define KVM_DEV_RISCV_AIA_IDS_MIN		63
> + #define KVM_DEV_RISCV_AIA_IDS_MAX		2048
> + #define KVM_DEV_RISCV_AIA_SRCS_MAX		1024
> + #define KVM_DEV_RISCV_AIA_GROUP_BITS_MAX	8
> + #define KVM_DEV_RISCV_AIA_GROUP_SHIFT_MIN	24
> + #define KVM_DEV_RISCV_AIA_GROUP_SHIFT_MAX	56
> + #define KVM_DEV_RISCV_AIA_HART_BITS_MAX		16
> + #define KVM_DEV_RISCV_AIA_GUEST_BITS_MAX	8
> +=20
> + #define KVM_DEV_RISCV_AIA_GRP_ADDR		1
> + #define KVM_DEV_RISCV_AIA_ADDR_APLIC		0
> + #define KVM_DEV_RISCV_AIA_ADDR_IMSIC(__vcpu)	(1 + (__vcpu))
> + #define KVM_DEV_RISCV_AIA_ADDR_MAX		\
> + 		(1 + KVM_DEV_RISCV_APLIC_MAX_HARTS)
> +=20
> + #define KVM_DEV_RISCV_AIA_GRP_CTRL		2
> + #define KVM_DEV_RISCV_AIA_CTRL_INIT		0
> +=20
> + /*
> +  * The device attribute type contains the memory mapped offset of the
> +  * APLIC register (range 0x0000-0x3FFF) and it must be 4-byte aligned.
> +  */
> + #define KVM_DEV_RISCV_AIA_GRP_APLIC		3
> +=20
> + /*
> +  * The lower 12-bits of the device attribute type contains the iselect
> +  * value of the IMSIC register (range 0x70-0xFF) whereas the higher ord=
er
> +  * bits contains the VCPU id.
> +  */
> + #define KVM_DEV_RISCV_AIA_GRP_IMSIC		4
> + #define KVM_DEV_RISCV_AIA_IMSIC_ISEL_BITS	12
> + #define KVM_DEV_RISCV_AIA_IMSIC_ISEL_MASK	\
> + 		((1U << KVM_DEV_RISCV_AIA_IMSIC_ISEL_BITS) - 1)
> + #define KVM_DEV_RISCV_AIA_IMSIC_MKATTR(__vcpu, __isel)	\
> + 		(((__vcpu) << KVM_DEV_RISCV_AIA_IMSIC_ISEL_BITS) | \
> + 		 ((__isel) & KVM_DEV_RISCV_AIA_IMSIC_ISEL_MASK))
> + #define KVM_DEV_RISCV_AIA_IMSIC_GET_ISEL(__attr)	\
> + 		((__attr) & KVM_DEV_RISCV_AIA_IMSIC_ISEL_MASK)
> + #define KVM_DEV_RISCV_AIA_IMSIC_GET_VCPU(__attr)	\
> + 		((__attr) >> KVM_DEV_RISCV_AIA_IMSIC_ISEL_BITS)
> +=20
> + /* One single KVM irqchip, ie. the AIA */
> + #define KVM_NR_IRQCHIPS			1
> +=20
>   #endif
>  =20
>   #endif /* __LINUX_KVM_RISCV_H */

This is now a conflict between the kvm tree and Linus' tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/7cTy0wTS/3CWFgu5zjddGxq
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmSiHJgACgkQAVBC80lX
0GxpwQf/ao5TAkouXVy4EGSDzoUw+WoYSUjuPdSgUuLHFZfJEKbewH6Pzvfb6vpF
scbV81nPVh/gEJmnNF6Q7oiXgzNdMOzmp85yRwNy1lbSKVC1qYIHgN19Tt2HKQMf
L60JvRhoUsYoE5LUtdUFG36paaTmEvYCwwzU1qM4c65mvRh3WvpSDpTgEWeQ9OVt
bYGq90cepQRvpotzsmgUa4gNwmnIq/5q8Qg4yqpPdWYbvEJI1qjUjS7xOgcaN0Vb
HTn1z0Mas4rUFTkXh1X8Wz122Oj/s3xPQsIE/Fj6C0JX3YxCtTc1DRjEGE5nt0Pc
6kY4436CthEVJKO+NVSkK2u/wYyf5g==
=hzwc
-----END PGP SIGNATURE-----

--Sig_/7cTy0wTS/3CWFgu5zjddGxq--
