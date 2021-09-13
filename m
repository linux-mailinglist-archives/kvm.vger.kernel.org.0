Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6906940A19D
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 01:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238958AbhIMXkA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 19:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236470AbhIMXj7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 19:39:59 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE48C061760
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 16:38:41 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id r4so24036113ybp.4
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 16:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cI/jeOU5rLR8X7WtxXOWaAngNhFiIOuHbXY1aDDYGos=;
        b=NMKR01fsDjOL/bSL+r00xqJRi+mMiSl6JTC0z4v6w6pafJlzwWUnP9WNprle1mMKN9
         SqkKP2t1CC3hqLN22VyYmhvfvyeQ/qxBgsK11LfqIg5zqIVMWuOlE5MUxuoWgXZTpy75
         iRBbB0FA/hVDjM0PJ+UlOyXWs7eZ+8A69OKeK/yvuqzJaHhr9Y6cSKKsP0w2vbJWVgEM
         kODN4pbGHgOQvBD0z3e1EqPUFVe3dZm5XhkbS+sKKxEjVVyOeJUiOOzetIKdzPA4/wH7
         O/R5G0yjVzvkn4sEUZGCmkl0ghblpGpJcVyQ55ahS529cEpnW5uYibER5FPC2dokxqeC
         O4Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cI/jeOU5rLR8X7WtxXOWaAngNhFiIOuHbXY1aDDYGos=;
        b=5ED2MMJQrdkvKkPutJTyeuX0gyMi2GUx6LoZLI+JtwXM4gDe+sWsWLoC/tVkxsbAf8
         kgt9Ea3hNzQDJT/vmS4RWydXE0sYY6nN+6BDoUQ7xcl8aKInFP/E7Xd+LmwxxGru1t/7
         9vCiy0RY9hrorK2N5f5k7cwHVjWnlbXwgYFSM3YikYAbISlKPA/D4Fa5F1QIjQebXI8t
         ciwxvPaC9echbuBQL/m1JcC9D1bsR112pEQkdEi9bHDjON9jPSeRX9BIzf1WDkhFmr/J
         mgAhWeP8iH8IWZVgBOSNcF+zq7bsoWE0nazjkexZhflQfghHmy2Y07Ad4LQlnXtk0ff/
         /LPw==
X-Gm-Message-State: AOAM532O/YotaXsGY1YB4xmNbbxnEGnBB19fEhB6SdAQeLMOidOfSFzG
        SbrtHKquS/AgoeOJk6l22aL3IJEpnH1Jbh4AsXC54A==
X-Google-Smtp-Source: ABdhPJzT+O8be5cYSNBVl8s3QC+2tzsAf4DvhR8OYgF/hCrLtsSWXEIW0OmXr/C1MdplAnMcBhEp35bF6USETxVCWHc=
X-Received: by 2002:a25:ab44:: with SMTP id u62mr18518702ybi.335.1631576320503;
 Mon, 13 Sep 2021 16:38:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com> <20210909013818.1191270-3-rananta@google.com>
 <20210909171755.GF5176@sirena.org.uk> <CAJHc60yJ6621=TezncgsMR+DdYxzXY1oF-QLeARwq8HowH6sVQ@mail.gmail.com>
 <20210910083011.GA4474@sirena.org.uk>
In-Reply-To: <20210910083011.GA4474@sirena.org.uk>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 13 Sep 2021 16:38:29 -0700
Message-ID: <CAJHc60z0kLzrA3FfQeD0RFZE-PscnDsxxqkVwzcNFcCkf_FRPw@mail.gmail.com>
Subject: Re: [PATCH v4 02/18] KVM: arm64: selftests: Add sysreg.h
To:     Mark Brown <broonie@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 10, 2021 at 1:30 AM Mark Brown <broonie@kernel.org> wrote:
>
> On Thu, Sep 09, 2021 at 01:06:31PM -0700, Raghavendra Rao Ananta wrote:
> > On Thu, Sep 9, 2021 at 10:18 AM Mark Brown <broonie@kernel.org> wrote:
>
> > > >  create mode 100644 tools/testing/selftests/kvm/include/aarch64/sysreg.h
>
> > > Can we arrange to copy this at build time rather than having a duplicate
> > > copy we need to keep in sync?  We have some stuff to do this for uapi
> > > headers already.
>
> > That's a great idea actually (I wasn't aware of it). But, probably
> > should've mentioned it earlier, I had a hard time compiling the header
> > as is so I modified it a little bit and made the definitions of
> > [write|read]_sysreg_s() similar to the ones in kvm-unit-tests.
> > I'll try my best to get the original format working and try to
> > implement your idea if it works.
>
> One option would be to do something like split out the bits that can be
> shared into a separate header which can be included from both places and
> then have the header with the unsharable bits include that.  Something
> like sysreg.h and sysreg_defs.h for example.

Hi Mark,

Thanks again for your suggestion. As of v6 of the series, the original
header from the kernel seems to be working as is, so there's no need
to split it anymore.
However, I'll plan to incorporate your suggestion as a separate
series, if it's okay :)

I was looking into this though and could only find some utilities such
as tools/iio/, tools/spi/, and so on, which seem to create a symbolic
link to the header present in the kernel (rather than copying). Is
this what you were referring to?

Regards,
Raghavendra
