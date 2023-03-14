Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 024CA6B9073
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 11:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjCNKpj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 06:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjCNKpi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 06:45:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AAAB14EB4
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 03:45:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6472B817B7
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 10:44:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD02C433D2;
        Tue, 14 Mar 2023 10:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678790673;
        bh=/zc6dyyYEjbrVXwGWF4uQQkOIFQN/MV9XcG7kVyoU8c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=huMTdu+PpFBDNANuJEv3Zffu1Vwm5cnJIAQmdYY3MuN25otEzxcnlFhMmkggk2hUo
         Zg6vJh0QdA9Jnk7zIVTJcZgLygNa22xIIMc2Pcs3GewkKm2ckMzMRdk7bASAm+Eues
         RAN2IljR//Emad3bmD6suX/b0xnCdzhRS9quJSJdByNALFOBypTAd+axnneC01zyp9
         mqLwazNT6zD+m68frSOR6bzEC7f4JK/4T7YbjsBWyMJxnlp4Wj6f3OSAsIN4kJmS52
         zfQ8yCd2HXmxsc+/l1K3ni3SUZUbMnG/6B0ZUMCAF96ZfwPxqmqsZGPZ7TYIDtJlD2
         EAHAvLIXAshfA==
Date:   Tue, 14 Mar 2023 10:44:25 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Oleg Nesterov <oleg@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Rolf Eike Beer <eb@emlix.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH -next v14 11/19] riscv: Add ptrace vector support
Message-ID: <61c440cd-bae9-4984-9d26-d78e9fad2f16@spud>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
 <20230224170118.16766-12-andy.chiu@sifive.com>
 <87mt4v4clq.fsf@all.your.base.are.belong.to.us>
 <CABgGipU9LjvT6RQ6OfTXm6==pV0KXUjvyTR-FCNC05sfDec+9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wsNNZ3f2h61Byr8b"
Content-Disposition: inline
In-Reply-To: <CABgGipU9LjvT6RQ6OfTXm6==pV0KXUjvyTR-FCNC05sfDec+9g@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--wsNNZ3f2h61Byr8b
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 14, 2023 at 06:39:19PM +0800, Andy Chiu wrote:
> On Thu, Mar 2, 2023 at 7:27=E2=80=AFPM Bj=C3=B6rn T=C3=B6pel <bjorn@kerne=
l.org> wrote:
> >
> > Andy Chiu <andy.chiu@sifive.com> writes:
> >
> > > diff --git a/arch/riscv/kernel/ptrace.c b/arch/riscv/kernel/ptrace.c
> > > index 2ae8280ae475..3c0e01d7f8fb 100644
> > > --- a/arch/riscv/kernel/ptrace.c
> > > +++ b/arch/riscv/kernel/ptrace.c
> > > @@ -83,6 +87,62 @@ static int riscv_fpr_set(struct task_struct *targe=
t,
> > >  }
> > >  #endif
> > >
> > > +#ifdef CONFIG_RISCV_ISA_V
> > > +static int riscv_vr_get(struct task_struct *target,
> > > +                     const struct user_regset *regset,
> > > +                     struct membuf to)
> > > +{
> > > +     struct __riscv_v_ext_state *vstate =3D &target->thread.vstate;
> > > +
> > > +     if (!riscv_v_vstate_query(task_pt_regs(target)))
> > > +             return -EINVAL;
> > > +     /*
> > > +      * Ensure the vector registers have been saved to the memory be=
fore
> > > +      * copying them to membuf.
> > > +      */
> > > +     if (target =3D=3D current)
> > > +             riscv_v_vstate_save(current, task_pt_regs(current));
> > > +
> > > +     /* Copy vector header from vstate. */
> > > +     membuf_write(&to, vstate, offsetof(struct __riscv_v_ext_state, =
datap));
> > > +     membuf_zero(&to, sizeof(void *));
> > > +#if __riscv_xlen =3D=3D 32
> > > +     membuf_zero(&to, sizeof(__u32));
> > > +#endif
> >
> > Remind me why the extra care is needed for 32b?
> >
>=20
> That is from the old version of the code and I agree we should remove
> that.

> Hey Conor, does your Rb still hold after removing this #if,
> #endif section?

Sure.

--wsNNZ3f2h61Byr8b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZBBQBQAKCRB4tDGHoIJi
0q0/AP4qrjOdg4BZ8czZIXwP9AB8olebSGPPagBSO9A50HhpCgD+MmTpUZCrAhFP
UT8+bE+VYtwzLS7zCuUEHQUHd8lqwAY=
=JWax
-----END PGP SIGNATURE-----

--wsNNZ3f2h61Byr8b--
