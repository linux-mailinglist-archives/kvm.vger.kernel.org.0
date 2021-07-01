Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C973B94B1
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 18:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhGAQgU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 12:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbhGAQgU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 12:36:20 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1A0C061762
        for <kvm@vger.kernel.org>; Thu,  1 Jul 2021 09:33:49 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id f21so8206068ioh.13
        for <kvm@vger.kernel.org>; Thu, 01 Jul 2021 09:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oxNmfnGuVWxwqtQP8iWetLNNCO0LL7lruLnrhE46HbY=;
        b=TioGXDMwu1WAftTOwRQMsrLcoN14xtL+ozg3gIC/P2Ms+Ylo6+9IjYGyblZCvG9n8Z
         r5QWhXcMrmuDDZX5xGuWtnYeD2mdznpq0P9x3UgfjMM93vsnQwyj11Kf7d9uQKLOetfV
         AHA3acb89mu+ZPiYjA0sbtD2/X5GfsPE97zSWAQMPh+0FXYkWHrFR78r0bJhDeXxBBpI
         HJuTPOuPffjoPfX/kmEOJithNlCyq8iNm/nSuE3u10GM5O9j5I46VGRVQ9Akk2qeSiIg
         lADEBgHvo3lASUgMTAP5aezeEJa602kd7TvpdRVS8Rc0vyHwLH09ecCqtCHuIK/AJ7JQ
         BnSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oxNmfnGuVWxwqtQP8iWetLNNCO0LL7lruLnrhE46HbY=;
        b=mWQWN8pN9mk/qwIdCe/xu3JQuJywQ356zID1GtWZsDodiH1W7dj1YMw5g1le5ykt/t
         jHxDoSyZ7Um2i4x6V6MfL+gPICMnCY8eL2LwIPOlfW6fPdD34F54oE+w5UDPjISE+XUD
         qX6vbdsBq29QhA//EE24PYcH7T9c7PYiriFWEGT/YAGkHSo2MY+TempwCyDqNpwBegJr
         a6EgERln2NTgYv7JUJ+OfndQ9+EmTy19oeap3s4muP3kNdXBh8ZnNh1WhXJidNjg3GTq
         wn/QH7PW2Dx74JdyyfG7Lli3RnxiOE81yDHIbCJIzkwg9EW69wzpddw8gQsB73aezzXJ
         V6hw==
X-Gm-Message-State: AOAM531GzqkgIDOpzqdcCBTiQKI4D+ee1TC9UhA1KL80jU0XygUBK3tK
        dJZR5Wd9hI+45S9o7JD3F0aP40uUdbGDE7ZRMhHWmA==
X-Google-Smtp-Source: ABdhPJxqmIlTDA1yhmLYwjDxlu5KYbaTz3fteR4mltnVvDp8Cn5k2rJwkIH6uuP7tHtEN6PLDCP6EAlzIfOl4v6O4qc=
X-Received: by 2002:a6b:5b11:: with SMTP id v17mr228586ioh.19.1625157228881;
 Thu, 01 Jul 2021 09:33:48 -0700 (PDT)
MIME-Version: 1.0
References: <YNWm623jLRMMDoNS@mwanda>
In-Reply-To: <YNWm623jLRMMDoNS@mwanda>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 1 Jul 2021 09:33:38 -0700
Message-ID: <CANgfPd9xMTre6yZjvM6Yh-7SUrUQf5QHOScncPrZzA7noCF7ug@mail.gmail.com>
Subject: Re: [bug report] KVM: x86/mmu: Skip rmap operations if rmaps not allocated
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Dan,

Thanks for reporting this. I believe it's already been fixed by "KVM:
x86/mmu: Fix uninitialized boolean variable flush" from Colin King.

On Fri, Jun 25, 2021 at 2:50 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> Hello Ben Gardon,
>
> The patch e2209710ccc5: "KVM: x86/mmu: Skip rmap operations if rmaps
> not allocated" from May 18, 2021, leads to the following static
> checker warning:
>
>         arch/x86/kvm/mmu/mmu.c:5704 kvm_mmu_zap_collapsible_sptes()
>         error: uninitialized symbol 'flush'.
>
> arch/x86/kvm/mmu/mmu.c
>   5687  void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
>   5688                                     const struct kvm_memory_slot *memslot)
>   5689  {
>   5690          /* FIXME: const-ify all uses of struct kvm_memory_slot.  */
>   5691          struct kvm_memory_slot *slot = (struct kvm_memory_slot *)memslot;
>   5692          bool flush;
>                 ^^^^^^^^^^
> needs to be "bool flush = false;"
>
>   5693
>   5694          if (kvm_memslots_have_rmaps(kvm)) {
>   5695                  write_lock(&kvm->mmu_lock);
>   5696                  flush = slot_handle_leaf(kvm, slot, kvm_mmu_zap_collapsible_spte, true);
>   5697                  if (flush)
>   5698                          kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
>   5699                  write_unlock(&kvm->mmu_lock);
>   5700          }
>   5701
>   5702          if (is_tdp_mmu_enabled(kvm)) {
>   5703                  read_lock(&kvm->mmu_lock);
>   5704                  flush = kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot, flush);
>                                                                              ^^^^^
> Unintialized.
>
>   5705                  if (flush)
>   5706                          kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
>   5707                  read_unlock(&kvm->mmu_lock);
>   5708          }
>   5709  }
>
> regards,
> dan carpenter
