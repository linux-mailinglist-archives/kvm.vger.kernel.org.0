Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C04139AA31
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 20:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhFCSl2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 14:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFCSl1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 14:41:27 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F3CC06174A
        for <kvm@vger.kernel.org>; Thu,  3 Jun 2021 11:39:30 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id l23-20020a17090a0717b029016ae774f973so3777205pjl.1
        for <kvm@vger.kernel.org>; Thu, 03 Jun 2021 11:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=G1RdXss9gIKUo2p6Za1cqFOjPkitJ5C8gIseJUxnP+E=;
        b=LDCp2GtwYEyBVq5SBnSd/F9Y094QBr7Zd77ImJQeeDAsWmSqzqmAqqGK4LfM/K774+
         XJZmnbx9YHUapr8jogIRcK4tFfGWvRWFPR9EufaUXaFGDtgho3NTAeszD8o9FsYadE2E
         oFitDmMUAeVfUst0Ax/VCJJ/X2/sylzO5KuXf6d9Tm2Ym/AaY9249ATEc9tpuSlSHxlM
         L0zz5AkagCAnsvDDyOyOVrXvxlIhUzAj2VDhfNptxbn9l8WjQFBPFlMZH8v9rVLpfY4S
         iyCktEzgzFTj1TfF3qiDZSvJzNhTxE0G6xALKlKPvJgiJCD0eNc9rpAsJpvhmfhALTu7
         KAjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=G1RdXss9gIKUo2p6Za1cqFOjPkitJ5C8gIseJUxnP+E=;
        b=nh3nxujFLsI9T/QTWqR6WtwlRXlrzYyf+0oOPLtuwtbHHdBe73YUej4P2l8x24DHdk
         burttWCTzPIbpRKEMVohGhaYsVy+Nbg211VWNbCA/2UeBG0ISrcCesQqb8FkPBKY7L89
         VKpX89RIIwL+QXCCBjQPFA6GkmIbPNnZdQn/aAbVyoQi5erAMuTezljX29N40tZ+tl+2
         5cJK0N5hyniiABOkIfuc1eJqVlrfKa5nahaZ0iCELLeOYbvZjSjXidP6MSbda0DwOBmZ
         3ID5+76disG1KUBTzbZlXd9NSBHTB5Aygw8/Wycs81JcxbaUaXfCC7reIHA1FH5/HXe5
         m6RQ==
X-Gm-Message-State: AOAM533wv6aAOs9uUKQ6GrFReK40FKJ2LGgRWFookVP7VUClf677DtgJ
        tVuBeLRtlmA6xsJh5/SWLP/ivg==
X-Google-Smtp-Source: ABdhPJwFvjGj+P7qpvo0esBmOMIZI5qE35WwfYBbVtQvgEaTSPGPA1h0F3jcrDZ69+bLBGm5aFzcqw==
X-Received: by 2002:a17:902:bcc3:b029:ed:4637:fb2f with SMTP id o3-20020a170902bcc3b02900ed4637fb2fmr463929pls.72.1622745570091;
        Thu, 03 Jun 2021 11:39:30 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id j5sm2815786pfj.185.2021.06.03.11.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 11:39:29 -0700 (PDT)
Date:   Thu, 3 Jun 2021 18:39:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Hou Wenlong <houwenlong.hwl@antgroup.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Subject: Re: [kvm-unit-tests PATCH] x86: test combined access
Message-ID: <YLkh3bQ106M9nV3k@google.com>
References: <20210603050537.19605-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603050537.19605-1-jiangshanlai@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 03, 2021, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> Check combined access when guest shares pagetables.

Can we avoid "combined"?  Purely because of Intel using "combined" to refer to
the full IA32+EPT translation.  It'd also be helpful to provide a bit more
detail.  E.g. 

  Add a test to verify that KVM correctly handles the case where two or more
  non-leaf page table entries point at the same table gfn, but with different
  parent access permissions.

> For example, here is a shared pagetable:
>    pgd[]   pud[]        pmd[]            virtual address pointers
>                      /->pmd1(u--)->pte1(uw-)->page1 <- ptr1 (u--)
>         /->pud1(uw-)--->pmd2(uw-)->pte2(uw-)->page2 <- ptr2 (uw-)
>    pgd-|           (shared pmd[] as above)
>         \->pud2(u--)--->pmd1(u--)->pte1(uw-)->page1 <- ptr3 (u--)
>                      \->pmd2(uw-)->pte2(uw-)->page2 <- ptr4 (u--)
>   pud1 and pud2 point to the same pmd table
> 
> The test is usefull when TDP is not enabled.
              ^^^^^^^
	      useful

> Co-Developed-by: Hou Wenlong <houwenlong.hwl@antgroup.com>

Co-developed-by, and this needs Hou Wenlong's SoB as well.

> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
>  x86/access.c | 99 ++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 93 insertions(+), 6 deletions(-)
> 
> diff --git a/x86/access.c b/x86/access.c
> index 7dc9eb6..6dbe6e5 100644
> --- a/x86/access.c
> +++ b/x86/access.c
> @@ -60,6 +60,8 @@ enum {
>      AC_PDE_BIT36_BIT,
>      AC_PDE_BIT13_BIT,
>  
> +    AC_PUDE_NO_WRITABLE_BIT, // special test case to disable write bit on PUD entry

Part of me thinks we should use AC_PDPTE_WRITABLE_BIT to be consistent with the
PDE and PTE bits, but I think I agree that special casing this one-off tests is
cleaner overall.

For better or worse, this test uses x86 legacy paging terminology for the entry
bits, not Linux's generic PTE/PMD/PUD/PGD.  I.e. for consistency, I think it
makes sense to use AC_PDPTE_NO_WRITABLE_BIT.

This new bit also needs an entry in ac_names[], otherwise it'll print garbage on
failure.  I'm thinking:

@@ -134,6 +134,7 @@ const char *ac_names[] = {
     [AC_PDE_BIT51_BIT] = "pde.51",
     [AC_PDE_BIT36_BIT] = "pde.36",
     [AC_PDE_BIT13_BIT] = "pde.13",
+    [AC_PDPTE_NO_WRITABLE_BIT] = "pdpte.ro",
     [AC_PKU_AD_BIT] = "pkru.ad",
     [AC_PKU_WD_BIT] = "pkru.wd",
     [AC_PKU_PKEY_BIT] = "pkey=1",


> +
>      AC_PKU_AD_BIT,
>      AC_PKU_WD_BIT,
>      AC_PKU_PKEY_BIT,
> @@ -97,6 +99,8 @@ enum {
>  #define AC_PDE_BIT36_MASK     (1 << AC_PDE_BIT36_BIT)
>  #define AC_PDE_BIT13_MASK     (1 << AC_PDE_BIT13_BIT)
>  
> +#define AC_PUDE_NO_WRITABLE_MASK  (1 << AC_PUDE_NO_WRITABLE_BIT)
> +
>  #define AC_PKU_AD_MASK        (1 << AC_PKU_AD_BIT)
>  #define AC_PKU_WD_MASK        (1 << AC_PKU_WD_BIT)
>  #define AC_PKU_PKEY_MASK      (1 << AC_PKU_PKEY_BIT)
> @@ -326,6 +330,7 @@ static pt_element_t ac_test_alloc_pt(ac_pool_t *pool)
>  {
>      pt_element_t ret = pool->pt_pool + pool->pt_pool_current;
>      pool->pt_pool_current += PAGE_SIZE;
> +    memset(va(ret), 0, PAGE_SIZE);
>      return ret;
>  }
>  
> @@ -408,7 +413,8 @@ static void ac_emulate_access(ac_test_t *at, unsigned flags)
>  	goto fault;
>      }
>  
> -    writable = F(AC_PDE_WRITABLE);
> +    writable = !F(AC_PUDE_NO_WRITABLE);
> +    writable &= F(AC_PDE_WRITABLE);

These can be combined, e.g.

       writable = !F(AC_PDPTE_NO_WRITABLE) && F(AC_PDE_WRITABLE);

>      user = F(AC_PDE_USER);
>      executable = !F(AC_PDE_NX);
>  
> @@ -471,7 +477,7 @@ static void ac_set_expected_status(ac_test_t *at)
>      ac_emulate_access(at, at->flags);
>  }
>  
> -static void __ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool,
> +static void __ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool, bool reuse,
>  				      u64 pd_page, u64 pt_page)
>  
>  {
> @@ -496,13 +502,26 @@ static void __ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool,
>  	    goto next;
>  	}
>  	skip = false;
> +	if (reuse && vroot[index]) {
> +	    switch (i) {
> +	    case 2:
> +		at->pdep = &vroot[index];
> +		break;
> +	    case 1:
> +		at->ptep = &vroot[index];
> +		break;
> +	    }
> +	    goto next;
> +	}
>  
>  	switch (i) {
>  	case 5:
>  	case 4:
>  	case 3:
> -	    pte = pd_page ? pd_page : ac_test_alloc_pt(pool);
> +	    pte = (i==3 && pd_page) ? pd_page : ac_test_alloc_pt(pool);
>  	    pte |= PT_PRESENT_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
> +	    if (F(AC_PUDE_NO_WRITABLE))
> +		pte &= ~PT_WRITABLE_MASK

This will seemingly clear the WRITABLE bit for PML4 and PML5, but due to reuse
behavior, that may not be reflected in the actual page tables depending on
whether or not the first test clears the writable bit.

For robustness and clarity, I think it'd be better to do:

        case 5:
        case 4:
            pte = ac_test_alloc_pt(pool);
            pte |= PT_PRESENT_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
            break;
        case 3:
            pte = pd_page ? pd_page : ac_test_alloc_pt(pool);
            pte |= PT_PRESENT_MASK | PT_USER_MASK;
            if (!F(AC_PDPTE_NO_WRITABLE))
                pte |= PT_WRITABLE_MASK;
            break;

>  	case 2:
>  	    if (!F(AC_PDE_PSE)) {
> @@ -568,13 +587,13 @@ static void __ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool,
>  
>  static void ac_test_setup_pte(ac_test_t *at, ac_pool_t *pool)
>  {
> -	__ac_setup_specific_pages(at, pool, 0, 0);
> +	__ac_setup_specific_pages(at, pool, false, 0, 0);
>  }
>  
>  static void ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool,
>  				    u64 pd_page, u64 pt_page)
>  {
> -	return __ac_setup_specific_pages(at, pool, pd_page, pt_page);
> +	return __ac_setup_specific_pages(at, pool, false, pd_page, pt_page);
>  }
>  
>  static void dump_mapping(ac_test_t *at)
> @@ -930,6 +949,73 @@ err:
>  	return 0;
>  }
>  
> +static int check_combined_protection(ac_pool_t *pool)

To avoid the "combined" verbiage, how about check_effective_sp_permissions()?

