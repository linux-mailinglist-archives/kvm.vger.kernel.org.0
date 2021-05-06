Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30DFA375824
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 18:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235583AbhEFQFm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 12:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235156AbhEFQFk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 12:05:40 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88082C061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 09:04:42 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id m12so9087037eja.2
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 09:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C736AuqidzDQYfgZUZZB0PARKzaD4iAVzFxsLnZvVFc=;
        b=n1fAETreJFQdC7wXEx5ii+pfu/gGH9b/X8P5A9SX9BGHF7EutNs8G9WP/6DeQ2UEEz
         lf3SV4glmo9fE8fMqGf/+JMh4m+fmRshQpmQh79Olzk5LYno3JkeOfytqEKfk/VclzzJ
         of6IX46ugieYUfWu0eEiMPC/A/nIUtuPLE3+dgdoXM7BCZ5ZEewe7BI/qNpNP4P7/eqh
         x1uCSUJPNDOvt3uq/6X68SpaE2eiJRn/D2v+9sJrdNQqvEXBFt5cxsJ77XFujzRe9E0u
         dJSkDbtfDPNtAd+q/qcFmWTw3MJND80Z31hpZSed3D3dtCJNSiU41yxdRE0pLc5YIdKB
         vSng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C736AuqidzDQYfgZUZZB0PARKzaD4iAVzFxsLnZvVFc=;
        b=QsThg7pvm5+Iec5VRulg/kpgVTOIKbLCWDzYTAIwIV1edpC4SsF2ps0x1kryTx+fYk
         D/jKHN6CwSkzmfoWIAVHVR4UXFTRkh+gDiJT7A0zOO0hQwtIjoSDsr3DYbDm3tzm5fAs
         IdoefsgJgxzW76DgKg7ZlRIpL4m9hvjI3Ye+vrhI/gzPFiBmHWM3jZI9RbWbZ5TU0oqq
         5WNVP+1mE9i8ZTmlGRRNHfAJVVnn4aX3WiAO1O4bZDyoW2gNYrF78V+6cCmkMHPNM7AG
         IDX0uMGj7MmaDFyAmxVxGsVDgroakLIh8NT0B2AyJL/H7iUOnCI4k8twm1u3LOYy0Utl
         YT8A==
X-Gm-Message-State: AOAM530VGGfzwPdCD9Q946yPEn7dhhaStRw7fIjjKSFOEHPnapU4E81q
        tUeMLg1fc2KJE1V46sHxZiZvMX5hcTUtggD/OVqndg==
X-Google-Smtp-Source: ABdhPJxWQt3yjMYSuWKONmSU3rQ4pt6tgqkHulEIhHw9fFhEGRGThw0EfZS8dZ2aVL+Wv3z1hTcsyguw7VV4nt7m6PE=
X-Received: by 2002:a17:906:b1cc:: with SMTP id bv12mr5163395ejb.407.1620317081062;
 Thu, 06 May 2021 09:04:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210506133758.1749233-1-philmd@redhat.com> <20210506133758.1749233-5-philmd@redhat.com>
 <CANCZdfoJWEbPFvZ0605riUfnpVRAeC6Feem5_ahC7FUfO71-AA@mail.gmail.com>
 <39f12704-af5c-2e4f-d872-a860d9a870d7@redhat.com> <CANCZdfqW0XTa18F+JxuSnhpictWxVJUsu87c=yAwMp6YT60FMg@mail.gmail.com>
 <7a96d45e-2bdc-f699-96f7-3fbf607cb06b@redhat.com> <CANCZdfrcv9ZUcBv7z+z3JPCjy0uzzY07VLmC4dqr5r8ba_QPLw@mail.gmail.com>
 <adfc5da4-a615-24d7-0c67-f04d4eaec9a6@redhat.com>
In-Reply-To: <adfc5da4-a615-24d7-0c67-f04d4eaec9a6@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 6 May 2021 17:03:33 +0100
Message-ID: <CAFEAcA98KHKcGam1nukspYOQvPNXyq+hfsNbATpNvmDGoODN1A@mail.gmail.com>
Subject: Re: [PATCH v2 4/9] bsd-user/syscall: Replace alloca() by g_new()
To:     Eric Blake <eblake@redhat.com>
Cc:     Warner Losh <imp@bsdimp.com>, kvm-devel <kvm@vger.kernel.org>,
        Kyle Evans <kevans@freebsd.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        qemu-arm <qemu-arm@nongnu.org>, qemu-ppc <qemu-ppc@nongnu.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 6 May 2021 at 16:46, Eric Blake <eblake@redhat.com> wrote:
>
> On 5/6/21 10:30 AM, Warner Losh wrote:
>
> >
> > But for the real answer, I need to contact the original authors of
> > this part of the code (they are no longer involved day-to-day in
> > the bsd-user efforts) to see if this scenario is possible or not. If
> > it's easy to find out that way, we can either know this is safe to
> > do, or if effort is needed to make it safe. At present, I've seen
> > enough and chatted enough with others to be concerned that
> > the change would break proper emulation.
>
> Do we have a feel for the maximum amount of memory being used by the
> various alloca() replaced in this series?  If so, can we just
> stack-allocate an array of bytes of the maximum size needed?

In *-user the allocas are generally of the form "guest passed
us a random number, allocate that many structs/whatevers". (In this
specific bsd-user example it's the writev syscall and it's "however
many struct iovecs the guest passed".) So there is no upper limit.

The right thing to do here is probably to use g_try_malloc() and return
ENOMEM or whatever on failure. The use of alloca, at least in the
linux-user code, is purely old lazy coding based on "in practice
real world guest binaries don't allocate very many of these so
we can get away with shoving them on the stack".

thanks
-- PMM
