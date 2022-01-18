Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19932491D6B
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 04:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353350AbiARDgM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 22:36:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:54019 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354553AbiARDGy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 22:06:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642475214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m/T+xqeUAypi/EBSYpJv9W0hZEqvgrZKwX4x1rH2s4Q=;
        b=UUzwjgWPDEHAk5byIbbuFrZNTCQFZBsaU5BFI9SeoGmRvnWqkyBp1FbbTh9vRtzUISk4Kv
        BuXmhEwRhsNEd0RfmY6E7wIilKRtWWlVy8QBqtNvdxP/wHCkzqAhAl/MojWQzSNZzMpjvX
        kRwnbD07XvkhmX8T6IZh4EU0QvgR2Bk=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-489-KNYfK3HeOaeEzKSn4Za1JQ-1; Mon, 17 Jan 2022 22:06:52 -0500
X-MC-Unique: KNYfK3HeOaeEzKSn4Za1JQ-1
Received: by mail-pg1-f197.google.com with SMTP id i17-20020a63e911000000b00346ca0d49ddso8702573pgh.20
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 19:06:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=m/T+xqeUAypi/EBSYpJv9W0hZEqvgrZKwX4x1rH2s4Q=;
        b=cMZiL2uhTgXf6WrNoulBgu6vCi0IFzXqiSiI084TXSjPiK3YllH0ajDdbfrq5+5V8A
         iORcJeWSGvdLV9ljkFc1/VdcTgIiyGrNM3sBuDJIxkkEQw15NIa+Oz8TLcPyiXmDIn4z
         A1HASp8VO2xsvMmse0XjjBozI5MiBwFLN49sEFRGLB6rVLCL1QtdvZJYVP6R1ZwcpA5F
         cmEqFh13/XokfXLZwrDSPODbHxW9sfe8BPDVa4kovtZRu7hKN0kcsArY6P6hYS4H4TTH
         VjXMkxkGfNwmzwmV27j2Bqqp4laxSjosJwYiDMD2IoiFp8HOn6wQtQ+9HYykPw7pLN35
         /qXg==
X-Gm-Message-State: AOAM532fDJEcq7ECHh8xvQ+J27oGYZvMO+ohM3SCWZoFWA8q/E0fuWyM
        uARV3UBKb4RlCkhz67nbioeGdk7RUEn476OWZBbZO/A2eQKQzoL7PbJ6y+3mDQ2x+ZG1Kc1ycXP
        EyA8xWRwUSm+L
X-Received: by 2002:a17:902:d505:b0:14a:77ac:1e8b with SMTP id b5-20020a170902d50500b0014a77ac1e8bmr25111380plg.1.1642475211595;
        Mon, 17 Jan 2022 19:06:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzoQYXGFOiuE7DE7WvP6A/zKMhsh+2K8vED7mN/UdEi/ZVq6aYj54hRESwmfzpInEWZa5o65A==
X-Received: by 2002:a17:902:d505:b0:14a:77ac:1e8b with SMTP id b5-20020a170902d50500b0014a77ac1e8bmr25111367plg.1.1642475211348;
        Mon, 17 Jan 2022 19:06:51 -0800 (PST)
Received: from [10.72.13.83] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c19sm15280757pfo.91.2022.01.17.19.06.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jan 2022 19:06:50 -0800 (PST)
Message-ID: <ce3890b8-8f48-847d-b029-e29cc9261f18@redhat.com>
Date:   Tue, 18 Jan 2022 11:06:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [RFC 1/3] vdpa: support exposing the config size to userspace
Content-Language: en-US
To:     "Longpeng(Mike)" <longpeng2@huawei.com>, mst@redhat.com,
        sgarzare@redhat.com, stefanha@redhat.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        arei.gonglei@huawei.com, yechuan@huawei.com,
        huangzhichao@huawei.com
References: <20220117092921.1573-1-longpeng2@huawei.com>
 <20220117092921.1573-2-longpeng2@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220117092921.1573-2-longpeng2@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2022/1/17 下午5:29, Longpeng(Mike) 写道:
> From: Longpeng <longpeng2@huawei.com>
>
> - GET_CONFIG_SIZE: the size of the virtio config space


I think we need to be verbose here. And it would be better to quote what 
spec said:

"

The device MUST allow reading of any device-specific configuration field 
before FEATURES_OK is set by the driver. This includes fields which are 
conditional on feature bits, as long as those feature bits are offered 
by the device.

"

I guess the size should contain the conditional on features bits.

(Or maybe we need to tweak the comment for get_config_size as well).

Other looks good.

Thanks


>
> Signed-off-by: Longpeng <longpeng2@huawei.com>
> ---
>   drivers/vhost/vdpa.c       | 17 +++++++++++++++++
>   include/uapi/linux/vhost.h |  4 ++++
>   2 files changed, 21 insertions(+)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 29cced1cd277..1eea14a4ea56 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -355,6 +355,20 @@ static long vhost_vdpa_get_iova_range(struct vhost_vdpa *v, u32 __user *argp)
>   	return 0;
>   }
>   
> +static long vhost_vdpa_get_config_size(struct vhost_vdpa *v, u32 __user *argp)
> +{
> +	struct vdpa_device *vdpa = v->vdpa;
> +	const struct vdpa_config_ops *ops = vdpa->config;
> +	u32 size;
> +
> +	size = ops->get_config_size(vdpa);
> +
> +	if (copy_to_user(argp, &size, sizeof(size)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
>   static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>   				   void __user *argp)
>   {
> @@ -492,6 +506,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>   	case VHOST_VDPA_GET_IOVA_RANGE:
>   		r = vhost_vdpa_get_iova_range(v, argp);
>   		break;
> +	case VHOST_VDPA_GET_CONFIG_SIZE:
> +		r = vhost_vdpa_get_config_size(v, argp);
> +		break;
>   	default:
>   		r = vhost_dev_ioctl(&v->vdev, cmd, argp);
>   		if (r == -ENOIOCTLCMD)
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index c998860d7bbc..bc74e95a273a 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -150,4 +150,8 @@
>   /* Get the valid iova range */
>   #define VHOST_VDPA_GET_IOVA_RANGE	_IOR(VHOST_VIRTIO, 0x78, \
>   					     struct vhost_vdpa_iova_range)
> +
> +/* Get the config size */
> +#define VHOST_VDPA_GET_CONFIG_SIZE	_IOR(VHOST_VIRTIO, 0x79, __u32)
> +
>   #endif

