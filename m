Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 771E57329DB
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 10:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244925AbjFPIbf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 04:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240382AbjFPIbd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 04:31:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3CE613E;
        Fri, 16 Jun 2023 01:31:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B48F61055;
        Fri, 16 Jun 2023 08:31:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317D5C433C9;
        Fri, 16 Jun 2023 08:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686904290;
        bh=rTOlfpmBCp0oMrcMWpEhK5SPHAeTuxu5wMswJ4b9E70=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qpLjshihZypKSGURcvnhtiQjt+wTqEidN+GrF6AIMbG3Ddu8gzlcs3C0+pZSb3kjs
         Vjl65RCvawMSpjqvsRUy+pNp1J489y+VmeGwGNyeZ9sb2FVryCO0LDGo5DRPoS1XZF
         4hFQf+wvnitxfpkeOBvAuqK7Q+zISh/4KkA922PMSZlXrILbrVE9ysI1lRrcdRkCCi
         Pqlg+/Gk1cLe/IkoncELEQzRKumJFhNmwegZTRd9v8Kcnlx3Fsc1Ej6CzjpAK2q3GW
         yc3jPAew7mIby3ZoRmf97KgSeuhAUExKxrCK/m8mIJ8eYllIGW6p8L1C05uybR12iB
         TmsNXuEoIPNrg==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-51878f8e541so492280a12.3;
        Fri, 16 Jun 2023 01:31:30 -0700 (PDT)
X-Gm-Message-State: AC+VfDydK16lolfUzTQpxHupcdCZuKDzjIT6WpYxvNv3xmvctpEwayey
        onjOWe2xjs30H4jFleI0nH2v3myTi3OMrTqFsNI=
X-Google-Smtp-Source: ACHHUZ7Q/ccIVBVq5F2jCaCd3wDfwJiFQhWmPdlbLzzgA08ypO1TckBlBcfjmVQjgDd7TjJOnZfYaVdBd9wZnpGZZCM=
X-Received: by 2002:aa7:d3c1:0:b0:518:9195:b535 with SMTP id
 o1-20020aa7d3c1000000b005189195b535mr650263edr.42.1686904288292; Fri, 16 Jun
 2023 01:31:28 -0700 (PDT)
MIME-Version: 1.0
References: <1596005919-29365-5-git-send-email-chenhc@lemote.com>
 <20230616071831.1452507-1-yuzhao@google.com> <20230616082322.GA7323@alpha.franken.de>
In-Reply-To: <20230616082322.GA7323@alpha.franken.de>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Fri, 16 Jun 2023 16:31:13 +0800
X-Gmail-Original-Message-ID: <CAAhV-H54aipF6jXAiGpcjzpDy06Q28hmx-p4msvxgASHU5Z+cw@mail.gmail.com>
Message-ID: <CAAhV-H54aipF6jXAiGpcjzpDy06Q28hmx-p4msvxgASHU5Z+cw@mail.gmail.com>
Subject: Re: [PATCH 5/5] MAINTAINERS: Update KVM/MIPS maintainers
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Yu Zhao <yuzhao@google.com>, aleksandar.qemu.devel@gmail.com,
        jiaxun.yang@flygoat.com, kvm@vger.kernel.org,
        linux-mips@vger.kernel.org, pbonzini@redhat.com,
        robh+dt@kernel.org, zhangfx@lemote.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 16, 2023 at 4:23=E2=80=AFPM Thomas Bogendoerfer
<tsbogend@alpha.franken.de> wrote:
>
> On Fri, Jun 16, 2023 at 01:18:31AM -0600, Yu Zhao wrote:
> > On Tue, Jul 28, 2020 at 23:58:20PM -0700, Huacai Chen wrote:
> > > James Hogan has become inactive for a long time and leaves KVM for MI=
PS
> > > orphan. I'm working on KVM/Loongson and attempt to make it upstream b=
oth
> > > in kernel and QEMU, while Aleksandar Markovic is already a maintainer=
 of
