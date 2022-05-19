Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C19D452D68B
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 16:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238659AbiESO6A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 10:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239776AbiESO55 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 10:57:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0AB13D8096
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 07:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652972276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c8jDbEvRi6+iV6qqKNcRhWpgw9xMZvSzaM7VjjYN6zI=;
        b=HZ6gmaDalgkxsjc2YrTAy1EaoFrAfBMuAE4mBCDQV/Tsw0Ie8HUFQ0KumZI04g5W/jzGDZ
        CK/pI0UjLbV6fNyMTa4bEXu96KWhoX5NhjPoDv+SS3cR7djPgCP1qHaIYVN42FqfkepEL/
        CPQcg/ONnZNMRE6gLunsf1LZ5sq/syY=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-23pHcOF0MT-ag1zHJlFhtg-1; Thu, 19 May 2022 10:57:55 -0400
X-MC-Unique: 23pHcOF0MT-ag1zHJlFhtg-1
Received: by mail-qk1-f199.google.com with SMTP id a5-20020ae9e805000000b006a034b31384so4332636qkg.8
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 07:57:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=c8jDbEvRi6+iV6qqKNcRhWpgw9xMZvSzaM7VjjYN6zI=;
        b=3AB724PDpkwER6CqTSPCrPA1yQOmN7Uo06FKgxOMMgNlw5NYQ4qLWcN+OuFeXg0avp
         eLAD7Mpe7sDic2gz1eDq7sYCtDluYlbLup8pESwTl0uZ4DHS5aSAT8Va4rQDjEe4rBl2
         Tfc/IfnlFdN+Gg8LcbwEGQHBqLcI2qcHxT6e00LMS5LJgKAdjM1sN2U9ng5bHQxZQGVp
         nE/EfvBnBIBqoD16KE7e43Pmfmig2d9eDCNMs+yn2bKAW0WMPTuOaP5w+QiaaZAQmCXf
         qJOA89JdkMwM9C7QSP+8moTNw6p2/vvv6v6uCInm5gdfSOIS2MzGYQ9rrzX3nfJaRX99
         BKuw==
X-Gm-Message-State: AOAM533lSnqIDufw/RVFeiOQEUAQjQ2GKsx+UDtOI7aYFnTg5qhuz7eW
        Om/7HcvpsY9zMY4Eht2wqNH42DGNq/JFokUrZJPrATMFzE+JWY//jYAxIKIFowCnn4UXlxfy0EH
        /nrALK2jQzbvNoeh7KlNP07pMHrc3
X-Received: by 2002:a05:622a:1899:b0:2f3:b09e:dbe9 with SMTP id v25-20020a05622a189900b002f3b09edbe9mr4153445qtc.199.1652972274461;
        Thu, 19 May 2022 07:57:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy5fazVz2A8H1loe5PClxt9eyMGCIRyQO4I122g38usxKCQLkuCLe8K4TMfFt2GmgorC7+KG/yG0SowbzBLDLc=
X-Received: by 2002:a05:622a:1899:b0:2f3:b09e:dbe9 with SMTP id
 v25-20020a05622a189900b002f3b09edbe9mr4153431qtc.199.1652972274265; Thu, 19
 May 2022 07:57:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220519143145.767845-1-eperezma@redhat.com> <20220519144801.m7ioxoa5beo5jzv7@sgarzare-redhat>
In-Reply-To: <20220519144801.m7ioxoa5beo5jzv7@sgarzare-redhat>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 19 May 2022 16:57:18 +0200
Message-ID: <CAJaqyWfywBEe21P1a1LG2v=Ab2d-L5x19MrtWLvDqccOxFLMqQ@mail.gmail.com>
Subject: Re: [PATCH] vdpasim: allow to enable a vq repeatedly
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Michael Tsirkin <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        linux-kernel@vger.kernel.org, Gautam Dawar <gdawar@xilinx.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        kvm list <kvm@vger.kernel.org>, Cindy Lu <lulu@redhat.com>,
        netdev@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Eli Cohen <eli@mellanox.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Parav Pandit <parav@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 19, 2022 at 4:48 PM Stefano Garzarella <sgarzare@redhat.com> wr=
ote:
>
> On Thu, May 19, 2022 at 04:31:45PM +0200, Eugenio P=C3=A9rez wrote:
> >Code must be resilient to enable a queue many times.
> >
> >At the moment the queue is resetting so it's definitely not the expected
> >behavior.
> >
> >Fixes: 2c53d0f64c06 ("vdpasim: vDPA device simulator")
> >Cc: stable@vger.kernel.org
> >Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> >---
> > drivers/vdpa/vdpa_sim/vdpa_sim.c | 5 +++--
> > 1 file changed, 3 insertions(+), 2 deletions(-)
> >
> >diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vd=
pa_sim.c
> >index ddbe142af09a..b53cd00ad161 100644
> >--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> >+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> >@@ -355,9 +355,10 @@ static void vdpasim_set_vq_ready(struct vdpa_device=
 *vdpa, u16 idx, bool ready)
> >       struct vdpasim_virtqueue *vq =3D &vdpasim->vqs[idx];
> >
> >       spin_lock(&vdpasim->lock);
> >-      vq->ready =3D ready;
> >-      if (vq->ready)
> >+      if (!vq->ready) {
> >+              vq->ready =3D ready;
> >               vdpasim_queue_ready(vdpasim, idx);
> >+      }
>
> But this way the first time vq->ready is set to true, then it will never
> be set back to false.
>

You're right, I had in mind to reset the flow before enabling as the
only possibility.

Sending v2 with that part fixed, thanks!

> Should we leave the assignment out of the block?
> Maybe after the if block to avoid the problem we are fixing.
>
> Thanks,
> Stefano
>

