Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 144CDB26BF
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 22:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388871AbfIMUiM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 16:38:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46140 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388167AbfIMUiM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 16:38:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8DKTXWB111543;
        Fri, 13 Sep 2019 20:37:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=UnHv8GsPRMvPYvkuE3GfiVzOkpVWk1Oi2pxkcI2+QNs=;
 b=ltUFe5j6111wxw0O2auNMY0/mBG3bdsmvDMr38NPMobx59m+ZDYP9sWalKoHgaFp9aQ7
 +yg1ME6BjRwQZHlbhSPBwJ4Kz1Us/i4oxZn8/IhbolSR5qXx1flPVV/tcEOstlMTMMwg
 eikhoztXcSjjS9K5CGO7QWTZxLkOnbqfiRodNcFkar6LUflzE8cyhARsfap2hD3y2pyG
 WQ+SUOV7Zl/qX10S4zEjWDyljm/1A7Oj0SSrkRFWKdIoS3f6QyimfXGxM0mwWYriVoXU
 pr5I7LFPvmkL5fKejP9636KwgC+RJjF70TZOxpFzIvkdw1D0YZqSFpwUEW5TrFYP2shA nA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2uytd36x92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Sep 2019 20:37:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8DKTSsq131242;
        Fri, 13 Sep 2019 20:37:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2uytdna7jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Sep 2019 20:37:58 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8DKbulk013241;
        Fri, 13 Sep 2019 20:37:56 GMT
Received: from [10.159.133.236] (/10.159.133.236)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Sep 2019 13:37:56 -0700
Subject: Re: [PATCH 3/4] kvm-unit-test: nVMX: __enter_guest() should not set
 "launched" state when VM-entry fails
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, rkrcmar@redhat.com, pbonzini@redhat.com,
        jmattson@google.com
References: <20190829205635.20189-1-krish.sadhukhan@oracle.com>
 <20190829205635.20189-4-krish.sadhukhan@oracle.com>
 <20190904154231.GB24079@linux.intel.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <a2268863-e554-4547-5196-3509bda3ace3@oracle.com>
Date:   Fri, 13 Sep 2019 13:37:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190904154231.GB24079@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9379 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909130208
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9379 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909130208
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/4/19 8:42 AM, Sean Christopherson wrote:
> On Thu, Aug 29, 2019 at 04:56:34PM -0400, Krish Sadhukhan wrote:
>> Bit# 31 in VM-exit reason is set by hardware in both cases of early VM-entry
>> failures and VM-entry failures due to invalid guest state.
> This is incorrect, VMCS.EXIT_REASON is not written on a VM-Fail.  If the
> tests are passing, you're probably consuming a stale EXIT_REASON.

In vmx_vcpu_run(),

         if (vmx->fail || (vmx->exit_reason & 
VMX_EXIT_REASONS_FAILED_VMENTRY))
                 return;

         vmx->loaded_vmcs->launched = 1;

we return without setting "launched" whenever bit# 31 is set in Exit 
Reason. If VM-entry fails due to invalid guest state or due to errors in 
VM-entry MSR-loading area, bit#31 is set.  As a result, L2 is not in 
"launched" state when we return to L1.  Tests that want to VMRESUME L2 
after fixing the bad guest state or the bad MSR-loading area, fail with 
VM-Instruction Error 5,

         "Early vmresume failure: error number is 5. See Intel 30.4."