> > > QEMU/MIPS. We are both interested in QEMU/KVM/MIPS, and we have alrea=
dy
> > > made some contributions in kernel and QEMU. If possible, we want to t=
ake
> > > the KVM/MIPS maintainership.
> > >
> > > Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> > > Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
> > > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> > > ---
> > >  MAINTAINERS | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index bddc79a..5f9c2fd 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -9441,9 +9441,11 @@ F:   arch/arm64/kvm/
> > >  F: include/kvm/arm_*
> > >
> > >  KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)
> > > +M: Huacai Chen <chenhc@lemote.com>
> > > +M: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
> > >  L: linux-mips@vger.kernel.org
> > >  L: kvm@vger.kernel.org
> > > -S: Orphan
> > > +S: Maintained
> > >  F: arch/mips/include/asm/kvm*
> > >  F: arch/mips/include/uapi/asm/kvm*
> > >  F: arch/mips/kvm/
> >
> > Hi,
> >
> > Is kvm/mips still maintained? Thanks.
> >
> > I tried v6.4-rc6 and hit the following crash. It seems it has been brok=
en since
> >
> >   commit 45c7e8af4a5e3f0bea4ac209eea34118dd57ac64
> >   Author: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> >   Date:   Mon Mar 1 16:29:57 2021 +0100
> >
> >       MIPS: Remove KVM_TE support
>
> ok, I see what I missed when removing TE support, d'oh. Does the patch
> below fix the issue for you ?
>
> Thomas.
>
> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm=
_host.h
> index 957121a495f0..04cedf9f8811 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -317,7 +317,7 @@ struct kvm_vcpu_arch {
>         unsigned int aux_inuse;
>
>         /* COP0 State */
> -       struct mips_coproc *cop0;
> +       struct mips_coproc cop0;
Maybe keeping it as a pointer and allocate in kvm_arch_vcpu_create()
is better? (smaller modification)

Huacai
>
>         /* Resume PC after MMIO completion */
>         unsigned long io_pc;
> @@ -698,7 +698,7 @@ static inline bool kvm_mips_guest_can_have_fpu(struct=
 kvm_vcpu_arch *vcpu)
>  static inline bool kvm_mips_guest_has_fpu(struct kvm_vcpu_arch *vcpu)
>  {
>         return kvm_mips_guest_can_have_fpu(vcpu) &&
> -               kvm_read_c0_guest_config1(vcpu->cop0) & MIPS_CONF1_FP;
> +               kvm_read_c0_guest_config1(&vcpu->cop0) & MIPS_CONF1_FP;
>  }
>
>  static inline bool kvm_mips_guest_can_have_msa(struct kvm_vcpu_arch *vcp=
u)
> @@ -710,7 +710,7 @@ static inline bool kvm_mips_guest_can_have_msa(struct=
 kvm_vcpu_arch *vcpu)
>  static inline bool kvm_mips_guest_has_msa(struct kvm_vcpu_arch *vcpu)
>  {
>         return kvm_mips_guest_can_have_msa(vcpu) &&
> -               kvm_read_c0_guest_config3(vcpu->cop0) & MIPS_CONF3_MSA;
> +               kvm_read_c0_guest_config3(&vcpu->cop0) & MIPS_CONF3_MSA;
>  }
>
>  struct kvm_mips_callbacks {
> diff --git a/arch/mips/kvm/emulate.c b/arch/mips/kvm/emulate.c
> index edaec93a1a1f..e64372b8f66a 100644
> --- a/arch/mips/kvm/emulate.c
> +++ b/arch/mips/kvm/emulate.c
> @@ -312,7 +312,7 @@ int kvm_get_badinstrp(u32 *opc, struct kvm_vcpu *vcpu=
, u32 *out)
>   */
>  int kvm_mips_count_disabled(struct kvm_vcpu *vcpu)
>  {
> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>
>         return  (vcpu->arch.count_ctl & KVM_REG_MIPS_COUNT_CTL_DC) ||
>                 (kvm_read_c0_guest_cause(cop0) & CAUSEF_DC);
> @@ -384,7 +384,7 @@ static inline ktime_t kvm_mips_count_time(struct kvm_=
vcpu *vcpu)
>   */
>  static u32 kvm_mips_read_count_running(struct kvm_vcpu *vcpu, ktime_t no=
w)
>  {
> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>         ktime_t expires, threshold;
>         u32 count, compare;
>         int running;
> @@ -444,7 +444,7 @@ static u32 kvm_mips_read_count_running(struct kvm_vcp=
u *vcpu, ktime_t now)
>   */
>  u32 kvm_mips_read_count(struct kvm_vcpu *vcpu)
>  {
> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>
>         /* If count disabled just read static copy of count */
>         if (kvm_mips_count_disabled(vcpu))
> @@ -502,7 +502,7 @@ ktime_t kvm_mips_freeze_hrtimer(struct kvm_vcpu *vcpu=
, u32 *count)
>  static void kvm_mips_resume_hrtimer(struct kvm_vcpu *vcpu,
>                                     ktime_t now, u32 count)
>  {
> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>         u32 compare;
>         u64 delta;
>         ktime_t expire;
> @@ -603,7 +603,7 @@ int kvm_mips_restore_hrtimer(struct kvm_vcpu *vcpu, k=
time_t before,
>   */
>  void kvm_mips_write_count(struct kvm_vcpu *vcpu, u32 count)
>  {
> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>         ktime_t now;
>
>         /* Calculate bias */
> @@ -649,7 +649,7 @@ void kvm_mips_init_count(struct kvm_vcpu *vcpu, unsig=
ned long count_hz)
>   */
>  int kvm_mips_set_count_hz(struct kvm_vcpu *vcpu, s64 count_hz)
>  {
> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>         int dc;
>         ktime_t now;
>         u32 count;
> @@ -696,7 +696,7 @@ int kvm_mips_set_count_hz(struct kvm_vcpu *vcpu, s64 =
count_hz)
>   */
>  void kvm_mips_write_compare(struct kvm_vcpu *vcpu, u32 compare, bool ack=
)
>  {
> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>         int dc;
>         u32 old_compare =3D kvm_read_c0_guest_compare(cop0);
>         s32 delta =3D compare - old_compare;
> @@ -779,7 +779,7 @@ void kvm_mips_write_compare(struct kvm_vcpu *vcpu, u3=
2 compare, bool ack)
>   */
>  static ktime_t kvm_mips_count_disable(struct kvm_vcpu *vcpu)
>  {
> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>         u32 count;
>         ktime_t now;
>
> @@ -806,7 +806,7 @@ static ktime_t kvm_mips_count_disable(struct kvm_vcpu=
 *vcpu)
>   */
>  void kvm_mips_count_disable_cause(struct kvm_vcpu *vcpu)
>  {
> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>
>         kvm_set_c0_guest_cause(cop0, CAUSEF_DC);
>         if (!(vcpu->arch.count_ctl & KVM_REG_MIPS_COUNT_CTL_DC))
> @@ -826,7 +826,7 @@ void kvm_mips_count_disable_cause(struct kvm_vcpu *vc=
pu)
>   */
>  void kvm_mips_count_enable_cause(struct kvm_vcpu *vcpu)
>  {
> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>         u32 count;
>
>         kvm_clear_c0_guest_cause(cop0, CAUSEF_DC);
> @@ -852,7 +852,7 @@ void kvm_mips_count_enable_cause(struct kvm_vcpu *vcp=
u)
>   */
>  int kvm_mips_set_count_ctl(struct kvm_vcpu *vcpu, s64 count_ctl)
>  {
> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>         s64 changed =3D count_ctl ^ vcpu->arch.count_ctl;
>         s64 delta;
>         ktime_t expire, now;
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index 884be4ef99dc..aa5583a7b05b 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -649,7 +649,7 @@ static int kvm_mips_copy_reg_indices(struct kvm_vcpu =
*vcpu, u64 __user *indices)
>  static int kvm_mips_get_reg(struct kvm_vcpu *vcpu,
>                             const struct kvm_one_reg *reg)
>  {
> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>         struct mips_fpu_struct *fpu =3D &vcpu->arch.fpu;
>         int ret;
>         s64 v;
> @@ -761,7 +761,7 @@ static int kvm_mips_get_reg(struct kvm_vcpu *vcpu,
>  static int kvm_mips_set_reg(struct kvm_vcpu *vcpu,
>                             const struct kvm_one_reg *reg)
>  {
> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>         struct mips_fpu_struct *fpu =3D &vcpu->arch.fpu;
>         s64 v;
>         s64 vs[2];
> @@ -1086,7 +1086,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, l=
ong ext)
>  int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
>  {
>         return kvm_mips_pending_timer(vcpu) ||
> -               kvm_read_c0_guest_cause(vcpu->arch.cop0) & C_TI;
> +               kvm_read_c0_guest_cause(&vcpu->arch.cop0) & C_TI;
>  }
>
>  int kvm_arch_vcpu_dump_regs(struct kvm_vcpu *vcpu)
> @@ -1110,7 +1110,7 @@ int kvm_arch_vcpu_dump_regs(struct kvm_vcpu *vcpu)
>         kvm_debug("\thi: 0x%08lx\n", vcpu->arch.hi);
>         kvm_debug("\tlo: 0x%08lx\n", vcpu->arch.lo);
>
> -       cop0 =3D vcpu->arch.cop0;
> +       cop0 =3D &vcpu->arch.cop0;
>         kvm_debug("\tStatus: 0x%08x, Cause: 0x%08x\n",
>                   kvm_read_c0_guest_status(cop0),
>                   kvm_read_c0_guest_cause(cop0));
> @@ -1232,7 +1232,7 @@ static int __kvm_mips_handle_exit(struct kvm_vcpu *=
vcpu)
>
>         case EXCCODE_TLBS:
>                 kvm_debug("TLB ST fault:  cause %#x, status %#x, PC: %p, =
BadVaddr: %#lx\n",
> -                         cause, kvm_read_c0_guest_status(vcpu->arch.cop0=
), opc,
> +                         cause, kvm_read_c0_guest_status(&vcpu->arch.cop=
0), opc,
>                           badvaddr);
>
>                 ++vcpu->stat.tlbmiss_st_exits;
> @@ -1304,7 +1304,7 @@ static int __kvm_mips_handle_exit(struct kvm_vcpu *=
vcpu)
>                 kvm_get_badinstr(opc, vcpu, &inst);
>                 kvm_err("Exception Code: %d, not yet handled, @ PC: %p, i=
nst: 0x%08x  BadVaddr: %#lx Status: %#x\n",
>                         exccode, opc, inst, badvaddr,
> -                       kvm_read_c0_guest_status(vcpu->arch.cop0));
> +                       kvm_read_c0_guest_status(&vcpu->arch.cop0));
>                 kvm_arch_vcpu_dump_regs(vcpu);
>                 run->exit_reason =3D KVM_EXIT_INTERNAL_ERROR;
>                 ret =3D RESUME_HOST;
> @@ -1377,7 +1377,7 @@ int noinstr kvm_mips_handle_exit(struct kvm_vcpu *v=
cpu)
>  /* Enable FPU for guest and restore context */
>  void kvm_own_fpu(struct kvm_vcpu *vcpu)
>  {
> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>         unsigned int sr, cfg5;
>
>         preempt_disable();
> @@ -1421,7 +1421,7 @@ void kvm_own_fpu(struct kvm_vcpu *vcpu)
>  /* Enable MSA for guest and restore context */
>  void kvm_own_msa(struct kvm_vcpu *vcpu)
>  {
> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>         unsigned int sr, cfg5;
>
>         preempt_disable();
> diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
> index 3d21cbfa7443..99d5a71e4300 100644
> --- a/arch/mips/kvm/vz.c
> +++ b/arch/mips/kvm/vz.c
> @@ -422,7 +422,7 @@ static void _kvm_vz_restore_htimer(struct kvm_vcpu *v=
cpu,
>   */
>  static void kvm_vz_restore_timer(struct kvm_vcpu *vcpu)
>  {
> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>         u32 cause, compare;
>
>         compare =3D kvm_read_sw_gc0_compare(cop0);
> @@ -517,7 +517,7 @@ static void _kvm_vz_save_htimer(struct kvm_vcpu *vcpu=
,
>   */
>  static void kvm_vz_save_timer(struct kvm_vcpu *vcpu)
>  {
> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>         u32 gctl0, compare, cause;
>
>         gctl0 =3D read_c0_guestctl0();
> @@ -863,7 +863,7 @@ static unsigned long mips_process_maar(unsigned int o=
p, unsigned long val)
>
>  static void kvm_write_maari(struct kvm_vcpu *vcpu, unsigned long val)
>  {
> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>
>         val &=3D MIPS_MAARI_INDEX;
>         if (val =3D=3D MIPS_MAARI_INDEX)
> @@ -876,7 +876,7 @@ static enum emulation_result kvm_vz_gpsi_cop0(union m=
ips_instruction inst,
>                                               u32 *opc, u32 cause,
>                                               struct kvm_vcpu *vcpu)
>  {
> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>         enum emulation_result er =3D EMULATE_DONE;
>         u32 rt, rd, sel;
>         unsigned long curr_pc;
> @@ -1911,7 +1911,7 @@ static int kvm_vz_get_one_reg(struct kvm_vcpu *vcpu=
,
>                               const struct kvm_one_reg *reg,
>                               s64 *v)
>  {
> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>         unsigned int idx;
>
>         switch (reg->id) {
> @@ -2081,7 +2081,7 @@ static int kvm_vz_get_one_reg(struct kvm_vcpu *vcpu=
,
>         case KVM_REG_MIPS_CP0_MAARI:
>                 if (!cpu_guest_has_maar || cpu_guest_has_dyn_maar)
>                         return -EINVAL;
> -               *v =3D kvm_read_sw_gc0_maari(vcpu->arch.cop0);
> +               *v =3D kvm_read_sw_gc0_maari(&vcpu->arch.cop0);
>                 break;
>  #ifdef CONFIG_64BIT
>         case KVM_REG_MIPS_CP0_XCONTEXT:
> @@ -2135,7 +2135,7 @@ static int kvm_vz_set_one_reg(struct kvm_vcpu *vcpu=
,
>                               const struct kvm_one_reg *reg,
>                               s64 v)
>  {
> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>         unsigned int idx;
>         int ret =3D 0;
>         unsigned int cur, change;
> @@ -2562,7 +2562,7 @@ static void kvm_vz_vcpu_load_tlb(struct kvm_vcpu *v=
cpu, int cpu)
>
>  static int kvm_vz_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  {
> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>         bool migrated, all;
>
>         /*
> @@ -2704,7 +2704,7 @@ static int kvm_vz_vcpu_load(struct kvm_vcpu *vcpu, =
int cpu)
>
>  static int kvm_vz_vcpu_put(struct kvm_vcpu *vcpu, int cpu)
>  {
> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>
>         if (current->flags & PF_VCPU)
>                 kvm_vz_vcpu_save_wired(vcpu);
> @@ -3076,7 +3076,7 @@ static void kvm_vz_vcpu_uninit(struct kvm_vcpu *vcp=
u)
>
>  static int kvm_vz_vcpu_setup(struct kvm_vcpu *vcpu)
>  {
> -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
>         unsigned long count_hz =3D 100*1000*1000; /* default to 100 MHz *=
/
>
>         /*
>
> --
> Crap can work. Given enough thrust pigs will fly, but it's not necessaril=
y a
> good idea.                                                [ RFC1925, 2.3 =
]
