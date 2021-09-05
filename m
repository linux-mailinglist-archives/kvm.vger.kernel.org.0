Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0A1400F82
	for <lists+kvm@lfdr.de>; Sun,  5 Sep 2021 14:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237909AbhIEMKU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Sep 2021 08:10:20 -0400
Received: from mail-mw2nam10on2040.outbound.protection.outlook.com ([40.107.94.40]:39296
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234382AbhIEMKT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Sep 2021 08:10:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bxEbHRA1ARS+UFoHt+Hg/VsnpvY9J+o/LXWOZAgNuGsNw+fBZxoTOkwhoJDXXyop25MZdgFuqOmvikOnw6uZStvqxd/WQWwCtv1+onbWycwDTeOWAGPUxFBIcQGTuMa3vVIOHSXo7A9vbeK9JZT+nK10ghGLyq7dsjNFhPgarGaHwEfbKRzXDzgn9Futbm2Pya9LG2rB+NsXiSDori84oCCMaSaguUItahKq6ip78ejfaU47OL+LllM3wAltY5aDcRnglvel5piYjIj7UlbU6E/uW2SpXCeYqv3I+16gSVXCrfU+0OXa85gxpKIWSu2y1QfSl6yD59nzduCiI37zCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Mb2WmlZMNgMbeujM6Bci8Q0uyaVKPhAjLXC48m9pUmM=;
 b=LFcXAEFE2ivt6PZhSBjw5f6x+10ZKMhr1SQZ5O9eiVxlpQ30rUyDvs2KxQ/d+9I5O7jVVLHxxpy3jB0bqSHUTdWy3WT7x0EzTzDBHrxmJyAFRe7lHSaKmDtosn+Cynt9sg94odATcH5S5cCzhtzNYeQw43+yiLYc/uNLmT4bucengVZpQJNfC/9MbAyqoi3O6jsUdwjUTFeGqWeietHjMf0XxOZMvsQ0dR9Vdccsp5lD5qrfYq91gJs2uud+UbSUOunWaOFUjH/otyQBZxBcciN0ECAXiyiZ1WsDblvJp519XYXimS+OeSLQEvB/H4skAD71DVrOP9VSaZpOXPZb/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mb2WmlZMNgMbeujM6Bci8Q0uyaVKPhAjLXC48m9pUmM=;
 b=s3sxVXXhAt/5mA39SpBqsJu4Lc0RDfv8Yyo8XJzFP9gnxPtDHJqkRImrFWq0zg2HshHPHuR3OGz2gSrESfn67N+nFcijm5oVDqnwWf1ZOB57wqg4lvzhfbOdELYhBOAnuUbiJYnX1gqcmixe9eRNZee7Kb6b4CZOuTfLmcHkF2VieKj8c/gBwQ2oh+5mpmm/93mNjDSnBMBfqBDOc+jqZnn3Z6dng9nedUT2yYi9x8lbC70sAgAixOR94uuzivOu44Os97lEso/7GreDTT/FkiDwL1gtL9thT+V+Gw/2nQVNQcvZD6Os/zf4SXmSdVahrBjBLhyaiT191ru4s4DoOQ==
Received: from BN0PR04CA0048.namprd04.prod.outlook.com (2603:10b6:408:e8::23)
 by BYAPR12MB3144.namprd12.prod.outlook.com (2603:10b6:a03:d6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.22; Sun, 5 Sep
 2021 12:09:15 +0000
Received: from BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e8:cafe::51) by BN0PR04CA0048.outlook.office365.com
 (2603:10b6:408:e8::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17 via Frontend
 Transport; Sun, 5 Sep 2021 12:09:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT046.mail.protection.outlook.com (10.13.177.127) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4478.19 via Frontend Transport; Sun, 5 Sep 2021 12:09:14 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 5 Sep
 2021 12:09:13 +0000
Received: from r-arch-stor02.mtr.labs.mlnx (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 5 Sep 2021 05:09:12 -0700
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <mst@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <kvm@vger.kernel.org>, <stefanha@redhat.com>
CC:     <oren@nvidia.com>, <nitzanc@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 1/1] virtio: add VIRTIO_F_IN_ORDER to header file
Date:   Sun, 5 Sep 2021 15:09:11 +0300
Message-ID: <20210905120911.8239-1-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1e8a740-cdf1-4898-4ce1-08d97065faaf
X-MS-TrafficTypeDiagnostic: BYAPR12MB3144:
X-Microsoft-Antispam-PRVS: <BYAPR12MB31440D150FF663542E23CBD0DED19@BYAPR12MB3144.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ORrc25WaGZYvXbolAPKwf0EG/mTvW4qh2TFY6wP9qeFV7/MLUs1C9q6PQwb3QPOmKZ02nCP33aRTBSFb/rF7VSNRJTMhG27LR96PsVk3eE4VU2/ZVKixHrOSL2V3wSxSNE4VvpYEijrAHiULH+zhp5M9YbspoenC7sD7RCLtwgpdlpO17U3Lhn4DZPjPtSF2qEDs4CS9oNEW11w1h2cPSaNyR2NSTRCFqtA9Q6LBCX65ltLQAGwkMLTjOSie/JAAjiZSdR+yBAMSUvVgWGQVFOTfimeVdQFzidVlmv9vjVF5vRDu6F53SFZf3BlNKpN83o+fFm4cwb18FM6gU5HmGG7i6mo9TGb92z6OEdSFJ/ExawfiETl14FS+X7NqmVENWKo4dHAYSnzA1DNOTf/0CuYSoaDNlfslviR3mHhY8MHZkiNCPel6s716oFBqNo+egAnhMYXVdsNEUg6Vnfn90e38C8IjQAzRa5KKLTfZv7qw5pjE/uoy3G95c5w3BcCC9E+loNfUl9odsoAv6MnGk1+e7/y0GswJQTiYyOmOfgOUrm0Rs3ZqYRnVaSE8B4pbSGLZ3rkFs9EsnJ6h/OW5KvWnpZvcA4JDv/JrYIIJkssPH9nk1ilX33WZdgAV9D6mHN9ouK81960Jj7Gr1BjsS3varddWuvtYmXXPiavWlbOPsoifAOepk1sEtZnGHv7eTOG4dGm5M3ybHPD1sxItHg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(86362001)(83380400001)(426003)(336012)(316002)(356005)(5660300002)(47076005)(82310400003)(2906002)(36860700001)(8936002)(4326008)(1076003)(36756003)(7636003)(70586007)(70206006)(107886003)(2616005)(26005)(508600001)(36906005)(4744005)(186003)(8676002)(54906003)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2021 12:09:14.7657
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f1e8a740-cdf1-4898-4ce1-08d97065faaf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3144
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For now only add this definition from the spec. In the future, The
drivers should negotiate this feature to optimize the performance.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 include/uapi/linux/virtio_config.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
index b5eda06f0d57..3fcdc4ab6f19 100644
--- a/include/uapi/linux/virtio_config.h
+++ b/include/uapi/linux/virtio_config.h
@@ -82,6 +82,12 @@
 /* This feature indicates support for the packed virtqueue layout. */
 #define VIRTIO_F_RING_PACKED		34
 
+/*
+ * This feature indicates that all buffers are used by the device in the same
+ * order in which they have been made available.
+ */
+#define VIRTIO_F_IN_ORDER              35
+
 /*
  * This feature indicates that memory accesses by the driver and the
  * device are ordered in a way described by the platform.
-- 
2.18.1

