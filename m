Return-Path: <kvm+bounces-20064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F27D99101FA
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 12:54:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BEC628135E
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 10:54:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63ECF1AAE19;
	Thu, 20 Jun 2024 10:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="S0l6vp9O"
X-Original-To: kvm@vger.kernel.org
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB7C17CA1B;
	Thu, 20 Jun 2024 10:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718880844; cv=none; b=PIvjYlLlRUaNqHtJgy2esH4BiKj7/faSPLdRP+bFNFaUcn25cF3Mwrqa6HzFqqUIe6CqWSqddaciCSJceJNIw3C4KGXgPpvBAxOXExrrK9xbvDxNnA0fY1Uecy5nDLccZt/kG8ksb9VsrJtgqMWCqILtBUp5ABVbzIXmnhNN/w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718880844; c=relaxed/simple;
	bh=UruHWUQ5O8MYClPNIYZaA1YtVIMIggmoUzcTqSnUq/c=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To; b=du0p9PpCQqqtMjUgXPzy1dQ4d4Qa9rSw73TLCn5QvTlXkXD82AqHCz4cXnKt73WdKL45kRJkMoxh0xwI879/iLowYZvDJcHQhfiHpo0lmvpZxrK/HVnowULr0KI69ttsmpX0dgv/dLSzOcbMUgX9G9b3bZB+i8XH3M+KU1JdQNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=S0l6vp9O; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1718880839; h=Message-ID:Subject:Date:From:To;
	bh=2vIY8NZnvngm+xxf0k0vAQCKhjahEOWJHOTFFlU+/BE=;
	b=S0l6vp9OukbkV5RYsVoz3F/mYQVPyeqtf6gz5P+vrm1GVVBYDPGrdNlWDw5INirkjsnqVZhFbqShyV42GKO8rTKXEsk2c7XaDz09Mows0DsoGPtPz+BCQxZEtEJyZ9/SxgD6xEaRUB55JhNHvk+cOi+udBb3XzSA4ofgsuizro0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037067109;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=26;SR=0;TI=SMTPD_---0W8sD2ym_1718880836;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W8sD2ym_1718880836)
          by smtp.aliyun-inc.com;
          Thu, 20 Jun 2024 18:53:57 +0800
Message-ID: <1718880548.281809-3-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost v9 2/6] virtio: remove support for names array entries being null.
Date: Thu, 20 Jun 2024 18:49:08 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux.dev,
 Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Hans de Goede <hdegoede@redhat.com>,
 =?utf-8?q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Vadim Pasternak <vadimp@nvidia.com>,
 Bjorn Andersson <andersson@kernel.org>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Cornelia Huck <cohuck@redhat.com>,
 Halil Pasic <pasic@linux.ibm.com>,
 Eric Farman <farman@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>,
 Jason Wang <jasowang@redhat.com>,
 linux-um@lists.infradead.org,
 platform-driver-x86@vger.kernel.org,
 linux-remoteproc@vger.kernel.org,
 linux-s390@vger.kernel.org,
 kvm@vger.kernel.org,
 Wei Wang <wei.w.wang@intel.com>
References: <20240424091533.86949-1-xuanzhuo@linux.alibaba.com>
 <20240424091533.86949-3-xuanzhuo@linux.alibaba.com>
 <20240620035749-mutt-send-email-mst@kernel.org>
 <1718872778.4831812-1-xuanzhuo@linux.alibaba.com>
 <20240620044839-mutt-send-email-mst@kernel.org>
 <1718874293.698573-2-xuanzhuo@linux.alibaba.com>
 <20240620054548-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240620054548-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On Thu, 20 Jun 2024 06:01:54 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Thu, Jun 20, 2024 at 05:04:53PM +0800, Xuan Zhuo wrote:
> > On Thu, 20 Jun 2024 05:01:08 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > On Thu, Jun 20, 2024 at 04:39:38PM +0800, Xuan Zhuo wrote:
> > > > On Thu, 20 Jun 2024 04:02:45 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > > > On Wed, Apr 24, 2024 at 05:15:29PM +0800, Xuan Zhuo wrote:
> > > > > > commit 6457f126c888 ("virtio: support reserved vqs") introduced this
> > > > > > support. Multiqueue virtio-net use 2N as ctrl vq finally, so the logic
> > > > > > doesn't apply. And not one uses this.
> > > > > >
> > > > > > On the other side, that makes some trouble for us to refactor the
> > > > > > find_vqs() params.
> > > > > >
> > > > > > So I remove this support.
> > > > > >
> > > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > > Acked-by: Jason Wang <jasowang@redhat.com>
> > > > > > Acked-by: Eric Farman <farman@linux.ibm.com> # s390
> > > > > > Acked-by: Halil Pasic <pasic@linux.ibm.com>
> > > > >
> > > > >
> > > > > I don't mind, but this patchset is too big already.
> > > > > Why do we need to make this part of this patchset?
> > > >
> > > >
> > > > If some the pointers of the names is NULL, then in the virtio ring,
> > > > we will have a trouble to index from the arrays(names, callbacks...).
> > > > Becasue that the idx of the vq is not the index of these arrays.
> > > >
> > > > If the names is [NULL, "rx", "tx"], the first vq is the "rx", but index of the
> > > > vq is zero, but the index of the info of this vq inside the arrays is 1.
> > >
> > >
> > > Ah. So actually, it used to work.
> > >
> > > What this should refer to is
> > >
> > > commit ddbeac07a39a81d82331a312d0578fab94fccbf1
> > > Author: Wei Wang <wei.w.wang@intel.com>
> > > Date:   Fri Dec 28 10:26:25 2018 +0800
> > >
> > >     virtio_pci: use queue idx instead of array idx to set up the vq
> > >
> > >     When find_vqs, there will be no vq[i] allocation if its corresponding
> > >     names[i] is NULL. For example, the caller may pass in names[i] (i=4)
> > >     with names[2] being NULL because the related feature bit is turned off,
> > >     so technically there are 3 queues on the device, and name[4] should
> > >     correspond to the 3rd queue on the device.
> > >
> > >     So we use queue_idx as the queue index, which is increased only when the
> > >     queue exists.
> > >
> > >     Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> > >     Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > >
> >
> > That just work for PCI.
> >
> > The trouble I described is that we can not index in the virtio ring.
> >
> > In virtio ring, we may like to use the vq.index that do not increase
> > for the NULL.
> >
> >
> > >
> > > Which made it so setting names NULL actually does not reserve a vq.
> > >
> > > But I worry about non pci transports - there's a chance they used
> > > a different index with the balloon. Did you test some of these?
> > >
> >
> > Balloon is out of spec.
> >
> > The vq.index does not increase for the name NULL. So the Balloon use the
> > continuous id. That is out of spec.
>
>
> I see. And apparently the QEMU implementation is out of spec, too,
> so they work fine. And STATS is always on in QEMU.
>
> That change by Wei broke the theoretical config which has
> !STATS but does have FREE_PAGE. We never noticed - not many people
> ever bothered with FREE_PAGE.
>
> However QEMU really is broken in a weird way.
> In particular if it exposes STATS but driver does not
> configure STATS then QEMU still has the stats vq.
> Things will break then.
>
>
> In short, it's a mess, and it needs thought.
> At this point I suggest we keep the ability to set
> names to NULL in case we want to just revert Wei's patch.
>
>
>
> > That does not matter for this patchset.
> > The name NULL is always skipped.
> >
> > Thanks.
>
>
> Let's keep this patchset as small as possible.
> Keep the existing functionality, we'll do cleanups
> later.


I am ok. But we need a idx to index the info of the vq.

How about a new element "cfg_idx" to virtio_vq_config.

struct virtio_vq_config {
	unsigned int nvqs;
->	unsigned int cfg_idx;

	struct virtqueue   **vqs;
	vq_callback_t      **callbacks;
	const char         **names;
	const bool          *ctx;
	struct irq_affinity *desc;
};


That is setted by transport. The virtio ring can use this to index the info
of the vq. Then the #1 #2 commits can be dropped.


Thanks.



>
>
> > > --
> > > MST
> > >
>

