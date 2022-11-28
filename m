Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC7F63B3DB
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 22:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234358AbiK1VER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 16:04:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232877AbiK1VEP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 16:04:15 -0500
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828C02F3A0
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 13:04:13 -0800 (PST)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-142b72a728fso14585989fac.9
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 13:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SvghONPmEycpXKEDzwtsdLuUDXpxFtvRPy/fapLeKnM=;
        b=o6Fj92Ju3+pgrUluEjOukrmTz3rwVQBkHUKOWiMh+CCtPK+y6qtR41g5/BWfygTP7H
         xUpRHjDLcG7cuFrbXw8TXr69x1GdvsvseK297FDOzDJJLdDNGwalmuW64gj77vJWPzSN
         azsPUZ4/UR3WJFy8+gam07/CmoMo0RCIaRiwA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SvghONPmEycpXKEDzwtsdLuUDXpxFtvRPy/fapLeKnM=;
        b=UKkXNRiZCVLJuDufP5WpW/h/zztJ3ic0gNWdpLHwkOpYwkA1mOserMchNroiLEMsYv
         3tFpFoeCuBicAPXpPYeQkXpba0K/wfVYtlLxnIyNt9qow4ct9rmO6eggRdwgrcgV1xs/
         +NosbxABnfZECyGTDVYbEyDlDFJKfxQUTIX6mpnD1votoTTHWQhnbr23A4ZMwibpYzIx
         D1jG9f+/+mn4kLKl3TCbRctooEmVI2BO3edk/ILrcbUvjgs1F2ybPIxDLpPXe3pOdEBD
         qBsiRDdg9xmABNGrgeP0YltnvNgmPXbvPBgTuUvTLDC6ikU3LyFAHM5QfkFPH15U+5Ci
         EC0Q==
X-Gm-Message-State: ANoB5pnSByH0SluTIx4dzte4MwsjPQiDLzj8WCsVunvBCRL81DYhT7Jv
        TDJcAkcMYAjMFZ9kfNDkQp/gMglTP59gHqBR3xpK
X-Google-Smtp-Source: AA0mqf4co8CqCxZuftAiHxiWs+NzUxhecUpLAKa/YIcGpdqfE6qObE/kk6R8vBF+hyJylgsZJThVh7HMO8M18bmy204=
X-Received: by 2002:a05:6870:c18a:b0:142:870e:bd06 with SMTP id
 h10-20020a056870c18a00b00142870ebd06mr26804666oad.181.1669669452816; Mon, 28
 Nov 2022 13:04:12 -0800 (PST)
MIME-Version: 1.0
References: <20221128161424.608889-1-apatel@ventanamicro.com> <20221128161424.608889-3-apatel@ventanamicro.com>
In-Reply-To: <20221128161424.608889-3-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Mon, 28 Nov 2022 13:04:02 -0800
Message-ID: <CAOnJCUKPaFeHfgf2xYaE8tSK6wKqMntMHD-KnMr5n=vLxSC9+w@mail.gmail.com>
Subject: Re: [PATCH 2/9] RISC-V: KVM: Remove redundant includes of asm/kvm_vcpu_timer.h
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 28, 2022 at 8:14 AM Anup Patel <apatel@ventanamicro.com> wrote:
>
> The asm/kvm_vcpu_timer.h is redundantly included in vcpu_sbi_base.c
> so let us remove it.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/kvm/vcpu_sbi_base.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/vcpu_sbi_base.c b/arch/riscv/kvm/vcpu_sbi_base.c
> index 48f431091cdb..22b9126e2872 100644
> --- a/arch/riscv/kvm/vcpu_sbi_base.c
> +++ b/arch/riscv/kvm/vcpu_sbi_base.c
> @@ -12,7 +12,6 @@
>  #include <linux/version.h>
>  #include <asm/csr.h>
>  #include <asm/sbi.h>
> -#include <asm/kvm_vcpu_timer.h>
>  #include <asm/kvm_vcpu_sbi.h>
>
>  static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> --
> 2.34.1
>

Reviewed-by: Atish Patra <atishp@rivosinc.com>

-- 
Regards,
Atish
