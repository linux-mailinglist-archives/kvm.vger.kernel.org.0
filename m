Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D953A2D269B
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 09:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbgLHIux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 03:50:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbgLHIux (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 03:50:53 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2CFBC061749
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 00:50:12 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id f23so23531282ejk.2
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 00:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TZXwYDaCWS7e1DN18P4hTw8qRki8SYJYAh/bIEvt7VA=;
        b=FZ0lHPANfEWsj+/iVtzHykLTQO6ijRLMLun67MC83GxuH1p2GZvrYjVFI3LNftNYmi
         /WF/Ppj7Wq5wn6x5qlhZ7poOpmvIzR9WmdgY8pxNF30wGY0Co7IAbS2881d+bH0E6Byn
         bpioRfSGZZ4HMfmUGGDYIBx8I9lWUbAfa90kVnGyoX+TsCLBzuOSbLyiDTiWf1LMert8
         UgTYEKxN95dU+dYig9SnYr/1zjEk7X1WFDFui6Zn9YsLNmnCV9FZ9w0tvEVe2ihnVf8w
         L9O0G22F2V+wSKewS6KowfEZDIuF/m1OLAcCf+VIX9oZBeQmp9GyjwPdaUayPjCGVMO+
         P38w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TZXwYDaCWS7e1DN18P4hTw8qRki8SYJYAh/bIEvt7VA=;
        b=uEqXlfN2fs47QO+iIzwr66alR/NRggE8BRU2L7NDWTUE1+OBe76UZjBTbShIDMTLp2
         /ymyXRP79AlKMHI6KOoZpV3mMypeB3DeaQtDP+cxz3p8v+DRx5dv4+L231maRpDpUIFn
         OU9/YjoQcHhr6MDfJjKUz7zbN8VMh6xdWSPfOh+gi6EvEXeQbrL3M4jiQnZG3m8nsEG7
         29DGtv6fcmEI4U55XG+Jrl9jlElwFKUrUtWrmm9EKSHfi0TSUfZjy+ILaSld6VwUoxws
         +55o0gFLvzW3CX4+LKOAwt1aj4hqi0dvAUw2qC953puJXtiG4TSXQfrmGYWj9hcaMP3f
         wl0g==
X-Gm-Message-State: AOAM530VDIOTzCMdbOV14YfGADX2P01f9ijXKuTEmT+BKeJKflVTO9wj
        a0Irx4Zo/CPeCLsILcR5QPU=
X-Google-Smtp-Source: ABdhPJww+kwZb8018JvYoa53FIBJf92vPUO/fyV4DEOGl5s9UG9EkjlxM/dxQWfVsgIsKRCS5yIpUg==
X-Received: by 2002:a17:906:3c11:: with SMTP id h17mr21899491ejg.20.1607417411619;
        Tue, 08 Dec 2020 00:50:11 -0800 (PST)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id d6sm14878522ejy.114.2020.12.08.00.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 00:50:10 -0800 (PST)
Date:   Tue, 8 Dec 2020 08:50:09 +0000
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
Subject: Re: [RFC PATCH 20/27] vhost: Return used buffers
Message-ID: <20201208085009.GV203660@stefanha-x1.localdomain>
References: <20201120185105.279030-1-eperezma@redhat.com>
 <20201120185105.279030-21-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YnIutncTLXsDZs5t"
Content-Disposition: inline
In-Reply-To: <20201120185105.279030-21-eperezma@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--YnIutncTLXsDZs5t
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2020 at 07:50:58PM +0100, Eugenio P=E9rez wrote:
> @@ -1028,6 +1061,7 @@ static int vhost_sw_live_migration_start(struct vho=
st_dev *dev)
> =20
>      for (idx =3D 0; idx < dev->nvqs; ++idx) {
>          struct vhost_virtqueue *vq =3D &dev->vqs[idx];
> +        unsigned num =3D virtio_queue_get_num(dev->vdev, idx);
>          struct vhost_vring_addr addr =3D {
>              .index =3D idx,
>          };
> @@ -1044,6 +1078,12 @@ static int vhost_sw_live_migration_start(struct vh=
ost_dev *dev)
>          r =3D dev->vhost_ops->vhost_set_vring_addr(dev, &addr);
>          assert(r =3D=3D 0);
> =20
> +        r =3D vhost_backend_update_device_iotlb(dev, addr.used_user_addr,
> +                                              addr.used_user_addr,
> +                                              sizeof(vring_used_elem_t) =
* num,
> +                                              IOMMU_RW);

I don't remember seeing iotlb setup for the rest of the vring or guest
memory. Maybe this should go into a single patch so it's easy to review
the iova space layout.

--YnIutncTLXsDZs5t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/PPkEACgkQnKSrs4Gr
c8jbGwf+OqBpKYq3vRs1xwb03191eAU1RZXGSRe283/ocJlVX8EMuoRMZPbbEXgt
+OqCILt/QQuvQloLfm23ggS9XXUgKfQSPG16bFM0RE6j5lDUqDWESbduxFWxWl5k
YAZhTPElTlaGeJbRpW4Ls2bqKSIkd77wtZu+AdPGGfr6IiZxE2rC3Rut3qhzl6A4
C2dhtR3TPweeG5bL8ls6tv3t9+J0n4tap8b93aX920+9ksgj1uYEZNjRk6jEWiMG
2vy5eEgE/SJcaNSFafSgYQGGscP3nAHCcwgkUs7MjiGyVXiMNi0xDGunPdQ1R/f/
/Sto7Mj12OlDF0kbMRUuNi5FfF3wOA==
=vcmP
-----END PGP SIGNATURE-----

--YnIutncTLXsDZs5t--
