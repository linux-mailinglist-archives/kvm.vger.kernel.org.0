Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B501155DBDF
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245490AbiF1GNP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 02:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245518AbiF1GMc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 02:12:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4A7BC2610A
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 23:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656396750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Dx6dQM49vWdX9cmVmNPYk3K9FV6smpCQ8wm7kLXU688=;
        b=VyOyLe4il8ySW43rGIc5JOyxk51K1Ya/No+WUoXoxFXWLHPSn0lu8ePS/iyKEiq2QH+iEj
        1k5bqvpo+6Bw2kgtDsPWtRrkg0eASM8je7jut5bjMPIpOK4LhB5Wumt67m5JI4B91Fxk/n
        QSxzTKYpvJ711t+uCx7p5u+aBVJCTtU=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-221-rkDycQ5rNAWF8oC1XGSC-g-1; Tue, 28 Jun 2022 02:12:26 -0400
X-MC-Unique: rkDycQ5rNAWF8oC1XGSC-g-1
Received: by mail-lf1-f72.google.com with SMTP id h18-20020a056512055200b004810d1b257aso3202697lfl.13
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 23:12:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dx6dQM49vWdX9cmVmNPYk3K9FV6smpCQ8wm7kLXU688=;
        b=TpGRhEeps1RCnZsgpiROuh7tc8rJGGtV3xo955Gn4kiUP1Ph/TXwqKlD2Sj17WOTBg
         x0wPhPaNVbCqauOVkaIkxKN2riX3+xReSG6UTkiWp5N2zOpYDO4dXW3M9ToRcL078otf
         j3Z7qiNKSx9j8uHJ22LHARk2QjBPawsTtoBc1UFb6pHVazy8+PLLjdpKtwF8VNGEjEqD
         15wzKT0HXH9CqW1y8c/orTsxpuvX8ok0/cti60H1VAmTM3lZz/I38nCVUqUQjrwQdm8S
         Tjo0dJPwo9qg3D8LJXvgUJQzReIpO3FPhqFWL2/lGroyfDv9TdvfOeITV9t1TqbW0kmV
         rUlg==
X-Gm-Message-State: AJIora9e5o3xPtc1wfuoHVjgwZPhYWNU+XNg3Yed4Tw7G1Y5hQs6ErB7
        BMeN6GaMCcDjoQHAAu5E7eFASxeNTUqR4RsDC05IfrvQKWHvCNXuuYyCMgHzTHBwzhxSegPsHIc
        eh6xv0G6IcsFsaIYEOslXhVAA7ask
X-Received: by 2002:a05:6512:13a5:b0:47d:c1d9:dea8 with SMTP id p37-20020a05651213a500b0047dc1d9dea8mr10373860lfa.442.1656396744839;
        Mon, 27 Jun 2022 23:12:24 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sXN+QfgdhlGQk/CZZ9irUZ7rpfge9ShgLuLje1BX5ivPuK52DeT/MuedO9nPEXy/Kb7bkkyZVCwlmvRGeNCLg=
X-Received: by 2002:a05:6512:13a5:b0:47d:c1d9:dea8 with SMTP id
 p37-20020a05651213a500b0047dc1d9dea8mr10373832lfa.442.1656396744537; Mon, 27
 Jun 2022 23:12:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220624025817-mutt-send-email-mst@kernel.org>
 <CACGkMEseptD=45j3kQr0yciRxR679Jcig=292H07-RYC2vXmFQ@mail.gmail.com>
 <20220627023841-mutt-send-email-mst@kernel.org> <CACGkMEvy8xF2T_vubKeUEPC2aroO_fbB0Xe8nnxK4OBUgAS+Gw@mail.gmail.com>
 <20220627034733-mutt-send-email-mst@kernel.org> <CACGkMEtpjUBaUML=fEs5hR66rzNTBhBXOmfpzyXV1F-6BqvsGg@mail.gmail.com>
 <20220627074723-mutt-send-email-mst@kernel.org> <CACGkMEv0zdgG6SAaxRwkpObEFX_KRB1ovezNiHX+QXsYhE=qaQ@mail.gmail.com>
 <20220628014309-mutt-send-email-mst@kernel.org> <CACGkMEuzrmVsM5Xa3N_9n0-XOqyMAz65AON8oxkgmjnXb_bAFg@mail.gmail.com>
 <20220628020832-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220628020832-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 28 Jun 2022 14:12:13 +0800
