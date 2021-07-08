Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1573C1AE7
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 23:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbhGHVS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 17:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbhGHVS5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jul 2021 17:18:57 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A66FC06175F
        for <kvm@vger.kernel.org>; Thu,  8 Jul 2021 14:16:15 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id f17so6732497pfj.8
        for <kvm@vger.kernel.org>; Thu, 08 Jul 2021 14:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=U+3KChXg3CSJ+Kb2l57Z/XocGhGhrNj002rPNMqu6LA=;
        b=tA5mLH64Nl6cIokOeagx93nASkriOieK4ZXfjTlkyymAsv5G5JqjLX4gqSoLy3NEvJ
         LChpJ3ebUWGgL9S3BAb0DMP22OdekOZvpxm+MMeCtsulYkA81uIstaUbB3M8Q6BWPndJ
         +Nkkwm/G+XxwZwQXs8L5QKb19HFzS4tuyZdNjnxHz6V34Dsth146w0JcKHsPnvKhTQgd
         Jhu2EDjYdK8vIGSuSpOtDYhYA/i81p6GTZ78croqA0E7PoSI/lrSj0YhPdaJZt7HLcEX
         wHZBKaFdG/D6h+Szev6bgZqFDqPzPJSICxXTxihZtdtv3SNgX0SbYsftJDbWUUom1mj1
         ElFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U+3KChXg3CSJ+Kb2l57Z/XocGhGhrNj002rPNMqu6LA=;
        b=goc1RPgIaVErAjfN+GALfOqIfA3lru3MmCOr4NGf7Hh60FdQVoLP5T3VsJB4aY4d1j
         arinmGzjMSvNOacLGjFwGL8wnCSOh8EGkNJE6XtnDSNFJVPj43O0zLvfPIR4eZZ90eM3
         sHZHwp9yQsN3gaztSMatAxd4htfCKyhsGwgyYAIWZ2Yaty63ZWSGHYOMIPszlDVtXppL
         F79opWfnTRQkZwBVq+61nfGDBtMrRvRab5XhmeuZbf+uGjBRrnUzk72Kq/Outpq2TelC
         X3m2qGYSE363KMUYYJSCOkCShdW/+txm2FIGDwOBhQLgyO3JkMgrim7/FUa/5ZfO6/Pa
         mquQ==
X-Gm-Message-State: AOAM530N/J6G8JtoXTU19r96RethXKmq2k50hbQaBwtjeUJbnRIq3rkL
        MZgtw08Nhl+aBcZaz54lAZiVwg==
X-Google-Smtp-Source: ABdhPJzIrihXgUJlsTN076+hWDLvEs59vpPqaTUpBolEnjpfwUWoosO0qwvlmTaIh9J9Qn7RJZAT4Q==
X-Received: by 2002:a63:5223:: with SMTP id g35mr22065453pgb.45.1625778974883;
        Thu, 08 Jul 2021 14:16:14 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id b65sm3674345pfa.32.2021.07.08.14.16.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 14:16:13 -0700 (PDT)
