Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC56E54372C
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 17:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244207AbiFHPVh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 11:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245358AbiFHPUW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 11:20:22 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F94F129C1F
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 08:17:40 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id i66so28406276oia.11
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 08:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VlFFsM0vokhDlBPR30yxEKtEVSOVohVHRPtlqVM7p4c=;
        b=NXMtuu4RASXFiLHNwNTM2NV/7eIyypEdCAzOxvmY3JUnnnQJFRDGvSRq/OfW7W8HiL
         xy+WWDZjp9bUHiz/qLV4UEX8zVWjQMhliROaWK27VZ6z1Mxkyr4YvJOPOOt47iKx2Y8a
         mdxMkgIgPfE+B4lVYWo8ltVL0dV8qNGV+3MBhCok1TQabTCpD+mSeZeB/K/n5hctyrlI
         djasKhQNBlnNq1fY3grB/0wQrBYNkGZcYAZn8OE5obUdZAgN47EVlv/Mm85DDi5U82Nc
         ELhJRFzr5PykyL8LEt5IZ6PBKeuzQqsRkN/TNxn+PMb3qQ6CPdFyxf/sN3jg5qUVHJpk
         SDgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VlFFsM0vokhDlBPR30yxEKtEVSOVohVHRPtlqVM7p4c=;
        b=kH2sgg+WznwqLsx76eqIaVHVyJ9fYopJ6pOytDMxHmCs5WtKZYpJF2bjgfBx5sPOGT
         GhBp0wFMTCvr5Fe78UibXDxQvNM2xJuXJKmVTioNDdmNKfj31rQxbjrVwuCeGn64UBnT
         DaTpU+zwhfDF8zgOXgV2yV8U7ZeUYQmcKVtSbJBEaG6RfdQ4xyGFOyDHJH+sC+h4Ocol
         +km7BjiGTrtHhHT5QO2fmWBLXiS6WENsIxyL73l2LqVJY8VQLwGn50xslExRxOvwJitV
         XUDAO0yQ4GS12UzmVDlH1c05b9659V2uSVrGrjmql7YW9sN3appavFDyl3eXJ4LyWWgu
         xjng==
X-Gm-Message-State: AOAM531zbgFOcdQYm6yVLPmHZO41vfsriMfa6J8EubijOP4KuuEEOAvW
        8xviW6tLAdhr9sdFmt9Ij3u1RIAvQrcv+Ji7CiKtMQ==
X-Google-Smtp-Source: ABdhPJxnpsuzj2vDd3Hr296o3dKVf0rqE6EvPPFUkQ3V1TX/N0nEd0b4JHWjPSVChOaJdBvJ3B1fyhijGVQUOJ2IcoI=
X-Received: by 2002:a05:6808:19a7:b0:32b:3cef:631 with SMTP id
 bj39-20020a05680819a700b0032b3cef0631mr2749669oib.294.1654701451827; Wed, 08
 Jun 2022 08:17:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220528113829.1043361-1-maz@kernel.org> <20220528113829.1043361-16-maz@kernel.org>
In-Reply-To: <20220528113829.1043361-16-maz@kernel.org>
From:   Fuad Tabba <tabba@google.com>
Date:   Wed, 8 Jun 2022 16:16:55 +0100
Message-ID: <CA+EHjTyW62HaJdH_L1RMBzQpzkNbFBAYpXQ-y_Wg4u1a2eVJwA@mail.gmail.com>
Subject: Re: [PATCH 15/18] KVM: arm64: Warn when PENDING_EXCEPTION and
 INCREMENT_PC are set together
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Mark Brown <broonie@kernel.org>, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Sat, May 28, 2022 at 12:49 PM Marc Zyngier <maz@kernel.org> wrote:
>
> We really don't want PENDING_EXCEPTION and INCREMENT_PC to ever be
> set at the same time, as they are mutually exclusive. Add checks
> that will generate a warning should this ever happen.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 1 +
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c   | 2 ++
>  arch/arm64/kvm/inject_fault.c        | 8 ++++++++
>  3 files changed, 11 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 46e631cd8d9e..861fa0b24a7f 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -473,6 +473,7 @@ static inline unsigned long vcpu_data_host_to_guest(struct kvm_vcpu *vcpu,
>
>  static __always_inline void kvm_incr_pc(struct kvm_vcpu *vcpu)
>  {
> +       WARN_ON(vcpu_get_flag(vcpu, PENDING_EXCEPTION));
>         vcpu_set_flag(vcpu, INCREMENT_PC);
>  }
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> index 2841a2d447a1..04973984b6db 100644
> --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> @@ -38,6 +38,8 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
>         *vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
>         *vcpu_cpsr(vcpu) = read_sysreg_el2(SYS_SPSR);
>
> +       WARN_ON(vcpu_get_flag(vcpu, INCREMENT_PC));
> +
>         vcpu_set_flag(vcpu, PENDING_EXCEPTION);
>         vcpu_set_flag(vcpu, EXCEPT_AA64_EL1_SYNC);
>
> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> index a9a7b513f3b0..2f4b9afc16ec 100644
> --- a/arch/arm64/kvm/inject_fault.c
> +++ b/arch/arm64/kvm/inject_fault.c
> @@ -20,6 +20,8 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
>         bool is_aarch32 = vcpu_mode_is_32bit(vcpu);
>         u32 esr = 0;
>
> +       WARN_ON(vcpu_get_flag(vcpu, INCREMENT_PC));
> +

Minor nit: While we're at it, should we just create a helper for
setting PENDING_EXCEPTION, same as we have for INCREMENT_PC? That
might make the code clearer and save us from the hassle of having this
WARN_ON before every instance of setting PENDING_EXCEPTION?

Cheers,
/fuad



>         vcpu_set_flag(vcpu, PENDING_EXCEPTION);
>         vcpu_set_flag(vcpu, EXCEPT_AA64_EL1_SYNC);
>
> @@ -51,6 +53,8 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
>  {
>         u32 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
>
> +       WARN_ON(vcpu_get_flag(vcpu, INCREMENT_PC));
> +
>         vcpu_set_flag(vcpu, PENDING_EXCEPTION);
>         vcpu_set_flag(vcpu, EXCEPT_AA64_EL1_SYNC);
>
> @@ -71,6 +75,8 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
>
>  static void inject_undef32(struct kvm_vcpu *vcpu)
>  {
> +       WARN_ON(vcpu_get_flag(vcpu, INCREMENT_PC));
> +
>         vcpu_set_flag(vcpu, PENDING_EXCEPTION);
>         vcpu_set_flag(vcpu, EXCEPT_AA32_UND);
>  }
> @@ -94,6 +100,8 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt, u32 addr)
>
>         far = vcpu_read_sys_reg(vcpu, FAR_EL1);
>
> +       WARN_ON(vcpu_get_flag(vcpu, INCREMENT_PC));
> +
>         if (is_pabt) {
>                 vcpu_set_flag(vcpu, PENDING_EXCEPTION);
>                 vcpu_set_flag(vcpu, EXCEPT_AA32_IABT);
> --
> 2.34.1
>
