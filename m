Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A532610B0FF
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 15:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbfK0ORW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 09:17:22 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:40259 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbfK0ORW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 09:17:22 -0500
Received: by mail-il1-f196.google.com with SMTP id v17so17289196ilg.7
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2019 06:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QObTP4mLW9Jvr4xsS3SBEsbXUYL9fgpDbO15vOIw4ck=;
        b=w6/PWZTDaBC6B28+ZGtoxCSC50gJRDrbtwLOMgKTwjGBGDJpf2AL9FzU1eV/ZbnT7m
         BraoZzBTsrERXVt44eShLB+NJPkYlVW0DjwaitVldhQx8dnl7P9zOegYqUDELDR/eiyP
         lTAFXih4tUhDrIbaUXb3cSeBAiQFOnYS3hB6SmgJok6PwlmKufDtkZ8F76axPE7Cy+i8
         bE/5vPbwQRx7PGUA0Llh2cmZLIpNKu4m+lEiMbiiLLT/rdZEF4qutu7ASxN2M4MR+dtt
         M8+e2GBZ/R3Z8gbxyQ9jGgvXsteet0zEZMRtMeJ1uwRbSAk2C3hF+jRObUop5/RLKiie
         w4Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QObTP4mLW9Jvr4xsS3SBEsbXUYL9fgpDbO15vOIw4ck=;
        b=Yt5DETb8+rPQpaKJts2v9P6AtJbjppQzHJLs864mX80V7sfPmmwP8srRBPiMXs9Gbo
         WU8HobomNd8CsKF3xw8M2HwUl/v+ah85ept6452CEInYSnbPRhPK/4rzcykOottrjMDs
         07hVdwKHudafbryBtnNbdgKtQm+d2eN+93ger+L0UwPuqVnP5WhCvzMqsCW+BPBBA37K
         5mYakR014VtSaneOu4aHliayIUseXppSI8c7m1RdzMKyWuwiYnFpONOSccdzdXUsiYCM
         V4SUCv13Enxw1AE5/rB0veccI0zhkGV2hWl55RfByqPb9LwWVfMj2WxqpzH7XR39mLSZ
         MrLg==
X-Gm-Message-State: APjAAAU8CDWoMZQv8KY6MMNUSiXJfvwNys9+v6JTDxRzSfcu/c9TFpQ6
        XvcHPjwXC53q6Dmz06YJ0zBmOIfYvV5cdPqerILMZw==
X-Google-Smtp-Source: APXvYqyRoBMOezpopCvm+EOF9M4gCNqeP2xpNgkAFrOKoeGpG6f8dMF5A4Fx8X6nlnP0ctaDCoGIQi4q6UC4J864wOI=
X-Received: by 2002:a92:cd52:: with SMTP id v18mr30980721ilq.69.1574864239578;
 Wed, 27 Nov 2019 06:17:19 -0800 (PST)
MIME-Version: 1.0
References: <20191111014048.21296-1-zhengxiang9@huawei.com>
 <20191111014048.21296-6-zhengxiang9@huawei.com> <CADSWDztF=eaUDNnq8bhnPyTKW1YjAWm4UBaH-NBPkzjnzx0bxg@mail.gmail.com>
 <22a3935a-a672-f8f1-e5be-6c0725f738c4@huawei.com>
In-Reply-To: <22a3935a-a672-f8f1-e5be-6c0725f738c4@huawei.com>
From:   Beata Michalska <beata.michalska@linaro.org>
Date:   Wed, 27 Nov 2019 14:17:08 +0000
Message-ID: <CADSWDzsEFNMKrC6h4=r70KMzG8XX_5DS1CfGBGBCMmOTfu6qyA@mail.gmail.com>
Subject: Re: [RESEND PATCH v21 5/6] target-arm: kvm64: handle SIGBUS signal
 from kernel or KVM
To:     Xiang Zheng <zhengxiang9@huawei.com>
Cc:     pbonzini@redhat.com, mst@redhat.com,
        Igor Mammedov <imammedo@redhat.com>, shannon.zhaosl@gmail.com,
        Peter Maydell <peter.maydell@linaro.org>,
        Laszlo Ersek <lersek@redhat.com>, james.morse@arm.com,
        gengdongjiu <gengdongjiu@huawei.com>, mtosatti@redhat.com,
        rth@twiddle.net, ehabkost@redhat.com, jonathan.cameron@huawei.com,
        xuwei5@huawei.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org, linuxarm@huawei.com,
        wanghaibin.wang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi

On Wed, 27 Nov 2019 at 12:47, Xiang Zheng <zhengxiang9@huawei.com> wrote:
>
> Hi Beata,
>
> Thanks for you review!
>
YAW

