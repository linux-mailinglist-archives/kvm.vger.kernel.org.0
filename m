Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B08F425924
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 19:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243218AbhJGRUJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 13:20:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59373 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243031AbhJGRUC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 13:20:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633627088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MbsrIrP94uMZOldrtrZ79yVQv4OvBHJ9iPBTzJB4K/c=;
        b=fLFJOYBObF2/VG5yJkxZCiV+b9MBx0+UcsL/WWUWgjo3lft54RMhfew1jcFRWUBAnhqB2p
        cQwKgll3XMkhWfeBZYwT2wSZ5QqvAoFdEDgRWZo8QndqqPPxbzoM55vBu4qq/Gbo3DF1SA
        +ECWOZZNIjs48ysNoADoMubdtT8vncA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422--JLSH9C1MHasgB-kDB2Vyg-1; Thu, 07 Oct 2021 13:18:07 -0400
X-MC-Unique: -JLSH9C1MHasgB-kDB2Vyg-1
Received: by mail-wr1-f71.google.com with SMTP id 41-20020adf812c000000b00160dfbfe1a2so1576195wrm.3
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 10:18:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MbsrIrP94uMZOldrtrZ79yVQv4OvBHJ9iPBTzJB4K/c=;
        b=ZAe8VnXkTs/ejruwMMttdj6a27/AP3QntLZSsZMQ+mumFDuAtXEsn+2ep5DsF70j4R
         /qfyshXy4WzfzavhqtFu3VuHcMOMvGYkibKoapDJLZCoyhJpA/jvibaef+rwPWHuFUd9
         lMsT9UNbaoUGxTEHP/44CfqFFVK1VHUjdPf/0wz7blmzPAjjFygKVppu1i1MhXr3YKVO
         9ni+Fhnn9MU5SqFTQa8YzjsOsucH0NQisUX+9GFFCe0w0XdNmvnEX3h+kPMG2DLRsfRB
         BlzC6Q1TMiY9LNBoaDDW8pJe722G5FNVNZG5xEX8+bNeRAz1UDKk0PbVrgN5UQv+fJz3
         aGPg==
X-Gm-Message-State: AOAM533klvkz052poqXwenkivcHat5TOusnTmpxwkxYZ1bqxGJfHcD+p
        Q+fICI8kzT9ev3u0Jn0HG4+CNz438YzxnKakU6J2Rtkc00grVCgEcdCHGukwAYMp41KYoPZ6xRO
        3C2f+LvtN/0F5
X-Received: by 2002:adf:a190:: with SMTP id u16mr6929334wru.114.1633627086512;
        Thu, 07 Oct 2021 10:18:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy7xEE3cTlJ3IDq18XapggwQJqgO4jE2PHvJpwaf/AuDBn/WAl0wR2VfNC+ol+BqIv9/PLpXQ==
X-Received: by 2002:adf:a190:: with SMTP id u16mr6929307wru.114.1633627086331;
        Thu, 07 Oct 2021 10:18:06 -0700 (PDT)
Received: from [192.168.1.36] (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id l2sm9310004wmi.1.2021.10.07.10.18.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Oct 2021 10:18:05 -0700 (PDT)
Message-ID: <6080fa16-66aa-570e-93c8-09be2ced9431@redhat.com>
Date:   Thu, 7 Oct 2021 19:18:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v4 16/23] target/i386/sev: Remove stubs by using code
 elision
Content-Language: en-US
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eric Blake <eblake@redhat.com>,
        "Daniel P . Berrange" <berrange@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sergio Lopez <slp@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>
References: <20211007161716.453984-1-philmd@redhat.com>
 <20211007161716.453984-17-philmd@redhat.com> <YV8pS2D8e14qmFBq@work-vm>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
In-Reply-To: <YV8pS2D8e14qmFBq@work-vm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/7/21 19:07, Dr. David Alan Gilbert wrote:
> * Philippe Mathieu-Daudé (philmd@redhat.com) wrote:
>> Only declare sev_enabled() and sev_es_enabled() when CONFIG_SEV is
>> set, to allow the compiler to elide unused code. Remove unnecessary
>> stubs.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> 
> What makes it allowed to *rely* on the compiler eliding calls?

I am not aware of a particular requirement on the compiler for code
elision, however we already use this syntax:

$ git grep -A4 'ifdef CONFIG_' include/sysemu/
...
include/sysemu/tcg.h:11:#ifdef CONFIG_TCG
include/sysemu/tcg.h-12-extern bool tcg_allowed;
include/sysemu/tcg.h-13-#define tcg_enabled() (tcg_allowed)
include/sysemu/tcg.h-14-#else
include/sysemu/tcg.h-15-#define tcg_enabled() 0
...

Cc'ing Richard/Eric/Daniel who have more experience with compiler
features in case they can enlighten me here.

