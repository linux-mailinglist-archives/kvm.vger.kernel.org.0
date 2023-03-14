Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8BF6B904C
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 11:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjCNKkq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 06:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjCNKko (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 06:40:44 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB007D553
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 03:40:15 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id c200so4880946ybf.3
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 03:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1678790370;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yu39TNvqQnNoXX8hkbpumBIW7PEMEsaP5j9Jtp3j5c0=;
        b=nuqquZarQi0XRF1lNsfXXLT58CukRtTcSq8ehFTIGXzIhJMTAHbnbsr9tllyRl4+Df
         Re4vmDhBBWV9NTT857MyzA6DDWCiw2GsMysyCCKK9EICSPeiytnbvjrwiNSNkFhkiDDP
         B+Jxsp/NHOljh5aPohPpmzc5NjCxSKYOvxvnRQebuD1dgMEen/wO33PppARw8iR6u03c
         EECfl4/Tuta73OZv4lswN+Rxw3ZqEAxLRK5kev0OlyPjCeKN0bdVI1Tclv48eHK74cI0
         O+UuHMfJWu21FoZh4tgRrCPFvwU6TBDAyTAcD3lMARDnqgtWJ86pMW5TBEFHLQQIWK9f
         jxhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678790370;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yu39TNvqQnNoXX8hkbpumBIW7PEMEsaP5j9Jtp3j5c0=;
        b=lhVR++N4+jzyB7273Xh7Rew6Qv0NNfHtyNZ63K/LW8eqF9vHJYZnf/GH8QPFgn8rWe
         cqowwKbKZwekODyJomTMKHR4EjkuV8Aa9YwPkPuzfsa1kjJ2dKVask9NoFd31KMYY2nm
         faARuOLACDvotqfmERzlA+Z5QkB0UNX2zqYQ0NZ06P1hdvIeM9iGCgr1yjzyhFj7tqAO
         qH+PhdlhzFFU1swx5/Tp4gavzPgHa9OPi5ifWFH+omdzuNfLCcGU5C/wmLbaBTMoPNiG
         /CsYj3m6buEwFl43LrxpLO4PStFVDs/w6O9J6E7sFKGGVeZt06x4Ew1lfkAOt3n8+USe
         ZiHQ==
X-Gm-Message-State: AO0yUKUTG0o+e5NTs+Cyl9baD0g6iL59wM6KaVuOsS8LW02ijtQaEW44
        18r6BEZ1rPLX7ejQzDTe6o4V825049uvRqLrJgzEhw==
X-Google-Smtp-Source: AK7set9SXhCZjwP6lNAaNDriGW7JDr3Y4d0EMaZDNDiulZE6m2OvwDsZLCTfqrARJtbI5djaUSqY3HVtI954rV8THog=
X-Received: by 2002:a5b:6c4:0:b0:b26:d140:5f74 with SMTP id
 r4-20020a5b06c4000000b00b26d1405f74mr9038758ybq.1.1678790370297; Tue, 14 Mar
 2023 03:39:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230224170118.16766-1-andy.chiu@sifive.com> <20230224170118.16766-12-andy.chiu@sifive.com>
 <87mt4v4clq.fsf@all.your.base.are.belong.to.us>
In-Reply-To: <87mt4v4clq.fsf@all.your.base.are.belong.to.us>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Tue, 14 Mar 2023 18:39:19 +0800
Message-ID: <CABgGipU9LjvT6RQ6OfTXm6==pV0KXUjvyTR-FCNC05sfDec+9g@mail.gmail.com>
Subject: Re: [PATCH -next v14 11/19] riscv: Add ptrace vector support
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 2, 2023 at 7:27=E2=80=AFPM Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.=
org> wrote:
>
> Andy Chiu <andy.chiu@sifive.com> writes:
>
> > diff --git a/arch/riscv/kernel/ptrace.c b/arch/riscv/kernel/ptrace.c
> > index 2ae8280ae475..3c0e01d7f8fb 100644
> > --- a/arch/riscv/kernel/ptrace.c
> > +++ b/arch/riscv/kernel/ptrace.c
> > @@ -83,6 +87,62 @@ static int riscv_fpr_set(struct task_struct *target,
> >  }
> >  #endif
> >
> > +#ifdef CONFIG_RISCV_ISA_V
> > +static int riscv_vr_get(struct task_struct *target,
> > +                     const struct user_regset *regset,
> > +                     struct membuf to)
> > +{
> > +     struct __riscv_v_ext_state *vstate =3D &target->thread.vstate;
> > +
> > +     if (!riscv_v_vstate_query(task_pt_regs(target)))
> > +             return -EINVAL;
> > +     /*
> > +      * Ensure the vector registers have been saved to the memory befo=
re
> > +      * copying them to membuf.
> > +      */
> > +     if (target =3D=3D current)
> > +             riscv_v_vstate_save(current, task_pt_regs(current));
> > +
> > +     /* Copy vector header from vstate. */
> > +     membuf_write(&to, vstate, offsetof(struct __riscv_v_ext_state, da=
tap));
> > +     membuf_zero(&to, sizeof(void *));
> > +#if __riscv_xlen =3D=3D 32
> > +     membuf_zero(&to, sizeof(__u32));
> > +#endif
>
> Remind me why the extra care is needed for 32b?
>

That is from the old version of the code and I agree we should remove
that. Hey Conor, does your Rb still hold after removing this #if,
#endif section?

>
> Bj=C3=B6rn

Andy
