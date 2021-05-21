Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E32038C23D
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 10:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbhEUIuX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 04:50:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35738 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230288AbhEUIuX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 May 2021 04:50:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621586940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C+RrPrGVxZisWP0sBdZiifQusgNF1wAFIFuVSD1WN80=;
        b=Xgc1+y5Xkt84wbhy+bMkKjQCsXdL4gPBIKazOWg66tsJJZk3vYkN4cS0oIKF3mpksz4kMH
        gllWeEPhr14Us6at72VWBRSwOaijOTPPnzdBa1xUHK58tsHfw/1cQMcAfbxq8jxNTK8W23
        qIkd+lNpzesR0pYl/Oe01T1usBahLeY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-pCFmskScNqWyAFelhh7pfg-1; Fri, 21 May 2021 04:48:58 -0400
X-MC-Unique: pCFmskScNqWyAFelhh7pfg-1
Received: by mail-wm1-f72.google.com with SMTP id 12-20020a1c010c0000b0290176491efde9so3556441wmb.4
        for <kvm@vger.kernel.org>; Fri, 21 May 2021 01:48:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=C+RrPrGVxZisWP0sBdZiifQusgNF1wAFIFuVSD1WN80=;
        b=uapcLhtcAQRbM0pxX4NAc95m/daLUH8yXI7BP9DPCtWkQqPhtfvK/EDWS44Z8nNZFt
         zegGR/Ssk9YSZ1EwpkhN1IZcgtvuMh+/5157+SPmwiXBmwUmUzAzvf1t08NkuuxQpheI
         cgZVZS13gZG8yOq5fnIuN4ebKMScAA7A3raOwNRVSOoDddTakYQNcNPrUNOLm0ksbrYR
         GtxFgonAEKSv69c8IjLXsTMg5i7BYUjkDjDkKVaO0q2nds5s4hnnbQzuu2JdMbGQnJnG
         CgE59HtxOMlRHSlogof4N0Kvi2/+zVYTpvJq7b6//l1M1Q8/h84OD++IOSkd+i8eAnz1
         BFJg==
X-Gm-Message-State: AOAM533aefiTh56Bokje6pUowRqVN+606/a3HUBj3SnYu+XeYcquoPO7
        Fum80IJ9dFxwXKG5fbRuxzElLOqK3jfvmyKKxdluPFIP0yeWqPSVYOwBzf7R2pSvFIDgb9eRZ6g
        0HsyMqVmtCo/n
X-Received: by 2002:a5d:4a81:: with SMTP id o1mr7955095wrq.177.1621586937343;
        Fri, 21 May 2021 01:48:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwx9FKQyrvOPP7boT1WEW/qQzOKlleOxVcg2ZXiXvfEsG7bp5bbEt8GrCAOXSmuZgRMrpaDzQ==
X-Received: by 2002:a5d:4a81:: with SMTP id o1mr7955083wrq.177.1621586937185;
        Fri, 21 May 2021 01:48:57 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id m11sm1226436wri.44.2021.05.21.01.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 01:48:56 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Liang Li <liliang324@gmail.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Tianyu.Lan@microsoft.com
Subject: Re: About the performance of hyper-v
In-Reply-To: <CA+2MQi_LG57KRRFjMR_zPvJBDaH4z16S5J=c+U+-Ss_Z71Ax7g@mail.gmail.com>
References: <CA+2MQi-_06J1cmLhKAmV1vkPEnvDx6+bOnK06OciYmdymaNruw@mail.gmail.com>
 <87cztmkdlp.fsf@vitty.brq.redhat.com>
 <CA+2MQi_LG57KRRFjMR_zPvJBDaH4z16S5J=c+U+-Ss_Z71Ax7g@mail.gmail.com>
Date:   Fri, 21 May 2021 10:48:55 +0200
Message-ID: <87y2c8iia0.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Liang Li <liliang324@gmail.com> writes:

>> > Hi Vitaly,
>> >
>> > I found a case that the virtualization overhead was almost doubled
>> > when turning on Hper-v related features compared to that without any
>> > no hyper-v feature.  It happens when running a 3D game in windows
>> > guest in qemu kvm environment.
>> >
>> > By investigation, I found there are a lot of IPIs triggered by guest,
>> > when turning on the hyer-v related features including stimer, for the
>> > apicv is turned off, at least two vm exits are needed for processing a
>> > single IPI.
>> >
>> >
>> > perf stat will show something like below [recorded for 5 seconds]
>> >
>> > ---------
>> >
>> > Analyze events for all VMs, all VCPUs:
>> >              VM-EXIT    Samples  Samples%     Time%    Min Time    Max
>> > Time         Avg time
>> >   EXTERNAL_INTERRUPT     471831    59.89%    68.58%      0.64us
>> > 65.42us      2.34us ( +-   0.11% )
>> >            MSR_WRITE     238932    30.33%    23.07%      0.48us
>> > 41.05us      1.56us ( +-   0.14% )
>> >
>> > Total Samples:787803, Total events handled time:1611193.84us.
>> >
>> > I tried turning off hyper-v for the same workload and repeat the test,
>> > the overall virtualization overhead reduced by about of 50%:
>> >
>> > -------
>> >
>> > Analyze events for all VMs, all VCPUs:
>> >
>> >              VM-EXIT    Samples  Samples%     Time%    Min Time    Max
>> > Time         Avg time
>> >           APIC_WRITE     255152    74.43%    50.72%      0.49us
>> > 50.01us      1.42us ( +-   0.14% )
>> >        EPT_MISCONFIG      39967    11.66%    40.58%      1.55us
>> > 686.05us      7.27us ( +-   0.43% )
>> >            DR_ACCESS      35003    10.21%     4.64%      0.32us
>> > 40.03us      0.95us ( +-   0.32% )
>> >   EXTERNAL_INTERRUPT       6622     1.93%     2.08%      0.70us
>> > 57.38us      2.25us ( +-   1.42% )
>> >
>> > Total Samples:342788, Total events handled time:715695.62us.
>> >
>> > For this scenario,  hyper-v works really bad.  stimer works better
>> > than hpet, but on the other hand, it relies on SynIC which has
>> > negative effects for IPI intensive workloads.
>> > Do you have any plans for improvement?
>> >
>>
>> Hey,
>>
>> the above can be caused by the fact that when 'hv-synic' is enabled, KVM
>> automatically disables APICv and this can explain the overhead and the
>> fact that you're seeing more vmexits. KVM disables APICv because SynIC's
>> 'AutoEOI' feature is incompatible with it. We can, however, tell Windows
>> to not use AutoEOI ('Recommend deprecating AutoEOI' bit) and only
>> inhibit APICv if the recommendation was ignored. This is implemented in
>> the following KVM patch series:
>> https://lore.kernel.org/kvm/20210518144339.1987982-1-vkuznets@redhat.com/
>>
>> It will, however, require a new 'hv-something' flag to QEMU. For now, it
>> can be tested with 'hv-passthrough'.
>>
>> It would be great if you could give it a spin!
>>
>> --
>> Vitaly
>
> It's great to know that you already have a solution for this. :)
>
> By the way,  is there any requirement for the version of windows or
> windows updates for the new feature to work?

AFAIR, 'Recommend deprecating AutoEOI' bit appeared in WS2012 so I'd
expect WS2008 to ignore it completely (and thus SynIC will always be
disabling APICv for it).

-- 
Vitaly

