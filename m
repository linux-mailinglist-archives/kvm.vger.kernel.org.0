Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D533B140A70
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2020 14:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgAQNKn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jan 2020 08:10:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37940 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726587AbgAQNKn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jan 2020 08:10:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579266640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3naX5f3N1OJENrtyP/IUSp6TUQq5MNvgkrF1Zq4dbZo=;
        b=AkTaaIjE7tVPIwQBxWitgkXgO7ssunFjzLYpfajizuGIrgsZ2fNgHTI62IDgNdPlG7QPXW
        gTUkTy/XHeG9wMdM8o9dPWBByG50k3rOkfYWaw2hS6/R6Bubn+AHVTmWQCadG8/jplsvDb
        tWibIZRmr69Y1x2u/ZmoOCSdfx0kLYw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-bP9sOBxRO8W6XflkcVXNpw-1; Fri, 17 Jan 2020 08:10:36 -0500
X-MC-Unique: bP9sOBxRO8W6XflkcVXNpw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1578D477
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2020 13:10:35 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1898E60C84;
        Fri, 17 Jan 2020 13:10:31 +0000 (UTC)
Date:   Fri, 17 Jan 2020 14:10:29 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Wainer dos Santos Moschetta <wainersm@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests] README: fix markdown formatting and general
 improvements
Message-ID: <20200117131029.ymicng7vj2zebsik@kamzik.brq.redhat.com>
References: <20200116212054.4041-1-wainersm@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116212054.4041-1-wainersm@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 16, 2020 at 06:20:54PM -0300, Wainer dos Santos Moschetta wrote:
> There are some formatting fixes on this change:
> - Some blocks weren't indented correctly;
> - Some statements needed escape.
> 
> Also the text is improved in some ways:
> - Variables and options are bold now;
> - Files path are set to italic;

I'd rather not do that. All the *'s and \'s make reading more difficult.

> - Inline commands are marked;
> - Added a section about the tests configuration file.

Adding new content should be done as a separate patch.

Thanks for the cleanups, but I think we can keep the markup minimal and
still format the content neatly.

drew

