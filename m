Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0363E32A781
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449246AbhCBQQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:16:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27329 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1573021AbhCBOIb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 09:08:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614694023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9ZZPA/RjfCV3cwHtIqxM2nNGL0XO9fFuMgdZl9YFKtA=;
        b=Wt07/MV6rsiGHfhXKJvCIYzJKfCteUVeqosAbaPUN0e45qVS80gSaLQd/83uNDwP5cuvaS
        VxcqMShukMa3tonBlxGK6SFe/cAG+Od4TNLWCSFY9DdvQGXcj0nc9n8pcqAGocTkEPZqDE
        9DVnGPuW0SRDRpEYQwXuGHR6BDwugv4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-70fuzWFGOUmhMo4IWbqhpA-1; Tue, 02 Mar 2021 09:06:59 -0500
X-MC-Unique: 70fuzWFGOUmhMo4IWbqhpA-1
Received: by mail-wm1-f72.google.com with SMTP id w10so733798wmk.1
        for <kvm@vger.kernel.org>; Tue, 02 Mar 2021 06:06:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=9ZZPA/RjfCV3cwHtIqxM2nNGL0XO9fFuMgdZl9YFKtA=;
        b=a2OWGGPS9p86uSjwwP9bx5658KZQmSkNuRH8SGqWoVV68jxF0gy/IhQ2VpUWwzJZtG
         y3zXK5X9I5k3riFSB2suKqPs7CZgCueD2a6CLBOBeyaHVxp7QNk+9J0FAAX0Dx4RXsLo
         mIM7g3gT/CG3pHvhtZQcYobwFB0llyWzhOA2HlPrY0hcWI7vvRsEWnO4tVAF4KmsW0AA
         M0mqLg7WBbw8N/HB1iiWqdJjowxxWgwCQcIfBMurf7GuOnP/n9kS2VMtkCPuXbYxIss+
         L8AS7ELnaPqwgmMx1g7IA3AWmKeV4qFe4f/As5Zun0Jox3WaN6+hilxnqubY/70QEyLs
         1lzw==
X-Gm-Message-State: AOAM532NtoAeDHOBBD6paFJQrqKf4URWSGWeBl3LEXM6BDAFXZJ8P68q
        On0AQcvGmBQ+oGjm5wrIiFGZ2PneZvZMusgm3Jbasoj0ycdsaBkpTBC6PKcIvASnnoXDKbXsNtu
        A5l3WokOJJGdJ
X-Received: by 2002:adf:e603:: with SMTP id p3mr19332951wrm.360.1614694017990;
        Tue, 02 Mar 2021 06:06:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxPGvxaY2j2NNhchVLownsWlN5RsZOvtKftuEEVsTkK4Mn+YSpvgBcb/lnrmcwYWFG9dj3inA==
X-Received: by 2002:adf:e603:: with SMTP id p3mr19332896wrm.360.1614694017534;
        Tue, 02 Mar 2021 06:06:57 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id o20sm745021wmq.5.2021.03.02.06.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 06:06:57 -0800 (PST)
Date:   Tue, 2 Mar 2021 15:06:54 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [RFC PATCH 10/10] vhost/vdpa: return configuration bytes read
 and written to user space
Message-ID: <20210302140654.ybmjqui5snp5wxym@steredhat>
References: <20210216094454.82106-1-sgarzare@redhat.com>
 <20210216094454.82106-11-sgarzare@redhat.com>
 <4d682ff2-9663-d6ac-d5bf-616b2bf96e1a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4d682ff2-9663-d6ac-d5bf-616b2bf96e1a@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 02, 2021 at 12:05:35PM +0800, Jason Wang wrote:
>
>On 2021/2/16 5:44 下午, Stefano Garzarella wrote:
>>vdpa_get_config() and vdpa_set_config() now return the amount
>>of bytes read and written, so let's return them to the user space.
>>
>>We also modify vhost_vdpa_config_validate() to return 0 (bytes read
>>or written) instead of an error, when the buffer length is 0.
>>
>>Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>>---
>>  drivers/vhost/vdpa.c | 26 +++++++++++++++-----------
>>  1 file changed, 15 insertions(+), 11 deletions(-)
>>
>>diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>>index 21eea2be5afa..b754c53171a7 100644
>>--- a/drivers/vhost/vdpa.c
>>+++ b/drivers/vhost/vdpa.c
>>@@ -191,9 +191,6 @@ static ssize_t vhost_vdpa_config_validate(struct vhost_vdpa *v,
>>  	struct vdpa_device *vdpa = v->vdpa;
>>  	u32 size = vdpa->config->get_config_size(vdpa);
>>-	if (c->len == 0)
>>-		return -EINVAL;
>>-
>>  	return min(c->len, size);
>>  }
>>@@ -204,6 +201,7 @@ static long vhost_vdpa_get_config(struct vhost_vdpa *v,
>>  	struct vhost_vdpa_config config;
>>  	unsigned long size = offsetof(struct vhost_vdpa_config, buf);
>>  	ssize_t config_size;
>>+	long ret;
>>  	u8 *buf;
>>  	if (copy_from_user(&config, c, size))
>>@@ -217,15 +215,18 @@ static long vhost_vdpa_get_config(struct vhost_vdpa *v,
>>  	if (!buf)
>>  		return -ENOMEM;
>>-	vdpa_get_config(vdpa, config.off, buf, config_size);
>>-
>>-	if (copy_to_user(c->buf, buf, config_size)) {
>>-		kvfree(buf);
>>-		return -EFAULT;
>>+	ret = vdpa_get_config(vdpa, config.off, buf, config_size);
>>+	if (ret < 0) {
>>+		ret = -EFAULT;
>>+		goto out;
>>  	}
>>+	if (copy_to_user(c->buf, buf, config_size))
>>+		ret = -EFAULT;
>>+
>>+out:
>>  	kvfree(buf);
>>-	return 0;
>>+	return ret;
>>  }
>>  static long vhost_vdpa_set_config(struct vhost_vdpa *v,
>>@@ -235,6 +236,7 @@ static long vhost_vdpa_set_config(struct vhost_vdpa *v,
>>  	struct vhost_vdpa_config config;
>>  	unsigned long size = offsetof(struct vhost_vdpa_config, buf);
>>  	ssize_t config_size;
>>+	long ret;
>>  	u8 *buf;
>>  	if (copy_from_user(&config, c, size))
>>@@ -248,10 +250,12 @@ static long vhost_vdpa_set_config(struct vhost_vdpa *v,
>>  	if (IS_ERR(buf))
>>  		return PTR_ERR(buf);
>>-	vdpa_set_config(vdpa, config.off, buf, config_size);
>>+	ret = vdpa_set_config(vdpa, config.off, buf, config_size);
>>+	if (ret < 0)
>>+		ret = -EFAULT;
>>  	kvfree(buf);
>>-	return 0;
>>+	return ret;
>>  }
>
>
>So I wonder whether it's worth to return the number of bytes since we 
>can't propogate the result to driver or driver doesn't care about 
>that.

Okay, but IIUC user space application that issue VHOST_VDPA_GET_CONFIG 
ioctl can use the return value.

Should we change also 'struct virtio_config_ops' to propagate this value 
also to virtio drivers?

Thanks,
Stefano

