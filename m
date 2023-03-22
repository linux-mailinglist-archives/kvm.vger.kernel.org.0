Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA8186C5253
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 18:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjCVRVu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 13:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjCVRVs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 13:21:48 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D3A66D0B
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 10:21:26 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id k37so11410282lfv.0
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 10:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112; t=1679505683;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZAMwytLDDPXOJZO7xVxuXg0wtjoShJg+clkvBywaXAo=;
        b=NhEzhajgiO0scbd61FI+YDLNe/DDnEOiVT7Dn5D2fjex5xhRtPRBlBY+JxrearBLuR
         yJ9WEWNww9OUPDpR/YugZQxUS1UBnqNP0yFExwUMGxUJfTrT5VYwaRDx/dh3CR7ZQNA2
         vx2lB9ZbwxHli0lFXOQMAyw0cjcA/Xd+hLVE3EEINvbWDbasZXcbqnsOBWETKPt3zh/w
         Hru80PEpNo5REJZ6HZnYvjhLcRbN8KcB13CqYlSzFrwKwd8vJ6KCyOZ6erFQiOPX9syh
         mxJbXKk7u7WFt6XLNTRW3nNNA1AXT4BIzQLCVemnqXLgNO0IDfFvHQCKHA8HXAFU44bQ
         X/AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679505683;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZAMwytLDDPXOJZO7xVxuXg0wtjoShJg+clkvBywaXAo=;
        b=2mrp8alClmcO0B7TdC6ASc9/Nr14aRG6Jb4jGUInIU26DXjcqdHZpyRi9mP1x/bvHT
         r/ONOEMRsK0feQDzJjLxzbOT+wOg+qROQwgs4mrRQwuFnXbqjXAKKe58vcMDpiYuu02A
         Jq256DlaDYxCJWaoX5pLsTyxfK/Pf5LixvwvXdwir+8WdSxlroveZu8C4rUstxnK3PlL
         DHcvpBOSGufJN/hSnpzsxLJCgDL3gHNCXRKAbiHEbnB29cBQpo52IcsH6qKoK4ZZmhHl
         RZc8bWiFdky2xXLclMfOF5v4I1Sne7g/vnL3b1GyKH0Ln1jlgDZe/Ay8S3c96orlwWet
         qnsw==
X-Gm-Message-State: AO0yUKWqTPISs+UTTYEXNOrIl130cYJsGbnMQo2SPM2UIXOjPrtNAmQz
        amEGAXJzNk8iMr0DNReq3HQDFr+VP3elxM7SfN3dCw==
X-Google-Smtp-Source: AK7set9MuRTtqaHAxup5npSc4ZVmoBivLmO5CzIRbhpGcr+n85AcT1Z7IBjQDmgArMu1eeNf2AWjeNPVP6I/j8eTD4w=
X-Received: by 2002:ac2:5989:0:b0:4dd:a025:d8c with SMTP id
 w9-20020ac25989000000b004dda0250d8cmr2195562lfn.5.1679505682982; Wed, 22 Mar
 2023 10:21:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230322141031.2211141-1-viktor@daynix.com> <20230322123121-mutt-send-email-mst@kernel.org>
 <87mt44hh5f.fsf@redhat.com>
In-Reply-To: <87mt44hh5f.fsf@redhat.com>
From:   Viktor Prutyanov <viktor@daynix.com>
Date:   Wed, 22 Mar 2023 20:21:12 +0300
Message-ID: <CAPv0NP79iv=s-tdTWwb_3cWbucJSH7LTDYo0VxjdnWvpjguK3Q@mail.gmail.com>
Subject: Re: [PATCH v4] virtio: add VIRTIO_F_NOTIFICATION_DATA feature support
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, jasowang@redhat.com,
        pasic@linux.ibm.com, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, yan@daynix.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 22, 2023 at 7:42=E2=80=AFPM Cornelia Huck <cohuck@redhat.com> w=
rote:
>
> On Wed, Mar 22 2023, "Michael S. Tsirkin" <mst@redhat.com> wrote:
>
> > On Wed, Mar 22, 2023 at 05:10:31PM +0300, Viktor Prutyanov wrote:
> >> According to VirtIO spec v1.2, VIRTIO_F_NOTIFICATION_DATA feature
> >> indicates that the driver passes extra data along with the queue
> >> notifications.
> >>
> >> In a split queue case, the extra data is 16-bit available index. In a
> >> packed queue case, the extra data is 1-bit wrap counter and 15-bit
> >> available index.
> >>
> >> Add support for this feature for MMIO, channel I/O and modern PCI
> >> transports.
> >>
> >> Signed-off-by: Viktor Prutyanov <viktor@daynix.com>
> >> ---
> >>  v4: remove VP_NOTIFY macro and legacy PCI support, add
> >>     virtio_ccw_kvm_notify_with_data to virtio_ccw
> >>  v3: support feature in virtio_ccw, remove VM_NOTIFY, use avail_idx_sh=
adow,
> >>     remove byte swap, rename to vring_notification_data
> >>  v2: reject the feature in virtio_ccw, replace __le32 with u32
> >>
> >>  Tested with disabled VIRTIO_F_NOTIFICATION_DATA on qemu-system-s390x
> >>  (virtio-blk-ccw), qemu-system-riscv64 (virtio-blk-device,
> >>  virtio-rng-device), qemu-system-x86_64 (virtio-blk-pci, virtio-net-pc=
i)
> >>  to make sure nothing is broken.
> >>  Tested with enabled VIRTIO_F_NOTIFICATION_DATA on 64-bit RISC-V Linux
> >>  and my hardware implementation of virtio-rng.
> >
> > what did you test? virtio pci? mmio? guessing not ccw...
> >
> > Cornelia could you hack up something to quickly test ccw?
>
> Hm, I'm not entirely sure how notification data is supposed to be used
> in real life -- Viktor, what is your virtio-rng implementation doing;
> can this be hacked into all transports?

In hardware implementation of split VirtIO queue, the notification data fea=
ture
saves time on a memory request to avail_idx from the device side. I can
definitely say about MMIO, but most likely it is also useful for PCI.
It is also written here that this feature was added for efficiency:
https://www.mail-archive.com/virtio-dev@lists.oasis-open.org/msg02728.html
Also DPDK has support for this feature in VirtIO PCI:
https://github.com/DPDK/dpdk/commit/7e72f3ec1a8abefd9321a61e484846e16177f5b=
1

>
> (Also, if the other ccw folks have something handy, please speak up :)
>
