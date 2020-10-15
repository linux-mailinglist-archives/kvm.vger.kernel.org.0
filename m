Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1A328F5CD
	for <lists+kvm@lfdr.de>; Thu, 15 Oct 2020 17:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389147AbgJOP0y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Oct 2020 11:26:54 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4964 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388357AbgJOP0y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Oct 2020 11:26:54 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09FF1XlG093058
        for <kvm@vger.kernel.org>; Thu, 15 Oct 2020 11:26:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=6xFds+JYG4lJw345A7IopkVagtXb6z9RXC3UXon99b8=;
 b=q52pTT6+52Zk9KaRrwrmtdTU3pzJ8E1a/4nikyJ3wOHIpx3M4QawzawLrhdFy3uRSg/W
 JyRFBiFbEHrCLyJi6VGovCiUZH7jjNNanhSr5h0UtDZ3JezfEqfFwE6E9C8B7c340ZX2
 prfc8PYIQ/Wr+07pOUzNQctGA7QaqQa2txzlXln8vLfV+7kpQvAGQLomDe5OQo9reHlp
 2LROGMrUmqQhrfoFabNlMa0KrP3Js272WYkghgOcJUpYkwwqU/guuRFY68Y9fxNN2URd
 tkl0crj8IPkKUhq+xBvE/VYlcmVhor5tiyBJTZCdV/LHS5Pc6mEDIjj7MXWjbvvSiGES mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 346r21aewd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 15 Oct 2020 11:26:52 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09FF1Z0O093231
        for <kvm@vger.kernel.org>; Thu, 15 Oct 2020 11:26:51 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 346r21aevf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Oct 2020 11:26:51 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09FFGnaT009862;
        Thu, 15 Oct 2020 15:26:50 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03wdc.us.ibm.com with ESMTP id 343y2tjrn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Oct 2020 15:26:50 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09FFQoFQ45154644
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Oct 2020 15:26:50 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E093AE05C;
        Thu, 15 Oct 2020 15:26:50 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE72EAE062;
        Thu, 15 Oct 2020 15:26:49 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.130.217])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTPS;
        Thu, 15 Oct 2020 15:26:49 +0000 (GMT)
Subject: Re: [PATCH v1] self_tests/kvm: sync_regs and reset tests for diag318
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com
References: <20201014192710.66578-1-walling@linux.ibm.com>
 <dc00c982-8d36-3df4-f896-ebe197b97274@redhat.com>
