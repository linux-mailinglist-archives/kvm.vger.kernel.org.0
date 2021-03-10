Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB4533387D
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 10:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbhCJJPo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 04:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbhCJJPc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 04:15:32 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2232DC06174A;
        Wed, 10 Mar 2021 01:15:32 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id bm21so37182209ejb.4;
        Wed, 10 Mar 2021 01:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h4zBemXq8V6/AVM5Gm1CAbSuTQBM3iIefLQNaul1B2Q=;
        b=Jqz4gUnE05MsaD3zwKJpbufnV9qNjkW/U/dRxpVxrhFa6eelmaI30jwCwbKr5qafuQ
         u2OAtAObw1pqroeIfi+00Km0u6t4zHML4FTTWWBLtEQ/e2+EsF6aYeFMNeEX1Wgsf/+s
         PXxa4bEBkGtz//chJ1fwm0rck5YXviTjVFKn8fOs5GCSagWdACDXGl0nKb+1upPlUTRX
         n4eMtlW/th63PeMaiW93sNBTKeXuEet+45siKUQoYl7FSAhRET/NYmThrEUJtahhfYxR
         I7lXEd8dUPgyW2PyIOQnBARYnjZUMBxCkQE+fwM/gvsc6/exatjkgP+TwE7H8GStV8hd
         A+QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h4zBemXq8V6/AVM5Gm1CAbSuTQBM3iIefLQNaul1B2Q=;
        b=flLTBKUhPphTxfDmrm4o8mxJ7MzsdWRq54JcN1ixYlOb3G2AAFNl876aTXNFBTdFmL
         nvS4OEFQg7BUPSvMLYm9c07VBcSiHqYzj+/1RSpO33MkQs63x257s8sI/XBOcFm56oey
         a0DUJZd7P/OsAulHd7l4TF4mD4n0fqsDf4C1KSNARWCxjMt+cPZZgNpArV37FVecjEun
         /Xl41xhVZrd+Z/toyobFxeyGLdX+VnskYAtAR6/uNvuDX1lrjBktz0v9QtF3bRu/JIS2
         uDSjAHEae6VMmOh0eEehTsnUw7k+4tkD/KnJbVu6IYwQTi1Se0RlG2uBfg9uAbwTHI3E
         duEg==
X-Gm-Message-State: AOAM533Bipp4xq/CmW0Xnikpyx2mwNdpmtBrMIWfPZiaoCBKai8tBFaE
        XnGRixzXoxv8Lb+07cmbQ3aBv0/B97jpbQdqNQ==
X-Google-Smtp-Source: ABdhPJyvyL496vu1nUaY2xMu+CkLv+zpNH1ISwEGWCABWap9ED/IB6hi7BEpdXBTEQcHDGWff4LSZYvjJT1u+ngJmxQ=
X-Received: by 2002:a17:906:f210:: with SMTP id gt16mr2576308ejb.206.1615367730887;
 Wed, 10 Mar 2021 01:15:30 -0800 (PST)
MIME-Version: 1.0
References: <20210303020946.26083-1-lihaiwei.kernel@gmail.com>
 <03239d81-df56-a6c9-c79d-c14d22f62705@gmail.com> <YEgH11nNwdCkF5kT@google.com>
In-Reply-To: <YEgH11nNwdCkF5kT@google.com>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Date:   Wed, 10 Mar 2021 17:15:08 +0800
Message-ID: <CAB5KdOZkdXsLup+58On=LZ6eG4jYdcaK2NCt9U0Q-qy_6dQrfw@mail.gmail.com>
Subject: Re: [PATCH] kvm: lapic: add module parameters for LAPIC_TIMER_ADVANCE_ADJUST_MAX/MIN
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 10, 2021 at 7:42 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Mar 03, 2021, Haiwei Li wrote:
> > On 21/3/3 10:09, lihaiwei.kernel@gmail.com wrote:
> > > From: Haiwei Li <lihaiwei@tencent.com>
> > >
> > > In my test environment, advance_expire_delta is frequently greater than
> > > the fixed LAPIC_TIMER_ADVANCE_ADJUST_MAX. And this will hinder the
> > > adjustment.
> >
> > Supplementary details:
> >
> > I have tried to backport timer related features to our production
> > kernel.
> >
> > After completed, i found that advance_expire_delta is frequently greater
> > than the fixed value. It's necessary to trun the fixed to dynamically
> > values.
>
> Does this reproduce on an upstream kernel?  If so...
>
>   1. How much over the 10k cycle limit is the delta?
>   2. Any idea what causes the large delta?  E.g. is there something that can
>      and/or should be fixed elsewhere?
>   3. Is it platform/CPU specific?

Hi, Sean

I have traced the flow on our production kernel and it frequently consumes more
than 10K cycles from sched_out to sched_in.
So two scenarios tested on Cascade lake Server(96 pcpu), v5.11 kernel.

1. only cyclictest in guest(88 vcpu and bound with isolated pcpus, w/o mwait
exposed, adaptive advance lapic timer is default -1). The ratio of occurrences:

greater_than_10k/total: 29/2060, 1.41%

2. cyclictest in guest(88 vcpu and not bound, w/o mwait exposed, adaptive
advance lapic timer is default -1) and stress in host(no isolate). The ratio of
occurrences:

greater_than_10k/total: 122381/1017363, 12.03%

-- 
Haiwei Li

>
> Ideally, KVM would play nice with "all" environments by default without forcing
> the admin to hand-tune things.