>> ---
>>  target/i386/sev.h       | 14 ++++++++++++--
>>  target/i386/cpu.c       | 13 +++++++------
>>  target/i386/sev-stub.c  | 41 -----------------------------------------
>>  target/i386/meson.build |  2 +-
>>  4 files changed, 20 insertions(+), 50 deletions(-)
>>  delete mode 100644 target/i386/sev-stub.c
>>
>> diff --git a/target/i386/sev.h b/target/i386/sev.h
>> index c96072bf78d..d9548e3e642 100644
>> --- a/target/i386/sev.h
>> +++ b/target/i386/sev.h
>> @@ -14,6 +14,10 @@
>>  #ifndef QEMU_SEV_I386_H
>>  #define QEMU_SEV_I386_H
>>  
>> +#ifndef CONFIG_USER_ONLY
>> +#include CONFIG_DEVICES /* CONFIG_SEV */
>> +#endif
>> +
>>  #include "exec/confidential-guest-support.h"
>>  #include "qapi/qapi-types-misc-target.h"
>>  
>> @@ -35,8 +39,14 @@ typedef struct SevKernelLoaderContext {
>>      size_t cmdline_size;
>>  } SevKernelLoaderContext;
>>  
>> -bool sev_enabled(void);
>> -extern bool sev_es_enabled(void);
>> +#ifdef CONFIG_SEV
>> + bool sev_enabled(void);
>> +bool sev_es_enabled(void);
>> +#else
>> +#define sev_enabled() 0
>> +#define sev_es_enabled() 0
>> +#endif
>> +
>>  extern SevInfo *sev_get_info(void);
>>  extern uint32_t sev_get_cbit_position(void);
>>  extern uint32_t sev_get_reduced_phys_bits(void);
>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>> index 8289dc87bd5..fc3ed80ef1e 100644
>> --- a/target/i386/cpu.c
>> +++ b/target/i386/cpu.c
>> @@ -5764,12 +5764,13 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>>          *edx = 0;
>>          break;
>>      case 0x8000001F:
>> -        *eax = sev_enabled() ? 0x2 : 0;
>> -        *eax |= sev_es_enabled() ? 0x8 : 0;
>> -        *ebx = sev_get_cbit_position();
>> -        *ebx |= sev_get_reduced_phys_bits() << 6;
>> -        *ecx = 0;
>> -        *edx = 0;
>> +        *eax = *ebx = *ecx = *edx = 0;
>> +        if (sev_enabled()) {
>> +            *eax = 0x2;
>> +            *eax |= sev_es_enabled() ? 0x8 : 0;
>> +            *ebx = sev_get_cbit_position();
>> +            *ebx |= sev_get_reduced_phys_bits() << 6;
>> +        }
>>          break;
>>      default:
>>          /* reserved values: zero */
>> diff --git a/target/i386/sev-stub.c b/target/i386/sev-stub.c
>> deleted file mode 100644
>> index 7e8b6f9a259..00000000000
>> --- a/target/i386/sev-stub.c
>> +++ /dev/null
>> @@ -1,41 +0,0 @@
>> -/*
>> - * QEMU SEV stub
>> - *
>> - * Copyright Advanced Micro Devices 2018
>> - *
>> - * Authors:
>> - *      Brijesh Singh <brijesh.singh@amd.com>
>> - *
>> - * This work is licensed under the terms of the GNU GPL, version 2 or later.
>> - * See the COPYING file in the top-level directory.
>> - *
>> - */
>> -
>> -#include "qemu/osdep.h"
>> -#include "qapi/error.h"
>> -#include "sev.h"
>> -
>> -bool sev_enabled(void)
>> -{
>> -    return false;
>> -}
>> -
>> -uint32_t sev_get_cbit_position(void)
>> -{
>> -    return 0;
>> -}
>> -
>> -uint32_t sev_get_reduced_phys_bits(void)
>> -{
>> -    return 0;
>> -}
>> -
>> -bool sev_es_enabled(void)
>> -{
>> -    return false;
>> -}
>> -
>> -bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp)
>> -{
>> -    g_assert_not_reached();
>> -}
>> diff --git a/target/i386/meson.build b/target/i386/meson.build
>> index a4f45c3ec1d..ae38dc95635 100644
>> --- a/target/i386/meson.build
>> +++ b/target/i386/meson.build
>> @@ -6,7 +6,7 @@
>>    'xsave_helper.c',
>>    'cpu-dump.c',
>>  ))
>> -i386_ss.add(when: 'CONFIG_SEV', if_true: files('host-cpu.c'), if_false: files('sev-stub.c'))
>> +i386_ss.add(when: 'CONFIG_SEV', if_true: files('host-cpu.c'))
>>  
>>  # x86 cpu type
>>  i386_ss.add(when: 'CONFIG_KVM', if_true: files('host-cpu.c'))
>> -- 
>> 2.31.1
>>

