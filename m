Return-Path: <kvm+bounces-6006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C276A829DE2
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 16:46:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 316101F28783
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 15:46:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC4E84CDE6;
	Wed, 10 Jan 2024 15:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gtiLDA4B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E23D4CB54
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 15:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5eb6dba1796so78481127b3.1
        for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 07:45:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704901538; x=1705506338; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Lq0U/JA8ruxxMjOd91X5TeH+1BTCqwEXpz7z0V/bils=;
        b=gtiLDA4BpK7ptNHYsYa/8pAkUfMymcQ+oOO56+/Xl2m3BM1anDOmV/RzWotPT7SfWB
         4PFtcMu7BZGFbAu4XCdT0oea0hHHtjz5V4gOkJNTNcReQm3V5tOJSHqXNw6xlVYuyNEN
         K+4TIjG6JvhNYDjGV7bbyj+6e0lQAQLOJv1SsK16iZx0ny4sMlFsodCtfhyp5IYS1dSq
         GrLdJxY/8N57MRl+DktAi0sUNcXM6gWvr3TInh3I0RIwPUabQoNdtyplGKVPatQ5emRm
         1deEUbWHxny7n3fDgsqVCGTAmxOxqabC28kcxKJkteRbT41/aL1rWakSfqYc6AGWfhnF
         TklQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704901538; x=1705506338;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lq0U/JA8ruxxMjOd91X5TeH+1BTCqwEXpz7z0V/bils=;
        b=lmvCgdHNg2Y4YB2Z8KzDA7IKSNt4AylMtlakUPwq6YjIJcgPUGXP21qbvJ32sYM9jp
         ZwApfV645AA8JjAMEY25Qo2awDNM6kG/fKEMorIXLWZsgJPkVPJ7GlU+5e2WspjFBwJR
         QmuHGDbDrE/rvAhM2WJ3G28566mOEbPqycfd2Mn2Zeero308MXHrn9nhkJKnalOeTeD6
         ZWqURD3FXTsmuQoo5nqz/h00TGgWwKTdSLrvAatbomjQu7gMy+eXLwAXodH+IbGW28NI
         kh7xtuQR9hXGdgVLXn/RfiwBXB8QKAipmb312Qg/DhKwpnVj0l1Mux13YFSBLP0QmvX5
         dUrQ==
X-Gm-Message-State: AOJu0YyO5sdTyOx1PYjQ3Qk8Qz9LGTZQuBf2V40fdBOtHtNZiKW9Lq0h
	FXArwEKSV0XkcuZa4tMwY7J9T25XYGrMc8y5+A==
X-Google-Smtp-Source: AGHT+IGTdQzTgcbH03msREAtwwMGQwWLrPJpgE5yk/oSK2EIjbPojsGBLiAo3crBf9e87rN8qint7m6Y/wM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:be12:0:b0:5f9:88f5:e4e7 with SMTP id
 i18-20020a81be12000000b005f988f5e4e7mr581962ywn.10.1704901538193; Wed, 10 Jan
 2024 07:45:38 -0800 (PST)
Date: Wed, 10 Jan 2024 07:45:36 -0800
In-Reply-To: <20231230172351.574091-19-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231230172351.574091-1-michael.roth@amd.com> <20231230172351.574091-19-michael.roth@amd.com>
Message-ID: <ZZ67oJwzAsSvui5U@google.com>
Subject: Re: [PATCH v11 18/35] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, 
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, pbonzini@redhat.com, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com, 
	Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Sat, Dec 30, 2023, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The KVM_SEV_SNP_LAUNCH_UPDATE command can be used to insert data into
> the guest's memory. The data is encrypted with the cryptographic context
> created with the KVM_SEV_SNP_LAUNCH_START.
> 
> In addition to the inserting data, it can insert a two special pages
> into the guests memory: the secrets page and the CPUID page.
> 
> While terminating the guest, reclaim the guest pages added in the RMP
> table. If the reclaim fails, then the page is no longer safe to be
> released back to the system and leak them.
> 
> For more information see the SEV-SNP specification.

Please rewrite all changelogs to explain what *KVM* support is being added, why
the proposed uAPI looks like it does, and how the new uAPI is intended be used.

Porividing a crash course on the relevant hardware behavior is definitely helpful,
but the changelog absolutely needs to explain/justify the patch.

