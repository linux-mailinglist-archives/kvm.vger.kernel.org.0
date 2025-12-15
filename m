Return-Path: <kvm+bounces-66048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CEA41CC0140
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 23:03:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A81D0300C0F8
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 22:03:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F23530E0D9;
	Mon, 15 Dec 2025 22:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="G2KNj0no"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723A31DED63
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 22:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765836226; cv=none; b=T1yMwBsp3NCUt82CPBjFXX3fX/+6bvGDyrR+vwg7y9S3gaKiZF/NrloWUdOP5XtMhywaX8BQslGplQw4StRyn+KmIsJxZKls4xsqKkxPv3elCvI6Uf8k2PPYRMcXDJzWSc+1q1tnYGBPDBydZi936lQ+XNqszfoku3dslc936Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765836226; c=relaxed/simple;
	bh=GdNEr7oWcOgdcWwLcSyXT6l+yqjTyCKthvb9uQLyHxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZFQMDyh+/TAyvbC9FYjtix2cxC2vt+Ksk2r7XOxTcGj3pMYOI/A9RnyVsKkMGd47YcX/+8lujWaHYPY67/4CQ/5SGXBF3w9L35hLe9zd+8nEnh+59hH7pN68q7+M/s1958ngBbtA6kxTfW9xuir4d2ASk1OSRcKehVQNU6QMcrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=G2KNj0no; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 15 Dec 2025 22:03:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765836219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6RwFECZtzyu1W3CFfKFYwI/VBdlF+c76/uK3nOGFH4o=;
	b=G2KNj0noZuy4xyxiverTAWs+WqPFJ6LDWUmNXsh6qy57kNl16h+deV+73CKvXblmUvH/Yf
	UQBJqlg3Aw+0pSNFf4GytMafgWBvC722am4TJeBRaVBGCC1oXuSiKmfajOR9B0GBOs5nQy
	T43csj42wcvpPvLitTytk7krM4WYfUA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Kevin Cheng <chengkev@google.com>
Cc: kvm@vger.kernel.org, andrew.jones@linux.dev, thuth@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com
Subject: Re: [kvm-unit-tests PATCH v2 1/2] x86/svm: Add missing svm intercepts
Message-ID: <bkhnsywzv3bbtxjbgufpv3rdwkd5v2guvj36im46zok3ksb2da@xgudp5pniia7>
References: <20251215210026.2422155-1-chengkev@google.com>
 <20251215210026.2422155-2-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215210026.2422155-2-chengkev@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Dec 15, 2025 at 09:00:25PM +0000, Kevin Cheng wrote:
> Some intercepts are missing from the KUT svm testing. Add all missing
> intercepts and reorganize the svm intercept definition/setting/clearing.
> 
> Signed-off-by: Kevin Cheng <chengkev@google.com>
> Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

