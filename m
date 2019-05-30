Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF4EE2FEB1
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 16:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbfE3O6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 May 2019 10:58:38 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:35310 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726065AbfE3O6i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 May 2019 10:58:38 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3418FA158468C0152440;
        Thu, 30 May 2019 22:58:33 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Thu, 30 May 2019
 22:58:26 +0800
Subject: Re: [PATCH v17 02/10] ACPI: add some GHES structures and macros
 definition
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     <pbonzini@redhat.com>, <imammedo@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <lersek@redhat.com>, <james.morse@arm.com>, <mtosatti@redhat.com>,
        <rth@twiddle.net>, <ehabkost@redhat.com>, <zhengxiang9@huawei.com>,
        <jonathan.cameron@huawei.com>, <xuwei5@huawei.com>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>, <linuxarm@huawei.com>
References: <1557832703-42620-1-git-send-email-gengdongjiu@huawei.com>
 <1557832703-42620-3-git-send-email-gengdongjiu@huawei.com>
 <20190528233859-mutt-send-email-mst@kernel.org>
From:   gengdongjiu <gengdongjiu@huawei.com>
Message-ID: <a0cad169-0dae-8525-f36f-2b88e418791e@huawei.com>
Date:   Thu, 30 May 2019 22:58:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190528233859-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/5/29 11:40, Michael S. Tsirkin wrote:
> On Tue, May 14, 2019 at 04:18:15AM -0700, Dongjiu Geng wrote:
>> Add Generic Error Status Block structures and some macros
>> definitions, which is referred to the ACPI 4.0 or ACPI 6.2. The
>> HEST table generation and CPER record will use them.
>>
>> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> 
> Are these all still used? I'd rather you moved stuff to
> where it's used.
Ok, I will move them, thanks

> 
> 
> 
>> ---
>>  include/hw/acpi/acpi-defs.h | 52 +++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 52 insertions(+)
>>
>> diff --git a/include/hw/acpi/acpi-defs.h b/include/hw/acpi/acpi-defs.h
>> index f9aa4bd..d1996fb 100644
>> --- a/include/hw/acpi/acpi-defs.h
>> +++ b/include/hw/acpi/acpi-defs.h
>> @@ -224,6 +224,25 @@ typedef struct AcpiMultipleApicTable AcpiMultipleApicTable;
>>  #define ACPI_APIC_RESERVED              16   /* 16 and greater are reserved */
>>  
>>  /*
>> + * Values for Hardware Error Notification Type field
>> + */
>> +enum AcpiHestNotifyType {
>> +    ACPI_HEST_NOTIFY_POLLED = 0,
>> +    ACPI_HEST_NOTIFY_EXTERNAL = 1,
>> +    ACPI_HEST_NOTIFY_LOCAL = 2,
>> +    ACPI_HEST_NOTIFY_SCI = 3,
>> +    ACPI_HEST_NOTIFY_NMI = 4,
>> +    ACPI_HEST_NOTIFY_CMCI = 5,  /* ACPI 5.0: 18.3.2.7, Table 18-290 */
>> +    ACPI_HEST_NOTIFY_MCE = 6,   /* ACPI 5.0: 18.3.2.7, Table 18-290 */
>> +    ACPI_HEST_NOTIFY_GPIO = 7,  /* ACPI 6.0: 18.3.2.7, Table 18-332 */
>> +    ACPI_HEST_NOTIFY_SEA = 8,   /* ACPI 6.1: 18.3.2.9, Table 18-345 */
>> +    ACPI_HEST_NOTIFY_SEI = 9,   /* ACPI 6.1: 18.3.2.9, Table 18-345 */
>> +    ACPI_HEST_NOTIFY_GSIV = 10, /* ACPI 6.1: 18.3.2.9, Table 18-345 */
>> +    ACPI_HEST_NOTIFY_SDEI = 11, /* ACPI 6.2: 18.3.2.9, Table 18-383 */
>> +    ACPI_HEST_NOTIFY_RESERVED = 12 /* 12 and greater are reserved */
>> +};
>> +
> 
> If there's a single user, the best thing to do
> is just to open-code with a comment that matches
> spec names. It's hard to find stuff like ACPI_HEST_NOTIFY_GSIV
> in a spec.
ok, I will do it, thanks

> 
>> +/*
>>   * MADT sub-structures (Follow MULTIPLE_APIC_DESCRIPTION_TABLE)
>>   */
>>  #define ACPI_SUB_HEADER_DEF   /* Common ACPI sub-structure header */\
>> @@ -400,6 +419,39 @@ struct AcpiSystemResourceAffinityTable {
>>  } QEMU_PACKED;
>>  typedef struct AcpiSystemResourceAffinityTable AcpiSystemResourceAffinityTable;
>>  
>> +/*
>> + * Generic Error Status Block
>> + */
>> +struct AcpiGenericErrorStatus {
>> +    /* It is a bitmask composed of ACPI_GEBS_xxx macros */
>> +    uint32_t block_status;
>> +    uint32_t raw_data_offset;
>> +    uint32_t raw_data_length;
>> +    uint32_t data_length;
>> +    uint32_t error_severity;
>> +} QEMU_PACKED;
>> +typedef struct AcpiGenericErrorStatus AcpiGenericErrorStatus;
>> +
>> +/*
>> + * Masks for block_status flags above
>> + */
>> +#define ACPI_GEBS_UNCORRECTABLE         1
>> +
>> +/*
>> + * Values for error_severity field above
>> + */
>> +enum AcpiGenericErrorSeverity {
>> +    ACPI_CPER_SEV_RECOVERABLE,
>> +    ACPI_CPER_SEV_FATAL,
>> +    ACPI_CPER_SEV_CORRECTED,
>> +    ACPI_CPER_SEV_NONE,
>> +};
>> +
>> +/*
>> + * Generic Hardware Error Source version 2
>> + */
>> +#define ACPI_HEST_SOURCE_GENERIC_ERROR_V2    10
>> +
>>  #define ACPI_SRAT_PROCESSOR_APIC     0
>>  #define ACPI_SRAT_MEMORY             1
>>  #define ACPI_SRAT_PROCESSOR_x2APIC   2
>> -- 
>> 1.8.3.1
> .
> 

