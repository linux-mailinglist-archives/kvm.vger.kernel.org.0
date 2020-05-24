Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 233E11DFC93
	for <lists+kvm@lfdr.de>; Sun, 24 May 2020 04:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388271AbgEXCpd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 22:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388250AbgEXCpd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 May 2020 22:45:33 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB94C061A0E;
        Sat, 23 May 2020 19:45:31 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id j2so14562587ilr.5;
        Sat, 23 May 2020 19:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sPIpS7o+v+dd68E0lXRCwMzyADINEPr31caprUJMgMI=;
        b=X763fNTdFkbB7EHWL0zmKDkl0wHjeoXGPNsP0jqw4nqHaJL6LnxlqRDhPxGI8DIfbF
         OFca2mpQHhwcNGnL9Y09W1yQ7dcEd3ugLjXPxrZKIAzyOmFSTdDV53STxiIO7rLXUipL
         PBfNzz+kbQ3PTIgzUlqKGOFu/x795f1JtpE9HryDX4UWlm0jYvuy9PkhNa1tATZzIXwt
         UB2YK/4ymWT2BGLUnAehmlhaYQVW6XfWmVxxlyBt0Fiq7WAIlBKGECJhBeb9KLhFzF9C
         boLdQJXt5IGH3s7QME1/Wee59VAgn5IVzT6XVtyOwGGrfGvgxbJ4aafmhvHRqG86KRoS
         9eSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sPIpS7o+v+dd68E0lXRCwMzyADINEPr31caprUJMgMI=;
        b=ZIaLNXh3TXIdqFWTKz9j+kD9gJ435pY+h5KsmsjPziZV8SEgMw5t29wiAePda6mk02
         G3Ayq0JiZlsNfnfQh4qnJOYQEgrSTUzc1rxQry2OVZCr2Wbi7b/FbSu2vzP4QJltmvg1
         xCykc4ovZ7SZHR0FYp/aas4gJN3Hx8mINsI9yvYYVQDdt2Yq/ZR8kTd0nxPwkMgmBkya
         22ERXcb4kW6tqzEmsvPEaM09iODxvbG3EIegSQWbRJTCQkrggjMxMqRUdg6S5qZbJi2G
         /R7mKRmLRCzALKy40dPb2/1TTkr9hUtKMF5u/98YD0+FJj8d2GPuuJoawzSvHAqQpI2n
         Sx3A==
X-Gm-Message-State: AOAM532ZDyP+PNKd2tRblYmvJZADIc5BNjyyHaH2jxCwOqpYbeGpiZu4
        B7FVgyVGCKj81Tw7Lo/PS64gYbDV+6psyFBZs8A=
X-Google-Smtp-Source: ABdhPJyXp/52Vs6QaZ8JwyNh3fuzLRWdAqjapa/7cCZ9rXYC5mSqXzvUJ3nVdoFG60eKsHkZvhAyFvm43F7Jw5B00X8=
X-Received: by 2002:a92:980f:: with SMTP id l15mr19343146ili.251.1590288329769;
 Sat, 23 May 2020 19:45:29 -0700 (PDT)
MIME-Version: 1.0
References: <1590220602-3547-1-git-send-email-chenhc@lemote.com>
 <1590220602-3547-13-git-send-email-chenhc@lemote.com> <a52129ed-80ff-304a-59d6-f132c7553646@xen0n.name>
 <CAHiYmc6YDw7=mqXfMdgSfeR-HVd2Ec+sQVquM=Z6jLke2s-VEw@mail.gmail.com>
In-Reply-To: <CAHiYmc6YDw7=mqXfMdgSfeR-HVd2Ec+sQVquM=Z6jLke2s-VEw@mail.gmail.com>
From:   Huacai Chen <chenhuacai@gmail.com>
Date:   Sun, 24 May 2020 10:45:18 +0800
Message-ID: <CAAhV-H400FyhpmWutr7=g0AF2BVn7kJ=b89KapYs-nU2fuwaZQ@mail.gmail.com>
Subject: Re: [PATCH V7 12/15] KVM: MIPS: Add CONFIG6 and DIAG registers emulation
To:     Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     WANG Xuerui <kernel@xen0n.name>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        kvm <kvm@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Aleksandar


