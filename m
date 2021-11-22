Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68F7459522
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 19:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239261AbhKVS4A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 13:56:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbhKVSzl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 13:55:41 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE36C061748
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 10:52:35 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id w15so19173408ill.2
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 10:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jh0rAboI5YGmmBd4eAYKZ7CKVWH/8t5Aet8Vy4Wq++s=;
        b=Q1sfYb5XgG58bxKiOwySl8U40ogH+EyXn4bIG/VtrjilGcDEFSwOFEDW7eM5Aux67p
         z4Lo5FWGbBDhC4r5n0P21z0pl+cvm+tVMgbus0bsf8UdoRj5hn5ex+wj7WVIOwDVnVLx
         GGrKJCo3Q0sZjbuE3u4rMjwnJiUpExrU9E20W5yOE8BK+iQVhQtZvjc1q2goiN/jwbg5
         Sse3gMpZFAioq/33bPlO4hGGAzPTK1dcxZYPzqok33NjMkVhBRQ//mjvFc965O079kKE
         SkSvGaLsf0J1wP5siiBFmtSYhx2AS8nNo/MqDdVhDYeV9Wz/Ej0glDfQRZsr0fap5nsu
         POZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jh0rAboI5YGmmBd4eAYKZ7CKVWH/8t5Aet8Vy4Wq++s=;
        b=URzV+MDSVzBRFgKzYdVbRTx7Gll+Mt4oQ6haLrS2zn7mlrDwyCHyUi1Vrsal9Me2QG
         0Zjok5yr4+nxTjwZeYVDsmLz1mjklLp8A4clFln65otpXB0VIxyRevlpgxsadgNJLci8
         FNp06Plv/aIz+U3aFxP8YkeC/FBCQEZNOs5sbdLfGklfxfQxbKpm5qri0y3c961SCfdT
         1+DYeHWyXX8Z+fEj3089Q+eNiJD6IbIf9Yjja500CaG+YQY4hUwe2uW8XsCYFzSDcep9
         SLKjXvo8tQgTjeQm8df9FGb/1SJ9538gxk5OaawuBcS0RUaU+OyNySnEAh30iaENXOlB
         l5pA==
X-Gm-Message-State: AOAM53343OTezpsg6HzCfTpoGrxAwBFb/KlPoDEnwrGN3dWoDSq1DA5a
        5uS7yvv/Ev+heFURb9e/556Tk5FClYkIj5NiocOzvA==
X-Google-Smtp-Source: ABdhPJwaczCDNK4/ARD63U7RMdwUfIJBG1EUi5/4PCfvcAZ9e0Pb1dzGbnG2sxrRQB8Ysx4U/+LUAyn1QlQi4CG63Ug=
X-Received: by 2002:a92:dccc:: with SMTP id b12mr21458495ilr.129.1637607154439;
 Mon, 22 Nov 2021 10:52:34 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com> <20211119235759.1304274-2-dmatlack@google.com>
In-Reply-To: <20211119235759.1304274-2-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 22 Nov 2021 10:52:23 -0800
Message-ID: <CANgfPd9geO-+S__H5k5nxcJQ-OrLJk0Az8SZR8BdCm_ViySMwQ@mail.gmail.com>
Subject: Re: [RFC PATCH 01/15] KVM: x86/mmu: Rename rmap_write_protect to kvm_vcpu_write_protect_gfn
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
> rmap_write_protect is a poor name because we may not even touch the rmap
> if the TDP MMU is in use. It is also confusing that rmap_write_protect
> is not a simpler wrapper around __rmap_write_protect, since that is the
> typical flow for functions with double-underscore names.
>
> Rename it to kvm_vcpu_write_protect_gfn to convey that we are
> write-protecting a specific gfn in the context of a vCPU.
>
> No functional change intended.
>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>


> ---
>  arch/x86/kvm/mmu/mmu.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 8f0035517450..16ffb571bc75 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1427,7 +1427,7 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
>         return write_protected;
>  }
>
> -static bool rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
> +static bool kvm_vcpu_write_protect_gfn(struct kvm_vcpu *vcpu, u64 gfn)
>  {
>         struct kvm_memory_slot *slot;
>
> @@ -2026,7 +2026,7 @@ static int mmu_sync_children(struct kvm_vcpu *vcpu,
>                 bool protected = false;
>
>                 for_each_sp(pages, sp, parents, i)
> -                       protected |= rmap_write_protect(vcpu, sp->gfn);
> +                       protected |= kvm_vcpu_write_protect_gfn(vcpu, sp->gfn);
>
>                 if (protected) {
>                         kvm_mmu_remote_flush_or_zap(vcpu->kvm, &invalid_list, true);
> @@ -2153,7 +2153,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>         hlist_add_head(&sp->hash_link, sp_list);
>         if (!direct) {
>                 account_shadowed(vcpu->kvm, sp);
> -               if (level == PG_LEVEL_4K && rmap_write_protect(vcpu, gfn))
> +               if (level == PG_LEVEL_4K && kvm_vcpu_write_protect_gfn(vcpu, gfn))
>                         kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn, 1);
>         }
>         trace_kvm_mmu_get_page(sp, true);
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
