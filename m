Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDA9D7D489C
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 09:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbjJXHfT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 03:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232420AbjJXHfS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 03:35:18 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1120B90
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 00:35:16 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-53df747cfe5so6456941a12.2
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 00:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698132914; x=1698737714; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=32gTUUjXU68PR9X7xQzHlV1yrbdzrrt47OwobaK/im0=;
        b=eDmCyPeThbudlkwLYx6lFDtJmT8mcBdWYF6d3roY4OlYG63JfzSC7r/DGWX3rNK1uw
         42QTiHkgZmr5iGybU+5UZyHzF0Mf/xQ7SRnd0lIWL8ko69f1KJqpC3JW5JjXkuzIJnoA
         q6ni1HqzETDMNH9BZzxYFvBfmV9/Q7h8c/ko8rDYLN4VxIfw1io1JVapeFEmeBzX7a2P
         kJ3Ukd57UpKaHB8t+fbsAvPgT1d9egUQuUruRbb1oAiZ55QkJBcwEuR8ML5X8v23JB7e
         0PWcPxZy8mxc8jSZCYYLEDWmK5TZbRd8dGt8M1sZrNHnub2uXIKg8DXFYhjYli6hlGd4
         S+1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698132914; x=1698737714;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=32gTUUjXU68PR9X7xQzHlV1yrbdzrrt47OwobaK/im0=;
        b=C9AX1Hsn50jDfHVtIDmgSYcG3UyMjWwWW2W854iE24unfjb7Sd6vPPJT75rB/7kRdA
         lJU5IkfITM+pgXPKPS1ggRQeQUfk7KF9nA3ytgzYpA8pro/W+WD/TUwMWPbOSisvwVb4
         Xd7MvQSjA043Xx80mDPnho0tuppvfUUAOyKoKp3kRMSEIeE7p07pWwstvzg802Po6x/2
         fUhiUYkhY0rU2yUNO5zdC0f/fluVdkJAadCKFeV8rOZn4ngUE95WzGP4uUzxnkwLfaiR
         80KqtvNuLNv49hdkA3n8Kimg1K6AqckMg7WLw9BI6eor7/K84ihUYLJCZQgphUTcB7tY
         tpjw==
X-Gm-Message-State: AOJu0YymLcxfu89Vwp75mJWZ42ZGS+qO5PA0FZMPNNNMy9/S5WZO3unF
        FCVgQrwGjF4UCir/7KSQRwTUvBFZNqecoNbZKXE=
X-Google-Smtp-Source: AGHT+IFp/uHv1l5CsH7+HTAoEjLJtzfXtxhv7dKkZ5shtUpJb8zM76imNnUO0v5NgMklFtDN30DwcDyk6Az5xeql/wE=
X-Received: by 2002:a05:6402:5111:b0:540:7e8:dd4f with SMTP id
 m17-20020a056402511100b0054007e8dd4fmr5895340edd.20.1698132914306; Tue, 24
 Oct 2023 00:35:14 -0700 (PDT)
MIME-Version: 1.0
References: <CAKhg4tKSWLood9aFo7r1j-a3sXvf+WraFV_xUcKOMLq9sxrPXA@mail.gmail.com>
 <CACGkMEufrJfM7bw7s76gq_3S5oSgx4w5KjxO_oReMg34bCy5hA@mail.gmail.com>
In-Reply-To: <CACGkMEufrJfM7bw7s76gq_3S5oSgx4w5KjxO_oReMg34bCy5hA@mail.gmail.com>
From:   Liang Chen <liangchen.linux@gmail.com>
Date:   Tue, 24 Oct 2023 15:35:02 +0800
Message-ID: <CAKhg4t+OZBAt8modbysXvdCAEwui=bnV9dcSZoZNZwCf_rcAYw@mail.gmail.com>
Subject: Re: [RFC] vhost: vmap virtio descriptor table kernel/kvm
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 24, 2023 at 12:45=E2=80=AFPM Jason Wang <jasowang@redhat.com> w=
rote:
>
> On Tue, Oct 24, 2023 at 11:17=E2=80=AFAM Liang Chen <liangchen.linux@gmai=
l.com> wrote:
> >
> > The current vhost code uses 'copy_from_user' to copy descriptors from
> > userspace to vhost. We attempted to 'vmap' the descriptor table to
> > reduce the overhead associated with 'copy_from_user' during descriptor
> > access, because it can be accessed quite frequently. This change
> > resulted in a moderate performance improvement (approximately 3%) in
> > our pktgen test, as shown below. Additionally, the latency in the
> > 'vhost_get_vq_desc' function shows a noticeable decrease.
> >
> > current code:
> >                 IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s
> > rxcmp/s   txcmp/s  rxmcst/s   %ifutil
> > Average:        vnet0      0.31 1330807.03      0.02  77976.98
> > 0.00      0.00      0.00      6.39
> > # /usr/share/bcc/tools/funclatency -d 10 vhost_get_vq_desc
> > avg =3D 145 nsecs, total: 1455980341 nsecs, count: 9985224
> >
> > vmap:
> >                 IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s
> > rxcmp/s   txcmp/s  rxmcst/s   %ifutil
> > Average:        vnet0      0.07 1371870.49      0.00  80383.04
> > 0.00      0.00      0.00      6.58
> > # /usr/share/bcc/tools/funclatency -d 10 vhost_get_vq_desc
> > avg =3D 122 nsecs, total: 1286983929 nsecs, count: 10478134
> >
> > We are uncertain if there are any aspects we may have overlooked and
> > would appreciate any advice before we submit an actual patch.
>
> So the idea is to use a shadow page table instead of the userspace one
> to avoid things like spec barriers or SMAP.
>
> I've tried this in the past:
>
> commit 7f466032dc9e5a61217f22ea34b2df932786bbfc (HEAD)
> Author: Jason Wang <jasowang@redhat.com>
> Date:   Fri May 24 04:12:18 2019 -0400
>
>     vhost: access vq metadata through kernel virtual address
>
>     It was noticed that the copy_to/from_user() friends that was used to
>     access virtqueue metdata tends to be very expensive for dataplane
>     implementation like vhost since it involves lots of software checks,
>     speculation barriers, hardware feature toggling (e.g SMAP). The
>     extra cost will be more obvious when transferring small packets since
>     the time spent on metadata accessing become more significant.
> ...
>
> Note that it tries to use a direct map instead of a VMAP as Andrea
> suggests. But it led to several fallouts which were tricky to be
> fixed[1] (like the use of MMU notifiers to do synchronization). So it
> is reverted finally.
>
> I'm not saying it's a dead end. But we need to find a way to solve the
> issues or use something different. I'm happy to offer help.
>
> 1) Avoid using SMAP for vhost kthread, for example using shed
> notifier, I'm not sure this is possible or not
> 2) A new iov iterator that doesn't do SMAP at all, this looks
> dangerous and Al might not like it
> 3) (Re)using HMM
> ...
>
> You may want to see archives for more information. We've had a lot of
> discussions.
>
> Thanks
>
> [1] https://lore.kernel.org/lkml/20190731084655.7024-1-jasowang@redhat.co=
m/
>

Thanks a lot for the help. We will take a deeper look and reach out if
we have any questions or once we've finalized the patch.

Thanks,
Liang

> >
> >
> > Thanks,
> > Liang
> >
>
