Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C99A390DF5
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 03:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbhEZBnw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 21:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbhEZBnv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 May 2021 21:43:51 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410E3C061574
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 18:42:21 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id e15so10695741plh.1
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 18:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o8E4+5ZAKL0lNJTs6AaOglOtVWwkGnocN+n8tCRloHk=;
        b=l5q7ISvDge5lGEoTYb6q7xBFtDWziih+hFsPYp01vHeMyyRtwBPTD0eKUCNBw+0nSt
         IAGgfAjkYNwJZhF/7rEmsjbCywwHVpyWDvZEEWTxe8W3WlxmtwJBw3KCFEqemmsN/tur
         4gzV1JYak9CGxQoh/f82RzxCTzqO1ohfesSxhreHZHJmMunBfcvRfjP6DBJt5HbQz00u
         N57MLM6BvuINS3CkICvdBTMP5Ybk0zF6+ArGRisDyKZtYhMkd3KBIl9czIc6Lcqtvldj
         nl1+Y8bOSENJe1XtvIScf6/xmWlwAYjiCX5Q0Udy+ipgeAssXaSx7WDuXVdIkGsk7yy4
         aR9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o8E4+5ZAKL0lNJTs6AaOglOtVWwkGnocN+n8tCRloHk=;
        b=kfdddCwLyAnPoU9giOSdPlTV8fiTts7H+APvwnC+Wmcmgbk4mmXa+xxDyDw+c72+gT
         +undKIgIF0c7iLCM/9SAmHVBwPJBu+BngrTG1J/zfHf8t8Pr1m0fU04MaC5Ts2pyQ1tk
         I8j9JbTyzbc0h+Szagv36e81srssjIsxPZQT4RZLPydY+PU1Ew0i5I8Xz4u+MHNttniG
         u+/lG6nM6ze48npjojkdjQARU7kYBF5VewXqblMvpBFhsdPgzo+9/ZvJ4GFN3L91jZ8J
         rdWFyvtffT6532vJ0YP3ThL4SifvRjs9c1uMnad4gIH6z2PS9FMGHMu9u+jQgZ5DozHX
         KxXQ==
X-Gm-Message-State: AOAM533igrku9boY2Im1vBTcrWoU8JvgtG9/KUHev2jYxmbS54nyxRLR
        P9xujvFmbYVpmdyIBBSreaXBxqKmW72rdrBJ2mT8Qw==
X-Google-Smtp-Source: ABdhPJz4NBsggzyrPkLlJ3Td7DiSvO9EdqkwCslk9S+U3Nwv93kHKTTkLZV3WMLCRBlHeFFNY0SAGPudmLJo8+BppCo=
X-Received: by 2002:a17:902:ee8b:b029:ef:ab33:b835 with SMTP id
 a11-20020a170902ee8bb02900efab33b835mr33168127pld.27.1621993340620; Tue, 25
 May 2021 18:42:20 -0700 (PDT)
MIME-Version: 1.0
References: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com> <2-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <20210428060300.GA4092@lst.de> <CAPcyv4g=MFtZMVZPn8AtTX6NyweF25nuFNVBu7pg_QSP+EGE+g@mail.gmail.com>
 <20210428124153.GA28566@lst.de> <20210428140005.GS1370958@nvidia.com>
 <CAPcyv4hnjX-HtoG08dPbPxJPeJyvnO-WaJosoY1aSRqm5oo14Q@mail.gmail.com> <20210526004230.GA3563025@nvidia.com>
In-Reply-To: <20210526004230.GA3563025@nvidia.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 25 May 2021 18:42:15 -0700
Message-ID: <CAPcyv4gM2keEqtyhKyC+-djgq8QBVFnQiHtorgDMLgmw2kGS5g@mail.gmail.com>
Subject: Re: [PATCH v2 02/13] vfio/mdev: Allow the mdev_parent_ops to specify
 the device driver to bind
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        KVM list <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        Dave Jiang <dave.jiang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 25, 2021 at 5:42 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Wed, Apr 28, 2021 at 12:58:29PM -0700, Dan Williams wrote:
>
> > I have an ulterior motive / additional use case in mind here which is
> > the work-in-progress cleanup of the DSA driver.
>
> Well, I worked on it for a while, please take a look at this:
>
> https://github.com/jgunthorpe/linux/commits/device_driver_attach
>
> It makes device_driver_attach() into what this mdev stuff needs, and I
> think improves the sysfs bind file as a side effect.

Nice, yes, it looks like it does.

> Is it what you need for DSA?

Yes.
