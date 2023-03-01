Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2716A6AF6
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 11:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjCAKlp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 05:41:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCAKlo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 05:41:44 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07E7270F;
        Wed,  1 Mar 2023 02:41:42 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id m6so17032917lfq.5;
        Wed, 01 Mar 2023 02:41:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677667301;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i+lwdyMLWrNCUvP02r0csUXgwLUgh7w7WbrI0pmUfWw=;
        b=EPL5WVS3tFSDOLTSWnexGJFkVlGLQr63rDlUGz4KbfG1CDAdaTmo2PQBTQq6KzrjbW
         Posj+feIgGObc/hvqjhm1JUTYHxypeB5N1OocI79dOg5jSq2bv+sk4pb2HdmvxOOmmd7
         kRl1TGZgBle2bjJAoLH+sDKyB64RouLB6PL2gxNmqlYD0ypElu5VxW2EX+l9tByHslig
         Y1z7C71RRCU/s/K3kV/UwHdMnBsKUCm9n3NLTbj+q8Hjdrkivc2LYA3SvekePOb1fwS3
         LJe7wJqdjJRYBglMYo5q3AqhBRYqB9AgwFqATK7wS1TQR+nWogVw2Qa2+FLynzqPSsVq
         5huA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677667301;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i+lwdyMLWrNCUvP02r0csUXgwLUgh7w7WbrI0pmUfWw=;
        b=PlgJ1QE0+5rgSSQTiAjMFJsu1JEDanFE9/VXZLUsECIBMG2AeCW6eUJ0iHq81p8TD9
         Zz4shZG8gk3iPutUWnJV/UVPbncj3M/6ld7ValNzalVzuQOevJ62vbJQEjuURdJcUAfv
         6FzvANSHcj6urA2sd6pQnggifKEKG1fIX2XR5+Il2MemtMMCmbU8uOj5vs1cGuLJg+Gt
         POiBsgu2fEWTbs/lU7dUV/K6oPar25deBVMGyeA1cZA4PXE641Y4bQT6lGIE/WX8k+aK
         feUNPFmM2IekbNnKZ/MAzPqYzyVH4H5uX4mOBdVkvJjdPegioeFfZtiucVakb5th6nwJ
         1ADw==
X-Gm-Message-State: AO0yUKWs+pqZOVN+e8e/0X44EH6P1Ywaxbi/OT8dKLEF7qaa1NmZu4rJ
        zL0yBcDL3i0VdDMEo9I5Tlg=
X-Google-Smtp-Source: AK7set+11Iny2EdWmD9hXw83EgIIV1mL8orIaUR+ppxy5FtPa7r6ToSfgxtS+0dWKUJcZtFHIvc0pg==
X-Received: by 2002:ac2:5197:0:b0:4b5:3e6e:382e with SMTP id u23-20020ac25197000000b004b53e6e382emr1459043lfi.4.1677667300743;
        Wed, 01 Mar 2023 02:41:40 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id h5-20020a05651211c500b004dc48d91061sm1680896lfr.304.2023.03.01.02.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 02:41:40 -0800 (PST)
From:   Zhi Wang <zhi.wang.linux@gmail.com>
X-Google-Original-From: Zhi Wang <zhi.wang.linux@intel.com>
Date:   Wed, 1 Mar 2023 12:41:38 +0200
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
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>
Subject: Re: [PATCH RFC v8 50/56] KVM: SEV: Handle restricted memory
 invalidations for SNP
Message-ID: <20230301124138.000004f9@intel.com>
In-Reply-To: <20230220183847.59159-51-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
        <20230220183847.59159-51-michael.roth@amd.com>
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

On Mon, 20 Feb 2023 12:38:41 -0600
Michael Roth <michael.roth@amd.com> wrote:

