Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305C0203DF0
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 19:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729857AbgFVRaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 13:30:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27664 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729605AbgFVRaO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 13:30:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592847012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xrap4FZDxKhug28DDSJ1NQrjmR6wvF/49si69So0LsM=;
        b=Kd/Sh1/E/K2QncwL1jfBnyocB0i5PZz3cb4j+nek9QzpeSMI0/w2o73WuogLw1WLK0xyrU
        tFjoLGV2ek6wt+nhr+N5sJUPbEdPzyeKdUTUfoORSrW2UoC0+XG938feIyaieOR9e8GuPp
        DdWKpibQCbUp5tbtPg7o7mp42aHF1CI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-dKCsThN5MWKAUCwLekIU6A-1; Mon, 22 Jun 2020 13:30:08 -0400
X-MC-Unique: dKCsThN5MWKAUCwLekIU6A-1
Received: by mail-wm1-f71.google.com with SMTP id c66so179266wma.8
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 10:30:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xrap4FZDxKhug28DDSJ1NQrjmR6wvF/49si69So0LsM=;
        b=KXnCbUVbhg9de8P0dFmC9fFMY5FpNzTxwmakKPfZv+P6uuQ7zuHyK24gBsmcgJ2lIe
         nbQoESva4jmoc+fJz1Wqt3BC0j5IWXpPcj/vXYHn+XgYNOab5BolBuRQj4KF8K06hklw
         zRcv9Vv0w+d5LbPKMiWLKQrAPLNffhMqobinB/Bp0KKlZva8szz+UP6dItjabHnpv5S2
         Z3AEbptlIfKI2DjJQiZ9SeuwJ7aB1QSz+rJKldz01LvIzXxUgc3skEmafbS25vd9M1uz
         NVh7p5XSd7OM4dnXwZE71/q235bJ4ScTaW9kI2VmGcY3ma6H395wRZIuAj9FfLCfheDy
         Ggvg==
X-Gm-Message-State: AOAM533Db490L4QsAQnLYxg4LszqLy9gZJdHgPPATovjmaIfvChIklN8
        D+kHR1xVqOAKNEz93FYFiThEiKqQXZwF+I7VJUqU7+gTay5xm5e47LyAOpdCcMCBONOgRE3oLwI
        dCDBlHGOua72t
X-Received: by 2002:adf:dfcd:: with SMTP id q13mr7063198wrn.295.1592847007243;
        Mon, 22 Jun 2020 10:30:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyTwup3IEUtBW1q22cYYY4gZzaRZ+puwYQ0AAHM3FhzYsDClMFjLM0dOLdgDOLMJKO4ERtfGg==
X-Received: by 2002:adf:dfcd:: with SMTP id q13mr7063175wrn.295.1592847006951;
        Mon, 22 Jun 2020 10:30:06 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id v24sm21567401wrd.92.2020.06.22.10.30.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 10:30:06 -0700 (PDT)
Subject: Re: [PATCH] SVM: add test for nested guest RIP corruption
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20200622165533.145882-1-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fc46c0a2-7a05-797e-3909-36b47ae302e0@redhat.com>
Date:   Mon, 22 Jun 2020 19:30:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200622165533.145882-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/20 18:55, Maxim Levitsky wrote:
> +/*
> + * Detect nested guest RIP corruption as explained in kernel commit
> + * b6162e82aef19fee9c32cb3fe9ac30d9116a8c73
> + *
> + * In the assembly loop below, execute 'ins' from a IO port,
> + * while not intercepting IO violations, so that this instruction is
> + * intercepted and emulated by the L0 qemu.
> + *
> + * At the same time we are getting interrupts from the local APIC timer,
> + * and we do intercept them in L1
> + *
> + * If interrupt happens on the insb instruction, L0 will VMexit, emulate
> + * the insb instruction and then it will try to inject the interrupt to L1
> + * by doing a nested VMexit (since L1 intercepts interrupts),
> + * and due to a bug it will use pre-emulation value of RIP,RAX and RSP.
> + *
> + * In our intercept handler we check that RIP is of the insb instruction,
> + * (corrupted) but its memory operand is already written meaning,
> + * that insb was already executed.
> + */

