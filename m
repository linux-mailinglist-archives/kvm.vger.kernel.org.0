Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93EFE1E0428
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 02:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388462AbgEYA06 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 May 2020 20:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388014AbgEYA05 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 May 2020 20:26:57 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7B0C061A0E;
        Sun, 24 May 2020 17:26:57 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id e1so15591936wrt.5;
        Sun, 24 May 2020 17:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vo+PEr3ThFugXAxWUKbQS6Sgo7Ct30K9zT/l1PQSZzY=;
        b=MNuTohxdsNrs+I2lcPknVdqhPu3Niw7DMSTSIdwxqelIoBKu5E2XQJuQpHOppji+Ku
         cFBMlyivTNfbhi/TGP+0fWvQf8wJpFFa6YjCz2Jl4MiljckpxoT4qXAoMUNXvc4VUKXt
         fTT6/ZKmn1WyjWGjj0HgNYDXpURzzaPDOeqWe4WH7SRFMNylehCpk8GUB1++aKj9dvdW
         RxbG//xeHqYQWLJ0uGevZRo0iLoviA4v7Ah1x/tG1Vme6GfwF4run0IAUEKWni10uxxg
         u+ZLdMGmj5PU5Mi3IgFXpqVVb/2ZNgUJ/rzdkjZcksyPEydDOoch3LzBO0cBztgNJj4j
         ZPLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vo+PEr3ThFugXAxWUKbQS6Sgo7Ct30K9zT/l1PQSZzY=;
        b=eXh6jy5FMXcbL2IA+5drMz+Ztt5M8Ji35vRJ7SiaLcodz1IiFFn+uOCSqBy8Re8cvi
         HOTBdNdcFvkfoJk9OIOY8eJ7JGVG2foqMjCo9WK3yEP4E6u+Rc2YJWYlXTbuoFYoJFBJ
         3D88jlN0/T1sY4eHyEM0pheK0gV9IDwuya/Ed5+tvwB08DPyOgOc/XBAixD1l5Ii9PUB
         iPoP/ZO/uxTucE5CqH30u++syEVao70jbMDUYSUz0ciyT84j/ZGpwVl7s9Hy5ZhnZJuj
         mrX4DHvbmkiTjaEy4T+slBH3VcM+GGGOCDWpHJW8xy3dvPKVplA7ASujgiW6sDz9iV1J
         Vauw==
X-Gm-Message-State: AOAM532f2CZXGN0cA3mjY33u0Sqw0w/maNjUWVowEdyrWLIIuq6zwvSN
        m4uIoTkfb/wTTnlNYO31YG/LG4NiLUdmECDqOFw=
X-Google-Smtp-Source: ABdhPJzQc0lI/qGMzcqdCCUpCUHxAjDZSQGq2RYrZZpKUbnDevc2RxM4cL4KS4u+V9WlhLgzzeROsty+zKa9EXjhyT8=
X-Received: by 2002:adf:ab4e:: with SMTP id r14mr2553160wrc.147.1590366416154;
 Sun, 24 May 2020 17:26:56 -0700 (PDT)
MIME-Version: 1.0
References: <1590318819-24520-1-git-send-email-chenhc@lemote.com>
In-Reply-To: <1590318819-24520-1-git-send-email-chenhc@lemote.com>
From:   Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Date:   Mon, 25 May 2020 02:26:42 +0200
Message-ID: <CAHiYmc7sBuG8p2cZ_28UH8kSPpBLe5dj9fDWo45NZWLGcBvhpg@mail.gmail.com>
Subject: Re: [PATCH V8 00/15] KVM: MIPS: Add Loongson-3 support (Host Side)
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        kvm <kvm@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> V7 -> V8:
> 1, Rebase to be applied on kvm tree, i.e., the linux-next branch of
>    https://git.kernel.org/pub/scm/virt/kvm/kvm.git/. Building KVM/MIPS
>    need commit 3fbfb4585bfd4ff34e ("mips: define pud_index() regardless
>    of page table folding"), which has already been in mips tree but not
>    in kvm tree.
>

Huacai,

I do support and salute the series (as I always did), as I see it as a
giant step forward for KVM for MIPS.

However, in general, I think any series should not depend on "pick
that patch from another tree", and should be a stand-alone unit that
yields to successful build and desired functionality. If there is a
dependency like you described, the patch in question, in my opinion,
should be integrated into the series in question. Git is even smart
enough that it recognizes the same patch has been applied before, so
integration of another tree would not be exposed to problems.

From the point of view of synchronizing with QEMU part, and the timing
issues wrt kernel and QEMU releases, I want to stress that it is
better that this series is integrated sooner rather than later. In
other words, I think that potential Paolo's KVM pull request should
happen before Thomas' mips-next pull request (Paolo could include
"mips: define pud_index() regardless of page table folding", and
Thomas could simply omit it).

But, that said, I don't feel I should impose my opinion to others
here. Take my statements just as advises. I defer the decision on how
to proceed with the integration of this series entirely to Paolo and
Thomas.

Yours,
Aleksandar
