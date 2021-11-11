Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5162244DB4C
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 18:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbhKKRyu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 12:54:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56529 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233361AbhKKRyu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 12:54:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636653120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+jq8wGq2890McAb97SRyc2p1x5wYZX4e7vFXhMT4Yzs=;
        b=ONJQ2s5HnqxN4YIqt+NPeK0/hL8OlXQrYIzrEObUi67NvNiWWrfB9g4yYg7Zq60NWxId/m
        nPMFX5VJ96m29DrGYQAmWxCmO0gHRLgMMdO7/Q2kD/L0HjYESt1TayHHLru5zcrK7D/kEN
        KhUjCgN0iAqXy1gFsi+okuZV3rslnw4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-HKzjXsq7NMWtJwZDjwM1sA-1; Thu, 11 Nov 2021 12:51:59 -0500
X-MC-Unique: HKzjXsq7NMWtJwZDjwM1sA-1
Received: by mail-wm1-f70.google.com with SMTP id a67-20020a1c7f46000000b00333629ed22dso1548010wmd.6
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 09:51:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+jq8wGq2890McAb97SRyc2p1x5wYZX4e7vFXhMT4Yzs=;
        b=yxoL/j6hrOKcrvo+5wvA0HlVxl347wZaEv2NJFPKxiJKxGBQI6PNjBZr5phBAE6VaC
         eAZ6O7mKQKFqItUQlBiqdZ98JBjouq0xWZ1B2FUCsgcpiSKTQ+CUzyx/4koYhA696wYE
         lQ8E8dwcLmpagC/yuJ/xdGMf2tEzxhhEq5hm1MhjHVxJSC1IyZzfMNXRGltqre42sWnt
         ViBWR/otoQ9O+is6pYuXDXV+jW9CFPHNcYmiUg8nBFbmGYVaYVOx43s42+RYVgNr6XY5
         GYXQU9CUKGsVHE6bInJh3WiawRy3Lai3kvbXR8v+STD+VByL9PV1q1GGwzagM9UWsnyP
         NhrA==
X-Gm-Message-State: AOAM530/da5qHQF5LRwEa/kmbmAS0LipOV+TOn6sfbgXf4qafgB0szMA
        kWMPRJq650Ap65ZKhTBrNKkDNbEM4YzyLJ7Ym/bv2wDZ4LRlipcPPeZcRL0CtfOWNkS1cubr0lf
        d+7ymEh/h+Vqk
X-Received: by 2002:a05:600c:a55:: with SMTP id c21mr27404928wmq.191.1636653117948;
        Thu, 11 Nov 2021 09:51:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwx8pvz+OZOZYRwRviIiEBR9CIg42Cnxv/B8GOna7UMplCeGaoyJlMuGSARvnCJ2Uobov5TIA==
X-Received: by 2002:a05:600c:a55:: with SMTP id c21mr27404899wmq.191.1636653117678;
        Thu, 11 Nov 2021 09:51:57 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id h18sm4037740wre.46.2021.11.11.09.51.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 09:51:57 -0800 (PST)
Message-ID: <682754b9-a402-e992-7318-48844a3da20c@redhat.com>
Date:   Thu, 11 Nov 2021 18:51:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH 00/14] Run access test in an L2 guest
Content-Language: en-US
To:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com
References: <20211110212001.3745914-1-aaronlewis@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211110212001.3745914-1-aaronlewis@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/10/21 22:19, Aaron Lewis wrote:
> The motivation behind this change is to test the routing logic when an
> exception occurs in an L2 guest and ensure the exception goes to the
> correct place.  For example, if an exception occurs in L2, does L1 want
> to get involved, or L0, or do niether of them care about it and leave
> it to L2 to handle.  Test that the exception doesn't end up going to L1
> When L1 didn't ask for it.  This was occurring before commit 18712c13709d
> ("KVM: nVMX: Use vmx_need_pf_intercept() when deciding if L0 wants a #PF")
> fixed the issue.  Without that fix, running
> vmx_pf_exception_test_reduced_maxphyaddr with allow_smaller_maxphyaddr=Y
> would have resulted in the test failing with the following error:
> 
> x86/vmx_tests.c:10698: assert failed: false: Unexpected exit to L1,
> exit_reason: VMX_EXC_NMI (0x0)
> 
> This series only tests the routing logic for #PFs.  A future
> series will address other exceptions, however, getting #PF testing in
> place is a big enough chunk that the other exceptions will be submitted
> seperately (in a future series).
> 
> This series is dependant on Paolo's changes (inlcuded). Without them,
> running ac_test_run() on one of the userspace test fails.  Of note:  the
> commit ("x86: get rid of ring0stacktop") has been updated to include a fix
> for a compiler error to get it building on clang.
> 
> This series is also dependant on the commit ("x86: Look up the PTEs rather
> than assuming them").  This was sent out for review seperately, however,
> it is needed to get ac_test_run() running on a different cr3 than the one
> access_test runs on, so it is included here as well.  This is also v2 of
> that commit.  While preparing this series a review came in, so I just
> included the changes here.

Queued, thanks.

Paolo

