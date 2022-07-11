Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7280570505
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 16:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbiGKOF1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 10:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbiGKOFX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 10:05:23 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D056320F65
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 07:05:21 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id d12so8845809lfq.12
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 07:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/q0quOUBTZl2gZ3/jAMDJM6IbzyCJBTglBZNVpNLFAg=;
        b=OrD3qzvjeeLGTBMraqT2BYvr0yduEBgTKuhSk/E0kxg3vkZv4jX3EyewouXwf6dCCq
         uAZcyX19ccZNhJbindes8nJi5AREvwTXp/PkgH0V5RLCa4wS04W6iJBQbwc1qikmv6Ta
         Oz1p8LhqQQO+Py50NrAt8cB689pHX13B3jg5rFLqNz8UpUvIApkpkukZUoeooUYiH5KF
         hK9vTeGXNomKC2l94M8dS1+yOkcyMfFW19eS4TJwdJ0hHjY5FpX0PrTLl2RXLSq61YEl
         hPeThgGZKETyFHA8MHZH6KiEG6SLlx/sbWBFsthhH1WHZBM0ngdsToPFTuVlYj2mfk+g
         CepQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/q0quOUBTZl2gZ3/jAMDJM6IbzyCJBTglBZNVpNLFAg=;
        b=HOldJ9yycmmcLwG4QtMVUfNpJ3jb9qqz5RBSupiBJ3DfEa9kEH4PcEmOUAskwSc0vW
         dAfu5ARMibYESSoRVH2ciO4mFIjBC9zplgyUlWukJwOdHwFvJRHKn7RoL5Fey1jf4Ahy
         9XfXyy5hmj/kJVzB2i52G5nTtCsA/EVcBLmd6Cd4J5M1qxk6JGhL+mdRnc+rknAOsQr1
         bImAmIAgCwCY51h2mnne4vKJWGbHZXCiemUHynpawlG0Z9ptV7jSjg/E6BvynPRJSAFY
         CtSzGPlknFn9UMCTdNijKo5DlN6Z1rCUv2cM19MnIp6Xe0EAHyBPu/YUU4pGCMnBba+e
         H5IA==
X-Gm-Message-State: AJIora9q6z4+DCbDTv2KLSTaF8+LifK3phuoL9WpiSt/w3tF3P31l6ir
        /vmFwRfNSdTEUmgfCh8iK2iPCtsJvtQGuXKSFOC35Q==
X-Google-Smtp-Source: AGRyM1vr9Y62NuaJJYfkorIddGjcA9PSwfY28vd8Oaa2IQe6aGGNvRjDvJ+WHbbexoWMRT+ZRh4z37GhWYBnUZQ0IZo=
X-Received: by 2002:a05:6512:32c5:b0:481:1822:c41f with SMTP id
 f5-20020a05651232c500b004811822c41fmr12289097lfg.373.1657548319052; Mon, 11
 Jul 2022 07:05:19 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <6a513cf79bf71c479dbd72165faf1d804d77b3af.1655761627.git.ashish.kalra@amd.com>
In-Reply-To: <6a513cf79bf71c479dbd72165faf1d804d77b3af.1655761627.git.ashish.kalra@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Mon, 11 Jul 2022 08:05:07 -0600
Message-ID: <CAMkAt6obGwyiJh7J34Vt8tC+XXMNm8YPrv4gV=TVoF2Xga5GjQ@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 28/49] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_FINISH command
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        Linux Memory Management List <linux-mm@kvack.org>,
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 5:08 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> The KVM_SEV_SNP_LAUNCH_FINISH finalize the cryptographic digest and stores
> it as the measurement of the guest at launch.
>
> While finalizing the launch flow, it also issues the LAUNCH_UPDATE command
> to encrypt the VMSA pages.
>
> If its an SNP guest, then VMSA was added in the RMP entry as
> a guest owned page and also removed from the kernel direct map
> so flush it later after it is transitioned back to hypervisor
> state and restored in the direct map.

