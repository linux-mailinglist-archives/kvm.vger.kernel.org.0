Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 144CE4B9FFC
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 13:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240353AbiBQMWD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 07:22:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240347AbiBQMWB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 07:22:01 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C619EBB95;
        Thu, 17 Feb 2022 04:21:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iZbIWOlqwdS0/XmNaQHHU4JyzeN54vgkPxKqTSVnuJfvzGUkeffnqfPEUqb1NurYG2o2o0YT1mlRjjz/k7tiJ5MMMBFiG69lHoOrrnYvh36jrP5OooqQ0qOKT6EPHxHVk/YRuyKlxhgb44GHaPgq/vduOX+OjR2eThqznPHAZO5rxWum2UegWagJUHSOY5fiq38DxT2nAExVIYrAaG+3HrfFecWZBCbe86uYD5GxtpE66uzhMmaWkKl9ksHcQH4KikgZHjt+Sg9SXtItp6UYhIQoFs0h86Y0cbQuiqsVZVufFCQ1vg7FT+2DM9Z85/pjCgw8etKFvd/yXFafzSJ+Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jmm2OblzqgIcV0xjJONbBYsEprzhXANKD8088Wzjoec=;
 b=VrowiRfOnr5ihfw4a8RUgdXX3CPB9wVwxL3vMCi/5n86euFRM7jzTVezotc+dIl7H5gxkQzrSlh/6NyxInQC2V76DatJb3Y1RfT5w4RTK5WN5O1GDgvXkSJy9KsL8bEdFVVAIiSuEyHCaRS46fL/i6r26m7Kbpnk76Zp41SMiPtDQyuMpc44ityZ9aOyN67o2HUKheKxk8JEBpTM1R325fpuUWTlygq0A2Y7ebgZhwMfYXL5qXmWl6z3z4ogB33k+w2NSp235vQZpi1c9M1fasAOH4+AMenO7AfcN2ruTyMWAaXRmGXabDEEtxKwZUUt31vr1+SmQ2il4GlF/TSxqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jmm2OblzqgIcV0xjJONbBYsEprzhXANKD8088Wzjoec=;
 b=okeXyI/fXaHB2B4KyhM4jGZCOwFSIHhQ6pv4jFkGm4ZRW0YYIXR5OFGiWOy5QMA7aa9Fxgx7Q2Uh0f5Gshmg26x+iPcUljyF5s6+A52uaNZga1y98pYt1TGt6PgNbotKySd5AUwNIYlzNoyy5MrvF+imKIElon7sZl7tNRhYsbTkFpe9MinxBPHNRb1gBFGTkLSseb3lAQqUXrQUUbi8FgF2K/r/TXNZ1oNPuBmS9znY/LEEOXFm3cE4uIyxBH28YDE1/rEiO7xh+bZXsI0qrLe0mkPJ1aDNHZb2dJTMJlW6ggR+ynIQRbGARhAuCuOag/gR9gJIsRWxAnab8WCKTQ==
