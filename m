Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 735454ACE84
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 02:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344952AbiBHB6a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 20:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235393AbiBHB61 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 20:58:27 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A54C061355
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 17:58:26 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id x52-20020a05683040b400b0059ea92202daso12216359ott.7
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 17:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=763abjfJ+SdAaD/kize7T/3PS7RgLJsrH464pKF7rz4=;
        b=E8i3wJQdqN+xoUV3XcnqXAAbbxJQLmcXKSsb3ZwEpwvUKPI4HpQe46RAnRorbEG5tF
         /KBkrRgVwqVWbc6n9UhCtBQwAcCoith1izTA9Cr7uGFhVXCmWHwisH3TZXDN0oVzX69l
         ZzV+8OS6+6hpNa8GWTyMvlsM1IUgk/1FYrIfGU9RhUmeUfKUNBMChzw0yg18dpR5R9Xd
         ZtWTMiTJ1uutQrxjrvaEdPEzXDDSTbNMR4fmhjnLpIwZlaKUCpeqJ6bX3cvV6/v+oDeq
         yz6AudTqIIjzu0pFE2338SkbpfivEZbOcMgfeeTynFTaqe6cF88OvLbW0h2TLZqX+qnY
         omng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=763abjfJ+SdAaD/kize7T/3PS7RgLJsrH464pKF7rz4=;
        b=mx+PdZJbT6X+wNhtT8zJFwjQqtXsUVvK4Kd4J4bI2INFg6+HgPJojt8FlyDszIvQZ7
         ZuIaHxDpmXg4ekss7ZXwsyvIYmE/A57eH0II62rp4p1NngyDk+nMtPgtWaUZS5LuVE9W
         c5PpQe5WE/14ZAKrNgh1N1paajr9YVIjJPUfdBTVxSm8jCJDCvbQD5wOzI5wyEvv4b1d
         b/6OgsDBwLnSEWgTMJhLmTtO5u1lOgNdD5Y4KWuPY4Y4CPVzp2aYsbh/R7twUzD92NZv
         TK0ZY1Agh0lZ83w64DppLC2UhSJnOEOq+rOvZRyO96uAiEZkyRwUDomeMTRoTjJTQPHq
         2jgg==
X-Gm-Message-State: AOAM530Dj/m6mrvAWoBbtMVzD7isyMR+sw0TWRxAOd+WNpArGAap6KDa
        zWFORyQ8IIYOcgSrMpg+13VXlwNgWYVN1WPb94/nJA==
X-Google-Smtp-Source: ABdhPJy48H6F1givxqObMkSesmcHas1J+460SqSSMIu267MI/HmJYzygo16v6/vCq51fjLHkyjmSAnAbWZ7XOy61NTA=
X-Received: by 2002:a9d:6041:: with SMTP id v1mr1058648otj.35.1644285505833;
 Mon, 07 Feb 2022 17:58:25 -0800 (PST)
MIME-Version: 1.0
References: <20220120125122.4633-1-varad.gautam@suse.com> <20220120125122.4633-3-varad.gautam@suse.com>
 <CAA03e5FbSoRo9tXwJocBtZHEc7xisJ3gEFuOW0FPvchbL9X8PQ@mail.gmail.com>
 <Yf0GO8EydyQSdZvu@suse.de> <CAA03e5HnyqZqDOyK8cbJgq_-zMPYEcrAuKr_CF8+=3DeykfV5A@mail.gmail.com>
 <Yf1UqmkfirgX1Nl+@google.com> <CAA03e5G19K12UAt-1JLWXK2QEy2rSLDtzrj0LCv-DL1bYXOAsA@mail.gmail.com>
 <YgGK8Fx3f2pIdtHg@google.com>
In-Reply-To: <YgGK8Fx3f2pIdtHg@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Mon, 7 Feb 2022 17:58:14 -0800
Message-ID: <CAA03e5HjdOjd0Vvk91v50M9FF71goxn9Ym2ZXv2XnSz7Mbcyzg@mail.gmail.com>
Subject: Re: [kvm-unit-tests 02/13] x86: AMD SEV-ES: Setup #VC exception
 handler for AMD SEV-ES
