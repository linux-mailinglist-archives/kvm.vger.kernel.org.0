Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6867B32E3CD
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 09:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhCEIhk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 03:37:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20564 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229592AbhCEIhT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Mar 2021 03:37:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614933439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5IxD+zRq/yhrLjAjbqOqe9sITek/cTcDBZYIQhAd6Ic=;
        b=E2qDu376iIH0DMKpz9DxCB2PXjd5T9f/snqSBqHXhFtIFibUAUBnlULS3dlqOIomiMC+Vc
        FMxrBQLVU1PumBdRr/V6LOyZvv5CKENWjbNNn1vsjs/i80o9mFHzVHmgd8I1p96YTF/6sH
        yyIZJCfEeOCkTuP70hjApWm2NaEk4dk=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-EZc_keigOpGbr4_RBH4cfg-1; Fri, 05 Mar 2021 03:37:16 -0500
X-MC-Unique: EZc_keigOpGbr4_RBH4cfg-1
Received: by mail-ej1-f69.google.com with SMTP id rl7so536524ejb.16
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 00:37:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=5IxD+zRq/yhrLjAjbqOqe9sITek/cTcDBZYIQhAd6Ic=;
        b=eyi65ri4pSRAEUY49Rq0+gLLmrb81z9XKXXaWPP6WwxL8pqNq5Pk7EhB+1bgzqtYcf
         OdtHpTNBzF45zoan8EL54ds9HOE8asW7zR+npCrOivfXkpFiN1wITNsC9VE3nZD0ldws
         9K+OMrvhW19LmWekW/4JiJtjp4yAr0Ith3tPbOyxRNiVaFZqHFEqV4hRefsGdY8vu5iP
         ReasRNvHGs7Pby4qGtJ28tMd7eV2LMGfCCe1nDJ58K7Qku4ZX4Cn4UiFHpf+gAElwaaH
         HIpFrCNksBC2PrKxZBrWU28uyypRqKmGp/8A8MY0CmAwPquvwxPlFt9HGGBs0WL0pkg1
         xyfQ==
X-Gm-Message-State: AOAM531NcqcgK8uVLUVHOWZ62vu6IJhKojjuzDS5mGvcWRNvrI84Eprx
        ZZlO5Q+No6fMFuj+cEED1ab7imO6nEf2aWghlT3cZg66020exqb6fJ2deQ6YFjvqsV7rfVaGzUs
        vwCKJYwO9E9Jl
X-Received: by 2002:aa7:d316:: with SMTP id p22mr7803924edq.107.1614933435326;
        Fri, 05 Mar 2021 00:37:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyjOmXvN8EMZ0rcYtj7qz24OPE/oP+k8nHqB8bmBISFKPKisJaNW2VnaxRq7If6mLdWgTCHeg==
X-Received: by 2002:aa7:d316:: with SMTP id p22mr7803915edq.107.1614933435181;
        Fri, 05 Mar 2021 00:37:15 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id si7sm1078074ejb.84.2021.03.05.00.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 00:37:14 -0800 (PST)
Date:   Fri, 5 Mar 2021 09:37:12 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [RFC PATCH 10/10] vhost/vdpa: return configuration bytes read
 and written to user space
Message-ID: <20210305083712.atfrlpq6bkjrf6pd@steredhat>
References: <20210216094454.82106-1-sgarzare@redhat.com>
 <20210216094454.82106-11-sgarzare@redhat.com>
 <4d682ff2-9663-d6ac-d5bf-616b2bf96e1a@redhat.com>
 <20210302140654.ybmjqui5snp5wxym@steredhat>
 <5cf852b1-1279-20e9-516d-30f876e0162d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5cf852b1-1279-20e9-516d-30f876e0162d@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 04, 2021 at 04:31:22PM +0800, Jason Wang wrote:
