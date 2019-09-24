Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DAE6BC9EB
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 16:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409716AbfIXOM7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 10:12:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52046 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726441AbfIXOM7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 10:12:59 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 783533C916
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 14:12:58 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id o188so79663wmo.5
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 07:12:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=l9vefuHyet8vI1m8FEB739NjXuW8QKuRb1VaSFhtOvw=;
        b=mIBbOgWqICzbKIBejOzG+NnQUkfLiRkJWHq8453DgvGn3ihWOUL/+kSNCJrus+g8HE
         xU1Rf9XCjWP6MYP3Fr0jNs1CDfv2DO5jnj7BIEnMDhlUh9JZRE6NerxT5+DXkWl00HHZ
         UN3awHbo2PelWjgrdvBwvuVGt/ZS8tgQ4l+lm6DKt9AtRv8cFwChvSD5+4u5N87++uNl
         eLVaf+dX/Skx73wZMkHGNe2q36uNyf2wS3T9k6v+6JkuwYk/Hd57yHrTXvLFJihV4uzw
         HZ8uHAEiit5mImpo/6rt9c+wva0sXL3FVGoomdyHPl5BjMoYoaU4uSmCznaeQkUEGuL+
         sKpQ==
X-Gm-Message-State: APjAAAXkMXvwfYjyekeExocRy1xf1gBDM22KVnA/iQIf8PgMG3dWmpup
        1VPGQNeSCUrpZJ+Xl8qPfuuZZ22AFcg+qs4XAPiDk8DUUIMmuSZo3T7mT+bxOUhKtX1/IdoCdyS
        8FozhlacTpGQx
X-Received: by 2002:a05:600c:291c:: with SMTP id i28mr241844wmd.98.1569334376733;
        Tue, 24 Sep 2019 07:12:56 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzD4YtTHWQ7AvwR0ifKjQMc4MlqhVYnQsSAaeaMfJOPaMROHIwmLe7G8/V7MGRSuGapV+xo5A==
X-Received: by 2002:a05:600c:291c:: with SMTP id i28mr241816wmd.98.1569334376472;
        Tue, 24 Sep 2019 07:12:56 -0700 (PDT)
Received: from dritchie.redhat.com (139.red-95-120-215.dynamicip.rima-tde.net. [95.120.215.139])
        by smtp.gmail.com with ESMTPSA id l13sm151370wmj.25.2019.09.24.07.12.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2019 07:12:55 -0700 (PDT)
References: <20190924124433.96810-1-slp@redhat.com> <20190924124433.96810-3-slp@redhat.com> <474e1e49-6ae6-bf94-1a92-07c0142aff40@redhat.com>
User-agent: mu4e 1.2.0; emacs 26.2
From:   Sergio Lopez <slp@redhat.com>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        marcel.apfelbaum@gmail.com, pbonzini@redhat.com, rth@twiddle.net,
        ehabkost@redhat.com, lersek@redhat.com, kraxel@redhat.com,
        mtosatti@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v4 2/8] hw/i386: Factorize e820 related functions
In-reply-to: <474e1e49-6ae6-bf94-1a92-07c0142aff40@redhat.com>
Date:   Tue, 24 Sep 2019 16:12:45 +0200
Message-ID: <87pnjpsrz6.fsf@redhat.com>
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
>> Extract e820 related functions from pc.c, and put them in e820.c, so
>> they can be shared with other components.
>>=20
>> Signed-off-by: Sergio Lopez <slp@redhat.com>
>> ---
>>  hw/i386/Makefile.objs |  1 +
>>  hw/i386/e820.c        | 99 +++++++++++++++++++++++++++++++++++++++++++
>>  hw/i386/e820.h        | 11 +++++
>>  hw/i386/pc.c          | 66 +----------------------------
>>  include/hw/i386/pc.h  | 11 -----
>>  target/i386/kvm.c     |  1 +
>>  6 files changed, 114 insertions(+), 75 deletions(-)
>>  create mode 100644 hw/i386/e820.c
>>  create mode 100644 hw/i386/e820.h
>>=20
>> diff --git a/hw/i386/Makefile.objs b/hw/i386/Makefile.objs
>> index c5f20bbd72..149712db07 100644
>> --- a/hw/i386/Makefile.objs
>> +++ b/hw/i386/Makefile.objs
>> @@ -2,6 +2,7 @@ obj-$(CONFIG_KVM) +=3D kvm/
>>  obj-y +=3D multiboot.o
>>  obj-y +=3D pvh.o
>>  obj-y +=3D pc.o
>> +obj-y +=3D e820.o
>
> Isn't that commit d6d059ca07ae907b8945f88c382fb54d43f9f03a?
> I'm confuse now.

