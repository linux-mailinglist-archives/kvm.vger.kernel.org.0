Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFBBC6F832B
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 14:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbjEEMnL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 08:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjEEMnJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 08:43:09 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1CA17FC3
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 05:43:08 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id 98e67ed59e1d1-24df6bbf765so1595886a91.0
        for <kvm@vger.kernel.org>; Fri, 05 May 2023 05:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683290588; x=1685882588;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GStTkfOoiU+0hr7MDdtqXSTUxV8ZSA6iP9d3CFL1FGo=;
        b=pmEWFc/ew8zSposLiGEZ90/j1VPeDhssFdSIbByKXdc2fkS+yE8qSC1JpQS07KI/Kg
         kPidQBtTG60ddFFwnguLI1Z2xULeRa5aBq1y32dTdBZ9vlyrzvFPZrwiNqMF35vcyjsy
         grj/yETluR+Q+F+h7Y97+pyKUVq7Kpn2Qh+1MUz56l2CuQep5hTPCTc8/n0pZ4bQldjP
         VSCB7T3jJbCSc1y1iPt1LACdqDBS1A+KTCftGAk/o4Qx0GIJzislM7imcQfVQQ9fq8kO
         GOkwbxutmtQkNNP9EsjBd6K76xY2SKnHnmA0h+J69cZwrSVbfv6H4hk8fAQxa5c3fxh/
         vVjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683290588; x=1685882588;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GStTkfOoiU+0hr7MDdtqXSTUxV8ZSA6iP9d3CFL1FGo=;
        b=dNNwDSECxwUJ+zmxdHMdWA4RrlwSW4SGzAmBm4swzFG2z7RhUpL0zBdOVTGSbyHIsv
         oFXVkVM4T5/aeFquOirBfrV3YaecQNYrScNXMgbS0HEZ0aRZj1iLXr9Ts5RLeStb2Dy6
         RKTyHXGDjPrBG4ZP/kEgsLpDnd00mH+dOTGJy83GxySLH100dExLaenpHYGG7fDn3mma
         lT0rJBpkrjjYTnKPQkbviltVWhI365BdQFTEcnu7twXut0eDljkn9mBddqZar60fVnWa
         ZcCuGmlD5gbiqPLIqHJPWVNVSQAzw588J00yvwjrYLHjcDVWtscd5Cmbtg2uJDGXz8BT
         0bfg==
X-Gm-Message-State: AC+VfDz0DwIlehX3ORYY6Vw1/aJvn8BzIJjIqG+PMmvcDjg7+ZM/VHKX
        9TBLTe4CtHtjtvGmi0R3SpnuqWju1fSe6yu7uCJOW3XwlpyLpJe/
X-Google-Smtp-Source: ACHHUZ5teUgO1Lm0yqQ6Lyi3wZWasNapmOMABzH8ycEs1GsFZg+rmNkygD4B+fDOt1tfFDZeXVynXrK9dwvlxuhNkBE=
X-Received: by 2002:a17:90b:713:b0:250:5f4:5652 with SMTP id
 s19-20020a17090b071300b0025005f45652mr1275135pjz.39.1683290588284; Fri, 05
 May 2023 05:43:08 -0700 (PDT)
MIME-Version: 1.0
References: <1679555884-32544-1-git-send-email-lirongqing@baidu.com> <b8facaa4-7dc3-7f2c-e25b-16503c4bfae7@gmail.com>
In-Reply-To: <b8facaa4-7dc3-7f2c-e25b-16503c4bfae7@gmail.com>
From:   zhuangel570 <zhuangel570@gmail.com>
Date:   Fri, 5 May 2023 20:42:56 +0800
Message-ID: <CANZk6aTqiOtJiriSUtZ3myod5hcbV8fb7NA8O2YmUo5PrFyTYw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Don't create kvm-nx-lpage-re kthread if not itlb_multihit
To:     Robert Hoo <robert.hoo.linux@gmail.com>
Cc:     lirongqing@baidu.com, seanjc@google.com, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, kvm@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

FYI, this is our test scenario, simulating the FaaS business, every VM assi=
gn
0.1 core, starting lots VMs run in backgroud (such as 800 VM on a machine
with 80 cores), then burst create 10 VMs, then got 100ms+ latency in creati=
ng
"kvm-nx-lpage-recovery".

