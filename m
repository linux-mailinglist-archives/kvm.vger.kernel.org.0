Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6625A1B5C28
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 15:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbgDWNJU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 09:09:20 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:60121 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726224AbgDWNJT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Apr 2020 09:09:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587647358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nRDrgnXHrxpTZaiKHSlO8TdKkp85FQtZIsNzBFi8N+E=;
        b=cILHGmmI4P338SDZN4lEekucljHYy09dWNbBifJOh4Q7xI8ws5nI8QuxrWsn014lpWMoTN
        KPWsZIDn0AiLrh2YKhJ7ee6ol76vZ2yY/eqiasKbeFKO2BGS7wcYcfbW8WNyAydpWwPXYi
        L/7Htvr8wWx7Woao8oTyQhqRkSR6tUQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-gCdeEIuqOjuS9KiDqMxbYg-1; Thu, 23 Apr 2020 09:09:08 -0400
X-MC-Unique: gCdeEIuqOjuS9KiDqMxbYg-1
Received: by mail-wr1-f71.google.com with SMTP id y10so2827035wrn.5
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 06:09:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nRDrgnXHrxpTZaiKHSlO8TdKkp85FQtZIsNzBFi8N+E=;
        b=gsvvHrBKzPLdtycP+palvtyn2HLniEefl2+Oo1tiqXjFKzH0LOmv00SPlmT6d2XAwu
         QmpjyhC5JfrqN8clVptSmfiPC52rdM2iLIXzqi+IrYxLkzA5nH0fPkeNAdlMy5SIpbSR
         g9jCqwh67b1/Nnxlx7aupLoBNz6OtYismvYJf6qEtGdiS3eulBa1cP8I4nhQe+57DDgY
         qbGjkOKpdr4EmgbpEmVXRcGycapQIkx8IiPaXl6+XQaJ4HVA+x3LMo4c8sUH/sXbUncJ
         W3dKd04VX2/NrrfWx9CB9QSe65CxRbFlS2g6bMvRVVeNjqrdirO4B1WzWAF63++0PAu3
         oiSA==
X-Gm-Message-State: AGi0PuZoXixOI52/vXStkfdBrCFEZ36Dj14ACc13Y8Uel7UeOZdS0Efg
        u1m5RFlbrlgqi0C5aW8EfCel6rsSX3U9Y74SML8o1eVzQ13wcO6zTphdTcXFuWNRUQT3RRcxH7Z
        6vHkLp11jNMK1
X-Received: by 2002:a05:6000:8f:: with SMTP id m15mr4893177wrx.19.1587647347530;
        Thu, 23 Apr 2020 06:09:07 -0700 (PDT)
X-Google-Smtp-Source: APiQypKQhJQKXaNSzOGt3YG9cwUmHegnE/E9zR6KvQ89lUTl30MbyVJZL9olprQhG2/iHh3vioVUNw==
X-Received: by 2002:a05:6000:8f:: with SMTP id m15mr4893150wrx.19.1587647347272;
        Thu, 23 Apr 2020 06:09:07 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id w83sm3784105wmb.37.2020.04.23.06.09.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 06:09:06 -0700 (PDT)
Subject: Re: [kvm-unit-test PATCH] x86: access: Add tests for reserved bits of
 guest physical address
