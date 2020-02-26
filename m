Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1043B16F48A
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 01:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729376AbgBZAz2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 19:55:28 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:33615 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728865AbgBZAz2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 19:55:28 -0500
Received: by mail-lf1-f65.google.com with SMTP id n25so652138lfl.0
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 16:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kofpq0ryBGq8q7LXYc8FLYm5lBu/RwSYQGoNVFBTJ8c=;
        b=e6T2WhTN1FwAt5fKQQF6z75oa4m9FMg/yVq+yF66ec15kZQDBmDoKSkHjMiwQF46Mw
         j3H1nK9Q8CTwSZ203S/IrCPamEfkS7jMvH9F+nqCfoxOyUojRX/UR+bOPPjMvkIB2so6
         GQwf6E6Vn963qg8xljWYBHi78QMeOJHwowGn3pzUZ3nMpVbFAk155LFAkahM28DGTCeG
         B8dpHgd+SKHPorBR55Lwqpdv96VF2HnGXWD9oW5eGQfDrGfRwK6zyb1NkgXTiXTbCxmJ
         QnaOpMGCnJjpVCa55N21pLhBxccjfyHjqJ9bC10HNHmyiXm3Koh0Vfh0xLE74pVrC6qY
         /i0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kofpq0ryBGq8q7LXYc8FLYm5lBu/RwSYQGoNVFBTJ8c=;
        b=VFrAy/bFCP8l66xfzQLU5NCc6rhBS7KE2YIGuGtxTpCZiG5mooDkvNdoHCDiA4PBqC
         5WzCreMI+yeOHN2LF0L41ET5av9FYI2XcmfhKTVXi/3vxAjpri2F+Vsk12stYnFpdfGh
         HFPrzDmMrnF4RFSPewgz/hygHDhLxpwTIhFQ6aYRMvFh2Mm9M7tAFpfV6srou0tQmJOu
         795xWFDhpsftPq+FzytwRL4DIbt4C19/JC924IjIPdOmCGGVYC2Zhn4609FsOUuLlUdE
         SHmbZjd8RiAibbLcqMABfJqC4fAx3rriNRjY0hAE+CbS0o9J6cGUt3l6MlRamtWemPXk
         cQFA==
X-Gm-Message-State: APjAAAVJmoH00XaeSMCk6531j0GY7e4yM1MYb47pqT2voPVg48FFml+/
        vfYu42t5jA6KKgCALETCEzUlD0+SDuLndpc2/8MvQg==
X-Google-Smtp-Source: APXvYqycP28GDg4qUuFuGQuGXvryOid9m5H4aUQSRTQiwqCdvCcDPwyvf/Fw3Lt0UuY3sbSVYBQ7w8+kvIno4UC7rtg=
X-Received: by 2002:ac2:4d16:: with SMTP id r22mr803022lfi.74.1582678524559;
 Tue, 25 Feb 2020 16:55:24 -0800 (PST)
MIME-Version: 1.0
References: <20200207103608.110305-1-oupton@google.com> <20200207103608.110305-6-oupton@google.com>
 <CAOQ_QsgXKT20apeRQ7YckWGY=QUGZkQSixb_uvFEnqgwd6=rJQ@mail.gmail.com> <33c721e1-3af2-70c5-f01f-b22427e4e3aa@oracle.com>
