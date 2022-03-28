Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3984EA17F
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 22:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344885AbiC1UbO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 16:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345891AbiC1UbH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 16:31:07 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BB23DDED
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 13:29:25 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id i11so15728229plr.1
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 13:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/4W3IfBTDwK+tQlKzd86ll/8Sy27cDUhj3fakj6+JPo=;
        b=C1nlR1GwqLJNFMhz656qiqwH5o4GFPTIXwkjQjKbMGwP/QD4l8PzAPCp4bgTqjzVBM
         VqBPQgmR1FTz3yryHYkvK3JSQ3GeVxXPXpmVTOyR/HLleY71pnyKFC1cAwlmCL6DO+le
         nDwm1nKgU/CXLyKe8wg81jPHsXOKka4uWJlCRoDKuQclERiNCQzqovS8EX9agiNPduVe
         +nhBexPK5StGhOj0FU5xT5Z+1KENQFYPbYFpsQTFTTIJxa30CQt38RkraKajtdrO/f/c
         7DODTZeMvsqqjVRd5lfrXuXcBBdeJZ7AfKVunW1H4q+u3sX3sduBptFT/n4XyhBjZ24l
         1jJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/4W3IfBTDwK+tQlKzd86ll/8Sy27cDUhj3fakj6+JPo=;
        b=jlVvVzIkC/N0STvxqUPmhjlEOKawdi8P2AZPxfrjqnL9uWrlzap2/JMZogPqmOFdyr
         cevEPza8h1WWVCra/Dpb3pqlz7h5MuMhhuW55JbpFCMGf5+pjKV1FjmtyhXBqzRBAR4Z
         R44o8ptKEhoUS8MZAjN2P3AWGXoRlx2dmB9UaybWW3v6eFG9KniEW3A2UrsNcXYfyw5V
         t3FWujIhgjkEvMeRXdp2dSAKaHzSLVNGQ0No6eSUUYImbOMq4I1sfpByzYqhk2lKynWr
         nzkeYADJZCL/zqchc3fD4COkw4dXrrPMCGKvH9Rjoh/lkSv/s9VGK8AgFnZCmilxEw3h
         6pgA==
X-Gm-Message-State: AOAM530Fdm9gB87iGg5xsQM04J2kmemQibueK0Li4VMLV9n1OTO84htJ
        M/4bQpdEkDeXkVSmuaVfJvW6+g==
X-Google-Smtp-Source: ABdhPJwuKOQ7GfxCK+jtNa/zIEEvWhWWgrPU+xvVD2fZ8q10QaODbvTOs86FwYZ8335yAoB/HOe4xA==
X-Received: by 2002:a17:90a:5643:b0:1bf:ac1f:a1de with SMTP id d3-20020a17090a564300b001bfac1fa1demr899633pji.224.1648499364345;
        Mon, 28 Mar 2022 13:29:24 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id s1-20020a056a00178100b004f731a1a952sm17014176pfg.168.2022.03.28.13.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 13:29:23 -0700 (PDT)
Date:   Mon, 28 Mar 2022 20:29:19 +0000
From:   David Matlack <dmatlack@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v2 09/11] KVM: x86/MMU: Allow NX huge pages to be
 disabled on a per-vm basis
Message-ID: <YkIan0iLv3DS16G9@google.com>
References: <20220321234844.1543161-1-bgardon@google.com>
 <20220321234844.1543161-10-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321234844.1543161-10-bgardon@google.com>
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

On Mon, Mar 21, 2022 at 04:48:42PM -0700, Ben Gardon wrote:
> In some cases, the NX hugepage mitigation for iTLB multihit is not
> needed for all guests on a host. Allow disabling the mitigation on a
> per-VM basis to avoid the performance hit of NX hugepages on trusted
> workloads.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/mmu.h              | 1 +
>  arch/x86/kvm/mmu/mmu.c          | 6 ++++--
>  arch/x86/kvm/x86.c              | 6 ++++++
>  include/uapi/linux/kvm.h        | 1 +
>  5 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 0a0c54639dd8..04ddfc475ce0 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1242,6 +1242,7 @@ struct kvm_arch {
>  #endif
>  
>  	bool nx_huge_pages;
> +	bool disable_nx_huge_pages;
>  };
>  
>  struct kvm_vm_stat {
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index dd28fe8d13ae..36d8d84ca6c6 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -177,6 +177,7 @@ static inline bool is_nx_huge_page_enabled(struct kvm *kvm)
>  {
>  	return READ_ONCE(kvm->arch.nx_huge_pages);
>  }
> +void kvm_update_nx_huge_pages(struct kvm *kvm);
>  
>  static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  					u32 err, bool prefetch)
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index dc9672f70468..a7d387ccfd74 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6195,9 +6195,10 @@ static void __set_nx_huge_pages(bool val)
>  	nx_huge_pages = itlb_multihit_kvm_mitigation = val;
>  }
>  
> -static void kvm_update_nx_huge_pages(struct kvm *kvm)
> +void kvm_update_nx_huge_pages(struct kvm *kvm)
>  {
> -	kvm->arch.nx_huge_pages = nx_huge_pages;
> +	kvm->arch.nx_huge_pages = nx_huge_pages &&
> +				  !kvm->arch.disable_nx_huge_pages;

kvm->arch.nx_huge_pages seems like it could be dropped and
is_nx_huge_page_enabled() could just check this condition.

>  
>  	mutex_lock(&kvm->slots_lock);
>  	kvm_mmu_zap_all_fast(kvm);
> @@ -6451,6 +6452,7 @@ int kvm_mmu_post_init_vm(struct kvm *kvm)
>  	int err;
>  
>  	kvm->arch.nx_huge_pages = READ_ONCE(nx_huge_pages);
> +	kvm->arch.disable_nx_huge_pages = false;

I believe this can be omitted since kvm_arch is zero-initialized.

>  	err = kvm_vm_create_worker_thread(kvm, kvm_nx_lpage_recovery_worker, 0,
>  					  "kvm-nx-lpage-recovery",
>  					  &kvm->arch.nx_lpage_recovery_thread);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 51106d32f04e..73df90a6932b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4256,6 +4256,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_SYS_ATTRIBUTES:
>  	case KVM_CAP_VAPIC:
>  	case KVM_CAP_ENABLE_CAP:
> +	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:

Please document the new capability.

>  		r = 1;
>  		break;
>  	case KVM_CAP_EXIT_HYPERCALL:
> @@ -6048,6 +6049,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		}
>  		mutex_unlock(&kvm->lock);
>  		break;
> +	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
> +		kvm->arch.disable_nx_huge_pages = true;
> +		kvm_update_nx_huge_pages(kvm);
> +		r = 0;
> +		break;
>  	default:
>  		r = -EINVAL;
>  		break;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index ee5cc9e2a837..6f9fa7ecfd1e 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1144,6 +1144,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_S390_MEM_OP_EXTENSION 211
>  #define KVM_CAP_PMU_CAPABILITY 212
>  #define KVM_CAP_DISABLE_QUIRKS2 213
> +#define KVM_CAP_VM_DISABLE_NX_HUGE_PAGES 214
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> -- 
> 2.35.1.894.gb6a874cedc-goog
> 
