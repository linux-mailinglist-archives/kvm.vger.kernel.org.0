Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21FE62EB17C
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 18:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730431AbhAERhe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 12:37:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728897AbhAERhe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 12:37:34 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3EB0C061574
        for <kvm@vger.kernel.org>; Tue,  5 Jan 2021 09:36:53 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id r17so400910ilo.11
        for <kvm@vger.kernel.org>; Tue, 05 Jan 2021 09:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iYUbdn46eLLJUQGutNwUga7LivqPsgBrhoaqA3UjSMc=;
        b=C7rW8Vdc6213/7dex6sGc3MF9LPSadvWCiBhsLWUZ0baN3pEYGmG0dPeWinzaKYMhm
         L4eaM6Kl79/+NkB/wI7Iv4LyIVGubn5OA8mRSKHP+cSvQRG3rxNC4T7AC6xQJ9bUblKv
         w5fLP1TQLV8vPRwCGDs4kWL6ma2xbosoaEN0nDA9S984ub5ajvNXw4eGbYo0MZuL2Gn9
         CpzZVqWT4gkvY8VTA7QX8aFARGlJXfmadxv3ZgSgWwbr6lDTYn6IyfaGZ8kOXpHX793y
         3CLUh/0bul/6nF3nBaWeoHsPsNez0AP8tRiqgdYKrrSoIzE1GtHG2pZkXBGQU0D8337D
         kzZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iYUbdn46eLLJUQGutNwUga7LivqPsgBrhoaqA3UjSMc=;
        b=iTanb2Bn6YZgLW9VbWi/WvmqSTJ53YYvoi5B6hzAgU0lXk1tkPmrv+1enaRdmtKXLD
         3oCPEbVIEFbREvFKCMC/pm2nW851PiUxS5nVmxCbYIFXA2YX//aO649Rkz2ttw6f2P6k
         ECcM5QpGsOUqwSjH6TdMXRNTYIcpV+g79UTCTg8oxMkVVsyrbSk8rzeFCoFXH1uVA+E6
         AOs7jXmfBvgT+PnQIHcGdJFnwaC7Q4MrCRziiXO0reFLV9O3K8U4tZ04A2lIvt1PtSQS
         A6iTozLlPLcZGtI9MLxX+mMp/9r7QR50Ye82bFNJT2BK4BEjaF06xOp2awG/QAiK5ShN
         lCvQ==
X-Gm-Message-State: AOAM531E9IsVloszY0nEhgHKr+68ZXCIDqs74AMQpE6X9HHToRKhQlbK
        aOEZYdjiG8Izdz9HF5ssqbA61phEHbt5NBt1dec=
X-Google-Smtp-Source: ABdhPJyqlVfZpAO6yv6nGmppmW7gpKPg65l4Vu1XOlAeCnxF0P7r3nwdAcmxzlnVeenovVNhgkvSpmqhcmiuN6qc2kU=
X-Received: by 2002:a92:c942:: with SMTP id i2mr650901ilq.227.1609868212964;
 Tue, 05 Jan 2021 09:36:52 -0800 (PST)
MIME-Version: 1.0
References: <20201203124703.168-1-jiangyifei@huawei.com> <20201203124703.168-14-jiangyifei@huawei.com>
 <CAKmqyKM5m3_w6=Jd+EdTatY9G0YBm1mFjh+5FodnVmFfKydyZw@mail.gmail.com> <1889871dcdf74ac3b495d75e6fd2aeaf@huawei.com>
In-Reply-To: <1889871dcdf74ac3b495d75e6fd2aeaf@huawei.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Tue, 5 Jan 2021 09:36:25 -0800
Message-ID: <CAKmqyKMg+cmLm6fBN23KCoVajgbY-3YRF3K=m4HaHOoehckGHA@mail.gmail.com>
Subject: Re: [PATCH RFC v4 13/15] target/riscv: Introduce dynamic time
 frequency for virt machine
To:     Jiangyifei <jiangyifei@huawei.com>
Cc:     "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        "open list:RISC-V" <qemu-riscv@nongnu.org>,
        "Zhangxiaofeng (F)" <victor.zhangxiaofeng@huawei.com>,
        Sagar Karandikar <sagark@eecs.berkeley.edu>,
        "open list:Overall" <kvm@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Anup Patel <anup.patel@wdc.com>,
        yinyipeng <yinyipeng1@huawei.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        "dengkai (A)" <dengkai1@huawei.com>,
        "Wubin (H)" <wu.wubin@huawei.com>,
        Zhanghailiang <zhang.zhanghailiang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 14, 2020 at 11:31 PM Jiangyifei <jiangyifei@huawei.com> wrote:
