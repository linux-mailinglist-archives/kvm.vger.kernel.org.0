Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388BC3F44E7
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 08:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbhHWG2p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 02:28:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23807 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229598AbhHWG2p (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Aug 2021 02:28:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629700082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qEgW76/QbsdmzDpY6YbWFRp1GnxyCaBmFQdXxX32rA8=;
        b=XpqL2107gFtLp+Gaw3H9HFw1sanAspYerjv2BGW8ZfGvhhSe0hfdJEGNnIm0CLu8HA90xo
        5Z7gMrnipFqKLmdFd++0KE74j1fIbPSdXepH+W3EtLU0zcGVrmlj44JZ0NA5Epm4nWo8YO
        zwYVCfPv24oX31AjslE5oy7EQPEvWmQ=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-0BTzGzezP4Sl74nqvb15aA-1; Mon, 23 Aug 2021 02:28:01 -0400
X-MC-Unique: 0BTzGzezP4Sl74nqvb15aA-1
Received: by mail-pl1-f200.google.com with SMTP id g12-20020a1709026b4cb029012c0d2e483cso3881379plt.5
        for <kvm@vger.kernel.org>; Sun, 22 Aug 2021 23:28:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=qEgW76/QbsdmzDpY6YbWFRp1GnxyCaBmFQdXxX32rA8=;
        b=fgXMuy3nJTMEqFSgsRe55okbsnZcgAa5b8ZxPljLhKO/4Y17QSoHX2pFGmAGRUEpMw
         bdPsKumV8g1xtaal9oMPwAbgNOWtNxJTg46Ve6vyV+sJ3D6e8CfcM0uyBhUgUog98Qiv
         sUiQ/xkNC/Hqtkr4In0IbRvG34i+qMoIlrq5kUFvljyEJvq5GL+3Zv6BFTT+G5G1jUNv
         Tbd570CM+mKFkhBLjspLbwr5VCa8N65uym0oKjAL7V0zju0HVyBnbQgA53m3XIER53Gv
         h1FZhKKUJKSh9lODBmVooVS41QOQ/7uJOM/aw7km4l1lwKZqTrRatrNa7NQzGntzs31z
         HJvg==
X-Gm-Message-State: AOAM5335kiivKXuBUSJWEBN+/VVksq9nTx80D3LMtgztjBbBknr8EDTu
        hR/X4ZdbAorWgMMW0htgrbWQhnf4Y/RlFKTV/0qhGSo0jTWvSqqEMY29A5iKg1ikYNYT0FPL4ug
        Q4uf23/a54CSy
X-Received: by 2002:a17:902:7d90:b0:134:d977:22de with SMTP id a16-20020a1709027d9000b00134d97722demr1865269plm.30.1629700080193;
        Sun, 22 Aug 2021 23:28:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw9Au0/duLZTHlJC0wzzpusIjoVy6rg0evHqzqvyikarIys4G/LFXCzlPnifIHGbSty2QhnOQ==
X-Received: by 2002:a17:902:7d90:b0:134:d977:22de with SMTP id a16-20020a1709027d9000b00134d97722demr1865251plm.30.1629700079950;
        Sun, 22 Aug 2021 23:27:59 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j20sm2254119pgb.2.2021.08.22.23.27.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Aug 2021 23:27:59 -0700 (PDT)
Subject: Re: [PATCH v11 03/12] vdpa: Fix some coding style issues
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        hch@infradead.org, christian.brauner@canonical.com,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com, robin.murphy@arm.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210818120642.165-1-xieyongji@bytedance.com>
 <20210818120642.165-4-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d0ca19ee-3318-df4f-a023-c72034bbb411@redhat.com>
Date:   Mon, 23 Aug 2021 14:27:50 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210818120642.165-4-xieyongji@bytedance.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/8/18 ÏÂÎç8:06, Xie Yongji Ð´µÀ:
> Fix some code indent issues and following checkpatch warning:
>
> WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
> 371: FILE: include/linux/vdpa.h:371:
> +static inline void vdpa_get_config(struct vdpa_device *vdev, unsigned offset,
>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   include/linux/vdpa.h | 34 +++++++++++++++++-----------------
>   1 file changed, 17 insertions(+), 17 deletions(-)
>
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index 954b340f6c2f..8a645f8f4476 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -43,17 +43,17 @@ struct vdpa_vq_state_split {
>    * @last_used_idx: used index
>    */
>   struct vdpa_vq_state_packed {
> -        u16	last_avail_counter:1;
> -        u16	last_avail_idx:15;
> -        u16	last_used_counter:1;
> -        u16	last_used_idx:15;
> +	u16	last_avail_counter:1;
> +	u16	last_avail_idx:15;
> +	u16	last_used_counter:1;
> +	u16	last_used_idx:15;
>   };
>   
>   struct vdpa_vq_state {
> -     union {
> -          struct vdpa_vq_state_split split;
> -          struct vdpa_vq_state_packed packed;
> -     };
> +	union {
> +		struct vdpa_vq_state_split split;
> +		struct vdpa_vq_state_packed packed;
> +	};
>   };
>   
>   struct vdpa_mgmt_dev;
> @@ -131,7 +131,7 @@ struct vdpa_iova_range {
>    *				@vdev: vdpa device
>    *				@idx: virtqueue index
>    *				@state: pointer to returned state (last_avail_idx)
> - * @get_vq_notification: 	Get the notification area for a virtqueue
> + * @get_vq_notification:	Get the notification area for a virtqueue
>    *				@vdev: vdpa device
>    *				@idx: virtqueue index
>    *				Returns the notifcation area
> @@ -353,25 +353,25 @@ static inline struct device *vdpa_get_dma_dev(struct vdpa_device *vdev)
>   
>   static inline void vdpa_reset(struct vdpa_device *vdev)
>   {
> -        const struct vdpa_config_ops *ops = vdev->config;
> +	const struct vdpa_config_ops *ops = vdev->config;
>   
>   	vdev->features_valid = false;
> -        ops->set_status(vdev, 0);
> +	ops->set_status(vdev, 0);
>   }
>   
>   static inline int vdpa_set_features(struct vdpa_device *vdev, u64 features)
>   {
> -        const struct vdpa_config_ops *ops = vdev->config;
> +	const struct vdpa_config_ops *ops = vdev->config;
>   
>   	vdev->features_valid = true;
> -        return ops->set_features(vdev, features);
> +	return ops->set_features(vdev, features);
>   }
>   
> -
> -static inline void vdpa_get_config(struct vdpa_device *vdev, unsigned offset,
> -				   void *buf, unsigned int len)
> +static inline void vdpa_get_config(struct vdpa_device *vdev,
> +				   unsigned int offset, void *buf,
> +				   unsigned int len)
>   {
> -        const struct vdpa_config_ops *ops = vdev->config;
> +	const struct vdpa_config_ops *ops = vdev->config;
>   
>   	/*
>   	 * Config accesses aren't supposed to trigger before features are set.

