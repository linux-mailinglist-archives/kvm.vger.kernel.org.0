Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9DBB2D59E3
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 13:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732293AbgLJL7Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 06:59:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34357 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732084AbgLJL7Q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Dec 2020 06:59:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607601469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+gQ9iINAWDXR5JwO1kT+v2+a0wsEJwps06F6jliWiHg=;
        b=DAW1g+CzcU3QHaEKuM5kxTDvNAa6W0SfgptrhwUrPHxL6ob9HH+yYU2zON3G+apDjLHIL1
        NqD8EOTsjJJ7YqKC84rAiAtMJ2FUr7vbWlk5G2VKqBaBuUyMHzvpfYq7bQAYaRbpc6Rxe3
        bA5hVgv9LcQ9q0ZrblmFAJCqJrh81qM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-uuDY_b2UP4KRLbhduxHdtQ-1; Thu, 10 Dec 2020 06:57:46 -0500
X-MC-Unique: uuDY_b2UP4KRLbhduxHdtQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 14A6F1005513;
        Thu, 10 Dec 2020 11:57:43 +0000 (UTC)
Received: from localhost (ovpn-113-62.ams2.redhat.com [10.36.113.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 48B0C5C67A;
        Thu, 10 Dec 2020 11:57:29 +0000 (UTC)
Date:   Thu, 10 Dec 2020 11:57:29 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@gmail.com>,
        qemu-level <qemu-devel@nongnu.org>,
        Lars Ganrot <lars.ganrot@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Salil Mehta <mehta.salil.lnk@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Liran Alon <liralon@gmail.com>,
        Rob Miller <rob.miller@broadcom.com>,
        Max Gurtovoy <maxgu14@gmail.com>,
        Alex Barba <alex.barba@broadcom.com>,
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
        Juan Quintela <quintela@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Howard Cai <howard.cai@gmail.com>,
        Xiao W Wang <xiao.w.wang@intel.com>,
        Sean Mooney <smooney@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Eli Cohen <eli@mellanox.com>, Siwei Liu <loseweigh@gmail.com>,
        Stephen Finucane <stephenfin@redhat.com>
Subject: Re: [RFC PATCH 16/27] virtio: Expose virtqueue_alloc_element
Message-ID: <20201210115729.GI416119@stefanha-x1.localdomain>
References: <20201120185105.279030-1-eperezma@redhat.com>
 <20201120185105.279030-17-eperezma@redhat.com>
 <20201208082552.GT203660@stefanha-x1.localdomain>
 <CAJaqyWdN7iudf8mDN4k4Fs9j1x+ztZARuBbinPHD3ZQSMH1pyQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJaqyWdN7iudf8mDN4k4Fs9j1x+ztZARuBbinPHD3ZQSMH1pyQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dMdWWqg3F2Dv/qfw"
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--dMdWWqg3F2Dv/qfw
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 09, 2020 at 07:46:49PM +0100, Eugenio Perez Martin wrote:
> On Tue, Dec 8, 2020 at 9:26 AM Stefan Hajnoczi <stefanha@gmail.com> wrote=
:
> >
> > On Fri, Nov 20, 2020 at 07:50:54PM +0100, Eugenio P=E9rez wrote:
> > > Specify VirtQueueElement * as return type makes no harm at this momen=
t.
> >
> > The reason for the void * return type is that C implicitly converts voi=
d
> > pointers to pointers of any type. The function takes a size_t sz
> > argument so it can allocate a object of user-defined size. The idea is
> > that the user's struct embeds a VirtQueueElement field. Changing the
> > return type to VirtQueueElement * means that callers may need to
> > explicitly cast to the user's struct type.
> >
> > It's a question of coding style but I think the void * return type
> > communicates what is going on better than VirtQueueElement *.
>=20
> Right, what I meant with that is that nobody uses that feature, but I
> just re-check and I saw that contrib/vhost-user-blk actually uses it
> (not checked for more uses). I think it is better just to drop this
> commit.

contrib/vhost-user-blk doesn't use hw/virtio/virtio.c. The code is
similar and copy-pasted, but you are free to change this file without
affecting vontrib/vhost-user-blk :).

I still think it's clearer to make it obvious that this function
allocates an object of generic type or at least the change is purely a
question of style and probably not worth making.

Stefan

--dMdWWqg3F2Dv/qfw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/SDSgACgkQnKSrs4Gr
c8gBXggAw53QuLAS8n2bgSqAmCJga4/haYpDTp+tcWdB6R0QXZYfoJpiYcwL6Xor
xVRBetMYe7/mi+28pZ8gklFMpXUoxN4ZqJiIfGUXlLzhUaT5nkpvfxqyhnXkf1Hy
GqNiuv+V6U6kEvlVKK5ImLovsDj9xN6Gy80NUSk1a689Z+6qlD6zs21HAGOSpl47
ZsDLjAP6SMiYE6ZTVxvm42vBho0ixxW/ulW1BxlAOzWnukknFQr1Ci5Hl3RMsDmR
TmaccrPr8RgZtRzOVIOT/MhxCxBke95BKC5SQiLeooYIGGr6kIvIfEonTBCgLBkO
06D5WVldB7oAONWscYTRjJzqlKSUIA==
=090p
-----END PGP SIGNATURE-----

--dMdWWqg3F2Dv/qfw--

