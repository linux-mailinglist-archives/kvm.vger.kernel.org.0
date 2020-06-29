Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 903C020E048
	for <lists+kvm@lfdr.de>; Mon, 29 Jun 2020 23:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388942AbgF2Uol (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jun 2020 16:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731594AbgF2TN7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jun 2020 15:13:59 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1BBC00877D
        for <kvm@vger.kernel.org>; Mon, 29 Jun 2020 02:26:50 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id k6so15806819wrn.3
        for <kvm@vger.kernel.org>; Mon, 29 Jun 2020 02:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2ag+08nSeSr6EqkiGuHLlAELsHQApzSuYKPqMWgc+aA=;
        b=sGVxejwGSDuSw2Q1kO4cvm5jx1DmxMYSYraHX6cHuB0RJNXu+AVUG/392jEMAZWFiN
         rqLodF1hAY1isTwa7TGAF8sPw782rX09KHEpMQdnR+ZGr7IbQN05/7Q1GhPT2X10V5bz
         Xbm+tPkA2azeZ55pSjdePfxWMcem9WNDIjN/Iv309PoMB9CapVAIiTG4zzQlT+ygA+kP
         Myn5f74stAiNV+OrA0CvqIucteZ8PjjPq3oq2c6GQZiJT75JdNsfRrbLRkZBsmjVtvs+
         9MgsGDOI2yj9taw/BsNjwj2dixG2tsffTsOwt6S3vPEdQt/6Altn4pm/WlhI1TM/pIf5
         EKkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2ag+08nSeSr6EqkiGuHLlAELsHQApzSuYKPqMWgc+aA=;
        b=kGT9Gje/u8w86VSJK4UhQTU8oU2cdNcTrTMwlEOXyxFcNUv+NpgFRZwn3+XwJkekn9
         AVz5hXGcMWWWidbAxyKB235kHEo9sx2nAN9HZmN3MGPiiCxwwXeZZk3MFxMEOH5kIiZI
         QEYFhVMO48Vt+JpsdigAFbfjWDfxP/Ti8m5nFbgHhMdjjAK6n7yLNFLyr5LF5REH4jkl
         yTuTJ/SSzZoAzrEJdOz13GJu0i6qwSaQowGnGRAwGD00r37Qr4nyJuJXnGkhUKMnCVqC
         rBXixdP7uWNEJTcydHVTIFQT+EVthlUPMCGjjeYd/54g+yoseafjmYOicTWtFN2gU2hI
         Gfdg==
X-Gm-Message-State: AOAM530IWzHl0cH1B9SxI5UDADkJd+8V6rDUZsqwbk8TjamZEa9ss6d5
        WY8skOZMhj+wzwbn1Ko4zd8=
X-Google-Smtp-Source: ABdhPJw2AMURrJPby179MwG4mhz9UG670amev/bcvGRiECK4d8FyEybeGQpKxfxKTP0KVngy0h617A==
X-Received: by 2002:a5d:4603:: with SMTP id t3mr17395732wrq.38.1593422809180;
        Mon, 29 Jun 2020 02:26:49 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id l18sm19774398wrm.52.2020.06.29.02.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 02:26:48 -0700 (PDT)
Date:   Mon, 29 Jun 2020 10:26:46 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [RFC 0/3] virtio: NUMA-aware memory allocation
Message-ID: <20200629092646.GC31392@stefanha-x1.localdomain>
References: <20200625135752.227293-1-stefanha@redhat.com>
 <9cd725b5-4954-efd9-4d1b-3a448a436472@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="m51xatjYGsM+13rf"
Content-Disposition: inline
In-Reply-To: <9cd725b5-4954-efd9-4d1b-3a448a436472@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--m51xatjYGsM+13rf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 28, 2020 at 02:34:37PM +0800, Jason Wang wrote:
>=20
> On 2020/6/25 =E4=B8=8B=E5=8D=889:57, Stefan Hajnoczi wrote:
> > These patches are not ready to be merged because I was unable to measur=
e a
> > performance improvement. I'm publishing them so they are archived in ca=
se
> > someone picks up this work again in the future.
> >=20
> > The goal of these patches is to allocate virtqueues and driver state fr=
om the
> > device's NUMA node for optimal memory access latency. Only guests with =
a vNUMA
> > topology and virtio devices spread across vNUMA nodes benefit from this=
=2E  In
> > other cases the memory placement is fine and we don't need to take NUMA=
 into
> > account inside the guest.
> >=20
> > These patches could be extended to virtio_net.ko and other devices in t=
he
> > future. I only tested virtio_blk.ko.
> >=20
> > The benchmark configuration was designed to trigger worst-case NUMA pla=
cement:
> >   * Physical NVMe storage controller on host NUMA node 0
> >   * IOThread pinned to host NUMA node 0
> >   * virtio-blk-pci device in vNUMA node 1
> >   * vCPU 0 on host NUMA node 1 and vCPU 1 on host NUMA node 0
> >   * vCPU 0 in vNUMA node 0 and vCPU 1 in vNUMA node 1
> >=20
> > The intent is to have .probe() code run on vCPU 0 in vNUMA node 0 (host=
 NUMA
> > node 1) so that memory is in the wrong NUMA node for the virtio-blk-pci=
 devic=3D
> > e.
> > Applying these patches fixes memory placement so that virtqueues and dr=
iver
> > state is allocated in vNUMA node 1 where the virtio-blk-pci device is l=
ocated.
> >=20
> > The fio 4KB randread benchmark results do not show a significant improv=
ement:
> >=20
> > Name                  IOPS   Error
> > virtio-blk        42373.79 =3DC2=3DB1 0.54%
> > virtio-blk-numa   42517.07 =3DC2=3DB1 0.79%
>=20
>=20
> I remember I did something similar in vhost by using page_to_nid() for
> descriptor ring. And I get little improvement as shown here.
>=20
> Michael reminds that it was probably because all data were cached. So I
> doubt if the test lacks sufficient stress on the cache ...

Yes, that sounds likely. If there's no real-world performance
improvement then I'm happy to leave these patches unmerged.

Stefan

--m51xatjYGsM+13rf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl75s9YACgkQnKSrs4Gr
c8jAlQgAkxcrX8BwizJMukF4LIVrZHVVDcZjCvl+WEazZ8s6RpSCMj1yeg1wyplH
lt34UesBkGMWTyRQPfQTC16lAQy9hn1nPLhrqyFPk9oiQUEK9Kzf5j7I3JnLVNnI
jBGARfiyb0nKnhfqx0y/ixeAOLDNf9d2swoEc4lnqCo584dlMliJLIC/2jE7AvwF
M6xsrjW6JNxLuV4shp0CaWVgsPd/6OR8PMPy9XatWVPgyF9fpPn6pZJsb6B8d+gL
8lCvNa0+Deq/ruy67yyzenpuqvyMmA11HeQocFFqIvaEdCHA6QCGil0fmXVb0Ile
4X2GnES1wsHbGId3ofPrpM4rjxm7Rw==
=IwcF
-----END PGP SIGNATURE-----

--m51xatjYGsM+13rf--
