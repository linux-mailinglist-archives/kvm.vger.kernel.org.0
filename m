Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0DD6B40C8
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2019 21:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733132AbfIPTGP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Sep 2019 15:06:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50730 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727958AbfIPTGP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Sep 2019 15:06:15 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8GJ45wD123863;
        Mon, 16 Sep 2019 19:06:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=4fG8fcd0PBfnCxHre1EAgomHjZyiXi4bjvsMomWorYI=;
 b=oo7YmVVOfr2FB+JwK5i8ZJu83RNOw3S3KOFe2D/Ua3JGTa84eRxF6LWu4aIjl+AaTASR
 xmLfNe3yDEFCzK/lzmkmyongJ1436I7ylafudGym8UneNhC6y/aOnx5aiQPW+htwFEJH
 hSpAvcqFNjeU1WaHVVMQuMOReQIRzVn+YlVsYkJfkpT+xE+XPwa1suLNdZXY1dZz0ZRj
 2YZQuLZIzlkQxIMFwRCfLGPYE+pqEBb2WvKScYJDdSHtqFayy3XOjgy3O3lB0MtKedwJ
 nl2KXbP8ak2pNaqCztUwWQ2XDGTTF38hg/X9T1kxzL9Z0+A9KfOqVsHBFCmvUT3YkDKn 6A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2v2bx2sqxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Sep 2019 19:06:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8GIx6Po014882;
        Mon, 16 Sep 2019 19:06:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2v0nb578jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Sep 2019 19:06:10 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8GJ68Wn011017;
        Mon, 16 Sep 2019 19:06:09 GMT
Received: from dhcp-10-132-91-76.usdhcp.oraclecorp.com (/10.132.91.76)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Sep 2019 12:06:08 -0700
Subject: Re: [kvm-unit-tests PATCH v2] x86: nvmx: test max atomic switch MSRs
To:     Marc Orr <marcorr@google.com>, kvm@vger.kernel.org,
        jmattson@google.com, pshier@google.com,
        sean.j.christopherson@intel.com
References: <20190914004919.256530-1-marcorr@google.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <6537afdb-2e0e-0933-3f7d-2a474378edf5@oracle.com>
Date:   Mon, 16 Sep 2019 12:06:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190914004919.256530-1-marcorr@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9382 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=11 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909160185
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9382 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=11 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909160186
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 09/13/2019 05:49 PM, Marc Orr wrote:
> Excerise nested VMX's atomic MSR switch code (e.g., VM-entry MSR-load
> list) at the maximum number of MSRs supported, as described in the SDM,
> in the appendix chapter titled "MISCELLANEOUS DATA".
>
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Marc Orr <marcorr@google.com>
> ---
> v1 -> v2
> * Replaced 2M page allocations with 128 kB allocations.
> * Broadly, updated test to follow Sean's draft:
>    * Got rid of loop + individual test cases. Instead combined all test cases.
>    * Got rid of configure_atomic_switch_msr_limit_test().
> * Updated cleanup code to free memory. I added a new helper,
>    free_pages_by_order() to help here.
> * Changed virt_to_phys() to explicit u64 cast.
> * Renamed original test case from atomic_switch_msr_limit_test() to
>    atomic_switch_max_msrs_test(). Added opt-in
>    atomic_switch_overflow_msrs_test() test case to test failure code path
>    during VM-entry.
> * Fixed a bug in transitioning VMX launched state when the first
>    VM-entry fails.

Can we move this bug-fix to a separate patch so that it can be 
identified easily when searching in git history ?


