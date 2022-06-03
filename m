Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDD753C421
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 07:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240382AbiFCFXp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 01:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235344AbiFCFXo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 01:23:44 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967EFEAA
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 22:23:42 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id k11so9131014oia.12
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 22:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WzoFXntAxDsmUFhrpSN0lydvB+GY7yOTwcwlnFeu8rY=;
        b=cDX1z3L55FaZQ0li/2NABGuvZQyvjAqV+mY2GlCyFa5u97/2e33Jq96U0qmoLghctm
         5GP1pn3Im95P2noRUSsP4jMGfKhVGu/wtPGSZcVLj2kkpTlQuFl5kBNQD/OZ83qAuU6g
         0itfRy6UbiuNxrzOIdfKQebbdyu07JlOyc4y7Q5kSQRaOgNbU9vc0avrBsuMOkgXQ+S4
         yEA0gyK51HTDVMj/ih70oU7ulvB3yWtlYfg2RRAg7fYWss0yZ3U93FQZKEouD20Zh417
         +UNSKGp7HfokN03K4UEzG7nVgpMjkENcfzRrGddIaKJZ8xAC6DmA9fRLiBh/L+ZPF6ED
         G9gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WzoFXntAxDsmUFhrpSN0lydvB+GY7yOTwcwlnFeu8rY=;
        b=RdfIptRbnRiRZg+bPOncIMHeUXc2v+LnZpeEmOd6zQohNsrFUiSOXUwmXsv21WgMPa
         NVOr1J1lbwhy+z8HFPVn0yL6o/jTdAUaNds9n/bm8ak0DR33ISujvivbCjzsva73efi0
         IiC3KAw865DDxfCqVJbuLO66yvIJ3d177tsFVrKMKaUIevTfexznLXjlh7hSmqppU8bv
         zPlMqsGNn4qidYodxY6J2VvM+v5kED9ov/4UcM7T+fkxhRMlRkHBlPDyJIEzyoldVNcM
         /oTn/1VX2gB6zOK46d8dsxXMQdfNj7LEeLoEkTGhfaEOqE9qeT5rRMjtbXYhazpVUBj2
         z0XQ==
X-Gm-Message-State: AOAM533WNl7AOKolJVii6ne+zAj+znnyJH7vOKZxSkW4T4/yG/eECmxN
        r4HJQdjVOACyq8EFRsINm+FTW3cfJwd3iutI2iZlyA==
X-Google-Smtp-Source: ABdhPJzJos2xkVCVqdPnVrVWhwf2C8SCrcNh90O1+X0s17dXtFigyJz4zZMj4J/ZSP/5Utgr5FClDToyr9C7HgI430I=
X-Received: by 2002:a05:6808:144d:b0:32b:7fbc:943d with SMTP id
 x13-20020a056808144d00b0032b7fbc943dmr20056912oiv.107.1654233821610; Thu, 02
 Jun 2022 22:23:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220528113829.1043361-1-maz@kernel.org> <20220528113829.1043361-4-maz@kernel.org>
In-Reply-To: <20220528113829.1043361-4-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 2 Jun 2022 22:23:25 -0700
Message-ID: <CAAeT=FxmD4Nsrodr-FCjpNghAormCg4P+R7hF3+g_wfQ5T12Rg@mail.gmail.com>
Subject: Re: [PATCH 03/18] KVM: arm64: Drop FP_FOREIGN_STATE from the
 hypervisor code
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kernel-team@android.com, Will Deacon <will@kernel.org>,
        Mark Brown <broonie@kernel.org>
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

On Sat, May 28, 2022 at 4:38 AM Marc Zyngier <maz@kernel.org> wrote:
>
> The vcpu KVM_ARM64_FP_FOREIGN_FPSTATE flag tracks the thread's own
> TIF_FOREIGN_FPSTATE so that we can evaluate just before running
> the vcpu whether it the FP regs contain something that is owned
> by the vcpu or not by updating the rest of the FP flags.
>
> We do this in the hypervisor code in order to make sure we're
> in a context where we are not interruptible. But we already
> have a hook in the run loop to generate this flag. We may as
> well update the FP flags directly and save the pointless flag
> tracking.
>
> Whilst we're at it, rename update_fp_enabled() to guest_owns_fp_regs()
> to indicate what the leftover of this helper actually do.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>


> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -107,16 +107,19 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
>  }
>
>  /*
> - * Called just before entering the guest once we are no longer
> - * preemptable. Syncs the host's TIF_FOREIGN_FPSTATE with the KVM
> - * mirror of the flag used by the hypervisor.
> + * Called just before entering the guest once we are no longer preemptable
> + * and interrupts are disabled. If we have managed to run anything using
> + * FP while we were preemptible (such as off the back of an interrupt),
> + * then neither the host nor the guest own the FP hardware (and it was the
> + * responsibility of the code that used FP to save the existing state).
> + *
> + * Note that not supporting FP is basically the same thing as far as the
> + * hypervisor is concerned (nothing to save).
>   */
>  void kvm_arch_vcpu_ctxflush_fp(struct kvm_vcpu *vcpu)
>  {
> -       if (test_thread_flag(TIF_FOREIGN_FPSTATE))
> -               vcpu->arch.flags |= KVM_ARM64_FP_FOREIGN_FPSTATE;
> -       else
> -               vcpu->arch.flags &= ~KVM_ARM64_FP_FOREIGN_FPSTATE;
> +       if (!system_supports_fpsimd() || test_thread_flag(TIF_FOREIGN_FPSTATE))
> +               vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED | KVM_ARM64_FP_HOST);
>  }

Although kvm_arch_vcpu_load_fp() unconditionally sets KVM_ARM64_FP_HOST,
perhaps having kvm_arch_vcpu_load_fp() set KVM_ARM64_FP_HOST only when
FP is supported might be more consistent?
Then, checking system_supports_fpsimd() is unnecessary here.
(KVM_ARM64_FP_ENABLED is not set when FP is not supported)

Thanks,
Reiji
