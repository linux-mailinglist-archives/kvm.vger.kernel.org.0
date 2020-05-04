Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6E51C3FEB
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 18:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729577AbgEDQcC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 12:32:02 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22672 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728655AbgEDQcC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 12:32:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588609920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IyB269AFKOC157sfM//hC6JyvCfXoWoNiIwhZiVaINM=;
        b=ReED0/OPe7tGVYI0iIubbgzdv557Vk5laYfoZGVX4YuK4sOkjJwwPEEFEhA2O5xLc0GBEb
        UwzuKA4RSs76DtdaKo+pgA+iGdFc/aDPSZnNknPqM6Fye6pPQJ/Z0wxdgMDlKXTOXkoaTY
        r3VwRCt2S7bz+s/XD26NmT+oHtX6hyk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-R_hB2s1COwSBiOsl6hOUUQ-1; Mon, 04 May 2020 12:31:59 -0400
X-MC-Unique: R_hB2s1COwSBiOsl6hOUUQ-1
Received: by mail-wr1-f72.google.com with SMTP id e5so11027031wrs.23
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 09:31:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IyB269AFKOC157sfM//hC6JyvCfXoWoNiIwhZiVaINM=;
        b=nJBHLo5N5oHfNEn1WOtRQFzAtqzuRChKj9mG3SBG647UTFaJCVb40u6Nwgx8Nb2dni
         d+aNG/r8vP0MwAESR6drCZj6lRHkW0oO5L42vCBjdQL5FOKi2qNye6FPGdeBXoELqWNx
         vNkngs/jDmCEKYCa8uRmT3A4imVtEMMxeL+gq46ayQJilGdg3gqToX3oKgzKgkmPy2Zg
         toAdAi6xATmpQmTshQBnVJv5v8UIKvI18dnzCuTVc3w+Cul/Raky0yZ1ilEvLClQop0e
         73LXtnenRO/0qTAXSNvTiwCbwx5G89IVKGjd0QLW8dKiLHZjz1ZGdYmhNkXOxMzpvCr2
         cRpw==
X-Gm-Message-State: AGi0PuY8OvH4eYwx+xLKZ1QHuP/X3hMMUmcyBFWGaxJsQw7lT9Kh0VN3
        nYyBpyUoRY+q4aWLCAQ7TJu6XPVwWYQTltocaKtUpumtqGcW2rX3OoZxwX4lqkUap2oI7fybpC8
        5hY5f77rA/f+G
X-Received: by 2002:adf:f041:: with SMTP id t1mr126253wro.346.1588609917648;
        Mon, 04 May 2020 09:31:57 -0700 (PDT)
X-Google-Smtp-Source: APiQypIljPCI6hKiLiZGCDmI3dbBzFUE7Mbf/4Rf+dtHDl8lZ1cM0scqk2VQvKw/T7tOEUd5BJx0WA==
X-Received: by 2002:adf:f041:: with SMTP id t1mr126236wro.346.1588609917401;
        Mon, 04 May 2020 09:31:57 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id d5sm19653025wrp.44.2020.05.04.09.31.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 09:31:56 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v3] x86: nVMX: add new test for
 vmread/vmwrite flags preservation
To:     Simon Smith <brigidsmith@google.com>, kvm@vger.kernel.org
References: <20200420175834.258122-1-brigidsmith@google.com>
 <CAHfZhxt1c6PBM+VLFuhDnkUPcCwJCs17xL4bngzfq9YyJNDpJA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6c7a19a9-0030-9c32-33f9-9de86cb89bb2@redhat.com>
Date:   Mon, 4 May 2020 18:31:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAHfZhxt1c6PBM+VLFuhDnkUPcCwJCs17xL4bngzfq9YyJNDpJA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/05/20 18:19, Simon Smith wrote:
> Ping!  (I realized I sent this via non-plaintext and the listserv rejected it.)

Queued now, thanks!

Paolo