>
>   lib/alloc_page.c  |   5 ++
>   lib/alloc_page.h  |   1 +
>   x86/unittests.cfg |   2 +-
>   x86/vmx.c         |   2 +-
>   x86/vmx_tests.c   | 131 ++++++++++++++++++++++++++++++++++++++++++++++
>   5 files changed, 139 insertions(+), 2 deletions(-)
>
> diff --git a/lib/alloc_page.c b/lib/alloc_page.c
> index 97d13395ff08..ed236389537e 100644
> --- a/lib/alloc_page.c
> +++ b/lib/alloc_page.c
> @@ -53,6 +53,11 @@ void free_pages(void *mem, unsigned long size)
>   	spin_unlock(&lock);
>   }
>   
> +void free_pages_by_order(void *mem, unsigned long order)
> +{
> +	free_pages(mem, 1ul << (order + PAGE_SHIFT));
> +}
> +
>   void *alloc_page()
>   {
>   	void *p;
> diff --git a/lib/alloc_page.h b/lib/alloc_page.h
> index 5cdfec57a0a8..739a91def979 100644
> --- a/lib/alloc_page.h
> +++ b/lib/alloc_page.h
> @@ -14,5 +14,6 @@ void *alloc_page(void);
>   void *alloc_pages(unsigned long order);
>   void free_page(void *page);
>   void free_pages(void *mem, unsigned long size);
> +void free_pages_by_order(void *mem, unsigned long order);
>   
>   #endif
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 694ee3d42f3a..05122cf91ea1 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -227,7 +227,7 @@ extra_params = -cpu qemu64,+umip
>   
>   [vmx]
>   file = vmx.flat
> -extra_params = -cpu host,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test"
> +extra_params = -cpu host,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test"
>   arch = x86_64
>   groups = vmx
>   
> diff --git a/x86/vmx.c b/x86/vmx.c
> index 6079420db33a..7313c78f15c2 100644
> --- a/x86/vmx.c
> +++ b/x86/vmx.c
> @@ -1820,7 +1820,7 @@ static void __enter_guest(u8 abort_flag, struct vmentry_failure *failure)
>   		abort();
>   	}
>   
> -	if (!failure->early) {
> +	if (!failure->early && !(vmcs_read(EXI_REASON) & VMX_ENTRY_FAILURE)) {
>   		launched = 1;
>   		check_for_guest_termination();
>   	}
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index f035f24a771a..fb665f38b1e5 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -8570,6 +8570,134 @@ static int invalid_msr_entry_failure(struct vmentry_failure *failure)
>   	return VMX_TEST_VMEXIT;
>   }
>   
> +/*
> + * The max number of MSRs in an atomic switch MSR list is:
> + * (111B + 1) * 512 = 4096
> + *
> + * Each list entry consumes:
> + * 4-byte MSR index + 4 bytes reserved + 8-byte data = 16 bytes
> + *
> + * Allocate 128 kB to cover max_msr_list_size (i.e., 64 kB) and then some.
> + */
> +static const u32 msr_list_page_order = 5;
> +
> +static void atomic_switch_msr_limit_test_guest(void)
> +{
> +	vmcall();
> +}
> +
> +static void populate_msr_list(struct vmx_msr_entry *msr_list,
> +			      size_t byte_capacity, int count)
> +{
> +	int i;
> +
> +	for (i = 0; i < count; i++) {
> +		msr_list[i].index = MSR_IA32_TSC;
> +		msr_list[i].reserved = 0;
> +		msr_list[i].value = 0x1234567890abcdef;
> +	}
> +
> +	memset(msr_list + count, 0xff,
> +	       byte_capacity - count * sizeof(*msr_list));
> +}
> +
> +static int max_msr_list_size(void)
> +{
> +	u32 vmx_misc = rdmsr(MSR_IA32_VMX_MISC);
> +	u32 factor = ((vmx_misc & GENMASK(27, 25)) >> 25) + 1;
> +
> +	return factor * 512;
> +}
> +
> +static void atomic_switch_msrs_test(int count)
> +{
> +	struct vmx_msr_entry *vm_enter_load;
> +        struct vmx_msr_entry *vm_exit_load;
> +        struct vmx_msr_entry *vm_exit_store;
> +	int max_allowed = max_msr_list_size();
> +	int byte_capacity = 1ul << (msr_list_page_order + PAGE_SHIFT);
> +	/* Exceeding the max MSR list size at exit trigers KVM to abort. */
> +	int exit_count = count > max_allowed ? max_allowed : count;
> +	int cleanup_count = count > max_allowed ? 2 : 1;
> +	int i;
> +
> +	/*
> +	 * Check for the IA32_TSC MSR,
> +	 * available with the "TSC flag" and used to populate the MSR lists.
> +	 */
> +	if (!(cpuid(1).d & (1 << 4))) {
> +		report_skip(__func__);
> +		return;
> +	}
> +
> +	/* Set L2 guest. */
> +	test_set_guest(atomic_switch_msr_limit_test_guest);
> +
> +	/* Setup atomic MSR switch lists. */
> +	vm_enter_load = alloc_pages(msr_list_page_order);
> +	vm_exit_load = alloc_pages(msr_list_page_order);
> +	vm_exit_store = alloc_pages(msr_list_page_order);
> +
> +	vmcs_write(ENTER_MSR_LD_ADDR, (u64)vm_enter_load);
> +	vmcs_write(EXIT_MSR_LD_ADDR, (u64)vm_exit_load);
> +	vmcs_write(EXIT_MSR_ST_ADDR, (u64)vm_exit_store);
> +
> +	/*
> +	 * VM-Enter should succeed up to the max number of MSRs per list, and
> +	 * should not consume junk beyond the last entry.
> +	 */
> +	populate_msr_list(vm_enter_load, byte_capacity, count);
> +	populate_msr_list(vm_exit_load, byte_capacity, exit_count);
> +	populate_msr_list(vm_exit_store, byte_capacity, exit_count);
> +
> +	vmcs_write(ENT_MSR_LD_CNT, count);
> +	vmcs_write(EXI_MSR_LD_CNT, exit_count);
> +	vmcs_write(EXI_MSR_ST_CNT, exit_count);
> +
> +	if (count <= max_allowed) {
> +		enter_guest();
> +		assert_exit_reason(VMX_VMCALL);
> +		skip_exit_vmcall();
> +	} else {
> +		u32 exit_reason;
> +		u32 exit_reason_want;
> +		u32 exit_qual;
> +
> +		enter_guest_with_invalid_guest_state();
> +
> +		exit_reason = vmcs_read(EXI_REASON);
> +		exit_reason_want = VMX_FAIL_MSR | VMX_ENTRY_FAILURE;
> +		report("exit_reason, %u, is %u.",
> +		       exit_reason == exit_reason_want, exit_reason,
> +		       exit_reason_want);
> +
> +		exit_qual = vmcs_read(EXI_QUALIFICATION);
> +		report("exit_qual, %u, is %u.", exit_qual == max_allowed + 1,
> +		       exit_qual, max_allowed + 1);
> +	}
> +
> +	/* Cleanup. */
> +	vmcs_write(ENT_MSR_LD_CNT, 0);
> +	vmcs_write(EXI_MSR_LD_CNT, 0);
> +	vmcs_write(EXI_MSR_ST_CNT, 0);
> +	for (i = 0; i < cleanup_count; i++) {
> +		enter_guest();
> +		skip_exit_vmcall();
> +	}
> +	free_pages_by_order(vm_enter_load, msr_list_page_order);
> +	free_pages_by_order(vm_exit_load, msr_list_page_order);
> +	free_pages_by_order(vm_exit_store, msr_list_page_order);
> +}
> +
> +static void atomic_switch_max_msrs_test(void)
> +{
> +	atomic_switch_msrs_test(max_msr_list_size());
> +}
> +
> +static void atomic_switch_overflow_msrs_test(void)
> +{
> +	atomic_switch_msrs_test(max_msr_list_size() + 1);
> +}
>   
>   #define TEST(name) { #name, .v2 = name }
>   
> @@ -8660,5 +8788,8 @@ struct vmx_test vmx_tests[] = {
>   	TEST(ept_access_test_paddr_read_execute_ad_enabled),
>   	TEST(ept_access_test_paddr_not_present_page_fault),
>   	TEST(ept_access_test_force_2m_page),
> +	/* Atomic MSR switch tests. */
> +	TEST(atomic_switch_max_msrs_test),
> +	TEST(atomic_switch_overflow_msrs_test),
>   	{ NULL, NULL, NULL, NULL, NULL, {0} },
>   };