>
>On 2021/3/2 10:06 下午, Stefano Garzarella wrote:
>>On Tue, Mar 02, 2021 at 12:05:35PM +0800, Jason Wang wrote:
>>>
>>>On 2021/2/16 5:44 下午, Stefano Garzarella wrote:
>>>>vdpa_get_config() and vdpa_set_config() now return the amount
>>>>of bytes read and written, so let's return them to the user space.
>>>>
>>>>We also modify vhost_vdpa_config_validate() to return 0 (bytes read
>>>>or written) instead of an error, when the buffer length is 0.
>>>>
>>>>Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>>>>---
>>>> drivers/vhost/vdpa.c | 26 +++++++++++++++-----------
>>>> 1 file changed, 15 insertions(+), 11 deletions(-)
>>>>
>>>>diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>>>>index 21eea2be5afa..b754c53171a7 100644
>>>>--- a/drivers/vhost/vdpa.c
>>>>+++ b/drivers/vhost/vdpa.c
>>>>@@ -191,9 +191,6 @@ static ssize_t 
>>>>vhost_vdpa_config_validate(struct vhost_vdpa *v,
>>>>     struct vdpa_device *vdpa = v->vdpa;
>>>>     u32 size = vdpa->config->get_config_size(vdpa);
>>>>-    if (c->len == 0)
>>>>-        return -EINVAL;
>>>>-
>>>>     return min(c->len, size);
>>>> }
>>>>@@ -204,6 +201,7 @@ static long vhost_vdpa_get_config(struct 
>>>>vhost_vdpa *v,
>>>>     struct vhost_vdpa_config config;
>>>>     unsigned long size = offsetof(struct vhost_vdpa_config, buf);
>>>>     ssize_t config_size;
>>>>+    long ret;
>>>>     u8 *buf;
>>>>     if (copy_from_user(&config, c, size))
>>>>@@ -217,15 +215,18 @@ static long vhost_vdpa_get_config(struct 
>>>>vhost_vdpa *v,
>>>>     if (!buf)
>>>>         return -ENOMEM;
>>>>-    vdpa_get_config(vdpa, config.off, buf, config_size);
>>>>-
>>>>-    if (copy_to_user(c->buf, buf, config_size)) {
>>>>-        kvfree(buf);
>>>>-        return -EFAULT;
>>>>+    ret = vdpa_get_config(vdpa, config.off, buf, config_size);
>>>>+    if (ret < 0) {
>>>>+        ret = -EFAULT;
>>>>+        goto out;
>>>>     }
>>>>+    if (copy_to_user(c->buf, buf, config_size))
>>>>+        ret = -EFAULT;
>>>>+
>>>>+out:
>>>>     kvfree(buf);
>>>>-    return 0;
>>>>+    return ret;
>>>> }
>>>> static long vhost_vdpa_set_config(struct vhost_vdpa *v,
>>>>@@ -235,6 +236,7 @@ static long vhost_vdpa_set_config(struct 
>>>>vhost_vdpa *v,
>>>>     struct vhost_vdpa_config config;
>>>>     unsigned long size = offsetof(struct vhost_vdpa_config, buf);
>>>>     ssize_t config_size;
>>>>+    long ret;
>>>>     u8 *buf;
>>>>     if (copy_from_user(&config, c, size))
>>>>@@ -248,10 +250,12 @@ static long vhost_vdpa_set_config(struct 
>>>>vhost_vdpa *v,
>>>>     if (IS_ERR(buf))
>>>>         return PTR_ERR(buf);
>>>>-    vdpa_set_config(vdpa, config.off, buf, config_size);
>>>>+    ret = vdpa_set_config(vdpa, config.off, buf, config_size);
>>>>+    if (ret < 0)
>>>>+        ret = -EFAULT;
>>>>     kvfree(buf);
>>>>-    return 0;
>>>>+    return ret;
>>>> }
>>>
>>>
>>>So I wonder whether it's worth to return the number of bytes since 
>>>we can't propogate the result to driver or driver doesn't care 
>>>about that.
>>
>>Okay, but IIUC user space application that issue 
>>VHOST_VDPA_GET_CONFIG ioctl can use the return value.
>
>
>Yes, but it looks to it's too late to change since it's a userspace 
>noticble behaviour.

Yeah, this is a good point.
I looked at QEMU and we only check if the value is not negative, so it 
should work, but for other applications it could be a real change.

Do we leave it as is?

>
>
>>
>>Should we change also 'struct virtio_config_ops' to propagate this 
>>value also to virtio drivers?
>
>
>I think not, the reason is the driver doesn't expect the get()/set() 
>can fail...

Got it.

Thanks,
Stefano

