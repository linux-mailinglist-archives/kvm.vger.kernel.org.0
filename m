Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF921F14C8
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 10:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729116AbgFHI4q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 04:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgFHI4p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 04:56:45 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34462C08C5C3;
        Mon,  8 Jun 2020 01:56:45 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id o5so17680202iow.8;
        Mon, 08 Jun 2020 01:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DxNt0eIwm9p9g/mQmVwYWK8COQJtmgwTgesczuWioPg=;
        b=UhoDqW1r+NKy9FmTgwkOvep3I+dcHP4n4QbazpDBw5ENhBd5iDewyg+kEYSpd//7qj
         GVeay4/TsadhtoRTPVrfnbOmd+BjIKzn5RPbIogb/LQ2BGY6OUJDouApGyodISusf/fw
         HWbbT9X5pFBE/YIu/EvTPI86t9yV/EBzxNwgyAzf6bzcWD4LMmP9HrFC6zeW8ETQSxj2
         sIbmHWf1MRilR55K95KR5ISOQoAS2PpIOLjHX+u0zcesqRUgPheyMLAOzC/FcO3E5hul
         zBSXRWDsnkp9IcSK37yk4s0sZAYsSWhF0/rXYQDtxSNdVsZ2RzaYi1pJPNWQzrItm4rV
         Xh0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DxNt0eIwm9p9g/mQmVwYWK8COQJtmgwTgesczuWioPg=;
        b=ihWjIkSrzfUiF05s2QKmB7J+q53FxfMNomP2+hd9LVf4Yh94ISYQj6NEr7LmPoUDCg
         cu2KsCCq5guZDu2IK62Xz8xf8yGELu9T81WZE5RsnLjm2l4Q3sGJBPUYPsgoN33D0e1N
         6hcOFKWLt8QjhKHWoGA/jsCON5PJU69D9Qbw5KOc9pF4RalS//v9OuMUhVRhAEoruind
         S3AosRRfW12uml70vccPVNjs2jS/RQDrJFR8kgTw3VcK4PH1UBMw5FB5xnNfaJVLcmJi
         sxCCGsy5cwlk1UJ1xw1p2msfu76BjvTRkjDq6vsBNVulVnHFIoGtjh1j5hb0IkJ+H2Bm
         kmVw==
X-Gm-Message-State: AOAM5321wp4Xc6nvfBH4Z4TR+pZO0EiVH0Zju6XYyPMO/AHF+iAn5yRC
        jIJg+iAaTvqfwBMdWya3qbboLKDS7Me6DM03neHFRAp0qK9nHw==
X-Google-Smtp-Source: ABdhPJy33K/MZi/8fowNpbavwNCsNJmtMmm7LuXYb74EHZQGkej9w1i7LTwl8SZ8cZENnVTKt5AurBBwAssQbfegELw=
X-Received: by 2002:a05:6602:13c6:: with SMTP id o6mr20248830iov.84.1591606604459;
 Mon, 08 Jun 2020 01:56:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com> <20200605213853.14959-20-sean.j.christopherson@intel.com>
In-Reply-To: <20200605213853.14959-20-sean.j.christopherson@intel.com>
From:   Huacai Chen <chenhuacai@gmail.com>
Date:   Mon, 8 Jun 2020 16:56:32 +0800
Message-ID: <CAAhV-H6v+tO6PCqjfDcecxk-mUk8YEmSDUMjOXMj1hL5=XSpSw@mail.gmail.com>
Subject: Re: [PATCH 19/21] KVM: MIPS: Drop @max param from mmu_topup_memory_cache()
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
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>,
        Christoffer Dall <christoffer.dall@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Huacai Chen <chenhc@lemote.com>

On Sat, Jun 6, 2020 at 5:44 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Replace the @max param in mmu_topup_memory_cache() and instead use
> ARRAY_SIZE() to terminate the loop to fill the cache.  This removes a
> BUG_ON() and sets the stage for moving MIPS to the common memory cache
> implementation.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/mips/kvm/mmu.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
> index 7dad7a293eae..94562c54b930 100644
> --- a/arch/mips/kvm/mmu.c
> +++ b/arch/mips/kvm/mmu.c
> @@ -25,15 +25,13 @@
>  #define KVM_MMU_CACHE_MIN_PAGES 2
>  #endif
>
> -static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
> -                                 int min, int max)
> +static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache, int min)
>  {
>         void *page;
>
> -       BUG_ON(max > KVM_NR_MEM_OBJS);
>         if (cache->nobjs >= min)
>                 return 0;
> -       while (cache->nobjs < max) {
> +       while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
>                 page = (void *)__get_free_page(GFP_KERNEL);
>                 if (!page)
>                         return -ENOMEM;
> @@ -711,8 +709,7 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
>                 goto out;
>
>         /* We need a minimum of cached pages ready for page table creation */
> -       err = mmu_topup_memory_cache(memcache, KVM_MMU_CACHE_MIN_PAGES,
> -                                    KVM_NR_MEM_OBJS);
> +       err = mmu_topup_memory_cache(memcache, KVM_MMU_CACHE_MIN_PAGES);
>         if (err)
>                 goto out;
>
> @@ -796,8 +793,7 @@ static pte_t *kvm_trap_emul_pte_for_gva(struct kvm_vcpu *vcpu,
>         int ret;
>
>         /* We need a minimum of cached pages ready for page table creation */
> -       ret = mmu_topup_memory_cache(memcache, KVM_MMU_CACHE_MIN_PAGES,
> -                                    KVM_NR_MEM_OBJS);
> +       ret = mmu_topup_memory_cache(memcache, KVM_MMU_CACHE_MIN_PAGES);
>         if (ret)
>                 return NULL;
>
> --
> 2.26.0
>
