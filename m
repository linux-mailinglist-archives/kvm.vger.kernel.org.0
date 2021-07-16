Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA073CB70F
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 13:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbhGPL7h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 07:59:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39016 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232088AbhGPL7d (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 16 Jul 2021 07:59:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626436598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BBXhtuB22eGeE8WglXjCn7wXxTPArvZNBgiifMvrjqQ=;
        b=Zm7JfIr0OE/CpzrucfiS/kej1gpD262kHAR+MfIFnusMSHns7FSgLOAHXkXmXg1RDgza1I
        xt/VvwKTuemrG7RZ+/Vv3tYZuMmyGBcbISj0mB8O0/h8cZd6YL1PMa///7YHK5ohbDQH4g
        bhg6NQ5vd2M4R4VdIWpExVCUUegJUII=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-53-G9-SeDW3Nz2y1aUYnb3v3g-1; Fri, 16 Jul 2021 07:56:36 -0400
X-MC-Unique: G9-SeDW3Nz2y1aUYnb3v3g-1
Received: by mail-wr1-f70.google.com with SMTP id o10-20020a05600002cab02901426384855aso2239185wry.11
        for <kvm@vger.kernel.org>; Fri, 16 Jul 2021 04:56:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BBXhtuB22eGeE8WglXjCn7wXxTPArvZNBgiifMvrjqQ=;
        b=S3+t+FN34e79OYxUKs1z9zHQ7lMKvYdK4k5dhqGTVi0rsjD6X/WMn2JlsNvu1x3bZf
         LXYETuMHkULnCXsLZvLFH5pYv9LSjIzekPlRCoShX/7qZ7rqTZZpmMKGdbixpwRajSwx
         1AukJtHNml3kpHT+gYhuLL7+R72lKT0jhcbZzHIlFjORLJncih27VSwMRO86vYjkz0B2
         aBYfJr1dJlI0Obj+0xCazNFK3mXcUfsOTjseb26vvE/RP8tydga3mEkGeh9o8MpW3qGk
         hqHIT4tehfRkzlFDeGXcmW3phsylOoc3iEm1UAC4UfMShcv2lKn8hH4gpoIZ7WGkAgB2
         QtRg==
X-Gm-Message-State: AOAM533jo+E+KTbmgrLHBBGex1SlkUvlmB+pfQEdiHeD95a17KinOvuQ
        1Qvi2oTn2j3jG8vXr+k+XKgdigLTWunWsADJAzVyDlxnA88YK9682YVz/iZb4qCfn0AAVnk1HP5
        AhLpxfhKI/IlN
X-Received: by 2002:a7b:ca50:: with SMTP id m16mr16016410wml.140.1626436594894;
        Fri, 16 Jul 2021 04:56:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyzpk42UzRRxk7+MFlgI3Tl4jUUYwJ5//sfSt39koXWXmATnlp1LtpgerFv79RAxrnGo919Wg==
X-Received: by 2002:a7b:ca50:: with SMTP id m16mr16016389wml.140.1626436594646;
        Fri, 16 Jul 2021 04:56:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y66sm8009080wmy.39.2021.07.16.04.56.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jul 2021 04:56:34 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] s390x: Fix out-of-tree builds
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Steffen Eiden <seiden@linux.ibm.com>
References: <20210716105219.1201997-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <11739766-1932-ce25-75b0-cae6be58aad1@redhat.com>
Date:   Fri, 16 Jul 2021 13:56:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210716105219.1201997-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/07/21 12:52, Thomas Huth wrote:
> The support for "snippets" (nested guest binaries) that has been added
> recently to the s390x folder broke the out-of-tree compilation. We
> have to make sure that the snippet folder is created in the build
> directory, too, and that linker script is taken from the source folder.
> 
> While we're at it, switch the gitlab-CI cross compiler job to use
> out-of-tree builds, too, so that this does not happen so easily again.
> We're still testing in-tree s390x builds with the native "s390x-kvm"
> job on the s390x host, so we now test both, in-tree and out-of-tree
> builds.
> 
> Fixes: 2f6fdb4ac446 ("s390x: snippets: Add snippet compilation")
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>   .gitlab-ci.yml | 4 +++-
>   configure      | 4 ++++
>   s390x/Makefile | 2 +-
>   3 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index 4aebb97..943b20f 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -57,7 +57,9 @@ build-ppc64le:
>   build-s390x:
>    script:
>    - dnf install -y qemu-system-s390x gcc-s390x-linux-gnu
> - - ./configure --arch=s390x --cross-prefix=s390x-linux-gnu-
> + - mkdir build
> + - cd build
> + - ../configure --arch=s390x --cross-prefix=s390x-linux-gnu-
>    - make -j2
>    - ACCEL=tcg ./run_tests.sh
>        selftest-setup intercept emulator sieve skey diag10 diag308 vector diag288
> diff --git a/configure b/configure
> index 1d4871e..1d4d855 100755
> --- a/configure
> +++ b/configure
> @@ -296,6 +296,10 @@ if test ! -e Makefile; then
>       ln -sf "$srcdir/$testdir/unittests.cfg" $testdir/
>       ln -sf "$srcdir/run_tests.sh"
>   
> +    if [ -d "$srcdir/$testdir/snippets" ]; then
> +        mkdir -p "$testdir/snippets/c"
> +    fi
> +
>       echo "linking scripts..."
>       ln -sf "$srcdir/scripts"
>   fi
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 07af26d..6565561 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -90,7 +90,7 @@ $(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(FLATLIBS)
>   	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $@ $@
>   
>   $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_asmlib) $(FLATLIBS)
> -	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/c/flat.lds $(patsubst %.gbin,%.o,$@) $(snippet_asmlib) $(FLATLIBS)
> +	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/c/flat.lds $(patsubst %.gbin,%.o,$@) $(snippet_asmlib) $(FLATLIBS)
>   	$(OBJCOPY) -O binary $@ $@
>   	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $@ $@
>   
> 

Queued, thanks.

Paolo