> On 2019/11/22 23:47, Beata Michalska wrote:
> > Hi,
> >
> > On Mon, 11 Nov 2019 at 01:48, Xiang Zheng <zhengxiang9@huawei.com> wrote:
> >>
> >> From: Dongjiu Geng <gengdongjiu@huawei.com>
> >>
> >> Add a SIGBUS signal handler. In this handler, it checks the SIGBUS type,
> >> translates the host VA delivered by host to guest PA, then fills this PA
> >> to guest APEI GHES memory, then notifies guest according to the SIGBUS
> >> type.
> >>
> >> When guest accesses the poisoned memory, it will generate a Synchronous
> >> External Abort(SEA). Then host kernel gets an APEI notification and calls
> >> memory_failure() to unmapped the affected page in stage 2, finally
> >> returns to guest.
> >>
> >> Guest continues to access the PG_hwpoison page, it will trap to KVM as
> >> stage2 fault, then a SIGBUS_MCEERR_AR synchronous signal is delivered to
> >> Qemu, Qemu records this error address into guest APEI GHES memory and
> >> notifes guest using Synchronous-External-Abort(SEA).
> >>
> >> In order to inject a vSEA, we introduce the kvm_inject_arm_sea() function
> >> in which we can setup the type of exception and the syndrome information.
> >> When switching to guest, the target vcpu will jump to the synchronous
> >> external abort vector table entry.
> >>
> >> The ESR_ELx.DFSC is set to synchronous external abort(0x10), and the
> >> ESR_ELx.FnV is set to not valid(0x1), which will tell guest that FAR is
> >> not valid and hold an UNKNOWN value. These values will be set to KVM
> >> register structures through KVM_SET_ONE_REG IOCTL.
> >>
> >> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> >> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
> >> Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
> >> ---
> >>  hw/acpi/acpi_ghes.c         | 297 ++++++++++++++++++++++++++++++++++++
> >>  include/hw/acpi/acpi_ghes.h |   4 +
> >>  include/sysemu/kvm.h        |   3 +-
> >>  target/arm/cpu.h            |   4 +
> >>  target/arm/helper.c         |   2 +-
> >>  target/arm/internals.h      |   5 +-
> >>  target/arm/kvm64.c          |  64 ++++++++
> >>  target/arm/tlb_helper.c     |   2 +-
> >>  target/i386/cpu.h           |   2 +
> >>  9 files changed, 377 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/hw/acpi/acpi_ghes.c b/hw/acpi/acpi_ghes.c
> >> index 42c00ff3d3..f5b54990c0 100644
> >> --- a/hw/acpi/acpi_ghes.c
> >> +++ b/hw/acpi/acpi_ghes.c
> >> @@ -39,6 +39,34 @@
> >>  /* The max size in bytes for one error block */
> >>  #define ACPI_GHES_MAX_RAW_DATA_LENGTH       0x1000
> >>
> >> +/*
> >> + * The total size of Generic Error Data Entry
> >> + * ACPI 6.1/6.2: 18.3.2.7.1 Generic Error Data,
> >> + * Table 18-343 Generic Error Data Entry
> >> + */
> >> +#define ACPI_GHES_DATA_LENGTH               72
> >> +
> >> +/*
> >> + * The memory section CPER size,
> >> + * UEFI 2.6: N.2.5 Memory Error Section
> >> + */
> >> +#define ACPI_GHES_MEM_CPER_LENGTH           80
> >> +
> >> +/*
> >> + * Masks for block_status flags
> >> + */
> >> +#define ACPI_GEBS_UNCORRECTABLE         1
> >
> > Why not listing all supported statuses ? Similar to error severity below ?
> >
>
> We now only use the first bit for uncorrectable error. The correctable errors
> are handled in host and would not be delivered to QEMU.
>
> I think it's unnecessary to list all the bit masks.

