Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73D82124F66
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 18:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbfLRRdi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 12:33:38 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38849 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727071AbfLRRdi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Dec 2019 12:33:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576690417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/2b/vDqw+ozQRfXoTPtUPyy72TArTScgbED5dzJFnaE=;
        b=KzQ1cvBKtNQF3VRMKTZlKdvrD4Wsuqe6ZwItyEaJlqb3MHhjqU68Ps1xiuAmDPNkbay55l
        fiGx8Tv/U/seuzmhXkDzCFvqCmOER4WBntV8EIRfF2PQOJvmreNHwsTxUsyvL1orOQ8Frb
        2qXKb+aHDVFRxD6br3KeQ7h/iNGv1E8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-Qj4e2DH9Ps-TGnxKM92FFg-1; Wed, 18 Dec 2019 12:33:36 -0500
X-MC-Unique: Qj4e2DH9Ps-TGnxKM92FFg-1
Received: by mail-wm1-f70.google.com with SMTP id t17so35559wmi.7
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2019 09:33:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/2b/vDqw+ozQRfXoTPtUPyy72TArTScgbED5dzJFnaE=;
        b=i75PDB7hDQoBDKlCGq1M9pdZOUJDkjfsbXilf2mUMcS2qgs4Hd/Rq1PThNdhxF/mFH
         X9e9zqZJBHGf07BsBNFg2sHjFgJthodZh84p8+MMNd49sosCCF8jBgZJMWQqq6BwXpSQ
         DLJ/wQ+YAJi+xeNxlki4xapG3KzyI4wyd4EiVGRXNB9KUm+RqJJgjmoPnBBdXkKkwbuN
         KVOwYvALlcuwbaS1JoNJ5qgdWZE2May+vvmbDO/+IqCXGb+FnHAHhE1VcmmvhLeNw8t5
         mxstfdTwq7koPQIiCPGU+Ft+gz/xQCW+kR/L+LkEgqsolPpKO3fFgrGyFQko2R5xN7CD
         jbmA==
X-Gm-Message-State: APjAAAW9/PkFvqGtdk1LEFig/IC9hOSwwX3N1UhMZUP+5G7Sl4+F3EQj
        9gHkelWd2l3OYoxCGiiyMVpPK81wBB+fZD6qyqRvBrQk4wl4t7qXIkioqFLqNBY4dORLhAUd6H6
        LO0CD+dg9ecKR
X-Received: by 2002:a1c:740b:: with SMTP id p11mr4887202wmc.78.1576690415165;
        Wed, 18 Dec 2019 09:33:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqy92N0AYB0AtyIwVEC/gFojCtUjdkCfiSAbx5G+Mq6ZebBFFgycCkame14FDWKtc1ZZsYDEHw==
X-Received: by 2002:a1c:740b:: with SMTP id p11mr4887175wmc.78.1576690414907;
        Wed, 18 Dec 2019 09:33:34 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:ac09:bce1:1c26:264c? ([2001:b07:6468:f312:ac09:bce1:1c26:264c])
        by smtp.gmail.com with ESMTPSA id v8sm3330146wrw.2.2019.12.18.09.33.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2019 09:33:34 -0800 (PST)
Subject: Re: [PATCH kvm-unit-tests] Update AMD instructions to conform to LLVM
 assembler
To:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, drjones@redhat.com
References: <20190220202442.145494-1-pshier@google.com>
 <CALMp9eRMbht+7xHXJV90MSs52LtjjdCtVeCdd_=5nqeSms8VxQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4ed8612a-1baf-fbd4-5248-45803562e1a6@redhat.com>
Date:   Wed, 18 Dec 2019 18:33:33 +0100
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

Applied.

Paolo

