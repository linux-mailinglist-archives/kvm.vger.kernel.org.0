Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A27BA5BF808
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 09:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiIUHpH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 03:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbiIUHpB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 03:45:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7760256B98
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 00:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663746296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9ubLtsAgcpDm3nvMpf+F5CRd6Xb0P+Wgpu8FfKvJ+Z0=;
        b=L41odCb2o2XgCzZCpWpW+5JRtJLH9Dh7DhO1tlhhAQsziyYtGZMnKKuslKQ7MFzsdfIc9Z
        YIqdRmIGJepEDeQHxr4g0NLANjoKao790ytyz3IK5OxoAm/ggFZ8M+MSMU7aqRKgD3Rtn7
        CSVkgsf/uqUFdljre2+2UGH9JIBU/Ac=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-110-FjpPvUiUO4qZo_9NJiEQSw-1; Wed, 21 Sep 2022 03:44:55 -0400
X-MC-Unique: FjpPvUiUO4qZo_9NJiEQSw-1
Received: by mail-ot1-f71.google.com with SMTP id a11-20020a9d6e8b000000b00656442abf2eso2643933otr.21
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 00:44:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=9ubLtsAgcpDm3nvMpf+F5CRd6Xb0P+Wgpu8FfKvJ+Z0=;
        b=kxl3hnCqkGPC0PihA1ECcVHqR92Hl8mO3LyHNURcvuH51XaLZsMISlS++QXfS0BLEp
         Xhl82ylKABWexwSt8oMwhvtryr4HZBzA310isnWlczER2Q1NH6jlUtqn/AsY0A9wDHuQ
         Sn/JC3Hp95lilVHkxE2pYGrXh7ITlGBcslR85+TSJotgJBzaHOIFQHqxDoT+CC1NaV6m
         NlfHF2svQ8J8RGieG62ln8kL8GEjZ9OkQMfu57lO4y9ANxOpt9+nz3jcYS7rpvumx6bM
         g1ADVKyKoWR++gSPznV4v1jLu900bhWJq74jVSnfzWdsh3W6vdU+3DYEtqcp22htbDVe
         VcSg==
X-Gm-Message-State: ACrzQf20HuPTXD0ikF7ShS1l4uBRoheLXlIkK+zQkrnwkv0QLVDA0XPx
        yzHwb5h/ECHNgJ8lpTR7ZofAYNWPnF9gaax6l2T0k2jHp/6C2XJDQ5pzKf4U+usfNy2B77NZANs
        pVOYuKESLd3KdPGP8oeaetAeJyLBX
X-Received: by 2002:a05:6870:73cd:b0:12a:dff3:790a with SMTP id a13-20020a05687073cd00b0012adff3790amr4112346oan.35.1663746294187;
        Wed, 21 Sep 2022 00:44:54 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6wkv3SUBRdXvKVaNbuIgmOgYkeMBTnxhWlJtmZOEou/q4L0gaF2SAW7Z0YIVrq9HwXTbuOFZXv4kvlgStXvGI=
X-Received: by 2002:a05:6870:73cd:b0:12a:dff3:790a with SMTP id
 a13-20020a05687073cd00b0012adff3790amr4112337oan.35.1663746293933; Wed, 21
 Sep 2022 00:44:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220909085712.46006-1-lingshan.zhu@intel.com>
 <20220909085712.46006-2-lingshan.zhu@intel.com> <CACGkMEsq+weeO7i8KtNNAPhXGwN=cTwWt3RWfTtML-Xwj3K5Qg@mail.gmail.com>
 <e69b65e7-516f-55bd-cb99-863d7accbd32@intel.com> <CACGkMEv0++vmfzzmX47NhsaY5JTvbO2Ro7Taf8C0dxV6OVXTKw@mail.gmail.com>
 <27b04293-2225-c78d-f6e3-ffe8a7472ea1@intel.com>