I'm not sure we are using all the error severity types either, but fair enough.
>
> >> +
> >> +/*
> >> + * Values for error_severity field
> >> + */
> >> +enum AcpiGenericErrorSeverity {
> >> +    ACPI_CPER_SEV_RECOVERABLE,
> >> +    ACPI_CPER_SEV_FATAL,
> >> +    ACPI_CPER_SEV_CORRECTED,
> >> +    ACPI_CPER_SEV_NONE,
> >> +};
> >> +
> >>  /*
> >>   * Now only support ARMv8 SEA notification type error source
> >>   */
> >> @@ -49,6 +77,16 @@
> >>   */
> >>  #define ACPI_GHES_SOURCE_GENERIC_ERROR_V2   10
> >>
> >> +#define UUID_BE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)        \
> >> +    {{{ ((a) >> 24) & 0xff, ((a) >> 16) & 0xff, ((a) >> 8) & 0xff, (a) & 0xff, \
> >> +    ((b) >> 8) & 0xff, (b) & 0xff,                   \
> >> +    ((c) >> 8) & 0xff, (c) & 0xff,                    \
> >> +    (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) } } }
> >> +
> >> +#define UEFI_CPER_SEC_PLATFORM_MEM                   \
> >> +    UUID_BE(0xA5BC1114, 0x6F64, 0x4EDE, 0xB8, 0x63, 0x3E, 0x83, \
> >> +    0xED, 0x7C, 0x83, 0xB1)
> >> +
> >>  /*

As suggested in different thread - could this be also made common with
NVMe code ?
> >>   * | +--------------------------+ 0
> >>   * | |        Header            |
> >> @@ -77,6 +115,174 @@ typedef struct AcpiGhesState {
> >>      uint64_t ghes_addr_le;
> >>  } AcpiGhesState;
> >>
> >> +/*
> >> + * Total size for Generic Error Status Block
> >> + * ACPI 6.2: 18.3.2.7.1 Generic Error Data,
> >> + * Table 18-380 Generic Error Status Block
> >> + */
> >> +#define ACPI_GHES_GESB_SIZE                 20
> >
> > Minor: This is not entirely correct: GEDE is part of GESB so the total length
> > would be ACPI_GHES_GESB_SIZE + n* sizeof(GEDE)
> >
>
> Yes, here it only indicates the total length of Generic Error Status Block structure
> expect "GEDEs".
>
Sure, just the comment might be misleading. That's minor though.