Hm... this was pulled on 2019-09-17 and I totally missed it. I'll drop
this and rebase the patchset for v5.

Thanks!

>>  obj-$(CONFIG_I440FX) +=3D pc_piix.o
>>  obj-$(CONFIG_Q35) +=3D pc_q35.o
>>  obj-y +=3D fw_cfg.o pc_sysfw.o
>> diff --git a/hw/i386/e820.c b/hw/i386/e820.c
>> new file mode 100644
>> index 0000000000..d5c5c0d528
>> --- /dev/null
>> +++ b/hw/i386/e820.c
>> @@ -0,0 +1,99 @@
>> +/*
>> + * Copyright (c) 2003-2004 Fabrice Bellard
>> + * Copyright (c) 2019 Red Hat, Inc.
>> + *
>> + * Permission is hereby granted, free of charge, to any person obtainin=
g a copy
>> + * of this software and associated documentation files (the "Software")=
, to deal
>> + * in the Software without restriction, including without limitation th=
e rights
>> + * to use, copy, modify, merge, publish, distribute, sublicense, and/or=
 sell
>> + * copies of the Software, and to permit persons to whom the Software is
>> + * furnished to do so, subject to the following conditions:
>> + *
>> + * The above copyright notice and this permission notice shall be inclu=
ded in
>> + * all copies or substantial portions of the Software.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPR=
ESS OR
>> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABIL=
ITY,
>> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SH=
ALL
>> + * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR=
 OTHER
>> + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARIS=
ING FROM,
>> + * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALIN=
GS IN
>> + * THE SOFTWARE.
>> + */
>> +
>> +#include "qemu/osdep.h"
>> +#include "qemu/error-report.h"
>> +#include "qemu/cutils.h"
>> +#include "qemu/units.h"
>> +
>> +#include "hw/i386/e820.h"
>> +#include "hw/i386/fw_cfg.h"
>> +
>> +#define E820_NR_ENTRIES		16
>> +
>> +struct e820_entry {
>> +    uint64_t address;
>> +    uint64_t length;
>> +    uint32_t type;
>> +} QEMU_PACKED __attribute((__aligned__(4)));
>> +
>> +struct e820_table {
>> +    uint32_t count;
>> +    struct e820_entry entry[E820_NR_ENTRIES];
>> +} QEMU_PACKED __attribute((__aligned__(4)));
>> +
>> +static struct e820_table e820_reserve;
>> +static struct e820_entry *e820_table;
>> +static unsigned e820_entries;
>> +
>> +int e820_add_entry(uint64_t address, uint64_t length, uint32_t type)
>> +{
>> +    int index =3D le32_to_cpu(e820_reserve.count);
>> +    struct e820_entry *entry;
>> +
>> +    if (type !=3D E820_RAM) {
>> +        /* old FW_CFG_E820_TABLE entry -- reservations only */
>> +        if (index >=3D E820_NR_ENTRIES) {
>> +            return -EBUSY;
>> +        }
>> +        entry =3D &e820_reserve.entry[index++];
>> +
>> +        entry->address =3D cpu_to_le64(address);
>> +        entry->length =3D cpu_to_le64(length);
>> +        entry->type =3D cpu_to_le32(type);
>> +
>> +        e820_reserve.count =3D cpu_to_le32(index);
>> +    }
>> +
>> +    /* new "etc/e820" file -- include ram too */
>> +    e820_table =3D g_renew(struct e820_entry, e820_table, e820_entries =
+ 1);
>> +    e820_table[e820_entries].address =3D cpu_to_le64(address);
>> +    e820_table[e820_entries].length =3D cpu_to_le64(length);
>> +    e820_table[e820_entries].type =3D cpu_to_le32(type);
>> +    e820_entries++;
>> +
>> +    return e820_entries;
>> +}
>> +
>> +int e820_get_num_entries(void)
>> +{
>> +    return e820_entries;
>> +}
>> +
>> +bool e820_get_entry(int idx, uint32_t type, uint64_t *address, uint64_t=
 *length)
