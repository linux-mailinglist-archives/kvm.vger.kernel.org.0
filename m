Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91D7916BC2D
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 09:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729605AbgBYIsV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 03:48:21 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33474 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729475AbgBYIsV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Feb 2020 03:48:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582620499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8EWoYLKzioWXRMBvu9PrHJEE9hqJweeNrsXbqfhysoI=;
        b=HipSTOs2O2wt9QSTowNH9JeM4hZ56XSLPZ4KwijoZi8QfFXGsLqtQTosMYkGoTzzTvODqG
        Q70NQ7kaSGIiM9rcMMLQ1zO3pcatKY3xgmYK6A0hNGrUBtoAX3QZEFi6tEj0ww2YLDt6tu
        v7tdw9z0syIChnkr9GJgcCmAoZHrUeM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-iFV1Zub2Ney8fOOK6FhD5g-1; Tue, 25 Feb 2020 03:48:14 -0500
X-MC-Unique: iFV1Zub2Ney8fOOK6FhD5g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53D94107ACC4;
        Tue, 25 Feb 2020 08:48:12 +0000 (UTC)
Received: from localhost (unknown [10.43.2.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D3E491840;
        Tue, 25 Feb 2020 08:48:05 +0000 (UTC)
Date:   Tue, 25 Feb 2020 09:48:04 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     Dongjiu Geng <gengdongjiu@huawei.com>
Cc:     <mst@redhat.com>, <xiaoguangrong.eric@gmail.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <fam@euphon.net>, <rth@twiddle.net>, <ehabkost@redhat.com>,
        <mtosatti@redhat.com>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>, <qemu-arm@nongnu.org>,
        <pbonzini@redhat.com>, <james.morse@arm.com>, <lersek@redhat.com>,
        <jonathan.cameron@huawei.com>,
        <shameerali.kolothum.thodi@huawei.com>, <zhengxiang9@huawei.com>
Subject: Re: [PATCH v24 04/10] ACPI: Build related register address fields
 via hardware error fw_cfg blob
Message-ID: <20200225094804.3ae51b86@redhat.com>
In-Reply-To: <20200217131248.28273-5-gengdongjiu@huawei.com>
References: <20200217131248.28273-1-gengdongjiu@huawei.com>
        <20200217131248.28273-5-gengdongjiu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 17 Feb 2020 21:12:42 +0800
Dongjiu Geng <gengdongjiu@huawei.com> wrote:

> This patch builds error_block_address and read_ack_register fields
> in hardware errors table , the error_block_address points to Generic
> Error Status Block(GESB) via bios_linker. The max size for one GESB
> is 1kb in bytes, For more detailed information, please refer to

s/1kb in bytes/1Kb/

> document: docs/specs/acpi_hest_ghes.rst
> 
> Now we only support one Error source, if necessary, we can extend to
> support more.
> 
> Suggested-by: Laszlo Ersek <lersek@redhat.com>
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> ---

otherwise looks fine to me, so

Reviewed-by: Igor Mammedov <imammedo@redhat.com>


here should go a list of changes made to the patch to ease review
like:
 vX: 
   - ....
   - ...
 vY:
   - ...

>  default-configs/arm-softmmu.mak |  1 +
>  hw/acpi/Kconfig                 |  4 ++
>  hw/acpi/Makefile.objs           |  1 +
>  hw/acpi/aml-build.c             |  2 +
>  hw/acpi/ghes.c                  | 89 +++++++++++++++++++++++++++++++++++++++++
>  hw/arm/virt-acpi-build.c        |  6 +++
>  include/hw/acpi/aml-build.h     |  1 +
>  include/hw/acpi/ghes.h          | 28 +++++++++++++
>  8 files changed, 132 insertions(+)
>  create mode 100644 hw/acpi/ghes.c
>  create mode 100644 include/hw/acpi/ghes.h
> 
> diff --git a/default-configs/arm-softmmu.mak b/default-configs/arm-softmmu.mak
> index 645e620..7648be0 100644
> --- a/default-configs/arm-softmmu.mak
> +++ b/default-configs/arm-softmmu.mak
> @@ -41,3 +41,4 @@ CONFIG_FSL_IMX25=y
>  CONFIG_FSL_IMX7=y
>  CONFIG_FSL_IMX6UL=y
>  CONFIG_SEMIHOSTING=y
> +CONFIG_ACPI_APEI=y
> diff --git a/hw/acpi/Kconfig b/hw/acpi/Kconfig
> index 54209c6..1932f66 100644
> --- a/hw/acpi/Kconfig
> +++ b/hw/acpi/Kconfig
> @@ -28,6 +28,10 @@ config ACPI_HMAT
>      bool
>      depends on ACPI
>  
> +config ACPI_APEI
> +    bool
> +    depends on ACPI
> +
>  config ACPI_PCI
>      bool
>      depends on ACPI && PCI
> diff --git a/hw/acpi/Makefile.objs b/hw/acpi/Makefile.objs
> index 777da07..28c5ddb 100644
> --- a/hw/acpi/Makefile.objs
> +++ b/hw/acpi/Makefile.objs
> @@ -8,6 +8,7 @@ common-obj-$(CONFIG_ACPI_NVDIMM) += nvdimm.o
>  common-obj-$(CONFIG_ACPI_VMGENID) += vmgenid.o
>  common-obj-$(CONFIG_ACPI_HW_REDUCED) += generic_event_device.o
>  common-obj-$(CONFIG_ACPI_HMAT) += hmat.o
> +common-obj-$(CONFIG_ACPI_APEI) += ghes.o
>  common-obj-$(call lnot,$(CONFIG_ACPI_X86)) += acpi-stub.o
>  common-obj-$(call lnot,$(CONFIG_PC)) += acpi-x86-stub.o
>  
> diff --git a/hw/acpi/aml-build.c b/hw/acpi/aml-build.c
> index 2c3702b..3681ec6 100644
> --- a/hw/acpi/aml-build.c
> +++ b/hw/acpi/aml-build.c
> @@ -1578,6 +1578,7 @@ void acpi_build_tables_init(AcpiBuildTables *tables)
>      tables->table_data = g_array_new(false, true /* clear */, 1);
>      tables->tcpalog = g_array_new(false, true /* clear */, 1);
>      tables->vmgenid = g_array_new(false, true /* clear */, 1);
> +    tables->hardware_errors = g_array_new(false, true /* clear */, 1);
>      tables->linker = bios_linker_loader_init();
>  }
>  
> @@ -1588,6 +1589,7 @@ void acpi_build_tables_cleanup(AcpiBuildTables *tables, bool mfre)
>      g_array_free(tables->table_data, true);
>      g_array_free(tables->tcpalog, mfre);
>      g_array_free(tables->vmgenid, mfre);
> +    g_array_free(tables->hardware_errors, mfre);
>  }
>  
>  /*
> diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
> new file mode 100644
> index 0000000..e1b3f8f
> --- /dev/null
> +++ b/hw/acpi/ghes.c
> @@ -0,0 +1,89 @@
> +/*
> + * Support for generating APEI tables and recording CPER for Guests
> + *
> + * Copyright (c) 2020 HUAWEI TECHNOLOGIES CO., LTD.
> + *
> + * Author: Dongjiu Geng <gengdongjiu@huawei.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> +
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> +
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include "qemu/osdep.h"
> +#include "qemu/units.h"
> +#include "hw/acpi/ghes.h"
> +#include "hw/acpi/aml-build.h"
> +
> +#define ACPI_GHES_ERRORS_FW_CFG_FILE        "etc/hardware_errors"
> +#define ACPI_GHES_DATA_ADDR_FW_CFG_FILE     "etc/hardware_errors_addr"
> +
> +/* The max size in bytes for one error block */
> +#define ACPI_GHES_MAX_RAW_DATA_LENGTH   (1 * KiB)
> +
> +/* Now only support ARMv8 SEA notification type error source */
> +#define ACPI_GHES_ERROR_SOURCE_COUNT        1
> +
> +/*
> + * Build table for the hardware error fw_cfg blob.
> + * Initialize "etc/hardware_errors" and "etc/hardware_errors_addr" fw_cfg blobs.
> + * See docs/specs/acpi_hest_ghes.rst for blobs format.
> + */
> +void build_ghes_error_table(GArray *hardware_errors, BIOSLinker *linker)
> +{
> +    int i, error_status_block_offset;
> +
> +    /* Build error_block_address */
> +    for (i = 0; i < ACPI_GHES_ERROR_SOURCE_COUNT; i++) {
> +        build_append_int_noprefix(hardware_errors, 0, sizeof(uint64_t));
> +    }
> +
> +    /* Build read_ack_register */
> +    for (i = 0; i < ACPI_GHES_ERROR_SOURCE_COUNT; i++) {
> +        /*
> +         * Initialize the value of read_ack_register to 1, so GHES can be
> +         * writeable after (re)boot.
> +         * ACPI 6.2: 18.3.2.8 Generic Hardware Error Source version 2
> +         * (GHESv2 - Type 10)
> +         */
> +        build_append_int_noprefix(hardware_errors, 1, sizeof(uint64_t));
> +    }
> +
> +    /* Generic Error Status Block offset in the hardware error fw_cfg blob */
> +    error_status_block_offset = hardware_errors->len;
> +
> +    /* Reserve space for Error Status Data Block */
> +    acpi_data_push(hardware_errors,
> +        ACPI_GHES_MAX_RAW_DATA_LENGTH * ACPI_GHES_ERROR_SOURCE_COUNT);
> +
> +    /* Tell guest firmware to place hardware_errors blob into RAM */
> +    bios_linker_loader_alloc(linker, ACPI_GHES_ERRORS_FW_CFG_FILE,
> +                             hardware_errors, sizeof(uint64_t), false);
> +
> +    for (i = 0; i < ACPI_GHES_ERROR_SOURCE_COUNT; i++) {
> +        /*
> +         * Tell firmware to patch error_block_address entries to point to
> +         * corresponding "Generic Error Status Block"
> +         */
> +        bios_linker_loader_add_pointer(linker,
> +            ACPI_GHES_ERRORS_FW_CFG_FILE, sizeof(uint64_t) * i,
> +            sizeof(uint64_t), ACPI_GHES_ERRORS_FW_CFG_FILE,
> +            error_status_block_offset + i * ACPI_GHES_MAX_RAW_DATA_LENGTH);
> +    }
> +
> +    /*
> +     * tell firmware to write hardware_errors GPA into
> +     * hardware_errors_addr fw_cfg, once the former has been initialized.
> +     */
> +    bios_linker_loader_write_pointer(linker, ACPI_GHES_DATA_ADDR_FW_CFG_FILE,
> +        0, sizeof(uint64_t), ACPI_GHES_ERRORS_FW_CFG_FILE, 0);
> +}
> diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
> index bd5f771..6819fcf 100644
> --- a/hw/arm/virt-acpi-build.c
> +++ b/hw/arm/virt-acpi-build.c
> @@ -48,6 +48,7 @@
>  #include "sysemu/reset.h"
>  #include "kvm_arm.h"
>  #include "migration/vmstate.h"
> +#include "hw/acpi/ghes.h"
>  
>  #define ARM_SPI_BASE 32
>  
> @@ -830,6 +831,11 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
>      acpi_add_table(table_offsets, tables_blob);
>      build_spcr(tables_blob, tables->linker, vms);
>  
> +    if (vms->ras) {
> +        acpi_add_table(table_offsets, tables_blob);
> +        build_ghes_error_table(tables->hardware_errors, tables->linker);
> +    }
> +
>      if (ms->numa_state->num_nodes > 0) {
>          acpi_add_table(table_offsets, tables_blob);
>          build_srat(tables_blob, tables->linker, vms);
> diff --git a/include/hw/acpi/aml-build.h b/include/hw/acpi/aml-build.h
> index de4a406..8f13620 100644
> --- a/include/hw/acpi/aml-build.h
> +++ b/include/hw/acpi/aml-build.h
> @@ -220,6 +220,7 @@ struct AcpiBuildTables {
>      GArray *rsdp;
>      GArray *tcpalog;
>      GArray *vmgenid;
> +    GArray *hardware_errors;
>      BIOSLinker *linker;
>  } AcpiBuildTables;
>  
> diff --git a/include/hw/acpi/ghes.h b/include/hw/acpi/ghes.h
> new file mode 100644
> index 0000000..50379b0
> --- /dev/null
> +++ b/include/hw/acpi/ghes.h
> @@ -0,0 +1,28 @@
> +/*
> + * Support for generating APEI tables and recording CPER for Guests
> + *
> + * Copyright (c) 2020 HUAWEI TECHNOLOGIES CO., LTD.
> + *
> + * Author: Dongjiu Geng <gengdongjiu@huawei.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> +
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> +
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef ACPI_GHES_H
> +#define ACPI_GHES_H
> +
> +#include "hw/acpi/bios-linker-loader.h"
> +
> +void build_ghes_error_table(GArray *hardware_errors, BIOSLinker *linker);
> +#endif

