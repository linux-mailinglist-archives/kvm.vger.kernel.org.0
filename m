Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF87641166E
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 16:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbhITOMO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 10:12:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53553 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229567AbhITOMN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 10:12:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632147046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RbxjU0qTM37tjAGcJkV92O2IEWr+qZ+g6bo7srNL7rU=;
        b=aNV+zdEvcFO1+Wejwaa/A4xl0wV4JG30miBvOC420WQus8WD5QKFJjzX9iW+RqfBHTgZsu
        o/N/p5mSlwerMTHKg8FKuxYBeNBSzZfhAOza6RsEgRQYmSCoVJqvCKpB24qdLA+Qt6gMfe
        rWbaMWtWP/qEnQMySfe93yo1tj0OIvg=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-L5kQ7FcVOCKexI3GiJx2fA-1; Mon, 20 Sep 2021 10:10:45 -0400
X-MC-Unique: L5kQ7FcVOCKexI3GiJx2fA-1
Received: by mail-qv1-f72.google.com with SMTP id w10-20020a0cb54a000000b0037a9848b92fso183321033qvd.0
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 07:10:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RbxjU0qTM37tjAGcJkV92O2IEWr+qZ+g6bo7srNL7rU=;
        b=R8VYEV63YM1GkZ2ZZcE/pkZq01ldmnX1y1ZTVtPCE08Oep4iwyV/DgtGXtX/3rayHs
         ZoQF2gIgepXTPJXMhstiqBjS4XZOu/YXU7jg1bWT66Pxk9zRcdpyNHryHoa0LbxZeuB2
         GkeJQuQ2r2i9g08fjia783AsHL/kKDJZLJuad+PGrUjg7CEoui6Q7UPOBxqRMyYvcyeC
         +nYLr2Xzuw7hOy2z8p3tMyzkJwTWyE10hphESD2frH05U/c2OxZCP0+bw47LoA5I6LtA
         OCFzOu59CmYvrOw5QF1xWlhsyRgvcwFoIi9Ja8MoQz+jPy9rRr04rt7BpQ8Kjt5UuT6r
         6uNw==
X-Gm-Message-State: AOAM533D0E0jOUiAz3wbC/ut1TvU8pqLF8lqzlmhH1IC9NAloy/R9E/Q
        IFFvYM7sFR0Dt3je1fdboYwDEK93cVAhDKHpoZPbltgHfMkkHJGP0qwA1YJp2O2bRXHeC9CfIzR
        8L0HMEIhaZ0MD
X-Received: by 2002:ac8:7d42:: with SMTP id h2mr22673698qtb.220.1632147044850;
        Mon, 20 Sep 2021 07:10:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzWtW6bdXbF26ywHKskWeYY4oyhJXrq1VU07T3GfA9xT30QFw0t/ifo6u7f0E5c8BrMFZVPBg==
X-Received: by 2002:ac8:7d42:: with SMTP id h2mr22673675qtb.220.1632147044667;
        Mon, 20 Sep 2021 07:10:44 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id t5sm5678861qkj.61.2021.09.20.07.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 07:10:43 -0700 (PDT)
Date:   Mon, 20 Sep 2021 16:10:39 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 1/2] Makefile: Fix cscope
Message-ID: <20210920141039.jfb2iektdzdjldy5@gator>
References: <1629908421-8543-1-git-send-email-pmorel@linux.ibm.com>
 <1629908421-8543-2-git-send-email-pmorel@linux.ibm.com>
 <1dd4c64e-3866-98c9-8178-dbff90dca55f@redhat.com>
 <2aaffea2-0a20-1a6d-eebb-69b6cfe6e83c@linux.ibm.com>
 <20210827102204.3y6gdpchn77cz7yo@gator.home>
 <327ff7e0-82d8-a12d-7565-e476b1dbcca8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <327ff7e0-82d8-a12d-7565-e476b1dbcca8@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 20, 2021 at 03:27:11PM +0200, Paolo Bonzini wrote:
> On 27/08/21 12:22, Andrew Jones wrote:
> > > 51b8f0b1 2017-11-23 Andrew Jones Makefile: fix cscope target
> > No surprise there, that's when the $(PWD) use was first introduced.
> > 
> > > So I add Andrew as CC, I did forgot to do before.
> > > 
> > I'll send a patch changing $(PWD) to $(shell pwd)
> 
> I could not find the patch using $(CURDIR) in my mailbox, though I found
> it on spinics.net.  I fudged the following
> 
> From 164507376abae4be15b0f65aa14d56f179198a99 Mon Sep 17 00:00:00 2001
> From: Andrew Jones <drjones@redhat.com>
> Date: Fri, 27 Aug 2021 12:31:15 +0200
> Subject: [PATCH kvm-unit-tests] Makefile: Don't trust PWD
> 
> It's possible that PWD is already set to something which isn't
> the full path of the current working directory. Let's use $(CURDIR)
> instead, which is always correct.
> 
> Suggested-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> diff --git a/Makefile b/Makefile
> index f7b9f28..6792b93 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -119,7 +119,7 @@ cscope: cscope_dirs = lib lib/libfdt lib/linux $(TEST_DIR) $(ARCH_LIBDIRS) lib/a
>  cscope:
>  	$(RM) ./cscope.*
>  	find -L $(cscope_dirs) -maxdepth 1 \
> -		-name '*.[chsS]' -exec realpath --relative-base=$(PWD) {} \; | sort -u > ./cscope.files
> +		-name '*.[chsS]' -exec realpath --relative-base=$(CURDIR) {} \; | sort -u > ./cscope.files
>  	cscope -bk
>  .PHONY: tags
> 
> and queued it.

Hi Paolo,

You'll get a conflict when you go to merge because I already did it :-)

commit 3d4eb24cb5b4de6c26f79b849fe2818d5315a691 (origin/misc/queue, misc/queue)
Author: Andrew Jones <drjones@redhat.com>
Date:   Fri Aug 27 12:25:27 2021 +0200

    Makefile: Don't trust PWD
    
    PWD comes from the environment and it's possible that it's already
    set to something which isn't the full path of the current working
    directory. Use the make variable $(CURDIR) instead.
    
    Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
    Reviewed-by: Thomas Huth <thuth@redhat.com>
    Suggested-by: Thomas Huth <thuth@redhat.com>
    Signed-off-by: Andrew Jones <drjones@redhat.com>



misc/queue is something I recently invented for stuff like this in order
to help lighten your load a bit.

Thanks,
drew

