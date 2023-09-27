Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 209967AF81C
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 04:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbjI0Car (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 22:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235972AbjI0CWp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 22:22:45 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B71AE4EDC;
        Tue, 26 Sep 2023 18:50:01 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0VsyF-Ei_1695779398;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VsyF-Ei_1695779398)
          by smtp.aliyun-inc.com;
          Wed, 27 Sep 2023 09:49:58 +0800
Message-ID: <1695779259.7440922-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [GIT PULL] virtio: features
Date:   Wed, 27 Sep 2023 09:47:39 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <eperezma@redhat.com>, <jasowang@redhat.com>,
        <shannon.nelson@amd.com>, <xuanzhuo@linux.alibaba.com>,
        <yuanyaogoog@chromium.org>, <yuehaibing@huawei.com>,
        Thomas Lendacky <thomas.lendacky@amd.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <20230903181338-mutt-send-email-mst@kernel.org>
 <20230926130451.axgodaa6tvwqs3ut@amd.com>
In-Reply-To: <20230926130451.axgodaa6tvwqs3ut@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 26 Sep 2023 08:04:51 -0500, Michael Roth <michael.roth@amd.com> wro=
te:
> On Sun, Sep 03, 2023 at 06:13:38PM -0400, Michael S. Tsirkin wrote:
> > The following changes since commit 2dde18cd1d8fac735875f2e4987f11817cc0=
bc2c:
> >
> >   Linux 6.5 (2023-08-27 14:49:51 -0700)
> >
> > are available in the Git repository at:
> >
> >   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/fo=
r_linus
> >
> > for you to fetch changes up to 1acfe2c1225899eab5ab724c91b7e1eb2881b9ab:
> >
> >   virtio_ring: fix avail_wrap_counter in virtqueue_add_packed (2023-09-=
03 18:10:24 -0400)
> >
> > ----------------------------------------------------------------
> > virtio: features
> >
> > a small pull request this time around, mostly because the
> > vduse network got postponed to next relase so we can be sure
> > we got the security store right.
> >
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >
> > ----------------------------------------------------------------
> > Eugenio P=E9=96=9Eez (4):
> >       vdpa: add VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK flag
> >       vdpa: accept VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK backend featu=
re
> >       vdpa: add get_backend_features vdpa operation
> >       vdpa_sim: offer VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK
> >
> > Jason Wang (1):
> >       virtio_vdpa: build affinity masks conditionally
> >
> > Xuan Zhuo (12):
> >       virtio_ring: check use_dma_api before unmap desc for indirect
> >       virtio_ring: put mapping error check in vring_map_one_sg
> >       virtio_ring: introduce virtqueue_set_dma_premapped()
> >       virtio_ring: support add premapped buf
> >       virtio_ring: introduce virtqueue_dma_dev()
> >       virtio_ring: skip unmap for premapped
> >       virtio_ring: correct the expression of the description of virtque=
ue_resize()
> >       virtio_ring: separate the logic of reset/enable from virtqueue_re=
size
> >       virtio_ring: introduce virtqueue_reset()
> >       virtio_ring: introduce dma map api for virtqueue
> >       virtio_ring: introduce dma sync api for virtqueue
> >       virtio_net: merge dma operations when filling mergeable buffers
>
> This ^ patch (upstream commit 295525e29a) seems to cause a
> network-related regression when using SWIOTLB in the guest. I noticed
> this initially testing SEV guests, which use SWIOTLB by default, but
> it can also be seen with normal guests when forcing SWIOTLB via
> swiotlb=3Dforce kernel cmdline option. I see it with both 6.6-rc1 and
> 6.6-rc2 (haven't tried rc3 yet, but don't see any related changes
> there), and reverting 714073495f seems to avoid the issue.
>
> Steps to reproduce:
>
> 1) Boot QEMU/KVM guest with 6.6-rc2 with swiotlb=3Dforce via something li=
ke the following cmdline:
>
>    qemu-system-x86_64 \
>    -machine q35 -smp 4,maxcpus=3D255 -cpu EPYC-Milan-v2 \
>    -enable-kvm -m 16G,slots=3D5,maxmem=3D256G -vga none \
>    -device virtio-scsi-pci,id=3Dscsi0,disable-legacy=3Don,iommu_platform=
=3Dtrue \
>    -drive file=3D/home/mroth/storage/ubuntu-18.04-seves2.qcow2,if=3Dnone,=
id=3Ddrive0,snapshot=3Doff \
>    -device scsi-hd,id=3Dhd0,drive=3Ddrive0,bus=3Dscsi0.0 \
>    -device virtio-net-pci,netdev=3Dnetdev0,id=3Dnet0,disable-legacy=3Don,=
iommu_platform=3Dtrue,romfile=3D \
>    -netdev tap,script=3D/home/mroth/qemu-ifup,id=3Dnetdev0 \
>    -L /home/mroth/storage/AMDSEV2/snp-release-2023-09-23/usr/local/share/=
qemu \
>    -drive if=3Dpflash,format=3Draw,unit=3D0,file=3D/home/mroth/storage/AM=
DSEV2/snp-release-2023-09-23/usr/local/share/qemu/OVMF_CODE.fd,readonly \
>    -drive if=3Dpflash,format=3Draw,unit=3D1,file=3D/home/mroth/storage/AM=
DSEV2/snp-release-2023-09-23/usr/local/share/qemu/OVMF_VARS.fd \
>    -debugcon file:debug.log -global isa-debugcon.iobase=3D0x402 -msg time=
stamp=3Don \
>    -kernel /boot/vmlinuz-6.6.0-rc2-vanilla0+ \
>    -initrd /boot/initrd.img-6.6.0-rc2-vanilla0+ \
>    -append "root=3DUUID=3Dd72a6d1c-06cf-4b79-af43-f1bac4f620f9 ro console=
=3DttyS0,115200n8 earlyprintk=3Dserial,ttyS0,115200 debug=3D1 sev=3Ddebug p=
age_poison=3D0 spec_rstack_overflow=3Doff swiotlb=3Dforce"
>
> 2) scp a small file from the host to the guest IP via its virtio-net devi=
ce.
>    Smaller file sizes succeed, but the larger the file the more likely
>    it will fail. e.g.:
>
>    mroth@host:~$ dd if=3D/dev/zero of=3Dtest bs=3D1K count=3D19
>    19+0 records in
>    19+0 records out
>    19456 bytes (19 kB, 19 KiB) copied, 0.000940134 s, 20.7 MB/s
>    mroth@host:~$ scp test vm0:
>    test                                                                  =
  100%   19KB  10.1MB/s   00:00
