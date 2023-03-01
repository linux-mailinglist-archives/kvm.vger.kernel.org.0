Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE2106A736D
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 19:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjCAS1o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 13:27:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjCAS1n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 13:27:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150144AFCF
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 10:27:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BA46B810F8
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 18:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD73DC433D2;
        Wed,  1 Mar 2023 18:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677695258;
        bh=8tcuhuBxaNuryy+YMC5HU/Q91+w3y7m5w1hFlQwwp9g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KAcZ2dlyptE+kw3BGUZdUfdwyo4Y16spt+I2AjuAqK33XmnbqAJyMZZJXj12hUhZd
         PKBS4Qmn4me0JKRdZ4BM7XRsCL3BjKxhAqqU7YTcfjo/Kk1YuHkmgnKePK8H1R/aqa
         sHvf0s7Ypjn+JUUOHis3AYDupHtzP8SfJUN2Ii+1OzAtXJ6yU1M1RD9hbFMXfZ8MUJ
         JQ0RgzOvNtyW+WcoalHEVhoJMD2D/Z8SS7LB2AMjXX+xFF1q8DZhEDhoy90bDHnSn0
         rUKHjGE2IV6SnCza29bdVzKjuu5DrfabphMzQFUTf3faqsmfAXDtMU2hr8RXpERTAK
         45xi5PsYKM8RQ==
Date:   Wed, 1 Mar 2023 18:27:31 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Richard Henderson <richard.henderson@linaro.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Heiko Stuebner <heiko@sntech.de>, Guo Ren <guoren@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@rivosinc.com>,
        Wenting Zhang <zephray@outlook.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        David Hildenbrand <david@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Bresticker <abrestic@rivosinc.com>
Subject: Re: [PATCH -next v14 13/19] riscv: signal: Add sigcontext
 save/restore for vector
Message-ID: <Y/+ZE1j2usg5C1Uv@spud>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
 <20230224170118.16766-14-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zIjW5a5S4okYDy11"
Content-Disposition: inline
In-Reply-To: <20230224170118.16766-14-andy.chiu@sifive.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--zIjW5a5S4okYDy11
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 24, 2023 at 05:01:12PM +0000, Andy Chiu wrote:
> From: Greentime Hu <greentime.hu@sifive.com>
>=20
> This patch facilitates the existing fp-reserved words for placement of
> the first extension's context header on the user's sigframe. A context
> header consists of a distinct magic word and the size, including the
> header itself, of an extension on the stack. Then, the frame is followed
> by the context of that extension, and then a header + context body for
> another extension if exists. If there is no more extension to come, then
> the frame must be ended with a null context header. A special case is
> rv64gc, where the kernel support no extensions requiring to expose
> additional regfile to the user. In such case the kernel would place the
> null context header right after the first reserved word of
> __riscv_q_ext_state when saving sigframe. And the kernel would check if
> all reserved words are zeros when a signal handler returns.
>=20
> __riscv_q_ext_state---->|	|<-__riscv_extra_ext_header
> 			~	~
> 	.reserved[0]--->|0	|<-	.reserved
> 		<-------|magic	|<-	.hdr
> 		|	|size	|_______ end of sc_fpregs
> 		|	|ext-bdy|
> 		|	~	~
> 	+)size	------->|magic	|<- another context header
> 			|size	|
> 			|ext-bdy|
> 			~	~
> 			|magic:0|<- null context header
> 			|size:0	|
>=20
> The vector registers will be saved in datap pointer. The datap pointer
> will be allocated dynamically when the task needs in kernel space. On
> the other hand, datap pointer on the sigframe will be set right after
> the __riscv_v_ext_state data structure.
>=20
> Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Suggested-by: Vineet Gupta <vineetg@rivosinc.com>
> Suggested-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> ---

