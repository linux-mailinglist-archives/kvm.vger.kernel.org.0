Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13A261365C6
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 04:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730970AbgAJDXJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 22:23:09 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38931 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730952AbgAJDXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 22:23:09 -0500
Received: by mail-wm1-f66.google.com with SMTP id 20so446143wmj.4
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 19:23:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZAEkX/VWTLJ8uZxbCM5wcLv0heUOqQqTWwGXwc0d0FQ=;
        b=KQKKBb/W+s7IQNQsN7/KzhIehhnEdttuu3wopCayayvXivRHneNMXGnhrDLXKVnEs7
         DSFwQRvqz2X8YnEb5Ji1jJtVOEpVvcVELrE6HHC0TKfitDXB1EBBNVAx10mgMrxEzRtU
         x81mdWpE6BNGMWqzIi1z+ASDqCCNeNEbNaQMo8MbRvgF6USBrYf4Oh46roX01v0lm/zN
         So2E2qDgZPYuvdr9KESdxAPaI2W5LlzLx/fkHqmkg+rvdNmjzkvwiT5+5ecFPLeFLbZ2
         MHgq2xmuhbJL5/rCprJT4scbiit9eBTgTo6EEJNpFyb133T3KpH1HceR/EsUReb9FCMk
         Ltuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZAEkX/VWTLJ8uZxbCM5wcLv0heUOqQqTWwGXwc0d0FQ=;
        b=rP0zracNV98nzADFwl937UZIYvPbk1Uvk/YAiFsjIcZFpRqMVvTf14ISjmKpogFFz9
         cywRcuQjatsEpE4qAIpdTaPwTQTRaOM3ZndfzWJsoSw0sKiBC46Th4zm4hwGZKO6a5Gh
         v4+C4nWemZ/yl40ndtrlqLdPP47cFAWB8YS9FDYwPHZ6nK7AbExzWEIMMi46GbZlO+uU
         sHcI9XME3+hgb+O+R6IjiqRabdv3y4x0bvVLRXzc+yW2l3GLjDyA9VPUad1ueH7F2U0s
         pkRuzkrkmH+aTVieJk9HomyxCTGRxCgVrhHxS5DxaBnYIGGvYkClozLTshf6txWSyDb3
         xDwQ==
X-Gm-Message-State: APjAAAUOhM7rokjRyJc54DMJXV2Aw8CzsDuA4K8AwZgbIU2KMSOSuMwT
        UIPWrn2tnO6lkEE6Be7EyRW2TrvLhOrjo1BsqespTw==
X-Google-Smtp-Source: APXvYqxGvMr3pAaeIB49r7X8zwgfojDsIlKzeOqh8BIcm4h6d6tlfsj062er98Toobg1aI6Mrfw5yxHLCzxw+4a0avI=
X-Received: by 2002:a7b:cf0d:: with SMTP id l13mr1252693wmg.13.1578626584384;
 Thu, 09 Jan 2020 19:23:04 -0800 (PST)
MIME-Version: 1.0
References: <20191225025945.108466-1-anup.patel@wdc.com> <20191225025945.108466-5-anup.patel@wdc.com>
 <6939f485-dd09-e857-0015-1a28e05f0855@arm.com>
