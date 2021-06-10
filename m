Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7CCF3A31A0
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 19:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhFJRDo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 13:03:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24093 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229802AbhFJRDo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 13:03:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623344507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=smhh7ChUWNyvRIjQ4a5pk+uwg2wXey4b0vnBlZ2UvTQ=;
        b=COUsfX7fScesjyy7TKaaVoxZwMekFCRMa2yztXoxtU3XcAIYJbpScs94F6+Hto7IogOuy1
        ABpWpPi8sc1GDBiMR1XKXJQppVTgGT/ITJoEAopUoYBLOpgxXchuYVkQBlcDJuTOevePR4
        dQz/+vY+0w70M2glcUnOZ3mCo+4j3dA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-Bel9RfUNN_Kb-09DeU9MfQ-1; Thu, 10 Jun 2021 13:01:46 -0400
X-MC-Unique: Bel9RfUNN_Kb-09DeU9MfQ-1
Received: by mail-wm1-f69.google.com with SMTP id f22-20020a1c6a160000b029018f49a7efb7so4188663wmc.1
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 10:01:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=smhh7ChUWNyvRIjQ4a5pk+uwg2wXey4b0vnBlZ2UvTQ=;
        b=SedsO5dO4X3p6Ei8+QhxqISdPFU7ha7tQRLaPtj2bZW3b1ircIu7AVOfqDCiKJdBdg
         0aHL2SMcevDHY9LEndCAOgelXRBnFHqlVRL5dBfyDYW9/RnlmoATcOIdtpvOYucpMq9O
         vSPJcVVw4ewoddbhqUvny2wqQ6Pkj0Sb/dajf38lhBZwvPzKfjM0Rlyl8S4umwzgDjSz
         9Jnt3ZJkHeXKuWlA03cGSGoJY4kNuZBQBUY1a0gQ4ok/qu440rqs4r/O06qdGkQKVrIQ
         kl28cClQm9E3GDf1f+sXhlB5jyfO0PtcFgpwDS25YwhNpmR+Gk+vgu6quxaxpfz3G+gO
         sRrg==
X-Gm-Message-State: AOAM530a/hG2h0iHfy0z7EDxYKMihPXSXC8pOX6jK3D0UoJDbzDu++gs
        qFvNtUbValLmWXoAUGzQdLRoMGxF2R5Be2PrCrx1ZMla6Qu4SLRCvw7WPKd3oEC3V8HBZTmWfN/
        mAqdr71+sl2fBtyXEXvjA3D6Lke5o6S5MvPnqMPjpc76HoKkGisbRo6o87SOuHteh
X-Received: by 2002:adf:fe8c:: with SMTP id l12mr6692207wrr.26.1623344504680;
        Thu, 10 Jun 2021 10:01:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxK3ioxgNVvZqZY1dkLjaAiOo8mgXFLdlLVKxCLyt2FANj+H0mozxBCv3ovjRTACPHSKuCwWw==
X-Received: by 2002:adf:fe8c:: with SMTP id l12mr6692188wrr.26.1623344504504;
        Thu, 10 Jun 2021 10:01:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.gmail.com with ESMTPSA id p12sm9238540wme.43.2021.06.10.10.01.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 10:01:43 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 0/2] x86: hyper-v: expose hv_hypercall()
 from hyperv.h
To:     Siddharth Chandrasekaran <sidcha@amazon.de>
Cc:     Siddharth Chandrasekaran <sidcha.dev@gmail.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>, kvm@vger.kernel.org
References: <cover.1623330462.git.sidcha@amazon.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6f306598-62ed-f158-4644-59ce664b5926@redhat.com>
Date:   Thu, 10 Jun 2021 19:01:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <cover.1623330462.git.sidcha@amazon.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/06/21 15:12, Siddharth Chandrasekaran wrote:
> Couple of minor patches that promote hyperv.h to lib/x86 and expose
> hv_hypercall() from there so other tests can use do hypercalls too.
> 
> ~ Sid.
> 
> Siddharth Chandrasekaran (2):
>    x86: Move hyperv helpers into libs/x86
>    x86: Move hyper-v hypercall related methods to lib/x86/
> 
>   x86/Makefile.common       |  9 +-----
>   {x86 => lib/x86}/hyperv.h |  3 ++
>   {x86 => lib/x86}/hyperv.c | 52 +++++++++++++++++++++++++++++++++
>   x86/hyperv_connections.c  | 60 ++++-----------------------------------
>   4 files changed, 61 insertions(+), 63 deletions(-)
>   rename {x86 => lib/x86}/hyperv.h (98%)
>   rename {x86 => lib/x86}/hyperv.c (63%)
> 

Please base the overlay test on this patch instead of the other way 
round, thanks!  (You can send them in a single series).

Paolo

