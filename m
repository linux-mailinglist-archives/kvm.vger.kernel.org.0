Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE652FB0E0
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 13:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfKMMyG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 07:54:06 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37466 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfKMMyG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 07:54:06 -0500
Received: by mail-wr1-f67.google.com with SMTP id t1so2246873wrv.4
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 04:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=K2kNRxQF6XtlwZO8O5NcPFFHmYLEKhkaER7G/5ZIkI8=;
        b=KMAmw2J1m6B+CoV/TMcmOtDjS2fbQ/w73TKjv+lGM1vBitxy3dDwj614BFJYMNKD6o
         gSpcQE9cUmjkTJ7bTiTOgfEjsAl/b7fl0hA3+iAiC/zi6e7GqXAmsluXFN6OYUXljLTg
         6IyPPftl9vbbtk7NS9BISkteYFdMIYQFoozmvGGpN6SYEJBh1OWRrwpL+AYB42u0wOMZ
         jjgCLVcV2RBpqoJvlMjz586CbOEjtWjxSSR6gcT9JqlFvNRwGupAjijxEzZWF0sXbuhV
         /JRfKsCAfkJr/zVXg3RoZnu7zMGRMcSAw/+rnunwQjceII+YYbka7vn18dLepsCeRoeR
         RZng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
        bh=K2kNRxQF6XtlwZO8O5NcPFFHmYLEKhkaER7G/5ZIkI8=;
        b=jH051gmvvm2L4CDfRO4IquTH/7QHWvB8xjubGoYHksVXPdAXtTIGl0KxBRk7IeqfOR
         VV9HyV6PzCO0/RPxRds3uhhV9lJz1hQs5d7hy6hFUDb8oot13gUBfLphgqxErrVBvWd+
         SgL0DA9vTsgmLuDx2wA9aR+rOiI+dCdOdDd9B+jU2zj0OB2TcyOQvcCQsc/7ebZ5xuJX
         IY8sK0/VXlcq+Dmmyb4eTMMwodtRAjFrsfTgIud+TcTUNRZNDffrcmLLmakWcByEFIOu
         SXT2WiFOhEAW8cYC4zTvUcbIhRkUHW8asv0S6IZPFVMqkmSXy2vtQbneUbWubOKv8eeK
         SuOw==
X-Gm-Message-State: APjAAAWPRdgWwsA2ZF43ek9hOpJr9M+3m+vO+55prh9AISYcqEro+K+y
        tbSsQ+KdpfnUE7pKGHJnNQSm+w==
X-Google-Smtp-Source: APXvYqzEz2gspxWTdWGgXXe9Q80df5VoVs8wvaw5Z/uQhBhWhwTaJcvcIlfXmyrGBOh2I8ICYlqKvQ==
X-Received: by 2002:adf:f150:: with SMTP id y16mr2615355wro.192.1573649642968;
        Wed, 13 Nov 2019 04:54:02 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id w13sm2706268wrm.8.2019.11.13.04.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 04:54:01 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 52A931FF87;
        Wed, 13 Nov 2019 12:54:01 +0000 (GMT)
References: <20191113112649.14322-1-thuth@redhat.com>
 <20191113112649.14322-2-thuth@redhat.com>
User-agent: mu4e 1.3.5; emacs 27.0.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [kvm-unit-test PATCH 1/5] travis.yml: Re-arrange the test matrix
In-reply-to: <20191113112649.14322-2-thuth@redhat.com>
Date:   Wed, 13 Nov 2019 12:54:01 +0000
Message-ID: <87y2wk6iom.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Thomas Huth <thuth@redhat.com> writes:

> We will soon need more control over the individual test matrix
> entries, so we should not limit the matrix to "env" sections,
> i.e. put the "matrix:" keyword on the top, not the "env:".
>
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