> Implement a platform hook to do the work of restoring the direct map
> entries and cleaning up RMP table entries for restricted memory that is
> being freed back to the host.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 62 ++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c |  1 +
>  arch/x86/kvm/svm/svm.h |  1 +
>  3 files changed, 64 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 7a74a92cb39a..bedec90d034f 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4509,3 +4509,65 @@ bool sev_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 error_code, bool *priv
>  
>  	return true;
>  }
> +
> +void sev_invalidate_private_range(struct kvm_memory_slot *slot, gfn_t start, gfn_t end)
> +{
> +	gfn_t gfn = start;
> +
> +	if (!sev_snp_guest(slot->kvm))
> +		return;
> +
> +	if (!kvm_slot_can_be_private(slot)) {
> +		pr_warn_ratelimited("SEV: Memslot for GFN: 0x%llx is not private.\n",
> +				    gfn);
> +		return;
> +	}
> +

This is a generic check for both SNP and TDX, it should be moved to
kvm_restrictedmem_invalidate_begin().

> +	while (gfn <= end) {
> +		gpa_t gpa = gfn_to_gpa(gfn);
> +		int level = PG_LEVEL_4K;
> +		int order, rc;
> +		kvm_pfn_t pfn;
> +
> +		rc = kvm_restrictedmem_get_pfn(slot, gfn, &pfn, &order);
> +		if (rc) {
> +			pr_warn_ratelimited("SEV: Failed to retrieve restricted PFN for GFN 0x%llx, rc: %d\n",
> +					    gfn, rc);
> +			gfn++;
> +			continue;
> +		}
> +
> +		if (order) {
> +			int rmp_level;
> +
> +			if (IS_ALIGNED(gpa, page_level_size(PG_LEVEL_2M)) &&
> +			    gpa + page_level_size(PG_LEVEL_2M) <= gfn_to_gpa(end))
> +				level = PG_LEVEL_2M;
> +			else
> +				pr_debug("%s: GPA 0x%llx is not aligned to 2M, skipping 2M directmap restoration\n",
> +					 __func__, gpa);
> +
> +			/*
> +			 * TODO: It may still be possible to restore 2M mapping here,
> +			 * but keep it simple for now.
> +			 */
> +			if (level == PG_LEVEL_2M &&
> +			    (!snp_lookup_rmpentry(pfn, &rmp_level) || rmp_level == PG_LEVEL_4K)) {
> +				pr_debug("%s: PFN 0x%llx is not mapped as 2M private range, skipping 2M directmap restoration\n",
> +					 __func__, pfn);
> +				level = PG_LEVEL_4K;
> +			}
> +		}
> +
> +		pr_debug("%s: GPA %llx PFN %llx order %d level %d\n",
> +			 __func__, gpa, pfn, order, level);
> +		rc = snp_make_page_shared(slot->kvm, gpa, pfn, level);
> +		if (rc)
> +			pr_err("SEV: Failed to restore page to shared, GPA: 0x%llx PFN: 0x%llx order: %d rc: %d\n",
> +			       gpa, pfn, order, rc);
> +
> +		gfn += page_level_size(level) >> PAGE_SHIFT;
> +		put_page(pfn_to_page(pfn));
> +		cond_resched();
> +	}
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 18e4a6c17d11..3fe5f13b5f3a 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4862,6 +4862,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.adjust_mapping_level = sev_adjust_mapping_level,
>  	.update_mem_attr = sev_update_mem_attr,
>  	.fault_is_private = sev_fault_is_private,
> +	.invalidate_restricted_mem = sev_invalidate_private_range,
>  };
>  
>  /*
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 97038afa8020..857b674e68f0 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -727,6 +727,7 @@ void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
>  void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
>  int sev_update_mem_attr(struct kvm_memory_slot *slot, unsigned int attr,
>  			gfn_t start, gfn_t end);
> +void sev_invalidate_private_range(struct kvm_memory_slot *slot, gfn_t start, gfn_t end);
>  
>  bool sev_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 error_code, bool *private_fault);
>  

