Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D960143954
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 10:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729078AbgAUJSt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 04:18:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41557 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728712AbgAUJSt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 04:18:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579598327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5gpaajxNuLsdBSQiaiBPCKHeNO4yOpGf83DYoV8E9mA=;
        b=L0Y16SxwnBBIRDR5N0FDFcu3Y1t/HmkzFl+Ao7q7B3K9AkxXKs2+iTiDMBpTGYBtDTll1B
        LnrDvaCXeIce3lJNz5MFg6ITCWMdhOlntiqkqOf5TTkhhcYDSPxrbEL998GyzHFHRWoi0L
        nNzUcldq3dpY+N1WI/9TaWRKyP7dUeo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-dnHLW7pYMNejKt8hiplsUQ-1; Tue, 21 Jan 2020 04:18:45 -0500
X-MC-Unique: dnHLW7pYMNejKt8hiplsUQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B18C3801E6D
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 09:18:44 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B454019C6A;
        Tue, 21 Jan 2020 09:18:41 +0000 (UTC)
Date:   Tue, 21 Jan 2020 10:18:38 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Wainer dos Santos Moschetta <wainersm@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests v2 1/2] README: Fix markdown formatting
Message-ID: <20200121091838.caxeirc4aymxdnwc@kamzik.brq.redhat.com>
References: <20200120194310.3942-1-wainersm@redhat.com>
 <20200120194310.3942-2-wainersm@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200120194310.3942-2-wainersm@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 20, 2020 at 04:43:09PM -0300, Wainer dos Santos Moschetta wrote:
> There are formatting issues that prevent README.md
> from being rendered correctly in a browser. This
> patch fixes the following categories of issues:
> 
> - blocks which aren't indented correctly;
> - texts wrapped in <> which need escape, or
>   be replaced with another thing.
> 
> Also some inline commands are marked with ``.
> 
> Signed-off-by: Wainer dos Santos Moschetta <wainersm@redhat.com>
> ---
>  README.md | 72 ++++++++++++++++++++++++++++++-------------------------
>  1 file changed, 39 insertions(+), 33 deletions(-)

Thanks

Reviewed-by: Andrew Jones <drjones@redhat.com>

But, I still have a few comments below.

