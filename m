Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139EE42CA07
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 21:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236010AbhJMTba (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 15:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbhJMTb2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 15:31:28 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA027C061570
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 12:29:24 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id s136so51840pgs.4
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 12:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HJWlwMc3bcVndzEG3rK1HHM2GpwqaG1vW1trPKMhPTE=;
        b=ngD+bHowU5GX0hIFoHwCgvBSYL1kIwj5BamgcK2b44Hn0Efa1cJh1BkhvPnJNyXaz+
         oaTiT+/SvMe6Sna42CuymTahBBHtBTsM99qXGLLWtDgURRrWH7WsP4ESROuTVw/YrLgC
         CNfDMvuhnaZto7jmQiMkFOCpDK0ROXVXdyYLbaV5tFR9BX0J2eg3sjJpkF1ptwft6sX1
         FWrvZX8CX+PrVKFcYhPqspYD4+FBt2wBaQ7Ooa8YpeerB3ORiRQFE/S6I6RUkpe3R4PG
         GECmmS0ixOIVW4fYFpRI7AkWVEQ3gsU1YNKQ5R8s4sfw7DL9MKXo3I22jJxSTVstAuO2
         yFfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HJWlwMc3bcVndzEG3rK1HHM2GpwqaG1vW1trPKMhPTE=;
        b=6mLbXN19M78dnn8B0BJ3bmMbphD0cxJruNFLWGoY6t8bsv07rKeER3or9Wcnm4+afa
         iwDkde853Iz/czklaMdjNeG+BrcQS69qpwOlY7o3f118ze3VnB1DIlFpPWzI6suc9VAW
         +KXUsvaiDNtNkpn0kwaJTu8wYp6F8z/o/vBwFtlnLubmqJxFoQL33SYRrxGwmrzyYyUz
         nk4yKFnsiXrPfihLTw0UGe/lrKHpEK1K3OLFUbHRdmxOvkypf65M7hmBjY/OyuY5Q+Yj
         JKAJl4uUm/5x3tf2J7O/NJ7RpSoeJKKXp/X0pZ2mXqNvjJX0VaerKgI2oiopTD8JzNbm
         jVnA==
X-Gm-Message-State: AOAM532EeDulHFYzO0bYAmjngsmk/RRra/OE+RGOLqU4QS1Xj5co0VQu
        MD+YO0dhWZvwR7VctcKLsf9/Og==
X-Google-Smtp-Source: ABdhPJwBnTbMERs0zBoP7LOWHM0wM+4dMwjgOwnXVqj4whYC/0ed3HgNAWHQmB2Rp9Cx46+JjoCGag==
X-Received: by 2002:a63:2041:: with SMTP id r1mr828228pgm.482.1634153364099;
        Wed, 13 Oct 2021 12:29:24 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j6sm302246pgq.0.2021.10.13.12.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 12:29:23 -0700 (PDT)
Date:   Wed, 13 Oct 2021 19:29:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        Stephen <stephenackerman16@gmail.com>, djwong@kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, rppt@kernel.org,
        James.Bottomley@hansenpartnership.com, akpm@linux-foundation.org,
        david@redhat.com, hagen@jauu.net
Subject: Re: kvm crash in 5.14.1?
Message-ID: <YWczkHnrv5ZQAkCH@google.com>
References: <85e40141-3c17-1dff-1ed0-b016c5d778b6@gmail.com>
 <2cd8af17-8631-44b5-8580-371527beeb38@gmail.com>
 <YWcs3XRLdrvyRz31@eldamar.lan>
 <f430d53f-59cf-a658-a207-1f04adb32c56@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f430d53f-59cf-a658-a207-1f04adb32c56@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 13, 2021, Paolo Bonzini wrote:
> On 13/10/21 21:00, Salvatore Bonaccorso wrote:
> > Hi,
> > 
> > On Sat, Oct 09, 2021 at 12:00:39PM -0700, Stephen wrote:
> > > > I'll try to report back if I see a crash; or in roughly a week if the
> > > system seems to have stabilized.
> > > 
> > > Just wanted to provide a follow-up here and say that I've run on both
> > > v5.14.8 and v5.14.9 with this patch and everything seems to be good; no
> > > further crashes or problems.
> > 
> > In Debian we got a report as well related to this issue (cf.
> > https://bugs.debian.org/996175). Do you know did the patch felt
> > through the cracks?
> 
> Yeah, it's not a KVM patch so the mm maintainers didn't see it.  I'll handle
> it tomorrow.

It's queued in the -mm tree.

https://lore.kernel.org/mm-commits/20211010224759.Ny1hd1WiD%25akpm@linux-foundation.org/
