Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3167E3A3185
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 18:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbhFJQ5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 12:57:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31836 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230345AbhFJQ5z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 12:57:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623344158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AI5wK1GMbdZ9jlyDAgMAb+0uiOBJAVzZzToMBcOHjZc=;
        b=Ws8bduqVEK3h9Ur0F6p/6AFKEflRiAWcWDP1OFxV1V8NXebjMLrLPGOnQQnrDHm79secXp
        IL58Pw21xIsK0Af1IvUrUWBN1tomCdXxhAIhVbWi4kLnxeRUe8kivPzLaKKWui9YEENYAW
        ZL2EHnOZfdldNiw24dINZR0p5UAIFcY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-IUE8JWCaM_q1DOBjqKz9AA-1; Thu, 10 Jun 2021 12:55:57 -0400
X-MC-Unique: IUE8JWCaM_q1DOBjqKz9AA-1
Received: by mail-wr1-f70.google.com with SMTP id x9-20020adfffc90000b02901178add5f60so1257958wrs.5
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 09:55:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AI5wK1GMbdZ9jlyDAgMAb+0uiOBJAVzZzToMBcOHjZc=;
        b=GJFFg5Bvk/ou+cDZab51vPhZZJ9KDyP+NMjEWQYIgd5bWt79hLY/DzP7C59bKbjK2z
         2silbW6DTXIdZncXNcp39VU8i/4f4opNttQcfApzAqh/GMgx8RFXMZ94mE8N6tnO2Iif
         LtIhSeN54dzqyHiBY1JztzgkMFnb4QL76XL+bVtbunPsnOT1K0h6usllgJeHjcxgrcyH
         OQp5zA83w4VO2MjPMvoRs6jl/H1DFphKAwWMilfhDsNn6qpWBgWQzAOf25DZ5/wFvNXI
         jGu3HHPd20pxVTX0dWKwo/zPqYS3udU25bi4UJl91pHoGti/FOS/5AcxHTRY2QEpbn6c
         J90Q==
X-Gm-Message-State: AOAM530LUaogMHt7G3pdmSUYtIsJ1MZkiTWCQhXgyuuRlDJRtKZSa/VD
        6i59GNsJgDA9A989HVOF7tawMy+Xdi52mL0NfWF7JhtIJd6pdAuc4S3UGrlpTgn575dyf4eCdG5
        RwezB4wQ6QUCeCIh95+vZQG3Kkyxi9JmPXd1NI+Rj6N3CxubKuAfpQOVs9luaiiIo
X-Received: by 2002:a7b:c098:: with SMTP id r24mr15812264wmh.35.1623344155496;
        Thu, 10 Jun 2021 09:55:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyN2bAXTSOI9J1jpar1JagoWnksFyVqEcNGjVWxN51j3lhOHLq8J1qDRTfKudFVPc+/RjPm5Q==
X-Received: by 2002:a7b:c098:: with SMTP id r24mr15812249wmh.35.1623344155271;
        Thu, 10 Jun 2021 09:55:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.gmail.com with ESMTPSA id q20sm5222307wrf.45.2021.06.10.09.55.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 09:55:54 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 1/2] x86: Do not assign values to unaligned
 pointer to 128 bits
To:     Jacob Xu <jacobhxu@google.com>, Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm list <kvm@vger.kernel.org>
References: <20210511015016.815461-1-jacobhxu@google.com>
 <CAJ5mJ6jUvHN5Mh_hVR5rArvA6aFNdhDCinQd1ZjLg=ht=J4ijw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6a610605-cdb3-572f-865d-005c275a189b@redhat.com>
Date:   Thu, 10 Jun 2021 18:55:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAJ5mJ6jUvHN5Mh_hVR5rArvA6aFNdhDCinQd1ZjLg=ht=J4ijw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/06/21 18:14, Jacob Xu wrote:
> ping (previous ping just now contained html subpart, oops).

Queued, thanks!

Paolo

