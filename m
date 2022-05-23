Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55632530C30
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 11:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbiEWIMV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 04:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbiEWIMQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 04:12:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A6A96424
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 01:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653293532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=53MnhvYtL+/cYihHLxo4GLsLARejRnqIvuUsOxI+lBY=;
        b=F9ROI/1BV3OInshkRy94lTF6N5gUYgm1JvFsW7LMiJdS3Mz170XYIFWdEXdlOAGoIvQ6N0
        E76zYiPxXHnlHukAQ/4Z4XhcW5OJDVHpwkOJ5LaZ8kRaoes7l/ajyANQHULX/lJAEOFA+j
        t/EodEZQMRqbDJnona0/lE3M86Vt6ik=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-43-mxLcA84bNbiqoNK6qLdL9w-1; Mon, 23 May 2022 04:12:10 -0400
X-MC-Unique: mxLcA84bNbiqoNK6qLdL9w-1
Received: by mail-qv1-f69.google.com with SMTP id ke5-20020a056214300500b00461fc78b983so7401807qvb.17
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 01:12:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=53MnhvYtL+/cYihHLxo4GLsLARejRnqIvuUsOxI+lBY=;
        b=s/LP1Vk3FUbID8iR1B+u9jJNPfO8t9lCOJgstzHrGEkBHa9JNCIk8sil9vygpRIfb/
         bVHInEDaKdsJL44U+XSnNRhpEMEE5C58zr/5LgEYRrkcD8YMsX04djy25+WZVWa7gLH8
         1NHGN55/RstwRS6a8sTmY164lK/J60xopcnFSzd2W5e1auHsY8NlNhPoq7YsUls3Fk8F
         4YC9BTH2gOZq51hbCmK3eyvYugPpW2BoDHTuWQyn4oBH1r+S/S/3YK2BvemHs9eJtZSl
         CCQymPsBYLnzGccrenTsV0aXkhdIodksCTQSJuF/RecpPDQhSHA4JPBEkmqfBxAgjzlP
         7Kfw==
X-Gm-Message-State: AOAM530cnmB3kUZ5nSuwxmh3w86ioxbqPAxedtMJiL2TSQi86vSt6bsY
        M5mJrK60TDymB/glqWFLfVde2QpPE/M3xYRU8zjyVM8qLv8xyKxNsL9yDhaV826ey+fU5Ud1kz3
        Ms71gZODZM4X43EIB5Wkbh1tGpKM+
X-Received: by 2002:a05:6214:1cc3:b0:456:56d:f2c5 with SMTP id g3-20020a0562141cc300b00456056df2c5mr16071590qvd.119.1653293530258;
        Mon, 23 May 2022 01:12:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxndmh3Z/5Upq6a5oy0R43tgYXfcGAKp5IHcGn2lvZMLVj0I5W3ABKYUsCufqilG4+hIlR2T+HHxzM4JZ4Bw6E=
X-Received: by 2002:a05:6214:1cc3:b0:456:56d:f2c5 with SMTP id
 g3-20020a0562141cc300b00456056df2c5mr16071553qvd.119.1653293530053; Mon, 23
 May 2022 01:12:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220520172325.980884-1-eperezma@redhat.com> <20220520172325.980884-4-eperezma@redhat.com>
 <20220521083630.GA5298@gmail.com>
In-Reply-To: <20220521083630.GA5298@gmail.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Mon, 23 May 2022 10:11:33 +0200
Message-ID: <CAJaqyWfKXbeT5nUbBvHj4A3Ntz_YwA3OvgDeyq=D6J2cy8dRJw@mail.gmail.com>
Subject: Re: [PATCH 3/4] vhost-vdpa: uAPI to stop the device
To:     =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        Longpeng <longpeng2@huawei.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>, dinang@xilinx.com,
        Eli Cohen <elic@nvidia.com>,
        Laurent Vivier <lvivier@redhat.com>, pabloc@xilinx.com,
        "Dawar, Gautam" <gautam.dawar@amd.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        tanuj.kamde@amd.com, Wu Zongyong <wuzongyong@linux.alibaba.com>,
        martinpo@xilinx.com, Cindy Lu <lulu@redhat.com>,
        ecree.xilinx@gmail.com, Parav Pandit <parav@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
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

On Sat, May 21, 2022 at 10:36 AM Martin Habets <habetsm.xilinx@gmail.com> w=
rote:
>
> On Fri, May 20, 2022 at 07:23:24PM +0200, Eugenio P=C3=A9rez wrote:
> > The ioctl adds support for stop the device from userspace.
> >
> > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > ---
> >  drivers/vhost/vdpa.c       | 18 ++++++++++++++++++
> >  include/uapi/linux/vhost.h |  3 +++
> >  2 files changed, 21 insertions(+)
> >
> > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > index a325bc259afb..da4a8c709bc1 100644
> > --- a/drivers/vhost/vdpa.c
> > +++ b/drivers/vhost/vdpa.c
> > @@ -478,6 +478,21 @@ static long vhost_vdpa_get_vqs_count(struct vhost_=
vdpa *v, u32 __user *argp)
> >       return 0;
> >  }
> >
> > +static long vhost_vdpa_stop(struct vhost_vdpa *v, u32 __user *argp)
> > +{
> > +     struct vdpa_device *vdpa =3D v->vdpa;
> > +     const struct vdpa_config_ops *ops =3D vdpa->config;
> > +     int stop;
> > +
> > +     if (!ops->stop)
> > +             return -EOPNOTSUPP;
> > +
> > +     if (copy_to_user(argp, &stop, sizeof(stop)))
>
> You want to use copy_from_user() here.
>

Hi Martin,

You're right, I'll resend a new version with this fixed. Thanks!

> Martin
>
> > +             return -EFAULT;
> > +
> > +     return ops->stop(vdpa, stop);
> > +}
> > +
> >  static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int =
cmd,
> >                                  void __user *argp)
> >  {
> > @@ -649,6 +664,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *=
filep,
> >       case VHOST_VDPA_GET_VQS_COUNT:
> >               r =3D vhost_vdpa_get_vqs_count(v, argp);
> >               break;
> > +     case VHOST_STOP:
> > +             r =3D vhost_vdpa_stop(v, argp);
> > +             break;
> >       default:
> >               r =3D vhost_dev_ioctl(&v->vdev, cmd, argp);
> >               if (r =3D=3D -ENOIOCTLCMD)
> > diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> > index cab645d4a645..e7526968ab0c 100644
> > --- a/include/uapi/linux/vhost.h
> > +++ b/include/uapi/linux/vhost.h
> > @@ -171,4 +171,7 @@
> >  #define VHOST_VDPA_SET_GROUP_ASID    _IOW(VHOST_VIRTIO, 0x7C, \
> >                                            struct vhost_vring_state)
> >
> > +/* Stop or resume a device so it does not process virtqueue requests a=
nymore */
> > +#define VHOST_STOP                   _IOW(VHOST_VIRTIO, 0x7D, int)
> > +
> >  #endif
> > --
> > 2.27.0
>

