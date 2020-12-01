Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2682CA200
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 13:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389983AbgLAL5U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 06:57:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727524AbgLAL5T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Dec 2020 06:57:19 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5C4C0613D4
        for <kvm@vger.kernel.org>; Tue,  1 Dec 2020 03:56:39 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id u19so2839855edx.2
        for <kvm@vger.kernel.org>; Tue, 01 Dec 2020 03:56:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mY7iQAlCDv3m/pSFTAcG32WtflFk1CABCP1rf+2nyJY=;
        b=N6ERR3oDzH7bAbri2CfZlwbNC3SDoBMC/1OQXau8oCo9R7bBsZLtKgE3iJoWjyiWLP
         QlbnsxR2XXXVUVnXVMJLaKWWYZqr3uTUSc3juUWI2zi/3eIKukJJsAZ7IEffIktsTi/f
         aG44fb9hrqUvdZWTodJKVoY8DkKlmu3n+dBeOeN++VO8Cc3mOqYrlqP4uh4iotK768+G
         k7BIHZLXkihW8qOkaMNCcDx41oA5JE0ylirJi7Xzf9nhsgBT9EGdnHVxYzEOvzYZFu8n
         ylzs4u/ciNj/++ii9oa4LQ+HpsVVe8GL4KAU1fLatmOJkeLyEI1XjESQxqA9PRHJacyn
         FkdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mY7iQAlCDv3m/pSFTAcG32WtflFk1CABCP1rf+2nyJY=;
        b=k0MkH3EwCdFtUvKZvheFbxx5iFOHPDqHl0OdYn3Cmv8t/7lTcEVwumc8WKTV4m13kQ
         cYOQigkhfxjvluANWy5juzluu+HR3Besm2ADktRm7sVf/Pau6jGhK3ZKjuBC5SOFBA8E
         3HvVb+v/UZG9HMsk24oVSpbER1AndXTg1BdeSt43I/Z97MMRRD0Cftg10VHqdmgmzTlC
         twYxC+FHAlQN6mRgDiIdP7fSxAGM2ajgcse5G2vzpgFiGyDGmlePy5MPojxZx8lcmLZT
         69P2KkM9hsmjEpu3o/5e11u8feGLQAhaVt77nfVOYc6TBr5YnsJduMRmas65QFOWRtxW
         e3EA==
X-Gm-Message-State: AOAM5308nkN2DQhGPC87ryYftEryWrg2MT7LHnyrU9LQ4SBCTPqoCyYM
        qqf0QY8RPbDD7qbWD8Jq7QylZgJTSCH8kUvsTcqtTQ==
X-Google-Smtp-Source: ABdhPJxrdT5H/NK0SSJ+6i/lEOMxEKnNt6HXsoPmsOOxIwm7ajxcGRo5LbitxkE+siXGh+yTYebFymgMdEKZugzxm5U=
X-Received: by 2002:aa7:d915:: with SMTP id a21mr2537511edr.251.1606823798104;
 Tue, 01 Dec 2020 03:56:38 -0800 (PST)
MIME-Version: 1.0
References: <cover.1605316268.git.ashish.kalra@amd.com> <2ba88b512ec667eff66b2ece2177330a28e657c0.1605316268.git.ashish.kalra@amd.com>
 <CAFEAcA8eiyzUbHXQip1sT_TrT+Mfv-WG8cSMmM-w_eOFShAMzQ@mail.gmail.com> <20201201115047.GA15055@work-vm>
In-Reply-To: <20201201115047.GA15055@work-vm>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 1 Dec 2020 11:56:26 +0000
Message-ID: <CAFEAcA_cdixD7jvu68snUU=PN2xQow1W2goKjshfdF9jGb2dBQ@mail.gmail.com>
Subject: Re: [PATCH 01/11] memattrs: add debug attribute
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, ssg.sos.patches@amd.com,
        Markus Armbruster <armbru@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Richard Henderson <rth@twiddle.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 1 Dec 2020 at 11:51, Dr. David Alan Gilbert <dgilbert@redhat.com> wrote:
>
> * Peter Maydell (peter.maydell@linaro.org) wrote:
> > On Mon, 16 Nov 2020 at 19:28, Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> > >
> > > From: Brijesh Singh <brijesh.singh@amd.com>
> > >
> > > From: Brijesh Singh <brijesh.singh@amd.com>
> > >
> > > Extend the MemTxAttrs to include a 'debug' flag. The flag can be used as
> > > general indicator that operation was triggered by the debugger.
> > >
> > > A subsequent patch will set the debug=1 when issuing a memory access
> > > from the gdbstub or HMP commands. This is a prerequisite to support
> > > debugging an encrypted guest. When a request with debug=1 is seen, the
> > > encryption APIs will be used to access the guest memory.
> >
> > So, what counts as "debug" here, and why are debug requests
> > special? If "debug=1" means "can actually get at the guest memory",
> > why wouldn't every device model want to use it?
>
> SEV has a flag that the guest-owner can set on a VM to enable debug;
> it's rare for it to be enabled; so it's not suitable for use by normal
> devices.  It's only there for debug if the guest owner allows you to.

So if I do a memory transaction with debug=1 then I should expect
that it might come back with a failure status (meaning "this VM
doesn't permit debug") and I should handle that error ?

thanks
-- PMM
