Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2364AD681
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 12:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357250AbiBHL0R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 06:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345829AbiBHJ5C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 04:57:02 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2AC0C03FEC0
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 01:57:00 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id x23so32363734lfc.0
        for <kvm@vger.kernel.org>; Tue, 08 Feb 2022 01:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xnDB24LQeAUZkcfN3wL+FHV/aKMR05Pb76EsfKgOtQs=;
        b=gvGqrcbMb8DtdN8ZXcz6prSV4SyBxVL8iaSXK7eBe0hV86JPh8TEGaBs9LeBjH394n
         JV5aBERcpIRWYYa6clmXFDkBsubhJVVJXzuUPZt7JtaDR+AcLQ74PLG74djh/U6ThE9F
         jYLME7ZdZfWKpgrV+VImN+2PQV0ucGeZ80w1uSkw089d/t3KRCTq41dyBqhBLwUg08Y+
         oFdo8CrrtiCXONlgKD+p0PBpktOXX9dbD5ax6mo9/6Hk50Eh3BsT6JiVSEF2I2T7Agvt
         DGIRHYiSRdYJMcE9MSwtJaWRukyds/9cMoCgWlB0nnL/HMht3xIjt98uC6O9o9xEKRbe
         1vKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xnDB24LQeAUZkcfN3wL+FHV/aKMR05Pb76EsfKgOtQs=;
        b=5cwPntVFypG7hsfXiv9GHZz5sj7/VimqA2kD2bEUE6QUtG4b/lyosqYY9C3U79bfHR
         v4GxQ+JAb8P8ok5PQzebOqItq70o5pGbZBkGesBx9QBWmCQEaUKf5T7NPNqCOTfpJ1hj
         PV8r0tNENc7a1MpKPTSpNdTOx/bDIdS4VLULgjuyxQ+vynG6CMIBHFTwRmyIdhLRBZmb
         QOJGFBMJgrZKOm1cK3o3Gip+viRYdAPIkFbnMjU4mEy9YlYgzH2rkfF5KivZUOYSW0Ia
         jDaoIotKUonDTtlK9wvLu8IO3127+J9BcTWkC+JFPUXpjEt8PbK5JI9/Qg7WdvL5w214
         7eCQ==
X-Gm-Message-State: AOAM530Y2HN4GS03//dmvA11MnsKFLxIrGs5gUuGJ60xgAJV/A0slXRo
        o9MFBr4GQasUobX/HFmCE4jOnmsFEdXu4gnuKvmaYw==
X-Google-Smtp-Source: ABdhPJxaGa+pLWFNUpDY6o6qT/j3Mq2c5YYfreeyurnEZrGUe6/lYOJubaJ+/Um6tzeBm0PoCUWy/A+7MB2iwbKR5iU=
X-Received: by 2002:a05:6512:3181:: with SMTP id i1mr2552749lfe.286.1644314218724;
 Tue, 08 Feb 2022 01:56:58 -0800 (PST)
MIME-Version: 1.0
References: <YSVhV+UIMY12u2PW@google.com> <87mtp5q3gx.wl-maz@kernel.org>
 <CAOQ_QshSaEm_cMYQfRTaXJwnVqeoN29rMLBej-snWd6_0HsgGw@mail.gmail.com>
 <87fsuxq049.wl-maz@kernel.org> <20210825150713.5rpwzm4grfn7akcw@gator.home>
 <CAOQ_QsgWiw9-BuGTUFpHqBw3simUaM4Tweb9y5_oz1UHdr4ELg@mail.gmail.com>
 <877dg8ppnt.wl-maz@kernel.org> <YSfiN3Xq1vUzHeap@google.com>
 <20210827074011.ci2kzo4cnlp3qz7h@gator.home> <CAOQ_Qsg2dKLLanSx6nMbC1Er9DSO3peLVEAJNvU1ZcRVmwaXgQ@mail.gmail.com>
 <87ilyitt6e.wl-maz@kernel.org> <CAOQ_QshfXEGL691_MOJn0YbL94fchrngP8vuFReCW-=5UQtNKQ@mail.gmail.com>
 <87lf3drmvp.wl-maz@kernel.org> <CAOQ_QsjVk9n7X9E76ycWBNguydPE0sVvywvKW0jJ_O58A0NJHg@mail.gmail.com>
 <CAJHc60wp4uCVQhigNrNxF3pPd_8RPHXQvK+gf7rSxCRfH6KwFg@mail.gmail.com>
 <875yq88app.wl-maz@kernel.org> <CAOQ_QshL2MCc8-vkYRTDhtZXug20OnMg=qedhSGDrp_VUnX+5g@mail.gmail.com>
 <878ruld72v.wl-maz@kernel.org>
In-Reply-To: <878ruld72v.wl-maz@kernel.org>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 8 Feb 2022 01:56:47 -0800
Message-ID: <CAOQ_QshwtTknXrpLkHbKj119=wVHvch0tHJURfrvia6Syy3tjg@mail.gmail.com>
Subject: Re: KVM/arm64: Guest ABI changes do not appear rollback-safe
To:     Marc Zyngier <maz@kernel.org>
Cc:     Raghavendra Rao Ananta <rananta@google.com>,
        Andrew Jones <drjones@redhat.com>,
        kvmarm@lists.cs.columbia.edu, pshier@google.com,
        ricarkol@google.com, reijiw@google.com, jingzhangos@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        james.morse@arm.com, Alexandru.Elisei@arm.com,
        suzuki.poulose@arm.com, Peter Maydell <peter.maydell@linaro.org>,
        Sean Christopherson <seanjc@google.com>
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

On Tue, Feb 8, 2022 at 1:46 AM Marc Zyngier <maz@kernel.org> wrote:
> > > KVM currently restricts the vcpu features to be unified across vcpus,
> > > but that's only an implementation choice.
> >
> > But that implementation choice has become ABI, no? How could support
> > for asymmetry be added without requiring userspace opt-in or breaking
> > existing VMMs that depend on feature unification?
>
> Of course, you'd need some sort of advertising of this new behaviour.
>
> One thing I would like to add to the current state of thing is an
> indication of whether the effects of a sysreg being written from
> userspace are global or local to a vcpu. You'd need a new capability,
> and an extra flag added to the encoding of each register.

Ah. I think that is a much more reasonable fit then. VMMs unaware of
this can continue to migrate new bits (albeit at the cost of
potentially higher lock contention for the per-VM stuff), and those
that do can reap the benefits of writing such attributes exactly once.

[...]

> > > A device means yet another configuration and migration API. Don't you
> > > think we have enough of those? The complexity of KVM/arm64 userspace
> > > API is already insane, and extremely fragile. Adding to it will be a
> > > validation nightmare (it already is, and I don't see anyone actively
> > > helping with it).
> >
> > It seems equally fragile to introduce VM-wide serialization to vCPU
> > UAPI that we know is in the live migration critical path for _any_
> > VMM. Without requiring userspace changes for all the new widgets under
> > discussion we're effectively forcing VMMs to do something suboptimal.
>
> I'm perfectly happy with suboptimal to start with, and find ways to
> make it better once we have a clear path forward. I just don't want to
> conflate the two.

Fair. My initial concern was that it didn't seem as though there was
much room for growth/improvement with the one reg UAPI, but your
suggestion definitely provides a ramp out to handle VM state once per
VM.

Thanks for following up :)

--
Oliver
