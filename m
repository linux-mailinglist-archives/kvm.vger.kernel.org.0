Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A37E4E9F93
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 21:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245538AbiC1TPm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 15:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245534AbiC1TPk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 15:15:40 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A16C488AA
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 12:13:59 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id w7so26476694lfd.6
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 12:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fPHcThhavYQoi1CRvCTyZV8TYj/0992Wtfs4sW93D/I=;
        b=Ndlw/8Us34OEJZq/npk2kS+igmzvUQCNI/fg/kB0v2fEuXBXD2WikwIN4dTzk2MNqu
         9TJWkML/0Xv7P8la/hH3Mn7LYbKA9mMzyt6kgbUQBELx8ZyjdHH8IsnNAdScOe1Hxw+E
         cXoTsKmvvOY1MZ5izparRhp5siMFuJ87zMo45G4hBxF6MIs3bbeOXbkNw6qi02/I5hzf
         Aud6rjbOuNpdq/SvyDaYW4T/0lIGeuaaGETpTl3k/4p5x6kvk++bfbgfFPIIkBlT20kJ
         DsUltenM6gEZ58KIVZcn8lFBlXba9ulIvOWSqCs1hMQXlsXAWn/0j0j4zMD0I4kb8nf2
         wn7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fPHcThhavYQoi1CRvCTyZV8TYj/0992Wtfs4sW93D/I=;
        b=iH5AlT2nbM+7cuw+mrujqMiNkxitQ2BBUirw1YXLYeV7DOK2iVdwvq1vno24DpMV+a
         Xbk+swvxB4eKLo1ckQ44uRk4gSqGtXbfDuH1ZXZ8SjhQlE/IImmVqFLmYwVG6gu1SS0y
         HYB1wsjeLoQiqZ71AjjCXqJ7ekBxPWIunIWYBJiFlV/0kf1kNI4X7+v3/tFN2wS1G/px
         ntyBB9JWZpksZa9zWPz2KMl9WNZ1TzE4oU6bYwShLMX/4DrDfW2/N4szs4FisOLpohTG
         TkD9cX3jtbjzcu3zgU4SmiZTz/OjesrN88C6Aa6qWt00iDJtR04RyyItbt3esYP4TdLL
         xL2g==
X-Gm-Message-State: AOAM533Dv3Sw4LmFqugCfRz4jJvfprtsKxw6Cekp0roNxHrJ+M4EsyKL
        5ofxT78afXSCsQve9fN+xf9zEDUV9co12Ahr5zWLog==
X-Google-Smtp-Source: ABdhPJyonMOo0lWVKSKdR2MkojMlBg3HqAgbTvfhfHLEW1XK+4ZAsDlUjefFU7c4OUBEsk0QLt7A3pB4rS7fCAVcbgk=
X-Received: by 2002:ac2:5d49:0:b0:44a:37de:9d98 with SMTP id
 w9-20020ac25d49000000b0044a37de9d98mr21134273lfd.580.1648494834715; Mon, 28
 Mar 2022 12:13:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220325233125.413634-1-vipinsh@google.com> <CALzav=e6W2VSp=btmqTpQJ=3bH+Bw3D8sLApkTTvMMKAnw_LAw@mail.gmail.com>
 <CAHVum0dOfJ5HuscNq0tA6BnUJK34v4CPCTkD4piHc7FObZOsng@mail.gmail.com> <b754fa0a-4f9e-1ea5-6c77-f2410b7f8456@redhat.com>
In-Reply-To: <b754fa0a-4f9e-1ea5-6c77-f2410b7f8456@redhat.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Mon, 28 Mar 2022 12:13:18 -0700
Message-ID: <CAHVum0cynwp5Phx=v2LV33Hsa8viq0jpVLh0Q_ZtpUZVy6Lm9w@mail.gmail.com>
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thank you David and Paolo, for checking this patch carefully. With
hindsight, I should have explicitly mentioned adding "noinline" in my
patch email.

On Sun, Mar 27, 2022 at 3:41 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 3/26/22 01:31, Vipin Sharma wrote:
> >>> -static void slot_rmap_walk_next(struct slot_rmap_walk_iterator *iterator)
> >>> +static noinline void
> >>
> >> What is the reason to add noinline?
> >
> > My understanding is that since this method is called from
> > __always_inline methods, noinline will avoid gcc inlining the
> > slot_rmap_walk_next in those functions and generate smaller code.
> >
>
> Iterators are written in such a way that it's way more beneficial to
> inline them.  After inlining, compilers replace the aggregates (in this
> case, struct slot_rmap_walk_iterator) with one variable per field and
> that in turn enables a lot of optimizations, so the iterators should
> actually be always_inline if anything.
>
> For the same reason I'd guess the effect on the generated code should be
> small (next time please include the output of "size mmu.o"), but should
> still be there.  I'll do a quick check of the generated code and apply
> the patch.

Yeah, I should have added the "size mmu.o" output. Here is what I have found:

size arch/x86/kvm/mmu/mmu.o

Without noinline:
              text      data     bss       dec        hex filename
          89938   15793      72  105803   19d4b arch/x86/kvm/mmu/mmu.o

With noinline:
              text      data     bss        dec       hex filename
          90058   15793      72  105923   19dc3 arch/x86/kvm/mmu/mmu.o

With noinline, increase in size = 120

Curiously, I also checked file size with "ls -l" command
File size:
        Without noinline: 1394272 bytes
        With noinline: 1381216 bytes

With noinline, decrease in size = 13056 bytes

I also disassembled mmu.o via "objdump -d" and found following
Total lines in the generated assembly:
        Without noinline: 23438
        With noinline: 23393

With noinline, decrease in assembly code = 45

I can see in assembly code that there are multiple "call" operations
in the "with noinline" object file, which is expected and has less
lines of code compared to "without noinline". I am not sure why the
size command is showing an increase in text segment for "with
noinline" and what to infer with all of this data.

Thanks
Vipin
