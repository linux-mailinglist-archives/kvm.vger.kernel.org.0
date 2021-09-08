Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5265E403D56
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 18:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347220AbhIHQI6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 12:08:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33876 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346618AbhIHQI5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Sep 2021 12:08:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631117268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bgAixjfqxK+KySv0KLIPFQXXlPfwGRV/dBCLSa1qrTs=;
        b=aUw0wiLpDa+JObqaDmcQp0On/HCXQwVbL0k6oHuq2QmocCj8vkp8PyiqSLAUVe23XIOTiV
        qDeaFa8HOG3C6PS1+VjJc1fncajvRi9cNW5/bPpHy754PZ44RdoNiB+4EGOmShsGfIlNMf
        8tE+s70nkui5YvL6OZ/ZFi839o55Ygo=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-zjp__QDON-SXdZwjRSHmDw-1; Wed, 08 Sep 2021 12:07:47 -0400
X-MC-Unique: zjp__QDON-SXdZwjRSHmDw-1
Received: by mail-ej1-f69.google.com with SMTP id bi9-20020a170906a24900b005c74b30ff24so1248259ejb.5
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 09:07:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bgAixjfqxK+KySv0KLIPFQXXlPfwGRV/dBCLSa1qrTs=;
        b=pwmGDosy26MKVcLk+qr7YOo33Pn3PU+pMA889ISdeqGi02io9oEXOsJWsmCQT/TWVP
         aGIbgGWjC2PrXr8o8lKIkYN4qwmJeZjxehsaEuYfVXakWbFApK9s+sAWWrFKE913hUdm
         o6iRvNL8CnR8ZY73Y2TpsCf7cRB7Gfh5Dyvwa8BKnhktHgiSMr+CWqum9Z4QksEvo+lv
         GgqJa1sKmHAfWdp+4CVIB9QcVbInDaaItrdjdXkpzosKY3LpJMfq2zI5pSbEr8KsW7lC
         JOgOOXTyl1ClTZiTIl8ayHffvkqpx2rL9hFkPNjs3fJ1eGdxRQ+o0nkYJY/jePRdvJSG
         iLiQ==
X-Gm-Message-State: AOAM533waBQSnKLjYBkiIkuMjVMM4MGWYCCG2Nx+CnMu1eJhXvvdoK36
        a/vHZHKUIHRcy06YKjGBt0U7dx8xfwj/BJbyEnRnEsHI+rjKuzhbw0zz71+d5qxmr2mVV7kap+X
        NCi84t7rDqe/B
X-Received: by 2002:aa7:c04e:: with SMTP id k14mr4597891edo.101.1631117265773;
        Wed, 08 Sep 2021 09:07:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/Z+CwRUwOjBWCCIIw4LzHo1BJr62ATb5mUiTSp/JNWar8qE3J6IMmTqOXtmUN6Dl6kWTUDw==
X-Received: by 2002:aa7:c04e:: with SMTP id k14mr4597875edo.101.1631117265580;
        Wed, 08 Sep 2021 09:07:45 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id l8sm1080254ejn.103.2021.09.08.09.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 09:07:45 -0700 (PDT)
Date:   Wed, 8 Sep 2021 18:07:43 +0200
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
Message-ID: <20210908160743.l4hrl4de7wkxwuda@gator>
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
 <20210702163122.96110-5-alexandru.elisei@arm.com>
 <20210907102135.i2w3r7j4zyj736b5@gator>
 <ee11a10a-c3e6-b9ce-81e1-147025a9b5bd@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee11a10a-c3e6-b9ce-81e1-147025a9b5bd@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 08, 2021 at 04:37:39PM +0100, Alexandru Elisei wrote:
