Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFDD39037E
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 16:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233802AbhEYOJy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 10:09:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51941 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233797AbhEYOJw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 May 2021 10:09:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621951701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C6JWIrp1X2QWT7DZ7p/eDKEr77BtjgN6Key1F3L5mgM=;
        b=f3AQB1bHkg5LrhYmjn5C8ikKaaBEJgO/ngnBvzZo1ocCmbrF409Pylcpqx9h5Ky0xgvgRH
        YGbVsYOYtPhKvd1GSxRYZb9ummfp1RhkwFe7mbPuxD1JvGEnQ62X5zusVi2olXagmTiWfw
        OrRnQ7XSH7wtLb22EHmAcZNTGcoa2J0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-8McpjtcYPg2wI0EitHmlyg-1; Tue, 25 May 2021 10:08:20 -0400
X-MC-Unique: 8McpjtcYPg2wI0EitHmlyg-1
Received: by mail-ej1-f70.google.com with SMTP id z1-20020a1709068141b02903cd421d7803so8853535ejw.22
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 07:08:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C6JWIrp1X2QWT7DZ7p/eDKEr77BtjgN6Key1F3L5mgM=;
        b=G0YfLwE27S+mRkEaRZFDcWyl0h45qecy6LbV/y6vW4nyMnu2A2kqYQSUUrS7SJ2tBF
         QrcZ0/r3TOGGluF0OZvFHoiiibwjrUf3TQTmln/QBQB68YvxVP9oD/Q5aBRt3iV7nfwF
         lcGnrJHbDw85DYcxJKBegRGiQ3be9xMoG9f/90rFkQT702aHB5E13I6q+YyOe+c8C0P0
         FRQgwocls9iHXfNwTn9bi6v84rl0uxKEPMS3fNhWiPCWTKg7MD0bzILblbg5lbO09xtr
         Y4PVrloax4G0OBzni8kKRndDAJ/8/FLZkxZ5GK/g/gre/Fm+/Y5aJ6y5j5BgrBVt1gKW
         97FA==
X-Gm-Message-State: AOAM531ehd8PaAnk1MaXXss7734ZwqaE8zhiIgvMoRaqVDEgLWIH2Lj5
        8yCGkSfRuOM2ds4gCpK/CCLgacX2X5qu0OdaytWF+3CThYHUBSpnPM6mFCkkzX2p+SI9sm5p01v
        pj4rmW9ne7pSM
X-Received: by 2002:a17:907:1b11:: with SMTP id mp17mr29324488ejc.1.1621951699033;
        Tue, 25 May 2021 07:08:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJ8NCBc55GgItfBceAaBuINHwCsxN0ByhZnfYq7Pj5KNr0oNXheshEkj931t4BMHAxbsJicQ==
X-Received: by 2002:a17:907:1b11:: with SMTP id mp17mr29324460ejc.1.1621951698877;
        Tue, 25 May 2021 07:08:18 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id gt12sm9078897ejb.60.2021.05.25.07.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 07:08:18 -0700 (PDT)
Date:   Tue, 25 May 2021 16:08:16 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, oxffffaa@gmail.com
Subject: Re: [PATCH v10 04/18] af_vsock: implement SEQPACKET receive loop
Message-ID: <20210525140816.btiv5v6e3vguxxun@steredhat>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
 <20210520191611.1271204-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210520191611.1271204-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 20, 2021 at 10:16:08PM +0300, Arseny Krasnov wrote:
>Add receive loop for SEQPACKET. It looks like receive loop for
>STREAM, but there are differences:
>1) It doesn't call notify callbacks.
>2) It doesn't care about 'SO_SNDLOWAT' and 'SO_RCVLOWAT' values, because
>   there is no sense for these values in SEQPACKET case.
>3) It waits until whole record is received or error is found during
>   receiving.
>4) It processes and sets 'MSG_TRUNC' flag.
>
>So to avoid extra conditions for two types of socket inside one loop, two
>independent functions were created.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> v9 -> v10:
> 1) Use 'msg_data_left()' instead of direct access to 'msg_hdr'.
>
> include/net/af_vsock.h   |  4 +++
> net/vmw_vsock/af_vsock.c | 72 +++++++++++++++++++++++++++++++++++++++-
> 2 files changed, 75 insertions(+), 1 deletion(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

