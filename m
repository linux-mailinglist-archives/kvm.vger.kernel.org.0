Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB444010A3
	for <lists+kvm@lfdr.de>; Sun,  5 Sep 2021 17:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237418AbhIEPvX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Sep 2021 11:51:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29989 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234447AbhIEPvW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 5 Sep 2021 11:51:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630857018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dt3+lUrr17xrCqRRoNhFo4SoQOQwGb+2P4GqnUIMZG4=;
        b=IijXAQqeJQVkWJv5BjwkNQiwwNw32alX9PdHKY7ogztPUvGZ8kK2pa80DD59021DtwF3wk
        vnn7p4vVJ0j2aaI4Rd9gVdGlARJYOQywh0r5Iwq9fkaIfOVuCZnxj1xiVXx42y/eoJa7jT
        T4y+PRw0xkcVhezVPUx2Aw4QIXme58g=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-j6q35e5NMTywUKAoQa8kFA-1; Sun, 05 Sep 2021 11:50:17 -0400
X-MC-Unique: j6q35e5NMTywUKAoQa8kFA-1
Received: by mail-ed1-f72.google.com with SMTP id b8-20020a056402350800b003c5e3d4e2a7so2452066edd.2
        for <kvm@vger.kernel.org>; Sun, 05 Sep 2021 08:50:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dt3+lUrr17xrCqRRoNhFo4SoQOQwGb+2P4GqnUIMZG4=;
        b=DGponOGR9HoTDW3Bchi3IvqPQiy4wf8QhpDDi69Jgy6B5fjpm4tB7UlL3ZDyEdDJdy
         n8cAueR5wGW82aRhJPFhhZcrCmOuF7CUrfbaL0fUHLW8fueYbyt1dZ3uMi3HBjfWfU1n
         BtT6t01q97pLL7k351T+yelVqFvk5Mw/hG7Epp9Qh2MQ1DFTgx+HkKCWk+A1webB/E56
         NavdmyYX4q1MvCrOvHPVNEVXqHRL4RP/PfUSdpWPttHXotahNoZsfZiHj3AC0/XgVRSB
         BVirCCbTUG2e5MJxgH+q2oZ+GvGfh+uLNLzd1frXfDpWpxnmNOU8J/kHKyAD+A/THqFq
         raJQ==
X-Gm-Message-State: AOAM532yDZwDuYDefTWxCeUYlsD5p1F1m8fMlQhOWuANLb9Mmp24rKMv
        rmDN4cOYx4BlJJyVwBQJ075PDtFAYR/srhS6537gFBfXYGixdAe029L3y7PGvUsSL+9lVudQ0nw
        iWE2ZppGmcanj
X-Received: by 2002:aa7:c514:: with SMTP id o20mr9209155edq.318.1630857016058;
        Sun, 05 Sep 2021 08:50:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/Vr1hTVx3/Sty6LNqcZMAJAOmpd1FUx3LtNW8reY+9FMDFhx51QrJugo5epYEB0BNnX/rsw==
X-Received: by 2002:aa7:c514:: with SMTP id o20mr9209144edq.318.1630857015928;
        Sun, 05 Sep 2021 08:50:15 -0700 (PDT)
Received: from redhat.com ([2.55.131.183])
        by smtp.gmail.com with ESMTPSA id g18sm2495519ejr.99.2021.09.05.08.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 08:50:15 -0700 (PDT)
Date:   Sun, 5 Sep 2021 11:50:11 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [PATCH net-next v4 2/6] virtio/vsock: add 'VIRTIO_VSOCK_SEQ_EOR'
 bit.
Message-ID: <20210905115002-mutt-send-email-mst@kernel.org>
References: <20210903061353.3187150-1-arseny.krasnov@kaspersky.com>
 <20210903061523.3187714-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210903061523.3187714-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 03, 2021 at 09:15:20AM +0300, Arseny Krasnov wrote:
> This bit is used to handle POSIX MSG_EOR flag passed from
> userspace in 'send*()' system calls. It marks end of each
> record and is visible to receiver using 'recvmsg()' system
> call.
> 
> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Spec patch for this?

> ---
>  include/uapi/linux/virtio_vsock.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
> index 8485b004a5f8..64738838bee5 100644
> --- a/include/uapi/linux/virtio_vsock.h
> +++ b/include/uapi/linux/virtio_vsock.h
> @@ -98,6 +98,7 @@ enum virtio_vsock_shutdown {
>  /* VIRTIO_VSOCK_OP_RW flags values */
>  enum virtio_vsock_rw {
>  	VIRTIO_VSOCK_SEQ_EOM = 1,
> +	VIRTIO_VSOCK_SEQ_EOR = 2,
>  };
>  
>  #endif /* _UAPI_LINUX_VIRTIO_VSOCK_H */
> -- 
> 2.25.1

