Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20A4C107521
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 16:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbfKVPoS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 10:44:18 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:44798 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfKVPoR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 10:44:17 -0500
Received: by mail-io1-f65.google.com with SMTP id j20so8451687ioo.11
        for <kvm@vger.kernel.org>; Fri, 22 Nov 2019 07:44:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=g9f0ujU0vBAbeeTaxcef1LrvqapMSonaO3UV+dEMt+I=;
        b=o4Azwy8kme4L35JG14/I/WUu6/lRXdvRKtysNmMPp/3FCgUYXyjrxpfZU0Rpu/198b
         F+VEjmNgPEx73Pe/1AjwFcfUQ0ieQQSvwXO2Fug3YfIoKX+MOImNCGIha3h1tMZtW1tP
         E2T8IAmdLN34TQt/o323HE44wYSIZ2dR+rOLj8QymHCXCzlr4r/j+e+2dnUw6tdsa19W
         TnuBHsmN+NIc8ainV2UDq8Ut9uifGOscUlxsQVgFIOy5sPVLD/bIAR5cLZanCERsdLvB
         S+XF/xO5x2/05gGYIUfD7RhcUN3lozyx9imDE9+rDQogkQ0kDp4cDxct/eCSnaTDIp7X
         yJhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=g9f0ujU0vBAbeeTaxcef1LrvqapMSonaO3UV+dEMt+I=;
        b=cyL7L1Ih9EnBWwNOrg5Va7sdVuSJLqbkioPdyeKSdXVeTW05cwlVzeH0FoB2zaem8f
         YZ3p7DLeX+pxk0sWQniFvGFH2POxOHOqtOB6rhzL4U8LluPAG5wsCzfbNBfg3SrWvEHx
         txkOOAKmk7PKXzStx0JW8gI2T66DORzWDcU2qxOQ4JXGjUca8dWLoj7Mg8VFLujO3WRj
         Yv0B8Jfy7mpujt2FeiHvNtPUqgGHKDc1BUZQRojMbOEgvTm78Ra9t3pb6nIs8x55GkTn
         UamqO6A0q/dEHx2R7Y66u0XiobbPRUcNZp2vuvRaJaJuzR+VIJzxBQcGpWiqgo4M6tLy
         JqHA==
X-Gm-Message-State: APjAAAXLKem5mI4pHYR7ktRuWpIV9btnYFUqaKpxoapasEv2Ck8AybnF
        N4zGKCM2k5XIVgt/wDF4eRMmZ3s9Y6v9z8QWDpZn7A==
X-Google-Smtp-Source: APXvYqyqLMScabCQfULqWeXJKp10grTApZ6mt9P+4EovikRY2w5RiUNsjjY8sQeLo/oWQTwUvjCs54JA59HDU2cK0HQ=
X-Received: by 2002:a02:7086:: with SMTP id f128mr10990542jac.128.1574437456219;
 Fri, 22 Nov 2019 07:44:16 -0800 (PST)
MIME-Version: 1.0
References: <20191111014048.21296-1-zhengxiang9@huawei.com>
 <20191111014048.21296-4-zhengxiang9@huawei.com> <20191115103801.547fc84d@redhat.com>
 <cf5e5aa4-2283-6cf9-70d0-278d167e3a13@huawei.com>
In-Reply-To: <cf5e5aa4-2283-6cf9-70d0-278d167e3a13@huawei.com>
From:   Beata Michalska <beata.michalska@linaro.org>
Date:   Fri, 22 Nov 2019 15:44:05 +0000
Message-ID: <CADSWDzvYY7cRZ62N1QEtJz8=KCtCnO9A2vK0rjyn1Opn+KxAwQ@mail.gmail.com>
Subject: Re: [RESEND PATCH v21 3/6] ACPI: Add APEI GHES table generation support
To:     gengdongjiu <gengdongjiu@huawei.com>
Cc:     Igor Mammedov <imammedo@redhat.com>,
        Xiang Zheng <zhengxiang9@huawei.com>,
        Peter Maydell <peter.maydell@linaro.org>, ehabkost@redhat.com,
        kvm@vger.kernel.org, mst@redhat.com, wanghaibin.wang@huawei.com,
        mtosatti@redhat.com, qemu-devel@nongnu.org, linuxarm@huawei.com,
        shannon.zhaosl@gmail.com, qemu-arm@nongnu.org, james.morse@arm.com,
        xuwei5@huawei.com, jonathan.cameron@huawei.com,
        pbonzini@redhat.com, Laszlo Ersek <lersek@redhat.com>,
        rth@twiddle.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Mon, 18 Nov 2019 at 12:50, gengdongjiu <gengdongjiu@huawei.com> wrote:
>
> Hi,Igor,
>    Thanks for you review and time.
>
> >
> >> +    /*
> >> +     * Type:
> >> +     * Generic Hardware Error Source version 2(GHESv2 - Type 10)
> >> +     */
> >> +    build_append_int_noprefix(table_data, ACPI_GHES_SOURCE_GENERIC_ER=
ROR_V2, 2);
> >> +    /*
> >> +     * Source Id
> >
> >> +     * Once we support more than one hardware error sources, we need =
to
> >> +     * increase the value of this field.
> > I'm not sure ^^^ is correct, according to spec it's just unique id per
> > distinct error structure, so we just assign arbitrary values to each
> > declared source and that never changes once assigned.
> The source id is used to distinct the error source, for each source=EF=BC=
=8C the =E2=80=98source id=E2=80=99 is unique=EF=BC=8C
> but different source has different source id. for example, the 'source id=
' of the error source 0 is 0,
> the 'source id' of the error source 1 is 1.
>

I might be wrong but the source id is not a sequence number and it can
have any value as long
as it is unique and the comment 're 'increasing the number' reads bit wrong=
.

>
> >
> > For now I'd make source_id an enum with one member
> >   enum {
> >     ACPI_HEST_SRC_ID_SEA =3D 0,
> >     /* future ids go here */
> >     ACPI_HEST_SRC_ID_RESERVED,
> >   }
> If we only have one error source, we can use enum instead of allocating m=
agic 0.
> But if we have more error source , such as 10 error source. using enum  m=
aybe not a good idea.
>
> for example, if there are 10 error sources, I can just using below loop
>
> for(i=3D0; i< 10; i++)
>    build_ghes_v2=EF=BC=88source_id++=EF=BC=89;
>

You can do that but using enum makes it more readable and maintainable.
Also you can keep the source id as a sequence number but still represent th=
at
with enum, as it has been suggested, and use the 'RESERVED' field for
loop control.
I think it might be also worth to represent the HES type as enum as well :
enum{
    ACPI_HES_TYPE_GHESv2 =3D 10,

};

