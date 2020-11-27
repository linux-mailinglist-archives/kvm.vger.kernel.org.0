Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3222B2C6C8F
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 21:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731726AbgK0U3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 15:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731747AbgK0U1Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Nov 2020 15:27:25 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8A4C061A04
        for <kvm@vger.kernel.org>; Fri, 27 Nov 2020 12:20:48 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id q13so7937348lfr.10
        for <kvm@vger.kernel.org>; Fri, 27 Nov 2020 12:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wq5aPWBOYfgE0ikLgKOb/75PgZgI1EkZa0hkLcr2E6E=;
        b=LIRHhHFIkM/Wpdo44zJO/nUYNrS+gJ0aecPyjsSYd8yPt5l7XJsEgxH6VluvZ0l2c8
         SxkO84qW52Zqb3ZiSgF1lDgqzBV+MlcdgFO3ZowglCYgd+BRmFg17FEnlLafGdblK5s/
         B3QPELYXQKnl2eFyB+OjIbaxgEFtKKGHdr8XwYWm3WPMSSRAPPhdzcrwFHF+Z9+4GLDh
         qeBz/MGtUfU/PYmoBosJRa8XkQ4ACohZRg7L17a0lN10TaXaWR+qqvoYi1QWNBpX7P4C
         L+CeuduU0Y40aOHEfYkSzUJUpJHJtMDynlFnqLlaOH1tlUe6LxUwKpbUA3YkNI+Mk5wH
         CfbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wq5aPWBOYfgE0ikLgKOb/75PgZgI1EkZa0hkLcr2E6E=;
        b=T0SUjPTF/gMmD84Y7v7TsI0yzUh7o16+OrGyvBl/qBTNcOH0oQ9b+O5Pm7USlSV5vK
         su5a7R/C/Q/+EtOIaSfvPmdLKxAmjhIvqCIi0TsQ+6mgJ3l/rPrxDtbK/Vm2S1RoaYwH
         RE1m/MDNMxnKXjnj5AJPZNjpkpAzeVtC2UpQQbzJaZwhkdVvP0CTBMlFb8C4TrXX9wI6
         vVqNrIprUYCcyzSlvGIF7b1Ki1HUw6Izbw/2KKuAmoIOPcsYJDTa0TZ+zFcqtoR7GcQW
         m8SsOpSuXRSZUWTnb1cozfAe/HXFCylbgyD54tLqpYpcOg059eg+aRJs0OClPgWyb7ON
         MeLw==
X-Gm-Message-State: AOAM531P9F3QkZClFF7vBreq8JC6ts8vzp1n5tpbw3DBxmBan0Fqmek6
        jOonAvi8sQaNlvRYtMNro3EEJWITYyAKtIpLAHFFOg==
X-Google-Smtp-Source: ABdhPJyiw7lwgD7IoK6mA6mBXxN3hEsO6avakTr/7wyhqC2uMw7qd0GXA+MXPFHMDZckGCqsV53ONzvSTrdB21Gj/Ek=
X-Received: by 2002:a19:8c13:: with SMTP id o19mr4194624lfd.573.1606508446532;
 Fri, 27 Nov 2020 12:20:46 -0800 (PST)
MIME-Version: 1.0
References: <3E05451B-A9CD-4719-99D0-72750A304044@amazon.com>
 <CAG48ez2VAu6oARGVZ+muDK9_6_38KVUTJf7utz5Nn=AsmN17nA@mail.gmail.com>
 <CAG48ez13ZAAOVmA89PRKRqr9UezV2_bj8Q6_6sSPzcqfzbsuQQ@mail.gmail.com> <e4acbcdb-7ee4-5dfb-ffbf-19eb49cef9c6@amazon.com>
