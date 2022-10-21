Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8DB2606D0C
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 03:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiJUBdy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 21:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiJUBdw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 21:33:52 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F347219FC6
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 18:33:51 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id bu30so2414944wrb.8
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 18:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UDc/7EKe3fjg9/HlzFBTEgTvDgZRorby6bcrR56TrdU=;
        b=pcexPsk5/8WuhU2x15Z1v+rgdwBZLj3YlhPJBkQgfTeW/CgQaMEhG2WKmc7L2o5Rsy
         CDD5/DPx0oGd05JxpopmjJ2xv/+/vJ7AXT6AMQfgu0KPECbYoeXyXQff0+LxOMX10cGz
         6w/ROYS+vD/U81tet2pJJpROdTcwPQo+EigMzuQ1Ptri99pqtKrZ62hfgBZMKrfg5hM0
         UPUr3/jsRm0Xv/RJ1V9kikbkayVpBWwZOsaFKbuaTHoVyZIrCa1zqg8BuzZnlqKaM4Xr
         hOGn3S/j/gQUYaxMzLpb/nW2bKu21MgWeGSJ6CB5BwGV0z0ywAmDgMyjCi1TCFMxiQkK
         0D9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UDc/7EKe3fjg9/HlzFBTEgTvDgZRorby6bcrR56TrdU=;
        b=eeuzpFVD2/9oqkHksBN7YVOhppgyxe5rLjOpncBE28uAusExrm0IxQ4Ih+W0jE+mG3
         c3ldR5vN17mBdBdLxqouRDv94IvkJkgp74W+jn5tGSjcHF8VI/QIlKj6nk8/ILGYb3u/
         FxURcIeD236hZKt8lziNClrJP7paVya4v4eWfgTOFkYxawT39hMjeUJnk5tFjy2Gi8sv
         RDVSfgUPb66a+Z6LDU0IxquUj4tvO2hlsQV0cYH4q8Yko/a0fCLvjWW4hrcGFzYjddNu
         SX4/S83vQjpvEpTwm5dJxnRqE9MTgZytydnvcPbcQeavBqdTJRLQvLLUICh9KpYxLnHl
         RCVQ==
X-Gm-Message-State: ACrzQf1oo4kM4FfSyrjnKHXILSFBMSXs0ln7Vc6oTNzc1ix3EZjDq3rj
        Oyu95G9IS57lgcYkpjcUnIrSDS/HI+HQJHm9EW3lLfTkfGOdiA==
X-Google-Smtp-Source: AMsMyM4U+vhw2RnvU7W8rr1RBQ3zqz2Y8O5Gq9DmAgxup7kdaiSWyTfLyhc7p55pYn3ZyShIbpb9YcPubpRO8Z6oxRM=
X-Received: by 2002:adf:f491:0:b0:235:894e:8d6c with SMTP id
 l17-20020adff491000000b00235894e8d6cmr4365371wro.209.1666316029690; Thu, 20
 Oct 2022 18:33:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220920174603.302510-1-aaronlewis@google.com>
 <20220920174603.302510-2-aaronlewis@google.com> <Y0C1c2bBNVF4qxJq@google.com>
 <CAAAPnDEk_bckk0W5C2vKiL4HJVUHFGV3_NqfdbsqYFqpJvuXog@mail.gmail.com> <Y02c6JdM432f8H+A@google.com>
In-Reply-To: <Y02c6JdM432f8H+A@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Fri, 21 Oct 2022 01:33:38 +0000
Message-ID: <CAAAPnDGbDp37x+V5n8b_vxzBbBXROrg5bhVQcvrfCC1UMo-RJA@mail.gmail.com>
Subject: Re: [PATCH v5 1/7] kvm: x86/pmu: Correct the mask used in a pmu event
 filter lookup
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 17, 2022 at 6:20 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Sat, Oct 15, 2022, Aaron Lewis wrote:
> > > And the total patch is:
> > >
> > > ---
> > >  arch/x86/kvm/pmu.c           | 2 +-
> > >  arch/x86/kvm/pmu.h           | 2 ++
> > >  arch/x86/kvm/svm/pmu.c       | 2 ++
> > >  arch/x86/kvm/vmx/pmu_intel.c | 2 ++
> > >  4 files changed, 7 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > > index d9b9a0f0db17..d0e2c7eda65b 100644
> > > --- a/arch/x86/kvm/pmu.c
> > > +++ b/arch/x86/kvm/pmu.c
> > > @@ -273,7 +273,7 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
> > >                 goto out;
> > >
> > >         if (pmc_is_gp(pmc)) {
> > > -               key = pmc->eventsel & AMD64_RAW_EVENT_MASK_NB;
> > > +               key = pmc->eventsel & kvm_pmu_ops.EVENTSEL_MASK;
> > >                 if (bsearch(&key, filter->events, filter->nevents,
> > >                             sizeof(__u64), cmp_u64))
> > >                         allow_event = filter->action == KVM_PMU_EVENT_ALLOW;
> > > diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> > > index 5cc5721f260b..45a7dd24125d 100644
> > > --- a/arch/x86/kvm/pmu.h
> > > +++ b/arch/x86/kvm/pmu.h
> > > @@ -40,6 +40,8 @@ struct kvm_pmu_ops {
> > >         void (*reset)(struct kvm_vcpu *vcpu);
> > >         void (*deliver_pmi)(struct kvm_vcpu *vcpu);
> > >         void (*cleanup)(struct kvm_vcpu *vcpu);
> > > +
> > > +       const u64 EVENTSEL_MASK;
> >
> > Agreed, a constant is better.  Had I realized I could do that, that
> > would have been my first choice.
> >
> > What about calling it EVENTSEL_RAW_MASK to make it more descriptive
> > though?  It's a little too generic given there is EVENTSEL_UMASK and
> > EVENTSEL_CMASK, also there is precedent for using the term 'raw event'
> > for (eventsel+umask), i.e.
> > https://man7.org/linux/man-pages/man1/perf-record.1.html.
>
> Hmm.  I'd prefer to avoid "raw" because that implies there's a non-raw version
> that can be translated into the "raw" version.  This is kinda the opposite, where
> the above field is the composite type and the invidiual fields are the "raw"
> components.
>
> Refresh me, as I've gotten twisted about: this mask needs to be EVENTSEL_EVENT_MASK
> + EVENTSEL_UMASK, correct?  Or phrased differently, it'll hold more than just
> EVENTSEL_EVENT_MASK?

I found it more useful to just have the event select.  That allowed me
to use just it or the event select + umask as needed in patch #4.

const u64 EVENTSEL_EVENT;

>
> What about something completely different, e.g. FILTER_MASK?  It'll require a
> comment to document, but that seems inevitable, and FILTER_MASK should be really
> hard to confuse with the myriad EVENTSEL_*MASK fields.