> >
> > and use that instead of allocating magic 0 at the beginning of the func=
tion.
> >  build_ghes_v2(ACPI_HEST_GHES_SEA);
> > Also add a comment to declaration that already assigned values are not =
to be changed
> >
> >> +     */
> >> +    build_append_int_noprefix(table_data, source_id, 2);
> >> +    /* Related Source Id */
> >> +    build_append_int_noprefix(table_data, 0xffff, 2);
> >> +    /* Flags */
> >> +    build_append_int_noprefix(table_data, 0, 1);
> >> +    /* Enabled */
> >> +    build_append_int_noprefix(table_data, 1, 1);
> >> +
> >> +    /* Number of Records To Pre-allocate */
> >> +    build_append_int_noprefix(table_data, 1, 4);
> >> +    /* Max Sections Per Record */
> >> +    build_append_int_noprefix(table_data, 1, 4);
> >> +    /* Max Raw Data Length */
> >> +    build_append_int_noprefix(table_data, ACPI_GHES_MAX_RAW_DATA_LENG=
TH, 4);
> >> +
> >> +    /* Error Status Address */
> >> +    build_append_gas(table_data, AML_AS_SYSTEM_MEMORY, 0x40, 0,
> >> +                     4 /* QWord access */, 0);
> >> +    bios_linker_loader_add_pointer(linker, ACPI_BUILD_TABLE_FILE,
> >> +        ACPI_GHES_ERROR_STATUS_ADDRESS_OFFSET(hest_start, source_id),
> > it's fine only if GHESv2 is the only entries in HEST, but once
> > other types are added this macro will silently fall apart and
> > cause table corruption.
> >
> > Instead of offset from hest_start, I suggest to use offset relative
> > to GAS structure, here is an idea
> >
> > #define GAS_ADDR_OFFSET 4
> >
> >     off =3D table->len
> >     build_append_gas()
> >     bios_linker_loader_add_pointer(...,
> >         off + GAS_ADDR_OFFSET, ...
> I think your suggestion is good.
>
> >
> >> +        ACPI_GHES_ADDRESS_SIZE, ACPI_GHES_ERRORS_FW_CFG_FILE,
> >> +        source_id * ACPI_GHES_ADDRESS_SIZE);
> >> +
> >> +    /*
> >> +     * Notification Structure
> >> +     * Now only enable ARMv8 SEA notification type
> >> +     */
> >> +    acpi_ghes_build_notify(table_data, ACPI_GHES_NOTIFY_SEA);
> >> +
> >> +    /* Error Status Block Length */
> >> +    build_append_int_noprefix(table_data, ACPI_GHES_MAX_RAW_DATA_LENG=
TH, 4);
> >> +
> >> +    /*
> >> +     * Read Ack Register
> >> +     * ACPI 6.1: 18.3.2.8 Generic Hardware Error Source
> >> +     * version 2 (GHESv2 - Type 10)
> >> +     */
> >> +    build_append_gas(table_data, AML_AS_SYSTEM_MEMORY, 0x40, 0,
> >> +                     4 /* QWord access */, 0);
> >> +    bios_linker_loader_add_pointer(linker, ACPI_BUILD_TABLE_FILE,
> >> +        ACPI_GHES_READ_ACK_REGISTER_ADDRESS_OFFSET(hest_start, 0),
> > ditto
> >
> >> +        ACPI_GHES_ADDRESS_SIZE, ACPI_GHES_ERRORS_FW_CFG_FILE,
> >> +        (ACPI_GHES_ERROR_SOURCE_COUNT + source_id) * ACPI_GHES_ADDRES=
S_SIZE);
> >> +
> >> +    /*
> >> +     * Read Ack Preserve
> >> +     * We only provide the first bit in Read Ack Register to OSPM to =
write
> >> +     * while the other bits are preserved.
> >> +     */
> >> +    build_append_int_noprefix(table_data, ~0x1ULL, 8);
> >> +    /* Read Ack Write */
> >> +    build_append_int_noprefix(table_data, 0x1, 8);
> >> +
> >> +    build_header(linker, table_data, (void *)(table_data->data + hest=
_start),
> >> +        "HEST", table_data->len - hest_start, 1, NULL, "GHES");
> > hest is not GHEST specific so s/GHES/NULL/
> >
> >> +}
> >> +
> >> +static AcpiGhesState ges;
> >> +void acpi_ghes_add_fw_cfg(FWCfgState *s, GArray *hardware_error)
> >> +{
> >> +
> >> +    size_t size =3D 2 * ACPI_GHES_ADDRESS_SIZE + ACPI_GHES_MAX_RAW_DA=
TA_LENGTH;
> >> +    size_t request_block_size =3D ACPI_GHES_ERROR_SOURCE_COUNT * size=
;
> >> +
> >
> >> +    /* Create a read-only fw_cfg file for GHES */
> >> +    fw_cfg_add_file(s, ACPI_GHES_ERRORS_FW_CFG_FILE, hardware_error->=
data,
> >> +                    request_block_size);
> >> +
> >> +    /* Create a read-write fw_cfg file for Address */
> >> +    fw_cfg_add_file_callback(s, ACPI_GHES_DATA_ADDR_FW_CFG_FILE, NULL=
, NULL,
> >> +        NULL, &ges.ghes_addr_le, sizeof(ges.ghes_addr_le), false);
> >> +}
> >> diff --git a/hw/acpi/aml-build.c b/hw/acpi/aml-build.c
> >> index 2c3702b882..3681ec6e3d 100644
> >> --- a/hw/acpi/aml-build.c
> >> +++ b/hw/acpi/aml-build.c
> >> @@ -1578,6 +1578,7 @@ void acpi_build_tables_init(AcpiBuildTables *tab=
les)
> >>      tables->table_data =3D g_array_new(false, true /* clear */, 1);
> >>      tables->tcpalog =3D g_array_new(false, true /* clear */, 1);
> >>      tables->vmgenid =3D g_array_new(false, true /* clear */, 1);
> >> +    tables->hardware_errors =3D g_array_new(false, true /* clear */, =
1);
> >>      tables->linker =3D bios_linker_loader_init();
> >>  }
> >>
> >> @@ -1588,6 +1589,7 @@ void acpi_build_tables_cleanup(AcpiBuildTables *=
tables, bool mfre)
> >>      g_array_free(tables->table_data, true);
> >>      g_array_free(tables->tcpalog, mfre);
> >>      g_array_free(tables->vmgenid, mfre);
> >> +    g_array_free(tables->hardware_errors, mfre);
> >>  }
> >>
> >>  /*
> >> diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
> >> index 4cd50175e0..1b1fd273e4 100644
> >> --- a/hw/arm/virt-acpi-build.c
> >> +++ b/hw/arm/virt-acpi-build.c
> >> @@ -48,6 +48,7 @@
> >>  #include "sysemu/reset.h"
> >>  #include "kvm_arm.h"
> >>  #include "migration/vmstate.h"
> >> +#include "hw/acpi/acpi_ghes.h"
> >>
> >>  #define ARM_SPI_BASE 32
> >>
> >> @@ -825,6 +826,13 @@ void virt_acpi_build(VirtMachineState *vms, AcpiB=
uildTables *tables)
> >>      acpi_add_table(table_offsets, tables_blob);
> >>      build_spcr(tables_blob, tables->linker, vms);
> >>
> >> +    if (vms->ras) {
> >> +        acpi_add_table(table_offsets, tables_blob);
> >> +        acpi_ghes_build_error_table(tables->hardware_errors, tables->=
linker);
> >> +        acpi_ghes_build_hest(tables_blob, tables->hardware_errors,
> >> +                             tables->linker);
> >> +    }
> >> +
> >>      if (ms->numa_state->num_nodes > 0) {
> >>          acpi_add_table(table_offsets, tables_blob);
> >>          build_srat(tables_blob, tables->linker, vms);
> >> @@ -942,6 +950,10 @@ void virt_acpi_setup(VirtMachineState *vms)
> >>      fw_cfg_add_file(vms->fw_cfg, ACPI_BUILD_TPMLOG_FILE, tables.tcpal=
og->data,
> >>                      acpi_data_len(tables.tcpalog));
> >>
> >> +    if (vms->ras) {
> >> +        acpi_ghes_add_fw_cfg(vms->fw_cfg, tables.hardware_errors);
> >> +    }
> >> +
> >>      build_state->rsdp_mr =3D acpi_add_rom_blob(virt_acpi_build_update=
,
> >>                                               build_state, tables.rsdp=
,
> >>                                               ACPI_BUILD_RSDP_FILE, 0)=
;
> >> diff --git a/include/hw/acpi/acpi_ghes.h b/include/hw/acpi/acpi_ghes.h
> >> new file mode 100644
> >> index 0000000000..cb62ec9c7b
> >> --- /dev/null
> >> +++ b/include/hw/acpi/acpi_ghes.h
> >> @@ -0,0 +1,56 @@
> >> +/*
> >> + * Support for generating APEI tables and recording CPER for Guests
> >> + *
> >> + * Copyright (c) 2019 HUAWEI TECHNOLOGIES CO., LTD.
> >> + *
> >> + * Author: Dongjiu Geng <gengdongjiu@huawei.com>
> >> + *
> >> + * This program is free software; you can redistribute it and/or modi=
fy
> >> + * it under the terms of the GNU General Public License as published =
by
> >> + * the Free Software Foundation; either version 2 of the License, or
> >> + * (at your option) any later version.
> >> +
> >> + * This program is distributed in the hope that it will be useful,
> >> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >> + * GNU General Public License for more details.
> >> +
> >> + * You should have received a copy of the GNU General Public License =
along
> >> + * with this program; if not, see <http://www.gnu.org/licenses/>.
> >> + */
> >> +
> >> +#ifndef ACPI_GHES_H
> >> +#define ACPI_GHES_H
> >> +
> >> +#include "hw/acpi/bios-linker-loader.h"
> >> +
> >> +/*
> >> + * Values for Hardware Error Notification Type field
> >> + */
> >> +enum AcpiGhesNotifyType {
> >> +    ACPI_GHES_NOTIFY_POLLED =3D 0,    /* Polled */
> >> +    ACPI_GHES_NOTIFY_EXTERNAL =3D 1,  /* External Interrupt */
> >> +    ACPI_GHES_NOTIFY_LOCAL =3D 2, /* Local Interrupt */
> >> +    ACPI_GHES_NOTIFY_SCI =3D 3,   /* SCI */
> >> +    ACPI_GHES_NOTIFY_NMI =3D 4,   /* NMI */
> >> +    ACPI_GHES_NOTIFY_CMCI =3D 5,  /* CMCI, ACPI 5.0: 18.3.2.7, Table =
18-290 */
> >> +    ACPI_GHES_NOTIFY_MCE =3D 6,   /* MCE, ACPI 5.0: 18.3.2.7, Table 1=
8-290 */
> >> +    /* GPIO-Signal, ACPI 6.0: 18.3.2.7, Table 18-332 */
> >> +    ACPI_GHES_NOTIFY_GPIO =3D 7,
> >> +    /* ARMv8 SEA, ACPI 6.1: 18.3.2.9, Table 18-345 */
> >> +    ACPI_GHES_NOTIFY_SEA =3D 8,
> >> +    /* ARMv8 SEI, ACPI 6.1: 18.3.2.9, Table 18-345 */
> >> +    ACPI_GHES_NOTIFY_SEI =3D 9,
> >> +    /* External Interrupt - GSIV, ACPI 6.1: 18.3.2.9, Table 18-345 */
> >> +    ACPI_GHES_NOTIFY_GSIV =3D 10,
> >> +    /* Software Delegated Exception, ACPI 6.2: 18.3.2.9, Table 18-383=
 */
> >> +    ACPI_GHES_NOTIFY_SDEI =3D 11,
> >> +    ACPI_GHES_NOTIFY_RESERVED =3D 12 /* 12 and greater are reserved *=
/
> >> +};
> > maybe make all comment go on newline, otherwise zoo above look ugly
> sure.
>
> >
> >> +
> >> +void acpi_ghes_build_hest(GArray *table_data, GArray *hardware_error,
> >> +                          BIOSLinker *linker);
> >> +
> >> +void acpi_ghes_build_error_table(GArray *hardware_errors, BIOSLinker =
*linker);
> >> +void acpi_ghes_add_fw_cfg(FWCfgState *s, GArray *hardware_errors);
> >> +#endif
> >> diff --git a/include/hw/acpi/aml-build.h b/include/hw/acpi/aml-build.h
> >> index de4a406568..8f13620701 100644
> >> --- a/include/hw/acpi/aml-build.h
> >> +++ b/include/hw/acpi/aml-build.h
> >> @@ -220,6 +220,7 @@ struct AcpiBuildTables {
> >>      GArray *rsdp;
> >>      GArray *tcpalog;
> >>      GArray *vmgenid;
> >> +    GArray *hardware_errors;
> >>      BIOSLinker *linker;
> >>  } AcpiBuildTables;
> >>
> >
> > .
> >
>
>
