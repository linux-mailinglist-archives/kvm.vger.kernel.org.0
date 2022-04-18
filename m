Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30756505C78
	for <lists+kvm@lfdr.de>; Mon, 18 Apr 2022 18:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346215AbiDRQco (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 12:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346356AbiDRQcf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 12:32:35 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E5B1ADB4
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 09:29:55 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id w5so4168880lji.4
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 09:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ACTXoCAAPWGoVloJ2EChe4T7s6GZlY4X8j8GihvZ3tM=;
        b=HF3T4mfkjpsmLehz1/tS7TVpSB651oSEXAy9LFxM4Cc9sKtBkSNUWdU5q9rLIK9OCA
         ftRLlsNgVBJ1J5Arabq5Ye+bmKzq8fA12+fAebj2cN/HTx7C8gpPtTmJgQud/DKw02TJ
         3s327PHRVZNqD3QT158Yh44wswuruCrG4HB8xB+xig2UmEYPDaxpvzeeFmmBIJ1nk5qZ
         1n7htO0T+PdZiuX87JGBYvKlnH4mmhtm2oMwwFJZI23zVzqNcGog9KbrCjOa+Uhteb+b
         KPzV8lX4IAfbFxA9f0F5+7FDG1tP+aPixIwk2fVHETOQqDTXjQ9Eg7Te6yN9eIQkNf1e
         wf7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ACTXoCAAPWGoVloJ2EChe4T7s6GZlY4X8j8GihvZ3tM=;
        b=WrWadOoGM5gIZBoCRT54MtMp9YhUKZ8fYeEyO8qu4bfT0VDnEV1POH0j8xZ7yp3dWh
         dttUxG1jXv9q1Np+7QRZL1yBL5T0rYXTPrisBe9uQe9S+HjY8ReZFq3xrEbX9MSyAHun
         zPK0wiLvBY8b626d1kbBYQKy/m5WbPTTco6Pw8vNStfjkVgvroR0+gJziehkc97oV6Iq
         oIDSLttomgS0FZutOfvGgcDZWuDE5tvQqCRAORJRIbV6JwBxHP2TQs62GU5kQzwSJCYT
         MiojuPosT55sAMylYSbWDEsi1HR7qhjMR3I0qwJkQGnshXlngbCErTUP+ZfNvz/2bvEF
         MkIA==
X-Gm-Message-State: AOAM530PGd946oPrRy+Aebq4Xtti+d5+pV2/eZYB6Q+ua1unDA98SUzz
        AyhqB2qGxr9OHY9wtRvEcpEgzU/Re8BlD8tWZ9lmuQ==
X-Google-Smtp-Source: ABdhPJyvuiGgXGN0OEytNZ0J/MDCq8oEDCWzgeniVmVsLwc3DBFKVnJYqd47PNLkmyfkgyMU4S5hwbn9gH67w6uScyE=
X-Received: by 2002:a2e:8e93:0:b0:24d:ab45:4053 with SMTP id
 z19-20020a2e8e93000000b0024dab454053mr7630884ljk.231.1650299393165; Mon, 18
 Apr 2022 09:29:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220325233125.413634-1-vipinsh@google.com> <CALzav=e6W2VSp=btmqTpQJ=3bH+Bw3D8sLApkTTvMMKAnw_LAw@mail.gmail.com>
 <CAHVum0dOfJ5HuscNq0tA6BnUJK34v4CPCTkD4piHc7FObZOsng@mail.gmail.com>
 <b754fa0a-4f9e-1ea5-6c77-f2410b7f8456@redhat.com> <CAHVum0d=WoqxZ4vUYY37jeQL1yLdiwbYjPSPFAa1meM5LUBDQQ@mail.gmail.com>
In-Reply-To: <CAHVum0d=WoqxZ4vUYY37jeQL1yLdiwbYjPSPFAa1meM5LUBDQQ@mail.gmail.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Mon, 18 Apr 2022 09:29:16 -0700
Message-ID: <CAHVum0eF=CmqXabrJS7rsVxhQLKA7v8iG1SjThcEJ=_zAUhRsg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Speed up slot_rmap_walk_next for sparsely
 populated rmaps
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 8, 2022 at 12:31 PM Vipin Sharma <vipinsh@google.com> wrote:
>
> On Sun, Mar 27, 2022 at 3:41 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 3/26/22 01:31, Vipin Sharma wrote:
> > >>> -static void slot_rmap_walk_next(struct slot_rmap_walk_iterator *iterator)
> > >>> +static noinline void
> > >>
> > >> What is the reason to add noinline?
> > >
> > > My understanding is that since this method is called from
> > > __always_inline methods, noinline will avoid gcc inlining the
> > > slot_rmap_walk_next in those functions and generate smaller code.
> > >
> >
> > Iterators are written in such a way that it's way more beneficial to
> > inline them.  After inlining, compilers replace the aggregates (in this
> > case, struct slot_rmap_walk_iterator) with one variable per field and
> > that in turn enables a lot of optimizations, so the iterators should
> > actually be always_inline if anything.
> >
> > For the same reason I'd guess the effect on the generated code should be
> > small (next time please include the output of "size mmu.o"), but should
> > still be there.  I'll do a quick check of the generated code and apply
> > the patch.
> >
> > Paolo
> >
>
> Let me know if you are still planning to modify the current patch by
> removing "noinline" and merge or if you prefer a v2 without noinline.

Hi Paolo,

Any update on this patch?

Thanks
Vipin
