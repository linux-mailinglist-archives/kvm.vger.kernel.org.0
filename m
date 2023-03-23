Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCBAB6C69AD
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 14:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbjCWNif (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 09:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjCWNid (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 09:38:33 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B92272C
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 06:38:31 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id x3so86633488edb.10
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 06:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679578710;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qWBcKLRnvFLHZ95dKYMRwjcB81tNMw0nKAjX/UoFdyM=;
        b=jjWsCwUjJU/wngnLjTstZYLUOK/6F3ez5gZ/XBZ8TmNBcn5i46pDMZV6Y5V5avM9bf
         jH9z6QsxRNrw3YbZyKgnKZhtKqtIbaLllQZU+Z5FG+VpFjBTUlfRirswGw+lHmagf2zB
         8iydCsDA+2xiDyKCJiCr83fhzyA9xB2iCeMIsIKQVqc2tcuzBT97lm3vT/ar6Afdie+O
         PwoYLPonm2eFFO49H/jUxcT13/0nTxk/W+iKMbsyBtjhxSvwUybCyHYwKyfxXQoUbt2m
         oBPoHTpljPoLQoFY3NEsQU4wlzSpn1nstQmi9f/ei3Ajam8WbbZ/aTWw/k4ex96P+etz
         iHQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679578710;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qWBcKLRnvFLHZ95dKYMRwjcB81tNMw0nKAjX/UoFdyM=;
        b=oxk4IpcTyrGwFEVXJHcFU8wcC4omoEsXgGybjxD8XS5LKRKCtgEx+VA5Upj2rLckHM
         HK6aa6xnevRUHvdEl3fefd5lE8hZXM055pMydB6BKcOISu5l5gt816I6yC3+g5XTfZ7Z
         PBrgG8PB1ekjl66UkyA5BAYBNbgYbMdK1m8LAX86ceoTAnao0Aop8L9kt2OevU55gXTo
         mNBmdi+TvH//IX9+TxixW8bYZj2gIzOzLpTIVPhLhE8klUDq8QWRlEsRyCGLL/55/x5U
         sRufy9h4YRh8km0Awgy05YNEMRSgRILXruKO4R1lqF/fYjbfJajfwxo9iR2zHekejyP3
         AsrQ==
X-Gm-Message-State: AO0yUKUpIOtQzDn4esnHBm0pzzYAQwHv8t8VqG0+9htSv+ajoCGPKd1H
        KgMpW9qzUSwwiDmiCBgOxye42MBfvsKCGuXKeVBCamp1mHk3xisBHhduBQ==
X-Google-Smtp-Source: AK7set/z07jNc+URMlpH1Ic9X2Oxsw2o5ITLjBd8+X7nspYUypDuYBhdJxGtaGF76bhjSGP/IC0eNN8sd2fWcDTY5PI=
X-Received: by 2002:a17:906:668c:b0:8b1:3c31:efe6 with SMTP id
 z12-20020a170906668c00b008b13c31efe6mr3364110ejo.3.1679578709798; Thu, 23 Mar
 2023 06:38:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230323052828.6545-1-faithilikerun@gmail.com> <3983f8bc-5be2-bb3c-a5cd-647550f577a0@bjorling.me>
In-Reply-To: <3983f8bc-5be2-bb3c-a5cd-647550f577a0@bjorling.me>
From:   Sam Li <faithilikerun@gmail.com>
Date:   Thu, 23 Mar 2023 21:38:03 +0800
Message-ID: <CAAAx-8Kq4JiA3rgjNuueBxWPiyKtQXy8-YCv04QOgbj=0DTXaA@mail.gmail.com>
Subject: Re: [PATCH v8 0/4] Add zoned storage emulation to virtio-blk driver
To:     =?UTF-8?Q?Matias_Bj=C3=B8rling?= <m@bjorling.me>
Cc:     qemu-devel@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        qemu-block@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>,
        damien.lemoal@opensource.wdc.com, kvm@vger.kernel.org,
        hare@suse.de, Paolo Bonzini <pbonzini@redhat.com>,
        dmitry.fomichev@wdc.com, Hanna Reitz <hreitz@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Matias Bj=C3=B8rling <m@bjorling.me> =E4=BA=8E2023=E5=B9=B43=E6=9C=8823=E6=
=97=A5=E5=91=A8=E5=9B=9B 21:26=E5=86=99=E9=81=93=EF=BC=9A
>
> On 23/03/2023 06.28, Sam Li wrote:
> > This patch adds zoned storage emulation to the virtio-blk driver.
> >
> > The patch implements the virtio-blk ZBD support standardization that is
> > recently accepted by virtio-spec. The link to related commit is at
> >
> > https://github.com/oasis-tcs/virtio-spec/commit/b4e8efa0fa6c8d844328090=
ad15db65af8d7d981
> >
> > The Linux zoned device code that implemented by Dmitry Fomichev has bee=
n
> > released at the latest Linux version v6.3-rc1.
> >
> > Aside: adding zoned=3Don alike options to virtio-blk device will be
> > considered in following-up plan.
> >
> > v7:
> > - address Stefan's review comments
> >    * rm aio_context_acquire/release in handle_req
> >    * rename function return type
> >    * rename BLOCK_ACCT_APPEND to BLOCK_ACCT_ZONE_APPEND for clarity
> >
> > v6:
> > - update headers to v6.3-rc1
> >
> > v5:
> > - address Stefan's review comments
> >    * restore the way writing zone append result to buffer
> >    * fix error checking case and other errands
> >
> > v4:
> > - change the way writing zone append request result to buffer
> > - change zone state, zone type value of virtio_blk_zone_descriptor
> > - add trace events for new zone APIs
> >
> > v3:
> > - use qemuio_from_buffer to write status bit [Stefan]
> > - avoid using req->elem directly [Stefan]
> > - fix error checkings and memory leak [Stefan]
> >
> > v2:
> > - change units of emulated zone op coresponding to block layer APIs
> > - modify error checking cases [Stefan, Damien]
> >
> > v1:
> > - add zoned storage emulation
> >
> > Sam Li (4):
> >    include: update virtio_blk headers to v6.3-rc1
> >    virtio-blk: add zoned storage emulation for zoned devices
> >    block: add accounting for zone append operation
> >    virtio-blk: add some trace events for zoned emulation
> >
> >   block/qapi-sysemu.c                          |  11 +
> >   block/qapi.c                                 |  18 +
> >   hw/block/trace-events                        |   7 +
> >   hw/block/virtio-blk-common.c                 |   2 +
> >   hw/block/virtio-blk.c                        | 405 ++++++++++++++++++=
+
> >   include/block/accounting.h                   |   1 +
> >   include/standard-headers/drm/drm_fourcc.h    |  12 +
> >   include/standard-headers/linux/ethtool.h     |  48 ++-
> >   include/standard-headers/linux/fuse.h        |  45 ++-
> >   include/standard-headers/linux/pci_regs.h    |   1 +
> >   include/standard-headers/linux/vhost_types.h |   2 +
> >   include/standard-headers/linux/virtio_blk.h  | 105 +++++
> >   linux-headers/asm-arm64/kvm.h                |   1 +
> >   linux-headers/asm-x86/kvm.h                  |  34 +-
> >   linux-headers/linux/kvm.h                    |   9 +
> >   linux-headers/linux/vfio.h                   |  15 +-
> >   linux-headers/linux/vhost.h                  |   8 +
> >   qapi/block-core.json                         |  62 ++-
> >   qapi/block.json                              |   4 +
> >   19 files changed, 769 insertions(+), 21 deletions(-)
> >
>
>
> Hi Sam,
>
> I applied your patches and can report that they work with both SMR HDDs
> and ZNS SSDs. Very nice work!
>
> Regarding the documentation (docs/system/qemu-block-drivers.rst.inc). Is
> it possible to expose the host's zoned block device through something
> else than virtio-blk? If not, I wouldn't mind seeing the documentation
> updated to show a case when using the virtio-blk driver.
>
> For example (this also includes the device part):
>
> -device virtio-blk-pci,drive=3Ddrive0,id=3Dvirtblk0 \
> -blockdev
> host_device,node-name=3Ddrive0,filename=3D/dev/nullb0,cache.direct=3Don``
>
> It might also be nice to describe the shorthand for those that likes to
> pass in the parameters using only the -drive parameter.
>
>   -drive driver=3Dhost_device,file=3D/dev/nullb0,if=3Dvirtio,cache.direct=
=3Don

Hi Matias,

I'm glad it works. Thanks for your feedback!

For the question, this patch is exposing the zoned interface through
virtio-blk only. It's a good suggestion to put a use case inside
documentation. I will add it in the subsequent patch.

Thanks,
Sam