>
>
> > -----Original Message-----
> > From: Alistair Francis [mailto:alistair23@gmail.com]
> > Sent: Wednesday, December 9, 2020 6:26 AM
> > To: Jiangyifei <jiangyifei@huawei.com>
> > Cc: qemu-devel@nongnu.org Developers <qemu-devel@nongnu.org>; open
> > list:RISC-V <qemu-riscv@nongnu.org>; Zhangxiaofeng (F)
> > <victor.zhangxiaofeng@huawei.com>; Sagar Karandikar
> > <sagark@eecs.berkeley.edu>; open list:Overall <kvm@vger.kernel.org>;
> > libvir-list@redhat.com; Bastian Koppelmann
> > <kbastian@mail.uni-paderborn.de>; Anup Patel <anup.patel@wdc.com>;
> > yinyipeng <yinyipeng1@huawei.com>; Alistair Francis
> > <Alistair.Francis@wdc.com>; kvm-riscv@lists.infradead.org; Palmer Dabbelt
> > <palmer@dabbelt.com>; dengkai (A) <dengkai1@huawei.com>; Wubin (H)
> > <wu.wubin@huawei.com>; Zhanghailiang <zhang.zhanghailiang@huawei.com>
> > Subject: Re: [PATCH RFC v4 13/15] target/riscv: Introduce dynamic time
> > frequency for virt machine
> >
> > On Thu, Dec 3, 2020 at 4:57 AM Yifei Jiang <jiangyifei@huawei.com> wrote:
> > >
> > > Currently, time base frequency was fixed as SIFIVE_CLINT_TIMEBASE_FREQ.
> > > Here introduce "time-frequency" property to set time base frequency
> > > dynamically of which default value is still
> > > SIFIVE_CLINT_TIMEBASE_FREQ. The virt machine uses frequency of the first
> > cpu to create clint and fdt.
> > >
> > > Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> > > Signed-off-by: Yipeng Yin <yinyipeng1@huawei.com>
> > > ---
> > >  hw/riscv/virt.c    | 18 ++++++++++++++----
> > >  target/riscv/cpu.c |  3 +++
> > >  target/riscv/cpu.h |  2 ++
> > >  3 files changed, 19 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/hw/riscv/virt.c b/hw/riscv/virt.c index
> > > 47b7018193..788a7237b6 100644
> > > --- a/hw/riscv/virt.c
> > > +++ b/hw/riscv/virt.c
> > > @@ -178,7 +178,7 @@ static void create_pcie_irq_map(void *fdt, char
> > > *nodename,  }
> > >
> > >  static void create_fdt(RISCVVirtState *s, const struct MemmapEntry
> > *memmap,
> > > -    uint64_t mem_size, const char *cmdline)
> > > +    uint64_t mem_size, const char *cmdline, uint64_t
> > > + timebase_frequency)
> > >  {
> > >      void *fdt;
> > >      int i, cpu, socket;
> > > @@ -225,7 +225,7 @@ static void create_fdt(RISCVVirtState *s, const
> > > struct MemmapEntry *memmap,
> > >
> > >      qemu_fdt_add_subnode(fdt, "/cpus");
> > >      qemu_fdt_setprop_cell(fdt, "/cpus", "timebase-frequency",
> > > -                          SIFIVE_CLINT_TIMEBASE_FREQ);
> > > +                          timebase_frequency);
> > >      qemu_fdt_setprop_cell(fdt, "/cpus", "#size-cells", 0x0);
> > >      qemu_fdt_setprop_cell(fdt, "/cpus", "#address-cells", 0x1);
> > >      qemu_fdt_add_subnode(fdt, "/cpus/cpu-map"); @@ -510,6 +510,7
> > @@
> > > static void virt_machine_init(MachineState *machine)
> > >      target_ulong firmware_end_addr, kernel_start_addr;
> > >      uint32_t fdt_load_addr;
> > >      uint64_t kernel_entry;
> > > +    uint64_t timebase_frequency = 0;
> > >      DeviceState *mmio_plic, *virtio_plic, *pcie_plic;
> > >      int i, j, base_hartid, hart_count;
> > >      CPUState *cs;
> > > @@ -553,12 +554,20 @@ static void virt_machine_init(MachineState
> > *machine)
> > >                                  hart_count, &error_abort);
> > >          sysbus_realize(SYS_BUS_DEVICE(&s->soc[i]), &error_abort);
> > >
> > > +        if (!timebase_frequency) {
> > > +            timebase_frequency = RISCV_CPU(first_cpu)->env.frequency;
> > > +        }
> > > +        /* If vcpu's time frequency is not specified, we use default
> > frequency */
> > > +        if (!timebase_frequency) {
> > > +            timebase_frequency = SIFIVE_CLINT_TIMEBASE_FREQ;
> > > +        }
> > > +
> > >          /* Per-socket CLINT */
> > >          sifive_clint_create(
> > >              memmap[VIRT_CLINT].base + i *
> > memmap[VIRT_CLINT].size,
> > >              memmap[VIRT_CLINT].size, base_hartid, hart_count,
> > >              SIFIVE_SIP_BASE, SIFIVE_TIMECMP_BASE,
> > SIFIVE_TIME_BASE,
> > > -            SIFIVE_CLINT_TIMEBASE_FREQ, true);
> > > +            timebase_frequency, true);
> > >
> > >          /* Per-socket PLIC hart topology configuration string */
> > >          plic_hart_config_len =
> > > @@ -610,7 +619,8 @@ static void virt_machine_init(MachineState
> > *machine)
> > >          main_mem);
> > >
> > >      /* create device tree */
> > > -    create_fdt(s, memmap, machine->ram_size,
> > machine->kernel_cmdline);
> > > +    create_fdt(s, memmap, machine->ram_size,
> > machine->kernel_cmdline,
> > > +               timebase_frequency);
> > >
> > >      /* boot rom */
> > >      memory_region_init_rom(mask_rom, NULL, "riscv_virt_board.mrom",
> > > diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c index
> > > 439dc89ee7..66f35bcbbf 100644
> > > --- a/target/riscv/cpu.c
> > > +++ b/target/riscv/cpu.c
> > > @@ -494,6 +494,8 @@ static void riscv_cpu_realize(DeviceState *dev,
> > > Error **errp)
> > >
> > >      riscv_cpu_register_gdb_regs_for_features(cs);
> > >
> > > +    env->user_frequency = env->frequency;
> > > +
> > >      qemu_init_vcpu(cs);
> > >      cpu_reset(cs);
> > >
> > > @@ -531,6 +533,7 @@ static Property riscv_cpu_properties[] = {
> > >      DEFINE_PROP_BOOL("mmu", RISCVCPU, cfg.mmu, true),
> > >      DEFINE_PROP_BOOL("pmp", RISCVCPU, cfg.pmp, true),
> > >      DEFINE_PROP_UINT64("resetvec", RISCVCPU, cfg.resetvec,
> > > DEFAULT_RSTVEC),
> > > +    DEFINE_PROP_UINT64("time-frequency", RISCVCPU, env.frequency, 0),
> >
> > Why not set the default to SIFIVE_CLINT_TIMEBASE_FREQ?
> >
>
> When the time frequency is not specified, it will follow the host or the migration
> source. And we define 0 as equivalent to not specified time frequency.
>
> > Also, QEMU now has a clock API, is using that instead a better option?
> >
>
> Sorry, I didn't find the clock API. Could you tell me what the API is.
> I think that the time frequency is option of KVM VCPU. So it is appropriate to put this
> option in the CPU.

The clock API is documented here:
https://gitlab.com/qemu-project/qemu/-/blob/master/docs/devel/clocks.rst

I'm not sure if it applies to KVM, but it is at least worth considering.

Alistair

>
> Yifei
>
> > Alistair
> >
> > >      DEFINE_PROP_END_OF_LIST(),
> > >  };
> > >
> > > diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h index
> > > 16d6050ead..f5b6c34176 100644
> > > --- a/target/riscv/cpu.h
> > > +++ b/target/riscv/cpu.h
> > > @@ -243,6 +243,8 @@ struct CPURISCVState {
> > >      uint64_t kvm_timer_time;
> > >      uint64_t kvm_timer_compare;
> > >      uint64_t kvm_timer_state;
> > > +    uint64_t user_frequency;
> > > +    uint64_t frequency;
> > >  };
> > >
> > >  OBJECT_DECLARE_TYPE(RISCVCPU, RISCVCPUClass,
> > > --
> > > 2.19.1
> > >
> > >
