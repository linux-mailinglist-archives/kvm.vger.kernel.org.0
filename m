Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3821B4A6B
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 18:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgDVQ1A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 12:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbgDVQ1A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 12:27:00 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE78AC03C1A9
        for <kvm@vger.kernel.org>; Wed, 22 Apr 2020 09:26:59 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id i19so2999257ioh.12
        for <kvm@vger.kernel.org>; Wed, 22 Apr 2020 09:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ARQeSk2+NORP6v4NT1HcDlot2QPQtDdHOOTogk7Q3E0=;
        b=cI85keEiMYi2LL7zilZvX6AhS0AsCUeagqEOWsGnf5I/x3mv073zADCTxxdWgaCCT+
         xK+T2kBOlzvMeEaUkSaPXnTcX8KKYKnhHHt7IaOwDe3qW6qXD8VC+yUO0/Dmsu3whkoc
         q7GVekBPn9dm9TX1l3WGdCI914T31blhtI4uHH9G/0PhIb75gxK7+QgDFqJQzprQzKuh
         P23mLtaJ0l0X/a2xgOBzQ/KsMmTYyfsfSA6NvUwIuv+ezjL04CzZ5nXslB/LAK+FW0gN
         WRDuSOdZnSGlwopzJE/gV34RQHeV9RWKSUgyDZ0GARbRhHvhHRwZdv/1T5RAXFmsQvsh
         EUPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ARQeSk2+NORP6v4NT1HcDlot2QPQtDdHOOTogk7Q3E0=;
        b=II6Fe/f5uIgs5o+n41a/uv7tkOAQjO4SfMSBbYgX38IO+sHxC3ckTZPNuil+TbBnXi
         kbFYwKwpQCObt2pHAoabyjW4piVRejGDO2R02FZ8No5M3rhtLm3HT4zt5Ka0SAkZ1T4O
         exGntYQWxEfmhHDHTbxAqBFoXLgmPjohfRC4wrecNVh8ex6C79/dln4EDkogndzCQGRU
         UQLRVX0XO4hnbVHbYGMki24EKLIecTTxHJzIMqh1T/1h7dhPPiPX2SxCrYI23E6J8aif
         Lj1bkwgl9NNCpMLbQ+U/b/QW/Sh263Eklo/2ISFy+eQUjtdHgIULQNW3gY2GHE58vSTS
         tIzg==
X-Gm-Message-State: AGi0Pub5Rhp0P4G2xXz+WQg0TY6iIMrqwkz2U7QvvnMPGXmJa+yN23nN
        0rVrBAH94uH0GVpkxPmeCpGux1l//s6K5P1xXH2QPMCR
X-Google-Smtp-Source: APiQypLF74uHPnyey6wmqKmG62Jt2qNFVeJ87R1PSBrn4kwivL/D0pZuk4k+ObU1M5tuWcS/Xp0XWFA2hcmODlcpo84=
X-Received: by 2002:a6b:c910:: with SMTP id z16mr26262209iof.164.1587572818530;
 Wed, 22 Apr 2020 09:26:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200414001026.50051-1-jmattson@google.com>
In-Reply-To: <20200414001026.50051-1-jmattson@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 22 Apr 2020 09:26:47 -0700
Message-ID: <CALMp9eRnLxG=Je3SDcz6HOgB0AJbC-qACySiSVrxP9qT6A54Rw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 1/2] x86: nVMX: Add some corner-case
 VMX-preemption timer tests
To:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Oliver Upton <oupton@google.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 13, 2020 at 5:10 PM Jim Mattson <jmattson@google.com> wrote:
>
> Verify that both injected events and debug traps that result from
> pending debug exceptions take precedence over a "VMX-preemption timer
> expired" VM-exit resulting from a zero-valued VMX-preemption timer.
>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Oliver Upton <oupton@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---
>  x86/vmx_tests.c | 120 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 120 insertions(+)
>
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 1f97fe3..fccb27f 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -8319,6 +8319,125 @@ static void vmx_store_tsc_test(void)
>                msr_entry.value, low, high);
>  }
>
> +static void vmx_preemption_timer_zero_test_db_handler(struct ex_regs *regs)
> +{
> +}
> +
> +static void vmx_preemption_timer_zero_test_guest(void)
> +{
> +       while (vmx_get_test_stage() < 3)
> +               vmcall();
> +}
> +
> +static void vmx_preemption_timer_zero_activate_preemption_timer(void)
> +{
> +       vmcs_set_bits(PIN_CONTROLS, PIN_PREEMPT);
> +       vmcs_write(PREEMPT_TIMER_VALUE, 0);
> +}
> +
> +static void vmx_preemption_timer_zero_advance_past_vmcall(void)
> +{
> +       vmcs_clear_bits(PIN_CONTROLS, PIN_PREEMPT);
> +       enter_guest();
> +       skip_exit_vmcall();
> +}
> +
> +static void vmx_preemption_timer_zero_inject_db(bool intercept_db)
> +{
> +       vmx_preemption_timer_zero_activate_preemption_timer();
> +       vmcs_write(ENT_INTR_INFO, INTR_INFO_VALID_MASK |
> +                  INTR_TYPE_HARD_EXCEPTION | DB_VECTOR);
> +       vmcs_write(EXC_BITMAP, intercept_db ? 1 << DB_VECTOR : 0);
> +       enter_guest();
> +}
> +
> +static void vmx_preemption_timer_zero_set_pending_dbg(u32 exception_bitmap)
> +{
> +       vmx_preemption_timer_zero_activate_preemption_timer();
> +       vmcs_write(GUEST_PENDING_DEBUG, BIT(12) | DR_TRAP1);
> +       vmcs_write(EXC_BITMAP, exception_bitmap);
> +       enter_guest();
> +}
> +
> +static void vmx_preemption_timer_zero_expect_preempt_at_rip(u64 expected_rip)
> +{
> +       u32 reason = (u32)vmcs_read(EXI_REASON);
> +       u64 guest_rip = vmcs_read(GUEST_RIP);
> +
> +       report(reason == VMX_PREEMPT && guest_rip == expected_rip,
> +              "Exit reason is 0x%x (expected 0x%x) and guest RIP is %lx (0x%lx expected).",
> +              reason, VMX_PREEMPT, guest_rip, expected_rip);
> +}
> +
> +/*
> + * This test ensures that when the VMX preemption timer is zero at
> + * VM-entry, a VM-exit occurs after any event injection and after any
> + * pending debug exceptions are raised, but before execution of any
> + * guest instructions.
> + */
> +static void vmx_preemption_timer_zero_test(void)
> +{
> +       u64 db_fault_address = (u64)get_idt_addr(&boot_idt[DB_VECTOR]);
> +       handler old_db;
> +       u32 reason;
> +
> +       if (!(ctrl_pin_rev.clr & PIN_PREEMPT)) {
> +               report_skip("'Activate VMX-preemption timer' not supported");
> +               return;
> +       }
> +
> +       /*
> +        * Install a custom #DB handler that doesn't abort.
> +        */
> +       old_db = handle_exception(DB_VECTOR,
> +                                 vmx_preemption_timer_zero_test_db_handler);
> +
> +       test_set_guest(vmx_preemption_timer_zero_test_guest);
> +
> +       /*
> +        * VMX-preemption timer should fire after event injection.
> +        */
> +       vmx_set_test_stage(0);
> +       vmx_preemption_timer_zero_inject_db(0);
> +       vmx_preemption_timer_zero_expect_preempt_at_rip(db_fault_address);
> +       vmx_preemption_timer_zero_advance_past_vmcall();
> +
> +       /*
> +        * VMX-preemption timer should fire after event injection.
> +        * Exception bitmap is irrelevant, since you can't intercept
> +        * an event that you injected.
> +        */
> +       vmx_set_test_stage(1);
> +       vmx_preemption_timer_zero_inject_db(1 << DB_VECTOR);
> +       vmx_preemption_timer_zero_expect_preempt_at_rip(db_fault_address);
> +       vmx_preemption_timer_zero_advance_past_vmcall();
> +
> +       /*
> +        * VMX-preemption timer should fire after pending debug exceptions
> +        * have delivered a #DB trap.
> +        */
> +       vmx_set_test_stage(2);
> +       vmx_preemption_timer_zero_set_pending_dbg(0);
> +       vmx_preemption_timer_zero_expect_preempt_at_rip(db_fault_address);
> +       vmx_preemption_timer_zero_advance_past_vmcall();
> +
> +       /*
> +        * VMX-preemption timer would fire after pending debug exceptions
> +        * have delivered a #DB trap, but in this case, the #DB trap is
> +        * intercepted.
> +        */
> +       vmx_set_test_stage(3);
> +       vmx_preemption_timer_zero_set_pending_dbg(1 << DB_VECTOR);
> +       reason = (u32)vmcs_read(EXI_REASON);
> +       report(reason == VMX_EXC_NMI, "Exit reason is 0x%x (expected 0x%x)",
> +              reason, VMX_EXC_NMI);
> +
> +       vmcs_clear_bits(PIN_CONTROLS, PIN_PREEMPT);
> +       enter_guest();
> +
> +       handle_exception(DB_VECTOR, old_db);
> +}
> +
>  static void vmx_db_test_guest(void)
>  {
>         /*
> @@ -9623,6 +9742,7 @@ struct vmx_test vmx_tests[] = {
>         TEST(vmx_pending_event_test),
>         TEST(vmx_pending_event_hlt_test),
>         TEST(vmx_store_tsc_test),
> +       TEST(vmx_preemption_timer_zero_test),
>         /* EPT access tests. */
>         TEST(ept_access_test_not_present),
>         TEST(ept_access_test_read_only),
> --
> 2.26.0.110.g2183baf09c-goog

Adding +Paolo Bonzini.
