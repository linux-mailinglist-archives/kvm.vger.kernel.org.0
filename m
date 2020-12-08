Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E375A2D243F
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 08:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgLHHVg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 02:21:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbgLHHVf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 02:21:35 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7DEC061749
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 23:20:55 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id ce23so19415575ejb.8
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 23:20:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/h2yFiiCakJYZ7C4aOv6n4E6nxXfNP5Jigi5iFmZn4o=;
        b=g9k9EHyyE1hyh4GREJGgliFEA0ACDBQoilZma7WSGUbkrSU12XsZRINIy0PAa2YAbm
         8jIwIAWXmroD/yp7Wlkwg7/4zkF7ReIlTm8yY6vr93wZHRzKNagE5iTQRjbWaWGsmgCx
         IhMXTNfbWrw66OJZzE7QgPlmBO9LxJ31OfPy/jG0lWT06o/3FHubxQoiOaj+M9r9R+q6
         Oi6z+6pP4X6slMLeu0dZCJV4XZ1RrvNaA4yLihSzjdJJJCRmjl02MRaKgVxzDTZbsy4x
         B1N/VhOh/ToqToiS7YxKuFtp5CiTasuTKJTuDUWDgnEkCZTt+4plmE15QfzZ+X1oPCEI
         NBDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/h2yFiiCakJYZ7C4aOv6n4E6nxXfNP5Jigi5iFmZn4o=;
        b=Scpo0tn9ukr05siQw+ECtYnmg5jVwkvoyqKtRUlY11ZkwL8YlCuDdGH+eXE6EfZ+Gd
         c57v6V5usUhxfnke/B8mrL8FenXedcavCF2jy+2E4z4uS1Ojlj+bCay5V22bQ2zfFLiD
         Piq/xOGQnjntSF/zorr02hr7hbKIm2szgcHQ9n8NRfBeCBU0MCtyv8/YlHO1+1dET63V
         Ypg3atRPMPTMdXhCqCzjPncL7+9Dl+tmmcyTaUVxw/BGZzvlnNgPC110kegOG6poaJe5
         qj25dP/oKglevxs32WnsOqBbIj+IePXztplz/DW1WswpQrTPUsNBAaiugqFNtzfLEbho
         2QiQ==
X-Gm-Message-State: AOAM5305QtZqm97HW8V6arDmO6YIx0amhEjyqLvdNvexGlMN93w7dKgj
        faNRUsG36Y5RZqpXsWatir8=
X-Google-Smtp-Source: ABdhPJz/JnR5N/NM+ralFbvuipmGWLzBttoSpakMqOYFYSR5Rk/CB0G8LXhZRJBRyhaegtzdavo3sA==
X-Received: by 2002:a17:907:2108:: with SMTP id qn8mr22101643ejb.127.1607412054128;
        Mon, 07 Dec 2020 23:20:54 -0800 (PST)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id rl7sm13489164ejb.107.2020.12.07.23.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 23:20:52 -0800 (PST)
Date:   Tue, 8 Dec 2020 07:20:51 +0000
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
Subject: Re: [RFC PATCH 08/27] vhost: Add a flag for software assisted Live
 Migration
Message-ID: <20201208072051.GO203660@stefanha-x1.localdomain>
References: <20201120185105.279030-1-eperezma@redhat.com>
 <20201120185105.279030-9-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="keoAwTxaagou87Dg"
Content-Disposition: inline
In-Reply-To: <20201120185105.279030-9-eperezma@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--keoAwTxaagou87Dg
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2020 at 07:50:46PM +0100, Eugenio P=E9rez wrote:
> @@ -1571,6 +1577,13 @@ void vhost_dev_disable_notifiers(struct vhost_dev =
*hdev, VirtIODevice *vdev)
>      BusState *qbus =3D BUS(qdev_get_parent_bus(DEVICE(vdev)));
>      int i, r;
> =20
> +    if (hdev->sw_lm_enabled) {
> +        /* We've been called after migration is completed, so no need to
> +           disable it again
> +        */
> +        return;
> +    }
> +
>      for (i =3D 0; i < hdev->nvqs; ++i) {
>          r =3D virtio_bus_set_host_notifier(VIRTIO_BUS(qbus), hdev->vq_in=
dex + i,
>                                           false);

What is the purpose of this?

--keoAwTxaagou87Dg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/PKVMACgkQnKSrs4Gr
c8g4MQgAuHhrnsIoIcFJBG8vM52Q4JFZAfZXRtw2rZr14BSUaoKLRLLesEpWWkwy
xguwLpUJihF1okcf7wSAioIiVkaWPy/+z2Q2Yus4JQGPpZEYCfficmeOVnb1Whxr
6BJKaDQdNEjd7rpKiaegscT9iIyIOOGZErGBZTVBCttrBDbmoYtdtwrvTr0m97Tn
+0O56WNnmRVHZbbFlYpDCp61oH9VQSQbqsRp4nshZVwiaRHptw5PotRSYa9v+SUj
gaJj0DyxrTaOo/PZRzJgfH6ByiePKWy2y41ZVFIeV64aNJWNfPdlYcXgnAyBk3gF
s1qYSxylD703VnKvaWBQTXO8PnJikA==
=1YKg
-----END PGP SIGNATURE-----

--keoAwTxaagou87Dg--