Given the guest uses the SNP NAE AP boot protocol we were expecting
that there would be some option to add vCPUs to the VM but mark them
as "pending AP boot creation protocol" state. This would allow the
LaunchDigest of a VM doesn't change just because its vCPU count
changes. Would it be possible to add a new add an argument to
KVM_SNP_LAUNCH_FINISH to tell it which vCPUs to LAUNCH_UPDATE VMSA
pages for or similarly a new argument for KVM_CREATE_VCPU?

>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  .../virt/kvm/x86/amd-memory-encryption.rst    |  22 ++++
>  arch/x86/kvm/svm/sev.c                        | 119 ++++++++++++++++++
>  include/uapi/linux/kvm.h                      |  14 +++
>  3 files changed, 155 insertions(+)
>
> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> index 62abd5c1f72b..750162cff87b 100644
> --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> @@ -514,6 +514,28 @@ Returns: 0 on success, -negative on error
>  See the SEV-SNP spec for further details on how to build the VMPL permission
>  mask and page type.
>
> +21. KVM_SNP_LAUNCH_FINISH
> +-------------------------
> +
> +After completion of the SNP guest launch flow, the KVM_SNP_LAUNCH_FINISH command can be
> +issued to make the guest ready for the execution.
> +
> +Parameters (in): struct kvm_sev_snp_launch_finish
> +
> +Returns: 0 on success, -negative on error
> +
> +::
> +
> +        struct kvm_sev_snp_launch_finish {
> +                __u64 id_block_uaddr;
> +                __u64 id_auth_uaddr;
> +                __u8 id_block_en;
> +                __u8 auth_key_en;
> +                __u8 host_data[32];
> +        };
> +
> +
> +See SEV-SNP specification for further details on launch finish input parameters.
>
>  References
>  ==========
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index a9461d352eda..a5b90469683f 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2095,6 +2095,106 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
>         return ret;
>  }
>
> +static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +       struct sev_data_snp_launch_update data = {};
> +       int i, ret;
> +
> +       data.gctx_paddr = __psp_pa(sev->snp_context);
> +       data.page_type = SNP_PAGE_TYPE_VMSA;
> +
> +       for (i = 0; i < kvm->created_vcpus; i++) {
> +               struct vcpu_svm *svm = to_svm(xa_load(&kvm->vcpu_array, i));

Why are we iterating over |created_vcpus| rather than using kvm_for_each_vcpu?

> +               u64 pfn = __pa(svm->sev_es.vmsa) >> PAGE_SHIFT;
> +
> +               /* Perform some pre-encryption checks against the VMSA */
> +               ret = sev_es_sync_vmsa(svm);
> +               if (ret)
> +                       return ret;

Do we need to take the 'vcpu->mutex' lock before modifying the
vcpu,like we do for SEV-ES in sev_launch_update_vmsa()?

> +
> +               /* Transition the VMSA page to a firmware state. */
> +               ret = rmp_make_private(pfn, -1, PG_LEVEL_4K, sev->asid, true);
> +               if (ret)
> +                       return ret;
> +
> +               /* Issue the SNP command to encrypt the VMSA */
> +               data.address = __sme_pa(svm->sev_es.vmsa);
> +               ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
> +                                     &data, &argp->error);
> +               if (ret) {
> +                       snp_page_reclaim(pfn);
> +                       return ret;
> +               }
> +
> +               svm->vcpu.arch.guest_state_protected = true;
> +       }
> +
> +       return 0;
> +}
> +
> +static int snp_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +       struct sev_data_snp_launch_finish *data;
> +       void *id_block = NULL, *id_auth = NULL;
> +       struct kvm_sev_snp_launch_finish params;
> +       int ret;
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
> +       /* Measure all vCPUs using LAUNCH_UPDATE before we finalize the launch flow. */
> +       ret = snp_launch_update_vmsa(kvm, argp);
> +       if (ret)
> +               return ret;
> +
> +       data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
> +       if (!data)
> +               return -ENOMEM;
> +
> +       if (params.id_block_en) {
> +               id_block = psp_copy_user_blob(params.id_block_uaddr, KVM_SEV_SNP_ID_BLOCK_SIZE);
> +               if (IS_ERR(id_block)) {
> +                       ret = PTR_ERR(id_block);
> +                       goto e_free;
> +               }
> +
> +               data->id_block_en = 1;
> +               data->id_block_paddr = __sme_pa(id_block);
> +       }
> +
> +       if (params.auth_key_en) {
> +               id_auth = psp_copy_user_blob(params.id_auth_uaddr, KVM_SEV_SNP_ID_AUTH_SIZE);
> +               if (IS_ERR(id_auth)) {
> +                       ret = PTR_ERR(id_auth);
> +                       goto e_free_id_block;
> +               }
> +
> +               data->auth_key_en = 1;
> +               data->id_auth_paddr = __sme_pa(id_auth);
> +       }
> +
> +       data->gctx_paddr = __psp_pa(sev->snp_context);
> +       ret = sev_issue_cmd(kvm, SEV_CMD_SNP_LAUNCH_FINISH, data, &argp->error);
> +
> +       kfree(id_auth);
> +
> +e_free_id_block:
> +       kfree(id_block);
> +
> +e_free:
> +       kfree(data);
> +
> +       return ret;
> +}
> +
>  int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  {
>         struct kvm_sev_cmd sev_cmd;
> @@ -2191,6 +2291,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>         case KVM_SEV_SNP_LAUNCH_UPDATE:
>                 r = snp_launch_update(kvm, &sev_cmd);
>                 break;
> +       case KVM_SEV_SNP_LAUNCH_FINISH:
> +               r = snp_launch_finish(kvm, &sev_cmd);
> +               break;
>         default:
>                 r = -EINVAL;
>                 goto out;
> @@ -2696,11 +2799,27 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
>
>         svm = to_svm(vcpu);
>
> +       /*
> +        * If its an SNP guest, then VMSA was added in the RMP entry as
> +        * a guest owned page. Transition the page to hypervisor state
> +        * before releasing it back to the system.
> +        * Also the page is removed from the kernel direct map, so flush it
> +        * later after it is transitioned back to hypervisor state and
> +        * restored in the direct map.
> +        */
> +       if (sev_snp_guest(vcpu->kvm)) {
> +               u64 pfn = __pa(svm->sev_es.vmsa) >> PAGE_SHIFT;
> +
> +               if (host_rmp_make_shared(pfn, PG_LEVEL_4K, false))
> +                       goto skip_vmsa_free;

Why not call host_rmp_make_shared with leak==true? This old VMSA page
is now unusable IIUC.



> +       }
> +
>         if (vcpu->arch.guest_state_protected)
>                 sev_flush_encrypted_page(vcpu, svm->sev_es.vmsa);
>
>         __free_page(virt_to_page(svm->sev_es.vmsa));
>
> +skip_vmsa_free:
>         if (svm->sev_es.ghcb_sa_free)
>                 kvfree(svm->sev_es.ghcb_sa);
>  }
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 9b36b07414ea..5a4662716b6a 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1814,6 +1814,7 @@ enum sev_cmd_id {
>         KVM_SEV_SNP_INIT,
>         KVM_SEV_SNP_LAUNCH_START,
>         KVM_SEV_SNP_LAUNCH_UPDATE,
> +       KVM_SEV_SNP_LAUNCH_FINISH,
>
>         KVM_SEV_NR_MAX,
>  };
> @@ -1948,6 +1949,19 @@ struct kvm_sev_snp_launch_update {
>         __u8 vmpl1_perms;
>  };
>
> +#define KVM_SEV_SNP_ID_BLOCK_SIZE      96
> +#define KVM_SEV_SNP_ID_AUTH_SIZE       4096
> +#define KVM_SEV_SNP_FINISH_DATA_SIZE   32
> +
> +struct kvm_sev_snp_launch_finish {
> +       __u64 id_block_uaddr;
> +       __u64 id_auth_uaddr;
> +       __u8 id_block_en;
> +       __u8 auth_key_en;
> +       __u8 host_data[KVM_SEV_SNP_FINISH_DATA_SIZE];
> +       __u8 pad[6];
> +};
> +
>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU    (1 << 0)
>  #define KVM_DEV_ASSIGN_PCI_2_3         (1 << 1)
>  #define KVM_DEV_ASSIGN_MASK_INTX       (1 << 2)
> --
> 2.25.1
>
