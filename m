Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19E193890BC
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 16:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241909AbhESOXz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 10:23:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39573 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234654AbhESOXx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 May 2021 10:23:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621434151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YoPWReBJ7coHVZn89zjXWd8XWjqbT/8bFMJRY3N8pH8=;
        b=TOGmh6N+HIlLCEo2sjPojHA7pwV178qzK2bI8WTWNcCCI7SXMwr+nJMVOSJgpVI5fSqz/s
        xxd7khMrdrvw4Da03wm532+QsPaCV9wSqCCtRXbH0INk7KH+E/MReUA12KVQ6IttdpPkAV
        tCiKkMt2sxSpEB0MPpZIPnk2L55Y+t0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-ULmDoBDZMCSo5G8MZjRbOw-1; Wed, 19 May 2021 10:22:29 -0400
X-MC-Unique: ULmDoBDZMCSo5G8MZjRbOw-1
Received: by mail-wr1-f70.google.com with SMTP id h104-20020adf90710000b029010de8455a3aso7212317wrh.12
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 07:22:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=YoPWReBJ7coHVZn89zjXWd8XWjqbT/8bFMJRY3N8pH8=;
        b=sgYCHn8wl7fGxMoVtEBMas8yQG8LYMWNssu80MOTe8WJRdSZqJHFn/5RauTq8f1Hd8
         IVgMA+JvoG+y5zAMmzOwUqy4RunOniftbyb0VKb+Eq6CHWysMHlNN3pBaFc0iWkgR4t5
         RAVCGwIXHNlSnpIXu1YCGr6SNHGb50+8cSoIbTQ0/VVWBG4/BPQDGF751aWScr3kyIK7
         6IrDhUubWMPT9BTN5rWEAK4nOP5mbY11K/6FD3chM0hqji2ehNYZ0wINSnhNye1VoNfd
         +g/pCyvIg8A+XlQt2yVupifJUI4PQY+orN7xLLNv6zK8rRAm8nBMikw8owWZepUzk9Je
         2Syg==
X-Gm-Message-State: AOAM532OMUJbOFhO0ta69s3uNyibVun8gyyYUnVeuFxQ5naW2R4MfeDE
        VGrjDmhJpc3bcIHJ4QxUpRz5ruIlREyz/Z46QBdC+lDLGzi4oIdflEQfr1XZJhareGkeoh18GAo
        wHsfUXksfszoE
X-Received: by 2002:a05:600c:198d:: with SMTP id t13mr11448050wmq.179.1621434148032;
        Wed, 19 May 2021 07:22:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwutByAaLwHK8yre4qbgax2x632mPj3eJwuxzg3bNFt9d9tkqggBe4mvl1QIJu+EtWq9dTcBw==
X-Received: by 2002:a05:600c:198d:: with SMTP id t13mr11448022wmq.179.1621434147825;
        Wed, 19 May 2021 07:22:27 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id y6sm4583126wmy.23.2021.05.19.07.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 07:22:27 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Liang Li <liliang324@gmail.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Tianyu.Lan@microsoft.com
Subject: Re: About the performance of hyper-v
In-Reply-To: <CA+2MQi-_06J1cmLhKAmV1vkPEnvDx6+bOnK06OciYmdymaNruw@mail.gmail.com>
References: <CA+2MQi-_06J1cmLhKAmV1vkPEnvDx6+bOnK06OciYmdymaNruw@mail.gmail.com>
Date:   Wed, 19 May 2021 16:22:26 +0200
Message-ID: <87cztmkdlp.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Liang Li <liliang324@gmail.com> writes:

> [resend for missing cc]
>
> Hi Vitaly,
>
> I found a case that the virtualization overhead was almost doubled
> when turning on Hper-v related features compared to that without any
> no hyper-v feature.  It happens when running a 3D game in windows
> guest in qemu kvm environment.
>
> By investigation, I found there are a lot of IPIs triggered by guest,
> when turning on the hyer-v related features including stimer, for the
> apicv is turned off, at least two vm exits are needed for processing a
> single IPI.
>
>
> perf stat will show something like below [recorded for 5 seconds]
>
> ---------
>
> Analyze events for all VMs, all VCPUs:
>              VM-EXIT    Samples  Samples%     Time%    Min Time    Max
> Time         Avg time
>   EXTERNAL_INTERRUPT     471831    59.89%    68.58%      0.64us
> 65.42us      2.34us ( +-   0.11% )
>            MSR_WRITE     238932    30.33%    23.07%      0.48us
> 41.05us      1.56us ( +-   0.14% )
>
> Total Samples:787803, Total events handled time:1611193.84us.
>
> I tried turning off hyper-v for the same workload and repeat the test,
> the overall virtualization overhead reduced by about of 50%:
>
> -------
>
> Analyze events for all VMs, all VCPUs:
>
>              VM-EXIT    Samples  Samples%     Time%    Min Time    Max
> Time         Avg time
>           APIC_WRITE     255152    74.43%    50.72%      0.49us
> 50.01us      1.42us ( +-   0.14% )
>        EPT_MISCONFIG      39967    11.66%    40.58%      1.55us
> 686.05us      7.27us ( +-   0.43% )
>            DR_ACCESS      35003    10.21%     4.64%      0.32us
> 40.03us      0.95us ( +-   0.32% )
>   EXTERNAL_INTERRUPT       6622     1.93%     2.08%      0.70us
> 57.38us      2.25us ( +-   1.42% )
>
> Total Samples:342788, Total events handled time:715695.62us.
>
> For this scenario,  hyper-v works really bad.  stimer works better
> than hpet, but on the other hand, it relies on SynIC which has
> negative effects for IPI intensive workloads.
> Do you have any plans for improvement?
>

Hey,

the above can be caused by the fact that when 'hv-synic' is enabled, KVM
automatically disables APICv and this can explain the overhead and the
fact that you're seeing more vmexits. KVM disables APICv because SynIC's
'AutoEOI' feature is incompatible with it. We can, however, tell Windows
to not use AutoEOI ('Recommend deprecating AutoEOI' bit) and only
inhibit APICv if the recommendation was ignored. This is implemented in
the following KVM patch series:
https://lore.kernel.org/kvm/20210518144339.1987982-1-vkuznets@redhat.com/

It will, however, require a new 'hv-something' flag to QEMU. For now, it
can be tested with 'hv-passthrough'.

It would be great if you could give it a spin!

-- 
Vitaly

