Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6580D6F8FB6
	for <lists+kvm@lfdr.de>; Sat,  6 May 2023 09:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbjEFHNL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 May 2023 03:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbjEFHNJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 May 2023 03:13:09 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A444C1E
        for <kvm@vger.kernel.org>; Sat,  6 May 2023 00:13:08 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-51f597c975fso2448421a12.0
        for <kvm@vger.kernel.org>; Sat, 06 May 2023 00:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683357188; x=1685949188;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mu3qZ0AvedwLeTUsw/OD/GuswR849znk2PpNGzIPK5I=;
        b=rJje/fCy7njvxtPWu2F6BvNsr6p/kuZHDGXE/Nv1kXHqUf/qm78bokFm4CizeJTxaa
         OBQG9pXA213OzGbsyZL79eX1RRIx7L3ubUAK4nYNj8jpVoj6SbsHFods+cJUkETKkIC8
         37pWDws55tRKGT9UWxPtccLhlOEEf5DgKlt9I6IWpulnNztL9CbuD28OzJ0I9dGQ7v51
         cDGk3WAh6vxLk0URZJzyBX2efpfuAWSZqGG0KcGws5jVJl0Hlt370ylQXEP8jCd9NkTv
         rd1uPaWYpFA3XeHo0mEdjsLZwPiEoAq5O0LfXV3JjWFd8SEneqXZF63+AZMbEGCpgzDr
         ycjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683357188; x=1685949188;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mu3qZ0AvedwLeTUsw/OD/GuswR849znk2PpNGzIPK5I=;
        b=HKnRemf2HwFUmW5kTdpRcq5UmURNbhXu6B267Bm84aHtpwQC7aG/zUxOHY9JNJERK8
         LmkANaITHjogyZCKIvhlv/Yv5qlc9gYmXTQSkV3E3pfDy8bRENgr1BcRolvkxKms2cRx
         F6NdLfbX94IDdzoJ/PAnMarlhLklvF3HC9F0Nz/Yllzc1seZp6hmezkd/czvITw6XKuY
         n7L3sWJ92oc+bXSZTGccdgI7Wq4IWuAYCoqLWOWZ8XAZId/KaaeR5lOWPughXYEv7QIN
         ipp9vhylQ5SVAFHJjWBdTOhNAoCfESruaDtytJtz1X37vlP6U18HDmnHILrCIOgBLfPf
         78kw==
X-Gm-Message-State: AC+VfDwJT6uR3f159tkXkCjB5OA/YfG70cDNTr2P+00P8erxJ6/0MKen
        hOmkVtHmYjbXHHYsx2ScKk1VvE9EWOT8JaBqp5k=
X-Google-Smtp-Source: ACHHUZ6AAmpvGf+t2ALHLZYH08juVwhY9wxkolKLCeI6ZBoVG75KETkBoWrDt+ZOIrUkzIW3cmkRV0vnpdCdjciOnto=
X-Received: by 2002:a17:902:7295:b0:1a2:6257:36b9 with SMTP id
 d21-20020a170902729500b001a2625736b9mr3627220pll.31.1683357187782; Sat, 06
 May 2023 00:13:07 -0700 (PDT)
MIME-Version: 1.0
References: <1679555884-32544-1-git-send-email-lirongqing@baidu.com>
 <b8facaa4-7dc3-7f2c-e25b-16503c4bfae7@gmail.com> <CANZk6aTqiOtJiriSUtZ3myod5hcbV8fb7NA8O2YmUo5PrFyTYw@mail.gmail.com>
 <ZFVAd+SRpnEkw5tx@google.com>
In-Reply-To: <ZFVAd+SRpnEkw5tx@google.com>
From:   zhuangel570 <zhuangel570@gmail.com>
Date:   Sat, 6 May 2023 15:12:55 +0800
Message-ID: <CANZk6aTQoYn5g2ELucjg16yTjo13xUeprOMfgJtZVY+psxHTCQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Don't create kvm-nx-lpage-re kthread if not itlb_multihit
To:     Sean Christopherson <seanjc@google.com>
Cc:     Robert Hoo <robert.hoo.linux@gmail.com>, lirongqing@baidu.com,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, kvm@vger.kernel.org,
        x86@kernel.org
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

The "never" parameter works for environments without ITLB MULTIHIT issue. B=
ut
for vulnerable environments, should we prohibit users from turning off
software mitigations?

As for the nx_huge_page_recovery_thread worker thread, this is a solution t=
o
optimize software mitigation, maybe not needed in all cases.
For example, on a vulnerable machine, software mitigations need to be enabl=
ed,
but worker threads may not be needed when the VM determines that huge pages
are not in use (not sure).

Do you think it is possible to introduce a new parameter to disable worker
threads?

