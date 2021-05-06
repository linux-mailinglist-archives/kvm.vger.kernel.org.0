Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085D9375C29
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 22:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbhEFU1F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 16:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhEFU1D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 16:27:03 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A58C061761
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 13:26:04 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id h4so9693914lfv.0
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 13:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1ZJJpWnA5QBmwVYH3cUwpevDYWEenuEP/75drNSjJCY=;
        b=S0+QLDISnbSh1ONFqwJCL8w4tNmRaDfvMYrwRyDl6rYGCwzjNgv7bw4fuskxy8KcJr
         6T25FNlnG3YLNrvUnnejT3wA+6r/ndayJgncOTb1W9pl3866LWC8EGinLtF1i1UdHZQJ
         +sfry1urEFO3iXViQogTaezEWwYDmJegWlkdW7Nxa1rh4dD5sbubhycdchTVT+LabKMR
         cU5PIdvMI7rXQvlvV/8ESxutbN8mk1ScYNPnxXYjG9PtrEPjUdm8DNapt/XYvFKatnpU
         L+0FI6FXZELFvotrgCkGwN5Yz+UWbTZ3NOCWcNh5k5q8FNDrxzWGrOj8w2hyhgSUIH65
         yedA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1ZJJpWnA5QBmwVYH3cUwpevDYWEenuEP/75drNSjJCY=;
        b=qWtqZM1sfvjCNnXcwr6C4b9tVVKVvVy07cjHK0abJMw5pMTxRAXxkeO44Oc7geVkFI
         eFRLi0KxvC6wuhcHf2dIvW9yvQdNwvzRI8XnX0UJQXfAfimTilj4vXelzHPpdEdPK0su
         oL9i5r5uqoXMxGMUUcW1jEUucpq8UepYxGC+VbhwPJx8Dnb8RXFDqgHVqSwtrpuLSBZ1
         Sepx2Fpc4H6BjTOPx/VPNvmj050rupn6NmXR5kU8GOVuSlqNNLmji8SX56ob510tPTta
         qtg9lfmlBDZncxTZ+geepG5CRnZtEvHe51kdKpHX/c6KOGnlaqMmAjCtHdeNMVYWnxBi
         RCdw==
X-Gm-Message-State: AOAM533egxeCKVBmzGO5rLRf/teKLZGHhJiXFv8W33fzMExYEjcjqqEa
        zFq3Ywf969yRAO+F60Nq7HlW2248QBM12gDwujGrDw==
X-Google-Smtp-Source: ABdhPJyUZumnhAS1Pbr7OXmFMAO1l3HlGin0F9L+J7NfQ0DdxjTjvc41B/s7EhTyO0zhVhv3KJlmA1JPIwyRuDT1ywg=
X-Received: by 2002:a05:6512:130c:: with SMTP id x12mr4163234lfu.423.1620332762896;
 Thu, 06 May 2021 13:26:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210430123822.13825-1-brijesh.singh@amd.com> <20210430123822.13825-22-brijesh.singh@amd.com>
In-Reply-To: <20210430123822.13825-22-brijesh.singh@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Thu, 6 May 2021 14:25:50 -0600
Message-ID: <CAMkAt6pF-AS7NJsAMhnezuvo9tcTQhhq_e-eKDatjzbKBAHp0Q@mail.gmail.com>
Subject: Re: [PATCH Part2 RFC v2 21/37] KVM: SVM: Add KVM_SNP_INIT command
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        kvm list <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, jroedel@suse.de,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>, peterz@infradead.org,
        "H. Peter Anvin" <hpa@zytor.com>, tony.luck@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 30, 2021 at 6:44 AM Brijesh Singh <brijesh.singh@amd.com> wrote:
>
> The KVM_SNP_INIT command is used by the hypervisor to initialize the
> SEV-SNP platform context. In a typical workflow, this command should be the
> first command issued. When creating SEV-SNP guest, the VMM must use this
> command instead of the KVM_SEV_INIT or KVM_SEV_ES_INIT.
>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c   | 18 ++++++++++++++++--
>  include/uapi/linux/kvm.h |  3 +++
>  2 files changed, 19 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 200d227f9232..ea74dd9e03d3 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -230,8 +230,9 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
>
>  static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
> +       bool es_active = (argp->id == KVM_SEV_ES_INIT || argp->id == KVM_SEV_SNP_INIT);
>         struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> -       bool es_active = argp->id == KVM_SEV_ES_INIT;
> +       bool snp_active = argp->id == KVM_SEV_SNP_INIT;
>         int asid, ret;
>
>         if (kvm->created_vcpus)
> @@ -242,12 +243,16 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
> +       if (snp_active)
> +               ret = sev_snp_init(&argp->error);
> +       else
> +               ret = sev_platform_init(&argp->error);
>         if (ret)
>                 goto e_free;
>
> @@ -583,6 +588,9 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>         save->pkru = svm->vcpu.arch.pkru;
>         save->xss  = svm->vcpu.arch.ia32_xss;
>
> +       if (sev_snp_guest(svm->vcpu.kvm))
> +               save->sev_features |= SVM_SEV_FEATURES_SNP_ACTIVE;
> +
>         /*
>          * SEV-ES will use a VMSA that is pointed to by the VMCB, not
>          * the traditional VMSA that is part of the VMCB. Copy the
> @@ -1525,6 +1533,12 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
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
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 3fd9a7e9d90c..aaa2d62f09b5 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1678,6 +1678,9 @@ enum sev_cmd_id {
>         /* Guest Migration Extension */
>         KVM_SEV_SEND_CANCEL,
>
> +       /* SNP specific commands */
> +       KVM_SEV_SNP_INIT,
> +

Do you want to reserve some more enum values for SEV in case
additional functionality is added, or is this very unlikely?

>         KVM_SEV_NR_MAX,
>  };
>
> --
> 2.17.1
>
