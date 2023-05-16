Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D77077045F5
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 09:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbjEPHNo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 03:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbjEPHNf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 03:13:35 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3650F46BB
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 00:13:20 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-4f24cfb8539so12372669e87.3
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 00:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1684221198; x=1686813198;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q1ltoygmt4h8PKqzsElxWFoV93Ld5KS1X9hW+I7uw4M=;
        b=Hpb5+xL18lOc7d+ldqR0Po6N7TcZvKtvITvmqIPtYR7nTJNVEvLSuQQxL7GIlj+cXp
         XHzGkPL+93wkF0N3laTMKX41kWCaCSBmrUcwDd1hBndkw0WEPcFd2DARlTUETwDeiDgX
         PYfDDgE8mUEd3R/oaNkp4H21OwRl5PCHRX6E2s9SUIIeyAmYUELzexLQhqEoJtJutq18
         VSoK2LWiq3W1rUaYGEs49SQpX7a9h+52Nolwlqvu5fzWSIlNbQzlXZOM/xKERcWbyG2g
         kruykRLM2Bfj6NuCazs9nzswL/jfxYUHMRW5e1jfSAv8w6ubgW0e1CrKOjMUP5vz+pkA
         HmXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684221198; x=1686813198;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q1ltoygmt4h8PKqzsElxWFoV93Ld5KS1X9hW+I7uw4M=;
        b=fc8DFXVoDgbteg+hKCSZq4DC1Dp7gehrWA1JGnrIznUz8EtSdx5PvAQs3IhgUhrtdz
         Ytp1vCH7zQ5TpZ2PJdgmouxIwA10FuqbvWkbZVVyMgr79yOt0IB61AvJTmkMw9eZ7CUW
         APXtWnpKj5ZuhqVCrm4f2jmfOp6guBIQZHVh0eAkuGlKg4wHUpaItA7KxLj9Adt/jsZn
         L7bxQe2agg/3oFLCagUEV+W1A00cmAs/CvPFFDZtK5mqL1J/tbQI3qE7FmXB7/wBnAqR
         jLylOqkbFat8k7Bt0maX4X4Wy/2lPCkbieWFxSaovQmwCk05ZGEgEdINmRqGGOnA0iOm
         olBg==
X-Gm-Message-State: AC+VfDyOCE3UAm701g9LmKikAdK23CRvJYOrHMdNBUlwN8DQ/NQWnJYK
        3/OGlSuHNg9jJwps/DCEHn94dstWsaJTfcsi7FfsmV2AB68rGthtLHA=
X-Google-Smtp-Source: ACHHUZ6aMCwjQC6ws5qn/ylLBDN8BiDarT5DnOzn+uotya5OHFqLcjh/BN3GDOkAJ8WU81Epp1OHeTk+KVTUJLrug4I=
X-Received: by 2002:ac2:446c:0:b0:4f0:20bb:f48a with SMTP id
 y12-20020ac2446c000000b004f020bbf48amr6550635lfl.59.1684221198219; Tue, 16
 May 2023 00:13:18 -0700 (PDT)
MIME-Version: 1.0
References: <20230509103033.11285-1-andy.chiu@sifive.com> <20230509103033.11285-21-andy.chiu@sifive.com>
 <87ttwdhljn.fsf@all.your.base.are.belong.to.us>
In-Reply-To: <87ttwdhljn.fsf@all.your.base.are.belong.to.us>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Tue, 16 May 2023 15:13:07 +0800
Message-ID: <CABgGipW7PJLjxtx++-FJaOop6HqBg8o7XDKycg5hysD+eZd4rA@mail.gmail.com>
Subject: Re: [PATCH -next v19 20/24] riscv: Add prctl controls for userspace
 vector management
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        guoren@linux.alibaba.com, David Hildenbrand <david@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Joey Gouly <joey.gouly@arm.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Guo Ren <guoren@kernel.org>,
        Jisheng Zhang <jszhang@kernel.org>, greentime.hu@sifive.com,
        Albert Ou <aou@eecs.berkeley.edu>,
        Stefan Roesch <shr@devkernel.io>, vineetg@rivosinc.com,
        Josh Triplett <josh@joshtriplett.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Jordy Zomer <jordyzomer@google.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>
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

On Mon, May 15, 2023 at 7:38=E2=80=AFPM Bj=C3=B6rn T=C3=B6pel <bjorn@kernel=
.org> wrote:
>
> Andy Chiu <andy.chiu@sifive.com> writes:
>
> > This patch add two riscv-specific prctls, to allow usespace control the
> > use of vector unit:
>
> A more general question; I know that it's only x86 that implements
> arch_prctl(), and that arm64 added the SVE prctl kernel/sys.c -- but is
> there a reason not to have an arch-specific prctl for riscv?

