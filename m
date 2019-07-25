Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2CC775AC6
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2019 00:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbfGYWdC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 18:33:02 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53126 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbfGYWdC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jul 2019 18:33:02 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PMSeeZ075166;
        Thu, 25 Jul 2019 22:32:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=dFvqAyTiLtFatjagqKkP6ISWON3XWwVO+WhSHnoVIRU=;
 b=48Vo597p6rCmHuc8s3FH7Oeuc7TcccFNKExV7mtUOVHeDYOrs+eW3zKyYYBQK65eda5R
 LUG5qtqjvcEH7FeP59oVsJZNaR99P9xe6oobUXKT0niGbkLUfgJZDK78Iak0hG348tZr
 2Zp8VBHDi5HWDfqXin/AR/IrRjuPmnXvlqDIYd3Tz15T+xbH/Xv+Vq7J0yaDfHiUKWP7
 Wdcb0aAX35fbne2n9q9Wtx1NUShXIfsLZ/9zLI4FZ4LMvVJDZ4bCFdNYzXA018tH08m8
 V9ryvB7eUWDW2I/izIaByh3HTQbdjKQfxW3B9Lp7dcwke2aPU4QvAdyDIHwHBcQ8Ospa dg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2tx61c6uad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 22:32:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PMRdlK106882;
        Thu, 25 Jul 2019 22:32:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2tx60y30e5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 22:32:41 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6PMWe6a004656;
        Thu, 25 Jul 2019 22:32:40 GMT
