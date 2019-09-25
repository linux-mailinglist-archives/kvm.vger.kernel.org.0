Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1C1BD811
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 08:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411849AbfIYGD1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 02:03:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37832 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411845AbfIYGDG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 02:03:06 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0AF568535C
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 06:03:06 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id w10so1746323wrl.5
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 23:03:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=kdVgmLDX3XC0MZB5e+D8RfcV20vQhEvu7mZJJoI2cYI=;
        b=mdRlyprgs/3SN6k8JisBXp88r7xWb9U00kVWu6yjdEPVcm5nViohXxtlXPSTzyFo6/
         SeIgSdWi2oM7/J8tWogzRcjFJe1nRArx9Epy8zovzejhccxj2EWCwnUXrMFakARBQjkO
         OV5R7Nlqe68Nh7LqzYDf1GCCShNeUt3U4ki7p9FH1bFiKQkLJAxiXp3ang6XopiMmDOC
         T2z5QCGfg/CD5nhTzTwRsYtLCvbUVRUZniKqZOVjwVx1HL/dsSWh5SfrAdkZR7efOLGM
         sJ7IPQuvQAQsPYtqUaAYryJWgyaOfGTb7mPcgR0XSh2Y6XXlyCyJGQL6oLofR8G2MgHC
         YVuA==
X-Gm-Message-State: APjAAAVw+tfAiaVYgLD4CniwLKYk9BWudB+ul8mQhQ6k5qlrM3ornkIK
        5C+jH+mQncmHOKUmYttEF8NwIyr4gNKqQdU+sO4QVuUNMu7eEWf8qZ3SZ0J2OGePbagz/uyn36H
        pfxPHjqMbM74J
X-Received: by 2002:adf:bb0a:: with SMTP id r10mr7363885wrg.13.1569391383754;
        Tue, 24 Sep 2019 23:03:03 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxAbYS6gsCDr+G2KEN9U5KqgyI7/w95sCF5bkYJb7ePUh//1XmHS3yIhfV+Ixnh55zlkdDEFg==
X-Received: by 2002:adf:bb0a:: with SMTP id r10mr7363842wrg.13.1569391383453;
        Tue, 24 Sep 2019 23:03:03 -0700 (PDT)
Received: from dritchie.redhat.com (139.red-95-120-215.dynamicip.rima-tde.net. [95.120.215.139])
        by smtp.gmail.com with ESMTPSA id v7sm4853071wru.87.2019.09.24.23.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2019 23:03:02 -0700 (PDT)
References: <20190924124433.96810-1-slp@redhat.com> <20190924124433.96810-2-slp@redhat.com> <1f1e944f-0076-6c96-3da0-ea196e2d21a1@redhat.com>
User-agent: mu4e 1.2.0; emacs 26.2
From:   Sergio Lopez <slp@redhat.com>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        marcel.apfelbaum@gmail.com, pbonzini@redhat.com, rth@twiddle.net,
        ehabkost@redhat.com, lersek@redhat.com, kraxel@redhat.com,
        mtosatti@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v4 1/8] hw/i386: Factorize PVH related functions
In-reply-to: <1f1e944f-0076-6c96-3da0-ea196e2d21a1@redhat.com>
Date:   Wed, 25 Sep 2019 08:03:00 +0200
Message-ID: <87lfucsyjv.fsf@redhat.com>
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

