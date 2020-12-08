Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 291A02D259B
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 09:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728170AbgLHISk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 03:18:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbgLHISj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 03:18:39 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C157C061749
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 00:17:59 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id b2so16662985edm.3
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 00:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BiHatFn29jpCwDDhBSm+X0xUHoMKEAQw9eUj4sTBRlM=;
        b=mQzGDDBdkuRnj6sxJrdTG4VLsqwKNasQhPknV11+Pb27T5zHd8ND5cE/Djp3nCtC+X
         mRSuXJy8UnNQ9MPbDTV9NREs531651euPnlM6X1VV7T1aHhD4lOcB52TgpOijuJoWcmC
         LAWGMzcGgHB0S3Cdol4KEUXm9GqEoBhja1U4G0EWt+WfEMJAmJtXktow0Z6fRyjZfsLT
         rxrLLDJDJMhbscND2z2sjN5ThDAG/+oBWMTE8MK0SvpE5hCJvvQNPI5xDni+TxqIOxMo
         izM4EHrGKVv0m8M2uMTlXlZEfiSnZgExpNv/mQB6dODNYagN4wkxZ6xve+BbCqCOnrSB
         fjzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BiHatFn29jpCwDDhBSm+X0xUHoMKEAQw9eUj4sTBRlM=;
        b=XFwWB+J75EIcUbaiReGPh67ogI4ZUjm5k6eC4ZjgKha+T5HSzczHQs69TxNnr0lWwc
         8a9TTtTw9I3AE3VrhjBG1JAnskGXtE5fB1/gVq/a4QNjfDEzN62tRYTvsXy+bIPp0oWp
         6BwTt42cPO3qOzwLko/UA411uT73/RKQ6hOhIwGtwbO8UhvNcfxELIAvbNfQD0X4dkT0
         1WURJY5QYDkWL1oQ4yT+//aRYIoUJgpKIRLNVTWbqKhwiACcqrxbrBJTYSOj2lJ69jdI
         lhdoia0Q5VCgrIThQ98vA0hN+NavwNjuiT08il1McXWyuvxm7lGA7FyUL2G6x3wScI3D
         lvCg==
X-Gm-Message-State: AOAM5339TKfiE+xM1bImclzI7dxIy88Dv9rp4Fkd/oRbkh0+8FJYwOHw
        0hfumoxwH0CjPLBgTEicDSY=
X-Google-Smtp-Source: ABdhPJyHh0yxa7w8t9BjtnS6Zimgt4s5lHthEFOAPhZNJnJ55BjwATBi4HezVl7QtEVqO0Z0JSV7Pg==
X-Received: by 2002:aa7:d459:: with SMTP id q25mr23378343edr.279.1607415477826;
        Tue, 08 Dec 2020 00:17:57 -0800 (PST)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id ch30sm16327737edb.8.2020.12.08.00.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 00:17:56 -0800 (PST)
Date:   Tue, 8 Dec 2020 08:17:55 +0000
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
Message-ID: <20201208081755.GS203660@stefanha-x1.localdomain>
References: <20201120185105.279030-1-eperezma@redhat.com>
 <20201120185105.279030-11-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="E1BPhOSoTthPQdPL"
Content-Disposition: inline
In-Reply-To: <20201120185105.279030-11-eperezma@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--E1BPhOSoTthPQdPL
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

Looking at later patches I see that this is the vhost hdev vring state,
not the VirtIODevice vring state. That makes more sense.

--E1BPhOSoTthPQdPL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/PNrMACgkQnKSrs4Gr
c8hJxQf/Xue75u7nedZDTV1CqmKKp32KUzPMlA5zalyXvgqpXIivVnQ97AKeTHt9
vwLbUTVRNrC+5TVoAsyAlBeqFCRzwcdOdxIBFfqHE8bbND4mV+98ka4xPEwwFYQG
zxbcGPKnGwvdUP/ZYk4l/qK2EUwAmqXBq9v9XiBzciMBptG+CVNCOppv4SqaWhdn
IdTLT2m0KevNzqTvF6jOy6zA4BSoKYOZENTh20MSqWEILqCREtS/VkHCiqVW4DuJ
653E63sKml4j2uCGj25Tvs0JV6B+yDDf5jyz97B4qW8ur8cGbxmklBjXrlUSaBfI
m9FnQX/MGv39h7gG9BRaDnGfk7DyMQ==
=d+Ix
-----END PGP SIGNATURE-----

--E1BPhOSoTthPQdPL--
