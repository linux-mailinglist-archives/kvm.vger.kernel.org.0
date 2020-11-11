Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B77F2AEEFD
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 11:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbgKKKum (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 05:50:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42312 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725925AbgKKKuj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Nov 2020 05:50:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605091838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mnA7XsiGSJFXhW6YNgCg1O0O0+tMAkowMzr0RmATALo=;
        b=ZnvTuVK5FsVtsj2ls3L/0j1BBP2vJyBJjMhgaPFm6y6lcyHGhJ2JGCo0xgQ+RR4vcgHZdq
        wB/sdqf4X/BbGI5m4qwy+vBkYecNF0kf9GjMQaiA9cHHtY4ne8deTWlDNNHHgzkIaCPiPg
        gF1Z1MWx7XWKB0d/hyLmtOyppTGU6NE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-qQq5v6yaNU-mbvOPFDX2dg-1; Wed, 11 Nov 2020 05:50:36 -0500
X-MC-Unique: qQq5v6yaNU-mbvOPFDX2dg-1
Received: by mail-wr1-f69.google.com with SMTP id w17so455815wrp.11
        for <kvm@vger.kernel.org>; Wed, 11 Nov 2020 02:50:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mnA7XsiGSJFXhW6YNgCg1O0O0+tMAkowMzr0RmATALo=;
        b=XY12h40khY76kHrm1dc07fBn0NbCRx0M3jxoipkSyW3F0mC/cnwvutB3kERMlFNvTm
         zssy9q/zY11gAPyEENZV7hhODJtrTgNbCbknF/doj1V0aN7miknd37errGyJQrDg+HID
         I9yP9L/sh48DaX5k84OyzWjLxbX3Z1+mC9Mb0NXgxjCwKM2WL8NePYmLW++wRXzR+Fkr
         hPrSuIgSIU46XktXHW1uhQJ+fdyke/rX3/xOiet4gdrM7VBWYgbYuv5ZAdtecx6mfYB2
         oXE/El1/rbYrA0CcyIL5f3kyHUSURhLlaim5fdi67wikVEWzd+Gv3pLxxOOcGtDKuqh9
         vqPQ==
X-Gm-Message-State: AOAM530i/rTswc6iyHn8I3UWiVIzNZuvb7KcK2kkTougHRigK0rtttt/
        kRqAqUalIUYCCzMpHIr6p0CgTrDC7rfbUftU7r8zWOIyfkXtcLIOSYMOCiZV6Q8raIm+Fr5r4XC
        MvEGZYt4yvj9+
X-Received: by 2002:adf:eeca:: with SMTP id a10mr24970192wrp.186.1605091835504;
        Wed, 11 Nov 2020 02:50:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxz4TPJxgCHN7vv+R3d7jzN9KDvG9vgiS4za2+hlcdJRS27vg4GofYWp6iFMLk0C1lnkV/R+w==
X-Received: by 2002:adf:eeca:: with SMTP id a10mr24970172wrp.186.1605091835295;
        Wed, 11 Nov 2020 02:50:35 -0800 (PST)
Received: from steredhat (host-79-47-126-226.retail.telecomitalia.it. [79.47.126.226])
        by smtp.gmail.com with ESMTPSA id p4sm2017826wrm.51.2020.11.11.02.50.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 02:50:34 -0800 (PST)
Date:   Wed, 11 Nov 2020 11:50:31 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Tian Tao <tiantao6@hisilicon.com>
Cc:     mst@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost_vdpa: switch to vmemdup_user()
Message-ID: <20201111105031.mtdbvt7grkxeuwn4@steredhat>
References: <1605057288-60400-1-git-send-email-tiantao6@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1605057288-60400-1-git-send-email-tiantao6@hisilicon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 11, 2020 at 09:14:48AM +0800, Tian Tao wrote:
>Replace opencoded alloc and copy with vmemdup_user()
>
>Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
>---
> drivers/vhost/vdpa.c | 10 +++-------
> 1 file changed, 3 insertions(+), 7 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>index 2754f30..4c39583 100644
>--- a/drivers/vhost/vdpa.c
>+++ b/drivers/vhost/vdpa.c
>@@ -245,14 +245,10 @@ static long vhost_vdpa_set_config(struct vhost_vdpa *v,
> 		return -EFAULT;
> 	if (vhost_vdpa_config_validate(v, &config))
> 		return -EINVAL;
>-	buf = kvzalloc(config.len, GFP_KERNEL);
>-	if (!buf)
>-		return -ENOMEM;
>
>-	if (copy_from_user(buf, c->buf, config.len)) {
>-		kvfree(buf);
>-		return -EFAULT;
>-	}
>+	buf = vmemdup_user(c->buf, config.len);
>+	if (IS_ERR(buf))
>+		return PTR_ERR(buf);
>
> 	ops->set_config(vdpa, config.off, buf, config.len);
>
>-- 
>2.7.4
>

