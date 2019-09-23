Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E287BBB1DD
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 12:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436460AbfIWKCy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 06:02:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59328 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407592AbfIWKCy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 06:02:54 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E29ACC059B7C
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 10:02:53 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id c188so4743304wmd.9
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 03:02:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7Y8XgF9VSWF/4IabhykeB5kMw3gTyZVDX47zu96+jbI=;
        b=K9yCII1T64aoyvKGt44TYwNvMgtDLLrIKJUxdGGYrNzGdn9hI5B2sS77II49hs95c0
         kOE2ZlUK6F4waGj+S0N+0JZd5ZTJ7bMSW89uW4kYFiNvzgsPRJ2dkMWibeuC+JiZeloh
         BodFrQHbzekFRSWGhtEuIHSRZ7wtUbEXIXYApg0MF7iOh9+vbWo8rw7xTc19DKqnDDNc
         GX96zWIcmbBwApIQt/pKIR2PxNhDJ43zuNsINBmfpsEzPUb5dKqWy9m13w8MDxveDOgZ
         6OyT9l+gJqgVq8yTzlqSOES+OoQeQ46vdV4AKjeeQ+E4s6GVOKf9Bk14eh8bg2bpxkzr
         qo/w==
X-Gm-Message-State: APjAAAVDwmX9daQGxvaJ4amAfoFO2stYtc5gCEhRO1LHahJNokq2jZYR
        H+4LuXGtayCyGmIQ0zgmvoAlYhQd2ePxphOFgpCd5N4wT8hStalcGieqkezgRqsWlbefnjDjPxW
        u7lSt4VNsCgo7
X-Received: by 2002:a7b:c932:: with SMTP id h18mr12000164wml.86.1569232972397;
        Mon, 23 Sep 2019 03:02:52 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwbawnEsOggXmfc7CbN4mNkoTizp76vM/AK7Yl6A6YLO39lVCowu1LjvNDy+wzZGb8IXNI7RQ==
X-Received: by 2002:a7b:c932:: with SMTP id h18mr12000146wml.86.1569232972164;
        Mon, 23 Sep 2019 03:02:52 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id g73sm16566505wme.10.2019.09.23.03.02.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2019 03:02:51 -0700 (PDT)
Subject: Re: [PATCH 10/17] KVM: monolithic: x86: use the external functions
 instead of kvm_x86_ops
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-11-aarcange@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <38f723ba-9746-d550-c86f-61807a6f17eb@redhat.com>
Date:   Mon, 23 Sep 2019 12:02:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190920212509.2578-11-aarcange@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/09/19 23:25, Andrea Arcangeli wrote:
> Now that the new methods are plugged in and they are functional use
> them instead of invoking the pointer to functions through kvm_x86_ops.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  10 +-
>  arch/x86/kvm/cpuid.c            |  22 +--
>  arch/x86/kvm/hyperv.c           |   6 +-
>  arch/x86/kvm/kvm_cache_regs.h   |  10 +-
>  arch/x86/kvm/lapic.c            |  28 +--
>  arch/x86/kvm/mmu.c              |  26 +--
>  arch/x86/kvm/mmu.h              |   4 +-
>  arch/x86/kvm/pmu.c              |  24 +--
>  arch/x86/kvm/pmu.h              |   2 +-
>  arch/x86/kvm/trace.h            |   4 +-
>  arch/x86/kvm/vmx/pmu_intel.c    |   2 +-
>  arch/x86/kvm/x86.c              | 304 ++++++++++++++++----------------
>  arch/x86/kvm/x86.h              |   2 +-

Let's make the prefix kvm_x86_ instead of kvm_x86_ops_.

Paolo
