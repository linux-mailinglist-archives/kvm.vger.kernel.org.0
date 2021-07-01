Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDC63B9274
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 15:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbhGANsC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 09:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhGANr6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 09:47:58 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7B3C061762
        for <kvm@vger.kernel.org>; Thu,  1 Jul 2021 06:45:27 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id o13-20020a9d404d0000b0290466630039caso6544225oti.6
        for <kvm@vger.kernel.org>; Thu, 01 Jul 2021 06:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3Z3Ky60fuRUeEkGom9Yl2zloU6rr5fasjCslnLTq5J4=;
        b=h1FHCJUTz+cPJ99ikqnWnu26wAhDi9Pbj2yi2ayDZV8XMkma6MQmm1iJ1OfkLzQrXa
         s5vBTY5sOM3h7IYkT+9aN9odhxcQqU/WjX9wH1rSGjswAXS2yGBj1/V4Le1bIYfGzIP8
         GB3QWd2YPXBm4mhdC7uFzRXGV7BIv6cGzzQARDWby9RfgrAQ9GfuGYLENR65ZlArlxGe
         sPzzTVQBS2Dgh5WIyzqCHF7hazDhs1V/KKprP8FODoL+Z4SgzHINpIca+4jAfnccHvGL
         jezzJBTipS2zc1gyrEhz6lmv9r9GdVsSHfXL9DzEnqZr6/IxlIM9FYXz4FkPxm5tI98n
         +J4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3Z3Ky60fuRUeEkGom9Yl2zloU6rr5fasjCslnLTq5J4=;
        b=WtH9/1rvXZx4BjFxHRq47C4WDkN/xu11KLM7E2KCDETXyvblVyRqkfQxTize6Z7xd7
         NkKDNLpMRS9h9q601Kz4TLh9JGYZ3+7CT5VccU8vC2r2LqFvc0uzpfC+xWUGVUDxhpaq
         32iPyhqJmyQ+WS3tZp4XRorrhc/ttzUhO4Btv/a9xH5O9dIuQx/HmdRvUPf2RIFvk+qP
         GACijJiw8yhkwDKKUemkaxD1woCzvrtsClLlVjSC4nfFQBR9q6x/jHRm1eqjA0UgZ6eI
         EpUNpcXp0YmZv4FZcTIo9YRowWRHQgOzcqDP/3i/9U5wFrf3ypyzET9Q72wu90lz+xIQ
         AGUw==
X-Gm-Message-State: AOAM532hXgls2W/ADfoI3bwnsvox1oYWwzHaveuHoMu1cKhuRhg+Np/C
        OUw/KsQ9wa4iOFVC0ouzHRWyT9B4jDE8jQX67YQI3Q==
X-Google-Smtp-Source: ABdhPJzeim6ujWY7qJh+wtQAcoH/aBYP+t9YLKycAH2wxkD4xqTn7Nen+pj2ik7IL4o31/4yRywN6rMyo9yoBfWXbvM=
X-Received: by 2002:a05:6830:1de2:: with SMTP id b2mr30219otj.365.1625147126448;
 Thu, 01 Jul 2021 06:45:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com> <20210615133950.693489-4-tabba@google.com>
 <20210701130149.GC9757@willie-the-truck>
In-Reply-To: <20210701130149.GC9757@willie-the-truck>
From:   Fuad Tabba <tabba@google.com>
Date:   Thu, 1 Jul 2021 14:44:50 +0100
Message-ID: <CA+EHjTxmmLtGgSm6XOe9PL7S5hkjuzeW6VSzQbhR1wT5RWi7WQ@mail.gmail.com>
Subject: Re: [PATCH v2 03/13] KVM: arm64: Fix names of config register fields
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Will,

On Thu, Jul 1, 2021 at 2:01 PM Will Deacon <will@kernel.org> wrote:
>
> On Tue, Jun 15, 2021 at 02:39:40PM +0100, Fuad Tabba wrote:
> > Change the names of hcr_el2 register fields to match the Arm
> > Architecture Reference Manual. Easier for cross-referencing and
> > for grepping.
> >
> > Also, change the name of CPTR_EL2_RES1 to CPTR_NVHE_EL2_RES1,
> > because res1 bits are different for VHE.
> >
> > No functional change intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_arm.h | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> > index 25d8a61888e4..bee1ba6773fb 100644
> > --- a/arch/arm64/include/asm/kvm_arm.h
> > +++ b/arch/arm64/include/asm/kvm_arm.h
> > @@ -31,9 +31,9 @@
> >  #define HCR_TVM              (UL(1) << 26)
> >  #define HCR_TTLB     (UL(1) << 25)
> >  #define HCR_TPU              (UL(1) << 24)
> > -#define HCR_TPC              (UL(1) << 23)
> > +#define HCR_TPCP     (UL(1) << 23)
>
> This one is a bit weird: the field is called TPCP if the CPU supports
> FEAT_DPB but is called TPC otherwise! So I don't think renaming it like
> this really makes anything better. Perhaps add a comment:
>
>   #define HCR_TPC       (UL(1) << 23)   /* TPCP if FEAT_DPB */

I missed that. That's why it's referred to as Bit[23] in the diagram.
I'll add the comment and revert its name.

Thanks,
/fuad

> ?
>
> Rest of the patch looks good:
>
> Acked-by: Will Deacon <will@kernel.org>
>
> Will
