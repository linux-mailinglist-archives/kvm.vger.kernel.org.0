Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547F638DF55
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 04:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbhEXCm5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 May 2021 22:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbhEXCm4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 May 2021 22:42:56 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7D1C061574
        for <kvm@vger.kernel.org>; Sun, 23 May 2021 19:41:27 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id w7so18197895lji.6
        for <kvm@vger.kernel.org>; Sun, 23 May 2021 19:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SAGlgSwI8WoAGaFB9ifJOZ0SKmW5nQmqDXowAqZIXLI=;
        b=hMgmL9jKWQjehh2xcg4RipQ2nzjr0cukwUmetmmS0FC8RUnyi3BxusAzQfw2Cv3Hp1
         xPDaR3sQfaA3AMTbFUv0rM6GJfYJ2bgGOZKIhgS8vcxsR7jJFOxcMsC3PVoOE4qum2e6
         l1I/l41W5TzPqM/IcM5WWw7QcuuImP2TZ7wnjC07OszrKjIfoLaJErwr9rNJYzQlm0yt
         zFyEt7i/3msuiMv+D5AQySuvLHLbOKny/h+z0mmprWrv3CABNf6/KfwV2Rf6W7/swqKu
         8XaPg3+zWctOM8dEsp9yzEOTiZmgi5WpDO7wxuOQHvuKdrM6I+CKT8t0M3dvmwVn7geX
         3h+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SAGlgSwI8WoAGaFB9ifJOZ0SKmW5nQmqDXowAqZIXLI=;
        b=aR/1eNHhXZLw0dUlsf0t35ox5QX2fYrSwcdRFUEW53e5pjr3uy5xhpNyZwZg20c4BR
         fR23f4VRZXAtDPDFbe3JNX71WYUr1AOCuPIj2S/CZAqNlP0QAwPbKAH+B4ha+Y3oqKF+
         vYj97MYEzzh3x1HJxlkKAIDuFVTYxO5XDdJHzTNBSnz9BJcnLUlQOjqUT+5Y76i7w2xn
         JrfZeJl0ZVgYLSPT4NwBUEN/u9SkLoIylo6iM9qGEqgdSu3GfoKMv/oQiBLLB7gYXftv
         8K/D7revotDy5dO/xf9YpDzBXce2NKSZ5DvGSwgAapMnA0PaGibk4E958zWE74XbLqFl
         aHLQ==
X-Gm-Message-State: AOAM532QG40kLR8mtMtJvT+rrvcqNcIVyN1xlrbQkQZFcZ1q13wk8tM8
        +/FFx6J7ArNCLh2XgUYHOhwgjgkgv4DjX2tImJbmPl7XaAgMyQ==
X-Google-Smtp-Source: ABdhPJxRlaX6quvwawv5wktJiGVDfx5hDZdsc4PmiplDL857LCkzBcc1XhHQq33uu6hokn8Ep3+cmCZPmt08V6390KU=
X-Received: by 2002:a05:651c:329:: with SMTP id b9mr15404724ljp.128.1621824086130;
 Sun, 23 May 2021 19:41:26 -0700 (PDT)
MIME-Version: 1.0
References: <CA+2MQi-_06J1cmLhKAmV1vkPEnvDx6+bOnK06OciYmdymaNruw@mail.gmail.com>
 <87cztmkdlp.fsf@vitty.brq.redhat.com> <CA+2MQi_LG57KRRFjMR_zPvJBDaH4z16S5J=c+U+-Ss_Z71Ax7g@mail.gmail.com>
 <87y2c8iia0.fsf@vitty.brq.redhat.com>
