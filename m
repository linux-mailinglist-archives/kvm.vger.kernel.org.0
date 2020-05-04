Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF4641C3FAA
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 18:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729525AbgEDQTW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 12:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729458AbgEDQTW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 12:19:22 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA83DC061A0E
        for <kvm@vger.kernel.org>; Mon,  4 May 2020 09:19:21 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id g13so21654741wrb.8
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 09:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=v/Y4Oto6fyFoTrmnVjYFN+h2pKjvcvAOtCO/f+zHOpo=;
        b=CupmiGscyk6hVNpVwbg/zBWfH3+qUdnTsLxAbC1y/tmblRRbkg89bDhRHxOaGPwf/6
         W5aj18og6gxZln5wvz5cm0DcHbfptxST/4vDT8u+bMwwp+NPehL4HxoNq4CzSKC9SB/g
         Lhxa41bD7YTgjPOiFSwFzlBKPkgvTHWn8E0LvrlzQ5f7LxmjMvjQP+ujDLxspF6LaJWN
         m77n8+/+4wlw4dpGLamlgJhecLoaBssaFYxz5jswF2hJftYrZsp08DMLRxO9nOM2uBhF
         jPRViAgyQf+IINj5L7OEf/TZaaTDFhk4A6t6eNfGk0IsnARMrDxyhmE59fpj+ADD7NTP
         ++oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=v/Y4Oto6fyFoTrmnVjYFN+h2pKjvcvAOtCO/f+zHOpo=;
        b=M07NT9koS5fJvO6Xq8ExlIPbRL/c6DJ1WDgk0GiuEoAbiBTG+3ZTFzqeFTDn6aFno3
         36/+norcmvgkOHu6iN9k0U8+Dbw5vHZTTJW4rDmIEZgx017AoE7wTRPbv41Q+RlFp7o8
         JP2Ry52q1DEWtV1F2A6X6eILurqge0xMzxUn6iMlF9WpTcaPkP2LHNej+ao1AHmWvRbL
         FHDSMxEWczmjKO9EcXylL5HY1gzZchldbMS3kwx7a40YFC5w1eNEsFUA3ygo7HToLy6T
         Be4Jpiwof5NeaTQbzFqFTRCNTt4gG+hRJxO0jjqgfwYBky4pDb312G82AXIQVoktmB06
         mYEQ==
X-Gm-Message-State: AGi0PubbO3XcA+bMYJipJLVdPLkxKsgOEIOw2e4QNfw78qFzVS9OmiKO
        YLHtFy3RZTWqMGt6TPAV3U9g3syd2W+pVtM9ha/EkjAs
X-Google-Smtp-Source: APiQypLsTncUF/WxaItljkOTs9nSY/Mv7gd4ozqRdaYO/4jvySPUEZ5sXjJN/QUB457dT9MgaxHCVlwuoB9WuRjRTns=
X-Received: by 2002:a5d:4d8f:: with SMTP id b15mr47888wru.107.1588609160025;
 Mon, 04 May 2020 09:19:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200420175834.258122-1-brigidsmith@google.com>
In-Reply-To: <20200420175834.258122-1-brigidsmith@google.com>
From:   Simon Smith <brigidsmith@google.com>
Date:   Mon, 4 May 2020 09:19:09 -0700
Message-ID: <CAHfZhxt1c6PBM+VLFuhDnkUPcCwJCs17xL4bngzfq9YyJNDpJA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3] x86: nVMX: add new test for
 vmread/vmwrite flags preservation
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping!  (I realized I sent this via non-plaintext and the listserv rejected it.)


On Mon, Apr 20, 2020 at 10:59 AM Simon Smith <brigidsmith@google.com> wrote:
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
> Signed-off-by: Simon Smith <brigidsmith@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Reviewed-by: Oliver Upton <oupton@google.com>
> ---
>  x86/vmx.c | 140 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 140 insertions(+)
>
> diff --git a/x86/vmx.c b/x86/vmx.c
> index 4c47eec1a1597..cbe68761894d4 100644
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
> @@ -387,6 +388,141 @@ static void test_vmwrite_vmread(void)
>         free_page(vmcs);
>  }
>
> +ulong finish_fault;
> +u8 sentinel;
> +bool handler_called;
> +
> +static void pf_handler(struct ex_regs *regs)
> +{
> +       /*
> +        * check that RIP was not improperly advanced and that the
> +        * flags value was preserved.
> +        */
> +       report(regs->rip < finish_fault, "RIP has not been advanced!");
> +       report(((u8)regs->rflags == ((sentinel | 2) & 0xd7)),
> +              "The low byte of RFLAGS was preserved!");
> +       regs->rip = finish_fault;
> +       handler_called = true;
> +
> +}
> +
> +static void prep_flags_test_env(void **vpage, struct vmcs **vmcs, handler *old)
> +{
> +       /*
> +        * get an unbacked address that will cause a #PF
> +        */
> +       *vpage = alloc_vpage();
> +
> +       /*
> +        * set up VMCS so we have something to read from
> +        */
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
> +       /*
> +        * set the proper label
> +        */
> +       extern char finish_read_fault;
> +
> +       finish_fault = (ulong)&finish_read_fault;
> +
> +       /*
> +        * execute the vmread instruction that will cause a #PF
> +        */
> +       handler_called = false;
> +       asm volatile ("movb %[byte], %%ah\n\t"
> +                     "sahf\n\t"
> +                     "vmread %[enc], %[val]; finish_read_fault:"
> +                     : [val] "=m" (*(u64 *)vpage)
> +                     : [byte] "Krm" (sentinel),
> +                     [enc] "r" ((u64)GUEST_SEL_SS)
> +                     : "cc", "ah");
> +       report(handler_called, "The #PF handler was invoked");
> +
> +       /*
> +        * restore the old #PF handler
> +        */
> +       handle_exception(PF_VECTOR, old);
> +}
> +
> +static void test_vmread_flags_touch(void)
> +{
> +       /*
> +        * set up the sentinel value in the flags register. we
> +        * choose these two values because they candy-stripe
> +        * the 5 flags that sahf sets.
> +        */
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
> +       /*
> +        * set the proper label
> +        */
> +       extern char finish_write_fault;
> +
> +       finish_fault = (ulong)&finish_write_fault;
> +
> +       /*
> +        * execute the vmwrite instruction that will cause a #PF
> +        */
> +       handler_called = false;
> +       asm volatile ("movb %[byte], %%ah\n\t"
> +                     "sahf\n\t"
> +                     "vmwrite %[val], %[enc]; finish_write_fault:"
> +                     : [val] "=m" (*(u64 *)vpage)
> +                     : [byte] "Krm" (sentinel),
> +                     [enc] "r" ((u64)GUEST_SEL_SS)
> +                     : "cc", "ah");
> +       report(handler_called, "The #PF handler was invoked");
> +
> +       /*
> +        * restore the old #PF handler
> +        */
> +       handle_exception(PF_VECTOR, old);
> +}
> +
> +static void test_vmwrite_flags_touch(void)
> +{
> +       /*
> +        * set up the sentinel value in the flags register. we
> +        * choose these two values because they candy-stripe
> +        * the 5 flags that sahf sets.
> +        */
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
> @@ -1988,6 +2124,10 @@ int main(int argc, const char *argv[])
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
> 2.26.1.301.g55bc3eb7cb9-goog
>