To:     Sean Christopherson <seanjc@google.com>
Cc:     Joerg Roedel <jroedel@suse.de>,
        Varad Gautam <varad.gautam@suse.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>, bp@suse.de
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

On Mon, Feb 7, 2022 at 1:11 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Feb 04, 2022, Marc Orr wrote:
> > On Fri, Feb 4, 2022 at 8:30 AM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Fri, Feb 04, 2022, Marc Orr wrote:
> > > > On Fri, Feb 4, 2022 at 2:55 AM Joerg Roedel <jroedel@suse.de> wrote:
> > > > >         3) The firmware #VC handler might use state which is not
> > > > >            available anymore after ExitBootServices.
> > > >
> > > > Of all the issues listed, this one seems the most serious.
> > > >
> > > > >         4) If the firmware uses the kvm-unit-test GHCB after
> > > > >            ExitBootServices, it has the get the GHCB address from the
> > > > >            GHCB MSR, requiring an identity mapping.
> > > > >            Moreover it requires to keep the address of the GHCB in the
> > > > >            MSR at all times where a #VC could happen. This could be a
> > > > >            problem when we start to add SEV-ES specific tests to the
> > > > >            unit-tests, explcitily testing the MSR protocol.
> > > >
> > > > Ack. I'd think we could require tests to save/restore the GHCB MSR.
> > > >
> > > > > It is easy to violate this implicit protocol and breaking kvm-unit-tests
> > > > > just by a new version of OVMF being used. I think that is not a very
> > > > > robust approach and a separate #VC handler in the unit-test framework
> > > > > makes sense even now.
> > > >
> > > > Thanks for the explanation! I hope we can keep the UEFI #VC handler
> > > > working, because like I mentioned, I think this work can be used to
> > > > test that code inside of UEFI. But I guess time will tell.
> > > >
> > > > Of all the points listed above, I think point #3 is the most
> > > > concerning. The others seem like they can be managed.
> > >
> > >   5) Debug.  I don't want to have to reverse engineer assembly code to understand
> > >      why a #VC handler isn't doing what I expect, or to a debug the exchanges
> > >      between guest and host.
> >
> > Ack. But this can also be viewed as a benefit. Because the bug is
> > probably something that should be followed up and fixed inside of
> > UEFI.
>
> But how would we know it's a bug?  E.g. IMO, UEFI should be enlightened to _never_
> take a #VC, at which point its #VC handle can be changed to panic and using such a
> UEIF would cause KUT to fail.

Yeah. If we end up with enlightened UEFIs that skip handling some/all
#VC exceptions, then using the UEFI #VC handler from kvm-unit-tests
doesn't make any sense :-).

> > And that's my end goal. Can we reuse this work to test the #VC handler
> > in the UEFI?
> >
> > This shouldn't be onerous. Because the #VC should follow the APM and
> > GHCB specs. And both UEFI and kvm-unit-tests #VC handlers should be
> > coded to those specs. If they're not, then one of them has a bug.
> >
> > > On Thu, Jan 20, 2022 at 4:52 AM Varad Gautam <varad.gautam@suse.com> wrote:
> > > > If --amdsev-efi-vc is passed during ./configure, the tests will
> > > > continue using the UEFI #VC handler.
> > >
> > > Why bother?  I would prefer we ditch the UEFI #VC handler entirely and not give
> > > users the option to using anything but the built-in handler.  What do we gain
> > > other than complexity?
> >
> > See above. If we keep the ability to run off the UEFI #VC handler then
> > we can get continuous testing running inside of Google to verify the
> > UEFI used to launch every SEV VM on Google cloud.
>
> I'm not super opposed to the idea, but I really do think that taking a #VC in
> guest UEFI is a bug in and of itself.

Understood.
