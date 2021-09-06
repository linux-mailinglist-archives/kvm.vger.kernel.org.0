Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 525634019AD
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 12:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241879AbhIFKVL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 06:21:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50284 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241708AbhIFKVK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Sep 2021 06:21:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630923606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kApZxRcNths8CwofL4jwNIMwgxVB9nVlu1PJuFsciKs=;
        b=RwIWe7rlUZXYHk/u4j6B0N1y/IrP/Mq29zwEJp0P3P/SNh1IhprBZ9ieFsGLg/EwhChb5N
        aQdGWo2w2L0DOZ0CzxMmc6L27SssRGR5o9JDEqmM7SwbYtaKiPbKphTfDS+MrDNholGylv
        gV24ulkgAqI7CxxevTghG4zU423KwpQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-oUdpm6rUPH6AivF5-QXrpA-1; Mon, 06 Sep 2021 06:20:05 -0400
X-MC-Unique: oUdpm6rUPH6AivF5-QXrpA-1
Received: by mail-ed1-f69.google.com with SMTP id b6-20020aa7c6c6000000b003c2b5b2ddf8so3493235eds.0
        for <kvm@vger.kernel.org>; Mon, 06 Sep 2021 03:20:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kApZxRcNths8CwofL4jwNIMwgxVB9nVlu1PJuFsciKs=;
        b=jv/NOrCTNUs3vyldsqQMVRj8eTbcCbGAj9qP+Vas0vpHmePK/1keDzEJ/OJwhs/jXo
         03ymCvj10rqMb+5b5GgAL+w7YlAb9l8olCtqYUG7VWmC0XjK8hCKruCXoB/mHE2rHGew
         onWEHbU+vY6OPn9UJZ0iMm0Kw/LpEFOya7rL33xUfkEYOnfZsDoEfesAPl3mnYUbdTIY
         IEdOmpx0bjEnHX2X7GlNY4KzfKDZwQk/J9t3fiTCBPXb/X6jm3ZB4v3fp0+pdHZsbKv1
         EPGmPaT77mcG72spHGPBIPL9upzrEbx8VKeVbZIP6F2fG6QGOvk+ftL1dWi66Q+3l3s6
         fboA==
X-Gm-Message-State: AOAM531Dg04uYK8SmeLOq0HN1Ac7CTN9bNeylAMQqzqoCIm21BGlqG6+
        2E9XIcVyc0GUvaBK9MDhK3S0Gy/cm3AAR2uBdSg+YxDRo+VodVhuRSM2bHjfiE1cDjeBaJ7o5ZC
        d0XY8kz6/7Mbs
X-Received: by 2002:a17:906:b00c:: with SMTP id v12mr12809173ejy.222.1630923603867;
        Mon, 06 Sep 2021 03:20:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyPJ+JhtNZmx05ysP93LZo4bmGfUAKojyaBYEWc3KUkgJMiIG8poRKWqRwdzqSe7p8yZW5CTg==
X-Received: by 2002:a17:906:b00c:: with SMTP id v12mr12809159ejy.222.1630923603602;
        Mon, 06 Sep 2021 03:20:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p23sm4471023edw.94.2021.09.06.03.20.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 03:20:03 -0700 (PDT)
Subject: Re: [PATCH 0/3] KVM: x86/mmu: kvm_mmu_page cleanups
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia He <justin.he@arm.com>
References: <20210901221023.1303578-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6636f9c9-96e9-40bf-e344-c0b3f6ed7bed@redhat.com>
Date:   Mon, 6 Sep 2021 12:20:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210901221023.1303578-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/09/21 00:10, Sean Christopherson wrote:
> Patch 1 is from Jia He to remove a defunct boolean from kvm_mmu_page
> (link[*] below if you want to take it directly).
> 
> Patch 2 builds on that patch to micro-optimize the TDP MMU flag.
> 
> Patch 3 is another micro-optimization that probably doesn't buy much
> performance (I didn't check), feel free to ignore it.
> 
> [*] https://lkml.kernel.org/r/20210830145336.27183-1-justin.he@arm.com
> 
> Jia He (1):
>    KVM: x86/mmu: Remove unused field mmio_cached in struct kvm_mmu_page
> 
> Sean Christopherson (2):
>    KVM: x86/mmu: Relocate kvm_mmu_page.tdp_mmu_page for better cache
>      locality
>    KVM: x86/mmu: Move lpage_disallowed_link further "down" in
>      kvm_mmu_page
> 
>   arch/x86/kvm/mmu/mmu_internal.h | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
> 

Queued, thanks.

Paolo

