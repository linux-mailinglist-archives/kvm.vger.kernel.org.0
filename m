Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53BCB77D27C
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 20:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239463AbjHOSvC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 14:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239595AbjHOSuy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 14:50:54 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFBE2688
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 11:50:29 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2b9b904bb04so92176021fa.1
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 11:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692125415; x=1692730215;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dHt7TuIICG9h1Hjps9RfjKxzUr/a7gkVi7bZkYQhJnY=;
        b=jfVO2gv/D3STtcS/c7Do8Qeupk0u4FySEJfL1dIWXBBpv/tIwvFcLw9mpJQVX4zaB/
         6LJhhC6KVNn1yPex7cWjjCshBrN7KGk2VdumDaR0lKBn6fe7Sw5XY+/oWElxieUZ1B2l
         wY19xhlDcdwPpqtaxWIBe9gHarUKFjP8lAnwojuVJc5hQwPOCaX4GqtgV9vVlqTegBaz
         0yqShVXDe6GaMQAwrV/Vks/A36OXL7muFMmcf5vEJLW9Weia1K9PjBu3YibDIu3WI6Tu
         qkgj//5ftNBDQ0eBGZ1cx6IfYxz9MJ+bTLP9zmDVY2ag9u40cdTMo3vUjff2Fnhby96P
         H4Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692125415; x=1692730215;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dHt7TuIICG9h1Hjps9RfjKxzUr/a7gkVi7bZkYQhJnY=;
        b=KkQ7t8eTlAu9so3Sdpq73gOT3NEKBn8n8FNeffhU1NrQ8A5EKcSNGSQLPlB4v//B0K
         gKWxgC1fTjCDAwDvm64BasLIt+x1vQwuA3Mwb8MD06qofiBqAfSEpjZmjNBfKTCCTLFR
         f7T+a5zIFdJfLeuZO2iqWioY08BkWu9T2jaCfYGDCcMLRCus1MiXIfKkveELefyWiSny
         OCKSQpTtUkIqPyaOULGaEmQlW7EDuMwrBWIxinMCsso1TZSigW9fj3VlQR5Kqo+2wbQs
         5w167fT+gdD9zkvlq2ruXZiiEZ4rypXntCsMtfUgidu5BnGbHUI0MMV3XIKBJUvDwBBr
         Kfug==
X-Gm-Message-State: AOJu0YxWobcNMtWRtDuWWBWZmrbZLO+Jm4m5Nkd/e879N+p6Z9x2EIPU
        JYyco22J+3nwfZpsP7iAvNzZwY8rshFKghh0OG43Z/qQJqBw4V/BinKf6w==
X-Google-Smtp-Source: AGHT+IE9TK4lXAiVKvxwV7WjNSw2lx0pvj2Za+gR18Zn3KmoDZnp7fISMixYXbFPgqdZwH3LYoacnpLifN0fgKqFulw=
X-Received: by 2002:a05:6512:60a:b0:4fe:ae7:d906 with SMTP id
 b10-20020a056512060a00b004fe0ae7d906mr8112628lfe.65.1692125414580; Tue, 15
 Aug 2023 11:50:14 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1690322424.git.isaku.yamahata@intel.com> <19a589ab40b01c10c3b9addc5c38f3fe64b15ad0.1690322424.git.isaku.yamahata@intel.com>
