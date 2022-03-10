Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFEBE4D510B
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 18:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245025AbiCJR51 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 12:57:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238376AbiCJR50 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 12:57:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F51F15FC87
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 09:56:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646934984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rkPBo3Z97DCJCmqrebEMdZGQBy/a9FPya5vrhdSYtWI=;
        b=ZgIXzzmFlgJLh3Icmr5Z4nOyPl8IS01CTmgPvS1s+FrOlMOGPFSYNMrOJKJAs1oqI4Yipq
        53jsR5uOW70Ds7b80vIX9ZY4LGM6HDUu7+HNWgS1QSdAN40i1eByFIrIwQ1oul3CMlFWqv
        jeBGmNwlgg21V8HWM+3Y8RFdW8fmTk8=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-477-LI1rndAxNJyc7QsfHMMDRg-1; Thu, 10 Mar 2022 12:56:23 -0500
X-MC-Unique: LI1rndAxNJyc7QsfHMMDRg-1
Received: by mail-qv1-f71.google.com with SMTP id a9-20020ad45c49000000b004352ae97476so5446274qva.13
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 09:56:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rkPBo3Z97DCJCmqrebEMdZGQBy/a9FPya5vrhdSYtWI=;
        b=Lno8Wrwds62YqMpaS8IjISUkyLQesp72eFRrudUSwP0GMrB02tyG+CxdwFHUokTdY/
         kAo0gH83SB/Zf5Zu4zCXUx2muTO0LNd68eNYnZ/FXJuxutgZRbSrr3q0Y8lo2zWFvPJk
         LThmEYFw5eXn2kkEytQoFB8wXdv/JEIgZZF8TF+7EfJDolIfNnIWwc4yZpUeB0J59aS5
         Ai9sH22t9rRD3pVZYv3ZKTVQI9+6Kcs0TrqzHCE8Hn3EBLLUtJ6Ihzjz4Pp+0qB97FtF
         i8KWyrJ3KMicKXiy4DycP6wYp1X/LpA1OgO0+610kmV/AJGK8kS8iBgJAeKXPlFHHp/E
         3M/g==
X-Gm-Message-State: AOAM531112jIH5xqaTxJLkEFX0R4dPqDzMStzfvHVI9i0ijut4h0osGc
        MItXFLxpS6LyoPYZo3M/PfIlU6VcMpEjbtWCJHq6q6Uoeua1ZkuwLQFrYWMQ+HB1P0mfoa0LtQl
        +VRjUzQFsETX/NGIHN1+uFybyh5bD
X-Received: by 2002:a05:620a:17a6:b0:67b:cd:72d0 with SMTP id ay38-20020a05620a17a600b0067b00cd72d0mr3931891qkb.406.1646934982806;
        Thu, 10 Mar 2022 09:56:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw6gBoE5AIyUGB0jDDVS5NvaCAYKFicqPjbo6Ono52Y1893x8AibQaTsESSBkY/CW41ZRbNkWXV1gxZ2YZELXA=
X-Received: by 2002:a05:620a:17a6:b0:67b:cd:72d0 with SMTP id
 ay38-20020a05620a17a600b0067b00cd72d0mr3931868qkb.406.1646934982618; Thu, 10
 Mar 2022 09:56:22 -0800 (PST)
MIME-Version: 1.0
References: <20201216064818.48239-1-jasowang@redhat.com> <20220224212314.1326-1-gdawar@xilinx.com>
 <20220224212314.1326-17-gdawar@xilinx.com>
In-Reply-To: <20220224212314.1326-17-gdawar@xilinx.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 10 Mar 2022 18:55:46 +0100
Message-ID: <CAJaqyWekkJEJufrWGx83eaDj2Osi2E_r=K9rY0Qh+iFb1fJ+yA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 16/19] vdpa_sim: advertise VIRTIO_NET_F_MTU
To:     Gautam Dawar <gautam.dawar@xilinx.com>
Cc:     Gautam Dawar <gdawar@xilinx.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Tanuj Murlidhar Kamde <tanujk@xilinx.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Eli Cohen <elic@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Parav Pandit <parav@nvidia.com>,
        Longpeng <longpeng2@huawei.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 24, 2022 at 10:28 PM Gautam Dawar <gautam.dawar@xilinx.com> wrote:
>
> We've already reported maximum mtu via config space, so let's
> advertise the feature.
>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
> ---
>  drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> index d5324f6fd8c7..ff22cc56f40b 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> @@ -26,7 +26,8 @@
>  #define DRV_LICENSE  "GPL v2"
>
>  #define VDPASIM_NET_FEATURES   (VDPASIM_FEATURES | \
> -                                (1ULL << VIRTIO_NET_F_MAC))
> +                                (1ULL << VIRTIO_NET_F_MAC) | \
> +                                (1ULL << VIRTIO_NET_F_MTU));

Extra semicolon at the end of macro.

Thanks.

>
>  #define VDPASIM_NET_VQ_NUM     2
>
> --
> 2.25.0
>

