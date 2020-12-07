Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467982D16D8
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 17:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbgLGQxA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 11:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbgLGQxA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 11:53:00 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E1DC061749
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 08:52:19 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id lt17so20508245ejb.3
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 08:52:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OTQRBjUe2TNjYMgJefl7n0HpBavaiUEtwmxJsr1/2t4=;
        b=erKmXltJIFGXdOQcph/EmLbnMRY6RChItOwpRyiu8mFYM+wjLN9CHS8NfD8l6oT6qJ
         1f/szmE8g+MJAyGMfg78p8iPicMlWeScTuFEWULsmGKKsuAlilIgx6fw334H1Q6/1R2r
         qFRDGMSE6bgWNv5M5iOHiqZOmFzj+zS2s/4VInI1sJuZOADPtUs8x7MlwhR1+oGPruEG
         ydJKuWQ1H76nsoemtOULbMSmbVQAUW1rsuwvKPl4VoUrKRtyPt1353Tsr2CsusdN1oij
         t/UNHMJUgc6F8336mbycNpSenKA4XbUZoHoG4eaWiwmHcftSFe8ZoQZgiCadTLdwYC3w
         L1AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OTQRBjUe2TNjYMgJefl7n0HpBavaiUEtwmxJsr1/2t4=;
        b=Gn3fw6rWliYuZ5YClL42a1/iylJHpu1LFyonKZEHUc296CTXFaa4WjgC4nOsuGs7uj
         cQQ9adFslKg7b82Zvg0tlk4IVEoYuorJgE+8Y0aIhhRTSLsEWCgP9hn4NClUvQ5es8uL
         ngK20ueYT2yyLgBiB7ma/Elh5vSWVgW6SjLICXbHT01T1YLbxaLY5iBP7RTYsww0srqL
         OullSEz+MZmPXrkGC/eUB3p/nLyTIYXmaFxuOAnb2PlXG12r1I/Aza7KSrwdDIRRRG0f
         5OqHXP4TEya2fcqHpLnoLzj6ry37fb6cC/jiiowWk6dq+J0uUZRvjWwG9N1lb8zgGMUv
         8sYQ==
X-Gm-Message-State: AOAM531KmIvhdy7o34Xb/bKP6d1JlftqOmP1UEcof/wLqjkh1UKTx37t
        PGj7eXkFINqcAiJuvuRjWls=
X-Google-Smtp-Source: ABdhPJycsLY1gSAtaotTfUaJl7iKx3GhozpQNix9ydMBC5YVDHoyAJwcCg7JB0Eipy1M7eJ+9OyCCg==
X-Received: by 2002:a17:907:28d4:: with SMTP id en20mr19944431ejc.196.1607359938454;
        Mon, 07 Dec 2020 08:52:18 -0800 (PST)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id q4sm10641523ejc.78.2020.12.07.08.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 08:52:17 -0800 (PST)
Date:   Mon, 7 Dec 2020 16:52:16 +0000
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
Subject: Re: [RFC PATCH 05/27] vhost: Add hdev->dev.sw_lm_vq_handler
Message-ID: <20201207165216.GL203660@stefanha-x1.localdomain>
References: <20201120185105.279030-1-eperezma@redhat.com>
 <20201120185105.279030-6-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VBq/nvTu32OVLBUP"
Content-Disposition: inline
In-Reply-To: <20201120185105.279030-6-eperezma@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--VBq/nvTu32OVLBUP
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2020 at 07:50:43PM +0100, Eugenio P=E9rez wrote:
> Only virtio-net honors it.
>=20
> Signed-off-by: Eugenio P=E9rez <eperezma@redhat.com>
> ---
>  include/hw/virtio/vhost.h |  1 +
>  hw/net/virtio-net.c       | 39 ++++++++++++++++++++++++++++-----------
>  2 files changed, 29 insertions(+), 11 deletions(-)
>=20
> diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
> index 4a8bc75415..b5b7496537 100644
> --- a/include/hw/virtio/vhost.h
> +++ b/include/hw/virtio/vhost.h
> @@ -83,6 +83,7 @@ struct vhost_dev {
>      bool started;
>      bool log_enabled;
>      uint64_t log_size;
> +    VirtIOHandleOutput sw_lm_vq_handler;

sw =3D=3D software?
lm =3D=3D live migration?

Maybe there is a name that is clearer. What are these virtqueues called?
Shadow vqs? Logged vqs?

Live migration is a feature that uses dirty memory logging, but other
features may use dirty memory logging too. The name should probably not
be associated with live migration.

>      Error *migration_blocker;
>      const VhostOps *vhost_ops;
>      void *opaque;
> diff --git a/hw/net/virtio-net.c b/hw/net/virtio-net.c
> index 9179013ac4..9a69ae3598 100644
> --- a/hw/net/virtio-net.c
> +++ b/hw/net/virtio-net.c
> @@ -2628,24 +2628,32 @@ static void virtio_net_tx_bh(void *opaque)
>      }
>  }
> =20
> -static void virtio_net_add_queue(VirtIONet *n, int index)
> +static void virtio_net_add_queue(VirtIONet *n, int index,
> +                                 VirtIOHandleOutput custom_handler)
>  {

We talked about the possibility of moving this into the generic vhost
code so that devices don't need to be modified. It would be nice to hide
this feature inside vhost.

--VBq/nvTu32OVLBUP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/OXb8ACgkQnKSrs4Gr
c8h0zgf/Y8KuZmHAiJe/VBJicMVsGgLkqfkqKp7+bL8u8nU75Wm24ECd47sAbvWK
q/BQs7t9VxQ0KBH8DJBGviwxG4bfoAtzXpSKgHRgbvd0AWHqJqfbEcKP+yZ0mKwB
uSAsQqNU/K9DxvNiJSzzklUvKmvKPrWXwgWsP2jRKOTAxn2nvNrCO+X9sAveTmEk
ZMfFOsHVNVxc4nJIwRsySTnpUz4ADJvzrhGk8cvjIIg/9Gq28EsYiMLWhtQymrj6
iEIZnfg5REWv/w3KzvwqVBaBqVF/QkFk0w8naAuT+KHbr+fKZLtMVC6ebY44vqZN
+iQr7fQg3dfy8ba7WFxyYHnVGmZMEQ==
=GegK
-----END PGP SIGNATURE-----

--VBq/nvTu32OVLBUP--