In-Reply-To: <87y2c8iia0.fsf@vitty.brq.redhat.com>
From:   Liang Li <liliang324@gmail.com>
Date:   Mon, 24 May 2021 10:41:14 +0800
Message-ID: <CA+2MQi-OK5zK_sBtm8k-nnqVPQTSzE1UVTEfQ4KBChMHc=Npzg@mail.gmail.com>
Subject: Re: About the performance of hyper-v
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Tianyu.Lan@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> >> > Analyze events for all VMs, all VCPUs:
> >> >              VM-EXIT    Samples  Samples%     Time%    Min Time    Max
> >> > Time         Avg time
> >> >   EXTERNAL_INTERRUPT     471831    59.89%    68.58%      0.64us
> >> > 65.42us      2.34us ( +-   0.11% )
> >> >            MSR_WRITE     238932    30.33%    23.07%      0.48us
> >> > 41.05us      1.56us ( +-   0.14% )
> >> >
> >> > Total Samples:787803, Total events handled time:1611193.84us.
> >> >
> >> > I tried turning off hyper-v for the same workload and repeat the test,
> >> > the overall virtualization overhead reduced by about of 50%:
> >> >
> >> > -------
> >> >
> >> > Analyze events for all VMs, all VCPUs:
> >> >
> >> >              VM-EXIT    Samples  Samples%     Time%    Min Time    Max
> >> > Time         Avg time
> >> >           APIC_WRITE     255152    74.43%    50.72%      0.49us
> >> > 50.01us      1.42us ( +-   0.14% )
> >> >        EPT_MISCONFIG      39967    11.66%    40.58%      1.55us
> >> > 686.05us      7.27us ( +-   0.43% )
> >> >            DR_ACCESS      35003    10.21%     4.64%      0.32us
> >> > 40.03us      0.95us ( +-   0.32% )
> >> >   EXTERNAL_INTERRUPT       6622     1.93%     2.08%      0.70us
> >> > 57.38us      2.25us ( +-   1.42% )
> >> >
> >> > Total Samples:342788, Total events handled time:715695.62us.
> >> >
> >> > For this scenario,  hyper-v works really bad.  stimer works better
> >> > than hpet, but on the other hand, it relies on SynIC which has
> >> > negative effects for IPI intensive workloads.
> >> > Do you have any plans for improvement?
> >> >
> >>
> >> Hey,
> >>
> >> the above can be caused by the fact that when 'hv-synic' is enabled, KVM
> >> automatically disables APICv and this can explain the overhead and the
> >> fact that you're seeing more vmexits. KVM disables APICv because SynIC's
> >> 'AutoEOI' feature is incompatible with it. We can, however, tell Windows
> >> to not use AutoEOI ('Recommend deprecating AutoEOI' bit) and only
> >> inhibit APICv if the recommendation was ignored. This is implemented in
> >> the following KVM patch series:
> >> https://lore.kernel.org/kvm/20210518144339.1987982-1-vkuznets@redhat.com/
> >>
> >> It will, however, require a new 'hv-something' flag to QEMU. For now, it
> >> can be tested with 'hv-passthrough'.
> >>
> >> It would be great if you could give it a spin!
> >>
> >> --
> >> Vitaly
> >
> > It's great to know that you already have a solution for this. :)
> >
> > By the way,  is there any requirement for the version of windows or
> > windows updates for the new feature to work?
>
> AFAIR, 'Recommend deprecating AutoEOI' bit appeared in WS2012 so I'd
> expect WS2008 to ignore it completely (and thus SynIC will always be
> disabling APICv for it).
>

Hi Vitaly,
      I tried your patchset and found it's not helpful to reduce the
virtualization overhead.
here are some perfdata with the same workload

===============================
Analyze events for all VMs, all VCPUs:
             VM-EXIT    Samples  Samples%     Time%    Min Time    Max
Time         Avg time
           MSR_WRITE     924045    89.96%    81.10%      0.42us
68.42us      1.26us ( +-   0.07% )
           DR_ACCESS      44669     4.35%     2.36%      0.32us
50.74us      0.76us ( +-   0.32% )
  EXTERNAL_INTERRUPT      29809     2.90%     6.42%      0.66us
70.75us      3.10us ( +-   0.54% )
              VMCALL      17819     1.73%     5.21%      0.75us
15.64us      4.20us ( +-   0.33%

Total Samples:1027227, Total events handled time:1436343.94us.
===============================

The result shows the overhead increased.  enable the apicv can help to
reduce the vm-exit
caused by interrupt injection, but on the other side, there are a lot
of vm-exit caused by APIC_EOI.

When turning off the hyper-v and using the kvm apicv, there is no such
overhead. It seems turning
on hyper V related features is not always the best choice for a windows guest.

Thanks!
Liang
