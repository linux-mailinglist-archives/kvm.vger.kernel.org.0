Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CECF4141CF4
	for <lists+kvm@lfdr.de>; Sun, 19 Jan 2020 09:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgASIUF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Jan 2020 03:20:05 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9664 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726444AbgASIUF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Jan 2020 03:20:05 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6B101EBA86C3279E3455;
        Sun, 19 Jan 2020 16:20:02 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Sun, 19 Jan 2020
 16:19:54 +0800
Subject: Re: [PATCH v22 9/9] MAINTAINERS: Add ACPI/HEST/GHES entries
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
CC:     Fam Zheng <fam@euphon.net>, Eduardo Habkost <ehabkost@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
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
 <CAFEAcA_QO1t10EJySQ5tbOHNuXgzQnJrN28n7fmZt_7aP=hvzA@mail.gmail.com>
 <724fbf58-19df-593c-b665-2c2e9fe71189@redhat.com>
From:   gengdongjiu <gengdongjiu@huawei.com>
Message-ID: <ebf18e13-4f7e-9002-6774-5977a243fca7@huawei.com>
Date:   Sun, 19 Jan 2020 16:19:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <724fbf58-19df-593c-b665-2c2e9fe71189@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/1/17 19:22, Philippe Mathieu-Daudé wrote:
> On 1/17/20 12:09 PM, Peter Maydell wrote:
>> On Fri, 17 Jan 2020 at 07:22, Philippe Mathieu-Daudé <philmd@redhat.com> wrote:
>>>
>>> Hi Peter,
>>>
>>> On 1/16/20 5:46 PM, Peter Maydell wrote:
>>>> On Wed, 8 Jan 2020 at 11:32, Dongjiu Geng <gengdongjiu@huawei.com> wrote:
>>>>>
>>>>> I and Xiang are willing to review the APEI-related patches and
>>>>> volunteer as the reviewers for the HEST/GHES part.
>>>>>
>>>>> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
>>>>> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
>>>>> ---
>>>>>    MAINTAINERS | 9 +++++++++
>>>>>    1 file changed, 9 insertions(+)
>>>>>
>>>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>>>> index 387879a..5af70a5 100644
>>>>> --- a/MAINTAINERS
>>>>> +++ b/MAINTAINERS
>>>>> @@ -1423,6 +1423,15 @@ F: tests/bios-tables-test.c
>>>>>    F: tests/acpi-utils.[hc]
>>>>>    F: tests/data/acpi/
>>>>>
>>>>> +ACPI/HEST/GHES
>>>>> +R: Dongjiu Geng <gengdongjiu@huawei.com>
>>>>> +R: Xiang Zheng <zhengxiang9@huawei.com>
>>>>> +L: qemu-arm@nongnu.org
>>>>> +S: Maintained
>>>>> +F: hw/acpi/ghes.c
>>>>> +F: include/hw/acpi/ghes.h
>>>>> +F: docs/specs/acpi_hest_ghes.rst
>>>>> +
>>>>>    ppc4xx
>>>>>    M: David Gibson <david@gibson.dropbear.id.au>
>>>>>    L: qemu-ppc@nongnu.org
>>>>> -- 
>>>>
>>>> Michael, Igor: since this new MAINTAINERS section is
>>>> moving files out of the 'ACPI/SMBIOS' section that you're
>>>> currently responsible for, do you want to provide an
>>>> acked-by: that you think this division of files makes sense?
>>>
>>> The files are not 'moved out', Michael and Igor are still the
>>> maintainers of the supported ACPI/SMBIOS subsystem: 

In fact, I am willing to maintain with others to the new added files , I see some new added files in "hw/acpi" folders are moved out, such as NVDIMM/vmgenid.

NVDIMM
M: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
S: Maintained
F: hw/acpi/nvdimm.c
F: hw/mem/nvdimm.c
F: include/hw/mem/nvdimm.h
F: docs/nvdimm.txt

VM Generation ID
M: Ben Warren <ben@skyportsystems.com>
S: Maintained
F: hw/acpi/vmgenid.c
F: include/hw/acpi/vmgenid.h
F: docs/specs/vmgenid.txt
F: tests/vmgenid-test.c
F: stubs/vmgenid.c

