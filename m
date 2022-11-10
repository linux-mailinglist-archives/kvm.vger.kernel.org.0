Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9ED0623B68
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 06:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiKJFlw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 00:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiKJFlv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 00:41:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70ABD178B5
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 21:40:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668058852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KNVESHMXm8XLHqmpP/5Naw7okC4rI80zGLYxXKZMM6o=;
        b=hsLJtTHqFjjVKkzAMJaTJiD9xZtD1ZbAu3Xi24pPEviBotMh8QFeWqKeIOKEJwT7ABfEM/
        U/J1zEkbe5U0BPzMf+PYYd8PoKKItiEubcxmD3z/LiP6iNzlfcGeamydrre8jBPNyEjXZt
        BPBicuAsp8lmyFTX5HTZopaFFru4pgY=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-245-xDnh2ccKP7OI5tUy2Pi4qA-1; Thu, 10 Nov 2022 00:40:50 -0500
X-MC-Unique: xDnh2ccKP7OI5tUy2Pi4qA-1
Received: by mail-pl1-f200.google.com with SMTP id t3-20020a170902e84300b00186ab03043dso666461plg.20
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 21:40:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KNVESHMXm8XLHqmpP/5Naw7okC4rI80zGLYxXKZMM6o=;
        b=oOg4zAucod9+3IuLkLSP2Ujeas09R+NnJ2tD/PRRl1liQjyUCcKlk9OHPPMYTMUtk5
         j6/fbCF+FT37wpd3wLB2e5E/YNIU7kcNq+T3l8o5KcUUw3GYipuz8LtJ1mFMow01+q0P
         qiz/IP7TBjwom+Z7dU1jQiNTYQ+2dtSlB5MvZpbOih2VaHZFoR09IiyB+zIyV+brEwb7
         nYLOskSDf3bT9Dcc3yP3JxW8KSNXh/BokNTa7cxhvtteaqQirFbqaCyEu7sE0Wz4gZdA
         9Nb7PKdBIHopqh86ZhANsWuaii/P1iT14UVqpnHplL++T9Lgzf/4UaLM5EZhHS2PJ0jm
         Hysg==
X-Gm-Message-State: ACrzQf2e/MIGKRH3Ic4tfE0tLIiKeokfp5eO6cJLEtVNHlotb6ssBmtS
        N9Esz9bQ/QTxWHrt5Qr0Zkx3grFiOlnp0qdVFByk28PcqVsugLirUdjpGWLS69VogIPY8GNdEs0
        9CiootJMtB75r
X-Received: by 2002:a17:902:e745:b0:187:2033:1832 with SMTP id p5-20020a170902e74500b0018720331832mr55580830plf.119.1668058849826;
        Wed, 09 Nov 2022 21:40:49 -0800 (PST)
X-Google-Smtp-Source: AMsMyM6MlPDUf0LLkCc9kum3CdKh2TL8pGtBzVG4EX5JLDgqAznrRCBMNu3on0DUJLj0JobGM/g/2g==
X-Received: by 2002:a17:902:e745:b0:187:2033:1832 with SMTP id p5-20020a170902e74500b0018720331832mr55580818plf.119.1668058849561;
        Wed, 09 Nov 2022 21:40:49 -0800 (PST)
Received: from [10.72.13.112] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 12-20020a63124c000000b0046f8e444edfsm7895121pgs.60.2022.11.09.21.40.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 21:40:48 -0800 (PST)
Message-ID: <56bfad97-74d2-8570-c391-83ecf9965cfd@redhat.com>
Date:   Thu, 10 Nov 2022 13:40:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH v6 05/10] vdpa: move SVQ vring features check to net/
To:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Parav Pandit <parav@mellanox.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Cindy Lu <lulu@redhat.com>, Eli Cohen <eli@mellanox.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, kvm@vger.kernel.org,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20221108170755.92768-1-eperezma@redhat.com>
 <20221108170755.92768-6-eperezma@redhat.com>
Content-Language: en-US
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20221108170755.92768-6-eperezma@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2022/11/9 01:07, Eugenio Pérez 写道:
> The next patches will start control SVQ if possible. However, we don't
> know if that will be possible at qemu boot anymore.


