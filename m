Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 639933379BE
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 17:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhCKQmz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 11:42:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41507 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229901AbhCKQmp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Mar 2021 11:42:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615480964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Va1ZOtanAw2n/6dRqr+9ZkAc2XTPpNeFM2MzXmR/KFc=;
        b=jPi7sidgC2l9zhoYFVD9ZaW84WNIqDQonyIBBhyFbY9zX4/s67FYyiig8cfiHG9IP5YJsD
        pxcUCIiQAohyk/BmYDXE9GriiIAbKgey3VWyQzkeYU0I8Pvp5XYtvBNIJ2pCvuH2moP1rZ
        bfFPXOSUp5PQ2MPrUltTsrep/n2fRbY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-81-BvqiskchMVCMiRcAowO1ZQ-1; Thu, 11 Mar 2021 11:42:41 -0500
X-MC-Unique: BvqiskchMVCMiRcAowO1ZQ-1
Received: by mail-wm1-f70.google.com with SMTP id a63so1683873wmd.8
        for <kvm@vger.kernel.org>; Thu, 11 Mar 2021 08:42:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Va1ZOtanAw2n/6dRqr+9ZkAc2XTPpNeFM2MzXmR/KFc=;
        b=cVpr0s/MMpqFlPI2e/Ls4k7yYU6zPB7DvKNCKNdOxpwC4nLL+P2/mfoH9CBNxGcV8L
         5MAwNGOFliQwItYlxQyupAXmh4P9DOpJj9rtxczMVH2MCJIUzq+55V9CrFF801pvv8qQ
         nC8rYqpeuWWay58p/h0tc/D8MJrFDejRTxScboQUnQ1IUEpyz+6yz15Yz0i1osUYSYV3
         OrQb1dtCDkRwSihsldKhO4Xn/bhXOelhKywN2YlMLrqmhbjJHpJzut5EylAhb2Cd/WVI
         Hc3wyx/OiY9mDl+403VijS4m9rq05z3WdcXFk01LYL5V6Qb854EWLX+r+nyagI6AkRnD
         BoTg==
X-Gm-Message-State: AOAM532nk++i9LgxjPK4D4dkJDNOtoxV56GL/dAnlG30Q5n7yoMlKbAM
        w9G6Pe1rx4yTXQBPJiBo55zPlB4Ci0IizGM7vVUCCZT829kOnt1GWpn8hAgzjjZT52r8Djq2i6h
        jbAOQ/we00Wad
X-Received: by 2002:a7b:ce19:: with SMTP id m25mr9125885wmc.74.1615480960098;
        Thu, 11 Mar 2021 08:42:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwQzxGktgJgEENYc14fEDmcQqXqPEFE3sW2SOPsGR0u/IFDM4kuQ4raenTl/7wrfSpgSACISg==
X-Received: by 2002:a7b:ce19:: with SMTP id m25mr9125870wmc.74.1615480959923;
        Thu, 11 Mar 2021 08:42:39 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id z25sm4897002wmi.23.2021.03.11.08.42.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 08:42:39 -0800 (PST)
Date:   Thu, 11 Mar 2021 11:42:36 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 0/2] vhost-vdpa: fix issues around v->config_ctx handling
Message-ID: <20210311114217-mutt-send-email-mst@kernel.org>
References: <20210311135257.109460-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311135257.109460-1-sgarzare@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 11, 2021 at 02:52:55PM +0100, Stefano Garzarella wrote:
> While writing a test for a Rust library [1] to handle vhost-vdpa devices,
> I experienced the 'use-after-free' issue fixed in patch 1, then I
> discovered the potential issue when eventfd_ctx_fdget() fails fixed in
> patch 2.
> 
> Do you think it might be useful to write a vdpa test suite, perhaps using
> this Rust library [2] ?
> Could we put it in the kernel tree in tool/testing?

I can add tools/vdpa, no problem ...

> Thanks,
> Stefano
> 
> [1] https://github.com/stefano-garzarella/vhost/tree/vdpa
> [2] https://github.com/rust-vmm/vhost
> 
> Stefano Garzarella (2):
>   vhost-vdpa: fix use-after-free of v->config_ctx
>   vhost-vdpa: set v->config_ctx to NULL if eventfd_ctx_fdget() fails
> 
>  drivers/vhost/vdpa.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> -- 
> 2.29.2

