Return-Path: <kvm+bounces-58313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D8AD0B8CA77
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 16:42:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 975DC1B273FB
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 14:42:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF21E2F9993;
	Sat, 20 Sep 2025 14:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TTLnSCxM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683272BEC2E;
	Sat, 20 Sep 2025 14:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758379331; cv=none; b=oLP70aMh9HN7ZoXZvMeOZ5LH9duzzDOaM/Y/0XfqGqvHZgQPdrxeewfgyUgTnIHOo6DsNYtXCy4shtUDNPeXW0PgU0VzncX0382kzOmfqHq5JOahKfhTUP1u+12r5Pwv+HjmlGOTTGcW9Bt3DzBlNnbR0FvYK5viGWzvlCg4xyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758379331; c=relaxed/simple;
	bh=8ESeYby+VBnGxoL4sKU6AzMNuckA9rBZYz1Tl2yfc9U=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=L8wwzDF41Vh53V32KQ/2TWfvNcggCwz2xxgcOAtkdumn6hpu5Ziez9XuZ54LXnqyZsKIkzQjuzWIqZf4mJNOw7UCj3VBMh+NI65RKxhGINphdie+FKSMbFbshCezUoPRdNvDIG5mQFoZz5pyHEKYtWL2BNOvh/ryI1b3VTfPrAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TTLnSCxM; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758379330; x=1789915330;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=8ESeYby+VBnGxoL4sKU6AzMNuckA9rBZYz1Tl2yfc9U=;
  b=TTLnSCxM84vn0/65jAmAefENm3MqBtw8as1BhaF1W2VW8vPu4SMMvBrd
   4U8g9rheW/FI8TDk01aYHrbpFZiO0uBM/Z+ZjKn3GRcirv0LYVjy+aqT7
   CPjiyA86tysxl8oaftxjG8KUibnenfU+VURPFl9dVhInK9A/Ki+SIADMr
   DpzYaqSYOZuyP014nKS0fsGsTRdqZVa+SUqaoVzkK0cStXIDft5U0Ec0w
   Cr9FYedTX4jJ1zlK/fgTI58dTTxympKN+DgdIS4aip52z4jPPUp6CyxQF
   o4pwcKKxRIAIxR9JcCyLyvDzU+zvn697t7WX6de6/s9QAzHb5BvlGpjMw
   w==;
X-CSE-ConnectionGUID: YoUvWdWSRROE6EWEENRJVA==
X-CSE-MsgGUID: ePGH1wlcRYuxBIyP9dVoMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="60645899"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="60645899"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2025 07:42:10 -0700
X-CSE-ConnectionGUID: oLTEyd53SQGIys1VP2VHIA==
X-CSE-MsgGUID: 8S919d3NRSSML7Z5SxHNpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,281,1751266800"; 
   d="scan'208";a="206832999"
Received: from lkp-server01.sh.intel.com (HELO 84a20bd60769) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 20 Sep 2025 07:42:08 -0700
Received: from kbuild by 84a20bd60769 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uzymq-0005O7-15;
	Sat, 20 Sep 2025 14:42:04 +0000
