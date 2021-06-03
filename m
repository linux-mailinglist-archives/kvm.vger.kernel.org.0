Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16AEF39A55E
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 18:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbhFCQKa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 12:10:30 -0400
Received: from mail-bn7nam10on2055.outbound.protection.outlook.com ([40.107.92.55]:28416
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230138AbhFCQK3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 12:10:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fEvWKW43fawI4t4xAlTltv29NO6LzZIVfAq345y48DPfdXwF79VaJzSqwHe3gJPqijIteL4AYuWxI5Eeg9ARMrRnPt8Xf+Sh5911rSUiLia+SsumgQTd8k0NxfzjfI/Xcak9vbh1ZD4FaBwxHQrAGd74xMM1NWR9DZuHaFnUE23Ca6pgOpfHqJIFpUZL2FVhE+wQCjtUuIeCf8U+MP6Y2fdDoPTfRg4DOOTnD2J12XdKdx9PU+ArbmBPQoNS2PRBtZPbGmBzcTB05wZUYCsRdgOa8Ujchgz3WRhLemd9B/d9KSr827Ax635xCSAWzSymvI4LP70N+fCSF2fhC+omCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNNy0w3qmBeWzCWsJs7/vAbXPuVBX+0TqT6TMURXvTg=;
 b=m5NaU0bFQxMqJS2nDlBDlY+hH+LwDvmhOnakOqNohqm326LB32ofOqzinfmM644IZ2LQBqlHsfUF9MwXiDeuiKlTSQA7hX3Df7tdib/CKoT71XC6F+AwHvvrghEWOFwUJDOmaAtkLq1AW58StUkDUNjIQodptSZN9p04ifz6IntmO/2vHjhOIliKJKEJ4cfg0mJitW9pyVST9rZUJWs5QyJqWWYY2kXV8D4YgJez6F6dEzKy5BlZAfq70tEGdVIaMTfq6wDZC5Op5qXAsTstk0t/LPHHWmzF1P6aYyeWhQjNcef/lBZmKkziWogCKKPUo3nognmwf4JaEjdS4xzpkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNNy0w3qmBeWzCWsJs7/vAbXPuVBX+0TqT6TMURXvTg=;
 b=B89k9F3Qp4ylQIMBxF8rUpEK65+sO7mfpKFA16RlqteOBmaY97ahVTdUwV0hqsrr5G80j06VrJyUIk64k8svsWUGkZptUBmSwftnoBIJZYP6b3feA/mn8wokbQoMycM53Vj2358jbhmEyODwdOhVAdlBWU/t/gg9M3QA+ASwRD0nd2olyon40fjytmHrdKRVguu6toReX1/WqnklGkf6NdT9hcCqp0rIUuxh+9vTc3ozv0fIrR2F1mIB+RYQbmgV/5Eg2Tztlwa4JPI8ZD9W17p5MAKZCWeGdMmJsiXFk1v4grgesn2/U/5OakX/x5TWk3Tk4eIFfyLiMyEiaJ/+Sw==
Received: from MWHPR04CA0026.namprd04.prod.outlook.com (2603:10b6:300:ee::12)
 by DM6PR12MB3275.namprd12.prod.outlook.com (2603:10b6:5:185::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.27; Thu, 3 Jun
 2021 16:08:43 +0000
Received: from CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ee:cafe::2b) by MWHPR04CA0026.outlook.office365.com
 (2603:10b6:300:ee::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend
 Transport; Thu, 3 Jun 2021 16:08:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT042.mail.protection.outlook.com (10.13.174.250) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 16:08:42 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 16:08:41 +0000
Received: from r-arch-stor02.mtr.labs.mlnx (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Jun 2021 16:08:36 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jgg@nvidia.com>
CC:     <aviadye@nvidia.com>, <oren@nvidia.com>, <shahafs@nvidia.com>,
        <parav@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <kevin.tian@intel.com>, <hch@infradead.org>, <targupta@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <liulongfang@huawei.com>,
        <yan.y.zhao@intel.com>, Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 05/11] vfio-pci: include vfio header in vfio_pci_core.h
Date:   Thu, 3 Jun 2021 19:08:03 +0300
Message-ID: <20210603160809.15845-6-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210603160809.15845-1-mgurtovoy@nvidia.com>
References: <20210603160809.15845-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 937e99eb-8048-4a45-7270-08d926a9dbd3
X-MS-TrafficTypeDiagnostic: DM6PR12MB3275:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3275E240BA24D372039E19C1DE3C9@DM6PR12MB3275.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oLZ3XvRoO7LxfbkOnfXqH3i0+/wOi5fHh1CO187iR2EZchQOZnWP1KZnkP7nggW5k6zq+LLzijfeptMND43TRf/ZFC90yqWMVWubHa7WLMIQt+HeKy1lZS7zNlERGsZNS2RyYLdqKXJwmduEs/gJRICByiPG5rdyUcl5p0rdJx1gRxBoQkV3khvhlSYvT8xvdj4M3VYnfcWzGLTOAvJw291YkDEfAPg3K8zSpf+zShav/BIWGVZ6O86/JpmJhgZgFLVWJNP8BsBdzqV9DiBntMACM0LcwWljH/sjbPeOzEeu20f8lBClKrqyThAAReCtEGySx4u7IDISuirPj+jlftyncHEnLwe/iWUrCxFa9Cadatq1CKfYwb0Jmbq8wcUZF2qZfviT4BWqZsYP9FzM1rKi9enWAP9n0NWSzSNyWDcQ9lLPQ0yTY33qf4tZUj24wA9G9aUpriG4EUrnXnumeJTzz5Ljibul1SpqTtLKptD5jzPaDisK+sIAERvJ7OWa03ZJ+Im7EuMj35e+Bf8BsjO9OTv5p44A9BLSsiESpNUbB6JTHPhIV67Onn+UxGPQMm4DMYaqDy0kH1R2R8/AvzTM8DXX2koBOBI6PsKDM3sSxvUytWL5+OtYlWnYCJE7A7F9tHppslIuoWJA8BpYzg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(396003)(136003)(36840700001)(46966006)(70206006)(336012)(70586007)(36860700001)(8936002)(26005)(54906003)(82740400003)(4326008)(186003)(316002)(5660300002)(8676002)(6636002)(86362001)(2906002)(356005)(47076005)(478600001)(7636003)(36756003)(2616005)(110136005)(426003)(1076003)(83380400001)(107886003)(6666004)(82310400003)(36906005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 16:08:42.7849
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 937e99eb-8048-4a45-7270-08d926a9dbd3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3275
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vfio_device structure is embedded into the vfio_pci_core_device
structure, so there is no reason for not including the header file in
the vfio_pci_core header as well.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 1 -
 drivers/vfio/pci/vfio_pci_core.h | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 2d2fa64cc8a0..61cd785c80e8 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -23,7 +23,6 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/uaccess.h>
-#include <linux/vfio.h>
 #include <linux/vgaarb.h>
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
diff --git a/drivers/vfio/pci/vfio_pci_core.h b/drivers/vfio/pci/vfio_pci_core.h
index 9aa558672b83..cb24d229df66 100644
--- a/drivers/vfio/pci/vfio_pci_core.h
+++ b/drivers/vfio/pci/vfio_pci_core.h
@@ -10,6 +10,7 @@
 
 #include <linux/mutex.h>
 #include <linux/pci.h>
+#include <linux/vfio.h>
 #include <linux/irqbypass.h>
 #include <linux/types.h>
 #include <linux/uuid.h>
-- 
2.21.0

