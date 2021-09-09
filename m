Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F83405734
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 15:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354390AbhIINcJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 09:32:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27088 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358345AbhIINHK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Sep 2021 09:07:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631192758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1FVErduCuTQmHI3vb5b1r9KDhDiP+77xZGlhd2lM7ew=;
        b=M6t3u8sF0wG5ULyhAOghlLfFKBby4BaXvFQG4sxnmZLatoqcXJp6rb8mspMhnOZ7Q5RQiN
        yErt1c4JTXAlTYEONojviBwHQE51zSlQNTLd0BuPJsvztl+o34EK/sSATqzPiHvuftmWGd
        AOldZTkOv8tN9pnBMS9GJUEeA/e6eMk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-JEPbRRFzMEO8TZJLEg5Rsg-1; Thu, 09 Sep 2021 09:05:57 -0400
X-MC-Unique: JEPbRRFzMEO8TZJLEg5Rsg-1
Received: by mail-wm1-f71.google.com with SMTP id k5-20020a7bc3050000b02901e081f69d80so742833wmj.8
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 06:05:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1FVErduCuTQmHI3vb5b1r9KDhDiP+77xZGlhd2lM7ew=;
        b=s0GFMZws7wIJ9gLOZQgSBAUxqIRZ6uY7uu/uNn8rNXvoGFJRh9s7gfpvjdrI+IwFxu
         wVBVFoNjCc/v1NvWyhRa3E/mh60P+ZdCJATqFv1sfRJ4C34DKjqEOt93FPLD3gsFZEhY
         r8aK7IhKIUMQHc1Yru7LDRc5agXqKZZQJMTe9vfrH7Vt0jNeZ80NeTOfmp/Ci+FZHYz8
         /bFpLJep+xQ65dXh9JrXFgMx/21dPtmR8RlbAlE30xjTQkfRLby1HzD2JNt6CjQ5wstU
         DODOBkXUD1MESU/FdviMSHLb4Lu8LYG/UQ6iayMtAfmb7kYd/14LP0LpOK1pR5MWrbOJ
         USmg==
X-Gm-Message-State: AOAM532IP64YwI5EoWo66JdWyq96krkDlHhJYZwGW/jsyHWIiGTju+xv
        AexYHyKEV/XuVl5pUWwRUIwvcAroWvwrp6rIfnaRzFQkqFlJMRjANCct4KJVq9gih/x83YLnObl
        6opvlllD5o7An
X-Received: by 2002:a5d:5241:: with SMTP id k1mr3513738wrc.14.1631192756631;
        Thu, 09 Sep 2021 06:05:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxT+tWfcglL0t0S4eC6SA9jHkqZot0Iidmz8QttJrfgTCOxvjPtNiiEnA6df1lyr1npKB9VDA==
X-Received: by 2002:a5d:5241:: with SMTP id k1mr3513679wrc.14.1631192756264;
        Thu, 09 Sep 2021 06:05:56 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id s15sm1695653wrb.22.2021.09.09.06.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 06:05:55 -0700 (PDT)
Date:   Thu, 9 Sep 2021 15:05:53 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     thuth@redhat.com, pbonzini@redhat.com, lvivier@redhat.com,
        kvm-ppc@vger.kernel.org, david@redhat.com, frankja@linux.ibm.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, andre.przywara@arm.com,
        maz@kernel.org, vivek.gautam@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 4/5] scripts: Generate kvmtool
 standalone tests
Message-ID: <20210909130553.gnzce7cs7d5stvjd@gator>
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
 <20210702163122.96110-5-alexandru.elisei@arm.com>
 <20210907102135.i2w3r7j4zyj736b5@gator>
 <ee11a10a-c3e6-b9ce-81e1-147025a9b5bd@arm.com>
 <20210908160743.l4hrl4de7wkxwuda@gator>
 <9d5da497-7070-31ef-282a-a11a86e0102e@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d5da497-7070-31ef-282a-a11a86e0102e@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 09, 2021 at 12:11:52PM +0100, Alexandru Elisei wrote:
> Hi Drew,
> 
> On 9/8/21 5:07 PM, Andrew Jones wrote:
> > On Wed, Sep 08, 2021 at 04:37:39PM +0100, Alexandru Elisei wrote:
> >> Hi Drew,
> >>
> >> On 9/7/21 11:21 AM, Andrew Jones wrote:
> >>> On Fri, Jul 02, 2021 at 05:31:21PM +0100, Alexandru Elisei wrote:
> >>>> Add support for the standalone target when running kvm-unit-tests under
> >>>> kvmtool.
> >>>>
> >>>> Example command line invocation:
> >>>>
> >>>> $ ./configure --target=kvmtool
> >>>> $ make clean && make standalone
> >>>>
> >>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> >>>> ---
> >>>>  scripts/mkstandalone.sh | 14 +++++++-------
> >>>>  1 file changed, 7 insertions(+), 7 deletions(-)
> >>>>
> >>>> diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
> >>>> index 16f461c06842..d84bdb7e278c 100755
> >>>> --- a/scripts/mkstandalone.sh
> >>>> +++ b/scripts/mkstandalone.sh
> >>>> @@ -44,6 +44,10 @@ generate_test ()
> >>>>  	config_export ARCH_NAME
> >>>>  	config_export PROCESSOR
> >>>>  
> >>>> +	if [ "$ARCH" = "arm64" ] || [ "$ARCH" = "arm" ]; then
> >>>> +		config_export TARGET
> >>>> +	fi
> >>> Should export unconditionally, since we'll want TARGET set
> >>> unconditionally.
> >> Yes, will do.
> >>
> >>>> +
> >>>>  	echo "echo BUILD_HEAD=$(cat build-head)"
> >>>>  
> >>>>  	if [ ! -f $kernel ]; then
> >>>> @@ -59,7 +63,7 @@ generate_test ()
> >>>>  		echo 'export FIRMWARE'
> >>>>  	fi
> >>>>  
> >>>> -	if [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ]; then
> >>>> +	if [ "$TARGET" != "kvmtool" ] && [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ]; then
> >>> I think it would be better to ensure that ENVIRON_DEFAULT is "no" for
> >>> TARGET=kvmtool in configure.
> >> From looking at the code, it is my understanding that with ENVIRON_DEFAULT=yes, an
> >> initrd file is generated with the contents of erratatxt and other information, in
> >> a key=value pair format. This initrd is then passed on to the test (please correct
> >> me if I'm wrong). With ENVIRON_DEFAULT=no (set via ./configure
> >> --disable-default-environ), this initrd is not generated.
> >>
> >> kvmtool doesn't have support for passing an initrd when loading firmware, so yes,
> >> I believe the default should be no.
> >>
> >> However, I have two questions:
> >>
> >> 1. What happens when the user specifically enables the default environ via
> >> ./configure --enable-default-environ --target=kvmtool? In my opinion, that should
> >> be an error because the user wants something that is not possible with kvmtool
> >> (loading an image with --firmware in kvmtool means that the initrd image it not
> >> loaded into the guest memory and no node is generated for it in the dtb), but I
> >> would like to hear your thoughts about it.
> > As part of the forcing ENVIRON_DEFAULT to "no" for kvmtool in configure an
> > error should be generated if a user tries to explicitly enable it.
> >
> >> 2. If the default environment is disabled, is it still possible for an user to
> >> pass an initrd via other means? I couldn't find where that is implemented, so I'm
> >> guessing it's not possible.
> > Yes, a user could have a KVM_UNIT_TESTS_ENV environment variable set when
> > they launch the tests. If that variable points to a file then it will get
> > passed as an initrd. I guess you should also report a warning in arm/run
> > if KVM_UNIT_TESTS_ENV is set which states that the environment file will
> > be ignored when running with kvmtool.
> 
> Thank you for explaining it, I had looked at
> scripts/arch-run.bash::initrd_create(), but it didn't click that setting the
> KVM_UNIT_TESTS_ENV environment variable is enough to generate and use the initrd.
> 
> After looking at the code some more, in the logs the -initrd argument is shown as
> a comment, instead of an actual argument that is passed to qemu:
> 
> timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64 -nodefaults -machine
> virt,gic-version=host,accel=kvm -cpu host -device virtio-serial-device -device
> virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none
> -serial stdio -kernel arm/cache.flat -smp 1 # -initrd /tmp/tmp.rUIZ3h9KLJ
> QEMU_ACCEL = kvm
> INFO: IDC-DIC: dcache clean to PoU required
> INFO: IDC-DIC: icache invalidation to PoU required
> PASS: IDC-DIC: code generation
> SUMMARY: 1 tests
> 
> This is done intentionally in scripts/arch-run.bash::run_qemu(). I don't
> understand the reason for that. When I first looked at the logs, I was sure that
> no initrd is passed to the test. I had to go dig through the scripts to figure out
> that the "#" sign (which marks the beginning of a comment) is not present in the
> qemu invocation.

It's commented out because if you want to copy+paste the command line to
use it again it'll fail to run because the temp file will be gone. Of
course somebody depending on the environment for their test run will have
other problems when it's gone, but those people can use the
KVM_UNIT_TESTS_ENV variable to specify a non-temp file which includes the
default environment and then configure without the default environment.
The command line won't get the # in that case.

Thanks,
drew

> 
> Thanks,
> 
> Alex
> 
> >
> > There aren't currently any other ways to invoke the addition of the
> > -initrd command line option, because so far we only support passing a
> > single file to test (the environment "file"). If we ever want to pass
> > more files, then we'd need to create a simple file system on the initrd
> > and make it possible to add -initrd even when no environment is desired.
> > But, that may never happen.
> >
> > Thanks,
> > drew
> >
> >> Thanks,
> >>
> >> Alex
> >>
> >>>
> >>>>  		temp_file ERRATATXT "$ERRATATXT"
> >>>>  		echo 'export ERRATATXT'
> >>>>  	fi
> >>>> @@ -95,12 +99,8 @@ function mkstandalone()
> >>>>  	echo Written $standalone.
> >>>>  }
> >>>>  
> >>>> -if [ "$TARGET" = "kvmtool" ]; then
> >>>> -	echo "Standalone tests not supported with kvmtool"
> >>>> -	exit 2
> >>>> -fi
> >>>> -
> >>>> -if [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ] && [ ! -f "$ERRATATXT" ]; then
> >>>> +if [ "$TARGET" != "kvmtool" ] && [ "$ENVIRON_DEFAULT" = "yes" ] && \
> >>>> +		[ "$ERRATATXT" ] && [ ! -f "$ERRATATXT" ]; then
> >>>>  	echo "$ERRATATXT not found. (ERRATATXT=$ERRATATXT)" >&2
> >>>>  	exit 2
> >>>>  fi
> >>>> -- 
> >>>> 2.32.0
> >>>>
> >>> Thanks,
> >>> drew 
> >>>
> 

