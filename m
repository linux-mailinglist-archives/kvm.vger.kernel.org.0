Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88FC343589B
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 04:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhJUC1J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 22:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhJUC1I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 22:27:08 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4CCC06161C
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 19:24:52 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 145so220017ljj.1
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 19:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=student.cerritos.edu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qlx2L0/5DhFwWhGDMal8NQV+6BgDC4+ZVysrt7frFNM=;
        b=Ta4uxXTVEnYWSrrJvu0OjO8PuWIGSqyTwEwaJzvIOGhi4C3i7d2sjAphax3M1jlNNc
         BS9tyxc8JDnTMwR3j/8JYSFkwb5hINwqmDDC+HTS6SDxcb7HvgrV4MB7LdW7MsPB1mx2
         O5ftXJkMcjg+7mbgRtdAROAwxFTTcVAymcp7M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qlx2L0/5DhFwWhGDMal8NQV+6BgDC4+ZVysrt7frFNM=;
        b=wPG0hBhfz/dsmvCxhsc7IIHi3M8kp1f7S2PCQ0i48GXyHafqNlZGAP6YnpLShoHHJU
         f4VAmWJFrnIE8HiV9HlhdpFpJeKjfqrqXVJCXqGR1RnedQssZ/YmE1VM4+/2OuKOGVC+
         o//qaGtlNkB0GChdbJeQaAIELH0JpwAuoeGWRkXoY25WYZrvEhTh9eC25y++emyS9TNj
         mGpg6fhxd84HEqYcRpTMeeiDIyKoXyTI7o1EQEziQeno7IC/32SEtk6gUqy0ACN7RMgC
         tKw5/hyN28kJyQRhhYpy3e8yAmdWuCwzBGI7scopMKLdQk1CDfAQ4NI5LDp4ouk3cBn1
         xP9A==
X-Gm-Message-State: AOAM531VNaNZu8Sy7Cnj8nA0xfJu8vG5AEOazfhEMfd95I5dJ1QI6U7U
        2sHAt66Y6OoG1p2EVBT8E5zmaQmi9Jlsibx3AbEz5Q==
X-Google-Smtp-Source: ABdhPJxbE7RXIVCOSrEjWEqAlsNNfkbSucmI7WjgqbRWQ/Keaz4jNAqXYmUVSDp+jeKeHW4mtO/SANe1g00pwoPCTy0=
X-Received: by 2002:a05:651c:a05:: with SMTP id k5mr2898026ljq.288.1634783091015;
 Wed, 20 Oct 2021 19:24:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAPOgqxEuo6VFAUWc5os6N1iPqh-mQrSg6d09Tj5vy82Gw=v-fg@mail.gmail.com>
 <YXCiM2iKZuiwnfjj@google.com>
In-Reply-To: <YXCiM2iKZuiwnfjj@google.com>
From:   Amy Parker <apark0006@student.cerritos.edu>
Date:   Wed, 20 Oct 2021 19:24:39 -0700
Message-ID: <CAPOgqxEj-XEfWZSaY-jxWNWgcWHGKF2qgLXEcs6+y54jfcocQg@mail.gmail.com>
Subject: Re: Addition of a staging subdirectory to virt/ for in-development features
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 20, 2021 at 4:11 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Oct 20, 2021, Amy Parker wrote:
> > Hello all.
> >
> > Has the idea of having a staging subdirectory for KVM been proposed before?
>
> Not that I know of.

Alright, thank you for clarification.

>
> > It could become a buffer place for KVM features currently in development/not
> > production ready, but that should be able to be conditionally included into
> > the kernel. With a staging directory, these features would be divorced from
> > KVM mainline, but would be able to be rolled out promptly to users while they
> > are being refined.
>
> Can you give an example?
>
> I'm struggling to envision a feature that is both large enough to warrant
> "staging", yet isolated enough to actually be "divorced from KVM mainline".
> One of the rules for staging/drivers is that the drivers are standalone and don't
> require changes to the kernel proper outside of docs, firmware, and perhaps
> exports.

I can think of three categories of implementations:

1. Supporting new hardware virtualization technologies, which may take
a while to develop but should still be available to users for testing
and non-production purposes while being refined, such as on new
architectures or by new manufacturers. It's entirely possible that
there will be new competitors in the x86_64 space soon, especially
with the increasing popularity of the concept of 128-bit computing
architectures.
2. Experimental algorithms which optimize current functions; these may
not be immediately production-ready, but should be available to the
end user in something like the staging folder.
3. Other future virtualization technologies, should they ever be
added, such as cross-binary architecture and syscall compatibility.

    - amyip
