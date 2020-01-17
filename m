Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 687F9140481
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2020 08:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729100AbgAQHjV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jan 2020 02:39:21 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:54889 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgAQHjV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jan 2020 02:39:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579246758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nh7yv0mjswrLZeLywZrBbXl5YC5cViXMUU6z3ixDojA=;
        b=Ul89oCHrM4CM8CEqkZzLZC2s/jpppsrx6efgA9A7DpYotMspApkU5s/d18JX4biIfq8bkX
        t4jdZwn3kzP6xEBg9NuuZh04fwhGigtiwEg/b9Xzu3wSAdL2qFZU5S9xZqOrrRHH4kEiXU
        +6eSQF8j3t5J7EcmjTioycV6gax7HUI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-_urAG-ntNZqAF-51rOfJnA-1; Fri, 17 Jan 2020 02:39:17 -0500
X-MC-Unique: _urAG-ntNZqAF-51rOfJnA-1
Received: by mail-wr1-f72.google.com with SMTP id f17so10233703wrt.19
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2020 23:39:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Nh7yv0mjswrLZeLywZrBbXl5YC5cViXMUU6z3ixDojA=;
        b=tQSvz/FwPgD3JyjiZTpZCZ8YC17PBGN0d22KLWLxDQ6fVnrAavLME5p5i6S58kN5vX
         TUcaJDDo88fDaF5V2XNuKsvm3//DDI1d45PppWBZtZlIMVPuFWdLU+2zBVtnNFB/x4WJ
         48LJQhCjqleXKK0dOSAi7MQk33kgOVzWWAhWenO66becojX45Db7mQB2n9OXukFHdoo+
         sqDKN6pdhCCntTpLWvnQ7ty/ON2kId1XdxeHTI/0VxJz7t5LtpPqMplBnzm8DPUmqC+L
         3wKo4XurndEr/OaPd4JoCu4RrUwZiRS3qLAkJKTeUc/E5CJ21XdcBQ4MnGN8ukvcxUvT
         ogCQ==
X-Gm-Message-State: APjAAAWsdcB6xIRPswbc+Ow3MCI1ACbZKDP4JWHbrElYw5IIrvZcPBnl
        keczOXH5Idz0kasri+e8MbFhheBC66V5WPniy9Wz0bL8PgE/Lx+gddbs/FIyUUJ9oKfHSHiH9jD
        Fot5pskj2jgvT
X-Received: by 2002:a05:600c:507:: with SMTP id i7mr3170069wmc.135.1579246755464;
        Thu, 16 Jan 2020 23:39:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqwRVFnR13Fkw0BE1sDnOhJiDJN/oCQphmpWIBvF0NM2QbH26ylIP418+RxRX4md8J07H6jY0Q==
X-Received: by 2002:a05:600c:507:: with SMTP id i7mr3170057wmc.135.1579246755221;
        Thu, 16 Jan 2020 23:39:15 -0800 (PST)
Received: from [192.168.1.35] (113.red-83-57-172.dynamicip.rima-tde.net. [83.57.172.113])
        by smtp.gmail.com with ESMTPSA id c2sm32946759wrp.46.2020.01.16.23.39.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2020 23:39:14 -0800 (PST)
Subject: Re: [PATCH v22 5/9] ACPI: Record the Generic Error Status Block
 address
To:     Dongjiu Geng <gengdongjiu@huawei.com>, pbonzini@redhat.com,
        mst@redhat.com, imammedo@redhat.com, shannon.zhaosl@gmail.com,
        peter.maydell@linaro.org, fam@euphon.net, rth@twiddle.net,
        ehabkost@redhat.com, mtosatti@redhat.com, xuwei5@huawei.com,
        jonathan.cameron@huawei.com, james.morse@arm.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org
Cc:     zhengxiang9@huawei.com, linuxarm@huawei.com
References: <1578483143-14905-1-git-send-email-gengdongjiu@huawei.com>
 <1578483143-14905-6-git-send-email-gengdongjiu@huawei.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <11c62b51-7a94-5e34-39c6-60c5e989a63b@redhat.com>
