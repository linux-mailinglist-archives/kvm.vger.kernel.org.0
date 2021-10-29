Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF924401C5
	for <lists+kvm@lfdr.de>; Fri, 29 Oct 2021 20:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhJ2SU6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Oct 2021 14:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbhJ2SU5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Oct 2021 14:20:57 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7258BC0613F5
        for <kvm@vger.kernel.org>; Fri, 29 Oct 2021 11:18:28 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id s19so18144424ljj.11
        for <kvm@vger.kernel.org>; Fri, 29 Oct 2021 11:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6gzqVRL5S6+afpMyNODH0pBpVAT9PrZbeLsch+p0Irs=;
        b=tGz+64nOHnWsxk51dfc06pYJyhw9jonhHrQdFBodgY5y5sesT8bA8ktgmSBugp+3Je
         FzZDdezUG1/Jeq3xf5CiQrNyVymLY416TUqBoP548TlAKopBWSaAzkjP024cOrvd+OUL
         CWV3ga0R0bj2W2/REDcE7KL+gJ+IJER0KwaRXFnO4MZS0lT5ozuJU+dT3b4k/n7vS+1h
         AUF6HL5lxYlDmvqaPUePlgp9FtD51CuXXhHpyCANZwkPjrNhe0lyIEECqEhiuCrpcW7I
         xcWGXGSIxic4UqkUeU5UDXcSDjXtq0rh0lQoq4hlpiDn4qaty2wTflNUkZTLli3josc+
         zJGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6gzqVRL5S6+afpMyNODH0pBpVAT9PrZbeLsch+p0Irs=;
        b=bg+Q8eivWTatMMk68QAV3isxZbfNoveEPvwfOR7H6Siu033JqfsoCHpHlaTzvVTc2V
         n9npN8E+c+/HXHauUTk+iYu85IaMo8UO9l3MCEa1/7bAo/0dGk9L3W+tQ22bt4l12Wr1
         wUd/e8Io1XGYTwxz7GxSwCkt4/KmnovZMWjXVQBNYD7cUV5fjK+5+kLFLJUDQNCIbkCg
         byJWL1ypQlmjSZMOVlV0qQbOSeEbdZhgnRKjaifoAJ50REzEwplAXBKXanjNRU4WdHe+
         TVvo46muO8SkNlEfvZfKN4d+N2eAvY98AjbMlyuLprVWiaG5MHvS3h88UO54uXE2ygwv
         6x9w==
X-Gm-Message-State: AOAM5319d/dvTLgNd38K763GjIq0vey4ZAexb8Hfw5e6qesNSDwDQmtG
        NmP0UGtQsf5lsLZjuFDE8q9+fVZP4UsnujSgRuUEKA==
X-Google-Smtp-Source: ABdhPJwuuUqHsGAxudNHy1pXSqXpNJwQ0mQILNxJN/3XPiTCFRDAfELtLMvtP273AM4utb+UT0qen6DLY3ZL1rAG6JA=
X-Received: by 2002:a05:651c:1051:: with SMTP id x17mr10679682ljm.337.1635531506374;
 Fri, 29 Oct 2021 11:18:26 -0700 (PDT)
MIME-Version: 1.0
References: <20211029003202.158161-1-oupton@google.com> <20211029003202.158161-4-oupton@google.com>
 <87k0hw9iez.wl-maz@kernel.org>
In-Reply-To: <87k0hw9iez.wl-maz@kernel.org>
From:   Oliver Upton <oupton@google.com>
Date:   Fri, 29 Oct 2021 11:18:13 -0700
Message-ID: <CAOQ_QshjMXMFK2uHVDxYbFkVJApGxhT4M4NbMNY+qX3QvPe5_A@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: arm64: Raise KVM's reported debug architecture
 to v8.2
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Marc,

On Fri, Oct 29, 2021 at 4:31 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 29 Oct 2021 01:32:02 +0100,
> Oliver Upton <oupton@google.com> wrote:
[...]
> >       case SYS_ID_AA64DFR0_EL1:
> > -             /* Limit debug to ARMv8.0 */
> > +             /* Limit debug to ARMv8.2 */
> >               val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER);
> > -             val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), 6);
> > +             val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), 8);
> > +
> > +             /* Hide DoubleLock from guests */
> > +             val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_DOUBLELOCK);
> > +             val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_DOUBLELOCK), 0CF);
> > +
>
> One issue with that is that this will break migration from an older
> kernel (DFR0 will be different between source and destination).
>
> You'll need a set_user handler and deal with it in a similar way to
> CSV2/CSV3.

Yeah, definitely so. In that case, unless we're strongly motivated to
expose these changes soon, I'll just punt the ID register changes
until Reiji's series [1] lands, as anything I add for a writable DFR0
will invariably be scrapped in favor of his work.

I'll post v2 of this series folding in your feedback (thx for quick
review, btw), less this patch.

[1] https://patchwork.kernel.org/project/kvm/cover/20211012043535.500493-1-reijiw@google.com/

--
Thanks,
Oliver
