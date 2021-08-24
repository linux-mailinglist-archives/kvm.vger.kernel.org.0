Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B803F5BA4
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 12:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236022AbhHXKG1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 06:06:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33317 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235933AbhHXKG0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Aug 2021 06:06:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629799542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=acXZTsv+ZGRCIMsgyzotp4JqHaREWpj8Vd1U498dQK8=;
        b=WBzmgeo4tq7NZN8G5eTa7GoNWaKzJHS8oizDsLqQrT4qk8dKgqMIpcenyxdN82jwNqlTud
        uQfAJpqIsphChX8LizRaGX9TxDv4BjhALTwTSU4bTyMP6o5+odyTrpqigOHZkK/8Z4pIwI
        eB45wl7XMTM/6XXcm/iOwb9w6kFTO7k=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-vdnEUR5FOi-INKKK8xu_QQ-1; Tue, 24 Aug 2021 06:05:27 -0400
X-MC-Unique: vdnEUR5FOi-INKKK8xu_QQ-1
Received: by mail-ej1-f71.google.com with SMTP id r21-20020a1709067055b02904be5f536463so6854246ejj.0
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 03:05:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=acXZTsv+ZGRCIMsgyzotp4JqHaREWpj8Vd1U498dQK8=;
        b=Re2A7ECtbPlsCixMzwW95/8f3k1wHTxfZrTFDTcWp7Db1EvBkj2ekw5tR2lVmY41ht
         WhEm2BQd+rKZcYi2iKhECoYbbwSWQkNYOBtgU3Q0u3MIZEABawp7ilWJ1f5vPgaXjnVf
         iqxUhofJ56lzVcK/U2/+xD5nqsPyPCzaeK4lUZNQoyW4ldvrDVqhVwYlJc2Qf3k5QhGt
         OT+X+PYSIWwuV44B/gYD/K7iBiE1HItlDD0pUZSkrU4Rl4fy4yTKrwMuaVqDpA8oCwwS
         i7ZjxsitLSaVJbldxj1hEWHkMGGlOqFF5FpEqlsP1OId2Q1PJVO5A3Rte0edBtp3VI1G
         cgvg==
X-Gm-Message-State: AOAM5303qAP2UQwJm1L76T1rBit4Xrk2mcYNk+N1r1MD7wZryzEZ+x/v
        WySjUy9G8uD0qdM9Xzvd0ReSJyRy39cLGJYYR3z0+AqOWuH1EOn6LLw3sp1Xh/6PlkPidcJDDWH
        8YD9VJaYhNmNu
X-Received: by 2002:a05:6402:5206:: with SMTP id s6mr42111217edd.151.1629799526306;
        Tue, 24 Aug 2021 03:05:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzI44Z4judGCzN7R2zpOlFSwZBSbEmkd/UBfNZmHvvZCXJIff7B6uB+tsb4YfaMzeFQo6RVNA==
X-Received: by 2002:a05:6402:5206:: with SMTP id s6mr42111185edd.151.1629799526106;
        Tue, 24 Aug 2021 03:05:26 -0700 (PDT)
Received: from steredhat (host-79-45-8-152.retail.telecomitalia.it. [79.45.8.152])
        by smtp.gmail.com with ESMTPSA id k21sm8853122ejj.55.2021.08.24.03.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 03:05:25 -0700 (PDT)
Date:   Tue, 24 Aug 2021 12:05:23 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v3 0/6] virtio/vsock: introduce MSG_EOR flag for
 SEQPACKET
Message-ID: <20210824100523.yn5hgiycz2ysdnvm@steredhat>
References: <20210816085036.4173627-1-arseny.krasnov@kaspersky.com>
 <3f3fc268-10fc-1917-32c2-dc0e7737dc48@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <3f3fc268-10fc-1917-32c2-dc0e7737dc48@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Arseny,

On Mon, Aug 23, 2021 at 09:41:16PM +0300, Arseny Krasnov wrote:
>Hello, please ping :)
>

Sorry, I was off last week.
I left some minor comments in the patches.

Let's wait a bit for other comments before next version, also on the 
spec, then I think you can send the next version without RFC tag.
The target should be the net-next tree, since this is a new feature.

Thanks,
Stefano

