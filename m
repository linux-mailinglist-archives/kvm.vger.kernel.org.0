Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0917954A126
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 23:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352257AbiFMVRJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 17:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235257AbiFMVQ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 17:16:57 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF69F6F
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 13:59:01 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id h18so5180232ilj.7
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 13:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ga8fmQuD3EjQJc6y9LFAh1+REX1O+10pZrDfXI21feA=;
        b=o89LuZIGrtaJTyuZxG/tFnoJZC06jfTzoIWRxdGPpGTWCcJd74F804tAWQexje8E3S
         NKPBUP7yMeJS2wZDVN7+e9vUrsPTTTDTl1Vr6qFT668LVtWD1vpWSabbyMfX0R7kk724
         I0MrTsUsfRHEueeWuMHYJ3cXJ+dMvcXowkvDzaBemxuQQAOWK9R841p47SAJqoXkKQzP
         jSHb2YATHBYiGFSUwkZ4eoiHC7YlXlnfE2nbvZ5Iytq4i8vJE/RkCwYjiloIqqf9Vc8Q
         fnpO1lj8pByTahSevtouYCYgA68hA3oA82BnsmDzg/4sqbqbSsPeUqy8329WGF860AGD
         mGDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ga8fmQuD3EjQJc6y9LFAh1+REX1O+10pZrDfXI21feA=;
        b=rg1CDiCz1usCkLSAyfwDTMIrChCnmzcP//uvGkm2JuAVD1QDo05a16phUP8tLVtgNX
         30FFXt+XsaPQ7HBzlYl9BVp2xNF35l0dJW8JVJQWLVRtHHiRDAlZCKFWX+QB9/pnU/WB
         EfXMrILemLFV65w84nlItRfImCUh33Y56YC6ZiutPYzXgohm+7GvOiAYDstmsi8lP2Cc
         YmPjL9Ln3n/EYxFyZwPy9xuICmGTAQI8j/bSU7kdzDYSWqZpmNdontho+0cvy14ouHsI
         +3jRLHfNFBJ9RNcR5vxlAnD0LbseJKI3bY0AKaiV4+KmOie8O2iYV5fJqxJr5VvhHxQ7
         lGBA==
X-Gm-Message-State: AJIora++lULjntV2QdWL8Cl7Y2yNKZ8Sdj8PjpPKklMC+bDxR1H6p8RI
        UJpGFAV0AbUPOEIpt9Vs06pMA0chfLO4L/hc5LZ+xQ==
X-Google-Smtp-Source: AGRyM1vHj2xpae4EYuioWncsG3+wihbYPjRsIe9kP4YDnqu0eM1AJTOMo7FS7jaD0u82ksjNPyavbXP9+w47JSvyr1I=
X-Received: by 2002:a05:6e02:792:b0:2d7:ae5d:e2fd with SMTP id
 q18-20020a056e02079200b002d7ae5de2fdmr1015080ils.315.1655153941065; Mon, 13
 Jun 2022 13:59:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210820155918.7518-1-brijesh.singh@amd.com> <20210820155918.7518-24-brijesh.singh@amd.com>
In-Reply-To: <20210820155918.7518-24-brijesh.singh@amd.com>
From:   Alper Gun <alpergun@google.com>
Date:   Mon, 13 Jun 2022 13:58:50 -0700
Message-ID: <CABpDEukdrEbXjOF_QuZqUMQndYx=zVM4s2o-oN_wb2L_HCrONg@mail.gmail.com>
Subject: Re: [PATCH Part2 v5 23/45] KVM: SVM: Add KVM_SNP_INIT command
To:     Brijesh Singh <brijesh.singh@amd.com>, Ashish.Kalra@amd.com
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
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
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
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
        sathyanarayanan.kuppuswamy@linux.intel.com,
        Pavan Kumar Paluri <papaluri@amd.com>
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

