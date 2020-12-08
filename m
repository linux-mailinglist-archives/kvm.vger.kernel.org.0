Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB292D24EC
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 08:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgLHHuF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 02:50:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbgLHHuE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 02:50:04 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C1EC0613D6
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 23:49:24 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id g20so23329484ejb.1
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 23:49:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4rL1+j26gkB7erofiOGo8PnZet2HWoJP4KemX2vffbo=;
        b=EDZMPhB73I4Mii/KMuvj6gb1rjF6rQhkVObEQc/NoDsHeQZTSxwA2e/GP7Pnvb3I+A
         si3AFq87uNTZi5nfPLxcC5rpMAajc3QRFs5InP8m5fUEso0JIWK8DDjes8rRetBU2CWe
         LB1adPwqtLY5XkmAnu+Zq+TK4HNLClKKtDUiPbwrB2SJnih9h+h0y1kDdis7Y0YiJBGC
         XevX7TfA0Smdinf8Dgxp08b/QEYj/wbTh+Ug3CZSOoNDBsc++XkF56aEDLqr4zpVQZYG
         O+YI9vFRSbhaqQ3YOoh7Dkvb/YUlARxRcbn3Rv+50G2rKgxOxrePJFkOiE5MPzTpIuRb
         idRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4rL1+j26gkB7erofiOGo8PnZet2HWoJP4KemX2vffbo=;
        b=WAKgZ6fjFad6DmPt+PTVH6hjDjtAFUjuMBTSeTKMUL2CBGULGoKZCi83AiZveApPxv
         yKUjBNjw+bsiLml/1YVIlCe2Nz3FV2LP0vO3lkIuFOTelV64QVaCUCFOFJ2aG0IPgIFn
         8VZvHt/1KyFqQfN+YyxnTBqPRbYhfPP16VUUUqFSLiuuk8MMqYJHAbaGxvym2HHNo4WW
         QBXzoOE+AfS4bGswttNUZaw0LQuIWijIBysuhlpFTfPXv8mjqGGR8dr4D1/N2wrJRMbH
         gAB9B+aAjcR85NfAJITsK9e7099PQAod+37FUBCjhZONadTN0sH4Id/uwEtgpwLrbeRr
         ZLxg==
X-Gm-Message-State: AOAM530p4YaI//enXeyv82455WqHiyIcQMc738fumvhNlW8LvIU0EExI
        lADconvA3uXg8o20j84lyCM=
X-Google-Smtp-Source: ABdhPJxV3CSSLGGO1bLrsbPIe+eLOQhH8ex4ooVemMOpVQnhueMjPvGB0QMQd8PYfPB4UtiMSuYLTw==
X-Received: by 2002:a17:906:144e:: with SMTP id q14mr11118182ejc.150.1607413763062;
        Mon, 07 Dec 2020 23:49:23 -0800 (PST)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id i2sm16262086edk.93.2020.12.07.23.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 23:49:21 -0800 (PST)
Date:   Tue, 8 Dec 2020 07:49:20 +0000
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Cc:     qemu-devel@nongnu.org, Lars Ganrot <lars.ganrot@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Salil Mehta <mehta.salil.lnk@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Liran Alon <liralon@gmail.com>,
        Rob Miller <rob.miller@broadcom.com>,
        Max Gurtovoy <maxgu14@gmail.com>,
        Alex Barba <alex.barba@broadcom.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jim Harford <jim.harford@broadcom.com>,
        Jason Wang <jasowang@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Christophe Fontaine <cfontain@redhat.com>,
        vm <vmireyno@marvell.com>, Daniel Daly <dandaly0@gmail.com>,
        Michael Lilja <ml@napatech.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Nitin Shrivastav <nitin.shrivastav@broadcom.com>,
        Lee Ballard <ballle98@gmail.com>,
        Dmytro Kazantsev <dmytro.kazantsev@gmail.com>,
        Juan Quintela <quintela@redhat.com>, kvm@vger.kernel.org,
        Howard Cai <howard.cai@gmail.com>,
        Xiao W Wang <xiao.w.wang@intel.com>,
        Sean Mooney <smooney@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Eli Cohen <eli@mellanox.com>, Siwei Liu <loseweigh@gmail.com>,
        Stephen Finucane <stephenfin@redhat.com>
Subject: Re: [RFC PATCH 10/27] vhost: Allocate shadow vring
Message-ID: <20201208074920.GQ203660@stefanha-x1.localdomain>
References: <20201120185105.279030-1-eperezma@redhat.com>
 <20201120185105.279030-11-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="90KBcPA0h13nTGdQ"
Content-Disposition: inline
In-Reply-To: <20201120185105.279030-11-eperezma@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--90KBcPA0h13nTGdQ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2020 at 07:50:48PM +0100, Eugenio P=E9rez wrote:
> Signed-off-by: Eugenio P=E9rez <eperezma@redhat.com>
> ---
>  hw/virtio/vhost-sw-lm-ring.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/hw/virtio/vhost-sw-lm-ring.c b/hw/virtio/vhost-sw-lm-ring.c
> index cbf53965cd..cd7b5ba772 100644
> --- a/hw/virtio/vhost-sw-lm-ring.c
> +++ b/hw/virtio/vhost-sw-lm-ring.c
> @@ -16,8 +16,11 @@
>  #include "qemu/event_notifier.h"
> =20
>  typedef struct VhostShadowVirtqueue {
> +    struct vring vring;
>      EventNotifier hdev_notifier;
>      VirtQueue *vq;
> +
> +    vring_desc_t descs[];
>  } VhostShadowVirtqueue;

VhostShadowVirtqueue is starting to look like VirtQueue. Can the shadow
vq code simply use the VirtIODevice's VirtQueues instead of duplicating
this?

What I mean is:

1. Disable the vhost hdev vq and sync the avail index back to the
   VirtQueue.
2. Move the irq fd to the VirtQueue as its guest notifier.
3. Install the shadow_vq_handler() as the VirtQueue's handle_output
   function.
4. Move the call fd to the VirtQueue as its host notifier.

Now we can process requests from the VirtIODevice's VirtQueue using
virtqueue_pop() and friends. We're also in sync and ready for vmstate
save/load.

--90KBcPA0h13nTGdQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/PMAAACgkQnKSrs4Gr
c8gavQgAw1mEua4Bu1as46tr75SMdL7OZIjXLc7U/7ipGFzF/CpY2dWW+pn/fmuo
Hti2GT73HxO/dNY0bQBdAlSt3khiO7ACSjUB9rd6+xz6YUlak8q6I3OyITFHSxT6
pJFrKX6oaOoVSkM127eYJ90cGqnJrAiWXjdlabuRXaW542cksyu4sRmUzaOiPATi
rCJRf4A9PGRpyuLouwi2iFUemk/M+JHp7xP1RA4TcNFF1POdTLL6Pz3u4tnLR0hs
O1/EQRfEPmXnMlW3ZHQdGm/Wzlvw09Z1So19n6Xhzst8cOzVXqtwA995/LbUugXr
eF5QMy92/O8yaVSwkQfQ6/ejnSWA1w==
=j5kK
-----END PGP SIGNATURE-----

--90KBcPA0h13nTGdQ--
