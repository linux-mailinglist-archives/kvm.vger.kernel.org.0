Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4E9214BBE
	for <lists+kvm@lfdr.de>; Sun,  5 Jul 2020 11:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgGEJ5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Jul 2020 05:57:36 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:46374 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726572AbgGEJ5f (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 5 Jul 2020 05:57:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593943053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=+gUgX92JeD7WLhazOuEI6R4E6yaZ0C2n0lMzBRIGICM=;
        b=SMJgy7yeipSe9uyPIPsizMi/62fCrf/Ss7vqaOWzbi6RuOxITNyndGmvMraUIKdvwgSB/m
        p9CjmiMEEzweik7exumt2g2Ii/fqL6dG9RgOo4L5N0DIqApwAwX/lEzeuSjvkv4dcnABEu
        hcgw3ttIDQRmF7ieVFzl6PVKU33SvkU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-gfgytSTFPKSbQYu7ROJJTg-1; Sun, 05 Jul 2020 05:57:31 -0400
X-MC-Unique: gfgytSTFPKSbQYu7ROJJTg-1
Received: by mail-wm1-f72.google.com with SMTP id y204so30379093wmd.2
        for <kvm@vger.kernel.org>; Sun, 05 Jul 2020 02:57:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=+gUgX92JeD7WLhazOuEI6R4E6yaZ0C2n0lMzBRIGICM=;
        b=Ace1Fq4r+Pjgs98xWmfzOlDyWMqOLAWx+4tMglak0J5W/1DO7OHI7H0SiZBUk4GnuC
         692hJc+dwClVBq/U0V/D8GYcgQrEf/CezWWJqngD5KumkC0cvUSs66hyuB7SZhb0SYIo
         SM17IPqSWF4nj4oRz1rK1rm6qr/c4o5dd0FefEB6c8BnPXs11xynhhMik3PI5F6xTb76
         PKGUwdYxjdMeCu9hwPhdAG6vev7WPnfD89csKStgJSiJ36x9Q7CJg4UzydJWEf6QNfTP
         9/ixG2vbgGBxA9p2XOv3EWklYL3RTP6jDJ+qCT3Oy+WorwR+P7xzj9wBW1cTEqw/1dVN
         Ie4g==
X-Gm-Message-State: AOAM5320zEq6nS0sLn+xBFJi6zUV8mmqg5E6Y5OmfS8rpA37YSBTjwOZ
        qhYIiQWVMgFmmG+32QXTgcB8WgLdxLmGT1D7XwxukSa2XSfYKRNy5F9QIJDL6CJndH4kCHe+aQ3
        c9NlLrep+KjA1
X-Received: by 2002:a1c:5f41:: with SMTP id t62mr2692282wmb.53.1593943050542;
        Sun, 05 Jul 2020 02:57:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxirFuQmtmWTsM9nGieBKS0Jk/VlohalmlCkiqhmr/qsz7u6D3jsAKhovtjwGvWv46inRbySg==
X-Received: by 2002:a1c:5f41:: with SMTP id t62mr2692258wmb.53.1593943050341;
        Sun, 05 Jul 2020 02:57:30 -0700 (PDT)
Received: from [192.168.1.39] (1.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.1])
        by smtp.gmail.com with ESMTPSA id i67sm17186873wma.12.2020.07.05.02.57.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 02:57:29 -0700 (PDT)
Subject: Re: [RFC PATCH 4/7] accel/kvm: Simplify kvm_set_sigmask_len()
To:     Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org
Cc:     Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Richard Henderson <rth@twiddle.net>, qemu-s390x@nongnu.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Peter Maydell <peter.maydell@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, qemu-arm@nongnu.org,
        Cornelia Huck <cohuck@redhat.com>, qemu-ppc@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Huth <thuth@redhat.com>
