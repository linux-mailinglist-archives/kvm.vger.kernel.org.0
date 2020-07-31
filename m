Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E108D23447F
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 13:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732485AbgGaLYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 07:24:39 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33299 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732104AbgGaLYh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 07:24:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596194675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FnDKMoIrI6Brz2FxzLVFulkmaL5xDwKSC+gKy7dwOZc=;
        b=OTrZZtAlxPWBN6n705pkAMW9lQvALvZXAb8WyrJeXGDqc/01Su1VapG3uPqGvNrwgdpBCc
        z3lSfPv84rrXdo94uIs1HiY8I51si/m8uQpmvY5MIv38qPs266W9rf3aMU/UwKfA58uxSJ
        aMVffBZ4LFI9oRW5sMSLpEmI783lgz4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-LbJuluI3OZiVPe2ZJTBr-A-1; Fri, 31 Jul 2020 07:24:33 -0400
X-MC-Unique: LbJuluI3OZiVPe2ZJTBr-A-1
Received: by mail-wr1-f72.google.com with SMTP id j2so6442226wrr.14
        for <kvm@vger.kernel.org>; Fri, 31 Jul 2020 04:24:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FnDKMoIrI6Brz2FxzLVFulkmaL5xDwKSC+gKy7dwOZc=;
        b=CVmgNsH2TzQlfnbCHG0+WuMr9di3/qCfOPvSQfLcyVAzJSMCX6kpibybPAM7bVtatD
         qATbmf/9wKP6OkZd2MffBb35i3JMO1CKoLx0EmjePPvnost6up8o9HAWJiPK5/iZz05m
         Tv6bL6QmpVjMOcW2Yqj+cvqCMS0Bh5EoKM0Gm/AIBT4IwE9ICdLdXgKMGBUCCYVsRwiu
         TMPLeP2Ur3TBpq94d/+NEwedUUy55uB/haf7/aIOyHARvZ/KUin3aMxYGFnlZ+WR07nS
         pufiDiU3P1QOxVYbBQfvq+GPR6+hOa2OAMq6G0zH0Oq9kMdjDQ24519uaWzHDN3HNYsR
         TrpQ==
X-Gm-Message-State: AOAM531bbPMlgDo8gHSVM+Gq9zIgRUtuewhjGLXZe68CVRs8SPeucL1/
        aFjDK0HvNoiS0blrLfabege4+TFG69PLMyAwHEj1b4QRD/wrtd1ZFyO48UPPC3+6kdQdvyy3t2J
        Q/la5bktZwiPz
X-Received: by 2002:a05:6000:1211:: with SMTP id e17mr3145446wrx.263.1596194672656;
        Fri, 31 Jul 2020 04:24:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfooP8J1sqE0dwd7h/KW/oWNUPCynNOlZVCfM60R+5HV2KUnh0EDFuZ+vXB907kTFPAzl/4g==
X-Received: by 2002:a05:6000:1211:: with SMTP id e17mr3145425wrx.263.1596194672381;
        Fri, 31 Jul 2020 04:24:32 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:310b:68e5:c01a:3778? ([2001:b07:6468:f312:310b:68e5:c01a:3778])
        by smtp.gmail.com with ESMTPSA id d7sm6954118wra.29.2020.07.31.04.24.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2020 04:24:31 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] gitlab-ci.yml: Compile some jobs
 out-of-tree
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     drjones@redhat.com
References: <20200731094139.9364-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e2b61ffa-fc82-ebae-fab3-0b5022c11296@redhat.com>
Date:   Fri, 31 Jul 2020 13:24:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200731094139.9364-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/07/20 11:41, Thomas Huth wrote:
> So far we only compiled all jobs in-tree in the gitlab-CI. For the code
> that gets compiled twice (one time for 64-bit and one time for 32-bit
> for example), we can easily move one of the two jobs to out-of-tree build
> mode to increase the build test coverage a little bit.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  .gitlab-ci.yml | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index 1ec9797..6613c7b 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -19,7 +19,9 @@ build-aarch64:
>  build-arm:
>   script:
>   - dnf install -y qemu-system-arm gcc-arm-linux-gnu
> - - ./configure --arch=arm --cross-prefix=arm-linux-gnu-
> + - mkdir build
> + - cd build
> + - ../configure --arch=arm --cross-prefix=arm-linux-gnu-
>   - make -j2
>   - ACCEL=tcg MAX_SMP=8 ./run_tests.sh
>       selftest-setup selftest-vectors-kernel selftest-vectors-user selftest-smp
> @@ -31,7 +33,9 @@ build-arm:
>  build-ppc64be:
>   script:
>   - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu
> - - ./configure --arch=ppc64 --endian=big --cross-prefix=powerpc64-linux-gnu-
> + - mkdir build
> + - cd build
> + - ../configure --arch=ppc64 --endian=big --cross-prefix=powerpc64-linux-gnu-
>   - make -j2
>   - ACCEL=tcg ./run_tests.sh
>       selftest-setup spapr_hcall rtas-get-time-of-day rtas-get-time-of-day-base
> @@ -77,7 +81,9 @@ build-x86_64:
>  build-i386:
>   script:
>   - dnf install -y qemu-system-x86 gcc
> - - ./configure --arch=i386
> + - mkdir build
> + - cd build
> + - ../configure --arch=i386
>   - make -j2
>   - ACCEL=tcg ./run_tests.sh
>       cmpxchg8b vmexit_cpuid vmexit_mov_from_cr8 vmexit_mov_to_cr8
> 

Applied, thanks.

Paolo