Looks good, just some wording improvements

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 30009c4..827ff87 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1793,21 +1793,20 @@ static bool virq_inject_check(struct svm_test *test)
  * Detect nested guest RIP corruption as explained in kernel commit
  * b6162e82aef19fee9c32cb3fe9ac30d9116a8c73
  *
- * In the assembly loop below, execute 'ins' from a IO port,
- * while not intercepting IO violations, so that this instruction is
- * intercepted and emulated by the L0 qemu.
+ * In the assembly loop below 'ins' is executed while IO instructions
+ * are not intercepted; the instruction is emulated by L0.
  *
  * At the same time we are getting interrupts from the local APIC timer,
  * and we do intercept them in L1
  *
- * If interrupt happens on the insb instruction, L0 will VMexit, emulate
- * the insb instruction and then it will try to inject the interrupt to L1
- * by doing a nested VMexit (since L1 intercepts interrupts),
- * and due to a bug it will use pre-emulation value of RIP,RAX and RSP.
+ * If the interrupt happens on the insb instruction, L0 will VMexit, emulate
+ * the insb instruction and then it will inject the interrupt to L1 through
+ * a nested VMexit.  Due to a bug, it would leave pre-emulation values of RIP,
+ * RAX and RSP in the VMCB.
  *
- * In our intercept handler we check that RIP is of the insb instruction,
- * (corrupted) but its memory operand is already written meaning,
- * that insb was already executed.
+ * In our intercept handler we detect the bug by checking that RIP is that of
+ * the insb instruction, but its memory operand has already been written.
+ * This means that insb was already executed.
  */
 
> +static void reg_corruption_test(struct svm_test *test)
> +{
> +    /* this is endless loop, which is interrupted by the timer interrupt */
> +    asm volatile (
> +            "again:\n\t"
> +            "movw $0x4d0, %%dx\n\t" // IO port
> +            "lea %[_io_port_var], %%rdi\n\t"
> +            "movb $0xAA, %[_io_port_var]\n\t"
> +            "insb_instruction_label:\n\t"
> +            "insb\n\t"
> +            "jmp again\n\t"

And here you could use "1:" and "jmp 1b" instead of a global label.

You said offlist that an "inb" instruction would not work, but I'm not sure
I understand why.  Wouldn't you see "0xAA" in vmcb->save.rax with the fixed
kernel, and something else with the broken one?

Paolo

> +
> +            : [_io_port_var] "=m" (io_port_var)
> +            : /* no inputs*/
> +            : "rdx", "rdi"
> +    );
> +}
> +
> +static bool reg_corruption_finished(struct svm_test *test)
> +{
> +    if (isr_cnt == 10000) {
> +        report(true,
> +               "No RIP corruption detected after %d timer interrupts",
> +               isr_cnt);
> +        set_test_stage(test, 1);
> +        return true;
> +    }
> +
> +    if (vmcb->control.exit_code == SVM_EXIT_INTR) {
> +
> +        void* guest_rip = (void*)vmcb->save.rip;
> +
> +        irq_enable();
> +        asm volatile ("nop");
> +        irq_disable();
> +
> +        if (guest_rip == insb_instruction_label && io_port_var != 0xAA) {
> +            report(false,
> +                   "RIP corruption detected after %d timer interrupts",
> +                   isr_cnt);
> +            return true;
> +        }
> +
> +    }
> +    return false;
> +}
> +
> +static bool reg_corruption_check(struct svm_test *test)
> +{
> +    return get_test_stage(test) == 1;
> +}
> +
>  #define TEST(name) { #name, .v2 = name }
>  
>  /*
> @@ -1950,6 +2050,9 @@ struct svm_test svm_tests[] = {
>      { "virq_inject", default_supported, virq_inject_prepare,
>        default_prepare_gif_clear, virq_inject_test,
>        virq_inject_finished, virq_inject_check },
> +    { "reg_corruption", default_supported, reg_corruption_prepare,
> +      default_prepare_gif_clear, reg_corruption_test,
> +      reg_corruption_finished, reg_corruption_check },
>      TEST(svm_guest_state_test),
>      { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
>  };
> 