On Tue, May 2, 2023 at 10:20=E2=80=AFAM Robert Hoo <robert.hoo.linux@gmail.=
com> wrote:
>
> On 3/23/2023 3:18 PM, lirongqing@baidu.com wrote:
> > From: Li RongQing <lirongqing@baidu.com>
> >
> > if CPU has not X86_BUG_ITLB_MULTIHIT bug, kvm-nx-lpage-re kthread
> > is not needed to create
>
> (directed by Sean from
> https://lore.kernel.org/kvm/ZE%2FR1%2FhvbuWmD8mw@google.com/ here.)
>
> No, I think it should tie to "nx_huge_pages" value rather than
> directly/partially tie to boot_cpu_has_bug(X86_BUG_ITLB_MULTIHIT).
> >
> > Signed-off-by: Li RongQing <lirongqing@baidu.com>
> > ---
> >   arch/x86/kvm/mmu/mmu.c | 19 +++++++++++++++++++
> >   1 file changed, 19 insertions(+)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 8354262..be98c69 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -6667,6 +6667,11 @@ static bool get_nx_auto_mode(void)
> >       return boot_cpu_has_bug(X86_BUG_ITLB_MULTIHIT) && !cpu_mitigation=
s_off();
> >   }
> >
> > +static bool cpu_has_itlb_multihit(void)
> > +{
> > +     return boot_cpu_has_bug(X86_BUG_ITLB_MULTIHIT);
> > +}
> > +
> >   static void __set_nx_huge_pages(bool val)
> >   {
> >       nx_huge_pages =3D itlb_multihit_kvm_mitigation =3D val;
> > @@ -6677,6 +6682,11 @@ static int set_nx_huge_pages(const char *val, co=
nst struct kernel_param *kp)
> >       bool old_val =3D nx_huge_pages;
> >       bool new_val;
> >
> > +     if (!cpu_has_itlb_multihit()) {
> > +             __set_nx_huge_pages(false);
> > +             return 0;
> > +     }
> > +
> It's rude simply return here just because
> !boot_cpu_has_bug(X86_BUG_ITLB_MULTIHIT), leaving all else behind, i.e.
> leaving below sysfs node useless.
> If you meant to do this, you should clear these sysfs APIs because of
> !boot_cpu_has_bug(X86_BUG_ITLB_MULTIHIT).
>
> >       /* In "auto" mode deploy workaround only if CPU has the bug. */
> >       if (sysfs_streq(val, "off"))
> >               new_val =3D 0;
> > @@ -6816,6 +6826,9 @@ static int set_nx_huge_pages_recovery_param(const=
 char *val, const struct kernel
> >       uint old_period, new_period;
> >       int err;
> >
> > +     if (!cpu_has_itlb_multihit())
> > +             return 0;
> > +
> >       was_recovery_enabled =3D calc_nx_huge_pages_recovery_period(&old_=
period);
> >
> >       err =3D param_set_uint(val, kp);
> > @@ -6971,6 +6984,9 @@ int kvm_mmu_post_init_vm(struct kvm *kvm)
> >   {
> >       int err;
> >
> > +     if (!cpu_has_itlb_multihit())
> > +             return 0;
> > +
> It's rude to simply return. kvm_mmu_post_init_vm() by name is far more th=
an
> nx_hugepage stuff, though at present only this stuff in.
> I would rather
>
>         if (cpu_has_itlb_multihit()) {
>                 ...
>         }
>
> Consider people in the future when they do modifications on this function=
.
> >       err =3D kvm_vm_create_worker_thread(kvm, kvm_nx_huge_page_recover=
y_worker, 0,
> >                                         "kvm-nx-lpage-recovery",
> >                                         &kvm->arch.nx_huge_page_recover=
y_thread);
> > @@ -6982,6 +6998,9 @@ int kvm_mmu_post_init_vm(struct kvm *kvm)
> >
> >   void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
> >   {
> > +     if (!cpu_has_itlb_multihit())
> > +             return;
> > Ditto. It looks (wrongly) like: if !cpu_has_itlb_multihit(), no need to=
 do
> anything about pre_destroy_vm.
>
> >       if (kvm->arch.nx_huge_page_recovery_thread)
> >               kthread_stop(kvm->arch.nx_huge_page_recovery_thread);
> >   }
>
> To summary, regardless of the concrete patch/implementation, what Sean mo=
re
> urgently needs is real world justification to mitigate NX_hugepage; which=
 I
> believe you have at hand: why would you like to do this, what real world
> issue caused by this bothers you. You could have more descriptions.
>
> With regards to NX_hugepage, I see people dislike it [1][2][3], but on HW
> with itlb_multihit, they've no choice but to use it to mitigate.
>
> [1] this patch
> [2]
> https://lore.kernel.org/kvm/CANZk6aSv5ta3emitOfWKxaB-JvURBVu-sXqFnCz9PKXh=
qjbV9w@mail.gmail.com/
> [3]
> https://lore.kernel.org/kvm/20220613212523.3436117-1-bgardon@google.com/
> (merged)



--=20
=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=
=80=94=E2=80=94
   zhuangel570
=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=
=80=94=E2=80=94
