Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA8611C192
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 01:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbfLLAkg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 19:40:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26880 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727267AbfLLAkg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 19:40:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576111235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Ho9hYEXWN0MoUB0J4MdxrHz2s2KYrC6sXYLRdDAzHA=;
        b=QzwuRMeC6O6lBHIXoRY3TvXIbjmbulkHYHWhjyRrN9/ncvOXv7/V079vkdzQHCpJ81A1p9
        YdJ7jgJadAb78pEiABbfsuHE7HSuJtvSRrLKjFwT8fy9x8BfmDB/FS5/Y2NTgWVkyhF0lp
        SVbQYplJvBL594QLSX+pvK5BlIzPWEo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-5Cx6XvU9PZmsZAq8rvbXkg-1; Wed, 11 Dec 2019 19:40:34 -0500
X-MC-Unique: 5Cx6XvU9PZmsZAq8rvbXkg-1
Received: by mail-wr1-f69.google.com with SMTP id z14so326157wrs.4
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 16:40:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0Ho9hYEXWN0MoUB0J4MdxrHz2s2KYrC6sXYLRdDAzHA=;
        b=jjRcTlDrvgEPBMrUY322+nxSQJRPDtbudXKoUEP9NqVy0tw3TPJfXPpZZrZdhXjKty
         l08hGkTcc7sZA4YugW+CMiM0JgUd5l1/Fp2ovQkcS16+Tsap0D4ra+qzq5lIKer1fN1E
         tbPT4nS3HJCV6vEh+R9LCZ1b834YSZFFvGcWN9gIgoRJEz6C9uUVDPNrN+D29rD9+bLi
         wLRAkUXBFlLYkcU6VO431wBs+dtc+zWvmZ5w/KaNgTWs2lHkv3i/anXbnUeUToahGIxD
         /3dEWJ+ziKNZ5VE43k9iC/RuDLxDCm0Guau0K7Xb2UZQKzlXY8daNKQvfJCyQn7FVPgN
         giTw==
X-Gm-Message-State: APjAAAXclnHmZX8ComBd9g7XO/BnJkiAuXyY+yHPwSfmiVY+Lo8YUSIP
        szhhQ3Umfa9c8Was47OhR6+4ubYu2Xeg5EEkPKEbaNXN8UkAt+uIrvSPVeM0pP09/EQzWRQprFX
        Fy5ew7dv5AQ2p
X-Received: by 2002:a7b:c1d3:: with SMTP id a19mr2930572wmj.127.1576111232692;
        Wed, 11 Dec 2019 16:40:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqw1HYdZRmXr4vxUkxgc+Pjrc8YpEu7gC5TgCVRUkrPuZq6nDsF88F1DNGoHvcud6gPFfKSC9A==
X-Received: by 2002:a7b:c1d3:: with SMTP id a19mr2930549wmj.127.1576111232373;
        Wed, 11 Dec 2019 16:40:32 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id z3sm4070110wrs.94.2019.12.11.16.40.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 16:40:31 -0800 (PST)
Subject: Re: [PATCH kvm-unit-tests] Update AMD instructions to conform to LLVM
 assembler
To:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, drjones@redhat.com
References: <20190220202442.145494-1-pshier@google.com>
 <CALMp9eRMbht+7xHXJV90MSs52LtjjdCtVeCdd_=5nqeSms8VxQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <169fb4bb-f77d-3f79-3024-fc710dc6c060@redhat.com>
