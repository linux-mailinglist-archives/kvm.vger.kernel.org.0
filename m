Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9203A0186
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 21:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236240AbhFHSxg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 14:53:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43813 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235609AbhFHSvb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Jun 2021 14:51:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623178177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LoFPYgnqMyhO0Yj8C3Yvp32ZataCAS/eqdcV2HTCHSE=;
        b=LplkMVyUawg2t4lqg2EKqlIW4dO4taOptgawyURiLQBSB4dA/PA8KmisohjjyuCfaIAoqE
        Wk8xshB6p76Hb7Ews3n7nb8lXmd5Bo35EdGIn5pLUFeRp46znd4hfvLpqSfSciMavNOaiq
        jnV0jFRsk9jhKsXAAdqT9lo2+/XvcA4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-Fz4d2DCTPBe13RDWSo6PAw-1; Tue, 08 Jun 2021 14:49:36 -0400
X-MC-Unique: Fz4d2DCTPBe13RDWSo6PAw-1
Received: by mail-wr1-f70.google.com with SMTP id e11-20020a056000178bb0290119c11bd29eso4917409wrg.2
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 11:49:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LoFPYgnqMyhO0Yj8C3Yvp32ZataCAS/eqdcV2HTCHSE=;
        b=FGynaG7L4uKhTNgJBm9mgfHwgpsvjhp8FgsueU/6k37vsYS3Vp/EErUKjptJr9nQc5
         Oc03JbJtUBTs+t5J9DdjBAi98gvVp4cxg5huIp9CStIpO3/Ucs7b+yp7fk7TIAWiTBob
         vQ6l8Y97ADaYEPC72ZvjRlScHxD66sdl5iHBHl+jmOu93zmqLFfpgXGgByshsvnFQ8xS
         bviIdsuYig4FOE1O+/cKfEMKOzoBmoz83yhf6PbNBjMbAp3R122Aw1F6zJS1RK/g4W6p
         hddcnEUccNypE8IDAJ6ed7ajUIOeMpu0cm2NZtQ3VEN0MHhvO2vkYcft8qzF7Ax8R7PG
         6xMw==
X-Gm-Message-State: AOAM532PtzZ+qxe71s71eMU0PPyJrZrhh5TdNP3EAZqh84o0P7kymw0P
        Wwlfsl1SObAw9R1oXtvjRUqf2xNXau4EIxCSub5ke1zvtXXRC6l0OMtZ9g3uWkQVdIUVG7TTtQz
        7U0qIxOVgC5cs
X-Received: by 2002:a1c:6209:: with SMTP id w9mr23392159wmb.27.1623178174613;
        Tue, 08 Jun 2021 11:49:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw3+TYMvL7MTOdcK65ZOwaAtc1zOMAovr43eMyB3gQg838fgLXHhy2jg/rdZnO7Mz8SKkSkYA==
X-Received: by 2002:a1c:6209:: with SMTP id w9mr23392145wmb.27.1623178174353;
        Tue, 08 Jun 2021 11:49:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y26sm11641365wma.33.2021.06.08.11.49.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 11:49:33 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH V3] x86: Add a test to check effective
 permissions
To:     Lai Jiangshan <jiangshanlai@gmail.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Hou Wenlong <houwenlong.hwl@antgroup.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
References: <6c87d221-8b6c-56a7-e8d1-31ad8a8379e3@linux.alibaba.com>
 <20210605174901.157556-1-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4ea8682d-b602-807e-d7b9-6c8b828ccadf@redhat.com>
