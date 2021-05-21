Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89DCA38C1AF
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 10:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbhEUIYg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 04:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbhEUIYf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 04:24:35 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F8CC061574
        for <kvm@vger.kernel.org>; Fri, 21 May 2021 01:23:11 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id x19so28503560lfa.2
        for <kvm@vger.kernel.org>; Fri, 21 May 2021 01:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E5BzorGsri5488PSjL1siEN5kekGXz/1aX5aJvAEN+U=;
        b=IWXIQBLEb9e1Sj1s4dOXalSrJzpAasLAI9bAOkcpIwhDghJ15i/kr/gBcVltz4gu5J
         1ANJo35KfXx9ZMDE8ZsR6wAey3dTTxWABR5Pd0TUf+1BzP3wvWlfWO3eTqUm8HKoKZtX
         p9AJQA9jjU882lGpte7NucfRmybEtPLgN3JA1yl/KdcEdweILCjKgwBIPRPykveDcahH
         uCZhYQsfOuyXkbEW4ehMSybVjCWfVqNQyUs1CiYtlhOBijatgBrM6GPwAaFnZq4oclVS
         EfLqfr32VgUxSZhTJ5oaj+Wzhf2CLDe2ZTZoRANj9611fRKMcGbG9rOq1rDBM8UXEmLF
         3mSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E5BzorGsri5488PSjL1siEN5kekGXz/1aX5aJvAEN+U=;
        b=Hz/ghLx7Z+TN7vbPTjmkJzXcxHNxvICd+9nCz11VIhZ1pr21a3FnP182SkHolXG8Py
         nGjDRorLwhvIkSGA3wkaaxLhA7Y1/6KV1ze+zagRb+PEcY6WQITsnPNDt2G8BKd/i0ZR
         I86OoEEkzTQiBjsusgM+y0U5VZWmdijTY8LfVC+1tlaZOI+/WmTLhAwsk7qAfSMd6uiU
         Ccx7a+JcQS4PCORtzaN7RX+0kN/Ijy0P9jCpYoL/owNhNNxVamJiJXPon6fZc50rYqjV
         D/+cNTqrENWk4q6PNhVCWmtIERFJq0KNLjHbz+qCimIbFKublAgHLnyERFgUD/1ruSlr
         woSA==
X-Gm-Message-State: AOAM5315J6wVDWZxyGxy6Vmm/LxKeqXdkeIB3s9IWzZh57yKPUigH8jR
        0/oSEV54h1w2CEFgOqLw+czI22fJxJAU3OUuUVeIaIca+WcaXA==
X-Google-Smtp-Source: ABdhPJyS44Ti1OVEFySlaupWDk5WVhczzgVIgAOAkvsOoTOPdg5CVNd5Td6i2iiVTizwX9DTqg19oDU0p4RawDY6qyI=
X-Received: by 2002:a05:6512:2398:: with SMTP id c24mr1420928lfv.638.1621585390193;
 Fri, 21 May 2021 01:23:10 -0700 (PDT)
MIME-Version: 1.0
References: <CA+2MQi-_06J1cmLhKAmV1vkPEnvDx6+bOnK06OciYmdymaNruw@mail.gmail.com>
 <87cztmkdlp.fsf@vitty.brq.redhat.com>
In-Reply-To: <87cztmkdlp.fsf@vitty.brq.redhat.com>
From:   Liang Li <liliang324@gmail.com>
Date:   Fri, 21 May 2021 16:22:58 +0800
Message-ID: <CA+2MQi_LG57KRRFjMR_zPvJBDaH4z16S5J=c+U+-Ss_Z71Ax7g@mail.gmail.com>
Subject: Re: About the performance of hyper-v
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Tianyu.Lan@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > Hi Vitaly,
> >
> > I found a case that the virtualization overhead was almost doubled
> > when turning on Hper-v related features compared to that without any
> > no hyper-v feature.  It happens when running a 3D game in windows
> > guest in qemu kvm environment.
> >
> > By investigation, I found there are a lot of IPIs triggered by guest,
> > when turning on the hyer-v related features including stimer, for the
> > apicv is turned off, at least two vm exits are needed for processing a
> > single IPI.
> >
> >
> > perf stat will show something like below [recorded for 5 seconds]
> >
> > ---------
> >
> > Analyze events for all VMs, all VCPUs:
> >              VM-EXIT    Samples  Samples%     Time%    Min Time    Max
> > Time         Avg time
> >   EXTERNAL_INTERRUPT     471831    59.89%    68.58%      0.64us
> > 65.42us      2.34us ( +-   0.11% )
> >            MSR_WRITE     238932    30.33%    23.07%      0.48us
> > 41.05us      1.56us ( +-   0.14% )
> >
> > Total Samples:787803, Total events handled time:1611193.84us.
> >
> > I tried turning off hyper-v for the same workload and repeat the test,
> > the overall virtualization overhead reduced by about of 50%:
> >
> > -------
> >
> > Analyze events for all VMs, all VCPUs:
> >
> >              VM-EXIT    Samples  Samples%     Time%    Min Time    Max
> > Time         Avg time
> >           APIC_WRITE     255152    74.43%    50.72%      0.49us
> > 50.01us      1.42us ( +-   0.14% )
> >        EPT_MISCONFIG      39967    11.66%    40.58%      1.55us
> > 686.05us      7.27us ( +-   0.43% )
> >            DR_ACCESS      35003    10.21%     4.64%      0.32us
> > 40.03us      0.95us ( +-   0.32% )
> >   EXTERNAL_INTERRUPT       6622     1.93%     2.08%      0.70us
> > 57.38us      2.25us ( +-   1.42% )
> >
> > Total Samples:342788, Total events handled time:715695.62us.
> >
> > For this scenario,  hyper-v works really bad.  stimer works better
> > than hpet, but on the other hand, it relies on SynIC which has
> > negative effects for IPI intensive workloads.
> > Do you have any plans for improvement?
> >
>
> Hey,
>
> the above can be caused by the fact that when 'hv-synic' is enabled, KVM
> automatically disables APICv and this can explain the overhead and the
> fact that you're seeing more vmexits. KVM disables APICv because SynIC's
> 'AutoEOI' feature is incompatible with it. We can, however, tell Windows
> to not use AutoEOI ('Recommend deprecating AutoEOI' bit) and only
> inhibit APICv if the recommendation was ignored. This is implemented in
> the following KVM patch series:
> https://lore.kernel.org/kvm/20210518144339.1987982-1-vkuznets@redhat.com/
>
> It will, however, require a new 'hv-something' flag to QEMU. For now, it
> can be tested with 'hv-passthrough'.
>
> It would be great if you could give it a spin!
>
> --
> Vitaly

It's great to know that you already have a solution for this. :)

By the way,  is there any requirement for the version of windows or
windows updates for the new feature to work?

Thanks!

Liang