> 
> diff --git a/README.md b/README.md
> index 1a9a4ab..367c92a 100644
> --- a/README.md
> +++ b/README.md
> @@ -13,12 +13,11 @@ To create the test images do:
>      ./configure
>      make
>  
> -in this directory. Test images are created in ./<ARCH>/*.flat
> +in this directory. Test images are created in ./ARCH/\*.flat
>  
>  ## Standalone tests
>  
> -The tests can be built as standalone
> -To create and use standalone tests do:
> +The tests can be built as standalone. To create and use standalone tests do:

I'd prefer we use two spaces after the period for the sentence punctuation,
like many kernel documents have.

>  
>      ./configure
>      make standalone
> @@ -26,7 +25,7 @@ To create and use standalone tests do:
>      (go to somewhere)
>      ./some-test
>  
> -'make install' will install all tests in PREFIX/share/kvm-unit-tests/tests,
> +`make install` will install all tests in PREFIX/share/kvm-unit-tests/tests,
>  each as a standalone test.
>  
>  
> @@ -42,39 +41,40 @@ or:
>  
>  to run them all.
>  
> -To select a specific qemu binary, specify the QEMU=<path>
> +By default the runner script searches for a suitable qemu binary in the system.
> +To select a specific qemu binary though, specify the QEMU=path/to/binary
>  environment variable:
>  
>      QEMU=/tmp/qemu/x86_64-softmmu/qemu-system-x86_64 ./x86-run ./x86/msr.flat
>  
>  To select an accelerator, for example "kvm" or "tcg", specify the
> -ACCEL=<name> environment variable:
> +ACCEL=name environment variable:
>  
>      ACCEL=kvm ./x86-run ./x86/msr.flat
>  
>  # Unit test inputs
>  
> -Unit tests use QEMU's '-append <args...>' parameter for command line
> +Unit tests use QEMU's '-append args...' parameter for command line
>  inputs, i.e. all args will be available as argv strings in main().
>  Additionally a file of the form
>  
> -KEY=VAL
> -KEY2=VAL
> -...
> +    KEY=VAL
> +    KEY2=VAL
> +    ...
>  
> -may be passed with '-initrd <file>' to become the unit test's environ,
> -which can then be accessed in the usual ways, e.g. VAL = getenv("KEY")
> -Any key=val strings can be passed, but some have reserved meanings in
> +may be passed with '-initrd file' to become the unit test's environ,
> +which can then be accessed in the usual ways, e.g. VAL = getenv("KEY").
> + Any key=val strings can be passed, but some have reserved meanings in

Looks like an unintentional space added before the 'Any'. Actually maybe
it's time to reformat all paragraphs. I'd like each line to have a length
of +/- 76 characters.

>  the framework. The list of reserved environment variables is below
>  
> - QEMU_ACCEL            ... either kvm or tcg
> - QEMU_VERSION_STRING   ... string of the form `qemu -h | head -1`
> - KERNEL_VERSION_STRING ... string of the form `uname -r`
> +    QEMU_ACCEL                   either kvm or tcg
> +    QEMU_VERSION_STRING          string of the form `qemu -h | head -1`
> +    KERNEL_VERSION_STRING        string of the form `uname -r`
>  
>  Additionally these self-explanatory variables are reserved
>  
> - QEMU_MAJOR, QEMU_MINOR, QEMU_MICRO, KERNEL_VERSION, KERNEL_PATCHLEVEL,
> - KERNEL_SUBLEVEL, KERNEL_EXTRAVERSION
> +    QEMU_MAJOR, QEMU_MINOR, QEMU_MICRO, KERNEL_VERSION, KERNEL_PATCHLEVEL,
> +    KERNEL_SUBLEVEL, KERNEL_EXTRAVERSION
>  
>  # Guarding unsafe tests
>  
> @@ -85,42 +85,48 @@ host. kvm-unit-tests provides two ways to handle tests like those.
>      unittests.cfg file. When a unit test is in the nodefault group
>      it is only run when invoked
>  
> -    a) independently, arch-run arch/test
> -    b) by specifying any other non-nodefault group it is in,
> -       groups = nodefault,mygroup : ./run_tests.sh -g mygroup
> -    c) by specifying all tests should be run, ./run_tests.sh -a
> +     a) independently, `ARCH-run ARCH/test`
> +
> +     b) by specifying any other non-nodefault group it is in,
> +        groups = nodefault,mygroup : `./run_tests.sh -g mygroup`
> +
> +     c) by specifying all tests should be run, `./run_tests.sh -a`
>  
>   2) Making the test conditional on errata in the code,
> +    ```
>      if (ERRATA(abcdef012345)) {
>          do_unsafe_test();
>      }
> +    ```
>  
>      With the errata condition the unsafe unit test is only run
>      when
>  
> -    a) the ERRATA_abcdef012345 environ variable is provided and 'y'
> -    b) the ERRATA_FORCE environ variable is provided and 'y'
> -    c) by specifying all tests should be run, ./run_tests.sh -a
> +    a) the ERRATA_abcdef012345 environment variable is provided and 'y'
> +
> +    b) the ERRATA_FORCE environment variable is provided and 'y'
> +
> +    c) by specifying all tests should be run, `./run_tests.sh -a`
>         (The -a switch ensures the ERRATA_FORCE is provided and set
>          to 'y'.)
>  
> -The errata.txt file provides a mapping of the commits needed by errata
> +The ./errata.txt file provides a mapping of the commits needed by errata
>  conditionals to their respective minimum kernel versions. By default,
>  when the user does not provide an environ, then an environ generated
> -from the errata.txt file and the host's kernel version is provided to
> +from the ./errata.txt file and the host's kernel version is provided to
>  all unit tests.
>  
>  # Contributing
>  
>  ## Directory structure
>  
> -    .:				configure script, top-level Makefile, and run_tests.sh
> -    ./scripts:		helper scripts for building and running tests
> -    ./lib:			general architecture neutral services for the tests
> -    ./lib/<ARCH>:	architecture dependent services for the tests
> -    ./<ARCH>:		the sources of the tests and the created objects/images
> +    .:                  configure script, top-level Makefile, and run_tests.sh
> +    ./scripts:          helper scripts for building and running tests
> +    ./lib:              general architecture neutral services for the tests
> +    ./lib/<ARCH>:       architecture dependent services for the tests
> +    ./<ARCH>:           the sources of the tests and the created objects/images
>  
> -See <ARCH>/README for architecture specific documentation.
> +See ./ARCH/README for architecture specific documentation.
>  
>  ## Style
>  
> -- 
> 2.23.0
>

Besides the space before 'Any' this patch is fine, which is why I gave the
r-b. I can do a reformatting patch on top of this myself for my other
comments. However if you're going to respin this, then please consider
reformatting the line lengths and the sentence punctuation. Also please
changing occurrences of "qemu" and "kvm" to "QEMU" and "KVM" when they are
being used as names, rather than parts of paths. E.g.

 The KVM test suite is in kvm-unit-tests.
 We can run QEMU with qemu-system-x86_64.

Thanks,
drew

