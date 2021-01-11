Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 225DE2F22BC
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 23:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390297AbhAKW04 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 17:26:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389909AbhAKW0x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 17:26:53 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06C3C061786
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 14:26:06 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id m6so142503pfm.6
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 14:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dsx9zNhBNgm7/MgiHPV9Mv1Hz514Va+ALCf6uCUdhWs=;
        b=DmDR8Hc5JKjKe/jOX7P9yMKIy50msWGR8lniN6PxRWC0/+yijXPk0WMywC4zAB3OF5
         LrCorWF9RmpWBfgermpou7207MQVh/svCpxozZhqgM+Ln3PIl8K+YubbVRc9a4OELBlA
         XL+UuKH5XmJa+lTjJ13/LZHaHy/gYHO39oxVQyxj82yE5fdHphTiUiityJJJYG9hStby
         mRQTiJ9rTnNZZn+RyukSE11iQtl07TMEYbwxR+zRa+zE7qKusnLQR2JCJmJDvrhNDFoz
         NNcG1cV8us2bTB+WxQPZVNBHBxfisBCsDmvQdvZ6ZzHwCTaCZPAsCMlmQlsF7Tc8b3Q/
         dM2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dsx9zNhBNgm7/MgiHPV9Mv1Hz514Va+ALCf6uCUdhWs=;
        b=M3z00rz2VVf2JXvX67TmUZPF7PtSr4EZNG6pbS5fnCEVeDhyEPEClUKgbMrKSUJxGB
         WO0llsqtSJkEcmEJ63/0DTa2lGBeDUO2l31OPxmRKQuxpCK79jfRz6XXjrL31/ejJnpE
         qY5mof4JQVOCBltKwdJXOB8XSP0YsVPcb+eIFpGHcfU3zrJEfqATQO4buQXPbRpw7xrk
         UBHH0Qzy9DdhFx9/p2nyrjQCD4cHE92l1Pn3g4VieZB70QfSCHnZtgrurUQG8LWGBwnC
         xxSmnhp1obGA/iHaDLW+M61fPwdaA33wQ8v1vuXGEOsIS6Y9+KTL4UdLRqfvocWBrw89
         pBmg==
X-Gm-Message-State: AOAM5335RJgJtHyQTV6qw5JFza0FlgiB1ZzGc6t/HTOTEzxLUcmT40Od
        b5YzyfWy8jQ9zm8/kWSuUa35nA==
X-Google-Smtp-Source: ABdhPJx9oyanVFeJAzYH7MnU/avyhn37WOVd2mMm7z2PWYOXwwWPxq+wSktGV0jkI7b0agDzJQnakg==
X-Received: by 2002:a62:303:0:b029:1a5:a6f7:ac0d with SMTP id 3-20020a6203030000b02901a5a6f7ac0dmr1740170pfd.63.1610403966129;
        Mon, 11 Jan 2021 14:26:06 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id u1sm417135pjr.51.2021.01.11.14.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 14:26:05 -0800 (PST)
Date:   Mon, 11 Jan 2021 14:25:59 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] x86/access: Fixed test stuck issue on new
 52bit machine
Message-ID: <X/zQdznwyBXHoout@google.com>
References: <20210110091942.12835-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210110091942.12835-1-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jan 10, 2021, Yang Weijiang wrote:
> When the application is tested on a machine with 52bit-physical-address, the
> synthesized 52bit GPA triggers EPT(4-Level) fast_page_fault infinitely.

That doesn't sound right, KVM should use 5-level EPT if guest maxpa > 48.
Hmm, unless the CPU doesn't support 5-level EPT, but I didn't think such CPUs
(maxpa=52 w/o 5-level EPT) existed?  Ah, but it would be possible with nested
VMX, and initial KVM 5-level support didn't allow nested 5-level EPT.  Any
chance you're running this test in a VM with 5-level EPT disabled, but maxpa=52?