There was a small miscommunication about this R-b tag as it wasn't
explicitly given, but the patch does look good to me, so to concur:

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
>  x86/svm.c       |  18 +++++--
>  x86/svm.h       |  84 ++++++++++++++++++++++++++----
>  x86/svm_tests.c | 136 ++++++++++++++++++++++++------------------------
>  3 files changed, 159 insertions(+), 79 deletions(-)
> 
> diff --git a/x86/svm.c b/x86/svm.c
> index de9eb19443caa..18b2538c6e8c7 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -137,6 +137,18 @@ static void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
>  	seg->base = base;
>  }
>  
> +void vmcb_save_intercepts(struct vmcb *vmcb, u32 *saved_intercepts)
> +{
> +	for (int i = 0; i < MAX_INTERCEPT; i++)
> +		saved_intercepts[i] = vmcb->control.intercept[i];
> +}
> +
> +void vmcb_restore_intercepts(struct vmcb *vmcb, u32 *saved_intercepts)
> +{
> +	for (int i = 0; i < MAX_INTERCEPT; i++)
> +		vmcb->control.intercept[i] = saved_intercepts[i];
> +}
> +
>  inline void vmmcall(void)
>  {
>  	asm volatile ("vmmcall" : : : "memory");
> @@ -193,9 +205,9 @@ void vmcb_ident(struct vmcb *vmcb)
>  	save->cr2 = read_cr2();
>  	save->g_pat = rdmsr(MSR_IA32_CR_PAT);
>  	save->dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
> -	ctrl->intercept = (1ULL << INTERCEPT_VMRUN) |
> -		(1ULL << INTERCEPT_VMMCALL) |
> -		(1ULL << INTERCEPT_SHUTDOWN);
> +	vmcb_set_intercept(INTERCEPT_VMRUN);
> +	vmcb_set_intercept(INTERCEPT_VMMCALL);
> +	vmcb_set_intercept(INTERCEPT_SHUTDOWN);
>  	ctrl->iopm_base_pa = virt_to_phys(io_bitmap);
>  	ctrl->msrpm_base_pa = virt_to_phys(msr_bitmap);
>  
> diff --git a/x86/svm.h b/x86/svm.h
> index 264583a6547ef..c22c252fed001 100644
> --- a/x86/svm.h
> +++ b/x86/svm.h
> @@ -2,9 +2,49 @@
>  #define X86_SVM_H
>  
>  #include "libcflat.h"
> +#include "bitops.h"
> +
> +enum intercept_words {
> +	INTERCEPT_CR = 0,
> +	INTERCEPT_DR,
> +	INTERCEPT_EXCEPTION,
> +	INTERCEPT_WORD3,
> +	INTERCEPT_WORD4,
> +	INTERCEPT_WORD5,
> +	MAX_INTERCEPT,
> +};
>  
>  enum {
> -	INTERCEPT_INTR,
> +	/* Byte offset 000h (word 0) */
> +	INTERCEPT_CR0_READ = 0,
> +	INTERCEPT_CR3_READ = 3,
> +	INTERCEPT_CR4_READ = 4,
> +	INTERCEPT_CR8_READ = 8,
> +	INTERCEPT_CR0_WRITE = 16,
> +	INTERCEPT_CR3_WRITE = 16 + 3,
> +	INTERCEPT_CR4_WRITE = 16 + 4,
> +	INTERCEPT_CR8_WRITE = 16 + 8,
> +	/* Byte offset 004h (word 1) */
> +	INTERCEPT_DR0_READ = 32,
> +	INTERCEPT_DR1_READ,
> +	INTERCEPT_DR2_READ,
> +	INTERCEPT_DR3_READ,
> +	INTERCEPT_DR4_READ,
> +	INTERCEPT_DR5_READ,
> +	INTERCEPT_DR6_READ,
> +	INTERCEPT_DR7_READ,
> +	INTERCEPT_DR0_WRITE = 48,
> +	INTERCEPT_DR1_WRITE,
> +	INTERCEPT_DR2_WRITE,
> +	INTERCEPT_DR3_WRITE,
> +	INTERCEPT_DR4_WRITE,
> +	INTERCEPT_DR5_WRITE,
> +	INTERCEPT_DR6_WRITE,
> +	INTERCEPT_DR7_WRITE,
> +	/* Byte offset 008h (word 2) */
> +	INTERCEPT_EXCEPTION_OFFSET = 64,
> +	/* Byte offset 00Ch (word 3) */
> +	INTERCEPT_INTR = 96,
>  	INTERCEPT_NMI,
>  	INTERCEPT_SMI,
>  	INTERCEPT_INIT,
> @@ -36,7 +76,8 @@ enum {
>  	INTERCEPT_TASK_SWITCH,
>  	INTERCEPT_FERR_FREEZE,
>  	INTERCEPT_SHUTDOWN,
> -	INTERCEPT_VMRUN,
> +	/* Byte offset 010h (word 4) */
> +	INTERCEPT_VMRUN = 128,
>  	INTERCEPT_VMMCALL,
>  	INTERCEPT_VMLOAD,
>  	INTERCEPT_VMSAVE,
> @@ -49,6 +90,24 @@ enum {
>  	INTERCEPT_MONITOR,
>  	INTERCEPT_MWAIT,
>  	INTERCEPT_MWAIT_COND,
> +	INTERCEPT_XSETBV,
> +	INTERCEPT_RDPRU,
> +	TRAP_EFER_WRITE,
> +	TRAP_CR0_WRITE,
> +	TRAP_CR1_WRITE,
> +	TRAP_CR2_WRITE,
> +	TRAP_CR3_WRITE,
> +	TRAP_CR4_WRITE,
> +	TRAP_CR5_WRITE,
> +	TRAP_CR6_WRITE,
> +	TRAP_CR7_WRITE,
> +	TRAP_CR8_WRITE,
> +	/* Byte offset 014h (word 5) */
> +	INTERCEPT_INVLPGB = 160,
> +	INTERCEPT_INVLPGB_ILLEGAL,
> +	INTERCEPT_INVPCID,
> +	INTERCEPT_MCOMMIT,
> +	INTERCEPT_TLBSYNC,
>  };
>  
>  enum {
> @@ -69,13 +128,8 @@ enum {
>  };
>  
>  struct __attribute__ ((__packed__)) vmcb_control_area {
> -	u16 intercept_cr_read;
> -	u16 intercept_cr_write;
> -	u16 intercept_dr_read;
> -	u16 intercept_dr_write;
> -	u32 intercept_exceptions;
> -	u64 intercept;
> -	u8 reserved_1[40];
> +	u32 intercept[MAX_INTERCEPT];
> +	u32 reserved_1[15 - MAX_INTERCEPT];
>  	u16 pause_filter_thresh;
>  	u16 pause_filter_count;
>  	u64 iopm_base_pa;
> @@ -431,6 +485,8 @@ bool vnmi_supported(void);
>  int get_test_stage(struct svm_test *test);
>  void set_test_stage(struct svm_test *test, int s);
>  void inc_test_stage(struct svm_test *test);
> +void vmcb_save_intercepts(struct vmcb *vmcb, u32 *saved_intercepts);
> +void vmcb_restore_intercepts(struct vmcb *vmcb, u32 *saved_intercepts);
>  void vmcb_ident(struct vmcb *vmcb);
>  struct regs get_regs(void);
>  void vmmcall(void);
> @@ -441,6 +497,16 @@ void test_set_guest(test_guest_func func);
>  
>  extern struct vmcb *vmcb;
>  
> +static inline void vmcb_set_intercept(u64 val)
> +{
> +	__set_bit(val, vmcb->control.intercept);
> +}
> +
> +static inline void vmcb_clear_intercept(u64 val)
> +{
> +	__clear_bit(val, vmcb->control.intercept);
> +}
> +
>  static inline void stgi(void)
>  {
>      asm volatile ("stgi");
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index 3761647642542..e732fb4eeea38 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -63,7 +63,7 @@ static bool null_check(struct svm_test *test)
>  
>  static void prepare_no_vmrun_int(struct svm_test *test)
>  {
> -	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMRUN);
> +	vmcb_clear_intercept(INTERCEPT_VMRUN);
>  }
>  
>  static bool check_no_vmrun_int(struct svm_test *test)
> @@ -84,8 +84,8 @@ static bool check_vmrun(struct svm_test *test)
>  static void prepare_rsm_intercept(struct svm_test *test)
>  {
>  	default_prepare(test);
> -	vmcb->control.intercept |= 1 << INTERCEPT_RSM;
> -	vmcb->control.intercept_exceptions |= (1ULL << UD_VECTOR);
> +	vmcb_set_intercept(INTERCEPT_RSM);
> +	vmcb_set_intercept(INTERCEPT_EXCEPTION_OFFSET + UD_VECTOR);
>  }
>  
>  static void test_rsm_intercept(struct svm_test *test)
> @@ -107,7 +107,7 @@ static bool finished_rsm_intercept(struct svm_test *test)
>  				    vmcb->control.exit_code);
>  			return true;
>  		}
> -		vmcb->control.intercept &= ~(1 << INTERCEPT_RSM);
> +		vmcb_clear_intercept(INTERCEPT_RSM);
>  		inc_test_stage(test);
>  		break;
>  
> @@ -132,7 +132,7 @@ static void prepare_sel_cr0_intercept(struct svm_test *test)
>  	/* Clear CR0.MP and CR0.CD as the tests will set either of them */
>  	vmcb->save.cr0 &= ~X86_CR0_MP;
>  	vmcb->save.cr0 &= ~X86_CR0_CD;
> -	vmcb->control.intercept |= (1ULL << INTERCEPT_SELECTIVE_CR0);
> +	vmcb_set_intercept(INTERCEPT_SELECTIVE_CR0);
>  }
>  
>  static void prepare_sel_nonsel_cr0_intercepts(struct svm_test *test)
> @@ -140,8 +140,8 @@ static void prepare_sel_nonsel_cr0_intercepts(struct svm_test *test)
>  	/* Clear CR0.MP and CR0.CD as the tests will set either of them */
>  	vmcb->save.cr0 &= ~X86_CR0_MP;
>  	vmcb->save.cr0 &= ~X86_CR0_CD;
> -	vmcb->control.intercept_cr_write |= (1ULL << 0);
> -	vmcb->control.intercept |= (1ULL << INTERCEPT_SELECTIVE_CR0);
> +	vmcb_set_intercept(INTERCEPT_CR0_WRITE);
> +	vmcb_set_intercept(INTERCEPT_SELECTIVE_CR0);
>  }
>  
>  static void __test_cr0_write_bit(struct svm_test *test, unsigned long bit,
> @@ -218,7 +218,7 @@ static bool check_cr0_nointercept(struct svm_test *test)
>  static void prepare_cr3_intercept(struct svm_test *test)
>  {
>  	default_prepare(test);
> -	vmcb->control.intercept_cr_read |= 1 << 3;
> +	vmcb_set_intercept(INTERCEPT_CR3_READ);
>  }
>  
>  static void test_cr3_intercept(struct svm_test *test)
> @@ -252,7 +252,7 @@ static void corrupt_cr3_intercept_bypass(void *_test)
>  static void prepare_cr3_intercept_bypass(struct svm_test *test)
>  {
>  	default_prepare(test);
> -	vmcb->control.intercept_cr_read |= 1 << 3;
> +	vmcb_set_intercept(INTERCEPT_CR3_READ);
>  	on_cpu_async(1, corrupt_cr3_intercept_bypass, test);
>  }
>  
> @@ -272,8 +272,7 @@ static void test_cr3_intercept_bypass(struct svm_test *test)
>  static void prepare_dr_intercept(struct svm_test *test)
>  {
>  	default_prepare(test);
> -	vmcb->control.intercept_dr_read = 0xff;
> -	vmcb->control.intercept_dr_write = 0xff;
> +	vmcb->control.intercept[INTERCEPT_DR] = 0xff00ff;
>  }
>  
>  static void test_dr_intercept(struct svm_test *test)
> @@ -390,7 +389,7 @@ static bool next_rip_supported(void)
>  
>  static void prepare_next_rip(struct svm_test *test)
>  {
> -	vmcb->control.intercept |= (1ULL << INTERCEPT_RDTSC);
> +	vmcb_set_intercept(INTERCEPT_RDTSC);
>  }
>  
>  
> @@ -416,7 +415,7 @@ static bool is_x2apic;
>  static void prepare_msr_intercept(struct svm_test *test)
>  {
>  	default_prepare(test);
> -	vmcb->control.intercept |= (1ULL << INTERCEPT_MSR_PROT);
> +	vmcb_set_intercept(INTERCEPT_MSR_PROT);
>  
>  	memset(msr_bitmap, 0, MSR_BITMAP_SIZE);
>  
> @@ -663,10 +662,10 @@ static bool check_msr_intercept(struct svm_test *test)
>  
>  static void prepare_mode_switch(struct svm_test *test)
>  {
> -	vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR)
> -		|  (1ULL << UD_VECTOR)
> -		|  (1ULL << DF_VECTOR)
> -		|  (1ULL << PF_VECTOR);
> +	vmcb_set_intercept(INTERCEPT_EXCEPTION_OFFSET + GP_VECTOR);
> +	vmcb_set_intercept(INTERCEPT_EXCEPTION_OFFSET + UD_VECTOR);
> +	vmcb_set_intercept(INTERCEPT_EXCEPTION_OFFSET + DF_VECTOR);
> +	vmcb_set_intercept(INTERCEPT_EXCEPTION_OFFSET + DF_VECTOR);
>  	test->scratch = 0;
>  }
>  
> @@ -773,7 +772,7 @@ extern u8 *io_bitmap;
>  
>  static void prepare_ioio(struct svm_test *test)
>  {
> -	vmcb->control.intercept |= (1ULL << INTERCEPT_IOIO_PROT);
> +	vmcb_set_intercept(INTERCEPT_IOIO_PROT);
>  	test->scratch = 0;
>  	memset(io_bitmap, 0, 8192);
>  	io_bitmap[8192] = 0xFF;
> @@ -1171,7 +1170,7 @@ static void pending_event_prepare(struct svm_test *test)
>  
>  	pending_event_guest_run = false;
>  
> -	vmcb->control.intercept |= (1ULL << INTERCEPT_INTR);
> +	vmcb_set_intercept(INTERCEPT_INTR);
>  	vmcb->control.int_ctl |= V_INTR_MASKING_MASK;
>  
>  	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL |
> @@ -1195,7 +1194,7 @@ static bool pending_event_finished(struct svm_test *test)
>  			return true;
>  		}
>  
> -		vmcb->control.intercept &= ~(1ULL << INTERCEPT_INTR);
> +		vmcb_clear_intercept(INTERCEPT_INTR);
>  		vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
>  
>  		if (pending_event_guest_run) {
> @@ -1400,7 +1399,7 @@ static bool interrupt_finished(struct svm_test *test)
>  		}
>  		vmcb->save.rip += 3;
>  
> -		vmcb->control.intercept |= (1ULL << INTERCEPT_INTR);
> +		vmcb_set_intercept(INTERCEPT_INTR);
>  		vmcb->control.int_ctl |= V_INTR_MASKING_MASK;
>  		break;
>  
> @@ -1414,7 +1413,7 @@ static bool interrupt_finished(struct svm_test *test)
>  
>  		sti_nop_cli();
>  
> -		vmcb->control.intercept &= ~(1ULL << INTERCEPT_INTR);
> +		vmcb_clear_intercept(INTERCEPT_INTR);
>  		vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
>  		break;
>  
> @@ -1476,7 +1475,7 @@ static bool nmi_finished(struct svm_test *test)
>  		}
>  		vmcb->save.rip += 3;
>  
> -		vmcb->control.intercept |= (1ULL << INTERCEPT_NMI);
> +		vmcb_set_intercept(INTERCEPT_NMI);
>  		break;
>  
>  	case 1:
> @@ -1569,7 +1568,7 @@ static bool nmi_hlt_finished(struct svm_test *test)
>  		}
>  		vmcb->save.rip += 3;
>  
> -		vmcb->control.intercept |= (1ULL << INTERCEPT_NMI);
> +		vmcb_set_intercept(INTERCEPT_NMI);
>  		break;
>  
>  	case 2:
> @@ -1605,7 +1604,7 @@ static void vnmi_prepare(struct svm_test *test)
>  	 * Disable NMI interception to start.  Enabling vNMI without
>  	 * intercepting "real" NMIs should result in an ERR VM-Exit.
>  	 */
> -	vmcb->control.intercept &= ~(1ULL << INTERCEPT_NMI);
> +	vmcb_clear_intercept(INTERCEPT_NMI);
>  	vmcb->control.int_ctl = V_NMI_ENABLE_MASK;
>  	vmcb->control.int_vector = NMI_VECTOR;
>  }
> @@ -1629,7 +1628,7 @@ static bool vnmi_finished(struct svm_test *test)
>  			return true;
>  		}
>  		report(!nmi_fired, "vNMI enabled but NMI_INTERCEPT unset!");
> -		vmcb->control.intercept |= (1ULL << INTERCEPT_NMI);
> +		vmcb_set_intercept(INTERCEPT_NMI);
>  		vmcb->save.rip += 3;
>  		break;
>  
> @@ -1804,7 +1803,7 @@ static bool virq_inject_finished(struct svm_test *test)
>  			return true;
>  		}
>  		virq_fired = false;
> -		vmcb->control.intercept |= (1ULL << INTERCEPT_VINTR);
> +		vmcb_set_intercept(INTERCEPT_VINTR);
>  		vmcb->control.int_ctl = V_INTR_MASKING_MASK | V_IRQ_MASK |
>  			(0x0f << V_INTR_PRIO_SHIFT);
>  		break;
> @@ -1819,7 +1818,7 @@ static bool virq_inject_finished(struct svm_test *test)
>  			report_fail("V_IRQ fired before SVM_EXIT_VINTR");
>  			return true;
>  		}
> -		vmcb->control.intercept &= ~(1ULL << INTERCEPT_VINTR);
> +		vmcb_clear_intercept(INTERCEPT_VINTR);
>  		break;
>  
>  	case 2:
> @@ -1842,7 +1841,7 @@ static bool virq_inject_finished(struct svm_test *test)
>  				    vmcb->control.exit_code);
>  			return true;
>  		}
> -		vmcb->control.intercept |= (1ULL << INTERCEPT_VINTR);
> +		vmcb_set_intercept(INTERCEPT_VINTR);
>  		break;
>  
>  	case 4:
> @@ -1943,7 +1942,7 @@ static void reg_corruption_prepare(struct svm_test *test)
>  	set_test_stage(test, 0);
>  
>  	vmcb->control.int_ctl = V_INTR_MASKING_MASK;
> -	vmcb->control.intercept |= (1ULL << INTERCEPT_INTR);
> +	vmcb_set_intercept(INTERCEPT_INTR);
>  
>  	handle_irq(TIMER_VECTOR, reg_corruption_isr);
>  
> @@ -2050,7 +2049,7 @@ static volatile bool init_intercept;
>  static void init_intercept_prepare(struct svm_test *test)
>  {
>  	init_intercept = false;
> -	vmcb->control.intercept |= (1ULL << INTERCEPT_INIT);
> +	vmcb_set_intercept(INTERCEPT_INIT);
>  }
>  
>  static void init_intercept_test(struct svm_test *test)
> @@ -2547,7 +2546,7 @@ static void test_dr(void)
>  /* TODO: verify if high 32-bits are sign- or zero-extended on bare metal */
>  #define	TEST_BITMAP_ADDR(save_intercept, type, addr, exit_code,		\
>  			 msg) {						\
> -		vmcb->control.intercept = saved_intercept | 1ULL << type; \
> +		vmcb_set_intercept(type); \
>  		if (type == INTERCEPT_MSR_PROT)				\
>  			vmcb->control.msrpm_base_pa = addr;		\
>  		else							\
> @@ -2574,48 +2573,50 @@ static void test_dr(void)
>   */
>  static void test_msrpm_iopm_bitmap_addrs(void)
>  {
> -	u64 saved_intercept = vmcb->control.intercept;
> +	u32 saved_intercepts[MAX_INTERCEPT];
>  	u64 addr_beyond_limit = 1ull << cpuid_maxphyaddr();
>  	u64 addr = virt_to_phys(msr_bitmap) & (~((1ull << 12) - 1));
>  
> -	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_MSR_PROT,
> +	vmcb_save_intercepts(vmcb, saved_intercepts);
> +
> +	TEST_BITMAP_ADDR(saved_intercepts, INTERCEPT_MSR_PROT,
>  			 addr_beyond_limit - 2 * PAGE_SIZE, SVM_EXIT_ERR,
>  			 "MSRPM");
> -	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_MSR_PROT,
> +	TEST_BITMAP_ADDR(saved_intercepts, INTERCEPT_MSR_PROT,
>  			 addr_beyond_limit - 2 * PAGE_SIZE + 1, SVM_EXIT_ERR,
>  			 "MSRPM");
> -	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_MSR_PROT,
> +	TEST_BITMAP_ADDR(saved_intercepts, INTERCEPT_MSR_PROT,
>  			 addr_beyond_limit - PAGE_SIZE, SVM_EXIT_ERR,
>  			 "MSRPM");
> -	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_MSR_PROT, addr,
> +	TEST_BITMAP_ADDR(saved_intercepts, INTERCEPT_MSR_PROT, addr,
>  			 SVM_EXIT_VMMCALL, "MSRPM");
>  	addr |= (1ull << 12) - 1;
>  	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_MSR_PROT, addr,
>  			 SVM_EXIT_VMMCALL, "MSRPM");
>  
> -	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT,
> +	TEST_BITMAP_ADDR(saved_intercepts, INTERCEPT_IOIO_PROT,
>  			 addr_beyond_limit - 4 * PAGE_SIZE, SVM_EXIT_VMMCALL,
>  			 "IOPM");
> -	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT,
> +	TEST_BITMAP_ADDR(saved_intercepts, INTERCEPT_IOIO_PROT,
>  			 addr_beyond_limit - 3 * PAGE_SIZE, SVM_EXIT_VMMCALL,
>  			 "IOPM");
> -	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT,
> +	TEST_BITMAP_ADDR(saved_intercepts, INTERCEPT_IOIO_PROT,
>  			 addr_beyond_limit - 2 * PAGE_SIZE - 2, SVM_EXIT_VMMCALL,
>  			 "IOPM");
> -	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT,
> +	TEST_BITMAP_ADDR(saved_intercepts, INTERCEPT_IOIO_PROT,
>  			 addr_beyond_limit - 2 * PAGE_SIZE, SVM_EXIT_ERR,
>  			 "IOPM");
> -	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT,
> +	TEST_BITMAP_ADDR(saved_intercepts, INTERCEPT_IOIO_PROT,
>  			 addr_beyond_limit - PAGE_SIZE, SVM_EXIT_ERR,
>  			 "IOPM");
>  	addr = virt_to_phys(io_bitmap) & (~((1ull << 11) - 1));
> -	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT, addr,
> +	TEST_BITMAP_ADDR(saved_intercepts, INTERCEPT_IOIO_PROT, addr,
>  			 SVM_EXIT_VMMCALL, "IOPM");
>  	addr |= (1ull << 12) - 1;
> -	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT, addr,
> +	TEST_BITMAP_ADDR(saved_intercepts, INTERCEPT_IOIO_PROT, addr,
>  			 SVM_EXIT_VMMCALL, "IOPM");
>  
> -	vmcb->control.intercept = saved_intercept;
> +	vmcb_restore_intercepts(vmcb, saved_intercepts);
>  }
>  
>  /*
> @@ -2811,16 +2812,17 @@ static void vmload_vmsave_guest_main(struct svm_test *test)
>  
>  static void svm_vmload_vmsave(void)
>  {
> -	u32 intercept_saved = vmcb->control.intercept;
> +	u32 saved_intercepts[MAX_INTERCEPT];
>  
> +	vmcb_save_intercepts(vmcb, saved_intercepts);
>  	test_set_guest(vmload_vmsave_guest_main);
>  
>  	/*
>  	 * Disabling intercept for VMLOAD and VMSAVE doesn't cause
>  	 * respective #VMEXIT to host
>  	 */
> -	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMLOAD);
> -	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMSAVE);
> +	vmcb_clear_intercept(INTERCEPT_VMLOAD);
> +	vmcb_clear_intercept(INTERCEPT_VMSAVE);
>  	svm_vmrun();
>  	report(vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
>  	       "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
> @@ -2829,39 +2831,39 @@ static void svm_vmload_vmsave(void)
>  	 * Enabling intercept for VMLOAD and VMSAVE causes respective
>  	 * #VMEXIT to host
>  	 */
> -	vmcb->control.intercept |= (1ULL << INTERCEPT_VMLOAD);
> +	vmcb_set_intercept(INTERCEPT_VMLOAD);
>  	svm_vmrun();
>  	report(vmcb->control.exit_code == SVM_EXIT_VMLOAD, "Test "
>  	       "VMLOAD/VMSAVE intercept: Expected VMLOAD #VMEXIT");
> -	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMLOAD);
> -	vmcb->control.intercept |= (1ULL << INTERCEPT_VMSAVE);
> +	vmcb_clear_intercept(INTERCEPT_VMLOAD);
> +	vmcb_set_intercept(INTERCEPT_VMSAVE);
>  	svm_vmrun();
>  	report(vmcb->control.exit_code == SVM_EXIT_VMSAVE, "Test "
>  	       "VMLOAD/VMSAVE intercept: Expected VMSAVE #VMEXIT");
> -	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMSAVE);
> +	vmcb_clear_intercept(INTERCEPT_VMSAVE);
>  	svm_vmrun();
>  	report(vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
>  	       "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
>  
> -	vmcb->control.intercept |= (1ULL << INTERCEPT_VMLOAD);
> +	vmcb_set_intercept(INTERCEPT_VMLOAD);
>  	svm_vmrun();
>  	report(vmcb->control.exit_code == SVM_EXIT_VMLOAD, "Test "
>  	       "VMLOAD/VMSAVE intercept: Expected VMLOAD #VMEXIT");
> -	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMLOAD);
> +	vmcb_clear_intercept(INTERCEPT_VMLOAD);
>  	svm_vmrun();
>  	report(vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
>  	       "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
>  
> -	vmcb->control.intercept |= (1ULL << INTERCEPT_VMSAVE);
> +	vmcb_set_intercept(INTERCEPT_VMSAVE);
>  	svm_vmrun();
>  	report(vmcb->control.exit_code == SVM_EXIT_VMSAVE, "Test "
>  	       "VMLOAD/VMSAVE intercept: Expected VMSAVE #VMEXIT");
> -	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMSAVE);
> +	vmcb_clear_intercept(INTERCEPT_VMSAVE);
>  	svm_vmrun();
>  	report(vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
>  	       "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
>  
> -	vmcb->control.intercept = intercept_saved;
> +	vmcb_restore_intercepts(vmcb, saved_intercepts);
>  }
>  
>  static void prepare_vgif_enabled(struct svm_test *test)
> @@ -2974,7 +2976,7 @@ static void pause_filter_test(void)
>  		return;
>  	}
>  
> -	vmcb->control.intercept |= (1 << INTERCEPT_PAUSE);
> +	vmcb_set_intercept(INTERCEPT_PAUSE);
>  
>  	// filter count more that pause count - no VMexit
>  	pause_filter_run_test(10, 9, 0, 0);
> @@ -3356,7 +3358,7 @@ static void svm_intr_intercept_mix_if(void)
>  	// make a physical interrupt to be pending
>  	handle_irq(0x55, dummy_isr);
>  
> -	vmcb->control.intercept |= (1 << INTERCEPT_INTR);
> +	vmcb_set_intercept(INTERCEPT_INTR);
>  	vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
>  	vmcb->save.rflags &= ~X86_EFLAGS_IF;
>  
> @@ -3389,7 +3391,7 @@ static void svm_intr_intercept_mix_gif(void)
>  {
>  	handle_irq(0x55, dummy_isr);
>  
> -	vmcb->control.intercept |= (1 << INTERCEPT_INTR);
> +	vmcb_set_intercept(INTERCEPT_INTR);
>  	vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
>  	vmcb->save.rflags &= ~X86_EFLAGS_IF;
>  
> @@ -3419,7 +3421,7 @@ static void svm_intr_intercept_mix_gif2(void)
>  {
>  	handle_irq(0x55, dummy_isr);
>  
> -	vmcb->control.intercept |= (1 << INTERCEPT_INTR);
> +	vmcb_set_intercept(INTERCEPT_INTR);
>  	vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
>  	vmcb->save.rflags |= X86_EFLAGS_IF;
>  
> @@ -3448,7 +3450,7 @@ static void svm_intr_intercept_mix_nmi(void)
>  {
>  	handle_exception(2, dummy_nmi_handler);
>  
> -	vmcb->control.intercept |= (1 << INTERCEPT_NMI);
> +	vmcb_set_intercept(INTERCEPT_NMI);
>  	vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
>  	vmcb->save.rflags |= X86_EFLAGS_IF;
>  
> @@ -3472,7 +3474,7 @@ static void svm_intr_intercept_mix_smi_guest(struct svm_test *test)
>  
>  static void svm_intr_intercept_mix_smi(void)
>  {
> -	vmcb->control.intercept |= (1 << INTERCEPT_SMI);
> +	vmcb_set_intercept(INTERCEPT_SMI);
>  	vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
>  	test_set_guest(svm_intr_intercept_mix_smi_guest);
>  	svm_intr_intercept_mix_run_guest(NULL, SVM_EXIT_SMI);
> @@ -3530,14 +3532,14 @@ static void handle_exception_in_l2(u8 vector)
>  
>  static void handle_exception_in_l1(u32 vector)
>  {
> -	u32 old_ie = vmcb->control.intercept_exceptions;
> +	u32 old_ie = vmcb->control.intercept[INTERCEPT_EXCEPTION];
>  
> -	vmcb->control.intercept_exceptions |= (1ULL << vector);
> +	vmcb_set_intercept(INTERCEPT_EXCEPTION_OFFSET + vector);
>  
>  	report(svm_vmrun() == (SVM_EXIT_EXCP_BASE + vector),
>  		"%s handled by L1",  exception_mnemonic(vector));
>  
> -	vmcb->control.intercept_exceptions = old_ie;
> +	vmcb->control.intercept[INTERCEPT_EXCEPTION] = old_ie;
>  }
>  
>  static void svm_exception_test(void)
> @@ -3568,7 +3570,7 @@ static void svm_shutdown_intercept_test(void)
>  {
>  	test_set_guest(shutdown_intercept_test_guest);
>  	vmcb->save.idtr.base = (u64)alloc_vpage();
> -	vmcb->control.intercept |= (1ULL << INTERCEPT_SHUTDOWN);
> +	vmcb_set_intercept(INTERCEPT_SHUTDOWN);
>  	svm_vmrun();
>  	report(vmcb->control.exit_code == SVM_EXIT_SHUTDOWN, "shutdown test passed");
>  }
> -- 
> 2.52.0.239.gd5f0c6e74e-goog
> 

