Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05FDD5A0513
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 02:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiHYAQs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 20:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiHYAQo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 20:16:44 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A755875CC2
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 17:16:43 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id 2so17126709pll.0
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 17:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=MHdzy+Y3IGKPhJ5wgSVwr2qbqw/cZ1nEjeINOhlIR1Y=;
        b=KI61vBSlvf0smginpmDqNipT7pvmL+34ub49oTYJ8vAL/m7HAL8OPVtMe9VxqC/xp4
         l/IWhbjvmdx0Lm/EQu26nOyM9Wxc2nilf2Qo+vharJdIEAzf58p//MvSK7coJYr9Y807
         4RD4y98tNErVdj0CMfP1jhzkb4raK8goULt9dLMWBTxnpkwSxZfFpFnwSK4JMvRCu1EW
         OE0wgvpyfodk4KEE6NhI0M8YDX90sEJd/330ZMxLe4Z0Y65Jm3tjfkFAreI8hJlYHDnt
         BAeo+9v5/bW4OAcUYlwe5JeU1ZWdxa0kV7LOAyoKPXVjeq+RmJh8hSPApyxx0lLRpMs+
         /7tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=MHdzy+Y3IGKPhJ5wgSVwr2qbqw/cZ1nEjeINOhlIR1Y=;
        b=7WpVY/akxaid1CK0kIdcpREbFA1da2AWB7ECmMVKwVt6ZBWuteYkJlnbS+ljHjXouS
         j/q+2iv9u55D+0mYa5aJjgeG1IoursM0FVIVSHIccQyse7GfcC1OE+AnzRNdUBHNeafk
         BLjCt2952zuSouZhMgtslq4R40tZf0YJKqdbnfEZ+T8PicqiTWqQv9k9CSxd7EYPwu6m
         ArTHZg+aK1b1FSga5QsuYWj9NiJgXHhUFMgm8WUormON9/7iQRt+fteMFZxz2gr4YG3T
         JuwGEtO2VwC7PiacXiJie3t++TIT7cqra1GazdqKz17GgRBvfwkZbnlprVBR42mkBWcJ
         kV2A==
X-Gm-Message-State: ACgBeo0T9YfZuFuA0a/WynTOiAS+DhvHULuyzPaAdTqqncHL48M4hP7P
        lj72ELl3AT/p6fYj+oH+UjakKg==
X-Google-Smtp-Source: AA6agR69d6gIuxI19ypQK8juYAOBDvyZVYJGbVKFz011vcOsLImHYI5Fbe6AvKvRavE2ED/FcyHI6g==
X-Received: by 2002:a17:90b:1c0c:b0:1f5:494a:304b with SMTP id oc12-20020a17090b1c0c00b001f5494a304bmr1647000pjb.157.1661386602993;
        Wed, 24 Aug 2022 17:16:42 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id l12-20020a170903244c00b0015e8d4eb1d5sm13390904pls.31.2022.08.24.17.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 17:16:42 -0700 (PDT)
Date:   Thu, 25 Aug 2022 00:16:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>
Subject: Re: [PATCH 4/5] selftests: KVM: Add support for posted interrupt
 handling in L2
Message-ID: <Ywa/ZhbEJwo6gkRr@google.com>
References: <20220802230718.1891356-1-mizhang@google.com>
 <20220802230718.1891356-5-mizhang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802230718.1891356-5-mizhang@google.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 02, 2022, Mingwei Zhang wrote:
> Add support for posted interrupt handling in L2. This is done by adding
> needed data structures in vmx_pages and APIs to allow an L2 receive posted
> interrupts
> 
> Cc: Jim Mattson <jmattson@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  tools/testing/selftests/kvm/include/x86_64/vmx.h | 10 ++++++++++
>  tools/testing/selftests/kvm/lib/x86_64/vmx.c     | 16 ++++++++++++++++
>  2 files changed, 26 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
> index 7d8c980317f7..3449ae8ab282 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
> @@ -579,6 +579,14 @@ struct vmx_pages {
>  	void *apic_access_hva;
>  	uint64_t apic_access_gpa;
>  	void *apic_access;
> +
> +	void *virtual_apic_hva;
> +	uint64_t virtual_apic_gpa;
> +	void *virtual_apic;
> +
> +	void *posted_intr_desc_hva;
> +	uint64_t posted_intr_desc_gpa;
> +	void *posted_intr_desc;
>  };
>  
>  union vmx_basic {
> @@ -622,5 +630,7 @@ void nested_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
>  void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
>  		  uint32_t eptp_memslot);
>  void prepare_virtualize_apic_accesses(struct vmx_pages *vmx, struct kvm_vm *vm);
> +void prepare_virtual_apic(struct vmx_pages *vmx, struct kvm_vm *vm);
> +void prepare_posted_intr_desc(struct vmx_pages *vmx, struct kvm_vm *vm);
>  
>  #endif /* SELFTEST_KVM_VMX_H */
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> index 80a568c439b8..7d65bee37b9f 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> @@ -556,3 +556,19 @@ void prepare_virtualize_apic_accesses(struct vmx_pages *vmx, struct kvm_vm *vm)
>  	vmx->apic_access_hva = addr_gva2hva(vm, (uintptr_t)vmx->apic_access);
>  	vmx->apic_access_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->apic_access);
>  }
> +
> +void prepare_virtual_apic(struct vmx_pages *vmx, struct kvm_vm *vm)
> +{
> +	vmx->virtual_apic = (void *)vm_vaddr_alloc_page(vm);
> +	vmx->virtual_apic_hva = addr_gva2hva(vm, (uintptr_t)vmx->virtual_apic);
> +	vmx->virtual_apic_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->virtual_apic);
> +}
> +
> +void prepare_posted_intr_desc(struct vmx_pages *vmx, struct kvm_vm *vm)
> +{
> +	vmx->posted_intr_desc = (void *)vm_vaddr_alloc_page(vm);
> +	vmx->posted_intr_desc_hva =
> +		addr_gva2hva(vm, (uintptr_t)vmx->posted_intr_desc);
> +	vmx->posted_intr_desc_gpa =
> +		addr_gva2gpa(vm, (uintptr_t)vmx->posted_intr_desc);

Let these poke out, or capture the field in a local var.  Actually, posted_intr_desc
is a void *, is casting even necessary?


> +}
> -- 
> 2.37.1.455.g008518b4e5-goog
> 
