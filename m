Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA6730C524
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 17:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236017AbhBBQNr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 11:13:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44579 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232632AbhBBQJG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 11:09:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612282058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TKrochvWmjZ6rIvzco/HQHkVox8nJ/FnR3zhsXxEX18=;
        b=OT7q5LrfP/dfp0H8tklJG64XPU2gvOUfAERm5ZnwLkVYmGdElD8z1SOz5nQg3dlcbHktjP
        Y845m42yIyOXt43M+iAyZe/YvnDWUCblDUkK5kXyuw7yjgTQDQgRU/zkt65+uAuNcHyMDC
        p+hO7FNu9gWWNnGjK4c1/AoCIHCNYy4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-dR1W9C5HMKe8gVH_eQcA8g-1; Tue, 02 Feb 2021 11:07:37 -0500
X-MC-Unique: dR1W9C5HMKe8gVH_eQcA8g-1
Received: by mail-ed1-f69.google.com with SMTP id o8so9868795edh.12
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 08:07:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TKrochvWmjZ6rIvzco/HQHkVox8nJ/FnR3zhsXxEX18=;
        b=TfiAzaVX7+Vxl7KcaZ5AR801ppGIH288AKkO6uuCoc6CwKIYRg8szX1e4WOzDT54sX
         5QHNjgT4rARIGLpBatasHdIeHoHca7Tc/vsQ/Q22DtxAz/6pMh/VpiHeSDbJxg3p4g4X
         kqTjtpEhwiX7qtlx+6M4W9p6OkgOXFM+MxSN3S1nb6OiacIudztcE3Rk1Mn3U7IF/0cy
         yx6kS/xEsZsqc7akeupCMXpOBTA5YA2IxJXX60mjAVFJKd2Zz+3Y4RnpYrtdufd6vCx8
         o55TOD3edxGKbHYZ8SLYhHXPoH2G26XG0ZCgeyZejX0Z4SeGfs0OdL2XvhcvLHDfxVFK
         OfZA==
X-Gm-Message-State: AOAM5306o0JofTH3/PrR3aW31WpLm5YJK1RvSMqx9QwzmqitL+gA0TIT
        jLjI2JzKIDIiwlBpe0R0TTLpNFW0pwYxbyV9jEbps5SftuzgguKQ+XStYcC0P/5Q57zmpUuWZ+s
        gxvTsI7unhixX
X-Received: by 2002:aa7:de19:: with SMTP id h25mr12614160edv.145.1612282055545;
        Tue, 02 Feb 2021 08:07:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwmKNtCbw04IK1LzXTmzVDUQ+j2/FOvokrLiCZYTtMe8QxwX5OjrcIT42yfEsZd7k/LwwTF1A==
X-Received: by 2002:aa7:de19:: with SMTP id h25mr12614130edv.145.1612282055202;
        Tue, 02 Feb 2021 08:07:35 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a6sm4083163ejs.79.2021.02.02.08.07.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 08:07:34 -0800 (PST)
Subject: Re: [PATCH] KVM: x86/mmu: Add '__func__' in rmap_printk()
To:     Joe Perches <joe@perches.com>,
        Stephen Zhang <stephenzhangzsd@gmail.com>, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1611713325-3591-1-git-send-email-stephenzhangzsd@gmail.com>
 <244f1c7f-d6ca-bd7c-da5e-8da3bf8b5aee@redhat.com>
 <cfb3699fc03cff1e4c4ffe3c552dba7b7727fa09.camel@perches.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0e85dafc-1f2b-043c-f589-a32dcb4b7dca@redhat.com>
