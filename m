Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29A536DC733
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 15:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjDJNOS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 09:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjDJNOS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 09:14:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735A286A8
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 06:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681132407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rVq4rLpOqMxQg/zoPqfstsjr4bU27Vqu2lYJG9JB7Jg=;
        b=Neer2J3iYZ4552VS85GhInGOGI8fhazFMMwgND05k+355SZAPrer7WLVW4Mm9DmLiDoL+n
        ZMvTrSwyuyic8xSJ3YM0kdKMDbL6gPOlFmzwgQ2giAPRK8bjspQoWsyf2dxTF1w9bDC9qE
        zNF3mynj5O7mG8DvycZyqzn2gX+TlaI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-110-mEMg47PaMB6eyEL48codSQ-1; Mon, 10 Apr 2023 09:13:24 -0400
X-MC-Unique: mEMg47PaMB6eyEL48codSQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D92E52A5956A;
        Mon, 10 Apr 2023 13:13:23 +0000 (UTC)
Received: from localhost (unknown [10.39.192.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 62A8A492B00;
        Mon, 10 Apr 2023 13:13:23 +0000 (UTC)
Date:   Mon, 10 Apr 2023 09:13:22 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Sam Li <faithilikerun@gmail.com>
Cc:     qemu-devel@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        damien.lemoal@opensource.wdc.com, qemu-block@nongnu.org,
        Eric Blake <eblake@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, hare@suse.de,
        "Michael S. Tsirkin" <mst@redhat.com>, dmitry.fomichev@wdc.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH v10 0/5] Add zoned storage emulation to virtio-blk driver
Message-ID: <20230410131322.GD888305@fedora>
References: <20230407082528.18841-1-faithilikerun@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="pO7awKOZ8/9N5zcX"
Content-Disposition: inline
In-Reply-To: <20230407082528.18841-1-faithilikerun@gmail.com>
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


--pO7awKOZ8/9N5zcX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 07, 2023 at 04:25:23PM +0800, Sam Li wrote:
> This patch adds zoned storage emulation to the virtio-blk driver. It
> implements the virtio-blk ZBD support standardization that is
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
> v10:
> - adapt to the latest zone-append patches: rename bs->bl.wps to bs->wps
>=20
> v9:
> - address review comments
>   * add docs for zoned emulation use case [Matias]
>   * add the zoned feature bit to qmp monitor [Matias]
>   * add the version number for newly added configs of accounting [Markus]
>=20
> v8:
> - address Stefan's review comments
>   * rm aio_context_acquire/release in handle_req
>   * rename function return type
>   * rename BLOCK_ACCT_APPEND to BLOCK_ACCT_ZONE_APPEND for clarity
>=20
> v7:
> - update headers to v6.3-rc1
>=20
> v6:
> - address Stefan's review comments
>   * add accounting for zone append operation
>   * fix in_iov usage in handle_request, error handling and typos
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
> Sam Li (5):
>   include: update virtio_blk headers to v6.3-rc1
>   virtio-blk: add zoned storage emulation for zoned devices
>   block: add accounting for zone append operation
>   virtio-blk: add some trace events for zoned emulation
>   docs/zoned-storage:add zoned emulation use case
>=20
>  block/qapi-sysemu.c                          |  11 +
>  block/qapi.c                                 |  18 +
>  docs/devel/zoned-storage.rst                 |  17 +
>  hw/block/trace-events                        |   7 +
>  hw/block/virtio-blk-common.c                 |   2 +
>  hw/block/virtio-blk.c                        | 405 +++++++++++++++++++
>  hw/virtio/virtio-qmp.c                       |   2 +
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
>  qapi/block-core.json                         |  68 +++-
>  qapi/block.json                              |   4 +
>  21 files changed, 794 insertions(+), 21 deletions(-)
>=20
> --=20
> 2.39.2
>=20

Thanks, applied to my block-next tree:
https://gitlab.com/stefanha/qemu/commits/block-next

Stefan

--pO7awKOZ8/9N5zcX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmQ0C3EACgkQnKSrs4Gr
c8hUTgf+MvSIhNQHcki7xIgGAulx4dPt6u2vKFB204hIxHFAsmuickp7ysM2/Qd/
irPT2aOG/e7ixAdAfy18wF8+mRTuTWixcwXgRY8GYeKm8Q7gb9ydl0/BKBvuQvNp
FDXkG2ZemWyIbHDcOaGo2TH6FJIWlJWkFh7qL9APdJ7p3fpmX6sQs4RWoPhcFYr/
4PWmzXOaR/xyE7SYMmH8DpsDPPnPRNLfQmVN7kupvOX0tHRlC26Tg4maYZmrbXAd
143PcfarjYYwe9BZ4Yo+T0eKnVMdbg3kugEMgBTvgFmy0UR074NrWFV/lZSAQDB+
vwV7SfBWVh4tUdZ+eQsk9efxLT5HJA==
=SfKn
-----END PGP SIGNATURE-----

--pO7awKOZ8/9N5zcX--

