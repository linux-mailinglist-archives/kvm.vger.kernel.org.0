Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 604206C710D
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 20:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbjCWT1A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 15:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjCWT07 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 15:26:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1FB8A56
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 12:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679599576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hwpDPG8hWOmnRuQ2UfpouVGelWkpeYxf66en20QDEYE=;
        b=Rcv4M+PXZtt8Ob6HsVIYKN4tJFO7w1QNKOgQVk44FrUQRcJie0Bhg7dQCH56hwpvWkFxpO
        ijYDBORlAlRWtz//S+g4JHr1Ims+RXVDsPNS1tXsGsybzt58KGeSGPVrjDg7k7AKid17ck
        YSfjlimPZlqQVq160xLk40LG2McMa5o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-308-gCRcGiQeOnexxGQkUEmBoQ-1; Thu, 23 Mar 2023 15:26:12 -0400
X-MC-Unique: gCRcGiQeOnexxGQkUEmBoQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C61AC101A551;
        Thu, 23 Mar 2023 19:26:11 +0000 (UTC)
Received: from localhost (unknown [10.39.192.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C1F2492B00;
        Thu, 23 Mar 2023 19:26:10 +0000 (UTC)
Date:   Thu, 23 Mar 2023 15:26:06 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Sam Li <faithilikerun@gmail.com>
Cc:     qemu-devel@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
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
Message-ID: <20230323192606.GC1459474@fedora>
References: <20230323052828.6545-1-faithilikerun@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VlHdNbAuf4pi85d6"
Content-Disposition: inline
In-Reply-To: <20230323052828.6545-1-faithilikerun@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--VlHdNbAuf4pi85d6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 23, 2023 at 01:28:24PM +0800, Sam Li wrote:
> This patch adds zoned storage emulation to the virtio-blk driver.
>=20
> The patch implements the virtio-blk ZBD support standardization that is
> recently accepted by virtio-spec. The link to related commit is at
>=20
> https://github.com/oasis-tcs/virtio-spec/commit/b4e8efa0fa6c8d844328090ad=
15db65af8d7d981
>=20
> The Linux zoned device code that implemented by Dmitry Fomichev has been
> released at the latest Linux version v6.3-rc1.
>=20
> Aside: adding zoned=3Don alike options to virtio-blk device will be
> considered in following-up plan.
>=20
> v7:
> - address Stefan's review comments
>   * rm aio_context_acquire/release in handle_req
>   * rename function return type
>   * rename BLOCK_ACCT_APPEND to BLOCK_ACCT_ZONE_APPEND for clarity
>=20
> v6:
> - update headers to v6.3-rc1
>=20
> v5:
> - address Stefan's review comments
>   * restore the way writing zone append result to buffer
>   * fix error checking case and other errands
>=20
> v4:
> - change the way writing zone append request result to buffer
> - change zone state, zone type value of virtio_blk_zone_descriptor
> - add trace events for new zone APIs
>=20
> v3:
> - use qemuio_from_buffer to write status bit [Stefan]
> - avoid using req->elem directly [Stefan]
> - fix error checkings and memory leak [Stefan]
>=20
> v2:
> - change units of emulated zone op coresponding to block layer APIs
> - modify error checking cases [Stefan, Damien]
>=20
> v1:
> - add zoned storage emulation
>=20
> Sam Li (4):
>   include: update virtio_blk headers to v6.3-rc1
>   virtio-blk: add zoned storage emulation for zoned devices
>   block: add accounting for zone append operation
>   virtio-blk: add some trace events for zoned emulation
>=20
>  block/qapi-sysemu.c                          |  11 +
>  block/qapi.c                                 |  18 +
>  hw/block/trace-events                        |   7 +
>  hw/block/virtio-blk-common.c                 |   2 +
>  hw/block/virtio-blk.c                        | 405 +++++++++++++++++++
>  include/block/accounting.h                   |   1 +
>  include/standard-headers/drm/drm_fourcc.h    |  12 +
>  include/standard-headers/linux/ethtool.h     |  48 ++-
>  include/standard-headers/linux/fuse.h        |  45 ++-
>  include/standard-headers/linux/pci_regs.h    |   1 +
>  include/standard-headers/linux/vhost_types.h |   2 +
>  include/standard-headers/linux/virtio_blk.h  | 105 +++++
>  linux-headers/asm-arm64/kvm.h                |   1 +
>  linux-headers/asm-x86/kvm.h                  |  34 +-
>  linux-headers/linux/kvm.h                    |   9 +
>  linux-headers/linux/vfio.h                   |  15 +-
>  linux-headers/linux/vhost.h                  |   8 +
>  qapi/block-core.json                         |  62 ++-
>  qapi/block.json                              |   4 +
>  19 files changed, 769 insertions(+), 21 deletions(-)
>=20
> --=20
> 2.39.2
>=20

I'll wait for the next version that addresses the comments before
merging, but I'm happy now:

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--VlHdNbAuf4pi85d6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmQcp84ACgkQnKSrs4Gr
c8g4UAf/YczhvgKugimmks/W5zbaTFNrJl2o6G6OynIa4pA1Z/FkCf2tieEPgzFr
0NWqI74TMpliuCw4Dm+2TfpgBNP247L7Lj5eh2VtaAmQLoPZChiLMLrkvDpaKnSl
n+ljqlIugVSkAQ1UmclbVevs8clpRZLtnHSJMGhxg8e94kTsBhaDbTQ4NwMFHpm4
/jElxzOz96EcvLtDDYsS5f16FMtckT7+Zs2BtfsIP2sOvcEIRv0Z9UhyT7kQ7kjr
m0GTo7zLBvHO5rS3XwWk+AgxwEbUpPBSC7rZYJxm4GNMBhSL/9PchkB2bz8amddD
spwoblkOewD1GJJk+JCGBuNwiMYMaQ==
=bM1F
-----END PGP SIGNATURE-----

--VlHdNbAuf4pi85d6--

