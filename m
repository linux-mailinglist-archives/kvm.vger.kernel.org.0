Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E9C3058FB
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 11:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236270AbhA0K6Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 05:58:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46100 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236254AbhA0K4P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Jan 2021 05:56:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611744880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=86WV7E6lV+Cr2RhV35tDcglEpjUTrr3fQsjJztebOZY=;
        b=htjK9i6phx9oysmoStRQXwN7hufLAPtkqgjNUxUqnPbfFDi1iaqwHvWmRDRw/JN4z+3Yty
        qd7GoqIvXJFrQEE33mfQuTobocWuQV99HmRM/7MUyTiqnomaUOtu4uNy6Q0cRVX/onbBeX
        RBEiOzO009GF/ptyv3l7/WzNLhX53No=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-UNIKhxWGNZOy40MzZuxhsw-1; Wed, 27 Jan 2021 05:54:38 -0500
X-MC-Unique: UNIKhxWGNZOy40MzZuxhsw-1
Received: by mail-ed1-f69.google.com with SMTP id f12so1132058edq.15
        for <kvm@vger.kernel.org>; Wed, 27 Jan 2021 02:54:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=86WV7E6lV+Cr2RhV35tDcglEpjUTrr3fQsjJztebOZY=;
        b=JzXBwA2LZQ5mcuzgElyOnOzTqSHOnRG8ocAYzkUriqau7fVC87UKaakX5VpKe/T8R1
         7+WpkFElgJ+NaQyF8jwbGGD/cz4nCKvD0mrttE16wvXKEGdijoq90SR1yYWzTWaZ7ebf
         bX0HzXlEjH6qOG3qY02dW4XlH8NYoyyNQ3MSXFE/Xq45Og09NdoiETPA0iO6CwdW+NcB
         JZW86Qgy5e+vgIL5BEh0wjByk99LX27k78j1dzGZ8UNYFPUundtuZOwmOX3aXoLzOEdJ
         fJsA08Gg4oaUsy13xAUuaRt6Z4GByEOZuYpQtM25vVnRH1qlBiQACj0RI9Cdz2aSCWKk
         98Mw==
X-Gm-Message-State: AOAM532zET2fzLne7bUdTi5Fd1ucomnj/RRBntXqMYOAH/7iIgBKJvy6
        XT8T+jQhCKRS4rhJyxNG8CKpFcD+jVPwDjDvIaIDVrWXYcZry2PW+r4dyODzDWsk3h5n7Zx3cIT
        C7nuV1Ow+2Ec9
X-Received: by 2002:a17:906:b082:: with SMTP id x2mr5991226ejy.100.1611744877278;
        Wed, 27 Jan 2021 02:54:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzButKZSAE0oNfPAxP2xn91tk8KEclK6UYubWMNxhMbU8m2nbPyIZgrLIH+IerQL/gdSH2s4w==
X-Received: by 2002:a17:906:b082:: with SMTP id x2mr5991209ejy.100.1611744877070;
        Wed, 27 Jan 2021 02:54:37 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id pj11sm635689ejb.58.2021.01.27.02.54.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 02:54:35 -0800 (PST)
