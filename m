Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4A056B88B
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 13:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237934AbiGHL3T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 07:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237958AbiGHL3M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 07:29:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5ADAEBCA8
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 04:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657279750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pQ8hI7tAToAaGENhoelGGeUPhfdGj6ZA32YUdh4TI7g=;
        b=BLM6o7cR296ZgaMDtCR7UlAxknC6hOVrmDqDWC2uD1BfIT93Z4zB2Hem98OLZM/roVhYJg
        YleQIgzyeLSNhQ3PT19kq9ZXPpfjAMHOE1GrpwZY+CaK+fdaN1njP0OrBitrQC5JhiI38R
        pETwIfTLM2CIYNxn8rmgAYcv9SYnaZA=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-M_FJh2lOP3GtmO_he1RBpw-1; Fri, 08 Jul 2022 07:29:04 -0400
X-MC-Unique: M_FJh2lOP3GtmO_he1RBpw-1
Received: by mail-qt1-f199.google.com with SMTP id fw9-20020a05622a4a8900b0031e7a2ed350so12841833qtb.0
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 04:29:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pQ8hI7tAToAaGENhoelGGeUPhfdGj6ZA32YUdh4TI7g=;
        b=CDjUB63nOoH7odIRtLPwMxmvgcKvjy9YPM520Fxn894e7EbBqYiPVjxzXwCtTr/wMS
         CsSEafOcta4VZzXmO54lI2CWr0lUFrkuWpZ8x0xz7cTABu/iUZo+7ktlSSPIES/+vlkp
         xnzLlpUe61dxE/d6bjaNnqyh5SVcqZZTkAfrUG6xtuRh85IIclquGA8gXOknTC4ZoGQg
         R1WWSLQQ19sPvvpz7Hr1opq9Ssyka1xX7Zkg3UCzeps7BzOksbv39KWnHzX32z3inVmi
         He2zQwmmw5b60BH113kkKEHA0j7ms74GbgY9LGGIUViBtqWL90wcgyJYmzjn4vfvQriE
         YfBQ==
X-Gm-Message-State: AJIora9ZP82bqWQz0Ha6Knw29SZt1W/RweQ1EixHbJkOYSWuZFVBaFnU
        V0JWgAA9OeZsXs7eiqfdZ0e/7WM7falKxsNQPNpgMR0BmV/CNxl+IF+8WVQTq1W5rBCrIPZ4DCX
        E2uxI/KQbkeUROLfc5n+y61wHvTvR
X-Received: by 2002:ac8:5dca:0:b0:31e:85b8:8a18 with SMTP id e10-20020ac85dca000000b0031e85b88a18mr2366798qtx.370.1657279744181;
        Fri, 08 Jul 2022 04:29:04 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sentVPmK5WEA4lrN7utaqjkf+t27q8DqhRdkX0cZZhMbHLJdy+uMh1/O3NgdOS4+jT1HeWza8vKer/xm5M1KI=
X-Received: by 2002:ac8:5dca:0:b0:31e:85b8:8a18 with SMTP id
 e10-20020ac85dca000000b0031e85b88a18mr2366771qtx.370.1657279743969; Fri, 08
 Jul 2022 04:29:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220623160738.632852-1-eperezma@redhat.com> <20220623160738.632852-2-eperezma@redhat.com>
 <20220628133955.sj32sfounu4byggl@sgarzare-redhat>
In-Reply-To: <20220628133955.sj32sfounu4byggl@sgarzare-redhat>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 8 Jul 2022 13:28:27 +0200
Message-ID: <CAJaqyWcHoB6edp3Qq8Df75Si_6aBDN=qp9ggB2D5hsshCxOdjQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] vdpa: Add suspend operation
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>, Jason Wang <jasowang@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
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
        Dan Carpenter <dan.carpenter@oracle.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 28, 2022 at 3:40 PM Stefano Garzarella <sgarzare@redhat.com> wr=
ote:
>
> On Thu, Jun 23, 2022 at 06:07:35PM +0200, Eugenio P=C3=A9rez wrote:
> >This operation is optional: It it's not implemented, backend feature bit
> >will not be exposed.
> >
> >Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> >---
> > include/linux/vdpa.h | 4 ++++
> > 1 file changed, 4 insertions(+)
> >
> >diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> >index 7b4a13d3bd91..d282f464d2f1 100644
> >--- a/include/linux/vdpa.h
> >+++ b/include/linux/vdpa.h
> >@@ -218,6 +218,9 @@ struct vdpa_map_file {
> >  * @reset:                    Reset device
> >  *                            @vdev: vdpa device
> >  *                            Returns integer: success (0) or error (< =
0)
> >+ * @suspend:                  Suspend or resume the device (optional)
>                                             ^
> IIUC we removed the resume operation (that should be done with reset),
> so should we update this documentation?
>

Totally, I forgot to update the doc. I'll send a new version with that.

Thanks!


> Thanks,
> Stefano
>
> >+ *                            @vdev: vdpa device
> >+ *                            Returns integer: success (0) or error (< =
0)
> >  * @get_config_size:          Get the size of the configuration space i=
ncludes
> >  *                            fields that are conditional on feature bi=
ts.
> >  *                            @vdev: vdpa device
> >@@ -319,6 +322,7 @@ struct vdpa_config_ops {
> >       u8 (*get_status)(struct vdpa_device *vdev);
> >       void (*set_status)(struct vdpa_device *vdev, u8 status);
> >       int (*reset)(struct vdpa_device *vdev);
> >+      int (*suspend)(struct vdpa_device *vdev);
> >       size_t (*get_config_size)(struct vdpa_device *vdev);
> >       void (*get_config)(struct vdpa_device *vdev, unsigned int offset,
> >                          void *buf, unsigned int len);
> >--
> >2.31.1
> >
>

