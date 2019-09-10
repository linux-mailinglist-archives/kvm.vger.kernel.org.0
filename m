Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48A0BAEDB7
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 16:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393314AbfIJOvE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 10:51:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58954 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732708AbfIJOvE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 10:51:04 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1C8597BDB2
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 14:51:03 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id o11so9085956wrq.22
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 07:51:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gofW/I3HiExmHtJYHDSGlY73UxNhHRod7s0r8vNZb4U=;
        b=l2igp+CrJEaMnDZZjkyyG/eKT2qQLsRKUU4Rp98R/Pa8TDFktgt9FoYQThHvI0tTXA
         jyseKrjYWECSQcUOzPJxI/9xdVo89dG/yhw3SgIPZ8IHnIJBmwoDr1Acw6t6IhuM+EQy
         f/+8nNpuNiGdMDfg1dOwx2IA0rOH2ql6r8EYE3+uS2W2F0Mbop2XpfCWW8+8cimYiNH7
         vXHxaOzozlitWvp6ijK650hJQuoPuSPXuqS4BcUv4xdtnbtiT/htbTueCHz2hjOviimu
         s9Vyi00CI7v/ep6BH0hxR5lBNQMbPi1ugu5ehMUUHctWnGk1AdESB/5bxczIFZe9oVSH
         4KrA==
X-Gm-Message-State: APjAAAX8bl9QdN3rGFWxbaFQdQr3gCfcUubDxUF7/Vpm7ABhZzT/inOx
        rohq6OV9VUIzuJUUnYQVeaBm55PzDGyjMeezjZhh1J5TUVn+P1RHQFOgqhYL42TDtA8llVJYzeR
        bgLb8044I+KB7
X-Received: by 2002:adf:f44e:: with SMTP id f14mr25934386wrp.290.1568127061751;
        Tue, 10 Sep 2019 07:51:01 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxorwp1TFUnqIKQEgqAs5kfMyLGOONDuonTUrORfhsMZdVRomI374440aHqUvjYCB6KSeKDrQ==
X-Received: by 2002:adf:f44e:: with SMTP id f14mr25934353wrp.290.1568127061483;
        Tue, 10 Sep 2019 07:51:01 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id q192sm4305937wme.23.2019.09.10.07.51.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2019 07:51:00 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] travis.yml: Enable running of tests with
 TCG
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Drew Jones <drjones@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
References: <20190830184509.15240-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5a14349e-4345-7a5f-3e9f-a697fca79b56@redhat.com>
Date:   Tue, 10 Sep 2019 16:50:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190830184509.15240-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/08/19 20:45, Thomas Huth wrote:
> Currently the tests at the end of the .travis.yml script are ignored,
> since we can not use KVM in the Travis containers. But we can actually
> run of some of the kvm-unit-tests with TCG instead, to make sure that
> the binaries are not completely broken.
> Thus introduce a new TESTS variable that lists the tests which we can
> run with TCG. Unfortunately, the ppc64 and s390x QEMUs in Ubuntu also
> need some extra love: The ppc64 version only works with the additional
> "cap-htm=off" setting. And the s390x package lacks the firmware and
> refuses to work unless we provide a fake firmware file here. Any file
> works since the firmware is skipped when "-kernel" is used, so we can
> simply use one of the pre-existing files in the source tree.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  .travis.yml | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/.travis.yml b/.travis.yml
> index a4a165d..6c14953 100644
> --- a/.travis.yml
> +++ b/.travis.yml
> @@ -20,24 +20,40 @@ env:
>    matrix:
>      - CONFIG=""
>        BUILD_DIR="."
> +      TESTS="vmexit_cpuid vmexit_mov_from_cr8 vmexit_mov_to_cr8 vmexit_ipi
> +             vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed"
>      - CONFIG=""
>        BUILD_DIR="x86-builddir"
> +      TESTS="ioapic-split ioapic smptest smptest3 eventinj msr port80 syscall
> +             tsc rmap_chain umip intel_iommu vmexit_inl_pmtimer vmexit_ipi_halt"
>      - CONFIG="--arch=arm --cross-prefix=arm-linux-gnueabihf-"
>        BUILD_DIR="."
> +      TESTS="selftest-vectors-kernel selftest-vectors-user selftest-smp"
>      - CONFIG="--arch=arm --cross-prefix=arm-linux-gnueabihf-"
>        BUILD_DIR="arm-buildir"
> +      TESTS="pci-test pmu gicv2-active gicv3-active psci selftest-setup"
>      - CONFIG="--arch=arm64 --cross-prefix=aarch64-linux-gnu-"
>        BUILD_DIR="."
> +      TESTS="selftest-vectors-kernel selftest-vectors-user selftest-smp"
>      - CONFIG="--arch=arm64 --cross-prefix=aarch64-linux-gnu-"
>        BUILD_DIR="arm64-buildir"
> +      TESTS="pci-test pmu gicv2-active gicv3-active psci timer selftest-setup"
>      - CONFIG="--arch=ppc64 --endian=little --cross-prefix=powerpc64le-linux-gnu-"
>        BUILD_DIR="."
> +      TESTS="spapr_hcall emulator rtas-set-time-of-day"
> +      ACCEL="tcg,cap-htm=off"
>      - CONFIG="--arch=ppc64 --endian=little --cross-prefix=powerpc64le-linux-gnu-"
>        BUILD_DIR="ppc64le-buildir"
> +      TESTS="rtas-get-time-of-day rtas-get-time-of-day-base"
> +      ACCEL="tcg,cap-htm=off"
>      - CONFIG="--arch=s390x --cross-prefix=s390x-linux-gnu-"
>        BUILD_DIR="."
> +      TESTS="diag10 diag308"
> +      ACCEL="tcg,firmware=s390x/run"
>      - CONFIG="--arch=s390x --cross-prefix=s390x-linux-gnu-"
>        BUILD_DIR="s390x-builddir"
> +      TESTS="sieve"
> +      ACCEL="tcg,firmware=s390x/run"
>  
>  before_script:
>    - mkdir -p $BUILD_DIR && cd $BUILD_DIR
> @@ -45,4 +61,5 @@ before_script:
>    - if [ -e ../configure ]; then ../configure $CONFIG ; fi
>  script:
>    - make -j3
> -  - ./run_tests.sh || true
> +  - ACCEL="${ACCEL:-tcg}" ./run_tests.sh -v $TESTS | tee results.txt
> +  - if grep -q FAIL results.txt ; then exit 1 ; fi
> 

Queued, thanks.

Paolo
