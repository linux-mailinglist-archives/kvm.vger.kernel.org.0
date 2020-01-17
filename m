Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D51301407BC
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2020 11:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgAQKRD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jan 2020 05:17:03 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:53360 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726085AbgAQKRD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jan 2020 05:17:03 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 0F497E896FAF0E365F54;
        Fri, 17 Jan 2020 18:17:02 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Fri, 17 Jan 2020
 18:16:53 +0800
Subject: Re: [PATCH v22 9/9] MAINTAINERS: Add ACPI/HEST/GHES entries
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
CC:     Fam Zheng <fam@euphon.net>, Eduardo Habkost <ehabkost@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Linuxarm <linuxarm@huawei.com>,
        Shannon Zhao <shannon.zhaosl@gmail.com>,
        Zheng Xiang <zhengxiang9@huawei.com>,
        qemu-arm <qemu-arm@nongnu.org>,
        James Morse <james.morse@arm.com>,
        "xuwei (O)" <xuwei5@huawei.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
References: <1578483143-14905-1-git-send-email-gengdongjiu@huawei.com>
 <1578483143-14905-10-git-send-email-gengdongjiu@huawei.com>
 <CAFEAcA-mLgD8rQ211ep44nd8oxTKSnxc7YmY+nPtADpKZk5asA@mail.gmail.com>
 <1c45a8b4-1ea4-ddfd-cce3-c42699d2b3b9@redhat.com>
From:   gengdongjiu <gengdongjiu@huawei.com>
Message-ID: <d502bd34-79e4-45f8-e1b7-54265623db15@huawei.com>
Date:   Fri, 17 Jan 2020 18:16:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <1c45a8b4-1ea4-ddfd-cce3-c42699d2b3b9@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/1/17 15:22, Philippe Mathieu-Daudé wrote:
> Hi Peter,
> 
> On 1/16/20 5:46 PM, Peter Maydell wrote:
>> On Wed, 8 Jan 2020 at 11:32, Dongjiu Geng <gengdongjiu@huawei.com> wrote:
>>>
>>> I and Xiang are willing to review the APEI-related patches and
>>> volunteer as the reviewers for the HEST/GHES part.
>>>
>>> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
>>> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
>>> ---
>>>   MAINTAINERS | 9 +++++++++
>>>   1 file changed, 9 insertions(+)
>>>
>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>> index 387879a..5af70a5 100644
>>> --- a/MAINTAINERS
>>> +++ b/MAINTAINERS
>>> @@ -1423,6 +1423,15 @@ F: tests/bios-tables-test.c
>>>   F: tests/acpi-utils.[hc]
>>>   F: tests/data/acpi/
>>>
>>> +ACPI/HEST/GHES
>>> +R: Dongjiu Geng <gengdongjiu@huawei.com>
>>> +R: Xiang Zheng <zhengxiang9@huawei.com>
>>> +L: qemu-arm@nongnu.org
>>> +S: Maintained
>>> +F: hw/acpi/ghes.c
>>> +F: include/hw/acpi/ghes.h
>>> +F: docs/specs/acpi_hest_ghes.rst
>>> +
>>>   ppc4xx
>>>   M: David Gibson <david@gibson.dropbear.id.au>
>>>   L: qemu-ppc@nongnu.org
>>> -- 
>>
>> Michael, Igor: since this new MAINTAINERS section is
>> moving files out of the 'ACPI/SMBIOS' section that you're
>> currently responsible for, do you want to provide an
>> acked-by: that you think this division of files makes sense?
> 
> The files are not 'moved out', Michael and Igor are still the maintainers of the supported ACPI/SMBIOS subsystem:
> 
> ACPI/SMBIOS
> M: Michael S. Tsirkin <mst@redhat.com>
> M: Igor Mammedov <imammedo@redhat.com>
> S: Supported
> F: include/hw/acpi/*
> F: hw/acpi/*
> 
> Dongjiu and Xiang only add themselves as reviewers to get notified on changes on these specific files. The more eyes the better :)
> 
> The docs/specs/acpi_hest_ghes.rst document has no maintainer, as these others too:
If this file has no maintainer, may be it needs a M tag for this file, otherwise when people change this file, and use "./scripts/get_maintainer.pl xxxxx" to get maintainer, it will be empty.

> 
> - docs/specs/acpi_cpu_hotplug.txt
> - docs/specs/acpi_hw_reduced_hotplug.rst
> - docs/specs/acpi_mem_hotplug.txt
> - docs/specs/acpi_nvdimm.txt
> 
> The only ACPI file reported as maintained in docs/specs/ is acpi_pci_hotplug.txt, from this entry:
> 
> PCI
> M: Michael S. Tsirkin <mst@redhat.com>
> M: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
> S: Supported
> F: docs/specs/*pci*
> 
> FWIW:
> Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> 
> .
> 

