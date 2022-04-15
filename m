Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E82E502E4D
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 19:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242599AbiDORZS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 13:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235083AbiDORZR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 13:25:17 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65607673C2
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 10:22:48 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-e2a00f2cc8so8599157fac.4
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 10:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o6RNsbAcvCjfLqiPEs8YxqK7loPVDDokLUvNoulF59A=;
        b=YweDAQH+57nyCbJiqTnmkuUixI0hWysuyaXXtwPl3/6lG2I95P04KxY4xevBp2oDi5
         N2b1gYZz2AgMCA7rsRMrENUcSHNF+PZ80sUPPAhpqjyBy+ZapY68bn1sIN01p+OwnE6v
         4VbELWcqE3txh+y/CFb+J6I2FHs8d9m3jFE3nAoJK1pV3rcFbERu89afjZMdSx30pF4C
         YzWBBVmc+VAp5R0ydxi/CJ9TZPER/XEngAwrBkxb5UB0AIY1DGXDUZWDFUFNOrJwcq6B
         7b9wAHZPvWKw3ZcxqzN7OusbpVhLq3BBTmm2yLBiZsjkhGa3+MSm8nMS+IvjZ92vcKre
         Ho5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o6RNsbAcvCjfLqiPEs8YxqK7loPVDDokLUvNoulF59A=;
        b=evmOSqDYL+d3NE3i853ExGjyJA6vY50CXeL53Q6kuS1sNwW547L4AMP/vG05FW25mF
         u1MZF1xWbVtFtxlWkVymLu+C+lQVvBkh2tUNGyfuH/rHrFF+905JxhjkTWOT01vRfvsb
         0MGAqFgra828JR7XePi5+WgOC240zVVnBjlea1VZn95AquJDuug+Eq+uF5mcsBfb0Qej
         ZJqzKMJ0bIJqun/LrplmiOa9Xo641xPS6yyL74oUBJRWD1m6D8+1wVWGnSF7C+fJiafJ
         uPr1XnUD/S8mTrOBHxYvkUM26TEs19HRm5IQDdCv93F63d0z2AZ1G+Op6LyEu6sEOcKJ
         KVBQ==
X-Gm-Message-State: AOAM532iiEc6P0znvIaiDaJrBuDdIbw7i1j5cd3LePs/kBFwgBNuWuDj
        zhJu89aLEORmQVKK01kpuPM4OTSJfDPZj/bGTX7bFCkAIKk=
X-Google-Smtp-Source: ABdhPJxuQ62977eaW89duCoZWBSSdyIYp+iXxmPwaGhWVI/9BJ7AMqAdYncAi2ohxULElZke7mkX3BBPj9pCklWQdnQ=
X-Received: by 2002:a05:6870:40cc:b0:de:15e7:4df0 with SMTP id
 l12-20020a05687040cc00b000de15e74df0mr1826725oal.110.1650043367504; Fri, 15
 Apr 2022 10:22:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220224105451.5035-1-varad.gautam@suse.com> <20220224105451.5035-12-varad.gautam@suse.com>
 <Ykzx5f9HucC7ss2i@google.com> <Yk/nid+BndbMBYCx@suse.de> <YlmkBLz4udVfdpeQ@google.com>
In-Reply-To: <YlmkBLz4udVfdpeQ@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Fri, 15 Apr 2022 10:22:36 -0700
Message-ID: <CAA03e5ETN6dhjSpPYTAGicCuKGjaTe-kVvAaMDC1=_EONfL=Sw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3 11/11] x86: AMD SEV-ES: Handle string IO
 for IOIO #VC
To:     Sean Christopherson <seanjc@google.com>
Cc:     Joerg Roedel <jroedel@suse.de>,
        Varad Gautam <varad.gautam@suse.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>, bp@suse.de
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

On Fri, Apr 15, 2022 at 9:57 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Apr 08, 2022, Joerg Roedel wrote:
> > On Wed, Apr 06, 2022 at 01:50:29AM +0000, Sean Christopherson wrote:
> > > On Thu, Feb 24, 2022, Varad Gautam wrote:
> > > > Using Linux's IOIO #VC processing logic.
> > >
> > > How much string I/O is there in KUT?  I assume it's rare, i.e. avoiding it entirely
> > > is probably less work in the long run.
> >
> > The problem is that SEV-ES support will silently break if someone adds
> > it unnoticed and without testing changes on SEV-ES.
>
> But IMO that is extremely unlikely to happen.  objdump + grep shows that the only
> string I/O in KUT comes from the explicit asm in emulator.c and amd_sev.c.  And
> the existence of amd_sev.c's version suggests that emulator.c isn't supported.
> I.e. this is being added purely for an SEV specific test, which is silly.
>
> And it's not like we're getting validation coverage of the exit_info, that also
> comes from software in vc_ioio_exitinfo().
>
> Burying this in the #VC handler makes it so much harder to understand what is
> actually be tested, and will make it difficult to test the more interesting edge
> cases.  E.g. I'd really like to see a test that requests string I/O emulation for
> a buffer that's beyond the allowed size, straddles multiple pages, walks into
> non-existent memory, etc.., and doing those with a direct #VMGEXIT will be a lot
> easier to write and read then bouncing through the #VC handler.

For the record, I like the current approach of implementing a #VC
handler within kvm-unit-tests itself for the string IO.

Rationale:
- Makes writing string IO tests easy.
- We get some level of testing of the #VC handler in the guest kernel
in the sense that this #VC handler is based on that one. So if we find
an issue in this handler we know we probably need to fix that same
issue in the guest kernel #VC handler.
- I don't follow the argument that having a direct #VMGEXIT in the
test itself makes the test easerit to write and read. It's going to
add a lot of extra code to the test that makes it hard to parse the
actual string IO operations and expectations IMHO.
- I agree that writing test cases to straddle multiple pages, walk
into non-existent memory, etc. is an excellent idea. But I don't
follow how exposing the test itself to the #VC exit makes this easier.
Worst case, the kvm-unit-tests can be extended with some sort of
helper to expose to the test the scratch buffer size and whether it's
embedded in the GHCB or external.
