Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F6D56323D
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 13:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237236AbiGALJO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 07:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237041AbiGALJD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 07:09:03 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2080.outbound.protection.outlook.com [40.107.93.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9667013F18;
        Fri,  1 Jul 2022 04:09:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UVZsEcQrD0VbQVO2AAF8Sall6Uss1qzNgArQL/X9+OkAMo8WiQv4DCutklIwwHQeCEan1phLuGcVg8OMTGSrJkPWflZ26ssqGdsidP8SLq9Qf+lbFp3ddKEKNQVYnheoGKe2CAUVva3protgpAwcLveWuPGQMiKlLWoCTH1t5ZULpfJQTHWbjluS7OGuhlPOjXEujWbbBV+fOX6gQJe9I5xx9NRrUaAkezciEMg/ItfCCTszD3IUvltWSEVy8D7QJfr/I/mK0/LiNVGzIfsOEnqgv3WMQ5B7OqTGBO/AEq2LyO4X2ENzr8zkuBFATwja4MBDJ8EhINYbCP++HjBqzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iCE5cFy902njAAaC+/8i+2QQAsppvJHr5YO5yZN4ihg=;
 b=AbH0H8NSXuOwweZPBAzjqxNYUTLLmAiMIJ9TY9UvVU24k2ywbSirdT1NlGXj9ITKIJGOP6mNuKnIqK1GkBVh6OIfrQd2ItBaXcIqgEup1EL2hZlu3gePA4Cd9LE6hwHJqd/4q4Yd7gTsiZ5lMEubOh1NybxPU45rR4MSOZBySWcilcKrtsRrpmmxdFqdjGZ/HKCggiJhKEaK6/HIiTt7aoyGwOViRZqaQk3KVx8J7mNiDbyY02NoLyADZ0TorfUGn6j7CXINjXNztZn3k0OaRdv087XFZO7SZ6oHFaTV2ElG+PvHNnyo9QF8L2l5g3a5cYYW4+diFie1qJpCdUKdrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iCE5cFy902njAAaC+/8i+2QQAsppvJHr5YO5yZN4ihg=;
 b=HWGzhNNDQ0Uag4wQIuxb1yU7y1o1ZopUPIMc5mWQhxRjWBFPxaWt2vXqNaxvA0RZHBJq11lWuMbgVRVKsNSD5wfJTEMs5Fyxo/q8xiBj8Tkqd8RVmqdc5+UtUzUM94W0KEYXslNjdRHKMd+yt+D1U0zjbMPYLTdK3oFnelSYz6t4Cd/nAJr/7EJlFPcfLAgWOjszt4D5Pj13vncNGC1j0Sxfjedqlq7DbJA8pptgCmbqa1CxmNPJQZGZQtxvKZ8f1KmIAqRWz1NmmFTn/1+x9gdycGuRQOwxnQoxAFrp2YnVn8CqhH+YOnL3ztLdq+MRUc6URxADN/QHL6F8QcQK2g==
Received: from MWHPR12CA0046.namprd12.prod.outlook.com (2603:10b6:301:2::32)
 by MN2PR12MB3440.namprd12.prod.outlook.com (2603:10b6:208:d0::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Fri, 1 Jul
 2022 11:08:58 +0000
Received: from CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:2:cafe::53) by MWHPR12CA0046.outlook.office365.com
 (2603:10b6:301:2::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Fri, 1 Jul 2022 11:08:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT051.mail.protection.outlook.com (10.13.174.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.17 via Frontend Transport; Fri, 1 Jul 2022 11:08:58 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Fri, 1 Jul 2022 11:08:57 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Fri, 1 Jul 2022 04:08:56 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Fri, 1 Jul 2022 04:08:50 -0700
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
Subject: [PATCH v4 6/6] vfio/pci: Add support for virtual PME
Date:   Fri, 1 Jul 2022 16:38:14 +0530
Message-ID: <20220701110814.7310-7-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220701110814.7310-1-abhsahu@nvidia.com>
References: <20220701110814.7310-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88f1e34e-f7d5-4f8a-6422-08da5b521888
X-MS-TrafficTypeDiagnostic: MN2PR12MB3440:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 75x93W5fMLZVOYwL8zqtTOsnk0ZFlsrTPdxIqoyPxDF+x/WEMohLtWf2phireV2fjWKTmuSe2lS+473EEZR/JvJD5kkHjBEaQPFATMAc3f/2NWPFdc6dn+EQ2xLZkX8NjtPxXxQNXJE6cIsmmT+5XnjqcGkR5u/Jthe2f11nF17CWPFDOFA6o0X/Pi/E74FfazCLiFSbPBgJKl/S/gBrAstUuYnWcMOnBcpqa88/O4NAjW3ucqqu5h/dHlct8v8sul1fCtP8JkKhtSLUduXOrW0nsRP3UEQpue4xtgwDMMJjp3ghwrJEMTgGLgnFhmabX2P/RPs6G2Qg5CsbPLTPlJB1K7VVCoqwRHPC51Faj8YrG2sZvUsdO86OZG1PL/hVDJPt34hEH12I48e0JwSpcLiAVpfqv+Olk7VuMQTW4bHEGhRVzaGxRw3mKZp87xx7okKU3/gFrXGCEYQ6fBpgqxuU/XaEPFxm1zyhOGvIQM9Kxwnn4NWDVwGLKNRYghIPifsatZ3RUxtP06J9+07IljDhFFMotCfYGX4b26OFuxhN4TT3UpW1Dyl51S/EISSlUeakYZemi7aWTGMIoYG1+zic4WXccUMqCJ+PkgGLczFehyoBMf3exyPcTp6QbxkJwt4dwuQHCk4lp1TYKdpdG549/PaCP+2OITq1j6avZmLatSwOi4zY2yye+lGp+CgGT5UPLUhHRfnCcIe9b+Gcs7rvFp88XEbLrWatXQeB4IFv3iDgM6kDFPT+g54XuWiYM42zC8l/xLN3ENEHWlTcDenlU96RSudld4GauHKpZoVIIGKkTkNZvj1/IaYr9q4OO8wkwmEevoiexLVTp2LDm0RqQ2P0aAj09SgGbr69Zy8=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(376002)(396003)(346002)(36840700001)(40470700004)(46966006)(40480700001)(7416002)(7696005)(30864003)(5660300002)(40460700003)(36860700001)(426003)(41300700001)(83380400001)(8936002)(478600001)(6666004)(2906002)(186003)(47076005)(336012)(82310400005)(316002)(82740400003)(2616005)(86362001)(54906003)(107886003)(356005)(4326008)(36756003)(110136005)(81166007)(26005)(1076003)(70206006)(8676002)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 11:08:58.1977
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 88f1e34e-f7d5-4f8a-6422-08da5b521888
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3440
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the PCI device is in low power state and the device requires
wake-up, then it can generate PME (Power Management Events). Mostly
these PME events will be propagated to the root port and then the
root port will generate the system interrupt. Then the OS should
identify the device which generated the PME and should resume
the device.

We can implement a similar virtual PME framework where if the device
already went into the runtime suspended state and then there is any
wake-up on the host side, then it will send the virtual PME
notification to the guest. This virtual PME will be helpful for the cases
where the device will not be suspended again if there is any wake-up
triggered by the host. Following is the overall approach regarding
the virtual PME.

1. Add one more event like VFIO_PCI_ERR_IRQ_INDEX named
   VFIO_PCI_PME_IRQ_INDEX and do the required code changes to get/set
   this new IRQ.

2. From the guest side, the guest needs to enable eventfd for the
   virtual PME notification.

3. In the vfio-pci driver, the PME support bits are currently
   virtualized and set to 0. We can set PME capability support for all
   the power states. This PME capability support is independent of the
   physical PME support.

4. The PME enable (PME_En bit in Power Management Control/Status
   Register) and PME status (PME_Status bit in Power Management
   Control/Status Register) are also virtualized currently.
   The write support for PME_En bit can be enabled.

5. The PME_Status bit is a write-1-clear bit where the write with
   zero value will have no effect and write with 1 value will clear the
   bit. The write for this bit will be trapped inside
   vfio_pm_config_write() similar to PCI_PM_CTRL write for PM_STATES.

6. When the host gets a request for resuming the device other than from
   low power exit feature IOCTL, then PME_Status bit will be set.
   According to [PCIe v5 7.5.2.2],
     "PME_Status - This bit is Set when the Function would normally
      generate a PME signal. The value of this bit is not affected by
      the value of the PME_En bit."

   So even if PME_En bit is not set, we can set PME_Status bit.

7. If the guest has enabled PME_En and registered for PME events
   through eventfd, then the usage count will be incremented to prevent
   the device to go into the suspended state and notify the guest through
   eventfd trigger.

The virtual PME can help in handling physical PME also. When
physical PME comes, then also the runtime resume will be called. If
the guest has registered for virtual PME, then it will be sent in this
case also.

* Implementation for handling the virtual PME on the hypervisor:

If we take the implementation in Linux OS, then during runtime suspend
time, then it calls __pci_enable_wake(). It internally enables PME
through pci_pme_active() and also enables the ACPI side wake-up
through platform_pci_set_wakeup(). To handle the PME, the hypervisor has
the following two options:

1. Create a virtual root port for the VFIO device and trigger
   interrupt when the PME comes. It will call pcie_pme_irq() which will
   resume the device.

2. Create a virtual ACPI _PRW resource and associate it with the device
   itself. In _PRW, any GPE (General Purpose Event) can be assigned for
   the wake-up. When PME comes, then GPE can be triggered by the
   hypervisor. GPE interrupt will call pci_acpi_wake_dev() function
   internally and it will resume the device.

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_config.c | 39 +++++++++++++++++++++------
 drivers/vfio/pci/vfio_pci_core.c   | 43 ++++++++++++++++++++++++------
 drivers/vfio/pci/vfio_pci_intrs.c  | 18 +++++++++++++
 include/linux/vfio_pci_core.h      |  2 ++
 include/uapi/linux/vfio.h          |  1 +
 5 files changed, 87 insertions(+), 16 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 21a4743d011f..a06375a03758 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -719,6 +719,20 @@ static int vfio_pm_config_write(struct vfio_pci_core_device *vdev, int pos,
 	if (count < 0)
 		return count;
 
+	/*
+	 * PME_STATUS is write-1-clear bit. If PME_STATUS is 1, then clear the
+	 * bit in vconfig. The PME_STATUS is in the upper byte of the control
+	 * register and user can do single byte write also.
+	 */
+	if (offset <= PCI_PM_CTRL + 1 && offset + count > PCI_PM_CTRL + 1) {
+		if (le32_to_cpu(val) &
+		    (PCI_PM_CTRL_PME_STATUS >> (offset - PCI_PM_CTRL) * 8)) {
+			__le16 *ctrl = (__le16 *)&vdev->vconfig
+					[vdev->pm_cap_offset + PCI_PM_CTRL];
+			*ctrl &= ~cpu_to_le16(PCI_PM_CTRL_PME_STATUS);
+		}
+	}
+
 	if (offset == PCI_PM_CTRL) {
 		pci_power_t state;
 
@@ -771,14 +785,16 @@ static int __init init_pci_cap_pm_perm(struct perm_bits *perm)
 	 * the user change power state, but we trap and initiate the
 	 * change ourselves, so the state bits are read-only.
 	 *
-	 * The guest can't process PME from D3cold so virtualize PME_Status
-	 * and PME_En bits. The vconfig bits will be cleared during device
-	 * capability initialization.
+	 * The guest can't process physical PME from D3cold so virtualize
+	 * PME_Status and PME_En bits. These bits will be used for the
+	 * virtual PME between host and guest. The vconfig bits will be
+	 * updated during device capability initialization. PME_Status is
+	 * write-1-clear bit, so it is read-only. We trap and update the
+	 * vconfig bit manually during write.
 	 */
 	p_setd(perm, PCI_PM_CTRL,
 	       PCI_PM_CTRL_PME_ENABLE | PCI_PM_CTRL_PME_STATUS,
-	       ~(PCI_PM_CTRL_PME_ENABLE | PCI_PM_CTRL_PME_STATUS |
-		 PCI_PM_CTRL_STATE_MASK));
+	       ~(PCI_PM_CTRL_STATE_MASK | PCI_PM_CTRL_PME_STATUS));
 
 	return 0;
 }
@@ -1454,8 +1470,13 @@ static void vfio_update_pm_vconfig_bytes(struct vfio_pci_core_device *vdev,
 	__le16 *pmc = (__le16 *)&vdev->vconfig[offset + PCI_PM_PMC];
 	__le16 *ctrl = (__le16 *)&vdev->vconfig[offset + PCI_PM_CTRL];
 
-	/* Clear vconfig PME_Support, PME_Status, and PME_En bits */
-	*pmc &= ~cpu_to_le16(PCI_PM_CAP_PME_MASK);
+	/*
+	 * Set the vconfig PME_Support bits. The PME_Status is being used for
+	 * virtual PME support and is not dependent upon the physical
+	 * PME support.
+	 */
+	*pmc |= cpu_to_le16(PCI_PM_CAP_PME_MASK);
+	/* Clear vconfig PME_Support and PME_En bits */
 	*ctrl &= ~cpu_to_le16(PCI_PM_CTRL_PME_ENABLE | PCI_PM_CTRL_PME_STATUS);
 }
 
@@ -1582,8 +1603,10 @@ static int vfio_cap_init(struct vfio_pci_core_device *vdev)
 		if (ret)
 			return ret;
 
-		if (cap == PCI_CAP_ID_PM)
+		if (cap == PCI_CAP_ID_PM) {
+			vdev->pm_cap_offset = pos;
 			vfio_update_pm_vconfig_bytes(vdev, pos);
+		}
 
 		prev = &vdev->vconfig[pos + PCI_CAP_LIST_NEXT];
 		pos = next;
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 1ddaaa6ccef5..6c1225bc2aeb 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -319,14 +319,35 @@ static int vfio_pci_core_runtime_resume(struct device *dev)
 	 *   the low power state or closed the device.
 	 * - If there is device access on the host side.
 	 *
-	 * For the second case, check if re-entry to the low power state is
-	 * allowed. If not, then increment the usage count so that runtime PM
-	 * framework won't suspend the device and set the 'pm_runtime_resumed'
-	 * flag.
+	 * For the second case:
+	 * - The virtual PME_STATUS bit will be set. If PME_ENABLE bit is set
+	 *   and user has registered for virtual PME events, then send the PME
+	 *   virtual PME event.
+	 * - Check if re-entry to the low power state is not allowed.
+	 *
+	 * For the above conditions, increment the usage count so that
+	 * runtime PM framework won't suspend the device and set the
+	 * 'pm_runtime_resumed' flag.
 	 */
-	if (vdev->pm_runtime_engaged && !vdev->pm_runtime_reentry_allowed) {
-		pm_runtime_get_noresume(dev);
-		vdev->pm_runtime_resumed = true;
+	if (vdev->pm_runtime_engaged) {
+		bool pme_triggered = false;
+		__le16 *ctrl = (__le16 *)&vdev->vconfig
+				[vdev->pm_cap_offset + PCI_PM_CTRL];
+
+		*ctrl |= cpu_to_le16(PCI_PM_CTRL_PME_STATUS);
+		if (le16_to_cpu(*ctrl) & PCI_PM_CTRL_PME_ENABLE) {
+			mutex_lock(&vdev->igate);
+			if (vdev->pme_trigger) {
+				pme_triggered = true;
+				eventfd_signal(vdev->pme_trigger, 1);
+			}
+			mutex_unlock(&vdev->igate);
+		}
+
+		if (!vdev->pm_runtime_reentry_allowed || pme_triggered) {
+			pm_runtime_get_noresume(dev);
+			vdev->pm_runtime_resumed = true;
+		}
 	}
 	up_write(&vdev->memory_lock);
 
@@ -586,6 +607,10 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 		eventfd_ctx_put(vdev->req_trigger);
 		vdev->req_trigger = NULL;
 	}
+	if (vdev->pme_trigger) {
+		eventfd_ctx_put(vdev->pme_trigger);
+		vdev->pme_trigger = NULL;
+	}
 	mutex_unlock(&vdev->igate);
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_close_device);
@@ -639,7 +664,8 @@ static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_typ
 	} else if (irq_type == VFIO_PCI_ERR_IRQ_INDEX) {
 		if (pci_is_pcie(vdev->pdev))
 			return 1;
-	} else if (irq_type == VFIO_PCI_REQ_IRQ_INDEX) {
+	} else if (irq_type == VFIO_PCI_REQ_IRQ_INDEX ||
+		   irq_type == VFIO_PCI_PME_IRQ_INDEX) {
 		return 1;
 	}
 
@@ -985,6 +1011,7 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 		switch (info.index) {
 		case VFIO_PCI_INTX_IRQ_INDEX ... VFIO_PCI_MSIX_IRQ_INDEX:
 		case VFIO_PCI_REQ_IRQ_INDEX:
+		case VFIO_PCI_PME_IRQ_INDEX:
 			break;
 		case VFIO_PCI_ERR_IRQ_INDEX:
 			if (pci_is_pcie(vdev->pdev))
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 1a37db99df48..db4180687a74 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -639,6 +639,17 @@ static int vfio_pci_set_req_trigger(struct vfio_pci_core_device *vdev,
 					       count, flags, data);
 }
 
+static int vfio_pci_set_pme_trigger(struct vfio_pci_core_device *vdev,
+				    unsigned index, unsigned start,
+				    unsigned count, uint32_t flags, void *data)
+{
+	if (index != VFIO_PCI_PME_IRQ_INDEX || start != 0 || count > 1)
+		return -EINVAL;
+
+	return vfio_pci_set_ctx_trigger_single(&vdev->pme_trigger,
+					       count, flags, data);
+}
+
 int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
 			    unsigned index, unsigned start, unsigned count,
 			    void *data)
