Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC736FCAD6
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 18:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235781AbjEIQMB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 12:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235645AbjEIQMA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 12:12:00 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0B62127
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 09:11:58 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-4f13a72ff53so6764567e87.0
        for <kvm@vger.kernel.org>; Tue, 09 May 2023 09:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1683648717; x=1686240717;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OzJaCG/OMHNYElGBgmenbpg63aufpuFPkDUabCgItGk=;
        b=NULj4O+JGNCyV+KeDufbKevReeAkOh7DxA0aRU6bN8QhLySM+6jIo5iqkqaG6aBi28
         ifeMXOg4uMKXZNnl/rABuo8Ka9OtvX8VUtoZ5e8rV6FPmd2iGqcMmgJPnIpjY1CEikA5
         MPoqPJVPvrcmmWPewXY4Agq0vrKIl1/un6jQ1ZEhgrIVKeDD/4MWnfp+Rz39uGh2I4Hi
         HyrnETJGvsMkBvNnaSTjZcNjrv0cn1PkOH7q+GGkwTHJSuyfHBJUV30zwaP7ItAzYuK2
         DD81XoptwZ/zPGbl0K/4UzMelFipgCBVonGCpF33HGPBd+l/zRrNi30Kwyk9Lc4L1rpR
         NJ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683648717; x=1686240717;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OzJaCG/OMHNYElGBgmenbpg63aufpuFPkDUabCgItGk=;
        b=ZOWa0ud2OvW55kMLa8/nrTxl13UrvMWCVXNOlJgPvLkIDnupdtmG2uZ62v9gDAA2AT
         aTf2cwF4FR4AZN1A0ffnKH5FkeAUtsLzsqnpRQAUFLVt+C5uw4pExufeUk2wl0uPVSgY
         RhIMSWkbDh8ipVZLFTSgJaHmtV8bHuG5snCojiKUZz2TJX7gCi87Q9DQ0ijaBUQCSHqm
         YgK/iNfLUQkLflFMgnhYXZDx/NrMiKDtczMH0y+SNpqMHbn1AHAWtl+F/eY/zRBFSB/h
         1kGDCB360atZ8wJJsjThTKwJ9z2eP+daGd2SL2YtzzN0F+BgC1mP8Xh4uyF3a6lh0Tay
         zDcA==
X-Gm-Message-State: AC+VfDw97gxwWRf7AWMHukBT5Icrl0hfq0cOzsPN2PtcgVZp6mqPOlNe
        3X7m/upE7R441JRY1EaYoo/i61CwzUnzpLicql1QYA==
X-Google-Smtp-Source: ACHHUZ7k+XfWXUIUB2Ybwk1N7tPL7s5PtmEBH8IA+vRwsIaa2j8CzaAvd0SnMu2S+nE+4iNIdWuT/6miQKkzsm1wjs8=
X-Received: by 2002:ac2:5599:0:b0:4eb:d8d:6c13 with SMTP id
 v25-20020ac25599000000b004eb0d8d6c13mr872822lfg.9.1683648716955; Tue, 09 May
 2023 09:11:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230509103033.11285-1-andy.chiu@sifive.com> <20230509103033.11285-21-andy.chiu@sifive.com>
 <2629220.BddDVKsqQX@diego>
In-Reply-To: <2629220.BddDVKsqQX@diego>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Wed, 10 May 2023 00:11:45 +0800
Message-ID: <CABgGipXN2vsdEMJFX-e8EgVNvnDr7v6zixyWErfaq31ghWkGRw@mail.gmail.com>
Subject: Re: [PATCH -next v19 20/24] riscv: Add prctl controls for userspace
 vector management
To:     =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Vincent Chen <vincent.chen@sifive.com>,
        Guo Ren <guoren@kernel.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Stefan Roesch <shr@devkernel.io>,
        Joey Gouly <joey.gouly@arm.com>,
        Jordy Zomer <jordyzomer@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 9, 2023 at 7:14=E2=80=AFPM Heiko St=C3=BCbner <heiko@sntech.de>=
 wrote:
