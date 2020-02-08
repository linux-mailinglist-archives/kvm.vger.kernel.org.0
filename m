Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 722B0156236
	for <lists+kvm@lfdr.de>; Sat,  8 Feb 2020 02:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbgBHBI5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 20:08:57 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53894 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbgBHBI4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 20:08:56 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 018139W8154955;
        Sat, 8 Feb 2020 01:08:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=f7fIdOObg23mWVaXcZqK1lzGiwBV33qcnN14591AwTU=;
 b=NbIIoH/yXa21ulCDnZbw8Q4DIpGkvZMmfVFVPaW3TFDTjQ8uakL7mQauaQ3LY7Fh80fj
 kqax9LeQkuVK9U5MHqs1Q2RdckSudXXmxlfYhJTaeqaQZA3RPXLoI24FN4wZS+XfPhs+
 3BvtKW8+ca43PCTS3wujaWOUIbLHJ+xef28bxal/l+TDWiKAugO/qVspYt9ppmD2oAxA
 pdtvtOJWdF28Pc/Vw+hvD5FmvfHBPEOn+Q1KEY4vsMUfWGDZlIkkXHGkeYcbnXCu8gUf
 njcFZzBoIbdY+sXKHig0IelHSHlG25GigaLOAJW78KyJ6paTb+dqMGsxt0MH6adHWdyC UQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xykbpk39q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 08 Feb 2020 01:08:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 01813jXn157852;
        Sat, 8 Feb 2020 01:08:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2y1j56yp9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 08 Feb 2020 01:08:49 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01818nZp030054;
        Sat, 8 Feb 2020 01:08:49 GMT
Received: from localhost.localdomain (/10.159.239.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 07 Feb 2020 17:08:49 -0800
Subject: Re: [PATCH v5 4/4] selftests: KVM: SVM: Add vmcall test
To:     Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com
Cc:     thuth@redhat.com, drjones@redhat.com, wei.huang2@amd.com
References: <20200207142715.6166-1-eric.auger@redhat.com>
 <20200207142715.6166-5-eric.auger@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <5d81a669-bb2e-fe06-ae51-9843ad91d5f0@oracle.com>
Date:   Fri, 7 Feb 2020 17:08:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200207142715.6166-5-eric.auger@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9524 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002080006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9524 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002080006
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/7/20 6:27 AM, Eric Auger wrote:
> L2 guest calls vmcall and L1 checks the exit status does
> correspond.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
>
> ---
>
> v4 -> v5:
> - rename l2_vmcall into l2_guest_code
>
> v3 -> v4:
> - remove useless includes
> - collected Lin's R-b
>
> v2 -> v3:
> - remove useless comment and add Vitaly's R-b
> ---
>   tools/testing/selftests/kvm/Makefile          |  1 +
>   .../selftests/kvm/x86_64/svm_vmcall_test.c    | 79 +++++++++++++++++++
>   2 files changed, 80 insertions(+)
>   create mode 100644 tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
>
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index fb2fa62d7dd5..d91c53b726e6 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -26,6 +26,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_dirty_log_test
>   TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
>   TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
>   TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
> +TEST_GEN_PROGS_x86_64 += x86_64/svm_vmcall_test
>   TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
>   TEST_GEN_PROGS_x86_64 += dirty_log_test
>   TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
> diff --git a/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c b/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
> new file mode 100644
> index 000000000000..d74ab0cc06d0
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
> @@ -0,0 +1,79 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * svm_vmcall_test
> + *
> + * Copyright (C) 2020, Red Hat, Inc.
> + *
> + * Nested SVM testing: VMCALL
> + */
> +
> +#include "test_util.h"
> +#include "kvm_util.h"
> +#include "processor.h"
> +#include "svm_util.h"
> +
> +#define VCPU_ID		5
> +
> +static struct kvm_vm *vm;
> +
> +static inline void l2_guest_code(struct svm_test_data *svm)
> +{
> +	__asm__ __volatile__("vmcall");
> +}
> +
> +static void l1_guest_code(struct svm_test_data *svm)
> +{
> +	#define L2_GUEST_STACK_SIZE 64
> +	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
> +	struct vmcb *vmcb = svm->vmcb;
> +
> +	/* Prepare for L2 execution. */
> +	generic_svm_setup(svm, l2_guest_code,
> +			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
> +
> +	run_guest(vmcb, svm->vmcb_gpa);
> +
> +	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
> +	GUEST_DONE();
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	vm_vaddr_t svm_gva;
> +
> +	nested_svm_check_supported();
> +
> +	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
> +	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
> +
> +	vcpu_alloc_svm(vm, &svm_gva);
> +	vcpu_args_set(vm, VCPU_ID, 1, svm_gva);
> +
> +	for (;;) {
> +		volatile struct kvm_run *run = vcpu_state(vm, VCPU_ID);
> +		struct ucall uc;
> +
> +		vcpu_run(vm, VCPU_ID);
> +		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
> +			    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
> +			    run->exit_reason,
> +			    exit_reason_str(run->exit_reason));
> +
> +		switch (get_ucall(vm, VCPU_ID, &uc)) {
> +		case UCALL_ABORT:
> +			TEST_ASSERT(false, "%s",
> +				    (const char *)uc.args[0]);
> +			/* NOT REACHED */
> +		case UCALL_SYNC:
> +			break;
> +		case UCALL_DONE:
> +			goto done;
> +		default:
> +			TEST_ASSERT(false,
> +				    "Unknown ucall 0x%x.", uc.cmd);
> +		}
> +	}
> +done:
> +	kvm_vm_free(vm);
> +	return 0;
> +}
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
