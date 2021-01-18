Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946E92FA865
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 19:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407333AbhARR5x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 12:57:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22388 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436815AbhARR4y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 12:56:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610992525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pGFVMLMPVyi6550JoWRccTXRgAGtqoGfbghrTRcS6SA=;
        b=Hugbvc2KFN7I8HJdojj8BVG94B7f1zlCIeAztYoTMCPyD1BONFz5ZFoRCaX6vFYyb+6VOq
        bg184DTq3tjVPIjBSGYuGq+CVysE6DmFYG9k8fshICbs0HSgvFRpBLQ9NLCm0XQzxC1s4u
        Ld6fPcq0uR4GZpR3hSqy3qDhg5X3Y98=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-mF9vhg05PGS9kRRDEmU4wg-1; Mon, 18 Jan 2021 12:55:23 -0500
X-MC-Unique: mF9vhg05PGS9kRRDEmU4wg-1
Received: by mail-ej1-f69.google.com with SMTP id z2so1047221ejf.3
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 09:55:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pGFVMLMPVyi6550JoWRccTXRgAGtqoGfbghrTRcS6SA=;
        b=jUEYhGUwiOhgLcDE+3Z3ajZTdF5qrml5YO30qczMkOweCzzAmFmCbammxalBSeUhOa
         fcUNNZdL4TJUUctesLG+lTE4D2sYp5TM1kLW9DMfnUYLno5KZsKeqEYkfUg5XNqN74jU
         puuCOPDfUIhQ8vD5adJHFiR1n1IU2i0lzZEBH01mTiAmiT3h54R+b1/sBmKaDckgg5oE
         jk6uJgzldc1ZrIEgFr1ogYTMZq329I6D6FRYoYS40GWn/BYJBUJAozRO4mgAorXk6MAg
         Vnd4ZqE9NeWy7wdfbtEpPhccOANM9WJZRjkCuN+zxPfpRbXocwJgqP/9VYenijVYmZBK
         VIIA==
X-Gm-Message-State: AOAM532VQwHFrPjIC3d8hUIX92Ob4ugafsro8V38gFJMwFLYJB/25Ajc
        yw+9fYZy0CKA7h1l4DSeMJVi5MhLZfx+kmDxRhfm5vO65K4jnL3yN9KIVe8cmbxMrQvOmEHIQ3D
        ZyjdliIgpF8FeUSAr4JKbGZ1UiabOO9ufMqwAF+PivcWIuT5KK681cbAaLgWDRkUk
X-Received: by 2002:a17:906:478a:: with SMTP id cw10mr514577ejc.533.1610992521510;
        Mon, 18 Jan 2021 09:55:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyacG26XFoZjuMt4H+J5Bsxc2sTU8YRNJdY4ntJy7qaNvvSn9eAeFrfdqCASvlBDkOKG0D6kA==
