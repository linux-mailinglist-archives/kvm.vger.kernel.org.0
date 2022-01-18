Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C48491C39
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 04:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344810AbiARDOO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 22:14:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:39225 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354730AbiARDKM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 22:10:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642475411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VHROM3H3Gj1zTOOoCmnC85BRDlwA1UmiYl4rywuZ64M=;
        b=c07sMGExbWxiQO/s2OfmJo63WqZ4wkQbUrGblIDYlO520OxBMsaiwk+5//3yVqs9kuNpSA
        Skp7wgIlupw7LTTETXIIbH6z+IDek+nLMkjOpVy+ieOGNig477A+5Y2ouVq39DwOcl847H
        1eRo1mFpE5aIGaf+RRJd+hfuOoeLaAo=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-UdsDmUE8Mt-nxvCAVVKRLg-1; Mon, 17 Jan 2022 22:10:07 -0500
X-MC-Unique: UdsDmUE8Mt-nxvCAVVKRLg-1
Received: by mail-pj1-f70.google.com with SMTP id d11-20020a17090a498b00b001b3fb4f070bso1053817pjh.5
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 19:10:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VHROM3H3Gj1zTOOoCmnC85BRDlwA1UmiYl4rywuZ64M=;
        b=KuY+f9yxZMyHjeLdbnTsu1umJqxgUIEXzaxV5qNIjNEz4q+95Gk6W08k7nw3bEkuNc
         SnE6Z2CUBha/+RDZTx3V2WGpieZc5CKDygSCudYnh0vG0hPnWhfcsFDbQJy6YJT4ofaG
         6W6r2IeJOlLCAQvr/0AjnXjkUwewQxlnGn+RHUEKL8XRr8pqb7VaykiGAA81zOIJpMDs
         Kn+sROS16Q8HWJsWy7jxbYzxBZKxcBH0w0TuoyUEhK7No94kCcJr64xAS1rNvhwHEVds
         pbwWu6JZs8oLEj4poULxnyfm7bWv1FAlnjQCN52Cc00cG9Nyc4Jzw5j7ikMUpMb78IzR
         +9HQ==
X-Gm-Message-State: AOAM531bsW81+NIzIOj41HAvmey+w5BVaM7qY8TeGsJCjDZ/I2DBQ4p5
        yqNrjWHi1TbI5hxMZqNBLSIjNzYPGUbzqh+UIoBisYnJQqnacpWzkFSYVjb+qScSX4AJziDIO6e
        Xth69Lj5lxIl8
X-Received: by 2002:a63:2210:: with SMTP id i16mr14992534pgi.532.1642475406807;
        Mon, 17 Jan 2022 19:10:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzpr917B1MdxpHfy21aTB02UTG9DuJi4ylO0bN/YcI+iiqs3Cv0o2sHKTxbfK+NwUV144Z2mw==
X-Received: by 2002:a63:2210:: with SMTP id i16mr14992512pgi.532.1642475406468;
        Mon, 17 Jan 2022 19:10:06 -0800 (PST)
Received: from [10.72.13.83] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m3sm14672061pfa.183.2022.01.17.19.10.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jan 2022 19:10:05 -0800 (PST)
Message-ID: <545d11f3-0b4e-da61-91f3-595ed5608334@redhat.com>
Date:   Tue, 18 Jan 2022 11:09:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [RFC 3/3] vdpasim_net: control virtqueue support
Content-Language: en-US
To:     "Longpeng(Mike)" <longpeng2@huawei.com>, mst@redhat.com,
        sgarzare@redhat.com, stefanha@redhat.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        arei.gonglei@huawei.com, yechuan@huawei.com,
        huangzhichao@huawei.com
References: <20220117092921.1573-1-longpeng2@huawei.com>
 <20220117092921.1573-4-longpeng2@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220117092921.1573-4-longpeng2@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2022/1/17 下午5:29, Longpeng(Mike) 写道:
> From: Longpeng <longpeng2@huawei.com>
>
> Introduces the control virtqueue support for vdpasim_net, based on
> Jason's RFC [1].
>
> [1] https://patchwork.kernel.org/project/kvm/patch/20200924032125.18619-25-jasowang@redhat.com/


I'd expect to implement the receive filter as well[1]. This gives us a 
chance to test this.

Thanks

