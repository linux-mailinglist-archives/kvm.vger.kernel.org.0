Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589DF3AC6AB
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 10:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbhFRJBz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 05:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbhFRJBy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 05:01:54 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83C6C061574
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 01:59:45 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id 5-20020a9d01050000b02903c700c45721so9016237otu.6
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 01:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kxWq/w4pUVc8HOlAC++EsNgPCdWz4WRSzn6eNlOcpd8=;
        b=bhaMQb0WGrbDqa+aKHcQIksSIM+zTHdcqFfPBr5BV5rr/Wi8UST4PtBaFBBmWA70/c
         JeE4Hu4BbtwFqF0c80sjfACvvB1nesUeK9TieyU/oqhdgOex7UgfdkqRux0UxZ5/TcHT
         DLHvuKVExIhZtgV1fPhYLr/Md+zpFpFjNVpAPjGlXCP+m9MsUwKdcLN7akLZFoz7RcTk
         238s+sJ/BuekxpTMYI4dcJE/HjWwxIUM3JYIJt/VdYH2Zb8cmBY3gzekVcESfoAgP54o
         bIIHlFX/dEToFLWW+5NXkS2fXPFEuRa4egZ9ULCaZiOK2z8px8znd93Nlh17ZN0KkdrP
         Dwpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kxWq/w4pUVc8HOlAC++EsNgPCdWz4WRSzn6eNlOcpd8=;
        b=lni26DhIluclcazoXbWHkxeCxWGZinLVdFy1jEkq4uQpAA4o48TxJ95LuVyBjnvFsg
         xgsmhGigpHEdl1zh8Mj+q2q8aADdHt676HShgvDpbRmaRZTtwM6Opj9xwhdFZLOQhjj6
         +TeFS4/kXFWy2CEMDEENhsCl3/7CkeSoTHcmG0r+W0EUK1XNxtQXwwYn8xj2pLLW5M2q
         lsOOQXK9nM+KplyVMZlNDGPj6X/OwThDZ+Mo14hB6D8rg1sr1ykuD7coSnaeh6Aj5y10
         tFKUlzeAC/p5UxYvmoB3UBeMneA1EHZY+AJEg8frcnCewBA70dCF0w3ouWcc0wja4oCO
         R20w==
X-Gm-Message-State: AOAM530anWL0WiIwW/vayvQ3IeeguSAOCWb2q2VciUT+axbzBEW5dUnw
        scb+qEfQrOawBBM/4/fUuyG4cbKREHMXeBt/rbQ5qw==
X-Google-Smtp-Source: ABdhPJwzc7DiWjyKPp58Q0od7P57f5+tDcapLIkUHFsPNVK62ZAuAwBi+XcIKklM8bb9dajJNv9sTtXhTaAbgYqG490=
X-Received: by 2002:a05:6830:1598:: with SMTP id i24mr8497546otr.52.1624006785056;
 Fri, 18 Jun 2021 01:59:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210617105824.31752-1-wangyanan55@huawei.com>
 <20210617105824.31752-2-wangyanan55@huawei.com> <20210617123837.GA24457@willie-the-truck>
 <87eed0d13p.wl-maz@kernel.org> <2c1b9376-3997-aa7b-d5f3-b04da985c260@huawei.com>