In-Reply-To: <33c721e1-3af2-70c5-f01f-b22427e4e3aa@oracle.com>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 25 Feb 2020 16:55:13 -0800
Message-ID: <CAOQ_QsgrQKzJcHyDoF-+XR_1um3tQUKv3PmDk-zc7VhSyJUGfw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3 5/5] x86: VMX: Add tests for monitor
 trap flag
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 25, 2020 at 4:13 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
>
> On 02/24/2020 04:09 PM, Oliver Upton wrote:
> > On Fri, Feb 7, 2020 at 2:36 AM Oliver Upton <oupton@google.com> wrote:
> >> Test to verify that MTF VM-exits into host are synthesized when the
> >> 'monitor trap flag' processor-based VM-execution control is set under
> >> various conditions.
> >>
> >> Expect an MTF VM-exit if instruction execution produces no events other
> >> than MTF. Should instruction execution produce a concurrent debug-trap
> >> and MTF event, expect an MTF VM-exit with the 'pending debug exceptions'
> >> VMCS field set. Expect an MTF VM-exit to follow event delivery should
> >> instruction execution generate a higher-priority event, such as a
> >> general-protection fault. Lastly, expect an MTF VM-exit to follow
> >> delivery of a debug-trap software exception (INT1/INT3/INTO/INT n).
> >>
> >> Signed-off-by: Oliver Upton <oupton@google.com>
> >> Reviewed-by: Jim Mattson <jmattson@google.com>
> >> ---
> >>   x86/vmx.h       |   1 +
> >>   x86/vmx_tests.c | 157 ++++++++++++++++++++++++++++++++++++++++++++++++
> >>   2 files changed, 158 insertions(+)
> >>
> >> diff --git a/x86/vmx.h b/x86/vmx.h
> >> index 6214400f2b53..6adf0916564b 100644
> >> --- a/x86/vmx.h
> >> +++ b/x86/vmx.h
> >> @@ -399,6 +399,7 @@ enum Ctrl0 {
> >>          CPU_NMI_WINDOW          = 1ul << 22,
> >>          CPU_IO                  = 1ul << 24,
> >>          CPU_IO_BITMAP           = 1ul << 25,
> >> +       CPU_MTF                 = 1ul << 27,
> >>          CPU_MSR_BITMAP          = 1ul << 28,
> >>          CPU_MONITOR             = 1ul << 29,
> >>          CPU_PAUSE               = 1ul << 30,
> >> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> >> index b31c360c5f3c..0e2c2f8a7d34 100644
> >> --- a/x86/vmx_tests.c
> >> +++ b/x86/vmx_tests.c
> >> @@ -4970,6 +4970,162 @@ static void test_vmx_preemption_timer(void)
> >>          vmcs_write(EXI_CONTROLS, saved_exit);
> >>   }
> >>
> >> +extern unsigned char test_mtf1;
> >> +extern unsigned char test_mtf2;
> >> +extern unsigned char test_mtf3;
> >> +
> >> +__attribute__((noclone)) static void test_mtf_guest(void)
> >> +{
> >> +       asm ("vmcall;\n\t"
> >> +            "out %al, $0x80;\n\t"
> >> +            "test_mtf1:\n\t"
> >> +            "vmcall;\n\t"
> >> +            "out %al, $0x80;\n\t"
> >> +            "test_mtf2:\n\t"
> >> +            /*
> >> +             * Prepare for the 'MOV CR3' test. Attempt to induce a
> >> +             * general-protection fault by moving a non-canonical address into
> >> +             * CR3. The 'MOV CR3' instruction does not take an imm64 operand,
> >> +             * so we must MOV the desired value into a register first.
> >> +             *
> >> +             * MOV RAX is done before the VMCALL such that MTF is only enabled
> >> +             * for the instruction under test.
> >> +             */
> >> +            "mov $0x8000000000000000, %rax;\n\t"
> >> +            "vmcall;\n\t"
> >> +            "mov %rax, %cr3;\n\t"
> >> +            "test_mtf3:\n\t"
> >> +            "vmcall;\n\t"
> >> +            /*
> >> +             * ICEBP/INT1 instruction. Though the instruction is now
> >> +             * documented, don't rely on assemblers enumerating the
> >> +             * instruction. Resort to hand assembly.
> >> +             */
> >> +            ".byte 0xf1;\n\t");
> >> +}
> >> +
> >> +static void test_mtf_gp_handler(struct ex_regs *regs)
> >> +{
> >> +       regs->rip = (unsigned long) &test_mtf3;
> >> +}
> >> +
> >> +static void test_mtf_db_handler(struct ex_regs *regs)
> >> +{
> >> +}
> >> +
> >> +static void enable_mtf(void)
> >> +{
> >> +       u32 ctrl0 = vmcs_read(CPU_EXEC_CTRL0);
> >> +
> >> +       vmcs_write(CPU_EXEC_CTRL0, ctrl0 | CPU_MTF);
> >> +}
> >> +
> >> +static void disable_mtf(void)
> >> +{
> >> +       u32 ctrl0 = vmcs_read(CPU_EXEC_CTRL0);
> >> +
> >> +       vmcs_write(CPU_EXEC_CTRL0, ctrl0 & ~CPU_MTF);
> >> +}
> >> +
> >> +static void enable_tf(void)
> >> +{
> >> +       unsigned long rflags = vmcs_read(GUEST_RFLAGS);
> >> +
> >> +       vmcs_write(GUEST_RFLAGS, rflags | X86_EFLAGS_TF);
> >> +}
> >> +
> >> +static void disable_tf(void)
> >> +{
> >> +       unsigned long rflags = vmcs_read(GUEST_RFLAGS);
> >> +
> >> +       vmcs_write(GUEST_RFLAGS, rflags & ~X86_EFLAGS_TF);
> >> +}
> >> +
> >> +static void report_mtf(const char *insn_name, unsigned long exp_rip)
> >> +{
> >> +       unsigned long rip = vmcs_read(GUEST_RIP);
> >> +
> >> +       assert_exit_reason(VMX_MTF);
> >> +       report(rip == exp_rip, "MTF VM-exit after %s instruction. RIP: 0x%lx (expected 0x%lx)",
> >> +              insn_name, rip, exp_rip);
> >> +}
> >> +
> >> +static void vmx_mtf_test(void)
> >> +{
> >> +       unsigned long pending_dbg;
> >> +       handler old_gp, old_db;
> >> +
> >> +       if (!(ctrl_cpu_rev[0].clr & CPU_MTF)) {
> >> +               printf("CPU does not support the 'monitor trap flag' processor-based VM-execution control.\n");
> >> +               return;
> >> +       }
> >> +
> >> +       test_set_guest(test_mtf_guest);
> >> +
> >> +       /* Expect an MTF VM-exit after OUT instruction */
> >> +       enter_guest();
> >> +       skip_exit_vmcall();
> >> +
> >> +       enable_mtf();
> >> +       enter_guest();
> >> +       report_mtf("OUT", (unsigned long) &test_mtf1);
> >> +       disable_mtf();
> >> +
> >> +       /*
> >> +        * Concurrent #DB trap and MTF on instruction boundary. Expect MTF
> >> +        * VM-exit with populated 'pending debug exceptions' VMCS field.
> >> +        */
> >> +       enter_guest();
> >> +       skip_exit_vmcall();
> >> +
> >> +       enable_mtf();
> >> +       enable_tf();
> >> +
> >> +       enter_guest();
> >> +       report_mtf("OUT", (unsigned long) &test_mtf2);
> >> +       pending_dbg = vmcs_read(GUEST_PENDING_DEBUG);
> >> +       report(pending_dbg & DR_STEP,
> >> +              "'pending debug exceptions' field after MTF VM-exit: 0x%lx (expected 0x%lx)",
> >> +              pending_dbg, (unsigned long) DR_STEP);
> >> +
> >> +       disable_mtf();
> >> +       disable_tf();
> >> +       vmcs_write(GUEST_PENDING_DEBUG, 0);
> >> +
> >> +       /*
> >> +        * #GP exception takes priority over MTF. Expect MTF VM-exit with RIP
> >> +        * advanced to first instruction of #GP handler.
> >> +        */
> >> +       enter_guest();
> >> +       skip_exit_vmcall();
> >> +
> >> +       old_gp = handle_exception(GP_VECTOR, test_mtf_gp_handler);
> >> +
> >> +       enable_mtf();
> >> +       enter_guest();
> >> +       report_mtf("MOV CR3", (unsigned long) get_idt_addr(&boot_idt[GP_VECTOR]));
> >> +       disable_mtf();
> >> +
> >> +       /*
> >> +        * Concurrent MTF and privileged software exception (i.e. ICEBP/INT1).
> >> +        * MTF should follow the delivery of #DB trap, though the SDM doesn't
> >> +        * provide clear indication of the relative priority.
> >> +        */
> >> +       enter_guest();
> >> +       skip_exit_vmcall();
> >> +
> >> +       handle_exception(GP_VECTOR, old_gp);
> >> +       old_db = handle_exception(DB_VECTOR, test_mtf_db_handler);
> >> +
> >> +       enable_mtf();
> >> +       enter_guest();
> >> +       report_mtf("INT1", (unsigned long) get_idt_addr(&boot_idt[DB_VECTOR]));
> >> +       disable_mtf();
> >> +
> >> +       enter_guest();
> >> +       handle_exception(DB_VECTOR, old_db);
> >> +}
> >> +
> >>   /*
> >>    * Tests for VM-execution control fields
> >>    */
> >> @@ -9505,5 +9661,6 @@ struct vmx_test vmx_tests[] = {
> >>          TEST(atomic_switch_max_msrs_test),
> >>          TEST(atomic_switch_overflow_msrs_test),
> >>          TEST(rdtsc_vmexit_diff_test),
> >> +       TEST(vmx_mtf_test),
> >>          { NULL, NULL, NULL, NULL, NULL, {0} },
> >>   };
> >> --
> >> 2.25.0.341.g760bfbb309-goog
> >>
> > Friendly ping :) (Just on this patch, 1-4 have already been applied)
> >
> > --
> > Thanks,
> > Oliver
> I know Paolo has already applied this patch. Wanted to send out the
> comments anyway as I was reviewing it...
>
>      1. The commit header should have "nVMX" instead of "VMX". That's
> important for searching git history.

"VMX" was intentional, as these tests need not imply any use of nested
virtualization. They're simply tests for an implementation of VMX, be
it KVM nVMX or Intel hardware VMX. In fact, I booted kvm-unit-tests on
bare-metal before sending out to ensure the series behaved
identically.

>      2. It would be better for readability if the commit message lists
> the test scenarios as numbered items or bullet points instead of putting
> them all in the same paragraph.

Sounds good, I'll conform to the suggested style in future contributions.

>      3. Section 25.5.2 in the SDM has more scenarios for MTF VM-exits,
> but the test covers only a few scenarios like #DB, #GP etc.

Yes, this test covers a limited set of scenarios for MTF. The cases
were chosen to exercise the emulation added to KVM nVMX as part of the
series rather than to exercise hardware-generated MTF VM-exits
unconditionally forwarded to L1. However, using such contrived
scenarios doesn't quite align with my response to (1) where the tests
haven't any implications of nested virtualization.

Thanks Krish :)

--
Best,
Oliver