> Hi Sergio,
>
> On 9/24/19 2:44 PM, Sergio Lopez wrote:
>> Extract PVH related functions from pc.c, and put them in pvh.c, so
>> they can be shared with other components.
>>=20
>> Signed-off-by: Sergio Lopez <slp@redhat.com>
>> ---
>>  hw/i386/Makefile.objs |   1 +
>>  hw/i386/pc.c          | 120 +++++-------------------------------------
>>  hw/i386/pvh.c         | 113 +++++++++++++++++++++++++++++++++++++++
>>  hw/i386/pvh.h         |  10 ++++
>>  4 files changed, 136 insertions(+), 108 deletions(-)
>>  create mode 100644 hw/i386/pvh.c
>>  create mode 100644 hw/i386/pvh.h
>>=20
>> diff --git a/hw/i386/Makefile.objs b/hw/i386/Makefile.objs
>> index 5d9c9efd5f..c5f20bbd72 100644
>> --- a/hw/i386/Makefile.objs
>> +++ b/hw/i386/Makefile.objs
>> @@ -1,5 +1,6 @@
>>  obj-$(CONFIG_KVM) +=3D kvm/
>>  obj-y +=3D multiboot.o
>> +obj-y +=3D pvh.o
>>  obj-y +=3D pc.o
>>  obj-$(CONFIG_I440FX) +=3D pc_piix.o
>>  obj-$(CONFIG_Q35) +=3D pc_q35.o
>> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
>> index bad866fe44..10e4ced0c6 100644
>> --- a/hw/i386/pc.c
>> +++ b/hw/i386/pc.c
>> @@ -42,6 +42,7 @@
>>  #include "elf.h"
>>  #include "migration/vmstate.h"
>>  #include "multiboot.h"
>> +#include "pvh.h"
>>  #include "hw/timer/mc146818rtc.h"
>>  #include "hw/dma/i8257.h"
>>  #include "hw/timer/i8254.h"
>> @@ -116,9 +117,6 @@ static struct e820_entry *e820_table;
>>  static unsigned e820_entries;
>>  struct hpet_fw_config hpet_cfg =3D {.count =3D UINT8_MAX};
>>=20=20
>> -/* Physical Address of PVH entry point read from kernel ELF NOTE */
>> -static size_t pvh_start_addr;
>> -
>>  GlobalProperty pc_compat_4_1[] =3D {};
>>  const size_t pc_compat_4_1_len =3D G_N_ELEMENTS(pc_compat_4_1);
>>=20=20
>> @@ -1076,109 +1074,6 @@ struct setup_data {
>>      uint8_t data[0];
>>  } __attribute__((packed));
>>=20=20
>> -
>> -/*
>> - * The entry point into the kernel for PVH boot is different from
>> - * the native entry point.  The PVH entry is defined by the x86/HVM
>> - * direct boot ABI and is available in an ELFNOTE in the kernel binary.
>> - *
>> - * This function is passed to load_elf() when it is called from
>> - * load_elfboot() which then additionally checks for an ELF Note of
>> - * type XEN_ELFNOTE_PHYS32_ENTRY and passes it to this function to
>> - * parse the PVH entry address from the ELF Note.
>> - *
>> - * Due to trickery in elf_opts.h, load_elf() is actually available as
>> - * load_elf32() or load_elf64() and this routine needs to be able
>> - * to deal with being called as 32 or 64 bit.
>> - *
>> - * The address of the PVH entry point is saved to the 'pvh_start_addr'
>> - * global variable.  (although the entry point is 32-bit, the kernel
>> - * binary can be either 32-bit or 64-bit).
>> - */
>> -static uint64_t read_pvh_start_addr(void *arg1, void *arg2, bool is64)
>> -{
>> -    size_t *elf_note_data_addr;
>> -
>> -    /* Check if ELF Note header passed in is valid */
>> -    if (arg1 =3D=3D NULL) {
>> -        return 0;
>> -    }
>> -
>> -    if (is64) {
>> -        struct elf64_note *nhdr64 =3D (struct elf64_note *)arg1;
>> -        uint64_t nhdr_size64 =3D sizeof(struct elf64_note);
>> -        uint64_t phdr_align =3D *(uint64_t *)arg2;
>> -        uint64_t nhdr_namesz =3D nhdr64->n_namesz;
>> -
>> -        elf_note_data_addr =3D
>> -            ((void *)nhdr64) + nhdr_size64 +
>> -            QEMU_ALIGN_UP(nhdr_namesz, phdr_align);
>> -    } else {
>> -        struct elf32_note *nhdr32 =3D (struct elf32_note *)arg1;
>> -        uint32_t nhdr_size32 =3D sizeof(struct elf32_note);
>> -        uint32_t phdr_align =3D *(uint32_t *)arg2;
>> -        uint32_t nhdr_namesz =3D nhdr32->n_namesz;
>> -
>> -        elf_note_data_addr =3D
>> -            ((void *)nhdr32) + nhdr_size32 +
>> -            QEMU_ALIGN_UP(nhdr_namesz, phdr_align);
>> -    }
>> -
>> -    pvh_start_addr =3D *elf_note_data_addr;
>> -
>> -    return pvh_start_addr;
>> -}
>> -
>> -static bool load_elfboot(const char *kernel_filename,
>> -                   int kernel_file_size,
>> -                   uint8_t *header,
>> -                   size_t pvh_xen_start_addr,
>> -                   FWCfgState *fw_cfg)
>> -{
>> -    uint32_t flags =3D 0;
>> -    uint32_t mh_load_addr =3D 0;
>> -    uint32_t elf_kernel_size =3D 0;
>> -    uint64_t elf_entry;
>> -    uint64_t elf_low, elf_high;
>> -    int kernel_size;
>> -
>> -    if (ldl_p(header) !=3D 0x464c457f) {
>> -        return false; /* no elfboot */
>> -    }
>> -
>> -    bool elf_is64 =3D header[EI_CLASS] =3D=3D ELFCLASS64;
>> -    flags =3D elf_is64 ?
>> -        ((Elf64_Ehdr *)header)->e_flags : ((Elf32_Ehdr *)header)->e_fla=
gs;
>> -
>> -    if (flags & 0x00010004) { /* LOAD_ELF_HEADER_HAS_ADDR */
>> -        error_report("elfboot unsupported flags =3D %x", flags);
>> -        exit(1);
>> -    }
>> -
>> -    uint64_t elf_note_type =3D XEN_ELFNOTE_PHYS32_ENTRY;
>> -    kernel_size =3D load_elf(kernel_filename, read_pvh_start_addr,
>> -                           NULL, &elf_note_type, &elf_entry,
>> -                           &elf_low, &elf_high, 0, I386_ELF_MACHINE,
>> -                           0, 0);
>> -
>> -    if (kernel_size < 0) {
>> -        error_report("Error while loading elf kernel");
>> -        exit(1);
>> -    }
>> -    mh_load_addr =3D elf_low;
>> -    elf_kernel_size =3D elf_high - elf_low;
>> -
>> -    if (pvh_start_addr =3D=3D 0) {
>> -        error_report("Error loading uncompressed kernel without PVH ELF=
 Note");
>> -        exit(1);
>> -    }
>> -    fw_cfg_add_i32(fw_cfg, FW_CFG_KERNEL_ENTRY, pvh_start_addr);
>> -    fw_cfg_add_i32(fw_cfg, FW_CFG_KERNEL_ADDR, mh_load_addr);
>> -    fw_cfg_add_i32(fw_cfg, FW_CFG_KERNEL_SIZE, elf_kernel_size);
>> -
>> -    return true;
>> -}
>> -
>>  static void load_linux(PCMachineState *pcms,
>>                         FWCfgState *fw_cfg)
>>  {
>> @@ -1218,6 +1113,9 @@ static void load_linux(PCMachineState *pcms,
>>      if (ldl_p(header+0x202) =3D=3D 0x53726448) {
>>          protocol =3D lduw_p(header+0x206);
>>      } else {
>> +        size_t pvh_start_addr;
>> +        uint32_t mh_load_addr =3D 0;
>> +        uint32_t elf_kernel_size =3D 0;
>>          /*
>>           * This could be a multiboot kernel. If it is, let's stop treat=
ing it
>>           * like a Linux kernel.
>> @@ -1235,10 +1133,16 @@ static void load_linux(PCMachineState *pcms,
>>           * If load_elfboot() is successful, populate the fw_cfg info.
>>           */
>>          if (pcmc->pvh_enabled &&
>> -            load_elfboot(kernel_filename, kernel_size,
>> -                         header, pvh_start_addr, fw_cfg)) {
>> +            pvh_load_elfboot(kernel_filename,
>> +                             &mh_load_addr, &elf_kernel_size)) {
>>              fclose(f);
>>=20=20
>> +            pvh_start_addr =3D pvh_get_start_addr();
>> +
>> +            fw_cfg_add_i32(fw_cfg, FW_CFG_KERNEL_ENTRY, pvh_start_addr);
>> +            fw_cfg_add_i32(fw_cfg, FW_CFG_KERNEL_ADDR, mh_load_addr);
>> +            fw_cfg_add_i32(fw_cfg, FW_CFG_KERNEL_SIZE, elf_kernel_size);
>> +
>>              fw_cfg_add_i32(fw_cfg, FW_CFG_CMDLINE_SIZE,
>>                  strlen(kernel_cmdline) + 1);
>>              fw_cfg_add_string(fw_cfg, FW_CFG_CMDLINE_DATA, kernel_cmdli=
ne);
>> diff --git a/hw/i386/pvh.c b/hw/i386/pvh.c
>> new file mode 100644
>> index 0000000000..1c81727811
>> --- /dev/null
>> +++ b/hw/i386/pvh.c
>> @@ -0,0 +1,113 @@
>> +/*
>> + * PVH Boot Helper
>> + *
>> + * Copyright (C) 2019 Oracle
>> + * Copyright (C) 2019 Red Hat, Inc
>> + *
>> + * This work is licensed under the terms of the GNU GPL, version 2 or l=
ater.
>> + * See the COPYING file in the top-level directory.
>> + *
>> + */
>> +
>> +#include "qemu/osdep.h"
>> +#include "qemu/units.h"
>> +#include "qemu/error-report.h"
>> +#include "hw/loader.h"
>> +#include "cpu.h"
>> +#include "elf.h"
>> +#include "pvh.h"
>> +
>> +static size_t pvh_start_addr;
>> +
>> +size_t pvh_get_start_addr(void)
>> +{
>> +    return pvh_start_addr;
>> +}
>> +
>> +/*
>> + * The entry point into the kernel for PVH boot is different from
>> + * the native entry point.  The PVH entry is defined by the x86/HVM
>> + * direct boot ABI and is available in an ELFNOTE in the kernel binary.
>> + *
>> + * This function is passed to load_elf() when it is called from
>> + * load_elfboot() which then additionally checks for an ELF Note of
>> + * type XEN_ELFNOTE_PHYS32_ENTRY and passes it to this function to
>> + * parse the PVH entry address from the ELF Note.
>> + *
>> + * Due to trickery in elf_opts.h, load_elf() is actually available as
>> + * load_elf32() or load_elf64() and this routine needs to be able
>> + * to deal with being called as 32 or 64 bit.
>> + *
>> + * The address of the PVH entry point is saved to the 'pvh_start_addr'
>> + * global variable.  (although the entry point is 32-bit, the kernel
>> + * binary can be either 32-bit or 64-bit).
>> + */
>> +
>> +static uint64_t read_pvh_start_addr(void *arg1, void *arg2, bool is64)
>> +{
>> +    size_t *elf_note_data_addr;
>> +
>> +    /* Check if ELF Note header passed in is valid */
>> +    if (arg1 =3D=3D NULL) {
>> +        return 0;
>> +    }
>> +
>> +    if (is64) {
>> +        struct elf64_note *nhdr64 =3D (struct elf64_note *)arg1;
>> +        uint64_t nhdr_size64 =3D sizeof(struct elf64_note);
>> +        uint64_t phdr_align =3D *(uint64_t *)arg2;
>> +        uint64_t nhdr_namesz =3D nhdr64->n_namesz;
>> +
>> +        elf_note_data_addr =3D
>> +            ((void *)nhdr64) + nhdr_size64 +
>> +            QEMU_ALIGN_UP(nhdr_namesz, phdr_align);
>> +    } else {
>> +        struct elf32_note *nhdr32 =3D (struct elf32_note *)arg1;
>> +        uint32_t nhdr_size32 =3D sizeof(struct elf32_note);
>> +        uint32_t phdr_align =3D *(uint32_t *)arg2;
>> +        uint32_t nhdr_namesz =3D nhdr32->n_namesz;
>> +
>> +        elf_note_data_addr =3D
>> +            ((void *)nhdr32) + nhdr_size32 +
>> +            QEMU_ALIGN_UP(nhdr_namesz, phdr_align);
>> +    }
>> +
>> +    pvh_start_addr =3D *elf_note_data_addr;
>> +
>> +    return pvh_start_addr;
>> +}
>> +
>> +bool pvh_load_elfboot(const char *kernel_filename,
>> +                      uint32_t *mh_load_addr,
>> +                      uint32_t *elf_kernel_size)
>> +{
>> +    uint64_t elf_entry;
>> +    uint64_t elf_low, elf_high;
>> +    int kernel_size;
>> +    uint64_t elf_note_type =3D XEN_ELFNOTE_PHYS32_ENTRY;
>> +
>> +    kernel_size =3D load_elf(kernel_filename, read_pvh_start_addr,
>> +                           NULL, &elf_note_type, &elf_entry,
>> +                           &elf_low, &elf_high, 0, I386_ELF_MACHINE,
>> +                           0, 0);
>> +
>> +    if (kernel_size < 0) {
>> +        error_report("Error while loading elf kernel");
>> +        return false;
>> +    }
>> +
>> +    if (pvh_start_addr =3D=3D 0) {
>> +        error_report("Error loading uncompressed kernel without PVH ELF=
 Note");
>> +        return false;
>> +    }
>> +
>> +    if (mh_load_addr) {
>> +        *mh_load_addr =3D elf_low;
>> +    }
>> +
>> +    if (elf_kernel_size) {
>> +        *elf_kernel_size =3D elf_high - elf_low;
>> +    }
>> +
>> +    return true;
>> +}
>> diff --git a/hw/i386/pvh.h b/hw/i386/pvh.h
>> new file mode 100644
>> index 0000000000..ada67ff6e8
>> --- /dev/null
>> +++ b/hw/i386/pvh.h
>> @@ -0,0 +1,10 @@
>
> License missing.

I'm a bit confused about the policy for license blocks in headers, as
some do have it, while others don't (i.e. multiboot.h and acpi-build.h).

>> +#ifndef HW_I386_PVH_H
>> +#define HW_I386_PVH_H
>> +
>> +size_t pvh_get_start_addr(void);
>> +
>> +bool pvh_load_elfboot(const char *kernel_filename,
>> +                      uint32_t *mh_load_addr,
>> +                      uint32_t *elf_kernel_size);
>
> Can you document these functions?

Sure.

Thanks,
Sergio.

>> +
>> +#endif
>>=20


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAl2LAxQACgkQ9GknjS8M
AjX4WBAAq/BtbV9mUG9GH3Os6D1hVFI+gMv1DccKyutkUhjFrzBZNlFBeeQCyDIl
z1YaEkAxPzaTKhNYNV+XXHQxqtXn5uq0lRu48oIbsamFCvn8SPXWVAocszJ1m5ix
xQ8GSE/xm0u/MJ2XLhy9O+7I5UD4ze1xS0+z4hFrBdRteCzF+MjFflhCUR5Eot9d
Nac6DOrnP9hSce09IDsP6yGdXwePt/O5FKDTW9wRnZ66VzeM6No0GtXRiYpl3gZr
lXmV/Xwv74LRHTCQPreQVN0n08eRzAfVCpmXSFQ9HULOFr8iJoVSLQlbxvFBOXn5
eUvErXPhmsYKgOIzgqScYq3AvGQ24mI3aEFiHwn3hHa5or75hZ+s4WGAQPVyBsiy
dIlcP3r/psOasnUEXlo7T7FiqmG0bJUWZBPDz94ewV9/fEXVuYeLZPsTcd26/XIf
46Ka+qKcGBbh0KYsdHpP/ok6mOOl27ug/SndpS6o83giSB8faiJjuHh+ZxCMQcxF
95LlZW3jlOnHuXrH6sgVn4DzqPkZgD1KXcpFNwgMD/uyKCAh5esaZY8WU36usRxc
EUFjpNF2OB1YeLUq9arJPTvXOTAZMk3W7aogxdthz+dY4RgPB7CXwX4i2hv+uthu
MdWsVoV18fCu+6h1hG2/ydzyvLSstSE42EMKSx0tmPQSPr+QrE4=
=ey5j
-----END PGP SIGNATURE-----
--=-=-=--
