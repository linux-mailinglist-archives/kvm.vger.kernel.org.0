Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59CE743E88A
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 20:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhJ1SnD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 14:43:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27404 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230380AbhJ1SnB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Oct 2021 14:43:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635446431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oqhCFtgogFW5Lacylz2cte7NCWpwMtHZ14FMRyC5M1Y=;
        b=IKtom8Gzeqfyr0eW2q1HUcruqw/FjALHxU8+q//6GdlbMH0lD9/kY5MTXX+k4yjFOxKbFE
        tB5OxKkMzIWuHoPUQtuPw2/959VdDMQ9ySMDw+trxixAYgqqdmgmL2u4D6D5yCHB71cjiw
        c8PnCsButsgx7Zo1Syh0ML7TtKLn3+A=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-Fg7Ahe17PIiRTgs5SUovuQ-1; Thu, 28 Oct 2021 14:40:30 -0400
X-MC-Unique: Fg7Ahe17PIiRTgs5SUovuQ-1
Received: by mail-oo1-f69.google.com with SMTP id e18-20020a4ae0d2000000b002bb7f65be0aso541692oot.10
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 11:40:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oqhCFtgogFW5Lacylz2cte7NCWpwMtHZ14FMRyC5M1Y=;
        b=GcRL1j4qsNUZZFmlBUnxHQW25TksEpo3OlRP1ifz3MpfZuO3xJRtVzio7wG90v41rj
         JnYECUNHqbNa+K/2cvxp2tXiW9366Nfpf1Gbcj3lbI5lAzUQqR2OaNEX/FJh2Ffou7vW
         gKsWtPHsj4mDKggQKFbezegUTEIhhk70RxQpnfsJoCMuBiz9GiqDJX+or4+1oRRAhYHW
         Tp+KKg7CjG5RjJiFZuiWq7svpgyM7ogerBE02TYPIcs0Ogkzjcul6mpD/2xkagoLNyDc
         qEvRLkn5cCGu7Sh/iYf6P8MIvSgNe4cJM9J/7YIN9fhAAzbUvS5gteXp5oYfaOi/zVey
         QTVw==
X-Gm-Message-State: AOAM533w8id3GhzFkyaJPTaG8tYbLMeqTuWuE/WhIx0egothYicW6fSI
        acXHlPMYn8AcgMkM5p83sl2g6497A6aGDc58yvehjEf8mFLPR6YLamgVbtVbma2+VH/vrn1srPs
        SdNi4Fa1PisKF
X-Received: by 2002:a05:6830:2f3:: with SMTP id r19mr4810483ote.226.1635446429840;
        Thu, 28 Oct 2021 11:40:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+QDpgpmOcTEh2/ZJPGar/gJCf/QWqhW8QpZTggHEZALuXtM/MZ6oCwETOpqjQJHMYaplJ0A==
X-Received: by 2002:a05:6830:2f3:: with SMTP id r19mr4810462ote.226.1635446429654;
        Thu, 28 Oct 2021 11:40:29 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id a1sm1217526oti.30.2021.10.28.11.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 11:40:29 -0700 (PDT)
Date:   Thu, 28 Oct 2021 12:40:28 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 0/4] Move vfio_ccw to the new mdev API
Message-ID: <20211028124028.791050f3.alex.williamson@redhat.com>
In-Reply-To: <0-v4-cea4f5bd2c00+b52-ccw_mdev_jgg@nvidia.com>
References: <0-v4-cea4f5bd2c00+b52-ccw_mdev_jgg@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 26 Oct 2021 14:57:29 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> This is the first 4 patches of the v3 series which only change CCW to use
> the new VFIO API for mdevs and leaves the lifetime model as-is.
> 
> As agreed, we will go ahead with this set and IBM can take the remaining
> patches of cleanup when they want. (I won't resend them)
> 
> Alex: as Eric has now ack'd them please take them to the VFIO tree for
> this upcoming merge window
 
Applied to vfio next branch for v5.16.  Thanks,

Alex

