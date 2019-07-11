Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1E4065787
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 15:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbfGKNBg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 09:01:36 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:33125 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728490AbfGKNBf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 09:01:35 -0400
Received: by mail-ot1-f65.google.com with SMTP id q20so5752433otl.0
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 06:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DlCBAK869R2VULvL3hzvYE8/WG0a4e51TGIc7viUdU0=;
        b=AsI1MWJn6QKiJuTT6EP1tTKFcdNT0QvBfFpZfj4Gl+qBt3NrjbLomnXIIJKJPGR9Dt
         0OmqBOfXs+2SVq7CbtDqrEGLbHL/6t64xHu8dVZTErvN/AXtGpJYIeIBRZ0a0EIGiwwq
         7Yafex+ftj8MmhXYkYxCZyzjiBW8+WB8TtnZgDMjqTDNJSBmMbw7kgZicDhEnxbfgOCP
         EAxhDws/6+h7e5ozy0ak90l1FmmYiKDvaBZsiVRJsKsQpCDWzZjqznqdzD5fc4y9LkNg
         UaO/a3GcUzxWcwQE3JrKOIMlEwiVFvhpURAFG466w9nCaalu4Lhvu2qBZgBonTahywfl
         Pn9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DlCBAK869R2VULvL3hzvYE8/WG0a4e51TGIc7viUdU0=;
        b=ozCc9iJAZYunUyKAbYXjuFr9wvypPx3mh7sSW4dJrPon6AoMttoX6Lw2ZZE7ao3Udo
         xGN3wj2/mTAKYufEno37KeCgdZv0IW7Hsh1VPDJbYc5KY8liSL/cJO4cC4SmZZ2G9MgD
         X7MRj+cN8DToaJ2+ZGXjW09PzBKgI8CnrQz5vRXmT6wgjz0of1gzvF2VNf4lNtXR24Gf
         K7nkmMxAvr7vzqtDnD8nSMHS7IzZZbeRSK8eADkpedVQi0X9urYKNh3tyigsJOKvNMcv
         3SafqX7ew3xJPT1weFe83ENeiZl90ucEdFr1YzV8HnDj4SsvJU2sDEap83qAXzUSSN7E
         p/dw==
X-Gm-Message-State: APjAAAUCi4Res/MpUkaJzfrSwDNcyRrbbxZsmlFRQ27aR1Ed2AHCoKYk
        c3pRa+ErXCAUf/0peWSKzuIUa3wpJtjE4snYWV8gdQ==
X-Google-Smtp-Source: APXvYqwsgtkq45KEyG0cWRGfkI61XQc4V1sn0YwWe1f4asohpxHLm0qSO8KvFEKrRc9EAwK1tmdCxxB1piVY52qzz1Q=
X-Received: by 2002:a9d:711e:: with SMTP id n30mr3084074otj.97.1562850094117;
 Thu, 11 Jul 2019 06:01:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190711104412.31233-1-quintela@redhat.com> <5828a0c7-bcb4-2ca4-eec3-cb44f9ab1312@de.ibm.com>
In-Reply-To: <5828a0c7-bcb4-2ca4-eec3-cb44f9ab1312@de.ibm.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 11 Jul 2019 14:01:23 +0100
Message-ID: <CAFEAcA_5Kb0aAyJKjv7OEGP8MzUvNYxvmuDcWhL8kT1zcUrCag@mail.gmail.com>
Subject: Re: [Qemu-devel] [PULL 00/19] Migration patches
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Juan Quintela <quintela@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 11 Jul 2019 at 13:56, Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
>
>
>
> On 11.07.19 12:43, Juan Quintela wrote:
> > The following changes since commit 6df2cdf44a82426f7a59dcb03f0dd2181ed7fdfa:
> >
> >   Update version for v4.1.0-rc0 release (2019-07-09 17:21:53 +0100)
> >
> > are available in the Git repository at:
> >
> >   https://github.com/juanquintela/qemu.git tags/migration-pull-request
> >
> > for you to fetch changes up to 0b47e79b3d04f500b6f3490628905ec5884133df:
> >
> >   migration: allow private destination ram with x-ignore-shared (2019-07-11 12:30:40 +0200)
> >
> > ----------------------------------------------------------------
> > Migration pull request
> >
> > ----------------------------------------------------------------
> >
> [...]
> >  include/exec/memory.h        |   19 +
> >  include/exec/memory.h.rej    |   26 +
> >  include/exec/ram_addr.h      |   92 +-
> >  include/exec/ram_addr.h.orig |  488 +++
> [...]
> >  migration/ram.c              |   93 +-
> >  migration/ram.c.orig         | 4599 ++++++++++++++++++++++++++++++++++
> >  migration/ram.c.rej          |   33 +
>
> The .ref and .orig look odd. And they are is not part of the patches.

Good catch -- git diff says they are part of the pullreq so
they'd have ended up in the git repo if you hadn't noticed them.

thanks
-- PMM
