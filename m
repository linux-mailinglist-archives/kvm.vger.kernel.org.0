Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1BB559B8F
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 16:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiFXOdh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 10:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbiFXOdg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 10:33:36 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D285CE0B
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 07:33:34 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id o23so2947314ljg.13
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 07:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0yhMNVTfPgAiz+CgtIR9pHMpZQGSdtbAVl/2DeBNAqc=;
        b=SjJEMzrWxAcKwc5YzGrav8NBQX276eeEeaWCtW3CaaxjO2ltEuVAL6sjneDt8mLwMn
         G6omp21sIapg84ueYj+ecm4lMnl2oPZc8MrWyBu7vx5vt3yt77+RjCP//eeuR7ow53sn
         VnnylV8XIzAoEQEuEz4hxs8qd3t0zqP4KQ9SzEQh0VCHd4ml8YA99OQxsqxV3YgqjJjL
         aWusHu4Bphs1xWYY5SOgSPxmBo+MvIuc/HJDTXMRpWrdYBJWzuf/0vsMJWq14wpSeisJ
         MnxOEE3UFKvBxX5t+eB5AQfzMwsQX0c/vbKbT//6/qzs6CLTB1B9hAzjiZz/YUrPRgCg
         585A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0yhMNVTfPgAiz+CgtIR9pHMpZQGSdtbAVl/2DeBNAqc=;
        b=MDcwWqRlyyRNJ11hrwhJ788UvKSRxlvNR5AzR/HQqY9HLHfznkmEhnpe75ewKEojHJ
         HKIngixIa41ZNDx019M8+clePurMPAKivUVegMEZoZA634zYHCaIzdU7bv5Bn8zpFGOd
         qGtnToWkK8rzkfcSkD8R/8mVJTe5g0LGa96pxKqiuViuAhjm8rFDO9/ZhZD4Gq7AagPo
         2JmhqC+geZNQNRT0ViQlWS2AVd5L2M+XE4mqnNL8ga05kSOsXNiX6Nn/jJEz+5bwLUBq
         DMX4RWgmvy6hUwzSQQV+r5L5Omp3ubCtBtsrys7k2AV3i6jYtmb2aFW5gXE5DHmiJcNP
         xTDw==
X-Gm-Message-State: AJIora897jcAPwRyk7ye73+T1maROjfUq0+mYLyHiAZAk6CABz1JWtZ9
        hnbEPlx1tOyKhFh3rCWkAwcoxCvb3xW3K9Kkkad8pw==
X-Google-Smtp-Source: AGRyM1vdiMmZacgjEGkkuIL1NK5wWJI4LMznvMCziB6kOQphLZLpwbEtJYE7oZ87HpYB93JjjWFeHHJ2h3V4164qP4I=
X-Received: by 2002:a2e:2a43:0:b0:25a:84a9:921c with SMTP id
 q64-20020a2e2a43000000b0025a84a9921cmr7511271ljq.83.1656081212439; Fri, 24
 Jun 2022 07:33:32 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <fdf036c1e2fdf770da8238b31056206be08a7c1b.1655761627.git.ashish.kalra@amd.com>
In-Reply-To: <fdf036c1e2fdf770da8238b31056206be08a7c1b.1655761627.git.ashish.kalra@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 24 Jun 2022 08:33:21 -0600
Message-ID: <CAMkAt6o2cQPAAzYK31myzBQWckUSQWVOOV2+-5VpnTym-wN7sA@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 26/49] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_UPDATE command
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Marc Orr <marcorr@google.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>, jarkko@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 5:08 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
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
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  .../virt/kvm/x86/amd-memory-encryption.rst    |  29 +++
>  arch/x86/kvm/svm/sev.c                        | 187 ++++++++++++++++++
>  include/uapi/linux/kvm.h                      |  19 ++
>  3 files changed, 235 insertions(+)
>
> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> index 878711f2dca6..62abd5c1f72b 100644
> --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> @@ -486,6 +486,35 @@ Returns: 0 on success, -negative on error
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
> index 41b83aa6b5f4..b5f0707d7ed6 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -18,6 +18,7 @@
>  #include <linux/processor.h>
>  #include <linux/trace_events.h>
>  #include <linux/hugetlb.h>
> +#include <linux/sev.h>
>
>  #include <asm/pkru.h>
>  #include <asm/trapnr.h>
> @@ -233,6 +234,49 @@ static void sev_decommission(unsigned int handle)
>         sev_guest_decommission(&decommission, NULL);
>  }
>
> +static inline void snp_leak_pages(u64 pfn, enum pg_level level)
> +{
> +       unsigned int npages = page_level_size(level) >> PAGE_SHIFT;
> +
> +       WARN(1, "psc failed pfn 0x%llx pages %d (leaking)\n", pfn, npages);
> +
> +       while (npages) {
> +               memory_failure(pfn, 0);
> +               dump_rmpentry(pfn);
> +               npages--;
> +               pfn++;
> +       }
> +}

