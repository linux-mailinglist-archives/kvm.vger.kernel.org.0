Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C44AC6A1BA7
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 12:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjBXLzw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 06:55:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjBXLzu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 06:55:50 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96598410A3;
        Fri, 24 Feb 2023 03:55:48 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id z42so6187543ljq.13;
        Fri, 24 Feb 2023 03:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SM2jD2WGkkdjc+YfrvfeooKgMPREveodz0PCNlMVFUU=;
        b=oYtJEH81IIRS5o0x+xLdmMNllSAuwKBCUooS8AOaxRt/BE2cRWtGVWH+Bvz/Sp9Tkv
         r5BQzvKNC+0V5/PWEzDgoV1DnyLuGa7xy3g76rs+pkCS/Udh21KWrBYoUMSWUJohp2Wm
         ST9xgqK1Wbop0OnRewSDsJjHAB21U+24MnCBkEoTdnK9UgmN5GKr/nktQDZdIlpt68Er
         vi+srj5T3SfN3DkzjbTiuuKTf2C1X6vO2zE0ab5Qupw1aIfOOTbOUoJaOJ7o7e2rRcIJ
         2grOIfhbo9PlYhGn3XLA91cNnkMhyIZDQf26A6U7LyWyMqIx9KtRacvhxatGUck2N0to
         SCdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SM2jD2WGkkdjc+YfrvfeooKgMPREveodz0PCNlMVFUU=;
        b=1cPGO8yyyh67iJ8A7Q98Mp/t9HMDPPwEjGo3NadyERfYUDk94dTwoeuyxiPq9LRc1d
         Hu+WbuRTeDQQ7eMpgKcHjIohF8Te9v8eBmmSjC3apfNRY4wnmASegOeXoSYevOXiuaxb
         JZWlzHZW+0BtTB/NRBhBmfn4nNbmjOVj2vqew8C2urptuNRjByMUCEzkhb/TRZsey754
         MJuGmsLNP78qRRyBB2Pg7turJhCwTjleY8ZdaGXHogCR7HHORwq/czJnR0TIKRfR4a1H
         SQgB/fV9TlFBu5HHZiesH1Uv3DDvhdGnTyzquuPUVKiY+BfCYOYETyMUE/9czZ3phOd9
         B2Gg==
X-Gm-Message-State: AO0yUKXINFmAPhKr7tzG8tD39h/OUNO/hLwhtGm6hJOZEe40GRtfeIks
        nWzkSufZMtZ6KoxpA6cQkU0=
X-Google-Smtp-Source: AK7set/WeGrqGcctJ0TVe1kLF8QFmtLiUiu8GO3U35HUeDbvsI/VmUrvYYPSOTjYEDAl0Scs+kKEyw==
X-Received: by 2002:a2e:a9a2:0:b0:293:47c6:e876 with SMTP id x34-20020a2ea9a2000000b0029347c6e876mr8132243ljq.2.1677239746722;
        Fri, 24 Feb 2023 03:55:46 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id s2-20020a19ad42000000b004cc7026d95asm1665253lfd.259.2023.02.24.03.55.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 03:55:46 -0800 (PST)
Date:   Fri, 24 Feb 2023 13:55:44 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
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
Subject: Re: [PATCH RFC v8 35/56] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_UPDATE
 command
Message-ID: <20230224135544.000075fb@gmail.com>
In-Reply-To: <20230220183847.59159-36-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
        <20230220183847.59159-36-michael.roth@amd.com>
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

On Mon, 20 Feb 2023 12:38:26 -0600
Michael Roth <michael.roth@amd.com> wrote:

> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The KVM_SEV_SNP_LAUNCH_UPDATE command can be used to insert data into the
> guest's memory. The data is encrypted with the cryptographic context
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
> 
> Co-developed-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  .../virt/kvm/x86/amd-memory-encryption.rst    |  29 +++
>  arch/x86/kvm/svm/sev.c                        | 190 ++++++++++++++++++
>  include/uapi/linux/kvm.h                      |  19 ++
>  3 files changed, 238 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> index 58971fc02a15..c94be8e6d657 100644
> --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> @@ -485,6 +485,35 @@ Returns: 0 on success, -negative on error
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
> +                __u32 len;              /* length of memory region */
> +                __u8 imi_page;          /* 1 if memory is part of the IMI */
> +                __u8 page_type;         /* page type */
> +                __u8 vmpl3_perms;       /* VMPL3 permission mask */
> +                __u8 vmpl2_perms;       /* VMPL2 permission mask */
> +                __u8 vmpl1_perms;       /* VMPL1 permission mask */
> +        };
> +
> +See the SEV-SNP spec for further details on how to build the VMPL permission
> +mask and page type.
> +
> +
>  References
>  ==========
>  
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 097bb2138360..03dd227f6090 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -234,6 +234,37 @@ static void sev_decommission(unsigned int handle)
>  	sev_guest_decommission(&decommission, NULL);
>  }
>  
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
> +		 */
> +		snp_mark_pages_offline(pfn,
> +				       page_level_size(PG_LEVEL_4K) >> PAGE_SHIFT);
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
> +		snp_mark_pages_offline(pfn,
> +				       page_level_size(level) >> PAGE_SHIFT);
> +
> +	return rc;
> +}
> +

