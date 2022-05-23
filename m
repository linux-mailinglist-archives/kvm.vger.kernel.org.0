Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF5E3530A58
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 10:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbiEWHjm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 03:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiEWHjg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 03:39:36 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31155B7D7;
        Mon, 23 May 2022 00:39:34 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4L66zT4KDFz4xDK;
        Mon, 23 May 2022 16:36:04 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1653287766;
        bh=+0vivFk/Z067mjX8nd9BkvwUKAQ5iry4PW1fq/uku9o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SsoTGujOhHXaP3KkRyCCTMa3dTq9WxGjkSXpTPXv15OdMUiGAzZ/Ul13tm019YcwP
         EDbOZJearfSHoyX0nf5rSPwTiInVNIfQ0JWDI69oMXom9v4yDPlIghkl++m1q3Gf7N
         ntHvW9hD9WxrFaL+QOEvDn7c4/twwXHGddfKYe6oF+WrrEJKoyxj9LVIb98y56iz3e
         zFZeT5jMFbwaoYJ+AoChc5RJWnsH86T62DnGx9429MHUZe5Ki9Uj59O8UtUFI5iqtj
         /HqC1kLH0/UfuooaZYU/vGniCkCx6TAQrZkRSNqiHh+/Xh5lEilZEYnzReHEBCBZMG
         XNj6oorXpIzGg==
Date:   Mon, 23 May 2022 16:36:03 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Oliver Upton <oupton@google.com>, KVM <kvm@vger.kernel.org>
Subject: Re: linux-next: manual merge of the kvm-arm tree with the arm64
 tree