> >> +/* The offset of Data Length in Generic Error Status Block */
> >> +#define ACPI_GHES_GESB_DATA_LENGTH_OFFSET   12
> >> +
> >
> > If those were nicely represented as structures you get the offsets easily
> > without having number of defines. That could simplify the code and make it
> > more readable - see comments below
> >
>
> To address Igor's comment, this macro is useless and I will drop it.
>
> >> +/*
> >> + * Record the value of data length for each error status block to avoid getting
> >> + * this value from guest.
> >> + */
> >> +static uint32_t acpi_ghes_data_length[ACPI_GHES_ERROR_SOURCE_COUNT];
> >> +
> >> +/*
> >> + * Generic Error Data Entry
> >> + * ACPI 6.1: 18.3.2.7.1 Generic Error Data
> >> + */
> >> +static void acpi_ghes_generic_error_data(GArray *table, QemuUUID section_type,
> >> +                uint32_t error_severity, uint16_t revision,
> >> +                uint8_t validation_bits, uint8_t flags,
> >> +                uint32_t error_data_length, QemuUUID fru_id,
> >> +                uint8_t *fru_text, uint64_t time_stamp)
> >
> > Why not just defining a struct that represents the GED entry?
> >
> >> +{
> >> +    QemuUUID uuid_le;
> >> +
> >> +    /* Section Type */
> >> +    uuid_le = qemu_uuid_bswap(section_type);
> >> +    g_array_append_vals(table, uuid_le.data, ARRAY_SIZE(uuid_le.data));
> >> +
> >> +    /* Error Severity */
> >> +    build_append_int_noprefix(table, error_severity, 4);
> >> +    /* Revision */
> >> +    build_append_int_noprefix(table, revision, 2);
> >
> > Minor: According to the spec it seems that the revision number is
> > a fixed value so you could drop that from the parameters....
> > or ... use a struct to represent the data
> >
> >> +    /* Validation Bits */
> >> +    build_append_int_noprefix(table, validation_bits, 1);
> >> +    /* Flags */
> >> +    build_append_int_noprefix(table, flags, 1);
> >> +    /* Error Data Length */
> >> +    build_append_int_noprefix(table, error_data_length, 4);
> >> +
> >> +    /* FRU Id */
> >> +    uuid_le = qemu_uuid_bswap(fru_id);
> >> +    g_array_append_vals(table, uuid_le.data, ARRAY_SIZE(uuid_le.data));
> >> +
> >> +    /* FRU Text */
> >> +    g_array_append_vals(table, fru_text, 20);
> >> +    /* Timestamp */
> >> +    build_append_int_noprefix(table, time_stamp, 8);
> >> +}
> >> +
> >> +/*
> >> + * Generic Error Status Block
> >> + * ACPI 6.1: 18.3.2.7.1 Generic Error Data
> >> + */
> >> +static void acpi_ghes_generic_error_status(GArray *table, uint32_t block_status,
> >> +                uint32_t raw_data_offset, uint32_t raw_data_length,
> >> +                uint32_t data_length, uint32_t error_severity)
> >
> > Same as the above
> >
>
Still believe having a struct could make the code bit more maintainable
and readable ... :)
> >> +{
> >> +    /* Block Status */
> >> +    build_append_int_noprefix(table, block_status, 4);
> >> +    /* Raw Data Offset */
> >> +    build_append_int_noprefix(table, raw_data_offset, 4);
> >> +    /* Raw Data Length */
> >> +    build_append_int_noprefix(table, raw_data_length, 4);
> >> +    /* Data Length */
> >> +    build_append_int_noprefix(table, data_length, 4);
> >> +    /* Error Severity */
> >> +    build_append_int_noprefix(table, error_severity, 4);
> >> +}
> >> +
> >> +/* UEFI 2.6: N.2.5 Memory Error Section */
> >> +static void acpi_ghes_build_append_mem_cper(GArray *table,
> >> +                                            uint64_t error_physical_addr)
> >> +{
> >> +    /*
> >> +     * Memory Error Record
> >> +     */
> >> +
> >> +    /* Validation Bits */
> >> +    build_append_int_noprefix(table,
> >> +                              (1UL << 14) | /* Type Valid */
> >> +                              (1UL << 1) /* Physical Address Valid */,
> >> +                              8);
> >> +    /* Error Status */
> >> +    build_append_int_noprefix(table, 0, 8);
> >
> > Just wondering whether it would be worth to specify the Error Type
> > through the Error Status ?
> >
>
> Error Status relies on the informations from implementation-specific error registers
> which means we need to provide more informations to QEMU to handle.
>
> In current implemention, KVM only delivers BUS_MCEERR_AR type of signal and poisoned
> HVA to userspace(QEMU). If we want to extract more information in QEMU, it requires KVM
> to provide corresponding informations. However KVM is not ready for that now.

Fair enough - thanks.
>
> >> +    /* Physical Address */
> >> +    build_append_int_noprefix(table, error_physical_addr, 8);
> >> +    /* Skip all the detailed information normally found in such a record */
> >> +    build_append_int_noprefix(table, 0, 48);
> >> +    /* Memory Error Type */
> >> +    build_append_int_noprefix(table, 0 /* Unknown error */, 1);
> >> +    /* Skip all the detailed information normally found in such a record */
> >> +    build_append_int_noprefix(table, 0, 7);
> >> +}
> >> +
> >> +static int acpi_ghes_record_mem_error(uint64_t error_block_address,
> >> +                                      uint64_t error_physical_addr,
> >> +                                      uint32_t data_length)
> >> +{
> >> +    GArray *block;
> >> +    uint64_t current_block_length;
> >> +    /* Memory Error Section Type */
> >> +    QemuUUID mem_section_id_le = UEFI_CPER_SEC_PLATFORM_MEM;
> >
> > As already mentioned - mixing LE /w BE
> >
>
> >> +    QemuUUID fru_id = {};
> >> +    uint8_t fru_text[20] = {};
> >> +
> >> +    /*
> >> +     * Generic Error Status Block
> >> +     * | +---------------------+
> >> +     * | |     block_status    |
> >> +     * | +---------------------+
> >> +     * | |    raw_data_offset  |
> >> +     * | +---------------------+
> >> +     * | |    raw_data_length  |
> >> +     * | +---------------------+
> >> +     * | |     data_length     |
> >> +     * | +---------------------+
> >> +     * | |   error_severity    |
> >> +     * | +---------------------+
> >> +     */
> >> +    block = g_array_new(false, true /* clear */, 1);
> >> +
> >> +    /* The current whole length of the generic error status block */
> >> +    current_block_length = ACPI_GHES_GESB_SIZE + data_length;
> >> +
> >> +    /* This is the length if adding a new generic error data entry*/
> >> +    data_length += ACPI_GHES_DATA_LENGTH;
> >> +    data_length += ACPI_GHES_MEM_CPER_LENGTH;
> >> +
> >> +    /*
> >> +     * Check whether it will run out of the preallocated memory if adding a new
> >> +     * generic error data entry
> >> +     */
> >> +    if ((data_length + ACPI_GHES_GESB_SIZE) > ACPI_GHES_MAX_RAW_DATA_LENGTH) {
> >> +        error_report("Record CPER out of boundary!!!");
> >
> > Minor: The error message could be made more accurate, like:
> >     "Not enough memory to record new CPER"
> >
>
> OK.
>
> >> +        return ACPI_GHES_CPER_FAIL;
> >> +    }
> >> +
> >> +    /* Build the new generic error status block header */
> >> +    acpi_ghes_generic_error_status(block, cpu_to_le32(ACPI_GEBS_UNCORRECTABLE),
> >> +        0, 0, cpu_to_le32(data_length), cpu_to_le32(ACPI_CPER_SEV_RECOVERABLE));
> >> +
> >> +    /* Write back above generic error status block header to guest memory */
> >> +    cpu_physical_memory_write(error_block_address, block->data,
> >> +                              block->len);
> >> +
> >> +    /* Add a new generic error data entry */
> >> +
> >> +    data_length = block->len;
> >> +    /* Build this new generic error data entry header */
> >> +    acpi_ghes_generic_error_data(block, mem_section_id_le,
> >> +        cpu_to_le32(ACPI_CPER_SEV_RECOVERABLE), cpu_to_le32(0x300), 0, 0,
> >> +        cpu_to_le32(ACPI_GHES_MEM_CPER_LENGTH), fru_id, fru_text, 0);
> >> +
> >> +    /* Build the memory section CPER for above new generic error data entry */
> >> +    acpi_ghes_build_append_mem_cper(block, error_physical_addr);
> >> +
> >> +    /* Write back above this new generic error data entry to guest memory */
> >> +    cpu_physical_memory_write(error_block_address + current_block_length,
> >> +        block->data + data_length, block->len - data_length);
> >> +
> >
> > As already mentioned and unless I have missed smth (which is highly possible)
> > this will append new records while the GESB is kept 'in-place'. So the
> > used space is
> > only growing.
> >
>
> Yes, we need to address this unlimited growing records.
>
> >> +    g_array_free(block, true);
> >> +
> >> +    return ACPI_GHES_CPER_OK;
> >> +}
> >> +
> >>  /*
> >>   * Hardware Error Notification
> >>   * ACPI 4.0: 17.3.2.7 Hardware Error Notification
> >> @@ -265,3 +471,94 @@ void acpi_ghes_add_fw_cfg(FWCfgState *s, GArray *hardware_error)
> >>      fw_cfg_add_file_callback(s, ACPI_GHES_DATA_ADDR_FW_CFG_FILE, NULL, NULL,
> >>          NULL, &ges.ghes_addr_le, sizeof(ges.ghes_addr_le), false);
> >>  }
> >> +
> >> +bool acpi_ghes_record_errors(uint32_t notify, uint64_t physical_address)
> >> +{
> >> +    uint64_t error_block_addr, read_ack_register_addr, read_ack_register = 0;
> >> +    int loop = 0;
> >> +    uint64_t start_addr = le64_to_cpu(ges.ghes_addr_le);
> >> +    bool ret = ACPI_GHES_CPER_FAIL;
> >> +    uint8_t source_id;
> >> +    const uint8_t error_source_id[] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
> >> +                                        0xff, 0xff,    0, 0xff, 0xff, 0xff};
> >> +
> >
> > I'm not entirely sure why this is needed - se below
> >
>
> >> +    /*
> >> +     * | +---------------------+ ges.ghes_addr_le
> >> +     * | |error_block_address0 |
> >> +     * | +---------------------+ --+--
> >> +     * | |    .............    | ACPI_GHES_ADDRESS_SIZE
> >> +     * | +---------------------+ --+--
> >> +     * | |error_block_addressN |
> >> +     * | +---------------------+
> >> +     * | | read_ack_register0  |
> >> +     * | +---------------------+ --+--
> >> +     * | |   .............     | ACPI_GHES_ADDRESS_SIZE
> >> +     * | +---------------------+ --+--
> >> +     * | | read_ack_registerN  |
> >> +     * | +---------------------+ --+--
> >> +     * | |      CPER           |   |
> >> +     * | |      ....           | ACPI_GHES_MAX_RAW_DATA_LENGT
> >> +     * | |      CPER           |   |
> >> +     * | +---------------------+ --+--
> >> +     * | |    ..........       |
> >> +     * | +---------------------+
> >> +     * | |      CPER           |
> >> +     * | |      ....           |
> >> +     * | |      CPER           |
> >> +     * | +---------------------+
> >> +     */
> >> +    if (physical_address && notify < ACPI_GHES_NOTIFY_RESERVED) {
> >> +        /* Find and check the source id for this new CPER */
> >> +        source_id = error_source_id[notify];
> >
> > Why not using switch case for supported source types ?
> > For the time being only one is being supported. And you only use that to
> > verify that support - seems a bit unnecessary.
> >
>
> Good idea, I think using switch case is much better.
>
> >> +        if (source_id != 0xff) {
> >> +            start_addr += source_id * ACPI_GHES_ADDRESS_SIZE;
> >> +        } else {
> >> +            goto out;
> >> +        }
> >> +
> >> +        cpu_physical_memory_read(start_addr, &error_block_addr,
> >> +                                 ACPI_GHES_ADDRESS_SIZE);
> >> +
> >> +        read_ack_register_addr = start_addr +
> >> +            ACPI_GHES_ERROR_SOURCE_COUNT * ACPI_GHES_ADDRESS_SIZE;
> >> +retry:
> >> +        cpu_physical_memory_read(read_ack_register_addr,
> >> +                                 &read_ack_register, ACPI_GHES_ADDRESS_SIZE);
> >> +
> >> +        /* zero means OSPM does not acknowledge the error */
> >> +        if (!read_ack_register) {
> >> +            if (loop < 3) {
> >> +                usleep(100 * 1000);
> >> +                loop++;
> >> +                goto retry;
> >> +            } else {
> >> +                error_report("OSPM does not acknowledge previous error,"
> >> +                    " so can not record CPER for current error, forcibly"
> >> +                    " acknowledge previous error to avoid blocking next time"
> >> +                    " CPER record! Exit");
> >> +                read_ack_register = 1;
> >> +                cpu_physical_memory_write(read_ack_register_addr,
> >> +                    &read_ack_register, ACPI_GHES_ADDRESS_SIZE);
> >
> > Already mentioned ...
> > This seems to be against the spec. It not only ignores the req
> > for OSPM to acknowledge receiving notifications for previous errors ,
> > but it also loses one of them. Why not caching it somewhere until
> > OSPM acknowledges the old ones ?
> >
>
> Yes, Igor had mentioned this point in the previous comments.
>
> >> +            }
> >> +        } else {
> >> +            if (error_block_addr) {
> >
> > What is the use case for the address not being set ?
> >
>
> Hmmm...I'd add a "error_fatal" in this case.
>
> >> +                read_ack_register = 0;
> >> +                /*
> >> +                 * Clear the Read Ack Register, OSPM will write it to 1 when
> >> +                 * acknowledge this error.
> >> +                 */
> >> +                cpu_physical_memory_write(read_ack_register_addr,
> >> +                    &read_ack_register, ACPI_GHES_ADDRESS_SIZE);
> >
> > If the ack register has been cleared - which is why we end up here ....
> > why writing it back if there is no notification for the system to process ?
> >
>
> Ending up here means the ack register has been acked by OSPM, we need to clear it so
> that OSPM can write it back to 1 at the next time.
>
My bad - missed the zeroing part.

> >> +                ret = acpi_ghes_record_mem_error(error_block_addr,
> >> +                          physical_address, acpi_ghes_data_length[source_id]);
> >> +                if (ret == ACPI_GHES_CPER_OK) {
> >> +                    acpi_ghes_data_length[source_id] +=
> >> +                        (ACPI_GHES_DATA_LENGTH + ACPI_GHES_MEM_CPER_LENGTH);
> >
> > As mentioned .. this will run out of space - some roll-back
> > mechanism is needed to overwrite stale entries
> >
>
> Yes, Igor had mentioned this point too.
>
> >> +                }
> >> +            }
> >> +        }
> >> +    }
> >> +
> >> +out:
> >> +    return ret;
> >> +}
> >> diff --git a/include/hw/acpi/acpi_ghes.h b/include/hw/acpi/acpi_ghes.h
> >> index cb62ec9c7b..8e3c5b879e 100644
> >> --- a/include/hw/acpi/acpi_ghes.h
> >> +++ b/include/hw/acpi/acpi_ghes.h
> >> @@ -24,6 +24,9 @@
> >>
> >>  #include "hw/acpi/bios-linker-loader.h"
> >>
> >> +#define ACPI_GHES_CPER_OK                   1
> >> +#define ACPI_GHES_CPER_FAIL                 0
> >> +
> >
> > Is there really a need to introduce those ?
> >
>
> Don't you think it's more clear than using "1" or "0"? :)
>
> >>  /*
> >>   * Values for Hardware Error Notification Type field
> >>   */
> >> @@ -53,4 +56,5 @@ void acpi_ghes_build_hest(GArray *table_data, GArray *hardware_error,
> >>
> >>  void acpi_ghes_build_error_table(GArray *hardware_errors, BIOSLinker *linker);
> >>  void acpi_ghes_add_fw_cfg(FWCfgState *s, GArray *hardware_errors);
> >> +bool acpi_ghes_record_errors(uint32_t notify, uint64_t error_physical_addr);
> >>  #endif
> >
> > All the above should preferably land in a separate patch
> >
>
> OK.
>
> >> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> >> index 9d143282bc..321ead8115 100644
> >> --- a/include/sysemu/kvm.h
> >> +++ b/include/sysemu/kvm.h
> >> @@ -378,8 +378,7 @@ bool kvm_vcpu_id_is_valid(int vcpu_id);
> >>  /* Returns VCPU ID to be used on KVM_CREATE_VCPU ioctl() */
> >>  unsigned long kvm_arch_vcpu_id(CPUState *cpu);
> >>
> >> -#ifdef TARGET_I386
> >> -#define KVM_HAVE_MCE_INJECTION 1
> >> +#ifdef KVM_HAVE_MCE_INJECTION
> >>  void kvm_arch_on_sigbus_vcpu(CPUState *cpu, int code, void *addr);
> >>  #endif
> >>
> >> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> >> index d844ea21d8..c4fe6ccc63 100644
> >> --- a/target/arm/cpu.h
> >> +++ b/target/arm/cpu.h
> >> @@ -28,6 +28,10 @@
> >>  /* ARM processors have a weak memory model */
> >>  #define TCG_GUEST_DEFAULT_MO      (0)
> >>
> >> +#ifdef TARGET_AARCH64
> >> +#define KVM_HAVE_MCE_INJECTION 1
> >> +#endif
> >> +
> >>  #define EXCP_UDEF            1   /* undefined instruction */
> >>  #define EXCP_SWI             2   /* software interrupt */
> >>  #define EXCP_PREFETCH_ABORT  3
> >> diff --git a/target/arm/helper.c b/target/arm/helper.c
> >> index 63815fc4cf..a9ce97efb1 100644
> >> --- a/target/arm/helper.c
> >> +++ b/target/arm/helper.c
> >> @@ -3005,7 +3005,7 @@ static uint64_t do_ats_write(CPUARMState *env, uint64_t value,
> >>               * Report exception with ESR indicating a fault due to a
> >>               * translation table walk for a cache maintenance instruction.
> >>               */
> >> -            syn = syn_data_abort_no_iss(current_el == target_el,
> >> +            syn = syn_data_abort_no_iss(current_el == target_el, 0,
> >>                                          fi.ea, 1, fi.s1ptw, 1, fsc);
> >>              env->exception.vaddress = value;
> >>              env->exception.fsr = fsr;
> >> diff --git a/target/arm/internals.h b/target/arm/internals.h
> >> index f5313dd3d4..28b8451d6d 100644
> >> --- a/target/arm/internals.h
> >> +++ b/target/arm/internals.h
> >> @@ -451,13 +451,14 @@ static inline uint32_t syn_insn_abort(int same_el, int ea, int s1ptw, int fsc)
> >>          | ARM_EL_IL | (ea << 9) | (s1ptw << 7) | fsc;
> >>  }
> >>
> >> -static inline uint32_t syn_data_abort_no_iss(int same_el,
> >> +static inline uint32_t syn_data_abort_no_iss(int same_el, int fnv,
> >>                                               int ea, int cm, int s1ptw,
> >>                                               int wnr, int fsc)
> >>  {
> >>      return (EC_DATAABORT << ARM_EL_EC_SHIFT) | (same_el << ARM_EL_EC_SHIFT)
> >>             | ARM_EL_IL
> >> -           | (ea << 9) | (cm << 8) | (s1ptw << 7) | (wnr << 6) | fsc;
> >> +           | (fnv << 10) | (ea << 9) | (cm << 8) | (s1ptw << 7)
> >> +           | (wnr << 6) | fsc;
> >>  }
> >>
> >>  static inline uint32_t syn_data_abort_with_iss(int same_el,
> >> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
> >> index 28f6db57d5..c7b7653d3f 100644
> >> --- a/target/arm/kvm64.c
> >> +++ b/target/arm/kvm64.c
> >> @@ -28,6 +28,8 @@
> >>  #include "kvm_arm.h"
> >>  #include "hw/boards.h"
> >>  #include "internals.h"
> >> +#include "hw/acpi/acpi.h"
> >> +#include "hw/acpi/acpi_ghes.h"
> >>
> >>  static bool have_guest_debug;
> >>
> >> @@ -710,6 +712,30 @@ int kvm_arm_cpreg_level(uint64_t regidx)
> >>      return KVM_PUT_RUNTIME_STATE;
> >>  }
> >>
> >> +/* Callers must hold the iothread mutex lock */
> >> +static void kvm_inject_arm_sea(CPUState *c)
> >
> > We could enclose this function along with the kvm_arch_on_sigbus_vcpu
> > within ifdef switch for KVM_HAVE_MCE_INJECTION
> >
>
> Peter suggested to define KVM_HAVE_MCE_INJECTION within ifdef TARGET_AARCH64.
> So isn't KVM_HAVE_MCE_INJECTION always defined in the target/arm/kvm64.c?
>
OK, not sure why I had v7 in mind but the code changes are in kvm64 so all good.
Apologies for the confusion.

> >> +{
> >> +    ARMCPU *cpu = ARM_CPU(c);
> >> +    CPUARMState *env = &cpu->env;
> >> +    CPUClass *cc = CPU_GET_CLASS(c);
> >> +    uint32_t esr;
> >> +    bool same_el;
> >> +
> >> +    c->exception_index = EXCP_DATA_ABORT;
> >> +    env->exception.target_el = 1;
> >> +
> >> +    /*
> >> +     * Set the DFSC to synchronous external abort and set FnV to not valid,
> >> +     * this will tell guest the FAR_ELx is UNKNOWN for this abort.
> >> +     */
> >> +    same_el = arm_current_el(env) == env->exception.target_el;
> >> +    esr = syn_data_abort_no_iss(same_el, 1, 0, 0, 0, 0, 0x10);
> >
> > IINM this is the only use case when FnV is considered to be valid
> > so I'm not convinced it is worth to modify the syn_data_abort_no_iss
> > just for this.
> >
> >> +
> >> +    env->exception.syndrome = esr;
> >> +
> >> +    cc->do_interrupt(c);
> >> +}
> >> +
> >>  #define AARCH64_CORE_REG(x)   (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
> >>                   KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(x))
> >>
> >> @@ -1036,6 +1062,44 @@ int kvm_arch_get_registers(CPUState *cs)
> >>      return ret;
> >>  }
> >>
> >> +void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
> >> +{
> >> +    ram_addr_t ram_addr;
> >> +    hwaddr paddr;
> >> +
> >> +    assert(code == BUS_MCEERR_AR || code == BUS_MCEERR_AO);
> >> +
> >> +    if (acpi_enabled && addr &&
> >> +            object_property_get_bool(qdev_get_machine(), "ras", NULL)) {
> >> +        ram_addr = qemu_ram_addr_from_host(addr);
> >> +        if (ram_addr != RAM_ADDR_INVALID &&
> >> +            kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
> >> +            kvm_hwpoison_page_add(ram_addr);
> >> +            /*
> >> +             * Asynchronous signal will be masked by main thread, so
> >> +             * only handle synchronous signal.
> >> +             */
> >
> > I'm not entirely sure that the comment above is correct (it has been
> > pointed out before). I would expect the AO signal to be handled here as
> > well. Not having proper support to do that just yet is another story but
> > the comment might be bit misleading.
> >
>
> We also expect the AO signal can be handled here. Maybe we could add the comment like:
>
> "Asynchronous signal is masked by main thread now. Once it can be asserted, we could
> handle it." :)
>
Still not entirely there - if I'm not mistaken. Both BUS_MCEERR_AR and
BUS_MVEERR_AO can end up here.
I'm not entirely sure what you mean by "masked by main thread" ? Both will be
handled by sigbus_handler and as such both will end up here either
directly through kvm_on_sigbus
or through kvm_cpu_exec with pending sigbus. Or am I misguided ?

BR
Beata
> >
> >> +            if (code == BUS_MCEERR_AR) {
> >> +                kvm_cpu_synchronize_state(c);
> >> +                if (ACPI_GHES_CPER_FAIL !=
> >> +                    acpi_ghes_record_errors(ACPI_GHES_NOTIFY_SEA, paddr)) {
> >> +                    kvm_inject_arm_sea(c);
> >> +                } else {
> >> +                    fprintf(stderr, "failed to record the error\n");
> >> +                }
> >> +            }
> >> +            return;
> >> +        }
> >> +        fprintf(stderr, "Hardware memory error for memory used by "
> >> +                "QEMU itself instead of guest system!\n");
> >> +    }
> >> +
> >> +    if (code == BUS_MCEERR_AR) {
> >> +        fprintf(stderr, "Hardware memory error!\n");
> >> +        exit(1);
> >> +    }
> >> +}
> >> +
> >>  /* C6.6.29 BRK instruction */
> >>  static const uint32_t brk_insn = 0xd4200000;
> >>
> >> diff --git a/target/arm/tlb_helper.c b/target/arm/tlb_helper.c
> >> index 5feb312941..499672ebbc 100644
> >> --- a/target/arm/tlb_helper.c
> >> +++ b/target/arm/tlb_helper.c
> >> @@ -33,7 +33,7 @@ static inline uint32_t merge_syn_data_abort(uint32_t template_syn,
> >>       * ISV field.
> >>       */
> >>      if (!(template_syn & ARM_EL_ISV) || target_el != 2 || s1ptw) {
> >> -        syn = syn_data_abort_no_iss(same_el,
> >> +        syn = syn_data_abort_no_iss(same_el, 0,
> >>                                      ea, 0, s1ptw, is_write, fsc);
> >>      } else {
> >>          /*
> >> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> >> index 5352c9ff55..f75a210f96 100644
> >> --- a/target/i386/cpu.h
> >> +++ b/target/i386/cpu.h
> >> @@ -29,6 +29,8 @@
> >>  /* The x86 has a strong memory model with some store-after-load re-ordering */
> >>  #define TCG_GUEST_DEFAULT_MO      (TCG_MO_ALL & ~TCG_MO_ST_LD)
> >>
> >> +#define KVM_HAVE_MCE_INJECTION 1
> >> +
> >>  /* Maximum instruction code size */
> >>  #define TARGET_MAX_INSN_SIZE 16
> >>
> >> --
> >> 2.19.1
> >>
> >>
> >>
> >
> > .
> >
>
> --
>
> Thanks,
> Xiang
>