References: <20200623105052.1700-1-philmd@redhat.com>
 <20200623105052.1700-5-philmd@redhat.com>
 <cc7b7da2-fcf8-5c5c-5c3c-9e96368ddd22@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Autocrypt: addr=philmd@redhat.com; keydata=
 mQINBDXML8YBEADXCtUkDBKQvNsQA7sDpw6YLE/1tKHwm24A1au9Hfy/OFmkpzo+MD+dYc+7
 bvnqWAeGweq2SDq8zbzFZ1gJBd6+e5v1a/UrTxvwBk51yEkadrpRbi+r2bDpTJwXc/uEtYAB
 GvsTZMtiQVA4kRID1KCdgLa3zztPLCj5H1VZhqZsiGvXa/nMIlhvacRXdbgllPPJ72cLUkXf
 z1Zu4AkEKpccZaJspmLWGSzGu6UTZ7UfVeR2Hcc2KI9oZB1qthmZ1+PZyGZ/Dy+z+zklC0xl
 XIpQPmnfy9+/1hj1LzJ+pe3HzEodtlVA+rdttSvA6nmHKIt8Ul6b/h1DFTmUT1lN1WbAGxmg
 CH1O26cz5nTrzdjoqC/b8PpZiT0kO5MKKgiu5S4PRIxW2+RA4H9nq7nztNZ1Y39bDpzwE5Sp
 bDHzd5owmLxMLZAINtCtQuRbSOcMjZlg4zohA9TQP9krGIk+qTR+H4CV22sWldSkVtsoTaA2
 qNeSJhfHQY0TyQvFbqRsSNIe2gTDzzEQ8itsmdHHE/yzhcCVvlUzXhAT6pIN0OT+cdsTTfif
 MIcDboys92auTuJ7U+4jWF1+WUaJ8gDL69ThAsu7mGDBbm80P3vvUZ4fQM14NkxOnuGRrJxO
 qjWNJ2ZUxgyHAh5TCxMLKWZoL5hpnvx3dF3Ti9HW2dsUUWICSQARAQABtDJQaGlsaXBwZSBN
 YXRoaWV1LURhdWTDqSAoUGhpbCkgPHBoaWxtZEByZWRoYXQuY29tPokCVQQTAQgAPwIbDwYL
 CQgHAwIGFQgCCQoLBBYCAwECHgECF4AWIQSJweePYB7obIZ0lcuio/1u3q3A3gUCXsfWwAUJ
 KtymWgAKCRCio/1u3q3A3ircD/9Vjh3aFNJ3uF3hddeoFg1H038wZr/xi8/rX27M1Vj2j9VH
 0B8Olp4KUQw/hyO6kUxqkoojmzRpmzvlpZ0cUiZJo2bQIWnvScyHxFCv33kHe+YEIqoJlaQc
 JfKYlbCoubz+02E2A6bFD9+BvCY0LBbEj5POwyKGiDMjHKCGuzSuDRbCn0Mz4kCa7nFMF5Jv
 piC+JemRdiBd6102ThqgIsyGEBXuf1sy0QIVyXgaqr9O2b/0VoXpQId7yY7OJuYYxs7kQoXI
 6WzSMpmuXGkmfxOgbc/L6YbzB0JOriX0iRClxu4dEUg8Bs2pNnr6huY2Ft+qb41RzCJvvMyu
 gS32LfN0bTZ6Qm2A8ayMtUQgnwZDSO23OKgQWZVglGliY3ezHZ6lVwC24Vjkmq/2yBSLakZE
 6DZUjZzCW1nvtRK05ebyK6tofRsx8xB8pL/kcBb9nCuh70aLR+5cmE41X4O+MVJbwfP5s/RW
 9BFSL3qgXuXso/3XuWTQjJJGgKhB6xXjMmb1J4q/h5IuVV4juv1Fem9sfmyrh+Wi5V1IzKI7
 RPJ3KVb937eBgSENk53P0gUorwzUcO+ASEo3Z1cBKkJSPigDbeEjVfXQMzNt0oDRzpQqH2vp
 apo2jHnidWt8BsckuWZpxcZ9+/9obQ55DyVQHGiTN39hkETy3Emdnz1JVHTU0Q==
Message-ID: <73417f60-edae-4a7d-4808-eb371e95044a@redhat.com>
Date:   Sun, 5 Jul 2020 11:57:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <cc7b7da2-fcf8-5c5c-5c3c-9e96368ddd22@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/5/20 9:12 AM, Paolo Bonzini wrote:
> On 23/06/20 12:50, Philippe Mathieu-Daudé wrote:
>> The sigmask_len is a property of the accelerator, not the VM.
>> Simplify by directly using the global kvm_state, remove the
>> unnecessary KVMState* argument.
> 
> This is not entirely true, if there were multiple KVMStates how would
> you know which one to read from?  So it would have to be a global variable.

Ah I guess I understand. Thanks for reviewing and queuing the rest!

> 
> Paolo
> 
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>> ---
>>  include/sysemu/kvm.h | 2 +-
>>  accel/kvm/kvm-all.c  | 4 ++--
>>  target/mips/kvm.c    | 2 +-
>>  3 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
>> index 3662641c99..44c1767a7f 100644
>> --- a/include/sysemu/kvm.h
>> +++ b/include/sysemu/kvm.h
>> @@ -469,7 +469,7 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *env, uint32_t function,
>>  uint64_t kvm_arch_get_supported_msr_feature(KVMState *s, uint32_t index);
>>  
>>  
>> -void kvm_set_sigmask_len(KVMState *s, unsigned int sigmask_len);
>> +void kvm_set_sigmask_len(unsigned int sigmask_len);
>>  
>>  #if !defined(CONFIG_USER_ONLY)
>>  int kvm_physical_memory_addr_from_host(KVMState *s, void *ram_addr,
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index afd14492a0..7b3f76f23d 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -2240,9 +2240,9 @@ err:
>>      return ret;
>>  }
>>  
>> -void kvm_set_sigmask_len(KVMState *s, unsigned int sigmask_len)
>> +void kvm_set_sigmask_len(unsigned int sigmask_len)
>>  {
>> -    s->sigmask_len = sigmask_len;
>> +    kvm_state->sigmask_len = sigmask_len;
>>  }
>>  
>>  static void kvm_handle_io(uint16_t port, MemTxAttrs attrs, void *data, int direction,
>> diff --git a/target/mips/kvm.c b/target/mips/kvm.c
>> index 0adfa70210..cc3e09bdef 100644
>> --- a/target/mips/kvm.c
>> +++ b/target/mips/kvm.c
>> @@ -48,7 +48,7 @@ unsigned long kvm_arch_vcpu_id(CPUState *cs)
>>  int kvm_arch_init(MachineState *ms, KVMState *s)
>>  {
>>      /* MIPS has 128 signals */
>> -    kvm_set_sigmask_len(s, 16);
>> +    kvm_set_sigmask_len(16);
>>  
>>      kvm_mips_fpu_cap = kvm_check_extension(KVM_CAP_MIPS_FPU);
>>      kvm_mips_msa_cap = kvm_check_extension(KVM_CAP_MIPS_MSA);
>>
> 