On Fri, Aug 20, 2021 at 9:00 AM Brijesh Singh <brijesh.singh@amd.com> wrote:
>
> The KVM_SNP_INIT command is used by the hypervisor to initialize the
> SEV-SNP platform context. In a typical workflow, this command should be the
> first command issued. When creating SEV-SNP guest, the VMM must use this
> command instead of the KVM_SEV_INIT or KVM_SEV_ES_INIT.
>
> The flags value must be zero, it will be extended in future SNP support to
> communicate the optional features (such as restricted INT injection etc).
>
> Co-developed-by: Pavan Kumar Paluri <papaluri@amd.com>
> Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  .../virt/kvm/amd-memory-encryption.rst        | 27 ++++++++++++
>  arch/x86/include/asm/svm.h                    |  2 +
>  arch/x86/kvm/svm/sev.c                        | 44 ++++++++++++++++++-
>  arch/x86/kvm/svm/svm.h                        |  4 ++
>  include/uapi/linux/kvm.h                      | 13 ++++++
>  5 files changed, 88 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> index 5c081c8c7164..7b1d32fb99a8 100644
> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> @@ -427,6 +427,33 @@ issued by the hypervisor to make the guest ready for execution.
>
>  Returns: 0 on success, -negative on error
>
> +18. KVM_SNP_INIT
> +----------------
> +
> +The KVM_SNP_INIT command can be used by the hypervisor to initialize SEV-SNP
> +context. In a typical workflow, this command should be the first command issued.
> +
> +Parameters (in/out): struct kvm_snp_init
> +
> +Returns: 0 on success, -negative on error
> +
> +::
> +
> +        struct kvm_snp_init {
> +                __u64 flags;
> +        };
> +
> +The flags bitmap is defined as::
> +
> +   /* enable the restricted injection */
> +   #define KVM_SEV_SNP_RESTRICTED_INJET   (1<<0)
> +
> +   /* enable the restricted injection timer */
> +   #define KVM_SEV_SNP_RESTRICTED_TIMER_INJET   (1<<1)
> +
> +If the specified flags is not supported then return -EOPNOTSUPP, and the supported
> +flags are returned.
> +
>  References
>  ==========
>
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 44a3f920f886..a39e31845a33 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -218,6 +218,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>  #define SVM_NESTED_CTL_SEV_ENABLE      BIT(1)
>  #define SVM_NESTED_CTL_SEV_ES_ENABLE   BIT(2)
>
> +#define SVM_SEV_FEAT_SNP_ACTIVE                BIT(0)
> +
>  struct vmcb_seg {
>         u16 selector;
>         u16 attrib;
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 50fddbe56981..93da463545ef 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -235,10 +235,30 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
>         sev_decommission(handle);
>  }
>
> +static int verify_snp_init_flags(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +       struct kvm_snp_init params;
> +       int ret = 0;
> +
> +       if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
> +               return -EFAULT;
> +
> +       if (params.flags & ~SEV_SNP_SUPPORTED_FLAGS)
> +               ret = -EOPNOTSUPP;
> +
> +       params.flags = SEV_SNP_SUPPORTED_FLAGS;
> +
> +       if (copy_to_user((void __user *)(uintptr_t)argp->data, &params, sizeof(params)))
> +               ret = -EFAULT;
> +
> +       return ret;
> +}
> +
>  static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
> +       bool es_active = (argp->id == KVM_SEV_ES_INIT || argp->id == KVM_SEV_SNP_INIT);
>         struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> -       bool es_active = argp->id == KVM_SEV_ES_INIT;
> +       bool snp_active = argp->id == KVM_SEV_SNP_INIT;
>         int asid, ret;
>
>         if (kvm->created_vcpus)
> @@ -249,12 +269,22 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>                 return ret;
>
>         sev->es_active = es_active;
> +       sev->snp_active = snp_active;
>         asid = sev_asid_new(sev);
>         if (asid < 0)
>                 goto e_no_asid;
>         sev->asid = asid;
>
> -       ret = sev_platform_init(&argp->error);
> +       if (snp_active) {
> +               ret = verify_snp_init_flags(kvm, argp);
> +               if (ret)
> +                       goto e_free;
> +
> +               ret = sev_snp_init(&argp->error);
> +       } else {
> +               ret = sev_platform_init(&argp->error);

After SEV INIT_EX support patches, SEV may be initialized in the platform late.
In my tests, if SEV has not been initialized in the platform yet, SNP
VMs fail with SEV_DF_FLUSH required error. I tried calling
SEV_DF_FLUSH right after the SNP platform init but this time it failed
later on the SNP launch update command with SEV_RET_INVALID_PARAM
error. Looks like there is another dependency on SEV platform
initialization.

Calling sev_platform_init for SNP VMs fixes the problem in our tests.

> +       }
> +
>         if (ret)
>                 goto e_free;
>
> @@ -600,6 +630,10 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>         save->pkru = svm->vcpu.arch.pkru;
>         save->xss  = svm->vcpu.arch.ia32_xss;
>
> +       /* Enable the SEV-SNP feature */
> +       if (sev_snp_guest(svm->vcpu.kvm))
> +               save->sev_features |= SVM_SEV_FEAT_SNP_ACTIVE;
> +
>         return 0;
>  }
>
> @@ -1532,6 +1566,12 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>         }
>
>         switch (sev_cmd.id) {
> +       case KVM_SEV_SNP_INIT:
> +               if (!sev_snp_enabled) {
> +                       r = -ENOTTY;
> +                       goto out;
> +               }
> +               fallthrough;
>         case KVM_SEV_ES_INIT:
>                 if (!sev_es_enabled) {
>                         r = -ENOTTY;
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 01953522097d..57c3c404b0b3 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -69,6 +69,9 @@ enum {
>  /* TPR and CR2 are always written before VMRUN */
>  #define VMCB_ALWAYS_DIRTY_MASK ((1U << VMCB_INTR) | (1U << VMCB_CR2))
>
> +/* Supported init feature flags */
> +#define SEV_SNP_SUPPORTED_FLAGS                0x0
> +
>  struct kvm_sev_info {
>         bool active;            /* SEV enabled guest */
>         bool es_active;         /* SEV-ES enabled guest */
> @@ -81,6 +84,7 @@ struct kvm_sev_info {
>         u64 ap_jump_table;      /* SEV-ES AP Jump Table address */
>         struct kvm *enc_context_owner; /* Owner of copied encryption context */
>         struct misc_cg *misc_cg; /* For misc cgroup accounting */
> +       u64 snp_init_flags;
>  };
>
>  struct kvm_svm {
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index d9e4aabcb31a..944e2bf601fe 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1712,6 +1712,9 @@ enum sev_cmd_id {
>         /* Guest Migration Extension */
>         KVM_SEV_SEND_CANCEL,
>
> +       /* SNP specific commands */
> +       KVM_SEV_SNP_INIT,
> +
>         KVM_SEV_NR_MAX,
>  };
>
> @@ -1808,6 +1811,16 @@ struct kvm_sev_receive_update_data {
>         __u32 trans_len;
>  };
>
> +/* enable the restricted injection */
> +#define KVM_SEV_SNP_RESTRICTED_INJET   (1 << 0)
> +
> +/* enable the restricted injection timer */
> +#define KVM_SEV_SNP_RESTRICTED_TIMER_INJET   (1 << 1)
> +
> +struct kvm_snp_init {
> +       __u64 flags;
> +};
> +
>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU    (1 << 0)
>  #define KVM_DEV_ASSIGN_PCI_2_3         (1 << 1)
>  #define KVM_DEV_ASSIGN_MASK_INTX       (1 << 2)
> --
> 2.17.1
>
>
