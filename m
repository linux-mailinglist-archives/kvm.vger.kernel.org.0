Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F42C60FA73
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 16:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbiJ0Odz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 10:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234367AbiJ0Odv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 10:33:51 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7DA18982F
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 07:33:51 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 3-20020a17090a0f8300b00212d5cd4e5eso6564051pjz.4
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 07:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Th99Ltq5Y+36xmE1RZslN/6kaqbAEVsh5tTv0CHqHJU=;
        b=U00KASOoVyFwkGzNuVjZIbcfYjgpQNKvJ9qD3BXMrLpJ8M8wRmi9yT6lVAhgv/4mCK
         dP9gGqlppty4UUs6nhNCR/2j7Gko8Lf1CP3D/YjeXy37CvPa247V3ElP08S9g/U4REWD
         m/ibmPpRwi4es0am/BRxRFhOuCeHipzpn1fJaBclk+NZOfyKAc2QM/H87fefX1/HGwrr
         mbvRYmY3cj//loRBtoGubO++hAtq5Y7iRWAU9goP/T4kuezMVc0rMzgzyZUJRmcAbYTA
         /j8naF1ZvyiJ51dCEz47bCsohr3u5ik8OYoY/2GNnH24iGE1RyXMbWmySK9p8ye57dwx
         H6AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Th99Ltq5Y+36xmE1RZslN/6kaqbAEVsh5tTv0CHqHJU=;
        b=qQUWKYZDwuFgH8pPBK2amc1/VJZf/ohtNSjNgdvNejx36P0HN4hpLQRjLm0jlbhR6P
         axMws2JmaOs0n5C99LQHtK2tQ/dXQSWT6ANUdJ2pV1M91SsEzlkzMO84FfMMVTHgT9FI
         N3z9X9wrLKUFuWdGDzUMkt+9ruFPBVkrp+EMmGs9N0guK4NRsD7TyjTS/jWvBzTr3fAz
         FzvtxvdKUoP8Q1R9Tpz3TN0sCYYvA8WhXYN/YTn2py3FTOI7LGpcfMKJ+ERnzIm6zU8d
         ZaDc9oKL1aqJnk34PikKPjYy1EStkePLR3dMNpOc2gZ9n8vb2NV11zPte1yfJ6BuWnm9
         u6cw==
X-Gm-Message-State: ACrzQf1+G5RqaMnPUVu9w6cSqMHXrOQ8VtoPh7YYjAjgmslSviyXZrSz
        YEoUK51SIpu/lt205R3HcNJYIpMftrphSMWyoVV5ng==
X-Google-Smtp-Source: AMsMyM4g3mDCx8r1Ss9FlKEj96MfTjIFNxzlQZEF8JZ0DWlJRFbXfBXt/4+KSp7jq7K2syVC2z/f7J5F0w7tjl0HO7Q=
X-Received: by 2002:a17:902:9049:b0:180:7922:ce36 with SMTP id
 w9-20020a170902904900b001807922ce36mr51136823plz.30.1666881230636; Thu, 27
 Oct 2022 07:33:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220805135813.2102034-1-maz@kernel.org> <20220805135813.2102034-2-maz@kernel.org>
 <CAAeT=Fz55H09PWpmMu1sBkV=iUEHWezwhghJskaWAoqQsi2N0A@mail.gmail.com> <86zgdlms58.wl-maz@kernel.org>
In-Reply-To: <86zgdlms58.wl-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 27 Oct 2022 07:33:34 -0700
Message-ID: <CAAeT=FzbYp58Yw6QXqD92w4UMG8x+O81i6hoC+_jeOEL0vFjGA@mail.gmail.com>
Subject: Re: [PATCH 1/9] KVM: arm64: PMU: Align chained counter implementation
 with architecture pseudocode
To:     Marc Zyngier <maz@kernel.org>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
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

Hi Marc,

> > > +static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
> > > +                                     unsigned long mask, u32 event)
> > > +{
> > > +       int i;
> > > +
> > > +       if (!kvm_vcpu_has_pmu(vcpu))
> > > +               return;
> > > +
> > > +       if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E))
> > > +               return;
> > > +
> > > +       /* Weed out disabled counters */
> > > +       mask &= __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
> > > +
> > > +       for_each_set_bit(i, &mask, ARMV8_PMU_CYCLE_IDX) {
> > > +               u64 type, reg;
> > > +
> > > +               /* Filter on event type */
> > > +               type = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i);
> > > +               type &= kvm_pmu_event_mask(vcpu->kvm);
> > > +               if (type != event)
> > > +                       continue;
> > > +
> > > +               /* Increment this counter */
> > > +               reg = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) + 1;
> > > +               reg = lower_32_bits(reg);
> > > +               __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = reg;
> > > +
> > > +               if (reg) /* No overflow? move on */
> > > +                       continue;
> > > +
> > > +               /* Mark overflow */
> > > +               __vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(i);
> >
> > Perhaps it might be useful to create another helper that takes
> > care of just one counter (it would essentially do the code above
> > in the loop). The helper could be used (in addition to the above
> > loop) from the code below for the CHAIN event case and from
> > kvm_pmu_perf_overflow(). Then unnecessary execution of
> > for_each_set_bit() could be avoided for these two cases.
>
> I'm not sure it really helps. We would still need to check whether the
> counter is enabled, and we'd need to bring that into the helper
> instead of keeping it outside of the loop.

That's true. It seems that I overlooked that.
Although it appears checking with kvm_vcpu_has_pmu() is unnecessary
(redundant), the check with PMCR_EL0.E is necessary.

Thank you,
Reiji
