Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 349A03C152E
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 16:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbhGHOcV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 10:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbhGHOcV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jul 2021 10:32:21 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3804CC06175F
        for <kvm@vger.kernel.org>; Thu,  8 Jul 2021 07:29:38 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id f13so16100015lfh.6
        for <kvm@vger.kernel.org>; Thu, 08 Jul 2021 07:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KlZJUqaLgsBO7mX3KI8iI1wIxb+SgVZoM88aZKw+rzA=;
        b=obWPsghibGoeU7rd3DensnAXBnHvwcxiIoKHrfURhiEUGBvfx5jrCXoh4K+JYC/OOz
         7ZTtmjLST2bp4ANmZsR2f0WoB75kcsJ93MscKpT4kwOP80YTAcguMNu5sKnIiWprpcql
         PNtHAJD+L7aKWTxcThzPzvOj26jSDSHcf5W/cCTgMsgBAG/4kLEd3h3+xtgm3y0wfjEe
         G+Fz1MmJaiaJlPSpBQqZZfX6dPKZLVCBl3eH4QX9W9j3oDv6pEuY1J3Ihh/LapbI6wIp
         8hnZyKa/5C+ded+7G8att1ZG++q/hdXFyOZpMxTnYasV5ka8Zgwh3M1TxoZS4umQOSTQ
         Kdhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KlZJUqaLgsBO7mX3KI8iI1wIxb+SgVZoM88aZKw+rzA=;
        b=RsPL+xFexDrZB0Gk5tUae6Pz3WrPRHoJLTqE7ru9wq52puYwmLH8/36xumMdGdgYSQ
         5CJ5WpPopvBx+x1KBWHmLe8lCN5BuibLEgGL5dC49qglDZJPxaXWCCnAT+IIPh3CUxKl
         6W+ni2QSTVCz/2NfTjQhjbdr9TRwk9r6jYjtqFO+5EFDGg+hSPk82Y0dMvxYjk1wYXDQ
         Xk3exTfdcJZcaBM3KNuFY/NHyEf79oH4XWSEgajX9X8yqA3fuhxkMkX3fZnfk4K6sE8z
         xX8iNrr3j7EoX3rg1Rzjes3Fuf2BYSD/u3Oj/uQy+6TU5Q3lvC8keui5PztNmD5jYj5G
         iK6g==
X-Gm-Message-State: AOAM531fqxObHnSf0ETG6nv2svilSS+697FpBZnPEe4lQzXiqj6sDf63
        ccryMghtn89xcNRvfBdKk7veO8m9w5o8ckFdQHatww==
X-Google-Smtp-Source: ABdhPJwJ/gHUqnQQLrEM6QdPY6amGL54L7H/DfwpiDkcpLDdlO7X6rs7//kecyIH8fJQDv9E7jx6T2rRQARezra5svE=
X-Received: by 2002:a2e:3513:: with SMTP id z19mr15574170ljz.256.1625754576203;
 Thu, 08 Jul 2021 07:29:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210706180350.2838127-1-jingzhangos@google.com>
 <20210706180350.2838127-3-jingzhangos@google.com> <YOY5QndV0O3giRJ2@google.com>
In-Reply-To: <YOY5QndV0O3giRJ2@google.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Thu, 8 Jul 2021 09:29:24 -0500
Message-ID: <CAAdAUtiA91MzByviP=0VEtiHi2dAp9PryKmgD1p+qE4Re9HCJg@mail.gmail.com>
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