Date:   Tue, 2 Feb 2021 17:07:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <cfb3699fc03cff1e4c4ffe3c552dba7b7727fa09.camel@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/01/21 18:25, Joe Perches wrote:
> On Wed, 2021-01-27 at 11:54 +0100, Paolo Bonzini wrote:
>> On 27/01/21 03:08, Stephen Zhang wrote:
>>> Given the common pattern:
>>>
>>> rmap_printk("%s:"..., __func__,...)
>>>
>>> we could improve this by adding '__func__' in rmap_printk().
> 
> Currently, the MMU_DEBUG control is not defined so this isn't used.
> 
> Another improvement would be to remove the macro altogether and
> rename the uses to the more standard style using pr_debug.
> 
> arch/x86/kvm/mmu/mmu_internal.h-#undef MMU_DEBUG
> arch/x86/kvm/mmu/mmu_internal.h-
> arch/x86/kvm/mmu/mmu_internal.h-#ifdef MMU_DEBUG
> arch/x86/kvm/mmu/mmu_internal.h-extern bool dbg;
> arch/x86/kvm/mmu/mmu_internal.h-
> arch/x86/kvm/mmu/mmu_internal.h-#define pgprintk(x...) do { if (dbg) printk(x); } while (0)
> arch/x86/kvm/mmu/mmu_internal.h:#define rmap_printk(x...) do { if (dbg) printk(x); } while (0)
> arch/x86/kvm/mmu/mmu_internal.h-#define MMU_WARN_ON(x) WARN_ON(x)
> arch/x86/kvm/mmu/mmu_internal.h-#else
> arch/x86/kvm/mmu/mmu_internal.h-#define pgprintk(x...) do { } while (0)
> arch/x86/kvm/mmu/mmu_internal.h:#define rmap_printk(x...) do { } while (0)
> arch/x86/kvm/mmu/mmu_internal.h-#define MMU_WARN_ON(x) do { } while (0)
> arch/x86/kvm/mmu/mmu_internal.h-#endif
> arch/x86/kvm/mmu/mmu_internal.h-
> 
> Also this define hasn't been set in quite awhile as there are
> format/argument mismatches in the code that use gpa_t that need
> to be converted from %lx to %llx with a cast to (u64)
> 
> So I think this would be better as:

Joe, would you mind sending this out as a full patch with Signed-off-by?

Thanks,

Paolo