> +static long save_v_state(struct pt_regs *regs, void **sc_vec)
> +{
> +	/*
> +	 * Put __sc_riscv_v_state to the user's signal context space pointed
> +	 * by sc_vec and the datap point the address right
> +	 * after __sc_riscv_v_state.
> +	 */

AFAIU, this comment describes the assignments here. I think it would be
significantly clearer if you defined the variables here & moved the
assignment and comment further down the function.

> +	struct __riscv_ctx_hdr __user *hdr =3D (struct __riscv_ctx_hdr *)(*sc_v=
ec);
> +	struct __sc_riscv_v_state __user *state =3D (struct __sc_riscv_v_state =
*)(hdr + 1);
> +	void __user *datap =3D state + 1;
> +	long err;
> +
> +	/* datap is designed to be 16 byte aligned for better performance */
> +	WARN_ON(unlikely(!IS_ALIGNED((unsigned long)datap, 16)));
> +
> +	riscv_v_vstate_save(current, regs);
> +	/* Copy everything of vstate but datap. */
> +	err =3D __copy_to_user(&state->v_state, &current->thread.vstate,
> +			     offsetof(struct __riscv_v_ext_state, datap));
> +	/* Copy the pointer datap itself. */
> +	err |=3D __put_user(datap, &state->v_state.datap);
> +	/* Copy the whole vector content to user space datap. */
> +	err |=3D __copy_to_user(datap, current->thread.vstate.datap, riscv_v_vs=
ize);
> +	/* Copy magic to the user space after saving  all vector conetext */
> +	err |=3D __put_user(RISCV_V_MAGIC, &hdr->magic);
> +	err |=3D __put_user(riscv_v_sc_size, &hdr->size);
> +	if (unlikely(err))
> +		return err;
> +
> +	/* Only progress the sv_vec if everything has done successfully  */
> +	*sc_vec +=3D riscv_v_sc_size;
> +	return 0;
> +}
>  static long restore_sigcontext(struct pt_regs *regs,
>  	struct sigcontext __user *sc)
>  {
> +	void *sc_ext_ptr =3D &sc->sc_extdesc.hdr;
> +	__u32 rsvd;
>  	long err;
> -	size_t i;
> -
>  	/* sc_regs is structured the same as the start of pt_regs */
>  	err =3D __copy_from_user(regs, &sc->sc_regs, sizeof(sc->sc_regs));
>  	if (unlikely(err))
> -		return err;
> +		goto done;
>  	/* Restore the floating-point state. */
>  	if (has_fpu()) {
>  		err =3D restore_fp_state(regs, &sc->sc_fpregs);
>  		if (unlikely(err))
> -			return err;
> +			goto done;
>  	}
> =20
> -	/* We support no other extension state at this time. */
> -	for (i =3D 0; i < ARRAY_SIZE(sc->sc_fpregs.q.reserved); i++) {
> -		u32 value;
> -
> -		err =3D __get_user(value, &sc->sc_fpregs.q.reserved[i]);
> -		if (unlikely(err))
> +	/* Check the reserved word before extensions parsing */
> +	err =3D __get_user(rsvd, &sc->sc_extdesc.reserved);
> +	if (unlikely(err))
> +		goto done;
> +	if (unlikely(rsvd))
> +		goto invalid;
> +
> +	while (1 && !err) {

This is just while (!err), no?

> +		__u32 magic, size;
> +		struct __riscv_ctx_hdr *head =3D (struct __riscv_ctx_hdr *)sc_ext_ptr;
> +
> +		err |=3D __get_user(magic, &head->magic);
> +		err |=3D __get_user(size, &head->size);
> +		if (err)
> +			goto done;
> +
> +		sc_ext_ptr +=3D sizeof(struct __riscv_ctx_hdr);
> +		switch (magic) {
> +		case END_MAGIC:
> +			if (size !=3D END_HDR_SIZE)
> +				goto invalid;
> +			goto done;
> +		case RISCV_V_MAGIC:
> +			if (!has_vector() || !riscv_v_vstate_query(regs))
> +				goto invalid;
> +			if (size !=3D riscv_v_sc_size)
> +				goto invalid;
> +			err =3D __restore_v_state(regs, sc_ext_ptr);
>  			break;
> -		if (value !=3D 0)
> -			return -EINVAL;
> +		default:
> +			goto invalid;

Why does this need a goto, rather than returning -EINVAL directly?

> +		}
> +		sc_ext_ptr =3D ((void *)(head) + size);
>  	}
> +done:
>  	return err;
> +invalid:
> +	return -EINVAL;
> +}

--zIjW5a5S4okYDy11
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY/+ZEwAKCRB4tDGHoIJi
0skzAP9E/bN4Uo8N3ZZng+eYHTQLuuzWUv3ciD/XP/7xSGynMwEA+/czkY4NFMFm
vAP1PHcHiSJV2xiS3cf22Rg4bVZcNwM=
=hq0j
-----END PGP SIGNATURE-----

--zIjW5a5S4okYDy11--
