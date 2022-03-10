Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 696434D5243
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 20:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245409AbiCJSX7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 13:23:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239692AbiCJSX7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 13:23:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CFB02BF97C
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 10:22:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646936575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OUsx2B8DPPUnwo9W++AgxGnDV4EWGqmUAKP5ASwmHJw=;
        b=Ay7c6HYr7B9geLbqbeHYVLw/oEqKadwu+ze0fAXrXOsFHoHX2RtTsRyJaghl/rseNv86QE
        FkxybUsefMXCuXatt8FAqbbRE0/w5F8FSnA6G2A3iVPwyQZD2VD9CgjUdPIALTIEbAA1Fz
        Hf7O9pnF+VjF9HQzSMfGREBcevsxVUM=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-117-nCkdzddJOaOlC0rHP6s6YQ-1; Thu, 10 Mar 2022 13:22:46 -0500
X-MC-Unique: nCkdzddJOaOlC0rHP6s6YQ-1
Received: by mail-qv1-f72.google.com with SMTP id fw9-20020a056214238900b0043522aa5b81so5473315qvb.21
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 10:22:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OUsx2B8DPPUnwo9W++AgxGnDV4EWGqmUAKP5ASwmHJw=;
        b=BIFvug9sgHaQFU6tkHHomN9GF91XOPeNlLZBFmihfGIYpuedIvJIf4CXCb4OaLbe24
         1YVGEklAweVJSIsdFLHOGv3ghwW/XQhi5GNV62nRDduGlF2DbNcjPsmtbaNF6G01BeRR
         SspnjRVmd3Sp2DlwmNI3K3c3JM6oRzG1ysO4XBUaUpLmFM+yZHdTAFVqggkZnPbd1JqJ
         VddyMpapQUwe6GD5HnTGf4Bws5ZkAdngNWQ8+k9+KzR4ObvHqBvmg2POqFzPUoocV9xd
         s3vK+7Hjp8Fd66JKkruFwDI86VfClVlnj24CxEFMBtmtzZWfQQ7AhTo+auWUaOE2Q0sM
         UkVQ==
X-Gm-Message-State: AOAM530l0F/d5c5msmFO37TH+CyxIxOfBrF86H+rA3qfUxywGFzaCfFI
        CaXPNNjQxwPrm2PfK7fmATyXuzyfdWOx1cmb64BHsCIjLzUnUYcKZUEVFUN7sTpjz1Xup9Ikp2r
        xKF//s0WW/pSYxbK4qTLG/R1zrHQF
X-Received: by 2002:a05:6214:e43:b0:435:a753:2434 with SMTP id o3-20020a0562140e4300b00435a7532434mr5025315qvc.40.1646936562519;
        Thu, 10 Mar 2022 10:22:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwPfaHMXlT/QhUUEEw33PgTEhfdzxWFogWNltCegaSsdnJWLI/ODTwtUN7FkKmpLxGT5JhbfCFHsm4LVrsmAUs=
X-Received: by 2002:a05:6214:e43:b0:435:a753:2434 with SMTP id
 o3-20020a0562140e4300b00435a7532434mr5025288qvc.40.1646936562306; Thu, 10 Mar
 2022 10:22:42 -0800 (PST)
MIME-Version: 1.0
References: <20201216064818.48239-1-jasowang@redhat.com> <20220224212314.1326-1-gdawar@xilinx.com>
 <20220224212314.1326-19-gdawar@xilinx.com>
In-Reply-To: <20220224212314.1326-19-gdawar@xilinx.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 10 Mar 2022 19:22:06 +0100
Message-ID: <CAJaqyWeW87TqKxNWPEayyi81uBd_W+Jekdt4sq_d9adCkbwp2g@mail.gmail.com>
Subject: Re: [RFC PATCH v2 18/19] vdpa_sim: filter destination mac address
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

On Thu, Feb 24, 2022 at 10:29 PM Gautam Dawar <gautam.dawar@xilinx.com> wrote:
>
> This patch implements a simple unicast filter for vDPA simulator.
>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
> ---
>  drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 49 ++++++++++++++++++----------
>  1 file changed, 31 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> index 05d552cb7f94..ed5ade4ae570 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> @@ -47,13 +47,28 @@ static void vdpasim_net_complete(struct vdpasim_virtqueue *vq, size_t len)
>         local_bh_enable();
>  }
>
> +static bool receive_filter(struct vdpasim *vdpasim, size_t len)
> +{
> +       bool modern = vdpasim->features & (1ULL << VIRTIO_F_VERSION_1);
> +       size_t hdr_len = modern ? sizeof(struct virtio_net_hdr_v1) :
> +                                 sizeof(struct virtio_net_hdr);
> +
> +       if (len < ETH_ALEN + hdr_len)
> +               return false;
> +
> +       if (!strncmp(vdpasim->buffer + hdr_len,
> +                    vdpasim->config.mac, ETH_ALEN))
> +               return true;
> +
> +       return false;
> +}
> +
>  static void vdpasim_net_work(struct work_struct *work)
>  {
>         struct vdpasim *vdpasim = container_of(work, struct vdpasim, work);
>         struct vdpasim_virtqueue *txq = &vdpasim->vqs[1];
>         struct vdpasim_virtqueue *rxq = &vdpasim->vqs[0];
>         ssize_t read, write;
> -       size_t total_write;
>         int pkts = 0;
>         int err;
>
> @@ -66,36 +81,34 @@ static void vdpasim_net_work(struct work_struct *work)
>                 goto out;
>
>         while (true) {
> -               total_write = 0;
>                 err = vringh_getdesc_iotlb(&txq->vring, &txq->out_iov, NULL,
>                                            &txq->head, GFP_ATOMIC);
>                 if (err <= 0)
>                         break;
>
> +               read = vringh_iov_pull_iotlb(&txq->vring, &txq->out_iov,
> +                                            vdpasim->buffer,
> +                                            PAGE_SIZE);
> +
> +               if (!receive_filter(vdpasim, read)) {
> +                       vdpasim_complete(txq, 0);

vdpasim_net_complete?

Thanks!

> +                       continue;
> +               }
> +
>                 err = vringh_getdesc_iotlb(&rxq->vring, NULL, &rxq->in_iov,
>                                            &rxq->head, GFP_ATOMIC);
>                 if (err <= 0) {
> -                       vringh_complete_iotlb(&txq->vring, txq->head, 0);
> +                       vdpasim_net_complete(txq, 0);
>                         break;
>                 }
>
> -               while (true) {
> -                       read = vringh_iov_pull_iotlb(&txq->vring, &txq->out_iov,
> -                                                    vdpasim->buffer,
> -                                                    PAGE_SIZE);
> -                       if (read <= 0)
> -                               break;
> -
> -                       write = vringh_iov_push_iotlb(&rxq->vring, &rxq->in_iov,
> -                                                     vdpasim->buffer, read);
> -                       if (write <= 0)
> -                               break;
> -
> -                       total_write += write;
> -               }
> +               write = vringh_iov_push_iotlb(&rxq->vring, &rxq->in_iov,
> +                                             vdpasim->buffer, read);
> +               if (write <= 0)
> +                       break;
>
>                 vdpasim_net_complete(txq, 0);
> -               vdpasim_net_complete(rxq, total_write);
> +               vdpasim_net_complete(rxq, write);
>
>                 if (++pkts > 4) {
>                         schedule_work(&vdpasim->work);
> --
> 2.25.0
>

