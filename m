Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9661E045A
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 03:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388330AbgEYBX4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 May 2020 21:23:56 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:33127 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388104AbgEYBXz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 May 2020 21:23:55 -0400
Received: by mail-io1-f66.google.com with SMTP id k18so17289463ion.0;
        Sun, 24 May 2020 18:23:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zCFEPEQJSVR+2frxcrHLzNcELHQb8FtRYHK8V6RTIVw=;
        b=ogAIPpZEzfhTyhN+DEzwjF6FzubL7cKNOOtDy9PLBjy3E6Bb48/ksU+9TZ94wvv0LO
         OrQalTPBj3IA5rtd6d1mcDgC+/M838wwlQz9Em6hqyTBUqHOHh8wLcQqGVUcjq6NUMdY
         tyaJoyt3vqFW+YohpiqpDIuKAfOzrXKPpk0+qhLZVSn1d3GZrhSBd+DBshdSVkaTC9GO
         AR+zeIp8jCMueZcc0r0C8nQXbZdnc1W9wxmf1b/kpEym2C+8hPDPolp1ZplrZPX+3OLE
         oLp2jbKo3PWKfR5b6tC+S09898F1Vo5DAtTz7NmnSzTs1iAv9xYngT3rBojrUNzmjFqm
         ZmhA==
X-Gm-Message-State: AOAM533/dODWw8OtIVp/J+GRoN0pbs2H8mCOAOFXVWAv9gRKlnCwNfUk
        gDlQHh2+tj67Az13KR/QXW9u/HXwvaT+QbKwmiU=
X-Google-Smtp-Source: ABdhPJwWIU91/gftTyHKWrKsP3bcniFoxRfxoCmW6g9p0EIkrMLlFvDwQG3k8xB9cAEYu99NvX0aRnM3iL3u/kMhPxE=
X-Received: by 2002:a02:942a:: with SMTP id a39mr17334476jai.50.1590369833541;
 Sun, 24 May 2020 18:23:53 -0700 (PDT)
MIME-Version: 1.0
References: <1590318819-24520-1-git-send-email-chenhc@lemote.com> <CAHiYmc7sBuG8p2cZ_28UH8kSPpBLe5dj9fDWo45NZWLGcBvhpg@mail.gmail.com>
In-Reply-To: <CAHiYmc7sBuG8p2cZ_28UH8kSPpBLe5dj9fDWo45NZWLGcBvhpg@mail.gmail.com>
From:   Huacai Chen <chenhc@lemote.com>
Date:   Mon, 25 May 2020 09:23:41 +0800
Message-ID: <CAAhV-H56E2LLHM-0UPLeR0vKDw=qJaRU9QYbxzNc=St_QK9oOA@mail.gmail.com>
Subject: Re: [PATCH V8 00/15] KVM: MIPS: Add Loongson-3 support (Host Side)
To:     Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        kvm <kvm@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Aleksandar,

On Mon, May 25, 2020 at 8:26 AM Aleksandar Markovic
<aleksandar.qemu.devel@gmail.com> wrote:
>
> > V7 -> V8:
> > 1, Rebase to be applied on kvm tree, i.e., the linux-next branch of
> >    https://git.kernel.org/pub/scm/virt/kvm/kvm.git/. Building KVM/MIPS
> >    need commit 3fbfb4585bfd4ff34e ("mips: define pud_index() regardless
> >    of page table folding"), which has already been in mips tree but not
> >    in kvm tree.
> >
>
> Huacai,
>
> I do support and salute the series (as I always did), as I see it as a
> giant step forward for KVM for MIPS.
>
> However, in general, I think any series should not depend on "pick
> that patch from another tree", and should be a stand-alone unit that
> yields to successful build and desired functionality. If there is a
> dependency like you described, the patch in question, in my opinion,
> should be integrated into the series in question. Git is even smart
> enough that it recognizes the same patch has been applied before, so
> integration of another tree would not be exposed to problems.
>
> From the point of view of synchronizing with QEMU part, and the timing
> issues wrt kernel and QEMU releases, I want to stress that it is
> better that this series is integrated sooner rather than later. In
> other words, I think that potential Paolo's KVM pull request should
> happen before Thomas' mips-next pull request (Paolo could include
> "mips: define pud_index() regardless of page table folding", and
> Thomas could simply omit it).
>
> But, that said, I don't feel I should impose my opinion to others
> here. Take my statements just as advises. I defer the decision on how
> to proceed with the integration of this series entirely to Paolo and
> Thomas.
I think I lack some experience of cross-subsystem development, so in
V8 I only adjust the context of my own patches to let the series be
applied on kvm tree, but didn't consider patches already in other
trees (Moreover, that patch is not mine). So, should I send a V9 that
take commit 3fbfb4585bfd4ff3 together?

Thanks,
Huacai
>
> Yours,
> Aleksandar
