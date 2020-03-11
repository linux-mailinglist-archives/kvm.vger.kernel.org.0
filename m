Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9EF18235C
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 21:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbgCKUif (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 16:38:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38450 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbgCKUie (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 16:38:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02BKXWv7002773;
        Wed, 11 Mar 2020 20:38:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Tgc4Gjqv7+jxDJR4aa5VlCLxBDwDEVU0ZJPG7KlEDH8=;
 b=VhL5FrEMRjoesjE/t5vTsQl7HHXY+21iofQAq6uCjP3gWP9kB1RJNaKvFGRy0Cgu04kq
 qCvnGS3+4McGAPvADG2B8/Un11DISpyHxqmf3O/gM2dGILBwr8RO8vjw2tsxj3CM/hH5
 JxIbZDTs+EsQmrbgt2DhSq3lQ1JHxJyUt3Pk+n8lp3nk3UR3SB0VoVw0+zsSa2tBsIpM
 WQz25/k8ieyIaVMTlDgP3sA1fR83SPk6a+a8axiPDzVi6aX7p4zBQsruOKCdZ99IG7ey
 PAsManBTKng+waBfit3MiVEvthx4cYQ6HH5pRWk6zG8qMGVfRWrSM1RByxta/3WE5UNs Mw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2yp7hmacqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Mar 2020 20:38:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02BKW23j102813;
        Wed, 11 Mar 2020 20:38:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2ypv9w5yx1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Mar 2020 20:38:26 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02BKcPmL029226;
        Wed, 11 Mar 2020 20:38:26 GMT
Received: from localhost.localdomain (/10.159.253.243)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Mar 2020 13:38:25 -0700
Subject: Re: [PATCH] kvm-unit-test: nVMX: Test Selector and Base Address
 fields of Guest Segment Registers on vmentry of nested guests
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
References: <20200310225149.31254-1-krish.sadhukhan@oracle.com>
 <20200310225149.31254-2-krish.sadhukhan@oracle.com>
 <20200311150516.GB21852@linux.intel.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <0fb906f6-574f-2e2e-4113-e9d883cb713e@oracle.com>
Date:   Wed, 11 Mar 2020 13:38:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200311150516.GB21852@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003110114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003110114
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/11/20 8:05 AM, Sean Christopherson wrote:
> On Tue, Mar 10, 2020 at 06:51:49PM -0400, Krish Sadhukhan wrote:
>> According to section "Checks on Guest Segment Registers" in Intel SDM vol 3C,
>> the following checks are performed on the Guest Segment Registers on vmentry
>> of nested guests:
>>
>>      Selector fields:
>> 	— TR. The TI flag (bit 2) must be 0.
>> 	— LDTR. If LDTR is usable, the TI flag (bit 2) must be 0.
>> 	— SS. If the guest will not be virtual-8086 and the "unrestricted
>> 	  guest" VM-execution control is 0, the RPL (bits 1:0) must equal
>> 	  the RPL of the selector field for CS.1
>>
>>      Base-address fields:
>> 	— CS, SS, DS, ES, FS, GS. If the guest will be virtual-8086, the
>> 	  address must be the selector field shifted left 4 bits (multiplied
>> 	  by 16).
>> 	— The following checks are performed on processors that support Intel
>> 	  64 architecture:
>> 		TR, FS, GS. The address must be canonical.
>> 		LDTR. If LDTR is usable, the address must be canonical.
>> 		CS. Bits 63:32 of the address must be zero.
>> 		SS, DS, ES. If the register is usable, bits 63:32 of the
>> 		address must be zero.
>>
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> ---
>>   lib/x86/processor.h |   1 +
>>   x86/vmx_tests.c     | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 110 insertions(+)
>>
>> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
>> index 03fdf64..3642212 100644
>> --- a/lib/x86/processor.h
>> +++ b/lib/x86/processor.h
>> @@ -57,6 +57,7 @@
>>   #define X86_EFLAGS_OF    0x00000800
>>   #define X86_EFLAGS_IOPL  0x00003000
>>   #define X86_EFLAGS_NT    0x00004000
>> +#define X86_EFLAGS_VM    0x00020000
>>   #define X86_EFLAGS_AC    0x00040000
>>   
>>   #define X86_EFLAGS_ALU (X86_EFLAGS_CF | X86_EFLAGS_PF | X86_EFLAGS_AF | \
>> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>> index a7abd63..5e96dfa 100644
>> --- a/x86/vmx_tests.c
>> +++ b/x86/vmx_tests.c
>> @@ -7681,6 +7681,113 @@ static void test_load_guest_pat(void)
>>   	test_pat(GUEST_PAT, "GUEST_PAT", ENT_CONTROLS, ENT_LOAD_PAT);
>>   }
>>   
>> +#define	GUEST_SEG_USABLE_MASK	1u << 16
> s/USABLE/UNUSABLE
>
> The usage below looks correct, just the name is inverted.
>
>> +#define	TEST_SEGMENT_SEL(seg_sel, seg_sel_name, val, val_saved)		\
>> +	vmcs_write(seg_sel, val);					\
>> +	enter_guest_with_invalid_guest_state();				\
>> +	report_guest_state_test(seg_sel_name,			\
>> +				VMX_ENTRY_FAILURE |			\
>> +				VMX_FAIL_STATE,				\
>> +				val, seg_sel_name);			\
>> +	vmcs_write(seg_sel, val_saved);
>> +
>> +/*
>> + * The following checks are done on the Selector field of the Guest Segment
>> + * Registers:
>> + *    — TR. The TI flag (bit 2) must be 0.
>> + *    — LDTR. If LDTR is usable, the TI flag (bit 2) must be 0.
>> + *    — SS. If the guest will not be virtual-8086 and the "unrestricted
>> + *	guest" VM-execution control is 0, the RPL (bits 1:0) must equal
>> + *	the RPL of the selector field for CS.
>> + *
>> + *  [Intel SDM]
>> + */
>> +static void test_guest_segment_sel_fields(void)
>> +{
>> +	u16 sel_saved;
>> +	u16 sel;
>> +
>> +	sel_saved = vmcs_read(GUEST_SEL_TR);
>> +	sel = sel_saved | 0x4;
>> +	TEST_SEGMENT_SEL(GUEST_SEL_TR, "GUEST_SEL_TR", sel, sel_saved);
>> +
>> +	sel_saved = vmcs_read(GUEST_SEL_LDTR);
>> +	sel = sel_saved | 0x4;
>> +	TEST_SEGMENT_SEL(GUEST_SEL_LDTR, "GUEST_SEL_LDTR", sel, sel_saved);
>> +
>> +	if (!(vmcs_read(GUEST_RFLAGS) & X86_EFLAGS_VM) &&
>> +	    !(vmcs_read(CPU_SECONDARY) & CPU_URG)) {
> Rather than react to the environment, these tests should configure every
> relevant aspect and ignore the ones it can't change.  E.g. the unit tests
> aren't going to randomly launch a vm86 guest.  Ditto for the unusuable bit,
> it's unlikely to be set for most segments and would be something to test
> explicitly.


Just wanted to clarify on the "unusable bit" part of your comment. Do 
you mean each of the segment register checks from the SDM should have 
two tests, one with the "unusable bit" set and the other with that bit 
not set, irrespective of the checks being conditional on the setting of 
that bit ?

>
>> +		u16 cs_rpl_bits = vmcs_read(GUEST_SEL_CS) & 0x3;
>> +		sel_saved = vmcs_read(GUEST_SEL_SS);
>> +		sel = sel_saved | (~cs_rpl_bits & 0x3);
>> +		TEST_SEGMENT_SEL(GUEST_SEL_SS, "GUEST_SEL_SS", sel, sel_saved);
>> +	}
>> +}
>> +
>> +#define	TEST_SEGMENT_BASE_ADDR_UPPER_BITS(seg_base, seg_base_name)	\
>> +	addr_saved = vmcs_read(seg_base);				\
>> +	for (i = 32; i < 63; i = i + 4) {				\
>> +		addr = addr_saved | 1ull << i;				\
>> +		vmcs_write(seg_base, addr);				\
>> +		enter_guest_with_invalid_guest_state();			\
>> +		report_guest_state_test(seg_base_name,			\
>> +					VMX_ENTRY_FAILURE |		\
>> +					VMX_FAIL_STATE,			\
>> +					addr, seg_base_name);		\
>> +	}								\
>> +									\
>> +	vmcs_write(seg_base, addr_saved);
>> +
>> +#define	TEST_SEGMENT_BASE_ADDR_CANONICAL(seg_base, seg_base_name)	\
>> +	addr_saved = vmcs_read(seg_base);				\
>> +	vmcs_write(seg_base, NONCANONICAL);				\
>> +	enter_guest_with_invalid_guest_state();				\
>> +	report_guest_state_test(seg_base_name,				\
>> +				VMX_ENTRY_FAILURE | VMX_FAIL_STATE,	\
>> +				NONCANONICAL, seg_base_name);		\
>> +	vmcs_write(seg_base, addr_saved);
>> +
>> +/*
>> + * The following checks are done on the Base Address field of the Guest
>> + * Segment Registers on processors that support Intel 64 architecture:
>> + *    - TR, FS, GS : The address must be canonical.
>> + *    - LDTR : If LDTR is usable, the address must be canonical.
>> + *    - CS : Bits 63:32 of the address must be zero.
>> + *    - SS, DS, ES : If the register is usable, bits 63:32 of the address
>> + *	must be zero.
>> + *
>> + *  [Intel SDM]
>> + */
>> +static void test_guest_segment_base_addr_fields(void)
>> +{
>> +	u64 addr_saved, addr;
>> +	int i;
>> +
>> +	/*
>> +	 * The address of TR, FS, GS and LDTR must be canonical.
>> +	 */
>> +	TEST_SEGMENT_BASE_ADDR_CANONICAL(GUEST_BASE_TR, "GUEST_BASE_TR");
>> +	TEST_SEGMENT_BASE_ADDR_CANONICAL(GUEST_BASE_FS, "GUEST_BASE_FS");
>> +	TEST_SEGMENT_BASE_ADDR_CANONICAL(GUEST_BASE_GS, "GUEST_BASE_GS");
> FS/GS bases aren't checked if the segment is unusable.
>
>> +	if (!(vmcs_read(GUEST_AR_LDTR) & GUEST_SEG_USABLE_MASK))
>> +		TEST_SEGMENT_BASE_ADDR_CANONICAL(GUEST_BASE_LDTR,
>> +						"GUEST_BASE_LDTR");
>> +
>> +	/*
>> +	 * Bits 63:32 in CS, SS, DS and ES base address must be zero
>> +	 */
>> +	TEST_SEGMENT_BASE_ADDR_UPPER_BITS(GUEST_BASE_CS, "GUEST_BASE_CS");
>> +	if (!(vmcs_read(GUEST_AR_SS) & GUEST_SEG_USABLE_MASK))
>> +		TEST_SEGMENT_BASE_ADDR_UPPER_BITS(GUEST_BASE_SS,
>> +						 "GUEST_BASE_SS");
>> +	if (!(vmcs_read(GUEST_AR_DS) & GUEST_SEG_USABLE_MASK))
>> +		TEST_SEGMENT_BASE_ADDR_UPPER_BITS(GUEST_BASE_DS,
>> +						 "GUEST_BASE_DS");
>> +	if (!(vmcs_read(GUEST_AR_ES) & GUEST_SEG_USABLE_MASK))
>> +		TEST_SEGMENT_BASE_ADDR_UPPER_BITS(GUEST_BASE_ES,
>> +						 "GUEST_BASE_ES");
>> +}
>> +
>>   /*
>>    * Check that the virtual CPU checks the VMX Guest State Area as
>>    * documented in the Intel SDM.
>> @@ -7701,6 +7808,8 @@ static void vmx_guest_state_area_test(void)
>>   	test_load_guest_pat();
>>   	test_guest_efer();
>>   	test_load_guest_perf_global_ctrl();
>> +	test_guest_segment_sel_fields();
>> +	test_guest_segment_base_addr_fields();
>>   
>>   	/*
>>   	 * Let the guest finish execution
>> -- 
>> 1.8.3.1
>>