Date:   Fri, 17 Jan 2020 08:39:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1578483143-14905-6-git-send-email-gengdongjiu@huawei.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/8/20 12:32 PM, Dongjiu Geng wrote:
> Record the GHEB address via fw_cfg file, when recording
> a error to CPER, it will use this address to find out
> Generic Error Data Entries and write the error.
> 
> Make the HEST GHES to a GED device.
> 
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
> ---
>   hw/acpi/generic_event_device.c         | 15 ++++++++++++++-
>   hw/acpi/ghes.c                         | 16 ++++++++++++++++
>   hw/arm/virt-acpi-build.c               | 13 ++++++++++++-
>   include/hw/acpi/generic_event_device.h |  2 ++
>   include/hw/acpi/ghes.h                 |  6 ++++++
>   5 files changed, 50 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/acpi/generic_event_device.c b/hw/acpi/generic_event_device.c
> index 9cee90c..9bf37e4 100644
> --- a/hw/acpi/generic_event_device.c
> +++ b/hw/acpi/generic_event_device.c
> @@ -234,12 +234,25 @@ static const VMStateDescription vmstate_ged_state = {
>       }
>   };
>   
> +static const VMStateDescription vmstate_ghes_state = {
> +    .name = "acpi-ghes-state",
> +    .version_id = 1,
> +    .minimum_version_id = 1,
> +    .fields      = (VMStateField[]) {
> +        VMSTATE_UINT64(ghes_addr_le, AcpiGhesState),
> +        VMSTATE_END_OF_LIST()
> +    }
> +};
> +
>   static const VMStateDescription vmstate_acpi_ged = {
>       .name = "acpi-ged",
>       .version_id = 1,
>       .minimum_version_id = 1,
>       .fields = (VMStateField[]) {
> -        VMSTATE_STRUCT(ged_state, AcpiGedState, 1, vmstate_ged_state, GEDState),
> +        VMSTATE_STRUCT(ged_state, AcpiGedState, 1,
> +                       vmstate_ged_state, GEDState),
> +        VMSTATE_STRUCT(ghes_state, AcpiGedState, 1,
> +                       vmstate_ghes_state, AcpiGhesState),
>           VMSTATE_END_OF_LIST(),
>       },
>       .subsections = (const VMStateDescription * []) {
> diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
> index 9d37798..68f4abf 100644
> --- a/hw/acpi/ghes.c
> +++ b/hw/acpi/ghes.c
> @@ -23,6 +23,7 @@
>   #include "hw/acpi/acpi.h"
>   #include "hw/acpi/ghes.h"
>   #include "hw/acpi/aml-build.h"
> +#include "hw/acpi/generic_event_device.h"
>   #include "hw/nvram/fw_cfg.h"
>   #include "sysemu/sysemu.h"
>   #include "qemu/error-report.h"
> @@ -208,3 +209,18 @@ void acpi_build_hest(GArray *table_data, GArray *hardware_errors,
>       build_header(linker, table_data, (void *)(table_data->data + hest_start),
>           "HEST", table_data->len - hest_start, 1, NULL, "");
>   }
> +
> +void acpi_ghes_add_fw_cfg(AcpiGhesState *ags, FWCfgState *s,
> +                            GArray *hardware_error)
> +{
> +    size_t size = 2 * sizeof(uint64_t) + ACPI_GHES_MAX_RAW_DATA_LENGTH;
> +    size_t request_block_size = ACPI_GHES_ERROR_SOURCE_COUNT * size;
> +
> +    /* Create a read-only fw_cfg file for GHES */
> +    fw_cfg_add_file(s, ACPI_GHES_ERRORS_FW_CFG_FILE, hardware_error->data,
> +                    request_block_size);
> +
> +    /* Create a read-write fw_cfg file for Address */
> +    fw_cfg_add_file_callback(s, ACPI_GHES_DATA_ADDR_FW_CFG_FILE, NULL, NULL,
> +        NULL, &(ags->ghes_addr_le), sizeof(ags->ghes_addr_le), false);
> +}
> diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
> index 837bbf9..c8aa94d 100644
> --- a/hw/arm/virt-acpi-build.c
> +++ b/hw/arm/virt-acpi-build.c
> @@ -797,6 +797,7 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
>       unsigned dsdt, xsdt;
>       GArray *tables_blob = tables->table_data;
>       MachineState *ms = MACHINE(vms);
> +    AcpiGedState *acpi_ged_state;
>   
>       table_offsets = g_array_new(false, true /* clear */,
>                                           sizeof(uint32_t));
> @@ -831,7 +832,9 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
>       acpi_add_table(table_offsets, tables_blob);
>       build_spcr(tables_blob, tables->linker, vms);
>   
> -    if (vms->ras) {
> +    acpi_ged_state = ACPI_GED(object_resolve_path_type("", TYPE_ACPI_GED,
> +                                                       NULL));

Testing vms->ras first is cheaper than calling 
object_resolve_path_type(). Since some people are spending lot of time 
to reduce VM boot time, it might be worth considering.

> +    if (acpi_ged_state &&  vms->ras) {
>           acpi_add_table(table_offsets, tables_blob);
>           build_ghes_error_table(tables->hardware_errors, tables->linker);
>           acpi_build_hest(tables_blob, tables->hardware_errors,
> @@ -925,6 +928,7 @@ void virt_acpi_setup(VirtMachineState *vms)
>   {
>       AcpiBuildTables tables;
>       AcpiBuildState *build_state;
> +    AcpiGedState *acpi_ged_state;
>   
>       if (!vms->fw_cfg) {
>           trace_virt_acpi_setup();
> @@ -955,6 +959,13 @@ void virt_acpi_setup(VirtMachineState *vms)
>       fw_cfg_add_file(vms->fw_cfg, ACPI_BUILD_TPMLOG_FILE, tables.tcpalog->data,
>                       acpi_data_len(tables.tcpalog));
>   
> +    acpi_ged_state = ACPI_GED(object_resolve_path_type("", TYPE_ACPI_GED,
> +                                                       NULL));
> +    if (acpi_ged_state && vms->ras) {
> +        acpi_ghes_add_fw_cfg(&acpi_ged_state->ghes_state,
> +                             vms->fw_cfg, tables.hardware_errors);
> +    }
> +
>       build_state->rsdp_mr = acpi_add_rom_blob(virt_acpi_build_update,
>                                                build_state, tables.rsdp,
>                                                ACPI_BUILD_RSDP_FILE, 0);
> diff --git a/include/hw/acpi/generic_event_device.h b/include/hw/acpi/generic_event_device.h
> index d157eac..037d2b5 100644
> --- a/include/hw/acpi/generic_event_device.h
> +++ b/include/hw/acpi/generic_event_device.h
> @@ -61,6 +61,7 @@
>   
>   #include "hw/sysbus.h"
>   #include "hw/acpi/memory_hotplug.h"
> +#include "hw/acpi/ghes.h"
>   
>   #define ACPI_POWER_BUTTON_DEVICE "PWRB"
>   
> @@ -95,6 +96,7 @@ typedef struct AcpiGedState {
>       GEDState ged_state;
>       uint32_t ged_event_bitmap;
>       qemu_irq irq;
> +    AcpiGhesState ghes_state;
>   } AcpiGedState;
>   
>   void build_ged_aml(Aml *table, const char* name, HotplugHandler *hotplug_dev,
> diff --git a/include/hw/acpi/ghes.h b/include/hw/acpi/ghes.h
> index 09a7f86..a6761e6 100644
> --- a/include/hw/acpi/ghes.h
> +++ b/include/hw/acpi/ghes.h
> @@ -60,7 +60,13 @@ enum {
>       ACPI_HEST_SRC_ID_RESERVED,
>   };
>   
> +typedef struct AcpiGhesState {
> +    uint64_t ghes_addr_le;
> +} AcpiGhesState;
> +
>   void build_ghes_error_table(GArray *hardware_errors, BIOSLinker *linker);
>   void acpi_build_hest(GArray *table_data, GArray *hardware_error,
>                             BIOSLinker *linker);
> +void acpi_ghes_add_fw_cfg(AcpiGhesState *vms, FWCfgState *s,
> +                          GArray *hardware_errors);
>   #endif
> 

