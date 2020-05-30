Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4628F1E8D12
	for <lists+kvm@lfdr.de>; Sat, 30 May 2020 04:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728707AbgE3CI0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 22:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728406AbgE3CIZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 22:08:25 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D7CCC08C5C9
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 19:08:25 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id r2so4368355ila.4
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 19:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WPmaAyijbZRcdnCDAzIdmftbmv7QF44NJaDAxY23DL4=;
        b=dffCavqiDYn5M+lBLNQ6T7a04SmV9z755BGFbZDfyEqsCLZiM8bgDBn14b0m5Ou2O0
         y7JrTwcvbluc1IzBgtQQV3atlx15fFkXvP+Oc0Tr4OSw3DnTrhm3pJTj04xR3QHZLkSo
         xa2JpPsQwA4XI9sTiG4q6fYH1ibXgmg39fnYGLVDiIJ07zDGMRHaw0T/hdMp3AWTkinr
         QLGWFWH4Ec9OgUHnnDUWgDeDrV83aiF/8G3YUgZRIPE1EYOb6+XToEp8vOpaWdOL7l0n
         63Us23g017swm+mRV+ojJWZz/EyyRvSmWNRDeqjjv4eT9BcQMUTwbbadvYK5PHyQCP6p
         bZzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WPmaAyijbZRcdnCDAzIdmftbmv7QF44NJaDAxY23DL4=;
        b=l70vwkZh+8YGKqULcnSyIfC4oRC59+m2ZI+aZnugF2HD8/RqHV88DGC2m0tcmbmBl0
         stz3BUICe1+Lzo23D0Q2pkwwd9harC1ndW9CreN+cYGcSsLanP7ww2ZRwwHDgksuSiSu
         2ZG2+6rkf/3tNKld6D3BAfpGh8Rn1SbbEC80u/Yf4imdLwULukXwwULoz0rS7YCJf+I1
         F23G4cy854k7TrFZG9hmZzlY8nhiG7x0aMrF+QUNRFt88VA6mrr0D9JObscy6oRgarxq
         7m1OGmOPkHpgdyJW+YkdOXFWf9bPAdM/vlCXlhb5CBQLALCtV9Svuxy8qzjEpmTSb8WC
         yuJA==
X-Gm-Message-State: AOAM531pH9CPYZWRQ2Qep5XCzCG4LoTRmCb13498G7g5embto+zCXwqy
        H1tTs1m4JhD1aBeMeyG/pZbBLJH+mO8kGbWf+FLMtg==
X-Google-Smtp-Source: ABdhPJzQLPvKvFtxSJpo0NMt91IPWVc2aHICrA/25fG0J4C9CLGA1vx885sW3B2jt+uaANVqHdN2+IKq8BzFs4gs+Ok=
X-Received: by 2002:a92:a113:: with SMTP id v19mr10062469ili.110.1590804504597;
 Fri, 29 May 2020 19:08:24 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1588711355.git.ashish.kalra@amd.com> <4ff020b446baa06037136ceeb1e66d4eba8ad492.1588711355.git.ashish.kalra@amd.com>
