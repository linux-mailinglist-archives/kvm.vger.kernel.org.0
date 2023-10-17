Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4C27CCE20
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 22:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234861AbjJQUel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 16:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234143AbjJQUek (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 16:34:40 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EDC09F
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 13:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697574878; x=1729110878;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gg02HXV/DM1Y3hQtypJQLDnLAQ1YO1LltY0joN3bM5c=;
  b=BoPnK4d3Y9JYdCtAVXXQO0rBuUCHoI0Md22rKIsPxEr0YsNvyEUA52Hy
   u9NfkcgVg5Dpy8t5OFV9DjOIPU5BiZFfX1iGOjDAWU6TeA13we3w/diyi
   ILnNV0xCQxBEBZYYcsRUaFtJTJ4nahucXBhRinOg+I0p1nPbIvdGDhGjj
   Kd2bQ8XRGjoQ06ACkR1uY8A8JAZ0ur+iHkSferlNqCdIoQ/2W8mMwx4q0
   lDQ5mllq6MaqVbJz3/pou7MlBRLVFF7IkHi4pZNRZdE8syQ5XZkTJn6PD
   33LGMmeChsa7PqvtCLoHYwagFCrm3jLsLLPKxQ30nmziNCGGtEBbWBl6Q
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10866"; a="366132717"
X-IronPort-AV: E=Sophos;i="6.03,233,1694761200"; 
   d="scan'208";a="366132717"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 13:34:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10866"; a="846963335"
X-IronPort-AV: E=Sophos;i="6.03,233,1694761200"; 
   d="scan'208";a="846963335"
Received: from lkp-server02.sh.intel.com (HELO f64821696465) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Oct 2023 13:34:33 -0700
Received: from kbuild by f64821696465 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qsqlr-000A3X-1S;
        Tue, 17 Oct 2023 20:34:31 +0000
Date:   Wed, 18 Oct 2023 04:33:40 +0800
From:   kernel test robot <lkp@intel.com>
To:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        mst@redhat.com, jasowang@redhat.com, jgg@nvidia.com
Cc:     oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, si-wei.liu@oracle.com,
        leonro@nvidia.com, yishaih@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 vfio 6/9] virtio-pci: Introduce APIs to execute legacy
 IO admin commands
