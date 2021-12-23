Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5844847E1DE
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 12:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347825AbhLWK77 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 05:59:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:48693 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347803AbhLWK76 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Dec 2021 05:59:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640257197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Gi7g+IDEb6WGbto01CYp8T3QI7qHrL20V9bktHYFsUE=;
        b=FBxPauh4/gzTtMZVC1qXIHRZFzIaA8VtJ+fg/xfxRM5gRwnfO2DHwRrwMYivFUNfaFDxAc
        SW/IxtgcUBrovxWkRmq/Q7xQAFZriPAu+nyCYQ0NOGIW1UsRk+cS/VYrOwtgHU02M8d6uX
        rJQ7cTn9xxodgvKg55HsBMGdnHsb2ss=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-483-_rnUCeqWMzKKjcJpB0lw4A-1; Thu, 23 Dec 2021 05:59:56 -0500
X-MC-Unique: _rnUCeqWMzKKjcJpB0lw4A-1
Received: by mail-wm1-f72.google.com with SMTP id r2-20020a05600c35c200b00345c3b82b22so2613814wmq.0
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 02:59:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Gi7g+IDEb6WGbto01CYp8T3QI7qHrL20V9bktHYFsUE=;
        b=Hu68EMi62rMo4AJ7ADl7QCHeoBNrtxbofXbcQOvY9ztaLsgerPqUisdvmGlEo1YBY3
         BZvwuj6Pe+8S4UXgru1iYNL9kWQ5cdyXVo8sOBwn8ejwkWxKxW46fMqq5lyDTr3YFuvg
         hN2A8MS6hbsiy7kbA/qx0wv1WPv6ckwyMugbsJSKnP80FAs2DbZri7ir5snNZEmqxo8/
         ZmKLXNcXw4EE5KRYZV/RZ77PAJJ3gM43Q3MRgBzbGm/sBg62+sc01aQUCainiMWtKEM4
         UIXkRbKTa2M6UccoU1hIOkWSqpELitJFLnmwurb1rEzxOzJQZ9UMXyRtCHc1XI444CDr
         UIfA==
X-Gm-Message-State: AOAM531nyFP3XjpODdpK4/cCK/yRUqDf+RZhbuVl7of9ijQ3H3lffKjX
        eCa8dC8jaWGUJuhiuS4PNz2jy2k0WrF2TzSbwcftbt1neVdWLk378kn+lbgJhf5yOfphWKmsgP8
        ezR9NkJnpoMqb
X-Received: by 2002:a5d:6944:: with SMTP id r4mr1338212wrw.515.1640257194568;
        Thu, 23 Dec 2021 02:59:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyiSPvRCS4tIgVXtQ5WPcUTF+53o6QxFaMhWGw4m+5+v/5BVnqxslIxZT8JsIX8wZYXvoGfdw==
X-Received: by 2002:a5d:6944:: with SMTP id r4mr1338194wrw.515.1640257194380;
        Thu, 23 Dec 2021 02:59:54 -0800 (PST)
Received: from steredhat (host-79-51-11-180.retail.telecomitalia.it. [79.51.11.180])
        by smtp.gmail.com with ESMTPSA id p11sm4952547wru.99.2021.12.23.02.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 02:59:53 -0800 (PST)
Date:   Thu, 23 Dec 2021 11:59:50 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Yi Wang <wang.yi59@zte.com.cn>
Cc:     mst@redhat.com, Zhang Min <zhang.min9@zte.com.cn>,
        wang.liang82@zte.com.cn, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, xue.zhihong@zte.com.cn
