Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08FC289F60
	for <lists+kvm@lfdr.de>; Sat, 10 Oct 2020 10:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730084AbgJJIb1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Oct 2020 04:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729998AbgJJIRl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Oct 2020 04:17:41 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F93C0613D5
        for <kvm@vger.kernel.org>; Sat, 10 Oct 2020 01:17:41 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d1so495589pfc.0
        for <kvm@vger.kernel.org>; Sat, 10 Oct 2020 01:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=JmfhJhv2NHxxbb4qDndk7dXF8DUuGBOHJg+qIPTijck=;
        b=AW2QRriAQLiWs6Oo+zl5g+8I1vSYuzWKPnWotxYglAXShw31TdhjfQTIk7LkBLv0xD
         z0Jy2ZdOvXl93Dh5TI+wuTPBs4yw7FcVUUuky85i5RjHxIrlrA8MIoSLJ2/maeeSIKDK
         KDThTQD6uUFnXa639s+3D8Jp5QhYCwKbUszEuMskpILj7krxchVr3W1ao1n65j3fSf7S
         5EUmTFPYL53DRyQru4jxZYJUdzq/Fi7Nic8KSiJsjg+3sFVCmf9OWHfuFKPuVaxWNXo9
         mjTmJHAzsz8j3umFW4Vc6HOsa5NADBtd2v+NFi2KQXUJiALYuwECJgrsBDRXLuWxr1MT
         3wEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=JmfhJhv2NHxxbb4qDndk7dXF8DUuGBOHJg+qIPTijck=;
        b=kyPBYS4aHNSENbGSDCJM2JjBEcgh8Qjshh9WjmDoCnzgyRObq/P24KaBDahFdHpG6G
         9gqjfasL5IIpZj/zHkVpdEdk6/XdstfWVjQabrPh3GiC+PZ4dENytOvgrv6HJuqIUfYe
         5SN/AzYr78aLor5Ylq92NksWo14Jh7RJpZrlAdOTLgQXa72zmMNi/8IiscTnJxrOMmoB
         Xy104gdgrVKYO7ELo2wk7lS4Vin0Ja8W+cvV1dGB+BqF8N+V9d1CcddPHIj6sT6153iN
         Q1Nj3060N+HrrgIwyHS2vjYC1dKqXVzGaxmy5Swf04JdG8aLkpzPDlFGMLnlOBc2436y
         kpTw==
X-Gm-Message-State: AOAM531j5ghRBsKpHFUhYVH5/nVrYwEQBb6Y1+aRXefnVQdgcT8TCYbU
        FCgWtvc9AMyqPY/ShAOgyi0=
X-Google-Smtp-Source: ABdhPJyJkds8czIw6qk3s3Y9LJA5MZFQKUI5xgpHHacBAN+j9JPjUOi+971xDlA4yAVxT6cdNMouBg==
X-Received: by 2002:a62:8348:0:b029:152:9d3c:c67e with SMTP id h69-20020a6283480000b02901529d3cc67emr15807586pfe.65.1602317860996;
        Sat, 10 Oct 2020 01:17:40 -0700 (PDT)
