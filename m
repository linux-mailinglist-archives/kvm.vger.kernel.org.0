Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A084252B88E
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 13:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235523AbiERLRl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 07:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235498AbiERLRZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 07:17:25 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2046.outbound.protection.outlook.com [40.107.237.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598A4712CA;
        Wed, 18 May 2022 04:17:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SY6/mcc/PX40qoIeqjwGKxxnpO958f5HCU65h0PteeM0TkzPpfIyvTihR1347gBMrTB53G6Y295Z+YATMzyCaA2JLUVUymqzKkvEcDMUwBXsZ10tQWId71QM/hIkM6EsXttc+kbZGx34Cv8ox9d8g0XNDnthmpbWYanYV5MDtLf9G5az+vUm17zDlbcuUL5w07G0quSEUkz1VZRCrDgE/jIuvGm0kKfnvaR/hJKfFbUMg43Fw5NHOt5pAhRmhPY5I8jv20g1ignBAc89AN1GBM5tSTrVajdY6tgojvLGwHb6WVlrn5QcOmV/vYEQheY/Z+xCPoRrafcGX4Qk9FGXXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ckZNf76vXNF0gCLtTyWXDiodvzXxVNyqHCsixTx7kg0=;
 b=RvE9nL3dAhF944q4aEtNR3lfakX4bpcfLiu+yhqyU++OJLtMEmgEjvKt7hPXOAcvUmzcgLbQawBv/+ST3z2nnaWMdu9gHwgDv4ZWNvgbD2tTvUb1AuIlbqwVCbixZ4EUQgVIN7/v+WlMirCF0rR/WVVPTjtLZr+jwWg80SwIpdpQ8AdcuIgaxyPTSlNcdMvQ8Ear3ih/bBtvGLMVdJOgtAEybA4NwypNwQOw4O7PwPH54Hunlp4vLovdoLgX/6BZ2yFebjgEnPeEHGlb6gH3b5SL1NCA7+3KhFPW19Wy2jaNe/Ata8rnocA9OT1vCqEoAEryMVc9wwbzA9p1+spYFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ckZNf76vXNF0gCLtTyWXDiodvzXxVNyqHCsixTx7kg0=;
 b=tTUNnaVfDYi5QH0v2elMiHBSv9yGHdNXQMg4l9zl+8ch0IfWJEut8AScs3p13q6ESpqvPQhs5vjJlnvkJZh9xMWQOgnjn7bR0Ith+9Pk+JIDseCB21CwLWLi+OhzVs5mVn4YmVUmbcmUiDROF6lXrr6dS5SjH3yHF6kePJRe1lGZCpAbdwM0yGfJugB+ADG2+2QIeZ7HeAbSw0Aanna3FH4xGLXRr4rq/SFbxsXqr3/MIHGPsVU248jM05JEDAVD4AWhqZVW4ndpsTP4S9SagBWnDF7+nQ60nnwd/reFZf6ZMeoQI7CeS1Bsnau59MFDey+kp0+767LbZEtXo+ujHw==
Received: from DS7PR03CA0216.namprd03.prod.outlook.com (2603:10b6:5:3ba::11)
 by MN0PR12MB6004.namprd12.prod.outlook.com (2603:10b6:208:380::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 11:17:21 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::4) by DS7PR03CA0216.outlook.office365.com
 (2603:10b6:5:3ba::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14 via Frontend
 Transport; Wed, 18 May 2022 11:17:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5273.14 via Frontend Transport; Wed, 18 May 2022 11:17:20 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 18 May
 2022 11:16:20 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 18 May
 2022 04:16:19 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Wed, 18 May 2022 04:16:14 -0700
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
Subject: [PATCH v5 0/4] vfio/pci: power management changes
Date:   Wed, 18 May 2022 16:46:08 +0530
Message-ID: <20220518111612.16985-1-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2b71050-040e-4cd1-46c6-08da38bff9d6
X-MS-TrafficTypeDiagnostic: MN0PR12MB6004:EE_
X-Microsoft-Antispam-PRVS: <MN0PR12MB600439F104C609214A2F0F83CCD19@MN0PR12MB6004.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wfIu4kvvMbgBseMV1suafEOgduZapT709N2kYf0slta18nK1IAeHJNShllj2dSZivMtfd7ifNlxf9ybD6945DlMneoHtvYiOyIjjvd0g3FccIojUI/l1Tw+8V1lBw/0BFXrCfz5aNAWDLvks9QgY3NlgsWbqQ3tc9Iy6wys8inekKjjYo2oP0sPwLst+LVDAwupPXoth/CbjyAKKRAbGpWC22BD39aYMB79yk0lnRc5UArittz61ebrX8G0W3d0SzoPPm9jiy1GTqFV8iFbUE0QC+daQDPh4F9bzpg0hXFwBtTISswMq7OmHS3oov00wyeJPYkDjOg3ZK0NpkILqgm16qB5kTRECS+4VI87suiDG3oHZVUw8Hnen7YcZBli1QJMNl7p+SlwAia630p5O7PO82aLGyQnzj2Ws4N386FNS6U8yGLV1ZjUKEhSjeypHwaRB584uBeXTUzap7+UehIFiO7g09FsjysCezjrIzRLRMMFR+p98UBWiW7ouXfijOEPXDYVwwwgCvse6HCe3xbIeyCsvSer2vCdxe0cS8RzbYP1NbxYWPoSvzgTDKZfS0nJac7l4CxMorkqH7WFI2uMS5Xaj9q/FEdbhQSd+38Rp6B81/OhK9wBg8uTUcqQy5Oxa7ufE/KAmAU8xUfYB08gjepKQ4T1B9Pkd/AitSEEpKV3J9qKU4TKvmwiX/g0rDgP+A89LLP7y76wbnlln4L1PyZCJiVl+qg1TuDOT3Ndo1yEcMNbxT3SlB+c0y5KvUbx+T0PmFjzJS2cwvvus+GtMBI3mztetzpIna2mAilnLGXpYMJdE3WXwLO/Be1k+UzNdUkfWoQqJ8/4kFkdArA==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(86362001)(36860700001)(316002)(6666004)(36756003)(5660300002)(83380400001)(26005)(4326008)(508600001)(7696005)(8676002)(70206006)(70586007)(82310400005)(966005)(1076003)(336012)(426003)(40460700003)(186003)(8936002)(2616005)(107886003)(7416002)(54906003)(110136005)(2906002)(47076005)(356005)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 11:17:20.6575
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f2b71050-040e-4cd1-46c6-08da38bff9d6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6004
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

* Changes in v5

- Rebased over https://github.com/awilliam/linux-vfio/tree/next.
- Renamed vfio_pci_lock_and_set_power_state() to
  vfio_lock_and_set_power_state() and made it static.
- Inside vfio_pci_core_sriov_configure(), protected setting of
  power state and sriov enablement with 'memory_lock'.
- Removed CONFIG_PM macro use since it is not needed with current
  code.

* Changes in v4
  (https://lore.kernel.org/lkml/20220517100219.15146-1-abhsahu@nvidia.com)

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

 drivers/vfio/pci/vfio_pci_config.c |  56 ++++++++-
 drivers/vfio/pci/vfio_pci_core.c   | 178 ++++++++++++++++++++---------
 2 files changed, 178 insertions(+), 56 deletions(-)

-- 
2.17.1