> ---
>  .travis.yml | 92 ++++++++++++++++++++++++++++++++---------------------
>  1 file changed, 56 insertions(+), 36 deletions(-)
>
> diff --git a/.travis.yml b/.travis.yml
> index 6c14953..611bbdc 100644
> --- a/.travis.yml
> +++ b/.travis.yml
> @@ -16,44 +16,64 @@ addons:
>        - qemu-system
>  git:
>    submodules: false
> -env:
> -  matrix:
> -    - CONFIG=3D""
> -      BUILD_DIR=3D"."
> -      TESTS=3D"vmexit_cpuid vmexit_mov_from_cr8 vmexit_mov_to_cr8 vmexit=
_ipi
> +
> +matrix:
> +  include:
> +    - env:
> +      - CONFIG=3D""
> +      - BUILD_DIR=3D"."
> +      - TESTS=3D"vmexit_cpuid vmexit_mov_from_cr8 vmexit_mov_to_cr8 vmex=
it_ipi
>               vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadlin=
e_immed"
> -    - CONFIG=3D""
> -      BUILD_DIR=3D"x86-builddir"
> -      TESTS=3D"ioapic-split ioapic smptest smptest3 eventinj msr port80 =
syscall
> +
> +    - env:
> +      - CONFIG=3D""
> +      - BUILD_DIR=3D"x86-builddir"
> +      - TESTS=3D"ioapic-split ioapic smptest smptest3 eventinj msr port8=
0 syscall
>               tsc rmap_chain umip intel_iommu vmexit_inl_pmtimer vmexit_i=
pi_halt"
> -    - CONFIG=3D"--arch=3Darm --cross-prefix=3Darm-linux-gnueabihf-"
> -      BUILD_DIR=3D"."
> -      TESTS=3D"selftest-vectors-kernel selftest-vectors-user selftest-sm=
p"
> -    - CONFIG=3D"--arch=3Darm --cross-prefix=3Darm-linux-gnueabihf-"
> -      BUILD_DIR=3D"arm-buildir"
> -      TESTS=3D"pci-test pmu gicv2-active gicv3-active psci selftest-setu=
p"
> -    - CONFIG=3D"--arch=3Darm64 --cross-prefix=3Daarch64-linux-gnu-"
> -      BUILD_DIR=3D"."
> -      TESTS=3D"selftest-vectors-kernel selftest-vectors-user selftest-sm=
p"
> -    - CONFIG=3D"--arch=3Darm64 --cross-prefix=3Daarch64-linux-gnu-"
> -      BUILD_DIR=3D"arm64-buildir"
> -      TESTS=3D"pci-test pmu gicv2-active gicv3-active psci timer selftes=
t-setup"
> -    - CONFIG=3D"--arch=3Dppc64 --endian=3Dlittle --cross-prefix=3Dpowerp=
c64le-linux-gnu-"
> -      BUILD_DIR=3D"."
> -      TESTS=3D"spapr_hcall emulator rtas-set-time-of-day"
> -      ACCEL=3D"tcg,cap-htm=3Doff"
> -    - CONFIG=3D"--arch=3Dppc64 --endian=3Dlittle --cross-prefix=3Dpowerp=
c64le-linux-gnu-"
> -      BUILD_DIR=3D"ppc64le-buildir"
> -      TESTS=3D"rtas-get-time-of-day rtas-get-time-of-day-base"
> -      ACCEL=3D"tcg,cap-htm=3Doff"
> -    - CONFIG=3D"--arch=3Ds390x --cross-prefix=3Ds390x-linux-gnu-"
> -      BUILD_DIR=3D"."
> -      TESTS=3D"diag10 diag308"
> -      ACCEL=3D"tcg,firmware=3Ds390x/run"
> -    - CONFIG=3D"--arch=3Ds390x --cross-prefix=3Ds390x-linux-gnu-"
> -      BUILD_DIR=3D"s390x-builddir"
> -      TESTS=3D"sieve"
> -      ACCEL=3D"tcg,firmware=3Ds390x/run"
> +
> +    - env:
> +      - CONFIG=3D"--arch=3Darm --cross-prefix=3Darm-linux-gnueabihf-"
> +      - BUILD_DIR=3D"."
> +      - TESTS=3D"selftest-vectors-kernel selftest-vectors-user selftest-=
smp"
> +
> +    - env:
> +      - CONFIG=3D"--arch=3Darm --cross-prefix=3Darm-linux-gnueabihf-"
> +      - BUILD_DIR=3D"arm-buildir"
> +      - TESTS=3D"pci-test pmu gicv2-active gicv3-active psci selftest-se=
tup"
> +
> +    - env:
> +      - CONFIG=3D"--arch=3Darm64 --cross-prefix=3Daarch64-linux-gnu-"
> +      - BUILD_DIR=3D"."
> +      - TESTS=3D"selftest-vectors-kernel selftest-vectors-user selftest-=
smp"
> +
> +    - env:
> +      - CONFIG=3D"--arch=3Darm64 --cross-prefix=3Daarch64-linux-gnu-"
> +      - BUILD_DIR=3D"arm64-buildir"
> +      - TESTS=3D"pci-test pmu gicv2-active gicv3-active psci timer selft=
est-setup"
> +
> +    - env:
> +      - CONFIG=3D"--arch=3Dppc64 --endian=3Dlittle --cross-prefix=3Dpowe=
rpc64le-linux-gnu-"
> +      - BUILD_DIR=3D"."
> +      - TESTS=3D"spapr_hcall emulator rtas-set-time-of-day"
> +      - ACCEL=3D"tcg,cap-htm=3Doff"
> +
> +    - env:
> +      - CONFIG=3D"--arch=3Dppc64 --endian=3Dlittle --cross-prefix=3Dpowe=
rpc64le-linux-gnu-"
> +      - BUILD_DIR=3D"ppc64le-buildir"
> +      - TESTS=3D"rtas-get-time-of-day rtas-get-time-of-day-base"
> +      - ACCEL=3D"tcg,cap-htm=3Doff"
> +
> +    - env:
> +      - CONFIG=3D"--arch=3Ds390x --cross-prefix=3Ds390x-linux-gnu-"
> +      - BUILD_DIR=3D"."
> +      - TESTS=3D"diag10 diag308"
> +      - ACCEL=3D"tcg,firmware=3Ds390x/run"
> +
> +    - env:
> +      - CONFIG=3D"--arch=3Ds390x --cross-prefix=3Ds390x-linux-gnu-"
> +      - BUILD_DIR=3D"s390x-builddir"
> +      - TESTS=3D"sieve"
> +      - ACCEL=3D"tcg,firmware=3Ds390x/run"
>
>  before_script:
>    - mkdir -p $BUILD_DIR && cd $BUILD_DIR


--
Alex Benn=C3=A9e
