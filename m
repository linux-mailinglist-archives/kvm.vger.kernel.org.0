Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2151C7B27
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 22:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729073AbgEFUXf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 16:23:35 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34294 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728231AbgEFUXe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 16:23:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588796612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7CHDA2MfClJT1ewMQFWsuEj5A2IA4sO3+SfzPA41XjY=;
        b=YjwzKPu/Tc8EjrwFJj6wQ9tPQRl64qTqrCu99c6cjArlSYkh2eda+XFinD4xAdBTXR3ddn
        oJr7ZmzXrixzx/c9/1tLCFtSZ0UX5DFw0g7oFGrgvlTOkYmfaa0FkdwJZn389Wprxbc36u
        lJ3inaRKF5djeiVkF3u2LOIJKBv6r30=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-TbPB_ew1PMG0pHD5ySfVpg-1; Wed, 06 May 2020 16:23:30 -0400
X-MC-Unique: TbPB_ew1PMG0pHD5ySfVpg-1
Received: by mail-wr1-f72.google.com with SMTP id g10so1913657wrr.10
        for <kvm@vger.kernel.org>; Wed, 06 May 2020 13:23:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7CHDA2MfClJT1ewMQFWsuEj5A2IA4sO3+SfzPA41XjY=;
        b=gVyizCGA9ZLdRn3VKUfKJ7qxUc2P2yDZQXpsGdEUQq/H2K9hSAiunYNsi3wZl2NYpG
         CZFAyaL7ujCc0ljFpd6AmxmKLebmbjod/7JqkVzMId54bT50qRrxPqkdi6ZdusJBnkr8
         WEoRuHMH2/kFoOkx7KAdFPTfpKaLpKHUIIIFx7nAboa9OZ3bRwZXRXswp67OFc570RWF
         H5tmsyGlPtnqv+VgHDOjkhuZOHDYsV8DPx21Je6BnixjGwMdmVEUJ6ml21cvY+yujsaa
         au2g/14U4J/sKsnYjeNxmIHVxZZbjX2iRrauCUUkw4jSf1LpFqhSGa78nPOUjeiEun29
         UfRw==
X-Gm-Message-State: AGi0PubEjzVOHCa9T2QXr0Vv7vso/DS0LD3QTna1YJMwWVvI90FjKgaq
        E1HPlCuMeK4cydiCAw8lIYBKLHYkroVF4QQJa65UKld+7lM5r31Q0G6eG7kNqiuWmMxM0ERFIr8
        6rq1cH6FP32Q4
X-Received: by 2002:a7b:c766:: with SMTP id x6mr6527947wmk.142.1588796609016;
        Wed, 06 May 2020 13:23:29 -0700 (PDT)
X-Google-Smtp-Source: APiQypJaps9zwx1oAMIXNTa50JuFXRc9OtfdLT5grh9KOLMkoLE5ptxgYrPc6/l2hdY3ZLd3UOd+TA==
X-Received: by 2002:a7b:c766:: with SMTP id x6mr6527925wmk.142.1588796608706;
        Wed, 06 May 2020 13:23:28 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id v10sm4431814wrq.45.2020.05.06.13.23.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 13:23:28 -0700 (PDT)
Date:   Wed, 6 May 2020 16:23:25 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Dongjiu Geng <gengdongjiu@huawei.com>
Cc:     imammedo@redhat.com, xiaoguangrong.eric@gmail.com,
        peter.maydell@linaro.org, shannon.zhaosl@gmail.com, fam@euphon.net,
        rth@twiddle.net, ehabkost@redhat.com, mtosatti@redhat.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
        pbonzini@redhat.com, zhengxiang9@huawei.com,
        Jonathan.Cameron@huawei.com, linuxarm@huawei.com
Subject: Re: [PATCH v25 08/10] ACPI: Record Generic Error Status Block(GESB)
 table
Message-ID: <20200506162320-mutt-send-email-mst@kernel.org>
References: <20200410114639.32844-1-gengdongjiu@huawei.com>
 <20200410114639.32844-9-gengdongjiu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200410114639.32844-9-gengdongjiu@huawei.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 10, 2020 at 07:46:37PM +0800, Dongjiu Geng wrote:
