Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB4FD4A6C9C
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 09:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242966AbiBBIG1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 03:06:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50441 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237918AbiBBIGZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Feb 2022 03:06:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643789184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6Ku5FedphAhKRl0XNH9vCmvgH2DaHf/evJb1hacNe3k=;
        b=bI/JHZwAjynnmbNvEKCyfYbBRsZFEdVdSaxUd9byvpIIfSN/xRlcy3s4qH5QGfx/VYx2Bc
        bHuvJK5tJ191lj1RAssBGaZlp3WTWvO0NEK+TpHwlFEYZ+PAZDKF8wUNEtEylOeQR6/s2c
        V03V1KM9qVbLSoNvB9BDeP4lOCUkVOg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-410-GLiZEBkON96T1hEDJ8JAdA-1; Wed, 02 Feb 2022 03:06:23 -0500
X-MC-Unique: GLiZEBkON96T1hEDJ8JAdA-1
Received: by mail-ej1-f71.google.com with SMTP id kw5-20020a170907770500b006ba314a753eso7721405ejc.21
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 00:06:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6Ku5FedphAhKRl0XNH9vCmvgH2DaHf/evJb1hacNe3k=;
        b=TdGjoudPVNGLuqAe05SfB+e389WmBBTE+Q26n3f01jFE0AC2332UwVCefti5xKcXPk
         hzE6daEKKogG6cx0ftsyJ5pY4T3W+2/8O1+dkEdWI6exTdzASaqV7qFdLrt67unOSdNO
         1QWtTj+f1xoq1ElG4SS8Vk4KSrT8jWvrsTrdIJp1+0q7LFC4KcaOhixfdTFuUHLB46te
         0S0RI7ykrYUH40vFsgvPndj6xUVvSU6PnhQGp+71B6appY7NiBwtDPjWggVgGFLvO1LO
         HDPW8vGGhG84e54krm5DFn2WgFfCu6naSIWPh0Ak4Y15aVTOzrHm+6yzV153b+hI6q9Q
         W0ZA==
X-Gm-Message-State: AOAM531kMCaN+HDR8rxwfRPcCdADYWks1Ata0Uw+2CuZvHQxR5FpynY2
        QW3Uju2pIp/LKUpDj+pmZe3rt51mWD8fvdsZT5oVvSdsR8cjvu1Ij8IQUve6s5hPBYGIDspnQGA
        bKRkj2eJiN5UA
X-Received: by 2002:a17:907:7286:: with SMTP id dt6mr24090591ejc.285.1643789182245;
        Wed, 02 Feb 2022 00:06:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwClPMOrveMm+4dK6vH/RImG8n4BWVY2SZcPvclm5UEqSV59JkPKRf+UyyNe4Omi4TLQyc6ww==
X-Received: by 2002:a17:907:7286:: with SMTP id dt6mr24090578ejc.285.1643789182021;
        Wed, 02 Feb 2022 00:06:22 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id co19sm20631874edb.7.2022.02.02.00.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 00:06:21 -0800 (PST)
Date:   Wed, 2 Feb 2022 09:06:19 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH kvm-unit-tests] arm64: Fix compiling with ancient compiler
Message-ID: <20220202080619.qowpy5wh5vpk4tu4@gator>
References: <20220201190116.182415-1-drjones@redhat.com>
 <51425935-acb6-1c34-cdbc-2349b1f8e05e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51425935-acb6-1c34-cdbc-2349b1f8e05e@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 02, 2022 at 06:19:46AM +0100, Thomas Huth wrote:
> On 01/02/2022 20.01, Andrew Jones wrote:
> > When compiling with an ancient compiler (gcc-4.8.5-36.el7_6.2.aarch64)
> > the build fails with
> > 
> >    lib/libcflat.a(alloc.o): In function `mult_overflow':
> >    /home/drjones/kvm-unit-tests/lib/alloc.c:19: undefined reference to `__multi3'
> > 
> > According to kernel commit fb8722735f50 ("arm64: support __int128 on
> > gcc 5+") GCC5+ will not emit __multi3 for __int128 multiplication,
> > so let's just fallback to the non-__int128 overflow check when we
> > use gcc versions older than 5.
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >   lib/alloc.c | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/lib/alloc.c b/lib/alloc.c
> > index f4266f5d064e..70228aa32c6c 100644
> > --- a/lib/alloc.c
> > +++ b/lib/alloc.c
> > @@ -1,6 +1,7 @@
> >   #include "alloc.h"
> >   #include "asm/page.h"
> >   #include "bitops.h"
> > +#include <linux/compiler.h>
> >   void *malloc(size_t size)
> >   {
> > @@ -13,7 +14,7 @@ static bool mult_overflow(size_t a, size_t b)
> >   	/* 32 bit system, easy case: just use u64 */
> >   	return (u64)a * (u64)b >= (1ULL << 32);
> >   #else
> > -#ifdef __SIZEOF_INT128__
> > +#if defined(__SIZEOF_INT128__) && (!defined(__aarch64__) || GCC_VERSION >= 50000)
> >   	/* if __int128 is available use it (like the u64 case above) */
> >   	unsigned __int128 res = a;
> >   	res *= b;
> 
> I'd also be OK if we'd simply declare GCC compiler versions < 5 as
> unsupported ... but since it's an easy fix:

I'd like to continue supporting this particular old compiler, because I
only have one machine where I can run the unit tests with KVM AArch32,
and on that machine I still have an old RHEL (RHEL7-Alt) installed. If
it gets too difficult to support, then I'll try upgrading that machine's
RHEL version or at least its compiler version.

> 
> Acked-by: Thomas Huth <thuth@redhat.com>
> 

Thanks, but I need a v2 since I just remembered clang. For v2, I see two
options:

 1) Just change the line as below and hope we don't need to worry about
    clang versions

#if defined(__SIZEOF_INT128__) && (!defined(__aarch64__) || defined(__clang__) || GCC_VERSION >= 50000)

 2) Replace lib/alloc.c's mult_overflow() with lib/linux/compiler.h's
check_mul_overflow()


(2) seems like the better choice except for the fact that it lazily
doesn't implement a fallback for compilers which don't support the
builtins (and that's older than GCC7.1). Do we care? Of course I
could combine the two implementations if we really want that fallback
and the cleanup.

Thanks,
drew