On Wed, Jul 7, 2021 at 6:31 PM David Matlack <dmatlack@google.com> wrote:
>
> On Tue, Jul 06, 2021 at 06:03:48PM +0000, Jing Zhang wrote:
> > Add documentations for linear and logarithmic histogram statistics.
> > Add binary stats capability text which is missing during merge of
> > the binary stats patch.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  Documentation/virt/kvm/api.rst | 36 +++++++++++++++++++++++++++++++---
> >  1 file changed, 33 insertions(+), 3 deletions(-)
> >
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index 3b6e3b1628b4..948d33c26704 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -5171,6 +5171,9 @@ by a string of size ``name_size``.
> >       #define KVM_STATS_TYPE_CUMULATIVE       (0x0 << KVM_STATS_TYPE_SHIFT)
> >       #define KVM_STATS_TYPE_INSTANT          (0x1 << KVM_STATS_TYPE_SHIFT)
> >       #define KVM_STATS_TYPE_PEAK             (0x2 << KVM_STATS_TYPE_SHIFT)
> > +     #define KVM_STATS_TYPE_LINEAR_HIST      (0x3 << KVM_STATS_TYPE_SHIFT)
> > +     #define KVM_STATS_TYPE_LOG_HIST         (0x4 << KVM_STATS_TYPE_SHIFT)
> > +     #define KVM_STATS_TYPE_MAX              KVM_STATS_TYPE_LOG_HIST
> >
> >       #define KVM_STATS_UNIT_SHIFT            4
> >       #define KVM_STATS_UNIT_MASK             (0xF << KVM_STATS_UNIT_SHIFT)
> > @@ -5178,11 +5181,13 @@ by a string of size ``name_size``.
> >       #define KVM_STATS_UNIT_BYTES            (0x1 << KVM_STATS_UNIT_SHIFT)
> >       #define KVM_STATS_UNIT_SECONDS          (0x2 << KVM_STATS_UNIT_SHIFT)
> >       #define KVM_STATS_UNIT_CYCLES           (0x3 << KVM_STATS_UNIT_SHIFT)
> > +     #define KVM_STATS_UNIT_MAX              KVM_STATS_UNIT_CYCLES
> >
> >       #define KVM_STATS_BASE_SHIFT            8
> >       #define KVM_STATS_BASE_MASK             (0xF << KVM_STATS_BASE_SHIFT)
> >       #define KVM_STATS_BASE_POW10            (0x0 << KVM_STATS_BASE_SHIFT)
> >       #define KVM_STATS_BASE_POW2             (0x1 << KVM_STATS_BASE_SHIFT)
> > +     #define KVM_STATS_BASE_MAX              KVM_STATS_BASE_POW2
> >
> >       struct kvm_stats_desc {
> >               __u32 flags;
> > @@ -5214,6 +5219,22 @@ Bits 0-3 of ``flags`` encode the type:
> >      represents a peak value for a measurement, for example the maximum number
> >      of items in a hash table bucket, the longest time waited and so on.
> >      The corresponding ``size`` field for this type is always 1.
> > +  * ``KVM_STATS_TYPE_LINEAR_HIST``
> > +    The statistics data is in the form of linear histogram. The number of
> > +    buckets is specified by the ``size`` field. The size of buckets is specified
> > +    by the ``hist_param`` field. The range of the Nth bucket (1 <= N < ``size``)
> > +    is [``hist_param``*(N-1), ``hist_param``*N), while the range of the last
> > +    bucket is [``hist_param``*(``size``-1), +INF). (+INF means positive infinity
> > +    value.) The bucket value indicates how many times the statistics data is in
> > +    the bucket's range.
> > +  * ``KVM_STATS_TYPE_LOG_HIST``
> > +    The statistics data is in the form of logarithmic histogram. The number of
> > +    buckets is specified by the ``size`` field. The base of logarithm is
> > +    specified by the ``hist_param`` field. The range of the Nth bucket (1 < N <
> > +    ``size``) is [pow(``hist_param``, N-2), pow(``hist_param``, N-1)). The range
> > +    of the first bucket is [0, 1), while the range of the last bucket is
> > +    [pow(``hist_param``, ``size``-2), +INF). The bucket value indicates how many
> > +    times the statistics data is in the bucket's range.
> >
> >  Bits 4-7 of ``flags`` encode the unit:
> >    * ``KVM_STATS_UNIT_NONE``
> > @@ -5246,9 +5267,10 @@ unsigned 64bit data.
> >  The ``offset`` field is the offset from the start of Data Block to the start of
> >  the corresponding statistics data.
> >
> > -The ``unused`` field is reserved for future support for other types of
> > -statistics data, like log/linear histogram. Its value is always 0 for the types
> > -defined above.
> > +The ``hist_param`` field is used as a parameter for histogram statistics data.
> > +For linear histogram statistics data, it indicates the size of a bucket. For
> > +logarithmic histogram statistics data, it indicates the base of the logarithm.
> > +Only base of 2 is supported fo logarithmic histogram.
> >
> >  The ``name`` field is the name string of the statistics data. The name string
> >  starts at the end of ``struct kvm_stats_desc``.  The maximum length including
> > @@ -7182,3 +7204,11 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
> >  of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
> >  the hypercalls whose corresponding bit is in the argument, and return
> >  ENOSYS for the others.
> > +
> > +8.35 KVM_CAP_STATS_BINARY_FD
> > +----------------------------
> > +
> > +:Architectures: all
> > +
> > +This capability indicates the feature that userspace can get a file descriptor
> > +for every VM and VCPU to read statistics data in binary format.
>
> This should probably be in a separate patch with a Fixes tag.
>
> Fixes: fdc09ddd4064 ("KVM: stats: Add documentation for binary statistics interface")
>
> > --
> > 2.32.0.93.g670b81a890-goog
> >
Thanks David.
Jing
