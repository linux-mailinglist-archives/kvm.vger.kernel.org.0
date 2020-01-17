Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 572A314046F
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2020 08:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbgAQHWv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jan 2020 02:22:51 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32058 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726675AbgAQHWu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jan 2020 02:22:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579245769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y3RcHw06IWFshCmwxf/kgJpylqKRRJYyaQ6ieJjtjws=;
        b=Vfv3rfn1WqELM74pSMZnOVgqI0avTfc+BpfzF/KISDEgdP6gYDMl7TvUngxbFPpoQYbT+/
        aRL4rXpB1/X7IkU7/JF6GgiaoNcQ8CYevsv/qbLX2dS+8whhV59WgwU6vNhj3sWqzItN7i
        e2ci88poh/vpmdep+airE5ber3lN4NU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-38kSFjW8MjuiOC6Jj1vXtg-1; Fri, 17 Jan 2020 02:22:48 -0500
X-MC-Unique: 38kSFjW8MjuiOC6Jj1vXtg-1
Received: by mail-wm1-f72.google.com with SMTP id h130so1916364wme.7
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2020 23:22:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y3RcHw06IWFshCmwxf/kgJpylqKRRJYyaQ6ieJjtjws=;
        b=H+52vk/pGFJfODzoA2XpoCPILDqrAf4nouWuc3t4kZZ5/TxWfEiJCIhBZr3xghUUwQ
         SKfy56hAs09ls+HhkabzFo4bEUjztNADjZVhQgCoGMopXAkeVMflL96POssFghoJNh2o
         A7DcgHKirB7+kevgfnot0tDkJ+nu3d+sUD2q8Bvgif+sXxDV4cbMFP/31jMTEz3hqplO
         v3Rzve8qJfOGa3Wqf/kTUWHHnQP6yzv66yLVAKase09tJHqAMx3URNsd3UyR/RNx81zb
         JmYXYy0iMTq7i2Xq9l1sIceGkG0bsGrte+2Yg74cO+Mdq/dDibiSf1NHqiyQPPFcuAAw
         5HCw==
X-Gm-Message-State: APjAAAXwxdaNKHdvbMJfnVEzSLxvcsH99cKLU5n+YAv9KKCCF5CVXfIH
        9UVhw6HA7NKJ6wr6sLCapLcBZLrRHWEvtHHFjZCSYLL+BEiKs29lzOfAdwSfa0rhmH+MoDACmCX
        aS3LO5gJ+S+27
X-Received: by 2002:adf:cf12:: with SMTP id o18mr1505118wrj.361.1579245767227;
        Thu, 16 Jan 2020 23:22:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqyhVu92f0rPbMXkhVzlAmmh1h6VA7J+gWqDV5WIKA8NY6FR45MKwm6SeR4kPdGNcBnws6v4QA==
X-Received: by 2002:adf:cf12:: with SMTP id o18mr1505101wrj.361.1579245766968;
        Thu, 16 Jan 2020 23:22:46 -0800 (PST)
Received: from [192.168.1.35] (113.red-83-57-172.dynamicip.rima-tde.net. [83.57.172.113])
        by smtp.gmail.com with ESMTPSA id x7sm31918244wrq.41.2020.01.16.23.22.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2020 23:22:46 -0800 (PST)
Subject: Re: [PATCH v22 9/9] MAINTAINERS: Add ACPI/HEST/GHES entries
To:     Peter Maydell <peter.maydell@linaro.org>,
        Dongjiu Geng <gengdongjiu@huawei.com>
Cc:     Fam Zheng <fam@euphon.net>, Eduardo Habkost <ehabkost@redhat.com>,
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
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <1c45a8b4-1ea4-ddfd-cce3-c42699d2b3b9@redhat.com>
Date:   Fri, 17 Jan 2020 08:22:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAFEAcA-mLgD8rQ211ep44nd8oxTKSnxc7YmY+nPtADpKZk5asA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On 1/16/20 5:46 PM, Peter Maydell wrote:
> On Wed, 8 Jan 2020 at 11:32, Dongjiu Geng <gengdongjiu@huawei.com> wrote:
>>
>> I and Xiang are willing to review the APEI-related patches and
>> volunteer as the reviewers for the HEST/GHES part.
>>
>> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
>> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
>> ---
>>   MAINTAINERS | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 387879a..5af70a5 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -1423,6 +1423,15 @@ F: tests/bios-tables-test.c
>>   F: tests/acpi-utils.[hc]
>>   F: tests/data/acpi/
>>
>> +ACPI/HEST/GHES
>> +R: Dongjiu Geng <gengdongjiu@huawei.com>
>> +R: Xiang Zheng <zhengxiang9@huawei.com>
>> +L: qemu-arm@nongnu.org
>> +S: Maintained
>> +F: hw/acpi/ghes.c
>> +F: include/hw/acpi/ghes.h
>> +F: docs/specs/acpi_hest_ghes.rst
>> +
>>   ppc4xx
>>   M: David Gibson <david@gibson.dropbear.id.au>
>>   L: qemu-ppc@nongnu.org
>> --
> 
> Michael, Igor: since this new MAINTAINERS section is
> moving files out of the 'ACPI/SMBIOS' section that you're
> currently responsible for, do you want to provide an
> acked-by: that you think this division of files makes sense?

The files are not 'moved out', Michael and Igor are still the 
maintainers of the supported ACPI/SMBIOS subsystem:

ACPI/SMBIOS
M: Michael S. Tsirkin <mst@redhat.com>
M: Igor Mammedov <imammedo@redhat.com>
S: Supported
F: include/hw/acpi/*
F: hw/acpi/*

Dongjiu and Xiang only add themselves as reviewers to get notified on 
changes on these specific files. The more eyes the better :)

The docs/specs/acpi_hest_ghes.rst document has no maintainer, as these 
others too:

- docs/specs/acpi_cpu_hotplug.txt
- docs/specs/acpi_hw_reduced_hotplug.rst
- docs/specs/acpi_mem_hotplug.txt
- docs/specs/acpi_nvdimm.txt

The only ACPI file reported as maintained in docs/specs/ is 
acpi_pci_hotplug.txt, from this entry:

PCI
M: Michael S. Tsirkin <mst@redhat.com>
M: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
S: Supported
F: docs/specs/*pci*

FWIW:
Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>

