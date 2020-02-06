Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD88F154F25
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 23:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgBFW6S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 17:58:18 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:57448 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726543AbgBFW6R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 17:58:17 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 016Mw7Jh161795;
        Thu, 6 Feb 2020 22:58:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=TSWwNmntLleJP4eW97/f6yuOUT0Diezr4kbOhMP+XN8=;
 b=0K8SZ0C4/Iw8Eo2khWYXCX1jjxYrInM8v+q7PKtN9U8pgPJ7iRZSB+3ShPlCvTVqJVTA
 MUsMpYr51A6H7qLtW7AON0VzcKWueSOYcuCERqXw3a9eOKYb1fGQySPjxp2jzE4jOXK6
 p2YgF1JM4OTAZ05ple055FcZ87Gys+R1kS74Itcs369pdds/Uhx6GsugBV9Brr8XdM3K
 Yg/EiPCmvfNv2kg9yu/6Z9P80qnlR6CAqryKDMqU7+4M7p3LhyDIuRh0Ig93lH4SLlDs
 yfRIgSQqEzwPa4xG2BNZf/DJ6F5pJbImdxQtE+ZxG/K5qrr1hxLg7iDIx6C3WEzI1Dl2 mQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=TSWwNmntLleJP4eW97/f6yuOUT0Diezr4kbOhMP+XN8=;
 b=qsaRGZbM8pvgm61c1+bJ9bQvWaAs16jJA8zXW7KXEfi90WgMg2eGZ7aFFn+XqqYrgukR
 e6lRSNw62PmZBOJ4/q9lcGYR4aribXAQr4xO7jj9FURzpnlRdF7DXbNjAiFbT4kymyDA
 4Re7JDkgM3tB5g1duQfbsoFU6fFWFI4nVN4WpO/RtsBmi2i/D7nnXpzXEbMl4F2tlf7a
 T6hebQrTll0HKonyVQN4q8N8VqOTy0FUYEoClhBOQK7AJcmPgG316jZSsSQxGzeFrX5U
 iljVp2E78LVSDGwPpNPYwsj1tS3yE4BTTC1jDO0BOQ1V2mTUjhXp+hPc+zi8njLOR1zL lQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2xykbpmvk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Feb 2020 22:58:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 016MnHxl155179;
        Thu, 6 Feb 2020 22:58:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2y080ea2dp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Feb 2020 22:58:01 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 016Mw0uv024120;
        Thu, 6 Feb 2020 22:58:00 GMT
Received: from dhcp-10-132-97-93.usdhcp.oraclecorp.com (/10.132.97.93)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Feb 2020 14:58:00 -0800
Subject: Re: [PATCH v4 2/3] selftests: KVM: AMD Nested test infrastructure
To:     Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com
Cc:     thuth@redhat.com, drjones@redhat.com, wei.huang2@amd.com
References: <20200206104710.16077-1-eric.auger@redhat.com>
 <20200206104710.16077-3-eric.auger@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <92106709-10ff-44d3-1fe8-2c77c010913f@oracle.com>
