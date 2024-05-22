Return-Path: <kvm+bounces-17950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BCF898CC079
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 13:42:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D1201F232EE
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 11:42:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0352E130E21;
	Wed, 22 May 2024 11:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="WCDiwaJp"
X-Original-To: kvm@vger.kernel.org
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C01F12DDBF;
	Wed, 22 May 2024 11:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716378111; cv=none; b=SEkxLtbvyjiWhTCx4CPZ7k84HRxdSEmfjg10H+9rKC6DJV6krDbDGEij6p/jdbVP+/4BIDgkA4F1Q1AUDDt1nbWzNtC0guvnUwJc6wO6pyDgEtxyV2OnIzYUFKwt/aNRt8YvmWvjDtXyb2TAig7JIRs6rbz5ctZQbUPwzqtBKtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716378111; c=relaxed/simple;
	bh=6kOScnqq1f3Lup96PmP+FiM2VqT68vsjDqx1Kl8E/3Y=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To:
	 Content-Type; b=uXmwp4ngkFNtsa0qHqXnGTH3nsoBYgkPvrjlg1+iZtyooX7pOBV+LhoTDC1e1QwcRzxZzFnBXKqIpjfAhO97ylN4f94L+z3LB25VVfzu6gh8K36DEgEpcvWdYLqQKfcLbsKeuL2dB6pM2HIELUuLbyJFvc+v75XldQ0zYhdV+XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=WCDiwaJp; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1716378104; h=Message-ID:Subject:Date:From:To:Content-Type;
	bh=G7AvbOTwQvGlz5AgqSfZcaQhKwQJQMPhSdT/huU+DmE=;
	b=WCDiwaJpGnhtWV4/CeEpd0yEAMbxXitpXiOSZb3EnCquOKfxchdECp8R07hVxtPbgu07GwoSOURjWt2QRBQho/IzvAEOQBeFiTPbhRBpXEh4ksSdukcsQ9YijXE58ldUxe6uMyRF6DshQ4Zo7zivkkwiHuVgIwQHWRO0F42U65c=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037067110;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=32;SR=0;TI=SMTPD_---0W7.TVQP_1716378101;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W7.TVQP_1716378101)
          by smtp.aliyun-inc.com;
          Wed, 22 May 2024 19:41:42 +0800
Message-ID: <1716377965.6866436-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [GIT PULL] virtio: features, fixes, cleanups
Date: Wed, 22 May 2024 19:39:25 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 anton.yakovlev@opensynergy.com,
 bartosz.golaszewski@linaro.org,
 christophe.jaillet@wanadoo.fr,
 dave.jiang@intel.com,
 david@redhat.com,
 eperezma@redhat.com,
 herbert@gondor.apana.org.au,
 jasowang@redhat.com,
 jiri@nvidia.com,
 jiri@resnulli.us,
 johannes@sipsolutions.net,
 krzysztof.kozlowski@linaro.org,
 lingshan.zhu@intel.com,
 linus.walleij@linaro.org,
 lizhijian@fujitsu.com,
 martin.petersen@oracle.com,
 maxime.coquelin@redhat.com,
 michael.christie@oracle.com,
 sgarzare@redhat.com,
 stevensd@chromium.org,
 sudeep.holla@arm.com,
 syzbot+98edc2df894917b3431f@syzkaller.appspotmail.com,
 u.kleine-koenig@pengutronix.de,
 viresh.kumar@linaro.org,
 yuxue.liu@jaguarmicro.com,
 Srujana Challa <schalla@marvell.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,Jason Wang <jasowang@redhat.com>
References: <20240522060301-mutt-send-email-mst@kernel.org>
 <1716373365.1499481-1-xuanzhuo@linux.alibaba.com>
 <20240522073727-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240522073727-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On Wed, 22 May 2024 07:38:01 -0400, "Michael S. Tsirkin" <mst@redhat.com> w=
