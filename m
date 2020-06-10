Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2172A1F5E14
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 00:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgFJWDt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 18:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbgFJWDr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 18:03:47 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806B4C08C5C2
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 15:03:47 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id k13so2220246vsm.13
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 15:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vDWPbvyM3cqJd2ORoD0SPltk6IcPQq+mA/Xeq0EsR5Q=;
        b=HtBemui3S+wlJlJDJ02Q481rDHDfxLfLvNajFyxAV+3MgJgw3oMaW3w+9xkzOJHdOU
         OzI3lyiSjv6lYHSB6aO+fOX8oTLV1e+4dTEvg0Bb3jYIltK/8hP7WE2rTFWFLo0BKv+g
         jChlOJLa2VmIeGOlncQkZ+6vIdpbi3ZVjs/+gIMU9m/V7BQmRgkLIDPlHOBzNvHwA7He
         z3s054JQpPVmd5YxEVf2WtDoip/eqp+jrUiBedV1cRI0/JEKwBwm9TwQyKRXySbhpoEO
         8JOOuQ6iXe4IMpPwP/km8+5+pozfjgb/vmU+yBmORAc7J+MYPgsGqfxUKYCncbmW1xJc
         d1nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vDWPbvyM3cqJd2ORoD0SPltk6IcPQq+mA/Xeq0EsR5Q=;
        b=C9TwzYR6/q5VawBYxH7CnztbmGU72TyMfpACpqVicqVQf27R/S/OzrkGLE0Xom/Owl
         VA6xTOooGJjqpvhwT/RFfe6QGNREfL+JRHHMIbZXwb8DMHhuIYTn0T/XLK3e/PZiBsiU
         qTRQ9Cl0vLJZBLMOZIgt8pdKj6iMww4fLMjzmRCDTZI/Zo2mBloL1vBMA18ouGIoBqOC
         BOmEInZ96/IYmQxf11FuaUaCRXJnbrLh0X/X89/YyVnVj6q+cieQVTrk77KwIp/rII7W
         XzuRKWRBoq03UNF5WdD41JJ46WNw6Y7zm+mpAxWoOQz3xcF5XvbmFIWcyYi4JZbqOeaf
         ZSyA==
X-Gm-Message-State: AOAM531hzyhikz23Q2xe5mNK9qkG7XTafewhQ+YNCJgmWv+0NHxfxAVs
        PNbTnchvUEmx1wpY430nvSi5E/9LZjDgcfe0tW32hQ==
X-Google-Smtp-Source: ABdhPJzQqRq1kSgZfPTBAuvGye9mC+iq+87t5Ox/WTN7eShxqXFGWQvbS00c/EdH8V5E91+Dg9ynPn922dWRj734K9w=
X-Received: by 2002:a67:70c3:: with SMTP id l186mr4267734vsc.117.1591826626254;
 Wed, 10 Jun 2020 15:03:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com> <20200605213853.14959-4-sean.j.christopherson@intel.com>
In-Reply-To: <20200605213853.14959-4-sean.j.christopherson@intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 10 Jun 2020 15:03:35 -0700
Message-ID: <CANgfPd9tOLb2ipbm9-zyo0G4Onh6LqmYq1rg9o93k90DoMsx2A@mail.gmail.com>
Subject: Re: [PATCH 03/21] KVM: x86/mmu: Use consistent "mc" name for
 kvm_mmu_memory_cache locals
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Marc Zyngier <maz@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Christoffer Dall <christoffer.dall@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 5, 2020 at 2:39 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Use "mc" for local variables to shorten line lengths and provide
> consistent names, which will be especially helpful when some of the
> helpers are moved to common KVM code in future patches.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index cbc101663a89..36c90f004ef4 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1060,27 +1060,27 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
>         local_irq_enable();
>  }
>
> -static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache, int min)
> +static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
>  {
>         void *obj;
>
> -       if (cache->nobjs >= min)
> +       if (mc->nobjs >= min)
>                 return 0;
> -       while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
> -               if (cache->kmem_cache)
> -                       obj = kmem_cache_zalloc(cache->kmem_cache, GFP_KERNEL_ACCOUNT);
> +       while (mc->nobjs < ARRAY_SIZE(mc->objects)) {
> +               if (mc->kmem_cache)
> +                       obj = kmem_cache_zalloc(mc->kmem_cache, GFP_KERNEL_ACCOUNT);
>                 else
>                         obj = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
>                 if (!obj)
> -                       return cache->nobjs >= min ? 0 : -ENOMEM;
> -               cache->objects[cache->nobjs++] = obj;
> +                       return mc->nobjs >= min ? 0 : -ENOMEM;
> +               mc->objects[mc->nobjs++] = obj;
>         }
>         return 0;
>  }
>
> -static int mmu_memory_cache_free_objects(struct kvm_mmu_memory_cache *cache)
> +static int mmu_memory_cache_free_objects(struct kvm_mmu_memory_cache *mc)
>  {
> -       return cache->nobjs;
> +       return mc->nobjs;
>  }
>
>  static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
> @@ -1395,10 +1395,10 @@ static struct kvm_rmap_head *gfn_to_rmap(struct kvm *kvm, gfn_t gfn,
>
>  static bool rmap_can_add(struct kvm_vcpu *vcpu)
>  {
> -       struct kvm_mmu_memory_cache *cache;
> +       struct kvm_mmu_memory_cache *mc;
>
> -       cache = &vcpu->arch.mmu_pte_list_desc_cache;
> -       return mmu_memory_cache_free_objects(cache);
> +       mc = &vcpu->arch.mmu_pte_list_desc_cache;
> +       return mmu_memory_cache_free_objects(mc);
>  }
>
>  static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
> --
> 2.26.0
>