On Sat, May 23, 2020 at 9:59 PM Aleksandar Markovic
<aleksandar.qemu.devel@gmail.com> wrote:
>
>  you sh
>
> =D1=81=D1=83=D0=B1, 23. =D0=BC=D0=B0=D1=98 2020. =D1=83 15:27 WANG Xuerui=
 <kernel@xen0n.name> =D1=98=D0=B5 =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=
=BE/=D0=BB=D0=B0:
> >
> > Hi Huacai,
> >
> > On 5/23/20 3:56 PM, Huacai Chen wrote:
> >
> > > Loongson-3 has CONFIG6 and DIAG registers which need to be emulated.
> > > CONFIG6 is mostly used to enable/disable FTLB and SFB, while DIAG is
> > > mostly used to flush BTB, ITLB, DTLB, VTLB and FTLB.
> > >
> > > Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> > > Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
> > > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> > > Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> > > ---
> > >   arch/mips/include/asm/kvm_host.h |  7 +++++
> > >   arch/mips/include/asm/mipsregs.h |  7 +++++
> > >   arch/mips/kvm/tlb.c              | 41 ++++++++++++++++++++++++++
> > >   arch/mips/kvm/vz.c               | 62 +++++++++++++++++++++++++++++=
++++++++++-
> > >   4 files changed, 116 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm=
/kvm_host.h
> > > index 3fd2f1c..30b5e33 100644
> > > --- a/arch/mips/include/asm/kvm_host.h
> > > +++ b/arch/mips/include/asm/kvm_host.h
> > > @@ -68,9 +68,11 @@
> > >   #define KVM_REG_MIPS_CP0_CONFIG3    MIPS_CP0_32(16, 3)
> > >   #define KVM_REG_MIPS_CP0_CONFIG4    MIPS_CP0_32(16, 4)
> > >   #define KVM_REG_MIPS_CP0_CONFIG5    MIPS_CP0_32(16, 5)
> > > +#define KVM_REG_MIPS_CP0_CONFIG6     MIPS_CP0_32(16, 6)
> > >   #define KVM_REG_MIPS_CP0_CONFIG7    MIPS_CP0_32(16, 7)
> > >   #define KVM_REG_MIPS_CP0_MAARI              MIPS_CP0_64(17, 2)
> > >   #define KVM_REG_MIPS_CP0_XCONTEXT   MIPS_CP0_64(20, 0)
> > > +#define KVM_REG_MIPS_CP0_DIAG                MIPS_CP0_32(22, 0)
> > >   #define KVM_REG_MIPS_CP0_ERROREPC   MIPS_CP0_64(30, 0)
> > >   #define KVM_REG_MIPS_CP0_KSCRATCH1  MIPS_CP0_64(31, 2)
> > >   #define KVM_REG_MIPS_CP0_KSCRATCH2  MIPS_CP0_64(31, 3)
> > > @@ -256,6 +258,7 @@ struct mips_coproc {
> > >   #define MIPS_CP0_WATCH_LO   18
> > >   #define MIPS_CP0_WATCH_HI   19
> > >   #define MIPS_CP0_TLB_XCONTEXT       20
> > > +#define MIPS_CP0_DIAG                22
> > >   #define MIPS_CP0_ECC                26
> > >   #define MIPS_CP0_CACHE_ERR  27
> > >   #define MIPS_CP0_TAG_LO             28
> > > @@ -927,6 +930,10 @@ void kvm_vz_save_guesttlb(struct kvm_mips_tlb *b=
uf, unsigned int index,
> > >                         unsigned int count);
> > >   void kvm_vz_load_guesttlb(const struct kvm_mips_tlb *buf, unsigned =
int index,
> > >                         unsigned int count);
> > > +#ifdef CONFIG_CPU_LOONGSON64
> > > +void kvm_loongson_clear_guest_vtlb(void);
> > > +void kvm_loongson_clear_guest_ftlb(void);
> > > +#endif
> > >   #endif
> > >
> > >   void kvm_mips_suspend_mm(int cpu);
> > > diff --git a/arch/mips/include/asm/mipsregs.h b/arch/mips/include/asm=
/mipsregs.h
> > > index 796fe47..ce40fbf 100644
> > > --- a/arch/mips/include/asm/mipsregs.h
> > > +++ b/arch/mips/include/asm/mipsregs.h
> > > @@ -993,6 +996,8 @@
> > >   /* Disable Branch Return Cache */
> > >   #define R10K_DIAG_D_BRC             (_ULCAST_(1) << 22)
> > >
> > > +/* Flush BTB */
> > > +#define LOONGSON_DIAG_BTB    (_ULCAST_(1) << 1)
> > >   /* Flush ITLB */
> > >   #define LOONGSON_DIAG_ITLB  (_ULCAST_(1) << 2)
> > >   /* Flush DTLB */
> > > @@ -2825,7 +2830,9 @@ __BUILD_SET_C0(status)
> > >   __BUILD_SET_C0(cause)
> > >   __BUILD_SET_C0(config)
> > >   __BUILD_SET_C0(config5)
> > > +__BUILD_SET_C0(config6)
> > >   __BUILD_SET_C0(config7)
> > > +__BUILD_SET_C0(diag)
> > >   __BUILD_SET_C0(intcontrol)
> > >   __BUILD_SET_C0(intctl)
> > >   __BUILD_SET_C0(srsmap)
> > > diff --git a/arch/mips/kvm/tlb.c b/arch/mips/kvm/tlb.c
> > > index 7cd9216..1418715 100644
> > > --- a/arch/mips/kvm/tlb.c
> > > +++ b/arch/mips/kvm/tlb.c
> > > @@ -20,6 +20,7 @@
> > >
> > >   #include <asm/cpu.h>
> > >   #include <asm/bootinfo.h>
> > > +#include <asm/mipsregs.h>
> > >   #include <asm/mmu_context.h>
> > >   #include <asm/pgtable.h>
> > >   #include <asm/cacheflush.h>
> > > @@ -622,6 +623,46 @@ void kvm_vz_load_guesttlb(const struct kvm_mips_=
tlb *buf, unsigned int index,
> > >   }
> > >   EXPORT_SYMBOL_GPL(kvm_vz_load_guesttlb);
> > >
> > > +#ifdef CONFIG_CPU_LOONGSON64
> > > +void kvm_loongson_clear_guest_vtlb(void)
> > > +{
> > > +     int idx =3D read_gc0_index();
> > > +
> > > +     /* Set root GuestID for root probe and write of guest TLB entry=
 */
> > > +     set_root_gid_to_guest_gid();
> > > +
> > > +     write_gc0_index(0);
> > > +     guest_tlbinvf();
> > > +     write_gc0_index(idx);
> > > +
> > > +     clear_root_gid();
> > > +     set_c0_diag(LOONGSON_DIAG_ITLB | LOONGSON_DIAG_DTLB);
> > > +}
> > > +EXPORT_SYMBOL_GPL(kvm_loongson_clear_guest_vtlb);
> > > +
> > > +void kvm_loongson_clear_guest_ftlb(void)
> > > +{
> > > +     int i;
> > > +     int idx =3D read_gc0_index();
> > > +
> > > +     /* Set root GuestID for root probe and write of guest TLB entry=
 */
> > > +     set_root_gid_to_guest_gid();
> > > +
> > > +     for (i =3D current_cpu_data.tlbsizevtlb;
> > > +          i < (current_cpu_data.tlbsizevtlb +
> > > +                  current_cpu_data.tlbsizeftlbsets);
> > > +          i++) {
> > > +             write_gc0_index(i);
> > > +             guest_tlbinvf();
> > > +     }
> > > +     write_gc0_index(idx);
> > > +
> > > +     clear_root_gid();
> > > +     set_c0_diag(LOONGSON_DIAG_ITLB | LOONGSON_DIAG_DTLB);
> > > +}
> > > +EXPORT_SYMBOL_GPL(kvm_loongson_clear_guest_ftlb);
> > > +#endif
> > > +
> > >   #endif
> > >
> > >   /**
> > > diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
> > > index 72a62f1..73701c3 100644
> > > --- a/arch/mips/kvm/vz.c
> > > +++ b/arch/mips/kvm/vz.c
> > > @@ -127,6 +127,11 @@ static inline unsigned int kvm_vz_config5_guest_=
wrmask(struct kvm_vcpu *vcpu)
> > >       return mask;
> > >   }
> > >
> > > +static inline unsigned int kvm_vz_config6_guest_wrmask(struct kvm_vc=
pu *vcpu)
> > > +{
> > > +     return MIPS_CONF6_LOONGSON_INTIMER | MIPS_CONF6_LOONGSON_EXTIME=
R;
> >
> > This depends on the "MIPS: Tidy up CP0.Config6 bits definition" patch
> > which is not yet upstream.
> >
> > I'd suggest backing this change out to prioritize upstreaming of v6.
> > Cleanups can always come later. It's not like this kind of minor
> > cleanups should block progress of greater things...
> >
>
> Hi, Huacai,
>
> I must agree with Wang, You started complicating thing, and exactly at th=
e moment we reached consensus on v6. Either accept Wang;s advice, or make t=
hat "MIPS: Tidy up CP0.Config6 bits definition" patch part of your series a=
nd send v8.
>
> And your series should be made as if it should be applied to kernel upstr=
eam, not linux-mips. That will make Paolo's life easier. Please try to simp=
lify things for other participants, not mix some minor thing from different=
 trees etc., or now deal with your pgp keys, or other currently unimportant=
 things, instead tryto  focus on the cleanness of the series. Paolo will su=
bmit pull request, and we should be thankful to him for doing this, trust m=
e, submitting pull requests is not fun at all.
I will send a V8 series which can be applied on the linux-next branch
at https://git.kernel.org/pub/scm/virt/kvm/kvm.git/, I think this is
the best way for Paolo.

Huacai
>
> Yours,
> Aleksandar
>
>
> > > +}
> > > +
> > >   /*
> > >    * VZ optionally allows these additional Config bits to be written =
by root:
> > >    * Config:  M, [MT]
> > > @@ -181,6 +186,12 @@ static inline unsigned int kvm_vz_config5_user_w=
rmask(struct kvm_vcpu *vcpu)
> > >       return kvm_vz_config5_guest_wrmask(vcpu) | MIPS_CONF5_MRP;
> > >   }
> > >
> > > +static inline unsigned int kvm_vz_config6_user_wrmask(struct kvm_vcp=
u *vcpu)
> > > +{
> > > +     return kvm_vz_config6_guest_wrmask(vcpu) |
> > > +             MIPS_CONF6_LOONGSON_SFBEN | MIPS_CONF6_LOONGSON_FTLBDIS=
;
> > > +}
> > > +
> > >   static gpa_t kvm_vz_gva_to_gpa_cb(gva_t gva)
> > >   {
> > >       /* VZ guest has already converted gva to gpa */
> > > @@ -930,7 +941,8 @@ static enum emulation_result kvm_vz_gpsi_cop0(uni=
on mips_instruction inst,
> > >                                   (sel =3D=3D 2 ||        /* SRSCtl *=
/
> > >                                    sel =3D=3D 3)) ||      /* SRSMap *=
/
> > >                                  (rd =3D=3D MIPS_CP0_CONFIG &&
> > > -                                 (sel =3D=3D 7)) ||      /* Config7 =
*/
> > > +                                 (sel =3D=3D 6 ||        /* Config6 =
*/
> > > +                                  sel =3D=3D 7)) ||      /* Config7 =
*/
> > >                                  (rd =3D=3D MIPS_CP0_LLADDR &&
> > >                                   (sel =3D=3D 2) &&       /* MAARI */
> > >                                   cpu_guest_has_maar &&
> > > @@ -938,6 +950,11 @@ static enum emulation_result kvm_vz_gpsi_cop0(un=
ion mips_instruction inst,
> > >                                  (rd =3D=3D MIPS_CP0_ERRCTL &&
> > >                                   (sel =3D=3D 0))) {      /* ErrCtl *=
/
> > >                               val =3D cop0->reg[rd][sel];
> > > +#ifdef CONFIG_CPU_LOONGSON64
> > > +                     } else if (rd =3D=3D MIPS_CP0_DIAG &&
> > > +                                (sel =3D=3D 0)) {        /* Diag */
> > > +                             val =3D cop0->reg[rd][sel];
> > > +#endif
> > >                       } else {
> > >                               val =3D 0;
> > >                               er =3D EMULATE_FAIL;
> > > @@ -1000,9 +1017,40 @@ static enum emulation_result kvm_vz_gpsi_cop0(=
union mips_instruction inst,
> > >                                  cpu_guest_has_maar &&
> > >                                  !cpu_guest_has_dyn_maar) {
> > >                               kvm_write_maari(vcpu, val);
> > > +                     } else if (rd =3D=3D MIPS_CP0_CONFIG &&
> > > +                                (sel =3D=3D 6)) {
> > > +                             cop0->reg[rd][sel] =3D (int)val;
> > >                       } else if (rd =3D=3D MIPS_CP0_ERRCTL &&
> > >                                  (sel =3D=3D 0)) {        /* ErrCtl *=
/
> > >                               /* ignore the written value */
> > > +#ifdef CONFIG_CPU_LOONGSON64
> > > +                     } else if (rd =3D=3D MIPS_CP0_DIAG &&
> > > +                                (sel =3D=3D 0)) {        /* Diag */
> > > +                             unsigned long flags;
> > > +
> > > +                             local_irq_save(flags);
> > > +                             if (val & LOONGSON_DIAG_BTB) {
> > > +                                     /* Flush BTB */
> > > +                                     set_c0_diag(LOONGSON_DIAG_BTB);
> > > +                             }
> > > +                             if (val & LOONGSON_DIAG_ITLB) {
> > > +                                     /* Flush ITLB */
> > > +                                     set_c0_diag(LOONGSON_DIAG_ITLB)=
;
> > > +                             }
> > > +                             if (val & LOONGSON_DIAG_DTLB) {
> > > +                                     /* Flush DTLB */
> > > +                                     set_c0_diag(LOONGSON_DIAG_DTLB)=
;
> > > +                             }
> > > +                             if (val & LOONGSON_DIAG_VTLB) {
> > > +                                     /* Flush VTLB */
> > > +                                     kvm_loongson_clear_guest_vtlb()=
;
> > > +                             }
> > > +                             if (val & LOONGSON_DIAG_FTLB) {
> > > +                                     /* Flush FTLB */
> > > +                                     kvm_loongson_clear_guest_ftlb()=
;
> > > +                             }
> > > +                             local_irq_restore(flags);
> > > +#endif
> > >                       } else {
> > >                               er =3D EMULATE_FAIL;
> > >                       }
> > > @@ -1692,6 +1740,7 @@ static u64 kvm_vz_get_one_regs[] =3D {
> > >       KVM_REG_MIPS_CP0_CONFIG3,
> > >       KVM_REG_MIPS_CP0_CONFIG4,
> > >       KVM_REG_MIPS_CP0_CONFIG5,
> > > +     KVM_REG_MIPS_CP0_CONFIG6,
> > >   #ifdef CONFIG_64BIT
> > >       KVM_REG_MIPS_CP0_XCONTEXT,
> > >   #endif
> > > @@ -2019,6 +2068,9 @@ static int kvm_vz_get_one_reg(struct kvm_vcpu *=
vcpu,
> > >                       return -EINVAL;
> > >               *v =3D read_gc0_config5();
> > >               break;
> > > +     case KVM_REG_MIPS_CP0_CONFIG6:
> > > +             *v =3D kvm_read_sw_gc0_config6(cop0);
> > > +             break;
> > >       case KVM_REG_MIPS_CP0_MAAR(0) ... KVM_REG_MIPS_CP0_MAAR(0x3f):
> > >               if (!cpu_guest_has_maar || cpu_guest_has_dyn_maar)
> > >                       return -EINVAL;
> > > @@ -2288,6 +2340,14 @@ static int kvm_vz_set_one_reg(struct kvm_vcpu =
*vcpu,
> > >                       write_gc0_config5(v);
> > >               }
> > >               break;
> > > +     case KVM_REG_MIPS_CP0_CONFIG6:
> > > +             cur =3D kvm_read_sw_gc0_config6(cop0);
> > > +             change =3D (cur ^ v) & kvm_vz_config6_user_wrmask(vcpu)=
;
> > > +             if (change) {
> > > +                     v =3D cur ^ change;
> > > +                     kvm_write_sw_gc0_config6(cop0, (int)v);
> > > +             }
> > > +             break;
> > >       case KVM_REG_MIPS_CP0_MAAR(0) ... KVM_REG_MIPS_CP0_MAAR(0x3f):
> > >               if (!cpu_guest_has_maar || cpu_guest_has_dyn_maar)
> > >                       return -EINVAL;
