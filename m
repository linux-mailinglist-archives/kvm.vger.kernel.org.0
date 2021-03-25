Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7AF348D40
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 10:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbhCYJnF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 05:43:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49806 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229900AbhCYJmy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 05:42:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616665374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iazG2kvbVV7z7jI0Hl0WMxl3hq3T9QCm0mrnWD6S1vM=;
        b=HZTTwqpzI5d25dA+u+5V1+FbZO0bikzsheye5w95tALiqhsMxz7v6633IuXdbfPj5LanJl
        SEOvIrzH0fPCep8L3dTPaDgwJ63xtOpmmDqozhrEbV9rcBZq0oNVNBl8g8PhGU76hbYYzj
        ntTA+Qs8qgwjyxUjcy0I/fEvZO0dqI0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-9zBeL4SqOEW54UGEi9LnYg-1; Thu, 25 Mar 2021 05:42:52 -0400
X-MC-Unique: 9zBeL4SqOEW54UGEi9LnYg-1
Received: by mail-wr1-f70.google.com with SMTP id z17so2374057wrv.23
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 02:42:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iazG2kvbVV7z7jI0Hl0WMxl3hq3T9QCm0mrnWD6S1vM=;
        b=p8S97F+vvLZQKPeqx1w/C4gXs/GxhMFwyUUddy/iesRqmvMucObr0sFvJhoZbyIjPq
         ynh7yf2vJhdELpSwd6DMj1/+AZ4ysDRfEAi5n+aD+w+V1CM5TCAEHGneS05EXnd01tTj
         DUQuI0c1UG1UJffWVEkUts4hwDTHNq3aO8ss1QtmrBb2Wb30W41h40NUdqEV1q64b6Qm
         3BtUfkrlsZTQLSfcprIqfTTwwlRk1qKujqByj5u37MgV1X22sBhaU6QHVWBSYlRtJ/nD
         pGsxJiaNlFudiOTVDhE+ilRgZXCGzsWcyjh+kzkPX6tA/NmOyyfIEo47XZ9EXXSLlmdX
         k7DA==
X-Gm-Message-State: AOAM533Ob52tcFNcp906FiehNWHAXvxHnLUKM2IUNtKyY/8U5LAje1l5
        fXzqARRRWQtSweokL5Pvm9LUflj6PenRPgUmQ2Q4CnsZCnwcOzXRlsQUuVjwgvOQxB5teL1u+Ki
        ZPx1lYPyOnLoI
X-Received: by 2002:a5d:4e0e:: with SMTP id p14mr7877651wrt.64.1616665370845;
        Thu, 25 Mar 2021 02:42:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxmI0XTmVVlZKGjXd72cRR6QIqVv7OMV2LK555R2VZPMAHPAdbuj1iy4hwRCKLYd5iX47irTg==
X-Received: by 2002:a5d:4e0e:: with SMTP id p14mr7877623wrt.64.1616665370676;
        Thu, 25 Mar 2021 02:42:50 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id j13sm7019686wrt.29.2021.03.25.02.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 02:42:50 -0700 (PDT)
Date:   Thu, 25 Mar 2021 10:42:47 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Jeff Vander Stoep <jeffv@google.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v7 06/22] af_vsock: implement send logic for SEQPACKET
Message-ID: <20210325094247.np2hdgwzgcjpgsia@steredhat>
References: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
 <20210323131045.2460319-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210323131045.2460319-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 04:10:42PM +0300, Arseny Krasnov wrote:
>This adds some logic to current stream enqueue function for SEQPACKET
>support:
>1) Use transport's seqpacket enqueue callback.
>2) Return value from enqueue function is whole record length or error
>   for SOCK_SEQPACKET.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> v6 -> v7:
> 'seqpacket_enqueue' callback interface changed, 'flags' argument was
> removed, because it was 'msg_flags' field of 'msg' argument which is
> already exists.
>
> include/net/af_vsock.h   |  2 ++
> net/vmw_vsock/af_vsock.c | 21 +++++++++++++++------
> 2 files changed, 17 insertions(+), 6 deletions(-)


Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