In-Reply-To: <6939f485-dd09-e857-0015-1a28e05f0855@arm.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 10 Jan 2020 08:52:53 +0530
Message-ID: <CAAhSdy0pJufv5ELaojpEKOx9r1OmAj3SGZV=DVC3VEewdq2UKQ@mail.gmail.com>
Subject: Re: [kvmtool RFC PATCH 4/8] riscv: Implement Guest/VM VCPU arch functions
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>, Will Deacon <will.deacon@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 8, 2020 at 6:52 PM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Hi,
>
> On 12/25/19 3:00 AM, Anup Patel wrote:
> > This patch implements kvm_cpu__<xyz> Guest/VM VCPU arch functions.
> >
> > These functions mostly deal with:
> > 1. VCPU allocation and initialization
> > 2. VCPU reset
> > 3. VCPU show/dump code
> > 4. VCPU show/dump registers
> >
> > We also save RISC-V ISA, XLEN, and TIMEBASE frequency for each VCPU
> > so that it can be later used for generating Guest/VM FDT.
> >
> > Signed-off-by: Anup Patel <anup.patel@wdc.com>
> > ---
> >  riscv/include/kvm/kvm-cpu-arch.h |   4 +
> >  riscv/kvm-cpu.c                  | 307 ++++++++++++++++++++++++++++++-
> >  2 files changed, 304 insertions(+), 7 deletions(-)
> >
> > diff --git a/riscv/include/kvm/kvm-cpu-arch.h b/riscv/include/kvm/kvm-cpu-arch.h
> > index 09a50e8..035965e 100644
> > --- a/riscv/include/kvm/kvm-cpu-arch.h
> > +++ b/riscv/include/kvm/kvm-cpu-arch.h
> > @@ -14,6 +14,10 @@ struct kvm_cpu {
> >
> >       unsigned long   cpu_id;
> >
> > +     unsigned long   riscv_xlen;
> > +     unsigned long   riscv_isa;
> > +     unsigned long   riscv_timebase;
> > +
> >       struct kvm      *kvm;
> >       int             vcpu_fd;
> >       struct kvm_run  *kvm_run;
> > diff --git a/riscv/kvm-cpu.c b/riscv/kvm-cpu.c
> > index e4b8fa5..1565275 100644
> > --- a/riscv/kvm-cpu.c
> > +++ b/riscv/kvm-cpu.c
> > @@ -17,10 +17,84 @@ int kvm_cpu__get_debug_fd(void)
> >       return debug_fd;
> >  }
> >
> > +static __u64 __kvm_reg_id(__u64 type, __u64 idx)
> > +{
> > +     __u64 id = KVM_REG_RISCV | type | idx;
> > +
> > +     if (sizeof(unsigned long) == 8)
>
> This looks fragile. As far as I know, according to C99 the minimum width of
> unsigned long is 32 bits. Why not use __riscv_xlen instead?

Good suggestion. I will use __riscv_xlen here.

>
> Thanks,
> Alex
> > +             id |= KVM_REG_SIZE_U64;
> > +     else
> > +             id |= KVM_REG_SIZE_U32;
> > +
> > +     return id;
> > +}
> > +
> > +#define RISCV_CONFIG_REG(name)       __kvm_reg_id(KVM_REG_RISCV_CONFIG, \
> > +                                          KVM_REG_RISCV_CONFIG_REG(name))
> > +
> > +#define RISCV_CORE_REG(name) __kvm_reg_id(KVM_REG_RISCV_CORE, \
> > +                                          KVM_REG_RISCV_CORE_REG(name))
> > +
> > +#define RISCV_CSR_REG(name)  __kvm_reg_id(KVM_REG_RISCV_CSR, \
> > +                                          KVM_REG_RISCV_CSR_REG(name))
> > +
> > +#define RISCV_TIMER_REG(name)        __kvm_reg_id(KVM_REG_RISCV_TIMER, \
> > +                                          KVM_REG_RISCV_TIMER_REG(name))
> > +
> >  struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
> >  {
> > -     /* TODO: */
> > -     return NULL;
> > +     struct kvm_cpu *vcpu;
> > +     unsigned long timebase = 0, isa = 0;
> > +     int coalesced_offset, mmap_size;
> > +     struct kvm_one_reg reg;
> > +
> > +     vcpu = calloc(1, sizeof(struct kvm_cpu));
> > +     if (!vcpu)
> > +             return NULL;
> > +
> > +     vcpu->vcpu_fd = ioctl(kvm->vm_fd, KVM_CREATE_VCPU, cpu_id);
> > +     if (vcpu->vcpu_fd < 0)
> > +             die_perror("KVM_CREATE_VCPU ioctl");
> > +
> > +     reg.id = RISCV_CONFIG_REG(isa);
> > +     reg.addr = (unsigned long)&isa;
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (config.isa)");
> > +
> > +     reg.id = RISCV_TIMER_REG(frequency);
> > +     reg.addr = (unsigned long)&timebase;
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (config.timebase)");
> > +
> > +     mmap_size = ioctl(kvm->sys_fd, KVM_GET_VCPU_MMAP_SIZE, 0);
> > +     if (mmap_size < 0)
> > +             die_perror("KVM_GET_VCPU_MMAP_SIZE ioctl");
> > +
> > +     vcpu->kvm_run = mmap(NULL, mmap_size, PROT_RW, MAP_SHARED,
> > +                          vcpu->vcpu_fd, 0);
> > +     if (vcpu->kvm_run == MAP_FAILED)
> > +             die("unable to mmap vcpu fd");
> > +
> > +     coalesced_offset = ioctl(kvm->sys_fd, KVM_CHECK_EXTENSION,
> > +                              KVM_CAP_COALESCED_MMIO);
> > +     if (coalesced_offset)
> > +             vcpu->ring = (void *)vcpu->kvm_run +
> > +                          (coalesced_offset * PAGE_SIZE);
> > +
> > +     reg.id = RISCV_CONFIG_REG(isa);
> > +     reg.addr = (unsigned long)&isa;
> > +     if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
> > +             die("KVM_SET_ONE_REG failed (config.isa)");
> > +
> > +     /* Populate the vcpu structure. */
> > +     vcpu->kvm               = kvm;
> > +     vcpu->cpu_id            = cpu_id;
> > +     vcpu->riscv_isa         = isa;
> > +     vcpu->riscv_xlen        = __riscv_xlen;
> > +     vcpu->riscv_timebase    = timebase;
> > +     vcpu->is_running        = true;
> > +
> > +     return vcpu;
> >  }
> >
> >  void kvm_cpu__arch_nmi(struct kvm_cpu *cpu)
> > @@ -29,7 +103,7 @@ void kvm_cpu__arch_nmi(struct kvm_cpu *cpu)
> >
> >  void kvm_cpu__delete(struct kvm_cpu *vcpu)
> >  {
> > -     /* TODO: */
> > +     free(vcpu);
> >  }
> >
> >  bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
> > @@ -40,12 +114,43 @@ bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
> >
> >  void kvm_cpu__show_page_tables(struct kvm_cpu *vcpu)
> >  {
> > -     /* TODO: */
> >  }
> >
> >  void kvm_cpu__reset_vcpu(struct kvm_cpu *vcpu)
> >  {
> > -     /* TODO: */
> > +     struct kvm *kvm = vcpu->kvm;
> > +     struct kvm_mp_state mp_state;
> > +     struct kvm_one_reg reg;
> > +     unsigned long data;
> > +
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_MP_STATE, &mp_state) < 0)
> > +             die_perror("KVM_GET_MP_STATE failed");
> > +
> > +     /*
> > +      * If MP state is stopped then it means Linux KVM RISC-V emulates
> > +      * SBI v0.2 (or higher) with HART power managment and give VCPU
> > +      * will power-up at boot-time by boot VCPU. For such VCPU, we
> > +      * don't update PC, A0 and A1 here.
> > +      */
> > +     if (mp_state.mp_state == KVM_MP_STATE_STOPPED)
> > +             return;
> > +
> > +     reg.addr = (unsigned long)&data;
> > +
> > +     data    = kvm->arch.kern_guest_start;
> > +     reg.id  = RISCV_CORE_REG(regs.pc);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
> > +             die_perror("KVM_SET_ONE_REG failed (pc)");
> > +
> > +     data    = vcpu->cpu_id;
> > +     reg.id  = RISCV_CORE_REG(regs.a0);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
> > +             die_perror("KVM_SET_ONE_REG failed (a0)");
> > +
> > +     data    = kvm->arch.dtb_guest_start;
> > +     reg.id  = RISCV_CORE_REG(regs.a1);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
> > +             die_perror("KVM_SET_ONE_REG failed (a1)");
> >  }
> >
> >  int kvm_cpu__get_endianness(struct kvm_cpu *vcpu)
> > @@ -55,10 +160,198 @@ int kvm_cpu__get_endianness(struct kvm_cpu *vcpu)
> >
> >  void kvm_cpu__show_code(struct kvm_cpu *vcpu)
> >  {
> > -     /* TODO: */
> > +     struct kvm_one_reg reg;
> > +     unsigned long data;
> > +     int debug_fd = kvm_cpu__get_debug_fd();
> > +
> > +     reg.addr = (unsigned long)&data;
> > +
> > +     dprintf(debug_fd, "\n*PC:\n");
> > +     reg.id = RISCV_CORE_REG(regs.pc);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (show_code @ PC)");
> > +
> > +     kvm__dump_mem(vcpu->kvm, data, 32, debug_fd);
> > +
> > +     dprintf(debug_fd, "\n*RA:\n");
> > +     reg.id = RISCV_CORE_REG(regs.ra);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (show_code @ RA)");
> > +
> > +     kvm__dump_mem(vcpu->kvm, data, 32, debug_fd);
> >  }
> >
> >  void kvm_cpu__show_registers(struct kvm_cpu *vcpu)
> >  {
> > -     /* TODO: */
> > +     struct kvm_one_reg reg;
> > +     unsigned long data;
> > +     int debug_fd = kvm_cpu__get_debug_fd();
> > +
> > +     reg.addr = (unsigned long)&data;
> > +     dprintf(debug_fd, "\n Registers:\n");
> > +
> > +     reg.id          = RISCV_CORE_REG(mode);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (mode)");
> > +     dprintf(debug_fd, " MODE:  0x%lx\n", data);
> > +
> > +     reg.id          = RISCV_CORE_REG(regs.pc);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (pc)");
> > +     dprintf(debug_fd, " PC:    0x%lx\n", data);
> > +
> > +     reg.id          = RISCV_CORE_REG(regs.ra);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (ra)");
> > +     dprintf(debug_fd, " RA:    0x%lx\n", data);
> > +
> > +     reg.id          = RISCV_CORE_REG(regs.sp);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (sp)");
> > +     dprintf(debug_fd, " SP:    0x%lx\n", data);
> > +
> > +     reg.id          = RISCV_CORE_REG(regs.gp);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (gp)");
> > +     dprintf(debug_fd, " GP:    0x%lx\n", data);
> > +
> > +     reg.id          = RISCV_CORE_REG(regs.tp);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (tp)");
> > +     dprintf(debug_fd, " TP:    0x%lx\n", data);
> > +
> > +     reg.id          = RISCV_CORE_REG(regs.t0);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (t0)");
> > +     dprintf(debug_fd, " T0:    0x%lx\n", data);
> > +
> > +     reg.id          = RISCV_CORE_REG(regs.t1);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (t1)");
> > +     dprintf(debug_fd, " T1:    0x%lx\n", data);
> > +
> > +     reg.id          = RISCV_CORE_REG(regs.t2);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (t2)");
> > +     dprintf(debug_fd, " T2:    0x%lx\n", data);
> > +
> > +     reg.id          = RISCV_CORE_REG(regs.s0);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (s0)");
> > +     dprintf(debug_fd, " S0:    0x%lx\n", data);
> > +
> > +     reg.id          = RISCV_CORE_REG(regs.s1);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (s1)");
> > +     dprintf(debug_fd, " S1:    0x%lx\n", data);
> > +
> > +     reg.id          = RISCV_CORE_REG(regs.a0);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (a0)");
> > +     dprintf(debug_fd, " A0:    0x%lx\n", data);
> > +
> > +     reg.id          = RISCV_CORE_REG(regs.a1);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (a1)");
> > +     dprintf(debug_fd, " A1:    0x%lx\n", data);
> > +
> > +     reg.id          = RISCV_CORE_REG(regs.a2);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (a2)");
> > +     dprintf(debug_fd, " A2:    0x%lx\n", data);
> > +
> > +     reg.id          = RISCV_CORE_REG(regs.a3);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (a3)");
> > +     dprintf(debug_fd, " A3:    0x%lx\n", data);
> > +
> > +     reg.id          = RISCV_CORE_REG(regs.a4);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (a4)");
> > +     dprintf(debug_fd, " A4:    0x%lx\n", data);
> > +
> > +     reg.id          = RISCV_CORE_REG(regs.a5);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (a5)");
> > +     dprintf(debug_fd, " A5:    0x%lx\n", data);
> > +
> > +     reg.id          = RISCV_CORE_REG(regs.a6);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (a6)");
> > +     dprintf(debug_fd, " A6:    0x%lx\n", data);
> > +
> > +     reg.id          = RISCV_CORE_REG(regs.a7);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (a7)");
> > +     dprintf(debug_fd, " A7:    0x%lx\n", data);
> > +
> > +     reg.id          = RISCV_CORE_REG(regs.s2);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (s2)");
> > +     dprintf(debug_fd, " S2:    0x%lx\n", data);
> > +
> > +     reg.id          = RISCV_CORE_REG(regs.s3);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (s3)");
> > +     dprintf(debug_fd, " S3:    0x%lx\n", data);
> > +
> > +     reg.id          = RISCV_CORE_REG(regs.s4);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (s4)");
> > +     dprintf(debug_fd, " S4:    0x%lx\n", data);
> > +
> > +     reg.id          = RISCV_CORE_REG(regs.s5);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (s5)");
> > +     dprintf(debug_fd, " S5:    0x%lx\n", data);
> > +
> > +     reg.id          = RISCV_CORE_REG(regs.s6);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (s6)");
> > +     dprintf(debug_fd, " S6:    0x%lx\n", data);
> > +
> > +     reg.id          = RISCV_CORE_REG(regs.s7);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (s7)");
> > +     dprintf(debug_fd, " S7:    0x%lx\n", data);
> > +
> > +     reg.id          = RISCV_CORE_REG(regs.s8);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (s8)");
> > +     dprintf(debug_fd, " S8:    0x%lx\n", data);
> > +
> > +     reg.id          = RISCV_CORE_REG(regs.s9);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (s9)");
> > +     dprintf(debug_fd, " S9:    0x%lx\n", data);
> > +
> > +     reg.id          = RISCV_CORE_REG(regs.s10);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (s10)");
> > +     dprintf(debug_fd, " S10:   0x%lx\n", data);
> > +
> > +     reg.id          = RISCV_CORE_REG(regs.s11);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (s11)");
> > +     dprintf(debug_fd, " S11:   0x%lx\n", data);
> > +
> > +     reg.id          = RISCV_CORE_REG(regs.t3);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (t3)");
> > +     dprintf(debug_fd, " T3:    0x%lx\n", data);
> > +
> > +     reg.id          = RISCV_CORE_REG(regs.t4);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (t4)");
> > +     dprintf(debug_fd, " T4:    0x%lx\n", data);
> > +
> > +     reg.id          = RISCV_CORE_REG(regs.t5);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (t5)");
> > +     dprintf(debug_fd, " T5:    0x%lx\n", data);
> > +
> > +     reg.id          = RISCV_CORE_REG(regs.t6);
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > +             die("KVM_GET_ONE_REG failed (t6)");
> > +     dprintf(debug_fd, " T6:    0x%lx\n", data);
> >  }

Regards,
Anup
