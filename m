Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68D9C275306
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 10:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgIWIOi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 04:14:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59119 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726178AbgIWIOi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 04:14:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600848876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c8DFEaIpp6EhgO+YmCwx8H0jssxASLQV47cgc3soFPI=;
        b=i5OGISdjkAnuC34MZiagbOXXrFfvo92O4Nq6pYwV+tWXx0Scqg4gXLH3yln12jlmZiRgKV
        l4/L5fEqXvHHZ589x6KohBb4tajJi7FmZQRGc2k8yKmAogPZ5aCVGlZIq77+Lh24Lls/5U
        qaLA8YEpPPAMb8+rpgHOOrWTvLKmmMc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-_lSMZcoyN_GdlmzZQWMdlw-1; Wed, 23 Sep 2020 04:14:33 -0400
X-MC-Unique: _lSMZcoyN_GdlmzZQWMdlw-1
Received: by mail-wr1-f70.google.com with SMTP id v12so8517261wrm.9
        for <kvm@vger.kernel.org>; Wed, 23 Sep 2020 01:14:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c8DFEaIpp6EhgO+YmCwx8H0jssxASLQV47cgc3soFPI=;
        b=S5ib11LZFQQ3uaZzDT4u1vzBd46bA+E/euXFy+tk10RUtiQOjK47WnCqvW3oX5kiED
         FcfaKzg6uMQ6nkmpaK/2QF159lx/rpIhbr0OIufi+HnTXtYHru+jtFEhrIbLuwq21sSD
         O32w/AhH9PEeKtMCRMeOAHBFb5hTWFqxRgjaopqHxk6cAuhdK+hMqnbKsLOnAc++DfRm
         KXJJH4udk8nW3yKU8F/i6bcTVzivYYeY4KAHasSz3vZmfHxNocxehgKBIUZ/6f2CcBqu
         3eUml1B3Ld1Zl5eiaVo/6r6NsUekq04qmlPbE67AMG57djF6+HkWsTqh9Fz79GsrhO2r
         3kuQ==
X-Gm-Message-State: AOAM533KV1/qHo5iLZ32V1nH3Di9iuEsP139BVMDxR9gROuLvq9ldWGN
        wgj2/jTBEEkLhKZlgY8SyoopaPRmmPsLkslT2sG2AU/LZ0m0864hx8MAe/Z7aCpwZiLhX3eKd7u
        MdGc6azelSl5j
X-Received: by 2002:adf:9027:: with SMTP id h36mr9700986wrh.259.1600848871996;
        Wed, 23 Sep 2020 01:14:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxmc93HoRCquCbEP3xx0UUdArw0ZrqOn8DVzPioK/UTepliwjnXZP++XFA9qoR3ibgUsIIEvQ==
X-Received: by 2002:adf:9027:: with SMTP id h36mr9700970wrh.259.1600848871776;
        Wed, 23 Sep 2020 01:14:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:15f1:648d:7de6:bad9? ([2001:b07:6468:f312:15f1:648d:7de6:bad9])
        by smtp.gmail.com with ESMTPSA id 9sm6976309wmf.7.2020.09.23.01.14.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 01:14:31 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] travis.yml: Fix the getopt problem
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200923073931.74769-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0bc92d08-a642-32c9-0a73-102f6fd27913@redhat.com>
Date:   Wed, 23 Sep 2020 10:14:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200923073931.74769-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/20 09:39, Thomas Huth wrote:
> The enhanced getopt is now not selected with a configure switch
> anymore, but by setting the PATH to the right location.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  This fixes the new macOS build jobs on Travis :
>  https://travis-ci.com/github/huth/kvm-unit-tests/builds/186146708
> 
>  .travis.yml | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Pushed, and I also linked the gitlab repo to Travis:

https://travis-ci.com/gitlab/kvm-unit-tests/KVM-Unit-Tests

Paolo

> diff --git a/.travis.yml b/.travis.yml
> index ae4ed08..2e5ae41 100644
> --- a/.travis.yml
> +++ b/.travis.yml
> @@ -128,8 +128,7 @@ jobs:
>              - qemu
>              - x86_64-elf-gcc
>        env:
> -      - CONFIG="--cross-prefix=x86_64-elf-
> -                --getopt=/usr/local/opt/gnu-getopt/bin/getopt"
> +      - CONFIG="--cross-prefix=x86_64-elf-"
>        - BUILD_DIR="build"
>        - TESTS="ioapic-split smptest smptest3 vmexit_cpuid vmexit_mov_from_cr8
>                 vmexit_mov_to_cr8 vmexit_inl_pmtimer vmexit_ipi vmexit_ipi_halt
> @@ -137,6 +136,7 @@ jobs:
>                 vmexit_tscdeadline_immed eventinj msr port80 setjmp
>                 syscall tsc rmap_chain umip intel_iommu"
>        - ACCEL="tcg"
> +      - PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
>  
>      - os: osx
>        osx_image: xcode11.6
> @@ -149,8 +149,7 @@ jobs:
>              - qemu
>              - i686-elf-gcc
>        env:
> -      - CONFIG="--arch=i386 --cross-prefix=i686-elf-
> -                --getopt=/usr/local/opt/gnu-getopt/bin/getopt"
> +      - CONFIG="--arch=i386 --cross-prefix=i686-elf-"
>        - BUILD_DIR="build"
>        - TESTS="cmpxchg8b vmexit_cpuid vmexit_mov_from_cr8 vmexit_mov_to_cr8
>                 vmexit_inl_pmtimer vmexit_ipi vmexit_ipi_halt
> @@ -158,6 +157,7 @@ jobs:
>                 vmexit_tscdeadline_immed eventinj port80 setjmp tsc
>                 taskswitch umip"
>        - ACCEL="tcg"
> +      - PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
>  
>  before_script:
>    - if [ "$ACCEL" = "kvm" ]; then
> 

