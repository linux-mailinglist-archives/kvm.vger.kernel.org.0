Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5154C154BA8
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 20:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgBFTIl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 14:08:41 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44334 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727738AbgBFTIl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 14:08:41 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 016J8WpA172908;
        Thu, 6 Feb 2020 19:08:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=yansYJidJ2HRyuM/DKZHN3c8dM+VvdkGZN7ODN38+Bc=;
 b=NnOVue9i1GmzVur0C8YB31uthCY0qMvGVdbGkRGMtlhvH8I2FZetuvMJhwnUts9PaQYf
 8uPKLMOjp7XQciZKJJCYBjDBl085aJlitqMCaPvme0NGhOTL31s9oQ8D4z19RPlgolbZ
 ITirbPbus7AFFuER/QogvcOWKInGN+9lOglWqXDLd0ge6B1RylxLuK9QSfTd+PCS6sZ0
 98GK5zy4bcr6FDdcHQsEs93e5JXAfjYTMmCAlARfpK/BmHPI/vaFMHruEfH3aF9VTxfD
 Giua3WjIA46v5JMQVaR0jRdOdbNVR4XWY+LUFkXbkeszm3o2LVNzvoO/lYpfkOf+K7V2 GA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=yansYJidJ2HRyuM/DKZHN3c8dM+VvdkGZN7ODN38+Bc=;
 b=GDEa7pjC00TmLwoBuPhDKYUIrpHyz5eNq1KBKuQT7KOZPnDdsATODw+mszGtyfZeRR86
 1zjJXlCMP+ks7wUSqI0Lk83zd/o3bmHcsx8gwb9liK/6velPYWslcZ68izHj/OdMDQnR
 VJ/n+UTEY/EvWHoGzwb7BdxFHd4lvijEYlPp4Gca1Bm4vODNvW+jrRaAxs8YQaJVwNum
 kzKlOcC7khpOKxjHcgEkuPFfGZL9tyNFaDriP/Iv3jTuwRIRVD7VtfB7UGT6fmS4chmv
 sRVu9BGBOzzg6led5NUcrDLK0a6mh6gbWP4C/ZS1ohFgSyQVfJWunqn2xr9vmd8yaYgs /Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xykbpksa6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Feb 2020 19:08:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 016J8Pmf088015;
        Thu, 6 Feb 2020 19:08:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2y0mnk9qbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Feb 2020 19:08:31 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 016J8UIY015928;
        Thu, 6 Feb 2020 19:08:30 GMT
Received: from localhost.localdomain (/10.159.247.143)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Feb 2020 11:08:30 -0800
Subject: Re: [PATCH v4 3/3] selftests: KVM: SVM: Add vmcall test
To:     Wei Huang <wei.huang2@amd.com>, Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com,
        thuth@redhat.com, drjones@redhat.com
References: <20200206104710.16077-1-eric.auger@redhat.com>
 <20200206104710.16077-4-eric.auger@redhat.com>
 <20200206173931.GC2465308@weiserver.amd.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <556d20b2-d6cf-e13c-635c-809836316b80@oracle.com>