Subject: Re: [PATCH] vdpa: regist vhost-vdpa dev class
Message-ID: <20211223105950.ovywoj6v3aooh2v5@steredhat>
References: <20211223073145.35363-1-wang.yi59@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20211223073145.35363-1-wang.yi59@zte.com.cn>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 23, 2021 at 03:31:45PM +0800, Yi Wang wrote:
>From: Zhang Min <zhang.min9@zte.com.cn>
>
>Some applications like kata-containers need to acquire MAJOR/MINOR/DEVNAME
>for devInfo [1], so regist vhost-vdpa dev class to expose uevent.
>
>1. https://github.com/kata-containers/kata-containers/blob/main/src/runtime/virtcontainers/device/config/config.go
>
>Signed-off-by: Zhang Min <zhang.min9@zte.com.cn>
>Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
>---
> drivers/vhost/vdpa.c | 12 ++++++++++++
> 1 file changed, 12 insertions(+)
>
>diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>index fb41db3da611..90fbad93e7a2 100644
>--- a/drivers/vhost/vdpa.c
>+++ b/drivers/vhost/vdpa.c
>@@ -1012,6 +1012,7 @@ static void vhost_vdpa_release_dev(struct device *device)
> 	kfree(v);
> }
>
>+static struct class *vhost_vdpa_class;
   ^
Maybe is better to move this declaration on top, near `static dev_t 
vhost_vdpa_major;`

> static int vhost_vdpa_probe(struct vdpa_device *vdpa)
> {
> 	const struct vdpa_config_ops *ops = vdpa->config;
>@@ -1040,6 +1041,7 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
> 	v->dev.release = vhost_vdpa_release_dev;
> 	v->dev.parent = &vdpa->dev;
> 	v->dev.devt = MKDEV(MAJOR(vhost_vdpa_major), minor);
>+	v->dev.class = vhost_vdpa_class;
> 	v->vqs = kmalloc_array(v->nvqs, sizeof(struct vhost_virtqueue),
> 			       GFP_KERNEL);
> 	if (!v->vqs) {
>@@ -1097,6 +1099,14 @@ static int __init vhost_vdpa_init(void)
> {
> 	int r;
>
>+	vhost_vdpa_class = class_create(THIS_MODULE, "vhost-vdpa");
>+	if (IS_ERR(vhost_vdpa_class)) {
>+		r = PTR_ERR(vhost_vdpa_class);
>+		pr_warn("vhost vdpa class create error %d,  maybe mod reinserted\n", r);
                                                           ^
double space.

I'm not a native speaker, but I would rephrase the second part to "maybe 
the module is already loaded"

>+		vhost_vdpa_class = NULL;
>+		return r;
>+	}
>+
> 	r = alloc_chrdev_region(&vhost_vdpa_major, 0, VHOST_VDPA_DEV_MAX,
> 				"vhost-vdpa");
> 	if (r)
>@@ -1111,6 +1121,7 @@ static int __init vhost_vdpa_init(void)
> err_vdpa_register_driver:
> 	unregister_chrdev_region(vhost_vdpa_major, VHOST_VDPA_DEV_MAX);
> err_alloc_chrdev:
>+	class_destroy(vhost_vdpa_class);

Should we set `vhost_vdpa_class` to NULL here?

If yes, maybe better to add a new label, and a goto in the 
`class_create` error handling.

> 	return r;
> }
> module_init(vhost_vdpa_init);
>@@ -1118,6 +1129,7 @@ module_init(vhost_vdpa_init);
> static void __exit vhost_vdpa_exit(void)
> {
> 	vdpa_unregister_driver(&vhost_vdpa_driver);
>+	class_destroy(vhost_vdpa_class);

I would move it after unregister_chrdev_region() to have the reverse 
order of initialization (as we already rightly do in the error path of 
vhost_vdpa_init()).

Thanks,
Stefano

> 	unregister_chrdev_region(vhost_vdpa_major, VHOST_VDPA_DEV_MAX);
> }
> module_exit(vhost_vdpa_exit);
>-- 
>2.27.0
>_______________________________________________
>Virtualization mailing list
>Virtualization@lists.linux-foundation.org
>https://lists.linuxfoundation.org/mailman/listinfo/virtualization
>

