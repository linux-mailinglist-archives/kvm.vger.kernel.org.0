Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC1C367BAD
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 10:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235191AbhDVIDq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 04:03:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47822 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234773AbhDVIDp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 04:03:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619078590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HuliVKSjNgJrwoXum5zRyi+xd5k9Y5JwzVBuTZhkAsE=;
        b=hNyt2KY8yecVqqejFdp5deW3EWouWIeCeXwFhg2YsG/rQwO+GVSlc9cRyOTAd99ZfWej+H
        zIXXrMqicMKO5G3+oH8w3kVO6H+IKNIdSpui4pBW7s1xT5mYUx7XYNaFlN/FLNJ403fD2N
        CZpGudMd9pPA2/Ol8fjSItbz+NcoX/Y=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-A2ZxUM7tP9GVsql8TUtTbA-1; Thu, 22 Apr 2021 04:03:08 -0400
X-MC-Unique: A2ZxUM7tP9GVsql8TUtTbA-1
Received: by mail-ed1-f71.google.com with SMTP id d2-20020aa7d6820000b0290384ee872881so12206072edr.10
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 01:03:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=HuliVKSjNgJrwoXum5zRyi+xd5k9Y5JwzVBuTZhkAsE=;
        b=gPfjGd8zNfKAmA0j1CRgPtLv1mNis+r4Bxgr6wieBVJqGmeyA4ikI44VeLH/uWE6HN
         j6Blkr4X+KaHBdKuQ5MoRScaT2Y1zlofeJCjrwjNWR4TekmlesvQqgWcdl0TSYhbmvr0
         xZnqBy6/hIVoVT/1cSQFECbRAnSM9fMFGKaPs7NgBgaunTOk2KgFPEGLSpUiLhLA310b
         y6EfOgr2cXa8jwzpUbG+Cd/WxQk8c12WFyO+BekzwN/Vaq4/SM/s1V/oFFivE6PtanN1
         c5m9f5wsIqpXctYz2PZ1cfyznMIzztP1uZwvSLc+UBIy1W+2caVP51+nEa+v4dmYsFWb
         AX0A==
X-Gm-Message-State: AOAM5311CS3hV7Tm8LzuVR8YymSzwtPIRa9ElCmuY8hupJ36SHdU2Yy1
        kV2mii4qbj5yCi1OQg8OQG5pcJ9NE7/OlB2FZbet0Dw4fmXrvzyk4QxPFPBNnSbEsfTdy0V6Iky
        9UUiuXkVM9VRB
X-Received: by 2002:a17:906:88b:: with SMTP id n11mr1988584eje.26.1619078587429;
        Thu, 22 Apr 2021 01:03:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwBCeIBHz0a6EpgAkl4aqEVM/01xzrbdA4bz1BfFlA+tlE+r0auJtDYmLc9V1fmQD3QoOVbng==
X-Received: by 2002:a17:906:88b:: with SMTP id n11mr1988567eje.26.1619078587272;
        Thu, 22 Apr 2021 01:03:07 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id cd14sm1306755ejb.53.2021.04.22.01.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 01:03:06 -0700 (PDT)
Date:   Thu, 22 Apr 2021 10:03:05 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Thomas Huth <thuth@redhat.com>, Jacob Xu <jacobhxu@google.com>,
        kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] update git tree location in MAINTAINERS
 to point at gitlab
Message-ID: <20210422080305.pjmfwq45qhhwmzt2@gator>
References: <20210421191611.2557051-1-jacobhxu@google.com>
 <edc3df0e-0eb7-108d-3371-2e13f285d632@redhat.com>
 <97adb2d3-47f4-385a-18b4-90572c9f486a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <97adb2d3-47f4-385a-18b4-90572c9f486a@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 22, 2021 at 09:39:44AM +0200, Paolo Bonzini wrote:
> On 22/04/21 05:42, Thomas Huth wrote:
> > On 21/04/2021 21.16, Jacob Xu wrote:
> > > The MAINTAINERS file appears to have been forgotten during the migration
> > > to gitlab from the kernel.org. Let's update it now.
> > > 
> > > Signed-off-by: Jacob Xu <jacobhxu@google.com>
> > > ---
> > >   MAINTAINERS | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index 54124f6..e0c8e99 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -55,7 +55,7 @@ Maintainers
> > >   -----------
> > >   M: Paolo Bonzini <pbonzini@redhat.com>
> > >   L: kvm@vger.kernel.org
> > > -T: git://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git
> > > +T:    https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git
> > 
> > Reviewed-by: Thomas Huth <thuth@redhat.com>
> 
> You're too humble, Thomas. :)  Since Drew and you have commit access this
> could very well be:
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ef7e9af..0082e58 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -54,8 +54,9 @@ Descriptions of section entries:
>  Maintainers
>  -----------
>  M: Paolo Bonzini <pbonzini@redhat.com>
> +M: Thomas Huth <thuth@redhat.com>
> +M: Andrew Jones <drjones@redhat.com>
>  L: kvm@vger.kernel.org
> -T: git://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git
> +T: https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git
> 
>  Architecture Specific Code:
>  ---------------------------
> 
> And also, while at it:
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ef7e9af..0082e58 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -92,3 +94,4 @@ M: Paolo Bonzini <pbonzini@redhat.com>
>  L: kvm@vger.kernel.org
>  F: x86/*
>  F: lib/x86/*
> +T: https://gitlab.com/bonzini/kvm-unit-tests.git
> 
>

I also use my own gitlab for arm/queue. So we could also add

diff --git a/MAINTAINERS b/MAINTAINERS
index 54124f6f1a5e..0a2f3a645bb3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -67,6 +67,7 @@ L: kvmarm@lists.cs.columbia.edu
 F: arm/*
 F: lib/arm/*
 F: lib/arm64/*
+T: https://gitlab.com/rhdrjones/kvm-unit-tests.git
 
 POWERPC
 M: Laurent Vivier <lvivier@redhat.com>


Thanks,
drew