In-Reply-To: <19a589ab40b01c10c3b9addc5c38f3fe64b15ad0.1690322424.git.isaku.yamahata@intel.com>
From:   Sagi Shahar <sagis@google.com>
Date:   Tue, 15 Aug 2023 11:50:02 -0700
Message-ID: <CAAhR5DG8hHKVjoN+pWKBVivSm8zkBX5NMbKAuWUL2Tkhaj1YRQ@mail.gmail.com>
Subject: Re: [PATCH v15 059/115] KVM: TDX: Create initial guest memory
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 25, 2023 at 3:15=E2=80=AFPM <isaku.yamahata@intel.com> wrote:
>
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Because the guest memory is protected in TDX, the creation of the initial
> guest memory requires a dedicated TDX module API, tdh_mem_page_add, inste=
ad
> of directly copying the memory contents into the guest memory in the case
> of the default VM type.  KVM MMU page fault handler callback,
> private_page_add, handles it.
>
> Define new subcommand, KVM_TDX_INIT_MEM_REGION, of VM-scoped
> KVM_MEMORY_ENCRYPT_OP.  It assigns the guest page, copies the initial
> memory contents into the guest memory, encrypts the guest memory.  At the
> same time, optionally it extends memory measurement of the TDX guest.  It
> calls the KVM MMU page fault(EPT-violation) handler to trigger the
> callbacks for it.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>
> ---
> v14 -> v15:
> - add a check if TD is finalized or not to tdx_init_mem_region()
> - return -EAGAIN when partial population
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/uapi/asm/kvm.h       |   9 ++
>  arch/x86/kvm/mmu/mmu.c                |   1 +
>  arch/x86/kvm/vmx/tdx.c                | 158 +++++++++++++++++++++++++-
>  arch/x86/kvm/vmx/tdx.h                |   2 +
>  tools/arch/x86/include/uapi/asm/kvm.h |   9 ++
>  5 files changed, 174 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/=
kvm.h
> index 311a7894b712..a1815fcbb0be 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -572,6 +572,7 @@ enum kvm_tdx_cmd_id {
>         KVM_TDX_CAPABILITIES =3D 0,
>         KVM_TDX_INIT_VM,
>         KVM_TDX_INIT_VCPU,
> +       KVM_TDX_INIT_MEM_REGION,
>
>         KVM_TDX_CMD_NR_MAX,
>  };
> @@ -645,4 +646,12 @@ struct kvm_tdx_init_vm {
>         struct kvm_cpuid2 cpuid;
>  };
>
> +#define KVM_TDX_MEASURE_MEMORY_REGION  (1UL << 0)
> +
> +struct kvm_tdx_init_mem_region {
> +       __u64 source_addr;
> +       __u64 gpa;
> +       __u64 nr_pages;
> +};
> +
>  #endif /* _ASM_X86_KVM_H */
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 7ef66d8a785b..0d218d930d0a 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5704,6 +5704,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
>  out:
>         return r;
>  }
> +EXPORT_SYMBOL(kvm_mmu_load);
>
>  void kvm_mmu_unload(struct kvm_vcpu *vcpu)
>  {
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index e367351f8d71..32e84c29d35e 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -446,6 +446,21 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t r=
oot_hpa, int pgd_level)
>         td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE=
_MASK);
>  }
>
> +static void tdx_measure_page(struct kvm_tdx *kvm_tdx, hpa_t gpa)
> +{
> +       struct tdx_module_output out;
> +       u64 err;
> +       int i;
> +
> +       for (i =3D 0; i < PAGE_SIZE; i +=3D TDX_EXTENDMR_CHUNKSIZE) {
> +               err =3D tdh_mr_extend(kvm_tdx->tdr_pa, gpa + i, &out);
> +               if (KVM_BUG_ON(err, &kvm_tdx->kvm)) {
> +                       pr_tdx_error(TDH_MR_EXTEND, err, &out);
> +                       break;
> +               }
> +       }
> +}
> +
>  static void tdx_unpin(struct kvm *kvm, kvm_pfn_t pfn)
>  {
>         struct page *page =3D pfn_to_page(pfn);
> @@ -460,12 +475,10 @@ static int tdx_sept_set_private_spte(struct kvm *kv=
m, gfn_t gfn,
>         hpa_t hpa =3D pfn_to_hpa(pfn);
>         gpa_t gpa =3D gfn_to_gpa(gfn);
>         struct tdx_module_output out;
> +       hpa_t source_pa;
> +       bool measure;
>         u64 err;
>
> -       /* TODO: handle large pages. */
> -       if (KVM_BUG_ON(level !=3D PG_LEVEL_4K, kvm))
> -               return -EINVAL;
> -
>         /*
>          * Because restricted mem doesn't support page migration with
>          * a_ops->migrate_page (yet), no callback isn't triggered for KVM=
 on
> @@ -476,7 +489,12 @@ static int tdx_sept_set_private_spte(struct kvm *kvm=
, gfn_t gfn,
>          */
>         get_page(pfn_to_page(pfn));
>
> +       /* Build-time faults are induced and handled via TDH_MEM_PAGE_ADD=
. */
>         if (likely(is_td_finalized(kvm_tdx))) {
> +               /* TODO: handle large pages. */
> +               if (KVM_BUG_ON(level !=3D PG_LEVEL_4K, kvm))
> +                       return -EINVAL;
> +
>                 err =3D tdh_mem_page_aug(kvm_tdx->tdr_pa, gpa, hpa, &out)=
;
>                 if (unlikely(err =3D=3D TDX_ERROR_SEPT_BUSY)) {
>                         tdx_unpin(kvm, pfn);
> @@ -490,7 +508,45 @@ static int tdx_sept_set_private_spte(struct kvm *kvm=
, gfn_t gfn,
>                 return 0;
>         }
>
> -       /* TODO: tdh_mem_page_add() comes here for the initial memory. */
> +       /*
> +        * KVM_INIT_MEM_REGION, tdx_init_mem_region(), supports only 4K p=
age
> +        * because tdh_mem_page_add() supports only 4K page.
> +        */
> +       if (KVM_BUG_ON(level !=3D PG_LEVEL_4K, kvm))
> +               return -EINVAL;
> +
> +       /*
> +        * In case of TDP MMU, fault handler can run concurrently.  Note
> +        * 'source_pa' is a TD scope variable, meaning if there are multi=
ple
> +        * threads reaching here with all needing to access 'source_pa', =
it
> +        * will break.  However fortunately this won't happen, because be=
low
> +        * TDH_MEM_PAGE_ADD code path is only used when VM is being creat=
ed
> +        * before it is running, using KVM_TDX_INIT_MEM_REGION ioctl (whi=
ch
> +        * always uses vcpu 0's page table and protected by vcpu->mutex).
> +        */
> +       if (KVM_BUG_ON(kvm_tdx->source_pa =3D=3D INVALID_PAGE, kvm)) {
> +               tdx_unpin(kvm, pfn);
> +               return -EINVAL;
> +       }
> +
> +       source_pa =3D kvm_tdx->source_pa & ~KVM_TDX_MEASURE_MEMORY_REGION=
;
> +       measure =3D kvm_tdx->source_pa & KVM_TDX_MEASURE_MEMORY_REGION;
> +       kvm_tdx->source_pa =3D INVALID_PAGE;
> +
> +       do {
> +               err =3D tdh_mem_page_add(kvm_tdx->tdr_pa, gpa, hpa, sourc=
e_pa,
> +                                      &out);
> +               /*
> +                * This path is executed during populating initial guest =
memory
> +                * image. i.e. before running any vcpu.  Race is rare.
> +                */
> +       } while (unlikely(err =3D=3D TDX_ERROR_SEPT_BUSY));
> +       if (KVM_BUG_ON(err, kvm)) {
> +               pr_tdx_error(TDH_MEM_PAGE_ADD, err, &out);
> +               tdx_unpin(kvm, pfn);
> +               return -EIO;
> +       } else if (measure)
> +               tdx_measure_page(kvm_tdx, gpa);
>
>         return 0;
>  }
> @@ -1215,6 +1271,95 @@ void tdx_flush_tlb_current(struct kvm_vcpu *vcpu)
>         tdx_track(to_kvm_tdx(vcpu->kvm));
>  }
>
> +#define TDX_SEPT_PFERR (PFERR_WRITE_MASK | PFERR_GUEST_ENC_MASK)
> +
> +static int tdx_init_mem_region(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
> +{
> +       struct kvm_tdx *kvm_tdx =3D to_kvm_tdx(kvm);
> +       struct kvm_tdx_init_mem_region region;
> +       struct kvm_vcpu *vcpu;
> +       struct page *page;
> +       int idx, ret =3D 0;
> +       bool added =3D false;
> +
> +       /* Once TD is finalized, the initial guest memory is fixed. */
> +       if (is_td_finalized(kvm_tdx))
> +               return -EINVAL;
> +
> +       /* The BSP vCPU must be created before initializing memory region=
s. */
> +       if (!atomic_read(&kvm->online_vcpus))
> +               return -EINVAL;
> +
> +       if (cmd->flags & ~KVM_TDX_MEASURE_MEMORY_REGION)
> +               return -EINVAL;
> +
> +       if (copy_from_user(&region, (void __user *)cmd->data, sizeof(regi=
on)))
> +               return -EFAULT;
> +
> +       /* Sanity check */
> +       if (!IS_ALIGNED(region.source_addr, PAGE_SIZE) ||
> +           !IS_ALIGNED(region.gpa, PAGE_SIZE) ||
> +           !region.nr_pages ||
> +           region.gpa + (region.nr_pages << PAGE_SHIFT) <=3D region.gpa =
||

During an internal security review we noticed that region.nr_pages is
always checked after it's shifted but when it is used it is not
shifted. This means that if any of the upper 12 bits are set then we
will pass the sanity check but the while loop below will run over a
much larger range than expected.

A simple fix would be to add the following check to test if any of the
shifted bits is set:
+           (region.nr_pages << PAGE_SHIFT) >> PAGE_SHIFT !=3D region.nr_pa=
ges ||

Reported-by: gkirkpatrick@google.com

> +           !kvm_is_private_gpa(kvm, region.gpa) ||
> +           !kvm_is_private_gpa(kvm, region.gpa + (region.nr_pages << PAG=
E_SHIFT)))
> +               return -EINVAL;
> +
> +       vcpu =3D kvm_get_vcpu(kvm, 0);
> +       if (mutex_lock_killable(&vcpu->mutex))
> +               return -EINTR;
> +
> +       vcpu_load(vcpu);
> +       idx =3D srcu_read_lock(&kvm->srcu);
> +
> +       kvm_mmu_reload(vcpu);
> +
> +       while (region.nr_pages) {
> +               if (signal_pending(current)) {
> +                       ret =3D -ERESTARTSYS;
> +                       break;
> +               }
> +
> +               if (need_resched())
> +                       cond_resched();
> +
> +               /* Pin the source page. */
> +               ret =3D get_user_pages_fast(region.source_addr, 1, 0, &pa=
ge);
> +               if (ret < 0)
> +                       break;
> +               if (ret !=3D 1) {
> +                       ret =3D -ENOMEM;
> +                       break;
> +               }
> +
> +               kvm_tdx->source_pa =3D pfn_to_hpa(page_to_pfn(page)) |
> +                                    (cmd->flags & KVM_TDX_MEASURE_MEMORY=
_REGION);
> +
> +               ret =3D kvm_mmu_map_tdp_page(vcpu, region.gpa, TDX_SEPT_P=
FERR,
> +                                          PG_LEVEL_4K);
> +               put_page(page);
> +               if (ret)
> +                       break;
> +
> +               region.source_addr +=3D PAGE_SIZE;
> +               region.gpa +=3D PAGE_SIZE;
> +               region.nr_pages--;
> +               added =3D true;
> +       }
> +
> +       srcu_read_unlock(&kvm->srcu, idx);
> +       vcpu_put(vcpu);
> +
> +       mutex_unlock(&vcpu->mutex);
> +
> +       if (added && region.nr_pages > 0)
> +               ret =3D -EAGAIN;
> +       if (copy_to_user((void __user *)cmd->data, &region, sizeof(region=
)))
> +               ret =3D -EFAULT;
> +
> +       return ret;
> +}
> +
>  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>  {
>         struct kvm_tdx_cmd tdx_cmd;
> @@ -1234,6 +1379,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp=
)
>         case KVM_TDX_INIT_VM:
>                 r =3D tdx_td_init(kvm, &tdx_cmd);
>                 break;
> +       case KVM_TDX_INIT_MEM_REGION:
> +               r =3D tdx_init_mem_region(kvm, &tdx_cmd);
> +               break;
>         default:
>                 r =3D -EINVAL;
>                 goto out;
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 6603da8708ad..24ee0bc3285c 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -17,6 +17,8 @@ struct kvm_tdx {
>         u64 xfam;
>         int hkid;
>
> +       hpa_t source_pa;
> +
>         bool finalized;
>         atomic_t tdh_mem_track;
>
> diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/inclu=
de/uapi/asm/kvm.h
> index 83bd9e3118d1..a3408f6e1124 100644
> --- a/tools/arch/x86/include/uapi/asm/kvm.h
> +++ b/tools/arch/x86/include/uapi/asm/kvm.h
> @@ -567,6 +567,7 @@ enum kvm_tdx_cmd_id {
>         KVM_TDX_CAPABILITIES =3D 0,
>         KVM_TDX_INIT_VM,
>         KVM_TDX_INIT_VCPU,
> +       KVM_TDX_INIT_MEM_REGION,
>
>         KVM_TDX_CMD_NR_MAX,
>  };
> @@ -648,4 +649,12 @@ struct kvm_tdx_init_vm {
>         };
>  };
>
> +#define KVM_TDX_MEASURE_MEMORY_REGION  (1UL << 0)
> +
> +struct kvm_tdx_init_mem_region {
> +       __u64 source_addr;
> +       __u64 gpa;
> +       __u64 nr_pages;
> +};
> +
>  #endif /* _ASM_X86_KVM_H */
> --
> 2.25.1
>
