Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6399328C4B7
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 00:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389166AbgJLWWS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 18:22:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37938 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388524AbgJLWWM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Oct 2020 18:22:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602541330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yjGUBxBoe8Q9Umu8r0BjI9ieeAxQ0aLM4vfXiCy6qYo=;
        b=Pqp4sm5TbkeNJTEcOA/RoFHVQAQ0ZVzdnZTsQz50FdL2jfay2OrI3k9VVN7S/5vvcgfULi
        LWhAZkwThq9HBWrAAtH9Np9g1BG9RnKFdgFvYjZznOg7sjbSb/0UMl+BPsYmsDskKjuAau
        pYaIcuCZ3kWzFl6J8x9SmBGIO3UrzRE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-9cn0hldNPXSJ6G789FaMow-1; Mon, 12 Oct 2020 18:22:02 -0400
X-MC-Unique: 9cn0hldNPXSJ6G789FaMow-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 465075200;
        Mon, 12 Oct 2020 22:22:01 +0000 (UTC)
Received: from w520.home (ovpn-113-35.phx2.redhat.com [10.3.113.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D437B76643;
        Mon, 12 Oct 2020 22:21:57 +0000 (UTC)
Date:   Mon, 12 Oct 2020 16:21:57 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kernel test robot <lkp@intel.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>, kbuild-all@lists.01.org,
        kvm@vger.kernel.org, Bharat Bhushan <Bharat.Bhushan@nxp.com>,
        Eric Auger <eric.auger@redhat.com>
Subject: Re: [vfio:next 19/27] drivers/vfio/fsl-mc/vfio_fsl_mc.c:189:36:
 error: 'FSL_MC_REGION_CACHEABLE' undeclared
Message-ID: <20201012162157.532edd5f@w520.home>
In-Reply-To: <202010130507.H3A1OKjq-lkp@intel.com>
References: <202010130507.H3A1OKjq-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


While I'm a little surprise to see an i386 build pulling in
vfio_fsl_mc, I see that CONFIG_FSL_MC_BUS does enable compile testing
on various other archs.  I assume therefore that this is just the lack
of the necessary fsl-bus series to enable the vfio_fsl_mc driver.
Both should be present in the next linux-next tree and I'm aware to
send my pull request after GregKH's to get the ordering of these
correct in mainline.  Please let me know if there are any other
concerns from anyone.  Thanks,

Alex


On Tue, 13 Oct 2020 05:59:09 +0800
kernel test robot <lkp@intel.com> wrote:

> tree:   https://github.com/awilliam/linux-vfio.git next
> head:   2099363255f123f6c9abcfa8531bbec65a8f1820
> commit: 67247289688d49a610a956c23c4ff032f0281845 [19/27] vfio/fsl-mc: Allow userspace to MMAP fsl-mc device MMIO regions
> config: i386-allyesconfig (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
> reproduce (this is a W=1 build):
>         # https://github.com/awilliam/linux-vfio/commit/67247289688d49a610a956c23c4ff032f0281845
>         git remote add vfio https://github.com/awilliam/linux-vfio.git
>         git fetch --no-tags vfio next
>         git checkout 67247289688d49a610a956c23c4ff032f0281845
>         # save the attached .config to linux build tree
>         make W=1 ARCH=i386 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/vfio/fsl-mc/vfio_fsl_mc.c: In function 'vfio_fsl_mc_mmap_mmio':
> >> drivers/vfio/fsl-mc/vfio_fsl_mc.c:189:36: error: 'FSL_MC_REGION_CACHEABLE' undeclared (first use in this function)  
>      189 |  region_cacheable = (region.type & FSL_MC_REGION_CACHEABLE) &&
>          |                                    ^~~~~~~~~~~~~~~~~~~~~~~
>    drivers/vfio/fsl-mc/vfio_fsl_mc.c:189:36: note: each undeclared identifier is reported only once for each function it appears in
> >> drivers/vfio/fsl-mc/vfio_fsl_mc.c:190:22: error: 'FSL_MC_REGION_SHAREABLE' undeclared (first use in this function)  
>      190 |       (region.type & FSL_MC_REGION_SHAREABLE);
>          |                      ^~~~~~~~~~~~~~~~~~~~~~~
>    drivers/vfio/fsl-mc/vfio_fsl_mc.c: In function 'vfio_fsl_mc_bus_notifier':
>    drivers/vfio/fsl-mc/vfio_fsl_mc.c:256:9: error: 'struct fsl_mc_device' has no member named 'driver_override'
>      256 |   mc_dev->driver_override = kasprintf(GFP_KERNEL, "%s",
>          |         ^~
>    drivers/vfio/fsl-mc/vfio_fsl_mc.c:258:14: error: 'struct fsl_mc_device' has no member named 'driver_override'
>      258 |   if (!mc_dev->driver_override)
>          |              ^~
>    drivers/vfio/fsl-mc/vfio_fsl_mc.c: In function 'vfio_fsl_mc_init_device':
>    drivers/vfio/fsl-mc/vfio_fsl_mc.c:295:8: error: implicit declaration of function 'dprc_setup' [-Werror=implicit-function-declaration]
>      295 |  ret = dprc_setup(mc_dev);
>          |        ^~~~~~~~~~
>    drivers/vfio/fsl-mc/vfio_fsl_mc.c:301:8: error: implicit declaration of function 'dprc_scan_container' [-Werror=implicit-function-declaration]
>      301 |  ret = dprc_scan_container(mc_dev, false);
>          |        ^~~~~~~~~~~~~~~~~~~
>    drivers/vfio/fsl-mc/vfio_fsl_mc.c:310:2: error: implicit declaration of function 'dprc_remove_devices' [-Werror=implicit-function-declaration]
>      310 |  dprc_remove_devices(mc_dev, NULL, 0);
>          |  ^~~~~~~~~~~~~~~~~~~
>    drivers/vfio/fsl-mc/vfio_fsl_mc.c:311:2: error: implicit declaration of function 'dprc_cleanup' [-Werror=implicit-function-declaration]
>      311 |  dprc_cleanup(mc_dev);
>          |  ^~~~~~~~~~~~
>    cc1: some warnings being treated as errors
> 
> vim +/FSL_MC_REGION_CACHEABLE +189 drivers/vfio/fsl-mc/vfio_fsl_mc.c
> 
>    174	
>    175	static int vfio_fsl_mc_mmap_mmio(struct vfio_fsl_mc_region region,
>    176					 struct vm_area_struct *vma)
>    177	{
>    178		u64 size = vma->vm_end - vma->vm_start;
>    179		u64 pgoff, base;
>    180		u8 region_cacheable;
>    181	
>    182		pgoff = vma->vm_pgoff &
>    183			((1U << (VFIO_FSL_MC_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
>    184		base = pgoff << PAGE_SHIFT;
>    185	
>    186		if (region.size < PAGE_SIZE || base + size > region.size)
>    187			return -EINVAL;
>    188	
>  > 189		region_cacheable = (region.type & FSL_MC_REGION_CACHEABLE) &&
>  > 190				   (region.type & FSL_MC_REGION_SHAREABLE);  
>    191		if (!region_cacheable)
>    192			vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>    193	
>    194		vma->vm_pgoff = (region.addr >> PAGE_SHIFT) + pgoff;
>    195	
>    196		return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
>    197				       size, vma->vm_page_prot);
>    198	}
>    199	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

