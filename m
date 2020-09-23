Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D3827567D
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 12:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgIWKiE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 06:38:04 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:45794 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726476AbgIWKiE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 06:38:04 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id A4079527BA;
        Wed, 23 Sep 2020 10:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1600857481;
         x=1602671882; bh=u++h4KLshu515GIGRHa+5ipJDwCE+IHS2fuGCkiGaqU=; b=
        tdKuUif0eQmaNzNCzjGMdKCyr3hCOOYZZwpp6TGsjRB2XkxRu8CYL5nuaHKuNuYS
        EdvSy8p18XV28ZsJ2XVlfXG5aV82XLjYg+Jct0yaBT3DPx0OIGvgYJRhRP/76PHA
        3Ovc0ALtvlYXWBUK/OYNPGP1kEGUptlaGBWjr6AMr9A=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id M8acR2IWsE01; Wed, 23 Sep 2020 13:38:01 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 569B8515BD;
        Wed, 23 Sep 2020 13:38:01 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 23
 Sep 2020 13:38:01 +0300
Date:   Wed, 23 Sep 2020 13:38:00 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Thomas Huth <thuth@redhat.com>
CC:     <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] travis.yml: Fix the getopt problem
Message-ID: <20200923103800.GC11460@SPB-NB-133.local>
References: <20200923073931.74769-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200923073931.74769-1-thuth@redhat.com>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 23, 2020 at 09:39:31AM +0200, Thomas Huth wrote:
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
> 
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
> -- 
> 2.18.2
> 

Thanks, Thomas!