I didn't notice that there is an arch-specific prctl for x86 when
implementing this. Maintaining a separate prctl out of the generic one
to do arch-specific configurations makes code elegant. But the role of
generic prctl has becoming more "arch-specific" due to porting of
architectures. For example, the generic prctl are used by arm64 for
SVE/SME configs, which apparently are arch-specific. And adding a
syscal for a similar interface might confuse users if the line between
the two is not clear.

I think the question would be more like "Is it worth adding a
arch_prctl when the generic prctl has already been used by other
architectures for arch-specific configurations?".

>
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
> > ---
> >  arch/riscv/include/asm/processor.h |  13 ++++
> >  arch/riscv/include/asm/vector.h    |   4 ++
> >  arch/riscv/kernel/process.c        |   1 +
> >  arch/riscv/kernel/vector.c         | 108 +++++++++++++++++++++++++++++
> >  arch/riscv/kvm/vcpu.c              |   2 +
> >  include/uapi/linux/prctl.h         |  11 +++
> >  kernel/sys.c                       |  12 ++++
> >  7 files changed, 151 insertions(+)
> >
> > diff --git a/arch/riscv/include/asm/processor.h b/arch/riscv/include/as=
m/processor.h
> > index 38ded8c5f207..79261da74cfd 100644
> > --- a/arch/riscv/include/asm/processor.h
> > +++ b/arch/riscv/include/asm/processor.h
> > @@ -40,6 +40,7 @@ struct thread_struct {
> >       unsigned long s[12];    /* s[0]: frame pointer */
> >       struct __riscv_d_ext_state fstate;
> >       unsigned long bad_cause;
> > +     unsigned long vstate_ctrl;
> >       struct __riscv_v_ext_state vstate;
> >  };
> >
> > @@ -83,6 +84,18 @@ extern void riscv_fill_hwcap(void);
> >  extern int arch_dup_task_struct(struct task_struct *dst, struct task_s=
truct *src);
> >
> >  extern unsigned long signal_minsigstksz __ro_after_init;
> > +
> > +#ifdef CONFIG_RISCV_ISA_V
> > +/* Userspace interface for PR_RISCV_V_{SET,GET}_VS prctl()s: */
> > +#define RISCV_V_SET_CONTROL(arg)     riscv_v_vstate_ctrl_set_current(a=
rg)
> > +#define RISCV_V_GET_CONTROL()                riscv_v_vstate_ctrl_get_c=
urrent()
> > +extern unsigned int riscv_v_vstate_ctrl_set_current(unsigned long arg)=
;
> > +extern unsigned int riscv_v_vstate_ctrl_get_current(void);
> > +#else /* !CONFIG_RISCV_ISA_V */
> > +#define RISCV_V_SET_CONTROL(arg)     (-EINVAL)
> > +#define RISCV_V_GET_CONTROL()                (-EINVAL)
>
> The else-clause is not needed (see my comment below for kernel/sys.c),
> and can be removed.
>
> > +#endif /* CONFIG_RISCV_ISA_V */
> > +
> >  #endif /* __ASSEMBLY__ */
> >
> >  #endif /* _ASM_RISCV_PROCESSOR_H */
>
> > diff --git a/kernel/sys.c b/kernel/sys.c
> > index 339fee3eff6a..412d2c126060 100644
> > --- a/kernel/sys.c
> > +++ b/kernel/sys.c
> > @@ -140,6 +140,12 @@
> >  #ifndef GET_TAGGED_ADDR_CTRL
> >  # define GET_TAGGED_ADDR_CTRL()              (-EINVAL)
> >  #endif
> > +#ifndef PR_RISCV_V_SET_CONTROL
> > +# define PR_RISCV_V_SET_CONTROL(a)   (-EINVAL)
> > +#endif
> > +#ifndef PR_RISCV_V_GET_CONTROL
> > +# define PR_RISCV_V_GET_CONTROL()    (-EINVAL)
>
> Both SET/GET above should be RISCV_V_{SET,GET}_CONTROL (without the
> prefix "PR_"), and nothing else, otherwise...
>
> > +#endif
> >
> >  /*
> >   * this is where the system-wide overflow UID and GID are defined, for
> > @@ -2708,6 +2714,12 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned lon=
g, arg2, unsigned long, arg3,
> >               error =3D !!test_bit(MMF_VM_MERGE_ANY, &me->mm->flags);
> >               break;
> >  #endif
> > +     case PR_RISCV_V_SET_CONTROL:
> > +             error =3D RISCV_V_SET_CONTROL(arg2);
> > +             break;
> > +     case PR_RISCV_V_GET_CONTROL:
> > +             error =3D RISCV_V_GET_CONTROL();
> > +             break;
>
>
> ...the case here will be weird. ;-)

Yes... fixing that now

>
>
> Bj=C3=B6rn

Thanks,
Andy
