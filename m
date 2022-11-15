Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7001628DF0
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 01:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236156AbiKOAG2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 19:06:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231940AbiKOAG0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 19:06:26 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72DA75F68
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 16:06:24 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id be13so21999783lfb.4
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 16:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Az9IN8Zy1dJmBRFuDXhjgx3aGXqJvvzc74n4e9Jt26g=;
        b=kqUOFEkegtme2mkhbD4Uil3tRf50K+VQP7vXlPGBjCgIbHzRga0AvXBquvfT39LicL
         labZrsZ2ngDm1S4DOXhW9bNQp0ag5bOKHrUbpphasCEUwIKaVSzHr6598tnDgGGkIwzx
         sBicPU81ymnx7/9IAktLVz9fb5YAKFDN3D0act5ZF2pdFvbm1/XsDNDpxgVVLx23NFIZ
         FzvQQIKKoDbuqNts+l/ijHYR8e76a7SZ77rT7y0jTB7QRepC4ow+QiwkQQZUddZx9eWk
         /d1ve75v4eYDNeCNvoPWtFmpj7qZg2zObiazWjEUng0CfJzMBZPqHifSmSLuz/U7BVmM
         io9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Az9IN8Zy1dJmBRFuDXhjgx3aGXqJvvzc74n4e9Jt26g=;
        b=1Bo4oEvDMN+zmvCvWLeSPou9V7ekVUq06glE3wYYt7hGIJgxJ5/czsZyO3YsmqYhvJ
         prWI+RD8ZuvN3OHAPSlxLSYj66K72Zw35x6ncUKi0s7y1ehOOXpOg4a9g6ZCrlvnyI9C
         XT5SwgXfPl8CNjoaXNfTL7dXdKs3RFJi2Iw8JtnsUAKNLRHiDI5lC9lDwyM94XPA0RPw
         y+HZjdzHhLkDWT7xGQx0qi876ASu02HutyY7p9FdmigfR3rpepmIPugT/RO2ldE+V/iF
         LW1D9aU3/wj2fMhxZ1JYM5G9ixL6dMZN7jdh2+NBALS+MTo8EJ043UNMg2o16mdGyBgT
         ii3A==
X-Gm-Message-State: ANoB5pmDx8alhQOVWQ2eNJFMSD6wa0XViZ18Kh5soFFRtaaKaDObC5Kv
        saAYj3oEenxGqpDRmHk0JefNlfuR5qnlVgA/fJO7Hw==
X-Google-Smtp-Source: AA0mqf7gX3vqtDi3Yxs47Cl+MK4x4aGqDk7az/9AZvPqY8qzUX5ZW2cLAnPFLGSy61pSQZSXZP0tHCzwk6xxkixN23s=
X-Received: by 2002:a05:6512:b8c:b0:4a4:5f2e:49b3 with SMTP id
 b12-20020a0565120b8c00b004a45f2e49b3mr4723628lfv.148.1668470782274; Mon, 14
 Nov 2022 16:06:22 -0800 (PST)
