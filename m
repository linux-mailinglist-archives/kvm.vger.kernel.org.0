Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B434550DC88
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 11:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235643AbiDYJ3z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 05:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236323AbiDYJ3r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 05:29:47 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2053.outbound.protection.outlook.com [40.107.95.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87BF613F7C;
        Mon, 25 Apr 2022 02:26:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P9s7L30jz5s0woeGo5yUReYWw9rb/qU8afre9euDHC59oU3tqctjsnGOLzfY3NYpcgoIX7dgAib1MqhZHxzXhHq/0PBAktybA0EDs6I7s7gqvKyU4bcqZcxvX0Q7MRMBs09v/o+N92/13CTDWRFMqefLLTdFqVhuCdSxgN97J2rXFD9EMrkhxg5kJ4vcSeVQI47dJ3xlfZABHeQznt5A9LOBquIL4LztAI26j2Az2oBU720XhjIywNbQXUh/KEWJL5dLxoSbF6W5/rylNsWqXOEKotg49n/d8UWq/zlkfTQ/ZYsP+LCCieGRItzHDvB4Bu/xfUodzxJY6Q36BRy8Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YJZVB3rj/w+KrQi8nevnsyxBbrMbLsm66b0j7qO5kbc=;
 b=bCjzTOJyNlSVSrTGApRM9dZf7qdbMC0txY+wI28Xo2TuIRjzhWt9I+sl+uGlDeDnJEhBR/LjhT7VFxFFKTB6kqyFYY2hEQPwR2GrNB/+1ls4WsxDNNAzo74YxvGkyBkOXydV38Frsu/RwM8CtjN68oQ/UJzAblZoW+MAHWiYVuuihUasFpLIZDCvSBRiWTPpEXWjn3YxnUl2UTxt2RCW1lmWPGqpBepU0hcT+/6CG9shNWsXPst4ACjXk+zD3ZtWlu2jlhjnx/ZLUreDAJZQV4wmo19BmbNtaBP8gVrvAQcsXa5s/E0J5teP9vCpW9KBQI8Uj+fqoerJblNruM41NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YJZVB3rj/w+KrQi8nevnsyxBbrMbLsm66b0j7qO5kbc=;
 b=GybILv/m7BNi8pX2lL8SuCC3Nrb5Va/1kzsJEGuDcfNPIbs95y4/adr5W5xJXYsotHn0OvFc+gvn8irVBPKTIeRwPvdyiWc2K6jJyro8g6YtAjHuqD9AutP/wO3A1E0P5b57y5vyBafjhP5p9lAy1esG8mmbhGjv9mWMQdkfFDEsLXmj965nYcXrbk9F9pfGwxZpB5KEjDTfKq8anYfwFieymUyDfRJoAOhYd/45l43wFhWHkxuTDwcVwyW1ccn7AheRtAGzILXaROYJcUdB9bIUFrGDb/6B4QWOdIxT7s5laGLVhhOedesZxIbkdDmkOzmd4tLe4pExsE46fTmrdw==
Received: from DS7PR06CA0050.namprd06.prod.outlook.com (2603:10b6:8:54::32) by
 CY4PR12MB1910.namprd12.prod.outlook.com (2603:10b6:903:128::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Mon, 25 Apr
 2022 09:26:40 +0000
Received: from DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:54:cafe::41) by DS7PR06CA0050.outlook.office365.com
 (2603:10b6:8:54::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13 via Frontend
 Transport; Mon, 25 Apr 2022 09:26:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT011.mail.protection.outlook.com (10.13.172.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Mon, 25 Apr 2022 09:26:40 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 25 Apr
 2022 09:26:39 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 25 Apr
 2022 02:26:38 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Mon, 25 Apr 2022 02:26:33 -0700
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
Subject: [PATCH v3 2/8] vfio/pci: Change the PF power state to D0 before enabling VFs
Date:   Mon, 25 Apr 2022 14:56:09 +0530
Message-ID: <20220425092615.10133-3-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220425092615.10133-1-abhsahu@nvidia.com>
References: <20220425092615.10133-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98418fc6-cc42-45cf-6810-08da269db433
X-MS-TrafficTypeDiagnostic: CY4PR12MB1910:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB19101C572E8D1C59AA000A2CCCF89@CY4PR12MB1910.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: exKQja5L45maLOHx882lX7/g0rVRG2WHUTIbGsohq8xuAH+3bE6dGO76F/79TWomPH6SHVghIbHjWe+bTj4NzOSR3+OYNCfIJy5hk6NoYi3PZyePr+8SMLcIw+bDxyUkJBA9GfchTzZOcfPWjnweRbuUlH9MYaUHgpDaeNuTkPgv7sMM0jQMHBmQUzKsTFeROGIZ7ssjxqIcWqwsSfLKNIGalF0MjQRVmsypcrp6jbX+szsskM37JLXBIeY55Oyt3DfMfzSjUXH9A5kmJ2VrxvUfN74aReVB2e0FE3u69D5GuGLov5I4yAm6vNvlfV1InPIvRl5JpnAB3Ph84CWAwz4gUZmzuKK/BMc83lvLpcIsQ+wmgpML+x+o7ZWzVQ1fQPYOsfOYoOUNkCKSeJipy7gzia1XGG5SN6EoqgOav1j77pL7BgW6qtnsDMxoWxSw+iks1m5NXyF6bkNrPDXgTt5hVbK//sDJcVtB8Rrf2PFdEw1aTPHbQD9i6ZAoBCu0FRID0DG+7wzE3LX6bOfCXLIJqs+LX8dWc3IWZnPUuPh6dDjmzIoDDoJwj0lFXYBXEzk8Fz0xLmqBPPcHtB4oGKMw1hfQF/czB7HWy9xEbaybcxXGBGX1mxUPziUzndmFp9s3oASxkMbjnBfc0esp5S8AhJOAT/h7Z0zv30ids10gWNISbKje3DB86B31mlbWA9KNKr+02l7ueI8zdI8jfg==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(36860700001)(2906002)(336012)(86362001)(47076005)(316002)(4326008)(7416002)(70206006)(70586007)(5660300002)(8676002)(8936002)(36756003)(426003)(110136005)(2616005)(54906003)(7696005)(107886003)(1076003)(6666004)(26005)(82310400005)(356005)(40460700003)(83380400001)(81166007)(508600001)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 09:26:40.0085
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 98418fc6-cc42-45cf-6810-08da269db433
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1910
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
patches related with runtime PM will handle this case since runtime PM
maintains its own usage count.

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index f3dfb033e1c4..1271728a09db 100644
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
@@ -1959,6 +1963,13 @@ int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 		}
 		list_add_tail(&vdev->sriov_pfs_item, &vfio_pci_sriov_pfs);
 		mutex_unlock(&vfio_pci_sriov_pfs_mutex);
+
+		/*
+		 * The PF power state should always be higher than the VF power
+		 * state. If PF is in the low power state, then change the
+		 * power state to D0 first before enabling SR-IOV.
+		 */
+		vfio_pci_set_power_state(vdev, PCI_D0);
 		ret = pci_enable_sriov(pdev, nr_virtfn);
 		if (ret)
 			goto out_del;
-- 
2.17.1