> On Mon, May 10, 2021 at 6:50 PM Jacob Xu <jacobhxu@google.com> wrote:
>>
>> When compiled with clang, the following statement gets converted into a
>> movaps instructions.
>> mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
>>
>> Since mem is an unaligned pointer to sse_union, we get a GP when
>> running. Let's avoid using a pointer to sse_union at all, since doing so
>> implies that the pointer is aligned to 128 bits.
>>
>> Fixes: e5e76263b5 ("x86: add additional test cases for sse exceptions to
>> emulator.c")
>>
>> Signed-off-by: Jacob Xu <jacobhxu@google.com>
>> ---
>>   x86/emulator.c | 67 +++++++++++++++++++++++++-------------------------
>>   1 file changed, 33 insertions(+), 34 deletions(-)
>>
>> diff --git a/x86/emulator.c b/x86/emulator.c
>> index 9705073..1d5c172 100644
>> --- a/x86/emulator.c
>> +++ b/x86/emulator.c
>> @@ -645,37 +645,34 @@ static void test_muldiv(long *mem)
>>
>>   typedef unsigned __attribute__((vector_size(16))) sse128;
>>
>> -typedef union {
>> -    sse128 sse;
>> -    unsigned u[4];
>> -} sse_union;
>> -
>> -static bool sseeq(sse_union *v1, sse_union *v2)
>> +static bool sseeq(uint32_t *v1, uint32_t *v2)
>>   {
>>       bool ok = true;
>>       int i;
>>
>>       for (i = 0; i < 4; ++i) {
>> -       ok &= v1->u[i] == v2->u[i];
>> +       ok &= v1[i] == v2[i];
>>       }
>>
>>       return ok;
>>   }
>>
>> -static __attribute__((target("sse2"))) void test_sse(sse_union *mem)
>> +static __attribute__((target("sse2"))) void test_sse(uint32_t *mem)
>>   {
>> -       sse_union v;
>> +       sse128 vv;
>> +       uint32_t *v = (uint32_t *)&vv;
>>
>>          write_cr0(read_cr0() & ~6); /* EM, TS */
>>          write_cr4(read_cr4() | 0x200); /* OSFXSR */
>> +       memset(&vv, 0, sizeof(vv));
>>
>>   #define TEST_RW_SSE(insn) do { \
>> -               v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4; \
>> -               asm(insn " %1, %0" : "=m"(*mem) : "x"(v.sse)); \
>> -               report(sseeq(&v, mem), insn " (read)"); \
>> -               mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8; \
>> -               asm(insn " %1, %0" : "=x"(v.sse) : "m"(*mem)); \
>> -               report(sseeq(&v, mem), insn " (write)"); \
>> +               v[0] = 1; v[1] = 2; v[2] = 3; v[3] = 4; \
>> +               asm(insn " %1, %0" : "=m"(*mem) : "x"(vv) : "memory"); \
>> +               report(sseeq(v, mem), insn " (read)"); \
>> +               mem[0] = 5; mem[1] = 6; mem[2] = 7; mem[3] = 8; \
>> +               asm(insn " %1, %0" : "=x"(vv) : "m"(*mem) : "memory"); \
>> +               report(sseeq(v, mem), insn " (write)"); \
>>   } while (0)
>>
>>          TEST_RW_SSE("movdqu");
>> @@ -704,40 +701,41 @@ static void cross_movups_handler(struct ex_regs *regs)
>>
>>   static __attribute__((target("sse2"))) void test_sse_exceptions(void *cross_mem)
>>   {
>> -       sse_union v;
>> -       sse_union *mem;
>> +       sse128 vv;
>> +       uint32_t *v = (uint32_t *)&vv;
>> +       uint32_t *mem;
>>          uint8_t *bytes = cross_mem; // aligned on PAGE_SIZE*2
>>          void *page2 = (void *)(&bytes[4096]);
>>          struct pte_search search;
>>          pteval_t orig_pte;
>>
>>          // setup memory for unaligned access
>> -       mem = (sse_union *)(&bytes[8]);
>> +       mem = (uint32_t *)(&bytes[8]);
>>
>>          // test unaligned access for movups, movupd and movaps
>> -       v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
>> -       mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
>> -       asm("movups %1, %0" : "=m"(*mem) : "x"(v.sse));
>> -       report(sseeq(&v, mem), "movups unaligned");
>> -
>> -       v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
>> -       mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
>> -       asm("movupd %1, %0" : "=m"(*mem) : "x"(v.sse));
>> -       report(sseeq(&v, mem), "movupd unaligned");
>> +       v[0] = 1; v[1] = 2; v[2] = 3; v[3] = 4;
>> +       mem[0] = 5; mem[1] = 6; mem[2] = 8; mem[3] = 9;
>> +       asm("movups %1, %0" : "=m"(*mem) : "x"(vv) : "memory");
>> +       report(sseeq(v, mem), "movups unaligned");
>> +
>> +       v[0] = 1; v[1] = 2; v[2] = 3; v[3] = 4;
>> +       mem[0] = 5; mem[1] = 6; mem[2] = 7; mem[3] = 8;
>> +       asm("movupd %1, %0" : "=m"(*mem) : "x"(vv) : "memory");
>> +       report(sseeq(v, mem), "movupd unaligned");
>>          exceptions = 0;
>>          handle_exception(GP_VECTOR, unaligned_movaps_handler);
>>          asm("movaps %1, %0\n\t unaligned_movaps_cont:"
>> -                       : "=m"(*mem) : "x"(v.sse));
>> +                       : "=m"(*mem) : "x"(vv));
>>          handle_exception(GP_VECTOR, 0);
>>          report(exceptions == 1, "unaligned movaps exception");
>>
>>          // setup memory for cross page access
>> -       mem = (sse_union *)(&bytes[4096-8]);
>> -       v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
>> -       mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
>> +       mem = (uint32_t *)(&bytes[4096-8]);
>> +       v[0] = 1; v[1] = 2; v[2] = 3; v[3] = 4;
>> +       mem[0] = 5; mem[1] = 6; mem[2] = 7; mem[3] = 8;
>>
>> -       asm("movups %1, %0" : "=m"(*mem) : "x"(v.sse));
>> -       report(sseeq(&v, mem), "movups unaligned crosspage");
>> +       asm("movups %1, %0" : "=m"(*mem) : "x"(vv) : "memory");
>> +       report(sseeq(v, mem), "movups unaligned crosspage");
>>
>>          // invalidate second page
>>          search = find_pte_level(current_page_table(), page2, 1);
>> @@ -747,7 +745,8 @@ static __attribute__((target("sse2"))) void test_sse_exceptions(void *cross_mem)
>>
>>          exceptions = 0;
>>          handle_exception(PF_VECTOR, cross_movups_handler);
>> -       asm("movups %1, %0\n\t cross_movups_cont:" : "=m"(*mem) : "x"(v.sse));
>> +       asm("movups %1, %0\n\t cross_movups_cont:" : "=m"(*mem) : "x"(vv) :
>> +                       "memory");
>>          handle_exception(PF_VECTOR, 0);
>>          report(exceptions == 1, "movups crosspage exception");
>>
>> --
>> 2.31.1.607.g51e8a6a459-goog
>>
> 

