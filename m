Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6365697E9
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 17:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731795AbfGOPOG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 11:14:06 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:41305 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731600AbfGONsy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 09:48:54 -0400
Received: by mail-oi1-f194.google.com with SMTP id g7so12660599oia.8
        for <kvm@vger.kernel.org>; Mon, 15 Jul 2019 06:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KhkyjNmkbBt2TNHskueMzItP+CrD8zBwY2BmKGOgg24=;
        b=lmI7jgqwe/klpYvHZkRxhikM1BoM6wJfMh+JrykXLTcrQbog2aDqRwp25mzdsRqDig
         qEAagZuqq1sGl+epF5tcN+vcB+pIyfRLI269AvgeAsIOu+4UvMu76dVtldMfmQBgVoMo
         +vOXZq1n8y/eh70MGI83416zfyEhbBvY8cZii5YzXTapEakgID/bS3K/zM8jh5AzTPeS
         bPlYnbBpPe7UuYYfE/h7djLWag761E1+LpGxPrSUrxycnfkKP0eZ4tPqhL/sK4vAGqrF
         b5Td2iJ2+OhsIb4sjS/XYvJLQuMXNaLqohdbIRIoaidrSpkESo0eM7hEOkpMyYevJwpg
         grQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KhkyjNmkbBt2TNHskueMzItP+CrD8zBwY2BmKGOgg24=;
        b=BZCgFTAqUyg1vn3rfL8z2p9Isk12pfAUWEH2mqvKTkXB3ZUT60bov5Dy2hQrmGI/zs
         TMqyK0OW0j2YrkNLy6rbVHjorBHljpvnf2J6MgNwH4ON1CFDgmN2tAXmnL2LlpucECOD
         ev9BdVKiKNJP13YZM+B3hTAecqcbAhe623L/VcgPK9/daNZ9ewZAYRvCXC5Y0EWPv/nC
         kEZu0TFEA3cAda+9gfuJlK7zrLc9z3sa2/B8p2u58KVqqfh7QFwD/lDcHQblEpdp7afE
         7dciYnw6nM1xWBBO6rFjoVm8J0mZUzUhEwhjf5wSGM5SZFXJaTyfg+1kqQJP8uTSMg/F
         Y2Lw==
X-Gm-Message-State: APjAAAUAhgO7lrKsSSOStU9eeYpcxWxz2VRr+bOhFV0+KOslz6pwFmkP
        b/ypHfVe4dpPV5FBQwAPBSAxZSYKlHh/YHk2Qw8tmA==
X-Google-Smtp-Source: APXvYqxeCSv7UUCXqxX+f+jUbGXXh8dmymO3S+I1HW0faMk34f4/TcgmuVMDIIt3tGibA09eGd/lfrl/Am80fyL7O5Y=
X-Received: by 2002:aca:ac48:: with SMTP id v69mr12743117oie.48.1563198533124;
 Mon, 15 Jul 2019 06:48:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190712143207.4214-1-quintela@redhat.com> <CAFEAcA-ydNS072OH7CyGNq2+sESgonW-8QSJdNYJq6zW-rYjUQ@mail.gmail.com>
 <CAFEAcA9ncjtGdc8CZOJBDBRtzEU8oL7YicVg5PtyiiO2O4z51w@mail.gmail.com> <87zhlf76pk.fsf@trasno.org>
In-Reply-To: <87zhlf76pk.fsf@trasno.org>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Mon, 15 Jul 2019 14:48:42 +0100
Message-ID: <CAFEAcA_9tVQht7bp9_yrFEhQ74ye6LBNjEYK_nftCWsKMrOohw@mail.gmail.com>
Subject: Re: [PULL 00/19] Migration patches
To:     Juan Quintela <quintela@redhat.com>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
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

On Mon, 15 Jul 2019 at 14:44, Juan Quintela <quintela@redhat.com> wrote:
>
> Peter Maydell <peter.maydell@linaro.org> wrote:
> > On Fri, 12 Jul 2019 at 17:33, Peter Maydell <peter.maydell@linaro.org> wrote:
> >> Still fails on aarch32 host, I'm afraid:
>
> Hi
>
> dropping the multifd test patch from now.  For "some" reason, having a
> packed struct and 32bits is getting ugly, not sure yet _why_.

IMHO 'packed' structs are usually a bad idea. They have a bunch
of behaviours you may not be expecting (for instance they're
also not naturally aligned, and arrays of them won't be the
size you expect).

thanks
-- PMM