Received: from DM5PR04CA0043.namprd04.prod.outlook.com (2603:10b6:3:12b::29)
 by DM4PR12MB5915.namprd12.prod.outlook.com (2603:10b6:8:68::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Thu, 17 Feb
 2022 12:21:46 +0000
Received: from DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:12b:cafe::53) by DM5PR04CA0043.outlook.office365.com
 (2603:10b6:3:12b::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14 via Frontend
 Transport; Thu, 17 Feb 2022 12:21:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT045.mail.protection.outlook.com (10.13.173.123) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Thu, 17 Feb 2022 12:21:45 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 17 Feb
 2022 12:21:25 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 17 Feb 2022
 04:21:24 -0800
Received: from nvidia-Inspiron-15-7510.nvidia.com (10.127.8.9) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.9 via
 Frontend Transport; Thu, 17 Feb 2022 04:21:21 -0800
From:   Abhishek Sahu <abhsahu@nvidia.com>
To:     <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        <linux-kernel@vger.kernel.org>, Abhishek Sahu <abhsahu@nvidia.com>
Subject: [PATCH v3 0/2] vfio/pci: fixes related with power management
Date:   Thu, 17 Feb 2022 17:51:05 +0530
Message-ID: <20220217122107.22434-1-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51326077-b708-4497-94c3-08d9f2101036
X-MS-TrafficTypeDiagnostic: DM4PR12MB5915:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB59158B603675DF2F66C6978CCC369@DM4PR12MB5915.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wNsaJMXpQOkuE2sAWV2lAoo80bGFUnN0zhSBXvV2oo7IM7tCNpQxWUNjWTLnlmJJMNM46j4IbRAVFjmwbx3I78KFvOCHGRFVvO+zEChJk0usNNnO8Wjz9D6LHBj+SR8XWVRFyeuFhFLh2hFNeYnS2KTTMIHIDlc+BoCRuoxwK3A515GwU1T5Ep0LjxwCKGmUljO2OfGdQyZiqLbtidy5OBp/I6f+poCuQT1OiEYwQ+ZCuH3l6pTbRzWPR90hxLmso7QZfX4GnkUcxHmqU+XQ+xj3QD1Nywasm2mkVhSGAhaQHWD//ZTe5wnZHEwQvQQYAOj1KfKE8M27BkAUGAOd3djN9S8JEh/lkkvenpuSe0EJx/VobJWHyhoIA1bBjdwfzGi2WIYOq7s+UWKQQ0Ess9Z7HnYWaI4aCO7ePlRy4bT2Z85bTD9yOctecbYjx++EWPGJ5Se4K4cqFQn5oyAptxRhaksRnt0O4j/JnuJn/C1RNpyQHgCc+lxHZP2ghtikFF0FjDx2FMEVBnAV/uLseFPIW5vaTwEipgPdbddfhA55FQaVzUr77jogQNB/KjBVdJp9zyDC/OR/DonufrIoiABVxzbfXSUgFKAPm7TIvT6arJm8yA/RM7fDfR896h1sCSmk36CKd+ZJ+uYDUmZsAtAJyuWExA4/+FXV2EETxq5zC4i9NA9ojCebaw5NrhTCkMFr0dS2kt9lzENQDbXc47+vjNztUvJLt5O31U1ZK0/Bpy0tGRavwqZd0B0GdBh+DUerS687uZ9MniAM1x+p37iUmLlxlOAJXquSSpYUHk0=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(36756003)(2906002)(7696005)(86362001)(356005)(8936002)(81166007)(54906003)(83380400001)(5660300002)(107886003)(6666004)(2616005)(40460700003)(110136005)(70586007)(336012)(426003)(1076003)(316002)(47076005)(70206006)(8676002)(966005)(508600001)(26005)(4326008)(82310400004)(186003)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 12:21:45.3640
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 51326077-b708-4497-94c3-08d9f2101036
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5915
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The commit 51ef3a004b1e ("vfio/pci: Restore device state on PM
transition") added a wrapper function vfio_pci_probe_power_state().
For the devices which do not have No_Soft_Reset bit set in its
PMCSR config register, inside this function, the current PCI state
will be saved locally in 'vfio_pci_core_device::pm_save' during
D0->D3hot transition and same will be restored back during D3hot->D0
transition. We have few IOCTLs and internal functions in vfio-pci
driver which can be invoked when the device power state is non-D0.
This patch series fixes issues around reset-related API's if reset
is invoked in the D3hot state.

* Changes in v3

- Split the changes into 2 patches.
- Updated comments and commit message according to updated changes.
- Added code to wakeup devices for vfio_pci_dev_set_try_reset().

* Changes in v2

- Add the Fixes tag and sent this patch independently.
- Invoke vfio_pci_set_power_state() before invoking reset related API's.
- Removed saving of power state locally.
- Removed warning before 'kfree(vdev->pm_save)'.
- Updated comments and commit message according to updated changes.

* v1 of this patch was sent in
https://lore.kernel.org/lkml/20220124181726.19174-4-abhsahu@nvidia.com/

Abhishek Sahu (2):
  vfio/pci: fix memory leak during D3hot to D0 transition
  vfio/pci: wake-up devices around reset functions

 drivers/vfio/pci/vfio_pci_core.c | 61 ++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

-- 
2.17.1

