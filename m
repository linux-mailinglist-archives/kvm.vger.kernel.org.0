Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6AB6CB777
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 08:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjC1Gql (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 02:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjC1Gqj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 02:46:39 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06BED1
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 23:46:37 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id h9so11415731ljq.2
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 23:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679985996;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W1XHAQoLpqUkdzwTbDoHACx1szTrEA0iohgHCx3vq/8=;
        b=RPfmjUDq9fVJ0cg+5VyR6LMxEePEFgqG+46h4jYUj2MMJ6QuGhYgo7YNjS4fvjllti
         KrVwLdcjAfIMv4G65ncXtrQaY1PaVm3DhwsR8wSP3SvbOXkMtaHVn7OfwADd3rfHdqeZ
         gzz7xqzXsasrL7eAE7WwEDTmbERoWGptvOc5zrkC5ldAf+YYwvUQy+nurWpxEuC7SqpA
         uFtrvPGBzy5mgYkCySfAUDbDPdroQYr1TR+sCuK+k3Bl/yankxN3VPdRR4voY7FOMjjt
         X7wzHz3VqXWYctGxhNtvSkfds9V8Bew9qUPBA/9dIxGnVwNAvzmgaCqzuWk1ci+UaW98
         Ea+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679985996;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W1XHAQoLpqUkdzwTbDoHACx1szTrEA0iohgHCx3vq/8=;
        b=4FjxWWqb3Niaa2khdRHWbEynwk2M7E02QlXGeHkaZwLuALBKJaPBekXGMOSPtE1JoY
         Rfk531WZWoWyW8nkiwNOUTeH02CAZM+rGY359Y2He3q2cZrf4057rc405z1duZvUQ+TL
         eyXfrs5wtZyFz3+a6CLoYEixwQLyTJMA7V1Wz8Hudi4DLEE/haiuMcXwcwxyud0IhKm4
         KuOvnwyldB3u90Ku15ely7XcxO2aCJ/6Xkt3Wj1w/weTYAU37wNp8pXO1ErtFd7Hz8Sp
         8nr95fLtXSQtnaC+GpId98nUzmEF6XlVSmz8W2MIxOfMybTyI0LEygkljsxTZd1LOJ+G
         rXNQ==
X-Gm-Message-State: AAQBX9fl6IMh0hj9Vns66/wlSvyyAto4zh9O+XFTUQgMu+diWk90tenk
        Drs6J85NKXr7V0joas/gANuaBC5bNHToOx6Hltwr46TUEtg3sFW2EH4=
X-Google-Smtp-Source: AKy350aj03u+AwN2EEmKhkoKmZSoRKbdhO/Z9rJtA54de/v8g1VSN1m3aP5mrq3kBBOiXkwL0KInrskLFPzTY8ZAugU=
X-Received: by 2002:a2e:a175:0:b0:299:ac68:4801 with SMTP id
 u21-20020a2ea175000000b00299ac684801mr4347500ljl.0.1679985995953; Mon, 27 Mar
 2023 23:46:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230327164941.20491-1-andy.chiu@sifive.com> <20230327164941.20491-12-andy.chiu@sifive.com>
 <5660672.DvuYhMxLoT@devpool47.emlix.com>
In-Reply-To: <5660672.DvuYhMxLoT@devpool47.emlix.com>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Tue, 28 Mar 2023 14:46:24 +0800
Message-ID: <CABgGipWcK6kAARBMCT8JGxV-9_yav_p0HME9+28vcv195R6_ww@mail.gmail.com>
Subject: Re: [PATCH -next v17 11/20] riscv: Add ptrace vector support
To:     Rolf Eike Beer <eb@emlix.com>
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
        Conor Dooley <conor.dooley@microchip.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Qing Zhang <zhangqing@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 28, 2023 at 1:53=E2=80=AFPM Rolf Eike Beer <eb@emlix.com> wrote=
:
>
> On Montag, 27. M=C3=A4rz 2023 18:49:31 CEST Andy Chiu wrote:
> > From: Greentime Hu <greentime.hu@sifive.com>
> >
> > This patch adds ptrace support for riscv vector. The vector registers w=
ill
> > be saved in datap pointer of __riscv_v_ext_state. This pointer will be =
set
> > right after the __riscv_v_ext_state data structure then it will be put =
in
> > ubuf for ptrace system call to get or set. It will check if the datap g=
ot
> > from ubuf is set to the correct address or not when the ptrace system c=
all
> > is trying to set the vector registers.
> >
> > Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> > Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> > Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> > Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> > Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> > ---
> >  arch/riscv/include/uapi/asm/ptrace.h |  7 +++
> >  arch/riscv/kernel/ptrace.c           | 70 ++++++++++++++++++++++++++++
> >  include/uapi/linux/elf.h             |  1 +
> >  3 files changed, 78 insertions(+)
> >
> > diff --git a/arch/riscv/kernel/ptrace.c b/arch/riscv/kernel/ptrace.c
> > index 23c48b14a0e7..75e66c040b64 100644
> > --- a/arch/riscv/kernel/ptrace.c
> > +++ b/arch/riscv/kernel/ptrace.c
> > @@ -80,6 +84,61 @@ static int riscv_fpr_set(struct task_struct *target,
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
> > +
> > +     /*
> > +      * Ensure the vector registers have been saved to the memory befo=
re
> > +      * copying them to membuf.
> > +      */
> > +     if (target =3D=3D current)
> > +             riscv_v_vstate_save(current, task_pt_regs(current));
> > +
> > +     /* Copy vector header from vstate. */
> > +     membuf_write(&to, vstate, offsetof(struct __riscv_v_ext_state,
> datap));
> > +     membuf_zero(&to, sizeof(void *));
>
> No idea why I have not seen it in any previous version, but this "sizeof(=
void
> *)" just made me thing "what is going on here?". I personally would have
> written something like "sizeof(to.var)" or "offsetof(to.buf)" or somethin=
g like
> that. That makes it easier for me to understand what is skipped/zeroed he=
re,
> let alone making it a bit more fool proof when someone changes one of the
> struct layouts. YMMV.
>

Thanks for the finding. Fixing it now

> Regards,
>
> Eike
> --
> Rolf Eike Beer, emlix GmbH, http://www.emlix.com
> Fon +49 551 30664-0, Fax +49 551 30664-11
> Gothaer Platz 3, 37083 G=C3=B6ttingen, Germany
> Sitz der Gesellschaft: G=C3=B6ttingen, Amtsgericht G=C3=B6ttingen HR B 31=
60
> Gesch=C3=A4ftsf=C3=BChrung: Heike Jordan, Dr. Uwe Kracke =E2=80=93 Ust-Id=
Nr.: DE 205 198 055
>
> emlix - smart embedded open source

Cheers,
Andy
