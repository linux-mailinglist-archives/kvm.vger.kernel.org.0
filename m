Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214C44A5E0B
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 15:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239125AbiBAOOl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 09:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239062AbiBAOOj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 09:14:39 -0500
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A377BC061714
        for <kvm@vger.kernel.org>; Tue,  1 Feb 2022 06:14:39 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id b15-20020a4a878f000000b002dccc412166so4155602ooi.11
        for <kvm@vger.kernel.org>; Tue, 01 Feb 2022 06:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0Mv4cSUeeZweAnsTUqHW1wUxBTbYbtVcIHd+m/V5bGY=;
        b=fCCNxq817wuHQ5Hn6FTacPjcK+/v53kFh+ve+RyVcCTl2IImJNlBc4v9ZWuz7GHzBG
         hZXiRsmVBAn83cRk3DvYCZw0iixXJ/SjeLeIKfD6ReQEE4rQAfzSYUks1JwL6RDNCS0B
         tTrU4+GdmPOQ9b50/Tor9wI+iPKsH9NqYJtnJkG/eO0gNrHOiy6MuNiqTHPbakMZ7nDC
         sYYAguuq7dKuQ+sPHxbM3CMdhDYcUkJ/O6l8MzkPxf6ZGCrkwHwUyqBMXumAKXrglZmB
         bBHTacSaxw4YmH30TKTHRbgz8ucxl+vvk4YeWwmdH3leORh2dRhMJxwd831YzwjtPPGD
         8MfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0Mv4cSUeeZweAnsTUqHW1wUxBTbYbtVcIHd+m/V5bGY=;
        b=NO2EsVC4waJF9RRUtOQPlECXh76zlhFzEKXBkP0AebngO1z/+cS/SIr2Rw5Ucji3HA
         l6YoY19bQ2bVjRrUxvzS0wm9Gkil2Exxr7BfmJ0yZGNCfklnYEWaNXpIzFpZ1mL15Bk/
         emy5AhvLvG3+GDciTUMEf8ySeCWpl6SoCX7MqEzOrMYk9CBD30hMhZQJmReEM3eigj+U
         cPtzOpV2PWv/W6Aeq+av/QjkKzk+3qcXiBFWYy+WPCuNxhg/YaX/ckxvfHWYoH3zzaNM
         4xjsSjCyfpZ9frDBAn7X7ukWLdVAiLViEF/J0Dj00FGyBsk5SlO2MIkGMEl/Jo5WG6FO
         XcjQ==
X-Gm-Message-State: AOAM530wPGobGOVJHfJs0dhpyQ2MjQuaGS1dhZBucyDovDuoX7dIOZkt
        zUFLbWFbhlzdND0/t0X7rJNVmFNVrPeMSRzyqIyPbQ==
X-Google-Smtp-Source: ABdhPJxgxV32gOPH0Pj3ssxlVkD9gYwHxKl1vEQqOy/sFPwMIt/lSCEnnpsJKSJLfZZnQKuvk0/voIHWnwUup9EJpU0=
X-Received: by 2002:a4a:a3c1:: with SMTP id t1mr8840770ool.31.1643724878826;
 Tue, 01 Feb 2022 06:14:38 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com> <20220106042708.2869332-5-reijiw@google.com>
 <CA+EHjTxCWe2pFNhq+9gRUJ0RnjX4OcuV2WazDbProUaJE2ZTBg@mail.gmail.com> <CAAeT=FzBC+1P3jNuLvF_tLwy-aQehPyJXJ3dmAsijB8=ky-ZKA@mail.gmail.com>
In-Reply-To: <CAAeT=FzBC+1P3jNuLvF_tLwy-aQehPyJXJ3dmAsijB8=ky-ZKA@mail.gmail.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Tue, 1 Feb 2022 14:14:02 +0000
Message-ID: <CA+EHjTzK_We_vwu6QbR3N4J5wJqF00fKm6rf6X8RA_4Mjg=VXw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 04/26] KVM: arm64: Make ID_AA64PFR0_EL1 writable
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

...

> > > diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> > > index 0a06d0648970..28d9bf0e178c 100644
> > > --- a/arch/arm64/kvm/vgic/vgic-init.c
> > > +++ b/arch/arm64/kvm/vgic/vgic-init.c
> > > @@ -116,6 +116,11 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
> > >         else
> > >                 INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
> > >
> > > +       if (type == KVM_DEV_TYPE_ARM_VGIC_V3)
> > > +               /* Set ID_AA64PFR0_EL1.GIC to 1 */
> > > +               (void)kvm_set_id_reg_feature(kvm, SYS_ID_AA64PFR0_EL1,
> > > +                                    ID_AA64PFR0_GIC3, ID_AA64PFR0_GIC_SHIFT);
> > > +
> >
> > If this fails wouldn't it be better to return the error?
>
> This should never fail because kvm_vgic_create() prevents
> userspace from running the first KVM_RUN for any vCPUs
> while it calls kvm_set_id_reg_feature().
> So, I am thinking of adding WARN_ON_ONCE() for the return value
> rather than adding an unnecessary error handling.

Consider this to be a nit from my part, as I don't have any strong
feelings about this, but kvm_vgic_create() already returns an error if
there's a problem. So I don't think that that would be imposing any
additional error handling.

Thanks,
/fuad

> Thanks,
> Reiji
