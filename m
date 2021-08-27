Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB953F9813
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 12:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244831AbhH0KW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 06:22:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33804 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233204AbhH0KW6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 06:22:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630059729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kFsg8uc+e9bXdhscdQ6m42La98rWwK6ke0MHee/B24s=;
        b=SA6+Z9WpKQmVidXZoA0A2+vY2Qnazt6ZT7N7T86mSU10VMQwwBdEspJ6O/TbvKEu6x61At
        wHgRzrvX3n4FW8aH9gLbfghp9C+QVGKumzvpK2Qq24ZWxvSFUQXnMh70jdfumq668fsC/h
        S//k0Da2MZ6KasWllH1sE5mrgh/2odE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-VfYVyG2INMuXNgGmgu63Nw-1; Fri, 27 Aug 2021 06:22:08 -0400
X-MC-Unique: VfYVyG2INMuXNgGmgu63Nw-1
Received: by mail-ed1-f71.google.com with SMTP id y10-20020a056402270a00b003c8adc4d40cso901425edd.15
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 03:22:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=kFsg8uc+e9bXdhscdQ6m42La98rWwK6ke0MHee/B24s=;
        b=r/1w+v0swjKySyKwLZPDg8nXsYAXR9L+qSYNxfRUIIIVyAXCHnG7GXz61XyR+ZocZE
         QFwtxbDYQBD8v5+Irj58tsk96QpoG5q8MJzU1Rm0q8exoYM1FzvFJbhbg1+aA7W/5XC6
         kccpnEDlEhnBRRQJSPeFcOgYfSf4roiOaFm95izL95+wz+YIAykkKhk/hzqSkxSUxPxg
         PRn+SCIWRKiurFnat6SAPyCMX5vQNLcTN0IarTFeEafXQ0OWpinFmi0LwScJFAU/TsEt
         FjUaPsQy1MlGxbTdm4q7WfHrZ4gFqJsytJFEYG+8qBl4qk/VHZLHOvN0hD9fCcp3U7kg
         mB6g==
X-Gm-Message-State: AOAM532v3vMYmOWFdUTA3WThyTE6UVilv5nOPeX/JOHvWm4HKL7Vz6yl
        S035wjwvpVuQ49z68BSPgs/zS7ZdhIZKqEvzBLJ7Ebqkw5nBYCNpzLBYvWLr1AmXs82Au2lnlhS
        gpg9S2UDrjdiT
X-Received: by 2002:a05:6402:31b9:: with SMTP id dj25mr9002673edb.180.1630059726825;
        Fri, 27 Aug 2021 03:22:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx36cbsgw+8ssml4nYa14Iy4uWIQMjpSViHUtTQv6ANYU1nTvFz+eacwsmAgW8Asmk+iYt4Og==
X-Received: by 2002:a05:6402:31b9:: with SMTP id dj25mr9002669edb.180.1630059726662;
        Fri, 27 Aug 2021 03:22:06 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id p23sm2655958ejc.19.2021.08.27.03.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 03:22:06 -0700 (PDT)
Date:   Fri, 27 Aug 2021 12:22:04 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 1/2] Makefile: Fix cscope
Message-ID: <20210827102204.3y6gdpchn77cz7yo@gator.home>
References: <1629908421-8543-1-git-send-email-pmorel@linux.ibm.com>
 <1629908421-8543-2-git-send-email-pmorel@linux.ibm.com>
 <1dd4c64e-3866-98c9-8178-dbff90dca55f@redhat.com>
 <2aaffea2-0a20-1a6d-eebb-69b6cfe6e83c@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2aaffea2-0a20-1a6d-eebb-69b6cfe6e83c@linux.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 11:26:38AM +0200, Pierre Morel wrote:
> 
> 
> On 8/26/21 7:07 AM, Thomas Huth wrote:
> > On 25/08/2021 18.20, Pierre Morel wrote:
> > > In Linux, cscope uses a wrong directory.
> > > Simply search from the directory where the make is started.
> > > 
> > > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > > ---
> > >   Makefile | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/Makefile b/Makefile
> > > index f7b9f28c..c8b0d74f 100644
> > > --- a/Makefile
> > > +++ b/Makefile
> > > @@ -119,7 +119,7 @@ cscope: cscope_dirs = lib lib/libfdt lib/linux
> > > $(TEST_DIR) $(ARCH_LIBDIRS) lib/a
> > >   cscope:
> > >       $(RM) ./cscope.*
> > >       find -L $(cscope_dirs) -maxdepth 1 \
> > > -        -name '*.[chsS]' -exec realpath --relative-base=$(PWD) {}
> > > \; | sort -u > ./cscope.files
> > > +        -name '*.[chsS]' -exec realpath --relative-base=. {} \; |
> > > sort -u > ./cscope.files
> > 
> > Why is $PWD not pointing to the same location as "." ? Are you doing
> > in-tree or out-of-tree builds?
> > 
> >   Thomas
> > 
> 
> In tree.
> That is the point, why is PWD indicating void ?

If you do 'env' I'll bet you'll see something like

...
PWD=
...

> I use a bash on s390x.
> inside bash PWD shows current directory
> GNU Make is 4.2.1 on Ubuntu 18.04
> 
> This works on X with redhat and GNU make 3.82
> 
> This happens on s390x since:
> 51b8f0b1 2017-11-23 Andrew Jones Makefile: fix cscope target

No surprise there, that's when the $(PWD) use was first introduced.

> 
> So I add Andrew as CC, I did forgot to do before.
>

I'll send a patch changing $(PWD) to $(shell pwd)

Thanks,
drew

