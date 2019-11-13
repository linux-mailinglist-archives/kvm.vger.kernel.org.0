Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD8AFB1B1
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 14:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbfKMNtV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 08:49:21 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42120 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfKMNtV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 08:49:21 -0500
Received: by mail-wr1-f67.google.com with SMTP id a15so2432156wrf.9
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 05:49:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=MlZP0CPfy3HRfaEKjw6fsnzHX1s+V5SyG2dfVqslH7Y=;
        b=W6hpnohoBReXNHmNmTCwzJJvlmGEefGZWQJ8Yzx1UpRfuLl53zs8XmCXXELycwt5nu
         iQ1eL3nG6XIHtf04fKrnYjUqoOCf7Hi1SbyprVmgTyX/K3Ycz3pjAPxBRktiJ8D9Fhnk
         Nh/5YqPeIJx6Wv3mChqA289Sreiyks//fPouwGGmk1lbOG4HXSwXOnbiOD2+RQ7q6eDo
         2prQZpFU5ZB4A8RvrDlkKUpWvt7MTMTG+DMmXGYBFsdKFVHK3KK7sjk9cfVMxsg6Sodp
         Tuo60XcQVLUMgw/STHAbtBMHVF3xONz8lxpvMwdWTWEkgWlQNhLhNJbT51Dfr03zazE6
         LnFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
        bh=MlZP0CPfy3HRfaEKjw6fsnzHX1s+V5SyG2dfVqslH7Y=;
        b=iQQS9DEODVld7gmvpHYfTT/xjNM1lz175Kl2r4jPFRrltQpsRWN2AhpeVxLUKj+B8K
         Go8FeXbkExcZcipso/pfUZP+WR6lzNtXEyfy56pc9zqp/sX1HU5wge4+R44guJt3hU36
         SbGQyHAhfdIt5k/A3kBH/NQWDwqiVWcyvPXNYUBTIJgcOzAoGzNSaqZFuulnnyW9Qvkr
         WBRLhHJnjI81FN0/OSS68mKiBvjmMcVZU2tpjjVpH3/B47DBuzLfvp6Kr98fKAdWeClD
         breK72J38RknGywj7IOrY56dBweEREo/F6K8G426S9M01oihLoOnh0VtEBENmWSFVuTO
         VIhw==
X-Gm-Message-State: APjAAAXgG9uENtQMBylTirCEAygwQJuThoSJvzoViMEw49kTSvTK/YVb
        UjnCshkEMOvLAlaufSGfcIKtnu2TJE0=
X-Google-Smtp-Source: APXvYqzWRZAY6Yjq9Wh90+uH/+HWZS7IssKG3+1MGUnd6bocabqnHeGWx7GHJpmgz39HCgqk+6qhxA==
X-Received: by 2002:a5d:6390:: with SMTP id p16mr2765200wru.55.1573652959234;
        Wed, 13 Nov 2019 05:49:19 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id h16sm2683718wrs.48.2019.11.13.05.49.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 05:49:17 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 44D551FF87;
        Wed, 13 Nov 2019 13:49:17 +0000 (GMT)
References: <20191113112649.14322-1-thuth@redhat.com>
 <20191113112649.14322-4-thuth@redhat.com>
User-agent: mu4e 1.3.5; emacs 27.0.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [kvm-unit-test PATCH 3/5] travis.yml: Test with KVM instead of
 TCG (on x86)
In-reply-to: <20191113112649.14322-4-thuth@redhat.com>
Date:   Wed, 13 Nov 2019 13:49:17 +0000
Message-ID: <87sgmr7uoy.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Thomas Huth <thuth@redhat.com> writes:

> Travis nowadays supports KVM in their CI pipelines, so we can finally
> run the kvm-unit-tests with KVM instead of TCG here. Unfortunately, there
> are some quirks: First, the QEMU binary has to be running as root, otherw=
ise
> you get an "permission denied" error here - even if you fix up the access
> permissions to /dev/kvm first.

Could it be another resource it's trying to access?

> Second, not all x86 tests are working in
> this environment, so we still have to manually select the test set here
> (but the amount of tests is definitely higher now than what we were able
> to run with TCG before).
>
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  .travis.yml | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/.travis.yml b/.travis.yml
> index 3f5b5ee..f91118c 100644
> --- a/.travis.yml
> +++ b/.travis.yml
> @@ -1,4 +1,4 @@
> -sudo: false
> +sudo: true
>  dist: bionic
>  language: c
>  cache: ccache
> @@ -13,16 +13,21 @@ matrix:
>        env:
>        - CONFIG=3D""
>        - BUILD_DIR=3D"."
> -      - TESTS=3D"vmexit_cpuid vmexit_mov_from_cr8 vmexit_mov_to_cr8 vmex=
it_ipi
> -             vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadlin=
e_immed"
> +      - TESTS=3D"access asyncpf debug emulator ept hypercall hyperv_stim=
er
> +               hyperv_synic idt_test intel_iommu ioapic ioapic-split
> +               kvmclock_test msr pcid rdpru realmode rmap_chain s3 umip"
> +      - ACCEL=3D"kvm"
>
>      - addons:
>          apt_packages: gcc qemu-system-x86
>        env:
>        - CONFIG=3D""
>        - BUILD_DIR=3D"x86-builddir"
> -      - TESTS=3D"ioapic-split ioapic smptest smptest3 eventinj msr port8=
0 syscall
> -             tsc rmap_chain umip intel_iommu vmexit_inl_pmtimer vmexit_i=
pi_halt"
> +      - TESTS=3D"smptest smptest3 tsc tsc_adjust xsave vmexit_cpuid vmex=
it_vmcall
> +               sieve vmexit_inl_pmtimer vmexit_ipi_halt vmexit_mov_from_=
cr8
> +               vmexit_mov_to_cr8 vmexit_ple_round_robin vmexit_tscdeadli=
ne
> +               vmexit_tscdeadline_immed  vmx_apic_passthrough_thread sys=
call"
> +      - ACCEL=3D"kvm"
>
>      - addons:
>          apt_packages: gcc-arm-linux-gnueabihf qemu-system-arm
> @@ -85,6 +90,9 @@ matrix:
>        - ACCEL=3D"tcg,firmware=3Ds390x/run"
>
>  before_script:
> +  - if [ "$ACCEL" =3D "kvm" ]; then
> +      sudo chmod u+s /usr/bin/qemu-system-* ;
> +    fi
>    - mkdir -p $BUILD_DIR && cd $BUILD_DIR
>    - if [ -e ./configure ]; then ./configure $CONFIG ; fi
>    - if [ -e ../configure ]; then ../configure $CONFIG ; fi


--
Alex Benn=C3=A9e
