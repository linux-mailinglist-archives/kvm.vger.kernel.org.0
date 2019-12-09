Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9CC9116D8B
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 14:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbfLINFc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 08:05:32 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:40658 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727038AbfLINFb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Dec 2019 08:05:31 -0500
Received: by mail-il1-f195.google.com with SMTP id b15so12625601ila.7
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2019 05:05:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pq1VnlfgzcHCQJUO32Frg0EdLNprnm9eqLtuA42zu7k=;
        b=feb5SHfGA+O42Pfi3xXO9Rqt5xYzZjznx9mrRC+eUdR2sFjzJRgk6UQfC4n8tb1G7W
         zO+OYzrw7xC4wXhLbgCq9V4ZJ5XfC92+xl95paRQbBBsbz43qudQl9+BVOKkzW6aQdXI
         FZbaKxe4igjH0EOSDjaXODalaVs949GmPhs7c53qjjkbPOra0wvHs4ROlevvToLzbxzb
         e49MJb3Yp7vLNcCNmwfG0Pwdd5Mpfou4XfAYvlw1vgS2s1ok0shCE4PI7p/mZS7hbadp
         bR2jzT5sjyPssQttlC7kt+g3tb+/DjQouBAjEhALtKNAhrPRlpyAOo+bS19M43MeF+hy
         hVMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pq1VnlfgzcHCQJUO32Frg0EdLNprnm9eqLtuA42zu7k=;
        b=KZ8H/aH0iZ1Khj73Fit+jdnnDDAGdyU0iJMRic6ism4A3iMliZWvu9YJEGLmfAVKUr
         Sbz6eN8+O+19rRCuveHHe+PgrWtSNkXxJ+0DgcAKXawp9bnksB/MwCmVcZDrqTX+Zi0o
         rHdIfDAvRSNTPNCilkgJqXQBncBbpw17TGEpVvyh7Y54FF+XtQ72zqOE2xq/jImwQLL+
         6zYO13vpiLjswtO/NTuNBqy9/rK+Nf3QKFBRTFOItgeBq9rI0YMr1uD89Dv3gaIy8mi9
         tJnYgct1/8g5d0isNshn295bCPJEK24qXa0arlzt7i9Ko06G9qbvdiBPFwkMkPsKIZaO
         FEoA==
X-Gm-Message-State: APjAAAV428PMmUktRtUrPHwtbtiimeqHITBTXpZb7g6fMwHg0yJiP70K
        RCSDvQx95h748KtOHJy+aRd/Ky2ocppTsbgIlxpC3w==
X-Google-Smtp-Source: APXvYqzRysTxu6BAnyOdhlOugs6B0yiBfWcE+8peBNltmDcf3EYuCxWSNBXWuukvL1Afr5eHIQI8kAb6QfwN/XraZg0=
X-Received: by 2002:a92:5b5b:: with SMTP id p88mr9272188ilb.307.1575896730283;
 Mon, 09 Dec 2019 05:05:30 -0800 (PST)
MIME-Version: 1.0
References: <20191111014048.21296-1-zhengxiang9@huawei.com>
 <20191111014048.21296-6-zhengxiang9@huawei.com> <CADSWDztF=eaUDNnq8bhnPyTKW1YjAWm4UBaH-NBPkzjnzx0bxg@mail.gmail.com>
 <238ea7b3-9d6d-e3f7-40c9-e3e62b5fb477@huawei.com>
In-Reply-To: <238ea7b3-9d6d-e3f7-40c9-e3e62b5fb477@huawei.com>
From:   Beata Michalska <beata.michalska@linaro.org>
Date:   Mon, 9 Dec 2019 13:05:19 +0000
Message-ID: <CADSWDzvFvS6mYiMhXu2J+u+sUxZaKcCE78EuSggv-VOY7zEN_w@mail.gmail.com>
Subject: Re: [RESEND PATCH v21 5/6] target-arm: kvm64: handle SIGBUS signal
 from kernel or KVM
To:     gengdongjiu <gengdongjiu@huawei.com>
Cc:     Xiang Zheng <zhengxiang9@huawei.com>, pbonzini@redhat.com,
        mst@redhat.com, Igor Mammedov <imammedo@redhat.com>,
        shannon.zhaosl@gmail.com, Peter Maydell <peter.maydell@linaro.org>,
        Laszlo Ersek <lersek@redhat.com>, james.morse@arm.com,
        mtosatti@redhat.com, rth@twiddle.net, ehabkost@redhat.com,
        jonathan.cameron@huawei.com, xuwei5@huawei.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        linuxarm@huawei.com, wanghaibin.wang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 7 Dec 2019 at 09:33, gengdongjiu <gengdongjiu@huawei.com> wrote:
>
>
>
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
> yes, the comments needs to correct.
>
> >
> >> +/* The offset of Data Length in Generic Error Status Block */
> >> +#define ACPI_GHES_GESB_DATA_LENGTH_OFFSET   12
> >> +
> >
> > If those were nicely represented as structures you get the offsets easily
> > without having number of defines. That could simplify the code and make it
> > more readable - see comments below
> >
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
>
> This is due to address Igor's comments. there are two reasons:
> 1. avoid define many structures about APEI/GHES/CPER, so you can see it has very little structures definition in acpi_ghes.h
> 2. using build_append_int_noprefix() to compose the table can avoid considering endian
>
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
>
> Afterwards May be we will many source types to support, so Igor's suggestion is better as shown below.
>
> static const uint8_t ghes_notify2source_id_map[] = {
>     ACPI_HEST_SRC_ID_SEA,
>     ACPI_HEST_SRC_ID_RESERVED
> }
>
>
> >
> >> +        if (source_id != 0xff) {
> >> +            start_addr += source_id * ACPI_GHES_ADDRESS_SIZE;
> >> +        } else {
> >> +            goto out;
> >> +        }
> >> +
> [...]
> >>
> >> +/* Callers must hold the iothread mutex lock */
> >> +static void kvm_inject_arm_sea(CPUState *c)
> >
> > We could enclose this function along with the kvm_arch_on_sigbus_vcpu
> > within ifdef switch for KVM_HAVE_MCE_INJECTION
> >
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
>
> Here we set the FnV to not valid, not to set it to valid.
> because Guest will use the physical address that recorded in APEI table.
>
To be precise : the FnV is  giving the status of FAR - so what you are setting
here is status of 0b0 which means FAR is valid, not FnV on it's own.
And my point was that you are changing the prototype for syn_data_abort_no_iss
just for this case only so I was just thinking that it might not be
worth that, instead
you could just set it here ... or to be more flexible , provide a way
to set specific bits
on demand.


BR
Beata

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
> > .
> >
>