>    mroth@host:~$ dd if=3D/dev/zero of=3Dtest bs=3D1K count=3D20
>    20+0 records in
>    20+0 records out
>    20480 bytes (20 kB, 20 KiB) copied, 0.00093774 s, 21.8 MB/s
>    mroth@host:~$ scp test vm0:
>    test                                                                  =
    0%    0     0.0KB/s   --:-- ETA
>    client_loop: send disconnect: Broken pipe
>    lost connection
>    mroth@host:~$


Hi Michael,

Thanks for the report.

Cloud you try this fix?  I reproduce this issue, and that works for me.

Thanks.


diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 98dc9b49d56b..9ece27dc5144 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -589,16 +589,16 @@ static void virtnet_rq_unmap(struct receive_queue *rq=
, void *buf, u32 len)

        --dma->ref;

-       if (dma->ref) {
-               if (dma->need_sync && len) {
-                       offset =3D buf - (head + sizeof(*dma));
+       if (dma->need_sync && len) {
+               offset =3D buf - (head + sizeof(*dma));

-                       virtqueue_dma_sync_single_range_for_cpu(rq->vq, dma=
->addr, offset,
-                                                               len, DMA_FR=
OM_DEVICE);
-               }
+               virtqueue_dma_sync_single_range_for_cpu(rq->vq, dma->addr,
+                                                       offset, len,
+                                                       DMA_FROM_DEVICE);
+       }

+       if (dma->ref)
                return;
-       }

        virtqueue_dma_unmap_single_attrs(rq->vq, dma->addr, dma->len,
                                         DMA_FROM_DEVICE, DMA_ATTR_SKIP_CPU=
_SYNC);


>
> Thanks,
>
> Mike
>
> >
> > Yuan Yao (1):
> >       virtio_ring: fix avail_wrap_counter in virtqueue_add_packed
> >
> > Yue Haibing (1):
> >       vdpa/mlx5: Remove unused function declarations
> >
> >  drivers/net/virtio_net.c           | 230 ++++++++++++++++++---
> >  drivers/vdpa/mlx5/core/mlx5_vdpa.h |   3 -
> >  drivers/vdpa/vdpa_sim/vdpa_sim.c   |   8 +
> >  drivers/vhost/vdpa.c               |  15 +-
> >  drivers/virtio/virtio_ring.c       | 412 +++++++++++++++++++++++++++++=
+++-----
> >  drivers/virtio/virtio_vdpa.c       |  17 +-
> >  include/linux/vdpa.h               |   4 +
> >  include/linux/virtio.h             |  22 ++
> >  include/uapi/linux/vhost_types.h   |   4 +
> >  9 files changed, 625 insertions(+), 90 deletions(-)
> >
