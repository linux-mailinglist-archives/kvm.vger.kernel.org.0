Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 104EF5511AB
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 09:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239320AbiFTHkR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 03:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237615AbiFTHkP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 03:40:15 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FDAFF5AC;
        Mon, 20 Jun 2022 00:40:13 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25K4lEg7017264;
        Mon, 20 Jun 2022 07:39:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7cqLTU9P1Ro0Wdde+r9wJ+UtamNnbvbI+jmvk75qn34=;
 b=mjkUx6YN1YPZsmrPM/nAmw0GbmTV0oB/xGVwbdIuWE9YvF7d8Lk+u+IyJHKDT5CiHd2v
 cy2pNOJbqMb/QoCVcny28OvN8BxYUKp70l6vTeiwW8ZTnv4aoLL7qf/0KHz8OrBYqfCS
 Z16eWM6z4xkugZNOGg4vQcZ6gQrnc4EN1Tyw7ATMD64gdaZpvxIvVWkEcFHgrfp9JNIC
 jP4Cw/llGNSIHyxRUzbvim7oDNvR41Skd18CAzTc/rcOzvvBntsvEjSWsklAjapMope5
 sWLCY1tgyCg2/KZAVaVVMGixTfAcFIgzBEmWFErI/hQo0dTYaQTKzlhu4qOKEqVvz6zw 1w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gsr0u9vhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 07:39:58 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25K7JH3B018024;
        Mon, 20 Jun 2022 07:39:57 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gsr0u9vh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 07:39:57 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25K7bFew009561;
        Mon, 20 Jun 2022 07:39:54 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3gs5yhj44t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 07:39:54 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25K7dpqf18481508
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jun 2022 07:39:51 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 764BC4203F;
        Mon, 20 Jun 2022 07:39:51 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7625842041;
        Mon, 20 Jun 2022 07:39:50 +0000 (GMT)
Received: from [9.171.78.67] (unknown [9.171.78.67])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Jun 2022 07:39:50 +0000 (GMT)
Message-ID: <6518c2f2-476c-9f12-5a07-974af95a0b42@linux.ibm.com>
Date:   Mon, 20 Jun 2022 09:39:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 1/3] KVM: selftests: Consolidate common code for
 popuplating ucall struct
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Colton Lewis <coltonlewis@google.com>,
        Andrew Jones <drjones@redhat.com>
References: <20220618001618.1840806-1-seanjc@google.com>
 <20220618001618.1840806-2-seanjc@google.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220618001618.1840806-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3kMnldFGR4mx2uIIfYJ39jhAL3unWFq8
X-Proofpoint-ORIG-GUID: t79n4gkBCrUV_et_g7vpEmhdtxJM0A7F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-20_05,2022-06-17_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1011 spamscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206200035
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 18.06.22 um 02:16 schrieb Sean Christopherson:
> Make ucall() a common helper that populates struct ucall, and only calls
> into arch code to make the actually call out to userspace.
> 
> Rename all arch-specific helpers to make it clear they're arch-specific,
> and to avoid collisions with common helpers (one more on its way...)
> 
> No functional change intended.
> 
> Cc: Colton Lewis <coltonlewis@google.com>
> Cc: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

seems to work on s390.
Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>