> ---
>   arch/x86/kvm/mmu/mmu.c          | 47 ++++++++++++++++++-----------------------
>   arch/x86/kvm/mmu/mmu_internal.h | 10 +--------
>   arch/x86/kvm/mmu/paging_tmpl.h  | 10 ++++-----
>   arch/x86/kvm/mmu/spte.c         |  4 ++--
>   4 files changed, 28 insertions(+), 43 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6d16481aa29d..54987bd64647 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -105,11 +105,6 @@ enum {
>   	AUDIT_POST_SYNC
>   };
>   
> -#ifdef MMU_DEBUG
> -bool dbg = 0;
> -module_param(dbg, bool, 0644);
> -#endif
> -
>   #define PTE_PREFETCH_NUM		8
>   
>   #define PT32_LEVEL_BITS 10
> @@ -844,17 +839,17 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
>   	int i, count = 0;
>   
>   	if (!rmap_head->val) {
> -		rmap_printk("pte_list_add: %p %llx 0->1\n", spte, *spte);
> +		pr_debug("%p %llx 0->1\n", spte, *spte);
>   		rmap_head->val = (unsigned long)spte;
>   	} else if (!(rmap_head->val & 1)) {
> -		rmap_printk("pte_list_add: %p %llx 1->many\n", spte, *spte);
> +		pr_debug("%p %llx 1->many\n", spte, *spte);
>   		desc = mmu_alloc_pte_list_desc(vcpu);
>   		desc->sptes[0] = (u64 *)rmap_head->val;
>   		desc->sptes[1] = spte;
>   		rmap_head->val = (unsigned long)desc | 1;
>   		++count;
>   	} else {
> -		rmap_printk("pte_list_add: %p %llx many->many\n", spte, *spte);
> +		pr_debug("%p %llx many->many\n", spte, *spte);
>   		desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
>   		while (desc->sptes[PTE_LIST_EXT-1]) {
>   			count += PTE_LIST_EXT;
> @@ -906,14 +901,14 @@ static void __pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
>   		pr_err("%s: %p 0->BUG\n", __func__, spte);
>   		BUG();
>   	} else if (!(rmap_head->val & 1)) {
> -		rmap_printk("%s:  %p 1->0\n", __func__, spte);
> +		pr_debug("%p 1->0\n", spte);
>   		if ((u64 *)rmap_head->val != spte) {
>   			pr_err("%s:  %p 1->BUG\n", __func__, spte);
>   			BUG();
>   		}
>   		rmap_head->val = 0;
>   	} else {
> -		rmap_printk("%s:  %p many->many\n", __func__, spte);
> +		pr_debug("%p many->many\n", spte);
>   		desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
>   		prev_desc = NULL;
>   		while (desc) {
> @@ -1115,7 +1110,7 @@ static bool spte_write_protect(u64 *sptep, bool pt_protect)
>   	      !(pt_protect && spte_can_locklessly_be_made_writable(spte)))
>   		return false;
>   
> -	rmap_printk("rmap_write_protect: spte %p %llx\n", sptep, *sptep);
> +	pr_debug("spte %p %llx\n", sptep, *sptep);
>   
>   	if (pt_protect)
>   		spte &= ~SPTE_MMU_WRITEABLE;
> @@ -1142,7 +1137,7 @@ static bool spte_clear_dirty(u64 *sptep)
>   {
>   	u64 spte = *sptep;
>   
> -	rmap_printk("rmap_clear_dirty: spte %p %llx\n", sptep, *sptep);
> +	pr_debug("spte %p %llx\n", sptep, *sptep);
>   
>   	MMU_WARN_ON(!spte_ad_enabled(spte));
>   	spte &= ~shadow_dirty_mask;
> @@ -1184,7 +1179,7 @@ static bool spte_set_dirty(u64 *sptep)
>   {
>   	u64 spte = *sptep;
>   
> -	rmap_printk("rmap_set_dirty: spte %p %llx\n", sptep, *sptep);
> +	pr_debug("spte %p %llx\n", sptep, *sptep);
>   
>   	/*
>   	 * Similar to the !kvm_x86_ops.slot_disable_log_dirty case,
> @@ -1331,7 +1326,7 @@ static bool kvm_zap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head)
>   	bool flush = false;
>   
>   	while ((sptep = rmap_get_first(rmap_head, &iter))) {
> -		rmap_printk("%s: spte %p %llx.\n", __func__, sptep, *sptep);
> +		pr_debug("spte %p %llx.\n", sptep, *sptep);
>   
>   		pte_list_remove(rmap_head, sptep);
>   		flush = true;
> @@ -1363,8 +1358,8 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
>   
>   restart:
>   	for_each_rmap_spte(rmap_head, &iter, sptep) {
> -		rmap_printk("kvm_set_pte_rmapp: spte %p %llx gfn %llx (%d)\n",
> -			    sptep, *sptep, gfn, level);
> +		pr_debug("spte %p %llx gfn %llx (%d)\n",
> +			 sptep, *sptep, gfn, level);
>   
>   		need_flush = 1;
>   
> @@ -1605,7 +1600,7 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
>   	return young;
>   }
>   
> -#ifdef MMU_DEBUG
> +#ifdef DEBUG
>   static int is_empty_shadow_page(u64 *spt)
>   {
>   	u64 *pos;
> @@ -2490,12 +2485,11 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
>   	LIST_HEAD(invalid_list);
>   	int r;
>   
> -	pgprintk("%s: looking for gfn %llx\n", __func__, gfn);
> +	pr_debug("looking for gfn %llx\n", gfn);
>   	r = 0;
>   	spin_lock(&kvm->mmu_lock);
>   	for_each_gfn_indirect_valid_sp(kvm, sp, gfn) {
> -		pgprintk("%s: gfn %llx role %x\n", __func__, gfn,
> -			 sp->role.word);
> +		pr_debug("gfn %llx role %x\n", gfn, sp->role.word);
>   		r = 1;
>   		kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
>   	}
> @@ -2614,7 +2608,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>   	int ret = RET_PF_FIXED;
>   	bool flush = false;
>   
> -	pgprintk("%s: spte %llx write_fault %d gfn %llx\n", __func__,
> +	pr_debug("spte %llx write_fault %d gfn %llx\n",
>   		 *sptep, write_fault, gfn);
>   
>   	if (is_shadow_present_pte(*sptep)) {
> @@ -2630,7 +2624,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>   			drop_parent_pte(child, sptep);
>   			flush = true;
>   		} else if (pfn != spte_to_pfn(*sptep)) {
> -			pgprintk("hfn old %llx new %llx\n",
> +			pr_debug("hfn old %llx new %llx\n",
>   				 spte_to_pfn(*sptep), pfn);
>   			drop_spte(vcpu->kvm, sptep);
>   			flush = true;
> @@ -2662,7 +2656,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>   		return RET_PF_SPURIOUS;
>   	}
>   
> -	pgprintk("%s: setting spte %llx\n", __func__, *sptep);
> +	pr_debug("setting spte %llx\n", *sptep);
>   	trace_kvm_mmu_set_spte(level, gfn, sptep);
>   	if (!was_rmapped && is_large_pte(*sptep))
>   		++vcpu->kvm->stat.lpages;
> @@ -3747,7 +3741,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>   static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa,
>   				u32 error_code, bool prefault)
>   {
> -	pgprintk("%s: gva %lx error %x\n", __func__, gpa, error_code);
> +	pr_debug("gva %llx error %x\n", (u64)gpa, error_code);
>   
>   	/* This path builds a PAE pagetable, we can map 2mb pages at maximum. */
>   	return direct_page_fault(vcpu, gpa & PAGE_MASK, error_code, prefault,
> @@ -4904,8 +4898,7 @@ static bool detect_write_misaligned(struct kvm_mmu_page *sp, gpa_t gpa,
>   {
>   	unsigned offset, pte_size, misaligned;
>   
> -	pgprintk("misaligned: gpa %llx bytes %d role %x\n",
> -		 gpa, bytes, sp->role.word);
> +	pr_debug("gpa %llx bytes %d role %x\n", gpa, bytes, sp->role.word);
>   
>   	offset = offset_in_page(gpa);
>   	pte_size = sp->role.gpte_is_8_bytes ? 8 : 4;
> @@ -4990,7 +4983,7 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
>   
>   	remote_flush = local_flush = false;
>   
> -	pgprintk("%s: gpa %llx bytes %d\n", __func__, gpa, bytes);
> +	pr_debug("gpa %llx bytes %d\n", gpa, bytes);
>   
>   	/*
>   	 * No need to care whether allocation memory is successful
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index bfc6389edc28..095bdef63a03 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -6,17 +6,9 @@
>   #include <linux/kvm_host.h>
>   #include <asm/kvm_host.h>
>   
> -#undef MMU_DEBUG
> -
> -#ifdef MMU_DEBUG
> -extern bool dbg;
> -
> -#define pgprintk(x...) do { if (dbg) printk(x); } while (0)
> -#define rmap_printk(x...) do { if (dbg) printk(x); } while (0)
> +#ifdef DEBUG
>   #define MMU_WARN_ON(x) WARN_ON(x)
>   #else
> -#define pgprintk(x...) do { } while (0)
> -#define rmap_printk(x...) do { } while (0)
>   #define MMU_WARN_ON(x) do { } while (0)
>   #endif
>   
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 50e268eb8e1a..ecbb4e469c1e 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -462,8 +462,8 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>   			goto retry_walk;
>   	}
>   
> -	pgprintk("%s: pte %llx pte_access %x pt_access %x\n",
> -		 __func__, (u64)pte, walker->pte_access, walker->pt_access);
> +	pr_debug("pte %llx pte_access %x pt_access %x\n",
> +		 (u64)pte, walker->pte_access, walker->pt_access);
>   	return 1;
>   
>   error:
> @@ -536,7 +536,7 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>   	if (FNAME(prefetch_invalid_gpte)(vcpu, sp, spte, gpte))
>   		return false;
>   
> -	pgprintk("%s: gpte %llx spte %p\n", __func__, (u64)gpte, spte);
> +	pr_debug("gpte %llx spte %p\n", (u64)gpte, spte);
>   
>   	gfn = gpte_to_gfn(gpte);
>   	pte_access = sp->role.access & FNAME(gpte_access)(gpte);
> @@ -794,7 +794,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
>   	bool map_writable, is_self_change_mapping;
>   	int max_level;
>   
> -	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
> +	pr_debug("addr %llx err %x\n", (u64)addr, error_code);
>   
>   	/*
>   	 * If PFEC.RSVD is set, this is a shadow page fault.
> @@ -811,7 +811,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
>   	 * The page is not mapped by the guest.  Let the guest handle it.
>   	 */
>   	if (!r) {
> -		pgprintk("%s: guest page fault\n", __func__);
> +		pr_debug("guest page fault\n");
>   		if (!prefault)
>   			kvm_inject_emulated_page_fault(vcpu, &walker.fault);
>   
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index c51ad544f25b..23adcb93f6cc 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -146,8 +146,8 @@ int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
>   			goto out;
>   
>   		if (mmu_need_write_protect(vcpu, gfn, can_unsync)) {
> -			pgprintk("%s: found shadow page for %llx, marking ro\n",
> -				 __func__, gfn);
> +			pr_debug("found shadow page for %llx, marking ro\n",
> +				 gfn);
>   			ret |= SET_SPTE_WRITE_PROTECTED_PT;
>   			pte_access &= ~ACC_WRITE_MASK;
>   			spte &= ~(PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE);
> 