>
> Hi,
>
> need to poke this more, but one issue popped up at first compile.
>
> Am Dienstag, 9. Mai 2023, 12:30:29 CEST schrieb Andy Chiu:
> > This patch add two riscv-specific prctls, to allow usespace control the
> > use of vector unit:
> >
> >  * PR_RISCV_V_SET_CONTROL: control the permission to use Vector at next=
,
> >    or all following execve for a thread. Turning off a thread's Vector
> >    live is not possible since libraries may have registered ifunc that
> >    may execute Vector instructions.
> >  * PR_RISCV_V_GET_CONTROL: get the same permission setting for the
> >    current thread, and the setting for following execve(s).
> >
> > Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> > Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
> > Reviewed-by: Vincent Chen <vincent.chen@sifive.com>
>
>
> > diff --git a/arch/riscv/kernel/vector.c b/arch/riscv/kernel/vector.c
> > index 960a343799c6..16ccb35625a9 100644
> > --- a/arch/riscv/kernel/vector.c
> > +++ b/arch/riscv/kernel/vector.c
> > @@ -9,6 +9,7 @@
> >  #include <linux/slab.h>
> >  #include <linux/sched.h>
> >  #include <linux/uaccess.h>
> > +#include <linux/prctl.h>
> >
> >  #include <asm/thread_info.h>
> >  #include <asm/processor.h>
> > @@ -19,6 +20,8 @@
> >  #include <asm/ptrace.h>
> >  #include <asm/bug.h>
> >
> > +static bool riscv_v_implicit_uacc =3D !IS_ENABLED(CONFIG_RISCV_V_DISAB=
LE);
> > +
> >  unsigned long riscv_v_vsize __read_mostly;
> >  EXPORT_SYMBOL_GPL(riscv_v_vsize);
> >
> > @@ -91,11 +94,51 @@ static int riscv_v_thread_zalloc(void)
> >       return 0;
> >  }
> >
> > +#define VSTATE_CTRL_GET_CUR(x) ((x) & PR_RISCV_V_VSTATE_CTRL_CUR_MASK)
> > +#define VSTATE_CTRL_GET_NEXT(x) (((x) & PR_RISCV_V_VSTATE_CTRL_NEXT_MA=
SK) >> 2)
> > +#define VSTATE_CTRL_MAKE_NEXT(x) (((x) << 2) & PR_RISCV_V_VSTATE_CTRL_=
NEXT_MASK)
> > +#define VSTATE_CTRL_GET_INHERIT(x) (!!((x) & PR_RISCV_V_VSTATE_CTRL_IN=
HERIT))
> > +static inline int riscv_v_get_cur_ctrl(struct task_struct *tsk)
> > +{
> > +     return VSTATE_CTRL_GET_CUR(tsk->thread.vstate_ctrl);
> > +}
> > +
> > +static inline int riscv_v_get_next_ctrl(struct task_struct *tsk)
> > +{
> > +     return VSTATE_CTRL_GET_NEXT(tsk->thread.vstate_ctrl);
> > +}
> > +
> > +static inline bool riscv_v_test_ctrl_inherit(struct task_struct *tsk)
> > +{
> > +     return VSTATE_CTRL_GET_INHERIT(tsk->thread.vstate_ctrl);
> > +}
> > +
> > +static inline void riscv_v_set_ctrl(struct task_struct *tsk, int cur, =
int nxt,
> > +                                 bool inherit)
> > +{
> > +     unsigned long ctrl;
> > +
> > +     ctrl =3D cur & PR_RISCV_V_VSTATE_CTRL_CUR_MASK;
> > +     ctrl |=3D VSTATE_CTRL_MAKE_NEXT(nxt);
> > +     if (inherit)
> > +             ctrl |=3D PR_RISCV_V_VSTATE_CTRL_INHERIT;
> > +     tsk->thread.vstate_ctrl =3D ctrl;
> > +}
> > +
> > +bool riscv_v_user_allowed(void)
> > +{
> > +     return riscv_v_get_cur_ctrl(current) =3D=3D PR_RISCV_V_VSTATE_CTR=
L_ON;
> > +}
>
> EXPORT_SYMBOL(riscv_v_user_allowed);

It's a shame. KVM is a builtin on my test platform so I missed this
obvious thing. Or, maybe we should make them inline functions or
macros at the header file because of the size. And because other
modules may rarely use them.

>
> kvm is allowed to be built as module, so you could end up with:
>
> ERROR: modpost: "riscv_v_user_allowed" [arch/riscv/kvm/kvm.ko] undefined!
> make[2]: *** [../scripts/Makefile.modpost:136: Module.symvers] Fehler 1
> make[1]: *** [/home/devel/hstuebner/00_git-repos/linux-riscv/Makefile:197=
8: modpost] Fehler 2
> make[1]: Verzeichnis =E2=80=9E/home/devel/hstuebner/00_git-repos/linux-ri=
scv/_build-riscv64=E2=80=9C wird verlassen
> make: *** [Makefile:226: __sub-make] Fehler 2
>
>
> Heiko
>
>
>

Thanks,
Andy