Received: from ?IPv6:2601:647:4700:9b2:25eb:9460:8682:b3b5? ([2601:647:4700:9b2:25eb:9460:8682:b3b5])
        by smtp.gmail.com with ESMTPSA id u25sm12118302pgl.31.2020.10.10.01.17.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 10 Oct 2020 01:17:40 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [kvm-unit-tests PATCH] x86: vmx: Add test for MTF on a guest
 MOV-to-CR0 that enables PAE
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20200818002537.207910-1-pshier@google.com>
Date:   Sat, 10 Oct 2020 01:17:39 -0700
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        Jim Mattson <jmattson@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <4A2666E9-2C3F-4216-9944-70AC3413C09B@gmail.com>
References: <20200818002537.207910-1-pshier@google.com>
To:     Peter Shier <pshier@google.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Aug 17, 2020, at 5:25 PM, Peter Shier <pshier@google.com> wrote:
>=20
> Verify that when L2 guest enables PAE paging and L0 intercept of L2
> MOV to CR0 reflects MTF exit to L1, subsequent resume to L2 correctly
> preserves PDPTE array specified by L2 CR3.
>=20
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by:   Peter Shier <pshier@google.com>
> Signed-off-by: Peter Shier <pshier@google.com>
> ---
> lib/x86/asm/page.h |   8 +++
> x86/vmx_tests.c    | 171 +++++++++++++++++++++++++++++++++++++++++++++
> 2 files changed, 179 insertions(+)
>=20
> diff --git a/lib/x86/asm/page.h b/lib/x86/asm/page.h
> index 7e2a3dd4b90a..1359eb74cde4 100644
> --- a/lib/x86/asm/page.h
> +++ b/lib/x86/asm/page.h
> @@ -36,10 +36,18 @@ typedef unsigned long pgd_t;
> #define PT64_NX_MASK		(1ull << 63)
> #define PT_ADDR_MASK		GENMASK_ULL(51, 12)
>=20
> +#define PDPTE64_PAGE_SIZE_MASK	  (1ull << 7)
> +#define PDPTE64_RSVD_MASK	  GENMASK_ULL(51, cpuid_maxphyaddr())
> +
> #define PT_AD_MASK              (PT_ACCESSED_MASK | PT_DIRTY_MASK)
>=20
> +#define PAE_PDPTE_RSVD_MASK     (GENMASK_ULL(63, cpuid_maxphyaddr()) =
|	\
> +				 GENMASK_ULL(8, 5) | GENMASK_ULL(2, 1))
> +
> +
> #ifdef __x86_64__
> #define	PAGE_LEVEL	4
> +#define	PDPT_LEVEL	3
> #define	PGDIR_WIDTH	9
> #define	PGDIR_MASK	511
> #else
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 32e3d4f47b33..372e5efb6b5f 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -5250,6 +5250,176 @@ static void vmx_mtf_test(void)
> 	enter_guest();
> }
>=20
> +extern char vmx_mtf_pdpte_guest_begin;
> +extern char vmx_mtf_pdpte_guest_end;
> +
> +asm("vmx_mtf_pdpte_guest_begin:\n\t"
> +    "mov %cr0, %rax\n\t"    /* save CR0 with PG=3D1                 =
*/
> +    "vmcall\n\t"            /* on return from this CR0.PG=3D0       =
*/
> +    "mov %rax, %cr0\n\t"    /* restore CR0.PG=3D1 to enter PAE mode =
*/
> +    "vmcall\n\t"
> +    "retq\n\t"
> +    "vmx_mtf_pdpte_guest_end:");
> +
> +static void vmx_mtf_pdpte_test(void)
> +{
> +	void *test_mtf_pdpte_guest;
> +	pteval_t *pdpt;
> +	u32 guest_ar_cs;
> +	u64 guest_efer;
> +	pteval_t *pte;
> +	u64 guest_cr0;
> +	u64 guest_cr3;
> +	u64 guest_cr4;
> +	u64 ent_ctls;
> +	int i;
> +
> +	if (setup_ept(false))
> +		return;
> +
> +	if (!(ctrl_cpu_rev[0].clr & CPU_MTF)) {
> +		printf("CPU does not support 'monitor trap flag.'\n");
> +		return;
> +	}
> +
> +	if (!(ctrl_cpu_rev[1].clr & CPU_URG)) {
> +		printf("CPU does not support 'unrestricted guest.'\n");
> +		return;
> +	}
> +
> +	vmcs_write(EXC_BITMAP, ~0);
> +	vmcs_write(CPU_EXEC_CTRL1, vmcs_read(CPU_EXEC_CTRL1) | CPU_URG);
> +
> +	/*
> +	 * Copy the guest code to an identity-mapped page.
> +	 */
> +	test_mtf_pdpte_guest =3D alloc_page();
> +	memcpy(test_mtf_pdpte_guest, &vmx_mtf_pdpte_guest_begin,
> +	       &vmx_mtf_pdpte_guest_end - &vmx_mtf_pdpte_guest_begin);
> +
> +	test_set_guest(test_mtf_pdpte_guest);
> +
> +	enter_guest();
> +	skip_exit_vmcall();
> +
> +	/*
> +	 * Put the guest in non-paged 32-bit protected mode, ready to =
enter
> +	 * PAE mode when CR0.PG is set. CR4.PAE will already have been =
set
> +	 * when the guest started out in long mode.
> +	 */
> +	ent_ctls =3D vmcs_read(ENT_CONTROLS);
> +	vmcs_write(ENT_CONTROLS, ent_ctls & ~ENT_GUEST_64);
> +
> +	guest_efer =3D vmcs_read(GUEST_EFER);
> +	vmcs_write(GUEST_EFER, guest_efer & ~(EFER_LMA | EFER_LME));
> +
> +	/*
> +	 * Set CS access rights bits for 32-bit protected mode:
> +	 * 3:0    B execute/read/accessed
> +	 * 4      1 code or data
> +	 * 6:5    0 descriptor privilege level
> +	 * 7      1 present
> +	 * 11:8   0 reserved
> +	 * 12     0 available for use by system software
> +	 * 13     0 64 bit mode not active
> +	 * 14     1 default operation size 32-bit segment
> +	 * 15     1 page granularity: segment limit in 4K units
> +	 * 16     0 segment usable
> +	 * 31:17  0 reserved
> +	 */
> +	guest_ar_cs =3D vmcs_read(GUEST_AR_CS);
> +	vmcs_write(GUEST_AR_CS, 0xc09b);
> +
> +	guest_cr0 =3D vmcs_read(GUEST_CR0);
> +	vmcs_write(GUEST_CR0, guest_cr0 & ~X86_CR0_PG);
> +
> +	guest_cr4 =3D vmcs_read(GUEST_CR4);
> +	vmcs_write(GUEST_CR4, guest_cr4 & ~X86_CR4_PCIDE);
> +
> +	guest_cr3 =3D vmcs_read(GUEST_CR3);
> +
> +	/*
> +	 * Turn the 4-level page table into a PAE page table by =
following the 0th
> +	 * PML4 entry to a PDPT page, and grab the first four PDPTEs =
from that
> +	 * page.
> +	 *
> +	 * Why does this work?
> +	 *
> +	 * PAE uses 32-bit addressing which implies:
> +	 * Bits 11:0   page offset
> +	 * Bits 20:12  entry into 512-entry page table
> +	 * Bits 29:21  entry into a 512-entry directory table
> +	 * Bits 31:30  entry into the page directory pointer table.
> +	 * Bits 63:32  zero
> +	 *
> +	 * As only 2 bits are needed to select the PDPTEs for the entire
> +	 * 32-bit address space, take the first 4 PDPTEs in the level 3 =
page
> +	 * directory pointer table. It doesn't matter which of these =
PDPTEs
> +	 * are present because they must cover the guest code given that =
it
> +	 * has already run successfully.
> +	 *
> +	 * Get a pointer to PTE for GVA=3D0 in the page directory =
pointer table
> +	 */
> +	pte =3D get_pte_level((pgd_t *)(guest_cr3 & ~X86_CR3_PCID_MASK), =
0, PDPT_LEVEL);
> +
> +	/*
> +	 * Need some memory for the 4-entry PAE page directory pointer
> +	 * table. Use the end of the identity-mapped page where the =
guest code
> +	 * is stored. There is definitely space as the guest code is =
only a
> +	 * few bytes.
> +	 */
> +	pdpt =3D test_mtf_pdpte_guest + PAGE_SIZE - 4 * =
sizeof(pteval_t);
> +
> +	/*
> +	 * Copy the first four PDPTEs into the PAE page table with =
reserved
> +	 * bits cleared. Note that permission bits from the PML4E and =
PDPTE
> +	 * are not propagated.
> +	 */
> +	for (i =3D 0; i < 4; i++) {
> +		TEST_ASSERT_EQ_MSG(0, (pte[i] & PDPTE64_RSVD_MASK),
> +				   "PDPTE has invalid reserved bits");
> +		TEST_ASSERT_EQ_MSG(0, (pte[i] & PDPTE64_PAGE_SIZE_MASK),
> +				   "Cannot use 1GB super pages for =
PAE");
> +		pdpt[i] =3D pte[i] & ~(PAE_PDPTE_RSVD_MASK);
> +	}
> +	vmcs_write(GUEST_CR3, virt_to_phys(pdpt));
> +
> +	enable_mtf();
> +	enter_guest();

This entry failed on my bare-metal machine:

Test suite: vmx_mtf_pdpte_test
VM-Exit failure on vmresume (reason=3D0x80000021, qual=3D0): invalid =
guest state

Any idea why?

