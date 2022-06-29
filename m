Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95D0155F509
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 06:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbiF2ENb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 00:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231529AbiF2ENC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 00:13:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 57EEB3A724
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 21:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656475964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GNM+BbnxY/R2xbw+iRFV6Wl10CXwSKS8xeWt77Ki534=;
        b=LErCZfp2nKpakADTdPJ8cVNrXsAOWv4OqBrK8DjK4TL4+0Uf9eyriRG9KPMZJz65nxU4gf
        ZWm8E2Oa9zZU/8mo6vooeFTGJhXjROaXUYqtOtLywnCRpWUhKcuLoLLOKVnrCOfgGlFKtN
        43A1B11AVUW1LitsyCD1VV6OTj20h88=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-363-HD2IqWMfPDacil_yC9jXpg-1; Wed, 29 Jun 2022 00:12:40 -0400
X-MC-Unique: HD2IqWMfPDacil_yC9jXpg-1
Received: by mail-lf1-f72.google.com with SMTP id bp15-20020a056512158f00b0047f603e5f92so7176649lfb.20
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 21:12:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GNM+BbnxY/R2xbw+iRFV6Wl10CXwSKS8xeWt77Ki534=;
        b=wJdd5DGP6QVR9zXaFmL8rzUyn505VqLj7GSO3HIGyC/pRiDfGdhXJmN+VKjOfXPYNw
         4IaAJcXfGSmh/FWFwjqkNRrTqCRUiJiX26WwYJHGKgitwDgabU7u1r8VTudZrGx6jktE
         qw/Oo0ZYX9h8oIxka+PW9uO72fLtZ6HI4LZ0Z7O26ssIPs4xmijwyczKIA61S149YJ+D
         44ZwzUhfcQ1rzf/bJ/5DVP5PSeMR7T/dmt3KNwBPvv22PnQt0ItWwQ9mndh7heg+ntMa
         lqc/UDAjtDXc6vBmO67BJbpo4JwecjnrzCxXEvJZPcJ46+RvoNMAWYBPFjAe0tWvtEZy
         Gtjw==
X-Gm-Message-State: AJIora/DUIys0A1guHxTiXgY/8bIk2xl7LkpLzHw1XHCcexLc94gIst6
        ysq2AJk2b8rYl8A++DzJdoZYDlxoPoHwJIK2j8gl7KT5sSZUPzRt8gQ/ep8tV7ol0G9Q3MUglET
        UCHezDRrkh86aDvd+VfPNVcMTDCmB
X-Received: by 2002:a05:651c:895:b0:250:c5ec:bc89 with SMTP id d21-20020a05651c089500b00250c5ecbc89mr574053ljq.251.1656475958717;
        Tue, 28 Jun 2022 21:12:38 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tHRCeQEYFeDihZwqrb3gPA69zDi6jWiWd/DBiz6ym7vRZ1l6srncfxGDke2JCiHZCDM5Ja741bHC00eazMkAU=
X-Received: by 2002:a05:651c:895:b0:250:c5ec:bc89 with SMTP id
 d21-20020a05651c089500b00250c5ecbc89mr574045ljq.251.1656475958454; Tue, 28
 Jun 2022 21:12:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220623160738.632852-1-eperezma@redhat.com> <20220623160738.632852-3-eperezma@redhat.com>
In-Reply-To: <20220623160738.632852-3-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 29 Jun 2022 12:12:27 +0800
Message-ID: <CACGkMEtNC=4KeigQXr4NuaiuVGkxK2ruQTk6-Fbr3B1MqHieTA@mail.gmail.com>
Subject: Re: [PATCH v6 2/4] vhost-vdpa: introduce SUSPEND backend feature bit
To:     =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Cindy Lu <lulu@redhat.com>,
        "Kamde, Tanuj" <tanuj.kamde@amd.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "Uminski, Piotr" <Piotr.Uminski@intel.com>,
        habetsm.xilinx@gmail.com, "Dawar, Gautam" <gautam.dawar@amd.com>,
        Pablo Cascon Katchadourian <pabloc@xilinx.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Longpeng <longpeng2@huawei.com>,
        Dinan Gunawardena <dinang@xilinx.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Martin Porter <martinpo@xilinx.com>,
        Eli Cohen <elic@nvidia.com>, ecree.xilinx@gmail.com,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 24, 2022 at 12:08 AM Eugenio P=C3=A9rez <eperezma@redhat.com> w=
rote:
>
> Userland knows if it can suspend the device or not by checking this featu=
re
> bit.
>
> It's only offered if the vdpa driver backend implements the suspend()
> operation callback, and to offer it or userland to ack it if the backend
> does not offer that callback is an error.
>
> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> ---
>  drivers/vhost/vdpa.c             | 16 +++++++++++++++-
>  include/uapi/linux/vhost_types.h |  2 ++
>  2 files changed, 17 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 23dcbfdfa13b..3d636e192061 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -347,6 +347,14 @@ static long vhost_vdpa_set_config(struct vhost_vdpa =
*v,
>         return 0;
>  }
>
> +static bool vhost_vdpa_can_suspend(const struct vhost_vdpa *v)
> +{
> +       struct vdpa_device *vdpa =3D v->vdpa;
> +       const struct vdpa_config_ops *ops =3D vdpa->config;
> +
> +       return ops->suspend;
> +}
> +
>  static long vhost_vdpa_get_features(struct vhost_vdpa *v, u64 __user *fe=
aturep)
>  {
>         struct vdpa_device *vdpa =3D v->vdpa;
> @@ -577,7 +585,11 @@ static long vhost_vdpa_unlocked_ioctl(struct file *f=
ilep,
>         if (cmd =3D=3D VHOST_SET_BACKEND_FEATURES) {
>                 if (copy_from_user(&features, featurep, sizeof(features))=
)
>                         return -EFAULT;
> -               if (features & ~VHOST_VDPA_BACKEND_FEATURES)
> +               if (features & ~(VHOST_VDPA_BACKEND_FEATURES |
> +                                BIT_ULL(VHOST_BACKEND_F_SUSPEND)))
> +                       return -EOPNOTSUPP;
> +               if ((features & BIT_ULL(VHOST_BACKEND_F_SUSPEND)) &&
> +                    !vhost_vdpa_can_suspend(v))

Do we need to advertise this to the management?

Thanks

>                         return -EOPNOTSUPP;
>                 vhost_set_backend_features(&v->vdev, features);
>                 return 0;
> @@ -628,6 +640,8 @@ static long vhost_vdpa_unlocked_ioctl(struct file *fi=
lep,
>                 break;
>         case VHOST_GET_BACKEND_FEATURES:
>                 features =3D VHOST_VDPA_BACKEND_FEATURES;
> +               if (vhost_vdpa_can_suspend(v))
> +                       features |=3D BIT_ULL(VHOST_BACKEND_F_SUSPEND);
>                 if (copy_to_user(featurep, &features, sizeof(features)))
>                         r =3D -EFAULT;
>                 break;
> diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_=
types.h
> index 634cee485abb..1bdd6e363f4c 100644
> --- a/include/uapi/linux/vhost_types.h
> +++ b/include/uapi/linux/vhost_types.h
> @@ -161,5 +161,7 @@ struct vhost_vdpa_iova_range {
>   * message
>   */
>  #define VHOST_BACKEND_F_IOTLB_ASID  0x3
> +/* Device can be suspended */
> +#define VHOST_BACKEND_F_SUSPEND  0x4
>
>  #endif
> --
> 2.31.1
>