In-Reply-To: <2c1b9376-3997-aa7b-d5f3-b04da985c260@huawei.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Fri, 18 Jun 2021 09:59:09 +0100
Message-ID: <CA+EHjTyW+LP=UmwDP+egbPzpz2vxFpbOMgXi=dOt15j8wfLxWg@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] KVM: arm64: Introduce two cache maintenance callbacks
To:     "wangyanan (Y)" <wangyanan55@huawei.com>
Cc:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Fri, Jun 18, 2021 at 2:52 AM wangyanan (Y) <wangyanan55@huawei.com> wrote:
>
>
>
> On 2021/6/17 22:20, Marc Zyngier wrote:
> > On Thu, 17 Jun 2021 13:38:37 +0100,
> > Will Deacon <will@kernel.org> wrote:
> >> On Thu, Jun 17, 2021 at 06:58:21PM +0800, Yanan Wang wrote:
> >>> To prepare for performing CMOs for guest stage-2 in the fault handlers
> >>> in pgtable.c, here introduce two cache maintenance callbacks in struct
> >>> kvm_pgtable_mm_ops. We also adjust the comment alignment for the
> >>> existing part but make no real content change at all.
> >>>
> >>> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
> >>> ---
> >>>   arch/arm64/include/asm/kvm_pgtable.h | 42 +++++++++++++++++-----------
> >>>   1 file changed, 25 insertions(+), 17 deletions(-)
> >>>
> >>> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> >>> index c3674c47d48c..b6ce34aa44bb 100644
> >>> --- a/arch/arm64/include/asm/kvm_pgtable.h
> >>> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> >>> @@ -27,23 +27,29 @@ typedef u64 kvm_pte_t;
> >>>
> >>>   /**
> >>>    * struct kvm_pgtable_mm_ops - Memory management callbacks.
> >>> - * @zalloc_page:   Allocate a single zeroed memory page. The @arg parameter
> >>> - *                 can be used by the walker to pass a memcache. The
> >>> - *                 initial refcount of the page is 1.
> >>> - * @zalloc_pages_exact:    Allocate an exact number of zeroed memory pages. The
> >>> - *                 @size parameter is in bytes, and is rounded-up to the
> >>> - *                 next page boundary. The resulting allocation is
> >>> - *                 physically contiguous.
> >>> - * @free_pages_exact:      Free an exact number of memory pages previously
> >>> - *                 allocated by zalloc_pages_exact.
> >>> - * @get_page:              Increment the refcount on a page.
> >>> - * @put_page:              Decrement the refcount on a page. When the refcount
> >>> - *                 reaches 0 the page is automatically freed.
> >>> - * @page_count:            Return the refcount of a page.
> >>> - * @phys_to_virt:  Convert a physical address into a virtual address mapped
> >>> - *                 in the current context.
> >>> - * @virt_to_phys:  Convert a virtual address mapped in the current context
> >>> - *                 into a physical address.
> >>> + * @zalloc_page:           Allocate a single zeroed memory page.
> >>> + *                         The @arg parameter can be used by the walker
> >>> + *                         to pass a memcache. The initial refcount of
> >>> + *                         the page is 1.
> >>> + * @zalloc_pages_exact:            Allocate an exact number of zeroed memory pages.
> >>> + *                         The @size parameter is in bytes, and is rounded
> >>> + *                         up to the next page boundary. The resulting
> >>> + *                         allocation is physically contiguous.
> >>> + * @free_pages_exact:              Free an exact number of memory pages previously
> >>> + *                         allocated by zalloc_pages_exact.
> >>> + * @get_page:                      Increment the refcount on a page.
> >>> + * @put_page:                      Decrement the refcount on a page. When the
> >>> + *                         refcount reaches 0 the page is automatically
> >>> + *                         freed.
> >>> + * @page_count:                    Return the refcount of a page.
> >>> + * @phys_to_virt:          Convert a physical address into a virtual address
> >>> + *                         mapped in the current context.
> >>> + * @virt_to_phys:          Convert a virtual address mapped in the current
> >>> + *                         context into a physical address.
> >>> + * @clean_invalidate_dcache:       Clean and invalidate the data cache for the
> >>> + *                         specified memory address range.
> >> This should probably be explicit about whether this to the PoU/PoC/PoP.
> > Indeed. I can fix that locally if there is nothing else that requires
> > adjusting.
> Will be grateful !

Sorry, I missed the v7 update. One comment here is that the naming
used in the patch series I mentioned shortens invalidate to inval (if
you want it to be less of a mouthful):
https://lore.kernel.org/linux-arm-kernel/20210524083001.2586635-19-tabba@google.com/

Otherwise:
Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks!
/fuad



>
> Thanks,
> Yanan
> .
> >
> >       M.
> >
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
