Return-Path: <kvm+bounces-458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AE377DFD8E
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 01:34:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D225C281E09
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 00:34:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBCDC1101;
	Fri,  3 Nov 2023 00:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nVODL3Zn"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB937EC
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 00:34:28 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62D9197
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 17:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698971662; x=1730507662;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3Pt8fVwDAgej907rc78EFPw3tbD8E7fs6/CUusBrXSQ=;
  b=nVODL3ZnTP1ADyezufsfZvPf7A8X7RAX1hYjvDwh0we0kx9MafqVJKBl
   gBxCvkhIVhOZSzEeENlx0/13J1F8wMQti3vZF586v5cuff1DS+F+6w8Dv
   zl6/LPIXW2JK0n/ONRHwau6end2vvBOOTTQxgT5yZ84wrVBwCtA73zJdv
   Rxr8xH1bcBzA+E61OMbm84dcFQVHyhXNscSeVRfLDlVFlf/yXRhCuMzCt
   e57ushshr0PNiG4V3r8G0d24kCwqQeRZyx3JtF/K9DhzzXg/HE96Jax/W
   F4pHycBSaGNyuUUM0pp8WvPjDTnZrgw5Q6rsj7nAfDaB/n6GEBSgmNz+P
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10882"; a="387739248"
X-IronPort-AV: E=Sophos;i="6.03,272,1694761200"; 
   d="scan'208";a="387739248"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2023 17:34:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10882"; a="737915639"
X-IronPort-AV: E=Sophos;i="6.03,272,1694761200"; 
   d="scan'208";a="737915639"
Received: from lkp-server01.sh.intel.com (HELO 17d9e85e5079) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 02 Nov 2023 17:34:10 -0700
Received: from kbuild by 17d9e85e5079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1qyi8V-00023b-1M;
	Fri, 03 Nov 2023 00:34:07 +0000
Date: Fri, 3 Nov 2023 08:33:06 +0800
From: kernel test robot <lkp@intel.com>
To: Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
	mst@redhat.com, jasowang@redhat.com, jgg@nvidia.com
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, parav@nvidia.com,
	feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
	joao.m.martins@oracle.com, si-wei.liu@oracle.com, leonro@nvidia.com,
	yishaih@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V2 vfio 5/9] virtio-pci: Initialize the supported admin
 commands
Message-ID: <202311030838.GjyaBTjM-lkp@intel.com>
References: <20231029155952.67686-6-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231029155952.67686-6-yishaih@nvidia.com>

Hi Yishai,

kernel test robot noticed the following build warnings:

[auto build test WARNING on awilliam-vfio/for-linus]
[also build test WARNING on linus/master v6.6]
[cannot apply to awilliam-vfio/next mst-vhost/linux-next next-20231102]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yishai-Hadas/virtio-Define-feature-bit-for-administration-virtqueue/20231030-000414
base:   https://github.com/awilliam/linux-vfio.git for-linus
patch link:    https://lore.kernel.org/r/20231029155952.67686-6-yishaih%40nvidia.com
patch subject: [PATCH V2 vfio 5/9] virtio-pci: Initialize the supported admin commands
config: i386-randconfig-061-20231102 (https://download.01.org/0day-ci/archive/20231103/202311030838.GjyaBTjM-lkp@intel.com/config)
compiler: gcc-7 (Ubuntu 7.5.0-6ubuntu2) 7.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231103/202311030838.GjyaBTjM-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311030838.GjyaBTjM-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/virtio/virtio_pci_modern.c:726:16: sparse: sparse: restricted __le16 degrades to integer

vim +726 drivers/virtio/virtio_pci_modern.c

   673	
   674	static int vp_modern_admin_cmd_exec(struct virtio_device *vdev,
   675					    struct virtio_admin_cmd *cmd)
   676	{
   677		struct scatterlist *sgs[VIRTIO_AVQ_SGS_MAX], hdr, stat;
   678		struct virtio_pci_device *vp_dev = to_vp_device(vdev);
   679		struct virtio_admin_cmd_status *va_status;
   680		unsigned int out_num = 0, in_num = 0;
   681		struct virtio_admin_cmd_hdr *va_hdr;
   682		struct virtqueue *avq;
   683		u16 status;
   684		int ret;
   685	
   686		avq = virtio_has_feature(vdev, VIRTIO_F_ADMIN_VQ) ?
   687			vp_dev->admin_vq.info.vq : NULL;
   688		if (!avq)
   689			return -EOPNOTSUPP;
   690	
   691		va_status = kzalloc(sizeof(*va_status), GFP_KERNEL);
   692		if (!va_status)
   693			return -ENOMEM;
   694	
   695		va_hdr = kzalloc(sizeof(*va_hdr), GFP_KERNEL);
   696		if (!va_hdr) {
   697			ret = -ENOMEM;
   698			goto err_alloc;
   699		}
   700	
   701		va_hdr->opcode = cmd->opcode;
   702		va_hdr->group_type = cmd->group_type;
   703		va_hdr->group_member_id = cmd->group_member_id;
   704	
   705		/* Add header */
   706		sg_init_one(&hdr, va_hdr, sizeof(*va_hdr));
   707		sgs[out_num] = &hdr;
   708		out_num++;
   709	
   710		if (cmd->data_sg) {
   711			sgs[out_num] = cmd->data_sg;
   712			out_num++;
   713		}
   714	
   715		/* Add return status */
   716		sg_init_one(&stat, va_status, sizeof(*va_status));
   717		sgs[out_num + in_num] = &stat;
   718		in_num++;
   719	
   720		if (cmd->result_sg) {
   721			sgs[out_num + in_num] = cmd->result_sg;
   722			in_num++;
   723		}
   724	
   725		if (cmd->opcode == VIRTIO_ADMIN_CMD_LIST_QUERY ||
 > 726		    cmd->opcode == VIRTIO_ADMIN_CMD_LIST_USE)
   727			ret = __virtqueue_exec_admin_cmd(&vp_dev->admin_vq, sgs,
   728					       out_num, in_num,
   729					       sgs, GFP_KERNEL);
   730		else
   731			ret = virtqueue_exec_admin_cmd(&vp_dev->admin_vq, sgs,
   732					       out_num, in_num,
   733					       sgs, GFP_KERNEL);
   734		if (ret) {
   735			dev_err(&vdev->dev,
   736				"Failed to execute command on admin vq: %d\n.", ret);
   737			goto err_cmd_exec;
   738		}
   739	
   740		status = le16_to_cpu(va_status->status);
   741		if (status != VIRTIO_ADMIN_STATUS_OK) {
   742			dev_err(&vdev->dev,
   743				"admin command error: status(%#x) qualifier(%#x)\n",
   744				status, le16_to_cpu(va_status->status_qualifier));
   745			ret = -status;
   746		}
   747	
   748	err_cmd_exec:
   749		kfree(va_hdr);
   750	err_alloc:
   751		kfree(va_status);
   752		return ret;
   753	}
   754	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