> Co-developed-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  .../virt/kvm/x86/amd-memory-encryption.rst    |  28 +++
>  arch/x86/kvm/svm/sev.c                        | 181 ++++++++++++++++++
>  include/uapi/linux/kvm.h                      |  19 ++
>  3 files changed, 228 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> index b1beb2fe8766..d4325b26724c 100644
> --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> @@ -485,6 +485,34 @@ Returns: 0 on success, -negative on error
>  
>  See the SEV-SNP specification for further detail on the launch input.
>  
> +20. KVM_SNP_LAUNCH_UPDATE
> +-------------------------
> +
> +The KVM_SNP_LAUNCH_UPDATE is used for encrypting a memory region. It also
> +calculates a measurement of the memory contents. The measurement is a signature
> +of the memory contents that can be sent to the guest owner as an attestation
> +that the memory was encrypted correctly by the firmware.
> +
> +Parameters (in): struct  kvm_snp_launch_update
> +
> +Returns: 0 on success, -negative on error
> +
> +::
> +
> +        struct kvm_sev_snp_launch_update {
> +                __u64 start_gfn;        /* Guest page number to start from. */
> +                __u64 uaddr;            /* userspace address need to be encrypted */

Huh?  Why is KVM taking a userspace address?  IIUC, the address unconditionally
gets translated into a gfn, so why not pass a gfn?

And speaking of gfns, AFAICT start_gfn is never used.

Oof, reading more of the code, this *requires* an effective in-place copy-and-convert
of guest memory.

> +                __u32 len;              /* length of memory region */

Bytes?  Pages?  One field above operates on frame numbers, one apparently operates
on a byte-granularity address.

> +                __u8 imi_page;          /* 1 if memory is part of the IMI */

What's "the IMI"?  Initial Measurement Image?  I assume this is essentially just
a flag that communicates whether or not the page should be measured?

> +                __u8 page_type;         /* page type */
> +                __u8 vmpl3_perms;       /* VMPL3 permission mask */
> +                __u8 vmpl2_perms;       /* VMPL2 permission mask */
> +                __u8 vmpl1_perms;       /* VMPL1 permission mask */

Why?  KVM doesn't support VMPLs.

> +static int snp_page_reclaim(u64 pfn)
> +{
> +	struct sev_data_snp_page_reclaim data = {0};
> +	int err, rc;
> +
> +	data.paddr = __sme_set(pfn << PAGE_SHIFT);
> +	rc = sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
> +	if (rc) {
> +		/*
> +		 * If the reclaim failed, then page is no longer safe
> +		 * to use.

Uh, why can reclaim fail, and why does the kernel apparently not care about
leaking pages?  AFAICT, nothing ever complains beyond a pr_debug.  That sounds
bonkers to me, i.e. at the very minimum, why doesn't this warrant a WARN_ON_ONCE?

> +		 */
> +		snp_leak_pages(pfn, 1);
> +	}
> +
> +	return rc;
> +}
> +
> +static int host_rmp_make_shared(u64 pfn, enum pg_level level, bool leak)
> +{
> +	int rc;
> +
> +	rc = rmp_make_shared(pfn, level);
> +	if (rc && leak)
> +		snp_leak_pages(pfn,
> +			       page_level_size(level) >> PAGE_SHIFT);

Completely unnecessary wrap.

> +
> +	return rc;
> +}
> +
>  static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
>  {
>  	struct sev_data_deactivate deactivate;
> @@ -1990,6 +2020,154 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	return rc;
>  }
>  
> +static int snp_launch_update_gfn_handler(struct kvm *kvm,
> +					 struct kvm_gfn_range *range,
> +					 void *opaque)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_memory_slot *memslot = range->slot;
> +	struct sev_data_snp_launch_update data = {0};
> +	struct kvm_sev_snp_launch_update params;
> +	struct kvm_sev_cmd *argp = opaque;
> +	int *error = &argp->error;
> +	int i, n = 0, ret = 0;
> +	unsigned long npages;
> +	kvm_pfn_t *pfns;
> +	gfn_t gfn;
> +
> +	if (!kvm_slot_can_be_private(memslot)) {
> +		pr_err("SEV-SNP requires private memory support via guest_memfd.\n");

Yeah, no.  Sprinkling pr_err() all over the place in user-triggerable error paths
is not acceptable.  I get that it's often hard to extract "what went wrong" out
of the kernel, but adding pr_err() everywhere is not a viable solution.

> +		return -EINVAL;
> +	}
> +
> +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params))) {
> +		pr_err("Failed to copy user parameters for SEV-SNP launch.\n");
> +		return -EFAULT;
> +	}
> +
> +	data.gctx_paddr = __psp_pa(sev->snp_context);
> +
> +	npages = range->end - range->start;
> +	pfns = kvmalloc_array(npages, sizeof(*pfns), GFP_KERNEL_ACCOUNT);
> +	if (!pfns)
> +		return -ENOMEM;
> +
> +	pr_debug("%s: GFN range 0x%llx-0x%llx, type %d\n", __func__,
> +		 range->start, range->end, params.page_type);
> +
> +	for (gfn = range->start, i = 0; gfn < range->end; gfn++, i++) {
> +		int order, level;
> +		bool assigned;
> +		void *kvaddr;
> +
> +		ret = __kvm_gmem_get_pfn(kvm, memslot, gfn, &pfns[i], &order, false);
> +		if (ret)
> +			goto e_release;
> +
> +		n++;
> +		ret = snp_lookup_rmpentry((u64)pfns[i], &assigned, &level);
> +		if (ret || assigned) {
> +			pr_err("Failed to ensure GFN 0x%llx is in initial shared state, ret: %d, assigned: %d\n",
> +			       gfn, ret, assigned);
> +			return -EFAULT;
> +		}
> +
> +		kvaddr = pfn_to_kaddr(pfns[i]);
> +		if (!virt_addr_valid(kvaddr)) {

I really, really don't like that this assume guest_memfd is backed by struct page.

> +			pr_err("Invalid HVA 0x%llx for GFN 0x%llx\n", (uint64_t)kvaddr, gfn);
> +			ret = -EINVAL;
> +			goto e_release;
> +		}
> +
> +		ret = kvm_read_guest_page(kvm, gfn, kvaddr, 0, PAGE_SIZE);

Good gravy.  If I'm reading this correctly, KVM:

  1. Translates an HVA into a GFN.
  2. Gets the PFN for that GFN from guest_memfd
  3. Verifies the PFN is not assigned to the guest
  4. Copies memory from the shared memslot page to the guest_memfd page
  5. Converts the page to private and asks the PSP to encrypt it

(a) As above, why is #1 a thing?
(b) Why are KVM's memory attributes never consulted?
(c) What prevents TOCTOU issues with respect to the RMP?
(d) Why is *KVM* copying memory into guest_memfd?
(e) What guarantees the direct map is valid for guest_memfd?
(f) Why does KVM's uAPI *require* the source page to come from the same memslot?

> +		if (ret) {
> +			pr_err("Guest read failed, ret: 0x%x\n", ret);
> +			goto e_release;
> +		}
> +
> +		ret = rmp_make_private(pfns[i], gfn << PAGE_SHIFT, PG_LEVEL_4K,
> +				       sev_get_asid(kvm), true);
> +		if (ret) {
> +			ret = -EFAULT;
> +			goto e_release;
> +		}
> +
> +		data.address = __sme_set(pfns[i] << PAGE_SHIFT);
> +		data.page_size = PG_LEVEL_TO_RMP(PG_LEVEL_4K);
> +		data.page_type = params.page_type;
> +		data.vmpl3_perms = params.vmpl3_perms;
> +		data.vmpl2_perms = params.vmpl2_perms;
> +		data.vmpl1_perms = params.vmpl1_perms;
> +		ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
> +				      &data, error);
> +		if (ret) {
> +			pr_err("SEV-SNP launch update failed, ret: 0x%x, fw_error: 0x%x\n",
> +			       ret, *error);
> +			snp_page_reclaim(pfns[i]);
> +
> +			/*
> +			 * When invalid CPUID function entries are detected, the firmware
> +			 * corrects these entries for debugging purpose and leaves the
> +			 * page unencrypted so it can be provided users for debugging
> +			 * and error-reporting.
> +			 *
> +			 * Copy the corrected CPUID page back to shared memory so
> +			 * userpsace can retrieve this information.

Why?  IIUC, this is basically backdooring reads/writes into guest_memfd to avoid
having to add proper mmap() support.
 
> +			 */
> +			if (params.page_type == SNP_PAGE_TYPE_CPUID &&
> +			    *error == SEV_RET_INVALID_PARAM) {
> +				int ret;

Ugh, do not shadow variables.

> +
> +				host_rmp_make_shared(pfns[i], PG_LEVEL_4K, true);
> +
> +				ret = kvm_write_guest_page(kvm, gfn, kvaddr, 0, PAGE_SIZE);
> +				if (ret)
> +					pr_err("Failed to write CPUID page back to userspace, ret: 0x%x\n",
> +					       ret);
> +			}
> +
> +			goto e_release;
> +		}
> +	}
> +
> +e_release:
> +	/* Content of memory is updated, mark pages dirty */
> +	for (i = 0; i < n; i++) {
> +		set_page_dirty(pfn_to_page(pfns[i]));
> +		mark_page_accessed(pfn_to_page(pfns[i]));
> +
> +		/*
> +		 * If its an error, then update RMP entry to change page ownership
> +		 * to the hypervisor.
> +		 */
> +		if (ret)
> +			host_rmp_make_shared(pfns[i], PG_LEVEL_4K, true);
> +
> +		put_page(pfn_to_page(pfns[i]));
> +	}
> +
> +	kvfree(pfns);

Saving PFNs from guest_memfd, which is fully owned by KVM, is so unnecessarily
complex.  Add a guest_memfd API (or three) to do this safely, e.g. to lock the
pages, do (and track) the RMP conversion, etc...