Date:   Thu, 8 Jul 2021 21:16:10 +0000
From:   David Matlack <dmatlack@google.com>
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v1 2/4] KVM: stats: Update doc for histogram statistics
Message-ID: <YOdrGg47GnvyEDPF@google.com>
References: <20210706180350.2838127-1-jingzhangos@google.com>
 <20210706180350.2838127-3-jingzhangos@google.com>
 <YOdqvvmE2ly6o9Fa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOdqvvmE2ly6o9Fa@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 08, 2021 at 09:14:38PM +0000, David Matlack wrote:
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
> >  	#define KVM_STATS_TYPE_CUMULATIVE	(0x0 << KVM_STATS_TYPE_SHIFT)
> >  	#define KVM_STATS_TYPE_INSTANT		(0x1 << KVM_STATS_TYPE_SHIFT)
> >  	#define KVM_STATS_TYPE_PEAK		(0x2 << KVM_STATS_TYPE_SHIFT)
> > +	#define KVM_STATS_TYPE_LINEAR_HIST	(0x3 << KVM_STATS_TYPE_SHIFT)
> > +	#define KVM_STATS_TYPE_LOG_HIST		(0x4 << KVM_STATS_TYPE_SHIFT)
> > +	#define KVM_STATS_TYPE_MAX		KVM_STATS_TYPE_LOG_HIST
> >  
> >  	#define KVM_STATS_UNIT_SHIFT		4
> >  	#define KVM_STATS_UNIT_MASK		(0xF << KVM_STATS_UNIT_SHIFT)
> > @@ -5178,11 +5181,13 @@ by a string of size ``name_size``.
> >  	#define KVM_STATS_UNIT_BYTES		(0x1 << KVM_STATS_UNIT_SHIFT)
> >  	#define KVM_STATS_UNIT_SECONDS		(0x2 << KVM_STATS_UNIT_SHIFT)
> >  	#define KVM_STATS_UNIT_CYCLES		(0x3 << KVM_STATS_UNIT_SHIFT)
> > +	#define KVM_STATS_UNIT_MAX		KVM_STATS_UNIT_CYCLES
> >  
> >  	#define KVM_STATS_BASE_SHIFT		8
> >  	#define KVM_STATS_BASE_MASK		(0xF << KVM_STATS_BASE_SHIFT)
> >  	#define KVM_STATS_BASE_POW10		(0x0 << KVM_STATS_BASE_SHIFT)
> >  	#define KVM_STATS_BASE_POW2		(0x1 << KVM_STATS_BASE_SHIFT)
> > +	#define KVM_STATS_BASE_MAX		KVM_STATS_BASE_POW2
> 
> Should these FOO_MAX additions go in a separate commit too?
> 
> >  
> >  	struct kvm_stats_desc {
> >  		__u32 flags;
> > @@ -5214,6 +5219,22 @@ Bits 0-3 of ``flags`` encode the type:
> >      represents a peak value for a measurement, for example the maximum number
> >      of items in a hash table bucket, the longest time waited and so on.
> >      The corresponding ``size`` field for this type is always 1.
> > +  * ``KVM_STATS_TYPE_LINEAR_HIST``
> > +    The statistics data is in the form of linear histogram. The number of
> > +    buckets is specified by the ``size`` field. The size of buckets is specified
> > +    by the ``hist_param`` field. The range of the Nth bucket (1 <= N < ``size``)
> 
> Using 1-based indexes is a little jarring but maybe that's just me :).
> 
> > +    is [``hist_param``*(N-1), ``hist_param``*N), while the range of the last
> > +    bucket is [``hist_param``*(``size``-1), +INF). (+INF means positive infinity
> > +    value.) The bucket value indicates how many times the statistics data is in
> > +    the bucket's range.
> > +  * ``KVM_STATS_TYPE_LOG_HIST``
> > +    The statistics data is in the form of logarithmic histogram. The number of
> > +    buckets is specified by the ``size`` field. The base of logarithm is
> > +    specified by the ``hist_param`` field. The range of the Nth bucket (1 < N <
> 
> Should 1 be 2 here? The first bucket uses a slightly differen formula as
> you mention in the next sentence.

Oops I see you used "<" instead of "<=" so what you have is correct. I
think reordering the sentences would still be helpfull though.

> 
> Actually it may be clearer if you re-ordered the sentences a bit:
> 
>   The range of the first bucket is [0, 1), while the range of the last
>   bucket is [pow(hist_param, size-1), +INF). Otherwise the Nth bucket
>   (1-indexed) covers [pow(hist_param, N-2), pow(histparam, N-1)).
> 
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
> 
> s/fo/for/
> 
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
> > -- 
> > 2.32.0.93.g670b81a890-goog
> > 