@@ -688,6 +699,13 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
 			break;
 		}
 		break;
+	case VFIO_PCI_PME_IRQ_INDEX:
+		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
+		case VFIO_IRQ_SET_ACTION_TRIGGER:
+			func = vfio_pci_set_pme_trigger;
+			break;
+		}
+		break;
 	}
 
 	if (!func)
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 18cc83b767b8..ee2646d820c2 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -102,6 +102,7 @@ struct vfio_pci_core_device {
 	bool			bar_mmap_supported[PCI_STD_NUM_BARS];
 	u8			*pci_config_map;
 	u8			*vconfig;
+	u8			pm_cap_offset;
 	struct perm_bits	*msi_perm;
 	spinlock_t		irqlock;
 	struct mutex		igate;
@@ -133,6 +134,7 @@ struct vfio_pci_core_device {
 	int			ioeventfds_nr;
 	struct eventfd_ctx	*err_trigger;
 	struct eventfd_ctx	*req_trigger;
+	struct eventfd_ctx	*pme_trigger;
 	struct list_head	dummy_resources_list;
 	struct mutex		ioeventfds_lock;
 	struct list_head	ioeventfds_list;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 7e00de5c21ea..08170950d655 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -621,6 +621,7 @@ enum {
 	VFIO_PCI_MSIX_IRQ_INDEX,
 	VFIO_PCI_ERR_IRQ_INDEX,
 	VFIO_PCI_REQ_IRQ_INDEX,
+	VFIO_PCI_PME_IRQ_INDEX,
 	VFIO_PCI_NUM_IRQS
 };
 
-- 
2.17.1

