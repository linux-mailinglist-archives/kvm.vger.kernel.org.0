Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5640E6C710B
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 20:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjCWTZv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 15:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjCWTZu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 15:25:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9DBDBCA
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 12:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679599429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MCP6WQ/UnkFYQPbZ6UF1Z/GhxTZEQnAe4X6aMbwzzME=;
        b=Q4O9m9G78Bf1uf4YFsgOyGtELSV2jt41VuebqTVzS0OxDHQ1ASKMNee5BcPc6ppb4Bn7eP
        YjNY+hnZgrbY6Te8sfWTxi0rWVxNlXaz4GmFWNdQJYE0zlko0+CMC265JChtWPtk2R6UTa
        d66KfqExKDFOHZPKCYydP5+pE66H7eI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-495-NioI3iS0PmSuR7ioagn2BA-1; Thu, 23 Mar 2023 15:23:46 -0400
X-MC-Unique: NioI3iS0PmSuR7ioagn2BA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 20E13380673E;
        Thu, 23 Mar 2023 19:23:45 +0000 (UTC)
Received: from localhost (unknown [10.39.192.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3AFE91121314;
        Thu, 23 Mar 2023 19:23:44 +0000 (UTC)
Date:   Thu, 23 Mar 2023 15:23:42 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Sam Li <faithilikerun@gmail.com>
Cc:     Matias =?iso-8859-1?Q?Bj=F8rling?= <m@bjorling.me>,
        qemu-devel@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        qemu-block@nongnu.org, damien.lemoal@opensource.wdc.com,
        kvm@vger.kernel.org, hare@suse.de,
        Paolo Bonzini <pbonzini@redhat.com>, dmitry.fomichev@wdc.com,
        Hanna Reitz <hreitz@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v8 0/4] Add zoned storage emulation to virtio-blk driver
Message-ID: <20230323192342.GB1459474@fedora>
References: <20230323052828.6545-1-faithilikerun@gmail.com>
 <3983f8bc-5be2-bb3c-a5cd-647550f577a0@bjorling.me>
 <CAAAx-8Kq4JiA3rgjNuueBxWPiyKtQXy8-YCv04QOgbj=0DTXaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/Nz4WpxO4P2CBrIu"
Content-Disposition: inline
In-Reply-To: <CAAAx-8Kq4JiA3rgjNuueBxWPiyKtQXy8-YCv04QOgbj=0DTXaA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--/Nz4WpxO4P2CBrIu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 23, 2023 at 09:38:03PM +0800, Sam Li wrote:
> Matias Bj=C3=B8rling <m@bjorling.me> =E4=BA=8E2023=E5=B9=B43=E6=9C=8823=
=E6=97=A5=E5=91=A8=E5=9B=9B 21:26=E5=86=99=E9=81=93=EF=BC=9A
> > On 23/03/2023 06.28, Sam Li wrote:
> For the question, this patch is exposing the zoned interface through
> virtio-blk only. It's a good suggestion to put a use case inside
> documentation. I will add it in the subsequent patch.

Regarding the state of other zoned devices:

--device scsi-block should be able to pass through SCSI ZBC devices.

QEMU supports NVMe ZNS emulation for testing, but cannot pass through
zoned devices from the host yet. If you have an NVMe ZNS device you can
use VFIO PCI pass the entire NVMe PCI adapter through to the guest.

Stefan

--/Nz4WpxO4P2CBrIu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmQcpz4ACgkQnKSrs4Gr
c8ijrwf/esAH/6Y/U9E8/d79PGVht9b3OfY+uNJO2TfYnMH9D9GFL2PLe9G2kbZq
ajSlVRrTWYvebCIURVNzXSRmHOJJGopgYvlqUSeNIKuc+w9SqXqQbY4ns4bthIDb
rJkaZ4IP5zV2hFfEUDl2i00uvO9JeGKOW3y1sOm5GuU3BBm/WLHhNa6/ViPVOxJg
t4kAyG5hQ40K1GidZHQxEWgpaOW9c4hQYRrNRkWBKEefA6yIhYimyhm1EttiGcQv
Q5rz5mmKFlpQC4nnxvTdtAqUAQG8Lw8h9aOSYekDjC9zVK6wOysK1k0OhrTW8/nK
vewRH4naYf8aKH62FlY4Ptef6NUiTQ==
=Q0kO
-----END PGP SIGNATURE-----

--/Nz4WpxO4P2CBrIu--