On Sat, May 6, 2023 at 1:44=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Fri, May 05, 2023, zhuangel570 wrote:
> > FYI, this is our test scenario, simulating the FaaS business, every VM =
assign
> > 0.1 core, starting lots VMs run in backgroud (such as 800 VM on a machi=
ne
> > with 80 cores), then burst create 10 VMs, then got 100ms+ latency in cr=
eating
> > "kvm-nx-lpage-recovery".
> >
> > On Tue, May 2, 2023 at 10:20=E2=80=AFAM Robert Hoo <robert.hoo.linux@gm=
ail.com> wrote:
> > >
> > > On 3/23/2023 3:18 PM, lirongqing@baidu.com wrote:
> > > > From: Li RongQing <lirongqing@baidu.com>
> > > >
> > > > if CPU has not X86_BUG_ITLB_MULTIHIT bug, kvm-nx-lpage-re kthread
> > > > is not needed to create
> > >
> > > (directed by Sean from
> > > https://lore.kernel.org/kvm/ZE%2FR1%2FhvbuWmD8mw@google.com/ here.)
> > >
> > > No, I think it should tie to "nx_huge_pages" value rather than
> > > directly/partially tie to boot_cpu_has_bug(X86_BUG_ITLB_MULTIHIT).
>
> Lightly tested.  This is what I'm thinking for a "never" param.  Unless s=
omeone
> has an alternative idea, I'll post a formal patch after more testing.
>
> ---
>  arch/x86/kvm/mmu/mmu.c | 41 ++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 36 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c8961f45e3b1..14713c050196 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -58,6 +58,8 @@
>
>  extern bool itlb_multihit_kvm_mitigation;
>
> +static bool nx_hugepage_mitigation_hard_disabled;
> +
>  int __read_mostly nx_huge_pages =3D -1;
>  static uint __read_mostly nx_huge_pages_recovery_period_ms;
>  #ifdef CONFIG_PREEMPT_RT
> @@ -67,12 +69,13 @@ static uint __read_mostly nx_huge_pages_recovery_rati=
o =3D 0;
>  static uint __read_mostly nx_huge_pages_recovery_ratio =3D 60;
>  #endif
>
> +static int get_nx_huge_pages(char *buffer, const struct kernel_param *kp=
);
>  static int set_nx_huge_pages(const char *val, const struct kernel_param =
*kp);
>  static int set_nx_huge_pages_recovery_param(const char *val, const struc=
t kernel_param *kp);
>
>  static const struct kernel_param_ops nx_huge_pages_ops =3D {
>         .set =3D set_nx_huge_pages,
> -       .get =3D param_get_bool,
> +       .get =3D get_nx_huge_pages,
>  };
>
>  static const struct kernel_param_ops nx_huge_pages_recovery_param_ops =
=3D {
> @@ -6844,6 +6847,14 @@ static void mmu_destroy_caches(void)
>         kmem_cache_destroy(mmu_page_header_cache);
>  }
>
> +static int get_nx_huge_pages(char *buffer, const struct kernel_param *kp=
)
> +{
> +       if (nx_hugepage_mitigation_hard_disabled)
> +               return sprintf(buffer, "never\n");
> +
> +       return param_get_bool(buffer, kp);
> +}
> +
>  static bool get_nx_auto_mode(void)
>  {
>         /* Return true when CPU has the bug, and mitigations are ON */
> @@ -6860,15 +6871,29 @@ static int set_nx_huge_pages(const char *val, con=
st struct kernel_param *kp)
>         bool old_val =3D nx_huge_pages;
>         bool new_val;
>
> +       if (nx_hugepage_mitigation_hard_disabled)
> +               return -EPERM;
> +
>         /* In "auto" mode deploy workaround only if CPU has the bug. */
> -       if (sysfs_streq(val, "off"))
> +       if (sysfs_streq(val, "off")) {
>                 new_val =3D 0;
> -       else if (sysfs_streq(val, "force"))
> +       } else if (sysfs_streq(val, "force")) {
>                 new_val =3D 1;
> -       else if (sysfs_streq(val, "auto"))
> +       } else if (sysfs_streq(val, "auto")) {
>                 new_val =3D get_nx_auto_mode();
> -       else if (kstrtobool(val, &new_val) < 0)
> +       } if (sysfs_streq(val, "never")) {
> +               new_val =3D 0;
> +
> +               mutex_lock(&kvm_lock);
> +               if (!list_empty(&vm_list)) {
> +                       mutex_unlock(&kvm_lock);
> +                       return -EBUSY;
> +               }
> +               nx_hugepage_mitigation_hard_disabled =3D true;
> +               mutex_unlock(&kvm_lock);
> +       } else if (kstrtobool(val, &new_val) < 0) {
>                 return -EINVAL;
> +       }
>
>         __set_nx_huge_pages(new_val);
>
> @@ -7006,6 +7031,9 @@ static int set_nx_huge_pages_recovery_param(const c=
har *val, const struct kernel
>         uint old_period, new_period;
>         int err;
>
> +       if (nx_hugepage_mitigation_hard_disabled)
> +               return -EPERM;
> +
>         was_recovery_enabled =3D calc_nx_huge_pages_recovery_period(&old_=
period);
>
>         err =3D param_set_uint(val, kp);
> @@ -7161,6 +7189,9 @@ int kvm_mmu_post_init_vm(struct kvm *kvm)
>  {
>         int err;
>
> +       if (nx_hugepage_mitigation_hard_disabled)
> +               return 0;
> +
>         err =3D kvm_vm_create_worker_thread(kvm, kvm_nx_huge_page_recover=
y_worker, 0,
>                                           "kvm-nx-lpage-recovery",
>                                           &kvm->arch.nx_huge_page_recover=
y_thread);
>
> base-commit: b3c98052d46948a8d65d2778c7f306ff38366aac
> --
>


--=20
=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=
=80=94=E2=80=94
   zhuangel570
=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=
=80=94=E2=80=94
