Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178C61F085F
	for <lists+kvm@lfdr.de>; Sat,  6 Jun 2020 21:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728883AbgFFTfB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jun 2020 15:35:01 -0400
Received: from mout.web.de ([212.227.17.12]:58043 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728351AbgFFTfA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jun 2020 15:35:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1591472079;
        bh=lKUg2PhSFx6sUFem2OVSuuT/pnnC9Z/U+JZQ9f2W1EY=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
        b=JSjx9ofinJBv+SozHFfL4ZkwiOhDZ+taFFsMkB5z6y4OVKBC0Y7OjFEJqq/WHo0bG
         bQXdHZtzTOhHh2RsxXB68bufGCwRKyhoVacORdj9gXbTHX8QRYJxhSCgXjkQbz7wY+
         vcl9m58ZSTVEVfCAXYs7m3hZYgSEkQkA2+a7hcI4=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from luklap ([87.123.206.73]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MPKB5-1jKDLv3JD3-00PpsX; Sat, 06
 Jun 2020 21:34:38 +0200
Date:   Sat, 6 Jun 2020 21:34:35 +0200
From:   Lukas Straub <lukasstraub2@web.de>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, Eduardo Habkost <ehabkost@redhat.com>,
        kvm@vger.kernel.org, "Michael S . Tsirkin" <mst@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>, qemu-s390x@nongnu.org,
        Hailiang Zhang <zhang.zhanghailiang@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH v3 08/20] migration/colo: Use
 ram_block_discard_disable()
Message-ID: <20200606213435.664ca5e4@luklap>
In-Reply-To: <20200603144914.41645-9-david@redhat.com>
References: <20200603144914.41645-1-david@redhat.com>
        <20200603144914.41645-9-david@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/LYHMMuSwfzP+qx4=p_ni+M6";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Provags-ID: V03:K1:6/EiRazrWk4aoVSSJLHR/x+lzc9SP4jIhe6OtRGTKIE2vIIS39u
 +9MU1wXuX5wMqOEr6M2hIwSDy5i5IOCKDIeu+A+Nj9tUGCoNZgcVl3jiNzI7Ferxjr8dOLk
 XB8AkKuoreoVIu+lev4ShwOdWY4S8hU6envKebReReOdULc7uR8igOgVjgVSLwTbmJOV4Zq
 KfCJkHVw+af7sX6qzECWQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:NlkEyiKaNyw=:pIc6AxLTI8LTPkTs9aVvWs
 hyoadoiWE6feoptSNsvxry1/Xzwi/hYv/1bEtdfwTfIEoC5LIYq2T1042Suv02D4JnH+qHCC5
 zJi/etzDrRHpqVcU1YsWOv+7edppI33pZOYydz2gnmWS94Vtb++meOfMhGTSczvr18KI0/UOT
 t4s9o1xn9dBZNE1bjxvYHVmN+LCwcHbAd1xWG842s4EroTbvcpD/yE7zBSxGJN2uBnZRjtUrZ
 Zhez/GVm7PPqceA8C7QzAZaAHCW15lWimFftGfzmZZEnRbl5iy0WHL+TUpXEwNS9+EhEhM6VM
 N5iY2hOc3sQr4KHbHdyAuOp9TW6cWA4KYhtUfB8c4G2Vd3z0xhx9gecykCnvYrP61OWyNOjoA
 RgZ2DymITWXSDojqaeOp6y83tmEmM1HuzCAL1/HdTQpK626kf91kKdm0LNvSRKC8whYgR0SPm
 lsKo7X+fNHXO1x9rRv/yDxUljGiGQVGn4Y53XCjaz6JHDhhftj1OFAqqQa1SPUvF9Q4ZErQLk
 xn2NkmSrxWLMtlCojYMlrWCU32ued6xY21gTlIO7HokoQJ1bXhlI3O1dswPAta1eMa7niTP2C
 pQLE6xVeZsInaYBoZ8R6FTWvmkb3zMGAmuYgpglWxozDHznBQ91U/++5KJ9MC8TXJcGpzepmI
 P8Sd0rSbY8KVqDpnqo7GzYUAxT4Nx7OItnHASrxcBJYv3RBNWy7/jvHd1INhnDLHJQPA6bXyy
 ssOGf0sKjfbaMd9S8NZzKmva+zoqEWM0pbLBME/oLZkDT77rkVAemxpRvSExXnsCkYvKsOC6C
 tKZoacES7u0TjiErd/mrB8KmZQXKNIndlapbL1jvkT8enX56dbPvsp0J942EyjjiBOJT2c0PS
 wiiQXmkM+mESeKBMfwga15qmKfgls/nQpSLPqSXurJkgLcLfj086j2P9pNn8woSfSVem64YBP
 MOdKGexIahoC6YhMz637Pg171Whhqxd7EylDBPp1KSvkqCa0dW4BgBTRmyPyGZGeQRZosXgyX
 yJsVm9hWaNUkFdN9SkJMRYf7MRS3kHbgtvsWya6zyo87ZyhtCbbapiYI+JxJhmcv3l9CphJrq
 kZusiFvnUjdQOoczAuziScWvrrjLYW1YChWAYrOcioTphWmkE5wyET+k/3imbdE3G8WInd/Ap
 +yS21v6A1mrHsWYxZonGUAsHcHzwbc55ZsU9JgF96a9qoY1pYeMzJlmA6b+RsX8Idb/MOHYWv
 7WUw0hTP5UjkzPuia
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/LYHMMuSwfzP+qx4=p_ni+M6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed,  3 Jun 2020 16:49:02 +0200
David Hildenbrand <david@redhat.com> wrote:

> COLO will copy all memory in a RAM block, disable discarding of RAM.
>=20
> Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Hailiang Zhang <zhang.zhanghailiang@huawei.com>
> Cc: Juan Quintela <quintela@redhat.com>
> Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---

Hi,
This works well in my colo tests.
Tested-by: Lukas Straub <lukasstraub2@web.de>

Regards,
Lukas Straub

--Sig_/LYHMMuSwfzP+qx4=p_ni+M6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEg/qxWKDZuPtyYo+kNasLKJxdslgFAl7b78sACgkQNasLKJxd
slgswQ/9HxF5Kde3XJ4TbdV2756BABKJDSIQxKbvLTFAVJ3J9uMZSP8lv0h1Yftc
oMiKl1oKyeUDHZiwz+5MjCP6UZiIjl5UNqg4oJD7Tsl43aUYuxfBXhxtPGNVKFx1
EJRphGSiZcd+kYFx5OUvzB+f/fNsu5n0YhJ+iyD54Ttj2NZgBgeTyQ2UCoGM2RQc
kG8ZiUOGh6AEd/D5gRh5mbPToB9GVR54col2891RBBATA5gIfpxzRBY/gUoKCjKY
t8aGiZ3NB9/Ekb4Zv0zpodsUPxfS4xfhJSFyU7DtNeF0PclVZDjhWKWpmoWUvo1P
dhKCj7FtikfbuhRKbr5+myjYu+mZyK82+v7fR5KydmiAo5dL5x2uYD0sSKq/fZT9
6xakcwHCi3h0438Pi7iIuH+COKw4IKIeF8Rt2UEz6pz+1xCGGfLi7M5MYl3qi4MI
SQapHk1uruog/YLVK73H8KzqU7bc8qgKLOTqCcCdyWvhTf0t90J8k3fNQ8Fv62ej
1Loyy/WOuaHfEO2ajYamJPCRbJm95echI6E4odyCLu2hAfQq1Z78+78EiXP9Cxnq
rArF5n4vtGinKBLy4MDCByR/H0SYf2KAV0vSh9N82WhKHc3hNbN2jvijVK3CEn+E
wc9Jyymae3vXdkU4CCZudCSwhuNX2w/eJ13WZVTWo9nftO8vJVE=
=kqMZ
-----END PGP SIGNATURE-----

--Sig_/LYHMMuSwfzP+qx4=p_ni+M6--
