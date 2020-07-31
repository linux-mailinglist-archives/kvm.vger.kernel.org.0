Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868D72348E3
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 18:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729114AbgGaQFw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 12:05:52 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53264 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727819AbgGaQFv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jul 2020 12:05:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596211549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iTcMEhyP/fGGCZXBYCtZfkPc0hr80NsAgttmtlRwhyE=;
        b=IebI1pfBXD4s0RyLcjGtSlrrJHF/GeAizEzUxMBf87nGbI/NVTQ/QJuuCx4kReaRTX9V6f
        PkH3YtCcTu+KOFQWQEOcWjIGnJHiyRzqfHEhHbBSSkda53u+5wtFJTCAT2ysildISNGF3O
        ChjsPCsjCnzMlkZS2yXIfUpffqqqNfI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-QxlupzwlMLOHOzSAWZxDqg-1; Fri, 31 Jul 2020 12:05:47 -0400
X-MC-Unique: QxlupzwlMLOHOzSAWZxDqg-1
Received: by mail-wm1-f70.google.com with SMTP id u68so2191388wmu.3
        for <kvm@vger.kernel.org>; Fri, 31 Jul 2020 09:05:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iTcMEhyP/fGGCZXBYCtZfkPc0hr80NsAgttmtlRwhyE=;
        b=U6O7MOa7bHAH6IFAEsYgD6DNB/bYRpeZmineaiCNcZK+UfFiWggqb9Q60VYk+zY3wI
         Wuv96DfmctOy+Hkb/xXxEvQ5OYlPTXBUZHVSm+CHZzk091neovl+a8P1cMqtxY6adW/N
         XkPBE8hA22cp0Yz6KpupcfSCILb3JoQdV74uIEnGE/52GYqkSXOrVO99B2+ogjR3L3cF
         wZhfoENi6k9FEHDcT54ptzYwWPCUJgIzQ0N7tEqOhKN5Yr96LljexGMzjs3eSB+lTLYi
         64d1TkAo6T/STdamEAl9hIIGZraz1dy4yUeHK1XkeQlkMjouzUp27wCP8PNhRtgzoowC
         BV+A==
X-Gm-Message-State: AOAM533uHplANMzXUSwD4dDHmPgIaIT2KjDxxZRIgmvqNsbD67yli6fE
        L++ShEl3iVPxIcicbfV5Z8DwLJK/rRTSyhzJxW4/INoVRAtWfHeL01Ay0G/TdJ26FHflKpSy45P
        OcUXJEDM2zfaI
X-Received: by 2002:adf:fa85:: with SMTP id h5mr4284966wrr.18.1596211546181;
        Fri, 31 Jul 2020 09:05:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFzXULOGE8P4UjWl5zig0U3KvRgqeDtNwmjR/Uba5NixmuwvwvWrg+mZ6zAPlEiFStMput4w==
X-Received: by 2002:adf:fa85:: with SMTP id h5mr4284938wrr.18.1596211545822;
        Fri, 31 Jul 2020 09:05:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:90a5:f767:5f9f:3445? ([2001:b07:6468:f312:90a5:f767:5f9f:3445])
        by smtp.gmail.com with ESMTPSA id w64sm12301996wmb.26.2020.07.31.09.05.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2020 09:05:45 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] fw_cfg: avoid index out of bounds
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org
References: <20200730215809.1970-1-pbonzini@redhat.com>
 <B357AE3F-2ACB-41F0-B6C1-D9A3F6604F4F@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dfec6c8e-7629-b92b-f410-6fd0a393afa4@redhat.com>
Date:   Fri, 31 Jul 2020 18:05:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <B357AE3F-2ACB-41F0-B6C1-D9A3F6604F4F@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/07/20 18:00, Nadav Amit wrote:
>>
>> On Jul 30, 2020, at 2:58 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> clang compilation fails with
>>
>> lib/x86/fwcfg.c:32:3: error: array index 17 is past the end of the array (which contains 16 elements) [-Werror,-Warray-bounds]
>>                fw_override[FW_CFG_MAX_RAM] = atol(str) * 1024 * 1024;
>>
>> The reason is that FW_CFG_MAX_RAM does not exist in the fw-cfg spec and was
>> added for bare metal support.  Fix the size of the array and rename FW_CFG_MAX_ENTRY
>> to FW_CFG_NUM_ENTRIES, so that it is clear that it must be one plus the
>> highest valid entry.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>> lib/x86/fwcfg.c | 6 +++---
>> lib/x86/fwcfg.h | 5 ++++-
>> 2 files changed, 7 insertions(+), 4 deletions(-)
>>
>> diff --git a/lib/x86/fwcfg.c b/lib/x86/fwcfg.c
>> index c2aaf5a..1734afb 100644
>> --- a/lib/x86/fwcfg.c
>> +++ b/lib/x86/fwcfg.c
>> @@ -4,7 +4,7 @@
>>
>> static struct spinlock lock;
>>
>> -static long fw_override[FW_CFG_MAX_ENTRY];
>> +static long fw_override[FW_CFG_NUM_ENTRIES];
>> static bool fw_override_done;
>>
>> bool no_test_device;
>> @@ -15,7 +15,7 @@ static void read_cfg_override(void)
>> 	int i;
>>
>> 	/* Initialize to negative value that would be considered as invalid */
>> -	for (i = 0; i < FW_CFG_MAX_ENTRY; i++)
>> +	for (i = 0; i < FW_CFG_NUM_ENTRIES; i++)
>> 		fw_override[i] = -1;
>>
>> 	if ((str = getenv("NR_CPUS")))
>> @@ -44,7 +44,7 @@ static uint64_t fwcfg_get_u(uint16_t index, int bytes)
>>     if (!fw_override_done)
>>         read_cfg_override();
>>
>> -    if (index < FW_CFG_MAX_ENTRY && fw_override[index] >= 0)
>> +    if (index < FW_CFG_NUM_ENTRIES && fw_override[index] >= 0)
>> 	    return fw_override[index];
>>
>>     spin_lock(&lock);
>> diff --git a/lib/x86/fwcfg.h b/lib/x86/fwcfg.h
>> index 64d4c6e..ac4257e 100644
>> --- a/lib/x86/fwcfg.h
>> +++ b/lib/x86/fwcfg.h
>> @@ -20,9 +20,12 @@
>> #define FW_CFG_NUMA             0x0d
>> #define FW_CFG_BOOT_MENU        0x0e
>> #define FW_CFG_MAX_CPUS         0x0f
>> -#define FW_CFG_MAX_ENTRY        0x10
>> +
>> +/* Dummy entries used when running on bare metal */
>> #define FW_CFG_MAX_RAM		0x11
>>
>> +#define FW_CFG_NUM_ENTRIES      (FW_CFG_MAX_RAM + 1)
>> +
>> #define FW_CFG_WRITE_CHANNEL    0x4000
>> #define FW_CFG_ARCH_LOCAL       0x8000
>> #define FW_CFG_ENTRY_MASK       ~(FW_CFG_WRITE_CHANNEL | FW_CFG_ARCH_LOCAL)
>> — 
>> 2.26.2
> 
> For the record: I did send a patch more than two weeks ago to fix this
> problem (that I created).

Oops, sorry.  I just saw it on the gitlab CI, I must have missed your patch.

Paolo

