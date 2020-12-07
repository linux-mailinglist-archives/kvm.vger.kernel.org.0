Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1892D1705
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 18:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgLGQ7c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 11:59:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727352AbgLGQ7c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 11:59:32 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9A8C061749
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 08:58:51 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id lt17so20541052ejb.3
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 08:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ODFYNKTjMTwnPrK31rw4SLzGgzSU67H0O2yeRZFdhqE=;
        b=StWv8dDxId3OKQIuDuKxj9jQNu0m2dzeV78062mOPIKyxMU89QJYro/YNl6/gjoSSS
         v+t8vX/HJok65OHBMUd/BtXcUpWPE5Ub+gyBQOwt1/2u/C8p+9CU+1Mcr4dA+Y14w57i
         45c9afhRrA+LOIgaVY/Kd651s2f0piLIcWD4/ZPGUokK04B51HiNdCtNJ238uJfgGUcE
         rw4cg4ji6epNW5tAC0WMjVbnEYY1SQjxkYzqX3FZ/JoKmSLH1MrT7IFpcIu3FPLfnUTb
         s+MZhd9GtEOIS4n+mXJNrCelojEWWRysYkGqyQ3LzTTqgH5FkkH79xzDO9SGVNseGj6i
         Q13g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ODFYNKTjMTwnPrK31rw4SLzGgzSU67H0O2yeRZFdhqE=;
        b=bHQY7mWAM19jAvhY85NqzRWXW+hnd6DVZvJpUyOO0KR51ZAfH/I4sR5j9aYG5vhcm8
         lzrGDxFtXPRpsZO8mpsFoOChzcvqDTQLZkS21RHS6PzG33NeJwlqXuIZvmNqQfrd0/hE
         KROFv+3YH9+nPrKpbhwyhBihV+lxeKIwBi2mmhl1jxWZ0K9bNixSXKNiXW+belUThW6I
         GfCVsDW3dI9UObgACbinbonUmZ0tyi+UwgFY7w1U3P89umML/EmjdY+/U/3PhyZfNMv6
         YqYDM/BTQpNYKHL7DX2nrali75U7/d/sXKqkbpbamU47dvJ4F8Q2Z+oJjm9goGkAd3Yt
         ZqvA==
X-Gm-Message-State: AOAM531g70erDa6fUTpZchSXzAjE2C82MV1lc0WzXl67lJbEipwcQutF
        1rOvZRKEbFXwhWJHiq1eDo4=
X-Google-Smtp-Source: ABdhPJzHOW+Ylwqjw+on2+NxIj8szkbB93r8R6R4oPxzlBCIMpXESI+nx/IQwtqoqUYOs2yYBcEfMQ==
X-Received: by 2002:a17:907:447d:: with SMTP id oo21mr19969752ejb.367.1607360330523;
        Mon, 07 Dec 2020 08:58:50 -0800 (PST)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id n1sm12853926ejb.2.2020.12.07.08.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 08:58:49 -0800 (PST)
Date:   Mon, 7 Dec 2020 16:58:48 +0000
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
Subject: Re: [RFC PATCH 06/27] virtio: Add virtio_queue_get_used_notify_split
Message-ID: <20201207165848.GM203660@stefanha-x1.localdomain>
References: <20201120185105.279030-1-eperezma@redhat.com>
 <20201120185105.279030-7-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="EOHJn1TVIJfeVXv2"
Content-Disposition: inline
In-Reply-To: <20201120185105.279030-7-eperezma@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--EOHJn1TVIJfeVXv2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2020 at 07:50:44PM +0100, Eugenio P=E9rez wrote:
> This function is just used for a few commits, so SW LM is developed
> incrementally, and it is deleted after it is useful.
>=20
> For a few commits, only the events (irqfd, eventfd) are forwarded.

s/eventfd/ioeventfd/ (irqfd is also an eventfd)

> +bool virtio_queue_get_used_notify_split(VirtQueue *vq)
> +{
> +    VRingMemoryRegionCaches *caches;
> +    hwaddr pa =3D offsetof(VRingUsed, flags);
> +    uint16_t flags;
> +
> +    RCU_READ_LOCK_GUARD();
> +
> +    caches =3D vring_get_region_caches(vq);
> +    assert(caches);
> +    flags =3D virtio_lduw_phys_cached(vq->vdev, &caches->used, pa);
> +    return !(VRING_USED_F_NO_NOTIFY & flags);
> +}

QEMU stores the notification status:

void virtio_queue_set_notification(VirtQueue *vq, int enable)
{
    vq->notification =3D enable; <---- here

    if (!vq->vring.desc) {
        return;
    }

    if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED)) {
        virtio_queue_packed_set_notification(vq, enable);
    } else {
        virtio_queue_split_set_notification(vq, enable);

I'm wondering why it's necessary to fetch from guest RAM instead of
using vq->notification? It also works for both split and packed
queues so the code would be simpler.

--EOHJn1TVIJfeVXv2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/OX0gACgkQnKSrs4Gr
c8joJwgAxP2IQdibt4q6jUVfHjl/jy+5PpzROcRTI3+NTOW7RZAtHwg1VSLc+N8N
AGRSKiaMpsWS/ApNmdzTjrmMurFOZRjrsPVwu+UDqsd1vscYk9ZWhc3vS24gYSot
X9Y0av+ZpV0OBKlFGpEdqaOHt7LuK/IwyZe5fXGH0CAH25+OKky7gisAMXeY9c3L
CEusJ6PGE4fr+99IcJcefGiMPCW6QvmJQnvsq2F7ST1ArsPfhvZASZWnucmtXsNH
YywpV+RFNQrbyiMU86CwVE99COm16dTpb1n4QHu5+4tTQa9l3wy9cKTPrrFzlUGI
Wm8tTPQ1Njha3wNnYaoHBGcNMX0sCg==
=RgXt
-----END PGP SIGNATURE-----

--EOHJn1TVIJfeVXv2--