In-Reply-To: <27b04293-2225-c78d-f6e3-ffe8a7472ea1@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 21 Sep 2022 15:44:42 +0800
Message-ID: <CACGkMEvf0sQyFTowg9DtVS3QbAHidv_cOBCk5hUaaKNxwods8Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] vDPA: allow userspace to query features of a vDPA device
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022 at 2:00 PM Zhu, Lingshan <lingshan.zhu@intel.com> wrote:
>
>
>
> On 9/21/2022 10:17 AM, Jason Wang wrote:
> > On Tue, Sep 20, 2022 at 5:58 PM Zhu, Lingshan <lingshan.zhu@intel.com> wrote:
> >>
> >>
> >> On 9/20/2022 10:02 AM, Jason Wang wrote:
> >>> On Fri, Sep 9, 2022 at 5:05 PM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
> >>>> This commit adds a new vDPA netlink attribution
> >>>> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES. Userspace can query
> >>>> features of vDPA devices through this new attr.
> >>>>
> >>>> This commit invokes vdpa_config_ops.get_config() than
> >>>> vdpa_get_config_unlocked() to read the device config
> >>>> spcae, so no raeces in vdpa_set_features_unlocked()
> >>>>
> >>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> >>> It's better to share the userspace code as well.
> >> OK, will share it in V2.
> >>>> ---
> >>>>    drivers/vdpa/vdpa.c       | 19 ++++++++++++++-----
> >>>>    include/uapi/linux/vdpa.h |  4 ++++
> >>>>    2 files changed, 18 insertions(+), 5 deletions(-)
> >>>>
> >>>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> >>>> index c06c02704461..798a02c7aa94 100644
> >>>> --- a/drivers/vdpa/vdpa.c
> >>>> +++ b/drivers/vdpa/vdpa.c
> >>>> @@ -491,6 +491,8 @@ static int vdpa_mgmtdev_fill(const struct vdpa_mgmt_dev *mdev, struct sk_buff *m
> >>>>                   err = -EMSGSIZE;
> >>>>                   goto msg_err;
> >>>>           }
> >>>> +
> >>>> +       /* report features of a vDPA management device through VDPA_ATTR_DEV_SUPPORTED_FEATURES */
> >>> The code explains itself, there's no need for the comment.
> >> these comments are required in other discussions
> > I think it's more than sufficient to clarify the semantic where it is defined.
> OK, then only comments in the header file
> >
> >>>>           if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_SUPPORTED_FEATURES,
> >>>>                                 mdev->supported_features, VDPA_ATTR_PAD)) {
> >>>>                   err = -EMSGSIZE;
> >>>> @@ -815,10 +817,10 @@ static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
> >>>>    static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *msg)
> >>>>    {
> >>>>           struct virtio_net_config config = {};
> >>>> -       u64 features;
> >>>> +       u64 features_device, features_driver;
> >>>>           u16 val_u16;
> >>>>
> >>>> -       vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
> >>>> +       vdev->config->get_config(vdev, 0, &config, sizeof(config));
> >>>>
> >>>>           if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, sizeof(config.mac),
> >>>>                       config.mac))
> >>>> @@ -832,12 +834,19 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
> >>>>           if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
> >>>>                   return -EMSGSIZE;
> >>>>
> >>>> -       features = vdev->config->get_driver_features(vdev);
> >>>> -       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
> >>>> +       features_driver = vdev->config->get_driver_features(vdev);
> >>>> +       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
> >>>> +                             VDPA_ATTR_PAD))
> >>>> +               return -EMSGSIZE;
> >>>> +
> >>>> +       features_device = vdev->config->get_device_features(vdev);
> >>>> +
> >>>> +       /* report features of a vDPA device through VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES */
> >>>> +       if (nla_put_u64_64bit(msg, VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES, features_device,
> >>>>                                 VDPA_ATTR_PAD))
> >>>>                   return -EMSGSIZE;
> >>>>
> >>>> -       return vdpa_dev_net_mq_config_fill(vdev, msg, features, &config);
> >>>> +       return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver, &config);
> >>>>    }
> >>>>
> >>>>    static int
> >>>> diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h
> >>>> index 25c55cab3d7c..97531b52dcbe 100644
> >>>> --- a/include/uapi/linux/vdpa.h
> >>>> +++ b/include/uapi/linux/vdpa.h
> >>>> @@ -46,12 +46,16 @@ enum vdpa_attr {
> >>>>
> >>>>           VDPA_ATTR_DEV_NEGOTIATED_FEATURES,      /* u64 */
> >>>>           VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,          /* u32 */
> >>>> +       /* features of a vDPA management device */
> >>>>           VDPA_ATTR_DEV_SUPPORTED_FEATURES,       /* u64 */
> >>>>
> >>>>           VDPA_ATTR_DEV_QUEUE_INDEX,              /* u32 */
> >>>>           VDPA_ATTR_DEV_VENDOR_ATTR_NAME,         /* string */
> >>>>           VDPA_ATTR_DEV_VENDOR_ATTR_VALUE,        /* u64 */
> >>>>
> >>>> +       /* features of a vDPA device, e.g., /dev/vhost-vdpa0 */
> >>>> +       VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES,  /* u64 */
> >>> What's the difference between this and VDPA_ATTR_DEV_SUPPORTED_FEATURES?
> >> This is to report a vDPA device features, and
> >> VDPA_ATTR_DEV_SUPPORTED_FEATURES
> >> is used for reporting the management device features, we have a long
> >> discussion
> >> on this before.
> > Yes, but the comment is not clear in many ways:
> >
> > " features of a vDPA management device" sounds like features that is
> > out of the scope of the virtio.
> I think the term "vDPA device" implies that it is a virtio device.
> So how about: "virtio features of a vDPA management device"

Not a native speaker, but how about "virtio features that are
supported by the vDPA management device?"

Thanks

> >
> > And
> >
> > "/dev/vhost-vdpa0" is not a vDPA device but a vhost-vDPA device.
> will remove this example here.
>
> Thanks
> >
> > Thanks
> >
> >>> Thanks
> >>>
> >>>> +
> >>>>           /* new attributes must be added above here */
> >>>>           VDPA_ATTR_MAX,
> >>>>    };
> >>>> --
> >>>> 2.31.1
> >>>>
>

