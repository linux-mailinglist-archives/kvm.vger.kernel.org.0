Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C3B66DB5A
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 11:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236082AbjAQKmd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 05:42:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236504AbjAQKmQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 05:42:16 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE645C171;
        Tue, 17 Jan 2023 02:42:14 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id p66so14724452iof.1;
        Tue, 17 Jan 2023 02:42:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p9RSB0BhHGTXVHOfWxtaA4bX1SBCybHhxqLyFrdPZmE=;
        b=k8VWcZVdA05kSA3xmlJoYb7deCbUU9YjweO55XWNW4IfmDji/qslO9QQG9m4fwrW0N
         yDANrDzpDb+aa3G0ReKthCtjWKUilbiw6OCCLtw9nGDE1YAK5vUtyyaNQqVtEJ5eU5RK
         Keva839sBX3DoYG/ed64sXzwvfX2BtVUr6UuXYUw3xVR6AGd9BQ+oL/ojZa+sn0WU/ZP
         MJgFUhM4xz2x5RLy2D40xA+xdEhLuhW12oybtD24zSpYsXRej17/iEcV98MhQa2d7+2e
         XCRI/T9r+DFwFJqu6bP1mPUXRyhPXSH7sMfo70XkZ3JWntRuhFeFPxCMbf7S0AfVmK4B
         obOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p9RSB0BhHGTXVHOfWxtaA4bX1SBCybHhxqLyFrdPZmE=;
        b=qx4ZPuiLuT7844bR/0siKvDDcW/VK0TCNCZrrT5iwQ/V3YpbMkPIwauP36dY+CInpy
         nu+/Wr/YhrYqzXthOUPRDRcnp5Z5KB7FMQyLI08+IE+uhZ86s0wKTJFQj3RZJE4igP1N
         OH9n892AmtEW8rzG6O6zB5F6kFqQvz+iknuZ+SpCar1iL7eIst7k9vkmTonZXHAN8R23
         DIMYTj3L+c6c4ck4LmxCVX6Y8D5IT0+sQNSEsN/NeSnr9FMIKQaIuiU3C+cWS8ah4MNl
         PmPcTqY+T88lm1O2EFfUvi9VvFQQImZGQFTN9GYwSupEaAiT8f0I1t9Gc+yEUkYQ5aOL
         eILA==
X-Gm-Message-State: AFqh2kpz1kp2M1RVc9nhehS0a9F9iJ/j4Hx/T3ehl4E5fwqom+aHMI9G
        /akZisC5HvmkVA1ZDACR9xA=
X-Google-Smtp-Source: AMrXdXsMjVzneQpnFD6YPzKcweoY87blKu8zb74uOTZ5iPScbWTixKwHYR/SUZP1V6RilnHO1ozs/Q==
X-Received: by 2002:a6b:b2d0:0:b0:6e2:d939:4f30 with SMTP id b199-20020a6bb2d0000000b006e2d9394f30mr385034iof.0.1673952134013;
        Tue, 17 Jan 2023 02:42:14 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id g11-20020a02a08b000000b0038a3b8aaf11sm7656852jah.37.2023.01.17.02.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 02:42:13 -0800 (PST)
Date:   Tue, 17 Jan 2023 12:42:03 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jarkko Sakkinen <jarkko.sakkinen@profian.com>
Subject: Re: [PATCH RFC v7 20/64] x86/fault: Add support to handle the RMP
 fault for user address
Message-ID: <20230117124203.00001961@gmail.com>
In-Reply-To: <20221214194056.161492-21-michael.roth@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
        <20221214194056.161492-21-michael.roth@amd.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 14 Dec 2022 13:40:12 -0600
Michael Roth <michael.roth@amd.com> wrote:

> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> When SEV-SNP is enabled globally, a write from the host goes through the
> RMP check. When the host writes to pages, hardware checks the following
> conditions at the end of page walk:
> 
> 1. Assigned bit in the RMP table is zero (i.e page is shared).
> 2. If the page table entry that gives the sPA indicates that the target
>    page size is a large page, then all RMP entries for the 4KB
>    constituting pages of the target must have the assigned bit 0.
> 3. Immutable bit in the RMP table is not zero.
> 

Just being curious. AMD APM table 15-37 "RMP Page Assignment Settings" shows
Immuable bit is "don't care" when a page is owned by the hypervisor. The 
table 15-39 "RMP Memory Access Checks" shows the hardware will do
"Hypervisor-owned" check for host data write and page table access. I suppose
"Hypervisor-owned" check means HW will check if the RMP entry is configured
according to the table 15-37 (Assign bit = 0, ASID = 0, Immutable = X)

