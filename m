Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B89A3643CEE
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 06:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234014AbiLFF7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 00:59:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233770AbiLFF7S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 00:59:18 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAFD2793F;
        Mon,  5 Dec 2022 21:59:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670306350; x=1701842350;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VBnJVd+Hc6al1XaW5PlQfaxbMT88bR8HJInkPCC3JHA=;
  b=LYfMyyXZNP80nirOweJ4PHTgk8NpF29lRc3gTUODDzFtFu7qo0NlSPg+
   61ZNPN1GZJnq7PwTkroyguMtBYbnRQKyehyCTdE1rk4RN953Ln98trDXG
   CX5YcYy09JiANM2gBJbGDd3RzNNHymFC2a83OcELW+Ni7em+Tzsd/zk9A
   YV4JrB3KVFowolplSH1d/BAnsBG/XS7hBzIysTOKtGgtKkbIGW7rKwDpY
   uUhd2cjpdKKPVhvkCJ11wdfYfDe/8D07nKnC9BMDN3YjiVcwRBNclWfYC
   TOHA2ah0j1h1JEPAk2vHVBovCwcewu1vnyzxb679PrtGTLJR17UoQyE+X
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="378706773"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="378706773"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 21:59:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="648211414"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="648211414"
Received: from leirao-pc.bj.intel.com ([10.238.156.101])
  by fmsmga007.fm.intel.com with ESMTP; 05 Dec 2022 21:58:54 -0800
From:   Lei Rao <lei.rao@intel.com>
To:     kbusch@kernel.org, axboe@fb.com, kch@nvidia.com, hch@lst.de,
        sagi@grimberg.me, alex.williamson@redhat.com, cohuck@redhat.com,
        jgg@ziepe.ca, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        mjrosato@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, kvm@vger.kernel.org
Cc:     eddie.dong@intel.com, yadong.li@intel.com, yi.l.liu@intel.com,
        Konrad.wilk@oracle.com, stephen@eideticom.com, hang.yuan@intel.com,
        Lei Rao <lei.rao@intel.com>
Subject: [RFC PATCH 5/5] nvme-vfio: Add a document for the NVMe device
Date:   Tue,  6 Dec 2022 13:58:16 +0800
Message-Id: <20221206055816.292304-6-lei.rao@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221206055816.292304-1-lei.rao@intel.com>
References: <20221206055816.292304-1-lei.rao@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The documentation describes the details of the NVMe hardware
extension to support VFIO live migration.

Signed-off-by: Lei Rao <lei.rao@intel.com>
Signed-off-by: Yadong Li <yadong.li@intel.com>
Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Eddie Dong <eddie.dong@intel.com>
Reviewed-by: Hang Yuan <hang.yuan@intel.com>
---
 drivers/vfio/pci/nvme/nvme.txt | 278 +++++++++++++++++++++++++++++++++
 1 file changed, 278 insertions(+)
 create mode 100644 drivers/vfio/pci/nvme/nvme.txt

diff --git a/drivers/vfio/pci/nvme/nvme.txt b/drivers/vfio/pci/nvme/nvme.txt
new file mode 100644
index 000000000000..eadcf2082eed
--- /dev/null
+++ b/drivers/vfio/pci/nvme/nvme.txt
@@ -0,0 +1,278 @@
+===========================
+NVMe Live Migration Support
+===========================
+
+Introduction
+------------
+To support live migration, NVMe device designs its own implementation,
+including five new specific admin commands and a capability flag in
+the vendor-specific field in the identify controller data structure to
+support VF's live migration usage. Software can use these live migration
+admin commands to get device migration state data size, save and load the
+data, suspend and resume the given VF device. They are submitted by software
+to the NVMe PF device's admin queue and ignored if placed in the VF device's
+admin queue. This is due to the NVMe VF device being passed to the virtual
+machine in the virtualization scenario. So VF device's admin queue is not
+available for the hypervisor to submit VF device live migration commands.
+The capability flag in the identify controller data structure can be used by
+software to detect if the NVMe device supports live migration. The following
+chapters introduce the detailed format of the commands and the capability flag.
+
+Definition of opcode for live migration commands
+------------------------------------------------
+
++---------------------------+-----------+-----------+------------+
+|                           |           |           |            |
+|     Opcode by Field       |           |           |            |
+|                           |           |           |            |
++--------+---------+--------+           |           |            |
+|        |         |        | Combined  | Namespace |            |
+|    07  |  06:02  | 01:00  |  Opcode   | Identifier|  Command   |
+|        |         |        |           |    used   |            |
++--------+---------+--------+           |           |            |
+|Generic | Function|  Data  |           |           |            |
+|command |         |Transfer|           |           |            |
++--------+---------+--------+-----------+-----------+------------+
+|                                                                |
+|                     Vendor SpecificOpcode                      |
++--------+---------+--------+-----------+-----------+------------+
+|        |         |        |           |           | Query the  |
+|   1b   |  10001  |  00    |   0xC4    |           | data size  |
++--------+---------+--------+-----------+-----------+------------+
+|        |         |        |           |           | Suspend the|
+|   1b   |  10010  |  00    |   0xC8    |           |    VF      |
++--------+---------+--------+-----------+-----------+------------+
+|        |         |        |           |           | Resume the |
+|   1b   |  10011  |  00    |   0xCC    |           |    VF      |
++--------+---------+--------+-----------+-----------+------------+
+|        |         |        |           |           | Save the   |
+|   1b   |  10100  |  10    |   0xD2    |           |device data |
++--------+---------+--------+-----------+-----------+------------+
+|        |         |        |           |           | Load the   |
+|   1b   |  10101  |  01    |   0xD5    |           |device data |
++--------+---------+--------+-----------+-----------+------------+
+
+Definition of QUERY_DATA_SIZE command
+-------------------------------------
+
++---------+------------------------------------------------------------------------------------+
+|         |                                                                                    |
+|   Bytes |                                    Description                                     |
+|         |                                                                                    |
++---------+------------------------------------------------------------------------------------+
+|         |                                                                                    |
+|         |                                                                                    |
+|         | +-----------+--------------------------------------------------------------------+ |
+|         | |  Bits     |Description                                                         | |
+|         | +-----------+--------------------------------------------------------------------+ |
+|         | |  07:00    |Opcode(OPC):set to 0xC4 to indicate a qeury command                 | |
+|         | +-----------+--------------------------------------------------------------------+ |
+|         | |  09:08    |Fused Operation(FUSE):Please see NVMe SPEC for more details[1]      | |
+|         | +-----------+--------------------------------------------------------------------+ |
+|  03:00  | |  13:10    |Reserved                                                            | |
+|         | +-----------+--------------------------------------------------------------------+ |
+|         | |  15:14    |PRP or SGL for Data Transfer(PSDT): See NVMe SPEC for details[1]    | |
+|         | +-----------+--------------------------------------------------------------------+ |
+|         | |  31:16    |Command Identifier(CID)                                             | |
+|         | +-----------+--------------------------------------------------------------------+ |
+|         |                                                                                    |
+|         |                                                                                    |
++---------+------------------------------------------------------------------------------------+
+|  39:04  |  Reserved                                                                          |
++---------+------------------------------------------------------------------------------------+
+|  41:40  |  VF index: means which VF controller internal data size to query                   |
++---------+------------------------------------------------------------------------------------+
+|  63:42  |  Reserved                                                                          |
++---------+------------------------------------------------------------------------------------+
+
+The QUERY_DATA_SIZE command is used to query the NVMe VF internal data size for live migration.
+When the NVMe firmware receives the command, it will return the size of NVMe VF internal
+data. The data size depends on how many IO queues are created.
+
+Definition of SUSPEND command
+-----------------------------
+
++---------+------------------------------------------------------------------------------------+
+|         |                                                                                    |
+|   Bytes |                                    Description                                     |
+|         |                                                                                    |
++---------+------------------------------------------------------------------------------------+
+|         |                                                                                    |
+|         |                                                                                    |
+|         | +-----------+--------------------------------------------------------------------+ |
+|         | |  Bits     |Description                                                         | |
+|         | +-----------+--------------------------------------------------------------------+ |
+|         | |  07:00    |Opcode(OPC):set to 0xC8 to indicate a suspend command               | |
+|         | +-----------+--------------------------------------------------------------------+ |
+|         | |  09:08    |Fused Operation(FUSE):Please see NVMe specification for details[1]  | |
+|         | +-----------+--------------------------------------------------------------------+ |
+|  03:00  | |  13:10    |Reserved                                                            | |
+|         | +-----------+--------------------------------------------------------------------+ |
+|         | |  15:14    |PRP or SGL for Data Transfer(PSDT):See NVMe SPEC for details[1]     | |
+|         | +-----------+--------------------------------------------------------------------+ |
+|         | |  31:16    |Command Identifier(CID)                                             | |
+|         | +-----------+--------------------------------------------------------------------+ |
+|         |                                                                                    |
+|         |                                                                                    |
++---------+------------------------------------------------------------------------------------+
+|  39:04  |  Reserved                                                                          |
++---------+------------------------------------------------------------------------------------+
+|  41:40  |  VF index: means which VF controller to suspend                                    |
++---------+------------------------------------------------------------------------------------+
+|  63:42  |  Reserved                                                                          |
++---------+------------------------------------------------------------------------------------+
+
+The SUSPEND command is used to suspend the NVMe VF controller. When the NVMe firmware receives
+this command, it will suspend the NVMe VF controller.
+
+Definition of RESUME command
+----------------------------
+
++---------+------------------------------------------------------------------------------------+
+|         |                                                                                    |
+|   Bytes |                                    Description                                     |
+|         |                                                                                    |
++---------+------------------------------------------------------------------------------------+
+|         |                                                                                    |
+|         |                                                                                    |
+|         | +-----------+--------------------------------------------------------------------+ |
+|         | |  Bits     |Description                                                         | |
+|         | +-----------+--------------------------------------------------------------------+ |
+|         | |  07:00    |Opcode(OPC):set to 0xCC to indicate a resume command                | |
+|         | +-----------+--------------------------------------------------------------------+ |
+|         | |  09:08    |Fused Operation(FUSE):Please see NVMe SPEC for details[1]           | |
+|         | +-----------+--------------------------------------------------------------------+ |
+|  03:00  | |  13:10    |Reserved                                                            | |
+|         | +-----------+--------------------------------------------------------------------+ |
+|         | |  15:14    |PRP or SGL for Data Transfer(PSDT):See NVMe SPEC for details[1]     | |
+|         | +-----------+--------------------------------------------------------------------+ |
+|         | |  31:16    |Command Identifier(CID)                                             | |
+|         | +-----------+--------------------------------------------------------------------+ |
+|         |                                                                                    |
+|         |                                                                                    |
++---------+------------------------------------------------------------------------------------+
+|  39:04  |  Reserved                                                                          |
++---------+------------------------------------------------------------------------------------+
+|  41:40  |  VF index: means which VF controller to resume                                     |
++---------+------------------------------------------------------------------------------------+
+|  63:42  |  Reserved                                                                          |
++---------+------------------------------------------------------------------------------------+
+
+The RESUME command is used to resume the NVMe VF controller. When firmware receives this command,
+it will restart the NVMe VF controller.
+
+Definition of SAVE_DATA command
+--------------------------
+
++---------+------------------------------------------------------------------------------------+
+|         |                                                                                    |
+|   Bytes |                                    Description                                     |
+|         |                                                                                    |
++---------+------------------------------------------------------------------------------------+
+|         |                                                                                    |
+|         |                                                                                    |
+|         | +-----------+--------------------------------------------------------------------+ |
+|         | |  Bits     |Description                                                         | |
+|         | +-----------+--------------------------------------------------------------------+ |
+|         | |  07:00    |Opcode(OPC):set to 0xD2 to indicate a save command                  | |
+|         | +-----------+--------------------------------------------------------------------+ |
+|         | |  09:08    |Fused Operation(FUSE):Please see NVMe SPEC for details[1]           | |
+|         | +-----------+--------------------------------------------------------------------+ |
+|  03:00  | |  13:10    |Reserved                                                            | |
+|         | +-----------+--------------------------------------------------------------------+ |
+|         | |  15:14    |PRP or SGL for Data Transfer(PSDT):See NVMe SPEC for details[1]     | |
+|         | +-----------+--------------------------------------------------------------------+ |
+|         | |  31:16    |Command Identifier(CID)                                             | |
+|         | +-----------+--------------------------------------------------------------------+ |
+|         |                                                                                    |
+|         |                                                                                    |
++---------+------------------------------------------------------------------------------------+
+|  23:04  | Reserved                                                                           |
++---------+------------------------------------------------------------------------------------+
+|  31:24  | PRP Entry1:the first PRP entry for the commmand or a PRP List Pointer              |
++---------+------------------------------------------------------------------------------------+
+|  39:32  | PRP Entry2:the second address entry(reserved,page base address or PRP List Pointer)|
++---------+------------------------------------------------------------------------------------+
+|  41:40  | VF index: means which VF controller internal data to save                          |
++---------+------------------------------------------------------------------------------------+
+|  63:42  | Reserved                                                                           |
++---------+------------------------------------------------------------------------------------+
+
+The SAVE_DATA command is used to save the NVMe VF internal data for live migration. When firmware
+receives this command, it will save the admin queue states, save some registers, drain IO SQs
+and CQs, save every IO queue state, disable the VF controller, and transfer all data to the
+host memory through DMA.
+
+Definition of LOAD_DATA command
+--------------------------
+
++---------+------------------------------------------------------------------------------------+
+|         |                                                                                    |
+|   Bytes |                                    Description                                     |
+|         |                                                                                    |
++---------+------------------------------------------------------------------------------------+
+|         |                                                                                    |
+|         |                                                                                    |
+|         | +-----------+--------------------------------------------------------------------+ |
+|         | |  Bits     |Description                                                         | |
+|         | +-----------+--------------------------------------------------------------------+ |
+|         | |  07:00    |Opcode(OPC):set to 0xD5 to indicate a load command                  | |
+|         | +-----------+--------------------------------------------------------------------+ |
+|         | |  09:08    |Fused Operation(FUSE):Please see NVMe SPEC for details[1]           | |
+|         | +-----------+--------------------------------------------------------------------+ |
+|  03:00  | |  13:10    |Reserved                                                            | |
+|         | +-----------+--------------------------------------------------------------------+ |
+|         | |  15:14    |PRP or SGL for Data Transfer(PSDT): See NVMe SPEC for details[1]    | |
+|         | +-----------+--------------------------------------------------------------------+ |
+|         | |  31:16    |Command Identifier(CID)                                             | |
+|         | +-----------+--------------------------------------------------------------------+ |
+|         |                                                                                    |
+|         |                                                                                    |
++---------+------------------------------------------------------------------------------------+
+|  23:04  | Reserved                                                                           |
++---------+------------------------------------------------------------------------------------+
+|  31:24  | PRP Entry1:the first PRP entry for the commmand or a PRP List Pointer              |
++---------+------------------------------------------------------------------------------------+
+|  39:32  | PRP Entry2:the second address entry(reserved,page base address or PRP List Pointer)|
++---------+------------------------------------------------------------------------------------+
+|  41:40  | VF index: means which VF controller internal data to load                          |
++---------+------------------------------------------------------------------------------------+
+|  47:44  | Size: means the size of the device's internal data to be loaded                    |
++---------+------------------------------------------------------------------------------------+
+|  63:48  | Reserved                                                                           |
++---------+------------------------------------------------------------------------------------+
+
+The LOAD_DATA command is used to restore the NVMe VF internal data. When firmware receives this
+command, it will read the device internal's data from the host memory through DMA, restore the
+admin queue states and some registers, and restore every IO queue state.
+
+Extensions of the vendor-specific field in the identify controller data structure
+---------------------------------------------------------------------------------
+
++---------+------+------+------+-------------------------------+
+|         |      |      |      |                               |
+|  Bytes  | I/O  |Admin | Disc |        Description            |
+|         |      |      |      |                               |
++---------+------+------+------+-------------------------------+
+|         |      |      |      |                               |
+| 01:00   |  M   |  M   |  R   | PCI Vendor ID(VID)            |
++---------+------+------+------+-------------------------------+
+|         |      |      |      |                               |
+| 03:02   |  M   |  M   |  R   | PCI Subsytem Vendor ID(SSVID) |
++---------+------+------+------+-------------------------------+
+|         |      |      |      |                               |
+|  ...    | ...  | ...  | ...  |  ...                          |
++---------+------+------+------+-------------------------------+
+|         |      |      |      |                               |
+|  3072   |  O   |  O   |  O   | Live Migration Support        |
++---------+------+------+------+-------------------------------+
+|         |      |      |      |                               |
+|4095:3073|  O   |  O   |  O   | Vendor Specific               |
++---------+------+------+------+-------------------------------+
+
+According to NVMe specification, the bytes from 3072 to 4095 are vendor-specific fields.
+NVMe device uses the 3072 bytes in the identify controller data structure to indicate
+whether live migration is supported. 0x0 means live migration is not supported. 0x01 means
+live migration is supported, and other values are reserved.
+
+[1] https://nvmexpress.org/wp-content/uploads/NVMe-NVM-Express-2.0a-2021.07.26-Ratified.pdf
-- 
2.34.1