>
>> Whenever VM-entry
>> fails, the nested VMCS is not in "launched" state any more. Hence,
>> __enter_guest() should not set the "launched" state when a VM-entry fails.
>>
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
>> ---
>>   x86/vmx.c | 9 +++++----
>>   1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/x86/vmx.c b/x86/vmx.c
>> index 872ba11..183d11b 100644
>> --- a/x86/vmx.c
>> +++ b/x86/vmx.c
>> @@ -1805,6 +1805,8 @@ static void check_for_guest_termination(void)
>>    */
>>   static void __enter_guest(u8 abort_flag, struct vmentry_failure *failure)
>>   {
>> +	bool vm_entry_failure;
>> +
>>   	TEST_ASSERT_MSG(v2_guest_main,
>>   			"Never called test_set_guest_func!");
>>   
>> @@ -1812,15 +1814,14 @@ static void __enter_guest(u8 abort_flag, struct vmentry_failure *failure)
>>   			"Called enter_guest() after guest returned.");
>>   
>>   	vmx_enter_guest(failure);
>> +	vm_entry_failure = vmcs_read(EXI_REASON) & VMX_ENTRY_FAILURE;
> Rather than duplicating the code in vmx_run(), what if we move this check
> into vmx_enter_guest() and rework struct vmentry_failure?  The code was
> originally designed to handle only VM-Fail conditions, we should clean it
> up instead of bolting more stuff on top.  E.g.:
>
> struct vmentry_status {
> 	/* Did we attempt VMLAUNCH or VMRESUME */
> 	bool vmlaunch;
> 	/* Instruction mnemonic (for convenience). */
> 	const char *instr;
> 	/* VM-Enter passed all consistency checks, i.e. did not fail. */
> 	bool succeeded;
> 	/* VM-Enter failed before loading guest state, i.e. VM-Fail. */
> 	bool vm_fail;
> 	/* Contents of RFLAGS on VM-Fail, EXIT_REASON on VM-Exit.  */
> 	union {
> 		unsigned long vm_fail_flags;
> 		unsigned long vm_exit_reason;
> 	};
> };
>
> static void vmx_enter_guest(struct vmentry_status *status)
> {
> 	status->vm_fail = 0;
>
> 	in_guest = 1;
> 	asm volatile (
> 		"mov %[HOST_RSP], %%rdi\n\t"
> 		"vmwrite %%rsp, %%rdi\n\t"
> 		LOAD_GPR_C
> 		"cmpb $0, %[launched]\n\t"
> 		"jne 1f\n\t"
> 		"vmlaunch\n\t"
> 		"jmp 2f\n\t"
> 		"1: "
> 		"vmresume\n\t"
> 		"2: "
> 		SAVE_GPR_C
> 		"pushf\n\t"
> 		"pop %%rdi\n\t"
> 		"mov %%rdi, %[vm_fail_flags]\n\t"
> 		"movl $1, %[vm_fail]\n\t"
> 		"jmp 3f\n\t"
> 		"vmx_return:\n\t"
> 		SAVE_GPR_C
> 		"3: \n\t"
> 		: [vm_fail]"+m"(status->vm_fail),
> 		  [vm_fail_flags]"=m"(status->vm_fail_flags)
> 		: [launched]"m"(launched), [HOST_RSP]"i"(HOST_RSP)
> 		: "rdi", "memory", "cc"
> 	);
> 	in_guest = 0;
>
> 	if (!status->vm_fail)
> 		status->vm_exit_reason = vmcs_read(EXI_REASON);
> 		
> 	status->succeeded = !status->vm_fail &&
> 			    !(status->vm_exit_reason & VMX_ENTRY_FAILURE);
>
> 	status->vmlaunch = !launched;
> 	status->instr = launched ? "vmresume" : "vmlaunch";
>
> 	if (status->succeeded)
> 		launched = 1;
> }


This looks good. Do you want to send a patch or you want me to add it to 
the current set ?


>
>>   	if ((abort_flag & ABORT_ON_EARLY_VMENTRY_FAIL && failure->early) ||
>> -	    (abort_flag & ABORT_ON_INVALID_GUEST_STATE &&
>> -	    vmcs_read(EXI_REASON) & VMX_ENTRY_FAILURE)) {
>> -
>> +	    (abort_flag & ABORT_ON_INVALID_GUEST_STATE && vm_entry_failure)) {
>>   		print_vmentry_failure_info(failure);
>>   		abort();
>>   	}
>>   
>> -	if (!failure->early) {
>> +	if (!vm_entry_failure) {
>>   		launched = 1;
>>   		check_for_guest_termination();
>>   	}
>> -- 
>> 2.20.1
>>
