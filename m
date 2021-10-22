Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86BF4373A4
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 10:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbhJVI35 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 04:29:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34178 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231984AbhJVI34 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 04:29:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634891259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v3oZmb5X5Wiq6TAUc+R676kz52C0MZzlKXhj1RnIhDQ=;
        b=BQOMWmjdwyeBf5iBflFBrpqycP/zYk68t3p0gvVxN7IO+ZBtJUNnAx7CpKScld5SLpldte
        bX03mXe0/1f9YBwD3Jmp8pY1we7EAZLmXhOwjiKa9bfk4JW7mv/DRf7HdHMG/6ibmhfgAl
        /YTUfgbMkwSA3XEj6rXsQRn1jvKItNM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-XqfT97N7NXWBK-3xORFxGw-1; Fri, 22 Oct 2021 04:27:37 -0400
X-MC-Unique: XqfT97N7NXWBK-3xORFxGw-1
Received: by mail-ed1-f71.google.com with SMTP id u17-20020a50d511000000b003daa3828c13so2963744edi.12
        for <kvm@vger.kernel.org>; Fri, 22 Oct 2021 01:27:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=v3oZmb5X5Wiq6TAUc+R676kz52C0MZzlKXhj1RnIhDQ=;
        b=NVi0kcXQ+xM1OCU7VCpHZLIcx2weN5O2HD00UE2UTJrENVRV/HM/BmMzTp61xkeGsZ
         ovub7Z5/zkdta6gNFK54EIUrZtk6QgTC3ZQrsKyruYlTlLAwkZI+93ICUzUNta5trCCC
         kEO4rK0SUXJmcZ84KYpQP4/O7ZM3WR1gus6zGju78aTGMkuPy6yvLrzol6f5MAwHxmi6
         3mNYAf3REL3NzzzWogHJIS7qwOS5L5nNwjvlGz3Vgj1rkVtj8StRaGPjHLMeYmurZpYS
         oImwHFGOGcIPnsbsLi6JDGXmfdhjPhUtHVrGLfjp18467I87gsqBu4z2LxWPVeQtGOuY
         S4LQ==
X-Gm-Message-State: AOAM533jKZ1/invy35mrZ/21g0nQEfGr5JDQVonfnd03F7cgWs8BUA3j
        71lMu+YBLdUjNZMVBooBpLF15O24s6lDK2d/w9wyn3b79ULYkB+AxfGfANhO/Kr12H9VIz0mOF6
        iSDhF/bChtAXd
X-Received: by 2002:a17:907:868c:: with SMTP id qa12mr13578206ejc.346.1634891256595;
        Fri, 22 Oct 2021 01:27:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPwRDKvf75gYruYmYeFWBYl4p46bdPXTTIyIva9IFWQeizVMcT9wTYm0zHNbHaMEGqt6llzg==
X-Received: by 2002:a17:907:868c:: with SMTP id qa12mr13578194ejc.346.1634891256399;
        Fri, 22 Oct 2021 01:27:36 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id d22sm3536082ejj.47.2021.10.22.01.27.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 01:27:35 -0700 (PDT)
Message-ID: <de8dbc64-ae2d-aa9f-a973-171feb5874d6@redhat.com>
Date:   Fri, 22 Oct 2021 10:27:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] KVM: x86: advertise absence of X86_BUG_NULL_SEG via CPUID
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        thomas.lendacky@amd.com, dgilbert@redhat.com
References: <20211021211958.1531754-1-pbonzini@redhat.com>
 <CALMp9eR3bt5P_+ZTJqcckL1pbZCyS6dCNK8o2OQR-atU_A_jtQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALMp9eR3bt5P_+ZTJqcckL1pbZCyS6dCNK8o2OQR-atU_A_jtQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/10/21 23:36, Jim Mattson wrote:
> On Thu, Oct 21, 2021 at 2:20 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> Guests have X86_BUG_NULL_SEG if and only if the host have it.  Use
>> the info from static_cpu_has_bug to form the 0x80000021 CPUID leaf that
>> was defined for Zen3.  Userspace can then set the bit even on older
>> CPUs that do not have the bug, such as Zen2.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>   arch/x86/kvm/cpuid.c | 17 ++++++++++++++++-
>>   1 file changed, 16 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 2d70edb0f323..b51398e1727b 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -902,7 +902,13 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>>                  entry->edx = 0;
>>                  break;
>>          case 0x80000000:
>> -               entry->eax = min(entry->eax, 0x8000001f);
>> +               entry->eax = min(entry->eax, 0x80000021);
>> +               /*
>> +                * X86_BUG_NULL_SEG is not reported in CPUID on Zen2; in
>> +                * that case, provide the CPUID leaf ourselves.
>> +                */
> 
> I think this is backwards. !X86_BUG_NULL_SEG isn't reported in CPUID on Zen2.

Right I should use the name of the bit instead.

>> +               if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
>> +                       entry->eax = max(entry->eax, 0x80000021);
>>                  break;
>>          case 0x80000001:
>>                  cpuid_entry_override(entry, CPUID_8000_0001_EDX);
>> @@ -973,6 +979,15 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>>                          entry->ebx &= ~GENMASK(11, 6);
>>                  }
>>                  break;
>> +       case 0x80000020:
>> +               entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
>> +               break;
>> +       case 0x80000021:
>> +               entry->ebx = entry->ecx = entry->edx = 0;
>> +               entry->eax &= BIT(6);
> 
> While we're here, shouldn't bit 0 (Processor ignores nested data
> breakpoints) and bit 2 (LFENCE is always dispatch serializing) also
> match the hardware?

Yes, that makes sense.  Just wanted to gauge whether anybody thought it 
a really bad idea.

Paolo

> 
>> +               if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
>> +                       entry->eax |= BIT(6);
>> +               break;
>>          /*Add support for Centaur's CPUID instruction*/
>>          case 0xC0000000:
>>                  /*Just support up to 0xC0000004 now*/
>> --
>> 2.27.0
>>
> 

