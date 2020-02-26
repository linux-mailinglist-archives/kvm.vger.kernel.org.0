Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C56316F41B
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 01:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729230AbgBZANn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 19:13:43 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45404 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728865AbgBZANn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 19:13:43 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01Q0DbUF170777;
        Wed, 26 Feb 2020 00:13:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=EyK63IqnGHMOEClM+j3vACW6wGcP/PPfj2p1ZQUxykk=;
 b=bu5jBjsNXKxVOEZ3+gOnxBuDXICA4Jcd6JEX9hNSpfR1YFiz7gtkPpDmvRjpNA7mEkZK
 mPfvreaSUT3GiSSfd1ijYk/+kOZfEDjdGdXl7gjY/hy50K5qFN8nOwouuEaSA1nmT+Tm
 dGn7A71UbVNs4+bb8jlanX5B5+3KyxPYscIwOdh/6OmaTCNZ3Zq/CD142GRqx64y0nCy
 Dt1WTZBMCtfWTjU95zhkbhknHpgpPEMsoDKmUo4HT1mmJhhFfW7QfGQaJ4JHzC6WYNoZ
 tj9R4yx7XpXdK7dEgmA8hAwdXCKhWc/3G5mz7hqd+QhEQxK056R5x8rbvUG4W2pkjE2i jA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2ydcsn8885-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 00:13:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01Q0C7Zo157040;
        Wed, 26 Feb 2020 00:13:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2ydcs0ku24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 00:13:36 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01Q0DZiV006894;
        Wed, 26 Feb 2020 00:13:35 GMT
Received: from dhcp-10-132-97-93.usdhcp.oraclecorp.com (/10.132.97.93)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Feb 2020 16:13:35 -0800
Subject: Re: [kvm-unit-tests PATCH v3 5/5] x86: VMX: Add tests for monitor
 trap flag
To:     Oliver Upton <oupton@google.com>, kvm list <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200207103608.110305-1-oupton@google.com>
 <20200207103608.110305-6-oupton@google.com>
 <CAOQ_QsgXKT20apeRQ7YckWGY=QUGZkQSixb_uvFEnqgwd6=rJQ@mail.gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <33c721e1-3af2-70c5-f01f-b22427e4e3aa@oracle.com>
Date:   Tue, 25 Feb 2020 16:13:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <CAOQ_QsgXKT20apeRQ7YckWGY=QUGZkQSixb_uvFEnqgwd6=rJQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=3 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0
 suspectscore=3 impostorscore=0 clxscore=1011 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250170
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 02/24/2020 04:09 PM, Oliver Upton wrote:
> On Fri, Feb 7, 2020 at 2:36 AM Oliver Upton <oupton@google.com> wrote:
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
>>   x86/vmx.h       |   1 +
>>   x86/vmx_tests.c | 157 ++++++++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 158 insertions(+)
>>
>> diff --git a/x86/vmx.h b/x86/vmx.h
>> index 6214400f2b53..6adf0916564b 100644
>> --- a/x86/vmx.h
>> +++ b/x86/vmx.h
>> @@ -399,6 +399,7 @@ enum Ctrl0 {
>>          CPU_NMI_WINDOW          = 1ul << 22,
>>          CPU_IO                  = 1ul << 24,
>>          CPU_IO_BITMAP           = 1ul << 25,
>> +       CPU_MTF                 = 1ul << 27,
>>          CPU_MSR_BITMAP          = 1ul << 28,
>>          CPU_MONITOR             = 1ul << 29,
>>          CPU_PAUSE               = 1ul << 30,
>> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>> index b31c360c5f3c..0e2c2f8a7d34 100644
>> --- a/x86/vmx_tests.c
>> +++ b/x86/vmx_tests.c
>> @@ -4970,6 +4970,162 @@ static void test_vmx_preemption_timer(void)
>>          vmcs_write(EXI_CONTROLS, saved_exit);
>>   }
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
>>   /*
>>    * Tests for VM-execution control fields
>>    */
>> @@ -9505,5 +9661,6 @@ struct vmx_test vmx_tests[] = {
>>          TEST(atomic_switch_max_msrs_test),
>>          TEST(atomic_switch_overflow_msrs_test),
>>          TEST(rdtsc_vmexit_diff_test),
>> +       TEST(vmx_mtf_test),
>>          { NULL, NULL, NULL, NULL, NULL, {0} },
>>   };
>> --
>> 2.25.0.341.g760bfbb309-goog
>>
> Friendly ping :) (Just on this patch, 1-4 have already been applied)
>
> --
> Thanks,
> Oliver
I know Paolo has already applied this patch. Wanted to send out the 
comments anyway as I was reviewing it...

     1. The commit header should have "nVMX" instead of "VMX". That's 
important for searching git history.
     2. It would be better for readability if the commit message lists 
the test scenarios as numbered items or bullet points instead of putting 
them all in the same paragraph.
     3. Section 25.5.2 in the SDM has more scenarios for MTF VM-exits, 
but the test covers only a few scenarios like #DB, #GP etc.