MIME-Version: 1.0
References: <cover.1667110240.git.isaku.yamahata@intel.com> <fb337a67e17715977e46523d1344cb2a7f46a37a.1667110240.git.isaku.yamahata@intel.com>
In-Reply-To: <fb337a67e17715977e46523d1344cb2a7f46a37a.1667110240.git.isaku.yamahata@intel.com>
From:   Sagi Shahar <sagis@google.com>
Date:   Mon, 14 Nov 2022 16:06:10 -0800
Message-ID: <CAAhR5DFGvGQmf95hrGcK0uvawvFrzdCisnEtvLV8k8pM3FRV_w@mail.gmail.com>
Subject: Re: [PATCH v10 016/108] KVM: TDX: create/destroy VM structure
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 29, 2022 at 11:24 PM <isaku.yamahata@intel.com> wrote:
>
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> As the first step to create TDX guest, create/destroy VM struct.  Assign
> TDX private Host Key ID (HKID) to the TDX guest for memory encryption and
> allocate extra pages for the TDX guest. On destruction, free allocated
> pages, and HKID.
>
> Before tearing down private page tables, TDX requires some resources of the
> guest TD to be destroyed (i.e. keyID must have been reclaimed, etc).  Add
> flush_shadow_all_private callback before tearing down private page tables
> for it.
>
> Add a second kvm_x86_ops hook in kvm_arch_destroy_vm() to support TDX's
> destruction path, which needs to first put the VM into a teardown state,
> then free per-vCPU resources, and finally free per-VM resources.
>
> Co-developed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |   2 +
>  arch/x86/include/asm/kvm_host.h    |   2 +
>  arch/x86/kvm/vmx/main.c            |  34 ++-
>  arch/x86/kvm/vmx/tdx.c             | 411 +++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/tdx.h             |   2 +
>  arch/x86/kvm/vmx/x86_ops.h         |  11 +
>  arch/x86/kvm/x86.c                 |   8 +
>  7 files changed, 467 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 8a5c5ae70bc5..3a29a6b31ee8 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -21,7 +21,9 @@ KVM_X86_OP(has_emulated_msr)
>  KVM_X86_OP(vcpu_after_set_cpuid)
>  KVM_X86_OP(is_vm_type_supported)
>  KVM_X86_OP(vm_init)
> +KVM_X86_OP_OPTIONAL(flush_shadow_all_private)
>  KVM_X86_OP_OPTIONAL(vm_destroy)
> +KVM_X86_OP_OPTIONAL(vm_free)
>  KVM_X86_OP_OPTIONAL_RET0(vcpu_precreate)
>  KVM_X86_OP(vcpu_create)
>  KVM_X86_OP(vcpu_free)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 2a41a93a80f3..2870155ce6fb 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1472,7 +1472,9 @@ struct kvm_x86_ops {
>         bool (*is_vm_type_supported)(unsigned long vm_type);
>         unsigned int vm_size;
>         int (*vm_init)(struct kvm *kvm);
> +       void (*flush_shadow_all_private)(struct kvm *kvm);
>         void (*vm_destroy)(struct kvm *kvm);
> +       void (*vm_free)(struct kvm *kvm);
>
>         /* Create, but do not attach this VCPU */
>         int (*vcpu_precreate)(struct kvm *kvm);
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 0900ff2f2390..d01a946a18cf 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -29,18 +29,44 @@ static __init int vt_hardware_setup(void)
>         return 0;
>  }
>
> +static void vt_hardware_unsetup(void)
> +{
> +       tdx_hardware_unsetup();
> +       vmx_hardware_unsetup();
> +}
> +
>  static int vt_vm_init(struct kvm *kvm)
>  {
>         if (is_td(kvm))
> -               return -EOPNOTSUPP;     /* Not ready to create guest TD yet. */
> +               return tdx_vm_init(kvm);
>
>         return vmx_vm_init(kvm);
>  }
>
> +static void vt_flush_shadow_all_private(struct kvm *kvm)
> +{
> +       if (is_td(kvm))
> +               return tdx_mmu_release_hkid(kvm);
> +}
> +
> +static void vt_vm_destroy(struct kvm *kvm)
> +{
> +       if (is_td(kvm))
> +               return;
> +
> +       vmx_vm_destroy(kvm);
> +}
> +
> +static void vt_vm_free(struct kvm *kvm)
> +{
> +       if (is_td(kvm))
> +               return tdx_vm_free(kvm);
> +}
> +
>  struct kvm_x86_ops vt_x86_ops __initdata = {
>         .name = "kvm_intel",
>
> -       .hardware_unsetup = vmx_hardware_unsetup,
> +       .hardware_unsetup = vt_hardware_unsetup,
>         .check_processor_compatibility = vmx_check_processor_compatibility,
>
>         .hardware_enable = vmx_hardware_enable,
> @@ -50,7 +76,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>         .is_vm_type_supported = vt_is_vm_type_supported,
>         .vm_size = sizeof(struct kvm_vmx),
>         .vm_init = vt_vm_init,
> -       .vm_destroy = vmx_vm_destroy,
> +       .flush_shadow_all_private = vt_flush_shadow_all_private,
> +       .vm_destroy = vt_vm_destroy,
> +       .vm_free = vt_vm_free,
>
>         .vcpu_precreate = vmx_vcpu_precreate,
>         .vcpu_create = vmx_vcpu_create,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 530e72f85762..ec88dde0d300 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -32,6 +32,401 @@ struct tdx_capabilities {
>  /* Capabilities of KVM + the TDX module. */
>  static struct tdx_capabilities tdx_caps;
>
> +/*
> + * Some TDX SEAMCALLs (TDH.MNG.CREATE, TDH.PHYMEM.CACHE.WB,
> + * TDH.MNG.KEY.RECLAIMID, TDH.MNG.KEY.FREEID etc) tries to acquire a global lock
> + * internally in TDX module.  If failed, TDX_OPERAND_BUSY is returned without
> + * spinning or waiting due to a constraint on execution time.  It's caller's
> + * responsibility to avoid race (or retry on TDX_OPERAND_BUSY).  Use this mutex
> + * to avoid race in TDX module because the kernel knows better about scheduling.
> + */
> +static DEFINE_MUTEX(tdx_lock);
> +static struct mutex *tdx_mng_key_config_lock;
> +
> +static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
> +{
> +       return pa | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
> +}
> +
> +static inline bool is_td_created(struct kvm_tdx *kvm_tdx)
> +{
> +       return kvm_tdx->tdr.added;
> +}
> +
> +static inline void tdx_hkid_free(struct kvm_tdx *kvm_tdx)
> +{
> +       tdx_keyid_free(kvm_tdx->hkid);
> +       kvm_tdx->hkid = -1;
> +}
> +
> +static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
> +{
> +       return kvm_tdx->hkid > 0;
> +}
> +
> +static void tdx_clear_page(unsigned long page)
> +{
> +       const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
> +       unsigned long i;
> +
> +       /*
> +        * Zeroing the page is only necessary for systems with MKTME-i:
> +        * when re-assign one page from old keyid to a new keyid, MOVDIR64B is
> +        * required to clear/write the page with new keyid to prevent integrity
> +        * error when read on the page with new keyid.
> +        *
> +        * The cache line could be poisoned (even without MKTME-i), clear the
> +        * poison bit.
> +        */
> +       for (i = 0; i < PAGE_SIZE; i += 64)
> +               movdir64b((void *)(page + i), zero_page);
> +       /*
> +        * MOVDIR64B store uses WC buffer.  Prevent following memory reads
> +        * from seeing potentially poisoned cache.
> +        */
> +       __mb();
> +}
> +
> +static int tdx_reclaim_page(unsigned long va, hpa_t pa, bool do_wb, u16 hkid)
> +{
> +       struct tdx_module_output out;
> +       u64 err;
> +
> +       do {
> +               err = tdh_phymem_page_reclaim(pa, &out);
> +               /*
> +                * TDH.PHYMEM.PAGE.RECLAIM is allowed only when TD is shutdown.
> +                * state.  i.e. destructing TD.
> +                * TDH.PHYMEM.PAGE.RECLAIM  requires TDR and target page.
> +                * Because we're destructing TD, it's rare to contend with TDR.
> +                */
> +       } while (err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX));
> +       if (WARN_ON_ONCE(err)) {
> +               pr_tdx_error(TDH_PHYMEM_PAGE_RECLAIM, err, &out);
> +               return -EIO;
> +       }
> +
> +       if (do_wb) {
> +               /*
> +                * Only TDR page gets into this path.  No contention is expected
> +                * because the last page of TD.
> +                */
> +               err = tdh_phymem_page_wbinvd(set_hkid_to_hpa(pa, hkid));
> +               if (WARN_ON_ONCE(err)) {
> +                       pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
> +                       return -EIO;
> +               }
> +       }
> +
> +       tdx_clear_page(va);
> +       return 0;
> +}
> +
> +static int tdx_alloc_td_page(struct tdx_td_page *page)
> +{
> +       page->va = __get_free_page(GFP_KERNEL_ACCOUNT);
> +       if (!page->va)
> +               return -ENOMEM;
> +
> +       page->pa = __pa(page->va);
> +       return 0;
> +}
> +
> +static inline void tdx_mark_td_page_added(struct tdx_td_page *page)
> +{
> +       WARN_ON_ONCE(page->added);
> +       page->added = true;
> +}
> +
> +static void tdx_reclaim_td_page(struct tdx_td_page *page)
> +{
> +       if (page->added) {
> +               /*
> +                * TDCX are being reclaimed.  TDX module maps TDCX with HKID
> +                * assigned to the TD.  Here the cache associated to the TD
> +                * was already flushed by TDH.PHYMEM.CACHE.WB before here, So
> +                * cache doesn't need to be flushed again.
> +                */
> +               if (tdx_reclaim_page(page->va, page->pa, false, 0))
> +                       return;
> +
> +               page->added = false;
> +       }
> +       if (page->va) {
> +               free_page(page->va);
> +               page->va = 0;
> +       }
> +}
> +
> +static int tdx_do_tdh_phymem_cache_wb(void *param)
> +{
> +       u64 err = 0;
> +
> +       do {
> +               err = tdh_phymem_cache_wb(!!err);
> +       } while (err == TDX_INTERRUPTED_RESUMABLE);
> +
> +       /* Other thread may have done for us. */
> +       if (err == TDX_NO_HKID_READY_TO_WBCACHE)
> +               err = TDX_SUCCESS;
> +       if (WARN_ON_ONCE(err)) {
> +               pr_tdx_error(TDH_PHYMEM_CACHE_WB, err, NULL);
> +               return -EIO;
> +       }
> +
> +       return 0;
> +}
> +
> +void tdx_mmu_release_hkid(struct kvm *kvm)
> +{
> +       struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +       cpumask_var_t packages;
> +       bool cpumask_allocated;
> +       u64 err;
> +       int ret;
> +       int i;
> +
> +       if (!is_hkid_assigned(kvm_tdx))
> +               return;
> +
> +       if (!is_td_created(kvm_tdx))
> +               goto free_hkid;
> +
> +       cpumask_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
> +       cpus_read_lock();
> +       for_each_online_cpu(i) {
> +               if (cpumask_allocated &&
> +                       cpumask_test_and_set_cpu(topology_physical_package_id(i),
> +                                               packages))
> +                       continue;
> +
> +               /*
> +                * We can destroy multiple the guest TDs simultaneously.
> +                * Prevent tdh_phymem_cache_wb from returning TDX_BUSY by
> +                * serialization.
> +                */
> +               mutex_lock(&tdx_lock);
> +               ret = smp_call_on_cpu(i, tdx_do_tdh_phymem_cache_wb, NULL, 1);
> +               mutex_unlock(&tdx_lock);
> +               if (ret)
> +                       break;
> +       }
> +       cpus_read_unlock();
> +       free_cpumask_var(packages);
> +
> +       mutex_lock(&tdx_lock);
> +       err = tdh_mng_key_freeid(kvm_tdx->tdr.pa);
> +       mutex_unlock(&tdx_lock);
> +       if (WARN_ON_ONCE(err)) {
> +               pr_tdx_error(TDH_MNG_KEY_FREEID, err, NULL);
> +               pr_err("tdh_mng_key_freeid failed. HKID %d is leaked.\n",
> +                       kvm_tdx->hkid);
> +               return;
> +       }
> +
> +free_hkid:
> +       tdx_hkid_free(kvm_tdx);
> +}
> +
> +void tdx_vm_free(struct kvm *kvm)
> +{
> +       struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +       int i;
> +
> +       /* Can't reclaim or free TD pages if teardown failed. */
> +       if (is_hkid_assigned(kvm_tdx))
> +               return;
> +
> +       if (kvm_tdx->tdcs) {
> +               for (i = 0; i < tdx_caps.tdcs_nr_pages; i++)
> +                       tdx_reclaim_td_page(&kvm_tdx->tdcs[i]);
> +               kfree(kvm_tdx->tdcs);
> +       }
> +
> +       /*
> +        * TDX module maps TDR with TDX global HKID.  TDX module may access TDR
> +        * while operating on TD (Especially reclaiming TDCS).  Cache flush with
> +        * TDX global HKID is needed.
> +        */
> +       if (kvm_tdx->tdr.added &&
> +               tdx_reclaim_page(kvm_tdx->tdr.va, kvm_tdx->tdr.pa, true,
> +                               tdx_global_keyid))
> +               return;
> +
> +       free_page(kvm_tdx->tdr.va);
> +}
> +
> +static int tdx_do_tdh_mng_key_config(void *param)
> +{
> +       hpa_t *tdr_p = param;
> +       u64 err;
> +
> +       do {
> +               err = tdh_mng_key_config(*tdr_p);
> +
> +               /*
> +                * If it failed to generate a random key, retry it because this
> +                * is typically caused by an entropy error of the CPU's random
> +                * number generator.
> +                */
> +       } while (err == TDX_KEY_GENERATION_FAILED);
> +
> +       if (WARN_ON_ONCE(err)) {
> +               pr_tdx_error(TDH_MNG_KEY_CONFIG, err, NULL);
> +               return -EIO;
> +       }
> +
> +       return 0;
> +}
> +
> +int tdx_vm_init(struct kvm *kvm)
> +{
> +       struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +       cpumask_var_t packages;
> +       int ret, i;
> +       u64 err;
> +
> +       ret = tdx_keyid_alloc();

Can we skip the hkid allocation at such an early stage?
This makes intra-host migration more complicated as the hkid of the
destination VM is already allocated before we have a chance to migrate
the state from the source VM.

I remember you had an internal version that already did that in
https://github.com/intel/tdx/blob/552dd80c48f67ca01bcdd10667e0c11efd375177/arch/x86/kvm/vmx/tdx.c#L508

> +       if (ret < 0)
> +               return ret;
> +       kvm_tdx->hkid = ret;
> +
> +       ret = tdx_alloc_td_page(&kvm_tdx->tdr);
> +       if (ret)
> +               goto free_hkid;
> +
> +       kvm_tdx->tdcs = kcalloc(tdx_caps.tdcs_nr_pages, sizeof(*kvm_tdx->tdcs),
> +                               GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +       if (!kvm_tdx->tdcs)
> +               goto free_tdr;
> +       for (i = 0; i < tdx_caps.tdcs_nr_pages; i++) {
> +               ret = tdx_alloc_td_page(&kvm_tdx->tdcs[i]);
> +               if (ret)
> +                       goto free_tdcs;
> +       }
> +
> +       if (!zalloc_cpumask_var(&packages, GFP_KERNEL)) {
> +               ret = -ENOMEM;
> +               goto free_tdcs;
> +       }
> +       cpus_read_lock();
> +       /*
> +        * Need at least one CPU of the package to be online in order to
> +        * program all packages for host key id.  Check it.
> +        */
> +       for_each_present_cpu(i)
> +               cpumask_set_cpu(topology_physical_package_id(i), packages);
> +       for_each_online_cpu(i)
> +               cpumask_clear_cpu(topology_physical_package_id(i), packages);
> +       if (!cpumask_empty(packages)) {
> +               ret = -EIO;
> +               /*
> +                * Because it's hard for human operator to figure out the
> +                * reason, warn it.
> +                */
> +               pr_warn("All packages need to have online CPU to create TD. Online CPU and retry.\n");
> +               goto free_packages;
> +       }
> +
> +       /*
> +        * Acquire global lock to avoid TDX_OPERAND_BUSY:
> +        * TDH.MNG.CREATE and other APIs try to lock the global Key Owner
> +        * Table (KOT) to track the assigned TDX private HKID.  It doesn't spin
> +        * to acquire the lock, returns TDX_OPERAND_BUSY instead, and let the
> +        * caller to handle the contention.  This is because of time limitation
> +        * usable inside the TDX module and OS/VMM knows better about process
> +        * scheduling.
> +        *
> +        * APIs to acquire the lock of KOT:
> +        * TDH.MNG.CREATE, TDH.MNG.KEY.FREEID, TDH.MNG.VPFLUSHDONE, and
> +        * TDH.PHYMEM.CACHE.WB.
> +        */
> +       mutex_lock(&tdx_lock);
> +       err = tdh_mng_create(kvm_tdx->tdr.pa, kvm_tdx->hkid);
> +       mutex_unlock(&tdx_lock);
> +       if (WARN_ON_ONCE(err)) {
> +               pr_tdx_error(TDH_MNG_CREATE, err, NULL);
> +               ret = -EIO;
> +               goto free_packages;
> +       }
> +       tdx_mark_td_page_added(&kvm_tdx->tdr);
> +
> +       for_each_online_cpu(i) {
> +               int pkg = topology_physical_package_id(i);
> +
> +               if (cpumask_test_and_set_cpu(pkg, packages))
> +                       continue;
> +
> +               /*
> +                * Program the memory controller in the package with an
> +                * encryption key associated to a TDX private host key id
> +                * assigned to this TDR.  Concurrent operations on same memory
> +                * controller results in TDX_OPERAND_BUSY.  Avoid this race by
> +                * mutex.
> +                */
> +               mutex_lock(&tdx_mng_key_config_lock[pkg]);
> +               ret = smp_call_on_cpu(i, tdx_do_tdh_mng_key_config,
> +                                     &kvm_tdx->tdr.pa, true);
> +               mutex_unlock(&tdx_mng_key_config_lock[pkg]);
> +               if (ret)
> +                       break;
> +       }
> +       cpus_read_unlock();
> +       free_cpumask_var(packages);
> +       if (ret)
> +               goto teardown;
> +
> +       for (i = 0; i < tdx_caps.tdcs_nr_pages; i++) {
> +               err = tdh_mng_addcx(kvm_tdx->tdr.pa, kvm_tdx->tdcs[i].pa);
> +               if (WARN_ON_ONCE(err)) {
> +                       pr_tdx_error(TDH_MNG_ADDCX, err, NULL);
> +                       ret = -EIO;
> +                       goto teardown;
> +               }
> +               tdx_mark_td_page_added(&kvm_tdx->tdcs[i]);
> +       }
> +
> +       /*
> +        * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT requires a dedicated
> +        * ioctl() to define the configure CPUID values for the TD.
> +        */
> +       return 0;
> +
> +       /*
> +        * The sequence for freeing resources from a partially initialized TD
> +        * varies based on where in the initialization flow failure occurred.
> +        * Simply use the full teardown and destroy, which naturally play nice
> +        * with partial initialization.
> +        */
> +teardown:
> +       tdx_mmu_release_hkid(kvm);
> +       tdx_vm_free(kvm);
> +       return ret;
> +
> +free_packages:
> +       cpus_read_unlock();
> +       free_cpumask_var(packages);
> +free_tdcs:
> +       for (i = 0; i < tdx_caps.tdcs_nr_pages; i++) {
> +               if (!kvm_tdx->tdcs[i].va)
> +                       continue;
> +               free_page(kvm_tdx->tdcs[i].va);
> +       }
> +       kfree(kvm_tdx->tdcs);
> +       kvm_tdx->tdcs = NULL;
> +free_tdr:
> +       if (kvm_tdx->tdr.va) {
> +               free_page(kvm_tdx->tdr.va);
> +               kvm_tdx->tdr.added = false;
> +               kvm_tdx->tdr.va = 0;
> +               kvm_tdx->tdr.pa = 0;
> +       }
> +free_hkid:
> +       if (kvm_tdx->hkid != -1)
> +               tdx_hkid_free(kvm_tdx);
> +       return ret;
> +}
> +
>  static int __init tdx_module_setup(void)
>  {
>         const struct tdsysinfo_struct *tdsysinfo;
> @@ -82,6 +477,8 @@ bool tdx_is_vm_type_supported(unsigned long type)
>
>  int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
>  {
> +       int max_pkgs;
> +       int i;
>         int r;
>
>         if (!enable_ept) {
> @@ -95,6 +492,14 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
>                 return -ENODEV;
>         }
>
> +       max_pkgs = topology_max_packages();
> +       tdx_mng_key_config_lock = kcalloc(max_pkgs, sizeof(*tdx_mng_key_config_lock),
> +                                  GFP_KERNEL);
> +       if (!tdx_mng_key_config_lock)
> +               return -ENOMEM;
> +       for (i = 0; i < max_pkgs; i++)
> +               mutex_init(&tdx_mng_key_config_lock[i]);
> +
>         /* TDX requires VMX. */
>         r = vmxon_all();
>         if (!r)
> @@ -103,3 +508,9 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
>
>         return r;
>  }
> +
> +void tdx_hardware_unsetup(void)
> +{
> +       /* kfree accepts NULL. */
> +       kfree(tdx_mng_key_config_lock);
> +}
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 98999bf3f188..938314635b47 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -17,6 +17,8 @@ struct kvm_tdx {
>
>         struct tdx_td_page tdr;
>         struct tdx_td_page *tdcs;
> +
> +       int hkid;
>  };
>
>  struct vcpu_tdx {
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index ac1688b0b0e3..95da978c9aa9 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -133,9 +133,20 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
>  #ifdef CONFIG_INTEL_TDX_HOST
>  int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
>  bool tdx_is_vm_type_supported(unsigned long type);
> +void tdx_hardware_unsetup(void);
> +
> +int tdx_vm_init(struct kvm *kvm);
> +void tdx_mmu_release_hkid(struct kvm *kvm);
> +void tdx_vm_free(struct kvm *kvm);
>  #else
>  static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
>  static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
> +static inline void tdx_hardware_unsetup(void) {}
> +
> +static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
> +static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
> +static inline void tdx_flush_shadow_all_private(struct kvm *kvm) {}
> +static inline void tdx_vm_free(struct kvm *kvm) {}
>  #endif
>
>  #endif /* __KVM_X86_VMX_X86_OPS_H */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 91053fdc4512..4b22196cb12c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12702,6 +12702,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>         kvm_page_track_cleanup(kvm);
>         kvm_xen_destroy_vm(kvm);
>         kvm_hv_destroy_vm(kvm);
> +       static_call_cond(kvm_x86_vm_free)(kvm);
>  }
>
>  static void memslot_rmap_free(struct kvm_memory_slot *slot)
> @@ -13012,6 +13013,13 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>
>  void kvm_arch_flush_shadow_all(struct kvm *kvm)
>  {
> +       /*
> +        * kvm_mmu_zap_all() zaps both private and shared page tables.  Before
> +        * tearing down private page tables, TDX requires some TD resources to
> +        * be destroyed (i.e. keyID must have been reclaimed, etc).  Invoke
> +        * kvm_x86_flush_shadow_all_private() for this.
> +        */
> +       static_call_cond(kvm_x86_flush_shadow_all_private)(kvm);
>         kvm_mmu_zap_all(kvm);
>  }
>
> --
> 2.25.1
>