> kvm_arch_on_sigbus_vcpu() error injection uses source_id as
> index in etc/hardware_errors to find out Error Status Data
> Block entry corresponding to error source. So supported source_id
> values should be assigned here and not be changed afterwards to
> make sure that guest will write error into expected Error Status
> Data Block.
> 
> Before QEMU writes a new error to ACPI table, it will check whether
> previous error has been acknowledged. If not acknowledged, the new
> errors will be ignored and not be recorded. For the errors section
> type, QEMU simulate it to memory section error.
> 
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>

Reviewed-by: Michael S. Tsirkin <mst@redhat.com>

> ---
> change since v24:
> 1. Using g_array_append_vals() to replace build_append_int_noprefix() to build FRU Text.
> 2. Remove the judgement that judge whether acpi_ged_state is NULL.
> 3. Add le64_to_cpu() to error_block_address
> ---
>  hw/acpi/ghes.c         | 219 +++++++++++++++++++++++++++++++++++++++++++++++++
>  include/hw/acpi/ghes.h |   1 +
>  2 files changed, 220 insertions(+)
> 
> diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
> index e74af23..a3ab2e4 100644
> --- a/hw/acpi/ghes.c
> +++ b/hw/acpi/ghes.c
> @@ -26,6 +26,7 @@
>  #include "qemu/error-report.h"
>  #include "hw/acpi/generic_event_device.h"
>  #include "hw/nvram/fw_cfg.h"
> +#include "qemu/uuid.h"
>  
>  #define ACPI_GHES_ERRORS_FW_CFG_FILE        "etc/hardware_errors"
>  #define ACPI_GHES_DATA_ADDR_FW_CFG_FILE     "etc/hardware_errors_addr"
> @@ -43,6 +44,36 @@
>  #define GAS_ADDR_OFFSET 4
>  
>  /*
> + * The total size of Generic Error Data Entry
> + * ACPI 6.1/6.2: 18.3.2.7.1 Generic Error Data,
> + * Table 18-343 Generic Error Data Entry
> + */
> +#define ACPI_GHES_DATA_LENGTH               72
> +
> +/* The memory section CPER size, UEFI 2.6: N.2.5 Memory Error Section */
> +#define ACPI_GHES_MEM_CPER_LENGTH           80
> +
> +/* Masks for block_status flags */
> +#define ACPI_GEBS_UNCORRECTABLE         1
> +
> +/*
> + * Total size for Generic Error Status Block except Generic Error Data Entries
> + * ACPI 6.2: 18.3.2.7.1 Generic Error Data,
> + * Table 18-380 Generic Error Status Block
> + */
> +#define ACPI_GHES_GESB_SIZE                 20
> +
> +/*
> + * Values for error_severity field
> + */
> +enum AcpiGenericErrorSeverity {
> +    ACPI_CPER_SEV_RECOVERABLE = 0,
> +    ACPI_CPER_SEV_FATAL = 1,
> +    ACPI_CPER_SEV_CORRECTED = 2,
> +    ACPI_CPER_SEV_NONE = 3,
> +};
> +
> +/*
>   * Hardware Error Notification
>   * ACPI 4.0: 17.3.2.7 Hardware Error Notification
>   * Composes dummy Hardware Error Notification descriptor of specified type
> @@ -73,6 +104,138 @@ static void build_ghes_hw_error_notification(GArray *table, const uint8_t type)
>  }
>  
>  /*
> + * Generic Error Data Entry
> + * ACPI 6.1: 18.3.2.7.1 Generic Error Data
> + */
> +static void acpi_ghes_generic_error_data(GArray *table,
> +                const uint8_t *section_type, uint32_t error_severity,
> +                uint8_t validation_bits, uint8_t flags,
> +                uint32_t error_data_length, QemuUUID fru_id,
> +                uint64_t time_stamp)
> +{
> +    const uint8_t fru_text[20] = {0};
> +
> +    /* Section Type */
> +    g_array_append_vals(table, section_type, 16);
> +
> +    /* Error Severity */
> +    build_append_int_noprefix(table, error_severity, 4);
> +    /* Revision */
> +    build_append_int_noprefix(table, 0x300, 2);
> +    /* Validation Bits */
> +    build_append_int_noprefix(table, validation_bits, 1);
> +    /* Flags */
> +    build_append_int_noprefix(table, flags, 1);
> +    /* Error Data Length */
> +    build_append_int_noprefix(table, error_data_length, 4);
> +
> +    /* FRU Id */
> +    g_array_append_vals(table, fru_id.data, ARRAY_SIZE(fru_id.data));
> +
> +    /* FRU Text */
> +    g_array_append_vals(table, fru_text, sizeof(fru_text));
> +
> +    /* Timestamp */
> +    build_append_int_noprefix(table, time_stamp, 8);
> +}
> +
> +/*
> + * Generic Error Status Block
> + * ACPI 6.1: 18.3.2.7.1 Generic Error Data
> + */
> +static void acpi_ghes_generic_error_status(GArray *table, uint32_t block_status,
> +                uint32_t raw_data_offset, uint32_t raw_data_length,
> +                uint32_t data_length, uint32_t error_severity)
> +{
> +    /* Block Status */
> +    build_append_int_noprefix(table, block_status, 4);
> +    /* Raw Data Offset */
> +    build_append_int_noprefix(table, raw_data_offset, 4);
> +    /* Raw Data Length */
> +    build_append_int_noprefix(table, raw_data_length, 4);
> +    /* Data Length */
> +    build_append_int_noprefix(table, data_length, 4);
> +    /* Error Severity */
> +    build_append_int_noprefix(table, error_severity, 4);
> +}
> +
> +/* UEFI 2.6: N.2.5 Memory Error Section */
> +static void acpi_ghes_build_append_mem_cper(GArray *table,
> +                                            uint64_t error_physical_addr)
> +{
> +    /*
> +     * Memory Error Record
> +     */
> +
> +    /* Validation Bits */
> +    build_append_int_noprefix(table,
> +                              (1ULL << 14) | /* Type Valid */
> +                              (1ULL << 1) /* Physical Address Valid */,
> +                              8);
> +    /* Error Status */
> +    build_append_int_noprefix(table, 0, 8);
> +    /* Physical Address */
> +    build_append_int_noprefix(table, error_physical_addr, 8);
> +    /* Skip all the detailed information normally found in such a record */
> +    build_append_int_noprefix(table, 0, 48);
> +    /* Memory Error Type */
> +    build_append_int_noprefix(table, 0 /* Unknown error */, 1);
> +    /* Skip all the detailed information normally found in such a record */
> +    build_append_int_noprefix(table, 0, 7);
> +}
> +
> +static int acpi_ghes_record_mem_error(uint64_t error_block_address,
> +                                      uint64_t error_physical_addr)
> +{
> +    GArray *block;
> +
> +    /* Memory Error Section Type */
> +    const uint8_t uefi_cper_mem_sec[] =
> +          UUID_LE(0xA5BC1114, 0x6F64, 0x4EDE, 0xB8, 0x63, 0x3E, 0x83, \
> +                  0xED, 0x7C, 0x83, 0xB1);
> +
> +    /* invalid fru id: ACPI 4.0: 17.3.2.6.1 Generic Error Data,
> +     * Table 17-13 Generic Error Data Entry
> +     */
> +    QemuUUID fru_id = {};
> +    uint32_t data_length;
> +
> +    block = g_array_new(false, true /* clear */, 1);
> +
> +    /* This is the length if adding a new generic error data entry*/
> +    data_length = ACPI_GHES_DATA_LENGTH + ACPI_GHES_MEM_CPER_LENGTH;
> +
> +    /*
> +     * Check whether it will run out of the preallocated memory if adding a new
> +     * generic error data entry
> +     */
> +    if ((data_length + ACPI_GHES_GESB_SIZE) > ACPI_GHES_MAX_RAW_DATA_LENGTH) {
> +        error_report("Not enough memory to record new CPER!!!");
> +        g_array_free(block, true);
> +        return -1;
> +    }
> +
> +    /* Build the new generic error status block header */
> +    acpi_ghes_generic_error_status(block, ACPI_GEBS_UNCORRECTABLE,
> +        0, 0, data_length, ACPI_CPER_SEV_RECOVERABLE);
> +
> +    /* Build this new generic error data entry header */
> +    acpi_ghes_generic_error_data(block, uefi_cper_mem_sec,
> +        ACPI_CPER_SEV_RECOVERABLE, 0, 0,
> +        ACPI_GHES_MEM_CPER_LENGTH, fru_id, 0);
> +
> +    /* Build the memory section CPER for above new generic error data entry */
> +    acpi_ghes_build_append_mem_cper(block, error_physical_addr);
> +
> +    /* Write the generic error data entry into guest memory */
> +    cpu_physical_memory_write(error_block_address, block->data, block->len);
> +
> +    g_array_free(block, true);
> +
> +    return 0;
> +}
> +
> +/*
>   * Build table for the hardware error fw_cfg blob.
>   * Initialize "etc/hardware_errors" and "etc/hardware_errors_addr" fw_cfg blobs.
>   * See docs/specs/acpi_hest_ghes.rst for blobs format.
> @@ -227,3 +390,59 @@ void acpi_ghes_add_fw_cfg(AcpiGhesState *ags, FWCfgState *s,
>      fw_cfg_add_file_callback(s, ACPI_GHES_DATA_ADDR_FW_CFG_FILE, NULL, NULL,
>          NULL, &(ags->ghes_addr_le), sizeof(ags->ghes_addr_le), false);
>  }
> +
> +int acpi_ghes_record_errors(uint8_t source_id, uint64_t physical_address)
> +{
> +    uint64_t error_block_addr, read_ack_register_addr, read_ack_register = 0;
> +    uint64_t start_addr;
> +    bool ret = -1;
> +    AcpiGedState *acpi_ged_state;
> +    AcpiGhesState *ags;
> +
> +    assert(source_id < ACPI_HEST_SRC_ID_RESERVED);
> +
> +    acpi_ged_state = ACPI_GED(object_resolve_path_type("", TYPE_ACPI_GED,
> +                                                       NULL));
> +    g_assert(acpi_ged_state);
> +    ags = &acpi_ged_state->ghes_state;
> +
> +    start_addr = le64_to_cpu(ags->ghes_addr_le);
> +
> +    if (physical_address) {
> +
> +        if (source_id < ACPI_HEST_SRC_ID_RESERVED) {
> +            start_addr += source_id * sizeof(uint64_t);
> +        }
> +
> +        cpu_physical_memory_read(start_addr, &error_block_addr,
> +                                 sizeof(error_block_addr));
> +
> +        error_block_addr = le64_to_cpu(error_block_addr);
> +
> +        read_ack_register_addr = start_addr +
> +            ACPI_GHES_ERROR_SOURCE_COUNT * sizeof(uint64_t);
> +
> +        cpu_physical_memory_read(read_ack_register_addr,
> +                                 &read_ack_register, sizeof(read_ack_register));
> +
> +        /* zero means OSPM does not acknowledge the error */
> +        if (!read_ack_register) {
> +                error_report("OSPM does not acknowledge previous error,"
> +                    " so can not record CPER for current error anymore");
> +        } else if (error_block_addr) {
> +                read_ack_register = cpu_to_le64(0);
> +                /*
> +                 * Clear the Read Ack Register, OSPM will write it to 1 when
> +                 * it acknowledges this error.
> +                 */
> +                cpu_physical_memory_write(read_ack_register_addr,
> +                    &read_ack_register, sizeof(uint64_t));
> +
> +                ret = acpi_ghes_record_mem_error(error_block_addr,
> +                                                 physical_address);
> +        } else
> +                error_report("can not find Generic Error Status Block");
> +    }
> +
> +    return ret;
> +}
> diff --git a/include/hw/acpi/ghes.h b/include/hw/acpi/ghes.h
> index a3420fc..4ad025e 100644
> --- a/include/hw/acpi/ghes.h
> +++ b/include/hw/acpi/ghes.h
> @@ -70,4 +70,5 @@ void build_ghes_error_table(GArray *hardware_errors, BIOSLinker *linker);
>  void acpi_build_hest(GArray *table_data, BIOSLinker *linker);
>  void acpi_ghes_add_fw_cfg(AcpiGhesState *vms, FWCfgState *s,
>                            GArray *hardware_errors);
> +int acpi_ghes_record_errors(uint8_t notify, uint64_t error_physical_addr);
>  #endif
> -- 
> 1.8.3.1

