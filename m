Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C686C51956C
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 04:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344007AbiEDCTI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 22:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243551AbiEDCTG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 22:19:06 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BEEC2BB20
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 19:15:31 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id w187so210907ybe.2
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 19:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c5B5hkcsMKdDxIP0ityCzhRmvMG1VC+HFykgkdqu09U=;
        b=SZfd803uo15kK66O/NlAk5XNFnbID7ZOAD3KZPSJujtLzKFGMVvU6o5VPAlUvxyn+3
         NMFa1yCnfttudlWnJWcoXZABDL3Jeyan6z9d1fBaAr/qznMS/ktE4+xvkpw4I5OqKBWd
         fBN1mc/S654rSyP51bV1T035KI5ONmgovVvrI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c5B5hkcsMKdDxIP0ityCzhRmvMG1VC+HFykgkdqu09U=;
        b=dZ6BPI2S6v0RZrfcCQkSw2OKNCxBuu7onFehHdE45cFSPAtsbdqwixj5uahkm81pnh
         2dhTLijWB10+BvToK8/NwhSIqABFmX0T87QowVWPAvvruhBQ0qWIgmvP7ILPVsoiWhRO
         56hnQhgvUiYFDF1GSUAfhToA2NuMhqnbUnGGPYTTWR3FJyk07Tafd0TalVHOQzE4C/WJ
         UaBJ/X/Vbaew3Sn508n2O9nmTTJuhpl8aMCuXwZvhPEkSlO35Y2TTFnz+vcIzvTUMV9i
         c43ntNks53UQwU4eLWm4XuZAJLzap+jXPOHxGSMqtvTXfCmLVpLXmEmLwwyRzb89Rpry
         CqhQ==
X-Gm-Message-State: AOAM533FP28mhBbDzLk9k5YDy6/VfNIAuZoGY5to9K/5fYzBEKLIVQoh
        TLOr3sgaA6j0EYobRXUSucftnyFuegRYqjXo+z69
X-Google-Smtp-Source: ABdhPJzzW0cIF1J0ZWV6KCLxVfMG8MOvXPpwHtk2SUtqsQQxYUN8p+PNE8DoWlFM3bD79C4kiVsszGg1ntn5lWE6FaI=
X-Received: by 2002:a25:32d3:0:b0:648:5929:845f with SMTP id
 y202-20020a2532d3000000b006485929845fmr15443858yby.53.1651630530878; Tue, 03
 May 2022 19:15:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220420112450.155624-1-apatel@ventanamicro.com> <20220420112450.155624-6-apatel@ventanamicro.com>
In-Reply-To: <20220420112450.155624-6-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Tue, 3 May 2022 19:15:20 -0700
Message-ID: <CAOnJCU+yd7hqauHRYwnPqNKEgfy5FK06ezR64aH0Hm2AcNNadw@mail.gmail.com>
Subject: Re: [PATCH v2 5/7] RISC-V: KVM: Reduce KVM_MAX_VCPUS value
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 20, 2022 at 4:25 AM Anup Patel <apatel@ventanamicro.com> wrote:
>
> Currently, the KVM_MAX_VCPUS value is 16384 for RV64 and 128
> for RV32.
>
> The KVM_MAX_VCPUS value is too high for RV64 and too low for
> RV32 compared to other architectures (e.g. x86 sets it to 1024
> and ARM64 sets it to 512). The too high value of KVM_MAX_VCPUS
> on RV64 also leads to VCPU mask on stack consuming 2KB.
>
> We set KVM_MAX_VCPUS to 1024 for both RV64 and RV32 to be
> aligned other architectures.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_host.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index 806f74dc0bfc..61d8b40e3d82 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -16,8 +16,7 @@
>  #include <asm/kvm_vcpu_fp.h>
>  #include <asm/kvm_vcpu_timer.h>
>
> -#define KVM_MAX_VCPUS                  \
> -       ((HGATP_VMID_MASK >> HGATP_VMID_SHIFT) + 1)
> +#define KVM_MAX_VCPUS                  1024
>
>  #define KVM_HALT_POLL_NS_DEFAULT       500000
>
> --
> 2.25.1
>

Reviewed-by: Atish Patra <atishp@rivosinc.com>

-- 
Regards,
Atish
