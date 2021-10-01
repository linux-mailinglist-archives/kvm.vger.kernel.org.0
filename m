Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB35641EF3F
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 16:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354354AbhJAOSx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 10:18:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59476 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354342AbhJAOSw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 1 Oct 2021 10:18:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633097827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QXYa/6pNkGh7DhVVHoCv6tDp16H1ut5Qth6GnXzzM4k=;
        b=Gr3wFEBPvtW3PROtYIE2kaUrJM5PR/9mVHa5+69nkkY61XulJ9Hgrn2C8JDIXQ7Z30pSW0
        n3bvo9H1YYaN9P1uGSZhDxsyiq4GbIwiPXi2DtNWy76gqP3UMSlnV4+dht37cQkag774cd
        UrbYbfrLDkIbZ6BoOVocyQWqb7g4M/8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-ZyOL4J-RP5KhycN8oT_zrA-1; Fri, 01 Oct 2021 10:17:06 -0400
X-MC-Unique: ZyOL4J-RP5KhycN8oT_zrA-1
Received: by mail-ed1-f69.google.com with SMTP id c8-20020a50d648000000b003daa53c7518so10235722edj.21
        for <kvm@vger.kernel.org>; Fri, 01 Oct 2021 07:17:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QXYa/6pNkGh7DhVVHoCv6tDp16H1ut5Qth6GnXzzM4k=;
        b=R2SEwq3KSRO59PRe1uxFYnBPq6T+jB7kV6jHbGcSPc4Cn5f6UUHyy+3OAEH3+jYibX
         EH8NvUfWZrmAg2EzjaEikKgLI813TROM8iVVxUJgUNXbYuyGw2bQVBIc7xWmTTpuNaIF
         DT4vLSP0/9X+HsZyydclAY/lLJwRLlw+m4yb04x6ld0TC9uMyGD7+F/Eyc4Ztus4qM4U
         a6P50fuKw3KiSuqpL3UHEUD4I+6ZWqs4PPdbhG+QKaxjWTClha5r52FmYfF/H+6NinLX
         pdiE57pMZfJcSFox2WLoTA1PQSlpZNna/jGevjVNbQhfDJKmzAlLsMBmCjwD0ImUPmff
         nWpg==
X-Gm-Message-State: AOAM530+4NEK3q+t938TFnFyM6gfDlyFHVsQEYSyUhYwZ9f0CexdgDIP
        YKsWavETYA2l+CPA04c8tbrG0ebVjKrCzBuF1+oeCxC68ZQ6rAY1tGLCcmfVIFIDJa0Klw1FGo+
        brhunxhOyqTS7
X-Received: by 2002:aa7:c7c2:: with SMTP id o2mr14606951eds.166.1633097824762;
        Fri, 01 Oct 2021 07:17:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxCiMsXBYCQ8UWIYXEv0CCzQitsksl4VwheKReCDgqX9Kwx4ytTAjcLaQ0AagoSgyQ5wyZQng==
X-Received: by 2002:aa7:c7c2:: with SMTP id o2mr14606924eds.166.1633097824509;
        Fri, 01 Oct 2021 07:17:04 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id f25sm1228903ejb.34.2021.10.01.07.17.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Oct 2021 07:17:03 -0700 (PDT)
Message-ID: <b39b08ff-b4cf-0409-5b70-3484441517fc@redhat.com>
Date:   Fri, 1 Oct 2021 16:17:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v8 4/7] KVM: x86: Report host tsc and realtime values in
 KVM_GET_CLOCK
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
References: <20210916181538.968978-1-oupton@google.com>
 <20210916181538.968978-5-oupton@google.com>
 <20210929185629.GA10933@fuller.cnet> <20210930192107.GB19068@fuller.cnet>
 <871r557jls.ffs@tglx>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <871r557jls.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/10/21 01:02, Thomas Gleixner wrote:
> 
>   Now the proposed change is creating exactly the same problem:
> 
>   +	if (data.flags & KVM_CLOCK_REALTIME) {
>   +		u64 now_real_ns = ktime_get_real_ns();
>   +
>   +		/*
>   +		 * Avoid stepping the kvmclock backwards.
>   +		 */
>   +		if (now_real_ns > data.realtime)
>   +			data.clock += now_real_ns - data.realtime;
>   +	}

Indeed, though it's opt-in (you can always not pass KVM_CLOCK_REALTIME 
and then the kernel will not muck with the value you gave it).

> virt came along and created a hard to solve circular dependency
> problem:
> 
>    - If CLOCK_MONOTONIC stops for too long then NTP/PTP gets out of
>      sync, but everything else is happy.
>      
>    - If CLOCK_MONOTONIC jumps too far forward, then all hell breaks
>      lose, but NTP/PTP is happy.

Yes, I agree that this sums it up.

For example QEMU (meaning: Marcelo :)) has gone for the former and 
"hoping" that NTP/PTP sorts it out sooner or later.  The clock in 
nanoseconds is sent out to the destination and restored.

Google's userspace instead went for the latter.  The reason is that 
they've always started running on the destination before finishing the 
memory copy[1], therefore it's much easier to bound the CLOCK_MONOTONIC 
jump.

I do like very much the cooperative S2IDLE or even S3 way to handle the 
brownout during live migration.  However if your stopping time is 
bounded, these patches are nice because, on current processors that have 
TSC scaling, they make it possible to keep the illusion of the TSC 
running.  Of course that's a big "if"; however, you can always bound the 
stopping time by aborting the restart on the destination machine once 
you get close enough to the limit.

Paolo

[1] see https://dl.acm.org/doi/pdf/10.1145/3296975.3186415, figure 3