rote:
> On Wed, May 22, 2024 at 06:22:45PM +0800, Xuan Zhuo wrote:
> > On Wed, 22 May 2024 06:03:01 -0400, "Michael S. Tsirkin" <mst@redhat.co=
m> wrote:
> > > Things to note here:
> > >
> > > - the new Marvell OCTEON DPU driver is not here: latest v4 keeps caus=
ing
> > >   build failures on mips. I deferred the pull hoping to get it in
> > >   and I might merge a new version post rc1
> > >   (supposed to be ok for new drivers as they can't cause regressions),
> > >   but we'll see.
> > > - there are also a couple bugfixes under review, to be merged after r=
c1
> > > - I merged a trivial patch (removing a comment) that also got
> > >   merged through net.
> > >   git handles this just fine and it did not seem worth it
> > >   rebasing to drop it.
> > > - there is a trivial conflict in the header file. Shouldn't be any
> > >   trouble to resolve, but fyi the resolution by Stephen is here
> > > 	diff --cc drivers/virtio/virtio_mem.c
> > > 	index e8355f55a8f7,6d4dfbc53a66..000000000000
> > > 	--- a/drivers/virtio/virtio_mem.c
> > > 	+++ b/drivers/virtio/virtio_mem.c
> > > 	@@@ -21,7 -21,7 +21,8 @@@
> > > 	  #include <linux/bitmap.h>
> > > 	  #include <linux/lockdep.h>
> > > 	  #include <linux/log2.h>
> > > 	 +#include <linux/vmalloc.h>
> > > 	+ #include <linux/suspend.h>
> > >   Also see it here:
> > >   https://lore.kernel.org/all/20240423145947.142171f6@canb.auug.org.a=
u/
> > >
> > >
> > >
> > > The following changes since commit 18daea77cca626f590fb140fc11e3a43c5=
d41354:
> > >
> > >   Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm =
(2024-04-30 12:40:41 -0700)
> > >
> > > are available in the Git repository at:
> > >
> > >   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/=
for_linus
> > >
> > > for you to fetch changes up to 0b8dbbdcf2e42273fbac9b752919e2e5b2abac=
21:
> > >
> > >   Merge tag 'for_linus' into vhost (2024-05-12 08:15:28 -0400)
> > >
> > > ----------------------------------------------------------------
> > > virtio: features, fixes, cleanups
> > >
> > > Several new features here:
> > >
> > > - virtio-net is finally supported in vduse.
> > >
> > > - Virtio (balloon and mem) interaction with suspend is improved
> > >
> > > - vhost-scsi now handles signals better/faster.
> > >
> > > - virtio-net now supports premapped mode by default,
> > >   opening the door for all kind of zero copy tricks.
> > >
> > > Fixes, cleanups all over the place.
> > >
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > >
> > > ----------------------------------------------------------------
> > > Christophe JAILLET (1):
> > >       vhost-vdpa: Remove usage of the deprecated ida_simple_xx() API
> > >
> > > David Hildenbrand (1):
> > >       virtio-mem: support suspend+resume
> > >
> > > David Stevens (2):
> > >       virtio_balloon: Give the balloon its own wakeup source
> > >       virtio_balloon: Treat stats requests as wakeup events
> > >
> > > Eugenio P=E9=96=9Eez (2):
> > >       MAINTAINERS: add Eugenio P=E9=96=9Eez as reviewer
> > >       MAINTAINERS: add Eugenio P=E9=96=9Eez as reviewer
> > >
> > > Jiri Pirko (1):
> > >       virtio: delete vq in vp_find_vqs_msix() when request_irq() fails
> > >
> > > Krzysztof Kozlowski (24):
> > >       virtio: balloon: drop owner assignment
> > >       virtio: input: drop owner assignment
> > >       virtio: mem: drop owner assignment
> > >       um: virt-pci: drop owner assignment
> > >       virtio_blk: drop owner assignment
> > >       bluetooth: virtio: drop owner assignment
> > >       hwrng: virtio: drop owner assignment
> > >       virtio_console: drop owner assignment
> > >       crypto: virtio - drop owner assignment
> > >       firmware: arm_scmi: virtio: drop owner assignment
> > >       gpio: virtio: drop owner assignment
> > >       drm/virtio: drop owner assignment
> > >       iommu: virtio: drop owner assignment
> > >       misc: nsm: drop owner assignment
> > >       net: caif: virtio: drop owner assignment
> > >       net: virtio: drop owner assignment
> > >       net: 9p: virtio: drop owner assignment
> > >       vsock/virtio: drop owner assignment
> > >       wifi: mac80211_hwsim: drop owner assignment
> > >       nvdimm: virtio_pmem: drop owner assignment
> > >       rpmsg: virtio: drop owner assignment
> > >       scsi: virtio: drop owner assignment
> > >       fuse: virtio: drop owner assignment
> > >       sound: virtio: drop owner assignment
> > >
> > > Li Zhijian (1):
> > >       vdpa: Convert sprintf/snprintf to sysfs_emit
> > >
> > > Maxime Coquelin (6):
> > >       vduse: validate block features only with block devices
> > >       vduse: Temporarily fail if control queue feature requested
> > >       vduse: enable Virtio-net device type
> > >       vduse: validate block features only with block devices
> > >       vduse: Temporarily fail if control queue feature requested
> > >       vduse: enable Virtio-net device type
> > >
> > > Michael S. Tsirkin (2):
> > >       Merge tag 'stable/vduse-virtio-net' into vhost
> > >       Merge tag 'for_linus' into vhost
> > >
> > > Mike Christie (9):
> > >       vhost-scsi: Handle vhost_vq_work_queue failures for events
> > >       vhost-scsi: Handle vhost_vq_work_queue failures for cmds
> > >       vhost-scsi: Use system wq to flush dev for TMFs
> > >       vhost: Remove vhost_vq_flush
> > >       vhost_scsi: Handle vhost_vq_work_queue failures for TMFs
> > >       vhost: Use virtqueue mutex for swapping worker
> > >       vhost: Release worker mutex during flushes
> > >       vhost_task: Handle SIGKILL by flushing work and exiting
> > >       kernel: Remove signal hacks for vhost_tasks
> > >
> > > Uwe Kleine-K=E9=B0=8Aig (1):
> > >       virtio-mmio: Convert to platform remove callback returning void
> > >
> > > Xuan Zhuo (7):
> > >       virtio_ring: introduce dma map api for page
> > >       virtio_ring: enable premapped mode whatever use_dma_api
> > >       virtio_net: replace private by pp struct inside page
> > >       virtio_net: big mode support premapped
> > >       virtio_net: enable premapped by default
> > >       virtio_net: rx remove premapped failover code
> > >       virtio_net: remove the misleading comment
> >
> > Hi Michael,
> >
> > As we discussed here:
> >
> > 	http://lore.kernel.org/all/CACGkMEuyeJ9mMgYnnB42=3Dhw6umNuo=3Dagn7VBqB=
qYPd7GN=3D+39Q@mail.gmail.com
> >
> > This patch set has been abandoned.
>
> You mean I should drop it? OK.

YES. As I discussed with Jason.

>
> > And you miss
> >
> > 	https://lore.kernel.org/all/20240424091533.86949-1-xuanzhuo@linux.alib=
aba.com/

And this.

Thanks.


> >
> > Thanks.
> >
> > >
> > > Yuxue Liu (2):
> > >       vp_vdpa: Fix return value check vp_vdpa_request_irq
> > >       vp_vdpa: don't allocate unused msix vectors
> > >
> > > Zhu Lingshan (1):
> > >       MAINTAINERS: apply maintainer role of Intel vDPA driver
> > >
> > >  MAINTAINERS                                   |  10 +-
> > >  arch/um/drivers/virt-pci.c                    |   1 -
> > >  drivers/block/virtio_blk.c                    |   1 -
> > >  drivers/bluetooth/virtio_bt.c                 |   1 -
> > >  drivers/char/hw_random/virtio-rng.c           |   1 -
> > >  drivers/char/virtio_console.c                 |   2 -
> > >  drivers/crypto/virtio/virtio_crypto_core.c    |   1 -
> > >  drivers/firmware/arm_scmi/virtio.c            |   1 -
> > >  drivers/gpio/gpio-virtio.c                    |   1 -
> > >  drivers/gpu/drm/virtio/virtgpu_drv.c          |   1 -
> > >  drivers/iommu/virtio-iommu.c                  |   1 -
> > >  drivers/misc/nsm.c                            |   1 -
> > >  drivers/net/caif/caif_virtio.c                |   1 -
> > >  drivers/net/virtio_net.c                      | 248 ++++++++++++++++=
+---------
> > >  drivers/net/wireless/virtual/mac80211_hwsim.c |   1 -
> > >  drivers/nvdimm/virtio_pmem.c                  |   1 -
> > >  drivers/rpmsg/virtio_rpmsg_bus.c              |   1 -
> > >  drivers/scsi/virtio_scsi.c                    |   1 -
> > >  drivers/vdpa/vdpa.c                           |   2 +-
> > >  drivers/vdpa/vdpa_user/vduse_dev.c            |  24 ++-
> > >  drivers/vdpa/virtio_pci/vp_vdpa.c             |  27 ++-
> > >  drivers/vhost/scsi.c                          |  70 +++++---
> > >  drivers/vhost/vdpa.c                          |   6 +-
> > >  drivers/vhost/vhost.c                         | 130 ++++++++++----
> > >  drivers/vhost/vhost.h                         |   3 +-
> > >  drivers/virtio/virtio_balloon.c               |  85 +++++----
> > >  drivers/virtio/virtio_input.c                 |   1 -
> > >  drivers/virtio/virtio_mem.c                   |  69 ++++++-
> > >  drivers/virtio/virtio_mmio.c                  |   6 +-
> > >  drivers/virtio/virtio_pci_common.c            |   4 +-
> > >  drivers/virtio/virtio_ring.c                  |  59 +++++-
> > >  fs/coredump.c                                 |   4 +-
> > >  fs/fuse/virtio_fs.c                           |   1 -
> > >  include/linux/sched/vhost_task.h              |   3 +-
> > >  include/linux/virtio.h                        |   7 +
> > >  include/uapi/linux/virtio_mem.h               |   2 +
> > >  kernel/exit.c                                 |   5 +-
> > >  kernel/signal.c                               |   4 +-
> > >  kernel/vhost_task.c                           |  53 ++++--
> > >  net/9p/trans_virtio.c                         |   1 -
> > >  net/vmw_vsock/virtio_transport.c              |   1 -
> > >  sound/virtio/virtio_card.c                    |   1 -
> > >  42 files changed, 578 insertions(+), 265 deletions(-)
> > >
>

