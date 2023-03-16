Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A50266BD97D
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 20:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbjCPTrm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 15:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCPTri (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 15:47:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E2F96C36
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 12:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678996009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pSi9BU5t5+b1e70Ga6k0+oHbCW1i4ecI0TLSimZHflo=;
        b=EFc2VS9y0ioiZMyN3Mr82Iz4vQTVLogZF2Z0N3giPS7KkeeK/9/t2T0AJ9nt40dSKd5vGY
        cJT5YOt8Hhoy+Jk3sqtrlBk3AilJM74uFJtoXmauDZltq8/C/oM8a+g6biMNrG63LUp5rD
        tEb3wTLo1Lp+80w/e49T+wmpRI+3Yhs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-543-Wfz-znq_MWi9-VP3IQAgQg-1; Thu, 16 Mar 2023 15:46:47 -0400
X-MC-Unique: Wfz-znq_MWi9-VP3IQAgQg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1342085A5B1;
        Thu, 16 Mar 2023 19:46:47 +0000 (UTC)
Received: from localhost (unknown [10.39.192.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E49C140EBF4;
        Thu, 16 Mar 2023 19:46:46 +0000 (UTC)
Date:   Thu, 16 Mar 2023 15:19:08 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Sam Li <faithilikerun@gmail.com>
Cc:     qemu-devel@nongnu.org, damien.lemoal@opensource.wdc.com,
        Hanna Reitz <hreitz@redhat.com>, hare@suse.de,
        qemu-block@nongnu.org, Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, dmitry.fomichev@wdc.com,
        Cornelia Huck <cohuck@redhat.com>,
        Markus Armbruster <armbru@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>
Subject: Re: [PATCH v7 2/4] virtio-blk: add zoned storage emulation for zoned
 devices
Message-ID: <20230316191908.GE63600@fedora>
References: <20230310105431.64271-1-faithilikerun@gmail.com>
 <20230310105431.64271-3-faithilikerun@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LV+jRK6iF/cgRhcX"
Content-Disposition: inline
In-Reply-To: <20230310105431.64271-3-faithilikerun@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--LV+jRK6iF/cgRhcX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 10, 2023 at 06:54:29PM +0800, Sam Li wrote:
> This patch extends virtio-blk emulation to handle zoned device commands
> by calling the new block layer APIs to perform zoned device I/O on
> behalf of the guest. It supports Report Zone, four zone oparations (open,
> close, finish, reset), and Append Zone.
>=20
> The VIRTIO_BLK_F_ZONED feature bit will only be set if the host does
> support zoned block devices. Regular block devices(conventional zones)
> will not be set.
>=20
> The guest os can use blktests, fio to test those commands on zoned device=
s.
> Furthermore, using zonefs to test zone append write is also supported.
>=20
> Signed-off-by: Sam Li <faithilikerun@gmail.com>
> ---
>  hw/block/virtio-blk-common.c |   2 +
>  hw/block/virtio-blk.c        | 394 +++++++++++++++++++++++++++++++++++
>  2 files changed, 396 insertions(+)
>=20
> diff --git a/hw/block/virtio-blk-common.c b/hw/block/virtio-blk-common.c
> index ac52d7c176..e2f8e2f6da 100644
> --- a/hw/block/virtio-blk-common.c
> +++ b/hw/block/virtio-blk-common.c
> @@ -29,6 +29,8 @@ static const VirtIOFeature feature_sizes[] =3D {
>       .end =3D endof(struct virtio_blk_config, discard_sector_alignment)},
>      {.flags =3D 1ULL << VIRTIO_BLK_F_WRITE_ZEROES,
>       .end =3D endof(struct virtio_blk_config, write_zeroes_may_unmap)},
> +    {.flags =3D 1ULL << VIRTIO_BLK_F_ZONED,
> +     .end =3D endof(struct virtio_blk_config, zoned)},
>      {}
>  };
> =20
> diff --git a/hw/block/virtio-blk.c b/hw/block/virtio-blk.c
> index cefca93b31..4ded625732 100644
> --- a/hw/block/virtio-blk.c
> +++ b/hw/block/virtio-blk.c
> @@ -17,6 +17,7 @@
>  #include "qemu/module.h"
>  #include "qemu/error-report.h"
>  #include "qemu/main-loop.h"
> +#include "block/block_int.h"
>  #include "trace.h"
>  #include "hw/block/block.h"
>  #include "hw/qdev-properties.h"
> @@ -601,6 +602,341 @@ err:
>      return err_status;
>  }
> =20
> +typedef struct ZoneCmdData {
> +    VirtIOBlockReq *req;
> +    struct iovec *in_iov;
> +    unsigned in_num;
> +    union {
> +        struct {
> +            unsigned int nr_zones;
> +            BlockZoneDescriptor *zones;
> +        } zone_report_data;
> +        struct {
> +            int64_t offset;
> +        } zone_append_data;
> +    };
> +} ZoneCmdData;
> +
> +/*
> + * check zoned_request: error checking before issuing requests. If all c=
hecks
> + * passed, return true.
> + * append: true if only zone append requests issued.
> + */
> +static bool check_zoned_request(VirtIOBlock *s, int64_t offset, int64_t =
len,
> +                             bool append, uint8_t *status) {
> +    BlockDriverState *bs =3D blk_bs(s->blk);
> +    int index;
> +
> +    if (!virtio_has_feature(s->host_features, VIRTIO_BLK_F_ZONED)) {
> +        *status =3D VIRTIO_BLK_S_UNSUPP;
> +        return false;
> +    }
> +
> +    if (offset < 0 || len < 0 || len > (bs->total_sectors << BDRV_SECTOR=
_BITS)
> +        || offset > (bs->total_sectors << BDRV_SECTOR_BITS) - len) {
> +        *status =3D VIRTIO_BLK_S_ZONE_INVALID_CMD;
> +        return false;
> +    }
> +
> +    if (append) {
> +        if (bs->bl.write_granularity) {
> +            if ((offset % bs->bl.write_granularity) !=3D 0) {
> +                *status =3D VIRTIO_BLK_S_ZONE_UNALIGNED_WP;
> +                return false;
> +            }
> +        }
> +
> +        index =3D offset / bs->bl.zone_size;
> +        if (BDRV_ZT_IS_CONV(bs->bl.wps->wp[index])) {
> +            *status =3D VIRTIO_BLK_S_ZONE_INVALID_CMD;
> +            return false;
> +        }
> +
> +        if (len / 512 > bs->bl.max_append_sectors) {
> +            if (bs->bl.max_append_sectors =3D=3D 0) {
> +                *status =3D VIRTIO_BLK_S_UNSUPP;
> +            } else {
> +                *status =3D VIRTIO_BLK_S_ZONE_INVALID_CMD;
> +            }
> +            return false;
> +        }
> +    }
> +    return true;
> +}
> +
> +static void virtio_blk_zone_report_complete(void *opaque, int ret)
> +{
> +    ZoneCmdData *data =3D opaque;
> +    VirtIOBlockReq *req =3D data->req;
> +    VirtIOBlock *s =3D req->dev;
> +    VirtIODevice *vdev =3D VIRTIO_DEVICE(req->dev);
> +    struct iovec *in_iov =3D data->in_iov;
> +    unsigned in_num =3D data->in_num;
> +    int64_t zrp_size, n, j =3D 0;
> +    int64_t nz =3D data->zone_report_data.nr_zones;
> +    int8_t err_status =3D VIRTIO_BLK_S_OK;
> +
> +    if (ret) {
> +        err_status =3D VIRTIO_BLK_S_ZONE_INVALID_CMD;
> +        goto out;
> +    }
> +
> +    struct virtio_blk_zone_report zrp_hdr =3D (struct virtio_blk_zone_re=
port) {
> +            .nr_zones =3D cpu_to_le64(nz),

Indentation is off. QEMU uses 4-space indentation.

> +    };
> +    zrp_size =3D sizeof(struct virtio_blk_zone_report)
> +               + sizeof(struct virtio_blk_zone_descriptor) * nz;
> +    n =3D iov_from_buf(in_iov, in_num, 0, &zrp_hdr, sizeof(zrp_hdr));
> +    if (n !=3D sizeof(zrp_hdr)) {
> +        virtio_error(vdev, "Driver provided input buffer that is too sma=
ll!");
> +        err_status =3D VIRTIO_BLK_S_ZONE_INVALID_CMD;
> +        goto out;
> +    }
> +
> +    for (size_t i =3D sizeof(zrp_hdr); i < zrp_size;
> +        i +=3D sizeof(struct virtio_blk_zone_descriptor), ++j) {
> +        struct virtio_blk_zone_descriptor desc =3D
> +            (struct virtio_blk_zone_descriptor) {
> +                .z_start =3D cpu_to_le64(data->zone_report_data.zones[j]=
=2Estart
> +                    >> BDRV_SECTOR_BITS),
> +                .z_cap =3D cpu_to_le64(data->zone_report_data.zones[j].c=
ap
> +                    >> BDRV_SECTOR_BITS),
> +                .z_wp =3D cpu_to_le64(data->zone_report_data.zones[j].wp
> +                    >> BDRV_SECTOR_BITS),
> +        };
> +
> +        switch (data->zone_report_data.zones[j].type) {
> +        case BLK_ZT_CONV:
> +            desc.z_type =3D VIRTIO_BLK_ZT_CONV;
> +            break;
> +        case BLK_ZT_SWR:
> +            desc.z_type =3D VIRTIO_BLK_ZT_SWR;
> +            break;
> +        case BLK_ZT_SWP:
> +            desc.z_type =3D VIRTIO_BLK_ZT_SWP;
> +            break;
> +        default:
> +            g_assert_not_reached();
> +        }
> +
> +        switch (data->zone_report_data.zones[j].state) {
> +        case BLK_ZS_RDONLY:
> +            desc.z_state =3D VIRTIO_BLK_ZS_RDONLY;
> +            break;
> +        case BLK_ZS_OFFLINE:
> +            desc.z_state =3D VIRTIO_BLK_ZS_OFFLINE;
> +            break;
> +        case BLK_ZS_EMPTY:
> +            desc.z_state =3D VIRTIO_BLK_ZS_EMPTY;
> +            break;
> +        case BLK_ZS_CLOSED:
> +            desc.z_state =3D VIRTIO_BLK_ZS_CLOSED;
> +            break;
> +        case BLK_ZS_FULL:
> +            desc.z_state =3D VIRTIO_BLK_ZS_FULL;
> +            break;
> +        case BLK_ZS_EOPEN:
> +            desc.z_state =3D VIRTIO_BLK_ZS_EOPEN;
> +            break;
> +        case BLK_ZS_IOPEN:
> +            desc.z_state =3D VIRTIO_BLK_ZS_IOPEN;
> +            break;
> +        case BLK_ZS_NOT_WP:
> +            desc.z_state =3D VIRTIO_BLK_ZS_NOT_WP;
> +            break;
> +        default:
> +            g_assert_not_reached();
> +        }
> +
> +        /* TODO: it takes O(n^2) time complexity. Optimizations required=
=2E */
> +        n =3D iov_from_buf(in_iov, in_num, i, &desc, sizeof(desc));
> +        if (n !=3D sizeof(desc)) {
> +            virtio_error(vdev, "Driver provided input buffer "
> +                               "for descriptors that is too small!");
> +            err_status =3D VIRTIO_BLK_S_ZONE_INVALID_CMD;
> +        }
> +    }
> +
> +out:
> +    aio_context_acquire(blk_get_aio_context(s->conf.conf.blk));
> +    virtio_blk_req_complete(req, err_status);
> +    virtio_blk_free_request(req);
> +    aio_context_release(blk_get_aio_context(s->conf.conf.blk));
> +    g_free(data->zone_report_data.zones);
> +    g_free(data);
> +}
> +
> +static int virtio_blk_handle_zone_report(VirtIOBlockReq *req,
> +                                         struct iovec *in_iov,
> +                                         unsigned in_num)
> +{
> +    VirtIOBlock *s =3D req->dev;
> +    VirtIODevice *vdev =3D VIRTIO_DEVICE(s);
> +    unsigned int nr_zones;
> +    ZoneCmdData *data;
> +    int64_t zone_size, offset;
> +    uint8_t err_status;
> +
> +    if (req->in_len < sizeof(struct virtio_blk_inhdr) +
> +            sizeof(struct virtio_blk_zone_report) +
> +            sizeof(struct virtio_blk_zone_descriptor)) {
> +        virtio_error(vdev, "in buffer too small for zone report");
> +        return -1;

The return value is unused. Maybe this function should return void?

> +    }
> +
> +    /* start byte offset of the zone report */
> +    offset =3D virtio_ldq_p(vdev, &req->out.sector) << BDRV_SECTOR_BITS;
> +    if (!check_zoned_request(s, offset, 0, false, &err_status)) {
> +        goto out;
> +    }
> +    nr_zones =3D (req->in_len - sizeof(struct virtio_blk_inhdr) -
> +                sizeof(struct virtio_blk_zone_report)) /
> +               sizeof(struct virtio_blk_zone_descriptor);
> +
> +    zone_size =3D sizeof(BlockZoneDescriptor) * nr_zones;
> +    data =3D g_malloc(sizeof(ZoneCmdData));
> +    data->req =3D req;
> +    data->in_iov =3D in_iov;
> +    data->in_num =3D in_num;
> +    data->zone_report_data.nr_zones =3D nr_zones;
> +    data->zone_report_data.zones =3D g_malloc(zone_size),
> +
> +    blk_aio_zone_report(s->blk, offset, &data->zone_report_data.nr_zones,
> +                        data->zone_report_data.zones,
> +                        virtio_blk_zone_report_complete, data);
> +    return 0;
> +
> +out:
> +    aio_context_acquire(blk_get_aio_context(s->conf.conf.blk));

aio_context_acquire/release() is not needed here because the lock is
already held by the caller.

> +    virtio_blk_req_complete(req, err_status);
> +    virtio_blk_free_request(req);
> +    aio_context_release(blk_get_aio_context(s->conf.conf.blk));
> +    return err_status;
> +}
> +
> +static void virtio_blk_zone_mgmt_complete(void *opaque, int ret)
> +{
> +    VirtIOBlockReq *req =3D opaque;
> +    VirtIOBlock *s =3D req->dev;
> +    int8_t err_status =3D VIRTIO_BLK_S_OK;
> +
> +    if (ret) {
> +        err_status =3D VIRTIO_BLK_S_ZONE_INVALID_CMD;
> +    }
> +
> +    aio_context_acquire(blk_get_aio_context(s->conf.conf.blk));
> +    virtio_blk_req_complete(req, err_status);
> +    virtio_blk_free_request(req);
> +    aio_context_release(blk_get_aio_context(s->conf.conf.blk));
> +}
> +
> +static int virtio_blk_handle_zone_mgmt(VirtIOBlockReq *req, BlockZoneOp =
op)
> +{
> +    VirtIOBlock *s =3D req->dev;
> +    VirtIODevice *vdev =3D VIRTIO_DEVICE(s);
> +    BlockDriverState *bs =3D blk_bs(s->blk);
> +    int64_t offset =3D virtio_ldq_p(vdev, &req->out.sector) << BDRV_SECT=
OR_BITS;
> +    uint64_t len;
> +    uint64_t capacity =3D bs->total_sectors << BDRV_SECTOR_BITS;
> +    uint8_t err_status =3D VIRTIO_BLK_S_OK;
> +
> +    uint32_t type =3D virtio_ldl_p(vdev, &req->out.type);
> +    if (type =3D=3D VIRTIO_BLK_T_ZONE_RESET_ALL) {
> +        /* Entire drive capacity */
> +        offset =3D 0;
> +        len =3D capacity;
> +    } else {
> +        if (bs->bl.zone_size > capacity - offset) {
> +            /* The zoned device allows the last smaller zone. */
> +            len =3D capacity - bs->bl.zone_size * (bs->bl.nr_zones - 1);
> +        } else {
> +            len =3D bs->bl.zone_size;
> +        }
> +    }
> +
> +    if (!check_zoned_request(s, offset, len, false, &err_status)) {
> +        goto out;
> +    }
> +
> +    blk_aio_zone_mgmt(s->blk, op, offset, len,
> +                      virtio_blk_zone_mgmt_complete, req);
> +
> +    return 0;
> +out:
> +    aio_context_acquire(blk_get_aio_context(s->conf.conf.blk));

aio_context_acquire/release() is not needed here because the lock is
already held by the caller.

> +    virtio_blk_req_complete(req, err_status);
> +    virtio_blk_free_request(req);
> +    aio_context_release(blk_get_aio_context(s->conf.conf.blk));
> +    return err_status;

The return value is unused. Maybe this function should return void?

> +}
> +
> +static void virtio_blk_zone_append_complete(void *opaque, int ret)
> +{
> +    ZoneCmdData *data =3D opaque;
> +    VirtIOBlockReq *req =3D data->req;
> +    VirtIOBlock *s =3D req->dev;
> +    VirtIODevice *vdev =3D VIRTIO_DEVICE(req->dev);
> +    int64_t append_sector, n;
> +    uint8_t err_status =3D VIRTIO_BLK_S_OK;
> +
> +    if (ret) {
> +        err_status =3D VIRTIO_BLK_S_ZONE_INVALID_CMD;
> +        goto out;
> +    }
> +
> +    virtio_stq_p(vdev, &append_sector,
> +                 data->zone_append_data.offset >> BDRV_SECTOR_BITS);
> +    n =3D iov_from_buf(data->in_iov, data->in_num, 0, &append_sector,
> +                     sizeof(append_sector));
> +    if (n !=3D sizeof(append_sector)) {
> +        virtio_error(vdev, "Driver provided input buffer less than size =
of "
> +                           "append_sector");
> +        err_status =3D VIRTIO_BLK_S_ZONE_INVALID_CMD;
> +        goto out;
> +    }
> +
> +out:
> +    aio_context_acquire(blk_get_aio_context(s->conf.conf.blk));
> +    virtio_blk_req_complete(req, err_status);
> +    virtio_blk_free_request(req);
> +    aio_context_release(blk_get_aio_context(s->conf.conf.blk));
> +    g_free(data);
> +}
> +
> +static int virtio_blk_handle_zone_append(VirtIOBlockReq *req,
> +                                         struct iovec *out_iov,
> +                                         struct iovec *in_iov,
> +                                         uint64_t out_num,
> +                                         unsigned in_num) {
> +    VirtIOBlock *s =3D req->dev;
> +    VirtIODevice *vdev =3D VIRTIO_DEVICE(s);
> +    uint8_t err_status =3D VIRTIO_BLK_S_OK;
> +
> +    int64_t offset =3D virtio_ldq_p(vdev, &req->out.sector) << BDRV_SECT=
OR_BITS;
> +    int64_t len =3D iov_size(out_iov, out_num);
> +
> +    if (!check_zoned_request(s, offset, len, true, &err_status)) {
> +        goto out;
> +    }
> +
> +    ZoneCmdData *data =3D g_malloc(sizeof(ZoneCmdData));
> +    data->req =3D req;
> +    data->in_iov =3D in_iov;
> +    data->in_num =3D in_num;
> +    data->zone_append_data.offset =3D offset;
> +    qemu_iovec_init_external(&req->qiov, out_iov, out_num);
> +    blk_aio_zone_append(s->blk, &data->zone_append_data.offset, &req->qi=
ov, 0,
> +                        virtio_blk_zone_append_complete, data);
> +    return 0;
> +
> +out:
> +    aio_context_acquire(blk_get_aio_context(s->conf.conf.blk));

aio_context_acquire/release() are not necessary in functions called from
virtio_blk_handle_request() because the lock is already acquired. It's
only needed in callback functions (from aio APIs or QEMUBH).

> +    virtio_blk_req_complete(req, err_status);
> +    virtio_blk_free_request(req);
> +    aio_context_release(blk_get_aio_context(s->conf.conf.blk));
> +    return err_status;

The return value is unused. Maybe this function should return void?

> +}
> +
>  static int virtio_blk_handle_request(VirtIOBlockReq *req, MultiReqBuffer=
 *mrb)
>  {
>      uint32_t type;
> @@ -687,6 +1023,24 @@ static int virtio_blk_handle_request(VirtIOBlockReq=
 *req, MultiReqBuffer *mrb)
>      case VIRTIO_BLK_T_FLUSH:
>          virtio_blk_handle_flush(req, mrb);
>          break;
> +    case VIRTIO_BLK_T_ZONE_REPORT:
> +        virtio_blk_handle_zone_report(req, in_iov, in_num);
> +        break;
> +    case VIRTIO_BLK_T_ZONE_OPEN:
> +        virtio_blk_handle_zone_mgmt(req, BLK_ZO_OPEN);
> +        break;
> +    case VIRTIO_BLK_T_ZONE_CLOSE:
> +        virtio_blk_handle_zone_mgmt(req, BLK_ZO_CLOSE);
> +        break;
> +    case VIRTIO_BLK_T_ZONE_FINISH:
> +        virtio_blk_handle_zone_mgmt(req, BLK_ZO_FINISH);
> +        break;
> +    case VIRTIO_BLK_T_ZONE_RESET:
> +        virtio_blk_handle_zone_mgmt(req, BLK_ZO_RESET);
> +        break;
> +    case VIRTIO_BLK_T_ZONE_RESET_ALL:
> +        virtio_blk_handle_zone_mgmt(req, BLK_ZO_RESET);
> +        break;
>      case VIRTIO_BLK_T_SCSI_CMD:
>          virtio_blk_handle_scsi(req);
>          break;
> @@ -705,6 +1059,13 @@ static int virtio_blk_handle_request(VirtIOBlockReq=
 *req, MultiReqBuffer *mrb)
>          virtio_blk_free_request(req);
>          break;
>      }
> +    case VIRTIO_BLK_T_ZONE_APPEND & ~VIRTIO_BLK_T_OUT:
> +        /*
> +         * It is not safe to access req->elem.out_sg directly because it
> +         * may be modified by virtio_blk_handle_request().
> +         */

Please prefix this with "Pass out_iov/out_num and in_iov/in_num, " to
make this comment clearer.

> +        virtio_blk_handle_zone_append(req, out_iov, in_iov, out_num, in_=
num);
> +        break;
>      /*
>       * VIRTIO_BLK_T_DISCARD and VIRTIO_BLK_T_WRITE_ZEROES are defined wi=
th
>       * VIRTIO_BLK_T_OUT flag set. We masked this flag in the switch stat=
ement,
> @@ -890,6 +1251,7 @@ static void virtio_blk_update_config(VirtIODevice *v=
dev, uint8_t *config)
>  {
>      VirtIOBlock *s =3D VIRTIO_BLK(vdev);
>      BlockConf *conf =3D &s->conf.conf;
> +    BlockDriverState *bs =3D blk_bs(s->blk);
>      struct virtio_blk_config blkcfg;
>      uint64_t capacity;
>      int64_t length;
> @@ -954,6 +1316,30 @@ static void virtio_blk_update_config(VirtIODevice *=
vdev, uint8_t *config)
>          blkcfg.write_zeroes_may_unmap =3D 1;
>          virtio_stl_p(vdev, &blkcfg.max_write_zeroes_seg, 1);
>      }
> +    if (bs->bl.zoned !=3D BLK_Z_NONE) {
> +        switch (bs->bl.zoned) {
> +        case BLK_Z_HM:
> +            blkcfg.zoned.model =3D VIRTIO_BLK_Z_HM;
> +            break;
> +        case BLK_Z_HA:
> +            blkcfg.zoned.model =3D VIRTIO_BLK_Z_HA;
> +            break;
> +        default:
> +            g_assert_not_reached();
> +        }
> +
> +        virtio_stl_p(vdev, &blkcfg.zoned.zone_sectors,
> +                     bs->bl.zone_size / 512);
> +        virtio_stl_p(vdev, &blkcfg.zoned.max_active_zones,
> +                     bs->bl.max_active_zones);
> +        virtio_stl_p(vdev, &blkcfg.zoned.max_open_zones,
> +                     bs->bl.max_open_zones);
> +        virtio_stl_p(vdev, &blkcfg.zoned.write_granularity, blk_size);
> +        virtio_stl_p(vdev, &blkcfg.zoned.max_append_sectors,
> +                     bs->bl.max_append_sectors);
> +    } else {
> +        blkcfg.zoned.model =3D VIRTIO_BLK_Z_NONE;
> +    }
>      memcpy(config, &blkcfg, s->config_size);
>  }
> =20
> @@ -1118,6 +1504,7 @@ static void virtio_blk_device_realize(DeviceState *=
dev, Error **errp)
>      VirtIODevice *vdev =3D VIRTIO_DEVICE(dev);
>      VirtIOBlock *s =3D VIRTIO_BLK(dev);
>      VirtIOBlkConf *conf =3D &s->conf;
> +    BlockDriverState *bs =3D blk_bs(conf->conf.blk);
>      Error *err =3D NULL;
>      unsigned i;
> =20
> @@ -1163,6 +1550,13 @@ static void virtio_blk_device_realize(DeviceState =
*dev, Error **errp)
>          return;
>      }
> =20
> +    if (bs->bl.zoned !=3D BLK_Z_NONE) {
> +        virtio_add_feature(&s->host_features, VIRTIO_BLK_F_ZONED);
> +        if (bs->bl.zoned =3D=3D BLK_Z_HM) {
> +            virtio_clear_feature(&s->host_features, VIRTIO_BLK_F_DISCARD=
);
> +        }
> +    }
> +
>      if (virtio_has_feature(s->host_features, VIRTIO_BLK_F_DISCARD) &&
>          (!conf->max_discard_sectors ||
>           conf->max_discard_sectors > BDRV_REQUEST_MAX_SECTORS)) {
> --=20
> 2.39.2
>=20

--LV+jRK6iF/cgRhcX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmQTa6wACgkQnKSrs4Gr
c8gTaAgAmS4CgqC0pYfI09mWNtVmXceYBmqNKmd5QB8By13WW88EbvZm4Bkbd2CX
GySJLF+LSu4HyD277QXDkdFR4oLCAVVC/jb/IGIr78UCvA4uqaqaS3bvDLSjhGgO
QCjUgJz0rtZUdn+C/C2LZ42Ma5RpsYr9L0x3H+Dt5oibRPgDFZ0tCNEZbO3Azkez
+ojfsBfywiVtbhNbdlpFCeCcIl2+27HR1567uResMkBoPuoELe+6q8d0Dm/OH9Pf
3LRIjyvbpOz3r4qA+DKtitkuoyClENLHpGnNSkqOTpL/l9HcfiqUP5Z11j34J4el
ZR7pA5OnS2TB34OM3IYUGr1dFaQ7oA==
=N0B1
-----END PGP SIGNATURE-----

--LV+jRK6iF/cgRhcX--