Message-ID: <202310180437.jo2csM6u-lkp@intel.com>
References: <20231017134217.82497-7-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231017134217.82497-7-yishaih@nvidia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yishai,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on v6.6-rc6 next-20231017]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yishai-Hadas/virtio-pci-Fix-common-config-map-for-modern-device/20231017-214450
base:   linus/master
patch link:    https://lore.kernel.org/r/20231017134217.82497-7-yishaih%40nvidia.com
patch subject: [PATCH V1 vfio 6/9] virtio-pci: Introduce APIs to execute legacy IO admin commands
config: alpha-allyesconfig (https://download.01.org/0day-ci/archive/20231018/202310180437.jo2csM6u-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231018/202310180437.jo2csM6u-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202310180437.jo2csM6u-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/virtio/virtio_pci_modern.c:731:5: warning: no previous prototype for 'virtio_pci_admin_list_query' [-Wmissing-prototypes]
     731 | int virtio_pci_admin_list_query(struct pci_dev *pdev, u8 *buf, int buf_size)
         |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/virtio/virtio_pci_modern.c:758:5: warning: no previous prototype for 'virtio_pci_admin_list_use' [-Wmissing-prototypes]
     758 | int virtio_pci_admin_list_use(struct pci_dev *pdev, u8 *buf, int buf_size)
         |     ^~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/virtio/virtio_pci_modern.c:786:5: warning: no previous prototype for 'virtio_pci_admin_legacy_io_write' [-Wmissing-prototypes]
     786 | int virtio_pci_admin_legacy_io_write(struct pci_dev *pdev, u16 opcode,
         |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/virtio/virtio_pci_modern.c:831:5: warning: no previous prototype for 'virtio_pci_admin_legacy_io_read' [-Wmissing-prototypes]
     831 | int virtio_pci_admin_legacy_io_read(struct pci_dev *pdev, u16 opcode,
         |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/virtio/virtio_pci_modern.c:877:5: warning: no previous prototype for 'virtio_pci_admin_legacy_io_notify_info' [-Wmissing-prototypes]
     877 | int virtio_pci_admin_legacy_io_notify_info(struct pci_dev *pdev,
         |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/virtio_pci_admin_list_query +731 drivers/virtio/virtio_pci_modern.c

   721	
   722	/*
   723	 * virtio_pci_admin_list_query - Provides to driver list of commands
   724	 * supported for the PCI VF.
   725	 * @dev: VF pci_dev
   726	 * @buf: buffer to hold the returned list
   727	 * @buf_size: size of the given buffer
   728	 *
   729	 * Returns 0 on success, or negative on failure.
   730	 */
 > 731	int virtio_pci_admin_list_query(struct pci_dev *pdev, u8 *buf, int buf_size)
   732	{
   733		struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
   734		struct virtio_admin_cmd cmd = {};
   735		struct scatterlist result_sg;
   736	
   737		if (!virtio_dev)
   738			return -ENODEV;
   739	
   740		sg_init_one(&result_sg, buf, buf_size);
   741		cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LIST_QUERY);
   742		cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
   743		cmd.result_sg = &result_sg;
   744	
   745		return vp_modern_admin_cmd_exec(virtio_dev, &cmd);
   746	}
   747	EXPORT_SYMBOL_GPL(virtio_pci_admin_list_query);
   748	
   749	/*
   750	 * virtio_pci_admin_list_use - Provides to device list of commands
   751	 * used for the PCI VF.
   752	 * @dev: VF pci_dev
   753	 * @buf: buffer which holds the list
   754	 * @buf_size: size of the given buffer
   755	 *
   756	 * Returns 0 on success, or negative on failure.
   757	 */
 > 758	int virtio_pci_admin_list_use(struct pci_dev *pdev, u8 *buf, int buf_size)
   759	{
   760		struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
   761		struct virtio_admin_cmd cmd = {};
   762		struct scatterlist data_sg;
   763	
   764		if (!virtio_dev)
   765			return -ENODEV;
   766	
   767		sg_init_one(&data_sg, buf, buf_size);
   768		cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LIST_USE);
   769		cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
   770		cmd.data_sg = &data_sg;
   771	
   772		return vp_modern_admin_cmd_exec(virtio_dev, &cmd);
   773	}
   774	EXPORT_SYMBOL_GPL(virtio_pci_admin_list_use);
   775	
   776	/*
   777	 * virtio_pci_admin_legacy_io_write - Write legacy registers of a member device
   778	 * @dev: VF pci_dev
   779	 * @opcode: op code of the io write command
   780	 * @offset: starting byte offset within the registers to write to
   781	 * @size: size of the data to write
   782	 * @buf: buffer which holds the data
   783	 *
   784	 * Returns 0 on success, or negative on failure.
   785	 */
 > 786	int virtio_pci_admin_legacy_io_write(struct pci_dev *pdev, u16 opcode,
   787					     u8 offset, u8 size, u8 *buf)
   788	{
   789		struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
   790		struct virtio_admin_cmd_legacy_wr_data *data;
   791		struct virtio_admin_cmd cmd = {};
   792		struct scatterlist data_sg;
   793		int vf_id;
   794		int ret;
   795	
   796		if (!virtio_dev)
   797			return -ENODEV;
   798	
   799		vf_id = pci_iov_vf_id(pdev);
   800		if (vf_id < 0)
   801			return vf_id;
   802	
   803		data = kzalloc(sizeof(*data) + size, GFP_KERNEL);
   804		if (!data)
   805			return -ENOMEM;
   806	
   807		data->offset = offset;
   808		memcpy(data->registers, buf, size);
   809		sg_init_one(&data_sg, data, sizeof(*data) + size);
   810		cmd.opcode = cpu_to_le16(opcode);
   811		cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
   812		cmd.group_member_id = cpu_to_le64(vf_id + 1);
   813		cmd.data_sg = &data_sg;
   814		ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
   815	
   816		kfree(data);
   817		return ret;
   818	}
   819	EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_io_write);
   820	
   821	/*
   822	 * virtio_pci_admin_legacy_io_read - Read legacy registers of a member device
   823	 * @dev: VF pci_dev
   824	 * @opcode: op code of the io read command
   825	 * @offset: starting byte offset within the registers to read from
   826	 * @size: size of the data to be read
   827	 * @buf: buffer to hold the returned data
   828	 *
   829	 * Returns 0 on success, or negative on failure.
   830	 */
 > 831	int virtio_pci_admin_legacy_io_read(struct pci_dev *pdev, u16 opcode,
   832					    u8 offset, u8 size, u8 *buf)
   833	{
   834		struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
   835		struct virtio_admin_cmd_legacy_rd_data *data;
   836		struct scatterlist data_sg, result_sg;
   837		struct virtio_admin_cmd cmd = {};
   838		int vf_id;
   839		int ret;
   840	
   841		if (!virtio_dev)
   842			return -ENODEV;
   843	
   844		vf_id = pci_iov_vf_id(pdev);
   845		if (vf_id < 0)
   846			return vf_id;
   847	
   848		data = kzalloc(sizeof(*data), GFP_KERNEL);
   849		if (!data)
   850			return -ENOMEM;
   851	
   852		data->offset = offset;
   853		sg_init_one(&data_sg, data, sizeof(*data));
   854		sg_init_one(&result_sg, buf, size);
   855		cmd.opcode = cpu_to_le16(opcode);
   856		cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
   857		cmd.group_member_id = cpu_to_le64(vf_id + 1);
   858		cmd.data_sg = &data_sg;
   859		cmd.result_sg = &result_sg;
   860		ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
   861	
   862		kfree(data);
   863		return ret;
   864	}
   865	EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_io_read);
   866	
   867	/*
   868	 * virtio_pci_admin_legacy_io_notify_info - Read the queue notification
   869	 * information for legacy interface
   870	 * @dev: VF pci_dev
   871	 * @req_bar_flags: requested bar flags
   872	 * @bar: on output the BAR number of the member device
   873	 * @bar_offset: on output the offset within bar
   874	 *
   875	 * Returns 0 on success, or negative on failure.
   876	 */
 > 877	int virtio_pci_admin_legacy_io_notify_info(struct pci_dev *pdev,
   878						   u8 req_bar_flags, u8 *bar,
   879						   u64 *bar_offset)
   880	{
   881		struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
   882		struct virtio_admin_cmd_notify_info_result *result;
   883		struct virtio_admin_cmd cmd = {};
   884		struct scatterlist result_sg;
   885		int vf_id;
   886		int ret;
   887	
   888		if (!virtio_dev)
   889			return -ENODEV;
   890	
   891		vf_id = pci_iov_vf_id(pdev);
   892		if (vf_id < 0)
   893			return vf_id;
   894	
   895		result = kzalloc(sizeof(*result), GFP_KERNEL);
   896		if (!result)
   897			return -ENOMEM;
   898	
   899		sg_init_one(&result_sg, result, sizeof(*result));
   900		cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO);
   901		cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
   902		cmd.group_member_id = cpu_to_le64(vf_id + 1);
   903		cmd.result_sg = &result_sg;
   904		ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
   905		if (!ret) {
   906			struct virtio_admin_cmd_notify_info_data *entry;
   907			int i;
   908	
   909			ret = -ENOENT;
   910			for (i = 0; i < VIRTIO_ADMIN_CMD_MAX_NOTIFY_INFO; i++) {
   911				entry = &result->entries[i];
   912				if (entry->flags == VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_END)
   913					break;
   914				if (entry->flags != req_bar_flags)
   915					continue;
   916				*bar = entry->bar;
   917				*bar_offset = le64_to_cpu(entry->offset);
   918				ret = 0;
   919				break;
   920			}
   921		}
   922	
   923		kfree(result);
   924		return ret;
   925	}
   926	EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_io_notify_info);
   927	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
