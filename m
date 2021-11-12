Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC4C44E93C
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 15:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235074AbhKLO5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 09:57:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24873 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231553AbhKLO5i (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Nov 2021 09:57:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636728887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CqpS1HH0zhDySu1JBKv5pA0ucN4UqNVJlGatSL7MT0A=;
        b=NMJX+AzilCZtIXxlYrJTAA0mrdryI64CkVSdhZ04SxIfyodjA1a0RHtq+D+4ZP0RZ5hBFm
        Gw6oK/OzirYtGn1gYiAX5tz0yMODM1tWjmhorJBMgl4TeJeZElbpcjDMLNN3zAcX4knJjM
        ZGx87foiMuT98NVMi6IFpPMcZhuQ0cg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-Gbd-4ObbMrOUnsKUVMorAA-1; Fri, 12 Nov 2021 09:54:46 -0500
X-MC-Unique: Gbd-4ObbMrOUnsKUVMorAA-1
Received: by mail-ed1-f72.google.com with SMTP id w18-20020a056402071200b003e61cbafdb4so226951edx.4
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 06:54:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=CqpS1HH0zhDySu1JBKv5pA0ucN4UqNVJlGatSL7MT0A=;
        b=sOznKhyFRwZiGWko8Z41skS5ngHaJqOVJWCKYLJzqZCmK4wYFAA/98No58zaGVuI3R
         C/OD/WNiO0w9TbF+CUZXTT6nnXFlsUts4dct2gJYGl0Fy+G3JozE+Hxv1MdVuJxtWeyx
         khTHUcaPb9L3okM4JEPYtT9QTbsH77uqI+1Erp++eLP2Y50qjXhMrHwbeZCt/I+7tMgR
         3XtpJF4pIlT9wfGHZoHQxAyxJKfQshEaVngrH+dEs1pwhfNlC4K8VVvyVE7IxrE78FJz
         MqlwgUt23xaU9gyQm+mRl6gxtOKmKHXseN/Ny3x9+MO8DrovEjbXdhxLcU1R2LtyqTk2
         eRGA==
X-Gm-Message-State: AOAM530iOjXuDijGyR/HviCmE8PR/JIxJ3pH4CWhaI7CXfqzY5AFCFB5
        D1Fs0iK69/OdAl9Pt+KDzUZhzzMO0QOY0jHjCEkbyeNEYj5ZYsN61Gzk789aFZql0UM1D3ZoWyJ
        O8Dvf3F5jSVV3
X-Received: by 2002:a50:e089:: with SMTP id f9mr22475521edl.290.1636728885139;
        Fri, 12 Nov 2021 06:54:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy5xCNQMS07DiZTiT4vSSKrzHxuhlKtuaSkvfESoFy0jlnHf/ZLWzbRuwGNBUwiLuFzccR8+g==
X-Received: by 2002:a50:e089:: with SMTP id f9mr22475491edl.290.1636728884981;
        Fri, 12 Nov 2021 06:54:44 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id mc3sm2769954ejb.24.2021.11.12.06.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 06:54:43 -0800 (PST)
Date:   Fri, 12 Nov 2021 15:54:42 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc:     kvm@vger.kernel.org, maz@kernel.org, shashi.mallela@linaro.org,
        qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 0/3] GIC ITS tests
Message-ID: <20211112145442.5ktlpwyolwdsxlnx@gator.home>
References: <20211112114734.3058678-1-alex.bennee@linaro.org>
 <20211112132312.qrgmby55mlenj72p@gator.home>
 <87wnldfoul.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87wnldfoul.fsf@linaro.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 12, 2021 at 02:08:01PM +0000, Alex Bennée wrote:
> 
> Andrew Jones <drjones@redhat.com> writes:
> 
> > On Fri, Nov 12, 2021 at 11:47:31AM +0000, Alex Bennée wrote:
> >> Hi,
> >> 
> >> Sorry this has been sitting in my tree so long. The changes are fairly
> >> minor from v2. I no longer split the tests up into TCG and KVM
> >> versions and instead just ensure that ERRATA_FORCE is always set when
> >> run under TCG.
> >> 
> >> Alex Bennée (3):
> >>   arm64: remove invalid check from its-trigger test
> >>   arm64: enable its-migration tests for TCG
> >>   arch-run: do not process ERRATA when running under TCG
> >> 
> >>  scripts/arch-run.bash |  4 +++-
> >>  arm/gic.c             | 16 ++++++----------
> >>  arm/unittests.cfg     |  3 ---
> >>  3 files changed, 9 insertions(+), 14 deletions(-)
> >> 
> >> -- 
> >> 2.30.2
> >> 
> >> _______________________________________________
> >> kvmarm mailing list
> >> kvmarm@lists.cs.columbia.edu
> >> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> >
> > Hi Alex,
> >
> > Thanks for this. I've applied to arm/queue, but I see that
> >
> > FAIL: gicv3: its-trigger: inv/invall: dev2/eventid=20 pending LPI is received
> >
> > consistently fails for me. Is that expected? Does it work for you?
> 
> doh - looks like I cocked up the merge conflict...
> 
> Did it fail for TCG or for KVM (or both)?

Just TCG, which was why I was wondering if it was expected. I've never run
these tests with TCG before.

Thanks,
drew

