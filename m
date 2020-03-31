Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26EA9199F7B
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 21:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730746AbgCaTxH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 15:53:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20063 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728274AbgCaTxG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 15:53:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585684385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b2UFMAgHLjerJ9NMZry/HpffFH2cpApwyp5N9quNxNg=;
        b=gz3NqhziaeNB1L3Hgtw0YVD22Snb6RsXCFYc/tV2i8zKDX9GLUs79mXWTGtIBNLz147eoY
        TAi/DrhTXlFFDnK4wGuzb9Blrs/8tvqU+Mt6vK284Rhn5NY0tJuPg1zdiXDX9FNXhcoi4Q
        qt+dbEJ7RiafQFqOibMbuv8yqDmZsOM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-HNTfer60NAmJAikMxrR-bw-1; Tue, 31 Mar 2020 15:51:15 -0400
X-MC-Unique: HNTfer60NAmJAikMxrR-bw-1
Received: by mail-wm1-f70.google.com with SMTP id s9so1499644wmh.2
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 12:51:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=b2UFMAgHLjerJ9NMZry/HpffFH2cpApwyp5N9quNxNg=;
        b=Hj0+wTLA1XAWztGj0KYj6QRs0XLRJPfukCsqZe8+bjY6imzieDBGFlITQuLkyco+Fx
         hd30mTyKGRy7qNvTivk2QwWZFCyUfIAo6+Li/UuakrV3y9bJH+0y/MuOp/OykCv307gI
         OuuVkKzW9KwAGU08dkyZymRGDVzXZAxAcivTTIWsGPTE7uuuUR+ULt2YYLqBKgLNnHiQ
         44YoH4h9Y/bFc49yVeymv+bBESxjFEGXMDB2wny6Im/8Qq4nPHSu5bEJIkSCi2oJiq2/
         C+ajbV54+sNlIFLAu/g26AjBaPauM1UZEwawuJs35yjZA6PX6ge43btY/wav+TKHWkXf
         cbeA==
X-Gm-Message-State: ANhLgQ1baYM9IWvO96LPf/2MJ9cAzLyep2t7QLE62eSyZ6HCS2ijz7Za
        P222MHrPOAgk/A5fErziy3q1vNfi2Z92sf7b1v2XYgaYKoo1POLQcc07TJkV6eIJn5bK2MiR58b
        6n6fdTdVruySU
X-Received: by 2002:adf:90c6:: with SMTP id i64mr21178490wri.88.1585684273178;
        Tue, 31 Mar 2020 12:51:13 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsBF9cECw6xLYUjwBS31gILdZtjJFvdt8FOUuQyT0OA1wSrJbotTajrFFZAFpWOR4/ADVtrdQ==
X-Received: by 2002:adf:90c6:: with SMTP id i64mr21178477wri.88.1585684272926;
        Tue, 31 Mar 2020 12:51:12 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id y15sm1290983wrh.50.2020.03.31.12.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 12:51:12 -0700 (PDT)
Date:   Tue, 31 Mar 2020 15:51:09 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        kvm list <kvm@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH v3 0/8] vhost: Reset batched descriptors on
 SET_VRING_BASE call
Message-ID: <20200331155049-mutt-send-email-mst@kernel.org>
References: <20200331192804.6019-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200331192804.6019-1-eperezma@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 31, 2020 at 09:27:56PM +0200, Eugenio Pérez wrote:
> Vhost did not reset properly the batched descriptors on SET_VRING_BASE
> event. Because of that, is possible to return an invalid descriptor to
> the guest.
> 
> This series ammend this, resetting them every time backend changes, and
> creates a test to assert correct behavior. To do that, they need to
> expose a new function in virtio_ring, virtqueue_reset_free_head, only
> on test code.
> 
> Another useful thing would be to check if mutex is properly get in
> vq private_data accessors. Not sure if mutex debug code allow that,
> similar to C++ unique lock::owns_lock. Not acquiring in the function
> because caller code holds the mutex in order to perform more actions.

I pushed vhost branch with patch 1, pls send patches on top of that!

> v3:
> * Rename accesors functions.
> * Make scsi and test use the accesors too.
> 
> v2:
> * Squashed commits.
> * Create vq private_data accesors (mst).
> 
> This is meant to be applied on top of
> c4f1c41a6094582903c75c0dcfacb453c959d457 in
> git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git.
> 
> Eugenio Pérez (5):
>   vhost: Create accessors for virtqueues private_data
>   tools/virtio: Add --batch option
>   tools/virtio: Add --batch=random option
>   tools/virtio: Add --reset=random
>   tools/virtio: Make --reset reset ring idx
> 
> Michael S. Tsirkin (3):
>   vhost: option to fetch descriptors through an independent struct
>   vhost: use batched version by default
>   vhost: batching fetches
> 
>  drivers/vhost/net.c          |  28 ++--
>  drivers/vhost/scsi.c         |  14 +-
>  drivers/vhost/test.c         |  69 ++++++++-
>  drivers/vhost/test.h         |   1 +
>  drivers/vhost/vhost.c        | 271 +++++++++++++++++++++++------------
>  drivers/vhost/vhost.h        |  44 +++++-
>  drivers/vhost/vsock.c        |  14 +-
>  drivers/virtio/virtio_ring.c |  29 ++++
>  tools/virtio/linux/virtio.h  |   2 +
>  tools/virtio/virtio_test.c   | 123 ++++++++++++++--
>  10 files changed, 456 insertions(+), 139 deletions(-)
> 
> -- 
> 2.18.1

