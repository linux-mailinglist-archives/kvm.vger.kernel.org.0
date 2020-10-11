Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBCF28A60F
	for <lists+kvm@lfdr.de>; Sun, 11 Oct 2020 08:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgJKGrB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Oct 2020 02:47:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40098 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728686AbgJKGq7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 11 Oct 2020 02:46:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602398818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e9DBg94y3dH4K7OJQw3QhobflJnhMnjEF2bmY+pjq5A=;
        b=OFCWahH1n9KRH6eiNbA2SLjxeSKoz2gE8hQi+rVnmvTDfzpT5sXK3od2ATBbdJUkG44cfF
        iBCZiGQ1uofQvUoWi++spnzcNCjbq3KPQu8qZS+uHphVrCgCNt9KSwmyxmQkvWBveuKaKf
        sHnJxC9Eyz53sISNZAWvjqcxzbZqAwA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138-ifyxuR1NMb6-_I6943wdLw-1; Sun, 11 Oct 2020 02:46:54 -0400
X-MC-Unique: ifyxuR1NMb6-_I6943wdLw-1
Received: by mail-wm1-f70.google.com with SMTP id g125so5198884wme.1
        for <kvm@vger.kernel.org>; Sat, 10 Oct 2020 23:46:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=e9DBg94y3dH4K7OJQw3QhobflJnhMnjEF2bmY+pjq5A=;
        b=sh7B0zXXQ4feCJrc+L4zwByFR1ozYzqJzdFrpi6NSI7zp9ncgI+mPxp2AsxHOBtbdq
         GXe+SL2jGnzs93/udQlen3LEmoMDIbIJTBjlg5CbztQuxj1BWdi1IhDCUTuOjgebwqwN
         UE7abj+yUOdKVY78//IjZ3lPfwNaTKp78VjDVndXy+YM0f1uPCl+5ArsVJFD57h/+UGf
         YXX7PUjn3/LsYnsScxISqWXBMK4SKwU6jw9P0gD7NHWU4Z7mVExcjr0zThoviXzDqTTc
         XAywoNoXWxAk67F5wXXadPSzxFl6i3LrfCx9z+O9AsI6LYWUORECejlCOXdxBkPPWOcn
         dZuA==
X-Gm-Message-State: AOAM531q2MHPO6X8CmzIvuPU2thjXSKkQGTVPLLmFy2EO3lkEomyeNR5
        LOcp2nVLuQ7vLOqu5jfH9IfN+FUY70TWdPzmbWJ3FE7i4Zv7sCrzlBXTnvY8STsdZTjg2ghBWzi
        pl7n8FEyfjjRg
X-Received: by 2002:a1c:a513:: with SMTP id o19mr5421306wme.130.1602398813151;
        Sat, 10 Oct 2020 23:46:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyM5mr9XODNM/0FDfdYSqdgaQBm+SlNnogDVtVm9qnwQtawYEdi+JIuDir297EELqzQhHaTMQ==
X-Received: by 2002:a1c:a513:: with SMTP id o19mr5421290wme.130.1602398812957;
        Sat, 10 Oct 2020 23:46:52 -0700 (PDT)
Received: from redhat.com (bzq-79-179-76-41.red.bezeqint.net. [79.179.76.41])
        by smtp.gmail.com with ESMTPSA id j5sm14175503wrx.88.2020.10.10.23.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 23:46:52 -0700 (PDT)
Date:   Sun, 11 Oct 2020 02:46:49 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Greg Kurz <groug@kaod.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qemu-devel@nongnu.org,
        Laurent Vivier <laurent@vivier.eu>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH v3 2/3] vhost: Use vhost_get_used_size() in
 vhost_vring_set_addr()
Message-ID: <20201011024636-mutt-send-email-mst@kernel.org>
References: <160171888144.284610.4628526949393013039.stgit@bahia.lan>
 <160171932300.284610.11846106312938909461.stgit@bahia.lan>
 <5fc896c6-e60d-db0b-f7b0-5b6806d70b8e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5fc896c6-e60d-db0b-f7b0-5b6806d70b8e@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 10, 2020 at 10:32:13AM +0800, Jason Wang wrote:
> 
> On 2020/10/3 下午6:02, Greg Kurz wrote:
> > The open-coded computation of the used size doesn't take the event
> > into account when the VIRTIO_RING_F_EVENT_IDX feature is present.
> > Fix that by using vhost_get_used_size().
> > 
> > Signed-off-by: Greg Kurz <groug@kaod.org>
> > ---
> >   drivers/vhost/vhost.c |    3 +--
> >   1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index c3b49975dc28..9d2c225fb518 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -1519,8 +1519,7 @@ static long vhost_vring_set_addr(struct vhost_dev *d,
> >   		/* Also validate log access for used ring if enabled. */
> >   		if ((a.flags & (0x1 << VHOST_VRING_F_LOG)) &&
> >   			!log_access_ok(vq->log_base, a.log_guest_addr,
> > -				sizeof *vq->used +
> > -				vq->num * sizeof *vq->used->ring))
> > +				       vhost_get_used_size(vq, vq->num)))
> >   			return -EINVAL;
> >   	}
> > 
> > 
> 
> Acked-by: Jason Wang <jasowang@redhat.com>

Linus already merged this, I can't add your ack, sorry!

