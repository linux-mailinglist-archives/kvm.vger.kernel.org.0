Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7678C42ECBC
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 10:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbhJOIuL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 04:50:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37791 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229849AbhJOIuJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Oct 2021 04:50:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634287682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tB/gkkjZsllie3Yvo9phHa69OMcnPBuasEQDVapsJYA=;
        b=M/R8722dMPzaijFeH0/unDQO0RQZTWZTgbGGAwUKosY2d+BByaatqfqk6DieQ//6XiuT8V
        2903fwzdQmBZYegAueMJI1UhZEAcgnAa8rtczSzYnyU3UJgECA59g4veFWABGaO5yeJsBu
        E9SZTVEJcTuzjGG/zQxaT7YZhqG/kI8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-3o_GTAHDPHqJV2aE8U4Y5A-1; Fri, 15 Oct 2021 04:48:01 -0400
X-MC-Unique: 3o_GTAHDPHqJV2aE8U4Y5A-1
Received: by mail-ed1-f72.google.com with SMTP id c25-20020a056402143900b003dc19782ea8so4082103edx.3
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 01:48:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tB/gkkjZsllie3Yvo9phHa69OMcnPBuasEQDVapsJYA=;
        b=uts9LZpPW1S0vepdty+3k56vvSHfCJcMx6gzxGBB8/z6sAdLwSVBAXpBXUJAWLNhjU
         SIIzY4TgKmmLbw+ejWQKaZ+ZDl61WcsvRbClrI/FCp36Fp1bvBeuJnw86tNUIunF+SJp
         sgPvX7c6Mf8aJh6yjNejmIltYBV7mkZcaqq2zx+6CudUef2NL+VmF4gn52aZVbZkggRX
         qcAgi1F0yLgruNy6nGMqUs7FshmUP5FB7VQiYkwaESeRs8wGMZFPrJHzwfHmqyW9uMY0
         P4kFryQF07ELs1JYo+1OZdfzucdd8Clo0FpwqdE1FOjVdu69J8PMFhfn2x8N/5zOBnuJ
         O32Q==
X-Gm-Message-State: AOAM531H91Wro/l18iP4ksV8B3P4cvYitnK9BNAuuwkiKUNh/6eHjggl
        BbtXO4b4ocQ+4uVdhmd6lYgB0MnMMigsZ+L2XWqUi4rNJY5DKRJvYR/qTVBy9p2dbXpuCExHEZ2
        ItXjj7jJVC5ku
X-Received: by 2002:a05:6402:270f:: with SMTP id y15mr15877412edd.126.1634287680344;
        Fri, 15 Oct 2021 01:48:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxGzkOQx3Z+QfSsE67T1Qfemiv6kryTvA5QIL4gVj0vSXZETTEviS8t3FZArLP/DBF46OWw0A==
X-Received: by 2002:a05:6402:270f:: with SMTP id y15mr15877400edd.126.1634287680189;
        Fri, 15 Oct 2021 01:48:00 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id v13sm4649609edl.69.2021.10.15.01.47.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 01:47:59 -0700 (PDT)
Message-ID: <bfb75bb2-2b5d-7fd7-b563-3c1ee7607b21@redhat.com>
Date:   Fri, 15 Oct 2021 10:47:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.15, take #2
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, kernel-team@android.com
References: <20211015084245.2994276-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211015084245.2994276-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/10/21 10:42, Marc Zyngier wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.15-2

Pulled, thanks.

Paolo

