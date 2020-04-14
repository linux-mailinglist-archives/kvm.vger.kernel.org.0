Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F5D1A8E95
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 00:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391976AbgDNW2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 18:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391879AbgDNW2I (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Apr 2020 18:28:08 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A5AC061A0C
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 15:28:07 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id h25so1534880lja.10
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 15:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9pMM2TbTy/6YHqjTiH7VA82H5qVv48xtAQ0Dcm+vBew=;
        b=N/2QG5YwOyqAyhGzk0z6bIlke1ibMA2lW4NyaAJu2MqXkIn9WjqmXPaN8TMhnl6VaY
         rPZZbcY1M6M3pyT2e7dzDs/XwTIoFfLj7HXLOaFVKr/+teWwarUNtYil1Y45V0n6jcPu
         11YJT2T688hCRsYlZ8hYDStwG9sV6/R1NEo95M4ojVqM0lzlBsGCCga/opdzgl+Urq1v
         k4u931fmQDQNLfZkcq2tAHcbIPGh4XbEPUV3tSE3ZwPOTRtyzBLPQOO40pWkjQXE/1eZ
         o7hHbQrkZUSJG+muH4v1o0nXPo841jMHV8qEnZltwExQyaYljTM7mf6sAfNi2Ezs0wlA
         lfhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9pMM2TbTy/6YHqjTiH7VA82H5qVv48xtAQ0Dcm+vBew=;
        b=FtTwoeSn0OJXQtuWkxSuC5EDLM+vIFLrZpy5briN/YqJQzZs21c8eCacmgSJD++45k
         0ky0L1h60qaG5b6x8MW0w6dToLKQjjKQL7um4Ag38ztUrKJl1UE+PNgIqGi7ssJ2RUfz
         HGuUx7FkTo6Dq6xvcvazIXrvQluNj9uhcz0pFz1yO9A3I7DtX+wD1vym+WHC7/mS6O9K
         t4rmGKCDeLP7IOGHj9NsoBRw17GNFdqtv9zT8rhQKUeFR9DR0LxqYihlCJfokhtOTlvx
         zPhljeQji0FFjJ/Azpo7CxmB6l59Xzf/qJ/VhZBCAmfjCLL5do8UuI5gt6hjQrSStPs3
         0tEw==
X-Gm-Message-State: AGi0PuZ6Ao1f2gR/uwLZl0urvZJmMPrE2ydE7p94GYjv3EhVPX/YsqsU
        brGfvLrbkZswKzOaoyGHub1/IuImviodYSyuqe1eXNwn
X-Google-Smtp-Source: APiQypJCubF8/leX62R2U+wcr7J3T8s/16Xi00/FhRjU5bYTx6b1N6o1qXkDzL8cCX+F+Skxknhubfld3PrHtvnGrwc=
X-Received: by 2002:a2e:b53b:: with SMTP id z27mr1346869ljm.109.1586903285570;
 Tue, 14 Apr 2020 15:28:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200414175959.184053-1-brigidsmith@google.com>
In-Reply-To: <20200414175959.184053-1-brigidsmith@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 14 Apr 2020 17:27:54 -0500
Message-ID: <CAOQ_QsgqPXQ+siP9sD==LpYG59NSUAZ326jrbbDqBkdA8Ghh7Q@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: nVMX: add new test for vmread/vmwrite
 flags preservation
To:     Simon Smith <brigidsmith@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Simon,

On Tue, Apr 14, 2020 at 1:03 PM Simon Smith <brigidsmith@google.com> wrote:
>
> This commit adds new unit tests for commit a4d956b93904 ("KVM: nVMX:
> vmread should not set rflags to specify success in case of #PF")
>
> The two new tests force a vmread and a vmwrite on an unmapped
> address to cause a #PF and verify that the low byte of %rflags is
> preserved and that %rip is not advanced.  The commit fixed a
> bug in vmread, but we include a test for vmwrite as well for
> completeness.
>
> Before the aforementioned commit, the ALU flags would be incorrectly
> cleared and %rip would be advanced (for vmread).
>
> v1: https://www.spinics.net/lists/kvm/msg212817.html
>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Simon Smith <brigidsmith@google.com>
> ---
>  x86/vmx.c | 121 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 121 insertions(+)
>
> diff --git a/x86/vmx.c b/x86/vmx.c
> index 647ab49408876..e9235ec4fcad9 100644
> --- a/x86/vmx.c
> +++ b/x86/vmx.c
> @@ -32,6 +32,7 @@
>  #include "processor.h"
>  #include "alloc_page.h"
>  #include "vm.h"
> +#include "vmalloc.h"
>  #include "desc.h"
>  #include "vmx.h"
>  #include "msr.h"
> @@ -368,6 +369,122 @@ static void test_vmwrite_vmread(void)
>         free_page(vmcs);
>  }
>
> +ulong finish_fault;
> +u8 sentinel;
> +bool handler_called;

nit: newline here

> +static void pf_handler(struct ex_regs *regs)
> +{
> +       // check that RIP was not improperly advanced and that the
> +       // flags value was preserved.

Throughout the patch, could you use C/kernel style comments?

/*
 * check that RIP was not improperly advanced and that the
 * flags value was perserved.
 */

This should also be used for single line comments.

> +       report("RIP has not been advanced!",
> +               regs->rip < finish_fault);
> +       report("The low byte of RFLAGS was preserved!",
> +               ((u8)regs->rflags == ((sentinel | 2) & 0xd7)));

This doesn't compile. The signature of report is:

  extern void report(bool pass, const char *msg_fmt, ...)

However, this is completely understandable, as report(...) used to be
parameterized the way you have it :)

> +
> +       regs->rip = finish_fault;
> +       handler_called = true;
> +
> +}
> +
> +static void prep_flags_test_env(void **vpage, struct vmcs **vmcs, handler *old)
> +{
> +       // get an unbacked address that will cause a #PF
> +       *vpage = alloc_vpage();
> +
> +       // set up VMCS so we have something to read from
> +       *vmcs = alloc_page();
> +
> +       memset(*vmcs, 0, PAGE_SIZE);
> +       (*vmcs)->hdr.revision_id = basic.revision;
> +       assert(!vmcs_clear(*vmcs));
> +       assert(!make_vmcs_current(*vmcs));
> +
> +       *old = handle_exception(PF_VECTOR, &pf_handler);
> +}
> +
> +static void test_read_sentinel(void)
> +{
> +       void *vpage;
> +       struct vmcs *vmcs;
> +       handler old;
> +
> +       prep_flags_test_env(&vpage, &vmcs, &old);
> +
> +       // set the proper label
> +       extern char finish_read_fault;
> +
> +       finish_fault = (ulong)&finish_read_fault;
> +
> +       // execute the vmread instruction that will cause a #PF
> +       handler_called = false;
> +       asm volatile ("movb %[byte], %%ah\n\t"
> +                     "sahf\n\t"
> +                     "vmread %[enc], %[val]; finish_read_fault:"
> +                     : [val] "=m" (*(u64 *)vpage)
> +                     : [byte] "Krm" (sentinel),
> +                     [enc] "r" ((u64)GUEST_SEL_SS)
> +                     : "cc", "ah"
> +                     );
> +       report("The #PF handler was invoked", handler_called);

Same thing here, you'll need to reorder the parameters.

> +
> +       // restore old #PF handler
> +       handle_exception(PF_VECTOR, old);
> +}
> +
> +static void test_vmread_flags_touch(void)
> +{
> +       // set up the sentinel value in the flags register. we
> +       // choose these two values because they candy-stripe
> +       // the 5 flags that sahf sets.
> +       sentinel = 0x91;
> +       test_read_sentinel();
> +
> +       sentinel = 0x45;
> +       test_read_sentinel();
> +}
> +
> +static void test_write_sentinel(void)
> +{
> +       void *vpage;
> +       struct vmcs *vmcs;
> +       handler old;
> +
> +       prep_flags_test_env(&vpage, &vmcs, &old);
> +
> +       // set the proper label
> +       extern char finish_write_fault;
> +
> +       finish_fault = (ulong)&finish_write_fault;
> +
> +       // execute the vmwrite instruction that will cause a #PF
> +       handler_called = false;
> +       asm volatile ("movb %[byte], %%ah\n\t"
> +                     "sahf\n\t"
> +                     "vmwrite %[val], %[enc]; finish_write_fault:"
> +                     : [val] "=m" (*(u64 *)vpage)
> +                     : [byte] "Krm" (sentinel),
> +                     [enc] "r" ((u64)GUEST_SEL_SS)
> +                     : "cc", "ah"
> +                     );
> +       report("The #PF handler was invoked", handler_called);

report(...) issue also here

> +
> +       // restore old #PF handler
> +       handle_exception(PF_VECTOR, old);
> +}
> +
> +static void test_vmwrite_flags_touch(void)
> +{
> +       // set up the sentinel value in the flags register. we
> +       // choose these two values because they candy-stripe
> +       // the 5 flags that sahf sets.
> +       sentinel = 0x91;
> +       test_write_sentinel();
> +
> +       sentinel = 0x45;
> +       test_write_sentinel();
> +}
> +
> +
>  static void test_vmcs_high(void)
>  {
>         struct vmcs *vmcs = alloc_page();
> @@ -1994,6 +2111,10 @@ int main(int argc, const char *argv[])
>                 test_vmcs_lifecycle();
>         if (test_wanted("test_vmx_caps", argv, argc))
>                 test_vmx_caps();
> +       if (test_wanted("test_vmread_flags_touch", argv, argc))
> +               test_vmread_flags_touch();
> +       if (test_wanted("test_vmwrite_flags_touch", argv, argc))
> +               test_vmwrite_flags_touch();
>
>         /* Balance vmxon from test_vmxon. */
>         vmx_off();
> --
> 2.26.0.110.g2183baf09c-goog
>

--
Thanks,
Oliver
