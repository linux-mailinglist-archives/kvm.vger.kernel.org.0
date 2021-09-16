Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8B640D501
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 10:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235367AbhIPIux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 04:50:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52922 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235339AbhIPIuw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Sep 2021 04:50:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631782171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1d4A45p0VDtSfTvTL93pZr7ns5btz2A1j/Q0yOKhflU=;
        b=fpe3IXh+ykA9LG8thZ3xwl9igWlKViafwScWV0IIAogcI1QHfr4IJNc6k5dZjN5CyZogf9
        qtgUJpImEDSf7QRXjYuA4lqLN8CL2aVKbAyC/s5MgzrbUUxUl+0psY+7WJ3kNPmVAlswNa
        asNd30HmZ9bG2XaIDu0OZBgR8llIMvE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-M4eiyjlmOKSSzRdJceO6nA-1; Thu, 16 Sep 2021 04:49:30 -0400
X-MC-Unique: M4eiyjlmOKSSzRdJceO6nA-1
Received: by mail-ed1-f72.google.com with SMTP id s15-20020a056402520f00b003cad788f1f6so4608705edd.22
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 01:49:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1d4A45p0VDtSfTvTL93pZr7ns5btz2A1j/Q0yOKhflU=;
        b=vp17Q5a+6B4x2DsrgnW3be/Uwkx0rEYO9nSqKMYgwIKcRFAghKgrauYkhO36j6QMGg
         l5d/bQVJtoXGB/KI4cCksdMbibJmUioQKBTwLnQc8TybcYnb9clygx120bZSI1i+1Hh8
         OQC6ulR97Y+ZnOBo5LrvN7IMzoQ8njBHpfNJGlaNP+NIJp/fLwP6Dm2frnYt1KHKGE0J
         PPn0JRh+MMuqQYUkEuQ/dPjPLrJp2SO3WQxXFWD+Uoq73NSjmxY7QR57mLwL2DljEujQ
         TGp3uoEeFlvcpRHHpYPJ1y6BgLLffgqE/S9f5CmxbuZlRwUuZ4uH87PG9m5rIKCUwgy1
         AJsA==
X-Gm-Message-State: AOAM5320K8DtxGRrygb0tr4G8oCr269dJZgzgu5Xg6QTBI+KLoiQHvUF
        SxvupvneVeRID6qnXWDIdol9ImY7AdSmHQVAc0rEP7azKwHqZkYE7uVrlXRQ1cweD5dtAWCQncI
        kZfuJGc3InVUx
X-Received: by 2002:a17:906:1e0c:: with SMTP id g12mr5170094ejj.155.1631782169189;
        Thu, 16 Sep 2021 01:49:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzvOAxAgH4kKa59Fqc07mYEOExj1wobhgkCngCCw8KddnqJDEB/Cwxu7qA9cKOhVlA0V8nBFg==
X-Received: by 2002:a17:906:1e0c:: with SMTP id g12mr5170077ejj.155.1631782169008;
        Thu, 16 Sep 2021 01:49:29 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id q6sm931814eju.45.2021.09.16.01.49.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 01:49:28 -0700 (PDT)
Date:   Thu, 16 Sep 2021 10:49:22 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yanan Wang <wangyanan55@huawei.com>
Subject: Re: [PATCH 3/3] KVM: selftests: Fix dirty bitmap offset calculation
Message-ID: <20210916084922.x33twpy74auxojrk@gator.home>
References: <20210915213034.1613552-1-dmatlack@google.com>
 <20210915213034.1613552-4-dmatlack@google.com>
 <CANgfPd_WkrdXJ3qYmv_DKLbKDsNs8KJK4i9sX3+kR_cwNmbJ_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd_WkrdXJ3qYmv_DKLbKDsNs8KJK4i9sX3+kR_cwNmbJ_w@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 15, 2021 at 02:55:03PM -0700, Ben Gardon wrote:
> On Wed, Sep 15, 2021 at 2:30 PM David Matlack <dmatlack@google.com> wrote:
> >
> > The calculation to get the per-slot dirty bitmap was incorrect leading
> > to a buffer overrun. Fix it by dividing the number of pages by
> > BITS_PER_LONG, since each element of the bitmap is a long and there is
> > one bit per page.
> >
> > Fixes: 609e6202ea5f ("KVM: selftests: Support multiple slots in dirty_log_perf_test")
> > Signed-off-by: David Matlack <dmatlack@google.com>
> 
> I was a little confused initially because we're allocating only one
> dirty bitmap in userspace even when we have multiple slots, but that's
> not a problem.

It's also confusing to me. Wouldn't it be better to create a bitmap per
slot? I think the new constraint that host mem must be a multiple of 64
is unfortunate.

Thanks,
drew

