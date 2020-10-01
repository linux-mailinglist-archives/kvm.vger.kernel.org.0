Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFF827FC59
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 11:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731605AbgJAJSh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 05:18:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53843 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725894AbgJAJSh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Oct 2020 05:18:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601543915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mMtf9G9z6EqUrGGTMXwLU+tPwuQnUh8q820Jj3pcbTs=;
        b=AIaiF0ofyru/dAB8AfZeEgD3jnIoPUNhRQzoH2UYbYivtfykIM7dVf1q4hb28mRzalYb0o
        XoeXp5rf9FqYzCtK4XSFcv8CtI8uF9E0AchJx6k8XAp62RSmFttWYekxZYcoDMBU+KgAif
        D4ZSx6txj3FdjWgA5t5200JcAtzc7Rw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-Z0lRG2GrPAC0uIXZ_KqCcg-1; Thu, 01 Oct 2020 05:18:34 -0400
X-MC-Unique: Z0lRG2GrPAC0uIXZ_KqCcg-1
Received: by mail-wm1-f71.google.com with SMTP id r83so969891wma.8
        for <kvm@vger.kernel.org>; Thu, 01 Oct 2020 02:18:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mMtf9G9z6EqUrGGTMXwLU+tPwuQnUh8q820Jj3pcbTs=;
        b=lHQwAWSIDQp8MoBI2CB6j0+xGqblEmMm/jQJYUdH+1JlU8tkZwhSzqqyQmHJ3A87ey
         x3W83/DDKBA0avzJGFwnR37Cac8vJjZsXRXFR7o/i1dxm61BQYV8wj02Dj7xUaFojq9H
         vXCz6i/PgjzV1UImIKMiKnlTvdWBbZsRL4jC/UR2mdqxmnOgUYHjt5lHIruz0/u0NPlX
         Tmr0Xllim94eycBRIq5Kou8JWdOvtycjawfsQTR8MyhRcuwBTPJ44AEeKPRoXIN9LT/k
         IPeLyfgfqVg22brozooYS3H4PhYASHvSpjH6kKEDQbi7Xz4TaY6kJbRhsVfeunOedwrA
         W3ZQ==
X-Gm-Message-State: AOAM530TiLxeLsdz7+m2BlzK/S/qHNkIQLr5r7bR/rsLYTe13UKsjV3D
        O73OZ20wbr4l/X6si5Jc6cblb2UTwYUnQsq7yuMQCcQOLb7nhpE80fOwK3gUIonUcbYYqJtET9j
        c5M7driWW9+Co
X-Received: by 2002:a1c:800f:: with SMTP id b15mr7090094wmd.114.1601543913149;
        Thu, 01 Oct 2020 02:18:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/ZLe+te2cu/cPsZgExbbujXfZnnD4I9XdEFo670dd9ti1oPRaD51ZMecYelK9mZpaj6MNdA==
X-Received: by 2002:a1c:800f:: with SMTP id b15mr7090084wmd.114.1601543912945;
        Thu, 01 Oct 2020 02:18:32 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f44:4e79:488f:33b3? ([2001:b07:6468:f312:f44:4e79:488f:33b3])
        by smtp.gmail.com with ESMTPSA id i33sm8663389wri.79.2020.10.01.02.18.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Oct 2020 02:18:32 -0700 (PDT)
Subject: Re: [PATCH v2 0/7] Update travis CI
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     drjones@redhat.com, lvivier@redhat.com
References: <20201001072234.143703-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5740ae55-6553-00a9-2e95-31c1a464dc6d@redhat.com>
Date:   Thu, 1 Oct 2020 11:18:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201001072234.143703-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/10/20 09:22, Thomas Huth wrote:
> Travis now features Ubuntu Focal containers, so we can update our
> kvm-unit-tests CI to use it for getting a newer version of QEMU and
> the compilers. Thanks to this QEMU update, we can now run more tests
> with TCG here.
> 
> Additionally, this series switches the second aarch64 build job to
> use the native builder - this way we can use the Clang compiler
> there to get some additional test coverage. This indeed already helped
> to discover some bogus register constraints in the aarch64 code.
> (ppc64 and s390x are not using the native builders yet since there are
> still some issues with Clang there that I haven't quite figured out ...
> that's maybe something for later)
> 
> v2:
>  - The patch that changed "bionic" into "focal" and the s390x patch
>    are already merged, so they are not included here anymore
>  - Fixed rebase conflicts in the x86 patches
>  - Dropped the hyperv tests from the 32-bit builds (they are going
>    to be marked as 64-bit only)
> 
> Thomas Huth (7):
>   travis.yml: Rework the x86 64-bit tests
>   travis.yml: Refresh the x86 32-bit test list
>   travis.yml: Add the selftest-setup ppc64 test
>   kbuild: fix asm-offset generation to work with clang
>   arm/pmu: Fix inline assembly for Clang
>   lib/arm64/spinlock: Fix inline assembly for Clang
>   travis.yml: Rework the aarch64 jobs
> 
>  .travis.yml             | 63 +++++++++++++++++++++++------------------
>  arm/pmu.c               | 10 ++++---
>  lib/arm64/spinlock.c    |  2 +-
>  lib/kbuild.h            |  6 ++--
>  scripts/asm-offsets.mak |  5 ++--
>  5 files changed, 48 insertions(+), 38 deletions(-)
> 

Queued, thanks.

Paolo

