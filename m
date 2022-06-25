Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC3155A564
	for <lists+kvm@lfdr.de>; Sat, 25 Jun 2022 02:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbiFYAQO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 20:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiFYAQN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 20:16:13 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968882F012
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 17:16:11 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id 128so3832563pfv.12
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 17:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5AtCjtMCl+cNMMkHTOz3YEphHVK0Ino+vMPvSCaV+v0=;
        b=k9Uze/489rwgRuE4kj0oFyxL9KvB/x4raQ6LUO0G89lGETZSUOIRHW5G5d7NGBYC6E
         dtpK+4ceOET3mNXfchYc7P1FFgwB2OxQMjLirlEaa7U3TXyJ5+RZKvtaGhPfDGZdGcD3
         epCiDPyGczEqDfytW13+GVP5z1trr9j6k3fbCzDNy4tAWQ8RYWXOElRAAxe0HSqd7zYH
         JoBttswyv6sN4eGa73FboHIWrfj26hiji66SAF9JP0YmBIWyrOWAp5NVTJksBZsTSiyf
         g65pFRepDqa0I1p5g5ozewFjzjKnHUhB5nX1ToNTnjNcBzQu99tuP+RBrrN32K/b5+RF
         TxXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5AtCjtMCl+cNMMkHTOz3YEphHVK0Ino+vMPvSCaV+v0=;
        b=FHa9bsEifAxQH8U2x0jQBeddpivueX8EHuSm+RSUFvsTC+1sMITBsAfp2mXG6Xk5jg
         96M9CbjcBWZK8ycb9XFwoGbijjmsEPd7Bch604+9jEWhDZrPLDusNeajNLpr12sBGLlk
         ry7hA0hf9FHv+rkvcTdRh3AUtV3HTgiyqIKy2+iSUG1JXgLfuY5ZmaVL0DVSrlS3wqup
         Upcde7pHJ2FDc9wBuhdVS8YzbM+0NojU7NGniTu+rwbRGPXcZYoLo08qazd8yzUhMDo9
         RdHt8v41qXFPQws5KvqKYjSrMSfVh151e8jNuCbgpFLRVXfPPAyTE+eb+3gHxQfmbvqc
         b4Aw==
X-Gm-Message-State: AJIora/hecgqCf5hcIhNLmCIPEg16/nIRQ539lF1PpVzGpixTSh+1iCE
        FWzeFzY2eH+YoaijxGVbrRnvoQ==
X-Google-Smtp-Source: AGRyM1vH/cHF+pfBs7Ks90bQw4lCq44ffDUDQ8soA5ZqNOWhnaNGuB4Fv7S8u/Qx0J5xS+txpzGgVw==
X-Received: by 2002:a63:6942:0:b0:40d:b8a:c55f with SMTP id e63-20020a636942000000b0040d0b8ac55fmr1255019pgc.542.1656116170981;
        Fri, 24 Jun 2022 17:16:10 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id q1-20020a170902a3c100b001675991fb7fsm2373623plb.55.2022.06.24.17.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 17:16:10 -0700 (PDT)
Date:   Sat, 25 Jun 2022 00:16:05 +0000
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH 2/4] KVM: x86/mmu: Defer "full" MMU setup until after
 vendor hardware_setup()
Message-ID: <YrZTxZm4kq0rXcKQ@google.com>
References: <20220624232735.3090056-1-seanjc@google.com>
 <20220624232735.3090056-3-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220624232735.3090056-3-seanjc@google.com>
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

On Fri, Jun 24, 2022 at 11:27:33PM +0000, Sean Christopherson wrote:
> Defer MMU setup, and in particular allocation of pte_list_desc_cache,
> until after the vendor's hardware_setup() has run, i.e. until after the
> MMU has been configured by vendor code.  This will allow a future commit
> to dynamically size pte_list_desc's array of sptes based on whether or
> not KVM is using TDP.
> 
> Alternatively, the setup could be done in kvm_configure_mmu(), but that
> would require vendor code to call e.g. kvm_unconfigure_mmu() in teardown
> and error paths, i.e. doesn't actually save code and is arguably uglier.
> 
> Note, keep the reset of PTE masks where it is to ensure that the masks
> are reset before the vendor's hardware_setup() runs, i.e. before the
> vendor code has a chance to manipulate the masks, e.g. VMX modifies masks
> even before calling kvm_configure_mmu().
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
[...]
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 17ac30b9e22c..ceb81e04aea3 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6673,10 +6673,8 @@ void kvm_mmu_x86_module_init(void)
>   * loaded as many of the masks/values may be modified by VMX or SVM, i.e. need
>   * to be reset when a potentially different vendor module is loaded.
>   */
> -int kvm_mmu_vendor_module_init(void)
> +void kvm_mmu_vendor_module_init(void)
>  {
> -	int ret = -ENOMEM;
> -
>  	/*
>  	 * MMU roles use union aliasing which is, generally speaking, an
>  	 * undefined behavior. However, we supposedly know how compilers behave
> @@ -6687,7 +6685,13 @@ int kvm_mmu_vendor_module_init(void)
>  	BUILD_BUG_ON(sizeof(union kvm_mmu_extended_role) != sizeof(u32));
>  	BUILD_BUG_ON(sizeof(union kvm_cpu_role) != sizeof(u64));
>  
> +	/* Reset the PTE masks before the vendor module's hardware setup. */
>  	kvm_mmu_reset_all_pte_masks();
> +}
> +
> +int kvm_mmu_hardware_setup(void)
> +{

Instead of putting this code in a new function and calling it after
hardware_setup(), we could put it in kvm_configure_mmu().

This will result in a larger patch diff, but has it eliminates a subtle
and non-trivial-to-verify dependency ordering between
kvm_configure_mmu() and kvm_mmu_hardware_setup() and it will co-locate
the initialization of nr_sptes_per_pte_list and the code that uses it to
create pte_list_desc_cache in a single function.