X-Received: by 2002:a17:906:478a:: with SMTP id cw10mr514565ejc.533.1610992521201;
        Mon, 18 Jan 2021 09:55:21 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f5sm9707135ejz.70.2021.01.18.09.55.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 09:55:20 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH] gitlab-ci.yml: Run test with KVM and macOS
 via cirrus-run
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
References: <20210115223017.271339-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <11b41984-ed6b-e5bd-f4ba-52d5c6be847b@redhat.com>
Date:   Mon, 18 Jan 2021 18:55:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210115223017.271339-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/01/21 23:30, Thomas Huth wrote:
> Since Travis changed their policy, we soon cannot use it for the
> kvm-unit-tests anymore, thus we lose the CI testing with KVM enabled
> and the compilation jobs on macOS. Fortunately there is an alternative:
> Cirrus-CI also provides containers with KVM enabled and CI jobs with
> macOS. Thanks to the so-call "cirrus-run" script, we can even start
> the jobs from the gitlab-CI, so we get all the test coverage in the
> gitlab-CI again. cirrus-run needs some configuration first, though.
> Please refer to the description from libvirt for the details how to
> set up your environment for these jobs:
> 
>   https://gitlab.com/libvirt/libvirt/-/blob/v7.0.0/ci/README.rst
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>   .gitlab-ci.yml                | 31 +++++++++++++++++
>   ci/cirrus-ci-fedora.yml       | 65 +++++++++++++++++++++++++++++++++++
>   ci/cirrus-ci-macos-i386.yml   | 36 +++++++++++++++++++
>   ci/cirrus-ci-macos-x86-64.yml | 41 ++++++++++++++++++++++
>   4 files changed, 173 insertions(+)
>   create mode 100644 ci/cirrus-ci-fedora.yml
>   create mode 100644 ci/cirrus-ci-macos-i386.yml
>   create mode 100644 ci/cirrus-ci-macos-x86-64.yml
> 
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index 6613c7b..8834e59 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -122,3 +122,34 @@ build-centos7:
>        setjmp sieve tsc rmap_chain umip
>        | tee results.txt
>    - grep -q PASS results.txt && ! grep -q FAIL results.txt
> +
> +# Cirrus-CI provides containers with macOS and Linux with KVM enabled,
> +# so we can test some scenarios there that are not possible with the
> +# gitlab-CI shared runners. We use the "cirrus-run" container from the
> +# libvirt project to start the jobs. See the following URL for more
> +# information how to set up your environment to use these containers:
> +#
> +#   https://gitlab.com/libvirt/libvirt/-/blob/v7.0.0/ci/README.rst
> +#
> +.cirrus_build_job_template: &cirrus_build_job_definition
> + image: registry.gitlab.com/libvirt/libvirt-ci/cirrus-run:master
> + before_script:
> +  - sed -e "s|[@]CI_REPOSITORY_URL@|$CI_REPOSITORY_URL|g"
> +        -e "s|[@]CI_COMMIT_REF_NAME@|$CI_COMMIT_REF_NAME|g"
> +        -e "s|[@]CI_COMMIT_SHA@|$CI_COMMIT_SHA|g"
> +        < ci/$CI_JOB_NAME.yml > ci/_$CI_JOB_NAME.yml
> + script:
> +  - cirrus-run -v --show-build-log always ci/_$CI_JOB_NAME.yml
> + only:
> +  variables:
> +   - $CIRRUS_GITHUB_REPO
> +   - $CIRRUS_API_TOKEN
> +
> +cirrus-ci-fedora:
> + <<: *cirrus_build_job_definition
> +
> +cirrus-ci-macos-i386:
> + <<: *cirrus_build_job_definition
> +
> +cirrus-ci-macos-x86-64:
> + <<: *cirrus_build_job_definition
> diff --git a/ci/cirrus-ci-fedora.yml b/ci/cirrus-ci-fedora.yml
> new file mode 100644
> index 0000000..aba6ae7
> --- /dev/null
> +++ b/ci/cirrus-ci-fedora.yml
> @@ -0,0 +1,65 @@
> +
> +fedora_task:
> +  container:
> +    image: fedora:latest
> +    cpu: 4
> +    memory: 4Gb
> +    kvm: true
> +  install_script:
> +    - dnf update -y
> +    - dnf install -y diffutils gcc git make qemu-system-x86
> +  clone_script:
> +    - git clone --depth 100 "@CI_REPOSITORY_URL@" .
> +    - git fetch origin "@CI_COMMIT_REF_NAME@"
> +    - git reset --hard "@CI_COMMIT_SHA@"
> +  script:
> +    - mkdir build
> +    - cd build
> +    - ../configure
> +    - make -j$(nproc)
> +    - ./run_tests.sh
> +        access
> +        asyncpf
> +        debug
> +        emulator
> +        ept
> +        hypercall
> +        hyperv_clock
> +        hyperv_connections
> +        hyperv_stimer
> +        hyperv_synic
> +        idt_test
> +        intel_iommu
> +        ioapic
> +        ioapic-split
> +        kvmclock_test
> +        msr
> +        pcid
> +        pcid-disabled
> +        rdpru
> +        realmode
> +        rmap_chain
> +        s3
> +        setjmp
> +        sieve
> +        smptest
> +        smptest3
> +        syscall
> +        tsc
> +        tsc_adjust
> +        tsx-ctrl
> +        umip
> +        vmexit_cpuid
> +        vmexit_inl_pmtimer
> +        vmexit_ipi
> +        vmexit_ipi_halt
> +        vmexit_mov_from_cr8
> +        vmexit_mov_to_cr8
> +        vmexit_ple_round_robin
> +        vmexit_tscdeadline
> +        vmexit_tscdeadline_immed
> +        vmexit_vmcall
> +        vmx_apic_passthrough_thread
> +        xsave
> +        | tee results.txt
> +    - grep -q PASS results.txt && ! grep -q FAIL results.txt
> diff --git a/ci/cirrus-ci-macos-i386.yml b/ci/cirrus-ci-macos-i386.yml
> new file mode 100644
> index 0000000..b837101
> --- /dev/null
> +++ b/ci/cirrus-ci-macos-i386.yml
> @@ -0,0 +1,36 @@
> +
> +macos_i386_task:
> +  osx_instance:
> +    image: catalina-base
> +  install_script:
> +    - brew install coreutils bash git gnu-getopt make qemu i686-elf-gcc
> +  clone_script:
> +    - git clone --depth 100 "@CI_REPOSITORY_URL@" .
> +    - git fetch origin "@CI_COMMIT_REF_NAME@"
> +    - git reset --hard "@CI_COMMIT_SHA@"
> +  script:
> +    - export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
> +    - mkdir build
> +    - cd build
> +    - ../configure --arch=i386 --cross-prefix=i686-elf-
> +    - gmake -j$(sysctl -n hw.ncpu)
> +    - ACCEL=tcg ./run_tests.sh
> +         cmpxchg8b
> +         eventinj
> +         realmode
> +         setjmp
> +         sieve
> +         taskswitch
> +         tsc
> +         umip
> +         vmexit_cpuid
> +         vmexit_inl_pmtimer
> +         vmexit_ipi
> +         vmexit_ipi_halt
> +         vmexit_mov_from_cr8
> +         vmexit_mov_to_cr8
> +         vmexit_ple_round_robin
> +         vmexit_tscdeadline
> +         vmexit_tscdeadline_immed
> +         | tee results.txt
> +    - grep -q PASS results.txt && ! grep -q FAIL results.txt
> diff --git a/ci/cirrus-ci-macos-x86-64.yml b/ci/cirrus-ci-macos-x86-64.yml
> new file mode 100644
> index 0000000..00cc1a2
> --- /dev/null
> +++ b/ci/cirrus-ci-macos-x86-64.yml
> @@ -0,0 +1,41 @@
> +
> +macos_task:
> +  osx_instance:
> +    image: catalina-base
> +  install_script:
> +    - brew install coreutils bash git gnu-getopt make qemu x86_64-elf-gcc
> +  clone_script:
> +    - git clone --depth 100 "@CI_REPOSITORY_URL@" .
> +    - git fetch origin "@CI_COMMIT_REF_NAME@"
> +    - git reset --hard "@CI_COMMIT_SHA@"
> +  script:
> +    - export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
> +    - mkdir build
> +    - cd build
> +    - ../configure --cross-prefix=x86_64-elf-
> +    - gmake -j$(sysctl -n hw.ncpu)
> +    - ACCEL=tcg ./run_tests.sh
> +         eventinj
> +         intel_iommu
> +         ioapic-split
> +         msr
> +         realmode
> +         rmap_chain
> +         setjmp
> +         sieve
> +         smptest
> +         smptest3
> +         syscall
> +         tsc
> +         umip
> +         vmexit_cpuid
> +         vmexit_inl_pmtimer
> +         vmexit_ipi
> +         vmexit_ipi_halt
> +         vmexit_mov_from_cr8
> +         vmexit_mov_to_cr8
> +         vmexit_ple_round_robin
> +         vmexit_tscdeadline
> +         vmexit_tscdeadline_immed
> +         | tee results.txt
> +    - grep -q PASS results.txt && ! grep -q FAIL results.txt
> 

Queued, thanks.

Paolo

