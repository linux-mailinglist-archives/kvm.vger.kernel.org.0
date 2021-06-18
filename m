Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B41733AD45A
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 23:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbhFRVWj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 17:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbhFRVWd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 17:22:33 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98071C061574
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 14:20:22 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 5-20020a9d01050000b02903c700c45721so11049992otu.6
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 14:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9lgU/PMWeQeUbCd3XE0jzHQ9dorLgAsc49ujOL35SEU=;
        b=GzBgZ4E84z3ZOlgfz9osCY0uVbPfDfg91HIzGAbwashIBb2RG8gUXUHeYvzgvJu9VH
         FaecV8qk+evG0P3FUGbn4tilFeHYzxj3MlzpAeRin4IzhJ/6L//Xc6T7uEERcN/hwd/Z
         Nc6z+TBd6Yr6XuvAAZ1eGuoT0PDDnRQIw0kX7Klq/lx2pmafHvyoz8qJoUU3BJ002sTF
         4d5clG5zABOfXhuLo4OVxNY3RQsA8zIFYkOQCBkgxh7bkVXDmbRd1KsTB9ZiGh1Yxdlc
         mYeOvBFUh+/eijE7EL4ffif2pgqODA99ov5Q7lbAca5Zaudr/nREItCmna7MIHKETWFC
         S9iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9lgU/PMWeQeUbCd3XE0jzHQ9dorLgAsc49ujOL35SEU=;
        b=Rb3JNCE2RA01AaE2meS20WeYJ6vie9du3eM81uy4a/ZaWoUc5e/a8tphOuSZOxWNhS
         45fPtfw6WpPMA4LzqtJi8zIMh8iFyn1EXGT/npnjlDlbamMA8vlMcLZyJ9JVCrEdYwtL
         +5rfj1Fb1h/8DP596K147luFifwP/VQMsH8vvsCtjRnPFI8zSKoPoZkooR6l8py38KUH
         AuFzZrRG9G1aovyU0PGx5rNRmcYeEdRa6RyQXQo7h/GbW0Jpe48HPZHJoAd1vlR1LC0+
         2teIvSGYPjI34Jw8biOrp5F1k1xtwOsT22oKhbqWAU0VvDet+huVZWodBsCLXZmNOSHl
         aJIQ==
X-Gm-Message-State: AOAM530pIF0tseVWRYlgOSTiw7aNGtUIhJno9Sx0HnoOKua5rSbRFhDK
        trhUzk/94GNyscB3U76XW41WEVsl2pxsObNGZaU=
X-Google-Smtp-Source: ABdhPJwyjgUUV11wJ0gms1NAz7TjBOaHPz5GI4ofwlF+2UnFBFvBeGxrrDaYWqIAcDV5YYTNjA09oc7TRvZSGUbbGRs=
X-Received: by 2002:a05:6830:2241:: with SMTP id t1mr11535635otd.123.1624051222032;
 Fri, 18 Jun 2021 14:20:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210618113118.70621-1-laramglazier@gmail.com>
 <ca3ca9a0-f6be-be85-b2a1-5f80dd9dd693@oracle.com> <CANX1H+3LC1FrGaJ+eo-FQnjHr8-VYAQJVW0j5H33x-hBAemGDA@mail.gmail.com>
 <CALMp9eT+2kCSGb5=N5cc=OeH1uPFuxDtpjLn=av5DA3oTxqm9g@mail.gmail.com>
 <CANX1H+2YUt6wF7P=jNBpfzJEnjz7Yz=Y8K_hWTwvYYbNb-vV2A@mail.gmail.com> <CALMp9eRDkfHHmRuRuRabRLcNBhudJwb+mhE=WD2tVR016Yq58w@mail.gmail.com>
In-Reply-To: <CALMp9eRDkfHHmRuRuRabRLcNBhudJwb+mhE=WD2tVR016Yq58w@mail.gmail.com>
From:   Lara Lazier <laramglazier@gmail.com>
Date:   Fri, 18 Jun 2021 23:20:10 +0200
Message-ID: <CANX1H+0M5+TS8gaOoi7_dUii0m_2h6rqORer0h3FvErk0hRLxA@mail.gmail.com>
Subject: Re: [PATCH kvm-unit-tests] svm: Updated cr4 in test_efer to fix
 report msg
To:     Jim Mattson <jmattson@google.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am Fr., 18. Juni 2021 um 23:10 Uhr schrieb Jim Mattson <jmattson@google.com>:
>
> On Fri, Jun 18, 2021 at 1:57 PM Lara Lazier <laramglazier@gmail.com> wrote:
> >
> > Am Fr., 18. Juni 2021 um 22:26 Uhr schrieb Jim Mattson <jmattson@google.com>:
> > >
> > > On Fri, Jun 18, 2021 at 12:59 PM Lara Lazier <laramglazier@gmail.com> wrote:
> > >
> > > > My understanding is as follows:
> > > > The "first" test should succeed with an SVM_EXIT_ERR when EFER.LME and
> > > > CR0.PG are both
> > > > non-zero and CR0.PE is zero (so I believe we do not really care
> > > > whether CR4.PAE is set or not though
> > > > I might be overlooking something here).
> > >
> > > You are overlooking the fact that the test will fail if CR4.PAE is
> > > clear. If CR4.PAE is 0 *and* CR0.PE is 0, then you can't be sure which
> > > one triggered the failure.
> > Oh, yes that makes sense! Thank you for the explanation.
> > I will move it back up.
>
> I think this may be subtle enough to warrant a comment as well, if
> you're so inclined.

Sure, I will add a corresponding comment.
