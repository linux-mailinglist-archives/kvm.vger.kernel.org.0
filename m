Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCF646466AE
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 02:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiLHB5O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 20:57:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiLHB5L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 20:57:11 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874979075D
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 17:57:10 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id d128so25068108ybf.10
        for <kvm@vger.kernel.org>; Wed, 07 Dec 2022 17:57:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sgZQZKod6we+ImeEyiG1D+f4JgWlzUQbiuVGgB2oWc0=;
        b=iLRCrUtTrivQY/VNlpIW5PxLBLiVFIu5r5x/7Gq7JZ5VBc4VGPHNXWbqi9oGkr+L24
         1O0HnrawGj43v0vv3GbCYrcPbO55iW49bRH2+rx0tbTOV7NcuDfR/P4ps/EG8Jn5Y5Y1
         oIRJOIJDgfp4m/d7AroY72PmVGgKRDXTFSmHIvai29avrqQzJLLEEGT7DI/S4YCk2Nxu
         B0ZFxzpRCY9NU8mcLWhmTZ8ihaxFIONgixzNTRyDJdkgo102qvc7WejaajERLyzPNoV9
         kxbDp0AB8Hada5eNQhvfe5JBOBYVag4aaoboqWJDO5diArqYyY2Qx/SSFiZGsrD8e3rk
         CSAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sgZQZKod6we+ImeEyiG1D+f4JgWlzUQbiuVGgB2oWc0=;
        b=iJxCpSkaBxTKN8xayJw/9sdCa56kmQKBYcCTHQOHBGV7UR9lkqjbDDsJi3/DobD3+M
         eh5zjbKJMApYvZ4FPiTQWUuoJQt0VcbFpSKtDjl1zKW/QjiXEOC7BcPovcqOJfRYE8Py
         CnmXUIc4sATkxph91rwbLhAIPOWyZOC69bnCa+RYflSSkK7KCRyOY3z6qCJsYKvRVdIp
         4V71LvVJPo7oZl+KZcZFDq477UxiVOESDt8ZGnb1lyB/M+h0jq/oTXjA/FBeYAdkjoo5
         a7t84UkJ90kP5VuDoOpLF70lzeEeWVbliu3O/0hWokvI1Krrc9PCUnWOG2ASvMa0lrR6
         sQZA==
X-Gm-Message-State: ANoB5pni+PXm4yCtHeq83gGfy6zwmBqhdYELlZqCp6HbZJZ/g/2Oi/3E
        3kU1xQiRRkLkmuzQGta6CehuxXPmPNramBuneV6pWw==
X-Google-Smtp-Source: AA0mqf7qQLRJfGdTJCsgR9vxHtzEIM6grxclRadtbUckzrnP/lLgyh/1Vmp45w4SYZNrGCkCHUnVWMD56Ot1gNdGcjU=
X-Received: by 2002:a25:b948:0:b0:6de:6c1:922e with SMTP id
 s8-20020a25b948000000b006de06c1922emr90363887ybm.0.1670464629602; Wed, 07 Dec
 2022 17:57:09 -0800 (PST)
MIME-Version: 1.0
References: <CADrL8HVDB3u2EOhXHCrAgJNLwHkj2Lka1B_kkNb0dNwiWiAN_Q@mail.gmail.com>
 <Y4qgampvx4lrHDXt@google.com> <Y44NylxprhPn6AoN@x1n> <CALzav=d=N7teRvjQZ1p0fs6i9hjmH7eVppJLMh_Go4TteQqqwg@mail.gmail.com>
 <Y442dPwu2L6g8zAo@google.com> <CADrL8HV_8=ssHSumpQX5bVm2h2J01swdB=+at8=xLr+KtW79MQ@mail.gmail.com>
 <Y46VgQRU+do50iuv@google.com> <CADrL8HVM1poR5EYCsghhMMoN2U+FYT6yZr_5hZ8pLZTXpLnu8Q@mail.gmail.com>
 <Y4+DVdq1Pj3k4Nyz@google.com> <CADrL8HVftX-B+oHLbjnJCret01yjUpOjQfmHdDa7mYkMenOa+A@mail.gmail.com>
In-Reply-To: <CADrL8HVftX-B+oHLbjnJCret01yjUpOjQfmHdDa7mYkMenOa+A@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 7 Dec 2022 17:56:43 -0800
Message-ID: <CALzav=cyPgsYPZfxsUFMBJ1j33LHxfSY-Bj0ttZqjozDm745Nw@mail.gmail.com>
Subject: Re: [RFC] Improving userfaultfd scalability for live migration
To:     James Houghton <jthoughton@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Linux MM <linux-mm@kvack.org>, kvm <kvm@vger.kernel.org>,
        chao.p.peng@linux.intel.com, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 6, 2022 at 12:41 PM James Houghton <jthoughton@google.com> wrote:
> On Tue, Dec 6, 2022 at 1:01 PM Sean Christopherson <seanjc@google.com> wrote:
> > Can you elaborate on what makes it better?  Or maybe generate a list of pros and
> > cons?  I can think of (dis)advantages for both approaches, but I haven't identified
> > anything that would be a blocking issue for either approach.  Doesn't mean there
> > isn't one or more blocking issues, just that I haven't thought of any :-)
>
> Let's see.... so using no-slow-GUP over no UFFD waiting:
> - No need to take mmap_lock in mem fault path.
> - Change the relevant __gfn_to_pfn_memslot callers
> (kvm_faultin_pfn/user_mem_abort/others?) to set `atomic = true` if the
> new CAP is used.
> - No need for a new PF_NO_UFFD_WAIT (would be toggled somewhere
> in/near kvm_faultin_pfn/user_mem_abort).
> - Userspace has to indirectly figure out the state of the page tables
> to know what action to take (which introduces some weirdness, like if
> anyone MADV_DONTNEEDs some guest memory, we need to know).

I'm no expert but I believe a guest access to MADV_DONTNEED'd GFN
would just cause a new page to be allocated by the kernel. So I think
userspace can still blindly do MADV_POPULATE_WRITE in this case. Were
there any other scenarios you had in mind?

> - While userfaultfd is registered (so like during post-copy), any
> hva_to_pfn() calls that were resolvable with slow GUP before (without
> dropping into handle_userfault()) will now need to be resolved by
> userspace manually with a call to MADV_POPULATE_WRITE. This extra trip
> to userspace could slow things down.

Is there any way to enable fast-gup to identify when a PTE is not
present due to userfaultfd specifically without taking the mmap_lock
(e.g. using an unused bit in the PTE)? Then we could avoid extra trips
to userspace for MADV_POPULATE_WRITE.

>
> Both of these seem pretty simple to implement in the kernel; the most
> complicated part is just returning KVM_EXIT_MEMORY_FAULT in more
> places / for other architectures (I care about x86 and arm64).
>
> Right now both approaches seem fine to me. Not having to take the
> mmap_lock in the fault path, while being such a minor difference now,
> could be a huge benefit if we can later get around to making
> UFFDIO_CONTINUE not need the mmap lock. Disregarding that, not
> requiring userspace to guess the state of the page tables seems
> helpful (less bug-prone, I guess).
>
> >
> > > When KVM_RUN exits:
> > > - If we haven't UFFDIO_CONTINUE'd yet, do that now and restart KVM_RUN.
> > > - If we have, then something bad has happened. Slow GUP already ran
> > > and failed, so we need to treat this in the same way we treat a
> > > MADV_POPULATE_WRITE failure above: userspace might just want to crash
> > > (or inject a memory error or something).
> > >
> > > - James
