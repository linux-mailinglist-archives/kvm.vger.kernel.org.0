Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2CC5BDA5F
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 11:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfIYJAv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 05:00:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41960 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726759AbfIYJAh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 05:00:37 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8A7E364120
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 09:00:36 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id n18so2003914wro.11
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 02:00:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=akojttV9wD2ODvI0dZtsSJtFOsq58tyYnhGeDmI3Seg=;
        b=V6guFs8wBTHvI47MN9bzzIcmIq1H00Y987cm8QfJGAdr0z8MVoEsXZBkT6MeK6e8Mi
         XAgWGBq5RN4egp28vxoHdDbwF9aGl8A+v+OsSKosuJcM5kNbFGR70EQYnYX3afF9Irmj
         VBsX8xy3XeckVq3ISAUTnWjQ2Dh8AX6nqoSjPJyraA7hJxdRQsDgj872I5ivFE82GlVF
         Ye1ix5e/Q4+V6TQeUaaWqqw3o3FO6TDpBuUiGcEy0MEqzbKzeZsEibHClMAeeY8dyB/r
         eKqPcmhSVvqsx1iUZ+pPFxWoqTudgejFF+xI8yac2Tw/u01vcoU8QCmnK3VS/xffRDoS
         kAaQ==
X-Gm-Message-State: APjAAAUjazD5Lbm249vrvPn6C6Jqq7b3YeASh47b/xHxWzVq6swF06Tw
        mn6fuVizRx6EssT/RmGmz9M74Xz3rs7jpqU++UfvBamai6EbM+pKcYbohYpAJUe4gXPNvg5HbfG
        xkikp9iRGhhrF
X-Received: by 2002:adf:fa86:: with SMTP id h6mr2100411wrr.152.1569402034011;
        Wed, 25 Sep 2019 02:00:34 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwGMWO6uqaiu+wm89ot6QNDAEOKF2Fnq/DA1OyU8Dwy1mqnzu5kzRIhTGGXVzCDo130hQJzIQ==
X-Received: by 2002:adf:fa86:: with SMTP id h6mr2100369wrr.152.1569402033724;
        Wed, 25 Sep 2019 02:00:33 -0700 (PDT)
Received: from dritchie.redhat.com (139.red-95-120-215.dynamicip.rima-tde.net. [95.120.215.139])
        by smtp.gmail.com with ESMTPSA id 26sm2163722wmf.20.2019.09.25.02.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 02:00:33 -0700 (PDT)
References: <20190924124433.96810-1-slp@redhat.com> <20190924124433.96810-2-slp@redhat.com> <20190925083604.w77kl2x5umx2rubj@steredhat>
User-agent: mu4e 1.2.0; emacs 26.2
From:   Sergio Lopez <slp@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        marcel.apfelbaum@gmail.com, pbonzini@redhat.com, rth@twiddle.net,
        ehabkost@redhat.com, philmd@redhat.com, lersek@redhat.com,
        kraxel@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v4 1/8] hw/i386: Factorize PVH related functions
In-reply-to: <20190925083604.w77kl2x5umx2rubj@steredhat>
Date:   Wed, 25 Sep 2019 11:00:30 +0200
Message-ID: <87d0fosqc1.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Stefano Garzarella <sgarzare@redhat.com> writes:

> Hi Sergio,
>
> On Tue, Sep 24, 2019 at 02:44:26PM +0200, Sergio Lopez wrote:
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
>
> Are we removing the following checks (ELF magic, flags) because they
> are superfluous?
>
> Should we mention this in the commit message?

Damn, good catch, that's wrong.

The only patches coming from previous iterations are the one factorizing
the e820 functions and this one, and both are wrong. I'm going to ditch
them and write whatever it's needed from scratch.

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
>> +#ifndef HW_I386_PVH_H
>> +#define HW_I386_PVH_H
>> +
>> +size_t pvh_get_start_addr(void);
>
> What about adding "size_t *pvh_start_addr" to the pvh_load_elfboot()?
> Just an idea, I'm not sure if it is better...

I agree. In fact, given that patch 4/8 extracts some common functions
from pc.c into x86.c, and load_linux is among these functions, perhaps
we can avoid creating an independent file and just put the PVH code
there.

What do you think?

Thanks a lot,
Sergio.

>> +
>> +bool pvh_load_elfboot(const char *kernel_filename,
>> +                      uint32_t *mh_load_addr,
>> +                      uint32_t *elf_kernel_size);
>> +
>> +#endif
>
> Thanks,
> Stefano


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAl2LLK4ACgkQ9GknjS8M
AjVLDg/6AglCHWEMvogIrJb7g60WraD/oFKO+VHH9ZW/mCL2cB4ICzqSxFHvw5uZ
yqhWEyoJ/EQbZaawiJUg7ZqroW6U60X8r3frgbpyR4iPlGrtqkV5UKMXMNZacGmN
7P5lkUdVeVN2owXgmxxqObnlpVCf6I0IWIGNi2KaWIi8jwkGybLvtskhMRbd64Rc
l3EHJcnZPOPUkTYV5DbVodHiknrwV50xTKKqgNc66FFKgmdZo3hl0TfQJGW+5ni1
ezgD7uAV9Q8ZH9LooEZpww1pcbu1+k0XI+rZzqfvvep8YlUnuMQR/xhp4Mr83yNC
8ZzQV/ZQa8A07IOqNivYaXAxWRqak06XrY5G2KDi6zXuU6d9l3mQwC4qr4meyDyJ
2ini4F1EB+ytdK+HHUibuTn3StV7iLAeuyuncK+lcf4+eP40Sh2clwApEH0cfXWX
cd1cTaUm/+m5L1U86gCeO9D2MLK+yhluJAMArGRNnVpkVthGHh9NIq8a5sl87UZu
y5ijJXLsIcuABT3DECJkS49cHjXtb0nT+sfqoWEyzHd3aJFsDnKj7uGo7Fv05pMd
LMjUa7b8iem886IQE0BvQ3sWSgKV4NOoIui7QruL6Y+VRyY6L7hIHB21X0V/BAYk
frNReR1Zv1XO036dcydcj6QC3st+6DIO4nJ0e/kGTSJDMDXMy0Y=
=pPNu
-----END PGP SIGNATURE-----
--=-=-=--