In-Reply-To: <e4acbcdb-7ee4-5dfb-ffbf-19eb49cef9c6@amazon.com>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 27 Nov 2020 21:20:19 +0100
Message-ID: <CAG48ez2akv0pGSt084sNHtESbjJNXpx=Ko86JEsyZM24+5zLqw@mail.gmail.com>
Subject: Re: [PATCH v2] drivers/virt: vmgenid: add vm generation id driver
To:     "Catangiu, Adrian Costin" <acatan@amazon.com>
Cc:     "Graf (AWS), Alexander" <graf@amazon.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, Willy Tarreau <w@1wt.eu>,
        "MacCarthaigh, Colm" <colmmacc@amazon.com>,
        Andy Lutomirski <luto@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "bonzini@gnu.org" <bonzini@gnu.org>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>,
        "oridgar@gmail.com" <oridgar@gmail.com>,
        "ghammer@redhat.com" <ghammer@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Qemu Developers <qemu-devel@nongnu.org>,
        KVM list <kvm@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Linux API <linux-api@vger.kernel.org>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        linux-s390 <linux-s390@vger.kernel.org>,
        "areber@redhat.com" <areber@redhat.com>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Andrey Vagin <avagin@gmail.com>,
        Mike Rapoport <rppt@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        "gil@azul.com" <gil@azul.com>,
        "asmehra@redhat.com" <asmehra@redhat.com>,
        "dgunigun@redhat.com" <dgunigun@redhat.com>,
        "vijaysun@ca.ibm.com" <vijaysun@ca.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 27, 2020 at 8:04 PM Catangiu, Adrian Costin
<acatan@amazon.com> wrote:
> On 27/11/2020 20:22, Jann Horn wrote:
> > On Fri, Nov 20, 2020 at 11:29 PM Jann Horn <jannh@google.com> wrote:
> >> On Mon, Nov 16, 2020 at 4:35 PM Catangiu, Adrian Costin
> >> <acatan@amazon.com> wrote:
> >>> This patch is a driver that exposes a monotonic incremental Virtual
> >>> Machine Generation u32 counter via a char-dev FS interface that
> >>> provides sync and async VmGen counter updates notifications. It also
> >>> provides VmGen counter retrieval and confirmation mechanisms.
> >>>
> >>> The hw provided UUID is not exposed to userspace, it is internally
> >>> used by the driver to keep accounting for the exposed VmGen counter.
> >>> The counter starts from zero when the driver is initialized and
> >>> monotonically increments every time the hw UUID changes (the VM
> >>> generation changes).
> >>>
> >>> On each hw UUID change, the new hypervisor-provided UUID is also fed
> >>> to the kernel RNG.
> >> As for v1:
> >>
> >> Is there a reasonable usecase for the "confirmation" mechanism? It
> >> doesn't seem very useful to me.
>
> I think it adds value in complex scenarios with multiple users of the
> mechanism, potentially at varying layers of the stack, different
> processes and/or runtime libraries.
>
> The driver offers a natural place to handle minimal orchestration
> support and offer visibility in system-wide status.
>
> A high-level service that trusts all system components to properly use
> the confirmation mechanism can actually block and wait patiently for the
> system to adjust to the new world. Even if it doesn't trust all
> components it can still do a best-effort, timeout block.

What concrete action would that high-level service be able to take
after waiting for such an event?

My model of the vmgenid mechanism is that RNGs and cryptographic
libraries that use it need to be fundamentally written such that it is
guaranteed that a VM fork can not cause the same random number /
counter / ... to be reused for two different cryptographic operations
in a way visible to an attacker. This means that e.g. TLS libraries
need to, between accepting unencrypted input and sending out encrypted
data, check whether the vmgenid changed since the connection was set
up, and if a vmgenid change occurred, kill the connection.

Can you give a concrete example of a usecase where the vmgenid
mechanism is used securely and the confirmation mechanism is necessary
as part of that?

> >> How do you envision integrating this with libraries that have to work
> >> in restrictive seccomp sandboxes? If this was in the vDSO, that would
> >> be much easier.
>
> Since this mechanism targets all of userspace stack, the usecase greatly
> vary. I doubt we can have a single silver bullet interface.
>
> For example, the mmap interface targets user space RNGs, where as fast
> and as race free as possible is key. But there also higher level
> applications that don't manage their own memory or don't have access to
> low-level primitives so they can't use the mmap or even vDSO interfaces.
> That's what the rest of the logic is there for, the read+poll interface
> and all of the orchestration logic.

Are you saying that, because people might not want to write proper
bindings for this interface while also being unwilling to take the
performance hit of calling read() in every place where they would have
to do so to be fully correct, you want to build a "best-effort"
mechanism that is deliberately designed to allow some cryptographic
state reuse in a limited time window?

> Like you correctly point out, there are also scenarios like tight
> seccomp jails where even the FS interfaces is inaccessible. For cases
> like this and others, I believe we will have to work incrementally to
> build up the interface diversity to cater to all the user scenarios
> diversity.

It would be much nicer if we could have one simple interface that lets
everyone correctly do what they need to, though...