Date:   Thu, 12 Dec 2019 01:40:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CALMp9eRMbht+7xHXJV90MSs52LtjjdCtVeCdd_=5nqeSms8VxQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/12/19 21:22, Jim Mattson wrote:
> On Wed, Feb 20, 2019 at 12:25 PM Peter Shier <pshier@google.com> wrote:
>>
>> The GNU assembler (gas) allows omitting operands where there is only a
>> single choice e.g. "VMRUN rAX".The LLVM assembler requires those operands
>> even though they are the default and only choice.
>>
>> In addition, LLVM does not allow a CLGI instruction with a terminating
>> \n\t. Adding a ; separator after the instruction is a workaround.
>>
>> Signed-off-by: Peter Shier <pshier@google.com>
>> Reviewed-by: Marc Orr <marcorr@google.com>
>> Reviewed-by: Jim Mattson <jmattson@google.com>
>> ---
>>  x86/svm.c | 16 ++++++++--------
>>  1 file changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/x86/svm.c b/x86/svm.c
>> index bc74e7c690a8..e5cb730b08cb 100644
>> --- a/x86/svm.c
>> +++ b/x86/svm.c
>> @@ -154,7 +154,7 @@ static void vmcb_ident(struct vmcb *vmcb)
>>      struct descriptor_table_ptr desc_table_ptr;
>>
>>      memset(vmcb, 0, sizeof(*vmcb));
>> -    asm volatile ("vmsave" : : "a"(vmcb_phys) : "memory");
>> +    asm volatile ("vmsave %0" : : "a"(vmcb_phys) : "memory");
>>      vmcb_set_seg(&save->es, read_es(), 0, -1U, data_seg_attr);
>>      vmcb_set_seg(&save->cs, read_cs(), 0, -1U, code_seg_attr);
>>      vmcb_set_seg(&save->ss, read_ss(), 0, -1U, data_seg_attr);
>> @@ -262,20 +262,20 @@ static void test_run(struct test *test, struct vmcb *vmcb)
>>      do {
>>          tsc_start = rdtsc();
>>          asm volatile (
>> -            "clgi \n\t"
>> -            "vmload \n\t"
>> +            "clgi;\n\t" // semi-colon needed for LLVM compatibility
>> +            "vmload %0\n\t"
>>              "mov regs+0x80, %%r15\n\t"  // rflags
>>              "mov %%r15, 0x170(%0)\n\t"
>>              "mov regs, %%r15\n\t"       // rax
>>              "mov %%r15, 0x1f8(%0)\n\t"
>>              LOAD_GPR_C
>> -            "vmrun \n\t"
>> +            "vmrun %0\n\t"
>>              SAVE_GPR_C
>>              "mov 0x170(%0), %%r15\n\t"  // rflags
>>              "mov %%r15, regs+0x80\n\t"
>>              "mov 0x1f8(%0), %%r15\n\t"  // rax
>>              "mov %%r15, regs\n\t"
>> -            "vmsave \n\t"
>> +            "vmsave %0\n\t"
>>              "stgi"
>>              : : "a"(vmcb_phys)
>>              : "rbx", "rcx", "rdx", "rsi",
>> @@ -330,7 +330,7 @@ static bool check_no_vmrun_int(struct test *test)
>>
>>  static void test_vmrun(struct test *test)
>>  {
>> -    asm volatile ("vmrun" : : "a"(virt_to_phys(test->vmcb)));
>> +    asm volatile ("vmrun %0" : : "a"(virt_to_phys(test->vmcb)));
>>  }
>>
>>  static bool check_vmrun(struct test *test)
>> @@ -1241,7 +1241,7 @@ static bool lat_svm_insn_finished(struct test *test)
>>
>>      for ( ; runs != 0; runs--) {
>>          tsc_start = rdtsc();
>> -        asm volatile("vmload\n\t" : : "a"(vmcb_phys) : "memory");
>> +        asm volatile("vmload %0\n\t" : : "a"(vmcb_phys) : "memory");
>>          cycles = rdtsc() - tsc_start;
>>          if (cycles > latvmload_max)
>>              latvmload_max = cycles;
>> @@ -1250,7 +1250,7 @@ static bool lat_svm_insn_finished(struct test *test)
>>          vmload_sum += cycles;
>>
>>          tsc_start = rdtsc();
>> -        asm volatile("vmsave\n\t" : : "a"(vmcb_phys) : "memory");
>> +        asm volatile("vmsave %0\n\t" : : "a"(vmcb_phys) : "memory");
>>          cycles = rdtsc() - tsc_start;
>>          if (cycles > latvmsave_max)
>>              latvmsave_max = cycles;
> 
> Ping.
> 

I am applying it, but I'm seriously puzzled by the clgi one.  Can you
open a bug on LLVM?

Paolo

