Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 037D86A5F60
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 20:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjB1TME (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 14:12:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjB1TMD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 14:12:03 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29AD31FE8;
        Tue, 28 Feb 2023 11:12:02 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id m7so14577286lfj.8;
        Tue, 28 Feb 2023 11:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677611520;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uv7zPB/3/n/GjotxPr3QAZ4fe2v+az1qjxPnevupIu0=;
        b=BfMMLuS5eSNj/Ge+TUpVvYl+FYWzdyNRKWJ+xpggvWkmwP80jfH5IayK0shL2PiNmF
         U5c7C6XGKocmqu9lu6iucY5RFxep3UTIjMecuocKxZfFtZloKpLSmEYJy2/mk6H46O0s
         BQrvtUKPnQHx0rcaBtxXBw7JRnJ/qEdj2weTpk0+GLVe52DONvIQanmhWdgM5JMmSYuF
         kE+JmQS85MtKbowNvjIl1DE8s137VHAc97GRfKpnsYRT4f2ODxdo3AMC9SGl6cXA4Wue
         yvkrPrrMs3bC61/OOetNvwBPJCHNcVJxxOog/bLvxI7sRFkV/CqE6nMM1nLeRvmhrYui
         np/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677611520;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uv7zPB/3/n/GjotxPr3QAZ4fe2v+az1qjxPnevupIu0=;
        b=ruZ1ZWwotrMLoklbylIB/5q+C5yYyaep0EZ1e8bnm4+FAu6Fv3P2gtSIXKSUBkiYsK
         0hKdytWO6E0VaMwi+R/WbbuQ/zls2cj+b88VSUkFm1tjMYl77qNUihn1bllTNi4Jds9l
         YTdWoSsPi1qZuQEw8CvNJaVl6JhB4vauGOkcHIMLuEdblzLHjnystib3S/rEJh5mXobY
         tWXkPYEnvqZNGBNEdQY677++qwq07Oo7j9gDVRZr5icTRK0iXVXAEUGappWyKoqvfohV
         FqIP/SYHTAjorxOOB44eT3K+wKZs08nNMF7li7suJtFyTnvOCG7omu+rbPaRrU3IWa4W
         FEqQ==
X-Gm-Message-State: AO0yUKWr59iduwxxLdC/chJunyiKVKJASq+1kqabu6Qsv/M61pciM7Be
        mMWW4au9kFwQapplUrf6c0U=
X-Google-Smtp-Source: AK7set8yCOjxHk7icQ9ufval00Ha+MWUzClI0rlxUuq3jsmZAk2MiIPR4enIzec0MGw/UdqPETNCyA==
X-Received: by 2002:ac2:44a9:0:b0:4d2:c70a:fe0a with SMTP id c9-20020ac244a9000000b004d2c70afe0amr834685lfm.2.1677611520244;
        Tue, 28 Feb 2023 11:12:00 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id b7-20020ac24107000000b004db297957e8sm1441198lfi.305.2023.02.28.11.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 11:12:00 -0800 (PST)
From:   Zhi Wang <zhi.wang.linux@gmail.com>
X-Google-Original-From: Zhi Wang <zhi.wang.linux@intel.com>
Date:   Tue, 28 Feb 2023 21:11:57 +0200
To:     Michael Roth <michael.roth@amd.com>
Cc:     <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH RFC v8 44/56] KVM: SVM: Add support to handle the RMP
 nested page fault
Message-ID: <20230228211157.0000071b@intel.com>
In-Reply-To: <20230220183847.59159-45-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
        <20230220183847.59159-45-michael.roth@amd.com>
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

On Mon, 20 Feb 2023 12:38:35 -0600
Michael Roth <michael.roth@amd.com> wrote:

> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> When SEV-SNP is enabled in the guest, the hardware places restrictions
> on all memory accesses based on the contents of the RMP table. When
> hardware encounters RMP check failure caused by the guest memory access
> it raises the #NPF. The error code contains additional information on
> the access type. See the APM volume 2 for additional information.
> 
> Page state changes are handled by userspace, so if an RMP fault is
> triggered as a result of an RMP NPT fault, exit to userspace just like
> with explicit page-state change requests.
> 
> RMP NPT faults can also occur if the guest pvalidates a 2M page as 4K,
> in which case the RMP entries need to be PSMASH'd. Handle this case
> immediately in the kernel.
> 
> Co-developed-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 84 ++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c | 21 +++++++++--
>  arch/x86/kvm/svm/svm.h |  1 +
>  3 files changed, 102 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 102966c43e28..197b1f904567 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3347,6 +3347,13 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
>  	svm->vmcb->control.ghcb_gpa = value;
>  }
>  
> +static int snp_rmptable_psmash(struct kvm *kvm, kvm_pfn_t pfn)
> +{
> +	pfn = pfn & ~(KVM_PAGES_PER_HPAGE(PG_LEVEL_2M) - 1);
> +
> +	return psmash(pfn);
> +}
> +
>  /*
>   * TODO: need to get the value set by userspace in vcpu->run->vmgexit.ghcb_msr
>   * and process that here accordingly.
> @@ -3872,3 +3879,80 @@ void sev_adjust_mapping_level(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int *le
>  	pr_debug("%s: GFN: 0x%llx, PFN: 0x%llx, level: %d, rmp_level: %d, level_orig: %d, assigned: %d\n",
>  		 __func__, gfn, pfn, *level, rmp_level, level_orig, assigned);
>  }
> +
> +void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
> +{
> +	int order, rmp_level, assigned, ret;
> +	struct kvm_memory_slot *slot;
> +	struct kvm *kvm = vcpu->kvm;
> +	kvm_pfn_t pfn;
> +	gfn_t gfn;
> +
> +	/*
> +	 * Private memslots punt handling of implicit page state changes to
                             ^put
> +	 * userspace, so the only RMP faults expected here for
> +	 * PFERR_GUEST_SIZEM_MASK. Anything else suggests that the RMP table has
> +	 * gotten out of sync with the private memslot.
> +	 *
> +	 * TODO: However, this case has also been noticed when an access occurs
> +	 * to an NPT mapping that has just been split/PSMASHED, in which case
> +	 * PFERR_GUEST_SIZEM_MASK might not be set. In those cases it should be
> +	 * safe to ignore and let the guest retry, but log these just in case
> +	 * for now.
> +	 */
> +	if (!(error_code & PFERR_GUEST_SIZEM_MASK)) {
> +		pr_warn_ratelimited("Unexpected RMP fault for GPA 0x%llx, error_code 0x%llx",
> +				    gpa, error_code);
> +		return;
> +	}
> +
> +	gfn = gpa >> PAGE_SHIFT;
> +
> +	/*
> +	 * Only RMPADJUST/PVALIDATE should cause PFERR_GUEST_SIZEM.
> +	 *
> +	 * For PVALIDATE, this should only happen if a guest PVALIDATEs a 4K GFN
> +	 * that is backed by a huge page in the host whose RMP entry has the
> +	 * hugepage/assigned bits set. With UPM, that should only ever happen
> +	 * for private pages.
> +	 *
> +	 * For RMPADJUST, this assumption might not hold, in which case handling
> +	 * for obtaining the PFN from HVA-backed memory may be needed. For now,
> +	 * just print warnings.
> +	 */
> +	if (!kvm_mem_is_private(kvm, gfn)) {
> +		pr_warn_ratelimited("Unexpected RMP fault, size-mismatch for non-private GPA 0x%llx\n",
> +				    gpa);
> +		return;
> +	}
> +
> +	slot = gfn_to_memslot(kvm, gfn);
> +	if (!kvm_slot_can_be_private(slot)) {
> +		pr_warn_ratelimited("Unexpected RMP fault, non-private slot for GPA 0x%llx\n",
> +				    gpa);
> +		return;
> +	}
> +
> +	ret = kvm_restrictedmem_get_pfn(slot, gfn, &pfn, &order);
> +	if (ret) {
> +		pr_warn_ratelimited("Unexpected RMP fault, no private backing page for GPA 0x%llx\n",
> +				    gpa);
> +		return;
> +	}
> +
> +	assigned = snp_lookup_rmpentry(pfn, &rmp_level);
> +	if (assigned != 1) {
> +		pr_warn_ratelimited("Unexpected RMP fault, no assigned RMP entry for GPA 0x%llx\n",
> +				    gpa);
> +		goto out;
> +	}
> +
> +	ret = snp_rmptable_psmash(kvm, pfn);
> +	if (ret)
> +		pr_err_ratelimited("Unable to split RMP entries for GPA 0x%llx PFN 0x%llx ret %d\n",
> +				   gpa, pfn, ret);
> +
> +out:
> +	kvm_zap_gfn_range(kvm, gfn, gfn + PTRS_PER_PMD);
> +	put_page(pfn_to_page(pfn));
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 9eb750c8b04c..f9ab4bf6d245 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1976,15 +1976,28 @@ static int pf_interception(struct kvm_vcpu *vcpu)
>  static int npf_interception(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> +	int rc;
>  
>  	u64 fault_address = svm->vmcb->control.exit_info_2;
>  	u64 error_code = svm->vmcb->control.exit_info_1;
>  
>  	trace_kvm_page_fault(vcpu, fault_address, error_code);
> -	return kvm_mmu_page_fault(vcpu, fault_address, error_code,
> -			static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
> -			svm->vmcb->control.insn_bytes : NULL,
> -			svm->vmcb->control.insn_len);
> +	rc = kvm_mmu_page_fault(vcpu, fault_address, error_code,
> +				static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
> +				svm->vmcb->control.insn_bytes : NULL,
> +				svm->vmcb->control.insn_len);
> +
> +	/*
> +	 * rc == 0 indicates a userspace exit is needed to handle page
> +	 * transitions, so do that first before updating the RMP table.
> +	 */
> +	if (error_code & PFERR_GUEST_RMP_MASK) {
> +		if (rc == 0)
> +			return rc;
> +		handle_rmp_page_fault(vcpu, fault_address, error_code);
> +	}
> +
> +	return rc;
>  }
>  
>  static int db_interception(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 0c655a4d32d5..13b00233b315 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -714,6 +714,7 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
>  void sev_es_unmap_ghcb(struct vcpu_svm *svm);
>  struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
>  void sev_adjust_mapping_level(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int *level);
> +void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
>  
>  /* vmenter.S */
>  

