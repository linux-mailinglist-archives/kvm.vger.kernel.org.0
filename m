Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD7042464A
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 20:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbhJFS5T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 14:57:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21229 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229992AbhJFS5S (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 14:57:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633546525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r1gZM96b2xz48C06LwSaVoqZU1gvrxyhuPbUEE/1+tM=;
        b=TzE1IuuhpP5VQYVxK3nmjtomR21Dy5bwbVGJLcET1wtMLqFd8fhu67+KPJ2RkUEUR9zemO
        c3MLw7AI1zYZUON/HzOJBee9RRM8LHnaQ4HzAiawk1qmFt5r8jKqdozm4XPPu/6KYMEQla
        4GccmP6kMdQIcifmPOJX/loyJFCZcoc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-9oOrUtdDNiSReJ42leLBSw-1; Wed, 06 Oct 2021 14:55:24 -0400
X-MC-Unique: 9oOrUtdDNiSReJ42leLBSw-1
Received: by mail-wr1-f70.google.com with SMTP id p12-20020adfc38c000000b00160d6a7e293so301751wrf.18
        for <kvm@vger.kernel.org>; Wed, 06 Oct 2021 11:55:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=r1gZM96b2xz48C06LwSaVoqZU1gvrxyhuPbUEE/1+tM=;
        b=xPU1sGywPww2mGZPBQWx5LQ5DbkkdWX7EatH+eYqCscbghv+/+yUqKDalMjmuDNBBS
         wYK1xCUVTU/DZW/btZ9Mz6tFPPJ0x7SPSeaETL+LsTfJGr8SNVF2IOeuXwR3cZuCKg92
         ZdNGTrUJ0CBrbwh6xfzuUEuty1SOZHAba8eaBZ1pAU6Xz4H242Yj1mbUwydmKnRR73rw
         HgBBSkBPwErann0SibcYXB/6YMWJ6lFlJLhChaPPtz4G786ULLS1HDc4aNba4sSaNobw
         9aj9kFapk9Cl8a8y27TR3rvu0H/589qKyTvhqTX/doQuISR8hN//7vD1VkApb6vxcFq/
         yfCw==
X-Gm-Message-State: AOAM5329/1YuBy4mRhGeqBf7TzwQ69YerzsVuI2hIBrpqui63NrrrObW
        BXMGrpxhWojl+Kx1n6cZYO79cOCqzKg51wkVvZlHjDPHNmjX9SdbXSLslDJ2ESRqCBRN/UcDnOX
        wlEkZmct5Cuni
X-Received: by 2002:adf:9bce:: with SMTP id e14mr23888557wrc.353.1633546522829;
        Wed, 06 Oct 2021 11:55:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxHnltUNfLVZWqKyfI3bMZQ5zkeCMf1ojmcmQjBGmOFQL1VDF7IL12AYR16Mkfl0HlhB6EMvw==
X-Received: by 2002:adf:9bce:: with SMTP id e14mr23888526wrc.353.1633546522586;
        Wed, 06 Oct 2021 11:55:22 -0700 (PDT)
Received: from [192.168.1.36] (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id l17sm21817239wrx.24.2021.10.06.11.55.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 11:55:22 -0700 (PDT)
Message-ID: <6a6629d7-2441-1711-d181-8b2b2127dd21@redhat.com>
Date:   Wed, 6 Oct 2021 20:55:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 13/22] target/i386/sev: Remove stubs by using code
 elision
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org
Cc:     Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
        Sergio Lopez <slp@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
 <20211002125317.3418648-14-philmd@redhat.com>
 <84e1213b-c6c0-85a4-0d3e-854cd3dc0fa0@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
In-Reply-To: <84e1213b-c6c0-85a4-0d3e-854cd3dc0fa0@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/4/21 10:19, Paolo Bonzini wrote:
> On 02/10/21 14:53, Philippe Mathieu-Daudé wrote:
>> Only declare sev_enabled() and sev_es_enabled() when CONFIG_SEV is
>> set, to allow the compiler to elide unused code. Remove unnecessary
>> stubs.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>> ---
>>   include/sysemu/sev.h    | 14 +++++++++++++-
>>   target/i386/sev_i386.h  |  3 ---
>>   target/i386/cpu.c       | 16 +++++++++-------
>>   target/i386/sev-stub.c  | 36 ------------------------------------
>>   target/i386/meson.build |  2 +-
>>   5 files changed, 23 insertions(+), 48 deletions(-)
>>   delete mode 100644 target/i386/sev-stub.c
>>
>> diff --git a/include/sysemu/sev.h b/include/sysemu/sev.h
>> index a329ed75c1c..f5c625bb3b3 100644
>> --- a/include/sysemu/sev.h
>> +++ b/include/sysemu/sev.h
>> @@ -14,9 +14,21 @@
>>   #ifndef QEMU_SEV_H
>>   #define QEMU_SEV_H
>>   -#include "sysemu/kvm.h"
>> +#ifndef CONFIG_USER_ONLY
>> +#include CONFIG_DEVICES /* CONFIG_SEV */
>> +#endif
>>   +#ifdef CONFIG_SEV
>>   bool sev_enabled(void);
>> +bool sev_es_enabled(void);
>> +#else
>> +#define sev_enabled() 0
>> +#define sev_es_enabled() 0
>> +#endif
> 
> This means that sev.h can only be included from target-specific files.
> 
> An alternative could be:
> 
> #ifdef NEED_CPU_H
> # include CONFIG_DEVICES

<command-line>: fatal error: x86_64-linux-user-config-devices.h: No such
file or directory

> #endif
> 
> #if defined NEED_CPU_H && !defined CONFIG_SEV
> # define sev_enabled() 0
> # define sev_es_enabled() 0
> #else
> bool sev_enabled(void);
> bool sev_es_enabled(void);
> #endif
> 
> ... but in fact sysemu/sev.h _is_ only used from x86-specific files. So
> should it be moved to include/hw/i386, and even merged with
> target/i386/sev_i386.h?  Do we need two files?

No clue, I don't think we need. Brijesh?

> 
> Thanks,
> 
> Paolo
> 
>> +uint32_t sev_get_cbit_position(void);
>> +uint32_t sev_get_reduced_phys_bits(void);
>> +
>>   int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp);
>>     #endif
>> diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
>> index 0798ab3519a..2d9a1a0112e 100644
>> --- a/target/i386/sev_i386.h
>> +++ b/target/i386/sev_i386.h
>> @@ -24,10 +24,7 @@
>>   #define SEV_POLICY_DOMAIN       0x10
>>   #define SEV_POLICY_SEV          0x20
>>   -extern bool sev_es_enabled(void);
>>   extern SevInfo *sev_get_info(void);
>> -extern uint32_t sev_get_cbit_position(void);
>> -extern uint32_t sev_get_reduced_phys_bits(void);
>>   extern char *sev_get_launch_measurement(void);
>>   extern SevCapability *sev_get_capabilities(Error **errp);
>>   extern SevAttestationReport *
>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>> index e169a01713d..27992bdc9f8 100644
>> --- a/target/i386/cpu.c
>> +++ b/target/i386/cpu.c
>> @@ -25,8 +25,8 @@
>>   #include "tcg/helper-tcg.h"
>>   #include "sysemu/reset.h"
>>   #include "sysemu/hvf.h"
>> +#include "sysemu/sev.h"
>>   #include "kvm/kvm_i386.h"
>> -#include "sev_i386.h"
>>   #include "qapi/error.h"
>>   #include "qapi/qapi-visit-machine.h"
>>   #include "qapi/qmp/qerror.h"
>> @@ -38,6 +38,7 @@
>>   #include "exec/address-spaces.h"
>>   #include "hw/boards.h"
>>   #include "hw/i386/sgx-epc.h"
>> +#include "sev_i386.h"
>>   #endif
>>     #include "disas/capstone.h"
>> @@ -5764,12 +5765,13 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t
>> index, uint32_t count,
>>           *edx = 0;
>>           break;
>>       case 0x8000001F:
>> -        *eax = sev_enabled() ? 0x2 : 0;
>> -        *eax |= sev_es_enabled() ? 0x8 : 0;
>> -        *ebx = sev_get_cbit_position();
>> -        *ebx |= sev_get_reduced_phys_bits() << 6;
>> -        *ecx = 0;
>> -        *edx = 0;
>> +        *eax = *ebx = *ecx = *edx = 0;
>> +        if (sev_enabled()) {
>> +            *eax = 0x2;
>> +            *eax |= sev_es_enabled() ? 0x8 : 0;
>> +            *ebx = sev_get_cbit_position();
>> +            *ebx |= sev_get_reduced_phys_bits() << 6;
>> +        }
>>           break;

