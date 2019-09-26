Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40678BEBFE
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 08:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392943AbfIZGeS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 02:34:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48506 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388934AbfIZGeR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 02:34:17 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AF0F54E919
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 06:34:16 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id f63so570413wma.7
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 23:34:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=TjThmoOCifZU3qjSQLBWFrKS0UKFSeYXDIZRv/qrZbs=;
        b=RrxiOiQPheayWTSzfMMztLa0QYLsdPUa4H/Tlg7OkgyYTiStUcbTYKf0RECwP1XuXV
         hHNpwyDuDVP4IIUlFOMvUAvfz+cqIJ4cZNNUU9n5VaBHPpIciEsA29q9dRk2Zcrw1/C9
         P+fGSnUAlmgVyDxgt3QWVb/QJf5hpJgkmOjJwP+VW597ziXmvZ3lBOoA0rusROtJlLod
         zyHgOrXBAiudtxAJGJLx6Q0ebTgGG8+/Q51GCVIqbwcHn8SHjWartw2jpdN2SrQ7QcZk
         Y3zsskDF2wccKB0mGPhFiGjD5KtzACdfVc5PBmZTQLsYIZStFvJi3qbAQMctnHqpMvLY
         GLvA==
X-Gm-Message-State: APjAAAXG5dkx45c0P6nkWZf7ed5HCFLkJjEGAlnPKAC3apKwvPEizqOh
        7oeaAWunSh7u+gP8xmG1TS3LNC7ORQ9q4Bh0AMSkvL8nXHZ7Ypw5npBEx3qXQGLL/7KatwA6H7g
        CKTpY3lBnUO7Y
X-Received: by 2002:adf:e908:: with SMTP id f8mr1463412wrm.210.1569479654482;
        Wed, 25 Sep 2019 23:34:14 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxPlmmaMuenRXqK1ncfnTKlhU0M3yCPEaMChd77smaEu2Aox4R2P4S4lCw6pcCnUAQcOs1pAQ==
X-Received: by 2002:adf:e908:: with SMTP id f8mr1463380wrm.210.1569479654050;
        Wed, 25 Sep 2019 23:34:14 -0700 (PDT)
Received: from dritchie.redhat.com (139.red-95-120-215.dynamicip.rima-tde.net. [95.120.215.139])
        by smtp.gmail.com with ESMTPSA id s12sm2341442wrn.90.2019.09.25.23.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 23:34:13 -0700 (PDT)
References: <20190924124433.96810-1-slp@redhat.com> <20190924124433.96810-9-slp@redhat.com> <061b720c-2ef2-b270-f18b-b0619573862d@redhat.com>
User-agent: mu4e 1.2.0; emacs 26.2
From:   Sergio Lopez <slp@redhat.com>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        marcel.apfelbaum@gmail.com, pbonzini@redhat.com, rth@twiddle.net,
        ehabkost@redhat.com, lersek@redhat.com, kraxel@redhat.com,
        mtosatti@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v4 8/8] hw/i386: Introduce the microvm machine type
In-reply-to: <061b720c-2ef2-b270-f18b-b0619573862d@redhat.com>
Date:   Thu, 26 Sep 2019 08:34:10 +0200
Message-ID: <87muer36sd.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com> writes:

