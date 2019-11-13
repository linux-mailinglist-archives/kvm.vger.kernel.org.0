Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3875EFB327
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 16:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbfKMPFJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 10:05:09 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36795 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727772AbfKMPFJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 10:05:09 -0500
Received: by mail-wr1-f66.google.com with SMTP id r10so2769838wrx.3
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 07:05:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=NO3PNf3g/VPZKnpNUzJ2AMM3C/6+AK3GwKL2m/b6hEE=;
        b=jhnVGq3AK/T/xNYoLRdAfB6+wrZ0tZXF03guXoGYJTT5WeT0bkcxt1TD5DMF7qKVvR
         dvtpPBMwCYTYZ0fQMQ1oa5NgnJ1aeuM8hR7wvVuTnQ8YUgV93sNpdqtpraZJyGWHjdTz
         BEuGsFSq7BuswZJutOoi15Xd31r4XqoyWxIHs/jQihUzzap+9+25ZBLj1OmBOsaVg4Or
         y03FbHnVo/jAtDOpBf1Sg22kOpwktdUvVrHPjwL3hF/Tm4TxL5l1SI/7ZLGIacIGh7ZL
         Xq6v/PhcXlqKIXVtZ8vyhK/+JICuzcOMAfPa83AzDSZwb447IQhBpGhXfA7Mf5Kn7JkJ
         RFGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
        bh=NO3PNf3g/VPZKnpNUzJ2AMM3C/6+AK3GwKL2m/b6hEE=;
        b=mn2awbNGv4Ps51prh9qwWaUiDGkNWdjwopfudXUpR7bzmdGT+8k8rId/sQtuISN/f1
         ydsoYOx4MY30bL8MP5SvDhwW2O/hJZ/TRRDznVjwVax9ck2XD4gsYoelc57nTA1ektEU
         q4wf4uFduzPPmFmD7b0GYx04wm3c+eWrb+dRZOLWuMXpjWsi+RxRG8KaoGGu0TseLAFX
         dU5YNy3Q4b+l7ERguIKTaR8CCeAr/g6X4MwFYkH8Xc0LJeFXnLGXj0mFlGlqYUMqBBe+
         27gxs+8trCZ+T2JuQDKk3NRL/DUL9iKbWFn5XRwpCy9kYPQ0k1OlAfA7n+jf2FiuAMcQ
         ZirQ==
X-Gm-Message-State: APjAAAXUA6+H5FmgD0sSyzlroqNL7SoqdeiQJcwyLwEQSw/zsO+Tj4G6
        JinrlTUJ2qCTM0jjpYMJjdWezg==
X-Google-Smtp-Source: APXvYqyK40K1rCdWnZoaPtWCPpDDydEJPaeRa1MReXK3lpia4oW3TqAT3DNDqnWwNWWoLeSfth8UtA==
X-Received: by 2002:adf:db41:: with SMTP id f1mr3112843wrj.351.1573657507017;
        Wed, 13 Nov 2019 07:05:07 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id w10sm2503483wmd.26.2019.11.13.07.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 07:05:05 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id B533D1FF87;
        Wed, 13 Nov 2019 15:05:04 +0000 (GMT)
References: <20191113112649.14322-1-thuth@redhat.com>
 <20191113112649.14322-5-thuth@redhat.com>
User-agent: mu4e 1.3.5; emacs 27.0.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [kvm-unit-test PATCH 4/5] travis.yml: Test the i386 build, too
In-reply-to: <20191113112649.14322-5-thuth@redhat.com>
Date:   Wed, 13 Nov 2019 15:05:04 +0000
Message-ID: <87pnhv7r6n.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Thomas Huth <thuth@redhat.com> writes:

> After installing gcc-multilib, we can also test the 32-bit builds
> on Travis.
>
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

> ---
>  .travis.yml | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/.travis.yml b/.travis.yml
> index f91118c..9ceb04d 100644
> --- a/.travis.yml
> +++ b/.travis.yml
> @@ -29,6 +29,21 @@ matrix:
>                 vmexit_tscdeadline_immed  vmx_apic_passthrough_thread sys=
call"
>        - ACCEL=3D"kvm"
>
> +    - addons:
> +        apt_packages: gcc gcc-multilib qemu-system-x86
> +      env:
> +      - CONFIG=3D"--arch=3Di386"
> +      - BUILD_DIR=3D"."
> +      - TESTS=3D"eventinj port80 sieve tsc taskswitch umip vmexit_ple_ro=
und_robin"
> +
> +    - addons:
> +        apt_packages: gcc gcc-multilib qemu-system-x86
> +      env:
> +      - CONFIG=3D"--arch=3Di386"
> +      - BUILD_DIR=3D"i386-builddir"
> +      - TESTS=3D"vmexit_mov_from_cr8 vmexit_ipi vmexit_ipi_halt vmexit_m=
ov_to_cr8
> +               vmexit_cpuid vmexit_tscdeadline vmexit_tscdeadline_immed"
> +
>      - addons:
>          apt_packages: gcc-arm-linux-gnueabihf qemu-system-arm
>        env:


--
Alex Benn=C3=A9e
