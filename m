Return-Path: <kvm+bounces-2740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB3CF7FD1A4
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 10:05:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D6186B210A9
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 09:05:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA29712B9B;
	Wed, 29 Nov 2023 09:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IMYbGbEk"
X-Original-To: kvm@vger.kernel.org
X-Greylist: delayed 63 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 29 Nov 2023 01:05:11 PST
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540C818D;
	Wed, 29 Nov 2023 01:05:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701248711; x=1732784711;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=woZ8E+l0CNEPRBPUKxmoG/NfRBBDwznN1n7mx/aFQJ4=;
  b=IMYbGbEkuHyASOA3qPIgCXATXSKhRqMzsO9DtW+LdrRjgonxEvYLiNaJ
   Z8aEa9vpSicr8dABhsp/dXjMxuaX7MO/9RTc3JlOZnB0ljR7dthUA7E6P
   NUnnijU/dRi5KWTQvhfb4nKOlnSb9Bt/xL/nwHA2z8vZ2p4xsFJ3+Y0ES
   wYWIxt4V9wngovhlFtsmWhr3pIFQJU15vrwUsTMryNU4Wu5rk+6LbcilG
   NEZoD1/FOM0izxsUF5ZLxbfp1YueyPQBXF3Gdkifzjx8DRpuOHh+RBO+k
   huKT7bgWzMSkNEHJ+WCKZ2PCZ4BxwaCYMD7JST8N/DRYWeOi4qM3lOTGb
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="25403"
X-IronPort-AV: E=Sophos;i="6.04,235,1695711600"; 
   d="scan'208";a="25403"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2023 01:04:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="718678539"
X-IronPort-AV: E=Sophos;i="6.04,235,1695711600"; 
   d="scan'208";a="718678539"
Received: from hongyuni-mobl.ccr.corp.intel.com (HELO [10.238.2.21]) ([10.238.2.21])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2023 01:04:04 -0800
Message-ID: <647701d8-c99b-4ca8-9817-137eaefda237@linux.intel.com>
Date: Wed, 29 Nov 2023 17:03:50 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] virtio: features
To: "Michael S. Tsirkin" <mst@redhat.com>, xuanzhuo@linux.alibaba.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, eperezma@redhat.com, jasowang@redhat.com,
 shannon.nelson@amd.com, yuanyaogoog@chromium.org, yuehaibing@huawei.com,
 kirill.shutemov@linux.intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 alexander.shishkin@linux.intel.com
References: <20230903181338-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: "Ning, Hongyu" <hongyu.ning@linux.intel.com>
In-Reply-To: <20230903181338-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2023/9/4 6:13, Michael S. Tsirkin wrote:
> The following changes since commit 2dde18cd1d8fac735875f2e4987f11817cc0bc2c:
> 
>    Linux 6.5 (2023-08-27 14:49:51 -0700)
> 
> are available in the Git repository at:
> 
>    https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
> 
> for you to fetch changes up to 1acfe2c1225899eab5ab724c91b7e1eb2881b9ab:
> 
>    virtio_ring: fix avail_wrap_counter in virtqueue_add_packed (2023-09-03 18:10:24 -0400)
> 
> ----------------------------------------------------------------
> virtio: features
> 
> a small pull request this time around, mostly because the
> vduse network got postponed to next relase so we can be sure
> we got the security store right.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> ----------------------------------------------------------------
> Eugenio Pérez (4):
>        vdpa: add VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK flag
>        vdpa: accept VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK backend feature
>        vdpa: add get_backend_features vdpa operation
>        vdpa_sim: offer VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK
> 
> Jason Wang (1):
>        virtio_vdpa: build affinity masks conditionally
> 
> Xuan Zhuo (12):
>        virtio_ring: check use_dma_api before unmap desc for indirect
>        virtio_ring: put mapping error check in vring_map_one_sg
>        virtio_ring: introduce virtqueue_set_dma_premapped()
>        virtio_ring: support add premapped buf
>        virtio_ring: introduce virtqueue_dma_dev()
>        virtio_ring: skip unmap for premapped
>        virtio_ring: correct the expression of the description of virtqueue_resize()
>        virtio_ring: separate the logic of reset/enable from virtqueue_resize
>        virtio_ring: introduce virtqueue_reset()
>        virtio_ring: introduce dma map api for virtqueue
>        virtio_ring: introduce dma sync api for virtqueue
>        virtio_net: merge dma operations when filling mergeable buffers

Hi,
above patch (upstream commit 295525e29a5b) seems causing a virtnet 
related Call Trace after WARNING from kernel/dma/debug.c.

details (log and test setup) tracked in 
https://bugzilla.kernel.org/show_bug.cgi?id=218204

it's recently noticed in a TDX guest testing since v6.6.0 release cycle 
and can still be reproduced in latest v6.7.0-rc3.

as local bisects results show, above WARNING and Call Trace is linked 
with this patch, do you mind to take a look?

> 
> Yuan Yao (1):
>        virtio_ring: fix avail_wrap_counter in virtqueue_add_packed
> 
> Yue Haibing (1):
>        vdpa/mlx5: Remove unused function declarations
> 
>   drivers/net/virtio_net.c           | 230 ++++++++++++++++++---
>   drivers/vdpa/mlx5/core/mlx5_vdpa.h |   3 -
>   drivers/vdpa/vdpa_sim/vdpa_sim.c   |   8 +
>   drivers/vhost/vdpa.c               |  15 +-
>   drivers/virtio/virtio_ring.c       | 412 ++++++++++++++++++++++++++++++++-----
>   drivers/virtio/virtio_vdpa.c       |  17 +-
>   include/linux/vdpa.h               |   4 +
>   include/linux/virtio.h             |  22 ++
>   include/uapi/linux/vhost_types.h   |   4 +
>   9 files changed, 625 insertions(+), 90 deletions(-)
> 