>> +{
>> +    if (idx < e820_entries && e820_table[idx].type =3D=3D cpu_to_le32(t=
ype)) {
>> +        *address =3D le64_to_cpu(e820_table[idx].address);
>> +        *length =3D le64_to_cpu(e820_table[idx].length);
>> +        return true;
>> +    }
>> +    return false;
>> +}
>> +
>> +void e820_create_fw_entry(FWCfgState *fw_cfg)
>> +{
>> +    fw_cfg_add_bytes(fw_cfg, FW_CFG_E820_TABLE,
>> +                     &e820_reserve, sizeof(e820_reserve));
>> +    fw_cfg_add_file(fw_cfg, "etc/e820", e820_table,
>> +                    sizeof(struct e820_entry) * e820_entries);
>> +}
>> diff --git a/hw/i386/e820.h b/hw/i386/e820.h
>> new file mode 100644
>> index 0000000000..569d1f0ab5
>> --- /dev/null
>> +++ b/hw/i386/e820.h
>> @@ -0,0 +1,11 @@
>> +/* e820 types */
>> +#define E820_RAM        1
>> +#define E820_RESERVED   2
>> +#define E820_ACPI       3
>> +#define E820_NVS        4
>> +#define E820_UNUSABLE   5
>> +
>> +int e820_add_entry(uint64_t address, uint64_t length, uint32_t type);
>> +int e820_get_num_entries(void);
>> +bool e820_get_entry(int idx, uint32_t type, uint64_t *address, uint64_t=
 *length);
>> +void e820_create_fw_entry(FWCfgState *fw_cfg);
>> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
>> index 10e4ced0c6..3920aa7e85 100644
>> --- a/hw/i386/pc.c
>> +++ b/hw/i386/pc.c
>> @@ -30,6 +30,7 @@
>>  #include "hw/i386/apic.h"
>>  #include "hw/i386/topology.h"
>>  #include "hw/i386/fw_cfg.h"
>> +#include "hw/i386/e820.h"
>>  #include "sysemu/cpus.h"
>>  #include "hw/block/fdc.h"
>>  #include "hw/ide.h"
>> @@ -99,22 +100,6 @@
>>  #define DPRINTF(fmt, ...)
>>  #endif
>>=20=20
>> -#define E820_NR_ENTRIES		16
>> -
>> -struct e820_entry {
>> -    uint64_t address;
>> -    uint64_t length;
>> -    uint32_t type;
>> -} QEMU_PACKED __attribute((__aligned__(4)));
>> -
>> -struct e820_table {
>> -    uint32_t count;
>> -    struct e820_entry entry[E820_NR_ENTRIES];
>> -} QEMU_PACKED __attribute((__aligned__(4)));
>> -
>> -static struct e820_table e820_reserve;
>> -static struct e820_entry *e820_table;
>> -static unsigned e820_entries;
>>  struct hpet_fw_config hpet_cfg =3D {.count =3D UINT8_MAX};
>>=20=20
>>  GlobalProperty pc_compat_4_1[] =3D {};
>> @@ -878,50 +863,6 @@ static void handle_a20_line_change(void *opaque, in=
t irq, int level)
>>      x86_cpu_set_a20(cpu, level);
>>  }
>>=20=20
>> -int e820_add_entry(uint64_t address, uint64_t length, uint32_t type)
>> -{
>> -    int index =3D le32_to_cpu(e820_reserve.count);
>> -    struct e820_entry *entry;
>> -
>> -    if (type !=3D E820_RAM) {
>> -        /* old FW_CFG_E820_TABLE entry -- reservations only */
>> -        if (index >=3D E820_NR_ENTRIES) {
>> -            return -EBUSY;
>> -        }
>> -        entry =3D &e820_reserve.entry[index++];
>> -
>> -        entry->address =3D cpu_to_le64(address);
>> -        entry->length =3D cpu_to_le64(length);
>> -        entry->type =3D cpu_to_le32(type);
>> -
>> -        e820_reserve.count =3D cpu_to_le32(index);
>> -    }
>> -
>> -    /* new "etc/e820" file -- include ram too */
>> -    e820_table =3D g_renew(struct e820_entry, e820_table, e820_entries =
+ 1);
>> -    e820_table[e820_entries].address =3D cpu_to_le64(address);
>> -    e820_table[e820_entries].length =3D cpu_to_le64(length);
>> -    e820_table[e820_entries].type =3D cpu_to_le32(type);
>> -    e820_entries++;
>> -
>> -    return e820_entries;
>> -}
>> -
>> -int e820_get_num_entries(void)
>> -{
>> -    return e820_entries;
>> -}
>> -
>> -bool e820_get_entry(int idx, uint32_t type, uint64_t *address, uint64_t=
 *length)
