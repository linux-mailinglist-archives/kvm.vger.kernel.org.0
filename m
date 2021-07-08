Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A363C1B27
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 23:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbhGHVqc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 17:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbhGHVqb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jul 2021 17:46:31 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB88C06175F
        for <kvm@vger.kernel.org>; Thu,  8 Jul 2021 14:43:49 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id q4so4664748ljp.13
        for <kvm@vger.kernel.org>; Thu, 08 Jul 2021 14:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kK2wX+ivQOCZabWVoev4LcXQ/QBkeFJ944RfY0NnbuQ=;
        b=j4jFsAY5JGZqtOjxmWW3NB9Q9FEH9Deo0Dlqn8dEiNhuGOcI29ZRy1Wv+v19hfaynC
         Z4bmc4cykXiKBbMLM8jQAKZSTOWEfV8LLqewPbjHIbFArzNul6RHqVDEURiGX06TJk+V
         gP6/L0Yg1nz0pZK4+EtmcP2EQtEOEaeActRyfD7kIN/MjF3w2x+POsAt6HKNHMX7eTTJ
         d9x32GDk2YJeTEsGOWeAIdk8T01r8IlIWoSB0IdSEknJZ7Fh3bQexmIIZbwJWcWAU6+p
         ymNHVZKN1EXZkKxBF1Ad5/r1hx1OiIoeDq7GIfF+EzzuHjtWxO2qoWYOlVU6DHaPnDRc
         O9bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kK2wX+ivQOCZabWVoev4LcXQ/QBkeFJ944RfY0NnbuQ=;
        b=kpOvyRCRvWhaLykos6wgBMEdQYBPvP2h+bzBIJNkQZgeQ101H1ZMv3xs2nb6fhdJUj
         PrjCzP4KyTcq0RGmwdV/dUT70Froc8gJuqagymJn/ZRUEVCEGn1/mYQzh/pn8DVTXjhK
         wG9C8qlgBV1SsepI5IzaZ80Z3pfteAUu8h7KRbz2BzzrbLvQCO9TuEWXkp/KnKr0WpOV
         eK2Isi/R6jbAS0fU+QEKCFu4NVmuGcb6y0TwybZ3k5haW6Gul+Rd+HaEwdue/cSnKjhm
         vuVgYBJV/iRIknGHBwbskmlhmb39+mnuI5JN4DlcjfrZ5IzcVDNJaqVgBPAZjwgzgAeJ
         MxAw==
X-Gm-Message-State: AOAM530mc5keCL+0A4+o5MFcg1Msk8N1L8dNeIyQQ/yqnKe2d8IX2ZOc
        oI78qJZBsTWg49lFH8lSlPgqtNkScAzI7JDpbzOC6w==
X-Google-Smtp-Source: ABdhPJx3FXdWZIXmIxdCunt5xodRiktH2WQvpAC46U5F1slb2tyyqaVzjhVFn5yp9WGUPlWmQ++tw/pDDNGn4tUZWZU=
X-Received: by 2002:a2e:5812:: with SMTP id m18mr7760332ljb.394.1625780627397;
 Thu, 08 Jul 2021 14:43:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210706180350.2838127-1-jingzhangos@google.com>
 <20210706180350.2838127-3-jingzhangos@google.com> <YOdqvvmE2ly6o9Fa@google.com>
 <YOdrGg47GnvyEDPF@google.com>