Date: Sat, 20 Sep 2025 22:41:40 +0800
From: kernel test robot <lkp@intel.com>
To: Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
Subject: [mst-vhost:vhost 41/44] drivers/vdpa/pds/vdpa_dev.c:590:19: error:
 incompatible function pointer types initializing 's64 (*)(struct vdpa_device
 *, u16)' (aka 'long long (*)(struct vdpa_device *, unsigned short)') with an
 expression of type 'u32 (struct vdpa_device *, u16)' (aka ...
Message-ID: <202509202256.zVt4MifB-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost
head:   877102ca14b3ee9b5343d71f6420f036baf8a9fc
commit: 2951c77700c3944ecd991ede7ee77e31f47f24ab [41/44] vduse: add vq group support
config: loongarch-randconfig-001-20250920 (https://download.01.org/0day-ci/archive/20250920/202509202256.zVt4MifB-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 7c861bcedf61607b6c087380ac711eb7ff918ca6)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250920/202509202256.zVt4MifB-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509202256.zVt4MifB-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/vdpa/pds/vdpa_dev.c:590:19: error: incompatible function pointer types initializing 's64 (*)(struct vdpa_device *, u16)' (aka 'long long (*)(struct vdpa_device *, unsigned short)') with an expression of type 'u32 (struct vdpa_device *, u16)' (aka 'unsigned int (struct vdpa_device *, unsigned short)') [-Wincompatible-function-pointer-types]
     590 |         .get_vq_group           = pds_vdpa_get_vq_group,
         |                                   ^~~~~~~~~~~~~~~~~~~~~
   1 error generated.


vim +590 drivers/vdpa/pds/vdpa_dev.c

151cc834f3ddafe Shannon Nelson 2023-05-19  577  
151cc834f3ddafe Shannon Nelson 2023-05-19  578  static const struct vdpa_config_ops pds_vdpa_ops = {
151cc834f3ddafe Shannon Nelson 2023-05-19  579  	.set_vq_address		= pds_vdpa_set_vq_address,
151cc834f3ddafe Shannon Nelson 2023-05-19  580  	.set_vq_num		= pds_vdpa_set_vq_num,
151cc834f3ddafe Shannon Nelson 2023-05-19  581  	.kick_vq		= pds_vdpa_kick_vq,
151cc834f3ddafe Shannon Nelson 2023-05-19  582  	.set_vq_cb		= pds_vdpa_set_vq_cb,
151cc834f3ddafe Shannon Nelson 2023-05-19  583  	.set_vq_ready		= pds_vdpa_set_vq_ready,
151cc834f3ddafe Shannon Nelson 2023-05-19  584  	.get_vq_ready		= pds_vdpa_get_vq_ready,
151cc834f3ddafe Shannon Nelson 2023-05-19  585  	.set_vq_state		= pds_vdpa_set_vq_state,
151cc834f3ddafe Shannon Nelson 2023-05-19  586  	.get_vq_state		= pds_vdpa_get_vq_state,
151cc834f3ddafe Shannon Nelson 2023-05-19  587  	.get_vq_notification	= pds_vdpa_get_vq_notification,
151cc834f3ddafe Shannon Nelson 2023-05-19  588  	.get_vq_irq		= pds_vdpa_get_vq_irq,
151cc834f3ddafe Shannon Nelson 2023-05-19  589  	.get_vq_align		= pds_vdpa_get_vq_align,
151cc834f3ddafe Shannon Nelson 2023-05-19 @590  	.get_vq_group		= pds_vdpa_get_vq_group,
151cc834f3ddafe Shannon Nelson 2023-05-19  591  
151cc834f3ddafe Shannon Nelson 2023-05-19  592  	.get_device_features	= pds_vdpa_get_device_features,
151cc834f3ddafe Shannon Nelson 2023-05-19  593  	.set_driver_features	= pds_vdpa_set_driver_features,
151cc834f3ddafe Shannon Nelson 2023-05-19  594  	.get_driver_features	= pds_vdpa_get_driver_features,
151cc834f3ddafe Shannon Nelson 2023-05-19  595  	.set_config_cb		= pds_vdpa_set_config_cb,
151cc834f3ddafe Shannon Nelson 2023-05-19  596  	.get_vq_num_max		= pds_vdpa_get_vq_num_max,
151cc834f3ddafe Shannon Nelson 2023-05-19  597  	.get_device_id		= pds_vdpa_get_device_id,
151cc834f3ddafe Shannon Nelson 2023-05-19  598  	.get_vendor_id		= pds_vdpa_get_vendor_id,
151cc834f3ddafe Shannon Nelson 2023-05-19  599  	.get_status		= pds_vdpa_get_status,
151cc834f3ddafe Shannon Nelson 2023-05-19  600  	.set_status		= pds_vdpa_set_status,
151cc834f3ddafe Shannon Nelson 2023-05-19  601  	.reset			= pds_vdpa_reset,
151cc834f3ddafe Shannon Nelson 2023-05-19  602  	.get_config_size	= pds_vdpa_get_config_size,
151cc834f3ddafe Shannon Nelson 2023-05-19  603  	.get_config		= pds_vdpa_get_config,
151cc834f3ddafe Shannon Nelson 2023-05-19  604  	.set_config		= pds_vdpa_set_config,
151cc834f3ddafe Shannon Nelson 2023-05-19  605  };
25d1270b6e9ea89 Shannon Nelson 2023-05-19  606  static struct virtio_device_id pds_vdpa_id_table[] = {
25d1270b6e9ea89 Shannon Nelson 2023-05-19  607  	{VIRTIO_ID_NET, VIRTIO_DEV_ANY_ID},
25d1270b6e9ea89 Shannon Nelson 2023-05-19  608  	{0},
25d1270b6e9ea89 Shannon Nelson 2023-05-19  609  };
25d1270b6e9ea89 Shannon Nelson 2023-05-19  610  

:::::: The code at line 590 was first introduced by commit
:::::: 151cc834f3ddafec869269fe48036460d920d08a pds_vdpa: add support for vdpa and vdpamgmt interfaces

:::::: TO: Shannon Nelson <shannon.nelson@amd.com>
:::::: CC: Michael S. Tsirkin <mst@redhat.com>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