Message-ID: <20220523163603.580fddfa@canb.auug.org.au>
In-Reply-To: <20220504143529.4060ab27@canb.auug.org.au>
References: <20220504143529.4060ab27@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/.hrk+MfNx9SbylaWUw_miKR";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/.hrk+MfNx9SbylaWUw_miKR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 4 May 2022 14:35:29 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Today's linux-next merge of the kvm-arm tree got a conflict in:
>=20
>   arch/arm64/kvm/sys_regs.c
>=20
> between commit:
>=20
>   0b12620fddb8 ("KVM: arm64: Treat ESR_EL2 as a 64-bit register")
>=20
> from the arm64 tree and commits:
>=20
>   e65197666773 ("KVM: arm64: Wire up CP15 feature registers to their AArc=
h64 equivalents")
>   9369bc5c5e35 ("KVM: arm64: Plumb cp10 ID traps through the AArch64 sysr=
eg handler")
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
> diff --cc arch/arm64/kvm/sys_regs.c
> index a4ef986adb5e,031d913cd79e..000000000000
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@@ -2351,6 -2355,123 +2355,123 @@@ static int kvm_handle_cp_64(struct kv=
m_
>   	return 1;
>   }
>  =20
> + static bool emulate_sys_reg(struct kvm_vcpu *vcpu, struct sys_reg_param=
s *params);
> +=20
> + /*
> +  * The CP10 ID registers are architecturally mapped to AArch64 feature
> +  * registers. Abuse that fact so we can rely on the AArch64 handler for=
 accesses
> +  * from AArch32.
> +  */
>  -static bool kvm_esr_cp10_id_to_sys64(u32 esr, struct sys_reg_params *pa=
rams)
> ++static bool kvm_esr_cp10_id_to_sys64(u64 esr, struct sys_reg_params *pa=
rams)
> + {
> + 	u8 reg_id =3D (esr >> 10) & 0xf;
> + 	bool valid;
> +=20
> + 	params->is_write =3D ((esr & 1) =3D=3D 0);
> + 	params->Op0 =3D 3;
> + 	params->Op1 =3D 0;
> + 	params->CRn =3D 0;
> + 	params->CRm =3D 3;
> +=20
> + 	/* CP10 ID registers are read-only */
> + 	valid =3D !params->is_write;
> +=20
> + 	switch (reg_id) {
> + 	/* MVFR0 */
> + 	case 0b0111:
> + 		params->Op2 =3D 0;
> + 		break;
> + 	/* MVFR1 */
> + 	case 0b0110:
> + 		params->Op2 =3D 1;
> + 		break;
> + 	/* MVFR2 */
> + 	case 0b0101:
> + 		params->Op2 =3D 2;
> + 		break;
> + 	default:
> + 		valid =3D false;
> + 	}
> +=20
> + 	if (valid)
> + 		return true;
> +=20
> + 	kvm_pr_unimpl("Unhandled cp10 register %s: %u\n",
> + 		      params->is_write ? "write" : "read", reg_id);
> + 	return false;
> + }
> +=20
> + /**
> +  * kvm_handle_cp10_id() - Handles a VMRS trap on guest access to a 'Med=
ia and
> +  *			  VFP Register' from AArch32.
> +  * @vcpu: The vCPU pointer
> +  *
> +  * MVFR{0-2} are architecturally mapped to the AArch64 MVFR{0-2}_EL1 re=
gisters.
> +  * Work out the correct AArch64 system register encoding and reroute to=
 the
> +  * AArch64 system register emulation.
> +  */
> + int kvm_handle_cp10_id(struct kvm_vcpu *vcpu)
> + {
> + 	int Rt =3D kvm_vcpu_sys_get_rt(vcpu);
>  -	u32 esr =3D kvm_vcpu_get_esr(vcpu);
> ++	u64 esr =3D kvm_vcpu_get_esr(vcpu);
> + 	struct sys_reg_params params;
> +=20
> + 	/* UNDEF on any unhandled register access */
> + 	if (!kvm_esr_cp10_id_to_sys64(esr, &params)) {
> + 		kvm_inject_undefined(vcpu);
> + 		return 1;
> + 	}
> +=20
> + 	if (emulate_sys_reg(vcpu, &params))
> + 		vcpu_set_reg(vcpu, Rt, params.regval);
> +=20
> + 	return 1;
> + }
> +=20
> + /**
> +  * kvm_emulate_cp15_id_reg() - Handles an MRC trap on a guest CP15 acce=
ss where
> +  *			       CRn=3D0, which corresponds to the AArch32 feature
> +  *			       registers.
> +  * @vcpu: the vCPU pointer
> +  * @params: the system register access parameters.
> +  *
> +  * Our cp15 system register tables do not enumerate the AArch32 feature
> +  * registers. Conveniently, our AArch64 table does, and the AArch32 sys=
tem
> +  * register encoding can be trivially remapped into the AArch64 for the=
 feature
> +  * registers: Append op0=3D3, leaving op1, CRn, CRm, and op2 the same.
> +  *
> +  * According to DDI0487G.b G7.3.1, paragraph "Behavior of VMSAv8-32 32-=
bit
> +  * System registers with (coproc=3D0b1111, CRn=3D=3Dc0)", read accesses=
 from this
> +  * range are either UNKNOWN or RES0. Rerouting remains architectural as=
 we
> +  * treat undefined registers in this range as RAZ.
> +  */
> + static int kvm_emulate_cp15_id_reg(struct kvm_vcpu *vcpu,
> + 				   struct sys_reg_params *params)
> + {
> + 	int Rt =3D kvm_vcpu_sys_get_rt(vcpu);
> +=20
> + 	/* Treat impossible writes to RO registers as UNDEFINED */
> + 	if (params->is_write) {
> + 		unhandled_cp_access(vcpu, params);
> + 		return 1;
> + 	}
> +=20
> + 	params->Op0 =3D 3;
> +=20
> + 	/*
> + 	 * All registers where CRm > 3 are known to be UNKNOWN/RAZ from AArch3=
2.
> + 	 * Avoid conflicting with future expansion of AArch64 feature registers
> + 	 * and simply treat them as RAZ here.
> + 	 */
> + 	if (params->CRm > 3)
> + 		params->regval =3D 0;
> + 	else if (!emulate_sys_reg(vcpu, params))
> + 		return 1;
> +=20
> + 	vcpu_set_reg(vcpu, Rt, params->regval);
> + 	return 1;
> + }
> +=20
>   /**
>    * kvm_handle_cp_32 -- handles a mrc/mcr trap on a guest CP14/CP15 acce=
ss
>    * @vcpu: The VCPU pointer

This is now a conflict between the kvm tree and the arm64 tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/.hrk+MfNx9SbylaWUw_miKR
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmKLK1MACgkQAVBC80lX
0Gykrwf/TE/fMdxVa5FSwNyHf9GknoxlGKakukzHDMxelELHyc+Gf7pyr3lR+Yo8
bfqsJAPJHPhm0hR0PYdPSSWLA3cIokKv4Lxw3VYsUnuqblPf+l5hSPUAukugW5IL
OqUbWxOSFfTKtnZpYFk65u7xo+l/ih5k+Hbjp7rsBoWeCahiEeKsgNnAK+YmVydk
y6juX8p0fY4svYEqwR1WtRZVlG2hsTbYosMTL+cA8SyiYx3qD4f4J9AsslMJR2Kp
tUPieghcLHlNS5MPRdSzgdzx7rpiuyu4ex3OMmbAfb3r62pdn2oDgVO2UImqEa3G
3tb2Ulc4HeX/H12ygh/gLVVipgZS+A==
=PPU8
-----END PGP SIGNATURE-----

--Sig_/.hrk+MfNx9SbylaWUw_miKR--
