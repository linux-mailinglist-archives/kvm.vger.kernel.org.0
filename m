Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 015C6563232
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 13:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236600AbiGALIb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 07:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236519AbiGALIa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 07:08:30 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1EFE31;
        Fri,  1 Jul 2022 04:08:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TvDukBd5PMKy0y1KwTM0O7rlfuKzJOhfNAGipbjViqtkimKlszUXdpLCHJoriGon3CFToTQAwAznGrviM1UsbMlUBEK6FdVfgD9+Zx7zIpqVBWDiXpYQsH8dYj1FZBPD5dZO2najg9K1mkvb3ozTd07CgcgQuQ+jlh63/tbkzRxm9Afr18fnXK4HB/zNtN9gqQl4iTqueP/mInd62NW6bG0uJ6F8qjnD0BnnVAAUn7G9RV2mv+TIB8xt5Kv/p1SP84p33ifa9ZSwrL2ywMPHg2x+RdkpfIcJQr50mSAPowLULSl0lN5YeN3z7p9WuVty+6zDN5oOzT/PAmAKWG3g7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sLRGBI0PTd4/f8j6mcsZXjahkT2S1E2ZDgGthYMtpSM=;
 b=OC5FetZVI07HwRW1Q2YsXwT6v4HGgGn++ICyfXRVmP5RjcKgdYscHj6xeEuTeA3tTVpuP2on9yX+LXTCVbtSKP68uwSbFEHlO57Nke/FRKWwBJou4iNWnHUoy1TfATBCw8l6+JU4MrBBJe82lnlwbdAnjmZq+asYlpDbP/uzG2DVwvfRVk+Q8JQLOMBdGmQp+Sg/gViDR0zZi7rIVBOSN6tT6s3MbdlUm1+tFdnTxAw7xQufjfg048m2inm7Bw998foY6GYyvUuRvvwwRFaowt7RW24H5K3IaHbQ2qsAXZmxuE3wv3bKm1CdkWHcndTBixJSmp0k+5xPOI2XLBvX5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sLRGBI0PTd4/f8j6mcsZXjahkT2S1E2ZDgGthYMtpSM=;
 b=UWtrwco6unUVjANJvyqaTWzmmVFpatucGcLJqLgujYj/5d+EcA3f4onI0gucJY0r1QmVw9jbDNsTt/CcXVHvBq5jRAPMM4gBWtbD2sxxmp3/XewcNGMxCSjpIMlbq7YggreLybx79NBCYv5h02aepGPxSwaM6gxKa7Cu1JA7yWTTH/4rpyRmDMLZPcCOSNFHdGxLq0CHeUAmtpTSC6yjl4dXPGoyNv0blfGqP/fUwIr7hdzFdqUTRX+NUi/lRZspzRv8M+SSOkLGiJQ4dLFNO5TCaVL7m/tThiwnCatjraQgAndIrGZjadCrhYKDqcKAlzcUs4QWH6X6FIfEfq2XOg==