[1] https://lkml.org/lkml/2020/9/23/1269


>
> Signed-off-by: Longpeng <longpeng2@huawei.com>
> ---
>   drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 83 +++++++++++++++++++++++++++-
>   1 file changed, 81 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> index 76dd24abc791..e9e388fd3cff 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> @@ -26,9 +26,85 @@
>   #define DRV_LICENSE  "GPL v2"
>   
>   #define VDPASIM_NET_FEATURES	(VDPASIM_FEATURES | \
> -				 (1ULL << VIRTIO_NET_F_MAC))
> +				 (1ULL << VIRTIO_NET_F_MAC) | \
> +				 (1ULL << VIRTIO_NET_F_CTRL_VQ) | \
> +				 (1ULL << VIRTIO_NET_F_CTRL_MAC_ADDR))
>   
> -#define VDPASIM_NET_VQ_NUM	2
> +#define VDPASIM_NET_VQ_NUM	3
> +
> +virtio_net_ctrl_ack vdpasim_net_handle_ctrl_mac(struct vdpasim *vdpasim,
> +						u8 cmd)
> +{
> +	struct vdpasim_virtqueue *cvq = &vdpasim->vqs[2];
> +	virtio_net_ctrl_ack status = VIRTIO_NET_ERR;
> +	struct virtio_net_config *config = vdpasim->config;
> +	size_t read;
> +
> +	switch (cmd) {
> +	case VIRTIO_NET_CTRL_MAC_ADDR_SET:
> +		read = vringh_iov_pull_iotlb(&cvq->vring, &cvq->out_iov,
> +					     (void *)config->mac, ETH_ALEN);
> +		if (read == ETH_ALEN)
> +			status = VIRTIO_NET_OK;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return status;
> +}
> +
> +static void vdpasim_net_handle_cvq(struct vdpasim *vdpasim)
> +{
> +	struct vdpasim_virtqueue *cvq = &vdpasim->vqs[2];
> +	virtio_net_ctrl_ack status = VIRTIO_NET_ERR;
> +	struct virtio_net_ctrl_hdr ctrl;
> +	size_t read, write;
> +	int err;
> +
> +	if (!(vdpasim->features & (1ULL << VIRTIO_NET_F_CTRL_VQ)))
> +		return;
> +
> +	if (!cvq->ready)
> +		return;
> +
> +	while (true) {
> +		err = vringh_getdesc_iotlb(&cvq->vring, &cvq->out_iov, &cvq->in_iov,
> +					   &cvq->head, GFP_ATOMIC);
> +		if (err <= 0)
> +			break;
> +
> +		read = vringh_iov_pull_iotlb(&cvq->vring, &cvq->in_iov, &ctrl,
> +					     sizeof(ctrl));
> +		if (read != sizeof(ctrl))
> +			break;
> +
> +		switch (ctrl.class) {
> +		case VIRTIO_NET_CTRL_MAC:
> +			status = vdpasim_net_handle_ctrl_mac(vdpasim, ctrl.cmd);
> +			break;
> +		default:
> +			break;
> +		}
> +
> +		/* Make sure data is wrote before advancing index */
> +		smp_wmb();
> +
> +		write = vringh_iov_push_iotlb(&cvq->vring, &cvq->out_iov,
> +					      &status, sizeof (status));
> +		vringh_complete_iotlb(&cvq->vring, cvq->head, write);
> +		vringh_kiov_cleanup(&cvq->in_iov);
> +		vringh_kiov_cleanup(&cvq->out_iov);
> +
> +		/* Make sure used is visible before rasing the interrupt. */
> +		smp_wmb();
> +
> +		local_bh_disable();
> +		if (vringh_need_notify_iotlb(&cvq->vring) > 0)
> +			vringh_notify(&cvq->vring);
> +		local_bh_enable();
> +	}
> +}
>   
>   static void vdpasim_net_work(struct work_struct *work)
>   {
> @@ -42,6 +118,9 @@ static void vdpasim_net_work(struct work_struct *work)
>   
>   	spin_lock(&vdpasim->lock);
>   
> +	/* process ctrl vq first */
> +	vdpasim_net_handle_cvq(vdpasim);
> +
>   	if (!(vdpasim->status & VIRTIO_CONFIG_S_DRIVER_OK))
>   		goto out;
>   

