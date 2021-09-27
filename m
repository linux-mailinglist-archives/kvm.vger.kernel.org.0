Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB31419969
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 18:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235549AbhI0QpB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 12:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235481AbhI0QpA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 12:45:00 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833B9C061575
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 09:43:20 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id z24so81067592lfu.13
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 09:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l6yovMgBWNTTR56Q7WSV6rzjLweUZFOJVhBOBAp7uko=;
        b=ICJXF1e6jZoXnOVK6Wj8c8uNVFlJycFej3Z9w9YS/1bsfYNOvS6oQ7issCFG0BAJGX
         d1jVqzZaX4HzXUZg3/PWF4cK07JMTKeNJ71HSrEUgmUnV7hd3vArCV9KxrS5WyT2++mX
         FFhukkIi2q7/rzSfQ0uEgmRmInluGicun9T+JL74YNiZhHCmgl9Tshm6DeYMTmzuxeQa
         Xm73b9Y9FMeQiIqcjk4+68SyAN9FfC8lu2lNqh9d0oxFpD92DWcgLfyzwDPTvw/kA5r2
         Gjl622IJgz2dvw1OWXA6RzTEDPNdpP6AayNiO3qad7uEdioV6mJ7KwVKgfF5Q/U3+Qm0
         rZjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l6yovMgBWNTTR56Q7WSV6rzjLweUZFOJVhBOBAp7uko=;
        b=mx9cbofGQT379h+p6PMTfn/J10fYgEyDZGKvTKTn5HACXHsMvU+xoUfGhCFHbHd1jy
         HbwDSy2wfQaLYH5H+DfwZnYujgbx8z/uOhc7qMVBYFSjFNKl2stqEMQ3OLeaoMLxujrP
         xGzFk5r7JFs7P8ZTiQ8uKCnAt771GhY/RrwOFLd1CDWu7NLM1ptghxTvC0HLsmU9U27l
         6blvI4/uuDcaaxx5Gnb+AsgBOkc16zRKV1vEzP41g7/as7ksqhVo0DWGq2PBkAEQLqet
         LTBM6AGK3WysYW2+KTh2qsq2jU2tpb7gjIpYHouBfs58q/w92FN1sDdG/KrB3kAaZYMD
         9JKw==
X-Gm-Message-State: AOAM530roNmDwFB4iILuF6oCVFPx7kBcdwHpXG2dL3M7amosy+ZhwsfP
        0i/oMAAqqN2Ato6X3tOKldDqSEOR+gbA+L1zg5vnVg==
X-Google-Smtp-Source: ABdhPJyYEaBxt+1iGUqAOnuV67ELpXWbdyFPo7UdANn1u/AcJTEpom6QjM0mjn0iIsy3VdRkmDd6LmUv1T2rU5/gPas=
X-Received: by 2002:a2e:87ca:: with SMTP id v10mr808353ljj.369.1632760997896;
 Mon, 27 Sep 2021 09:43:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210820155918.7518-1-brijesh.singh@amd.com> <20210820155918.7518-26-brijesh.singh@amd.com>
In-Reply-To: <20210820155918.7518-26-brijesh.singh@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Mon, 27 Sep 2021 10:43:06 -0600
Message-ID: <CAMkAt6qsZNJPM97Y6_8b7QmLv=n0MaDs7hThi3thFEee4P10pA@mail.gmail.com>
Subject: Re: [PATCH Part2 v5 25/45] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_UPDATE command
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
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
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        Marc Orr <marcorr@google.com>,
        sathyanarayanan.kuppuswamy@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 20, 2021 at 10:00 AM Brijesh Singh <brijesh.singh@amd.com> wrote:
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
>  .../virt/kvm/amd-memory-encryption.rst        |  29 +++
>  arch/x86/kvm/svm/sev.c                        | 187 ++++++++++++++++++
>  include/uapi/linux/kvm.h                      |  19 ++
>  3 files changed, 235 insertions(+)
>
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> index 937af3447954..ddcd94e9ffed 100644
> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> @@ -478,6 +478,35 @@ Returns: 0 on success, -negative on error
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
> index dbf04a52b23d..4b126598b7aa 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -17,6 +17,7 @@
>  #include <linux/misc_cgroup.h>
>  #include <linux/processor.h>
>  #include <linux/trace_events.h>
> +#include <linux/sev.h>
>  #include <asm/fpu/internal.h>
>
>  #include <asm/pkru.h>
> @@ -227,6 +228,49 @@ static void sev_decommission(unsigned int handle)
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
> @@ -1620,6 +1664,123 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
> +
> +       return false;
> +}

Internally we actually register the guest memory in chunks for various
reasons. So for our largest SEV VM we have 768 1 GB entries in
|sev->regions_list|. This was OK before because no look ups were done.
Now that we are performing a look ups a linked list with linear time
lookups seems not ideal, could we switch the back data structure here
to something more conducive too fast lookups?
> +
> +static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +       struct sev_data_snp_launch_update data = {0};
> +       struct kvm_sev_snp_launch_update params;
> +       unsigned long npages, pfn, n = 0;

Could we have a slightly more descriptive name for |n|? nprivate
maybe? Also why not zero in the loop below?

for (i = 0, n = 0; i < npages; ++i)

> +       int *error = &argp->error;
> +       struct page **inpages;
> +       int ret, i, level;

Should |i| be an unsigned long since it can is tracked in a for loop
with "i < npages" npages being an unsigned long? (|n| too)

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

This is *too* avoid cases...

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

Hmm if this call fails after the first iteration of this loop it will
lead to a hard to reproduce LaunchDigest right? Say if we are
SnpLaunchUpdating just 2 pages A and B. If we first call this ioctl
and A is SNP_LAUNCH_UPDATED'd but B fails, we then make A shared again
in the RMP. So we must call the ioctl with 2 pages again, after fixing
the issue with page B. Now the Launch digest has something like
Hash(A) then HASH(A & B) right (overly simplified) so A will be
included twice right? I am not sure if anything better can be done
here but might be worth documenting IIUC.

> +
> +               gfn++;
> +       }
> +
> +e_unpin:
> +       /* Content of memory is updated, mark pages dirty */
> +       for (i = 0; i < n; i++) {
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
>  int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  {
>         struct kvm_sev_cmd sev_cmd;
> @@ -1712,6 +1873,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>         case KVM_SEV_SNP_LAUNCH_START:
>                 r = snp_launch_start(kvm, &sev_cmd);
>                 break;
> +       case KVM_SEV_SNP_LAUNCH_UPDATE:
> +               r = snp_launch_update(kvm, &sev_cmd);
> +               break;
>         default:
>                 r = -EINVAL;
>                 goto out;
> @@ -1794,6 +1958,29 @@ find_enc_region(struct kvm *kvm, struct kvm_enc_region *range)
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
> index e6416e58cd9a..0681be4bdfdf 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1715,6 +1715,7 @@ enum sev_cmd_id {
>         /* SNP specific commands */
>         KVM_SEV_SNP_INIT,
>         KVM_SEV_SNP_LAUNCH_START,
> +       KVM_SEV_SNP_LAUNCH_UPDATE,
>
>         KVM_SEV_NR_MAX,
>  };
> @@ -1831,6 +1832,24 @@ struct kvm_sev_snp_launch_start {
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
> 2.17.1
>
>
