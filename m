Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 493D94CFE5
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 16:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfFTOEP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 10:04:15 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:42712 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726750AbfFTOEP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 10:04:15 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 4D4E3D440532536563AD;
        Thu, 20 Jun 2019 22:04:12 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Thu, 20 Jun 2019
 22:04:04 +0800
Subject: Re: [Qemu-devel] [PATCH v17 02/10] ACPI: add some GHES structures and
 macros definition
To:     Igor Mammedov <imammedo@redhat.com>
CC:     <pbonzini@redhat.com>, <mst@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <lersek@redhat.com>, <james.morse@arm.com>, <mtosatti@redhat.com>,
        <rth@twiddle.net>, <ehabkost@redhat.com>, <zhengxiang9@huawei.com>,
        <jonathan.cameron@huawei.com>, <xuwei5@huawei.com>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>, <linuxarm@huawei.com>
References: <1557832703-42620-1-git-send-email-gengdongjiu@huawei.com>
 <1557832703-42620-3-git-send-email-gengdongjiu@huawei.com>
 <20190620141052.370788fb@redhat.com>
From:   gengdongjiu <gengdongjiu@huawei.com>
Message-ID: <f4f94ecb-200c-3e18-1a09-5fb6bc761834@huawei.com>
Date:   Thu, 20 Jun 2019 22:04:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190620141052.370788fb@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Igor,
   Thanks for your review.

On 2019/6/20 20:10, Igor Mammedov wrote:
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
> there shouldn't be packed structures,
> is it a leftover from previous version?

I remember some people suggest to add QEMU_PACKED before, anyway I will remove it in my next version patch.

> 
>> +
>> +/*
>> + * Masks for block_status flags above
>> + */
>> +#define ACPI_GEBS_UNCORRECTABLE         1
>> +
>> +/*