> On the other hand, there's no reserved bits in 51:max_physical_address on
> machines with 52bit-physical-address.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  x86/access.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/x86/access.c b/x86/access.c
> index 7dc9eb6..bec1c4d 100644
> --- a/x86/access.c
> +++ b/x86/access.c
> @@ -15,6 +15,7 @@ static _Bool verbose = false;
>  typedef unsigned long pt_element_t;
>  static int invalid_mask;
>  static int page_table_levels;
> +static int max_phyaddr;
>  
>  #define PT_BASE_ADDR_MASK ((pt_element_t)((((pt_element_t)1 << 36) - 1) & PAGE_MASK))
>  #define PT_PSE_BASE_ADDR_MASK (PT_BASE_ADDR_MASK & ~(1ull << 21))
> @@ -394,9 +395,10 @@ static void ac_emulate_access(ac_test_t *at, unsigned flags)
>      if (!F(AC_PDE_ACCESSED))
>          at->ignore_pde = PT_ACCESSED_MASK;
>  
> -    pde_valid = F(AC_PDE_PRESENT)
> -        && !F(AC_PDE_BIT51) && !F(AC_PDE_BIT36) && !F(AC_PDE_BIT13)
> +    pde_valid = F(AC_PDE_PRESENT) && !F(AC_PDE_BIT36) && !F(AC_PDE_BIT13)
>          && !(F(AC_PDE_NX) && !F(AC_CPU_EFER_NX));
> +    if (max_phyaddr < 52)
> +        pde_valid &= !F(AC_PDE_BIT51);
>  
>      if (!pde_valid) {
>          at->expected_fault = 1;
> @@ -420,9 +422,10 @@ static void ac_emulate_access(ac_test_t *at, unsigned flags)
>  
>      at->expected_pde |= PT_ACCESSED_MASK;
>  
> -    pte_valid = F(AC_PTE_PRESENT)
> -        && !F(AC_PTE_BIT51) && !F(AC_PTE_BIT36)
> +    pte_valid = F(AC_PTE_PRESENT) && !F(AC_PTE_BIT36)
>          && !(F(AC_PTE_NX) && !F(AC_CPU_EFER_NX));
> +    if (max_phyaddr < 52)
> +        pte_valid &= !F(AC_PTE_BIT51);

This _should_ be unnecessary.  As below, AC_*_BIT51_MASK will be set in
invalid_mask, and so ac_test_bump_one() will skip tests that try to set bit 51.

>      if (!pte_valid) {
>          at->expected_fault = 1;
> @@ -964,13 +967,11 @@ static int ac_test_run(void)
>      shadow_cr4 = read_cr4();
>      shadow_efer = rdmsr(MSR_EFER);
>  
> -    if (cpuid_maxphyaddr() >= 52) {
> -        invalid_mask |= AC_PDE_BIT51_MASK;
> -        invalid_mask |= AC_PTE_BIT51_MASK;
> -    }
> -    if (cpuid_maxphyaddr() >= 37) {
> +    if (max_phyaddr  >= 37 && max_phyaddr < 52) {
>          invalid_mask |= AC_PDE_BIT36_MASK;
>          invalid_mask |= AC_PTE_BIT36_MASK;
> +        invalid_mask |= AC_PDE_BIT51_MASK;
> +        invalid_mask |= AC_PTE_BIT51_MASK;
>      }

This change is incorrect.  "invalid_mask" is misleading in this context as it
means "bits that can't be tested because they're legal".  So setting the bit 51
flags in invalid_mask if 'maxpa >= 52' is correct, as it states those tests are
"invalid" because setting bit 51 will not fault.

All that being said, it's also entirely possible I'm misreading this test, I've
done it many times before :-)

>      if (this_cpu_has(X86_FEATURE_PKU)) {
> @@ -1038,6 +1039,7 @@ int main(void)
>      int r;
>  
>      printf("starting test\n\n");
> +    max_phyaddr = cpuid_maxphyaddr();
>      page_table_levels = 4;
>      r = ac_test_run();
>  
> -- 
> 2.17.2
> 
