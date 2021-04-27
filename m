Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C169136C667
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 14:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235501AbhD0Mu7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 08:50:59 -0400
Received: from 10.mo51.mail-out.ovh.net ([46.105.77.235]:58372 "EHLO
        10.mo51.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235426AbhD0Mu7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 08:50:59 -0400
Received: from mxplan5.mail.ovh.net (unknown [10.108.4.92])
        by mo51.mail-out.ovh.net (Postfix) with ESMTPS id 1292A28184F;
        Tue, 27 Apr 2021 14:50:10 +0200 (CEST)
Received: from kaod.org (37.59.142.105) by DAG8EX1.mxp5.local (172.16.2.71)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Tue, 27 Apr
 2021 14:50:10 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-105G0069df386b5-2c89-4b96-8ac2-53ab7f6e23ea,
                    B6AA52F3D5CB607530F59D2ADE64727CB37F7539) smtp.auth=groug@kaod.org
X-OVh-ClientIp: 78.197.208.248
Date:   Tue, 27 Apr 2021 14:50:08 +0200
From:   Greg Kurz <groug@kaod.org>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
CC:     <qemu-devel@nongnu.org>, Cornelia Huck <cohuck@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>, <kvm@vger.kernel.org>,
        <virtio-fs@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
        Vivek Goyal <vgoyal@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [for-6.1 v2 0/2] virtiofsd: Add support for FUSE_SYNCFS request
Message-ID: <20210427145008.5d6914e9@bahia.lan>
In-Reply-To: <YIf1TY4MbAQnCYG0@work-vm>
References: <20210426152135.842037-1-groug@kaod.org>
        <YIf1TY4MbAQnCYG0@work-vm>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.105]
X-ClientProxiedBy: DAG9EX1.mxp5.local (172.16.2.81) To DAG8EX1.mxp5.local
 (172.16.2.71)
X-Ovh-Tracer-GUID: d41ada90-96be-49ef-ba02-9fba257bfa0c
X-Ovh-Tracer-Id: 613052500005591474
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduledrvddvtddgheejucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfgjfhfogggtgfhisehtjeertdertddvnecuhfhrohhmpefirhgvghcumfhurhiiuceoghhrohhugheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpefguedvhefhueeivdeiteehgfdtgeeuleegieeiieekffeitdfglefgteelleejtdenucffohhmrghinhepghhithhlrggsrdgtohhmpdhrvgguhhgrthdrtghomhenucfkpheptddrtddrtddrtddpfeejrdehledrudegvddruddtheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehmgihplhgrnhehrdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepghhrohhugheskhgrohgurdhorhhgpdhrtghpthhtohepphgsohhniihinhhisehrvgguhhgrthdrtghomh
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 27 Apr 2021 12:28:13 +0100
"Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:

> * Greg Kurz (groug@kaod.org) wrote:
> > FUSE_SYNCFS allows the client to flush the host page cache.
> > This isn't available in upstream linux yet, but the following
> > tree can be used to test:
> 
> That looks OK to me; but we'll need to wait until syncfs lands in the
> upstream kernel; we've got bitten before by stuff changing before it
> actaully lands in the kernel.
> 

Sure ! I'll repost an updated series when this happens.

Thanks for the feedback.

--
Greg

> Dave
> 
> > https://gitlab.com/gkurz/linux/-/tree/virtio-fs-sync
> > 
> > v2: - based on new version of FUSE_SYNCFS
> >       https://listman.redhat.com/archives/virtio-fs/2021-April/msg00166.html
> >     - propagate syncfs() errors to client (Vivek)
> > 
> > Greg Kurz (2):
> >   Update linux headers to 5.12-rc8 + FUSE_SYNCFS
> >   virtiofsd: Add support for FUSE_SYNCFS request
> > 
> >  include/standard-headers/drm/drm_fourcc.h     | 23 ++++-
> >  include/standard-headers/linux/ethtool.h      | 54 ++++++-----
> >  include/standard-headers/linux/fuse.h         | 13 ++-
> >  include/standard-headers/linux/input.h        |  2 +-
> >  .../standard-headers/rdma/vmw_pvrdma-abi.h    |  7 ++
> >  linux-headers/asm-generic/unistd.h            |  4 +-
> >  linux-headers/asm-mips/unistd_n32.h           |  1 +
> >  linux-headers/asm-mips/unistd_n64.h           |  1 +
> >  linux-headers/asm-mips/unistd_o32.h           |  1 +
> >  linux-headers/asm-powerpc/kvm.h               |  2 +
> >  linux-headers/asm-powerpc/unistd_32.h         |  1 +
> >  linux-headers/asm-powerpc/unistd_64.h         |  1 +
> >  linux-headers/asm-s390/unistd_32.h            |  1 +
> >  linux-headers/asm-s390/unistd_64.h            |  1 +
> >  linux-headers/asm-x86/kvm.h                   |  1 +
> >  linux-headers/asm-x86/unistd_32.h             |  1 +
> >  linux-headers/asm-x86/unistd_64.h             |  1 +
> >  linux-headers/asm-x86/unistd_x32.h            |  1 +
> >  linux-headers/linux/kvm.h                     | 89 +++++++++++++++++++
> >  linux-headers/linux/vfio.h                    | 27 ++++++
> >  tools/virtiofsd/fuse_lowlevel.c               | 19 ++++
> >  tools/virtiofsd/fuse_lowlevel.h               | 13 +++
> >  tools/virtiofsd/passthrough_ll.c              | 29 ++++++
> >  tools/virtiofsd/passthrough_seccomp.c         |  1 +
> >  24 files changed, 267 insertions(+), 27 deletions(-)
> > 
> > -- 
> > 2.26.3
> > 