> On 9/24/19 2:44 PM, Sergio Lopez wrote:
>> Microvm is a machine type inspired by both NEMU and Firecracker, and
>> constructed after the machine model implemented by the latter.
>>=20
>> It's main purpose is providing users a minimalist machine type free
>> from the burden of legacy compatibility, serving as a stepping stone
>> for future projects aiming at improving boot times, reducing the
>> attack surface and slimming down QEMU's footprint.
>>=20
>> The microvm machine type supports the following devices:
>>=20
>>  - ISA bus
>>  - i8259 PIC
>>  - LAPIC (implicit if using KVM)
>>  - IOAPIC (defaults to kernel_irqchip_split =3D true)
>>  - i8254 PIT
>>  - MC146818 RTC (optional)
>>  - kvmclock (if using KVM)
>>  - fw_cfg
>>  - One ISA serial port (optional)
>>  - Up to eight virtio-mmio devices (configured by the user)
>>=20
>> It supports the following machine-specific options:
>>=20
>> microvm.option-roms=3Dbool (Set off to disable loading option ROMs)
>> microvm.isa-serial=3Dbool (Set off to disable the instantiation an ISA s=
erial port)
>> microvm.rtc=3Dbool (Set off to disable the instantiation of an MC146818 =
RTC)
>> microvm.kernel-cmdline=3Dbool (Set off to disable adding virtio-mmio dev=
ices to the kernel cmdline)
>>=20
>> By default, microvm uses qboot as its BIOS, to obtain better boot
>> times, but it's also compatible with SeaBIOS.
>>=20
>> As no current FW is able to boot from a block device using virtio-mmio
>> as its transport, a microvm-based VM needs to be run using a host-side
>> kernel and, optionally, an initrd image.
>>=20
>> This is an example of instantiating a microvm VM with a virtio-mmio
>> based console:
>>=20
>> qemu-system-x86_64 -M microvm
>>  -enable-kvm -cpu host -m 512m -smp 2 \
>>  -kernel vmlinux -append "console=3Dhvc0 root=3D/dev/vda" \
>>  -nodefaults -no-user-config -nographic \
>>  -chardev stdio,id=3Dvirtiocon0,server \
>>  -device virtio-serial-device \
>>  -device virtconsole,chardev=3Dvirtiocon0 \
>>  -drive id=3Dtest,file=3Dtest.img,format=3Draw,if=3Dnone \
>>  -device virtio-blk-device,drive=3Dtest \
>>  -netdev tap,id=3Dtap0,script=3Dno,downscript=3Dno \
>>  -device virtio-net-device,netdev=3Dtap0
>>=20
>> This is another example, this time using an ISA serial port, useful
>> for debugging purposes:
>>=20
>> qemu-system-x86_64 -M microvm \
>>  -enable-kvm -cpu host -m 512m -smp 2 \
>>  -kernel vmlinux -append "earlyprintk=3DttyS0 console=3DttyS0 root=3D/de=
v/vda" \
>>  -nodefaults -no-user-config -nographic \
>>  -serial stdio \
>>  -drive id=3Dtest,file=3Dtest.img,format=3Draw,if=3Dnone \
>>  -device virtio-blk-device,drive=3Dtest \
>>  -netdev tap,id=3Dtap0,script=3Dno,downscript=3Dno \
>>  -device virtio-net-device,netdev=3Dtap0
>>=20
>> Finally, in this example a microvm VM is instantiated without RTC,
>> without an ISA serial port and without loading the option ROMs,
>> obtaining the smallest configuration:
>>=20
>> qemu-system-x86_64 -M microvm,rtc=3Doff,isa-serial=3Doff,option-roms=3Do=
ff \
>>  -enable-kvm -cpu host -m 512m -smp 2 \
>>  -kernel vmlinux -append "console=3Dhvc0 root=3D/dev/vda" \
>>  -nodefaults -no-user-config -nographic \
>>  -chardev stdio,id=3Dvirtiocon0,server \
>>  -device virtio-serial-device \
>>  -device virtconsole,chardev=3Dvirtiocon0 \
>>  -drive id=3Dtest,file=3Dtest.img,format=3Draw,if=3Dnone \
>>  -device virtio-blk-device,drive=3Dtest \
>>  -netdev tap,id=3Dtap0,script=3Dno,downscript=3Dno \
>>  -device virtio-net-device,netdev=3Dtap0
>>=20
>> Signed-off-by: Sergio Lopez <slp@redhat.com>
>> ---
>>  default-configs/i386-softmmu.mak |   1 +
>>  hw/i386/Kconfig                  |   4 +
>>  hw/i386/Makefile.objs            |   1 +
>>  hw/i386/microvm.c                | 512 +++++++++++++++++++++++++++++++
>>  include/hw/i386/microvm.h        |  80 +++++
>>  5 files changed, 598 insertions(+)
>>  create mode 100644 hw/i386/microvm.c
>>  create mode 100644 include/hw/i386/microvm.h
>>=20
>> diff --git a/default-configs/i386-softmmu.mak b/default-configs/i386-sof=
tmmu.mak
>> index cd5ea391e8..c27cdd98e9 100644
>> --- a/default-configs/i386-softmmu.mak
>> +++ b/default-configs/i386-softmmu.mak
>> @@ -26,3 +26,4 @@ CONFIG_ISAPC=3Dy
>>  CONFIG_I440FX=3Dy
>>  CONFIG_Q35=3Dy
>>  CONFIG_ACPI_PCI=3Dy
>> +CONFIG_MICROVM=3Dy
>> \ No newline at end of file
>> diff --git a/hw/i386/Kconfig b/hw/i386/Kconfig
>> index 6350438036..324e193dd8 100644
>> --- a/hw/i386/Kconfig
>> +++ b/hw/i386/Kconfig
>> @@ -88,6 +88,10 @@ config Q35
>>      select SMBIOS
>>      select FW_CFG_DMA
>>=20=20
>> +config MICROVM
>> +    bool
>> +    select VIRTIO_MMIO
>> +
>>  config VTD
>>      bool
>>=20=20
>> diff --git a/hw/i386/Makefile.objs b/hw/i386/Makefile.objs
>> index 5b4b3a672e..bb17d54567 100644
>> --- a/hw/i386/Makefile.objs
>> +++ b/hw/i386/Makefile.objs
>> @@ -6,6 +6,7 @@ obj-y +=3D pc.o
>>  obj-y +=3D e820.o
>>  obj-$(CONFIG_I440FX) +=3D pc_piix.o
>>  obj-$(CONFIG_Q35) +=3D pc_q35.o
>> +obj-$(CONFIG_MICROVM) +=3D microvm.o
>>  obj-y +=3D fw_cfg.o pc_sysfw.o
>>  obj-y +=3D x86-iommu.o
>>  obj-$(CONFIG_VTD) +=3D intel_iommu.o
>> diff --git a/hw/i386/microvm.c b/hw/i386/microvm.c
>> new file mode 100644
>> index 0000000000..4b494a1b27
>> --- /dev/null
>> +++ b/hw/i386/microvm.c
>> @@ -0,0 +1,512 @@
>> +/*
>> + * Copyright (c) 2018 Intel Corporation
>> + * Copyright (c) 2019 Red Hat, Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or modify=
 it
>> + * under the terms and conditions of the GNU General Public License,
>> + * version 2 or later, as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope it will be useful, but WITHO=
UT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public Licens=
e for
>> + * more details.
>> + *
>> + * You should have received a copy of the GNU General Public License al=
ong with
>> + * this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#include "qemu/osdep.h"
>> +#include "qemu/error-report.h"
>> +#include "qemu/cutils.h"
>> +#include "qemu/units.h"
>> +#include "qapi/error.h"
>> +#include "qapi/visitor.h"
>> +#include "sysemu/sysemu.h"
>> +#include "sysemu/cpus.h"
>> +#include "sysemu/numa.h"
>> +#include "sysemu/reset.h"
>> +
>> +#include "hw/loader.h"
>> +#include "hw/irq.h"
>> +#include "hw/nmi.h"
>> +#include "hw/kvm/clock.h"
>> +#include "hw/i386/microvm.h"
>> +#include "hw/i386/x86.h"
>> +#include "hw/i386/pc.h"
>> +#include "target/i386/cpu.h"
>> +#include "hw/timer/i8254.h"
>> +#include "hw/timer/mc146818rtc.h"
>> +#include "hw/char/serial.h"
>> +#include "hw/i386/topology.h"
>> +#include "hw/i386/e820.h"
>> +#include "hw/i386/fw_cfg.h"
>> +#include "hw/virtio/virtio-mmio.h"
>> +
>> +#include "cpu.h"
>> +#include "elf.h"
>> +#include "pvh.h"
>> +#include "kvm_i386.h"
>> +#include "hw/xen/start_info.h"
>> +
>> +#define MICROVM_BIOS_FILENAME "bios-microvm.bin"
>> +
>> +static void microvm_set_rtc(MicrovmMachineState *mms, ISADevice *s)
>> +{
>> +    X86MachineState *x86ms =3D X86_MACHINE(mms);
>> +    int val;
>> +
>> +    val =3D MIN(x86ms->below_4g_mem_size / KiB, 640);
>> +    rtc_set_memory(s, 0x15, val);
>> +    rtc_set_memory(s, 0x16, val >> 8);
>> +    /* extended memory (next 64MiB) */
>> +    if (x86ms->below_4g_mem_size > 1 * MiB) {
>> +        val =3D (x86ms->below_4g_mem_size - 1 * MiB) / KiB;
>> +    } else {
>> +        val =3D 0;
>> +    }
>> +    if (val > 65535) {
>> +        val =3D 65535;
>> +    }
>> +    rtc_set_memory(s, 0x17, val);
>> +    rtc_set_memory(s, 0x18, val >> 8);
>> +    rtc_set_memory(s, 0x30, val);
>> +    rtc_set_memory(s, 0x31, val >> 8);
>> +    /* memory between 16MiB and 4GiB */
>> +    if (x86ms->below_4g_mem_size > 16 * MiB) {
>> +        val =3D (x86ms->below_4g_mem_size - 16 * MiB) / (64 * KiB);
>> +    } else {
>> +        val =3D 0;
>> +    }
>> +    if (val > 65535) {
>> +        val =3D 65535;
>> +    }
>> +    rtc_set_memory(s, 0x34, val);
>> +    rtc_set_memory(s, 0x35, val >> 8);
>> +    /* memory above 4GiB */
>> +    val =3D x86ms->above_4g_mem_size / 65536;
>> +    rtc_set_memory(s, 0x5b, val);
>> +    rtc_set_memory(s, 0x5c, val >> 8);
>> +    rtc_set_memory(s, 0x5d, val >> 16);
>> +}
>> +
>> +static void microvm_devices_init(MicrovmMachineState *mms)
>> +{
>> +    X86MachineState *x86ms =3D X86_MACHINE(mms);
>> +    ISABus *isa_bus;
>> +    ISADevice *rtc_state;
>> +    GSIState *gsi_state;
>> +    qemu_irq *i8259;
>> +    int i;
>> +
>> +    gsi_state =3D g_malloc0(sizeof(*gsi_state));
>> +    x86ms->gsi =3D qemu_allocate_irqs(gsi_handler, gsi_state, GSI_NUM_P=
INS);
>> +
>> +    isa_bus =3D isa_bus_new(NULL, get_system_memory(), get_system_io(),
>> +                          &error_abort);
>> +    isa_bus_irqs(isa_bus, x86ms->gsi);
>> +
>> +    i8259 =3D i8259_init(isa_bus, pc_allocate_cpu_irq());
>> +
>> +    for (i =3D 0; i < ISA_NUM_IRQS; i++) {
>> +        gsi_state->i8259_irq[i] =3D i8259[i];
>> +    }
>> +
>> +    ioapic_init_gsi(gsi_state, "machine");
>> +
>> +    if (mms->rtc_enabled) {
>> +        rtc_state =3D mc146818_rtc_init(isa_bus, 2000, NULL);
>> +        microvm_set_rtc(mms, rtc_state);
>> +    }
>> +
>
> Maybe refactor that ...
>
>> +    if (kvm_pit_in_kernel()) {
>> +        kvm_pit_init(isa_bus, 0x40);
>> +    } else {
>> +        i8254_pit_init(isa_bus, 0x40, 0, NULL);
>> +    }
>
> ... as a x86_pit_create() function?

This is deemed to change in v5, as we want to avoid the legacy PIC+PIT
when possible.

>> +
>> +    kvmclock_create();
>> +
>> +    for (i =3D 0; i < VIRTIO_NUM_TRANSPORTS; i++) {
>> +        int nirq =3D VIRTIO_IRQ_BASE + i;
>> +        ISADevice *isadev =3D isa_create(isa_bus, TYPE_ISA_SERIAL);
>> +        qemu_irq mmio_irq;
>> +
>> +        isa_init_irq(isadev, &mmio_irq, nirq);
>> +        sysbus_create_simple("virtio-mmio",
>> +                             VIRTIO_MMIO_BASE + i * 512,
>> +                             x86ms->gsi[VIRTIO_IRQ_BASE + i]);
>> +    }
>> +
>> +    g_free(i8259);
>
> Not related to this patch, but i8259_init() API is not clear,
> it returns an allocated array of allocated qemu_irqs? Is it safe to copy
> them to gsi_state then free the array?

That's how I understand it, and also how it's used elsewhere.

>> +
>> +    if (mms->isa_serial_enabled) {
>> +        serial_hds_isa_init(isa_bus, 0, 1);
>> +    }
>> +
>> +    if (bios_name =3D=3D NULL) {
>> +        bios_name =3D MICROVM_BIOS_FILENAME;
>> +    }
>> +    x86_system_rom_init(get_system_memory(), true);
>> +}
>> +
>> +static void microvm_memory_init(MicrovmMachineState *mms)
>> +{
>> +    MachineState *machine =3D MACHINE(mms);
>> +    X86MachineState *x86ms =3D X86_MACHINE(mms);
>> +    MemoryRegion *ram, *ram_below_4g, *ram_above_4g;
>> +    MemoryRegion *system_memory =3D get_system_memory();
>> +    FWCfgState *fw_cfg;
>> +    ram_addr_t lowmem;
>> +    int i;
>> +
>> +    /*
>> +     * Check whether RAM fits below 4G (leaving 1/2 GByte for IO memory
>> +     * and 256 Mbytes for PCI Express Enhanced Configuration Access Map=
ping
>> +     * also known as MMCFG).
>> +     * If it doesn't, we need to split it in chunks below and above 4G.
>> +     * In any case, try to make sure that guest addresses aligned at
>> +     * 1G boundaries get mapped to host addresses aligned at 1G boundar=
ies.
>> +     */
>> +    if (machine->ram_size >=3D 0xb0000000) {
>> +        lowmem =3D 0x80000000;
>> +    } else {
>> +        lowmem =3D 0xb0000000;
>> +    }
>> +
>> +    /*
>> +     * Handle the machine opt max-ram-below-4g.  It is basically doing
>> +     * min(qemu limit, user limit).
>> +     */
>> +    if (!x86ms->max_ram_below_4g) {
>> +        x86ms->max_ram_below_4g =3D 1ULL << 32; /* default: 4G */
>
> Please use '4 * GiB' with no comment.

Ack (this is copypaste from pc_q35.c).

>> +    }
>> +    if (lowmem > x86ms->max_ram_below_4g) {
>> +        lowmem =3D x86ms->max_ram_below_4g;
>> +        if (machine->ram_size - lowmem > lowmem &&
>> +            lowmem & (1 * GiB - 1)) {
>> +            warn_report("There is possibly poor performance as the ram =
size "
>> +                        " (0x%" PRIx64 ") is more then twice the size o=
f"
>> +                        " max-ram-below-4g (%"PRIu64") and"
>> +                        " max-ram-below-4g is not a multiple of 1G.",
>> +                        (uint64_t)machine->ram_size, x86ms->max_ram_bel=
ow_4g);
>> +        }
>> +    }
>> +
>> +    if (machine->ram_size > lowmem) {
>> +        x86ms->above_4g_mem_size =3D machine->ram_size - lowmem;
>> +        x86ms->below_4g_mem_size =3D lowmem;
>> +    } else {
>> +        x86ms->above_4g_mem_size =3D 0;
>> +        x86ms->below_4g_mem_size =3D machine->ram_size;
>> +    }
>> +
>> +    ram =3D g_malloc(sizeof(*ram));
>> +    memory_region_allocate_system_memory(ram, NULL, "microvm.ram",
>> +                                         machine->ram_size);
>> +
>> +    ram_below_4g =3D g_malloc(sizeof(*ram_below_4g));
>> +    memory_region_init_alias(ram_below_4g, NULL, "ram-below-4g", ram,
>> +                             0, x86ms->below_4g_mem_size);
>> +    memory_region_add_subregion(system_memory, 0, ram_below_4g);
>> +
>> +    e820_add_entry(0, x86ms->below_4g_mem_size, E820_RAM);
>> +
>> +    if (x86ms->above_4g_mem_size > 0) {
>> +        ram_above_4g =3D g_malloc(sizeof(*ram_above_4g));
>> +        memory_region_init_alias(ram_above_4g, NULL, "ram-above-4g", ra=
m,
>> +                                 x86ms->below_4g_mem_size,
>> +                                 x86ms->above_4g_mem_size);
>> +        memory_region_add_subregion(system_memory, 0x100000000ULL,
>> +                                    ram_above_4g);
>> +        e820_add_entry(0x100000000ULL, x86ms->above_4g_mem_size, E820_R=
AM);
>> +    }
>> +
>> +    fw_cfg =3D fw_cfg_init_io_dma(FW_CFG_IO_BASE, FW_CFG_IO_BASE + 4,
>> +                                &address_space_memory);
>> +
>> +    fw_cfg_add_i16(fw_cfg, FW_CFG_NB_CPUS, x86ms->boot_cpus);
>> +    fw_cfg_add_i16(fw_cfg, FW_CFG_MAX_CPUS, (uint16_t)x86ms->apic_id_li=
mit);
>> +    fw_cfg_add_i64(fw_cfg, FW_CFG_RAM_SIZE, (uint64_t)machine->ram_size=
);
>> +    fw_cfg_add_i32(fw_cfg, FW_CFG_IRQ0_OVERRIDE, kvm_allows_irq0_overri=
de());
>> +
>> +    rom_set_fw(fw_cfg);
>> +
>> +    e820_create_fw_entry(fw_cfg);
>> +
>> +    load_linux(x86ms, fw_cfg, 0, true, true);
>> +
>> +    if (mms->option_roms_enabled) {
>> +        for (i =3D 0; i < nb_option_roms; i++) {
>> +            rom_add_option(option_rom[i].name, option_rom[i].bootindex);
>> +        }
>> +    }
>> +
>> +    x86ms->fw_cfg =3D fw_cfg;
>> +    x86ms->ioapic_as =3D &address_space_memory;
>> +}
>> +
>> +static gchar *microvm_get_mmio_cmdline(gchar *name)
>> +{
>> +    gchar *cmdline;
>> +    gchar *separator;
>> +    long int index;
>> +    int ret;
>> +
>> +    separator =3D g_strrstr(name, ".");
>> +    if (!separator) {
>> +        return NULL;
>> +    }
>> +
>> +    if (qemu_strtol(separator + 1, NULL, 10, &index) !=3D 0) {
>> +        return NULL;
>> +    }
>> +
>> +    cmdline =3D g_malloc0(VIRTIO_CMDLINE_MAXLEN);
>> +    ret =3D g_snprintf(cmdline, VIRTIO_CMDLINE_MAXLEN,
>> +                     " virtio_mmio.device=3D512@0x%lx:%ld",
>> +                     VIRTIO_MMIO_BASE + index * 512,
>> +                     VIRTIO_IRQ_BASE + index);
>> +    if (ret < 0 || ret >=3D VIRTIO_CMDLINE_MAXLEN) {
>> +        g_free(cmdline);
>> +        return NULL;
>> +    }
>> +
>> +    return cmdline;
>> +}
>> +
>> +static void microvm_fix_kernel_cmdline(MachineState *machine)
>> +{
>> +    X86MachineState *x86ms =3D X86_MACHINE(machine);
>> +    BusState *bus;
>> +    BusChild *kid;
>> +    char *cmdline;
>> +
>> +    /*
>> +     * Find MMIO transports with attached devices, and add them to the =
kernel
>> +     * command line.
>> +     *
>> +     * Yes, this is a hack, but one that heavily improves the UX without
>> +     * introducing any significant issues.
>> +     */
>> +    cmdline =3D g_strdup(machine->kernel_cmdline);
>> +    bus =3D sysbus_get_default();
>> +    QTAILQ_FOREACH(kid, &bus->children, sibling) {
>> +        DeviceState *dev =3D kid->child;
>> +        ObjectClass *class =3D object_get_class(OBJECT(dev));
>> +
>> +        if (class =3D=3D object_class_by_name(TYPE_VIRTIO_MMIO)) {
>> +            VirtIOMMIOProxy *mmio =3D VIRTIO_MMIO(OBJECT(dev));
>> +            VirtioBusState *mmio_virtio_bus =3D &mmio->bus;
>> +            BusState *mmio_bus =3D &mmio_virtio_bus->parent_obj;
>> +
>> +            if (!QTAILQ_EMPTY(&mmio_bus->children)) {
>> +                gchar *mmio_cmdline =3D microvm_get_mmio_cmdline(mmio_b=
us->name);
>> +                if (mmio_cmdline) {
>> +                    char *newcmd =3D g_strjoin(NULL, cmdline, mmio_cmdl=
ine, NULL);
>> +                    g_free(mmio_cmdline);
>> +                    g_free(cmdline);
>> +                    cmdline =3D newcmd;
>> +                }
>> +            }
>> +        }
>> +    }
>> +
>> +    fw_cfg_modify_i32(x86ms->fw_cfg, FW_CFG_CMDLINE_SIZE, strlen(cmdlin=
e) + 1);
>> +    fw_cfg_modify_string(x86ms->fw_cfg, FW_CFG_CMDLINE_DATA, cmdline);
>> +}
>> +
>> +static void microvm_machine_state_init(MachineState *machine)
>> +{
>> +    MicrovmMachineState *mms =3D MICROVM_MACHINE(machine);
>> +    X86MachineState *x86ms =3D X86_MACHINE(machine);
>> +    Error *local_err =3D NULL;
>> +
>> +    if (machine->kernel_filename =3D=3D NULL) {
>> +        error_report("missing kernel image file name, required by micro=
vm");
>> +        exit(1);
>> +    }
>> +
>> +    microvm_memory_init(mms);
>> +
>> +    x86_cpus_init(x86ms, CPU_VERSION_LATEST);
>> +    if (local_err) {
>> +        error_report_err(local_err);
>> +        exit(1);
>> +    }
>> +
>> +    microvm_devices_init(mms);
>> +}
>> +
>> +static void microvm_machine_reset(MachineState *machine)
>> +{
>> +    MicrovmMachineState *mms =3D MICROVM_MACHINE(machine);
>> +    CPUState *cs;
>> +    X86CPU *cpu;
>> +
>> +    if (mms->kernel_cmdline_enabled && !mms->kernel_cmdline_fixed) {
>> +        microvm_fix_kernel_cmdline(machine);
>> +        mms->kernel_cmdline_fixed =3D true;
>> +    }
>> +
>> +    qemu_devices_reset();
>> +
>> +    CPU_FOREACH(cs) {
>> +        cpu =3D X86_CPU(cs);
>> +
>> +        if (cpu->apic_state) {
>> +            device_reset(cpu->apic_state);
>> +        }
>> +    }
>> +}
>> +
>> +static bool microvm_machine_get_rtc(Object *obj, Error **errp)
>> +{
>> +    MicrovmMachineState *mms =3D MICROVM_MACHINE(obj);
>> +
>> +    return mms->rtc_enabled;
>> +}
>> +
>> +static void microvm_machine_set_rtc(Object *obj, bool value, Error **er=
rp)
>> +{
>> +    MicrovmMachineState *mms =3D MICROVM_MACHINE(obj);
>> +
>> +    mms->rtc_enabled =3D value;
>> +}
>> +
>> +static bool microvm_machine_get_isa_serial(Object *obj, Error **errp)
>> +{
>> +    MicrovmMachineState *mms =3D MICROVM_MACHINE(obj);
>> +
>> +    return mms->isa_serial_enabled;
>> +}
>> +
>> +static void microvm_machine_set_isa_serial(Object *obj, bool value,
>> +                                           Error **errp)
>> +{
>> +    MicrovmMachineState *mms =3D MICROVM_MACHINE(obj);
>> +
>> +    mms->isa_serial_enabled =3D value;
>> +}
>> +
>> +static bool microvm_machine_get_option_roms(Object *obj, Error **errp)
>> +{
>> +    MicrovmMachineState *mms =3D MICROVM_MACHINE(obj);
>> +
>> +    return mms->option_roms_enabled;
>> +}
>> +
>> +static void microvm_machine_set_option_roms(Object *obj, bool value,
>> +                                            Error **errp)
>> +{
>> +    MicrovmMachineState *mms =3D MICROVM_MACHINE(obj);
>> +
>> +    mms->option_roms_enabled =3D value;
>> +}
>> +
>> +static bool microvm_machine_get_kernel_cmdline(Object *obj, Error **err=
p)
>> +{
>> +    MicrovmMachineState *mms =3D MICROVM_MACHINE(obj);
>> +
>> +    return mms->kernel_cmdline_enabled;
>> +}
>> +
>> +static void microvm_machine_set_kernel_cmdline(Object *obj, bool value,
>> +                                               Error **errp)
>> +{
>> +    MicrovmMachineState *mms =3D MICROVM_MACHINE(obj);
>> +
>> +    mms->kernel_cmdline_enabled =3D value;
>> +}
>> +
>> +static void microvm_machine_initfn(Object *obj)
>> +{
>> +    MicrovmMachineState *mms =3D MICROVM_MACHINE(obj);
>> +
>> +    /* Configuration */
>> +    mms->rtc_enabled =3D true;
>> +    mms->isa_serial_enabled =3D true;
>> +    mms->option_roms_enabled =3D true;
>> +    mms->kernel_cmdline_enabled =3D true;
>> +
>> +    /* State */
>> +    mms->kernel_cmdline_fixed =3D false;
>> +}
>> +
>> +static void microvm_class_init(ObjectClass *oc, void *data)
>> +{
>> +    MachineClass *mc =3D MACHINE_CLASS(oc);
>> +    NMIClass *nc =3D NMI_CLASS(oc);
>> +
>> +    mc->init =3D microvm_machine_state_init;
>> +
>> +    mc->family =3D "microvm_i386";
>> +    mc->desc =3D "Microvm (i386)";
>> +    mc->units_per_default_bus =3D 1;
>> +    mc->no_floppy =3D 1;
>> +    machine_class_allow_dynamic_sysbus_dev(mc, "sysbus-debugcon");
>> +    machine_class_allow_dynamic_sysbus_dev(mc, "sysbus-debugexit");
>
> Aren't these common to X86?

Hm... Those seem to be leftovers from NEMU's virt.c. I'll check it those
are really needed.

>> +    mc->max_cpus =3D 288;
>> +    mc->has_hotpluggable_cpus =3D false;
>> +    mc->auto_enable_numa_with_memhp =3D false;
>> +    mc->default_cpu_type =3D TARGET_DEFAULT_CPU_TYPE;
>> +    mc->nvdimm_supported =3D false;
>> +
>> +    /* Avoid relying too much on kernel components */
>> +    mc->default_kernel_irqchip_split =3D true;
>> +
>> +    /* Machine class handlers */
>> +    mc->reset =3D microvm_machine_reset;
>> +
>> +    /* NMI handler */
>> +    nc->nmi_monitor_handler =3D x86_nmi;
>> +
>> +    object_class_property_add_bool(oc, MICROVM_MACHINE_RTC,
>> +                                   microvm_machine_get_rtc,
>> +                                   microvm_machine_set_rtc,
>> +                                   &error_abort);
>> +    object_class_property_set_description(oc, MICROVM_MACHINE_RTC,
>> +        "Set off to disable the instantiation of an MC146818 RTC",
>> +        &error_abort);
>> +
>> +    object_class_property_add_bool(oc, MICROVM_MACHINE_ISA_SERIAL,
>> +                                   microvm_machine_get_isa_serial,
>> +                                   microvm_machine_set_isa_serial,
>> +                                   &error_abort);
>> +    object_class_property_set_description(oc, MICROVM_MACHINE_ISA_SERIA=
L,
>> +        "Set off to disable the instantiation an ISA serial port",
>> +        &error_abort);
>> +
>> +    object_class_property_add_bool(oc, MICROVM_MACHINE_OPTION_ROMS,
>> +                                   microvm_machine_get_option_roms,
>> +                                   microvm_machine_set_option_roms,
>> +                                   &error_abort);
>> +    object_class_property_set_description(oc, MICROVM_MACHINE_OPTION_RO=
MS,
>> +        "Set off to disable loading option ROMs", &error_abort);
>> +
>> +    object_class_property_add_bool(oc, MICROVM_MACHINE_KERNEL_CMDLINE,
>> +                                   microvm_machine_get_kernel_cmdline,
>> +                                   microvm_machine_set_kernel_cmdline,
>> +                                   &error_abort);
>> +    object_class_property_set_description(oc, MICROVM_MACHINE_KERNEL_CM=
DLINE,
>> +        "Set off to disable adding virtio-mmio devices to the kernel cm=
dline",
>> +        &error_abort);
>> +}
>> +
>> +static const TypeInfo microvm_machine_info =3D {
>> +    .name          =3D TYPE_MICROVM_MACHINE,
>> +    .parent        =3D TYPE_X86_MACHINE,
>> +    .instance_size =3D sizeof(MicrovmMachineState),
>> +    .instance_init =3D microvm_machine_initfn,
>> +    .class_size    =3D sizeof(MicrovmMachineClass),
>> +    .class_init    =3D microvm_class_init,
>> +    .interfaces =3D (InterfaceInfo[]) {
>> +         { TYPE_NMI },
>
> Isn't this inherited from TYPE_X86_MACHINE?

Good question. Should we assume all x86 based machines have NMI, or just
leave it to each board?

Thanks,
Sergio.

>> +         { }
>> +    },
>> +};
>> +
>> +static void microvm_machine_init(void)
>> +{
>> +    type_register_static(&microvm_machine_info);
>> +}
>> +type_init(microvm_machine_init);
>> diff --git a/include/hw/i386/microvm.h b/include/hw/i386/microvm.h
>> new file mode 100644
>> index 0000000000..04c8caf886
>> --- /dev/null
>> +++ b/include/hw/i386/microvm.h
>> @@ -0,0 +1,80 @@
>> +/*
>> + * Copyright (c) 2018 Intel Corporation
>> + * Copyright (c) 2019 Red Hat, Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or modify=
 it
>> + * under the terms and conditions of the GNU General Public License,
>> + * version 2 or later, as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope it will be useful, but WITHO=
UT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public Licens=
e for
>> + * more details.
>> + *
>> + * You should have received a copy of the GNU General Public License al=
ong with
>> + * this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#ifndef HW_I386_MICROVM_H
>> +#define HW_I386_MICROVM_H
>> +
>> +#include "qemu-common.h"
>> +#include "exec/hwaddr.h"
>> +#include "qemu/notify.h"
>> +
>> +#include "hw/boards.h"
>> +#include "hw/i386/x86.h"
>> +
>> +/* Microvm memory layout */
>> +#define PVH_START_INFO        0x6000
>> +#define MEMMAP_START          0x7000
>> +#define MODLIST_START         0x7800
>> +#define BOOT_STACK_POINTER    0x8ff0
>> +#define PML4_START            0x9000
>> +#define PDPTE_START           0xa000
>> +#define PDE_START             0xb000
>> +#define KERNEL_CMDLINE_START  0x20000
>> +#define EBDA_START            0x9fc00
>> +#define HIMEM_START           0x100000
>> +
>> +/* Platform virtio definitions */
>> +#define VIRTIO_MMIO_BASE      0xc0000000
>> +#define VIRTIO_IRQ_BASE       5
>> +#define VIRTIO_NUM_TRANSPORTS 8
>> +#define VIRTIO_CMDLINE_MAXLEN 64
>> +
>> +/* Machine type options */
>> +#define MICROVM_MACHINE_RTC            "rtc"
>> +#define MICROVM_MACHINE_ISA_SERIAL     "isa-serial"
>> +#define MICROVM_MACHINE_OPTION_ROMS    "option-roms"
>> +#define MICROVM_MACHINE_KERNEL_CMDLINE "kernel-cmdline"
>> +
>> +typedef struct {
>> +    X86MachineClass parent;
>> +    HotplugHandler *(*orig_hotplug_handler)(MachineState *machine,
>> +                                           DeviceState *dev);
>> +} MicrovmMachineClass;
>> +
>> +typedef struct {
>> +    X86MachineState parent;
>> +
>> +    /* Machine type options */
>> +    bool rtc_enabled;
>> +    bool isa_serial_enabled;
>> +    bool option_roms_enabled;
>> +    bool kernel_cmdline_enabled;
>> +
>> +
>> +    /* Machine state */
>> +    bool kernel_cmdline_fixed;
>> +} MicrovmMachineState;
>> +
>> +#define TYPE_MICROVM_MACHINE   MACHINE_TYPE_NAME("microvm")
>> +#define MICROVM_MACHINE(obj) \
>> +    OBJECT_CHECK(MicrovmMachineState, (obj), TYPE_MICROVM_MACHINE)
>> +#define MICROVM_MACHINE_GET_CLASS(obj) \
>> +    OBJECT_GET_CLASS(MicrovmMachineClass, obj, TYPE_MICROVM_MACHINE)
>> +#define MICROVM_MACHINE_CLASS(class) \
>> +    OBJECT_CLASS_CHECK(MicrovmMachineClass, class, TYPE_MICROVM_MACHINE)
>> +
>> +#endif
>>=20


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAl2MW+IACgkQ9GknjS8M
AjX8Ug/+PXigHTQR8Twzt6rRWUkGSeIU7gfO7G5lK3+XnO+A0AGThCJ9QdacOfTI
j0z7mPdWpdiUdhCxn4QIVOls58rPToYtLOZt+69x2rN3TZ4IIRuKsCL5GvgdVK6R
M2QOKI1RjUiPyF43RaBrkoYWE3h1IbcJH3nRO8yhfn1aU5QZadh9VbsvmKcLiFkt
apt8lznvp8P+INao7oPaMpTUL8X4CntKKUL1g7CMJ8p3ny8cv7Y+flM+Jn9DySz+
fFI4F93/LlidbxrB/gLRoXO1YMdKFC5Ee7qgnBmW3qLZK/djfCqHt0Dn+qSqkxvG
WA1flZuqmueRBal8yzynuh4vIWd501MZeo9ynll+nlZ39GPKDZaIHmQASwNK4lvo
1/23Msfd4fVJ4DPKHv5ltcaBHJNeeeu0BoOIzQ78SMQbo29tjecVdot/X3rZEbte
Jm+fMXCtoedKA3fDHexvXacVICShB72mQr7sffZHam84pqp+BLuIb/aI0jD3KXE9
XGYoi2YSFK+pLu3V1VOgXehJQ+kfvUQvfEB20mKzc1fdgr9ixfMfBkexrlP5dsuI
mFqxZjOY0Z6PUVz+10XLM2rRVIcveqncSt+ZCb+BKebfWr/joaTZ25zawCSE1ylo
m8DxzgoROcI+PF5JhPQmwJ9egln7qmBxzG9dB2wmhxpbS38ep3o=
=BI4G
-----END PGP SIGNATURE-----
--=-=-=--
