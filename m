Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB8B41408D2
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2020 12:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgAQLWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jan 2020 06:22:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55758 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726689AbgAQLWk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jan 2020 06:22:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579260159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1KvxUNp1KgYZrP3PTc7X6mLhbjCUmF5jCMS907NMjFw=;
        b=ehDsMBX1YH8bHUAh1j8dibao7r7K3uRJLN2xaPhdEPlqzUah+dqyen1ORhXh0+aohZFTxr
        yyhBZhGR9zEnHek0QzfjF5OvmvVB8CN190JXhotr2g/ZH8UgnXBlxqVAilBEVeX13fibyk
        XcXyFNdemz6UuWpsIpBWJR6uDo/sBD8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-87-Y44E8p4LMWqiD8gwoc2ndA-1; Fri, 17 Jan 2020 06:22:38 -0500
X-MC-Unique: Y44E8p4LMWqiD8gwoc2ndA-1
Received: by mail-wm1-f71.google.com with SMTP id s25so1111038wmj.3
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2020 03:22:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1KvxUNp1KgYZrP3PTc7X6mLhbjCUmF5jCMS907NMjFw=;
        b=Rh7ASXO3S43JKeYsKplFsS4GSdDIp3P0FFEvFmKOioAgovv/t81aJ9xwTi11bQrwXM
         z94up5CMqRb/q5WU8kZD4HLFnhjpi/7W7jmZoZSHpay1xb/zgRXDHXOh174tmQ0/tMts
         x5IL5/2ptWbK9AsrYHaUocmthOGTN+mB1/IDiTJzJNZfYTQDAYy1KUJ4adPwkuYGu75d
         z5GmuXnVQIhU72ZCwRrarHcGi8fZkSUC0KoaupGGel3ye6/n+CAhRu6EZpP+p1KFzLv4
         82g5pxOWx6YwRmNwNfyXrQ06QxOc9MnnLWZuvoUqsAoG8BOQZMOIHqq8HKcRqZU7GRWt
         HV7g==
X-Gm-Message-State: APjAAAV8HsMjWuu4XjuvIrwN7/iVXc0/Z8kJdSiCTXU64A+d8PKLrIg/
        kCDECJFEe8F6fKeXLwwQXZZKjWL6qMdC3vPpqdofBvWEXwCwVKUCZVys3z0br0Y+cbfFzVAQSu3
        6qGCV9zDupiEL
X-Received: by 2002:a1c:7d93:: with SMTP id y141mr4010633wmc.111.1579260157341;
        Fri, 17 Jan 2020 03:22:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqxw6jG4sunKX8VtAdOpeF6yPeSU9Bg8VWVUzEvV9nwY1wrfKbeKrRfkjUOqNnf61HZxoUkhkw==
X-Received: by 2002:a1c:7d93:: with SMTP id y141mr4010613wmc.111.1579260157141;
        Fri, 17 Jan 2020 03:22:37 -0800 (PST)
Received: from [192.168.1.35] (113.red-83-57-172.dynamicip.rima-tde.net. [83.57.172.113])
        by smtp.gmail.com with ESMTPSA id 5sm33742050wrh.5.2020.01.17.03.22.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2020 03:22:36 -0800 (PST)
Subject: Re: [PATCH v22 9/9] MAINTAINERS: Add ACPI/HEST/GHES entries
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     Dongjiu Geng <gengdongjiu@huawei.com>, Fam Zheng <fam@euphon.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
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
 <CAFEAcA_QO1t10EJySQ5tbOHNuXgzQnJrN28n7fmZt_7aP=hvzA@mail.gmail.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <724fbf58-19df-593c-b665-2c2e9fe71189@redhat.com>
Date:   Fri, 17 Jan 2020 12:22:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAFEAcA_QO1t10EJySQ5tbOHNuXgzQnJrN28n7fmZt_7aP=hvzA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/17/20 12:09 PM, Peter Maydell wrote:
> On Fri, 17 Jan 2020 at 07:22, Philippe Mathieu-Daudé <philmd@redhat.com> wrote:
>>
>> Hi Peter,
>>
>> On 1/16/20 5:46 PM, Peter Maydell wrote:
>>> On Wed, 8 Jan 2020 at 11:32, Dongjiu Geng <gengdongjiu@huawei.com> wrote:
>>>>
>>>> I and Xiang are willing to review the APEI-related patches and
>>>> volunteer as the reviewers for the HEST/GHES part.
>>>>
>>>> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
>>>> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
>>>> ---
>>>>    MAINTAINERS | 9 +++++++++
>>>>    1 file changed, 9 insertions(+)
>>>>
>>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>>> index 387879a..5af70a5 100644
>>>> --- a/MAINTAINERS
>>>> +++ b/MAINTAINERS
>>>> @@ -1423,6 +1423,15 @@ F: tests/bios-tables-test.c
>>>>    F: tests/acpi-utils.[hc]
>>>>    F: tests/data/acpi/
>>>>
>>>> +ACPI/HEST/GHES
>>>> +R: Dongjiu Geng <gengdongjiu@huawei.com>
>>>> +R: Xiang Zheng <zhengxiang9@huawei.com>
>>>> +L: qemu-arm@nongnu.org
>>>> +S: Maintained
>>>> +F: hw/acpi/ghes.c
>>>> +F: include/hw/acpi/ghes.h
>>>> +F: docs/specs/acpi_hest_ghes.rst
>>>> +
>>>>    ppc4xx
>>>>    M: David Gibson <david@gibson.dropbear.id.au>
>>>>    L: qemu-ppc@nongnu.org
>>>> --
>>>
>>> Michael, Igor: since this new MAINTAINERS section is
>>> moving files out of the 'ACPI/SMBIOS' section that you're
>>> currently responsible for, do you want to provide an
>>> acked-by: that you think this division of files makes sense?
>>
>> The files are not 'moved out', Michael and Igor are still the
>> maintainers of the supported ACPI/SMBIOS subsystem:
> 
> Does get_maintainer.pl print the answers for all matching
> sections, rather than just the most specific, then?

Yes:

$ ./scripts/get_maintainer.pl -f hw/acpi/ghes.c
Dongjiu Geng <gengdongjiu@huawei.com> (reviewer:ACPI/HEST/GHES)
Xiang Zheng <zhengxiang9@huawei.com> (reviewer:ACPI/HEST/GHES)
"Michael S. Tsirkin" <mst@redhat.com> (supporter:ACPI/SMBIOS)
Igor Mammedov <imammedo@redhat.com> (supporter:ACPI/SMBIOS)
qemu-arm@nongnu.org (open list:ACPI/HEST/GHES)
qemu-devel@nongnu.org (open list:All patches CC here)

> In any case, I'd still like an acked-by from them.

Sure :)