PATCH 24 has similar functions. It would be better to expose them.

>  static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
>  {
>  	struct sev_data_deactivate deactivate;
> @@ -2093,6 +2124,162 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
> +		pr_err("SEV-SNP requires restricted memory.\n");
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
> +		void *kvaddr;
> +
> +		ret = kvm_restrictedmem_get_pfn(memslot, gfn, &pfns[i], &order);
> +		if (ret)
> +			goto e_release;
> +
> +		n++;
> +		ret = snp_lookup_rmpentry((u64)pfns[i], &level);
> +		if (ret) {
> +			pr_err("Failed to ensure GFN 0x%llx is in initial shared state, ret: %d\n",
> +			       gfn, ret);
> +			return -EFAULT;
> +		}
> +
> +		kvaddr = pfn_to_kaddr(pfns[i]);
> +		if (!virt_addr_valid(kvaddr)) {
> +			pr_err("Invalid HVA 0x%llx for GFN 0x%llx\n", (uint64_t)kvaddr, gfn);
> +			ret = -EINVAL;
> +			goto e_release;
> +		}
> +
> +		ret = kvm_read_guest_page(kvm, gfn, kvaddr, 0, PAGE_SIZE);
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
> +		data.page_size = X86_TO_RMP_PG_LEVEL(PG_LEVEL_4K);
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
> +			 */
> +			if (params.page_type == SNP_PAGE_TYPE_CPUID &&
> +			    *error == SEV_RET_INVALID_PARAM) {
> +				int ret;
> +
> +				host_rmp_make_shared(pfns[i], PG_LEVEL_4K, true);
> +
> +				ret = kvm_write_guest_page(kvm, gfn, kvaddr, 0, PAGE_SIZE);
> +				if (ret)
> +					pr_err("Failed to write CPUID page back to userspace, ret: 0x%x\n",
> +					       ret);
> +			}
> +
> +
> +			goto e_release;
> +		}
> +	}
> +
> +	/*
> +	 * Memory attribute updates via KVM_SET_MEMORY_ATTRIBUTES are serialized
> +	 * via kvm->slots_lock, so use the same protocol for updating them here.
> +	 */
> +	mutex_lock(&kvm->slots_lock);
> +	kvm_vm_set_region_attr(kvm, range->start, range->end, KVM_MEMORY_ATTRIBUTE_PRIVATE);
> +	mutex_unlock(&kvm->slots_lock);
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
> +	return ret;
> +}
> +
> +static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_snp_launch_update params;
> +
> +	if (!sev_snp_guest(kvm))
> +		return -ENOTTY;
> +
> +	if (!sev->snp_context)
> +		return -EINVAL;
> +
> +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
> +		return -EFAULT;
> +
> +	return kvm_vm_do_hva_range_op(kvm, params.uaddr, params.uaddr + params.len,
> +				      snp_launch_update_gfn_handler, argp);
> +}
> +
>  int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_sev_cmd sev_cmd;
> @@ -2186,6 +2373,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  	case KVM_SEV_SNP_LAUNCH_START:
>  		r = snp_launch_start(kvm, &sev_cmd);
>  		break;
> +	case KVM_SEV_SNP_LAUNCH_UPDATE:
> +		r = snp_launch_update(kvm, &sev_cmd);
> +		break;
>  	default:
>  		r = -EINVAL;
>  		goto out;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index cf19799ca5ce..4098bba17aa4 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1920,6 +1920,7 @@ enum sev_cmd_id {
>  	/* SNP specific commands */
>  	KVM_SEV_SNP_INIT,
>  	KVM_SEV_SNP_LAUNCH_START,
> +	KVM_SEV_SNP_LAUNCH_UPDATE,
>  
>  	KVM_SEV_NR_MAX,
>  };
> @@ -2036,6 +2037,24 @@ struct kvm_sev_snp_launch_start {
>  	__u8 pad[6];
>  };
>  
> +#define KVM_SEV_SNP_PAGE_TYPE_NORMAL		0x1
> +#define KVM_SEV_SNP_PAGE_TYPE_VMSA		0x2
> +#define KVM_SEV_SNP_PAGE_TYPE_ZERO		0x3
> +#define KVM_SEV_SNP_PAGE_TYPE_UNMEASURED	0x4
> +#define KVM_SEV_SNP_PAGE_TYPE_SECRETS		0x5
> +#define KVM_SEV_SNP_PAGE_TYPE_CPUID		0x6
> +
> +struct kvm_sev_snp_launch_update {
> +	__u64 start_gfn;
> +	__u64 uaddr;
> +	__u32 len;
> +	__u8 imi_page;
> +	__u8 page_type;
> +	__u8 vmpl3_perms;
> +	__u8 vmpl2_perms;
> +	__u8 vmpl1_perms;
> +};
> +
>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
>  #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
>  #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)

