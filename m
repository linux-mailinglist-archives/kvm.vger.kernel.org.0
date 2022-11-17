Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADF562D2E0
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 06:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238973AbiKQFqL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 00:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234881AbiKQFqI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 00:46:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202BF5EFA4
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 21:45:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668663910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=56i049Aed0JKBuVol4TWmhK7+K9RgEQ60fNagERMDS8=;
        b=L9gI5UFZU0Vim0LGmQcH2qkEkpsf8Iakva392QEElv0ov54E3Ae7yyeQyyuXK+xsMi5BuJ
        BA9wSL9Bi9oytNncRq3dv4rewnsFovoE2P6SF9xyWvcEgynLiU+lCBLRvNybApjVBsNTbQ
        D+Qz1T466eAGQnocCeqGoWyGeeLNbc8=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-510-Fgfz9ad3NNGX9IlqbPiKIA-1; Thu, 17 Nov 2022 00:45:08 -0500
X-MC-Unique: Fgfz9ad3NNGX9IlqbPiKIA-1
Received: by mail-oo1-f70.google.com with SMTP id u5-20020a4a6145000000b0049f4b251d54so476538ooe.13
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 21:45:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=56i049Aed0JKBuVol4TWmhK7+K9RgEQ60fNagERMDS8=;
        b=vl2EpiuUc3SImKD2qM2jvvnVDl3O29JcbNIeDtJjETiN2sxgNDtlxyqwkmidrgbikJ
         n+k996TzM4Zea+5iy4JT9DqZGl1hCEK+ltevId3S4nzE5L0FZZWeimQxYmwhOzbuLFfs
         jURKQkA1uDcpdIItBfktIdZMeGwCAm4PmcJ5MMqUgsWMvUsbQi+6f4BQdz46/ulxB2q9
         gPXIGGoQiHw55SCBCKIR5ZGUyjMPaCroPnkRs8csrKoe9/aXaltFcJ52RvwZTa/OT0SS
         XHbHGzy2DJc/dG3LHeHrdTifld0X/qFbmfIbA1P7JiBXeHKc+bQBtxdy8JMN6yb48KnQ
         ntCQ==
X-Gm-Message-State: ANoB5pnFuaEOSvXWXot724vtVeO9+SnHY/hNwreHRTPQL72c529IK0Bo
        SH/BMe/Y9v65061p0vKInftSUyNqnOHRf4HJGbXGzLvMbcsiTyfr6sLrmy58xCVcsvarcNQjibm
        uKdfcixQ0dowj12LXLoS7XXQizsAF
X-Received: by 2002:a05:6808:220b:b0:359:f5eb:82ec with SMTP id bd11-20020a056808220b00b00359f5eb82ecmr416038oib.280.1668663907742;
        Wed, 16 Nov 2022 21:45:07 -0800 (PST)
X-Google-Smtp-Source: AA0mqf76rMnpgnQjp6/ZhWLOS0qNtuIB6e3PWR7W+GcYDBtIVg+L09dpqBCuDpSDlzQEO/Uy3jtO6xdLIcbXnqVgd8o=
X-Received: by 2002:a05:6808:220b:b0:359:f5eb:82ec with SMTP id
 bd11-20020a056808220b00b00359f5eb82ecmr416026oib.280.1668663907571; Wed, 16
 Nov 2022 21:45:07 -0800 (PST)
MIME-Version: 1.0
References: <20221116150556.1294049-1-eperezma@redhat.com> <20221116150556.1294049-7-eperezma@redhat.com>
In-Reply-To: <20221116150556.1294049-7-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 17 Nov 2022 13:44:56 +0800
Message-ID: <CACGkMEv1D5eMz=j6CRYPc2Quve5Z3-ikDCeLcObiFYctnhYGLg@mail.gmail.com>
Subject: Re: [PATCH for 8.0 v7 06/10] vdpa: Allocate SVQ unconditionally
To:     =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>
Cc:     qemu-devel@nongnu.org, Cornelia Huck <cohuck@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>, Eli Cohen <eli@mellanox.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Cindy Lu <lulu@redhat.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Parav Pandit <parav@mellanox.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 16, 2022 at 11:06 PM Eugenio P=C3=A9rez <eperezma@redhat.com> w=
rote:
>
> SVQ may run or not in a device depending on runtime conditions (for
> example, if the device can move CVQ to its own group or not).
>
> Allocate the SVQ array unconditionally at startup, since its hard to
> move this allocation elsewhere.
>
> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  hw/virtio/vhost-vdpa.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> index 146f0dcb40..23efb8f49d 100644
> --- a/hw/virtio/vhost-vdpa.c
> +++ b/hw/virtio/vhost-vdpa.c
> @@ -547,10 +547,6 @@ static void vhost_vdpa_svq_cleanup(struct vhost_dev =
*dev)
>      struct vhost_vdpa *v =3D dev->opaque;
>      size_t idx;
>
> -    if (!v->shadow_vqs) {
> -        return;
> -    }
> -
>      for (idx =3D 0; idx < v->shadow_vqs->len; ++idx) {
>          vhost_svq_stop(g_ptr_array_index(v->shadow_vqs, idx));
>      }
> --
> 2.31.1
>

