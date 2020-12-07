Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E86A2D16AD
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 17:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727760AbgLGQoH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 11:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgLGQoH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 11:44:07 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66B3C061793
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 08:43:26 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id ce23so16644478ejb.8
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 08:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=trwWkN08RC97k3KH48B9gNQriEKWSyCbtbzCxwfGmWE=;
        b=B1EfYNbMVMFOaHv5Q1+MqxN4scHz/Hv2fxp5bGgVC+k0ctBrJNkDB5ON3sGBLmaQW5
         blaRzeSuWIpqS+bVQsZMBPxJI8qZqkB3vAkb7ZKE/z1Y2OwARk5Rn2HNXDzI7jOlrvf4
         RNSG3KDnMlyl33wXV01uXcO2Fn3qrf6AB/zxTIeRuxVzkPpRx14EgA0CNunoi2Bl4rGC
         5qAN0mMe6htUVLfW/sP/mFXpYntXPXC2gICjdEpOUEJvh+hE+akT2xtD0KWG30J3Gniq
         Dg6xvPp/SY/g5caQK0EmruRZ2vgxERtmT1abew+RC1FKJZNx/gw5mhLQw18Yzijrqefe
         e8iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=trwWkN08RC97k3KH48B9gNQriEKWSyCbtbzCxwfGmWE=;
        b=e1SUiXCJzeNyksHXeoM+PJND72I6AfNcPvTS00GlShFdt3MvNfU9HRAzeuyWlLiO/A
         cn6r6ZbBEZkYCMtj9xnVSm6pgtgI9H4409E7lTkjD480awkRZ2ONH8NvizmcvxsUTdDH
         s1SCRdprfOiyD6vFvEUcZHw7nGFtNGvKKvH0Chb6uK0lOnvBuvUvVkhf1DujfPIIhTvD
         H8ENY3nI78E0gS7BRvjXfnYBscbP48v6FHJGdlEv17Ve52MjO1Yz+L94CxstxHmpwLD3
         CjPQPNIJpvFW2pX5JWLwy67LGmdXuSX0C874k2BmkS10LwoO1GY+8mW92w4rqyDIo2Qu
         fvcw==
X-Gm-Message-State: AOAM533peNG4B43Fof2dEb6d91Pe2aK0ft6A060Hq9BgpUWUG53cnyi4
        GAdJbxcT7sZ4A5uKyhToVSA=
X-Google-Smtp-Source: ABdhPJwY9MeoSxGwRPyIJV5M0g2NpLCkzQk4QntsuJ7EEGm36J5EQc7Tf8qRkCsQBxMYB/d2Z8WFeA==
X-Received: by 2002:a17:906:ae41:: with SMTP id lf1mr20055824ejb.369.1607359405393;
        Mon, 07 Dec 2020 08:43:25 -0800 (PST)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id w20sm14259249edi.12.2020.12.07.08.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 08:43:24 -0800 (PST)
Date:   Mon, 7 Dec 2020 16:43:23 +0000
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
Subject: Re: [RFC PATCH 04/27] vhost: add vhost_kernel_set_vring_enable
Message-ID: <20201207164323.GK203660@stefanha-x1.localdomain>
References: <20201120185105.279030-1-eperezma@redhat.com>
 <20201120185105.279030-5-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ogUXNSQj4OI1q3LQ"
Content-Disposition: inline
In-Reply-To: <20201120185105.279030-5-eperezma@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--ogUXNSQj4OI1q3LQ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2020 at 07:50:42PM +0100, Eugenio P=E9rez wrote:
> Signed-off-by: Eugenio P=E9rez <eperezma@redhat.com>
> ---
>  hw/virtio/vhost-backend.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>=20
> diff --git a/hw/virtio/vhost-backend.c b/hw/virtio/vhost-backend.c
> index 222bbcc62d..317f1f96fa 100644
> --- a/hw/virtio/vhost-backend.c
> +++ b/hw/virtio/vhost-backend.c
> @@ -201,6 +201,34 @@ static int vhost_kernel_get_vq_index(struct vhost_de=
v *dev, int idx)
>      return idx - dev->vq_index;
>  }
> =20
> +static int vhost_kernel_set_vq_enable(struct vhost_dev *dev, unsigned id=
x,
> +                                      bool enable)
> +{
> +    struct vhost_vring_file file =3D {
> +        .index =3D idx,
> +    };
> +
> +    if (!enable) {
> +        file.fd =3D -1; /* Pass -1 to unbind from file. */
> +    } else {
> +        struct vhost_net *vn_dev =3D container_of(dev, struct vhost_net,=
 dev);
> +        file.fd =3D vn_dev->backend;
> +    }
> +
> +    return vhost_kernel_net_set_backend(dev, &file);

This is vhost-net specific even though the function appears to be
generic. Is there a plan to extend this to all devices?

> +}
> +
> +static int vhost_kernel_set_vring_enable(struct vhost_dev *dev, int enab=
le)
> +{
> +    int i;
> +
> +    for (i =3D 0; i < dev->nvqs; ++i) {
> +        vhost_kernel_set_vq_enable(dev, i, enable);
> +    }
> +
> +    return 0;
> +}

I suggest exposing the per-vq interface (vhost_kernel_set_vq_enable())
in VhostOps so it follows the ioctl interface.
vhost_kernel_set_vring_enable() can be moved to vhost.c can loop over
all vqs if callers find it convenient to loop over all vqs.

--ogUXNSQj4OI1q3LQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/OW6sACgkQnKSrs4Gr
c8jcDwgAvhR1DPn/758yBurYSAd5bodrjz48KqGTFPhHnHIzAsDSztsiZ/VKnhlt
lkf8slJQyaaQ5G9Po4HX6CNdMSNmkBT1mz0lk6dnr75aHQ/hijqknpXM1og/4MRQ
lCUyXQhHsLGZ3ETT8Is/Bgg99b3T0SykRSzhlpzIMaPqGgzvzTNdh1u0SFKi3W3o
Vke/ZS/yZ2K0F+sNwQzPGp5JflOTagn1QuGO8JslZinLNh8y3C05n/6ZCWbM9Jl9
ABaBPHhenGFmH672WMK839qEawHgEUS6aziPnVfPczqudEqinJpHT9Oc6xMeBG1D
mv3UoTm7iaY08guxGcO5yO6FILXe/g==
=IdPX
-----END PGP SIGNATURE-----

--ogUXNSQj4OI1q3LQ--
