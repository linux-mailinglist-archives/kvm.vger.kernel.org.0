Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4FC0656E7A
	for <lists+kvm@lfdr.de>; Tue, 27 Dec 2022 20:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiL0T4l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Dec 2022 14:56:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiL0T4b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Dec 2022 14:56:31 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3FD9EA6
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 11:56:30 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id r2-20020a9d7cc2000000b006718a7f7fbaso8751422otn.2
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 11:56:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vXpGIBP6w9zEBC9pDTauVygxnlfryd9P3gGOlL7tHmA=;
        b=LIVLbP5c+kJ/mNQb8FdCoHZVeAYFDPQSO0XAMppnllDbXEDu7ljUsgyRMsqfOiG+oV
         XIg/WXxHoAv/TA6QPmGbGQWyROSscenOvJzSVewGYWAK7Uc8WU7T8PZMP47rCWpW0HWm
         uwNhRZiPLdHcOa/WfQRu0QOVMoEowLVJI5/CJCRgx+WvX/Bbwo0K/UeQgZMoCw9yA4vp
         OzCA+5kZWlPPr/SzrW6/oD0JWH6gX0z0Xg/Jz+5Y2zunB3ZkELAhin+FDrwTE7nf4FMC
         DTLFDHDAIar1Y8Pf/TK2Lpim0RlrFwSXx5OyayiKoEiCe1QwnD+qfK8aS+eLVIBb6aN6
         BE5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vXpGIBP6w9zEBC9pDTauVygxnlfryd9P3gGOlL7tHmA=;
        b=6hSavq+AarIuHBRACcoiWp7X5HfnUjbhooC9RCzW9N+emzHfsaIxRx2PmOBxCjuPJg
         rd6y4mxkEpgg+esRqQCp3Zs+4tm9Jwvp6abm8r5MSU0Eb3S5bsD3tQ8YaMXK75Aof6KS
         qrJvg+NTaEMZBZOWTb2u2Qli2eve7q/XBGVQv4zUZ9mJI+tYNqrhwd1WHZSsXRypgKls
         48AVcEOlqvVOEXjFLgiyvWz7cj3seSkEoPe+mLx0OVMvqcvnT4hnODa0h8ycRdMW7GNb
         K52DNknYiPyJVo/YtCh+DwflZ2yrNO3Z6u158aCZc9nH0JkOitKZ8v4rSL5cxp48ENJ2
         Aw0g==
X-Gm-Message-State: AFqh2koxKVJ1iTK6Q+3cAuGgsfpQ3Tc0EabEYoStdhzkiwM1ndltj2rJ
        2HbfSfAJ58PFzASVYKoAXxvq8jXUvCO6Klqlev28hw==
X-Google-Smtp-Source: AMrXdXvMPIV1qvrugbZP8LqHFhQD9IjB2prziXwoGg4Y6n/LSxpGVYPDCHJmwn/zj21mxXN98/+cz5RFDLoJdt9h9G4=
X-Received: by 2002:a9d:6d84:0:b0:66c:a613:9843 with SMTP id
 x4-20020a9d6d84000000b0066ca6139843mr1647765otp.8.1672170989830; Tue, 27 Dec
 2022 11:56:29 -0800 (PST)
MIME-Version: 1.0
References: <20221227183713.29140-1-aaronlewis@google.com> <20221227183713.29140-2-aaronlewis@google.com>
In-Reply-To: <20221227183713.29140-2-aaronlewis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 27 Dec 2022 11:56:18 -0800
Message-ID: <CALMp9eRidX1TkpdLzzLyC6HhREhPsPeh2MZ5itoLbv3ik+a29g@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: x86: Clear XTILE_CFG if XTILE_DATA is clear
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        like.xu.linux@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 27, 2022 at 10:38 AM Aaron Lewis <aaronlewis@google.com> wrote:
>
> Be good citizens by clearing both
> CPUID.(EAX=0DH,ECX=0):EAX.XTILECFG[bit-17] and
> CPUID.(EAX=0DH,ECX=0):EAX.XTILEDATA[bit-18] if they are both not set.
> That way userspace or a guest doesn't fail if it attempts to set XCR0
> with the user xfeature bits, i.e. EDX:EAX of CPUID.(EAX=0DH,ECX=0).
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 0b5bf013fcb8e..2d9910847786a 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -977,6 +977,10 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>                 u64 permitted_xcr0 = kvm_caps.supported_xcr0 & xstate_get_guest_group_perm();
>                 u64 permitted_xss = kvm_caps.supported_xss;
>
> +               if (!(permitted_xcr0 & XFEATURE_MASK_XTILE_CFG) ||
> +                   !(permitted_xcr0 & XFEATURE_MASK_XTILE_DATA))
> +                       permitted_xcr0 &= ~XFEATURE_MASK_XTILE;
> +
>                 entry->eax &= permitted_xcr0;
>                 entry->ebx = xstate_required_size(permitted_xcr0, false);
>                 entry->ecx = entry->ebx;
> --
> 2.39.0.314.g84b9a713c41-goog
>

Two questions:

1) Under what circumstances would this happen?
2) Shouldn't we also clear XFEATURE_MASK_CFG if both bits are not set?
