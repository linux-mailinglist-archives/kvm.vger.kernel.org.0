Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCB9581860
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 19:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239269AbiGZR3r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 13:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiGZR3q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 13:29:46 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97302BB08
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 10:29:44 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id p11so18833008lfu.5
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 10:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MP/Ab0S9sAQyirSnGuAJssl2esAmIx+VYnYcLH9RAyk=;
        b=oWPVqt+ki+QYSJaCvejN9OeTbJDihmhbcU23Q7FN0RVV2g9KhKrOAH6qLZhw2GLobp
         HCe4GZBBhrQze1TStn66b1zUX/nKTryjG2ngK5Z0hMskMzWRCJjQwVxNvy94gThyd5pV
         M4wL0Nasow4+Z07BTiOMfxlDXJy4eS9gl6nDDL2xbecy2njUbd4y8fK32CyAut82q3mR
         rbkc8hF0NotbfNSUk1nNfpCuX6YXAtsfMClNgT3EJOXy3Wj1C0QfHWNIM5wrPQRFZWxx
         Qv5y/5OwF4RV8NYcSPpKRL8SXiYvNzcRmYHwgR9wuMglRyiXx7Y301uRBAiZb9kAVUqE
         yuwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MP/Ab0S9sAQyirSnGuAJssl2esAmIx+VYnYcLH9RAyk=;
        b=RWZwoo9pbb3dWAy8VcYr39Pt3d6+VZ9RZM8kdz0dhaOtIej2j2Cv/k21QCae2dqmax
         R5sf6C4Ttnqj+1haWaiFX012IEQNwBnF2v4iQJWP27FdLDYdSQiKVLp//moiGRDhUZrg
         zC63YfjgPknhlDq48RweA+qSC2+s9ROtRRv/YybpE73WQNtIco+fBu64OjXY58OWgx3k
         FgYheIySJU01cKPPXcp04xFyjKysiq9p6t/YbwNXTsyd5su/4rRy/OEwnDkHUrhCQYeo
         4rML6k0l6nNsi7YNVCDHk9Ysbl7XOBgVyxd5xnVSEJ7n+VpjstztmJqvhIZ46ujKoR7/
         b2vA==
X-Gm-Message-State: AJIora9Mcqw/f71rVk+rZMAw3rXheAPFRxq9++R4heAfXvSJ0RlR01A6
        F7wPSI1il9HHSEr1eo5mYvFluJj47ZjmlYPGBPl+gw==
X-Google-Smtp-Source: AGRyM1uSJCBB3Nwle8uRGu29WkGYeJi5wqkbu7+n2lqWd/rsN0asYTQhvCtUAe0tKF5zm9t2QqbuRALneexQYCjoM8Y=
X-Received: by 2002:ac2:4d93:0:b0:489:c69d:59c0 with SMTP id
 g19-20020ac24d93000000b00489c69d59c0mr7015912lfe.329.1658856583020; Tue, 26
 Jul 2022 10:29:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220725163539.3145690-1-dmatlack@google.com> <Yt8c6gklsMy2eM5f@google.com>
In-Reply-To: <Yt8c6gklsMy2eM5f@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 26 Jul 2022 10:29:16 -0700
Message-ID: <CALzav=e6ZODi1Cpv5Ej9uWWC_zF1eMMJqbXYHhi+fgenfgsfow@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] KVM: selftests: Rename perf_test_util to memstress
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Andrew Jones <andrew.jones@linux.dev>
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

On Mon, Jul 25, 2022 at 3:45 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Jul 25, 2022, David Matlack wrote:
> > This series renames the perf_test_util to memstress. patch 1 renames the files
> > perf_test_util.[ch] to memstress.[ch], and patch 2 replaces the perf_test_
> > prefix on symbols with memstress_.
> >
> > The reason for this rename, as with any rename, is to improve readability.
> > perf_test_util is too generic and does not describe at all what the library
> > does, other than being used for perf tests.
> >
> > I considered a lot of different names (naming is hard) and eventually settled
> > on memstress for a few reasons:
> >
> >  - "memstress" better describes the functionality proveded by this library,
> >    which is to run a VM that reads/writes to memory from all vCPUs in parallel
> >    (i.e. stressing VM memory).
>
> Hmm, but the purpose of the library isn't to stress VM memory so much as it is to
> stress KVM's MMU. And typically "stress" tests just hammer a resource to try and
> make it fail, whereas measuring performance is one of the main
>
> In other words, IMO it would be nice to keep "perf" in there somehwere.

The reasons I leaned toward "stress" rather than "perf" is that this
library itself does not measure performance (it's just a workload) and
it's not always used for performance tests (e.g.
memslot_modification_stress_test.c).

>
> Maybe mmu_perf or something along those lines?

How about "memperf"? "mmu_perf" makes me think it'd be explicitly
measuring the performance of MMU operations.

Another contender was "memstorm", but I thought it might be too cute.

> I wouldn't worry too much about
> changing the number of chars, the churn wouldn't be thaaat bad.

Heh. The line lengths were getting long when I played with
"memory_stress" :). But yeah it's not really that much churn.