Date:   Thu, 6 Feb 2020 11:08:28 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200206173931.GC2465308@weiserver.amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9523 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002060140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9523 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002060140
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/6/20 9:39 AM, Wei Huang wrote:
> On 02/06 11:47, Eric Auger wrote:
>> L2 guest calls vmcall and L1 checks the exit status does
>> correspond.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
> I verified this patch with my AMD box, both with nested=1 and nested=0. I
> also intentionally changed the assertion of exit_code to a different
> value (0x082) and the test complained about it. So the test is good.
>
> # selftests: kvm: svm_vmcall_test
> # ==== Test Assertion Failure ====
> #   x86_64/svm_vmcall_test.c:64: false
> #   pid=2485656 tid=2485656 - Interrupted system call
> #      1        0x0000000000401387: main at svm_vmcall_test.c:72
> #      2        0x00007fd0978d71a2: ?? ??:0
> #      3        0x00000000004013ed: _start at ??:?
> #   Failed guest assert: vmcb->control.exit_code == SVM_EXIT_VMMCALL
> # Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
> # Guest physical address width detected: 48
> not ok 15 selftests: kvm: svm_vmcall_test # exit=254
>
>> ---
>>
>> v3 -> v4:
>> - remove useless includes
>> - collected Lin's R-b
>>
>> v2 -> v3:
>> - remove useless comment and add Vitaly's R-b
>> ---
>>   tools/testing/selftests/kvm/Makefile          |  1 +
>>   .../selftests/kvm/x86_64/svm_vmcall_test.c    | 79 +++++++++++++++++++
>>   2 files changed, 80 insertions(+)
>>   create mode 100644 tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
>>
>> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
>> index 2e770f554cae..b529d3b42c02 100644
>> --- a/tools/testing/selftests/kvm/Makefile
>> +++ b/tools/testing/selftests/kvm/Makefile
>> @@ -26,6 +26,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_dirty_log_test
>>   TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
>>   TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
>>   TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
>> +TEST_GEN_PROGS_x86_64 += x86_64/svm_vmcall_test
>>   TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
>>   TEST_GEN_PROGS_x86_64 += dirty_log_test
>>   TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
>> diff --git a/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c b/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
>> new file mode 100644
>> index 000000000000..6d3565aab94e
>> --- /dev/null
>> +++ b/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
> Probably rename the file to svm_nested_vmcall_test.c. This matches with
> the naming convention of VMX's nested tests. Otherwise people might not know
> it is a nested one.

Is it better to give this file a generic name, say, nsvm_tests or 
something like that, and place all future nested SVM tests in it, rather 
than creating a separate file for each nested test ?
>
> Everything else looks good.
>
>> @@ -0,0 +1,79 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * svm_vmcall_test
>> + *
>> + * Copyright (C) 2020, Red Hat, Inc.
>> + *
>> + * Nested SVM testing: VMCALL
>> + */
>> +
>> +#include "test_util.h"
>> +#include "kvm_util.h"
>> +#include "processor.h"
>> +#include "svm_util.h"
>> +
>> +#define VCPU_ID		5
>> +
>> +static struct kvm_vm *vm;
>> +
>> +static inline void l2_vmcall(struct svm_test_data *svm)
>> +{
>> +	__asm__ __volatile__("vmcall");
>> +}
>> +
>> +static void l1_guest_code(struct svm_test_data *svm)
>> +{
>> +	#define L2_GUEST_STACK_SIZE 64
>> +	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
>> +	struct vmcb *vmcb = svm->vmcb;
>> +
>> +	/* Prepare for L2 execution. */
>> +	generic_svm_setup(svm, l2_vmcall,
>> +			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
>> +
>> +	run_guest(vmcb, svm->vmcb_gpa);
>> +
>> +	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
>> +	GUEST_DONE();
>> +}
>> +
>> +int main(int argc, char *argv[])
>> +{
>> +	vm_vaddr_t svm_gva;
>> +
>> +	nested_svm_check_supported();
>> +
>> +	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
>> +	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
>> +
>> +	vcpu_alloc_svm(vm, &svm_gva);
>> +	vcpu_args_set(vm, VCPU_ID, 1, svm_gva);
>> +
>> +	for (;;) {
>> +		volatile struct kvm_run *run = vcpu_state(vm, VCPU_ID);
>> +		struct ucall uc;
>> +
>> +		vcpu_run(vm, VCPU_ID);
>> +		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
>> +			    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
>> +			    run->exit_reason,
>> +			    exit_reason_str(run->exit_reason));
>> +
>> +		switch (get_ucall(vm, VCPU_ID, &uc)) {
>> +		case UCALL_ABORT:
>> +			TEST_ASSERT(false, "%s",
>> +				    (const char *)uc.args[0]);
>> +			/* NOT REACHED */
>> +		case UCALL_SYNC:
>> +			break;
>> +		case UCALL_DONE:
>> +			goto done;
>> +		default:
>> +			TEST_ASSERT(false,
>> +				    "Unknown ucall 0x%x.", uc.cmd);
>> +		}
>> +	}
>> +done:
>> +	kvm_vm_free(vm);
>> +	return 0;
>> +}
>
