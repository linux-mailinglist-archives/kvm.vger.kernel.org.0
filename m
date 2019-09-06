Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66F91AB514
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 11:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391218AbfIFJnc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 05:43:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47290 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730471AbfIFJnb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 05:43:31 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 06261308FC20;
        Fri,  6 Sep 2019 09:43:31 +0000 (UTC)
Received: from [10.36.117.162] (ovpn-117-162.ams2.redhat.com [10.36.117.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F5855D9CA;
        Fri,  6 Sep 2019 09:43:29 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] travis.yml: Enable running of tests with
 TCG
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Drew Jones <drjones@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
References: <20190830184509.15240-1-thuth@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <b94ed46f-7e50-daae-321c-c01b473ca0ea@redhat.com>
Date:   Fri, 6 Sep 2019 11:43:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190830184509.15240-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Fri, 06 Sep 2019 09:43:31 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30.08.19 20:45, Thomas Huth wrote:
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

What about the other s390x tests? (is the QEMU binary too old to make
them pass?)

The issue with TCG is that you can easily get false negatives in case
the QEMU binary changes (e.g., new Ubuntu release).

"to make sure that the binaries are not completely broken" - while I
understand the intuition behind that, I wonder if this is relevant in
practice (especially, somebody committing changes without testing them,
especially, under KVM). As long as the false negatives here don't hurt,
I guess this change is fine.

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


-- 

Thanks,

David / dhildenb
