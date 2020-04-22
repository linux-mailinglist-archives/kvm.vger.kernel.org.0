Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6964A1B4A6D
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 18:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgDVQ1b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 12:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbgDVQ1b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 12:27:31 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C6CC03C1A9
        for <kvm@vger.kernel.org>; Wed, 22 Apr 2020 09:27:30 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id f82so2497379ilh.8
        for <kvm@vger.kernel.org>; Wed, 22 Apr 2020 09:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EzGrC2vqQKE/rawUH7ijZjXr0pr1f68SrkRjObtRtqg=;
        b=tG7wYLsQGs8Z2l1BnwH5IR8n3D4aMmnVP7NqqD+vquciI60pduXyN9JAopBP6sZwWA
         ymv0DSklsI5JNi9lqSUcGc/nCCmCICfncRhoZREf7Eqfp3IMo1zqV3ZiwTsO/zS0PDfz
         qF6vtEjV3Bn6oLg3i8JT4ItFFCq1GeTC7C3T+CdeZTFCTZjG6NZfV7SEbCHegrhHfaR/
         fHq71+dZQ9vriMzp6jvvJ/GC9uXwykTM+lwIebrcAmv+6lNxU8RONOJ6RmSAHA+gDGL2
         auygphG3s72ABcDcl0EWhemQp3/iDeJqT39qOlqr0P8il0/XybGYMpXCn/f+W6q+q/go
         vd1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EzGrC2vqQKE/rawUH7ijZjXr0pr1f68SrkRjObtRtqg=;
        b=uXg0xnCV8x+tvJ2VmbQNEIHDQ3nCTQdF8Y77ula4gBX1ajiHMLCjbNcOJ6MA4S8LVu
         nXkw7f3GUz63CsrpidKN9rZc2KH0DOZeE7GLhIYCOlfHg2O182TGL4GiUQs4j2Pwguzx
         uGbGq0hnPraRrxojKhuUFcxQLJ3Yz9KUzwa1f0NChIhvmbfUmrM8JdiBAfObDCpFskpA
         YEp0/RZDxN+b7x49C2YcRAKx0SSylgD6qtoW1b1Vh7pS4JKsyirD5vxC3IJkXS9PSIxW
         0rE/q3xhAl9GEoovcrtCHpB/vv7grDaEy2K7nd1A3LI1vZLeomeG91Zpv8+aaXoB1lfS
         T6Lg==
X-Gm-Message-State: AGi0PuZtvUpM8QGtBs1eWtKAU5g5HZZEkLS5bYmv1KQb5LiIluJxsTId
        XlcT+O/BNXGIrHx8GFBjSntDuJEY2JdlS2kulRMHBf2h
X-Google-Smtp-Source: APiQypJom6O7KoVdZVKCaU79S3Fy9koGIMb0Zo6d9r1mMSdgG4bmhmSauBJPfBxKzehhq6P7rptYs8rW62alklrRWuE=
X-Received: by 2002:a92:da4e:: with SMTP id p14mr26539574ilq.296.1587572849555;
 Wed, 22 Apr 2020 09:27:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200414001026.50051-1-jmattson@google.com> <20200414001026.50051-2-jmattson@google.com>
In-Reply-To: <20200414001026.50051-2-jmattson@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 22 Apr 2020 09:27:18 -0700
Message-ID: <CALMp9eQskG_tyCZ6bxxZMB2Rm9_9MRyYdpzdfTiBngjuddcSTQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 2/2] x86: VMX: Add another corner-case
 VMX-preemption timer test
To:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Oliver Upton <oupton@google.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 13, 2020 at 5:10 PM Jim Mattson <jmattson@google.com> wrote:
>
> Ensure that the delivery of a "VMX-preemption timer expired" VM-exit
> doesn't disrupt single-stepping in the guest. Note that passing this
> test doesn't ensure correctness.
>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Oliver Upton <oupton@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---
>  x86/vmx_tests.c | 104 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 104 insertions(+)
>
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index fccb27f..86b8880 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -8438,6 +8438,109 @@ static void vmx_preemption_timer_zero_test(void)
>         handle_exception(DB_VECTOR, old_db);
>  }
>
> +static u64 vmx_preemption_timer_tf_test_prev_rip;
> +
> +static void vmx_preemption_timer_tf_test_db_handler(struct ex_regs *regs)
> +{
> +       extern char vmx_preemption_timer_tf_test_endloop;
> +
> +       if (vmx_get_test_stage() == 2) {
> +               /*
> +                * Stage 2 means that we're done, one way or another.
> +                * Arrange for the iret to drop us out of the wbinvd
> +                * loop and stop single-stepping.
> +                */
> +               regs->rip = (u64)&vmx_preemption_timer_tf_test_endloop;
> +               regs->rflags &= ~X86_EFLAGS_TF;
> +       } else if (regs->rip == vmx_preemption_timer_tf_test_prev_rip) {
> +               /*
> +                * The RIP should alternate between the wbinvd and the
> +                * jmp instruction in the code below. If we ever see
> +                * the same instruction twice in a row, that means a
> +                * single-step trap has been dropped. Let the
> +                * hypervisor know about the failure by executing a
> +                * VMCALL.
> +                */
> +               vmcall();
> +       }
> +       vmx_preemption_timer_tf_test_prev_rip = regs->rip;
> +}
> +
> +static void vmx_preemption_timer_tf_test_guest(void)
> +{
> +       /*
> +        * The hypervisor doesn't intercept WBINVD, so the loop below
> +        * shouldn't be a problem--it's just two instructions
> +        * executing in VMX non-root mode. However, when the
> +        * hypervisor is running in a virtual environment, the parent
> +        * hypervisor might intercept WBINVD and emulate it. If the
> +        * parent hypervisor is broken, the single-step trap after the
> +        * WBINVD might be lost.
> +        */
> +       asm volatile("vmcall\n\t"
> +                    "0: wbinvd\n\t"
> +                    "1: jmp 0b\n\t"
> +                    "vmx_preemption_timer_tf_test_endloop:");
> +}
> +
> +/*
> + * Ensure that the delivery of a "VMX-preemption timer expired"
> + * VM-exit doesn't disrupt single-stepping in the guest. Note that
> + * passing this test doesn't ensure correctness, because the test will
> + * only fail if the VMX-preemtion timer fires at the right time (or
> + * the wrong time, as it were).
> + */
> +static void vmx_preemption_timer_tf_test(void)
> +{
> +       handler old_db;
> +       u32 reason;
> +       int i;
> +
> +       if (!(ctrl_pin_rev.clr & PIN_PREEMPT)) {
> +               report_skip("'Activate VMX-preemption timer' not supported");
> +               return;
> +       }
> +
> +       old_db = handle_exception(DB_VECTOR,
> +                                 vmx_preemption_timer_tf_test_db_handler);
> +
> +       test_set_guest(vmx_preemption_timer_tf_test_guest);
> +
> +       enter_guest();
> +       skip_exit_vmcall();
> +
> +       vmx_set_test_stage(1);
> +       vmcs_set_bits(PIN_CONTROLS, PIN_PREEMPT);
> +       vmcs_write(PREEMPT_TIMER_VALUE, 50000);
> +       vmcs_write(GUEST_RFLAGS, X86_EFLAGS_FIXED | X86_EFLAGS_TF);
> +
> +       /*
> +        * The only exit we should see is "VMX-preemption timer
> +        * expired."  If we get a VMCALL exit, that means the #DB
> +        * handler has detected a missing single-step trap. It doesn't
> +        * matter where the guest RIP is when the VMX-preemption timer
> +        * expires (whether it's in the WBINVD loop or in the #DB
> +        * handler)--a single-step trap should never be discarded.
> +        */
> +       for (i = 0; i < 10000; i++) {
> +               enter_guest();
> +               reason = (u32)vmcs_read(EXI_REASON);
> +               if (reason == VMX_PREEMPT)
> +                       continue;
> +               TEST_ASSERT(reason == VMX_VMCALL);
> +               skip_exit_insn();
> +               break;
> +       }
> +
> +       report(reason == VMX_PREEMPT, "No single-step traps skipped");
> +
> +       vmx_set_test_stage(2);
> +       vmcs_clear_bits(PIN_CONTROLS, PIN_PREEMPT);
> +       enter_guest();
> +
> +       handle_exception(DB_VECTOR, old_db);
> +}
> +
>  static void vmx_db_test_guest(void)
>  {
>         /*
> @@ -9743,6 +9846,7 @@ struct vmx_test vmx_tests[] = {
>         TEST(vmx_pending_event_hlt_test),
>         TEST(vmx_store_tsc_test),
>         TEST(vmx_preemption_timer_zero_test),
> +       TEST(vmx_preemption_timer_tf_test),
>         /* EPT access tests. */
>         TEST(ept_access_test_not_present),
>         TEST(ept_access_test_read_only),
> --
> 2.26.0.110.g2183baf09c-goog

Adding +Paolo Bonzini.