From:   Collin Walling <walling@linux.ibm.com>
Message-ID: <99917e28-7c77-c7c3-5641-c711b107cf70@linux.ibm.com>
Date:   Thu, 15 Oct 2020 11:26:49 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <dc00c982-8d36-3df4-f896-ebe197b97274@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-15_08:2020-10-14,2020-10-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 clxscore=1015 adultscore=0 phishscore=0 suspectscore=2 spamscore=0
 bulkscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010150101
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/15/20 3:55 AM, Thomas Huth wrote:
> On 14/10/2020 21.27, Collin Walling wrote:
>> The DIAGNOSE 0x0318 instruction, unique to s390x, is a privileged call
>> that must be intercepted via SIE, handled in userspace, and the
>> information set by the instruction is communicated back to KVM.
>>
>> To test the instruction interception, an ad-hoc handler is defined which
>> simply has a VM execute the instruction and then userspace will extract
>> the necessary info. The handler is defined such that the instruction
>> invocation occurs only once. It is up the the caller to determine how the
>> info returned by this handler should be used.
>>
>> The diag318 info is communicated from userspace to KVM via a sync_regs
>> call. This is tested during a sync_regs test, where the diag318 info is
>> requested via the handler, then the info is stored in the appropriate
>> register in KVM via a sync registers call.
>>
>> The diag318 info is checked to be 0 after a normal and clear reset.
>>
>> If KVM does not support diag318, then the tests will print a message
>> stating that diag318 was skipped, and the asserts will simply test
>> against a value of 0.
> 
> Thanks a lot for writing the test! Looks pretty good already, but I still
> have some comments / questions below...
> 
>> --- /dev/null
>> +++ b/tools/testing/selftests/kvm/lib/s390x/diag318_test_handler.c
>> @@ -0,0 +1,80 @@
>> +// SPDX-License-Identifier: GPL-2.0-or-later
>> +/*
>> + * Test handler for the s390x DIAGNOSE 0x0318 instruction.
>> + *
>> + * Copyright (C) 2020, IBM
>> + */
>> +
>> +#include "test_util.h"
>> +#include "kvm_util.h"
>> +
>> +#define VCPU_ID	5
>> +
>> +#define ICPT_INSTRUCTION	0x04
>> +#define IPA0_DIAG		0x8300
>> +
>> +static void guest_code(void)
>> +{
>> +	uint64_t diag318_info = 0x12345678;
>> +
>> +	asm volatile ("diag %0,0,0x318\n" : : "d" (diag318_info));
>> +}
>> +
>> +/*
>> + * The DIAGNOSE 0x0318 instruction call must be handled via userspace. As such,
>> + * we create an ad-hoc VM here to handle the instruction then extract the
>> + * necessary data. It is up to the caller to decide what to do with that data.
>> + */
>> +static uint64_t diag318_handler(void)
>> +{
>> +	struct kvm_vm *vm;
>> +	struct kvm_run *run;
>> +	uint64_t reg;
>> +	uint64_t diag318_info;
>> +
>> +	vm = vm_create_default(VCPU_ID, 0, guest_code);
>> +	vcpu_run(vm, VCPU_ID);
>> +	run = vcpu_state(vm, VCPU_ID);
>> +
>> +	TEST_ASSERT(run->exit_reason == KVM_EXIT_S390_SIEIC,
>> +		    "DIAGNOSE 0x0318 instruction was not intercepted");
>> +	TEST_ASSERT(run->s390_sieic.icptcode == ICPT_INSTRUCTION,
>> +		    "Unexpected intercept code: 0x%x", run->s390_sieic.icptcode);
>> +	TEST_ASSERT((run->s390_sieic.ipa & 0xff00) == IPA0_DIAG,
>> +		    "Unexpected IPA0 code: 0x%x", (run->s390_sieic.ipa & 0xff00));
>> +
>> +	reg = (run->s390_sieic.ipa & 0x00f0) >> 4;
>> +	diag318_info = run->s.regs.gprs[reg];
>> +
>> +	kvm_vm_free(vm);
> 
> Could you please add a
> 
> 	TEST_ASSERT(diag_318_info == 0x12345678, ...)
> 
> here?

Will do.

> 
>> +	return diag318_info;
>> +}
>> +
>> +uint64_t get_diag318_info(void)
>> +{
>> +	static uint64_t diag318_info;
>> +	static bool printed_skip;
>> +
>> +	/*
>> +	 * If KVM does not support diag318, then return 0 to
>> +	 * ensure tests do not break.
>> +	 */
>> +	if (!kvm_check_cap(KVM_CAP_S390_DIAG318)) {
>> +		if (!printed_skip) {
>> +			fprintf(stdout, "KVM_CAP_S390_DIAG318 not supported. "
>> +				"Skipping diag318 test.\n");
>> +			printed_skip = true;
>> +		}
>> +		return 0;
>> +	}
>> +
>> +	/*
>> +	 * If a test has previously requested the diag318 info,
>> +	 * then don't bother spinning up a temporary VM again.
>> +	 */
>> +	if (!diag318_info)
>> +		diag318_info = diag318_handler();
>> +
>> +	return diag318_info;
>> +}
>> diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testing/selftests/kvm/s390x/resets.c
>> index b143db6d8693..d0416ba94ec5 100644
>> --- a/tools/testing/selftests/kvm/s390x/resets.c
>> +++ b/tools/testing/selftests/kvm/s390x/resets.c
>> @@ -12,6 +12,7 @@
>>  
>>  #include "test_util.h"
>>  #include "kvm_util.h"
>> +#include "diag318_test_handler.h"
>>  
>>  #define VCPU_ID 3
>>  #define LOCAL_IRQS 32
>> @@ -110,6 +111,8 @@ static void assert_clear(void)
>>  
>>  	TEST_ASSERT(!memcmp(sync_regs->vrs, regs_null, sizeof(sync_regs->vrs)),
>>  		    "vrs0-15 == 0 (sync_regs)");
>> +
>> +	TEST_ASSERT(sync_regs->diag318 == 0, "diag318 == 0 (sync_regs)");
>>  }
>>  
>>  static void assert_initial_noclear(void)
>> @@ -182,6 +185,7 @@ static void assert_normal(void)
>>  	test_one_reg(KVM_REG_S390_PFTOKEN, KVM_S390_PFAULT_TOKEN_INVALID);
>>  	TEST_ASSERT(sync_regs->pft == KVM_S390_PFAULT_TOKEN_INVALID,
>>  			"pft == 0xff.....  (sync_regs)");
>> +	TEST_ASSERT(sync_regs->diag318 == 0, "diag318 == 0 (sync_regs)");
>>  	assert_noirq();
>>  }
>>  
>> @@ -206,6 +210,7 @@ static void test_normal(void)
>>  	/* Create VM */
>>  	vm = vm_create_default(VCPU_ID, 0, guest_code_initial);
>>  	run = vcpu_state(vm, VCPU_ID);
>> +	run->s.regs.diag318 = get_diag318_info();
>>  	sync_regs = &run->s.regs;
> 
> Not sure, but don't you have to mark KVM_SYNC_DIAG318 in run->kvm_valid_regs
> and run->kvm_dirty_regs here...

Hmm... you're right. I need to do that...

Looks like the normal reset case is failing now. I must've missed
setting the value to 0 in KVM's normal reset handler...

It's a one-line fix (and truthfully, there isn't much harm done). I'll
toss it up on the list.

> 
>>  	vcpu_run(vm, VCPU_ID);
>> @@ -250,6 +255,7 @@ static void test_clear(void)
>>  	pr_info("Testing clear reset\n");
>>  	vm = vm_create_default(VCPU_ID, 0, guest_code_initial);
>>  	run = vcpu_state(vm, VCPU_ID);
>> +	run->s.regs.diag318 = get_diag318_info();
>>  	sync_regs = &run->s.regs;
> 
> ... and here?
> 
>  Thomas
> 


-- 
Regards,
Collin

Stay safe and stay healthy
