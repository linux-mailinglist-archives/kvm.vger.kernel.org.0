Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6F63F90A7
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 01:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243771AbhHZWVx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 18:21:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51678 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243760AbhHZWVx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 18:21:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630016465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R9XYA7XQIbgj6yTa9gEwI7Al7AUR6wHQxBjRY/YP3us=;
        b=AqVSOVoYkCZk4VJUoLzDOa/0IzHXZ+0nn0CuOfzYjBeNSiZdYBiEI7jie4l8mmFrPQmKOL
        dGWVeDtWpWGaKcGHGSR+ItskPetJNyawoDG07t1fe/VhVGGT1P9sWX2JB5U1T0kUvQ6T5e
        XP9JKrMyXXdIxYuQ8ECBkKxdm0Oeb1I=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-QNJ7QB-CPqGF3B9o7NwF4w-1; Thu, 26 Aug 2021 18:21:03 -0400
X-MC-Unique: QNJ7QB-CPqGF3B9o7NwF4w-1
Received: by mail-oi1-f197.google.com with SMTP id s9-20020a056808208900b002694a72eed5so2266880oiw.20
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 15:21:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R9XYA7XQIbgj6yTa9gEwI7Al7AUR6wHQxBjRY/YP3us=;
        b=tloyHRvZ8DIdIHAlBPSL7njeo84lK5sQ7CQZ3lqu2CRD75dttK4Tv8cOkQ0cp34bLD
         KwMUhnVTRmAUNtWSLLmQc16GRgO9FnNdz9i9zsiTipOCKdhdQVuIbfLRLVjRmMb0AUM/
         /zFoFJlTAKGZBSVgM8XB2MAXvoIn5l+VW+Dhh+IUcv2Kp9uXXrBqgs1HMCtn4TT6JYb5
         UyWpbsSo7omThs8SkRKQBDSrDA9nQu1ebfb56kUEJerlxfTKagfuiuoH/n5tOcOaUX3y
         jnDVA8bFDf8e+4UIMxoknH2mSiFjERy4H9DWrXWxWoRmtr5mVGuwHflAEGD/AIs5+rWQ
         7bvw==
X-Gm-Message-State: AOAM5301fBGyhvSRTAF4SNWaT/aq7zDwYZzWPGQ4UV6dF9ErBaJjEsIk
        MxNd0UYdMa8ny/nFfJIZn1NMAXcJKPMuI9QWmYVYJww14YJQMkjdWuosbdLAfiEgeXSIl0URtS8
        BQBjL1TqUVE4V
X-Received: by 2002:aca:4589:: with SMTP id s131mr4227912oia.121.1630016462886;
        Thu, 26 Aug 2021 15:21:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyLl+A5JJ8qehvfB/pqW4aNbCzzhvlaGBvf07+8wNrWRzNqcnZPuTSdjNbL/QrstLb5IWWlZQ==
X-Received: by 2002:aca:4589:: with SMTP id s131mr4227903oia.121.1630016462756;
        Thu, 26 Aug 2021 15:21:02 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id z7sm877035oti.65.2021.08.26.15.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 15:21:02 -0700 (PDT)
Date:   Thu, 26 Aug 2021 16:21:01 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Anthony Yznaga <anthony.yznaga@oracle.com>
Cc:     kvm@vger.kernel.org, steven.sistare@oracle.com
Subject: Re: [PATCH v3] vfio/type1: Fix vfio_find_dma_valid return
Message-ID: <20210826162101.53e0ae9f.alex.williamson@redhat.com>
In-Reply-To: <1629736550-2388-1-git-send-email-anthony.yznaga@oracle.com>
References: <1629736550-2388-1-git-send-email-anthony.yznaga@oracle.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 23 Aug 2021 09:35:50 -0700
Anthony Yznaga <anthony.yznaga@oracle.com> wrote:

> vfio_find_dma_valid is defined to return WAITED on success if it was
> necessary to wait.  However, the loop forgets the WAITED value returned
> by vfio_wait() and returns 0 in a later iteration.  Fix it.
> 
> Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
> Reviewed-by: Steve Sistare <steven.sistare@oracle.com>
> 
> ---
> v3:
>   use Steve Sistare's suggested commit text and add his R-b
> v2:
>   use Alex Williamson's simplified fix
> 
>  drivers/vfio/vfio_iommu_type1.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Applied to vfio next branch for v5.15.  Thanks,

Alex