To:     Mohammed Gamal <mgamal@redhat.com>, kvm@vger.kernel.org
References: <20200423103623.431206-1-mgamal@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3fd74ede-56f9-4ac5-1af6-51cc14ca2fdb@redhat.com>
Date:   Thu, 23 Apr 2020 15:09:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200423103623.431206-1-mgamal@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/04/20 12:36, Mohammed Gamal wrote:
> This extends the access tests to also test for reserved bits
> in guest physical addresses.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
> ---
>  x86/access.c      | 34 +++++++++++++++++++++++++++++++---
>  x86/unittests.cfg |  2 +-
>  2 files changed, 32 insertions(+), 4 deletions(-)
> 
> diff --git a/x86/access.c b/x86/access.c
> index 86d8a72..068b4dc 100644
> --- a/x86/access.c
> +++ b/x86/access.c
> @@ -16,7 +16,7 @@ typedef unsigned long pt_element_t;
>  static int invalid_mask;
>  static int page_table_levels;
>  
> -#define PT_BASE_ADDR_MASK ((pt_element_t)((((pt_element_t)1 << 40) - 1) & PAGE_MASK))
> +#define PT_BASE_ADDR_MASK ((pt_element_t)((((pt_element_t)1 << 36) - 1) & PAGE_MASK))
>  #define PT_PSE_BASE_ADDR_MASK (PT_BASE_ADDR_MASK & ~(1ull << 21))
>  
>  #define CR0_WP_MASK (1UL << 16)
> @@ -47,6 +47,7 @@ enum {
>      AC_PTE_DIRTY_BIT,
>      AC_PTE_NX_BIT,
>      AC_PTE_BIT51_BIT,
> +    AC_PTE_BIT36_BIT,
>  
>      AC_PDE_PRESENT_BIT,
>      AC_PDE_WRITABLE_BIT,
> @@ -56,6 +57,7 @@ enum {
>      AC_PDE_PSE_BIT,
>      AC_PDE_NX_BIT,
>      AC_PDE_BIT51_BIT,
> +    AC_PDE_BIT36_BIT,
>      AC_PDE_BIT13_BIT,
>  
>      AC_PKU_AD_BIT,
> @@ -82,6 +84,7 @@ enum {
>  #define AC_PTE_DIRTY_MASK     (1 << AC_PTE_DIRTY_BIT)
>  #define AC_PTE_NX_MASK        (1 << AC_PTE_NX_BIT)
>  #define AC_PTE_BIT51_MASK     (1 << AC_PTE_BIT51_BIT)
> +#define AC_PTE_BIT36_MASK     (1 << AC_PTE_BIT36_BIT)
>  
>  #define AC_PDE_PRESENT_MASK   (1 << AC_PDE_PRESENT_BIT)
>  #define AC_PDE_WRITABLE_MASK  (1 << AC_PDE_WRITABLE_BIT)
> @@ -91,6 +94,7 @@ enum {
>  #define AC_PDE_PSE_MASK       (1 << AC_PDE_PSE_BIT)
>  #define AC_PDE_NX_MASK        (1 << AC_PDE_NX_BIT)
>  #define AC_PDE_BIT51_MASK     (1 << AC_PDE_BIT51_BIT)
> +#define AC_PDE_BIT36_MASK     (1 << AC_PDE_BIT36_BIT)
>  #define AC_PDE_BIT13_MASK     (1 << AC_PDE_BIT13_BIT)
>  
>  #define AC_PKU_AD_MASK        (1 << AC_PKU_AD_BIT)
> @@ -115,6 +119,7 @@ const char *ac_names[] = {
>      [AC_PTE_DIRTY_BIT] = "pte.d",
>      [AC_PTE_NX_BIT] = "pte.nx",
>      [AC_PTE_BIT51_BIT] = "pte.51",
> +    [AC_PTE_BIT36_BIT] = "pte.36",
>      [AC_PDE_PRESENT_BIT] = "pde.p",
>      [AC_PDE_ACCESSED_BIT] = "pde.a",
>      [AC_PDE_WRITABLE_BIT] = "pde.rw",
> @@ -123,6 +128,7 @@ const char *ac_names[] = {
>      [AC_PDE_PSE_BIT] = "pde.pse",
>      [AC_PDE_NX_BIT] = "pde.nx",
>      [AC_PDE_BIT51_BIT] = "pde.51",
> +    [AC_PDE_BIT36_BIT] = "pde.36",
>      [AC_PDE_BIT13_BIT] = "pde.13",
>      [AC_PKU_AD_BIT] = "pkru.ad",
>      [AC_PKU_WD_BIT] = "pkru.wd",
> @@ -295,6 +301,14 @@ static _Bool ac_test_legal(ac_test_t *at)
>      if (!F(AC_PDE_PSE) && F(AC_PDE_BIT13))
>          return false;
>  
> +    /*
> +     * Shorten the test by avoiding testing too many reserved bit combinations
> +     */
> +    if ((F(AC_PDE_BIT51) + F(AC_PDE_BIT36) + F(AC_PDE_BIT13)) > 1)
> +        return false;
> +    if ((F(AC_PTE_BIT51) + F(AC_PTE_BIT36)) > 1)
> +        return false;
> +
>      return true;
>  }
>  
> @@ -381,7 +395,7 @@ static void ac_emulate_access(ac_test_t *at, unsigned flags)
>          at->ignore_pde = PT_ACCESSED_MASK;
>  
>      pde_valid = F(AC_PDE_PRESENT)
> -        && !F(AC_PDE_BIT51) && !F(AC_PDE_BIT13)
> +        && !F(AC_PDE_BIT51) && !F(AC_PDE_BIT36) && !F(AC_PDE_BIT13)
>          && !(F(AC_PDE_NX) && !F(AC_CPU_EFER_NX));
>  
>      if (!pde_valid) {
> @@ -407,7 +421,7 @@ static void ac_emulate_access(ac_test_t *at, unsigned flags)
>      at->expected_pde |= PT_ACCESSED_MASK;
>  
>      pte_valid = F(AC_PTE_PRESENT)
> -        && !F(AC_PTE_BIT51)
> +        && !F(AC_PTE_BIT51) && !F(AC_PTE_BIT36)
>          && !(F(AC_PTE_NX) && !F(AC_CPU_EFER_NX));
>  
>      if (!pte_valid) {
> @@ -516,6 +530,8 @@ static void __ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool,
>  		pte |= PT64_NX_MASK;
>  	    if (F(AC_PDE_BIT51))
>  		pte |= 1ull << 51;
> +	    if (F(AC_PDE_BIT36))
> +                pte |= 1ull << 36;
>  	    if (F(AC_PDE_BIT13))
>  		pte |= 1ull << 13;
>  	    at->pdep = &vroot[index];
> @@ -538,6 +554,8 @@ static void __ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool,
>  		pte |= PT64_NX_MASK;
>  	    if (F(AC_PTE_BIT51))
>  		pte |= 1ull << 51;
> +	    if (F(AC_PTE_BIT36))
> +                pte |= 1ull << 36;
>  	    at->ptep = &vroot[index];
>  	    break;
>  	}
> @@ -736,6 +754,7 @@ static void ac_test_show(ac_test_t *at)
>  	    strcat(line, " ");
>  	    strcat(line, ac_names[i]);
>  	}
> +
>      strcat(line, ": ");
>      printf("%s", line);
>  }
> @@ -945,6 +964,15 @@ static int ac_test_run(void)
>      shadow_cr4 = read_cr4();
>      shadow_efer = rdmsr(MSR_EFER);
>  
> +    if (cpuid_maxphyaddr() >= 52) {
> +        invalid_mask |= AC_PDE_BIT51_MASK;
> +        invalid_mask |= AC_PTE_BIT51_MASK;
> +    }
> +    if (cpuid_maxphyaddr() >= 37) {
> +        invalid_mask |= AC_PDE_BIT36_MASK;
> +        invalid_mask |= AC_PTE_BIT36_MASK;
> +    }
> +
>      if (this_cpu_has(X86_FEATURE_PKU)) {
>          set_cr4_pke(1);
>          set_cr4_pke(0);
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index d658bc8..bf0d02e 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -116,7 +116,7 @@ extra_params = -cpu qemu64,+x2apic,+tsc-deadline -append tscdeadline_immed
>  [access]
>  file = access.flat
>  arch = x86_64
> -extra_params = -cpu host
> +extra_params = -cpu host,phys-bits=36
>  
>  [smap]
>  file = smap.flat
> 

Queued, thanks.

Paolo

