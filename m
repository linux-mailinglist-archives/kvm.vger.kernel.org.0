Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29862DA271
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 22:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503481AbgLNVPP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 16:15:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42794 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728461AbgLNVPM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Dec 2020 16:15:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607980425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yBM6GwLsbOpYYOoBdDeKnBBPU0ajqAjEvKlkTZFVb1I=;
        b=IxA4BxzE3lmgLbyoSPnYvYeu8DNHZS+0hJgdEVzLXK6O/F27rPQDJFYBVqAN+BsZIcib9f
        qNlKqD/n3Dy8lJhOVNE5oQIW6E8T26S8wiSPBevu9HF30r43IGl6H/WZ6pdKyOw1Td6oJT
        IWQ+NOjWgAzcXJOnpy5Iau4yykyPKLQ=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-J7cLns8zNh-9WW_Mj_ggnQ-1; Mon, 14 Dec 2020 16:13:43 -0500
X-MC-Unique: J7cLns8zNh-9WW_Mj_ggnQ-1
Received: by mail-ej1-f69.google.com with SMTP id g18so5034008eje.1
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 13:13:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=yBM6GwLsbOpYYOoBdDeKnBBPU0ajqAjEvKlkTZFVb1I=;
        b=QfN1JUWBdiIbQnbQHSHbw1GC5ZGaFEfg9hYk50UYFftgbOaCQ99EcnQFx+aOwZ6GVv
         ubz/fKhkqKVHHvpn/PIpzOVveb7MWNZn0LpyQGRmMNjKkvgLnUTnIDTfj2KyRw7cgVq3
         +LbZ1XyWTIRSMjU8tQ3ebIGKBTtylg8NmzpaNHy49RVBz+nSaNnfSXsbi/suN40d2t/4
         GYUeX6kCj3VnEzXRT2ysueByjonqhnzf6AYYqkd6eqEtYDkd+4XCSinH+zcfbp5q7IVw
         200kZ1ePLznIxf/vk3HVADkWK83fzs4JeHeDP3i8aYQQNdG96plQ5daB96TPWZXZbyxH
         XrqQ==
X-Gm-Message-State: AOAM532s/oAFsl2T1FzHsYa5m5ib8FZdZDsu37b1KmXWSJgbs1fQnzsD
        D2RKMv/F0dwDiruJ6ZyN0w5W0fqGYSxDmrD3fvp19oyIHzdW/xZbrcD6mBTpUnP8v9b6vy1sKE6
        KF2Njxpaiztbh
X-Received: by 2002:a50:d5c1:: with SMTP id g1mr27542229edj.299.1607980422374;
        Mon, 14 Dec 2020 13:13:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwUGsTdEeL5YFkgnOsN5chqPJOJLrHGFiF3T52Fl6g6X4SA6FgVJC4ISaFrBN8wjhc8S2JGyA==
X-Received: by 2002:a50:d5c1:: with SMTP id g1mr27542213edj.299.1607980422202;
        Mon, 14 Dec 2020 13:13:42 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id s12sm16669891edu.28.2020.12.14.13.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 13:13:41 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com
Subject: Re: [PATCH v3 01/17] KVM: Fix arguments to kvm_{un,}map_gfn()
In-Reply-To: <20201214083905.2017260-2-dwmw2@infradead.org>
References: <20201214083905.2017260-1-dwmw2@infradead.org>
 <20201214083905.2017260-2-dwmw2@infradead.org>
Date:   Mon, 14 Dec 2020 22:13:40 +0100
Message-ID: <87ft48w0or.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

David Woodhouse <dwmw2@infradead.org> writes:

> From: David Woodhouse <dwmw@amazon.co.uk>
>
> It shouldn't take a vcpu.
>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>  arch/x86/kvm/x86.c       | 8 ++++----
>  include/linux/kvm_host.h | 4 ++--
>  virt/kvm/kvm_main.c      | 8 ++++----
>  3 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e545a8a613b1..c7f1ba21212e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2957,7 +2957,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
>  		return;
>  
>  	/* -EAGAIN is returned in atomic context so we can just return. */
> -	if (kvm_map_gfn(vcpu, vcpu->arch.st.msr_val >> PAGE_SHIFT,
> +	if (kvm_map_gfn(vcpu->kvm, vcpu->arch.st.msr_val >> PAGE_SHIFT,
>  			&map, &vcpu->arch.st.cache, false))
>  		return;
>  
> @@ -2992,7 +2992,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
>  
>  	st->version += 1;
>  
> -	kvm_unmap_gfn(vcpu, &map, &vcpu->arch.st.cache, true, false);
> +	kvm_unmap_gfn(vcpu->kvm, &map, &vcpu->arch.st.cache, true, false);
>  }
>  
>  int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> @@ -3981,7 +3981,7 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
>  	if (vcpu->arch.st.preempted)
>  		return;
>  
> -	if (kvm_map_gfn(vcpu, vcpu->arch.st.msr_val >> PAGE_SHIFT, &map,
> +	if (kvm_map_gfn(vcpu->kvm, vcpu->arch.st.msr_val >> PAGE_SHIFT, &map,
>  			&vcpu->arch.st.cache, true))
>  		return;
>  
> @@ -3990,7 +3990,7 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
>  
>  	st->preempted = vcpu->arch.st.preempted = KVM_VCPU_PREEMPTED;
>  
> -	kvm_unmap_gfn(vcpu, &map, &vcpu->arch.st.cache, true, true);
> +	kvm_unmap_gfn(vcpu->kvm, &map, &vcpu->arch.st.cache, true, true);
>  }
>  
>  void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 7f2e2a09ebbd..8eb5eb1399f5 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -806,11 +806,11 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
>  kvm_pfn_t kvm_vcpu_gfn_to_pfn_atomic(struct kvm_vcpu *vcpu, gfn_t gfn);
>  kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn);
>  int kvm_vcpu_map(struct kvm_vcpu *vcpu, gpa_t gpa, struct kvm_host_map *map);
> -int kvm_map_gfn(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map,
> +int kvm_map_gfn(struct kvm *kvm, gfn_t gfn, struct kvm_host_map *map,
>  		struct gfn_to_pfn_cache *cache, bool atomic);
>  struct page *kvm_vcpu_gfn_to_page(struct kvm_vcpu *vcpu, gfn_t gfn);
>  void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty);
> -int kvm_unmap_gfn(struct kvm_vcpu *vcpu, struct kvm_host_map *map,
> +int kvm_unmap_gfn(struct kvm *kvm, struct kvm_host_map *map,
>  		  struct gfn_to_pfn_cache *cache, bool dirty, bool atomic);
>  unsigned long kvm_vcpu_gfn_to_hva(struct kvm_vcpu *vcpu, gfn_t gfn);
>  unsigned long kvm_vcpu_gfn_to_hva_prot(struct kvm_vcpu *vcpu, gfn_t gfn, bool *writable);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2541a17ff1c4..f01a8df7806a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2181,10 +2181,10 @@ static int __kvm_map_gfn(struct kvm_memslots *slots, gfn_t gfn,
>  	return 0;
>  }
>  
> -int kvm_map_gfn(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map,
> +int kvm_map_gfn(struct kvm *kvm, gfn_t gfn, struct kvm_host_map *map,
>  		struct gfn_to_pfn_cache *cache, bool atomic)
>  {
> -	return __kvm_map_gfn(kvm_memslots(vcpu->kvm), gfn, map,
> +	return __kvm_map_gfn(kvm_memslots(kvm), gfn, map,
>  			cache, atomic);
>  }
>  EXPORT_SYMBOL_GPL(kvm_map_gfn);
> @@ -2232,10 +2232,10 @@ static void __kvm_unmap_gfn(struct kvm_memory_slot *memslot,
>  	map->page = NULL;
>  }
>  
> -int kvm_unmap_gfn(struct kvm_vcpu *vcpu, struct kvm_host_map *map, 
> +int kvm_unmap_gfn(struct kvm *kvm, struct kvm_host_map *map,
>  		  struct gfn_to_pfn_cache *cache, bool dirty, bool atomic)
>  {
> -	__kvm_unmap_gfn(gfn_to_memslot(vcpu->kvm, map->gfn), map,
> +	__kvm_unmap_gfn(gfn_to_memslot(kvm, map->gfn), map,
>  			cache, dirty, atomic);
>  	return 0;
>  }

What about different address space ids? 

gfn_to_memslot() now calls kvm_memslots() which gives memslots for
address space id = 0 but what if we want something different? Note,
different vCPUs can (in theory) be in different address spaces so we
actually need 'vcpu' and not 'kvm' then.

-- 
Vitaly

