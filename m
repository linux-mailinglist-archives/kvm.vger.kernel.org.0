Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F114C16BAC0
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 08:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728983AbgBYHgo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 02:36:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50077 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725837AbgBYHgo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 02:36:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582616202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UaYw3a/oAWVMUnKqFyGXb4v3TqNipzv94u9gYKbmxbs=;
        b=anYkVxqhjCRXieo9k04v8g5nFK+1V8aGyjMlet1szaY+SyAWQ56GUy/jxuQGKi8TtYnz30
        phi26pQtHlVUItIC/7q+kEvTFp6uOYGL6mkZOZd7z34iwMNv6ig/DygDIzV91fTd35owa9
        ayTiUdaSAWHG+ZV6KW3t1/chFwg/nuo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-g2pE6xlVPGGdlh84OiK5ww-1; Tue, 25 Feb 2020 02:36:41 -0500
X-MC-Unique: g2pE6xlVPGGdlh84OiK5ww-1
Received: by mail-wm1-f69.google.com with SMTP id y7so499744wmd.4
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 23:36:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UaYw3a/oAWVMUnKqFyGXb4v3TqNipzv94u9gYKbmxbs=;
        b=BbdRyWgABkMy7KpRlMa9gtB9rGXyd0WmdtqqXnlCghwYFbP3Znt1uwi53pt7lz3y04
         6Cpeka3tovP9zjipWX5SWdP1pj5fK6K9gtFhZ/1XZOGpW19mHUgtnyi9fN5ZLzaUN+8r
         pL8Ip3FIqhJEeblTGE3hJ4SDWE+QXE68toibwfVfh31TTIbV4YzK3imG1P8LKN1Hgo7G
         1o9S0VyD9ab1I9FOuMbpk0cgGVoq380+59wpt/nByDO5qe/AwB55TsQp2cdbfVNWlP40
         GDtjgKZ+/CKzeMcp8qLn12x/nahK+IfmlQY87lsB65u41d/YMtMr6Cws6LNUvXNjRMmK
         TKhQ==
X-Gm-Message-State: APjAAAXwGYV0xz4wVQvB7ixIHdTfZrSXbglv2ObmjsfaEY8ImLEUpv0y
        EK4elrt2hdI4qH45X91pgnz8neHjRXVbVsRwEbSDM9JHhdGb6XMDjb9L54qlDiPpMkq/xUjAsrg
        Z0wyzeG1C/ukg
X-Received: by 2002:a1c:6085:: with SMTP id u127mr3825761wmb.144.1582616199688;
        Mon, 24 Feb 2020 23:36:39 -0800 (PST)
X-Google-Smtp-Source: APXvYqw9RyFP4ywpygTK8FtYOgl5gjqMEyrZ/M1g+IUT7YO+3J7gSwW1Eii9IvUuFzVgobYtl9yNpw==
X-Received: by 2002:a1c:6085:: with SMTP id u127mr3825730wmb.144.1582616199337;
        Mon, 24 Feb 2020 23:36:39 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:60c6:7e02:8eeb:a041? ([2001:b07:6468:f312:60c6:7e02:8eeb:a041])
        by smtp.gmail.com with ESMTPSA id b10sm23512211wrw.61.2020.02.24.23.36.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 23:36:38 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v3 5/5] x86: VMX: Add tests for monitor
 trap flag
To:     Oliver Upton <oupton@google.com>, kvm list <kvm@vger.kernel.org>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200207103608.110305-1-oupton@google.com>
 <20200207103608.110305-6-oupton@google.com>
 <CAOQ_QsgXKT20apeRQ7YckWGY=QUGZkQSixb_uvFEnqgwd6=rJQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <202bf11f-289d-352c-0161-9c5b86507685@redhat.com>