>> -{
>> -    if (idx < e820_entries && e820_table[idx].type =3D=3D cpu_to_le32(t=
ype)) {
>> -        *address =3D le64_to_cpu(e820_table[idx].address);
>> -        *length =3D le64_to_cpu(e820_table[idx].length);
>> -        return true;
>> -    }
>> -    return false;
>> -}
>> -
>>  /* Calculates initial APIC ID for a specific CPU index
>>   *
>>   * Currently we need to be able to calculate the APIC ID from the CPU i=
ndex
>> @@ -1024,10 +965,7 @@ static FWCfgState *bochs_bios_init(AddressSpace *a=
s, PCMachineState *pcms)
>>                       acpi_tables, acpi_tables_len);
>>      fw_cfg_add_i32(fw_cfg, FW_CFG_IRQ0_OVERRIDE, kvm_allows_irq0_overri=
de());
>>=20=20
>> -    fw_cfg_add_bytes(fw_cfg, FW_CFG_E820_TABLE,
>> -                     &e820_reserve, sizeof(e820_reserve));
>> -    fw_cfg_add_file(fw_cfg, "etc/e820", e820_table,
>> -                    sizeof(struct e820_entry) * e820_entries);
>> +    e820_create_fw_entry(fw_cfg);
>>=20=20
>>      fw_cfg_add_bytes(fw_cfg, FW_CFG_HPET, &hpet_cfg, sizeof(hpet_cfg));
>>      /* allocate memory for the NUMA channel: one (64bit) word for the n=
umber
>> diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
>> index 19a837889d..062feeb69e 100644
>> --- a/include/hw/i386/pc.h
>> +++ b/include/hw/i386/pc.h
>> @@ -291,17 +291,6 @@ void pc_system_firmware_init(PCMachineState *pcms, =
MemoryRegion *rom_memory);
>>  void pc_madt_cpu_entry(AcpiDeviceIf *adev, int uid,
>>                         const CPUArchIdList *apic_ids, GArray *entry);
>>=20=20
>> -/* e820 types */
>> -#define E820_RAM        1
>> -#define E820_RESERVED   2
>> -#define E820_ACPI       3
>> -#define E820_NVS        4
>> -#define E820_UNUSABLE   5
>> -
>> -int e820_add_entry(uint64_t, uint64_t, uint32_t);
>> -int e820_get_num_entries(void);
>> -bool e820_get_entry(int, uint32_t, uint64_t *, uint64_t *);
>> -
>>  extern GlobalProperty pc_compat_4_1[];
>>  extern const size_t pc_compat_4_1_len;
>>=20=20
>> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
>> index 8023c679ea..8ce56db7d4 100644
>> --- a/target/i386/kvm.c
>> +++ b/target/i386/kvm.c
>> @@ -41,6 +41,7 @@
>>  #include "hw/i386/apic-msidef.h"
>>  #include "hw/i386/intel_iommu.h"
>>  #include "hw/i386/x86-iommu.h"
>> +#include "hw/i386/e820.h"
>>=20=20
>>  #include "hw/pci/pci.h"
>>  #include "hw/pci/msi.h"
>>=20


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAl2KJF0ACgkQ9GknjS8M
AjV3xA//ZgGDmb8f9cMYCWCj9g5M2D666mtmIVQEXZdW/LvdIhRfp+Lk6L9DAD71
dtNfjLEnSRYdEsVvRcokxfV18EEXRncDPRYknI55W5Ylk7bEpUrkh0LRgH6wSzPS
9pfur/jkBxJkSITd0tjlekpItKYsBdOzIaOyNpwIKjZvLs2XFL7DKrRZ82Lyhesv
/T0NwfJLxY9mPOcBi1aMNMjM3WV5ywZGv0Xj4/WpG9C8ZmCVphxbgPLIUg2h4jH0
irnddGbJvXekBC7kPKE1jr5Hn6FoMWAI7yBo9ld6Ng8raYJRJP+Swkix74vVlokt
vYR4m12qAauuD3TIjj654FuzJMH7EfQOZXXI4rIe3ak93l32Sgb54PGd8vLDaOKH
y2ZwtnEtb4qveBK/xGVxkojfNvBYqw+XctLzyjYkZ4TwIHhS+R2+75LCAP2z9fKp
vFCrS45UL/Fy5PSRocfp+9BrTGD306y9X1QU5W0BhEiSkcCwbiP11Feydmbv3LLE
xfNTHYn64Q/zyqvPh+9lM353ZPkBVGW9+54cwulyIofzcPrrPU9NDBVQhUOHpSkR
7AmIgpJDULJtktefSxj4oNDkii0SZ3HHkHVoBbrPlE3/pxsdUaOzg6wBWqE5s7IC
Fz5lJpLb2nS+RKr4TvgWWgkVH6aPp4Uf1ih11TZA/bR3jiEekOg=
=KQfs
-----END PGP SIGNATURE-----
--=-=-=--
