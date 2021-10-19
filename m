Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B9A43405B
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 23:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbhJSVUK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 17:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhJSVUJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 17:20:09 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008ADC06161C
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 14:17:55 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 75so20577126pga.3
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 14:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Oc0/+tVwK7K9nmz3ZCCVI0OnaV+/2goNVxH4SiWbdQY=;
        b=n/KgdwdBsIwUUylWrPRFshJHpCoQZrnOOHfYOc5/rMLQ8wuZKohdWeupQF1jMimzvb
         AIDP/6JoNxEWdsFJeXJQ9n1E/nR84Bvb4GS9Ron8aQSE5SlChfI/McpudJFpBiEAiq7u
         c0LTUpn88XqeZZR68Twh6qRkL90+VSMsQVD5a6UonW4RyfY/ps6p3bnnZc2jPb+i4xsZ
         +b6aOS+mevs/Ziu1ZT6F6eC/NCRz8ClKtNcfTJZcLh539e9ABJEpFtCnyvQO7g8/BfN5
         10QS+xNtPDeW5t5ZzyTWZDyR2BFDpnVn8/cMWxvdpCg8cfiiifFozI6/vPMmy+/4t1Os
         mfvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Oc0/+tVwK7K9nmz3ZCCVI0OnaV+/2goNVxH4SiWbdQY=;
        b=hgbrTD1fE+v3A5rX17DO8Vc9gHeFtKUlm1zoRPOipGj7pGjh3y9xH/tRzS9JpOjN6N
         eC8JKqG4ukfe9Mf6U8ZfvdGeKM3IcBM0e1rlXs/sPM6wiD1j7id/L/GC3qJSlhGuFCbo
         Juc/rfDXlaYzEqO8ZDWqT3FqpLxXplbGFE2lh4sZOiTQgaiGA2PKAv4gsEVjLcO5hJKx
         C0LCExAXXc9Xs400GSOCjmfJjsc0aRHbewH8cNzEOAfy6CTFuHNVzopTUpz24/RzbX9F
         4U2XReMena86eZh+TpzExOgmN7Noe02I/QPeSLWLKbpKtgMowfUVJShox+SVEQjn3Jk3
         /VCw==
X-Gm-Message-State: AOAM5335bA7iY6mwxSAD0wmnuaMTShCWa0Hlam6O9UKx89GJTJcv0j1R
        5cMyDHfAZCXN8nHjpceyJaky/g==
X-Google-Smtp-Source: ABdhPJx97+XMR9DaIQZAIqX4jy+cJjWfmQD3Dd0awGykaOoZQzlV7bhMqYiRM0qW49c0pxK2/TRSlQ==
X-Received: by 2002:a05:6a00:2311:b0:431:c19f:2a93 with SMTP id h17-20020a056a00231100b00431c19f2a93mr2263470pfh.11.1634678275358;
        Tue, 19 Oct 2021 14:17:55 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id nv5sm95571pjb.10.2021.10.19.14.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 14:17:54 -0700 (PDT)
Date:   Tue, 19 Oct 2021 14:17:51 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        maciej.szmigiero@oracle.com, maz@kernel.org, oupton@google.com,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Subject: Re: [PATCH v2 0/2] KVM: selftests: enable the memslot tests in ARM64
Message-ID: <YW81/4/DiAgELq09@google.com>
References: <20210907180957.609966-1-ricarkol@google.com>
 <20210907181737.jrg35l3d342zgikt@gator.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210907181737.jrg35l3d342zgikt@gator.home>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 07, 2021 at 08:17:37PM +0200, Andrew Jones wrote:
> On Tue, Sep 07, 2021 at 11:09:55AM -0700, Ricardo Koller wrote:
> > Enable memslot_modification_stress_test and memslot_perf_test in ARM64
> > (second patch). memslot_modification_stress_test builds and runs in
> > aarch64 without any modification. memslot_perf_test needs some nits
> > regarding ucalls (first patch).
> > 
> > Can anybody try these two tests in s390, please?
> > 
> > Changes:
> > v2: Makefile tests in the right order (from Andrew).
> 
> Hi Ricardo,
> 
> You could have collected all the r-b's too.
> 
> Thanks,
> drew
> 

Friendly ping on this one, please.

> > 
> > Ricardo Koller (2):
> >   KVM: selftests: make memslot_perf_test arch independent
> >   KVM: selftests: build the memslot tests for arm64
> > 
> >  tools/testing/selftests/kvm/Makefile          |  2 +
> >  .../testing/selftests/kvm/memslot_perf_test.c | 56 +++++++++++--------
> >  2 files changed, 36 insertions(+), 22 deletions(-)
> > 
> > -- 
> > 2.33.0.153.gba50c8fa24-goog
> > 
> 