> ---
>   tools/testing/selftests/kvm/Makefile          |  1 +
>   .../selftests/kvm/include/ucall_common.h      | 23 ++++++++++++++++---
>   .../testing/selftests/kvm/lib/aarch64/ucall.c | 23 ++++---------------
>   tools/testing/selftests/kvm/lib/riscv/ucall.c | 23 ++++---------------
>   tools/testing/selftests/kvm/lib/s390x/ucall.c | 23 ++++---------------
>   .../testing/selftests/kvm/lib/ucall_common.c  | 20 ++++++++++++++++
>   .../testing/selftests/kvm/lib/x86_64/ucall.c  | 23 ++++---------------
>   7 files changed, 61 insertions(+), 75 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/lib/ucall_common.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index b52c130f7b2f..bc2aee2af66c 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -46,6 +46,7 @@ LIBKVM += lib/perf_test_util.c
>   LIBKVM += lib/rbtree.c
>   LIBKVM += lib/sparsebit.c
>   LIBKVM += lib/test_util.c
> +LIBKVM += lib/ucall_common.c
>   
>   LIBKVM_x86_64 += lib/x86_64/apic.c
>   LIBKVM_x86_64 += lib/x86_64/handlers.S
> diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
> index 98562f685151..c6a4fd7fe443 100644
> --- a/tools/testing/selftests/kvm/include/ucall_common.h
> +++ b/tools/testing/selftests/kvm/include/ucall_common.h
> @@ -23,10 +23,27 @@ struct ucall {
>   	uint64_t args[UCALL_MAX_ARGS];
>   };
>   
> -void ucall_init(struct kvm_vm *vm, void *arg);
> -void ucall_uninit(struct kvm_vm *vm);
> +void ucall_arch_init(struct kvm_vm *vm, void *arg);
> +void ucall_arch_uninit(struct kvm_vm *vm);
> +void ucall_arch_do_ucall(vm_vaddr_t uc);
> +uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
> +
>   void ucall(uint64_t cmd, int nargs, ...);
> -uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
> +
> +static inline void ucall_init(struct kvm_vm *vm, void *arg)
> +{
> +	ucall_arch_init(vm, arg);
> +}
> +
> +static inline void ucall_uninit(struct kvm_vm *vm)
> +{
> +	ucall_arch_uninit(vm);
> +}
> +
> +static inline uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> +{
> +	return ucall_arch_get_ucall(vcpu, uc);
> +}
>   
>   #define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)	\
>   				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> index 0b949ee06b5e..2de9fdd34159 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> @@ -21,7 +21,7 @@ static bool ucall_mmio_init(struct kvm_vm *vm, vm_paddr_t gpa)
>   	return true;
>   }
>   
> -void ucall_init(struct kvm_vm *vm, void *arg)
> +void ucall_arch_init(struct kvm_vm *vm, void *arg)
>   {
>   	vm_paddr_t gpa, start, end, step, offset;
>   	unsigned int bits;
> @@ -64,31 +64,18 @@ void ucall_init(struct kvm_vm *vm, void *arg)
>   	TEST_FAIL("Can't find a ucall mmio address");
>   }
>   
> -void ucall_uninit(struct kvm_vm *vm)
> +void ucall_arch_uninit(struct kvm_vm *vm)
>   {
>   	ucall_exit_mmio_addr = 0;
>   	sync_global_to_guest(vm, ucall_exit_mmio_addr);
>   }
>   
> -void ucall(uint64_t cmd, int nargs, ...)
> +void ucall_arch_do_ucall(vm_vaddr_t uc)
>   {
> -	struct ucall uc = {
> -		.cmd = cmd,
> -	};
> -	va_list va;
> -	int i;
> -
> -	nargs = min(nargs, UCALL_MAX_ARGS);
> -
> -	va_start(va, nargs);
> -	for (i = 0; i < nargs; ++i)
> -		uc.args[i] = va_arg(va, uint64_t);
> -	va_end(va);
> -
> -	*ucall_exit_mmio_addr = (vm_vaddr_t)&uc;
> +	*ucall_exit_mmio_addr = uc;
>   }
>   
> -uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> +uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
>   {
>   	struct kvm_run *run = vcpu->run;
>   	struct ucall ucall = {};
> diff --git a/tools/testing/selftests/kvm/lib/riscv/ucall.c b/tools/testing/selftests/kvm/lib/riscv/ucall.c
> index 087b9740bc8f..b1598f418c1f 100644
> --- a/tools/testing/selftests/kvm/lib/riscv/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/riscv/ucall.c
> @@ -10,11 +10,11 @@
>   #include "kvm_util.h"
>   #include "processor.h"
>   
> -void ucall_init(struct kvm_vm *vm, void *arg)
> +void ucall_arch_init(struct kvm_vm *vm, void *arg)
>   {
>   }
>   
> -void ucall_uninit(struct kvm_vm *vm)
> +void ucall_arch_uninit(struct kvm_vm *vm)
>   {
>   }
>   
> @@ -44,27 +44,14 @@ struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
>   	return ret;
>   }
>   
> -void ucall(uint64_t cmd, int nargs, ...)
> +void ucall_arch_do_ucall(vm_vaddr_t uc)
>   {
> -	struct ucall uc = {
> -		.cmd = cmd,
> -	};
> -	va_list va;
> -	int i;
> -
> -	nargs = min(nargs, UCALL_MAX_ARGS);
> -
> -	va_start(va, nargs);
> -	for (i = 0; i < nargs; ++i)
> -		uc.args[i] = va_arg(va, uint64_t);
> -	va_end(va);
> -
>   	sbi_ecall(KVM_RISCV_SELFTESTS_SBI_EXT,
>   		  KVM_RISCV_SELFTESTS_SBI_UCALL,
> -		  (vm_vaddr_t)&uc, 0, 0, 0, 0, 0);
> +		  uc, 0, 0, 0, 0, 0);
>   }
>   
> -uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> +uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
>   {
>   	struct kvm_run *run = vcpu->run;
>   	struct ucall ucall = {};
> diff --git a/tools/testing/selftests/kvm/lib/s390x/ucall.c b/tools/testing/selftests/kvm/lib/s390x/ucall.c
> index 73dc4e21190f..114cb4af295f 100644
> --- a/tools/testing/selftests/kvm/lib/s390x/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/s390x/ucall.c
> @@ -6,34 +6,21 @@
>    */
>   #include "kvm_util.h"
>   
> -void ucall_init(struct kvm_vm *vm, void *arg)
> +void ucall_arch_init(struct kvm_vm *vm, void *arg)
>   {
>   }
>   
> -void ucall_uninit(struct kvm_vm *vm)
> +void ucall_arch_uninit(struct kvm_vm *vm)
>   {
>   }
>   
> -void ucall(uint64_t cmd, int nargs, ...)
> +void ucall_arch_do_ucall(vm_vaddr_t uc)
>   {
> -	struct ucall uc = {
> -		.cmd = cmd,
> -	};
> -	va_list va;
> -	int i;
> -
> -	nargs = min(nargs, UCALL_MAX_ARGS);
> -
> -	va_start(va, nargs);
> -	for (i = 0; i < nargs; ++i)
> -		uc.args[i] = va_arg(va, uint64_t);
> -	va_end(va);
> -
>   	/* Exit via DIAGNOSE 0x501 (normally used for breakpoints) */
> -	asm volatile ("diag 0,%0,0x501" : : "a"(&uc) : "memory");
> +	asm volatile ("diag 0,%0,0x501" : : "a"(uc) : "memory");
>   }
>   
> -uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> +uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
>   {
>   	struct kvm_run *run = vcpu->run;
>   	struct ucall ucall = {};
> diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
> new file mode 100644
> index 000000000000..749ffdf23855
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/lib/ucall_common.c
> @@ -0,0 +1,20 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include "kvm_util.h"
> +
> +void ucall(uint64_t cmd, int nargs, ...)
> +{
> +	struct ucall uc = {
> +		.cmd = cmd,
> +	};
> +	va_list va;
> +	int i;
> +
> +	nargs = min(nargs, UCALL_MAX_ARGS);
> +
> +	va_start(va, nargs);
> +	for (i = 0; i < nargs; ++i)
> +		uc.args[i] = va_arg(va, uint64_t);
> +	va_end(va);
> +
> +	ucall_arch_do_ucall((vm_vaddr_t)&uc);
> +}
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/ucall.c b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> index e5f0f9e0d3ee..9f532dba1003 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> @@ -8,34 +8,21 @@
>   
>   #define UCALL_PIO_PORT ((uint16_t)0x1000)
>   
> -void ucall_init(struct kvm_vm *vm, void *arg)
> +void ucall_arch_init(struct kvm_vm *vm, void *arg)
>   {
>   }
>   
> -void ucall_uninit(struct kvm_vm *vm)
> +void ucall_arch_uninit(struct kvm_vm *vm)
>   {
>   }
>   
> -void ucall(uint64_t cmd, int nargs, ...)
> +void ucall_arch_do_ucall(vm_vaddr_t uc)
>   {
> -	struct ucall uc = {
> -		.cmd = cmd,
> -	};
> -	va_list va;
> -	int i;
> -
> -	nargs = min(nargs, UCALL_MAX_ARGS);
> -
> -	va_start(va, nargs);
> -	for (i = 0; i < nargs; ++i)
> -		uc.args[i] = va_arg(va, uint64_t);
> -	va_end(va);
> -
>   	asm volatile("in %[port], %%al"
> -		: : [port] "d" (UCALL_PIO_PORT), "D" (&uc) : "rax", "memory");
> +		: : [port] "d" (UCALL_PIO_PORT), "D" (uc) : "rax", "memory");
>   }
>   
> -uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> +uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
>   {
>   	struct kvm_run *run = vcpu->run;
>   	struct ucall ucall = {};
