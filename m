Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45E5E6BD97E
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 20:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjCPTro (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 15:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCPTrm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 15:47:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53154C6E3
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 12:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678996014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MuYfOoLcjU5JGlUlEXyNqLNR/9nWq4KpdlO0Weadc9o=;
        b=DP6bpqG4aIIKI9q+PCBC0A11rprsDKgqvIwvbMAsPDip3kF8o2m/k5xqVdxxQZWELh9EOv
        Y+MIBJxBvJUv5PytGUXNktH8M+svgCtv83lhwSXqvqRty4ek9mQ1Ntve+mJN2dHD7WLvM5
        oQo9K2BThvwh8Omjz0Wk4jfKP8UT2Fs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-463-68I3kDLEMtyYAHBrKCGDXw-1; Thu, 16 Mar 2023 15:46:50 -0400
X-MC-Unique: 68I3kDLEMtyYAHBrKCGDXw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A706C811E7B;
        Thu, 16 Mar 2023 19:46:49 +0000 (UTC)
Received: from localhost (unknown [10.39.192.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C71DB492B00;
        Thu, 16 Mar 2023 19:46:48 +0000 (UTC)
Date:   Thu, 16 Mar 2023 15:23:41 -0400
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
Subject: Re: [PATCH v7 3/4] block: add accounting for zone append operation
Message-ID: <20230316192341.GF63600@fedora>
References: <20230310105431.64271-1-faithilikerun@gmail.com>
 <20230310105431.64271-4-faithilikerun@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="TtnxWzeXoIXHp1d0"
Content-Disposition: inline
In-Reply-To: <20230310105431.64271-4-faithilikerun@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--TtnxWzeXoIXHp1d0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 10, 2023 at 06:54:30PM +0800, Sam Li wrote:
> Taking account of the new zone append write operation for zoned devices,
> BLOCK_ACCT_APPEND enum is introduced as other I/O request type (read,
> write, flush).

Can it be called BLOCK_ACCT_ZONE_APPEND so it's clear that this
operation is specific to zoned devices? I think people might not make
the connection if they just see "append" and think that regular devices
support this operation.

>=20
> Signed-off-by: Sam Li <faithilikerun@gmail.com>
> ---
>  block/qapi-sysemu.c        | 11 ++++++++
>  block/qapi.c               | 15 ++++++++++
>  hw/block/virtio-blk.c      |  4 +++
>  include/block/accounting.h |  1 +
>  qapi/block-core.json       | 56 ++++++++++++++++++++++++++++++--------
>  qapi/block.json            |  4 +++
>  6 files changed, 80 insertions(+), 11 deletions(-)
>=20
> diff --git a/block/qapi-sysemu.c b/block/qapi-sysemu.c
> index 7bd7554150..f7e56dfeb2 100644
> --- a/block/qapi-sysemu.c
> +++ b/block/qapi-sysemu.c
> @@ -517,6 +517,7 @@ void qmp_block_latency_histogram_set(
>      bool has_boundaries, uint64List *boundaries,
>      bool has_boundaries_read, uint64List *boundaries_read,
>      bool has_boundaries_write, uint64List *boundaries_write,
> +    bool has_boundaries_append, uint64List *boundaries_append,
>      bool has_boundaries_flush, uint64List *boundaries_flush,
>      Error **errp)
>  {
> @@ -557,6 +558,16 @@ void qmp_block_latency_histogram_set(
>          }
>      }
> =20
> +    if (has_boundaries || has_boundaries_append) {
> +        ret =3D block_latency_histogram_set(
> +                stats, BLOCK_ACCT_APPEND,
> +                has_boundaries_append ? boundaries_append : boundaries);
> +        if (ret) {
> +            error_setg(errp, "Device '%s' set append write boundaries fa=
il", id);
> +            return;
> +        }
> +    }
> +
>      if (has_boundaries || has_boundaries_flush) {
>          ret =3D block_latency_histogram_set(
>              stats, BLOCK_ACCT_FLUSH,
> diff --git a/block/qapi.c b/block/qapi.c
> index c84147849d..d4be8ad72e 100644
> --- a/block/qapi.c
> +++ b/block/qapi.c
> @@ -533,27 +533,33 @@ static void bdrv_query_blk_stats(BlockDeviceStats *=
ds, BlockBackend *blk)
> =20
>      ds->rd_bytes =3D stats->nr_bytes[BLOCK_ACCT_READ];
>      ds->wr_bytes =3D stats->nr_bytes[BLOCK_ACCT_WRITE];
> +    ds->zap_bytes =3D stats->nr_bytes[BLOCK_ACCT_APPEND];

"zone_append_bytes" would be clearer. For a moment I thought "zap" is a
new operation. Since "zap" isn't used anywhere else, let's not introduce
a new name here.

>      ds->unmap_bytes =3D stats->nr_bytes[BLOCK_ACCT_UNMAP];
>      ds->rd_operations =3D stats->nr_ops[BLOCK_ACCT_READ];
>      ds->wr_operations =3D stats->nr_ops[BLOCK_ACCT_WRITE];
> +    ds->zap_operations =3D stats->nr_ops[BLOCK_ACCT_APPEND];
>      ds->unmap_operations =3D stats->nr_ops[BLOCK_ACCT_UNMAP];
> =20
>      ds->failed_rd_operations =3D stats->failed_ops[BLOCK_ACCT_READ];
>      ds->failed_wr_operations =3D stats->failed_ops[BLOCK_ACCT_WRITE];
> +    ds->failed_zap_operations =3D stats->failed_ops[BLOCK_ACCT_APPEND];
>      ds->failed_flush_operations =3D stats->failed_ops[BLOCK_ACCT_FLUSH];
>      ds->failed_unmap_operations =3D stats->failed_ops[BLOCK_ACCT_UNMAP];
> =20
>      ds->invalid_rd_operations =3D stats->invalid_ops[BLOCK_ACCT_READ];
>      ds->invalid_wr_operations =3D stats->invalid_ops[BLOCK_ACCT_WRITE];
> +    ds->invalid_zap_operations =3D stats->invalid_ops[BLOCK_ACCT_APPEND];
>      ds->invalid_flush_operations =3D
>          stats->invalid_ops[BLOCK_ACCT_FLUSH];
>      ds->invalid_unmap_operations =3D stats->invalid_ops[BLOCK_ACCT_UNMAP=
];
> =20
>      ds->rd_merged =3D stats->merged[BLOCK_ACCT_READ];
>      ds->wr_merged =3D stats->merged[BLOCK_ACCT_WRITE];
> +    ds->zap_merged =3D stats->merged[BLOCK_ACCT_APPEND];
>      ds->unmap_merged =3D stats->merged[BLOCK_ACCT_UNMAP];
>      ds->flush_operations =3D stats->nr_ops[BLOCK_ACCT_FLUSH];
>      ds->wr_total_time_ns =3D stats->total_time_ns[BLOCK_ACCT_WRITE];
> +    ds->zap_total_time_ns =3D stats->total_time_ns[BLOCK_ACCT_APPEND];
>      ds->rd_total_time_ns =3D stats->total_time_ns[BLOCK_ACCT_READ];
>      ds->flush_total_time_ns =3D stats->total_time_ns[BLOCK_ACCT_FLUSH];
>      ds->unmap_total_time_ns =3D stats->total_time_ns[BLOCK_ACCT_UNMAP];
> @@ -571,6 +577,7 @@ static void bdrv_query_blk_stats(BlockDeviceStats *ds=
, BlockBackend *blk)
> =20
>          TimedAverage *rd =3D &ts->latency[BLOCK_ACCT_READ];
>          TimedAverage *wr =3D &ts->latency[BLOCK_ACCT_WRITE];
> +        TimedAverage *zap =3D &ts->latency[BLOCK_ACCT_APPEND];
>          TimedAverage *fl =3D &ts->latency[BLOCK_ACCT_FLUSH];
> =20
>          dev_stats->interval_length =3D ts->interval_length;
> @@ -583,6 +590,10 @@ static void bdrv_query_blk_stats(BlockDeviceStats *d=
s, BlockBackend *blk)
>          dev_stats->max_wr_latency_ns =3D timed_average_max(wr);
>          dev_stats->avg_wr_latency_ns =3D timed_average_avg(wr);
> =20
> +        dev_stats->min_zap_latency_ns =3D timed_average_min(zap);
> +        dev_stats->max_zap_latency_ns =3D timed_average_max(zap);
> +        dev_stats->avg_zap_latency_ns =3D timed_average_avg(zap);
> +
>          dev_stats->min_flush_latency_ns =3D timed_average_min(fl);
>          dev_stats->max_flush_latency_ns =3D timed_average_max(fl);
>          dev_stats->avg_flush_latency_ns =3D timed_average_avg(fl);
> @@ -591,6 +602,8 @@ static void bdrv_query_blk_stats(BlockDeviceStats *ds=
, BlockBackend *blk)
>              block_acct_queue_depth(ts, BLOCK_ACCT_READ);
>          dev_stats->avg_wr_queue_depth =3D
>              block_acct_queue_depth(ts, BLOCK_ACCT_WRITE);
> +        dev_stats->avg_zap_queue_depth =3D
> +            block_acct_queue_depth(ts, BLOCK_ACCT_APPEND);
> =20
>          QAPI_LIST_PREPEND(ds->timed_stats, dev_stats);
>      }
> @@ -600,6 +613,8 @@ static void bdrv_query_blk_stats(BlockDeviceStats *ds=
, BlockBackend *blk)
>          =3D bdrv_latency_histogram_stats(&hgram[BLOCK_ACCT_READ]);
>      ds->wr_latency_histogram
>          =3D bdrv_latency_histogram_stats(&hgram[BLOCK_ACCT_WRITE]);
> +    ds->zap_latency_histogram
> +        =3D bdrv_latency_histogram_stats(&hgram[BLOCK_ACCT_APPEND]);
>      ds->flush_latency_histogram
>          =3D bdrv_latency_histogram_stats(&hgram[BLOCK_ACCT_FLUSH]);
>  }
> diff --git a/hw/block/virtio-blk.c b/hw/block/virtio-blk.c
> index 4ded625732..7605ca4f03 100644
> --- a/hw/block/virtio-blk.c
> +++ b/hw/block/virtio-blk.c
> @@ -925,6 +925,10 @@ static int virtio_blk_handle_zone_append(VirtIOBlock=
Req *req,
>      data->in_num =3D in_num;
>      data->zone_append_data.offset =3D offset;
>      qemu_iovec_init_external(&req->qiov, out_iov, out_num);
> +
> +    block_acct_start(blk_get_stats(s->blk), &req->acct, len,
> +                     BLOCK_ACCT_APPEND);
> +
>      blk_aio_zone_append(s->blk, &data->zone_append_data.offset, &req->qi=
ov, 0,
>                          virtio_blk_zone_append_complete, data);
>      return 0;
> diff --git a/include/block/accounting.h b/include/block/accounting.h
> index b9caad60d5..61cc868666 100644
> --- a/include/block/accounting.h
> +++ b/include/block/accounting.h
> @@ -37,6 +37,7 @@ enum BlockAcctType {
>      BLOCK_ACCT_READ,
>      BLOCK_ACCT_WRITE,
>      BLOCK_ACCT_FLUSH,
> +    BLOCK_ACCT_APPEND,
>      BLOCK_ACCT_UNMAP,
>      BLOCK_MAX_IOTYPE,
>  };
> diff --git a/qapi/block-core.json b/qapi/block-core.json
> index c05ad0c07e..76fe9c2fca 100644
> --- a/qapi/block-core.json
> +++ b/qapi/block-core.json
> @@ -849,6 +849,9 @@
>  # @min_wr_latency_ns: Minimum latency of write operations in the
>  #                     defined interval, in nanoseconds.
>  #
> +# @min_zap_latency_ns: Minimum latency of zone append operations in the
> +#                      defined interval, in nanoseconds.
> +#
>  # @min_flush_latency_ns: Minimum latency of flush operations in the
>  #                        defined interval, in nanoseconds.
>  #
> @@ -858,6 +861,9 @@
>  # @max_wr_latency_ns: Maximum latency of write operations in the
>  #                     defined interval, in nanoseconds.
>  #
> +# @max_zap_latency_ns: Maximum latency of zone append operations in the
> +#                      defined interval, in nanoseconds.
> +#
>  # @max_flush_latency_ns: Maximum latency of flush operations in the
>  #                        defined interval, in nanoseconds.
>  #
> @@ -867,6 +873,9 @@
>  # @avg_wr_latency_ns: Average latency of write operations in the
>  #                     defined interval, in nanoseconds.
>  #
> +# @avg_zap_latency_ns: Average latency of zone append operations in the
> +#                      defined interval, in nanoseconds.
> +#
>  # @avg_flush_latency_ns: Average latency of flush operations in the
>  #                        defined interval, in nanoseconds.
>  #
> @@ -876,15 +885,20 @@
>  # @avg_wr_queue_depth: Average number of pending write operations
>  #                      in the defined interval.
>  #
> +# @avg_zap_queue_depth: Average number of pending zone append operations
> +#                       in the defined interval.
> +#
>  # Since: 2.5
>  ##
>  { 'struct': 'BlockDeviceTimedStats',
>    'data': { 'interval_length': 'int', 'min_rd_latency_ns': 'int',
>              'max_rd_latency_ns': 'int', 'avg_rd_latency_ns': 'int',
>              'min_wr_latency_ns': 'int', 'max_wr_latency_ns': 'int',
> -            'avg_wr_latency_ns': 'int', 'min_flush_latency_ns': 'int',
> -            'max_flush_latency_ns': 'int', 'avg_flush_latency_ns': 'int',
> -            'avg_rd_queue_depth': 'number', 'avg_wr_queue_depth': 'numbe=
r' } }
> +            'avg_wr_latency_ns': 'int', 'min_zap_latency_ns': 'int',
> +            'max_zap_latency_ns': 'int', 'avg_zap_latency_ns': 'int',
> +            'min_flush_latency_ns': 'int', 'max_flush_latency_ns': 'int',
> +            'avg_flush_latency_ns': 'int', 'avg_rd_queue_depth': 'number=
',
> +            'avg_wr_queue_depth': 'number', 'avg_zap_queue_depth': 'numb=
er'  } }
> =20
>  ##
>  # @BlockDeviceStats:
> @@ -895,12 +909,16 @@
>  #
>  # @wr_bytes: The number of bytes written by the device.
>  #
> +# @zap_bytes: The number of bytes appended by the zoned devices.
> +#
>  # @unmap_bytes: The number of bytes unmapped by the device (Since 4.2)
>  #
>  # @rd_operations: The number of read operations performed by the device.
>  #
>  # @wr_operations: The number of write operations performed by the device.
>  #
> +# @zap_operations: The number of zone append operations performed by the=
 zoned devices.
> +#
>  # @flush_operations: The number of cache flush operations performed by t=
he
>  #                    device (since 0.15)
>  #
> @@ -911,6 +929,8 @@
>  #
>  # @wr_total_time_ns: Total time spent on writes in nanoseconds (since 0.=
15).
>  #
> +# @zap_total_time_ns: Total time spent on zone append writes in nanoseco=
nds.
> +#
>  # @flush_total_time_ns: Total time spent on cache flushes in nanoseconds
>  #                       (since 0.15).
>  #
> @@ -928,6 +948,9 @@
>  # @wr_merged: Number of write requests that have been merged into another
>  #             request (Since 2.3).
>  #
> +# @zap_merged: Number of zone append requests that have been merged into
> +#              another request.
> +#
>  # @unmap_merged: Number of unmap requests that have been merged into ano=
ther
>  #                request (Since 4.2)
>  #
> @@ -941,6 +964,9 @@
>  # @failed_wr_operations: The number of failed write operations
>  #                        performed by the device (Since 2.5)
>  #
> +# @failed_zap_operations: The number of failed zone append write
> +#                         operations performed by the zoned devices
> +#
>  # @failed_flush_operations: The number of failed flush operations
>  #                           performed by the device (Since 2.5)
>  #
> @@ -953,6 +979,9 @@
>  # @invalid_wr_operations: The number of invalid write operations
>  #                         performed by the device (Since 2.5)
>  #
> +# @invalid_zap_operations: The number of invalid zone append operations
> +#                          performed by the zoned device
> +#
>  # @invalid_flush_operations: The number of invalid flush operations
>  #                            performed by the device (Since 2.5)
>  #
> @@ -972,27 +1001,32 @@
>  #
>  # @wr_latency_histogram: @BlockLatencyHistogramInfo. (Since 4.0)
>  #
> +# @zap_latency_histogram: @BlockLatencyHistogramInfo.
> +#
>  # @flush_latency_histogram: @BlockLatencyHistogramInfo. (Since 4.0)
>  #
>  # Since: 0.14
>  ##
>  { 'struct': 'BlockDeviceStats',
> -  'data': {'rd_bytes': 'int', 'wr_bytes': 'int', 'unmap_bytes' : 'int',
> -           'rd_operations': 'int', 'wr_operations': 'int',
> +  'data': {'rd_bytes': 'int', 'wr_bytes': 'int', 'zap_bytes': 'int',
> +           'unmap_bytes' : 'int', 'rd_operations': 'int',
> +           'wr_operations': 'int', 'zap_operations': 'int',
>             'flush_operations': 'int', 'unmap_operations': 'int',
>             'rd_total_time_ns': 'int', 'wr_total_time_ns': 'int',
> -           'flush_total_time_ns': 'int', 'unmap_total_time_ns': 'int',
> -           'wr_highest_offset': 'int',
> -           'rd_merged': 'int', 'wr_merged': 'int', 'unmap_merged': 'int',
> -           '*idle_time_ns': 'int',
> +           'zap_total_time_ns': 'int', 'flush_total_time_ns': 'int',
> +           'unmap_total_time_ns': 'int', 'wr_highest_offset': 'int',
> +           'rd_merged': 'int', 'wr_merged': 'int', 'zap_merged': 'int',
> +           'unmap_merged': 'int', '*idle_time_ns': 'int',
>             'failed_rd_operations': 'int', 'failed_wr_operations': 'int',
> -           'failed_flush_operations': 'int', 'failed_unmap_operations': =
'int',
> -           'invalid_rd_operations': 'int', 'invalid_wr_operations': 'int=
',
> +           'failed_zap_operations': 'int', 'failed_flush_operations': 'i=
nt',
> +           'failed_unmap_operations': 'int', 'invalid_rd_operations': 'i=
nt',
> +           'invalid_wr_operations': 'int', 'invalid_zap_operations': 'in=
t',
>             'invalid_flush_operations': 'int', 'invalid_unmap_operations'=
: 'int',
>             'account_invalid': 'bool', 'account_failed': 'bool',
>             'timed_stats': ['BlockDeviceTimedStats'],
>             '*rd_latency_histogram': 'BlockLatencyHistogramInfo',
>             '*wr_latency_histogram': 'BlockLatencyHistogramInfo',
> +           '*zap_latency_histogram': 'BlockLatencyHistogramInfo',
>             '*flush_latency_histogram': 'BlockLatencyHistogramInfo' } }
> =20
>  ##
> diff --git a/qapi/block.json b/qapi/block.json
> index 5fe068f903..5a57ef4a9f 100644
> --- a/qapi/block.json
> +++ b/qapi/block.json
> @@ -525,6 +525,9 @@
>  # @boundaries-write: list of interval boundary values for write latency
>  #                    histogram.
>  #
> +# @boundaries-zap: list of interval boundary values for zone append write
> +#                  latency histogram.
> +#
>  # @boundaries-flush: list of interval boundary values for flush latency
>  #                    histogram.
>  #
> @@ -573,5 +576,6 @@
>             '*boundaries': ['uint64'],
>             '*boundaries-read': ['uint64'],
>             '*boundaries-write': ['uint64'],
> +           '*boundaries-zap': ['uint64'],
>             '*boundaries-flush': ['uint64'] },
>    'allow-preconfig': true }
> --=20
> 2.39.2
>=20

--TtnxWzeXoIXHp1d0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmQTbL0ACgkQnKSrs4Gr
c8i8GQf/Y8IqtZ1XrrGcR+70I9R2xGJD6uZGxz1yoAoMCG4Jd0knZeg7wGYd5j/1
rdPCH//J7ZMQnFcpp56aeODB31FlQFwH1wuVCT2X8j0jFFemuVFzFNo7NcquIftD
UQqlIicMagF7HQsEGVSal85vlbexxBB0m1iNn32w+XaYGeyaDbodTG5vU+0lnisY
FywrQh+XVRDNTgohr/50kJHmfxvqizh40ECPHzqmTWzV9gNNptXk49itk7UpC3hY
LGiHqgWEL1OhEM1nL+Qz5C7IEoILyi9Vn9+jRDecWuKeafvvDtoTNAawHc6qDTI8
wNtmmBeVC9eGUErMeh6+BIgbwXPxSg==
=M3hY
-----END PGP SIGNATURE-----

--TtnxWzeXoIXHp1d0--

