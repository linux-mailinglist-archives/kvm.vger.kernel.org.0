Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421F5459524
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 19:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233806AbhKVS4C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 13:56:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235215AbhKVSzv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 13:55:51 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B93C06174A
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 10:52:44 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id l19so19228919ilk.0
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 10:52:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d33SvisFQWBLP/JzQCEnd5k7sCbWGBXg7+QmXZl0nEU=;
        b=THFPvbtUXKDcarpvhenOcux6hN2XiC1iZYWHU7GzZZ7WhXQ+PgIUzcOAR9zO6f/YGG
         4dO5qVeUqiu+vEtywL7TTp9ZJrfKYSpjO07srEuCSIM48JOz2StIcE3pmLAiG+j17veM
         UgLgpVA+Us4vAkEMazmz+rxTxJOfLkau2Ew0lr6eqw7JMMh4zcLA3Hv0JImuF402qXJd
         9ga2O3shTroHV0S+wUbuXtnIFp31SSCxG/dQlhM4bOekF7DBmBKc9/29jth9Ry+GVpDF
         a0uYdvUF+pbQSmNwFJ0Sbf81UFe3HDdmlr47x2dlLyRstT2c7p/jjoGgchJEnpxCqzXA
         79oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d33SvisFQWBLP/JzQCEnd5k7sCbWGBXg7+QmXZl0nEU=;
        b=DtmkvYl9ejZ3GkLq2NH5HePr7KiknKeXNRoLQ9nHVPgHN771PBUF1b87kPlgqTMCnF
         Z0lnp3VNh4NvU+HWOurXyRTGNCQY7/cVSCPmCuQPHNnP5rTEtrfdiUl2PAF2uWJ9la2h
         qT3cV8++5jcBTpvTaXgaIWH5EGjfSL1f86a9uvIw8BLTVYbfV1oPLjmts76drGI0xmf7
         9h+9srg0N4Lyh3RdRhC57wKyGzvS+51rb0w3gy4cgSQp5wxARwlmnrbkFbB/VBG6gmGl
         04JY0ul+ojVJ5/BZZWKQNRGxBqNF4rphC/osTf8LxOIBMYhlniOjukFGmq1S+H6TvNlP
         DVBg==
X-Gm-Message-State: AOAM5337SajuPbn9habvmScsFr3oqvFDzYHGuhaMFVUaOKuyizeF0BCZ
        uEh/Q0zlu9OlYohgTRn/oWynZn4v8hp28mN8vu4PPQ==
X-Google-Smtp-Source: ABdhPJxxJ7BupMW8fPyzOSh15lP89H9XS7ubq4fEHheZfYxPh1ZzC7yyw9uJAkABqqjPiRH3LRaujoxy1cGf+hN7WJc=
X-Received: by 2002:a05:6e02:52d:: with SMTP id h13mr21836909ils.274.1637607163253;
 Mon, 22 Nov 2021 10:52:43 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com> <20211119235759.1304274-3-dmatlack@google.com>
In-Reply-To: <20211119235759.1304274-3-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 22 Nov 2021 10:52:32 -0800
Message-ID: <CANgfPd9ggDdfgs81ujv83Ztq66FJ+kHpmyNVHWg9_R1JvDSLGQ@mail.gmail.com>
Subject: Re: [RFC PATCH 02/15] KVM: x86/mmu: Rename __rmap_write_protect to rmap_write_protect
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 19, 2021 at 3:58 PM David Matlack <dmatlack@google.com> wrote:
>
> Now that rmap_write_protect has been renamed, there is no need for the
> double underscores in front of __rmap_write_protect.
>
> No functional change intended.
>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>


> ---
>  arch/x86/kvm/mmu/mmu.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 16ffb571bc75..1146f87044a6 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1235,9 +1235,9 @@ static bool spte_write_protect(u64 *sptep, bool pt_protect)
>         return mmu_spte_update(sptep, spte);
>  }
>
> -static bool __rmap_write_protect(struct kvm *kvm,
> -                                struct kvm_rmap_head *rmap_head,
> -                                bool pt_protect)
> +static bool rmap_write_protect(struct kvm *kvm,
> +                              struct kvm_rmap_head *rmap_head,
> +                              bool pt_protect)
>  {
>         u64 *sptep;
>         struct rmap_iterator iter;
> @@ -1317,7 +1317,7 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
>         while (mask) {
>                 rmap_head = gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
>                                         PG_LEVEL_4K, slot);
> -               __rmap_write_protect(kvm, rmap_head, false);
> +               rmap_write_protect(kvm, rmap_head, false);
>
>                 /* clear the first set bit */
>                 mask &= mask - 1;
> @@ -1416,7 +1416,7 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
>         if (kvm_memslots_have_rmaps(kvm)) {
>                 for (i = min_level; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
>                         rmap_head = gfn_to_rmap(gfn, i, slot);
> -                       write_protected |= __rmap_write_protect(kvm, rmap_head, true);
> +                       write_protected |= rmap_write_protect(kvm, rmap_head, true);
>                 }
>         }
>
> @@ -5780,7 +5780,7 @@ static bool slot_rmap_write_protect(struct kvm *kvm,
>                                     struct kvm_rmap_head *rmap_head,
>                                     const struct kvm_memory_slot *slot)
>  {
> -       return __rmap_write_protect(kvm, rmap_head, false);
> +       return rmap_write_protect(kvm, rmap_head, false);
>  }
>
>  void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
