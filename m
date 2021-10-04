Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206BC4214E5
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 19:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235271AbhJDROg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 13:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbhJDROf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 13:14:35 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFC0C061746
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 10:12:45 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id n64so22570694oih.2
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 10:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a+ErGJ+VGql1p2hYj8IB8VzyrOn66LWzrHaFsKIvDKc=;
        b=h3oETci+oft1UmX7a75PmczGicHfNM5s7F1GFBCDQAi2EkNVdjUq790hKUp30ANFFB
         VyrGByJzeZyminQFTMyMDLeLWiLWn0YYTgy/Eu9n88lHJh1Fi/M1vBf4/4eVqSgZKDRy
         ju5U30zZfx3TzeOig6VKJQYkuqmr6D2kRvJrrJ4wDzbUT/kgQ3q7E9lBVhpmjTwHuhF+
         /xHIwFAh0IyB9k4+YRnCvq7uLa54RD6q1ZEZb9fBuRnaeorCLkgAi91kVZPSVVH1mj2q
         Q7OyirHgV0SPFP3Nloc2CC8YfmIDiov3hLTpL77SAUKONdca4EAZznblaoem1xstXZxn
         H8AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a+ErGJ+VGql1p2hYj8IB8VzyrOn66LWzrHaFsKIvDKc=;
        b=Fo4uPEVdsYQLk6loubkKa79hC1TEiYThoFlkZs3zKQMlcH/dYnpL72NZdRMv3zUHqd
         yb7EwHv1PcKZaj7j/YGkvzTDVqH2+eTX+uFEGmwhFp3DI52j+9McZIO3HPyRlt+00RKx
         qXFHHZeudGZBokse3+qtQcEewhVf5SlIaeGg9lZzC/VG6OqN5VziYEhLObKcXWPlU6hY
         XzLvGo0pe4VdPDaD2a8BCWMZqHuYOzTUirGB70ap08cQXaixE8Z7K67PmDG7n3U9SE1H
         IqkYPnuxBcNMPuGWtRWkl8vhyDWn2QJIBPABDbW2zPgeB+zZ9hce8y+9isZmChFMXNOi
         RYJQ==
X-Gm-Message-State: AOAM533BXGJ9uv3ngTeuDxBqoJv4J6eUheUPqPCEISBJRxodDGE+cUUF
        ltanw4r1Amd34aSsQ8mm/AlqPu0avH64Bs9bIjo2aruMSro=
X-Google-Smtp-Source: ABdhPJzag2OrV2aOwtnwXxGEC4VTCSs3t51aHzUylqhKU0i/hVl2hLv/6niMCg7RcoueHw5ou6jKGxuaNmdDu8sY9jc=
X-Received: by 2002:a05:6808:180a:: with SMTP id bh10mr14867864oib.6.1633367564474;
 Mon, 04 Oct 2021 10:12:44 -0700 (PDT)
MIME-Version: 1.0
References: <1446878298.170497.1633338512925@office.mailbox.org>
 <b6abc5a3-39ea-b463-9df5-f50bdcb16d08@redhat.com> <936688112.157288.1633339838738@office.mailbox.org>
 <c4773ecc-053f-9bc6-03af-5039397a4531@redhat.com> <CAKwvOd=rrM4fGdGMkD5+kdA49a6K+JcUiR4K2-go=MMt++ukPA@mail.gmail.com>
In-Reply-To: <CAKwvOd=rrM4fGdGMkD5+kdA49a6K+JcUiR4K2-go=MMt++ukPA@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 4 Oct 2021 10:12:33 -0700
Message-ID: <CALMp9eRzadC50n=d=NFm7osVgKr+=UG7r2cWV2nOCfoPN41vvQ@mail.gmail.com>
Subject: Re: [BUG] [5.15] Compilation error in arch/x86/kvm/mmu/spte.h with clang-14
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, torvic9@mailbox.org,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 4, 2021 at 9:13 AM Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> On Mon, Oct 4, 2021 at 2:49 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 04/10/21 11:30, torvic9@mailbox.org wrote:
> > >
> > >> Paolo Bonzini <pbonzini@redhat.com> hat am 04.10.2021 11:26 geschrieben:
> > >>
> > >>
> > >> On 04/10/21 11:08, torvic9@mailbox.org wrote:
> > >>> I encounter the following issue when compiling 5.15-rc4 with clang-14:
> > >>>
> > >>> In file included from arch/x86/kvm/mmu/mmu.c:27:
> > >>> arch/x86/kvm/mmu/spte.h:318:9: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
> > >>>           return __is_bad_mt_xwr(rsvd_check, spte) |
> > >>>                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > >>>                                                    ||
> > >>> arch/x86/kvm/mmu/spte.h:318:9: note: cast one or both operands to int to silence this warning
> > >>
> > >> The warning is wrong, as mentioned in the line right above:

Casting the bool to an int doesn't seem that onerous.

> > > So it's an issue with clang-14 then?
> > > (I add Nick and Nathan)
> >
> > My clang here doesn't have the option, so I'm going to ask---are you
> > using W=1?  I can see why clang is warning for KVM's code, but in my
> > opinion such a check should only be in -Wextra.
>
> This is a newly added warning in top of tree clang.
>
> >
> > Paolo
> >
> > >>
> > >>           /*
> > >>            * Use a bitwise-OR instead of a logical-OR to aggregate the reserved
> > >>            * bits and EPT's invalid memtype/XWR checks to avoid an extra Jcc
> > >>            * (this is extremely unlikely to be short-circuited as true).
> > >>            */
> > >>
> > >> Paolo
> > >
> >
>
>
> --
> Thanks,
> ~Nick Desaulniers