In-Reply-To: <YOdrGg47GnvyEDPF@google.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Thu, 8 Jul 2021 16:43:35 -0500
Message-ID: <CAAdAUtg2uFeQb9vum-gmeYbqmpZzkk4Z8VFMr+XJQSiH-A3ZNA@mail.gmail.com>
Subject: Re: [PATCH v1 2/4] KVM: stats: Update doc for histogram statistics
To:     David Matlack <dmatlack@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 8, 2021 at 4:16 PM David Matlack <dmatlack@google.com> wrote:
>
> On Thu, Jul 08, 2021 at 09:14:38PM +0000, David Matlack wrote:
> > On Tue, Jul 06, 2021 at 06:03:48PM +0000, Jing Zhang wrote:
> > > Add documentations for linear and logarithmic histogram statistics.
> > > Add binary stats capability text which is missing during merge of
> > > the binary stats patch.
> > >
> > > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > > ---
> > >  Documentation/virt/kvm/api.rst | 36 +++++++++++++++++++++++++++++++---
> > >  1 file changed, 33 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > > index 3b6e3b1628b4..948d33c26704 100644
> > > --- a/Documentation/virt/kvm/api.rst
> > > +++ b/Documentation/virt/kvm/api.rst
> > > @@ -5171,6 +5171,9 @@ by a string of size ``name_size``.
> > >     #define KVM_STATS_TYPE_CUMULATIVE       (0x0 << KVM_STATS_TYPE_SHIFT)
> > >     #define KVM_STATS_TYPE_INSTANT          (0x1 << KVM_STATS_TYPE_SHIFT)
> > >     #define KVM_STATS_TYPE_PEAK             (0x2 << KVM_STATS_TYPE_SHIFT)
> > > +   #define KVM_STATS_TYPE_LINEAR_HIST      (0x3 << KVM_STATS_TYPE_SHIFT)
> > > +   #define KVM_STATS_TYPE_LOG_HIST         (0x4 << KVM_STATS_TYPE_SHIFT)
> > > +   #define KVM_STATS_TYPE_MAX              KVM_STATS_TYPE_LOG_HIST
> > >
> > >     #define KVM_STATS_UNIT_SHIFT            4
> > >     #define KVM_STATS_UNIT_MASK             (0xF << KVM_STATS_UNIT_SHIFT)
> > > @@ -5178,11 +5181,13 @@ by a string of size ``name_size``.
> > >     #define KVM_STATS_UNIT_BYTES            (0x1 << KVM_STATS_UNIT_SHIFT)
> > >     #define KVM_STATS_UNIT_SECONDS          (0x2 << KVM_STATS_UNIT_SHIFT)
> > >     #define KVM_STATS_UNIT_CYCLES           (0x3 << KVM_STATS_UNIT_SHIFT)
> > > +   #define KVM_STATS_UNIT_MAX              KVM_STATS_UNIT_CYCLES
> > >
> > >     #define KVM_STATS_BASE_SHIFT            8
> > >     #define KVM_STATS_BASE_MASK             (0xF << KVM_STATS_BASE_SHIFT)
> > >     #define KVM_STATS_BASE_POW10            (0x0 << KVM_STATS_BASE_SHIFT)
> > >     #define KVM_STATS_BASE_POW2             (0x1 << KVM_STATS_BASE_SHIFT)
> > > +   #define KVM_STATS_BASE_MAX              KVM_STATS_BASE_POW2
> >
> > Should these FOO_MAX additions go in a separate commit too?
> >
> > >
> > >     struct kvm_stats_desc {
> > >             __u32 flags;
> > > @@ -5214,6 +5219,22 @@ Bits 0-3 of ``flags`` encode the type:
> > >      represents a peak value for a measurement, for example the maximum number
> > >      of items in a hash table bucket, the longest time waited and so on.
> > >      The corresponding ``size`` field for this type is always 1.
> > > +  * ``KVM_STATS_TYPE_LINEAR_HIST``
> > > +    The statistics data is in the form of linear histogram. The number of
> > > +    buckets is specified by the ``size`` field. The size of buckets is specified
> > > +    by the ``hist_param`` field. The range of the Nth bucket (1 <= N < ``size``)
> >
> > Using 1-based indexes is a little jarring but maybe that's just me :).
> >
> > > +    is [``hist_param``*(N-1), ``hist_param``*N), while the range of the last
> > > +    bucket is [``hist_param``*(``size``-1), +INF). (+INF means positive infinity
> > > +    value.) The bucket value indicates how many times the statistics data is in
> > > +    the bucket's range.
> > > +  * ``KVM_STATS_TYPE_LOG_HIST``
> > > +    The statistics data is in the form of logarithmic histogram. The number of
> > > +    buckets is specified by the ``size`` field. The base of logarithm is
> > > +    specified by the ``hist_param`` field. The range of the Nth bucket (1 < N <
> >
> > Should 1 be 2 here? The first bucket uses a slightly differen formula as
> > you mention in the next sentence.
>
> Oops I see you used "<" instead of "<=" so what you have is correct. I
> think reordering the sentences would still be helpfull though.
>
Sure, will reorder the sentences as you suggested.
> >
> > Actually it may be clearer if you re-ordered the sentences a bit:
> >
> >   The range of the first bucket is [0, 1), while the range of the last
> >   bucket is [pow(hist_param, size-1), +INF). Otherwise the Nth bucket
> >   (1-indexed) covers [pow(hist_param, N-2), pow(histparam, N-1)).
> >
> > > +    ``size``) is [pow(``hist_param``, N-2), pow(``hist_param``, N-1)). The range
> > > +    of the first bucket is [0, 1), while the range of the last bucket is
> > > +    [pow(``hist_param``, ``size``-2), +INF). The bucket value indicates how many
> > > +    times the statistics data is in the bucket's range.
> > >
> > >  Bits 4-7 of ``flags`` encode the unit:
> > >    * ``KVM_STATS_UNIT_NONE``
> > > @@ -5246,9 +5267,10 @@ unsigned 64bit data.
> > >  The ``offset`` field is the offset from the start of Data Block to the start of
> > >  the corresponding statistics data.
> > >
> > > -The ``unused`` field is reserved for future support for other types of
> > > -statistics data, like log/linear histogram. Its value is always 0 for the types
> > > -defined above.
> > > +The ``hist_param`` field is used as a parameter for histogram statistics data.
> > > +For linear histogram statistics data, it indicates the size of a bucket. For
> > > +logarithmic histogram statistics data, it indicates the base of the logarithm.
> > > +Only base of 2 is supported fo logarithmic histogram.
> >
> > s/fo/for/
> >
> > >
> > >  The ``name`` field is the name string of the statistics data. The name string
> > >  starts at the end of ``struct kvm_stats_desc``.  The maximum length including
> > > @@ -7182,3 +7204,11 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
> > >  of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
> > >  the hypercalls whose corresponding bit is in the argument, and return
> > >  ENOSYS for the others.
> > > +
> > > +8.35 KVM_CAP_STATS_BINARY_FD
> > > +----------------------------
> > > +
> > > +:Architectures: all
> > > +
> > > +This capability indicates the feature that userspace can get a file descriptor
> > > +for every VM and VCPU to read statistics data in binary format.
> > > --
> > > 2.32.0.93.g670b81a890-goog
> > >
