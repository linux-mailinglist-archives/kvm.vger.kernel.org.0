Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69F73A6DD3
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 19:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbhFNR6q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 13:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233358AbhFNR6p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 13:58:45 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D876DC061767
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 10:56:41 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id x18so12964301ila.10
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 10:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QgQaf9a02i/gSrpUaabARbJbCqToF9sTPzXcFtCieAQ=;
        b=G8KM41dbJoc0BB0NM1gIhW0LNuPJbIhP1M52E0Ki1hoA46TZWaIn+3Exd+q28Zi0we
         zK876TBaXp+Y01cYMAy8DJYog/VP5L/qLZN4RaKj1RxfnUQx9NWrRXCK6mlsFgWc8CgC
         MjqTFQAW9SwvgNkhJTIWpkk0ER9iTqJCiOicFRrKW2Gi6/VYTE3w03AbmvHnvLr46HSx
         GsIhIermNG2DS/FgIyh4kZag+5YxNyK8VPeoT8Y8lnDpuOxLlfFako1k6mnvDozYP4HS
         bKNjQJQqVUsksu31ulsXQzgaK98mW1MARnjO89r2U76l5d+RmXHr0siVhoZtZeCS19ZC
         Enkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QgQaf9a02i/gSrpUaabARbJbCqToF9sTPzXcFtCieAQ=;
        b=JY6a+WqKhCHv7QdOW34aDtuvz1QQycGLtxm/pmmeedwYpNFzn7gHJdFYesXjIdh3Wj
         UxQcdGvNwR0p2l/O/vMagQn3zJHRINO05mFlquyo22kdFj7gY4a0TzJim8KJ+u3EX26w
         Mj1y8OgxWgkRR3bJ9lVyNkpl1YuY6WjegFbGShpR+vLi+c63zh6uSryDROmE/WswqNfy
         PaXmJF17P3YFy1g9hgm+2HTitn7ZdTQl2cWYKjdRFrv58Rp54+JwPvPEqYE0tqI9OG+K
         9dHNm8xCATwbifX6yuDsYuMhkuUiGR5Wr3s07G48KxV9vQyIhqWxUT6qg1cFCLj+43uC
         E0yw==
X-Gm-Message-State: AOAM5315XBNYyVJ5ei8YN/OSzJtDjILEfHHaU3DEijOfFPXfJcKxkCs6
        XXLRwHXmrBxX2REW5NbU2k+lk9AXaq+SkHK473q449EKntc=
X-Google-Smtp-Source: ABdhPJyiQhBv3NFJVhqfd7C9mQqqHgflSLC9OxhXBknckCH8xC9yElqByX5RCwpGhidh71vvtw9BEQGdwv+PfUqe1tM=
X-Received: by 2002:a92:7303:: with SMTP id o3mr14739919ilc.203.1623693401098;
 Mon, 14 Jun 2021 10:56:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210611235701.3941724-1-dmatlack@google.com> <20210611235701.3941724-3-dmatlack@google.com>
In-Reply-To: <20210611235701.3941724-3-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 14 Jun 2021 10:56:30 -0700
Message-ID: <CANgfPd9Z5_Pp4NdqMsY+uRNGSRbXci0yFq7YSJg77XaDcGb1sw@mail.gmail.com>
Subject: Re: [PATCH 2/8] KVM: x86/mmu: Rename cr2_or_gpa to gpa in fast_page_fault
To:     David Matlack <dmatlack@google.com>
Cc:     kvm <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 11, 2021 at 4:57 PM David Matlack <dmatlack@google.com> wrote:
>
> fast_page_fault is only called from direct_page_fault where we know the
> address is a gpa.
>
> Fixes: 736c291c9f36 ("KVM: x86: Use gpa_t for cr2/gpa to fix TDP support on 32-bit KVM")
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>


> ---
>  arch/x86/kvm/mmu/mmu.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index eccd889d20a5..1d0fe1445e04 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3007,8 +3007,7 @@ static bool is_access_allowed(u32 fault_err_code, u64 spte)
>  /*
>   * Returns one of RET_PF_INVALID, RET_PF_FIXED or RET_PF_SPURIOUS.
>   */
> -static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> -                          u32 error_code)
> +static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
>  {
>         struct kvm_shadow_walk_iterator iterator;
>         struct kvm_mmu_page *sp;
> @@ -3024,7 +3023,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>         do {
>                 u64 new_spte;
>
> -               for_each_shadow_entry_lockless(vcpu, cr2_or_gpa, iterator, spte)
> +               for_each_shadow_entry_lockless(vcpu, gpa, iterator, spte)
>                         if (!is_shadow_present_pte(spte))
>                                 break;
>
> @@ -3103,8 +3102,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>
>         } while (true);
>
> -       trace_fast_page_fault(vcpu, cr2_or_gpa, error_code, iterator.sptep,
> -                             spte, ret);
> +       trace_fast_page_fault(vcpu, gpa, error_code, iterator.sptep, spte, ret);
>         walk_shadow_page_lockless_end(vcpu);
>
>         return ret;
> --
> 2.32.0.272.g935e593368-goog
>
