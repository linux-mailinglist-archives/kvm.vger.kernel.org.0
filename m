Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3723481C0
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 20:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237764AbhCXTS1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 15:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238115AbhCXTRP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 15:17:15 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84409C0613F0
        for <kvm@vger.kernel.org>; Wed, 24 Mar 2021 12:17:14 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id x7so3119995wrw.10
        for <kvm@vger.kernel.org>; Wed, 24 Mar 2021 12:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=ks7ShY2KdqBCOa2qudGrTxafbstGO1KxoD94z5nmwd4=;
        b=bjZoBOViVyL1mHLmUFR7BSZIMAluKI/kXY5E2/ztjZRSCxzbzqraymTeP/LQuXxMd6
         5YPx58H1VAuhSW12/DzOC9BHGHgBV1J/hhCob2AhjQhBoGcMDaLPjYwGaOGrtjITgpiU
         twnR7Di8AA6EdQ4WpfeSjtyjUfsAP9baelo+A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=ks7ShY2KdqBCOa2qudGrTxafbstGO1KxoD94z5nmwd4=;
        b=JYiSj9XF1OEl4OLmmCHJ9mchdEeXIywRx3f2E/Gm3qcls73K66Ewx4MCeWXio3dtHQ
         mzkreHjeK8g1TuExMQQ+AWAIpfduDsAfIsj4NFZYPznPbLX58mDJisOR43KWHaNJZJ4A
         oO1UgGWm1y/uXAc8goYDFTTKZxiH6OrbXz9yeijobL252VRbU2RcFAV3Lx1E0UPen2nm
         C1Y+F9Ifyw6JpUzMzoLEUN/RoNrEXQs06jwSwF34Y1ophtKJnA6xm5fuf2OgJK7vj3Ro
         2u7uhtlt4Njes4/DqR4gq6oNiJxdxVQd7FiqLfgvFsw8s9u/AV1UAtQHBqB/DGUdTX5/
         2cCQ==
X-Gm-Message-State: AOAM532FEMWFxd1Kzdrltdcd4oqpQDnDqlCVLlYbx7FcDTgzwXRv0Ftu
        g9R8SKPJSNOIcErFOpLlhXemEA==
X-Google-Smtp-Source: ABdhPJz0jKYo0H/XBwWmbtO5rMA4MuyiBVo+Vi9lmrQcQ8si+ZT3Tkgf1DTxMp2/fnyfyvXSPQ76vg==
X-Received: by 2002:a5d:6312:: with SMTP id i18mr5156957wru.149.1616613433126;
        Wed, 24 Mar 2021 12:17:13 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id f2sm3344574wmp.20.2021.03.24.12.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 12:17:12 -0700 (PDT)
Date:   Wed, 24 Mar 2021 20:17:10 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        3pvd@google.com, Jann Horn <jannh@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: Re: [PATCH 3/3] mm: unexport follow_pfn
Message-ID: <YFuQNj10P+uUHD4G@phenom.ffwll.local>
Mail-Followup-To: Jason Gunthorpe <jgg@nvidia.com>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        3pvd@google.com, Jann Horn <jannh@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, Peter Xu <peterx@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Daniel Vetter <daniel.vetter@intel.com>
References: <20210316153303.3216674-1-daniel.vetter@ffwll.ch>
 <20210316153303.3216674-4-daniel.vetter@ffwll.ch>
 <20210324125211.GA2356281@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324125211.GA2356281@nvidia.com>
X-Operating-System: Linux phenom 5.7.0-1-amd64 
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 24, 2021 at 09:52:11AM -0300, Jason Gunthorpe wrote:
> On Tue, Mar 16, 2021 at 04:33:03PM +0100, Daniel Vetter wrote:
> > Both kvm (in bd2fae8da794 ("KVM: do not assume PTE is writable after
> > follow_pfn")) and vfio (in 07956b6269d3 ("vfio/type1: Use
> > follow_pte()")) have lost their callsites of follow_pfn(). All the
> > other ones have been switched over to unsafe_follow_pfn because they
> > cannot be fixed without breaking userspace api.
> > 
> > Argueably the vfio code is still racy, but that's kinda a bigger
> > picture. But since it does leak the pte beyond where it drops the pt
> > lock, without anything else like an mmu notifier guaranteeing
> > coherence, the problem is at least clearly visible in the vfio code.
> > So good enough with me.
> > 
> > I've decided to keep the explanation that after dropping the pt lock
> > you must have an mmu notifier if you keep using the pte somehow by
> > adjusting it and moving it into the kerneldoc for the new follow_pte()
> > function.
> > 
> > Cc: 3pvd@google.com
> > Cc: Jann Horn <jannh@google.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Jason Gunthorpe <jgg@nvidia.com>
> > Cc: Cornelia Huck <cohuck@redhat.com>
> > Cc: Peter Xu <peterx@redhat.com>
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > Cc: linux-mm@kvack.org
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-samsung-soc@vger.kernel.org
> > Cc: linux-media@vger.kernel.org
> > Cc: kvm@vger.kernel.org
> > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > ---
> >  include/linux/mm.h |  2 --
> >  mm/memory.c        | 26 +++++---------------------
> >  mm/nommu.c         | 13 +------------
> >  3 files changed, 6 insertions(+), 35 deletions(-)
> 
> I think this is the right thing to do.

Was just about to smash this into the topic branch for testing in
linux-next. Feel like an ack on the series, or at least the two mm
patches?
-Daniel

> 
> Alex is working on fixing VFIO and while kvm is still racy using
> follow pte, I think they are working on it too?
> 
> Jason

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