> 
> Signed-off-by: Wainer dos Santos Moschetta <wainersm@redhat.com>
> ---
>  See the results here: https://github.com/wainersm/kvm-unit-tests/tree/docs
> 
>  README.md | 100 ++++++++++++++++++++++++++++++------------------------
>  1 file changed, 55 insertions(+), 45 deletions(-)
> 
> diff --git a/README.md b/README.md
> index 1a9a4ab..07c5a82 100644
> --- a/README.md
> +++ b/README.md
> @@ -13,12 +13,11 @@ To create the test images do:
>      ./configure
>      make
>  
> -in this directory. Test images are created in ./<ARCH>/*.flat
> +in this directory. Test images are created in *./\<ARCH\>/\*.flat*
>  
>  ## Standalone tests
>  
> -The tests can be built as standalone
> -To create and use standalone tests do:
> +The tests can be built as standalone. To create and use standalone tests do:
>  
>      ./configure
>      make standalone
> @@ -26,8 +25,8 @@ To create and use standalone tests do:
>      (go to somewhere)
>      ./some-test
>  
> -'make install' will install all tests in PREFIX/share/kvm-unit-tests/tests,
> -each as a standalone test.
> +They are created in *./tests*. Or run `make install` to install all tests in
> +*PREFIX/share/kvm-unit-tests/tests*, each as a standalone test.
>  
>  
>  # Running the tests
> @@ -42,85 +41,96 @@ or:
>  
>  to run them all.
>  
> -To select a specific qemu binary, specify the QEMU=<path>
> +By default the runner script searches for a suitable qemu binary in the system.
> +To select a specific qemu binary though, specify the **QEMU=\<path\>**
>  environment variable:
>  
>      QEMU=/tmp/qemu/x86_64-softmmu/qemu-system-x86_64 ./x86-run ./x86/msr.flat
>  
>  To select an accelerator, for example "kvm" or "tcg", specify the
> -ACCEL=<name> environment variable:
> +**ACCEL=\<name\>** environment variable:
>  
>      ACCEL=kvm ./x86-run ./x86/msr.flat
>  
> -# Unit test inputs
> +# Tests suite configuration
>  
> -Unit tests use QEMU's '-append <args...>' parameter for command line
> -inputs, i.e. all args will be available as argv strings in main().
> -Additionally a file of the form
> +Given that each test case may need specific runtime configurations as, for
> +example, extra QEMU parameters and limited time to execute, the
> +runner script reads those information from a configuration file found
> +at *./\<ARCH\>/unittests.cfg*. This file also contain the group of tests which
> +can be ran with the script's **-g** option.
> +
> +## Unit test inputs
>  
> -KEY=VAL
> -KEY2=VAL
> -...
> +Unit tests use QEMU's **-append \<args...\>** parameter for command line
> +inputs, i.e. all args will be available as *argv* strings in *main()*.
> +Additionally a file of the form
>  
> -may be passed with '-initrd <file>' to become the unit test's environ,
> -which can then be accessed in the usual ways, e.g. VAL = getenv("KEY")
> -Any key=val strings can be passed, but some have reserved meanings in
> -the framework. The list of reserved environment variables is below
> +    KEY=VAL
> +    KEY2=VAL
> +    ...
>  
> - QEMU_ACCEL            ... either kvm or tcg
> - QEMU_VERSION_STRING   ... string of the form `qemu -h | head -1`
> - KERNEL_VERSION_STRING ... string of the form `uname -r`
> +may be passed with **-initrd \<file\>** to become the unit test's environ,
> +which can then be accessed in the usual ways, e.g. `VAL = getenv("KEY")`.
> + Any *key=val* strings can be passed, but some have reserved meanings in
> +the framework. The list of reserved environment variables is:
>  
> -Additionally these self-explanatory variables are reserved
> +    QEMU_ACCEL                   either kvm or tcg
> +    QEMU_VERSION_STRING          string of the form `qemu -h | head -1`
> +    KERNEL_VERSION_STRING        string of the form `uname -r`
>  
> - QEMU_MAJOR, QEMU_MINOR, QEMU_MICRO, KERNEL_VERSION, KERNEL_PATCHLEVEL,
> - KERNEL_SUBLEVEL, KERNEL_EXTRAVERSION
> +Additionally these self-explanatory variables are reserved: *QEMU\_MAJOR*, *QEMU\_MINOR*, *QEMU\_MICRO*, *KERNEL\_VERSION*, *KERNEL\_PATCHLEVEL*, *KERNEL\_SUBLEVEL*, *KERNEL\_EXTRAVERSION*.
>  
>  # Guarding unsafe tests
>  
>  Some tests are not safe to run by default, as they may crash the
>  host. kvm-unit-tests provides two ways to handle tests like those.
>  
> - 1) Adding 'nodefault' to the groups field for the unit test in the
> -    unittests.cfg file. When a unit test is in the nodefault group
> + 1) Adding **nodefault** to the groups field for the unit test in the
> +    *unittests.cfg* file. When a unit test is in the *nodefault* group
>      it is only run when invoked
>  
> -    a) independently, arch-run arch/test
> -    b) by specifying any other non-nodefault group it is in,
> -       groups = nodefault,mygroup : ./run_tests.sh -g mygroup
> -    c) by specifying all tests should be run, ./run_tests.sh -a
> +     a. independently, `<ARCH>-run <ARCH>/<TEST>.flat`
> +
> +     b. by specifying any other non-nodefault group it is in,
> +        *groups = nodefault,mygroup* : `./run_tests.sh -g mygroup`
> +
> +     c. by specifying all tests should be run, `./run_tests.sh -a`
>  
>   2) Making the test conditional on errata in the code,
> +    ```
>      if (ERRATA(abcdef012345)) {
>          do_unsafe_test();
>      }
> -
> +    ```
>      With the errata condition the unsafe unit test is only run
>      when
>  
> -    a) the ERRATA_abcdef012345 environ variable is provided and 'y'
> -    b) the ERRATA_FORCE environ variable is provided and 'y'
> -    c) by specifying all tests should be run, ./run_tests.sh -a
> -       (The -a switch ensures the ERRATA_FORCE is provided and set
> +    a) the *ERRATA\_abcdef012345* environment variable is provided and 'y'
> +
> +    b) the **ERRATA_FORCE** environment variable is provided and 'y'
> +
> +    c) by specifying all tests should be run, `./run_tests.sh -a`
> +       (The **-a** switch ensures the **ERRATA_FORCE** is provided and set
>          to 'y'.)
>  
> -The errata.txt file provides a mapping of the commits needed by errata
> +The *./errata.txt* file provides a mapping of the commits needed by errata
>  conditionals to their respective minimum kernel versions. By default,
>  when the user does not provide an environ, then an environ generated
> -from the errata.txt file and the host's kernel version is provided to
> +from the *./errata.txt* file and the host's kernel version is provided to
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
> +See *./\<ARCH\>/README* for architecture specific documentation.
>  
>  ## Style
>  
> @@ -129,7 +139,7 @@ existing files should be consistent with the existing style. For new
>  files:
>  
>    - C: please use standard linux-with-tabs, see Linux kernel
> -    doc Documentation/process/coding-style.rst
> +    doc *Documentation/process/coding-style.rst*
>    - Shell: use TABs for indentation
>  
>  Exceptions:
> @@ -142,7 +152,7 @@ Patches are welcome at the KVM mailing list <kvm@vger.kernel.org>.
>  
>  Please prefix messages with: [kvm-unit-tests PATCH]
>  
> -You can add the following to .git/config to do this automatically for you:
> +You can add the following to *.git/config* to do this automatically for you:
>  
>      [format]
>          subjectprefix = kvm-unit-tests PATCH
> -- 
> 2.23.0
> 

