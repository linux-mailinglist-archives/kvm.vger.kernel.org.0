Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E60E4595DD
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 21:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240386AbhKVUGW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 15:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbhKVUGR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 15:06:17 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC8EC061714
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 12:03:10 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id 14so24848618ioe.2
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 12:03:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rrUEucjsIu25GY601OtreqwaBPOJR4BOvmaMLgpsfuw=;
        b=JHgX7iSo19FK/TBFpxrd4cWpaSIJvNrXDPtItYF6sb6+arW0kpgY22ZNg4KY/xzD/0
         VHFvbpt/eyLLuPknWFGPy8znPRHfkBpRRD8LZI46fj/hixT884bAeem93vBM3MaCaNX4
         8tCv2GPwUFppLfJQet1T6y2cbn46MORiZ4lJitgJqfhuBWvJSEpBx2Cebeomc1EphDUh
         0rnGP4e/PytZIR5PmDOcEhoqTv7/ft+x42f/Ti+yE+Zzanl9iGN4dBIpTJBTaMs3ylQs
         BG5hLxnIH6Xqypo2tYQ94IusN7s0xjv8EvhLBl7d5sKMVXefoNzunAlQIg/Keu/y7bdZ
         I+jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rrUEucjsIu25GY601OtreqwaBPOJR4BOvmaMLgpsfuw=;
        b=Dcq9w84K6HT69vyBKSG1aKF7D1bBKPMLcDNwO6N3cbGlvekP8SIoFx/15u90ksPxvj
         2NYd5ch+i6rij3sqP5uwVmGaGS5IcLpyy8az3+Z3+xtV0NztZhkY28397EtQ1CUt37Qb
         p7eKFmdiLNJvqpXo+1+bud+LgbQhBWFARVYlfuup4qo+Q3Bp7m2UcL0cVvtUvK/qu4jq
         UacpAZPHY+LAVcmSt3EZuku514XbNGQc6sso8p2tDCRQm+1KRVb0TIGDg8p4hndrRaON
         bPM27arrKAU+JpQ1vTmFa6e2dESFr+thf3sY/ETPvazq+MzTbWqNjpHboNczaMXqe3bX
         mqRw==
X-Gm-Message-State: AOAM533BgR35KNVQOuPlImRdBsgItf23usY9TvmMn8fTa3/mOUKAxmfw
        Mgd8cBt2GKSdF/64SM10yrgySHIQf3j0J1aLnCbz5A==
X-Google-Smtp-Source: ABdhPJw+dM1W6M353i8ytIfkTfAqnSaPWZ2KAo4J7ruuSLgE7Liwv37EY3rrV6tUPxizCJ565dVIz/6617AG9sTMgrI=
X-Received: by 2002:a02:70cf:: with SMTP id f198mr50759883jac.124.1637611389509;
 Mon, 22 Nov 2021 12:03:09 -0800 (PST)
MIME-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com> <20211120045046.3940942-9-seanjc@google.com>
In-Reply-To: <20211120045046.3940942-9-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 22 Nov 2021 12:02:58 -0800
Message-ID: <CANgfPd9PNYOvZ1L4rxUuiAVF+FCuAYMbgfojLu1OTWEr-74M_Q@mail.gmail.com>
Subject: Re: [PATCH 08/28] KVM: x86/mmu: Drop unused @kvm param from kvm_tdp_mmu_get_root()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 19, 2021 at 8:51 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Drop the unused @kvm param from kvm_tdp_mmu_get_root().  No functional
> change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 7 ++++---
>  arch/x86/kvm/mmu/tdp_mmu.h | 3 +--
>  2 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 4305ee8e3de3..12a28afce73f 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -129,9 +129,10 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
>                 next_root = list_first_or_null_rcu(&kvm->arch.tdp_mmu_roots,
>                                                    typeof(*next_root), link);
>
> -       while (next_root && !kvm_tdp_mmu_get_root(kvm, next_root))
> +       while (next_root && !kvm_tdp_mmu_get_root(next_root))
>                 next_root = list_next_or_null_rcu(&kvm->arch.tdp_mmu_roots,
> -                               &next_root->link, typeof(*next_root), link);
> +                                                 &next_root->link,
> +                                                 typeof(*next_root), link);
>
>         rcu_read_unlock();
>
> @@ -211,7 +212,7 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
>         /* Check for an existing root before allocating a new one. */
>         for_each_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
>                 if (root->role.word == role.word &&
> -                   kvm_tdp_mmu_get_root(kvm, root))
> +                   kvm_tdp_mmu_get_root(root))
>                         goto out;
>         }
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 3899004a5d91..599714de67c3 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -7,8 +7,7 @@
>
>  hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
>
> -__must_check static inline bool kvm_tdp_mmu_get_root(struct kvm *kvm,
> -                                                    struct kvm_mmu_page *root)
> +__must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
>  {
>         if (root->role.invalid)
>                 return false;
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