Should this be deduplicated with the snp_leak_pages() in "crypto: ccp:
Handle the legacy TMR allocation when SNP is enabled" ?

> +
> +static int snp_page_reclaim(u64 pfn)
> +{
> +       struct sev_data_snp_page_reclaim data = {0};
> +       int err, rc;
> +
> +       data.paddr = __sme_set(pfn << PAGE_SHIFT);
> +       rc = snp_guest_page_reclaim(&data, &err);
> +       if (rc) {
> +               /*
> +                * If the reclaim failed, then page is no longer safe
> +                * to use.
> +                */
> +               snp_leak_pages(pfn, PG_LEVEL_4K);
> +       }
> +
> +       return rc;
> +}
> +
> +static int host_rmp_make_shared(u64 pfn, enum pg_level level, bool leak)
> +{
> +       int rc;
> +
> +       rc = rmp_make_shared(pfn, level);
> +       if (rc && leak)
> +               snp_leak_pages(pfn, level);
> +
> +       return rc;
> +}
> +
>  static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
>  {
>         struct sev_data_deactivate deactivate;
> @@ -1902,6 +1946,123 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>         return rc;
>  }
>
> +static bool is_hva_registered(struct kvm *kvm, hva_t hva, size_t len)
> +{
> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +       struct list_head *head = &sev->regions_list;
> +       struct enc_region *i;
> +
> +       lockdep_assert_held(&kvm->lock);
> +
> +       list_for_each_entry(i, head, list) {
> +               u64 start = i->uaddr;
> +               u64 end = start + i->size;
> +
> +               if (start <= hva && end >= (hva + len))
> +                       return true;
> +       }

Given that usersapce could load sev->regions_list with any # of any
sized regions. Should we add a  cond_resched() like in
sev_vm_destroy()?

> +
> +       return false;
> +}
> +
> +static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +       struct sev_data_snp_launch_update data = {0};
> +       struct kvm_sev_snp_launch_update params;
> +       unsigned long npages, pfn, n = 0;
> +       int *error = &argp->error;
> +       struct page **inpages;
> +       int ret, i, level;
> +       u64 gfn;
> +
> +       if (!sev_snp_guest(kvm))
> +               return -ENOTTY;
> +
> +       if (!sev->snp_context)
> +               return -EINVAL;
> +
> +       if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
> +               return -EFAULT;
> +
> +       /* Verify that the specified address range is registered. */
> +       if (!is_hva_registered(kvm, params.uaddr, params.len))
> +               return -EINVAL;
> +
> +       /*
> +        * The userspace memory is already locked so technically we don't
> +        * need to lock it again. Later part of the function needs to know
> +        * pfn so call the sev_pin_memory() so that we can get the list of
> +        * pages to iterate through.
> +        */
> +       inpages = sev_pin_memory(kvm, params.uaddr, params.len, &npages, 1);
> +       if (!inpages)
> +               return -ENOMEM;
> +
> +       /*
> +        * Verify that all the pages are marked shared in the RMP table before
> +        * going further. This is avoid the cases where the userspace may try
> +        * updating the same page twice.
> +        */
> +       for (i = 0; i < npages; i++) {
> +               if (snp_lookup_rmpentry(page_to_pfn(inpages[i]), &level) != 0) {
> +                       sev_unpin_memory(kvm, inpages, npages);
> +                       return -EFAULT;
> +               }
> +       }
> +
> +       gfn = params.start_gfn;
> +       level = PG_LEVEL_4K;
> +       data.gctx_paddr = __psp_pa(sev->snp_context);
> +
> +       for (i = 0; i < npages; i++) {
> +               pfn = page_to_pfn(inpages[i]);
> +
> +               ret = rmp_make_private(pfn, gfn << PAGE_SHIFT, level, sev_get_asid(kvm), true);
> +               if (ret) {
> +                       ret = -EFAULT;
> +                       goto e_unpin;
> +               }
> +
> +               n++;
> +               data.address = __sme_page_pa(inpages[i]);
> +               data.page_size = X86_TO_RMP_PG_LEVEL(level);
> +               data.page_type = params.page_type;
> +               data.vmpl3_perms = params.vmpl3_perms;
> +               data.vmpl2_perms = params.vmpl2_perms;
> +               data.vmpl1_perms = params.vmpl1_perms;
> +               ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE, &data, error);
> +               if (ret) {
> +                       /*
> +                        * If the command failed then need to reclaim the page.
> +                        */
> +                       snp_page_reclaim(pfn);
> +                       goto e_unpin;
> +               }
> +
> +               gfn++;
> +       }
> +
> +e_unpin:
> +       /* Content of memory is updated, mark pages dirty */
> +       for (i = 0; i < n; i++) {

Since |n| is not only a loop variable but actually carries the number
of private pages over to e_unpin can we use a more descriptive name?
How about something like 'nprivate_pages'?

> +               set_page_dirty_lock(inpages[i]);
> +               mark_page_accessed(inpages[i]);
> +
> +               /*
> +                * If its an error, then update RMP entry to change page ownership
> +                * to the hypervisor.
> +                */
> +               if (ret)
> +                       host_rmp_make_shared(pfn, level, true);
> +       }
> +
> +       /* Unlock the user pages */
> +       sev_unpin_memory(kvm, inpages, npages);
> +
> +       return ret;
> +}
> +
>  int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  {
>         struct kvm_sev_cmd sev_cmd;
> @@ -1995,6 +2156,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>         case KVM_SEV_SNP_LAUNCH_START:
>                 r = snp_launch_start(kvm, &sev_cmd);
>                 break;
> +       case KVM_SEV_SNP_LAUNCH_UPDATE:
> +               r = snp_launch_update(kvm, &sev_cmd);
> +               break;
>         default:
>                 r = -EINVAL;
>                 goto out;
> @@ -2113,6 +2277,29 @@ find_enc_region(struct kvm *kvm, struct kvm_enc_region *range)
>  static void __unregister_enc_region_locked(struct kvm *kvm,
>                                            struct enc_region *region)
>  {
> +       unsigned long i, pfn;
> +       int level;
> +
> +       /*
> +        * The guest memory pages are assigned in the RMP table. Unassign it
> +        * before releasing the memory.
> +        */
> +       if (sev_snp_guest(kvm)) {
> +               for (i = 0; i < region->npages; i++) {
> +                       pfn = page_to_pfn(region->pages[i]);
> +
> +                       if (!snp_lookup_rmpentry(pfn, &level))
> +                               continue;
> +
> +                       cond_resched();
> +
> +                       if (level > PG_LEVEL_4K)
> +                               pfn &= ~(KVM_PAGES_PER_HPAGE(PG_LEVEL_2M) - 1);
> +
> +                       host_rmp_make_shared(pfn, level, true);
> +               }
> +       }
> +
>         sev_unpin_memory(kvm, region->pages, region->npages);
>         list_del(&region->list);
>         kfree(region);
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 0cb119d66ae5..9b36b07414ea 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1813,6 +1813,7 @@ enum sev_cmd_id {
>         /* SNP specific commands */
>         KVM_SEV_SNP_INIT,
>         KVM_SEV_SNP_LAUNCH_START,
> +       KVM_SEV_SNP_LAUNCH_UPDATE,
>
>         KVM_SEV_NR_MAX,
>  };
> @@ -1929,6 +1930,24 @@ struct kvm_sev_snp_launch_start {
>         __u8 pad[6];
>  };
>
> +#define KVM_SEV_SNP_PAGE_TYPE_NORMAL           0x1
> +#define KVM_SEV_SNP_PAGE_TYPE_VMSA             0x2
> +#define KVM_SEV_SNP_PAGE_TYPE_ZERO             0x3
> +#define KVM_SEV_SNP_PAGE_TYPE_UNMEASURED       0x4
> +#define KVM_SEV_SNP_PAGE_TYPE_SECRETS          0x5
> +#define KVM_SEV_SNP_PAGE_TYPE_CPUID            0x6
> +
> +struct kvm_sev_snp_launch_update {
> +       __u64 start_gfn;
> +       __u64 uaddr;
> +       __u32 len;
> +       __u8 imi_page;
> +       __u8 page_type;
> +       __u8 vmpl3_perms;
> +       __u8 vmpl2_perms;
> +       __u8 vmpl1_perms;
> +};
> +
>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU    (1 << 0)
>  #define KVM_DEV_ASSIGN_PCI_2_3         (1 << 1)
>  #define KVM_DEV_ASSIGN_MASK_INTX       (1 << 2)
> --
> 2.25.1
>
