Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 597CB3B4763
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 18:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhFYQ2r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 12:28:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21473 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229630AbhFYQ2q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Jun 2021 12:28:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624638384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BgJylxZC8rGVsCNQgpaFPIfNoGokyUw2siT0jrpZvCE=;
        b=hAraQAdS7DOOCUnJynFB4GuXYChbVTrmgb5VjwAqm/6kg9NeFSCiYNJBOPdRhjL7cVhpQl
        hFkk2AZmpb8IiqDwdOL2mx71ESoU+XrJ2Ph2zLVBD/r7FG7gfQKljluept4q3/wpso9PX3
        kGlMF4+LGQE3WDZZaJ/V+tOf6TDIqog=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-7fIPOaIwPVyxRTd3cM4u3Q-1; Fri, 25 Jun 2021 12:26:23 -0400
X-MC-Unique: 7fIPOaIwPVyxRTd3cM4u3Q-1
Received: by mail-io1-f70.google.com with SMTP id d24-20020a5d95180000b02904f1970a0af0so1224455iom.6
        for <kvm@vger.kernel.org>; Fri, 25 Jun 2021 09:26:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=BgJylxZC8rGVsCNQgpaFPIfNoGokyUw2siT0jrpZvCE=;
        b=rTonPu2ji9e/54pJH4RgQXXnLhIKR7dLNcWEsm55Xxn1PzMGavldNiX8o3SYfV+GqG
         4H7xztqpInp43l4WpCCyD0SfCngcSRIbevUmT4CVtpw+Ce/WtHt9xPSHBYKAyHsEsa35
         M9hzytv4kuBPZnlJLGSOWOB0BZxkdGgRpyqlJd95U4t3rkAlhiwJA05obbkvqiz5g6Me
         sK+ssUc4IAINo2eOZWjVDUus+S6fFfRBrSsmkvcZ+qmvNnuDAYoepPmARUIhJx7AgtXL
         j+qC22XBAZnBjINqNmUCeOpiQg8molcL1xHtIjh5Ow0akyrHq7MkrtAqqfSlanPukW/v
         bP5Q==
X-Gm-Message-State: AOAM531P4qo04zOY1ORfg6tyUSpg7o8dzKXE9JXXc//r+gTyF92p9iq5
        HrD36wNffP0WKHJWczuKAccbEOISc1x2qi+yM7hPzxHlWb7hNSPk1cDhRYX3Q9S98LzHYXN5dsC
        OqLb+BU1TeSQK
X-Received: by 2002:a05:6638:50f:: with SMTP id i15mr10295703jar.28.1624638382582;
        Fri, 25 Jun 2021 09:26:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJySOMU3Ug49738ZsDWWj6cV+NJpTm31s8dvq45BNRPEZBMNGvGYjVZ3eRSsqPyLwhmwNDqvhw==
X-Received: by 2002:a05:6638:50f:: with SMTP id i15mr10295650jar.28.1624638381720;
        Fri, 25 Jun 2021 09:26:21 -0700 (PDT)
Received: from redhat.com (c-73-14-100-188.hsd1.co.comcast.net. [73.14.100.188])
        by smtp.gmail.com with ESMTPSA id o7sm3916618ilt.1.2021.06.25.09.26.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 09:26:21 -0700 (PDT)
Date:   Fri, 25 Jun 2021 10:26:20 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] vfio/mtty: Delete mdev_devices_list
Message-ID: <20210625102620.500ada5f.alex.williamson@redhat.com>
In-Reply-To: <0-v1-0bc56b362ca7+62-mtty_used_ports_jgg@nvidia.com>
References: <0-v1-0bc56b362ca7+62-mtty_used_ports_jgg@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 25 Jun 2021 12:56:04 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Dan points out that an error case left things on this list. It is also
> missing locking in available_instances_show().
> 
> Further study shows the list isn't needed at all, just store the total
> ports in use in an atomic and delete the whole thing.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Fixes: 09177ac91921 ("vfio/mtty: Convert to use vfio_register_group_dev()")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  samples/vfio-mdev/mtty.c | 24 ++++++------------------
>  1 file changed, 6 insertions(+), 18 deletions(-)
> 
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> index faf9b8e8873a5b..ffbaf07a17eaee 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -144,8 +144,7 @@ struct mdev_state {
>  	int nr_ports;
>  };
>  
> -static struct mutex mdev_list_lock;
> -static struct list_head mdev_devices_list;
> +static atomic_t mdev_used_ports;
>  
>  static const struct file_operations vd_fops = {
>  	.owner          = THIS_MODULE,
> @@ -733,15 +732,13 @@ static int mtty_probe(struct mdev_device *mdev)
>  
>  	mtty_create_config_space(mdev_state);
>  
> -	mutex_lock(&mdev_list_lock);
> -	list_add(&mdev_state->next, &mdev_devices_list);
> -	mutex_unlock(&mdev_list_lock);
> -
>  	ret = vfio_register_group_dev(&mdev_state->vdev);
>  	if (ret) {
>  		kfree(mdev_state);
>  		return ret;
>  	}
> +	atomic_add(mdev_state->nr_ports, &mdev_used_ports);
> +

I was just looking at the same and noticing how available_instances is
not enforced :-\  What if we ATOMIC_INIT(MAX_TTYS) and use this as
available ports rather than used ports.  We can check and return
-ENOSPC at the beginning or probe if we can't allocate the ports.  The
only complication is when we need to atomically subtract >1 and not go
negative.  I don't know if there's a better solution than:

+       for (i = nr_ports; i; i--) {
+               if (!atomic_add_unless(&available_ports, -1, 0))
+                       break;
+       }
+       if (i) {
+               atomic_add(nr_ports - i, &available_ports);
+               return -ENOSPC;
+       }

Thanks,
Alex

>  	dev_set_drvdata(&mdev->dev, mdev_state);
>  	return 0;
>  }
> @@ -750,10 +747,8 @@ static void mtty_remove(struct mdev_device *mdev)
>  {
>  	struct mdev_state *mdev_state = dev_get_drvdata(&mdev->dev);
>  
> +	atomic_sub(mdev_state->nr_ports, &mdev_used_ports);
>  	vfio_unregister_group_dev(&mdev_state->vdev);
> -	mutex_lock(&mdev_list_lock);
> -	list_del(&mdev_state->next);
> -	mutex_unlock(&mdev_list_lock);
>  
>  	kfree(mdev_state->vconfig);
>  	kfree(mdev_state);
> @@ -1274,14 +1269,10 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>  					struct mdev_type_attribute *attr,
>  					char *buf)
>  {
> -	struct mdev_state *mds;
>  	unsigned int ports = mtype_get_type_group_id(mtype) + 1;
> -	int used = 0;
>  
> -	list_for_each_entry(mds, &mdev_devices_list, next)
> -		used += mds->nr_ports;
> -
> -	return sprintf(buf, "%d\n", (MAX_MTTYS - used)/ports);
> +	return sprintf(buf, "%d\n",
> +		       (MAX_MTTYS - atomic_read(&mdev_used_ports)) / ports);
>  }
>  
>  static MDEV_TYPE_ATTR_RO(available_instances);
> @@ -1395,9 +1386,6 @@ static int __init mtty_dev_init(void)
>  	ret = mdev_register_device(&mtty_dev.dev, &mdev_fops);
>  	if (ret)
>  		goto err_device;
> -
> -	mutex_init(&mdev_list_lock);
> -	INIT_LIST_HEAD(&mdev_devices_list);
>  	return 0;
>  
>  err_device:

