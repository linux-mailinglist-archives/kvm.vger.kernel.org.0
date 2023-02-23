Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23A776A0EE0
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 18:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbjBWRqH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 12:46:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjBWRqF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 12:46:05 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B58D4FCAD;
        Thu, 23 Feb 2023 09:46:04 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id m7so14647604lfj.8;
        Thu, 23 Feb 2023 09:46:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677174362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gYIq09mCIdt8L8URFfe+pag31rri9xn6YRZUfSTQ4cQ=;
        b=H/MKnTDnvFdWxcQfGw3ysDrqU8kxVqbL6vEJjW7HtOr4msWrzCGUY1PDxLUYdKo3PM
         YLiEhEfthAIfkhDAArA4Ip+CysYZj3Ioym0g5zEOeTAbR+I2gMGXTUzHHV7bH2DWWNjl
         xaSi8T4miZA00aVNpols7SD8/uKpin4Fz6UzJK/FMK4U5osorpRZc+UEgpJUbyK12qiE
         UJdqkl2EYvKLRNn5+Vj0qVUk+ldaRk4W3GITriXGJDuD2OUgJwdNZS1jTj4dNe5gK7Vs
         jplpcMZp/JSF/7m0eWlLZD+JHHGcUCVmkq8Cb1F2fTQCoIcyQGMYpYZ9oT9RF9y3UeUN
         OuVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677174362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gYIq09mCIdt8L8URFfe+pag31rri9xn6YRZUfSTQ4cQ=;
        b=HKl+TpbOdb45pCN1VGmeiqec/J+nyF3QR+5aWD9lNEYe2Ze8+4kVW0r6+npERJVLa1
         R5Tl0aWe+EBSdbD5+mcaaNCKp7COZVJHU6yFEZFWNEIKFPJZTGEB0p9rgDMuokFl499d
         4nGCg6BaEhFYWf4szZoTqc8bHgTIGsSneHcOZPV90ZgU8U4737JUM9kPjCB/B4+8fqRh
         PYVMbvjy7HQEE7s8rSdYdNBm5WgTW6kL/SddccFqkdWX0Cegdo7x86hstL/mGtvTTbWu
         ErCBOrHxgleX4EGsrV4ZOMukA6f2rMy87KfrK46e2H8HfN22FkWGB4VJzJdUyoK1kza8
         lxVg==
X-Gm-Message-State: AO0yUKU/7M//cCpakjF2x3tlFXEo0nmyrqb2c9VgaeQhZz7ZLmH3K/jE
        3qXIkrn+BhsxlDR6FoSOjW0=
X-Google-Smtp-Source: AK7set/HWDu0Z1JwR4f2MLULVfhlz20LZD27Q64dW7aOz28mIbVbVwBH7uH3dA7q/4XucNCFko4n6A==
X-Received: by 2002:ac2:5496:0:b0:4d7:bda4:e6ae with SMTP id t22-20020ac25496000000b004d7bda4e6aemr4409072lfk.3.1677174362080;
        Thu, 23 Feb 2023 09:46:02 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id v6-20020ac25606000000b004b550c26949sm1025697lfd.290.2023.02.23.09.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 09:46:01 -0800 (PST)
Date:   Thu, 23 Feb 2023 19:46:00 +0200
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
Subject: Re: [PATCH RFC v8 32/56] KVM: SVM: Add initial SEV-SNP support
Message-ID: <20230223194600.000018ac@gmail.com>
In-Reply-To: <20230220183847.59159-33-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
        <20230220183847.59159-33-michael.roth@amd.com>
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

On Mon, 20 Feb 2023 12:38:23 -0600
Michael Roth <michael.roth@amd.com> wrote:

> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The next generation of SEV is called SEV-SNP (Secure Nested Paging).
> SEV-SNP builds upon existing SEV and SEV-ES functionality  while adding new
> hardware based security protection. SEV-SNP adds strong memory encryption
> integrity protection to help prevent malicious hypervisor-based attacks
> such as data replay, memory re-mapping, and more, to create an isolated
> execution environment.
> 
> The SNP feature is added incrementally, the later patches adds a new module
> parameters that can be used to enabled SEV-SNP in the KVM.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 10 +++++++++-
>  arch/x86/kvm/svm/svm.h |  8 ++++++++
>  2 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 9e9efb42a766..51db01b282eb 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -58,6 +58,9 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
>  #define sev_es_enabled false
>  #endif /* CONFIG_KVM_AMD_SEV */
>  
> +/* enable/disable SEV-SNP support */
> +static bool sev_snp_enabled;
> +
>  #define AP_RESET_HOLD_NONE		0
>  #define AP_RESET_HOLD_NAE_EVENT		1
>  #define AP_RESET_HOLD_MSR_PROTO		2
> @@ -2306,6 +2309,7 @@ void __init sev_hardware_setup(void)
>  {
>  #ifdef CONFIG_KVM_AMD_SEV
>  	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
> +	bool sev_snp_supported = false;
>  	bool sev_es_supported = false;
>  	bool sev_supported = false;
>  
> @@ -2385,12 +2389,16 @@ void __init sev_hardware_setup(void)
>  	if (misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count))
>  		goto out;
>  
> -	pr_info("SEV-ES supported: %u ASIDs\n", sev_es_asid_count);
>  	sev_es_supported = true;
> +	sev_snp_supported = sev_snp_enabled && cpu_feature_enabled(X86_FEATURE_SEV_SNP);
> +
> +	pr_info("SEV-ES %ssupported: %u ASIDs\n",
> +		sev_snp_supported ? "and SEV-SNP " : "", sev_es_asid_count);
>  
>  out:
>  	sev_enabled = sev_supported;
>  	sev_es_enabled = sev_es_supported;
> +	sev_snp_enabled = sev_snp_supported;
>  #endif
>  }
>  
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 5efcf036ccad..8eb1b51e92f5 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -76,6 +76,7 @@ enum {
>  struct kvm_sev_info {
>  	bool active;		/* SEV enabled guest */
>  	bool es_active;		/* SEV-ES enabled guest */
> +	bool snp_active;	/* SEV-SNP enabled guest */
>  	unsigned int asid;	/* ASID used for this guest */
>  	unsigned int handle;	/* SEV firmware handle */
>  	int fd;			/* SEV device fd */
> @@ -323,6 +324,13 @@ static __always_inline bool sev_es_guest(struct kvm *kvm)
>  #endif
>  }
>  
> +static inline bool sev_snp_guest(struct kvm *kvm)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +
> +	return sev_es_guest(kvm) && sev->snp_active;
> +}
> +

Maybe also use __always_inline like sev_es_guest() above?

It seems solved some warnings before:

https://lore.kernel.org/all/20210624095147.880513802@infradead.org/

>  static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
>  {
>  	vmcb->control.clean = 0;