Date:   Tue, 25 Feb 2020 08:36:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAOQ_QsgXKT20apeRQ7YckWGY=QUGZkQSixb_uvFEnqgwd6=rJQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/02/20 01:09, Oliver Upton wrote:
> On Fri, Feb 7, 2020 at 2:36 AM Oliver Upton <oupton@google.com> wrote:
>>
>> Test to verify that MTF VM-exits into host are synthesized when the
>> 'monitor trap flag' processor-based VM-execution control is set under
>> various conditions.
>>
>> Expect an MTF VM-exit if instruction execution produces no events other
>> than MTF. Should instruction execution produce a concurrent debug-trap
>> and MTF event, expect an MTF VM-exit with the 'pending debug exceptions'
>> VMCS field set. Expect an MTF VM-exit to follow event delivery should
>> instruction execution generate a higher-priority event, such as a
>> general-protection fault. Lastly, expect an MTF VM-exit to follow
>> delivery of a debug-trap software exception (INT1/INT3/INTO/INT n).
>>
>> Signed-off-by: Oliver Upton <oupton@google.com>
>> Reviewed-by: Jim Mattson <jmattson@google.com>
>> ---
>>  x86/vmx.h       |   1 +
>>  x86/vmx_tests.c | 157 ++++++++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 158 insertions(+)
>>
>> diff --git a/x86/vmx.h b/x86/vmx.h
>> index 6214400f2b53..6adf0916564b 100644
>> --- a/x86/vmx.h
>> +++ b/x86/vmx.h
>> @@ -399,6 +399,7 @@ enum Ctrl0 {
>>         CPU_NMI_WINDOW          = 1ul << 22,
>>         CPU_IO                  = 1ul << 24,
>>         CPU_IO_BITMAP           = 1ul << 25,
>> +       CPU_MTF                 = 1ul << 27,
>>         CPU_MSR_BITMAP          = 1ul << 28,
>>         CPU_MONITOR             = 1ul << 29,
>>         CPU_PAUSE               = 1ul << 30,
>> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>> index b31c360c5f3c..0e2c2f8a7d34 100644
>> --- a/x86/vmx_tests.c
>> +++ b/x86/vmx_tests.c
>> @@ -4970,6 +4970,162 @@ static void test_vmx_preemption_timer(void)
>>         vmcs_write(EXI_CONTROLS, saved_exit);
>>  }
>>
>> +extern unsigned char test_mtf1;
>> +extern unsigned char test_mtf2;
>> +extern unsigned char test_mtf3;
>> +
>> +__attribute__((noclone)) static void test_mtf_guest(void)
>> +{
>> +       asm ("vmcall;\n\t"
>> +            "out %al, $0x80;\n\t"
>> +            "test_mtf1:\n\t"
>> +            "vmcall;\n\t"
>> +            "out %al, $0x80;\n\t"
>> +            "test_mtf2:\n\t"
>> +            /*
>> +             * Prepare for the 'MOV CR3' test. Attempt to induce a
>> +             * general-protection fault by moving a non-canonical address into
>> +             * CR3. The 'MOV CR3' instruction does not take an imm64 operand,
>> +             * so we must MOV the desired value into a register first.
>> +             *
>> +             * MOV RAX is done before the VMCALL such that MTF is only enabled
>> +             * for the instruction under test.
>> +             */
>> +            "mov $0x8000000000000000, %rax;\n\t"
>> +            "vmcall;\n\t"
>> +            "mov %rax, %cr3;\n\t"
>> +            "test_mtf3:\n\t"
>> +            "vmcall;\n\t"
>> +            /*
>> +             * ICEBP/INT1 instruction. Though the instruction is now
>> +             * documented, don't rely on assemblers enumerating the
>> +             * instruction. Resort to hand assembly.
>> +             */
>> +            ".byte 0xf1;\n\t");
>> +}
>> +
>> +static void test_mtf_gp_handler(struct ex_regs *regs)
>> +{
>> +       regs->rip = (unsigned long) &test_mtf3;
>> +}
>> +
>> +static void test_mtf_db_handler(struct ex_regs *regs)
>> +{
>> +}
>> +
>> +static void enable_mtf(void)
>> +{
>> +       u32 ctrl0 = vmcs_read(CPU_EXEC_CTRL0);
>> +
>> +       vmcs_write(CPU_EXEC_CTRL0, ctrl0 | CPU_MTF);
>> +}
>> +
>> +static void disable_mtf(void)
>> +{
>> +       u32 ctrl0 = vmcs_read(CPU_EXEC_CTRL0);
>> +
>> +       vmcs_write(CPU_EXEC_CTRL0, ctrl0 & ~CPU_MTF);
>> +}
>> +
>> +static void enable_tf(void)
>> +{
>> +       unsigned long rflags = vmcs_read(GUEST_RFLAGS);
>> +
>> +       vmcs_write(GUEST_RFLAGS, rflags | X86_EFLAGS_TF);
>> +}
>> +
>> +static void disable_tf(void)
>> +{
>> +       unsigned long rflags = vmcs_read(GUEST_RFLAGS);
>> +
>> +       vmcs_write(GUEST_RFLAGS, rflags & ~X86_EFLAGS_TF);
>> +}
>> +
>> +static void report_mtf(const char *insn_name, unsigned long exp_rip)
>> +{
>> +       unsigned long rip = vmcs_read(GUEST_RIP);
>> +
>> +       assert_exit_reason(VMX_MTF);
>> +       report(rip == exp_rip, "MTF VM-exit after %s instruction. RIP: 0x%lx (expected 0x%lx)",
>> +              insn_name, rip, exp_rip);
>> +}
>> +
>> +static void vmx_mtf_test(void)
>> +{
>> +       unsigned long pending_dbg;
>> +       handler old_gp, old_db;
>> +
>> +       if (!(ctrl_cpu_rev[0].clr & CPU_MTF)) {
>> +               printf("CPU does not support the 'monitor trap flag' processor-based VM-execution control.\n");
>> +               return;
>> +       }
>> +
>> +       test_set_guest(test_mtf_guest);
>> +
>> +       /* Expect an MTF VM-exit after OUT instruction */
>> +       enter_guest();
>> +       skip_exit_vmcall();
>> +
>> +       enable_mtf();
>> +       enter_guest();
>> +       report_mtf("OUT", (unsigned long) &test_mtf1);
>> +       disable_mtf();
>> +
>> +       /*
>> +        * Concurrent #DB trap and MTF on instruction boundary. Expect MTF
>> +        * VM-exit with populated 'pending debug exceptions' VMCS field.
>> +        */
>> +       enter_guest();
>> +       skip_exit_vmcall();
>> +
>> +       enable_mtf();
>> +       enable_tf();
>> +
>> +       enter_guest();
>> +       report_mtf("OUT", (unsigned long) &test_mtf2);
>> +       pending_dbg = vmcs_read(GUEST_PENDING_DEBUG);
>> +       report(pending_dbg & DR_STEP,
>> +              "'pending debug exceptions' field after MTF VM-exit: 0x%lx (expected 0x%lx)",
>> +              pending_dbg, (unsigned long) DR_STEP);
>> +
>> +       disable_mtf();
>> +       disable_tf();
>> +       vmcs_write(GUEST_PENDING_DEBUG, 0);
>> +
>> +       /*
>> +        * #GP exception takes priority over MTF. Expect MTF VM-exit with RIP
>> +        * advanced to first instruction of #GP handler.
>> +        */
>> +       enter_guest();
>> +       skip_exit_vmcall();
>> +
>> +       old_gp = handle_exception(GP_VECTOR, test_mtf_gp_handler);
>> +
>> +       enable_mtf();
>> +       enter_guest();
>> +       report_mtf("MOV CR3", (unsigned long) get_idt_addr(&boot_idt[GP_VECTOR]));
>> +       disable_mtf();
>> +
>> +       /*
>> +        * Concurrent MTF and privileged software exception (i.e. ICEBP/INT1).
>> +        * MTF should follow the delivery of #DB trap, though the SDM doesn't
>> +        * provide clear indication of the relative priority.
>> +        */
>> +       enter_guest();
>> +       skip_exit_vmcall();
>> +
>> +       handle_exception(GP_VECTOR, old_gp);
>> +       old_db = handle_exception(DB_VECTOR, test_mtf_db_handler);
>> +
>> +       enable_mtf();
>> +       enter_guest();
>> +       report_mtf("INT1", (unsigned long) get_idt_addr(&boot_idt[DB_VECTOR]));
>> +       disable_mtf();
>> +
>> +       enter_guest();
>> +       handle_exception(DB_VECTOR, old_db);
>> +}
>> +
>>  /*
>>   * Tests for VM-execution control fields
>>   */
>> @@ -9505,5 +9661,6 @@ struct vmx_test vmx_tests[] = {
>>         TEST(atomic_switch_max_msrs_test),
>>         TEST(atomic_switch_overflow_msrs_test),
>>         TEST(rdtsc_vmexit_diff_test),
>> +       TEST(vmx_mtf_test),
>>         { NULL, NULL, NULL, NULL, NULL, {0} },
>>  };
>> --
>> 2.25.0.341.g760bfbb309-goog
>>
> 
> Friendly ping :) (Just on this patch, 1-4 have already been applied)

Done, thanks.  I only had to push, since I had applied it already to
test the KVM changes.

Paolo

