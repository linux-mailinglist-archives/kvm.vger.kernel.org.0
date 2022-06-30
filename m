Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 334CA5611B8
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 07:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbiF3FYT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 01:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232690AbiF3FX6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 01:23:58 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF75419B9
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 22:22:10 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id d14so17709441pjs.3
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 22:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NghwaHO0WT0kjPXwxxjV97AFvUF3y6uIODD3NtHsCFk=;
        b=cFT/mkeqyFiZKp+tnt1cMP+cCjZO1Wie2l3wYCOR+msU0UgXQ7xdodOdXjdYLzywRX
         XtHte9EFktgxyyYAe52fAY8NVJxryeFumGSfXdKh0wLYwLuPTH7PvvRkoN+MUKKj3vZb
         s1Cadp45WrxKxmINYETy455xf+OjxGkLEJTsvDhnbo12i2iNe1fUmtMr7eDpY8h5roFI
         ah0/pT17Fg93mxB1IDEY92ZQla+WaAWXF4WfsVbeowspHN5SxMcoBJ1kL1+/rY1sQVfX
         Afv3gAUmY9IFLxeU1RwpNvm7fyhmKhwc/BB0bG5+yztY0hLAGgZaGKceZXkYl9mZMl32
         oTlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NghwaHO0WT0kjPXwxxjV97AFvUF3y6uIODD3NtHsCFk=;
        b=k9MnIhp9g/qCKIlHyGBc/tznDHGDWX9nAFwh5KO+nHlAHHhYVYVBbAXGqxH2tNhZYe
         BULOq30tUasAJTYkK1UAGC/aBiWEvr45N81mfw+jf/aMfTRqYtF23F9afHPlwznwXYKx
         IYdEIaStJ111Ii58i9mkrZU78M1okk3PBl7kHIWufh/l+iwZbciNkFR08TBe3Z6CIDct
         XhQ/OVJLgqWFqbC8Syb1tNDArJlAeredF13Loq/u57jux7Blj6SD7MKD3nfk+hMqcEnh
         Fi+iyaquOqyVyPPhzGUdrieIng8I9uwt+/DvBvMVgP6DkZrcoSR69KJU7VTNcRG8HVUa
         Xwbw==
X-Gm-Message-State: AJIora9J07hEGa0h9Zc8H6Rxw/3HlZL6bpeJVqwCVYI6RrtzhFrgF1MW
        9FnLXTlh/nSw287ygsrGg9we5g==
X-Google-Smtp-Source: AGRyM1sY9/Yinw3PUnIBFU1GMP5W4RK43U/BnlIwolqGdGZIUqA9lVUU7tUfvv1A7JNjxM92aRXSdA==
X-Received: by 2002:a17:902:ba90:b0:16a:2863:fb85 with SMTP id k16-20020a170902ba9000b0016a2863fb85mr13883795pls.15.1656566530077;
        Wed, 29 Jun 2022 22:22:10 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id me3-20020a17090b17c300b001ec84b0f199sm672118pjb.1.2022.06.29.22.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 22:22:09 -0700 (PDT)
Date:   Wed, 29 Jun 2022 22:22:06 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 23/23] arm64: Add an efi/run script
Message-ID: <Yr0y/ufNch/PmHzT@google.com>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-24-nikos.nikoleris@arm.com>
 <YrJPsmon33EAfe54@google.com>
 <b4b03930-3132-9632-c091-3d968ba5aa7b@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4b03930-3132-9632-c091-3d968ba5aa7b@arm.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 22, 2022 at 03:13:56PM +0100, Nikos Nikoleris wrote:
> On 22/06/2022 00:09, Ricardo Koller wrote:
> > On Fri, May 06, 2022 at 09:56:05PM +0100, Nikos Nikoleris wrote:
> > > This change adds a efi/run script inspired by the one in x86. This
> > > script will setup a folder with the test compiled as an EFI app and a
> > > startup.nsh script. The script launches QEMU providing an image with
> > > EDKII and the path to the folder with the test which is executed
> > > automatically.
> > > 
> > > For example:
> > > 
> > > $> ./arm/efi/run ./arm/selftest.efi setup smp=2 mem=256
> > > 
> > > Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> > > ---
> > >   scripts/runtime.bash | 14 +++++-----
> > >   arm/efi/run          | 61 ++++++++++++++++++++++++++++++++++++++++++++
> > >   arm/run              |  8 ++++--
> > >   arm/Makefile.common  |  1 +
> > >   arm/dummy.c          |  4 +++
> > >   5 files changed, 78 insertions(+), 10 deletions(-)
> > >   create mode 100755 arm/efi/run
> > >   create mode 100644 arm/dummy.c
> > > 
> > > diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> > > index 7d0180b..dc28f24 100644
> > > --- a/scripts/runtime.bash
> > > +++ b/scripts/runtime.bash
> > > @@ -131,14 +131,12 @@ function run()
> > >       fi
> > > 
> > >       last_line=$(premature_failure > >(tail -1)) && {
> > > -        skip=true
> > > -        if [ "${CONFIG_EFI}" == "y" ] && [[ "${last_line}" =~ "enabling apic" ]]; then
> > > -            skip=false
> > > -        fi
> > > -        if [ ${skip} == true ]; then
> > > -            print_result "SKIP" $testname "" "$last_line"
> > > -            return 77
> > > -        fi
> > > +        if [ "${CONFIG_EFI}" == "y" ] && [ "${ARCH}" = x86_64 ]; then
> > > +            if ! [[ "${last_line}" =~ "enabling apic" ]]; then
> > > +                    print_result "SKIP" $testname "" "$last_line"
> > > +                    return 77
> > > +            fi
> > > +    fi
> > >       }
> > > 
> > >       cmdline=$(get_cmdline $kernel)
> > > diff --git a/arm/efi/run b/arm/efi/run
> > > new file mode 100755
> > > index 0000000..dfff717
> > > --- /dev/null
> > > +++ b/arm/efi/run
> > > @@ -0,0 +1,61 @@
> > > +#!/bin/bash
> > > +
> > > +set -e
> > > +
> > > +if [ $# -eq 0 ]; then
> > > +    echo "Usage $0 TEST_CASE [QEMU_ARGS]"
> > > +    exit 2
> > > +fi
> > > +
> > > +if [ ! -f config.mak ]; then
> > > +    echo "run './configure --enable-efi && make' first. See ./configure -h"
> > > +    exit 2
> > > +fi
> > > +source config.mak
> > > +source scripts/arch-run.bash
> > > +source scripts/common.bash
> > > +
> > > +: "${EFI_SRC:=$(realpath "$(dirname "$0")/../")}"
> > > +: "${EFI_UEFI:=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd}"
> > > +: "${EFI_TEST:=efi-tests}"
> > > +: "${EFI_CASE:=$(basename $1 .efi)}"
> > > +
> > > +if [ ! -f "$EFI_UEFI" ]; then
> > > +    echo "UEFI firmware not found: $EFI_UEFI"
> > > +    echo "Please install the UEFI firmware to this path"
> > > +    echo "Or specify the correct path with the env variable EFI_UEFI"
> > > +    exit 2
> > > +fi
> > > +
> > > +# Remove the TEST_CASE from $@
> > > +shift 1
> > > +
> > > +# Fish out the arguments for the test, they should be the next string
> > > +# after the "-append" option
> > > +qemu_args=()
> > > +cmd_args=()
> > > +while (( "$#" )); do
> > > +    if [ "$1" = "-append" ]; then
> > > +            cmd_args=$2
> > > +            shift 2
> > 
> > Does this work with params like this (2 words)?
> > 
> >       [pmu-cycle-counter]
> >       file = pmu.flat
> >       groups = pmu
> >       extra_params = -append 'cycle-counter 0'
> > 
> 
> I think it does. cmd_args will take the value of the string that follows
> append and in this case whatever is between the single/double quotes.

Just in case I tested it on bash and it works as expected.

So, with that:

Reviewed-by: Ricardo Koller <ricarkol@google.com>
