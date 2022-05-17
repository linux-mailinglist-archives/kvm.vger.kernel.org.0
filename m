Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 855D5529EC3
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 12:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343604AbiEQKEu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 06:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343531AbiEQKEE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 06:04:04 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2051.outbound.protection.outlook.com [40.107.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB5647393;
        Tue, 17 May 2022 03:03:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ms+6GSCAAQsiE+m4zdbckZLOph9vNxNIRETNLEXwUE7fMasDB7QP0uHC00M28JoLy0pr4NKZrtF6YaFhKoaeTn7k55NMkM/bWUELQTLjM6bOvBYtM94+/lBOCCYllTrxjpHcgxMPu2BYAQSHUHJH5KZcpgK/gQja5bj+ppZWDfeKMjuR2c+ZTPsQO45j2XolFmGl+Z0owIUXYDz+Qn6ZZVLx7fYyUFZ2QRmvxXiMsoycCPBvMFMUg7bLw55b8W88k1KqY85ytrrMoGHwOCbqPKuXzAs6c4F+BvW8r4sXuTNd5kM5rzcfUgutlARosB5/7r0ezI3t4gzLvUfxMypRkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vdME6vPxUISYgZVGmHwkzLnGlWlreSxXUxnkAsPFLI4=;
 b=jpQ754AITyHxNvLaeFjlHRD96lD4ZMLBw6BSgcAVSWBeqd/ZpKFhrgxv8fLIfuuO5iZFw3kI+R18tqTe6Pg04DFz6Daum5frE4+qF0Zynzl3FX6u90NZyNUWwcNEInmluHEI8OmF9YmGRVLNWH4fR/38+GJj9BqwarwlmH1r/4/rbEmJBcGxbS/9ZLM9rvND7IJe4LQKaiDeZJ2Ou2TMsiMfeibgemYnQJO1e/5Do5v80XdSINiOIMb3hoDEQbEfXJv58Dxaio9UMO/M05TfY3u/7z7YeT+XmzaCK0ZAIGSr3AnWzWLPV1v+03D5HEpfaks2Wv4IyUgYIoXej1IGAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vdME6vPxUISYgZVGmHwkzLnGlWlreSxXUxnkAsPFLI4=;
 b=QCeq6swzg0A8xVBZl9eWbCmrqV2l2++nP8E191lCyP+GBxpdOBvv9y2vYq3mpcAu0FblCOkjeezd8t4A/HH2I6UvebcqgGVAE+Gm3wxjGYlOU4bwAAARbu521vChpUjkwGwjlFs1SNNyXupMsicAHEL2UZfd3lqWWdTaSlZ9khZ1HSo5vUm+63nQ8J8w17t9HrR/Lrpy5ReaWa1YULqmupUF1lIJEc3EQnd9bLgQOpT/073F4S154i7neQV2w++nmqKzZYKXyPtHZx791OhgOrvvgDQJlymSsCfLpL/Hj7HDqAW4EiB1xUghrgyCz4Wlfd8WFhbS0WXFUBpn2UXf/Q==
Received: from MW4PR04CA0106.namprd04.prod.outlook.com (2603:10b6:303:83::21)
 by BN7PR12MB2660.namprd12.prod.outlook.com (2603:10b6:408:29::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.17; Tue, 17 May
 2022 10:03:18 +0000
Received: from CO1NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:83:cafe::8f) by MW4PR04CA0106.outlook.office365.com
 (2603:10b6:303:83::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13 via Frontend
 Transport; Tue, 17 May 2022 10:03:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT026.mail.protection.outlook.com (10.13.175.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Tue, 17 May 2022 10:03:18 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 17 May 2022 10:02:33 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 17 May 2022 03:02:33 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Tue, 17 May 2022 03:02:28 -0700
From:   Abhishek Sahu <abhsahu@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Abhishek Sahu <abhsahu@nvidia.com>
Subject: [PATCH v4 0/4] vfio/pci: power management changes
Date:   Tue, 17 May 2022 15:32:15 +0530
Message-ID: <20220517100219.15146-1-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cdaf3adc-81bc-4b0f-84ad-08da37ec7794
X-MS-TrafficTypeDiagnostic: BN7PR12MB2660:EE_
X-Microsoft-Antispam-PRVS: <BN7PR12MB2660C4C3D37F6612B6B157FECCCE9@BN7PR12MB2660.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vHNFWs1C7oBZocGs9Y3410CDaBE+Ztu3bdLXeGbGTIIwU88hVD+zE3edc2r3NYWXSLDWTYfELd5SoFxkYFlZXXDsuYwL+NQ/acA8tjoQTHqyDyRgNg+hZYl6BRsdX6RN+OhLKl1GULMTiJhq9Ce2lhtf1tBeaI92q/vKn8mOsjN5eJiUO2mT9n4h8uefI9zxHqyr7klV2aj597wVLTl+4GiJdaWyI6CpmxDIySXLVeaytCjsegymkhTIfLyQ3w2L+aFRBghKhCBS2L5CDX8V3MtS1+G1stMWnDE+2YXhm7tRBgQyTuNvRUyUJLsOyuI0rsL2HviP8pdMkSCVxAlKJ6W5w9EYNql+3Y7NzP6o+/jPfOSoCDcg5KtUgZMI8UMgHXchpK2/qCZsM0zXRk/ypagZ6boS7qd7dF4ZK0qq91XCBjMi2+K0woV598UvEvZWjF2CGcZu+NRu2W80mshfGH04aLzqQ0RPdJ9MitacuDRQzgfgpJQeq3QFt4HpXx0eokZYf9o3OJ4JUQ9RGcmm6jaJfmonDURuFDcSFK1EKLVo/SXNH6NlnwBW8jBV4xWieiw385F9GCTlw+euyKuI3yLUS+VQ8j7ta1WlrUGzSls6C2/FC572qbnW5HN5Xc0UCNI3IzAOf/g+mT6LOFHbMk+d/2PHL+WYVf1pOXjL9G2DjgcjO8Hk+S+ri88TqA+x2t5iNF6haVnn9FYGKu3M2TrIeBs8w6V2YWmsmSvHM8k5/JANQ1QIT60pIhmJ1RxDLKoSZNW9QCFwJxI1KDo9ZJA1TOlBTjz3WiQh7HGeZQfIAwfbaTZvwZlZEv6i8yX8pnam2Z8egnoUnVFA2nWGUg==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(508600001)(4326008)(8676002)(8936002)(70206006)(70586007)(7416002)(5660300002)(7696005)(40460700003)(966005)(86362001)(26005)(2616005)(107886003)(36756003)(336012)(47076005)(426003)(356005)(2906002)(6666004)(81166007)(36860700001)(83380400001)(186003)(1076003)(82310400005)(110136005)(316002)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 10:03:18.3284
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cdaf3adc-81bc-4b0f-84ad-08da37ec7794
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2660
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, there is very limited power management support available
in the upstream vfio-pci driver. If there is no user of vfio-pci device,
then it will be moved into D3Hot state. Similarly, if we enable the
runtime power management for vfio-pci device in the guest OS, then the
device is being runtime suspended (for linux guest OS) and the PCI
device will be put into D3hot state (in function
vfio_pm_config_write()). If the D3cold state can be used instead of
D3hot, then it will help in saving maximum power. The D3cold state can't
be possible with native PCI PM. It requires interaction with platform
firmware which is system-specific. To go into low power states
(including D3cold), the runtime PM framework can be used which
internally interacts with PCI and platform firmware and puts the device
into the lowest possible D-States.

This patch series registers the vfio-pci driver with runtime
PM framework and uses the same for moving the physical PCI
device to go into the low power state for unused idle devices.
There will be separate patch series that will add the support
for using runtime PM framework for used idle devices.

The current PM support was added with commit 6eb7018705de ("vfio-pci:
Move idle devices to D3hot power state") where the following point was
mentioned regarding D3cold state.

 "It's tempting to try to use D3cold, but we have no reason to inhibit
  hotplug of idle devices and we might get into a loop of having the
  device disappear before we have a chance to try to use it."

With the runtime PM, if the user want to prevent going into D3cold then
/sys/bus/pci/devices/.../d3cold_allowed can be set to 0 for the
devices where the above functionality is required instead of
disallowing the D3cold state for all the cases.

The BAR access needs to be disabled if device is in D3hot state.
Also, there should not be any config access if device is in D3cold
state. For SR-IOV, the PF power state should be higher than VF's power
state.

* Changes in v4

- Rebased over https://github.com/awilliam/linux-vfio/tree/next.
- Split the patch series into 2 parts. This part contains the patches
  for using runtime PM for unused idle device.
- Used the 'pdev->current_state' for checking if the device in D3 state.
- Adds the check in __vfio_pci_memory_enabled() function itself instead
  of adding power state check at each caller.
- Make vfio_pci_lock_and_set_power_state() global since it is needed
  in different files.
- Used vfio_pci_lock_and_set_power_state() instead of
  vfio_pci_set_power_state() before pci_enable_sriov().
- Inside vfio_pci_core_sriov_configure(), handled both the cases
  (the device is in low power state with and without user).
- Used list_for_each_entry_continue_reverse() in
  vfio_pci_dev_set_pm_runtime_get().

* Changes in v3
  (https://lore.kernel.org/lkml/20220425092615.10133-1-abhsahu@nvidia.com)

- Rebased patches on v5.18-rc3.
- Marked this series as PATCH instead of RFC.
- Addressed the review comments given in v2.
- Removed the limitation to keep device in D0 state if there is any
  access from host side. This is specific to NVIDIA use case and
  will be handled separately.
- Used the existing DEVICE_FEATURE IOCTL itself instead of adding new
  IOCTL for power management.
- Removed all custom code related with power management in runtime
  suspend/resume callbacks and IOCTL handling. Now, the callbacks
  contain code related with INTx handling and few other stuffs and
  all the PCI state and platform PM handling will be done by PCI core
  functions itself.
- Add the support of wake-up in main vfio layer itself since now we have
  more vfio/pci based drivers.
- Instead of assigning the 'struct dev_pm_ops' in individual parent
  driver, now the vfio_pci_core tself assigns the 'struct dev_pm_ops'. 
- Added handling of power management around SR-IOV handling.
- Moved the setting of drvdata in a separate patch.
- Masked INTx before during runtime suspended state.
- Changed the order of patches so that Fix related things are at beginning
  of this patch series.
- Removed storing the power state locally and used one new boolean to
  track the d3 (D3cold and D3hot) power state 
- Removed check for IO access in D3 power state.
- Used another helper function vfio_lock_and_set_power_state() instead
  of touching vfio_pci_set_power_state().
- Considered the fixes made in
  https://lore.kernel.org/lkml/20220217122107.22434-1-abhsahu@nvidia.com
  and updated the patches accordingly.

* Changes in v2
  (https://lore.kernel.org/lkml/20220124181726.19174-1-abhsahu@nvidia.com)

- Rebased patches on v5.17-rc1.
- Included the patch to handle BAR access in D3cold.
- Included the patch to fix memory leak.
- Made a separate IOCTL that can be used to change the power state from
  D3hot to D3cold and D3cold to D0.
- Addressed the review comments given in v1.

* v1
  https://lore.kernel.org/lkml/20211115133640.2231-1-abhsahu@nvidia.com/

Abhishek Sahu (4):
  vfio/pci: Invalidate mmaps and block the access in D3hot power state
  vfio/pci: Change the PF power state to D0 before enabling VFs
  vfio/pci: Virtualize PME related registers bits and initialize to zero
  vfio/pci: Move the unused device into low power state with runtime PM

 drivers/vfio/pci/vfio_pci_config.c |  40 +++++-
 drivers/vfio/pci/vfio_pci_core.c   | 195 +++++++++++++++++++++--------
 include/linux/vfio_pci_core.h      |   2 +
 3 files changed, 181 insertions(+), 56 deletions(-)

-- 
2.17.1

