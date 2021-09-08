Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55DC0403D4C
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 18:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346386AbhIHQIc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 12:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344503AbhIHQI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 12:08:29 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6686CC061575
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 09:07:21 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id c6so5266365ybm.10
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 09:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OlLwloMM1UNziGhSZ73I5whfEToHkI4ZvWhuIcM5G8s=;
        b=j5bGc2IirxaeHkq6J05nylDjOjhI8/WNnNCH218C+ljUcd3BGM6/pCCcKr7PlgQ9rX
         mqW/bc2JL6DSp2FiVstvuKUqj+sxSdPA6D3jxap2gRz/Av8srgQrIVRHdc/QBVyOAMzT
         gnjJFbXHDV1N79Vn4zAP+N9TEfUfDMpKdghWSrb3hKHoDqu8urjueLFJAX/2B0xLei0H
         kKvHUpnCdwec4gbQbL2VsN9H/6tmlUj7M6kQfhy4Cf2xb7nJqKGB0kLL59QoxiBmxHTO
         OsVNa+PcYwqBB1wJS9AUKqqv4GEtDXYhPdINQVZ6iU3jI863GfKQsA/GQcKcEoCtxCwm
         AcSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OlLwloMM1UNziGhSZ73I5whfEToHkI4ZvWhuIcM5G8s=;
        b=XL9T3J6+H8bohGBEGSeo5frgiPPvBm3enGp+2gmG3Qq4s1TuaP1+h89MTFS4cSE8XQ
         qG84B44PSZoWvLv+ZfmkwRLU6HOu/cF7B2VUNMIF3o8rDfz5TzZM03q7dyCSdi4ML/9v
         azLbc/bEY4kQRQCvsRW+Y6XaWZBM9BXGSdLyAp65vUx8lblw3QAtD4rkXHix9xYCXu6F
         o2W+jA84t0G+mAymXMIvXNW9azWhlfmbfU1WpM/F6OE/edk8V1Ip7gXE7vZNnMRFzRPL
         gbx6mkHM0Ort8LgSv6wsgwziI5GTFbiMFaQJ3y25JL7ufeXle5wfLHY5yCbFkIieL0UG
         udvg==
X-Gm-Message-State: AOAM532PxFcP7VoFt+lL6Y8w6RjYhP0iAyel3c1LE12A8WJ2WHPa9Ki4
        7iC+nSHcMYiIHI9Tf3Yg6rsIDMz7n4BWZp/QEVePlw==
X-Google-Smtp-Source: ABdhPJw4+DDt30fQHD5oYPdoChAnKFa73Ue9B3s9aptNmiCY1/fZWxEuLXm7T7yt4bdUe3JR8cBNfjANw4oHXZpOlhA=
X-Received: by 2002:a25:abeb:: with SMTP id v98mr4667226ybi.30.1631117240489;
 Wed, 08 Sep 2021 09:07:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210830044425.2686755-1-mizhang@google.com> <20210830044425.2686755-3-mizhang@google.com>
 <CANgfPd_46=V24r5Qu8cDuOCwVRSEF9RFHuD-1sPpKrBCjWOA2w@mail.gmail.com>
 <YS5fxJtX/nYb43ir@google.com> <CAL715WJUmRJmt=u4Gi3ydTpbTGy2M5Wi=CbF9Qs8GNRK8g5FAA@mail.gmail.com>
In-Reply-To: <CAL715WJUmRJmt=u4Gi3ydTpbTGy2M5Wi=CbF9Qs8GNRK8g5FAA@mail.gmail.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Wed, 8 Sep 2021 09:07:09 -0700
Message-ID: <CAL715WJYqusqiztS=fYE46jXmHUi9uni_kswt=ALyUx_hxKBFg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] selftests: KVM: use dirty logging to check if page
 stats work correctly
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 6, 2021 at 1:05 PM Mingwei Zhang <mizhang@google.com> wrote:
>
> On Tue, Aug 31, 2021 at 9:58 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, Aug 30, 2021, Ben Gardon wrote:
> > > On Sun, Aug 29, 2021 at 9:44 PM Mingwei Zhang <mizhang@google.com> wrote:
> > > > diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
> > > > index af1031fed97f..07eb6b5c125e 100644
> > > > --- a/tools/testing/selftests/kvm/lib/test_util.c
> > > > +++ b/tools/testing/selftests/kvm/lib/test_util.c
> > > > @@ -15,6 +15,13 @@
> > > >  #include "linux/kernel.h"
> > > >
> > > >  #include "test_util.h"
> > > > +#include "processor.h"
> > > > +
> > > > +static const char * const pagestat_filepaths[] = {
> > > > +       "/sys/kernel/debug/kvm/pages_4k",
> > > > +       "/sys/kernel/debug/kvm/pages_2m",
> > > > +       "/sys/kernel/debug/kvm/pages_1g",
> > > > +};
> > >
> > > I think these should only be defined for x86_64 too. Is this the right
> > > file for these definitions or is there an arch specific file they
> > > should go in?
> >
> > The stats also need to be pulled from the selftest's VM, not from the overall KVM
> > stats, otherwise the test will fail if there are any other active VMs on the host,
> > e.g. I like to run to selftests and kvm-unit-tests in parallel.
>
> That is correct. But since this selftest is not the 'default' selftest
> that people normally run, can we make an assumption on running these
> tests at this moment? I am planning to submit this test and improve it
> in the next series by using Jing's fd based KVM stats interface to
> eliminate the assumption of the existence of a single running VM.
> Right now, this interface still needs some work, so I am taking a
> shortcut that directly uses the whole-system metricfs based interface.
>
> But I can choose to do that and submit the fd-based API together with
> this series. What do you suggest?


I will take my point back, since some of the "TEST_ASSERT" in this
selftest does assume that there is no other VM running even on
'default' case (ie., run ./dirty_logging_perf_test without arguments).
Therefore, this patch will make the test flaky.

I will go back to implement the fd based API and submit the code along
with this selftest.

Thanks.
-Mingwei
