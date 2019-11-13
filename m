Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE99CFB0E2
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 13:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfKMMyp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 07:54:45 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50203 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbfKMMyp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 07:54:45 -0500
Received: by mail-wm1-f68.google.com with SMTP id l17so1886428wmh.0
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 04:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=TkP19HWUR7dthHcTKkKVBtwALFprjS/6El2DJ/O35Oo=;
        b=eIoiEVqeRbpCRWsSd6Gc+elrXY8lxL/0u7lPad0B3jy/7e1xX1Ir6WFPirN/ABqSzX
         /ixqNWcaTkWlShs9pRcwCW08yOdZQwubqY8QAhoW97Gzq6eJ+V3nuDTuQNOBRYKZr6Bc
         JXF7wN7vjNaZ8A4L+bkCz4leQHpPdIZ/4Bu0cbVtxGyJV2j08H+s0RC3DFnmn2QQOx5v
         3ESFJUVBfo45k6a61ykGabfQo7ffINI8eGizOFfzHLTuNx5uVRj9O0R42kseed1/UJnF
         x1AJlivdRgjlaw2Tsu9ZZUtQimvC/at1DxCl4ud1+VVawHhhypzUtSGSNV5QkDrcuBZG
         DIkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
        bh=TkP19HWUR7dthHcTKkKVBtwALFprjS/6El2DJ/O35Oo=;
        b=kKx58NplWfZhNKybt7S78ey1sYuObVNYor2eciFLjplG9M6un3OXAaCKOTTesvNfG1
         3fDP4rTdRKJ4Xk0gi7QLY8bDf4ko9Eu58yRkc89jxLS5bWYqeHZzfdGDHeXChq/ig8Pw
         feVNhkkOimld/itR2f7h88vYfJBkCGHgfD3PLTerWmhZrPEA4SUYh1USgKbFXsn2KikU
         JO6mXyW4raHtEPPRgBl/pgKwnXelJaRcbOmkIZ/N9/IHWScXWX62YZQ+GSwbf4D9BQV1
         bx5HoyRdh24NrXrFN5OODTgZjyqbkmBlIS6nFLugHD2Pit2QcKbdc/nGAsOObsn6S+Hh
         dPlA==
X-Gm-Message-State: APjAAAUk9L4RvDFXcPL/JDi42tt1hde3bcw4P4GztWEWttntxuhP4wep
        mUkm846VuQPmcmVV6eagUvQ4+Q==
X-Google-Smtp-Source: APXvYqzX8+2+R3rHI6/jlI6kl14b66DJj2nzGZSFC04DNkO8Ioe0INkGLBFpPBZ0+efgYLAWIiMsdQ==
X-Received: by 2002:a1c:6542:: with SMTP id z63mr2723410wmb.29.1573649680144;
        Wed, 13 Nov 2019 04:54:40 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id y17sm2882875wrs.58.2019.11.13.04.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 04:54:39 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 9D4D61FF87;
        Wed, 13 Nov 2019 12:54:38 +0000 (GMT)
References: <20191113112649.14322-1-thuth@redhat.com>
 <20191113112649.14322-3-thuth@redhat.com>
User-agent: mu4e 1.3.5; emacs 27.0.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [kvm-unit-test PATCH 2/5] travis.yml: Install only the required
 packages for each entry in the matrix
In-reply-to: <20191113112649.14322-3-thuth@redhat.com>
Date:   Wed, 13 Nov 2019 12:54:38 +0000
Message-ID: <87v9ro6inl.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Thomas Huth <thuth@redhat.com> writes:

> We don't need all cross compiler and QEMU versions for each and every ent=
ry
> in the test matrix, only the ones for the current target architecture.
> So let's speed up the installation process a little bit by only installing
> the packages that we really need.
>
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