Message-ID: <CACGkMEs4Ps6Jnbzrx+4Zju7SUfgu0aTACrLyqpqBcxsZP7YOkQ@mail.gmail.com>
Subject: Re: [PATCH v10 25/41] virtio_pci: struct virtio_pci_common_cfg add queue_notify_data
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev <netdev@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm <kvm@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>,
        kangjie.xu@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 28, 2022 at 2:10 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Jun 28, 2022 at 02:07:28PM +0800, Jason Wang wrote:
> > On Tue, Jun 28, 2022 at 1:46 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Tue, Jun 28, 2022 at 11:50:37AM +0800, Jason Wang wrote:
> > > > On Mon, Jun 27, 2022 at 7:53 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > >
> > > > > On Mon, Jun 27, 2022 at 04:14:20PM +0800, Jason Wang wrote:
> > > > > > On Mon, Jun 27, 2022 at 3:58 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > >
> > > > > > > On Mon, Jun 27, 2022 at 03:45:30PM +0800, Jason Wang wrote:
> > > > > > > > On Mon, Jun 27, 2022 at 2:39 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > > >
> > > > > > > > > On Mon, Jun 27, 2022 at 10:30:42AM +0800, Jason Wang wrote:
> > > > > > > > > > On Fri, Jun 24, 2022 at 2:59 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > > > > >
> > > > > > > > > > > On Fri, Jun 24, 2022 at 10:56:05AM +0800, Xuan Zhuo wrote:
> > > > > > > > > > > > Add queue_notify_data in struct virtio_pci_common_cfg, which comes from
> > > > > > > > > > > > here https://github.com/oasis-tcs/virtio-spec/issues/89
> > > > > > > > > > > >
> > > > > > > > > > > > For not breaks uABI, add a new struct virtio_pci_common_cfg_notify.
> > > > > > > > > > >
> > > > > > > > > > > What exactly is meant by not breaking uABI?
> > > > > > > > > > > Users are supposed to be prepared for struct size to change ... no?
> > > > > > > > > >
> > > > > > > > > > Not sure, any doc for this?
> > > > > > > > > >
> > > > > > > > > > Thanks
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > Well we have this:
> > > > > > > > >
> > > > > > > > >         The drivers SHOULD only map part of configuration structure
> > > > > > > > >         large enough for device operation.  The drivers MUST handle
> > > > > > > > >         an unexpectedly large \field{length}, but MAY check that \field{length}
> > > > > > > > >         is large enough for device operation.
> > > > > > > >
> > > > > > > > Yes, but that's the device/driver interface. What's done here is the
> > > > > > > > userspace/kernel.
> > > > > > > >
> > > > > > > > Userspace may break if it uses e.g sizeof(struct virtio_pci_common_cfg)?
> > > > > > > >
> > > > > > > > Thanks
> > > > > > >
> > > > > > > Hmm I guess there's risk... but then how are we going to maintain this
> > > > > > > going forward?  Add a new struct on any change?
> > > > > >
> > > > > > This is the way we have used it for the past 5 or more years. I don't
> > > > > > see why this must be handled in the vq reset feature.
> > > > > >
> > > > > > >Can we at least
> > > > > > > prevent this going forward somehow?
> > > > > >
> > > > > > Like have some padding?
> > > > > >
> > > > > > Thanks
> > > > >
> > > > > Maybe - this is what QEMU does ...
> > > >
> > > > Do you want this to be addressed in this series (it's already very huge anyhow)?
> > > >
> > > > Thanks
> > >
> > > Let's come up with a solution at least. QEMU does not seem to need the struct.
> >
> > If we want to implement it in Qemu we need that:
> >
> > https://github.com/fengidri/qemu/commit/39b79335cb55144d11a3b01f93d46cc73342c6bb
> >
> > > Let's just put
> > > it in virtio_pci_modern.h for now then?
> >
> > Does this mean userspace needs to define the struct by their own
> > instead of depending on the uapi in the future?
> >
> > Thanks
>
>
> $ git grep 'struct virtio_pci_common_cfg'
> include/standard-headers/linux/virtio_pci.h:struct virtio_pci_common_cfg {
> tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg,
> tests/qtest/libqos/virtio-pci-modern.c:                       offsetof(struct virtio_pci_common_cfg, device_feature));
> tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg,
> tests/qtest/libqos/virtio-pci-modern.c:                       offsetof(struct virtio_pci_common_cfg, device_feature));
> tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg,
> tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg,
> tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg,
> tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg,
> tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg,
> tests/qtest/libqos/virtio-pci-modern.c:                       offsetof(struct virtio_pci_common_cfg, guest_feature));
> tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg,
> tests/qtest/libqos/virtio-pci-modern.c:                       offsetof(struct virtio_pci_common_cfg, guest_feature));
> tests/qtest/libqos/virtio-pci-modern.c:                         offsetof(struct virtio_pci_common_cfg,
> tests/qtest/libqos/virtio-pci-modern.c:                          offsetof(struct virtio_pci_common_cfg,
> tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg, queue_select),
> tests/qtest/libqos/virtio-pci-modern.c:                         offsetof(struct virtio_pci_common_cfg, queue_size));
> tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg, queue_desc_lo),
> tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg, queue_desc_hi),
> tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg, queue_avail_lo),
> tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg, queue_avail_hi),
> tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg, queue_used_lo),
> tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg, queue_used_hi),
> tests/qtest/libqos/virtio-pci-modern.c:                               offsetof(struct virtio_pci_common_cfg,
> tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg, queue_enable), 1);
> tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg, msix_config), entry);
> tests/qtest/libqos/virtio-pci-modern.c:                           offsetof(struct virtio_pci_common_cfg,
> tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg, queue_msix_vector),
> tests/qtest/libqos/virtio-pci-modern.c:                           offsetof(struct virtio_pci_common_cfg,
>
>
> The only user of the struct is libqos and it just wants
> the offsets so can use macros just as well.

Yes, so this way should be fine.

Thanks

>
>
> > >
> > > > >
> > > > > > >
> > > > > > >
> > > > > > > > >
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > > Since I want to add queue_reset after queue_notify_data, I submitted
> > > > > > > > > > > > this patch first.
> > > > > > > > > > > >
> > > > > > > > > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > > > > > > > > Acked-by: Jason Wang <jasowang@redhat.com>
> > > > > > > > > > > > ---
> > > > > > > > > > > >  include/uapi/linux/virtio_pci.h | 7 +++++++
> > > > > > > > > > > >  1 file changed, 7 insertions(+)
> > > > > > > > > > > >
> > > > > > > > > > > > diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
> > > > > > > > > > > > index 3a86f36d7e3d..22bec9bd0dfc 100644
> > > > > > > > > > > > --- a/include/uapi/linux/virtio_pci.h
> > > > > > > > > > > > +++ b/include/uapi/linux/virtio_pci.h
> > > > > > > > > > > > @@ -166,6 +166,13 @@ struct virtio_pci_common_cfg {
> > > > > > > > > > > >       __le32 queue_used_hi;           /* read-write */
> > > > > > > > > > > >  };
> > > > > > > > > > > >
> > > > > > > > > > > > +struct virtio_pci_common_cfg_notify {
> > > > > > > > > > > > +     struct virtio_pci_common_cfg cfg;
> > > > > > > > > > > > +
> > > > > > > > > > > > +     __le16 queue_notify_data;       /* read-write */
> > > > > > > > > > > > +     __le16 padding;
> > > > > > > > > > > > +};
> > > > > > > > > > > > +
> > > > > > > > > > > >  /* Fields in VIRTIO_PCI_CAP_PCI_CFG: */
> > > > > > > > > > > >  struct virtio_pci_cfg_cap {
> > > > > > > > > > > >       struct virtio_pci_cap cap;
> > > > > > > > > > > > --
> > > > > > > > > > > > 2.31.0
> > > > > > > > > > >
> > > > > > > > >
> > > > > > >
> > > > >
> > >
>

