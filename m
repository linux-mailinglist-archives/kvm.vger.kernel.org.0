Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 034D550827A
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 09:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376331AbiDTHq5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 03:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237020AbiDTHqm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 03:46:42 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2423BBE5
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 00:43:54 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-2ef5380669cso9023397b3.9
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 00:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4rECfG0J0jcZuxwrgwhg30CvDbd+wKJQrKHF5lEEWz8=;
        b=JJ84zEuWmJdIZ7TstEV8XP6tov0sYCEo450P8hEILZNpuvqlc8LvmWDw8vMK9BIzyx
         p80wG38wyBCDllGZ8kRIEVtDhjYvl5nJhws3qJnrkrbECz8bby3fQzPYKA5RPVLCLzfJ
         eni5YMWY7Iu1XUrIumWZfAM5TinCUnaEoTBPI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4rECfG0J0jcZuxwrgwhg30CvDbd+wKJQrKHF5lEEWz8=;
        b=BZmlEyGlqC6rHa6jYpPWwDK+fGtsGghkjVt9kouTYyI+gBM07rsO2n/tb6oVwVxrP0
         cZrRsSQkS8ccXFcTIXWKMjJTZwVOY9JGB8QGPEs9SwxmaGCMfct3ZlrJwmJmAHu4cn03
         5gRN1Qo0h9iuf14chmNIB9eaDudcTibHGIGSzj7+rSbUScNSHkRRvQ921QYKVgUGASWu
         SQhA5ZXADhiapQ1FiV2DQdsXZaTn+Ge2ol5c+r04ErwXOsd1Zs2cJuJbj2+GTppP+E5y
         sK6BG4jSMpt2HohHbRL3jvIsTD1vjNHwy8ky2UAGDjUDOk5oFlDnOTaTMI/DG6nadJ1P
         a5nQ==
X-Gm-Message-State: AOAM532pj0Jc6DEAuYkhLM/Xut9JhCV/di8sKkL1rCESW2kstk19KfnS
        z78JyGQicricm0747ftB0TzeR3Br8K0cXtsDuVKe
X-Google-Smtp-Source: ABdhPJwC6ND2mFoDrO8/LZH+VaOdsYNDA7F6jKsenEvyVuoe+DYFot+AtDlzxrI+mCwBEaCI0C4EwGHyNVH1lr+kPjQ=
X-Received: by 2002:a81:5285:0:b0:2ec:471:e745 with SMTP id
 g127-20020a815285000000b002ec0471e745mr19863668ywb.443.1650440633909; Wed, 20
 Apr 2022 00:43:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220420013258.3639264-1-atishp@rivosinc.com> <20220420013258.3639264-2-atishp@rivosinc.com>
In-Reply-To: <20220420013258.3639264-2-atishp@rivosinc.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Wed, 20 Apr 2022 00:43:43 -0700
Message-ID: <CAOnJCU+r8KhhQP-LZN+oGGCDkdQt9ZbF+LCTtZWY8r=qwmSOng@mail.gmail.com>
Subject: Re: [PATCH 1/2] RISC-V: KVM: Remove 's' & 'u' as valid ISA extension
To:     Atish Patra <atishp@rivosinc.com>
Cc:     KVM General <kvm@vger.kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        devicetree <devicetree@vger.kernel.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Rob Herring <robh+dt@kernel.org>, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 19, 2022 at 6:33 PM Atish Patra <atishp@rivosinc.com> wrote:
>
> There are no ISA extension defined as 's' & 'u' in RISC-V specifications.
> The misa register defines 's' & 'u' bit as Supervisor/User privilege mode
> enabled. But it should not appear in the ISA extension in the device tree.
>
> Remove those from the allowed ISA extension for kvm.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/kvm/vcpu.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 6785aef4cbd4..2e25a7b83a1b 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -43,9 +43,7 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
>                                  riscv_isa_extension_mask(d) | \
>                                  riscv_isa_extension_mask(f) | \
>                                  riscv_isa_extension_mask(i) | \
> -                                riscv_isa_extension_mask(m) | \
> -                                riscv_isa_extension_mask(s) | \
> -                                riscv_isa_extension_mask(u))
> +                                riscv_isa_extension_mask(m))
>
>  static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
>  {
> --
> 2.25.1
>

Sorry. Forgot to add the fixes tag.

Fixes: a33c72faf2d7 (RISC-V: KVM: Implement VCPU create, init and
destroy functions)

-- 
Regards,
Atish
