Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31B5152B87A
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 13:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235513AbiERLRf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 07:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235506AbiERLR2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 07:17:28 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2050.outbound.protection.outlook.com [40.107.244.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F051E8CB08;
        Wed, 18 May 2022 04:17:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IYYscXaCNGegs6+HVjocVG70uSNIjvgxwaSNrYJl7lR6Cp/93juNbbdEmJ5idfEZLPxyoQt+aNHUWSBMJyi03Rznhcmwx4eEjRNJ477vNcOcQaxCupXP+n9orYZsYD3rY/28fUyaOByn8IHKzi2prtdnOdQJR6pe3gVkcUaKTCnJkAZm1qKeOM5NqeenLYzFCsG+qLvBJCKpDGQ1/ZrEs76pEM8VfKYkl/RvuQWkITzMrxIHSPCkyEVgSOxj3TH4mw7AdsnUfHOscBydsml/0ImZXo3Ns1Y88qnwe/CDXFwbmk5+JSLkCmZTFwMz/KK5YGkqFMGAuJyegNCLiuiWSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tIrYyeuhK0wNwHuEr6Li1fl1j3IH9Aq9af1pGxkvlUQ=;
 b=g+pzKREo4V8MEsa52Qt7WmROJ7sOB2uuveTn3iO+EriVEOlJX/ipWcB6dSv0EG+LBbgEOSeWXHv457+OKQFQ1jrAdZHJPc7/MmMQWzpt0Sxi1rXE+zoVa0EdSqMivbdpjJDSZYo7fODcCx8nZVspivHa9Ce8AvwvekjsQVNTD1L8bi26uajzDdJ3VMAfs03qLqKh/t3HceiX7QdHF1u6RSZlJHv8wFCYoc9kQTVX3kk39nzVziL4z1UX2+RbXY6S/I5H7+TX4YDAAVq33aXLfCPGebm7YwdW88K8GRKpgjdEsizgRT5P7jo7MHVHD+UwL24LxInmOqW/JjQIhCO39w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tIrYyeuhK0wNwHuEr6Li1fl1j3IH9Aq9af1pGxkvlUQ=;
 b=sVukWzgGcz1v5kZdtUMed9/36RLNIrz764+Bw4L7FU9dmwx/ryMyk79eYzW7sVFqPRwbZCeZNpY1+wogBCD67+FHPxk606eu2iQ0YulyZ/qPTX/BOmanChI5twyl1Px95Af1VajmCtfAGQtaz61k9ejT5IuNloIv1B3UZHXkSQ97AhoXyNsJEBjsvhsrd3WYo50SrVhmrTuAOSLJSlYjY43SCe4OwFC1qbXm+JaxLW7O2e3qZ2ObJfcNsFCMxT1u3isoxLa6+rU6u5YA+5C8Byr1AQEdHDO0C16PC8c5ucae3hnbNB9X6JwQ1m5DOZ47D5q3i7n/gMkWT2qbAioubA==
Received: from DS7PR03CA0212.namprd03.prod.outlook.com (2603:10b6:5:3ba::7) by
 CY4PR12MB1893.namprd12.prod.outlook.com (2603:10b6:903:127::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Wed, 18 May
 2022 11:17:22 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::9f) by DS7PR03CA0212.outlook.office365.com
 (2603:10b6:5:3ba::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.16 via Frontend
 Transport; Wed, 18 May 2022 11:17:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5273.14 via Frontend Transport; Wed, 18 May 2022 11:17:21 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 18 May
 2022 11:16:31 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 18 May
 2022 04:16:31 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Wed, 18 May 2022 04:16:25 -0700
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
Subject: [PATCH v5 2/4] vfio/pci: Change the PF power state to D0 before enabling VFs
Date:   Wed, 18 May 2022 16:46:10 +0530
Message-ID: <20220518111612.16985-3-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220518111612.16985-1-abhsahu@nvidia.com>
References: <20220518111612.16985-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02f61f80-d2cb-436e-ec47-08da38bffa81
X-MS-TrafficTypeDiagnostic: CY4PR12MB1893:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB18939A77483A8B5AB4442C0FCCD19@CY4PR12MB1893.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h6W0/6GCDYSIi8R/VLo+pC4XjZG8/nJ61+UasiWXaFzpbk7CWdwmPZJPcFmXW6iXGaLfJzwOpkPkkbmA0Px9yRymhR6gvOGa4eNinv40nKmNDLY53ekBKAR7EUjtI9Hj2DVYudY6m0Y9BqLzdeiENhd5yisdXjF3ZdUOH1k0a40SZqGb2rPxk3yuvahDt8llp/jCjN7OD8XjKAyd6sziqh4M8q6PDhE1tRaZVV6HKu0h9xsVIOMVB3LY9lSi551ZpeJJIyy/b5B9TqxKhkM8wLgZgS31BulCqTMAFMkBvNHA5szZgFI9QvFg5AG0tW82UwtO5dzoGNpMXgFyetxv7KoOzzmJ2hW+6m8gG84p+ke7E/MzwAu7EWrV8fsYtNQkLssujJoT9q/wmQIDv3RrHIF3RSAm/93lsInq8yqJTRzj2ECX9Yv0Y0TnBpGzAgRFtUoNNLjcvO5MjylW6MYyMP6gMU6aPFz99N3unYKBryIMnDPhXd/vk/BWos72Y8X1Vln/Heuto3Pm75LdSiOqAAC4r624XW9GHh+P9F3vJjaMqrhRppDgSqD2kpZSPDUSsUrRCQekDAWh9Pa0zrWMlRjHX91o1fcc6H/vUFxngSTaCYKZ+6poQAO4r0eKMCxDd4OUuiO49qnlAZLMWqXIgyjBCpNRVOYg3BdrPLW6KKBcQ90lde2aRULhmxWKadJws2Is+MTTQz+rKqXaQExvFg==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(2906002)(508600001)(110136005)(54906003)(7696005)(316002)(6666004)(8676002)(86362001)(356005)(70206006)(4326008)(81166007)(40460700003)(186003)(26005)(107886003)(5660300002)(36860700001)(336012)(426003)(1076003)(47076005)(82310400005)(7416002)(8936002)(2616005)(70586007)(36756003)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 11:17:21.7824
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02f61f80-d2cb-436e-ec47-08da38bffa81
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1893
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to [PCIe v5 9.6.2] for PF Device Power Management States

 "The PF's power management state (D-state) has global impact on its
  associated VFs. If a VF does not implement the Power Management
  Capability, then it behaves as if it is in an equivalent
  power state of its associated PF.

  If a VF implements the Power Management Capability, the Device behavior
  is undefined if the PF is placed in a lower power state than the VF.
  Software should avoid this situation by placing all VFs in lower power
  state before lowering their associated PF's power state."

From the vfio driver side, user can enable SR-IOV when the PF is in D3hot
state. If VF does not implement the Power Management Capability, then
the VF will be actually in D3hot state and then the VF BAR access will
fail. If VF implements the Power Management Capability, then VF will
assume that its current power state is D0 when the PF is D3hot and
in this case, the behavior is undefined.

To support PF power management, we need to create power management
dependency between PF and its VF's. The runtime power management support
may help with this where power management dependencies are supported
through device links. But till we have such support in place, we can
disallow the PF to go into low power state, if PF has VF enabled.
There can be a case, where user first enables the VF's and then
disables the VF's. If there is no user of PF, then the PF can put into
D3hot state again. But with this patch, the PF will still be in D0
state after disabling VF's since detecting this case inside
vfio_pci_core_sriov_configure() requires access to
struct vfio_device::open_count along with its locks. But the subsequent
patches related to runtime PM will handle this case since runtime PM
maintains its own usage count.

Also, vfio_pci_core_sriov_configure() can be called at any time
(with and without vfio pci device user), so the power state change
and SR-IOV enablement need to be protected with the required locks.

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 05a3aa95ba52..9489ceea8875 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -217,6 +217,10 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
 	bool needs_restore = false, needs_save = false;
 	int ret;
 
+	/* Prevent changing power state for PFs with VFs enabled */
+	if (pci_num_vf(pdev) && state > PCI_D0)
+		return -EBUSY;
+
 	if (vdev->needs_pm_restore) {
 		if (pdev->current_state < PCI_D3hot && state >= PCI_D3hot) {
 			pci_save_state(pdev);
@@ -1944,7 +1948,19 @@ int vfio_pci_core_sriov_configure(struct vfio_pci_core_device *vdev,
 		}
 		list_add_tail(&vdev->sriov_pfs_item, &vfio_pci_sriov_pfs);
 		mutex_unlock(&vfio_pci_sriov_pfs_mutex);
+
+		/*
+		 * The PF power state should always be higher than the VF power
+		 * state. If PF is in the low power state, then change the
+		 * power state to D0 first before enabling SR-IOV.
+		 * Also, this function can be called at any time, and userspace
+		 * PCI_PM_CTRL write can race against this code path,
+		 * so protect the same with 'memory_lock'.
+		 */
+		down_write(&vdev->memory_lock);
+		vfio_pci_set_power_state(vdev, PCI_D0);
 		ret = pci_enable_sriov(pdev, nr_virtfn);
+		up_write(&vdev->memory_lock);
 		if (ret)
 			goto out_del;
 		return nr_virtfn;
-- 
2.17.1

