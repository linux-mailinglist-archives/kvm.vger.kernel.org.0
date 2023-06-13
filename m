Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8188A72E7D6
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 18:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240478AbjFMQGc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 12:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239346AbjFMQGa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 12:06:30 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3FC01721
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 09:06:29 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-bc68c4e046aso3177516276.0
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 09:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686672389; x=1689264389;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qSQDwhzYJY7tobD4czU+pyoTs1hJWVefOdasiCdvdec=;
        b=7JZwNsEgQrxs9spaTdwXX2Di3yo5WPOgDQ55PEAhk/K3pspHhwT4fd+ubWREmWxa6c
         JFuI+CGBrhKi5g0AM4cw0JOtjmpQjDDCxgajP//aA/FKIedVMGNUJEPfjOfaeqk/FAsw
         f9GsrmYsDeV95H+jllKNDH1ovIVytMq36I1+BWMhQ5p4pGoK7s/Uld5Y/vM3TXkpR/Gn
         eR4KhQCEA8bdGfV6xPPRzT9EV7UNtqvJw1PT8FBSGc+2/CEEdWpEK09IQWmWgIwEd0+9
         VWg4vT4MBsiCegzGIwhjVJIwH5PeW5mRWf/ZowU767J5m4p08jehbcfVtueNmcTlioA6
         61ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686672389; x=1689264389;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qSQDwhzYJY7tobD4czU+pyoTs1hJWVefOdasiCdvdec=;
        b=d4rav9Ysw53HhqgFJvYCCsC3I7kOaebGIUto7UN05lKyWjCUc3w5LR9ov6bS+XFlA2
         wfPwEzpXI05yUcKGiCYr6B+3cTbbbSt2bAbrxk4+GILNpFtifSgQBkhquzXz+TgsMYS8
         DrYwDJeWll3nN/y0Mtl4KkzTHb/ufzArYjd9SlTS9Rt8VFz231CyZnesCqiRGzBIZ2Iw
         8euvGqB8qONfQPSePSzX/2CdaXizhz0k7zQoNJrQghoutcvkwg6qTFYSyMkMqGpApOEP
         zKcl+GcCFV3Y+ZpR5wZiaBfTxmxNkv0fJtwY7okJ3nDsHEvnYig4iCAS3ZAVoAgpcgCn
         sG4Q==
X-Gm-Message-State: AC+VfDz3mOOT62hpKBfQg224N9W+ZvSjsL490FU+MCOZBpEeu/xxAx/a
        iOl2SGinJghlo0aXp8G+gqaaDIYDjL8=
X-Google-Smtp-Source: ACHHUZ5t1fBiSR/tYb00iWy9UK0OHpyz0u1GPadvHcGNxc5YGmkhV9HnKH0b/w5BmC0fEJM2S3Us09Z6T0Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1682:b0:bca:629b:6f33 with SMTP id
 bx2-20020a056902168200b00bca629b6f33mr1049253ybb.5.1686672389135; Tue, 13 Jun
 2023 09:06:29 -0700 (PDT)
Date:   Tue, 13 Jun 2023 09:06:27 -0700
In-Reply-To: <fd000efe-315f-a2c7-b42b-7ebbce922928@linux.intel.com>
Mime-Version: 1.0
References: <20230607004636.1421424-1-seanjc@google.com> <fd000efe-315f-a2c7-b42b-7ebbce922928@linux.intel.com>
Message-ID: <ZIiUAz7VIBughj/J@google.com>
Subject: Re: [PATCH] KVM: x86: Update comments about MSR lists exposed to userspace
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 07, 2023, Binbin Wu wrote:
> 
> 
> On 6/7/2023 8:46 AM, Sean Christopherson wrote:
> > Refresh comments about msrs_to_save, emulated_msrs, and msr_based_features
> > to remove stale references left behind by commit 2374b7310b66 (KVM:
> > x86/pmu: Use separate array for defining "PMU MSRs to save"), and to
> > better reflect the current reality, e.g. emulated_msrs is no longer just
> > for MSRs that are "kvm-specific".
> > 
> > Reported-by: Binbin Wu <binbin.wu@linux.intel.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/x86.c | 27 +++++++++++++--------------
> >   1 file changed, 13 insertions(+), 14 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 5ad55ef71433..c77f72cf6dc8 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -1427,15 +1427,14 @@ int kvm_emulate_rdpmc(struct kvm_vcpu *vcpu)
> >   EXPORT_SYMBOL_GPL(kvm_emulate_rdpmc);
> >   /*
> > - * List of msr numbers which we expose to userspace through KVM_GET_MSRS
> > - * and KVM_SET_MSRS, and KVM_GET_MSR_INDEX_LIST.
> > - *
> > - * The three MSR lists(msrs_to_save, emulated_msrs, msr_based_features)
> > - * extract the supported MSRs from the related const lists.
> > - * msrs_to_save is selected from the msrs_to_save_all to reflect the
> > - * capabilities of the host cpu. This capabilities test skips MSRs that are
> > - * kvm-specific. Those are put in emulated_msrs_all; filtering of emulated_msrs
> > - * may depend on host virtualization features rather than host cpu features.
> > + * The three MSR lists(msrs_to_save, emulated_msrs, msr_based_features) track
> > + * the set of MSRs that KVM exposes to userspace through KVM_GET_MSRS,
> > + * KVM_SET_MSRS, and KVM_GET_MSR_INDEX_LIST.  msrs_to_save holds MSRs that
> > + * require host support, i.e. should be probed via RDMSR.  emulated_msrs holds
> > + * MSRs that emulates without strictly requiring host support.
> emulates -> emulate/emulated?

Ah, no, that's supposed to be "that KVM emulates".  I'll fix that up when applying.

> BTW, do you think is it better to use msrs_emulated instead of emulated_msrs
> to align the naming style?

No, "emulated" is used as an adjective that describes each MSR, versus the "to save"
part of msrs_to_save being a description of the list, not each MSR.

If I were going to rename anything, it would be msr_based_features, because that
reads as "MSR-based features", i.e. reads as "a list of features that are tied
to MSRs", whereas the list actually tracks "feature-based MSRs", i.e. "a list of
MSRs that track features".
