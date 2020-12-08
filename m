Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5F72D363B
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731447AbgLHW0t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:26:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730538AbgLHW0t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:26:49 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7F3C0613CF
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 14:26:08 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id 2so13846890ilg.9
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 14:26:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nvhw8YEQnOsEM2ufhYf0GgAhv/pW4JqRL5UjftTmw/M=;
        b=Uk/uAhvDfDJ6t8g9F+k+Ym93eLV7KgNWSRxWsITG+//MbDS7Bvjp2gDIWzwvLe8v5i
         D+gsKBUZRuCf3BY3tPSipbj3tu0WkVgH01BM5NuuJWa6Y2m+AG/41las8TjwAbL9kbc6
         rdZmx9kIcDXAJoJ0fsTVQnGaDwnkQMLKMup/fPYFBmCsXoBf+TIEXya4cl6RfD5l28/E
         kb0qPZsBGXfkbaKIdSxCSdCivvcrzVGKnTMXOxKKa2ZPtNG+90VOc1yX8+/Z5VKTnKH3
         /IUehixTPLx5r7i3L22p2hnT3bpQb8tdVx08mD2KINndVwo/XKnfuAcQu30B8rycWVWY
         3cMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nvhw8YEQnOsEM2ufhYf0GgAhv/pW4JqRL5UjftTmw/M=;
        b=NH01ZkFKXcPY7biqHCzq1pi92WssG9psEcFtQY+iUgKT54LYn7l2TI5YtkoB/mjM1n
         2U16srThms5ZDskA3Y5mX/S6YUZDm9xZVWlxcP7gw3/SH+tUJdwLCA3LMtkjmYHEYZ09
         bxFMHTFn3IgfY6wuQ6TRJPM0Xbu0ciFvt0JkLDjenIX1pSGVssgzGqN7mFlyQb6Bq0qe
         t0ll76fhyS2pgH/AxIQGGRy4SRFqbkaCcCwpA7jdgQ4ix93MAKndB4ETHJ8QWVq1jglm
         Tojoe+izzF0JcERi6C+nqTMk1Pz4eXskqZ6RFIZ0/K/nCiJOWjGomOEw9p8RenKV0GJ6
         6/Mw==
X-Gm-Message-State: AOAM532c476bxixYEzqflxU1MTx1IYgUpOsTas5Le4KyGJbiRPdM8BEq
        XpHuH6a5CysEJ6bFd1z9VONRuh2ISe9ke3qQkyE=
X-Google-Smtp-Source: ABdhPJxZ7foBcYZvriR58kHDDcy8oEOtSu1qfXVNDS4FT7lPq7QmetodLQ2vF7NhQaRUyaleZyeYKebiC+4U/shGAHI=
X-Received: by 2002:a92:490d:: with SMTP id w13mr23827ila.227.1607466368027;
 Tue, 08 Dec 2020 14:26:08 -0800 (PST)
MIME-Version: 1.0
References: <20201203124703.168-1-jiangyifei@huawei.com> <20201203124703.168-14-jiangyifei@huawei.com>
In-Reply-To: <20201203124703.168-14-jiangyifei@huawei.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Tue, 8 Dec 2020 14:25:41 -0800
Message-ID: <CAKmqyKM5m3_w6=Jd+EdTatY9G0YBm1mFjh+5FodnVmFfKydyZw@mail.gmail.com>
Subject: Re: [PATCH RFC v4 13/15] target/riscv: Introduce dynamic time
 frequency for virt machine
To:     Yifei Jiang <jiangyifei@huawei.com>
Cc:     "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        "open list:RISC-V" <qemu-riscv@nongnu.org>,
        "Zhangxiaofeng (F)" <victor.zhangxiaofeng@huawei.com>,
        Sagar Karandikar <sagark@eecs.berkeley.edu>,
        "open list:Overall" <kvm@vger.kernel.org>, libvir-list@redhat.com,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Anup Patel <anup.patel@wdc.com>,
        yinyipeng <yinyipeng1@huawei.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        kvm-riscv@lists.infradead.org, Palmer Dabbelt <palmer@dabbelt.com>,
        "dengkai (A)" <dengkai1@huawei.com>,
        "Wubin (H)" <wu.wubin@huawei.com>,
        Zhanghailiang <zhang.zhanghailiang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 3, 2020 at 4:57 AM Yifei Jiang <jiangyifei@huawei.com> wrote:
>
> Currently, time base frequency was fixed as SIFIVE_CLINT_TIMEBASE_FREQ.
> Here introduce "time-frequency" property to set time base frequency dynamically
> of which default value is still SIFIVE_CLINT_TIMEBASE_FREQ. The virt machine
> uses frequency of the first cpu to create clint and fdt.
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Yipeng Yin <yinyipeng1@huawei.com>
> ---
>  hw/riscv/virt.c    | 18 ++++++++++++++----
>  target/riscv/cpu.c |  3 +++
>  target/riscv/cpu.h |  2 ++
>  3 files changed, 19 insertions(+), 4 deletions(-)
>
> diff --git a/hw/riscv/virt.c b/hw/riscv/virt.c
> index 47b7018193..788a7237b6 100644
> --- a/hw/riscv/virt.c
> +++ b/hw/riscv/virt.c
> @@ -178,7 +178,7 @@ static void create_pcie_irq_map(void *fdt, char *nodename,
>  }
>
>  static void create_fdt(RISCVVirtState *s, const struct MemmapEntry *memmap,
> -    uint64_t mem_size, const char *cmdline)
> +    uint64_t mem_size, const char *cmdline, uint64_t timebase_frequency)
>  {
>      void *fdt;
>      int i, cpu, socket;
> @@ -225,7 +225,7 @@ static void create_fdt(RISCVVirtState *s, const struct MemmapEntry *memmap,
>
>      qemu_fdt_add_subnode(fdt, "/cpus");
>      qemu_fdt_setprop_cell(fdt, "/cpus", "timebase-frequency",
> -                          SIFIVE_CLINT_TIMEBASE_FREQ);
> +                          timebase_frequency);
>      qemu_fdt_setprop_cell(fdt, "/cpus", "#size-cells", 0x0);
>      qemu_fdt_setprop_cell(fdt, "/cpus", "#address-cells", 0x1);
>      qemu_fdt_add_subnode(fdt, "/cpus/cpu-map");
> @@ -510,6 +510,7 @@ static void virt_machine_init(MachineState *machine)
>      target_ulong firmware_end_addr, kernel_start_addr;
>      uint32_t fdt_load_addr;
>      uint64_t kernel_entry;
> +    uint64_t timebase_frequency = 0;
>      DeviceState *mmio_plic, *virtio_plic, *pcie_plic;
>      int i, j, base_hartid, hart_count;
>      CPUState *cs;
> @@ -553,12 +554,20 @@ static void virt_machine_init(MachineState *machine)
>                                  hart_count, &error_abort);
>          sysbus_realize(SYS_BUS_DEVICE(&s->soc[i]), &error_abort);
>
> +        if (!timebase_frequency) {
> +            timebase_frequency = RISCV_CPU(first_cpu)->env.frequency;
> +        }
> +        /* If vcpu's time frequency is not specified, we use default frequency */
> +        if (!timebase_frequency) {
> +            timebase_frequency = SIFIVE_CLINT_TIMEBASE_FREQ;
> +        }
> +
>          /* Per-socket CLINT */
>          sifive_clint_create(
>              memmap[VIRT_CLINT].base + i * memmap[VIRT_CLINT].size,
>              memmap[VIRT_CLINT].size, base_hartid, hart_count,
>              SIFIVE_SIP_BASE, SIFIVE_TIMECMP_BASE, SIFIVE_TIME_BASE,
> -            SIFIVE_CLINT_TIMEBASE_FREQ, true);
> +            timebase_frequency, true);
>
>          /* Per-socket PLIC hart topology configuration string */
>          plic_hart_config_len =
> @@ -610,7 +619,8 @@ static void virt_machine_init(MachineState *machine)
>          main_mem);
>
>      /* create device tree */
> -    create_fdt(s, memmap, machine->ram_size, machine->kernel_cmdline);
> +    create_fdt(s, memmap, machine->ram_size, machine->kernel_cmdline,
> +               timebase_frequency);
>
>      /* boot rom */
>      memory_region_init_rom(mask_rom, NULL, "riscv_virt_board.mrom",
> diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
> index 439dc89ee7..66f35bcbbf 100644
> --- a/target/riscv/cpu.c
> +++ b/target/riscv/cpu.c
> @@ -494,6 +494,8 @@ static void riscv_cpu_realize(DeviceState *dev, Error **errp)
>
>      riscv_cpu_register_gdb_regs_for_features(cs);
>
> +    env->user_frequency = env->frequency;
> +
>      qemu_init_vcpu(cs);
>      cpu_reset(cs);
>
> @@ -531,6 +533,7 @@ static Property riscv_cpu_properties[] = {
>      DEFINE_PROP_BOOL("mmu", RISCVCPU, cfg.mmu, true),
>      DEFINE_PROP_BOOL("pmp", RISCVCPU, cfg.pmp, true),
>      DEFINE_PROP_UINT64("resetvec", RISCVCPU, cfg.resetvec, DEFAULT_RSTVEC),
> +    DEFINE_PROP_UINT64("time-frequency", RISCVCPU, env.frequency, 0),

Why not set the default to SIFIVE_CLINT_TIMEBASE_FREQ?

Also, QEMU now has a clock API, is using that instead a better option?

Alistair

>      DEFINE_PROP_END_OF_LIST(),
>  };
>
> diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
> index 16d6050ead..f5b6c34176 100644
> --- a/target/riscv/cpu.h
> +++ b/target/riscv/cpu.h
> @@ -243,6 +243,8 @@ struct CPURISCVState {
>      uint64_t kvm_timer_time;
>      uint64_t kvm_timer_compare;
>      uint64_t kvm_timer_state;
> +    uint64_t user_frequency;
> +    uint64_t frequency;
>  };
>
>  OBJECT_DECLARE_TYPE(RISCVCPU, RISCVCPUClass,
> --
> 2.19.1
>
>