Received: from dhcp-10-132-91-225.usdhcp.oraclecorp.com (/10.132.91.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jul 2019 15:32:39 -0700
Subject: Re: [PATCH 2/2 v2]kvm-unit-test: nVMX: Test Host Segment Registers
 and Descriptor Tables on vmentry of nested guests
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, rkrcmar@redhat.com, pbonzini@redhat.com,
        jmattson@google.com
References: <20190703235437.13429-1-krish.sadhukhan@oracle.com>
 <20190703235437.13429-3-krish.sadhukhan@oracle.com>
 <20190724161247.GB25376@linux.intel.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <d157a449-c31d-a7e1-b855-60541aad8501@oracle.com>
Date:   Thu, 25 Jul 2019 15:32:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190724161247.GB25376@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9329 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907250268
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9329 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907250268
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 07/24/2019 09:12 AM, Sean Christopherson wrote:
> On Wed, Jul 03, 2019 at 07:54:36PM -0400, Krish Sadhukhan wrote:
>> According to section "Checks on Host Segment and Descriptor-Table
>> Registers" in Intel SDM vol 3C, the following checks are performed on
>> vmentry of nested guests:
>>
>>      - In the selector field for each of CS, SS, DS, ES, FS, GS and TR, the
>>        RPL (bits 1:0) and the TI flag (bit 2) must be 0.
>>      - The selector fields for CS and TR cannot be 0000H.
>>      - The selector field for SS cannot be 0000H if the "host address-space
>>        size" VM-exit control is 0.
>>      - On processors that support Intel 64 architecture, the base-address
>>        fields for FS, GS, GDTR, IDTR, and TR must contain canonical
>>        addresses.
>>
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
>> ---
>>   lib/x86/processor.h |   5 ++
>>   x86/vmx_tests.c     | 159 ++++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 164 insertions(+)
>>
>> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
>> index 4fef0bc..8b8bb7a 100644
>> --- a/lib/x86/processor.h
>> +++ b/lib/x86/processor.h
>> @@ -461,6 +461,11 @@ static inline void write_pkru(u32 pkru)
>>           : : "a" (eax), "c" (ecx), "d" (edx));
>>   }
>>   
>> +static inline u64 make_non_canonical(u64 addr)
>> +{
>> +	return (addr | 1ull << 48);
> This isn't guaranteed to work.  It assumes a 48-bit address space and
> also assumes addr is in the lower half of the address space.  In fact, I'm
> feeling a bit of deja vu...
>
> https://patchwork.kernel.org/patch/10798645/#22464371

Yes, I should have used NONCANONICAL instead of creating a new 
function.  My bad !  Will fix it.

>
>> +}
>> +
>>   static inline bool is_canonical(u64 addr)
>>   {
>>   	return (s64)(addr << 16) >> 16 == addr;
>> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>> index b50d858..5911a60 100644
>> --- a/x86/vmx_tests.c
>> +++ b/x86/vmx_tests.c
>> @@ -6938,6 +6938,163 @@ static void test_load_host_pat(void)
>>   	test_pat(HOST_PAT, "HOST_PAT", EXI_CONTROLS, EXI_LOAD_PAT);
>>   }
>>   
>> +/*
>> + * Test a value for the given VMCS field.
>> + *
>> + *  "field" - VMCS field
>> + *  "field_name" - string name of VMCS field
>> + *  "bit_start" - starting bit
>> + *  "bit_end" - ending bit
>> + *  "val" - value that the bit range must or must not contain
>> + *  "valid_val" - whether value given in 'val' must be valid or not
>> + *  "error" - expected VMCS error when vmentry fails for an invalid value
> Comments are great, but they should use kernel-doc style.

Will fix it.

>
>> + */
>> +static void test_vmcs_field(u64 field, const char *field_name, u32 bit_start,
>> +			    u32 bit_end, u64 val, bool valid_val, u32 error)
>> +{
>> +	u64 field_saved = vmcs_read(field);
>> +	u32 i;
>> +	u64 tmp;
>> +	u32 bit_on;
>> +	u64 mask = ~0ull;
>> +
>> +	mask = (mask >> bit_end) << bit_end;
>> +	mask = mask | ((1 << bit_start) - 1);
>> +	tmp = (field_saved & mask) | (val << bit_start);
>> +
>> +	vmcs_write(field, tmp);
>> +	report_prefix_pushf("%s %lx", field_name, tmp);
>> +	if (valid_val)
>> +		test_vmx_vmlaunch(0, false);
>> +	else
>> +		test_vmx_vmlaunch(error, false);
>> +	report_prefix_pop();
>> +
>> +	for (i = bit_start; i <= bit_end; i = i + 2) {
>> +		bit_on = ((1ull < i) & (val << bit_start)) ? 0 : 1;
>> +		if (bit_on)
>> +			tmp = field_saved | (1ull << i);
>> +		else
>> +			tmp = field_saved & ~(1ull << i);
>> +		vmcs_write(field, tmp);
>> +		report_prefix_pushf("%s %lx", field_name, tmp);
>> +		if (valid_val)
>> +			test_vmx_vmlaunch(error, false);
>> +		else
>> +			test_vmx_vmlaunch(0, false);
>> +		report_prefix_pop();
>> +	}
>> +
>> +	vmcs_write(field, field_saved);
>> +}
>> +
>> +static void test_canonical(u64 field, const char * field_name)
>> +{
>> +	u64 addr_saved = vmcs_read(field);
>> +	u64 addr = addr_saved;
>> +
>> +	report_prefix_pushf("%s %lx", field_name, addr);
>> +	if (is_canonical(addr)) {
>> +		test_vmx_vmlaunch(0, false);
>> +		report_prefix_pop();
>> +
>> +		addr = make_non_canonical(addr);
>> +		vmcs_write(field, addr);
>> +		report_prefix_pushf("%s %lx", field_name, addr);
>> +		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
>> +				  false);
>> +
>> +		vmcs_write(field, addr_saved);
>> +	} else {
>> +		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
>> +				  false);
>> +	}
>> +	report_prefix_pop();
>> +}
>> +
>> +/*
>> + * 1. In the selector field for each of CS, SS, DS, ES, FS, GS and TR, the
>> + *    RPL (bits 1:0) and the TI flag (bit 2) must be 0.
>> + * 2. The selector fields for CS and TR cannot be 0000H.
>> + * 3. The selector field for SS cannot be 0000H if the "host address-space
>> + *    size" VM-exit control is 0.
>> + * 4. On processors that support Intel 64 architecture, the base-address
>> + *    fields for FS, GS and TR must contain canonical addresses.
>> + */
>> +static void test_host_segment_regs(void)
>> +{
>> +	u32 exit_ctrl_saved = vmcs_read(EXI_CONTROLS);
>> +	u16 selector_saved;
>> +
>> +	/*
>> +	 * Test RPL and TI flags
>> +	 */
>> +	test_vmcs_field(HOST_SEL_CS, "HOST_SEL_CS", 0, 2, 0x0, true,
>> +		     VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
>> +	test_vmcs_field(HOST_SEL_SS, "HOST_SEL_SS", 0, 2, 0x0, true,
>> +		     VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
>> +	test_vmcs_field(HOST_SEL_DS, "HOST_SEL_DS", 0, 2, 0x0, true,
>> +		     VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
>> +	test_vmcs_field(HOST_SEL_ES, "HOST_SEL_ES", 0, 2, 0x0, true,
>> +		     VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
>> +	test_vmcs_field(HOST_SEL_FS, "HOST_SEL_FS", 0, 2, 0x0, true,
>> +		     VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
>> +	test_vmcs_field(HOST_SEL_GS, "HOST_SEL_GS", 0, 2, 0x0, true,
>> +		     VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
>> +	test_vmcs_field(HOST_SEL_TR, "HOST_SEL_TR", 0, 2, 0x0, true,
>> +		     VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
> A few layered helpers would reduce the boilerplate code by a substantial
> amount.
>
>> +
>> +	/*
>> +	 * Test that CS and TR fields can not be 0x0000
>> +	 */
>> +	test_vmcs_field(HOST_SEL_CS, "HOST_SEL_CS", 3, 15, 0x0000, false,
>> +			     VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
>> +	test_vmcs_field(HOST_SEL_TR, "HOST_SEL_TR", 3, 15, 0x0000, false,
>> +			     VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
>> +
>> +	/*
>> +	 * SS field can not be 0x0000 if "host address-space size" VM-exit
>> +	 * control is 0
>> +	 */
> As Nadav pointed out, this test is broken as a 64-bit host must configure
> VM-Exit to return to 64-bit mode.

That means any vmentry rule that requires setting "host address space 
size" VM-exit control to zero, can not be really tested !   I will 
remove this test then.

As an aside,  I am curious to know why the hardware threw "invalid 
VMX-control" error on bare-metal.  My idea was that since the hardware 
checks VMX controls before Host State and since bit# 9 in VMX 
Exit-control is unset, we are seeing "invalid VMX-control" error instead 
of "invalid Host State" error.

>
>> +	selector_saved = vmcs_read(HOST_SEL_SS);
>> +	vmcs_write(HOST_SEL_SS, 0);
>> +	if (exit_ctrl_saved & EXI_HOST_64) {
>> +		report_prefix_pushf("HOST_SEL_SS 0");
>> +		test_vmx_vmlaunch(0, false);
>> +		report_prefix_pop();
>> +
>> +		vmcs_write(EXI_CONTROLS, exit_ctrl_saved & ~EXI_HOST_64);
>> +	}
>> +
>> +	report_prefix_pushf("HOST_SEL_SS 0");
>> +	test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD, false);
>> +	report_prefix_pop();
>> +
>> +	vmcs_write(HOST_SEL_SS, selector_saved);
>> +	vmcs_write(EXI_CONTROLS, exit_ctrl_saved);
>> +
>> +#ifdef __x86_64__
> Unnecessary, the VMX tests are 64-bit only.  Adding 32-bit support would
> require a massive rewrite, i.e. this would be the least of our problems.

We also have the following in the vmx test:

#ifdef __x86_64__
extern void insn_cr8_load(void);
extern void insn_cr8_store(void);
#endif


Is this unnecessary also ?

>
>> +	/*
>> +	 * Base address for FS, GS and TR must be canonical
>> +	 */
>> +	test_canonical(HOST_BASE_FS, "HOST_BASE_FS");
>> +	test_canonical(HOST_BASE_GS, "HOST_BASE_GS");
>> +	test_canonical(HOST_BASE_TR, "HOST_BASE_TR");
>> +#endif
>> +}
>> +
>> +/*
>> + *  On processors that support Intel 64 architecture, the base-address
>> + *  fields for GDTR and IDTR must contain canonical addresses.
>> + */
>> +static void test_host_desc_tables(void)
>> +{
>> +#ifdef __x86_64__
>> +	test_canonical(HOST_BASE_GDTR, "HOST_BASE_GDTR");
>> +	test_canonical(HOST_BASE_IDTR, "HOST_BASE_IDTR");
>> +#endif
>> +}
>> +
>>   /*
>>    * Check that the virtual CPU checks the VMX Host State Area as
>>    * documented in the Intel SDM.
>> @@ -6958,6 +7115,8 @@ static void vmx_host_state_area_test(void)
>>   
>>   	test_host_efer();
>>   	test_load_host_pat();
>> +	test_host_segment_regs();
>> +	test_host_desc_tables();
>>   }
>>   
>>   /*
>> -- 
>> 2.20.1
>>