In-Reply-To: <4ff020b446baa06037136ceeb1e66d4eba8ad492.1588711355.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Fri, 29 May 2020 19:07:48 -0700
Message-ID: <CABayD+dJF2YX7hB+=Vtt9qHXs__axH14Mnbs=5u_hDhnRUdXVA@mail.gmail.com>
Subject: Re: [PATCH v8 13/18] KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION
 feature & Custom MSR.
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 5, 2020 at 2:19 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> Add new KVM_FEATURE_SEV_LIVE_MIGRATION feature for guest to check
> for host-side support for SEV live migration. Also add a new custom
> MSR_KVM_SEV_LIVE_MIG_EN for guest to enable the SEV live migration
> feature.
>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  Documentation/virt/kvm/cpuid.rst     |  5 +++++
>  Documentation/virt/kvm/msr.rst       | 10 ++++++++++
>  arch/x86/include/uapi/asm/kvm_para.h |  5 +++++
>  arch/x86/kvm/svm/sev.c               | 14 ++++++++++++++
>  arch/x86/kvm/svm/svm.c               | 16 ++++++++++++++++
>  arch/x86/kvm/svm/svm.h               |  2 ++
>  6 files changed, 52 insertions(+)
>
> diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
> index 01b081f6e7ea..0514523e00cd 100644
> --- a/Documentation/virt/kvm/cpuid.rst
> +++ b/Documentation/virt/kvm/cpuid.rst
> @@ -86,6 +86,11 @@ KVM_FEATURE_PV_SCHED_YIELD        13          guest checks this feature bit
>                                                before using paravirtualized
>                                                sched yield.
>
> +KVM_FEATURE_SEV_LIVE_MIGRATION    14          guest checks this feature bit before
> +                                              using the page encryption state
> +                                              hypercall to notify the page state
> +                                              change
> +
>  KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          host will warn if no guest-side
>                                                per-cpu warps are expeced in
>                                                kvmclock
> diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
> index 33892036672d..7cd7786bbb03 100644
> --- a/Documentation/virt/kvm/msr.rst
> +++ b/Documentation/virt/kvm/msr.rst
> @@ -319,3 +319,13 @@ data:
>
>         KVM guests can request the host not to poll on HLT, for example if
>         they are performing polling themselves.
> +
> +MSR_KVM_SEV_LIVE_MIG_EN:
> +        0x4b564d06
> +
> +       Control SEV Live Migration features.
> +
> +data:
> +        Bit 0 enables (1) or disables (0) host-side SEV Live Migration feature.
> +        Bit 1 enables (1) or disables (0) support for SEV Live Migration extensions.
> +        All other bits are reserved.
> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index 2a8e0b6b9805..d9d4953b42ad 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -31,6 +31,7 @@
>  #define KVM_FEATURE_PV_SEND_IPI        11
>  #define KVM_FEATURE_POLL_CONTROL       12
>  #define KVM_FEATURE_PV_SCHED_YIELD     13
> +#define KVM_FEATURE_SEV_LIVE_MIGRATION 14
>
>  #define KVM_HINTS_REALTIME      0
>
> @@ -50,6 +51,7 @@
>  #define MSR_KVM_STEAL_TIME  0x4b564d03
>  #define MSR_KVM_PV_EOI_EN      0x4b564d04
>  #define MSR_KVM_POLL_CONTROL   0x4b564d05
> +#define MSR_KVM_SEV_LIVE_MIG_EN        0x4b564d06
>
>  struct kvm_steal_time {
>         __u64 steal;
> @@ -122,4 +124,7 @@ struct kvm_vcpu_pv_apf_data {
>  #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
>  #define KVM_PV_EOI_DISABLED 0x0
>
> +#define KVM_SEV_LIVE_MIGRATION_ENABLED                 (1 << 0)
> +#define KVM_SEV_LIVE_MIGRATION_EXTENSIONS_SUPPORTED    (1 << 1)
> +
>  #endif /* _UAPI_ASM_X86_KVM_PARA_H */
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c0d7043a0627..6f69c3a47583 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1469,6 +1469,17 @@ int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
>         return 0;
>  }
>
> +void sev_update_migration_flags(struct kvm *kvm, u64 data)
> +{
> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +
> +       if (!sev_guest(kvm))
> +               return;
> +
> +       if (data & KVM_SEV_LIVE_MIGRATION_ENABLED)
> +               sev->live_migration_enabled = true;
> +}
> +
>  int svm_get_page_enc_bitmap(struct kvm *kvm,
>                                    struct kvm_page_enc_bitmap *bmap)
>  {
> @@ -1481,6 +1492,9 @@ int svm_get_page_enc_bitmap(struct kvm *kvm,
>         if (!sev_guest(kvm))
>                 return -ENOTTY;
>
> +       if (!sev->live_migration_enabled)
> +               return -EINVAL;
> +
>         gfn_start = bmap->start_gfn;
>         gfn_end = gfn_start + bmap->num_pages;
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 442adbbb0641..a99f5457f244 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2633,6 +2633,9 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>                 svm->msr_decfg = data;
>                 break;
>         }
> +       case MSR_KVM_SEV_LIVE_MIG_EN:
> +               sev_update_migration_flags(vcpu->kvm, data);
> +               break;
>         case MSR_IA32_APICBASE:
>                 if (kvm_vcpu_apicv_active(vcpu))
>                         avic_update_vapic_bar(to_svm(vcpu), data);
> @@ -3493,6 +3496,19 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
>         svm->nrips_enabled = kvm_cpu_cap_has(X86_FEATURE_NRIPS) &&
>                              guest_cpuid_has(&svm->vcpu, X86_FEATURE_NRIPS);
>
> +        /*
> +         * If SEV guest then enable the Live migration feature.
> +         */
> +        if (sev_guest(vcpu->kvm)) {
> +              struct kvm_cpuid_entry2 *best;
> +
> +              best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
> +              if (!best)
> +                      return;
> +
> +              best->eax |= (1 << KVM_FEATURE_SEV_LIVE_MIGRATION);
> +        }
> +
>         if (!kvm_vcpu_apicv_active(vcpu))
>                 return;
>
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index fd99e0a5417a..77f132a6fead 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -65,6 +65,7 @@ struct kvm_sev_info {
>         int fd;                 /* SEV device fd */
>         unsigned long pages_locked; /* Number of pages locked */
>         struct list_head regions_list;  /* List of registered regions */
> +       bool live_migration_enabled;
>         unsigned long *page_enc_bmap;
>         unsigned long page_enc_bmap_size;
>  };
> @@ -494,5 +495,6 @@ int svm_unregister_enc_region(struct kvm *kvm,
>  void pre_sev_run(struct vcpu_svm *svm, int cpu);
>  int __init sev_hardware_setup(void);
>  void sev_hardware_teardown(void);
> +void sev_update_migration_flags(struct kvm *kvm, u64 data);
>
>  #endif
> --
> 2.17.1
>

Reviewed-by: Steve Rutherford <srutherford@google.com>