If I was not wrong, there's no device specific feature that is checked 
in the function. So it should be general enough to be used by devices 
other than net. Then I don't see any advantage of doing this.

Thanks


>
> Since the moved checks will be already evaluated at net/ to know if it
> is ok to shadow CVQ, move them.
>
> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
> ---
>   hw/virtio/vhost-vdpa.c | 33 ++-------------------------------
>   net/vhost-vdpa.c       |  3 ++-
>   2 files changed, 4 insertions(+), 32 deletions(-)
>
> diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> index 3df2775760..146f0dcb40 100644
> --- a/hw/virtio/vhost-vdpa.c
> +++ b/hw/virtio/vhost-vdpa.c
> @@ -402,29 +402,9 @@ static int vhost_vdpa_get_dev_features(struct vhost_dev *dev,
>       return ret;
>   }
>   
> -static int vhost_vdpa_init_svq(struct vhost_dev *hdev, struct vhost_vdpa *v,
> -                               Error **errp)
> +static void vhost_vdpa_init_svq(struct vhost_dev *hdev, struct vhost_vdpa *v)
>   {
>       g_autoptr(GPtrArray) shadow_vqs = NULL;
> -    uint64_t dev_features, svq_features;
> -    int r;
> -    bool ok;
> -
> -    if (!v->shadow_vqs_enabled) {
> -        return 0;
> -    }
> -
> -    r = vhost_vdpa_get_dev_features(hdev, &dev_features);
> -    if (r != 0) {
> -        error_setg_errno(errp, -r, "Can't get vdpa device features");
> -        return r;
> -    }
> -
> -    svq_features = dev_features;
> -    ok = vhost_svq_valid_features(svq_features, errp);
> -    if (unlikely(!ok)) {
> -        return -1;
> -    }
>   
>       shadow_vqs = g_ptr_array_new_full(hdev->nvqs, vhost_svq_free);
>       for (unsigned n = 0; n < hdev->nvqs; ++n) {
> @@ -436,7 +416,6 @@ static int vhost_vdpa_init_svq(struct vhost_dev *hdev, struct vhost_vdpa *v,
>       }
>   
>       v->shadow_vqs = g_steal_pointer(&shadow_vqs);
> -    return 0;
>   }
>   
>   static int vhost_vdpa_init(struct vhost_dev *dev, void *opaque, Error **errp)
> @@ -461,11 +440,7 @@ static int vhost_vdpa_init(struct vhost_dev *dev, void *opaque, Error **errp)
>       dev->opaque =  opaque ;
>       v->listener = vhost_vdpa_memory_listener;
>       v->msg_type = VHOST_IOTLB_MSG_V2;
> -    ret = vhost_vdpa_init_svq(dev, v, errp);
> -    if (ret) {
> -        goto err;
> -    }
> -
> +    vhost_vdpa_init_svq(dev, v);
>       vhost_vdpa_get_iova_range(v);
>   
>       if (!vhost_vdpa_first_dev(dev)) {
> @@ -476,10 +451,6 @@ static int vhost_vdpa_init(struct vhost_dev *dev, void *opaque, Error **errp)
>                                  VIRTIO_CONFIG_S_DRIVER);
>   
>       return 0;
> -
> -err:
> -    ram_block_discard_disable(false);
> -    return ret;
>   }
>   
>   static void vhost_vdpa_host_notifier_uninit(struct vhost_dev *dev,
> diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
> index d3b1de481b..fb35b17ab4 100644
> --- a/net/vhost-vdpa.c
> +++ b/net/vhost-vdpa.c
> @@ -117,9 +117,10 @@ static bool vhost_vdpa_net_valid_svq_features(uint64_t features, Error **errp)
>       if (invalid_dev_features) {
>           error_setg(errp, "vdpa svq does not work with features 0x%" PRIx64,
>                      invalid_dev_features);
> +        return false;
>       }
>   
> -    return !invalid_dev_features;
> +    return vhost_svq_valid_features(features, errp);
>   }
>   
>   static int vhost_vdpa_net_check_device_id(struct vhost_net *net)