None of them mentions that Immutable bit in the related RMP-entry should
be 1 for hypervisor-owned page.

I can understand 1) 2). Can you explain more about 3)?

> The hardware will raise page fault if one of the above conditions is not
> met. Try resolving the fault instead of taking fault again and again. If
> the host attempts to write to the guest private memory then send the
> SIGBUS signal to kill the process. If the page level between the host and
> RMP entry does not match, then split the address to keep the RMP and host
> page levels in sync.
> 
> Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@profian.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@profian.com>
> Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/mm/fault.c      | 97 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/mm.h       |  3 +-
>  include/linux/mm_types.h |  3 ++
>  mm/memory.c              | 10 +++++
>  4 files changed, 112 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index f8193b99e9c8..d611051dcf1e 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -33,6 +33,7 @@
>  #include <asm/kvm_para.h>		/* kvm_handle_async_pf		*/
>  #include <asm/vdso.h>			/* fixup_vdso_exception()	*/
>  #include <asm/irq_stack.h>
> +#include <asm/sev.h>			/* snp_lookup_rmpentry()	*/
>  
>  #define CREATE_TRACE_POINTS
>  #include <asm/trace/exceptions.h>
> @@ -414,6 +415,7 @@ static void dump_pagetable(unsigned long address)
>  	pr_cont("PTE %lx", pte_val(*pte));
>  out:
>  	pr_cont("\n");
> +
>  	return;
>  bad:
>  	pr_info("BAD\n");
> @@ -1240,6 +1242,90 @@ do_kern_addr_fault(struct pt_regs *regs, unsigned long hw_error_code,
>  }
>  NOKPROBE_SYMBOL(do_kern_addr_fault);
>  
> +enum rmp_pf_ret {
> +	RMP_PF_SPLIT	= 0,
> +	RMP_PF_RETRY	= 1,
> +	RMP_PF_UNMAP	= 2,
> +};
> +
> +/*
> + * The goal of RMP faulting routine is really to check whether the
> + * page that faulted should be accessible.  That can be determined
> + * simply by looking at the RMP entry for the 4k address being accessed.
> + * If that entry has Assigned=1 then it's a bad address. It could be
> + * because the 2MB region was assigned as a large page, or it could be
> + * because the region is all 4k pages and that 4k was assigned.
> + * In either case, it's a bad access.
> + * There are basically two main possibilities:
> + * 1. The 2M entry has Assigned=1 and Page_Size=1. Then all 511 middle
> + * entries also have Assigned=1. This entire 2M region is a guest page.
> + * 2. The 2M entry has Assigned=0 and Page_Size=0. Then the 511 middle
> + * entries can be anything, this region consists of individual 4k assignments.
> + */
> +static int handle_user_rmp_page_fault(struct pt_regs *regs, unsigned long error_code,
> +				      unsigned long address)
> +{
> +	int rmp_level, level;
> +	pgd_t *pgd;
> +	pte_t *pte;
> +	u64 pfn;
> +
> +	pgd = __va(read_cr3_pa());
> +	pgd += pgd_index(address);
> +
> +	pte = lookup_address_in_pgd(pgd, address, &level);
> +
> +	/*
> +	 * It can happen if there was a race between an unmap event and
> +	 * the RMP fault delivery.
> +	 */
> +	if (!pte || !pte_present(*pte))
> +		return RMP_PF_UNMAP;
> +
> +	/*
> +	 * RMP page fault handler follows this algorithm:
> +	 * 1. Compute the pfn for the 4kb page being accessed
> +	 * 2. Read that RMP entry -- If it is assigned then kill the process
> +	 * 3. Otherwise, check the level from the host page table
> +	 *    If level=PG_LEVEL_4K then the page is already smashed
> +	 *    so just retry the instruction
> +	 * 4. If level=PG_LEVEL_2M/1G, then the host page needs to be split
> +	 */
> +
> +	pfn = pte_pfn(*pte);
> +
> +	/* If its large page then calculte the fault pfn */
> +	if (level > PG_LEVEL_4K)
> +		pfn = pfn | PFN_DOWN(address & (page_level_size(level) - 1));
> +
> +	/*
> +	 * If its a guest private page, then the fault cannot be resolved.
> +	 * Send a SIGBUS to terminate the process.
> +	 *
> +	 * As documented in APM vol3 pseudo-code for RMPUPDATE, when the 2M range
> +	 * is covered by a valid (Assigned=1) 2M entry, the middle 511 4k entries
> +	 * also have Assigned=1. This means that if there is an access to a page
> +	 * which happens to lie within an Assigned 2M entry, the 4k RMP entry
> +	 * will also have Assigned=1. Therefore, the kernel should see that
> +	 * the page is not a valid page and the fault cannot be resolved.
> +	 */
> +	if (snp_lookup_rmpentry(pfn, &rmp_level)) {
> +		pr_info("Fatal RMP page fault, terminating process, entry assigned for pfn 0x%llx\n",
> +			pfn);
> +		do_sigbus(regs, error_code, address, VM_FAULT_SIGBUS);
> +		return RMP_PF_RETRY;
> +	}
> +
> +	/*
> +	 * The backing page level is higher than the RMP page level, request
> +	 * to split the page.
> +	 */
> +	if (level > rmp_level)
> +		return RMP_PF_SPLIT;
> +
> +	return RMP_PF_RETRY;
> +}
> +
>  /*
>   * Handle faults in the user portion of the address space.  Nothing in here
>   * should check X86_PF_USER without a specific justification: for almost
> @@ -1337,6 +1423,17 @@ void do_user_addr_fault(struct pt_regs *regs,
>  	if (error_code & X86_PF_INSTR)
>  		flags |= FAULT_FLAG_INSTRUCTION;
>  
> +	/*
> +	 * If its an RMP violation, try resolving it.
> +	 */
> +	if (error_code & X86_PF_RMP) {
> +		if (handle_user_rmp_page_fault(regs, error_code, address))
> +			return;
> +
> +		/* Ask to split the page */
> +		flags |= FAULT_FLAG_PAGE_SPLIT;
> +	}
> +
>  #ifdef CONFIG_X86_64
>  	/*
>  	 * Faults in the vsyscall page might need emulation.  The
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 3c84f4e48cd7..2fd8e16d149c 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -466,7 +466,8 @@ static inline bool fault_flag_allow_retry_first(enum fault_flag flags)
>  	{ FAULT_FLAG_USER,		"USER" }, \
>  	{ FAULT_FLAG_REMOTE,		"REMOTE" }, \
>  	{ FAULT_FLAG_INSTRUCTION,	"INSTRUCTION" }, \
> -	{ FAULT_FLAG_INTERRUPTIBLE,	"INTERRUPTIBLE" }
> +	{ FAULT_FLAG_INTERRUPTIBLE,	"INTERRUPTIBLE" }, \
> +	{ FAULT_FLAG_PAGE_SPLIT,	"PAGESPLIT" }
>  
>  /*
>   * vm_fault is filled by the pagefault handler and passed to the vma's
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 500e536796ca..06ba34d51638 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -962,6 +962,8 @@ typedef struct {
>   *                      mapped R/O.
>   * @FAULT_FLAG_ORIG_PTE_VALID: whether the fault has vmf->orig_pte cached.
>   *                        We should only access orig_pte if this flag set.
> + * @FAULT_FLAG_PAGE_SPLIT: The fault was due page size mismatch, split the
> + *                         region to smaller page size and retry.
>   *
>   * About @FAULT_FLAG_ALLOW_RETRY and @FAULT_FLAG_TRIED: we can specify
>   * whether we would allow page faults to retry by specifying these two
> @@ -999,6 +1001,7 @@ enum fault_flag {
>  	FAULT_FLAG_INTERRUPTIBLE =	1 << 9,
>  	FAULT_FLAG_UNSHARE =		1 << 10,
>  	FAULT_FLAG_ORIG_PTE_VALID =	1 << 11,
> +	FAULT_FLAG_PAGE_SPLIT =		1 << 12,
>  };
>  
>  typedef unsigned int __bitwise zap_flags_t;
> diff --git a/mm/memory.c b/mm/memory.c
> index f88c351aecd4..e68da7e403c6 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4996,6 +4996,12 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
>  	return 0;
>  }
>  
> +static int handle_split_page_fault(struct vm_fault *vmf)
> +{
> +	__split_huge_pmd(vmf->vma, vmf->pmd, vmf->address, false, NULL);
> +	return 0;
> +}
> +
>  /*
>   * By the time we get here, we already hold the mm semaphore
>   *
> @@ -5078,6 +5084,10 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
>  				pmd_migration_entry_wait(mm, vmf.pmd);
>  			return 0;
>  		}
> +
> +		if (flags & FAULT_FLAG_PAGE_SPLIT)
> +			return handle_split_page_fault(&vmf);
> +
>  		if (pmd_trans_huge(vmf.orig_pmd) || pmd_devmap(vmf.orig_pmd)) {
>  			if (pmd_protnone(vmf.orig_pmd) && vma_is_accessible(vma))
>  				return do_huge_pmd_numa_page(&vmf);

