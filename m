Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25764491C38
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 04:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343939AbiARDOK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 22:14:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59569 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343614AbiARDHt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 22:07:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642475268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9CQmErdVbSRr9mtW1+GyxSplP9tubMADIUUmh9Y+ayg=;
        b=RRs87RMkYCJl+mUZsopuZkbmBCLWShGxMcq3HiFwVU3BbaoXLrXpVHmWY09WUOXYY+W0cw
        wtsopjdvkYnRnzJRWHv2k54tW6JDDFT3kQPKc1GO1eUg7zc2hOUwMgAn0lYWClXTsDw8Nf
        /jYQBjHw0Z0fxtq8eBUPM87CY8UEvvg=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-670-JdhZjUBRNK2-8l1MnevTBA-1; Mon, 17 Jan 2022 22:07:47 -0500
X-MC-Unique: JdhZjUBRNK2-8l1MnevTBA-1
Received: by mail-pg1-f197.google.com with SMTP id k13-20020a65434d000000b00342d8eb46b4so8682325pgq.23
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 19:07:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9CQmErdVbSRr9mtW1+GyxSplP9tubMADIUUmh9Y+ayg=;
        b=hLzEJN5Y5nmHpP8zwug2TzklgLSpqr6fxeLtjsJ+vcXO6q+IkOSpreFI1c5/h7p9tC
         N31CdZ/PUYw5n4GrKlKXy/f2OeFawKUPBUTHm5FMpVVD7WQ/+p7T9fJXjlm8I4YCfz73
         2tmhshISAN44sY0RZe5mxefFzT+oD5zB7jYGDTxwehhHt+gCPgSyjk0DaUmUbNLJHPMf
         qi2mSOPbmi4VVTgSyEX6J+75XeRatFmGFgcyXtVxKPyf43hDFDXEMbpbOYIHeWT1dNIF
         0z2rDFSHlLAJtW+KAsZRuUji/VePKCveM6+tepNm8BInHkGHuYj3sc6pqZpTd+0RxBQU
         g+Bg==
X-Gm-Message-State: AOAM531YMLAFjw2z2ZtzK5O0SuCGLYlrIgqkzgKN9/zXzT3y8B1iMJpV
        tvy6vLaetTI3v+hFx65P90FzwBb5wV2mJIxnZCvcBflkQmHy/bmOFC3l9MIbsfs81FRKZWOSw2N
        jIPaS2nCpFK/S
X-Received: by 2002:a63:9dc8:: with SMTP id i191mr21688280pgd.601.1642475266010;
        Mon, 17 Jan 2022 19:07:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyGn88ixeCz13kpjGb4SysE+JIuenybALI9UvqarO/71VSQGXiBlHPncz3hIYzN/LcoVqqxiA==
X-Received: by 2002:a63:9dc8:: with SMTP id i191mr21688268pgd.601.1642475265770;
        Mon, 17 Jan 2022 19:07:45 -0800 (PST)
Received: from [10.72.13.83] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a19sm4801961pfh.198.2022.01.17.19.07.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jan 2022 19:07:45 -0800 (PST)
Message-ID: <1a26d7b3-1020-50c5-f0a3-ebc645cdcddf@redhat.com>
Date:   Tue, 18 Jan 2022 11:07:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [RFC 2/3] vdpa: support exposing the count of vqs to userspace
Content-Language: en-US
To:     "Longpeng(Mike)" <longpeng2@huawei.com>, mst@redhat.com,
        sgarzare@redhat.com, stefanha@redhat.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        arei.gonglei@huawei.com, yechuan@huawei.com,
        huangzhichao@huawei.com
References: <20220117092921.1573-1-longpeng2@huawei.com>
 <20220117092921.1573-3-longpeng2@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220117092921.1573-3-longpeng2@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2022/1/17 下午5:29, Longpeng(Mike) 写道:
> From: Longpeng <longpeng2@huawei.com>
>
> - GET_VQS_COUNT: the count of virtqueues that exposed
>
> Signed-off-by: Longpeng <longpeng2@huawei.com>
> ---
>   drivers/vhost/vdpa.c       | 13 +++++++++++++
>   include/uapi/linux/vhost.h |  3 +++
>   2 files changed, 16 insertions(+)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 1eea14a4ea56..c1074278fc6b 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -369,6 +369,16 @@ static long vhost_vdpa_get_config_size(struct vhost_vdpa *v, u32 __user *argp)
>   	return 0;
>   }
>   
> +static long vhost_vdpa_get_vqs_count(struct vhost_vdpa *v, u32 __user *argp)
> +{
> +	struct vdpa_device *vdpa = v->vdpa;


While at it, I think it's better to change vdpa->nvqs to use u32?

Thanks


> +
> +	if (copy_to_user(argp, &vdpa->nvqs, sizeof(vdpa->nvqs)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
>   static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>   				   void __user *argp)
>   {
> @@ -509,6 +519,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>   	case VHOST_VDPA_GET_CONFIG_SIZE:
>   		r = vhost_vdpa_get_config_size(v, argp);
>   		break;
> +	case VHOST_VDPA_GET_VQS_COUNT:
> +		r = vhost_vdpa_get_vqs_count(v, argp);
> +		break;
>   	default:
>   		r = vhost_dev_ioctl(&v->vdev, cmd, argp);
>   		if (r == -ENOIOCTLCMD)
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index bc74e95a273a..5d99e7c242a2 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -154,4 +154,7 @@
>   /* Get the config size */
>   #define VHOST_VDPA_GET_CONFIG_SIZE	_IOR(VHOST_VIRTIO, 0x79, __u32)
>   
> +/* Get the count of all virtqueues */
> +#define VHOST_VDPA_GET_VQS_COUNT	_IOR(VHOST_VIRTIO, 0x80, __u32)
> +
>   #endif