Received: from MWHPR04CA0048.namprd04.prod.outlook.com (2603:10b6:300:ee::34)
 by DM4PR12MB5200.namprd12.prod.outlook.com (2603:10b6:5:397::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Fri, 1 Jul
 2022 11:08:26 +0000
Received: from CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ee:cafe::5d) by MWHPR04CA0048.outlook.office365.com
 (2603:10b6:300:ee::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Fri, 1 Jul 2022 11:08:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT049.mail.protection.outlook.com (10.13.175.50) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Fri, 1 Jul 2022 11:08:25 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Fri, 1 Jul 2022 11:08:24 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Fri, 1 Jul 2022 04:08:22 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Fri, 1 Jul 2022 04:08:17 -0700
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
Subject: [PATCH v4 0/6] vfio/pci: power management changes
Date:   Fri, 1 Jul 2022 16:38:08 +0530
Message-ID: <20220701110814.7310-1-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 114c044e-4e57-4002-3f29-08da5b5204fa
X-MS-TrafficTypeDiagnostic: DM4PR12MB5200:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?l3lWBGxjtlDUdpWc4DSF0WZcix1AAjLwrar7OhgEV/rG/AoVRJP2L3TwlJSA?=
 =?us-ascii?Q?wWya7tXbTvLpSYl/nlU6udxE/h9EqeU2PK3HnAZdhw6F/WZzIuFfVonRIX53?=
 =?us-ascii?Q?/QZChohY35+iSqWTAX6rlW8lzSuc1a9k1wu7QSiMJufQ5dO5F1P0wazk3rsw?=
 =?us-ascii?Q?FFgVWFqryOfOSTVgHRhZPWYvVWtGN2njXgFJexpt0BT9w6mHiSw6xzFr6xL+?=
 =?us-ascii?Q?yKNPiDkVtvlsQFJxClcFng6+/Nr2UvpNsvLa9DQhUdQebSVUaLLGi1XBMq5H?=
 =?us-ascii?Q?ErlJgqiyPDmomj6TV57aaFfHfp87KLuGYdW6PAwO8m/tmUUUH96T7pkqBCqk?=
 =?us-ascii?Q?vgXsVULN5B2eEN/DhEcIY7zeJgqOWGY1Dn+y0h6RclOy7NqFFO2kGJE2EtoP?=
 =?us-ascii?Q?TvFi0VR8YXy96zeHV4u23U3RkC5Zy5E3lnZcysIX4um6xFApopD1GipyCEoM?=
 =?us-ascii?Q?G6AzomDHBSYeHv9lgnoGUECdij2aHYP39NK+nuwwF2YSP+qGreh2zI8OquQA?=
 =?us-ascii?Q?c6xlerzbpn2Y1lt2v5Oa4IhAJoERzaecKlIUJ9/rZzdXrXEEl5+Rjt1EtP+1?=
 =?us-ascii?Q?7lk00QHkcY3DIakYifZFlqkNQ6RRbQzLUKX39jfYpajhDMFKlJjDaX6gbKYa?=
 =?us-ascii?Q?QXmM+iVNdWttpeeX50u5p7WCr8Y6bDTcieu7H2OWkUwnStqhSf519n55X4Xj?=
 =?us-ascii?Q?jsPxCVlKZPse1NjBzCAg0NwBAaLNupamqIjcyGLqzQ2kDbliyV3Pyd28Dt+e?=
 =?us-ascii?Q?lYAblbQQ8TMjKNbHA3BtE2iBBug3v6KFLuYd/yQtPuEeVoH/CPvLQoMdQ7lN?=
 =?us-ascii?Q?HtBJkSHuKzq/ovzdrViZ4LmhhShHXXW+0jKFsKW4KgkSfbDOuMnjG5gMAekr?=
 =?us-ascii?Q?5lskyvD0vkHVHk5D6FELvSDQhitYZZ5goTBUZESMzDYaymsWklw5vlAxCN1/?=
 =?us-ascii?Q?a0XCA9enmPAV0WzPaKsI8pi3VnmH9iwWHkR3J74JO9Y=3D?=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(39860400002)(396003)(346002)(36840700001)(46966006)(40470700004)(83380400001)(47076005)(336012)(426003)(7696005)(36860700001)(186003)(6666004)(107886003)(2616005)(40460700003)(36756003)(1076003)(26005)(966005)(70586007)(2906002)(8676002)(478600001)(41300700001)(70206006)(4326008)(81166007)(82740400003)(356005)(82310400005)(7416002)(110136005)(316002)(86362001)(40480700001)(5660300002)(8936002)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 11:08:25.4207
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 114c044e-4e57-4002-3f29-08da5b5204fa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5200
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is part 2 for the vfio-pci driver power management support.
Part 1 of this patch series was related to adding D3cold support
when there is no user of the VFIO device and has already merged in the
mainline kernel. If we enable the runtime power management for
vfio-pci device in the guest OS, then the device is being runtime
suspended (for linux guest OS) and the PCI device will be put into
D3hot state (in function vfio_pm_config_write()). If the D3cold
state can be used instead of D3hot, then it will help in saving
maximum power. The D3cold state can't be possible with native
PCI PM. It requires interaction with platform firmware which is
system-specific. To go into low power states (Including D3cold),
the runtime PM framework can be used which internally interacts
with PCI and platform firmware and puts the device into the
lowest possible D-States.

This patch series adds the support to engage runtime power management
initiated by the user. Since D3cold state can't be achieved by writing
PCI standard PM config registers, so a feature has been added in
DEVICE_FEATURE IOCTL for power management related handling. It
includes different flags which can be used for moving the device into
low power state and out of low power state. For the PCI device, this
low power state will be D3cold (if platform supports the D3cold
state). The hypervisors can implement virtual ACPI methods to make the
integration with guest OS. For example, in guest Linux OS if PCI device
ACPI node has _PR3 and _PR0 power resources with _ON/_OFF method,
then guest Linux OS makes the _OFF call during D3cold transition and
then _ON during D0 transition. The hypervisor can tap these virtual
ACPI calls and then do the low power related IOCTL.

Some devices (Like NVIDIA VGA or 3D controller) require driver
involvement each time before going into D3cold. Once the guest put the
device into D3cold, then the user can run some commands on the host side
(like lspci). The runtime PM framework will resume the device before
accessing the device and will suspend the device again. Now, this
second time suspend will be without guest driver involvement. vfio-pci
driver won't suspend the device if re-entry to low power is not
allowed. This patch series also adds virtual PME (power management
event) support which can be used to notify the guest OS for such kind
of host access. The guest can then put the device again into the
suspended state.

* Changes in v4

- Rebased patches on v5.19-rc4.
- Added virtual PME support.
- Used flags for low power entry and exit instead of explicit variable.
- Add the support to keep NVIDIA display related controllers in active
  state if there is any activity on the host side.
- Add a flag that can be set by the user to keep the device in the active
  state if there is any activity on the host side.
- Split the D3cold patch into smaller patches.
- Kept the runtime PM usage count incremented for all the IOCTL
  (except power management IOCTL) and all the PCI region access.
- Masked the runtime errors behind -EIO.
- Refactored logic in runtime suspend/resume routine and for power
  management device feature IOCTL.
- Add helper function for pm_runtime_put() also in the
  drivers/vfio/vfio.c and use the 'struct vfio_device' for the
  function parameter.
- Removed the requirement to move the device into D3hot before calling
  low power entry.
- Renamed power management related new members in the structure.
- Used 'pm_runtime_engaged' check in __vfio_pci_memory_enabled().

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

Abhishek Sahu (6):
  vfio/pci: Mask INTx during runtime suspend
  vfio: Add a new device feature for the power management
  vfio: Increment the runtime PM usage count during IOCTL call
  vfio/pci: Add the support for PCI D3cold state
  vfio/pci: Prevent low power re-entry without guest driver
  vfio/pci: Add support for virtual PME

 drivers/vfio/pci/vfio_pci_config.c |  41 +++-
 drivers/vfio/pci/vfio_pci_core.c   | 312 +++++++++++++++++++++++++++--
 drivers/vfio/pci/vfio_pci_intrs.c  |  24 ++-
 drivers/vfio/vfio.c                |  82 +++++++-
 include/linux/vfio_pci_core.h      |   8 +-
 include/uapi/linux/vfio.h          |  56 ++++++
 6 files changed, 492 insertions(+), 31 deletions(-)

-- 
2.17.1