Date:   Tue, 8 Jun 2021 20:49:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210605174901.157556-1-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/06/21 19:49, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> Add a test to verify that KVM correctly handles the case where two or
> more non-leaf page table entries point at the same table gfn, but with
> different parent access permissions.
> 
> For example, here is a shared pagetable:
>     pgd[]   pud[]        pmd[]            virtual address pointers
>                       /->pmd1(u--)->pte1(uw-)->page1 <- ptr1 (u--)
>          /->pud1(uw-)--->pmd2(uw-)->pte2(uw-)->page2 <- ptr2 (uw-)
>     pgd-|           (shared pmd[] as above)
>          \->pud2(u--)--->pmd1(u--)->pte1(uw-)->page1 <- ptr3 (u--)
>                       \->pmd2(uw-)->pte2(uw-)->page2 <- ptr4 (u--)
>    pud1 and pud2 point to the same pmd table
> 
> The test is useful when TDP is not enabled.
> 
> Co-Developed-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
>   x86/access.c | 106 ++++++++++++++++++++++++++++++++++++++++++++++++---
>   1 file changed, 100 insertions(+), 6 deletions(-)
> 
> diff --git a/x86/access.c b/x86/access.c
> index 7dc9eb6..0ad677e 100644
> --- a/x86/access.c
> +++ b/x86/access.c
> @@ -60,6 +60,12 @@ enum {
>       AC_PDE_BIT36_BIT,
>       AC_PDE_BIT13_BIT,
>   
> +    /*
> +     *  special test case to DISABLE writable bit on page directory
> +     *  pointer table entry.
> +     */
> +    AC_PDPTE_NO_WRITABLE_BIT,
> +
>       AC_PKU_AD_BIT,
>       AC_PKU_WD_BIT,
>       AC_PKU_PKEY_BIT,
> @@ -97,6 +103,8 @@ enum {
>   #define AC_PDE_BIT36_MASK     (1 << AC_PDE_BIT36_BIT)
>   #define AC_PDE_BIT13_MASK     (1 << AC_PDE_BIT13_BIT)
>   
> +#define AC_PDPTE_NO_WRITABLE_MASK  (1 << AC_PDPTE_NO_WRITABLE_BIT)
> +
>   #define AC_PKU_AD_MASK        (1 << AC_PKU_AD_BIT)
>   #define AC_PKU_WD_MASK        (1 << AC_PKU_WD_BIT)
>   #define AC_PKU_PKEY_MASK      (1 << AC_PKU_PKEY_BIT)
> @@ -130,6 +138,7 @@ const char *ac_names[] = {
>       [AC_PDE_BIT51_BIT] = "pde.51",
>       [AC_PDE_BIT36_BIT] = "pde.36",
>       [AC_PDE_BIT13_BIT] = "pde.13",
> +    [AC_PDPTE_NO_WRITABLE_BIT] = "pdpte.ro",
>       [AC_PKU_AD_BIT] = "pkru.ad",
>       [AC_PKU_WD_BIT] = "pkru.wd",
>       [AC_PKU_PKEY_BIT] = "pkey=1",
> @@ -326,6 +335,7 @@ static pt_element_t ac_test_alloc_pt(ac_pool_t *pool)
>   {
>       pt_element_t ret = pool->pt_pool + pool->pt_pool_current;
>       pool->pt_pool_current += PAGE_SIZE;
> +    memset(va(ret), 0, PAGE_SIZE);
>       return ret;
>   }
>   
> @@ -408,7 +418,7 @@ static void ac_emulate_access(ac_test_t *at, unsigned flags)
>   	goto fault;
>       }
>   
> -    writable = F(AC_PDE_WRITABLE);
> +    writable = !F(AC_PDPTE_NO_WRITABLE) && F(AC_PDE_WRITABLE);
>       user = F(AC_PDE_USER);
>       executable = !F(AC_PDE_NX);
>   
> @@ -471,7 +481,7 @@ static void ac_set_expected_status(ac_test_t *at)
>       ac_emulate_access(at, at->flags);
>   }
>   
> -static void __ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool,
> +static void __ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool, bool reuse,
>   				      u64 pd_page, u64 pt_page)
>   
>   {
> @@ -496,13 +506,29 @@ static void __ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool,
>   	    goto next;
>   	}
>   	skip = false;
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
>   	switch (i) {
>   	case 5:
>   	case 4:
> +	    pte = ac_test_alloc_pt(pool);
> +	    pte |= PT_PRESENT_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
> +	    break;
>   	case 3:
>   	    pte = pd_page ? pd_page : ac_test_alloc_pt(pool);
> -	    pte |= PT_PRESENT_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
> +	    pte |= PT_PRESENT_MASK | PT_USER_MASK;
> +	    if (!F(AC_PDPTE_NO_WRITABLE))
> +		pte |= PT_WRITABLE_MASK;
>   	    break;
>   	case 2:
>   	    if (!F(AC_PDE_PSE)) {
> @@ -568,13 +594,13 @@ static void __ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool,
>   
>   static void ac_test_setup_pte(ac_test_t *at, ac_pool_t *pool)
>   {
> -	__ac_setup_specific_pages(at, pool, 0, 0);
> +	__ac_setup_specific_pages(at, pool, false, 0, 0);
>   }
>   
>   static void ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool,
>   				    u64 pd_page, u64 pt_page)
>   {
> -	return __ac_setup_specific_pages(at, pool, pd_page, pt_page);
> +	return __ac_setup_specific_pages(at, pool, false, pd_page, pt_page);
>   }
>   
>   static void dump_mapping(ac_test_t *at)
> @@ -930,6 +956,73 @@ err:
>   	return 0;
>   }
>   
> +static int check_effective_sp_permissions(ac_pool_t *pool)
> +{
> +	unsigned long ptr1 = 0x123480000000;
> +	unsigned long ptr2 = ptr1 + SZ_2M;
> +	unsigned long ptr3 = ptr1 + SZ_1G;
> +	unsigned long ptr4 = ptr3 + SZ_2M;
> +	pt_element_t pmd = ac_test_alloc_pt(pool);
> +	ac_test_t at1, at2, at3, at4;
> +	int err_read_at1, err_write_at2;
> +	int err_read_at3, err_write_at4;
> +
> +	/*
> +	 * pgd[]   pud[]        pmd[]            virtual address pointers
> +	 *                   /->pmd1(u--)->pte1(uw-)->page1 <- ptr1 (u--)
> +	 *      /->pud1(uw-)--->pmd2(uw-)->pte2(uw-)->page2 <- ptr2 (uw-)
> +	 * pgd-|           (shared pmd[] as above)
> +	 *      \->pud2(u--)--->pmd1(u--)->pte1(uw-)->page1 <- ptr3 (u--)
> +	 *                   \->pmd2(uw-)->pte2(uw-)->page2 <- ptr4 (u--)
> +	 * pud1 and pud2 point to the same pmd page.
> +	 */
> +
> +	ac_test_init(&at1, (void *)(ptr1));
> +	at1.flags = AC_PDE_PRESENT_MASK | AC_PTE_PRESENT_MASK |
> +		    AC_PDE_USER_MASK | AC_PTE_USER_MASK |
> +		    AC_PDE_ACCESSED_MASK | AC_PTE_ACCESSED_MASK |
> +		    AC_PTE_WRITABLE_MASK | AC_ACCESS_USER_MASK;
> +	__ac_setup_specific_pages(&at1, pool, false, pmd, 0);
> +
> +	ac_test_init(&at2, (void *)(ptr2));
> +	at2.flags = at1.flags | AC_PDE_WRITABLE_MASK | AC_PTE_DIRTY_MASK | AC_ACCESS_WRITE_MASK;
> +	__ac_setup_specific_pages(&at2, pool, true, pmd, 0);
> +
> +	ac_test_init(&at3, (void *)(ptr3));
> +	at3.flags = AC_PDPTE_NO_WRITABLE_MASK | at1.flags;
> +	__ac_setup_specific_pages(&at3, pool, true, pmd, 0);
> +
> +	ac_test_init(&at4, (void *)(ptr4));
> +	at4.flags = AC_PDPTE_NO_WRITABLE_MASK | at2.flags;
> +	__ac_setup_specific_pages(&at4, pool, true, pmd, 0);
> +
> +	err_read_at1 = ac_test_do_access(&at1);
> +	if (!err_read_at1) {
> +		printf("%s: read access at1 fail\n", __FUNCTION__);
> +		return 0;
> +	}
> +
> +	err_write_at2 = ac_test_do_access(&at2);
> +	if (!err_write_at2) {
> +		printf("%s: write access at2 fail\n", __FUNCTION__);
> +		return 0;
> +	}
> +
> +	err_read_at3 = ac_test_do_access(&at3);
> +	if (!err_read_at3) {
> +		printf("%s: read access at3 fail\n", __FUNCTION__);
> +		return 0;
> +	}
> +
> +	err_write_at4 = ac_test_do_access(&at4);
> +	if (!err_write_at4) {
> +		printf("%s: write access at4 should fail\n", __FUNCTION__);
> +		return 0;
> +	}
> +
> +	return 1;
> +}
> +
>   static int ac_test_exec(ac_test_t *at, ac_pool_t *pool)
>   {
>       int r;
> @@ -948,7 +1041,8 @@ const ac_test_fn ac_test_cases[] =
>   	corrupt_hugepage_triger,
>   	check_pfec_on_prefetch_pte,
>   	check_large_pte_dirty_for_nowp,
> -	check_smep_andnot_wp
> +	check_smep_andnot_wp,
> +	check_effective_sp_permissions,
>   };
>   
>   static int ac_test_run(void)
> 

Applied, thanks.

Paolo