> 
> On Mon, Apr 20, 2020 at 10:59 AM Simon Smith <brigidsmith@google.com> wrote:
>>
>> This commit adds new unit tests for commit a4d956b93904 ("KVM: nVMX:
>> vmread should not set rflags to specify success in case of #PF")
>>
>> The two new tests force a vmread and a vmwrite on an unmapped
>> address to cause a #PF and verify that the low byte of %rflags is
>> preserved and that %rip is not advanced.  The commit fixed a
>> bug in vmread, but we include a test for vmwrite as well for
>> completeness.
>>
>> Before the aforementioned commit, the ALU flags would be incorrectly
>> cleared and %rip would be advanced (for vmread).
>>
>> Signed-off-by: Simon Smith <brigidsmith@google.com>
>> Reviewed-by: Jim Mattson <jmattson@google.com>
>> Reviewed-by: Peter Shier <pshier@google.com>
>> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> Reviewed-by: Oliver Upton <oupton@google.com>
>> ---
>>  x86/vmx.c | 140 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 140 insertions(+)
>>
>> diff --git a/x86/vmx.c b/x86/vmx.c
>> index 4c47eec1a1597..cbe68761894d4 100644
>> --- a/x86/vmx.c
>> +++ b/x86/vmx.c
>> @@ -32,6 +32,7 @@
>>  #include "processor.h"
>>  #include "alloc_page.h"
>>  #include "vm.h"
>> +#include "vmalloc.h"
>>  #include "desc.h"
>>  #include "vmx.h"
>>  #include "msr.h"
>> @@ -387,6 +388,141 @@ static void test_vmwrite_vmread(void)
>>         free_page(vmcs);
>>  }
>>
>> +ulong finish_fault;
>> +u8 sentinel;
>> +bool handler_called;
>> +
>> +static void pf_handler(struct ex_regs *regs)
>> +{
>> +       /*
>> +        * check that RIP was not improperly advanced and that the
>> +        * flags value was preserved.
>> +        */
>> +       report(regs->rip < finish_fault, "RIP has not been advanced!");
>> +       report(((u8)regs->rflags == ((sentinel | 2) & 0xd7)),
>> +              "The low byte of RFLAGS was preserved!");
>> +       regs->rip = finish_fault;
>> +       handler_called = true;
>> +
>> +}
>> +
>> +static void prep_flags_test_env(void **vpage, struct vmcs **vmcs, handler *old)
>> +{
>> +       /*
>> +        * get an unbacked address that will cause a #PF
>> +        */
>> +       *vpage = alloc_vpage();
>> +
>> +       /*
>> +        * set up VMCS so we have something to read from
>> +        */
>> +       *vmcs = alloc_page();
>> +
>> +       memset(*vmcs, 0, PAGE_SIZE);
>> +       (*vmcs)->hdr.revision_id = basic.revision;
>> +       assert(!vmcs_clear(*vmcs));
>> +       assert(!make_vmcs_current(*vmcs));
>> +
>> +       *old = handle_exception(PF_VECTOR, &pf_handler);
>> +}
>> +
>> +static void test_read_sentinel(void)
>> +{
>> +       void *vpage;
>> +       struct vmcs *vmcs;
>> +       handler old;
>> +
>> +       prep_flags_test_env(&vpage, &vmcs, &old);
>> +
>> +       /*
>> +        * set the proper label
>> +        */
>> +       extern char finish_read_fault;
>> +
>> +       finish_fault = (ulong)&finish_read_fault;
>> +
>> +       /*
>> +        * execute the vmread instruction that will cause a #PF
>> +        */
>> +       handler_called = false;
>> +       asm volatile ("movb %[byte], %%ah\n\t"
>> +                     "sahf\n\t"
>> +                     "vmread %[enc], %[val]; finish_read_fault:"
>> +                     : [val] "=m" (*(u64 *)vpage)
>> +                     : [byte] "Krm" (sentinel),
>> +                     [enc] "r" ((u64)GUEST_SEL_SS)
>> +                     : "cc", "ah");
>> +       report(handler_called, "The #PF handler was invoked");
>> +
>> +       /*
>> +        * restore the old #PF handler
>> +        */
>> +       handle_exception(PF_VECTOR, old);
>> +}
>> +
>> +static void test_vmread_flags_touch(void)
>> +{
>> +       /*
>> +        * set up the sentinel value in the flags register. we
>> +        * choose these two values because they candy-stripe
>> +        * the 5 flags that sahf sets.
>> +        */
>> +       sentinel = 0x91;
>> +       test_read_sentinel();
>> +
>> +       sentinel = 0x45;
>> +       test_read_sentinel();
>> +}
>> +
>> +static void test_write_sentinel(void)
>> +{
>> +       void *vpage;
>> +       struct vmcs *vmcs;
>> +       handler old;
>> +
>> +       prep_flags_test_env(&vpage, &vmcs, &old);
>> +
>> +       /*
>> +        * set the proper label
>> +        */
>> +       extern char finish_write_fault;
>> +
>> +       finish_fault = (ulong)&finish_write_fault;
>> +
>> +       /*
>> +        * execute the vmwrite instruction that will cause a #PF
>> +        */
>> +       handler_called = false;
>> +       asm volatile ("movb %[byte], %%ah\n\t"
>> +                     "sahf\n\t"
>> +                     "vmwrite %[val], %[enc]; finish_write_fault:"
>> +                     : [val] "=m" (*(u64 *)vpage)
>> +                     : [byte] "Krm" (sentinel),
>> +                     [enc] "r" ((u64)GUEST_SEL_SS)
>> +                     : "cc", "ah");
>> +       report(handler_called, "The #PF handler was invoked");
>> +
>> +       /*
>> +        * restore the old #PF handler
>> +        */
>> +       handle_exception(PF_VECTOR, old);
>> +}
>> +
>> +static void test_vmwrite_flags_touch(void)
>> +{
>> +       /*
>> +        * set up the sentinel value in the flags register. we
>> +        * choose these two values because they candy-stripe
>> +        * the 5 flags that sahf sets.
>> +        */
>> +       sentinel = 0x91;
>> +       test_write_sentinel();
>> +
>> +       sentinel = 0x45;
>> +       test_write_sentinel();
>> +}
>> +
>> +
>>  static void test_vmcs_high(void)
>>  {
>>         struct vmcs *vmcs = alloc_page();
>> @@ -1988,6 +2124,10 @@ int main(int argc, const char *argv[])
>>                 test_vmcs_lifecycle();
>>         if (test_wanted("test_vmx_caps", argv, argc))
>>                 test_vmx_caps();
>> +       if (test_wanted("test_vmread_flags_touch", argv, argc))
>> +               test_vmread_flags_touch();
>> +       if (test_wanted("test_vmwrite_flags_touch", argv, argc))
>> +               test_vmwrite_flags_touch();
>>
>>         /* Balance vmxon from test_vmxon. */
>>         vmx_off();
>> --
>> 2.26.1.301.g55bc3eb7cb9-goog
>>
> 

