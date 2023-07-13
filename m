Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F612751562
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 02:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbjGMAiA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 20:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbjGMAh4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 20:37:56 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on20631.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80AC21FF7;
        Wed, 12 Jul 2023 17:37:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ColdZihzAKLCGBTP/a/2H2cSNVM28Qs88K8z5mjEFDjspvqwL/v1uoSxtlvAXsn9iF5icx1ZfKt1bDz7v1GdZP9BzoxPELcVTEKFE3cSRZjkpQ+E9qdw1+PpUzpmTmeGx0Sgcz23dXeVrj8pVo5s0GjTGRWrrB2DMeXrKpu7SbKF46u1blVtLv8jJ/sGWprJCMTvQhFaZnRCIVjbztq2Vr8FAOa2A55IuGq7r3eWJT7rSFpRpNH3Pp6c+kTB2w/CoS5o5yDMCxUm+XAk3NBqOM5NebF83RQQSRR6v/qOUjkcDIR1ejifFri95puC6XVOXS+E4WoSI4h2gAJzc/rPtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dhtzf745OaShR0kkCeRdZgSxrlKV9BRm6QPHcdGYIF0=;
 b=hj8wMWK9EkeWrdMCUh3dAmovmh7sj3AJpZ530hOhRFyzB/ejxWqrXC1SDf80yz4x5sv3LL05Ag4YsBX+ZN8ji/EeiUIIuXhbtfm7kHKAI37tq/K8ufXzL4k404cTtnvaIod9mfQAmCrutF/nfktss9r5xR7TCTMpan/EkEN1t3G558+Tla5lrHyq5FBTeCI6MIzOcxuTyo1AM4tpTa40HEvWEfH0yZhweSMLMtiC+Z0lCGX2mg00orB0TNMtsq6W8fc2VdHHjP31MJBSvDuXEJnR+nvut9sogJoVCzwXRyC5nNsG9k+xqLb4kv0sewht4xh98/EopLVLr79PyHqdrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dhtzf745OaShR0kkCeRdZgSxrlKV9BRm6QPHcdGYIF0=;
 b=h4q10k8IKBKuj8DACK0lOz/yRGHaVG5pn4ACcQMqpINoHfuW66orCjfQfiJ12ACCsQN+GlgAjjc0XfVDjxLM0m4wkJwy+MsZQ8qQV10xk6yFKrlay8gDX+sFOEZz6XJyMrP7BMVXud6XSr3LKgTGQF8is0dBZ2uVgtvfMuRRmNI=
Received: from MW4P222CA0022.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::27)
 by IA1PR12MB6601.namprd12.prod.outlook.com (2603:10b6:208:3a3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.22; Thu, 13 Jul
 2023 00:37:43 +0000
Received: from CO1NAM11FT111.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::5b) by MW4P222CA0022.outlook.office365.com
 (2603:10b6:303:114::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.22 via Frontend
 Transport; Thu, 13 Jul 2023 00:37:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT111.mail.protection.outlook.com (10.13.174.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6588.24 via Frontend Transport; Thu, 13 Jul 2023 00:37:43 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 12 Jul
 2023 19:37:41 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>
Subject: [PATCH v11 vfio 0/7] pds-vfio-pci driver
Date:   Wed, 12 Jul 2023 17:37:20 -0700
Message-ID: <20230713003727.11226-1-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT111:EE_|IA1PR12MB6601:EE_
X-MS-Office365-Filtering-Correlation-Id: 640faa6a-66c9-4e59-f9fa-08db83395f09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mQRfJgijcY3wN/2eQ+wanKt3pJgMsSJL2quqzp1cqFpvSu06XiVT/CIdjar6arTEI+Hqn45CDEhk3WpUMaxD3p61gmlByeJBtNIKP66g6PJCQ3+1MulzVFLOGealsyi4nYCkl0KlJ4BDnnx7pkU/V7rjAVc1KY5Bzkr8L4whjRlpdlYLuaIva1lOnD3TD18xfhrdSIBmlL56IOH5s49EwytWEhsWwkSj1k0NLwU3xoDmSe7ZZ+8zmEjBE1sp4x2wIG67fNG9xdGVDl+m1RK8WV5ABMHng61kdaS+xy4Rwqq9ogXBlRI/YrLM9AegiCC2SMQDToYA0KYIZMyxx6g7NorQI7Tf0U+E/Hyq+ShwkuwLdRzuKYzDzq7nd2S8CeL+SRyqy4TZJlox7C2O8Jws/tfW0U4pD9baQWloOzh164ciX4KPFHYiV8KEEimq2tZEcGm+u799h7/9SrTlzgoY61YrPi3/ISMRsDVdngdGXG1rzj64zr9vRpO/ZjVy5x5JjqzQiJytIwx6xZ/arFwjfCewTCMcEsfCnZ84+bmn9ECDr0K2N6iXEzKRtGNC6E0OXX3P2akYJAAJdz8uVEnO/uqm0GzNC011H8asfFzzmP3oO2IgA9RyDlqAMHSGiWtduSib94r/jC7/JRV+UzWmnaykiUEexsffYRCTr489dPs5ccWd+wM/Qgpuw9cqZbMbChtcK4uL+7MJH4M5IjRWKpBMTEzGl6qsl+ZlOIddvWZh71GPWEhJRhR1JZUZliuW7IBd9MXcDMtkCH6P6h7LjMEo3zxrHZk4A5kfpYF+frfo3+7vq3bNRGiqSzR97Hgccb9IXR7XGhGAlt0voxbXsA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(376002)(39860400002)(451199021)(46966006)(40470700004)(36840700001)(41300700001)(82740400003)(316002)(40460700003)(966005)(5660300002)(26005)(36756003)(1076003)(44832011)(8936002)(8676002)(83380400001)(82310400005)(426003)(47076005)(36860700001)(86362001)(81166007)(16526019)(2906002)(2616005)(30864003)(186003)(336012)(356005)(40480700001)(110136005)(54906003)(6666004)(478600001)(70586007)(70206006)(4326008)(333604002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2023 00:37:43.2202
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 640faa6a-66c9-4e59-f9fa-08db83395f09
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT111.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6601
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a patchset for a new vendor specific VFIO driver
(pds-vfio-pci) for use with the AMD/Pensando Distributed Services
Card (DSC). This driver makes use of the pds_core driver.

This driver will use the pds_core device's adminq as the VFIO
control path to the DSC. In order to make adminq calls, the VFIO
instance makes use of functions exported by the pds_core driver.

In order to receive events from pds_core, the pds-vfio-pci driver
registers to a private notifier. This is needed for various events
that come from the device.

An ASCII diagram of a VFIO instance looks something like this and can
be used with the VFIO subsystem to provide the VF device VFIO and live
migration support.

                               .------.  .-----------------------.
                               | QEMU |--|  VM  .-------------.  |
                               '......'  |      |   Eth VF    |  |
                                  |      |      .-------------.  |
                                  |      |      |  SR-IOV VF  |  |
                                  |      |      '-------------'  |
                                  |      '------------||---------'
                               .--------------.       ||
                               |/dev/<vfio_fd>|       ||
                               '--------------'       ||
Host Userspace                         |              ||
===================================================   ||
Host Kernel                            |              ||
                                  .--------.          ||
                                  |vfio-pci|          ||
                                  '--------'          ||
       .------------------.           ||              ||
       |   | exported API |<----+     ||              ||
       |   '--------------|     |     ||              ||
       |                  |    .--------------.       ||
       |     pds_core     |--->| pds-vfio-pci |       ||
       '------------------' |  '--------------'       ||
               ||           |         ||              ||
             09:00.0     notifier    09:00.1          ||
== PCI ===============================================||=====
               ||                     ||              ||
          .----------.          .----------.          ||
    ,-----|    PF    |----------|    VF    |-------------------,
    |     '----------'         |'----------'         VF        |
    |                     DSC  |                 data/control  |
    |                          |                     path      |
    -----------------------------------------------------------

The pds-vfio-pci driver is targeted to reside in drivers/vfio/pci/pds.
It makes use of and introduces new files in the common include/linux/pds
include directory.

Note: This series is based on the latest linux-next tree. I did not base
it on the Alex Williamson's vfio/next because it has not yet pulled in
the latest changes which include the pds_vdpa driver. The pds_vdpa
driver has conflicts with the pds-vfio-pci driver that needed to be
resolved, which is why this series is based on the latest linux-next
tree.

Changes:

v11:
- Various fixes/suggestions by Kevin Tian:
	- Update commit message on patch 1/7 to mention ethernet VF
	- Fix formatting
	- Check return of pci_iov_vf_id() for error
	- Update MODULE_AUTHOR to be myself
	- Remove double print of pci_id
	- Set fast_poll=true for PDS_LM_CMD_RESUME
	- Update comments around SUSPEND and SUSPEND_STATUS operations
	- Get rid of pds_vfio_deferred_reset() and just perform the
	  operations inline to the only caller
	- Rework pds_vfio_state_mutex_unlock() to be simpler
	- Rework comments in pds_vfio_recovery()
	- Append "vfio" to the end of PDS_LM_DEV_NAME
	- Remove req_len from pds_vfio_client_adminq_cmd()
	- Remove unused completion structures in pds_adminq.h
	- Fix comment above creating VFs to specify pds_core as the PF
	  device
- Various fixes/suggestions by Alex Williamson:
	- Removed cached pci_id from pds_vfio_device structure
	- Rename from pds_vfio to pds-vfio-pci
- Various fixes/suggestions by  Shameerali Kolothum Thodi:
	- Fix checking return of pds_client_register()
	- Use bool argument for flags instead of u64 on
	  pds_vfio_client_adminq_cmd()
- Fix support for VFIO_MIGRATION_P2P
- Improve member name alignment in pds_adminq.h
- Rework Kconfig based on latest changes from Alex Williamson

v10:
https://lore.kernel.org/netdev/1b5bb4df-df6f-65af-df05-08f1a4b3dacf@amd.com/
- Various fixes/suggestions by Jason Gunthorpe
	- Simplify pds_vfio_get_lm_file() based on fpga_mgr_buf_load()
	- Clean-ups/fixes based on clang-format
	- Remove any double goto labels
	- Name goto labels baesed on what needs to be cleaned/freed
	  instead of a "call from" scheme
	- Fix any goto unwind ordering issues
	- Make sure call dma_map_single() after data is written to
	  memory in pds_vfio_dma_map_lm_file()
	- Don't use bitmap_zalloc() for the dirty bitmaps
- Use vzalloc() for dirty bitmaps and refactor how the bitmaps are DMA'd
  to and from the device in pds_vfio_dirty_seq_ack()
- Remove unnecessary goto in pds_vfio_dirty_disable()

v9:
https://lore.kernel.org/netdev/20230422010642.60720-1-brett.creeley@amd.com/
- Various fixes/suggestions by Alex Williamson
	- Fix how ID is generated in client registration
	- Add helper functions to get the VF's struct device and struct
	  pci_dev pointers instead of caching the struct pci dev
	- Remove redundant pds_vfio_lm_state() function and remove any
	  places this was being called
	- Fix multi-line comments to follow standard convention
	- Remove confusing comments in
	  pds_vfio_step_device_state_locked() since the driver's
	  migration states align with the VFIO documentation
	- Validate pdsc returned from pdsc_get_pf_struct()
- Various fixes/suggestions by Jason Gunthorpe
	- Use struct pdsc instead of void *
	- Use {} instead of {0} for structure initialization
	- Use unions on the stack instead of casting to the union when
	  sending AQ commands, which required including pds_lm.h in
	  pds_adminq.h
	- Replace use of dma_alloc_coherent() when creating the sgl DMA
	  entries for the LM file
	- Remove cached struct device *coredev and instead use
	  pci_physfn() to get the pds_core's struct device pointer
	- Drop the recovery work item and call pds_vfio_recovery()
	  directly from the notifier callback
	- Remove unnecessary #define for "pds_vfio_lm" and just use the
	  string inline to the anon_inode_getfile() argument
- Fix LM file reference counting
- Move initialization of some struct members to when the struct is being
  initialized for AQ commands
- Make use of GFP_KERNEL_ACCOUNT where it makes sense
- Replace PDS_VFIO_DRV_NAME with KBUILD_MODNAME
- Update to latest pds_core exported functions
- Remove duplicated prototypes for
  pds_vfio_dma_logging_[start|stop|report] from lm.h
- Hold pds_vfio->state_mutex while starting, stopping, and reporting
  dirty page tracking in pds_vfio_dma_logging_[start|stop|report]
- Remove duplicate PDS_DEV_TYPE_LM_STR define from pds_lm.h that's
  already included in pds_common.h
- Replace use of dma_alloc_coherent() when creating the sgl DMA
  entries for the dirty bitmaps

v8:
https://lore.kernel.org/netdev/20230404190141.57762-1-brett.creeley@amd.com/
- provide default iommufd callbacks for bind_iommufd, unbind_iommufd, and
  attach_ioas for the VFIO device as suggested by Shameerali Kolothum
  Thodi

v7:
https://lore.kernel.org/netdev/20230331003612.17569-1-brett.creeley@amd.com/
- Disable and clean up dirty page tracking when the VFIO device is closed
- Various improvements suggested by Simon Horman:
	- Fix RCT in vfio_combine_iova_ranges()
	- Simplify function exit paths by removing unnecessary goto
	  labels
	- Cleanup pds_vifo_print_guest_region_info() by adding a goto
	  label for freeing memory, which allowed for reduced
	  indentation on a for loop
	- Where possible use C99 style for loops

v6:
https://lore.kernel.org/netdev/20230327200553.13951-1-brett.creeley@amd.com/
- As suggested by Alex Williamson, use pci_domain_nr() macro to make sure
  the pds_vfio client's devname is unique
- Remove unnecessary forward declaration and include
- Fix copyright comment to use correct company name
- Remove "." from struct documentation for consistency

v5:
https://lore.kernel.org/netdev/20230322203442.56169-1-brett.creeley@amd.com/
- Fix SPDX comments in .h files
- Remove adminqcq argument from pdsc_post_adminq() uses
- Unregister client on vfio_pci_core_register_device() failure
- Other minor checkpatch issues

v4:
https://lore.kernel.org/netdev/20230308052450.13421-1-brett.creeley@amd.com/
- Update cover letter ASCII diagram to reflect new driver architecture
- Remove auxiliary driver implementation
- Use pds_core's exported functions to communicate with the device
- Implement and register notifier for events from the device/pds_core
- Use module_pci_driver() macro since auxiliary driver configuration is
  no longer needed in __init/__exit

v3:
https://lore.kernel.org/netdev/20230219083908.40013-1-brett.creeley@amd.com/
- Update copyright year to 2023 and use "Advanced Micro Devices, Inc."
  for the company name
- Clarify the fact that AMD/Pensando's VFIO solution is device type
  agnostic, which aligns with other current VFIO solutions
- Add line in drivers/vfio/pci/Makefile to build pds_vfio
- Move documentation to amd sub-directory
- Remove some dead code due to the pds_core implementation of
  listening to BIND/UNBIND events
- Move a dev_dbg() to a previous patch in the series
- Add implementation for vfio_migration_ops.migration_get_data_size to
  return the maximum possible device state size

RFC to v2:
https://lore.kernel.org/all/20221214232136.64220-1-brett.creeley@amd.com/
- Implement state transitions for VFIO_MIGRATION_P2P flag
- Improve auxiliary driver probe by returning EPROBE_DEFER
  when the PCI driver is not set up correctly
- Add pointer to docs in
  Documentation/networking/device_drivers/ethernet/index.rst

RFC:
https://lore.kernel.org/all/20221207010705.35128-1-brett.creeley@amd.com/



Brett Creeley (7):
  vfio: Commonize combine_ranges for use in other VFIO drivers
  vfio/pds: Initial support for pds VFIO driver
  vfio/pds: register with the pds_core PF
  vfio/pds: Add VFIO live migration support
  vfio/pds: Add support for dirty page tracking
  vfio/pds: Add support for firmware recovery
  vfio/pds: Add Kconfig and documentation

 .../ethernet/amd/pds-vfio-pci.rst             |  79 +++
 .../device_drivers/ethernet/index.rst         |   1 +
 MAINTAINERS                                   |   7 +
 drivers/vfio/pci/Kconfig                      |   2 +
 drivers/vfio/pci/Makefile                     |   2 +
 drivers/vfio/pci/mlx5/cmd.c                   |  48 +-
 drivers/vfio/pci/pds/Kconfig                  |  19 +
 drivers/vfio/pci/pds/Makefile                 |  11 +
 drivers/vfio/pci/pds/cmds.c                   | 493 +++++++++++++++
 drivers/vfio/pci/pds/cmds.h                   |  25 +
 drivers/vfio/pci/pds/dirty.c                  | 576 ++++++++++++++++++
 drivers/vfio/pci/pds/dirty.h                  |  39 ++
 drivers/vfio/pci/pds/lm.c                     | 434 +++++++++++++
 drivers/vfio/pci/pds/lm.h                     |  41 ++
 drivers/vfio/pci/pds/pci_drv.c                | 214 +++++++
 drivers/vfio/pci/pds/pci_drv.h                |   9 +
 drivers/vfio/pci/pds/vfio_dev.c               | 227 +++++++
 drivers/vfio/pci/pds/vfio_dev.h               |  42 ++
 drivers/vfio/vfio_main.c                      |  47 ++
 include/linux/pds/pds_adminq.h                | 375 ++++++++++++
 include/linux/pds/pds_common.h                |   3 +-
 include/linux/vfio.h                          |   3 +
 22 files changed, 2649 insertions(+), 48 deletions(-)
 create mode 100644 Documentation/networking/device_drivers/ethernet/amd/pds-vfio-pci.rst
 create mode 100644 drivers/vfio/pci/pds/Kconfig
 create mode 100644 drivers/vfio/pci/pds/Makefile
 create mode 100644 drivers/vfio/pci/pds/cmds.c
 create mode 100644 drivers/vfio/pci/pds/cmds.h
 create mode 100644 drivers/vfio/pci/pds/dirty.c
 create mode 100644 drivers/vfio/pci/pds/dirty.h
 create mode 100644 drivers/vfio/pci/pds/lm.c
 create mode 100644 drivers/vfio/pci/pds/lm.h
 create mode 100644 drivers/vfio/pci/pds/pci_drv.c
 create mode 100644 drivers/vfio/pci/pds/pci_drv.h
 create mode 100644 drivers/vfio/pci/pds/vfio_dev.c
 create mode 100644 drivers/vfio/pci/pds/vfio_dev.h

-- 
2.17.1

