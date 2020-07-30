Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35D6232C4A
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 09:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728858AbgG3HNl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 03:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbgG3HNl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 03:13:41 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0FFFC061794
        for <kvm@vger.kernel.org>; Thu, 30 Jul 2020 00:13:40 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id y22so22929342oie.8
        for <kvm@vger.kernel.org>; Thu, 30 Jul 2020 00:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o3sAhIVQ0azZpYHrUfnJ1dvzP8xZF2WLd0HbSWO3pxs=;
        b=llz1hS3m28x/N6gBltEen73pmeMmXH9gbiGbJjXByAyaGvxi7GaSFIs+MtYCz/JXV+
         JKqjnpIl6WYQHjPiPBTDkGpt8G0d3YmARw3Mr82+xucAK1Atvxg/ki23nPgKERTjM8Nx
         fIjn6msqHpPQIMGWwDzx6xwAgrR9wenOpVsqRAv8KfEsLB7ZJC69YhX7NjZJIn2BRvaN
         nE6Wlggi3NmU8nC0mla9rD3kVosgQu+7IELKEznvcSGQngiia1iUhtA4k8MtXcp9X6Uv
         NEUFL9Xc+4C2CieY1DbN3syfZS557VswfJoh4sEBr1cfdRUp4wz0rNciKXbNi4LImvQJ
         Dg9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o3sAhIVQ0azZpYHrUfnJ1dvzP8xZF2WLd0HbSWO3pxs=;
        b=VATZbjJWl4N+kYFYaiOmMrIqPauQ94Iv4F8C+cjmF3aF3e+F4G6BIQC7As6IUSYwOh
         0iz+x8BeNZEiqtrA2gPeUQGSnVyYyFSg2SqfahRSqsW0gq49qKvjhZBlZuBiUhWrltBv
         7SJ1BOT4n6CwT9eNg14uLA4vT9RC9732qcuy2n3CmNrlJOnrpbTINLZnB3J7SROIDwE1
         aiQRAytNHlT+IQCvjdJRh3V070KJkj8mvk1IdoHItH8zbKiG9HWnb/Fit2oLMkr71iIH
         TkzTikqcIjuHNDni3ZVHoDrvCINRXOy+2oyJtsiBh+mXm9KKoNHIJlf9YBqokCXERhxY
         7wIA==
X-Gm-Message-State: AOAM533fg7ViQzdtihdQbSyUghB9ZkgdR8VHjd1a2xcbp4picmtZEjk+
        zxy+5cj7yNzAxKQ0L+XjuHLHOVyQ5JtPi2iXgG8=
X-Google-Smtp-Source: ABdhPJwARtNDWQnPtEZJ808eotgGy+f3iiIe0XULWIjz28U5vu65tqt5debvvkl921nIve1lYzHeWca9RPw9rGOcILo=
X-Received: by 2002:aca:5842:: with SMTP id m63mr10701580oib.5.1596093220229;
 Thu, 30 Jul 2020 00:13:40 -0700 (PDT)
MIME-Version: 1.0
References: <dc518389-945a-1887-7ad0-00ebaf9ae30e@redhat.com>
 <682fe35c-f4ea-2540-f692-f23a42c6d56b@de.ibm.com> <c8e83bff-1762-f719-924f-618bd29e7894@redhat.com>
In-Reply-To: <c8e83bff-1762-f719-924f-618bd29e7894@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 30 Jul 2020 15:13:28 +0800
Message-ID: <CANRm+Czsb79JYAHcOm49tg=M2vHdOzh_XFaEcSS_RUPfX3dRuw@mail.gmail.com>
Subject: Re: A new name for kvm-unit-tests ?
To:     David Hildenbrand <david@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Huth <thuth@redhat.com>, KVM <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nadav Amit <namit@vmware.com>,
        Liran Alon <liran.alon@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 30 Jul 2020 at 15:10, David Hildenbrand <david@redhat.com> wrote:
>
> On 30.07.20 08:38, Christian Borntraeger wrote:
> >
> >
> > On 30.07.20 07:41, Thomas Huth wrote:
> >>
> >>  Hi all,
> >>
> >> since Paolo recently suggested to decrease the bus factor for
> >> kvm-unit-tests [1], I suggested (in a private mail) to maybe also move
> >> the repo to one of the git forges where we could benefit from a CI
> >
> > ack.
> >
> >> system (so that we do not merge bugs so often anymore as it happened in
> >> the previous months). If we do that step, that might be a good point in
> >> time to rename the kvm-unit-tests to something more adequate. "Why?" you
> >> might ask ... well, the unit tests are not only useful for kvm anymore:
> >
> > I personally dislike renames as you will have old references lurking in
> > the internet for decades. A rename will result in people continue to using
> > the old code because the old name is the only thing that they know.
> >
> > [...]
> >> Maybe we should come up with a more fancy name for the test suite? For
> >> example something like "HECATE" - "*H*ypervisor *E*xecution and *C*pu
> >> instruction *A*dvanced *T*est *E*nvironment" (and Hecate is also the
> >> goddess of boundaries - which you could translate to the hypervisor
> >> being the boundary between the virtual and real machine ... with a
> >> little bit of imagination, of course) ... well, yeah, that's just what
> >> came to my mind so far, of course. Let's brainstorm ... do you have any
> >> good ideas for a new name of the kvm-unit-tests? Or do you love the old
> >> name and think it should stay? Or do you think cpu-unit-tests would be
> >> the best fit? Please let us know!
> >
> > If we rename than hecate or cpu-unit-tests is fine for me, but I prefer
> > to keep the old name.
>
> +1 for keeping the old name.
>
> cpu-unit-tests might also not be completely fitting (I remember we
> already do test, or will test in the future I/O stuff like PCI, CCW, ...).
>
> IMHO, It's much more a collection of tests to verify
> architecture/standard/whatever compliance (including paravirtualized
> interfaces if available).

Vote for keeping the old name.

    Wanpeng