> Hi Drew,
> 
> On 9/7/21 11:21 AM, Andrew Jones wrote:
> > On Fri, Jul 02, 2021 at 05:31:21PM +0100, Alexandru Elisei wrote:
> >> Add support for the standalone target when running kvm-unit-tests under
> >> kvmtool.
> >>
> >> Example command line invocation:
> >>
> >> $ ./configure --target=kvmtool
> >> $ make clean && make standalone
> >>
> >> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> >> ---
> >>  scripts/mkstandalone.sh | 14 +++++++-------
> >>  1 file changed, 7 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
> >> index 16f461c06842..d84bdb7e278c 100755
> >> --- a/scripts/mkstandalone.sh
> >> +++ b/scripts/mkstandalone.sh
> >> @@ -44,6 +44,10 @@ generate_test ()
> >>  	config_export ARCH_NAME
> >>  	config_export PROCESSOR
> >>  
> >> +	if [ "$ARCH" = "arm64" ] || [ "$ARCH" = "arm" ]; then
> >> +		config_export TARGET
> >> +	fi
> > Should export unconditionally, since we'll want TARGET set
> > unconditionally.
> 
> Yes, will do.
> 
> >
> >> +
> >>  	echo "echo BUILD_HEAD=$(cat build-head)"
> >>  
> >>  	if [ ! -f $kernel ]; then
> >> @@ -59,7 +63,7 @@ generate_test ()
> >>  		echo 'export FIRMWARE'
> >>  	fi
> >>  
> >> -	if [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ]; then
> >> +	if [ "$TARGET" != "kvmtool" ] && [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ]; then
> > I think it would be better to ensure that ENVIRON_DEFAULT is "no" for
> > TARGET=kvmtool in configure.
> 
> From looking at the code, it is my understanding that with ENVIRON_DEFAULT=yes, an
> initrd file is generated with the contents of erratatxt and other information, in
> a key=value pair format. This initrd is then passed on to the test (please correct
> me if I'm wrong). With ENVIRON_DEFAULT=no (set via ./configure
> --disable-default-environ), this initrd is not generated.
> 
> kvmtool doesn't have support for passing an initrd when loading firmware, so yes,
> I believe the default should be no.
> 
> However, I have two questions:
> 
> 1. What happens when the user specifically enables the default environ via
> ./configure --enable-default-environ --target=kvmtool? In my opinion, that should
> be an error because the user wants something that is not possible with kvmtool
> (loading an image with --firmware in kvmtool means that the initrd image it not
> loaded into the guest memory and no node is generated for it in the dtb), but I
> would like to hear your thoughts about it.

As part of the forcing ENVIRON_DEFAULT to "no" for kvmtool in configure an
error should be generated if a user tries to explicitly enable it.

> 
> 2. If the default environment is disabled, is it still possible for an user to
> pass an initrd via other means? I couldn't find where that is implemented, so I'm
> guessing it's not possible.

Yes, a user could have a KVM_UNIT_TESTS_ENV environment variable set when
they launch the tests. If that variable points to a file then it will get
passed as an initrd. I guess you should also report a warning in arm/run
if KVM_UNIT_TESTS_ENV is set which states that the environment file will
be ignored when running with kvmtool.

There aren't currently any other ways to invoke the addition of the
-initrd command line option, because so far we only support passing a
single file to test (the environment "file"). If we ever want to pass
more files, then we'd need to create a simple file system on the initrd
and make it possible to add -initrd even when no environment is desired.
But, that may never happen.

Thanks,
drew

> 
> Thanks,
> 
> Alex
> 
> >
> >
> >>  		temp_file ERRATATXT "$ERRATATXT"
> >>  		echo 'export ERRATATXT'
> >>  	fi
> >> @@ -95,12 +99,8 @@ function mkstandalone()
> >>  	echo Written $standalone.
> >>  }
> >>  
> >> -if [ "$TARGET" = "kvmtool" ]; then
> >> -	echo "Standalone tests not supported with kvmtool"
> >> -	exit 2
> >> -fi
> >> -
> >> -if [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ] && [ ! -f "$ERRATATXT" ]; then
> >> +if [ "$TARGET" != "kvmtool" ] && [ "$ENVIRON_DEFAULT" = "yes" ] && \
> >> +		[ "$ERRATATXT" ] && [ ! -f "$ERRATATXT" ]; then
> >>  	echo "$ERRATATXT not found. (ERRATATXT=$ERRATATXT)" >&2
> >>  	exit 2
> >>  fi
> >> -- 
> >> 2.32.0
> >>
> > Thanks,
> > drew 
> >
> 