Subject: Re: [PATCH] KVM: x86/mmu: Add '__func__' in rmap_printk()
To:     Stephen Zhang <stephenzhangzsd@gmail.com>, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1611713325-3591-1-git-send-email-stephenzhangzsd@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <244f1c7f-d6ca-bd7c-da5e-8da3bf8b5aee@redhat.com>
Date:   Wed, 27 Jan 2021 11:54:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1611713325-3591-1-git-send-email-stephenzhangzsd@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/01/21 03:08, Stephen Zhang wrote:
> Given the common pattern:
> 
> rmap_printk("%s:"..., __func__,...)
> 
> we could improve this by adding '__func__' in rmap_printk().
> 
> Signed-off-by: Stephen Zhang <stephenzhangzsd@gmail.com>
> ---
>   arch/x86/kvm/mmu/mmu.c          | 20 ++++++++++----------
>   arch/x86/kvm/mmu/mmu_internal.h |  2 +-
>   2 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6d16481..1460705 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -844,17 +844,17 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
>   	int i, count = 0;
>   
>   	if (!rmap_head->val) {
> -		rmap_printk("pte_list_add: %p %llx 0->1\n", spte, *spte);
> +		rmap_printk("%p %llx 0->1\n", spte, *spte);
>   		rmap_head->val = (unsigned long)spte;
>   	} else if (!(rmap_head->val & 1)) {
> -		rmap_printk("pte_list_add: %p %llx 1->many\n", spte, *spte);
> +		rmap_printk("%p %llx 1->many\n", spte, *spte);
>   		desc = mmu_alloc_pte_list_desc(vcpu);
>   		desc->sptes[0] = (u64 *)rmap_head->val;
>   		desc->sptes[1] = spte;
>   		rmap_head->val = (unsigned long)desc | 1;
>   		++count;
>   	} else {
> -		rmap_printk("pte_list_add: %p %llx many->many\n", spte, *spte);
> +		rmap_printk("%p %llx many->many\n", spte, *spte);
>   		desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
>   		while (desc->sptes[PTE_LIST_EXT-1]) {
>   			count += PTE_LIST_EXT;
> @@ -906,14 +906,14 @@ static void __pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
>   		pr_err("%s: %p 0->BUG\n", __func__, spte);
>   		BUG();
>   	} else if (!(rmap_head->val & 1)) {
> -		rmap_printk("%s:  %p 1->0\n", __func__, spte);
> +		rmap_printk("%p 1->0\n", spte);
>   		if ((u64 *)rmap_head->val != spte) {
>   			pr_err("%s:  %p 1->BUG\n", __func__, spte);
>   			BUG();
>   		}
>   		rmap_head->val = 0;
>   	} else {
> -		rmap_printk("%s:  %p many->many\n", __func__, spte);
> +		rmap_printk("%p many->many\n", spte);
>   		desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
>   		prev_desc = NULL;
>   		while (desc) {
> @@ -1115,7 +1115,7 @@ static bool spte_write_protect(u64 *sptep, bool pt_protect)
>   	      !(pt_protect && spte_can_locklessly_be_made_writable(spte)))
>   		return false;
>   
> -	rmap_printk("rmap_write_protect: spte %p %llx\n", sptep, *sptep);
> +	rmap_printk("spte %p %llx\n", sptep, *sptep);
>   
>   	if (pt_protect)
>   		spte &= ~SPTE_MMU_WRITEABLE;
> @@ -1142,7 +1142,7 @@ static bool spte_clear_dirty(u64 *sptep)
>   {
>   	u64 spte = *sptep;
>   
> -	rmap_printk("rmap_clear_dirty: spte %p %llx\n", sptep, *sptep);
> +	rmap_printk("spte %p %llx\n", sptep, *sptep);
>   
>   	MMU_WARN_ON(!spte_ad_enabled(spte));
>   	spte &= ~shadow_dirty_mask;
> @@ -1184,7 +1184,7 @@ static bool spte_set_dirty(u64 *sptep)
>   {
>   	u64 spte = *sptep;
>   
> -	rmap_printk("rmap_set_dirty: spte %p %llx\n", sptep, *sptep);
> +	rmap_printk("spte %p %llx\n", sptep, *sptep);
>   
>   	/*
>   	 * Similar to the !kvm_x86_ops.slot_disable_log_dirty case,
> @@ -1331,7 +1331,7 @@ static bool kvm_zap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head)
>   	bool flush = false;
>   
>   	while ((sptep = rmap_get_first(rmap_head, &iter))) {
> -		rmap_printk("%s: spte %p %llx.\n", __func__, sptep, *sptep);
> +		rmap_printk("spte %p %llx.\n", sptep, *sptep);
>   
>   		pte_list_remove(rmap_head, sptep);
>   		flush = true;
> @@ -1363,7 +1363,7 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
>   
>   restart:
>   	for_each_rmap_spte(rmap_head, &iter, sptep) {
> -		rmap_printk("kvm_set_pte_rmapp: spte %p %llx gfn %llx (%d)\n",
> +		rmap_printk("spte %p %llx gfn %llx (%d)\n",
>   			    sptep, *sptep, gfn, level);
>   
>   		need_flush = 1;
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index bfc6389..5ec15e4 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -12,7 +12,7 @@
>   extern bool dbg;
>   
>   #define pgprintk(x...) do { if (dbg) printk(x); } while (0)
> -#define rmap_printk(x...) do { if (dbg) printk(x); } while (0)
> +#define rmap_printk(fmt, args...) do { if (dbg) printk("%s: " fmt, __func__, ## args); } while (0)
>   #define MMU_WARN_ON(x) WARN_ON(x)
>   #else
>   #define pgprintk(x...) do { } while (0)
> 

Queued, thanks.

Paolo