Date:   Thu, 6 Feb 2020 14:57:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20200206104710.16077-3-eric.auger@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9523 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002060164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9523 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002060165
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 02/06/2020 02:47 AM, Eric Auger wrote:
> Add the basic infrastructure needed to test AMD nested SVM.
> This is largely copied from the KVM unit test infrastructure.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>
> ---
>
> v3 -> v4:
> - just keep the 16 GPRs in gpr64_regs struct
> - vm* instructions do not take any param
> - add comments
>
> v2 -> v3:
> - s/regs/gp_regs64
> - Split the header into 2 parts: svm.h is a copy of
>    arch/x86/include/asm/svm.h whereas svm_util.h contains
>    testing add-ons
> - use get_gdt/dt() and remove sgdt/sidt
> - use get_es/ss/ds/cs
> - fix clobber for dr6 & dr7
> - use u64 instead of ulong
> ---
>   tools/testing/selftests/kvm/Makefile          |   2 +-
>   .../selftests/kvm/include/x86_64/processor.h  |  20 ++
>   .../selftests/kvm/include/x86_64/svm.h        | 297 ++++++++++++++++++
>   .../selftests/kvm/include/x86_64/svm_util.h   |  38 +++
>   tools/testing/selftests/kvm/lib/x86_64/svm.c  | 161 ++++++++++
>   5 files changed, 517 insertions(+), 1 deletion(-)
>   create mode 100644 tools/testing/selftests/kvm/include/x86_64/svm.h
>   create mode 100644 tools/testing/selftests/kvm/include/x86_64/svm_util.h
>   create mode 100644 tools/testing/selftests/kvm/lib/x86_64/svm.c
>
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 608fa835c764..2e770f554cae 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -8,7 +8,7 @@ KSFT_KHDR_INSTALL := 1
>   UNAME_M := $(shell uname -m)
>   
>   LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/sparsebit.c
> -LIBKVM_x86_64 = lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/ucall.c
> +LIBKVM_x86_64 = lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c
>   LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c
>   LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c
>   
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 6f7fffaea2e8..12475047869f 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -56,6 +56,26 @@ enum x86_register {
>   	R15,
>   };
>   
> +/* General Registers in 64-Bit Mode */
> +struct gpr64_regs {
> +	u64 rax;
> +	u64 rcx;
> +	u64 rdx;
> +	u64 rbx;
> +	u64 rsp;
> +	u64 rbp;
> +	u64 rsi;
> +	u64 rdi;
> +	u64 r8;
> +	u64 r9;
> +	u64 r10;
> +	u64 r11;
> +	u64 r12;
> +	u64 r13;
> +	u64 r14;
> +	u64 r15;
> +};
> +
>   struct desc64 {
>   	uint16_t limit0;
>   	uint16_t base0;
> diff --git a/tools/testing/selftests/kvm/include/x86_64/svm.h b/tools/testing/selftests/kvm/include/x86_64/svm.h
> new file mode 100644
> index 000000000000..f4ea2355dbc2
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/include/x86_64/svm.h
> @@ -0,0 +1,297 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * tools/testing/selftests/kvm/include/x86_64/svm.h
> + * This is a copy of arch/x86/include/asm/svm.h
> + *
> + */
> +
> +#ifndef SELFTEST_KVM_SVM_H
> +#define SELFTEST_KVM_SVM_H
> +
> +enum {
> +	INTERCEPT_INTR,
> +	INTERCEPT_NMI,
> +	INTERCEPT_SMI,
> +	INTERCEPT_INIT,
> +	INTERCEPT_VINTR,
> +	INTERCEPT_SELECTIVE_CR0,
> +	INTERCEPT_STORE_IDTR,
> +	INTERCEPT_STORE_GDTR,
> +	INTERCEPT_STORE_LDTR,
> +	INTERCEPT_STORE_TR,
> +	INTERCEPT_LOAD_IDTR,
> +	INTERCEPT_LOAD_GDTR,
> +	INTERCEPT_LOAD_LDTR,
> +	INTERCEPT_LOAD_TR,
> +	INTERCEPT_RDTSC,
> +	INTERCEPT_RDPMC,
> +	INTERCEPT_PUSHF,
> +	INTERCEPT_POPF,
> +	INTERCEPT_CPUID,
> +	INTERCEPT_RSM,
> +	INTERCEPT_IRET,
> +	INTERCEPT_INTn,
> +	INTERCEPT_INVD,
> +	INTERCEPT_PAUSE,
> +	INTERCEPT_HLT,
> +	INTERCEPT_INVLPG,
> +	INTERCEPT_INVLPGA,
> +	INTERCEPT_IOIO_PROT,
> +	INTERCEPT_MSR_PROT,
> +	INTERCEPT_TASK_SWITCH,
> +	INTERCEPT_FERR_FREEZE,
> +	INTERCEPT_SHUTDOWN,
> +	INTERCEPT_VMRUN,
> +	INTERCEPT_VMMCALL,
> +	INTERCEPT_VMLOAD,
> +	INTERCEPT_VMSAVE,
> +	INTERCEPT_STGI,
> +	INTERCEPT_CLGI,
> +	INTERCEPT_SKINIT,
> +	INTERCEPT_RDTSCP,
> +	INTERCEPT_ICEBP,
> +	INTERCEPT_WBINVD,
> +	INTERCEPT_MONITOR,
> +	INTERCEPT_MWAIT,
> +	INTERCEPT_MWAIT_COND,
> +	INTERCEPT_XSETBV,
> +	INTERCEPT_RDPRU,
> +};
> +
> +
> +struct __attribute__ ((__packed__)) vmcb_control_area {
> +	u32 intercept_cr;
> +	u32 intercept_dr;
> +	u32 intercept_exceptions;
> +	u64 intercept;
> +	u8 reserved_1[40];
> +	u16 pause_filter_thresh;
> +	u16 pause_filter_count;
> +	u64 iopm_base_pa;
> +	u64 msrpm_base_pa;
> +	u64 tsc_offset;
> +	u32 asid;
> +	u8 tlb_ctl;
> +	u8 reserved_2[3];
> +	u32 int_ctl;
> +	u32 int_vector;
> +	u32 int_state;
> +	u8 reserved_3[4];
> +	u32 exit_code;
> +	u32 exit_code_hi;
> +	u64 exit_info_1;
> +	u64 exit_info_2;
> +	u32 exit_int_info;
> +	u32 exit_int_info_err;
> +	u64 nested_ctl;
> +	u64 avic_vapic_bar;
> +	u8 reserved_4[8];
> +	u32 event_inj;
> +	u32 event_inj_err;
> +	u64 nested_cr3;
> +	u64 virt_ext;
> +	u32 clean;
> +	u32 reserved_5;
> +	u64 next_rip;
> +	u8 insn_len;
> +	u8 insn_bytes[15];
> +	u64 avic_backing_page;	/* Offset 0xe0 */
> +	u8 reserved_6[8];	/* Offset 0xe8 */
> +	u64 avic_logical_id;	/* Offset 0xf0 */
> +	u64 avic_physical_id;	/* Offset 0xf8 */
> +	u8 reserved_7[768];
> +};
> +
> +
> +#define TLB_CONTROL_DO_NOTHING 0
> +#define TLB_CONTROL_FLUSH_ALL_ASID 1
> +#define TLB_CONTROL_FLUSH_ASID 3
> +#define TLB_CONTROL_FLUSH_ASID_LOCAL 7
> +
> +#define V_TPR_MASK 0x0f
> +
> +#define V_IRQ_SHIFT 8
> +#define V_IRQ_MASK (1 << V_IRQ_SHIFT)
> +
> +#define V_GIF_SHIFT 9
> +#define V_GIF_MASK (1 << V_GIF_SHIFT)
> +
> +#define V_INTR_PRIO_SHIFT 16
> +#define V_INTR_PRIO_MASK (0x0f << V_INTR_PRIO_SHIFT)
> +
> +#define V_IGN_TPR_SHIFT 20
> +#define V_IGN_TPR_MASK (1 << V_IGN_TPR_SHIFT)
> +
> +#define V_INTR_MASKING_SHIFT 24
> +#define V_INTR_MASKING_MASK (1 << V_INTR_MASKING_SHIFT)
> +
> +#define V_GIF_ENABLE_SHIFT 25
> +#define V_GIF_ENABLE_MASK (1 << V_GIF_ENABLE_SHIFT)
> +
> +#define AVIC_ENABLE_SHIFT 31
> +#define AVIC_ENABLE_MASK (1 << AVIC_ENABLE_SHIFT)
> +
> +#define LBR_CTL_ENABLE_MASK BIT_ULL(0)
> +#define VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK BIT_ULL(1)
> +
> +#define SVM_INTERRUPT_SHADOW_MASK 1
> +
> +#define SVM_IOIO_STR_SHIFT 2
> +#define SVM_IOIO_REP_SHIFT 3
> +#define SVM_IOIO_SIZE_SHIFT 4
> +#define SVM_IOIO_ASIZE_SHIFT 7
> +
> +#define SVM_IOIO_TYPE_MASK 1
> +#define SVM_IOIO_STR_MASK (1 << SVM_IOIO_STR_SHIFT)
> +#define SVM_IOIO_REP_MASK (1 << SVM_IOIO_REP_SHIFT)
> +#define SVM_IOIO_SIZE_MASK (7 << SVM_IOIO_SIZE_SHIFT)
> +#define SVM_IOIO_ASIZE_MASK (7 << SVM_IOIO_ASIZE_SHIFT)
> +
> +#define SVM_VM_CR_VALID_MASK	0x001fULL
> +#define SVM_VM_CR_SVM_LOCK_MASK 0x0008ULL
> +#define SVM_VM_CR_SVM_DIS_MASK  0x0010ULL
> +
> +#define SVM_NESTED_CTL_NP_ENABLE	BIT(0)
> +#define SVM_NESTED_CTL_SEV_ENABLE	BIT(1)
> +
> +struct __attribute__ ((__packed__)) vmcb_seg {
> +	u16 selector;
> +	u16 attrib;
> +	u32 limit;
> +	u64 base;
> +};
> +
> +struct __attribute__ ((__packed__)) vmcb_save_area {
> +	struct vmcb_seg es;
> +	struct vmcb_seg cs;
> +	struct vmcb_seg ss;
> +	struct vmcb_seg ds;
> +	struct vmcb_seg fs;
> +	struct vmcb_seg gs;
> +	struct vmcb_seg gdtr;
> +	struct vmcb_seg ldtr;
> +	struct vmcb_seg idtr;
> +	struct vmcb_seg tr;
> +	u8 reserved_1[43];
> +	u8 cpl;
> +	u8 reserved_2[4];
> +	u64 efer;
> +	u8 reserved_3[112];
> +	u64 cr4;
> +	u64 cr3;
> +	u64 cr0;
> +	u64 dr7;
> +	u64 dr6;
> +	u64 rflags;
> +	u64 rip;
> +	u8 reserved_4[88];
> +	u64 rsp;
> +	u8 reserved_5[24];
> +	u64 rax;
> +	u64 star;
> +	u64 lstar;
> +	u64 cstar;
> +	u64 sfmask;
> +	u64 kernel_gs_base;
> +	u64 sysenter_cs;
> +	u64 sysenter_esp;
> +	u64 sysenter_eip;
> +	u64 cr2;
> +	u8 reserved_6[32];
> +	u64 g_pat;
> +	u64 dbgctl;
> +	u64 br_from;
> +	u64 br_to;
> +	u64 last_excp_from;
> +	u64 last_excp_to;
> +};
> +
> +struct __attribute__ ((__packed__)) vmcb {
> +	struct vmcb_control_area control;
> +	struct vmcb_save_area save;
> +};
> +
> +#define SVM_CPUID_FUNC 0x8000000a
> +
> +#define SVM_VM_CR_SVM_DISABLE 4
> +
> +#define SVM_SELECTOR_S_SHIFT 4
> +#define SVM_SELECTOR_DPL_SHIFT 5
> +#define SVM_SELECTOR_P_SHIFT 7
> +#define SVM_SELECTOR_AVL_SHIFT 8
> +#define SVM_SELECTOR_L_SHIFT 9
> +#define SVM_SELECTOR_DB_SHIFT 10
> +#define SVM_SELECTOR_G_SHIFT 11
> +
> +#define SVM_SELECTOR_TYPE_MASK (0xf)
> +#define SVM_SELECTOR_S_MASK (1 << SVM_SELECTOR_S_SHIFT)
> +#define SVM_SELECTOR_DPL_MASK (3 << SVM_SELECTOR_DPL_SHIFT)
> +#define SVM_SELECTOR_P_MASK (1 << SVM_SELECTOR_P_SHIFT)
> +#define SVM_SELECTOR_AVL_MASK (1 << SVM_SELECTOR_AVL_SHIFT)
> +#define SVM_SELECTOR_L_MASK (1 << SVM_SELECTOR_L_SHIFT)
> +#define SVM_SELECTOR_DB_MASK (1 << SVM_SELECTOR_DB_SHIFT)
> +#define SVM_SELECTOR_G_MASK (1 << SVM_SELECTOR_G_SHIFT)
> +
> +#define SVM_SELECTOR_WRITE_MASK (1 << 1)
> +#define SVM_SELECTOR_READ_MASK SVM_SELECTOR_WRITE_MASK
> +#define SVM_SELECTOR_CODE_MASK (1 << 3)
> +
> +#define INTERCEPT_CR0_READ	0
> +#define INTERCEPT_CR3_READ	3
> +#define INTERCEPT_CR4_READ	4
> +#define INTERCEPT_CR8_READ	8
> +#define INTERCEPT_CR0_WRITE	(16 + 0)
> +#define INTERCEPT_CR3_WRITE	(16 + 3)
> +#define INTERCEPT_CR4_WRITE	(16 + 4)
> +#define INTERCEPT_CR8_WRITE	(16 + 8)
> +
> +#define INTERCEPT_DR0_READ	0
> +#define INTERCEPT_DR1_READ	1
> +#define INTERCEPT_DR2_READ	2
> +#define INTERCEPT_DR3_READ	3
> +#define INTERCEPT_DR4_READ	4
> +#define INTERCEPT_DR5_READ	5
> +#define INTERCEPT_DR6_READ	6
> +#define INTERCEPT_DR7_READ	7
> +#define INTERCEPT_DR0_WRITE	(16 + 0)
> +#define INTERCEPT_DR1_WRITE	(16 + 1)
> +#define INTERCEPT_DR2_WRITE	(16 + 2)
> +#define INTERCEPT_DR3_WRITE	(16 + 3)
> +#define INTERCEPT_DR4_WRITE	(16 + 4)
> +#define INTERCEPT_DR5_WRITE	(16 + 5)
> +#define INTERCEPT_DR6_WRITE	(16 + 6)
> +#define INTERCEPT_DR7_WRITE	(16 + 7)
> +
> +#define SVM_EVTINJ_VEC_MASK 0xff
> +
> +#define SVM_EVTINJ_TYPE_SHIFT 8
> +#define SVM_EVTINJ_TYPE_MASK (7 << SVM_EVTINJ_TYPE_SHIFT)
> +
> +#define SVM_EVTINJ_TYPE_INTR (0 << SVM_EVTINJ_TYPE_SHIFT)
> +#define SVM_EVTINJ_TYPE_NMI (2 << SVM_EVTINJ_TYPE_SHIFT)
> +#define SVM_EVTINJ_TYPE_EXEPT (3 << SVM_EVTINJ_TYPE_SHIFT)
> +#define SVM_EVTINJ_TYPE_SOFT (4 << SVM_EVTINJ_TYPE_SHIFT)
> +
> +#define SVM_EVTINJ_VALID (1 << 31)
> +#define SVM_EVTINJ_VALID_ERR (1 << 11)
> +
> +#define SVM_EXITINTINFO_VEC_MASK SVM_EVTINJ_VEC_MASK
> +#define SVM_EXITINTINFO_TYPE_MASK SVM_EVTINJ_TYPE_MASK
> +
> +#define	SVM_EXITINTINFO_TYPE_INTR SVM_EVTINJ_TYPE_INTR
> +#define	SVM_EXITINTINFO_TYPE_NMI SVM_EVTINJ_TYPE_NMI
> +#define	SVM_EXITINTINFO_TYPE_EXEPT SVM_EVTINJ_TYPE_EXEPT
> +#define	SVM_EXITINTINFO_TYPE_SOFT SVM_EVTINJ_TYPE_SOFT
> +
> +#define SVM_EXITINTINFO_VALID SVM_EVTINJ_VALID
> +#define SVM_EXITINTINFO_VALID_ERR SVM_EVTINJ_VALID_ERR
> +
> +#define SVM_EXITINFOSHIFT_TS_REASON_IRET 36
> +#define SVM_EXITINFOSHIFT_TS_REASON_JMP 38
> +#define SVM_EXITINFOSHIFT_TS_HAS_ERROR_CODE 44
> +
> +#define SVM_EXITINFO_REG_MASK 0x0F
> +
> +#define SVM_CR0_SELECTIVE_MASK (X86_CR0_TS | X86_CR0_MP)
> +
> +#endif /* SELFTEST_KVM_SVM_H */
> diff --git a/tools/testing/selftests/kvm/include/x86_64/svm_util.h b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
> new file mode 100644
> index 000000000000..cd037917fece
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
> @@ -0,0 +1,38 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * tools/testing/selftests/kvm/include/x86_64/svm_utils.h
> + * Header for nested SVM testing
> + *
> + * Copyright (C) 2020, Red Hat, Inc.
> + */
> +
> +#ifndef SELFTEST_KVM_SVM_UTILS_H
> +#define SELFTEST_KVM_SVM_UTILS_H
> +
> +#include <stdint.h>
> +#include "svm.h"
> +#include "processor.h"
> +
> +#define CPUID_SVM_BIT		2
> +#define CPUID_SVM		BIT_ULL(CPUID_SVM_BIT)
> +
> +#define SVM_EXIT_VMMCALL	0x081
> +
> +struct svm_test_data {
> +	/* VMCB */
> +	struct vmcb *vmcb; /* gva */
> +	void *vmcb_hva;
> +	uint64_t vmcb_gpa;
> +
> +	/* host state-save area */
> +	struct vmcb_save_area *save_area; /* gva */
> +	void *save_area_hva;
> +	uint64_t save_area_gpa;
> +};
Looks like vmcb_hva and save_area_hva haven't been used anywhere. Do we 
need them ?
> +
> +struct svm_test_data *vcpu_alloc_svm(struct kvm_vm *vm, vm_vaddr_t *p_svm_gva);
> +void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_rsp);
> +void run_guest(struct vmcb *vmcb, uint64_t vmcb_gpa);
> +void nested_svm_check_supported(void);
> +
> +#endif /* SELFTEST_KVM_SVM_UTILS_H */
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/svm.c b/tools/testing/selftests/kvm/lib/x86_64/svm.c
> new file mode 100644
> index 000000000000..6e05a8fc3fe0
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/lib/x86_64/svm.c
> @@ -0,0 +1,161 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * tools/testing/selftests/kvm/lib/x86_64/svm.c
> + * Helpers used for nested SVM testing
> + * Largely inspired from KVM unit test svm.c
> + *
> + * Copyright (C) 2020, Red Hat, Inc.
> + */
> +
> +#include "test_util.h"
> +#include "kvm_util.h"
> +#include "../kvm_util_internal.h"
> +#include "processor.h"
> +#include "svm_util.h"
> +
> +struct gpr64_regs guest_regs;
> +u64 rflags;
> +
> +/* Allocate memory regions for nested SVM tests.
> + *
> + * Input Args:
> + *   vm - The VM to allocate guest-virtual addresses in.
> + *
> + * Output Args:
> + *   p_svm_gva - The guest virtual address for the struct svm_test_data.
> + *
> + * Return:
> + *   Pointer to structure with the addresses of the SVM areas.
> + */
> +struct svm_test_data *
> +vcpu_alloc_svm(struct kvm_vm *vm, vm_vaddr_t *p_svm_gva)
> +{
> +	vm_vaddr_t svm_gva = vm_vaddr_alloc(vm, getpagesize(),
> +					    0x10000, 0, 0);
> +	struct svm_test_data *svm = addr_gva2hva(vm, svm_gva);
> +
> +	svm->vmcb = (void *)vm_vaddr_alloc(vm, getpagesize(),
> +					   0x10000, 0, 0);
> +	svm->vmcb_hva = addr_gva2hva(vm, (uintptr_t)svm->vmcb);
> +	svm->vmcb_gpa = addr_gva2gpa(vm, (uintptr_t)svm->vmcb);
> +
> +	svm->save_area = (void *)vm_vaddr_alloc(vm, getpagesize(),
> +						0x10000, 0, 0);
> +	svm->save_area_hva = addr_gva2hva(vm, (uintptr_t)svm->save_area);
> +	svm->save_area_gpa = addr_gva2gpa(vm, (uintptr_t)svm->save_area);
> +
> +	*p_svm_gva = svm_gva;
> +	return svm;
> +}
> +
> +static void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
> +			 u64 base, u32 limit, u32 attr)
> +{
> +	seg->selector = selector;
> +	seg->attrib = attr;
> +	seg->limit = limit;
> +	seg->base = base;
> +}
> +
> +void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_rsp)
> +{
> +	struct vmcb *vmcb = svm->vmcb;
> +	uint64_t vmcb_gpa = svm->vmcb_gpa;
> +	struct vmcb_save_area *save = &vmcb->save;
> +	struct vmcb_control_area *ctrl = &vmcb->control;
> +	u32 data_seg_attr = 3 | SVM_SELECTOR_S_MASK | SVM_SELECTOR_P_MASK
> +	      | SVM_SELECTOR_DB_MASK | SVM_SELECTOR_G_MASK;
> +	u32 code_seg_attr = 9 | SVM_SELECTOR_S_MASK | SVM_SELECTOR_P_MASK
> +		| SVM_SELECTOR_L_MASK | SVM_SELECTOR_G_MASK;
> +	uint64_t efer;
> +
> +	efer = rdmsr(MSR_EFER);
> +	wrmsr(MSR_EFER, efer | EFER_SVME);
> +	wrmsr(MSR_VM_HSAVE_PA, svm->save_area_gpa);
> +
> +	memset(vmcb, 0, sizeof(*vmcb));
> +	asm volatile ("vmsave\n\t" : : "a" (vmcb_gpa) : "memory");
> +	vmcb_set_seg(&save->es, get_es(), 0, -1U, data_seg_attr);
> +	vmcb_set_seg(&save->cs, get_cs(), 0, -1U, code_seg_attr);
> +	vmcb_set_seg(&save->ss, get_ss(), 0, -1U, data_seg_attr);
> +	vmcb_set_seg(&save->ds, get_ds(), 0, -1U, data_seg_attr);
> +	vmcb_set_seg(&save->gdtr, 0, get_gdt().address, get_gdt().size, 0);
> +	vmcb_set_seg(&save->idtr, 0, get_idt().address, get_idt().size, 0);
> +
> +	ctrl->asid = 1;
> +	save->cpl = 0;
> +	save->efer = rdmsr(MSR_EFER);
> +	asm volatile ("mov %%cr4, %0" : "=r"(save->cr4) : : "memory");
> +	asm volatile ("mov %%cr3, %0" : "=r"(save->cr3) : : "memory");
> +	asm volatile ("mov %%cr0, %0" : "=r"(save->cr0) : : "memory");
> +	asm volatile ("mov %%dr7, %0" : "=r"(save->dr7) : : "memory");
> +	asm volatile ("mov %%dr6, %0" : "=r"(save->dr6) : : "memory");
> +	asm volatile ("mov %%cr2, %0" : "=r"(save->cr2) : : "memory");
> +	save->g_pat = rdmsr(MSR_IA32_CR_PAT);
> +	save->dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
> +	ctrl->intercept = (1ULL << INTERCEPT_VMRUN) |
> +				(1ULL << INTERCEPT_VMMCALL);
> +
> +	vmcb->save.rip = (u64)guest_rip;
> +	vmcb->save.rsp = (u64)guest_rsp;
> +	guest_regs.rdi = (u64)svm;
> +}
> +
> +/*
> + * save/restore 64-bit general registers except rax, rip, rsp
> + * which are directly handed through the VMCB guest processor state
> + */
> +#define SAVE_GPR_C				\
> +	"xchg %%rbx, guest_regs+0x20\n\t"	\
> +	"xchg %%rcx, guest_regs+0x10\n\t"	\
> +	"xchg %%rdx, guest_regs+0x18\n\t"	\
> +	"xchg %%rbp, guest_regs+0x30\n\t"	\
> +	"xchg %%rsi, guest_regs+0x38\n\t"	\
> +	"xchg %%rdi, guest_regs+0x40\n\t"	\
> +	"xchg %%r8,  guest_regs+0x48\n\t"	\
> +	"xchg %%r9,  guest_regs+0x50\n\t"	\
> +	"xchg %%r10, guest_regs+0x58\n\t"	\
> +	"xchg %%r11, guest_regs+0x60\n\t"	\
> +	"xchg %%r12, guest_regs+0x68\n\t"	\
> +	"xchg %%r13, guest_regs+0x70\n\t"	\
> +	"xchg %%r14, guest_regs+0x78\n\t"	\
> +	"xchg %%r15, guest_regs+0x80\n\t"
> +
> +#define LOAD_GPR_C      SAVE_GPR_C
> +
> +/*
> + * selftests do not use interrupts so we dropped clgi/sti/cli/stgi
> + * for now. registers involved in LOAD/SAVE_GPR_C are eventually
> + * unmodified so they do not need to be in the clobber list.
> + */
> +void run_guest(struct vmcb *vmcb, uint64_t vmcb_gpa)
> +{
> +	asm volatile (
> +		"vmload\n\t"
Don't we need to set %rax before calling vmload ?

             "mov %[vmcb_gpa], %%rax \n\t"
             "vmload %%rax\n\t"

> +		"mov rflags, %%r15\n\t"	// rflags
> +		"mov %%r15, 0x170(%[vmcb])\n\t"
> +		"mov guest_regs, %%r15\n\t"	// rax
> +		"mov %%r15, 0x1f8(%[vmcb])\n\t"
> +		LOAD_GPR_C
> +		"vmrun\n\t"
> +		SAVE_GPR_C
> +		"mov 0x170(%[vmcb]), %%r15\n\t"	// rflags
> +		"mov %%r15, rflags\n\t"
> +		"mov 0x1f8(%[vmcb]), %%r15\n\t"	// rax
> +		"mov %%r15, guest_regs\n\t"
> +		"vmsave\n\t"
> +		: : [vmcb] "r" (vmcb), [vmcb_gpa] "a" (vmcb_gpa)
> +		: "r15", "memory");
> +}
> +
> +void nested_svm_check_supported(void)
> +{
> +	struct kvm_cpuid_entry2 *entry =
> +		kvm_get_supported_cpuid_entry(0x80000001);
> +
> +	if (!(entry->ecx & CPUID_SVM)) {
> +		fprintf(stderr, "nested SVM not enabled, skipping test\n");
I think a better message would be:

     "nested SVM not supported on this CPU, skipping test\n"

Also, the function should ideally return a boolean and let the callers 
print whatever they want.

> +		exit(KSFT_SKIP);
> +	}
> +}
> +

