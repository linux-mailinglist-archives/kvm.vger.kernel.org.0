Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F08D44EFF3
	for <lists+kvm@lfdr.de>; Sat, 13 Nov 2021 00:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbhKLXPO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 18:15:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbhKLXPL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 18:15:11 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D84C061766
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 15:12:20 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id h11so21484337ljk.1
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 15:12:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iMTvT7NsOtiVrtb1ierayNB1hBIVaQnurs1N94fLgF8=;
        b=ersYV9JSN6rOg3zxZlrbNSTpFEgDl1UVqBfTJhN1zQ3nZ/fL+Uz/r80g3jc1Y4wCcj
         6CEDOJyZGpVJPgR6W+Y3rlx/AljcLlvRUYImunH3HBi6IgN4HgHbbJU3MkEJ/+JUiiSx
         Yb99wopDfmk2MEBWI564gXfQQbK56cb2l3NPARPHdu4GklGGSZ7F6/mVwNHKjcGJ6zk4
         OPii0OdHtbiSUNbqdM7RF9CZ8Vf09USAcWTVVaI0F4vJvtKoDwcQKgmgQgdRObJtD4Yk
         4TYgzvcyiuoyX55Lk5nn5oFssD40zA3OqYmbdymWqBIuVfObmph5EghMhDh7lma+39oF
         ZA2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iMTvT7NsOtiVrtb1ierayNB1hBIVaQnurs1N94fLgF8=;
        b=AEPeFNaaqMvPK54BL14CVp03zDrvi3ru4NgPkdt5ZIzEcHm8oeMg0gCrd75z1zyoIY
         7VJEuK3yZhAr5RZ3SMwrR1rPMxK+I3Is8l6W2wfD2iBGkTmdmqSM6TB/+Y/d72oxuLVB
         AJuuYPaUKdU/BWJ2+KCJNgw5DNXasE/aBUflnfJJ3gVrwszi3XyhA1/8QvhxWglh3OcO
         EQoH3c0oIfzs663nL5LT8dOda0GJqul5CIG1yVtIMH4mYO6huTiU8wXQvrvDio5so5L+
         PFcVH3HZCUvNv1io6YHi7cwkm5HQM8tom5vb0uZxdiNSyxhtKOO8eZASpzkT782CA76P
         FKuw==
X-Gm-Message-State: AOAM532hSDeaA5MfCvKktKoGCxdFPN+M6JQyoG4jHXmQ/2DWdPDE0iGp
        6jcmEgzRAOs7Y9BZj5LidIi/J2QJISrlr2xKKxelSQ==
X-Google-Smtp-Source: ABdhPJydU+hzM9MotqBxJ2F97X4iN4bm+1rkOt+Kax0ud7PwjIKZFoahzTavEcVxq70QB9KNwcWvpJ5XcjMWnenIhzY=
X-Received: by 2002:a05:651c:1507:: with SMTP id e7mr11130345ljf.83.1636758738318;
 Fri, 12 Nov 2021 15:12:18 -0800 (PST)
MIME-Version: 1.0
References: <20211111154930.3603189-1-pbonzini@redhat.com>
In-Reply-To: <20211111154930.3603189-1-pbonzini@redhat.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 12 Nov 2021 16:12:06 -0700
Message-ID: <CAMkAt6qtNcOSP93SYsj_s4EfbyV9L5K0aHgTBT+PJ5uJ-zjM1g@mail.gmail.com>
Subject: Re: [PATCH v12 0/7] Add AMD SEV and SEV-ES intra host migration support
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 11, 2021 at 8:49 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> This is a fixed version of Peter Gonda's series.  The main change is
> that it uses the "bugged" VM implementation (now renamed to "dead")
> to ensure the source VM is inoperational, and that it correctly
> charges the current cgroup for the ASID.
>
> I also renamed the capability to KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM,
> since it is similar to KVM_CAP_VM_COPY_ENC_CONTEXT_FROM.
>
> Paolo Bonzini (2):
>   KVM: generalize "bugged" VM to "dead" VM
>   KVM: SEV: provide helpers to charge/uncharge misc_cg

Thanks for these Paolo! I took a quick look through these. I can send
some additional testing for the new "dead" VM functionality on the
source side VM and I'll try to test when the cgroup is maxed out we
can still do an intra-host migration (make sure we aren't charging
double during the migration) in a follow up patch. I guess the cgroup
stuff in general could use some testing.

Also thanks for the detailed reviews Sean.

>
> Peter Gonda (5):
>   KVM: SEV: Refactor out sev_es_state struct
>   KVM: SEV: Add support for SEV intra host migration
>   KVM: SEV: Add support for SEV-ES intra host migration
>   selftest: KVM: Add open sev dev helper
>   selftest: KVM: Add intra host migration tests
>
>  Documentation/virt/kvm/api.rst                |  15 +
>  arch/x86/include/asm/kvm_host.h               |   1 +
>  arch/x86/kvm/svm/sev.c                        | 303 +++++++++++++++---
>  arch/x86/kvm/svm/svm.c                        |   9 +-
>  arch/x86/kvm/svm/svm.h                        |  28 +-
>  arch/x86/kvm/x86.c                            |   8 +-
>  include/linux/kvm_host.h                      |  12 +-
>  include/uapi/linux/kvm.h                      |   1 +
>  tools/testing/selftests/kvm/Makefile          |   3 +-
>  .../testing/selftests/kvm/include/kvm_util.h  |   1 +
>  .../selftests/kvm/include/x86_64/svm_util.h   |   2 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  24 +-
>  tools/testing/selftests/kvm/lib/x86_64/svm.c  |  13 +
>  .../selftests/kvm/x86_64/sev_migrate_tests.c  | 203 ++++++++++++
>  virt/kvm/kvm_main.c                           |  10 +-
>  15 files changed, 551 insertions(+), 82 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
>
> --
> 2.27.0
>