> ---
>  .travis.yml | 53 +++++++++++++++++++++++++++++++----------------------
>  1 file changed, 31 insertions(+), 22 deletions(-)
>
> diff --git a/.travis.yml b/.travis.yml
> index 611bbdc..3f5b5ee 100644
> --- a/.travis.yml
> +++ b/.travis.yml
> @@ -1,75 +1,84 @@
>  sudo: false
>  dist: bionic
>  language: c
> -compiler:
> -  - gcc
>  cache: ccache
> -addons:
> -  apt:
> -    packages:
> -      # Cross Toolchains
> -      - gcc-arm-linux-gnueabihf
> -      - gcc-aarch64-linux-gnu
> -      - gcc-powerpc64le-linux-gnu
> -      - gcc-s390x-linux-gnu
> -      # Run dependencies
> -      - qemu-system
>  git:
>    submodules: false
>
>  matrix:
>    include:
> -    - env:
> +
> +    - addons:
> +        apt_packages: gcc qemu-system-x86
> +      env:
>        - CONFIG=3D""
>        - BUILD_DIR=3D"."
>        - TESTS=3D"vmexit_cpuid vmexit_mov_from_cr8 vmexit_mov_to_cr8 vmex=
it_ipi
>               vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadlin=
e_immed"
>
> -    - env:
> +    - addons:
> +        apt_packages: gcc qemu-system-x86
> +      env:
>        - CONFIG=3D""
>        - BUILD_DIR=3D"x86-builddir"
>        - TESTS=3D"ioapic-split ioapic smptest smptest3 eventinj msr port8=
0 syscall
>               tsc rmap_chain umip intel_iommu vmexit_inl_pmtimer vmexit_i=
pi_halt"
>
> -    - env:
> +    - addons:
> +        apt_packages: gcc-arm-linux-gnueabihf qemu-system-arm
> +      env:
>        - CONFIG=3D"--arch=3Darm --cross-prefix=3Darm-linux-gnueabihf-"
>        - BUILD_DIR=3D"."
>        - TESTS=3D"selftest-vectors-kernel selftest-vectors-user selftest-=
smp"
>
> -    - env:
> +    - addons:
> +        apt_packages: gcc-arm-linux-gnueabihf qemu-system-arm
> +      env:
>        - CONFIG=3D"--arch=3Darm --cross-prefix=3Darm-linux-gnueabihf-"
>        - BUILD_DIR=3D"arm-buildir"
>        - TESTS=3D"pci-test pmu gicv2-active gicv3-active psci selftest-se=
tup"
>
> -    - env:
> +    - addons:
> +        apt_packages: gcc-aarch64-linux-gnu qemu-system-aarch64
> +      env:
>        - CONFIG=3D"--arch=3Darm64 --cross-prefix=3Daarch64-linux-gnu-"
>        - BUILD_DIR=3D"."
>        - TESTS=3D"selftest-vectors-kernel selftest-vectors-user selftest-=
smp"
>
> -    - env:
> +    - addons:
> +        apt_packages: gcc-aarch64-linux-gnu qemu-system-aarch64
> +      env:
>        - CONFIG=3D"--arch=3Darm64 --cross-prefix=3Daarch64-linux-gnu-"
>        - BUILD_DIR=3D"arm64-buildir"
>        - TESTS=3D"pci-test pmu gicv2-active gicv3-active psci timer selft=
est-setup"
>
> -    - env:
> +    - addons:
> +        apt_packages: gcc-powerpc64le-linux-gnu qemu-system-ppc
> +      env:
>        - CONFIG=3D"--arch=3Dppc64 --endian=3Dlittle --cross-prefix=3Dpowe=
rpc64le-linux-gnu-"
>        - BUILD_DIR=3D"."
>        - TESTS=3D"spapr_hcall emulator rtas-set-time-of-day"
>        - ACCEL=3D"tcg,cap-htm=3Doff"
>
> -    - env:
> +    - addons:
> +        apt_packages: gcc-powerpc64le-linux-gnu qemu-system-ppc
> +      env:
>        - CONFIG=3D"--arch=3Dppc64 --endian=3Dlittle --cross-prefix=3Dpowe=
rpc64le-linux-gnu-"
>        - BUILD_DIR=3D"ppc64le-buildir"
>        - TESTS=3D"rtas-get-time-of-day rtas-get-time-of-day-base"
>        - ACCEL=3D"tcg,cap-htm=3Doff"
>
> -    - env:
> +    - addons:
> +        apt_packages: gcc-s390x-linux-gnu qemu-system-s390x
> +      env:
>        - CONFIG=3D"--arch=3Ds390x --cross-prefix=3Ds390x-linux-gnu-"
>        - BUILD_DIR=3D"."
>        - TESTS=3D"diag10 diag308"
>        - ACCEL=3D"tcg,firmware=3Ds390x/run"
>
> -    - env:
> +    - addons:
> +        apt_packages: gcc-s390x-linux-gnu qemu-system-s390x
> +      env:
>        - CONFIG=3D"--arch=3Ds390x --cross-prefix=3Ds390x-linux-gnu-"
>        - BUILD_DIR=3D"s390x-builddir"
>        - TESTS=3D"sieve"


--
Alex Benn=C3=A9e
